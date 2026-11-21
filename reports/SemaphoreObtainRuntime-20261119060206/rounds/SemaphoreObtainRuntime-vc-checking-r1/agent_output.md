# Obtain VC checking r1

## Outcome

Blocked by a concrete call-precondition branch mismatch at KTaskSetDelay. No proving plan is delivered. Controller coq-debug actually returned exit 0 / status passed and loaded the current goal, auto and debug manual, including existential Assertion residual frames and derivable1. This is elaboration evidence only, not an implementation proof.

## Structural Blocker Scan

The current top-level `proof_of__SemaphoreObtain_partial_solve_wit_21_pure` is the null-delay branch of the finite wait call. Both alternatives of the top-level obligation require `delay_inactive_map (os_delays suspended) 0 <> None`. Its antecedent instead carries `sd.tdDelay = 0`, the actual delay-pointer cell storing that zero, delay_inv/tick_inv, and the residual resource. There is no inactive-at-zero premise. The two generated split goals repeat the same unsupported conclusion.

The relevant permitted resource shape is a suspended registered task whose delay field is zero, with an empty inactive map (and, for a simple local shape, an empty active delay DLL). Existing delay_world_wf explicitly permits a task with zero delay without any delay object; the inactive map ownership is then empty. No pointer/object at address zero is supplied. The other state/frame and continuation conditions are retained; the defect does not arise from a current/@pre scalar bridge. The normal zero-delay allocation path of KTaskSetDelay must remain admitted by the caller.

The imported `for_null_inactive` contract requires `(desc.tdDelay == 0 || inactive_map(desc.tdDelay) != None)`. Its first disjunct is already true here. The generated top-level VC nevertheless requires the second disjunct at zero. Neither selecting the other top-level alternative nor retaining its spatial resources supplies that missing map entry. Repair the C call-site assertion/spec-selection organization so QCP establishes the actual disjunction or selects the applicable null case. Do not strengthen the public Require, assume an inactive object at zero, change the delay model, weaken Ensure, or edit generated VCs.

This finding is local to the current generated call precondition. It is not a claim that original C is defective, nor a rejection of the approved assertS observation modeling/whitelist.

## Annotation Comparison Review

No prior VC comparisons were supplied in this first attempt. The finite-delay residual restoration property is explicitly introduced by entail_wit_11 as an existential resource plus a universal ktask_set_delay_step restoration entailment; later goals may use it only after that VC is actually proved. It is not an axiom or an already proved lemma. Its actual Coq type elaborates successfully.

## Proof-Mode Decisions

Stopped at the top-level structural blocker as allowed by the role workflow. The null-delay top-level obligation must be repaired before a complete split-first judgment and valid group plan can be delivered. No unexamined split or whole goal is marked proved or approved.

## Common Proof Patterns / VC Deltas / Grouping

No detailed proof strategy or group plan is issued for this blocked input. Existing semantic definitions and canonical files remain read-only. Only the handoff debug manual was changed, by inserting one Show command into the first split proof body; no proof or non-proof tokens were otherwise changed.

## Risks or Blockers

Actual returned goal at lines 2764 onward of the current goal file is the evidence; the canonical finite-delay call is the KTaskSetDelay(... where(for_null_inactive) ...) expression. Public caller/callee contract semantics must be preserved while correcting the call-precondition branch. Further mathematical checking of the remaining obligations is deferred to the repaired attempt, not reported as passed.
