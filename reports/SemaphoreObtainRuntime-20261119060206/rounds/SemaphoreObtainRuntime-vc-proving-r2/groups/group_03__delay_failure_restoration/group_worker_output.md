# Delay failure restoration

Completed both assigned whole-goal witnesses `proof_of__SemaphoreObtain_entail_wit_12_1` and `proof_of__SemaphoreObtain_entail_wit_12_2` using `LLM_pre_process`.

The failure branch of `ktask_set_delay_step`, together with nonzero return, yields return -5, a zero delay pointer, and unchanged suspended state. After substitution, `split_pure_spatial` separates the preserved facts from the memory goal. Cancellation frames `InsideCritical`; the carried restoration premise, instantiated at the actual failure transition, reconstructs `os_inv`. No new premises, helpers, imports, or trust assumptions were introduced.

Historical r1 split proofs informed the branch analysis; the current proofs are whole-goal proofs. All four protected unused split blocks retain generated `Proof. Abort.` tokens. Only the two assigned top-level proof spans were changed.

Exact controller `group-check` passed with process exit 0 and JSON status `passed` (elapsed 35.980459 seconds), compiling the current manual and group wrapper. This is group-level proof completion; parent/final checks remain the orchestrator's responsibility.
