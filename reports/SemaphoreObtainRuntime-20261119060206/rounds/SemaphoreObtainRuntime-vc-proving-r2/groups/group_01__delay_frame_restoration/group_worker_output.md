# Delay frame restoration — r2

Completed `proof_of__SemaphoreObtain_entail_wit_11` in the assigned copied manual using `LLM_pre_process` and a complete `Qed` proof.

Reused the corresponding accepted r1 delay_frame_restoration proof span, after checking the declaration against the current assignment. No statement, prelude, imports, unassigned proof spans, library, spec or annotation was changed. The proof constructs the residual Assertion from actual os_inv resources and restores the full invariant on both ktask_set_delay_step outcomes, transporting unchanged task scheduling and module facts across the delay-pointer map update. No inactive-map membership at zero is introduced.

Forbidden lemma/tactic scan: no matches. The exact current r2 controller group-check completed with process exit 0, JSON status `passed`, returncode 0. It compiled current goal, native auto, manual and group wrapper; elapsed 89.523062 seconds. This is current group validation, not parent/final-check.

Historical source: `verification_runs/SemaphoreObtainRuntime-20261119060206/SemaphoreObtainRuntime-vc-proving-r1/groups/group_00__delay_frame_restoration/SemaphoreObtainRuntime_proof_manual.v` (assigned witness only).

All writing stops after terminal report delivery.
