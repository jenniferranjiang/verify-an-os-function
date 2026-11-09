# Trial 保存与清理约定

使用现有 GitHub 仓库 `jenniferranjiang/verify-an-os-function`。全局 `lib/` 和 `annotated_C/` 保存在 `main`；所有过去的 trial 集中保存到同一个远端分支 `trial-archive`，确认推送成功后从 `main` 和本地工作目录移除。不为每个 trial 另建分支。

- 提交注解 C、predicate/spec、正式 VC 与手写证明、构建/适配脚本、依赖版本、审阅记录、最终检查结果及必要的故障证据。
- `verification_runs/**/_coq_builds/` 是可重建的编译工作目录，新增内容不提交；`.vo`、`.glob`、`.vos`、`.vok`、辅助文件和 Python 缓存不提交。
- 成功 run 保留正式 `VC/`、controller 状态、最终检查记录、输入映射和必要证据。保留记录中的条件与外部契约边界，不把导入契约计为本轮实现证明。
- 失败 run 被成功运行替代后可以清理；删除前提取其中独有的源码、手写证明或最小复现现场，并记录旧路径和归档位置。尚未解决的问题保留最小现场。
- 清理旧 trial 前先确认完整源码和关键证据已经提交到归档分支并推送，且依赖版本可定位。随后从当前目录删除并提交删除，需要时按下方命令恢复。
- 删除已提交的大文件不会减少旧 Git 历史；现有历史不在日常清理中改写。

`ksemaphoredelete-trial-261025-1` 已保存到 [归档分支](https://github.com/jenniferranjiang/verify-an-os-function/tree/trial-archive)，固定提交为 `f96dd2e20249ed8f55d8a33097de411a97aab9ab`。
其 predicate 已进入全局 `lib/`，23 个函数的 40 个公开契约与全局对应位置一致。
`KSemaphoreDelete.c`、`_SemaphoreDelete.c` 和 `LinklistResumeAll.c` 在全局 `annotated_C/src/` 中与归档的已验证版本逐字一致，包含完整函数体注解。
VC 和证明辅助库保留在归档 trial，不复制到全局。注解中的 `CRTOS_Verify.VC.*` 引用也原样保留；需要重跑验证时恢复 trial，使用其原有项目配置和证明依赖。

按需恢复当前 trial：

```sh
git fetch origin trial-archive
git restore --source=f96dd2e20249ed8f55d8a33097de411a97aab9ab -- ksemaphoredelete-trial-261025-1
```

此前 9 个历史 trial 已集中保存在该分支，当时归档提交为 `8d5877b8d9b27bfc51744723b357876b9a8eacda`。
其中包含 event-create、mutex-create、6 个 semaphore-create 和 semaphore-delete trial；补存了旧临时目录中 150 份源码/脚本快照，保持原相对路径。
归档分支的 `TRIALS.md` 和 `.docs/trial-archive-index.json` 提供完整目录清单。需要恢复其他 trial 时，将上方 `git restore` 的 source 换为该归档提交或 `origin/trial-archive`，并指定对应目录名。
上述 9 个已归档的历史 trial 目录已从本地移除；正在进行的新 trial 仍保留在本地。删除目录释放工作文件空间，Git 历史仍保存在本地 `.git` 中。

2026-11-01 的逐文件核对与清理记录：

- [同步核对](checks/trial-maintenance-20261101/sync.json)
- [清理清单、空间变化及失败源码归档索引](checks/trial-maintenance-20261101/cleanup.json)
- [函数体注解复制、远端分支核对及本地 trial 移除记录](checks/trial-archive-20261101.json)
- [全部历史 trial 集中归档及本地移除记录](checks/all-trials-archive-20261101.json)

上述记录是文件、契约及既有最终检查证据的核对，没有重新运行 QCP 或重新证明函数。需要重跑时，按 trial 中保留的工具链和验证流程重建编译产物。

2026-11-03：`keventcreate-trial-261101-1` 和 `kmutexcreate-trial-261101-1` 的 790 个已跟踪文件已逐文件核对并保存到远程 `trial-archive`，固定提交为 `764bd5919b1b8b301de7c94755cde510bed60d9b`。归档现有 11 个 trial。确认推送成功后，以上两个目录及可重建缓存已从本地移除；全局 `lib/` 的未提交修改保留。需要恢复时执行：

```sh
git fetch origin trial-archive
git restore --source=764bd5919b1b8b301de7c94755cde510bed60d9b -- keventcreate-trial-261101-1 kmutexcreate-trial-261101-1
```

2026-11-09：`keventdelete-trial-261103-1` 和 `kmutexdelete-trial-261103-1`
的当前工作树快照已保存到远程 `trial-archive`，固定提交为
`7e76450cbd41e10b5ff3543a4ae8e4fc30fd7fc1`。归档包含两个目录中当前存在的
已跟踪文件及未被忽略的未跟踪文件，共 1059 个；逐文件 blob 核对无差异。
23 个可重建的 Rocq 编译产物和临时缓存未归档。此次操作只保存既有源码、证明和
验证记录，没有重新运行验证或增加新的验证结论。需要恢复时执行：

```sh
git fetch origin trial-archive
git restore --source=7e76450cbd41e10b5ff3543a4ae8e4fc30fd7fc1 -- keventdelete-trial-261103-1 kmutexdelete-trial-261103-1
```
