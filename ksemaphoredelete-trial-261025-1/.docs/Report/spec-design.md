# KSemaphoreDelete 规格设计

## 当前 r6：同时保留封装版和展开版（2026-10-27）

按用户要求，在 LinklistResumeAll 的同一真实函数体上保留两个具名规格：`semaphore_waiters` 使用新纯谓词，`semaphore_waiters_expanded <= semaphore_waiters` 展开同一条件。
两版前置、效果关系、资源和结果语义相同；_SemaphoreDelete 中两份声明同步，现有调用继续选择 semaphore_waiters。
当前 `KSemaphoreDelete-spec-r6` 绑定 `KSemaphoreDelete-pred-r4`。独立复查及 [双规格检查](../../checks/ready-exstatus/two-spec-checks.json)确认展开版与 r5 一致、封装版展开后相同、callee/caller 一致且可执行文本未改。
新的纯谓词已同步共享库，正式导入类型检查和两份 C 语法检查通过。未运行 QCP parser/symbolic/VC 或实现证明，不宣称双规格的工具派生 VC 已证明。


## 历史 r5：按模块接口描述前后资源（2026-10-26）

`KSemaphoreDelete-spec-r5` 引用已通过的 `KSemaphoreDelete-pred-r3`。LinklistResumeAll 及 _SemaphoreDelete 中对应声明的前后条件统一使用 task_wakeup_inv，
避免逐项列出任务字段、延时和就绪队列。返回值、READY/-ERROR 结果、精确 steps 与等待链从 waiting 到 nil 的变化均保留。
logic.h 新增一个对应的 Extern 声明；其余 C spec 与可执行代码不变。
展开新谓词后两处完整契约与 r4 忽略空白一致，见 [等价检查](../../checks/task-wakeup-inv/spec-equivalence.json)。
新共享定义已经合并并重新编译，trial 仍使用原共享导入；独立设计审阅、正式路径的类型检查及 C 语法检查通过。
本轮未运行 QCP parser/symbolic/VC 或实现证明；函数行为和资源语义未改变，已有证明能否接入新表示仍须正式 workflow 检查。


## 历史 r4：直接表达全部唤醒的结果（2026-10-26）

`KSemaphoreDelete-spec-r4` 定向设计审阅通过，仍使用未修改的 predicate r2。
用户指出 r3 的整体行为不直观，因此在两个 `semaphore_waiters` 中用 `before` 命名前态、`waiting` 命名原等待任务序列；
后置显式说明原序列中每个任务在 after 中均为 READY 且 exstatus=-ERROR，队列资源前为 waiting、后为 nil。
这项纯结果由原逐步关系的状态更新支持：每轮置 READY/-1，其他任务描述符不变，后续轮只能选 SUSPEND，不能再次改变已唤醒任务。
原 `semaphore_resume_all_steps` 保留，以约束取消延时、ready 插入、处理顺序和未修改状态。
空 DLL 的非零条件来自前置 DLL，nil 无 payload，故其 pure_suspend 参数不要求已唤醒任务仍为 SUSPEND。
没有新增资源包装、Rocq 定义或 Extern，也没有改变 C 执行代码。

检查及差异见 [行为规格检查](../../checks/behavior-spec/checks.json) 和 [r3→r4 差异](../../checks/behavior-spec/changes.diff)。
量化结果与空 DLL 表达式的 Rocq 类型检查、两份 C 的 GCC ILP32 语法检查、caller/canonical 文本一致性检查均通过。
独立 reviewer `locked_spec_review` 完成定向复查；这不是 QCP parser 检查或 C 实现证明，量化结果的形式推导和实现验证仍待后续完成。
本次仅更新当前 trial，历史证明输入不变；r3 对当前文本的审阅结论由 r4 取代。
当前 aggregate SHA-256 为 `8fdb32d1be1c4483df5636a89e494f9a95a11546f9644e7030ce11a940e1a36b`，快照为 `checks/revisions/KSemaphoreDelete-spec-r4/`。

## 历史 r3：锁内局部资源契约（2026-10-26）

`KSemaphoreDelete-spec-r3` 已完成定向设计审阅，继续使用未修改的 `KSemaphoreDelete-pred-r2` 及迁移后的共享定义。
本次按用户要求更新当前 trial；共享 canonical、历史 controller 输入和 VC/proof 不在本次修改范围。

检查 23 个 active C 的适配后调用关系后，只有 `LinklistResumeAll/semaphore_waiters` 及 `_SemaphoreDelete` 中的同名声明需要调整。
移除 `anchor`、`InsideCritical` 和完整 `os_inv`，改为直接组合现有 `task_fields`、`delay_inv`、`assign_ready_pending` 与带 SUSPEND 关联的等待 DLL；
保留 `os_global_context`，为 callee 提供全局地址绑定。前置的 task_fields 已含任务登记、优先级、bitmap 和对齐条件，不重复列出。
后置返还更新后的三个模块 view 和空等待链哨兵，原 `semaphore_resume_all_steps` 精确效果关系保留。
`logic.h` 仅新增现有 `map`、`pure_suspend_sched_link`、`semaphore_wait_node` 的 Extern 声明，没有新增或修改 Rocq predicate。

其余锁内 helper 已采用局部契约，不机械重写；外层 Lock/Unlock 的协议接口保持。
调用者保留锁 token、信号量管理资源及其他模块资源，在解锁前重建完整不变量。
等待节点向 ready 队列迁移后的跨队列归属、task map 对其余谓词的影响和 ready 一致性仍须在实现阶段证明。
本次没有运行 QCP parser/symbolic、生成 VC 或重证实现；旧 whole-os_inv 契约的证明输入不适用于新契约，
受影响的 `LinklistResumeAll` 与 `_SemaphoreDelete` 实现 run 需要通过正式 workflow 更新输入后再验证，不能沿用旧接纳状态宣称新契约已证明。
未修改的 FreeId、IdRemoveObj 和入口包装的既有模块化证明不因此被宣称失效或升级为闭包完成。

验证记录见 [局部契约检查](../../checks/locked-local-spec/checks.json)，修改前快照与差异在同目录。
新增三个名称的 Rocq 类型检查及三个受影响 C 文件的 GCC ILP32 语法检查通过；canonical/caller 契约逐字一致，可执行文本未变。
唯一 GCC warning 是嵌套锁适配后原有的闲置 `lock` 变量。
当前 revision 包含 25 个 C/header，SHA-256 为 `30f36772f015db545b8e7766ab3fa6c440bbbb4af12a3711e44e0958bdc03562`；快照见 `checks/revisions/KSemaphoreDelete-spec-r3/`。

## 历史 r2 设计记录

本记录对应 `KSemaphoreDelete-spec-r2`（review-ready），固定已通过的 `KSemaphoreDelete-pred-r2`；formal contract 均直接写在同名 canonical C 定义上，不在本报告重复。r1 独立审阅发现的 S1 已在本轮修改，等待针对 S1 的独立复查，不自行声明 review-passed。

本轮按更新后的《源代码处理》先适配源码，再确定 23 个保留函数体的范围。`KTASK_ASSIGN` 为文档规定的模型边界，外层锁、解锁、`x_free` 和 `CONTAINER_OF` 为已有信任边界。具体来源、适用配置和每项变换见 [适配后闭包记录](adapted-closure.md)。真实调度及上下文切换汇编没有在本轮被证明，也不把其源码假冒为模型函数体。

## 目标行为与资源交接

目标及 `_SemaphoreDelete` 接受完整 int32 输入。负 ID 直接返回，非负 ID 由真实 uint16 形参转换后查询，因此 65536 查询 ID 0，不把大 ID 一概处理为失败。查无对象时退出锁；lazy bucket 从零变为自环可由相同 manager 抽象状态容纳。

命中后按真实等待链表顺序逐个处理任务：先把该任务 `exstatus` 写为 -ERROR，再摘除 sched_link，清理它仍活跃的 delay，设置 READY 并按当前 RR_REMAINSLICE 策略插入对应 ready bucket。Delay 对象、其 ticks/task、task.delay 指针和不涉及的任务字段保持。所有等待者处理完毕后删除 ID、将 uint16 id 字段写为 65535、摘除信号量管理链，重组完整私有 SemaphoreRaw。退出锁后该内存由 `x_free` 消费；仅原来存在等待者时执行文档规定的调度模型。

锁内 helper 删除嵌套 critical/IRQ entry/exit，保持外层 critical 资源作为 caller frame。顶层 spec 使用现有 OutsideCritical/InsideCritical 协议和具名 abstract program；helper spec 使用 ID manager、任务字段、延时和 ready-vector 的模块表示。没有为顶层要求额外 `id<128`，也没有用理想 bitmap 值替换实际 `bitmap_column` 字段效果。

`LinklistResumeAll` 的合法输入来自实际系统 invariant：每个等待节点属于已登记的 SUSPEND 任务，任务 ID 与管理器一致。此范围不是假设任意损坏链表都能退出。NULL_PARAM_CHECK 在切片展开为失败无限循环；没有把检查失败改成正常 return。调试打印可按 TrustBase 去除。

## 已有 spec 的导入与变更

所读全局 annotated C 及类型/spec header 的复制时基线保存在 `checks/spec-baseline/`。`GetObj`、`IdGetObj`、`RemoveObj`、任务状态读写、GetTaskWithIdnodeInfo、KTaskWakeup、ready 插入均从已有 canonical/interface spec 提取；_KTaskWakeup 的两个基础行为和六个 delay/sched 特化、KTaskUnSetDelay 的五个具名行为均保留。原 `libai` 源缺失，不能引用不存在的模块；本轮以共享库实际定义与原 annotated C 中已展开的资源含义补齐 semantic vocabulary，新增证明义务不会被当作历史证明。

DLL 的 payload-preserving 通用成员删除和自环删除保留；Before/After 采用已有 `dll_insert_*_dispatch` 纯列表效果。Init 使用原 pointer-slot 初始化规格。被选中的 caller-local declaration API 来自相同 canonical 文本，避免各调用者各自发明不同后置条件。每个切片只保留本函数真实函数体。

原 `m_id.h` 的 `IdRemoveObj/current_node` 不适合作为正常删除接口：其前置 `store_idmanager_remove_ready` 描述 bitmap 已清的中间状态，与 IdRemoveObj 第一项 IdGetObj 的普通 manager 前置不一致；其后置 `store_idmanager_removeobj_post` 仍拥有旧 id 值，遗漏 IdRemoveObj 最后一项 `idnode->id=-1`。本轮明确修正 current_node 为查询命中对象的 found view，并在出口保留 id=65535 的分离节点；新增同义 found_node 供本闭包选择。`known_node` 保持原文，新增 absent_node 表达查无对象的早返回。此修改属于已存在规格的语义修正，不能复用旧 current_node 的证明结论。已搜索原全局树，没有该具名规格的调用点。

原 `m_id.h` 将 RemoveObj 声明为 void，但权威 id.c 的返回类型是 `struct IdNode *` 且实际无 return。本切片恢复真实签名和函数体；其唯一调用者丢弃返回值，spec 不对返回值作承诺。不额外写 return，不以缺失返回值产生新的算法效果。

## 检查与后续义务

类型头只包含本闭包所用 ABI 类型/常量和 extern 全局对象，不包含模块集中 API spec。TaskDescriptor 保留全部前置字段；event 两个位域依 TrustBase 展开为 uint32。`CONTAINER_OF` 采用四个按类型/字段识别所属对象的专用接口，不再以数值偏移算式代替 formal 字段所属关系。原 ABI、适配 ABI 与切片 ABI 检查由独立 C analysis agent 完成。

23 份切片全部通过 GCC ILP32 C11 syntax 检查；结果在 `checks/spec-gcc.json`。`checks/SpecVocabulary.v` 对 logic.h 的 137 个正式名称、类型、record 投影及别名逐项 Coq typecheck 通过，日志为 `checks/spec-vocabulary.log`。旧 KNONE 在现有 formal 库没有定义，所选 contract 等价改用 0；KOK/KERROR 从已有 KTaskParseInfo 显式导入。这些检查不是 QCP parser、symbolic 或 VC。真实 RemoveObj 无 return 以及嵌套锁归一后的闲置局部变量会产生 warning，记录保留，未为了消除 warning 改写算法。

设计阶段允许将展开/重组资源、抽象操作组合、while 循环前缀推进和原有具名特化推导留为实现证明义务，但不允许留已知不匹配的路径、资源或 formal 定义。后续在固定通过 predicate revision 上完成独立 spec 审阅；此时尚未运行 QCP workflow，也不声称原 C 已验证。

当前正式标识以 `checks/spec-revision.json` 为准：`KSemaphoreDelete-spec-r2`，25 个 C/header 文件，aggregate SHA-256 `1ebdb05ad64fcdabdf6275e5cb21a05c940ef9e9c156b777692713b25d385a9d`。相同文件快照在 `checks/revisions/KSemaphoreDelete-spec-r2/`。它绑定 predicate r2 的 `9cd7d0759ba6015950e7ab63a448998c9daf844c3458396a132544b12e060879`，predicate 无修改。逐函数共享目录合并计划见 `checks/spec-merge-plan.json`。

## S1 修复：按字段恢复 container 接口

r1 的数值 `CONTAINER_OF(member, offset)` 已全部移除。它虽然采用 ABI 检查得到的数值，却没有保留通用 IdNode 或未发布 task 所需的 formal 字段所属关系，详见 [独立审阅 S1](spec-review.md)。本轮只修复该接口及调用归一，没有加强 GetObj、GetTaskWithIdnodeInfo 等原 canonical Require，也没有新建布局假设。

| 原始宏实例 | r2 专用接口 | 依据及前提来源 |
|---|---|---|
| id.c 的 IdNode.link | CONTAINER_OF_IDNODE_LINK | store_idnode/idnode_link 本来给出当前节点所属 IdNode 的 typed 字段关系；接口空资源，只返回那个所属对象。 |
| ktask.c 的 TaskDescriptor.id | CONTAINER_OF_TASK_ID | 逐字复用原 get_task_with_idnode.c:12–17 的 contract；不要求任务已在 descriptor map 或额外对齐，因此原通用查询范围保持。 |
| linklist.c 与 RR helper 的 TaskDescriptor.sched_link | CONTAINER_OF_TASK_SCHED | 逐字复用 m_ktask.h:549 附近的原 contract，包括 addr_aligned 前提；两个调用点的任务均由等待/ready 队列与已发布 descriptor map 对应，现有不变量提供对齐和字段关系。 |
| semaphore.c 的 Semaphore.id | CONTAINER_OF_SEMAPHORE_ID | semaphore ID manager 成员关系给出同一个已发布 Semaphore 的 id 字段所属关系；不要求借出或新增对象内存。 |

四接口均属于 TrustBase 已批准的 CONTAINER_OF 宏适配范围；它们没有 active canonical body，也不是额外被证明的 C 函数。边界 symbol 总数从 5 变成 8，真实函数体仍为 23。TASK_SCHED 两处 caller 的接口完全一致；TASK_ID 保留已有接口，不与全局同名 API 分叉。类型头和真实 ABI 未改，五处 C 调用只更换宏的工具适配名称，源执行路径、对象身份及副作用保持。此修复的真实形式效果是让当前 contract 显式取得并返还 typed 字段关系；不是把 ABI 检查自动变成 Rocq 定理。
