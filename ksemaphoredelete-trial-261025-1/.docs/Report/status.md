# KSemaphoreDelete 验证状态

## 2026-11-01 同步核对与运行目录清理

批准的 15 个 predicate 文件仍匹配哈希；trial 的 10 个库副本与全局一致。
23 个函数的 40 个公开契约与全局对应位置逐 token 一致；补齐全局 logic.h 原遗漏的 5 条既有声明后，两份逻辑头也逐字一致。
冻结输入检查通过，三个目标的正式 proof/lib 文件均匹配既有 final-check 产物哈希；本次没有重新证明。
函数体证明注解、源输入适配和正式 VC 仍保存在 trial。

移除各 trial 的未跟踪 Rocq 编译产物；当前 trial 的三个已被成功运行替代的失败工作目录已清理。
对应报告继续保留，独有 C/v 源码保存在 `evidence/retired-failed-runs-20261101.tar.gz`，归档内维持旧相对路径。
下文历史记录中对这三个失败工作目录的引用应从该归档恢复；编译产物需重建。
详见根目录 `.docs/checks/trial-maintenance-20261101/{sync,cleanup}.json`。

## 2026-10-31 实现证明完成

三个目标均已完成 controller 发布与 `final-check`，状态为 `done`，错误列表为空。
正式证明已合并到本 trial 的 `VC`；`verification_runs` 中的分组文件和失败轮次保留为历史。

| 目标 | 已检查的顶层 VC | 正式证明 |
| --- | --- | --- |
| KSemaphoreDelete | 3 | [KSemaphoreDelete_proof_manual.v](../../VC/KSemaphoreDelete_proof_manual.v) |
| _SemaphoreDelete | 96 | [SemaphoreDelete_proof_manual.v](../../VC/SemaphoreDelete_proof_manual.v) |
| LinklistResumeAll | 38 | [LinklistResumeAll_proof_manual.v](../../VC/LinklistResumeAll_proof_manual.v) |

批准的 `KSemaphoreDelete-pred-r7` / `KSemaphoreDelete-spec-r9` 保持不变。
结论限于当前非 SMP、32 位配置及 [登记范围](../../checks/verification-scope.json) 中的外部契约与模型边界；
20 个外部函数体未在本次重新证明，NULL_PARAM_CHECK_1 加入后的有效模型/API 边界为9个。

[机器结果及最终文件哈希](../../checks/implementation-results.json) 记录各 run 的完成时间、全部分组和正式产物。
[源码一致性复核](implementation-source-check-2026-10-31.md) 确认原始输入、批准 predicate、契约及执行内容的限定逆映射；
后续单行注解修复生成了新 parser 输入，并由最终 symbolic 重演重新核验。

本次处理的实际问题及证据：

- NONE 精确展开和空头 `for(;;)` 改为等价 `while(1)`，分别解除预处理错误与 QCP -11；见 [工具记录](implementation-tool-blocker.md)。
- 按批准 scope 导入四个 KTaskWakeup 具名契约，不把其上游派生计作本地已证；见 [边界记录](../../checks/imported-wakeup-spec-boundary.json)。
- 删除 `LinklistResumeAll` 中无法由当前模型推出、调用也不需要的 `target != 0` 中间注解。新目标经独立 VC 审查并完成全部证明；没有加强调用前提或修改批准的 predicate/spec。
- `_SemaphoreDelete` 合并库的 Bool.Bool 补充导入改变了 `&&` 的解释。只删除该导入 token 后，完整库由 MCP 编译确认；[最终候选对比](../../checks/merged-import-repair-comparison.json) 确认其余 helper 与 manual proof 保持一致（忽略空白、注释）。
- 按用户要求使用 Rocq MCP 检查后续候选证明。已恢复编译入口及受控 load path；交互 pet 仍因 OCaml 4.14.1 与依赖4.14.2不匹配而不可用，未宣称 start/check 成功。见 [MCP 使用记录](rocq-mcp-workflow.md)。

以下保留设计审阅和早期进度，均为历史记录。

## 2026-10-30 审阅完成，待确认实现输入

`KSemaphoreDelete-pred-r7` 与 `KSemaphoreDelete-spec-r9` 均已独立审阅通过，内容哈希未变。
见 [predicate 审阅](predicate-review-r7.md)、[spec 审阅](spec-review-r9.md)和
[源码一致性复核](source-check-2026-10-30.md)。本轮没有修改 C、predicate 或 spec 的语义，也未启动 QCP。

共享库和规格已在前轮同步到根目录，本轮未产生需再次合并的 formal 修改。
Trial 继续使用根 `CRTOS_Verify.lib`；15 个 predicate、25 个 spec 文件匹配登记哈希，
共享与 trial 的库副本和契约副本一致。根构建目标为 up-to-date，隔离编译的 153 项接口类型检查通过；
31 个源输入及 23 个切片可执行内容未变，3 组 ABI 和 3 个目标 C 语法检查通过。
新证据保存在 `checks/review-261030/`，不替代实现证明。

下一步请用户确认以上两份 review-passed revision，再按
[实现交接准备](../../checks/review-261030/implement-handoff.md)启动 QCP workflow。
函数体证明仍限于 `KSemaphoreDelete`、`_SemaphoreDelete`、`LinklistResumeAll`；20 个外部契约与 8 个模型/信任边界不重证。
资源转换、循环、批量效果连接和 strategy 正确性仍待证明。

## 以下为历史状态

2026-10-29：当前工作版本为 `KSemaphoreDelete-spec-r9` / `KSemaphoreDelete-pred-r7`。
已同步 VRTOS 新增的等待队首接口；LinklistResumeAll 选用 `semaphore_pending_head_ic`，
逐步效果采用 `wakeup_semaphore_head`，整体效果继续使用 `semaphore_resume_all_effect`。
共享库构建、类型、接口一致性及 C 语法检查通过；本次只更新设计，没有运行 QCP 或实现证明。
未将旧 revision 的审阅结论沿用为本版结论。无需用户操作。
详见 [本次变更记录](design-changes/2026-10-29-1-wakeup-pending-head.md)。

本次实现证明范围：3 个目标函数、20 个外部契约依赖、8 个模型/信任边界。
完整名单与责任划分见 [实现证明范围](verification-scope.md)，机器清单为
[`checks/verification-scope.json`](../../checks/verification-scope.json)。

2026-10-28 历史同步版本为 `KSemaphoreDelete-spec-r8` / `KSemaphoreDelete-pred-r6`，
已通过共享库构建、类型、C 语法和接口一致性检查，未进行独立审阅或 QCP 实现证明。
范围仅为根共享库/注解及 1025 trial；旧审阅记录对应旧 revision。
详见 [VRTOS 同步记录](2026-10-28-vrtos-sync.md)。

2026-10-28：当前为 `KSemaphoreDelete-spec-r7` / `KSemaphoreDelete-pred-r5`（定向设计审阅通过）。
LinklistResumeAll 只保留 semaphore_waiters 封装版，使用 semaphore_resume_all_effect 描述任务、延时、就绪队列及 pending 的整体结果。
旧 steps 只作循环证明辅助，nil 分支为 after=before；合法资源下的整体/逐步连接列为待证命题，尚未证明。
候选和共享库编译、三项模型检查、最终单规格的 caller 一致性与 C 语法检查通过；详见 [规格设计](spec-design.md) 和 [predicate 设计](predicate-design.md)。
本次抽象删除命令依赖也随之更新，旧相关实现证明不能直接作为新 revision 的证明；本轮未启动实现验证。

按用户要求，旧 implement 阶段新增的 QCP/Rocq 工作区、运行记录、证明产物及实现检查报告已移出 trial。当前源码、predicate/spec、修订快照和设计检查保留；当前 revision 尚未进行实现验证。
当前修改及检查见 [规格设计](spec-design.md)、[定向审阅](spec-review.md) 和 `checks/spec-revision.json`。

## 完成范围与修复

采用当前非 SMP、32 位验证配置，先按《源代码处理》适配，再检查 23 个真实 active body 及 8 个模型/信任边界。覆盖负 ID、非负 ID 的 uint16 转换与未命中、lazy 空桶初始化、有/无等待者、逐项写 exstatus=-ERROR 和唤醒、ID 注销、摘链、锁外释放，以及条件调度模型。源码与 ABI 依据见 [C 分析](c-analysis.md)、[适配清单](adapted-closure.md)及[切片检查](candidate-source-check.md)。

独立审阅完成两次修复闭环：P1 将信号量等待节点改为真实嵌套 `task_dync_sched_member.sched_link`；S1 恢复四类 typed container 接口，使通用查询不用额外加强 Require。另保留原 RUNNING 条件并补充有生命周期依据的 SUSPEND bitmap 一致性；纠正 `IdRemoveObj/current_node` 对完整删除出口的描述，保持内部 `RemoveObj` 摘链后仍持旧 ID 与完整删除最终写入 65535 的区别。旧错误规格的证明结论不能直接沿用。

## 共享合并与检查

正式函数定义见 [KSemaphoreDelete.v](../../../lib/KSemaphoreDelete.v)，完整设计见 [predicate-design.md](predicate-design.md) 和 [spec-design.md](spec-design.md)。目标规格见[当前 trial canonical](../../annotated_C/src/KSemaphoreDelete.c)，全局新增规格见[共享 canonical](../../../annotated_C/src/KSemaphoreDelete.c)。

合并使用复制基线、trial 修订与全局最新版本核对，没有覆盖期间的其他工作。新增/修改库、复用规格的增量及所需类型头均已进入根目录；已有多函数 C 的可执行 token 保持。根 `_CoqProject`、Makefile 和共享索引已更新。Trial 的活动引用使用 `CRTOS_Verify.lib`，留存的 trial/lib 审阅副本不再配置到构建路径。

- 根项目重新编译 8 个库：TaskInv、SemaphoreInv、CrtosInv、KTaskUnSetDelay、KTaskWakeup、SemaphoreOps、KSemaphoreDelete，以及受影响的 KSemaphoreCreate，全部 exit_code=0。见 [root build](../../checks/root-library-build.log)。
- 迁移后 137 项 formal 名称/类型/投影检查通过；23 个 C 切片的语法、唯一 active body、保留调用范围及 caller/canonical contract 一致性检查通过。
- 原始头、位域适配头和切片头的 ILP32 ABI 检查通过；31 个权威源码、配置和 TrustBase 输入哈希未变。
- [合并结果](../../checks/merge-result.json)和[迁移检查](../../checks/migration-check.json)记录文件对应及检查结果；全局新增库不依赖 trial 路径。

## 结论限制与下一步

设计阶段的检查不等于 C 实现已证明。后续实现验证须基于当前 revision 重新配置工作区并启动正式 workflow。资源转换、循环保持、全局不变量重建及新增不变量的上游保持义务仍须在实现证明中完成。`KTASK_ASSIGN` 使用文档规定的抽象模型，当前设计范围为非 SMP、32 位验证配置。

清理备份及文件清单：`/tmp/ksemaphoredelete-trial-261025-1-implement-backup-tyoe5rhw`。`_CoqProject` 已恢复共享依赖路径，并移除被清理的本地证明目录映射。
