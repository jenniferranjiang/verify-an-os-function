# Shared full task model

This library restores the full task/assign/delay model used by the mutex deletion
trial. It is separate from the task-free `lib/common` model; their global states
must not be mixed. Imports use `CRTOS_Verify.lib.*` through the root
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
