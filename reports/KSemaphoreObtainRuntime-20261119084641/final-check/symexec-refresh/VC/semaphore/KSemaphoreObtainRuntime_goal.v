From SimpleC.Verification Require Import VCPrelude.
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

(*----- Function KSemaphoreObtain -----*)

Definition KSemaphoreObtain_return_wit_1 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (after_2: VarGlobalState) (retval: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (after_2)) ( MonadErr.ret  (retval)) X_semaphore_obtain_oc )) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (OutsideCritical sg_semaphore_obtain_oc after_2 )
|--
  EX (after: VarGlobalState),
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (retval)) X_semaphore_obtain_oc ) ”
  &&  (OutsideCritical sg_semaphore_obtain_oc after )
.

Definition KSemaphoreObtain_partial_solve_wit_1_pure :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
.

Definition KSemaphoreObtain_partial_solve_wit_1_aux :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
.

Definition KSemaphoreObtain_partial_solve_wit_1 := KSemaphoreObtain_partial_solve_wit_1_pure -> KSemaphoreObtain_partial_solve_wit_1_aux.

Module Type VC_Correct.


Axiom proof_of_KSemaphoreObtain_return_wit_1 : KSemaphoreObtain_return_wit_1.
Axiom proof_of_KSemaphoreObtain_partial_solve_wit_1_pure : KSemaphoreObtain_partial_solve_wit_1_pure.
Axiom proof_of_KSemaphoreObtain_partial_solve_wit_1 : KSemaphoreObtain_partial_solve_wit_1.

End VC_Correct.
