# CriticalAreaLock annotation attempt 1

The accepted contracts are retained verbatim. The target has no lexical loop and introduces no predicates. No C, header, shared library, or generated proof file was edited.

Signature: `x_base CriticalAreaLock(void)`.
Preconditions: the accepted outside-critical ownership and entry scheduler nesting strictly below 65535.
Output: a valid saved IRQ handler, a state related by the accepted rely, inside-critical ownership, and the complete invariant with nesting incremented once. The existing Rocq predicates and C Ensure express this same relation.

The controller's exact `formal-case-lib-design` command returned exit 0 with `status: passed`, `skipped: true` because formal-case-lib policy is absent.

The controller's exact symexec command returned exit 1, `status: failed`, before reaching the target body. Its first failure is category `symbolic-execution`, kind `symexec-error`:

```
fatal error: Syntax error: unexpected token ':'; expected '::' in /home/xinra/crtos/ksemaphorecreate-trial-261012-1/annotated_C/include/semaphore_logic.h:23:12
```

Line 23 is `(OSHeap : Task_C_Rules::expr -> Assertion)`. It follows eight kind declarations using `:: *` in the same Extern Coq block. This is an annotation grammar failure in the shared frozen interface, not a failed semantic VC or missing resource; no symbolic state or VCs were produced. All four generated target files remain missing.

The minimal likely repair is to end the kind-declaration Extern Coq block after `(Task_C_Rules::expr :: *)` and start a separate term-declaration Extern Coq block before OSHeap. This follows the installed official example `QCP_examples/Applications_human/minisat/solver_qcp.h`, whose kind declarations and term declarations occupy separate blocks. The existing qualified type has not yet been rejected; do not introduce an alias without a subsequent concrete diagnostic.

The repair is outside this owner's writable file boundary and touches an accepted shared spec interface. Main has directed returning it to the design author for syntax-only adaptation and independent re-review under the user's existing authorization. After the repair, resume this same annotation owner/attempt and rerun the exact handoff commands. The inherited call-site `where` annotation is also still present; its removal/adaptation remains a local pending role-style issue after parsing succeeds, without changing either frozen contract.


## Resume after shared-header syntax repair

Reviewed spec-r3 parser adaptation (`.docs/Report/2026-10-12-2-spec-review.md`) is effective: exact controller symexec now parses the complete header and reaches the target increment. Design check again returns exit 0 / passed / skipped.

The first current failure is a resource-shape gap at `CriticalAreaLock.c:31:4`, reading `KTaskOsAssignLockNest_560_addr`. Symbolic state retains:

```
semaphore_irq_handler_ok(lock)
SemaphoreRely(hs, before, current_589)
scheduler_lock_nest(os_scheduler(before)) < 65535
SemaphoreInsideCritical(sg, hs, lock, current_589) *
SemaphoreOSInvariant(sg, current_589)
```

The actual reviewed invariant owns the UShort cell via `OSHeap(CrtosBorrowedRep.store_scheduler_view(os_scheduler(current)))`. QCP has no unfolding strategy or annotation exposing it. This is not absent semantic ownership or a reason to strengthen Require.

Removed only the inherited proof-local call `where sg = sg, hs = hs, before = before`; both frozen contracts and ordinary C tokens remain unchanged. Exact design/symexec rerun reaches precisely the same resource state, confirming automatic call instantiation succeeds without it.

A required local Assert immediately before the increment can expose the nest cell, but it must preserve the full non-nest resource remainder. The existing accepted interfaces have no named remainder, and this owner's policy forbids a case lib or edits to shared formal files. Requested main route a precise nest-cell/remainder decomposition interface to the existing design owner and review, or authorize direct annotation exposure of the existing tail. This must preserve definitionally equivalent full ownership and produce genuine entailment VCs. No terminal success or fake infrastructure classification is claimed for this annotation gap; the same attempt remains pending that design repair.

Main requested terminal annotation-gap delivery for exact nest-cell view design repair; no VC exists yet because symbolic execution stops before generation. The prior infrastructure parser blocker is resolved. Stop writing after the following report; main owns finalize.


## Resume with accepted predicate-r5 / spec-r4

Read the updated handoff completely and the independent r5 predicate/spec-r4 reviews. The accepted `SemaphoreCriticalFrame` interface and split/merge proofs now expose the exact existing nest cell while preserving the complete remainder and token ownership. The active architecture is the accepted modern Coq Arch32 LittleEndian carrier configuration; prior historical compiler instructions no longer apply.

Added one ordinary Assert immediately before `KTaskOsAssignLockNest ++`, where prior symbolic execution demonstrably could not obtain readable memory. It retains handler validity, Rely, the original entry bound, the inside-critical token, and the exact full resource remainder, and exposes `CrtosOSValid(current)` plus `data_at(&KTaskOsAssignLockNest, unsigned short, scheduler_lock_nest(os_scheduler(current)))`. The assertion generates genuine entailment obligations using the reviewed split lemma; it neither assumes a new contract nor discards memory. Frozen Require/Ensure clauses and all ordinary C tokens are unchanged. No post-increment or return assertion is added.

The exact handoff design command returned exit 0, status passed (skipped by absent case-lib policy). The exact handoff symexec command then returned exit 0, status passed, publication committed. All four canonical generated files are present and were written exclusively by that controller command. The generated goal imports the accepted custom Crtos_C_Rules and emits the increment as UShort `unsigned_last_nbits(... + 1, 16)`, preserving actual narrowing behavior.

Inspected current generated goal and manual without edits. Three parent obligations remain: pre-increment entailment, return entailment, and partial-call entailment. The pre-increment obligation splits into pure validity and spatial views; the return still requires proving the full original existential postcondition from the actual written cell and full frame. No historical failed VC comparison applies because earlier executions failed before creating goals. Generated manual placeholders await the controller's proving owner; this annotation completion is not a claim that they have been proved.

Plan is ready, with no new predicates or loops. The semantic resource-shape gap is resolved at symbolic stage through the accepted exact view. No remaining annotation blocker. Terminal report written last; stop writing for main-owned finalize-delivery.
