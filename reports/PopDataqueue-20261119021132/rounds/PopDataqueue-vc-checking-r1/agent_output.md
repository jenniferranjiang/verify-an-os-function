# PopDataqueue VC checking r1

## Outcome

No determined structural countermodel found. The current 14 manual top-level VCs and 9 generated split goals are covered by four groups. This is a proofability/grouping review, not an implementation proof or final-check result. No canonical or debug source was edited; no compiler/debug/MCP command was needed for this structural and mathematical analysis.

## Structural Blocker Scan

Scanned every top-level VC, prioritizing no-split goals. Both observation VCs retain safeExec and the corresponding RTrans observation bridge. First-stage field values are linked to q_id; second-stage fields are linked to the new observed q (no invalid cross-lock equality between q_id and q). The first unlock restores q_id, and the second unlock has mutually exclusive empty/nonempty resource branches. The nonempty branch receives a wand accepting store_dataqueue(pop q), while the empty branch accepts the original q. Each branch owns one remaining map frame, not two copies. Front arithmetic carries positive bounded max_len; array reads carry ready and nonempty. Updated output cells are kept in the item branch; original option slots are kept in the empty/failure branches. Callee-result continuations explicitly quantify the returned state/status, and output witnesses align with those bridges. No unsupported current/@pre or field-address bridge was found.

## Annotation Comparison Review

Handoff contains no previous VC comparisons. The current added ready, bounds and map facts are not assumed axioms: entail_wit_1 and entail_wit_4 must establish them from the current os_inv plus assertS observation. entail_wit_4 also establishes the update restoration wand, including ready preservation. which_implies_wit_3 must establish front-slot initialization; its Prop obligation in the global library is not a proved fact. entail_wit_2 and entail_wit_5_* establish the actual callee-continuation bridges. The named continuation extraction is used only through its current definitions; no skipped behavior or extra premise is introduced by naming the subterms.

## Split-first decisions (manual declaration order)

All split-goal binary judgments were completed before top-level mode selection:

- entail_wit_3_split_goal_1: provable from return continuation and retval=0.
- return_wit_3_split_goal_1: provable from return continuation and retval<>0 selecting Failed.
- which_implies_wit_1_split_goal_1: provable (alignment from store_dataqueue).
- which_implies_wit_1_split_goal_2: provable (nonzero from store_dataqueue).
- which_implies_wit_1_split_goal_spatial: provable (complete fields/padding/buffer unfolding).
- which_implies_wit_2_split_goal_1: provable (same alignment at second observation).
- which_implies_wit_2_split_goal_2: provable (same nonzero fact).
- which_implies_wit_2_split_goal_spatial: provable (same exact fields/padding/buffer).
- which_implies_wit_4_split_goal_spatial: provable (Some slot and existing DataElem ABI).

## Proof-Mode Decisions

In manual top-level order: entail_wit_1 LLM; entail_wit_2 LLM; entail_wit_3 aggressive; entail_wit_4 LLM; entail_wit_5_1 LLM; entail_wit_5_2 LLM; return_wit_1 LLM; return_wit_2 LLM; return_wit_3 aggressive; which_implies_wit_1 aggressive; which_implies_wit_2 aggressive; which_implies_wit_3 LLM; which_implies_wit_4 aggressive; which_implies_wit_5 LLM. Thus 5 aggressive and 9 whole-goal LLM routes. All split blocks under aggressive parents are required.

## Common Proof Patterns

1. Observation: unfold the first assertS, instantiate LastSeen through RTrans, preserve os_inv while extracting its pure existential, then split/merge store_map. This must establish ownership, not infer it from lookup alone.
2. View/rebuild: preserve explicit padding and opaque unrelated frame, substitute field equalities, and normalize only ABI/sizeof terms needed to fold exact queue/slot predicates. Keep None output cells as unknown ownership.
3. Call transition: construct the actual abstract atomic step, advance safeExec through bind, and choose the existential callee postcondition from the remaining continuation. The universal bridge must hold at arbitrary callee-return st/status. Failure selects Failed without further work; successful ring stage still performs Abandon regardless of empty/item result.
4. Map update: from ready/nonempty prove pop preserves initialized FIFO tail; semaphore IDs and all slots remain unchanged. Split once, construct the new map invariant by key equality, and use one update wand. No standalone helpers are planned because the case-lib policy is absent; necessary auxiliary assertions must be proved within assigned spans.

## VC Deltas

entail_wit_1 is readonly focus at the first observation. entail_wit_4 adds the genuinely new mutable focus/ready-preservation obligation. entail_wit_2 refines the ID-read atomic stage and chooses Obtain continuation. entail_wit_5_1 rebuilds the changed front with 16-bit modulo normalization and returns Item; entail_wit_5_2 uses unchanged state and Empty. which_implies_wit_1/2 are identical field patterns at distinct observations; wit_3 is the nonempty FIFO-head and array wand; wit_4 is slot-to-fields ABI; wit_5 forgets optional outputs before writes. The return group only consumes established continuation bridges and result/output equalities.

## Grouping Decisions

map_updates (2 top-level, difficulty5) keeps both map-focus contexts together and puts the new ready-preservation risk first. call_transitions (3 top-level, difficulty5) shares atomic/bind/callee-continuation semantics, with distinct ID, item and empty transitions. resource_views (5 top-level, 7 splits, difficulty4) shares queue/slot/array ownership and ABI normalization; the nonempty FIFO-head is its largest obligation. returns (4 top-level, 2 splits, difficulty2) is independent final-result projection. These are independent groups, all below the 12-witness hard bound. No sibling dependencies or helper declarations are planned.

## Risks or Blockers

No determined blocker. High-risk work remains real proof work: modular count/tail preservation for pop-ready; store_map update-wand construction; safeExec atomic/bind decomposition with existential continuation. These are not granted by the successful dependency build or by the named Prop obligations. All original imported-contract/model boundaries and implementation-closure limitations remain unchanged.
