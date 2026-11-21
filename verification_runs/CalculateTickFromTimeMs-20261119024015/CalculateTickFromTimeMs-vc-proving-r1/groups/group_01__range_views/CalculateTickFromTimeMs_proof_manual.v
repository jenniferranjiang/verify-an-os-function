From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.common Require Import CalculateTickFromTimeMs_goal.
From CRTOS_Verify.VC.common Require Import CalculateTickFromTimeMs_proof_auto.
Require Import CRTOS_Verify.lib.common.TickConversion.
Local Open Scope sac.

Lemma proof_of_CalculateTickFromTimeMs_return_wit_1_split_goal_1 : CalculateTickFromTimeMs_return_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of_CalculateTickFromTimeMs_return_wit_1 : CalculateTickFromTimeMs_return_wit_1.
Proof. Admitted.

Lemma proof_of_CalculateTickFromTimeMs_return_wit_2_split_goal_1 : CalculateTickFromTimeMs_return_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of_CalculateTickFromTimeMs_return_wit_2 : CalculateTickFromTimeMs_return_wit_2.
Proof. Admitted.

Lemma proof_of_CalculateTickFromTimeMs_return_wit_3_split_goal_1 : CalculateTickFromTimeMs_return_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of_CalculateTickFromTimeMs_return_wit_3 : CalculateTickFromTimeMs_return_wit_3.
Proof. Admitted.

Lemma proof_of_CalculateTickFromTimeMs_return_wit_4_split_goal_1 : CalculateTickFromTimeMs_return_wit_4_split_goal_1.
Proof. Abort.

Lemma proof_of_CalculateTickFromTimeMs_return_wit_4 : CalculateTickFromTimeMs_return_wit_4.
Proof. Admitted.

Lemma proof_of_CalculateTickFromTimeMs_which_implies_wit_1_split_goal_spatial : CalculateTickFromTimeMs_which_implies_wit_1_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold store_uint.
  cancel.
Qed.

Lemma proof_of_CalculateTickFromTimeMs_which_implies_wit_1 : CalculateTickFromTimeMs_which_implies_wit_1.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_CalculateTickFromTimeMs_which_implies_wit_1_split_goal_spatial.
Qed.

Lemma proof_of_CalculateTickFromTimeMs_which_implies_wit_2_split_goal_spatial : CalculateTickFromTimeMs_which_implies_wit_2_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold store_uint.
  cancel.
Qed.

Lemma proof_of_CalculateTickFromTimeMs_which_implies_wit_2 : CalculateTickFromTimeMs_which_implies_wit_2.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_CalculateTickFromTimeMs_which_implies_wit_2_split_goal_spatial.
Qed.

