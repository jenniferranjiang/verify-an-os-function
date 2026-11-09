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
Require Import CRTOS_Verify.lib.KTaskWakeup.
Require Import CRTOS_Verify.lib.DoubleLinkListSpec CRTOS_Verify.lib.TaskStatusMemory CRTOS_Verify.lib.KTaskParseInfo.
Import IDNode DLL.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.KMutexDelete.
Require Import KMutexDeleteProof.VC.MutexDelete_lib.
Local Open Scope sac.

(*----- Function _MutexDelete -----*)

Definition _MutexDelete_safety_wit_1 := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (PreH1 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  ((( &( "lock" ) )) # Int  |->_)
  **  ((( &( "mutex" ) )) # Ptr  |-> mutex_pre)
  **  (OutsideCritical sg_assumed_environment before_assumed_environment )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _MutexDelete_safety_wit_2 := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (PreH1 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "mutex" ) )) # Ptr  |-> mutex_pre)
  **  (OutsideCritical sg_assumed_environment before_assumed_environment )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _MutexDelete_safety_wit_3 := 
forall (mutex_pre: Z) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (PreH1 : (mutex_pre = 0)) (PreH2 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) ,
  ((( &( "mutex" ) )) # Ptr  |-> mutex_pre)
  **  ((( &( "lock" ) )) # Int  |->_)
  **  (OutsideCritical sg_assumed_environment before_assumed_environment )
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition _MutexDelete_entail_wit_1 := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (PreH1 : (mutex_pre = 0)) (PreH2 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  ((( &( "lock" ) )) # Int  |-> 0)
  **  (OutsideCritical sg_assumed_environment before_assumed_environment )
|--
  “ (mutex_pre = 0) ” 
  &&  “ (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment ) ”
  &&  ((( &( "lock" ) )) # Int  |->_)
  **  (OutsideCritical sg_assumed_environment before_assumed_environment )
.

Definition _MutexDelete_entail_wit_2 := 
forall (mutex_pre: Z) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (PreH1 : (mutex_pre = 0)) (PreH2 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) ,
  (OutsideCritical sg_assumed_environment before_assumed_environment )
|--
  “ (mutex_pre = 0) ” 
  &&  “ (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment ) ”
  &&  (OutsideCritical sg_assumed_environment before_assumed_environment )
.

Definition _MutexDelete_entail_wit_3_1 := 
(
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (PreH1 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(mutex_addr) ) = mutex_pre)) (PreH3 : (mutex_context (os_mutex_stable (sg_assumed_environment)) )) (PreH4 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = false)) (PreH5 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH6 : ((current.(mutex_addr) ) = mutex_pre)) (PreH7 : ((current.(mutex_id) ) = id_assumed_environment)) (PreH8 : ((current.(mutex_pending_addrs) ) = (@nil Z))) (PreH9 : (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) )) (PreH10 : (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) )) (PreH11 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH12 : (Crtos_RTrans drained st_lock )) (PreH13 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH15 : (retval = KOK)) (PreH16 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH19 : (mutex_pre <> 0)) (PreH20 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (store_dll (store_mutex ((pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))))) ( &( "k_mutex_list" ) ) (app ((map (mutex_link_node) (prefix))) ((map (mutex_link_node) (suffix)))) )
  **  (store_mutex (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &((mutex_pre)  # "Mutex" ->ₛ "link") current )
  **  (store_node_self_linked &((mutex_pre)  # "Mutex" ->ₛ "link") )
  **  (mutex_create_frame sg_assumed_environment st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (InsideCritical sg_assumed_environment st_lock )
|--
  EX (after: VarGlobalState) ,
  “ (mutex_pre = (current.(mutex_addr) )) ” 
  &&  “ (after = (replace_mutexes ((mutex_delete_unpublish (mutex_pre) ((os_mutexes (st_lock))))) (st_lock))) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_assumed_environment ) ” 
  &&  “ (Crtos_GTrans st_lock after ) ”
  &&  (InsideCritical sg_assumed_environment st_lock )
  **  (os_inv sg_assumed_environment after )
  **  (MutexRetired current )
) \/
(
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (PreH1 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(mutex_addr) ) = mutex_pre)) (PreH3 : (mutex_context (os_mutex_stable (sg_assumed_environment)) )) (PreH4 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = false)) (PreH5 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH6 : ((current.(mutex_addr) ) = mutex_pre)) (PreH7 : ((current.(mutex_id) ) = id_assumed_environment)) (PreH8 : ((current.(mutex_pending_addrs) ) = (@nil Z))) (PreH9 : (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) )) (PreH10 : (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) )) (PreH11 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH12 : (Crtos_RTrans drained st_lock )) (PreH13 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH15 : (retval = KOK)) (PreH16 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH19 : (mutex_pre <> 0)) (PreH20 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (store_dll (store_mutex ((pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))))) ( &( "k_mutex_list" ) ) (app ((map (mutex_link_node) (prefix))) ((map (mutex_link_node) (suffix)))) )
  **  (store_mutex (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &((mutex_pre)  # "Mutex" ->ₛ "link") current )
  **  (store_node_self_linked &((mutex_pre)  # "Mutex" ->ₛ "link") )
  **  (mutex_create_frame sg_assumed_environment st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (InsideCritical sg_assumed_environment st_lock )
|--
  “ (Crtos_GTrans st_lock (replace_mutexes ((mutex_delete_unpublish (mutex_pre) ((os_mutexes (st_lock))))) (st_lock)) ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen ((replace_mutexes ((mutex_delete_unpublish (mutex_pre) ((os_mutexes (st_lock))))) (st_lock)))) ( MonadErr.ret  (tt)) X_assumed_environment ) ”
  &&  (InsideCritical sg_assumed_environment st_lock )
  **  (os_inv sg_assumed_environment (replace_mutexes ((mutex_delete_unpublish (mutex_pre) ((os_mutexes (st_lock))))) (st_lock)) )
  **  (MutexRetired current )
).

Definition _MutexDelete_entail_wit_3_1_split_goal_1 := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (PreH1 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(mutex_addr) ) = mutex_pre)) (PreH3 : (mutex_context (os_mutex_stable (sg_assumed_environment)) )) (PreH4 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = false)) (PreH5 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH6 : ((current.(mutex_addr) ) = mutex_pre)) (PreH7 : ((current.(mutex_id) ) = id_assumed_environment)) (PreH8 : ((current.(mutex_pending_addrs) ) = (@nil Z))) (PreH9 : (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) )) (PreH10 : (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) )) (PreH11 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH12 : (Crtos_RTrans drained st_lock )) (PreH13 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH15 : (retval = KOK)) (PreH16 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH19 : (mutex_pre <> 0)) (PreH20 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (store_dll (store_mutex ((pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))))) ( &( "k_mutex_list" ) ) (app ((map (mutex_link_node) (prefix))) ((map (mutex_link_node) (suffix)))) )
  **  (store_mutex (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &((mutex_pre)  # "Mutex" ->ₛ "link") current )
  **  (store_node_self_linked &((mutex_pre)  # "Mutex" ->ₛ "link") )
  **  (mutex_create_frame sg_assumed_environment st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (InsideCritical sg_assumed_environment st_lock )
|--
  “ (Crtos_GTrans st_lock (replace_mutexes ((mutex_delete_unpublish (mutex_pre) ((os_mutexes (st_lock))))) (st_lock)) ) ”
.

Definition _MutexDelete_entail_wit_3_1_split_goal_2 := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (PreH1 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(mutex_addr) ) = mutex_pre)) (PreH3 : (mutex_context (os_mutex_stable (sg_assumed_environment)) )) (PreH4 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = false)) (PreH5 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH6 : ((current.(mutex_addr) ) = mutex_pre)) (PreH7 : ((current.(mutex_id) ) = id_assumed_environment)) (PreH8 : ((current.(mutex_pending_addrs) ) = (@nil Z))) (PreH9 : (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) )) (PreH10 : (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) )) (PreH11 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH12 : (Crtos_RTrans drained st_lock )) (PreH13 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH15 : (retval = KOK)) (PreH16 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH19 : (mutex_pre <> 0)) (PreH20 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (store_dll (store_mutex ((pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))))) ( &( "k_mutex_list" ) ) (app ((map (mutex_link_node) (prefix))) ((map (mutex_link_node) (suffix)))) )
  **  (store_mutex (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &((mutex_pre)  # "Mutex" ->ₛ "link") current )
  **  (store_node_self_linked &((mutex_pre)  # "Mutex" ->ₛ "link") )
  **  (mutex_create_frame sg_assumed_environment st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (InsideCritical sg_assumed_environment st_lock )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen ((replace_mutexes ((mutex_delete_unpublish (mutex_pre) ((os_mutexes (st_lock))))) (st_lock)))) ( MonadErr.ret  (tt)) X_assumed_environment ) ”
.

Definition _MutexDelete_entail_wit_3_1_split_goal_spatial := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (PreH1 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(mutex_addr) ) = mutex_pre)) (PreH3 : (mutex_context (os_mutex_stable (sg_assumed_environment)) )) (PreH4 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = false)) (PreH5 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH6 : ((current.(mutex_addr) ) = mutex_pre)) (PreH7 : ((current.(mutex_id) ) = id_assumed_environment)) (PreH8 : ((current.(mutex_pending_addrs) ) = (@nil Z))) (PreH9 : (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) )) (PreH10 : (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) )) (PreH11 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH12 : (Crtos_RTrans drained st_lock )) (PreH13 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH15 : (retval = KOK)) (PreH16 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH19 : (mutex_pre <> 0)) (PreH20 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (store_dll (store_mutex ((pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))))) ( &( "k_mutex_list" ) ) (app ((map (mutex_link_node) (prefix))) ((map (mutex_link_node) (suffix)))) )
  **  (store_mutex (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &((mutex_pre)  # "Mutex" ->ₛ "link") current )
  **  (store_node_self_linked &((mutex_pre)  # "Mutex" ->ₛ "link") )
  **  (mutex_create_frame sg_assumed_environment st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (InsideCritical sg_assumed_environment st_lock )
|--
  (InsideCritical sg_assumed_environment st_lock )
  **  (os_inv sg_assumed_environment (replace_mutexes ((mutex_delete_unpublish (mutex_pre) ((os_mutexes (st_lock))))) (st_lock)) )
  **  (MutexRetired current )
.

Definition _MutexDelete_entail_wit_3_2 := 
(
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (idnode: Z) (PreH1 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(mutex_addr) ) = mutex_pre)) (PreH3 : (mutex_context (os_mutex_stable (sg_assumed_environment)) )) (PreH4 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH5 : (idmanager_contains (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) id_assumed_environment idnode )) (PreH6 : (idnode <> 0)) (PreH7 : (&((idnode)  # "IdNode" ->ₛ "link") <> 0)) (PreH8 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH9 : ((current.(mutex_addr) ) = mutex_pre)) (PreH10 : ((current.(mutex_id) ) = id_assumed_environment)) (PreH11 : ((current.(mutex_pending_addrs) ) = (@nil Z))) (PreH12 : (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) )) (PreH13 : (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) )) (PreH14 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH15 : (Crtos_RTrans drained st_lock )) (PreH16 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH18 : (retval = KOK)) (PreH19 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH22 : (mutex_pre <> 0)) (PreH23 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH24 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (store_dll (store_mutex ((pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))))) ( &( "k_mutex_list" ) ) (app ((map (mutex_link_node) (prefix))) ((map (mutex_link_node) (suffix)))) )
  **  (store_mutex (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &((mutex_pre)  # "Mutex" ->ₛ "link") current )
  **  (store_node_self_linked &((mutex_pre)  # "Mutex" ->ₛ "link") )
  **  (mutex_create_frame sg_assumed_environment st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (idmanager_remove ((mutex_manager_stable ((os_mutex_stable (sg_assumed_environment))))) ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) ( &( "k_mutex_id_manager" ) ) )
  **  ((&((idnode)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  (InsideCritical sg_assumed_environment st_lock )
|--
  EX (after: VarGlobalState) ,
  “ (mutex_pre = (current.(mutex_addr) )) ” 
  &&  “ (after = (replace_mutexes ((mutex_delete_unpublish (mutex_pre) ((os_mutexes (st_lock))))) (st_lock))) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_assumed_environment ) ” 
  &&  “ (Crtos_GTrans st_lock after ) ”
  &&  (InsideCritical sg_assumed_environment st_lock )
  **  (os_inv sg_assumed_environment after )
  **  (MutexRetired current )
) \/
(
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (idnode: Z) (PreH1 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(mutex_addr) ) = mutex_pre)) (PreH3 : (mutex_context (os_mutex_stable (sg_assumed_environment)) )) (PreH4 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH5 : (idmanager_contains (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) id_assumed_environment idnode )) (PreH6 : (idnode <> 0)) (PreH7 : (&((idnode)  # "IdNode" ->ₛ "link") <> 0)) (PreH8 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH9 : ((current.(mutex_addr) ) = mutex_pre)) (PreH10 : ((current.(mutex_id) ) = id_assumed_environment)) (PreH11 : ((current.(mutex_pending_addrs) ) = (@nil Z))) (PreH12 : (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) )) (PreH13 : (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) )) (PreH14 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH15 : (Crtos_RTrans drained st_lock )) (PreH16 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH18 : (retval = KOK)) (PreH19 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH22 : (mutex_pre <> 0)) (PreH23 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH24 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (store_dll (store_mutex ((pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))))) ( &( "k_mutex_list" ) ) (app ((map (mutex_link_node) (prefix))) ((map (mutex_link_node) (suffix)))) )
  **  (store_mutex (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &((mutex_pre)  # "Mutex" ->ₛ "link") current )
  **  (store_node_self_linked &((mutex_pre)  # "Mutex" ->ₛ "link") )
  **  (mutex_create_frame sg_assumed_environment st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (idmanager_remove ((mutex_manager_stable ((os_mutex_stable (sg_assumed_environment))))) ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) ( &( "k_mutex_id_manager" ) ) )
  **  ((&((idnode)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  (InsideCritical sg_assumed_environment st_lock )
|--
  “ (Crtos_GTrans st_lock (replace_mutexes ((mutex_delete_unpublish (mutex_pre) ((os_mutexes (st_lock))))) (st_lock)) ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen ((replace_mutexes ((mutex_delete_unpublish (mutex_pre) ((os_mutexes (st_lock))))) (st_lock)))) ( MonadErr.ret  (tt)) X_assumed_environment ) ”
  &&  (InsideCritical sg_assumed_environment st_lock )
  **  (os_inv sg_assumed_environment (replace_mutexes ((mutex_delete_unpublish (mutex_pre) ((os_mutexes (st_lock))))) (st_lock)) )
  **  (MutexRetired current )
).

Definition _MutexDelete_entail_wit_3_2_split_goal_1 := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (idnode: Z) (PreH1 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(mutex_addr) ) = mutex_pre)) (PreH3 : (mutex_context (os_mutex_stable (sg_assumed_environment)) )) (PreH4 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH5 : (idmanager_contains (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) id_assumed_environment idnode )) (PreH6 : (idnode <> 0)) (PreH7 : (&((idnode)  # "IdNode" ->ₛ "link") <> 0)) (PreH8 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH9 : ((current.(mutex_addr) ) = mutex_pre)) (PreH10 : ((current.(mutex_id) ) = id_assumed_environment)) (PreH11 : ((current.(mutex_pending_addrs) ) = (@nil Z))) (PreH12 : (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) )) (PreH13 : (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) )) (PreH14 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH15 : (Crtos_RTrans drained st_lock )) (PreH16 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH18 : (retval = KOK)) (PreH19 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH22 : (mutex_pre <> 0)) (PreH23 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH24 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (store_dll (store_mutex ((pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))))) ( &( "k_mutex_list" ) ) (app ((map (mutex_link_node) (prefix))) ((map (mutex_link_node) (suffix)))) )
  **  (store_mutex (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &((mutex_pre)  # "Mutex" ->ₛ "link") current )
  **  (store_node_self_linked &((mutex_pre)  # "Mutex" ->ₛ "link") )
  **  (mutex_create_frame sg_assumed_environment st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (idmanager_remove ((mutex_manager_stable ((os_mutex_stable (sg_assumed_environment))))) ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) ( &( "k_mutex_id_manager" ) ) )
  **  ((&((idnode)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  (InsideCritical sg_assumed_environment st_lock )
|--
  “ (Crtos_GTrans st_lock (replace_mutexes ((mutex_delete_unpublish (mutex_pre) ((os_mutexes (st_lock))))) (st_lock)) ) ”
.

Definition _MutexDelete_entail_wit_3_2_split_goal_2 := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (idnode: Z) (PreH1 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(mutex_addr) ) = mutex_pre)) (PreH3 : (mutex_context (os_mutex_stable (sg_assumed_environment)) )) (PreH4 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH5 : (idmanager_contains (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) id_assumed_environment idnode )) (PreH6 : (idnode <> 0)) (PreH7 : (&((idnode)  # "IdNode" ->ₛ "link") <> 0)) (PreH8 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH9 : ((current.(mutex_addr) ) = mutex_pre)) (PreH10 : ((current.(mutex_id) ) = id_assumed_environment)) (PreH11 : ((current.(mutex_pending_addrs) ) = (@nil Z))) (PreH12 : (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) )) (PreH13 : (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) )) (PreH14 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH15 : (Crtos_RTrans drained st_lock )) (PreH16 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH18 : (retval = KOK)) (PreH19 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH22 : (mutex_pre <> 0)) (PreH23 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH24 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (store_dll (store_mutex ((pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))))) ( &( "k_mutex_list" ) ) (app ((map (mutex_link_node) (prefix))) ((map (mutex_link_node) (suffix)))) )
  **  (store_mutex (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &((mutex_pre)  # "Mutex" ->ₛ "link") current )
  **  (store_node_self_linked &((mutex_pre)  # "Mutex" ->ₛ "link") )
  **  (mutex_create_frame sg_assumed_environment st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (idmanager_remove ((mutex_manager_stable ((os_mutex_stable (sg_assumed_environment))))) ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) ( &( "k_mutex_id_manager" ) ) )
  **  ((&((idnode)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  (InsideCritical sg_assumed_environment st_lock )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen ((replace_mutexes ((mutex_delete_unpublish (mutex_pre) ((os_mutexes (st_lock))))) (st_lock)))) ( MonadErr.ret  (tt)) X_assumed_environment ) ”
.

Definition _MutexDelete_entail_wit_3_2_split_goal_spatial := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (idnode: Z) (PreH1 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(mutex_addr) ) = mutex_pre)) (PreH3 : (mutex_context (os_mutex_stable (sg_assumed_environment)) )) (PreH4 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH5 : (idmanager_contains (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) id_assumed_environment idnode )) (PreH6 : (idnode <> 0)) (PreH7 : (&((idnode)  # "IdNode" ->ₛ "link") <> 0)) (PreH8 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH9 : ((current.(mutex_addr) ) = mutex_pre)) (PreH10 : ((current.(mutex_id) ) = id_assumed_environment)) (PreH11 : ((current.(mutex_pending_addrs) ) = (@nil Z))) (PreH12 : (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) )) (PreH13 : (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) )) (PreH14 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH15 : (Crtos_RTrans drained st_lock )) (PreH16 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH18 : (retval = KOK)) (PreH19 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH22 : (mutex_pre <> 0)) (PreH23 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH24 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (store_dll (store_mutex ((pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))))) ( &( "k_mutex_list" ) ) (app ((map (mutex_link_node) (prefix))) ((map (mutex_link_node) (suffix)))) )
  **  (store_mutex (pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))) &((mutex_pre)  # "Mutex" ->ₛ "link") current )
  **  (store_node_self_linked &((mutex_pre)  # "Mutex" ->ₛ "link") )
  **  (mutex_create_frame sg_assumed_environment st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (idmanager_remove ((mutex_manager_stable ((os_mutex_stable (sg_assumed_environment))))) ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) ( &( "k_mutex_id_manager" ) ) )
  **  ((&((idnode)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  (InsideCritical sg_assumed_environment st_lock )
|--
  (InsideCritical sg_assumed_environment st_lock )
  **  (os_inv sg_assumed_environment (replace_mutexes ((mutex_delete_unpublish (mutex_pre) ((os_mutexes (st_lock))))) (st_lock)) )
  **  (MutexRetired current )
.

Definition _MutexDelete_return_wit_1 := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (after_2: VarGlobalState) (PreH1 : (mutex_pre = (current.(mutex_addr) ))) (PreH2 : (after_2 = (replace_mutexes ((mutex_delete_unpublish (mutex_pre) ((os_mutexes (st_lock))))) (st_lock)))) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (after_2)) ( MonadErr.ret  (tt)) X_assumed_environment )) (PreH4 : (Crtos_GTrans st_lock after_2 )) ,
  (OutsideCritical sg_assumed_environment after_2 )
|--
  EX (after: VarGlobalState) ,
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_assumed_environment ) ”
  &&  (OutsideCritical sg_assumed_environment after )
.

Definition _MutexDelete_partial_solve_wit_1_pure := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (PreH1 : (mutex_pre <> 0)) (PreH2 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "mutex" ) )) # Ptr  |-> mutex_pre)
  **  (OutsideCritical sg_assumed_environment before_assumed_environment )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment ) ”
.

Definition _MutexDelete_partial_solve_wit_1_aux := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (PreH1 : (mutex_pre <> 0)) (PreH2 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (OutsideCritical sg_assumed_environment before_assumed_environment )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment ) ” 
  &&  “ (mutex_pre <> 0) ” 
  &&  “ (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment ) ”
  &&  (OutsideCritical sg_assumed_environment before_assumed_environment )
.

Definition _MutexDelete_partial_solve_wit_1 := _MutexDelete_partial_solve_wit_1_pure -> _MutexDelete_partial_solve_wit_1_aux.

Definition _MutexDelete_partial_solve_wit_2_pure := 
(
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH2 : (mutex_pre <> 0)) (PreH3 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "mutex" ) )) # Ptr  |-> mutex_pre)
  **  (OutsideCritical sg_assumed_environment before_assumed_environment )
|--
  “ (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ” 
  &&  “ (&((mutex_pre)  # "Mutex" ->ₛ "pend_list") = (mutex_pending_head (mutex_pre))) ”
) \/
(
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (PreH1 : (0 <= INT_MAX)) (PreH2 : (0 >= INT_MIN)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH4 : (mutex_pre <> 0)) (PreH5 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "mutex" ) )) # Ptr  |-> mutex_pre)
  **  (OutsideCritical sg_assumed_environment before_assumed_environment )
|--
  “ (&((mutex_pre)  # "Mutex" ->ₛ "pend_list") = (mutex_pending_head (mutex_pre))) ”
).

Definition _MutexDelete_partial_solve_wit_2_pure_split_goal_1 := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (PreH1 : (0 <= INT_MAX)) (PreH2 : (0 >= INT_MIN)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH4 : (mutex_pre <> 0)) (PreH5 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "mutex" ) )) # Ptr  |-> mutex_pre)
  **  (OutsideCritical sg_assumed_environment before_assumed_environment )
|--
  “ (&((mutex_pre)  # "Mutex" ->ₛ "pend_list") = (mutex_pending_head (mutex_pre))) ”
.

Definition _MutexDelete_partial_solve_wit_2_aux := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH2 : (mutex_pre <> 0)) (PreH3 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (OutsideCritical sg_assumed_environment before_assumed_environment )
|--
  “ (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ” 
  &&  “ (&((mutex_pre)  # "Mutex" ->ₛ "pend_list") = (mutex_pending_head (mutex_pre))) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ” 
  &&  “ (mutex_pre <> 0) ” 
  &&  “ (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment ) ”
  &&  (OutsideCritical sg_assumed_environment before_assumed_environment )
.

Definition _MutexDelete_partial_solve_wit_2 := _MutexDelete_partial_solve_wit_2_pure -> _MutexDelete_partial_solve_wit_2_aux.

Definition _MutexDelete_partial_solve_wit_3_pure := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (PreH1 : (retval = KOK)) (PreH2 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH5 : (mutex_pre <> 0)) (PreH6 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (OutsideCritical sg_assumed_environment drained )
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "mutex" ) )) # Ptr  |-> mutex_pre)
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ”
.

Definition _MutexDelete_partial_solve_wit_3_aux := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (PreH1 : (retval = KOK)) (PreH2 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH5 : (mutex_pre <> 0)) (PreH6 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (OutsideCritical sg_assumed_environment drained )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ” 
  &&  “ (retval = KOK) ” 
  &&  “ (mutex_delete_drained mutex_pre id_assumed_environment drained ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ” 
  &&  “ (mutex_pre <> 0) ” 
  &&  “ (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment ) ”
  &&  (OutsideCritical sg_assumed_environment drained )
.

Definition _MutexDelete_partial_solve_wit_3 := _MutexDelete_partial_solve_wit_3_pure -> _MutexDelete_partial_solve_wit_3_aux.

Definition _MutexDelete_partial_solve_wit_4_pure := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH2 : (retval = KOK)) (PreH3 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH6 : (mutex_pre <> 0)) (PreH7 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (OutsideCritical sg_assumed_environment drained )
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "mutex" ) )) # Ptr  |-> mutex_pre)
|--
  “ (mutex_delete_drained mutex_pre id_assumed_environment drained ) ”
.

Definition _MutexDelete_partial_solve_wit_4_aux := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH2 : (retval = KOK)) (PreH3 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH6 : (mutex_pre <> 0)) (PreH7 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (OutsideCritical sg_assumed_environment drained )
|--
  “ (mutex_delete_drained mutex_pre id_assumed_environment drained ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment ) ” 
  &&  “ (retval = KOK) ” 
  &&  “ (mutex_delete_drained mutex_pre id_assumed_environment drained ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ” 
  &&  “ (mutex_pre <> 0) ” 
  &&  “ (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment ) ”
  &&  (OutsideCritical sg_assumed_environment drained )
.

Definition _MutexDelete_partial_solve_wit_4 := _MutexDelete_partial_solve_wit_4_pure -> _MutexDelete_partial_solve_wit_4_aux.

Definition _MutexDelete_partial_solve_wit_5_pure := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (retval_2: Z) (st_lock: VarGlobalState) (PreH1 : (Crtos_RTrans drained st_lock )) (PreH2 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH4 : (retval = KOK)) (PreH5 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH8 : (mutex_pre <> 0)) (PreH9 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (InsideCritical sg_assumed_environment st_lock )
  **  (os_inv sg_assumed_environment st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_2)
  **  ((( &( "mutex" ) )) # Ptr  |-> mutex_pre)
|--
  “ (mutex_delete_drained mutex_pre id_assumed_environment st_lock ) ”
.

Definition _MutexDelete_partial_solve_wit_5_aux := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (st_lock: VarGlobalState) (PreH1 : (Crtos_RTrans drained st_lock )) (PreH2 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH4 : (retval = KOK)) (PreH5 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH8 : (mutex_pre <> 0)) (PreH9 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (InsideCritical sg_assumed_environment st_lock )
  **  (os_inv sg_assumed_environment st_lock )
|--
  “ (mutex_delete_drained mutex_pre id_assumed_environment st_lock ) ” 
  &&  “ (Crtos_RTrans drained st_lock ) ” 
  &&  “ (mutex_delete_drained mutex_pre id_assumed_environment st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment ) ” 
  &&  “ (retval = KOK) ” 
  &&  “ (mutex_delete_drained mutex_pre id_assumed_environment drained ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ” 
  &&  “ (mutex_pre <> 0) ” 
  &&  “ (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment ) ”
  &&  (os_inv sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
.

Definition _MutexDelete_partial_solve_wit_5 := _MutexDelete_partial_solve_wit_5_pure -> _MutexDelete_partial_solve_wit_5_aux.

Definition _MutexDelete_partial_solve_wit_6 := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (PreH1 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(mutex_addr) ) = mutex_pre)) (PreH3 : ((current.(mutex_id) ) = id_assumed_environment)) (PreH4 : ((current.(mutex_pending_addrs) ) = (@nil Z))) (PreH5 : (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) )) (PreH6 : (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) )) (PreH7 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH8 : (Crtos_RTrans drained st_lock )) (PreH9 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH11 : (retval = KOK)) (PreH12 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH15 : (mutex_pre <> 0)) (PreH16 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  ((&((mutex_pre)  # "Mutex" ->ₛ "id" .ₛ "id")) # UShort  |-> id_assumed_environment)
  **  (mutex_delete_id_restore sg_assumed_environment st_lock mutex_pre id_assumed_environment )
  **  (InsideCritical sg_assumed_environment st_lock )
|--
  “ ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(mutex_addr) ) = mutex_pre) ” 
  &&  “ ((current.(mutex_id) ) = id_assumed_environment) ” 
  &&  “ ((current.(mutex_pending_addrs) ) = (@nil Z)) ” 
  &&  “ (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) ) ” 
  &&  “ (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) ) ” 
  &&  “ ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true) ” 
  &&  “ (Crtos_RTrans drained st_lock ) ” 
  &&  “ (mutex_delete_drained mutex_pre id_assumed_environment st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment ) ” 
  &&  “ (retval = KOK) ” 
  &&  “ (mutex_delete_drained mutex_pre id_assumed_environment drained ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ” 
  &&  “ (mutex_pre <> 0) ” 
  &&  “ (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment ) ”
  &&  ((&((mutex_pre)  # "Mutex" ->ₛ "id" .ₛ "id")) # UShort  |-> id_assumed_environment)
  **  (mutex_delete_id_restore sg_assumed_environment st_lock mutex_pre id_assumed_environment )
  **  (InsideCritical sg_assumed_environment st_lock )
.

Definition _MutexDelete_partial_solve_wit_7 := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (PreH1 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(mutex_addr) ) = mutex_pre)) (PreH3 : ((current.(mutex_id) ) = id_assumed_environment)) (PreH4 : ((current.(mutex_pending_addrs) ) = (@nil Z))) (PreH5 : (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) )) (PreH6 : (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) )) (PreH7 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH8 : (Crtos_RTrans drained st_lock )) (PreH9 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH11 : (retval = KOK)) (PreH12 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH15 : (mutex_pre <> 0)) (PreH16 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (os_inv sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
|--
  “ ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(mutex_addr) ) = mutex_pre) ” 
  &&  “ ((current.(mutex_id) ) = id_assumed_environment) ” 
  &&  “ ((current.(mutex_pending_addrs) ) = (@nil Z)) ” 
  &&  “ (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) ) ” 
  &&  “ (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) ) ” 
  &&  “ ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true) ” 
  &&  “ (Crtos_RTrans drained st_lock ) ” 
  &&  “ (mutex_delete_drained mutex_pre id_assumed_environment st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment ) ” 
  &&  “ (retval = KOK) ” 
  &&  “ (mutex_delete_drained mutex_pre id_assumed_environment drained ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ” 
  &&  “ (mutex_pre <> 0) ” 
  &&  “ (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment ) ”
  &&  (os_inv sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
.

Definition _MutexDelete_partial_solve_wit_8_pure := 
(
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (retval_2: Z) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (PreH1 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(mutex_addr) ) = mutex_pre)) (PreH3 : ((current.(mutex_id) ) = id_assumed_environment)) (PreH4 : ((current.(mutex_pending_addrs) ) = (@nil Z))) (PreH5 : (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) )) (PreH6 : (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) )) (PreH7 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH8 : (Crtos_RTrans drained st_lock )) (PreH9 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH11 : (retval = KOK)) (PreH12 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH15 : (mutex_pre <> 0)) (PreH16 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_delete_manager_frame sg_assumed_environment st_lock )
  **  ((( &( "delete_mutex_id" ) )) # UShort  |-> id_assumed_environment)
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_2)
  **  ((( &( "mutex" ) )) # Ptr  |-> mutex_pre)
|--
  “ (id_assumed_environment < 65536) ” 
  &&  “ (0 <= id_assumed_environment) ” 
  &&  “ (( &( "k_mutex_id_manager" ) ) <> 0) ”
) \/
(
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (retval_2: Z) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (PreH1 : (retval_2 <= INT_MAX)) (PreH2 : (retval_2 >= INT_MIN)) (PreH3 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH4 : ((current.(mutex_addr) ) = mutex_pre)) (PreH5 : ((current.(mutex_id) ) = id_assumed_environment)) (PreH6 : ((current.(mutex_pending_addrs) ) = (@nil Z))) (PreH7 : (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) )) (PreH8 : (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) )) (PreH9 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH10 : (Crtos_RTrans drained st_lock )) (PreH11 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH12 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH13 : (retval = KOK)) (PreH14 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH16 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH17 : (mutex_pre <> 0)) (PreH18 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_delete_manager_frame sg_assumed_environment st_lock )
  **  ((( &( "delete_mutex_id" ) )) # UShort  |-> id_assumed_environment)
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_2)
  **  ((( &( "mutex" ) )) # Ptr  |-> mutex_pre)
|--
  “ (( &( "k_mutex_id_manager" ) ) <> 0) ” 
  &&  “ (0 <= id_assumed_environment) ” 
  &&  “ (id_assumed_environment < 65536) ”
).

Definition _MutexDelete_partial_solve_wit_8_pure_split_goal_1 := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (retval_2: Z) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (PreH1 : (retval_2 <= INT_MAX)) (PreH2 : (retval_2 >= INT_MIN)) (PreH3 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH4 : ((current.(mutex_addr) ) = mutex_pre)) (PreH5 : ((current.(mutex_id) ) = id_assumed_environment)) (PreH6 : ((current.(mutex_pending_addrs) ) = (@nil Z))) (PreH7 : (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) )) (PreH8 : (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) )) (PreH9 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH10 : (Crtos_RTrans drained st_lock )) (PreH11 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH12 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH13 : (retval = KOK)) (PreH14 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH16 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH17 : (mutex_pre <> 0)) (PreH18 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_delete_manager_frame sg_assumed_environment st_lock )
  **  ((( &( "delete_mutex_id" ) )) # UShort  |-> id_assumed_environment)
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_2)
  **  ((( &( "mutex" ) )) # Ptr  |-> mutex_pre)
|--
  “ (( &( "k_mutex_id_manager" ) ) <> 0) ”
.

Definition _MutexDelete_partial_solve_wit_8_pure_split_goal_2 := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (retval_2: Z) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (PreH1 : (retval_2 <= INT_MAX)) (PreH2 : (retval_2 >= INT_MIN)) (PreH3 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH4 : ((current.(mutex_addr) ) = mutex_pre)) (PreH5 : ((current.(mutex_id) ) = id_assumed_environment)) (PreH6 : ((current.(mutex_pending_addrs) ) = (@nil Z))) (PreH7 : (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) )) (PreH8 : (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) )) (PreH9 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH10 : (Crtos_RTrans drained st_lock )) (PreH11 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH12 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH13 : (retval = KOK)) (PreH14 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH16 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH17 : (mutex_pre <> 0)) (PreH18 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_delete_manager_frame sg_assumed_environment st_lock )
  **  ((( &( "delete_mutex_id" ) )) # UShort  |-> id_assumed_environment)
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_2)
  **  ((( &( "mutex" ) )) # Ptr  |-> mutex_pre)
|--
  “ (0 <= id_assumed_environment) ”
.

Definition _MutexDelete_partial_solve_wit_8_pure_split_goal_3 := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (retval_2: Z) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (PreH1 : (retval_2 <= INT_MAX)) (PreH2 : (retval_2 >= INT_MIN)) (PreH3 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH4 : ((current.(mutex_addr) ) = mutex_pre)) (PreH5 : ((current.(mutex_id) ) = id_assumed_environment)) (PreH6 : ((current.(mutex_pending_addrs) ) = (@nil Z))) (PreH7 : (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) )) (PreH8 : (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) )) (PreH9 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH10 : (Crtos_RTrans drained st_lock )) (PreH11 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH12 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH13 : (retval = KOK)) (PreH14 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH16 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH17 : (mutex_pre <> 0)) (PreH18 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_delete_manager_frame sg_assumed_environment st_lock )
  **  ((( &( "delete_mutex_id" ) )) # UShort  |-> id_assumed_environment)
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_2)
  **  ((( &( "mutex" ) )) # Ptr  |-> mutex_pre)
|--
  “ (id_assumed_environment < 65536) ”
.

Definition _MutexDelete_partial_solve_wit_8_aux := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (PreH1 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(mutex_addr) ) = mutex_pre)) (PreH3 : ((current.(mutex_id) ) = id_assumed_environment)) (PreH4 : ((current.(mutex_pending_addrs) ) = (@nil Z))) (PreH5 : (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) )) (PreH6 : (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) )) (PreH7 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH8 : (Crtos_RTrans drained st_lock )) (PreH9 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH11 : (retval = KOK)) (PreH12 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH15 : (mutex_pre <> 0)) (PreH16 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_delete_manager_frame sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
|--
  “ (id_assumed_environment < 65536) ” 
  &&  “ (0 <= id_assumed_environment) ” 
  &&  “ (( &( "k_mutex_id_manager" ) ) <> 0) ” 
  &&  “ ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(mutex_addr) ) = mutex_pre) ” 
  &&  “ ((current.(mutex_id) ) = id_assumed_environment) ” 
  &&  “ ((current.(mutex_pending_addrs) ) = (@nil Z)) ” 
  &&  “ (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) ) ” 
  &&  “ (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) ) ” 
  &&  “ ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true) ” 
  &&  “ (Crtos_RTrans drained st_lock ) ” 
  &&  “ (mutex_delete_drained mutex_pre id_assumed_environment st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment ) ” 
  &&  “ (retval = KOK) ” 
  &&  “ (mutex_delete_drained mutex_pre id_assumed_environment drained ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ” 
  &&  “ (mutex_pre <> 0) ” 
  &&  “ (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment ) ”
  &&  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_delete_manager_frame sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
.

Definition _MutexDelete_partial_solve_wit_8 := _MutexDelete_partial_solve_wit_8_pure -> _MutexDelete_partial_solve_wit_8_aux.

Definition _MutexDelete_partial_solve_wit_9_pure := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (retval_2: Z) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (idnode: Z) (PreH1 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH2 : (idmanager_contains (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) id_assumed_environment idnode )) (PreH3 : (idnode <> 0)) (PreH4 : (&((idnode)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH6 : ((current.(mutex_addr) ) = mutex_pre)) (PreH7 : ((current.(mutex_id) ) = id_assumed_environment)) (PreH8 : ((current.(mutex_pending_addrs) ) = (@nil Z))) (PreH9 : (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) )) (PreH10 : (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) )) (PreH11 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH12 : (Crtos_RTrans drained st_lock )) (PreH13 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH15 : (retval = KOK)) (PreH16 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH19 : (mutex_pre <> 0)) (PreH20 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (idmanager_remove ((mutex_manager_stable ((os_mutex_stable (sg_assumed_environment))))) ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) ( &( "k_mutex_id_manager" ) ) )
  **  ((&((idnode)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  (mutex_delete_manager_frame sg_assumed_environment st_lock )
  **  ((( &( "delete_mutex_id" ) )) # UShort  |-> id_assumed_environment)
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_2)
  **  ((( &( "mutex" ) )) # Ptr  |-> mutex_pre)
|--
  “ ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(mutex_addr) ) = mutex_pre) ”
.

Definition _MutexDelete_partial_solve_wit_9_aux := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (idnode: Z) (PreH1 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH2 : (idmanager_contains (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) id_assumed_environment idnode )) (PreH3 : (idnode <> 0)) (PreH4 : (&((idnode)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH6 : ((current.(mutex_addr) ) = mutex_pre)) (PreH7 : ((current.(mutex_id) ) = id_assumed_environment)) (PreH8 : ((current.(mutex_pending_addrs) ) = (@nil Z))) (PreH9 : (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) )) (PreH10 : (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) )) (PreH11 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH12 : (Crtos_RTrans drained st_lock )) (PreH13 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH15 : (retval = KOK)) (PreH16 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH19 : (mutex_pre <> 0)) (PreH20 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (idmanager_remove ((mutex_manager_stable ((os_mutex_stable (sg_assumed_environment))))) ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) ( &( "k_mutex_id_manager" ) ) )
  **  ((&((idnode)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  (mutex_delete_manager_frame sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
|--
  “ ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(mutex_addr) ) = mutex_pre) ” 
  &&  “ ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true) ” 
  &&  “ (idmanager_contains (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) id_assumed_environment idnode ) ” 
  &&  “ (idnode <> 0) ” 
  &&  “ (&((idnode)  # "IdNode" ->ₛ "link") <> 0) ” 
  &&  “ ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(mutex_addr) ) = mutex_pre) ” 
  &&  “ ((current.(mutex_id) ) = id_assumed_environment) ” 
  &&  “ ((current.(mutex_pending_addrs) ) = (@nil Z)) ” 
  &&  “ (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) ) ” 
  &&  “ (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) ) ” 
  &&  “ ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true) ” 
  &&  “ (Crtos_RTrans drained st_lock ) ” 
  &&  “ (mutex_delete_drained mutex_pre id_assumed_environment st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment ) ” 
  &&  “ (retval = KOK) ” 
  &&  “ (mutex_delete_drained mutex_pre id_assumed_environment drained ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ” 
  &&  “ (mutex_pre <> 0) ” 
  &&  “ (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment ) ”
  &&  (mutex_delete_manager_frame sg_assumed_environment st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (idmanager_remove ((mutex_manager_stable ((os_mutex_stable (sg_assumed_environment))))) ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) ( &( "k_mutex_id_manager" ) ) )
  **  ((&((idnode)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  (InsideCritical sg_assumed_environment st_lock )
.

Definition _MutexDelete_partial_solve_wit_9 := _MutexDelete_partial_solve_wit_9_pure -> _MutexDelete_partial_solve_wit_9_aux.

Definition _MutexDelete_partial_solve_wit_10_pure := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (retval_2: Z) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (PreH1 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = false)) (PreH2 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH3 : ((current.(mutex_addr) ) = mutex_pre)) (PreH4 : ((current.(mutex_id) ) = id_assumed_environment)) (PreH5 : ((current.(mutex_pending_addrs) ) = (@nil Z))) (PreH6 : (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) )) (PreH7 : (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) )) (PreH8 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH9 : (Crtos_RTrans drained st_lock )) (PreH10 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH12 : (retval = KOK)) (PreH13 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH16 : (mutex_pre <> 0)) (PreH17 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_delete_manager_frame sg_assumed_environment st_lock )
  **  ((( &( "delete_mutex_id" ) )) # UShort  |-> id_assumed_environment)
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "lock" ) )) # Int  |-> retval_2)
  **  ((( &( "mutex" ) )) # Ptr  |-> mutex_pre)
|--
  “ ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(mutex_addr) ) = mutex_pre) ”
.

Definition _MutexDelete_partial_solve_wit_10_aux := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (PreH1 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = false)) (PreH2 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH3 : ((current.(mutex_addr) ) = mutex_pre)) (PreH4 : ((current.(mutex_id) ) = id_assumed_environment)) (PreH5 : ((current.(mutex_pending_addrs) ) = (@nil Z))) (PreH6 : (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) )) (PreH7 : (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) )) (PreH8 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH9 : (Crtos_RTrans drained st_lock )) (PreH10 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH12 : (retval = KOK)) (PreH13 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH16 : (mutex_pre <> 0)) (PreH17 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_delete_manager_frame sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
|--
  “ ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(mutex_addr) ) = mutex_pre) ” 
  &&  “ ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = false) ” 
  &&  “ ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(mutex_addr) ) = mutex_pre) ” 
  &&  “ ((current.(mutex_id) ) = id_assumed_environment) ” 
  &&  “ ((current.(mutex_pending_addrs) ) = (@nil Z)) ” 
  &&  “ (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) ) ” 
  &&  “ (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) ) ” 
  &&  “ ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true) ” 
  &&  “ (Crtos_RTrans drained st_lock ) ” 
  &&  “ (mutex_delete_drained mutex_pre id_assumed_environment st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment ) ” 
  &&  “ (retval = KOK) ” 
  &&  “ (mutex_delete_drained mutex_pre id_assumed_environment drained ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ” 
  &&  “ (mutex_pre <> 0) ” 
  &&  “ (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment ) ”
  &&  (mutex_delete_manager_frame sg_assumed_environment st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (InsideCritical sg_assumed_environment st_lock )
.

Definition _MutexDelete_partial_solve_wit_10 := _MutexDelete_partial_solve_wit_10_pure -> _MutexDelete_partial_solve_wit_10_aux.

Definition _MutexDelete_partial_solve_wit_11 := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (PreH1 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(mutex_addr) ) = mutex_pre)) (PreH3 : (mutex_context (os_mutex_stable (sg_assumed_environment)) )) (PreH4 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = false)) (PreH5 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH6 : ((current.(mutex_addr) ) = mutex_pre)) (PreH7 : ((current.(mutex_id) ) = id_assumed_environment)) (PreH8 : ((current.(mutex_pending_addrs) ) = (@nil Z))) (PreH9 : (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) )) (PreH10 : (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) )) (PreH11 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH12 : (Crtos_RTrans drained st_lock )) (PreH13 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH15 : (retval = KOK)) (PreH16 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH19 : (mutex_pre <> 0)) (PreH20 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (mutex_create_frame sg_assumed_environment st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))))) ( &( "k_mutex_list" ) ) (app ((map (mutex_link_node) (prefix))) ((cons ((Build_DL_Node (current) (&((mutex_pre)  # "Mutex" ->ₛ "link")))) ((map (mutex_link_node) (suffix)))))) )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (InsideCritical sg_assumed_environment st_lock )
|--
  “ ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(mutex_addr) ) = mutex_pre) ” 
  &&  “ (mutex_context (os_mutex_stable (sg_assumed_environment)) ) ” 
  &&  “ ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = false) ” 
  &&  “ ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(mutex_addr) ) = mutex_pre) ” 
  &&  “ ((current.(mutex_id) ) = id_assumed_environment) ” 
  &&  “ ((current.(mutex_pending_addrs) ) = (@nil Z)) ” 
  &&  “ (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) ) ” 
  &&  “ (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) ) ” 
  &&  “ ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true) ” 
  &&  “ (Crtos_RTrans drained st_lock ) ” 
  &&  “ (mutex_delete_drained mutex_pre id_assumed_environment st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment ) ” 
  &&  “ (retval = KOK) ” 
  &&  “ (mutex_delete_drained mutex_pre id_assumed_environment drained ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ” 
  &&  “ (mutex_pre <> 0) ” 
  &&  “ (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment ) ”
  &&  (store_dll (store_mutex ((pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))))) ( &( "k_mutex_list" ) ) (app ((map (mutex_link_node) (prefix))) ((cons ((Build_DL_Node (current) (&((mutex_pre)  # "Mutex" ->ₛ "link")))) ((map (mutex_link_node) (suffix)))))) )
  **  (mutex_create_frame sg_assumed_environment st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (InsideCritical sg_assumed_environment st_lock )
.

Definition _MutexDelete_partial_solve_wit_12 := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (drained: VarGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (idnode: Z) (PreH1 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(mutex_addr) ) = mutex_pre)) (PreH3 : (mutex_context (os_mutex_stable (sg_assumed_environment)) )) (PreH4 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH5 : (idmanager_contains (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) id_assumed_environment idnode )) (PreH6 : (idnode <> 0)) (PreH7 : (&((idnode)  # "IdNode" ->ₛ "link") <> 0)) (PreH8 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH9 : ((current.(mutex_addr) ) = mutex_pre)) (PreH10 : ((current.(mutex_id) ) = id_assumed_environment)) (PreH11 : ((current.(mutex_pending_addrs) ) = (@nil Z))) (PreH12 : (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) )) (PreH13 : (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) )) (PreH14 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true)) (PreH15 : (Crtos_RTrans drained st_lock )) (PreH16 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )) (PreH18 : (retval = KOK)) (PreH19 : (mutex_delete_drained mutex_pre id_assumed_environment drained )) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) (PreH22 : (mutex_pre <> 0)) (PreH23 : (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment )) (PreH24 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  (mutex_create_frame sg_assumed_environment st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))))) ( &( "k_mutex_list" ) ) (app ((map (mutex_link_node) (prefix))) ((cons ((Build_DL_Node (current) (&((mutex_pre)  # "Mutex" ->ₛ "link")))) ((map (mutex_link_node) (suffix)))))) )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (idmanager_remove ((mutex_manager_stable ((os_mutex_stable (sg_assumed_environment))))) ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) ( &( "k_mutex_id_manager" ) ) )
  **  ((&((idnode)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  (InsideCritical sg_assumed_environment st_lock )
|--
  “ ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(mutex_addr) ) = mutex_pre) ” 
  &&  “ (mutex_context (os_mutex_stable (sg_assumed_environment)) ) ” 
  &&  “ ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true) ” 
  &&  “ (idmanager_contains (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) id_assumed_environment idnode ) ” 
  &&  “ (idnode <> 0) ” 
  &&  “ (&((idnode)  # "IdNode" ->ₛ "link") <> 0) ” 
  &&  “ ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(mutex_addr) ) = mutex_pre) ” 
  &&  “ ((current.(mutex_id) ) = id_assumed_environment) ” 
  &&  “ ((current.(mutex_pending_addrs) ) = (@nil Z)) ” 
  &&  “ (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) ) ” 
  &&  “ (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) ) ” 
  &&  “ ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true) ” 
  &&  “ (Crtos_RTrans drained st_lock ) ” 
  &&  “ (mutex_delete_drained mutex_pre id_assumed_environment st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment ) ” 
  &&  “ (retval = KOK) ” 
  &&  “ (mutex_delete_drained mutex_pre id_assumed_environment drained ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ” 
  &&  “ (mutex_pre <> 0) ” 
  &&  “ (mutex_delete_live mutex_pre id_assumed_environment before_assumed_environment ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment ) ”
  &&  (store_dll (store_mutex ((pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))))) ( &( "k_mutex_list" ) ) (app ((map (mutex_link_node) (prefix))) ((cons ((Build_DL_Node (current) (&((mutex_pre)  # "Mutex" ->ₛ "link")))) ((map (mutex_link_node) (suffix)))))) )
  **  (mutex_create_frame sg_assumed_environment st_lock )
  **  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (idmanager_remove ((mutex_manager_stable ((os_mutex_stable (sg_assumed_environment))))) ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) ( &( "k_mutex_id_manager" ) ) )
  **  ((&((idnode)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  (InsideCritical sg_assumed_environment st_lock )
.

Definition _MutexDelete_partial_solve_wit_13_pure := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (after: VarGlobalState) (saved_lock: Z) (PreH1 : (mutex_pre = (current.(mutex_addr) ))) (PreH2 : (after = (replace_mutexes ((mutex_delete_unpublish (mutex_pre) ((os_mutexes (st_lock))))) (st_lock)))) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_assumed_environment )) (PreH4 : (Crtos_GTrans st_lock after )) ,
  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "mutex" ) )) # Ptr  |-> mutex_pre)
  **  ((( &( "delete_mutex_id" ) )) # UShort  |-> id_assumed_environment)
  **  (InsideCritical sg_assumed_environment st_lock )
  **  (os_inv sg_assumed_environment after )
  **  (MutexRetired current )
|--
  “ (Crtos_GTrans st_lock after ) ”
.

Definition _MutexDelete_partial_solve_wit_13_aux := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (after: VarGlobalState) (PreH1 : (mutex_pre = (current.(mutex_addr) ))) (PreH2 : (after = (replace_mutexes ((mutex_delete_unpublish (mutex_pre) ((os_mutexes (st_lock))))) (st_lock)))) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_assumed_environment )) (PreH4 : (Crtos_GTrans st_lock after )) ,
  (InsideCritical sg_assumed_environment st_lock )
  **  (os_inv sg_assumed_environment after )
  **  (MutexRetired current )
|--
  “ (Crtos_GTrans st_lock after ) ” 
  &&  “ (mutex_pre = (current.(mutex_addr) )) ” 
  &&  “ (after = (replace_mutexes ((mutex_delete_unpublish (mutex_pre) ((os_mutexes (st_lock))))) (st_lock))) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_assumed_environment ) ” 
  &&  “ (Crtos_GTrans st_lock after ) ”
  &&  (InsideCritical sg_assumed_environment st_lock )
  **  (os_inv sg_assumed_environment after )
  **  (MutexRetired current )
.

Definition _MutexDelete_partial_solve_wit_13 := _MutexDelete_partial_solve_wit_13_pure -> _MutexDelete_partial_solve_wit_13_aux.

Definition _MutexDelete_partial_solve_wit_14 := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (after: VarGlobalState) (PreH1 : (mutex_pre = (current.(mutex_addr) ))) (PreH2 : (after = (replace_mutexes ((mutex_delete_unpublish (mutex_pre) ((os_mutexes (st_lock))))) (st_lock)))) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_assumed_environment )) (PreH4 : (Crtos_GTrans st_lock after )) ,
  (OutsideCritical sg_assumed_environment after )
  **  (MutexRetired current )
|--
  “ (mutex_pre = (current.(mutex_addr) )) ” 
  &&  “ (after = (replace_mutexes ((mutex_delete_unpublish (mutex_pre) ((os_mutexes (st_lock))))) (st_lock))) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_assumed_environment ) ” 
  &&  “ (Crtos_GTrans st_lock after ) ”
  &&  (MutexRetired current )
  **  (OutsideCritical sg_assumed_environment after )
.

Definition _MutexDelete_partial_solve_wit_15 := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (after: VarGlobalState) (PreH1 : (mutex_pre = (current.(mutex_addr) ))) (PreH2 : (after = (replace_mutexes ((mutex_delete_unpublish (mutex_pre) ((os_mutexes (st_lock))))) (st_lock)))) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_assumed_environment )) (PreH4 : (Crtos_GTrans st_lock after )) ,
  (MutexRaw (current.(mutex_addr) ) )
  **  (OutsideCritical sg_assumed_environment after )
|--
  “ (mutex_pre = (current.(mutex_addr) )) ” 
  &&  “ (after = (replace_mutexes ((mutex_delete_unpublish (mutex_pre) ((os_mutexes (st_lock))))) (st_lock))) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_assumed_environment ) ” 
  &&  “ (Crtos_GTrans st_lock after ) ”
  &&  (MutexRaw mutex_pre )
  **  (OutsideCritical sg_assumed_environment after )
.

Definition _MutexDelete_which_implies_wit_1 := 
(
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ”
  &&  emp
) \/
(
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) ) ”
  &&  emp
).

Definition _MutexDelete_which_implies_wit_1_split_goal_1 := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (before_assumed_environment: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete_object (mutex_pre) (id_assumed_environment)) X_assumed_environment )) ,
  ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_resume_all (mutex_pre) (id_assumed_environment)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )
.

Definition _MutexDelete_which_implies_wit_2 := 
(
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (drained: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) ,
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment ) ”
  &&  emp
) \/
(
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (drained: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) ,
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment ) ”
  &&  emp
).

Definition _MutexDelete_which_implies_wit_2_split_goal_1 := 
forall (mutex_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_assumed_environment: Z) (drained: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (mutex_delete_after_resume (mutex_pre) (id_assumed_environment) (X_assumed_environment)) )) ,
  ( monadesafe_lib.safeExec  (LastSeen (drained)) (abs_mutex_retire (mutex_pre) (id_assumed_environment)) X_assumed_environment )
.

Definition _MutexDelete_which_implies_wit_3 := 
(
forall (mutex_pre: Z) (id_assumed_environment: Z) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (PreH1 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) ,
  (os_inv sg_assumed_environment st_lock )
|--
  EX (prefix: (@list MutexAbs))  (current: MutexAbs)  (suffix: (@list MutexAbs)) ,
  “ ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(mutex_addr) ) = mutex_pre) ” 
  &&  “ ((current.(mutex_id) ) = id_assumed_environment) ” 
  &&  “ ((current.(mutex_pending_addrs) ) = (@nil Z)) ” 
  &&  “ (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) ) ” 
  &&  “ (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) ) ” 
  &&  “ ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true) ”
  &&  ((&((mutex_pre)  # "Mutex" ->ₛ "id" .ₛ "id")) # UShort  |-> id_assumed_environment)
  **  (mutex_delete_id_restore sg_assumed_environment st_lock mutex_pre id_assumed_environment )
) \/
(
forall (mutex_pre: Z) (id_assumed_environment: Z) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (PreH1 : (mutex_delete_drained mutex_pre id_assumed_environment st_lock )) ,
  (os_inv sg_assumed_environment st_lock )
|--
  EX (prefix: (@list MutexAbs))  (current: MutexAbs)  (suffix: (@list MutexAbs)) ,
  “ ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(mutex_addr) ) = mutex_pre) ” 
  &&  “ ((current.(mutex_id) ) = id_assumed_environment) ” 
  &&  “ ((current.(mutex_pending_addrs) ) = (@nil Z)) ” 
  &&  “ (NoDup (map (mutex_addr) ((os_mutexes (st_lock)))) ) ” 
  &&  “ (NoDup (map (mutex_id) ((os_mutexes (st_lock)))) ) ” 
  &&  “ ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) (id_assumed_environment)) = true) ”
  &&  ((&((mutex_pre)  # "Mutex" ->ₛ "id" .ₛ "id")) # UShort  |-> id_assumed_environment)
  **  (mutex_delete_id_restore sg_assumed_environment st_lock mutex_pre id_assumed_environment )
).

Definition _MutexDelete_which_implies_wit_4 := 
(
forall (mutex_pre: Z) (id_assumed_environment: Z) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) ,
  ((&((mutex_pre)  # "Mutex" ->ₛ "id" .ₛ "id")) # UShort  |-> id_assumed_environment)
  **  (mutex_delete_id_restore sg_assumed_environment st_lock mutex_pre id_assumed_environment )
|--
  (os_inv sg_assumed_environment st_lock )
) \/
(
forall (mutex_pre: Z) (id_assumed_environment: Z) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) ,
  ((&((mutex_pre)  # "Mutex" ->ₛ "id" .ₛ "id")) # UShort  |-> id_assumed_environment)
  **  (mutex_delete_id_restore sg_assumed_environment st_lock mutex_pre id_assumed_environment )
|--
  (os_inv sg_assumed_environment st_lock )
).

Definition _MutexDelete_which_implies_wit_4_split_goal_spatial := 
forall (mutex_pre: Z) (id_assumed_environment: Z) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) ,
  ((&((mutex_pre)  # "Mutex" ->ₛ "id" .ₛ "id")) # UShort  |-> id_assumed_environment)
  **  (mutex_delete_id_restore sg_assumed_environment st_lock mutex_pre id_assumed_environment )
|--
  (os_inv sg_assumed_environment st_lock )
.

Definition _MutexDelete_which_implies_wit_5 := 
(
forall (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) ,
  (os_inv sg_assumed_environment st_lock )
|--
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_delete_manager_frame sg_assumed_environment st_lock )
) \/
(
forall (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) ,
  (os_inv sg_assumed_environment st_lock )
|--
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_delete_manager_frame sg_assumed_environment st_lock )
).

Definition _MutexDelete_which_implies_wit_5_split_goal_spatial := 
forall (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) ,
  (os_inv sg_assumed_environment st_lock )
|--
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_delete_manager_frame sg_assumed_environment st_lock )
.

Definition _MutexDelete_which_implies_wit_6 := 
(
forall (mutex_pre: Z) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (PreH1 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(mutex_addr) ) = mutex_pre)) ,
  (mutex_delete_manager_frame sg_assumed_environment st_lock )
|--
  “ ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix))))) ” 
  &&  “ ((current.(mutex_addr) ) = mutex_pre) ” 
  &&  “ (mutex_context (os_mutex_stable (sg_assumed_environment)) ) ”
  &&  (mutex_create_frame sg_assumed_environment st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))))) ( &( "k_mutex_list" ) ) (app ((map (mutex_link_node) (prefix))) ((cons ((Build_DL_Node (current) (&((mutex_pre)  # "Mutex" ->ₛ "link")))) ((map (mutex_link_node) (suffix)))))) )
) \/
(
forall (mutex_pre: Z) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (PreH1 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(mutex_addr) ) = mutex_pre)) ,
  (mutex_delete_manager_frame sg_assumed_environment st_lock )
|--
  “ (mutex_context (os_mutex_stable (sg_assumed_environment)) ) ”
  &&  (mutex_create_frame sg_assumed_environment st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))))) ( &( "k_mutex_list" ) ) (app ((map (mutex_link_node) (prefix))) ((cons ((Build_DL_Node (current) (&((mutex_pre)  # "Mutex" ->ₛ "link")))) ((map (mutex_link_node) (suffix)))))) )
).

Definition _MutexDelete_which_implies_wit_6_split_goal_1 := 
forall (mutex_pre: Z) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (PreH1 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(mutex_addr) ) = mutex_pre)) ,
  (mutex_delete_manager_frame sg_assumed_environment st_lock )
|--
  “ (mutex_context (os_mutex_stable (sg_assumed_environment)) ) ”
.

Definition _MutexDelete_which_implies_wit_6_split_goal_spatial := 
forall (mutex_pre: Z) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (current: MutexAbs) (prefix: (@list MutexAbs)) (suffix: (@list MutexAbs)) (PreH1 : ((os_mutexes (st_lock)) = (app (prefix) ((cons (current) (suffix)))))) (PreH2 : ((current.(mutex_addr) ) = mutex_pre)) ,
  (mutex_delete_manager_frame sg_assumed_environment st_lock )
|--
  (mutex_create_frame sg_assumed_environment st_lock )
  **  (store_dll (store_mutex ((pure_suspend_sched_link (((st_lock.(os_tasks) ).(task_desc_map) ))))) ( &( "k_mutex_list" ) ) (app ((map (mutex_link_node) (prefix))) ((cons ((Build_DL_Node (current) (&((mutex_pre)  # "Mutex" ->ₛ "link")))) ((map (mutex_link_node) (suffix)))))) )
.

Definition _MutexDelete_which_implies_wit_7 := 
(
forall (current: MutexAbs) ,
  (MutexRetired current )
|--
  (MutexRaw (current.(mutex_addr) ) )
) \/
(
forall (current: MutexAbs) ,
  (MutexRetired current )
|--
  (MutexRaw (current.(mutex_addr) ) )
).

Definition _MutexDelete_which_implies_wit_7_split_goal_spatial := 
forall (current: MutexAbs) ,
  (MutexRetired current )
|--
  (MutexRaw (current.(mutex_addr) ) )
.

Module Type VC_Correct.


Axiom proof_of__MutexDelete_safety_wit_1 : _MutexDelete_safety_wit_1.
Axiom proof_of__MutexDelete_safety_wit_2 : _MutexDelete_safety_wit_2.
Axiom proof_of__MutexDelete_safety_wit_3 : _MutexDelete_safety_wit_3.
Axiom proof_of__MutexDelete_entail_wit_1 : _MutexDelete_entail_wit_1.
Axiom proof_of__MutexDelete_entail_wit_2 : _MutexDelete_entail_wit_2.
Axiom proof_of__MutexDelete_entail_wit_3_1 : _MutexDelete_entail_wit_3_1.
Axiom proof_of__MutexDelete_entail_wit_3_2 : _MutexDelete_entail_wit_3_2.
Axiom proof_of__MutexDelete_return_wit_1 : _MutexDelete_return_wit_1.
Axiom proof_of__MutexDelete_partial_solve_wit_1_pure : _MutexDelete_partial_solve_wit_1_pure.
Axiom proof_of__MutexDelete_partial_solve_wit_1 : _MutexDelete_partial_solve_wit_1.
Axiom proof_of__MutexDelete_partial_solve_wit_2_pure : _MutexDelete_partial_solve_wit_2_pure.
Axiom proof_of__MutexDelete_partial_solve_wit_2 : _MutexDelete_partial_solve_wit_2.
Axiom proof_of__MutexDelete_partial_solve_wit_3_pure : _MutexDelete_partial_solve_wit_3_pure.
Axiom proof_of__MutexDelete_partial_solve_wit_3 : _MutexDelete_partial_solve_wit_3.
Axiom proof_of__MutexDelete_partial_solve_wit_4_pure : _MutexDelete_partial_solve_wit_4_pure.
Axiom proof_of__MutexDelete_partial_solve_wit_4 : _MutexDelete_partial_solve_wit_4.
Axiom proof_of__MutexDelete_partial_solve_wit_5_pure : _MutexDelete_partial_solve_wit_5_pure.
Axiom proof_of__MutexDelete_partial_solve_wit_5 : _MutexDelete_partial_solve_wit_5.
Axiom proof_of__MutexDelete_partial_solve_wit_6 : _MutexDelete_partial_solve_wit_6.
Axiom proof_of__MutexDelete_partial_solve_wit_7 : _MutexDelete_partial_solve_wit_7.
Axiom proof_of__MutexDelete_partial_solve_wit_8_pure : _MutexDelete_partial_solve_wit_8_pure.
Axiom proof_of__MutexDelete_partial_solve_wit_8 : _MutexDelete_partial_solve_wit_8.
Axiom proof_of__MutexDelete_partial_solve_wit_9_pure : _MutexDelete_partial_solve_wit_9_pure.
Axiom proof_of__MutexDelete_partial_solve_wit_9 : _MutexDelete_partial_solve_wit_9.
Axiom proof_of__MutexDelete_partial_solve_wit_10_pure : _MutexDelete_partial_solve_wit_10_pure.
Axiom proof_of__MutexDelete_partial_solve_wit_10 : _MutexDelete_partial_solve_wit_10.
Axiom proof_of__MutexDelete_partial_solve_wit_11 : _MutexDelete_partial_solve_wit_11.
Axiom proof_of__MutexDelete_partial_solve_wit_12 : _MutexDelete_partial_solve_wit_12.
Axiom proof_of__MutexDelete_partial_solve_wit_13_pure : _MutexDelete_partial_solve_wit_13_pure.
Axiom proof_of__MutexDelete_partial_solve_wit_13 : _MutexDelete_partial_solve_wit_13.
Axiom proof_of__MutexDelete_partial_solve_wit_14 : _MutexDelete_partial_solve_wit_14.
Axiom proof_of__MutexDelete_partial_solve_wit_15 : _MutexDelete_partial_solve_wit_15.
Axiom proof_of__MutexDelete_which_implies_wit_1 : _MutexDelete_which_implies_wit_1.
Axiom proof_of__MutexDelete_which_implies_wit_2 : _MutexDelete_which_implies_wit_2.
Axiom proof_of__MutexDelete_which_implies_wit_3 : _MutexDelete_which_implies_wit_3.
Axiom proof_of__MutexDelete_which_implies_wit_4 : _MutexDelete_which_implies_wit_4.
Axiom proof_of__MutexDelete_which_implies_wit_5 : _MutexDelete_which_implies_wit_5.
Axiom proof_of__MutexDelete_which_implies_wit_6 : _MutexDelete_which_implies_wit_6.
Axiom proof_of__MutexDelete_which_implies_wit_7 : _MutexDelete_which_implies_wit_7.

End VC_Correct.
