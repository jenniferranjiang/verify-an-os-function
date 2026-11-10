# Shared full task model

This library restores the full task/assign/delay model used by the mutex deletion
trial. Sources are organized by module (`task`, `assign`, `delay`, `tick`, and the
object modules); `common` holds the full global composition and shared support.
Earlier task-free duplicates have been consolidated into this restored model.
Imports use paths such as `CRTOS_Verify.lib.task.TaskState` through the root
`lib` mapping. QCP is imported from the configured shared installation at
`../qcp-binary-democases`, not from a private snapshot.

The sources originate from CRTOS commit
`8a16fffe3e029b56de598baa16f43865da85b92b`. Existing snapshot compatibility edits
were retained where applicable. CriticalCSL now uses the shared QCP functor
signature; byte-store proofs and status validity use its current interfaces.
No new axioms or admitted proofs were added.

The migration was not fully compiled, per user instruction. Historical trial
reviews/build claims refer to the earlier pinned dependency set and do not certify
this migrated configuration. Manifests now identify the migrated source inputs.

For duplicate sources, the existing module-directory version is retained, with
imports updated to the new layout. Global state/invariant composition and ABI
facts additionally restore the task fields needed by the task library. The
generic `os_atomic_cmd` and `CrtosCNotation` names remain available; restored task
callers also retain their established names. There is one source per basename.
