# Trial 保存与清理约定

使用现有 GitHub 仓库 `jenniferranjiang/verify-an-os-function`，在 `main` 上按 trial 目录管理。无需为每个 trial 新建分支。

- 提交注解 C、predicate/spec、正式 VC 与手写证明、构建/适配脚本、依赖版本、审阅记录、最终检查结果及必要的故障证据。
- `verification_runs/**/_coq_builds/` 是可重建的编译工作目录，新增内容不提交；`.vo`、`.glob`、`.vos`、`.vok`、辅助文件和 Python 缓存不提交。
- 成功 run 保留正式 `VC/`、controller 状态、最终检查记录、输入映射和必要证据。保留记录中的条件与外部契约边界，不把导入契约计为本轮实现证明。
- 失败 run 被成功运行替代后可以清理；删除前提取其中独有的源码、手写证明或最小复现现场，并记录旧路径和归档位置。尚未解决的问题保留最小现场。
- 清理旧 trial 前先确认源码和关键证据已经提交并推送，且依赖版本可定位。随后可以从当前目录删除并提交删除，必要时通过 Git 历史恢复。
- 删除已提交的大文件不会减少旧 Git 历史；现有历史不在日常清理中改写。

当前 `ksemaphoredelete-trial-261025-1` 的正式语义库使用全局 `lib/`。23 个函数的 40 个公开契约与全局 `annotated_C/` 对应位置一致。实现阶段的函数体注解、工具适配及 `VC/` 证明仍保存在 trial，不能仅凭 predicate/spec 已同步就删除该 trial。

2026-11-01 的逐文件核对与清理记录：

- [同步核对](checks/trial-maintenance-20261101/sync.json)
- [清理清单、空间变化及失败源码归档索引](checks/trial-maintenance-20261101/cleanup.json)

上述记录是文件、契约及既有最终检查证据的核对，没有重新运行 QCP 或重新证明函数。需要重跑时，按 trial 中保留的工具链和验证流程重建编译产物。
