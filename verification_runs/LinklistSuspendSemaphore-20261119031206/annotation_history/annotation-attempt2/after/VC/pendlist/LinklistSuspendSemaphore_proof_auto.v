From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.pendlist Require Import LinklistSuspendSemaphore_goal.
Require Import CRTOS_Verify.lib.id.IdModuleSpec.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreDelete CRTOS_Verify.lib.delay.KTaskUnSetDelay.
Require Import CRTOS_Verify.lib.list.DoubleLinkListSpec CRTOS_Verify.lib.task.TaskStatusMemory CRTOS_Verify.lib.task.KTaskParseInfo.
Import IDNode DLL.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreAbandon.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreObtain.
Import SimpleC.CoreLang.CTypes.SimpleCtypeNotations.
Local Open Scope sac.

Lemma proof_of_LinklistSuspend_safety_wit_1 : LinklistSuspend_safety_wit_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_safety_wit_2 : LinklistSuspend_safety_wit_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_safety_wit_3 : LinklistSuspend_safety_wit_3.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_safety_wit_4 : LinklistSuspend_safety_wit_4.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_safety_wit_5 : LinklistSuspend_safety_wit_5.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_safety_wit_6 : LinklistSuspend_safety_wit_6.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_safety_wit_7 : LinklistSuspend_safety_wit_7.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_safety_wit_8 : LinklistSuspend_safety_wit_8.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_safety_wit_9 : LinklistSuspend_safety_wit_9.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_safety_wit_10 : LinklistSuspend_safety_wit_10.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_safety_wit_11 : LinklistSuspend_safety_wit_11.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_safety_wit_12 : LinklistSuspend_safety_wit_12.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_safety_wit_13 : LinklistSuspend_safety_wit_13.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_safety_wit_14 : LinklistSuspend_safety_wit_14.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_safety_wit_15 : LinklistSuspend_safety_wit_15.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_safety_wit_16 : LinklistSuspend_safety_wit_16.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_safety_wit_17 : LinklistSuspend_safety_wit_17.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_1 : LinklistSuspend_partial_solve_wit_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_2 : LinklistSuspend_partial_solve_wit_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_3_pure : LinklistSuspend_partial_solve_wit_3_pure.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_3 : LinklistSuspend_partial_solve_wit_3.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_4_pure : LinklistSuspend_partial_solve_wit_4_pure.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_4 : LinklistSuspend_partial_solve_wit_4.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_5_pure : LinklistSuspend_partial_solve_wit_5_pure.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_5 : LinklistSuspend_partial_solve_wit_5.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_6_pure : LinklistSuspend_partial_solve_wit_6_pure.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_6 : LinklistSuspend_partial_solve_wit_6.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_7_pure : LinklistSuspend_partial_solve_wit_7_pure.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_7 : LinklistSuspend_partial_solve_wit_7.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_8_pure : LinklistSuspend_partial_solve_wit_8_pure.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_8 : LinklistSuspend_partial_solve_wit_8.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_9_pure : LinklistSuspend_partial_solve_wit_9_pure.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_9 : LinklistSuspend_partial_solve_wit_9.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_10 : LinklistSuspend_partial_solve_wit_10.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_11 : LinklistSuspend_partial_solve_wit_11.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_12_pure : LinklistSuspend_partial_solve_wit_12_pure.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_12 : LinklistSuspend_partial_solve_wit_12.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_13_pure : LinklistSuspend_partial_solve_wit_13_pure.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_13 : LinklistSuspend_partial_solve_wit_13.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_14_pure : LinklistSuspend_partial_solve_wit_14_pure.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_14 : LinklistSuspend_partial_solve_wit_14.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_15 : LinklistSuspend_partial_solve_wit_15.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_16_pure : LinklistSuspend_partial_solve_wit_16_pure.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_16 : LinklistSuspend_partial_solve_wit_16.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_17_pure : LinklistSuspend_partial_solve_wit_17_pure.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_partial_solve_wit_17 : LinklistSuspend_partial_solve_wit_17.
Proof. Admitted.

