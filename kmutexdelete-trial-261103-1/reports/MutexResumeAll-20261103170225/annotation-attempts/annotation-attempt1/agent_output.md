# MutexResumeAll annotation attempt 1

Frozen signature: x_err_t LinklistResumeAll(DoubleLinklistType *list). Preconditions/Output are exactly the reviewed mutex_waiters_oc contract; no function spec is changed. Under A1, acquire the live mutex, process the actual locked waiting sequence into READY/-ERROR with delay cancellation and original-order RRR insertion, release the lock, return 0 with drained historical observation and unchanged continuation.

Added one invariant per lexical loop, exact single-cell wand restore views, and which-implies/call where annotations under the explicit OS adaptation. The drain invariant records a semantic completion relation using the existing reviewed steps/effect definitions, not a new execution-chain model. All resource split/merge, initialization, preservation and exit consequences remain generated proof obligations.

Source adaptation authorized by main: task->id.id is evaluated once into local int32 resume_task_id before KTaskWakeup(resume_task_id), with only ghost annotations between. Integer promotion/value, lock boundaries, argument read count and executable side-effect order remain unchanged. This is the same normalization used by the root semaphore slice; it is not a source bug fix.

No formal lemma, manual VC or shared predicate has been modified or assumed.

First design compile passed. First symexec returned -11 after announcing the target function, with no generated artifacts and no line diagnostic. The first targeted compatibility repair normalizes the empty for(;;) loop to while(1), separately authorized by main; the body/break and both lock boundaries are unchanged. This matches the existing root semaphore slice normalization.

After empty-for normalization, the driver reached a precise symbolic resource failure at the loop's `node != list`: the next-field which-implies used the C local `list` and accidentally consumed its local cell. Repair uses the invariant's retained `list == list@pre` bridge and logical `list@pre` for borrowed field views, leaving the C local cell framed. This is annotation resource repair only.

The next failure was annotation scope at loop exit: logical current/remaining were opened inside the loop block and unavailable after its closing brace. Added explicit Given reopening at the exit; no function contract or mathematical relation changed.

Final checks: formal-case-lib-design passed (target actually recompiled, 198 existing base objects reused); controller symexec passed and atomically published all four generated outputs; post-symexec formal-case-lib passed with target recompiled. Current manual has 62 top-level obligations, including retained declaration-specialization derivations. No generated file was edited by hand; no proof has been supplied or claimed. First-attempt vc_comparisons is empty as required.

Frozen signature/With/Require/Ensure blocks and readonly shared inputs remain unchanged. The only executable normalizations are the two main-authorized ones above. The generic annotation restriction on where/which-implies is overridden only by the explicit OS handoff adaptation; these annotations preserve actual resource obligations rather than assuming them. Remaining mathematical and separation-logic work is for independent VC checking/group proving.

Delivery ready; terminal report written last, owner stops writing pending main finalize.
