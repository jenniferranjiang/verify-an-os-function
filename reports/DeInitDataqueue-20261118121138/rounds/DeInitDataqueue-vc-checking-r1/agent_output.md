# DeInitDataqueue VC checking

## Outcome

45 top-level VCs, 12 split goals. Current generated declarations load successfully under prescribed controller coq-debug (exit 0, status passed, 25.83s). No whole-goal structural blocker found. This is a proof plan, not completed implementation verification.

## Structural blocker scan

Scanned all top-level goals before split classification. Current p_queue is kept equal to p_queue@pre at cuts; all six fields and padding are present, private array is converted to exactly max_len*8 bytes before free, and base becomes zero on the actual freed branch. Saved observed/middle/after values, first-delete effect and original safeExec are preserved through the second-delete cut. No required resource is fabricated in feasible branch projections: entail2_1 and3_2 carry contradictory base equality/nullness premises, while2_2 and3_1 preserve exact resources. Final goals can instantiate final with after or middle and fold the precise retired record, including negative error codes left unchanged. Actual ABI fact is available; no obligation Prop is treated as a theorem.

## Annotation comparison review

No historical comparisons in this first attempt. Independently checked new cuts: the two initial quiescent assertions must be derived from checked cleanup_entry and the actual os_inv at the IRQ observation; subsequent quiescent follows from deletion filtering the semaphore set while leaving queue map unchanged. Array free view must be constructively proved, and final safeExec must follow from the real two conditional effects. These are explicit VCs, not assumed facts. Existing ReviewWhitelist001 concerns assertS admissibility only, not proof discharge.

## Split-first classification (manual order)

- entail_wit_1_split_goal_1: **not provable from the split premises**.
- entail_wit_1_split_goal_2: **not provable from the split premises**.
  Both demand a pure quiescent property from safeExec and RTrans alone. cleanup_entry provides an entailment from os_inv; the split removed that resource/inhabitation evidence. In particular the checked implication can be vacuous for an unrealizable observed state. Whole-goal LEFT route retains os_inv and supports extracting the property without dropping resources. Thus parent uses LLM_pre_process; both unused split proof blocks remain generated Abort.
- entail_wit_4_1 splits1/2/3: **provable**. First: deletion either preserves state or removes entries; existing second-ID quiescence is monotone under this operation and queue map is unchanged. Second/third: nonnegative blank maps to -1 in retired record.
- entail_wit_4_2 splits1/2/3: **provable**, same reasoning; nonnull-buffer history has no effect on this pure property.
- entail_wit_4_3 splits1/2: **provable**, negative blank is unchanged by retired record.
- entail_wit_4_4 splits1/2: **provable**, same reasoning for the freed-buffer history.

All split judgments were completed before deciding top-level modes or strategies.

## Proof-mode decisions

Four entail_wit_4_* parents use aggressive_pre_process with all ten associated splits. Remaining 41 top-level targets use LLM_pre_process. entail_wit_1 uses its spatial LEFT alternative as above; entail_wit_5_1..4 also use whole spatial LEFT alternatives with current os_inv and private fields. All other no-split targets are frame/arithmetic, feasible resource projections, contradictory-path elimination, or the owned-array-to-bytes conversion. Every top-level goal is covered once by group_plan.json.

## Common proof patterns and VC deltas

1. Owned view: unfold store_dataqueue/dataqueue_fields/dataqueue_buffer. Null base leaves emp; nonnull base supplies positive max_len and store_array of slots. Flatten each slot to its eight owned bytes, forgetting initialized payload/length values rather than owning payload memory. Reassemble CharArray.undef_full by array induction; authorized layout equations discharge address/stride conversions. Keep structure fields and padding. This is the main new resource transformation.
2. Observation: use safeExec of leading assertS and RTrans membership of observed, then apply cleanup_entry to actual os_inv and project quiescence. Retain original continuation and frame private queue/InsideCritical.
3. Free branch projections: 2_1/3_2 contradictory; 2_2/3_1 exact field/resource projection. Callee free positivity follows positive max_len and multiplier8, with allocation base tied by equality.
4. First delete: for nonnegative blank instantiate middle=after; for negative blank middle=observed. Pure split proofs are filtering monotonicity and Z.leb cases on dataqueue_retired. No assumption that IDs are distinct is needed for quiescence preservation.
5. Final cleanup: instantiate final=after for data>=0, else middle. Construct cleanup_effect using existing first-delete witness and real second-delete effect/identity. Derive atomic high-step and safeExec continuation; fold retired object from unchanged front/rear/max_len, zero base, empty slots, and branch-dependent sem IDs. Keep current os_inv and observed critical token. The absence of array after free is intentional; retired buffer is emp.
6. Return: choose after=final, reorder OutsideCritical and retired object. Partial-solve pure goals project given effects/quiescence or free arithmetic; implication goals use their explicit pure-obligation argument and cancel exact frames. Safety2/3 are impossible base-shape branches; all other safety goals are literal ILP32 bounds/negation.

## Grouping decisions

Ten independent groups, sizes1/1/4/4/4/3/8/8/6/6, all below hard maximum12. Owned buffer conversion and IRQ observation are separate single-goal groups because they have independent resource/protocol proof families. First-delete transitions and final cleanup are separate four-goal groups, keeping pure filtering arguments separate from high-step/refolding. Safety groups of8 are homogeneous fixed-literal/contradiction obligations; larger grouping avoids repeated compilation overhead without mixing heavy context. Call-frame groups of6 share their actual callee-precondition pattern. No helper is planned because formal_case_lib is absent; any needed local supporting facts must be proved within allowed proof spans. No group dependencies or sibling imports.

## Risks

Array flattening and assertS/atomic refinement need constructive proofs and may require local sublemmas. Their difficulty is not a blocker. Concrete quiescence filtering must preserve queue map and every survivor's pending fields. The formal byte view does not encode malloc provenance beyond the already adopted allocator API; this is an existing boundary, not a new assumption. No source/config/spec or canonical formal files were edited. Only Show insertions were made in the allowed debug copy. No VC has been proved by this checking task.
