# Dataqueue 全局整合检查

本次已完成最新InitDataqueue设计及批准源码副本的全局整合，原工作区不是后续构建依赖。**新增设计的迁移对应性及全局lib类型检查通过；全部旧VC证明并未通过当前回归编译。** 本次没有运行QCP parser/symbolic、生成新VC或完成C实现证明。

## 输入保全与增量合并

最新输入共53份非缓存文件：29份库、7份canonical C、2份header、3份源码上下文、1份README、11份报告；没有VC、workflow或controller状态。另一个旧目录未读取或复用，按用户要求删除。

独立reviewer确认：24份既有库来源与原记录基线一致；新增5份Dataqueue formal与原设计经全局命名空间替换后逐字一致；原全局库的Definition/Fixpoint/Record/Lemma等符号保留。29份原库输入中的空间接口现在直接复用同一全局Assertion下的原定义，未将裁剪副本覆盖全局完整文件。

3个Dataqueue canonical仅调整include/逻辑路径及来源说明，行为与已批准副本保持。4个Semaphore canonical保留原OC完整文件文本，新增IC契约块的20份契约在去选名后与原IC声明一致，且每个函数只有一个active定义。IC以去除嵌套锁等规则适配后的输入为对象，不能当作原OC body直接获证；完整重建规则见 [design.md](design.md)。3份未完成规格的源码上下文逐字保留所有批准修复。

原源码data_queue.c、semaphore.c、delay.c、tick.c哈希保持。没有应用两个待批准的Delay相关修复，也没有扩大IRQ信任授权。

## 当前全局输入与检查

- 整合版本标识：`dq-global-integration-20261116-r1`，表示路径/定义整合记录，不是新的实现证明revision。
- 全部64份全局lib的路径加SHA-256联合摘要：`03df8fe065b89359193ae15d472c09fa8340b0b1d4e9595be2d5308dba68d4dc`。
- 本轮7份canonical C加2份header联合摘要：`b99c19bf0aa7db9cf16222b5ff7a34a7610116a0f7c3b109287f35c37f7165fa`。
- 摘要算法：lib按路径排序；C按路径排序后接header排序；各项“工程相对路径 空格 文件SHA-256 换行”串接再取SHA-256。
- 全部64份lib经根Makefile依赖编译通过，相关.vo保留。新增头文件的实际Coq imports及63个qualified符号逐一Check通过，Init/Peak抽象与native Assertion类型检查通过，编辑器同配置可交互式加载。
- 7份C通过ILP32 GCC语法检查；原OC输入、IC调用契约以及源码修复对应关系经独立核对。
- 根_CoqProject、Makefile/Makefile.coq及依赖配置、编辑器路径均使用全局位置。设计和源码报告链接指向现存全局文件。

## 旧VC回归：既存失败及检查边界

原46份VC源码逐字保留。对合并前59份lib+46份VC，在独立临时构建中从零编译，不使用主工程或原工作区.vo：59份lib通过，19份VC生成.vo；出现以下7个首要失败。与合并后的回归相比，文件、行号和错误文本逐项一致。

| 既有文件 | 首要失败 |
| --- | --- |
| [EventCreate_lib.v](../../../../VC/event/EventCreate_lib.v) | split_pure_spatial的目标形态不匹配 |
| [MutexCreate_lib.v](../../../../VC/mutex/MutexCreate_lib.v) | msgqueue_inv未找到 |
| [SemaphoreDelete_lib.v](../../../../VC/semaphore/SemaphoreDelete_lib.v) | msgqueue_inv未找到 |
| [LinklistResumeAll_lib.v](../../../../VC/semaphore/LinklistResumeAll_lib.v) | introduction pattern不匹配 |
| [SemaphoreCreate_lib.v](../../../../VC/semaphore/SemaphoreCreate_lib.v) | published_world_wf__publish仍有未完成目标 |
| [KSemaphoreCreate_goal_check.v](../../../../VC/semaphore/KSemaphoreCreate_goal_check.v) | auto/manual Include存在重复proof label |
| [KSemaphoreDelete_goal_check.v](../../../../VC/semaphore/KSemaphoreDelete_goal_check.v) | auto/manual Include存在重复proof label |

这是“本次未发现新的首要编译失败”，不是“全部旧证明仍有效”：被这些失败挡住的依赖证明尚未检查完成。既有VC源码未修改或重生成，不能以旧历史done结果宣称其已通过当前模型的验证。

## 需要后续处理的语义问题

即使库能typecheck，通用OC KSemaphoreDelete原契约在新os_inv下仍有具体生命周期问题：ready队列q引用blank ID0/data ID1，调用通用Delete(0)可删除ID0并保留q。随后dataqueue_semaphores要求ID0存在，却已不满足，因而无法恢复新的os_inv。原OC Require没有排除此场景。

本次保留原OC接口和证明源码，同时明确其通用保证需复核；没有擅自加强Require或弱化queue关联。迁入的init_cleanup IC契约有无queue引用等quiescent条件，不能将其受限结论推广成通用删除。Dataqueue新实现证明尚未开展，详见 [设计说明](design.md) 的人工审阅重点。

## 本轮lib源文件增量

相对于本次整合前真实工作树，新增5份、修改5份；包括注释和空行。该统计说明设计整合规模，不是新增证明数量。

| 文件 | 类别 | 行增量 |
| --- | --- | --- |
| [lib/common/CrtosGlobState.v](../../../../lib/common/CrtosGlobState.v) | 修改 | +17 / -4 |
| [lib/common/CrtosInv.v](../../../../lib/common/CrtosInv.v) | 修改 | +21 / -3 |
| [lib/common/DataqueueInv.v](../../../../lib/common/DataqueueInv.v) | 新增 | +118 / -0 |
| [lib/dataqueue/DataqueueState.v](../../../../lib/dataqueue/DataqueueState.v) | 新增 | +96 / -0 |
| [lib/dataqueue/KDataqueuePeak.v](../../../../lib/dataqueue/KDataqueuePeak.v) | 新增 | +62 / -0 |
| [lib/dataqueue/KDeInitDataqueue.v](../../../../lib/dataqueue/KDeInitDataqueue.v) | 新增 | +61 / -0 |
| [lib/dataqueue/KInitDataqueue.v](../../../../lib/dataqueue/KInitDataqueue.v) | 新增 | +66 / -0 |
| [lib/semaphore/KSemaphoreCreate.v](../../../../lib/semaphore/KSemaphoreCreate.v) | 修改 | +15 / -0 |
| [lib/semaphore/KSemaphoreDelete.v](../../../../lib/semaphore/KSemaphoreDelete.v) | 修改 | +54 / -0 |
| [lib/task/KTaskWakeup.v](../../../../lib/task/KTaskWakeup.v) | 修改 | +6 / -2 |

## 记录保留

长期说明为 [design.md](design.md)，覆盖本轮lib/spec/VC含义及规格审阅重点；源码问题与修复证据、前后原因、函数进度、当前上下文均在本目录保留。原predicate/spec审阅记录注明其冻结版本属于迁移前输入，当前路径对应及检查以本报告为准。目录删除结果在完成后追加。

独立reviewer最终复核通过：原OC正文、3份批准源码副本、46份VC源码及原仓库源码均保全，无活动工作区路径依赖，报告链接有效。复核后仅清理CrtosGlobState的末尾空行并重新编译该文件；正文定义与证明未变化。

用户指定的两个InitDataqueue目录已删除：initdataqueue-trial-261115-1与initdataqueue-trial-261112-1。仅最新目录作为整合来源，旧目录未读取或复用。全局64份lib的.vo保留；源码问题与恢复所需报告留在当前全局位置。

删除目录后再次使用编辑器同配置成功加载全局KInitDataqueue/KDataqueuePeak；64份.vo、当前输入hash及全部报告链接再次核对通过。无运行中编译进程后已清理本轮迁移快照、隔离基线构建和过期未采用草稿；待用户处理的Delay回绕反例与提案仍按源码错误记录保留。

报告按用户要求整理到模块下的日期与主目标函数目录。全局C仅同步了注释中的报告路径，可执行代码与契约保持；上方C/header摘要已相应更新，库输入与.vo不受影响。
