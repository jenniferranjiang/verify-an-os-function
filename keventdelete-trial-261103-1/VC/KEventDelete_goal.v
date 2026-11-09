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
Require Import CRTOS_Verify.lib.IdModuleSpec CRTOS_Verify.lib.DoubleLinkListSpec.
Require Import CRTOS_Verify.lib.KEventDelete.
Import IDNode DLL MonadErr.
Require Import CRTOS_Verify.VC.KEventDelete_lib.
Local Open Scope sac.

(*----- Function KEventDelete -----*)

Definition KEventDelete_safety_wit_1 := 
forall (id_pre: Z) (X_event_delete_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_event_delete_oc: VarGlobalState) (sg_event_delete_oc: StableGlobalState) (retval: Z) (looked_up: VarGlobalState) (PreH1 : (retval = 0)) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (looked_up)) ( MonadErr.ret  (0)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_find_event (id_pre)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre < 65536)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_event_delete (id_pre)) X_event_delete_oc )) ,
  (OutsideCritical sg_event_delete_oc looked_up )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition KEventDelete_safety_wit_2 := 
forall (id_pre: Z) (X_event_delete_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_event_delete_oc: VarGlobalState) (sg_event_delete_oc: StableGlobalState) (retval: Z) (looked_up: VarGlobalState) (PreH1 : (retval <> 0)) (PreH2 : (event_delete_guard id_pre retval false looked_up )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (looked_up)) ( MonadErr.ret  (retval)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_find_event (id_pre)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre < 65536)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_event_delete (id_pre)) X_event_delete_oc )) ,
  (OutsideCritical sg_event_delete_oc looked_up )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition KEventDelete_safety_wit_3 := 
forall (id_pre: Z) (X_event_delete_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_event_delete_oc: VarGlobalState) (sg_event_delete_oc: StableGlobalState) (retval: Z) (looked_up: VarGlobalState) (PreH1 : (retval <> 0)) (PreH2 : (retval = 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (looked_up)) ( MonadErr.ret  (0)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_find_event (id_pre)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre < 65536)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_event_delete (id_pre)) X_event_delete_oc )) ,
  (OutsideCritical sg_event_delete_oc looked_up )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ False ”
.

Definition KEventDelete_safety_wit_4 := 
forall (id_pre: Z) (X_event_delete_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_event_delete_oc: VarGlobalState) (sg_event_delete_oc: StableGlobalState) (retval: Z) (looked_up: VarGlobalState) (PreH1 : (retval = 0)) (PreH2 : (retval <> 0)) (PreH3 : (event_delete_guard id_pre retval false looked_up )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (looked_up)) ( MonadErr.ret  (retval)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_find_event (id_pre)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH6 : (0 <= id_pre)) (PreH7 : (id_pre < 65536)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_event_delete (id_pre)) X_event_delete_oc )) ,
  (OutsideCritical sg_event_delete_oc looked_up )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ False ”
.

Definition KEventDelete_return_wit_1 := 
(
forall (id_pre: Z) (X_event_delete_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_event_delete_oc: VarGlobalState) (sg_event_delete_oc: StableGlobalState) (retval: Z) (looked_up: VarGlobalState) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (looked_up)) ( MonadErr.ret  (0)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_find_event (id_pre)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre < 65536)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_event_delete (id_pre)) X_event_delete_oc )) ,
  (OutsideCritical sg_event_delete_oc looked_up )
|--
  EX (after: VarGlobalState) ,
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_event_delete_oc ) ”
  &&  (OutsideCritical sg_event_delete_oc after )
) \/
(
forall (id_pre: Z) (X_event_delete_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_event_delete_oc: VarGlobalState) (retval: Z) (looked_up: VarGlobalState) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (looked_up)) ( MonadErr.ret  (0)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_find_event (id_pre)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre < 65536)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_event_delete (id_pre)) X_event_delete_oc )) ,
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (looked_up)) ( MonadErr.ret  (tt)) X_event_delete_oc ) ”
  &&  emp
).

Definition KEventDelete_return_wit_1_split_goal_1 := 
forall (id_pre: Z) (X_event_delete_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_event_delete_oc: VarGlobalState) (retval: Z) (looked_up: VarGlobalState) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (looked_up)) ( MonadErr.ret  (0)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_find_event (id_pre)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre < 65536)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_event_delete (id_pre)) X_event_delete_oc )) ,
  ( monadesafe_lib.safeExec  (LastSeen (looked_up)) ( MonadErr.ret  (tt)) X_event_delete_oc )
.

Definition KEventDelete_return_wit_2 := 
forall (id_pre: Z) (X_event_delete_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_event_delete_oc: VarGlobalState) (sg_event_delete_oc: StableGlobalState) (retval: Z) (looked_up: VarGlobalState) (after_2: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (after_2)) ( MonadErr.ret  (tt)) X_event_delete_oc )) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (looked_up)) (abs_event_delete_at (id_pre) (retval)) X_event_delete_oc )) (PreH3 : (retval <> 0)) (PreH4 : (retval <> 0)) (PreH5 : (event_delete_guard id_pre retval false looked_up )) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (looked_up)) ( MonadErr.ret  (retval)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_find_event (id_pre)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH8 : (0 <= id_pre)) (PreH9 : (id_pre < 65536)) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_event_delete (id_pre)) X_event_delete_oc )) ,
  (OutsideCritical sg_event_delete_oc after_2 )
|--
  EX (after: VarGlobalState) ,
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_event_delete_oc ) ”
  &&  (OutsideCritical sg_event_delete_oc after )
.

Definition KEventDelete_partial_solve_wit_1_pure := 
forall (id_pre: Z) (X_event_delete_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_event_delete_oc: VarGlobalState) (sg_event_delete_oc: StableGlobalState) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre < 65536)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_event_delete (id_pre)) X_event_delete_oc )) ,
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_event_delete_oc before_event_delete_oc )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_event_delete (id_pre)) X_event_delete_oc ) ”
.

Definition KEventDelete_partial_solve_wit_1_aux := 
forall (id_pre: Z) (X_event_delete_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_event_delete_oc: VarGlobalState) (sg_event_delete_oc: StableGlobalState) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre < 65536)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_event_delete (id_pre)) X_event_delete_oc )) ,
  (OutsideCritical sg_event_delete_oc before_event_delete_oc )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_event_delete (id_pre)) X_event_delete_oc ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre < 65536) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_event_delete (id_pre)) X_event_delete_oc ) ”
  &&  (OutsideCritical sg_event_delete_oc before_event_delete_oc )
.

Definition KEventDelete_partial_solve_wit_1 := KEventDelete_partial_solve_wit_1_pure -> KEventDelete_partial_solve_wit_1_aux.

Definition KEventDelete_partial_solve_wit_2_pure := 
forall (id_pre: Z) (X_event_delete_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_event_delete_oc: VarGlobalState) (sg_event_delete_oc: StableGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_find_event (id_pre)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre < 65536)) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_event_delete (id_pre)) X_event_delete_oc )) ,
  ((( &( "event" ) )) # Ptr  |->_)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_event_delete_oc before_event_delete_oc )
|--
  “ (0 <= id_pre) ” 
  &&  “ (id_pre < 65536) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_find_event (id_pre)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) ) ”
.

Definition KEventDelete_partial_solve_wit_2_aux := 
forall (id_pre: Z) (X_event_delete_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_event_delete_oc: VarGlobalState) (sg_event_delete_oc: StableGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_find_event (id_pre)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre < 65536)) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_event_delete (id_pre)) X_event_delete_oc )) ,
  (OutsideCritical sg_event_delete_oc before_event_delete_oc )
|--
  “ (0 <= id_pre) ” 
  &&  “ (id_pre < 65536) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_find_event (id_pre)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_find_event (id_pre)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre < 65536) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_event_delete (id_pre)) X_event_delete_oc ) ”
  &&  (OutsideCritical sg_event_delete_oc before_event_delete_oc )
.

Definition KEventDelete_partial_solve_wit_2 := KEventDelete_partial_solve_wit_2_pure -> KEventDelete_partial_solve_wit_2_aux.

Definition KEventDelete_partial_solve_wit_3_pure := 
forall (id_pre: Z) (X_event_delete_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_event_delete_oc: VarGlobalState) (sg_event_delete_oc: StableGlobalState) (retval: Z) (looked_up: VarGlobalState) (PreH1 : (retval <> 0)) (PreH2 : (retval <> 0)) (PreH3 : (event_delete_guard id_pre retval false looked_up )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (looked_up)) ( MonadErr.ret  (retval)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_find_event (id_pre)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH6 : (0 <= id_pre)) (PreH7 : (id_pre < 65536)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_event_delete (id_pre)) X_event_delete_oc )) ,
  (OutsideCritical sg_event_delete_oc looked_up )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (retval <> 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (looked_up)) ( MonadErr.ret  (retval)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) ) ”
.

Definition KEventDelete_partial_solve_wit_3_aux := 
forall (id_pre: Z) (X_event_delete_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_event_delete_oc: VarGlobalState) (sg_event_delete_oc: StableGlobalState) (retval: Z) (looked_up: VarGlobalState) (PreH1 : (retval <> 0)) (PreH2 : (retval <> 0)) (PreH3 : (event_delete_guard id_pre retval false looked_up )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (looked_up)) ( MonadErr.ret  (retval)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_find_event (id_pre)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH6 : (0 <= id_pre)) (PreH7 : (id_pre < 65536)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_event_delete (id_pre)) X_event_delete_oc )) ,
  (OutsideCritical sg_event_delete_oc looked_up )
|--
  “ (retval <> 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (looked_up)) ( MonadErr.ret  (retval)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (event_delete_guard id_pre retval false looked_up ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (looked_up)) ( MonadErr.ret  (retval)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_find_event (id_pre)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre < 65536) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_event_delete (id_pre)) X_event_delete_oc ) ”
  &&  (OutsideCritical sg_event_delete_oc looked_up )
.

Definition KEventDelete_partial_solve_wit_3 := KEventDelete_partial_solve_wit_3_pure -> KEventDelete_partial_solve_wit_3_aux.

Definition KEventDelete_partial_solve_wit_4_pure := 
forall (id_pre: Z) (X_event_delete_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_event_delete_oc: VarGlobalState) (sg_event_delete_oc: StableGlobalState) (retval: Z) (looked_up: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (looked_up)) (abs_event_delete_at (id_pre) (retval)) X_event_delete_oc )) (PreH2 : (retval <> 0)) (PreH3 : (retval <> 0)) (PreH4 : (event_delete_guard id_pre retval false looked_up )) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (looked_up)) ( MonadErr.ret  (retval)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_find_event (id_pre)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH7 : (0 <= id_pre)) (PreH8 : (id_pre < 65536)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_event_delete (id_pre)) X_event_delete_oc )) ,
  ((( &( "event" ) )) # Ptr  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_event_delete_oc looked_up )
|--
  “ (event_delete_guard id_pre retval false looked_up ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (looked_up)) (abs_event_delete_at (id_pre) (retval)) X_event_delete_oc ) ”
.

Definition KEventDelete_partial_solve_wit_4_aux := 
forall (id_pre: Z) (X_event_delete_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_event_delete_oc: VarGlobalState) (sg_event_delete_oc: StableGlobalState) (retval: Z) (looked_up: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (looked_up)) (abs_event_delete_at (id_pre) (retval)) X_event_delete_oc )) (PreH2 : (retval <> 0)) (PreH3 : (retval <> 0)) (PreH4 : (event_delete_guard id_pre retval false looked_up )) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (looked_up)) ( MonadErr.ret  (retval)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_find_event (id_pre)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) )) (PreH7 : (0 <= id_pre)) (PreH8 : (id_pre < 65536)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_event_delete (id_pre)) X_event_delete_oc )) ,
  (OutsideCritical sg_event_delete_oc looked_up )
|--
  “ (event_delete_guard id_pre retval false looked_up ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (looked_up)) (abs_event_delete_at (id_pre) (retval)) X_event_delete_oc ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (looked_up)) (abs_event_delete_at (id_pre) (retval)) X_event_delete_oc ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (event_delete_guard id_pre retval false looked_up ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (looked_up)) ( MonadErr.ret  (retval)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_find_event (id_pre)) (kevent_delete_lookup_cont (id_pre) (X_event_delete_oc)) ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre < 65536) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_event_delete (id_pre)) X_event_delete_oc ) ”
  &&  (OutsideCritical sg_event_delete_oc looked_up )
.

Definition KEventDelete_partial_solve_wit_4 := KEventDelete_partial_solve_wit_4_pure -> KEventDelete_partial_solve_wit_4_aux.

Definition KEventDelete_which_implies_wit_1 := 
(
forall (X_event_delete_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_event_delete_oc: VarGlobalState) (sg_event_delete_oc: StableGlobalState) (id: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_event_delete (id)) X_event_delete_oc )) ,
  (OutsideCritical sg_event_delete_oc before_event_delete_oc )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_find_event (id)) (kevent_delete_lookup_cont (id) (X_event_delete_oc)) ) ”
  &&  (OutsideCritical sg_event_delete_oc before_event_delete_oc )
) \/
(
forall (X_event_delete_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_event_delete_oc: VarGlobalState) (id: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_event_delete (id)) X_event_delete_oc )) ,
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_find_event (id)) (kevent_delete_lookup_cont (id) (X_event_delete_oc)) ) ”
  &&  emp
).

Definition KEventDelete_which_implies_wit_1_split_goal_1 := 
forall (X_event_delete_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_event_delete_oc: VarGlobalState) (id: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_event_delete (id)) X_event_delete_oc )) ,
  ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_oc)) (abs_find_event (id)) (kevent_delete_lookup_cont (id) (X_event_delete_oc)) )
.

Definition KEventDelete_which_implies_wit_2 := 
(
forall (X_event_delete_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_event_delete_oc: StableGlobalState) (looked_up: VarGlobalState) (event: Z) (id: Z) (PreH1 : (event <> 0)) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (looked_up)) ( MonadErr.ret  (event)) (kevent_delete_lookup_cont (id) (X_event_delete_oc)) )) ,
  (OutsideCritical sg_event_delete_oc looked_up )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (looked_up)) (abs_event_delete_at (id) (event)) X_event_delete_oc ) ”
  &&  (OutsideCritical sg_event_delete_oc looked_up )
) \/
(
forall (X_event_delete_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (looked_up: VarGlobalState) (event: Z) (id: Z) (PreH1 : (event <> 0)) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (looked_up)) ( MonadErr.ret  (event)) (kevent_delete_lookup_cont (id) (X_event_delete_oc)) )) ,
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (looked_up)) (abs_event_delete_at (id) (event)) X_event_delete_oc ) ”
  &&  emp
).

Definition KEventDelete_which_implies_wit_2_split_goal_1 := 
forall (X_event_delete_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (looked_up: VarGlobalState) (event: Z) (id: Z) (PreH1 : (event <> 0)) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (looked_up)) ( MonadErr.ret  (event)) (kevent_delete_lookup_cont (id) (X_event_delete_oc)) )) ,
  ( monadesafe_lib.safeExec  (LastSeen (looked_up)) (abs_event_delete_at (id) (event)) X_event_delete_oc )
.

Module Type VC_Correct.


Axiom proof_of_KEventDelete_safety_wit_1 : KEventDelete_safety_wit_1.
Axiom proof_of_KEventDelete_safety_wit_2 : KEventDelete_safety_wit_2.
Axiom proof_of_KEventDelete_safety_wit_3 : KEventDelete_safety_wit_3.
Axiom proof_of_KEventDelete_safety_wit_4 : KEventDelete_safety_wit_4.
Axiom proof_of_KEventDelete_return_wit_1 : KEventDelete_return_wit_1.
Axiom proof_of_KEventDelete_return_wit_2 : KEventDelete_return_wit_2.
Axiom proof_of_KEventDelete_partial_solve_wit_1_pure : KEventDelete_partial_solve_wit_1_pure.
Axiom proof_of_KEventDelete_partial_solve_wit_1 : KEventDelete_partial_solve_wit_1.
Axiom proof_of_KEventDelete_partial_solve_wit_2_pure : KEventDelete_partial_solve_wit_2_pure.
Axiom proof_of_KEventDelete_partial_solve_wit_2 : KEventDelete_partial_solve_wit_2.
Axiom proof_of_KEventDelete_partial_solve_wit_3_pure : KEventDelete_partial_solve_wit_3_pure.
Axiom proof_of_KEventDelete_partial_solve_wit_3 : KEventDelete_partial_solve_wit_3.
Axiom proof_of_KEventDelete_partial_solve_wit_4_pure : KEventDelete_partial_solve_wit_4_pure.
Axiom proof_of_KEventDelete_partial_solve_wit_4 : KEventDelete_partial_solve_wit_4.
Axiom proof_of_KEventDelete_which_implies_wit_1 : KEventDelete_which_implies_wit_1.
Axiom proof_of_KEventDelete_which_implies_wit_2 : KEventDelete_which_implies_wit_2.

End VC_Correct.
