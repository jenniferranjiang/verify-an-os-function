# id_focus delivery

Completed all seven assigned proof spans, including the which_implies_wit_7 spatial split and its aggressive dispatch. No annotation gap was found.

The ID focus proof derives marked-state pending membership from the semaphore-preserving task-map update, obtains task-list membership from os_world_wf and task_world_wf, and selects the actual ID node via task_wf_id_nodes. The ID bucket invariant supplies lookup bounds, bitmap query, and bucket membership. UShort ownership supplies the 16-bit bound. Only the id.id field is borrowed; its wand restores the same marked-state os_inv, including all ID links and buckets.

Eight fully proved helpers were appended to the group library with suffix __id_focus. The original seed, statements, declaration order, and unassigned proof spans were preserved. No historical proof reuse was needed.

Validation:

- Rocq MCP rocq_compile returned success: true for the six simple assigned proofs, the complete core which_implies_wit_6 candidate with exact copied goal definitions, and the final qualified group-library source. Interactive pet was not used.
- Forbidden lemma/tactic scan returned no hits.
- Exact controller group-check exited 0 with JSON status passed and returncode 0. Target: VC/LinklistResumeAll_group_03_id_focus_check.v. Build workspace: verification_runs/LinklistResumeAll-20261030234941/_coq_builds/LinklistResumeAll-vc-proving-r1/group_03/src. Elapsed: 178.93178 seconds; five current target files recompiled and 201 base vo files reused.

Stopped all proof/library writes before terminal delivery; main may finalize this group.
