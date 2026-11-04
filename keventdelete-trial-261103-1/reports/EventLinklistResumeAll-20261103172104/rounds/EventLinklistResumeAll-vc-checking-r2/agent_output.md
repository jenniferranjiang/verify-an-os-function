# Outcome

Completed VC checking for the current annotation r2 output. The current manual has 54 top-level obligations and 7 split goals. No definite structural countermodel remains. The plan contains 14 independent groups, with 5 aggressive parents and 49 LLM parents. This is a proofability analysis and assignment plan, not a proof of those obligations.

No canonical file or debug manual was modified. The generated goal definitions already expose the assertions and pure premises needed for this analysis, so no Show/coq-debug run was necessary.

# Structural Blocker Scan

The complete top-level scan checked local pointer/current-to-@pre bridges, actual owned resource addresses, existential choices, and historical versus current OS state. Scalar safety and partial-solve goals retain the necessary local equalities. The sentinel/exstatus/task-ID views have their corresponding spatial wands; the wand-return VCs return the same invariant that each view promises. The NULL branch is an unchanged nonreturning loop, and its two invariant entailments merely forget local values or reassert the same facts.

The previous countermodel used an old task simultaneously in the target Event and another Semaphore. In the current successful backedge `LinklistResumeAll_entail_wit_4_2`, PreH14/15 contain `os_world_wf` and `task_world_wf` for `marked`; PreH27/28 contain both for `current_2`. The old event head is explicitly `target::rest`. The scheduler-owner NoDup projection therefore excludes a second queue/self-owner occurrence of that target. The prior simultaneous-removal countermodel no longer satisfies the antecedent.

The successful backedge still does not own old `os_inv`. Its intended proof must use the now-retained old world facts together with the owned **post** `os_inv(after)` and the exact generic Wakeup frame. In particular, task ID-manager validity/lookup uniqueness can be obtained from the unchanged manager represented by the post invariant; event object representation uniqueness and relevant delay shape restrictions must be recovered through components preserved by the generic step and the post invariant. The planned helper explicitly retains this proof obligation and does not assume an old heap. This is high-risk mathematical work, but no concrete counterexample or missing mandatory premise was identified after examining the record updates and framing relations.

The generic failure backedge can use its spatial arm: `after=marked` restores access to the marked invariant, which identifies the two equal-ID task lookups. The marked target descriptor preserves the original SUSPEND status, contradicting the generic failure status. The plan does not try to invent progress for a real failed Wakeup.

Both imported KTaskWakeup derivation obligations retain an owned source invariant **before** constructing the callee-post wand. Their old-state exclusivity facts can therefore be extracted within the refinement proof. They are distinct from the earlier generated C backedge, where the old invariant had already been consumed. They remain compatibility obligations, not KTaskWakeup function-body proofs.

# Annotation Comparison Review

The handoff's comparison names current backedge `proof_of_LinklistResumeAll_entail_wit_4_2` and source obligations `proof_of_LinklistResumeAll_which_implies_wit_4` and `_7`. I checked their current statements rather than accepting `resolved` at face value.

- `_which_implies_wit_4` has the actual `os_inv(sg,current)` on the left, along with nonempty event membership. Its spatial right branch retains that same invariant and extracts registered SUSPEND descriptor/alignment plus both current world facts. These facts follow from Task/Event representation and the world part of the invariant.
- `_which_implies_wit_7` has the actual `os_inv(sg,marked)` on the left. The explicit exstatus-only map equation preserves `os_events`, so the same event head remains in marked. It extracts the concrete task ID, registration relation, marked world facts, and the ushort field with its restoration wand.
- The successful backedge actually contains all four extracted old-world premises. The target status and both ID-lookup relations also remain present; the post invariant and exact `ktask_wakeup_step` supply the post heap and frame.

Thus the repair has a real derivation source and rules out the reported countermodel. It has not weakened the loop progress target or public contract. The three comparison-current obligations are deliberately kept together in the first group so the controller's priority batch checks the repair as a whole.

# Proof-Mode Decisions

The strict split pass was completed first, in current manual order:

| Split goal | Binary judgement |
|---|---|
| `proof_of_LinklistResumeAll_which_implies_wit_3_split_goal_spatial` | Provable |
| `proof_of_LinklistResumeAll_which_implies_wit_5_split_goal_spatial` | Provable |
| `proof_of_LinklistResumeAll_which_implies_wit_6_split_goal_spatial` | Provable |
| `proof_of_LinklistResumeAll_which_implies_wit_8_split_goal_spatial` | Provable |
| `proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_1` | Provable |
| `proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_2` | Provable |
| `proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_3` | Provable |

Consequently `_which_implies_wit_3`, `_5`, `_6`, `_8`, `_9` use `aggressive_pre_process` and their formal targets are exactly these seven splits. All other 49 top-level obligations have no split and use `LLM_pre_process`, including the spatial first arms of the successful/failure backedges, the nonempty metadata and ID extraction obligations, and the two imported refinements. Their whole-goal analysis found a proof route with available premises. No generated split was removed or changed.

# Common Proof Patterns

1. **Pure projection and exact frames.** The partial-solve goals carry explicit descriptor, head, branch and continuation equalities. Reassert the listed facts and cancel the same invariant, critical token and/or borrowed field-wand pair. The ID read uses the same ushort value, promoted to int without narrowing. `retval=target` bridges the C pointer returned by the container model to the logical task address.
2. **Borrow and return.** Locate the selected Event's waiting DLL or Task field in `os_inv`; split only the required cell and introduce a wand to reconstruct the same/explicitly updated invariant. The return splits use wand elimination. The exstatus update affects only the descriptor's exstatus, preserving all status/ID/pending relationships and unrelated modules.
3. **Corrected head step.** Identify the generic returned task with the source head using the unchanged ID manager. Retained old scheduler-owner NoDup localizes removal to this one Event and excludes changes to unrelated queues. Use the record frame and post representation to prove head-to-batch composition; instantiate the next invariant with `current=after`, `remaining=rest`, then compose with old `event_resume_remaining_effect`.
4. **Atomic completion.** At loop exit, nil remaining yields an identity remaining effect, hence progress yields the original waiting batch effect from locked to current. Apply the original safeExec to that guarded atomic transition. The old gap preserves the nonzero object address, current pending is nil, and the existing global guarantee relation is unrestricted. Return the same current OutsideCritical observation.
5. **Imported refinement wands.** Before transferring source `os_inv`, retain its pure ID, status and exclusive-owner consequences. Instantiate generic sg/before identically, then handle both generic post branches under a wand. Use source membership to localize removal to the Semaphore head or detached self-owned list; NULL Delay forces unchanged delay state for the detached specialization.

The plan provides each selected target's exact instantiations, cancellations and remaining differences, rather than repeating these patterns in full here. All proposed helpers state their required old or post facts and the actual VC source of those facts. No helper is allowed to use old `os_inv` in the corrected backedge where only old pure facts survive.

# VC Deltas

Compared with the first attempt's blocker, the relevant semantic delta is the preserved current/marked world information in backedge `_4_2` and its new extraction conclusions in `_which_implies_4` and `_7`. The public operation, the batch effect, generic Wakeup step and loop progress target are unchanged. The same pure facts now propagate through the intervening partial-solve VCs and safety checks; those are projection/frame obligations. The original false old-double-queue assignment is excluded by NoDup.

# Grouping Decisions

There are 14 groups, maximum 6 top-level witnesses in a group, below the handoff limit 12. The first `event_batch_step` group holds all three comparison-current witnesses and their tightly connected task metadata/ID borrowing and head-to-batch helper family. It has difficulty 5 and is the likely critical path.

The two imported refinement groups each have one witness because each is a distinct source-contract/wand refinement with its own owner-local helper family; combining them with the C loop would enlarge the critical path without sharing an indispensable proof context. The singleton `wakeup_failure` is an independent contradiction route using the failure post-state, deliberately separated from successful batch composition.

The remaining groups separate pending-head access, exstatus update, wand returns, atomic exit, entry/null-loop, lock/read frames, container branches, task-ID frames and scalar bounds. Initialization and final return work are not bundled into the heavy batch step. All groups are independent; the plan has no sibling dependency or reuse instruction. Helper names carry their exact group suffix.

# Risks or Blockers

No confirmed blocker is reported. The head-to-batch composition and two imported generic-to-specialized Wakeup refinements require substantive new helpers. They are marked high risk; a proving owner must derive every premise from the current statement and report a precise missing-premise/countermodel if one is found. Neither prior design approval nor this analysis permits treating the `event_resume_all_effect_steps_obligation` Definition as a proved theorem.

This report does not assert implementation verification or group acceptance. Controller validation and actual group proofs remain required.
