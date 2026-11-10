# CRTOS 共享验证库

共享库使用 `CRTOS_Verify.lib` 逻辑根，各文件按模块归档，根 `lib/`
不放 `.v` 文件。根 `_CoqProject` 管理构建清单。

| 目录 | 内容 |
| --- | --- |
| `task/` | TaskState、TaskInv、任务状态、描述符、栈、唤醒与 exstatus |
| `assign/` | 调度状态、不变量、ready vector、bitmap 与任务调度 |
| `delay/` | 延时状态、不变量、设置与取消延时 |
| `tick/` | tick 不变量与顺序 |
| `event/`、`mutex/`、`semaphore/` | 各同步对象的状态、不变量、操作及创建/删除规格 |
| `isr/` | ISR 状态与管理不变量 |
| `id/`、`list/` | ID manager 和通用链表规格 |
| `common/` | 全局组合状态、全局不变量、临界区协议、配置、布局及通用基础库 |

示例：`Require Import CRTOS_Verify.lib.task.TaskState.`。
当前统一使用恢复的完整任务模型，`common/CrtosGlobState.v` 组合各模块状态，
`common/CrtosInv.v` 组合它们的空间不变量；不再保留平铺与模块化的同名副本。
`ObjectWaitNode.v` 保留独立的纯地址辅助定义，不拥有 task descriptor。

QCP 使用已有的 `../qcp-binary-democases` 安装；试验通过 `-R ../lib
CRTOS_Verify.lib` 导入共享库，不再持有 `.provider` 快照。
来源和验证范围见 `TASK_MODEL.md`。按用户要求，本次仅整理路径和静态检查，
不运行编译；历史试验结果不等于当前版本已经通过验证。
