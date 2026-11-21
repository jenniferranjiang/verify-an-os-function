From SimpleC.Verification Require Import VCPrelude.
Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreDelete.
Require Import CRTOS_Verify.lib.id.idnode CRTOS_Verify.lib.id.IdModuleSpec CRTOS_Verify.lib.common.dll CRTOS_Verify.lib.list.NodeSelfLinked.
Import IDNode DLL.
Local Open Scope sac.

(*----- Function KSemaphoreCreate -----*)

Definition KSemaphoreCreate_return_wit_1 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval: Z) (PreH1 : (retval = (-5))) (PreH2 : ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg_dataqueue_ic val_pre before_dataqueue_ic retval after_2 )),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic after_2 )
|--
  EX (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ (retval = (-5)) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg_dataqueue_ic val_pre before_dataqueue_ic retval after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic after )
.

Definition KSemaphoreCreate_return_wit_2 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval: Z) (PreH1 : (0 <= retval)) (PreH2 : (retval < 128)) (PreH3 : ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg_dataqueue_ic val_pre before_dataqueue_ic retval after_2 )),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic after_2 )
|--
  EX (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ (0 <= retval) ”
  &&  “ (retval < 128) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg_dataqueue_ic val_pre before_dataqueue_ic retval after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic after )
.

Definition KSemaphoreCreate_partial_solve_wit_1 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
.

Module Type VC_Correct.


Axiom proof_of_KSemaphoreCreate_return_wit_1 : KSemaphoreCreate_return_wit_1.
Axiom proof_of_KSemaphoreCreate_return_wit_2 : KSemaphoreCreate_return_wit_2.
Axiom proof_of_KSemaphoreCreate_partial_solve_wit_1 : KSemaphoreCreate_partial_solve_wit_1.

End VC_Correct.
