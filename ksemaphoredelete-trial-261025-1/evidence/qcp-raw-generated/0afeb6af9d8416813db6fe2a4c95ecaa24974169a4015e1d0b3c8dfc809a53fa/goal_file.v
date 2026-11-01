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
Require Import CRTOS_Verify.VC.LinklistResumeAll_lib.
Local Open Scope sac.

(*----- Function LinklistResumeAll -----*)

Definition LinklistResumeAll_safety_wit_1 := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (PreH1 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH2 : (semaphore_pending_nodes sem_semaphore_waiters before_semaphore_waiters (map (sched_link_node) (waiting_semaphore_waiters)) )) ,
  ((( &( "lock" ) )) # UInt  |->_)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  (os_inv sg_semaphore_waiters before_semaphore_waiters )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition LinklistResumeAll_safety_wit_2 := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (PreH1 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH2 : (semaphore_pending_nodes sem_semaphore_waiters before_semaphore_waiters (map (sched_link_node) (waiting_semaphore_waiters)) )) ,
  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "lock" ) )) # UInt  |-> 0)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  (os_inv sg_semaphore_waiters before_semaphore_waiters )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition LinklistResumeAll_safety_wit_3 := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (PreH1 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH2 : (semaphore_pending_nodes sem_semaphore_waiters before_semaphore_waiters (map (sched_link_node) (waiting_semaphore_waiters)) )) ,
  ((( &( "node" ) )) # Ptr  |->_)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # UInt  |-> 0)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  (os_inv sg_semaphore_waiters before_semaphore_waiters )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition LinklistResumeAll_safety_wit_4 := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (list_pre <> 0)) (PreH2 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH3 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH4 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |->_)
  **  ((( &( "lock" ) )) # UInt  |->_)
  **  (os_inv sg_semaphore_waiters current )
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition LinklistResumeAll_safety_wit_5 := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (PreH1 : (next <> list_pre)) (PreH2 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH3 : (remaining = (@nil Z))) (PreH4 : (next = list_pre)) (PreH5 : (list_pre <> 0)) (PreH6 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH7 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH8 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  (os_inv sg_semaphore_waiters current )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  ((( &( "lock" ) )) # UInt  |->_)
|--
  “ False ”
.

Definition LinklistResumeAll_safety_wit_6 := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (first: Z) (tail: (@list Z)) (next: Z) (PreH1 : (next = list_pre)) (PreH2 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH3 : (remaining = (cons (first) (tail)))) (PreH4 : (next = (sched_link_of (first)))) (PreH5 : (next <> list_pre)) (PreH6 : (list_pre <> 0)) (PreH7 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH8 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH9 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  (os_inv sg_semaphore_waiters current )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  ((( &( "lock" ) )) # UInt  |->_)
|--
  “ False ”
.

Definition LinklistResumeAll_safety_wit_7 := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH2 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH3 : (retval = target)) (PreH4 : (addr_aligned retval ALIGN_SIZE )) (PreH5 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH6 : (remaining = (cons (target) (rest)))) (PreH7 : (next = (sched_link_of (target)))) (PreH8 : (target <> 0)) (PreH9 : (addr_aligned target ALIGN_SIZE )) (PreH10 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH11 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH12 : (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH13 : (next <> list_pre)) (PreH14 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH15 : (remaining = (cons (target) (rest)))) (PreH16 : (next = (sched_link_of (target)))) (PreH17 : (next <> list_pre)) (PreH18 : (list_pre <> 0)) (PreH19 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH20 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH21 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (desc.(tdExstatus) ))
  **  (resume_exstatus_restore sg_semaphore_waiters marked target (-1) )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> retval)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  ((( &( "lock" ) )) # UInt  |->_)
|--
  “ (1 <> (INT_MIN)) ”
.

Definition LinklistResumeAll_safety_wit_8 := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH2 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH3 : (retval = target)) (PreH4 : (addr_aligned retval ALIGN_SIZE )) (PreH5 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH6 : (remaining = (cons (target) (rest)))) (PreH7 : (next = (sched_link_of (target)))) (PreH8 : (target <> 0)) (PreH9 : (addr_aligned target ALIGN_SIZE )) (PreH10 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH11 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH12 : (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH13 : (next <> list_pre)) (PreH14 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH15 : (remaining = (cons (target) (rest)))) (PreH16 : (next = (sched_link_of (target)))) (PreH17 : (next <> list_pre)) (PreH18 : (list_pre <> 0)) (PreH19 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH20 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH21 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (desc.(tdExstatus) ))
  **  (resume_exstatus_restore sg_semaphore_waiters marked target (-1) )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> retval)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  ((( &( "lock" ) )) # UInt  |->_)
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition LinklistResumeAll_safety_wit_9 := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (PreH1 : (next = list_pre)) (PreH2 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH3 : (remaining = (@nil Z))) (PreH4 : (next = list_pre)) (PreH5 : (list_pre <> 0)) (PreH6 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH7 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH8 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  (os_inv sg_semaphore_waiters current )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  ((( &( "lock" ) )) # UInt  |->_)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition LinklistResumeAll_entail_wit_1 := 
(
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (PreH1 : (list_pre <> 0)) (PreH2 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH3 : (semaphore_pending_nodes sem_semaphore_waiters before_semaphore_waiters (map (sched_link_node) (waiting_semaphore_waiters)) )) ,
  ((( &( "node" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # UInt  |-> 0)
  **  (os_inv sg_semaphore_waiters before_semaphore_waiters )
|--
  EX (current: VarGlobalState)  (remaining: (@list Z)) ,
  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_waiters))) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current ) ”
  &&  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |->_)
  **  ((( &( "lock" ) )) # UInt  |->_)
  **  (os_inv sg_semaphore_waiters current )
) \/
(
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (PreH1 : (list_pre <> 0)) (PreH2 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH3 : (semaphore_pending_nodes sem_semaphore_waiters before_semaphore_waiters (map (sched_link_node) (waiting_semaphore_waiters)) )) ,
  TT && emp 
|--
  EX (remaining: (@list Z)) ,
  “ (semaphore_pending_nodes sem_semaphore_waiters before_semaphore_waiters (map (sched_link_node) (remaining)) ) ” 
  &&  “ (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining before_semaphore_waiters ) ”
  &&  emp
).

Definition LinklistResumeAll_entail_wit_2 := 
(
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current_2: VarGlobalState) (remaining_2: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (task_id: Z) (retval_2: Z) (woke_desc: TaskDescriptorAbs) (next_state: VarGlobalState) (PreH1 : (retval_2 = 0)) (PreH2 : (target <> 0)) (PreH3 : (((marked.(os_tasks) ).(task_desc_map) (target)) = (Some (woke_desc)))) (PreH4 : (((woke_desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH5 : (wakeup_semaphore_head sem_semaphore_waiters target woke_desc marked next_state )) (PreH6 : (semaphore_pending_nodes sem_semaphore_waiters next_state (map (sched_link_node) (rest)) )) (PreH7 : (remaining_2 = (cons (target) (rest)))) (PreH8 : (semaphore_pending_nodes sem_semaphore_waiters current_2 (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH9 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current_2.(os_tasks) ).(task_desc_map) )))) (current_2)))) (PreH10 : (0 <= task_id)) (PreH11 : (task_id < 65536)) (PreH12 : (get_task_with_idnode_success sg_semaphore_waiters marked task_id target )) (PreH13 : (semaphore_pending_nodes sem_semaphore_waiters marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH14 : (((current_2.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH15 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current_2.(os_tasks) ).(task_desc_map) )))) (current_2)))) (PreH16 : (retval = target)) (PreH17 : (addr_aligned retval ALIGN_SIZE )) (PreH18 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH19 : (remaining_2 = (cons (target) (rest)))) (PreH20 : (next = (sched_link_of (target)))) (PreH21 : (target <> 0)) (PreH22 : (addr_aligned target ALIGN_SIZE )) (PreH23 : (((current_2.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH24 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH25 : (semaphore_pending_nodes sem_semaphore_waiters current_2 (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH26 : (next <> list_pre)) (PreH27 : (semaphore_pending_nodes sem_semaphore_waiters current_2 (map (sched_link_node) (remaining_2)) )) (PreH28 : (remaining_2 = (cons (target) (rest)))) (PreH29 : (next = (sched_link_of (target)))) (PreH30 : (next <> list_pre)) (PreH31 : (list_pre <> 0)) (PreH32 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH33 : (semaphore_pending_nodes sem_semaphore_waiters current_2 (map (sched_link_node) (remaining_2)) )) (PreH34 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining_2 current_2 )) ,
  (os_inv sg_semaphore_waiters next_state )
  **  ((( &( "task" ) )) # Ptr  |-> retval)
  **  ((( &( "node" ) )) # Ptr  |-> next)
|--
  EX (current: VarGlobalState)  (remaining: (@list Z)) ,
  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_waiters))) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current ) ”
  &&  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |->_)
  **  (os_inv sg_semaphore_waiters current )
) \/
(
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current_2: VarGlobalState) (remaining_2: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (task_id: Z) (retval_2: Z) (woke_desc: TaskDescriptorAbs) (next_state: VarGlobalState) (PreH1 : (retval_2 = 0)) (PreH2 : (target <> 0)) (PreH3 : (((marked.(os_tasks) ).(task_desc_map) (target)) = (Some (woke_desc)))) (PreH4 : (((woke_desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH5 : (wakeup_semaphore_head sem_semaphore_waiters target woke_desc marked next_state )) (PreH6 : (semaphore_pending_nodes sem_semaphore_waiters next_state (map (sched_link_node) (rest)) )) (PreH7 : (remaining_2 = (cons (target) (rest)))) (PreH8 : (semaphore_pending_nodes sem_semaphore_waiters current_2 (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH9 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current_2.(os_tasks) ).(task_desc_map) )))) (current_2)))) (PreH10 : (0 <= task_id)) (PreH11 : (task_id < 65536)) (PreH12 : (get_task_with_idnode_success sg_semaphore_waiters marked task_id target )) (PreH13 : (semaphore_pending_nodes sem_semaphore_waiters marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH14 : (((current_2.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH15 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current_2.(os_tasks) ).(task_desc_map) )))) (current_2)))) (PreH16 : (retval = target)) (PreH17 : (addr_aligned retval ALIGN_SIZE )) (PreH18 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH19 : (remaining_2 = (cons (target) (rest)))) (PreH20 : (next = (sched_link_of (target)))) (PreH21 : (target <> 0)) (PreH22 : (addr_aligned target ALIGN_SIZE )) (PreH23 : (((current_2.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH24 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH25 : (semaphore_pending_nodes sem_semaphore_waiters current_2 (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH26 : (next <> list_pre)) (PreH27 : (semaphore_pending_nodes sem_semaphore_waiters current_2 (map (sched_link_node) (remaining_2)) )) (PreH28 : (remaining_2 = (cons (target) (rest)))) (PreH29 : (next = (sched_link_of (target)))) (PreH30 : (next <> list_pre)) (PreH31 : (list_pre <> 0)) (PreH32 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH33 : (semaphore_pending_nodes sem_semaphore_waiters current_2 (map (sched_link_node) (remaining_2)) )) (PreH34 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining_2 current_2 )) ,
  TT && emp 
|--
  EX (remaining: (@list Z)) ,
  “ (semaphore_pending_nodes sem_semaphore_waiters next_state (map (sched_link_node) (remaining)) ) ” 
  &&  “ (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining next_state ) ”
  &&  emp
).

Definition LinklistResumeAll_return_wit_1 := 
(
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (PreH1 : (next = list_pre)) (PreH2 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH3 : (remaining = (@nil Z))) (PreH4 : (next = list_pre)) (PreH5 : (list_pre <> 0)) (PreH6 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH7 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH8 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  (os_inv sg_semaphore_waiters current )
|--
  EX (after: VarGlobalState) ,
  “ (0 = KOK) ” 
  &&  “ (semaphore_resume_all_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters after ) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters after (@nil (@DL_Node Z)) ) ”
  &&  (os_inv sg_semaphore_waiters after )
) \/
(
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (PreH1 : (next = list_pre)) (PreH2 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH3 : (remaining = (@nil Z))) (PreH4 : (next = list_pre)) (PreH5 : (list_pre <> 0)) (PreH6 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH7 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH8 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  TT && emp 
|--
  “ (semaphore_pending_nodes sem_semaphore_waiters current (@nil (@DL_Node Z)) ) ” 
  &&  “ (semaphore_resume_all_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters current ) ” 
  &&  “ (0 = KOK) ”
  &&  emp
).

Definition LinklistResumeAll_return_wit_1_split_goal_1 := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (PreH1 : (next = list_pre)) (PreH2 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH3 : (remaining = (@nil Z))) (PreH4 : (next = list_pre)) (PreH5 : (list_pre <> 0)) (PreH6 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH7 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH8 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  (semaphore_pending_nodes sem_semaphore_waiters current (@nil (@DL_Node Z)) )
.

Definition LinklistResumeAll_return_wit_1_split_goal_2 := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (PreH1 : (next = list_pre)) (PreH2 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH3 : (remaining = (@nil Z))) (PreH4 : (next = list_pre)) (PreH5 : (list_pre <> 0)) (PreH6 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH7 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH8 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  (semaphore_resume_all_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters current )
.

Definition LinklistResumeAll_return_wit_1_split_goal_3 := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (PreH1 : (next = list_pre)) (PreH2 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH3 : (remaining = (@nil Z))) (PreH4 : (next = list_pre)) (PreH5 : (list_pre <> 0)) (PreH6 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH7 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH8 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  (0 = KOK)
.

Definition LinklistResumeAll_partial_solve_wit_1 := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (PreH1 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH2 : (semaphore_pending_nodes sem_semaphore_waiters before_semaphore_waiters (map (sched_link_node) (waiting_semaphore_waiters)) )) ,
  (os_inv sg_semaphore_waiters before_semaphore_waiters )
|--
  “ (list_pre = (semaphore_pending_head (sem_semaphore_waiters))) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters before_semaphore_waiters (map (sched_link_node) (waiting_semaphore_waiters)) ) ”
  &&  (os_inv sg_semaphore_waiters before_semaphore_waiters )
.

Definition LinklistResumeAll_partial_solve_wit_2_pure := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (list_pre <> 0)) (PreH2 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH3 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH4 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |->_)
  **  ((( &( "lock" ) )) # UInt  |->_)
  **  (os_inv sg_semaphore_waiters current )
|--
  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ”
.

Definition LinklistResumeAll_partial_solve_wit_2_aux := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (list_pre <> 0)) (PreH2 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH3 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH4 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  (os_inv sg_semaphore_waiters current )
|--
  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_waiters))) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current ) ”
  &&  (os_inv sg_semaphore_waiters current )
.

Definition LinklistResumeAll_partial_solve_wit_2 := LinklistResumeAll_partial_solve_wit_2_pure -> LinklistResumeAll_partial_solve_wit_2_aux.

Definition LinklistResumeAll_partial_solve_wit_3 := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (first: Z) (tail: (@list Z)) (next: Z) (PreH1 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH2 : (remaining = (cons (first) (tail)))) (PreH3 : (next = (sched_link_of (first)))) (PreH4 : (next <> list_pre)) (PreH5 : (list_pre <> 0)) (PreH6 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH7 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH8 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (resume_next_restore sg_semaphore_waiters current list_pre next )
|--
  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (cons (first) (tail))) ” 
  &&  “ (next = (sched_link_of (first))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_waiters))) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current ) ”
  &&  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (resume_next_restore sg_semaphore_waiters current list_pre next )
.

Definition LinklistResumeAll_partial_solve_wit_4 := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (PreH1 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH2 : (remaining = (@nil Z))) (PreH3 : (next = list_pre)) (PreH4 : (list_pre <> 0)) (PreH5 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH6 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH7 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (resume_next_restore sg_semaphore_waiters current list_pre next )
|--
  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (@nil Z)) ” 
  &&  “ (next = list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_waiters))) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current ) ”
  &&  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (resume_next_restore sg_semaphore_waiters current list_pre next )
.

Definition LinklistResumeAll_partial_solve_wit_5_pure := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (PreH1 : (next <> list_pre)) (PreH2 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH3 : (remaining = (cons (target) (rest)))) (PreH4 : (next = (sched_link_of (target)))) (PreH5 : (next <> list_pre)) (PreH6 : (list_pre <> 0)) (PreH7 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH8 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH9 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  (os_inv sg_semaphore_waiters current )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  ((( &( "lock" ) )) # UInt  |->_)
|--
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ”
.

Definition LinklistResumeAll_partial_solve_wit_5_aux := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (PreH1 : (next <> list_pre)) (PreH2 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH3 : (remaining = (cons (target) (rest)))) (PreH4 : (next = (sched_link_of (target)))) (PreH5 : (next <> list_pre)) (PreH6 : (list_pre <> 0)) (PreH7 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH8 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH9 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  (os_inv sg_semaphore_waiters current )
|--
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_waiters))) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current ) ”
  &&  (os_inv sg_semaphore_waiters current )
.

Definition LinklistResumeAll_partial_solve_wit_5 := LinklistResumeAll_partial_solve_wit_5_pure -> LinklistResumeAll_partial_solve_wit_5_aux.

Definition LinklistResumeAll_partial_solve_wit_6_pure := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (next = (sched_link_of (target)))) (PreH3 : (target <> 0)) (PreH4 : (addr_aligned target ALIGN_SIZE )) (PreH5 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH6 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH7 : (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH8 : (next <> list_pre)) (PreH9 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH10 : (remaining = (cons (target) (rest)))) (PreH11 : (next = (sched_link_of (target)))) (PreH12 : (next <> list_pre)) (PreH13 : (list_pre <> 0)) (PreH14 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH15 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH16 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  (os_inv sg_semaphore_waiters current )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  ((( &( "lock" ) )) # UInt  |->_)
|--
  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (next = (sched_link_of (target))) ”
.

Definition LinklistResumeAll_partial_solve_wit_6_aux := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (next = (sched_link_of (target)))) (PreH3 : (target <> 0)) (PreH4 : (addr_aligned target ALIGN_SIZE )) (PreH5 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH6 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH7 : (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH8 : (next <> list_pre)) (PreH9 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH10 : (remaining = (cons (target) (rest)))) (PreH11 : (next = (sched_link_of (target)))) (PreH12 : (next <> list_pre)) (PreH13 : (list_pre <> 0)) (PreH14 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH15 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH16 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  (os_inv sg_semaphore_waiters current )
|--
  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (target <> 0) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_waiters))) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current ) ”
  &&  (os_inv sg_semaphore_waiters current )
.

Definition LinklistResumeAll_partial_solve_wit_6 := LinklistResumeAll_partial_solve_wit_6_pure -> LinklistResumeAll_partial_solve_wit_6_aux.

Definition LinklistResumeAll_partial_solve_wit_7_pure := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (PreH1 : (retval = target)) (PreH2 : (addr_aligned retval ALIGN_SIZE )) (PreH3 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH4 : (remaining = (cons (target) (rest)))) (PreH5 : (next = (sched_link_of (target)))) (PreH6 : (target <> 0)) (PreH7 : (addr_aligned target ALIGN_SIZE )) (PreH8 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH9 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH10 : (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH11 : (next <> list_pre)) (PreH12 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH13 : (remaining = (cons (target) (rest)))) (PreH14 : (next = (sched_link_of (target)))) (PreH15 : (next <> list_pre)) (PreH16 : (list_pre <> 0)) (PreH17 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH18 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH19 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  (os_inv sg_semaphore_waiters current )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> retval)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  ((( &( "lock" ) )) # UInt  |->_)
|--
  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ”
.

Definition LinklistResumeAll_partial_solve_wit_7_aux := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (PreH1 : (retval = target)) (PreH2 : (addr_aligned retval ALIGN_SIZE )) (PreH3 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH4 : (remaining = (cons (target) (rest)))) (PreH5 : (next = (sched_link_of (target)))) (PreH6 : (target <> 0)) (PreH7 : (addr_aligned target ALIGN_SIZE )) (PreH8 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH9 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH10 : (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH11 : (next <> list_pre)) (PreH12 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH13 : (remaining = (cons (target) (rest)))) (PreH14 : (next = (sched_link_of (target)))) (PreH15 : (next <> list_pre)) (PreH16 : (list_pre <> 0)) (PreH17 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH18 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH19 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  (os_inv sg_semaphore_waiters current )
|--
  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (retval = target) ” 
  &&  “ (addr_aligned retval ALIGN_SIZE ) ” 
  &&  “ (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (target <> 0) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_waiters))) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current ) ”
  &&  (os_inv sg_semaphore_waiters current )
.

Definition LinklistResumeAll_partial_solve_wit_7 := LinklistResumeAll_partial_solve_wit_7_pure -> LinklistResumeAll_partial_solve_wit_7_aux.

Definition LinklistResumeAll_partial_solve_wit_8 := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH2 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH3 : (retval = target)) (PreH4 : (addr_aligned retval ALIGN_SIZE )) (PreH5 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH6 : (remaining = (cons (target) (rest)))) (PreH7 : (next = (sched_link_of (target)))) (PreH8 : (target <> 0)) (PreH9 : (addr_aligned target ALIGN_SIZE )) (PreH10 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH11 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH12 : (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH13 : (next <> list_pre)) (PreH14 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH15 : (remaining = (cons (target) (rest)))) (PreH16 : (next = (sched_link_of (target)))) (PreH17 : (next <> list_pre)) (PreH18 : (list_pre <> 0)) (PreH19 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH20 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH21 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (desc.(tdExstatus) ))
  **  (resume_exstatus_restore sg_semaphore_waiters marked target (-1) )
|--
  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (retval = target) ” 
  &&  “ (addr_aligned retval ALIGN_SIZE ) ” 
  &&  “ (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (target <> 0) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_waiters))) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current ) ”
  &&  ((&((retval)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |->_)
  **  (resume_exstatus_restore sg_semaphore_waiters marked target (-1) )
.

Definition LinklistResumeAll_partial_solve_wit_9 := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH2 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH3 : (retval = target)) (PreH4 : (addr_aligned retval ALIGN_SIZE )) (PreH5 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH6 : (remaining = (cons (target) (rest)))) (PreH7 : (next = (sched_link_of (target)))) (PreH8 : (target <> 0)) (PreH9 : (addr_aligned target ALIGN_SIZE )) (PreH10 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH11 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH12 : (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH13 : (next <> list_pre)) (PreH14 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH15 : (remaining = (cons (target) (rest)))) (PreH16 : (next = (sched_link_of (target)))) (PreH17 : (next <> list_pre)) (PreH18 : (list_pre <> 0)) (PreH19 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH20 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH21 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  ((&((retval)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (-1))
  **  (resume_exstatus_restore sg_semaphore_waiters marked target (-1) )
|--
  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (retval = target) ” 
  &&  “ (addr_aligned retval ALIGN_SIZE ) ” 
  &&  “ (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (target <> 0) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_waiters))) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current ) ”
  &&  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (-1))
  **  (resume_exstatus_restore sg_semaphore_waiters marked target (-1) )
.

Definition LinklistResumeAll_partial_solve_wit_10_pure := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH2 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH3 : (retval = target)) (PreH4 : (addr_aligned retval ALIGN_SIZE )) (PreH5 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH6 : (remaining = (cons (target) (rest)))) (PreH7 : (next = (sched_link_of (target)))) (PreH8 : (target <> 0)) (PreH9 : (addr_aligned target ALIGN_SIZE )) (PreH10 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH11 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH12 : (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH13 : (next <> list_pre)) (PreH14 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH15 : (remaining = (cons (target) (rest)))) (PreH16 : (next = (sched_link_of (target)))) (PreH17 : (next <> list_pre)) (PreH18 : (list_pre <> 0)) (PreH19 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH20 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH21 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  (os_inv sg_semaphore_waiters marked )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> retval)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  ((( &( "lock" ) )) # UInt  |->_)
|--
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ”
.

Definition LinklistResumeAll_partial_solve_wit_10_aux := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH2 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH3 : (retval = target)) (PreH4 : (addr_aligned retval ALIGN_SIZE )) (PreH5 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH6 : (remaining = (cons (target) (rest)))) (PreH7 : (next = (sched_link_of (target)))) (PreH8 : (target <> 0)) (PreH9 : (addr_aligned target ALIGN_SIZE )) (PreH10 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH11 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH12 : (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH13 : (next <> list_pre)) (PreH14 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH15 : (remaining = (cons (target) (rest)))) (PreH16 : (next = (sched_link_of (target)))) (PreH17 : (next <> list_pre)) (PreH18 : (list_pre <> 0)) (PreH19 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH20 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH21 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  (os_inv sg_semaphore_waiters marked )
|--
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (retval = target) ” 
  &&  “ (addr_aligned retval ALIGN_SIZE ) ” 
  &&  “ (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (target <> 0) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_waiters))) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current ) ”
  &&  (os_inv sg_semaphore_waiters marked )
.

Definition LinklistResumeAll_partial_solve_wit_10 := LinklistResumeAll_partial_solve_wit_10_pure -> LinklistResumeAll_partial_solve_wit_10_aux.

Definition LinklistResumeAll_partial_solve_wit_11 := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (task_id: Z) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH3 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH4 : (0 <= task_id)) (PreH5 : (task_id < 65536)) (PreH6 : (get_task_with_idnode_success sg_semaphore_waiters marked task_id target )) (PreH7 : (semaphore_pending_nodes sem_semaphore_waiters marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH8 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH9 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH10 : (retval = target)) (PreH11 : (addr_aligned retval ALIGN_SIZE )) (PreH12 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH13 : (remaining = (cons (target) (rest)))) (PreH14 : (next = (sched_link_of (target)))) (PreH15 : (target <> 0)) (PreH16 : (addr_aligned target ALIGN_SIZE )) (PreH17 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH18 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH19 : (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH20 : (next <> list_pre)) (PreH21 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH22 : (remaining = (cons (target) (rest)))) (PreH23 : (next = (sched_link_of (target)))) (PreH24 : (next <> list_pre)) (PreH25 : (list_pre <> 0)) (PreH26 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH27 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH28 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (resume_id_restore sg_semaphore_waiters marked target task_id )
|--
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (0 <= task_id) ” 
  &&  “ (task_id < 65536) ” 
  &&  “ (get_task_with_idnode_success sg_semaphore_waiters marked task_id target ) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (retval = target) ” 
  &&  “ (addr_aligned retval ALIGN_SIZE ) ” 
  &&  “ (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (target <> 0) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_waiters))) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current ) ”
  &&  ((&((retval)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (resume_id_restore sg_semaphore_waiters marked target task_id )
.

Definition LinklistResumeAll_partial_solve_wit_12 := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (task_id: Z) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH3 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH4 : (0 <= task_id)) (PreH5 : (task_id < 65536)) (PreH6 : (get_task_with_idnode_success sg_semaphore_waiters marked task_id target )) (PreH7 : (semaphore_pending_nodes sem_semaphore_waiters marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH8 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH9 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH10 : (retval = target)) (PreH11 : (addr_aligned retval ALIGN_SIZE )) (PreH12 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH13 : (remaining = (cons (target) (rest)))) (PreH14 : (next = (sched_link_of (target)))) (PreH15 : (target <> 0)) (PreH16 : (addr_aligned target ALIGN_SIZE )) (PreH17 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH18 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH19 : (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH20 : (next <> list_pre)) (PreH21 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH22 : (remaining = (cons (target) (rest)))) (PreH23 : (next = (sched_link_of (target)))) (PreH24 : (next <> list_pre)) (PreH25 : (list_pre <> 0)) (PreH26 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH27 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH28 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  ((&((retval)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (resume_id_restore sg_semaphore_waiters marked target task_id )
|--
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (0 <= task_id) ” 
  &&  “ (task_id < 65536) ” 
  &&  “ (get_task_with_idnode_success sg_semaphore_waiters marked task_id target ) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (retval = target) ” 
  &&  “ (addr_aligned retval ALIGN_SIZE ) ” 
  &&  “ (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (target <> 0) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_waiters))) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current ) ”
  &&  ((&((target)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (resume_id_restore sg_semaphore_waiters marked target task_id )
.

Definition LinklistResumeAll_partial_solve_wit_13_pure := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (task_id: Z) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH3 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH4 : (0 <= task_id)) (PreH5 : (task_id < 65536)) (PreH6 : (get_task_with_idnode_success sg_semaphore_waiters marked task_id target )) (PreH7 : (semaphore_pending_nodes sem_semaphore_waiters marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH8 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH9 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH10 : (retval = target)) (PreH11 : (addr_aligned retval ALIGN_SIZE )) (PreH12 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH13 : (remaining = (cons (target) (rest)))) (PreH14 : (next = (sched_link_of (target)))) (PreH15 : (target <> 0)) (PreH16 : (addr_aligned target ALIGN_SIZE )) (PreH17 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH18 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH19 : (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH20 : (next <> list_pre)) (PreH21 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH22 : (remaining = (cons (target) (rest)))) (PreH23 : (next = (sched_link_of (target)))) (PreH24 : (next <> list_pre)) (PreH25 : (list_pre <> 0)) (PreH26 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH27 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH28 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  (os_inv sg_semaphore_waiters marked )
  **  ((( &( "resume_task_id" ) )) # Int  |-> task_id)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> retval)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  ((( &( "lock" ) )) # UInt  |->_)
|--
  “ (task_id < 65536) ” 
  &&  “ (get_task_with_idnode_success sg_semaphore_waiters marked task_id target ) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ”
.

Definition LinklistResumeAll_partial_solve_wit_13_aux := 
forall (list_pre: Z) (waiting_semaphore_waiters: (@list Z)) (sem_semaphore_waiters: Z) (before_semaphore_waiters: VarGlobalState) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (task_id: Z) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH3 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH4 : (0 <= task_id)) (PreH5 : (task_id < 65536)) (PreH6 : (get_task_with_idnode_success sg_semaphore_waiters marked task_id target )) (PreH7 : (semaphore_pending_nodes sem_semaphore_waiters marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH8 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH9 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH10 : (retval = target)) (PreH11 : (addr_aligned retval ALIGN_SIZE )) (PreH12 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH13 : (remaining = (cons (target) (rest)))) (PreH14 : (next = (sched_link_of (target)))) (PreH15 : (target <> 0)) (PreH16 : (addr_aligned target ALIGN_SIZE )) (PreH17 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH18 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH19 : (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH20 : (next <> list_pre)) (PreH21 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH22 : (remaining = (cons (target) (rest)))) (PreH23 : (next = (sched_link_of (target)))) (PreH24 : (next <> list_pre)) (PreH25 : (list_pre <> 0)) (PreH26 : (list_pre = (semaphore_pending_head (sem_semaphore_waiters)))) (PreH27 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) (PreH28 : (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current )) ,
  (os_inv sg_semaphore_waiters marked )
|--
  “ (task_id < 65536) ” 
  &&  “ (get_task_with_idnode_success sg_semaphore_waiters marked task_id target ) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (0 <= task_id) ” 
  &&  “ (task_id < 65536) ” 
  &&  “ (get_task_with_idnode_success sg_semaphore_waiters marked task_id target ) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (retval = target) ” 
  &&  “ (addr_aligned retval ALIGN_SIZE ) ” 
  &&  “ (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (target <> 0) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_waiters))) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (resume_remaining_effect sem_semaphore_waiters waiting_semaphore_waiters before_semaphore_waiters remaining current ) ”
  &&  (os_inv sg_semaphore_waiters marked )
.

Definition LinklistResumeAll_partial_solve_wit_13 := LinklistResumeAll_partial_solve_wit_13_pure -> LinklistResumeAll_partial_solve_wit_13_aux.

Definition LinklistResumeAll_which_implies_wit_1 := 
forall (list_pre: Z) (sem_semaphore_waiters: Z) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) ,
  (os_inv sg_semaphore_waiters current )
|--
  (EX (next: Z) ,
  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (@nil Z)) ” 
  &&  “ (next = list_pre) ”
  &&  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (resume_next_restore sg_semaphore_waiters current list_pre next ))
  ||
  (EX (next: Z)  (first: Z)  (tail: (@list Z)) ,
  “ (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) ) ” 
  &&  “ (remaining = (cons (first) (tail))) ” 
  &&  “ (next = (sched_link_of (first))) ” 
  &&  “ (next <> list_pre) ”
  &&  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (resume_next_restore sg_semaphore_waiters current list_pre next ))
.

Definition LinklistResumeAll_which_implies_wit_2 := 
(
forall (list_pre: Z) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (next: Z) ,
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (resume_next_restore sg_semaphore_waiters current list_pre next )
|--
  (os_inv sg_semaphore_waiters current )
) \/
(
forall (list_pre: Z) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (next: Z) ,
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (resume_next_restore sg_semaphore_waiters current list_pre next )
|--
  (os_inv sg_semaphore_waiters current )
).

Definition LinklistResumeAll_which_implies_wit_2_split_goal_spatial := 
forall (list_pre: Z) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (next: Z) ,
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (resume_next_restore sg_semaphore_waiters current list_pre next )
|--
  (os_inv sg_semaphore_waiters current )
.

Definition LinklistResumeAll_which_implies_wit_3 := 
(
forall (sem_semaphore_waiters: Z) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (next = (sched_link_of (target)))) (PreH3 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) ,
  (os_inv sg_semaphore_waiters current )
|--
  EX (desc: TaskDescriptorAbs) ,
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (target <> 0) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ”
  &&  (os_inv sg_semaphore_waiters current )
) \/
(
forall (sem_semaphore_waiters: Z) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (next = (sched_link_of (target)))) (PreH3 : (semaphore_pending_nodes sem_semaphore_waiters current (map (sched_link_node) (remaining)) )) ,
  TT && emp 
|--
  EX (desc: TaskDescriptorAbs) ,
  “ (target <> 0) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ”
  &&  emp
).

Definition LinklistResumeAll_which_implies_wit_4 := 
(
forall (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (target: Z) (desc: TaskDescriptorAbs) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) ,
  (os_inv sg_semaphore_waiters current )
|--
  EX (marked: VarGlobalState) ,
  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ”
  &&  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (desc.(tdExstatus) ))
  **  (resume_exstatus_restore sg_semaphore_waiters marked target (-1) )
) \/
(
forall (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (target: Z) (desc: TaskDescriptorAbs) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) ,
  (os_inv sg_semaphore_waiters current )
|--
  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (desc.(tdExstatus) ))
  **  (resume_exstatus_restore sg_semaphore_waiters (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)) target (-1) )
).

Definition LinklistResumeAll_which_implies_wit_4_split_goal_spatial := 
forall (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (target: Z) (desc: TaskDescriptorAbs) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) ,
  (os_inv sg_semaphore_waiters current )
|--
  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (desc.(tdExstatus) ))
  **  (resume_exstatus_restore sg_semaphore_waiters (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)) target (-1) )
.

Definition LinklistResumeAll_which_implies_wit_5 := 
(
forall (sg_semaphore_waiters: StableGlobalState) (target: Z) (marked: VarGlobalState) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (-1))
  **  (resume_exstatus_restore sg_semaphore_waiters marked target (-1) )
|--
  (os_inv sg_semaphore_waiters marked )
) \/
(
forall (sg_semaphore_waiters: StableGlobalState) (target: Z) (marked: VarGlobalState) (PreH1 : ((-1) <= INT_MAX)) (PreH2 : ((-1) >= INT_MIN)) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (-1))
  **  (resume_exstatus_restore sg_semaphore_waiters marked target (-1) )
|--
  (os_inv sg_semaphore_waiters marked )
).

Definition LinklistResumeAll_which_implies_wit_5_split_goal_spatial := 
forall (sg_semaphore_waiters: StableGlobalState) (target: Z) (marked: VarGlobalState) (PreH1 : ((-1) <= INT_MAX)) (PreH2 : ((-1) >= INT_MIN)) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (-1))
  **  (resume_exstatus_restore sg_semaphore_waiters marked target (-1) )
|--
  (os_inv sg_semaphore_waiters marked )
.

Definition LinklistResumeAll_which_implies_wit_6 := 
(
forall (sem_semaphore_waiters: Z) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (marked: VarGlobalState) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH3 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) ,
  (os_inv sg_semaphore_waiters marked )
|--
  EX (task_id: Z) ,
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (0 <= task_id) ” 
  &&  “ (task_id < 65536) ” 
  &&  “ (get_task_with_idnode_success sg_semaphore_waiters marked task_id target ) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ”
  &&  ((&((target)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (resume_id_restore sg_semaphore_waiters marked target task_id )
) \/
(
forall (sem_semaphore_waiters: Z) (sg_semaphore_waiters: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (marked: VarGlobalState) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) )) (PreH3 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) ,
  (os_inv sg_semaphore_waiters marked )
|--
  EX (task_id: Z) ,
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters current (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (0 <= task_id) ” 
  &&  “ (task_id < 65536) ” 
  &&  “ (get_task_with_idnode_success sg_semaphore_waiters marked task_id target ) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_waiters marked (cons ((sched_link_node (target))) ((map (sched_link_node) (rest)))) ) ”
  &&  ((&((target)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (resume_id_restore sg_semaphore_waiters marked target task_id )
).

Definition LinklistResumeAll_which_implies_wit_7 := 
(
forall (sg_semaphore_waiters: StableGlobalState) (target: Z) (marked: VarGlobalState) (task_id: Z) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (resume_id_restore sg_semaphore_waiters marked target task_id )
|--
  (os_inv sg_semaphore_waiters marked )
) \/
(
forall (sg_semaphore_waiters: StableGlobalState) (target: Z) (marked: VarGlobalState) (task_id: Z) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (resume_id_restore sg_semaphore_waiters marked target task_id )
|--
  (os_inv sg_semaphore_waiters marked )
).

Definition LinklistResumeAll_which_implies_wit_7_split_goal_spatial := 
forall (sg_semaphore_waiters: StableGlobalState) (target: Z) (marked: VarGlobalState) (task_id: Z) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (resume_id_restore sg_semaphore_waiters marked target task_id )
|--
  (os_inv sg_semaphore_waiters marked )
.

Definition KTaskWakeup_derive_msgqueue_recv_pending_head_ic_by_wakeup_by_id_ic := 
forall (id_pre: Z) (rest_msgqueue_recv_pending_head_ic: (@list (@DL_Node Z))) (task_msgqueue_recv_pending_head_ic: Z) (mq_msgqueue_recv_pending_head_ic: Z) (before_msgqueue_recv_pending_head_ic: VarGlobalState) (sg_msgqueue_recv_pending_head_ic: StableGlobalState) ,
  “ (id_pre < 65536) ” 
  &&  “ (get_task_with_idnode_success sg_msgqueue_recv_pending_head_ic before_msgqueue_recv_pending_head_ic id_pre task_msgqueue_recv_pending_head_ic ) ” 
  &&  “ (msgqueue_recv_pending_nodes mq_msgqueue_recv_pending_head_ic before_msgqueue_recv_pending_head_ic (cons ((sched_link_node (task_msgqueue_recv_pending_head_ic))) (rest_msgqueue_recv_pending_head_ic)) ) ”
  &&  (os_inv sg_msgqueue_recv_pending_head_ic before_msgqueue_recv_pending_head_ic )
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
  &&  “ (task_msgqueue_recv_pending_head_ic <> 0) ” 
  &&  “ (((before_msgqueue_recv_pending_head_ic.(os_tasks) ).(task_desc_map) (task_msgqueue_recv_pending_head_ic)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (wakeup_msgqueue_recv_head mq_msgqueue_recv_pending_head_ic task_msgqueue_recv_pending_head_ic desc before_msgqueue_recv_pending_head_ic after ) ” 
  &&  “ (msgqueue_recv_pending_nodes mq_msgqueue_recv_pending_head_ic after rest_msgqueue_recv_pending_head_ic ) ”
  &&  (os_inv sg_msgqueue_recv_pending_head_ic after )))
.

Definition KTaskWakeup_derive_msgqueue_send_pending_head_ic_by_wakeup_by_id_ic := 
forall (id_pre: Z) (rest_msgqueue_send_pending_head_ic: (@list (@DL_Node Z))) (task_msgqueue_send_pending_head_ic: Z) (mq_msgqueue_send_pending_head_ic: Z) (before_msgqueue_send_pending_head_ic: VarGlobalState) (sg_msgqueue_send_pending_head_ic: StableGlobalState) ,
  “ (id_pre < 65536) ” 
  &&  “ (get_task_with_idnode_success sg_msgqueue_send_pending_head_ic before_msgqueue_send_pending_head_ic id_pre task_msgqueue_send_pending_head_ic ) ” 
  &&  “ (msgqueue_send_pending_nodes mq_msgqueue_send_pending_head_ic before_msgqueue_send_pending_head_ic (cons ((sched_link_node (task_msgqueue_send_pending_head_ic))) (rest_msgqueue_send_pending_head_ic)) ) ”
  &&  (os_inv sg_msgqueue_send_pending_head_ic before_msgqueue_send_pending_head_ic )
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
  &&  “ (task_msgqueue_send_pending_head_ic <> 0) ” 
  &&  “ (((before_msgqueue_send_pending_head_ic.(os_tasks) ).(task_desc_map) (task_msgqueue_send_pending_head_ic)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (wakeup_msgqueue_send_head mq_msgqueue_send_pending_head_ic task_msgqueue_send_pending_head_ic desc before_msgqueue_send_pending_head_ic after ) ” 
  &&  “ (msgqueue_send_pending_nodes mq_msgqueue_send_pending_head_ic after rest_msgqueue_send_pending_head_ic ) ”
  &&  (os_inv sg_msgqueue_send_pending_head_ic after )))
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
Axiom proof_of_LinklistResumeAll_entail_wit_1 : LinklistResumeAll_entail_wit_1.
Axiom proof_of_LinklistResumeAll_entail_wit_2 : LinklistResumeAll_entail_wit_2.
Axiom proof_of_LinklistResumeAll_return_wit_1 : LinklistResumeAll_return_wit_1.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_1 : LinklistResumeAll_partial_solve_wit_1.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_2_pure : LinklistResumeAll_partial_solve_wit_2_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_2 : LinklistResumeAll_partial_solve_wit_2.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_3 : LinklistResumeAll_partial_solve_wit_3.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_4 : LinklistResumeAll_partial_solve_wit_4.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_5_pure : LinklistResumeAll_partial_solve_wit_5_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_5 : LinklistResumeAll_partial_solve_wit_5.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_6_pure : LinklistResumeAll_partial_solve_wit_6_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_6 : LinklistResumeAll_partial_solve_wit_6.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_7_pure : LinklistResumeAll_partial_solve_wit_7_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_7 : LinklistResumeAll_partial_solve_wit_7.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_8 : LinklistResumeAll_partial_solve_wit_8.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_9 : LinklistResumeAll_partial_solve_wit_9.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_10_pure : LinklistResumeAll_partial_solve_wit_10_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_10 : LinklistResumeAll_partial_solve_wit_10.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_11 : LinklistResumeAll_partial_solve_wit_11.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_12 : LinklistResumeAll_partial_solve_wit_12.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_13_pure : LinklistResumeAll_partial_solve_wit_13_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_13 : LinklistResumeAll_partial_solve_wit_13.
Axiom proof_of_LinklistResumeAll_which_implies_wit_1 : LinklistResumeAll_which_implies_wit_1.
Axiom proof_of_LinklistResumeAll_which_implies_wit_2 : LinklistResumeAll_which_implies_wit_2.
Axiom proof_of_LinklistResumeAll_which_implies_wit_3 : LinklistResumeAll_which_implies_wit_3.
Axiom proof_of_LinklistResumeAll_which_implies_wit_4 : LinklistResumeAll_which_implies_wit_4.
Axiom proof_of_LinklistResumeAll_which_implies_wit_5 : LinklistResumeAll_which_implies_wit_5.
Axiom proof_of_LinklistResumeAll_which_implies_wit_6 : LinklistResumeAll_which_implies_wit_6.
Axiom proof_of_LinklistResumeAll_which_implies_wit_7 : LinklistResumeAll_which_implies_wit_7.
Axiom proof_of_KTaskWakeup_derive_msgqueue_recv_pending_head_ic_by_wakeup_by_id_ic : KTaskWakeup_derive_msgqueue_recv_pending_head_ic_by_wakeup_by_id_ic.
Axiom proof_of_KTaskWakeup_derive_msgqueue_send_pending_head_ic_by_wakeup_by_id_ic : KTaskWakeup_derive_msgqueue_send_pending_head_ic_by_wakeup_by_id_ic.
Axiom proof_of_KTaskWakeup_derive_semaphore_pending_head_ic_by_wakeup_by_id_ic : KTaskWakeup_derive_semaphore_pending_head_ic_by_wakeup_by_id_ic.
Axiom proof_of_KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic : KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic.

End VC_Correct.
