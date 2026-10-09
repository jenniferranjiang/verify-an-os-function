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
From CRTOS_Verify.VC Require Import _SemaphoreCreate_goal.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.sem.CrtosOSProtocol.
Import CrtosOS_C_Rules.
Require Import Coq.Lists.List.
Require Import CRTOS_Verify.lib.CrtosGlobState.
Require Import CRTOS_Verify.sem.SemaphorePure.
Require Import CRTOS_Verify.sem.CrtosOSPure.
Require Import CRTOS_Verify.sem.SemaphoreProtocol.
Require Import CRTOS_Verify.sem.SemaphoreRep.
Require Import CRTOS_Verify.sem.CrtosOSRep.
Require Import CRTOS_Verify.sem.SemaphoreCritical.
Require Import CRTOS_Verify.VC.SemaphoreProofLocal.
From MonadLib.StateRelMonad Require Import StateRelBasic safeexec_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Local Open Scope sac.

Lemma proof_of__SemaphoreCreate_return_wit_1_split_goal_1 : _SemaphoreCreate_return_wit_1_split_goal_1.
Proof.
  unfold _SemaphoreCreate_return_wit_1_split_goal_1. intros.
  eapply safeExec_abs_create_success_local; eauto.
Qed.

Lemma proof_of__SemaphoreCreate_return_wit_1_split_goal_2 : _SemaphoreCreate_return_wit_1_split_goal_2.
Proof.
  unfold _SemaphoreCreate_return_wit_1_split_goal_2. intros.
  pose proof (semaphore_first_free_some_bound_local
    (crtos_semaphore_stable stable) (crtos_semaphore_state current_3)
    retval PreH6 PreH9) as Hbound.
  unfold SemaphoreStableContext in PreH6.
  destruct PreH6 as (Hm & Hb & Hba & Hr & Hil & Hbc).
  rewrite Hil in Hbound. unfold SEM_ID_MAX in Hbound. lia.
Qed.

Lemma proof_of__SemaphoreCreate_return_wit_1 : _SemaphoreCreate_return_wit_1.
Proof.
  right.
  intros. entailer!.
  - pose proof (semaphore_first_free_some_bound_local
      (crtos_semaphore_stable stable) (crtos_semaphore_state current_3)
      retval PreH6 PreH9) as Hbound.
    unfold SemaphoreStableContext in PreH6.
    destruct PreH6 as (Hm & Hb & Hba & Hr & Hil & Hbc).
    rewrite Hil in Hbound. unfold SEM_ID_MAX in Hbound. lia.
  - eapply safeExec_abs_create_success_local; eauto.
Qed.

Lemma proof_of__SemaphoreCreate_return_wit_2_split_goal_1 : _SemaphoreCreate_return_wit_2_split_goal_1.
Proof.
  unfold _SemaphoreCreate_return_wit_2_split_goal_1. intros.
  change (-5) with SEM_NO_MEMORY.
  eapply safeExec_abs_create_failure_local; eauto.
Qed.

Lemma proof_of__SemaphoreCreate_return_wit_2 : _SemaphoreCreate_return_wit_2.
Proof.
  right.
  intros. entailer!.
  change (-5) with SEM_NO_MEMORY.
  eapply safeExec_abs_create_failure_local; eauto.
Qed.

Lemma proof_of__SemaphoreCreate_return_wit_3_split_goal_1 : _SemaphoreCreate_return_wit_3_split_goal_1.
Proof.
  unfold _SemaphoreCreate_return_wit_3_split_goal_1. intros.
  change (-5) with SEM_NO_MEMORY.
  eapply safeExec_abs_create_failure_local;
    [apply SemaphoreRely_refl | exact PreH6].
Qed.

Lemma proof_of__SemaphoreCreate_return_wit_3_split_goal_2 : _SemaphoreCreate_return_wit_3_split_goal_2.
Proof.
  unfold _SemaphoreCreate_return_wit_3_split_goal_2. intros.
  apply SemaphoreRely_refl.
Qed.

Lemma proof_of__SemaphoreCreate_return_wit_3 : _SemaphoreCreate_return_wit_3.
Proof.
  right.
  intros. entailer!.
  - apply SemaphoreRely_refl.
  - change (-5) with SEM_NO_MEMORY.
    eapply safeExec_abs_create_failure_local;
      [apply SemaphoreRely_refl | exact PreH6].
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_5_pure_split_goal_1 : _SemaphoreCreate_partial_solve_wit_5_pure_split_goal_1.
Proof.
  unfold _SemaphoreCreate_partial_solve_wit_5_pure_split_goal_1. intros.
  entailer!. apply addr_of_LE_var_not_zero.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_5_pure_split_goal_2 : _SemaphoreCreate_partial_solve_wit_5_pure_split_goal_2.
Proof.
  unfold _SemaphoreCreate_partial_solve_wit_5_pure_split_goal_2. intros.
  unfold semaphore_layout_32_ok in PreH5.
  destruct PreH5 as
    (Hsize & Hidbase & Hidfield & Hidlink & Hidnext & Hidprev &
     Hnid & Hnlink & Hnnext & Hnprev & Hvalue & Hpend &
     Hpnext & Hpprev & Hnpnext & Hnpprev & Hreg &
     Hrnext & Hrprev & Hnrnext & Hnrprev).
  entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_5_pure_split_goal_3 : _SemaphoreCreate_partial_solve_wit_5_pure_split_goal_3.
Proof.
  unfold _SemaphoreCreate_partial_solve_wit_5_pure_split_goal_3. intros.
  unfold crtos_semaphore_nonsem_frame. Intros. entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_5_pure_split_goal_4 : _SemaphoreCreate_partial_solve_wit_5_pure_split_goal_4.
Proof.
  unfold _SemaphoreCreate_partial_solve_wit_5_pure_split_goal_4. intros.
  unfold crtos_semaphore_nonsem_frame. Intros.
  unfold SemaphoreStableContext in *. entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_5_pure : _SemaphoreCreate_partial_solve_wit_5_pure.
Proof.
  right. intros.
  unfold crtos_semaphore_nonsem_frame. Intros.
  unfold SemaphoreStableContext in *. entailer!.
  - unfold semaphore_layout_32_ok in PreH5. entailer!.
  - apply addr_of_LE_var_not_zero.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_9_pure_split_goal_1 : _SemaphoreCreate_partial_solve_wit_9_pure_split_goal_1.
Proof.
  unfold _SemaphoreCreate_partial_solve_wit_9_pure_split_goal_1. intros.
  entailer!. apply SemaphoreGuarantee_refl.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_9_pure : _SemaphoreCreate_partial_solve_wit_9_pure.
Proof. right. exact proof_of__SemaphoreCreate_partial_solve_wit_9_pure_split_goal_1. Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_11_pure_split_goal_1 : _SemaphoreCreate_partial_solve_wit_11_pure_split_goal_1.
Proof.
  unfold _SemaphoreCreate_partial_solve_wit_11_pure_split_goal_1. intros.
  sep_apply (valid_store_ushort (&(retval # "Semaphore" ->ₛ "value")) val_pre).
  Intros.
  unfold semaphore_layout_32_ok in PreH10.
  destruct PreH10 as
    (Hsize & Hidbase & Hidfield & Hidlink & Hidnext & Hidprev &
     Hnid & Hnlink & Hnnext & Hnprev & Hvalue & Hpend &
     Hpnext & Hpprev & Hnpnext & Hnpprev & Hreg &
     Hrnext & Hrprev & Hnrnext & Hnrprev).
  unfold isvalidptr_short in H. rewrite Hvalue in H.
  entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_11_pure : _SemaphoreCreate_partial_solve_wit_11_pure.
Proof. right. exact proof_of__SemaphoreCreate_partial_solve_wit_11_pure_split_goal_1. Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_14_pure_split_goal_1 : _SemaphoreCreate_partial_solve_wit_14_pure_split_goal_1.
Proof.
  unfold _SemaphoreCreate_partial_solve_wit_14_pure_split_goal_1. intros.
  unfold store_sem_standalone_node, store_semaphore_body. simpl.
  Intros.
  sep_apply (valid_store_ushort (&(retval # "Semaphore" ->ₛ "value")) val_pre).
  Intros.
  unfold semaphore_layout_32_ok in PreH10.
  destruct PreH10 as
    (Hsize & Hidbase & Hidfield & Hidlink & Hidnext & Hidprev &
     Hnid & Hnlink & Hnnext & Hnprev & Hvalue & Hpend &
     Hpnext & Hpprev & Hnpnext & Hnpprev & Hreg &
     Hrnext & Hrprev & Hnrnext & Hnrprev).
  entailer!.
  destruct H0 as [_ Hvalid].
  unfold isvalidptr_short in Hvalid. rewrite Hvalue in Hvalid.
  rewrite Hreg. lia.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_14_pure : _SemaphoreCreate_partial_solve_wit_14_pure.
Proof. right. exact proof_of__SemaphoreCreate_partial_solve_wit_14_pure_split_goal_1. Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_15_pure_split_goal_1 : _SemaphoreCreate_partial_solve_wit_15_pure_split_goal_1.
Proof.
  unfold _SemaphoreCreate_partial_solve_wit_15_pure_split_goal_1. intros.
  pose proof (semaphore_first_free_some_bound_local
    (crtos_semaphore_stable stable) (crtos_semaphore_state current)
    retval_2 PreH9 PreH12) as Hbound.
  unfold SemaphoreStableContext in PreH9.
  destruct PreH9 as (Hm & Hb & Hba & Hr & Hil & Hbc).
  rewrite Hil in Hbound. unfold SEM_ID_MAX in Hbound. entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_15_pure : _SemaphoreCreate_partial_solve_wit_15_pure.
Proof. right. exact proof_of__SemaphoreCreate_partial_solve_wit_15_pure_split_goal_1. Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_16_pure_split_goal_1 : _SemaphoreCreate_partial_solve_wit_16_pure_split_goal_1.
Proof.
  unfold _SemaphoreCreate_partial_solve_wit_16_pure_split_goal_1. intros.
  entailer!.
  eapply SemaphoreGuarantee_create_local; eauto.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_16_pure : _SemaphoreCreate_partial_solve_wit_16_pure.
Proof. right. exact proof_of__SemaphoreCreate_partial_solve_wit_16_pure_split_goal_1. Qed.

Lemma proof_of__SemaphoreCreate_which_implies_wit_1_split_goal_1 : _SemaphoreCreate_which_implies_wit_1_split_goal_1.
Proof.
  unfold _SemaphoreCreate_which_implies_wit_1_split_goal_1. intros.
  unfold crtos_semaphore_os_inv, semaphore_inv. Intros.
  sep_apply (store_semaphore_registry_zeroed_fresh_local
    (crtos_semaphore_stable stable) (crtos_semaphore_state current) sem).
  Intros. entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_which_implies_wit_1_split_goal_2 : _SemaphoreCreate_which_implies_wit_1_split_goal_2.
Proof.
  unfold _SemaphoreCreate_which_implies_wit_1_split_goal_2. intros.
  unfold crtos_semaphore_os_inv. Intros. entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_which_implies_wit_1_split_goal_3 : _SemaphoreCreate_which_implies_wit_1_split_goal_3.
Proof.
  unfold _SemaphoreCreate_which_implies_wit_1_split_goal_3. intros.
  unfold store_sem_zeroed_private. Intros. entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_which_implies_wit_1_split_goal_spatial : _SemaphoreCreate_which_implies_wit_1_split_goal_spatial.
Proof.
  unfold _SemaphoreCreate_which_implies_wit_1_split_goal_spatial. intros.
  unfold crtos_semaphore_os_inv, semaphore_inv,
    crtos_semaphore_nonsem_frame, store_sem_zeroed_private,
    store_sem_id_node_zeroed, store_sem_after_id_insert_private.
  Intros. entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_which_implies_wit_1 : _SemaphoreCreate_which_implies_wit_1.
Proof.
  right. intros.
  unfold crtos_semaphore_os_inv, semaphore_inv.
  Intros.
  sep_apply (store_semaphore_registry_zeroed_fresh_local
    (crtos_semaphore_stable stable) (crtos_semaphore_state current) sem).
  Intros.
  unfold crtos_semaphore_nonsem_frame, store_sem_zeroed_private,
    store_sem_id_node_zeroed, store_sem_after_id_insert_private.
  Intros. entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_which_implies_wit_2_split_goal_spatial : _SemaphoreCreate_which_implies_wit_2_split_goal_spatial.
Proof.
  unfold _SemaphoreCreate_which_implies_wit_2_split_goal_spatial. intros.
  unfold store_sem_id_node_zeroed, store_sem_after_id_insert_private,
    store_sem_zeroed_private.
  Intros. entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_which_implies_wit_2 : _SemaphoreCreate_which_implies_wit_2.
Proof. right. exact proof_of__SemaphoreCreate_which_implies_wit_2_split_goal_spatial. Qed.

Lemma proof_of__SemaphoreCreate_which_implies_wit_3_split_goal_spatial : _SemaphoreCreate_which_implies_wit_3_split_goal_spatial.
Proof.
  unfold _SemaphoreCreate_which_implies_wit_3_split_goal_spatial. intros.
  unfold crtos_semaphore_nonsem_frame, crtos_semaphore_os_inv, semaphore_inv.
  Intros. unfold crtos_os_world_wf in *. entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_which_implies_wit_3 : _SemaphoreCreate_which_implies_wit_3.
Proof. right. exact proof_of__SemaphoreCreate_which_implies_wit_3_split_goal_spatial. Qed.

Lemma proof_of__SemaphoreCreate_which_implies_wit_4_split_goal_1 : _SemaphoreCreate_which_implies_wit_4_split_goal_1.
Proof.
  unfold _SemaphoreCreate_which_implies_wit_4_split_goal_1. intros.
  unfold store_sem_after_id_insert_private. Intros. entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_which_implies_wit_4_split_goal_spatial : _SemaphoreCreate_which_implies_wit_4_split_goal_spatial.
Proof.
  unfold _SemaphoreCreate_which_implies_wit_4_split_goal_spatial. intros.
  unfold store_sem_after_id_insert_private. Intros. entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_which_implies_wit_4 : _SemaphoreCreate_which_implies_wit_4.
Proof.
  right. intros. unfold store_sem_after_id_insert_private. Intros. entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_which_implies_wit_5_split_goal_spatial : _SemaphoreCreate_which_implies_wit_5_split_goal_spatial.
Proof.
  unfold _SemaphoreCreate_which_implies_wit_5_split_goal_spatial. intros.
  unfold store_semaphore_registry.
  unfold SemaphoreStableContext in PreH1.
  destruct PreH1 as (Hm & Hb & Hba & Hr & Hil & Hbc).
  rewrite Hr. entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_which_implies_wit_5 : _SemaphoreCreate_which_implies_wit_5.
Proof. right. exact proof_of__SemaphoreCreate_which_implies_wit_5_split_goal_spatial. Qed.

Lemma proof_of__SemaphoreCreate_which_implies_wit_6_split_goal_spatial : _SemaphoreCreate_which_implies_wit_6_split_goal_spatial.
Proof.
  unfold _SemaphoreCreate_which_implies_wit_6_split_goal_spatial. intros.
  pose proof PreH2 as Hlayout.
  unfold semaphore_layout_32_ok in Hlayout.
  destruct Hlayout as
    (Hsize & Hidbase & Hidfield & Hidlink & Hidnext & Hidprev &
     Hnid & Hnlink & Hnnext & Hnprev & Hvalue & Hpend &
     Hpnext & Hpprev & Hnpnext & Hnpprev & Hreg &
     Hrnext & Hrprev & Hnrnext & Hnrprev).
  unfold store_sem_standalone_node, store_semaphore_body,
    store_semaphore_pending_list. simpl.
  sep_apply (store_sem_dll_empty_change_payload_local semaphore_unit_empty
    (fun _ (_ : unit) => emp) (&(sem # "Semaphore" ->ₛ "pend_list"))).
  rewrite Hrprev, Hnrprev, Hrnext, Hnrnext. entailer!.
  unfold store_sem_body_padding_zero.
  sep_apply (store_ptr_undef_store_ptr (sem + 24) 0).
  sep_apply (store_ptr_undef_store_ptr (sem + 28) 0).
  entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_which_implies_wit_6 : _SemaphoreCreate_which_implies_wit_6.
Proof. right. exact proof_of__SemaphoreCreate_which_implies_wit_6_split_goal_spatial. Qed.

Lemma proof_of__SemaphoreCreate_which_implies_wit_7_split_goal_1 : _SemaphoreCreate_which_implies_wit_7_split_goal_1.
Proof.
  unfold _SemaphoreCreate_which_implies_wit_7_split_goal_1. intros.
  entailer!.
  eapply crtos_os_world_wf_create_local; eauto.
Qed.

Lemma proof_of__SemaphoreCreate_which_implies_wit_7_split_goal_spatial : _SemaphoreCreate_which_implies_wit_7_split_goal_spatial.
Proof.
  unfold _SemaphoreCreate_which_implies_wit_7_split_goal_spatial. intros.
  unfold crtos_semaphore_nonsem_frame, crtos_semaphore_os_inv, semaphore_inv.
  simpl. Intros. entailer!.
  - sep_apply (store_crtos_task_desc_map_create_empty_local
      current sem id val_pre).
    sep_apply (store_semaphore_id_manager_reserve_create_local
      (crtos_semaphore_stable stable) (crtos_semaphore_state current)
      sem id val_pre).
    unfold store_semaphore_registry, semaphore_create_state. simpl.
    unfold SemaphoreStableContext in *. entailer!.
    assert (Hregaddr :
      semaphore_registry_addr (crtos_semaphore_stable stable) =
        &("k_sem_list")) by tauto.
    rewrite Hregaddr. entailer!.
  - pose proof PreH6 as Hworld.
    unfold crtos_os_world_wf in Hworld.
    destruct Hworld as (Htask & Hsemwf & Hbridge & Hscheduler).
    eapply semaphore_state_wf_create_local; eauto.
  - eapply crtos_os_world_wf_create_local; eauto.
Qed.

Lemma proof_of__SemaphoreCreate_which_implies_wit_7 : _SemaphoreCreate_which_implies_wit_7.
Proof.
  right. intros. entailer!.
  - unfold crtos_semaphore_nonsem_frame, crtos_semaphore_os_inv, semaphore_inv.
    simpl. Intros. entailer!.
  + sep_apply (store_crtos_task_desc_map_create_empty_local
      current sem id val_pre).
    sep_apply (store_semaphore_id_manager_reserve_create_local
      (crtos_semaphore_stable stable) (crtos_semaphore_state current)
      sem id val_pre).
    unfold store_semaphore_registry, semaphore_create_state. simpl.
    unfold SemaphoreStableContext in *. entailer!.
    assert (Hregaddr :
      semaphore_registry_addr (crtos_semaphore_stable stable) =
        &("k_sem_list")) by tauto.
    rewrite Hregaddr. entailer!.
  + pose proof PreH6 as Hworld.
    unfold crtos_os_world_wf in Hworld.
    destruct Hworld as (Htask & Hsemwf & Hbridge & Hscheduler).
    eapply semaphore_state_wf_create_local; eauto.
  + eapply crtos_os_world_wf_create_local; eauto.
  - eapply crtos_os_world_wf_create_local; eauto.
Qed.
