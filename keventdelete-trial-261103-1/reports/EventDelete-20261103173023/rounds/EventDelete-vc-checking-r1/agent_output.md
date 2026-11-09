# _EventDelete VC analysis, attempt 1

Outcome: **completed**. Current manual has 86 top-level obligations and 24 split obligations. The selected modes are 13 aggressive parents and 73 LLM parents, in 21 independent groups. This is a proof plan, not a proof-completion claim.

## Structural blocker scan

All top-level obligations were scanned first, prioritizing the no-split wholes. No definite countermodel or missing resource/current-@pre bridge was found. Inspection pointers and ID loads remain tied to event_pre; ready/checked/drained/locked/after observations have explicit equality or protocol links. The successful IdRemoveObj branch retains old address and ID NoDup, original ID/address/pending facts, and the manager-unpublish projection equation. Those are present before the removed-manager resource is used; they are not incorrectly inferred from the post-removal manager. The false-query branch explicitly also has query=true, so its apparent lack of detached ID cells is unreachable rather than a resource gap.

The successful retirement antecedent has all three detached IdNode stores, detached management link, store_event payload and exact event_create_frame. Old ID uniqueness plus idmanager_contains identifies the detached node with the original Event; empty pending permits complete retirement without retaining task nodes. Pure world/context information remains inside event_create_frame. Pending/ID restore wands are actual spatial resources, not freely asserted pure lemmas. The public environment assumptions are used only through the existing named gap relation; no new environment restriction was inserted.

## Annotation comparison review

The handoff lists no prior annotation comparisons. I independently checked the important newly retained facts: which_implies_wit_6 must derive ID/address NoDup, ID range/query=true and manager projection equality from the original os_inv; it is a heavy assigned obligation rather than an axiom. which_implies_wit_1 must construct the pending borrowing wand from actual payload ownership. which_implies_wit_7 consumes the ID restore wand. The explicit IdRemoveObj field spelling yields UShort id=65535 and self-linked Ptr cells at the real IdNode.link; no additional heap atom appears. No imported function body is part of these obligations.

## Split-first decisions

After the structural scan, every split was judged before top-level mode selection. All 24 are semantically provable. Names below omit the common `proof_of__EventDelete_` prefix.

- entail_wit_4_1: `entail_wit_4_1_split_goal_1` = 可证, `entail_wit_4_1_split_goal_2` = 可证, `entail_wit_4_1_split_goal_spatial` = 可证.
- entail_wit_4_2: `entail_wit_4_2_split_goal_1` = 可证, `entail_wit_4_2_split_goal_2` = 可证, `entail_wit_4_2_split_goal_spatial` = 可证.
- entail_wit_4_3: `entail_wit_4_3_split_goal_1` = 可证, `entail_wit_4_3_split_goal_2` = 可证, `entail_wit_4_3_split_goal_spatial` = 可证.
- entail_wit_4_4: `entail_wit_4_4_split_goal_1` = 可证, `entail_wit_4_4_split_goal_2` = 可证, `entail_wit_4_4_split_goal_spatial` = 可证.
- partial_solve_wit_20_pure: `partial_solve_wit_20_pure_split_goal_1` = 可证.
- partial_solve_wit_21_pure: `partial_solve_wit_21_pure_split_goal_1` = 可证.
- which_implies_wit_2: `which_implies_wit_2_split_goal_1` = 可证, `which_implies_wit_2_split_goal_spatial` = 可证.
- which_implies_wit_3: `which_implies_wit_3_split_goal_1` = 可证, `which_implies_wit_3_split_goal_2` = 可证.
- which_implies_wit_4: `which_implies_wit_4_split_goal_1` = 可证.
- which_implies_wit_5: `which_implies_wit_5_split_goal_1` = 可证, `which_implies_wit_5_split_goal_2` = 可证.
- which_implies_wit_7: `which_implies_wit_7_split_goal_spatial` = 可证.
- which_implies_wit_8: `which_implies_wit_8_split_goal_spatial` = 可证.
- which_implies_wit_9: `which_implies_wit_9_split_goal_spatial` = 可证.

The impossible-ID splits use the explicit false/true contradiction. The other retirement pure splits use the guarded atomic unpublish transition and the retained empty-object relation; their spatial splits use the actual detached resources and old uniqueness. The two manager-pointer splits use the existing global-variable address-nonzero fact, not an inference from arbitrary offset-field validity. Pending/ID wand splits are elimination; inspection continuation splits use the exact nonempty/empty observation and the same continuation X. Retired-to-raw is typed forgetting of the same owned bytes.

## Proof-mode decisions and VC deltas

Every parent with splits takes `aggressive_pre_process`; no whole-goal route is substituted for a successful split family. Every remaining parent takes `LLM_pre_process`. The grouping table accounts for all parents exactly once; detailed per-target spatial/pure/existential routes are in group_plan.json.

| Group | Mode/count | Parent obligations (common prefix omitted) |
|---|---|---|
| id_snapshot | LLM/1 | `which_implies_wit_6` |
| retire_success | aggressive/2 | `entail_wit_4_2`, `entail_wit_4_4` |
| inspect_continuations | aggressive/3 | `which_implies_wit_3`, `which_implies_wit_4`, `which_implies_wit_5` |
| pending_view | mixed/2 | `which_implies_wit_1`, `which_implies_wit_2` |
| manager_frame | aggressive/4 | `which_implies_wit_7`, `which_implies_wit_8`, `partial_solve_wit_20_pure`, `partial_solve_wit_21_pure` |
| reclaim | mixed/5 | `which_implies_wit_9`, `partial_solve_wit_28`, `partial_solve_wit_29`, `partial_solve_wit_30`, `partial_solve_wit_31` |
| missing_id_impossible | mixed/4 | `entail_wit_4_1`, `entail_wit_4_3`, `partial_solve_wit_22`, `partial_solve_wit_24` |
| return_dispatch | LLM/6 | `entail_wit_5_1`, `entail_wit_5_2`, `entail_wit_6_1`, `entail_wit_6_2`, `return_wit_1`, `return_wit_2` |
| branch_contradictions | LLM/4 | `safety_wit_6`, `safety_wit_7`, `safety_wit_9`, `safety_wit_10` |
| literal_bounds | LLM/6 | `safety_wit_1`, `safety_wit_2`, `safety_wit_3`, `safety_wit_4`, `safety_wit_5`, `safety_wit_8` |
| null_loop | LLM/2 | `entail_wit_1`, `entail_wit_2` |
| branch_join | LLM/4 | `entail_wit_3_1`, `entail_wit_3_2`, `partial_solve_wit_10_pure`, `partial_solve_wit_10` |
| inspection_entry | LLM/5 | `partial_solve_wit_1_pure`, `partial_solve_wit_1`, `partial_solve_wit_2_pure`, `partial_solve_wit_2`, `partial_solve_wit_3` |
| pending_contract_frame | LLM/4 | `partial_solve_wit_4_pure`, `partial_solve_wit_4`, `partial_solve_wit_5_pure`, `partial_solve_wit_5` |
| inspection_unlock | LLM/4 | `partial_solve_wit_6_pure`, `partial_solve_wit_6`, `partial_solve_wit_7_pure`, `partial_solve_wit_7` |
| resume_call_frame | LLM/6 | `partial_solve_wit_8_pure`, `partial_solve_wit_8`, `partial_solve_wit_9_pure`, `partial_solve_wit_9`, `partial_solve_wit_11_pure`, `partial_solve_wit_11` |
| final_lock_entry | LLM/4 | `partial_solve_wit_12_pure`, `partial_solve_wit_12`, `partial_solve_wit_13_pure`, `partial_solve_wit_13` |
| final_lock_result | LLM/4 | `partial_solve_wit_14_pure`, `partial_solve_wit_14`, `partial_solve_wit_15_pure`, `partial_solve_wit_15` |
| id_read_frame | LLM/6 | `partial_solve_wit_16`, `partial_solve_wit_17`, `partial_solve_wit_18_pure`, `partial_solve_wit_18`, `partial_solve_wit_19_pure`, `partial_solve_wit_19` |
| id_remove_frame | LLM/4 | `partial_solve_wit_20`, `partial_solve_wit_21`, `partial_solve_wit_23`, `partial_solve_wit_25` |
| unlock_schedule_frame | LLM/6 | `partial_solve_wit_26_pure`, `partial_solve_wit_26`, `partial_solve_wit_27_pure`, `partial_solve_wit_27`, `partial_solve_wit_32_pure`, `partial_solve_wit_32` |

## Common proof patterns

1. **Pure projection / constants / contradiction.** Safety literal bounds are closed arithmetic. Branch contradictions already have 0/nonzero or boolean true/false conflicts. Partial pure goals project named premises; implication wrappers keep the same heap and repeat pure facts. Do not invent old-state equalities.
2. **Protocol and local-frame cancellation.** Inspection and final-lock auxiliaries swap existing InsideCritical/os_inv or preserve OutsideCritical. Known local cells may be forgotten to undef where Q requests that; no extra cell is created. Branch joins instantiate ready=drained or ready=checked; function return instantiates the actual latest after state.
3. **Wand borrowing.** Unfold only the relevant event/manager representation, split the requested scalar or pending DLL, package the exact remainder with wand introduction, and later consume the identical owned cell/DLL with wand elimination. No duplicated os_inv is retained.
4. **Old snapshot facts.** From the original manager/DLL establish mapped ID/address uniqueness and membership/ranges. Prove the pure filter/remove projection equality while the old invariant is available, then retain it over IdRemoveObj. The resulting manager is rewritten to event_manager of the surviving sequence.
5. **Retirement and world preservation.** Identify the returned IdNode by old ID uniqueness, remove exactly original from the address-unique list, pack payload/padding and self-linked nodes into EventRetired, and reconstruct os_inv for replace_events. Removing a member with pending=[] leaves all sched-owner lists unchanged; other OS fields are definitionally preserved. Existing design `_obligation : Prop` definitions are not proof lemmas.
6. **Guarded atomic / WLP composition.** Construct the actual inspected or unpublish nrm observation using gap and pending facts, consume the corresponding bind, preserve the same X, and produce the residual program at LastSeen checked/after. ResumeAll uses its weakestpre(finish true) continuation; its ret continuation is not confused with the final caller X. The inspected nonempty branch controls final scheduling even if a later ResumeAll sees no waiter.
7. **Exact disposal shape.** EventRetired -> EventRaw forgets field values and padding contents while keeping all bytes and standalone node ownership; it does not prove allocator implementation or invent provenance.

## Grouping and risks

The order puts the independent heavy ID snapshot extraction, successful retirement, and abstract continuation families first. id_snapshot is a justified single-parent group because its ID/NoDup/focus helper family dominates that one obligation. Successful resched=true/false retirement parents stay together because their six splits share the same detached-object reconstruction; their final continuation differences are explicitly parameterized. Inspection/WLP branches are a separate family. Resource-wand focus and field forgetting are separated from protocol/frame/safety projections. All groups contain at most six parents (hard cap twelve); splitting the simple branch/partial families further would add overhead without mathematical independence benefits.

No group depends on sibling output. Planned helpers have exact group suffixes, and each helper lists premises available in its assigned VCs. The strongest work is the pure manager projection and spatial retirement reconstruction; these are high risk due to proof size, but no missing premise or countermodel was found. Groups must prove these facts and cannot use the typechecked design obligations as axioms.

Canonical C, goal, auto, manual and lib were not modified. The debug manual was not edited: the generated goal definitions already expose the full relevant contexts, so no coq-debug expansion was needed. No proof or group execution was performed by this VC-checking owner.
