# InsertObj annotation attempt 2: completed after accepted design repair

## Current delivery

Main refreshed this same attempt's handoff after independent predicate and spec review. The current accepted revisions are source-r2-0c50c37013e9, predicate-nonzero-candidate-fe8c4261db5c (manifest fe8c4261db5cff754395f3d9038769b3e50420d542347262a831aa3ce6a422b3), and spec-r5-480669e8557a (manifest 480669e8557a5f09a7683b69c5de2b087857f93649ef9c6729096df1c6a8b3cf). The review and source-boundary reasoning is recorded in .docs/Report/2026-10-12-6-predicate-review.md, 2026-10-12-4-spec-review.md, and design-changes/2026-10-12-3-object-address-validity.md. Those shared inputs remained read-only during this annotation repair.

The only C annotation edits in this resumed delivery add `&(idnode->link) != 0` to the first ordinary Assert and preserve it in the second ordinary Assert. The third Assert already required it. No canonical or caller-local With/Require/Ensure, executable C token, branch, loop, predicate definition, or manual proof was edited. No new case library or predicate was introduced.

Signature, preconditions, and output remain the frozen void InsertObj(manager, idnode) contract: owned allocated-unlinked manager and detached node become the complete manager at `idmanager_link(sm, idmanager_add(before, id), id, idnode)`. The loop treatment and all three resource views remain as in attempt 1. Pure address metadata now comes from the accepted object representations; it is not inferred from isvalidptr or a new layout equality.

## Current failed-VC comparisons

Historical worker manuals named by the handoff and current VC/InsertObj_proof_manual.v were read directly; current VC/InsertObj_goal.v was inspected for the actual propositions, resources, and witnesses.

1. `proof_of_InsertObj_entail_wit_2` retains the selected bucket existential, both BSS and initialized conclusions, exact zero cells or initialized link segment, all manager fields, updated bitmap, detached ID cells, and untouched-bucket frame. Its accepted `store_idbuckets` premise now contains the revised BSS representation. `store_idbuckets_split` selects the bucket and the independently compiled `store_idbucket_cases` returns head nonzero in BOTH alternatives. Thus the previously absent BSS-head premise has an accepted semantic source. No target nonzero condition was deleted. The new node-link fact is also preserved through this witness.

2. `proof_of_InsertObj_entail_wit_3_1` retains the initialized-empty bucket state and the same bucket/successor witnesses (bucket_2 and head). The original missing embedded-link nonzero conclusion is now explicitly present as PreH6 in BOTH whole-goal alternatives. The first Assert obtains it from revised `store_sem_id_detached`; the second Assert frames it through initialization. The remaining pure condition is empty-bucket idnodes_nonzero, with the same reverse-empty-segment spatial reconstruction. The generated redundant pure split for link nonzero disappeared because the fact is retained, not because the whole-goal obligation was removed.

3. `proof_of_InsertObj_entail_wit_3_2` retains the initialized bucket's hp/hn facts, exact fields and segment, untouched-bucket frame, and the same witnesses (bucket_2 and hn). The embedded-link nonzero fact is now explicit PreH7 in BOTH whole-goal alternatives. Existing DLL segment conversion is still required for the same spatial conclusion. Its former link-nonzero split is discharged by the retained premise, while the complete original responsibility remains in the whole goal.

The upstream propagation obligation `proof_of_InsertObj_entail_wit_1` still exists: its premise is the accepted detached representation, whose pure conjunct directly supplies the newly exposed link fact through OSHeap. This does not merely move an unsupported assertion upstream. All three comparison results are `resolved` in the annotation sense of repairing their reported missing facts; full proofs remain assigned to the subsequent proving phase.

## Current checks and stopping point

The exact handoff r2 `coq-check --target-kind formal-case-lib-design` command exited 0 with status passed/skipped (absent case-lib policy). The subsequent exact r2 `symexec` command exited 0 with status passed and publication committed for all four VC files. Generated files changed only through that command. No post-symexec case-lib check applies under absent policy. All comparison names remain present; the plan is ready. Generated manual/auto placeholders are not claimed as verified proofs.

The terminal report is written last as `{"status":"completed"}`. After it is written this owner stops all writes and returns control to main for finalize-delivery.

## Historical diagnosis before the accepted revision

The remainder preserves the earlier frozen-input delivery within this same attempt. Its unresolved/no-terminal statements describe that earlier checkpoint and are superseded by the current delivery above.

The three supplied failed VCs remain unresolved. No C source, annotation, generated VC, proof, accepted predicate, or function contract was changed in this attempt. Only this note and annotation_plan.json are delivered. The plan remains `planning`; no terminal report is written. This follows the annotation-designing workflow's frozen-spec exception: document the required design revision and return it to main, rather than reporting an annotation gap as an infrastructure blocker or claiming completion.

The accepted inputs remain source-r2-0c50c37013e9, predicate-r5-0a139d64743c, and spec-r4-9f3ebc915b99. Main may route a revision within the already authorized semantics through independent design review and manifest rebinding under the user's one-time authorization.

## Evidence and comparison

Read both handoff-listed group reports and notes, both historical worker manual files, and the current generated goal definitions and C assertions. The current goals retain the reported conclusions, pure premises, spatial resources, and existential witnesses. No files were regenerated: unchanged symbolic execution would reproduce the same unsupported implications.

- `shared-candidate/arm32le/idnode.v:473`: `store_uninit_idbucket head` owns the two zero-valued pointer cells but has no head-nonzero clause. The empty-bucket alternative of `store_idbucket` permits this representation. Neither `store_idbuckets` nor `store_idmanager_allocated_unlinked` adds the missing bucket-address fact.
- `lib/SemaphoreRep.v:21`: `store_sem_id_detached p id prev next` owns the id and two link cells, with no pure nonzero embedded-link fact.
- Official QCP `Rocq/SeparationLogic/CommonAssertion.v:313`: `isvalidptr` permits address zero. `ConAssertion.v:416` imposes no additional null exclusion on mstore. Field ownership therefore does not imply that the containing object or embedded link is nonzero.
- Official QCP `CNotation.v:51` leaves `eval_addr_expr` abstract. Its field/array congruence and rewriting rules do not establish IdNode.link = p + 4. The global-variable-address nonzero axiom at line 582 cannot directly help this generic InsertObj contract: its sm has no equality connecting htable to the semaphore global, and the axiom alone does not prove nonzero for every array element.

`proof_of_InsertObj_entail_wit_2`: selected-bucket splitting supplies head nonzero for the initialized alternative, but not for the BSS alternative. The pure configuration idmax=1, hoffset=1, htable=0, id=0, idlist=[], idbuckets=[[]] satisfies the listed ID facts and computes head=0. The memory representation does not exclude zero-address cells. This is a semantic missing-premise diagnosis, not a newly machine-certified full countermodel.

`proof_of_InsertObj_entail_wit_3_1`: initialization makes the empty bucket a self-loop, but does not establish the new idnode's embedded-link address nonzero. The whole-goal premises include idnode nonzero and its field resources; the conclusion additionally requires the separate abstract link address nonzero. Empty reverse-segment reconstruction addresses only the spatial part.

`proof_of_InsertObj_entail_wit_3_2`: the initialized bucket provides nonzero head, predecessor and successor, but no new-node link-nonzero fact. The existing dllseg-to-reverse-segment lemma addresses only the spatial part.

Removing these Assert facts only moves the failures to the frozen InitDoubleLinkList and DoubleLinkListInsertNodeAfter preconditions. Removing those API preconditions would still leave the accepted final store_dll's explicit nonzero head/node requirements. Adding a fresh Require to InsertObj would narrow its domain without establishing the premise from callers. None is an annotation-only repair.

## Concrete C/ABI facts versus missing formal facts

Current `evidence/source-abi.c` and `source-check-result.json` record successful Cortex-M3 target compilation establishing IdNode.link offset 4, DoubleLinklistType size/stride 8, and Semaphore offsets id=0, pend_list=16, link=24. These are concrete C/ABI facts, not existing Rocq equalities for eval_addr_expr.

The authoritative source root is `/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro`. Relevant inspected sources are:

- `kernel/include/xs_id.h`: IdNode embeds a link and DECLARE_ID_MANAGER allocates an actual array of bucket heads.
- `kernel/include/xs_sem.h`: Semaphore embeds its id, pending-list head, and registry link.
- `kernel/thread/semaphore.c`: the fixed semaphore manager is declared through that macro; creation checks malloc success, zeroes the object, passes &sem->id to IdInsertObj, then initializes/inserts its other embedded links.
- `kernel/thread/id.c:62-72`: InsertObj selects a real bucket array element and inserts &idnode->link.
- `kernel/thread/double_link.c`: initialization and insertion perform the original pointer writes.

No C defect is claimed. The gap concerns how these real object-address facts are expressed and propagated in the reviewed abstract representation.

## Candidate minimal design repair, subject to independent review

1. Add `head <> 0` to this trial's `store_uninit_idbucket head`, retaining both exact zero-valued pointer cells. Carry it through the BSS branch of `store_idbucket_cases`. This aligns the BSS alternative's address domain with the initialized store_dll alternative, which already requires head nonzero. Review the static initializer and all manager constructors so the new fact has an origin; do not merely move the unsupported assertion there.

2. Add the embedded-link nonzero fact to this trial's `store_sem_id_detached p id prev next`, retaining the same three cells and original contents. Consider carrying `p <> 0` in that representation too: it is already explicit at InsertObj/IdInsertObj entry and is needed by the caller using &sem->id. Preserve these facts through ID allocation, ID-field update, ID-failure ownership return, and the intermediate InsertObj assertions.

3. Review how private-object construction establishes these facts. `store_sem_zeroed_private` composes detached ID, pending-list and registry-link resources; its use in the trusted memset contract means a representation change alters that contract's meaning even if its text is unchanged. Review it and x_free against the already authorized complete 32-byte zero-object semantics. There must be no new assumption, altered ownership transfer, excluded failure path, or weaker postcondition. Inspect the analogous pending-list and registry-link address obligations in _SemaphoreCreate during the same impact audit.

No new bare Require on the generic InsertObj or link primitive contracts is proposed. Their reviewed behavior and ownership should remain; representation repair still requires review of every affected contract's semantic meaning. The minimal dependency chain includes bucket representations and manager representations, detached/private object representations, AllocId, InsertObj, IdInsertObj, _SemaphoreCreate, KSemaphoreCreate, static initialization, and the memset/x_free trusted-origin contracts. Caller-local declarations must remain equivalent to their canonical contracts.

A broader alternative is a justified concrete formal layout implementation linking symbolic field addresses to checked offsets, together with object-base bounds. It must be definitional or proved from accepted semantics. A new Parameter, Axiom, Admitted, or an equality assumed solely to discharge these VCs is not an acceptable bridge. This exceeds the current annotation owner boundary and absent case-lib policy.

## Resume boundary

Main must return the candidates to the appropriate design author and independent reviewer, compile the affected formal dependency closure, record updated predicate/spec manifests, and deliver the accepted revision to this same annotation owner. Then propagate the newly justified facts through the first/second assertions, retain the final required address facts, run the exact r2 formal-case-lib-design and symexec commands, and compare all three regenerated obligations against these originals. Only resolved comparisons permit ready/completed.

All three comparisons currently remain `unresolved`. No check is claimed for a repaired revision. The prior failed attempt to write these notes had a Python syntax error before execution and changed no files; this delivery uses apply_patch.
