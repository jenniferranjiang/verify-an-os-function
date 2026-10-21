# Predicate 设计

本 trial 根据当前 `Ubiquitous/XiZi_IIoT_Macro`、stm32f103-nano 配置和本轮 C analysis 重新设计。证据见同目录源码分析记录及 `checks/abi-check.log`、`checks/slice-abi-check.log`。没有读取其他 trial。这里只设计并类型检查，不证明 C 实现。

`shared_candidates/SemaphoreState.v` 保存对象的地址、ID、value 和等待任务地址顺序。模块状态是按全局链排列的对象序列；bitmap 的 ID 集和 hash 桶都是该序列的派生值，不增加第二份权威对象集合。创建、删除的头插/摘链使每桶顺序等于管理链按 ID hash 过滤的顺序。等待节点由当前任务的 sched_link 派生，不复制任务描述符。

`SemaphoreInv.v` 复用当前 `IDNode.store_idmanager`（包含零桶或已初始化空桶）和 `DLL.store_dll`。ID manager 拥有 ID 的2字节及ID link的8字节；全局管理DLL拥有对象管理link的8字节；其payload拥有value的2字节、pend哨兵的8字节和4字节padding，合计32字节。等待链只拥有任务sched_link，任务字段仍归统一task_inv。没有添加NoDup要求。`CrtosInv.os_sched_owners` 加入等待任务列表，沿用原覆盖条件以确保一个任务节点只有一个容器拥有。

| 阶段 | 唯一 owner | 资源交接 |
|---|---|---|
| malloc成功 | SemaphoreRaw | 全32字节未知值、非NULL和4字节对齐 |
| memset后 | SemaphoreZero | 全32字节清零，未发布 |
| ID分配失败 | SemaphoreZero、原manager | 没有字段修改；x_free消费完整私有对象 |
| bitmap分配后 | store_idmanager_allocated_unlinked、AssignedIdNode及私有余部 | 位图改变但尚未成桶；不能过早折叠稳定manager |
| ID插入后 | 更新manager、私有对象余部 | manager接管ID字段和ID link；pad不随ID转移 |
| 成功发布 | semaphore_inv | 初始化value/pend后，管理DLL接管管理link和对象payload |
| 出临界区 | OutsideCritical | 共享内存及nest=0交还协议，调用者不再持有对象 |

QCP 当前 `struct_padding` 为 `emp`，故4个实际padding字节由明确CharArray拥有；未重复计算自动padding。C ABI证据检查struct32及所有字段offset，`SemaphoreLayout`保留对应的纯Rocq陈述，未作为公理或已证事实使用。私有对象的memset/free contract按批准语义精确覆盖该布局。

统一临界区仍只有 `TrialShared.CrtosRules` 的一个 QCP CriticalSTS 实例。候选 `CrtosGlobState` 保存 semaphore 及其他 OS 数据，不保存硬件中断状态。`OutsideCritical sg st` 表示尚未进入共享协议；`InsideCritical sg st` 表示持有临界区 token。二者只附带 `os_global_context`，不解释 PRIMASK 的取值。

`CriticalNest` 独占当前源文件的 uint16 `KTaskOsAssignLockNest`。Disable 将协议资源和 nest=0 交出；CriticalAreaLock 写1；CriticalAreaUnLock 减0并由 Enable 归还资源。非SMP源码的 Unlock 没有额外 Disable。进入/退出仍是必须验证的真实 C 函数，不列 trusted。删除中断状态后，环境转换关系为 `True`，保留此前对 OS 数据的宽松关系；`LastSeen` 沿用该 rely，不要求加锁观察等于入口状态。候选统一采用 Arch32 LittleEndian，与 Cortex-M3 配置一致。中断保存、关闭及恢复不在本次模型范围内。

`lib/KSemaphoreCreate.v` 的程序选择真实的malloc提前失败（不虚构锁观察），或一次原子锁内操作。锁内失败要求ID空间已满且共享状态不变；成功要求最小空闲ID，并仅在semaphore分量头插value=实参、pend为空的新对象，其他模块保持。程序使用QCP现有safeExec，未重新定义它。

初始化资源在 `semaphore_initial_memory` 给出：manager常量字段、16个零bitmap字节、32个零pointer槽、全局自环头；稳定初态为空对象序列。不新增启动token。该内存由C静态初始化建立，交给统一协议时折叠为初始semaphore_inv；这项空间转换及后续拆合是后续实现证明义务，本设计不把它们声称为已证引理。

候选文件是当前共享库必要依赖闭包：20个现有文件因统一Assertion carrier需要重编；只在CrtosGlobState/CrtosRules/CrtosInv作语义扩展，其余主要改逻辑import并沿用原定义/证明。新增SemaphoreState/SemaphoreInv和函数程序。根共享lib未修改。当前共享的StructFieldOffsetAxiom等既有基础假设仍被导入；没有新增Axiom/Parameter/Admitted。现有任务/其他IPC模型的未触达frame不在本次宣称获得新证明。

构建使用本trial `_CoqProject` 的独立 `TrialShared`、`KSemaphoreCreateTrial` 前缀，只映射当前共享lib、vendor、QCP库和本trial。为导入现有safeExec，trial vendor复制当前根vendor的Monad/MonadErrBasic及当前QCP的MonadErrLoop/MonadErrHoare/monadesafe_lib；无历史产物。编译日志为 `checks/predicate-compile.log`，构建脚本为 `checks/build_predicates.py`。

状态：2026-10-21 按用户要求移除中断状态建模，旧 `predicate-r1-8a944cddeb13` 审阅结论对当前版本失效。本次为修改后的设计及编译检查，不宣称新的独立审阅或 C 实现证明。变更和检查见 [DCHG-20261021-01](design-changes/2026-10-21-1-remove-irq-state.md)。
