# KMutexDelete predicate 独立审阅

2026-11-10，reviewer：checked_revision_review（非作者）。当前结论：`needs-fix`。
旧版 `review-passed` 不适用于本次修改后的抽象程序；本记录替换旧结论。

审阅对象为 `lib/MutexState.v`、`lib/MutexInv.v`、`lib/KMutexDelete.v`，版本见
当前 revision manifest。前两个文件未改，继续直接复用全局 `mutex_inv`、`os_inv`
和原 critical protocol。此次实际语义变化位于 `KMutexDelete.v`：三个公开抽象程序
增加 `sg`；目标对象存在性与注销前 pending 为空改由 `assertS` 检查，不再由 C
接口公开对象描述符 witness。指针非空仍按既有约定写在 program 中。

## 尚需修正：入口检查与现有环境模型未衔接

`mutex_resume_entry_condition` 对输入状态集合中的每个 `observed`，要求
`os_inv sg observed` 能推出目标地址 `p` 存在；`mutex_detach_entry_condition`
还要求该对象的 pending 为空。两项都经 `assertS` 进入错误语义，因此不能再像旧版
`err=False` 且无正常后继时那样，由 liberal `safeExec` 真空满足。

但 pinned provider `CrtosRules.v` 中的 `Crtos_CS` transition 为 `True`，
`Crtos_RTrans` 直接复用该关系，`LastSeen before` 所指定的状态集合因而包含所有
`VarGlobalState`。每次 `task_atomic_cmd` 完成后也重新得到这种集合。因此当前检查
实际要求固定 `p` 存在于同一 `sg` 下所有可由 `os_inv` 表示的世界，注销检查还要求
它在所有这些世界中都没有 waiter。合法入口恰好含有该对象，并不能推出这些条件。

用户批准的 A1--A3 是本实验执行轨迹的限制，能排除目标被其他删除回收、排空后新增
waiter、跨删除裸指针访问；它们没有被现有 `True` rely 表达，也不能推出上述对全部
世界的条件。尚未给出有效对象删除路径上入口 `safeExec` 可满足、且多段临界区之间
能保留所需条件的依据。这里不声称已在 Rocq 中证明该前提绝对不可满足；审阅结论是
当前设计缺少正常合法调用的非真空性依据，不能标为通过。

修复应保留用户要求的指针级公开接口，说明已批准执行范围怎样在抽象程序与共享
critical 接口之间发挥作用。不能把 `obj` 加回公开 `Require/With`、把 `assertS`
改成无错误的过滤来隐藏问题、擅自加强 Lock 契约，或引入新的未批准信任。

## 检查范围

独立核对了原始 `mutex.c` 中的 `_MutexDelete/KMutexDelete`、`linklist.c` 中的
`LinklistResumeAll`，以及 provider 的 `LastSeen`、`task_atomic_cmd`、QCP 的
`assertS`、`safeExec` 和 weakest liberal precondition 定义。C 执行次序与未改的
对象内存交接不因本次接口修改而改变。

作者执行的编译证据：QCP 依赖重建 exit 0；trial 使用 pv-bench-8.20.1 的
`make -f Makefile.coq -j4` exit 0，三个本地正式文件编译成功。按 `_CoqProject`
完整 `-R/-Q` 配置编译 `checks/ExternCheck.v` 同样 exit 0，确认两个 entry condition
与三个带 `sg` 参数的公开程序类型。Reviewer 独立检查对应四个 `.vo` 均已生成；
未重复全库编译。类型正确不能消除上述语义问题，因此维持 `needs-fix`。
未运行 QCP parser、symbolic、VC 或 C 实现证明。
