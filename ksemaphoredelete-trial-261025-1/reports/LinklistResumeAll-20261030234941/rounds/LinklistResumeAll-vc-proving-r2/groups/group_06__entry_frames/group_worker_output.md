# entry_frames completion, round 2

All six assigned witnesses are proved with the required LLM_pre_process route. They establish zero integer bounds and preserve explicit entry premises and os_inv. The pure-to-aux witness invokes LLM_pre_process a second time for its aux definition.

The compatible r1 scripts were reused as documented in proof_reuse.md. No helper or import was added. The group library is byte-identical to the r1 seed. Only the six assigned manual proof spans were changed; declarations, unassigned tokens and accepted semantics were preserved.

Rocq MCP rocq_compile compiled a complete candidate built from verbatim current goal Definitions, the aux definition, current annotation-library definitions and the six Qed proofs. It returned success: true and empty diagnostic output in the trial workspace. No development staging check was needed.

The required controller group-check completed with process exit code 0, JSON status passed and returncode 0, taking 104.045173 seconds. It rebuilt the current group library, goals, automatic proof, manual and group wrapper in LinklistResumeAll-vc-proving-r2/group_06/src. The forbidden lemma/tactic token scan passed for the copied manual and library.

All writes are complete. The main agent may finalize this delivery.
