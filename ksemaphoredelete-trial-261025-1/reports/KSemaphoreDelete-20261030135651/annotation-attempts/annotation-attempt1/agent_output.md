# KSemaphoreDelete annotation

Signature 为 void KSemaphoreDelete(int32 id)。沿用已确认的 pred-r7/spec-r9：入口持有 OutsideCritical 和 abs_semaphore_delete 的 safeExec continuation；正常返回保留该 continuation 并返还更新状态的 OutsideCritical。冻结的 Rocq program 与 C contract 已表达同一行为，本轮不重写。

函数体只有一次 _SemaphoreDelete 调用；现有 where 已实例化 sg/before/X，没有循环或额外 predicate。保留 C 与 canonical/caller-local spec 原文。_SemaphoreDelete 的函数体证明在单独 run 完成，本 run 不把它计作已证依赖。

检查：formal-case-lib-design、controller symexec、formal-case-lib 均 exit 0/status passed。没有修改目标 C 或 seed case lib。生成 3 个显式 proof worklist 项：return_wit_1、partial_solve_wit_1_pure、partial_solve_wit_1；命题只需选择 callee 返回的 after 并保留已有 safeExec 事实与 OutsideCritical 资源，未见 annotation 缺口。proof manual 未手改，生成占位项由后续 proving owner 完成。本轮为首次 attempt，无 failed VC comparison。
