# Spec 独立审阅

## 当前 r6 定向审阅（2026-10-27）

**`KSemaphoreDelete-spec-r6`：review-passed（设计审阅）**，SHA-256 `7cf1f26315e947a56238ec22e4919c4ab673c62d0eaa05bce3e6701192e980ac`，引用 `KSemaphoreDelete-pred-r4`。
独立 reviewer `locked_spec_review` 核对两份具名 spec 等价、`expanded <= semaphore_waiters` 派生方向正确、两个 caller-local 副本一致及单一函数体。
正式共享类型和展开检查、双规格等价与 C 语法检查通过，见 [检查结果](../../checks/ready-exstatus/two-spec-checks.json)。本次未执行 QCP 派生验证或实现证明。


## 历史 r5 定向审阅（2026-10-26）

**`KSemaphoreDelete-spec-r5`：review-passed（设计审阅）**，SHA-256 `907df74fe9aa9107379dab8ccbb1f4c3f59a5aa51dbfd6c6787c2485070b7faa`，绑定 `KSemaphoreDelete-pred-r3`。
独立 reviewer `locked_spec_review` 在 predicate 通过后核对两处契约与 r4：新谓词展开后文本一致，callee/caller 完全一致，无前提加强、结果削弱或资源变化。
合并后的正式导入、展开等式、C 语法检查通过，见 [检查记录](../../checks/task-wakeup-inv/checks.json)。本次是接口表示调整，不是实现证明。


## 历史 r4 定向复查（2026-10-26）

**`KSemaphoreDelete-spec-r4`：review-passed（设计审阅）**，SHA-256 `8fdb32d1be1c4483df5636a89e494f9a95a11546f9644e7030ce11a940e1a36b`，predicate r2 未变。
独立 reviewer `locked_spec_review` 检查两处契约、原逐步效果、ERROR=1 配置以及空 DLL 表示，未发现设计问题。
新增可直接阅读的 READY/-ERROR 结果与原 steps 一致；空 DLL 具有原前置所保证的非零哨兵，nil 不施加 SUSPEND payload 条件。
父级完成表达式类型、C 语法、声明一致性及可执行文本不变检查，证据见 [检查结果](../../checks/behavior-spec/checks.json)。
本次未运行 QCP parser/symbolic/VC 或实现证明，不能将设计结论当作新契约已被证明。变更说明见 [规格设计](spec-design.md)。

## 历史 r3 定向复查（2026-10-26）

**`KSemaphoreDelete-spec-r3`：review-passed（设计审阅）。** SHA-256 `30f36772f015db545b8e7766ab3fa6c440bbbb4af12a3711e44e0958bdc03562`。
继续引用未修改的 predicate r2。独立 reviewer `locked_spec_review` 核对当前 canonical、caller、共享谓词、源控制流和 23 个 active C 的调用关系；
未发现本次修改的阻塞项。类型、语法、可执行文本与接口一致性检查均通过，见 [检查结果](../../checks/locked-local-spec/checks.json)。

局部资源覆盖队首读取、exstatus 写入、ID 查询和唤醒所需权限；等待 DLL 的纯 payload 给出已登记 SUSPEND 关联。
后置自环哨兵和原精确效果关系保留清空队列及唤醒效果，供 caller 与 frame 组合；完整系统不变量的机器重建证明未在本轮执行。
其余 helper 无需同类修改；Lock/Unlock 保留 InsideCritical/os_inv 交接。
本次是 trial 内规格修订，不是新实现证明。旧 r2 对当前已改契约的适用结论已被本次审阅替代，历史快照仍保留；
原实现 VC 和 controller 状态不作为 r3 证明。详情见 [当前设计变更](spec-design.md)。

## 历史 r2 审阅记录

当前结论：**KSemaphoreDelete-spec-r2：review-passed**，aggregate SHA-256 `1ebdb05ad64fcdabdf6275e5cb21a05c940ef9e9c156b777692713b25d385a9d`。绑定未修改的已通过 predicate `KSemaphoreDelete-pred-r2`（`9cd7d0759ba6015950e7ab63a448998c9daf844c3458396a132544b12e060879`）。r1 的唯一问题 S1 已关闭。此结论为设计审阅通过，不是 C 实现证明。

## r2 定向复查

已核对 manifest 全部 25 个文件 hash 并重算 aggregate，均一致。与 r1 冻结快照相比，仅五个 container caller 及 logic.h 变化；其余 19 个文件内容不变。逐个查看差异，五个 canonical 的公共 Require/Ensure 都未加强或削弱，改变仅为 container declaration 和对应调用；logic.h 仅补已有 ALIGN_SIZE 与 addr_aligned 的 Extern 类型。

四个类型/字段接口检查如下：

- `CONTAINER_OF_IDNODE_LINK`：GetObj 从 store_idnodes/store_idnode 取得同一个 IdNode 的 link 字段关系，接口直接返回该基址，保留字段关系和 emp，不凭空给予解引用内存。
- `CONTAINER_OF_TASK_ID`：与旧全局 get_task_with_idnode.c 接口一致，由 TaskDescriptor.id 字段关系返回原任务；不要求任务已发布或额外对齐，故保留原通用查询范围。
- `CONTAINER_OF_TASK_SCHED`：两处 caller declaration 完全相同，并保留原 m_ktask.h 的对齐前提。LinklistResumeAll 的等待者、RRR 扫描的 ready 成员均由已登记 descriptor map 对应，task_world_wf 提供对齐；字段关系来自 pred-r2 的同一 sched_link_of。没有为满足 API 加新的公开 Require。
- `CONTAINER_OF_SEMAPHORE_ID`：ID manager 成员由 semaphore_manager 派生，给出同一 Semaphore 的 id 字段地址；接口返回该对象，原内存由 caller frame 保存。

四者均为既有 TrustBase 的 CONTAINER_OF 宏适配实例，不是新增已证明 C 函数。原数值 CONTAINER_OF 接口和五个数值调用全部移除，不再要求从通用 manager 或未发布 task 推出无依据的数值布局等式。没有新增 predicate、布局公理或占位证明。

适配后真实 active body 数仍为 23。原 container 边界拆为四个具体接口，加上两项 critical、free、KTASK_ASSIGN 共 8 个边界；其他调用边未改变。读取更新后的 spec-closure.json，并逐个核对五处变更，没有遗留通用 CONTAINER_OF、缺少对应 API 或新的 unresolved dispatch。TASK_SCHED 两个副本一致；其余三接口各有唯一当前调用点，复用 TASK_ID/TASK_SCHED 与原声明含义一致。

复用了本次 23 个 GCC exit_code=0 与 137 个 formal vocabulary Check 的成功证据；新增 ALIGN_SIZE/addr_aligned 均在 Check 文件及日志中。slice_types.h 完全未变，因此不重复 ABI 检查。没有运行 QCP parser、symbolic、VC 或 implement，也没有重做 r1 已通过的未变检查。

S1 关闭，未发现新的 correctness blocker；r1 初审其余结论和模型/信任范围限制继续有效。下一步可按 skill 自动合并并完成根配置一致性检查，然后报告两份明确 revision 等待用户确认；本 reviewer 不将设计通过报告成实现已验证。

## r1 初审记录（历史结论：needs-fix）

审阅对象：`KSemaphoreDelete-spec-r1`，aggregate SHA-256 `a55119c001c37693491918ea2dd89ac2b63bbf766fc3c56f2e2d7edff19d5fa9`。固定 predicate 为已 `review-passed` 的 `KSemaphoreDelete-pred-r2`（`9cd7d0759ba6015950e7ab63a448998c9daf844c3458396a132544b12e060879`）。结论：**needs-fix**，存在下面一个可修复的接口问题 S1。

独立 reviewer 已完整阅读当前 spec guide/experience、设计记录、C analysis/适配闭包、candidate 源码与 ABI 检查记录、两个 header，以及全部 23 个 canonical 文件中的所有具名规格、caller-local declarations 和 active body。核对了 25 个文件的逐文件 hash 并按 manifest 算法重新计算 aggregate，全部一致。只读正式产物，没有运行 QCP parser、symbolic、VC 或 implement。

## 必须修复 S1：统一数值 CONTAINER_OF contract 不足以保持原通用查询规格

`GetObj.c`、`GetTaskWithIdnodeInfo.c`、`LinklistResumeAll.c`、`RoundRobinRemainReadyVectorInsert.c`、`_SemaphoreDelete.c` 都改用同一 `CONTAINER_OF(member, offset)` declaration，contract 只有空资源和返回 `member-offset`。切片传入的 4/104/16/0 与本次适配 ABI 数值一致；问题不是常量写错，而是该数值 contract 未保留原按类型、字段关联所属对象的 formal 保证。

具体受影响的两个通用 canonical：

- `GetObj` 的前置只有通用 `store_idmanager` 与 ID 范围。DLL 节点由 `idnode_link` 关联到 `field_addr(node.idnode_addr, struct IdNode, link)`，并拥有相应 ID/link 内存；这些定义没有提供普适的 `field_addr(base, IdNode, link)=base+4`。当前根库仅在若干具体外围对象布局中给出此关系，没有能从本通用 manager 前置直接取得的独立 IdNode 数值布局前提。因此新 API 返回 `member-4` 后，无法按该接口现有保证把返回值关联回同一个 `IdNodeAbs.idnode_addr` 并取得其 ID 字段资源。ABI 编译检查给出 C 布局证据，不自动成为 Rocq 中的已证等式。
- `GetTaskWithIdnodeInfo/inside_critical` 和 `inside_known` 原有范围允许 task 已在管理链/ID 表、但尚未进入已发布 descriptor map。`task_world_wf.task_wf_aligned` 只给 map 中已发布任务的基址对齐；当前 TaskDescriptor 布局公理 `task_descriptor_field_offset_axiom` 需要这一对齐前提。故它不能对原通用范围直接把 task 的 ID 字段地址化成 `task+104`。旧全局 `get_task_with_idnode.c:12–18` 已有 `CONTAINER_OF_TASK_ID` 接口：由 `id_ptr=field_addr(task,TaskDescriptor,id)` 返回同一个 task，不要求借出 task descriptor。新统一数值 API 没有给出这项保证。

本删除函数实际调用的等待任务已发布且对齐，能够满足更窄调用点的部分桥接条件；这不能代替保留的通用 canonical 本身成立，也不能作为缩窄原通用 spec 的理由。这里指出的是已选择接口与正式前置之间缺少地址关系，不是要求本阶段完成所有布局证明或提前运行 QCP。

最小修复建议：沿 TrustBase 已授权的按类型/字段 CONTAINER_OF 适配，复用既有 `CONTAINER_OF_TASK_ID`；其余实例使用对应 `IdNode.link`、`TaskDescriptor.task_dync_sched_member.sched_link`、`Semaphore.id` 的具体 API/contract，前置写实际字段地址等式，后置返回同一所属对象并保留输入资源。所有 caller-local API 必须与选用边界接口一致，适配记录和边界清单同步更新。也可提交足以覆盖当前全部通用前置的实际 formal bridge 证据，但不得用新的无依据布局公理或加强旧 canonical Require 来消除这个问题。

修复会改变五个 caller 的 API/调用文本及闭包边界名称，应固定 spec 新 revision；已有 predicate 若未改语义，无需重做 predicate 审阅。定向复查 container 字段关系、所有调用实例、边界一致性与受影响的 type/ABI/body 记录即可。

## 其余设计检查结果

**范围与结构。** 从目标沿已读 active body 重新跟随调用，与 `checks/spec-closure.json` 的 23 个真实实现一致；每个函数有唯一同名文件和完整实现。外层 critical/free、container 及 KTASK_ASSIGN 是五类已登记边界。没有遗留 DO_KTASK_ASSIGN、未解析 done dispatch 或裸 IRQ 调用。类型/逻辑 header 只提供类型、extern 对象及 formal vocabulary，没有集中模块 API specs。已复用 candidate 的 ABI/GCC/逐体检查证据；后续差异仅 `where` 的文件不改变该 body 结论。所有 caller-local 具名 contract 与 canonical 对应副本一致；文本一致性不能解决 S1 中接口自身不足的问题。

**目标输入及路径。** KSemaphoreDelete/_SemaphoreDelete 的公开 contract 没有加 `id<128` 或 `id<65536`；formal program 与 uint16 callee 参数共同覆盖负值直接返回、非负模65536查询、未命中、空等待及非空等待。65536 可以命中 ID 0；失败 lazy bucket 初始化不被错误描述成逐字节不变。外层 Require/Ensure 显式保留同一 safeExec continuation 与 OutsideCritical，不把全过程藏在不透明 pre/post。

**锁内唤醒与 frame。** LinklistResumeAll 以完整 os_inv 中已登记 SUSPEND 等待者为输入；不是把任意坏链表上的不退出路径忽略掉。其每轮先写 exstatus=-1，再调用 KTaskWakeup；实际 `_KTaskWakeup` 先摘 sched_link，再取消 delay，再插 ready，源 C 顺序保持。源队列剩余节点、任务未修改字段、Delay 对象和未修改模块都可按 pred-r2 的局部更新重建；InsideCritical anchor 作为未变化资源返还。源码检查中的 NULL 非返回检查仍存在。

**任务与 delay 的复用/特化。** `_KTaskWakeup` 的 not_suspended/wakeup_unified 和 linked/detached×null/inactive/active 六个具名特化均保留；特化只选同一通用 source view、delay 分区并添加对应纯见证，未把节点所有权复制给任务字段。KTaskUnSetDelay 五个具名规格保留原语义。NULL/inactive 原样返回；active 删除 delay.link 并写 inactive，保留 task.delay、ticks/task 和对象内存。all_case_delay 可由现有 delay_world_wf 分情况获得统一局部 view，再将其 post 与 frame 合回；这些推导尚是后续证明义务，没有被宣称为既有已证结论。

**ready 插入及底层 DLL。** RRR contract 描述真实严格时间片比较和 advance_cnt 阈值分支，不要求全桶有序；policy 和外层插入分别描述 highest 与 group 的真实更新。扫描读取使用 task_fields/registered_ready_nodes；新节点使用 occupy_dll_node，只在插入后归 ready DLL。Before/After 的 dispatch_case 覆盖哨兵及普通节点，删除保留 payload、返回自环；ready tail view 支持空桶 tail=哨兵。未发现额外资源丢失或重复拥有。

**ID 删除修正与回收。** `IdRemoveObj/current_node` 的显式修正有源码依据：入口使用查询命中的完整 manager，FreeId 才清 bitmap，RemoveObj 只摘链，最终写 uint16 65535。found_node 与之相同、absent_node 保留未命中路径、known_node 原规格保留。RemoveObj 的无 return 指针签名按真实 C 保持，调用者不使用返回值，spec 没有虚构返回值。目标对象从 ID/管理容器撤回后可重组 pred-r2 的完整 SemaphoreRetired/Raw；`x_free` 只消费这一完整私有块，位于 unlock 之后，不消费仍在共享 invariant 中的对象或内部节点指针。资源桥的实现证明尚未完成，不因此自动拒绝设计，也不把 Prop obligation 当作已证明事实。

**模型与证据限制。** KTASK_ASSIGN 使用当前规则明确给出的 OutsideCritical/safeExec 模型，不能据此声称调度器或汇编实现已证明。CriticalAreaLock/UnLock 沿 TrustBase 接口，局部 frame 不重复进入 primitive contract。137 个声明/投影的 Rocq vocabulary 类型检查、23 个 C 的 GCC 检查和三组 ABI 检查可用作设计证据，均不替代 QCP 实现证明或 S1 的 formal API 保证。

## 后续记录

spec-design.md 首段仍写 draft、末段引用较早候选 hash 和 135 个词汇；当前正式标识应以 `checks/spec-revision.json` 的 r1、25 文件及 137 个词汇为准。作者在修复 S1 时应同步这几处记录。这是报告一致性修正，不另立 correctness blocker。

当前只发现 S1 一个需要修复的设计问题。r1 不得标记 review-passed 或据此合并/进入实现；完成修复并针对受影响部分复查后可推进。本报告不撤销 pred-r2 的通过结论，也不恢复旧 B1。
