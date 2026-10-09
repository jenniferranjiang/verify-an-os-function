---
name: verify-os-function-with-qcp
description: 为使用 QCP 和 Rocq 验证操作系统 C 代码提供系统专用 knowledge 路由与工程适配；与 verify-c-function-with-qcp 的通用验证流程配合使用，当前包含 CRTOS 知识和参考快照。
---

# 操作系统验证 Knowledge 适配层

本 skill 不重复 predicate、spec、review、symbolic、VC 和 proof 的通用流程。处理操作系统 C 代码时，必须同时加载并遵循 $verify-c-function-with-qcp；本 skill 只补充系统专用事实、工程路径、并发协议和参考材料。

## 叠加规则

1. 通用流程与质量门禁来自 $verify-c-function-with-qcp。
2. 系统专用事实来自当前配置的权威源码和对应 knowledge profile。
3. Knowledge snapshot、经验文件和示例不自动成为可信结论。
4. Knowledge 与权威源码/config 冲突时，以权威输入为准并标记 [OPEN]。
5. Knowledge 不得放宽唯一 ownership、路径完整性、contract 强度、proof 或 trust 检查。

## 按阶段加载

### Context

先确定目标系统和配置，再完整读取对应 profile。CRTOS 任务先读 [CRTOS 公共知识](references/platforms/crtos/knowledge.md)。

### Predicate design

目标是 CRTOS 时，在通用 predicate 指南之外完整读取 [CRTOS Predicate Knowledge](references/platforms/crtos/predicate-knowledge.md)。它再按需路由 predicate 经验和 Task lib。

CRTOS Task lib 是通用 skill 所说 existing proof library 的一个具体候选。必须按 example-only、reviewed-interface、proved 或 user-approved trusted 分类；不得因为位于快照目录就视为 proved。

### Spec design

目标是 CRTOS 时，在通用 spec 指南之外完整读取 [CRTOS Spec Knowledge](references/platforms/crtos/spec-knowledge.md)。它再按需路由 spec 经验。

### Implement 与 review

使用 profile 中确认的 trial layout、logical path、QCP strategy、工具路径和共享库位置。通用审批门、closure、symbolic、VC、proof 和 final-integrity 条件保持不变。

## 示例材料

references/examples/los/ 只用于必要时参考 QCP 注解和定义组织。它不是 CRTOS 语义来源，也不是已证明依赖；使用前检查 assumptions、占位证明和与当前工具版本的兼容性。

## 新增系统 profile

在 references/platforms/<system>/ 中建立独立入口，至少说明：

- 适用配置和权威源码；
- workspace、logical path 和工具配置；
- 状态、并发与生命周期专用事实；
- 可复用定义、快照及其可信状态；
- 当前已知限制和 [OPEN]。

不要把新系统的路径、符号、状态机或默认配置写进 $verify-c-function-with-qcp。
