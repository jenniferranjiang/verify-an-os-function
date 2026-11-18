From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.dataqueue Require Import DeInitDataqueue_goal.
From CRTOS_Verify.VC.dataqueue Require Import DeInitDataqueue_proof_auto.
Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Local Open Scope sac.


Lemma proof_of_DeInitDataqueue_safety_wit_1 : DeInitDataqueue_safety_wit_1.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_safety_wit_2 : DeInitDataqueue_safety_wit_2.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_safety_wit_3 : DeInitDataqueue_safety_wit_3.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_safety_wit_4 : DeInitDataqueue_safety_wit_4.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_safety_wit_5 : DeInitDataqueue_safety_wit_5.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_safety_wit_6 : DeInitDataqueue_safety_wit_6.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_safety_wit_7 : DeInitDataqueue_safety_wit_7.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_safety_wit_8 : DeInitDataqueue_safety_wit_8.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_safety_wit_9 : DeInitDataqueue_safety_wit_9.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_safety_wit_10 : DeInitDataqueue_safety_wit_10.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_safety_wit_11 : DeInitDataqueue_safety_wit_11.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_safety_wit_12 : DeInitDataqueue_safety_wit_12.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_safety_wit_13 : DeInitDataqueue_safety_wit_13.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_safety_wit_14 : DeInitDataqueue_safety_wit_14.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_safety_wit_15 : DeInitDataqueue_safety_wit_15.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_safety_wit_16 : DeInitDataqueue_safety_wit_16.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_entail_wit_2_1 : DeInitDataqueue_entail_wit_2_1.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_entail_wit_2_2 : DeInitDataqueue_entail_wit_2_2.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_entail_wit_3_1 : DeInitDataqueue_entail_wit_3_1.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_entail_wit_3_2 : DeInitDataqueue_entail_wit_3_2.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_return_wit_1 : DeInitDataqueue_return_wit_1.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_1 : DeInitDataqueue_partial_solve_wit_1.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_2 : DeInitDataqueue_partial_solve_wit_2.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_3_pure : DeInitDataqueue_partial_solve_wit_3_pure.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_3 : DeInitDataqueue_partial_solve_wit_3.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_4_pure : DeInitDataqueue_partial_solve_wit_4_pure.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_4 : DeInitDataqueue_partial_solve_wit_4.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_5_pure : DeInitDataqueue_partial_solve_wit_5_pure.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_5 : DeInitDataqueue_partial_solve_wit_5.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_6_pure : DeInitDataqueue_partial_solve_wit_6_pure.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_6 : DeInitDataqueue_partial_solve_wit_6.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_7_pure : DeInitDataqueue_partial_solve_wit_7_pure.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_7 : DeInitDataqueue_partial_solve_wit_7.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_8_pure : DeInitDataqueue_partial_solve_wit_8_pure.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_8 : DeInitDataqueue_partial_solve_wit_8.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_entail_wit_1_split_goal_1 : DeInitDataqueue_entail_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of_DeInitDataqueue_entail_wit_1_split_goal_2 : DeInitDataqueue_entail_wit_1_split_goal_2.
Proof. Abort.

Lemma proof_of_DeInitDataqueue_entail_wit_1 : DeInitDataqueue_entail_wit_1.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_1 : DeInitDataqueue_entail_wit_4_1_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
rewrite PreH10.
unfold semaphore_delete_ic_effect in PreH1.
destruct PreH1 as [[Hinvalid Heq] | [Hvalid [[Hmiss Heq] | [s [Hin [Hid [Hpend Heq]]]]]]].
- subst after; exact PreH15.
- subst after; exact PreH15.
- subst after. unfold semaphore_delete_quiescent in *. intros Hrange.
  specialize (PreH15 Hrange). destruct PreH15 as [Htasks Hqueues].
  split.
  + intros t Ht Hid2. cbn [replace_semaphores] in Ht.
    unfold semaphore_unpublish in Ht. apply filter_In in Ht.
    apply Htasks; tauto.
  + intros p q Hq. cbn [replace_semaphores] in Hq.
    exact (Hqueues p q Hq).
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_2 : DeInitDataqueue_entail_wit_4_1_split_goal_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
cbn [dataqueue_retired dq_sem_blank].
destruct (Z.leb 0 (dq_sem_blank q_init_cleanup)) eqn:Hsign; [reflexivity|].
apply Z.leb_gt in Hsign. lia.
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_3 : DeInitDataqueue_entail_wit_4_1_split_goal_3.
Proof.
LLM_pre_process ltac:(lia || int_auto).
cbn [dataqueue_retired dq_sem_blank].
destruct (Z.leb 0 (dq_sem_blank q_init_cleanup)) eqn:Hsign; [reflexivity|].
apply Z.leb_gt in Hsign. lia.
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_1 : DeInitDataqueue_entail_wit_4_1.
Proof.
aggressive_pre_process.
Goal_apply proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_1.
Goal_apply proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_2.
Goal_apply proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_3.
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_1 : DeInitDataqueue_entail_wit_4_2_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
rewrite PreH10.
unfold semaphore_delete_ic_effect in PreH1.
destruct PreH1 as [[Hinvalid Heq] | [Hvalid [[Hmiss Heq] | [s [Hin [Hid [Hpend Heq]]]]]]].
- subst after; exact PreH16.
- subst after; exact PreH16.
- subst after. unfold semaphore_delete_quiescent in *. intros Hrange.
  specialize (PreH16 Hrange). destruct PreH16 as [Htasks Hqueues].
  split.
  + intros t Ht Hid2. cbn [replace_semaphores] in Ht.
    unfold semaphore_unpublish in Ht. apply filter_In in Ht.
    apply Htasks; tauto.
  + intros p q Hq. cbn [replace_semaphores] in Hq.
    exact (Hqueues p q Hq).
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_2 : DeInitDataqueue_entail_wit_4_2_split_goal_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
cbn [dataqueue_retired dq_sem_blank].
destruct (Z.leb 0 (dq_sem_blank q_init_cleanup)) eqn:Hsign; [reflexivity|].
apply Z.leb_gt in Hsign. lia.
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_3 : DeInitDataqueue_entail_wit_4_2_split_goal_3.
Proof.
LLM_pre_process ltac:(lia || int_auto).
cbn [dataqueue_retired dq_sem_blank].
destruct (Z.leb 0 (dq_sem_blank q_init_cleanup)) eqn:Hsign; [reflexivity|].
apply Z.leb_gt in Hsign. lia.
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_2 : DeInitDataqueue_entail_wit_4_2.
Proof.
aggressive_pre_process.
Goal_apply proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_1.
Goal_apply proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_2.
Goal_apply proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_3.
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_3_split_goal_1 : DeInitDataqueue_entail_wit_4_3_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
cbn [dataqueue_retired dq_sem_blank].
destruct (Z.leb 0 (dq_sem_blank q_init_cleanup)) eqn:Hsign.
- apply Z.leb_le in Hsign. lia.
- assumption.
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_3_split_goal_2 : DeInitDataqueue_entail_wit_4_3_split_goal_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
cbn [dataqueue_retired dq_sem_blank].
destruct (Z.leb 0 (dq_sem_blank q_init_cleanup)) eqn:Hsign.
- apply Z.leb_le in Hsign. lia.
- assumption.
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_3 : DeInitDataqueue_entail_wit_4_3.
Proof.
aggressive_pre_process.
Goal_apply proof_of_DeInitDataqueue_entail_wit_4_3_split_goal_1.
Goal_apply proof_of_DeInitDataqueue_entail_wit_4_3_split_goal_2.
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_4_split_goal_1 : DeInitDataqueue_entail_wit_4_4_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
cbn [dataqueue_retired dq_sem_blank].
destruct (Z.leb 0 (dq_sem_blank q_init_cleanup)) eqn:Hsign.
- apply Z.leb_le in Hsign. lia.
- assumption.
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_4_split_goal_2 : DeInitDataqueue_entail_wit_4_4_split_goal_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
cbn [dataqueue_retired dq_sem_blank].
destruct (Z.leb 0 (dq_sem_blank q_init_cleanup)) eqn:Hsign.
- apply Z.leb_le in Hsign. lia.
- assumption.
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_4 : DeInitDataqueue_entail_wit_4_4.
Proof.
aggressive_pre_process.
Goal_apply proof_of_DeInitDataqueue_entail_wit_4_4_split_goal_1.
Goal_apply proof_of_DeInitDataqueue_entail_wit_4_4_split_goal_2.
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_5_1 : DeInitDataqueue_entail_wit_5_1.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_entail_wit_5_2 : DeInitDataqueue_entail_wit_5_2.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_entail_wit_5_3 : DeInitDataqueue_entail_wit_5_3.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_entail_wit_5_4 : DeInitDataqueue_entail_wit_5_4.
Proof. Admitted.

Lemma proof_of_DeInitDataqueue_which_implies_wit_1 : DeInitDataqueue_which_implies_wit_1.
Proof. Admitted.

