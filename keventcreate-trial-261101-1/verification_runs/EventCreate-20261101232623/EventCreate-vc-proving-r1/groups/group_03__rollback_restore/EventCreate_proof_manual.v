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
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_2 : _EventCreate_safety_wit_2.
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_3 : _EventCreate_safety_wit_3.
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_4 : _EventCreate_safety_wit_4.
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_5 : _EventCreate_safety_wit_5.
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_6 : _EventCreate_safety_wit_6.
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_7 : _EventCreate_safety_wit_7.
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_8 : _EventCreate_safety_wit_8.
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_9 : _EventCreate_safety_wit_9.
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_10 : _EventCreate_safety_wit_10.
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_11 : _EventCreate_safety_wit_11.
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_12 : _EventCreate_safety_wit_12.
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_13 : _EventCreate_safety_wit_13.
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_14 : _EventCreate_safety_wit_14.
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_15 : _EventCreate_safety_wit_15.
Proof. Admitted. 

Lemma proof_of__EventCreate_safety_wit_16 : _EventCreate_safety_wit_16.
Proof. Admitted. 

Lemma proof_of__EventCreate_entail_wit_1 : _EventCreate_entail_wit_1.
Proof. Admitted. 

Lemma proof_of__EventCreate_return_wit_1 : _EventCreate_return_wit_1.
Proof. Admitted. 

Lemma proof_of__EventCreate_return_wit_2 : _EventCreate_return_wit_2.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_1_pure : _EventCreate_partial_solve_wit_1_pure.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_1 : _EventCreate_partial_solve_wit_1.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_2_pure : _EventCreate_partial_solve_wit_2_pure.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_2 : _EventCreate_partial_solve_wit_2.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_3_pure : _EventCreate_partial_solve_wit_3_pure.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_3 : _EventCreate_partial_solve_wit_3.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_4 : _EventCreate_partial_solve_wit_4.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_5 : _EventCreate_partial_solve_wit_5.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_6 : _EventCreate_partial_solve_wit_6.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_7_pure : _EventCreate_partial_solve_wit_7_pure.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_7 : _EventCreate_partial_solve_wit_7.
Proof. Admitted. 

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
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_11 : _EventCreate_partial_solve_wit_11.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_12_pure : _EventCreate_partial_solve_wit_12_pure.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_12 : _EventCreate_partial_solve_wit_12.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_13 : _EventCreate_partial_solve_wit_13.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_14_pure : _EventCreate_partial_solve_wit_14_pure.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_14 : _EventCreate_partial_solve_wit_14.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_15_pure : _EventCreate_partial_solve_wit_15_pure.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_15 : _EventCreate_partial_solve_wit_15.
Proof. Admitted. 

Lemma proof_of__EventCreate_entail_wit_2_1 : _EventCreate_entail_wit_2_1.
Proof. Admitted. 

Lemma proof_of__EventCreate_entail_wit_2_2 : _EventCreate_entail_wit_2_2.
Proof. Admitted. 

Lemma proof_of__EventCreate_return_wit_3_split_goal_1 : _EventCreate_return_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of__EventCreate_return_wit_3 : _EventCreate_return_wit_3.
Proof. Admitted. 

Lemma proof_of__EventCreate_partial_solve_wit_13_pure_split_goal_1 : _EventCreate_partial_solve_wit_13_pure_split_goal_1.
Proof. Abort.

Lemma proof_of__EventCreate_partial_solve_wit_13_pure : _EventCreate_partial_solve_wit_13_pure.
Proof. Admitted. 

Lemma proof_of__EventCreate_which_implies_wit_1_split_goal_1 : _EventCreate_which_implies_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_1_split_goal_2 : _EventCreate_which_implies_wit_1_split_goal_2.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_1_split_goal_spatial : _EventCreate_which_implies_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_1 : _EventCreate_which_implies_wit_1.
Proof. Admitted. 

Lemma proof_of__EventCreate_which_implies_wit_2_split_goal_1 : _EventCreate_which_implies_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_2_split_goal_2 : _EventCreate_which_implies_wit_2_split_goal_2.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_2_split_goal_3 : _EventCreate_which_implies_wit_2_split_goal_3.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_2_split_goal_4 : _EventCreate_which_implies_wit_2_split_goal_4.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_2_split_goal_spatial : _EventCreate_which_implies_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_2 : _EventCreate_which_implies_wit_2.
Proof. Admitted. 

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
Proof. Admitted. 

Lemma proof_of__EventCreate_which_implies_wit_5_split_goal_spatial : _EventCreate_which_implies_wit_5_split_goal_spatial.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_5 : _EventCreate_which_implies_wit_5.
Proof. Admitted. 

Lemma proof_of__EventCreate_which_implies_wit_6_split_goal_1 : _EventCreate_which_implies_wit_6_split_goal_1.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_6_split_goal_2 : _EventCreate_which_implies_wit_6_split_goal_2.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_6_split_goal_3 : _EventCreate_which_implies_wit_6_split_goal_3.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_6_split_goal_4 : _EventCreate_which_implies_wit_6_split_goal_4.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_6_split_goal_spatial : _EventCreate_which_implies_wit_6_split_goal_spatial.
Proof. Abort.

Lemma proof_of__EventCreate_which_implies_wit_6 : _EventCreate_which_implies_wit_6.
Proof. Admitted. 

