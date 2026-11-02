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
Require Import CRTOS_Verify.VC.EventCreate_lib.
Local Open Scope sac.

(*----- Function _EventCreate -----*)

Definition _EventCreate_safety_wit_1 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (PreH1 : (0 <= options_pre)) (PreH2 : (options_pre <= UINT_MAX)) (PreH3 : (options_pre <= UINT_MAX)) (PreH4 : (options_pre >= 0)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  ((( &( "id" ) )) # Int  |->_)
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _EventCreate_safety_wit_2 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (PreH1 : (0 <= options_pre)) (PreH2 : (options_pre <= UINT_MAX)) (PreH3 : (options_pre <= UINT_MAX)) (PreH4 : (options_pre >= 0)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  ((( &( "lock" ) )) # Int  |->_)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _EventCreate_safety_wit_3 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (PreH1 : (0 <= options_pre)) (PreH2 : (options_pre <= UINT_MAX)) (PreH3 : (options_pre <= UINT_MAX)) (PreH4 : (options_pre >= 0)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  ((( &( "event" ) )) # Ptr  |->_)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _EventCreate_safety_wit_4 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (0 <= options_pre)) (PreH3 : (options_pre <= UINT_MAX)) (PreH4 : (options_pre <= UINT_MAX)) (PreH5 : (options_pre >= 0)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  ((( &( "event" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _EventCreate_safety_wit_5 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (PreH1 : (0 < retval)) (PreH2 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH3 : (addr_aligned retval 4 )) (PreH4 : (0 <= options_pre)) (PreH5 : (options_pre <= UINT_MAX)) (PreH6 : (options_pre <= UINT_MAX)) (PreH7 : (options_pre >= 0)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (CharArray.undef_full retval sizeof( "Event" ) )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _EventCreate_safety_wit_6 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (retval = 0)) (PreH3 : (0 <= options_pre)) (PreH4 : (options_pre <= UINT_MAX)) (PreH5 : (options_pre <= UINT_MAX)) (PreH6 : (options_pre >= 0)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  ((( &( "event" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ False ”
.

Definition _EventCreate_safety_wit_7 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (0 < retval)) (PreH3 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH4 : (addr_aligned retval 4 )) (PreH5 : (0 <= options_pre)) (PreH6 : (options_pre <= UINT_MAX)) (PreH7 : (options_pre <= UINT_MAX)) (PreH8 : (options_pre >= 0)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (CharArray.undef_full retval sizeof( "Event" ) )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ False ”
.

Definition _EventCreate_safety_wit_8 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : (0 <= options_pre)) (PreH4 : (options_pre <= UINT_MAX)) (PreH5 : (options_pre <= UINT_MAX)) (PreH6 : (options_pre >= 0)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  ((( &( "event" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (5 <> (INT_MIN)) ”
.

Definition _EventCreate_safety_wit_9 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : (0 <= options_pre)) (PreH4 : (options_pre <= UINT_MAX)) (PreH5 : (options_pre <= UINT_MAX)) (PreH6 : (options_pre >= 0)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  ((( &( "event" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (5 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 5) ”
.

Definition _EventCreate_safety_wit_10 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (0 < retval)) (PreH3 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH4 : (addr_aligned retval 4 )) (PreH5 : (0 <= options_pre)) (PreH6 : (options_pre <= UINT_MAX)) (PreH7 : (options_pre <= UINT_MAX)) (PreH8 : (options_pre >= 0)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (CharArray.undef_full retval sizeof( "Event" ) )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _EventCreate_safety_wit_11 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH2 : (0 <= UINT_MAX)) (PreH3 : (0 >= 0)) (PreH4 : (retval_3 <= INT_MAX)) (PreH5 : (retval_3 >= INT_MIN)) (PreH6 : (retval_4 = (-1))) (PreH7 : (retval <> 0)) (PreH8 : (addr_aligned retval 4 )) (PreH9 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH10 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH11 : (Crtos_RTrans before_outside_critical st_lock )) (PreH12 : (retval <> 0)) (PreH13 : (addr_aligned retval 4 )) (PreH14 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH15 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH16 : (retval_2 = retval)) (PreH17 : (retval <> 0)) (PreH18 : (0 < retval)) (PreH19 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH20 : (addr_aligned retval 4 )) (PreH21 : (0 <= options_pre)) (PreH22 : (options_pre <= UINT_MAX)) (PreH23 : (options_pre <= UINT_MAX)) (PreH24 : (options_pre >= 0)) (PreH25 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  ((( &( "id" ) )) # Int  |-> retval_4)
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (store_idnode_insert_ready &((retval)  # "Event" ->ₛ "id") )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  (event_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  ((&((retval)  # "Event" ->ₛ "options")) # UInt  |-> 0)
  **  ((&((retval)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((retval)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Event" ->ₛ "link") )
  **  (EventPadding retval )
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _EventCreate_safety_wit_12 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH2 : (0 <= UINT_MAX)) (PreH3 : (0 >= 0)) (PreH4 : (retval_3 <= INT_MAX)) (PreH5 : (retval_3 >= INT_MIN)) (PreH6 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 )) (PreH7 : (retval <> 0)) (PreH8 : (addr_aligned retval 4 )) (PreH9 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH10 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH11 : (Crtos_RTrans before_outside_critical st_lock )) (PreH12 : (retval <> 0)) (PreH13 : (addr_aligned retval 4 )) (PreH14 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH15 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH16 : (retval_2 = retval)) (PreH17 : (retval <> 0)) (PreH18 : (0 < retval)) (PreH19 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH20 : (addr_aligned retval 4 )) (PreH21 : (0 <= options_pre)) (PreH22 : (options_pre <= UINT_MAX)) (PreH23 : (options_pre <= UINT_MAX)) (PreH24 : (options_pre >= 0)) (PreH25 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  ((( &( "id" ) )) # Int  |-> retval_4)
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  (event_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  ((&((retval)  # "Event" ->ₛ "options")) # UInt  |-> 0)
  **  ((&((retval)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((retval)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Event" ->ₛ "link") )
  **  (EventPadding retval )
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _EventCreate_safety_wit_13 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (retval_4 >= 0)) (PreH2 : ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH3 : (0 <= UINT_MAX)) (PreH4 : (0 >= 0)) (PreH5 : (retval_3 <= INT_MAX)) (PreH6 : (retval_3 >= INT_MIN)) (PreH7 : (retval_4 = (-1))) (PreH8 : (retval <> 0)) (PreH9 : (addr_aligned retval 4 )) (PreH10 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH11 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH12 : (Crtos_RTrans before_outside_critical st_lock )) (PreH13 : (retval <> 0)) (PreH14 : (addr_aligned retval 4 )) (PreH15 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH16 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH17 : (retval_2 = retval)) (PreH18 : (retval <> 0)) (PreH19 : (0 < retval)) (PreH20 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH21 : (addr_aligned retval 4 )) (PreH22 : (0 <= options_pre)) (PreH23 : (options_pre <= UINT_MAX)) (PreH24 : (options_pre <= UINT_MAX)) (PreH25 : (options_pre >= 0)) (PreH26 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  ((( &( "id" ) )) # Int  |-> retval_4)
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (store_idnode_insert_ready &((retval)  # "Event" ->ₛ "id") )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  (event_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  ((&((retval)  # "Event" ->ₛ "options")) # UInt  |-> 0)
  **  ((&((retval)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((retval)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Event" ->ₛ "link") )
  **  (EventPadding retval )
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ False ”
.

Definition _EventCreate_safety_wit_14 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (retval_4 < 0)) (PreH2 : ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH3 : (0 <= UINT_MAX)) (PreH4 : (0 >= 0)) (PreH5 : (retval_3 <= INT_MAX)) (PreH6 : (retval_3 >= INT_MIN)) (PreH7 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 )) (PreH8 : (retval <> 0)) (PreH9 : (addr_aligned retval 4 )) (PreH10 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH11 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH12 : (Crtos_RTrans before_outside_critical st_lock )) (PreH13 : (retval <> 0)) (PreH14 : (addr_aligned retval 4 )) (PreH15 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH16 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH17 : (retval_2 = retval)) (PreH18 : (retval <> 0)) (PreH19 : (0 < retval)) (PreH20 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH21 : (addr_aligned retval 4 )) (PreH22 : (0 <= options_pre)) (PreH23 : (options_pre <= UINT_MAX)) (PreH24 : (options_pre <= UINT_MAX)) (PreH25 : (options_pre >= 0)) (PreH26 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  ((( &( "id" ) )) # Int  |-> retval_4)
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  (event_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  ((&((retval)  # "Event" ->ₛ "options")) # UInt  |-> 0)
  **  ((&((retval)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((retval)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Event" ->ₛ "link") )
  **  (EventPadding retval )
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ False ”
.

Definition _EventCreate_safety_wit_15 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  ((-5))) X_outside_critical )) (PreH2 : (Crtos_GTrans st_lock st_lock )) (PreH3 : (retval_4 < 0)) (PreH4 : ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH5 : (0 <= UINT_MAX)) (PreH6 : (0 >= 0)) (PreH7 : (retval_3 <= INT_MAX)) (PreH8 : (retval_3 >= INT_MIN)) (PreH9 : (retval_4 = (-1))) (PreH10 : (retval <> 0)) (PreH11 : (addr_aligned retval 4 )) (PreH12 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH13 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH14 : (Crtos_RTrans before_outside_critical st_lock )) (PreH15 : (retval <> 0)) (PreH16 : (addr_aligned retval 4 )) (PreH17 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH18 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH19 : (retval_2 = retval)) (PreH20 : (retval <> 0)) (PreH21 : (0 < retval)) (PreH22 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH23 : (addr_aligned retval 4 )) (PreH24 : (0 <= options_pre)) (PreH25 : (options_pre <= UINT_MAX)) (PreH26 : (options_pre <= UINT_MAX)) (PreH27 : (options_pre >= 0)) (PreH28 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (OutsideCritical sg_outside_critical st_lock )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ (5 <> (INT_MIN)) ”
.

Definition _EventCreate_safety_wit_16 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  ((-5))) X_outside_critical )) (PreH2 : (Crtos_GTrans st_lock st_lock )) (PreH3 : (retval_4 < 0)) (PreH4 : ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH5 : (0 <= UINT_MAX)) (PreH6 : (0 >= 0)) (PreH7 : (retval_3 <= INT_MAX)) (PreH8 : (retval_3 >= INT_MIN)) (PreH9 : (retval_4 = (-1))) (PreH10 : (retval <> 0)) (PreH11 : (addr_aligned retval 4 )) (PreH12 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH13 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH14 : (Crtos_RTrans before_outside_critical st_lock )) (PreH15 : (retval <> 0)) (PreH16 : (addr_aligned retval 4 )) (PreH17 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH18 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH19 : (retval_2 = retval)) (PreH20 : (retval <> 0)) (PreH21 : (0 < retval)) (PreH22 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH23 : (addr_aligned retval 4 )) (PreH24 : (0 <= options_pre)) (PreH25 : (options_pre <= UINT_MAX)) (PreH26 : (options_pre <= UINT_MAX)) (PreH27 : (options_pre >= 0)) (PreH28 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (OutsideCritical sg_outside_critical st_lock )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ (5 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 5) ”
.

Definition _EventCreate_entail_wit_1 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= options_pre) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre >= 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ”
  &&  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
.

Definition _EventCreate_entail_wit_2_1 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (retval_4 = (-1))) (PreH2 : (retval <> 0)) (PreH3 : (addr_aligned retval 4 )) (PreH4 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH5 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH6 : (Crtos_RTrans before_outside_critical st_lock )) (PreH7 : (retval <> 0)) (PreH8 : (addr_aligned retval 4 )) (PreH9 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH10 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH11 : (retval_2 = retval)) (PreH12 : (retval <> 0)) (PreH13 : (0 < retval)) (PreH14 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH15 : (addr_aligned retval 4 )) (PreH16 : (0 <= options_pre)) (PreH17 : (options_pre <= UINT_MAX)) (PreH18 : (options_pre <= UINT_MAX)) (PreH19 : (options_pre >= 0)) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (store_idnode_insert_ready &((retval)  # "Event" ->ₛ "id") )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  (event_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  ((&((retval)  # "Event" ->ₛ "options")) # UInt  |-> 0)
  **  ((&((retval)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((retval)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Event" ->ₛ "link") )
  **  (EventPadding retval )
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
|--
  (“ ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128))) ” 
  &&  “ (0 <= UINT_MAX) ” 
  &&  “ (0 >= 0) ” 
  &&  “ (retval_3 <= INT_MAX) ” 
  &&  “ (retval_3 >= INT_MIN) ” 
  &&  “ (retval_4 = (-1)) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (event_context (os_event_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (event_addr) ((os_events (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Event" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (0 <= options_pre) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre >= 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ”
  &&  ((( &( "id" ) )) # Int  |-> retval_4)
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (store_idnode_insert_ready &((retval)  # "Event" ->ₛ "id") )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  (event_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  ((&((retval)  # "Event" ->ₛ "options")) # UInt  |-> 0)
  **  ((&((retval)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((retval)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Event" ->ₛ "link") )
  **  (EventPadding retval )
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3))
  ||
  (EX (retval_5: Z) ,
  “ ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_5 ) -> ((0 <= retval_5) /\ (retval_5 < 128))) ” 
  &&  “ (0 <= UINT_MAX) ” 
  &&  “ (0 >= 0) ” 
  &&  “ (retval_3 <= INT_MAX) ” 
  &&  “ (retval_3 >= INT_MIN) ” 
  &&  “ (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_5 ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (event_context (os_event_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (event_addr) ((os_events (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Event" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (0 <= options_pre) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre >= 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ”
  &&  ((( &( "id" ) )) # Int  |-> retval_5)
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (retval_5))) (retval_5) (&((retval)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  (event_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  ((&((retval)  # "Event" ->ₛ "options")) # UInt  |-> 0)
  **  ((&((retval)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((retval)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Event" ->ₛ "link") )
  **  (EventPadding retval )
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3))
.

Definition _EventCreate_entail_wit_2_2 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_5: Z) (PreH1 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_5 )) (PreH2 : (retval <> 0)) (PreH3 : (addr_aligned retval 4 )) (PreH4 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH5 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH6 : (Crtos_RTrans before_outside_critical st_lock )) (PreH7 : (retval <> 0)) (PreH8 : (addr_aligned retval 4 )) (PreH9 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH10 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH11 : (retval_2 = retval)) (PreH12 : (retval <> 0)) (PreH13 : (0 < retval)) (PreH14 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH15 : (addr_aligned retval 4 )) (PreH16 : (0 <= options_pre)) (PreH17 : (options_pre <= UINT_MAX)) (PreH18 : (options_pre <= UINT_MAX)) (PreH19 : (options_pre >= 0)) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (retval_5))) (retval_5) (&((retval)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  (event_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  ((&((retval)  # "Event" ->ₛ "options")) # UInt  |-> 0)
  **  ((&((retval)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((retval)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Event" ->ₛ "link") )
  **  (EventPadding retval )
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
  **  ((( &( "id" ) )) # Int  |-> retval_5)
|--
  (EX (retval_4: Z) ,
  “ ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128))) ” 
  &&  “ (0 <= UINT_MAX) ” 
  &&  “ (0 >= 0) ” 
  &&  “ (retval_3 <= INT_MAX) ” 
  &&  “ (retval_3 >= INT_MIN) ” 
  &&  “ (retval_4 = (-1)) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (event_context (os_event_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (event_addr) ((os_events (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Event" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (0 <= options_pre) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre >= 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ”
  &&  ((( &( "id" ) )) # Int  |-> retval_4)
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (store_idnode_insert_ready &((retval)  # "Event" ->ₛ "id") )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  (event_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  ((&((retval)  # "Event" ->ₛ "options")) # UInt  |-> 0)
  **  ((&((retval)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((retval)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Event" ->ₛ "link") )
  **  (EventPadding retval )
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3))
  ||
  (“ ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_5 ) -> ((0 <= retval_5) /\ (retval_5 < 128))) ” 
  &&  “ (0 <= UINT_MAX) ” 
  &&  “ (0 >= 0) ” 
  &&  “ (retval_3 <= INT_MAX) ” 
  &&  “ (retval_3 >= INT_MIN) ” 
  &&  “ (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_5 ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (event_context (os_event_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (event_addr) ((os_events (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Event" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (0 <= options_pre) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre >= 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ”
  &&  ((( &( "id" ) )) # Int  |-> retval_5)
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (retval_5))) (retval_5) (&((retval)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  (event_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  ((&((retval)  # "Event" ->ₛ "options")) # UInt  |-> 0)
  **  ((&((retval)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((retval)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Event" ->ₛ "link") )
  **  (EventPadding retval )
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3))
.

Definition _EventCreate_return_wit_1 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval_2: Z) (retval_3: Z) (retval_4: Z) (st_lock: VarGlobalState) (retval: Z) (PreH1 : (0 <= retval)) (PreH2 : (retval < 128)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen ((replace_events ((event_publish (retval_2) (retval) (options_pre) ((os_events (st_lock))))) (st_lock)))) ( MonadErr.ret  (retval)) X_outside_critical )) (PreH4 : (Crtos_GTrans st_lock (replace_events ((event_publish (retval_2) (retval) (options_pre) ((os_events (st_lock))))) (st_lock)) )) (PreH5 : (retval_2 <> 0)) (PreH6 : (addr_aligned retval_2 4 )) (PreH7 : (&((retval_2)  # "Event" ->ₛ "link") <> 0)) (PreH8 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval )) (PreH9 : (&((retval_2)  # "Event" ->ₛ "pend_list") <> 0)) (PreH10 : (retval >= 0)) (PreH11 : ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval ) -> ((0 <= retval) /\ (retval < 128)))) (PreH12 : (0 <= UINT_MAX)) (PreH13 : (0 >= 0)) (PreH14 : (retval_4 <= INT_MAX)) (PreH15 : (retval_4 >= INT_MIN)) (PreH16 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval )) (PreH17 : (retval_2 <> 0)) (PreH18 : (addr_aligned retval_2 4 )) (PreH19 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH20 : ~((In retval_2 (map (event_addr) ((os_events (st_lock)))) ))) (PreH21 : (Crtos_RTrans before_outside_critical st_lock )) (PreH22 : (retval_2 <> 0)) (PreH23 : (addr_aligned retval_2 4 )) (PreH24 : (&((retval_2)  # "Event" ->ₛ "pend_list") <> 0)) (PreH25 : (&((retval_2)  # "Event" ->ₛ "link") <> 0)) (PreH26 : (retval_3 = retval_2)) (PreH27 : (retval_2 <> 0)) (PreH28 : (0 < retval_2)) (PreH29 : (retval_2 <= (UINT_MAX - sizeof( "Event" ) ))) (PreH30 : (addr_aligned retval_2 4 )) (PreH31 : (0 <= options_pre)) (PreH32 : (options_pre <= UINT_MAX)) (PreH33 : (options_pre <= UINT_MAX)) (PreH34 : (options_pre >= 0)) (PreH35 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (OutsideCritical sg_outside_critical (replace_events ((event_publish (retval_2) (retval) (options_pre) ((os_events (st_lock))))) (st_lock)) )
|--
  EX (after_2: VarGlobalState) ,
  “ (0 <= retval) ” 
  &&  “ (retval < 128) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after_2)) ( MonadErr.ret  (retval)) X_outside_critical ) ”
  &&  (OutsideCritical sg_outside_critical after_2 )
.

Definition _EventCreate_return_wit_2 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  ((-5))) X_outside_critical )) (PreH2 : (Crtos_GTrans st_lock st_lock )) (PreH3 : (retval_4 < 0)) (PreH4 : ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH5 : (0 <= UINT_MAX)) (PreH6 : (0 >= 0)) (PreH7 : (retval_3 <= INT_MAX)) (PreH8 : (retval_3 >= INT_MIN)) (PreH9 : (retval_4 = (-1))) (PreH10 : (retval <> 0)) (PreH11 : (addr_aligned retval 4 )) (PreH12 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH13 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH14 : (Crtos_RTrans before_outside_critical st_lock )) (PreH15 : (retval <> 0)) (PreH16 : (addr_aligned retval 4 )) (PreH17 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH18 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH19 : (retval_2 = retval)) (PreH20 : (retval <> 0)) (PreH21 : (0 < retval)) (PreH22 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH23 : (addr_aligned retval 4 )) (PreH24 : (0 <= options_pre)) (PreH25 : (options_pre <= UINT_MAX)) (PreH26 : (options_pre <= UINT_MAX)) (PreH27 : (options_pre >= 0)) (PreH28 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (OutsideCritical sg_outside_critical st_lock )
|--
  EX (after: VarGlobalState) ,
  “ ((-5) = (-5)) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  ((-5))) X_outside_critical ) ”
  &&  (OutsideCritical sg_outside_critical after )
.

Definition _EventCreate_return_wit_3 := 
(
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : (0 <= options_pre)) (PreH4 : (options_pre <= UINT_MAX)) (PreH5 : (options_pre <= UINT_MAX)) (PreH6 : (options_pre >= 0)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  EX (after: VarGlobalState) ,
  “ ((-5) = (-5)) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  ((-5))) X_outside_critical ) ”
  &&  (OutsideCritical sg_outside_critical after )
) \/
(
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : (0 <= options_pre)) (PreH4 : (options_pre <= UINT_MAX)) (PreH5 : (options_pre <= UINT_MAX)) (PreH6 : (options_pre >= 0)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) ( MonadErr.ret  ((-5))) X_outside_critical ) ”
  &&  emp
).

Definition _EventCreate_return_wit_3_split_goal_1 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : (0 <= options_pre)) (PreH4 : (options_pre <= UINT_MAX)) (PreH5 : (options_pre <= UINT_MAX)) (PreH6 : (options_pre >= 0)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) ( MonadErr.ret  ((-5))) X_outside_critical )
.

Definition _EventCreate_partial_solve_wit_1_pure := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (PreH1 : (0 <= options_pre)) (PreH2 : (options_pre <= UINT_MAX)) (PreH3 : (options_pre <= UINT_MAX)) (PreH4 : (options_pre >= 0)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  ((( &( "event" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= sizeof( "Event" )) ” 
  &&  “ (sizeof( "Event" ) <= UINT_MAX) ”
.

Definition _EventCreate_partial_solve_wit_1_aux := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (PreH1 : (0 <= options_pre)) (PreH2 : (options_pre <= UINT_MAX)) (PreH3 : (options_pre <= UINT_MAX)) (PreH4 : (options_pre >= 0)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= sizeof( "Event" )) ” 
  &&  “ (sizeof( "Event" ) <= UINT_MAX) ” 
  &&  “ (0 <= options_pre) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre >= 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ”
  &&  (OutsideCritical sg_outside_critical before_outside_critical )
.

Definition _EventCreate_partial_solve_wit_1 := _EventCreate_partial_solve_wit_1_pure -> _EventCreate_partial_solve_wit_1_aux.

Definition _EventCreate_partial_solve_wit_2_pure := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (0 < retval)) (PreH3 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH4 : (addr_aligned retval 4 )) (PreH5 : (0 <= options_pre)) (PreH6 : (options_pre <= UINT_MAX)) (PreH7 : (options_pre <= UINT_MAX)) (PreH8 : (options_pre >= 0)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (CharArray.undef_full retval sizeof( "Event" ) )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= sizeof( "Event" )) ” 
  &&  “ (sizeof( "Event" ) <= UINT_MAX) ” 
  &&  “ (0 <= 0) ” 
  &&  “ (0 <= 127) ”
.

Definition _EventCreate_partial_solve_wit_2_aux := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (0 < retval)) (PreH3 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH4 : (addr_aligned retval 4 )) (PreH5 : (0 <= options_pre)) (PreH6 : (options_pre <= UINT_MAX)) (PreH7 : (options_pre <= UINT_MAX)) (PreH8 : (options_pre >= 0)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (CharArray.undef_full retval sizeof( "Event" ) )
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= sizeof( "Event" )) ” 
  &&  “ (sizeof( "Event" ) <= UINT_MAX) ” 
  &&  “ (0 <= 0) ” 
  &&  “ (0 <= 127) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Event" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (0 <= options_pre) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre >= 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ”
  &&  (CharArray.undef_full retval sizeof( "Event" ) )
  **  (OutsideCritical sg_outside_critical before_outside_critical )
.

Definition _EventCreate_partial_solve_wit_2 := _EventCreate_partial_solve_wit_2_pure -> _EventCreate_partial_solve_wit_2_aux.

Definition _EventCreate_partial_solve_wit_3_pure := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 = retval)) (PreH2 : (retval <> 0)) (PreH3 : (0 < retval)) (PreH4 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH5 : (addr_aligned retval 4 )) (PreH6 : (0 <= options_pre)) (PreH7 : (options_pre <= UINT_MAX)) (PreH8 : (options_pre <= UINT_MAX)) (PreH9 : (options_pre >= 0)) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (CharArray.full retval sizeof( "Event" ) (repeat_Z (0) (sizeof( "Event" ))) )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Event" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ”
.

Definition _EventCreate_partial_solve_wit_3_aux := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 = retval)) (PreH2 : (retval <> 0)) (PreH3 : (0 < retval)) (PreH4 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH5 : (addr_aligned retval 4 )) (PreH6 : (0 <= options_pre)) (PreH7 : (options_pre <= UINT_MAX)) (PreH8 : (options_pre <= UINT_MAX)) (PreH9 : (options_pre >= 0)) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (CharArray.full retval sizeof( "Event" ) (repeat_Z (0) (sizeof( "Event" ))) )
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Event" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Event" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (0 <= options_pre) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre >= 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ”
  &&  (CharArray.full retval sizeof( "Event" ) (repeat_Z (0) (sizeof( "Event" ))) )
  **  (OutsideCritical sg_outside_critical before_outside_critical )
.

Definition _EventCreate_partial_solve_wit_3 := _EventCreate_partial_solve_wit_3_pure -> _EventCreate_partial_solve_wit_3_aux.

Definition _EventCreate_partial_solve_wit_4 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (PreH1 : (retval <> 0)) (PreH2 : (addr_aligned retval 4 )) (PreH3 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH4 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH5 : (retval_2 = retval)) (PreH6 : (retval <> 0)) (PreH7 : (0 < retval)) (PreH8 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH9 : (addr_aligned retval 4 )) (PreH10 : (0 <= options_pre)) (PreH11 : (options_pre <= UINT_MAX)) (PreH12 : (options_pre <= UINT_MAX)) (PreH13 : (options_pre >= 0)) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (EventZero retval )
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Event" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (0 <= options_pre) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre >= 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ”
  &&  (OutsideCritical sg_outside_critical before_outside_critical )
  **  (EventZero retval )
.

Definition _EventCreate_partial_solve_wit_5 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (st_lock: VarGlobalState) (PreH1 : (Crtos_RTrans before_outside_critical st_lock )) (PreH2 : (retval <> 0)) (PreH3 : (addr_aligned retval 4 )) (PreH4 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH5 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH6 : (retval_2 = retval)) (PreH7 : (retval <> 0)) (PreH8 : (0 < retval)) (PreH9 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH10 : (addr_aligned retval 4 )) (PreH11 : (0 <= options_pre)) (PreH12 : (options_pre <= UINT_MAX)) (PreH13 : (options_pre <= UINT_MAX)) (PreH14 : (options_pre >= 0)) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical st_lock )
  **  (EventZero retval )
|--
  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Event" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (0 <= options_pre) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre >= 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ”
  &&  (os_inv sg_outside_critical st_lock )
  **  (EventZero retval )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _EventCreate_partial_solve_wit_6 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (st_lock: VarGlobalState) (PreH1 : (retval <> 0)) (PreH2 : (addr_aligned retval 4 )) (PreH3 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH4 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH5 : (Crtos_RTrans before_outside_critical st_lock )) (PreH6 : (retval <> 0)) (PreH7 : (addr_aligned retval 4 )) (PreH8 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH9 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH10 : (retval_2 = retval)) (PreH11 : (retval <> 0)) (PreH12 : (0 < retval)) (PreH13 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH14 : (addr_aligned retval 4 )) (PreH15 : (0 <= options_pre)) (PreH16 : (options_pre <= UINT_MAX)) (PreH17 : (options_pre <= UINT_MAX)) (PreH18 : (options_pre >= 0)) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (event_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  (store_idnode_insert_ready &((retval)  # "Event" ->ₛ "id") )
  **  ((&((retval)  # "Event" ->ₛ "options")) # UInt  |-> 0)
  **  ((&((retval)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((retval)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Event" ->ₛ "link") )
  **  (EventPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (event_context (os_event_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (event_addr) ((os_events (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Event" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (0 <= options_pre) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre >= 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ”
  &&  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (store_idnode_insert_ready &((retval)  # "Event" ->ₛ "id") )
  **  (event_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  ((&((retval)  # "Event" ->ₛ "options")) # UInt  |-> 0)
  **  ((&((retval)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((retval)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Event" ->ₛ "link") )
  **  (EventPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _EventCreate_partial_solve_wit_7_pure := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (retval_4 < 0)) (PreH2 : ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH3 : (0 <= UINT_MAX)) (PreH4 : (0 >= 0)) (PreH5 : (retval_3 <= INT_MAX)) (PreH6 : (retval_3 >= INT_MIN)) (PreH7 : (retval_4 = (-1))) (PreH8 : (retval <> 0)) (PreH9 : (addr_aligned retval 4 )) (PreH10 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH11 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH12 : (Crtos_RTrans before_outside_critical st_lock )) (PreH13 : (retval <> 0)) (PreH14 : (addr_aligned retval 4 )) (PreH15 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH16 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH17 : (retval_2 = retval)) (PreH18 : (retval <> 0)) (PreH19 : (0 < retval)) (PreH20 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH21 : (addr_aligned retval 4 )) (PreH22 : (0 <= options_pre)) (PreH23 : (options_pre <= UINT_MAX)) (PreH24 : (options_pre <= UINT_MAX)) (PreH25 : (options_pre >= 0)) (PreH26 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  ((( &( "id" ) )) # Int  |-> retval_4)
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (store_idnode_insert_ready &((retval)  # "Event" ->ₛ "id") )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  (event_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  ((&((retval)  # "Event" ->ₛ "options")) # UInt  |-> 0)
  **  ((&((retval)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((retval)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Event" ->ₛ "link") )
  **  (EventPadding retval )
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ”
.

Definition _EventCreate_partial_solve_wit_7_aux := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (retval_4 < 0)) (PreH2 : ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH3 : (0 <= UINT_MAX)) (PreH4 : (0 >= 0)) (PreH5 : (retval_3 <= INT_MAX)) (PreH6 : (retval_3 >= INT_MIN)) (PreH7 : (retval_4 = (-1))) (PreH8 : (retval <> 0)) (PreH9 : (addr_aligned retval 4 )) (PreH10 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH11 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH12 : (Crtos_RTrans before_outside_critical st_lock )) (PreH13 : (retval <> 0)) (PreH14 : (addr_aligned retval 4 )) (PreH15 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH16 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH17 : (retval_2 = retval)) (PreH18 : (retval <> 0)) (PreH19 : (0 < retval)) (PreH20 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH21 : (addr_aligned retval 4 )) (PreH22 : (0 <= options_pre)) (PreH23 : (options_pre <= UINT_MAX)) (PreH24 : (options_pre <= UINT_MAX)) (PreH25 : (options_pre >= 0)) (PreH26 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (store_idnode_insert_ready &((retval)  # "Event" ->ₛ "id") )
  **  (event_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  ((&((retval)  # "Event" ->ₛ "options")) # UInt  |-> 0)
  **  ((&((retval)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((retval)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Event" ->ₛ "link") )
  **  (EventPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval_4 < 0) ” 
  &&  “ ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128))) ” 
  &&  “ (0 <= UINT_MAX) ” 
  &&  “ (0 >= 0) ” 
  &&  “ (retval_3 <= INT_MAX) ” 
  &&  “ (retval_3 >= INT_MIN) ” 
  &&  “ (retval_4 = (-1)) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (event_context (os_event_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (event_addr) ((os_events (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Event" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (0 <= options_pre) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre >= 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ”
  &&  (event_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  (store_idnode_insert_ready &((retval)  # "Event" ->ₛ "id") )
  **  ((&((retval)  # "Event" ->ₛ "options")) # UInt  |-> 0)
  **  ((&((retval)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((retval)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Event" ->ₛ "link") )
  **  (EventPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _EventCreate_partial_solve_wit_7 := _EventCreate_partial_solve_wit_7_pure -> _EventCreate_partial_solve_wit_7_aux.

Definition _EventCreate_partial_solve_wit_8_pure := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  ((-5))) X_outside_critical )) (PreH2 : (Crtos_GTrans st_lock st_lock )) (PreH3 : (retval_4 < 0)) (PreH4 : ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH5 : (0 <= UINT_MAX)) (PreH6 : (0 >= 0)) (PreH7 : (retval_3 <= INT_MAX)) (PreH8 : (retval_3 >= INT_MIN)) (PreH9 : (retval_4 = (-1))) (PreH10 : (retval <> 0)) (PreH11 : (addr_aligned retval 4 )) (PreH12 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH13 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH14 : (Crtos_RTrans before_outside_critical st_lock )) (PreH15 : (retval <> 0)) (PreH16 : (addr_aligned retval 4 )) (PreH17 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH18 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH19 : (retval_2 = retval)) (PreH20 : (retval <> 0)) (PreH21 : (0 < retval)) (PreH22 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH23 : (addr_aligned retval 4 )) (PreH24 : (0 <= options_pre)) (PreH25 : (options_pre <= UINT_MAX)) (PreH26 : (options_pre <= UINT_MAX)) (PreH27 : (options_pre >= 0)) (PreH28 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (os_inv sg_outside_critical st_lock )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  (EventRaw retval )
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ (Crtos_GTrans st_lock st_lock ) ”
.

Definition _EventCreate_partial_solve_wit_8_aux := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  ((-5))) X_outside_critical )) (PreH2 : (Crtos_GTrans st_lock st_lock )) (PreH3 : (retval_4 < 0)) (PreH4 : ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH5 : (0 <= UINT_MAX)) (PreH6 : (0 >= 0)) (PreH7 : (retval_3 <= INT_MAX)) (PreH8 : (retval_3 >= INT_MIN)) (PreH9 : (retval_4 = (-1))) (PreH10 : (retval <> 0)) (PreH11 : (addr_aligned retval 4 )) (PreH12 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH13 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH14 : (Crtos_RTrans before_outside_critical st_lock )) (PreH15 : (retval <> 0)) (PreH16 : (addr_aligned retval 4 )) (PreH17 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH18 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH19 : (retval_2 = retval)) (PreH20 : (retval <> 0)) (PreH21 : (0 < retval)) (PreH22 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH23 : (addr_aligned retval 4 )) (PreH24 : (0 <= options_pre)) (PreH25 : (options_pre <= UINT_MAX)) (PreH26 : (options_pre <= UINT_MAX)) (PreH27 : (options_pre >= 0)) (PreH28 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (os_inv sg_outside_critical st_lock )
  **  (EventRaw retval )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (Crtos_GTrans st_lock st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  ((-5))) X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock st_lock ) ” 
  &&  “ (retval_4 < 0) ” 
  &&  “ ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128))) ” 
  &&  “ (0 <= UINT_MAX) ” 
  &&  “ (0 >= 0) ” 
  &&  “ (retval_3 <= INT_MAX) ” 
  &&  “ (retval_3 >= INT_MIN) ” 
  &&  “ (retval_4 = (-1)) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (event_context (os_event_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (event_addr) ((os_events (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Event" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (0 <= options_pre) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre >= 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ”
  &&  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical st_lock )
  **  (EventRaw retval )
.

Definition _EventCreate_partial_solve_wit_8 := _EventCreate_partial_solve_wit_8_pure -> _EventCreate_partial_solve_wit_8_aux.

Definition _EventCreate_partial_solve_wit_9 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  ((-5))) X_outside_critical )) (PreH2 : (Crtos_GTrans st_lock st_lock )) (PreH3 : (retval_4 < 0)) (PreH4 : ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH5 : (0 <= UINT_MAX)) (PreH6 : (0 >= 0)) (PreH7 : (retval_3 <= INT_MAX)) (PreH8 : (retval_3 >= INT_MIN)) (PreH9 : (retval_4 = (-1))) (PreH10 : (retval <> 0)) (PreH11 : (addr_aligned retval 4 )) (PreH12 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH13 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH14 : (Crtos_RTrans before_outside_critical st_lock )) (PreH15 : (retval <> 0)) (PreH16 : (addr_aligned retval 4 )) (PreH17 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH18 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH19 : (retval_2 = retval)) (PreH20 : (retval <> 0)) (PreH21 : (0 < retval)) (PreH22 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH23 : (addr_aligned retval 4 )) (PreH24 : (0 <= options_pre)) (PreH25 : (options_pre <= UINT_MAX)) (PreH26 : (options_pre <= UINT_MAX)) (PreH27 : (options_pre >= 0)) (PreH28 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (OutsideCritical sg_outside_critical st_lock )
  **  (EventRaw retval )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  ((-5))) X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock st_lock ) ” 
  &&  “ (retval_4 < 0) ” 
  &&  “ ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128))) ” 
  &&  “ (0 <= UINT_MAX) ” 
  &&  “ (0 >= 0) ” 
  &&  “ (retval_3 <= INT_MAX) ” 
  &&  “ (retval_3 >= INT_MIN) ” 
  &&  “ (retval_4 = (-1)) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (event_context (os_event_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (event_addr) ((os_events (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Event" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (0 <= options_pre) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre >= 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ”
  &&  (EventRaw retval )
  **  (OutsideCritical sg_outside_critical st_lock )
.

Definition _EventCreate_partial_solve_wit_10 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (retval_4 >= 0)) (PreH2 : ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH3 : (0 <= UINT_MAX)) (PreH4 : (0 >= 0)) (PreH5 : (retval_3 <= INT_MAX)) (PreH6 : (retval_3 >= INT_MIN)) (PreH7 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 )) (PreH8 : (retval <> 0)) (PreH9 : (addr_aligned retval 4 )) (PreH10 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH11 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH12 : (Crtos_RTrans before_outside_critical st_lock )) (PreH13 : (retval <> 0)) (PreH14 : (addr_aligned retval 4 )) (PreH15 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH16 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH17 : (retval_2 = retval)) (PreH18 : (retval <> 0)) (PreH19 : (0 < retval)) (PreH20 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH21 : (addr_aligned retval 4 )) (PreH22 : (0 <= options_pre)) (PreH23 : (options_pre <= UINT_MAX)) (PreH24 : (options_pre <= UINT_MAX)) (PreH25 : (options_pre >= 0)) (PreH26 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  ((&((retval)  # "Event" ->ₛ "options")) # UInt  |-> (Z.land options_pre 7))
  **  ((&((retval)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((retval)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Event" ->ₛ "link") )
  **  (EventPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (retval_4 >= 0) ” 
  &&  “ ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128))) ” 
  &&  “ (0 <= UINT_MAX) ” 
  &&  “ (0 >= 0) ” 
  &&  “ (retval_3 <= INT_MAX) ” 
  &&  “ (retval_3 >= INT_MIN) ” 
  &&  “ (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (event_context (os_event_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (event_addr) ((os_events (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Event" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (0 <= options_pre) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre >= 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ”
  &&  (NodeZero &((retval)  # "Event" ->ₛ "pend_list") )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  ((&((retval)  # "Event" ->ₛ "options")) # UInt  |-> (Z.land options_pre 7))
  **  ((&((retval)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((retval)  # "Event" ->ₛ "link") )
  **  (EventPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _EventCreate_partial_solve_wit_11 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (retval_4 >= 0)) (PreH2 : ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH3 : (0 <= UINT_MAX)) (PreH4 : (0 >= 0)) (PreH5 : (retval_3 <= INT_MAX)) (PreH6 : (retval_3 >= INT_MIN)) (PreH7 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 )) (PreH8 : (retval <> 0)) (PreH9 : (addr_aligned retval 4 )) (PreH10 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH11 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH12 : (Crtos_RTrans before_outside_critical st_lock )) (PreH13 : (retval <> 0)) (PreH14 : (addr_aligned retval 4 )) (PreH15 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH16 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH17 : (retval_2 = retval)) (PreH18 : (retval <> 0)) (PreH19 : (0 < retval)) (PreH20 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH21 : (addr_aligned retval 4 )) (PreH22 : (0 <= options_pre)) (PreH23 : (options_pre <= UINT_MAX)) (PreH24 : (options_pre <= UINT_MAX)) (PreH25 : (options_pre >= 0)) (PreH26 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  ((&((retval)  # "Event" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((retval)  # "Event" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |->_)
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  ((&((retval)  # "Event" ->ₛ "options")) # UInt  |-> (Z.land options_pre 7))
  **  ((&((retval)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((retval)  # "Event" ->ₛ "link") )
  **  (EventPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (retval_4 >= 0) ” 
  &&  “ ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128))) ” 
  &&  “ (0 <= UINT_MAX) ” 
  &&  “ (0 >= 0) ” 
  &&  “ (retval_3 <= INT_MAX) ” 
  &&  “ (retval_3 >= INT_MIN) ” 
  &&  “ (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (event_context (os_event_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (event_addr) ((os_events (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Event" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (0 <= options_pre) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre >= 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ”
  &&  ((&((retval)  # "Event" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((retval)  # "Event" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |->_)
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  ((&((retval)  # "Event" ->ₛ "options")) # UInt  |-> (Z.land options_pre 7))
  **  ((&((retval)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((retval)  # "Event" ->ₛ "link") )
  **  (EventPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _EventCreate_partial_solve_wit_12_pure := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_3: Z) (retval_4: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH2 : (retval_2 >= 0)) (PreH3 : ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 ) -> ((0 <= retval_2) /\ (retval_2 < 128)))) (PreH4 : (0 <= UINT_MAX)) (PreH5 : (0 >= 0)) (PreH6 : (retval_4 <= INT_MAX)) (PreH7 : (retval_4 >= INT_MIN)) (PreH8 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 )) (PreH9 : (retval <> 0)) (PreH10 : (addr_aligned retval 4 )) (PreH11 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH12 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH13 : (Crtos_RTrans before_outside_critical st_lock )) (PreH14 : (retval <> 0)) (PreH15 : (addr_aligned retval 4 )) (PreH16 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH17 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH18 : (retval_3 = retval)) (PreH19 : (retval <> 0)) (PreH20 : (0 < retval)) (PreH21 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH22 : (addr_aligned retval 4 )) (PreH23 : (0 <= options_pre)) (PreH24 : (options_pre <= UINT_MAX)) (PreH25 : (options_pre <= UINT_MAX)) (PreH26 : (options_pre >= 0)) (PreH27 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (store_node_self_linked &((retval)  # "Event" ->ₛ "pend_list") )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> retval_2)
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (retval_2))) (retval_2) (&((retval)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  ((&((retval)  # "Event" ->ₛ "options")) # UInt  |-> (Z.land options_pre 7))
  **  ((&((retval)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((retval)  # "Event" ->ₛ "link") )
  **  (EventPadding retval )
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_4)
|--
  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 ) ”
.

Definition _EventCreate_partial_solve_wit_12_aux := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_3: Z) (retval_4: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH2 : (retval_2 >= 0)) (PreH3 : ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 ) -> ((0 <= retval_2) /\ (retval_2 < 128)))) (PreH4 : (0 <= UINT_MAX)) (PreH5 : (0 >= 0)) (PreH6 : (retval_4 <= INT_MAX)) (PreH7 : (retval_4 >= INT_MIN)) (PreH8 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 )) (PreH9 : (retval <> 0)) (PreH10 : (addr_aligned retval 4 )) (PreH11 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH12 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH13 : (Crtos_RTrans before_outside_critical st_lock )) (PreH14 : (retval <> 0)) (PreH15 : (addr_aligned retval 4 )) (PreH16 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH17 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH18 : (retval_3 = retval)) (PreH19 : (retval <> 0)) (PreH20 : (0 < retval)) (PreH21 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH22 : (addr_aligned retval 4 )) (PreH23 : (0 <= options_pre)) (PreH24 : (options_pre <= UINT_MAX)) (PreH25 : (options_pre <= UINT_MAX)) (PreH26 : (options_pre >= 0)) (PreH27 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (store_node_self_linked &((retval)  # "Event" ->ₛ "pend_list") )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (retval_2))) (retval_2) (&((retval)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  ((&((retval)  # "Event" ->ₛ "options")) # UInt  |-> (Z.land options_pre 7))
  **  ((&((retval)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((retval)  # "Event" ->ₛ "link") )
  **  (EventPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "pend_list") <> 0) ” 
  &&  “ (retval_2 >= 0) ” 
  &&  “ ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 ) -> ((0 <= retval_2) /\ (retval_2 < 128))) ” 
  &&  “ (0 <= UINT_MAX) ” 
  &&  “ (0 >= 0) ” 
  &&  “ (retval_4 <= INT_MAX) ” 
  &&  “ (retval_4 >= INT_MIN) ” 
  &&  “ (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (event_context (os_event_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (event_addr) ((os_events (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ (retval_3 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Event" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (0 <= options_pre) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre >= 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ”
  &&  ((&((retval)  # "Event" ->ₛ "options")) # UInt  |-> (Z.land options_pre 7))
  **  ((&((retval)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (store_node_self_linked &((retval)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Event" ->ₛ "link") )
  **  (EventPadding retval )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (retval_2))) (retval_2) (&((retval)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _EventCreate_partial_solve_wit_12 := _EventCreate_partial_solve_wit_12_pure -> _EventCreate_partial_solve_wit_12_aux.

Definition _EventCreate_partial_solve_wit_13_pure := 
(
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (retval <> 0)) (PreH2 : (addr_aligned retval 4 )) (PreH3 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH4 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 )) (PreH5 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH6 : (retval_4 >= 0)) (PreH7 : ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH8 : (0 <= UINT_MAX)) (PreH9 : (0 >= 0)) (PreH10 : (retval_3 <= INT_MAX)) (PreH11 : (retval_3 >= INT_MIN)) (PreH12 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 )) (PreH13 : (retval <> 0)) (PreH14 : (addr_aligned retval 4 )) (PreH15 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH16 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH17 : (Crtos_RTrans before_outside_critical st_lock )) (PreH18 : (retval <> 0)) (PreH19 : (addr_aligned retval 4 )) (PreH20 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH21 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH22 : (retval_2 = retval)) (PreH23 : (retval <> 0)) (PreH24 : (0 < retval)) (PreH25 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH26 : (addr_aligned retval 4 )) (PreH27 : (0 <= options_pre)) (PreH28 : (options_pre <= UINT_MAX)) (PreH29 : (options_pre <= UINT_MAX)) (PreH30 : (options_pre >= 0)) (PreH31 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  ((( &( "event" ) )) # Ptr  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  (store_event (pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))) &((retval)  # "Event" ->ₛ "link") (event_created (retval) (retval_4) (options_pre)) )
  **  (occupy_dll_node &((retval)  # "Event" ->ₛ "link") )
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ (&((retval)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ (dll_insert_anchor ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) ( &( "k_event_list" ) ) ) ”
) \/
(
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (retval_4 <= INT_MAX)) (PreH2 : (retval_4 >= INT_MIN)) (PreH3 : (retval <> 0)) (PreH4 : (addr_aligned retval 4 )) (PreH5 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH6 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 )) (PreH7 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH8 : (retval_4 >= 0)) (PreH9 : ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH10 : (0 <= UINT_MAX)) (PreH11 : (0 >= 0)) (PreH12 : (retval_3 <= INT_MAX)) (PreH13 : (retval_3 >= INT_MIN)) (PreH14 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 )) (PreH15 : (retval <> 0)) (PreH16 : (addr_aligned retval 4 )) (PreH17 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH18 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH19 : (Crtos_RTrans before_outside_critical st_lock )) (PreH20 : (retval <> 0)) (PreH21 : (addr_aligned retval 4 )) (PreH22 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH23 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH24 : (retval_2 = retval)) (PreH25 : (retval <> 0)) (PreH26 : (0 < retval)) (PreH27 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH28 : (addr_aligned retval 4 )) (PreH29 : (0 <= options_pre)) (PreH30 : (options_pre <= UINT_MAX)) (PreH31 : (options_pre <= UINT_MAX)) (PreH32 : (options_pre >= 0)) (PreH33 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  ((( &( "event" ) )) # Ptr  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  (store_event (pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))) &((retval)  # "Event" ->ₛ "link") (event_created (retval) (retval_4) (options_pre)) )
  **  (occupy_dll_node &((retval)  # "Event" ->ₛ "link") )
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ (dll_insert_anchor ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) ( &( "k_event_list" ) ) ) ”
).

Definition _EventCreate_partial_solve_wit_13_pure_split_goal_1 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (retval_4 <= INT_MAX)) (PreH2 : (retval_4 >= INT_MIN)) (PreH3 : (retval <> 0)) (PreH4 : (addr_aligned retval 4 )) (PreH5 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH6 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 )) (PreH7 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH8 : (retval_4 >= 0)) (PreH9 : ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH10 : (0 <= UINT_MAX)) (PreH11 : (0 >= 0)) (PreH12 : (retval_3 <= INT_MAX)) (PreH13 : (retval_3 >= INT_MIN)) (PreH14 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 )) (PreH15 : (retval <> 0)) (PreH16 : (addr_aligned retval 4 )) (PreH17 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH18 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH19 : (Crtos_RTrans before_outside_critical st_lock )) (PreH20 : (retval <> 0)) (PreH21 : (addr_aligned retval 4 )) (PreH22 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH23 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH24 : (retval_2 = retval)) (PreH25 : (retval <> 0)) (PreH26 : (0 < retval)) (PreH27 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH28 : (addr_aligned retval 4 )) (PreH29 : (0 <= options_pre)) (PreH30 : (options_pre <= UINT_MAX)) (PreH31 : (options_pre <= UINT_MAX)) (PreH32 : (options_pre >= 0)) (PreH33 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  ((( &( "event" ) )) # Ptr  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  (store_event (pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))) &((retval)  # "Event" ->ₛ "link") (event_created (retval) (retval_4) (options_pre)) )
  **  (occupy_dll_node &((retval)  # "Event" ->ₛ "link") )
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ (dll_insert_anchor ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) ( &( "k_event_list" ) ) ) ”
.

Definition _EventCreate_partial_solve_wit_13_aux := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (retval <> 0)) (PreH2 : (addr_aligned retval 4 )) (PreH3 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH4 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 )) (PreH5 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH6 : (retval_4 >= 0)) (PreH7 : ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH8 : (0 <= UINT_MAX)) (PreH9 : (0 >= 0)) (PreH10 : (retval_3 <= INT_MAX)) (PreH11 : (retval_3 >= INT_MIN)) (PreH12 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 )) (PreH13 : (retval <> 0)) (PreH14 : (addr_aligned retval 4 )) (PreH15 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH16 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH17 : (Crtos_RTrans before_outside_critical st_lock )) (PreH18 : (retval <> 0)) (PreH19 : (addr_aligned retval 4 )) (PreH20 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH21 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH22 : (retval_2 = retval)) (PreH23 : (retval <> 0)) (PreH24 : (0 < retval)) (PreH25 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH26 : (addr_aligned retval 4 )) (PreH27 : (0 <= options_pre)) (PreH28 : (options_pre <= UINT_MAX)) (PreH29 : (options_pre <= UINT_MAX)) (PreH30 : (options_pre >= 0)) (PreH31 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (store_event (pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))) &((retval)  # "Event" ->ₛ "link") (event_created (retval) (retval_4) (options_pre)) )
  **  (occupy_dll_node &((retval)  # "Event" ->ₛ "link") )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (&((retval)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ (dll_insert_anchor ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) ( &( "k_event_list" ) ) ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "pend_list") <> 0) ” 
  &&  “ (retval_4 >= 0) ” 
  &&  “ ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128))) ” 
  &&  “ (0 <= UINT_MAX) ” 
  &&  “ (0 >= 0) ” 
  &&  “ (retval_3 <= INT_MAX) ” 
  &&  “ (retval_3 >= INT_MIN) ” 
  &&  “ (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_4 ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (event_context (os_event_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (event_addr) ((os_events (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Event" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (0 <= options_pre) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre >= 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ”
  &&  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  (store_event (pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))) &((retval)  # "Event" ->ₛ "link") (event_created (retval) (retval_4) (options_pre)) )
  **  (occupy_dll_node &((retval)  # "Event" ->ₛ "link") )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _EventCreate_partial_solve_wit_13 := _EventCreate_partial_solve_wit_13_pure -> _EventCreate_partial_solve_wit_13_aux.

Definition _EventCreate_partial_solve_wit_14_pure := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_3: Z) (retval_4: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (retval <> 0)) (PreH2 : (addr_aligned retval 4 )) (PreH3 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH4 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 )) (PreH5 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH6 : (retval_2 >= 0)) (PreH7 : ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 ) -> ((0 <= retval_2) /\ (retval_2 < 128)))) (PreH8 : (0 <= UINT_MAX)) (PreH9 : (0 >= 0)) (PreH10 : (retval_4 <= INT_MAX)) (PreH11 : (retval_4 >= INT_MIN)) (PreH12 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 )) (PreH13 : (retval <> 0)) (PreH14 : (addr_aligned retval 4 )) (PreH15 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH16 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH17 : (Crtos_RTrans before_outside_critical st_lock )) (PreH18 : (retval <> 0)) (PreH19 : (addr_aligned retval 4 )) (PreH20 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH21 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH22 : (retval_3 = retval)) (PreH23 : (retval <> 0)) (PreH24 : (0 < retval)) (PreH25 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH26 : (addr_aligned retval 4 )) (PreH27 : (0 <= options_pre)) (PreH28 : (options_pre <= UINT_MAX)) (PreH29 : (options_pre <= UINT_MAX)) (PreH30 : (options_pre >= 0)) (PreH31 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (dll_insert_after_dispatch (( &( "k_event_list" ) )) ((map (event_link_node) ((os_events (st_lock))))) (( &( "k_event_list" ) )) ((Build_DL_Node ((event_created (retval) (retval_2) (options_pre))) (&((retval)  # "Event" ->ₛ "link"))))) )
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> retval_2)
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (retval_2))) (retval_2) (&((retval)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_4)
|--
  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (event_context (os_event_stable (sg_outside_critical)) ) ” 
  &&  “ (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 ) ” 
  &&  “ ~((In retval (map (event_addr) ((os_events (st_lock)))) )) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ”
.

Definition _EventCreate_partial_solve_wit_14_aux := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_3: Z) (retval_4: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (retval <> 0)) (PreH2 : (addr_aligned retval 4 )) (PreH3 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH4 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 )) (PreH5 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH6 : (retval_2 >= 0)) (PreH7 : ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 ) -> ((0 <= retval_2) /\ (retval_2 < 128)))) (PreH8 : (0 <= UINT_MAX)) (PreH9 : (0 >= 0)) (PreH10 : (retval_4 <= INT_MAX)) (PreH11 : (retval_4 >= INT_MIN)) (PreH12 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 )) (PreH13 : (retval <> 0)) (PreH14 : (addr_aligned retval 4 )) (PreH15 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH16 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH17 : (Crtos_RTrans before_outside_critical st_lock )) (PreH18 : (retval <> 0)) (PreH19 : (addr_aligned retval 4 )) (PreH20 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH21 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH22 : (retval_3 = retval)) (PreH23 : (retval <> 0)) (PreH24 : (0 < retval)) (PreH25 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH26 : (addr_aligned retval 4 )) (PreH27 : (0 <= options_pre)) (PreH28 : (options_pre <= UINT_MAX)) (PreH29 : (options_pre <= UINT_MAX)) (PreH30 : (options_pre >= 0)) (PreH31 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (dll_insert_after_dispatch (( &( "k_event_list" ) )) ((map (event_link_node) ((os_events (st_lock))))) (( &( "k_event_list" ) )) ((Build_DL_Node ((event_created (retval) (retval_2) (options_pre))) (&((retval)  # "Event" ->ₛ "link"))))) )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (retval_2))) (retval_2) (&((retval)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (event_context (os_event_stable (sg_outside_critical)) ) ” 
  &&  “ (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 ) ” 
  &&  “ ~((In retval (map (event_addr) ((os_events (st_lock)))) )) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "pend_list") <> 0) ” 
  &&  “ (retval_2 >= 0) ” 
  &&  “ ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 ) -> ((0 <= retval_2) /\ (retval_2 < 128))) ” 
  &&  “ (0 <= UINT_MAX) ” 
  &&  “ (0 >= 0) ” 
  &&  “ (retval_4 <= INT_MAX) ” 
  &&  “ (retval_4 >= INT_MIN) ” 
  &&  “ (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (event_context (os_event_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (event_addr) ((os_events (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ (retval_3 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Event" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (0 <= options_pre) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre >= 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ”
  &&  (event_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (retval_2))) (retval_2) (&((retval)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (dll_insert_after_dispatch (( &( "k_event_list" ) )) ((map (event_link_node) ((os_events (st_lock))))) (( &( "k_event_list" ) )) ((Build_DL_Node ((event_created (retval) (retval_2) (options_pre))) (&((retval)  # "Event" ->ₛ "link"))))) )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _EventCreate_partial_solve_wit_14 := _EventCreate_partial_solve_wit_14_pure -> _EventCreate_partial_solve_wit_14_aux.

Definition _EventCreate_partial_solve_wit_15_pure := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_3: Z) (retval_4: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (0 <= retval_2)) (PreH2 : (retval_2 < 128)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen ((replace_events ((event_publish (retval) (retval_2) (options_pre) ((os_events (st_lock))))) (st_lock)))) ( MonadErr.ret  (retval_2)) X_outside_critical )) (PreH4 : (Crtos_GTrans st_lock (replace_events ((event_publish (retval) (retval_2) (options_pre) ((os_events (st_lock))))) (st_lock)) )) (PreH5 : (retval <> 0)) (PreH6 : (addr_aligned retval 4 )) (PreH7 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH8 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 )) (PreH9 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH10 : (retval_2 >= 0)) (PreH11 : ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 ) -> ((0 <= retval_2) /\ (retval_2 < 128)))) (PreH12 : (0 <= UINT_MAX)) (PreH13 : (0 >= 0)) (PreH14 : (retval_4 <= INT_MAX)) (PreH15 : (retval_4 >= INT_MIN)) (PreH16 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 )) (PreH17 : (retval <> 0)) (PreH18 : (addr_aligned retval 4 )) (PreH19 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH20 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH21 : (Crtos_RTrans before_outside_critical st_lock )) (PreH22 : (retval <> 0)) (PreH23 : (addr_aligned retval 4 )) (PreH24 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH25 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH26 : (retval_3 = retval)) (PreH27 : (retval <> 0)) (PreH28 : (0 < retval)) (PreH29 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH30 : (addr_aligned retval 4 )) (PreH31 : (0 <= options_pre)) (PreH32 : (options_pre <= UINT_MAX)) (PreH33 : (options_pre <= UINT_MAX)) (PreH34 : (options_pre >= 0)) (PreH35 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  ((( &( "id" ) )) # Int  |-> retval_2)
  **  ((( &( "event" ) )) # Ptr  |-> retval)
  **  (os_inv sg_outside_critical (replace_events ((event_publish (retval) (retval_2) (options_pre) ((os_events (st_lock))))) (st_lock)) )
  **  ((( &( "options" ) )) # UInt  |-> options_pre)
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_4)
|--
  “ (Crtos_GTrans st_lock (replace_events ((event_publish (retval) (retval_2) (options_pre) ((os_events (st_lock))))) (st_lock)) ) ”
.

Definition _EventCreate_partial_solve_wit_15_aux := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_3: Z) (retval_4: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (0 <= retval_2)) (PreH2 : (retval_2 < 128)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen ((replace_events ((event_publish (retval) (retval_2) (options_pre) ((os_events (st_lock))))) (st_lock)))) ( MonadErr.ret  (retval_2)) X_outside_critical )) (PreH4 : (Crtos_GTrans st_lock (replace_events ((event_publish (retval) (retval_2) (options_pre) ((os_events (st_lock))))) (st_lock)) )) (PreH5 : (retval <> 0)) (PreH6 : (addr_aligned retval 4 )) (PreH7 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH8 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 )) (PreH9 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH10 : (retval_2 >= 0)) (PreH11 : ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 ) -> ((0 <= retval_2) /\ (retval_2 < 128)))) (PreH12 : (0 <= UINT_MAX)) (PreH13 : (0 >= 0)) (PreH14 : (retval_4 <= INT_MAX)) (PreH15 : (retval_4 >= INT_MIN)) (PreH16 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 )) (PreH17 : (retval <> 0)) (PreH18 : (addr_aligned retval 4 )) (PreH19 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH20 : ~((In retval (map (event_addr) ((os_events (st_lock)))) ))) (PreH21 : (Crtos_RTrans before_outside_critical st_lock )) (PreH22 : (retval <> 0)) (PreH23 : (addr_aligned retval 4 )) (PreH24 : (&((retval)  # "Event" ->ₛ "pend_list") <> 0)) (PreH25 : (&((retval)  # "Event" ->ₛ "link") <> 0)) (PreH26 : (retval_3 = retval)) (PreH27 : (retval <> 0)) (PreH28 : (0 < retval)) (PreH29 : (retval <= (UINT_MAX - sizeof( "Event" ) ))) (PreH30 : (addr_aligned retval 4 )) (PreH31 : (0 <= options_pre)) (PreH32 : (options_pre <= UINT_MAX)) (PreH33 : (options_pre <= UINT_MAX)) (PreH34 : (options_pre >= 0)) (PreH35 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) ,
  (os_inv sg_outside_critical (replace_events ((event_publish (retval) (retval_2) (options_pre) ((os_events (st_lock))))) (st_lock)) )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (Crtos_GTrans st_lock (replace_events ((event_publish (retval) (retval_2) (options_pre) ((os_events (st_lock))))) (st_lock)) ) ” 
  &&  “ (0 <= retval_2) ” 
  &&  “ (retval_2 < 128) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen ((replace_events ((event_publish (retval) (retval_2) (options_pre) ((os_events (st_lock))))) (st_lock)))) ( MonadErr.ret  (retval_2)) X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock (replace_events ((event_publish (retval) (retval_2) (options_pre) ((os_events (st_lock))))) (st_lock)) ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "pend_list") <> 0) ” 
  &&  “ (retval_2 >= 0) ” 
  &&  “ ((idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 ) -> ((0 <= retval_2) /\ (retval_2 < 128))) ” 
  &&  “ (0 <= UINT_MAX) ” 
  &&  “ (0 >= 0) ” 
  &&  “ (retval_4 <= INT_MAX) ” 
  &&  “ (retval_4 >= INT_MIN) ” 
  &&  “ (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) retval_2 ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (event_context (os_event_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (event_addr) ((os_events (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ (retval_3 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Event" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (0 <= options_pre) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre <= UINT_MAX) ” 
  &&  “ (options_pre >= 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical ) ”
  &&  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical (replace_events ((event_publish (retval) (retval_2) (options_pre) ((os_events (st_lock))))) (st_lock)) )
.

Definition _EventCreate_partial_solve_wit_15 := _EventCreate_partial_solve_wit_15_pure -> _EventCreate_partial_solve_wit_15_aux.

Definition _EventCreate_which_implies_wit_1 := 
(
forall (event: Z) (PreH1 : (0 < event)) (PreH2 : (event <= (UINT_MAX - sizeof( "Event" ) ))) (PreH3 : (addr_aligned event 4 )) ,
  (CharArray.full event sizeof( "Event" ) (repeat_Z (0) (sizeof( "Event" ))) )
|--
  “ (event <> 0) ” 
  &&  “ (addr_aligned event 4 ) ” 
  &&  “ (&((event)  # "Event" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((event)  # "Event" ->ₛ "link") <> 0) ”
  &&  (EventZero event )
) \/
(
forall (event: Z) (PreH1 : (0 < event)) (PreH2 : (event <= (UINT_MAX - sizeof( "Event" ) ))) (PreH3 : (addr_aligned event 4 )) ,
  (CharArray.full event sizeof( "Event" ) (repeat_Z (0) (sizeof( "Event" ))) )
|--
  “ (&((event)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ (&((event)  # "Event" ->ₛ "pend_list") <> 0) ”
  &&  (EventZero event )
).

Definition _EventCreate_which_implies_wit_1_split_goal_1 := 
forall (event: Z) (PreH1 : (0 < event)) (PreH2 : (event <= (UINT_MAX - sizeof( "Event" ) ))) (PreH3 : (addr_aligned event 4 )) ,
  (CharArray.full event sizeof( "Event" ) (repeat_Z (0) (sizeof( "Event" ))) )
|--
  “ (&((event)  # "Event" ->ₛ "link") <> 0) ”
.

Definition _EventCreate_which_implies_wit_1_split_goal_2 := 
forall (event: Z) (PreH1 : (0 < event)) (PreH2 : (event <= (UINT_MAX - sizeof( "Event" ) ))) (PreH3 : (addr_aligned event 4 )) ,
  (CharArray.full event sizeof( "Event" ) (repeat_Z (0) (sizeof( "Event" ))) )
|--
  “ (&((event)  # "Event" ->ₛ "pend_list") <> 0) ”
.

Definition _EventCreate_which_implies_wit_1_split_goal_spatial := 
forall (event: Z) (PreH1 : (0 < event)) (PreH2 : (event <= (UINT_MAX - sizeof( "Event" ) ))) (PreH3 : (addr_aligned event 4 )) ,
  (CharArray.full event sizeof( "Event" ) (repeat_Z (0) (sizeof( "Event" ))) )
|--
  (EventZero event )
.

Definition _EventCreate_which_implies_wit_2 := 
(
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (event: Z) ,
  (os_inv sg_outside_critical st_lock )
  **  (EventZero event )
|--
  “ (event <> 0) ” 
  &&  “ (addr_aligned event 4 ) ” 
  &&  “ (event_context (os_event_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In event (map (event_addr) ((os_events (st_lock)))) )) ”
  &&  (event_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  (store_idnode_insert_ready &((event)  # "Event" ->ₛ "id") )
  **  ((&((event)  # "Event" ->ₛ "options")) # UInt  |-> 0)
  **  ((&((event)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((event)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((event)  # "Event" ->ₛ "link") )
  **  (EventPadding event )
) \/
(
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (event: Z) ,
  (os_inv sg_outside_critical st_lock )
  **  (EventZero event )
|--
  “ ~((In event (map (event_addr) ((os_events (st_lock)))) )) ” 
  &&  “ (event_context (os_event_stable (sg_outside_critical)) ) ” 
  &&  “ (addr_aligned event 4 ) ” 
  &&  “ (event <> 0) ”
  &&  (event_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  (store_idnode_insert_ready &((event)  # "Event" ->ₛ "id") )
  **  ((&((event)  # "Event" ->ₛ "options")) # UInt  |-> 0)
  **  ((&((event)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((event)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((event)  # "Event" ->ₛ "link") )
  **  (EventPadding event )
).

Definition _EventCreate_which_implies_wit_2_split_goal_1 := 
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (event: Z) ,
  (os_inv sg_outside_critical st_lock )
  **  (EventZero event )
|--
  “ ~((In event (map (event_addr) ((os_events (st_lock)))) )) ”
.

Definition _EventCreate_which_implies_wit_2_split_goal_2 := 
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (event: Z) ,
  (os_inv sg_outside_critical st_lock )
  **  (EventZero event )
|--
  “ (event_context (os_event_stable (sg_outside_critical)) ) ”
.

Definition _EventCreate_which_implies_wit_2_split_goal_3 := 
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (event: Z) ,
  (os_inv sg_outside_critical st_lock )
  **  (EventZero event )
|--
  “ (addr_aligned event 4 ) ”
.

Definition _EventCreate_which_implies_wit_2_split_goal_4 := 
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (event: Z) ,
  (os_inv sg_outside_critical st_lock )
  **  (EventZero event )
|--
  “ (event <> 0) ”
.

Definition _EventCreate_which_implies_wit_2_split_goal_spatial := 
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (event: Z) ,
  (os_inv sg_outside_critical st_lock )
  **  (EventZero event )
|--
  (event_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  (store_idnode_insert_ready &((event)  # "Event" ->ₛ "id") )
  **  ((&((event)  # "Event" ->ₛ "options")) # UInt  |-> 0)
  **  ((&((event)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((event)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((event)  # "Event" ->ₛ "link") )
  **  (EventPadding event )
.

Definition _EventCreate_which_implies_wit_3 := 
(
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (event: Z) (PreH1 : (event <> 0)) (PreH2 : (addr_aligned event 4 )) (PreH3 : (&((event)  # "Event" ->ₛ "pend_list") <> 0)) (PreH4 : (&((event)  # "Event" ->ₛ "link") <> 0)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) (PreH6 : (Crtos_RTrans before_outside_critical st_lock )) ,
  (event_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  (store_idnode_insert_ready &((event)  # "Event" ->ₛ "id") )
  **  ((&((event)  # "Event" ->ₛ "options")) # UInt  |-> 0)
  **  ((&((event)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((event)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((event)  # "Event" ->ₛ "link") )
  **  (EventPadding event )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  ((-5))) X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock st_lock ) ”
  &&  (os_inv sg_outside_critical st_lock )
  **  (EventRaw event )
) \/
(
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (event: Z) (PreH1 : (0 <= UINT_MAX)) (PreH2 : (0 >= 0)) (PreH3 : (event <> 0)) (PreH4 : (addr_aligned event 4 )) (PreH5 : (&((event)  # "Event" ->ₛ "pend_list") <> 0)) (PreH6 : (&((event)  # "Event" ->ₛ "link") <> 0)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) (PreH8 : (Crtos_RTrans before_outside_critical st_lock )) ,
  (event_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  (store_idnode_insert_ready &((event)  # "Event" ->ₛ "id") )
  **  ((&((event)  # "Event" ->ₛ "options")) # UInt  |-> 0)
  **  ((&((event)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((event)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((event)  # "Event" ->ₛ "link") )
  **  (EventPadding event )
|--
  “ (Crtos_GTrans st_lock st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  ((-5))) X_outside_critical ) ”
  &&  (os_inv sg_outside_critical st_lock )
  **  (EventRaw event )
).

Definition _EventCreate_which_implies_wit_3_split_goal_1 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (event: Z) (PreH1 : (0 <= UINT_MAX)) (PreH2 : (0 >= 0)) (PreH3 : (event <> 0)) (PreH4 : (addr_aligned event 4 )) (PreH5 : (&((event)  # "Event" ->ₛ "pend_list") <> 0)) (PreH6 : (&((event)  # "Event" ->ₛ "link") <> 0)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) (PreH8 : (Crtos_RTrans before_outside_critical st_lock )) ,
  (event_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  (store_idnode_insert_ready &((event)  # "Event" ->ₛ "id") )
  **  ((&((event)  # "Event" ->ₛ "options")) # UInt  |-> 0)
  **  ((&((event)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((event)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((event)  # "Event" ->ₛ "link") )
  **  (EventPadding event )
|--
  “ (Crtos_GTrans st_lock st_lock ) ”
.

Definition _EventCreate_which_implies_wit_3_split_goal_2 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (event: Z) (PreH1 : (0 <= UINT_MAX)) (PreH2 : (0 >= 0)) (PreH3 : (event <> 0)) (PreH4 : (addr_aligned event 4 )) (PreH5 : (&((event)  # "Event" ->ₛ "pend_list") <> 0)) (PreH6 : (&((event)  # "Event" ->ₛ "link") <> 0)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) (PreH8 : (Crtos_RTrans before_outside_critical st_lock )) ,
  (event_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  (store_idnode_insert_ready &((event)  # "Event" ->ₛ "id") )
  **  ((&((event)  # "Event" ->ₛ "options")) # UInt  |-> 0)
  **  ((&((event)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((event)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((event)  # "Event" ->ₛ "link") )
  **  (EventPadding event )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  ((-5))) X_outside_critical ) ”
.

Definition _EventCreate_which_implies_wit_3_split_goal_spatial := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (event: Z) (PreH1 : (0 <= UINT_MAX)) (PreH2 : (0 >= 0)) (PreH3 : (event <> 0)) (PreH4 : (addr_aligned event 4 )) (PreH5 : (&((event)  # "Event" ->ₛ "pend_list") <> 0)) (PreH6 : (&((event)  # "Event" ->ₛ "link") <> 0)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) (PreH8 : (Crtos_RTrans before_outside_critical st_lock )) ,
  (event_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) ( &( "k_event_id_manager" ) ) )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (map (event_link_node) ((os_events (st_lock)))) )
  **  (store_idnode_insert_ready &((event)  # "Event" ->ₛ "id") )
  **  ((&((event)  # "Event" ->ₛ "options")) # UInt  |-> 0)
  **  ((&((event)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (NodeZero &((event)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((event)  # "Event" ->ₛ "link") )
  **  (EventPadding event )
|--
  (os_inv sg_outside_critical st_lock )
  **  (EventRaw event )
.

Definition _EventCreate_which_implies_wit_4 := 
(
forall (event: Z) ,
  (NodeZero &((event)  # "Event" ->ₛ "pend_list") )
|--
  ((&((event)  # "Event" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((event)  # "Event" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |->_)
) \/
(
forall (event: Z) ,
  (NodeZero &((event)  # "Event" ->ₛ "pend_list") )
|--
  EX (x_2: Z)  (x: Z) ,
  ((&((event)  # "Event" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |-> x_2)
  **  ((&((event)  # "Event" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |-> x)
).

Definition _EventCreate_which_implies_wit_5 := 
(
forall (options_pre: Z) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (event: Z) (id: Z) (PreH1 : (event <> 0)) (PreH2 : (addr_aligned event 4 )) (PreH3 : (&((event)  # "Event" ->ₛ "link") <> 0)) (PreH4 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) id )) ,
  ((&((event)  # "Event" ->ₛ "options")) # UInt  |-> (Z.land options_pre 7))
  **  ((&((event)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (store_node_self_linked &((event)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((event)  # "Event" ->ₛ "link") )
  **  (EventPadding event )
|--
  “ (event <> 0) ” 
  &&  “ (addr_aligned event 4 ) ” 
  &&  “ (&((event)  # "Event" ->ₛ "link") <> 0) ” 
  &&  “ (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) id ) ”
  &&  (store_event (pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))) &((event)  # "Event" ->ₛ "link") (event_created (event) (id) (options_pre)) )
  **  (occupy_dll_node &((event)  # "Event" ->ₛ "link") )
) \/
(
forall (options_pre: Z) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (event: Z) (id: Z) (PreH1 : (0 <= UINT_MAX)) (PreH2 : ((Z.land options_pre 7) <= UINT_MAX)) (PreH3 : (0 >= 0)) (PreH4 : ((Z.land options_pre 7) >= 0)) (PreH5 : (event <> 0)) (PreH6 : (addr_aligned event 4 )) (PreH7 : (&((event)  # "Event" ->ₛ "link") <> 0)) (PreH8 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) id )) ,
  ((&((event)  # "Event" ->ₛ "options")) # UInt  |-> (Z.land options_pre 7))
  **  ((&((event)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (store_node_self_linked &((event)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((event)  # "Event" ->ₛ "link") )
  **  (EventPadding event )
|--
  (store_event (pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))) &((event)  # "Event" ->ₛ "link") (event_created (event) (id) (options_pre)) )
  **  (occupy_dll_node &((event)  # "Event" ->ₛ "link") )
).

Definition _EventCreate_which_implies_wit_5_split_goal_spatial := 
forall (options_pre: Z) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (event: Z) (id: Z) (PreH1 : (0 <= UINT_MAX)) (PreH2 : ((Z.land options_pre 7) <= UINT_MAX)) (PreH3 : (0 >= 0)) (PreH4 : ((Z.land options_pre 7) >= 0)) (PreH5 : (event <> 0)) (PreH6 : (addr_aligned event 4 )) (PreH7 : (&((event)  # "Event" ->ₛ "link") <> 0)) (PreH8 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) id )) ,
  ((&((event)  # "Event" ->ₛ "options")) # UInt  |-> (Z.land options_pre 7))
  **  ((&((event)  # "Event" ->ₛ "events")) # UInt  |-> 0)
  **  (store_node_self_linked &((event)  # "Event" ->ₛ "pend_list") )
  **  (NodeZero &((event)  # "Event" ->ₛ "link") )
  **  (EventPadding event )
|--
  (store_event (pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))) &((event)  # "Event" ->ₛ "link") (event_created (event) (id) (options_pre)) )
  **  (occupy_dll_node &((event)  # "Event" ->ₛ "link") )
.

Definition _EventCreate_which_implies_wit_6 := 
(
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (event: Z) (id: Z) (PreH1 : (event <> 0)) (PreH2 : (addr_aligned event 4 )) (PreH3 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH4 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) id )) (PreH5 : ~((In event (map (event_addr) ((os_events (st_lock)))) ))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) (PreH7 : (Crtos_RTrans before_outside_critical st_lock )) ,
  (event_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (id))) (id) (&((event)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (dll_insert_after_dispatch (( &( "k_event_list" ) )) ((map (event_link_node) ((os_events (st_lock))))) (( &( "k_event_list" ) )) ((Build_DL_Node ((event_created (event) (id) (options_pre))) (&((event)  # "Event" ->ₛ "link"))))) )
|--
  “ (0 <= id) ” 
  &&  “ (id < 128) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen ((replace_events ((event_publish (event) (id) (options_pre) ((os_events (st_lock))))) (st_lock)))) ( MonadErr.ret  (id)) X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock (replace_events ((event_publish (event) (id) (options_pre) ((os_events (st_lock))))) (st_lock)) ) ”
  &&  (os_inv sg_outside_critical (replace_events ((event_publish (event) (id) (options_pre) ((os_events (st_lock))))) (st_lock)) )
) \/
(
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (event: Z) (id: Z) (PreH1 : (event <> 0)) (PreH2 : (addr_aligned event 4 )) (PreH3 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH4 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) id )) (PreH5 : ~((In event (map (event_addr) ((os_events (st_lock)))) ))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) (PreH7 : (Crtos_RTrans before_outside_critical st_lock )) ,
  (event_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (id))) (id) (&((event)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (dll_insert_after_dispatch (( &( "k_event_list" ) )) ((map (event_link_node) ((os_events (st_lock))))) (( &( "k_event_list" ) )) ((Build_DL_Node ((event_created (event) (id) (options_pre))) (&((event)  # "Event" ->ₛ "link"))))) )
|--
  “ (Crtos_GTrans st_lock (replace_events ((event_publish (event) (id) (options_pre) ((os_events (st_lock))))) (st_lock)) ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen ((replace_events ((event_publish (event) (id) (options_pre) ((os_events (st_lock))))) (st_lock)))) ( MonadErr.ret  (id)) X_outside_critical ) ” 
  &&  “ (id < 128) ” 
  &&  “ (0 <= id) ”
  &&  (os_inv sg_outside_critical (replace_events ((event_publish (event) (id) (options_pre) ((os_events (st_lock))))) (st_lock)) )
).

Definition _EventCreate_which_implies_wit_6_split_goal_1 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (event: Z) (id: Z) (PreH1 : (event <> 0)) (PreH2 : (addr_aligned event 4 )) (PreH3 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH4 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) id )) (PreH5 : ~((In event (map (event_addr) ((os_events (st_lock)))) ))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) (PreH7 : (Crtos_RTrans before_outside_critical st_lock )) ,
  (event_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (id))) (id) (&((event)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (dll_insert_after_dispatch (( &( "k_event_list" ) )) ((map (event_link_node) ((os_events (st_lock))))) (( &( "k_event_list" ) )) ((Build_DL_Node ((event_created (event) (id) (options_pre))) (&((event)  # "Event" ->ₛ "link"))))) )
|--
  “ (Crtos_GTrans st_lock (replace_events ((event_publish (event) (id) (options_pre) ((os_events (st_lock))))) (st_lock)) ) ”
.

Definition _EventCreate_which_implies_wit_6_split_goal_2 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (event: Z) (id: Z) (PreH1 : (event <> 0)) (PreH2 : (addr_aligned event 4 )) (PreH3 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH4 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) id )) (PreH5 : ~((In event (map (event_addr) ((os_events (st_lock)))) ))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) (PreH7 : (Crtos_RTrans before_outside_critical st_lock )) ,
  (event_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (id))) (id) (&((event)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (dll_insert_after_dispatch (( &( "k_event_list" ) )) ((map (event_link_node) ((os_events (st_lock))))) (( &( "k_event_list" ) )) ((Build_DL_Node ((event_created (event) (id) (options_pre))) (&((event)  # "Event" ->ₛ "link"))))) )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen ((replace_events ((event_publish (event) (id) (options_pre) ((os_events (st_lock))))) (st_lock)))) ( MonadErr.ret  (id)) X_outside_critical ) ”
.

Definition _EventCreate_which_implies_wit_6_split_goal_3 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (event: Z) (id: Z) (PreH1 : (event <> 0)) (PreH2 : (addr_aligned event 4 )) (PreH3 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH4 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) id )) (PreH5 : ~((In event (map (event_addr) ((os_events (st_lock)))) ))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) (PreH7 : (Crtos_RTrans before_outside_critical st_lock )) ,
  (event_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (id))) (id) (&((event)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (dll_insert_after_dispatch (( &( "k_event_list" ) )) ((map (event_link_node) ((os_events (st_lock))))) (( &( "k_event_list" ) )) ((Build_DL_Node ((event_created (event) (id) (options_pre))) (&((event)  # "Event" ->ₛ "link"))))) )
|--
  “ (id < 128) ”
.

Definition _EventCreate_which_implies_wit_6_split_goal_4 := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (event: Z) (id: Z) (PreH1 : (event <> 0)) (PreH2 : (addr_aligned event 4 )) (PreH3 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH4 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) id )) (PreH5 : ~((In event (map (event_addr) ((os_events (st_lock)))) ))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) (PreH7 : (Crtos_RTrans before_outside_critical st_lock )) ,
  (event_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (id))) (id) (&((event)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (dll_insert_after_dispatch (( &( "k_event_list" ) )) ((map (event_link_node) ((os_events (st_lock))))) (( &( "k_event_list" ) )) ((Build_DL_Node ((event_created (event) (id) (options_pre))) (&((event)  # "Event" ->ₛ "link"))))) )
|--
  “ (0 <= id) ”
.

Definition _EventCreate_which_implies_wit_6_split_goal_spatial := 
forall (options_pre: Z) (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (event: Z) (id: Z) (PreH1 : (event <> 0)) (PreH2 : (addr_aligned event 4 )) (PreH3 : (event_context (os_event_stable (sg_outside_critical)) )) (PreH4 : (idmanager_min_free_id (event_manager_stable ((os_event_stable (sg_outside_critical)))) (event_manager ((os_events (st_lock)))) id )) (PreH5 : ~((In event (map (event_addr) ((os_events (st_lock)))) ))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_event_create (sg_outside_critical) (options_pre)) X_outside_critical )) (PreH7 : (Crtos_RTrans before_outside_critical st_lock )) ,
  (event_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_outside_critical)))) (idmanager_link ((event_manager_stable ((os_event_stable (sg_outside_critical))))) ((idmanager_add ((event_manager ((os_events (st_lock))))) (id))) (id) (&((event)  # "Event" ->ₛ "id"))) ( &( "k_event_id_manager" ) ) )
  **  (store_dll (store_event ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_event_list" ) ) (dll_insert_after_dispatch (( &( "k_event_list" ) )) ((map (event_link_node) ((os_events (st_lock))))) (( &( "k_event_list" ) )) ((Build_DL_Node ((event_created (event) (id) (options_pre))) (&((event)  # "Event" ->ₛ "link"))))) )
|--
  (os_inv sg_outside_critical (replace_events ((event_publish (event) (id) (options_pre) ((os_events (st_lock))))) (st_lock)) )
.

Module Type VC_Correct.


Axiom proof_of__EventCreate_safety_wit_1 : _EventCreate_safety_wit_1.
Axiom proof_of__EventCreate_safety_wit_2 : _EventCreate_safety_wit_2.
Axiom proof_of__EventCreate_safety_wit_3 : _EventCreate_safety_wit_3.
Axiom proof_of__EventCreate_safety_wit_4 : _EventCreate_safety_wit_4.
Axiom proof_of__EventCreate_safety_wit_5 : _EventCreate_safety_wit_5.
Axiom proof_of__EventCreate_safety_wit_6 : _EventCreate_safety_wit_6.
Axiom proof_of__EventCreate_safety_wit_7 : _EventCreate_safety_wit_7.
Axiom proof_of__EventCreate_safety_wit_8 : _EventCreate_safety_wit_8.
Axiom proof_of__EventCreate_safety_wit_9 : _EventCreate_safety_wit_9.
Axiom proof_of__EventCreate_safety_wit_10 : _EventCreate_safety_wit_10.
Axiom proof_of__EventCreate_safety_wit_11 : _EventCreate_safety_wit_11.
Axiom proof_of__EventCreate_safety_wit_12 : _EventCreate_safety_wit_12.
Axiom proof_of__EventCreate_safety_wit_13 : _EventCreate_safety_wit_13.
Axiom proof_of__EventCreate_safety_wit_14 : _EventCreate_safety_wit_14.
Axiom proof_of__EventCreate_safety_wit_15 : _EventCreate_safety_wit_15.
Axiom proof_of__EventCreate_safety_wit_16 : _EventCreate_safety_wit_16.
Axiom proof_of__EventCreate_entail_wit_1 : _EventCreate_entail_wit_1.
Axiom proof_of__EventCreate_entail_wit_2_1 : _EventCreate_entail_wit_2_1.
Axiom proof_of__EventCreate_entail_wit_2_2 : _EventCreate_entail_wit_2_2.
Axiom proof_of__EventCreate_return_wit_1 : _EventCreate_return_wit_1.
Axiom proof_of__EventCreate_return_wit_2 : _EventCreate_return_wit_2.
Axiom proof_of__EventCreate_return_wit_3 : _EventCreate_return_wit_3.
Axiom proof_of__EventCreate_partial_solve_wit_1_pure : _EventCreate_partial_solve_wit_1_pure.
Axiom proof_of__EventCreate_partial_solve_wit_1 : _EventCreate_partial_solve_wit_1.
Axiom proof_of__EventCreate_partial_solve_wit_2_pure : _EventCreate_partial_solve_wit_2_pure.
Axiom proof_of__EventCreate_partial_solve_wit_2 : _EventCreate_partial_solve_wit_2.
Axiom proof_of__EventCreate_partial_solve_wit_3_pure : _EventCreate_partial_solve_wit_3_pure.
Axiom proof_of__EventCreate_partial_solve_wit_3 : _EventCreate_partial_solve_wit_3.
Axiom proof_of__EventCreate_partial_solve_wit_4 : _EventCreate_partial_solve_wit_4.
Axiom proof_of__EventCreate_partial_solve_wit_5 : _EventCreate_partial_solve_wit_5.
Axiom proof_of__EventCreate_partial_solve_wit_6 : _EventCreate_partial_solve_wit_6.
Axiom proof_of__EventCreate_partial_solve_wit_7_pure : _EventCreate_partial_solve_wit_7_pure.
Axiom proof_of__EventCreate_partial_solve_wit_7 : _EventCreate_partial_solve_wit_7.
Axiom proof_of__EventCreate_partial_solve_wit_8_pure : _EventCreate_partial_solve_wit_8_pure.
Axiom proof_of__EventCreate_partial_solve_wit_8 : _EventCreate_partial_solve_wit_8.
Axiom proof_of__EventCreate_partial_solve_wit_9 : _EventCreate_partial_solve_wit_9.
Axiom proof_of__EventCreate_partial_solve_wit_10 : _EventCreate_partial_solve_wit_10.
Axiom proof_of__EventCreate_partial_solve_wit_11 : _EventCreate_partial_solve_wit_11.
Axiom proof_of__EventCreate_partial_solve_wit_12_pure : _EventCreate_partial_solve_wit_12_pure.
Axiom proof_of__EventCreate_partial_solve_wit_12 : _EventCreate_partial_solve_wit_12.
Axiom proof_of__EventCreate_partial_solve_wit_13_pure : _EventCreate_partial_solve_wit_13_pure.
Axiom proof_of__EventCreate_partial_solve_wit_13 : _EventCreate_partial_solve_wit_13.
Axiom proof_of__EventCreate_partial_solve_wit_14_pure : _EventCreate_partial_solve_wit_14_pure.
Axiom proof_of__EventCreate_partial_solve_wit_14 : _EventCreate_partial_solve_wit_14.
Axiom proof_of__EventCreate_partial_solve_wit_15_pure : _EventCreate_partial_solve_wit_15_pure.
Axiom proof_of__EventCreate_partial_solve_wit_15 : _EventCreate_partial_solve_wit_15.
Axiom proof_of__EventCreate_which_implies_wit_1 : _EventCreate_which_implies_wit_1.
Axiom proof_of__EventCreate_which_implies_wit_2 : _EventCreate_which_implies_wit_2.
Axiom proof_of__EventCreate_which_implies_wit_3 : _EventCreate_which_implies_wit_3.
Axiom proof_of__EventCreate_which_implies_wit_4 : _EventCreate_which_implies_wit_4.
Axiom proof_of__EventCreate_which_implies_wit_5 : _EventCreate_which_implies_wit_5.
Axiom proof_of__EventCreate_which_implies_wit_6 : _EventCreate_which_implies_wit_6.

End VC_Correct.
