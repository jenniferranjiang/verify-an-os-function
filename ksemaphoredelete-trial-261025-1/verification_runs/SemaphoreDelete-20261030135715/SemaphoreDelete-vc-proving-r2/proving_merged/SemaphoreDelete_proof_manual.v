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
From CRTOS_Verify.VC Require Import SemaphoreDelete_goal.
From CRTOS_Verify.VC Require Import SemaphoreDelete_proof_auto.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.lib.IdModuleSpec.
Require Import CRTOS_Verify.lib.KSemaphoreDelete CRTOS_Verify.lib.KTaskUnSetDelay.
Require Import CRTOS_Verify.lib.DoubleLinkListSpec CRTOS_Verify.lib.TaskStatusMemory CRTOS_Verify.lib.KTaskParseInfo.
Import IDNode DLL.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.VC.SemaphoreDelete_lib.
Local Open Scope sac.

Lemma proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_1 : _SemaphoreDelete_entail_wit_2_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  all: dump_pre_spatial; reflexivity.
Qed.

Lemma proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_2 : _SemaphoreDelete_entail_wit_2_1_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  exfalso. apply (CNotation.addr_of_LE_var_not_zero "k_sem_id_manager"). assumption.
Qed.

Lemma proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_spatial : _SemaphoreDelete_entail_wit_2_1_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  exfalso. apply (CNotation.addr_of_LE_var_not_zero "k_sem_id_manager"). assumption.
Qed.

Lemma proof_of__SemaphoreDelete_entail_wit_2_1 : _SemaphoreDelete_entail_wit_2_1.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_spatial.
  - Goal_apply proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_2.

Qed. 

Lemma proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_1 : _SemaphoreDelete_entail_wit_2_2_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  all: dump_pre_spatial; reflexivity.
Qed.

Lemma proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_2 : _SemaphoreDelete_entail_wit_2_2_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial. eapply delete_miss_continuation__lookup_miss; eauto.
Qed.

Lemma proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_spatial : _SemaphoreDelete_entail_wit_2_2_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold delete_manager_frame, delete_global_frame, os_inv, semaphore_inv.
  Intros.
  match goal with Hctx : semaphore_context _ |- _ => rewrite (proj1 Hctx) end.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed.

Lemma proof_of__SemaphoreDelete_entail_wit_2_2 : _SemaphoreDelete_entail_wit_2_2.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_spatial.
  - Goal_apply proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_2.

Qed. 

Lemma proof_of__SemaphoreDelete_entail_wit_3_1_split_goal_1 : _SemaphoreDelete_entail_wit_3_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  intro Hnil. rewrite Hnil in PreH8. contradiction.
Qed.

Lemma proof_of__SemaphoreDelete_entail_wit_3_1 : _SemaphoreDelete_entail_wit_3_1.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreDelete_entail_wit_3_1_split_goal_1.
Qed. 

Lemma proof_of__SemaphoreDelete_entail_wit_3_2 : _SemaphoreDelete_entail_wit_3_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  apply map_eq_nil in PreH3.
  Exists st_lock.
  split_pure_spatial.
  - unfold delete_pending_restore, semaphore_pending_head.
    sep_apply_l_atomic (derivable1_wand_elim1
      (store_dll (pure_suspend_sched_link st_lock.(os_tasks).(task_desc_map))
        (&(((original.(semaphore_addr))) # "Semaphore" ->ₛ "pend_list"))
        (map sched_link_node original.(semaphore_pending_addrs)))
      (os_inv sg_outside_critical st_lock)).
    sepcon_assoc_change; cancel.
  - split_pures; dump_pre_spatial; try assumption; try reflexivity; try lia.
    + unfold semaphore_resume_all_effect. rewrite PreH3. reflexivity.
    + unfold semaphore_pending_nodes. exists original.
      repeat split; auto. rewrite PreH3. reflexivity.
Qed. 

Lemma proof_of__SemaphoreDelete_entail_wit_4_1 : _SemaphoreDelete_entail_wit_4_1.
Proof.
  LLM_pre_process ltac:(congruence).
  all: congruence.
Qed. 

Lemma proof_of__SemaphoreDelete_entail_wit_4_2 : _SemaphoreDelete_entail_wit_4_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hcontains : idmanager_contains
    (semaphore_manager_stable (os_semaphore_stable sg_outside_critical))
    (semaphore_manager (os_semaphores drained)) (semaphore_id current) idnode_2).
  { rewrite PreH13. exact PreH5. }
  rewrite <- PreH12, <- PreH13.
  sepcon_assoc_change.
  sep_apply_l_atomic (retire_empty_semaphore_memory__retirement_commit
    sg_outside_critical drained prefix suffix current idnode_2
    PreH1 PreH3 PreH16 Hcontains PreH6 PreH7 PreH15).
  rewrite PreH12, PreH14.
  prop_apply_p (retired_nonzero__retirement_commit
    (semaphore_addr original) (semaphore_value original)).
  Intros_p Hp.
  set (after := replace_semaphores
    (semaphore_unpublish (semaphore_addr original) (os_semaphores drained)) drained).
  assert (Hstep : MonadErr.nrm (abs_semaphore_delete_locked id_pre) st_lock false after).
  {
    cbn [abs_semaphore_delete_locked].
    exists (semaphore_addr original). unfold semaphore_delete_locked_effect.
    right. exists original, drained.
    split; [exact PreH8|].
    split; [change (semaphore_id original = unsigned_last_nbits id_pre 16); exact PreH25|].
    split; [reflexivity|]. split; [exact Hp|].
    split.
    - rewrite PreH27. reflexivity.
    - split; [exact PreH9|reflexivity].
  }
  pose proof (delete_atomic_continuation__retirement_commit
    sg_outside_critical id_pre before_outside_critical st_lock after false
    X_outside_critical PreH20 PreH28 Hstep PreH29) as Hsafe.
  Exists after.
  split_pure_spatial.
  - sepcon_assoc_change. cancel.
  - split_pures; dump_pre_spatial; try reflexivity; try assumption; try congruence.
Qed. 

Lemma proof_of__SemaphoreDelete_entail_wit_4_3 : _SemaphoreDelete_entail_wit_4_3.
Proof.
  LLM_pre_process ltac:(lia || congruence).
Qed. 

Lemma proof_of__SemaphoreDelete_entail_wit_4_4 : _SemaphoreDelete_entail_wit_4_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hcontains : idmanager_contains
    (semaphore_manager_stable (os_semaphore_stable sg_outside_critical))
    (semaphore_manager (os_semaphores drained)) (semaphore_id current) idnode_2).
  { rewrite PreH13. exact PreH5. }
  rewrite <- PreH12, <- PreH13.
  sepcon_assoc_change.
  sep_apply_l_atomic (retire_empty_semaphore_memory__retirement_commit
    sg_outside_critical drained prefix suffix current idnode_2
    PreH1 PreH3 PreH16 Hcontains PreH6 PreH7 PreH15).
  rewrite PreH12, PreH14.
  prop_apply_p (retired_nonzero__retirement_commit
    (semaphore_addr original) (semaphore_value original)).
  Intros_p Hp.
  set (after := replace_semaphores
    (semaphore_unpublish (semaphore_addr original) (os_semaphores drained)) drained).
  assert (Hstep : MonadErr.nrm (abs_semaphore_delete_locked id_pre) st_lock true after).
  {
    cbn [abs_semaphore_delete_locked].
    exists (semaphore_addr original). unfold semaphore_delete_locked_effect.
    right. exists original, drained.
    split; [exact PreH8|].
    split; [change (semaphore_id original = unsigned_last_nbits id_pre 16); exact PreH25|].
    split; [reflexivity|]. split; [exact Hp|].
    split.
    - destruct (semaphore_pending_addrs original) as [|t ts] eqn:Hwaiting; [contradiction|reflexivity].
    - split; [exact PreH9|reflexivity].
  }
  pose proof (delete_atomic_continuation__retirement_commit
    sg_outside_critical id_pre before_outside_critical st_lock after true
    X_outside_critical PreH20 PreH28 Hstep PreH29) as Hsafe.
  Exists after.
  split_pure_spatial.
  - sepcon_assoc_change. cancel.
  - split_pures; dump_pre_spatial; try reflexivity; try assumption; try congruence.
Qed. 

Lemma proof_of__SemaphoreDelete_return_wit_2_split_goal_1 : _SemaphoreDelete_return_wit_2_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hneg : Z.ltb id_pre 0 = true) by (apply Z.ltb_lt; lia).
  unfold abs_semaphore_delete in PreH4 at 1.
  prog_nf in PreH4.
  rewrite Hneg in PreH4.
  exact PreH4.
Qed.

Lemma proof_of__SemaphoreDelete_return_wit_2 : _SemaphoreDelete_return_wit_2.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreDelete_return_wit_2_split_goal_1.
Qed. 

Lemma proof_of__SemaphoreDelete_partial_solve_wit_3_pure_split_goal_1 : _SemaphoreDelete_partial_solve_wit_3_pure_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  pose proof (unsigned_Lastnbits_range id_pre 16 ltac:(lia)) as Hrange.
  change (0 <= unsigned_last_nbits id_pre 16 < 65536) in Hrange.
  lia.
Qed.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_3_pure_split_goal_2 : _SemaphoreDelete_partial_solve_wit_3_pure_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  pose proof (unsigned_Lastnbits_range id_pre 16 ltac:(lia)) as Hrange.
  change (0 <= unsigned_last_nbits id_pre 16 < 65536) in Hrange.
  lia.
Qed.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_3_pure : _SemaphoreDelete_partial_solve_wit_3_pure.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreDelete_partial_solve_wit_3_pure_split_goal_1.
  - Goal_apply proof_of__SemaphoreDelete_partial_solve_wit_3_pure_split_goal_2.
Qed. 

Lemma proof_of__SemaphoreDelete_partial_solve_wit_10_pure_split_goal_1 : _SemaphoreDelete_partial_solve_wit_10_pure_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_10_pure_split_goal_2 : _SemaphoreDelete_partial_solve_wit_10_pure_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_10_pure : _SemaphoreDelete_partial_solve_wit_10_pure.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreDelete_partial_solve_wit_10_pure_split_goal_1.
  - Goal_apply proof_of__SemaphoreDelete_partial_solve_wit_10_pure_split_goal_2.
Qed. 

Lemma proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_1 : _SemaphoreDelete_partial_solve_wit_17_pure_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  apply CNotation.addr_of_LE_var_not_zero.
Qed.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_2 : _SemaphoreDelete_partial_solve_wit_17_pure_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  pose proof (unsigned_Lastnbits_range id_pre 16 ltac:(lia)) as Hrange.
  change (0 <= unsigned_last_nbits id_pre 16 < 65536) in Hrange.
  lia.
Qed.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_3 : _SemaphoreDelete_partial_solve_wit_17_pure_split_goal_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  pose proof (unsigned_Lastnbits_range id_pre 16 ltac:(lia)) as Hrange.
  change (0 <= unsigned_last_nbits id_pre 16 < 65536) in Hrange.
  lia.
Qed.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_17_pure : _SemaphoreDelete_partial_solve_wit_17_pure.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_1.
  - Goal_apply proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_2.
  - Goal_apply proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_3.
Qed. 

Lemma proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_1 : _SemaphoreDelete_partial_solve_wit_18_pure_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  apply CNotation.addr_of_LE_var_not_zero.
Qed.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_2 : _SemaphoreDelete_partial_solve_wit_18_pure_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  pose proof (unsigned_Lastnbits_range id_pre 16 ltac:(lia)) as Hrange.
  change (0 <= unsigned_last_nbits id_pre 16 < 65536) in Hrange.
  lia.
Qed.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_3 : _SemaphoreDelete_partial_solve_wit_18_pure_split_goal_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  pose proof (unsigned_Lastnbits_range id_pre 16 ltac:(lia)) as Hrange.
  change (0 <= unsigned_last_nbits id_pre 16 < 65536) in Hrange.
  lia.
Qed.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_18_pure : _SemaphoreDelete_partial_solve_wit_18_pure.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_1.
  - Goal_apply proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_2.
  - Goal_apply proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_3.
Qed. 

Lemma proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_spatial : _SemaphoreDelete_which_implies_wit_1_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv, semaphore_inv, delete_manager_frame, delete_global_frame.
  Intros_p Hwf. Intros_p Hctx. rewrite (proj1 Hctx).
  split_pure_spatial; [cancel | split_pures; dump_pre_spatial; auto].
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1 : _SemaphoreDelete_which_implies_wit_1.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_spatial.
Qed. 

Lemma proof_of__SemaphoreDelete_which_implies_wit_2 : _SemaphoreDelete_which_implies_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  apply semaphore_found_close__lookup_views.
Qed. 

Lemma proof_of__SemaphoreDelete_which_implies_wit_3_split_goal_spatial : _SemaphoreDelete_which_implies_wit_3_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  apply pending_dll_focus__pending_views; assumption.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_3 : _SemaphoreDelete_which_implies_wit_3.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreDelete_which_implies_wit_3_split_goal_spatial.
Qed. 

Lemma proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_1 : _SemaphoreDelete_which_implies_wit_4_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial. unfold semaphore_pending_nodes.
  exists original. repeat split; auto.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_spatial : _SemaphoreDelete_which_implies_wit_4_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold delete_pending_restore, semaphore_pending_head.
  apply derivable1_wand_elim2.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_4 : _SemaphoreDelete_which_implies_wit_4.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_spatial.
  - Goal_apply proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_1.
Qed. 

Lemma proof_of__SemaphoreDelete_which_implies_wit_5_split_goal_spatial : _SemaphoreDelete_which_implies_wit_5_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  eapply resume_id_cell_focus__id_read_views; eauto.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_5 : _SemaphoreDelete_which_implies_wit_5.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreDelete_which_implies_wit_5_split_goal_spatial.
Qed. 

Lemma proof_of__SemaphoreDelete_which_implies_wit_6_split_goal_spatial : _SemaphoreDelete_which_implies_wit_6_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold delete_id_restore.
  apply derivable1_wand_elim2.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_6 : _SemaphoreDelete_which_implies_wit_6.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreDelete_which_implies_wit_6_split_goal_spatial.
Qed. 

Lemma proof_of__SemaphoreDelete_which_implies_wit_7 : _SemaphoreDelete_which_implies_wit_7.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  destruct (resume_keeps_semaphore_fields__manager_selection
    sem original st_lock drained PreH1 PreH2 PreH3)
    as [current [Hcurrent [Haddr [Hid [Hvalue Hpending]]]]].
  destruct (in_split current (os_semaphores drained) Hcurrent)
    as [prefix [suffix Hsplit]].
  assert (Hquery : idmanager_query (semaphore_manager (os_semaphores drained))
    (semaphore_id original) = true).
  { unfold idmanager_query. cbn [semaphore_manager].
    apply id_in_ids_true_iff. rewrite <- Hid.
    apply in_map. exact Hcurrent. }
  Exists prefix current suffix.
  sep_apply_l_atomic (os_inv_manager_view__manager_selection sg_outside_critical drained).
  Intros_p Hnodup.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; auto.
Qed. 

Lemma proof_of__SemaphoreDelete_which_implies_wit_8_split_goal_1 : _SemaphoreDelete_which_implies_wit_8_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold delete_manager_frame. Intros_p HC.
  dump_pre_spatial. exact HC.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_8_split_goal_spatial : _SemaphoreDelete_which_implies_wit_8_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold delete_manager_frame. Intros_p HC.
  unfold semaphore_context in HC.
  destruct HC as [_ [_ [_ [_ [_ Hhead]]]]].
  rewrite PreH1, map_app. simpl map.
  unfold semaphore_link_node at 2.
  rewrite PreH2, Hhead.
  cancel.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_8 : _SemaphoreDelete_which_implies_wit_8.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreDelete_which_implies_wit_8_split_goal_spatial.
  - Goal_apply proof_of__SemaphoreDelete_which_implies_wit_8_split_goal_1.
Qed. 

Lemma proof_of__SemaphoreDelete_which_implies_wit_9_split_goal_spatial : _SemaphoreDelete_which_implies_wit_9_split_goal_spatial.
Proof.
 LLM_pre_process ltac:(lia || int_auto).
 apply retired_to_raw__retired_raw.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_9 : _SemaphoreDelete_which_implies_wit_9.
Proof.
 aggressive_pre_process.
 Goal_apply proof_of__SemaphoreDelete_which_implies_wit_9_split_goal_spatial.
Qed.

Lemma proof_of__SemaphoreDelete_safety_wit_1 : _SemaphoreDelete_safety_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_safety_wit_2 : _SemaphoreDelete_safety_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_safety_wit_3 : _SemaphoreDelete_safety_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_safety_wit_4 : _SemaphoreDelete_safety_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_safety_wit_5 : _SemaphoreDelete_safety_wit_5.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_safety_wit_6 : _SemaphoreDelete_safety_wit_6.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_safety_wit_7 : _SemaphoreDelete_safety_wit_7.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_safety_wit_8 : _SemaphoreDelete_safety_wit_8.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_safety_wit_9 : _SemaphoreDelete_safety_wit_9.
Proof.
  LLM_pre_process ltac:(congruence).
  all: congruence.
Qed. 


Lemma proof_of__SemaphoreDelete_safety_wit_10 : _SemaphoreDelete_safety_wit_10.
Proof.
  LLM_pre_process ltac:(congruence).
  all: congruence.
Qed. 


Lemma proof_of__SemaphoreDelete_safety_wit_11 : _SemaphoreDelete_safety_wit_11.
Proof.
  LLM_pre_process ltac:(congruence).
  all: congruence.
Qed. 


Lemma proof_of__SemaphoreDelete_safety_wit_12 : _SemaphoreDelete_safety_wit_12.
Proof.
  LLM_pre_process ltac:(congruence).
  all: congruence.
Qed. 


Lemma proof_of__SemaphoreDelete_safety_wit_13 : _SemaphoreDelete_safety_wit_13.
Proof.
  LLM_pre_process ltac:(congruence).
  all: congruence.
Qed. 


Lemma proof_of__SemaphoreDelete_safety_wit_14 : _SemaphoreDelete_safety_wit_14.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_safety_wit_15 : _SemaphoreDelete_safety_wit_15.
Proof.
  LLM_pre_process ltac:(lia || congruence).
Qed. 


Lemma proof_of__SemaphoreDelete_safety_wit_16 : _SemaphoreDelete_safety_wit_16.
Proof.
  LLM_pre_process ltac:(lia || congruence).
Qed. 


Lemma proof_of__SemaphoreDelete_entail_wit_1 : _SemaphoreDelete_entail_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  prop_apply_p (store_int_range (&("id")) id_pre).
  Intros_p Hrange.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; tauto.
Qed. 


Lemma proof_of__SemaphoreDelete_entail_wit_5_1 : _SemaphoreDelete_entail_wit_5_1.
Proof.
  LLM_pre_process ltac:(lia || congruence).
Qed. 


Lemma proof_of__SemaphoreDelete_entail_wit_5_2 : _SemaphoreDelete_entail_wit_5_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_entail_wit_6_1 : _SemaphoreDelete_entail_wit_6_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_entail_wit_6_2 : _SemaphoreDelete_entail_wit_6_2.
Proof.
  LLM_pre_process ltac:(lia || congruence).
Qed. 


Lemma proof_of__SemaphoreDelete_return_wit_1 : _SemaphoreDelete_return_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Exists st_lock.
  split_pure_spatial.
  - cancel (OutsideCritical sg_outside_critical st_lock).
  - dump_pre_spatial. assumption.
Qed. 


Lemma proof_of__SemaphoreDelete_return_wit_3 : _SemaphoreDelete_return_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Exists after_3.
  split_pure_spatial.
  - cancel (OutsideCritical sg_outside_critical after_3).
  - dump_pre_spatial. assumption.
Qed. 


Lemma proof_of__SemaphoreDelete_return_wit_4 : _SemaphoreDelete_return_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Exists after_2.
  split_pure_spatial.
  - cancel (OutsideCritical sg_outside_critical after_2).
  - dump_pre_spatial. assumption.
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_1 : _SemaphoreDelete_partial_solve_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_2 : _SemaphoreDelete_partial_solve_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_3 : _SemaphoreDelete_partial_solve_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreDelete_partial_solve_wit_3_aux.
  intros.
  pose proof (unsigned_Lastnbits_range id_pre 16 ltac:(lia)) as Hrange.
  change (0 <= unsigned_last_nbits id_pre 16 < 65536) in Hrange.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; auto; lia.
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_4_pure : _SemaphoreDelete_partial_solve_wit_4_pure.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_4 : _SemaphoreDelete_partial_solve_wit_4.
Proof.
  LLM_pre_process ltac:(auto).
  unfold _SemaphoreDelete_partial_solve_wit_4_aux. intros.
  split_pure_spatial; [cancel | split_pures; dump_pre_spatial; auto].
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_5 : _SemaphoreDelete_partial_solve_wit_5.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_6_pure : _SemaphoreDelete_partial_solve_wit_6_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_6 : _SemaphoreDelete_partial_solve_wit_6.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreDelete_partial_solve_wit_6_aux.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_7_pure : _SemaphoreDelete_partial_solve_wit_7_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_7 : _SemaphoreDelete_partial_solve_wit_7.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreDelete_partial_solve_wit_7_aux.
  intros.
  subst.
  split_pure_spatial.
  - cancel (os_inv sg_outside_critical st_lock).
    cancel (InsideCritical sg_outside_critical st_lock).
    cancel (&("sem") # Ptr |-> semaphore_addr original).
  - split_pures; dump_pre_spatial; auto.
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_8 : _SemaphoreDelete_partial_solve_wit_8.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_9_pure : _SemaphoreDelete_partial_solve_wit_9_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_9 : _SemaphoreDelete_partial_solve_wit_9.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreDelete_partial_solve_wit_9_aux.
  intros.
  subst.
  split_pure_spatial.
  - cancel (InsideCritical sg_outside_critical st_lock).
    cancel (delete_pending_restore sg_outside_critical st_lock (semaphore_addr original) (semaphore_pending_addrs original)).
    cancel (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st_lock))) &(((original.(semaphore_addr))) # "Semaphore" ->ₛ "pend_list") (map sched_link_node (semaphore_pending_addrs original))).
  - split_pures; dump_pre_spatial; auto.
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_10 : _SemaphoreDelete_partial_solve_wit_10.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreDelete_partial_solve_wit_10_aux.
  intros.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_11_pure : _SemaphoreDelete_partial_solve_wit_11_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst sem. split_pures; dump_pre_spatial; auto.
Qed.


Lemma proof_of__SemaphoreDelete_partial_solve_wit_11 : _SemaphoreDelete_partial_solve_wit_11.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreDelete_partial_solve_wit_11_aux. intros.
  subst sem. split_pure_spatial.
  - cancel (os_inv sg_outside_critical drained).
    cancel (InsideCritical sg_outside_critical st_lock).
    cancel (&( "sem" ) # Ptr |-> semaphore_addr original).
  - split_pures; dump_pre_spatial; auto.
Qed.


Lemma proof_of__SemaphoreDelete_partial_solve_wit_12_pure : _SemaphoreDelete_partial_solve_wit_12_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst sem. split_pures; dump_pre_spatial; auto.
Qed.


Lemma proof_of__SemaphoreDelete_partial_solve_wit_12 : _SemaphoreDelete_partial_solve_wit_12.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreDelete_partial_solve_wit_12_aux. intros.
  subst sem. split_pure_spatial.
  - cancel (os_inv sg_outside_critical drained).
    cancel (InsideCritical sg_outside_critical st_lock).
    cancel (&( "sem" ) # Ptr |-> semaphore_addr original).
  - split_pures; dump_pre_spatial; auto.
Qed.


Lemma proof_of__SemaphoreDelete_partial_solve_wit_13_pure : _SemaphoreDelete_partial_solve_wit_13_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_13 : _SemaphoreDelete_partial_solve_wit_13.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreDelete_partial_solve_wit_13_aux.
  intros.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_14_pure : _SemaphoreDelete_partial_solve_wit_14_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_14 : _SemaphoreDelete_partial_solve_wit_14.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreDelete_partial_solve_wit_14_aux.
  intros.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_15_pure : _SemaphoreDelete_partial_solve_wit_15_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst sem.
  split_pures; dump_pre_spatial; auto.
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_15 : _SemaphoreDelete_partial_solve_wit_15.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreDelete_partial_solve_wit_15_aux. intros.
  subst sem.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; auto.
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_16_pure : _SemaphoreDelete_partial_solve_wit_16_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst sem.
  split_pures; dump_pre_spatial; auto.
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_16 : _SemaphoreDelete_partial_solve_wit_16.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreDelete_partial_solve_wit_16_aux. intros.
  subst sem.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; auto.
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_17 : _SemaphoreDelete_partial_solve_wit_17.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreDelete_partial_solve_wit_17_aux. intros.
  pose proof (unsigned_Lastnbits_range id_pre 16 ltac:(lia)) as Hid.
  change (0 <= unsigned_last_nbits id_pre 16 < 65536) in Hid.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; auto.
    + rewrite PreH19. lia.
    + rewrite PreH19. lia.
    + apply addr_of_LE_var_not_zero.
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_18 : _SemaphoreDelete_partial_solve_wit_18.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreDelete_partial_solve_wit_18_aux. intros.
  pose proof (unsigned_Lastnbits_range id_pre 16 ltac:(lia)) as Hid.
  change (0 <= unsigned_last_nbits id_pre 16 < 65536) in Hid.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; auto.
    + rewrite PreH19. lia.
    + rewrite PreH19. lia.
    + apply addr_of_LE_var_not_zero.
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_19_pure : _SemaphoreDelete_partial_solve_wit_19_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_19 : _SemaphoreDelete_partial_solve_wit_19.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreDelete_partial_solve_wit_19_aux.
  intros. split_pure_spatial.
  - cancel (delete_manager_frame sg_outside_critical drained).
    cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_20_pure : _SemaphoreDelete_partial_solve_wit_20_pure.
Proof.
  LLM_pre_process ltac:(congruence).
  all: congruence.
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_20 : _SemaphoreDelete_partial_solve_wit_20.
Proof.
  LLM_pre_process ltac:(congruence).
  all: unfold _SemaphoreDelete_partial_solve_wit_20_aux; intros; congruence.
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_21_pure : _SemaphoreDelete_partial_solve_wit_21_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_21 : _SemaphoreDelete_partial_solve_wit_21.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreDelete_partial_solve_wit_21_aux.
  intros. split_pure_spatial.
  - cancel (delete_manager_frame sg_outside_critical drained).
    cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_22_pure : _SemaphoreDelete_partial_solve_wit_22_pure.
Proof.
  LLM_pre_process ltac:(congruence).
  all: congruence.
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_22 : _SemaphoreDelete_partial_solve_wit_22.
Proof.
  LLM_pre_process ltac:(congruence).
  all: unfold _SemaphoreDelete_partial_solve_wit_22_aux; intros; congruence.
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_23 : _SemaphoreDelete_partial_solve_wit_23.
Proof.
  LLM_pre_process ltac:(congruence).
  all: congruence.
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_24 : _SemaphoreDelete_partial_solve_wit_24.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_25 : _SemaphoreDelete_partial_solve_wit_25.
Proof.
  LLM_pre_process ltac:(congruence).
  all: congruence.
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_26 : _SemaphoreDelete_partial_solve_wit_26.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_27_pure : _SemaphoreDelete_partial_solve_wit_27_pure.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_27 : _SemaphoreDelete_partial_solve_wit_27.
Proof.
  LLM_pre_process ltac:(auto).
  unfold _SemaphoreDelete_partial_solve_wit_27_aux. intros.
  split_pure_spatial; [cancel | split_pures; dump_pre_spatial; auto].
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_28_pure : _SemaphoreDelete_partial_solve_wit_28_pure.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_28 : _SemaphoreDelete_partial_solve_wit_28.
Proof.
  LLM_pre_process ltac:(auto).
  unfold _SemaphoreDelete_partial_solve_wit_28_aux. intros.
  split_pure_spatial; [cancel | split_pures; dump_pre_spatial; auto].
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_29 : _SemaphoreDelete_partial_solve_wit_29.
Proof.
 LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_30 : _SemaphoreDelete_partial_solve_wit_30.
Proof.
 LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_31 : _SemaphoreDelete_partial_solve_wit_31.
Proof.
 LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_32 : _SemaphoreDelete_partial_solve_wit_32.
Proof.
 LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_33_pure : _SemaphoreDelete_partial_solve_wit_33_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_33 : _SemaphoreDelete_partial_solve_wit_33.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  LLM_pre_process ltac:(lia || int_auto).
Qed.
