# KSemaphoreCreate annotation attempt 1

Signature: `int32 KSemaphoreCreate(uint16 val)`.

Preconditions: the frozen `safeExec (LastSeen before) (abs_semaphore_create sg val) X` premise and `OutsideCritical sg before` resource. `val` has the C unsigned-short representation. The current user spec is frozen and is not strengthened with a new scalar-range premise.

Output: return -5 or a nonnegative ID below 128; existentially return an observation `after` together with `safeExec (LastSeen after) (ret result) X` and `OutsideCritical sg after`.

The existing Rocq vocabulary in `KSemaphoreCreateTrial.KSemaphoreCreate` and `TrialShared.CrtosRules` already expresses this refinement; no duplicate predicate is introduced. The declaration contract of `_SemaphoreCreate` exactly matches the wrapper contract, so the wrapper proof uses the callee spec and does not re-prove its body.

Removed the unnecessary legacy `by local` range annotation and explicit call `where` instantiation. Ordinary C tokens and both frozen contracts remain unchanged. There are no loops and no intermediate assertions. The case library remains its import-only seed. The separate `_SemaphoreCreate` implementation run must complete before the combined API can be described as verified.

Validation completed with the exact handoff commands and cwd: `formal-case-lib-design`, canonical `symexec`, and `formal-case-lib` all exited 0 and returned JSON `status: passed`.

Reviewed the generated goals: two return obligations select the callee post-state witness, and the call obligations preserve the unchanged `safeExec` premise and `OutsideCritical` resource. No annotation gap is visible. The generated proof-auto contains four `Admitted` placeholders; these are unproved obligations for the subsequent proving phase, not completed proofs. Generated files were changed only by canonical symexec; no proof was written by this annotation owner. There are no failed VC comparisons in this first attempt.
