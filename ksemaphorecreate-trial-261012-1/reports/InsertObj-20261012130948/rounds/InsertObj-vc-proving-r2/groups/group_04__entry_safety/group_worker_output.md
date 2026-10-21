Completed the six assigned entry safety witnesses using `LLM_pre_process ltac:(lia || int_auto)`. The four constant-bound goals and two inconsistent null-pointer branches close without predicate unfolding or helper additions.

Reused the corresponding six proof bodies from this run's `InsertObj-vc-proving-r1/groups/group_03__entry_safety/InsertObj_proof_manual.v`; checked them against current inputs. Only assigned proof spans were changed. Forbidden lemma/tactic scan passed.

The supplied controller `coq-check --target-kind group-check --group entry_safety` exited with code 0 and JSON status `passed`; the current goal, automatic proof, copied manual, and group wrapper were recompiled.
