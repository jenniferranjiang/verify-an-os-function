---
kind: final-integrity
status: pending
target_function: "<function>"
source_revision: "<revision>"
approved_predicate: "<predicate-review-path-and-revision>"
approved_spec: "<spec-review-path-and-revision>"
checked_by: "<reviewer-or-main-agent>"
---

# 最终完整性检查：`<function>`

> 本记录只汇总实际命令和结果，不重新解释 predicate/spec 设计。Proof 候选完成时做 full check；修复后只重跑失败项和受影响项。

## 1. Annotated C

| 检查 | 命令或 diff | 结果 |
|---|---|---|
| 与权威 C 相比只增加/修改注解 |  | `pass|fail|not-run` |
| 当前配置下可执行路径一致 |  | `pass|fail|not-run` |

## 2. QCP 与 VC

| 项目 | 结果 |
|---|---|
| QCP symbolic execution |  |
| Generated VC count |  |
| Proved VC count |  |
| Remaining VC |  |
| Goal 完整、未删除/弱化/隐藏 | `pass|fail|not-run` |

## 3. Rocq 与可信性

| 检查 | 命令 | 结果 |
|---|---|---|
| Rocq compilation |  | `pass|fail|not-run` |
| Assumptions/`Parameter/Axiom/Admitted/admit` scan 与分类 |  | `pass|fail|not-run` |
| Approved statement/spec 与 proof 对应 |  | `pass|fail|not-run` |

## 4. 失败项

| ID | 证据（file:line、symbol 或命令输出） | 具体失败 | 影响 | 下一步 |
|---|---|---|---|---|
|  |  |  |  |  |

## 5. 结论

- `verified|not-verified|partially-verified`：
- 未运行检查及原因：
- 剩余问题：
- 本次是 `full|affected-only`，触发原因和检查范围：

只有所有必需检查为 `pass`、全部目标 VC 已证明且没有未批准可信依赖时，才能写 `verified`。QCP 自动生成文件中
工具保留的 `Admitted` 必须单独列出，不能误报为人工 proof，也不能用它声称对应 VC 已证明。
权威 C、approved predicate/spec revision 或生成 goals 变化时，原结论失效并重新做 full check；不得在输入未变化时重复检查。
