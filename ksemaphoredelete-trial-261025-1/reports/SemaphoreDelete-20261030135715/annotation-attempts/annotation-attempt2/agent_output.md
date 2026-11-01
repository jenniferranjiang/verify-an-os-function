# _SemaphoreDelete annotation attempt 2

The VC reviewer identified that the old manager ID uniqueness was lost across IdRemoveObj. Its removal operation filters every matching ID, so a well-formed post-manager does not imply uniqueness of the deleted ID in the old state. The old retirement witnesses _SemaphoreDelete_entail_wit_4_2 and _SemaphoreDelete_entail_wit_4_4 therefore could not identify the returned ID node as the target semaphore's node.

The annotation now extracts NoDup(map(semaphore_id, drained.os_semaphores)) from the complete pre-removal os_inv, alongside the existing selected-object and query facts. This uses the actual old manager's idbuckets_ok/idlist_ok resource condition; it is not added to any input contract. The pure fact remains outside the callee-owned manager and is preserved across both IdRemoveObj and DoubleLinkListRmNode. Frozen predicates, canonical and caller contracts, all four existing view definitions, and executable C are unchanged.

Validation and exact old/current VC comparisons are pending regeneration.

## Current VC comparisons

The current symexec passed. Directly compared the historical and regenerated goal definitions, as well as both corresponding proof-manual lemma names. In each of _SemaphoreDelete_entail_wit_4_2 and _SemaphoreDelete_entail_wit_4_4, both alternative proof routes now have the same new premise NoDup(map semaphore_id drained.os_semaphores). After removing exactly this premise and normalizing only hypothesis numbering, every other old/current goal token is identical. The spatial inputs, existential after, safeExec continuation, os_inv and SemaphoreRetired conclusions are unchanged.

The establishing obligation _SemaphoreDelete_which_implies_wit_7 still takes full os_inv(sg, drained) as its spatial input; its output now includes the NoDup fact alongside the complete old manager and concrete manager frame. It does not assume NoDup on its left. The source is store_idmanager's idbuckets_ok, whose idlist_ok component contains NoDup; semaphore_manager's idlist is exactly map semaphore_id. These laws remain proof obligations, rather than new trusted facts.

Consequently the reviewer's two-object/same-ID countermodel is excluded at the retirement boundary. The existing contains(old,id,idnode_2) fact can now be combined with the selected object's membership and ID to identify the returned node. The necessary pure/list/resource bridges still require proving, but the old missing-premise gap is repaired. Both comparisons include the current retirement witness and which-implies_7, so verification will check the new fact's establishment as well as its use.

Only the NoDup annotation and Extern declarations for existing NoDup/semaphore_id were added in this attempt. There are no new predicates or changed view definitions. The first symexec retry needed the explicit semaphore_id function-value declaration (record-field syntax alone did not register it for map); after that correction, symexec passed. The design check passed; post-symexec case-lib validation is running.

Final validation: formal-case-lib-design passed in 46.655 seconds; current symexec passed in 1.658 seconds; post-symexec formal-case-lib passed in 56.923 seconds, reusing 197 unchanged base artifacts. Both requested VC comparisons are resolved. This is an annotation repair, not a completed proof of the retirement obligations. No generated proof file was hand-edited.
