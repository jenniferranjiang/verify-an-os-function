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
Require Import CRTOS_Verify.lib.KMutexCreate.
Require Import CRTOS_Verify.lib.DoubleLinkListSpec.
Require Import CRTOS_Verify.lib.KTaskWakeup.
Import DLL IDNode.
From MonadLib.MonadErr
      Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.VC.MutexCreate_lib.
Local Open Scope sac.

(*----- Function _MutexCreate -----*)

Definition _MutexCreate_safety_wit_1 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  ((( &( "id" ) )) # Int  |->_)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _MutexCreate_safety_wit_2 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  ((( &( "lock" ) )) # Int  |->_)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _MutexCreate_safety_wit_3 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  ((( &( "mutex" ) )) # Ptr  |->_)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _MutexCreate_safety_wit_4 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _MutexCreate_safety_wit_5 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (PreH1 : (0 < retval)) (PreH2 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH3 : (addr_aligned retval 4 )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (CharArray.undef_full retval sizeof( "Mutex" ) )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _MutexCreate_safety_wit_6 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (retval = 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ False ”
.

Definition _MutexCreate_safety_wit_7 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (0 < retval)) (PreH3 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH4 : (addr_aligned retval 4 )) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (CharArray.undef_full retval sizeof( "Mutex" ) )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ False ”
.

Definition _MutexCreate_safety_wit_8 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (5 <> (INT_MIN)) ”
.

Definition _MutexCreate_safety_wit_9 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (5 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 5) ”
.

Definition _MutexCreate_safety_wit_10 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (0 < retval)) (PreH3 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH4 : (addr_aligned retval 4 )) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (CharArray.undef_full retval sizeof( "Mutex" ) )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _MutexCreate_safety_wit_11 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH2 : (retval_3 <= INT_MAX)) (PreH3 : (retval_3 >= INT_MIN)) (PreH4 : (retval_4 = (-1))) (PreH5 : (retval <> 0)) (PreH6 : (addr_aligned retval 4 )) (PreH7 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH8 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH9 : (Crtos_RTrans before_outside_critical st_lock )) (PreH10 : (retval <> 0)) (PreH11 : (addr_aligned retval 4 )) (PreH12 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH13 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH14 : (retval_2 = retval)) (PreH15 : (retval <> 0)) (PreH16 : (0 < retval)) (PreH17 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH18 : (addr_aligned retval 4 )) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  ((( &( "id" ) )) # Int  |-> retval_4)
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_idnode_insert_ready &((retval)  # "Mutex" ->ₛ "id") )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _MutexCreate_safety_wit_12 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH2 : (retval_3 <= INT_MAX)) (PreH3 : (retval_3 >= INT_MIN)) (PreH4 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 )) (PreH5 : (retval <> 0)) (PreH6 : (addr_aligned retval 4 )) (PreH7 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH8 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH9 : (Crtos_RTrans before_outside_critical st_lock )) (PreH10 : (retval <> 0)) (PreH11 : (addr_aligned retval 4 )) (PreH12 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH13 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH14 : (retval_2 = retval)) (PreH15 : (retval <> 0)) (PreH16 : (0 < retval)) (PreH17 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH18 : (addr_aligned retval 4 )) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  ((( &( "id" ) )) # Int  |-> retval_4)
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _MutexCreate_safety_wit_13 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (retval_4 >= 0)) (PreH2 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH3 : (retval_3 <= INT_MAX)) (PreH4 : (retval_3 >= INT_MIN)) (PreH5 : (retval_4 = (-1))) (PreH6 : (retval <> 0)) (PreH7 : (addr_aligned retval 4 )) (PreH8 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH9 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH10 : (Crtos_RTrans before_outside_critical st_lock )) (PreH11 : (retval <> 0)) (PreH12 : (addr_aligned retval 4 )) (PreH13 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH14 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH15 : (retval_2 = retval)) (PreH16 : (retval <> 0)) (PreH17 : (0 < retval)) (PreH18 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH19 : (addr_aligned retval 4 )) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  ((( &( "id" ) )) # Int  |-> retval_4)
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_idnode_insert_ready &((retval)  # "Mutex" ->ₛ "id") )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ False ”
.

Definition _MutexCreate_safety_wit_14 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (retval_4 < 0)) (PreH2 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH3 : (retval_3 <= INT_MAX)) (PreH4 : (retval_3 >= INT_MIN)) (PreH5 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 )) (PreH6 : (retval <> 0)) (PreH7 : (addr_aligned retval 4 )) (PreH8 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH9 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH10 : (Crtos_RTrans before_outside_critical st_lock )) (PreH11 : (retval <> 0)) (PreH12 : (addr_aligned retval 4 )) (PreH13 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH14 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH15 : (retval_2 = retval)) (PreH16 : (retval <> 0)) (PreH17 : (0 < retval)) (PreH18 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH19 : (addr_aligned retval 4 )) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  ((( &( "id" ) )) # Int  |-> retval_4)
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ False ”
.

Definition _MutexCreate_safety_wit_15 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  ((-5))) X_outside_critical )) (PreH2 : (Crtos_GTrans st_lock st_lock )) (PreH3 : (retval_4 < 0)) (PreH4 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH5 : (retval_3 <= INT_MAX)) (PreH6 : (retval_3 >= INT_MIN)) (PreH7 : (retval_4 = (-1))) (PreH8 : (retval <> 0)) (PreH9 : (addr_aligned retval 4 )) (PreH10 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH11 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH12 : (Crtos_RTrans before_outside_critical st_lock )) (PreH13 : (retval <> 0)) (PreH14 : (addr_aligned retval 4 )) (PreH15 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH16 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH17 : (retval_2 = retval)) (PreH18 : (retval <> 0)) (PreH19 : (0 < retval)) (PreH20 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH21 : (addr_aligned retval 4 )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (OutsideCritical sg_outside_critical st_lock )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ (5 <> (INT_MIN)) ”
.

Definition _MutexCreate_safety_wit_16 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  ((-5))) X_outside_critical )) (PreH2 : (Crtos_GTrans st_lock st_lock )) (PreH3 : (retval_4 < 0)) (PreH4 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH5 : (retval_3 <= INT_MAX)) (PreH6 : (retval_3 >= INT_MIN)) (PreH7 : (retval_4 = (-1))) (PreH8 : (retval <> 0)) (PreH9 : (addr_aligned retval 4 )) (PreH10 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH11 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH12 : (Crtos_RTrans before_outside_critical st_lock )) (PreH13 : (retval <> 0)) (PreH14 : (addr_aligned retval 4 )) (PreH15 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH16 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH17 : (retval_2 = retval)) (PreH18 : (retval <> 0)) (PreH19 : (0 < retval)) (PreH20 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH21 : (addr_aligned retval 4 )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (OutsideCritical sg_outside_critical st_lock )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ (5 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 5) ”
.

Definition _MutexCreate_safety_wit_17 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH2 : (retval_4 >= 0)) (PreH3 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH4 : (retval_3 <= INT_MAX)) (PreH5 : (retval_3 >= INT_MIN)) (PreH6 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 )) (PreH7 : (retval <> 0)) (PreH8 : (addr_aligned retval 4 )) (PreH9 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH10 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH11 : (Crtos_RTrans before_outside_critical st_lock )) (PreH12 : (retval <> 0)) (PreH13 : (addr_aligned retval 4 )) (PreH14 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH15 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH16 : (retval_2 = retval)) (PreH17 : (retval <> 0)) (PreH18 : (0 < retval)) (PreH19 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH20 : (addr_aligned retval 4 )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (store_node_self_linked &((retval)  # "Mutex" ->ₛ "pend_list") )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition _MutexCreate_safety_wit_18 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH2 : (retval_4 >= 0)) (PreH3 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH4 : (retval_3 <= INT_MAX)) (PreH5 : (retval_3 >= INT_MIN)) (PreH6 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 )) (PreH7 : (retval <> 0)) (PreH8 : (addr_aligned retval 4 )) (PreH9 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH10 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH11 : (Crtos_RTrans before_outside_critical st_lock )) (PreH12 : (retval <> 0)) (PreH13 : (addr_aligned retval 4 )) (PreH14 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH15 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH16 : (retval_2 = retval)) (PreH17 : (retval <> 0)) (PreH18 : (0 < retval)) (PreH19 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH20 : (addr_aligned retval 4 )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (store_node_self_linked &((retval)  # "Mutex" ->ₛ "pend_list") )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 1)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _MutexCreate_safety_wit_19 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH2 : (retval_4 >= 0)) (PreH3 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH4 : (retval_3 <= INT_MAX)) (PreH5 : (retval_3 >= INT_MIN)) (PreH6 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 )) (PreH7 : (retval <> 0)) (PreH8 : (addr_aligned retval 4 )) (PreH9 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH10 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH11 : (Crtos_RTrans before_outside_critical st_lock )) (PreH12 : (retval <> 0)) (PreH13 : (addr_aligned retval 4 )) (PreH14 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH15 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH16 : (retval_2 = retval)) (PreH17 : (retval <> 0)) (PreH18 : (0 < retval)) (PreH19 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH20 : (addr_aligned retval 4 )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (store_node_self_linked &((retval)  # "Mutex" ->ₛ "pend_list") )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 1)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ (255 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 255) ”
.

Definition _MutexCreate_safety_wit_20 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH2 : (retval_4 >= 0)) (PreH3 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH4 : (retval_3 <= INT_MAX)) (PreH5 : (retval_3 >= INT_MIN)) (PreH6 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 )) (PreH7 : (retval <> 0)) (PreH8 : (addr_aligned retval 4 )) (PreH9 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH10 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH11 : (Crtos_RTrans before_outside_critical st_lock )) (PreH12 : (retval <> 0)) (PreH13 : (addr_aligned retval 4 )) (PreH14 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH15 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH16 : (retval_2 = retval)) (PreH17 : (retval <> 0)) (PreH18 : (0 < retval)) (PreH19 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH20 : (addr_aligned retval 4 )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (store_node_self_linked &((retval)  # "Mutex" ->ₛ "pend_list") )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 1)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 255)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _MutexCreate_entail_wit_1_1 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (retval_4 = (-1))) (PreH2 : (retval <> 0)) (PreH3 : (addr_aligned retval 4 )) (PreH4 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH5 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH6 : (Crtos_RTrans before_outside_critical st_lock )) (PreH7 : (retval <> 0)) (PreH8 : (addr_aligned retval 4 )) (PreH9 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH10 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH11 : (retval_2 = retval)) (PreH12 : (retval <> 0)) (PreH13 : (0 < retval)) (PreH14 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH15 : (addr_aligned retval 4 )) (PreH16 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_idnode_insert_ready &((retval)  # "Mutex" ->ₛ "id") )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
|--
  (“ ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128))) ” 
  &&  “ (retval_3 <= INT_MAX) ” 
  &&  “ (retval_3 >= INT_MIN) ” 
  &&  “ (retval_4 = (-1)) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (mutex_context (os_mutex_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Mutex" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical ) ”
  &&  ((( &( "id" ) )) # Int  |-> retval_4)
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_idnode_insert_ready &((retval)  # "Mutex" ->ₛ "id") )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3))
  ||
  (EX (retval_5: Z) ,
  “ ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_5 ) -> ((0 <= retval_5) /\ (retval_5 < 128))) ” 
  &&  “ (retval_3 <= INT_MAX) ” 
  &&  “ (retval_3 >= INT_MIN) ” 
  &&  “ (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_5 ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (mutex_context (os_mutex_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Mutex" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical ) ”
  &&  ((( &( "id" ) )) # Int  |-> retval_5)
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (retval_5))) (retval_5) (&((retval)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3))
.

Definition _MutexCreate_entail_wit_1_2 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_5: Z) (PreH1 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_5 )) (PreH2 : (retval <> 0)) (PreH3 : (addr_aligned retval 4 )) (PreH4 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH5 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH6 : (Crtos_RTrans before_outside_critical st_lock )) (PreH7 : (retval <> 0)) (PreH8 : (addr_aligned retval 4 )) (PreH9 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH10 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH11 : (retval_2 = retval)) (PreH12 : (retval <> 0)) (PreH13 : (0 < retval)) (PreH14 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH15 : (addr_aligned retval 4 )) (PreH16 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (retval_5))) (retval_5) (&((retval)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
  **  ((( &( "id" ) )) # Int  |-> retval_5)
|--
  (EX (retval_4: Z) ,
  “ ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128))) ” 
  &&  “ (retval_3 <= INT_MAX) ” 
  &&  “ (retval_3 >= INT_MIN) ” 
  &&  “ (retval_4 = (-1)) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (mutex_context (os_mutex_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Mutex" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical ) ”
  &&  ((( &( "id" ) )) # Int  |-> retval_4)
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_idnode_insert_ready &((retval)  # "Mutex" ->ₛ "id") )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3))
  ||
  (“ ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_5 ) -> ((0 <= retval_5) /\ (retval_5 < 128))) ” 
  &&  “ (retval_3 <= INT_MAX) ” 
  &&  “ (retval_3 >= INT_MIN) ” 
  &&  “ (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_5 ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (mutex_context (os_mutex_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Mutex" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical ) ”
  &&  ((( &( "id" ) )) # Int  |-> retval_5)
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (retval_5))) (retval_5) (&((retval)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3))
.

Definition _MutexCreate_return_wit_1 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval_2: Z) (retval_3: Z) (retval_4: Z) (st_lock: VarGlobalState) (retval: Z) (PreH1 : (0 <= retval)) (PreH2 : (retval < 128)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen ((replace_mutexes ((mutex_publish (retval_2) (retval) ((os_mutexes (st_lock))))) (st_lock)))) ( MonadErr.ret  (retval)) X_outside_critical )) (PreH4 : (Crtos_GTrans st_lock (replace_mutexes ((mutex_publish (retval_2) (retval) ((os_mutexes (st_lock))))) (st_lock)) )) (PreH5 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval )) (PreH6 : (&((retval_2)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH7 : (retval >= 0)) (PreH8 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval ) -> ((0 <= retval) /\ (retval < 128)))) (PreH9 : (retval_4 <= INT_MAX)) (PreH10 : (retval_4 >= INT_MIN)) (PreH11 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval )) (PreH12 : (retval_2 <> 0)) (PreH13 : (addr_aligned retval_2 4 )) (PreH14 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH15 : ~((In retval_2 (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH16 : (Crtos_RTrans before_outside_critical st_lock )) (PreH17 : (retval_2 <> 0)) (PreH18 : (addr_aligned retval_2 4 )) (PreH19 : (&((retval_2)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH20 : (&((retval_2)  # "Mutex" ->ₛ "link") <> 0)) (PreH21 : (retval_3 = retval_2)) (PreH22 : (retval_2 <> 0)) (PreH23 : (0 < retval_2)) (PreH24 : (retval_2 <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH25 : (addr_aligned retval_2 4 )) (PreH26 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (OutsideCritical sg_outside_critical (replace_mutexes ((mutex_publish (retval_2) (retval) ((os_mutexes (st_lock))))) (st_lock)) )
|--
  EX (after_2: VarGlobalState) ,
  “ (0 <= retval) ” 
  &&  “ (retval < 128) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after_2)) ( MonadErr.ret  (retval)) X_outside_critical ) ”
  &&  (OutsideCritical sg_outside_critical after_2 )
.

Definition _MutexCreate_return_wit_2 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  ((-5))) X_outside_critical )) (PreH2 : (Crtos_GTrans st_lock st_lock )) (PreH3 : (retval_4 < 0)) (PreH4 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH5 : (retval_3 <= INT_MAX)) (PreH6 : (retval_3 >= INT_MIN)) (PreH7 : (retval_4 = (-1))) (PreH8 : (retval <> 0)) (PreH9 : (addr_aligned retval 4 )) (PreH10 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH11 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH12 : (Crtos_RTrans before_outside_critical st_lock )) (PreH13 : (retval <> 0)) (PreH14 : (addr_aligned retval 4 )) (PreH15 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH16 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH17 : (retval_2 = retval)) (PreH18 : (retval <> 0)) (PreH19 : (0 < retval)) (PreH20 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH21 : (addr_aligned retval 4 )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (OutsideCritical sg_outside_critical st_lock )
|--
  EX (after: VarGlobalState) ,
  “ ((-5) = (-5)) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  ((-5))) X_outside_critical ) ”
  &&  (OutsideCritical sg_outside_critical after )
.

Definition _MutexCreate_return_wit_3 := 
(
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  EX (after: VarGlobalState) ,
  “ ((-5) = (-5)) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  ((-5))) X_outside_critical ) ”
  &&  (OutsideCritical sg_outside_critical after )
) \/
(
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) ( MonadErr.ret  ((-5))) X_outside_critical ) ”
  &&  emp
).

Definition _MutexCreate_return_wit_3_split_goal_1 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) ( MonadErr.ret  ((-5))) X_outside_critical )
.

Definition _MutexCreate_partial_solve_wit_1_pure := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  ((( &( "mutex" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= sizeof( "Mutex" )) ” 
  &&  “ (sizeof( "Mutex" ) <= UINT_MAX) ”
.

Definition _MutexCreate_partial_solve_wit_1_aux := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= sizeof( "Mutex" )) ” 
  &&  “ (sizeof( "Mutex" ) <= UINT_MAX) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical ) ”
  &&  (OutsideCritical sg_outside_critical before_outside_critical )
.

Definition _MutexCreate_partial_solve_wit_1 := _MutexCreate_partial_solve_wit_1_pure -> _MutexCreate_partial_solve_wit_1_aux.

Definition _MutexCreate_partial_solve_wit_2_pure := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (0 < retval)) (PreH3 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH4 : (addr_aligned retval 4 )) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (CharArray.undef_full retval sizeof( "Mutex" ) )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= sizeof( "Mutex" )) ” 
  &&  “ (sizeof( "Mutex" ) <= UINT_MAX) ” 
  &&  “ (0 <= 0) ” 
  &&  “ (0 <= 127) ”
.

Definition _MutexCreate_partial_solve_wit_2_aux := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (0 < retval)) (PreH3 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH4 : (addr_aligned retval 4 )) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (CharArray.undef_full retval sizeof( "Mutex" ) )
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= sizeof( "Mutex" )) ” 
  &&  “ (sizeof( "Mutex" ) <= UINT_MAX) ” 
  &&  “ (0 <= 0) ” 
  &&  “ (0 <= 127) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Mutex" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical ) ”
  &&  (CharArray.undef_full retval sizeof( "Mutex" ) )
  **  (OutsideCritical sg_outside_critical before_outside_critical )
.

Definition _MutexCreate_partial_solve_wit_2 := _MutexCreate_partial_solve_wit_2_pure -> _MutexCreate_partial_solve_wit_2_aux.

Definition _MutexCreate_partial_solve_wit_3_pure := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 = retval)) (PreH2 : (retval <> 0)) (PreH3 : (0 < retval)) (PreH4 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH5 : (addr_aligned retval 4 )) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (CharArray.full retval sizeof( "Mutex" ) (repeat_Z (0) (sizeof( "Mutex" ))) )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Mutex" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ”
.

Definition _MutexCreate_partial_solve_wit_3_aux := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 = retval)) (PreH2 : (retval <> 0)) (PreH3 : (0 < retval)) (PreH4 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH5 : (addr_aligned retval 4 )) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (CharArray.full retval sizeof( "Mutex" ) (repeat_Z (0) (sizeof( "Mutex" ))) )
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Mutex" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Mutex" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical ) ”
  &&  (CharArray.full retval sizeof( "Mutex" ) (repeat_Z (0) (sizeof( "Mutex" ))) )
  **  (OutsideCritical sg_outside_critical before_outside_critical )
.

Definition _MutexCreate_partial_solve_wit_3 := _MutexCreate_partial_solve_wit_3_pure -> _MutexCreate_partial_solve_wit_3_aux.

Definition _MutexCreate_partial_solve_wit_4 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (PreH1 : (retval <> 0)) (PreH2 : (addr_aligned retval 4 )) (PreH3 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH4 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH5 : (retval_2 = retval)) (PreH6 : (retval <> 0)) (PreH7 : (0 < retval)) (PreH8 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH9 : (addr_aligned retval 4 )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (MutexZero retval )
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Mutex" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical ) ”
  &&  (OutsideCritical sg_outside_critical before_outside_critical )
  **  (MutexZero retval )
.

Definition _MutexCreate_partial_solve_wit_5 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (st_lock: VarGlobalState) (PreH1 : (Crtos_RTrans before_outside_critical st_lock )) (PreH2 : (retval <> 0)) (PreH3 : (addr_aligned retval 4 )) (PreH4 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH5 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH6 : (retval_2 = retval)) (PreH7 : (retval <> 0)) (PreH8 : (0 < retval)) (PreH9 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH10 : (addr_aligned retval 4 )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical st_lock )
  **  (MutexZero retval )
|--
  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Mutex" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical ) ”
  &&  (os_inv sg_outside_critical st_lock )
  **  (MutexZero retval )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _MutexCreate_partial_solve_wit_6 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (st_lock: VarGlobalState) (PreH1 : (retval <> 0)) (PreH2 : (addr_aligned retval 4 )) (PreH3 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH4 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH5 : (Crtos_RTrans before_outside_critical st_lock )) (PreH6 : (retval <> 0)) (PreH7 : (addr_aligned retval 4 )) (PreH8 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH9 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH10 : (retval_2 = retval)) (PreH11 : (retval <> 0)) (PreH12 : (0 < retval)) (PreH13 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH14 : (addr_aligned retval 4 )) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  (store_idnode_insert_ready &((retval)  # "Mutex" ->ₛ "id") )
  **  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (mutex_context (os_mutex_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Mutex" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical ) ”
  &&  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_idnode_insert_ready &((retval)  # "Mutex" ->ₛ "id") )
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _MutexCreate_partial_solve_wit_7_pure := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (retval_4 < 0)) (PreH2 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH3 : (retval_3 <= INT_MAX)) (PreH4 : (retval_3 >= INT_MIN)) (PreH5 : (retval_4 = (-1))) (PreH6 : (retval <> 0)) (PreH7 : (addr_aligned retval 4 )) (PreH8 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH9 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH10 : (Crtos_RTrans before_outside_critical st_lock )) (PreH11 : (retval <> 0)) (PreH12 : (addr_aligned retval 4 )) (PreH13 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH14 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH15 : (retval_2 = retval)) (PreH16 : (retval <> 0)) (PreH17 : (0 < retval)) (PreH18 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH19 : (addr_aligned retval 4 )) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  ((( &( "id" ) )) # Int  |-> retval_4)
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_idnode_insert_ready &((retval)  # "Mutex" ->ₛ "id") )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "link") <> 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical ) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ”
.

Definition _MutexCreate_partial_solve_wit_7_aux := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (retval_4 < 0)) (PreH2 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH3 : (retval_3 <= INT_MAX)) (PreH4 : (retval_3 >= INT_MIN)) (PreH5 : (retval_4 = (-1))) (PreH6 : (retval <> 0)) (PreH7 : (addr_aligned retval 4 )) (PreH8 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH9 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH10 : (Crtos_RTrans before_outside_critical st_lock )) (PreH11 : (retval <> 0)) (PreH12 : (addr_aligned retval 4 )) (PreH13 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH14 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH15 : (retval_2 = retval)) (PreH16 : (retval <> 0)) (PreH17 : (0 < retval)) (PreH18 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH19 : (addr_aligned retval 4 )) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_idnode_insert_ready &((retval)  # "Mutex" ->ₛ "id") )
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "link") <> 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical ) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval_4 < 0) ” 
  &&  “ ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128))) ” 
  &&  “ (retval_3 <= INT_MAX) ” 
  &&  “ (retval_3 >= INT_MIN) ” 
  &&  “ (retval_4 = (-1)) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (mutex_context (os_mutex_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Mutex" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical ) ”
  &&  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  (store_idnode_insert_ready &((retval)  # "Mutex" ->ₛ "id") )
  **  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _MutexCreate_partial_solve_wit_7 := _MutexCreate_partial_solve_wit_7_pure -> _MutexCreate_partial_solve_wit_7_aux.

Definition _MutexCreate_partial_solve_wit_8_pure := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  ((-5))) X_outside_critical )) (PreH2 : (Crtos_GTrans st_lock st_lock )) (PreH3 : (retval_4 < 0)) (PreH4 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH5 : (retval_3 <= INT_MAX)) (PreH6 : (retval_3 >= INT_MIN)) (PreH7 : (retval_4 = (-1))) (PreH8 : (retval <> 0)) (PreH9 : (addr_aligned retval 4 )) (PreH10 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH11 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH12 : (Crtos_RTrans before_outside_critical st_lock )) (PreH13 : (retval <> 0)) (PreH14 : (addr_aligned retval 4 )) (PreH15 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH16 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH17 : (retval_2 = retval)) (PreH18 : (retval <> 0)) (PreH19 : (0 < retval)) (PreH20 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH21 : (addr_aligned retval 4 )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (os_inv sg_outside_critical st_lock )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  (MutexRaw retval )
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ (Crtos_GTrans st_lock st_lock ) ”
.

Definition _MutexCreate_partial_solve_wit_8_aux := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  ((-5))) X_outside_critical )) (PreH2 : (Crtos_GTrans st_lock st_lock )) (PreH3 : (retval_4 < 0)) (PreH4 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH5 : (retval_3 <= INT_MAX)) (PreH6 : (retval_3 >= INT_MIN)) (PreH7 : (retval_4 = (-1))) (PreH8 : (retval <> 0)) (PreH9 : (addr_aligned retval 4 )) (PreH10 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH11 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH12 : (Crtos_RTrans before_outside_critical st_lock )) (PreH13 : (retval <> 0)) (PreH14 : (addr_aligned retval 4 )) (PreH15 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH16 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH17 : (retval_2 = retval)) (PreH18 : (retval <> 0)) (PreH19 : (0 < retval)) (PreH20 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH21 : (addr_aligned retval 4 )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (os_inv sg_outside_critical st_lock )
  **  (MutexRaw retval )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (Crtos_GTrans st_lock st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  ((-5))) X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock st_lock ) ” 
  &&  “ (retval_4 < 0) ” 
  &&  “ ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128))) ” 
  &&  “ (retval_3 <= INT_MAX) ” 
  &&  “ (retval_3 >= INT_MIN) ” 
  &&  “ (retval_4 = (-1)) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (mutex_context (os_mutex_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Mutex" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical ) ”
  &&  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical st_lock )
  **  (MutexRaw retval )
.

Definition _MutexCreate_partial_solve_wit_8 := _MutexCreate_partial_solve_wit_8_pure -> _MutexCreate_partial_solve_wit_8_aux.

Definition _MutexCreate_partial_solve_wit_9 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  ((-5))) X_outside_critical )) (PreH2 : (Crtos_GTrans st_lock st_lock )) (PreH3 : (retval_4 < 0)) (PreH4 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH5 : (retval_3 <= INT_MAX)) (PreH6 : (retval_3 >= INT_MIN)) (PreH7 : (retval_4 = (-1))) (PreH8 : (retval <> 0)) (PreH9 : (addr_aligned retval 4 )) (PreH10 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH11 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH12 : (Crtos_RTrans before_outside_critical st_lock )) (PreH13 : (retval <> 0)) (PreH14 : (addr_aligned retval 4 )) (PreH15 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH16 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH17 : (retval_2 = retval)) (PreH18 : (retval <> 0)) (PreH19 : (0 < retval)) (PreH20 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH21 : (addr_aligned retval 4 )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (OutsideCritical sg_outside_critical st_lock )
  **  (MutexRaw retval )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  ((-5))) X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock st_lock ) ” 
  &&  “ (retval_4 < 0) ” 
  &&  “ ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128))) ” 
  &&  “ (retval_3 <= INT_MAX) ” 
  &&  “ (retval_3 >= INT_MIN) ” 
  &&  “ (retval_4 = (-1)) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (mutex_context (os_mutex_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Mutex" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical ) ”
  &&  (MutexRaw retval )
  **  (OutsideCritical sg_outside_critical st_lock )
.

Definition _MutexCreate_partial_solve_wit_10 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (retval_4 >= 0)) (PreH2 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH3 : (retval_3 <= INT_MAX)) (PreH4 : (retval_3 >= INT_MIN)) (PreH5 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 )) (PreH6 : (retval <> 0)) (PreH7 : (addr_aligned retval 4 )) (PreH8 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH9 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH10 : (Crtos_RTrans before_outside_critical st_lock )) (PreH11 : (retval <> 0)) (PreH12 : (addr_aligned retval 4 )) (PreH13 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH14 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH15 : (retval_2 = retval)) (PreH16 : (retval <> 0)) (PreH17 : (0 < retval)) (PreH18 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH19 : (addr_aligned retval 4 )) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (retval_4 >= 0) ” 
  &&  “ ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128))) ” 
  &&  “ (retval_3 <= INT_MAX) ” 
  &&  “ (retval_3 >= INT_MIN) ” 
  &&  “ (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (mutex_context (os_mutex_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Mutex" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical ) ”
  &&  (NodeZero &((retval)  # "Mutex" ->ₛ "pend_list") )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _MutexCreate_partial_solve_wit_11 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (retval_4 >= 0)) (PreH2 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH3 : (retval_3 <= INT_MAX)) (PreH4 : (retval_3 >= INT_MIN)) (PreH5 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 )) (PreH6 : (retval <> 0)) (PreH7 : (addr_aligned retval 4 )) (PreH8 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH9 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH10 : (Crtos_RTrans before_outside_critical st_lock )) (PreH11 : (retval <> 0)) (PreH12 : (addr_aligned retval 4 )) (PreH13 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH14 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH15 : (retval_2 = retval)) (PreH16 : (retval <> 0)) (PreH17 : (0 < retval)) (PreH18 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH19 : (addr_aligned retval 4 )) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  ((&((retval)  # "Mutex" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((retval)  # "Mutex" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |->_)
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (retval_4 >= 0) ” 
  &&  “ ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128))) ” 
  &&  “ (retval_3 <= INT_MAX) ” 
  &&  “ (retval_3 >= INT_MIN) ” 
  &&  “ (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (mutex_context (os_mutex_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Mutex" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical ) ”
  &&  ((&((retval)  # "Mutex" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((retval)  # "Mutex" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |->_)
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _MutexCreate_partial_solve_wit_12_pure := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_3: Z) (retval_4: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH2 : (retval_2 >= 0)) (PreH3 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 ) -> ((0 <= retval_2) /\ (retval_2 < 128)))) (PreH4 : (retval_4 <= INT_MAX)) (PreH5 : (retval_4 >= INT_MIN)) (PreH6 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 )) (PreH7 : (retval <> 0)) (PreH8 : (addr_aligned retval 4 )) (PreH9 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH10 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH11 : (Crtos_RTrans before_outside_critical st_lock )) (PreH12 : (retval <> 0)) (PreH13 : (addr_aligned retval 4 )) (PreH14 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH15 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH16 : (retval_3 = retval)) (PreH17 : (retval <> 0)) (PreH18 : (0 < retval)) (PreH19 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH20 : (addr_aligned retval 4 )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (store_node_self_linked &((retval)  # "Mutex" ->ₛ "pend_list") )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> retval_2)
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (retval_2))) (retval_2) (&((retval)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 1)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 255)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_4)
|--
  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "link") <> 0) ” 
  &&  “ (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 ) ”
.

Definition _MutexCreate_partial_solve_wit_12_aux := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_3: Z) (retval_4: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH2 : (retval_2 >= 0)) (PreH3 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 ) -> ((0 <= retval_2) /\ (retval_2 < 128)))) (PreH4 : (retval_4 <= INT_MAX)) (PreH5 : (retval_4 >= INT_MIN)) (PreH6 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 )) (PreH7 : (retval <> 0)) (PreH8 : (addr_aligned retval 4 )) (PreH9 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH10 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH11 : (Crtos_RTrans before_outside_critical st_lock )) (PreH12 : (retval <> 0)) (PreH13 : (addr_aligned retval 4 )) (PreH14 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH15 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH16 : (retval_3 = retval)) (PreH17 : (retval <> 0)) (PreH18 : (0 < retval)) (PreH19 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH20 : (addr_aligned retval 4 )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (store_node_self_linked &((retval)  # "Mutex" ->ₛ "pend_list") )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (retval_2))) (retval_2) (&((retval)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 1)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 255)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "link") <> 0) ” 
  &&  “ (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 ) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0) ” 
  &&  “ (retval_2 >= 0) ” 
  &&  “ ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 ) -> ((0 <= retval_2) /\ (retval_2 < 128))) ” 
  &&  “ (retval_4 <= INT_MAX) ” 
  &&  “ (retval_4 >= INT_MIN) ” 
  &&  “ (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (mutex_context (os_mutex_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "link") <> 0) ” 
  &&  “ (retval_3 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Mutex" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical ) ”
  &&  ((&((retval)  # "Mutex" ->ₛ "val")) # UShort  |-> 1)
  **  ((&((retval)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((retval)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 255)
  **  ((&((retval)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (store_node_self_linked &((retval)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding retval )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (retval_2))) (retval_2) (&((retval)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _MutexCreate_partial_solve_wit_12 := _MutexCreate_partial_solve_wit_12_pure -> _MutexCreate_partial_solve_wit_12_aux.

Definition _MutexCreate_partial_solve_wit_13_pure := 
(
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 )) (PreH2 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH3 : (retval_4 >= 0)) (PreH4 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH5 : (retval_3 <= INT_MAX)) (PreH6 : (retval_3 >= INT_MIN)) (PreH7 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 )) (PreH8 : (retval <> 0)) (PreH9 : (addr_aligned retval 4 )) (PreH10 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH11 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH12 : (Crtos_RTrans before_outside_critical st_lock )) (PreH13 : (retval <> 0)) (PreH14 : (addr_aligned retval 4 )) (PreH15 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH16 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH17 : (retval_2 = retval)) (PreH18 : (retval <> 0)) (PreH19 : (0 < retval)) (PreH20 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH21 : (addr_aligned retval 4 )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  ((( &( "id" ) )) # Int  |-> retval_4)
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  (store_mutex (pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))) &((retval)  # "Mutex" ->ₛ "link") (mutex_created (retval) (retval_4)) )
  **  (occupy_dll_node &((retval)  # "Mutex" ->ₛ "link") )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ (&((retval)  # "Mutex" ->ₛ "link") <> 0) ” 
  &&  “ (dll_insert_anchor ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) ( &( "k_mutex_list" ) ) ) ”
) \/
(
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (retval_4 <= INT_MAX)) (PreH2 : (retval_4 >= INT_MIN)) (PreH3 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 )) (PreH4 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH5 : (retval_4 >= 0)) (PreH6 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH7 : (retval_3 <= INT_MAX)) (PreH8 : (retval_3 >= INT_MIN)) (PreH9 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 )) (PreH10 : (retval <> 0)) (PreH11 : (addr_aligned retval 4 )) (PreH12 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH13 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH14 : (Crtos_RTrans before_outside_critical st_lock )) (PreH15 : (retval <> 0)) (PreH16 : (addr_aligned retval 4 )) (PreH17 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH18 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH19 : (retval_2 = retval)) (PreH20 : (retval <> 0)) (PreH21 : (0 < retval)) (PreH22 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH23 : (addr_aligned retval 4 )) (PreH24 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  ((( &( "id" ) )) # Int  |-> retval_4)
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  (store_mutex (pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))) &((retval)  # "Mutex" ->ₛ "link") (mutex_created (retval) (retval_4)) )
  **  (occupy_dll_node &((retval)  # "Mutex" ->ₛ "link") )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ (dll_insert_anchor ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) ( &( "k_mutex_list" ) ) ) ”
).

Definition _MutexCreate_partial_solve_wit_13_pure_split_goal_1 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (retval_4 <= INT_MAX)) (PreH2 : (retval_4 >= INT_MIN)) (PreH3 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 )) (PreH4 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH5 : (retval_4 >= 0)) (PreH6 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH7 : (retval_3 <= INT_MAX)) (PreH8 : (retval_3 >= INT_MIN)) (PreH9 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 )) (PreH10 : (retval <> 0)) (PreH11 : (addr_aligned retval 4 )) (PreH12 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH13 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH14 : (Crtos_RTrans before_outside_critical st_lock )) (PreH15 : (retval <> 0)) (PreH16 : (addr_aligned retval 4 )) (PreH17 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH18 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH19 : (retval_2 = retval)) (PreH20 : (retval <> 0)) (PreH21 : (0 < retval)) (PreH22 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH23 : (addr_aligned retval 4 )) (PreH24 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  ((( &( "id" ) )) # Int  |-> retval_4)
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  (store_mutex (pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))) &((retval)  # "Mutex" ->ₛ "link") (mutex_created (retval) (retval_4)) )
  **  (occupy_dll_node &((retval)  # "Mutex" ->ₛ "link") )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
|--
  “ (dll_insert_anchor ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) ( &( "k_mutex_list" ) ) ) ”
.

Definition _MutexCreate_partial_solve_wit_13_aux := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_2: Z) (retval_3: Z) (st_lock: VarGlobalState) (retval_4: Z) (PreH1 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 )) (PreH2 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH3 : (retval_4 >= 0)) (PreH4 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128)))) (PreH5 : (retval_3 <= INT_MAX)) (PreH6 : (retval_3 >= INT_MIN)) (PreH7 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 )) (PreH8 : (retval <> 0)) (PreH9 : (addr_aligned retval 4 )) (PreH10 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH11 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH12 : (Crtos_RTrans before_outside_critical st_lock )) (PreH13 : (retval <> 0)) (PreH14 : (addr_aligned retval 4 )) (PreH15 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH16 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH17 : (retval_2 = retval)) (PreH18 : (retval <> 0)) (PreH19 : (0 < retval)) (PreH20 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH21 : (addr_aligned retval 4 )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (store_mutex (pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))) &((retval)  # "Mutex" ->ₛ "link") (mutex_created (retval) (retval_4)) )
  **  (occupy_dll_node &((retval)  # "Mutex" ->ₛ "link") )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (&((retval)  # "Mutex" ->ₛ "link") <> 0) ” 
  &&  “ (dll_insert_anchor ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) ( &( "k_mutex_list" ) ) ) ” 
  &&  “ (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0) ” 
  &&  “ (retval_4 >= 0) ” 
  &&  “ ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) -> ((0 <= retval_4) /\ (retval_4 < 128))) ” 
  &&  “ (retval_3 <= INT_MAX) ” 
  &&  “ (retval_3 >= INT_MIN) ” 
  &&  “ (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_4 ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (mutex_context (os_mutex_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "link") <> 0) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Mutex" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical ) ”
  &&  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  (store_mutex (pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))) &((retval)  # "Mutex" ->ₛ "link") (mutex_created (retval) (retval_4)) )
  **  (occupy_dll_node &((retval)  # "Mutex" ->ₛ "link") )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (retval_4))) (retval_4) (&((retval)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _MutexCreate_partial_solve_wit_13 := _MutexCreate_partial_solve_wit_13_pure -> _MutexCreate_partial_solve_wit_13_aux.

Definition _MutexCreate_partial_solve_wit_14_pure := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_3: Z) (retval_4: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 )) (PreH2 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH3 : (retval_2 >= 0)) (PreH4 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 ) -> ((0 <= retval_2) /\ (retval_2 < 128)))) (PreH5 : (retval_4 <= INT_MAX)) (PreH6 : (retval_4 >= INT_MIN)) (PreH7 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 )) (PreH8 : (retval <> 0)) (PreH9 : (addr_aligned retval 4 )) (PreH10 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH11 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH12 : (Crtos_RTrans before_outside_critical st_lock )) (PreH13 : (retval <> 0)) (PreH14 : (addr_aligned retval 4 )) (PreH15 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH16 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH17 : (retval_3 = retval)) (PreH18 : (retval <> 0)) (PreH19 : (0 < retval)) (PreH20 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH21 : (addr_aligned retval 4 )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (dll_insert_after_dispatch (( &( "k_mutex_list" ) )) ((map (mutex_link_node) ((os_mutexes (st_lock))))) (( &( "k_mutex_list" ) )) ((Build_DL_Node ((mutex_created (retval) (retval_2))) (&((retval)  # "Mutex" ->ₛ "link"))))) )
  **  ((( &( "id" ) )) # Int  |-> retval_2)
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (retval_2))) (retval_2) (&((retval)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_4)
|--
  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (mutex_context (os_mutex_stable (sg_outside_critical)) ) ” 
  &&  “ (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 ) ” 
  &&  “ ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) )) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical ) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ”
.

Definition _MutexCreate_partial_solve_wit_14_aux := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_3: Z) (retval_4: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 )) (PreH2 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH3 : (retval_2 >= 0)) (PreH4 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 ) -> ((0 <= retval_2) /\ (retval_2 < 128)))) (PreH5 : (retval_4 <= INT_MAX)) (PreH6 : (retval_4 >= INT_MIN)) (PreH7 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 )) (PreH8 : (retval <> 0)) (PreH9 : (addr_aligned retval 4 )) (PreH10 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH11 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH12 : (Crtos_RTrans before_outside_critical st_lock )) (PreH13 : (retval <> 0)) (PreH14 : (addr_aligned retval 4 )) (PreH15 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH16 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH17 : (retval_3 = retval)) (PreH18 : (retval <> 0)) (PreH19 : (0 < retval)) (PreH20 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH21 : (addr_aligned retval 4 )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (dll_insert_after_dispatch (( &( "k_mutex_list" ) )) ((map (mutex_link_node) ((os_mutexes (st_lock))))) (( &( "k_mutex_list" ) )) ((Build_DL_Node ((mutex_created (retval) (retval_2))) (&((retval)  # "Mutex" ->ₛ "link"))))) )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (retval_2))) (retval_2) (&((retval)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_create_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (mutex_context (os_mutex_stable (sg_outside_critical)) ) ” 
  &&  “ (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 ) ” 
  &&  “ ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) )) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical ) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 ) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0) ” 
  &&  “ (retval_2 >= 0) ” 
  &&  “ ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 ) -> ((0 <= retval_2) /\ (retval_2 < 128))) ” 
  &&  “ (retval_4 <= INT_MAX) ” 
  &&  “ (retval_4 >= INT_MIN) ” 
  &&  “ (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (mutex_context (os_mutex_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "link") <> 0) ” 
  &&  “ (retval_3 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Mutex" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical ) ”
  &&  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (retval_2))) (retval_2) (&((retval)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (dll_insert_after_dispatch (( &( "k_mutex_list" ) )) ((map (mutex_link_node) ((os_mutexes (st_lock))))) (( &( "k_mutex_list" ) )) ((Build_DL_Node ((mutex_created (retval) (retval_2))) (&((retval)  # "Mutex" ->ₛ "link"))))) )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _MutexCreate_partial_solve_wit_14 := _MutexCreate_partial_solve_wit_14_pure -> _MutexCreate_partial_solve_wit_14_aux.

Definition _MutexCreate_partial_solve_wit_15_pure := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_3: Z) (retval_4: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (0 <= retval_2)) (PreH2 : (retval_2 < 128)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen ((replace_mutexes ((mutex_publish (retval) (retval_2) ((os_mutexes (st_lock))))) (st_lock)))) ( MonadErr.ret  (retval_2)) X_outside_critical )) (PreH4 : (Crtos_GTrans st_lock (replace_mutexes ((mutex_publish (retval) (retval_2) ((os_mutexes (st_lock))))) (st_lock)) )) (PreH5 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 )) (PreH6 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH7 : (retval_2 >= 0)) (PreH8 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 ) -> ((0 <= retval_2) /\ (retval_2 < 128)))) (PreH9 : (retval_4 <= INT_MAX)) (PreH10 : (retval_4 >= INT_MIN)) (PreH11 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 )) (PreH12 : (retval <> 0)) (PreH13 : (addr_aligned retval 4 )) (PreH14 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH15 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH16 : (Crtos_RTrans before_outside_critical st_lock )) (PreH17 : (retval <> 0)) (PreH18 : (addr_aligned retval 4 )) (PreH19 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH20 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH21 : (retval_3 = retval)) (PreH22 : (retval <> 0)) (PreH23 : (0 < retval)) (PreH24 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH25 : (addr_aligned retval 4 )) (PreH26 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  ((( &( "id" ) )) # Int  |-> retval_2)
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  (os_inv sg_outside_critical (replace_mutexes ((mutex_publish (retval) (retval_2) ((os_mutexes (st_lock))))) (st_lock)) )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_4)
|--
  “ (Crtos_GTrans st_lock (replace_mutexes ((mutex_publish (retval) (retval_2) ((os_mutexes (st_lock))))) (st_lock)) ) ”
.

Definition _MutexCreate_partial_solve_wit_15_aux := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (retval_3: Z) (retval_4: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (0 <= retval_2)) (PreH2 : (retval_2 < 128)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen ((replace_mutexes ((mutex_publish (retval) (retval_2) ((os_mutexes (st_lock))))) (st_lock)))) ( MonadErr.ret  (retval_2)) X_outside_critical )) (PreH4 : (Crtos_GTrans st_lock (replace_mutexes ((mutex_publish (retval) (retval_2) ((os_mutexes (st_lock))))) (st_lock)) )) (PreH5 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 )) (PreH6 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH7 : (retval_2 >= 0)) (PreH8 : ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 ) -> ((0 <= retval_2) /\ (retval_2 < 128)))) (PreH9 : (retval_4 <= INT_MAX)) (PreH10 : (retval_4 >= INT_MIN)) (PreH11 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 )) (PreH12 : (retval <> 0)) (PreH13 : (addr_aligned retval 4 )) (PreH14 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH15 : ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH16 : (Crtos_RTrans before_outside_critical st_lock )) (PreH17 : (retval <> 0)) (PreH18 : (addr_aligned retval 4 )) (PreH19 : (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH20 : (&((retval)  # "Mutex" ->ₛ "link") <> 0)) (PreH21 : (retval_3 = retval)) (PreH22 : (retval <> 0)) (PreH23 : (0 < retval)) (PreH24 : (retval <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH25 : (addr_aligned retval 4 )) (PreH26 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) ,
  (os_inv sg_outside_critical (replace_mutexes ((mutex_publish (retval) (retval_2) ((os_mutexes (st_lock))))) (st_lock)) )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (Crtos_GTrans st_lock (replace_mutexes ((mutex_publish (retval) (retval_2) ((os_mutexes (st_lock))))) (st_lock)) ) ” 
  &&  “ (0 <= retval_2) ” 
  &&  “ (retval_2 < 128) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen ((replace_mutexes ((mutex_publish (retval) (retval_2) ((os_mutexes (st_lock))))) (st_lock)))) ( MonadErr.ret  (retval_2)) X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock (replace_mutexes ((mutex_publish (retval) (retval_2) ((os_mutexes (st_lock))))) (st_lock)) ) ” 
  &&  “ (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 ) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0) ” 
  &&  “ (retval_2 >= 0) ” 
  &&  “ ((idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 ) -> ((0 <= retval_2) /\ (retval_2 < 128))) ” 
  &&  “ (retval_4 <= INT_MAX) ” 
  &&  “ (retval_4 >= INT_MIN) ” 
  &&  “ (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) retval_2 ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (mutex_context (os_mutex_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In retval (map (mutex_addr) ((os_mutexes (st_lock)))) )) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Mutex" ->ₛ "link") <> 0) ” 
  &&  “ (retval_3 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (0 < retval) ” 
  &&  “ (retval <= (UINT_MAX - sizeof( "Mutex" ) )) ” 
  &&  “ (addr_aligned retval 4 ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical ) ”
  &&  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical (replace_mutexes ((mutex_publish (retval) (retval_2) ((os_mutexes (st_lock))))) (st_lock)) )
.

Definition _MutexCreate_partial_solve_wit_15 := _MutexCreate_partial_solve_wit_15_pure -> _MutexCreate_partial_solve_wit_15_aux.

Definition _MutexCreate_which_implies_wit_1 := 
(
forall (mutex: Z) (PreH1 : (0 < mutex)) (PreH2 : (mutex <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH3 : (addr_aligned mutex 4 )) ,
  (CharArray.full mutex sizeof( "Mutex" ) (repeat_Z (0) (sizeof( "Mutex" ))) )
|--
  “ (mutex <> 0) ” 
  &&  “ (addr_aligned mutex 4 ) ” 
  &&  “ (&((mutex)  # "Mutex" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((mutex)  # "Mutex" ->ₛ "link") <> 0) ”
  &&  (MutexZero mutex )
) \/
(
forall (mutex: Z) (PreH1 : (0 < mutex)) (PreH2 : (mutex <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH3 : (addr_aligned mutex 4 )) ,
  (CharArray.full mutex sizeof( "Mutex" ) (repeat_Z (0) (sizeof( "Mutex" ))) )
|--
  “ (&((mutex)  # "Mutex" ->ₛ "link") <> 0) ” 
  &&  “ (&((mutex)  # "Mutex" ->ₛ "pend_list") <> 0) ”
  &&  (MutexZero mutex )
).

Definition _MutexCreate_which_implies_wit_1_split_goal_1 := 
forall (mutex: Z) (PreH1 : (0 < mutex)) (PreH2 : (mutex <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH3 : (addr_aligned mutex 4 )) ,
  (CharArray.full mutex sizeof( "Mutex" ) (repeat_Z (0) (sizeof( "Mutex" ))) )
|--
  “ (&((mutex)  # "Mutex" ->ₛ "link") <> 0) ”
.

Definition _MutexCreate_which_implies_wit_1_split_goal_2 := 
forall (mutex: Z) (PreH1 : (0 < mutex)) (PreH2 : (mutex <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH3 : (addr_aligned mutex 4 )) ,
  (CharArray.full mutex sizeof( "Mutex" ) (repeat_Z (0) (sizeof( "Mutex" ))) )
|--
  “ (&((mutex)  # "Mutex" ->ₛ "pend_list") <> 0) ”
.

Definition _MutexCreate_which_implies_wit_1_split_goal_spatial := 
forall (mutex: Z) (PreH1 : (0 < mutex)) (PreH2 : (mutex <= (UINT_MAX - sizeof( "Mutex" ) ))) (PreH3 : (addr_aligned mutex 4 )) ,
  (CharArray.full mutex sizeof( "Mutex" ) (repeat_Z (0) (sizeof( "Mutex" ))) )
|--
  (MutexZero mutex )
.

Definition _MutexCreate_which_implies_wit_2 := 
(
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (mutex: Z) ,
  (os_inv sg_outside_critical st_lock )
  **  (MutexZero mutex )
|--
  “ (mutex <> 0) ” 
  &&  “ (addr_aligned mutex 4 ) ” 
  &&  “ (mutex_context (os_mutex_stable (sg_outside_critical)) ) ” 
  &&  “ ~((In mutex (map (mutex_addr) ((os_mutexes (st_lock)))) )) ”
  &&  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  (store_idnode_insert_ready &((mutex)  # "Mutex" ->ₛ "id") )
  **  ((&((mutex)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((mutex)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((mutex)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding mutex )
) \/
(
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (mutex: Z) ,
  (os_inv sg_outside_critical st_lock )
  **  (MutexZero mutex )
|--
  “ ~((In mutex (map (mutex_addr) ((os_mutexes (st_lock)))) )) ” 
  &&  “ (mutex_context (os_mutex_stable (sg_outside_critical)) ) ” 
  &&  “ (addr_aligned mutex 4 ) ” 
  &&  “ (mutex <> 0) ”
  &&  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  (store_idnode_insert_ready &((mutex)  # "Mutex" ->ₛ "id") )
  **  ((&((mutex)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((mutex)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((mutex)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding mutex )
).

Definition _MutexCreate_which_implies_wit_2_split_goal_1 := 
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (mutex: Z) ,
  (os_inv sg_outside_critical st_lock )
  **  (MutexZero mutex )
|--
  “ ~((In mutex (map (mutex_addr) ((os_mutexes (st_lock)))) )) ”
.

Definition _MutexCreate_which_implies_wit_2_split_goal_2 := 
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (mutex: Z) ,
  (os_inv sg_outside_critical st_lock )
  **  (MutexZero mutex )
|--
  “ (mutex_context (os_mutex_stable (sg_outside_critical)) ) ”
.

Definition _MutexCreate_which_implies_wit_2_split_goal_3 := 
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (mutex: Z) ,
  (os_inv sg_outside_critical st_lock )
  **  (MutexZero mutex )
|--
  “ (addr_aligned mutex 4 ) ”
.

Definition _MutexCreate_which_implies_wit_2_split_goal_4 := 
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (mutex: Z) ,
  (os_inv sg_outside_critical st_lock )
  **  (MutexZero mutex )
|--
  “ (mutex <> 0) ”
.

Definition _MutexCreate_which_implies_wit_2_split_goal_spatial := 
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (mutex: Z) ,
  (os_inv sg_outside_critical st_lock )
  **  (MutexZero mutex )
|--
  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  (store_idnode_insert_ready &((mutex)  # "Mutex" ->ₛ "id") )
  **  ((&((mutex)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((mutex)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((mutex)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding mutex )
.

Definition _MutexCreate_which_implies_wit_3 := 
(
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (mutex: Z) (PreH1 : (mutex <> 0)) (PreH2 : (addr_aligned mutex 4 )) (PreH3 : (&((mutex)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH4 : (&((mutex)  # "Mutex" ->ₛ "link") <> 0)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) (PreH6 : (Crtos_RTrans before_outside_critical st_lock )) ,
  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  (store_idnode_insert_ready &((mutex)  # "Mutex" ->ₛ "id") )
  **  ((&((mutex)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((mutex)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((mutex)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding mutex )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  ((-5))) X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock st_lock ) ”
  &&  (os_inv sg_outside_critical st_lock )
  **  (MutexRaw mutex )
) \/
(
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (mutex: Z) (PreH1 : (mutex <> 0)) (PreH2 : (addr_aligned mutex 4 )) (PreH3 : (&((mutex)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH4 : (&((mutex)  # "Mutex" ->ₛ "link") <> 0)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) (PreH6 : (Crtos_RTrans before_outside_critical st_lock )) ,
  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  (store_idnode_insert_ready &((mutex)  # "Mutex" ->ₛ "id") )
  **  ((&((mutex)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((mutex)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((mutex)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding mutex )
|--
  “ (Crtos_GTrans st_lock st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  ((-5))) X_outside_critical ) ”
  &&  (os_inv sg_outside_critical st_lock )
  **  (MutexRaw mutex )
).

Definition _MutexCreate_which_implies_wit_3_split_goal_1 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (mutex: Z) (PreH1 : (mutex <> 0)) (PreH2 : (addr_aligned mutex 4 )) (PreH3 : (&((mutex)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH4 : (&((mutex)  # "Mutex" ->ₛ "link") <> 0)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) (PreH6 : (Crtos_RTrans before_outside_critical st_lock )) ,
  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  (store_idnode_insert_ready &((mutex)  # "Mutex" ->ₛ "id") )
  **  ((&((mutex)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((mutex)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((mutex)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding mutex )
|--
  “ (Crtos_GTrans st_lock st_lock ) ”
.

Definition _MutexCreate_which_implies_wit_3_split_goal_2 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (mutex: Z) (PreH1 : (mutex <> 0)) (PreH2 : (addr_aligned mutex 4 )) (PreH3 : (&((mutex)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH4 : (&((mutex)  # "Mutex" ->ₛ "link") <> 0)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) (PreH6 : (Crtos_RTrans before_outside_critical st_lock )) ,
  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  (store_idnode_insert_ready &((mutex)  # "Mutex" ->ₛ "id") )
  **  ((&((mutex)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((mutex)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((mutex)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding mutex )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  ((-5))) X_outside_critical ) ”
.

Definition _MutexCreate_which_implies_wit_3_split_goal_spatial := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (mutex: Z) (PreH1 : (mutex <> 0)) (PreH2 : (addr_aligned mutex 4 )) (PreH3 : (&((mutex)  # "Mutex" ->ₛ "pend_list") <> 0)) (PreH4 : (&((mutex)  # "Mutex" ->ₛ "link") <> 0)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) (PreH6 : (Crtos_RTrans before_outside_critical st_lock )) ,
  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (map (mutex_link_node) ((os_mutexes (st_lock)))) )
  **  (store_idnode_insert_ready &((mutex)  # "Mutex" ->ₛ "id") )
  **  ((&((mutex)  # "Mutex" ->ₛ "val")) # UShort  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (NodeZero &((mutex)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((mutex)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding mutex )
|--
  (os_inv sg_outside_critical st_lock )
  **  (MutexRaw mutex )
.

Definition _MutexCreate_which_implies_wit_4 := 
(
forall (mutex: Z) ,
  (NodeZero &((mutex)  # "Mutex" ->ₛ "pend_list") )
|--
  ((&((mutex)  # "Mutex" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((mutex)  # "Mutex" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |->_)
) \/
(
forall (mutex: Z) ,
  (NodeZero &((mutex)  # "Mutex" ->ₛ "pend_list") )
|--
  EX (x_2: Z)  (x: Z) ,
  ((&((mutex)  # "Mutex" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |-> x_2)
  **  ((&((mutex)  # "Mutex" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |-> x)
).

Definition _MutexCreate_which_implies_wit_5 := 
(
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (mutex: Z) (id: Z) (PreH1 : (mutex <> 0)) (PreH2 : (addr_aligned mutex 4 )) (PreH3 : (&((mutex)  # "Mutex" ->ₛ "link") <> 0)) (PreH4 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) id )) ,
  ((&((mutex)  # "Mutex" ->ₛ "val")) # UShort  |-> 1)
  **  ((&((mutex)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 255)
  **  ((&((mutex)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (store_node_self_linked &((mutex)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((mutex)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding mutex )
|--
  “ (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) id ) ”
  &&  (store_mutex (pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))) &((mutex)  # "Mutex" ->ₛ "link") (mutex_created (mutex) (id)) )
  **  (occupy_dll_node &((mutex)  # "Mutex" ->ₛ "link") )
) \/
(
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (mutex: Z) (id: Z) (PreH1 : (mutex <> 0)) (PreH2 : (addr_aligned mutex 4 )) (PreH3 : (&((mutex)  # "Mutex" ->ₛ "link") <> 0)) (PreH4 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) id )) ,
  ((&((mutex)  # "Mutex" ->ₛ "val")) # UShort  |-> 1)
  **  ((&((mutex)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 255)
  **  ((&((mutex)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (store_node_self_linked &((mutex)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((mutex)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding mutex )
|--
  (store_mutex (pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))) &((mutex)  # "Mutex" ->ₛ "link") (mutex_created (mutex) (id)) )
  **  (occupy_dll_node &((mutex)  # "Mutex" ->ₛ "link") )
).

Definition _MutexCreate_which_implies_wit_5_split_goal_spatial := 
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (mutex: Z) (id: Z) (PreH1 : (mutex <> 0)) (PreH2 : (addr_aligned mutex 4 )) (PreH3 : (&((mutex)  # "Mutex" ->ₛ "link") <> 0)) (PreH4 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) id )) ,
  ((&((mutex)  # "Mutex" ->ₛ "val")) # UShort  |-> 1)
  **  ((&((mutex)  # "Mutex" ->ₛ "recursive_cnt")) # UChar  |-> 0)
  **  ((&((mutex)  # "Mutex" ->ₛ "origin_prio")) # UChar  |-> 255)
  **  ((&((mutex)  # "Mutex" ->ₛ "holder")) # Ptr  |-> 0)
  **  (store_node_self_linked &((mutex)  # "Mutex" ->ₛ "pend_list") )
  **  (NodeZero &((mutex)  # "Mutex" ->ₛ "link") )
  **  (MutexPadding mutex )
|--
  (store_mutex (pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))) &((mutex)  # "Mutex" ->ₛ "link") (mutex_created (mutex) (id)) )
  **  (occupy_dll_node &((mutex)  # "Mutex" ->ₛ "link") )
.

Definition _MutexCreate_which_implies_wit_6 := 
(
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (mutex: Z) (id: Z) (PreH1 : (mutex <> 0)) (PreH2 : (addr_aligned mutex 4 )) (PreH3 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH4 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) id )) (PreH5 : ~((In mutex (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) (PreH7 : (Crtos_RTrans before_outside_critical st_lock )) ,
  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (id))) (id) (&((mutex)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (dll_insert_after_dispatch (( &( "k_mutex_list" ) )) ((map (mutex_link_node) ((os_mutexes (st_lock))))) (( &( "k_mutex_list" ) )) ((Build_DL_Node ((mutex_created (mutex) (id))) (&((mutex)  # "Mutex" ->ₛ "link"))))) )
|--
  “ (0 <= id) ” 
  &&  “ (id < 128) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen ((replace_mutexes ((mutex_publish (mutex) (id) ((os_mutexes (st_lock))))) (st_lock)))) ( MonadErr.ret  (id)) X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock (replace_mutexes ((mutex_publish (mutex) (id) ((os_mutexes (st_lock))))) (st_lock)) ) ”
  &&  (os_inv sg_outside_critical (replace_mutexes ((mutex_publish (mutex) (id) ((os_mutexes (st_lock))))) (st_lock)) )
) \/
(
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (mutex: Z) (id: Z) (PreH1 : (mutex <> 0)) (PreH2 : (addr_aligned mutex 4 )) (PreH3 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH4 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) id )) (PreH5 : ~((In mutex (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) (PreH7 : (Crtos_RTrans before_outside_critical st_lock )) ,
  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (id))) (id) (&((mutex)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (dll_insert_after_dispatch (( &( "k_mutex_list" ) )) ((map (mutex_link_node) ((os_mutexes (st_lock))))) (( &( "k_mutex_list" ) )) ((Build_DL_Node ((mutex_created (mutex) (id))) (&((mutex)  # "Mutex" ->ₛ "link"))))) )
|--
  “ (Crtos_GTrans st_lock (replace_mutexes ((mutex_publish (mutex) (id) ((os_mutexes (st_lock))))) (st_lock)) ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen ((replace_mutexes ((mutex_publish (mutex) (id) ((os_mutexes (st_lock))))) (st_lock)))) ( MonadErr.ret  (id)) X_outside_critical ) ” 
  &&  “ (id < 128) ” 
  &&  “ (0 <= id) ”
  &&  (os_inv sg_outside_critical (replace_mutexes ((mutex_publish (mutex) (id) ((os_mutexes (st_lock))))) (st_lock)) )
).

Definition _MutexCreate_which_implies_wit_6_split_goal_1 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (mutex: Z) (id: Z) (PreH1 : (mutex <> 0)) (PreH2 : (addr_aligned mutex 4 )) (PreH3 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH4 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) id )) (PreH5 : ~((In mutex (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) (PreH7 : (Crtos_RTrans before_outside_critical st_lock )) ,
  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (id))) (id) (&((mutex)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (dll_insert_after_dispatch (( &( "k_mutex_list" ) )) ((map (mutex_link_node) ((os_mutexes (st_lock))))) (( &( "k_mutex_list" ) )) ((Build_DL_Node ((mutex_created (mutex) (id))) (&((mutex)  # "Mutex" ->ₛ "link"))))) )
|--
  “ (Crtos_GTrans st_lock (replace_mutexes ((mutex_publish (mutex) (id) ((os_mutexes (st_lock))))) (st_lock)) ) ”
.

Definition _MutexCreate_which_implies_wit_6_split_goal_2 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (mutex: Z) (id: Z) (PreH1 : (mutex <> 0)) (PreH2 : (addr_aligned mutex 4 )) (PreH3 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH4 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) id )) (PreH5 : ~((In mutex (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) (PreH7 : (Crtos_RTrans before_outside_critical st_lock )) ,
  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (id))) (id) (&((mutex)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (dll_insert_after_dispatch (( &( "k_mutex_list" ) )) ((map (mutex_link_node) ((os_mutexes (st_lock))))) (( &( "k_mutex_list" ) )) ((Build_DL_Node ((mutex_created (mutex) (id))) (&((mutex)  # "Mutex" ->ₛ "link"))))) )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen ((replace_mutexes ((mutex_publish (mutex) (id) ((os_mutexes (st_lock))))) (st_lock)))) ( MonadErr.ret  (id)) X_outside_critical ) ”
.

Definition _MutexCreate_which_implies_wit_6_split_goal_3 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (mutex: Z) (id: Z) (PreH1 : (mutex <> 0)) (PreH2 : (addr_aligned mutex 4 )) (PreH3 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH4 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) id )) (PreH5 : ~((In mutex (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) (PreH7 : (Crtos_RTrans before_outside_critical st_lock )) ,
  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (id))) (id) (&((mutex)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (dll_insert_after_dispatch (( &( "k_mutex_list" ) )) ((map (mutex_link_node) ((os_mutexes (st_lock))))) (( &( "k_mutex_list" ) )) ((Build_DL_Node ((mutex_created (mutex) (id))) (&((mutex)  # "Mutex" ->ₛ "link"))))) )
|--
  “ (id < 128) ”
.

Definition _MutexCreate_which_implies_wit_6_split_goal_4 := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (mutex: Z) (id: Z) (PreH1 : (mutex <> 0)) (PreH2 : (addr_aligned mutex 4 )) (PreH3 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH4 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) id )) (PreH5 : ~((In mutex (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) (PreH7 : (Crtos_RTrans before_outside_critical st_lock )) ,
  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (id))) (id) (&((mutex)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (dll_insert_after_dispatch (( &( "k_mutex_list" ) )) ((map (mutex_link_node) ((os_mutexes (st_lock))))) (( &( "k_mutex_list" ) )) ((Build_DL_Node ((mutex_created (mutex) (id))) (&((mutex)  # "Mutex" ->ₛ "link"))))) )
|--
  “ (0 <= id) ”
.

Definition _MutexCreate_which_implies_wit_6_split_goal_spatial := 
forall (X_outside_critical: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (mutex: Z) (id: Z) (PreH1 : (mutex <> 0)) (PreH2 : (addr_aligned mutex 4 )) (PreH3 : (mutex_context (os_mutex_stable (sg_outside_critical)) )) (PreH4 : (idmanager_min_free_id (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (mutex_manager ((os_mutexes (st_lock)))) id )) (PreH5 : ~((In mutex (map (mutex_addr) ((os_mutexes (st_lock)))) ))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_mutex_create (sg_outside_critical)) X_outside_critical )) (PreH7 : (Crtos_RTrans before_outside_critical st_lock )) ,
  (mutex_create_frame sg_outside_critical st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_outside_critical)))) (idmanager_link ((mutex_manager_stable ((os_mutex_stable (sg_outside_critical))))) ((idmanager_add ((mutex_manager ((os_mutexes (st_lock))))) (id))) (id) (&((mutex)  # "Mutex" ->ₛ "id"))) ( &( "k_mutex_id_manager" ) ) )
  **  (store_dll (store_mutex ((pure_suspend_sched_link ((task_desc_map ((os_tasks (st_lock)))))))) ( &( "k_mutex_list" ) ) (dll_insert_after_dispatch (( &( "k_mutex_list" ) )) ((map (mutex_link_node) ((os_mutexes (st_lock))))) (( &( "k_mutex_list" ) )) ((Build_DL_Node ((mutex_created (mutex) (id))) (&((mutex)  # "Mutex" ->ₛ "link"))))) )
|--
  (os_inv sg_outside_critical (replace_mutexes ((mutex_publish (mutex) (id) ((os_mutexes (st_lock))))) (st_lock)) )
.

Module Type VC_Correct.


Axiom proof_of__MutexCreate_safety_wit_1 : _MutexCreate_safety_wit_1.
Axiom proof_of__MutexCreate_safety_wit_2 : _MutexCreate_safety_wit_2.
Axiom proof_of__MutexCreate_safety_wit_3 : _MutexCreate_safety_wit_3.
Axiom proof_of__MutexCreate_safety_wit_4 : _MutexCreate_safety_wit_4.
Axiom proof_of__MutexCreate_safety_wit_5 : _MutexCreate_safety_wit_5.
Axiom proof_of__MutexCreate_safety_wit_6 : _MutexCreate_safety_wit_6.
Axiom proof_of__MutexCreate_safety_wit_7 : _MutexCreate_safety_wit_7.
Axiom proof_of__MutexCreate_safety_wit_8 : _MutexCreate_safety_wit_8.
Axiom proof_of__MutexCreate_safety_wit_9 : _MutexCreate_safety_wit_9.
Axiom proof_of__MutexCreate_safety_wit_10 : _MutexCreate_safety_wit_10.
Axiom proof_of__MutexCreate_safety_wit_11 : _MutexCreate_safety_wit_11.
Axiom proof_of__MutexCreate_safety_wit_12 : _MutexCreate_safety_wit_12.
Axiom proof_of__MutexCreate_safety_wit_13 : _MutexCreate_safety_wit_13.
Axiom proof_of__MutexCreate_safety_wit_14 : _MutexCreate_safety_wit_14.
Axiom proof_of__MutexCreate_safety_wit_15 : _MutexCreate_safety_wit_15.
Axiom proof_of__MutexCreate_safety_wit_16 : _MutexCreate_safety_wit_16.
Axiom proof_of__MutexCreate_safety_wit_17 : _MutexCreate_safety_wit_17.
Axiom proof_of__MutexCreate_safety_wit_18 : _MutexCreate_safety_wit_18.
Axiom proof_of__MutexCreate_safety_wit_19 : _MutexCreate_safety_wit_19.
Axiom proof_of__MutexCreate_safety_wit_20 : _MutexCreate_safety_wit_20.
Axiom proof_of__MutexCreate_entail_wit_1_1 : _MutexCreate_entail_wit_1_1.
Axiom proof_of__MutexCreate_entail_wit_1_2 : _MutexCreate_entail_wit_1_2.
Axiom proof_of__MutexCreate_return_wit_1 : _MutexCreate_return_wit_1.
Axiom proof_of__MutexCreate_return_wit_2 : _MutexCreate_return_wit_2.
Axiom proof_of__MutexCreate_return_wit_3 : _MutexCreate_return_wit_3.
Axiom proof_of__MutexCreate_partial_solve_wit_1_pure : _MutexCreate_partial_solve_wit_1_pure.
Axiom proof_of__MutexCreate_partial_solve_wit_1 : _MutexCreate_partial_solve_wit_1.
Axiom proof_of__MutexCreate_partial_solve_wit_2_pure : _MutexCreate_partial_solve_wit_2_pure.
Axiom proof_of__MutexCreate_partial_solve_wit_2 : _MutexCreate_partial_solve_wit_2.
Axiom proof_of__MutexCreate_partial_solve_wit_3_pure : _MutexCreate_partial_solve_wit_3_pure.
Axiom proof_of__MutexCreate_partial_solve_wit_3 : _MutexCreate_partial_solve_wit_3.
Axiom proof_of__MutexCreate_partial_solve_wit_4 : _MutexCreate_partial_solve_wit_4.
Axiom proof_of__MutexCreate_partial_solve_wit_5 : _MutexCreate_partial_solve_wit_5.
Axiom proof_of__MutexCreate_partial_solve_wit_6 : _MutexCreate_partial_solve_wit_6.
Axiom proof_of__MutexCreate_partial_solve_wit_7_pure : _MutexCreate_partial_solve_wit_7_pure.
Axiom proof_of__MutexCreate_partial_solve_wit_7 : _MutexCreate_partial_solve_wit_7.
Axiom proof_of__MutexCreate_partial_solve_wit_8_pure : _MutexCreate_partial_solve_wit_8_pure.
Axiom proof_of__MutexCreate_partial_solve_wit_8 : _MutexCreate_partial_solve_wit_8.
Axiom proof_of__MutexCreate_partial_solve_wit_9 : _MutexCreate_partial_solve_wit_9.
Axiom proof_of__MutexCreate_partial_solve_wit_10 : _MutexCreate_partial_solve_wit_10.
Axiom proof_of__MutexCreate_partial_solve_wit_11 : _MutexCreate_partial_solve_wit_11.
Axiom proof_of__MutexCreate_partial_solve_wit_12_pure : _MutexCreate_partial_solve_wit_12_pure.
Axiom proof_of__MutexCreate_partial_solve_wit_12 : _MutexCreate_partial_solve_wit_12.
Axiom proof_of__MutexCreate_partial_solve_wit_13_pure : _MutexCreate_partial_solve_wit_13_pure.
Axiom proof_of__MutexCreate_partial_solve_wit_13 : _MutexCreate_partial_solve_wit_13.
Axiom proof_of__MutexCreate_partial_solve_wit_14_pure : _MutexCreate_partial_solve_wit_14_pure.
Axiom proof_of__MutexCreate_partial_solve_wit_14 : _MutexCreate_partial_solve_wit_14.
Axiom proof_of__MutexCreate_partial_solve_wit_15_pure : _MutexCreate_partial_solve_wit_15_pure.
Axiom proof_of__MutexCreate_partial_solve_wit_15 : _MutexCreate_partial_solve_wit_15.
Axiom proof_of__MutexCreate_which_implies_wit_1 : _MutexCreate_which_implies_wit_1.
Axiom proof_of__MutexCreate_which_implies_wit_2 : _MutexCreate_which_implies_wit_2.
Axiom proof_of__MutexCreate_which_implies_wit_3 : _MutexCreate_which_implies_wit_3.
Axiom proof_of__MutexCreate_which_implies_wit_4 : _MutexCreate_which_implies_wit_4.
Axiom proof_of__MutexCreate_which_implies_wit_5 : _MutexCreate_which_implies_wit_5.
Axiom proof_of__MutexCreate_which_implies_wit_6 : _MutexCreate_which_implies_wit_6.

End VC_Correct.
