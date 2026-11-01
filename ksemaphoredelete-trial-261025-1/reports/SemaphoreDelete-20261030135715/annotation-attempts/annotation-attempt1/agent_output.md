# _SemaphoreDelete annotation attempt 1

The supplied pred-r7/spec-r9 function contracts and shared predicates remain frozen. The void int32-handle API still implements the reviewed abstract delete operation: negative ID returns immediately; nonnegative ID is queried with uint16 conversion; a found semaphore has its waiters drained, ID deregistered and management node removed, then is freed outside the critical section. Scheduling occurs exactly when the original waiting list was nonempty. External callees retain the approved contracts; LinklistResumeAll has a separate body proof run.

## Annotation and local views

The active case lib adds four resource views: delete_global_frame, delete_manager_frame, delete_pending_restore and delete_id_restore. The manager remainder is concrete because ID deregistration is followed by management-DLL mutation. The two read-only views use spatial wands, consumed when returning the borrowed pending list or ID slot. No additional semantic assumptions, axioms or admitted lemmas were added.

Body annotations expose the manager for lookup, restore its found view and identify the semaphore, lend the pending DLL to IsDoubleLinkListEmpty, restore os_inv before LinklistResumeAll, and join empty/nonempty branches using the reviewed aggregate resume effect. They then read and return the ID slot, borrow the manager again for deregistration, preserve the management DLL through that intermediate state, and restore the updated os_inv plus a complete SemaphoreRetired allocation. The private allocation crosses unlock and is converted to SemaphoreRaw before free. The conditional tail carries the corresponding safeExec continuation.

The single executable normalization is the approved exact argument-read split: uint16 delete_sem_id = sem->id.id, followed by the same IdRemoveObj call using that temporary. It gives annotations a point to return the read field before lending the complete manager. The controller checks its inverse executable-token mapping. All remaining C executable tokens and all caller/canonical contract blocks are preserved.

## Diagnostics resolved

The first symexec stopped in existing IdRemoveObj declarations because idnode->id was inferred using an ambiguous struct field. Main added a recorded parser-only normalization using existing explicit IdNode field_addr/store syntax, plus consistent alpha-renaming of the second polymorphic binder in DoubleLinkListRmNode/remove_from_head. Canonical contracts were not edited. The controller applies these adaptations during ordinary symbolic execution and replay.

The first full-library design check exhausted the 900-second read-only external-kernel budget. Retrying after the shared kernel receipt became available reached a normal missing-import diagnostic; explicit Mem/SeparationLogic/MapLib and Interface imports fixed it. Strings.String was already imported.

The first body symexec lost the implicit local sem slot across a Which implies whose RHS did not mention it. The repaired ID-slot restore retains sem == original.semaphore_addr on both sides. Inspection of the regenerated _SemaphoreDelete_which_implies_wit_6 confirms that equality is an explicit premise, rather than an unproved extra conclusion.

## Validation and remaining work

The current formal-case-lib-design check passed (76.948 seconds, 197 reusable base artifacts). Current controller symexec passed and produced the complete goal, auto, manual and goal-check family. The final post-symexec formal-case-lib check passed (58.326 seconds, same 197 base artifacts). This is the first annotation attempt, so vc_comparisons is empty.

All generated entailments, safety checks, call conditions, resource-view laws, retirement conversion and safeExec bridges remain for VC checking/proving. This annotation delivery does not claim the function body has been proved. No generated proof manual was hand-edited.
