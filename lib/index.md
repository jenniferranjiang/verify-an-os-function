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
| `dataqueue/` | 队列状态及Init/初始化回滚/Peak/Pop/Push抽象程序；共享资源表示位于common/DataqueueInv |
| `isr/` | ISR 状态与管理不变量 |
| `pendlist/` | 共享等待链挂起及优先级插入语义 |
| `id/`、`list/` | ID manager 和通用链表规格 |
| `common/` | 全局组合状态、全局不变量、临界区协议、配置、布局及通用基础库 |

示例：`Require Import CRTOS_Verify.lib.task.TaskState.`。
当前统一使用恢复的完整任务模型，`common/CrtosGlobState.v` 组合各模块状态，
`common/CrtosInv.v` 组合它们的空间不变量；不再保留平铺与模块化的同名副本。
`ObjectWaitNode.v` 保留独立的纯地址辅助定义，不拥有 task descriptor。

QCP基础库按工程配置直接引用，全局库由根 `_CoqProject` 管理。Dataqueue的模块状态直接接入 `CrtosGlobState` 与 `CrtosInv`，已有模块空间定义使用同一全局Assertion；共享更新保持未触达的dataqueue分量。

Dataqueue设计、已批准源码副本修复及当前限制见 [设计说明](../.docs/Report/dataqueue/2026-11-16-InitDataqueue-DataqueuePeak/design.md) 和 [整合检查](../.docs/Report/dataqueue/2026-11-16-InitDataqueue-DataqueuePeak/integration-review.md)。设计和类型检查不等于C实现证明，原有证明的适用状态以当前依赖检查结果为准。

Pop/Push 本轮仅设计与审阅的输入及完整调用闭包见 [Pop/Push设计说明](../.docs/Report/dataqueue/2026-11-18-PopDataqueue-PushDataqueue/design.md)。Semaphore Obtain/Abandon 描述计数、挂起、超时及唤醒路径；设计审阅不等于这些实现已证。
