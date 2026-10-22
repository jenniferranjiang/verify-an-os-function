Signature: int32 _SemaphoreCreate(uint16 val).
Preconditions: frozen safeExec abstract creation capability and OutsideCritical.
Output: frozen refinement return -5 or published ID in [0,128), with OutsideCritical restored.

All public/callee contracts unchanged. User-requested by-local range assertion retained as an explicit user override of default annotation style. No new axioms, predicates, or C semantic changes. Case-lib seed only imports current proved byte-layout/ownership/spec bridges and existing semantic vocabulary. Resource cuts connect zero-byte memset to typed fields, return unknown ID failure ownership to SemaphoreRaw, pass complete DLL resources to the frozen generic insertion API, and restore the OS invariant before unlock.

First symexec failed at Given locked: VRTOS lock postcondition binds st_lock. Corrected the body-only witness name to st_lock everywhere; contracts remain unchanged.

Second symexec failed at generic DLL call: QCP requires explicit type arguments (A_713). The fixed user-selected VRTOS polymorphic interface requires the minimal call-site type instantiation `where (dispatch_case); A = SemaphoreAbs`, matching VRTOS ktask_set_delay.c. This is necessary to use the frozen polymorphic contract and does not specialize/change the declaration or its semantics; other call witnesses remain inferred.

With the type supplied, QCP could not infer the higher-order storeA payload or anchor witnesses. Supplied the actual store_semaphore, prior list, created object, and sentinel in the same generic call instantiation; no interface changes. These exactly match the resources already exposed in the preceding cut.

Validation: formal-case-lib-design passed (exit 0, 575.429757s); canonical symexec passed (exit 0, 0.402s) and atomically published all four generated files; formal-case-lib passed (exit 0, 33.331509s). No manual VC was edited. Top-level entry by-local witness should retain the whole typed-local route; byte-layout witness includes malloc bounds/alignment and byte resources, and can use the already compiled bridge plus the existing approved field-offset premise.

Terminal delivery: completed; owner has stopped writing pending main finalize-delivery.
