# Outcome
Current map-based generated goals checked; plan covers all 62 top-level obligations. Prescribed coq-debug passed (exit0/status passed, 25.34s), checking current imports/types and debug-copy boundaries. This is not an implementation proof.

# Structural blocker scan
Reviewed all whole goals first. No definite current/pre pointer or scalar bridge loss found: concrete fields and p_queue_pre identify one object, max_len UShort retains NodeNumber bounds, cleanup cuts retain q/refs/Y and the universal return bridge. Publication must choose entail_wit_1 left alternative and produce a new after-state; the right alternative asking for pre-publication after_3 lookup is not a valid route. The required map absence is obtainable by conflicting private/shared front-field ownership, not by assuming freshness. Layout size/offset connection now available as the authorized dataqueue_layout_abi. No unproved obligation Prop is treated as a theorem.

# Annotation comparison review
No comparisons supplied for this initial attempt. Actual establishing VCs are the two which-implies resource views, publication entail1, and all four cleanup entail2 paths. Return and call-frame VCs consume facts those cuts must prove; they do not independently establish the cuts.

# Split-first decisions (manual order)
All six splits were assessed before whole-goal mode assignment:
- safety_wit_12_split_goal_1: provable, UShort bound implies upper signed bound for n-1.
- safety_wit_12_split_goal_2: provable, UShort nonnegativity implies lower signed bound.
- which_implies_wit_1_split_goal_1: provable, DataqueueStorage alignment projection.
- which_implies_wit_1_split_goal_2: provable, DataqueueStorage nonzero projection.
- which_implies_wit_1_split_goal_spatial: provable, Storage definition plus authorized size20.
- which_implies_wit_2_split_goal_spatial: provable via concrete zero-byte encodings and ABI offsets, retaining padding; substantive byte-to-typed-store proof remains required.
Thus exactly these three parents use aggressive_pre_process. All remaining 59 top-level goals are judged provable whole-goal and use LLM_pre_process. These are proofability judgments, not checked proofs.

# Common proof patterns
Constant safety uses machine limits; impossible branch safety uses contradictory explicit guards. safety12 extracts typed-store bounds. Frame goals retain identical resource multisets and project already-given pure assumptions. Return goals instantiate existing final state and retired q, compute retired ID branches and apply the supplied continuation bridge. Storage views split bytes at real ABI offsets. Publication folds owned fields/array, proves map absence through separation, inserts a cell, proves sem distinctness from actual create effects and refines the observed init phase. Cleanup selects the actual failure variant and bind continuation, keeping object storage private.

# VC deltas
Current DataQueueAbs has no self-address, all object memory is store_dataqueue p q, publication is map lookup. entail1 must prove M p=None before insertion. Cleanup None guard belongs to its safeExec continuation. entail2_1/2 are allocation-failure (positive/zero size), entail2_3 first-create failure, entail2_4 second-create failure. return1/2/3 correspond respectively to blank>=0/data=-5, blank=-5/data=-1, both=-1; return4 is success. Per-witness strategies specify witnesses and facts; no helper is planned because formal_case_lib is absent.

# Grouping decisions
14 independent groups, 1–6 top-level goals each. Publication is one independent high-risk state transition; the two allocation failures share cleanup folding, two create failures share phase/ref continuation context. Storage views and final returns are separate from transition work. Safety and pure call frames are split into bounded coherent batches. No group depends on sibling output. All split goals stay with parent.

# Risks
Heavy byte/array conversion, finite-map publication, sem freshness, and safeExec bind/atomic refinement remain constructive obligations. The general zero-byte view quantifies arbitrary p; workers must use actual memory lemmas, not silently assume alignment. Any concrete missing premise found in proof must return through workflow. Known ABI authorization supplies only layout; it proves no resources. No definite whole-goal countermodel identified during this check.
