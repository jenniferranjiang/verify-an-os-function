# KMutexDelete predicate 设计

设计对象是当前权威 `kernel/thread/mutex.c` 的原始 `KMutexDelete`，按既有非 SMP、32 位验证配置处理。本次新增正式定义集中在 `lib/KMutexDelete.v`，直接导入根 `CRTOS_Verify.lib.KTaskWakeup`、`MutexInv` 与既有全局状态、临界区模型；没有复制或修改整套 Mutex/Task 定义。源文件、配置和前期反例见 [c-analysis.md](c-analysis.md) 与 [source-review.md](source-review.md)。

用户已明确批准排除两条错误触发交错。本设计仅在 A1（同一分配对象从查找命中到注销不被他人删除、回收或复用）、A2（排空后至注销无新 waiter）下成立。源码缺陷仍存在，拟议修复补丁未应用。A1/A2 不要求整个 OS 状态不变，不冻结 mutex 的值/holder/递归计数/优先级；每次重新加锁必须使用新的当前对象值。TrustBase 文件没有被修改。

## 已复用的资源与所有权

| 对象或字节 | 正常共享状态的唯一 owner | 删除过程 |
|---|---|---|
| ID manager 字段、bitmap、hash bucket、每个 Mutex 的 ID 值和 id.link | `store_idmanager`，由 `mutex_inv` 组合 | 查询借还；注销清 bitmap、摘 hash link、ID=65535，节点成为局部资源 |
| k_mutex_list 哨兵及每个 mutex.link | `store_dll (store_mutex wait)` | `DoubleLinkListRmNode` 返还 payload 与自环管理 link |
| Mutex 的 val/recursive_cnt/origin_prio/holder、两字节 padding、pend_list 哨兵 | `store_mutex` | 三次临界区分别重新取得资源；最后恢复为 `MutexRetired` |
| 挂在 pend_list 中的 task.sched_link | Mutex 的等待 DLL | ResumeAll 唤醒时转到 ready DLL，不随 Mutex 一起 free |
| TaskDescriptor 的 exstatus、status、ID、其他字段 | 共享 Task 谓词 | exstatus=-ERROR，wakeup 改 READY；其余字段精确保留 |
| task.delay 指向对象与延时链/表 | `delay_inv` | 复用 active→inactive / inactive / NULL 三种取消延时行为 |
| ready 队列与缓存 | `assign_inv` | 按原等待队列顺序执行既有 RRR 插入关系，不简化为集合并 |
| 其余模块与所有未触及资源 | 原 `os_inv` 的 frame | 每次恢复；没有从指针值或历史快照凭空取得字节权限 |

ID、管理链、等待链都有独立所有权；一个 Mutex 的 holder 仅是字段值，不让 Mutex 谓词拥有其指向的 Task。`MutexRetired` 只含本对象全部 36 字节，包括 ID 和三对自环链指针及 padding，不含已经唤醒的 task 节点。最终用原分配基址转为已有 `MutexRaw`，交给受信 allocator 接口。初始化沿用 `mutex_initial`、`mutex_initial_memory`、`MutexZero` 与根库创建模型，没有本次新增的全局存储或初始化 token。

## 三个真实临界区与环境假设

`abs_mutex_delete` 保留原流程：负 ID 直接返回；普通加锁查询，未命中后解锁返回；命中后把内部 `(address, uint16 ID)` 传给 `abs_mutex_delete_object`；后者顺序组合 `abs_mutex_resume_all` 与 `abs_mutex_retire`。没有将三个临界区压成一个原子操作，也没有凭空加入 `KTASK_ASSIGN`。非负 int32 ID 保留低 16 位转换，顶层不加强成 `id<65536`。

`mutex_delete_live`、`mutex_delete_drained` 是历史状态关联，自己没有空间 footprint，也不是“以后永远存在”的证书。`mutex_delete_scoped_atomic` 只在这两个后续 acquisition 中选取满足对应守卫的当前状态，正常与错误行为均受同一守卫限制。解锁后的状态集合仍使用原 `Crtos_RTrans`，原 `OutsideCritical`、`InsideCritical` 和 `os_inv` 不变。它不要求对 `RTrans=True` 的所有状态证明对象存在，因此不会用不可满足的全称前提造成 vacuous success。

相匹配的 C 接口是 `CriticalAreaLock` 的本次调用链限定环境合同 `mutex_live` 和 `mutex_drained`。它们依赖用户的 A1/A2，**不能从 ordinary lock 合同推出，也不能在其他调用者中任意选用**。普通共享 lock 的信任范围没有被悄悄变成“所有对象都保活”。守卫中的地址/ID 是同一对象的可观察投影；先释放、再在同地址和 ID 重建的 ABA 执行仍由 A1 明确排除，单凭这两个数字相等不能证明世代相同。其余 OS 分量与对象标量仍可变化。

## 唤醒、注销与 frame

`mutex_resume_all_effect` 是整个实际 drain 队列的公开效果，使用共享 `resume_all_task_map`、`resume_all_delays`、`resume_all_ready`；目标等待队列最终为空，其他对象与标量保持。本次等待序列取自进入 drain 临界区的状态，不承诺 lookup 时看到的队列不变。循环内部的 `mutex_resume_one` 直接使用通用 `ktask_wakeup_step`，`mutex_resume_all_steps` 仅供将迭代效果连接到整体效果；没有把 mutex 版本声称为 semaphore 专用合同的特化。

退休前又按真实源码取得锁，读取当前对象 ID 并保存当时标量。A2 只保证此刻仍为空队列；`MutexRetired` 的参数必须是这次取得锁时的对象，而不能使用较早 drain 的标量快照。`mutex_delete_unpublish` 更新唯一对象序列，ID manager 与管理 DLL 都从同一序列派生。

`mutex_delete_split_obligation` 与 `mutex_delete_restore_obligation` 复用已有 `mutex_create_frame` 的精确非 Mutex footprint，避免再定义一份同义全局 frame。恢复陈述的左侧明确要求 C 操作完成后的 manager、剩余管理 DLL、拆出的对象 payload 与自环节点；它不是把旧 `os_inv` 直接转换成新内存。manager 删除等式和旧对象地址唯一性必须在旧资源仍完整时导出并跨调用保留，不能仅从删除后的资源反推旧状态没有重复对象或 ID。

## 非真空与路径覆盖

两个环境守卫并不要求整个状态不变，但都允许“环境没有介入”这一合法执行。对已登记、空 pending 的对象，可以在后续 acquisition 选择当前观察；drain 的空分支是 identity，随后注销选择 `replace_mutexes` 的确定后态，因此成功删除路径不是由不可满足的前提排除。负 ID 的 ret 和未命中的查询也各有正常行为。

对合法的有限非空 pending，Task 与等待 DLL 提供已登记 SUSPEND 队列和不重复节点，ready invariant 提供原桶节点的有效描述符；既有 RRR 插入关系按 priority/advance_count/timeslice 的实际分支可以选择一次插入的后态，延时取消按 NULL/inactive/active 选择确定更新。按队列长度迭代得到批量后态。这里给出设计层面的构造依据；`mutex_resume_all_enabled_obligation` 和 steps/effect 的连接仍须后续正式证明，不能把该 Prop 定义本身当作存在性证明。

## 设计义务与状态

正式文件末尾的 `*_obligation : Prop` 是可类型检查的待证陈述，包含退休到 Raw、循环到批量效果、manager 一致性、非真空正常后态、模块 split/restore 及批量唤醒后 world 一致性。它们不是公理或已经证明的 lemma，未以这些 Definition 充当证明事实。没有手写 `Admitted`、`Axiom`、`Parameter`，也没有执行 QCP parser/symbolic、VC 生成或 C 实现证明。

Rocq 编译使用 trial 自己的 `_CoqProject` 与独立逻辑路径 `KMutexDeleteTrial.lib`，未改共享逻辑前缀；编译日志为 `../checks/predicate-compile.log`。predicate revision、SHA-256 与最终 compile exit code 在 `../checks/predicate-build.json` 固定。此文件由作者提供设计输入，最终 predicate 是否 `review-passed` 由独立 reviewer 另行记录。
