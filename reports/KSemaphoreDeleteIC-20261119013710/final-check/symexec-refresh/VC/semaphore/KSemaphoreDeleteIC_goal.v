From SimpleC.Verification Require Import VCPrelude.
Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreDelete.
Require Import CRTOS_Verify.lib.id.idnode CRTOS_Verify.lib.id.IdModuleSpec CRTOS_Verify.lib.common.dll CRTOS_Verify.lib.list.NodeSelfLinked.
Import IDNode DLL.
Local Open Scope sac.

(*----- Function KSemaphoreDelete -----*)

Definition KSemaphoreDelete_return_wit_1 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  id_pre before_dataqueue_cleanup_ic after_2 )) (PreH2 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic after_2 )
|--
  EX (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  id_pre before_dataqueue_cleanup_ic after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic after )
.

Definition KSemaphoreDelete_partial_solve_wit_1_pure :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic ) ”
.

Definition KSemaphoreDelete_partial_solve_wit_1_aux :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic ) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
.

Definition KSemaphoreDelete_partial_solve_wit_1 := KSemaphoreDelete_partial_solve_wit_1_pure -> KSemaphoreDelete_partial_solve_wit_1_aux.

Module Type VC_Correct.


Axiom proof_of_KSemaphoreDelete_return_wit_1 : KSemaphoreDelete_return_wit_1.
Axiom proof_of_KSemaphoreDelete_partial_solve_wit_1_pure : KSemaphoreDelete_partial_solve_wit_1_pure.
Axiom proof_of_KSemaphoreDelete_partial_solve_wit_1 : KSemaphoreDelete_partial_solve_wit_1.

End VC_Correct.
