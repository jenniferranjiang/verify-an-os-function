From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.semaphore Require Import LinklistResumeSemaphore_goal.
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

Lemma proof_of_LinklistResume_safety_wit_1 : LinklistResume_safety_wit_1.
Proof. Admitted.

Lemma proof_of_LinklistResume_safety_wit_2 : LinklistResume_safety_wit_2.
Proof. Admitted.

Lemma proof_of_LinklistResume_partial_solve_wit_1_pure : LinklistResume_partial_solve_wit_1_pure.
Proof. Admitted.

Lemma proof_of_LinklistResume_partial_solve_wit_1 : LinklistResume_partial_solve_wit_1.
Proof. Admitted.

Lemma proof_of_LinklistResume_partial_solve_wit_2_pure : LinklistResume_partial_solve_wit_2_pure.
Proof. Admitted.

Lemma proof_of_LinklistResume_partial_solve_wit_2 : LinklistResume_partial_solve_wit_2.
Proof. Admitted.

Lemma proof_of_LinklistResume_partial_solve_wit_3 : LinklistResume_partial_solve_wit_3.
Proof. Admitted.

Lemma proof_of_LinklistResume_partial_solve_wit_4_pure : LinklistResume_partial_solve_wit_4_pure.
Proof. Admitted.

Lemma proof_of_LinklistResume_partial_solve_wit_4 : LinklistResume_partial_solve_wit_4.
Proof. Admitted.

Lemma proof_of_LinklistResume_partial_solve_wit_5 : LinklistResume_partial_solve_wit_5.
Proof. Admitted.

Lemma proof_of_LinklistResume_partial_solve_wit_6_pure : LinklistResume_partial_solve_wit_6_pure.
Proof. Admitted.

Lemma proof_of_LinklistResume_partial_solve_wit_6 : LinklistResume_partial_solve_wit_6.
Proof. Admitted.

