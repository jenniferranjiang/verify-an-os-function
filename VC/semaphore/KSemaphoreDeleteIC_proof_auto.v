From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.semaphore Require Import KSemaphoreDeleteIC_goal.
Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreDelete.
Require Import CRTOS_Verify.lib.id.idnode CRTOS_Verify.lib.id.IdModuleSpec CRTOS_Verify.lib.common.dll CRTOS_Verify.lib.list.NodeSelfLinked.
Import IDNode DLL.
Local Open Scope sac.

Lemma proof_of_KSemaphoreDelete_return_wit_1 : KSemaphoreDelete_return_wit_1.
Proof. Admitted.

Lemma proof_of_KSemaphoreDelete_partial_solve_wit_1_pure : KSemaphoreDelete_partial_solve_wit_1_pure.
Proof. Admitted.

Lemma proof_of_KSemaphoreDelete_partial_solve_wit_1 : KSemaphoreDelete_partial_solve_wit_1.
Proof. Admitted.

