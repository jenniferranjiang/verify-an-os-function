From SimpleC.Verification Require Import VCPrelude.
Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreDelete.
Require Import CRTOS_Verify.lib.id.idnode CRTOS_Verify.lib.id.IdModuleSpec CRTOS_Verify.lib.common.dll CRTOS_Verify.lib.list.NodeSelfLinked.
Import IDNode DLL.
Local Open Scope sac.

(*----- Function _SemaphoreCreate -----*)

Definition _SemaphoreCreate_safety_wit_1 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z),
  ((( &( "id" ) )) # Int  |->_)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_2 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z),
  ((( &( "lock" ) )) # Int  |->_)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_3 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z),
  ((( &( "sem" ) )) # Ptr  |->_)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_4 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z),
  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ (32 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 32) ”
.

Definition _SemaphoreCreate_safety_wit_5 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (retval: Z) (PreH1 : (32 = 0)) (PreH2 : (retval = 0)),
  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ False ”
.

Definition _SemaphoreCreate_safety_wit_6 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (retval: Z) (PreH1 : (32 > 0)) (PreH2 : (retval = 0)),
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_7 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (retval: Z) (PreH1 : (32 > 0)) (PreH2 : (retval > 0)) (PreH3 : (retval <= (UINT_MAX - 32 ))) (PreH4 : (addr_aligned retval 4 )),
  (CharArray.undef_full retval 32 )
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_8 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (32 > 0)) (PreH3 : (retval = 0)),
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ False ”
.

Definition _SemaphoreCreate_safety_wit_9 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (32 > 0)) (PreH3 : (retval > 0)) (PreH4 : (retval <= (UINT_MAX - 32 ))) (PreH5 : (addr_aligned retval 4 )),
  (CharArray.undef_full retval 32 )
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ False ”
.

Definition _SemaphoreCreate_safety_wit_10 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (32 > 0)) (PreH3 : (retval = 0)),
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ (5 <> (INT_MIN)) ”
.

Definition _SemaphoreCreate_safety_wit_11 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (32 > 0)) (PreH3 : (retval = 0)),
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ (5 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 5) ”
.

Definition _SemaphoreCreate_safety_wit_12 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (32 > 0)) (PreH3 : (retval > 0)) (PreH4 : (retval <= (UINT_MAX - 32 ))) (PreH5 : (addr_aligned retval 4 )),
  (CharArray.undef_full retval 32 )
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_13 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (32 > 0)) (PreH3 : (retval > 0)) (PreH4 : (retval <= (UINT_MAX - 32 ))) (PreH5 : (addr_aligned retval 4 )),
  (CharArray.undef_full retval 32 )
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ (32 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 32) ”
.

Definition _SemaphoreCreate_safety_wit_14 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (retval: Z) (PreH1 : (retval = (-1))) (PreH2 : (lock = 0)) (PreH3 : (id = 0)) (PreH4 : (0 <= val_pre)) (PreH5 : (val_pre <= 65535)) (PreH6 : (sem <> 0)) (PreH7 : (addr_aligned sem 4 )) (PreH8 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH10 : (os_world_wf sg_dataqueue_ic before_dataqueue_ic )) (PreH11 : (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) )) (PreH12 : ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) ))),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idnode_insert_ready  &((sem)  # "Semaphore" ->ₛ "id") )
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_15 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (retval: Z) (PreH1 : ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_min_free_id  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) retval )) (PreH2 : (lock = 0)) (PreH3 : (id = 0)) (PreH4 : (0 <= val_pre)) (PreH5 : (val_pre <= 65535)) (PreH6 : (sem <> 0)) (PreH7 : (addr_aligned sem 4 )) (PreH8 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH10 : (os_world_wf sg_dataqueue_ic before_dataqueue_ic )) (PreH11 : (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) )) (PreH12 : ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) ))),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) ( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic))))) (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add  ((semaphore_manager ((os_semaphores (before_dataqueue_ic))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_16 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (retval: Z) (PreH1 : (retval >= 0)) (PreH2 : (retval = (-1))) (PreH3 : (lock = 0)) (PreH4 : (id = 0)) (PreH5 : (0 <= val_pre)) (PreH6 : (val_pre <= 65535)) (PreH7 : (sem <> 0)) (PreH8 : (addr_aligned sem 4 )) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH10 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH11 : (os_world_wf sg_dataqueue_ic before_dataqueue_ic )) (PreH12 : (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) )) (PreH13 : ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) ))),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idnode_insert_ready  &((sem)  # "Semaphore" ->ₛ "id") )
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  “ False ”
.

Definition _SemaphoreCreate_safety_wit_17 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (PreH1 : (lock = 0)) (PreH2 : (id = (-1))) (PreH3 : (sem <> 0)),
  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ (5 <> (INT_MIN)) ”
.

Definition _SemaphoreCreate_safety_wit_18 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (PreH1 : (lock = 0)) (PreH2 : (id = (-1))) (PreH3 : (sem <> 0)),
  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ (5 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 5) ”
.

Definition _SemaphoreCreate_entail_wit_1 :=
(
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 = retval)) (PreH2 : (retval <> 0)) (PreH3 : (32 > 0)) (PreH4 : (retval > 0)) (PreH5 : (retval <= (UINT_MAX - 32 ))) (PreH6 : (addr_aligned retval 4 )),
  (CharArray.full retval 32 (repeat_Z (0) (32)) )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ (0 = 0) ”
  &&  “ (0 = 0) ”
  &&  “ (0 <= val_pre) ”
  &&  “ (val_pre <= 65535) ”
  &&  “ (retval <> 0) ”
  &&  “ (addr_aligned retval 4 ) ”
  &&  “ (&((retval)  # "Semaphore" ->ₛ "pend_list") <> 0) ”
  &&  “ (&((retval)  # "Semaphore" ->ₛ "link") <> 0) ”
  &&  “ (os_world_wf sg_dataqueue_ic before_dataqueue_ic ) ”
  &&  “ (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) ) ”
  &&  “ ~((In retval (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) )) ”
  &&  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idnode_insert_ready  &((retval)  # "Semaphore" ->ₛ "id") )
  **  ((&((retval)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((retval)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding retval )
) \/
(
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 = retval)) (PreH2 : (retval <> 0)) (PreH3 : (32 > 0)) (PreH4 : (retval > 0)) (PreH5 : (retval <= (UINT_MAX - 32 ))) (PreH6 : (addr_aligned retval 4 )),
  (CharArray.full retval 32 (repeat_Z (0) (32)) )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ ~((In retval (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) )) ”
  &&  “ (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) ) ”
  &&  “ (os_world_wf sg_dataqueue_ic before_dataqueue_ic ) ”
  &&  “ (&((retval)  # "Semaphore" ->ₛ "link") <> 0) ”
  &&  “ (&((retval)  # "Semaphore" ->ₛ "pend_list") <> 0) ”
  &&  “ (val_pre <= 65535) ”
  &&  “ (0 <= val_pre) ”
  &&  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idnode_insert_ready  &((retval)  # "Semaphore" ->ₛ "id") )
  **  ((&((retval)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((retval)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding retval )
).

Definition _SemaphoreCreate_entail_wit_1_split_goal_1 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 = retval)) (PreH2 : (retval <> 0)) (PreH3 : (32 > 0)) (PreH4 : (retval > 0)) (PreH5 : (retval <= (UINT_MAX - 32 ))) (PreH6 : (addr_aligned retval 4 )),
  (CharArray.full retval 32 (repeat_Z (0) (32)) )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ ~((In retval (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) )) ”
.

Definition _SemaphoreCreate_entail_wit_1_split_goal_2 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 = retval)) (PreH2 : (retval <> 0)) (PreH3 : (32 > 0)) (PreH4 : (retval > 0)) (PreH5 : (retval <= (UINT_MAX - 32 ))) (PreH6 : (addr_aligned retval 4 )),
  (CharArray.full retval 32 (repeat_Z (0) (32)) )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) ) ”
.

Definition _SemaphoreCreate_entail_wit_1_split_goal_3 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 = retval)) (PreH2 : (retval <> 0)) (PreH3 : (32 > 0)) (PreH4 : (retval > 0)) (PreH5 : (retval <= (UINT_MAX - 32 ))) (PreH6 : (addr_aligned retval 4 )),
  (CharArray.full retval 32 (repeat_Z (0) (32)) )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ (os_world_wf sg_dataqueue_ic before_dataqueue_ic ) ”
.

Definition _SemaphoreCreate_entail_wit_1_split_goal_4 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 = retval)) (PreH2 : (retval <> 0)) (PreH3 : (32 > 0)) (PreH4 : (retval > 0)) (PreH5 : (retval <= (UINT_MAX - 32 ))) (PreH6 : (addr_aligned retval 4 )),
  (CharArray.full retval 32 (repeat_Z (0) (32)) )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ (&((retval)  # "Semaphore" ->ₛ "link") <> 0) ”
.

Definition _SemaphoreCreate_entail_wit_1_split_goal_5 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 = retval)) (PreH2 : (retval <> 0)) (PreH3 : (32 > 0)) (PreH4 : (retval > 0)) (PreH5 : (retval <= (UINT_MAX - 32 ))) (PreH6 : (addr_aligned retval 4 )),
  (CharArray.full retval 32 (repeat_Z (0) (32)) )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ (&((retval)  # "Semaphore" ->ₛ "pend_list") <> 0) ”
.

Definition _SemaphoreCreate_entail_wit_1_split_goal_6 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 = retval)) (PreH2 : (retval <> 0)) (PreH3 : (32 > 0)) (PreH4 : (retval > 0)) (PreH5 : (retval <= (UINT_MAX - 32 ))) (PreH6 : (addr_aligned retval 4 )),
  (CharArray.full retval 32 (repeat_Z (0) (32)) )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ (val_pre <= 65535) ”
.

Definition _SemaphoreCreate_entail_wit_1_split_goal_7 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 = retval)) (PreH2 : (retval <> 0)) (PreH3 : (32 > 0)) (PreH4 : (retval > 0)) (PreH5 : (retval <= (UINT_MAX - 32 ))) (PreH6 : (addr_aligned retval 4 )),
  (CharArray.full retval 32 (repeat_Z (0) (32)) )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ (0 <= val_pre) ”
.

Definition _SemaphoreCreate_entail_wit_1_split_goal_spatial :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 = retval)) (PreH2 : (retval <> 0)) (PreH3 : (32 > 0)) (PreH4 : (retval > 0)) (PreH5 : (retval <= (UINT_MAX - 32 ))) (PreH6 : (addr_aligned retval 4 )),
  (CharArray.full retval 32 (repeat_Z (0) (32)) )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idnode_insert_ready  &((retval)  # "Semaphore" ->ₛ "id") )
  **  ((&((retval)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((retval)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((retval)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding retval )
.

Definition _SemaphoreCreate_entail_wit_2_1 :=
(
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (retval: Z) (PreH1 : (retval < 0)) (PreH2 : (retval = (-1))) (PreH3 : (lock = 0)) (PreH4 : (id = 0)) (PreH5 : (0 <= val_pre)) (PreH6 : (val_pre <= 65535)) (PreH7 : (sem <> 0)) (PreH8 : (addr_aligned sem 4 )) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH10 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH11 : (os_world_wf sg_dataqueue_ic before_dataqueue_ic )) (PreH12 : (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) )) (PreH13 : ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) ))),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idnode_insert_ready  &((sem)  # "Semaphore" ->ₛ "id") )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  “ (lock = 0) ”
  &&  “ (retval = (-1)) ”
  &&  “ (sem <> 0) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
  **  (CharArray.undef_full sem 32 )
) \/
(
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (retval: Z) (PreH1 : ((service_id ((os_recycle (before_dataqueue_ic)))) <= INT_MAX)) (PreH2 : ((service_id ((os_recycle (before_dataqueue_ic)))) >= INT_MIN)) (PreH3 : (retval < 0)) (PreH4 : (retval = (-1))) (PreH5 : (lock = 0)) (PreH6 : (id = 0)) (PreH7 : (0 <= val_pre)) (PreH8 : (val_pre <= 65535)) (PreH9 : (sem <> 0)) (PreH10 : (addr_aligned sem 4 )) (PreH11 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH12 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH13 : (os_world_wf sg_dataqueue_ic before_dataqueue_ic )) (PreH14 : (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) )) (PreH15 : ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) ))),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idnode_insert_ready  &((sem)  # "Semaphore" ->ₛ "id") )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
  **  (CharArray.undef_full sem 32 )
).

Definition _SemaphoreCreate_entail_wit_2_1_split_goal_spatial :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (retval: Z) (PreH1 : ((service_id ((os_recycle (before_dataqueue_ic)))) <= INT_MAX)) (PreH2 : ((service_id ((os_recycle (before_dataqueue_ic)))) >= INT_MIN)) (PreH3 : (retval < 0)) (PreH4 : (retval = (-1))) (PreH5 : (lock = 0)) (PreH6 : (id = 0)) (PreH7 : (0 <= val_pre)) (PreH8 : (val_pre <= 65535)) (PreH9 : (sem <> 0)) (PreH10 : (addr_aligned sem 4 )) (PreH11 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH12 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH13 : (os_world_wf sg_dataqueue_ic before_dataqueue_ic )) (PreH14 : (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) )) (PreH15 : ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) ))),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idnode_insert_ready  &((sem)  # "Semaphore" ->ₛ "id") )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
  **  (CharArray.undef_full sem 32 )
.

Definition _SemaphoreCreate_entail_wit_2_2 :=
(
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (retval: Z) (PreH1 : (retval < 0)) (PreH2 : ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_min_free_id  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) retval )) (PreH3 : (lock = 0)) (PreH4 : (id = 0)) (PreH5 : (0 <= val_pre)) (PreH6 : (val_pre <= 65535)) (PreH7 : (sem <> 0)) (PreH8 : (addr_aligned sem 4 )) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH10 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH11 : (os_world_wf sg_dataqueue_ic before_dataqueue_ic )) (PreH12 : (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) )) (PreH13 : ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) ))),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) ( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic))))) (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add  ((semaphore_manager ((os_semaphores (before_dataqueue_ic))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  “ (lock = 0) ”
  &&  “ (retval = (-1)) ”
  &&  “ (sem <> 0) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
  **  (CharArray.undef_full sem 32 )
) \/
(
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (retval: Z) (PreH1 : ((service_id ((os_recycle (before_dataqueue_ic)))) <= INT_MAX)) (PreH2 : ((service_id ((os_recycle (before_dataqueue_ic)))) >= INT_MIN)) (PreH3 : (retval < 0)) (PreH4 : ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_min_free_id  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) retval )) (PreH5 : (lock = 0)) (PreH6 : (id = 0)) (PreH7 : (0 <= val_pre)) (PreH8 : (val_pre <= 65535)) (PreH9 : (sem <> 0)) (PreH10 : (addr_aligned sem 4 )) (PreH11 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH12 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH13 : (os_world_wf sg_dataqueue_ic before_dataqueue_ic )) (PreH14 : (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) )) (PreH15 : ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) ))),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) ( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic))))) (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add  ((semaphore_manager ((os_semaphores (before_dataqueue_ic))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  “ (retval = (-1)) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
  **  (CharArray.undef_full sem 32 )
).

Definition _SemaphoreCreate_entail_wit_2_2_split_goal_1 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (retval: Z) (PreH1 : ((service_id ((os_recycle (before_dataqueue_ic)))) <= INT_MAX)) (PreH2 : ((service_id ((os_recycle (before_dataqueue_ic)))) >= INT_MIN)) (PreH3 : (retval < 0)) (PreH4 : ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_min_free_id  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) retval )) (PreH5 : (lock = 0)) (PreH6 : (id = 0)) (PreH7 : (0 <= val_pre)) (PreH8 : (val_pre <= 65535)) (PreH9 : (sem <> 0)) (PreH10 : (addr_aligned sem 4 )) (PreH11 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH12 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH13 : (os_world_wf sg_dataqueue_ic before_dataqueue_ic )) (PreH14 : (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) )) (PreH15 : ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) ))),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) ( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic))))) (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add  ((semaphore_manager ((os_semaphores (before_dataqueue_ic))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  “ (retval = (-1)) ”
.

Definition _SemaphoreCreate_entail_wit_2_2_split_goal_spatial :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (retval: Z) (PreH1 : ((service_id ((os_recycle (before_dataqueue_ic)))) <= INT_MAX)) (PreH2 : ((service_id ((os_recycle (before_dataqueue_ic)))) >= INT_MIN)) (PreH3 : (retval < 0)) (PreH4 : ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_min_free_id  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) retval )) (PreH5 : (lock = 0)) (PreH6 : (id = 0)) (PreH7 : (0 <= val_pre)) (PreH8 : (val_pre <= 65535)) (PreH9 : (sem <> 0)) (PreH10 : (addr_aligned sem 4 )) (PreH11 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH12 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH13 : (os_world_wf sg_dataqueue_ic before_dataqueue_ic )) (PreH14 : (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) )) (PreH15 : ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) ))),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) ( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic))))) (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add  ((semaphore_manager ((os_semaphores (before_dataqueue_ic))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
  **  (CharArray.undef_full sem 32 )
.

Definition _SemaphoreCreate_entail_wit_3 :=
(
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (retval: Z) (PreH1 : (retval >= 0)) (PreH2 : ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_min_free_id  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) retval )) (PreH3 : (lock = 0)) (PreH4 : (id = 0)) (PreH5 : (0 <= val_pre)) (PreH6 : (val_pre <= 65535)) (PreH7 : (sem <> 0)) (PreH8 : (addr_aligned sem 4 )) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH10 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH11 : (os_world_wf sg_dataqueue_ic before_dataqueue_ic )) (PreH12 : (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) )) (PreH13 : ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) ))),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) ( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic))))) (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add  ((semaphore_manager ((os_semaphores (before_dataqueue_ic))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  “ (lock = 0) ”
  &&  “ (0 <= retval) ”
  &&  “ (retval < 128) ”
  &&  “ (0 <= val_pre) ”
  &&  “ (val_pre <= 65535) ”
  &&  “ (sem <> 0) ”
  &&  “ (addr_aligned sem 4 ) ”
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ”
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ”
  &&  “ ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_min_free_id  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) retval ) ”
  &&  “ (os_world_wf sg_dataqueue_ic before_dataqueue_ic ) ”
  &&  “ (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) ) ”
  &&  “ ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) )) ”
  &&  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) ( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic))))) (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add  ((semaphore_manager ((os_semaphores (before_dataqueue_ic))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (SemaphorePadding sem )
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |->_)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
) \/
(
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (retval: Z) (PreH1 : (retval >= 0)) (PreH2 : ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_min_free_id  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) retval )) (PreH3 : (lock = 0)) (PreH4 : (id = 0)) (PreH5 : (0 <= val_pre)) (PreH6 : (val_pre <= 65535)) (PreH7 : (sem <> 0)) (PreH8 : (addr_aligned sem 4 )) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH10 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH11 : (os_world_wf sg_dataqueue_ic before_dataqueue_ic )) (PreH12 : (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) )) (PreH13 : ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) ))),
  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) ( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic))))) (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add  ((semaphore_manager ((os_semaphores (before_dataqueue_ic))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  EX (x_2: Z) (x: Z),
  “ (lock = 0) ”
  &&  “ (0 <= retval) ”
  &&  “ (retval < 128) ”
  &&  “ (0 <= val_pre) ”
  &&  “ (val_pre <= 65535) ”
  &&  “ (sem <> 0) ”
  &&  “ (addr_aligned sem 4 ) ”
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ”
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ”
  &&  “ ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_min_free_id  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) retval ) ”
  &&  “ (os_world_wf sg_dataqueue_ic before_dataqueue_ic ) ”
  &&  “ (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) ) ”
  &&  “ ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) )) ”
  &&  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |-> x_2)
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |-> x)
  **  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) ( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic))))) (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add  ((semaphore_manager ((os_semaphores (before_dataqueue_ic))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  (SemaphorePadding sem )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
).

Definition _SemaphoreCreate_entail_wit_4 :=
(
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (PreH1 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH2 : (lock = 0)) (PreH3 : (0 <= id)) (PreH4 : (id < 128)) (PreH5 : (0 <= val_pre)) (PreH6 : (val_pre <= 65535)) (PreH7 : (sem <> 0)) (PreH8 : (addr_aligned sem 4 )) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH10 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH11 : ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_min_free_id  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) id )) (PreH12 : (os_world_wf sg_dataqueue_ic before_dataqueue_ic )) (PreH13 : (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) )) (PreH14 : ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) ))),
  ( CRTOS_Verify.lib.list.NodeSelfLinked.store_node_self_linked  &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) ( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic))))) (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add  ((semaphore_manager ((os_semaphores (before_dataqueue_ic))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (SemaphorePadding sem )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
|--
  “ (lock = 0) ”
  &&  “ (0 <= id) ”
  &&  “ (id < 128) ”
  &&  “ (0 <= val_pre) ”
  &&  “ (val_pre <= 65535) ”
  &&  “ (sem <> 0) ”
  &&  “ (addr_aligned sem 4 ) ”
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ”
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ”
  &&  “ ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_min_free_id  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) id ) ”
  &&  “ (os_world_wf sg_dataqueue_ic before_dataqueue_ic ) ”
  &&  “ (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) ) ”
  &&  “ ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) )) ”
  &&  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) ( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic))))) (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add  ((semaphore_manager ((os_semaphores (before_dataqueue_ic))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  (store_semaphore (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) &((sem)  # "Semaphore" ->ₛ "link") (semaphore_created (sem) (id) (val_pre)) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.occupy_dll_node  &((sem)  # "Semaphore" ->ₛ "link") )
) \/
(
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (PreH1 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH2 : (lock = 0)) (PreH3 : (0 <= id)) (PreH4 : (id < 128)) (PreH5 : (0 <= val_pre)) (PreH6 : (val_pre <= 65535)) (PreH7 : (sem <> 0)) (PreH8 : (addr_aligned sem 4 )) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH10 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH11 : ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_min_free_id  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) id )) (PreH12 : (os_world_wf sg_dataqueue_ic before_dataqueue_ic )) (PreH13 : (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) )) (PreH14 : ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) ))),
  ( CRTOS_Verify.lib.list.NodeSelfLinked.store_node_self_linked  &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) ( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic))))) (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add  ((semaphore_manager ((os_semaphores (before_dataqueue_ic))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (SemaphorePadding sem )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
|--
  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) ( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic))))) (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add  ((semaphore_manager ((os_semaphores (before_dataqueue_ic))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  (store_semaphore (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) &((sem)  # "Semaphore" ->ₛ "link") (semaphore_created (sem) (id) (val_pre)) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.occupy_dll_node  &((sem)  # "Semaphore" ->ₛ "link") )
).

Definition _SemaphoreCreate_entail_wit_4_split_goal_spatial :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (PreH1 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH2 : (lock = 0)) (PreH3 : (0 <= id)) (PreH4 : (id < 128)) (PreH5 : (0 <= val_pre)) (PreH6 : (val_pre <= 65535)) (PreH7 : (sem <> 0)) (PreH8 : (addr_aligned sem 4 )) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH10 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH11 : ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_min_free_id  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) id )) (PreH12 : (os_world_wf sg_dataqueue_ic before_dataqueue_ic )) (PreH13 : (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) )) (PreH14 : ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) ))),
  ( CRTOS_Verify.lib.list.NodeSelfLinked.store_node_self_linked  &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) ( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic))))) (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add  ((semaphore_manager ((os_semaphores (before_dataqueue_ic))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (SemaphorePadding sem )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
|--
  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) ( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic))))) (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add  ((semaphore_manager ((os_semaphores (before_dataqueue_ic))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  (store_semaphore (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) &((sem)  # "Semaphore" ->ₛ "link") (semaphore_created (sem) (id) (val_pre)) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.occupy_dll_node  &((sem)  # "Semaphore" ->ₛ "link") )
.

Definition _SemaphoreCreate_return_wit_1 :=
(
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (PreH1 : (lock = 0)) (PreH2 : (0 <= id)) (PreH3 : (id < 128)) (PreH4 : (0 <= val_pre)) (PreH5 : (val_pre <= 65535)) (PreH6 : (sem <> 0)) (PreH7 : (addr_aligned sem 4 )) (PreH8 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH10 : ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_min_free_id  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) id )) (PreH11 : (os_world_wf sg_dataqueue_ic before_dataqueue_ic )) (PreH12 : (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) )) (PreH13 : ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) ))),
  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) ( CRTOS_Verify.lib.list.DoubleLinkListSpec.dll_insert_after_dispatch  (( &( "k_sem_list" ) )) ((map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic))))) (( &( "k_sem_list" ) )) (( CRTOS_Verify.lib.common.dll_abs.Build_DL_Node  ((semaphore_created (sem) (id) (val_pre))) (&((sem)  # "Semaphore" ->ₛ "link"))))) )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) ( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic))))) (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add  ((semaphore_manager ((os_semaphores (before_dataqueue_ic))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
|--
  EX (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ (0 <= id) ”
  &&  “ (id < 128) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg_dataqueue_ic val_pre before_dataqueue_ic id after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic after )
) \/
(
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (PreH1 : ((service_id ((os_recycle (before_dataqueue_ic)))) <= INT_MAX)) (PreH2 : ((service_id ((os_recycle (before_dataqueue_ic)))) >= INT_MIN)) (PreH3 : (lock = 0)) (PreH4 : (0 <= id)) (PreH5 : (id < 128)) (PreH6 : (0 <= val_pre)) (PreH7 : (val_pre <= 65535)) (PreH8 : (sem <> 0)) (PreH9 : (addr_aligned sem 4 )) (PreH10 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH11 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH12 : ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_min_free_id  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) id )) (PreH13 : (os_world_wf sg_dataqueue_ic before_dataqueue_ic )) (PreH14 : (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) )) (PreH15 : ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) ))),
  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) ( CRTOS_Verify.lib.list.DoubleLinkListSpec.dll_insert_after_dispatch  (( &( "k_sem_list" ) )) ((map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic))))) (( &( "k_sem_list" ) )) (( CRTOS_Verify.lib.common.dll_abs.Build_DL_Node  ((semaphore_created (sem) (id) (val_pre))) (&((sem)  # "Semaphore" ->ₛ "link"))))) )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) ( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic))))) (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add  ((semaphore_manager ((os_semaphores (before_dataqueue_ic))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
|--
  EX (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ (0 <= id) ”
  &&  “ (id < 128) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg_dataqueue_ic val_pre before_dataqueue_ic id after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic after )
).

Definition _SemaphoreCreate_return_wit_2 :=
(
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (PreH1 : (lock = 0)) (PreH2 : (id = (-1))) (PreH3 : (sem <> 0)),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  EX (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ ((-5) = (-5)) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg_dataqueue_ic val_pre before_dataqueue_ic (-5) after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic after )
) \/
(
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (PreH1 : (lock = 0)) (PreH2 : (id = (-1))) (PreH3 : (sem <> 0)),
  TT && emp 
|--
  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg_dataqueue_ic val_pre before_dataqueue_ic (-5) before_dataqueue_ic ) ”
  &&  emp
).

Definition _SemaphoreCreate_return_wit_2_split_goal_1 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (PreH1 : (lock = 0)) (PreH2 : (id = (-1))) (PreH3 : (sem <> 0)),
  ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg_dataqueue_ic val_pre before_dataqueue_ic (-5) before_dataqueue_ic )
.

Definition _SemaphoreCreate_return_wit_3 :=
(
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (32 > 0)) (PreH3 : (retval = 0)),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  EX (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ ((-5) = (-5)) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg_dataqueue_ic val_pre before_dataqueue_ic (-5) after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic after )
) \/
(
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (32 > 0)) (PreH3 : (retval = 0)),
  TT && emp 
|--
  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg_dataqueue_ic val_pre before_dataqueue_ic (-5) before_dataqueue_ic ) ”
  &&  emp
).

Definition _SemaphoreCreate_return_wit_3_split_goal_1 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (32 > 0)) (PreH3 : (retval = 0)),
  ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg_dataqueue_ic val_pre before_dataqueue_ic (-5) before_dataqueue_ic )
.

Definition _SemaphoreCreate_partial_solve_wit_1 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
.

Definition _SemaphoreCreate_partial_solve_wit_2_pure :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (32 > 0)) (PreH3 : (retval > 0)) (PreH4 : (retval <= (UINT_MAX - 32 ))) (PreH5 : (addr_aligned retval 4 )),
  (CharArray.undef_full retval 32 )
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ (0 <= 0) ”
  &&  “ (0 <= 127) ”
.

Definition _SemaphoreCreate_partial_solve_wit_2_aux :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (32 > 0)) (PreH3 : (retval > 0)) (PreH4 : (retval <= (UINT_MAX - 32 ))) (PreH5 : (addr_aligned retval 4 )),
  (CharArray.undef_full retval 32 )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
|--
  “ (0 <= 0) ”
  &&  “ (0 <= 127) ”
  &&  “ (retval <> 0) ”
  &&  “ (32 > 0) ”
  &&  “ (retval > 0) ”
  &&  “ (retval <= (UINT_MAX - 32 )) ”
  &&  “ (addr_aligned retval 4 ) ”
  &&  (CharArray.undef_full retval 32 )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
.

Definition _SemaphoreCreate_partial_solve_wit_2 := _SemaphoreCreate_partial_solve_wit_2_pure -> _SemaphoreCreate_partial_solve_wit_2_aux.

Definition _SemaphoreCreate_partial_solve_wit_3 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (PreH1 : (lock = 0)) (PreH2 : (id = 0)) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : (sem <> 0)) (PreH6 : (addr_aligned sem 4 )) (PreH7 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH8 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH9 : (os_world_wf sg_dataqueue_ic before_dataqueue_ic )) (PreH10 : (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) )) (PreH11 : ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) ))),
  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idnode_insert_ready  &((sem)  # "Semaphore" ->ₛ "id") )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
|--
  “ (lock = 0) ”
  &&  “ (id = 0) ”
  &&  “ (0 <= val_pre) ”
  &&  “ (val_pre <= 65535) ”
  &&  “ (sem <> 0) ”
  &&  “ (addr_aligned sem 4 ) ”
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ”
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ”
  &&  “ (os_world_wf sg_dataqueue_ic before_dataqueue_ic ) ”
  &&  “ (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) ) ”
  &&  “ ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) )) ”
  &&  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idnode_insert_ready  &((sem)  # "Semaphore" ->ₛ "id") )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "pend_list") )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
  **  (SemaphorePadding sem )
.

Definition _SemaphoreCreate_partial_solve_wit_4_pure :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (PreH1 : (lock = 0)) (PreH2 : (id = (-1))) (PreH3 : (sem <> 0)),
  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
  **  (CharArray.undef_full sem 32 )
|--
  “ (sem <> 0) ”
  &&  “ (0 < 32) ”
.

Definition _SemaphoreCreate_partial_solve_wit_4_aux :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (lock: Z) (id: Z) (sem: Z) (PreH1 : (lock = 0)) (PreH2 : (id = (-1))) (PreH3 : (sem <> 0)),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
  **  (CharArray.undef_full sem 32 )
|--
  “ (sem <> 0) ”
  &&  “ (0 < 32) ”
  &&  “ (lock = 0) ”
  &&  “ (id = (-1)) ”
  &&  “ (sem <> 0) ”
  &&  (CharArray.undef_full sem 32 )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_dataqueue_ic before_dataqueue_ic )
.

Definition _SemaphoreCreate_partial_solve_wit_4 := _SemaphoreCreate_partial_solve_wit_4_pure -> _SemaphoreCreate_partial_solve_wit_4_aux.

Definition _SemaphoreCreate_partial_solve_wit_5 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (PreH1 : (lock = 0)) (PreH2 : (0 <= id)) (PreH3 : (id < 128)) (PreH4 : (0 <= val_pre)) (PreH5 : (val_pre <= 65535)) (PreH6 : (sem <> 0)) (PreH7 : (addr_aligned sem 4 )) (PreH8 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH10 : ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_min_free_id  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) id )) (PreH11 : (os_world_wf sg_dataqueue_ic before_dataqueue_ic )) (PreH12 : (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) )) (PreH13 : ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) ))),
  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) ( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic))))) (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add  ((semaphore_manager ((os_semaphores (before_dataqueue_ic))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (SemaphorePadding sem )
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |->_)
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
|--
  “ (lock = 0) ”
  &&  “ (0 <= id) ”
  &&  “ (id < 128) ”
  &&  “ (0 <= val_pre) ”
  &&  “ (val_pre <= 65535) ”
  &&  “ (sem <> 0) ”
  &&  “ (addr_aligned sem 4 ) ”
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ”
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ”
  &&  “ ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_min_free_id  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) id ) ”
  &&  “ (os_world_wf sg_dataqueue_ic before_dataqueue_ic ) ”
  &&  “ (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) ) ”
  &&  “ ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) )) ”
  &&  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |->_)
  **  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) ( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic))))) (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add  ((semaphore_manager ((os_semaphores (before_dataqueue_ic))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (SemaphorePadding sem )
  **  (NodeZero &((sem)  # "Semaphore" ->ₛ "link") )
.

Definition _SemaphoreCreate_partial_solve_wit_6_pure :=
(
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (PreH1 : (lock = 0)) (PreH2 : (0 <= id)) (PreH3 : (id < 128)) (PreH4 : (0 <= val_pre)) (PreH5 : (val_pre <= 65535)) (PreH6 : (sem <> 0)) (PreH7 : (addr_aligned sem 4 )) (PreH8 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH10 : ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_min_free_id  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) id )) (PreH11 : (os_world_wf sg_dataqueue_ic before_dataqueue_ic )) (PreH12 : (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) )) (PreH13 : ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) ))),
  ((( &( "lock" ) )) # Int  |-> lock)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) ( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic))))) (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add  ((semaphore_manager ((os_semaphores (before_dataqueue_ic))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  (store_semaphore (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) &((sem)  # "Semaphore" ->ₛ "link") (semaphore_created (sem) (id) (val_pre)) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.occupy_dll_node  &((sem)  # "Semaphore" ->ₛ "link") )
|--
  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ”
  &&  “ ( CRTOS_Verify.lib.list.DoubleLinkListSpec.dll_insert_anchor  ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) ( &( "k_sem_list" ) ) ) ”
) \/
(
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (PreH1 : ((service_id ((os_recycle (before_dataqueue_ic)))) <= INT_MAX)) (PreH2 : (id <= INT_MAX)) (PreH3 : (lock <= INT_MAX)) (PreH4 : ((service_id ((os_recycle (before_dataqueue_ic)))) >= INT_MIN)) (PreH5 : (id >= INT_MIN)) (PreH6 : (lock >= INT_MIN)) (PreH7 : (lock = 0)) (PreH8 : (0 <= id)) (PreH9 : (id < 128)) (PreH10 : (0 <= val_pre)) (PreH11 : (val_pre <= 65535)) (PreH12 : (sem <> 0)) (PreH13 : (addr_aligned sem 4 )) (PreH14 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH15 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH16 : ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_min_free_id  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) id )) (PreH17 : (os_world_wf sg_dataqueue_ic before_dataqueue_ic )) (PreH18 : (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) )) (PreH19 : ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) ))),
  ((( &( "lock" ) )) # Int  |-> lock)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) ( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic))))) (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add  ((semaphore_manager ((os_semaphores (before_dataqueue_ic))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  (store_semaphore (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) &((sem)  # "Semaphore" ->ₛ "link") (semaphore_created (sem) (id) (val_pre)) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.occupy_dll_node  &((sem)  # "Semaphore" ->ₛ "link") )
|--
  “ ( CRTOS_Verify.lib.list.DoubleLinkListSpec.dll_insert_anchor  ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) ( &( "k_sem_list" ) ) ) ”
).

Definition _SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1 :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (PreH1 : ((service_id ((os_recycle (before_dataqueue_ic)))) <= INT_MAX)) (PreH2 : (id <= INT_MAX)) (PreH3 : (lock <= INT_MAX)) (PreH4 : ((service_id ((os_recycle (before_dataqueue_ic)))) >= INT_MIN)) (PreH5 : (id >= INT_MIN)) (PreH6 : (lock >= INT_MIN)) (PreH7 : (lock = 0)) (PreH8 : (0 <= id)) (PreH9 : (id < 128)) (PreH10 : (0 <= val_pre)) (PreH11 : (val_pre <= 65535)) (PreH12 : (sem <> 0)) (PreH13 : (addr_aligned sem 4 )) (PreH14 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH15 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH16 : ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_min_free_id  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) id )) (PreH17 : (os_world_wf sg_dataqueue_ic before_dataqueue_ic )) (PreH18 : (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) )) (PreH19 : ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) ))),
  ((( &( "lock" ) )) # Int  |-> lock)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) ( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic))))) (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add  ((semaphore_manager ((os_semaphores (before_dataqueue_ic))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  (store_semaphore (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) &((sem)  # "Semaphore" ->ₛ "link") (semaphore_created (sem) (id) (val_pre)) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.occupy_dll_node  &((sem)  # "Semaphore" ->ₛ "link") )
|--
  “ ( CRTOS_Verify.lib.list.DoubleLinkListSpec.dll_insert_anchor  ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) ( &( "k_sem_list" ) ) ) ”
.

Definition _SemaphoreCreate_partial_solve_wit_6_aux :=
forall (before_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_dataqueue_ic:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (val_pre: Z) (lock: Z) (id: Z) (sem: Z) (PreH1 : (lock = 0)) (PreH2 : (0 <= id)) (PreH3 : (id < 128)) (PreH4 : (0 <= val_pre)) (PreH5 : (val_pre <= 65535)) (PreH6 : (sem <> 0)) (PreH7 : (addr_aligned sem 4 )) (PreH8 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH10 : ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_min_free_id  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) id )) (PreH11 : (os_world_wf sg_dataqueue_ic before_dataqueue_ic )) (PreH12 : (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) )) (PreH13 : ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) ))),
  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) ( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic))))) (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add  ((semaphore_manager ((os_semaphores (before_dataqueue_ic))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  (store_semaphore (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) &((sem)  # "Semaphore" ->ₛ "link") (semaphore_created (sem) (id) (val_pre)) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.occupy_dll_node  &((sem)  # "Semaphore" ->ₛ "link") )
|--
  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ”
  &&  “ ( CRTOS_Verify.lib.list.DoubleLinkListSpec.dll_insert_anchor  ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) ( &( "k_sem_list" ) ) ) ”
  &&  “ (lock = 0) ”
  &&  “ (0 <= id) ”
  &&  “ (id < 128) ”
  &&  “ (0 <= val_pre) ”
  &&  “ (val_pre <= 65535) ”
  &&  “ (sem <> 0) ”
  &&  “ (addr_aligned sem 4 ) ”
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ”
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ”
  &&  “ ( CRTOS_Verify.lib.id.idnode.IDNode.idmanager_min_free_id  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) (semaphore_manager ((os_semaphores (before_dataqueue_ic)))) id ) ”
  &&  “ (os_world_wf sg_dataqueue_ic before_dataqueue_ic ) ”
  &&  “ (semaphore_context (os_semaphore_stable (sg_dataqueue_ic)) ) ”
  &&  “ ~((In sem (map (semaphore_addr) ((os_semaphores (before_dataqueue_ic)))) )) ”
  &&  ( CRTOS_Verify.lib.common.dll.DLL.store_dll  (store_semaphore ((pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))))) ( &( "k_sem_list" ) ) (map (semaphore_link_node) ((os_semaphores (before_dataqueue_ic)))) )
  **  (store_semaphore (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) &((sem)  # "Semaphore" ->ₛ "link") (semaphore_created (sem) (id) (val_pre)) )
  **  ( CRTOS_Verify.lib.common.dll.DLL.occupy_dll_node  &((sem)  # "Semaphore" ->ₛ "link") )
  **  (dataqueue_inv (os_semaphores (before_dataqueue_ic)) ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (before_dataqueue_ic)) )
  **  (task_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (tick_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (delay_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (assign_inv sg_dataqueue_ic before_dataqueue_ic )
  **  (store_prio_lookup_table )
  **  (store_zombie_queue (task_desc_map ((os_tasks (before_dataqueue_ic)))) (os_zombie_head (sg_dataqueue_ic)) (zombie_queue (before_dataqueue_ic)) )
  **  (((os_recycler_slot (sg_dataqueue_ic))) # Int  |-> (service_id ((os_recycle (before_dataqueue_ic)))))
  **  (IntArray.full (os_idle_array (sg_dataqueue_ic)) CORE_COUNT (map (service_id) ((os_idle (before_dataqueue_ic)))) )
  **  (mutex_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_mutex_stable (sg_dataqueue_ic)) (os_mutexes (before_dataqueue_ic)) )
  **  (event_inv (pure_suspend_sched_link ((task_desc_map ((os_tasks (before_dataqueue_ic)))))) (os_event_stable (sg_dataqueue_ic)) (os_events (before_dataqueue_ic)) )
  **  (isrmanager_inv (os_isr_stable (sg_dataqueue_ic)) (os_isr (before_dataqueue_ic)) )
  **  (exstatus_inv sg_dataqueue_ic before_dataqueue_ic )
  **  ( CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager  (semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic)))) ( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link  ((semaphore_manager_stable ((os_semaphore_stable (sg_dataqueue_ic))))) (( CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add  ((semaphore_manager ((os_semaphores (before_dataqueue_ic))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id"))) ( &( "k_sem_id_manager" ) ) )
.

Definition _SemaphoreCreate_partial_solve_wit_6 := _SemaphoreCreate_partial_solve_wit_6_pure -> _SemaphoreCreate_partial_solve_wit_6_aux.

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
Axiom proof_of__SemaphoreCreate_entail_wit_2_1 : _SemaphoreCreate_entail_wit_2_1.
Axiom proof_of__SemaphoreCreate_entail_wit_2_2 : _SemaphoreCreate_entail_wit_2_2.
Axiom proof_of__SemaphoreCreate_entail_wit_3 : _SemaphoreCreate_entail_wit_3.
Axiom proof_of__SemaphoreCreate_entail_wit_4 : _SemaphoreCreate_entail_wit_4.
Axiom proof_of__SemaphoreCreate_return_wit_1 : _SemaphoreCreate_return_wit_1.
Axiom proof_of__SemaphoreCreate_return_wit_2 : _SemaphoreCreate_return_wit_2.
Axiom proof_of__SemaphoreCreate_return_wit_3 : _SemaphoreCreate_return_wit_3.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_1 : _SemaphoreCreate_partial_solve_wit_1.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_2_pure : _SemaphoreCreate_partial_solve_wit_2_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_2 : _SemaphoreCreate_partial_solve_wit_2.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_3 : _SemaphoreCreate_partial_solve_wit_3.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_4_pure : _SemaphoreCreate_partial_solve_wit_4_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_4 : _SemaphoreCreate_partial_solve_wit_4.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_5 : _SemaphoreCreate_partial_solve_wit_5.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_6_pure : _SemaphoreCreate_partial_solve_wit_6_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_6 : _SemaphoreCreate_partial_solve_wit_6.

End VC_Correct.
