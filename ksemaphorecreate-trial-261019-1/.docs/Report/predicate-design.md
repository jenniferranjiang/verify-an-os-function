# KSemaphoreCreate predicate 设计

当前版本 **P1 — review-passed**，manifest SHA256 `cf17462f93b883ac756270977ee6484c105d16260bc9507c7fb1fac6697aff52`。独立结论见 [predicate-review.md](predicate-review.md)。

本次仅设计及审阅。权威源码、配置、闭包与布局证据见 [source-analysis.md](source-analysis.md)。使用当前 `board/stm32f103-nano/config`、Cortex-M3、32 位 ILP32、little-endian、非 SMP。没有沿用或读取历史 trial 产物；根共享库也不是自动认可的证明结论。

## 当前表示与对象归属

`lib/CrtosGlobState.v` 是根共享文件的本 trial 候选：保留全局任务、调度、其他 IPC 类型，只调整 semaphore 分量。每个已登记对象以地址作为生命周期内身份，保存 ID、value、等待任务基址列表；管理链顺序由 `sem_ptr_list` 保存。`semaphore_idmanager` 从唯一对象表和链顺序派生 ID 列表及桶，不再保存第二份 `VarIdmanager`。当前源码中管理链和 ID 桶都头插，删除保持其余顺序，故该派生保留真实桶顺序。空桶的零指针与初始化后空自环由根 `store_idbucket` 的两个具体分支区分。

`lib/SemaphoreInv.v` 的 `semaphore_inv` 覆盖整个模块的 manager、位图、连续桶数组、全局哨兵、已登记对象及等待链。manager 拥有 `IdNode.id` 和 `id.link`，全局 DLL 拥有 `Semaphore.link`，对象 map 拥有 value、padding、pend_list 及等待任务 sched_link。等待任务只查询共用 `task_desc_map`，没有另建任务视图或重复拥有任务字段。源代码的静态 done 已唯一解析为直接调用，不保留 done 结构、状态或内存 predicate。

私有分配态 `sem_allocated` 拥有完整 32 字节未初始化内存；`sem_zero` 拥有清零后的完整对象。当前 QCP `CommonAssertion.struct_padding=emp`，因此两个 2 字节 padding 有唯一的显式 owner `sem_padding`。这不是重复自动 padding。`idnode_private` 保留失败时原 ID 和 link 的精确零值；成功 ID 登记后，剩余 22 字节由 `sem_private_remainder` / `sem_id_registered` 保留，value 赋值和 pend_list 自环后成为 `sem_ready_to_publish`。最终管理链插入交出最后一个 link，合回模块 invariant。失败 x_free 只消费完整 `sem_zero`，不接受已发布对象。

普通对象与等待链复用根 `DLL.DL_Node`、`DLL.dllseg`、`DLL.store_dll`；ID helper 的 canonical spec 使用复用的 `IDNode.store_idmanager` 和 `store_idmanager_allocated_unlinked`。ID 桶沿用根库按连续地址索引的 array spine 及现有 split/replace lemma；静态零桶初始化资源使用 QCP `store_array`。没有为 semaphore 重新写 DLL 递归或添加经验性 NoDup 前置条件。ID 基础表示保留根库已有的位图/ID 唯一性一致性要求。

`store_sem_static_initial` 写明静态初始化来源：manager 常量、16 字节全零位图、16 个零指针桶和已自环的 k_sem_list。`semaphore_initial_state` 为空 map/链；静态资源转入全局共享 invariant 没有新 token。初始化折叠、字节/字段视图切换、发布派生 ID 状态的等价以及更新后等待关系保持是后续实现阶段的证明义务；本次没有将未证明的 lemma 当作已证事实调用。

## 共用临界区与真实 IRQ

`lib/CrtosRules.v` 是根全局协议的候选，所有 DLL、ID、semaphore 空间谓词共享其唯一 assertion carrier。继续提供 `InsideCritical(sg,anchor)` 和 `OutsideCritical(sg,last_seen)`，没有 semaphore 专属 STS。候选在该全局状态机中显式记录实际 Cortex-M3 PRIMASK，并引入处理器 IRQ 的线性权限 `IRQMask(q)`；这不是虚构内存映射地址或纯 Prop。

全局 token 分为锁权限与 IRQ 权限。outside invariant 持锁 token，调用者持 IRQ token。首次 Disable 交出真实 q、关闭 IRQ 并取得共享资源；嵌套调用已有锁 token 时返回真实 1，不重复取得 invariant。Enable 按进入方式归还或保留共享资源，恢复保存位。允许外层入口 q=1，避免把逻辑锁持有方式等同硬件初始位；也允许实际 data_queue.c 的嵌套调用。环境只在 outside 且 q=0 时改变共享状态，不能篡改调用者持有的 IRQ 权限。

实际 QCP `has_tokens` 把 STS 观察设为 empty，而 `state_join` 用交集，组合后会丢失 IRQ 精确观察。候选 `owns_tokens` 在相同载体中把观察设为 full 作为中性项，保留真实状态和线性 token；未修改 QCP 库。

`slice_OS_inv(sg,st,n)` 只组合本次需要的完整 semaphore 模块和实际 uint16 `KTaskOsAssignLockNest` 单元，不冒称完整 OS invariant。未访问的其他模块在调用者 frame 中保留。`n` 是 C 计数，不是逻辑锁深度：`nest_inc` 按模 65536，`nest_dec` 按源码条件递减，65535→0→0 已明确保留。没有添加 nest<65535、入口 IRQ 开启、非 ISR 或空系统假设。

## 抽象操作与检查范围

`lib/KSemaphoreCreate.v` 中 locked 操作覆盖 ID 耗尽失败与成功发布，成功返回最小空闲 ID 并初始化 value/空等待链，仅更新全局 semaphore 分量。外层 `abs_semaphore_create` 把未加锁的 malloc 失败保留为原状态集合，把分配成功后的操作通过全局 `task_atomic_cmd` 提升。嵌套 `abs_semaphore_create_nested` 使用精确当前状态，无额外环境观察。`semaphore_create_nested_result` 同时关联实际计数，区分 malloc 失败与进入临界区后失败。`safeExec` 直接导入 QCP，两种 continuation 的实际 Rocq 类型已检查。

根共享库缺失 `libai` 依赖，且没有可用 `.vo`。本 trial 明确复制必要的根文件到 `lib/`，从当前宏重建缺失的 TaskStatus 纯类型和 delay 到期纯关系，不读取历史 trial。根 `StructFieldOffsetAxiom` 候选只保留纯定义，删除全部旧布局 Axiom。缺失编译产物的九个 QCP 基础模块原样保存在 `vendor/` 并单独编译。所有 load path 只指向本 trial 和当前 `/home/xinra/qcp-binary-democases/Rocq/`，不使用过时的 root `_CoqProject` 外部目录。

本次直接复用 QCP CNotation 的字段寻址符号。当前 ABI 已由真实头文件的编译断言确认；本次未用公理把任意寻址解释强制等同32字节，也未声称已经证明字节与字段模型桥接。后续前端接入需将这一已审阅布局映射到实际符号解释。Rocq 编译证明定义与类型成立，不代表 C 实现正确性。

复现：先 `python3 checks/compile_vendor.py`（仅缺失 QCP 产物首次需要），再 `python3 checks/compile.py`。编译证据保存在 `checks/predicate-compile.log`。当前 revision 的具体哈希以 `checks/predicate-manifest.sha256` 为准，独立审阅记录另行关联该哈希。共享候选没有晋升到根 `lib/`。
