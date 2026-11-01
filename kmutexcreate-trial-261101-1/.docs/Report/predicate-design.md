# KMutexCreate predicate 设计

本次是 `kmutexcreate-trial-261101-1` 全新设计实验。源码、配置、全模块生命周期和 ABI 依据见 [C 分析](c-analysis.md)。本轮只设计与审阅，不启动 QCP symbolic、VC 或 C 实现证明。正式定义在 trial `lib/`；报告不复制定义。当前状态为 review-ready；36个正式/适配Rocq文件均完成coqc编译（exit 0）。独立审阅结论另行记录。固定 revision：`038457b98a07c2fa559a7ec4ea7d63e980af6b73b4a8d8782668ffd97640e036`；文件hash清单见 `checks/predicate-revision.json`，编译结果见 `checks/compile-results.json`。

`MutexState.v` 使用管理链顺序的对象序列作为唯一模块状态，每个对象记录完整的逻辑 payload 与等待任务地址序列。`mutex_manager` 从该序列派生 ID bitmap 集合和哈希桶顺序；它复用公共 ID 模块而不引入第二份独立 manager 状态。`MutexStable` 保存固定全局地址、128 容量和16桶。`holder` 保存指针值，不把它当成任务所有权；递归计数没有额外的非零或不溢出假设。状态可以描述 create、obtain、abandon、delete 访问的全部 Mutex 字段，未把现存对象限制成新建状态。

`MutexInv.v` 的模块内存组合直接复用 `store_idmanager` 和 `DLL.store_dll`。36字节对象中，ID字段[0,2)与ID链接[4,12)由 manager 拥有；管理链接[28,36)由全局管理DLL拥有；其余 val[12,14)、recursive_cnt[14,15)、origin_prio[15,16)、holder[16,20)、pend头[20,28)及padding[2,4)由 `store_mutex` 拥有。pend链中任务 sched_link 的两个指针由等待DLL拥有，任务其他字段仍属于 Task 模块。padding采用当前已存在QCP表示（struct_padding不拥有字节），因此显式保留；没有把[14,16)误作padding。

malloc成功提供完整未知字节数组，memset将36字节全零；`MutexZero` 是这段内存的 typed 私有形态。ID插入前可展开 ID 的零槽并使用已有 `zero_idnode_insert_ready`，其余payload、两个独立节点和padding作为frame。ID成功后 manager 拥有嵌入ID，调用者保留私有payload与管理节点；pend初始化和四个字段赋值后，以 `mutex_created` 的payload交给管理DLL头插，最后重建完整模块不变量。无需为每个字段写入增加命名predicate。

ID失败时现有 API 返回未知值 ID 节点，不能声称仍满足 `MutexZero`。与未修改的私有frame重组 `MutexRaw`，解锁后由本次malloc原始基址调用free；不存在归还协议后又持有ID节点的成功分支。失败资源仍属局部对象，锁操作以frame保留它。

字节↔typed转换、失败资源重组、ID管理器派生状态与头插之间的对应，以及全局 invariant 恢复是后续实现证明义务。文件中的 `mutex_zero_bytes_obligation`、`mutex_reclaim_bytes_obligation`、`mutex_initialization_obligation` 只是经过类型检查的 Prop 陈述，不是已证明 lemma、Axiom 或自动可信结论。其语义根据现有布局与实际分离槽逐字节审查；本轮不把这些命题当作证明前提使用。静态初始化由 BSS bitmap/桶及自环管理链提供，`mutex_initial_memory` 明确这些原始owner，不引入虚构token。模块加入 `os_inv` 后，在系统初始状态采用 `mutex_initial=nil`，其初始化义务与既有模块初始化资源一同交给协议。

`CrtosGlobState.v` 增加 `os_mutex_stable`、`os_mutexes` 和仅替换该分量的 `replace_mutexes`。所有旧构造器保留 mutex 分量；`KTaskWakeup.v` 两个状态更新也保留该frame；其 delay、已知semaphore/msgqueue来源、detached纯关系同步加入mutex相等frame，通用wakeup关系引用新增模块文件 `MutexOps.v` 的 `mutex_remove_waiter_step`，仅摘任务等待成员并保留全部标量/holder。该适配防止新加入分量在旧全局效果关系中变得无约束；不改变旧分量的含义。`CrtosInv.v` 将 mutex等待链纳入全局调度owner互斥/覆盖并组合 `mutex_inv`；`sched_owned_not_waiting` 同步覆盖mutex等待者。其余模块状态和内存没有新假设或行为变化。

临界区复用唯一 `CrtosRules`，没有另建 mutex token 或协议。因为 Assertion carrier 的参数是全局状态，当时为更改状态类型复制了32个共享库副本并同步 import 路径，其中7个只是其他受影响使用者，并非本次规格需要，这部分复制范围过大；原清单见 `checks/dependent-modules.json`，复制前内容和hash保存在 `checks/predicate-baseline/` 与 `predicate-baseline.json`。真正的语义增量限于四个新模块、全局组合和上述frame；其他副本只改逻辑路径。未修改的纯类型库仍直接引用全局库。所有trial映射位于独立 `KMutexCreateTrial.lib` 前缀，避免混用两种Assertion carrier。

`KMutexCreate.v` 的 `abs_mutex_create_locked` 成功分支描述最小空闲ID、头插新建对象并保留其他模块；失败只保证返回-5和锁内状态未变。现有 `IdInsertObj` 复用spec不提供“失败必满”，本次没有加该保证。`abs_mutex_create` 包含锁外malloc失败ret分支和一次原子操作分支；不把入口观察强行等同加锁时观察，不宣称可靠性关系本身提供内存权限。

本次没有新增公理、占位定义或 Admitted。复用 `StructFieldOffsetAxiom.v` 已存在的mutex尺寸/偏移信任接口，实际C证据由双侧ABI静态断言提供；所有既有依赖的信任边界保持原状。本轮编译只检查Rocq定义和已有证明的兼容性，不证明新C实现。

2026-11-01 按用户要求收敛文件范围：本次规格依赖的29个文件（4个新增、25个已有文件适配）保留在trial/lib；另外7个仅供全局回归检查的文件移至checks/review-inputs/lib保留审阅证据。清单见checks/trial-lib-scope.json，原revision路径至归档位置的映射见checks/review-file-locations.json。正式内容未变；当前实际构建仍使用已合并的全局库。
