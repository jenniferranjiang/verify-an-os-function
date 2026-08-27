# KSemaphoreCreate annotated C layout

`src/` is intentionally flat and function-oriented.

- Every direct callee of `_SemaphoreCreate` has one `.c` file.
- Each file contains its canonical contract followed by its active C body.
- Helpers called by that body are declared as implementation APIs before the
  verified function instead of being expanded into the same file.
- `semaphore_create_internal.c` and `ksemaphore_create.c` are the two selected
  symbolic/VC targets.  The eight callee-body slices remain
  `implementation-proof-pending` at the current design gate.

No direct-callee body is hidden behind `#if 0`.
