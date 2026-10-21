# InsertObj annotation attempt 1

Signature: `void InsertObj(struct IdManager *manager, struct IdNode *idnode)`.
Preconditions: the frozen contract supplies nonzero pointers, an allocated-unlinked manager state for `id`, and exact detached ID-node ownership.
Output: full manager ownership at `idmanager_link(sm, idmanager_add(before, id), id, idnode)`; the selected ID and existing manager contents retain their reviewed mathematical meaning.
Rocq relation and C Ensure are the unchanged accepted `store_idmanager` applied to that state. No new definitions, predicates, formal case library, or contract changes were made.

Three necessary Assert points expose the opaque OSHeap resources: before reading manager/node fields, before inspecting the selected bucket head, and before calling DoubleLinkListInsertNodeAfter. They retain manager fields, updated bitmap ownership, all untouched buckets, the selected bucket contents, the ID field, and detached link cells. The selected bucket uses the existing BSS/initialized disjunction and existing `DLL.dllseg_shift_rev` to expose the successor's previous field. Original link values become undef only where the subsequent insertion overwrites both cells. Existing call-where annotations were removed; calls infer their arguments from the exposed resources.

Both reachable bucket shapes are retained. Both null-parameter infinite loops remain in C and receive false invariants justified by the unchanged nonnull preconditions. The lexical `do while (0)` wrappers remain unchanged: QCP treats them as single-execution blocks and reports “Expected loop after loop invariant” if an Inv Assert precedes them, so they have no emitted invariant.

Diagnostics resolved in this attempt:
- Initial symbolic execution could not read `manager->htable` through opaque OSHeap; the three resource-expansion assertions repair that gap.
- Declaration parsing required type constructors to use `* => *` and types to be in a separate Extern Coq block from values.
- Inv Assert before each do-while(0) wrapper was rejected by the QCP parser; removing those unsupported annotations preserves its single-pass semantics. False invariants remain on the actual while(1) loops.

Checks: formal-case-lib-design reports passed/skipped under absent policy; canonical symexec reports passed with exit code 0 and publishes all four VC files. No manual proof or generated file was hand-edited. Generated proof placeholders remain for the subsequent proving phase; annotation completion does not assert proof completion. This is the first attempt and no failed VC comparisons were supplied, so vc_comparisons is empty.

Proof handoff: resource bridges are expressed by the accepted `OSHeap` transport; selected-bucket splitting/cases use `store_idbuckets_split` and `store_idbucket_cases`; initialized successor exposure uses `DLL.dllseg_to_dllseg_shift_rev`; final reconstruction uses the accepted DLL insertion/resource lemmas and `store_idbuckets_replace`. Scalar bounds are derived from the owned UShort fields and accepted manager predicates, not added to the frozen entry contract.
