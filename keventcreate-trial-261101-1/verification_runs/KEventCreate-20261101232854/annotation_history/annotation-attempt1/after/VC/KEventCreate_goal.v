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
Require Import CRTOS_Verify.lib.KEventCreate.
Require Import CRTOS_Verify.lib.DoubleLinkListSpec.
Require Import CRTOS_Verify.lib.KTaskWakeup.
Import DLL IDNode.
From MonadLib.MonadErr
      Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Local Open Scope sac.

(*----- Function KEventCreate -----*)

Definition KEventCreate_return_wit_1 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (after_3: VarGlobalState) (retval: Z) (PreH1 : (retval = (-5))) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (after_3)) ( MonadErr.ret  (retval)) X_outside_critical )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (OutsideCritical sg_outside_critical after_3 )
|--
  EX (after: VarGlobalState) ,
  “ (retval = (-5)) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (retval)) X_outside_critical ) ”
  &&  (OutsideCritical sg_outside_critical after )
.

Definition KEventCreate_return_wit_2 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (after_3: VarGlobalState) (retval: Z) (PreH1 : (0 <= retval)) (PreH2 : (retval < 128)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (after_3)) ( MonadErr.ret  (retval)) X_outside_critical )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (OutsideCritical sg_outside_critical after_3 )
|--
  EX (after_2: VarGlobalState) ,
  “ (0 <= retval) ” 
  &&  “ (retval < 128) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after_2)) ( MonadErr.ret  (retval)) X_outside_critical ) ”
  &&  (OutsideCritical sg_outside_critical after_2 )
.

Definition KEventCreate_partial_solve_wit_1_pure := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ”
.

Definition KEventCreate_partial_solve_wit_1_aux := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ”
  &&  (OutsideCritical sg_outside_critical before_outside_critical )
.

Definition KEventCreate_partial_solve_wit_1 := KEventCreate_partial_solve_wit_1_pure -> KEventCreate_partial_solve_wit_1_aux.

Module Type VC_Correct.


Axiom proof_of_KEventCreate_return_wit_1 : KEventCreate_return_wit_1.
Axiom proof_of_KEventCreate_return_wit_2 : KEventCreate_return_wit_2.
Axiom proof_of_KEventCreate_partial_solve_wit_1_pure : KEventCreate_partial_solve_wit_1_pure.
Axiom proof_of_KEventCreate_partial_solve_wit_1 : KEventCreate_partial_solve_wit_1.

End VC_Correct.
