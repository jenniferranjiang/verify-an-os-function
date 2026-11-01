Completed all six assigned unlock frame witnesses using LLM_pre_process.

The three pure witnesses follow directly from the given Crtos_GTrans hypothesis. The wrappers unfold their matching auxiliary definitions, reinsert the existing pure facts and cancel the unchanged InsideCritical, os_inv and (where present) SemaphoreRetired resources. No helpers or semantic changes were needed; the group library seed is unchanged.

Rocq MCP: rocq_compile on the exact copied goal Definitions and all six complete candidate proofs returned success: true. The candidate imports the frozen shared dependencies; no admitted proofs were used in the candidate. Earlier exploratory calls exposed the wrapper preprocessing state and were not treated as completed proof evidence.

Validation: forbidden lemma/tactic scan passed. The exact assigned controller coq-check --target-kind group-check --group unlock_frames exited 0 and returned status: passed (94.533742 seconds). It recompiled the group library, goal, auto/manual proofs, and group wrapper in group_21/src.

All assigned proofs are complete. No files will be changed after terminal delivery.
