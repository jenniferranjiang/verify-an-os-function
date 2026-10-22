# KSemaphoreCreate annotation r1

Signature: `int32 KSemaphoreCreate(uint16 val)`.

Preconditions: the frozen contract supplies `safeExec(LastSeen(before), abs_semaphore_create(sg, val), X)` and `OutsideCritical(sg, before)`; the C parameter has type `uint16`.

Output: return -5 or an ID in [0,128), with an after-state satisfying the corresponding safeExec return and OutsideCritical resource. This is the unchanged abstract creation contract already supplied by KSemaphoreCreateTrial.KSemaphoreCreate and the C Ensure. The imported callee contract has exactly the same relation.

The wrapper has no loop and needs no additional body assertions, predicates, bridge assumptions, or case-library lemmas. Preserve both frozen contracts and the executable body. Reuse the existing minimal case-library seed. New symbolic output, rather than previous-trial witnesses, is authoritative.

Validation: formal-case-lib-design, symexec, and formal-case-lib all returned exit code 0 and JSON status passed. Symbolic execution freshly generated two return witnesses, one partial-solve pure witness, and its whole partial-solve witness. They remain obligations for the following checking/proving roles; this annotation owner did not edit or prove generated witnesses. No source edits were required.
