# Predicate 独立审阅

## 当前 r4 定向审阅（2026-10-27）

**`KSemaphoreDelete-pred-r4`：review-passed**，SHA-256 `d8996d5d10fe14e0a1a9379b9f9a4bd71235860c232bc324e946913e56dd6e67`。
独立 reviewer `locked_spec_review` 核对类型、原量词式与定义完全相同、中文注释边界准确且无新增假设或资源。
候选与共享根构建均通过，正式共享导入和 eq_refl 展开检查通过；见 [共享构建](../../checks/ready-exstatus/shared-build.json)。结论仅为设计审阅。


## 历史 r3 定向审阅（2026-10-26）

**`KSemaphoreDelete-pred-r3`：review-passed**，SHA-256 `0105ca70df5646e5d1de67673a04aadf2d788e869b96afb89d1cf47fcedf2338`。
独立 reviewer `locked_spec_review` 核对新增定义、基线差异、中文注释和候选编译结果：原三项分离资源与纯条件均保留，没有新增共享状态或完整不变量要求。
合并后共享文件与审阅候选一致；根 KTaskWakeup、KSemaphoreDelete 重编译以及从正式导入路径取得新类型、展开等式的检查通过。
证据见 [检查结果](../../checks/task-wakeup-inv/checks.json) 和 [根构建](../../checks/task-wakeup-inv/root-build.json)。旧 r2 作为未改定义的基线保留；本次未运行 QCP 实现证明。

## 历史 r2 审阅


当前结论：**KSemaphoreDelete-pred-r2：review-passed**，aggregate SHA-256 `9cd7d0759ba6015950e7ab63a448998c9daf844c3458396a132544b12e060879`。r1 的唯一问题 P1 已修复。此结论是 predicate 设计审阅通过，不是 spec 审阅通过或 C 实现证明。

## r2 定向复查

已核对 `checks/predicate-revision.json` 的七个逐文件 SHA-256，全部一致。`SemaphoreInv.v` 相对复制基线仅修正 `semaphore_wait_node` 的节点地址为已有 `sched_link_of task` 并添加相应注释；`CrtosInv.v` 仅改为导入 trial 的 SemaphoreInv。其余五个文件内容与 r1 一致。

等待节点现在与 `ready_task_node` 定义相同，source view 的 `pure_task_sched_link_member` 也使用同一 `sched_link_of`。因此非空信号量等待 DLL、唤醒局部 source view 与 ready DLL 的物理节点地址一致；没有新增别名公理、等式假设或排除非空等待分支。`checks/P1AddressCheck.v` 的两个 `eq_refl` 检查及其 exit_code=0 日志与这一结论一致。

依赖链为 trial `KSemaphoreDelete -> KTaskWakeup -> CrtosInv -> SemaphoreInv`，CrtosInv 中已不再导入旧根 SemaphoreInv。读取了 SemaphoreInv、CrtosInv、KTaskWakeup、KSemaphoreDelete 四个受影响文件的重编译记录，均 exit_code=0；其余三文件沿用 r1 未变证据。没有使用旧版 SemaphoreInv 的编译结果代替修复版检查。

P1 关闭；没有新增需要修复的问题。r1 初审中其余检查与范围限制仍有效，不重复审阅未变内容。可以固定此 predicate revision 进入后续 spec 设计审阅；共享库合并、一致性检查及用户明确 revision 确认仍须按流程执行。本 reviewer 没有启动 spec review、QCP parser、symbolic、VC 或 implement。

## r1 初审记录（历史结论：needs-fix）

审阅对象：`KSemaphoreDelete-pred-r1`，aggregate SHA-256 `429b7de69063a6217c1ed349851fc76f2c166c054893daebd6fb30342e481515`。结论：**needs-fix**。作者为 predicate_design 与 main agent，本记录由独立 reviewer 编写；没有修改正式文件或启动 QCP parser、symbolic、VC、implement。

已逐项核对 `checks/predicate-revision.json` 中六个正式文件的内容 hash，全部一致；阅读了六个文件、TaskInv/CrtosInv 相对 `checks/baseline` 的完整差异、设计报告、C analysis、适配闭包、相关共享依赖与源 C。`checks/predicate-compile.json` 记录六次 coqc exit_code=0，各日志一致；本审阅复用这份类型检查证据，不将其解释为 C 证明。已完整阅读本轮修订的 skill、predicate guide 与 experience；当前 skill SHA-256 为 `b59ac2378ab592770be79f618c5fd1ed6d9d2f8ead77d281e753ea809a73a9bd`。

本轮按更新后的规则先做《源代码处理》适配，再审阅保留的调用闭包。先前 B1 不再是本次 blocker；KTASK_ASSIGN 是已规定模型边界，不要求在本轮证明真实调度及汇编切换。

## 必须修复 P1：信号量等待节点引用了不存在的直接字段

候选 `CrtosInv.v` 导入的根 `lib/SemaphoreInv.v:89–90` 将 `semaphore_wait_node task` 的指针构造成 `TaskDescriptor` 的直接字段 `sched_link`。该结构体实际通过 `task_dync_sched_member.sched_link` 内嵌该节点；`lib/TaskState.v:171–173` 的 `sched_link_of`、`AssignState.ready_task_node`、候选 source views 及 `StructFieldOffsetAxiom.v:160–165` 都使用这个真实嵌套路径。

`store_semaphore` 第 102–103 行把错误节点列表传给 DLL，DLL 按节点指针拥有 next/prev；而 `os_inv` 传入的 `pure_suspend_sched_link` 又要求这些指针等于真实的 `sched_link_of task`。于是每个非空等待节点额外要求“虚构直接字段地址等于真实嵌套字段地址”。现有 ABI 仅规定真实嵌套字段偏移 16，不提供这个虚构别名；QCP `CNotation.v` 的 `->ₛ` 是一般 `LE_arrow_field` 构造，没有 TaskDescriptor 的重写特例。即使该额外等式让某些逻辑模型可满足，也没有 C 布局依据，不能用于本次源码对应结论。

这会直接影响有等待者的删除路径：等待 DLL 不能以有源码依据的方式拆成 `store_ktask_wakeup_sched_pre`，也不能把链指针转给 ready DLL。创建实验中的空 pending 不会实例化这个错误节点，这可以解释既有创建相关检查为何未暴露它；不能因此沿用到本轮非空路径。

修复范围可以保持很小：将所属 `SemaphoreInv.v` 复制到 trial，仅把该节点指针改为已有 `sched_link_of task`（或相同真实嵌套字段），调整 trial 的 CrtosInv import 和必要依赖，保留原其余定义。不要新增字段别名公理、增加调用者等式前提或排除非空 pending。重新编译受影响文件并固定新 revision；复查该节点构造、semaphore→source view→ready 的地址一致性和依赖引用即可，不必重做未改变的整个设计。

本次所读错误依赖 `lib/SemaphoreInv.v` SHA-256 为 `64455cd3c4448245365eb450481aa37c7e616e89e5ba29ed721d50147afb6c77`。由于它不在 r1 的六文件清单内，新 revision 应把修复后的文件及对应复制基线纳入清单。

## 其余已完成的设计检查

**TaskInv 的新增 SUSPEND bitmap 条件有实际用途和生命周期依据。** 原 RUNNING 条件不能推出 SUSPEND 的 mask；唤醒源码直接 OR 原 bitmap_column，必须维持它与 cur_prio 的对应。Startup 的 `__BitmapSiteMask`、Suspend 从 READY/RUNNING 转入并保持 mask、PrioSet 对 SUSPEND 同步重算，给出了正常生命周期依据。新增条件没有排除大 ID、合法等待顺序或未命中路径；INIT 保持不受该条件约束。保持性尚未证明、旧 task_world_wf 构造者须重编译，报告对此披露准确。没有把这种尚待证明的保持性当作无条件已证事实。

**局部 owner 分工未见新增重复或遗漏。** task_fields 只借出 descriptor map/stack 与 ID manager，任务管理链、自持节点和函数表留在 frame；等待/ready DLL 只持有调度 link，其纯 payload 不拥有描述符。单桶变换可在 assign_ready_pending 的 raw 视图中表示，不错误要求更新 group/highest 前就恢复稳定 assign_inv。全局 exstatus 是独立槽，不与任务 exstatus 重复。`CrtosInv` 的唯一 formal delta 是 TaskInv import，原 os_sched_owners coverage 及所有分量均保留；本轮实际访问的 task、semaphore、delay、ready、ID、DLL 权限都有对应 owner，P1 是其中具体地址错误。

**RRR 与 delay 的效果符合源 C。** `rrr_scan_insert` 在第一个 rest_timeslice 严格更大的节点前插入，无匹配则尾插；advance_cnt≥1 直接尾插，不无依据要求桶全局排序，也不虚构计数更新。policy 阶段保留 group、更新 highest，完整插入随后用原 bitmap_column 做 OR。registered_ready_nodes 保证扫描节点可在 map 找到 descriptor，`None` 的总函数分支不作为真实合法扫描行为使用。取消 delay 分清 NULL、inactive、active，active 精确删 DLL 项并转入 inactive map，保留 task/ticks/指针及其他状态。

**KTaskUnSetDelay 恢复接口与旧 annotated C 展开一致。** 旧 body 的 active 展开借出 `task.delay` 槽、delay payload 和剩余 DLL frame；候选 pre 用完整 DLL 表达同一资源，可沿公共 DLL split 取得旧展开。post 返回剩余 DLL、改为 inactive 的同一 payload 和自环 link。inactive 的未访问 link 没有从 caller frame 消失；NULL 保持原指针槽。`delay_nodes_wf(prefix++suffix)` 可由既有 StronglySorted/Forall 的删除保持性取得，并非凭空要求不可达排序。合回 delay_inv 与更新 map 的证明仍是后续义务。

**删除 program 覆盖本目标的主要分支。** 负 ID 直接 ret，不伪造加锁；非负值按 uint16 模 65536 查询；未命中保持抽象对象序列，同时允许 lazy bucket 的具体形态变化。命中按原顺序写 exstatus=-1、取消 delay、变 READY 并插队；pending 后缀同步更新，再注销信号量；resched 等于原队列非空，最后才接规定的调度模型。对象和 ID 的唯一性由既有 manager/DLL 分离及总 coverage 支持，不额外添加不必要的 NoDup。合法等待者为已登记 SUSPEND，因此有限 resume relation 不把坏链表上的无限循环冒充成功。

**退休对象资源完整，待证命题没有冒充证明。** SemaphoreRetired 包含 ID=65535、原 value、padding、ID link/管理 link/pend 哨兵自环，私有资源可独立穿过 unlock；剩余全局状态已注销目标。`store_idnode` 本身只持 ID 标量，故与 ID link 自环组合不重复。退回 SemaphoreRaw 的声明是 Prop definition，未被声明为公理或已证 lemma；六个候选文件没有新增 Parameter/Axiom/admit/Admitted。桥接、循环保持和全局不变量重建在实现阶段仍需证明，不能被本次设计审阅替代。

## 范围和后续门禁

当前根 `MsgQueueInv` 明确未纳入所指 msg_buf 的缓冲区内容；CrtosInv 注释也保留这一既有范围限制。本次删除及其适配闭包不读写该缓冲区，且修改不丢弃任何原有 frame，因而本报告不由这一未触及资源推导出必须重写消息队列模块。但本次不得把 os_inv 或 predicate 审阅扩大宣称为“整个 OS 所有模块内存均已完整验证”。本轮结论仅针对已描述的共享资源及删除操作的实际 footprint；根共享库的全局完整性限制仍需保留。

本次发现一个需要修复的正确性问题 P1，没有把未完成 lemma 或旧 B1 当作额外 blocker。P1 修复并完成受影响部分复查前，r1 不能用于正式 spec review，也不得合并全局库或进入 implement。此 `needs-fix` 是可修复的候选设计问题，不是无法消除的源码 blocker。
