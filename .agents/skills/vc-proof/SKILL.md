---
name: vc-proof
description: 在 OS predicate/spec revisions 已审阅并获用户批准后，交接 QCP 工作流完成 annotation、VC、manual proof 与 final-check。
---

# VC Proof

沿用主编排的[共用约束](../os-verification-coordinator/SKILL.md#通用验证约束)与[环境配置](../os-verification-coordinator/CONFIGURATION.md)，复用已有上下文及有效授权。

库、示例及已有证明的查找与复用遵循主编排的[库与证明参考](../os-verification-coordinator/SKILL.md#库与证明参考)。

## `implement`

只有用户明确确认 review-passed predicate/spec revisions 后才能进入。Main agent 读取
已配置 QCP 根目录中的 `AGENTS.md`，按[路径配置](../os-verification-coordinator/references/project-maintenance-guide.md#implement-阶段的-qcp-路径配置)将验证工作目录指向验证工程根目录，按[QCP工具适配](references/implementation-and-validation-guide.md#qcp工具适配)要求由 QCP 工具适配本 OS 的全局工程格式，从其中指定的 `verification-orchestrator` 启动 QCP workflow，
把已批准 predicate/spec 作为冻结输入，然后只执行 controller 返回的 action，直到 `done`、明确 blocker 或达到证明时间预算。

开始目标证明前，按[工具就绪条件](references/implementation-and-validation-guide.md#证明前的工具就绪条件)确认环境已配置可用；同一环境复用已有成功结果，之后按 QCP workflow 推进。环境错误先修复。

交接时要求按[VC 证明顺序](references/implementation-and-validation-guide.md#vc-证明顺序)从底层依赖往上证明：先完成本轮范围内的 callee 及所需 lib 引理，再推进上层 caller，由 QCP controller 安排执行。

交接时落实[每个目标函数累计 150 分钟的 VC 证明预算](references/implementation-and-validation-guide.md#vc-证明时间预算)，到时保存状态并等待用户决定是否追加时间。

交接时提供实际采用的 trusted specs、工具适配假设及用户信任说明的文件路径与章节，并明确按 spec 设计确定的本轮实现证明目标与 `reused-spec` 清单；导入复用函数不提交为 VC/函数体证明目标，也不因其证明状态自动扩大范围。复用依赖的证明状态和结论限制须随交接传递，不能将其冒称为已证或自动改标 trusted。trusted 和 reused-spec contract 均不作为本轮新完成的实现证明计数。

已采用审阅白名单时，要求 QCP annotation owner 及后续涉及设计检查的任务直接通过白名单中描述情况，但不因此跳过任何实际 VC。

交接给 QCP workflow 时必须明确 VC 文件修改边界：手工完成 VC 证明只修改 `*_proof_manual.v`；不得手工修改 `*_proof_auto.v`、`*_goal.v` 或 `*_goal_check.v`。

Annotation、spec、predicate、VC 和 proof 的诊断、修正与重试全部由该 workflow 按自己的规则处理；
main agent 不再定义第二套步骤或返回状态。具体调用边界见
[implementation-and-validation-guide.md](references/implementation-and-validation-guide.md)。
