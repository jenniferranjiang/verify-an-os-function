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
Require Import CRTOS_Verify.VC.SemaphoreDelete_lib.
Local Open Scope sac.

(*----- Function _SemaphoreDelete -----*)

Definition _SemaphoreDelete_safety_wit_1 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (PreH1 : ((INT_MIN) <= id_pre)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  ((( &( "resched" ) )) # Int  |->_)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreDelete_safety_wit_2 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (PreH1 : ((INT_MIN) <= id_pre)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  ((( &( "lock" ) )) # Int  |->_)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreDelete_safety_wit_3 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (PreH1 : ((INT_MIN) <= id_pre)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  ((( &( "sem" ) )) # Ptr  |->_)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreDelete_safety_wit_4 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (PreH1 : ((INT_MIN) <= id_pre)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  ((( &( "idnode" ) )) # Ptr  |->_)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreDelete_safety_wit_5 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (PreH1 : ((INT_MIN) <= id_pre)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreDelete_safety_wit_6 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (( &( "k_sem_id_manager" ) ) = 0)) (PreH2 : (retval_2 = 0)) (PreH3 : (Crtos_RTrans before_outside_critical st_lock )) (PreH4 : (id_pre >= 0)) (PreH5 : ((INT_MIN) <= id_pre)) (PreH6 : (id_pre <= INT_MAX)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreDelete_safety_wit_7 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH2 : (retval_2 = 0)) (PreH3 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = false)) (PreH4 : (Crtos_RTrans before_outside_critical st_lock )) (PreH5 : (id_pre >= 0)) (PreH6 : ((INT_MIN) <= id_pre)) (PreH7 : (id_pre <= INT_MAX)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreDelete_safety_wit_8 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH2 : (retval_2 <> 0)) (PreH3 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH4 : (Crtos_RTrans before_outside_critical st_lock )) (PreH5 : (id_pre >= 0)) (PreH6 : ((INT_MIN) <= id_pre)) (PreH7 : (id_pre <= INT_MAX)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_idmanager_found (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) retval_2 (unsigned_last_nbits (id_pre) (16)) )
  **  (delete_manager_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreDelete_safety_wit_9 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (retval_2 <> 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) = 0)) (PreH3 : (retval_2 = 0)) (PreH4 : (Crtos_RTrans before_outside_critical st_lock )) (PreH5 : (id_pre >= 0)) (PreH6 : ((INT_MIN) <= id_pre)) (PreH7 : (id_pre <= INT_MAX)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ False ”
.

Definition _SemaphoreDelete_safety_wit_10 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (retval_2 <> 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval_2 = 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = false)) (PreH5 : (Crtos_RTrans before_outside_critical st_lock )) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= id_pre)) (PreH8 : (id_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ False ”
.

Definition _SemaphoreDelete_safety_wit_11 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval_2 <> 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH5 : (Crtos_RTrans before_outside_critical st_lock )) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= id_pre)) (PreH8 : (id_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_idmanager_found (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) retval_2 (unsigned_last_nbits (id_pre) (16)) )
  **  (delete_manager_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ False ”
.

Definition _SemaphoreDelete_safety_wit_12 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (original: SemaphoreAbs) (retval_3: Z) (retval_4: Z) (PreH1 : (retval_4 <> 0)) (PreH2 : (retval_4 = 0)) (PreH3 : ((map (sched_link_node) ((original.(semaphore_pending_addrs) ))) <> (@nil (@DL_Node Z)))) (PreH4 : (In original (st_lock.(os_semaphores) ) )) (PreH5 : (retval_3 = (original.(semaphore_addr) ))) (PreH6 : (retval_2 = &((retval_3)  # "Semaphore" ->ₛ "id"))) (PreH7 : (In original (st_lock.(os_semaphores) ) )) (PreH8 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH9 : (retval_2 = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id"))) (PreH10 : ((original.(semaphore_addr) ) <> 0)) (PreH11 : (retval_2 <> 0)) (PreH12 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH13 : (retval_2 <> 0)) (PreH14 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH15 : (Crtos_RTrans before_outside_critical st_lock )) (PreH16 : (id_pre >= 0)) (PreH17 : ((INT_MIN) <= id_pre)) (PreH18 : (id_pre <= INT_MAX)) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_dll (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) )
  **  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (delete_pending_restore sg_outside_critical st_lock (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "resched" ) )) # Int  |-> 0)
|--
  “ False ”
.

Definition _SemaphoreDelete_safety_wit_13 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (original: SemaphoreAbs) (retval_3: Z) (retval_4: Z) (PreH1 : (retval_4 = 0)) (PreH2 : (retval_4 = 1)) (PreH3 : ((map (sched_link_node) ((original.(semaphore_pending_addrs) ))) = (@nil (@DL_Node Z)))) (PreH4 : (In original (st_lock.(os_semaphores) ) )) (PreH5 : (retval_3 = (original.(semaphore_addr) ))) (PreH6 : (retval_2 = &((retval_3)  # "Semaphore" ->ₛ "id"))) (PreH7 : (In original (st_lock.(os_semaphores) ) )) (PreH8 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH9 : (retval_2 = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id"))) (PreH10 : ((original.(semaphore_addr) ) <> 0)) (PreH11 : (retval_2 <> 0)) (PreH12 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH13 : (retval_2 <> 0)) (PreH14 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH15 : (Crtos_RTrans before_outside_critical st_lock )) (PreH16 : (id_pre >= 0)) (PreH17 : ((INT_MIN) <= id_pre)) (PreH18 : (id_pre <= INT_MAX)) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_dll (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) )
  **  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (delete_pending_restore sg_outside_critical st_lock (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "resched" ) )) # Int  |-> 0)
|--
  “ False ”
.

Definition _SemaphoreDelete_safety_wit_14 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (original: SemaphoreAbs) (retval_3: Z) (retval_4: Z) (PreH1 : (retval_4 = 0)) (PreH2 : (retval_4 = 0)) (PreH3 : ((map (sched_link_node) ((original.(semaphore_pending_addrs) ))) <> (@nil (@DL_Node Z)))) (PreH4 : (In original (st_lock.(os_semaphores) ) )) (PreH5 : (retval_3 = (original.(semaphore_addr) ))) (PreH6 : (retval_2 = &((retval_3)  # "Semaphore" ->ₛ "id"))) (PreH7 : (In original (st_lock.(os_semaphores) ) )) (PreH8 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH9 : (retval_2 = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id"))) (PreH10 : ((original.(semaphore_addr) ) <> 0)) (PreH11 : (retval_2 <> 0)) (PreH12 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH13 : (retval_2 <> 0)) (PreH14 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH15 : (Crtos_RTrans before_outside_critical st_lock )) (PreH16 : (id_pre >= 0)) (PreH17 : ((INT_MIN) <= id_pre)) (PreH18 : (id_pre <= INT_MAX)) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_dll (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) )
  **  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (delete_pending_restore sg_outside_critical st_lock (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "resched" ) )) # Int  |-> 0)
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition _SemaphoreDelete_safety_wit_15 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (saved_lock: Z) (sem: Z) (idnode: Z) (delete_sem_id: Z) (resched: Z) (after: VarGlobalState) (PreH1 : (sem = (original.(semaphore_addr) ))) (PreH2 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH3 : (delete_sem_id = (original.(semaphore_id) ))) (PreH4 : (resched = 1)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_outside_critical )) (PreH6 : (Crtos_GTrans st_lock after )) (PreH7 : (resched = 0)) ,
  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  (OutsideCritical sg_outside_critical after )
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> delete_sem_id)
  **  ((( &( "resched" ) )) # Int  |-> resched)
|--
  “ False ”
.

Definition _SemaphoreDelete_safety_wit_16 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (saved_lock: Z) (sem: Z) (idnode: Z) (delete_sem_id: Z) (resched: Z) (after: VarGlobalState) (PreH1 : (sem = (original.(semaphore_addr) ))) (PreH2 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH3 : (delete_sem_id = (original.(semaphore_id) ))) (PreH4 : (resched = 0)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_outside_critical )) (PreH6 : (Crtos_GTrans st_lock after )) (PreH7 : (resched <> 0)) ,
  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  (OutsideCritical sg_outside_critical after )
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> delete_sem_id)
  **  ((( &( "resched" ) )) # Int  |-> resched)
|--
  “ False ”
.

Definition _SemaphoreDelete_entail_wit_1 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ ((INT_MIN) <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ”
  &&  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_outside_critical before_outside_critical )
.

Definition _SemaphoreDelete_entail_wit_2_1 := 
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) = 0)) (PreH3 : (retval = 0)) (PreH4 : (Crtos_RTrans before_outside_critical st_lock )) (PreH5 : (id_pre >= 0)) (PreH6 : ((INT_MIN) <= id_pre)) (PreH7 : (id_pre <= INT_MAX)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (0 <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ (0 = 0) ” 
  &&  “ (0 = 0) ” 
  &&  “ (retval = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (tt)) X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock st_lock ) ”
  &&  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical st_lock )
) \/
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) = 0)) (PreH3 : (retval = 0)) (PreH4 : (Crtos_RTrans before_outside_critical st_lock )) (PreH5 : (id_pre >= 0)) (PreH6 : ((INT_MIN) <= id_pre)) (PreH7 : (id_pre <= INT_MAX)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (Crtos_GTrans st_lock st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (tt)) X_outside_critical ) ”
  &&  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical st_lock )
).

Definition _SemaphoreDelete_entail_wit_2_1_split_goal_1 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) = 0)) (PreH3 : (retval = 0)) (PreH4 : (Crtos_RTrans before_outside_critical st_lock )) (PreH5 : (id_pre >= 0)) (PreH6 : ((INT_MIN) <= id_pre)) (PreH7 : (id_pre <= INT_MAX)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (Crtos_GTrans st_lock st_lock ) ”
.

Definition _SemaphoreDelete_entail_wit_2_1_split_goal_2 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) = 0)) (PreH3 : (retval = 0)) (PreH4 : (Crtos_RTrans before_outside_critical st_lock )) (PreH5 : (id_pre >= 0)) (PreH6 : ((INT_MIN) <= id_pre)) (PreH7 : (id_pre <= INT_MAX)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (tt)) X_outside_critical ) ”
.

Definition _SemaphoreDelete_entail_wit_2_1_split_goal_spatial := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) = 0)) (PreH3 : (retval = 0)) (PreH4 : (Crtos_RTrans before_outside_critical st_lock )) (PreH5 : (id_pre >= 0)) (PreH6 : ((INT_MIN) <= id_pre)) (PreH7 : (id_pre <= INT_MAX)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_entail_wit_2_2 := 
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval = 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = false)) (PreH5 : (Crtos_RTrans before_outside_critical st_lock )) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= id_pre)) (PreH8 : (id_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (0 <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ (0 = 0) ” 
  &&  “ (0 = 0) ” 
  &&  “ (retval = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (tt)) X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock st_lock ) ”
  &&  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical st_lock )
) \/
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval = 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = false)) (PreH5 : (Crtos_RTrans before_outside_critical st_lock )) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= id_pre)) (PreH8 : (id_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (Crtos_GTrans st_lock st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (tt)) X_outside_critical ) ”
  &&  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical st_lock )
).

Definition _SemaphoreDelete_entail_wit_2_2_split_goal_1 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval = 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = false)) (PreH5 : (Crtos_RTrans before_outside_critical st_lock )) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= id_pre)) (PreH8 : (id_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (Crtos_GTrans st_lock st_lock ) ”
.

Definition _SemaphoreDelete_entail_wit_2_2_split_goal_2 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval = 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = false)) (PreH5 : (Crtos_RTrans before_outside_critical st_lock )) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= id_pre)) (PreH8 : (id_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (tt)) X_outside_critical ) ”
.

Definition _SemaphoreDelete_entail_wit_2_2_split_goal_spatial := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval = 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = false)) (PreH5 : (Crtos_RTrans before_outside_critical st_lock )) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= id_pre)) (PreH8 : (id_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_entail_wit_3_1 := 
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (original: SemaphoreAbs) (retval_2: Z) (retval_3: Z) (after: VarGlobalState) (retval_4: Z) (PreH1 : (retval_4 = KOK)) (PreH2 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock after )) (PreH3 : (semaphore_pending_nodes (original.(semaphore_addr) ) after (@nil (@DL_Node Z)) )) (PreH4 : (In original (st_lock.(os_semaphores) ) )) (PreH5 : (semaphore_pending_nodes (original.(semaphore_addr) ) st_lock (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) )) (PreH6 : (retval_3 = 0)) (PreH7 : (retval_3 = 0)) (PreH8 : ((map (sched_link_node) ((original.(semaphore_pending_addrs) ))) <> (@nil (@DL_Node Z)))) (PreH9 : (In original (st_lock.(os_semaphores) ) )) (PreH10 : (retval_2 = (original.(semaphore_addr) ))) (PreH11 : (retval = &((retval_2)  # "Semaphore" ->ₛ "id"))) (PreH12 : (In original (st_lock.(os_semaphores) ) )) (PreH13 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH14 : (retval = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id"))) (PreH15 : ((original.(semaphore_addr) ) <> 0)) (PreH16 : (retval <> 0)) (PreH17 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH18 : (retval <> 0)) (PreH19 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH20 : (Crtos_RTrans before_outside_critical st_lock )) (PreH21 : (id_pre >= 0)) (PreH22 : ((INT_MIN) <= id_pre)) (PreH23 : (id_pre <= INT_MAX)) (PreH24 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (os_inv sg_outside_critical after )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  EX (drained: VarGlobalState) ,
  “ (0 <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ ((original.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ (retval = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (1 = 1) ” 
  &&  “ ((original.(semaphore_pending_addrs) ) <> (@nil Z)) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) ) ”
  &&  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical drained )
) \/
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (original: SemaphoreAbs) (retval_2: Z) (retval_3: Z) (after: VarGlobalState) (retval_4: Z) (PreH1 : (retval_4 = KOK)) (PreH2 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock after )) (PreH3 : (semaphore_pending_nodes (original.(semaphore_addr) ) after (@nil (@DL_Node Z)) )) (PreH4 : (In original (st_lock.(os_semaphores) ) )) (PreH5 : (semaphore_pending_nodes (original.(semaphore_addr) ) st_lock (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) )) (PreH6 : (retval_3 = 0)) (PreH7 : (retval_3 = 0)) (PreH8 : ((map (sched_link_node) ((original.(semaphore_pending_addrs) ))) <> (@nil (@DL_Node Z)))) (PreH9 : (In original (st_lock.(os_semaphores) ) )) (PreH10 : (retval_2 = (original.(semaphore_addr) ))) (PreH11 : (retval = &((retval_2)  # "Semaphore" ->ₛ "id"))) (PreH12 : (In original (st_lock.(os_semaphores) ) )) (PreH13 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH14 : (retval = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id"))) (PreH15 : ((original.(semaphore_addr) ) <> 0)) (PreH16 : (retval <> 0)) (PreH17 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH18 : (retval <> 0)) (PreH19 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH20 : (Crtos_RTrans before_outside_critical st_lock )) (PreH21 : (id_pre >= 0)) (PreH22 : ((INT_MIN) <= id_pre)) (PreH23 : (id_pre <= INT_MAX)) (PreH24 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  TT && emp 
|--
  “ ((original.(semaphore_pending_addrs) ) <> (@nil Z)) ”
  &&  emp
).

Definition _SemaphoreDelete_entail_wit_3_1_split_goal_1 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (original: SemaphoreAbs) (retval_2: Z) (retval_3: Z) (after: VarGlobalState) (retval_4: Z) (PreH1 : (retval_4 = KOK)) (PreH2 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock after )) (PreH3 : (semaphore_pending_nodes (original.(semaphore_addr) ) after (@nil (@DL_Node Z)) )) (PreH4 : (In original (st_lock.(os_semaphores) ) )) (PreH5 : (semaphore_pending_nodes (original.(semaphore_addr) ) st_lock (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) )) (PreH6 : (retval_3 = 0)) (PreH7 : (retval_3 = 0)) (PreH8 : ((map (sched_link_node) ((original.(semaphore_pending_addrs) ))) <> (@nil (@DL_Node Z)))) (PreH9 : (In original (st_lock.(os_semaphores) ) )) (PreH10 : (retval_2 = (original.(semaphore_addr) ))) (PreH11 : (retval = &((retval_2)  # "Semaphore" ->ₛ "id"))) (PreH12 : (In original (st_lock.(os_semaphores) ) )) (PreH13 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH14 : (retval = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id"))) (PreH15 : ((original.(semaphore_addr) ) <> 0)) (PreH16 : (retval <> 0)) (PreH17 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH18 : (retval <> 0)) (PreH19 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH20 : (Crtos_RTrans before_outside_critical st_lock )) (PreH21 : (id_pre >= 0)) (PreH22 : ((INT_MIN) <= id_pre)) (PreH23 : (id_pre <= INT_MAX)) (PreH24 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  ((original.(semaphore_pending_addrs) ) <> (@nil Z))
.

Definition _SemaphoreDelete_entail_wit_3_2 := 
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (original: SemaphoreAbs) (retval_2: Z) (retval_3: Z) (PreH1 : (retval_3 <> 0)) (PreH2 : (retval_3 = 1)) (PreH3 : ((map (sched_link_node) ((original.(semaphore_pending_addrs) ))) = (@nil (@DL_Node Z)))) (PreH4 : (In original (st_lock.(os_semaphores) ) )) (PreH5 : (retval_2 = (original.(semaphore_addr) ))) (PreH6 : (retval = &((retval_2)  # "Semaphore" ->ₛ "id"))) (PreH7 : (In original (st_lock.(os_semaphores) ) )) (PreH8 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH9 : (retval = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id"))) (PreH10 : ((original.(semaphore_addr) ) <> 0)) (PreH11 : (retval <> 0)) (PreH12 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH13 : (retval <> 0)) (PreH14 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH15 : (Crtos_RTrans before_outside_critical st_lock )) (PreH16 : (id_pre >= 0)) (PreH17 : ((INT_MIN) <= id_pre)) (PreH18 : (id_pre <= INT_MAX)) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_dll (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) )
  **  (delete_pending_restore sg_outside_critical st_lock (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  EX (drained: VarGlobalState) ,
  “ (0 <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ ((original.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ (retval = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (0 = 0) ” 
  &&  “ ((original.(semaphore_pending_addrs) ) = (@nil Z)) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) ) ”
  &&  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical drained )
) \/
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (original: SemaphoreAbs) (retval_2: Z) (retval_3: Z) (PreH1 : (retval_3 <> 0)) (PreH2 : (retval_3 = 1)) (PreH3 : ((map (sched_link_node) ((original.(semaphore_pending_addrs) ))) = (@nil (@DL_Node Z)))) (PreH4 : (In original (st_lock.(os_semaphores) ) )) (PreH5 : (retval_2 = (original.(semaphore_addr) ))) (PreH6 : (retval = &((retval_2)  # "Semaphore" ->ₛ "id"))) (PreH7 : (In original (st_lock.(os_semaphores) ) )) (PreH8 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH9 : (retval = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id"))) (PreH10 : ((original.(semaphore_addr) ) <> 0)) (PreH11 : (retval <> 0)) (PreH12 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH13 : (retval <> 0)) (PreH14 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH15 : (Crtos_RTrans before_outside_critical st_lock )) (PreH16 : (id_pre >= 0)) (PreH17 : ((INT_MIN) <= id_pre)) (PreH18 : (id_pre <= INT_MAX)) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_dll (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) )
  **  (delete_pending_restore sg_outside_critical st_lock (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  EX (drained: VarGlobalState) ,
  “ (0 <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ (retval = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ ((original.(semaphore_pending_addrs) ) = (@nil Z)) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) ) ”
  &&  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical drained )
).

Definition _SemaphoreDelete_entail_wit_4_1 := 
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH3 : (semaphore_context (os_semaphore_stable (sg_outside_critical)) )) (PreH4 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = false)) (PreH5 : (In original (st_lock.(os_semaphores) ) )) (PreH6 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH7 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH8 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH9 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH10 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH11 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH12 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH13 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH14 : (In original (st_lock.(os_semaphores) ) )) (PreH15 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH16 : (0 <= id_pre)) (PreH17 : (id_pre <= INT_MAX)) (PreH18 : (sem = (original.(semaphore_addr) ))) (PreH19 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH20 : (In original (st_lock.(os_semaphores) ) )) (PreH21 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH22 : (resched = 0)) (PreH23 : ((original.(semaphore_pending_addrs) ) = (@nil Z))) (PreH24 : (Crtos_RTrans before_outside_critical st_lock )) (PreH25 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH26 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH27 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (store_dll (store_semaphore ((pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((map (semaphore_link_node) (suffix)))) )
  **  (store_semaphore (pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))) &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "link") current )
  **  (store_node_self_linked &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "link") )
  **  (delete_global_frame sg_outside_critical drained )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  EX (after: VarGlobalState) ,
  “ ((original.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id")) ” 
  &&  “ ((original.(semaphore_id) ) = (original.(semaphore_id) )) ” 
  &&  “ (resched = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock after ) ”
  &&  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical after )
  **  (SemaphoreRetired (original.(semaphore_addr) ) (original.(semaphore_value) ) )
) \/
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH3 : (semaphore_context (os_semaphore_stable (sg_outside_critical)) )) (PreH4 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = false)) (PreH5 : (In original (st_lock.(os_semaphores) ) )) (PreH6 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH7 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH8 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH9 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH10 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH11 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH12 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH13 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH14 : (In original (st_lock.(os_semaphores) ) )) (PreH15 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH16 : (0 <= id_pre)) (PreH17 : (id_pre <= INT_MAX)) (PreH18 : (sem = (original.(semaphore_addr) ))) (PreH19 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH20 : (In original (st_lock.(os_semaphores) ) )) (PreH21 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH22 : (resched = 0)) (PreH23 : ((original.(semaphore_pending_addrs) ) = (@nil Z))) (PreH24 : (Crtos_RTrans before_outside_critical st_lock )) (PreH25 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH26 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH27 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (store_dll (store_semaphore ((pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((map (semaphore_link_node) (suffix)))) )
  **  (store_semaphore (pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))) &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "link") current )
  **  (store_node_self_linked &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "link") )
  **  (delete_global_frame sg_outside_critical drained )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  EX (after: VarGlobalState) ,
  “ (idnode = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (resched = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock after ) ”
  &&  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical after )
  **  (SemaphoreRetired (original.(semaphore_addr) ) (original.(semaphore_value) ) )
).

Definition _SemaphoreDelete_entail_wit_4_2 := 
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (idnode_2: Z) (PreH1 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH3 : (semaphore_context (os_semaphore_stable (sg_outside_critical)) )) (PreH4 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH5 : (idmanager_contains (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) (original.(semaphore_id) ) idnode_2 )) (PreH6 : (idnode_2 <> 0)) (PreH7 : (&((idnode_2)  # "IdNode" ->ₛ "link") <> 0)) (PreH8 : (In original (st_lock.(os_semaphores) ) )) (PreH9 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH10 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH11 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH12 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH13 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH14 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH15 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH16 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH17 : (In original (st_lock.(os_semaphores) ) )) (PreH18 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH19 : (0 <= id_pre)) (PreH20 : (id_pre <= INT_MAX)) (PreH21 : (sem = (original.(semaphore_addr) ))) (PreH22 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH23 : (In original (st_lock.(os_semaphores) ) )) (PreH24 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH25 : (resched = 0)) (PreH26 : ((original.(semaphore_pending_addrs) ) = (@nil Z))) (PreH27 : (Crtos_RTrans before_outside_critical st_lock )) (PreH28 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH29 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH30 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (store_dll (store_semaphore ((pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((map (semaphore_link_node) (suffix)))) )
  **  (store_semaphore (pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))) &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "link") current )
  **  (store_node_self_linked &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "link") )
  **  (delete_global_frame sg_outside_critical drained )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (idmanager_remove ((semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical))))) ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) ( &( "k_sem_id_manager" ) ) )
  **  ((&((idnode_2)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  (InsideCritical sg_outside_critical st_lock )
|--
  EX (after: VarGlobalState) ,
  “ ((original.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id")) ” 
  &&  “ ((original.(semaphore_id) ) = (original.(semaphore_id) )) ” 
  &&  “ (resched = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock after ) ”
  &&  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical after )
  **  (SemaphoreRetired (original.(semaphore_addr) ) (original.(semaphore_value) ) )
) \/
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (idnode_2: Z) (PreH1 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH3 : (semaphore_context (os_semaphore_stable (sg_outside_critical)) )) (PreH4 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH5 : (idmanager_contains (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) (original.(semaphore_id) ) idnode_2 )) (PreH6 : (idnode_2 <> 0)) (PreH7 : (&((idnode_2)  # "IdNode" ->ₛ "link") <> 0)) (PreH8 : (In original (st_lock.(os_semaphores) ) )) (PreH9 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH10 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH11 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH12 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH13 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH14 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH15 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH16 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH17 : (In original (st_lock.(os_semaphores) ) )) (PreH18 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH19 : (0 <= id_pre)) (PreH20 : (id_pre <= INT_MAX)) (PreH21 : (sem = (original.(semaphore_addr) ))) (PreH22 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH23 : (In original (st_lock.(os_semaphores) ) )) (PreH24 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH25 : (resched = 0)) (PreH26 : ((original.(semaphore_pending_addrs) ) = (@nil Z))) (PreH27 : (Crtos_RTrans before_outside_critical st_lock )) (PreH28 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH29 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH30 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (store_dll (store_semaphore ((pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((map (semaphore_link_node) (suffix)))) )
  **  (store_semaphore (pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))) &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "link") current )
  **  (store_node_self_linked &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "link") )
  **  (delete_global_frame sg_outside_critical drained )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (idmanager_remove ((semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical))))) ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) ( &( "k_sem_id_manager" ) ) )
  **  ((&((idnode_2)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  (InsideCritical sg_outside_critical st_lock )
|--
  EX (after: VarGlobalState) ,
  “ (idnode = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (resched = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock after ) ”
  &&  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical after )
  **  (SemaphoreRetired (original.(semaphore_addr) ) (original.(semaphore_value) ) )
).

Definition _SemaphoreDelete_entail_wit_4_3 := 
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH3 : (semaphore_context (os_semaphore_stable (sg_outside_critical)) )) (PreH4 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = false)) (PreH5 : (In original (st_lock.(os_semaphores) ) )) (PreH6 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH7 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH8 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH9 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH10 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH11 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH12 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH13 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH14 : (In original (st_lock.(os_semaphores) ) )) (PreH15 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH16 : (0 <= id_pre)) (PreH17 : (id_pre <= INT_MAX)) (PreH18 : (sem = (original.(semaphore_addr) ))) (PreH19 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH20 : (In original (st_lock.(os_semaphores) ) )) (PreH21 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH22 : (resched = 1)) (PreH23 : ((original.(semaphore_pending_addrs) ) <> (@nil Z))) (PreH24 : (Crtos_RTrans before_outside_critical st_lock )) (PreH25 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH26 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH27 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (store_dll (store_semaphore ((pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((map (semaphore_link_node) (suffix)))) )
  **  (store_semaphore (pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))) &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "link") current )
  **  (store_node_self_linked &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "link") )
  **  (delete_global_frame sg_outside_critical drained )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  EX (after: VarGlobalState) ,
  “ ((original.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id")) ” 
  &&  “ ((original.(semaphore_id) ) = (original.(semaphore_id) )) ” 
  &&  “ (resched = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock after ) ”
  &&  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical after )
  **  (SemaphoreRetired (original.(semaphore_addr) ) (original.(semaphore_value) ) )
) \/
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH3 : (semaphore_context (os_semaphore_stable (sg_outside_critical)) )) (PreH4 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = false)) (PreH5 : (In original (st_lock.(os_semaphores) ) )) (PreH6 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH7 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH8 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH9 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH10 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH11 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH12 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH13 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH14 : (In original (st_lock.(os_semaphores) ) )) (PreH15 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH16 : (0 <= id_pre)) (PreH17 : (id_pre <= INT_MAX)) (PreH18 : (sem = (original.(semaphore_addr) ))) (PreH19 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH20 : (In original (st_lock.(os_semaphores) ) )) (PreH21 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH22 : (resched = 1)) (PreH23 : ((original.(semaphore_pending_addrs) ) <> (@nil Z))) (PreH24 : (Crtos_RTrans before_outside_critical st_lock )) (PreH25 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH26 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH27 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (store_dll (store_semaphore ((pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((map (semaphore_link_node) (suffix)))) )
  **  (store_semaphore (pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))) &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "link") current )
  **  (store_node_self_linked &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "link") )
  **  (delete_global_frame sg_outside_critical drained )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  EX (after: VarGlobalState) ,
  “ (idnode = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (resched = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock after ) ”
  &&  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical after )
  **  (SemaphoreRetired (original.(semaphore_addr) ) (original.(semaphore_value) ) )
).

Definition _SemaphoreDelete_entail_wit_4_4 := 
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (idnode_2: Z) (PreH1 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH3 : (semaphore_context (os_semaphore_stable (sg_outside_critical)) )) (PreH4 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH5 : (idmanager_contains (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) (original.(semaphore_id) ) idnode_2 )) (PreH6 : (idnode_2 <> 0)) (PreH7 : (&((idnode_2)  # "IdNode" ->ₛ "link") <> 0)) (PreH8 : (In original (st_lock.(os_semaphores) ) )) (PreH9 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH10 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH11 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH12 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH13 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH14 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH15 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH16 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH17 : (In original (st_lock.(os_semaphores) ) )) (PreH18 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH19 : (0 <= id_pre)) (PreH20 : (id_pre <= INT_MAX)) (PreH21 : (sem = (original.(semaphore_addr) ))) (PreH22 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH23 : (In original (st_lock.(os_semaphores) ) )) (PreH24 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH25 : (resched = 1)) (PreH26 : ((original.(semaphore_pending_addrs) ) <> (@nil Z))) (PreH27 : (Crtos_RTrans before_outside_critical st_lock )) (PreH28 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH29 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH30 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (store_dll (store_semaphore ((pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((map (semaphore_link_node) (suffix)))) )
  **  (store_semaphore (pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))) &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "link") current )
  **  (store_node_self_linked &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "link") )
  **  (delete_global_frame sg_outside_critical drained )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (idmanager_remove ((semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical))))) ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) ( &( "k_sem_id_manager" ) ) )
  **  ((&((idnode_2)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  (InsideCritical sg_outside_critical st_lock )
|--
  EX (after: VarGlobalState) ,
  “ ((original.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id")) ” 
  &&  “ ((original.(semaphore_id) ) = (original.(semaphore_id) )) ” 
  &&  “ (resched = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock after ) ”
  &&  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical after )
  **  (SemaphoreRetired (original.(semaphore_addr) ) (original.(semaphore_value) ) )
) \/
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (idnode_2: Z) (PreH1 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH3 : (semaphore_context (os_semaphore_stable (sg_outside_critical)) )) (PreH4 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH5 : (idmanager_contains (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) (original.(semaphore_id) ) idnode_2 )) (PreH6 : (idnode_2 <> 0)) (PreH7 : (&((idnode_2)  # "IdNode" ->ₛ "link") <> 0)) (PreH8 : (In original (st_lock.(os_semaphores) ) )) (PreH9 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH10 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH11 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH12 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH13 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH14 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH15 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH16 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH17 : (In original (st_lock.(os_semaphores) ) )) (PreH18 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH19 : (0 <= id_pre)) (PreH20 : (id_pre <= INT_MAX)) (PreH21 : (sem = (original.(semaphore_addr) ))) (PreH22 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH23 : (In original (st_lock.(os_semaphores) ) )) (PreH24 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH25 : (resched = 1)) (PreH26 : ((original.(semaphore_pending_addrs) ) <> (@nil Z))) (PreH27 : (Crtos_RTrans before_outside_critical st_lock )) (PreH28 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH29 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH30 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (store_dll (store_semaphore ((pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((map (semaphore_link_node) (suffix)))) )
  **  (store_semaphore (pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))) &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "link") current )
  **  (store_node_self_linked &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "link") )
  **  (delete_global_frame sg_outside_critical drained )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (idmanager_remove ((semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical))))) ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) ( &( "k_sem_id_manager" ) ) )
  **  ((&((idnode_2)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  (InsideCritical sg_outside_critical st_lock )
|--
  EX (after: VarGlobalState) ,
  “ (idnode = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (resched = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock after ) ”
  &&  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical after )
  **  (SemaphoreRetired (original.(semaphore_addr) ) (original.(semaphore_value) ) )
).

Definition _SemaphoreDelete_entail_wit_5_1 := 
forall (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (delete_sem_id: Z) (resched: Z) (after: VarGlobalState) (PreH1 : (sem = (original.(semaphore_addr) ))) (PreH2 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH3 : (delete_sem_id = (original.(semaphore_id) ))) (PreH4 : (resched = 1)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_outside_critical )) (PreH6 : (Crtos_GTrans st_lock after )) (PreH7 : (resched = 0)) ,
  (OutsideCritical sg_outside_critical after )
|--
  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (delete_sem_id = (original.(semaphore_id) )) ” 
  &&  “ (resched = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock after ) ” 
  &&  “ (resched = 0) ”
  &&  (OutsideCritical sg_outside_critical after )
.

Definition _SemaphoreDelete_entail_wit_5_2 := 
forall (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (delete_sem_id: Z) (resched: Z) (after: VarGlobalState) (PreH1 : (sem = (original.(semaphore_addr) ))) (PreH2 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH3 : (delete_sem_id = (original.(semaphore_id) ))) (PreH4 : (resched = 0)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_outside_critical )) (PreH6 : (Crtos_GTrans st_lock after )) (PreH7 : (resched = 0)) ,
  (OutsideCritical sg_outside_critical after )
|--
  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (delete_sem_id = (original.(semaphore_id) )) ” 
  &&  “ (resched = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock after ) ” 
  &&  “ (resched = 0) ”
  &&  (OutsideCritical sg_outside_critical after )
.

Definition _SemaphoreDelete_entail_wit_6_1 := 
forall (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (delete_sem_id: Z) (resched: Z) (after: VarGlobalState) (PreH1 : (sem = (original.(semaphore_addr) ))) (PreH2 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH3 : (delete_sem_id = (original.(semaphore_id) ))) (PreH4 : (resched = 1)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_outside_critical )) (PreH6 : (Crtos_GTrans st_lock after )) (PreH7 : (resched <> 0)) ,
  (OutsideCritical sg_outside_critical after )
|--
  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (delete_sem_id = (original.(semaphore_id) )) ” 
  &&  “ (resched = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock after ) ” 
  &&  “ (resched <> 0) ”
  &&  (OutsideCritical sg_outside_critical after )
.

Definition _SemaphoreDelete_entail_wit_6_2 := 
forall (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (delete_sem_id: Z) (resched: Z) (after: VarGlobalState) (PreH1 : (sem = (original.(semaphore_addr) ))) (PreH2 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH3 : (delete_sem_id = (original.(semaphore_id) ))) (PreH4 : (resched = 0)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_outside_critical )) (PreH6 : (Crtos_GTrans st_lock after )) (PreH7 : (resched <> 0)) ,
  (OutsideCritical sg_outside_critical after )
|--
  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (delete_sem_id = (original.(semaphore_id) )) ” 
  &&  “ (resched = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock after ) ” 
  &&  “ (resched <> 0) ”
  &&  (OutsideCritical sg_outside_critical after )
.

Definition _SemaphoreDelete_return_wit_1 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (resched: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : (resched = 0)) (PreH4 : (sem = 0)) (PreH5 : (idnode = 0)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (tt)) X_outside_critical )) (PreH7 : (Crtos_GTrans st_lock st_lock )) ,
  (OutsideCritical sg_outside_critical st_lock )
|--
  EX (after: VarGlobalState) ,
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_outside_critical ) ”
  &&  (OutsideCritical sg_outside_critical after )
.

Definition _SemaphoreDelete_return_wit_2 := 
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (PreH1 : (id_pre < 0)) (PreH2 : ((INT_MIN) <= id_pre)) (PreH3 : (id_pre <= INT_MAX)) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  EX (after: VarGlobalState) ,
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_outside_critical ) ”
  &&  (OutsideCritical sg_outside_critical after )
) \/
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (PreH1 : (id_pre < 0)) (PreH2 : ((INT_MIN) <= id_pre)) (PreH3 : (id_pre <= INT_MAX)) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) ( MonadErr.ret  (tt)) X_outside_critical ) ”
  &&  emp
).

Definition _SemaphoreDelete_return_wit_2_split_goal_1 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (PreH1 : (id_pre < 0)) (PreH2 : ((INT_MIN) <= id_pre)) (PreH3 : (id_pre <= INT_MAX)) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) ( MonadErr.ret  (tt)) X_outside_critical )
.

Definition _SemaphoreDelete_return_wit_3 := 
forall (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (delete_sem_id: Z) (resched: Z) (after_2: VarGlobalState) (after_3: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (after_3)) ( MonadErr.ret  (tt)) X_outside_critical )) (PreH2 : (sem = (original.(semaphore_addr) ))) (PreH3 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH4 : (delete_sem_id = (original.(semaphore_id) ))) (PreH5 : (resched = 1)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (after_2)) abs_ktask_assign X_outside_critical )) (PreH7 : (Crtos_GTrans st_lock after_2 )) (PreH8 : (resched <> 0)) ,
  (OutsideCritical sg_outside_critical after_3 )
|--
  EX (after: VarGlobalState) ,
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_outside_critical ) ”
  &&  (OutsideCritical sg_outside_critical after )
.

Definition _SemaphoreDelete_return_wit_4 := 
forall (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (delete_sem_id: Z) (resched: Z) (after_2: VarGlobalState) (PreH1 : (sem = (original.(semaphore_addr) ))) (PreH2 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH3 : (delete_sem_id = (original.(semaphore_id) ))) (PreH4 : (resched = 0)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (after_2)) ( MonadErr.ret  (tt)) X_outside_critical )) (PreH6 : (Crtos_GTrans st_lock after_2 )) (PreH7 : (resched = 0)) ,
  (OutsideCritical sg_outside_critical after_2 )
|--
  EX (after: VarGlobalState) ,
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_outside_critical ) ”
  &&  (OutsideCritical sg_outside_critical after )
.

Definition _SemaphoreDelete_partial_solve_wit_1 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (PreH1 : (id_pre >= 0)) (PreH2 : ((INT_MIN) <= id_pre)) (PreH3 : (id_pre <= INT_MAX)) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (OutsideCritical sg_outside_critical before_outside_critical )
|--
  “ (id_pre >= 0) ” 
  &&  “ ((INT_MIN) <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ”
  &&  (OutsideCritical sg_outside_critical before_outside_critical )
.

Definition _SemaphoreDelete_partial_solve_wit_2 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (PreH1 : (Crtos_RTrans before_outside_critical st_lock )) (PreH2 : (id_pre >= 0)) (PreH3 : ((INT_MIN) <= id_pre)) (PreH4 : (id_pre <= INT_MAX)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical st_lock )
|--
  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ ((INT_MIN) <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ”
  &&  (os_inv sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_partial_solve_wit_3_pure := 
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (PreH1 : (Crtos_RTrans before_outside_critical st_lock )) (PreH2 : (id_pre >= 0)) (PreH3 : ((INT_MIN) <= id_pre)) (PreH4 : (id_pre <= INT_MAX)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ ((unsigned_last_nbits (id_pre) (16)) < 65536) ” 
  &&  “ (0 <= (unsigned_last_nbits (id_pre) (16))) ”
) \/
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (PreH1 : (id_pre <= INT_MAX)) (PreH2 : (0 <= INT_MAX)) (PreH3 : (retval <= INT_MAX)) (PreH4 : (id_pre >= INT_MIN)) (PreH5 : (0 >= INT_MIN)) (PreH6 : (retval >= INT_MIN)) (PreH7 : (Crtos_RTrans before_outside_critical st_lock )) (PreH8 : (id_pre >= 0)) (PreH9 : ((INT_MIN) <= id_pre)) (PreH10 : (id_pre <= INT_MAX)) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (0 <= (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ ((unsigned_last_nbits (id_pre) (16)) < 65536) ”
).

Definition _SemaphoreDelete_partial_solve_wit_3_pure_split_goal_1 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (PreH1 : (id_pre <= INT_MAX)) (PreH2 : (0 <= INT_MAX)) (PreH3 : (retval <= INT_MAX)) (PreH4 : (id_pre >= INT_MIN)) (PreH5 : (0 >= INT_MIN)) (PreH6 : (retval >= INT_MIN)) (PreH7 : (Crtos_RTrans before_outside_critical st_lock )) (PreH8 : (id_pre >= 0)) (PreH9 : ((INT_MIN) <= id_pre)) (PreH10 : (id_pre <= INT_MAX)) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (0 <= (unsigned_last_nbits (id_pre) (16))) ”
.

Definition _SemaphoreDelete_partial_solve_wit_3_pure_split_goal_2 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (PreH1 : (id_pre <= INT_MAX)) (PreH2 : (0 <= INT_MAX)) (PreH3 : (retval <= INT_MAX)) (PreH4 : (id_pre >= INT_MIN)) (PreH5 : (0 >= INT_MIN)) (PreH6 : (retval >= INT_MIN)) (PreH7 : (Crtos_RTrans before_outside_critical st_lock )) (PreH8 : (id_pre >= 0)) (PreH9 : ((INT_MIN) <= id_pre)) (PreH10 : (id_pre <= INT_MAX)) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ ((unsigned_last_nbits (id_pre) (16)) < 65536) ”
.

Definition _SemaphoreDelete_partial_solve_wit_3_aux := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (PreH1 : (Crtos_RTrans before_outside_critical st_lock )) (PreH2 : (id_pre >= 0)) (PreH3 : ((INT_MIN) <= id_pre)) (PreH4 : (id_pre <= INT_MAX)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ ((unsigned_last_nbits (id_pre) (16)) < 65536) ” 
  &&  “ (0 <= (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ ((INT_MIN) <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ”
  &&  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_partial_solve_wit_3 := _SemaphoreDelete_partial_solve_wit_3_pure -> _SemaphoreDelete_partial_solve_wit_3_aux.

Definition _SemaphoreDelete_partial_solve_wit_4_pure := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (saved_lock: Z) (resched: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : (resched = 0)) (PreH4 : (sem = 0)) (PreH5 : (idnode = 0)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (tt)) X_outside_critical )) (PreH7 : (Crtos_GTrans st_lock st_lock )) ,
  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical st_lock )
|--
  “ (Crtos_GTrans st_lock st_lock ) ”
.

Definition _SemaphoreDelete_partial_solve_wit_4_aux := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (resched: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : (resched = 0)) (PreH4 : (sem = 0)) (PreH5 : (idnode = 0)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (tt)) X_outside_critical )) (PreH7 : (Crtos_GTrans st_lock st_lock )) ,
  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical st_lock )
|--
  “ (Crtos_GTrans st_lock st_lock ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ (resched = 0) ” 
  &&  “ (sem = 0) ” 
  &&  “ (idnode = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (tt)) X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock st_lock ) ”
  &&  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_partial_solve_wit_4 := _SemaphoreDelete_partial_solve_wit_4_pure -> _SemaphoreDelete_partial_solve_wit_4_aux.

Definition _SemaphoreDelete_partial_solve_wit_5 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval <> 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH5 : (Crtos_RTrans before_outside_critical st_lock )) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= id_pre)) (PreH8 : (id_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_idmanager_found (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) retval (unsigned_last_nbits (id_pre) (16)) )
  **  (delete_manager_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (retval <> 0) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ ((INT_MIN) <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ”
  &&  (store_idmanager_found (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) retval (unsigned_last_nbits (id_pre) (16)) )
  **  (delete_manager_frame sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_partial_solve_wit_6_pure := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval_2: Z) (st_lock: VarGlobalState) (retval: Z) (original: SemaphoreAbs) (PreH1 : (In original (st_lock.(os_semaphores) ) )) (PreH2 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH3 : (retval = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id"))) (PreH4 : ((original.(semaphore_addr) ) <> 0)) (PreH5 : (retval <> 0)) (PreH6 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH7 : (retval <> 0)) (PreH8 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH9 : (Crtos_RTrans before_outside_critical st_lock )) (PreH10 : (id_pre >= 0)) (PreH11 : ((INT_MIN) <= id_pre)) (PreH12 : (id_pre <= INT_MAX)) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval)
  **  (os_inv sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval_2)
  **  ((( &( "resched" ) )) # Int  |-> 0)
|--
  “ (retval = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id")) ”
.

Definition _SemaphoreDelete_partial_solve_wit_6_aux := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (original: SemaphoreAbs) (PreH1 : (In original (st_lock.(os_semaphores) ) )) (PreH2 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH3 : (retval = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id"))) (PreH4 : ((original.(semaphore_addr) ) <> 0)) (PreH5 : (retval <> 0)) (PreH6 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH7 : (retval <> 0)) (PreH8 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH9 : (Crtos_RTrans before_outside_critical st_lock )) (PreH10 : (id_pre >= 0)) (PreH11 : ((INT_MIN) <= id_pre)) (PreH12 : (id_pre <= INT_MAX)) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (os_inv sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (retval = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (retval = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id")) ” 
  &&  “ ((original.(semaphore_addr) ) <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ ((INT_MIN) <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ”
  &&  (os_inv sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_partial_solve_wit_6 := _SemaphoreDelete_partial_solve_wit_6_pure -> _SemaphoreDelete_partial_solve_wit_6_aux.

Definition _SemaphoreDelete_partial_solve_wit_7_pure := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (original: SemaphoreAbs) (retval_3: Z) (PreH1 : (retval_3 = (original.(semaphore_addr) ))) (PreH2 : (retval_2 = &((retval_3)  # "Semaphore" ->ₛ "id"))) (PreH3 : (In original (st_lock.(os_semaphores) ) )) (PreH4 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH5 : (retval_2 = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id"))) (PreH6 : ((original.(semaphore_addr) ) <> 0)) (PreH7 : (retval_2 <> 0)) (PreH8 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH9 : (retval_2 <> 0)) (PreH10 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH11 : (Crtos_RTrans before_outside_critical st_lock )) (PreH12 : (id_pre >= 0)) (PreH13 : ((INT_MIN) <= id_pre)) (PreH14 : (id_pre <= INT_MAX)) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  (os_inv sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "sem" ) )) # Ptr  |-> retval_3)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "resched" ) )) # Int  |-> 0)
|--
  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_addr) ) = (original.(semaphore_addr) )) ”
.

Definition _SemaphoreDelete_partial_solve_wit_7_aux := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (retval_2: Z) (original: SemaphoreAbs) (retval_3: Z) (PreH1 : (retval_3 = (original.(semaphore_addr) ))) (PreH2 : (retval_2 = &((retval_3)  # "Semaphore" ->ₛ "id"))) (PreH3 : (In original (st_lock.(os_semaphores) ) )) (PreH4 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH5 : (retval_2 = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id"))) (PreH6 : ((original.(semaphore_addr) ) <> 0)) (PreH7 : (retval_2 <> 0)) (PreH8 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH9 : (retval_2 <> 0)) (PreH10 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH11 : (Crtos_RTrans before_outside_critical st_lock )) (PreH12 : (id_pre >= 0)) (PreH13 : ((INT_MIN) <= id_pre)) (PreH14 : (id_pre <= INT_MAX)) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (os_inv sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "sem" ) )) # Ptr  |-> retval_3)
|--
  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ (retval_3 = (original.(semaphore_addr) )) ” 
  &&  “ (retval_2 = &((retval_3)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (retval_2 = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id")) ” 
  &&  “ ((original.(semaphore_addr) ) <> 0) ” 
  &&  “ (retval_2 <> 0) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (retval_2 <> 0) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ ((INT_MIN) <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ”
  &&  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (os_inv sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_partial_solve_wit_7 := _SemaphoreDelete_partial_solve_wit_7_pure -> _SemaphoreDelete_partial_solve_wit_7_aux.

Definition _SemaphoreDelete_partial_solve_wit_8 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (original: SemaphoreAbs) (retval_2: Z) (PreH1 : (In original (st_lock.(os_semaphores) ) )) (PreH2 : ((original.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH3 : (retval_2 = (original.(semaphore_addr) ))) (PreH4 : (retval = &((retval_2)  # "Semaphore" ->ₛ "id"))) (PreH5 : (In original (st_lock.(os_semaphores) ) )) (PreH6 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH7 : (retval = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id"))) (PreH8 : ((original.(semaphore_addr) ) <> 0)) (PreH9 : (retval <> 0)) (PreH10 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH11 : (retval <> 0)) (PreH12 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH13 : (Crtos_RTrans before_outside_critical st_lock )) (PreH14 : (id_pre >= 0)) (PreH15 : ((INT_MIN) <= id_pre)) (PreH16 : (id_pre <= INT_MAX)) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_dll (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) )
  **  (delete_pending_restore sg_outside_critical st_lock (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (retval_2 = (original.(semaphore_addr) )) ” 
  &&  “ (retval = &((retval_2)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (retval = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id")) ” 
  &&  “ ((original.(semaphore_addr) ) <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ ((INT_MIN) <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ”
  &&  (store_dll (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) )
  **  (delete_pending_restore sg_outside_critical st_lock (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_partial_solve_wit_9_pure := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (original: SemaphoreAbs) (retval_3: Z) (retval_4: Z) (PreH1 : (retval_4 = 0)) (PreH2 : (retval_4 = 0)) (PreH3 : ((map (sched_link_node) ((original.(semaphore_pending_addrs) ))) <> (@nil (@DL_Node Z)))) (PreH4 : (In original (st_lock.(os_semaphores) ) )) (PreH5 : (retval_3 = (original.(semaphore_addr) ))) (PreH6 : (retval_2 = &((retval_3)  # "Semaphore" ->ₛ "id"))) (PreH7 : (In original (st_lock.(os_semaphores) ) )) (PreH8 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH9 : (retval_2 = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id"))) (PreH10 : ((original.(semaphore_addr) ) <> 0)) (PreH11 : (retval_2 <> 0)) (PreH12 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH13 : (retval_2 <> 0)) (PreH14 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH15 : (Crtos_RTrans before_outside_critical st_lock )) (PreH16 : (id_pre >= 0)) (PreH17 : ((INT_MIN) <= id_pre)) (PreH18 : (id_pre <= INT_MAX)) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_dll (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) )
  **  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (delete_pending_restore sg_outside_critical st_lock (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "resched" ) )) # Int  |-> 1)
|--
  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_addr) ) = (original.(semaphore_addr) )) ”
.

Definition _SemaphoreDelete_partial_solve_wit_9_aux := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (retval_2: Z) (original: SemaphoreAbs) (retval_3: Z) (retval_4: Z) (PreH1 : (retval_4 = 0)) (PreH2 : (retval_4 = 0)) (PreH3 : ((map (sched_link_node) ((original.(semaphore_pending_addrs) ))) <> (@nil (@DL_Node Z)))) (PreH4 : (In original (st_lock.(os_semaphores) ) )) (PreH5 : (retval_3 = (original.(semaphore_addr) ))) (PreH6 : (retval_2 = &((retval_3)  # "Semaphore" ->ₛ "id"))) (PreH7 : (In original (st_lock.(os_semaphores) ) )) (PreH8 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH9 : (retval_2 = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id"))) (PreH10 : ((original.(semaphore_addr) ) <> 0)) (PreH11 : (retval_2 <> 0)) (PreH12 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH13 : (retval_2 <> 0)) (PreH14 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH15 : (Crtos_RTrans before_outside_critical st_lock )) (PreH16 : (id_pre >= 0)) (PreH17 : ((INT_MIN) <= id_pre)) (PreH18 : (id_pre <= INT_MAX)) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (store_dll (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) )
  **  (delete_pending_restore sg_outside_critical st_lock (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ (retval_4 = 0) ” 
  &&  “ (retval_4 = 0) ” 
  &&  “ ((map (sched_link_node) ((original.(semaphore_pending_addrs) ))) <> (@nil (@DL_Node Z))) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (retval_3 = (original.(semaphore_addr) )) ” 
  &&  “ (retval_2 = &((retval_3)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (retval_2 = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id")) ” 
  &&  “ ((original.(semaphore_addr) ) <> 0) ” 
  &&  “ (retval_2 <> 0) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (retval_2 <> 0) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ ((INT_MIN) <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ”
  &&  (store_dll (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) )
  **  (delete_pending_restore sg_outside_critical st_lock (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_partial_solve_wit_9 := _SemaphoreDelete_partial_solve_wit_9_pure -> _SemaphoreDelete_partial_solve_wit_9_aux.

Definition _SemaphoreDelete_partial_solve_wit_10_pure := 
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval_2: Z) (st_lock: VarGlobalState) (retval_3: Z) (original: SemaphoreAbs) (retval: Z) (retval_4: Z) (PreH1 : (In original (st_lock.(os_semaphores) ) )) (PreH2 : ((original.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH3 : (semaphore_pending_nodes (original.(semaphore_addr) ) st_lock (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) )) (PreH4 : (retval_4 = 0)) (PreH5 : (retval_4 = 0)) (PreH6 : ((map (sched_link_node) ((original.(semaphore_pending_addrs) ))) <> (@nil (@DL_Node Z)))) (PreH7 : (In original (st_lock.(os_semaphores) ) )) (PreH8 : (retval = (original.(semaphore_addr) ))) (PreH9 : (retval_3 = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH10 : (In original (st_lock.(os_semaphores) ) )) (PreH11 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH12 : (retval_3 = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id"))) (PreH13 : ((original.(semaphore_addr) ) <> 0)) (PreH14 : (retval_3 <> 0)) (PreH15 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH16 : (retval_3 <> 0)) (PreH17 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH18 : (Crtos_RTrans before_outside_critical st_lock )) (PreH19 : (id_pre >= 0)) (PreH20 : ((INT_MIN) <= id_pre)) (PreH21 : (id_pre <= INT_MAX)) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (os_inv sg_outside_critical st_lock )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_3)
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_2)
  **  ((( &( "resched" ) )) # Int  |-> 1)
|--
  “ (&(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "pend_list") = (semaphore_pending_head ((original.(semaphore_addr) )))) ” 
  &&  “ (semaphore_pending_nodes (original.(semaphore_addr) ) st_lock (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) ) ” 
  &&  “ (&((retval)  # "Semaphore" ->ₛ "pend_list") = (semaphore_pending_head (retval))) ”
) \/
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval_2: Z) (st_lock: VarGlobalState) (retval_3: Z) (original: SemaphoreAbs) (retval: Z) (retval_4: Z) (PreH1 : (1 <= INT_MAX)) (PreH2 : (retval_2 <= INT_MAX)) (PreH3 : (id_pre <= INT_MAX)) (PreH4 : (1 >= INT_MIN)) (PreH5 : (retval_2 >= INT_MIN)) (PreH6 : (id_pre >= INT_MIN)) (PreH7 : (In original (st_lock.(os_semaphores) ) )) (PreH8 : (semaphore_pending_nodes (original.(semaphore_addr) ) st_lock (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) )) (PreH9 : (retval_4 = 0)) (PreH10 : (retval_4 = 0)) (PreH11 : ((map (sched_link_node) ((original.(semaphore_pending_addrs) ))) <> (@nil (@DL_Node Z)))) (PreH12 : (In original (st_lock.(os_semaphores) ) )) (PreH13 : (retval = (original.(semaphore_addr) ))) (PreH14 : (retval_3 = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH15 : (In original (st_lock.(os_semaphores) ) )) (PreH16 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH17 : (retval_3 = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id"))) (PreH18 : ((original.(semaphore_addr) ) <> 0)) (PreH19 : (retval_3 <> 0)) (PreH20 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH21 : (retval_3 <> 0)) (PreH22 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH23 : (Crtos_RTrans before_outside_critical st_lock )) (PreH24 : (id_pre >= 0)) (PreH25 : ((INT_MIN) <= id_pre)) (PreH26 : (id_pre <= INT_MAX)) (PreH27 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (os_inv sg_outside_critical st_lock )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_3)
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_2)
  **  ((( &( "resched" ) )) # Int  |-> 1)
|--
  “ (&((retval)  # "Semaphore" ->ₛ "pend_list") = (semaphore_pending_head (retval))) ” 
  &&  “ (&((retval)  # "Semaphore" ->ₛ "pend_list") = (semaphore_pending_head (retval))) ”
).

Definition _SemaphoreDelete_partial_solve_wit_10_pure_split_goal_1 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval_2: Z) (st_lock: VarGlobalState) (retval_3: Z) (original: SemaphoreAbs) (retval: Z) (retval_4: Z) (PreH1 : (1 <= INT_MAX)) (PreH2 : (retval_2 <= INT_MAX)) (PreH3 : (id_pre <= INT_MAX)) (PreH4 : (1 >= INT_MIN)) (PreH5 : (retval_2 >= INT_MIN)) (PreH6 : (id_pre >= INT_MIN)) (PreH7 : (In original (st_lock.(os_semaphores) ) )) (PreH8 : (semaphore_pending_nodes (original.(semaphore_addr) ) st_lock (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) )) (PreH9 : (retval_4 = 0)) (PreH10 : (retval_4 = 0)) (PreH11 : ((map (sched_link_node) ((original.(semaphore_pending_addrs) ))) <> (@nil (@DL_Node Z)))) (PreH12 : (In original (st_lock.(os_semaphores) ) )) (PreH13 : (retval = (original.(semaphore_addr) ))) (PreH14 : (retval_3 = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH15 : (In original (st_lock.(os_semaphores) ) )) (PreH16 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH17 : (retval_3 = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id"))) (PreH18 : ((original.(semaphore_addr) ) <> 0)) (PreH19 : (retval_3 <> 0)) (PreH20 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH21 : (retval_3 <> 0)) (PreH22 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH23 : (Crtos_RTrans before_outside_critical st_lock )) (PreH24 : (id_pre >= 0)) (PreH25 : ((INT_MIN) <= id_pre)) (PreH26 : (id_pre <= INT_MAX)) (PreH27 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (os_inv sg_outside_critical st_lock )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_3)
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_2)
  **  ((( &( "resched" ) )) # Int  |-> 1)
|--
  “ (&((retval)  # "Semaphore" ->ₛ "pend_list") = (semaphore_pending_head (retval))) ”
.

Definition _SemaphoreDelete_partial_solve_wit_10_pure_split_goal_2 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (retval_2: Z) (st_lock: VarGlobalState) (retval_3: Z) (original: SemaphoreAbs) (retval: Z) (retval_4: Z) (PreH1 : (1 <= INT_MAX)) (PreH2 : (retval_2 <= INT_MAX)) (PreH3 : (id_pre <= INT_MAX)) (PreH4 : (1 >= INT_MIN)) (PreH5 : (retval_2 >= INT_MIN)) (PreH6 : (id_pre >= INT_MIN)) (PreH7 : (In original (st_lock.(os_semaphores) ) )) (PreH8 : (semaphore_pending_nodes (original.(semaphore_addr) ) st_lock (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) )) (PreH9 : (retval_4 = 0)) (PreH10 : (retval_4 = 0)) (PreH11 : ((map (sched_link_node) ((original.(semaphore_pending_addrs) ))) <> (@nil (@DL_Node Z)))) (PreH12 : (In original (st_lock.(os_semaphores) ) )) (PreH13 : (retval = (original.(semaphore_addr) ))) (PreH14 : (retval_3 = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH15 : (In original (st_lock.(os_semaphores) ) )) (PreH16 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH17 : (retval_3 = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id"))) (PreH18 : ((original.(semaphore_addr) ) <> 0)) (PreH19 : (retval_3 <> 0)) (PreH20 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH21 : (retval_3 <> 0)) (PreH22 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH23 : (Crtos_RTrans before_outside_critical st_lock )) (PreH24 : (id_pre >= 0)) (PreH25 : ((INT_MIN) <= id_pre)) (PreH26 : (id_pre <= INT_MAX)) (PreH27 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (os_inv sg_outside_critical st_lock )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_3)
  **  (InsideCritical sg_outside_critical st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_2)
  **  ((( &( "resched" ) )) # Int  |-> 1)
|--
  “ (&((retval)  # "Semaphore" ->ₛ "pend_list") = (semaphore_pending_head (retval))) ”
.

Definition _SemaphoreDelete_partial_solve_wit_10_aux := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (retval_3: Z) (original: SemaphoreAbs) (retval: Z) (retval_4: Z) (PreH1 : (In original (st_lock.(os_semaphores) ) )) (PreH2 : ((original.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH3 : (semaphore_pending_nodes (original.(semaphore_addr) ) st_lock (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) )) (PreH4 : (retval_4 = 0)) (PreH5 : (retval_4 = 0)) (PreH6 : ((map (sched_link_node) ((original.(semaphore_pending_addrs) ))) <> (@nil (@DL_Node Z)))) (PreH7 : (In original (st_lock.(os_semaphores) ) )) (PreH8 : (retval = (original.(semaphore_addr) ))) (PreH9 : (retval_3 = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH10 : (In original (st_lock.(os_semaphores) ) )) (PreH11 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH12 : (retval_3 = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id"))) (PreH13 : ((original.(semaphore_addr) ) <> 0)) (PreH14 : (retval_3 <> 0)) (PreH15 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH16 : (retval_3 <> 0)) (PreH17 : ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH18 : (Crtos_RTrans before_outside_critical st_lock )) (PreH19 : (id_pre >= 0)) (PreH20 : ((INT_MIN) <= id_pre)) (PreH21 : (id_pre <= INT_MAX)) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) ,
  (os_inv sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (&(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "pend_list") = (semaphore_pending_head ((original.(semaphore_addr) )))) ” 
  &&  “ (semaphore_pending_nodes (original.(semaphore_addr) ) st_lock (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) ) ” 
  &&  “ (&((retval)  # "Semaphore" ->ₛ "pend_list") = (semaphore_pending_head (retval))) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (semaphore_pending_nodes (original.(semaphore_addr) ) st_lock (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) ) ” 
  &&  “ (retval_4 = 0) ” 
  &&  “ (retval_4 = 0) ” 
  &&  “ ((map (sched_link_node) ((original.(semaphore_pending_addrs) ))) <> (@nil (@DL_Node Z))) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (retval = (original.(semaphore_addr) )) ” 
  &&  “ (retval_3 = &((retval)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (retval_3 = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id")) ” 
  &&  “ ((original.(semaphore_addr) ) <> 0) ” 
  &&  “ (retval_3 <> 0) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (retval_3 <> 0) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((st_lock.(os_semaphores) )))) ((unsigned_last_nbits (id_pre) (16)))) = true) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ ((INT_MIN) <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ”
  &&  (os_inv sg_outside_critical st_lock )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_partial_solve_wit_10 := _SemaphoreDelete_partial_solve_wit_10_pure -> _SemaphoreDelete_partial_solve_wit_10_aux.

Definition _SemaphoreDelete_partial_solve_wit_11_pure := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (saved_lock: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : (sem = (original.(semaphore_addr) ))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : (In original (st_lock.(os_semaphores) ) )) (PreH6 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH7 : (resched = 1)) (PreH8 : ((original.(semaphore_pending_addrs) ) <> (@nil Z))) (PreH9 : (Crtos_RTrans before_outside_critical st_lock )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH11 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH12 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical drained )
|--
  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ”
.

Definition _SemaphoreDelete_partial_solve_wit_11_aux := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : (sem = (original.(semaphore_addr) ))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : (In original (st_lock.(os_semaphores) ) )) (PreH6 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH7 : (resched = 1)) (PreH8 : ((original.(semaphore_pending_addrs) ) <> (@nil Z))) (PreH9 : (Crtos_RTrans before_outside_critical st_lock )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH11 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH12 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical drained )
|--
  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (resched = 1) ” 
  &&  “ ((original.(semaphore_pending_addrs) ) <> (@nil Z)) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ” 
  &&  “ (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) ) ”
  &&  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (os_inv sg_outside_critical drained )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_partial_solve_wit_11 := _SemaphoreDelete_partial_solve_wit_11_pure -> _SemaphoreDelete_partial_solve_wit_11_aux.

Definition _SemaphoreDelete_partial_solve_wit_12_pure := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (saved_lock: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : (sem = (original.(semaphore_addr) ))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : (In original (st_lock.(os_semaphores) ) )) (PreH6 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH7 : (resched = 0)) (PreH8 : ((original.(semaphore_pending_addrs) ) = (@nil Z))) (PreH9 : (Crtos_RTrans before_outside_critical st_lock )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH11 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH12 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical drained )
|--
  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ”
.

Definition _SemaphoreDelete_partial_solve_wit_12_aux := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : (sem = (original.(semaphore_addr) ))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : (In original (st_lock.(os_semaphores) ) )) (PreH6 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH7 : (resched = 0)) (PreH8 : ((original.(semaphore_pending_addrs) ) = (@nil Z))) (PreH9 : (Crtos_RTrans before_outside_critical st_lock )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH11 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH12 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical drained )
|--
  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (resched = 0) ” 
  &&  “ ((original.(semaphore_pending_addrs) ) = (@nil Z)) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ” 
  &&  “ (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) ) ”
  &&  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (os_inv sg_outside_critical drained )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_partial_solve_wit_12 := _SemaphoreDelete_partial_solve_wit_12_pure -> _SemaphoreDelete_partial_solve_wit_12_aux.

Definition _SemaphoreDelete_partial_solve_wit_13 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (PreH1 : (In original (st_lock.(os_semaphores) ) )) (PreH2 : ((original.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH3 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= INT_MAX)) (PreH6 : (sem = (original.(semaphore_addr) ))) (PreH7 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH8 : (In original (st_lock.(os_semaphores) ) )) (PreH9 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH10 : (resched = 1)) (PreH11 : ((original.(semaphore_pending_addrs) ) <> (@nil Z))) (PreH12 : (Crtos_RTrans before_outside_critical st_lock )) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH14 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH15 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  ((&(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id" .ₛ "id")) # UShort  |-> (original.(semaphore_id) ))
  **  (delete_id_restore sg_outside_critical drained (original.(semaphore_addr) ) (original.(semaphore_id) ) )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (resched = 1) ” 
  &&  “ ((original.(semaphore_pending_addrs) ) <> (@nil Z)) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ” 
  &&  “ (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) ) ”
  &&  ((&(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id" .ₛ "id")) # UShort  |-> (original.(semaphore_id) ))
  **  (delete_id_restore sg_outside_critical drained (original.(semaphore_addr) ) (original.(semaphore_id) ) )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_partial_solve_wit_14 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (PreH1 : (In original (st_lock.(os_semaphores) ) )) (PreH2 : ((original.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH3 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= INT_MAX)) (PreH6 : (sem = (original.(semaphore_addr) ))) (PreH7 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH8 : (In original (st_lock.(os_semaphores) ) )) (PreH9 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH10 : (resched = 0)) (PreH11 : ((original.(semaphore_pending_addrs) ) = (@nil Z))) (PreH12 : (Crtos_RTrans before_outside_critical st_lock )) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH14 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH15 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  ((&(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id" .ₛ "id")) # UShort  |-> (original.(semaphore_id) ))
  **  (delete_id_restore sg_outside_critical drained (original.(semaphore_addr) ) (original.(semaphore_id) ) )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (resched = 0) ” 
  &&  “ ((original.(semaphore_pending_addrs) ) = (@nil Z)) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ” 
  &&  “ (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) ) ”
  &&  ((&(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id" .ₛ "id")) # UShort  |-> (original.(semaphore_id) ))
  **  (delete_id_restore sg_outside_critical drained (original.(semaphore_addr) ) (original.(semaphore_id) ) )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_partial_solve_wit_15_pure := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (saved_lock: Z) (PreH1 : ((original.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH2 : (In original (st_lock.(os_semaphores) ) )) (PreH3 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= INT_MAX)) (PreH6 : (sem = (original.(semaphore_addr) ))) (PreH7 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH8 : (In original (st_lock.(os_semaphores) ) )) (PreH9 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH10 : (resched = 1)) (PreH11 : ((original.(semaphore_pending_addrs) ) <> (@nil Z))) (PreH12 : (Crtos_RTrans before_outside_critical st_lock )) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH14 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH15 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (os_inv sg_outside_critical drained )
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> (original.(semaphore_id) ))
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) ) ”
.

Definition _SemaphoreDelete_partial_solve_wit_15_aux := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (PreH1 : ((original.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH2 : (In original (st_lock.(os_semaphores) ) )) (PreH3 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= INT_MAX)) (PreH6 : (sem = (original.(semaphore_addr) ))) (PreH7 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH8 : (In original (st_lock.(os_semaphores) ) )) (PreH9 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH10 : (resched = 1)) (PreH11 : ((original.(semaphore_pending_addrs) ) <> (@nil Z))) (PreH12 : (Crtos_RTrans before_outside_critical st_lock )) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH14 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH15 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (os_inv sg_outside_critical drained )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) ) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (resched = 1) ” 
  &&  “ ((original.(semaphore_pending_addrs) ) <> (@nil Z)) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ” 
  &&  “ (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) ) ”
  &&  (os_inv sg_outside_critical drained )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_partial_solve_wit_15 := _SemaphoreDelete_partial_solve_wit_15_pure -> _SemaphoreDelete_partial_solve_wit_15_aux.

Definition _SemaphoreDelete_partial_solve_wit_16_pure := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (saved_lock: Z) (PreH1 : ((original.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH2 : (In original (st_lock.(os_semaphores) ) )) (PreH3 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= INT_MAX)) (PreH6 : (sem = (original.(semaphore_addr) ))) (PreH7 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH8 : (In original (st_lock.(os_semaphores) ) )) (PreH9 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH10 : (resched = 0)) (PreH11 : ((original.(semaphore_pending_addrs) ) = (@nil Z))) (PreH12 : (Crtos_RTrans before_outside_critical st_lock )) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH14 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH15 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (os_inv sg_outside_critical drained )
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> (original.(semaphore_id) ))
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) ) ”
.

Definition _SemaphoreDelete_partial_solve_wit_16_aux := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (PreH1 : ((original.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH2 : (In original (st_lock.(os_semaphores) ) )) (PreH3 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= INT_MAX)) (PreH6 : (sem = (original.(semaphore_addr) ))) (PreH7 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH8 : (In original (st_lock.(os_semaphores) ) )) (PreH9 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH10 : (resched = 0)) (PreH11 : ((original.(semaphore_pending_addrs) ) = (@nil Z))) (PreH12 : (Crtos_RTrans before_outside_critical st_lock )) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH14 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH15 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (os_inv sg_outside_critical drained )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) ) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (resched = 0) ” 
  &&  “ ((original.(semaphore_pending_addrs) ) = (@nil Z)) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ” 
  &&  “ (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) ) ”
  &&  (os_inv sg_outside_critical drained )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_partial_solve_wit_16 := _SemaphoreDelete_partial_solve_wit_16_pure -> _SemaphoreDelete_partial_solve_wit_16_aux.

Definition _SemaphoreDelete_partial_solve_wit_17_pure := 
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (saved_lock: Z) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : (In original (st_lock.(os_semaphores) ) )) (PreH2 : ((original.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH3 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH4 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH5 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH6 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH7 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH8 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH9 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH10 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH11 : (In original (st_lock.(os_semaphores) ) )) (PreH12 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH13 : (0 <= id_pre)) (PreH14 : (id_pre <= INT_MAX)) (PreH15 : (sem = (original.(semaphore_addr) ))) (PreH16 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH17 : (In original (st_lock.(os_semaphores) ) )) (PreH18 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH19 : (resched = 0)) (PreH20 : ((original.(semaphore_pending_addrs) ) = (@nil Z))) (PreH21 : (Crtos_RTrans before_outside_critical st_lock )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH23 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH24 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical drained )
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> (original.(semaphore_id) ))
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ ((original.(semaphore_id) ) < 65536) ” 
  &&  “ (0 <= (original.(semaphore_id) )) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ”
) \/
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (saved_lock: Z) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : (resched <= INT_MAX)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : (saved_lock <= INT_MAX)) (PreH4 : (resched >= INT_MIN)) (PreH5 : (id_pre >= INT_MIN)) (PreH6 : (saved_lock >= INT_MIN)) (PreH7 : (In original (st_lock.(os_semaphores) ) )) (PreH8 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH9 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH10 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH11 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH12 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH13 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH14 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH15 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH16 : (In original (st_lock.(os_semaphores) ) )) (PreH17 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH18 : (0 <= id_pre)) (PreH19 : (id_pre <= INT_MAX)) (PreH20 : (sem = (original.(semaphore_addr) ))) (PreH21 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH22 : (In original (st_lock.(os_semaphores) ) )) (PreH23 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH24 : (resched = 0)) (PreH25 : ((original.(semaphore_pending_addrs) ) = (@nil Z))) (PreH26 : (Crtos_RTrans before_outside_critical st_lock )) (PreH27 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH28 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH29 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical drained )
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> (original.(semaphore_id) ))
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (0 <= (original.(semaphore_id) )) ” 
  &&  “ ((original.(semaphore_id) ) < 65536) ”
).

Definition _SemaphoreDelete_partial_solve_wit_17_pure_split_goal_1 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (saved_lock: Z) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : (resched <= INT_MAX)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : (saved_lock <= INT_MAX)) (PreH4 : (resched >= INT_MIN)) (PreH5 : (id_pre >= INT_MIN)) (PreH6 : (saved_lock >= INT_MIN)) (PreH7 : (In original (st_lock.(os_semaphores) ) )) (PreH8 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH9 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH10 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH11 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH12 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH13 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH14 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH15 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH16 : (In original (st_lock.(os_semaphores) ) )) (PreH17 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH18 : (0 <= id_pre)) (PreH19 : (id_pre <= INT_MAX)) (PreH20 : (sem = (original.(semaphore_addr) ))) (PreH21 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH22 : (In original (st_lock.(os_semaphores) ) )) (PreH23 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH24 : (resched = 0)) (PreH25 : ((original.(semaphore_pending_addrs) ) = (@nil Z))) (PreH26 : (Crtos_RTrans before_outside_critical st_lock )) (PreH27 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH28 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH29 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical drained )
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> (original.(semaphore_id) ))
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (( &( "k_sem_id_manager" ) ) <> 0) ”
.

Definition _SemaphoreDelete_partial_solve_wit_17_pure_split_goal_2 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (saved_lock: Z) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : (resched <= INT_MAX)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : (saved_lock <= INT_MAX)) (PreH4 : (resched >= INT_MIN)) (PreH5 : (id_pre >= INT_MIN)) (PreH6 : (saved_lock >= INT_MIN)) (PreH7 : (In original (st_lock.(os_semaphores) ) )) (PreH8 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH9 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH10 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH11 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH12 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH13 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH14 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH15 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH16 : (In original (st_lock.(os_semaphores) ) )) (PreH17 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH18 : (0 <= id_pre)) (PreH19 : (id_pre <= INT_MAX)) (PreH20 : (sem = (original.(semaphore_addr) ))) (PreH21 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH22 : (In original (st_lock.(os_semaphores) ) )) (PreH23 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH24 : (resched = 0)) (PreH25 : ((original.(semaphore_pending_addrs) ) = (@nil Z))) (PreH26 : (Crtos_RTrans before_outside_critical st_lock )) (PreH27 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH28 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH29 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical drained )
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> (original.(semaphore_id) ))
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (0 <= (original.(semaphore_id) )) ”
.

Definition _SemaphoreDelete_partial_solve_wit_17_pure_split_goal_3 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (saved_lock: Z) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : (resched <= INT_MAX)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : (saved_lock <= INT_MAX)) (PreH4 : (resched >= INT_MIN)) (PreH5 : (id_pre >= INT_MIN)) (PreH6 : (saved_lock >= INT_MIN)) (PreH7 : (In original (st_lock.(os_semaphores) ) )) (PreH8 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH9 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH10 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH11 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH12 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH13 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH14 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH15 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH16 : (In original (st_lock.(os_semaphores) ) )) (PreH17 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH18 : (0 <= id_pre)) (PreH19 : (id_pre <= INT_MAX)) (PreH20 : (sem = (original.(semaphore_addr) ))) (PreH21 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH22 : (In original (st_lock.(os_semaphores) ) )) (PreH23 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH24 : (resched = 0)) (PreH25 : ((original.(semaphore_pending_addrs) ) = (@nil Z))) (PreH26 : (Crtos_RTrans before_outside_critical st_lock )) (PreH27 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH28 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH29 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical drained )
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> (original.(semaphore_id) ))
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ ((original.(semaphore_id) ) < 65536) ”
.

Definition _SemaphoreDelete_partial_solve_wit_17_aux := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : (In original (st_lock.(os_semaphores) ) )) (PreH2 : ((original.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH3 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH4 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH5 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH6 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH7 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH8 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH9 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH10 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH11 : (In original (st_lock.(os_semaphores) ) )) (PreH12 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH13 : (0 <= id_pre)) (PreH14 : (id_pre <= INT_MAX)) (PreH15 : (sem = (original.(semaphore_addr) ))) (PreH16 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH17 : (In original (st_lock.(os_semaphores) ) )) (PreH18 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH19 : (resched = 0)) (PreH20 : ((original.(semaphore_pending_addrs) ) = (@nil Z))) (PreH21 : (Crtos_RTrans before_outside_critical st_lock )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH23 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH24 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical drained )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ ((original.(semaphore_id) ) < 65536) ” 
  &&  “ (0 <= (original.(semaphore_id) )) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) ) ” 
  &&  “ ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ ((current.(semaphore_id) ) = (original.(semaphore_id) )) ” 
  &&  “ ((current.(semaphore_value) ) = (original.(semaphore_value) )) ” 
  &&  “ ((current.(semaphore_pending_addrs) ) = (@nil Z)) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (resched = 0) ” 
  &&  “ ((original.(semaphore_pending_addrs) ) = (@nil Z)) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ” 
  &&  “ (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) ) ”
  &&  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical drained )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_partial_solve_wit_17 := _SemaphoreDelete_partial_solve_wit_17_pure -> _SemaphoreDelete_partial_solve_wit_17_aux.

Definition _SemaphoreDelete_partial_solve_wit_18_pure := 
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (saved_lock: Z) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : (In original (st_lock.(os_semaphores) ) )) (PreH2 : ((original.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH3 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH4 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH5 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH6 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH7 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH8 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH9 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH10 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH11 : (In original (st_lock.(os_semaphores) ) )) (PreH12 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH13 : (0 <= id_pre)) (PreH14 : (id_pre <= INT_MAX)) (PreH15 : (sem = (original.(semaphore_addr) ))) (PreH16 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH17 : (In original (st_lock.(os_semaphores) ) )) (PreH18 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH19 : (resched = 1)) (PreH20 : ((original.(semaphore_pending_addrs) ) <> (@nil Z))) (PreH21 : (Crtos_RTrans before_outside_critical st_lock )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH23 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH24 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical drained )
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> (original.(semaphore_id) ))
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ ((original.(semaphore_id) ) < 65536) ” 
  &&  “ (0 <= (original.(semaphore_id) )) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ”
) \/
(
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (saved_lock: Z) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : (resched <= INT_MAX)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : (saved_lock <= INT_MAX)) (PreH4 : (resched >= INT_MIN)) (PreH5 : (id_pre >= INT_MIN)) (PreH6 : (saved_lock >= INT_MIN)) (PreH7 : (In original (st_lock.(os_semaphores) ) )) (PreH8 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH9 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH10 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH11 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH12 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH13 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH14 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH15 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH16 : (In original (st_lock.(os_semaphores) ) )) (PreH17 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH18 : (0 <= id_pre)) (PreH19 : (id_pre <= INT_MAX)) (PreH20 : (sem = (original.(semaphore_addr) ))) (PreH21 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH22 : (In original (st_lock.(os_semaphores) ) )) (PreH23 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH24 : (resched = 1)) (PreH25 : ((original.(semaphore_pending_addrs) ) <> (@nil Z))) (PreH26 : (Crtos_RTrans before_outside_critical st_lock )) (PreH27 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH28 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH29 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical drained )
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> (original.(semaphore_id) ))
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (0 <= (original.(semaphore_id) )) ” 
  &&  “ ((original.(semaphore_id) ) < 65536) ”
).

Definition _SemaphoreDelete_partial_solve_wit_18_pure_split_goal_1 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (saved_lock: Z) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : (resched <= INT_MAX)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : (saved_lock <= INT_MAX)) (PreH4 : (resched >= INT_MIN)) (PreH5 : (id_pre >= INT_MIN)) (PreH6 : (saved_lock >= INT_MIN)) (PreH7 : (In original (st_lock.(os_semaphores) ) )) (PreH8 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH9 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH10 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH11 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH12 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH13 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH14 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH15 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH16 : (In original (st_lock.(os_semaphores) ) )) (PreH17 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH18 : (0 <= id_pre)) (PreH19 : (id_pre <= INT_MAX)) (PreH20 : (sem = (original.(semaphore_addr) ))) (PreH21 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH22 : (In original (st_lock.(os_semaphores) ) )) (PreH23 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH24 : (resched = 1)) (PreH25 : ((original.(semaphore_pending_addrs) ) <> (@nil Z))) (PreH26 : (Crtos_RTrans before_outside_critical st_lock )) (PreH27 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH28 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH29 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical drained )
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> (original.(semaphore_id) ))
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (( &( "k_sem_id_manager" ) ) <> 0) ”
.

Definition _SemaphoreDelete_partial_solve_wit_18_pure_split_goal_2 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (saved_lock: Z) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : (resched <= INT_MAX)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : (saved_lock <= INT_MAX)) (PreH4 : (resched >= INT_MIN)) (PreH5 : (id_pre >= INT_MIN)) (PreH6 : (saved_lock >= INT_MIN)) (PreH7 : (In original (st_lock.(os_semaphores) ) )) (PreH8 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH9 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH10 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH11 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH12 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH13 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH14 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH15 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH16 : (In original (st_lock.(os_semaphores) ) )) (PreH17 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH18 : (0 <= id_pre)) (PreH19 : (id_pre <= INT_MAX)) (PreH20 : (sem = (original.(semaphore_addr) ))) (PreH21 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH22 : (In original (st_lock.(os_semaphores) ) )) (PreH23 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH24 : (resched = 1)) (PreH25 : ((original.(semaphore_pending_addrs) ) <> (@nil Z))) (PreH26 : (Crtos_RTrans before_outside_critical st_lock )) (PreH27 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH28 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH29 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical drained )
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> (original.(semaphore_id) ))
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ (0 <= (original.(semaphore_id) )) ”
.

Definition _SemaphoreDelete_partial_solve_wit_18_pure_split_goal_3 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (saved_lock: Z) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : (resched <= INT_MAX)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : (saved_lock <= INT_MAX)) (PreH4 : (resched >= INT_MIN)) (PreH5 : (id_pre >= INT_MIN)) (PreH6 : (saved_lock >= INT_MIN)) (PreH7 : (In original (st_lock.(os_semaphores) ) )) (PreH8 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH9 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH10 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH11 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH12 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH13 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH14 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH15 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH16 : (In original (st_lock.(os_semaphores) ) )) (PreH17 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH18 : (0 <= id_pre)) (PreH19 : (id_pre <= INT_MAX)) (PreH20 : (sem = (original.(semaphore_addr) ))) (PreH21 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH22 : (In original (st_lock.(os_semaphores) ) )) (PreH23 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH24 : (resched = 1)) (PreH25 : ((original.(semaphore_pending_addrs) ) <> (@nil Z))) (PreH26 : (Crtos_RTrans before_outside_critical st_lock )) (PreH27 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH28 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH29 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical drained )
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> (original.(semaphore_id) ))
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ ((original.(semaphore_id) ) < 65536) ”
.

Definition _SemaphoreDelete_partial_solve_wit_18_aux := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : (In original (st_lock.(os_semaphores) ) )) (PreH2 : ((original.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH3 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH4 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH5 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH6 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH7 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH8 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH9 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH10 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH11 : (In original (st_lock.(os_semaphores) ) )) (PreH12 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH13 : (0 <= id_pre)) (PreH14 : (id_pre <= INT_MAX)) (PreH15 : (sem = (original.(semaphore_addr) ))) (PreH16 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH17 : (In original (st_lock.(os_semaphores) ) )) (PreH18 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH19 : (resched = 1)) (PreH20 : ((original.(semaphore_pending_addrs) ) <> (@nil Z))) (PreH21 : (Crtos_RTrans before_outside_critical st_lock )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH23 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH24 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical drained )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ ((original.(semaphore_id) ) < 65536) ” 
  &&  “ (0 <= (original.(semaphore_id) )) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) ) ” 
  &&  “ ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ ((current.(semaphore_id) ) = (original.(semaphore_id) )) ” 
  &&  “ ((current.(semaphore_value) ) = (original.(semaphore_value) )) ” 
  &&  “ ((current.(semaphore_pending_addrs) ) = (@nil Z)) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (resched = 1) ” 
  &&  “ ((original.(semaphore_pending_addrs) ) <> (@nil Z)) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ” 
  &&  “ (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) ) ”
  &&  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical drained )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_partial_solve_wit_18 := _SemaphoreDelete_partial_solve_wit_18_pure -> _SemaphoreDelete_partial_solve_wit_18_aux.

Definition _SemaphoreDelete_partial_solve_wit_19_pure := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (saved_lock: Z) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (idnode_2: Z) (PreH1 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH2 : (idmanager_contains (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) (original.(semaphore_id) ) idnode_2 )) (PreH3 : (idnode_2 <> 0)) (PreH4 : (&((idnode_2)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : (In original (st_lock.(os_semaphores) ) )) (PreH6 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH7 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH8 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH9 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH10 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH11 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH12 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH13 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH14 : (In original (st_lock.(os_semaphores) ) )) (PreH15 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH16 : (0 <= id_pre)) (PreH17 : (id_pre <= INT_MAX)) (PreH18 : (sem = (original.(semaphore_addr) ))) (PreH19 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH20 : (In original (st_lock.(os_semaphores) ) )) (PreH21 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH22 : (resched = 1)) (PreH23 : ((original.(semaphore_pending_addrs) ) <> (@nil Z))) (PreH24 : (Crtos_RTrans before_outside_critical st_lock )) (PreH25 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH26 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH27 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (idmanager_remove ((semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical))))) ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) ( &( "k_sem_id_manager" ) ) )
  **  ((&((idnode_2)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (delete_manager_frame sg_outside_critical drained )
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> (original.(semaphore_id) ))
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(semaphore_addr) ) = (original.(semaphore_addr) )) ”
.

Definition _SemaphoreDelete_partial_solve_wit_19_aux := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (idnode_2: Z) (PreH1 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH2 : (idmanager_contains (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) (original.(semaphore_id) ) idnode_2 )) (PreH3 : (idnode_2 <> 0)) (PreH4 : (&((idnode_2)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : (In original (st_lock.(os_semaphores) ) )) (PreH6 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH7 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH8 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH9 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH10 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH11 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH12 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH13 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH14 : (In original (st_lock.(os_semaphores) ) )) (PreH15 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH16 : (0 <= id_pre)) (PreH17 : (id_pre <= INT_MAX)) (PreH18 : (sem = (original.(semaphore_addr) ))) (PreH19 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH20 : (In original (st_lock.(os_semaphores) ) )) (PreH21 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH22 : (resched = 1)) (PreH23 : ((original.(semaphore_pending_addrs) ) <> (@nil Z))) (PreH24 : (Crtos_RTrans before_outside_critical st_lock )) (PreH25 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH26 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH27 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (idmanager_remove ((semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical))))) ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) ( &( "k_sem_id_manager" ) ) )
  **  ((&((idnode_2)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  (delete_manager_frame sg_outside_critical drained )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true) ” 
  &&  “ (idmanager_contains (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) (original.(semaphore_id) ) idnode_2 ) ” 
  &&  “ (idnode_2 <> 0) ” 
  &&  “ (&((idnode_2)  # "IdNode" ->ₛ "link") <> 0) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) ) ” 
  &&  “ ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ ((current.(semaphore_id) ) = (original.(semaphore_id) )) ” 
  &&  “ ((current.(semaphore_value) ) = (original.(semaphore_value) )) ” 
  &&  “ ((current.(semaphore_pending_addrs) ) = (@nil Z)) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (resched = 1) ” 
  &&  “ ((original.(semaphore_pending_addrs) ) <> (@nil Z)) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ” 
  &&  “ (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) ) ”
  &&  (delete_manager_frame sg_outside_critical drained )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (idmanager_remove ((semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical))))) ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) ( &( "k_sem_id_manager" ) ) )
  **  ((&((idnode_2)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_partial_solve_wit_19 := _SemaphoreDelete_partial_solve_wit_19_pure -> _SemaphoreDelete_partial_solve_wit_19_aux.

Definition _SemaphoreDelete_partial_solve_wit_20_pure := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (saved_lock: Z) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = false)) (PreH2 : (In original (st_lock.(os_semaphores) ) )) (PreH3 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH4 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH5 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH6 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH7 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH8 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH9 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH10 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH11 : (In original (st_lock.(os_semaphores) ) )) (PreH12 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH13 : (0 <= id_pre)) (PreH14 : (id_pre <= INT_MAX)) (PreH15 : (sem = (original.(semaphore_addr) ))) (PreH16 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH17 : (In original (st_lock.(os_semaphores) ) )) (PreH18 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH19 : (resched = 1)) (PreH20 : ((original.(semaphore_pending_addrs) ) <> (@nil Z))) (PreH21 : (Crtos_RTrans before_outside_critical st_lock )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH23 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH24 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (delete_manager_frame sg_outside_critical drained )
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> (original.(semaphore_id) ))
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(semaphore_addr) ) = (original.(semaphore_addr) )) ”
.

Definition _SemaphoreDelete_partial_solve_wit_20_aux := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = false)) (PreH2 : (In original (st_lock.(os_semaphores) ) )) (PreH3 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH4 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH5 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH6 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH7 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH8 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH9 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH10 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH11 : (In original (st_lock.(os_semaphores) ) )) (PreH12 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH13 : (0 <= id_pre)) (PreH14 : (id_pre <= INT_MAX)) (PreH15 : (sem = (original.(semaphore_addr) ))) (PreH16 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH17 : (In original (st_lock.(os_semaphores) ) )) (PreH18 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH19 : (resched = 1)) (PreH20 : ((original.(semaphore_pending_addrs) ) <> (@nil Z))) (PreH21 : (Crtos_RTrans before_outside_critical st_lock )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH23 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH24 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical drained )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = false) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) ) ” 
  &&  “ ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ ((current.(semaphore_id) ) = (original.(semaphore_id) )) ” 
  &&  “ ((current.(semaphore_value) ) = (original.(semaphore_value) )) ” 
  &&  “ ((current.(semaphore_pending_addrs) ) = (@nil Z)) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (resched = 1) ” 
  &&  “ ((original.(semaphore_pending_addrs) ) <> (@nil Z)) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ” 
  &&  “ (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) ) ”
  &&  (delete_manager_frame sg_outside_critical drained )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_partial_solve_wit_20 := _SemaphoreDelete_partial_solve_wit_20_pure -> _SemaphoreDelete_partial_solve_wit_20_aux.

Definition _SemaphoreDelete_partial_solve_wit_21_pure := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (saved_lock: Z) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (idnode_2: Z) (PreH1 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH2 : (idmanager_contains (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) (original.(semaphore_id) ) idnode_2 )) (PreH3 : (idnode_2 <> 0)) (PreH4 : (&((idnode_2)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : (In original (st_lock.(os_semaphores) ) )) (PreH6 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH7 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH8 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH9 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH10 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH11 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH12 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH13 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH14 : (In original (st_lock.(os_semaphores) ) )) (PreH15 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH16 : (0 <= id_pre)) (PreH17 : (id_pre <= INT_MAX)) (PreH18 : (sem = (original.(semaphore_addr) ))) (PreH19 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH20 : (In original (st_lock.(os_semaphores) ) )) (PreH21 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH22 : (resched = 0)) (PreH23 : ((original.(semaphore_pending_addrs) ) = (@nil Z))) (PreH24 : (Crtos_RTrans before_outside_critical st_lock )) (PreH25 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH26 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH27 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (idmanager_remove ((semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical))))) ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) ( &( "k_sem_id_manager" ) ) )
  **  ((&((idnode_2)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (delete_manager_frame sg_outside_critical drained )
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> (original.(semaphore_id) ))
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(semaphore_addr) ) = (original.(semaphore_addr) )) ”
.

Definition _SemaphoreDelete_partial_solve_wit_21_aux := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (idnode_2: Z) (PreH1 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH2 : (idmanager_contains (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) (original.(semaphore_id) ) idnode_2 )) (PreH3 : (idnode_2 <> 0)) (PreH4 : (&((idnode_2)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : (In original (st_lock.(os_semaphores) ) )) (PreH6 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH7 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH8 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH9 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH10 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH11 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH12 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH13 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH14 : (In original (st_lock.(os_semaphores) ) )) (PreH15 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH16 : (0 <= id_pre)) (PreH17 : (id_pre <= INT_MAX)) (PreH18 : (sem = (original.(semaphore_addr) ))) (PreH19 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH20 : (In original (st_lock.(os_semaphores) ) )) (PreH21 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH22 : (resched = 0)) (PreH23 : ((original.(semaphore_pending_addrs) ) = (@nil Z))) (PreH24 : (Crtos_RTrans before_outside_critical st_lock )) (PreH25 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH26 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH27 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (idmanager_remove ((semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical))))) ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) ( &( "k_sem_id_manager" ) ) )
  **  ((&((idnode_2)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  (delete_manager_frame sg_outside_critical drained )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true) ” 
  &&  “ (idmanager_contains (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) (original.(semaphore_id) ) idnode_2 ) ” 
  &&  “ (idnode_2 <> 0) ” 
  &&  “ (&((idnode_2)  # "IdNode" ->ₛ "link") <> 0) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) ) ” 
  &&  “ ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ ((current.(semaphore_id) ) = (original.(semaphore_id) )) ” 
  &&  “ ((current.(semaphore_value) ) = (original.(semaphore_value) )) ” 
  &&  “ ((current.(semaphore_pending_addrs) ) = (@nil Z)) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (resched = 0) ” 
  &&  “ ((original.(semaphore_pending_addrs) ) = (@nil Z)) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ” 
  &&  “ (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) ) ”
  &&  (delete_manager_frame sg_outside_critical drained )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (idmanager_remove ((semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical))))) ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) ( &( "k_sem_id_manager" ) ) )
  **  ((&((idnode_2)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_partial_solve_wit_21 := _SemaphoreDelete_partial_solve_wit_21_pure -> _SemaphoreDelete_partial_solve_wit_21_aux.

Definition _SemaphoreDelete_partial_solve_wit_22_pure := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (saved_lock: Z) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = false)) (PreH2 : (In original (st_lock.(os_semaphores) ) )) (PreH3 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH4 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH5 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH6 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH7 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH8 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH9 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH10 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH11 : (In original (st_lock.(os_semaphores) ) )) (PreH12 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH13 : (0 <= id_pre)) (PreH14 : (id_pre <= INT_MAX)) (PreH15 : (sem = (original.(semaphore_addr) ))) (PreH16 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH17 : (In original (st_lock.(os_semaphores) ) )) (PreH18 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH19 : (resched = 0)) (PreH20 : ((original.(semaphore_pending_addrs) ) = (@nil Z))) (PreH21 : (Crtos_RTrans before_outside_critical st_lock )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH23 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH24 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  ((( &( "sem" ) )) # Ptr  |-> (original.(semaphore_addr) ))
  **  (delete_manager_frame sg_outside_critical drained )
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> (original.(semaphore_id) ))
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(semaphore_addr) ) = (original.(semaphore_addr) )) ”
.

Definition _SemaphoreDelete_partial_solve_wit_22_aux := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = false)) (PreH2 : (In original (st_lock.(os_semaphores) ) )) (PreH3 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH4 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH5 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH6 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH7 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH8 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH9 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH10 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH11 : (In original (st_lock.(os_semaphores) ) )) (PreH12 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH13 : (0 <= id_pre)) (PreH14 : (id_pre <= INT_MAX)) (PreH15 : (sem = (original.(semaphore_addr) ))) (PreH16 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH17 : (In original (st_lock.(os_semaphores) ) )) (PreH18 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH19 : (resched = 0)) (PreH20 : ((original.(semaphore_pending_addrs) ) = (@nil Z))) (PreH21 : (Crtos_RTrans before_outside_critical st_lock )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH23 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH24 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical drained )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = false) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) ) ” 
  &&  “ ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ ((current.(semaphore_id) ) = (original.(semaphore_id) )) ” 
  &&  “ ((current.(semaphore_value) ) = (original.(semaphore_value) )) ” 
  &&  “ ((current.(semaphore_pending_addrs) ) = (@nil Z)) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (resched = 0) ” 
  &&  “ ((original.(semaphore_pending_addrs) ) = (@nil Z)) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ” 
  &&  “ (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) ) ”
  &&  (delete_manager_frame sg_outside_critical drained )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_partial_solve_wit_22 := _SemaphoreDelete_partial_solve_wit_22_pure -> _SemaphoreDelete_partial_solve_wit_22_aux.

Definition _SemaphoreDelete_partial_solve_wit_23 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH3 : (semaphore_context (os_semaphore_stable (sg_outside_critical)) )) (PreH4 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = false)) (PreH5 : (In original (st_lock.(os_semaphores) ) )) (PreH6 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH7 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH8 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH9 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH10 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH11 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH12 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH13 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH14 : (In original (st_lock.(os_semaphores) ) )) (PreH15 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH16 : (0 <= id_pre)) (PreH17 : (id_pre <= INT_MAX)) (PreH18 : (sem = (original.(semaphore_addr) ))) (PreH19 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH20 : (In original (st_lock.(os_semaphores) ) )) (PreH21 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH22 : (resched = 0)) (PreH23 : ((original.(semaphore_pending_addrs) ) = (@nil Z))) (PreH24 : (Crtos_RTrans before_outside_critical st_lock )) (PreH25 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH26 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH27 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (delete_global_frame sg_outside_critical drained )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((cons ((Build_DL_Node (current) (&(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "link")))) ((map (semaphore_link_node) (suffix)))))) )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ (semaphore_context (os_semaphore_stable (sg_outside_critical)) ) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = false) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) ) ” 
  &&  “ ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ ((current.(semaphore_id) ) = (original.(semaphore_id) )) ” 
  &&  “ ((current.(semaphore_value) ) = (original.(semaphore_value) )) ” 
  &&  “ ((current.(semaphore_pending_addrs) ) = (@nil Z)) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (resched = 0) ” 
  &&  “ ((original.(semaphore_pending_addrs) ) = (@nil Z)) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ” 
  &&  “ (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) ) ”
  &&  (store_dll (store_semaphore ((pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((cons ((Build_DL_Node (current) (&(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "link")))) ((map (semaphore_link_node) (suffix)))))) )
  **  (delete_global_frame sg_outside_critical drained )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_partial_solve_wit_24 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (idnode_2: Z) (PreH1 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH3 : (semaphore_context (os_semaphore_stable (sg_outside_critical)) )) (PreH4 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH5 : (idmanager_contains (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) (original.(semaphore_id) ) idnode_2 )) (PreH6 : (idnode_2 <> 0)) (PreH7 : (&((idnode_2)  # "IdNode" ->ₛ "link") <> 0)) (PreH8 : (In original (st_lock.(os_semaphores) ) )) (PreH9 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH10 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH11 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH12 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH13 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH14 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH15 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH16 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH17 : (In original (st_lock.(os_semaphores) ) )) (PreH18 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH19 : (0 <= id_pre)) (PreH20 : (id_pre <= INT_MAX)) (PreH21 : (sem = (original.(semaphore_addr) ))) (PreH22 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH23 : (In original (st_lock.(os_semaphores) ) )) (PreH24 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH25 : (resched = 0)) (PreH26 : ((original.(semaphore_pending_addrs) ) = (@nil Z))) (PreH27 : (Crtos_RTrans before_outside_critical st_lock )) (PreH28 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH29 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH30 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (delete_global_frame sg_outside_critical drained )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((cons ((Build_DL_Node (current) (&(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "link")))) ((map (semaphore_link_node) (suffix)))))) )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (idmanager_remove ((semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical))))) ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) ( &( "k_sem_id_manager" ) ) )
  **  ((&((idnode_2)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ (semaphore_context (os_semaphore_stable (sg_outside_critical)) ) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true) ” 
  &&  “ (idmanager_contains (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) (original.(semaphore_id) ) idnode_2 ) ” 
  &&  “ (idnode_2 <> 0) ” 
  &&  “ (&((idnode_2)  # "IdNode" ->ₛ "link") <> 0) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) ) ” 
  &&  “ ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ ((current.(semaphore_id) ) = (original.(semaphore_id) )) ” 
  &&  “ ((current.(semaphore_value) ) = (original.(semaphore_value) )) ” 
  &&  “ ((current.(semaphore_pending_addrs) ) = (@nil Z)) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (resched = 0) ” 
  &&  “ ((original.(semaphore_pending_addrs) ) = (@nil Z)) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ” 
  &&  “ (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) ) ”
  &&  (store_dll (store_semaphore ((pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((cons ((Build_DL_Node (current) (&(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "link")))) ((map (semaphore_link_node) (suffix)))))) )
  **  (delete_global_frame sg_outside_critical drained )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (idmanager_remove ((semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical))))) ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) ( &( "k_sem_id_manager" ) ) )
  **  ((&((idnode_2)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_partial_solve_wit_25 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (PreH1 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH3 : (semaphore_context (os_semaphore_stable (sg_outside_critical)) )) (PreH4 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = false)) (PreH5 : (In original (st_lock.(os_semaphores) ) )) (PreH6 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH7 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH8 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH9 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH10 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH11 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH12 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH13 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH14 : (In original (st_lock.(os_semaphores) ) )) (PreH15 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH16 : (0 <= id_pre)) (PreH17 : (id_pre <= INT_MAX)) (PreH18 : (sem = (original.(semaphore_addr) ))) (PreH19 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH20 : (In original (st_lock.(os_semaphores) ) )) (PreH21 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH22 : (resched = 1)) (PreH23 : ((original.(semaphore_pending_addrs) ) <> (@nil Z))) (PreH24 : (Crtos_RTrans before_outside_critical st_lock )) (PreH25 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH26 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH27 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (delete_global_frame sg_outside_critical drained )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((cons ((Build_DL_Node (current) (&(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "link")))) ((map (semaphore_link_node) (suffix)))))) )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ (semaphore_context (os_semaphore_stable (sg_outside_critical)) ) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = false) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) ) ” 
  &&  “ ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ ((current.(semaphore_id) ) = (original.(semaphore_id) )) ” 
  &&  “ ((current.(semaphore_value) ) = (original.(semaphore_value) )) ” 
  &&  “ ((current.(semaphore_pending_addrs) ) = (@nil Z)) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (resched = 1) ” 
  &&  “ ((original.(semaphore_pending_addrs) ) <> (@nil Z)) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ” 
  &&  “ (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) ) ”
  &&  (store_dll (store_semaphore ((pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((cons ((Build_DL_Node (current) (&(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "link")))) ((map (semaphore_link_node) (suffix)))))) )
  **  (delete_global_frame sg_outside_critical drained )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_partial_solve_wit_26 := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_outside_critical: VarGlobalState) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (drained: VarGlobalState) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (idnode_2: Z) (PreH1 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH3 : (semaphore_context (os_semaphore_stable (sg_outside_critical)) )) (PreH4 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH5 : (idmanager_contains (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) (original.(semaphore_id) ) idnode_2 )) (PreH6 : (idnode_2 <> 0)) (PreH7 : (&((idnode_2)  # "IdNode" ->ₛ "link") <> 0)) (PreH8 : (In original (st_lock.(os_semaphores) ) )) (PreH9 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH10 : (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) )) (PreH11 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH12 : ((current.(semaphore_addr) ) = (original.(semaphore_addr) ))) (PreH13 : ((current.(semaphore_id) ) = (original.(semaphore_id) ))) (PreH14 : ((current.(semaphore_value) ) = (original.(semaphore_value) ))) (PreH15 : ((current.(semaphore_pending_addrs) ) = (@nil Z))) (PreH16 : ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true)) (PreH17 : (In original (st_lock.(os_semaphores) ) )) (PreH18 : (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH19 : (0 <= id_pre)) (PreH20 : (id_pre <= INT_MAX)) (PreH21 : (sem = (original.(semaphore_addr) ))) (PreH22 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH23 : (In original (st_lock.(os_semaphores) ) )) (PreH24 : ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH25 : (resched = 1)) (PreH26 : ((original.(semaphore_pending_addrs) ) <> (@nil Z))) (PreH27 : (Crtos_RTrans before_outside_critical st_lock )) (PreH28 : ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical )) (PreH29 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH30 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (delete_global_frame sg_outside_critical drained )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((cons ((Build_DL_Node (current) (&(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "link")))) ((map (semaphore_link_node) (suffix)))))) )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (idmanager_remove ((semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical))))) ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) ( &( "k_sem_id_manager" ) ) )
  **  ((&((idnode_2)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  (InsideCritical sg_outside_critical st_lock )
|--
  “ ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ (semaphore_context (os_semaphore_stable (sg_outside_critical)) ) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true) ” 
  &&  “ (idmanager_contains (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) (original.(semaphore_id) ) idnode_2 ) ” 
  &&  “ (idnode_2 <> 0) ” 
  &&  “ (&((idnode_2)  # "IdNode" ->ₛ "link") <> 0) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes (original.(semaphore_addr) ) drained (@nil (@DL_Node Z)) ) ” 
  &&  “ ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(semaphore_addr) ) = (original.(semaphore_addr) )) ” 
  &&  “ ((current.(semaphore_id) ) = (original.(semaphore_id) )) ” 
  &&  “ ((current.(semaphore_value) ) = (original.(semaphore_value) )) ” 
  &&  “ ((current.(semaphore_pending_addrs) ) = (@nil Z)) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (semaphore_resume_all_effect (original.(semaphore_addr) ) (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (0 <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (resched = 1) ” 
  &&  “ ((original.(semaphore_pending_addrs) ) <> (@nil Z)) ” 
  &&  “ (Crtos_RTrans before_outside_critical st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_outside_critical)) (abs_semaphore_delete (sg_outside_critical) (id_pre)) X_outside_critical ) ” 
  &&  “ (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) ) ”
  &&  (store_dll (store_semaphore ((pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((cons ((Build_DL_Node (current) (&(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "link")))) ((map (semaphore_link_node) (suffix)))))) )
  **  (delete_global_frame sg_outside_critical drained )
  **  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (idmanager_remove ((semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical))))) ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) ( &( "k_sem_id_manager" ) ) )
  **  ((&((idnode_2)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode_2)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode_2)  # "IdNode" ->ₛ "link"))
  **  (InsideCritical sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_partial_solve_wit_27_pure := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (saved_lock: Z) (sem: Z) (idnode: Z) (delete_sem_id: Z) (resched: Z) (after: VarGlobalState) (PreH1 : (sem = (original.(semaphore_addr) ))) (PreH2 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH3 : (delete_sem_id = (original.(semaphore_id) ))) (PreH4 : (resched = 1)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_outside_critical )) (PreH6 : (Crtos_GTrans st_lock after )) ,
  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> delete_sem_id)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical after )
  **  (SemaphoreRetired sem (original.(semaphore_value) ) )
|--
  “ (Crtos_GTrans st_lock after ) ”
.

Definition _SemaphoreDelete_partial_solve_wit_27_aux := 
forall (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (delete_sem_id: Z) (resched: Z) (after: VarGlobalState) (PreH1 : (sem = (original.(semaphore_addr) ))) (PreH2 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH3 : (delete_sem_id = (original.(semaphore_id) ))) (PreH4 : (resched = 1)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_outside_critical )) (PreH6 : (Crtos_GTrans st_lock after )) ,
  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical after )
  **  (SemaphoreRetired sem (original.(semaphore_value) ) )
|--
  “ (Crtos_GTrans st_lock after ) ” 
  &&  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (delete_sem_id = (original.(semaphore_id) )) ” 
  &&  “ (resched = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock after ) ”
  &&  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical after )
  **  (SemaphoreRetired sem (original.(semaphore_value) ) )
.

Definition _SemaphoreDelete_partial_solve_wit_27 := _SemaphoreDelete_partial_solve_wit_27_pure -> _SemaphoreDelete_partial_solve_wit_27_aux.

Definition _SemaphoreDelete_partial_solve_wit_28_pure := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (saved_lock: Z) (sem: Z) (idnode: Z) (delete_sem_id: Z) (resched: Z) (after: VarGlobalState) (PreH1 : (sem = (original.(semaphore_addr) ))) (PreH2 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH3 : (delete_sem_id = (original.(semaphore_id) ))) (PreH4 : (resched = 0)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_outside_critical )) (PreH6 : (Crtos_GTrans st_lock after )) ,
  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> delete_sem_id)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical after )
  **  (SemaphoreRetired sem (original.(semaphore_value) ) )
|--
  “ (Crtos_GTrans st_lock after ) ”
.

Definition _SemaphoreDelete_partial_solve_wit_28_aux := 
forall (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (delete_sem_id: Z) (resched: Z) (after: VarGlobalState) (PreH1 : (sem = (original.(semaphore_addr) ))) (PreH2 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH3 : (delete_sem_id = (original.(semaphore_id) ))) (PreH4 : (resched = 0)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_outside_critical )) (PreH6 : (Crtos_GTrans st_lock after )) ,
  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical after )
  **  (SemaphoreRetired sem (original.(semaphore_value) ) )
|--
  “ (Crtos_GTrans st_lock after ) ” 
  &&  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (delete_sem_id = (original.(semaphore_id) )) ” 
  &&  “ (resched = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock after ) ”
  &&  (InsideCritical sg_outside_critical st_lock )
  **  (os_inv sg_outside_critical after )
  **  (SemaphoreRetired sem (original.(semaphore_value) ) )
.

Definition _SemaphoreDelete_partial_solve_wit_28 := _SemaphoreDelete_partial_solve_wit_28_pure -> _SemaphoreDelete_partial_solve_wit_28_aux.

Definition _SemaphoreDelete_partial_solve_wit_29 := 
forall (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (delete_sem_id: Z) (resched: Z) (after: VarGlobalState) (PreH1 : (sem = (original.(semaphore_addr) ))) (PreH2 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH3 : (delete_sem_id = (original.(semaphore_id) ))) (PreH4 : (resched = 0)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_outside_critical )) (PreH6 : (Crtos_GTrans st_lock after )) ,
  (OutsideCritical sg_outside_critical after )
  **  (SemaphoreRetired sem (original.(semaphore_value) ) )
|--
  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (delete_sem_id = (original.(semaphore_id) )) ” 
  &&  “ (resched = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock after ) ”
  &&  (SemaphoreRetired sem (original.(semaphore_value) ) )
  **  (OutsideCritical sg_outside_critical after )
.

Definition _SemaphoreDelete_partial_solve_wit_30 := 
forall (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (delete_sem_id: Z) (resched: Z) (after: VarGlobalState) (PreH1 : (sem = (original.(semaphore_addr) ))) (PreH2 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH3 : (delete_sem_id = (original.(semaphore_id) ))) (PreH4 : (resched = 1)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_outside_critical )) (PreH6 : (Crtos_GTrans st_lock after )) ,
  (OutsideCritical sg_outside_critical after )
  **  (SemaphoreRetired sem (original.(semaphore_value) ) )
|--
  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (delete_sem_id = (original.(semaphore_id) )) ” 
  &&  “ (resched = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock after ) ”
  &&  (SemaphoreRetired sem (original.(semaphore_value) ) )
  **  (OutsideCritical sg_outside_critical after )
.

Definition _SemaphoreDelete_partial_solve_wit_31 := 
forall (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (delete_sem_id: Z) (resched: Z) (after: VarGlobalState) (PreH1 : (sem = (original.(semaphore_addr) ))) (PreH2 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH3 : (delete_sem_id = (original.(semaphore_id) ))) (PreH4 : (resched = 1)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_outside_critical )) (PreH6 : (Crtos_GTrans st_lock after )) ,
  (SemaphoreRaw sem )
  **  (OutsideCritical sg_outside_critical after )
|--
  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (delete_sem_id = (original.(semaphore_id) )) ” 
  &&  “ (resched = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock after ) ”
  &&  (SemaphoreRaw sem )
  **  (OutsideCritical sg_outside_critical after )
.

Definition _SemaphoreDelete_partial_solve_wit_32 := 
forall (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (delete_sem_id: Z) (resched: Z) (after: VarGlobalState) (PreH1 : (sem = (original.(semaphore_addr) ))) (PreH2 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH3 : (delete_sem_id = (original.(semaphore_id) ))) (PreH4 : (resched = 0)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_outside_critical )) (PreH6 : (Crtos_GTrans st_lock after )) ,
  (SemaphoreRaw sem )
  **  (OutsideCritical sg_outside_critical after )
|--
  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (delete_sem_id = (original.(semaphore_id) )) ” 
  &&  “ (resched = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock after ) ”
  &&  (SemaphoreRaw sem )
  **  (OutsideCritical sg_outside_critical after )
.

Definition _SemaphoreDelete_partial_solve_wit_33_pure := 
forall (id_pre: Z) (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (saved_lock: Z) (sem: Z) (idnode: Z) (delete_sem_id: Z) (resched: Z) (after: VarGlobalState) (PreH1 : (sem = (original.(semaphore_addr) ))) (PreH2 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH3 : (delete_sem_id = (original.(semaphore_id) ))) (PreH4 : (resched = 1)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_outside_critical )) (PreH6 : (Crtos_GTrans st_lock after )) (PreH7 : (resched <> 0)) ,
  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  (OutsideCritical sg_outside_critical after )
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "delete_sem_id" ) )) # UShort  |-> delete_sem_id)
  **  ((( &( "resched" ) )) # Int  |-> resched)
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_outside_critical ) ”
.

Definition _SemaphoreDelete_partial_solve_wit_33_aux := 
forall (X_outside_critical: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (delete_sem_id: Z) (resched: Z) (after: VarGlobalState) (PreH1 : (sem = (original.(semaphore_addr) ))) (PreH2 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH3 : (delete_sem_id = (original.(semaphore_id) ))) (PreH4 : (resched = 1)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_outside_critical )) (PreH6 : (Crtos_GTrans st_lock after )) (PreH7 : (resched <> 0)) ,
  (OutsideCritical sg_outside_critical after )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_outside_critical ) ” 
  &&  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (delete_sem_id = (original.(semaphore_id) )) ” 
  &&  “ (resched = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_outside_critical ) ” 
  &&  “ (Crtos_GTrans st_lock after ) ” 
  &&  “ (resched <> 0) ”
  &&  (OutsideCritical sg_outside_critical after )
.

Definition _SemaphoreDelete_partial_solve_wit_33 := _SemaphoreDelete_partial_solve_wit_33_pure -> _SemaphoreDelete_partial_solve_wit_33_aux.

Definition _SemaphoreDelete_which_implies_wit_1 := 
(
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) ,
  (os_inv sg_outside_critical st_lock )
|--
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical st_lock )
) \/
(
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) ,
  (os_inv sg_outside_critical st_lock )
|--
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical st_lock )
).

Definition _SemaphoreDelete_which_implies_wit_1_split_goal_spatial := 
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) ,
  (os_inv sg_outside_critical st_lock )
|--
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_which_implies_wit_2 := 
(
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (id: Z) (idnode: Z) ,
  (store_idmanager_found (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) idnode (unsigned_last_nbits (id) (16)) )
  **  (delete_manager_frame sg_outside_critical st_lock )
|--
  EX (original: SemaphoreAbs) ,
  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id) (16))) ” 
  &&  “ (idnode = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id")) ” 
  &&  “ ((original.(semaphore_addr) ) <> 0) ”
  &&  (os_inv sg_outside_critical st_lock )
) \/
(
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (id: Z) (idnode: Z) ,
  (store_idmanager_found (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((st_lock.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) idnode (unsigned_last_nbits (id) (16)) )
  **  (delete_manager_frame sg_outside_critical st_lock )
|--
  EX (original: SemaphoreAbs) ,
  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ ((original.(semaphore_id) ) = (unsigned_last_nbits (id) (16))) ” 
  &&  “ (idnode = &(((original.(semaphore_addr) ))  # "Semaphore" ->ₛ "id")) ” 
  &&  “ ((original.(semaphore_addr) ) <> 0) ”
  &&  (os_inv sg_outside_critical st_lock )
).

Definition _SemaphoreDelete_which_implies_wit_3 := 
(
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (PreH1 : (In original (st_lock.(os_semaphores) ) )) (PreH2 : (sem = (original.(semaphore_addr) ))) ,
  (os_inv sg_outside_critical st_lock )
|--
  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (sem = (original.(semaphore_addr) )) ”
  &&  (store_dll (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &((sem)  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) )
  **  (delete_pending_restore sg_outside_critical st_lock sem (original.(semaphore_pending_addrs) ) )
) \/
(
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (PreH1 : (In original (st_lock.(os_semaphores) ) )) (PreH2 : (sem = (original.(semaphore_addr) ))) ,
  (os_inv sg_outside_critical st_lock )
|--
  (store_dll (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &((sem)  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) )
  **  (delete_pending_restore sg_outside_critical st_lock sem (original.(semaphore_pending_addrs) ) )
).

Definition _SemaphoreDelete_which_implies_wit_3_split_goal_spatial := 
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (PreH1 : (In original (st_lock.(os_semaphores) ) )) (PreH2 : (sem = (original.(semaphore_addr) ))) ,
  (os_inv sg_outside_critical st_lock )
|--
  (store_dll (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &((sem)  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) )
  **  (delete_pending_restore sg_outside_critical st_lock sem (original.(semaphore_pending_addrs) ) )
.

Definition _SemaphoreDelete_which_implies_wit_4 := 
(
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (PreH1 : (In original (st_lock.(os_semaphores) ) )) (PreH2 : (sem = (original.(semaphore_addr) ))) ,
  (store_dll (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &((sem)  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) )
  **  (delete_pending_restore sg_outside_critical st_lock sem (original.(semaphore_pending_addrs) ) )
|--
  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (semaphore_pending_nodes sem st_lock (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) ) ”
  &&  (os_inv sg_outside_critical st_lock )
) \/
(
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (PreH1 : (In original (st_lock.(os_semaphores) ) )) (PreH2 : (sem = (original.(semaphore_addr) ))) ,
  (store_dll (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &((sem)  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) )
  **  (delete_pending_restore sg_outside_critical st_lock sem (original.(semaphore_pending_addrs) ) )
|--
  “ (semaphore_pending_nodes sem st_lock (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) ) ”
  &&  (os_inv sg_outside_critical st_lock )
).

Definition _SemaphoreDelete_which_implies_wit_4_split_goal_1 := 
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (PreH1 : (In original (st_lock.(os_semaphores) ) )) (PreH2 : (sem = (original.(semaphore_addr) ))) ,
  (store_dll (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &((sem)  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) )
  **  (delete_pending_restore sg_outside_critical st_lock sem (original.(semaphore_pending_addrs) ) )
|--
  “ (semaphore_pending_nodes sem st_lock (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) ) ”
.

Definition _SemaphoreDelete_which_implies_wit_4_split_goal_spatial := 
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (PreH1 : (In original (st_lock.(os_semaphores) ) )) (PreH2 : (sem = (original.(semaphore_addr) ))) ,
  (store_dll (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &((sem)  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((original.(semaphore_pending_addrs) ))) )
  **  (delete_pending_restore sg_outside_critical st_lock sem (original.(semaphore_pending_addrs) ) )
|--
  (os_inv sg_outside_critical st_lock )
.

Definition _SemaphoreDelete_which_implies_wit_5 := 
(
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (drained: VarGlobalState) (sem: Z) (PreH1 : (In original (st_lock.(os_semaphores) ) )) (PreH2 : (sem = (original.(semaphore_addr) ))) (PreH3 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) ,
  (os_inv sg_outside_critical drained )
|--
  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained ) ”
  &&  ((&((sem)  # "Semaphore" ->ₛ "id" .ₛ "id")) # UShort  |-> (original.(semaphore_id) ))
  **  (delete_id_restore sg_outside_critical drained sem (original.(semaphore_id) ) )
) \/
(
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (drained: VarGlobalState) (sem: Z) (PreH1 : (In original (st_lock.(os_semaphores) ) )) (PreH2 : (sem = (original.(semaphore_addr) ))) (PreH3 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) ,
  (os_inv sg_outside_critical drained )
|--
  ((&((sem)  # "Semaphore" ->ₛ "id" .ₛ "id")) # UShort  |-> (original.(semaphore_id) ))
  **  (delete_id_restore sg_outside_critical drained sem (original.(semaphore_id) ) )
).

Definition _SemaphoreDelete_which_implies_wit_5_split_goal_spatial := 
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (drained: VarGlobalState) (sem: Z) (PreH1 : (In original (st_lock.(os_semaphores) ) )) (PreH2 : (sem = (original.(semaphore_addr) ))) (PreH3 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) ,
  (os_inv sg_outside_critical drained )
|--
  ((&((sem)  # "Semaphore" ->ₛ "id" .ₛ "id")) # UShort  |-> (original.(semaphore_id) ))
  **  (delete_id_restore sg_outside_critical drained sem (original.(semaphore_id) ) )
.

Definition _SemaphoreDelete_which_implies_wit_6 := 
(
forall (sg_outside_critical: StableGlobalState) (original: SemaphoreAbs) (drained: VarGlobalState) (sem: Z) ,
  ((&((sem)  # "Semaphore" ->ₛ "id" .ₛ "id")) # UShort  |-> (original.(semaphore_id) ))
  **  (delete_id_restore sg_outside_critical drained sem (original.(semaphore_id) ) )
|--
  “ (sem = (original.(semaphore_addr) )) ”
  &&  (os_inv sg_outside_critical drained )
) \/
(
forall (sg_outside_critical: StableGlobalState) (original: SemaphoreAbs) (drained: VarGlobalState) (sem: Z) ,
  ((&((sem)  # "Semaphore" ->ₛ "id" .ₛ "id")) # UShort  |-> (original.(semaphore_id) ))
  **  (delete_id_restore sg_outside_critical drained sem (original.(semaphore_id) ) )
|--
  “ (sem = (original.(semaphore_addr) )) ”
  &&  (os_inv sg_outside_critical drained )
).

Definition _SemaphoreDelete_which_implies_wit_6_split_goal_1 := 
forall (sg_outside_critical: StableGlobalState) (original: SemaphoreAbs) (drained: VarGlobalState) (sem: Z) ,
  ((&((sem)  # "Semaphore" ->ₛ "id" .ₛ "id")) # UShort  |-> (original.(semaphore_id) ))
  **  (delete_id_restore sg_outside_critical drained sem (original.(semaphore_id) ) )
|--
  “ (sem = (original.(semaphore_addr) )) ”
.

Definition _SemaphoreDelete_which_implies_wit_6_split_goal_spatial := 
forall (sg_outside_critical: StableGlobalState) (original: SemaphoreAbs) (drained: VarGlobalState) (sem: Z) ,
  ((&((sem)  # "Semaphore" ->ₛ "id" .ₛ "id")) # UShort  |-> (original.(semaphore_id) ))
  **  (delete_id_restore sg_outside_critical drained sem (original.(semaphore_id) ) )
|--
  (os_inv sg_outside_critical drained )
.

Definition _SemaphoreDelete_which_implies_wit_7 := 
(
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (drained: VarGlobalState) (sem: Z) (PreH1 : (In original (st_lock.(os_semaphores) ) )) (PreH2 : (sem = (original.(semaphore_addr) ))) (PreH3 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH4 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (os_inv sg_outside_critical drained )
|--
  EX (prefix: (@list SemaphoreAbs))  (current: SemaphoreAbs)  (suffix: (@list SemaphoreAbs)) ,
  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) ) ” 
  &&  “ ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(semaphore_addr) ) = sem) ” 
  &&  “ ((current.(semaphore_id) ) = (original.(semaphore_id) )) ” 
  &&  “ ((current.(semaphore_value) ) = (original.(semaphore_value) )) ” 
  &&  “ ((current.(semaphore_pending_addrs) ) = (@nil Z)) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true) ”
  &&  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical drained )
) \/
(
forall (sg_outside_critical: StableGlobalState) (st_lock: VarGlobalState) (original: SemaphoreAbs) (drained: VarGlobalState) (sem: Z) (PreH1 : (In original (st_lock.(os_semaphores) ) )) (PreH2 : (sem = (original.(semaphore_addr) ))) (PreH3 : (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained )) (PreH4 : (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) )) ,
  (os_inv sg_outside_critical drained )
|--
  EX (prefix: (@list SemaphoreAbs))  (current: SemaphoreAbs)  (suffix: (@list SemaphoreAbs)) ,
  “ (In original (st_lock.(os_semaphores) ) ) ” 
  &&  “ (sem = (original.(semaphore_addr) )) ” 
  &&  “ (semaphore_resume_all_effect sem (original.(semaphore_pending_addrs) ) st_lock drained ) ” 
  &&  “ (semaphore_pending_nodes sem drained (@nil (@DL_Node Z)) ) ” 
  &&  “ ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(semaphore_addr) ) = sem) ” 
  &&  “ ((current.(semaphore_id) ) = (original.(semaphore_id) )) ” 
  &&  “ ((current.(semaphore_value) ) = (original.(semaphore_value) )) ” 
  &&  “ ((current.(semaphore_pending_addrs) ) = (@nil Z)) ” 
  &&  “ ((idmanager_query ((semaphore_manager ((drained.(os_semaphores) )))) ((original.(semaphore_id) ))) = true) ”
  &&  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_outside_critical)))) (semaphore_manager ((drained.(os_semaphores) ))) ( &( "k_sem_id_manager" ) ) )
  **  (delete_manager_frame sg_outside_critical drained )
).

Definition _SemaphoreDelete_which_implies_wit_8 := 
(
forall (sg_outside_critical: StableGlobalState) (drained: VarGlobalState) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (sem: Z) (PreH1 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(semaphore_addr) ) = sem)) ,
  (delete_manager_frame sg_outside_critical drained )
|--
  “ ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(semaphore_addr) ) = sem) ” 
  &&  “ (semaphore_context (os_semaphore_stable (sg_outside_critical)) ) ”
  &&  (delete_global_frame sg_outside_critical drained )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((cons ((Build_DL_Node (current) (&((sem)  # "Semaphore" ->ₛ "link")))) ((map (semaphore_link_node) (suffix)))))) )
) \/
(
forall (sg_outside_critical: StableGlobalState) (drained: VarGlobalState) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (sem: Z) (PreH1 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(semaphore_addr) ) = sem)) ,
  (delete_manager_frame sg_outside_critical drained )
|--
  “ (semaphore_context (os_semaphore_stable (sg_outside_critical)) ) ”
  &&  (delete_global_frame sg_outside_critical drained )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((cons ((Build_DL_Node (current) (&((sem)  # "Semaphore" ->ₛ "link")))) ((map (semaphore_link_node) (suffix)))))) )
).

Definition _SemaphoreDelete_which_implies_wit_8_split_goal_1 := 
forall (sg_outside_critical: StableGlobalState) (drained: VarGlobalState) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (sem: Z) (PreH1 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(semaphore_addr) ) = sem)) ,
  (delete_manager_frame sg_outside_critical drained )
|--
  “ (semaphore_context (os_semaphore_stable (sg_outside_critical)) ) ”
.

Definition _SemaphoreDelete_which_implies_wit_8_split_goal_spatial := 
forall (sg_outside_critical: StableGlobalState) (drained: VarGlobalState) (current: SemaphoreAbs) (prefix: (@list SemaphoreAbs)) (suffix: (@list SemaphoreAbs)) (sem: Z) (PreH1 : ((drained.(os_semaphores) ) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(semaphore_addr) ) = sem)) ,
  (delete_manager_frame sg_outside_critical drained )
|--
  (delete_global_frame sg_outside_critical drained )
  **  (store_dll (store_semaphore ((pure_suspend_sched_link (((drained.(os_tasks) ).(task_desc_map) ))))) ( &( "k_sem_list" ) ) (app ((map (semaphore_link_node) (prefix))) ((cons ((Build_DL_Node (current) (&((sem)  # "Semaphore" ->ₛ "link")))) ((map (semaphore_link_node) (suffix)))))) )
.

Definition _SemaphoreDelete_which_implies_wit_9 := 
(
forall (original: SemaphoreAbs) (sem: Z) ,
  (SemaphoreRetired sem (original.(semaphore_value) ) )
|--
  (SemaphoreRaw sem )
) \/
(
forall (original: SemaphoreAbs) (sem: Z) ,
  (SemaphoreRetired sem (original.(semaphore_value) ) )
|--
  (SemaphoreRaw sem )
).

Definition _SemaphoreDelete_which_implies_wit_9_split_goal_spatial := 
forall (original: SemaphoreAbs) (sem: Z) ,
  (SemaphoreRetired sem (original.(semaphore_value) ) )
|--
  (SemaphoreRaw sem )
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
Axiom proof_of__SemaphoreDelete_safety_wit_16 : _SemaphoreDelete_safety_wit_16.
Axiom proof_of__SemaphoreDelete_entail_wit_1 : _SemaphoreDelete_entail_wit_1.
Axiom proof_of__SemaphoreDelete_entail_wit_2_1 : _SemaphoreDelete_entail_wit_2_1.
Axiom proof_of__SemaphoreDelete_entail_wit_2_2 : _SemaphoreDelete_entail_wit_2_2.
Axiom proof_of__SemaphoreDelete_entail_wit_3_1 : _SemaphoreDelete_entail_wit_3_1.
Axiom proof_of__SemaphoreDelete_entail_wit_3_2 : _SemaphoreDelete_entail_wit_3_2.
Axiom proof_of__SemaphoreDelete_entail_wit_4_1 : _SemaphoreDelete_entail_wit_4_1.
Axiom proof_of__SemaphoreDelete_entail_wit_4_2 : _SemaphoreDelete_entail_wit_4_2.
Axiom proof_of__SemaphoreDelete_entail_wit_4_3 : _SemaphoreDelete_entail_wit_4_3.
Axiom proof_of__SemaphoreDelete_entail_wit_4_4 : _SemaphoreDelete_entail_wit_4_4.
Axiom proof_of__SemaphoreDelete_entail_wit_5_1 : _SemaphoreDelete_entail_wit_5_1.
Axiom proof_of__SemaphoreDelete_entail_wit_5_2 : _SemaphoreDelete_entail_wit_5_2.
Axiom proof_of__SemaphoreDelete_entail_wit_6_1 : _SemaphoreDelete_entail_wit_6_1.
Axiom proof_of__SemaphoreDelete_entail_wit_6_2 : _SemaphoreDelete_entail_wit_6_2.
Axiom proof_of__SemaphoreDelete_return_wit_1 : _SemaphoreDelete_return_wit_1.
Axiom proof_of__SemaphoreDelete_return_wit_2 : _SemaphoreDelete_return_wit_2.
Axiom proof_of__SemaphoreDelete_return_wit_3 : _SemaphoreDelete_return_wit_3.
Axiom proof_of__SemaphoreDelete_return_wit_4 : _SemaphoreDelete_return_wit_4.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_1 : _SemaphoreDelete_partial_solve_wit_1.
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
Axiom proof_of__SemaphoreDelete_partial_solve_wit_8 : _SemaphoreDelete_partial_solve_wit_8.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_9_pure : _SemaphoreDelete_partial_solve_wit_9_pure.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_9 : _SemaphoreDelete_partial_solve_wit_9.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_10_pure : _SemaphoreDelete_partial_solve_wit_10_pure.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_10 : _SemaphoreDelete_partial_solve_wit_10.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_11_pure : _SemaphoreDelete_partial_solve_wit_11_pure.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_11 : _SemaphoreDelete_partial_solve_wit_11.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_12_pure : _SemaphoreDelete_partial_solve_wit_12_pure.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_12 : _SemaphoreDelete_partial_solve_wit_12.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_13 : _SemaphoreDelete_partial_solve_wit_13.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_14 : _SemaphoreDelete_partial_solve_wit_14.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_15_pure : _SemaphoreDelete_partial_solve_wit_15_pure.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_15 : _SemaphoreDelete_partial_solve_wit_15.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_16_pure : _SemaphoreDelete_partial_solve_wit_16_pure.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_16 : _SemaphoreDelete_partial_solve_wit_16.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_17_pure : _SemaphoreDelete_partial_solve_wit_17_pure.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_17 : _SemaphoreDelete_partial_solve_wit_17.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_18_pure : _SemaphoreDelete_partial_solve_wit_18_pure.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_18 : _SemaphoreDelete_partial_solve_wit_18.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_19_pure : _SemaphoreDelete_partial_solve_wit_19_pure.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_19 : _SemaphoreDelete_partial_solve_wit_19.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_20_pure : _SemaphoreDelete_partial_solve_wit_20_pure.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_20 : _SemaphoreDelete_partial_solve_wit_20.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_21_pure : _SemaphoreDelete_partial_solve_wit_21_pure.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_21 : _SemaphoreDelete_partial_solve_wit_21.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_22_pure : _SemaphoreDelete_partial_solve_wit_22_pure.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_22 : _SemaphoreDelete_partial_solve_wit_22.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_23 : _SemaphoreDelete_partial_solve_wit_23.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_24 : _SemaphoreDelete_partial_solve_wit_24.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_25 : _SemaphoreDelete_partial_solve_wit_25.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_26 : _SemaphoreDelete_partial_solve_wit_26.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_27_pure : _SemaphoreDelete_partial_solve_wit_27_pure.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_27 : _SemaphoreDelete_partial_solve_wit_27.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_28_pure : _SemaphoreDelete_partial_solve_wit_28_pure.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_28 : _SemaphoreDelete_partial_solve_wit_28.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_29 : _SemaphoreDelete_partial_solve_wit_29.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_30 : _SemaphoreDelete_partial_solve_wit_30.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_31 : _SemaphoreDelete_partial_solve_wit_31.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_32 : _SemaphoreDelete_partial_solve_wit_32.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_33_pure : _SemaphoreDelete_partial_solve_wit_33_pure.
Axiom proof_of__SemaphoreDelete_partial_solve_wit_33 : _SemaphoreDelete_partial_solve_wit_33.
Axiom proof_of__SemaphoreDelete_which_implies_wit_1 : _SemaphoreDelete_which_implies_wit_1.
Axiom proof_of__SemaphoreDelete_which_implies_wit_2 : _SemaphoreDelete_which_implies_wit_2.
Axiom proof_of__SemaphoreDelete_which_implies_wit_3 : _SemaphoreDelete_which_implies_wit_3.
Axiom proof_of__SemaphoreDelete_which_implies_wit_4 : _SemaphoreDelete_which_implies_wit_4.
Axiom proof_of__SemaphoreDelete_which_implies_wit_5 : _SemaphoreDelete_which_implies_wit_5.
Axiom proof_of__SemaphoreDelete_which_implies_wit_6 : _SemaphoreDelete_which_implies_wit_6.
Axiom proof_of__SemaphoreDelete_which_implies_wit_7 : _SemaphoreDelete_which_implies_wit_7.
Axiom proof_of__SemaphoreDelete_which_implies_wit_8 : _SemaphoreDelete_which_implies_wit_8.
Axiom proof_of__SemaphoreDelete_which_implies_wit_9 : _SemaphoreDelete_which_implies_wit_9.

End VC_Correct.
