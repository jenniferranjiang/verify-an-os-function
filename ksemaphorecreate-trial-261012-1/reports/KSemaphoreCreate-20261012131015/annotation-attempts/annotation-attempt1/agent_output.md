# KSemaphoreCreate annotation r1

Signature: `int32 KSemaphoreCreate(uint16 val)`; `_SemaphoreCreate` is the frozen caller-local callee interface.

Preconditions: the accepted `scheduler_lock_nest(os_scheduler(before)) < 65535` domain and `SemaphoreOutsideCritical(sg, hs, before)` ownership. The `uint16` argument retains its source type. Deeper entry nesting remains excluded.

Output: return -5 with the original state, or return -5 with a rely-related state whose semaphore ID manager is full, or return the minimum free ID and publish a nonzero-address semaphore initialized with `val` in a rely-related state, with the accepted guarantee and outside-critical resources restored. The existing Rocq relations and both frozen C Ensure clauses express precisely these three alternatives; no new predicate or wrapper is introduced.

Change: removed the existing call `where sg = sg, hs = hs, before = before` annotation. QCP infers these arguments from the unchanged precondition and resources. No executable C token, function contract, shared predicate or formal dependency was changed. There are no loops or added ordinary assertions. `formal_case_lib` remains absent.

Controller checks, in required order and exact handoff cwd/argv:

- `coq-check --target-kind formal-case-lib-design`: exit 0, JSON `status: passed`, skipped under the absent policy.
- `symexec`: exit 0, JSON `status: passed`, returncode 0; all four generated files published with `publication.status: committed`.

Read the actual generated goal and proof files. The 5 exported obligations are `KSemaphoreCreate_return_wit_1`, `_return_wit_2`, `_return_wit_3`, `_partial_solve_wit_1_pure`, and `_partial_solve_wit_1`. They retain the direct failure, full-manager failure, successful publish branches and call precondition. Their premises expose the matching callee facts and exact outside-critical resources. No annotation gap was found. This is the initial attempt, so there are no failed-VC comparisons.

Only symexec wrote generated files. Generated proof stubs are not completed proofs; VC checking and proving remain for subsequent controller actions. The annotation owner has not edited or proved manual VCs and does not claim whole-function completion.

Ready for main-owned finalize-delivery.
