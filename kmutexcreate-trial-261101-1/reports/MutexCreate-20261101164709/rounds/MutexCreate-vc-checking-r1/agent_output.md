# Outcome

Analysis completed: 55 top-level obligations, 19 split obligations, 13 independent proof groups. This is a proofability assessment and dispatch plan, not a completed Rocq proof. The 45 obligations routed out of the generator auto template remain ordinary unproved manual obligations and are all covered.

# Structural Blocker Scan

Scanned every top-level statement, prioritizing the 48 without split goals. Their resources match directly or reorder within a frame; no current/@pre pointer or scalar bridge is missing. Return witnesses instantiate the precise locked/published state. Branch joins recover lock integer bounds from the owned Int cell and ID bounds from min-free plus fixed capacity. The six which-implies conversions keep each private field, each DLL/ID-manager footprint and the unique padding bytes accounted for. No concrete P-true/Q-false assignment was found.

Potential missing mutex_context in failure restoration was checked against the current shared definitions: mutex_create_frame contains os_world_wf, whose os_wf_context contains os_global_context, whose first conjunct is mutex_context. Thus that fact was preserved, not lost. The global C roots match the stable roots through this same context. Imported definitions were read only after main explicitly supplied the formal dependency paths; the historical trial/lib snapshots were not used.

# Annotation Comparison Review

The handoff contains no annotation_comparisons. Independent source-of-premise checks: which_implies_wit_1 must establish typed zero ownership from memset bytes; which_implies_wit_2 must establish freshness by disjoint payload ownership; entail_wit_1_1/1_2 establish the ID-range implication, using mutex_context and idmanager_min_free_id. which_implies_wit_3 and _6 establish the failure/success continuation and restore os_inv before later partial_solve witnesses project them. No later given premise is accepted as evidence of its own establishing VC.

# Proof-Mode Decisions

After the structural scan, all split obligations were judged first, in manual declaration order. Every split is semantically provable from its displayed premises. Table below records this first pass; detailed strategies were written only after all mode decisions.

| Split obligation | Judgment |
| --- | --- |
| `proof_of__MutexCreate_return_wit_3_split_goal_1` | 可证 |
| `proof_of__MutexCreate_partial_solve_wit_13_pure_split_goal_1` | 可证 |
| `proof_of__MutexCreate_which_implies_wit_1_split_goal_1` | 可证 |
| `proof_of__MutexCreate_which_implies_wit_1_split_goal_2` | 可证 |
| `proof_of__MutexCreate_which_implies_wit_1_split_goal_spatial` | 可证 |
| `proof_of__MutexCreate_which_implies_wit_2_split_goal_1` | 可证 |
| `proof_of__MutexCreate_which_implies_wit_2_split_goal_2` | 可证 |
| `proof_of__MutexCreate_which_implies_wit_2_split_goal_3` | 可证 |
| `proof_of__MutexCreate_which_implies_wit_2_split_goal_4` | 可证 |
| `proof_of__MutexCreate_which_implies_wit_2_split_goal_spatial` | 可证 |
| `proof_of__MutexCreate_which_implies_wit_3_split_goal_1` | 可证 |
| `proof_of__MutexCreate_which_implies_wit_3_split_goal_2` | 可证 |
| `proof_of__MutexCreate_which_implies_wit_3_split_goal_spatial` | 可证 |
| `proof_of__MutexCreate_which_implies_wit_5_split_goal_spatial` | 可证 |
| `proof_of__MutexCreate_which_implies_wit_6_split_goal_1` | 可证 |
| `proof_of__MutexCreate_which_implies_wit_6_split_goal_2` | 可证 |
| `proof_of__MutexCreate_which_implies_wit_6_split_goal_3` | 可证 |
| `proof_of__MutexCreate_which_implies_wit_6_split_goal_4` | 可证 |
| `proof_of__MutexCreate_which_implies_wit_6_split_goal_spatial` | 可证 |

Each of the seven parents with splits therefore uses aggressive_pre_process. Every other top-level was then independently judged as a whole and uses LLM_pre_process; no split is scheduled separately. The table below is in canonical manual declaration order.

| Top-level obligation | Mode | Group |
| --- | --- | --- |
| `proof_of__MutexCreate_safety_wit_1` | `LLM_pre_process` | `safety_1` |
| `proof_of__MutexCreate_safety_wit_2` | `LLM_pre_process` | `safety_1` |
| `proof_of__MutexCreate_safety_wit_3` | `LLM_pre_process` | `safety_1` |
| `proof_of__MutexCreate_safety_wit_4` | `LLM_pre_process` | `safety_1` |
| `proof_of__MutexCreate_safety_wit_5` | `LLM_pre_process` | `safety_1` |
| `proof_of__MutexCreate_safety_wit_6` | `LLM_pre_process` | `safety_2` |
| `proof_of__MutexCreate_safety_wit_7` | `LLM_pre_process` | `safety_2` |
| `proof_of__MutexCreate_safety_wit_8` | `LLM_pre_process` | `safety_2` |
| `proof_of__MutexCreate_safety_wit_9` | `LLM_pre_process` | `safety_2` |
| `proof_of__MutexCreate_safety_wit_10` | `LLM_pre_process` | `safety_2` |
| `proof_of__MutexCreate_safety_wit_11` | `LLM_pre_process` | `safety_3` |
| `proof_of__MutexCreate_safety_wit_12` | `LLM_pre_process` | `safety_3` |
| `proof_of__MutexCreate_safety_wit_13` | `LLM_pre_process` | `safety_3` |
| `proof_of__MutexCreate_safety_wit_14` | `LLM_pre_process` | `safety_3` |
| `proof_of__MutexCreate_safety_wit_15` | `LLM_pre_process` | `safety_3` |
| `proof_of__MutexCreate_safety_wit_16` | `LLM_pre_process` | `safety_4` |
| `proof_of__MutexCreate_safety_wit_17` | `LLM_pre_process` | `safety_4` |
| `proof_of__MutexCreate_safety_wit_18` | `LLM_pre_process` | `safety_4` |
| `proof_of__MutexCreate_safety_wit_19` | `LLM_pre_process` | `safety_4` |
| `proof_of__MutexCreate_safety_wit_20` | `LLM_pre_process` | `safety_4` |
| `proof_of__MutexCreate_return_wit_1` | `LLM_pre_process` | `public_returns` |
| `proof_of__MutexCreate_return_wit_2` | `LLM_pre_process` | `failed_exit_frames` |
| `proof_of__MutexCreate_partial_solve_wit_1_pure` | `LLM_pre_process` | `allocation_frames` |
| `proof_of__MutexCreate_partial_solve_wit_1` | `LLM_pre_process` | `allocation_frames` |
| `proof_of__MutexCreate_partial_solve_wit_2_pure` | `LLM_pre_process` | `allocation_frames` |
| `proof_of__MutexCreate_partial_solve_wit_2` | `LLM_pre_process` | `allocation_frames` |
| `proof_of__MutexCreate_partial_solve_wit_3_pure` | `LLM_pre_process` | `allocation_frames` |
| `proof_of__MutexCreate_partial_solve_wit_3` | `LLM_pre_process` | `allocation_frames` |
| `proof_of__MutexCreate_partial_solve_wit_4` | `LLM_pre_process` | `branch_join_frames` |
| `proof_of__MutexCreate_partial_solve_wit_5` | `LLM_pre_process` | `invariant_open_failure` |
| `proof_of__MutexCreate_partial_solve_wit_6` | `LLM_pre_process` | `invariant_open_failure` |
| `proof_of__MutexCreate_partial_solve_wit_7_pure` | `LLM_pre_process` | `invariant_open_failure` |
| `proof_of__MutexCreate_partial_solve_wit_7` | `LLM_pre_process` | `invariant_open_failure` |
| `proof_of__MutexCreate_partial_solve_wit_8_pure` | `LLM_pre_process` | `failed_exit_frames` |
| `proof_of__MutexCreate_partial_solve_wit_8` | `LLM_pre_process` | `failed_exit_frames` |
| `proof_of__MutexCreate_partial_solve_wit_9` | `LLM_pre_process` | `failed_exit_frames` |
| `proof_of__MutexCreate_partial_solve_wit_10` | `LLM_pre_process` | `payload_initialization` |
| `proof_of__MutexCreate_partial_solve_wit_11` | `LLM_pre_process` | `payload_initialization` |
| `proof_of__MutexCreate_partial_solve_wit_12_pure` | `LLM_pre_process` | `payload_initialization` |
| `proof_of__MutexCreate_partial_solve_wit_12` | `LLM_pre_process` | `payload_initialization` |
| `proof_of__MutexCreate_partial_solve_wit_13` | `LLM_pre_process` | `publish_call_frames` |
| `proof_of__MutexCreate_partial_solve_wit_14_pure` | `LLM_pre_process` | `publish_call_frames` |
| `proof_of__MutexCreate_partial_solve_wit_14` | `LLM_pre_process` | `publish_call_frames` |
| `proof_of__MutexCreate_partial_solve_wit_15_pure` | `LLM_pre_process` | `publish_call_frames` |
| `proof_of__MutexCreate_partial_solve_wit_15` | `LLM_pre_process` | `publish_call_frames` |
| `proof_of__MutexCreate_entail_wit_1_1` | `LLM_pre_process` | `branch_join_frames` |
| `proof_of__MutexCreate_entail_wit_1_2` | `LLM_pre_process` | `branch_join_frames` |
| `proof_of__MutexCreate_return_wit_3` | `aggressive_pre_process` | `public_returns` |
| `proof_of__MutexCreate_partial_solve_wit_13_pure` | `aggressive_pre_process` | `publish_call_frames` |
| `proof_of__MutexCreate_which_implies_wit_1` | `aggressive_pre_process` | `zero_bytes` |
| `proof_of__MutexCreate_which_implies_wit_2` | `aggressive_pre_process` | `invariant_open_failure` |
| `proof_of__MutexCreate_which_implies_wit_3` | `aggressive_pre_process` | `invariant_open_failure` |
| `proof_of__MutexCreate_which_implies_wit_4` | `LLM_pre_process` | `payload_initialization` |
| `proof_of__MutexCreate_which_implies_wit_5` | `aggressive_pre_process` | `payload_initialization` |
| `proof_of__MutexCreate_which_implies_wit_6` | `aggressive_pre_process` | `publish_invariant` |

# Common Proof Patterns

- **S (literal/branch safety):** establish only a pure signed-int bound or contradiction; constant bounds use the actual 32-bit model. Impossible paths use their explicit guards. No spatial conversion.
- **F (frame projection/permutation):** both sides have identical resources, potentially reordered. Introduce explicit PreH facts, reassociate/cancel. For auxiliary implications prove elementary pure goals directly if their premise footprint contains removed stack locals; do not recreate missing stack resources.
- **R (return packaging):** choose the exact existing state for the existential, retain OutsideCritical and the already established continuation. Malloc failure instead selects the ret(-5) branch of abs_mutex_create.
- **Z (zero-byte conversion):** use the existing 36-byte layout, partition the byte array at actual field/padding boundaries, establish little-endian typed zero representation and fold MutexZero. No pending Prop definition is a proved lemma.
- **I (invariant/resource conversion):** unfold os_inv and mutex_inv, retain context through os_world_wf, use root equalities and frame the untouched OS modules. Freshness follows from disjointness of the new and any existing val cell. Failure forgets values into MutexRaw and restores the old state.
- **P (publication):** head dispatch produces cons; identify the derived manager with add+link by pointwise equality of all 16 buckets. Publish adds no waiters, preserving world scheduling ownership, task maps and service-slot facts. Fold the exact updated os_inv.
- **C (continuation):** safeExec of choice covers the chosen normal branch. Under the supplied rely observation choose locked st; failure uses (-5,st), success uses existential p and the exact published state. Crtos_CS has a True transition relation; guarantee evidence does not assert additional OS semantic preservation.

# VC Deltas

The machine plan contains the executable per-target detail (spatial P/Q, witnesses, pure premise sources, frame/list transformations and helper obligations). Compact deltas:

| Family | Pattern and actual difference |
| --- | --- |
| safety 1–5, 8–12, 15–20 | S: literals 0, 1, 5 or 255; 8/15 are 5<>INT_MIN |
| safety 6/7 | S: contradictory null/non-null or positive/null result |
| safety 13/14 | S: failed ID=-1 contradicts success guard; min-free range contradicts negative guard |
| partial_solve 1/2 pure+aux | F+S: sizeof(Mutex)=36 and memset zero-byte range; unchanged allocation/frame |
| partial_solve 3 pure+aux, 4 | F: allocation address facts, same zero bytes or MutexZero; ordering only |
| partial_solve 5/6 | F: lock invariant footprint, then ID-call footprint |
| partial_solve 7 pure+aux | F: failure inputs to private-object and invariant restoration |
| partial_solve 8 pure+aux, 9 | F: already-established guarantee, unlock then original-base free footprint |
| partial_solve 10/11 | F: pend NodeZero then two undef pointer cells for initialization |
| partial_solve 12 pure+aux | F: exact initialized payload and retained min-free ID |
| partial_solve 13 pure+aux | F: head-anchor branch is equality by reflexivity; frame new payload/node with old list |
| partial_solve 14 pure+aux | F: inserted DLL plus updated manager feed final conversion |
| partial_solve 15 pure+aux | F: exact published os_inv and original InsideCritical index feed unlock |
| entail 1_1/1_2 | F: left failed/right successful branch; lock scalar bounds come from its cell, min-free range from context |
| return 1/2 | R: published state / unchanged locked state |
| return 3 | C: malloc-failure ret branch before lock |
| which_implies 1 | Z: byte allocation to typed full zero object and two nonzero field addresses |
| which_implies 2 | I: unfold mutex module, prove fresh address by separation, forget only ID initialization values |
| which_implies 3 | I+C: restore unchanged os_inv and unknown-valued MutexRaw, derive locked failure continuation |
| which_implies 4 | F: zero pend links to undef cells, witnesses 0 |
| which_implies 5 | I: initialized payload with empty waiting DLL and separately occupied management link |
| which_implies 6 | P+C: manager bucket equality, new world invariant, ID bounds and successful continuation |

# Grouping Decisions

Plan order puts the three high-risk conversion families first: zero_bytes; invariant_open_failure; publish_invariant. The zero-byte conversion and publication are single-witness groups because each owns an independent substantial helper family. The opening/failure group keeps extraction, restoration and their directly related frames together. Publication is already isolated from simple final-result and call-preparation work, avoiding a large tail group. Every other group contains 2–6 top-level witnesses; safety is four groups of five. All groups are independent; helpers have their own group suffix and do not rely on sibling outputs. Public helper visibility expresses reuse intent only.

# Risks or Blockers

No definite annotation/specification/dependency blocker. High proof-development risk remains in byte/typed-store conversion, extracting an arbitrary member of store_dll to prove freshness, and the derived-manager equality with replace_Znth over 16 filtered buckets. These require new proved helper lemmas, not stronger caller requirements or new axioms. World-invariant transport must explicitly cover all record fields. The reused callees and existing lock/memory trust boundary remain unchanged; this analysis is not a whole mutex-module correctness claim.

The exact handoff coq-debug command completed with exit code 0 and JSON status passed. The only debug-copy edits were four Show. insertions in proof bodies for which_implies 1/2/3/6. This checks loading/typing and shows the pending goals; it does not discharge them. Canonical C, goal, auto, manual, goal-check, case lib and shared libraries were not edited.
