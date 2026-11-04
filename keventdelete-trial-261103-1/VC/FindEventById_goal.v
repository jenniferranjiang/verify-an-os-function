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
Require Import CRTOS_Verify.VC.FindEventById_lib.
Local Open Scope sac.

(*----- Function FindEventById -----*)

Definition FindEventById_safety_wit_1 := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre < 65536)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  ((( &( "lock" ) )) # Int  |->_)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_event_lookup_oc before_event_lookup_oc )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition FindEventById_safety_wit_2 := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre < 65536)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  ((( &( "idnode" ) )) # Ptr  |->_)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_event_lookup_oc before_event_lookup_oc )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition FindEventById_safety_wit_3 := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre < 65536)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  ((( &( "event" ) )) # Ptr  |->_)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_event_lookup_oc before_event_lookup_oc )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition FindEventById_safety_wit_4 := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre < 65536)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  ((( &( "event" ) )) # Ptr  |-> 0)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_event_lookup_oc before_event_lookup_oc )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition FindEventById_safety_wit_5 := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (PreH1 : (id_pre < 0)) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre < 65536)) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  ((( &( "event" ) )) # Ptr  |-> 0)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_event_lookup_oc before_event_lookup_oc )
|--
  “ False ”
.

Definition FindEventById_safety_wit_6 := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (( &( "k_event_id_manager" ) ) = 0)) (PreH2 : (retval_2 = 0)) (PreH3 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH4 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH5 : (id_pre >= 0)) (PreH6 : (0 <= id_pre)) (PreH7 : (id_pre < 65536)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_lookup_oc)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (find_event_manager_frame sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
  **  ((( &( "event" ) )) # Ptr  |-> 0)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ False ”
.

Definition FindEventById_safety_wit_7 := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH2 : (retval_2 = 0)) (PreH3 : ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = false)) (PreH4 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH5 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH6 : (id_pre >= 0)) (PreH7 : (0 <= id_pre)) (PreH8 : (id_pre < 65536)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_lookup_oc)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (find_event_manager_frame sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
  **  ((( &( "event" ) )) # Ptr  |-> 0)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition FindEventById_safety_wit_8 := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH2 : (retval_2 <> 0)) (PreH3 : ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = true)) (PreH4 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH5 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH6 : (id_pre >= 0)) (PreH7 : (0 <= id_pre)) (PreH8 : (id_pre < 65536)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  (store_idmanager_found (event_manager_stable ((os_event_stable (sg_event_lookup_oc)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) retval_2 id_pre )
  **  (find_event_manager_frame sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
  **  ((( &( "event" ) )) # Ptr  |-> 0)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition FindEventById_safety_wit_9 := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (retval_2 <> 0)) (PreH2 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH3 : (retval_2 = 0)) (PreH4 : ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = false)) (PreH5 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH6 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH7 : (id_pre >= 0)) (PreH8 : (0 <= id_pre)) (PreH9 : (id_pre < 65536)) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_lookup_oc)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (find_event_manager_frame sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
  **  ((( &( "event" ) )) # Ptr  |-> 0)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ False ”
.

Definition FindEventById_safety_wit_10 := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH3 : (retval_2 <> 0)) (PreH4 : ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = true)) (PreH5 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH6 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH7 : (id_pre >= 0)) (PreH8 : (0 <= id_pre)) (PreH9 : (id_pre < 65536)) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  (store_idmanager_found (event_manager_stable ((os_event_stable (sg_event_lookup_oc)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) retval_2 id_pre )
  **  (find_event_manager_frame sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
  **  ((( &( "event" ) )) # Ptr  |-> 0)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ False ”
.

Definition FindEventById_safety_wit_11 := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (0)) X_event_lookup_oc )) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre < 65536)) (PreH4 : (Crtos_GTrans st_lock st_lock )) (PreH5 : (event_lookup_result id_pre 0 st_lock )) (PreH6 : (retval_2 = 0)) (PreH7 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH8 : (retval_2 = 0)) (PreH9 : ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = false)) (PreH10 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH11 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH12 : (id_pre >= 0)) (PreH13 : (0 <= id_pre)) (PreH14 : (id_pre < 65536)) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  (OutsideCritical sg_event_lookup_oc st_lock )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "event" ) )) # Ptr  |-> 0)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "lock" ) )) # Int  |-> retval)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition FindEventById_return_wit_1 := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (st_lock: VarGlobalState) (retval_2: Z) (found: Z) (retval: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (retval)) X_event_lookup_oc )) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre < 65536)) (PreH4 : (Crtos_GTrans st_lock st_lock )) (PreH5 : (retval = found)) (PreH6 : (retval_2 = &((retval)  # "Event" ->ₛ "id"))) (PreH7 : (found <> 0)) (PreH8 : (retval_2 = &((found)  # "Event" ->ₛ "id"))) (PreH9 : (event_delete_guard id_pre found false st_lock )) (PreH10 : (event_lookup_result id_pre found st_lock )) (PreH11 : (retval_2 <> 0)) (PreH12 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH13 : (retval_2 <> 0)) (PreH14 : ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = true)) (PreH15 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH16 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH17 : (id_pre >= 0)) (PreH18 : (0 <= id_pre)) (PreH19 : (id_pre < 65536)) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  (OutsideCritical sg_event_lookup_oc st_lock )
|--
  EX (after_2: VarGlobalState) ,
  “ (retval <> 0) ” 
  &&  “ (event_delete_guard id_pre retval false after_2 ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after_2)) ( MonadErr.ret  (retval)) X_event_lookup_oc ) ”
  &&  (OutsideCritical sg_event_lookup_oc after_2 )
.

Definition FindEventById_return_wit_2 := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (0)) X_event_lookup_oc )) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre < 65536)) (PreH4 : (Crtos_GTrans st_lock st_lock )) (PreH5 : (event_lookup_result id_pre 0 st_lock )) (PreH6 : (retval = 0)) (PreH7 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH8 : (retval = 0)) (PreH9 : ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = false)) (PreH10 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH11 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH12 : (id_pre >= 0)) (PreH13 : (0 <= id_pre)) (PreH14 : (id_pre < 65536)) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  (OutsideCritical sg_event_lookup_oc st_lock )
|--
  EX (after: VarGlobalState) ,
  “ (0 = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (0)) X_event_lookup_oc ) ”
  &&  (OutsideCritical sg_event_lookup_oc after )
.

Definition FindEventById_partial_solve_wit_1 := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (PreH1 : (id_pre >= 0)) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre < 65536)) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  (OutsideCritical sg_event_lookup_oc before_event_lookup_oc )
|--
  “ (id_pre >= 0) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre < 65536) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc ) ”
  &&  (OutsideCritical sg_event_lookup_oc before_event_lookup_oc )
.

Definition FindEventById_partial_solve_wit_2 := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (st_lock: VarGlobalState) (PreH1 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH2 : (id_pre >= 0)) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre < 65536)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  (InsideCritical sg_event_lookup_oc st_lock )
  **  (os_inv sg_event_lookup_oc st_lock )
|--
  “ (Crtos_RTrans before_event_lookup_oc st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre < 65536) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc ) ”
  &&  (os_inv sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
.

Definition FindEventById_partial_solve_wit_3_pure := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (PreH1 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH2 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH3 : (id_pre >= 0)) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre < 65536)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_lookup_oc)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (find_event_manager_frame sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
  **  ((( &( "event" ) )) # Ptr  |-> 0)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (0 <= id_pre) ” 
  &&  “ (id_pre < 65536) ”
.

Definition FindEventById_partial_solve_wit_3_aux := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (st_lock: VarGlobalState) (PreH1 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH2 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH3 : (id_pre >= 0)) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre < 65536)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_lookup_oc)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (find_event_manager_frame sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
|--
  “ (0 <= id_pre) ” 
  &&  “ (id_pre < 65536) ” 
  &&  “ (( &( "k_event_id_manager" ) ) <> 0) ” 
  &&  “ (Crtos_RTrans before_event_lookup_oc st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre < 65536) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc ) ”
  &&  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_lookup_oc)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (find_event_manager_frame sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
.

Definition FindEventById_partial_solve_wit_3 := FindEventById_partial_solve_wit_3_pure -> FindEventById_partial_solve_wit_3_aux.

Definition FindEventById_partial_solve_wit_4_pure := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH3 : (retval_2 = 0)) (PreH4 : ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = false)) (PreH5 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH6 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH7 : (id_pre >= 0)) (PreH8 : (0 <= id_pre)) (PreH9 : (id_pre < 65536)) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_lookup_oc)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (find_event_manager_frame sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
  **  ((( &( "event" ) )) # Ptr  |-> 0)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = false) ”
.

Definition FindEventById_partial_solve_wit_4_aux := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH3 : (retval_2 = 0)) (PreH4 : ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = false)) (PreH5 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH6 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH7 : (id_pre >= 0)) (PreH8 : (0 <= id_pre)) (PreH9 : (id_pre < 65536)) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_lookup_oc)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (find_event_manager_frame sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
|--
  “ ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = false) ” 
  &&  “ (retval_2 = 0) ” 
  &&  “ (( &( "k_event_id_manager" ) ) <> 0) ” 
  &&  “ (retval_2 = 0) ” 
  &&  “ ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = false) ” 
  &&  “ (( &( "k_event_id_manager" ) ) <> 0) ” 
  &&  “ (Crtos_RTrans before_event_lookup_oc st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre < 65536) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc ) ”
  &&  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_lookup_oc)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (find_event_manager_frame sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
.

Definition FindEventById_partial_solve_wit_4 := FindEventById_partial_solve_wit_4_pure -> FindEventById_partial_solve_wit_4_aux.

Definition FindEventById_partial_solve_wit_5_pure := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (event_lookup_result id_pre 0 st_lock )) (PreH2 : (retval_2 = 0)) (PreH3 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH4 : (retval_2 = 0)) (PreH5 : ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = false)) (PreH6 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH7 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH8 : (id_pre >= 0)) (PreH9 : (0 <= id_pre)) (PreH10 : (id_pre < 65536)) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (os_inv sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
  **  ((( &( "event" ) )) # Ptr  |-> 0)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "lock" ) )) # Int  |-> retval)
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc ) ” 
  &&  “ (Crtos_RTrans before_event_lookup_oc st_lock ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre < 65536) ” 
  &&  “ (event_lookup_result id_pre 0 st_lock ) ”
.

Definition FindEventById_partial_solve_wit_5_aux := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (event_lookup_result id_pre 0 st_lock )) (PreH2 : (retval_2 = 0)) (PreH3 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH4 : (retval_2 = 0)) (PreH5 : ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = false)) (PreH6 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH7 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH8 : (id_pre >= 0)) (PreH9 : (0 <= id_pre)) (PreH10 : (id_pre < 65536)) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  (os_inv sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc ) ” 
  &&  “ (Crtos_RTrans before_event_lookup_oc st_lock ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre < 65536) ” 
  &&  “ (event_lookup_result id_pre 0 st_lock ) ” 
  &&  “ (event_lookup_result id_pre 0 st_lock ) ” 
  &&  “ (retval_2 = 0) ” 
  &&  “ (( &( "k_event_id_manager" ) ) <> 0) ” 
  &&  “ (retval_2 = 0) ” 
  &&  “ ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = false) ” 
  &&  “ (( &( "k_event_id_manager" ) ) <> 0) ” 
  &&  “ (Crtos_RTrans before_event_lookup_oc st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre < 65536) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc ) ”
  &&  (os_inv sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
.

Definition FindEventById_partial_solve_wit_5 := FindEventById_partial_solve_wit_5_pure -> FindEventById_partial_solve_wit_5_aux.

Definition FindEventById_partial_solve_wit_6_pure := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (0)) X_event_lookup_oc )) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre < 65536)) (PreH4 : (Crtos_GTrans st_lock st_lock )) (PreH5 : (event_lookup_result id_pre 0 st_lock )) (PreH6 : (retval_2 = 0)) (PreH7 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH8 : (retval_2 = 0)) (PreH9 : ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = false)) (PreH10 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH11 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH12 : (id_pre >= 0)) (PreH13 : (0 <= id_pre)) (PreH14 : (id_pre < 65536)) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (os_inv sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
  **  ((( &( "event" ) )) # Ptr  |-> 0)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "lock" ) )) # Int  |-> retval)
|--
  “ (Crtos_GTrans st_lock st_lock ) ”
.

Definition FindEventById_partial_solve_wit_6_aux := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (0)) X_event_lookup_oc )) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre < 65536)) (PreH4 : (Crtos_GTrans st_lock st_lock )) (PreH5 : (event_lookup_result id_pre 0 st_lock )) (PreH6 : (retval_2 = 0)) (PreH7 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH8 : (retval_2 = 0)) (PreH9 : ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = false)) (PreH10 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH11 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH12 : (id_pre >= 0)) (PreH13 : (0 <= id_pre)) (PreH14 : (id_pre < 65536)) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  (os_inv sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
|--
  “ (Crtos_GTrans st_lock st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (0)) X_event_lookup_oc ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre < 65536) ” 
  &&  “ (Crtos_GTrans st_lock st_lock ) ” 
  &&  “ (event_lookup_result id_pre 0 st_lock ) ” 
  &&  “ (retval_2 = 0) ” 
  &&  “ (( &( "k_event_id_manager" ) ) <> 0) ” 
  &&  “ (retval_2 = 0) ” 
  &&  “ ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = false) ” 
  &&  “ (( &( "k_event_id_manager" ) ) <> 0) ” 
  &&  “ (Crtos_RTrans before_event_lookup_oc st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre < 65536) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc ) ”
  &&  (InsideCritical sg_event_lookup_oc st_lock )
  **  (os_inv sg_event_lookup_oc st_lock )
.

Definition FindEventById_partial_solve_wit_6 := FindEventById_partial_solve_wit_6_pure -> FindEventById_partial_solve_wit_6_aux.

Definition FindEventById_partial_solve_wit_7_pure := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (retval_2: Z) (st_lock: VarGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH3 : (retval <> 0)) (PreH4 : ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = true)) (PreH5 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH6 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH7 : (id_pre >= 0)) (PreH8 : (0 <= id_pre)) (PreH9 : (id_pre < 65536)) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  (store_idmanager_found (event_manager_stable ((os_event_stable (sg_event_lookup_oc)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) retval id_pre )
  **  (find_event_manager_frame sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
  **  ((( &( "event" ) )) # Ptr  |-> 0)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> retval_2)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (retval <> 0) ”
.

Definition FindEventById_partial_solve_wit_7_aux := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH3 : (retval <> 0)) (PreH4 : ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = true)) (PreH5 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH6 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH7 : (id_pre >= 0)) (PreH8 : (0 <= id_pre)) (PreH9 : (id_pre < 65536)) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  (store_idmanager_found (event_manager_stable ((os_event_stable (sg_event_lookup_oc)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) retval id_pre )
  **  (find_event_manager_frame sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
|--
  “ (retval <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (( &( "k_event_id_manager" ) ) <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = true) ” 
  &&  “ (( &( "k_event_id_manager" ) ) <> 0) ” 
  &&  “ (Crtos_RTrans before_event_lookup_oc st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre < 65536) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc ) ”
  &&  (store_idmanager_found (event_manager_stable ((os_event_stable (sg_event_lookup_oc)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) retval id_pre )
  **  (find_event_manager_frame sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
.

Definition FindEventById_partial_solve_wit_7 := FindEventById_partial_solve_wit_7_pure -> FindEventById_partial_solve_wit_7_aux.

Definition FindEventById_partial_solve_wit_8_pure := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (retval_2: Z) (st_lock: VarGlobalState) (retval: Z) (found: Z) (PreH1 : (found <> 0)) (PreH2 : (retval = &((found)  # "Event" ->ₛ "id"))) (PreH3 : (event_delete_guard id_pre found false st_lock )) (PreH4 : (event_lookup_result id_pre found st_lock )) (PreH5 : (retval <> 0)) (PreH6 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH7 : (retval <> 0)) (PreH8 : ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = true)) (PreH9 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH10 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH11 : (id_pre >= 0)) (PreH12 : (0 <= id_pre)) (PreH13 : (id_pre < 65536)) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  ((( &( "idnode" ) )) # Ptr  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (os_inv sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
  **  ((( &( "event" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval_2)
|--
  “ (retval = &((found)  # "Event" ->ₛ "id")) ”
.

Definition FindEventById_partial_solve_wit_8_aux := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (found: Z) (PreH1 : (found <> 0)) (PreH2 : (retval = &((found)  # "Event" ->ₛ "id"))) (PreH3 : (event_delete_guard id_pre found false st_lock )) (PreH4 : (event_lookup_result id_pre found st_lock )) (PreH5 : (retval <> 0)) (PreH6 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH7 : (retval <> 0)) (PreH8 : ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = true)) (PreH9 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH10 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH11 : (id_pre >= 0)) (PreH12 : (0 <= id_pre)) (PreH13 : (id_pre < 65536)) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  (os_inv sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
|--
  “ (retval = &((found)  # "Event" ->ₛ "id")) ” 
  &&  “ (found <> 0) ” 
  &&  “ (retval = &((found)  # "Event" ->ₛ "id")) ” 
  &&  “ (event_delete_guard id_pre found false st_lock ) ” 
  &&  “ (event_lookup_result id_pre found st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (( &( "k_event_id_manager" ) ) <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = true) ” 
  &&  “ (( &( "k_event_id_manager" ) ) <> 0) ” 
  &&  “ (Crtos_RTrans before_event_lookup_oc st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre < 65536) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc ) ”
  &&  (os_inv sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
.

Definition FindEventById_partial_solve_wit_8 := FindEventById_partial_solve_wit_8_pure -> FindEventById_partial_solve_wit_8_aux.

Definition FindEventById_partial_solve_wit_9_pure := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (retval_2: Z) (st_lock: VarGlobalState) (retval_3: Z) (found: Z) (retval: Z) (PreH1 : (retval = found)) (PreH2 : (retval_3 = &((retval)  # "Event" ->ₛ "id"))) (PreH3 : (found <> 0)) (PreH4 : (retval_3 = &((found)  # "Event" ->ₛ "id"))) (PreH5 : (event_delete_guard id_pre found false st_lock )) (PreH6 : (event_lookup_result id_pre found st_lock )) (PreH7 : (retval_3 <> 0)) (PreH8 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH9 : (retval_3 <> 0)) (PreH10 : ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = true)) (PreH11 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH12 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH13 : (id_pre >= 0)) (PreH14 : (0 <= id_pre)) (PreH15 : (id_pre < 65536)) (PreH16 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  ((( &( "idnode" ) )) # Ptr  |-> retval_3)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (os_inv sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> retval_2)
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc ) ” 
  &&  “ (Crtos_RTrans before_event_lookup_oc st_lock ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre < 65536) ” 
  &&  “ (event_lookup_result id_pre retval st_lock ) ”
.

Definition FindEventById_partial_solve_wit_9_aux := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (st_lock: VarGlobalState) (retval_3: Z) (found: Z) (retval: Z) (PreH1 : (retval = found)) (PreH2 : (retval_3 = &((retval)  # "Event" ->ₛ "id"))) (PreH3 : (found <> 0)) (PreH4 : (retval_3 = &((found)  # "Event" ->ₛ "id"))) (PreH5 : (event_delete_guard id_pre found false st_lock )) (PreH6 : (event_lookup_result id_pre found st_lock )) (PreH7 : (retval_3 <> 0)) (PreH8 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH9 : (retval_3 <> 0)) (PreH10 : ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = true)) (PreH11 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH12 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH13 : (id_pre >= 0)) (PreH14 : (0 <= id_pre)) (PreH15 : (id_pre < 65536)) (PreH16 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  (os_inv sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc ) ” 
  &&  “ (Crtos_RTrans before_event_lookup_oc st_lock ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre < 65536) ” 
  &&  “ (event_lookup_result id_pre retval st_lock ) ” 
  &&  “ (retval = found) ” 
  &&  “ (retval_3 = &((retval)  # "Event" ->ₛ "id")) ” 
  &&  “ (found <> 0) ” 
  &&  “ (retval_3 = &((found)  # "Event" ->ₛ "id")) ” 
  &&  “ (event_delete_guard id_pre found false st_lock ) ” 
  &&  “ (event_lookup_result id_pre found st_lock ) ” 
  &&  “ (retval_3 <> 0) ” 
  &&  “ (( &( "k_event_id_manager" ) ) <> 0) ” 
  &&  “ (retval_3 <> 0) ” 
  &&  “ ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = true) ” 
  &&  “ (( &( "k_event_id_manager" ) ) <> 0) ” 
  &&  “ (Crtos_RTrans before_event_lookup_oc st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre < 65536) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc ) ”
  &&  (os_inv sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
.

Definition FindEventById_partial_solve_wit_9 := FindEventById_partial_solve_wit_9_pure -> FindEventById_partial_solve_wit_9_aux.

Definition FindEventById_partial_solve_wit_10_pure := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (found: Z) (retval_3: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (retval_3)) X_event_lookup_oc )) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre < 65536)) (PreH4 : (Crtos_GTrans st_lock st_lock )) (PreH5 : (retval_3 = found)) (PreH6 : (retval_2 = &((retval_3)  # "Event" ->ₛ "id"))) (PreH7 : (found <> 0)) (PreH8 : (retval_2 = &((found)  # "Event" ->ₛ "id"))) (PreH9 : (event_delete_guard id_pre found false st_lock )) (PreH10 : (event_lookup_result id_pre found st_lock )) (PreH11 : (retval_2 <> 0)) (PreH12 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH13 : (retval_2 <> 0)) (PreH14 : ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = true)) (PreH15 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH16 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH17 : (id_pre >= 0)) (PreH18 : (0 <= id_pre)) (PreH19 : (id_pre < 65536)) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  ((( &( "event" ) )) # Ptr  |-> retval_3)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (os_inv sg_event_lookup_oc st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  (InsideCritical sg_event_lookup_oc st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval)
|--
  “ (Crtos_GTrans st_lock st_lock ) ”
.

Definition FindEventById_partial_solve_wit_10_aux := 
forall (id_pre: Z) (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (st_lock: VarGlobalState) (retval_2: Z) (found: Z) (retval_3: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (retval_3)) X_event_lookup_oc )) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre < 65536)) (PreH4 : (Crtos_GTrans st_lock st_lock )) (PreH5 : (retval_3 = found)) (PreH6 : (retval_2 = &((retval_3)  # "Event" ->ₛ "id"))) (PreH7 : (found <> 0)) (PreH8 : (retval_2 = &((found)  # "Event" ->ₛ "id"))) (PreH9 : (event_delete_guard id_pre found false st_lock )) (PreH10 : (event_lookup_result id_pre found st_lock )) (PreH11 : (retval_2 <> 0)) (PreH12 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH13 : (retval_2 <> 0)) (PreH14 : ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = true)) (PreH15 : (( &( "k_event_id_manager" ) ) <> 0)) (PreH16 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH17 : (id_pre >= 0)) (PreH18 : (0 <= id_pre)) (PreH19 : (id_pre < 65536)) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc )) ,
  (os_inv sg_event_lookup_oc st_lock )
  **  (InsideCritical sg_event_lookup_oc st_lock )
|--
  “ (Crtos_GTrans st_lock st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (retval_3)) X_event_lookup_oc ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre < 65536) ” 
  &&  “ (Crtos_GTrans st_lock st_lock ) ” 
  &&  “ (retval_3 = found) ” 
  &&  “ (retval_2 = &((retval_3)  # "Event" ->ₛ "id")) ” 
  &&  “ (found <> 0) ” 
  &&  “ (retval_2 = &((found)  # "Event" ->ₛ "id")) ” 
  &&  “ (event_delete_guard id_pre found false st_lock ) ” 
  &&  “ (event_lookup_result id_pre found st_lock ) ” 
  &&  “ (retval_2 <> 0) ” 
  &&  “ (( &( "k_event_id_manager" ) ) <> 0) ” 
  &&  “ (retval_2 <> 0) ” 
  &&  “ ((idmanager_query ((event_manager ((os_events (st_lock))))) (id_pre)) = true) ” 
  &&  “ (( &( "k_event_id_manager" ) ) <> 0) ” 
  &&  “ (Crtos_RTrans before_event_lookup_oc st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre < 65536) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id_pre)) X_event_lookup_oc ) ”
  &&  (InsideCritical sg_event_lookup_oc st_lock )
  **  (os_inv sg_event_lookup_oc st_lock )
.

Definition FindEventById_partial_solve_wit_10 := FindEventById_partial_solve_wit_10_pure -> FindEventById_partial_solve_wit_10_aux.

Definition FindEventById_which_implies_wit_1 := 
(
forall (sg_event_lookup_oc: StableGlobalState) (st_lock: VarGlobalState) ,
  (os_inv sg_event_lookup_oc st_lock )
|--
  “ (( &( "k_event_id_manager" ) ) <> 0) ”
  &&  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_lookup_oc)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (find_event_manager_frame sg_event_lookup_oc st_lock )
) \/
(
forall (sg_event_lookup_oc: StableGlobalState) (st_lock: VarGlobalState) ,
  (os_inv sg_event_lookup_oc st_lock )
|--
  “ (( &( "k_event_id_manager" ) ) <> 0) ”
  &&  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_lookup_oc)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (find_event_manager_frame sg_event_lookup_oc st_lock )
).

Definition FindEventById_which_implies_wit_1_split_goal_1 := 
forall (sg_event_lookup_oc: StableGlobalState) (st_lock: VarGlobalState) ,
  (os_inv sg_event_lookup_oc st_lock )
|--
  “ (( &( "k_event_id_manager" ) ) <> 0) ”
.

Definition FindEventById_which_implies_wit_1_split_goal_spatial := 
forall (sg_event_lookup_oc: StableGlobalState) (st_lock: VarGlobalState) ,
  (os_inv sg_event_lookup_oc st_lock )
|--
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_lookup_oc)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (find_event_manager_frame sg_event_lookup_oc st_lock )
.

Definition FindEventById_which_implies_wit_2 := 
(
forall (sg_event_lookup_oc: StableGlobalState) (st_lock: VarGlobalState) (id: Z) (PreH1 : ((idmanager_query ((event_manager ((os_events (st_lock))))) (id)) = false)) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_lookup_oc)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (find_event_manager_frame sg_event_lookup_oc st_lock )
|--
  “ (event_lookup_result id 0 st_lock ) ”
  &&  (os_inv sg_event_lookup_oc st_lock )
) \/
(
forall (sg_event_lookup_oc: StableGlobalState) (st_lock: VarGlobalState) (id: Z) (PreH1 : ((idmanager_query ((event_manager ((os_events (st_lock))))) (id)) = false)) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_lookup_oc)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (find_event_manager_frame sg_event_lookup_oc st_lock )
|--
  “ (event_lookup_result id 0 st_lock ) ”
  &&  (os_inv sg_event_lookup_oc st_lock )
).

Definition FindEventById_which_implies_wit_2_split_goal_1 := 
forall (sg_event_lookup_oc: StableGlobalState) (st_lock: VarGlobalState) (id: Z) (PreH1 : ((idmanager_query ((event_manager ((os_events (st_lock))))) (id)) = false)) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_lookup_oc)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (find_event_manager_frame sg_event_lookup_oc st_lock )
|--
  “ (event_lookup_result id 0 st_lock ) ”
.

Definition FindEventById_which_implies_wit_2_split_goal_spatial := 
forall (sg_event_lookup_oc: StableGlobalState) (st_lock: VarGlobalState) (id: Z) (PreH1 : ((idmanager_query ((event_manager ((os_events (st_lock))))) (id)) = false)) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_lookup_oc)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (find_event_manager_frame sg_event_lookup_oc st_lock )
|--
  (os_inv sg_event_lookup_oc st_lock )
.

Definition FindEventById_which_implies_wit_3 := 
(
forall (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (st_lock: VarGlobalState) (id: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id)) X_event_lookup_oc )) (PreH2 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH3 : (0 <= id)) (PreH4 : (id < 65536)) (PreH5 : (event_lookup_result id 0 st_lock )) ,
  (os_inv sg_event_lookup_oc st_lock )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (0)) X_event_lookup_oc ) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id < 65536) ” 
  &&  “ (Crtos_GTrans st_lock st_lock ) ”
  &&  (os_inv sg_event_lookup_oc st_lock )
) \/
(
forall (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (st_lock: VarGlobalState) (id: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id)) X_event_lookup_oc )) (PreH2 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH3 : (0 <= id)) (PreH4 : (id < 65536)) (PreH5 : (event_lookup_result id 0 st_lock )) ,
  TT && emp 
|--
  “ (Crtos_GTrans st_lock st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (0)) X_event_lookup_oc ) ”
  &&  emp
).

Definition FindEventById_which_implies_wit_3_split_goal_1 := 
forall (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (st_lock: VarGlobalState) (id: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id)) X_event_lookup_oc )) (PreH2 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH3 : (0 <= id)) (PreH4 : (id < 65536)) (PreH5 : (event_lookup_result id 0 st_lock )) ,
  (Crtos_GTrans st_lock st_lock )
.

Definition FindEventById_which_implies_wit_3_split_goal_2 := 
forall (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (st_lock: VarGlobalState) (id: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id)) X_event_lookup_oc )) (PreH2 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH3 : (0 <= id)) (PreH4 : (id < 65536)) (PreH5 : (event_lookup_result id 0 st_lock )) ,
  ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (0)) X_event_lookup_oc )
.

Definition FindEventById_which_implies_wit_4 := 
(
forall (sg_event_lookup_oc: StableGlobalState) (st_lock: VarGlobalState) (idnode: Z) (id: Z) (PreH1 : (idnode <> 0)) ,
  (store_idmanager_found (event_manager_stable ((os_event_stable (sg_event_lookup_oc)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) idnode id )
  **  (find_event_manager_frame sg_event_lookup_oc st_lock )
|--
  EX (found: Z) ,
  “ (found <> 0) ” 
  &&  “ (idnode = &((found)  # "Event" ->ₛ "id")) ” 
  &&  “ (event_delete_guard id found false st_lock ) ” 
  &&  “ (event_lookup_result id found st_lock ) ”
  &&  (os_inv sg_event_lookup_oc st_lock )
) \/
(
forall (sg_event_lookup_oc: StableGlobalState) (st_lock: VarGlobalState) (idnode: Z) (id: Z) (PreH1 : (idnode <> 0)) ,
  (store_idmanager_found (event_manager_stable ((os_event_stable (sg_event_lookup_oc)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) idnode id )
  **  (find_event_manager_frame sg_event_lookup_oc st_lock )
|--
  EX (found: Z) ,
  “ (found <> 0) ” 
  &&  “ (idnode = &((found)  # "Event" ->ₛ "id")) ” 
  &&  “ (event_delete_guard id found false st_lock ) ” 
  &&  “ (event_lookup_result id found st_lock ) ”
  &&  (os_inv sg_event_lookup_oc st_lock )
).

Definition FindEventById_which_implies_wit_5 := 
(
forall (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (sg_event_lookup_oc: StableGlobalState) (st_lock: VarGlobalState) (id: Z) (event: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id)) X_event_lookup_oc )) (PreH2 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH3 : (0 <= id)) (PreH4 : (id < 65536)) (PreH5 : (event_lookup_result id event st_lock )) ,
  (os_inv sg_event_lookup_oc st_lock )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (event)) X_event_lookup_oc ) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id < 65536) ” 
  &&  “ (Crtos_GTrans st_lock st_lock ) ”
  &&  (os_inv sg_event_lookup_oc st_lock )
) \/
(
forall (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (st_lock: VarGlobalState) (id: Z) (event: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id)) X_event_lookup_oc )) (PreH2 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH3 : (0 <= id)) (PreH4 : (id < 65536)) (PreH5 : (event_lookup_result id event st_lock )) ,
  TT && emp 
|--
  “ (Crtos_GTrans st_lock st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (event)) X_event_lookup_oc ) ”
  &&  emp
).

Definition FindEventById_which_implies_wit_5_split_goal_1 := 
forall (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (st_lock: VarGlobalState) (id: Z) (event: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id)) X_event_lookup_oc )) (PreH2 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH3 : (0 <= id)) (PreH4 : (id < 65536)) (PreH5 : (event_lookup_result id event st_lock )) ,
  (Crtos_GTrans st_lock st_lock )
.

Definition FindEventById_which_implies_wit_5_split_goal_2 := 
forall (X_event_lookup_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_event_lookup_oc: VarGlobalState) (st_lock: VarGlobalState) (id: Z) (event: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_event_lookup_oc)) (abs_find_event (id)) X_event_lookup_oc )) (PreH2 : (Crtos_RTrans before_event_lookup_oc st_lock )) (PreH3 : (0 <= id)) (PreH4 : (id < 65536)) (PreH5 : (event_lookup_result id event st_lock )) ,
  ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (event)) X_event_lookup_oc )
.

Module Type VC_Correct.


Axiom proof_of_FindEventById_safety_wit_1 : FindEventById_safety_wit_1.
Axiom proof_of_FindEventById_safety_wit_2 : FindEventById_safety_wit_2.
Axiom proof_of_FindEventById_safety_wit_3 : FindEventById_safety_wit_3.
Axiom proof_of_FindEventById_safety_wit_4 : FindEventById_safety_wit_4.
Axiom proof_of_FindEventById_safety_wit_5 : FindEventById_safety_wit_5.
Axiom proof_of_FindEventById_safety_wit_6 : FindEventById_safety_wit_6.
Axiom proof_of_FindEventById_safety_wit_7 : FindEventById_safety_wit_7.
Axiom proof_of_FindEventById_safety_wit_8 : FindEventById_safety_wit_8.
Axiom proof_of_FindEventById_safety_wit_9 : FindEventById_safety_wit_9.
Axiom proof_of_FindEventById_safety_wit_10 : FindEventById_safety_wit_10.
Axiom proof_of_FindEventById_safety_wit_11 : FindEventById_safety_wit_11.
Axiom proof_of_FindEventById_return_wit_1 : FindEventById_return_wit_1.
Axiom proof_of_FindEventById_return_wit_2 : FindEventById_return_wit_2.
Axiom proof_of_FindEventById_partial_solve_wit_1 : FindEventById_partial_solve_wit_1.
Axiom proof_of_FindEventById_partial_solve_wit_2 : FindEventById_partial_solve_wit_2.
Axiom proof_of_FindEventById_partial_solve_wit_3_pure : FindEventById_partial_solve_wit_3_pure.
Axiom proof_of_FindEventById_partial_solve_wit_3 : FindEventById_partial_solve_wit_3.
Axiom proof_of_FindEventById_partial_solve_wit_4_pure : FindEventById_partial_solve_wit_4_pure.
Axiom proof_of_FindEventById_partial_solve_wit_4 : FindEventById_partial_solve_wit_4.
Axiom proof_of_FindEventById_partial_solve_wit_5_pure : FindEventById_partial_solve_wit_5_pure.
Axiom proof_of_FindEventById_partial_solve_wit_5 : FindEventById_partial_solve_wit_5.
Axiom proof_of_FindEventById_partial_solve_wit_6_pure : FindEventById_partial_solve_wit_6_pure.
Axiom proof_of_FindEventById_partial_solve_wit_6 : FindEventById_partial_solve_wit_6.
Axiom proof_of_FindEventById_partial_solve_wit_7_pure : FindEventById_partial_solve_wit_7_pure.
Axiom proof_of_FindEventById_partial_solve_wit_7 : FindEventById_partial_solve_wit_7.
Axiom proof_of_FindEventById_partial_solve_wit_8_pure : FindEventById_partial_solve_wit_8_pure.
Axiom proof_of_FindEventById_partial_solve_wit_8 : FindEventById_partial_solve_wit_8.
Axiom proof_of_FindEventById_partial_solve_wit_9_pure : FindEventById_partial_solve_wit_9_pure.
Axiom proof_of_FindEventById_partial_solve_wit_9 : FindEventById_partial_solve_wit_9.
Axiom proof_of_FindEventById_partial_solve_wit_10_pure : FindEventById_partial_solve_wit_10_pure.
Axiom proof_of_FindEventById_partial_solve_wit_10 : FindEventById_partial_solve_wit_10.
Axiom proof_of_FindEventById_which_implies_wit_1 : FindEventById_which_implies_wit_1.
Axiom proof_of_FindEventById_which_implies_wit_2 : FindEventById_which_implies_wit_2.
Axiom proof_of_FindEventById_which_implies_wit_3 : FindEventById_which_implies_wit_3.
Axiom proof_of_FindEventById_which_implies_wit_4 : FindEventById_which_implies_wit_4.
Axiom proof_of_FindEventById_which_implies_wit_5 : FindEventById_which_implies_wit_5.

End VC_Correct.
