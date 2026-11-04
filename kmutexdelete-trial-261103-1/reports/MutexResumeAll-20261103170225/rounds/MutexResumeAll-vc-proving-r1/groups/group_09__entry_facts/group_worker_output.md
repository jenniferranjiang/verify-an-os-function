Completed all three assigned top-level witnesses with LLM_pre_process and Qed.

- entail_wit_1 preserves the four entry facts, weakens initialized node/task/lock cells to undef, and cancels OutsideCritical.
- entail_wit_2 closes directly under LLM_pre_process.
- which_implies_wit_1 selects the full spatial branch, extracts the existing mutex_delete_live witness, constructs mutex_pending_nodes with reflexive map equality, and preserves os_inv.

No helpers or library changes were required. Interactive Rocq MCP checks used the controller-generated group_09/dev workspace and its formal load mappings. Forbidden lemma scan passed. The final group-check exited 0 with JSON status passed (28.73342 seconds).
