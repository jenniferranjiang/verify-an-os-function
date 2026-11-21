> 2026-11-21 更新：Dataqueue 已改为有效元素列表，本文旧 Dataqueue predicate/spec/实现结论不适用于新输入。Init、DeInit、Peak、Pop 的旧表示证明需重新适配；历史记录保留。见 [本轮设计与验证范围](../2026-11-21-FifoRepresentation/design.md)。

# Dataqueue 当前任务总表

本表替代此前叠加的历史状态。用户已取消VC累计证明时限，并授权完成Semaphore后串行推进Peak、Pop、Push及必要非导入调用闭包。实际检查仍须通过。

逐函数实际用时及统计口径见[证明用时表](proof-timing.md)，包括已完成、进行中和未开始项。

| 函数 | 本轮目标或依赖分类 | predicate/spec 状态 | 实现证明及 final-check | 依赖假设或未完成原因 | 文件/报告 |
| --- | --- | --- | --- | --- | --- |
| InitDataqueue | 第一阶段目标 | map/ABI版本审阅通过 | 当前原生auto/manual workflow done，final-check通过 | Create/DeInit及其新增IC闭包已完成；保留导入契约和可信边界 | [当前证明说明](native-auto-restoration.md) |
| DeInitDataqueue | 私有初始化回滚目标 | init_cleanup审阅通过 | 当前原生auto/manual workflow done，final-check通过 | Delete IC闭包已完成；不涵盖已发布对象并发销毁 | [当前证明说明](native-auto-restoration.md) |
| _SemaphoreCreate | 本轮新IC契约调用闭包 | 审阅通过，冻结规格未变 | done，final-check通过；9顶层+13split Qed | 原生auto 26个；ID/DLL导入契约、分配模型及ABI依赖保持 | [IC记录](semaphore-ic-review.md) |
| KSemaphoreCreate | 本轮新IC契约wrapper | 审阅通过 | done，final-check通过；3个原生auto VC | 内部Create已done，采用原生自动求解路径 | [canonical](../../../../annotated_C/src/kernel/semaphore/KSemaphoreCreate.c) |
| _SemaphoreDelete | 本轮新IC契约调用闭包 | quiescent清理契约审阅通过 | done，final-check通过；14顶层+11split Qed | 35个原生auto；quiescent清理范围，ID/DLL导入边界 | [canonical](../../../../annotated_C/src/kernel/semaphore/_SemaphoreDelete.c) |
| KSemaphoreDelete | 本轮新IC契约wrapper | 同上 | done，final-check通过；3个原生auto VC | 内部Delete已done | [canonical](../../../../annotated_C/src/kernel/semaphore/KSemaphoreDelete.c) |
| DataqueuePeak | 第一阶段目标 | map版本设计审阅通过 | done，final-check通过；7顶层+10split Qed | 18原生auto，IRQ和已授权ABI边界 | [canonical](../../../../annotated_C/src/kernel/dataqueue/DataqueuePeak.c) |
| PopDataqueue | 第二阶段首目标 | predicate/spec r1审阅通过 | 本体done/final-check通过；14顶层+9split Qed | 34原生auto；Obtain/Abandon新增闭包尚未完成 | [设计审阅](../2026-11-18-PopDataqueue-PushDataqueue/review.md) |
| PushDataqueue | 第二阶段后目标 | predicate/spec r1审阅通过 | 尚未开始QCP实现证明 | Pop之后推进，复用共有接口和依赖 | [设计审阅](../2026-11-18-PopDataqueue-PushDataqueue/review.md) |
| _SemaphoreObtain | Pop/Push新增调用闭包 | 设计审阅通过 | done，final-check通过；36顶层+37所需split Qed | 107原生auto；有限Delay恢复、失败回滚和调度后status已证；导入任务契约保持 | [闭包设计](../2026-11-18-PopDataqueue-PushDataqueue/source-analysis.md) |
| KSemaphoreObtain | Pop/Push新增wrapper | 设计审阅通过 | done，final-check通过；3原生auto | 内部Obtain已done，caller契约一致 | [闭包设计](../2026-11-18-PopDataqueue-PushDataqueue/source-analysis.md) |
| KSemaphoreAbandon / _SemaphoreAbandon | Pop/Push新增调用闭包 | 设计审阅通过 | 内部Abandon在VC-checking已暂停；wrapper尚未开始；无final-check | 包含计数和唤醒路径 | [闭包设计](../2026-11-18-PopDataqueue-PushDataqueue/source-analysis.md) |
| LinklistSuspend | 新场景契约调用闭包 | 设计审阅通过 | done，final-check通过；26顶层+9split Qed | FIFO/优先级插入，含派生spec蕴含，不假设等待链排序 | [闭包设计](../2026-11-18-PopDataqueue-PushDataqueue/source-analysis.md) |
| LinklistResume | 新场景契约调用闭包 | 设计审阅通过 | done，final-check通过；5顶层+3split Qed | 12原生auto；KTaskWakeup保持已导入契约边界 | [闭包设计](../2026-11-18-PopDataqueue-PushDataqueue/source-analysis.md) |
| CalculateTickFromTimeMs | 新规格叶子 | 64位转换设计审阅通过 | done，final-check通过；6顶层+6split Qed | 15原生auto；当前64位乘法、100Hz契约 | [canonical](../../../../annotated_C/src/kernel/common/CalculateTickFromTimeMs.c) |
| ID/DLL helpers；GetKTaskDescriptor、KTaskSetDelay、KTaskWakeup、SuspendKTask等 | reused-spec | 按各caller核对适用性及接口 | 不作为本轮新证函数计数 | 使用导入契约，不因来源证明未完成扩大闭包 | [闭包及来源](../2026-11-18-PopDataqueue-PushDataqueue/source-analysis.md) |
| Lock/Unlock、分配/释放/清零及其他规定模型 | 已授权可信或模型/API边界 | 依既有契约和适用条件 | 不宣称本轮证明硬件或模型实现 | IRQ、C库及ABI假设分别记录，未扩大trusted函数集 | [TrustBase](../../../../.agents/skills/verify-an-os-function/references/TrustBase.md) |

Init/DeInit当前采用原生QCP自动求解结果与手工Rocq证明的组合；auto中生成器保留的Admitted不能称为完整Rocq证明项。准确数量及done记录见native-auto-restoration.md。设计通过、goal编译通过和依赖构建通过均不等于实现证明完成。

长期语义说明见[design.md](design.md)，原始源码缺陷及批准副本修复见[source-errors.md](source-errors.md)和[source-changes.md](source-changes.md)。历史运行细节保留于对应workflow及其他报告，本表只呈现当前状态。
