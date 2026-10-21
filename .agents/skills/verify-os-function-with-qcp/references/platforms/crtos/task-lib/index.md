# Task lib 参考快照

本目录完整保存 `/home/xinra/vrtos/lib/` 的 13 个 Rocq 文件，来源 revision
为 `8e01372`，复制日期为 2026-08-25。它用于在设计新的 CRTOS 模块时参考
predicate、ownership、全局状态、不变量和证明文件的实际组织方式。

目标模块的真实 C、当前配置及当前 trial 已有的正式定义始终优先。本快照只提供
项目实例，不应通过替换 Task 名称、字段或状态直接复制成新模块设计。guide 中的
Task 代码块用于解释原则；需要精确 symbol 时，以本快照为准。

文件分组：

- 纯状态：`KTaskPure.v`；
- 对象、字段和外部栈 ownership：`KTaskDescriptor.v`、
  `KTaskSchedMember.v`、`KTaskStackSetup.v`；
- 函数局部前后状态：`KTaskParseInfo.v`；
- 全局状态、不变量和并发规则：`CrtosGlobState.v`、`CrtosInv.v`、
  `CrtosRules.v`；
- 证明辅助：`KTaskStackSetupProofAux.v`；
- 通用容器依赖：`dll_abs.v`、`dll.v`、`idnode_abs.v`、`idnode.v`。

已知边界：

- 当前内容主要覆盖 `KTaskCreate` 和初始化流程，不代表完整 Task 生命周期；
- `KTaskStackSetup.v` 现存两个 `Axiom`，只能用于了解现状，不能作为新定义
  或证明的可接受范式；
- `CrtosRules.v` 依赖未收录在本目录的 `libai/TaskProtocolSTS.v`，并发实例
  并不自包含；
- `KTaskDescriptor.v` 使用的两个 event 字段布局来自验证切片，与原 CRTOS
  共享 29/3 位 bitfield 的 ABI 不等价。
