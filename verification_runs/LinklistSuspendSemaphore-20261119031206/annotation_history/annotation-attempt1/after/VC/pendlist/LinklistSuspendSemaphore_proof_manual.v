From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.pendlist Require Import LinklistSuspendSemaphore_goal.
From CRTOS_Verify.VC.pendlist Require Import LinklistSuspendSemaphore_proof_auto.
Require Import CRTOS_Verify.lib.id.IdModuleSpec.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreDelete CRTOS_Verify.lib.delay.KTaskUnSetDelay.
Require Import CRTOS_Verify.lib.list.DoubleLinkListSpec CRTOS_Verify.lib.task.TaskStatusMemory CRTOS_Verify.lib.task.KTaskParseInfo.
Import IDNode DLL.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreAbandon.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreObtain.
Local Open Scope sac.

Lemma proof_of_LinklistSuspend_entail_wit_1_1 : LinklistSuspend_entail_wit_1_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_1_2 : LinklistSuspend_entail_wit_1_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_2_1 : LinklistSuspend_entail_wit_2_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_2_2 : LinklistSuspend_entail_wit_2_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_3 : LinklistSuspend_entail_wit_3.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_4_1 : LinklistSuspend_entail_wit_4_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_4_2 : LinklistSuspend_entail_wit_4_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_5 : LinklistSuspend_entail_wit_5.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_6_1 : LinklistSuspend_entail_wit_6_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_6_2 : LinklistSuspend_entail_wit_6_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_7_1 : LinklistSuspend_entail_wit_7_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_7_2 : LinklistSuspend_entail_wit_7_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_7_3 : LinklistSuspend_entail_wit_7_3.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_7_4 : LinklistSuspend_entail_wit_7_4.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_return_wit_1_split_goal_1 : LinklistSuspend_return_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistSuspend_return_wit_1 : LinklistSuspend_return_wit_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_return_wit_2_split_goal_1 : LinklistSuspend_return_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistSuspend_return_wit_2 : LinklistSuspend_return_wit_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_return_wit_3_split_goal_1 : LinklistSuspend_return_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistSuspend_return_wit_3 : LinklistSuspend_return_wit_3.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_return_wit_4_split_goal_1 : LinklistSuspend_return_wit_4_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistSuspend_return_wit_4 : LinklistSuspend_return_wit_4.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_1_split_goal_spatial : LinklistSuspend_which_implies_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistSuspend_which_implies_wit_1 : LinklistSuspend_which_implies_wit_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_2_split_goal_spatial : LinklistSuspend_which_implies_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistSuspend_which_implies_wit_2 : LinklistSuspend_which_implies_wit_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_3 : LinklistSuspend_which_implies_wit_3.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_4_split_goal_spatial : LinklistSuspend_which_implies_wit_4_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistSuspend_which_implies_wit_4 : LinklistSuspend_which_implies_wit_4.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_5 : LinklistSuspend_which_implies_wit_5.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_6_split_goal_spatial : LinklistSuspend_which_implies_wit_6_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistSuspend_which_implies_wit_6 : LinklistSuspend_which_implies_wit_6.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_7_split_goal_spatial : LinklistSuspend_which_implies_wit_7_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistSuspend_which_implies_wit_7 : LinklistSuspend_which_implies_wit_7.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic : LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic.
Proof. Admitted.

