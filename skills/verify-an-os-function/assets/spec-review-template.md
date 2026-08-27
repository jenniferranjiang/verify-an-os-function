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

- Predicate revision 与状态：
- 路径、direct callees 与 load/store ownership：
- 一函数一文件、active body、callee API 与源码等价性：
- Rocq、parser/typecheck、QCP-MCP symbolic 检查及范围：
- 仍存在的 `[OPEN]`：
- 结论：`ready|open`

任一必需项为 `open` 时保持 `draft`，先补 spec，不启动 review。Reviewer 不重复报告作者已经知道且没有新证据的 blocker。

## 3. 路径与 Effect

按真实 C 路径逐项写：

- 路径/源码位置：
  - 进入条件和资源：
  - 返回值或阻塞：
  - Concrete old/new 与 abstract effect：
  - Ensure/frame：

## 4. Dependencies 与 Formal Checks

- Predicate/callee/formal symbol、revision/status 与用途：
- 实际运行的命令或检查范围：
- 结果：

## 5. Review Issues

- `<ID>` — `blocker|non-blocker` — `open|fixed|passed|accepted`
  - 证据（file:line 或 symbol）：
  - 具体不一致与实际后果：
  - 最小修改与通过条件：

## 6. Review-passed 条件

- 路径、返回值和 abstract effect：`pass|fail`；证据：
- Require/Ensure 强度：`pass|fail`；证据：
- Old/new、ownership transfer、frame 与资源返还：`pass|fail`；证据：
- Direct-callee 状态：`pass|fail`；证据：
- Formal checks、QCP-MCP symbolic 与 blockers：`pass|fail`；证据：

## 7. Review 记录与重审判断

- Review ID、spec revision 与 `full|affected-only`：
- 触发原因和实际检查的 issue/paths/symbols/dependency closure：
- Predicate revision 是否仍有效：
- 结论：`needs-fix|review-passed|blocked`
- Review-passed spec revision（通过时填写）：
- 用户批准的 predicate/spec revisions（两者均 review-passed 后填写）：

Full review 只用于首次 ready revision或审阅依据失效；`needs-fix` 后只检查已报告 issue、修改处及受影响 closure。不得在没有新 revision 或新证据时重复 review。AI 不得自行批准。
