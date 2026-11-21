# Outcome
Current structural review finds no definite annotation/spec countermodel. Plan covers 36 top-level VCs in 10 groups: 21 aggressive, 15 whole. This is proof planning, not implementation proof completion. Exact controller coq-debug with Show-only overlay exited 0 and status passed; it loaded all current goal/manual declarations. Canonical files remain unchanged.

# Structural Blocker Scan
Scanned all top-level goals, no-split whole goals first. Resource addresses match field cells/wands and current task/sem bridges. The descriptor existential in entail8 is backed by admissibility plus os_inv; entail10 by the callee transition; entail11 has a residual-frame construction; entail14 continuation exists by safeExec bind decomposition; entail16 is backed by the continuation status assertion at the rely-reached state. No unconnected @pre/current address was found.

# Annotation Comparison Review
The current entail8 consequent no longer asks task<>0 before suspension. The existing lookup/exstatus-update wand and future-delay universal remain required. The related entail9 establishes the clear-status call precondition and preserves future-delay. Entail10 still requires nonzero, but its antecedent now includes successful linklist_suspend_prio; flag1 excludes the invalid branch and ktask_suspend_step supplies nonzero. Thus the reported old pure gap is resolved without introducing an entry nonzero assumption. Full exstatus invariant reconstruction remains real proof work.

# Proof-Mode Decisions
Split judgments below were completed before whole-goal mode selection. Names abbreviated by removing proof_of__SemaphoreObtain_. P means semantically provable; N means missing invariant-derived premises in the isolated pure split.
- entail_wit_1_1_split_goal_1: P
- entail_wit_1_1_split_goal_2: P
- entail_wit_1_2_split_goal_1: P
- entail_wit_1_2_split_goal_2: P
- entail_wit_1_3_split_goal_1: P
- entail_wit_1_3_split_goal_2: P
- entail_wit_1_3_split_goal_3: P
- entail_wit_3_1_split_goal_1: P
- entail_wit_3_1_split_goal_2: P
- entail_wit_3_1_split_goal_spatial: P
- entail_wit_3_2_split_goal_1: P
- entail_wit_3_2_split_goal_2: P
- entail_wit_3_2_split_goal_spatial: P
- entail_wit_5_split_goal_1: P
- entail_wit_5_split_goal_2: P
- entail_wit_5_split_goal_spatial: P
- entail_wit_6_split_goal_1: P
- entail_wit_6_split_goal_2: P
- entail_wit_7_split_goal_1: N
- entail_wit_7_split_goal_2: N
- entail_wit_9_split_goal_1: P
- entail_wit_9_split_goal_2: P
- entail_wit_9_split_goal_3: P
- entail_wit_9_split_goal_spatial: P
- entail_wit_12_1_split_goal_1: P
- entail_wit_12_1_split_goal_spatial: P
- entail_wit_12_2_split_goal_1: P
- entail_wit_12_2_split_goal_spatial: P
- entail_wit_13_1_split_goal_1: N
- entail_wit_13_1_split_goal_2: N
- entail_wit_13_2_split_goal_1: N
- entail_wit_13_2_split_goal_2: N
- entail_wit_15_split_goal_1: P
- entail_wit_17_split_goal_1: P
- entail_wit_17_split_goal_2: P
- entail_wit_17_split_goal_spatial: P
- return_wit_6_split_goal_1: P
- return_wit_7_split_goal_1: P
- return_wit_8_split_goal_1: P
- partial_solve_wit_19_pure_split_goal_1: P
- which_implies_wit_1_split_goal_spatial: P
- which_implies_wit_2_split_goal_spatial: P
- which_implies_wit_3_split_goal_spatial: P
- which_implies_wit_6_split_goal_spatial: P
- which_implies_wit_7_split_goal_spatial: P
- which_implies_wit_8_split_goal_spatial: P
- which_implies_wit_11_split_goal_spatial: P

Whole modes: all ten no-split goals; entail7 and entail13_1/13_2 retain os_inv facts lost by their pure splits. All others with splits use aggressive mode except entail12_1/12_2. Their four split goals are P. Per explicit main handoff, these two use whole mode to resolve the already diagnosed composition mismatch: aggressive processing strips the known global-context andp wrapper whereas generated splits retain it. This is a composition-driven exception, not a semantic unprovability claim; the unchanged complete witnesses still require Qed and full checks. No tool/skill change is proposed.

# Common Proof Patterns
Borrow/restore: focus a module/store_map entry, expose the exact typed cell, construct or consume its wand, frame every unrelated module including dataqueue. Pure transition: preserve os_inv long enough to extract consistency facts, then specialize safeExec with the actual rely state, branch guards and concrete transition; return precisely the actual abstract state. Continuation: decompose bind at the scheduling call; use the carried continuation after imported assign and the subsequent protected status read. No case-lib exists, so no new helper is planned.

# VC Deltas
- entail_wit_7: Keep os_inv spatially while extracting its global context/world facts. Specialize safeExec of abs_semaphore_obtain at the rely-reached held state, select original by ID and zero value/nonzero wait, and extract semaphore_obtain_entry: admissibility and universally quantified future-delay obligation. Preserve all resources and pure guards; do not try the resource-free split route.
- entail_wit_8: From os_inv assign/task-map consistency and linklist_suspend_admissible obtain a descriptor for running task. Select that desc, split its store_map entry, borrow tdExstatus as Int, and construct the wand for writing zero. Reassemble TaskInv/store_map and all os_inv conjuncts at semaphore_clear_status; retain scheduler ownership, ID manager, delay and dataqueue frames. Only exstatus changes. No task<>0 premise is available or required here. Preserve future-delay universal premise literally.
- entail_wit_9: Clear exstatus only; simplify task-map update at task and preserve scheduler/status/owner fields, transferring admissibility from held to semaphore_clear_status. semaphore_clear_status preserves semaphore list, choose original and supplied map sched_link_node pending list in semaphore_pending_nodes. Re-use exact universally quantified future-delay premise after rewriting task=running task. Apply exstatus-zero restoration wand, frame critical token.
- entail_wit_10: Choose suspended=after and the descriptor supplied by linklist_suspend_prio. Unfold successful flag-1 relation through linklist_suspend_step and ktask_suspend_step to obtain task<>0 and suspended status/map lookup. Instantiate the carried future-delay universal premise with original desc, after and sd; rewrite task and sem equalities. Cancel unchanged os_inv after and InsideCritical held.
- which_implies_wit_7: Open assign component, borrow Assign.os_running_task pointer, construct same-value wand for os_inv held.
- which_implies_wit_8: Use task equality, then apply same-running-pointer restoration wand.
- entail_wit_11: Split os_inv suspended into task delay-pointer cell, delay_inv, tick_inv and residual Assertion frame. Instantiate delay_frame with every remaining resource plus the residual task-map entry and invariant pure facts. For each ktask_set_delay_step result, reconstruct task-map descriptor with updated delay pointer, delay/tick components and unchanged other modules; prove the universally quantified restoration entailment. Branch on carried future-delay disjunction, preserving window and os_global_context wrapper. Do not invent inactive_map(0) membership.
- entail_wit_4: Restore the found ID-manager view and its wand; use semaphore invariant list/ID correspondence to select original with matching id-node address. Obtain value bounds from the UShort resource, membership and nonzero from the semaphore invariant. Return the same held os_inv and InsideCritical, preserving entry safeExec.
- which_implies_wit_3: Open semaphore component of os_inv, expose store_idmanager and construct its exact restoration wand, retaining remaining global resources.
- which_implies_wit_4: Use original membership and os_inv semaphore list ownership to focus its value cell. Extract UShort bounds and split value=0 versus value>0. Zero branch returns same-value wand; positive branch constructs wand updating semaphore_set_value and replace_semaphores, preserving all unrelated list/map/global resources including dataqueue. Reestablish semaphore uniqueness and range after decrement.
- which_implies_wit_6: Substitute sem_value=0 and apply the exact same-value wand.
- entail_wit_12_1: Whole-goal composition route: destruct ktask_set_delay_step and retval<>0 to isolate failure, derive retval=-5, delay_after=0 and st_after=suspended. Specialize the carried restoration derivable1 at this exact transition, weaken andp(coq_prop(os_global_context sg),delay_frame) to delay_frame and reassociate resources; restore os_inv suspended while framing InsideCritical held. Retain failure step and all requested facts. Splits are semantically provable but aggressive wrapper normalization prevents mandated split composition; whole route must prove the full unchanged witness.
- entail_wit_12_2: Whole-goal composition route: destruct ktask_set_delay_step and retval<>0 to isolate failure, derive retval=-5, delay_after=0 and st_after=suspended. Specialize the carried restoration derivable1 at this exact transition, weaken andp(coq_prop(os_global_context sg),delay_frame) to delay_frame and reassociate resources; restore os_inv suspended while framing InsideCritical held. Retain failure step and all requested facts. Splits are semantically provable but aggressive wrapper normalization prevents mandated split composition; whole route must prove the full unchanged witness.
- entail_wit_13_1: Retain os_inv after to obtain task ID uniqueness/global context. The two successful ID lookups identify task_2 with task; map lookup injectivity identifies desc_2 with sd. Contradict not-suspended versus sd suspended, closing entire branch. Pure splits omit invariant facts needed for this identity.
- entail_wit_13_2: Choose after_wakeup=after. From os_inv after and wakeup transition preservation recover suspended ID uniqueness and identify task_2=task, desc_2=sd. Compose clear-status, prio suspend, delay allocation failure and actual wakeup transition into abs_semaphore_obtain locked result inl(-5), then specialize entry safeExec via rely before->held. Obtain Crtos_GTrans held after and ret(-5); cancel os_inv after and held token. No independent rollback axiom.
- which_implies_wit_10: Use task_desc_map lookup and os_inv ID-manager correspondence/uniqueness to choose rollback_id=tdId of sd. Borrow nested id.id UShort, obtain 0<=id<65536 and get_task_with_idnode_success for this exact task, and construct same-value restoration wand; retain every unrelated frame.
- which_implies_wit_11: Apply rollback-ID cell same-value wand to restore os_inv suspended.
- entail_wit_14_1: Select prepared=st_after and restore os_inv using the universal delay-frame entailment and successful ktask_set_delay_step; retain InsideCritical held. Compose clear-status, prio suspension and optional successful delay step into the locked inr(task) transition of abs_semaphore_obtain. Specialize entry safeExec through rely before->held, then use bind decomposition for abs_ktask_assign to obtain existential continuation Y and its ret(tt)->semaphore_obtain_after_assign implication. Show Crtos_GTrans held prepared. Select actual transition state, not an arbitrary poststate.
- entail_wit_14_2: Select prepared=st_after and restore os_inv using the universal delay-frame entailment and successful ktask_set_delay_step; retain InsideCritical held. Compose clear-status, prio suspension and optional successful delay step into the locked inr(task) transition of abs_semaphore_obtain. Specialize entry safeExec through rely before->held, then use bind decomposition for abs_ktask_assign to obtain existential continuation Y and its ret(tt)->semaphore_obtain_after_assign implication. Show Crtos_GTrans held prepared. Select actual transition state, not an arbitrary poststate.
- entail_wit_14_3: Select prepared=suspended; wait<=0, wait<>0 and -1<=wait force wait=-1, so no delay step. Preserve existing os_inv suspended and held token. Compose clear-status, prio suspension and optional successful delay step into the locked inr(task) transition of abs_semaphore_obtain. Specialize entry safeExec through rely before->held, then use bind decomposition for abs_ktask_assign to obtain existential continuation Y and its ret(tt)->semaphore_obtain_after_assign implication. Show Crtos_GTrans held prepared. Select actual transition state, not an arbitrary poststate.
- entail_wit_15: Apply carried continuation implication at after to safeExec ret(tt) Y.
- entail_wit_16: Choose observed=st_lock. Specialize semaphore_obtain_after_assign safeExec along Crtos_RTrans scheduled st_lock; its status assertion supplies a descriptor lookup for task. Extract that task-map entry from os_inv and borrow exstatus with same-value restoration wand. Preserve the critical token and rely bridge; do not use running-task identity in the new state as a substitute for the specified original task.
- entail_wit_17: Crtos_GTrans reflexivity. Unfold after-assign status assertion and atomic observation; use rely scheduled->observed plus task map lookup to select exstatus read, obtaining safeExec ret(exstatus). Apply same-exstatus restoration wand; frame held token.
- entail_wit_1_1: Unfold KTICK_HALF_RANGE; numeric positive bound. Unfold semaphore_wait_ticks at zero; select zero branch by arithmetic.
- entail_wit_1_2: Unfold KTICK_HALF_RANGE; prove -1 below bound. Unfold semaphore_wait_ticks at -1 and select infinite branch.
- entail_wit_1_3: Use msec positive and <=INT_MAX, tick_from_time_ms divisor100Hz/1000 bounds to show retval<KTICK_HALF_RANGE. Normalize signed_last_nbits using signed32 range. Same tick bounds imply retval>=0; signed32 normalization yields requested lower bound. Use retval=tick_from_time_ms msec and msec>0 to select semaphore_wait_ticks finite branch, normalize signed32 conversion.
- which_implies_wit_1: Use existing Int/store_integer representation equivalence at 4-byte alignment; supplied signed bounds agree. No new ABI assumption.
- which_implies_wit_2: Reverse same store_integer/Int representation equivalence; same address/value.
- entail_wit_3_1: Crtos_GTrans reflexivity, preserve resources. Restore manager view via wand; os_global_context fixes nonnull manager address, contradict null manager branch. Reassociate manager resource and its restoration wand; apply wand and frame held token.
- entail_wit_3_2: Crtos_GTrans reflexivity. Restore os_inv from manager wand; ID query false identifies absent semaphore lookup. Specialize abs_semaphore_obtain safeExec at rely-reached held state and its missing-ID return -1. Apply manager restoration wand and frame held token.
- entail_wit_5: Use positive value update transition to derive Crtos_GTrans held (replace_semaphores ... held); retain resource frame. Specialize safeExec via rely and positive semaphore lookup, choose replacement state and locked inl0 branch; restore os_inv through new-value wand as needed. Rewrite retval=semaphore_addr original, apply decremented-value wand and frame token.
- entail_wit_6: Crtos_GTrans reflexivity. Select zero-value/zero-wait immediate -2 branch in abs_semaphore_obtain using original membership and id equality; specialize safeExec at held via rely.
- partial_solve_wit_19_pure: Unfold semaphore_pending_head to the exact field-address expression; reflexivity and pure-right, framing all locals and os_inv.
- return_wit_6: Select invalid negative timeout branch using msec<0 and msec<>-1; abs_semaphore_obtain reduces to ret(-1), preserving before.
- return_wit_7: Select invalid id<0 branch; specialize original safeExec to unchanged ret(-1).
- return_wit_8: Select id>65535 invalid branch; specialize original safeExec to unchanged ret(-1).

# Grouping Decisions
task_prepare is first and contains comparison current entail8 together with establishing/consuming related obligations. The residual delay frame is a single independent heavy resource transformation. Rollback identity and schedule continuation are separated from immediate branches and final observation to avoid an oversized tail. Every group has at most six top-level witnesses (hard maximum twelve); no sibling dependencies or helper ownership are introduced.

# Risks or Blockers
No definitive blocker. Highest risks are exstatus update preserving all os_inv ownership invariants, delay residual-frame reassembly, rollback ID identity across wakeup, and safeExec scheduling bind construction. These are assigned concrete proof obligations rather than declared done. Generated native auto remains separate and unmodified.
