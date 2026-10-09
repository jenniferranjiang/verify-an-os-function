---
file_or_slice: "annotated_C/src/DoubleLinkListInsertNodeAfter.c and caller-local contracts"
approved_version: "spec-r16-b7a98f34d4b9"
status: review-passed
change_kind: breaking
approved_by: "user (chat)"
approved_at: "2026-10-08"
reviewed_candidate: "spec-r16-b7a98f34d4b9"
reviewed_by: "spec_reviewer"
review_conclusion: "review-passed"
current_candidate: "spec-r16-b7a98f34d4b9"
---

# 设计变更请求：`DoubleLinkListInsertNodeAfter` node 非空前置条件

- Change kind：`breaking`；canonical helper Require 增加 `linklist_node != 0`，因此必须形成新 spec revision 并重新获得用户批准。
- 原批准设计：r14 只要求 `store_sem_dll(...) * store_sem_standalone_node(...)`；后者给 node 的两个 link 字段写权限，但没有纯 `node <> 0`。
- 新源码/proof 证据：r14 生成的 `DoubleLinkListInsertNodeAfter_return_wit_1` 必须重建 `store_sem_dll(..., Build_SemDLNode(payload,node)::nodes)`；该 predicate 的 `Forall` 明确要求新节点地址非零。Rocq 展开后留下不可由旧 Require 推出的 `node <> 0`，不能用 tactic、Axiom 或 Admitted 消除。
- 拟议修改：canonical Require 增加 `linklist_node != 0`；`InsertObj.c` 与 `_SemaphoreCreate.c` 的 caller-local declaration 同步为 `node != 0`。函数体、返回、Ensure、插入方向和 ownership transfer 均不变。
- 对 abstract state/command 的影响：无；semaphore state、reserve/create transformer 与 public `KSemaphoreCreate` command 不变。
- 对 ownership/predicate/spec 的影响：predicate revision r20 不变。r16 在 `IdInsertObj`/`InsertObj` canonical 与 caller-local contracts 中显式传递 allocation 已有的 `semaphore_layout_32_ok(sem)`；`_SemaphoreCreate` 从 `store_sem_zeroed_private` 的正式定义中导出并 frame 该事实。public API 与 heap footprint 不变。
- 对 trust/scope 和已完成工作的影响：trusted symbols 与九函数闭包不变；r14 生成 VC 已移入 `.tmp/stale-r14-generated-vc-20261008/`，必须在 r16 获批后重新 symbolic/生成，不复用或手改旧 goal/auto/check。
- 保持不变的 formal types/statements/interfaces：七个 approved predicate 文件、统一 critical carrier、全部 public contracts、DLL Ensure 与所有 executable C。
- 受影响文件和已批准内容：`DoubleLinkListInsertNodeAfter.c` canonical Require；`InsertObj.c`、`_SemaphoreCreate.c` caller-local copies；其 transitive callers 需复核可满足新前提。
- 已考虑但拒绝的方案：不把 `node <> 0` 塞入 proof-local cut（无前提依据）；不把 `store_sem_standalone_node` 改成强 predicate（会不必要地使 predicate r20 失效）；不使用 Axiom/Admitted。
- 可独立继续的工作：无；按门禁暂停受影响 VC/proof，等待 r16 review 与批准。
- 审阅决定和新版本：r15（manifest `66bfb378...f027`）affected-only review 为 `needs-fix`；r16 `spec-r16-b7a98f34d4b9`（annotated manifest `b7a98f34d4b98a9f90cbf5fa775c09e35b01f369b345d866b9606e8ff4537c65`）affected-only review 为 `review-passed`。

## Independent review issue

- `SPEC-IMPL-07-CALLER` | `blocker` | `CommonAssertion.v:289-299,471-476`; `SemaphoreRep.v:15-23,85-101,235-257,333-348`; three r16 helper contract groups；`.tmp/SemaphoreNonnullReview.v` | r15 未显式把 layout 事实带入 helper closure；先前以裸 `mstore` 否定 typed-store validity 的反例不适用，真正缺口是 layout fact 的显式贯穿 | r16 从 `store_sem_zeroed_private` 保留 `semaphore_layout_32_ok`，并在 `IdInsertObj`/`InsertObj` pre/post逐层传递。Coq 8.20.1机器检查确认：ID path由 typed UShort 的 `isvalidptr_short sem` 与 id-link=`sem+4`推出非零；registry path由 `isvalidptr_short(sem+12)`与registry-link=`sem+24`推出非零；无新增 assumption | 无需继续修复；两个 caller entailment、canonical/caller-local同步、public footprint、hash/GCC/helper检查均已通过 | `fixed-in-r16-reviewed`.

其余检查保持通过。r16 hashes：annotated `b7a98f34...37c65`、predicate `77f0b1b0...53a8`、helper `3a935320...dbae`；source manifest `2adc70fc...9c2`；九文件 GCC、helper compile/coqchk/trust scan及review-only entailment compile/coqchk通过。结论为 `review-passed`，等待用户明确批准 r16 后才能恢复 implement。
