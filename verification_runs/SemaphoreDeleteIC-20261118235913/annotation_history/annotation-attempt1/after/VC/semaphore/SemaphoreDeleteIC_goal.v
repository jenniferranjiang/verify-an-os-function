From SimpleC.Verification Require Import VCPrelude.
Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreDelete.
Require Import CRTOS_Verify.lib.id.idnode CRTOS_Verify.lib.id.IdModuleSpec CRTOS_Verify.lib.common.dll CRTOS_Verify.lib.list.NodeSelfLinked.
Import IDNode DLL.
Local Open Scope sac.

(*----- Function _SemaphoreDelete -----*)

Definition _SemaphoreDelete_safety_wit_1 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ((( &( "resched" ) )) # Int  |->_)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreDelete_safety_wit_2 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ((( &( "lock" ) )) # Int  |->_)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreDelete_safety_wit_3 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ((( &( "sem" ) )) # Ptr  |->_)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreDelete_safety_wit_4 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ((( &( "idnode" ) )) # Ptr  |->_)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreDelete_safety_wit_5 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreDelete_safety_wit_6 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (PreH1 : (id_pre >= 0)) (PreH2 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  “ (65535 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 65535) ”
.

Definition _SemaphoreDelete_safety_wit_7 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (retval: Z) (PreH1 : (( &( "k_sem_id_manager" ) ) = 0)) (PreH2 : (retval = 0)) (PreH3 : (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )) (PreH4 : (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) )) (PreH5 : (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) )) (PreH6 : (id_pre <= 65535)) (PreH7 : (id_pre >= 0)) (PreH8 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_cleanup_ic)))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
  **  ((( &( "idnode" ) )) # Ptr  |-> retval)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreDelete_safety_wit_8 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (retval: Z) (PreH1 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH2 : (retval = 0)) (PreH3 : (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) (id_pre)) = false)) (PreH4 : (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )) (PreH5 : (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) )) (PreH6 : (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) )) (PreH7 : (id_pre <= 65535)) (PreH8 : (id_pre >= 0)) (PreH9 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_cleanup_ic)))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
  **  ((( &( "idnode" ) )) # Ptr  |-> retval)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreDelete_safety_wit_9 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (retval: Z) (PreH1 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH2 : (retval <> 0)) (PreH3 : (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) (id_pre)) = true)) (PreH4 : (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )) (PreH5 : (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) )) (PreH6 : (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) )) (PreH7 : (id_pre <= 65535)) (PreH8 : (id_pre >= 0)) (PreH9 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager_found  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) retval id_pre )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_cleanup_ic)))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
  **  ((( &( "idnode" ) )) # Ptr  |-> retval)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreDelete_safety_wit_10 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) = 0)) (PreH3 : (retval = 0)) (PreH4 : (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )) (PreH5 : (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) )) (PreH6 : (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) )) (PreH7 : (id_pre <= 65535)) (PreH8 : (id_pre >= 0)) (PreH9 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_cleanup_ic)))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
  **  ((( &( "idnode" ) )) # Ptr  |-> retval)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ False ”
.

Definition _SemaphoreDelete_safety_wit_11 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval = 0)) (PreH4 : (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) (id_pre)) = false)) (PreH5 : (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )) (PreH6 : (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) )) (PreH7 : (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) )) (PreH8 : (id_pre <= 65535)) (PreH9 : (id_pre >= 0)) (PreH10 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_cleanup_ic)))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
  **  ((( &( "idnode" ) )) # Ptr  |-> retval)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ False ”
.

Definition _SemaphoreDelete_safety_wit_12 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval <> 0)) (PreH4 : (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) (id_pre)) = true)) (PreH5 : (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )) (PreH6 : (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) )) (PreH7 : (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) )) (PreH8 : (id_pre <= 65535)) (PreH9 : (id_pre >= 0)) (PreH10 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager_found  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) retval id_pre )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_cleanup_ic)))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
  **  ((( &( "idnode" ) )) # Ptr  |-> retval)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ False ”
.

Definition _SemaphoreDelete_safety_wit_13 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (lock: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : ((@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)) <> (@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)))) (PreH3 : (retval = (semaphore_addr (original)))) (PreH4 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : (lock = 0)) (PreH8 : (resched = 0)) (PreH9 : (sem = 0)) (PreH10 : (In original (os_semaphores (before_dataqueue_cleanup_ic)) )) (PreH11 : ((semaphore_id (original)) = id_pre)) (PreH12 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH13 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH14 : ((semaphore_addr (original)) <> 0)) (PreH15 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list") (@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)) )
  **  ((( &( "sem" ) )) # Ptr  |-> (semaphore_addr (original)))
  **  (wand ( CRTOS_Verify.lib.common.dll.DLL.store_dll  ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic))))))) (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list")) ((@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg_dataqueue_cleanup_ic) (before_dataqueue_cleanup_ic)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
|--
  “ False ”
.

Definition _SemaphoreDelete_safety_wit_14 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (lock: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : (retval_2 = 1)) (PreH3 : ((@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)) = (@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)))) (PreH4 : (retval = (semaphore_addr (original)))) (PreH5 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH6 : (0 <= id_pre)) (PreH7 : (id_pre <= 65535)) (PreH8 : (lock = 0)) (PreH9 : (resched = 0)) (PreH10 : (sem = 0)) (PreH11 : (In original (os_semaphores (before_dataqueue_cleanup_ic)) )) (PreH12 : ((semaphore_id (original)) = id_pre)) (PreH13 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH14 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH15 : ((semaphore_addr (original)) <> 0)) (PreH16 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list") (@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)) )
  **  ((( &( "sem" ) )) # Ptr  |-> (semaphore_addr (original)))
  **  (wand ( CRTOS_Verify.lib.common.dll.DLL.store_dll  ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic))))))) (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list")) ((@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg_dataqueue_cleanup_ic) (before_dataqueue_cleanup_ic)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
|--
  “ False ”
.

Definition _SemaphoreDelete_safety_wit_15 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (original: SemaphoreAbs) (sem: Z) (lock: Z) (resched: Z) (idnode: Z) (delete_sem_id: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : (sem = (semaphore_addr (original)))) (PreH2 : (sem <> 0)) (PreH3 : (lock = 0)) (PreH4 : (resched = 0)) (PreH5 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH6 : (delete_sem_id = (semaphore_id (original)))) (PreH7 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  id_pre before_dataqueue_cleanup_ic after )) (PreH8 : (resched <> 0)),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> delete_sem_id)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic after )
|--
  “ False ”
.

Definition _SemaphoreDelete_entail_wit_1 :=
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval <> 0)) (PreH4 : (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) (id_pre)) = true)) (PreH5 : (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )) (PreH6 : (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) )) (PreH7 : (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) )) (PreH8 : (id_pre <= 65535)) (PreH9 : (id_pre >= 0)) (PreH10 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager_found  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) retval id_pre )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_cleanup_ic)))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
|--
  EX (original: SemaphoreAbs),
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (0 = 0) ”
  &&  “ (0 = 0) ”
  &&  “ (0 = 0) ”
  &&  “ (In original (os_semaphores (before_dataqueue_cleanup_ic)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_pending_addrs (original)) = (@nil Z)) ”
  &&  “ (retval = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ ((semaphore_addr (original)) <> 0) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
) \/
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (retval: Z) (PreH1 : ((service_id ((os_recycle (before_dataqueue_cleanup_ic)))) <= INT_MAX)) (PreH2 : ((service_id ((os_recycle (before_dataqueue_cleanup_ic)))) >= INT_MIN)) (PreH3 : (retval <> 0)) (PreH4 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH5 : (retval <> 0)) (PreH6 : (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) (id_pre)) = true)) (PreH7 : (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )) (PreH8 : (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) )) (PreH9 : (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) )) (PreH10 : (id_pre <= 65535)) (PreH11 : (id_pre >= 0)) (PreH12 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager_found  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) retval id_pre )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_cleanup_ic)))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
|--
  EX (original: SemaphoreAbs),
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (In original (os_semaphores (before_dataqueue_cleanup_ic)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_pending_addrs (original)) = (@nil Z)) ”
  &&  “ (retval = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ ((semaphore_addr (original)) <> 0) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
).

Definition _SemaphoreDelete_entail_wit_2 :=
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (lock: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : ((semaphore_addr (original)) = (semaphore_addr (original)))) (PreH2 : (retval_2 <> 0)) (PreH3 : (retval_2 = 1)) (PreH4 : (retval = (semaphore_addr (original)))) (PreH5 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH6 : (0 <= id_pre)) (PreH7 : (id_pre <= 65535)) (PreH8 : (lock = 0)) (PreH9 : (resched = 0)) (PreH10 : (sem = 0)) (PreH11 : (In original (os_semaphores (before_dataqueue_cleanup_ic)) )) (PreH12 : ((semaphore_id (original)) = id_pre)) (PreH13 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH14 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH15 : ((semaphore_addr (original)) <> 0)) (PreH16 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  EX (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)),
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (lock = 0) ”
  &&  “ (resched = 0) ”
  &&  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ ((semaphore_id (original)) = (semaphore_id (original))) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_pending_addrs (original)) = (@nil Z)) ”
  &&  “ ((os_semaphores (before_dataqueue_cleanup_ic)) = (app (prefix) ((cons (original) (suffix))))) ”
  &&  “ (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) ) ”
  &&  “ (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) ((semaphore_id (original)))) = true) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic ) ”
  &&  “ (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic ) ”
  &&  “ (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) ) ”
  &&  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((cons (( CRTOS_Verify.lib.common.dll_abs.Build_DL_Node  (original) (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "link")))) ((map (semaphore_link_node) (suffix)))))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
) \/
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (lock: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 <> 0)) (PreH2 : (retval_2 = 1)) (PreH3 : (retval = (semaphore_addr (original)))) (PreH4 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : (lock = 0)) (PreH8 : (resched = 0)) (PreH9 : (sem = 0)) (PreH10 : (In original (os_semaphores (before_dataqueue_cleanup_ic)) )) (PreH11 : ((semaphore_id (original)) = id_pre)) (PreH12 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH13 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH14 : ((semaphore_addr (original)) <> 0)) (PreH15 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  EX (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)),
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (lock = 0) ”
  &&  “ (resched = 0) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_pending_addrs (original)) = (@nil Z)) ”
  &&  “ ((os_semaphores (before_dataqueue_cleanup_ic)) = (app (prefix) ((cons (original) (suffix))))) ”
  &&  “ (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) ) ”
  &&  “ (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) ((semaphore_id (original)))) = true) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic ) ”
  &&  “ (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic ) ”
  &&  “ (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) ) ”
  &&  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((cons (( CRTOS_Verify.lib.common.dll_abs.Build_DL_Node  (original) (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "link")))) ((map (semaphore_link_node) (suffix)))))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
).

Definition _SemaphoreDelete_entail_wit_3_1 :=
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (original: SemaphoreAbs) (lock: Z) (resched: Z) (sem: Z) (idnode: Z) (delete_sem_id: Z) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) (delete_sem_id)) = false)) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre <= 65535)) (PreH4 : (lock = 0)) (PreH5 : (resched = 0)) (PreH6 : (sem = (semaphore_addr (original)))) (PreH7 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH8 : (delete_sem_id = (semaphore_id (original)))) (PreH9 : ((semaphore_id (original)) = id_pre)) (PreH10 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH11 : ((os_semaphores (before_dataqueue_cleanup_ic)) = (app (prefix) ((cons (original) (suffix)))))) (PreH12 : (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) )) (PreH13 : (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) ((semaphore_id (original)))) = true)) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )) (PreH15 : (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )) (PreH16 : (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) )),
  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((map (semaphore_link_node) (suffix)))) )
  **  (store_semaphore (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) &((sem)  # "Semaphore" ->ₛ "link") original )
  **  ( CRTOS_Verify.lib.list.NodeSelfLinked.store_node_self_linked  &((sem)  # "Semaphore" ->ₛ "link") )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
|--
  EX (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ (sem = (semaphore_addr (original))) ”
  &&  “ (sem <> 0) ”
  &&  “ (lock = 0) ”
  &&  “ (resched = 0) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (delete_sem_id = (semaphore_id (original))) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  id_pre before_dataqueue_cleanup_ic after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic after )
  **  (CharArray.undef_full sem 32 )
) \/
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (original: SemaphoreAbs) (lock: Z) (resched: Z) (sem: Z) (idnode: Z) (delete_sem_id: Z) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : ((service_id ((os_recycle (before_dataqueue_cleanup_ic)))) <= INT_MAX)) (PreH2 : ((service_id ((os_recycle (before_dataqueue_cleanup_ic)))) >= INT_MIN)) (PreH3 : (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) (delete_sem_id)) = false)) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= 65535)) (PreH6 : (lock = 0)) (PreH7 : (resched = 0)) (PreH8 : (sem = (semaphore_addr (original)))) (PreH9 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH10 : (delete_sem_id = (semaphore_id (original)))) (PreH11 : ((semaphore_id (original)) = id_pre)) (PreH12 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH13 : ((os_semaphores (before_dataqueue_cleanup_ic)) = (app (prefix) ((cons (original) (suffix)))))) (PreH14 : (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) )) (PreH15 : (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) ((semaphore_id (original)))) = true)) (PreH16 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )) (PreH17 : (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )) (PreH18 : (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) )),
  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((map (semaphore_link_node) (suffix)))) )
  **  (store_semaphore (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) &((sem)  # "Semaphore" ->ₛ "link") original )
  **  ( CRTOS_Verify.lib.list.NodeSelfLinked.store_node_self_linked  &((sem)  # "Semaphore" ->ₛ "link") )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
|--
  EX (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ (sem = (semaphore_addr (original))) ”
  &&  “ (sem <> 0) ”
  &&  “ (lock = 0) ”
  &&  “ (resched = 0) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (delete_sem_id = (semaphore_id (original))) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  id_pre before_dataqueue_cleanup_ic after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic after )
  **  (CharArray.undef_full sem 32 )
).

Definition _SemaphoreDelete_entail_wit_3_2 :=
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (original: SemaphoreAbs) (lock: Z) (resched: Z) (sem: Z) (idnode: Z) (delete_sem_id: Z) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (idnode_2: Z) (PreH1 : (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) (delete_sem_id)) = true)) (PreH2 : ( CRTOS_Verify.lib.id.IdModuleSpec.idmanager_contains  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) delete_sem_id idnode_2 )) (PreH3 : (idnode_2 <> 0)) (PreH4 : (&((idnode_2)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : (lock = 0)) (PreH8 : (resched = 0)) (PreH9 : (sem = (semaphore_addr (original)))) (PreH10 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH11 : (delete_sem_id = (semaphore_id (original)))) (PreH12 : ((semaphore_id (original)) = id_pre)) (PreH13 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH14 : ((os_semaphores (before_dataqueue_cleanup_ic)) = (app (prefix) ((cons (original) (suffix)))))) (PreH15 : (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) )) (PreH16 : (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) ((semaphore_id (original)))) = true)) (PreH17 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )) (PreH18 : (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )) (PreH19 : (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) )),
  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((map (semaphore_link_node) (suffix)))) )
  **  (store_semaphore (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) &((sem)  # "Semaphore" ->ₛ "link") original )
  **  ( CRTOS_Verify.lib.list.NodeSelfLinked.store_node_self_linked  &((sem)  # "Semaphore" ->ₛ "link") )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_remove  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic))))) ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) (delete_sem_id)) ( &( "k_sem_id_manager" ) ) )
  **  ((&((idnode_2)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
|--
  EX (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ (sem = (semaphore_addr (original))) ”
  &&  “ (sem <> 0) ”
  &&  “ (lock = 0) ”
  &&  “ (resched = 0) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (delete_sem_id = (semaphore_id (original))) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  id_pre before_dataqueue_cleanup_ic after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic after )
  **  (CharArray.undef_full sem 32 )
) \/
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (original: SemaphoreAbs) (lock: Z) (resched: Z) (sem: Z) (idnode: Z) (delete_sem_id: Z) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (idnode_2: Z) (PreH1 : ((service_id ((os_recycle (before_dataqueue_cleanup_ic)))) <= INT_MAX)) (PreH2 : ((service_id ((os_recycle (before_dataqueue_cleanup_ic)))) >= INT_MIN)) (PreH3 : (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) (delete_sem_id)) = true)) (PreH4 : ( CRTOS_Verify.lib.id.IdModuleSpec.idmanager_contains  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) delete_sem_id idnode_2 )) (PreH5 : (idnode_2 <> 0)) (PreH6 : (&((idnode_2)  # "IdNode" ->ₛ "link") <> 0)) (PreH7 : (0 <= id_pre)) (PreH8 : (id_pre <= 65535)) (PreH9 : (lock = 0)) (PreH10 : (resched = 0)) (PreH11 : (sem = (semaphore_addr (original)))) (PreH12 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH13 : (delete_sem_id = (semaphore_id (original)))) (PreH14 : ((semaphore_id (original)) = id_pre)) (PreH15 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH16 : ((os_semaphores (before_dataqueue_cleanup_ic)) = (app (prefix) ((cons (original) (suffix)))))) (PreH17 : (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) )) (PreH18 : (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) ((semaphore_id (original)))) = true)) (PreH19 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )) (PreH20 : (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )) (PreH21 : (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) )),
  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((map (semaphore_link_node) (suffix)))) )
  **  (store_semaphore (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) &((sem)  # "Semaphore" ->ₛ "link") original )
  **  ( CRTOS_Verify.lib.list.NodeSelfLinked.store_node_self_linked  &((sem)  # "Semaphore" ->ₛ "link") )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_remove  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic))))) ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) (delete_sem_id)) ( &( "k_sem_id_manager" ) ) )
  **  ((&((idnode_2)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
|--
  EX (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ (sem = (semaphore_addr (original))) ”
  &&  “ (sem <> 0) ”
  &&  “ (lock = 0) ”
  &&  “ (resched = 0) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (delete_sem_id = (semaphore_id (original))) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  id_pre before_dataqueue_cleanup_ic after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic after )
  **  (CharArray.undef_full sem 32 )
).

Definition _SemaphoreDelete_return_wit_1 :=
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) = 0)) (PreH3 : (retval = 0)) (PreH4 : (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )) (PreH5 : (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) )) (PreH6 : (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) )) (PreH7 : (id_pre <= 65535)) (PreH8 : (id_pre >= 0)) (PreH9 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_cleanup_ic)))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
|--
  EX (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  id_pre before_dataqueue_cleanup_ic after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic after )
) \/
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (retval: Z) (PreH1 : ((service_id ((os_recycle (before_dataqueue_cleanup_ic)))) <= INT_MAX)) (PreH2 : ((service_id ((os_recycle (before_dataqueue_cleanup_ic)))) >= INT_MIN)) (PreH3 : (retval = 0)) (PreH4 : (( &( "k_sem_id_manager" ) ) = 0)) (PreH5 : (retval = 0)) (PreH6 : (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )) (PreH7 : (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) )) (PreH8 : (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) )) (PreH9 : (id_pre <= 65535)) (PreH10 : (id_pre >= 0)) (PreH11 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_cleanup_ic)))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
|--
  EX (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  id_pre before_dataqueue_cleanup_ic after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic after )
).

Definition _SemaphoreDelete_return_wit_2 :=
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval = 0)) (PreH4 : (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) (id_pre)) = false)) (PreH5 : (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )) (PreH6 : (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) )) (PreH7 : (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) )) (PreH8 : (id_pre <= 65535)) (PreH9 : (id_pre >= 0)) (PreH10 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_cleanup_ic)))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
|--
  EX (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  id_pre before_dataqueue_cleanup_ic after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic after )
) \/
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (retval: Z) (PreH1 : ((service_id ((os_recycle (before_dataqueue_cleanup_ic)))) <= INT_MAX)) (PreH2 : ((service_id ((os_recycle (before_dataqueue_cleanup_ic)))) >= INT_MIN)) (PreH3 : (retval = 0)) (PreH4 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH5 : (retval = 0)) (PreH6 : (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) (id_pre)) = false)) (PreH7 : (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )) (PreH8 : (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) )) (PreH9 : (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) )) (PreH10 : (id_pre <= 65535)) (PreH11 : (id_pre >= 0)) (PreH12 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_cleanup_ic)))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
|--
  EX (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  id_pre before_dataqueue_cleanup_ic after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic after )
).

Definition _SemaphoreDelete_return_wit_3 :=
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (PreH1 : (id_pre < 0)) (PreH2 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  EX (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  id_pre before_dataqueue_cleanup_ic after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic after )
) \/
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (id_pre: Z) (PreH1 : (id_pre < 0)) (PreH2 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  TT && emp 
|--
  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  id_pre before_dataqueue_cleanup_ic before_dataqueue_cleanup_ic ) ”
  &&  emp
).

Definition _SemaphoreDelete_return_wit_3_split_goal_1 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (id_pre: Z) (PreH1 : (id_pre < 0)) (PreH2 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  id_pre before_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
.

Definition _SemaphoreDelete_return_wit_4 :=
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (PreH1 : (id_pre > 65535)) (PreH2 : (id_pre >= 0)) (PreH3 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  EX (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  id_pre before_dataqueue_cleanup_ic after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic after )
) \/
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (id_pre: Z) (PreH1 : (id_pre > 65535)) (PreH2 : (id_pre >= 0)) (PreH3 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  TT && emp 
|--
  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  id_pre before_dataqueue_cleanup_ic before_dataqueue_cleanup_ic ) ”
  &&  emp
).

Definition _SemaphoreDelete_return_wit_4_split_goal_1 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (id_pre: Z) (PreH1 : (id_pre > 65535)) (PreH2 : (id_pre >= 0)) (PreH3 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  id_pre before_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
.

Definition _SemaphoreDelete_return_wit_5 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (original: SemaphoreAbs) (sem: Z) (lock: Z) (resched: Z) (idnode: Z) (delete_sem_id: Z) (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : (sem = (semaphore_addr (original)))) (PreH2 : (sem <> 0)) (PreH3 : (lock = 0)) (PreH4 : (resched = 0)) (PreH5 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH6 : (delete_sem_id = (semaphore_id (original)))) (PreH7 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  id_pre before_dataqueue_cleanup_ic after_2 )) (PreH8 : (resched = 0)),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic after_2 )
|--
  EX (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  id_pre before_dataqueue_cleanup_ic after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic after )
.

Definition _SemaphoreDelete_partial_solve_wit_1 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (PreH1 : (id_pre <= 65535)) (PreH2 : (id_pre >= 0)) (PreH3 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  “ (id_pre <= 65535) ”
  &&  “ (id_pre >= 0) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
.

Definition _SemaphoreDelete_partial_solve_wit_2_pure :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (PreH1 : (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )) (PreH2 : (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) )) (PreH3 : (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) )) (PreH4 : (id_pre <= 65535)) (PreH5 : (id_pre >= 0)) (PreH6 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_cleanup_ic)))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre < 65536) ”
.

Definition _SemaphoreDelete_partial_solve_wit_2_aux :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (PreH1 : (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )) (PreH2 : (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) )) (PreH3 : (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) )) (PreH4 : (id_pre <= 65535)) (PreH5 : (id_pre >= 0)) (PreH6 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_cleanup_ic)))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre < 65536) ”
  &&  “ (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic ) ”
  &&  “ (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) ) ”
  &&  “ (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) ) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (id_pre >= 0) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic ) ”
  &&  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_cleanup_ic)))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
.

Definition _SemaphoreDelete_partial_solve_wit_2 := _SemaphoreDelete_partial_solve_wit_2_pure -> _SemaphoreDelete_partial_solve_wit_2_aux.

Definition _SemaphoreDelete_partial_solve_wit_3_pure :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (lock: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (lock = 0)) (PreH4 : (resched = 0)) (PreH5 : (sem = 0)) (PreH6 : (In original (os_semaphores (before_dataqueue_cleanup_ic)) )) (PreH7 : ((semaphore_id (original)) = id_pre)) (PreH8 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH9 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH10 : ((semaphore_addr (original)) <> 0)) (PreH11 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
.

Definition _SemaphoreDelete_partial_solve_wit_3_aux :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (lock: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (lock = 0)) (PreH4 : (resched = 0)) (PreH5 : (sem = 0)) (PreH6 : (In original (os_semaphores (before_dataqueue_cleanup_ic)) )) (PreH7 : ((semaphore_id (original)) = id_pre)) (PreH8 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH9 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH10 : ((semaphore_addr (original)) <> 0)) (PreH11 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (lock = 0) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (In original (os_semaphores (before_dataqueue_cleanup_ic)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_pending_addrs (original)) = (@nil Z)) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ ((semaphore_addr (original)) <> 0) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
.

Definition _SemaphoreDelete_partial_solve_wit_3 := _SemaphoreDelete_partial_solve_wit_3_pure -> _SemaphoreDelete_partial_solve_wit_3_aux.

Definition _SemaphoreDelete_partial_solve_wit_4_pure :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (lock: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : (retval = (semaphore_addr (original)))) (PreH2 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : (lock = 0)) (PreH6 : (resched = 0)) (PreH7 : (sem = 0)) (PreH8 : (In original (os_semaphores (before_dataqueue_cleanup_ic)) )) (PreH9 : ((semaphore_id (original)) = id_pre)) (PreH10 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH11 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH12 : ((semaphore_addr (original)) <> 0)) (PreH13 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  “ (In original (os_semaphores (before_dataqueue_cleanup_ic)) ) ”
  &&  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
  &&  “ ((semaphore_pending_addrs (original)) = (@nil Z)) ”
.

Definition _SemaphoreDelete_partial_solve_wit_4_aux :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (lock: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : (retval = (semaphore_addr (original)))) (PreH2 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : (lock = 0)) (PreH6 : (resched = 0)) (PreH7 : (sem = 0)) (PreH8 : (In original (os_semaphores (before_dataqueue_cleanup_ic)) )) (PreH9 : ((semaphore_id (original)) = id_pre)) (PreH10 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH11 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH12 : ((semaphore_addr (original)) <> 0)) (PreH13 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  “ (In original (os_semaphores (before_dataqueue_cleanup_ic)) ) ”
  &&  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
  &&  “ ((semaphore_pending_addrs (original)) = (@nil Z)) ”
  &&  “ (retval = (semaphore_addr (original))) ”
  &&  “ (idnode = &((retval)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (lock = 0) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (In original (os_semaphores (before_dataqueue_cleanup_ic)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_pending_addrs (original)) = (@nil Z)) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ ((semaphore_addr (original)) <> 0) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic ) ”
  &&  ((( &( "sem" ) )) # Ptr  |-> (semaphore_addr (original)))
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
.

Definition _SemaphoreDelete_partial_solve_wit_4 := _SemaphoreDelete_partial_solve_wit_4_pure -> _SemaphoreDelete_partial_solve_wit_4_aux.

Definition _SemaphoreDelete_partial_solve_wit_5 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (lock: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : ((semaphore_addr (original)) = (semaphore_addr (original)))) (PreH2 : (retval = (semaphore_addr (original)))) (PreH3 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= 65535)) (PreH6 : (lock = 0)) (PreH7 : (resched = 0)) (PreH8 : (sem = 0)) (PreH9 : (In original (os_semaphores (before_dataqueue_cleanup_ic)) )) (PreH10 : ((semaphore_id (original)) = id_pre)) (PreH11 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH12 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH13 : ((semaphore_addr (original)) <> 0)) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list") (@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)) )
  **  (wand ( CRTOS_Verify.lib.common.dll.DLL.store_dll  ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic))))))) (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list")) ((@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg_dataqueue_cleanup_ic) (before_dataqueue_cleanup_ic)) )
|--
  “ (retval = (semaphore_addr (original))) ”
  &&  “ (idnode = &((retval)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (lock = 0) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (In original (os_semaphores (before_dataqueue_cleanup_ic)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_pending_addrs (original)) = (@nil Z)) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ ((semaphore_addr (original)) <> 0) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic ) ”
  &&  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list") (@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)) )
  **  (wand ( CRTOS_Verify.lib.common.dll.DLL.store_dll  ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic))))))) (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list")) ((@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg_dataqueue_cleanup_ic) (before_dataqueue_cleanup_ic)) )
.

Definition _SemaphoreDelete_partial_solve_wit_6_pure :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (lock: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 <> 0)) (PreH2 : (retval_2 = 1)) (PreH3 : ((@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)) = (@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)))) (PreH4 : (retval = (semaphore_addr (original)))) (PreH5 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH6 : (0 <= id_pre)) (PreH7 : (id_pre <= 65535)) (PreH8 : (lock = 0)) (PreH9 : (resched = 0)) (PreH10 : (sem = 0)) (PreH11 : (In original (os_semaphores (before_dataqueue_cleanup_ic)) )) (PreH12 : ((semaphore_id (original)) = id_pre)) (PreH13 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH14 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH15 : ((semaphore_addr (original)) <> 0)) (PreH16 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list") (@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)) )
  **  ((( &( "sem" ) )) # Ptr  |-> (semaphore_addr (original)))
  **  (wand ( CRTOS_Verify.lib.common.dll.DLL.store_dll  ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic))))))) (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list")) ((@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg_dataqueue_cleanup_ic) (before_dataqueue_cleanup_ic)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
|--
  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
.

Definition _SemaphoreDelete_partial_solve_wit_6_aux :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (lock: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 <> 0)) (PreH2 : (retval_2 = 1)) (PreH3 : ((@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)) = (@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)))) (PreH4 : (retval = (semaphore_addr (original)))) (PreH5 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH6 : (0 <= id_pre)) (PreH7 : (id_pre <= 65535)) (PreH8 : (lock = 0)) (PreH9 : (resched = 0)) (PreH10 : (sem = 0)) (PreH11 : (In original (os_semaphores (before_dataqueue_cleanup_ic)) )) (PreH12 : ((semaphore_id (original)) = id_pre)) (PreH13 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH14 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH15 : ((semaphore_addr (original)) <> 0)) (PreH16 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list") (@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)) )
  **  (wand ( CRTOS_Verify.lib.common.dll.DLL.store_dll  ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic))))))) (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list")) ((@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg_dataqueue_cleanup_ic) (before_dataqueue_cleanup_ic)) )
|--
  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
  &&  “ (retval_2 <> 0) ”
  &&  “ (retval_2 = 1) ”
  &&  “ (retval = (semaphore_addr (original))) ”
  &&  “ (idnode = &((retval)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (lock = 0) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (In original (os_semaphores (before_dataqueue_cleanup_ic)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_pending_addrs (original)) = (@nil Z)) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ ((semaphore_addr (original)) <> 0) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic ) ”
  &&  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list") (@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)) )
  **  (wand ( CRTOS_Verify.lib.common.dll.DLL.store_dll  ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic))))))) (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list")) ((@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg_dataqueue_cleanup_ic) (before_dataqueue_cleanup_ic)) )
.

Definition _SemaphoreDelete_partial_solve_wit_6 := _SemaphoreDelete_partial_solve_wit_6_pure -> _SemaphoreDelete_partial_solve_wit_6_aux.

Definition _SemaphoreDelete_partial_solve_wit_7_pure :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (lock: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : ((semaphore_addr (original)) = (semaphore_addr (original)))) (PreH2 : (retval_2 <> 0)) (PreH3 : (retval_2 = 1)) (PreH4 : (retval = (semaphore_addr (original)))) (PreH5 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH6 : (0 <= id_pre)) (PreH7 : (id_pre <= 65535)) (PreH8 : (lock = 0)) (PreH9 : (resched = 0)) (PreH10 : (sem = 0)) (PreH11 : (In original (os_semaphores (before_dataqueue_cleanup_ic)) )) (PreH12 : ((semaphore_id (original)) = id_pre)) (PreH13 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH14 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH15 : ((semaphore_addr (original)) <> 0)) (PreH16 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ((( &( "sem" ) )) # Ptr  |-> (semaphore_addr (original)))
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
|--
  “ (In original (os_semaphores (before_dataqueue_cleanup_ic)) ) ”
  &&  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
.

Definition _SemaphoreDelete_partial_solve_wit_7_aux :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (lock: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : ((semaphore_addr (original)) = (semaphore_addr (original)))) (PreH2 : (retval_2 <> 0)) (PreH3 : (retval_2 = 1)) (PreH4 : (retval = (semaphore_addr (original)))) (PreH5 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH6 : (0 <= id_pre)) (PreH7 : (id_pre <= 65535)) (PreH8 : (lock = 0)) (PreH9 : (resched = 0)) (PreH10 : (sem = 0)) (PreH11 : (In original (os_semaphores (before_dataqueue_cleanup_ic)) )) (PreH12 : ((semaphore_id (original)) = id_pre)) (PreH13 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH14 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH15 : ((semaphore_addr (original)) <> 0)) (PreH16 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  “ (In original (os_semaphores (before_dataqueue_cleanup_ic)) ) ”
  &&  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
  &&  “ (retval_2 <> 0) ”
  &&  “ (retval_2 = 1) ”
  &&  “ (retval = (semaphore_addr (original))) ”
  &&  “ (idnode = &((retval)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (lock = 0) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (In original (os_semaphores (before_dataqueue_cleanup_ic)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_pending_addrs (original)) = (@nil Z)) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ ((semaphore_addr (original)) <> 0) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
.

Definition _SemaphoreDelete_partial_solve_wit_7 := _SemaphoreDelete_partial_solve_wit_7_pure -> _SemaphoreDelete_partial_solve_wit_7_aux.

Definition _SemaphoreDelete_partial_solve_wit_8_pure :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (lock: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : ((semaphore_addr (original)) = (semaphore_addr (original)))) (PreH2 : (retval_2 <> 0)) (PreH3 : (retval_2 = 1)) (PreH4 : (retval = (semaphore_addr (original)))) (PreH5 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH6 : (0 <= id_pre)) (PreH7 : (id_pre <= 65535)) (PreH8 : (lock = 0)) (PreH9 : (resched = 0)) (PreH10 : (sem = 0)) (PreH11 : (In original (os_semaphores (before_dataqueue_cleanup_ic)) )) (PreH12 : ((semaphore_id (original)) = id_pre)) (PreH13 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH14 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH15 : ((semaphore_addr (original)) <> 0)) (PreH16 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ((( &( "delete_sem_id" ) )) # UShort  |-> (semaphore_id (original)))
  **  ((( &( "sem" ) )) # Ptr  |-> (semaphore_addr (original)))
  **  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id" .ₛ "id")) # UShort  |-> (semaphore_id (original)))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id" .ₛ "id")) ((semaphore_id (original)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg_dataqueue_cleanup_ic) (before_dataqueue_cleanup_ic)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
|--
  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
.

Definition _SemaphoreDelete_partial_solve_wit_8_aux :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (lock: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : ((semaphore_addr (original)) = (semaphore_addr (original)))) (PreH2 : (retval_2 <> 0)) (PreH3 : (retval_2 = 1)) (PreH4 : (retval = (semaphore_addr (original)))) (PreH5 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH6 : (0 <= id_pre)) (PreH7 : (id_pre <= 65535)) (PreH8 : (lock = 0)) (PreH9 : (resched = 0)) (PreH10 : (sem = 0)) (PreH11 : (In original (os_semaphores (before_dataqueue_cleanup_ic)) )) (PreH12 : ((semaphore_id (original)) = id_pre)) (PreH13 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH14 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH15 : ((semaphore_addr (original)) <> 0)) (PreH16 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )),
  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id" .ₛ "id")) # UShort  |-> (semaphore_id (original)))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id" .ₛ "id")) ((semaphore_id (original)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg_dataqueue_cleanup_ic) (before_dataqueue_cleanup_ic)) )
|--
  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
  &&  “ (retval_2 <> 0) ”
  &&  “ (retval_2 = 1) ”
  &&  “ (retval = (semaphore_addr (original))) ”
  &&  “ (idnode = &((retval)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (lock = 0) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (In original (os_semaphores (before_dataqueue_cleanup_ic)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_pending_addrs (original)) = (@nil Z)) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ ((semaphore_addr (original)) <> 0) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic ) ”
  &&  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id" .ₛ "id")) # UShort  |-> (semaphore_id (original)))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id" .ₛ "id")) ((semaphore_id (original)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg_dataqueue_cleanup_ic) (before_dataqueue_cleanup_ic)) )
.

Definition _SemaphoreDelete_partial_solve_wit_8 := _SemaphoreDelete_partial_solve_wit_8_pure -> _SemaphoreDelete_partial_solve_wit_8_aux.

Definition _SemaphoreDelete_partial_solve_wit_9_pure :=
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (original: SemaphoreAbs) (lock: Z) (resched: Z) (sem: Z) (idnode: Z) (delete_sem_id: Z) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (lock = 0)) (PreH4 : (resched = 0)) (PreH5 : (sem = (semaphore_addr (original)))) (PreH6 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH7 : (delete_sem_id = (semaphore_id (original)))) (PreH8 : ((semaphore_id (original)) = id_pre)) (PreH9 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH10 : ((os_semaphores (before_dataqueue_cleanup_ic)) = (app (prefix) ((cons (original) (suffix)))))) (PreH11 : (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) )) (PreH12 : (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) ((semaphore_id (original)))) = true)) (PreH13 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )) (PreH14 : (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )) (PreH15 : (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> delete_sem_id)
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((cons (( CRTOS_Verify.lib.common.dll_abs.Build_DL_Node  (original) (&((sem)  # "Semaphore" ->ₛ "link")))) ((map (semaphore_link_node) (suffix)))))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
|--
  “ (0 <= delete_sem_id) ”
  &&  “ (delete_sem_id < 65536) ”
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ”
) \/
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (original: SemaphoreAbs) (lock: Z) (resched: Z) (sem: Z) (idnode: Z) (delete_sem_id: Z) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : ((service_id ((os_recycle (before_dataqueue_cleanup_ic)))) <= INT_MAX)) (PreH2 : (resched <= INT_MAX)) (PreH3 : (lock <= INT_MAX)) (PreH4 : (id_pre <= INT_MAX)) (PreH5 : ((service_id ((os_recycle (before_dataqueue_cleanup_ic)))) >= INT_MIN)) (PreH6 : (resched >= INT_MIN)) (PreH7 : (lock >= INT_MIN)) (PreH8 : (id_pre >= INT_MIN)) (PreH9 : (0 <= id_pre)) (PreH10 : (id_pre <= 65535)) (PreH11 : (lock = 0)) (PreH12 : (resched = 0)) (PreH13 : (sem = (semaphore_addr (original)))) (PreH14 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH15 : (delete_sem_id = (semaphore_id (original)))) (PreH16 : ((semaphore_id (original)) = id_pre)) (PreH17 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH18 : ((os_semaphores (before_dataqueue_cleanup_ic)) = (app (prefix) ((cons (original) (suffix)))))) (PreH19 : (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) )) (PreH20 : (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) ((semaphore_id (original)))) = true)) (PreH21 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )) (PreH22 : (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )) (PreH23 : (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> delete_sem_id)
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((cons (( CRTOS_Verify.lib.common.dll_abs.Build_DL_Node  (original) (&((sem)  # "Semaphore" ->ₛ "link")))) ((map (semaphore_link_node) (suffix)))))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
|--
  “ (( &( "k_sem_id_manager" ) ) <> 0) ”
).

Definition _SemaphoreDelete_partial_solve_wit_9_pure_split_goal_1 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (original: SemaphoreAbs) (lock: Z) (resched: Z) (sem: Z) (idnode: Z) (delete_sem_id: Z) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : ((service_id ((os_recycle (before_dataqueue_cleanup_ic)))) <= INT_MAX)) (PreH2 : (resched <= INT_MAX)) (PreH3 : (lock <= INT_MAX)) (PreH4 : (id_pre <= INT_MAX)) (PreH5 : ((service_id ((os_recycle (before_dataqueue_cleanup_ic)))) >= INT_MIN)) (PreH6 : (resched >= INT_MIN)) (PreH7 : (lock >= INT_MIN)) (PreH8 : (id_pre >= INT_MIN)) (PreH9 : (0 <= id_pre)) (PreH10 : (id_pre <= 65535)) (PreH11 : (lock = 0)) (PreH12 : (resched = 0)) (PreH13 : (sem = (semaphore_addr (original)))) (PreH14 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH15 : (delete_sem_id = (semaphore_id (original)))) (PreH16 : ((semaphore_id (original)) = id_pre)) (PreH17 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH18 : ((os_semaphores (before_dataqueue_cleanup_ic)) = (app (prefix) ((cons (original) (suffix)))))) (PreH19 : (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) )) (PreH20 : (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) ((semaphore_id (original)))) = true)) (PreH21 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )) (PreH22 : (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )) (PreH23 : (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> delete_sem_id)
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((cons (( CRTOS_Verify.lib.common.dll_abs.Build_DL_Node  (original) (&((sem)  # "Semaphore" ->ₛ "link")))) ((map (semaphore_link_node) (suffix)))))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
|--
  “ (( &( "k_sem_id_manager" ) ) <> 0) ”
.

Definition _SemaphoreDelete_partial_solve_wit_9_aux :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (original: SemaphoreAbs) (lock: Z) (resched: Z) (sem: Z) (idnode: Z) (delete_sem_id: Z) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (lock = 0)) (PreH4 : (resched = 0)) (PreH5 : (sem = (semaphore_addr (original)))) (PreH6 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH7 : (delete_sem_id = (semaphore_id (original)))) (PreH8 : ((semaphore_id (original)) = id_pre)) (PreH9 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH10 : ((os_semaphores (before_dataqueue_cleanup_ic)) = (app (prefix) ((cons (original) (suffix)))))) (PreH11 : (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) )) (PreH12 : (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) ((semaphore_id (original)))) = true)) (PreH13 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )) (PreH14 : (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )) (PreH15 : (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) )),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((cons (( CRTOS_Verify.lib.common.dll_abs.Build_DL_Node  (original) (&((sem)  # "Semaphore" ->ₛ "link")))) ((map (semaphore_link_node) (suffix)))))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
|--
  “ (0 <= delete_sem_id) ”
  &&  “ (delete_sem_id < 65536) ”
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (lock = 0) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (delete_sem_id = (semaphore_id (original))) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_pending_addrs (original)) = (@nil Z)) ”
  &&  “ ((os_semaphores (before_dataqueue_cleanup_ic)) = (app (prefix) ((cons (original) (suffix))))) ”
  &&  “ (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) ) ”
  &&  “ (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) ((semaphore_id (original)))) = true) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic ) ”
  &&  “ (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic ) ”
  &&  “ (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) ) ”
  &&  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((cons (( CRTOS_Verify.lib.common.dll_abs.Build_DL_Node  (original) (&((sem)  # "Semaphore" ->ₛ "link")))) ((map (semaphore_link_node) (suffix)))))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
.

Definition _SemaphoreDelete_partial_solve_wit_9 := _SemaphoreDelete_partial_solve_wit_9_pure -> _SemaphoreDelete_partial_solve_wit_9_aux.

Definition _SemaphoreDelete_partial_solve_wit_10 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (original: SemaphoreAbs) (lock: Z) (resched: Z) (sem: Z) (idnode: Z) (delete_sem_id: Z) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) (delete_sem_id)) = false)) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre <= 65535)) (PreH4 : (lock = 0)) (PreH5 : (resched = 0)) (PreH6 : (sem = (semaphore_addr (original)))) (PreH7 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH8 : (delete_sem_id = (semaphore_id (original)))) (PreH9 : ((semaphore_id (original)) = id_pre)) (PreH10 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH11 : ((os_semaphores (before_dataqueue_cleanup_ic)) = (app (prefix) ((cons (original) (suffix)))))) (PreH12 : (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) )) (PreH13 : (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) ((semaphore_id (original)))) = true)) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )) (PreH15 : (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )) (PreH16 : (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) )),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((cons (( CRTOS_Verify.lib.common.dll_abs.Build_DL_Node  (original) (&((sem)  # "Semaphore" ->ₛ "link")))) ((map (semaphore_link_node) (suffix)))))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
|--
  “ (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) (delete_sem_id)) = false) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (lock = 0) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (delete_sem_id = (semaphore_id (original))) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_pending_addrs (original)) = (@nil Z)) ”
  &&  “ ((os_semaphores (before_dataqueue_cleanup_ic)) = (app (prefix) ((cons (original) (suffix))))) ”
  &&  “ (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) ) ”
  &&  “ (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) ((semaphore_id (original)))) = true) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic ) ”
  &&  “ (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic ) ”
  &&  “ (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) ) ”
  &&  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((cons (( CRTOS_Verify.lib.common.dll_abs.Build_DL_Node  (original) (&((sem)  # "Semaphore" ->ₛ "link")))) ((map (semaphore_link_node) (suffix)))))) )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
.

Definition _SemaphoreDelete_partial_solve_wit_11 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (original: SemaphoreAbs) (lock: Z) (resched: Z) (sem: Z) (idnode: Z) (delete_sem_id: Z) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (idnode_2: Z) (PreH1 : (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) (delete_sem_id)) = true)) (PreH2 : ( CRTOS_Verify.lib.id.IdModuleSpec.idmanager_contains  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) delete_sem_id idnode_2 )) (PreH3 : (idnode_2 <> 0)) (PreH4 : (&((idnode_2)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : (lock = 0)) (PreH8 : (resched = 0)) (PreH9 : (sem = (semaphore_addr (original)))) (PreH10 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH11 : (delete_sem_id = (semaphore_id (original)))) (PreH12 : ((semaphore_id (original)) = id_pre)) (PreH13 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH14 : ((os_semaphores (before_dataqueue_cleanup_ic)) = (app (prefix) ((cons (original) (suffix)))))) (PreH15 : (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) )) (PreH16 : (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) ((semaphore_id (original)))) = true)) (PreH17 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic )) (PreH18 : (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )) (PreH19 : (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) )),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_remove  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic))))) ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) (delete_sem_id)) ( &( "k_sem_id_manager" ) ) )
  **  ((&((idnode_2)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((cons (( CRTOS_Verify.lib.common.dll_abs.Build_DL_Node  (original) (&((sem)  # "Semaphore" ->ₛ "link")))) ((map (semaphore_link_node) (suffix)))))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
|--
  “ (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) (delete_sem_id)) = true) ”
  &&  “ ( CRTOS_Verify.lib.id.IdModuleSpec.idmanager_contains  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) delete_sem_id idnode_2 ) ”
  &&  “ (idnode_2 <> 0) ”
  &&  “ (&((idnode_2)  # "IdNode" ->ₛ "link") <> 0) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (lock = 0) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (delete_sem_id = (semaphore_id (original))) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_pending_addrs (original)) = (@nil Z)) ”
  &&  “ ((os_semaphores (before_dataqueue_cleanup_ic)) = (app (prefix) ((cons (original) (suffix))))) ”
  &&  “ (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) ) ”
  &&  “ (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query  ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) ((semaphore_id (original)))) = true) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  id_pre before_dataqueue_cleanup_ic ) ”
  &&  “ (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic ) ”
  &&  “ (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) ) ”
  &&  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((cons (( CRTOS_Verify.lib.common.dll_abs.Build_DL_Node  (original) (&((sem)  # "Semaphore" ->ₛ "link")))) ((map (semaphore_link_node) (suffix)))))) )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_remove  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic))))) ((semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic))))) (delete_sem_id)) ( &( "k_sem_id_manager" ) ) )
  **  ((&((idnode_2)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
.

Definition _SemaphoreDelete_partial_solve_wit_12_pure :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (original: SemaphoreAbs) (sem: Z) (lock: Z) (resched: Z) (idnode: Z) (delete_sem_id: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : (sem = (semaphore_addr (original)))) (PreH2 : (sem <> 0)) (PreH3 : (lock = 0)) (PreH4 : (resched = 0)) (PreH5 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH6 : (delete_sem_id = (semaphore_id (original)))) (PreH7 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  id_pre before_dataqueue_cleanup_ic after )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> delete_sem_id)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic after )
  **  (CharArray.undef_full sem 32 )
|--
  “ (sem <> 0) ”
  &&  “ (0 < 32) ”
.

Definition _SemaphoreDelete_partial_solve_wit_12_aux :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (id_pre: Z) (original: SemaphoreAbs) (sem: Z) (lock: Z) (resched: Z) (idnode: Z) (delete_sem_id: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : (sem = (semaphore_addr (original)))) (PreH2 : (sem <> 0)) (PreH3 : (lock = 0)) (PreH4 : (resched = 0)) (PreH5 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH6 : (delete_sem_id = (semaphore_id (original)))) (PreH7 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  id_pre before_dataqueue_cleanup_ic after )),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic after )
  **  (CharArray.undef_full sem 32 )
|--
  “ (sem <> 0) ”
  &&  “ (0 < 32) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (sem <> 0) ”
  &&  “ (lock = 0) ”
  &&  “ (resched = 0) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (delete_sem_id = (semaphore_id (original))) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  id_pre before_dataqueue_cleanup_ic after ) ”
  &&  (CharArray.undef_full sem 32 )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic after )
.

Definition _SemaphoreDelete_partial_solve_wit_12 := _SemaphoreDelete_partial_solve_wit_12_pure -> _SemaphoreDelete_partial_solve_wit_12_aux.

Definition _SemaphoreDelete_which_implies_wit_1 :=
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  “ (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic ) ”
  &&  “ (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) ) ”
  &&  “ (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) ) ”
  &&  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_cleanup_ic)))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
) \/
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  “ (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) ) ”
  &&  “ (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) ) ”
  &&  “ (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic ) ”
  &&  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_cleanup_ic)))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
).

Definition _SemaphoreDelete_which_implies_wit_1_split_goal_1 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  “ (NoDup (map (semaphore_id) ((os_semaphores (before_dataqueue_cleanup_ic)))) ) ”
.

Definition _SemaphoreDelete_which_implies_wit_1_split_goal_2 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  “ (semaphore_context (os_semaphore_stable (sg_dataqueue_cleanup_ic)) ) ”
.

Definition _SemaphoreDelete_which_implies_wit_1_split_goal_3 :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  “ (os_world_wf sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic ) ”
.

Definition _SemaphoreDelete_which_implies_wit_1_split_goal_spatial :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_cleanup_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_cleanup_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_cleanup_ic)))) )
  **  (task_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (tick_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (delay_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (assign_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))) (os_zombie_head (sg_dataqueue_cleanup_ic)) (zombie_queue (before_dataqueue_cleanup_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_cleanup_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_cleanup_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_cleanup_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_cleanup_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_mutex_stable (sg_dataqueue_cleanup_ic)) (os_mutexes (before_dataqueue_cleanup_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) (os_event_stable (sg_dataqueue_cleanup_ic)) (os_events (before_dataqueue_cleanup_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_cleanup_ic)) (os_isr (before_dataqueue_cleanup_ic)) )
  **  (exstatus_inv sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_cleanup_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_cleanup_ic)) )
.

Definition _SemaphoreDelete_which_implies_wit_2 :=
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (original: SemaphoreAbs) (sem: Z) (PreH1 : (In original (os_semaphores (before_dataqueue_cleanup_ic)) )) (PreH2 : (sem = (semaphore_addr (original)))) (PreH3 : ((semaphore_pending_addrs (original)) = (@nil Z))),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  “ (sem = (semaphore_addr (original))) ”
  &&  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) &((sem)  # "Semaphore" ->ₛ "pend_list") (@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)) )
  **  (wand ( CRTOS_Verify.lib.common.dll.DLL.store_dll  ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic))))))) (&((sem)  # "Semaphore" ->ₛ "pend_list")) ((@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg_dataqueue_cleanup_ic) (before_dataqueue_cleanup_ic)) )
) \/
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (original: SemaphoreAbs) (sem: Z) (PreH1 : (In original (os_semaphores (before_dataqueue_cleanup_ic)) )) (PreH2 : (sem = (semaphore_addr (original)))) (PreH3 : ((semaphore_pending_addrs (original)) = (@nil Z))),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) &((sem)  # "Semaphore" ->ₛ "pend_list") (@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)) )
  **  (wand ( CRTOS_Verify.lib.common.dll.DLL.store_dll  ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic))))))) (&((sem)  # "Semaphore" ->ₛ "pend_list")) ((@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg_dataqueue_cleanup_ic) (before_dataqueue_cleanup_ic)) )
).

Definition _SemaphoreDelete_which_implies_wit_2_split_goal_spatial :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (original: SemaphoreAbs) (sem: Z) (PreH1 : (In original (os_semaphores (before_dataqueue_cleanup_ic)) )) (PreH2 : (sem = (semaphore_addr (original)))) (PreH3 : ((semaphore_pending_addrs (original)) = (@nil Z))),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) &((sem)  # "Semaphore" ->ₛ "pend_list") (@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)) )
  **  (wand ( CRTOS_Verify.lib.common.dll.DLL.store_dll  ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic))))))) (&((sem)  # "Semaphore" ->ₛ "pend_list")) ((@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg_dataqueue_cleanup_ic) (before_dataqueue_cleanup_ic)) )
.

Definition _SemaphoreDelete_which_implies_wit_3 :=
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (original: SemaphoreAbs) (sem: Z) (PreH1 : (sem = (semaphore_addr (original)))),
  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) &((sem)  # "Semaphore" ->ₛ "pend_list") (@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)) )
  **  (wand ( CRTOS_Verify.lib.common.dll.DLL.store_dll  ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic))))))) (&((sem)  # "Semaphore" ->ₛ "pend_list")) ((@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg_dataqueue_cleanup_ic) (before_dataqueue_cleanup_ic)) )
|--
  “ (sem = (semaphore_addr (original))) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
) \/
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (original: SemaphoreAbs) (sem: Z) (PreH1 : (sem = (semaphore_addr (original)))),
  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) &((sem)  # "Semaphore" ->ₛ "pend_list") (@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)) )
  **  (wand ( CRTOS_Verify.lib.common.dll.DLL.store_dll  ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic))))))) (&((sem)  # "Semaphore" ->ₛ "pend_list")) ((@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg_dataqueue_cleanup_ic) (before_dataqueue_cleanup_ic)) )
|--
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
).

Definition _SemaphoreDelete_which_implies_wit_3_split_goal_spatial :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (original: SemaphoreAbs) (sem: Z) (PreH1 : (sem = (semaphore_addr (original)))),
  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic)))))) &((sem)  # "Semaphore" ->ₛ "pend_list") (@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)) )
  **  (wand ( CRTOS_Verify.lib.common.dll.DLL.store_dll  ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_cleanup_ic))))))) (&((sem)  # "Semaphore" ->ₛ "pend_list")) ((@nil (@ CRTOS_Verify.lib.common.dll_abs.DL_Node  Z)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg_dataqueue_cleanup_ic) (before_dataqueue_cleanup_ic)) )
|--
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
.

Definition _SemaphoreDelete_which_implies_wit_4 :=
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (original: SemaphoreAbs) (sem: Z) (PreH1 : (In original (os_semaphores (before_dataqueue_cleanup_ic)) )) (PreH2 : (sem = (semaphore_addr (original)))),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  “ (sem = (semaphore_addr (original))) ”
  &&  ((&((sem)  # "Semaphore" ->ₛ "id" .ₛ "id")) # UShort  |-> (semaphore_id (original)))
  **  (wand (store_ushort (&((sem)  # "Semaphore" ->ₛ "id" .ₛ "id")) ((semaphore_id (original)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg_dataqueue_cleanup_ic) (before_dataqueue_cleanup_ic)) )
) \/
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (original: SemaphoreAbs) (sem: Z) (PreH1 : (In original (os_semaphores (before_dataqueue_cleanup_ic)) )) (PreH2 : (sem = (semaphore_addr (original)))),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  ((&((sem)  # "Semaphore" ->ₛ "id" .ₛ "id")) # UShort  |-> (semaphore_id (original)))
  **  (wand (store_ushort (&((sem)  # "Semaphore" ->ₛ "id" .ₛ "id")) ((semaphore_id (original)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg_dataqueue_cleanup_ic) (before_dataqueue_cleanup_ic)) )
).

Definition _SemaphoreDelete_which_implies_wit_4_split_goal_spatial :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (original: SemaphoreAbs) (sem: Z) (PreH1 : (In original (os_semaphores (before_dataqueue_cleanup_ic)) )) (PreH2 : (sem = (semaphore_addr (original)))),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
|--
  ((&((sem)  # "Semaphore" ->ₛ "id" .ₛ "id")) # UShort  |-> (semaphore_id (original)))
  **  (wand (store_ushort (&((sem)  # "Semaphore" ->ₛ "id" .ₛ "id")) ((semaphore_id (original)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg_dataqueue_cleanup_ic) (before_dataqueue_cleanup_ic)) )
.

Definition _SemaphoreDelete_which_implies_wit_5 :=
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (original: SemaphoreAbs) (sem: Z) (PreH1 : (sem = (semaphore_addr (original)))),
  ((&((sem)  # "Semaphore" ->ₛ "id" .ₛ "id")) # UShort  |-> (semaphore_id (original)))
  **  (wand (store_ushort (&((sem)  # "Semaphore" ->ₛ "id" .ₛ "id")) ((semaphore_id (original)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg_dataqueue_cleanup_ic) (before_dataqueue_cleanup_ic)) )
|--
  “ (sem = (semaphore_addr (original))) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
) \/
(
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (original: SemaphoreAbs) (sem: Z) (PreH1 : (sem = (semaphore_addr (original)))),
  ((&((sem)  # "Semaphore" ->ₛ "id" .ₛ "id")) # UShort  |-> (semaphore_id (original)))
  **  (wand (store_ushort (&((sem)  # "Semaphore" ->ₛ "id" .ₛ "id")) ((semaphore_id (original)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg_dataqueue_cleanup_ic) (before_dataqueue_cleanup_ic)) )
|--
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
).

Definition _SemaphoreDelete_which_implies_wit_5_split_goal_spatial :=
forall (before_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_cleanup_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (original: SemaphoreAbs) (sem: Z) (PreH1 : (sem = (semaphore_addr (original)))),
  ((&((sem)  # "Semaphore" ->ₛ "id" .ₛ "id")) # UShort  |-> (semaphore_id (original)))
  **  (wand (store_ushort (&((sem)  # "Semaphore" ->ₛ "id" .ₛ "id")) ((semaphore_id (original)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg_dataqueue_cleanup_ic) (before_dataqueue_cleanup_ic)) )
|--
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_cleanup_ic before_dataqueue_cleanup_ic )
.

Module Type VC_Correct.


Axiom proof_of__SemaphoreDelete_safety_wit_1 : _SemaphoreDelete_safety_wit_1.
Axiom proof_of__SemaphoreDelete_safety_wit_2 : _SemaphoreDelete_safety_wit_2.
Axiom proof_of__SemaphoreDelete_safety_wit_3 : _SemaphoreDelete_safety_wit_3.
Axiom proof_of__SemaphoreDelete_safety_wit_4 : _SemaphoreDelete_safety_wit_4.
Axiom proof_of__SemaphoreDelete_safety_wit_5 : _SemaphoreDelete_safety_wit_5.
Axiom proof_of__SemaphoreDelete_safety_wit_6 : _SemaphoreDelete_safety_wit_6.
Axiom proof_of__SemaphoreDelete_safety_wit_7 : _SemaphoreDelete_safety_wit_7.
Axiom proof_of__SemaphoreDelete_safety_wit_8 : _SemaphoreDelete_safety_wit_8.
Axiom proof_of__SemaphoreDelete_safety_wit_9 : _SemaphoreDelete_safety_wit_9.
Axiom proof_of__SemaphoreDelete_safety_wit_10 : _SemaphoreDelete_safety_wit_10.
Axiom proof_of__SemaphoreDelete_safety_wit_11 : _SemaphoreDelete_safety_wit_11.
Axiom proof_of__SemaphoreDelete_safety_wit_12 : _SemaphoreDelete_safety_wit_12.
Axiom proof_of__SemaphoreDelete_safety_wit_13 : _SemaphoreDelete_safety_wit_13.
Axiom proof_of__SemaphoreDelete_safety_wit_14 : _SemaphoreDelete_safety_wit_14.
Axiom proof_of__SemaphoreDelete_safety_wit_15 : _SemaphoreDelete_safety_wit_15.
Axiom proof_of__SemaphoreDelete_entail_wit_1 : _SemaphoreDelete_entail_wit_1.
Axiom proof_of__SemaphoreDelete_entail_wit_2 : _SemaphoreDelete_entail_wit_2.
Axiom proof_of__SemaphoreDelete_entail_wit_3_1 : _SemaphoreDelete_entail_wit_3_1.
Axiom proof_of__SemaphoreDelete_entail_wit_3_2 : _SemaphoreDelete_entail_wit_3_2.
Axiom proof_of__SemaphoreDelete_return_wit_1 : _SemaphoreDelete_return_wit_1.
Axiom proof_of__SemaphoreDelete_return_wit_2 : _SemaphoreDelete_return_wit_2.
Axiom proof_of__SemaphoreDelete_return_wit_3 : _SemaphoreDelete_return_wit_3.
Axiom proof_of__SemaphoreDelete_return_wit_4 : _SemaphoreDelete_return_wit_4.
Axiom proof_of__SemaphoreDelete_return_wit_5 : _SemaphoreDelete_return_wit_5.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_1 : _SemaphoreDelete_partial_solve_wit_1.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_2_pure : _SemaphoreDelete_partial_solve_wit_2_pure.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_2 : _SemaphoreDelete_partial_solve_wit_2.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_3_pure : _SemaphoreDelete_partial_solve_wit_3_pure.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_3 : _SemaphoreDelete_partial_solve_wit_3.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_4_pure : _SemaphoreDelete_partial_solve_wit_4_pure.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_4 : _SemaphoreDelete_partial_solve_wit_4.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_5 : _SemaphoreDelete_partial_solve_wit_5.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_6_pure : _SemaphoreDelete_partial_solve_wit_6_pure.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_6 : _SemaphoreDelete_partial_solve_wit_6.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_7_pure : _SemaphoreDelete_partial_solve_wit_7_pure.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_7 : _SemaphoreDelete_partial_solve_wit_7.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_8_pure : _SemaphoreDelete_partial_solve_wit_8_pure.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_8 : _SemaphoreDelete_partial_solve_wit_8.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_9_pure : _SemaphoreDelete_partial_solve_wit_9_pure.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_9 : _SemaphoreDelete_partial_solve_wit_9.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_10 : _SemaphoreDelete_partial_solve_wit_10.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_11 : _SemaphoreDelete_partial_solve_wit_11.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_12_pure : _SemaphoreDelete_partial_solve_wit_12_pure.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_12 : _SemaphoreDelete_partial_solve_wit_12.
Axiom proof_of__SemaphoreDelete_which_implies_wit_1 : _SemaphoreDelete_which_implies_wit_1.
Axiom proof_of__SemaphoreDelete_which_implies_wit_2 : _SemaphoreDelete_which_implies_wit_2.
Axiom proof_of__SemaphoreDelete_which_implies_wit_3 : _SemaphoreDelete_which_implies_wit_3.
Axiom proof_of__SemaphoreDelete_which_implies_wit_4 : _SemaphoreDelete_which_implies_wit_4.
Axiom proof_of__SemaphoreDelete_which_implies_wit_5 : _SemaphoreDelete_which_implies_wit_5.

End VC_Correct.
