# Outcome

Completed VC analysis and a six-group plan covering all 19 current top-level VCs. Four split goals are provable; their three parents use aggressive_pre_process. The other 16 top-level VCs have no splits and use LLM_pre_process. This is a proofability assessment, not completed implementation verification. The exact handoff coq-debug command exited 0 with JSON status passed using pv-bench-8.20.1; the debug copy was unchanged and no Show expansion was needed because all definitions were readable in the current goal file.

# Structural Blocker Scan

Scanned every top-level declaration, prioritizing entail_1, entail_2, all ten safety VCs and four partial-solve VCs, which have no splits. Current/pre manager and node addresses agree throughout. The allocated-unlinked manager provides the already-updated bitmap and old buckets; the detached representation provides the node id and exact previous/next cells. The selected bucket can be exposed using the modulo index and old length invariant. Both bucket branches retain the bitmap, manager fields, detached-node resources and bucket-except frame. Return contains all four changed DLL cells, node id and the shifted old bucket required to reassemble the manager. No missing resource, equality bridge or concrete countermodel was found. Whole disjunctions and all spatial alternatives remain in the formal inputs.

# Annotation Comparison Review

- entail_2 at C:103: independently verified store_uninit_idbucket includes head<>0, and both alternatives of store_idbucket_cases preserve it (shared-candidate/arm32le/idnode.v:476,660). store_idbuckets_split (line 736) extracts precisely the selected bucket. Its range follows from positive hoffset and idbuckets_ok length. Thus BSS head nonzero has a premise source, not a typed-cell or layout inference.
- entail_3_1 and entail_3_2 at C:130: current whole goals and splits carry link<>0 as PreH6/PreH7. The responsible establishment VC is entail_1: store_sem_id_detached (lib/SemaphoreRep.v:33) explicitly owns p<>0 and embedded-link<>0 plus the exact detached cells. entail_2 retains that fact in both alternatives; partial_solve_1 and both branch VCs preserve it. partial_solve_2 consumes it directly. This closes the propagation chain within InsertObj without claiming callers' independent proofs are finished.
- Related return uses node and link nonzero to rebuild the new list representation. Its mathematical bucket-invariant update remains substantial but needs no new semantic premise. The comparisons' resolved labels were not used as proof evidence.

# Proof-Mode Decisions

The split pass was completed before whole-goal mode analysis. In manual declaration order, its entire result is:

| Split (prefix proof_of_InsertObj_) | Binary judgment |
| --- | --- |
| entail_wit_3_1_split_goal_1 | Provable |
| entail_wit_3_1_split_goal_spatial | Provable |
| entail_wit_3_2_split_goal_spatial | Provable |
| return_wit_1_split_goal_spatial | Provable |

All top-level declarations, in manual order:

| Top-level suffix | Split suffixes | Mode |
| --- | --- | --- |
| entail_wit_1 | none | LLM_pre_process |
| entail_wit_2 | none | LLM_pre_process |
| entail_wit_3_1 | split_goal_1, split_goal_spatial | aggressive_pre_process |
| entail_wit_3_2 | split_goal_spatial | aggressive_pre_process |
| return_wit_1 | split_goal_spatial | aggressive_pre_process |
| safety_wit_1 | none | LLM_pre_process |
| safety_wit_2 | none | LLM_pre_process |
| safety_wit_3 | none | LLM_pre_process |
| safety_wit_4 | none | LLM_pre_process |
| safety_wit_5 | none | LLM_pre_process |
| safety_wit_6 | none | LLM_pre_process |
| safety_wit_7 | none | LLM_pre_process |
| safety_wit_8 | none | LLM_pre_process |
| safety_wit_9 | none | LLM_pre_process |
| safety_wit_10 | none | LLM_pre_process |
| partial_solve_wit_1_pure | none | LLM_pre_process |
| partial_solve_wit_1 | none | LLM_pre_process |
| partial_solve_wit_2_pure | none | LLM_pre_process |
| partial_solve_wit_2 | none | LLM_pre_process |

The three aggressive parents were assigned their mode solely from their all-provable split sets; no second whole-goal analysis or whole-goal strategy is prescribed. No previous-attempt proofability result was consulted.

# Common Proof Patterns

H — Heap transport: OSHeap is crtos_heap_lift on the current OS carrier. Use exported crtos_heap_lift_sep and crtos_heap_lift_entails; use OSHeap_ushort_eq for UShort cells. Pure conjunctions and existential/disjunction distribution follow by unfolding lift. Pointer cells transport by unfolding the typed pointer/byte stores over the same heap and normalizing the token/state components. Relevant OSHeap_sep_eq, OSHeap_entails, OSHeap_pure_and_eq etc. in SemaphoreCriticalViews are Local, so do not assume their identifiers are importable. Any required bridge equality must be established inside the assigned proof from exported facts/definitions. No new helper declarations are planned.

B — Bucket extraction and DLL conversion: use old length and positive hoffset to bound id mod hoffset, then existing store_idbuckets_split/store_idbucket_cases. Frame all untouched manager/bitmap/node resources. The existing DLL.dllseg_to_dllseg_shift_rev consumes the old head.prev cell with the old segment and exposes successor.prev plus the shifted segment, including the initialized-empty case.

E — Empty bucket: rewrite bucket=Znth= nil. idnodes_nonzero reduces to Forall nil. The shifted reverse nil segment at head/head is a reflexive pure fact with emp, requiring no memory.

R — Final reconstruction: new node is Build_IdNodeAbs id idnode_pre; new bucket is node::bucket. Use existing DLL insertion and reverse-to-ordinary conversion, recover nonzero endpoint from the represented links, then store_idbuckets_replace. Establish the updated idbuckets_ok inside the proof by prefix/selected-bucket/suffix decomposition, freshness from min-free, preserved length and hash index, Forall/NoDup extension, and permutation of concatenated node ids. The source is before with allocated bitmap; the target is idmanager_link sm (idmanager_add before id) id idnode_pre. This is a heap/data refinement; there is no safeExec or protocol-state transition in these goals.

P — Call obligations: pure call conditions are direct listed hypotheses. The auxiliary goals merely retain pure facts and rearrange the frame; InitDoubleLinkList additionally forgets the exact zero values into undef stores. Each implication is proved directly after introducing its premise, without sibling proofs.

S — Safety: closed Arch32 zero bounds, contradictory null checks, or positivity of the modulo divisor. No representation unfolding is necessary.

# VC Deltas

| Formal target suffix | Pattern and actual difference |
| --- | --- |
| entail_wit_1 | H: open two compound representations; choose whole-goal second alternative and witnesses next,previous; derive id/hoffset UShort bounds while retaining their cells. |
| entail_wit_2 | H/B: selected-bucket witness plus branch-local hp/hn; derive head nonzero from both accepted cases and keep link metadata. |
| entail_wit_3_1_split_goal_1 | E: only nil nonzero-list fact; spatial antecedent unchanged. |
| entail_wit_3_1_split_goal_spatial | H/E: add emp shifted nil segment after rewriting Znth; bitmap and bucket-except cancel. |
| entail_wit_3_2_split_goal_spatial | H/B: x=hn,px=head,y=head,py=hp; transfer one prev cell across the segment. |
| return_wit_1_split_goal_spatial | H/R: fold node/link cells, replace the selected bucket and prove the global invariant; all existential tail/decomposition witnesses come from existing spatial predicates. |
| safety_wit_1,3,4,6,8,9 | S: closed INT_MIN<=0<=INT_MAX; entry, initialized and BSS frames differ but are irrelevant. |
| safety_wit_2,5,10 | S: contradictions manager=0 versus nonzero, node=0 versus nonzero, hp=0 versus nonzero respectively. |
| safety_wit_7 | S: hoffset>0 excludes 0 and -1, proving both remainder clauses. |
| partial_solve_wit_1_pure | P: reflexive head equality and existing head nonzero. |
| partial_solve_wit_1 | P: two exact-zero head stores weaken to undef; preserve complete frame. |
| partial_solve_wit_2_pure | P: head, link and successor nonzero are direct hypotheses. |
| partial_solve_wit_2 | P: pure duplication and exact spatial permutation only. |

# Grouping Decisions

Plan order is manager_open (2 top-level, no splits, difficulty 4), bucket_insert_ready (2 top-level, 3 formal splits, difficulty 3), final_result (1 top-level/1 formal split, difficulty 5), call_preconditions (4, difficulty 2), entry_safety (6, difficulty 1), bucket_safety (4, difficulty 1). All are below the hard limit 12; no helpers are declared because formal_case_lib is absent. The comparison current VCs occupy the first two groups, and entail_1 is colocated with entail_2 because it establishes the newly propagated link fact. Final return has distinct invariant/permutation work and is an independent singleton; splitting it away prevents coupling simple call/safety tasks to the largest proof. Groups use only immutable inputs and do not read sibling output.

# Risks or Blockers

No semantic blocker identified. Highest risk is the in-proof idbuckets_ok insertion argument and nonzero DLL endpoint reconstruction in final_result. OSHeap/native-pointer transport is an engineering risk in the two semantic groups, not a missing premise; Local bridge lemmas cannot be cited as exported APIs. The debug pass establishes current environment loading only; generated Admitted seeds remain to be replaced by the proof workers. Canonical files, accepted shared sources and the debug copy were not modified.
