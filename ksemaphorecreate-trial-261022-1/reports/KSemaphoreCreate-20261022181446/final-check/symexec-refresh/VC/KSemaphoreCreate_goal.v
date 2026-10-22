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
Require Import KSemaphoreCreateTrial.KSemaphoreCreate.
Require Import TrialShared.CrtosInv TrialShared.SemaphoreInv.
Require Import TrialShared.DoubleLinkListSpec.
Import IDNode DLL.
From MonadLib.MonadErr
      Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Local Open Scope sac.

(*----- Function KSemaphoreCreate -----*)

Definition KSemaphoreCreate_return_wit_1 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (after_3: VarGlobalState) (retval: Z) (PreH1 : (retval = (-5))) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (after_3)) ( MonadErr.ret  ((-5))) X )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  (OutsideCritical sg after_3 )
|--
  EX (after: VarGlobalState) ,
  “ (retval = (-5)) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  ((-5))) X ) ”
  &&  (OutsideCritical sg after )
.

Definition KSemaphoreCreate_return_wit_2 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (after_3: VarGlobalState) (retval: Z) (PreH1 : (0 <= retval)) (PreH2 : (retval < 128)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (after_3)) ( MonadErr.ret  (retval)) X )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  (OutsideCritical sg after_3 )
|--
  EX (after_2: VarGlobalState) ,
  “ (0 <= retval) ” 
  &&  “ (retval < 128) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after_2)) ( MonadErr.ret  (retval)) X ) ”
  &&  (OutsideCritical sg after_2 )
.

Definition KSemaphoreCreate_partial_solve_wit_1_pure := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (OutsideCritical sg before )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X ) ”
.

Definition KSemaphoreCreate_partial_solve_wit_1_aux := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  (OutsideCritical sg before )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X ) ”
  &&  (OutsideCritical sg before )
.

Definition KSemaphoreCreate_partial_solve_wit_1 := KSemaphoreCreate_partial_solve_wit_1_pure -> KSemaphoreCreate_partial_solve_wit_1_aux.

Module Type VC_Correct.


Axiom proof_of_KSemaphoreCreate_return_wit_1 : KSemaphoreCreate_return_wit_1.
Axiom proof_of_KSemaphoreCreate_return_wit_2 : KSemaphoreCreate_return_wit_2.
Axiom proof_of_KSemaphoreCreate_partial_solve_wit_1_pure : KSemaphoreCreate_partial_solve_wit_1_pure.
Axiom proof_of_KSemaphoreCreate_partial_solve_wit_1 : KSemaphoreCreate_partial_solve_wit_1.

End VC_Correct.
