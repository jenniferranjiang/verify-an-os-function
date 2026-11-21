From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.dataqueue Require Import PopDataqueue_goal.
From CRTOS_Verify.VC.dataqueue Require Import PopDataqueue_proof_auto.
Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.dataqueue.KPopDataqueue CRTOS_Verify.lib.dataqueue.KPushDataqueue.
Local Open Scope sac.

Lemma proof_of_PopDataqueue_entail_wit_1 : PopDataqueue_entail_wit_1.
Proof. Admitted.

Lemma proof_of_PopDataqueue_entail_wit_2 : PopDataqueue_entail_wit_2.
Proof. Admitted.

Lemma proof_of_PopDataqueue_entail_wit_3_split_goal_1 : PopDataqueue_entail_wit_3_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst retval. exact (PreH5 after 0 PreH2).
Qed.

Lemma proof_of_PopDataqueue_entail_wit_3 : PopDataqueue_entail_wit_3.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_PopDataqueue_entail_wit_3_split_goal_1.
Qed.

Lemma proof_of_PopDataqueue_entail_wit_4 : PopDataqueue_entail_wit_4.
Proof. Admitted.

Lemma proof_of_PopDataqueue_entail_wit_5_1 : PopDataqueue_entail_wit_5_1.
Proof. Admitted.

Lemma proof_of_PopDataqueue_entail_wit_5_2 : PopDataqueue_entail_wit_5_2.
Proof. Admitted.

Lemma proof_of_PopDataqueue_return_wit_1 : PopDataqueue_return_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst result new_data new_length.
  Right. Exists after_4 item.
  split_pure_spatial.
  - repeat progress cancel.
  - split_pures; dump_pre_spatial; try reflexivity.
    exact (PreH8 after_4 retval PreH1).
Qed.

Lemma proof_of_PopDataqueue_return_wit_2 : PopDataqueue_return_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst result new_data new_length.
  Left. Exists after_4.
  split_pure_spatial.
  - repeat progress cancel.
  - split_pures; dump_pre_spatial; try reflexivity.
    exact (PreH8 after_4 retval PreH1).
Qed.

Lemma proof_of_PopDataqueue_return_wit_3_split_goal_1 : PopDataqueue_return_wit_3_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  specialize (PreH5 after_4 retval PreH2).
  unfold dataqueue_pop_after_obtain in PreH5.
  prog_nf in PreH5.
  destruct (Z.eq_dec retval 0); [lia | exact PreH5].
Qed.

Lemma proof_of_PopDataqueue_return_wit_3 : PopDataqueue_return_wit_3.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_PopDataqueue_return_wit_3_split_goal_1.
Qed.

Lemma proof_of_PopDataqueue_which_implies_wit_1_split_goal_1 : PopDataqueue_which_implies_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of_PopDataqueue_which_implies_wit_1_split_goal_2 : PopDataqueue_which_implies_wit_1_split_goal_2.
Proof. Abort.

Lemma proof_of_PopDataqueue_which_implies_wit_1_split_goal_spatial : PopDataqueue_which_implies_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of_PopDataqueue_which_implies_wit_1 : PopDataqueue_which_implies_wit_1.
Proof. Admitted.

Lemma proof_of_PopDataqueue_which_implies_wit_2_split_goal_1 : PopDataqueue_which_implies_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of_PopDataqueue_which_implies_wit_2_split_goal_2 : PopDataqueue_which_implies_wit_2_split_goal_2.
Proof. Abort.

Lemma proof_of_PopDataqueue_which_implies_wit_2_split_goal_spatial : PopDataqueue_which_implies_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of_PopDataqueue_which_implies_wit_2 : PopDataqueue_which_implies_wit_2.
Proof. Admitted.

Lemma proof_of_PopDataqueue_which_implies_wit_3 : PopDataqueue_which_implies_wit_3.
Proof. Admitted.

Lemma proof_of_PopDataqueue_which_implies_wit_4_split_goal_spatial : PopDataqueue_which_implies_wit_4_split_goal_spatial.
Proof. Abort.

Lemma proof_of_PopDataqueue_which_implies_wit_4 : PopDataqueue_which_implies_wit_4.
Proof. Admitted.

Lemma proof_of_PopDataqueue_which_implies_wit_5 : PopDataqueue_which_implies_wit_5.
Proof. Admitted.

