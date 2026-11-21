# KSemaphoreObtain annotation result

Signature: `int32 KSemaphoreObtain(int32 id, int32 msec)`.
Preconditions: the frozen refinement precondition is `safeExec(LastSeen(before), abs_semaphore_obtain(sg,id,msec),X)` and `OutsideCritical(sg,before)`. No additional scalar restriction is introduced: the reviewed underlying abstraction includes invalid IDs and timeouts.
Output: return the outcome of that same abstract semaphore obtain operation and return the outside-critical resources at its resulting state. This is partial correctness, not a blocking termination claim.

The existing Rocq abstraction and C contract are retained byte-for-byte; no new predicate, case library, invariant, Assert, or source change was needed. The only executable call is `_SemaphoreObtain(id,msec)` and its return value is directly returned. Whitespace-normalized caller-local callee contract equals the current canonical `_SemaphoreObtain::semaphore_obtain_oc` exactly. The callee now has its own completed workflow; imported subdependencies and trusted/model boundaries remain those of that result, not new trusted declarations.

The original source has static `done.SemaphoreObtain = _SemaphoreObtain` and the wrapper calls that member; the canonical direct-call adaptation and removal of KDEBUG_NOT_IN_INTERRUPT agree with the existing approved context/TrustBase. No new direct global access or heap access occurs in this wrapper.

The supplied formal-case-lib-design command returned exit 0/status passed/skipped (absent policy). Supplied symexec returned exit 0/status passed. It generated three native auto witnesses and no manual obligations. Generated files were changed only through that command. Manual proofs were not edited. No previous failed VCs exist; comparisons remain empty. Annotation success is not final-check success; main must continue the workflow.
