From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.dataqueue Require Import DataqueuePeak_goal.
From CRTOS_Verify.VC.dataqueue Require Import DataqueuePeak_proof_auto.
Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Local Open Scope sac.

Lemma proof_of_DataqueuePeak_entail_wit_1 : DataqueuePeak_entail_wit_1.
Proof. Admitted.

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
Proof. Abort.

Lemma proof_of_DataqueuePeak_which_implies_wit_1_split_goal_2 : DataqueuePeak_which_implies_wit_1_split_goal_2.
Proof. Abort.

Lemma proof_of_DataqueuePeak_which_implies_wit_1_split_goal_spatial : DataqueuePeak_which_implies_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of_DataqueuePeak_which_implies_wit_1 : DataqueuePeak_which_implies_wit_1.
Proof. Admitted.

Lemma proof_of_DataqueuePeak_which_implies_wit_2 : DataqueuePeak_which_implies_wit_2.
Proof. Admitted.

Lemma proof_of_DataqueuePeak_which_implies_wit_3_split_goal_spatial : DataqueuePeak_which_implies_wit_3_split_goal_spatial.
Proof. Abort.

Lemma proof_of_DataqueuePeak_which_implies_wit_3 : DataqueuePeak_which_implies_wit_3.
Proof. Admitted.

Lemma proof_of_DataqueuePeak_which_implies_wit_4 : DataqueuePeak_which_implies_wit_4.
Proof. Admitted.

