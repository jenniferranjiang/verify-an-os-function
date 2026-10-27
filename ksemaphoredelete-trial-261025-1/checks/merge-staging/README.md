# 规格增量合并暂存

本目录只准备 `KSemaphoreDelete-spec-r2` 的全局增量；未写全局文件，也未修改冻结候选。主 agent 应等待正式审阅结论，再按 `manifest.json` 的 `baseline_sha256` 与全局最新版本进行三方核对。文件树相对于 CRTOS 根目录，`diffs/` 是可读差异。完整复制时基线在旁边的 `checks/merge-baselines/`。

共暂存 27 个目标文件：13 个已有文件（其中两个内容未变）、12 个新增 canonical C 及两个新共享头。已有多函数 C 的全部可执行 token 保持；原函数体、证明注解、未参与本轮的函数及具名规格没有删除。当前 canonical spec 中的纯空指针常量 KNONE=0 等价迁为 0，未定义的 KNONE 词汇声明移除。ID current_node 的语义修正单独在 `m_id.h` 差异中可见；RemoveObj 恢复真实指针返回声明，增加 FreeId、found_node 和 absent_node。

新增 C 直接使用 `annotated_C/include/{slice_types,logic}.h`。这些头不集中任何 C 函数 API contract。新 logic 的所有逻辑路径已从 trial 前缀变为 `CRTOS_Verify.lib`，不存在 trial 专属路径。

## 历史证明依赖的处理边界

对拥有实际定义的 TaskStatusMemory、DoubleLinkListSpec、NodeSelfLinked 和 GetTaskWithIdnodeInside（现在由 KTaskWakeup 提供）直接迁移 import。delay 的三个旧语义模块以本轮重建的 KTaskUnSetDelay 接口替代。m_double_linklist 仅使用的 RRR 资源语义也已由新 KTaskWakeup 提供。

其他旧 `libai` 模块同时携带未恢复的证明辅助词汇，不能仅改前缀便称其已迁移。因此旧多函数/证明文件保留那些导入，并额外导入本轮选定 canonical API 需要的实际语义模块。具体保留项在 manifest 每个文件的 `remaining_libai_imports` 中列出：AssignInCritical、AssignCommon、AssignStat、KTaskSetDelay、RRR_ReadyInsert、旧 KTaskWakeup。未修改的 m_ktask.h、task_sched_view.h、delay_views_strategy.h、ready_cache_strategy.h 还保留 AssignReadyPending、TaskOwnedMemoryLemmas、TaskSchedViews、KTaskSetDelayTaskFrame、ReadyCacheViews 等历史依赖。

这些未恢复内容是原有证明注解的依赖，不参与本轮冻结的一函数一文件试验构建；本轮 canonical C 的类型、正式词汇与路径检查使用独立的新头和合并后的共享库。合并暂存因此只恢复本轮 API 及其正式语义，不宣称旧 annotated_C 全树或旧证明工程可整体重编译。若以后选择继续使用旧证明注解，必须先恢复对应辅助模块，不能把本次设计审阅当作它们已验证。

`body-preservation.json` 核对旧 C 去注释/空白的 token 串完全一致。无实现证明、QCP 解析或 VC 在本阶段运行。准备脚本在 `checks/prepare-spec-merge.py`，只能用于重新准备暂存，不执行全局写入。

## r2 container 修复的合并

新增/修复的 canonical 调用使用 CONTAINER_OF_IDNODE_LINK、CONTAINER_OF_SEMAPHORE_ID、CONTAINER_OF_TASK_ID 和 CONTAINER_OF_TASK_SCHED。现有 get_task_with_idnode.c 已使用与 r2 相同的 TASK_ID；现有 rrr_ready_vector_insert.c 已使用 m_ktask.h 的 TASK_SCHED。因此保留这些既有函数体，不为此次合并再次改写普通 C 语句。m_ktask.h 也被纳入基线/接口核对，所选 TASK_SCHED contract 保持原文，包括已有对齐要求。四接口的 typed 字段关系属于已授权宏处理，空资源不授予额外对象内存；没有加入新的布局公理。
