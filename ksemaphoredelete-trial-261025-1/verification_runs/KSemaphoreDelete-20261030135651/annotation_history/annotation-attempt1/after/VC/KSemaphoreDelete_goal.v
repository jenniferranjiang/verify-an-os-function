Require Import Coq.ZArith.ZArith.
Require Import Coq.Bool.Bool.
Require Import Coq.Strings.String.
Require Import Coq.Strings.Ascii.
Require Import Coq.Lists.List.
Require Import Coq.Classes.RelationClasses.
Require Import Coq.Classes.Morphisms.
Require Import Coq.micromega.Psatz.
Require Import Coq.Sorting.Permutation.
From AUXLib Require Import int_auto Axioms Feq Idents ListLib VMap.
Require Import SetsClass.SetsClass. Import SetsNotation.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.lib.IdModuleSpec.
Require Import CRTOS_Verify.lib.KSemaphoreDelete CRTOS_Verify.lib.KTaskUnSetDelay.
Require Import CRTOS_Verify.lib.DoubleLinkListSpec CRTOS_Verify.lib.TaskStatusMemory CRTOS_Verify.lib.KTaskParseInfo.
Import IDNode DLL.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Local Open Scope sac.

(*----- Function KSemaphoreDelete -----*)

Definition KSemaphoreDelete_return_wit_1 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (after_2: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (after_2)) ( MonadErr.ret  (tt)) X_outside_critical )) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (OutsideCritical sg_outside_critical after_2 )
|--
  EX (after: VarGlobalState) ,
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_outside_critical ) ”
  &&  (OutsideCritical sg_outside_critical after )
.

Definition KSemaphoreDelete_partial_solve_wit_1_pure := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ”
.

Definition KSemaphoreDelete_partial_solve_wit_1_aux := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ”
  &&  (OutsideCritical sg_outside_critical before_outside_critical )
.

Definition KSemaphoreDelete_partial_solve_wit_1 := KSemaphoreDelete_partial_solve_wit_1_pure -> KSemaphoreDelete_partial_solve_wit_1_aux.

Module Type VC_Correct.


Axiom proof_of_KSemaphoreDelete_return_wit_1 : KSemaphoreDelete_return_wit_1.
Axiom proof_of_KSemaphoreDelete_partial_solve_wit_1_pure : KSemaphoreDelete_partial_solve_wit_1_pure.
Axiom proof_of_KSemaphoreDelete_partial_solve_wit_1 : KSemaphoreDelete_partial_solve_wit_1.

End VC_Correct.
