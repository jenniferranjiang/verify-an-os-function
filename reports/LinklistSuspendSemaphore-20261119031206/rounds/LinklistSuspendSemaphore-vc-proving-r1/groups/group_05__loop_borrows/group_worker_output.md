# loop_borrows completed

All four assigned top-level lemmas and the assigned spatial split close with Qed. The exact group-check completed with exit code 0 and JSON status passed; group-development also passed.

- entail_wit_5 borrows the current waiting node next pointer and both real task cur_prio fields, derives target/current distinctness from scheduler ownership, and composes the return wands to recover the unchanged staged os_inv. Both end-of-list and nonempty-successor cases are proved.
- which_implies_wit_3 borrows and restores the sentinel next field, using the actual empty/nonempty waiting list shape.
- which_implies_wit_5 borrows and restores the sentinel previous field and proves that insertion at the last anchor equals append, using list uniqueness obtained from owned DLL resources.
- which_implies_wit_6 and its spatial split discharge the resource-return wand.

Only assigned proof bodies in the copied manual were changed. Local assertions are proved within those bodies. No new library, import, assumption, axiom, admitted proof, or contract change was introduced. Existing unassigned proof tokens remain untouched. Debug Show commands have been removed. Checked .vo artifacts are retained by the controller build workspaces. Main remains responsible for group finalization and function final-check.
