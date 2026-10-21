# Registry preparation delivery

All six assigned witnesses are complete in the copied manual; no new declaration, import, helper library, predicate, annotation, or transition was introduced.

- `entail_wit_3`: the whole-goal LLM route selects the first disjunct. The registered private object is expanded, metadata retained, and the four known-zero pointer cells weakened to undef. A proof-local pointer bridge follows the current trial `VC/InsertObj_proof_manual.v`; typed address congruences normalize the embedded slots. All manager, registry, scheduler, task, IRQ, and padding frames are preserved.
- `entail_wit_4`: the first disjunct is proved because `LLM_pre_process` selects that original whole-goal branch. It has the same registry transformation as the planned second disjunct, with the extra value, pending, and undefined-link resources explicitly framed. Successor and tail are obtained from the actual registry representation. StableContext supplies the global head address; the established DLL segment lemma exposes successor.prev and the shifted reverse segment. The exact mapped object nodes retain the nonzero metadata and satisfy the data and pointer projections.
- `partial_solve_wit_7_pure`, `partial_solve_wit_8_pure`, and both auxiliary wrappers close with explicit LLM preprocessing; wrappers explicitly unfold their auxiliary definitions before the second preprocessing step.

Validation of the final unchanged proof source:

- Forbidden lemma/tactic scan: no hits; no Show diagnostics remain.
- Group development: actual exit 0, JSON status passed, elapsed 145.483472 seconds.
- Group check: actual exit 0, JSON status passed, elapsed 147.99708 seconds.

Iteration record: an early development invocation was interrupted with Ctrl-C and returned actual exit 130 after the controller reported that manual compilation had run for 30 seconds. At that point the proof contained whole-goal csimpl and repeated pointer sep_apply; this was a suspected broad-tactic cost, not evidence that compilation was hung. Subsequent versions use four explicit address congruences and four explicit pointer weakenings. Other completed failed iterations reported ordinary proof syntax, unfolding, matching, and cancellation errors, all corrected before the final successful checks.

One later development session (78575) became unavailable across task restoration: write_stdin returned `Unknown process id 78575`, while tool_calls.jsonl had the corresponding started record without a finished record (call_id `9f78d605adc848dc9041d6dbf592c71e`). Its result is unconfirmed and no exit code is inferred. The authorized command was rerun, and only the new completed checks above are used for acceptance.

No historical CRTOS trial or current sibling output was used. All writing stops with this delivery; main may now finalize it.
