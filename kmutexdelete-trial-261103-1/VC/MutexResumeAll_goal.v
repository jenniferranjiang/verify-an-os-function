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
Require Import KMutexDeleteProof.VC.MutexResumeAll_lib.
Local Open Scope sac.

(*----- Function LinklistResumeAll -----*)

Definition LinklistResumeAll_safety_wit_1 := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (PreH1 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH2 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc before_mutex_waiters_oc )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  ((( &( "lock" ) )) # UInt  |->_)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  (OutsideCritical sg_mutex_waiters_oc before_mutex_waiters_oc )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition LinklistResumeAll_safety_wit_2 := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (PreH1 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH2 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc before_mutex_waiters_oc )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "lock" ) )) # UInt  |-> 0)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  (OutsideCritical sg_mutex_waiters_oc before_mutex_waiters_oc )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition LinklistResumeAll_safety_wit_3 := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (PreH1 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH2 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc before_mutex_waiters_oc )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  ((( &( "node" ) )) # Ptr  |->_)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # UInt  |-> 0)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  (OutsideCritical sg_mutex_waiters_oc before_mutex_waiters_oc )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition LinklistResumeAll_safety_wit_4 := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (PreH1 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH2 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc before_mutex_waiters_oc )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  ((( &( "node" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # UInt  |-> 0)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  (OutsideCritical sg_mutex_waiters_oc before_mutex_waiters_oc )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition LinklistResumeAll_safety_wit_5 := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (PreH1 : (list_pre = 0)) (PreH2 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH3 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc before_mutex_waiters_oc )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |->_)
  **  ((( &( "lock" ) )) # UInt  |->_)
  **  (OutsideCritical sg_mutex_waiters_oc before_mutex_waiters_oc )
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition LinklistResumeAll_safety_wit_6 := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (remaining: (@list Z)) (current: VarGlobalState) (saved_lock: Z) (PreH1 : (list_pre <> 0)) (PreH2 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH3 : (In original (os_mutexes (st_lock)) )) (PreH4 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH5 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH6 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH7 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH8 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH9 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH10 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |->_)
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
  **  (os_inv sg_mutex_waiters_oc current )
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition LinklistResumeAll_safety_wit_7 := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (next: Z) (PreH1 : (next <> list_pre)) (PreH2 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH3 : (list_pre <> 0)) (PreH4 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH5 : (remaining = (@nil Z))) (PreH6 : (next = list_pre)) (PreH7 : (list_pre <> 0)) (PreH8 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH9 : (In original (os_mutexes (st_lock)) )) (PreH10 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH11 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH12 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH13 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH14 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH15 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH16 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (os_inv sg_mutex_waiters_oc current )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  “ False ”
.

Definition LinklistResumeAll_safety_wit_8 := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (first: Z) (tail: (@list Z)) (next: Z) (PreH1 : (next = list_pre)) (PreH2 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH3 : (list_pre <> 0)) (PreH4 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH5 : (remaining = (cons (first) (tail)))) (PreH6 : (next = (sched_link_of (first)))) (PreH7 : (next <> list_pre)) (PreH8 : (list_pre <> 0)) (PreH9 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH10 : (In original (os_mutexes (st_lock)) )) (PreH11 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH12 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH13 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH14 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH15 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH16 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH17 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (os_inv sg_mutex_waiters_oc current )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  “ False ”
.

Definition LinklistResumeAll_safety_wit_9 := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH2 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH3 : (retval = target)) (PreH4 : (addr_aligned retval ALIGN_SIZE )) (PreH5 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH6 : (remaining = (cons (target) (rest)))) (PreH7 : (next = (sched_link_of (target)))) (PreH8 : (addr_aligned target ALIGN_SIZE )) (PreH9 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH10 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH11 : (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH12 : (next <> list_pre)) (PreH13 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH14 : (list_pre <> 0)) (PreH15 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH16 : (remaining = (cons (target) (rest)))) (PreH17 : (next = (sched_link_of (target)))) (PreH18 : (next <> list_pre)) (PreH19 : (list_pre <> 0)) (PreH20 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH21 : (In original (os_mutexes (st_lock)) )) (PreH22 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH23 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH24 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH25 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH26 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH27 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH28 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH29 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (desc.(tdExstatus) ))
  **  (mutex_resume_exstatus_restore sg_mutex_waiters_oc marked target (-1) )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |-> retval)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  “ (1 <> (INT_MIN)) ”
.

Definition LinklistResumeAll_safety_wit_10 := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH2 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH3 : (retval = target)) (PreH4 : (addr_aligned retval ALIGN_SIZE )) (PreH5 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH6 : (remaining = (cons (target) (rest)))) (PreH7 : (next = (sched_link_of (target)))) (PreH8 : (addr_aligned target ALIGN_SIZE )) (PreH9 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH10 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH11 : (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH12 : (next <> list_pre)) (PreH13 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH14 : (list_pre <> 0)) (PreH15 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH16 : (remaining = (cons (target) (rest)))) (PreH17 : (next = (sched_link_of (target)))) (PreH18 : (next <> list_pre)) (PreH19 : (list_pre <> 0)) (PreH20 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH21 : (In original (os_mutexes (st_lock)) )) (PreH22 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH23 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH24 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH25 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH26 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH27 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH28 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH29 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (desc.(tdExstatus) ))
  **  (mutex_resume_exstatus_restore sg_mutex_waiters_oc marked target (-1) )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |-> retval)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition LinklistResumeAll_safety_wit_11 := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (next: Z) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (PreH1 : (mutex_delete_drained p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH2 : (Crtos_GTrans st_lock current )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (current)) ( MonadErr.ret  (tt)) X_mutex_waiters_oc )) (PreH4 : (next = list_pre)) (PreH5 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH6 : (list_pre <> 0)) (PreH7 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH8 : (remaining = (@nil Z))) (PreH9 : (next = list_pre)) (PreH10 : (list_pre <> 0)) (PreH11 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH12 : (In original (os_mutexes (st_lock)) )) (PreH13 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH14 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH15 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH16 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH17 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH18 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH19 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (OutsideCritical sg_mutex_waiters_oc current )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |-> next)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition LinklistResumeAll_entail_wit_1 := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (PreH1 : (list_pre = 0)) (PreH2 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH3 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc before_mutex_waiters_oc )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  ((( &( "node" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # UInt  |-> 0)
  **  (OutsideCritical sg_mutex_waiters_oc before_mutex_waiters_oc )
|--
  “ (list_pre = 0) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc before_mutex_waiters_oc ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc ) ”
  &&  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |->_)
  **  ((( &( "lock" ) )) # UInt  |->_)
  **  (OutsideCritical sg_mutex_waiters_oc before_mutex_waiters_oc )
.

Definition LinklistResumeAll_entail_wit_2 := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (PreH1 : (list_pre = 0)) (PreH2 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH3 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc before_mutex_waiters_oc )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (OutsideCritical sg_mutex_waiters_oc before_mutex_waiters_oc )
|--
  “ (list_pre = 0) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc before_mutex_waiters_oc ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc ) ”
  &&  (OutsideCritical sg_mutex_waiters_oc before_mutex_waiters_oc )
.

Definition LinklistResumeAll_entail_wit_3 := 
(
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (PreH1 : (In original (os_mutexes (st_lock)) )) (PreH2 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH3 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH4 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH5 : (mutex_pending_nodes p_mutex_waiters_oc st_lock (map (sched_link_node) ((original.(mutex_pending_addrs) ))) )) (PreH6 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH7 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH8 : (list_pre <> 0)) (PreH9 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH10 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc before_mutex_waiters_oc )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (os_inv sg_mutex_waiters_oc st_lock )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
  **  ((( &( "node" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
|--
  EX (remaining: (@list Z))  (current: VarGlobalState) ,
  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_addr) ) = p_mutex_waiters_oc) ” 
  &&  “ ((original.(mutex_id) ) = id_mutex_waiters_oc) ” 
  &&  “ (Crtos_RTrans before_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current ) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc ) ”
  &&  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |->_)
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
  **  (os_inv sg_mutex_waiters_oc current )
) \/
(
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (PreH1 : (In original (os_mutexes (st_lock)) )) (PreH2 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH3 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH4 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH5 : (mutex_pending_nodes p_mutex_waiters_oc st_lock (map (sched_link_node) ((original.(mutex_pending_addrs) ))) )) (PreH6 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH7 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH8 : (list_pre <> 0)) (PreH9 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH10 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc before_mutex_waiters_oc )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  TT && emp 
|--
  EX (remaining: (@list Z)) ,
  “ (mutex_delete_live (original.(mutex_addr) ) (original.(mutex_id) ) st_lock ) ” 
  &&  “ (mutex_delete_live (original.(mutex_addr) ) (original.(mutex_id) ) st_lock ) ” 
  &&  “ (mutex_pending_nodes (original.(mutex_addr) ) st_lock (map (sched_link_node) (remaining)) ) ” 
  &&  “ (mutex_resume_remaining_effect (original.(mutex_addr) ) (original.(mutex_pending_addrs) ) st_lock remaining st_lock ) ”
  &&  emp
).

Definition LinklistResumeAll_entail_wit_4_1 := 
(
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current_2: VarGlobalState) (remaining_2: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (task_id: Z) (after: VarGlobalState) (desc_2: TaskDescriptorAbs) (task: Z) (retval_2: Z) (PreH1 : (task <> 0)) (PreH2 : (get_task_with_idnode_success sg_mutex_waiters_oc marked task_id task )) (PreH3 : (((marked.(os_tasks) ).(task_desc_map) (task)) = (Some (desc_2)))) (PreH4 : (((desc_2.(tdSchedMember) ).(tsmStat) ) <> TSK_SUSPEND)) (PreH5 : (retval_2 = (-1))) (PreH6 : (after = marked)) (PreH7 : (remaining_2 = (cons (target) (rest)))) (PreH8 : (mutex_pending_nodes p_mutex_waiters_oc current_2 (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH9 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current_2.(os_tasks) ).(task_desc_map) )))) (current_2)))) (PreH10 : (0 <= task_id)) (PreH11 : (task_id < 65536)) (PreH12 : (get_task_with_idnode_success sg_mutex_waiters_oc marked task_id target )) (PreH13 : (mutex_pending_nodes p_mutex_waiters_oc marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH14 : (((current_2.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH15 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current_2.(os_tasks) ).(task_desc_map) )))) (current_2)))) (PreH16 : (retval = target)) (PreH17 : (addr_aligned retval ALIGN_SIZE )) (PreH18 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH19 : (remaining_2 = (cons (target) (rest)))) (PreH20 : (next = (sched_link_of (target)))) (PreH21 : (addr_aligned target ALIGN_SIZE )) (PreH22 : (((current_2.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH23 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH24 : (mutex_pending_nodes p_mutex_waiters_oc current_2 (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH25 : (next <> list_pre)) (PreH26 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH27 : (list_pre <> 0)) (PreH28 : (mutex_pending_nodes p_mutex_waiters_oc current_2 (map (sched_link_node) (remaining_2)) )) (PreH29 : (remaining_2 = (cons (target) (rest)))) (PreH30 : (next = (sched_link_of (target)))) (PreH31 : (next <> list_pre)) (PreH32 : (list_pre <> 0)) (PreH33 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH34 : (In original (os_mutexes (st_lock)) )) (PreH35 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH36 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH37 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH38 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH39 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current_2 )) (PreH40 : (mutex_pending_nodes p_mutex_waiters_oc current_2 (map (sched_link_node) (remaining_2)) )) (PreH41 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining_2 current_2 )) (PreH42 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (os_inv sg_mutex_waiters_oc after )
  **  ((( &( "task" ) )) # Ptr  |-> retval)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  EX (remaining: (@list Z))  (current: VarGlobalState) ,
  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_addr) ) = p_mutex_waiters_oc) ” 
  &&  “ ((original.(mutex_id) ) = id_mutex_waiters_oc) ” 
  &&  “ (Crtos_RTrans before_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current ) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc ) ”
  &&  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |->_)
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
  **  (os_inv sg_mutex_waiters_oc current )
) \/
(
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current_2: VarGlobalState) (remaining_2: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (task_id: Z) (after: VarGlobalState) (desc_2: TaskDescriptorAbs) (task: Z) (retval_2: Z) (PreH1 : (task <> 0)) (PreH2 : (get_task_with_idnode_success sg_mutex_waiters_oc marked task_id task )) (PreH3 : (((marked.(os_tasks) ).(task_desc_map) (task)) = (Some (desc_2)))) (PreH4 : (((desc_2.(tdSchedMember) ).(tsmStat) ) <> TSK_SUSPEND)) (PreH5 : (retval_2 = (-1))) (PreH6 : (after = marked)) (PreH7 : (remaining_2 = (cons (target) (rest)))) (PreH8 : (mutex_pending_nodes p_mutex_waiters_oc current_2 (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH9 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current_2.(os_tasks) ).(task_desc_map) )))) (current_2)))) (PreH10 : (0 <= task_id)) (PreH11 : (task_id < 65536)) (PreH12 : (get_task_with_idnode_success sg_mutex_waiters_oc marked task_id target )) (PreH13 : (mutex_pending_nodes p_mutex_waiters_oc marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH14 : (((current_2.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH15 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current_2.(os_tasks) ).(task_desc_map) )))) (current_2)))) (PreH16 : (retval = target)) (PreH17 : (addr_aligned retval ALIGN_SIZE )) (PreH18 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH19 : (remaining_2 = (cons (target) (rest)))) (PreH20 : (next = (sched_link_of (target)))) (PreH21 : (addr_aligned target ALIGN_SIZE )) (PreH22 : (((current_2.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH23 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH24 : (mutex_pending_nodes p_mutex_waiters_oc current_2 (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH25 : (next <> list_pre)) (PreH26 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH27 : (list_pre <> 0)) (PreH28 : (mutex_pending_nodes p_mutex_waiters_oc current_2 (map (sched_link_node) (remaining_2)) )) (PreH29 : (remaining_2 = (cons (target) (rest)))) (PreH30 : (next = (sched_link_of (target)))) (PreH31 : (next <> list_pre)) (PreH32 : (list_pre <> 0)) (PreH33 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH34 : (In original (os_mutexes (st_lock)) )) (PreH35 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH36 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH37 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH38 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH39 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current_2 )) (PreH40 : (mutex_pending_nodes p_mutex_waiters_oc current_2 (map (sched_link_node) (remaining_2)) )) (PreH41 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining_2 current_2 )) (PreH42 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  TT && emp 
|--
  EX (remaining: (@list Z)) ,
  “ ((mutex_pending_head ((original.(mutex_addr) ))) <> 0) ” 
  &&  “ ((mutex_pending_head ((original.(mutex_addr) ))) = (mutex_pending_head ((original.(mutex_addr) )))) ” 
  &&  “ (mutex_delete_live (original.(mutex_addr) ) (original.(mutex_id) ) (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current_2.(os_tasks) ).(task_desc_map) )))) (current_2)) ) ” 
  &&  “ (mutex_pending_nodes (original.(mutex_addr) ) (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current_2.(os_tasks) ).(task_desc_map) )))) (current_2)) (map (sched_link_node) (remaining)) ) ” 
  &&  “ (mutex_resume_remaining_effect (original.(mutex_addr) ) (original.(mutex_pending_addrs) ) st_lock remaining (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current_2.(os_tasks) ).(task_desc_map) )))) (current_2)) ) ”
  &&  emp
).

Definition LinklistResumeAll_entail_wit_4_2 := 
(
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current_2: VarGlobalState) (remaining_2: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (task_id: Z) (after: VarGlobalState) (desc_2: TaskDescriptorAbs) (task: Z) (retval_2: Z) (PreH1 : (task <> 0)) (PreH2 : (get_task_with_idnode_success sg_mutex_waiters_oc marked task_id task )) (PreH3 : (((marked.(os_tasks) ).(task_desc_map) (task)) = (Some (desc_2)))) (PreH4 : (((desc_2.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH5 : (retval_2 = 0)) (PreH6 : (ktask_wakeup_step task desc_2 marked after )) (PreH7 : (remaining_2 = (cons (target) (rest)))) (PreH8 : (mutex_pending_nodes p_mutex_waiters_oc current_2 (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH9 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current_2.(os_tasks) ).(task_desc_map) )))) (current_2)))) (PreH10 : (0 <= task_id)) (PreH11 : (task_id < 65536)) (PreH12 : (get_task_with_idnode_success sg_mutex_waiters_oc marked task_id target )) (PreH13 : (mutex_pending_nodes p_mutex_waiters_oc marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH14 : (((current_2.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH15 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current_2.(os_tasks) ).(task_desc_map) )))) (current_2)))) (PreH16 : (retval = target)) (PreH17 : (addr_aligned retval ALIGN_SIZE )) (PreH18 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH19 : (remaining_2 = (cons (target) (rest)))) (PreH20 : (next = (sched_link_of (target)))) (PreH21 : (addr_aligned target ALIGN_SIZE )) (PreH22 : (((current_2.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH23 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH24 : (mutex_pending_nodes p_mutex_waiters_oc current_2 (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH25 : (next <> list_pre)) (PreH26 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH27 : (list_pre <> 0)) (PreH28 : (mutex_pending_nodes p_mutex_waiters_oc current_2 (map (sched_link_node) (remaining_2)) )) (PreH29 : (remaining_2 = (cons (target) (rest)))) (PreH30 : (next = (sched_link_of (target)))) (PreH31 : (next <> list_pre)) (PreH32 : (list_pre <> 0)) (PreH33 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH34 : (In original (os_mutexes (st_lock)) )) (PreH35 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH36 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH37 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH38 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH39 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current_2 )) (PreH40 : (mutex_pending_nodes p_mutex_waiters_oc current_2 (map (sched_link_node) (remaining_2)) )) (PreH41 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining_2 current_2 )) (PreH42 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (os_inv sg_mutex_waiters_oc after )
  **  ((( &( "task" ) )) # Ptr  |-> retval)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  EX (remaining: (@list Z))  (current: VarGlobalState) ,
  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_addr) ) = p_mutex_waiters_oc) ” 
  &&  “ ((original.(mutex_id) ) = id_mutex_waiters_oc) ” 
  &&  “ (Crtos_RTrans before_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current ) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc ) ”
  &&  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |->_)
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
  **  (os_inv sg_mutex_waiters_oc current )
) \/
(
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current_2: VarGlobalState) (remaining_2: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (task_id: Z) (after: VarGlobalState) (desc_2: TaskDescriptorAbs) (task: Z) (retval_2: Z) (PreH1 : (task <> 0)) (PreH2 : (get_task_with_idnode_success sg_mutex_waiters_oc marked task_id task )) (PreH3 : (((marked.(os_tasks) ).(task_desc_map) (task)) = (Some (desc_2)))) (PreH4 : (((desc_2.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH5 : (retval_2 = 0)) (PreH6 : (ktask_wakeup_step task desc_2 marked after )) (PreH7 : (remaining_2 = (cons (target) (rest)))) (PreH8 : (mutex_pending_nodes p_mutex_waiters_oc current_2 (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH9 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current_2.(os_tasks) ).(task_desc_map) )))) (current_2)))) (PreH10 : (0 <= task_id)) (PreH11 : (task_id < 65536)) (PreH12 : (get_task_with_idnode_success sg_mutex_waiters_oc marked task_id target )) (PreH13 : (mutex_pending_nodes p_mutex_waiters_oc marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH14 : (((current_2.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH15 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current_2.(os_tasks) ).(task_desc_map) )))) (current_2)))) (PreH16 : (retval = target)) (PreH17 : (addr_aligned retval ALIGN_SIZE )) (PreH18 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH19 : (remaining_2 = (cons (target) (rest)))) (PreH20 : (next = (sched_link_of (target)))) (PreH21 : (addr_aligned target ALIGN_SIZE )) (PreH22 : (((current_2.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH23 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH24 : (mutex_pending_nodes p_mutex_waiters_oc current_2 (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH25 : (next <> list_pre)) (PreH26 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH27 : (list_pre <> 0)) (PreH28 : (mutex_pending_nodes p_mutex_waiters_oc current_2 (map (sched_link_node) (remaining_2)) )) (PreH29 : (remaining_2 = (cons (target) (rest)))) (PreH30 : (next = (sched_link_of (target)))) (PreH31 : (next <> list_pre)) (PreH32 : (list_pre <> 0)) (PreH33 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH34 : (In original (os_mutexes (st_lock)) )) (PreH35 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH36 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH37 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH38 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH39 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current_2 )) (PreH40 : (mutex_pending_nodes p_mutex_waiters_oc current_2 (map (sched_link_node) (remaining_2)) )) (PreH41 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining_2 current_2 )) (PreH42 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  TT && emp 
|--
  EX (remaining: (@list Z)) ,
  “ ((mutex_pending_head ((original.(mutex_addr) ))) <> 0) ” 
  &&  “ ((mutex_pending_head ((original.(mutex_addr) ))) = (mutex_pending_head ((original.(mutex_addr) )))) ” 
  &&  “ (mutex_delete_live (original.(mutex_addr) ) (original.(mutex_id) ) after ) ” 
  &&  “ (mutex_pending_nodes (original.(mutex_addr) ) after (map (sched_link_node) (remaining)) ) ” 
  &&  “ (mutex_resume_remaining_effect (original.(mutex_addr) ) (original.(mutex_pending_addrs) ) st_lock remaining after ) ”
  &&  emp
).

Definition LinklistResumeAll_return_wit_1 := 
(
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (next: Z) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (mutex_delete_drained p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH2 : (Crtos_GTrans st_lock current )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (current)) ( MonadErr.ret  (tt)) X_mutex_waiters_oc )) (PreH4 : (next = list_pre)) (PreH5 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH6 : (list_pre <> 0)) (PreH7 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH8 : (remaining = (@nil Z))) (PreH9 : (next = list_pre)) (PreH10 : (list_pre <> 0)) (PreH11 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH12 : (In original (os_mutexes (st_lock)) )) (PreH13 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH14 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH15 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH16 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH17 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH18 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH19 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (OutsideCritical sg_mutex_waiters_oc current )
|--
  EX (after: VarGlobalState) ,
  “ (0 = KOK) ” 
  &&  “ (mutex_delete_drained p_mutex_waiters_oc id_mutex_waiters_oc after ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_mutex_waiters_oc ) ”
  &&  (OutsideCritical sg_mutex_waiters_oc after )
) \/
(
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (next: Z) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (mutex_delete_drained p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH2 : (Crtos_GTrans st_lock current )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (current)) ( MonadErr.ret  (tt)) X_mutex_waiters_oc )) (PreH4 : (next = list_pre)) (PreH5 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH6 : (list_pre <> 0)) (PreH7 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH8 : (remaining = (@nil Z))) (PreH9 : (next = list_pre)) (PreH10 : (list_pre <> 0)) (PreH11 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH12 : (In original (os_mutexes (st_lock)) )) (PreH13 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH14 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH15 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH16 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH17 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH18 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH19 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  TT && emp 
|--
  “ (0 = KOK) ”
  &&  emp
).

Definition LinklistResumeAll_return_wit_1_split_goal_1 := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (next: Z) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (mutex_delete_drained p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH2 : (Crtos_GTrans st_lock current )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (current)) ( MonadErr.ret  (tt)) X_mutex_waiters_oc )) (PreH4 : (next = list_pre)) (PreH5 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH6 : (list_pre <> 0)) (PreH7 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH8 : (remaining = (@nil Z))) (PreH9 : (next = list_pre)) (PreH10 : (list_pre <> 0)) (PreH11 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH12 : (In original (os_mutexes (st_lock)) )) (PreH13 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH14 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH15 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH16 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH17 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH18 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH19 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (0 = KOK)
.

Definition LinklistResumeAll_partial_solve_wit_1_pure := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (PreH1 : (list_pre <> 0)) (PreH2 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH3 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc before_mutex_waiters_oc )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  ((( &( "node" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # UInt  |-> 0)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  (OutsideCritical sg_mutex_waiters_oc before_mutex_waiters_oc )
|--
  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc before_mutex_waiters_oc ) ”
.

Definition LinklistResumeAll_partial_solve_wit_1_aux := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (PreH1 : (list_pre <> 0)) (PreH2 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH3 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc before_mutex_waiters_oc )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (OutsideCritical sg_mutex_waiters_oc before_mutex_waiters_oc )
|--
  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc before_mutex_waiters_oc ) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc before_mutex_waiters_oc ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc ) ”
  &&  (OutsideCritical sg_mutex_waiters_oc before_mutex_waiters_oc )
.

Definition LinklistResumeAll_partial_solve_wit_1 := LinklistResumeAll_partial_solve_wit_1_pure -> LinklistResumeAll_partial_solve_wit_1_aux.

Definition LinklistResumeAll_partial_solve_wit_2_pure := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (PreH1 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH2 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH3 : (list_pre <> 0)) (PreH4 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH5 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc before_mutex_waiters_oc )) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (InsideCritical sg_mutex_waiters_oc st_lock )
  **  (os_inv sg_mutex_waiters_oc st_lock )
  **  ((( &( "node" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # UInt  |-> (unsigned_last_nbits (retval) (32)))
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
|--
  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock ) ”
.

Definition LinklistResumeAll_partial_solve_wit_2_aux := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (PreH1 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH2 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH3 : (list_pre <> 0)) (PreH4 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH5 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc before_mutex_waiters_oc )) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (InsideCritical sg_mutex_waiters_oc st_lock )
  **  (os_inv sg_mutex_waiters_oc st_lock )
|--
  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock ) ” 
  &&  “ (Crtos_RTrans before_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock ) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc before_mutex_waiters_oc ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc ) ”
  &&  (os_inv sg_mutex_waiters_oc st_lock )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
.

Definition LinklistResumeAll_partial_solve_wit_2 := LinklistResumeAll_partial_solve_wit_2_pure -> LinklistResumeAll_partial_solve_wit_2_aux.

Definition LinklistResumeAll_partial_solve_wit_3_pure := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (PreH1 : (list_pre <> 0)) (PreH2 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH3 : (In original (os_mutexes (st_lock)) )) (PreH4 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH5 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH6 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH7 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH8 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH9 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH10 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |->_)
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
  **  (os_inv sg_mutex_waiters_oc current )
|--
  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ”
.

Definition LinklistResumeAll_partial_solve_wit_3_aux := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (list_pre <> 0)) (PreH2 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH3 : (In original (os_mutexes (st_lock)) )) (PreH4 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH5 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH6 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH7 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH8 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH9 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH10 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (InsideCritical sg_mutex_waiters_oc st_lock )
  **  (os_inv sg_mutex_waiters_oc current )
|--
  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_addr) ) = p_mutex_waiters_oc) ” 
  &&  “ ((original.(mutex_id) ) = id_mutex_waiters_oc) ” 
  &&  “ (Crtos_RTrans before_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current ) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc ) ”
  &&  (os_inv sg_mutex_waiters_oc current )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
.

Definition LinklistResumeAll_partial_solve_wit_3 := LinklistResumeAll_partial_solve_wit_3_pure -> LinklistResumeAll_partial_solve_wit_3_aux.

Definition LinklistResumeAll_partial_solve_wit_4 := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (first: Z) (tail: (@list Z)) (next: Z) (PreH1 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH2 : (list_pre <> 0)) (PreH3 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH4 : (remaining = (cons (first) (tail)))) (PreH5 : (next = (sched_link_of (first)))) (PreH6 : (next <> list_pre)) (PreH7 : (list_pre <> 0)) (PreH8 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH9 : (In original (os_mutexes (st_lock)) )) (PreH10 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH11 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH12 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH13 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH14 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH15 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH16 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (mutex_resume_next_restore sg_mutex_waiters_oc current list_pre next )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (cons (first) (tail))) ” 
  &&  “ (next = (sched_link_of (first))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_addr) ) = p_mutex_waiters_oc) ” 
  &&  “ ((original.(mutex_id) ) = id_mutex_waiters_oc) ” 
  &&  “ (Crtos_RTrans before_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current ) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc ) ”
  &&  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (mutex_resume_next_restore sg_mutex_waiters_oc current list_pre next )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
.

Definition LinklistResumeAll_partial_solve_wit_5 := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (PreH1 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH2 : (list_pre <> 0)) (PreH3 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH4 : (remaining = (@nil Z))) (PreH5 : (next = list_pre)) (PreH6 : (list_pre <> 0)) (PreH7 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH8 : (In original (os_mutexes (st_lock)) )) (PreH9 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH10 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH11 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH12 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH13 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH14 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH15 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH16 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (mutex_resume_next_restore sg_mutex_waiters_oc current list_pre next )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (@nil Z)) ” 
  &&  “ (next = list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_addr) ) = p_mutex_waiters_oc) ” 
  &&  “ ((original.(mutex_id) ) = id_mutex_waiters_oc) ” 
  &&  “ (Crtos_RTrans before_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current ) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc ) ”
  &&  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (mutex_resume_next_restore sg_mutex_waiters_oc current list_pre next )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
.

Definition LinklistResumeAll_partial_solve_wit_6_pure := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (next: Z) (target: Z) (rest: (@list Z)) (PreH1 : (next <> list_pre)) (PreH2 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH3 : (list_pre <> 0)) (PreH4 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH5 : (remaining = (cons (target) (rest)))) (PreH6 : (next = (sched_link_of (target)))) (PreH7 : (next <> list_pre)) (PreH8 : (list_pre <> 0)) (PreH9 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH10 : (In original (os_mutexes (st_lock)) )) (PreH11 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH12 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH13 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH14 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH15 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH16 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH17 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (os_inv sg_mutex_waiters_oc current )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ”
.

Definition LinklistResumeAll_partial_solve_wit_6_aux := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (PreH1 : (next <> list_pre)) (PreH2 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH3 : (list_pre <> 0)) (PreH4 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH5 : (remaining = (cons (target) (rest)))) (PreH6 : (next = (sched_link_of (target)))) (PreH7 : (next <> list_pre)) (PreH8 : (list_pre <> 0)) (PreH9 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH10 : (In original (os_mutexes (st_lock)) )) (PreH11 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH12 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH13 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH14 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH15 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH16 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH17 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (os_inv sg_mutex_waiters_oc current )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_addr) ) = p_mutex_waiters_oc) ” 
  &&  “ ((original.(mutex_id) ) = id_mutex_waiters_oc) ” 
  &&  “ (Crtos_RTrans before_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current ) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc ) ”
  &&  (os_inv sg_mutex_waiters_oc current )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
.

Definition LinklistResumeAll_partial_solve_wit_6 := LinklistResumeAll_partial_solve_wit_6_pure -> LinklistResumeAll_partial_solve_wit_6_aux.

Definition LinklistResumeAll_partial_solve_wit_7_pure := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (next = (sched_link_of (target)))) (PreH3 : (addr_aligned target ALIGN_SIZE )) (PreH4 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH5 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH6 : (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH7 : (next <> list_pre)) (PreH8 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH9 : (list_pre <> 0)) (PreH10 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH11 : (remaining = (cons (target) (rest)))) (PreH12 : (next = (sched_link_of (target)))) (PreH13 : (next <> list_pre)) (PreH14 : (list_pre <> 0)) (PreH15 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH16 : (In original (os_mutexes (st_lock)) )) (PreH17 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH18 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH19 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH20 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH21 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH22 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH23 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH24 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (os_inv sg_mutex_waiters_oc current )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (next = (sched_link_of (target))) ”
.

Definition LinklistResumeAll_partial_solve_wit_7_aux := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (next = (sched_link_of (target)))) (PreH3 : (addr_aligned target ALIGN_SIZE )) (PreH4 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH5 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH6 : (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH7 : (next <> list_pre)) (PreH8 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH9 : (list_pre <> 0)) (PreH10 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH11 : (remaining = (cons (target) (rest)))) (PreH12 : (next = (sched_link_of (target)))) (PreH13 : (next <> list_pre)) (PreH14 : (list_pre <> 0)) (PreH15 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH16 : (In original (os_mutexes (st_lock)) )) (PreH17 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH18 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH19 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH20 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH21 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH22 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH23 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH24 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (os_inv sg_mutex_waiters_oc current )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_addr) ) = p_mutex_waiters_oc) ” 
  &&  “ ((original.(mutex_id) ) = id_mutex_waiters_oc) ” 
  &&  “ (Crtos_RTrans before_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current ) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc ) ”
  &&  (os_inv sg_mutex_waiters_oc current )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
.

Definition LinklistResumeAll_partial_solve_wit_7 := LinklistResumeAll_partial_solve_wit_7_pure -> LinklistResumeAll_partial_solve_wit_7_aux.

Definition LinklistResumeAll_partial_solve_wit_8_pure := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (PreH1 : (retval = target)) (PreH2 : (addr_aligned retval ALIGN_SIZE )) (PreH3 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH4 : (remaining = (cons (target) (rest)))) (PreH5 : (next = (sched_link_of (target)))) (PreH6 : (addr_aligned target ALIGN_SIZE )) (PreH7 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH8 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH9 : (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH10 : (next <> list_pre)) (PreH11 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH12 : (list_pre <> 0)) (PreH13 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH14 : (remaining = (cons (target) (rest)))) (PreH15 : (next = (sched_link_of (target)))) (PreH16 : (next <> list_pre)) (PreH17 : (list_pre <> 0)) (PreH18 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH19 : (In original (os_mutexes (st_lock)) )) (PreH20 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH21 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH22 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH23 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH24 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH25 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH26 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH27 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (os_inv sg_mutex_waiters_oc current )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |-> retval)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ”
.

Definition LinklistResumeAll_partial_solve_wit_8_aux := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (PreH1 : (retval = target)) (PreH2 : (addr_aligned retval ALIGN_SIZE )) (PreH3 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH4 : (remaining = (cons (target) (rest)))) (PreH5 : (next = (sched_link_of (target)))) (PreH6 : (addr_aligned target ALIGN_SIZE )) (PreH7 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH8 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH9 : (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH10 : (next <> list_pre)) (PreH11 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH12 : (list_pre <> 0)) (PreH13 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH14 : (remaining = (cons (target) (rest)))) (PreH15 : (next = (sched_link_of (target)))) (PreH16 : (next <> list_pre)) (PreH17 : (list_pre <> 0)) (PreH18 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH19 : (In original (os_mutexes (st_lock)) )) (PreH20 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH21 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH22 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH23 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH24 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH25 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH26 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH27 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (os_inv sg_mutex_waiters_oc current )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (retval = target) ” 
  &&  “ (addr_aligned retval ALIGN_SIZE ) ” 
  &&  “ (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_addr) ) = p_mutex_waiters_oc) ” 
  &&  “ ((original.(mutex_id) ) = id_mutex_waiters_oc) ” 
  &&  “ (Crtos_RTrans before_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current ) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc ) ”
  &&  (os_inv sg_mutex_waiters_oc current )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
.

Definition LinklistResumeAll_partial_solve_wit_8 := LinklistResumeAll_partial_solve_wit_8_pure -> LinklistResumeAll_partial_solve_wit_8_aux.

Definition LinklistResumeAll_partial_solve_wit_9 := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH2 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH3 : (retval = target)) (PreH4 : (addr_aligned retval ALIGN_SIZE )) (PreH5 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH6 : (remaining = (cons (target) (rest)))) (PreH7 : (next = (sched_link_of (target)))) (PreH8 : (addr_aligned target ALIGN_SIZE )) (PreH9 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH10 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH11 : (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH12 : (next <> list_pre)) (PreH13 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH14 : (list_pre <> 0)) (PreH15 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH16 : (remaining = (cons (target) (rest)))) (PreH17 : (next = (sched_link_of (target)))) (PreH18 : (next <> list_pre)) (PreH19 : (list_pre <> 0)) (PreH20 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH21 : (In original (os_mutexes (st_lock)) )) (PreH22 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH23 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH24 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH25 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH26 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH27 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH28 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH29 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (desc.(tdExstatus) ))
  **  (mutex_resume_exstatus_restore sg_mutex_waiters_oc marked target (-1) )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (retval = target) ” 
  &&  “ (addr_aligned retval ALIGN_SIZE ) ” 
  &&  “ (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_addr) ) = p_mutex_waiters_oc) ” 
  &&  “ ((original.(mutex_id) ) = id_mutex_waiters_oc) ” 
  &&  “ (Crtos_RTrans before_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current ) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc ) ”
  &&  ((&((retval)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |->_)
  **  (mutex_resume_exstatus_restore sg_mutex_waiters_oc marked target (-1) )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
.

Definition LinklistResumeAll_partial_solve_wit_10 := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH2 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH3 : (retval = target)) (PreH4 : (addr_aligned retval ALIGN_SIZE )) (PreH5 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH6 : (remaining = (cons (target) (rest)))) (PreH7 : (next = (sched_link_of (target)))) (PreH8 : (addr_aligned target ALIGN_SIZE )) (PreH9 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH10 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH11 : (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH12 : (next <> list_pre)) (PreH13 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH14 : (list_pre <> 0)) (PreH15 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH16 : (remaining = (cons (target) (rest)))) (PreH17 : (next = (sched_link_of (target)))) (PreH18 : (next <> list_pre)) (PreH19 : (list_pre <> 0)) (PreH20 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH21 : (In original (os_mutexes (st_lock)) )) (PreH22 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH23 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH24 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH25 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH26 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH27 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH28 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH29 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  ((&((retval)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (-1))
  **  (mutex_resume_exstatus_restore sg_mutex_waiters_oc marked target (-1) )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (retval = target) ” 
  &&  “ (addr_aligned retval ALIGN_SIZE ) ” 
  &&  “ (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_addr) ) = p_mutex_waiters_oc) ” 
  &&  “ ((original.(mutex_id) ) = id_mutex_waiters_oc) ” 
  &&  “ (Crtos_RTrans before_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current ) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc ) ”
  &&  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (-1))
  **  (mutex_resume_exstatus_restore sg_mutex_waiters_oc marked target (-1) )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
.

Definition LinklistResumeAll_partial_solve_wit_11_pure := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH2 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH3 : (retval = target)) (PreH4 : (addr_aligned retval ALIGN_SIZE )) (PreH5 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH6 : (remaining = (cons (target) (rest)))) (PreH7 : (next = (sched_link_of (target)))) (PreH8 : (addr_aligned target ALIGN_SIZE )) (PreH9 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH10 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH11 : (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH12 : (next <> list_pre)) (PreH13 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH14 : (list_pre <> 0)) (PreH15 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH16 : (remaining = (cons (target) (rest)))) (PreH17 : (next = (sched_link_of (target)))) (PreH18 : (next <> list_pre)) (PreH19 : (list_pre <> 0)) (PreH20 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH21 : (In original (os_mutexes (st_lock)) )) (PreH22 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH23 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH24 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH25 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH26 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH27 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH28 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH29 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (os_inv sg_mutex_waiters_oc marked )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |-> retval)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ”
.

Definition LinklistResumeAll_partial_solve_wit_11_aux := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH2 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH3 : (retval = target)) (PreH4 : (addr_aligned retval ALIGN_SIZE )) (PreH5 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH6 : (remaining = (cons (target) (rest)))) (PreH7 : (next = (sched_link_of (target)))) (PreH8 : (addr_aligned target ALIGN_SIZE )) (PreH9 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH10 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH11 : (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH12 : (next <> list_pre)) (PreH13 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH14 : (list_pre <> 0)) (PreH15 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH16 : (remaining = (cons (target) (rest)))) (PreH17 : (next = (sched_link_of (target)))) (PreH18 : (next <> list_pre)) (PreH19 : (list_pre <> 0)) (PreH20 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH21 : (In original (os_mutexes (st_lock)) )) (PreH22 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH23 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH24 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH25 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH26 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH27 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH28 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH29 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (os_inv sg_mutex_waiters_oc marked )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (retval = target) ” 
  &&  “ (addr_aligned retval ALIGN_SIZE ) ” 
  &&  “ (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_addr) ) = p_mutex_waiters_oc) ” 
  &&  “ ((original.(mutex_id) ) = id_mutex_waiters_oc) ” 
  &&  “ (Crtos_RTrans before_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current ) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc ) ”
  &&  (os_inv sg_mutex_waiters_oc marked )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
.

Definition LinklistResumeAll_partial_solve_wit_11 := LinklistResumeAll_partial_solve_wit_11_pure -> LinklistResumeAll_partial_solve_wit_11_aux.

Definition LinklistResumeAll_partial_solve_wit_12 := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (task_id: Z) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH3 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH4 : (0 <= task_id)) (PreH5 : (task_id < 65536)) (PreH6 : (get_task_with_idnode_success sg_mutex_waiters_oc marked task_id target )) (PreH7 : (mutex_pending_nodes p_mutex_waiters_oc marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH8 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH9 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH10 : (retval = target)) (PreH11 : (addr_aligned retval ALIGN_SIZE )) (PreH12 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH13 : (remaining = (cons (target) (rest)))) (PreH14 : (next = (sched_link_of (target)))) (PreH15 : (addr_aligned target ALIGN_SIZE )) (PreH16 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH17 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH18 : (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH19 : (next <> list_pre)) (PreH20 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH21 : (list_pre <> 0)) (PreH22 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH23 : (remaining = (cons (target) (rest)))) (PreH24 : (next = (sched_link_of (target)))) (PreH25 : (next <> list_pre)) (PreH26 : (list_pre <> 0)) (PreH27 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH28 : (In original (os_mutexes (st_lock)) )) (PreH29 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH30 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH31 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH32 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH33 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH34 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH35 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH36 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (mutex_resume_id_restore sg_mutex_waiters_oc marked target task_id )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (0 <= task_id) ” 
  &&  “ (task_id < 65536) ” 
  &&  “ (get_task_with_idnode_success sg_mutex_waiters_oc marked task_id target ) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (retval = target) ” 
  &&  “ (addr_aligned retval ALIGN_SIZE ) ” 
  &&  “ (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_addr) ) = p_mutex_waiters_oc) ” 
  &&  “ ((original.(mutex_id) ) = id_mutex_waiters_oc) ” 
  &&  “ (Crtos_RTrans before_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current ) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc ) ”
  &&  ((&((retval)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (mutex_resume_id_restore sg_mutex_waiters_oc marked target task_id )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
.

Definition LinklistResumeAll_partial_solve_wit_13 := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (task_id: Z) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH3 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH4 : (0 <= task_id)) (PreH5 : (task_id < 65536)) (PreH6 : (get_task_with_idnode_success sg_mutex_waiters_oc marked task_id target )) (PreH7 : (mutex_pending_nodes p_mutex_waiters_oc marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH8 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH9 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH10 : (retval = target)) (PreH11 : (addr_aligned retval ALIGN_SIZE )) (PreH12 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH13 : (remaining = (cons (target) (rest)))) (PreH14 : (next = (sched_link_of (target)))) (PreH15 : (addr_aligned target ALIGN_SIZE )) (PreH16 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH17 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH18 : (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH19 : (next <> list_pre)) (PreH20 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH21 : (list_pre <> 0)) (PreH22 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH23 : (remaining = (cons (target) (rest)))) (PreH24 : (next = (sched_link_of (target)))) (PreH25 : (next <> list_pre)) (PreH26 : (list_pre <> 0)) (PreH27 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH28 : (In original (os_mutexes (st_lock)) )) (PreH29 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH30 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH31 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH32 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH33 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH34 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH35 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH36 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  ((&((retval)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (mutex_resume_id_restore sg_mutex_waiters_oc marked target task_id )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (0 <= task_id) ” 
  &&  “ (task_id < 65536) ” 
  &&  “ (get_task_with_idnode_success sg_mutex_waiters_oc marked task_id target ) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (retval = target) ” 
  &&  “ (addr_aligned retval ALIGN_SIZE ) ” 
  &&  “ (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_addr) ) = p_mutex_waiters_oc) ” 
  &&  “ ((original.(mutex_id) ) = id_mutex_waiters_oc) ” 
  &&  “ (Crtos_RTrans before_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current ) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc ) ”
  &&  ((&((target)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (mutex_resume_id_restore sg_mutex_waiters_oc marked target task_id )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
.

Definition LinklistResumeAll_partial_solve_wit_14_pure := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (task_id: Z) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH3 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH4 : (0 <= task_id)) (PreH5 : (task_id < 65536)) (PreH6 : (get_task_with_idnode_success sg_mutex_waiters_oc marked task_id target )) (PreH7 : (mutex_pending_nodes p_mutex_waiters_oc marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH8 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH9 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH10 : (retval = target)) (PreH11 : (addr_aligned retval ALIGN_SIZE )) (PreH12 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH13 : (remaining = (cons (target) (rest)))) (PreH14 : (next = (sched_link_of (target)))) (PreH15 : (addr_aligned target ALIGN_SIZE )) (PreH16 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH17 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH18 : (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH19 : (next <> list_pre)) (PreH20 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH21 : (list_pre <> 0)) (PreH22 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH23 : (remaining = (cons (target) (rest)))) (PreH24 : (next = (sched_link_of (target)))) (PreH25 : (next <> list_pre)) (PreH26 : (list_pre <> 0)) (PreH27 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH28 : (In original (os_mutexes (st_lock)) )) (PreH29 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH30 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH31 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH32 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH33 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH34 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH35 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH36 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (os_inv sg_mutex_waiters_oc marked )
  **  ((( &( "resume_task_id" ) )) # Int  |-> task_id)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |-> retval)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  “ (task_id < 65536) ”
.

Definition LinklistResumeAll_partial_solve_wit_14_aux := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (task_id: Z) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH3 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH4 : (0 <= task_id)) (PreH5 : (task_id < 65536)) (PreH6 : (get_task_with_idnode_success sg_mutex_waiters_oc marked task_id target )) (PreH7 : (mutex_pending_nodes p_mutex_waiters_oc marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH8 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH9 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH10 : (retval = target)) (PreH11 : (addr_aligned retval ALIGN_SIZE )) (PreH12 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH13 : (remaining = (cons (target) (rest)))) (PreH14 : (next = (sched_link_of (target)))) (PreH15 : (addr_aligned target ALIGN_SIZE )) (PreH16 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH17 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH18 : (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH19 : (next <> list_pre)) (PreH20 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH21 : (list_pre <> 0)) (PreH22 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH23 : (remaining = (cons (target) (rest)))) (PreH24 : (next = (sched_link_of (target)))) (PreH25 : (next <> list_pre)) (PreH26 : (list_pre <> 0)) (PreH27 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH28 : (In original (os_mutexes (st_lock)) )) (PreH29 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH30 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH31 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH32 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH33 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH34 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH35 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH36 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (os_inv sg_mutex_waiters_oc marked )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  “ (task_id < 65536) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (0 <= task_id) ” 
  &&  “ (task_id < 65536) ” 
  &&  “ (get_task_with_idnode_success sg_mutex_waiters_oc marked task_id target ) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (retval = target) ” 
  &&  “ (addr_aligned retval ALIGN_SIZE ) ” 
  &&  “ (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_addr) ) = p_mutex_waiters_oc) ” 
  &&  “ ((original.(mutex_id) ) = id_mutex_waiters_oc) ” 
  &&  “ (Crtos_RTrans before_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current ) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc ) ”
  &&  (os_inv sg_mutex_waiters_oc marked )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
.

Definition LinklistResumeAll_partial_solve_wit_14 := LinklistResumeAll_partial_solve_wit_14_pure -> LinklistResumeAll_partial_solve_wit_14_aux.

Definition LinklistResumeAll_partial_solve_wit_15_pure := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (next: Z) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (PreH1 : (next = list_pre)) (PreH2 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH3 : (list_pre <> 0)) (PreH4 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH5 : (remaining = (@nil Z))) (PreH6 : (next = list_pre)) (PreH7 : (list_pre <> 0)) (PreH8 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH9 : (In original (os_mutexes (st_lock)) )) (PreH10 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH11 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH12 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH13 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH14 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH15 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH16 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (os_inv sg_mutex_waiters_oc current )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current ) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (@nil Z)) ” 
  &&  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_addr) ) = p_mutex_waiters_oc) ” 
  &&  “ ((original.(mutex_id) ) = id_mutex_waiters_oc) ” 
  &&  “ (Crtos_RTrans before_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc ) ”
.

Definition LinklistResumeAll_partial_solve_wit_15_aux := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (next: Z) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (next = list_pre)) (PreH2 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH3 : (list_pre <> 0)) (PreH4 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH5 : (remaining = (@nil Z))) (PreH6 : (next = list_pre)) (PreH7 : (list_pre <> 0)) (PreH8 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH9 : (In original (os_mutexes (st_lock)) )) (PreH10 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH11 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH12 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH13 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH14 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH15 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH16 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (os_inv sg_mutex_waiters_oc current )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current ) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (@nil Z)) ” 
  &&  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_addr) ) = p_mutex_waiters_oc) ” 
  &&  “ ((original.(mutex_id) ) = id_mutex_waiters_oc) ” 
  &&  “ (Crtos_RTrans before_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc ) ” 
  &&  “ (next = list_pre) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (@nil Z)) ” 
  &&  “ (next = list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_addr) ) = p_mutex_waiters_oc) ” 
  &&  “ ((original.(mutex_id) ) = id_mutex_waiters_oc) ” 
  &&  “ (Crtos_RTrans before_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current ) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc ) ”
  &&  (os_inv sg_mutex_waiters_oc current )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
.

Definition LinklistResumeAll_partial_solve_wit_15 := LinklistResumeAll_partial_solve_wit_15_pure -> LinklistResumeAll_partial_solve_wit_15_aux.

Definition LinklistResumeAll_partial_solve_wit_16_pure := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (next: Z) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (PreH1 : (mutex_delete_drained p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH2 : (Crtos_GTrans st_lock current )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (current)) ( MonadErr.ret  (tt)) X_mutex_waiters_oc )) (PreH4 : (next = list_pre)) (PreH5 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH6 : (list_pre <> 0)) (PreH7 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH8 : (remaining = (@nil Z))) (PreH9 : (next = list_pre)) (PreH10 : (list_pre <> 0)) (PreH11 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH12 : (In original (os_mutexes (st_lock)) )) (PreH13 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH14 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH15 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH16 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH17 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH18 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH19 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (os_inv sg_mutex_waiters_oc current )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  “ (Crtos_GTrans st_lock current ) ”
.

Definition LinklistResumeAll_partial_solve_wit_16_aux := 
forall (list_pre: Z) (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (next: Z) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (mutex_delete_drained p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH2 : (Crtos_GTrans st_lock current )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (current)) ( MonadErr.ret  (tt)) X_mutex_waiters_oc )) (PreH4 : (next = list_pre)) (PreH5 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH6 : (list_pre <> 0)) (PreH7 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH8 : (remaining = (@nil Z))) (PreH9 : (next = list_pre)) (PreH10 : (list_pre <> 0)) (PreH11 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH12 : (In original (os_mutexes (st_lock)) )) (PreH13 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH14 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH15 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH16 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH17 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH18 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH19 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (os_inv sg_mutex_waiters_oc current )
  **  (InsideCritical sg_mutex_waiters_oc st_lock )
|--
  “ (Crtos_GTrans st_lock current ) ” 
  &&  “ (mutex_delete_drained p_mutex_waiters_oc id_mutex_waiters_oc current ) ” 
  &&  “ (Crtos_GTrans st_lock current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (current)) ( MonadErr.ret  (tt)) X_mutex_waiters_oc ) ” 
  &&  “ (next = list_pre) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (@nil Z)) ” 
  &&  “ (next = list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_addr) ) = p_mutex_waiters_oc) ” 
  &&  “ ((original.(mutex_id) ) = id_mutex_waiters_oc) ” 
  &&  “ (Crtos_RTrans before_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current ) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc ) ”
  &&  (InsideCritical sg_mutex_waiters_oc st_lock )
  **  (os_inv sg_mutex_waiters_oc current )
.

Definition LinklistResumeAll_partial_solve_wit_16 := LinklistResumeAll_partial_solve_wit_16_pure -> LinklistResumeAll_partial_solve_wit_16_aux.

Definition LinklistResumeAll_which_implies_wit_1 := 
(
forall (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (PreH1 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) ,
  (os_inv sg_mutex_waiters_oc st_lock )
|--
  EX (original: MutexAbs) ,
  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_addr) ) = p_mutex_waiters_oc) ” 
  &&  “ ((original.(mutex_id) ) = id_mutex_waiters_oc) ” 
  &&  “ (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock ) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc st_lock (map (sched_link_node) ((original.(mutex_pending_addrs) ))) ) ”
  &&  (os_inv sg_mutex_waiters_oc st_lock )
) \/
(
forall (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (st_lock: VarGlobalState) (PreH1 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) ,
  TT && emp 
|--
  EX (original: MutexAbs) ,
  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_addr) ) = p_mutex_waiters_oc) ” 
  &&  “ ((original.(mutex_id) ) = id_mutex_waiters_oc) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc st_lock (map (sched_link_node) ((original.(mutex_pending_addrs) ))) ) ”
  &&  emp
).

Definition LinklistResumeAll_which_implies_wit_2 := 
forall (list_pre: Z) (p_mutex_waiters_oc: Z) (sg_mutex_waiters_oc: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (list_pre = (mutex_pending_head (p_mutex_waiters_oc)))) (PreH2 : (list_pre <> 0)) (PreH3 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) ,
  (os_inv sg_mutex_waiters_oc current )
|--
  (EX (next: Z) ,
  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (@nil Z)) ” 
  &&  “ (next = list_pre) ”
  &&  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (mutex_resume_next_restore sg_mutex_waiters_oc current list_pre next ))
  ||
  (EX (next: Z)  (first: Z)  (tail: (@list Z)) ,
  “ (list_pre = (mutex_pending_head (p_mutex_waiters_oc))) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (cons (first) (tail))) ” 
  &&  “ (next = (sched_link_of (first))) ” 
  &&  “ (next <> list_pre) ”
  &&  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (mutex_resume_next_restore sg_mutex_waiters_oc current list_pre next ))
.

Definition LinklistResumeAll_which_implies_wit_3 := 
(
forall (list_pre: Z) (sg_mutex_waiters_oc: StableGlobalState) (current: VarGlobalState) (next: Z) ,
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (mutex_resume_next_restore sg_mutex_waiters_oc current list_pre next )
|--
  (os_inv sg_mutex_waiters_oc current )
) \/
(
forall (list_pre: Z) (sg_mutex_waiters_oc: StableGlobalState) (current: VarGlobalState) (next: Z) ,
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (mutex_resume_next_restore sg_mutex_waiters_oc current list_pre next )
|--
  (os_inv sg_mutex_waiters_oc current )
).

Definition LinklistResumeAll_which_implies_wit_3_split_goal_spatial := 
forall (list_pre: Z) (sg_mutex_waiters_oc: StableGlobalState) (current: VarGlobalState) (next: Z) ,
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (mutex_resume_next_restore sg_mutex_waiters_oc current list_pre next )
|--
  (os_inv sg_mutex_waiters_oc current )
.

Definition LinklistResumeAll_which_implies_wit_4 := 
(
forall (p_mutex_waiters_oc: Z) (sg_mutex_waiters_oc: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (next = (sched_link_of (target)))) (PreH3 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) ,
  (os_inv sg_mutex_waiters_oc current )
|--
  EX (desc: TaskDescriptorAbs) ,
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ”
  &&  (os_inv sg_mutex_waiters_oc current )
) \/
(
forall (p_mutex_waiters_oc: Z) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (next = (sched_link_of (target)))) (PreH3 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) ,
  TT && emp 
|--
  EX (desc: TaskDescriptorAbs) ,
  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ”
  &&  emp
).

Definition LinklistResumeAll_which_implies_wit_5 := 
(
forall (sg_mutex_waiters_oc: StableGlobalState) (current: VarGlobalState) (target: Z) (desc: TaskDescriptorAbs) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) ,
  (os_inv sg_mutex_waiters_oc current )
|--
  EX (marked: VarGlobalState) ,
  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ”
  &&  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (desc.(tdExstatus) ))
  **  (mutex_resume_exstatus_restore sg_mutex_waiters_oc marked target (-1) )
) \/
(
forall (sg_mutex_waiters_oc: StableGlobalState) (current: VarGlobalState) (target: Z) (desc: TaskDescriptorAbs) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) ,
  (os_inv sg_mutex_waiters_oc current )
|--
  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (desc.(tdExstatus) ))
  **  (mutex_resume_exstatus_restore sg_mutex_waiters_oc (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)) target (-1) )
).

Definition LinklistResumeAll_which_implies_wit_5_split_goal_spatial := 
forall (sg_mutex_waiters_oc: StableGlobalState) (current: VarGlobalState) (target: Z) (desc: TaskDescriptorAbs) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) ,
  (os_inv sg_mutex_waiters_oc current )
|--
  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (desc.(tdExstatus) ))
  **  (mutex_resume_exstatus_restore sg_mutex_waiters_oc (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)) target (-1) )
.

Definition LinklistResumeAll_which_implies_wit_6 := 
(
forall (sg_mutex_waiters_oc: StableGlobalState) (target: Z) (marked: VarGlobalState) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (-1))
  **  (mutex_resume_exstatus_restore sg_mutex_waiters_oc marked target (-1) )
|--
  (os_inv sg_mutex_waiters_oc marked )
) \/
(
forall (sg_mutex_waiters_oc: StableGlobalState) (target: Z) (marked: VarGlobalState) (PreH1 : ((-1) <= INT_MAX)) (PreH2 : ((-1) >= INT_MIN)) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (-1))
  **  (mutex_resume_exstatus_restore sg_mutex_waiters_oc marked target (-1) )
|--
  (os_inv sg_mutex_waiters_oc marked )
).

Definition LinklistResumeAll_which_implies_wit_6_split_goal_spatial := 
forall (sg_mutex_waiters_oc: StableGlobalState) (target: Z) (marked: VarGlobalState) (PreH1 : ((-1) <= INT_MAX)) (PreH2 : ((-1) >= INT_MIN)) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (-1))
  **  (mutex_resume_exstatus_restore sg_mutex_waiters_oc marked target (-1) )
|--
  (os_inv sg_mutex_waiters_oc marked )
.

Definition LinklistResumeAll_which_implies_wit_7 := 
(
forall (p_mutex_waiters_oc: Z) (sg_mutex_waiters_oc: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (marked: VarGlobalState) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH3 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) ,
  (os_inv sg_mutex_waiters_oc marked )
|--
  EX (task_id: Z) ,
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (0 <= task_id) ” 
  &&  “ (task_id < 65536) ” 
  &&  “ (get_task_with_idnode_success sg_mutex_waiters_oc marked task_id target ) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ”
  &&  ((&((target)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (mutex_resume_id_restore sg_mutex_waiters_oc marked target task_id )
) \/
(
forall (p_mutex_waiters_oc: Z) (sg_mutex_waiters_oc: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (marked: VarGlobalState) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH3 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) ,
  (os_inv sg_mutex_waiters_oc marked )
|--
  EX (task_id: Z) ,
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (0 <= task_id) ” 
  &&  “ (task_id < 65536) ” 
  &&  “ (get_task_with_idnode_success sg_mutex_waiters_oc marked task_id target ) ” 
  &&  “ (mutex_pending_nodes p_mutex_waiters_oc marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ”
  &&  ((&((target)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (mutex_resume_id_restore sg_mutex_waiters_oc marked target task_id )
).

Definition LinklistResumeAll_which_implies_wit_8 := 
(
forall (sg_mutex_waiters_oc: StableGlobalState) (target: Z) (marked: VarGlobalState) (task_id: Z) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (mutex_resume_id_restore sg_mutex_waiters_oc marked target task_id )
|--
  (os_inv sg_mutex_waiters_oc marked )
) \/
(
forall (sg_mutex_waiters_oc: StableGlobalState) (target: Z) (marked: VarGlobalState) (task_id: Z) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (mutex_resume_id_restore sg_mutex_waiters_oc marked target task_id )
|--
  (os_inv sg_mutex_waiters_oc marked )
).

Definition LinklistResumeAll_which_implies_wit_8_split_goal_spatial := 
forall (sg_mutex_waiters_oc: StableGlobalState) (target: Z) (marked: VarGlobalState) (task_id: Z) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (mutex_resume_id_restore sg_mutex_waiters_oc marked target task_id )
|--
  (os_inv sg_mutex_waiters_oc marked )
.

Definition LinklistResumeAll_which_implies_wit_9 := 
(
forall (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (sg_mutex_waiters_oc: StableGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH2 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH3 : (remaining = (@nil Z))) (PreH4 : (In original (os_mutexes (st_lock)) )) (PreH5 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH6 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH7 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH8 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH9 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (os_inv sg_mutex_waiters_oc current )
|--
  “ (mutex_delete_drained p_mutex_waiters_oc id_mutex_waiters_oc current ) ” 
  &&  “ (Crtos_GTrans st_lock current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (current)) ( MonadErr.ret  (tt)) X_mutex_waiters_oc ) ”
  &&  (os_inv sg_mutex_waiters_oc current )
) \/
(
forall (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH2 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH3 : (remaining = (@nil Z))) (PreH4 : (In original (os_mutexes (st_lock)) )) (PreH5 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH6 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH7 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH8 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH9 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (current)) ( MonadErr.ret  (tt)) X_mutex_waiters_oc ) ” 
  &&  “ (Crtos_GTrans st_lock current ) ” 
  &&  “ (mutex_delete_drained p_mutex_waiters_oc id_mutex_waiters_oc current ) ”
  &&  emp
).

Definition LinklistResumeAll_which_implies_wit_9_split_goal_1 := 
forall (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH2 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH3 : (remaining = (@nil Z))) (PreH4 : (In original (os_mutexes (st_lock)) )) (PreH5 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH6 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH7 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH8 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH9 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  ( monadesafe_lib.safeExec  (LastSeen (current)) ( MonadErr.ret  (tt)) X_mutex_waiters_oc )
.

Definition LinklistResumeAll_which_implies_wit_9_split_goal_2 := 
forall (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH2 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH3 : (remaining = (@nil Z))) (PreH4 : (In original (os_mutexes (st_lock)) )) (PreH5 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH6 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH7 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH8 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH9 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (Crtos_GTrans st_lock current )
.

Definition LinklistResumeAll_which_implies_wit_9_split_goal_3 := 
forall (X_mutex_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_mutex_waiters_oc: Z) (p_mutex_waiters_oc: Z) (before_mutex_waiters_oc: VarGlobalState) (st_lock: VarGlobalState) (original: MutexAbs) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc current )) (PreH2 : (mutex_pending_nodes p_mutex_waiters_oc current (map (sched_link_node) (remaining)) )) (PreH3 : (remaining = (@nil Z))) (PreH4 : (In original (os_mutexes (st_lock)) )) (PreH5 : ((original.(mutex_addr) ) = p_mutex_waiters_oc)) (PreH6 : ((original.(mutex_id) ) = id_mutex_waiters_oc)) (PreH7 : (Crtos_RTrans before_mutex_waiters_oc st_lock )) (PreH8 : (mutex_delete_live p_mutex_waiters_oc id_mutex_waiters_oc st_lock )) (PreH9 : (mutex_resume_remaining_effect p_mutex_waiters_oc (original.(mutex_pending_addrs) ) st_lock remaining current )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_mutex_waiters_oc)) (abs_mutex_resume_all (p_mutex_waiters_oc) (id_mutex_waiters_oc)) X_mutex_waiters_oc )) ,
  (mutex_delete_drained p_mutex_waiters_oc id_mutex_waiters_oc current )
.

Definition KTaskWakeup_derive_semaphore_pending_head_ic_by_wakeup_by_id_ic := 
forall (id_pre: Z) (rest_semaphore_pending_head_ic: (@list (@DL_Node Z))) (task_semaphore_pending_head_ic: Z) (sem_semaphore_pending_head_ic: Z) (before_semaphore_pending_head_ic: VarGlobalState) (sg_semaphore_pending_head_ic: StableGlobalState) ,
  “ (id_pre < 65536) ” 
  &&  “ (get_task_with_idnode_success sg_semaphore_pending_head_ic before_semaphore_pending_head_ic id_pre task_semaphore_pending_head_ic ) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_pending_head_ic before_semaphore_pending_head_ic (cons ((sched_link_node (task_semaphore_pending_head_ic))) (rest_semaphore_pending_head_ic)) ) ”
  &&  (os_inv sg_semaphore_pending_head_ic before_semaphore_pending_head_ic )
|--
EX (sg_wakeup_by_id_ic: StableGlobalState) (before_wakeup_by_id_ic: VarGlobalState) ,
  (“ (id_pre < 65536) ”
  &&  (os_inv sg_wakeup_by_id_ic before_wakeup_by_id_ic ))
  **
  (((EX after_2 desc_2 task retval_2,
  “ (task <> 0) ” 
  &&  “ (get_task_with_idnode_success sg_wakeup_by_id_ic before_wakeup_by_id_ic id_pre task ) ” 
  &&  “ (((before_wakeup_by_id_ic.(os_tasks) ).(task_desc_map) (task)) = (Some (desc_2))) ” 
  &&  “ (((desc_2.(tdSchedMember) ).(tsmStat) ) <> TSK_SUSPEND) ” 
  &&  “ (retval_2 = (-1)) ” 
  &&  “ (after_2 = before_wakeup_by_id_ic) ”
  &&  (os_inv sg_wakeup_by_id_ic after_2 ))
  ||
  (EX after_2 desc_2 task retval_2,
  “ (task <> 0) ” 
  &&  “ (get_task_with_idnode_success sg_wakeup_by_id_ic before_wakeup_by_id_ic id_pre task ) ” 
  &&  “ (((before_wakeup_by_id_ic.(os_tasks) ).(task_desc_map) (task)) = (Some (desc_2))) ” 
  &&  “ (((desc_2.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (retval_2 = 0) ” 
  &&  “ (ktask_wakeup_step task desc_2 before_wakeup_by_id_ic after_2 ) ”
  &&  (os_inv sg_wakeup_by_id_ic after_2 )))
  -*
  (EX after desc retval,
  “ (retval = 0) ” 
  &&  “ (task_semaphore_pending_head_ic <> 0) ” 
  &&  “ (((before_semaphore_pending_head_ic.(os_tasks) ).(task_desc_map) (task_semaphore_pending_head_ic)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (wakeup_semaphore_head sem_semaphore_pending_head_ic task_semaphore_pending_head_ic desc before_semaphore_pending_head_ic after ) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_pending_head_ic after rest_semaphore_pending_head_ic ) ”
  &&  (os_inv sg_semaphore_pending_head_ic after )))
.

Definition KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic := 
forall (id_pre: Z) (before_detached_sched_null_delay: VarGlobalState) (sg_detached_sched_null_delay: StableGlobalState) ,
  “ (id_pre < 65536) ” 
  &&  “ (ktask_wakeup_detached_null_condition sg_detached_sched_null_delay before_detached_sched_null_delay id_pre ) ”
  &&  (os_inv sg_detached_sched_null_delay before_detached_sched_null_delay )
|--
EX (sg_wakeup_by_id_ic: StableGlobalState) (before_wakeup_by_id_ic: VarGlobalState) ,
  (“ (id_pre < 65536) ”
  &&  (os_inv sg_wakeup_by_id_ic before_wakeup_by_id_ic ))
  **
  (((EX after_2 desc_2 task_2 retval_2,
  “ (task_2 <> 0) ” 
  &&  “ (get_task_with_idnode_success sg_wakeup_by_id_ic before_wakeup_by_id_ic id_pre task_2 ) ” 
  &&  “ (((before_wakeup_by_id_ic.(os_tasks) ).(task_desc_map) (task_2)) = (Some (desc_2))) ” 
  &&  “ (((desc_2.(tdSchedMember) ).(tsmStat) ) <> TSK_SUSPEND) ” 
  &&  “ (retval_2 = (-1)) ” 
  &&  “ (after_2 = before_wakeup_by_id_ic) ”
  &&  (os_inv sg_wakeup_by_id_ic after_2 ))
  ||
  (EX after_2 desc_2 task_2 retval_2,
  “ (task_2 <> 0) ” 
  &&  “ (get_task_with_idnode_success sg_wakeup_by_id_ic before_wakeup_by_id_ic id_pre task_2 ) ” 
  &&  “ (((before_wakeup_by_id_ic.(os_tasks) ).(task_desc_map) (task_2)) = (Some (desc_2))) ” 
  &&  “ (((desc_2.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (retval_2 = 0) ” 
  &&  “ (ktask_wakeup_step task_2 desc_2 before_wakeup_by_id_ic after_2 ) ”
  &&  (os_inv sg_wakeup_by_id_ic after_2 )))
  -*
  ((EX after desc task retval,
  “ (task <> 0) ” 
  &&  “ (get_task_with_idnode_success sg_detached_sched_null_delay before_detached_sched_null_delay id_pre task ) ” 
  &&  “ (((before_detached_sched_null_delay.(os_tasks) ).(task_desc_map) (task)) = (Some (desc))) ” 
  &&  “ ((desc.(tdDelay) ) = 0) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) <> TSK_SUSPEND) ” 
  &&  “ (retval = (-1)) ” 
  &&  “ (after = before_detached_sched_null_delay) ”
  &&  (os_inv sg_detached_sched_null_delay after ))
  ||
  (EX after desc task retval,
  “ (task <> 0) ” 
  &&  “ (get_task_with_idnode_success sg_detached_sched_null_delay before_detached_sched_null_delay id_pre task ) ” 
  &&  “ (((before_detached_sched_null_delay.(os_tasks) ).(task_desc_map) (task)) = (Some (desc))) ” 
  &&  “ ((desc.(tdDelay) ) = 0) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (retval = 0) ” 
  &&  “ (ktask_wakeup_detached_null_step task desc before_detached_sched_null_delay after ) ”
  &&  (os_inv sg_detached_sched_null_delay after ))))
.

Module Type VC_Correct.


Axiom proof_of_LinklistResumeAll_safety_wit_1 : LinklistResumeAll_safety_wit_1.
Axiom proof_of_LinklistResumeAll_safety_wit_2 : LinklistResumeAll_safety_wit_2.
Axiom proof_of_LinklistResumeAll_safety_wit_3 : LinklistResumeAll_safety_wit_3.
Axiom proof_of_LinklistResumeAll_safety_wit_4 : LinklistResumeAll_safety_wit_4.
Axiom proof_of_LinklistResumeAll_safety_wit_5 : LinklistResumeAll_safety_wit_5.
Axiom proof_of_LinklistResumeAll_safety_wit_6 : LinklistResumeAll_safety_wit_6.
Axiom proof_of_LinklistResumeAll_safety_wit_7 : LinklistResumeAll_safety_wit_7.
Axiom proof_of_LinklistResumeAll_safety_wit_8 : LinklistResumeAll_safety_wit_8.
Axiom proof_of_LinklistResumeAll_safety_wit_9 : LinklistResumeAll_safety_wit_9.
Axiom proof_of_LinklistResumeAll_safety_wit_10 : LinklistResumeAll_safety_wit_10.
Axiom proof_of_LinklistResumeAll_safety_wit_11 : LinklistResumeAll_safety_wit_11.
Axiom proof_of_LinklistResumeAll_entail_wit_1 : LinklistResumeAll_entail_wit_1.
Axiom proof_of_LinklistResumeAll_entail_wit_2 : LinklistResumeAll_entail_wit_2.
Axiom proof_of_LinklistResumeAll_entail_wit_3 : LinklistResumeAll_entail_wit_3.
Axiom proof_of_LinklistResumeAll_entail_wit_4_1 : LinklistResumeAll_entail_wit_4_1.
Axiom proof_of_LinklistResumeAll_entail_wit_4_2 : LinklistResumeAll_entail_wit_4_2.
Axiom proof_of_LinklistResumeAll_return_wit_1 : LinklistResumeAll_return_wit_1.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_1_pure : LinklistResumeAll_partial_solve_wit_1_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_1 : LinklistResumeAll_partial_solve_wit_1.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_2_pure : LinklistResumeAll_partial_solve_wit_2_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_2 : LinklistResumeAll_partial_solve_wit_2.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_3_pure : LinklistResumeAll_partial_solve_wit_3_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_3 : LinklistResumeAll_partial_solve_wit_3.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_4 : LinklistResumeAll_partial_solve_wit_4.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_5 : LinklistResumeAll_partial_solve_wit_5.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_6_pure : LinklistResumeAll_partial_solve_wit_6_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_6 : LinklistResumeAll_partial_solve_wit_6.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_7_pure : LinklistResumeAll_partial_solve_wit_7_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_7 : LinklistResumeAll_partial_solve_wit_7.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_8_pure : LinklistResumeAll_partial_solve_wit_8_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_8 : LinklistResumeAll_partial_solve_wit_8.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_9 : LinklistResumeAll_partial_solve_wit_9.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_10 : LinklistResumeAll_partial_solve_wit_10.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_11_pure : LinklistResumeAll_partial_solve_wit_11_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_11 : LinklistResumeAll_partial_solve_wit_11.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_12 : LinklistResumeAll_partial_solve_wit_12.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_13 : LinklistResumeAll_partial_solve_wit_13.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_14_pure : LinklistResumeAll_partial_solve_wit_14_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_14 : LinklistResumeAll_partial_solve_wit_14.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_15_pure : LinklistResumeAll_partial_solve_wit_15_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_15 : LinklistResumeAll_partial_solve_wit_15.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_16_pure : LinklistResumeAll_partial_solve_wit_16_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_16 : LinklistResumeAll_partial_solve_wit_16.
Axiom proof_of_LinklistResumeAll_which_implies_wit_1 : LinklistResumeAll_which_implies_wit_1.
Axiom proof_of_LinklistResumeAll_which_implies_wit_2 : LinklistResumeAll_which_implies_wit_2.
Axiom proof_of_LinklistResumeAll_which_implies_wit_3 : LinklistResumeAll_which_implies_wit_3.
Axiom proof_of_LinklistResumeAll_which_implies_wit_4 : LinklistResumeAll_which_implies_wit_4.
Axiom proof_of_LinklistResumeAll_which_implies_wit_5 : LinklistResumeAll_which_implies_wit_5.
Axiom proof_of_LinklistResumeAll_which_implies_wit_6 : LinklistResumeAll_which_implies_wit_6.
Axiom proof_of_LinklistResumeAll_which_implies_wit_7 : LinklistResumeAll_which_implies_wit_7.
Axiom proof_of_LinklistResumeAll_which_implies_wit_8 : LinklistResumeAll_which_implies_wit_8.
Axiom proof_of_LinklistResumeAll_which_implies_wit_9 : LinklistResumeAll_which_implies_wit_9.
Axiom proof_of_KTaskWakeup_derive_semaphore_pending_head_ic_by_wakeup_by_id_ic : KTaskWakeup_derive_semaphore_pending_head_ic_by_wakeup_by_id_ic.
Axiom proof_of_KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic : KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic.

End VC_Correct.
