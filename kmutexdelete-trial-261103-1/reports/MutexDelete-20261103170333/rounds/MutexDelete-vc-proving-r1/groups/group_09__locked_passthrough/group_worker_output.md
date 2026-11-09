Completed all five assigned top-level witnesses (partial_solve_wit_4 through partial_solve_wit_8) using LLM_pre_process.

Witnesses 4 and 5 reassert existing pure premises and preserve/cancel their critical-section resources. Witnesses 6 and 7 close directly under LLM_pre_process. Witness 8 obtains the ID bounds from mutex_delete_drained and the manager address fact from addr_of_LE_var_not_zero, then preserves all manager, frame and lock resources.

No helpers were added; the seed group library and all unassigned proof tokens remain unchanged. Forbidden lemma/tactic scans of the copied manual and group library returned no matches.

Controller group-check completed with process exit 0 and JSON status passed (50.922928 seconds). All assigned proofs were also checked interactively in the controller-provided group development workspace.
