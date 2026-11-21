From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.dataqueue Require Import DataqueuePeak_goal.
From CRTOS_Verify.VC.dataqueue Require Import DataqueuePeak_proof_auto.
Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Local Open Scope sac.

Lemma proof_of_DataqueuePeak_entail_wit_1 : DataqueuePeak_entail_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hentry : dataqueue_peak_entry sg p_queue_pre (Crtos_RTrans before)).
  { destruct PreH2 as [states [Hstates Hsafe]].
    unfold LastSeen in Hstates.
    unfold safe, abs_dataqueue_peak in Hsafe.
    rewrite wp_bind, wp_assertS in Hsafe.
    destruct Hsafe as [Hentry _].
    unfold dataqueue_peak_entry in Hentry |- *.
    intros obs Hobs. apply Hentry.
    apply (proj2 (Hstates obs)). exact Hobs. }
  pose proof (Hentry observed PreH1) as Hguard.
  prop_apply_p Hguard. Intros_p Hg. destruct Hg as [q Hq].
  assert (Hfocus : os_inv sg observed |--
      “ dataqueue_ready q ” &&
      store_dataqueue p_queue_pre q **
      (store_dataqueue p_queue_pre q -* os_inv sg observed)).
  { remember (store_dataqueue p_queue_pre q -* os_inv sg observed) as W eqn:HW.
    unfold os_inv at 1. unfold dataqueue_inv at 1. Intros.
    sep_apply_l_atomic (store_map_split store_dataqueue p_queue_pre q
      (dataqueue_map (os_dataqueues observed)) Hq).
    split_pure_spatial.
    - cancel (store_dataqueue p_queue_pre q).
      subst W. apply_sepcon_adjoint.
      sep_apply_l_atomic (store_map_merge store_dataqueue p_queue_pre q
        (dataqueue_map (os_dataqueues observed)) Hq).
      unfold os_inv, dataqueue_inv.
      split_pure_spatial; [sepcon_assoc_change; cancel | split_pures; dump_pre_spatial; assumption].
    - dump_pre_spatial.
      match goal with H : forall p q, _ p = Some q -> _ |- _ => exact (proj1 (H _ _ Hq)) end. }
  sep_apply_l_atomic Hfocus. Intros.
  Exists q. split_pure_spatial.
  - sepcon_assoc_change; cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed.

Lemma proof_of_DataqueuePeak_entail_wit_2_split_goal_1 : DataqueuePeak_entail_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of_DataqueuePeak_entail_wit_2_split_goal_2 : DataqueuePeak_entail_wit_2_split_goal_2.
Proof. Abort.

Lemma proof_of_DataqueuePeak_entail_wit_2_split_goal_spatial : DataqueuePeak_entail_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of_DataqueuePeak_entail_wit_2 : DataqueuePeak_entail_wit_2.
Proof. Admitted.

Lemma proof_of_DataqueuePeak_entail_wit_3_split_goal_1 : DataqueuePeak_entail_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of_DataqueuePeak_entail_wit_3_split_goal_2 : DataqueuePeak_entail_wit_3_split_goal_2.
Proof. Abort.

Lemma proof_of_DataqueuePeak_entail_wit_3_split_goal_spatial : DataqueuePeak_entail_wit_3_split_goal_spatial.
Proof. Abort.

Lemma proof_of_DataqueuePeak_entail_wit_3 : DataqueuePeak_entail_wit_3.
Proof. Admitted.

Lemma proof_of_DataqueuePeak_which_implies_wit_1_split_goal_1 : DataqueuePeak_which_implies_wit_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold store_dataqueue. Intros. dump_pre_spatial. tauto.
Qed.

Lemma proof_of_DataqueuePeak_which_implies_wit_1_split_goal_2 : DataqueuePeak_which_implies_wit_1_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold store_dataqueue. Intros. dump_pre_spatial. tauto.
Qed.

Lemma proof_of_DataqueuePeak_which_implies_wit_1_split_goal_spatial : DataqueuePeak_which_implies_wit_1_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold store_dataqueue, dataqueue_fields. Intros. change (6 * sizeof(CHAR)) with 6. csimpl. sepcon_assoc_change. cancel.
Qed.

Lemma proof_of_DataqueuePeak_which_implies_wit_1 : DataqueuePeak_which_implies_wit_1.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of_DataqueuePeak_which_implies_wit_1_split_goal_spatial.
  - Goal_apply proof_of_DataqueuePeak_which_implies_wit_1_split_goal_1.
  - Goal_apply proof_of_DataqueuePeak_which_implies_wit_1_split_goal_2.
Qed.

Lemma proof_of_DataqueuePeak_which_implies_wit_2 : DataqueuePeak_which_implies_wit_2.
Proof. Admitted.

Lemma proof_of_DataqueuePeak_which_implies_wit_3_split_goal_spatial : DataqueuePeak_which_implies_wit_3_split_goal_spatial.
Proof. Abort.

Lemma proof_of_DataqueuePeak_which_implies_wit_3 : DataqueuePeak_which_implies_wit_3.
Proof. Admitted.

Lemma proof_of_DataqueuePeak_which_implies_wit_4 : DataqueuePeak_which_implies_wit_4.
Proof. Admitted.

