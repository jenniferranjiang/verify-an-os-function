# pending_head_access delivery

Completed both assigned top-level witnesses using `LLM_pre_process ltac:(lia || int_auto)`.

- `proof_of_LinklistResumeAll_which_implies_wit_1` obtains the published Event from `event_delete_gap` and constructs `event_pending_at` using its exact pending list. The existing `os_inv` is preserved.
- `proof_of_LinklistResumeAll_which_implies_wit_2` uses `pending_head_borrow__pending_head_access`, choosing the empty/nonempty disjunct from the actual pending list. Nonempty head distinctness follows from `dup_store_ptr`; the restoration wand rebuilds the same waiting DLL, Event payload, outer Event DLL, manager, and OS frames.

Four fully proved helpers were appended to the provided group library, all with suffix `__pending_head_access`. The seed and unassigned proof tokens remain unchanged. No historical proof was required.

Validation: forbidden lemma/tactic scan had no matches. The exact supplied controller `coq-check --target-kind group-check --group pending_head_access` exited 0 with JSON `status: passed` (52.638238 seconds), compiling the current group library, manual and group wrapper. An earlier `coq-debug` attempt reported its optional debug script absent; interactive exploration used Rocq MCP and the final controller group-check passed.

No blocker. All writes stop with the terminal report.
