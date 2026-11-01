# id_focus r2 delivery

Completed all seven assigned proof spans, including the which_implies_wit_7 spatial split and aggressive dispatch. Reused the compatible r1 proof/helper closure after comparing current definitions; details are in proof_reuse.md. No annotation gap was found.

The core proof selects the real ID-manager node using marked-state pending membership and task_wf_id_nodes, obtains query/bucket facts from the ID invariant and the 16-bit bound from UShort ownership, and borrows only id.id with a wand restoring the same marked-state os_inv. The eight helpers retain suffix __id_focus. Statements, seed declarations, and unassigned spans remain unchanged.

Validation:

- Rocq MCP rocq_compile returned success: true for the complete reused helper library and all seven assigned proofs against exact current goal definitions. No interactive pet calls were used.
- Forbidden lemma/tactic scan before controller checking returned no hits.
- The exact controller group-check exited 0 with JSON status passed and returncode 0. It rebuilt the five current target files, reused 201 base vo files, and took 105.502801 seconds. Target: VC/LinklistResumeAll_group_03_id_focus_check.v. Build workspace: verification_runs/LinklistResumeAll-20261030234941/_coq_builds/LinklistResumeAll-vc-proving-r2/group_03/src.

All writes are stopped for terminal delivery and main finalization.
