From SimpleC.Verification Require Import VCPrelude.
Require Import CRTOS_Verify.lib.id.IdModuleSpec.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreDelete CRTOS_Verify.lib.delay.KTaskUnSetDelay.
Require Import CRTOS_Verify.lib.list.DoubleLinkListSpec CRTOS_Verify.lib.task.TaskStatusMemory CRTOS_Verify.lib.task.KTaskParseInfo.
Import IDNode DLL.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreAbandon.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreObtain.
Import SimpleC.CoreLang.CTypes.SimpleCtypeNotations.
Local Open Scope sac.

(*----- Function LinklistResume -----*)

Definition LinklistResume_safety_wit_1 :=
forall (waiting_semaphore_head_ic: (@list Z)) (sem_semaphore_head_ic: Z) (before_semaphore_head_ic: VarGlobalState) (sg_semaphore_head_ic: StableGlobalState) (list_pre: Z) (PreH1 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH2 : (waiting_semaphore_head_ic <> (@nil Z))) (PreH3 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (map (sched_link_node) (waiting_semaphore_head_ic)) )),
  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  (os_inv sg_semaphore_head_ic before_semaphore_head_ic )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition LinklistResume_safety_wit_2 :=
forall (waiting_semaphore_head_ic: (@list Z)) (sem_semaphore_head_ic: Z) (before_semaphore_head_ic: VarGlobalState) (sg_semaphore_head_ic: StableGlobalState) (list_pre: Z) (first: Z) (rest: (@list Z)) (retval: Z) (task_id: Z) (after: VarGlobalState) (desc: TaskDescriptorAbs) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : (first <> 0)) (PreH3 : (((before_semaphore_head_ic.(os_tasks) ).(task_desc_map) (first)) = (Some (desc)))) (PreH4 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH5 : (wakeup_semaphore_head sem_semaphore_head_ic first desc before_semaphore_head_ic after )) (PreH6 : (semaphore_pending_nodes sem_semaphore_head_ic after (map (sched_link_node) (rest)) )) (PreH7 : (0 <= task_id)) (PreH8 : (task_id < 65536)) (PreH9 : (get_task_with_idnode_success sg_semaphore_head_ic before_semaphore_head_ic task_id first )) (PreH10 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) )) (PreH11 : (retval = first)) (PreH12 : (addr_aligned retval 4 )) (PreH13 : ((sched_link_of (first)) = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH14 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH15 : (waiting_semaphore_head_ic = (cons (first) (rest)))) (PreH16 : (addr_aligned first 4 )) (PreH17 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) )) (PreH18 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH19 : (waiting_semaphore_head_ic <> (@nil Z))) (PreH20 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (map (sched_link_node) (waiting_semaphore_head_ic)) )),
  (os_inv sg_semaphore_head_ic after )
  **  ((( &( "task" ) )) # Ptr  |-> first)
  **  ((( &( "resume_task_id" ) )) # Int  |-> task_id)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition LinklistResume_return_wit_1 :=
(
forall (waiting_semaphore_head_ic: (@list Z)) (sem_semaphore_head_ic: Z) (before_semaphore_head_ic: VarGlobalState) (sg_semaphore_head_ic: StableGlobalState) (list_pre: Z) (first: Z) (rest: (@list Z)) (retval: Z) (task_id: Z) (after_2: VarGlobalState) (desc: TaskDescriptorAbs) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : (first <> 0)) (PreH3 : (((before_semaphore_head_ic.(os_tasks) ).(task_desc_map) (first)) = (Some (desc)))) (PreH4 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH5 : (wakeup_semaphore_head sem_semaphore_head_ic first desc before_semaphore_head_ic after_2 )) (PreH6 : (semaphore_pending_nodes sem_semaphore_head_ic after_2 (map (sched_link_node) (rest)) )) (PreH7 : (0 <= task_id)) (PreH8 : (task_id < 65536)) (PreH9 : (get_task_with_idnode_success sg_semaphore_head_ic before_semaphore_head_ic task_id first )) (PreH10 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) )) (PreH11 : (retval = first)) (PreH12 : (addr_aligned retval 4 )) (PreH13 : ((sched_link_of (first)) = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH14 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH15 : (waiting_semaphore_head_ic = (cons (first) (rest)))) (PreH16 : (addr_aligned first 4 )) (PreH17 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) )) (PreH18 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH19 : (waiting_semaphore_head_ic <> (@nil Z))) (PreH20 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (map (sched_link_node) (waiting_semaphore_head_ic)) )),
  (os_inv sg_semaphore_head_ic after_2 )
|--
  EX (after: VarGlobalState),
  “ (0 = 0) ”
  &&  “ (semaphore_resume_head_effect sem_semaphore_head_ic before_semaphore_head_ic after ) ”
  &&  (os_inv sg_semaphore_head_ic after )
) \/
(
forall (waiting_semaphore_head_ic: (@list Z)) (sem_semaphore_head_ic: Z) (before_semaphore_head_ic: VarGlobalState) (sg_semaphore_head_ic: StableGlobalState) (list_pre: Z) (first: Z) (rest: (@list Z)) (retval: Z) (task_id: Z) (after_2: VarGlobalState) (desc: TaskDescriptorAbs) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : (first <> 0)) (PreH3 : (((before_semaphore_head_ic.(os_tasks) ).(task_desc_map) (first)) = (Some (desc)))) (PreH4 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH5 : (wakeup_semaphore_head sem_semaphore_head_ic first desc before_semaphore_head_ic after_2 )) (PreH6 : (semaphore_pending_nodes sem_semaphore_head_ic after_2 (map (sched_link_node) (rest)) )) (PreH7 : (0 <= task_id)) (PreH8 : (task_id < 65536)) (PreH9 : (get_task_with_idnode_success sg_semaphore_head_ic before_semaphore_head_ic task_id first )) (PreH10 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) )) (PreH11 : (retval = first)) (PreH12 : (addr_aligned retval 4 )) (PreH13 : ((sched_link_of (first)) = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH14 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH15 : (waiting_semaphore_head_ic = (cons (first) (rest)))) (PreH16 : (addr_aligned first 4 )) (PreH17 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) )) (PreH18 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH19 : (waiting_semaphore_head_ic <> (@nil Z))) (PreH20 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (map (sched_link_node) (waiting_semaphore_head_ic)) )),
  TT && emp 
|--
  “ (semaphore_resume_head_effect sem_semaphore_head_ic before_semaphore_head_ic after_2 ) ”
  &&  emp
).

Definition LinklistResume_return_wit_1_split_goal_1 :=
forall (waiting_semaphore_head_ic: (@list Z)) (sem_semaphore_head_ic: Z) (before_semaphore_head_ic: VarGlobalState) (sg_semaphore_head_ic: StableGlobalState) (list_pre: Z) (first: Z) (rest: (@list Z)) (retval: Z) (task_id: Z) (after_2: VarGlobalState) (desc: TaskDescriptorAbs) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : (first <> 0)) (PreH3 : (((before_semaphore_head_ic.(os_tasks) ).(task_desc_map) (first)) = (Some (desc)))) (PreH4 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH5 : (wakeup_semaphore_head sem_semaphore_head_ic first desc before_semaphore_head_ic after_2 )) (PreH6 : (semaphore_pending_nodes sem_semaphore_head_ic after_2 (map (sched_link_node) (rest)) )) (PreH7 : (0 <= task_id)) (PreH8 : (task_id < 65536)) (PreH9 : (get_task_with_idnode_success sg_semaphore_head_ic before_semaphore_head_ic task_id first )) (PreH10 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) )) (PreH11 : (retval = first)) (PreH12 : (addr_aligned retval 4 )) (PreH13 : ((sched_link_of (first)) = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH14 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH15 : (waiting_semaphore_head_ic = (cons (first) (rest)))) (PreH16 : (addr_aligned first 4 )) (PreH17 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) )) (PreH18 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH19 : (waiting_semaphore_head_ic <> (@nil Z))) (PreH20 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (map (sched_link_node) (waiting_semaphore_head_ic)) )),
  (semaphore_resume_head_effect sem_semaphore_head_ic before_semaphore_head_ic after_2 )
.

Definition LinklistResume_partial_solve_wit_1_pure :=
forall (waiting_semaphore_head_ic: (@list Z)) (sem_semaphore_head_ic: Z) (before_semaphore_head_ic: VarGlobalState) (sg_semaphore_head_ic: StableGlobalState) (list_pre: Z) (PreH1 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH2 : (waiting_semaphore_head_ic <> (@nil Z))) (PreH3 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (map (sched_link_node) (waiting_semaphore_head_ic)) )),
  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  (os_inv sg_semaphore_head_ic before_semaphore_head_ic )
|--
  “ (list_pre = (semaphore_pending_head (sem_semaphore_head_ic))) ”
  &&  “ (waiting_semaphore_head_ic <> (@nil Z)) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (map (sched_link_node) (waiting_semaphore_head_ic)) ) ”
.

Definition LinklistResume_partial_solve_wit_1_aux :=
forall (waiting_semaphore_head_ic: (@list Z)) (sem_semaphore_head_ic: Z) (before_semaphore_head_ic: VarGlobalState) (sg_semaphore_head_ic: StableGlobalState) (list_pre: Z) (PreH1 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH2 : (waiting_semaphore_head_ic <> (@nil Z))) (PreH3 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (map (sched_link_node) (waiting_semaphore_head_ic)) )),
  (os_inv sg_semaphore_head_ic before_semaphore_head_ic )
|--
  “ (list_pre = (semaphore_pending_head (sem_semaphore_head_ic))) ”
  &&  “ (waiting_semaphore_head_ic <> (@nil Z)) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (map (sched_link_node) (waiting_semaphore_head_ic)) ) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_head_ic))) ”
  &&  “ (waiting_semaphore_head_ic <> (@nil Z)) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (map (sched_link_node) (waiting_semaphore_head_ic)) ) ”
  &&  (os_inv sg_semaphore_head_ic before_semaphore_head_ic )
.

Definition LinklistResume_partial_solve_wit_1 := LinklistResume_partial_solve_wit_1_pure -> LinklistResume_partial_solve_wit_1_aux.

Definition LinklistResume_partial_solve_wit_2_pure :=
forall (waiting_semaphore_head_ic: (@list Z)) (sem_semaphore_head_ic: Z) (before_semaphore_head_ic: VarGlobalState) (sg_semaphore_head_ic: StableGlobalState) (list_pre: Z) (first: Z) (rest: (@list Z)) (PreH1 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH2 : (waiting_semaphore_head_ic = (cons (first) (rest)))) (PreH3 : (addr_aligned first 4 )) (PreH4 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) )) (PreH5 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH6 : (waiting_semaphore_head_ic <> (@nil Z))) (PreH7 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (map (sched_link_node) (waiting_semaphore_head_ic)) )),
  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> (sched_link_of (first)))
  **  (wand (store_ptr (&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) ((sched_link_of (first)))) (os_inv (sg_semaphore_head_ic) (before_semaphore_head_ic)) )
  **  ((( &( "task" ) )) # Ptr  |-> 0)
|--
  “ (addr_aligned first 4 ) ”
  &&  “ ((sched_link_of (first)) = (sched_link_of (first))) ”
.

Definition LinklistResume_partial_solve_wit_2_aux :=
forall (waiting_semaphore_head_ic: (@list Z)) (sem_semaphore_head_ic: Z) (before_semaphore_head_ic: VarGlobalState) (sg_semaphore_head_ic: StableGlobalState) (list_pre: Z) (first: Z) (rest: (@list Z)) (PreH1 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH2 : (waiting_semaphore_head_ic = (cons (first) (rest)))) (PreH3 : (addr_aligned first 4 )) (PreH4 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) )) (PreH5 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH6 : (waiting_semaphore_head_ic <> (@nil Z))) (PreH7 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (map (sched_link_node) (waiting_semaphore_head_ic)) )),
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> (sched_link_of (first)))
  **  (wand (store_ptr (&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) ((sched_link_of (first)))) (os_inv (sg_semaphore_head_ic) (before_semaphore_head_ic)) )
|--
  “ (addr_aligned first 4 ) ”
  &&  “ ((sched_link_of (first)) = (sched_link_of (first))) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_head_ic))) ”
  &&  “ (waiting_semaphore_head_ic = (cons (first) (rest))) ”
  &&  “ (addr_aligned first 4 ) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) ) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_head_ic))) ”
  &&  “ (waiting_semaphore_head_ic <> (@nil Z)) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (map (sched_link_node) (waiting_semaphore_head_ic)) ) ”
  &&  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> (sched_link_of (first)))
  **  (wand (store_ptr (&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) ((sched_link_of (first)))) (os_inv (sg_semaphore_head_ic) (before_semaphore_head_ic)) )
.

Definition LinklistResume_partial_solve_wit_2 := LinklistResume_partial_solve_wit_2_pure -> LinklistResume_partial_solve_wit_2_aux.

Definition LinklistResume_partial_solve_wit_3 :=
forall (waiting_semaphore_head_ic: (@list Z)) (sem_semaphore_head_ic: Z) (before_semaphore_head_ic: VarGlobalState) (sg_semaphore_head_ic: StableGlobalState) (list_pre: Z) (first: Z) (rest: (@list Z)) (retval: Z) (PreH1 : (retval = first)) (PreH2 : (addr_aligned retval 4 )) (PreH3 : ((sched_link_of (first)) = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH4 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH5 : (waiting_semaphore_head_ic = (cons (first) (rest)))) (PreH6 : (addr_aligned first 4 )) (PreH7 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) )) (PreH8 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH9 : (waiting_semaphore_head_ic <> (@nil Z))) (PreH10 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (map (sched_link_node) (waiting_semaphore_head_ic)) )),
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> (sched_link_of (first)))
  **  (wand (store_ptr (&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) ((sched_link_of (first)))) (os_inv (sg_semaphore_head_ic) (before_semaphore_head_ic)) )
  **  ((( &( "task" ) )) # Ptr  |-> retval)
|--
  “ (retval = first) ”
  &&  “ (addr_aligned retval 4 ) ”
  &&  “ ((sched_link_of (first)) = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_head_ic))) ”
  &&  “ (waiting_semaphore_head_ic = (cons (first) (rest))) ”
  &&  “ (addr_aligned first 4 ) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) ) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_head_ic))) ”
  &&  “ (waiting_semaphore_head_ic <> (@nil Z)) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (map (sched_link_node) (waiting_semaphore_head_ic)) ) ”
  &&  ((( &( "task" ) )) # Ptr  |-> first)
  **  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> (sched_link_of (first)))
  **  (wand (store_ptr (&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) ((sched_link_of (first)))) (os_inv (sg_semaphore_head_ic) (before_semaphore_head_ic)) )
.

Definition LinklistResume_partial_solve_wit_4_pure :=
forall (waiting_semaphore_head_ic: (@list Z)) (sem_semaphore_head_ic: Z) (before_semaphore_head_ic: VarGlobalState) (sg_semaphore_head_ic: StableGlobalState) (list_pre: Z) (first: Z) (rest: (@list Z)) (retval: Z) (PreH1 : (retval = first)) (PreH2 : (addr_aligned retval 4 )) (PreH3 : ((sched_link_of (first)) = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH4 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH5 : (waiting_semaphore_head_ic = (cons (first) (rest)))) (PreH6 : (addr_aligned first 4 )) (PreH7 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) )) (PreH8 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH9 : (waiting_semaphore_head_ic <> (@nil Z))) (PreH10 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (map (sched_link_node) (waiting_semaphore_head_ic)) )),
  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> first)
  **  (os_inv sg_semaphore_head_ic before_semaphore_head_ic )
|--
  “ (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) ) ”
.

Definition LinklistResume_partial_solve_wit_4_aux :=
forall (waiting_semaphore_head_ic: (@list Z)) (sem_semaphore_head_ic: Z) (before_semaphore_head_ic: VarGlobalState) (sg_semaphore_head_ic: StableGlobalState) (list_pre: Z) (first: Z) (rest: (@list Z)) (retval: Z) (PreH1 : (retval = first)) (PreH2 : (addr_aligned retval 4 )) (PreH3 : ((sched_link_of (first)) = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH4 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH5 : (waiting_semaphore_head_ic = (cons (first) (rest)))) (PreH6 : (addr_aligned first 4 )) (PreH7 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) )) (PreH8 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH9 : (waiting_semaphore_head_ic <> (@nil Z))) (PreH10 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (map (sched_link_node) (waiting_semaphore_head_ic)) )),
  (os_inv sg_semaphore_head_ic before_semaphore_head_ic )
|--
  “ (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) ) ”
  &&  “ (retval = first) ”
  &&  “ (addr_aligned retval 4 ) ”
  &&  “ ((sched_link_of (first)) = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_head_ic))) ”
  &&  “ (waiting_semaphore_head_ic = (cons (first) (rest))) ”
  &&  “ (addr_aligned first 4 ) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) ) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_head_ic))) ”
  &&  “ (waiting_semaphore_head_ic <> (@nil Z)) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (map (sched_link_node) (waiting_semaphore_head_ic)) ) ”
  &&  (os_inv sg_semaphore_head_ic before_semaphore_head_ic )
.

Definition LinklistResume_partial_solve_wit_4 := LinklistResume_partial_solve_wit_4_pure -> LinklistResume_partial_solve_wit_4_aux.

Definition LinklistResume_partial_solve_wit_5 :=
forall (waiting_semaphore_head_ic: (@list Z)) (sem_semaphore_head_ic: Z) (before_semaphore_head_ic: VarGlobalState) (sg_semaphore_head_ic: StableGlobalState) (list_pre: Z) (first: Z) (rest: (@list Z)) (retval: Z) (task_id: Z) (PreH1 : (0 <= task_id)) (PreH2 : (task_id < 65536)) (PreH3 : (get_task_with_idnode_success sg_semaphore_head_ic before_semaphore_head_ic task_id first )) (PreH4 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) )) (PreH5 : (retval = first)) (PreH6 : (addr_aligned retval 4 )) (PreH7 : ((sched_link_of (first)) = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH8 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH9 : (waiting_semaphore_head_ic = (cons (first) (rest)))) (PreH10 : (addr_aligned first 4 )) (PreH11 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) )) (PreH12 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH13 : (waiting_semaphore_head_ic <> (@nil Z))) (PreH14 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (map (sched_link_node) (waiting_semaphore_head_ic)) )),
  ((&((first)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (wand (store_ushort (&((first)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (task_id)) (os_inv (sg_semaphore_head_ic) (before_semaphore_head_ic)) )
|--
  “ (0 <= task_id) ”
  &&  “ (task_id < 65536) ”
  &&  “ (get_task_with_idnode_success sg_semaphore_head_ic before_semaphore_head_ic task_id first ) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) ) ”
  &&  “ (retval = first) ”
  &&  “ (addr_aligned retval 4 ) ”
  &&  “ ((sched_link_of (first)) = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_head_ic))) ”
  &&  “ (waiting_semaphore_head_ic = (cons (first) (rest))) ”
  &&  “ (addr_aligned first 4 ) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) ) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_head_ic))) ”
  &&  “ (waiting_semaphore_head_ic <> (@nil Z)) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (map (sched_link_node) (waiting_semaphore_head_ic)) ) ”
  &&  ((&((first)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (wand (store_ushort (&((first)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (task_id)) (os_inv (sg_semaphore_head_ic) (before_semaphore_head_ic)) )
.

Definition LinklistResume_partial_solve_wit_6_pure :=
forall (waiting_semaphore_head_ic: (@list Z)) (sem_semaphore_head_ic: Z) (before_semaphore_head_ic: VarGlobalState) (sg_semaphore_head_ic: StableGlobalState) (list_pre: Z) (first: Z) (rest: (@list Z)) (retval: Z) (task_id: Z) (PreH1 : (0 <= task_id)) (PreH2 : (task_id < 65536)) (PreH3 : (get_task_with_idnode_success sg_semaphore_head_ic before_semaphore_head_ic task_id first )) (PreH4 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) )) (PreH5 : (retval = first)) (PreH6 : (addr_aligned retval 4 )) (PreH7 : ((sched_link_of (first)) = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH8 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH9 : (waiting_semaphore_head_ic = (cons (first) (rest)))) (PreH10 : (addr_aligned first 4 )) (PreH11 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) )) (PreH12 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH13 : (waiting_semaphore_head_ic <> (@nil Z))) (PreH14 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (map (sched_link_node) (waiting_semaphore_head_ic)) )),
  ((( &( "task" ) )) # Ptr  |-> first)
  **  ((( &( "resume_task_id" ) )) # Int  |-> task_id)
  **  (os_inv sg_semaphore_head_ic before_semaphore_head_ic )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
|--
  “ (task_id < 65536) ”
  &&  “ (get_task_with_idnode_success sg_semaphore_head_ic before_semaphore_head_ic task_id first ) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) ) ”
.

Definition LinklistResume_partial_solve_wit_6_aux :=
forall (waiting_semaphore_head_ic: (@list Z)) (sem_semaphore_head_ic: Z) (before_semaphore_head_ic: VarGlobalState) (sg_semaphore_head_ic: StableGlobalState) (list_pre: Z) (first: Z) (rest: (@list Z)) (retval: Z) (task_id: Z) (PreH1 : (0 <= task_id)) (PreH2 : (task_id < 65536)) (PreH3 : (get_task_with_idnode_success sg_semaphore_head_ic before_semaphore_head_ic task_id first )) (PreH4 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) )) (PreH5 : (retval = first)) (PreH6 : (addr_aligned retval 4 )) (PreH7 : ((sched_link_of (first)) = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH8 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH9 : (waiting_semaphore_head_ic = (cons (first) (rest)))) (PreH10 : (addr_aligned first 4 )) (PreH11 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) )) (PreH12 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH13 : (waiting_semaphore_head_ic <> (@nil Z))) (PreH14 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (map (sched_link_node) (waiting_semaphore_head_ic)) )),
  (os_inv sg_semaphore_head_ic before_semaphore_head_ic )
|--
  “ (task_id < 65536) ”
  &&  “ (get_task_with_idnode_success sg_semaphore_head_ic before_semaphore_head_ic task_id first ) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) ) ”
  &&  “ (0 <= task_id) ”
  &&  “ (task_id < 65536) ”
  &&  “ (get_task_with_idnode_success sg_semaphore_head_ic before_semaphore_head_ic task_id first ) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) ) ”
  &&  “ (retval = first) ”
  &&  “ (addr_aligned retval 4 ) ”
  &&  “ ((sched_link_of (first)) = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_head_ic))) ”
  &&  “ (waiting_semaphore_head_ic = (cons (first) (rest))) ”
  &&  “ (addr_aligned first 4 ) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) ) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_head_ic))) ”
  &&  “ (waiting_semaphore_head_ic <> (@nil Z)) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (map (sched_link_node) (waiting_semaphore_head_ic)) ) ”
  &&  (os_inv sg_semaphore_head_ic before_semaphore_head_ic )
.

Definition LinklistResume_partial_solve_wit_6 := LinklistResume_partial_solve_wit_6_pure -> LinklistResume_partial_solve_wit_6_aux.

Definition LinklistResume_which_implies_wit_1 :=
(
forall (waiting_semaphore_head_ic: (@list Z)) (sem_semaphore_head_ic: Z) (before_semaphore_head_ic: VarGlobalState) (sg_semaphore_head_ic: StableGlobalState) (list_pre: Z) (PreH1 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH2 : (waiting_semaphore_head_ic <> (@nil Z))) (PreH3 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (map (sched_link_node) (waiting_semaphore_head_ic)) )),
  (os_inv sg_semaphore_head_ic before_semaphore_head_ic )
|--
  EX (first: Z) (rest: (@list Z)),
  “ (list_pre = (semaphore_pending_head (sem_semaphore_head_ic))) ”
  &&  “ (waiting_semaphore_head_ic = (cons (first) (rest))) ”
  &&  “ (addr_aligned first 4 ) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) ) ”
  &&  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> (sched_link_of (first)))
  **  (wand (store_ptr (&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) ((sched_link_of (first)))) (os_inv (sg_semaphore_head_ic) (before_semaphore_head_ic)) )
) \/
(
forall (waiting_semaphore_head_ic: (@list Z)) (sem_semaphore_head_ic: Z) (before_semaphore_head_ic: VarGlobalState) (sg_semaphore_head_ic: StableGlobalState) (list_pre: Z) (PreH1 : (list_pre = (semaphore_pending_head (sem_semaphore_head_ic)))) (PreH2 : (waiting_semaphore_head_ic <> (@nil Z))) (PreH3 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (map (sched_link_node) (waiting_semaphore_head_ic)) )),
  (os_inv sg_semaphore_head_ic before_semaphore_head_ic )
|--
  EX (first: Z) (rest: (@list Z)),
  “ (list_pre = (semaphore_pending_head (sem_semaphore_head_ic))) ”
  &&  “ (waiting_semaphore_head_ic = (cons (first) (rest))) ”
  &&  “ (addr_aligned first 4 ) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) ) ”
  &&  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> (sched_link_of (first)))
  **  (wand (store_ptr (&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) ((sched_link_of (first)))) (os_inv (sg_semaphore_head_ic) (before_semaphore_head_ic)) )
).

Definition LinklistResume_which_implies_wit_2 :=
(
forall (before_semaphore_head_ic: VarGlobalState) (sg_semaphore_head_ic: StableGlobalState) (list_pre: Z) (first: Z),
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> (sched_link_of (first)))
  **  (wand (store_ptr (&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) ((sched_link_of (first)))) (os_inv (sg_semaphore_head_ic) (before_semaphore_head_ic)) )
|--
  (os_inv sg_semaphore_head_ic before_semaphore_head_ic )
) \/
(
forall (before_semaphore_head_ic: VarGlobalState) (sg_semaphore_head_ic: StableGlobalState) (list_pre: Z) (first: Z),
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> (sched_link_of (first)))
  **  (wand (store_ptr (&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) ((sched_link_of (first)))) (os_inv (sg_semaphore_head_ic) (before_semaphore_head_ic)) )
|--
  (os_inv sg_semaphore_head_ic before_semaphore_head_ic )
).

Definition LinklistResume_which_implies_wit_2_split_goal_spatial :=
forall (before_semaphore_head_ic: VarGlobalState) (sg_semaphore_head_ic: StableGlobalState) (list_pre: Z) (first: Z),
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> (sched_link_of (first)))
  **  (wand (store_ptr (&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) ((sched_link_of (first)))) (os_inv (sg_semaphore_head_ic) (before_semaphore_head_ic)) )
|--
  (os_inv sg_semaphore_head_ic before_semaphore_head_ic )
.

Definition LinklistResume_which_implies_wit_3 :=
(
forall (sem_semaphore_head_ic: Z) (before_semaphore_head_ic: VarGlobalState) (sg_semaphore_head_ic: StableGlobalState) (first: Z) (rest: (@list Z)) (PreH1 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) )),
  (os_inv sg_semaphore_head_ic before_semaphore_head_ic )
|--
  EX (task_id: Z),
  “ (0 <= task_id) ”
  &&  “ (task_id < 65536) ”
  &&  “ (get_task_with_idnode_success sg_semaphore_head_ic before_semaphore_head_ic task_id first ) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) ) ”
  &&  ((&((first)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (wand (store_ushort (&((first)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (task_id)) (os_inv (sg_semaphore_head_ic) (before_semaphore_head_ic)) )
) \/
(
forall (sem_semaphore_head_ic: Z) (before_semaphore_head_ic: VarGlobalState) (sg_semaphore_head_ic: StableGlobalState) (first: Z) (rest: (@list Z)) (PreH1 : (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) )),
  (os_inv sg_semaphore_head_ic before_semaphore_head_ic )
|--
  EX (task_id: Z),
  “ (0 <= task_id) ”
  &&  “ (task_id < 65536) ”
  &&  “ (get_task_with_idnode_success sg_semaphore_head_ic before_semaphore_head_ic task_id first ) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_head_ic before_semaphore_head_ic (cons ((sched_link_node (first))) ((map (sched_link_node) (rest)))) ) ”
  &&  ((&((first)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (wand (store_ushort (&((first)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (task_id)) (os_inv (sg_semaphore_head_ic) (before_semaphore_head_ic)) )
).

Definition LinklistResume_which_implies_wit_4 :=
(
forall (before_semaphore_head_ic: VarGlobalState) (sg_semaphore_head_ic: StableGlobalState) (first: Z) (task_id: Z),
  ((&((first)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (wand (store_ushort (&((first)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (task_id)) (os_inv (sg_semaphore_head_ic) (before_semaphore_head_ic)) )
|--
  (os_inv sg_semaphore_head_ic before_semaphore_head_ic )
) \/
(
forall (before_semaphore_head_ic: VarGlobalState) (sg_semaphore_head_ic: StableGlobalState) (first: Z) (task_id: Z),
  ((&((first)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (wand (store_ushort (&((first)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (task_id)) (os_inv (sg_semaphore_head_ic) (before_semaphore_head_ic)) )
|--
  (os_inv sg_semaphore_head_ic before_semaphore_head_ic )
).

Definition LinklistResume_which_implies_wit_4_split_goal_spatial :=
forall (before_semaphore_head_ic: VarGlobalState) (sg_semaphore_head_ic: StableGlobalState) (first: Z) (task_id: Z),
  ((&((first)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (wand (store_ushort (&((first)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (task_id)) (os_inv (sg_semaphore_head_ic) (before_semaphore_head_ic)) )
|--
  (os_inv sg_semaphore_head_ic before_semaphore_head_ic )
.

Module Type VC_Correct.


Axiom proof_of_LinklistResume_safety_wit_1 : LinklistResume_safety_wit_1.
Axiom proof_of_LinklistResume_safety_wit_2 : LinklistResume_safety_wit_2.
Axiom proof_of_LinklistResume_return_wit_1 : LinklistResume_return_wit_1.
Axiom proof_of_LinklistResume_partial_solve_wit_1_pure : LinklistResume_partial_solve_wit_1_pure.
Axiom proof_of_LinklistResume_partial_solve_wit_1 : LinklistResume_partial_solve_wit_1.
Axiom proof_of_LinklistResume_partial_solve_wit_2_pure : LinklistResume_partial_solve_wit_2_pure.
Axiom proof_of_LinklistResume_partial_solve_wit_2 : LinklistResume_partial_solve_wit_2.
Axiom proof_of_LinklistResume_partial_solve_wit_3 : LinklistResume_partial_solve_wit_3.
Axiom proof_of_LinklistResume_partial_solve_wit_4_pure : LinklistResume_partial_solve_wit_4_pure.
Axiom proof_of_LinklistResume_partial_solve_wit_4 : LinklistResume_partial_solve_wit_4.
Axiom proof_of_LinklistResume_partial_solve_wit_5 : LinklistResume_partial_solve_wit_5.
Axiom proof_of_LinklistResume_partial_solve_wit_6_pure : LinklistResume_partial_solve_wit_6_pure.
Axiom proof_of_LinklistResume_partial_solve_wit_6 : LinklistResume_partial_solve_wit_6.
Axiom proof_of_LinklistResume_which_implies_wit_1 : LinklistResume_which_implies_wit_1.
Axiom proof_of_LinklistResume_which_implies_wit_2 : LinklistResume_which_implies_wit_2.
Axiom proof_of_LinklistResume_which_implies_wit_3 : LinklistResume_which_implies_wit_3.
Axiom proof_of_LinklistResume_which_implies_wit_4 : LinklistResume_which_implies_wit_4.

End VC_Correct.
