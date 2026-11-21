# SemaphoreDeleteIC VC checking r1

## Outcome

No definite structural countermodel found. All 14 manual top-level obligations are covered by four independent groups. All 11 generated split goals are judged provable; eight parents use aggressive_pre_process and six no-split parents use LLM_pre_process. This is proof planning, not implementation proof or final-check. No canonical/debug source was modified, no proof was written, and no compiler or MCP success is claimed by this review.

## Structural Blocker Scan

Scanned every top-level obligation, prioritizing the six no-split whole goals. Current/entry IDs are joined by the retained equalities; sem is linked to original.semaphore_addr, and idnode to its embedded IdNode. IdRemove's returned node is not simply assumed to equal the original: the pure manager membership plus NoDup IDs must establish that in entail_wit_3_2. The removed management link, payload, empty pending list, returned ID node and both padding regions together supply the full object for reclaim; the remaining global resources include dataqueue_inv throughout. entail_wit_3_1 has contradictory query booleans and is unreachable. return_wit_1's null global address is contradicted by the already imported QCP addr_of_LE_var_not_zero fact (CNotation.v); no new global-address assumption is planned. No arithmetic range is demanded without a current source.

The pure claim that unpublish removes exactly original is not automatic from NoDup IDs. It additionally needs the spatial duplicate-address exclusion between the detached payload and the remaining management DLL. This is included as a real high-risk proof obligation, not a free premise.

## Annotation Comparison Review

Handoff annotation_comparisons is empty (first VC attempt). The newly exposed NoDup IDs is sourced from the actual manager's id_map_bytes_ok/idbuckets_ok, whose idlist_ok contains NoDup. Original selection comes from store_idmanager_found and the derived bucket list. Quiescent plus normalized valid ID establishes the empty pending list. The pending and ID read annotations use ownership plus an exact separating implication for restoration; they do not add a second os_inv owner.

Independently compared the current caller IdRemoveObj dataqueue_ic_low_level_spec with annotated_C/src/kernel/id/IdRemoveObj.c low_level_spec: same sm/m parameters, bounds and manager resource; same miss alternative; same existential node, query, contains, nonzero facts, updated manager, 65535 UShort ID and self-linked pointer cells. Explicit field_addr with IdNode/SysDoubleLinklistNode and typed store merely desugars the old arrow-field shorthand. It does not strengthen its result or erase memory. The generated entail_wit_3_2 uses exactly those IdNode UShort/Ptr cells. No callee proof completion is inferred.

The original pending/KTASK_ASSIGN branches remain in canonical C. Pending is nil before IsDoubleLinkListEmpty; its existing contract forces return 1, so the resched=1 body is unreachable under this IC spec. The annotation still has to prove the nil premise. Generated guards retain resched=0 and the native auto routes cover the impossible scheduling branch. This is quiescent cleanup only, not a proof of general concurrent deletion or LinklistResumeAll.

## Split-First Judgments

All judgments below were made before selecting top-level modes or writing detailed strategies:

| Split (common prefix proof_of__SemaphoreDelete_) | Judgment |
| --- | --- |
| return_wit_3_split_goal_1 | Provable: invalid negative ID, unchanged state |
| return_wit_4_split_goal_1 | Provable: invalid high ID, unchanged state |
| partial_solve_wit_9_pure_split_goal_1 | Provable: existing named-variable address nonzero fact |
| which_implies_wit_1_split_goal_1 | Provable: manager metadata supplies NoDup IDs |
| which_implies_wit_1_split_goal_2 | Provable: semaphore_inv supplies context |
| which_implies_wit_1_split_goal_3 | Provable: os_inv supplies world wf |
| which_implies_wit_1_split_goal_spatial | Provable: unfold/reorder full invariant |
| which_implies_wit_2_split_goal_spatial | Provable: select payload, borrow nil pending DLL and retain restoring wand |
| which_implies_wit_3_split_goal_spatial | Provable: pending ownership and its wand eliminate to os_inv |
| which_implies_wit_4_split_goal_spatial | Provable: select ID manager node and borrow its ID cell with restoration |
| which_implies_wit_5_split_goal_spatial | Provable: ID cell and its wand eliminate to os_inv |

## Proof-Mode Decisions

Manual declaration order: entail_wit_1, entail_wit_2, entail_wit_3_1, entail_wit_3_2, return_wit_1 and return_wit_2 have no split and use LLM_pre_process after whole-goal analysis. return_wit_3, return_wit_4, partial_solve_wit_9_pure, and which_implies_wit_1 through which_implies_wit_5 use aggressive_pre_process because all their splits above are provable. No split is discarded or left for an unsupported route.

## Common Proof Patterns and VC Deltas

- Invariant exposure/restoration: os_inv -> semaphore_inv plus the unchanged frame; context rewrites manager/list pointers. which_implies_wit_1 extracts pure metadata; entail_wit_2 additionally chooses prefix/suffix around original; return_wit_2 closes the same original state.
- Membership and lookup: derived 16-bucket manager uses maps and filters. entail_wit_1 converts the found IdNode into an original Semaphore and closes the found manager; entail_wit_2 obtains query=true from its known member. return_wit_2 instead uses query=false to exclude every matching ID, with id mod 65536=id from explicit bounds.
- Borrow/restore: which_implies_wit_2/3 borrow a payload's nil pending DLL and apply the restoring wand; which_implies_wit_4/5 borrow the ID cell from manager ownership and restore it. The different owners matter: payload contains no ID cell.
- Contradictory/invalid exits: entail_wit_3_1 substitutes equal IDs then discriminates booleans; return_wit_1 contradicts the named-global address; return_wit_3/4 choose the explicit invalid-input effect.
- Successful retirement: entail_wit_3_2 alone needs identity of the returned ID node, spatial exclusion of repeated addresses, exact filtered manager equality, removal of an empty waiter list, preservation of every Dataqueue reference under quiescent, and reconstruction of 32 bytes. Choose after=replace_semaphores(prefix++suffix,before), then show it is the stated unpublish state. Detailed premises and routes are in its plan entry. All local facts must be proved; absent case-lib means no planned helper declarations.

## Grouping Decisions

Plan order: retire_object (1 whole goal, difficulty 5), borrow_fields (4 aggressive parents/4 splits, difficulty 4), select_object (4 parents/5 splits, difficulty 4), early_returns (5 parents/2 splits, difficulty 2). Each group is independent and below the 12-witness hard limit. The single retirement witness is a genuine coupled final-state/resource transition; splitting its internal work into sibling groups would require an unavailable shared case-lib interface. It runs first to reduce the likely critical path. Borrowing and selection are separate because their mathematics and ownership traversals differ; easy returns are not left in the retirement group. No group dependency or unproved helper is introduced.

## Risks or Blockers

No definite blocker. The manager removal/filter equation and the borrowing of a particular ID node may require substantial list/bucket reasoning. Address uniqueness is proved from ownership, not assumed from ID uniqueness. The retired payload's raw memory proof must include both padding intervals. Dataqueue relations must be rebuilt with witnesses that survive removal; retaining only its store_map is insufficient. Existing ID/DLL/model contracts remain dependencies, not newly verified bodies. Native auto remains unchanged. No direct Rocq MCP call was made.
