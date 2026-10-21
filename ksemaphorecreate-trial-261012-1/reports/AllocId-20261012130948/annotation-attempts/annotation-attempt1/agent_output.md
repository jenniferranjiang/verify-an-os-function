# AllocId annotation attempt 1

Signature: `int AllocId(struct IdManager *manager)`.
Preconditions: the frozen contract requires a nonzero manager and the complete accepted `store_idmanager(sm, before, manager)` ownership transported by OSHeap.
Output: return -1 exactly on the full-manager branch while preserving ownership; otherwise return the smallest free ID and transfer the bitmap to allocated-unlinked ownership while preserving all buckets. The accepted `idmanager_full`, `idmanager_min_free_id`, and `store_idmanager_allocated_unlinked` supply the unchanged Rocq and C contract meaning.

Only body annotations and required Extern Coq name declarations were added. Existing `allocid_index_scan_inv` and `allocid_entry_scan_inv` are reused without any new predicate definitions. One necessary Assert exposes manager fields, the full byte array, and the transported untouched bucket resource because symbolic execution cannot read fields through opaque OSHeap. All four lexical loops have Inv Assert. The do-while annotation uses the parser-required position before the trailing while, as in the official QCP sum.c example. Live local stores are retained through explicit initial values until their first assignments.

Diagnostics resolved in this attempt:
- Parser requires type declarations and value declarations in separate Extern Coq blocks; split the blocks.
- Parser requires do-while invariant at its trailing while; moved only the annotation.
- Complete assertions discard unnamed local stores; retained index/end/id/entry initial values through the parameter check and heap-opening Assert, and id/entry through the byte loop.

Checks: formal-case-lib-design passed (skipped because policy is absent); canonical symexec exited 0 with JSON status passed and committed all four generated files. Reviewed the generated manual and goal statements: byte and bit progression, array-read bindings, failed-full returns, and successful bitmap update are represented. No incoming failed VCs, so vc_comparisons is empty. Generated placeholders are unchanged controller outputs and remain obligations for proving; this report claims annotation delivery only. Frozen contracts, executable C, accepted shared inputs, and all proof files were not manually edited.
