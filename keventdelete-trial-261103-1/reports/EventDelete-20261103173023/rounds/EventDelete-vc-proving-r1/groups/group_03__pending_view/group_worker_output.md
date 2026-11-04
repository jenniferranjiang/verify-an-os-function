# pending_view delivery

The assigned pending-view witnesses are proved directly in their copied manual spans. The library seed is unchanged and no new helper is needed.

`which_implies_wit_1` obtains the live event from the deletion gap, chooses its actual pending sequence, uses `in_split` and `dllseg_split` to expose its payload, and places every remaining resource into a restore wand. Supplying the same pending DLL reconstructs the event payload and the complete original `os_inv` via `dllseg_concat`. All membership, lifecycle guard, gap, and pending-head facts are preserved.

`which_implies_wit_2` follows the assigned aggressive route: its pure reflexive guarantee goal closes during explicit LLM preprocessing, and its spatial split applies wand elimination.

No annotation or specification change is required.

Validation: the prescribed `coq-check --target-kind group-check --group pending_view` completed with exit code 0 and JSON status `passed` (48.556155 seconds). All four assigned lemma declarations are complete; the aggressive top-level needs only the spatial Goal_apply because preprocessing itself closes the reflexive pure branch. The full forbidden-lemma/tactic scan passed.
