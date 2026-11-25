---
name: verification-report
description: 整理 OS 验证的设计、审阅、源码缺陷及最终或阶段报告，核对全局一致性、证明范围和信任限制并按规则收尾。
---

# 验证报告与收尾

沿用主编排的[共用约束](../os-verification-coordinator/SKILL.md#通用验证约束)与[环境配置](../os-verification-coordinator/CONFIGURATION.md)，复用已有上下文及有效授权。

### 临时产物与保留边界

开始任务及首次修改已有文件时，按[最终报告的统计要求](references/reporting-guide.md#最终报告)记录修改前基线，供证明完成后的统计使用。

验证工程的 `.docs/Report/` 只保存人工可读的当前设计、审阅、错误和最终完整性记录。不把完整 formal source、控制器每步返回、编译目录或多份状态摘要复制进报告目录。

验证中仍在使用的 QCP `reports/`、`verification_runs/` 和正式 `VC/` 由 verification-orchestrator 管理，main agent 不自行整理、改写或提前删除。需要暂存的编译输出、对比快照、一次性脚本和工具日志放入为当前任务新建的 系统临时目录中的 `crtos-verify-<task>-<purpose>-XXXXXX/`（用 `mktemp -d` 创建，尊重 `TMPDIR`）；不用仓库 `.docs/` 充当工作区或备份目录。

一个阶段结束时执行一次收尾：

- 未完成时保留当前 formal 输入、证明、恢复所需状态和有效记录；完整验证结束后，输入及证明保留在全局位置，设计说明长期保留，其他记录按报告指南整理。
- 默认保留当前工程的 `.vo`，供编辑器交互式加载依赖；不得仅因它们可重建或本阶段结束而删除。仅在用户要求清理、修复已确认的缓存失效时清理相应范围。修复失效缓存时只重建受影响依赖，并保留重建后的 `.vo`。
- `.vos/.vok/.glob/.*.aux` 和 tactic cache 不一律保留：仅在当前工具或构建流程实际需要时保留，否则可在阶段收尾时清理。采用依赖 `.vos` 的快速编译流程时，须保留其加载所需产物，不能机械地只留 `.vo`。
- 删除重复 VC 副本、已被后续成功尝试取代且不再用于当前交互式工作的临时工作区，以及人工另存的 claim/finalize/step 回执副本。
- 任务中的 `/tmp` 备份只保留到目标写入、比较和必要检查成功；对应阶段结束后立即删除。不删除编辑器、Codex 或其他任务拥有的临时目录。
- 清理前确认目标没有被运行中的进程使用，且所依赖的最终摘要已存在。清理后检查报告链接、当前 revision 和正式构建输入未被损坏。

## 全局一致性检查与收尾

输入和证明直接维护在全局位置。用户确认revisions且controller返回 `done`（含 `final-check`）后，main agent完成以下收尾：

1. 按[统计要求](references/reporting-guide.md#最终报告)记录manual/lib相对于修改前基线的增量，保留已有定义、spec、证明和其他任务内容。
2. 确认根构建、imports、逻辑路径、工具及编辑器引用一致，编译受影响的库及依赖者，实现目标检查到goal_check。复用同版本成功检查，不为收尾重复整库构建或重新生成VC。旧结论因共享修改不再适用时明确标记并处理，不能借旧 `.vo` 或旧done记录宣称当前版本通过。
3. 按[保留规则](references/reporting-guide.md#完成后保留什么)保留并更新设计说明，整理最终验证报告与源码缺陷记录，链接当前全局文件、revision、结果及剩余限制。
4. 完成[最终完整性审阅](../predicate-and-spec-design/SKILL.md#审阅内容与通过条件)，清理已不需要的任务临时产物，保留 `.vo` 和仍在使用的workflow恢复状态。不删除全局lib、annotated C或VC。

仅设计审阅或尚未完成证明时，保留当前输入与有效记录，明确draft、review-passed、未证或invalidated状态，不因文件在全局目录就报告验证完成。设计改变和证明恢复沿用同一全局输入，未解决的依赖问题如实报告。
