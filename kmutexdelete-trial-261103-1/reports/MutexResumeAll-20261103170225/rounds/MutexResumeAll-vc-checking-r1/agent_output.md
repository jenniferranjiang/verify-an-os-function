# MutexResumeAll VC checking, round 1

## Outcome

Current canonical inputs support a completed analysis: 54 top-level VCs, 8 generated split goals, 15 independent groups. Six parents use aggressive_pre_process; the remaining 48 use LLM_pre_process. This is an analysis/grouping result, not a discharged-proof claim. Canonical C/formal files were not changed. No Show insertion or debug run was needed because the goal definitions expose the relevant P/Q directly.

## Structural Blocker Scan

All top-level whole goals were scanned first, especially no-split field bridges and loop back-edges. No definite countermodel was found. list_pre/head(p), retval/target, marked/current and task ID bounds are explicitly bridged. which_implies fields have actual cells plus nonduplicable restore wands. On the successful wakeup back-edge, only the **post** os_inv is owned: derive old lookup uniqueness from the unchanged ID-manager component and derive exact queue-tail removal using the post READY/SUSPEND exclusion; do not silently use an old heap snapshot. Failed wakeup has after=marked, so current os_inv yields the lookup/descriptor contradiction.

The source-state pure facts must be extracted before giving os_inv to a wand in the two generated KTaskWakeup refinement obligations. This is possible from their actual source heap and does not require a new premise. Their presence is generated contract refinement work, not permission to reprove the reused C body.

## Annotation Comparison Review

No historical annotation comparisons were supplied. Newly established facts have visible obligations: which_implies_1 supplies the original Mutex witness; which_implies_2 supplies exact head.next observations; which_implies_4 supplies SUSPEND descriptor/alignment; which_implies_5/6 justify exstatus change and restore; which_implies_7/8 justify ID reading and restore; entail_3 and entail_4_* justify the continuation-style remaining-effect invariant; which_implies_9 consumes its empty tail. No *_obligation definition is treated as proof.

## Proof-Mode Decisions

Split pass was completed for **all** split goals before top-level mode analysis, in canonical manual order:

- `proof_of_LinklistResumeAll_return_wit_1_split_goal_1`: 可证：0=KOK by its definition.
- `proof_of_LinklistResumeAll_which_implies_wit_3_split_goal_spatial`: 可证：head.next cell applies its exact restore wand.
- `proof_of_LinklistResumeAll_which_implies_wit_5_split_goal_spatial`: 可证：owned registered task exstatus can be replaced while all scheduler/ID/domain dependent facts are unchanged; requires a new proved frame lemma.
- `proof_of_LinklistResumeAll_which_implies_wit_6_split_goal_spatial`: 可证：new -1 cell applies the exstatus restore wand.
- `proof_of_LinklistResumeAll_which_implies_wit_8_split_goal_spatial`: 可证：unchanged ID cell applies its restore wand.
- `proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_1`: 可证：remaining=nil turns the continuation into an actual bulk effect; st_lock/original witness the guarded normal atomic execution and transfer safeExec.
- `proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_2`: 可证：the existing GTrans is True.
- `proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_3`: 可证：the actual aggregate effect preserves the original object identity and empties its pending. This is stronger than merely combining unrelated live and pending witnesses; nil original.pending uses current=st_lock, nonnil uses mapped-original membership.

After that complete split pass, modes were decided for all parents in manual order:

- `proof_of_LinklistResumeAll_safety_wit_1`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_safety_wit_2`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_safety_wit_3`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_safety_wit_4`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_safety_wit_5`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_safety_wit_6`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_safety_wit_7`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_safety_wit_8`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_safety_wit_9`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_safety_wit_10`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_safety_wit_11`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_entail_wit_1`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_entail_wit_2`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_1_pure`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_1`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_2_pure`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_2`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_3_pure`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_3`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_4`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_5`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_6_pure`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_6`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_7_pure`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_7`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_8_pure`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_8`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_9`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_10`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_11_pure`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_11`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_12`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_13`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_14_pure`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_14`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_15_pure`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_15`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_16_pure`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_partial_solve_wit_16`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_entail_wit_3`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_entail_wit_4_1`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_entail_wit_4_2`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_return_wit_1`: `aggressive_pre_process` (all associated splits provable).
- `proof_of_LinklistResumeAll_which_implies_wit_1`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_which_implies_wit_2`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_which_implies_wit_3`: `aggressive_pre_process` (all associated splits provable).
- `proof_of_LinklistResumeAll_which_implies_wit_4`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_which_implies_wit_5`: `aggressive_pre_process` (all associated splits provable).
- `proof_of_LinklistResumeAll_which_implies_wit_6`: `aggressive_pre_process` (all associated splits provable).
- `proof_of_LinklistResumeAll_which_implies_wit_7`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_LinklistResumeAll_which_implies_wit_8`: `aggressive_pre_process` (all associated splits provable).
- `proof_of_LinklistResumeAll_which_implies_wit_9`: `aggressive_pre_process` (all associated splits provable).
- `proof_of_KTaskWakeup_derive_semaphore_pending_head_ic_by_wakeup_by_id_ic`: `LLM_pre_process` (no split; complete whole goal is provable).
- `proof_of_KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic`: `LLM_pre_process` (no split; complete whole goal is provable).

## Common Proof Patterns

1. **Projection/frame copy**: pure conjuncts are current PreH facts; preserve heap with cancellation. Aux partial_solve goals are implications from their pure witnesses, not a request to change those witnesses. Literal bounds and contradictory next=head/next!=head branches need no new semantic lemma.
2. **Field focus and wand return**: take only the actual next/exstatus/id cell from its unique owner; construct a wand carrying the exact leftover resource. Exstatus restoration uses the precise marked task-map update; ID/next are read-only. Pure pointer or membership facts never replace the cell.
3. **Finite drain semantics**: initial os_inv supplies queue uniqueness, registered SUSPEND descriptors and valid delays/ready state. Prove the forward step-chain/bulk bridge by finite-list induction and exact map, delay and ready-fold composition. The loop back-edge prepends one real resume_one to the universal remaining-effect continuation. Do not use the typechecked Prop statement as a theorem.
4. **Scoped atomic exit**: empty tail gives actual bulk effect; guard, RTrans and original object identify the normal transition under the frozen A1/A2 scoped model. Transfer entry safeExec to ret(tt) for LastSeen(current). No equality of all OS states is assumed.
5. **General wakeup refinement**: extract pure source consistency, transfer os_inv, then introduce the post wand. Same-ID uniqueness aligns task/descriptor; exclusive source membership distinguishes semaphore versus detached route; preserve actual returned state/resource. Both branches and all cross-module remove_found components are addressed.

## VC Deltas

The detailed per-witness P/Q, witness choices, resource transformations and helper premises are in group_plan.json. Nontrivial differences: entail_4_1 is impossible wakeup failure; entail_4_2 uses post-invariant reasoning and step-prefix composition. which_implies_4 has a false-looking pure-only alternative but its full spatial alternative is available and chosen. which_implies_9 split_3 is provable **purely** because the remaining-effect fact encodes the completed bulk state, not because pure pending membership ensures uniqueness. The generated return split is only the constant equality; its parent frame is reconstructed by aggressive preprocessing.

## Grouping Decisions

The plan starts with the three high-risk semantic families (bulk initialization, loop step, head view), then exstatus/ID restoration, exit and generated wakeup refinements. Remaining independent arithmetic and fact-copy work is separated by stage. All groups have 2–6 parents except the singleton bulk_initialization: its finite drain-to-bulk induction is an independent heavy helper family and a likely critical path; mixing unrelated entry arithmetic would obscure that ownership. No group exceeds the hard limit 12. Groups do not depend on sibling outputs; needed helper families are separately proved with exact group suffixes. The return/exit family is split from loop transition work because it uses pure effect/atomic reasoning rather than the heavy loop induction.

## Risks or Blockers

No definite blocker. Highest risks are exact ready/delay fold composition, task-map-indexed frame rebuilding, and extracting/preserving sufficient pure source consistency in generated refinements. These require substantial new checked lemmas, but their premises are available from the actual VCs. All A1/A2 scoped assumptions remain exactly those in the frozen inputs; no new axiom, strengthened Require, generated statement edit or canonical mutation is planned.
