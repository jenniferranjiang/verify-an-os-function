---
kind: spec-review
status: draft
function: "<function>"
source_revision: "<revision>"
spec_revision: "<revision>"
predicate_review: "<path-and-review-passed-revision>"
formal_sources:
  rocq_files: []
  symbols: []
  annotated_c_file: "<path>"
checks: []
approval:
  approved_by:
  approved_at:
  predicate_revision:
  spec_revision:
---

# Spec 审阅：`<function>`

> 不复制 Require/Ensure 正文。按真实 C 返回路径填写；证据不足写 `[OPEN]`。

## 1. 用普通话说明

- 调用者必须提供什么：
- 成功、失败、早返回或阻塞分别返回什么、改变什么：
- 哪些资源保持不变并返还：
- 使用哪些 reviewed predicates 和 direct-callee specs：
- 本 spec 不承诺什么：

## 2. Review-ready 条件

| 条件 | 证据 | 状态 |
|---|---|---|
| 引用的 predicate revision 为 `review-passed` |  | `ready|open` |
| 全部 return/blocking path 和 direct callees 已列出 |  | `ready|open` |
| Formal pre/post 与 `With/Require/Ensure` 已写出 |  | `ready|open` |
| 每个 load/store 能追溯到 reviewed predicate |  | `ready|open` |
| 适用的 Rocq compile 与 parser/typecheck 已通过 |  | `ready|open` |
| 没有影响路径/effect/ownership/frame/dependency 的已知 `[OPEN]` |  | `ready|open` |

任一项为 `open` 时保持 `draft`，先补 spec，不启动 review。Reviewer 不负责重复报告作者已经知道的 blocker。

## 3. 路径与 Effect

| C 路径/源码位置 | Require 的条件和资源 | 返回值 | Concrete old/new | Abstract effect | Ensure/frame |
|---|---|---|---|---|---|
|  |  |  |  |  |  |

## 4. Dependencies 与 Formal Checks

| Predicate/callee/formal symbol | Revision/status | 用途 | 命令 | 结果 |
|---|---|---|---|---|
|  |  |  |  |  |

## 5. Review Issues

| ID | 级别 | 证据（file:line 或 symbol） | 具体不一致 | 实际后果 | 最小修改 | 通过条件 | 状态 |
|---|---|---|---|---|---|---|---|
|  | `blocker|non-blocker` |  |  |  |  |  | `open|fixed|passed|accepted` |

## 6. Review-passed 条件

| 条件 | 证据 | 状态 |
|---|---|---|
| 所有真实路径、返回值和 abstract effect 已覆盖 |  | `pass|fail` |
| Require 足够且没有无依据加强，Ensure 没有弱化义务 |  | `pass|fail` |
| Old/new、ownership transfer、frame 和资源返还正确 |  | `pass|fail` |
| Direct-callee 状态准确，没有把 pending 当 verified |  | `pass|fail` |
| Formal checks 通过且没有 open blocker |  | `pass|fail` |

## 7. Review 记录与重审判断

| Review ID | Spec revision | `full|delta` | 触发原因 | 检查的 paths/symbols/dependency closure | 结果 |
|---|---|---|---|---|---|
|  |  |  |  |  | `needs-fix|review-passed|blocked` |

- Predicate revision 是否仍有效：
- 本次修改是否影响上一结论；为什么：
- 是否需要 delta、full 或 no-review：
- Review-passed spec revision：
- 用户批准的 predicate/spec revisions（两者均 review-passed 后填写）：

Full review 只用于首次 ready revision 或审阅依据失效；其他有实质影响的修改做 delta。不得在没有新 revision 或新证据时重复 review。AI 不得自行批准。
