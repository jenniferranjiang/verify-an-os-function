# Implement

用户确认 predicate/spec revisions 后，main agent 完整读取
`/home/xinra/qcp-binary-democases/AGENTS.md`，沿用现有 trial 工程，从它指定的
`verification-orchestrator` 入口启动 QCP workflow，并把批准的 predicate/spec 当作冻结输入。

## QCP工具适配

设计与审阅阶段已有的 trial 文件结构是 implement 必须遵循的工程格式。验证继续使用现有 annotated C、库文件、`_CoqProject` 和其中的外部库引用，文件组织与库引用按[工程配置指南](project-configuration-guide.md#trial-与全局库)保持不变，不重新配置为 QCP 示例仓库的结构，不复制整套依赖或示例，也不改写已有逻辑命名空间。

由 QCP 工具适配本 OS 工程，而不是让 OS 工程迁就 QCP 的默认目录约定。当前 controller 的固定目录和工程内依赖限制不能直接支持上述格式，应在 implement 中完成 QCP 工具侧的必要适配：读取现有工程配置、解析现有输入及外部库路径，并按 trial 的文件组织处理验证产物。适配范围以支持本实验为准，不要求先建设通用工具框架，也不能仅修改本指南便视为工具已支持。

交接时提供现有输入文件和工程配置的位置；符号执行、依赖分析、证明编译和 final-check 均须使用一致的路径映射，并实际检查适配生效。

## Annotation 阶段适配

本 OS 验证流程允许在函数体中按验证需要使用 `by local`、call `where`、branch-control、普通 `Inv`、multi-inv 等 QCP 合法注解。Annotation 阶段可以新增或修正这些注解，不要求提前在 spec-writing 阶段全部填写。

例如，可用 `by local` 从已有前提或存储资源推出 `value` 的范围；可用 call `where` 显式实例化契约中的 `With` 逻辑参数、类型参数或选择适用的具名 spec。范围事实及调用前置条件仍须证明；分支与循环注解须覆盖真实可达路径并保留相应证明义务。不得借此添加无依据假设、遗漏资源或改变可执行 C 的行为，冻结 predicate/spec 的语义变更仍按原审批和审阅流程处理。

Main 交接 annotation 任务时须明确传达本节的 OS 适配规则。

## 验证范围与执行

交接时分开列出本轮实现证明目标与从根 annotated_C 导入的 `reused-spec` 边界，附复用来源、revision 和 contract。
按[工程配置指南](project-configuration-guide.md#已有-spec-的复用与特化)，导入复用函数不生成本轮实现 VC，也不重新证明函数体；保留其函数文件不表示要将其提交为证明目标。
之后只执行 controller 返回的 action，直到 controller 报告 `done` 或明确 blocker；不要在本 skill
中复制 QCP 的阶段、命令、返回状态或 final-check。
