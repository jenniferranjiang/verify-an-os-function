# safety_1_8 delivery

Completed the eight assigned top-level safety witnesses using the prescribed whole-goal route, each beginning with explicit `LLM_pre_process ltac:(lia || int_auto)` and ending in Qed. The literal bounds/negation conditions follow from ILP32 integer arithmetic; the two inconsistent base guards close by existing pure equalities. No dynamic bound or new assumption was introduced.

Only the eight assigned proof spans changed. A mechanical comparison with current canonical manual after masking those spans confirmed all remaining text identical. Statements, prelude, declaration order and unassigned generated proofs were preserved. No helpers or imports were added.

Validation used only the local controller group-check invocation from the handoff, not Rocq MCP. This follows the parent instruction after the earlier auto-review denial of a project-source MCP payload; no equivalent MCP upload was retried. The controller returned exit 0/status passed, compiled current goal/auto/manual/group wrapper, and reported 39.733814 seconds. Terminal report is written last and no files will be changed after delivery.
