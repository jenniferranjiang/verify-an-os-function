# Outcome

Blocked: the current canonical VC still contains the annotation gap reported by task_prepare. No successful proving plan is issued. Canonical C, library, goal, auto and manual files are unchanged; no new proof or compilation success is claimed.

# Structural Blocker Scan

The current manual has 36 top-level witnesses and 47 split declarations. Its names agree with the handoff. Priority inspection of unsplit witnesses confirms the missing premise in `proof_of__SemaphoreObtain_entail_wit_8` (goal definition at line 1242). Both disjuncts require `assignRunningTask (os_assign held) <> 0` in the consequent. Antecedents provide current-task admissibility and a universal condition on future successful suspensions, but no successful suspension has yet occurred.

Concrete failing assignment/resource shape: running address and returned current-task address are 0, the task map registers a RUNNING descriptor at 0, a separate semaphore has value 0, and msec/wait_time are -1. Task-descriptor fields are owned at their modeled offsets, with the other os_inv components on disjoint resources. The carried finite-delay condition is vacuous because `0 < -1` is false. The bound feedback documents that TaskInv and assign_world_wf permit this registered base-zero case, and valid_object does not exclude address 0. Neither the semaphore ID node nor the task ID field being nonzero establishes task-base nonzero. Both consequent alternatives fail at `0 <> 0`, independently of which exstatus-focus existential is chosen. This is the same substantive gap as the bound task_prepare report, not a proof-search timeout.

# Annotation Comparison Review

The earlier null-delay comparison remains reflected correctly in the generated goal: partial_solve_wit_21_pure has `sd.tdDelay = 0` and asks for `sd.tdDelay <> 0 -> inactive_map(sd.tdDelay) <> None`; it no longer demands membership of address 0. This witness is native auto, not a current manual obligation. Its range, lookup, context and window conjuncts are carried premises. This local resolution does not establish the unrelated early task-nonzero fact.

# Proof-Mode Decisions

No final mode decisions or full split-first analysis are issued after the definite structural blocker. The bound delay_failure_restoration report separately identifies composition failure for entail_wit_12_1 and entail_wit_12_2: generated splits retain the pure os_global_context wrapper that aggressive preprocessing extracts. Preserve that feedback for the next checking attempt; do not treat four split proofs as completed top-level proofs.

# Common Proof Patterns

Deferred until annotation repair produces a structurally sound input.

# VC Deltas

The task_prepare blocker remains present in both whole-goal alternatives. No premise establishing early nonzero has been added. The successful later suspension relation belongs to entail_wit_10, after the affected assertion; it cannot justify the earlier entail_wit_8.

# Grouping Decisions

An empty groups array records blocked analysis only; it is not a successful coverage plan.

# Risks or Blockers

Return to annotation to remove the unsupported early nonzero demand or otherwise supply a justified repair, then regenerate affected VCs. Prefer the minimal internal-assertion correction discussed by main: retain task identity, registration and memory ownership before the call, and establish nonzero from the successful suspension contract afterward. This report does not authorize or require public Require strengthening, a global TaskInv change, new trust or an algorithm repair. The annotation owner must verify the actual repair and establish its subsequent obligations.
