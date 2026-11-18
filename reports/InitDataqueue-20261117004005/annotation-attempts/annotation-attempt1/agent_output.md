# InitDataqueue annotation delivery

The approved top-level With/Require/Ensure and all callee contracts remain unchanged. No new predicate, axiom or admitted lemma was introduced. The do-while(0) is a single-execution control wrapper, with early breaks; no iterative invariant was added.

Added DataqueueStorage-to-bytes and memset-bytes-to-fields `which implies` views, producing real proof obligations. Added success publication and common failure cleanup assertions. The failure assertion introduces an existential unit continuation Y with a universal bridge to the existing Z continuation X; it does not assume any obligation proposition. These assertions consume actual owned queue fields and buffers, and the generated VCs must prove publication, cleanup eligibility, frame and continuation relationships. Saved lock and entry parameter bindings are explicitly preserved across assertion cuts.

Main authorized splitting the chained assignment into rear=0 then front=0 (same C evaluation order), with original expression preserved in a comment. No other executable statement changed.

## Shared header syntax adaptation

Main extended the owner boundary for syntax-only splitting of mixed kind/term Extern Coq blocks in the two canonical headers. Each block retained every declaration in its original order; only `*/` and `/*@ Extern Coq` delimiters were inserted between last kind and first term. Thus the concatenated Extern Coq declaration token sequence is unchanged. Affected callers: InitDataqueue, DeInitDataqueue, DataqueuePeak and the four Semaphore create/delete IC interfaces via the shared headers.

| Header | Before SHA-256 | After SHA-256 |
| --- | --- | --- |
| dataqueue.h | b02826b6f105c8ed84d6f744eb932d05589c88827c4a9fa322309426dd2a42bb | 86456b032fb6eeb59d037a2c76539256d039c5acc906a3902809f1e30b213a3b |
| dataqueue_semaphore_logic.h | d818c76d9e392a75d55065ff17b465f269a6d5deb84e9e8196f6eccbc26089fc | 52ca5f4c0fb0dbae190be28a9f40b4fc294bd6e2a6e8c9d44658dedd0f44702f |

## Checks

`formal-case-lib-design` passed/skipped because policy is absent; no duplicate case lib was created. Controller symexec passed, generated and committed the four files in VC/dataqueue. This is VC generation, not implementation proof. Earlier failed runs advanced parser/storage/call obligations and produced no published VC. Manual proof files were not edited by this owner. The auto routing preserved generated statements and promoted unsupported auto obligations to manual proof responsibilities.
