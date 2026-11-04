# _MutexDelete annotation attempt 1 — completed

Signature: void _MutexDelete(struct Mutex *mutex). Preconditions and output remain the reviewed assumed_environment contract: under A1/A2, drain waiters, retire the same object, free its complete private allocation and return OutsideCritical with the same continuation. No new lifetime or business assumptions.

The only changed function-contract tokens are the user-approved IdRemoveObj normalization in `.docs/Report/proposed-idnode-spec-normalization.patch`. Both high_level_spec and low_level_spec in this caller and the reused canonical `annotated_C/src/IdRemoveObj.c` now use explicit IdNode field_addr/store resources. Their complete normalized spec text is equal. Other contracts and all shared predicate semantics remain unchanged; root shared specs and authoritative C were not edited.

Body annotations expose the bind continuation, the freshly acquired drained Mutex, ID field borrowing/restore, ID-manager and management-DLL resources, then the updated os_inv and complete private MutexRetired crossing Unlock before x_free. The case lib defines only the necessary continuation, spatial ID restore wand and exact manager frame, directly reusing the reviewed shared definitions. It contains no new proof assumption or placeholder lemma. The NULL dead loop retains its original path with a corresponding invariant.

Main authorized one equivalent C slice normalization: read `mutex->id.id` once into a local `uint16 delete_mutex_id` immediately before the same IdRemoveObj call, with only ghost annotations in between, inside the same critical section. Lock positions, C paths, effects and call order are unchanged. The immutable `mutex@pre` value is used in partial entailment annotations so selecting a resource subcontext does not consume the still-live C parameter's local store.

Parser diagnoses were resolved in this same attempt: the approved IdNode field normalization resolved RecordIdNode/Z ambiguity; separating the last polymorphic DoubleLinkListRmNode spec into a second identical-signature declaration resolved duplicate With {A} scope without changing any spec-block tokens or removing a named contract; explicit Extern declarations supplied first-class mutex_addr/mutex_id projections. No dummy struct/global or replacement contract was introduced.

Required controller development checks all passed:

- formal-case-lib-design: passed, exit 0, 7.688081 seconds, 199 base dependencies reused.
- symexec: passed, exit 0, 0.975 seconds; four generated formal files committed by controller. Its auto-obligation routing promoted 28 unresolved auto templates with statements preserved.
- formal-case-lib: passed, exit 0, 8.077835 seconds.

The generated VC structure was inspected for the two IdRemoveObj branches and the final resource handoff. The query-miss branch retains the contradiction with the original known-present ID; the hit branch retains returned ID-node membership, old address/ID NoDup, the fresh current object, exact manager/DLL resources, shared frame and retirement continuation. These are pending proof obligations, not claims of implementation correctness. No generated file or manual VC was hand-edited and no manual proof was attempted. Handoff failed_vcs was empty, so vc_comparisons remains empty.

Terminal report is completed; all writing has stopped for main's finalize-delivery.
