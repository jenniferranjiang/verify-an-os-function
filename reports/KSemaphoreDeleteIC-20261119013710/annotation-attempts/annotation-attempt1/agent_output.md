# KSemaphoreDeleteIC annotation delivery

Signature: void KSemaphoreDelete(int32 id).
Preconditions: the frozen dataqueue_cleanup_ic contract provides semaphore_delete_quiescent(id,before) and os_inv(sg,before).
Output: restore os_inv for an after state satisfying the existing semaphore_delete_ic_effect. Invalid IDs and absent objects preserve abstract state; an applicable quiescent object is removed under that effect. This natural-language meaning is the frozen Rocq relation and Ensure; no new definition or case library is needed.

Canonical C, headers, imported contracts and frozen target contract were not modified. The caller-local _SemaphoreDelete IC contract and target wrapper contract are text-normalized identical to the current internal canonical contract, whose implementation has completed its separate workflow. Existing call selection is retained. There are no loops, direct field accesses or additional internal operations in this wrapper. The OC path remains unchanged.

Controller formal-case-lib-design passed (absent policy: skipped), then symexec passed and published the four formal VC files. IC=1 and OC=0 GCC -m32 syntax checks passed. The generated goal contains the callee precondition obligation and the existential after-state return; all 3 top-level VCs are native automatic results. Generated auto keeps native Admitted placeholders, while manual has only its prelude and no obligations. No proofs were moved, authored or removed by this annotation owner. This is not a full Rocq proof-term claim and does not replace main's remaining workflow/final-check.

No raw Rocq compilation or MCP source transmission was used; main's dependency/parent checks must still typecheck and validate the generated current files. No source-root file or trust assumption changed. No failed-VC comparisons apply to this first attempt.
