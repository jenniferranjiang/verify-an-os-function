# Outcome

VC analysis completed for 62 top-level obligations; this is a proof plan, not an implementation proof. No concrete structural countermodel was found. The prescribed coq-debug initially failed because VCPrelude was outside project mappings; main repaired root build/editor mappings, and the same command passed (28.04 seconds). Only one Show was inserted into the authorized debug copy. Canonical formal/C files were not modified.

# Structural Blocker Scan

All whole goals were scanned before split analysis. Pointer/scalar @pre bridges, saved lock binding, queue object and refs remain present. Success entail_wit_1 must use its left, spatial publication alternative: the right pure fallback incorrectly expects the queue already in after_3 and is not used. Failure assertions retain exact q and references plus Y and its universal final-to-X bridge, so the continuation is not introduced as a trusted premise. Generated promoted safety/partial_solve witnesses are real obligations; their binder/import shape was accepted by the prescribed Coq command, whose admitted seed remains unproved.

# Annotation Comparison Review

The handoff comparison list is empty (initial attempt). Independently inspected assertion responsibility: entail_wit_1 establishes success publication; entail_wit_2_1 through _2_4 establish failure object folding, cleanup continuation and GTrans. Subsequent partial_solve witnesses merely retain those facts, and return witnesses consume them. The DataqueueStorage and memset views have separate which_implies witnesses; none is assumed proved.

# Proof-Mode Decisions

Strict split-first decisions, in manual declaration order: safety_wit_12_split_goal_1 and _2 are provable from UShort scalar ownership bounds. which_implies_wit_1_split_goal_1 (alignment), _2 (nonzero), and _spatial are provable by unfolding DataqueueStorage and actual sizeof. which_implies_wit_2_split_goal_spatial is provable by the ILP32 little-endian field layout and zero-byte splitting, preserving padding. Thus these three parents use aggressive_pre_process. After all split decisions, all other 59 top-level goals were analyzed as whole goals and use LLM_pre_process. The transition entailments need substantial constructive proofs but no identified missing premise; difficulty is not a blocker.

# Common Proof Patterns

S: constant integer bounds or contradictory branch return facts, framing all resources. safety12 additionally extracts unsigned-short bounds from ownership.
P: reintroduce existing pure facts, reorder/cancel identical resources; implication-valued partial_solve goals introduce their pure-witness argument. No state change or fresh witness is needed.
T-success: fold exact local queue storage and n unknown slots, combine two fresh semaphore create effects, publish queue into dataqueue_inv, preserve all other os_inv components, and consume the actual atomic phase of safeExec.
T-cleanup: fold the partially initialized queue, reconstruct the actual phase attempt and its same refs, and obtain the deinit continuation from original safeExec bind; do not independently assume cleanup-entry properties.
R: use dataqueue_retired object and actual post-cleanup state, apply the universal continuation bridge, and select the observed sentinel/error-code branch; success directly retains the published q.
Layout: unfold storage, split bytes by actual offsets, convert zero encodings and retain [6,8) padding.

# VC Deltas

Safety1-8 and 13-15/18-20/23-29 only constrain constants. Safety9-11 contradict malloc branches; 16-17 and 21-22 contradict return sign branches. Partial_solve1-7 frame initialization/create; 8 is success unlock; 9-11 are three failure unlock frames; 12-14 are the matching cleanup call frames (their _pure forms prove existing premises). Entail2_1 and 2_2 distinguish positive/zero allocation size; 2_3 is first create failure; 2_4 retains the successful first ID after second-create failure. Return1/2/3 use retired ID pairs (-1,-5),(-5,-1),(-1,-1), respectively; return4 chooses the whole success alternative.

# Grouping Decisions

16 independent groups, each at most six top-level witnesses. Publication is a singleton because it owns the independent heavy invariant-publication/refinement route. Allocation failure and create failure are separate coherent transitions; final results are separate from transitions. Layout views are independent from transitions. Constant and unchanged-call-frame groups are split by program stage to avoid long tail groups. No helpers are planned because formal_case_lib policy is absent. The detailed per-witness executable strategies are in group_plan.json; no sibling proof dependency is introduced. The high-risk transitions are dispatched first.

# Risks

Publication and both cleanup transition groups require nontrivial byte-array folding and safeExec bind proofs. Every dataqueue_*_obligation is merely a Prop definition, not a proven lemma. Existing global layout axioms/interfaces must be checked and used only within approved TrustBase; new axioms or layout assumptions are forbidden. If actual ABI interface cannot derive the required equalities, return a precise dependency gap instead of assuming dataqueue_layout. Reused ID/DLL contracts and trusted IRQ/allocator boundaries remain assumptions, not completed body proofs. The coq-debug pass only checks generated types and seed loading.
