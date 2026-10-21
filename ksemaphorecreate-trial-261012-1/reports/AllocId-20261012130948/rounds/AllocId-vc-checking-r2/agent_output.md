# Outcome

Completed independent analysis of the current canonical AllocId goals: 43 top-level VCs and 15 split goals. All selected obligations are semantically provable. The plan has 10 independent groups, 8 aggressive parents and 35 whole-goal parents. This is a proofability assessment, not completed implementation proofs. The authorized coq-debug command exited 0 with JSON status passed; the debug manual differs only by Show commands.

# Structural Blocker Scan

Scanned every current top-level definition, prioritizing no-split entail_2, returns, partial_solve goals, then remaining safety/projection goals. No missing manager/current-at-entry equality, resource address or existential witness was found. Both sides use manager_pre throughout. The store_idmanager existential supplies the very byte list required by entail_2. Array access goals use the owned full array at id_map(sm) and the explicit index/end bounds. Return goals preserve all manager fields and bucket resources; successful allocation changes only the byte list and deliberately retains old bucket membership in allocated_unlinked. Scan facts retain byte interpretation and both prefix invariants; they establish the free/minimal or full result.

Canonical manual, goal and auto were read, and accepted idnode/heap-bridge definitions were used read-only to interpret the statements. No historical trial, historical plan or proof was used. The qcp_local_end binder carries the same local end value; heap address strings remain end.

# Annotation Comparison Review

The handoff lists no annotation comparisons. Independently checked premise provenance in the current VCs: entail_2 opens the manager to establish bytes_ok and buckets_ok; entail_3 establishes the empty outer prefix; entail_4 establishes its successor prefix from the byte=255 guard; entail_5 initializes the entry scan; entail_6 establishes its successor by the land-nonzero guard. Thus these are current obligations, not assumed successful repairs. The public return contracts are retained.

# Proof-Mode Decisions

The following split-only pass was completed in manual declaration order before deciding any parent mode. Every split was judged provable, with no deferred split or split-based blocker:

- `safety_wit_9_split_goal_1`: provable.
- `safety_wit_9_split_goal_2`: provable.
- `safety_wit_19_split_goal_1`: provable.
- `safety_wit_19_split_goal_2`: provable.
- `safety_wit_22_split_goal_1`: provable.
- `safety_wit_22_split_goal_2`: provable.
- `safety_wit_27_split_goal_1`: provable.
- `safety_wit_27_split_goal_2`: provable.
- `safety_wit_27_split_goal_3`: provable.
- `safety_wit_27_split_goal_4`: provable.
- `entail_wit_3_split_goal_1`: provable.
- `entail_wit_3_split_goal_2`: provable.
- `entail_wit_4_split_goal_1`: provable.
- `entail_wit_5_split_goal_1`: provable.
- `entail_wit_6_split_goal_1`: provable.

After that pass, all parents with splits select aggressive_pre_process without further whole-goal proofability analysis. All remaining parents are whole-goal provable and select LLM_pre_process. The complete manual-order decisions are:

| Current top-level VC | Mode |
| --- | --- |
| `safety_wit_9` | aggressive_pre_process |
| `safety_wit_19` | aggressive_pre_process |
| `safety_wit_22` | aggressive_pre_process |
| `safety_wit_27` | aggressive_pre_process |
| `entail_wit_2` | LLM_pre_process |
| `entail_wit_3` | aggressive_pre_process |
| `entail_wit_4` | aggressive_pre_process |
| `entail_wit_5` | aggressive_pre_process |
| `entail_wit_6` | aggressive_pre_process |
| `return_wit_1` | LLM_pre_process |
| `return_wit_2` | LLM_pre_process |
| `return_wit_3` | LLM_pre_process |
| `safety_wit_1` | LLM_pre_process |
| `safety_wit_2` | LLM_pre_process |
| `safety_wit_3` | LLM_pre_process |
| `safety_wit_4` | LLM_pre_process |
| `safety_wit_5` | LLM_pre_process |
| `safety_wit_6` | LLM_pre_process |
| `safety_wit_7` | LLM_pre_process |
| `safety_wit_8` | LLM_pre_process |
| `safety_wit_10` | LLM_pre_process |
| `safety_wit_11` | LLM_pre_process |
| `safety_wit_12` | LLM_pre_process |
| `safety_wit_13` | LLM_pre_process |
| `safety_wit_14` | LLM_pre_process |
| `safety_wit_15` | LLM_pre_process |
| `safety_wit_16` | LLM_pre_process |
| `safety_wit_17` | LLM_pre_process |
| `safety_wit_18` | LLM_pre_process |
| `safety_wit_20` | LLM_pre_process |
| `safety_wit_21` | LLM_pre_process |
| `safety_wit_23` | LLM_pre_process |
| `safety_wit_24` | LLM_pre_process |
| `safety_wit_25` | LLM_pre_process |
| `safety_wit_26` | LLM_pre_process |
| `safety_wit_28` | LLM_pre_process |
| `safety_wit_29` | LLM_pre_process |
| `safety_wit_30` | LLM_pre_process |
| `entail_wit_1` | LLM_pre_process |
| `partial_solve_wit_1` | LLM_pre_process |
| `partial_solve_wit_2` | LLM_pre_process |
| `partial_solve_wit_3` | LLM_pre_process |
| `partial_solve_wit_4` | LLM_pre_process |

# Common Proof Patterns

- **P1: Literal/contradiction safety.** Spatial preconditions are context only; the consequent is pure. Introduce pure goals, compute machine bounds and use arithmetic or contradictory path premises. No existential or heap transition.
- **P2: Bounded arithmetic.** bytes_ok yields 0 <= idmax <= 65535. Convert nonnegative quot to div, bound ceil-byte count by 8192 and index by 8191; entry invariant bounds id by index*8+8. Heap is context, with no existential.
- **P3: Pure scan invariants.** Empty prefix is vacuous; outer successor splits an index below old index or equal to it. Entry initialization chooses offset 0; entry successor chooses offset+1. Prove offset<8 using byte_eq_255_of_low_bits and byte<>255, derive the newly scanned bit from land, compose shifts, and eliminate 8-bit truncation from [0,127] range. No resource transformation.
- **P4: Array access.** Preserve all pure facts and manager/bucket frame, split full UCharArray into its indexed Znth cell and missing_i using explicit index bounds. The final write-preparation goal weakens the known cell to undef.
- **P5: Heap representation.** Open/fold store_idmanager and store_id_map; reuse the current byte existential. Preserve field addresses and buckets, convert quotient/division length, and transport separating conjunction, pure assertions, existential and byte/array cells across OSHeap using public crtos_heap_lift_sep and definitions. OSHeap_ushort_eq is public; other locally declared bridge facts are not assumed exported. No new helper declarations are planned.
- **P6: Result semantics.** query_eq connects testbits and membership. Split lower IDs between prior bytes (255) and the scanned prefix in this byte. Failure repacks the old manager. Success proves minimality and updates bytes_ok for id::old_ids using Znth replacement, lor/shiftl testbits, distinct bit indices and old freeness; instantiate the map witness with the actual updated array. Buckets keep the old membership relation until linking. This is heap/bitmap refinement; no scheduler or safeExec transition occurs in these VCs.

# VC Deltas

All names below use the `proof_of_AllocId_` prefix. Repeated routes refer to the patterns above; concrete per-target execution strategies are in group_plan.json.

| VCs | Pattern and actual difference |
| --- | --- |
| safety_9 splits 1/2 | P2: idmax+7 upper/lower integer bounds. |
| safety_19 splits 1/2 | P2: index*8 upper/lower integer bounds. |
| safety_22 splits 1/2 | P2: id+1 upper/lower bounds via entry invariant. |
| safety_27 splits 1/2/3/4 | P2: signed truncation upper/lower bounds; C remainder bounded by 7 and nonnegative. Derive id>=0 before rem-to-mod rewriting. |
| entail_2 | P5: open the byte existential, emit fields and both interpretation facts; select either identical whole-goal disjunct. |
| entail_3 splits 1/2 | P3 empty prefix; P2 nonnegative byte count. |
| entail_4 split 1 | P3 outer prefix successor from byte=255. |
| entail_5 split 1 | P3 entry offset=0 and byte range. |
| entail_6 split 1 | P3 offset+1, newly true low bit, composed right shift and truncation normalization. |
| return_1 | P6/P5: success disjunct; updated byte-list witness; membership gains exactly id and remains unlinked. |
| return_2 | P6/P5: full because id>=idmax and every smaller ID is covered by the two prefixes. |
| return_3 | P6/P5: full because index=end covers every valid ID byte. |
| safety_1/2/3/4/5/7/12 | P1: literal zero bounds. |
| safety_6 | P1: manager=0 contradicts manager<>0. |
| safety_8/28 | P1: divisor 8 is nonzero and differs from -1. |
| safety_10 | P1: literal seven bounds. |
| safety_11/20/30 | P1: literal eight bounds. |
| safety_13 | P1: literal 255 bounds. |
| safety_14 | P2: index+1 bounded by end<=8192. |
| safety_15 | P1: index>=end and index<=end contradict index<>end. |
| safety_16 | P1: index=end contradicts index<end. |
| safety_17/25 | P1: literal one differs from INT_MIN. |
| safety_18/21/24/26/29 | P1: literal one bounds. |
| safety_23 | P1: shift count one lies in [0,7]. |
| entail_1 | P5 reflexive heap; manager<>0 and four reflexive local-zero equalities. |
| partial_solve_1/2/3 | P4: outer read, selected byte read, success-path read; retain each exact pure guard set. |
| partial_solve_4 | P4: success-path write preparation additionally weakens byte cell to undef. |

# Grouping Decisions

Risk-first ordering places entry-scan bit reasoning and the independent allocation-result proof first, followed by full-result proofs. The success singleton is justified by its independent updated-bitmap result transformation; separating it prevents the final-result work from hiding inside an oversized transition group. Outer initialization/progression and bounds share byte-count context. Array decomposition is separate. Remaining literal safety and contradictory control paths are grouped by program stage. No group depends on sibling outputs; absent formal_case_lib prohibits new helper planning, so all needed local facts remain assertions inside their own witness.

| Group | Top-level count | Aggressive split count | Difficulty |
| --- | --- | --- | --- |
| entry_scan | 3 | 4 | 4 |
| allocation_result | 1 | 0 | 5 |
| full_results | 2 | 0 | 4 |
| outer_scan | 6 | 7 | 3 |
| array_access | 4 | 0 | 2 |
| initial_values | 6 | 0 | 1 |
| outer_literals | 6 | 0 | 1 |
| control_paths | 5 | 0 | 1 |
| inner_literals | 6 | 0 | 1 |
| mask_safety | 4 | 4 | 2 |

# Risks or Blockers

No semantic blocker was identified. The allocation-result proof has the highest burden: byte update semantics, NoDup/range preservation, and carrier conversion for the folded array. Entry-scan progression also needs careful testbit/shiftr reasoning and unsigned truncation. All premises for these mathematical facts are present. They are proof effort risks, not reasons to weaken predicates, contracts or frozen definitions. Successful coq-debug confirms current input loading only; the generated Admitted/Abort seed is still awaiting the planned implementation proofs.
