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
From KMutexDeleteProof.VC Require Import MutexDelete_goal.
From KMutexDeleteProof.VC Require Import MutexDelete_proof_auto.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.lib.IdModuleSpec.
Require Import CRTOS_Verify.lib.KTaskWakeup.
Require Import CRTOS_Verify.lib.DoubleLinkListSpec CRTOS_Verify.lib.TaskStatusMemory CRTOS_Verify.lib.KTaskParseInfo.
Import IDNode DLL.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.KMutexDelete.
Require Import KMutexDeleteProof.VC.MutexDelete_lib.
Local Open Scope sac.


Lemma proof_of__MutexDelete_safety_wit_1 : _MutexDelete_safety_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__MutexDelete_safety_wit_2 : _MutexDelete_safety_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__MutexDelete_safety_wit_3 : _MutexDelete_safety_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__MutexDelete_entail_wit_1 : _MutexDelete_entail_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  exfalso.
  unfold mutex_delete_live in PreH2.
  destruct PreH2 as [Hnonzero _].
  exact (Hnonzero PreH1).
Qed. 

Lemma proof_of__MutexDelete_entail_wit_2 : _MutexDelete_entail_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__MutexDelete_return_wit_1 : _MutexDelete_return_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Exists after_2.
  split_pure_spatial.
  - cancel.
  - dump_pre_spatial. exact PreH3.
Qed. 

Lemma proof_of__MutexDelete_partial_solve_wit_1_pure : _MutexDelete_partial_solve_wit_1_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__MutexDelete_partial_solve_wit_1 : _MutexDelete_partial_solve_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _MutexDelete_partial_solve_wit_1_aux. intros.
  split_pure_spatial.
  - cancel (OutsideCritical sg_assumed_environment before_assumed_environment).
  - split_pures; dump_pre_spatial; assumption.
Qed. 

Lemma proof_of__MutexDelete_partial_solve_wit_2 : _MutexDelete_partial_solve_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _MutexDelete_partial_solve_wit_2_aux. intros.
  split_pure_spatial.
  - cancel (OutsideCritical sg_assumed_environment before_assumed_environment).
  - split_pures; dump_pre_spatial; first [assumption | unfold mutex_pending_head; reflexivity].
Qed. 

Lemma proof_of__MutexDelete_partial_solve_wit_3_pure : _MutexDelete_partial_solve_wit_3_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__MutexDelete_partial_solve_wit_3 : _MutexDelete_partial_solve_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _MutexDelete_partial_solve_wit_3_aux. intros.
  split_pure_spatial.
  - cancel (OutsideCritical sg_assumed_environment drained).
  - split_pures; dump_pre_spatial; assumption.
Qed. 

Lemma proof_of__MutexDelete_partial_solve_wit_4_pure : _MutexDelete_partial_solve_wit_4_pure.
Proof.
  LLM_pre_process ltac:(assumption).
Qed. 

Lemma proof_of__MutexDelete_partial_solve_wit_4 : _MutexDelete_partial_solve_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _MutexDelete_partial_solve_wit_4_aux. intros.
  split_pure_spatial.
  - cancel (OutsideCritical sg_assumed_environment drained).
  - split_pures; dump_pre_spatial; assumption.
Qed. 

Lemma proof_of__MutexDelete_partial_solve_wit_5_pure : _MutexDelete_partial_solve_wit_5_pure.
Proof.
  LLM_pre_process ltac:(assumption).
Qed. 

Lemma proof_of__MutexDelete_partial_solve_wit_5 : _MutexDelete_partial_solve_wit_5.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _MutexDelete_partial_solve_wit_5_aux. intros.
  split_pure_spatial.
  - cancel (os_inv sg_assumed_environment st_lock).
    cancel (InsideCritical sg_assumed_environment st_lock).
  - split_pures; dump_pre_spatial; assumption.
Qed. 

Lemma proof_of__MutexDelete_partial_solve_wit_6 : _MutexDelete_partial_solve_wit_6.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__MutexDelete_partial_solve_wit_7 : _MutexDelete_partial_solve_wit_7.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__MutexDelete_partial_solve_wit_8 : _MutexDelete_partial_solve_wit_8.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _MutexDelete_partial_solve_wit_8_aux. intros.
  assert (Hbounds : 0 <= id_assumed_environment < 65536)
    by (unfold mutex_delete_drained in PreH9; tauto).
  split_pure_spatial.
  - cancel (store_idmanager (mutex_manager_stable (os_mutex_stable sg_assumed_environment))
      (mutex_manager (os_mutexes st_lock)) (&("k_mutex_id_manager"))).
    cancel (mutex_delete_manager_frame sg_assumed_environment st_lock).
    cancel (InsideCritical sg_assumed_environment st_lock).
  - split_pures; dump_pre_spatial; try assumption; try lia;
      apply addr_of_LE_var_not_zero.
Qed. 

Lemma proof_of__MutexDelete_partial_solve_wit_9_pure : _MutexDelete_partial_solve_wit_9_pure.
Proof.
  LLM_pre_process ltac:(assumption || reflexivity || lia || int_auto).
Qed. 

Lemma proof_of__MutexDelete_partial_solve_wit_9 : _MutexDelete_partial_solve_wit_9.
Proof.
  LLM_pre_process ltac:(assumption || reflexivity || lia || int_auto).
  LLM_pre_process ltac:(assumption || reflexivity || lia || int_auto).
Qed. 

Lemma proof_of__MutexDelete_partial_solve_wit_10_pure : _MutexDelete_partial_solve_wit_10_pure.
Proof.
  LLM_pre_process ltac:(congruence).
Qed. 

Lemma proof_of__MutexDelete_partial_solve_wit_10 : _MutexDelete_partial_solve_wit_10.
Proof.
  LLM_pre_process ltac:(congruence).
Qed. 

Lemma proof_of__MutexDelete_partial_solve_wit_11 : _MutexDelete_partial_solve_wit_11.
Proof.
  LLM_pre_process ltac:(congruence).
Qed. 

Lemma proof_of__MutexDelete_partial_solve_wit_12 : _MutexDelete_partial_solve_wit_12.
Proof.
  LLM_pre_process ltac:(assumption || reflexivity || lia || int_auto).
Qed. 

Lemma proof_of__MutexDelete_partial_solve_wit_13_pure : _MutexDelete_partial_solve_wit_13_pure.
Proof.
  LLM_pre_process ltac:(assumption || reflexivity || lia || int_auto).
Qed. 

Lemma proof_of__MutexDelete_partial_solve_wit_13 : _MutexDelete_partial_solve_wit_13.
Proof.
  LLM_pre_process ltac:(assumption || reflexivity || lia || int_auto).
  LLM_pre_process ltac:(assumption || reflexivity || lia || int_auto).
Qed. 

Lemma proof_of__MutexDelete_partial_solve_wit_14 : _MutexDelete_partial_solve_wit_14.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__MutexDelete_partial_solve_wit_15 : _MutexDelete_partial_solve_wit_15.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  rewrite PreH1.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; congruence.
Qed. 

Lemma proof_of__MutexDelete_entail_wit_3_1_split_goal_1 : _MutexDelete_entail_wit_3_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(congruence).
Qed.

Lemma proof_of__MutexDelete_entail_wit_3_1_split_goal_2 : _MutexDelete_entail_wit_3_1_split_goal_2.
Proof.
  LLM_pre_process ltac:(congruence).
Qed.

Lemma proof_of__MutexDelete_entail_wit_3_1_split_goal_spatial : _MutexDelete_entail_wit_3_1_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(congruence).
Qed.

Lemma proof_of__MutexDelete_entail_wit_3_1 : _MutexDelete_entail_wit_3_1.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__MutexDelete_entail_wit_3_1_split_goal_spatial.
  - Goal_apply proof_of__MutexDelete_entail_wit_3_1_split_goal_2.
Qed. 

Lemma proof_of__MutexDelete_entail_wit_3_2_split_goal_1 : _MutexDelete_entail_wit_3_2_split_goal_1.
Proof. LLM_pre_process ltac:(lia || int_auto). Qed.

Lemma proof_of__MutexDelete_entail_wit_3_2_split_goal_2 : _MutexDelete_entail_wit_3_2_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  eapply retire_continuation__retire_state; eauto.
Qed.

Lemma proof_of__MutexDelete_entail_wit_3_2_split_goal_spatial : _MutexDelete_entail_wit_3_2_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  cancel (InsideCritical sg_assumed_environment st_lock).
  subst mutex_pre id_assumed_environment.
  sep_apply_l_atomic (retire_empty_mutex_memory__retire_state
    sg_assumed_environment st_lock prefix suffix current idnode
    PreH1 PreH3 PreH13 PreH12 PreH5 PreH6 PreH7 PreH11).
  cancel.
Qed.

Lemma proof_of__MutexDelete_entail_wit_3_2 : _MutexDelete_entail_wit_3_2.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__MutexDelete_entail_wit_3_2_split_goal_spatial.
  - Goal_apply proof_of__MutexDelete_entail_wit_3_2_split_goal_2.
Qed. 

Lemma proof_of__MutexDelete_partial_solve_wit_2_pure_split_goal_1 : _MutexDelete_partial_solve_wit_2_pure_split_goal_1.
Proof.
  LLM_pre_process ltac:(unfold mutex_pending_head; reflexivity).
Qed.

Lemma proof_of__MutexDelete_partial_solve_wit_2_pure : _MutexDelete_partial_solve_wit_2_pure.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__MutexDelete_partial_solve_wit_2_pure_split_goal_1.
Qed. 

Lemma proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_1 : _MutexDelete_partial_solve_wit_8_pure_split_goal_1.
Proof.
  LLM_pre_process ltac:(apply CNotation.addr_of_LE_var_not_zero).
Qed.

Lemma proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_2 : _MutexDelete_partial_solve_wit_8_pure_split_goal_2.
Proof.
  LLM_pre_process ltac:(unfold mutex_delete_drained, mutex_delete_live in *; intuition lia).
Qed.

Lemma proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_3 : _MutexDelete_partial_solve_wit_8_pure_split_goal_3.
Proof.
  LLM_pre_process ltac:(unfold mutex_delete_drained, mutex_delete_live in *; intuition lia).
Qed.

Lemma proof_of__MutexDelete_partial_solve_wit_8_pure : _MutexDelete_partial_solve_wit_8_pure.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_1.
  - Goal_apply proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_2.
  - Goal_apply proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_3.
Qed. 

Lemma proof_of__MutexDelete_which_implies_wit_1_split_goal_1 : _MutexDelete_which_implies_wit_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold abs_mutex_delete_object in PreH1 at 1.
  prog_nf in PreH1.
  unfold mutex_delete_after_resume.
  unfold monadesafe_lib.safeExec, monadesafe_lib.safe in PreH1.
  unfold monadesafe_lib.safeExec, monadesafe_lib.safe.
  setoid_rewrite wp_bind in PreH1.
  exact PreH1.
Qed.

Lemma proof_of__MutexDelete_which_implies_wit_1 : _MutexDelete_which_implies_wit_1.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__MutexDelete_which_implies_wit_1_split_goal_1.
Qed. 

Lemma proof_of__MutexDelete_which_implies_wit_2_split_goal_1 : _MutexDelete_which_implies_wit_2_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold mutex_delete_after_resume in PreH1 at 1.
  prog_nf in PreH1.
  unfold monadesafe_lib.safeExec, monadesafe_lib.safe in PreH1.
  unfold monadesafe_lib.safeExec, monadesafe_lib.safe.
  setoid_rewrite wp_ret in PreH1.
  exact PreH1.
Qed.

Lemma proof_of__MutexDelete_which_implies_wit_2 : _MutexDelete_which_implies_wit_2.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__MutexDelete_which_implies_wit_2_split_goal_1.
Qed. 

Lemma proof_of__MutexDelete_which_implies_wit_3 : _MutexDelete_which_implies_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  destruct PreH1 as [Hp [Hid [current [Hin [Haddr [Hkey Hempty]]]]]].
  destruct (in_split current (os_mutexes st_lock) Hin) as [prefix [suffix Hsplit]].
  prop_apply_p (mutex_addresses_unique__borrow_id sg_assumed_environment st_lock).
  Intros_p Haddr_unique.
  prop_apply_p (mutex_ids_unique__borrow_id sg_assumed_environment st_lock).
  Intros_p Hid_unique.
  Exists prefix current suffix.
  split_pure_spatial.
  - rewrite <- Haddr, <- Hkey.
    apply os_id_cell_focus__borrow_id. exact Hin.
  - split_pures; dump_pre_spatial; try assumption.
    unfold idmanager_query, mutex_manager. cbn [idlist].
    apply id_in_ids_true_iff. rewrite <- Hkey. apply in_map. exact Hin.
Qed. 

Lemma proof_of__MutexDelete_which_implies_wit_4_split_goal_spatial : _MutexDelete_which_implies_wit_4_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold mutex_delete_id_restore.
  apply derivable1_wand_elim2.
Qed.

Lemma proof_of__MutexDelete_which_implies_wit_4 : _MutexDelete_which_implies_wit_4.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__MutexDelete_which_implies_wit_4_split_goal_spatial.
Qed. 

Lemma proof_of__MutexDelete_which_implies_wit_5_split_goal_spatial : _MutexDelete_which_implies_wit_5_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv, mutex_inv, mutex_delete_manager_frame, mutex_create_frame.
  Intros_p Hworld.
  Intros_p Hctx.
  assert (Hptr : mutex_manager_ptr (os_mutex_stable sg_assumed_environment) = &("k_mutex_id_manager")) by (unfold mutex_context in Hctx; tauto).
  rewrite Hptr.
  split_pure_spatial.
  - cancel (store_idmanager (mutex_manager_stable (os_mutex_stable sg_assumed_environment)) (mutex_manager (os_mutexes st_lock)) &("k_mutex_id_manager")).
    cancel (task_inv sg_assumed_environment st_lock).
    cancel (tick_inv sg_assumed_environment st_lock).
    cancel (delay_inv sg_assumed_environment st_lock).
    cancel (assign_inv sg_assumed_environment st_lock).
    cancel store_prio_lookup_table.
    cancel (store_zombie_queue (task_desc_map (os_tasks st_lock)) (os_zombie_head sg_assumed_environment) (zombie_queue st_lock)).
    cancel (os_recycler_slot sg_assumed_environment # Int |-> service_id (os_recycle st_lock)).
    cancel (IntArray.full (os_idle_array sg_assumed_environment) CORE_COUNT (map service_id (os_idle st_lock))).
    cancel (isrmanager_inv (os_isr_stable sg_assumed_environment) (os_isr st_lock)).
    cancel (exstatus_inv sg_assumed_environment st_lock).
    cancel (semaphore_inv (pure_suspend_sched_link (task_desc_map (os_tasks st_lock))) (os_semaphore_stable sg_assumed_environment) (os_semaphores st_lock)).
    cancel (event_inv (pure_suspend_sched_link (task_desc_map (os_tasks st_lock))) (os_event_stable sg_assumed_environment) (os_events st_lock)).
    cancel (store_dll (store_mutex (pure_suspend_sched_link (task_desc_map (os_tasks st_lock)))) (mutex_list_head (os_mutex_stable sg_assumed_environment)) (map mutex_link_node (os_mutexes st_lock))).
  - split_pures; dump_pre_spatial; assumption.
Qed.

Lemma proof_of__MutexDelete_which_implies_wit_5 : _MutexDelete_which_implies_wit_5.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__MutexDelete_which_implies_wit_5_split_goal_spatial.
Qed. 

Lemma proof_of__MutexDelete_which_implies_wit_6_split_goal_1 : _MutexDelete_which_implies_wit_6_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold mutex_delete_manager_frame.
  Intros_p Hctx.
  dump_pre_spatial.
  exact Hctx.
Qed.

Lemma proof_of__MutexDelete_which_implies_wit_6_split_goal_spatial : _MutexDelete_which_implies_wit_6_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold mutex_delete_manager_frame.
  Intros_p Hctx.
  rewrite PreH1, map_app.
  cbn [map mutex_link_node].
  unfold mutex_link_node at 2.
  rewrite PreH2.
  assert (Hhead : mutex_list_head (os_mutex_stable sg_assumed_environment) = &("k_mutex_list")) by (unfold mutex_context in Hctx; tauto).
  rewrite Hhead.
  cancel.
Qed.

Lemma proof_of__MutexDelete_which_implies_wit_6 : _MutexDelete_which_implies_wit_6.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__MutexDelete_which_implies_wit_6_split_goal_spatial.
  - Goal_apply proof_of__MutexDelete_which_implies_wit_6_split_goal_1.
Qed. 

Lemma proof_of__MutexDelete_which_implies_wit_7_split_goal_spatial : _MutexDelete_which_implies_wit_7_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold MutexRetired, MutexRaw, store_idnode, store_idnode_insert_ready,
    store_node_self_linked, NodeStorage, MutexPadding.
  simpl. Intros.
  destruct H0 as [Hid Hlink].
  unfold idnode_link in Hlink; simpl in Hlink.
  rewrite idnode_link_node_prev_addr, idnode_link_node_next_addr.
  rewrite <- Hlink.
  split_pure_spatial.
  - cbn zeta.
    match goal with
    | |- context [store_ushort ?p ?v] =>
        sep_apply_l_atomic (store_ushort_undef_store_ushort p v)
    end. cancel.
    match goal with
    | |- context [store_ushort ?p ?v] =>
        sep_apply_l_atomic (store_ushort_undef_store_ushort p v)
    end. cancel.
    repeat match goal with
    | |- context [store_uchar ?p ?v] =>
        sep_apply_l_atomic (store_uchar_undef_store_uchar p v); cancel
    | |- context [store_ptr ?p ?v] =>
        sep_apply_l_atomic (store_ptr_undef_store_ptr p v); cancel
    end.
    sep_apply_l_atomic (CharArray.full_to_undef_full
      (mutex_addr current + 2) 2 (repeat_Z 0 2)).
    cancel.
  - split_pures; dump_pre_spatial; tauto.
Qed.

Lemma proof_of__MutexDelete_which_implies_wit_7 : _MutexDelete_which_implies_wit_7.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__MutexDelete_which_implies_wit_7_split_goal_spatial.
Qed. 

