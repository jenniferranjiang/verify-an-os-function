# Implement

用户确认 Stage 1 完成并指定进入 Stage 2 后，main agent 完整读取已配置 QCP 根目录的
`AGENTS.md`，按[路径配置](project-maintenance-guide.md#implement-阶段的-qcp-路径配置)
将验证工作目录指向验证工程根目录，沿用现有工程，从它指定的
`verification-orchestrator` 入口启动 QCP workflow，并把批准的 predicate/spec 当作冻结输入。

交接时附默认审阅白名单及已配置的用户补充文件路径、版本、冲突处理结果和本轮适用条目，
指出对应 formal symbols/revisions 与结论限制。QCP annotation owner 及后续涉及设计检查的任务
沿用这些例外，不因同一白名单中已豁免问题要求重新设计；所有实际生成的 VC 仍须证明。

## 证明前的工具就绪条件

确认已有 QCP、Rocq MCP 和项目依赖可用。
同一环境复用已有成功结果，不在每次证明前重复完整验收；环境错误先修复。
环境可用后直接按 QCP agent 的 workflow/controller 完成证明，不额外增加一套验证流程。

## QCP工具适配

### 沿用现有工程

设计与审阅阶段直接维护的全局文件就是implement输入。沿用全局lib、annotated C、VC、根_CoqProject/Makefile与外部基础库路径，保持现有逻辑前缀。按[全局工程规则](project-maintenance-guide.md#全局工作区与依赖维护)处理必要依赖及其检查，保留其他函数的有效输入和证明。

Controller的main-root与MCP的workspace使用验证工程根目录，交接明确本轮canonical文件、批准revision、reused-spec边界和VC输出位置。不能因根目录里存在其他函数就把它们全交给workflow。冻结输入包含本轮实际使用的共享定义版本；依赖变动须按语义影响更新状态及重新检查。

通过验证工程自己的路径配置、构建入口和 controller 已支持的参数对接实际布局，检查输入解析及构建结果。符号执行、依赖分析、证明编译和 final-check 使用一致路径。外部 QCP 等工具的代码、控制脚本和库只读；若现有接口仍无法支持某个布局或检查，报告具体不兼容项和受阻目标。

## Annotation 阶段适配

本 OS 验证流程允许在函数体中按验证需要使用 `by local`、call `where`、branch-control、普通 `Inv`、multi-inv 等 QCP 合法注解。Annotation 阶段可以新增或修正这些注解，不要求提前在 spec-writing 阶段全部填写。

例如，可用 `by local` 从已有前提或存储资源推出 `value` 的范围；可用 call `where` 显式实例化契约中的 `With` 逻辑参数、类型参数或选择适用的具名 spec。范围事实及调用前置条件仍须证明；分支与循环注解须覆盖真实可达路径并保留相应证明义务。若修正需要改变已批准规格的语义，暂停受影响的证明，按[设计变更报告](reporting-guide.md#设计变更报告)结合 C 路径和新旧 spec 说明原因。人类专家审阅并确认新版本后，以该版本恢复证明。

Main 交接 annotation 任务时须明确传达本节的 OS 适配规则。

## 验证范围与执行

交接时分开列出按spec设计确定的本轮实现证明目标与从根 annotated_C 或其他证明工程导入的 `reused-spec` 边界，附复用来源、revision、caller-local contract位置及已知证明状态。旧证明未完成或不能移植不自动扩大本轮目标。
按[工程组织与维护指南](project-maintenance-guide.md#已有-spec-的复用与特化)，导入 spec 只放在 caller 定义前，不为其新建独立函数文件，也不生成本轮实现 VC 或重新证明函数体；工具的闭包检查须识别这类边界，不得因缺少同名 `.c`、proof文件或发现未证依赖而补建文件。依赖契约未获实现证明时，报告caller结论相对于该契约成立，不宣称整个调用链已证，也不自动改标trusted。
之后只执行 controller 返回的 action，直到 controller 报告 `done`、明确 blocker 或达到下述时间预算；不要在本 skill
中复制 QCP 的阶段、命令、返回状态或 final-check。


实际产生VC和证明后，更新长期保留的[设计说明](reporting-guide.md#设计说明)：解释本轮证明目标对应的C路径与资源操作，以及关键义务如何借助lib/spec完成。Controller完成后的收尾按主skill的[全局一致性检查与收尾](../SKILL.md#全局一致性检查与收尾)执行。

## VC 证明顺序

VC 证明按实际依赖从底层往上推进：在本轮实现证明范围内，先完成callee函数的 VC证明，再证明依赖它们的上层 caller。这一顺序不扩大既定验证范围。已有适用且有效的证明直接复用；`reused-spec` 和
已获授权的 trusted 边界仍按前述范围规则处理，并保留其证明状态和结论限制。

## VC 证明时间预算

每个目标函数的 VC 证明累计上限为 **150 分钟**，包含证明尝试和相关编译。重试与恢复沿用已用时间，等待用户及环境故障修复不计入。

交接给 verification-orchestrator 时落实计时与暂停。到时保存可恢复状态，汇报已用时间、剩余义务及主要卡点，等待用户决定是否追加时间。
