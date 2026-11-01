# retirement_commit r2 delivery

Owner: `group-worker/SemaphoreDelete-vc-proving-r2:retirement_commit`.

Completed witnesses:
- `proof_of__SemaphoreDelete_entail_wit_4_2`
- `proof_of__SemaphoreDelete_entail_wit_4_4`

Restored the validated r1 assigned proof/helper closure after comparing the exact current seed and unchanged declarations. Frozen external dependency hashes matched. All helper propositions and proof bodies remain unchanged. The sole historical library change is removing redundant `Bool.Bool` from the supplemental import, leaving `From Coq Require Import Lia Sorting.Permutation.`. This prevents the merged import order from parsing assertion && as bool.

Rocq MCP validation: `rocq_compile` in `/home/xinra/crtos/ksemaphoredelete-trial-261025-1` compiled the complete corrected helper library, current original goal Definitions, and both assigned proofs. Result: `success: true`, output empty. The successful candidate was then saved to the r2 owned files. No interactive backend or compile_file was used.

Formal validation: exact handoff `coq-check --round SemaphoreDelete-vc-proving-r2 --target-kind group-check --group retirement_commit` returned exit 0 and JSON status `passed`.

Only the assigned proof spans, supplied group library, and group reports were written. Seed declarations, unassigned spans, source/spec/predicate files, and r1 history remain unchanged. No new assumption or annotation gap.

Group-check call: `e5e33800a484450ab0da30f91ee6d188`; completed `2026-10-31T02:16:03.014313+00:00`.
