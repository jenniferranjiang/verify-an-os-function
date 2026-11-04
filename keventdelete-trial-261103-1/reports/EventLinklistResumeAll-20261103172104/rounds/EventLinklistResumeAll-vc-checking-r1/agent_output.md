# Outcome

Blocked: annotation-gap in `proof_of_LinklistResumeAll_entail_wit_4_2`, the successful KTaskWakeup-to-loop-invariant backedge. No canonical file was edited. This finding does not require changing the approved public contract, the D1/D2 environment assumptions, or the executable C.

# Structural Blocker Scan

The generated whole goal has no split subgoal. Its first arm owns `os_inv sg after`, the two local task/node cells and `InsideCritical sg locked`; it retains pure snapshots of `current_2`, `marked`, `locked`, the event pending list and the generic `ktask_wakeup_step`. It does **not** retain `os_world_wf` / `NoDup (os_sched_owners ...)` of the old state whose `os_inv` was consumed by KTaskWakeup. The second arm is a pure variant with the same historical facts and cannot repair this omission.

A concrete state/resource countermodel shape is:

1. Choose distinct valid Event `p` and Semaphore `q`, and a registered task `t` with NULL Delay. In `current_2`, give Event `p` pending `[t]` and Semaphore `q` pending `[t]`. The task is SUSPEND with a valid ID and aligned address. Keep all other objects and fields ordinary. This old snapshot violates only the shared sched-owner exclusivity requirement relevant here; the VC antecedent does not own `os_inv current_2` or assert that exclusivity.
2. Set `locked = current_2`, `waiting = remaining_2 = [t]`, `target = task = t`, `rest = []`, and `desc` to the old descriptor. Then `event_resume_remaining_effect p waiting locked remaining_2 current_2` is reflexive (its premise and conclusion are the same effect). Choose a true continuation `X`; the frozen error-free abstract program admits the stated safeExec premise. Set `list_pre = event_pending_head p`, `next = sched_link_of t`, with distinct addresses as in an ordinary nonempty DLL observation. The live gap condition is true.
3. Set `marked` to the stated exstatus=-1 update. The generic `ktask_wakeup_step t (set_task_desc_exstatus desc (-1)) marked after` permits removing `t` from **both** the Event and Semaphore pending sequences: `wakeup_events` and `wakeup_semaphores` independently use their remove-found relations, and no old exclusivity is a premise of that pure step. Insert `t` once into ready, set its task status READY, leave NULL Delay and all other fields unchanged. Both pending queues are now empty.
4. `after` is an ordinary well-formed state: `t` has one ready owner, both container sentinels are empty, and all current task/ID/DLL resources can satisfy `os_inv sg after`. This resource can coexist with the frame local cells and the saved critical token. The saved `InsideCritical sg locked` does not re-establish an old `os_inv locked`; the protocol permits intermediate state updates while keeping that token.
5. The consequent must instantiate `current = after` to return the same shared heap. Its `event_pending_at` forces `remaining = []` for the unique Event `p`. The required progress relation therefore entails `event_resume_all_effect p [t] locked after`, because the empty remaining effect holds with final state `after` itself. That batch Event effect preserves the Semaphore component, while this `after` has changed Semaphore `q` from `[t]` to `[]`. Hence the required effect is false. The pure second arm forces the same empty remainder and fails for the same reason.

This countermodel is not claimed to be a real execution from a valid source precondition. It explains exactly why the **local generated VC** is too weak after the call: a fact available from the consumed old invariant was not carried as a pure fact into the post-call obligation.

# Annotation Comparison Review

The handoff lists no annotation comparisons. The relevant facts currently come from the loop invariant, the exstatus-update which-implies blocks, and KTaskWakeup's generic contract. None preserves old scheduler ownership exclusivity across the consumption of `os_inv(sg, marked)`. Current `os_inv(sg, after)` only establishes post-state exclusivity and cannot rule out simultaneous removal from two old queues.

# Proof-Mode Decisions

No proving mode or plan is selected. The structural countermodel allows immediate annotation feedback under the VC-checking workflow; completing split-first analysis of unrelated goals would not make this whole obligation valid. The seven split blocks and the two imported KTaskWakeup derivation compatibility obligations remain unchanged and unclaimed as proved.

# Common Proof Patterns

Deferred until a corrected current VC excludes the countermodel. Do not add an axiom or helper whose old-exclusivity premise is unavailable in this VC.

# VC Deltas

The exact failing top-level name is `proof_of_LinklistResumeAll_entail_wit_4_2` (parent `null`). Source location: `LinklistResumeAll`, successful return from KTaskWakeup, before re-establishing the loop invariant. The generated statement is `VC/EventLinklistResumeAll_goal.v`'s `LinklistResumeAll_entail_wit_4_2` definition.

# Grouping Decisions

No groups assigned. Do not send the invalid backedge to a proving owner.

# Risks or Blockers

Repair boundary: C annotation. Before consuming the old invariant, explicitly extract and preserve the required pure old-state exclusivity (for example `NoDup (os_sched_owners current)` / `os_world_wf sg current`, and its marked-state consequence, using locally proved which-implies obligations). Retain the fact through the Wakeup call and in the backedge context. The exstatus-only update preserves owner lists, so this is a consequence of existing resources, not a new user precondition. Annotation should also retain any other old-state pure validity facts actually needed for the batch-effect step; do not assume them merely because the old state variable exists.

The two imported <= derivation obligations are interface compatibility obligations, not KTaskWakeup body proofs. They must still be inspected after regeneration; no permission to delete or bypass them is implied by this blocker.
