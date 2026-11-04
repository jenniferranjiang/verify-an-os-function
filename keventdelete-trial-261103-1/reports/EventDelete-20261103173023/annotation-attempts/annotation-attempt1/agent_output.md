# _EventDelete annotation attempt 1

All three controller development checks passed: formal-case-lib-design, symexec, formal-case-lib. The final _EventDelete public spec is byte-identical to the reviewed r1 annotation. Existing shared headers and global libraries were not modified; all local definitions are in VC/EventDelete_lib.v, and its seed import block remains intact.

## Annotation changes

Pending DLL and Event ID scalar are temporarily borrowed via two explicit spatial wands and then returned before calling functions requiring the complete resource. The initial pending inspection uses the actual checked-state sequence; its result chooses a ResumeAll continuation or direct final unpublish operation. The conditional branch join retains the chosen resched and the correct residual safeExec. Final manager/DLL removal reassembles os_inv for the new event sequence and the complete EventRetired allocation before unlocking and freeing. The ID and address uniqueness plus manager/unpublish equality are generated which-implies obligations derived from the original os_inv, not new public premises or assumed lemmas.

Two pure helpers name the real residual unpublish/schedule operation and its weakest-precondition continuation. No unproved obligation was imported as a proof fact. The null-parameter nonreturning loop retains its resources and condition instead of asserting a literal false postcondition that the symbolic simplifier could not establish from an opaque guard.

## Source-preserving normalization

The ID argument expression is read once into a fresh uint16 delete_event_id local, then its borrowed storage is returned before IdRemoveObj consumes the complete manager. This preserves the value, read count, sequencing, lock interval, and all executable effects. The added else branch contains only annotations. No original lock was moved or merged; the already reviewed standalone IsEmpty inspection lock remains in place.

## Imported IdRemoveObj syntax adaptation

Initial symexec failed before the active body because the logical addr binder in `(idnode->id == 65535)` was resolved to the embedded Event/Task `id : IdNode` field. Main authorized representation-only repair under existing reuse rules; no unfreeze was used and the _EventDelete target contract stayed unchanged.

Both high_level_spec and low_level_spec retain their With binders, branches, return values, manager effects and footprint. Their implicit scalar/link ownership assertions now use explicit store(field_addr(..., struct IdNode,...), ...) forms. Pure address tests likewise name struct IdNode.link. Actual generated EventDelete_goal.v confirms precisely:

- IdNode.id UShort stores 65535;
- IdNode.link.node_prev and node_next Ptr stores both point to IdNode.link;
- no additional storage or logical guarantee was introduced.

No imported named spec was removed, and no reused function body was submitted for verification. Main will independently review the equivalent spelling and synchronize the trial canonical boundary after this owner stops writing.

## Iteration evidence

The first parser failure was the imported IdNode field ambiguity. After the typed form, subsequent ordinary annotation repairs handled the null-loop state, explicit pending-head address equality, branch-specific rather than disjunctive which-implies commands, and function-style os_events projection. The final symexec succeeded and published its own generated files. No manual, goal, auto or goal-check file was hand-edited.

Generated manual file has 110 lemma entries, of which 86 are non-split top-level obligations. They remain unproved here and await independent VC checking/group proving. The owner has not claimed C correctness from successful symbolic execution.
