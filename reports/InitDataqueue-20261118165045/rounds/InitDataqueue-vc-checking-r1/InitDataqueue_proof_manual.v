From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.dataqueue Require Import InitDataqueue_goal.
From CRTOS_Verify.VC.dataqueue Require Import InitDataqueue_proof_auto.
Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Local Open Scope sac.

Lemma proof_of_InitDataqueue_safety_wit_12_split_goal_1 : InitDataqueue_safety_wit_12_split_goal_1.
Proof. Show. Abort.

Lemma proof_of_InitDataqueue_safety_wit_12_split_goal_2 : InitDataqueue_safety_wit_12_split_goal_2.
Proof. Abort.

Lemma proof_of_InitDataqueue_safety_wit_12 : InitDataqueue_safety_wit_12.
Proof. Admitted.

Lemma proof_of_InitDataqueue_entail_wit_1 : InitDataqueue_entail_wit_1.
Proof. Admitted.

Lemma proof_of_InitDataqueue_entail_wit_2_1 : InitDataqueue_entail_wit_2_1.
Proof. Admitted.

Lemma proof_of_InitDataqueue_entail_wit_2_2 : InitDataqueue_entail_wit_2_2.
Proof. Admitted.

Lemma proof_of_InitDataqueue_entail_wit_2_3 : InitDataqueue_entail_wit_2_3.
Proof. Admitted.

Lemma proof_of_InitDataqueue_entail_wit_2_4 : InitDataqueue_entail_wit_2_4.
Proof. Admitted.

Lemma proof_of_InitDataqueue_return_wit_1 : InitDataqueue_return_wit_1.
Proof. Admitted.

Lemma proof_of_InitDataqueue_return_wit_2 : InitDataqueue_return_wit_2.
Proof. Admitted.

Lemma proof_of_InitDataqueue_return_wit_3 : InitDataqueue_return_wit_3.
Proof. Admitted.

Lemma proof_of_InitDataqueue_return_wit_4 : InitDataqueue_return_wit_4.
Proof. Admitted.

Lemma proof_of_InitDataqueue_which_implies_wit_1_split_goal_1 : InitDataqueue_which_implies_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of_InitDataqueue_which_implies_wit_1_split_goal_2 : InitDataqueue_which_implies_wit_1_split_goal_2.
Proof. Abort.

Lemma proof_of_InitDataqueue_which_implies_wit_1_split_goal_spatial : InitDataqueue_which_implies_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of_InitDataqueue_which_implies_wit_1 : InitDataqueue_which_implies_wit_1.
Proof. Admitted.

Lemma proof_of_InitDataqueue_which_implies_wit_2_split_goal_spatial : InitDataqueue_which_implies_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of_InitDataqueue_which_implies_wit_2 : InitDataqueue_which_implies_wit_2.
Proof. Admitted.

