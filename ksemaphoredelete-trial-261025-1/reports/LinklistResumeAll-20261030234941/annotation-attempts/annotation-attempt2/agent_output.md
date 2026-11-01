# LinklistResumeAll annotation r2

Completed the requested minimal body-annotation repair. At annotated_C/src/LinklistResumeAll.c:153 only `target != 0 &&` was removed; alignment, descriptor lookup, SUSPEND, pending-list association and complete os_inv remain. A byte comparison with the controller's annotation-attempt2/before snapshot shows exactly that one C annotation line changed, and the case library is unchanged. Frozen function contracts, predicates, executable C and reviewed NONE/while/imported-contract adaptations were preserved.

## Failed VC comparison

Source: `LinklistResumeAll-vc-proving-r1:pending_head`, `proof_of_LinklistResumeAll_which_implies_wit_3`. Historical proof: [r1 pending_head manual](../../../../verification_runs/LinklistResumeAll-20261030234941/LinklistResumeAll-vc-proving-r1/groups/group_02__pending_head/LinklistResumeAll_proof_manual.v). The worker had reduced the existing full-resource alternative to the unsupported target <> 0 conjunct; its completed descriptor/alignment helpers and witnesses 1/2 remain unchanged in that historical directory. The original [worker diagnosis](../../rounds/LinklistResumeAll-vc-proving-r1/groups/group_02__pending_head/group_worker_output.md) remains the evidence for that proof progress and its Rocq MCP checks.

Current manual still contains the same named witness referencing the newly generated Definition. Direct comparison with [the saved old goal](../../../../verification_runs/LinklistResumeAll-20261030234941/annotation_history/annotation-attempt2/before/VC/LinklistResumeAll_goal.v) confirms both generated alternatives remove only target <> 0. Input equalities, the pending-list premise, os_inv ownership, descriptor existential and every other result are unchanged. No new premise or replacement assumption was added. The reported annotation gap is resolved; this does not claim the current manual VC has been proved.

All 51 Definition names are unchanged. Besides which_implies_wit_3, fifteen downstream definitions changed: safety_wit_7/8; entail_wit_2; partial_solve_wit_6/7/10/13_pure and _aux; partial_solve_wit_8/9/11/12. After removing occurrences of the propagated nonzero fact and normalizing PreH numbering, each of those old/new definitions is identical. Some auxiliary conclusions also lose the propagated fact. Spatial resources, existential witnesses, other conclusions and both generated alternatives remain. The nonzero fact independently provided after the imported Wakeup call remains. These downstream manual proofs must be rechecked with the weaker premises, rather than treated as accepted solely because their old groups passed.

All r1 proof groups and reports remain untouched for reuse: [r1 groups](../../../../verification_runs/LinklistResumeAll-20261030234941/LinklistResumeAll-vc-proving-r1/groups/), including pending_head helpers and completed witnesses. This role did not edit or prove any manual VC, merge group helpers, or alter historical artifacts. Subsequent proof work must follow the user's Rocq MCP requirement described in `.docs/Report/rocq-mcp-workflow.md`.

## Validation and current input

The exact handoff commands all returned exit code 0 and JSON status passed:
- formal-case-lib-design: 38.861944 seconds;
- symexec: 0.944 seconds, all generated outputs published;
- formal-case-lib: 44.851321 seconds.

Fresh controller mapping: [mapping.json](../../../../evidence/parser-normalization/0258dd37a77fdcdb02d58fad348819362e3643129c6e09b05f464fa02075c2b8/mapping.json).
Canonical SHA-256: `a295dc8474fde9a7113adc3f547225b6638994b0b1676cb98a935e967bad3e68`.
Parser SHA-256: `0258dd37a77fdcdb02d58fad348819362e3643129c6e09b05f464fa02075c2b8`.
The mapping preserves the reviewed four imported-contract proof boundaries and sanctioned NULL_PARAM_CHECK_1 normal-return model; neither is claimed locally proved. Historical source-audit hashes are not presented as current. The current symbolic check exercised the frozen-input guard and regenerated the mapping from the modified annotation source.

Execution trace: `evidence/qcp-execution-traces/a857cc139e64c4043695e7d98250041df90557afd50526af745b85097a1d3a34.txt`.
SMT diagnostic: `evidence/qcp-smt-diagnostics/cdbd3ce23b4ba92cb5e6756b74e273946e91e96fb5f661e7735f094854566eed.txt`.

The annotation owner stops writing after the terminal report. Main should finalize this delivery and schedule proof reuse/rechecking under the controller.
