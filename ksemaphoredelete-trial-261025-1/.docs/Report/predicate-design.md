# KSemaphoreDelete predicate 设计

## 当前 r4：具名任务结果条件（2026-10-27）

新增 `tasks_ready_with_exstatus`，位于 [共享 KTaskWakeup 模块](../../../lib/KTaskWakeup.v)。它仅封装原量词式的 READY 与指定 exstatus 条件，不包含资源或精确唤醒过程。
候选独立审阅与编译通过后增量同步共享库；现有定义未变，根 KTaskWakeup、KSemaphoreDelete 重编译通过，正式导入及定义展开等式检查通过。
版本 `KSemaphoreDelete-pred-r4` 的 active shared 文件哈希见 checks/predicate-revision.json，证据在 [ready-exstatus](../../checks/ready-exstatus/)。本次没有运行实现证明。


## 历史 r3：任务唤醒资源接口（2026-10-26）

用户要求参考 LOS 的模块级前后状态写法，新增共享 `KTaskWakeup.v` 的 `task_wakeup_inv`。
它组合既有任务字段、延时和就绪队列资源，供 LinklistResumeAll 在前后条件中作为整体使用；源等待链与行为关系仍单独写出。
具体定义和边界注释见 [共享模块](../../../lib/KTaskWakeup.v)，没有修改现有 task_inv、全局 os_inv 或现有抽象状态。
新接口的展开与 r4 三项资源一致，不要求额外稳定一致性，不增加或丢弃内存；不是整份 pre/post 的封装。
候选在 trial/lib 编译并独立审阅后增量合并到根模块，根 KTaskWakeup 与直接依赖 KSemaphoreDelete 均重新编译通过。
当前使用原有 CRTOS_Verify.lib 导入，无新增构建路径；trial/lib 是审阅副本。共享索引已同步，未修改根 annotated C 的既有契约。
当前 `KSemaphoreDelete-pred-r3` 的 active shared 源文件哈希见 checks/predicate-revision.json；前态及检查在 [检查目录](../../checks/task-wakeup-inv/)。
这是资源接口的表示调整，不是新完成的 C 实现证明。


当前 formal revision：`KSemaphoreDelete-pred-r2`，状态：`review-ready`。文件清单和逐文件 SHA-256 在 [predicate-revision.json](../../checks/predicate-revision.json)；下列 7 个 `.v` 均已通过 `coqc` 编译。此结论只表示设计候选可交审阅，不是 `review-passed` 或 C 实现证明。

本轮按用户修订后的 skill，以《源代码处理》适配后的闭包为范围。`DO_KTASK_ASSIGN` 使用已有 `KTASK_ASSIGN/abs_ktask_assign` 模型，不递归原始调度和硬件切换内部调用；这项模型边界不宣称逐语句硬件等价。原 B1 已因规则明确而解除，旧准备阶段的 blocker 结论不适用于此 revision。C 行为及配置见 [c-analysis.md](c-analysis.md)，ABI 按当前 32 位适配核对；不将原生 K210 的 64 位/SMP 配置混入结论。

## 正式文件与共享库复用

| 文件 | 本次责任 |
| --- | --- |
| [TaskInv.v](../../lib/TaskInv.v) | 共享文件副本；保留所有原字段/谓词，仅为 task_world_wf 增加 SUSPEND bitmap 一致性字段。 |
| [SemaphoreInv.v](../../lib/SemaphoreInv.v) | 共享文件副本；修复 P1，等待节点复用真实嵌套字段地址 sched_link_of。 |
| [CrtosInv.v](../../lib/CrtosInv.v) | 共享文件副本；切换 TaskInv 与 SemaphoreInv imports，使 os_inv 使用同一候选版本。 |
| [KTaskWakeup.v](../../lib/KTaskWakeup.v) | 任务 exstatus/READY 更新、真实 RRR 插入和 ready 元数据更新、delay 取消关系、唤醒源链及任务/ready 局部资源接口。 |
| [KTaskUnSetDelay.v](../../lib/KTaskUnSetDelay.v) | 依据旧 annotated C 的具体展开恢复 vDelayView 及局部 pre/post，供保留原具名规格。作者为 main agent，纳入本 revision 一并审阅。 |
| [SemaphoreOps.v](../../lib/SemaphoreOps.v) | 信号量模块的 uint16 查询归一、等待队列更新、注销；直接复用 SemaphoreAbs/SemaphoreState。 |
| [KSemaphoreDelete.v](../../lib/KSemaphoreDelete.v) | 按原队列顺序逐次唤醒、锁内删除效果、带可选调度的顶层 program，以及摘链后的私有完整对象。 |

未修改的 SemaphoreState、AssignState/AssignInv、DelayState/DelayInv、CrtosGlobState/CrtosRules、idnode、DLL、TaskStatus 等直接导入根库。没有另造 Task view、Semaphore 专用临界区、第二份可变 ID manager 或第二份共享状态类型。三份被修改文件的复制基线在 `checks/baseline/`；全局库未由本作者修改。

## r1 → r2：修复独立审阅 P1

[r1 独立审阅](predicate-review.md) 为 `needs-fix`，唯一 P1 是根 SemaphoreInv 的 semaphore_wait_node 使用虚构直接字段 `TaskDescriptor.sched_link`。r2 将该构造改用已存在的 `sched_link_of task`，即真实 `task_dync_sched_member.sched_link`，其余 SemaphoreInv 定义和证明保持原样；CrtosInv 指向该 trial 副本。没有增加别名公理、地址等式 Require 或空等待队列限制。

影响路径为 `SemaphoreInv.store_semaphore → CrtosInv.os_inv → KTaskWakeup.source view → KSemaphoreDelete.resume/delete`：等待链的 node pointer、SUSPEND payload 约束、wakeup source 和 READY node 现在使用同一规范地址。公共 TaskState/AssignState 的地址函数未修改，KTaskUnSetDelay 与 SemaphoreOps 不依赖此表示变化。`checks/P1AddressCheck.v` 以 `eq_refl` 检查等待 node 与 ready node 定义相同、其 pointer 与 source view 使用的 sched_link_of 相同，类型检查 exit_code=0，日志在 `checks/P1AddressCheck.log`。源 C、适配配置、其他 functional effect 均未改变。原基线保存在 `checks/baseline/SemaphoreInv.v`，P1 来源是已有表示错误而非 C 源码缺陷。

此修复改变非空等待链的内存表示，r1 不能用于当前 spec review；r2 请求仅复查 P1 与上述受影响依赖。包含 r1 的既有审阅归档保持不变。复制的 SemaphoreInv 带有原已授权的布局公理 `semaphore_field_offsets_trusted`，本次没有修改或新增该公理；“无新增公理”不表示所有导入文件不含历史信任项。

## 数据与内存归属

SemaphoreAbs 已含基址、ID、value 和等待任务地址顺序；ID bitmap/hash 桶由管理链顺序派生。内部按地址追踪从已发布到私有回收的同一对象，外部接口仍通过 ID 查找，不把地址暴露成用户必须提供的身份。

| 实体/阶段 | 唯一 owner 及转移 |
| --- | --- |
| 发布对象的 ID 字段和 id.link | `store_idmanager`，通过 `semaphore_manager` 对应同一个 Semaphore；注销后返还调用者。 |
| 发布对象的管理 link | `semaphore_inv` 的管理 DLL；摘链后返还自环节点。 |
| value、padding、pend_list | `store_semaphore`；删除保持 value/padding，清空 pend 后带入私有对象。 |
| 等待任务 sched_link | Semaphore 的 pend DLL；每次唤醒摘出，并由 ready DLL 接管。 |
| 任务 exstatus、六个调度字段、delay 指针及其余描述符 | `task_inv` 的唯一 descriptor map；`task_fields` 只借出 manager/map，其余 task 容器与表资源留在 caller frame。 |
| Delay 对象 | `delay_inv` 的 active DLL 或 inactive map；取消仅移入 inactive，不 free、不改 task.delay/ticks/task 字段。 |
| 就绪桶、bitmap、highest_prio | `assign_inv`；`assign_ready_pending` 借出 raw vector 和节点登记事实，容纳 group/highest 尚未同步的中间阶段。 |
| 注销到锁外 free | `SemaphoreRetired` 拥有目标完整字段、padding 和三条自环 link；剩余 `os_inv` 已不含目标。私有资源穿过 unlock，合为 `SemaphoreRaw` 后交 `x_free` 消费。 |

`store_ktask_wakeup_sched_pre/post` 保存原链哨兵及前后缀，避免仅凭 SUSPEND 猜来源；其 payload 只给登记/地址关系，不取得 descriptor 所有权。`store_ready_dll_tail_view` 以同一桶资源加纯尾指针关系支持尾插；空桶 tail 等于哨兵。既有 `os_sched_owners` 已含 Semaphore，coverage/NoDup 推论可支持其他队列互斥，不另加重复条件。

## 功能效果及真实路径

`semaphore_query_id` 明确对非负 int32 输入取模 65536；负值在顶层 program 中先直接返回。例如 65536 查询 ID 0，不能用无依据 `id < 128` 或 `id < 65536` Require 排除别名路径。

`GetObj` 可能将 BSS 零桶初始化为自环后返回 NULL。共享 `store_idbucket` 已容纳这两种空桶形态，因此失败可保持同一抽象对象序列；报告和契约不能由这个抽象恒等推出具体字节不变。

`semaphore_resume_one` 明确先写首任务 exstatus=-1，再用 `ktask_wakeup_step` 取消 delay、设 READY、插就绪队列，最后更新该信号量的 pending 后缀。`semaphore_resume_all_steps` 按原顺序重复，空列表要求同一信号量仍发布且 pending 已空。合法系统中，等待 payload 关联已登记 SUSPEND 任务，成功摘链支持剩余长度下降；坏链表和未登记任务不被模型假装为成功返回。

RR_REMAINSLICE 的 `advance_cnt < 1` 分支在第一个 rest_timeslice 严格较大节点前插入，找不到则尾插；达到阈值时无条件尾插。因此不要求原桶全局按剩余时间片排序。插入本身保持 advance_cnt、rest_timeslice、origin_timeslice。AssignPolicyInsert 更新 highest=max；外层 KTaskInsertToReadyVector 再用真实 bitmap_column OR 更新 group。所有其他描述符字段和 ready 桶顺序按局部更新保留。

`semaphore_delete_locked_effect` 分清未命中与成功注销，resched 恰等于原 pending 非空。成功先完成所有唤醒，再注销 ID 和管理链；`abs_semaphore_delete` 在外层组合一次原子删除与必要的 `abs_ktask_assign`，没有给负 ID 路径虚构加锁观察。free 消费私有对象，不修改该抽象全局状态。

ID 值的两个阶段保持区分：共享 `store_idmanager_removeobj_post` 正确表示 static RemoveObj 摘链后仍持原 id；完整 IdRemoveObj 接着写 uint16 65535。此次不修改该中间定义。旧 `m_id.h` 的 current_node 不应将它直接当完整出口；spec 作者需保持完整出口 65535，与原 known_node 保证一致。

## SUSPEND bitmap 条件的有依据增补

旧 `task_world_wf` 仅约束 RUNNING 的 bitmap；READY 由 assign 的桶关系约束。取合法优先级 3、SUSPEND、bitmap_column=0 的 descriptor：原字段类型与旧 task 条件允许这个值，但唤醒会插入优先级 3 桶并 OR 0，无法恢复 ready bitmap 与非空桶对应。这不是缺文件或不能拆 owner 的推测，原条件确实不能推出所需掩码。

本候选保留原 `task_wf_running_bitmap` 字段签名，仅增加 `task_wf_suspend_bitmap`。源码依据：`ktask.c:597–619` 的 Startup 设置 cur_prio 后调用 `__BitmapSiteMask`；`ktask.c:524–558` 的 Suspend 仅接受 READY/RUNNING 并保持 cur_prio/bitmap；`ktask.c:244–285` 的优先级修改对 SUSPEND 同步重算 mask；当前 32 优先级的 `__BitmapSiteMask` 在 84–97 行按 cur_prio 设置位。该条件是正常生命周期的系统不变量设计，不能声称已证明所有上游状态转换保持它。

类型不改变，但所有构造 task_world_wf/os_inv 的旧证明会受到新增条件影响；全局合并后必须按根配置重新编译受影响文件，旧结论不能自动追认为已证明新字段。新条件不作为删除函数额外筛选 ID/等待者的 Require，也不通过另造协议逃避共享一致性。

## 初始化、回收及待证义务

Semaphore 全局零初始化与空管理链继续复用 semaphore_initial_memory；没有新 token、额外分配或初始化对象。Task 初始 INIT 不要求此 SUSPEND mask，进入 SUSPEND 的真实路径需维持上述生命周期条件。

SemaphoreRetired 明确保留 ID 值 65535、原 value、padding、空 pend 和 ID/管理 link 自环。它携带三条内嵌 link 的非零事实，来源分别是原共享 DLL 的节点/哨兵条件；不能仅凭 `store_node_self_linked` 推出，因为该定义本身不含非零。释放基址仍是创建时的 Semaphore 基址，不能把内部 idnode 地址当作任意可释放指针。

`semaphore_retired_raw_obligation` 是一个可类型检查的 Prop 陈述，要求把完整退休资源转为已有 SemaphoreRaw；它不是已证引理，任何规格/证明不得直接使用它当事实。循环保持、共享 invariant 重建、RR 插入与 delay map/DLL 重组以及这个资源转换仍属于批准后实现阶段的证明义务。没有新增 Parameter、Axiom、admit 或 Admitted。现有共享 ABI 公理及 trusted free/critical/CONTAINER_OF 沿项目授权边界使用，不被包装成新已证结论。

## 编译与交审

可复现命令：`python3 ksemaphoredelete-trial-261025-1/checks/compile-predicate.py`。使用 trial `_CoqProject` 中与根项目一致的共享库映射及独立 `KSemaphoreDeleteTrial` 路径；逐文件命令/退出码见 [predicate-compile.json](../../checks/predicate-compile.json)，各日志为 `checks/compile-*.v.log`。7 个候选正式文件均有 exit_code=0 的编译记录；r2 仅重编译发生语义或依赖变化的 SemaphoreInv、CrtosInv、KTaskWakeup、KSemaphoreDelete，其余未改变文件复用 r1 结果。共享依赖 `.vo` 的使用不冒称全局合并后的根重编译检查。

本 revision 已完成作者的源码/字段归属/效果检查，交独立 reviewer 检查。本报告不提前给出 predicate 或 spec `review-passed`；所有 spec review 必须固定通过审阅的 predicate revision。本阶段未启动 QCP symbolic、VC 或 implement。
