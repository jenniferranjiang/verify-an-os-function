# Outcome
Completed analysis of all 42 top-level VCs. Plan has 10 independent groups. No proof scripts or canonical formal files were changed. This is proofability analysis, not a proof-completion claim.

# Structural Blocker Scan
Scanned all 42 top-level definitions, no-split wholes first. No concrete countermodel or missing current/pre address bridge was identified. Allocation uses numeric 32; malloc supplies positivity/range/alignment. The byte cut retains sem and both node-base nonzero facts. ID failure returns insert-ready memory and the cut asks for Raw (not Zero). Successful insertion consumes the ID resource into the manager while the payload owns value/pending queue/padding. Full DLL is retained through the list call. The publication cut keeps InsideCritical at st_lock and updates only os_inv. No ownership duplication was found.

# Annotation Comparison Review
The handoff lists no annotation comparisons. Independent premise provenance: the byte conversion establishes alignment and node-base facts from malloc/layout; entail 3 extracts world/context and proves freshness using separated heap ownership; entail 4 handles ID-failure completeness; entail 5 derives ID range from min-free/context; entail 6 constructs the new list payload; entail 7 establishes publication invariant and guarantee. These are assigned proof obligations, not assumed established.

# Proof-Mode Decisions
Split-first pass, in canonical declaration order (all split judgements were completed before assigning whole-goal modes):
- `proof_of__SemaphoreCreate_entail_wit_1_split_goal_1`: 不可证 — safeExec alone does not imply a scalar type range for arbitrary X; the local UShort resource was removed.
- `proof_of__SemaphoreCreate_entail_wit_1_split_goal_2`: 不可证 — safeExec alone does not imply a scalar type range for arbitrary X; the local UShort resource was removed.
- `proof_of__SemaphoreCreate_entail_wit_2_split_goal_1`: 可证 — current pure/spatial premises retain the necessary facts/resources.
- `proof_of__SemaphoreCreate_entail_wit_2_split_goal_2`: 可证 — current pure/spatial premises retain the necessary facts/resources.
- `proof_of__SemaphoreCreate_entail_wit_2_split_goal_3`: 可证 — current pure/spatial premises retain the necessary facts/resources.
- `proof_of__SemaphoreCreate_entail_wit_2_split_goal_spatial`: 可证 — current pure/spatial premises retain the necessary facts/resources.
- `proof_of__SemaphoreCreate_entail_wit_3_split_goal_1`: 可证 — current pure/spatial premises retain the necessary facts/resources.
- `proof_of__SemaphoreCreate_entail_wit_3_split_goal_2`: 可证 — current pure/spatial premises retain the necessary facts/resources.
- `proof_of__SemaphoreCreate_entail_wit_3_split_goal_3`: 可证 — current pure/spatial premises retain the necessary facts/resources.
- `proof_of__SemaphoreCreate_entail_wit_3_split_goal_spatial`: 可证 — current pure/spatial premises retain the necessary facts/resources.
- `proof_of__SemaphoreCreate_entail_wit_4_1_split_goal_1`: 可证 — current pure/spatial premises retain the necessary facts/resources.
- `proof_of__SemaphoreCreate_entail_wit_4_1_split_goal_spatial`: 可证 — current pure/spatial premises retain the necessary facts/resources.
- `proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_1`: 可证 — current pure/spatial premises retain the necessary facts/resources.
- `proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_2`: 可证 — current pure/spatial premises retain the necessary facts/resources.
- `proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_spatial`: 可证 — current pure/spatial premises retain the necessary facts/resources.
- `proof_of__SemaphoreCreate_entail_wit_6_split_goal_spatial`: 可证 — current pure/spatial premises retain the necessary facts/resources.
- `proof_of__SemaphoreCreate_entail_wit_7_split_goal_1`: 可证 — current pure/spatial premises retain the necessary facts/resources.
- `proof_of__SemaphoreCreate_entail_wit_7_split_goal_spatial`: 可证 — current pure/spatial premises retain the necessary facts/resources.
- `proof_of__SemaphoreCreate_return_wit_1_split_goal_1`: 可证 — current pure/spatial premises retain the necessary facts/resources.
- `proof_of__SemaphoreCreate_return_wit_2_split_goal_1`: 可证 — current pure/spatial premises retain the necessary facts/resources.
- `proof_of__SemaphoreCreate_return_wit_3_split_goal_1`: 可证 — current pure/spatial premises retain the necessary facts/resources.
- `proof_of__SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1`: 可证 — current pure/spatial premises retain the necessary facts/resources.
- `proof_of__SemaphoreCreate_partial_solve_wit_8_pure_split_goal_1`: 可证 — current pure/spatial premises retain the necessary facts/resources.

After the split pass: all parents except entail_wit_1 having splits use aggressive_pre_process. entail_wit_1 uses LLM_pre_process (left disjunct with UShort ownership). Every no-split top-level uses LLM_pre_process. Thus 11 aggressive parents and 31 whole-goal parents cover all 42 VCs.

# Common Proof Patterns
- FRAME: introduce pure parameters; retain/reorder exact heap atoms with cancellation; discharge repeated pure conjunctions from hypotheses. For pure-to-aux wrappers prove direct aux arithmetic/anchor/reflexivity rather than reintroducing missing C locals.
- RANGE: machine-constant bounds by normalization and arithmetic; impossible branch combinations by contradiction. Local UShort range extraction is a separate resource-dependent case.
- FOLD: open/fold os_inv and semaphore ownership, preserving every unchanged frame and using typed unknown-value weakening where allowed.
- REFINE: safeExec bind/choice/test specialization along allocation failure, ID exhaustion, or success with the actual before/st_lock/publication states.

# VC Deltas
- `byte_layout`: `entail_wit_2`. Detailed per-target differences and formal split strategies are in group_plan.json.
- `publish`: `entail_wit_7`, `partial_solve_wit_9_pure`, `partial_solve_wit_9`. Detailed per-target differences and formal split strategies are in group_plan.json.
- `open_id`: `entail_wit_3`, `partial_solve_wit_4`. Detailed per-target differences and formal split strategies are in group_plan.json.
- `id_failure`: `entail_wit_4_1`, `entail_wit_4_2`, `partial_solve_wit_5`, `partial_solve_wit_6_pure`, `partial_solve_wit_6`. Detailed per-target differences and formal split strategies are in group_plan.json.
- `list_prepare`: `entail_wit_5`, `entail_wit_6`, `partial_solve_wit_7`, `partial_solve_wit_8_pure`, `partial_solve_wit_8`. Detailed per-target differences and formal split strategies are in group_plan.json.
- `returns`: `return_wit_1`, `return_wit_2`, `return_wit_3`. Detailed per-target differences and formal split strategies are in group_plan.json.
- `entry_calls`: `entail_wit_1`, `partial_solve_wit_1_pure`, `partial_solve_wit_1`, `partial_solve_wit_2_pure`, `partial_solve_wit_2`, `partial_solve_wit_3`. Detailed per-target differences and formal split strategies are in group_plan.json.
- `safety_entry`: `safety_wit_1`, `safety_wit_2`, `safety_wit_3`, `safety_wit_4`, `safety_wit_5`, `safety_wit_6`. Detailed per-target differences and formal split strategies are in group_plan.json.
- `safety_alloc`: `safety_wit_7`, `safety_wit_8`, `safety_wit_9`, `safety_wit_10`, `safety_wit_11`, `safety_wit_12`. Detailed per-target differences and formal split strategies are in group_plan.json.
- `safety_locked`: `safety_wit_13`, `safety_wit_14`, `safety_wit_15`, `safety_wit_16`, `safety_wit_17`. Detailed per-target differences and formal split strategies are in group_plan.json.

# Grouping Decisions
Byte conversion is a singleton because it is the distinct byte/layout helper family. Publication contains the heavy manager/world preservation plus its final unlock frame; unrelated return refinement and list-payload construction are separated to reduce the tail. Open-ID freshness and failure/refold are separate resource families. Entry-call bookkeeping is kept with by-local range extraction. Safety work is divided by program stage into groups of 6, 6 and 5. Every group has at most 6 top-level witnesses, below the hard limit 12. Plan ordering puts byte conversion and publication first, then ownership/ID/list transformations, then returns and lightweight calls/safety. No group imports a sibling output.

# Risks or Blockers
No definite blocker. High-risk proof work is publication manager equality/world-wf preservation, heap-disjointness freshness, and byte-to-typed conversion under the frozen layout premise. Existing imported bridges must be instantiated against their actual hypotheses; if a required premise is genuinely absent, report it rather than weaken a generated statement. No need for a debug Show run was identified: generated definitions expose all resource and pure shapes required for this analysis. The two invalid by-local splits remain unused; they are not required proof gaps on the chosen whole-goal route.
