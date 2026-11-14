# 共享依赖迁移（2026-11-10）

原 `.provider/crtos-8a16/lib` 的完整任务模型已恢复到共享库并按模块归档。
任务文件放在 `lib/task/`，调度、延时和 tick 分别放在 `assign/`、`delay/`、
`tick/`；同步对象文件归各自模块，全局状态与临界区协议放在 `common/`。
不保留根目录平铺副本、legacy 目录或 task-free 同名副本。

试验通过 `-R ../lib CRTOS_Verify.lib` 导入共享库，例如
`CRTOS_Verify.lib.task.KTaskWakeup`；QCP 使用已有的
`../../qcp-binary-democases/Rocq`。本地 `.provider` 已删除。
来源与接口适配见根 `lib/TASK_MODEL.md`。

按用户要求不再编译。这里只检查源码路径和共享模块引用；未宣称当前配置
已完成编译或证明。旧设计报告中的构建与审阅记录属于当时的依赖版本，
刷新后的 manifest 只标识当前输入，不代表新的审批或证明结论。
