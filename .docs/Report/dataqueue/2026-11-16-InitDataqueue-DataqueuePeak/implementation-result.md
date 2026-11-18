> 最新结果：InitDataqueue run InitDataqueue-20261117224043 已由controller返回done，final-check passed（63个顶层VC）。这是相对于callee契约的Init函数证明；第一阶段闭包尚未完成。当前串行进入DeInitDataqueue run DeInitDataqueue-20261118121138。用户已取消VC预算上限。下文早期预算/部分VC计数为历史记录。

> 2026-11-18最新授权：用户要求持续完成原第一阶段及Pop/Push，取消VC证明时间上限，预先批准后续设计修改与修复建议，无需逐轮等待确认。实际审阅、证明检查和final-check照常执行，失败不得写通过；只读原源码、manual修改边界及禁止无依据假设仍保持。历史预算记录仅作已发生过程，不再作为停止条件。

> 2026-11-18恢复：用户明确给Init追加100分钟（累计上限200分钟），于2026-11-17 16:28 UTC恢复同一run，下一组call_frames_2；此前100分钟及已接纳结果保留。

# Dataqueue 串行验证阶段结果（2026-11-18）

状态：**partially-verified（仅Init部分VC），没有函数完成实现验证或final-check**。

当前run为 [InitDataqueue-20261117224043](../../../../reports/InitDataqueue-20261117224043/controller_state.json)。已接纳annotation、依赖准备、VC-checking及10个证明组，共44/62个顶层VC。所有本轮组先通过Rocq MCP交互Qed，再经controller group-check及finalize编译接纳。已证明成功发布、三类失败进入cleanup、四个返回目标、全部安全组及第一组调用frame。候选证明位于workflow管理的各组manual副本，尚未合并或final-apply；canonical manual仍是生成输入，不冒充最终证明。

## 预算与恢复

沿用每函数累计100分钟上限，旧run按当时记录保守计入15分钟；本run从2026-11-17 14:43 UTC进入VC检查到16:08 UTC约85分钟，MCP旧.vo加载修复不到1分钟不计。累计保守约99–100分钟，余量不足下一组及正式检查，停止新增证明尝试。没有把难度当阻塞或提前宣称完成，也没有重置历史预算。各owner、工具调用时间可在run timing_summary及group tool_calls中核对；工具耗时包含在owner墙钟时间内，不重复相加。

当前无运行owner。controller仍保留vc-proving事实及下一动作call_frames_2，未伪造done/paused或修改状态；追加预算后从step继续当前run。后续须完成call_frames_2/3/4，并由controller汇总annotation gap进入retry。已接纳组可供重试参考，但要按新生成目标重新接纳，不能直接套用旧结果。

## 剩余义务和真实缺口

剩余18个顶层VC：storage_views 2个（blocked），call_frames_2/3各6个，call_frames_4 4个（prepared）。storage_views的具体问题是memset后的which-implies只保留CharArray.full，漏掉原DataqueueStorage已提供的addr_aligned(p_queue,4)。任意1字节对齐数组不能推出2/4字节对齐的typed字段；MCP已核实这一点。修复是在局部注解前提保留既有对齐事实，不加强公开Require，不新增ABI或信任。该修复尚未应用，因为controller目前仍派发独立组。已证storage_views局部split保留，但未计入44个accepted顶层VC。

parent整文件检查、final-apply、final-check均未执行；DeInit/Peak、四个Semaphore IC目标的实现以及第二阶段Pop/Push均未启动。不能把Init调用了这些contract说成对应body已证。

## 输入、信任与一致性

用户确认的map设计使用DataQueueAbs、dataqueue_map及store_map；具体ABI事实dataqueue_layout_abi已按后续明确授权接入，只包含两个sizeof和八个字段地址偏移。GCC ILP32静态断言已核对大小、对齐、offset。没有新增资源/函数效果公理、Admitted或未授权trusted。旧布局缺失阻塞已经解决，现状为上述注解缺口与预算限制。TrustBase用户文件、IRQ边界、原crtoslatest均未修改。

ABI增量经独立predicate/spec审阅通过，revision map-abi-20261117-r1；canonical公开契约保持map版本。受影响全局64份lib根构建exit0、.vo保留。旧其他模块VC的历史失败不因本次库编译而获认证。长期说明见[design.md](design.md)，map/ABI依据见[map-refactor.md](map-refactor.md)，已有源码缺陷及批准修复见[source-errors.md](source-errors.md)。本轮新问题属于注解，不加入C源码缺陷清单。

## 任务总表

| 函数 | 本轮目标或依赖分类 | predicate/spec状态 | 实现证明及final-check | 依赖假设或未完成原因 | 文件/报告 |
| --- | --- | --- | --- | --- | --- |
| InitDataqueue | 第一阶段目标 | map设计及具体ABI已批准 | 44/62顶层VC、10组accepted；无final-check | 累计预算到限；局部对齐注解待修、剩余调用frame待证 | [C](../../../../annotated_C/src/kernel/dataqueue/InitDataqueue.c)、[manual](../../../../VC/dataqueue/InitDataqueue_proof_manual.v) |
| DeInitDataqueue | 第一阶段目标，Init回滚闭包 | 已批准init_cleanup | 未启动实现；无final-check | 仅未发布对象回滚；不覆盖通用并发销毁 | [C](../../../../annotated_C/src/kernel/dataqueue/DeInitDataqueue.c) |
| DataqueuePeak | 第一阶段目标 | map修订已批准 | 未启动实现；无final-check | 阶段尚未完成；具体ABI已接入 | [C](../../../../annotated_C/src/kernel/dataqueue/DataqueuePeak.c) |
| KSemaphoreCreate | 第一阶段新IC闭包目标 | dataqueue_ic已审阅批准 | 未启动本轮实现；无final-check | 不冒称旧OC证明覆盖IC | [C](../../../../annotated_C/src/kernel/semaphore/KSemaphoreCreate.c) |
| _SemaphoreCreate | 第一阶段新IC闭包目标 | dataqueue_ic已审阅批准 | 未启动本轮实现；无final-check | 需按既定规则适配嵌套锁与IC注解 | [C](../../../../annotated_C/src/kernel/semaphore/_SemaphoreCreate.c) |
| KSemaphoreDelete | 第一阶段新IC闭包目标 | dataqueue_cleanup_ic已审阅批准 | 未启动本轮实现；无final-check | 受限无等待者/无queue引用场景；通用OC生命周期待办仍存在 | [C](../../../../annotated_C/src/kernel/semaphore/KSemaphoreDelete.c) |
| _SemaphoreDelete | 第一阶段新IC闭包目标 | dataqueue_cleanup_ic已审阅批准 | 未启动本轮实现；无final-check | 需IC嵌套锁适配，不能据旧VC宣称通过 | [C](../../../../annotated_C/src/kernel/semaphore/_SemaphoreDelete.c) |
| PopDataqueue | 第二阶段首目标 | 尚无正式新spec；共享模块设计已有 | 未启动；无final-check | 第一阶段尚未完成；Obtain/Abandon及必要新闭包待设计；批准修复仍在报告 | [修复说明](source-changes.md) |
| PushDataqueue | 第二阶段次目标 | 同上 | 未启动；无final-check | 须在Pop后推进，复用统一接口 | [修复说明](source-changes.md) |
| IdInsertObj / IdGetObj / IdRemoveObj | reused-spec边界 | 沿用已审阅caller-local导入契约 | 本轮不证明、不生成其VC | 依赖契约，不计已证明或trusted | [设计及来源](design.md) |
| InitDoubleLinkList / DoubleLinkListInsertNodeAfter / IsDoubleLinkListEmpty / DoubleLinkListRmNode / LinklistResumeAll | reused-spec边界 | 沿用已审阅契约 | 本轮不证明其body | 旧证明状态不改变边界，不声明整个调用链已证 | [设计及来源](design.md) |
| CriticalAreaLock / CriticalAreaUnLock / DisableLocalInterrupt / EnableLocalInterrupt | 既有可信边界 | 沿用既有授权契约 | 不作为本轮新证明 | 非SMP ILP32资源交接、原样恢复保存值；无硬件IRQ证明 | [TrustBase](../../../../.agents/skills/verify-an-os-function/references/TrustBase.md)、[context](context.md) |
| x_malloc / x_free / memset / CONTAINER_OF模型 | 既定模型/API或已授权trusted | 沿用各caller既定契约 | 不计本轮实现证明 | 按TrustBase及源码处理规则适用，不扩大边界 | [设计](design.md) |


## 阶段性增量

相对本次ABI继续验证前真实工作树，lib/common/DataqueueInv.v仅新增具体布局公理及说明（见下表）；其他lib源保持。手写proof只写workflow的assigned manual spans，尚未final-apply至canonical，因此canonical手写证明增量为0；canonical manual的变化为controller重新生成map目标，不算手写证明成果。已接纳候选不是最终发布统计，正式完成后按final-apply产物统计manual增量。

| 文件 | 新增 | 删除 | 净增 |
| --- | --- | --- | --- |
| `lib/common/DataqueueInv.v` | 9 | 2 | 7 |

Init完成后收尾：根构建检查到正式InitDataqueue_goal_check.vo通过，4份.vo均保留。源码行为只沿用已有批准副本修复；本workflow只增补注解。formal manual为1324行；在本轮最初起点该文件不存在，因此相对空文件为+1324/-0（含生成模板、声明、注释与手写证明，不能全计为手写tactic）。DeInit新VC已加入根_CoqProject，两个Makefile同步。

工具分流诊断：当前QCP工程适配层symexec_tooling.py的_route_unproved_auto_obligations在auto任一lemma含未完成标记时把所有auto lemma转入manual，并清空auto正文。Init的final-check routing记录列出转移目标；这些目标已在manual实际证明，完整性结论不依赖空auto。此行为不是verify-an-os-function要求，也未据此认定核心生成器错误。尚需取得分流前的逐lemma结果，再决定选择性保留已完成auto的修复；本轮不手工搬证明到generated auto冒充自动完成。

DeInit恢复后进展：owned_buffer_view、irq_observation、free_branch_projection、first_delete_transition四组正式accepted，累计10/45顶层VC。数组到free字节、assertS锁内观察、第一删除后第二quiescent保持均已实际证明；cleanup_refinement进行中。重启未重置run/已接纳证明，原pending owner按同一claim恢复。

共享header兼容：另一窗口只新增PopPush设计库，原共享lib未改；dataqueue.h的新增操作词汇/import已按CRTOS_DATAQUEUE_WITH_OPERATIONS条件启用，Pop/Push两caller定义宏。GCC预处理formal文本与修改前一致，第一阶段不再受无关import影响，相关第二阶段review/context附了更新hash和非语义检查。
