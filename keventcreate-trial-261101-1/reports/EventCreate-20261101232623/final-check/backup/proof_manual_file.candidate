Require Import Coq.ZArith.ZArith.
Require Import Coq.Bool.Bool.
Require Import Coq.Strings.String.
Require Import Coq.Strings.Ascii.
Require Import Coq.Lists.List.
Require Import Coq.Classes.RelationClasses.
Require Import Coq.Classes.Morphisms.
Require Import Coq.micromega.Psatz.
Require Import Coq.Sorting.Permutation.
From AUXLib Require Import int_auto Axioms Feq Idents ListLib VMap.
Require Import SetsClass.SetsClass. Import SetsNotation.
From SimpleC.SL Require Import Mem SeparationLogic.
From CRTOS_Verify.VC Require Import EventCreate_goal.
From CRTOS_Verify.VC Require Import EventCreate_proof_auto.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.lib.KEventCreate.
Require Import CRTOS_Verify.lib.DoubleLinkListSpec.
Require Import CRTOS_Verify.lib.KTaskWakeup.
Import DLL IDNode.
From MonadLib.MonadErr
      Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.VC.EventCreate_lib.
Local Open Scope sac.


Lemma proof_of__EventCreate_safety_wit_1 : _EventCreate_safety_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_safety_wit_2 : _EventCreate_safety_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_safety_wit_3 : _EventCreate_safety_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_safety_wit_4 : _EventCreate_safety_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_safety_wit_5 : _EventCreate_safety_wit_5.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_safety_wit_6 : _EventCreate_safety_wit_6.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_safety_wit_7 : _EventCreate_safety_wit_7.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_safety_wit_8 : _EventCreate_safety_wit_8.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_safety_wit_9 : _EventCreate_safety_wit_9.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_safety_wit_10 : _EventCreate_safety_wit_10.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_safety_wit_11 : _EventCreate_safety_wit_11.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_safety_wit_12 : _EventCreate_safety_wit_12.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_safety_wit_13 : _EventCreate_safety_wit_13.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_safety_wit_14 : _EventCreate_safety_wit_14.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  pose proof (PreH2 PreH7) as Hrange.
  split_pures.
  dump_pre_spatial. lia.
Qed. 

Lemma proof_of__EventCreate_safety_wit_15 : _EventCreate_safety_wit_15.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_safety_wit_16 : _EventCreate_safety_wit_16.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_entail_wit_1 : _EventCreate_entail_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  prop_apply_p (store_uint_range (&("options")) options_pre).
  Intros_p Hrange.
  change (0 <= options_pre <= 4294967295) in Hrange.
  split_pure_spatial.
  - cancel ((&("options")) # UInt |-> options_pre).
    cancel (OutsideCritical sg_outside_critical before_outside_critical).
  - split_pures; dump_pre_spatial; try assumption; int_auto.
Qed. 

Lemma proof_of__EventCreate_return_wit_1 : _EventCreate_return_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Exists (replace_events (event_publish retval_2 retval options_pre (os_events st_lock)) st_lock).
  split_pure_spatial.
  - cancel (OutsideCritical sg_outside_critical (replace_events (event_publish retval_2 retval options_pre (os_events st_lock)) st_lock)).
  - split_pures; dump_pre_spatial; assumption.
Qed. 

Lemma proof_of__EventCreate_return_wit_2 : _EventCreate_return_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Exists st_lock.
  split_pure_spatial.
  - cancel (OutsideCritical sg_outside_critical st_lock).
  - split_pures; dump_pre_spatial; auto.
Qed. 

Lemma proof_of__EventCreate_partial_solve_wit_1_pure : _EventCreate_partial_solve_wit_1_pure.
Proof.
  LLM_pre_process ltac:(lia). pose proof EventLayoutABI.event_size_axiom as Hsz. change (sizeof_alias_type "Event" = EVENT_MEM_SIZE) in Hsz. cbn [sizeof_front_end_type sizeof_front_end_type_of_ptr_size]. rewrite Hsz. unfold EVENT_MEM_SIZE. split_pures; dump_pre_spatial; lia.
Qed.

Lemma proof_of__EventCreate_partial_solve_wit_1 : _EventCreate_partial_solve_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _EventCreate_partial_solve_wit_1_aux.
  intros.
  pose proof EventLayoutABI.event_size_axiom as Hsize.
  change (sizeof("Event") = 36) in Hsize.
  rewrite Hsize in *.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; try assumption; try lia; try int_auto.
Qed. 

Lemma proof_of__EventCreate_partial_solve_wit_2_pure : _EventCreate_partial_solve_wit_2_pure.
Proof.
  LLM_pre_process ltac:(lia). pose proof EventLayoutABI.event_size_axiom as Hsz. change (sizeof_alias_type "Event" = EVENT_MEM_SIZE) in Hsz. cbn [sizeof_front_end_type sizeof_front_end_type_of_ptr_size]. rewrite Hsz. unfold EVENT_MEM_SIZE. split_pures; dump_pre_spatial; lia.
Qed.

Lemma proof_of__EventCreate_partial_solve_wit_2 : _EventCreate_partial_solve_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _EventCreate_partial_solve_wit_2_aux.
  intros.
  pose proof EventLayoutABI.event_size_axiom as Hsize.
  change (sizeof("Event") = 36) in Hsize.
  rewrite Hsize in *.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; try assumption; try lia; try int_auto.
Qed. 

Lemma proof_of__EventCreate_partial_solve_wit_3_pure : _EventCreate_partial_solve_wit_3_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_partial_solve_wit_3 : _EventCreate_partial_solve_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _EventCreate_partial_solve_wit_3_aux.
  intros.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; try assumption; try lia; try int_auto.
Qed. 

Lemma proof_of__EventCreate_partial_solve_wit_4 : _EventCreate_partial_solve_wit_4.
Proof.
  LLM_pre_process ltac:(assumption || lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_partial_solve_wit_5 : _EventCreate_partial_solve_wit_5.
Proof.
  LLM_pre_process ltac:(assumption || lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_partial_solve_wit_6 : _EventCreate_partial_solve_wit_6.
Proof.
  LLM_pre_process ltac:(assumption || lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_partial_solve_wit_7_pure : _EventCreate_partial_solve_wit_7_pure.
Proof.
  LLM_pre_process ltac:(assumption || lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_partial_solve_wit_7 : _EventCreate_partial_solve_wit_7.
Proof.
  LLM_pre_process ltac:(assumption || lia || int_auto).
  unfold _EventCreate_partial_solve_wit_7_aux.
  LLM_pre_process ltac:(assumption || lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_partial_solve_wit_8_pure : _EventCreate_partial_solve_wit_8_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_partial_solve_wit_8 : _EventCreate_partial_solve_wit_8.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _EventCreate_partial_solve_wit_8_aux. intros.
  split_pure_spatial.
  - cancel (InsideCritical sg_outside_critical st_lock).
    cancel (os_inv sg_outside_critical st_lock).
    cancel (EventRaw retval).
  - split_pures; dump_pre_spatial; assumption.
Qed. 

Lemma proof_of__EventCreate_partial_solve_wit_9 : _EventCreate_partial_solve_wit_9.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_partial_solve_wit_10 : _EventCreate_partial_solve_wit_10.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_partial_solve_wit_11 : _EventCreate_partial_solve_wit_11.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_partial_solve_wit_12_pure : _EventCreate_partial_solve_wit_12_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_partial_solve_wit_12 : _EventCreate_partial_solve_wit_12.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _EventCreate_partial_solve_wit_12_aux. intros.
  split_pure_spatial.
  - cancel.
    cancel (store_node_self_linked &(retval # "Event" ->ₛ "pend_list")).
    cancel (event_create_frame sg_outside_critical st_lock).
    cancel (store_dll (store_event (pure_suspend_sched_link (task_desc_map (os_tasks st_lock)))) &("k_event_list") (map event_link_node (os_events st_lock))).
    cancel (EventPadding retval).
    cancel (NodeZero &(retval # "Event" ->ₛ "link")).
    cancel (&(retval # "Event" ->ₛ "options") # UInt |-> Z.land options_pre 7).
    cancel (&(retval # "Event" ->ₛ "events") # UInt |-> 0).
    cancel.
  - split_pures; dump_pre_spatial; auto.
Qed. 

Lemma proof_of__EventCreate_partial_solve_wit_13 : _EventCreate_partial_solve_wit_13.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _EventCreate_partial_solve_wit_13_aux. intros.
  split_pure_spatial.
  - cancel (store_dll (store_event (pure_suspend_sched_link (task_desc_map (os_tasks st_lock)))) &("k_event_list") (map event_link_node (os_events st_lock))).
    cancel.
  - split_pures; dump_pre_spatial; auto; unfold dll_insert_anchor; auto.
Qed. 

Lemma proof_of__EventCreate_partial_solve_wit_14_pure : _EventCreate_partial_solve_wit_14_pure.
Proof.
  LLM_pre_process ltac:(assumption || lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_partial_solve_wit_14 : _EventCreate_partial_solve_wit_14.
Proof.
  LLM_pre_process ltac:(assumption || lia || int_auto).
  unfold _EventCreate_partial_solve_wit_14_aux.
  intros.
  split_pure_spatial.
  - cancel.
    cancel (event_create_frame sg_outside_critical st_lock).
    match goal with |- ?P ** ?Q |-- _ => cancel P end.
    match goal with |- ?P |-- ?P => cancel P end.
  - split_pures; dump_pre_spatial; assumption.
Qed. 

Lemma proof_of__EventCreate_partial_solve_wit_15_pure : _EventCreate_partial_solve_wit_15_pure.
Proof.
  LLM_pre_process ltac:(assumption || lia || int_auto).
Qed. 

Lemma proof_of__EventCreate_partial_solve_wit_15 : _EventCreate_partial_solve_wit_15.
Proof.
  LLM_pre_process ltac:(assumption || lia || int_auto).
  unfold _EventCreate_partial_solve_wit_15_aux.
  intros.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed. 

Lemma proof_of__EventCreate_entail_wit_2_1 : _EventCreate_entail_wit_2_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Left. prop_apply_p (store_int_range (&("lock")) retval_3). Intros_p Hlock.
  split_pure_spatial; [cancel | split_pures; dump_pre_spatial; try assumption; try int_auto; try lia].
  - unfold idmanager_min_free_id in H. tauto.
  - change (-2147483648 <= retval_3) in H. lia.
Qed. 

Lemma proof_of__EventCreate_entail_wit_2_2 : _EventCreate_entail_wit_2_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Right. prop_apply_p (store_int_range (&("lock")) retval_3). Intros_p Hlock.
  assert (Hbounds : 0 <= retval_5 < 128) by
    (unfold idmanager_min_free_id in PreH1; unfold event_context in PreH4;
     rewrite <- (proj1 (proj2 PreH4)); tauto).
  split_pure_spatial; [cancel | split_pures; dump_pre_spatial; try assumption; try int_auto; try lia].
  change (-2147483648 <= retval_3) in H1. lia.
Qed. 

Lemma proof_of__EventCreate_return_wit_3_split_goal_1 : _EventCreate_return_wit_3_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold abs_event_create in PreH7 at 1.
  prog_nf in PreH7.
  safe_choice_l PreH7.
  exact PreH7.
Qed.

Lemma proof_of__EventCreate_return_wit_3 : _EventCreate_return_wit_3.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__EventCreate_return_wit_3_split_goal_1.
Qed. 

Lemma proof_of__EventCreate_partial_solve_wit_13_pure_split_goal_1 : _EventCreate_partial_solve_wit_13_pure_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial. unfold dll_insert_anchor. auto.
Qed.

Lemma proof_of__EventCreate_partial_solve_wit_13_pure : _EventCreate_partial_solve_wit_13_pure.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__EventCreate_partial_solve_wit_13_pure_split_goal_1.
Qed. 

Lemma proof_of__EventCreate_which_implies_wit_1_split_goal_1 : _EventCreate_which_implies_wit_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia). pose proof (EventLayoutABI.event_top_level_field_offset_axiom event PreH3) as Hl. unfold EventLayoutABI.event_top_level_field_offset_ok in Hl. destruct Hl as [_ [_ [_ [_ Hl]]]]. dump_pre_spatial. rewrite Hl. lia.
Qed.

Lemma proof_of__EventCreate_which_implies_wit_1_split_goal_2 : _EventCreate_which_implies_wit_1_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia). pose proof (EventLayoutABI.event_top_level_field_offset_axiom event PreH3) as Hl. unfold EventLayoutABI.event_top_level_field_offset_ok in Hl. destruct Hl as [_ [_ [_ [Hl _]]]]. dump_pre_spatial. rewrite Hl. lia.
Qed.

Lemma proof_of__EventCreate_which_implies_wit_1_split_goal_spatial : _EventCreate_which_implies_wit_1_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia). pose proof EventLayoutABI.event_size_axiom as Hsz. change (sizeof_alias_type "Event" = EVENT_MEM_SIZE) in Hsz. cbn [sizeof_front_end_type sizeof_front_end_type_of_ptr_size] in *. rewrite Hsz in *. unfold EVENT_MEM_SIZE in *. apply event_zero_bytes__zero_layout; assumption.
Qed.

Lemma proof_of__EventCreate_which_implies_wit_1 : _EventCreate_which_implies_wit_1.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__EventCreate_which_implies_wit_1_split_goal_spatial.
  - Goal_apply proof_of__EventCreate_which_implies_wit_1_split_goal_1.
  - Goal_apply proof_of__EventCreate_which_implies_wit_1_split_goal_2.
Qed.

Lemma proof_of__EventCreate_which_implies_wit_2_split_goal_1 : _EventCreate_which_implies_wit_2_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  apply event_fresh__open_event_state.
Qed.

Lemma proof_of__EventCreate_which_implies_wit_2_split_goal_2 : _EventCreate_which_implies_wit_2_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv, event_inv. Intros_p Hworld. Intros_p Hctx.
  dump_pre_spatial. exact Hctx.
Qed.

Lemma proof_of__EventCreate_which_implies_wit_2_split_goal_3 : _EventCreate_which_implies_wit_2_split_goal_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold EventZero. Intros_p Hp. dump_pre_spatial. tauto.
Qed.

Lemma proof_of__EventCreate_which_implies_wit_2_split_goal_4 : _EventCreate_which_implies_wit_2_split_goal_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold EventZero. Intros_p Hp. dump_pre_spatial. tauto.
Qed.

Lemma proof_of__EventCreate_which_implies_wit_2_split_goal_spatial : _EventCreate_which_implies_wit_2_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv, event_inv, EventZero, event_create_frame.
  Intros_p Hworld. Intros_p Hctx. Intros_p Hz.
  sep_apply_l_atomic (zero_idnode_insert_ready (&(event # "Event" ->ₛ "id"))).
  destruct Hz as [Hm [_ [_ [_ [_ Hh]]]]]. rewrite Hm, Hh.
  split_pure_spatial; [cancel | dump_pre_spatial; exact Hworld].
Qed.

Lemma proof_of__EventCreate_which_implies_wit_2 : _EventCreate_which_implies_wit_2.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__EventCreate_which_implies_wit_2_split_goal_spatial.
  - Goal_apply proof_of__EventCreate_which_implies_wit_2_split_goal_1.
  - Goal_apply proof_of__EventCreate_which_implies_wit_2_split_goal_2.
  - Goal_apply proof_of__EventCreate_which_implies_wit_2_split_goal_3.
  - Goal_apply proof_of__EventCreate_which_implies_wit_2_split_goal_4.
Qed. 

Lemma proof_of__EventCreate_which_implies_wit_3_split_goal_1 : _EventCreate_which_implies_wit_3_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__EventCreate_which_implies_wit_3_split_goal_2 : _EventCreate_which_implies_wit_3_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  unfold abs_event_create in PreH7 at 1.
  prog_nf in PreH7.
  safe_choice_r PreH7.
  eapply (highstependret_derive _ _ (-5) (fun _ => LastSeen st_lock)); [| exact PreH7].
  unfold hs_eval.
  intros states Hstates.
  exists (Crtos_RTrans st_lock).
  split.
  - unfold task_atomic_cmd.
  simpl.
  exists st_lock, st_lock.
  split.
  + apply (proj2 (Hstates st_lock)).
  exact PreH8.
  + split.
  * left.
  auto.
  * reflexivity.
  - unfold LastSeen.
  reflexivity.
Qed.

Lemma proof_of__EventCreate_which_implies_wit_3_split_goal_spatial : _EventCreate_which_implies_wit_3_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold event_create_frame.
  Intros_p Hwf.
  pose proof (proj1 (os_wf_context _ _ Hwf)) as Hctx.
  pose proof Hctx as Haddr.
  unfold event_context in Haddr.
  destruct Haddr as [Hmanager [_ [_ [_ [_ Hlist]]]]].
  unfold os_inv, event_inv, EventRaw.
  simpl.
  rewrite Hmanager, Hlist.
  split_pure_spatial.
  - cancel (task_inv sg_outside_critical st_lock).
  cancel (tick_inv sg_outside_critical st_lock).
  cancel (delay_inv sg_outside_critical st_lock).
  cancel (assign_inv sg_outside_critical st_lock).
  cancel store_prio_lookup_table.
  cancel (store_zombie_queue (task_desc_map (os_tasks st_lock)) (os_zombie_head sg_outside_critical) (zombie_queue st_lock)).
  cancel (IntArray.full (os_idle_array sg_outside_critical) CORE_COUNT (map service_id (os_idle st_lock))).
  cancel (isrmanager_inv (os_isr_stable sg_outside_critical) (os_isr st_lock)).
  cancel (exstatus_inv sg_outside_critical st_lock).
  cancel (semaphore_inv (pure_suspend_sched_link (task_desc_map (os_tasks st_lock))) (os_semaphore_stable sg_outside_critical) (os_semaphores st_lock)).
  cancel (mutex_inv (pure_suspend_sched_link (task_desc_map (os_tasks st_lock))) (os_mutex_stable sg_outside_critical) (os_mutexes st_lock)).
  cancel (store_int (os_recycler_slot sg_outside_critical) (service_id (os_recycle st_lock))).
  cancel (store_idmanager (event_manager_stable (os_event_stable sg_outside_critical)) (event_manager (os_events st_lock)) &("k_event_id_manager")).
  cancel (store_dll (store_event (pure_suspend_sched_link (task_desc_map (os_tasks st_lock)))) &("k_event_list") (map event_link_node (os_events st_lock))).
  cancel (store_idnode_insert_ready &(event # "Event" ->ₛ "id")).
  unfold NodeZero, NodeStorage, EventPadding.
  split_pure_spatial.
  + sep_apply_l_atomic (store_uint_undef_store_uint &(event # "Event" ->ₛ "options") 0).
  sep_apply_l_atomic (store_uint_undef_store_uint &(event # "Event" ->ₛ "events") 0).
  set (pend := &(event # "Event" ->ₛ "pend_list")) in *.
  set (link := &(event # "Event" ->ₛ "link")) in *.
  sep_apply_l_atomic (store_ptr_undef_store_ptr &(pend # "SysDoubleLinklistNode" ->ₛ "node_prev") 0).
  sep_apply_l_atomic (store_ptr_undef_store_ptr &(pend # "SysDoubleLinklistNode" ->ₛ "node_next") 0).
  sep_apply_l_atomic (store_ptr_undef_store_ptr &(link # "SysDoubleLinklistNode" ->ₛ "node_prev") 0).
  sep_apply_l_atomic (store_ptr_undef_store_ptr &(link # "SysDoubleLinklistNode" ->ₛ "node_next") 0).
  sep_apply_l_atomic (CharArray.full_to_undef_full (event+2) 2 (repeat_Z 0 2)).
  cancel.
  + split_pures; dump_pre_spatial; assumption.
  - split_pures; dump_pre_spatial; auto.
Qed.

Lemma proof_of__EventCreate_which_implies_wit_3 : _EventCreate_which_implies_wit_3.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__EventCreate_which_implies_wit_3_split_goal_spatial.
  - Goal_apply proof_of__EventCreate_which_implies_wit_3_split_goal_2.
Qed. 

Lemma proof_of__EventCreate_which_implies_wit_4 : _EventCreate_which_implies_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold NodeZero.
  set (q := &(event # "Event" ->ₛ "pend_list")).
  sep_apply_l_atomic (store_ptr_undef_store_ptr
    (&(q # "SysDoubleLinklistNode" ->ₛ "node_prev")) 0).
  sep_apply_l_atomic (store_ptr_undef_store_ptr
    (&(q # "SysDoubleLinklistNode" ->ₛ "node_next")) 0).
  unfold q; simpl.
  rewrite !addr_of_arrow_field, !eval_addr.
  cancel.
Qed. 

Lemma proof_of__EventCreate_which_implies_wit_5_split_goal_spatial : _EventCreate_which_implies_wit_5_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hmask : Z.land options_pre 7 = options_pre mod 8).
  { change (Z.land options_pre (Z.ones 3) = options_pre mod (2^3)).
    apply Z.land_ones; lia. }
  pose proof (EventLayoutABI.event_top_level_field_offset_axiom event PreH6) as Hlayout.
  unfold EventLayoutABI.event_top_level_field_offset_ok in Hlayout.
  destruct Hlayout as [Hid [Hopt [Hevents [Hpend Hlink]]]].
  prop_apply_p (valid_store_uint (&(event # "Event" ->ₛ "options")) (Z.land options_pre 7)).
  Intros_p Hvalid.
  assert (Hpendnz : &(event # "Event" ->ₛ "pend_list") <> 0).
  { rewrite Hpend. unfold isvalidptr_int in Hvalid. rewrite Hopt in Hvalid. lia. }
  pose proof (Z.mod_pos_bound options_pre 8 ltac:(lia)) as Hbounds.
  unfold store_event, event_created; cbn.
  rewrite Hmask.
  unfold NodeZero, occupy_dll_node, store_node_self_linked, store_dll.
  Exists (&(event # "Event" ->ₛ "pend_list")) (&(event # "Event" ->ₛ "pend_list")) 0 0.
  simpl dllseg.
  split_pure_spatial.
  - cancel (&(event # "Event" ->ₛ "options") # UInt |-> (options_pre mod 8)).
    cancel (&(event # "Event" ->ₛ "events") # UInt |-> 0).
    cancel.
  - split_pures; dump_pre_spatial; try tauto; try lia.
    + repeat split; auto; lia.
    + repeat split; auto; constructor.
Qed.

Lemma proof_of__EventCreate_which_implies_wit_5 : _EventCreate_which_implies_wit_5.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__EventCreate_which_implies_wit_5_split_goal_spatial.
Qed. 

Lemma proof_of__EventCreate_which_implies_wit_6_split_goal_1 : _EventCreate_which_implies_wit_6_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__EventCreate_which_implies_wit_6_split_goal_2 : _EventCreate_which_implies_wit_6_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  unfold abs_event_create in PreH6 at 1. prog_nf in PreH6.
  safe_choice_r PreH6.
  destruct PreH6 as [states [Hstates Hsafe]].
  exists (Crtos_RTrans (replace_events
    (event_publish event id options_pre (os_events st_lock)) st_lock)).
  split; [unfold LastSeen; reflexivity|].
  unfold safe, weakestpre in Hsafe.
  destruct Hsafe as [Herr Hnormal].
  unfold safe, weakestpre.
  split; [simpl; tauto|].
  intros r final [Hr Hfinal]. subst r final. apply Hnormal. simpl.
  exists st_lock, (replace_events
    (event_publish event id options_pre (os_events st_lock)) st_lock).
  split.
  - apply Hstates. exact PreH7.
  - split.
    + right. exists event.
      split; [exact PreH1|]. split; [exact PreH2|].
      split; [exact PreH5|]. split; [exact PreH4|reflexivity].
    + reflexivity.
Qed.

Lemma proof_of__EventCreate_which_implies_wit_6_split_goal_3 : _EventCreate_which_implies_wit_6_split_goal_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto). dump_pre_spatial.
  unfold idmanager_min_free_id in PreH4.
  unfold event_context in PreH3. intuition lia.
Qed.

Lemma proof_of__EventCreate_which_implies_wit_6_split_goal_4 : _EventCreate_which_implies_wit_6_split_goal_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto). dump_pre_spatial.
  unfold idmanager_min_free_id in PreH4. intuition lia.
Qed.

Lemma proof_of__EventCreate_which_implies_wit_6_split_goal_spatial : _EventCreate_which_implies_wit_6_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold dll_insert_after_dispatch.
  destruct (Z.eq_dec &("k_event_list") &("k_event_list")); [|contradiction].
  rewrite <- (event_publish_manager__publish_world
    (os_event_stable sg_outside_critical) (os_events st_lock)
    event id options_pre PreH3 PreH4).
  unfold event_create_frame. Intros_p Hworld.
  unfold os_inv, event_inv. cbn [replace_events].
  split_pure_spatial.
  - destruct PreH3 as [Hptr [_ [_ [_ [_ Hhead]]]]].
    rewrite Hptr, Hhead. simpl. cancel.
    change (event_link_node (event_created event id options_pre)) with
      (Build_DL_Node (event_created event id options_pre) &(event # "Event" ->ₛ "link")).
    unfold task_inv. Intros_p Htask. split_pure_spatial.
    + change (tick_inv sg_outside_critical (replace_events
        (event_publish event id options_pre (os_events st_lock)) st_lock))
        with (tick_inv sg_outside_critical st_lock).
      change (delay_inv sg_outside_critical (replace_events
        (event_publish event id options_pre (os_events st_lock)) st_lock))
        with (delay_inv sg_outside_critical st_lock).
      change (assign_inv sg_outside_critical (replace_events
        (event_publish event id options_pre (os_events st_lock)) st_lock))
        with (assign_inv sg_outside_critical st_lock).
      change (exstatus_inv sg_outside_critical (replace_events
        (event_publish event id options_pre (os_events st_lock)) st_lock))
        with (exstatus_inv sg_outside_critical st_lock).
      simpl. repeat progress cancel.
    + dump_pre_spatial. destruct Htask; constructor; assumption.
  - split_pures.
    + dump_pre_spatial. apply event_publish_world__publish_world. exact Hworld.
    + dump_pre_spatial. exact PreH3.
Qed.

Lemma proof_of__EventCreate_which_implies_wit_6 : _EventCreate_which_implies_wit_6.
Proof.
 aggressive_pre_process.
 Goal_apply proof_of__EventCreate_which_implies_wit_6_split_goal_spatial.
 Goal_apply proof_of__EventCreate_which_implies_wit_6_split_goal_2.
 Goal_apply proof_of__EventCreate_which_implies_wit_6_split_goal_3.
 Goal_apply proof_of__EventCreate_which_implies_wit_6_split_goal_4.
Qed. 

