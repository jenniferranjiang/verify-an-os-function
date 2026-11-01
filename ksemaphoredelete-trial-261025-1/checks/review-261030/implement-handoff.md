# KSemaphoreDelete 实现阶段交接准备

2026-10-30。用户已明确确认下述 review-passed revisions 并要求开始实现；本文件作为 workflow 交接约束。运行状态以 controller 报告为准。

## 固定设计输入

- Predicate：`KSemaphoreDelete-pred-r7`，内容摘要 `9a204245814625aade45188ff92e1cc911bc1aad78fee08d7f2f5dfab8b9d786`。
- Spec：`KSemaphoreDelete-spec-r9`，内容摘要 `00bad529f9b7b9f5a29415d443d27d7e6a7875e9ffc798acefdd6e3285a4c17b`。
- 审阅结论以 `checks/predicate-revision.json`、`checks/spec-revision.json` 及链接报告为准。
- TrustBase：`/home/xinra/TrustBase.md`；仅人工维护。
- 工程：`/home/xinra/crtos/ksemaphoredelete-trial-261025-1/`；继续使用此目录，不创建替代 trial。
- 路径：现有 `_CoqProject`、`annotated_C/include/logic.h`、`annotated_C/include/slice_types.h`；正式库来自根 `lib/` 的 `CRTOS_Verify.lib`。

## 函数体证明目标

- `KSemaphoreDelete`：`annotated_C/src/KSemaphoreDelete.c`。
- `_SemaphoreDelete`：`annotated_C/src/_SemaphoreDelete.c`。
- `LinklistResumeAll`：`annotated_C/src/LinklistResumeAll.c`。

## 外部契约边界

本轮在下列导入契约处停止递归，不生成它们的实现 VC。逐项来源、revision 和所选接口见 `checks/verification-scope.json`；不能把它们计为本轮新完成的实现证明。

`KTaskWakeup`, `_KTaskWakeup`, `GetTaskWithIdnodeInfo`, `KTaskUnSetDelay`, `KTaskInsertToReadyVector`, `AssignPolicyInsert`, `RoundRobinRemainReadyVectorInsert`, `KTaskStateSet`, `KTaskStatSetAsReady`, `JudgeKTaskStatIsSuspend`, `DoubleLinkListRmNode`, `DoubleLinkListInsertNodeBefore`, `DoubleLinkListInsertNodeAfter`, `InitDoubleLinkList`, `IsDoubleLinkListEmpty`, `FreeId`, `RemoveObj`, `GetObj`, `IdGetObj`, `IdRemoveObj`。

`LinklistResumeAll` 调用 `KTaskWakeup` 选择 `semaphore_pending_head_ic`，其 before 是写 exstatus 后的 marked 状态。

既定模型/信任边界：`CONTAINER_OF_IDNODE_LINK`, `CONTAINER_OF_SEMAPHORE_ID`, `CONTAINER_OF_TASK_ID`, `CONTAINER_OF_TASK_SCHED`, `CriticalAreaLock`, `CriticalAreaUnLock`, `KTASK_ASSIGN`, `x_free`。

## 执行约束

按 `/home/xinra/qcp-binary-democases/AGENTS.md` 指定的 verification-orchestrator 启动；当前工具需支持已有 trial 格式及外部库路径，不能把工程重组为 QCP_examples/Rocq 示例目录。符号执行、依赖分析、Coq 编译和 final-check 必须采用同一映射。

用户确认 review-passed 版本后，以上 predicate/spec 作为冻结输入。Annotation owner 可以添加或修正合法的 by local、call where、branch-control、Inv 和 multi-inv 等函数体注解，相关事实仍须证明，不得改可执行 C 行为或通过无依据假设消除义务。冻结语义需要修改时遵循 workflow 的审阅及审批流程。

仅按 controller 返回的 action 执行；不能用手工生成 VC 或编译绕过接纳。实现结束使用 controller final-check，另复核源码一致性记录是否仍有效。

## 本地待证义务

资源 view/strategy 的正确性、exstatus 写权限及 task map 重索引、Wakeup 队首与 ID 关联、循环和批量效果连接、ID found 资源恢复、注销与摘链中间态、SemaphoreRetired 到 SemaphoreRaw 转换均未由设计审阅证明。

当前源码/类型/接口证据见 `checks/review-261030/`；源码报告见 `.docs/Report/source-check-2026-10-30.md`。


2026-10-30 实现适配更新：LinklistResumeAll 的原 NULL_PARAM_CHECK 展开触发 QCP -11，首个 run 真实记录为 infrastructure blocker。按源码处理指南的既定规则，在 recorded parser input 使用 NULL_PARAM_CHECK_1（Require emp / Ensure p != 0，正常返回契约，不承诺 NULL 路径终止）。该边界已独立复核并登记，有效模型/API 数为9。canonical目标规格及predicate不变；既有canonical C中真实NULL无限循环保留，parser使用该受许可的模型边界，不能宣称其helper已在本地证明。详细审阅见 .docs/Report/implementation-adaptations-review.md。
