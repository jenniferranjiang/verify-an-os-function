# _SemaphoreCreate annotation delivery

Signature: `_SemaphoreCreate(uint16 val) -> int32`.

Preconditions: the frozen contract provides `OutsideCritical(sg,before)` and `safeExec(LastSeen(before),abs_semaphore_create(sg,val),X)`.

Output: return -5 or an ID in [0,128), with an outside-critical state and the corresponding `safeExec` return continuation. The frozen `abs_semaphore_create` already expresses allocation failure or an atomic minimum-free-ID allocation and publication of the initialized semaphore. Its pure semantics and all helper contracts remain unchanged.

No new predicates are required. Existing shared semantic interfaces are reused; helpers are not re-proved. The canonical case library remains its import seed. The final do-while(0) is a disabled debugging macro with a statically false guard and has no iterative mathematical progress.

Existing body annotations (`by local`, `where`, and `Given`) predate this attempt; no such syntax is added. Their compatibility will be tested through the supplied canonical symexec command.

First canonical check: formal-case-lib-design passed (exit 0, status passed).

First symexec: parser failure `No such projection idmax` at annotated_C/src/_SemaphoreCreate.c:32:40. The closest annotation is the frozen IdInsertObj success Ensure containing `__return < sidm.idmax`. No symbolic execution state exists yet because declaration parsing fails. Classification: contract syntax / Coq projection registration mismatch. `logic.h` declares `idmax` as an ordinary unary Extern Coq function; functional application `idmax(sidm)` would preserve semantics. Shared record-projection notation also appears in body `where` expressions. Main has been notified because normalizing text inside the frozen helper contract requires coordinating its freeze identity; no frozen text changed.

Main authorized and audited a parser metadata repair in `logic.h`: register the existing StableIdmanager record with its exact fields instead of its opaque type and unary idmax declaration. Main recorded the manifest update in `checks/parser-record-registration.json`. Body-only projection spellings were normalized to their already-declared unary functions. Frozen contracts remained byte-identical.

Second symexec: parsing advanced past IdInsertObj, then rejected the variadic KPrintf declaration at line 64 (`Syntax error: unexpected token '.'`). This is unsupported C debug-interface syntax, before any body execution. TrustBase permits removal of KPrintf declarations and uses; main has been notified to coordinate that preprocessing repair without silently changing frozen contracts.

Main explicitly authorized trusted debug removal after saving/unfreezing the original contract surface. Removed only the unsupported KPrintf declaration/spec and the disabled if(0) logging macro. All remaining function contracts are unchanged; no lexical loop remains.

Third symexec: body execution reached IdInsertObj, whose Require needs `store_idmanager` and `ZeroIdNode` while caller retains opaque `os_inv` and `SemaphoreZero`. Added four ordinary resource cuts: expose manager/private fields before IdInsertObj; refold failure resources before x_free; expose pending-node storage and the existing DLL insertion cut before list helpers; restore the complete published-state invariant before unlock. The untouched DLL tail uses existing `dllseg_shift_rev`; no new predicate is defined. These assertions generate proof obligations rather than assumptions.

Fourth symexec: type registration mismatch, `Cannot unify types SemaphoreState and (list A)` when exposing freshness/list content. Actual Rocq `SemaphoreState` is `list SemaphoreAbs`, but QCP metadata declares it opaque. Main notified to register its exact existing alias before the next run.

Final annotation state: the actual SemaphoreState alias is now registered in QCP metadata (main receipt `checks/parser-semaphore-state-alias.json`), and the four resource cuts pass symbolic execution. Local lock storage is retained with an existential logical value binding, not an unprovable numeric assumption. There are no loops and no new predicates. Only current-trial helper contracts are used; helpers are not re-proved.

Validation: formal-case-lib-design passed; final canonical symexec passed with all four generated files present and publication committed; final formal-case-lib check passed (exit 0 and JSON status passed). The case library remains unchanged. No generated file was edited by this owner.

Proof-stage caution: QCP emits optional split helpers for the initial pre-existing `by local` type-range annotation. `_SemaphoreCreate_entail_wit_1` is a disjunction whose full-local-store branch can derive the uint16 bounds, while its optional pure-only split alternatives cannot be proved independently. Main has been notified to honor the original witness/VC_Correct interface when grouping proof obligations. The four ordinary cuts preserve spatial resources needed for their pure consequences (including fresh-object separation).
