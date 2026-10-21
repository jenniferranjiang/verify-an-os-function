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
From CRTOS_Verify.VC Require Import SemaphoreCreate_goal.
From CRTOS_Verify.VC Require Import SemaphoreCreate_proof_auto.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import KSemaphoreCreateTrial.KSemaphoreCreate.
Require Import TrialShared.CrtosInv TrialShared.SemaphoreInv.
Import IDNode DLL.
From MonadLib.MonadErr
      Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.VC.SemaphoreCreate_lib.
Local Open Scope sac.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_1 : _SemaphoreCreate_entail_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_2 : _SemaphoreCreate_entail_wit_1_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1 : _SemaphoreCreate_entail_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto || reflexivity).
  all: unfold store_ushort; Intros; entailer_with ltac:(lia || assumption).
Qed. 

Lemma proof_of__SemaphoreCreate_entail_wit_2_split_goal_1 : _SemaphoreCreate_entail_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_2_split_goal_2 : _SemaphoreCreate_entail_wit_2_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_2 : _SemaphoreCreate_entail_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold SemaphoreRaw, NodeStorage.
  Intros.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; tauto.
Qed. 

Lemma proof_of__SemaphoreCreate_entail_wit_3_split_goal_1 : _SemaphoreCreate_entail_wit_3_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv, semaphore_inv.
  Intros_p Hwf. Intros_p Hctx.
  prop_apply_p (fresh_semaphore__raw_open
    (pure_suspend_sched_link (task_desc_map (os_tasks locked)))
    (semaphore_list_head (os_semaphore_stable sg)) (os_semaphores locked) sem).
  Intros_p Hfresh. dump_pre_spatial. exact Hfresh.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_3_split_goal_2 : _SemaphoreCreate_entail_wit_3_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv, semaphore_inv.
  Intros_p Hwf. Intros_p Hctx.
  unfold store_dll at 1.
  Intros h pt.
  dump_pre_spatial. tauto.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_3_split_goal_3 : _SemaphoreCreate_entail_wit_3_split_goal_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv, semaphore_inv.
  Intros_p Hwf. Intros_p Hctx.
  dump_pre_spatial. exact Hctx.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_3_split_goal_4 : _SemaphoreCreate_entail_wit_3_split_goal_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv. Intros_p Hwf.
  dump_pre_spatial. exact Hwf.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_3_split_goal_5 : _SemaphoreCreate_entail_wit_3_split_goal_5.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold SemaphoreZero. Intros_p Hzero.
  dump_pre_spatial. tauto.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_3_split_goal_spatial : _SemaphoreCreate_entail_wit_3_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv, semaphore_inv, SemaphoreZero.
  Intros.
  match goal with H : semaphore_context _ |- _ =>
    pose proof H as Hctx; unfold semaphore_context in Hctx;
    destruct Hctx as [Hm [_ [_ [_ [_ Hl]]]]]; rewrite Hm, Hl
  end.
  cancel.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_3 : _SemaphoreCreate_entail_wit_3.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_3_split_goal_spatial.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_3_split_goal_1.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_3_split_goal_2.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_3_split_goal_3.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_3_split_goal_4.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_3_split_goal_5.
Qed. 

Lemma proof_of__SemaphoreCreate_entail_wit_4_split_goal_spatial : _SemaphoreCreate_entail_wit_4_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv, semaphore_inv, SemaphoreZero.
  match goal with H : semaphore_context _ |- _ =>
    pose proof H as Hctx; unfold semaphore_context in Hctx;
    destruct Hctx as [Hm [_ [_ [_ [_ Hl]]]]]; rewrite Hm, Hl
  end.
  split_pure_spatial.
  - sepcon_right_assoc. cancel.
  - split_pures; dump_pre_spatial; tauto.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_4 : _SemaphoreCreate_entail_wit_4.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreCreate_entail_wit_4_split_goal_spatial.
Qed. 

Lemma proof_of__SemaphoreCreate_entail_wit_5_split_goal_1 : _SemaphoreCreate_entail_wit_5_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold semaphore_context in *.
  dump_pre_spatial. intuition lia.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_5_split_goal_spatial : _SemaphoreCreate_entail_wit_5_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  sep_apply_l_atomic (list_cut__list_prepare (pure_suspend_sched_link (task_desc_map (os_tasks locked))) (os_semaphore_stable sg) (os_semaphores locked) (&(sem # "Semaphore" ->ₛ "link")) PreH15 PreH10).
  sep_apply_l_atomic (node_zero_storage__list_prepare (&(sem # "Semaphore" ->ₛ "pend_list")) PreH9).
  repeat progress cancel.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_5 : _SemaphoreCreate_entail_wit_5.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_5_split_goal_spatial.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_5_split_goal_1.
Qed. 

Lemma proof_of__SemaphoreCreate_entail_wit_6_split_goal_1 : _SemaphoreCreate_entail_wit_6_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).

Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_6_split_goal_spatial : _SemaphoreCreate_entail_wit_6_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  cancel (InsideCritical sg locked).
  sep_apply_l_atomic (publish_resources__publish val_pre sg locked sem id
    PreH3 PreH4 PreH5 PreH6 PreH7 PreH8 PreH14 PreH15 PreH16).
  cancel.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_6 : _SemaphoreCreate_entail_wit_6.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_6_split_goal_spatial.
Qed. 

Lemma proof_of__SemaphoreCreate_return_wit_1_split_goal_1 : _SemaphoreCreate_return_wit_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold abs_semaphore_create in PreH8 at 1.
  prog_nf in PreH8.
  safe_choice_r PreH8.
  eapply (highstependret_derive (task_atomic_cmd (abs_semaphore_create_locked sg val_pre)) (LastSeen before) id (fun _ => LastSeen (replace_semaphores (semaphore_publish sem id val_pre (os_semaphores locked)) locked))).
  - intros states Hstates.
    exists (Crtos_RTrans (replace_semaphores (semaphore_publish sem id val_pre (os_semaphores locked)) locked)).
    split.
    + exists locked, (replace_semaphores (semaphore_publish sem id val_pre (os_semaphores locked)) locked).
      split.
      * apply Hstates. exact PreH7.
      * split.
        -- cbn. right. exists sem. repeat first [assumption | reflexivity | split].
        -- reflexivity.
    + unfold LastSeen. reflexivity.
  - exact PreH8.
Qed.

Lemma proof_of__SemaphoreCreate_return_wit_1 : _SemaphoreCreate_return_wit_1.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreCreate_return_wit_1_split_goal_1.
Qed. 

Lemma proof_of__SemaphoreCreate_return_wit_2_split_goal_1 : _SemaphoreCreate_return_wit_2_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold abs_semaphore_create in PreH8 at 1.
  prog_nf in PreH8.
  safe_choice_r PreH8.
  eapply (highstependret_derive (task_atomic_cmd (abs_semaphore_create_locked sg val_pre)) (LastSeen before) (-5) (fun _ => LastSeen locked)).
  - intros states Hstates.
    exists (Crtos_RTrans locked).
    split.
    + exists locked, locked.
      split.
      * apply Hstates. exact PreH7.
      * split.
        -- cbn. left. repeat first [assumption | reflexivity | split].
        -- reflexivity.
    + unfold LastSeen. reflexivity.
  - exact PreH8.
Qed.

Lemma proof_of__SemaphoreCreate_return_wit_2 : _SemaphoreCreate_return_wit_2.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreCreate_return_wit_2_split_goal_1.
Qed. 

Lemma proof_of__SemaphoreCreate_return_wit_3_split_goal_1 : _SemaphoreCreate_return_wit_3_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold abs_semaphore_create in PreH5 at 1.
  prog_nf in PreH5.
  safe_choice_l PreH5.
  exact PreH5.
Qed.

Lemma proof_of__SemaphoreCreate_return_wit_3 : _SemaphoreCreate_return_wit_3.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreCreate_return_wit_3_split_goal_1.
Qed. 

Lemma proof_of__SemaphoreCreate_partial_solve_wit_4_pure_split_goal_1 : _SemaphoreCreate_partial_solve_wit_4_pure_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial. apply addr_of_LE_var_not_zero.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_4_pure_split_goal_2 : _SemaphoreCreate_partial_solve_wit_4_pure_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold ZeroIdNode. Intros. entailer_with ltac:(tauto).
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_4_pure : _SemaphoreCreate_partial_solve_wit_4_pure.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreCreate_partial_solve_wit_4_pure_split_goal_1.
  - Goal_apply proof_of__SemaphoreCreate_partial_solve_wit_4_pure_split_goal_2.
Qed. 

Lemma proof_of__SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1 : _SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto || reflexivity).
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_6_pure : _SemaphoreCreate_partial_solve_wit_6_pure.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1.
Qed.

Lemma proof_of__SemaphoreCreate_safety_wit_1 : _SemaphoreCreate_safety_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_2 : _SemaphoreCreate_safety_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_3 : _SemaphoreCreate_safety_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_4 : _SemaphoreCreate_safety_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_5 : _SemaphoreCreate_safety_wit_5.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_6 : _SemaphoreCreate_safety_wit_6.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_7 : _SemaphoreCreate_safety_wit_7.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_8 : _SemaphoreCreate_safety_wit_8.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_9 : _SemaphoreCreate_safety_wit_9.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_10 : _SemaphoreCreate_safety_wit_10.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_11 : _SemaphoreCreate_safety_wit_11.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_12 : _SemaphoreCreate_safety_wit_12.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_13 : _SemaphoreCreate_safety_wit_13.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_14 : _SemaphoreCreate_safety_wit_14.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_15 : _SemaphoreCreate_safety_wit_15.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_16 : _SemaphoreCreate_safety_wit_16.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_17 : _SemaphoreCreate_safety_wit_17.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_18 : _SemaphoreCreate_safety_wit_18.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_1_pure : _SemaphoreCreate_partial_solve_wit_1_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto || reflexivity).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_1 : _SemaphoreCreate_partial_solve_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto || reflexivity).
  unfold _SemaphoreCreate_partial_solve_wit_1_aux. intros.
  entailer_with ltac:(lia || int_auto || reflexivity).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_2_pure : _SemaphoreCreate_partial_solve_wit_2_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto || reflexivity).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_2 : _SemaphoreCreate_partial_solve_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto || reflexivity).
  unfold _SemaphoreCreate_partial_solve_wit_2_aux. intros.
  entailer_with ltac:(lia || int_auto || reflexivity).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_3 : _SemaphoreCreate_partial_solve_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto || reflexivity).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_4 : _SemaphoreCreate_partial_solve_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreCreate_partial_solve_wit_4_aux. intros.
  pose proof (addr_of_LE_var_not_zero "k_sem_id_manager") as Hmanager.
  unfold ZeroIdNode. Intros. entailer_with ltac:(tauto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_5 : _SemaphoreCreate_partial_solve_wit_5.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_6 : _SemaphoreCreate_partial_solve_wit_6.
Proof.
  LLM_pre_process ltac:(lia || int_auto || reflexivity).
  unfold _SemaphoreCreate_partial_solve_wit_6_aux. intros.
  entailer_with ltac:(lia || int_auto || reflexivity).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_7 : _SemaphoreCreate_partial_solve_wit_7.
Proof.
  LLM_pre_process ltac:(eauto; lia).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_8 : _SemaphoreCreate_partial_solve_wit_8.
Proof.
  LLM_pre_process ltac:(eauto; lia).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_9_pure : _SemaphoreCreate_partial_solve_wit_9_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).

Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_9 : _SemaphoreCreate_partial_solve_wit_9.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  all: try unfold _SemaphoreCreate_partial_solve_wit_9_aux.
  all: intros; split_pure_spatial; [cancel | split_pures; dump_pre_spatial; assumption].
Qed.
