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
Import IDNode DLL.
From MonadLib.MonadErr
      Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.VC.SemaphoreCreate_lib.
Local Open Scope sac.

(*----- Function _SemaphoreCreate -----*)

Definition _SemaphoreCreate_safety_wit_1 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  ((( &( "id" ) )) # Int  |->_)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (OutsideCritical sg before )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_2 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  ((( &( "lock" ) )) # Int  |->_)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (OutsideCritical sg before )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_3 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  ((( &( "sem" ) )) # Ptr  |->_)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (OutsideCritical sg before )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_4 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (OutsideCritical sg before )
|--
  “ (32 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 32) ”
.

Definition _SemaphoreCreate_safety_wit_5 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (0 <= val_pre)) (PreH3 : (val_pre <= 65535)) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (OutsideCritical sg before )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_6 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (0 <= val_pre)) (PreH3 : (val_pre <= 65535)) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  (SemaphoreRaw retval )
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (OutsideCritical sg before )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_7 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (retval = 0)) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (OutsideCritical sg before )
|--
  “ False ”
.

Definition _SemaphoreCreate_safety_wit_8 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval <> 0)) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  (SemaphoreRaw retval )
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (OutsideCritical sg before )
|--
  “ False ”
.

Definition _SemaphoreCreate_safety_wit_9 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (OutsideCritical sg before )
|--
  “ (5 <> (INT_MIN)) ”
.

Definition _SemaphoreCreate_safety_wit_10 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (OutsideCritical sg before )
|--
  “ (5 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 5) ”
.

Definition _SemaphoreCreate_safety_wit_11 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (sem: Z) (id: Z) (lock: Z) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : (sem <> 0)) (PreH4 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH5 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH6 : (id = 0)) (PreH7 : (lock = 0)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  (OutsideCritical sg before )
  **  (SemaphoreRaw sem )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_12 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (sem: Z) (id: Z) (lock: Z) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : (sem <> 0)) (PreH4 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH5 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH6 : (id = 0)) (PreH7 : (lock = 0)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  (OutsideCritical sg before )
  **  (SemaphoreRaw sem )
|--
  “ (32 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 32) ”
.

Definition _SemaphoreCreate_safety_wit_13 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (saved_lock: Z) (sem: Z) (id: Z) (retval: Z) (PreH1 : (retval = (-1))) (PreH2 : (idmanager_full (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) )) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : (sem <> 0)) (PreH6 : (addr_aligned sem 4 )) (PreH7 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH8 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH9 : (Crtos_RTrans before locked )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH11 : (id = 0)) (PreH12 : (os_world_wf sg locked )) (PreH13 : (semaphore_context (os_semaphore_stable (sg)) )) (PreH14 : (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) )) (PreH15 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) ( &( "k_sem_id_manager" ) ) )
  **  (ZeroIdNode &((sem)  # "Semaphore" ->ₛ "id") )
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_14 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (saved_lock: Z) (sem: Z) (id: Z) (retval: Z) (PreH1 : (0 <= retval)) (PreH2 : (retval < ((semaphore_manager_stable ((os_semaphore_stable (sg)))).(idmax) ))) (PreH3 : (idmanager_min_free_id (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) retval )) (PreH4 : (0 <= val_pre)) (PreH5 : (val_pre <= 65535)) (PreH6 : (sem <> 0)) (PreH7 : (addr_aligned sem 4 )) (PreH8 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH10 : (Crtos_RTrans before locked )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH12 : (id = 0)) (PreH13 : (os_world_wf sg locked )) (PreH14 : (semaphore_context (os_semaphore_stable (sg)) )) (PreH15 : (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) )) (PreH16 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (idmanager_link ((semaphore_manager_stable ((os_semaphore_stable (sg))))) ((idmanager_add ((semaphore_manager ((os_semaphores (locked))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_15 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (saved_lock: Z) (sem: Z) (id: Z) (retval: Z) (PreH1 : (retval >= 0)) (PreH2 : (retval = (-1))) (PreH3 : (idmanager_full (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) )) (PreH4 : (0 <= val_pre)) (PreH5 : (val_pre <= 65535)) (PreH6 : (sem <> 0)) (PreH7 : (addr_aligned sem 4 )) (PreH8 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH10 : (Crtos_RTrans before locked )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH12 : (id = 0)) (PreH13 : (os_world_wf sg locked )) (PreH14 : (semaphore_context (os_semaphore_stable (sg)) )) (PreH15 : (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) )) (PreH16 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) ( &( "k_sem_id_manager" ) ) )
  **  (ZeroIdNode &((sem)  # "Semaphore" ->ₛ "id") )
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  “ False ”
.

Definition _SemaphoreCreate_safety_wit_16 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (saved_lock: Z) (sem: Z) (id: Z) (retval: Z) (PreH1 : (retval < 0)) (PreH2 : (0 <= retval)) (PreH3 : (retval < ((semaphore_manager_stable ((os_semaphore_stable (sg)))).(idmax) ))) (PreH4 : (idmanager_min_free_id (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) retval )) (PreH5 : (0 <= val_pre)) (PreH6 : (val_pre <= 65535)) (PreH7 : (sem <> 0)) (PreH8 : (addr_aligned sem 4 )) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH10 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH11 : (Crtos_RTrans before locked )) (PreH12 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH13 : (id = 0)) (PreH14 : (os_world_wf sg locked )) (PreH15 : (semaphore_context (os_semaphore_stable (sg)) )) (PreH16 : (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) )) (PreH17 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (idmanager_link ((semaphore_manager_stable ((os_semaphore_stable (sg))))) ((idmanager_add ((semaphore_manager ((os_semaphores (locked))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  “ False ”
.

Definition _SemaphoreCreate_safety_wit_17 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (saved_lock: Z) (sem: Z) (id: Z) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : (sem <> 0)) (PreH4 : (addr_aligned sem 4 )) (PreH5 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH7 : (Crtos_RTrans before locked )) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH9 : (id = (-1))) (PreH10 : (idmanager_full (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) )) ,
  (OutsideCritical sg locked )
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "id" ) )) # Int  |-> id)
|--
  “ (5 <> (INT_MIN)) ”
.

Definition _SemaphoreCreate_safety_wit_18 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (saved_lock: Z) (sem: Z) (id: Z) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : (sem <> 0)) (PreH4 : (addr_aligned sem 4 )) (PreH5 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH7 : (Crtos_RTrans before locked )) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH9 : (id = (-1))) (PreH10 : (idmanager_full (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) )) ,
  (OutsideCritical sg locked )
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "id" ) )) # Int  |-> id)
|--
  “ (5 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 5) ”
.

Definition _SemaphoreCreate_entail_wit_1 := 
(
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (OutsideCritical sg before )
|--
  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X ) ”
  &&  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (OutsideCritical sg before )
) \/
(
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  TT && emp 
|--
  “ (val_pre <= 65535) ” 
  &&  “ (0 <= val_pre) ”
  &&  emp
).

Definition _SemaphoreCreate_entail_wit_1_split_goal_1 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  (val_pre <= 65535)
.

Definition _SemaphoreCreate_entail_wit_1_split_goal_2 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  (0 <= val_pre)
.

Definition _SemaphoreCreate_entail_wit_2 := 
(
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (retval <> 0)) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  (SemaphoreRaw retval )
  **  (OutsideCritical sg before )
|--
  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (&((retval)  # "Semaphore" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((retval)  # "Semaphore" ->ₛ "link") <> 0) ” 
  &&  “ (0 = 0) ” 
  &&  “ (0 = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X ) ”
  &&  (OutsideCritical sg before )
  **  (SemaphoreRaw retval )
) \/
(
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (retval <> 0)) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  TT && emp 
|--
  “ (&((retval)  # "Semaphore" ->ₛ "link") <> 0) ” 
  &&  “ (&((retval)  # "Semaphore" ->ₛ "pend_list") <> 0) ”
  &&  emp
).

Definition _SemaphoreCreate_entail_wit_2_split_goal_1 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (retval <> 0)) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  (&((retval)  # "Semaphore" ->ₛ "link") <> 0)
.

Definition _SemaphoreCreate_entail_wit_2_split_goal_2 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (retval <> 0)) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  (&((retval)  # "Semaphore" ->ₛ "pend_list") <> 0)
.

Definition _SemaphoreCreate_entail_wit_3 := 
(
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (sem: Z) (id: Z) (lock: Z) (retval: Z) (locked: VarGlobalState) (PreH1 : (Crtos_RTrans before locked )) (PreH2 : (retval = sem)) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : (sem <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH7 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH8 : (id = 0)) (PreH9 : (lock = 0)) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  (InsideCritical sg locked )
  **  (os_inv sg locked )
  **  (SemaphoreZero sem )
|--
  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (addr_aligned sem 4 ) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ” 
  &&  “ (Crtos_RTrans before locked ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X ) ” 
  &&  “ (id = 0) ” 
  &&  “ (os_world_wf sg locked ) ” 
  &&  “ (semaphore_context (os_semaphore_stable (sg)) ) ” 
  &&  “ (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) ) ” 
  &&  “ ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) )) ”
  &&  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) ( &( "k_sem_id_manager" ) ) )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  (ZeroIdNode &((sem)  # "Semaphore" ->ₛ "id") )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
) \/
(
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (sem: Z) (id: Z) (lock: Z) (retval: Z) (locked: VarGlobalState) (PreH1 : (Crtos_RTrans before locked )) (PreH2 : (retval = sem)) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : (sem <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH7 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH8 : (id = 0)) (PreH9 : (lock = 0)) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  (InsideCritical sg locked )
  **  (os_inv sg locked )
  **  (SemaphoreZero sem )
|--
  “ ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) )) ” 
  &&  “ (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) ) ” 
  &&  “ (semaphore_context (os_semaphore_stable (sg)) ) ” 
  &&  “ (os_world_wf sg locked ) ” 
  &&  “ (addr_aligned sem 4 ) ”
  &&  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) ( &( "k_sem_id_manager" ) ) )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  (ZeroIdNode &((sem)  # "Semaphore" ->ₛ "id") )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
).

Definition _SemaphoreCreate_entail_wit_3_split_goal_1 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (sem: Z) (id: Z) (lock: Z) (retval: Z) (locked: VarGlobalState) (PreH1 : (Crtos_RTrans before locked )) (PreH2 : (retval = sem)) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : (sem <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH7 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH8 : (id = 0)) (PreH9 : (lock = 0)) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  (InsideCritical sg locked )
  **  (os_inv sg locked )
  **  (SemaphoreZero sem )
|--
  “ ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) )) ”
.

Definition _SemaphoreCreate_entail_wit_3_split_goal_2 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (sem: Z) (id: Z) (lock: Z) (retval: Z) (locked: VarGlobalState) (PreH1 : (Crtos_RTrans before locked )) (PreH2 : (retval = sem)) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : (sem <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH7 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH8 : (id = 0)) (PreH9 : (lock = 0)) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  (InsideCritical sg locked )
  **  (os_inv sg locked )
  **  (SemaphoreZero sem )
|--
  “ (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) ) ”
.

Definition _SemaphoreCreate_entail_wit_3_split_goal_3 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (sem: Z) (id: Z) (lock: Z) (retval: Z) (locked: VarGlobalState) (PreH1 : (Crtos_RTrans before locked )) (PreH2 : (retval = sem)) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : (sem <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH7 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH8 : (id = 0)) (PreH9 : (lock = 0)) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  (InsideCritical sg locked )
  **  (os_inv sg locked )
  **  (SemaphoreZero sem )
|--
  “ (semaphore_context (os_semaphore_stable (sg)) ) ”
.

Definition _SemaphoreCreate_entail_wit_3_split_goal_4 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (sem: Z) (id: Z) (lock: Z) (retval: Z) (locked: VarGlobalState) (PreH1 : (Crtos_RTrans before locked )) (PreH2 : (retval = sem)) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : (sem <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH7 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH8 : (id = 0)) (PreH9 : (lock = 0)) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  (InsideCritical sg locked )
  **  (os_inv sg locked )
  **  (SemaphoreZero sem )
|--
  “ (os_world_wf sg locked ) ”
.

Definition _SemaphoreCreate_entail_wit_3_split_goal_5 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (sem: Z) (id: Z) (lock: Z) (retval: Z) (locked: VarGlobalState) (PreH1 : (Crtos_RTrans before locked )) (PreH2 : (retval = sem)) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : (sem <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH7 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH8 : (id = 0)) (PreH9 : (lock = 0)) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  (InsideCritical sg locked )
  **  (os_inv sg locked )
  **  (SemaphoreZero sem )
|--
  “ (addr_aligned sem 4 ) ”
.

Definition _SemaphoreCreate_entail_wit_3_split_goal_spatial := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (sem: Z) (id: Z) (lock: Z) (retval: Z) (locked: VarGlobalState) (PreH1 : (Crtos_RTrans before locked )) (PreH2 : (retval = sem)) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : (sem <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH7 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH8 : (id = 0)) (PreH9 : (lock = 0)) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  (InsideCritical sg locked )
  **  (os_inv sg locked )
  **  (SemaphoreZero sem )
|--
  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) ( &( "k_sem_id_manager" ) ) )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  (ZeroIdNode &((sem)  # "Semaphore" ->ₛ "id") )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
.

Definition _SemaphoreCreate_entail_wit_4 := 
(
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (sem: Z) (id: Z) (retval: Z) (PreH1 : (retval < 0)) (PreH2 : (retval = (-1))) (PreH3 : (idmanager_full (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) )) (PreH4 : (0 <= val_pre)) (PreH5 : (val_pre <= 65535)) (PreH6 : (sem <> 0)) (PreH7 : (addr_aligned sem 4 )) (PreH8 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH10 : (Crtos_RTrans before locked )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH12 : (id = 0)) (PreH13 : (os_world_wf sg locked )) (PreH14 : (semaphore_context (os_semaphore_stable (sg)) )) (PreH15 : (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) )) (PreH16 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) ( &( "k_sem_id_manager" ) ) )
  **  (ZeroIdNode &((sem)  # "Semaphore" ->ₛ "id") )
  **  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (addr_aligned sem 4 ) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ” 
  &&  “ (Crtos_RTrans before locked ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X ) ” 
  &&  “ (retval = (-1)) ” 
  &&  “ (idmanager_full (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) ) ”
  &&  (InsideCritical sg locked )
  **  (os_inv sg locked )
  **  (SemaphoreZero sem )
) \/
(
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (sem: Z) (id: Z) (retval: Z) (PreH1 : ((role_id ((os_recycle (locked)))) <= INT_MAX)) (PreH2 : ((role_id ((os_recycle (locked)))) >= INT_MIN)) (PreH3 : (retval < 0)) (PreH4 : (retval = (-1))) (PreH5 : (idmanager_full (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) )) (PreH6 : (0 <= val_pre)) (PreH7 : (val_pre <= 65535)) (PreH8 : (sem <> 0)) (PreH9 : (addr_aligned sem 4 )) (PreH10 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH11 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH12 : (Crtos_RTrans before locked )) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH14 : (id = 0)) (PreH15 : (os_world_wf sg locked )) (PreH16 : (semaphore_context (os_semaphore_stable (sg)) )) (PreH17 : (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) )) (PreH18 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) ( &( "k_sem_id_manager" ) ) )
  **  (ZeroIdNode &((sem)  # "Semaphore" ->ₛ "id") )
  **  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  (InsideCritical sg locked )
  **  (os_inv sg locked )
  **  (SemaphoreZero sem )
).

Definition _SemaphoreCreate_entail_wit_4_split_goal_spatial := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (sem: Z) (id: Z) (retval: Z) (PreH1 : ((role_id ((os_recycle (locked)))) <= INT_MAX)) (PreH2 : ((role_id ((os_recycle (locked)))) >= INT_MIN)) (PreH3 : (retval < 0)) (PreH4 : (retval = (-1))) (PreH5 : (idmanager_full (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) )) (PreH6 : (0 <= val_pre)) (PreH7 : (val_pre <= 65535)) (PreH8 : (sem <> 0)) (PreH9 : (addr_aligned sem 4 )) (PreH10 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH11 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH12 : (Crtos_RTrans before locked )) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH14 : (id = 0)) (PreH15 : (os_world_wf sg locked )) (PreH16 : (semaphore_context (os_semaphore_stable (sg)) )) (PreH17 : (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) )) (PreH18 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) ( &( "k_sem_id_manager" ) ) )
  **  (ZeroIdNode &((sem)  # "Semaphore" ->ₛ "id") )
  **  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  (InsideCritical sg locked )
  **  (os_inv sg locked )
  **  (SemaphoreZero sem )
.

Definition _SemaphoreCreate_entail_wit_5 := 
(
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (sem: Z) (id: Z) (retval: Z) (PreH1 : (retval >= 0)) (PreH2 : (0 <= retval)) (PreH3 : (retval < ((semaphore_manager_stable ((os_semaphore_stable (sg)))).(idmax) ))) (PreH4 : (idmanager_min_free_id (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) retval )) (PreH5 : (0 <= val_pre)) (PreH6 : (val_pre <= 65535)) (PreH7 : (sem <> 0)) (PreH8 : (addr_aligned sem 4 )) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH10 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH11 : (Crtos_RTrans before locked )) (PreH12 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH13 : (id = 0)) (PreH14 : (os_world_wf sg locked )) (PreH15 : (semaphore_context (os_semaphore_stable (sg)) )) (PreH16 : (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) )) (PreH17 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (idmanager_link ((semaphore_manager_stable ((os_semaphore_stable (sg))))) ((idmanager_add ((semaphore_manager ((os_semaphores (locked))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (addr_aligned sem 4 ) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ” 
  &&  “ (Crtos_RTrans before locked ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X ) ” 
  &&  “ (0 <= retval) ” 
  &&  “ (retval < 128) ” 
  &&  “ (idmanager_min_free_id (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) retval ) ” 
  &&  “ (os_world_wf sg locked ) ” 
  &&  “ (semaphore_context (os_semaphore_stable (sg)) ) ” 
  &&  “ (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) ) ” 
  &&  “ ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) )) ”
  &&  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (idmanager_link ((semaphore_manager_stable ((os_semaphore_stable (sg))))) ((idmanager_add ((semaphore_manager ((os_semaphores (locked))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  (dllseg_shift_rev (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) (semaphore_first_link ((os_semaphore_stable (sg))) ((os_semaphores (locked)))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  (DllInsertAfterCut ( &( "k_sem_list" ) ) (semaphore_first_link ((os_semaphore_stable (sg))) ((os_semaphores (locked)))) &((sem)  # "Semaphore" ->ₛ "link") 0 0 )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (NodeStorage &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (SemaphorePadding sem )
) \/
(
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (sem: Z) (id: Z) (retval: Z) (PreH1 : (retval >= 0)) (PreH2 : (0 <= retval)) (PreH3 : (retval < ((semaphore_manager_stable ((os_semaphore_stable (sg)))).(idmax) ))) (PreH4 : (idmanager_min_free_id (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) retval )) (PreH5 : (0 <= val_pre)) (PreH6 : (val_pre <= 65535)) (PreH7 : (sem <> 0)) (PreH8 : (addr_aligned sem 4 )) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH10 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH11 : (Crtos_RTrans before locked )) (PreH12 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH13 : (id = 0)) (PreH14 : (os_world_wf sg locked )) (PreH15 : (semaphore_context (os_semaphore_stable (sg)) )) (PreH16 : (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) )) (PreH17 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (idmanager_link ((semaphore_manager_stable ((os_semaphore_stable (sg))))) ((idmanager_add ((semaphore_manager ((os_semaphores (locked))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  “ (retval < 128) ”
  &&  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (idmanager_link ((semaphore_manager_stable ((os_semaphore_stable (sg))))) ((idmanager_add ((semaphore_manager ((os_semaphores (locked))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  (dllseg_shift_rev (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) (semaphore_first_link ((os_semaphore_stable (sg))) ((os_semaphores (locked)))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  (DllInsertAfterCut ( &( "k_sem_list" ) ) (semaphore_first_link ((os_semaphore_stable (sg))) ((os_semaphores (locked)))) &((sem)  # "Semaphore" ->ₛ "link") 0 0 )
  **  (NodeStorage &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (SemaphorePadding sem )
).

Definition _SemaphoreCreate_entail_wit_5_split_goal_1 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (sem: Z) (id: Z) (retval: Z) (PreH1 : (retval >= 0)) (PreH2 : (0 <= retval)) (PreH3 : (retval < ((semaphore_manager_stable ((os_semaphore_stable (sg)))).(idmax) ))) (PreH4 : (idmanager_min_free_id (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) retval )) (PreH5 : (0 <= val_pre)) (PreH6 : (val_pre <= 65535)) (PreH7 : (sem <> 0)) (PreH8 : (addr_aligned sem 4 )) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH10 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH11 : (Crtos_RTrans before locked )) (PreH12 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH13 : (id = 0)) (PreH14 : (os_world_wf sg locked )) (PreH15 : (semaphore_context (os_semaphore_stable (sg)) )) (PreH16 : (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) )) (PreH17 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (idmanager_link ((semaphore_manager_stable ((os_semaphore_stable (sg))))) ((idmanager_add ((semaphore_manager ((os_semaphores (locked))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  “ (retval < 128) ”
.

Definition _SemaphoreCreate_entail_wit_5_split_goal_spatial := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (sem: Z) (id: Z) (retval: Z) (PreH1 : (retval >= 0)) (PreH2 : (0 <= retval)) (PreH3 : (retval < ((semaphore_manager_stable ((os_semaphore_stable (sg)))).(idmax) ))) (PreH4 : (idmanager_min_free_id (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) retval )) (PreH5 : (0 <= val_pre)) (PreH6 : (val_pre <= 65535)) (PreH7 : (sem <> 0)) (PreH8 : (addr_aligned sem 4 )) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH10 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH11 : (Crtos_RTrans before locked )) (PreH12 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH13 : (id = 0)) (PreH14 : (os_world_wf sg locked )) (PreH15 : (semaphore_context (os_semaphore_stable (sg)) )) (PreH16 : (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) )) (PreH17 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (idmanager_link ((semaphore_manager_stable ((os_semaphore_stable (sg))))) ((idmanager_add ((semaphore_manager ((os_semaphores (locked))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (idmanager_link ((semaphore_manager_stable ((os_semaphore_stable (sg))))) ((idmanager_add ((semaphore_manager ((os_semaphores (locked))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  (dllseg_shift_rev (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) (semaphore_first_link ((os_semaphore_stable (sg))) ((os_semaphores (locked)))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  (DllInsertAfterCut ( &( "k_sem_list" ) ) (semaphore_first_link ((os_semaphore_stable (sg))) ((os_semaphores (locked)))) &((sem)  # "Semaphore" ->ₛ "link") 0 0 )
  **  (NodeStorage &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (SemaphorePadding sem )
.

Definition _SemaphoreCreate_entail_wit_6 := 
(
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (sem: Z) (id: Z) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : (sem <> 0)) (PreH4 : (addr_aligned sem 4 )) (PreH5 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH7 : (Crtos_RTrans before locked )) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH9 : (0 <= id)) (PreH10 : (id < 128)) (PreH11 : (idmanager_min_free_id (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) id )) (PreH12 : (os_world_wf sg locked )) (PreH13 : (semaphore_context (os_semaphore_stable (sg)) )) (PreH14 : (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) )) (PreH15 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) ,
  (DllInsertedCut ( &( "k_sem_list" ) ) (semaphore_first_link ((os_semaphore_stable (sg))) ((os_semaphores (locked)))) &((sem)  # "Semaphore" ->ₛ "link") )
  **  (store_node_self_linked &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (idmanager_link ((semaphore_manager_stable ((os_semaphore_stable (sg))))) ((idmanager_add ((semaphore_manager ((os_semaphores (locked))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  (dllseg_shift_rev (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) (semaphore_first_link ((os_semaphore_stable (sg))) ((os_semaphores (locked)))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (SemaphorePadding sem )
|--
  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (addr_aligned sem 4 ) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ” 
  &&  “ (Crtos_RTrans before locked ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X ) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id < 128) ” 
  &&  “ (idmanager_min_free_id (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) id ) ” 
  &&  “ ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) )) ” 
  &&  “ (Crtos_GTrans locked (replace_semaphores ((semaphore_publish (sem) (id) (val_pre) ((os_semaphores (locked))))) (locked)) ) ”
  &&  (InsideCritical sg locked )
  **  (os_inv sg (replace_semaphores ((semaphore_publish (sem) (id) (val_pre) ((os_semaphores (locked))))) (locked)) )
) \/
(
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (sem: Z) (id: Z) (PreH1 : ((role_id ((os_recycle (locked)))) <= INT_MAX)) (PreH2 : ((role_id ((os_recycle (locked)))) >= INT_MIN)) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : (sem <> 0)) (PreH6 : (addr_aligned sem 4 )) (PreH7 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH8 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH9 : (Crtos_RTrans before locked )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH11 : (0 <= id)) (PreH12 : (id < 128)) (PreH13 : (idmanager_min_free_id (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) id )) (PreH14 : (os_world_wf sg locked )) (PreH15 : (semaphore_context (os_semaphore_stable (sg)) )) (PreH16 : (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) )) (PreH17 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) ,
  (DllInsertedCut ( &( "k_sem_list" ) ) (semaphore_first_link ((os_semaphore_stable (sg))) ((os_semaphores (locked)))) &((sem)  # "Semaphore" ->ₛ "link") )
  **  (store_node_self_linked &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (idmanager_link ((semaphore_manager_stable ((os_semaphore_stable (sg))))) ((idmanager_add ((semaphore_manager ((os_semaphores (locked))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  (dllseg_shift_rev (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) (semaphore_first_link ((os_semaphore_stable (sg))) ((os_semaphores (locked)))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (SemaphorePadding sem )
|--
  “ (Crtos_GTrans locked (replace_semaphores ((semaphore_publish (sem) (id) (val_pre) ((os_semaphores (locked))))) (locked)) ) ”
  &&  (InsideCritical sg locked )
  **  (os_inv sg (replace_semaphores ((semaphore_publish (sem) (id) (val_pre) ((os_semaphores (locked))))) (locked)) )
).

Definition _SemaphoreCreate_entail_wit_6_split_goal_1 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (sem: Z) (id: Z) (PreH1 : ((role_id ((os_recycle (locked)))) <= INT_MAX)) (PreH2 : ((role_id ((os_recycle (locked)))) >= INT_MIN)) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : (sem <> 0)) (PreH6 : (addr_aligned sem 4 )) (PreH7 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH8 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH9 : (Crtos_RTrans before locked )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH11 : (0 <= id)) (PreH12 : (id < 128)) (PreH13 : (idmanager_min_free_id (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) id )) (PreH14 : (os_world_wf sg locked )) (PreH15 : (semaphore_context (os_semaphore_stable (sg)) )) (PreH16 : (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) )) (PreH17 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) ,
  (DllInsertedCut ( &( "k_sem_list" ) ) (semaphore_first_link ((os_semaphore_stable (sg))) ((os_semaphores (locked)))) &((sem)  # "Semaphore" ->ₛ "link") )
  **  (store_node_self_linked &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (idmanager_link ((semaphore_manager_stable ((os_semaphore_stable (sg))))) ((idmanager_add ((semaphore_manager ((os_semaphores (locked))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  (dllseg_shift_rev (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) (semaphore_first_link ((os_semaphore_stable (sg))) ((os_semaphores (locked)))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (SemaphorePadding sem )
|--
  “ (Crtos_GTrans locked (replace_semaphores ((semaphore_publish (sem) (id) (val_pre) ((os_semaphores (locked))))) (locked)) ) ”
.

Definition _SemaphoreCreate_entail_wit_6_split_goal_spatial := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (sem: Z) (id: Z) (PreH1 : ((role_id ((os_recycle (locked)))) <= INT_MAX)) (PreH2 : ((role_id ((os_recycle (locked)))) >= INT_MIN)) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : (sem <> 0)) (PreH6 : (addr_aligned sem 4 )) (PreH7 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH8 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH9 : (Crtos_RTrans before locked )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH11 : (0 <= id)) (PreH12 : (id < 128)) (PreH13 : (idmanager_min_free_id (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) id )) (PreH14 : (os_world_wf sg locked )) (PreH15 : (semaphore_context (os_semaphore_stable (sg)) )) (PreH16 : (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) )) (PreH17 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) ,
  (DllInsertedCut ( &( "k_sem_list" ) ) (semaphore_first_link ((os_semaphore_stable (sg))) ((os_semaphores (locked)))) &((sem)  # "Semaphore" ->ₛ "link") )
  **  (store_node_self_linked &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (idmanager_link ((semaphore_manager_stable ((os_semaphore_stable (sg))))) ((idmanager_add ((semaphore_manager ((os_semaphores (locked))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  (dllseg_shift_rev (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) (semaphore_first_link ((os_semaphore_stable (sg))) ((os_semaphores (locked)))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (SemaphorePadding sem )
|--
  (InsideCritical sg locked )
  **  (os_inv sg (replace_semaphores ((semaphore_publish (sem) (id) (val_pre) ((os_semaphores (locked))))) (locked)) )
.

Definition _SemaphoreCreate_return_wit_1 := 
(
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (sem: Z) (id: Z) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : (sem <> 0)) (PreH4 : (addr_aligned sem 4 )) (PreH5 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH7 : (Crtos_RTrans before locked )) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH9 : (0 <= id)) (PreH10 : (id < 128)) (PreH11 : (idmanager_min_free_id (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) id )) (PreH12 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) (PreH13 : (Crtos_GTrans locked (replace_semaphores ((semaphore_publish (sem) (id) (val_pre) ((os_semaphores (locked))))) (locked)) )) ,
  (OutsideCritical sg (replace_semaphores ((semaphore_publish (sem) (id) (val_pre) ((os_semaphores (locked))))) (locked)) )
|--
  EX (after_2: VarGlobalState) ,
  “ (0 <= id) ” 
  &&  “ (id < 128) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after_2)) ( MonadErr.ret  (id)) X ) ”
  &&  (OutsideCritical sg after_2 )
) \/
(
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (sem: Z) (id: Z) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : (sem <> 0)) (PreH4 : (addr_aligned sem 4 )) (PreH5 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH7 : (Crtos_RTrans before locked )) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH9 : (0 <= id)) (PreH10 : (id < 128)) (PreH11 : (idmanager_min_free_id (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) id )) (PreH12 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) (PreH13 : (Crtos_GTrans locked (replace_semaphores ((semaphore_publish (sem) (id) (val_pre) ((os_semaphores (locked))))) (locked)) )) ,
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen ((replace_semaphores ((semaphore_publish (sem) (id) (val_pre) ((os_semaphores (locked))))) (locked)))) ( MonadErr.ret  (id)) X ) ”
  &&  emp
).

Definition _SemaphoreCreate_return_wit_1_split_goal_1 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (sem: Z) (id: Z) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : (sem <> 0)) (PreH4 : (addr_aligned sem 4 )) (PreH5 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH7 : (Crtos_RTrans before locked )) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH9 : (0 <= id)) (PreH10 : (id < 128)) (PreH11 : (idmanager_min_free_id (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) id )) (PreH12 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) (PreH13 : (Crtos_GTrans locked (replace_semaphores ((semaphore_publish (sem) (id) (val_pre) ((os_semaphores (locked))))) (locked)) )) ,
  ( monadesafe_lib.safeExec  (LastSeen ((replace_semaphores ((semaphore_publish (sem) (id) (val_pre) ((os_semaphores (locked))))) (locked)))) ( MonadErr.ret  (id)) X )
.

Definition _SemaphoreCreate_return_wit_2 := 
(
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (sem: Z) (id: Z) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : (sem <> 0)) (PreH4 : (addr_aligned sem 4 )) (PreH5 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH7 : (Crtos_RTrans before locked )) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH9 : (id = (-1))) (PreH10 : (idmanager_full (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) )) ,
  (OutsideCritical sg locked )
|--
  EX (after: VarGlobalState) ,
  “ ((-5) = (-5)) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  ((-5))) X ) ”
  &&  (OutsideCritical sg after )
) \/
(
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (sem: Z) (id: Z) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : (sem <> 0)) (PreH4 : (addr_aligned sem 4 )) (PreH5 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH7 : (Crtos_RTrans before locked )) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH9 : (id = (-1))) (PreH10 : (idmanager_full (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) )) ,
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (locked)) ( MonadErr.ret  ((-5))) X ) ”
  &&  emp
).

Definition _SemaphoreCreate_return_wit_2_split_goal_1 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (sem: Z) (id: Z) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : (sem <> 0)) (PreH4 : (addr_aligned sem 4 )) (PreH5 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH7 : (Crtos_RTrans before locked )) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH9 : (id = (-1))) (PreH10 : (idmanager_full (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) )) ,
  ( monadesafe_lib.safeExec  (LastSeen (locked)) ( MonadErr.ret  ((-5))) X )
.

Definition _SemaphoreCreate_return_wit_3 := 
(
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  (OutsideCritical sg before )
|--
  EX (after: VarGlobalState) ,
  “ ((-5) = (-5)) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  ((-5))) X ) ”
  &&  (OutsideCritical sg after )
) \/
(
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before)) ( MonadErr.ret  ((-5))) X ) ”
  &&  emp
).

Definition _SemaphoreCreate_return_wit_3_split_goal_1 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  ( monadesafe_lib.safeExec  (LastSeen (before)) ( MonadErr.ret  ((-5))) X )
.

Definition _SemaphoreCreate_partial_solve_wit_1_pure := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (OutsideCritical sg before )
|--
  “ (32 = 32) ”
.

Definition _SemaphoreCreate_partial_solve_wit_1_aux := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  (OutsideCritical sg before )
|--
  “ (32 = 32) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X ) ”
  &&  (OutsideCritical sg before )
.

Definition _SemaphoreCreate_partial_solve_wit_1 := _SemaphoreCreate_partial_solve_wit_1_pure -> _SemaphoreCreate_partial_solve_wit_1_aux.

Definition _SemaphoreCreate_partial_solve_wit_2_pure := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (sem: Z) (id: Z) (lock: Z) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : (sem <> 0)) (PreH4 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH5 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH6 : (id = 0)) (PreH7 : (lock = 0)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  (OutsideCritical sg before )
  **  (SemaphoreRaw sem )
|--
  “ (0 = 0) ” 
  &&  “ (32 = 32) ”
.

Definition _SemaphoreCreate_partial_solve_wit_2_aux := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (sem: Z) (id: Z) (lock: Z) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : (sem <> 0)) (PreH4 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH5 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH6 : (id = 0)) (PreH7 : (lock = 0)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  (OutsideCritical sg before )
  **  (SemaphoreRaw sem )
|--
  “ (0 = 0) ” 
  &&  “ (32 = 32) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ” 
  &&  “ (id = 0) ” 
  &&  “ (lock = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X ) ”
  &&  (SemaphoreRaw sem )
  **  (OutsideCritical sg before )
.

Definition _SemaphoreCreate_partial_solve_wit_2 := _SemaphoreCreate_partial_solve_wit_2_pure -> _SemaphoreCreate_partial_solve_wit_2_aux.

Definition _SemaphoreCreate_partial_solve_wit_3 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (sem: Z) (id: Z) (lock: Z) (retval: Z) (PreH1 : (retval = sem)) (PreH2 : (0 <= val_pre)) (PreH3 : (val_pre <= 65535)) (PreH4 : (sem <> 0)) (PreH5 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH7 : (id = 0)) (PreH8 : (lock = 0)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) ,
  (SemaphoreZero sem )
  **  (OutsideCritical sg before )
|--
  “ (retval = sem) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ” 
  &&  “ (id = 0) ” 
  &&  “ (lock = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X ) ”
  &&  (OutsideCritical sg before )
  **  (SemaphoreZero sem )
.

Definition _SemaphoreCreate_partial_solve_wit_4_pure := 
(
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (saved_lock: Z) (sem: Z) (id: Z) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : (sem <> 0)) (PreH4 : (addr_aligned sem 4 )) (PreH5 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH7 : (Crtos_RTrans before locked )) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH9 : (id = 0)) (PreH10 : (os_world_wf sg locked )) (PreH11 : (semaphore_context (os_semaphore_stable (sg)) )) (PreH12 : (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) )) (PreH13 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) ,
  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) ( &( "k_sem_id_manager" ) ) )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  (ZeroIdNode &((sem)  # "Semaphore" ->ₛ "id") )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  “ (&((sem)  # "Semaphore" ->ₛ "id") <> 0) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ”
) \/
(
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (saved_lock: Z) (sem: Z) (id: Z) (PreH1 : ((role_id ((os_recycle (locked)))) <= INT_MAX)) (PreH2 : (id <= INT_MAX)) (PreH3 : (saved_lock <= INT_MAX)) (PreH4 : ((role_id ((os_recycle (locked)))) >= INT_MIN)) (PreH5 : (id >= INT_MIN)) (PreH6 : (saved_lock >= INT_MIN)) (PreH7 : (0 <= val_pre)) (PreH8 : (val_pre <= 65535)) (PreH9 : (sem <> 0)) (PreH10 : (addr_aligned sem 4 )) (PreH11 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH12 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH13 : (Crtos_RTrans before locked )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH15 : (id = 0)) (PreH16 : (os_world_wf sg locked )) (PreH17 : (semaphore_context (os_semaphore_stable (sg)) )) (PreH18 : (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) )) (PreH19 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) ,
  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) ( &( "k_sem_id_manager" ) ) )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  (ZeroIdNode &((sem)  # "Semaphore" ->ₛ "id") )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "id") <> 0) ”
).

Definition _SemaphoreCreate_partial_solve_wit_4_pure_split_goal_1 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (saved_lock: Z) (sem: Z) (id: Z) (PreH1 : ((role_id ((os_recycle (locked)))) <= INT_MAX)) (PreH2 : (id <= INT_MAX)) (PreH3 : (saved_lock <= INT_MAX)) (PreH4 : ((role_id ((os_recycle (locked)))) >= INT_MIN)) (PreH5 : (id >= INT_MIN)) (PreH6 : (saved_lock >= INT_MIN)) (PreH7 : (0 <= val_pre)) (PreH8 : (val_pre <= 65535)) (PreH9 : (sem <> 0)) (PreH10 : (addr_aligned sem 4 )) (PreH11 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH12 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH13 : (Crtos_RTrans before locked )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH15 : (id = 0)) (PreH16 : (os_world_wf sg locked )) (PreH17 : (semaphore_context (os_semaphore_stable (sg)) )) (PreH18 : (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) )) (PreH19 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) ,
  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) ( &( "k_sem_id_manager" ) ) )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  (ZeroIdNode &((sem)  # "Semaphore" ->ₛ "id") )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  “ (( &( "k_sem_id_manager" ) ) <> 0) ”
.

Definition _SemaphoreCreate_partial_solve_wit_4_pure_split_goal_2 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (saved_lock: Z) (sem: Z) (id: Z) (PreH1 : ((role_id ((os_recycle (locked)))) <= INT_MAX)) (PreH2 : (id <= INT_MAX)) (PreH3 : (saved_lock <= INT_MAX)) (PreH4 : ((role_id ((os_recycle (locked)))) >= INT_MIN)) (PreH5 : (id >= INT_MIN)) (PreH6 : (saved_lock >= INT_MIN)) (PreH7 : (0 <= val_pre)) (PreH8 : (val_pre <= 65535)) (PreH9 : (sem <> 0)) (PreH10 : (addr_aligned sem 4 )) (PreH11 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH12 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH13 : (Crtos_RTrans before locked )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH15 : (id = 0)) (PreH16 : (os_world_wf sg locked )) (PreH17 : (semaphore_context (os_semaphore_stable (sg)) )) (PreH18 : (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) )) (PreH19 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) ,
  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) ( &( "k_sem_id_manager" ) ) )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  (ZeroIdNode &((sem)  # "Semaphore" ->ₛ "id") )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  “ (&((sem)  # "Semaphore" ->ₛ "id") <> 0) ”
.

Definition _SemaphoreCreate_partial_solve_wit_4_aux := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (sem: Z) (id: Z) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : (sem <> 0)) (PreH4 : (addr_aligned sem 4 )) (PreH5 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH7 : (Crtos_RTrans before locked )) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH9 : (id = 0)) (PreH10 : (os_world_wf sg locked )) (PreH11 : (semaphore_context (os_semaphore_stable (sg)) )) (PreH12 : (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) )) (PreH13 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) ,
  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) ( &( "k_sem_id_manager" ) ) )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  (ZeroIdNode &((sem)  # "Semaphore" ->ₛ "id") )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  “ (&((sem)  # "Semaphore" ->ₛ "id") <> 0) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (addr_aligned sem 4 ) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ” 
  &&  “ (Crtos_RTrans before locked ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X ) ” 
  &&  “ (id = 0) ” 
  &&  “ (os_world_wf sg locked ) ” 
  &&  “ (semaphore_context (os_semaphore_stable (sg)) ) ” 
  &&  “ (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) ) ” 
  &&  “ ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) )) ”
  &&  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) ( &( "k_sem_id_manager" ) ) )
  **  (ZeroIdNode &((sem)  # "Semaphore" ->ₛ "id") )
  **  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
.

Definition _SemaphoreCreate_partial_solve_wit_4 := _SemaphoreCreate_partial_solve_wit_4_pure -> _SemaphoreCreate_partial_solve_wit_4_aux.

Definition _SemaphoreCreate_partial_solve_wit_5 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (sem: Z) (id: Z) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : (sem <> 0)) (PreH4 : (addr_aligned sem 4 )) (PreH5 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH7 : (Crtos_RTrans before locked )) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH9 : (id = (-1))) (PreH10 : (idmanager_full (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) )) ,
  (InsideCritical sg locked )
  **  (os_inv sg locked )
  **  (SemaphoreZero sem )
|--
  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (addr_aligned sem 4 ) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ” 
  &&  “ (Crtos_RTrans before locked ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X ) ” 
  &&  “ (id = (-1)) ” 
  &&  “ (idmanager_full (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) ) ”
  &&  (SemaphoreZero sem )
  **  (InsideCritical sg locked )
  **  (os_inv sg locked )
.

Definition _SemaphoreCreate_partial_solve_wit_6_pure := 
(
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (saved_lock: Z) (sem: Z) (id: Z) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : (sem <> 0)) (PreH4 : (addr_aligned sem 4 )) (PreH5 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH7 : (Crtos_RTrans before locked )) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH9 : (id = (-1))) (PreH10 : (idmanager_full (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) )) ,
  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  (InsideCritical sg locked )
  **  (os_inv sg locked )
|--
  “ (Crtos_GTrans locked locked ) ”
) \/
(
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (saved_lock: Z) (sem: Z) (id: Z) (PreH1 : (id <= INT_MAX)) (PreH2 : (saved_lock <= INT_MAX)) (PreH3 : (id >= INT_MIN)) (PreH4 : (saved_lock >= INT_MIN)) (PreH5 : (0 <= val_pre)) (PreH6 : (val_pre <= 65535)) (PreH7 : (sem <> 0)) (PreH8 : (addr_aligned sem 4 )) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH10 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH11 : (Crtos_RTrans before locked )) (PreH12 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH13 : (id = (-1))) (PreH14 : (idmanager_full (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) )) ,
  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  (InsideCritical sg locked )
  **  (os_inv sg locked )
|--
  “ (Crtos_GTrans locked locked ) ”
).

Definition _SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (saved_lock: Z) (sem: Z) (id: Z) (PreH1 : (id <= INT_MAX)) (PreH2 : (saved_lock <= INT_MAX)) (PreH3 : (id >= INT_MIN)) (PreH4 : (saved_lock >= INT_MIN)) (PreH5 : (0 <= val_pre)) (PreH6 : (val_pre <= 65535)) (PreH7 : (sem <> 0)) (PreH8 : (addr_aligned sem 4 )) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH10 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH11 : (Crtos_RTrans before locked )) (PreH12 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH13 : (id = (-1))) (PreH14 : (idmanager_full (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) )) ,
  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  (InsideCritical sg locked )
  **  (os_inv sg locked )
|--
  “ (Crtos_GTrans locked locked ) ”
.

Definition _SemaphoreCreate_partial_solve_wit_6_aux := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (sem: Z) (id: Z) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : (sem <> 0)) (PreH4 : (addr_aligned sem 4 )) (PreH5 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH7 : (Crtos_RTrans before locked )) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH9 : (id = (-1))) (PreH10 : (idmanager_full (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) )) ,
  (InsideCritical sg locked )
  **  (os_inv sg locked )
|--
  “ (Crtos_GTrans locked locked ) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (addr_aligned sem 4 ) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ” 
  &&  “ (Crtos_RTrans before locked ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X ) ” 
  &&  “ (id = (-1)) ” 
  &&  “ (idmanager_full (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) ) ”
  &&  (InsideCritical sg locked )
  **  (os_inv sg locked )
.

Definition _SemaphoreCreate_partial_solve_wit_6 := _SemaphoreCreate_partial_solve_wit_6_pure -> _SemaphoreCreate_partial_solve_wit_6_aux.

Definition _SemaphoreCreate_partial_solve_wit_7 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (sem: Z) (id: Z) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : (sem <> 0)) (PreH4 : (addr_aligned sem 4 )) (PreH5 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH7 : (Crtos_RTrans before locked )) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH9 : (0 <= id)) (PreH10 : (id < 128)) (PreH11 : (idmanager_min_free_id (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) id )) (PreH12 : (os_world_wf sg locked )) (PreH13 : (semaphore_context (os_semaphore_stable (sg)) )) (PreH14 : (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) )) (PreH15 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) ,
  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (idmanager_link ((semaphore_manager_stable ((os_semaphore_stable (sg))))) ((idmanager_add ((semaphore_manager ((os_semaphores (locked))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  (dllseg_shift_rev (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) (semaphore_first_link ((os_semaphore_stable (sg))) ((os_semaphores (locked)))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  (DllInsertAfterCut ( &( "k_sem_list" ) ) (semaphore_first_link ((os_semaphore_stable (sg))) ((os_semaphores (locked)))) &((sem)  # "Semaphore" ->ₛ "link") 0 0 )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (NodeStorage &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (SemaphorePadding sem )
|--
  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (addr_aligned sem 4 ) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ” 
  &&  “ (Crtos_RTrans before locked ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X ) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id < 128) ” 
  &&  “ (idmanager_min_free_id (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) id ) ” 
  &&  “ (os_world_wf sg locked ) ” 
  &&  “ (semaphore_context (os_semaphore_stable (sg)) ) ” 
  &&  “ (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) ) ” 
  &&  “ ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) )) ”
  &&  (NodeStorage &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (idmanager_link ((semaphore_manager_stable ((os_semaphore_stable (sg))))) ((idmanager_add ((semaphore_manager ((os_semaphores (locked))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  (dllseg_shift_rev (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) (semaphore_first_link ((os_semaphore_stable (sg))) ((os_semaphores (locked)))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  (DllInsertAfterCut ( &( "k_sem_list" ) ) (semaphore_first_link ((os_semaphore_stable (sg))) ((os_semaphores (locked)))) &((sem)  # "Semaphore" ->ₛ "link") 0 0 )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (SemaphorePadding sem )
.

Definition _SemaphoreCreate_partial_solve_wit_8 := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (sem: Z) (id: Z) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : (sem <> 0)) (PreH4 : (addr_aligned sem 4 )) (PreH5 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH7 : (Crtos_RTrans before locked )) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH9 : (0 <= id)) (PreH10 : (id < 128)) (PreH11 : (idmanager_min_free_id (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) id )) (PreH12 : (os_world_wf sg locked )) (PreH13 : (semaphore_context (os_semaphore_stable (sg)) )) (PreH14 : (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) )) (PreH15 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) ,
  (store_node_self_linked &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (idmanager_link ((semaphore_manager_stable ((os_semaphore_stable (sg))))) ((idmanager_add ((semaphore_manager ((os_semaphores (locked))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  (dllseg_shift_rev (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) (semaphore_first_link ((os_semaphore_stable (sg))) ((os_semaphores (locked)))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  (DllInsertAfterCut ( &( "k_sem_list" ) ) (semaphore_first_link ((os_semaphore_stable (sg))) ((os_semaphores (locked)))) &((sem)  # "Semaphore" ->ₛ "link") 0 0 )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (SemaphorePadding sem )
|--
  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (addr_aligned sem 4 ) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ” 
  &&  “ (Crtos_RTrans before locked ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X ) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id < 128) ” 
  &&  “ (idmanager_min_free_id (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) id ) ” 
  &&  “ (os_world_wf sg locked ) ” 
  &&  “ (semaphore_context (os_semaphore_stable (sg)) ) ” 
  &&  “ (dll_nodes_nonzero (map (semaphore_link_node) ((os_semaphores (locked)))) ) ” 
  &&  “ ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) )) ”
  &&  (DllInsertAfterCut ( &( "k_sem_list" ) ) (semaphore_first_link ((os_semaphore_stable (sg))) ((os_semaphores (locked)))) &((sem)  # "Semaphore" ->ₛ "link") 0 0 )
  **  (store_node_self_linked &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (InsideCritical sg locked )
  **  (task_inv sg locked )
  **  (tick_inv sg locked )
  **  (delay_inv sg locked )
  **  (assign_inv sg locked )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (locked)))) (os_zombie_head (sg)) (zombie_queue (locked)) )
  **  (((os_recycler_slot (sg))) # Int  |-> (role_id ((os_recycle (locked)))))
  **  (IntArray.full (os_idle_array (sg)) CORE_COUNT (map (role_id) ((os_idle (locked)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_mutex_stable (sg)) (os_mutexes (locked)) )
  **  (msgqueue_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_msgqueue_stable (sg)) (os_msgqueues (locked)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))) (os_event_stable (sg)) (os_events (locked)) )
  **  (isrmanager_inv (os_isr_stable (sg)) (os_isr (locked)) )
  **  (exstatus_inv sg locked )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg)))) (idmanager_link ((semaphore_manager_stable ((os_semaphore_stable (sg))))) ((idmanager_add ((semaphore_manager ((os_semaphores (locked))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  (dllseg_shift_rev (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (locked)))))))) (semaphore_first_link ((os_semaphore_stable (sg))) ((os_semaphores (locked)))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (locked)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (SemaphorePadding sem )
.

Definition _SemaphoreCreate_partial_solve_wit_9_pure := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (saved_lock: Z) (sem: Z) (id: Z) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : (sem <> 0)) (PreH4 : (addr_aligned sem 4 )) (PreH5 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH7 : (Crtos_RTrans before locked )) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH9 : (0 <= id)) (PreH10 : (id < 128)) (PreH11 : (idmanager_min_free_id (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) id )) (PreH12 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) (PreH13 : (Crtos_GTrans locked (replace_semaphores ((semaphore_publish (sem) (id) (val_pre) ((os_semaphores (locked))))) (locked)) )) ,
  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  (InsideCritical sg locked )
  **  (os_inv sg (replace_semaphores ((semaphore_publish (sem) (id) (val_pre) ((os_semaphores (locked))))) (locked)) )
|--
  “ (Crtos_GTrans locked (replace_semaphores ((semaphore_publish (sem) (id) (val_pre) ((os_semaphores (locked))))) (locked)) ) ”
.

Definition _SemaphoreCreate_partial_solve_wit_9_aux := 
forall (val_pre: Z) (X: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before: VarGlobalState) (sg: StableGlobalState) (locked: VarGlobalState) (sem: Z) (id: Z) (PreH1 : (0 <= val_pre)) (PreH2 : (val_pre <= 65535)) (PreH3 : (sem <> 0)) (PreH4 : (addr_aligned sem 4 )) (PreH5 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH7 : (Crtos_RTrans before locked )) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X )) (PreH9 : (0 <= id)) (PreH10 : (id < 128)) (PreH11 : (idmanager_min_free_id (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) id )) (PreH12 : ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) ))) (PreH13 : (Crtos_GTrans locked (replace_semaphores ((semaphore_publish (sem) (id) (val_pre) ((os_semaphores (locked))))) (locked)) )) ,
  (InsideCritical sg locked )
  **  (os_inv sg (replace_semaphores ((semaphore_publish (sem) (id) (val_pre) ((os_semaphores (locked))))) (locked)) )
|--
  “ (Crtos_GTrans locked (replace_semaphores ((semaphore_publish (sem) (id) (val_pre) ((os_semaphores (locked))))) (locked)) ) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (addr_aligned sem 4 ) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ” 
  &&  “ (Crtos_RTrans before locked ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before)) (abs_semaphore_create (sg) (val_pre)) X ) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id < 128) ” 
  &&  “ (idmanager_min_free_id (semaphore_manager_stable ((os_semaphore_stable (sg)))) (semaphore_manager ((os_semaphores (locked)))) id ) ” 
  &&  “ ~((In sem (map (semaphore_addr) ((os_semaphores (locked)))) )) ” 
  &&  “ (Crtos_GTrans locked (replace_semaphores ((semaphore_publish (sem) (id) (val_pre) ((os_semaphores (locked))))) (locked)) ) ”
  &&  (InsideCritical sg locked )
  **  (os_inv sg (replace_semaphores ((semaphore_publish (sem) (id) (val_pre) ((os_semaphores (locked))))) (locked)) )
.

Definition _SemaphoreCreate_partial_solve_wit_9 := _SemaphoreCreate_partial_solve_wit_9_pure -> _SemaphoreCreate_partial_solve_wit_9_aux.

Module Type VC_Correct.


Axiom proof_of__SemaphoreCreate_safety_wit_1 : _SemaphoreCreate_safety_wit_1.
Axiom proof_of__SemaphoreCreate_safety_wit_2 : _SemaphoreCreate_safety_wit_2.
Axiom proof_of__SemaphoreCreate_safety_wit_3 : _SemaphoreCreate_safety_wit_3.
Axiom proof_of__SemaphoreCreate_safety_wit_4 : _SemaphoreCreate_safety_wit_4.
Axiom proof_of__SemaphoreCreate_safety_wit_5 : _SemaphoreCreate_safety_wit_5.
Axiom proof_of__SemaphoreCreate_safety_wit_6 : _SemaphoreCreate_safety_wit_6.
Axiom proof_of__SemaphoreCreate_safety_wit_7 : _SemaphoreCreate_safety_wit_7.
Axiom proof_of__SemaphoreCreate_safety_wit_8 : _SemaphoreCreate_safety_wit_8.
Axiom proof_of__SemaphoreCreate_safety_wit_9 : _SemaphoreCreate_safety_wit_9.
Axiom proof_of__SemaphoreCreate_safety_wit_10 : _SemaphoreCreate_safety_wit_10.
Axiom proof_of__SemaphoreCreate_safety_wit_11 : _SemaphoreCreate_safety_wit_11.
Axiom proof_of__SemaphoreCreate_safety_wit_12 : _SemaphoreCreate_safety_wit_12.
Axiom proof_of__SemaphoreCreate_safety_wit_13 : _SemaphoreCreate_safety_wit_13.
Axiom proof_of__SemaphoreCreate_safety_wit_14 : _SemaphoreCreate_safety_wit_14.
Axiom proof_of__SemaphoreCreate_safety_wit_15 : _SemaphoreCreate_safety_wit_15.
Axiom proof_of__SemaphoreCreate_safety_wit_16 : _SemaphoreCreate_safety_wit_16.
Axiom proof_of__SemaphoreCreate_safety_wit_17 : _SemaphoreCreate_safety_wit_17.
Axiom proof_of__SemaphoreCreate_safety_wit_18 : _SemaphoreCreate_safety_wit_18.
Axiom proof_of__SemaphoreCreate_entail_wit_1 : _SemaphoreCreate_entail_wit_1.
Axiom proof_of__SemaphoreCreate_entail_wit_2 : _SemaphoreCreate_entail_wit_2.
Axiom proof_of__SemaphoreCreate_entail_wit_3 : _SemaphoreCreate_entail_wit_3.
Axiom proof_of__SemaphoreCreate_entail_wit_4 : _SemaphoreCreate_entail_wit_4.
Axiom proof_of__SemaphoreCreate_entail_wit_5 : _SemaphoreCreate_entail_wit_5.
Axiom proof_of__SemaphoreCreate_entail_wit_6 : _SemaphoreCreate_entail_wit_6.
Axiom proof_of__SemaphoreCreate_return_wit_1 : _SemaphoreCreate_return_wit_1.
Axiom proof_of__SemaphoreCreate_return_wit_2 : _SemaphoreCreate_return_wit_2.
Axiom proof_of__SemaphoreCreate_return_wit_3 : _SemaphoreCreate_return_wit_3.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_1_pure : _SemaphoreCreate_partial_solve_wit_1_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_1 : _SemaphoreCreate_partial_solve_wit_1.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_2_pure : _SemaphoreCreate_partial_solve_wit_2_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_2 : _SemaphoreCreate_partial_solve_wit_2.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_3 : _SemaphoreCreate_partial_solve_wit_3.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_4_pure : _SemaphoreCreate_partial_solve_wit_4_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_4 : _SemaphoreCreate_partial_solve_wit_4.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_5 : _SemaphoreCreate_partial_solve_wit_5.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_6_pure : _SemaphoreCreate_partial_solve_wit_6_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_6 : _SemaphoreCreate_partial_solve_wit_6.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_7 : _SemaphoreCreate_partial_solve_wit_7.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_8 : _SemaphoreCreate_partial_solve_wit_8.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_9_pure : _SemaphoreCreate_partial_solve_wit_9_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_9 : _SemaphoreCreate_partial_solve_wit_9.

End VC_Correct.
