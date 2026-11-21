# LinklistResume annotation r1

Signature: x_err_t LinklistResume(DoubleLinklistType *list).
Preconditions: list is a registered semaphore pending head, its abstract waiting sequence is nonempty, and os_inv owns all current shared resources.
Output: return 0; there is an after-state satisfying the existing semaphore_resume_head_effect and os_inv. No direct exstatus write or termination claim for imported callees.

Existing lib/semaphore/KSemaphoreAbandon.v supplies the frozen pure effect. KTaskWakeup and CONTAINER_OF contracts match the existing caller source LinklistResumeAll.c. Imported contracts remain boundaries, not newly proved bodies. No loops/new predicates/case lib.

Planned resource views: extract the actual nonempty pending head and its task alignment from os_inv; borrow/restore head node_next, then borrow the registered task ID UShort and restore os_inv before the reused wakeup call. All wands are existing sep-logic operators with actual proof obligations.

formal-case-lib-design passed/skipped (absent policy). Main is arranging independent review of the preauthorized evaluate-once ID argument split; this owner has not modified executable C.

Main supplied independently reviewed source split dq-resume-id-evaluate-once-20261119-r1; annotation resumed afterward. Four which-implies annotations borrow/restore actual head pointer and ID cell, with existing wand; first symexec failed at return due to lost task local permission from the final resource view. Explicit local value bridges in restoration views fixed that resource loss. Second symexec passed, producing 7 manual tops/3 splits and 12 auto.

The 7 tops include two generated KTaskWakeup derived-contract entailments, although this is a reused-spec boundary (one entailment is unused detached-null specialization). Main authorized reducing caller imports to the actual existing semaphore_pending_head_ic complete contract without a local <= derivation; no logic change in its With/Require/Ensure. Current C writing stopped for independent applicability/interface review; baseline /tmp/crtos-verify-resume-import-contract-l3l6jnmc/LinklistResume.before.c. No new symexec until review completes.

Independent import review dq-resume-reused-contract-20261119-r1 passed: existing source revision43a2b34e, exact With/Require/Ensure and same named contract, no new specialization/trust or body target. Main removed temporary baseline after review. Final symexec exit0/status passed; current 5 manual top-level witnesses, 3 generated splits and 12 native auto. Full frozen LinklistResume spec unchanged. Only four local view/restore annotations plus minimal existing vocabulary imports; no new lib/predicate/helper proofs. Final caller KTaskWakeup requires actual same ID registered to pending head, all applicability duties remain current which-implies and return VCs.

Formal prelude includes existing SimpleCtypeNotations to avoid known shallow syntax gap; VC checker should perform actual load using its authorized coq-debug because absent case-lib design check only skips library compilation. No manual proof edited. Ready for main acceptance; this is annotation completion, not implementation proof.
