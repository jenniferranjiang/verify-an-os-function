From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.semaphore Require Import SemaphoreDeleteIC_goal.
From CRTOS_Verify.VC.semaphore Require Import SemaphoreDeleteIC_proof_auto.
Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreDelete.
Require Import CRTOS_Verify.lib.id.idnode CRTOS_Verify.lib.id.IdModuleSpec CRTOS_Verify.lib.common.dll CRTOS_Verify.lib.list.NodeSelfLinked.
Import IDNode DLL.
Local Open Scope sac.

Lemma proof_of__SemaphoreDelete_entail_wit_1 : _SemaphoreDelete_entail_wit_1.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_entail_wit_2 : _SemaphoreDelete_entail_wit_2.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_entail_wit_3_1 : _SemaphoreDelete_entail_wit_3_1.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_entail_wit_3_2 : _SemaphoreDelete_entail_wit_3_2.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_return_wit_1 : _SemaphoreDelete_return_wit_1.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_return_wit_2 : _SemaphoreDelete_return_wit_2.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_return_wit_3_split_goal_1 : _SemaphoreDelete_return_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_return_wit_3 : _SemaphoreDelete_return_wit_3.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_return_wit_4_split_goal_1 : _SemaphoreDelete_return_wit_4_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_return_wit_4 : _SemaphoreDelete_return_wit_4.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_9_pure_split_goal_1 : _SemaphoreDelete_partial_solve_wit_9_pure_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_9_pure : _SemaphoreDelete_partial_solve_wit_9_pure.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_1 : _SemaphoreDelete_which_implies_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_2 : _SemaphoreDelete_which_implies_wit_1_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_3 : _SemaphoreDelete_which_implies_wit_1_split_goal_3.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_spatial : _SemaphoreDelete_which_implies_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1 : _SemaphoreDelete_which_implies_wit_1.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_which_implies_wit_2_split_goal_spatial : _SemaphoreDelete_which_implies_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_2 : _SemaphoreDelete_which_implies_wit_2.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_which_implies_wit_3_split_goal_spatial : _SemaphoreDelete_which_implies_wit_3_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_3 : _SemaphoreDelete_which_implies_wit_3.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_spatial : _SemaphoreDelete_which_implies_wit_4_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_4 : _SemaphoreDelete_which_implies_wit_4.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_which_implies_wit_5_split_goal_spatial : _SemaphoreDelete_which_implies_wit_5_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_5 : _SemaphoreDelete_which_implies_wit_5.
Proof. Admitted.

