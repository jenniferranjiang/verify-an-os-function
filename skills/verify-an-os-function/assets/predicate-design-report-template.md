---
kind: predicate-design
status: draft
module: "<module-or-slice>"
source_revision: "<revision>"
predicate_revision: "<revision>"
formal_sources:
  rocq_files: []
  symbols: []
review:
  reviewed_revision:
  reviewed_by:
  conclusion: "draft|needs-fix|review-passed|invalidated"
---

# Predicate 设计报告：`<module-or-slice>`

> 本报告解释跨 definition、跨文件和模块级设计，不复制 Rocq 定义，也不代替紧邻 definition/statement 的 `.v` 注释。正式语义以所列 formal sources 和 revision 为准。

## 1. Scope 与依据

- 当前配置、模块边界和函数集合：
- 权威 C/headers/config 及 revision：
- 本报告覆盖与不覆盖的内容：
- 用户批准的 trusted symbols、contract/保证与批准证据：

## 2. C 对象与抽象状态

- 模块直接访问或管理的 C 对象及源码证据：
- Abstract state 分量、可观察语义和选取理由：
- Concrete representation 与 abstract state 的整体对应：

只记录整体映射和设计理由；逻辑参数、地址、字段与内存的直接对应留在最接近的 `.v` 注释中。

## 3. Predicate 分层与 Formal Sources

- Rocq 文件、主要 symbols、职责和依赖方向：
- 顶层 predicate 及直接组成部分的分工：
- 对外 view/interface、`which implies` 和预期客户端：
- Predicate revision：

## 4. Ownership 与 Lifecycle

- 稳定状态下的 owner 划分：
- 初始化时 ownership 来源和建立顺序：
- 正常状态转换与临时 ownership：
- 删除、失败路径、回收和最终归还：
- 跨模块借用、转移与不属于本模块的资源：

## 5. 关键设计选择

- 选择及源码/客户端依据：
- 考虑但未采用的方案及原因：
- 必须保持的限制、frame、atomicity/critical 假设：

## 6. 检查结果

- 实际运行的 compile/typecheck 命令和结果：
- Ownership/representation/lifecycle 检查范围和结论：
- 必要复现命令：

## 7. Review Issues

- `<ID>` — `blocker|non-blocker` — `open|fixed|passed|accepted`
  - 证据（file:line 或 symbol）：
  - Mismatch 与具体后果：
  - 最小修改与可执行通过条件：

## 8. Review 记录

- Review ID、predicate revision 与 `full|affected-only`：
- Review scope、触发原因和 dependency closure：
- 剩余 `[OPEN]`/blocker：
- 结论：`needs-fix|review-passed|invalidated`
- Review-passed predicate revision（通过时填写）：
- 用户确认及时间（确认后填写）：
