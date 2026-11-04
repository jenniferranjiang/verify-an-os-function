# Predicate 独立审阅

结论：**review-passed**。审阅者 `/root/source_review`，作者 `/root/predicate_design`，日期 2026-11-03。本结论仅适用于用户批准的 A1/A2 条件化实验；不是原源码无条件安全结论，不是 spec 审阅结论，也不是实现证明。

固定 revision：`kmutexdelete-predicate-r1`。正式文件 `lib/KMutexDelete.v` 的 SHA-256：`7a4fe9106548d5f07aca0fa278e182b37535b9d346654e7c4d30ae041da63d50`。设计说明为 [predicate-design.md](predicate-design.md)，源码和假设依据为 [c-analysis.md](c-analysis.md)、[source-review.md](source-review.md) 末尾当前有效的用户授权。读取了 skill 的 predicate 指南及设计经验，并对照现有共享定义与原始 C 逐项检查。本次没有修改正式 `.v` 或权威 C。

## 环境范围与原子操作

`abs_mutex_delete` 对负 ID 使用直接返回；其余首先执行原查询临界区，保留到 uint16 的低 16 位转换与未命中分支。成功后的 `abs_mutex_delete_object` 分别执行 drain 与 retire 两个临界区，没有移动锁、删掉解锁窗口、把三个临界区合并，或添加源码不存在的调度调用。

后两次 acquisition 的 `mutex_delete_scoped_atomic` 与切片中具名 `CriticalAreaLock.mutex_live`、`CriticalAreaLock.mutex_drained` 的环境保证一致：分别限制取得锁时的对象登记关系与空 pending 关系。这些合同只适用于用户批准的本次删除调用链，不能由 ordinary Lock 合同推出，也不能全局当作任意调用者都可使用的增强锁保证。`CrtosRules`、共享 STS、原 `RTrans` 和 `OutsideCritical/InsideCritical` 保持原定义；其余状态没有被冻结。

`mutex_delete_live`、`mutex_delete_drained` 自身只是历史关系，没有字节权限；它们没有要求所有 `RTrans=True` 的状态都含有目标对象。A1 的同一分配世代、禁止释放复用约束来自用户明确假设，地址/ID 相等本身不证明没有 ABA。当前状态 guard 是该假设在 acquisition 的必要可观察投影。drain 从实际第二次加锁状态取等待者，retire 从实际最后一次加锁状态保存标量，未沿用较早快照。

设计没有通过排除正常执行取得真空结论：对合法空 pending 对象，原观察本身满足 guard，空 drain 取 identity，retire 具有确定 `replace_mutexes` 后态。合法非空队列有有限、互不重复的登记任务；现有 RRR 插入定义覆盖 advance-count 的两个分支，顺序扫描时可选首次严格较大节点前或尾部插入，delay 更新覆盖 NULL/inactive/active。由此可逐长度构造 drain 后态。此处是陈述正确性的人工审阅依据；`mutex_resume_all_enabled_obligation` 仍只是待证命题，未被当作已证明存在性使用。

## 唯一所有权与实际效果

共享 MutexState/MutexInv 没有被复制。`store_idmanager` 唯一拥有 ID 值、ID hash links、bitmap 和桶；管理 DLL 唯一拥有管理 links；`store_mutex` 拥有标量、padding、pending 哨兵及其等待 task 的调度 links。TaskDescriptor 字段由 task 模块持有，holder 只是指针值。待唤醒 task 的成员关系没有被误用为字段所有权。

`mutex_resume_one` 先设置 exstatus=-1，再引用通用 `ktask_wakeup_step`；该既有关系包含 Mutex 来源链摘除、READY 插入与取消延时。批量效果复用现有 `resume_all_task_map/delays/ready`，保留其他对象、标量与其余全局分量；唯一调度节点归属由 `os_world_wf` 和真实 DLL 共同提供。没有把 semaphore 专属合同改名后假称已经证明 Mutex 场景。

`MutexRetired` 的字节覆盖与 32 位 `Mutex` 布局一致：ID 值 `[0,2)`、padding `[2,4)`、ID link `[4,12)`、val `[12,14)`、recursive/origin 两字节 `[14,16)`、holder `[16,20)`、pending 哨兵 `[20,28)`、管理 link `[28,36)`。ID 已变为 65535，三组链指针各自自环；其参数取最后注销时的对象。等待任务节点已经转移到 ready，既没有遗漏在已释放哨兵上，也没有被计入这 36 字节的 free 资源。

`mutex_delete_restore_obligation` 的左侧是实际完成 ID 和管理链摘除后的 manager、剩余 DLL、拆出的 payload、已脱离 links 与 ID 值，并保留原非 Mutex frame；没有从旧共享不变量直接制造新堆。显式旧地址 `NoDup` 和 manager 等式应在旧资源还完整时导出并跨调用保留；新增 addresses-unique 陈述从 `os_inv` 提取此事实，没有加强公开调用前置。待删除对象的 pending=nil 使注销保持全局调度节点覆盖。解锁归还新共享 invariant，完整退休对象留在本地 frame，按原分配基址交给 free。

初始化沿用既有 `MutexZero`、`mutex_initial_memory` 与创建模型，没有新全局存储或初始化 token。失配/负 ID 路径不释放对象。所有待证 `*_obligation : Prop` 都是有实际内容的命题定义，不是 Axiom、Parameter、Admitted 或可调用的证明事实；新增文件中没有这些占位项。

## 编译证据与边界

已核对 [predicate-build.json](../checks/predicate-build.json)：trial 工作目录使用自己的 `_CoqProject` 与 `KMutexDeleteTrial.lib`，执行 `/home/xinra/crtos/tools/rocq/coqc lib/KMutexDelete.v`，退出码为 0；源文件实际 SHA-256 与记录一致。编译日志为 [predicate-compile.log](../checks/predicate-compile.log)。另外检查了 [logic-interfaces.log](../checks/logic-interfaces.log) 中新增公开符号的 Rocq 类型，主 agent 已报告完整接口检查退出码 0。没有运行 QCP parser/symbolic、生成 VC 或启动实现证明。

主要依赖的当前 hash：`MutexState.v=7a3ee9b6c988603da028aee1fd049ab5c484dfba1f12283a3cc412a653b34f05`；`MutexInv.v=0d64414764c4d2bed396fc2e858bc1cd69df7fe5f5c2b650f4e4df24dad7867c`；`MutexOps.v=104b974d108b89252b30603e9ddec80dc4ce8ced2f5b980ff98271bca40ff5ba`；`CrtosRules.v=9338d39d287890070e3d242fbfc36f8006ff41aec533ec757d32e9769d3de72c`；`CrtosInv.v=83933aad0a8dd5f61d57cb2545b2d8de3d1ca6346758015c80273b0ae59755e8`；`KTaskWakeup.v=6ba940dc1d48be9a5eec40859102a6c79133be70bccc096271aafd482a80d1cf`。共享布局假设沿用既有 TrustBase 范围；没有新增信任公理。

在 A1/A2 和既有共享模型范围内，未发现阻塞 predicate 设计审阅的未解决问题。下一步 spec review 必须固定上述 revision，并保持相同的 caller-scoped 环境合同与源码适配范围。
