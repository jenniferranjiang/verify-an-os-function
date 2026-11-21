# Loop progress proof delivery

Assigned whole-goal witnesses: entail_wit_4_1, entail_wit_4_2, entail_wit_6_1, entail_wit_6_2. Only these four copied manual proof spans were changed; prelude, statements, declaration order and every other proof remain unchanged. No helper, import, library, specification or assumption was added.

The two initialization cases consume the actual head.next cell with its restoration wand, choose an empty scanned prefix and the original waiting list as suffix, and prove the quantified prefix condition vacuously. They select the empty/nonempty branch from the actual list-shape premise.

The two iteration cases normalize the returned task identity, consume both priority fields and the current next field with their precise restoration wand, and restore the identical staged os_inv. The new prefix is old_prefix ++ [current_task], with the priority condition proved by membership splitting and the actual non-break guard. The remaining suffix and next pointer choose the respective successor branch. The empty successor case also restores the local list cell using its explicit next_link = list_pre bridge.

No sorted-list assumption is used. The first development diagnostic left only the empty-prefix quantified proposition, closed by explicit False elimination. Subsequent full group-development passed with all four assigned lemmas Qed. The authorized fixed debug script was used only to inspect that target.

Exact group-check result is recorded in the controller tool log; terminal report is written only after exit zero and status passed.

Final exact group-check: exit 0, JSON status passed, elapsed 39.196739 seconds. All four assigned whole-goal witnesses are Qed. No split witnesses were assigned to this group.
