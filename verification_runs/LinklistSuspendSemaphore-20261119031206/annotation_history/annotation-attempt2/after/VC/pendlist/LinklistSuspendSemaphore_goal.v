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

(*----- Function LinklistSuspend -----*)

Definition LinklistSuspend_safety_wit_1 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (PreH1 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH2 : (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH3 : (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic )),
  ((( &( "ret" ) )) # Int  |->_)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  (os_inv sg_semaphore_ic before_semaphore_ic )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition LinklistSuspend_safety_wit_2 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (PreH1 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH2 : (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH3 : (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic )),
  ((( &( "node" ) )) # Ptr  |->_)
  **  ((( &( "suspend_id" ) )) # Int  |->_)
  **  ((( &( "ret" ) )) # Int  |-> 0)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  (os_inv sg_semaphore_ic before_semaphore_ic )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition LinklistSuspend_safety_wit_3 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (PreH1 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH2 : (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH3 : (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic )),
  ((( &( "tail" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |-> 0)
  **  ((( &( "suspend_id" ) )) # Int  |->_)
  **  ((( &( "ret" ) )) # Int  |-> 0)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  (os_inv sg_semaphore_ic before_semaphore_ic )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition LinklistSuspend_safety_wit_4 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (PreH1 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH2 : (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH3 : (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic )),
  ((( &( "tmp_task" ) )) # Ptr  |->_)
  **  ((( &( "tail" ) )) # Ptr  |-> 0)
  **  ((( &( "node" ) )) # Ptr  |-> 0)
  **  ((( &( "suspend_id" ) )) # Int  |->_)
  **  ((( &( "ret" ) )) # Int  |-> 0)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  (os_inv sg_semaphore_ic before_semaphore_ic )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition LinklistSuspend_safety_wit_5 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (PreH1 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH2 : (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH3 : (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic )),
  ((( &( "tmp_task" ) )) # Ptr  |-> 0)
  **  ((( &( "tail" ) )) # Ptr  |-> 0)
  **  ((( &( "node" ) )) # Ptr  |-> 0)
  **  ((( &( "suspend_id" ) )) # Int  |->_)
  **  ((( &( "ret" ) )) # Int  |-> 0)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  (os_inv sg_semaphore_ic before_semaphore_ic )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition LinklistSuspend_safety_wit_6 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (PreH1 : (flag_pre <> 0)) (PreH2 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH3 : (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH4 : (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic )),
  ((( &( "tmp_task" ) )) # Ptr  |-> 0)
  **  ((( &( "tail" ) )) # Ptr  |-> 0)
  **  ((( &( "node" ) )) # Ptr  |-> 0)
  **  ((( &( "suspend_id" ) )) # Int  |->_)
  **  ((( &( "ret" ) )) # Int  |-> 0)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  (os_inv sg_semaphore_ic before_semaphore_ic )
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition LinklistSuspend_safety_wit_7 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (PreH1 : (flag_pre <> 1)) (PreH2 : (flag_pre <> 0)) (PreH3 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH4 : (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH5 : (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic )),
  ((( &( "tmp_task" ) )) # Ptr  |-> 0)
  **  ((( &( "tail" ) )) # Ptr  |-> 0)
  **  ((( &( "node" ) )) # Ptr  |-> 0)
  **  ((( &( "suspend_id" ) )) # Int  |->_)
  **  ((( &( "ret" ) )) # Int  |-> 0)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  (os_inv sg_semaphore_ic before_semaphore_ic )
|--
  “ (10 <> (INT_MIN)) ”
.

Definition LinklistSuspend_safety_wit_8 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (PreH1 : (flag_pre <> 1)) (PreH2 : (flag_pre <> 0)) (PreH3 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH4 : (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH5 : (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic )),
  ((( &( "tmp_task" ) )) # Ptr  |-> 0)
  **  ((( &( "tail" ) )) # Ptr  |-> 0)
  **  ((( &( "node" ) )) # Ptr  |-> 0)
  **  ((( &( "suspend_id" ) )) # Int  |->_)
  **  ((( &( "ret" ) )) # Int  |-> 0)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  (os_inv sg_semaphore_ic before_semaphore_ic )
|--
  “ (10 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 10) ”
.

Definition LinklistSuspend_safety_wit_9 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (task_id: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (PreH1 : (flag_pre = 0)) (PreH2 : (ret = 0)) (PreH3 : (node = 0)) (PreH4 : (tail = 0)) (PreH5 : (tmp_task = 0)) (PreH6 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH7 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH8 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH9 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH10 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH11 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH12 : (ktask_not_os_service task_pre staged )),
  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  ((( &( "ret" ) )) # Int  |-> ret)
  **  ((( &( "node" ) )) # Ptr  |-> node)
  **  ((( &( "tail" ) )) # Ptr  |-> tail)
  **  ((( &( "tmp_task" ) )) # Ptr  |-> tmp_task)
  **  ((( &( "suspend_id" ) )) # Int  |-> task_id)
  **  (os_inv sg_semaphore_ic staged )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition LinklistSuspend_safety_wit_10 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (task_id: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (PreH1 : (flag_pre = 1)) (PreH2 : (ret = 0)) (PreH3 : (node = 0)) (PreH4 : (tail = 0)) (PreH5 : (tmp_task = 0)) (PreH6 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH7 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH8 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH9 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH10 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH11 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH12 : (ktask_not_os_service task_pre staged )),
  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  ((( &( "ret" ) )) # Int  |-> ret)
  **  ((( &( "node" ) )) # Ptr  |-> node)
  **  ((( &( "tail" ) )) # Ptr  |-> tail)
  **  ((( &( "tmp_task" ) )) # Ptr  |-> tmp_task)
  **  ((( &( "suspend_id" ) )) # Int  |-> task_id)
  **  (os_inv sg_semaphore_ic staged )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition LinklistSuspend_safety_wit_11 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (task_id: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (PreH1 : (flag_pre <> 0)) (PreH2 : (flag_pre = 0)) (PreH3 : (ret = 0)) (PreH4 : (node = 0)) (PreH5 : (tail = 0)) (PreH6 : (tmp_task = 0)) (PreH7 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH8 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH9 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH10 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH11 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH12 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH13 : (ktask_not_os_service task_pre staged )),
  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  ((( &( "ret" ) )) # Int  |-> ret)
  **  ((( &( "node" ) )) # Ptr  |-> node)
  **  ((( &( "tail" ) )) # Ptr  |-> tail)
  **  ((( &( "tmp_task" ) )) # Ptr  |-> tmp_task)
  **  ((( &( "suspend_id" ) )) # Int  |-> task_id)
  **  (os_inv sg_semaphore_ic staged )
|--
  “ False ”
.

Definition LinklistSuspend_safety_wit_12 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (task_id: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (PreH1 : (flag_pre = 0)) (PreH2 : (flag_pre = 1)) (PreH3 : (ret = 0)) (PreH4 : (node = 0)) (PreH5 : (tail = 0)) (PreH6 : (tmp_task = 0)) (PreH7 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH8 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH9 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH10 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH11 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH12 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH13 : (ktask_not_os_service task_pre staged )),
  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  ((( &( "ret" ) )) # Int  |-> ret)
  **  ((( &( "node" ) )) # Ptr  |-> node)
  **  ((( &( "tail" ) )) # Ptr  |-> tail)
  **  ((( &( "tmp_task" ) )) # Ptr  |-> tmp_task)
  **  ((( &( "suspend_id" ) )) # Int  |-> task_id)
  **  (os_inv sg_semaphore_ic staged )
|--
  “ False ”
.

Definition LinklistSuspend_safety_wit_13 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (task_id: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (PreH1 : (flag_pre <> 0)) (PreH2 : (flag_pre = 1)) (PreH3 : (ret = 0)) (PreH4 : (node = 0)) (PreH5 : (tail = 0)) (PreH6 : (tmp_task = 0)) (PreH7 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH8 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH9 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH10 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH11 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH12 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH13 : (ktask_not_os_service task_pre staged )),
  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  ((( &( "ret" ) )) # Int  |-> ret)
  **  ((( &( "node" ) )) # Ptr  |-> node)
  **  ((( &( "tail" ) )) # Ptr  |-> tail)
  **  ((( &( "tmp_task" ) )) # Ptr  |-> tmp_task)
  **  ((( &( "suspend_id" ) )) # Int  |-> task_id)
  **  (os_inv sg_semaphore_ic staged )
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition LinklistSuspend_safety_wit_14 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (task_id: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (PreH1 : (flag_pre <> 1)) (PreH2 : (flag_pre <> 0)) (PreH3 : (flag_pre = 1)) (PreH4 : (ret = 0)) (PreH5 : (node = 0)) (PreH6 : (tail = 0)) (PreH7 : (tmp_task = 0)) (PreH8 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH9 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH10 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH11 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH12 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH13 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH14 : (ktask_not_os_service task_pre staged )),
  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  ((( &( "ret" ) )) # Int  |-> ret)
  **  ((( &( "node" ) )) # Ptr  |-> node)
  **  ((( &( "tail" ) )) # Ptr  |-> tail)
  **  ((( &( "tmp_task" ) )) # Ptr  |-> tmp_task)
  **  ((( &( "suspend_id" ) )) # Int  |-> task_id)
  **  (os_inv sg_semaphore_ic staged )
|--
  “ False ”
.

Definition LinklistSuspend_safety_wit_15 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (task_id: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (other_desc: TaskDescriptorAbs) (node: Z) (prefix_loop: (@list Z)) (suffix_loop: (@list Z)) (old_tmp: Z) (tail: Z) (ret: Z) (PreH1 : (node <> list_pre)) (PreH2 : (flag_pre = 1)) (PreH3 : (ret = 0)) (PreH4 : (tail = 0)) (PreH5 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH6 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH7 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH8 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH9 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH10 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH11 : (ktask_not_os_service task_pre staged )) (PreH12 : (waiting_semaphore_ic = (app (prefix_loop) (suffix_loop)))) (PreH13 : forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) ))))) (PreH14 : (suffix_loop = (@nil Z))) (PreH15 : (node = list_pre)),
  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  ((( &( "ret" ) )) # Int  |-> ret)
  **  ((( &( "tail" ) )) # Ptr  |-> tail)
  **  ((( &( "tmp_task" ) )) # Ptr  |-> old_tmp)
  **  ((( &( "suspend_id" ) )) # Int  |-> task_id)
  **  ((( &( "node" ) )) # Ptr  |-> node)
  **  (os_inv sg_semaphore_ic staged )
|--
  “ False ”
.

Definition LinklistSuspend_safety_wit_16 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (task_id: Z) (staged: VarGlobalState) (ignored: Z) (rest_tasks: (@list Z)) (ret: Z) (tail: Z) (node: Z) (prefix_done: (@list Z)) (suffix_done: (@list Z)) (last_tmp: Z) (new_nodes: (@list (@DL_Node Z))) (after_prio: VarGlobalState) (PreH1 : (node = list_pre)) (PreH2 : (flag_pre = 1)) (PreH3 : (ret = 0)) (PreH4 : (tail = 0)) (PreH5 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH6 : (waiting_semaphore_ic = (app (prefix_done) (suffix_done)))) (PreH7 : (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done)))))))) (PreH8 : (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes )) (PreH9 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio )) (PreH10 : (suffix_done = (cons (last_tmp) (rest_tasks)))) (PreH11 : (node = &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH12 : (node <> list_pre)) (PreH13 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH14 : ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)))) (PreH15 : ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))))),
  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  ((( &( "ret" ) )) # Int  |-> ret)
  **  ((( &( "tmp_task" ) )) # Ptr  |-> last_tmp)
  **  ((( &( "tail" ) )) # Ptr  |-> tail)
  **  ((( &( "suspend_id" ) )) # Int  |-> task_id)
  **  ((( &( "node" ) )) # Ptr  |-> node)
  **  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
|--
  “ False ”
.

Definition LinklistSuspend_safety_wit_17 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (task_id: Z) (staged: VarGlobalState) (ignored: Z) (ret: Z) (tail: Z) (node: Z) (prefix_done: (@list Z)) (suffix_done: (@list Z)) (last_tmp: Z) (new_nodes: (@list (@DL_Node Z))) (after_prio: VarGlobalState) (PreH1 : (node <> list_pre)) (PreH2 : (flag_pre = 1)) (PreH3 : (ret = 0)) (PreH4 : (tail = 0)) (PreH5 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH6 : (waiting_semaphore_ic = (app (prefix_done) (suffix_done)))) (PreH7 : (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done)))))))) (PreH8 : (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes )) (PreH9 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio )) (PreH10 : (node = list_pre)) (PreH11 : (suffix_done = (@nil Z))) (PreH12 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH13 : ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)))) (PreH14 : ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))))),
  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  ((( &( "ret" ) )) # Int  |-> ret)
  **  ((( &( "tmp_task" ) )) # Ptr  |-> last_tmp)
  **  ((( &( "tail" ) )) # Ptr  |-> tail)
  **  ((( &( "suspend_id" ) )) # Int  |-> task_id)
  **  ((( &( "node" ) )) # Ptr  |-> node)
  **  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
|--
  “ False ”
.

Definition LinklistSuspend_entail_wit_1_1 :=
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (PreH1 : (flag_pre = 0)) (PreH2 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH3 : (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH4 : (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic )),
  (os_inv sg_semaphore_ic before_semaphore_ic )
|--
  EX (task_id: Z),
  “ (0 <= task_id) ”
  &&  “ (task_id < 65536) ”
  &&  “ (get_task_with_idnode_success sg_semaphore_ic before_semaphore_ic task_id task_pre ) ”
  &&  “ (flag_pre = 0) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic ) ”
  &&  “ (0 = 0) ”
  &&  “ (0 = 0) ”
  &&  “ (0 = 0) ”
  &&  “ (0 = 0) ”
  &&  ((&((task_pre)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (wand (store_ushort (&((task_pre)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (task_id)) (os_inv (sg_semaphore_ic) (before_semaphore_ic)) )
) \/
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (PreH1 : (flag_pre = 0)) (PreH2 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH3 : (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH4 : (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic )),
  (os_inv sg_semaphore_ic before_semaphore_ic )
|--
  EX (task_id: Z),
  “ (0 <= task_id) ”
  &&  “ (task_id < 65536) ”
  &&  “ (get_task_with_idnode_success sg_semaphore_ic before_semaphore_ic task_id task_pre ) ”
  &&  “ (flag_pre = 0) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic ) ”
  &&  ((&((task_pre)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (wand (store_ushort (&((task_pre)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (task_id)) (os_inv (sg_semaphore_ic) (before_semaphore_ic)) )
).

Definition LinklistSuspend_entail_wit_1_2 :=
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (PreH1 : (flag_pre = 1)) (PreH2 : (flag_pre <> 0)) (PreH3 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH4 : (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH5 : (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic )),
  (os_inv sg_semaphore_ic before_semaphore_ic )
|--
  EX (task_id: Z),
  “ (0 <= task_id) ”
  &&  “ (task_id < 65536) ”
  &&  “ (get_task_with_idnode_success sg_semaphore_ic before_semaphore_ic task_id task_pre ) ”
  &&  “ (flag_pre = 1) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic ) ”
  &&  “ (0 = 0) ”
  &&  “ (0 = 0) ”
  &&  “ (0 = 0) ”
  &&  “ (0 = 0) ”
  &&  ((&((task_pre)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (wand (store_ushort (&((task_pre)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (task_id)) (os_inv (sg_semaphore_ic) (before_semaphore_ic)) )
) \/
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (PreH1 : (flag_pre = 1)) (PreH2 : (flag_pre <> 0)) (PreH3 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH4 : (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH5 : (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic )),
  (os_inv sg_semaphore_ic before_semaphore_ic )
|--
  EX (task_id: Z),
  “ (0 <= task_id) ”
  &&  “ (task_id < 65536) ”
  &&  “ (get_task_with_idnode_success sg_semaphore_ic before_semaphore_ic task_id task_pre ) ”
  &&  “ (flag_pre = 1) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic ) ”
  &&  ((&((task_pre)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (wand (store_ushort (&((task_pre)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (task_id)) (os_inv (sg_semaphore_ic) (before_semaphore_ic)) )
).

Definition LinklistSuspend_entail_wit_2_1 :=
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (task_id: Z) (after: VarGlobalState) (found: Z) (retval: Z) (PreH1 : (found <> 0)) (PreH2 : (get_task_with_idnode_success sg_semaphore_ic before_semaphore_ic task_id found )) (PreH3 : (ktask_suspend_step found before_semaphore_ic retval after )) (PreH4 : (0 <= task_id)) (PreH5 : (task_id < 65536)) (PreH6 : (get_task_with_idnode_success sg_semaphore_ic before_semaphore_ic task_id task_pre )) (PreH7 : (flag_pre = 1)) (PreH8 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH9 : (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH10 : (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic )) (PreH11 : (ret = 0)) (PreH12 : (node = 0)) (PreH13 : (tail = 0)) (PreH14 : (tmp_task = 0)),
  (os_inv sg_semaphore_ic after )
|--
  EX (desc: TaskDescriptorAbs) (ignored: Z) (staged: VarGlobalState),
  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (node = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (tmp_task = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc))) ”
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (In task_pre (sched_owned_tasks ((os_tasks (staged)))) ) ”
  &&  “ (ktask_not_os_service task_pre staged ) ”
  &&  (os_inv sg_semaphore_ic staged )
) \/
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (task_id: Z) (after: VarGlobalState) (found: Z) (retval: Z) (PreH1 : (found <> 0)) (PreH2 : (get_task_with_idnode_success sg_semaphore_ic before_semaphore_ic task_id found )) (PreH3 : (ktask_suspend_step found before_semaphore_ic retval after )) (PreH4 : (0 <= task_id)) (PreH5 : (task_id < 65536)) (PreH6 : (get_task_with_idnode_success sg_semaphore_ic before_semaphore_ic task_id task_pre )) (PreH7 : (flag_pre = 1)) (PreH8 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH9 : (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH10 : (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic )) (PreH11 : (ret = 0)) (PreH12 : (node = 0)) (PreH13 : (tail = 0)) (PreH14 : (tmp_task = 0)),
  TT && emp 
|--
  EX (desc: TaskDescriptorAbs) (ignored: Z),
  “ (ktask_suspend_step task_pre before_semaphore_ic ignored after ) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic after (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ ((task_desc_map ((os_tasks (after))) (task_pre)) = (Some (desc))) ”
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (In task_pre (sched_owned_tasks ((os_tasks (after)))) ) ”
  &&  “ (ktask_not_os_service task_pre after ) ”
  &&  emp
).

Definition LinklistSuspend_entail_wit_2_2 :=
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (task_id: Z) (after: VarGlobalState) (found: Z) (retval: Z) (PreH1 : (found <> 0)) (PreH2 : (get_task_with_idnode_success sg_semaphore_ic before_semaphore_ic task_id found )) (PreH3 : (ktask_suspend_step found before_semaphore_ic retval after )) (PreH4 : (0 <= task_id)) (PreH5 : (task_id < 65536)) (PreH6 : (get_task_with_idnode_success sg_semaphore_ic before_semaphore_ic task_id task_pre )) (PreH7 : (flag_pre = 0)) (PreH8 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH9 : (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH10 : (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic )) (PreH11 : (ret = 0)) (PreH12 : (node = 0)) (PreH13 : (tail = 0)) (PreH14 : (tmp_task = 0)),
  (os_inv sg_semaphore_ic after )
|--
  EX (desc: TaskDescriptorAbs) (ignored: Z) (staged: VarGlobalState),
  “ (flag_pre = 0) ”
  &&  “ (ret = 0) ”
  &&  “ (node = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (tmp_task = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc))) ”
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (In task_pre (sched_owned_tasks ((os_tasks (staged)))) ) ”
  &&  “ (ktask_not_os_service task_pre staged ) ”
  &&  (os_inv sg_semaphore_ic staged )
) \/
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (task_id: Z) (after: VarGlobalState) (found: Z) (retval: Z) (PreH1 : (found <> 0)) (PreH2 : (get_task_with_idnode_success sg_semaphore_ic before_semaphore_ic task_id found )) (PreH3 : (ktask_suspend_step found before_semaphore_ic retval after )) (PreH4 : (0 <= task_id)) (PreH5 : (task_id < 65536)) (PreH6 : (get_task_with_idnode_success sg_semaphore_ic before_semaphore_ic task_id task_pre )) (PreH7 : (flag_pre = 0)) (PreH8 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH9 : (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH10 : (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic )) (PreH11 : (ret = 0)) (PreH12 : (node = 0)) (PreH13 : (tail = 0)) (PreH14 : (tmp_task = 0)),
  TT && emp 
|--
  EX (desc: TaskDescriptorAbs) (ignored: Z),
  “ (ktask_suspend_step task_pre before_semaphore_ic ignored after ) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic after (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ ((task_desc_map ((os_tasks (after))) (task_pre)) = (Some (desc))) ”
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (In task_pre (sched_owned_tasks ((os_tasks (after)))) ) ”
  &&  “ (ktask_not_os_service task_pre after ) ”
  &&  emp
).

Definition LinklistSuspend_entail_wit_3 :=
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (PreH1 : (flag_pre = 0)) (PreH2 : (flag_pre = 0)) (PreH3 : (ret = 0)) (PreH4 : (node = 0)) (PreH5 : (tail = 0)) (PreH6 : (tmp_task = 0)) (PreH7 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH8 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH9 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH10 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH11 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH12 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH13 : (ktask_not_os_service task_pre staged )),
  (os_inv sg_semaphore_ic staged )
|--
  EX (after_fifo: VarGlobalState),
  “ (flag_pre = 0) ”
  &&  “ (ret = 0) ”
  &&  “ (node = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (tmp_task = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (linklist_semaphore_enqueue sem_semaphore_ic task_pre 0 staged after_fifo ) ”
  &&  “ ((sched_link_of (task_pre)) = &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ”
  &&  “ (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0) ”
  &&  “ (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) list_pre ) ”
  &&  “ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (list_pre) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))) ”
  &&  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) ((map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))) (os_inv (sg_semaphore_ic) (after_fifo)) )
) \/
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (PreH1 : (flag_pre = 0)) (PreH2 : (flag_pre = 0)) (PreH3 : (ret = 0)) (PreH4 : (node = 0)) (PreH5 : (tail = 0)) (PreH6 : (tmp_task = 0)) (PreH7 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH8 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH9 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH10 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH11 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH12 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH13 : (ktask_not_os_service task_pre staged )),
  (os_inv sg_semaphore_ic staged )
|--
  EX (after_fifo: VarGlobalState),
  “ (flag_pre = 0) ”
  &&  “ (ret = 0) ”
  &&  “ (node = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (tmp_task = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (linklist_semaphore_enqueue sem_semaphore_ic task_pre 0 staged after_fifo ) ”
  &&  “ ((sched_link_of (task_pre)) = &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ”
  &&  “ (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0) ”
  &&  “ (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) list_pre ) ”
  &&  “ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (list_pre) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))) ”
  &&  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) ((map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))) (os_inv (sg_semaphore_ic) (after_fifo)) )
).

Definition LinklistSuspend_entail_wit_4_1 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (first_link: Z) (other_desc: TaskDescriptorAbs) (PreH1 : (waiting_semaphore_ic = (@nil Z))) (PreH2 : (first_link = list_pre)) (PreH3 : (flag_pre = 1)) (PreH4 : (flag_pre <> 0)) (PreH5 : (flag_pre = 1)) (PreH6 : (ret = 0)) (PreH7 : (node = 0)) (PreH8 : (tail = 0)) (PreH9 : (tmp_task = 0)) (PreH10 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH11 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH12 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH13 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH14 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH15 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH16 : (ktask_not_os_service task_pre staged )),
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> first_link)
  **  (wand (store_ptr (&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) (first_link)) (os_inv (sg_semaphore_ic) (staged)) )
|--
  (EX (prefix_loop: (@list Z)) (suffix_loop: (@list Z)),
  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc))) ”
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (In task_pre (sched_owned_tasks ((os_tasks (staged)))) ) ”
  &&  “ (ktask_not_os_service task_pre staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_loop) (suffix_loop))) ”
  &&  “ forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) )))) ”
  &&  “ (suffix_loop = (@nil Z)) ”
  &&  “ (first_link = list_pre) ”
  &&  (os_inv sg_semaphore_ic staged ))
  ||
  (EX (first_task: Z) (rest_tasks: (@list Z)) (prefix_loop: (@list Z)) (suffix_loop: (@list Z)),
  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc))) ”
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (In task_pre (sched_owned_tasks ((os_tasks (staged)))) ) ”
  &&  “ (ktask_not_os_service task_pre staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_loop) (suffix_loop))) ”
  &&  “ forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) )))) ”
  &&  “ (suffix_loop = (cons (first_task) (rest_tasks))) ”
  &&  “ (first_link = (sched_link_of (first_task))) ”
  &&  (os_inv sg_semaphore_ic staged ))
.

Definition LinklistSuspend_entail_wit_4_2 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (first_task_2: Z) (rest_tasks_2: (@list Z)) (first_link: Z) (other_desc: TaskDescriptorAbs) (PreH1 : (waiting_semaphore_ic = (cons (first_task_2) (rest_tasks_2)))) (PreH2 : (first_link = (sched_link_of (first_task_2)))) (PreH3 : (flag_pre = 1)) (PreH4 : (flag_pre <> 0)) (PreH5 : (flag_pre = 1)) (PreH6 : (ret = 0)) (PreH7 : (node = 0)) (PreH8 : (tail = 0)) (PreH9 : (tmp_task = 0)) (PreH10 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH11 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH12 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH13 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH14 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH15 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH16 : (ktask_not_os_service task_pre staged )),
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> first_link)
  **  (wand (store_ptr (&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) (first_link)) (os_inv (sg_semaphore_ic) (staged)) )
|--
  (EX (prefix_loop: (@list Z)) (suffix_loop: (@list Z)),
  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc))) ”
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (In task_pre (sched_owned_tasks ((os_tasks (staged)))) ) ”
  &&  “ (ktask_not_os_service task_pre staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_loop) (suffix_loop))) ”
  &&  “ forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) )))) ”
  &&  “ (suffix_loop = (@nil Z)) ”
  &&  “ (first_link = list_pre) ”
  &&  (os_inv sg_semaphore_ic staged ))
  ||
  (EX (first_task: Z) (rest_tasks: (@list Z)) (prefix_loop: (@list Z)) (suffix_loop: (@list Z)),
  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc))) ”
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (In task_pre (sched_owned_tasks ((os_tasks (staged)))) ) ”
  &&  “ (ktask_not_os_service task_pre staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_loop) (suffix_loop))) ”
  &&  “ forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) )))) ”
  &&  “ (suffix_loop = (cons (first_task) (rest_tasks))) ”
  &&  “ (first_link = (sched_link_of (first_task))) ”
  &&  (os_inv sg_semaphore_ic staged ))
.

Definition LinklistSuspend_entail_wit_5 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (other_desc_2: TaskDescriptorAbs) (node: Z) (first_task: Z) (rest_tasks_2: (@list Z)) (tail: Z) (ret: Z) (prefix_loop: (@list Z)) (suffix_loop: (@list Z)) (other_desc: TaskDescriptorAbs) (PreH1 : (node <> list_pre)) (PreH2 : (flag_pre = 1)) (PreH3 : (ret = 0)) (PreH4 : (tail = 0)) (PreH5 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH6 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH7 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH8 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH9 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH10 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH11 : (ktask_not_os_service task_pre staged )) (PreH12 : (waiting_semaphore_ic = (app (prefix_loop) (suffix_loop)))) (PreH13 : forall (scanned_2: Z), ((In scanned_2 prefix_loop ) -> exists (other_desc_2: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned_2)) = (Some (other_desc_2))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc_2.(tdSchedMember) ).(tsmCurPrio) ))))) (PreH14 : (suffix_loop = (cons (first_task) (rest_tasks_2)))) (PreH15 : (node = (sched_link_of (first_task)))),
  (os_inv sg_semaphore_ic staged )
|--
  (EX (current_desc: TaskDescriptorAbs) (current_task: Z) (rest_tasks: (@list Z)),
  “ (list_pre = list_pre) ”
  &&  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc))) ”
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (In task_pre (sched_owned_tasks ((os_tasks (staged)))) ) ”
  &&  “ (ktask_not_os_service task_pre staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_loop) ((cons (current_task) (rest_tasks))))) ”
  &&  “ forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) )))) ”
  &&  “ (node = (sched_link_of (current_task))) ”
  &&  “ (node <> list_pre) ”
  &&  “ (addr_aligned current_task 4 ) ”
  &&  “ ((task_desc_map ((os_tasks (staged))) (current_task)) = (Some (current_desc))) ”
  &&  “ (rest_tasks = (@nil Z)) ”
  &&  ((&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((current_desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> list_pre)
  **  (wand (sepcon ((store_uchar (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((desc.(tdSchedMember) ).(tsmCurPrio) )))) ((sepcon ((store_uchar (&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((current_desc.(tdSchedMember) ).(tsmCurPrio) )))) ((store_ptr (&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) (list_pre)))))) (os_inv (sg_semaphore_ic) (staged)) ))
  ||
  (EX (next_link: Z) (next_task: Z) (next_rest: (@list Z)) (current_desc: TaskDescriptorAbs) (current_task: Z) (rest_tasks: (@list Z)),
  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc))) ”
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (In task_pre (sched_owned_tasks ((os_tasks (staged)))) ) ”
  &&  “ (ktask_not_os_service task_pre staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_loop) ((cons (current_task) (rest_tasks))))) ”
  &&  “ forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) )))) ”
  &&  “ (node = (sched_link_of (current_task))) ”
  &&  “ (node <> list_pre) ”
  &&  “ (addr_aligned current_task 4 ) ”
  &&  “ ((task_desc_map ((os_tasks (staged))) (current_task)) = (Some (current_desc))) ”
  &&  “ (rest_tasks = (cons (next_task) (next_rest))) ”
  &&  “ (next_link = (sched_link_of (next_task))) ”
  &&  ((&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((current_desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next_link)
  **  (wand (sepcon ((store_uchar (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((desc.(tdSchedMember) ).(tsmCurPrio) )))) ((sepcon ((store_uchar (&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((current_desc.(tdSchedMember) ).(tsmCurPrio) )))) ((store_ptr (&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) (next_link)))))) (os_inv (sg_semaphore_ic) (staged)) ))
.

Definition LinklistSuspend_entail_wit_6_1 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (other_desc: TaskDescriptorAbs) (prefix_loop_2: (@list Z)) (other_desc_2: TaskDescriptorAbs) (next_task: Z) (next_rest: (@list Z)) (ret: Z) (tail: Z) (node: Z) (current_task: Z) (next_link: Z) (rest_tasks_2: (@list Z)) (current_desc: TaskDescriptorAbs) (retval: Z) (PreH1 : (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((current_desc.(tdSchedMember) ).(tsmCurPrio) ))) (PreH2 : (retval = current_task)) (PreH3 : (addr_aligned retval 4 )) (PreH4 : (node = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH5 : (flag_pre = 1)) (PreH6 : (ret = 0)) (PreH7 : (tail = 0)) (PreH8 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH9 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH10 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH11 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH12 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH13 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH14 : (ktask_not_os_service task_pre staged )) (PreH15 : (waiting_semaphore_ic = (app (prefix_loop_2) ((cons (current_task) (rest_tasks_2)))))) (PreH16 : forall (scanned_2: Z), ((In scanned_2 prefix_loop_2 ) -> exists (other_desc_2: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned_2)) = (Some (other_desc_2))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc_2.(tdSchedMember) ).(tsmCurPrio) ))))) (PreH17 : (node = (sched_link_of (current_task)))) (PreH18 : (node <> list_pre)) (PreH19 : (addr_aligned current_task 4 )) (PreH20 : ((task_desc_map ((os_tasks (staged))) (current_task)) = (Some (current_desc)))) (PreH21 : (rest_tasks_2 = (cons (next_task) (next_rest)))) (PreH22 : (next_link = (sched_link_of (next_task)))),
  ((&((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((current_desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next_link)
  **  (wand (sepcon ((store_uchar (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((desc.(tdSchedMember) ).(tsmCurPrio) )))) ((sepcon ((store_uchar (&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((current_desc.(tdSchedMember) ).(tsmCurPrio) )))) ((store_ptr (&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) (next_link)))))) (os_inv (sg_semaphore_ic) (staged)) )
|--
  (EX (prefix_loop: (@list Z)) (suffix_loop: (@list Z)),
  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc))) ”
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (In task_pre (sched_owned_tasks ((os_tasks (staged)))) ) ”
  &&  “ (ktask_not_os_service task_pre staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_loop) (suffix_loop))) ”
  &&  “ forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) )))) ”
  &&  “ (suffix_loop = (@nil Z)) ”
  &&  “ (next_link = list_pre) ”
  &&  (os_inv sg_semaphore_ic staged ))
  ||
  (EX (first_task: Z) (rest_tasks: (@list Z)) (prefix_loop: (@list Z)) (suffix_loop: (@list Z)),
  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc))) ”
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (In task_pre (sched_owned_tasks ((os_tasks (staged)))) ) ”
  &&  “ (ktask_not_os_service task_pre staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_loop) (suffix_loop))) ”
  &&  “ forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) )))) ”
  &&  “ (suffix_loop = (cons (first_task) (rest_tasks))) ”
  &&  “ (next_link = (sched_link_of (first_task))) ”
  &&  (os_inv sg_semaphore_ic staged ))
.

Definition LinklistSuspend_entail_wit_6_2 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (other_desc: TaskDescriptorAbs) (prefix_loop_2: (@list Z)) (other_desc_2: TaskDescriptorAbs) (ret: Z) (tail: Z) (node: Z) (current_task: Z) (next_link: Z) (rest_tasks_2: (@list Z)) (current_desc: TaskDescriptorAbs) (retval: Z) (PreH1 : (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((current_desc.(tdSchedMember) ).(tsmCurPrio) ))) (PreH2 : (retval = current_task)) (PreH3 : (addr_aligned retval 4 )) (PreH4 : (node = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH5 : (next_link = list_pre)) (PreH6 : (flag_pre = 1)) (PreH7 : (ret = 0)) (PreH8 : (tail = 0)) (PreH9 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH10 : (next_link = (semaphore_pending_head (sem_semaphore_ic)))) (PreH11 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH12 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH13 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH14 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH15 : (ktask_not_os_service task_pre staged )) (PreH16 : (waiting_semaphore_ic = (app (prefix_loop_2) ((cons (current_task) (rest_tasks_2)))))) (PreH17 : forall (scanned_2: Z), ((In scanned_2 prefix_loop_2 ) -> exists (other_desc_2: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned_2)) = (Some (other_desc_2))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc_2.(tdSchedMember) ).(tsmCurPrio) ))))) (PreH18 : (node = (sched_link_of (current_task)))) (PreH19 : (node <> next_link)) (PreH20 : (addr_aligned current_task 4 )) (PreH21 : ((task_desc_map ((os_tasks (staged))) (current_task)) = (Some (current_desc)))) (PreH22 : (rest_tasks_2 = (@nil Z))),
  ((&((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((current_desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((( &( "list" ) )) # Ptr  |-> next_link)
  **  ((&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next_link)
  **  (wand (sepcon ((store_uchar (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((desc.(tdSchedMember) ).(tsmCurPrio) )))) ((sepcon ((store_uchar (&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((current_desc.(tdSchedMember) ).(tsmCurPrio) )))) ((store_ptr (&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) (next_link)))))) (os_inv (sg_semaphore_ic) (staged)) )
|--
  (EX (prefix_loop: (@list Z)) (suffix_loop: (@list Z)),
  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc))) ”
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (In task_pre (sched_owned_tasks ((os_tasks (staged)))) ) ”
  &&  “ (ktask_not_os_service task_pre staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_loop) (suffix_loop))) ”
  &&  “ forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) )))) ”
  &&  “ (suffix_loop = (@nil Z)) ”
  &&  “ (next_link = list_pre) ”
  &&  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  (os_inv sg_semaphore_ic staged ))
  ||
  (EX (first_task: Z) (rest_tasks: (@list Z)) (prefix_loop: (@list Z)) (suffix_loop: (@list Z)),
  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc))) ”
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (In task_pre (sched_owned_tasks ((os_tasks (staged)))) ) ”
  &&  “ (ktask_not_os_service task_pre staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_loop) (suffix_loop))) ”
  &&  “ forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) )))) ”
  &&  “ (suffix_loop = (cons (first_task) (rest_tasks))) ”
  &&  “ (next_link = (sched_link_of (first_task))) ”
  &&  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  (os_inv sg_semaphore_ic staged ))
.

Definition LinklistSuspend_entail_wit_7_1 :=
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (other_desc: TaskDescriptorAbs) (node: Z) (prefix_loop: (@list Z)) (suffix_loop: (@list Z)) (old_tmp: Z) (tail: Z) (ret: Z) (PreH1 : (node = list_pre)) (PreH2 : (flag_pre = 1)) (PreH3 : (ret = 0)) (PreH4 : (tail = 0)) (PreH5 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH6 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH7 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH8 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH9 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH10 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH11 : (ktask_not_os_service task_pre staged )) (PreH12 : (waiting_semaphore_ic = (app (prefix_loop) (suffix_loop)))) (PreH13 : forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) ))))) (PreH14 : (suffix_loop = (@nil Z))) (PreH15 : (node = list_pre)),
  (os_inv sg_semaphore_ic staged )
|--
  EX (after_prio: VarGlobalState) (new_nodes: (@list (@DL_Node Z))) (prefix_done: (@list Z)) (suffix_done: (@list Z)),
  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_done) (suffix_done))) ”
  &&  “ (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done))))))) ”
  &&  “ (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes ) ”
  &&  “ (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio ) ”
  &&  “ (node = list_pre) ”
  &&  “ (suffix_done = (@nil Z)) ”
  &&  “ (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0) ”
  &&  “ ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((old_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((old_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes))) ”
  &&  “ ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))) ”
  &&  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
) \/
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (other_desc: TaskDescriptorAbs) (node: Z) (prefix_loop: (@list Z)) (suffix_loop: (@list Z)) (old_tmp: Z) (tail: Z) (ret: Z) (PreH1 : (node = list_pre)) (PreH2 : (flag_pre = 1)) (PreH3 : (ret = 0)) (PreH4 : (tail = 0)) (PreH5 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH6 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH7 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH8 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH9 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH10 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH11 : (ktask_not_os_service task_pre staged )) (PreH12 : (waiting_semaphore_ic = (app (prefix_loop) (suffix_loop)))) (PreH13 : forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) ))))) (PreH14 : (suffix_loop = (@nil Z))) (PreH15 : (node = list_pre)),
  (os_inv sg_semaphore_ic staged )
|--
  EX (after_prio: VarGlobalState) (prefix_done: (@list Z)),
  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_done) ((@nil Z)))) ”
  &&  “ (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) ((@nil Z))))))) ) ”
  &&  “ (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio ) ”
  &&  “ (node = list_pre) ”
  &&  “ (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0) ”
  &&  “ ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((old_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((old_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) ((@nil Z)))))))))) ”
  &&  “ ((node = list_pre) -> ((map (sched_link_node) ((app (prefix_done) ((cons (task_pre) ((@nil Z))))))) = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))) ”
  &&  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) ((map (sched_link_node) ((app (prefix_done) ((cons (task_pre) ((@nil Z))))))))) (os_inv (sg_semaphore_ic) (after_prio)) )
).

Definition LinklistSuspend_entail_wit_7_2 :=
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (other_desc: TaskDescriptorAbs) (node: Z) (first_task: Z) (rest_tasks_2: (@list Z)) (prefix_loop: (@list Z)) (suffix_loop: (@list Z)) (old_tmp: Z) (tail: Z) (ret: Z) (PreH1 : (node = list_pre)) (PreH2 : (flag_pre = 1)) (PreH3 : (ret = 0)) (PreH4 : (tail = 0)) (PreH5 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH6 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH7 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH8 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH9 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH10 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH11 : (ktask_not_os_service task_pre staged )) (PreH12 : (waiting_semaphore_ic = (app (prefix_loop) (suffix_loop)))) (PreH13 : forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) ))))) (PreH14 : (suffix_loop = (cons (first_task) (rest_tasks_2)))) (PreH15 : (node = (sched_link_of (first_task)))),
  (os_inv sg_semaphore_ic staged )
|--
  EX (after_prio: VarGlobalState) (new_nodes: (@list (@DL_Node Z))) (prefix_done: (@list Z)) (suffix_done: (@list Z)),
  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_done) (suffix_done))) ”
  &&  “ (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done))))))) ”
  &&  “ (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes ) ”
  &&  “ (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio ) ”
  &&  “ (node = list_pre) ”
  &&  “ (suffix_done = (@nil Z)) ”
  &&  “ (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0) ”
  &&  “ ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((old_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((old_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes))) ”
  &&  “ ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))) ”
  &&  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
) \/
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (other_desc: TaskDescriptorAbs) (node: Z) (first_task: Z) (rest_tasks_2: (@list Z)) (prefix_loop: (@list Z)) (suffix_loop: (@list Z)) (old_tmp: Z) (tail: Z) (ret: Z) (PreH1 : (node = list_pre)) (PreH2 : (flag_pre = 1)) (PreH3 : (ret = 0)) (PreH4 : (tail = 0)) (PreH5 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH6 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH7 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH8 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH9 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH10 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH11 : (ktask_not_os_service task_pre staged )) (PreH12 : (waiting_semaphore_ic = (app (prefix_loop) (suffix_loop)))) (PreH13 : forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) ))))) (PreH14 : (suffix_loop = (cons (first_task) (rest_tasks_2)))) (PreH15 : (node = (sched_link_of (first_task)))),
  (os_inv sg_semaphore_ic staged )
|--
  EX (after_prio: VarGlobalState) (prefix_done: (@list Z)),
  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_done) ((@nil Z)))) ”
  &&  “ (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) ((@nil Z))))))) ) ”
  &&  “ (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio ) ”
  &&  “ (node = list_pre) ”
  &&  “ (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0) ”
  &&  “ ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((old_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((old_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) ((@nil Z)))))))))) ”
  &&  “ ((node = list_pre) -> ((map (sched_link_node) ((app (prefix_done) ((cons (task_pre) ((@nil Z))))))) = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))) ”
  &&  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) ((map (sched_link_node) ((app (prefix_done) ((cons (task_pre) ((@nil Z))))))))) (os_inv (sg_semaphore_ic) (after_prio)) )
).

Definition LinklistSuspend_entail_wit_7_3 :=
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (prefix_loop: (@list Z)) (other_desc: TaskDescriptorAbs) (next_task: Z) (next_rest: (@list Z)) (ret: Z) (tail: Z) (node: Z) (current_task: Z) (next_link: Z) (rest_tasks_2: (@list Z)) (current_desc: TaskDescriptorAbs) (retval: Z) (PreH1 : (((desc.(tdSchedMember) ).(tsmCurPrio) ) > ((current_desc.(tdSchedMember) ).(tsmCurPrio) ))) (PreH2 : (retval = current_task)) (PreH3 : (addr_aligned retval 4 )) (PreH4 : (node = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH5 : (flag_pre = 1)) (PreH6 : (ret = 0)) (PreH7 : (tail = 0)) (PreH8 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH9 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH10 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH11 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH12 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH13 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH14 : (ktask_not_os_service task_pre staged )) (PreH15 : (waiting_semaphore_ic = (app (prefix_loop) ((cons (current_task) (rest_tasks_2)))))) (PreH16 : forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) ))))) (PreH17 : (node = (sched_link_of (current_task)))) (PreH18 : (node <> list_pre)) (PreH19 : (addr_aligned current_task 4 )) (PreH20 : ((task_desc_map ((os_tasks (staged))) (current_task)) = (Some (current_desc)))) (PreH21 : (rest_tasks_2 = (cons (next_task) (next_rest)))) (PreH22 : (next_link = (sched_link_of (next_task)))),
  ((&((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((current_desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next_link)
  **  (wand (sepcon ((store_uchar (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((desc.(tdSchedMember) ).(tsmCurPrio) )))) ((sepcon ((store_uchar (&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((current_desc.(tdSchedMember) ).(tsmCurPrio) )))) ((store_ptr (&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) (next_link)))))) (os_inv (sg_semaphore_ic) (staged)) )
|--
  EX (rest_tasks: (@list Z)) (after_prio: VarGlobalState) (new_nodes: (@list (@DL_Node Z))) (prefix_done: (@list Z)) (suffix_done: (@list Z)),
  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_done) (suffix_done))) ”
  &&  “ (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done))))))) ”
  &&  “ (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes ) ”
  &&  “ (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio ) ”
  &&  “ (suffix_done = (cons (retval) (rest_tasks))) ”
  &&  “ (node = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ”
  &&  “ (node <> list_pre) ”
  &&  “ (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0) ”
  &&  “ ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes))) ”
  &&  “ ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))) ”
  &&  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
) \/
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (prefix_loop: (@list Z)) (other_desc: TaskDescriptorAbs) (next_task: Z) (next_rest: (@list Z)) (ret: Z) (tail: Z) (node: Z) (current_task: Z) (next_link: Z) (rest_tasks_2: (@list Z)) (current_desc: TaskDescriptorAbs) (retval: Z) (PreH1 : (((desc.(tdSchedMember) ).(tsmCurPrio) ) > ((current_desc.(tdSchedMember) ).(tsmCurPrio) ))) (PreH2 : (retval = current_task)) (PreH3 : (addr_aligned retval 4 )) (PreH4 : (node = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH5 : (flag_pre = 1)) (PreH6 : (ret = 0)) (PreH7 : (tail = 0)) (PreH8 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH9 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH10 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH11 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH12 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH13 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH14 : (ktask_not_os_service task_pre staged )) (PreH15 : (waiting_semaphore_ic = (app (prefix_loop) ((cons (current_task) (rest_tasks_2)))))) (PreH16 : forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) ))))) (PreH17 : (node = (sched_link_of (current_task)))) (PreH18 : (node <> list_pre)) (PreH19 : (addr_aligned current_task 4 )) (PreH20 : ((task_desc_map ((os_tasks (staged))) (current_task)) = (Some (current_desc)))) (PreH21 : (rest_tasks_2 = (cons (next_task) (next_rest)))) (PreH22 : (next_link = (sched_link_of (next_task)))),
  ((&((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((current_desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next_link)
  **  (wand (sepcon ((store_uchar (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((desc.(tdSchedMember) ).(tsmCurPrio) )))) ((sepcon ((store_uchar (&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((current_desc.(tdSchedMember) ).(tsmCurPrio) )))) ((store_ptr (&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) (next_link)))))) (os_inv (sg_semaphore_ic) (staged)) )
|--
  EX (rest_tasks: (@list Z)) (after_prio: VarGlobalState) (prefix_done: (@list Z)),
  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_done) ((cons (retval) (rest_tasks))))) ”
  &&  “ (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) ((cons (retval) (rest_tasks)))))))) ) ”
  &&  “ (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio ) ”
  &&  “ (node = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ”
  &&  “ (node <> list_pre) ”
  &&  “ (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0) ”
  &&  “ ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) ((cons (retval) (rest_tasks))))))))))) ”
  &&  “ ((node = list_pre) -> ((map (sched_link_node) ((app (prefix_done) ((cons (task_pre) ((cons (retval) (rest_tasks)))))))) = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))) ”
  &&  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) ((map (sched_link_node) ((app (prefix_done) ((cons (task_pre) ((cons (retval) (rest_tasks)))))))))) (os_inv (sg_semaphore_ic) (after_prio)) )
).

Definition LinklistSuspend_entail_wit_7_4 :=
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (prefix_loop: (@list Z)) (other_desc: TaskDescriptorAbs) (ret: Z) (tail: Z) (node: Z) (current_task: Z) (next_link: Z) (rest_tasks_2: (@list Z)) (current_desc: TaskDescriptorAbs) (retval: Z) (PreH1 : (((desc.(tdSchedMember) ).(tsmCurPrio) ) > ((current_desc.(tdSchedMember) ).(tsmCurPrio) ))) (PreH2 : (retval = current_task)) (PreH3 : (addr_aligned retval 4 )) (PreH4 : (node = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH5 : (next_link = list_pre)) (PreH6 : (flag_pre = 1)) (PreH7 : (ret = 0)) (PreH8 : (tail = 0)) (PreH9 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH10 : (next_link = (semaphore_pending_head (sem_semaphore_ic)))) (PreH11 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH12 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH13 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH14 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH15 : (ktask_not_os_service task_pre staged )) (PreH16 : (waiting_semaphore_ic = (app (prefix_loop) ((cons (current_task) (rest_tasks_2)))))) (PreH17 : forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) ))))) (PreH18 : (node = (sched_link_of (current_task)))) (PreH19 : (node <> next_link)) (PreH20 : (addr_aligned current_task 4 )) (PreH21 : ((task_desc_map ((os_tasks (staged))) (current_task)) = (Some (current_desc)))) (PreH22 : (rest_tasks_2 = (@nil Z))),
  ((&((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((current_desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((( &( "list" ) )) # Ptr  |-> next_link)
  **  ((&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next_link)
  **  (wand (sepcon ((store_uchar (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((desc.(tdSchedMember) ).(tsmCurPrio) )))) ((sepcon ((store_uchar (&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((current_desc.(tdSchedMember) ).(tsmCurPrio) )))) ((store_ptr (&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) (next_link)))))) (os_inv (sg_semaphore_ic) (staged)) )
|--
  EX (rest_tasks: (@list Z)) (after_prio: VarGlobalState) (new_nodes: (@list (@DL_Node Z))) (prefix_done: (@list Z)) (suffix_done: (@list Z)),
  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_done) (suffix_done))) ”
  &&  “ (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done))))))) ”
  &&  “ (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes ) ”
  &&  “ (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio ) ”
  &&  “ (suffix_done = (cons (retval) (rest_tasks))) ”
  &&  “ (node = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ”
  &&  “ (node <> list_pre) ”
  &&  “ (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0) ”
  &&  “ ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes))) ”
  &&  “ ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))) ”
  &&  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
) \/
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (prefix_loop: (@list Z)) (other_desc: TaskDescriptorAbs) (ret: Z) (tail: Z) (node: Z) (current_task: Z) (next_link: Z) (rest_tasks_2: (@list Z)) (current_desc: TaskDescriptorAbs) (retval: Z) (PreH1 : (((desc.(tdSchedMember) ).(tsmCurPrio) ) > ((current_desc.(tdSchedMember) ).(tsmCurPrio) ))) (PreH2 : (retval = current_task)) (PreH3 : (addr_aligned retval 4 )) (PreH4 : (node = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH5 : (next_link = list_pre)) (PreH6 : (flag_pre = 1)) (PreH7 : (ret = 0)) (PreH8 : (tail = 0)) (PreH9 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH10 : (next_link = (semaphore_pending_head (sem_semaphore_ic)))) (PreH11 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH12 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH13 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH14 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH15 : (ktask_not_os_service task_pre staged )) (PreH16 : (waiting_semaphore_ic = (app (prefix_loop) ((cons (current_task) (rest_tasks_2)))))) (PreH17 : forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) ))))) (PreH18 : (node = (sched_link_of (current_task)))) (PreH19 : (node <> next_link)) (PreH20 : (addr_aligned current_task 4 )) (PreH21 : ((task_desc_map ((os_tasks (staged))) (current_task)) = (Some (current_desc)))) (PreH22 : (rest_tasks_2 = (@nil Z))),
  ((&((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((current_desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next_link)
  **  (wand (sepcon ((store_uchar (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((desc.(tdSchedMember) ).(tsmCurPrio) )))) ((sepcon ((store_uchar (&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((current_desc.(tdSchedMember) ).(tsmCurPrio) )))) ((store_ptr (&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) (next_link)))))) (os_inv (sg_semaphore_ic) (staged)) )
|--
  EX (rest_tasks: (@list Z)) (after_prio: VarGlobalState) (prefix_done: (@list Z)),
  “ (next_link = list_pre) ”
  &&  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_done) ((cons (retval) (rest_tasks))))) ”
  &&  “ (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) ((cons (retval) (rest_tasks)))))))) ) ”
  &&  “ (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio ) ”
  &&  “ (node = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ”
  &&  “ (node <> list_pre) ”
  &&  “ (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0) ”
  &&  “ ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) ((cons (retval) (rest_tasks))))))))))) ”
  &&  “ ((node = list_pre) -> ((map (sched_link_node) ((app (prefix_done) ((cons (task_pre) ((cons (retval) (rest_tasks)))))))) = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))) ”
  &&  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) ((map (sched_link_node) ((app (prefix_done) ((cons (task_pre) ((cons (retval) (rest_tasks)))))))))) (os_inv (sg_semaphore_ic) (after_prio)) )
).

Definition LinklistSuspend_return_wit_1 :=
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (after_fifo: VarGlobalState) (PreH1 : (flag_pre = 0)) (PreH2 : (ret = 0)) (PreH3 : (node = 0)) (PreH4 : (tail = 0)) (PreH5 : (tmp_task = 0)) (PreH6 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH7 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 0 staged after_fifo )) (PreH8 : ((sched_link_of (task_pre)) = &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH9 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH10 : (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) list_pre )) (PreH11 : ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (list_pre) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))),
  (os_inv sg_semaphore_ic after_fifo )
|--
  EX (after: VarGlobalState),
  “ (linklist_suspend_step sem_semaphore_ic task_pre flag_pre before_semaphore_ic ret after ) ”
  &&  (os_inv sg_semaphore_ic after )
) \/
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (after_fifo: VarGlobalState) (PreH1 : (flag_pre = 0)) (PreH2 : (ret = 0)) (PreH3 : (node = 0)) (PreH4 : (tail = 0)) (PreH5 : (tmp_task = 0)) (PreH6 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH7 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 0 staged after_fifo )) (PreH8 : ((sched_link_of (task_pre)) = &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH9 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH10 : (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) list_pre )) (PreH11 : ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (list_pre) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))),
  TT && emp 
|--
  “ (linklist_suspend_step sem_semaphore_ic task_pre 0 before_semaphore_ic 0 after_fifo ) ”
  &&  emp
).

Definition LinklistSuspend_return_wit_1_split_goal_1 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (after_fifo: VarGlobalState) (PreH1 : (flag_pre = 0)) (PreH2 : (ret = 0)) (PreH3 : (node = 0)) (PreH4 : (tail = 0)) (PreH5 : (tmp_task = 0)) (PreH6 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH7 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 0 staged after_fifo )) (PreH8 : ((sched_link_of (task_pre)) = &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH9 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH10 : (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) list_pre )) (PreH11 : ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (list_pre) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))),
  (linklist_suspend_step sem_semaphore_ic task_pre 0 before_semaphore_ic 0 after_fifo )
.

Definition LinklistSuspend_return_wit_2 :=
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (rest_tasks: (@list Z)) (ret: Z) (tail: Z) (node: Z) (prefix_done: (@list Z)) (suffix_done: (@list Z)) (last_tmp: Z) (new_nodes: (@list (@DL_Node Z))) (after_prio: VarGlobalState) (PreH1 : (node <> list_pre)) (PreH2 : (flag_pre = 1)) (PreH3 : (ret = 0)) (PreH4 : (tail = 0)) (PreH5 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH6 : (waiting_semaphore_ic = (app (prefix_done) (suffix_done)))) (PreH7 : (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done)))))))) (PreH8 : (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes )) (PreH9 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio )) (PreH10 : (suffix_done = (cons (last_tmp) (rest_tasks)))) (PreH11 : (node = &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH12 : (node <> list_pre)) (PreH13 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH14 : ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)))) (PreH15 : ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))))),
  (os_inv sg_semaphore_ic after_prio )
|--
  EX (after: VarGlobalState),
  “ (linklist_suspend_step sem_semaphore_ic task_pre flag_pre before_semaphore_ic ret after ) ”
  &&  (os_inv sg_semaphore_ic after )
) \/
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (rest_tasks: (@list Z)) (ret: Z) (tail: Z) (node: Z) (prefix_done: (@list Z)) (suffix_done: (@list Z)) (last_tmp: Z) (new_nodes: (@list (@DL_Node Z))) (after_prio: VarGlobalState) (PreH1 : (node <> list_pre)) (PreH2 : (flag_pre = 1)) (PreH3 : (ret = 0)) (PreH4 : (tail = 0)) (PreH5 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH6 : (waiting_semaphore_ic = (app (prefix_done) (suffix_done)))) (PreH7 : (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done)))))))) (PreH8 : (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes )) (PreH9 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio )) (PreH10 : (suffix_done = (cons (last_tmp) (rest_tasks)))) (PreH11 : (node = &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH12 : (node <> list_pre)) (PreH13 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH14 : ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)))) (PreH15 : ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))))),
  TT && emp 
|--
  “ (linklist_suspend_step sem_semaphore_ic task_pre 1 before_semaphore_ic 0 after_prio ) ”
  &&  emp
).

Definition LinklistSuspend_return_wit_2_split_goal_1 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (rest_tasks: (@list Z)) (ret: Z) (tail: Z) (node: Z) (prefix_done: (@list Z)) (suffix_done: (@list Z)) (last_tmp: Z) (new_nodes: (@list (@DL_Node Z))) (after_prio: VarGlobalState) (PreH1 : (node <> list_pre)) (PreH2 : (flag_pre = 1)) (PreH3 : (ret = 0)) (PreH4 : (tail = 0)) (PreH5 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH6 : (waiting_semaphore_ic = (app (prefix_done) (suffix_done)))) (PreH7 : (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done)))))))) (PreH8 : (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes )) (PreH9 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio )) (PreH10 : (suffix_done = (cons (last_tmp) (rest_tasks)))) (PreH11 : (node = &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH12 : (node <> list_pre)) (PreH13 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH14 : ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)))) (PreH15 : ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))))),
  (linklist_suspend_step sem_semaphore_ic task_pre 1 before_semaphore_ic 0 after_prio )
.

Definition LinklistSuspend_return_wit_3 :=
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (ret: Z) (tail: Z) (node: Z) (prefix_done: (@list Z)) (suffix_done: (@list Z)) (last_tmp: Z) (new_nodes: (@list (@DL_Node Z))) (after_prio: VarGlobalState) (last_link: Z) (PreH1 : (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) last_link )) (PreH2 : ((dll_insert_after_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (last_link) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)) (PreH3 : (node = list_pre)) (PreH4 : (flag_pre = 1)) (PreH5 : (ret = 0)) (PreH6 : (tail = 0)) (PreH7 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH8 : (waiting_semaphore_ic = (app (prefix_done) (suffix_done)))) (PreH9 : (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done)))))))) (PreH10 : (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes )) (PreH11 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio )) (PreH12 : (node = list_pre)) (PreH13 : (suffix_done = (@nil Z))) (PreH14 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH15 : ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)))) (PreH16 : ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))))),
  (os_inv sg_semaphore_ic after_prio )
|--
  EX (after: VarGlobalState),
  “ (linklist_suspend_step sem_semaphore_ic task_pre flag_pre before_semaphore_ic ret after ) ”
  &&  (os_inv sg_semaphore_ic after )
) \/
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (ret: Z) (tail: Z) (node: Z) (prefix_done: (@list Z)) (suffix_done: (@list Z)) (last_tmp: Z) (new_nodes: (@list (@DL_Node Z))) (after_prio: VarGlobalState) (last_link: Z) (PreH1 : (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) last_link )) (PreH2 : ((dll_insert_after_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (last_link) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)) (PreH3 : (node = list_pre)) (PreH4 : (flag_pre = 1)) (PreH5 : (ret = 0)) (PreH6 : (tail = 0)) (PreH7 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH8 : (waiting_semaphore_ic = (app (prefix_done) (suffix_done)))) (PreH9 : (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done)))))))) (PreH10 : (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes )) (PreH11 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio )) (PreH12 : (node = list_pre)) (PreH13 : (suffix_done = (@nil Z))) (PreH14 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH15 : ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)))) (PreH16 : ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))))),
  TT && emp 
|--
  “ (linklist_suspend_step sem_semaphore_ic task_pre 1 before_semaphore_ic 0 after_prio ) ”
  &&  emp
).

Definition LinklistSuspend_return_wit_3_split_goal_1 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (ret: Z) (tail: Z) (node: Z) (prefix_done: (@list Z)) (suffix_done: (@list Z)) (last_tmp: Z) (new_nodes: (@list (@DL_Node Z))) (after_prio: VarGlobalState) (last_link: Z) (PreH1 : (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) last_link )) (PreH2 : ((dll_insert_after_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (last_link) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)) (PreH3 : (node = list_pre)) (PreH4 : (flag_pre = 1)) (PreH5 : (ret = 0)) (PreH6 : (tail = 0)) (PreH7 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH8 : (waiting_semaphore_ic = (app (prefix_done) (suffix_done)))) (PreH9 : (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done)))))))) (PreH10 : (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes )) (PreH11 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio )) (PreH12 : (node = list_pre)) (PreH13 : (suffix_done = (@nil Z))) (PreH14 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH15 : ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)))) (PreH16 : ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))))),
  (linklist_suspend_step sem_semaphore_ic task_pre 1 before_semaphore_ic 0 after_prio )
.

Definition LinklistSuspend_return_wit_4 :=
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (PreH1 : (flag_pre <> 1)) (PreH2 : (flag_pre <> 0)) (PreH3 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH4 : (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH5 : (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic )),
  (os_inv sg_semaphore_ic before_semaphore_ic )
|--
  EX (after: VarGlobalState),
  “ (linklist_suspend_step sem_semaphore_ic task_pre flag_pre before_semaphore_ic (-10) after ) ”
  &&  (os_inv sg_semaphore_ic after )
) \/
(
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (PreH1 : (flag_pre <> 1)) (PreH2 : (flag_pre <> 0)) (PreH3 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH4 : (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH5 : (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic )),
  TT && emp 
|--
  “ (linklist_suspend_step sem_semaphore_ic task_pre flag_pre before_semaphore_ic (-10) before_semaphore_ic ) ”
  &&  emp
).

Definition LinklistSuspend_return_wit_4_split_goal_1 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (PreH1 : (flag_pre <> 1)) (PreH2 : (flag_pre <> 0)) (PreH3 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH4 : (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH5 : (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic )),
  (linklist_suspend_step sem_semaphore_ic task_pre flag_pre before_semaphore_ic (-10) before_semaphore_ic )
.

Definition LinklistSuspend_partial_solve_wit_1 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (task_id: Z) (PreH1 : (0 <= task_id)) (PreH2 : (task_id < 65536)) (PreH3 : (get_task_with_idnode_success sg_semaphore_ic before_semaphore_ic task_id task_pre )) (PreH4 : (flag_pre = 0)) (PreH5 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH6 : (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH7 : (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic )) (PreH8 : (ret = 0)) (PreH9 : (node = 0)) (PreH10 : (tail = 0)) (PreH11 : (tmp_task = 0)),
  ((&((task_pre)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (wand (store_ushort (&((task_pre)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (task_id)) (os_inv (sg_semaphore_ic) (before_semaphore_ic)) )
|--
  “ (0 <= task_id) ”
  &&  “ (task_id < 65536) ”
  &&  “ (get_task_with_idnode_success sg_semaphore_ic before_semaphore_ic task_id task_pre ) ”
  &&  “ (flag_pre = 0) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic ) ”
  &&  “ (ret = 0) ”
  &&  “ (node = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (tmp_task = 0) ”
  &&  ((&((task_pre)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (wand (store_ushort (&((task_pre)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (task_id)) (os_inv (sg_semaphore_ic) (before_semaphore_ic)) )
.

Definition LinklistSuspend_partial_solve_wit_2 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (task_id: Z) (PreH1 : (0 <= task_id)) (PreH2 : (task_id < 65536)) (PreH3 : (get_task_with_idnode_success sg_semaphore_ic before_semaphore_ic task_id task_pre )) (PreH4 : (flag_pre = 1)) (PreH5 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH6 : (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH7 : (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic )) (PreH8 : (ret = 0)) (PreH9 : (node = 0)) (PreH10 : (tail = 0)) (PreH11 : (tmp_task = 0)),
  ((&((task_pre)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (wand (store_ushort (&((task_pre)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (task_id)) (os_inv (sg_semaphore_ic) (before_semaphore_ic)) )
|--
  “ (0 <= task_id) ”
  &&  “ (task_id < 65536) ”
  &&  “ (get_task_with_idnode_success sg_semaphore_ic before_semaphore_ic task_id task_pre ) ”
  &&  “ (flag_pre = 1) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic ) ”
  &&  “ (ret = 0) ”
  &&  “ (node = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (tmp_task = 0) ”
  &&  ((&((task_pre)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (wand (store_ushort (&((task_pre)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (task_id)) (os_inv (sg_semaphore_ic) (before_semaphore_ic)) )
.

Definition LinklistSuspend_partial_solve_wit_3_pure :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (task_id: Z) (PreH1 : (0 <= task_id)) (PreH2 : (task_id < 65536)) (PreH3 : (get_task_with_idnode_success sg_semaphore_ic before_semaphore_ic task_id task_pre )) (PreH4 : (flag_pre = 1)) (PreH5 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH6 : (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH7 : (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic )) (PreH8 : (ret = 0)) (PreH9 : (node = 0)) (PreH10 : (tail = 0)) (PreH11 : (tmp_task = 0)),
  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  (os_inv sg_semaphore_ic before_semaphore_ic )
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  ((( &( "ret" ) )) # Int  |-> ret)
  **  ((( &( "node" ) )) # Ptr  |-> node)
  **  ((( &( "tail" ) )) # Ptr  |-> tail)
  **  ((( &( "tmp_task" ) )) # Ptr  |-> tmp_task)
  **  ((( &( "suspend_id" ) )) # Int  |-> task_id)
|--
  “ (task_id < 65536) ”
.

Definition LinklistSuspend_partial_solve_wit_3_aux :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (task_id: Z) (PreH1 : (0 <= task_id)) (PreH2 : (task_id < 65536)) (PreH3 : (get_task_with_idnode_success sg_semaphore_ic before_semaphore_ic task_id task_pre )) (PreH4 : (flag_pre = 1)) (PreH5 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH6 : (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH7 : (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic )) (PreH8 : (ret = 0)) (PreH9 : (node = 0)) (PreH10 : (tail = 0)) (PreH11 : (tmp_task = 0)),
  (os_inv sg_semaphore_ic before_semaphore_ic )
|--
  “ (task_id < 65536) ”
  &&  “ (0 <= task_id) ”
  &&  “ (task_id < 65536) ”
  &&  “ (get_task_with_idnode_success sg_semaphore_ic before_semaphore_ic task_id task_pre ) ”
  &&  “ (flag_pre = 1) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic ) ”
  &&  “ (ret = 0) ”
  &&  “ (node = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (tmp_task = 0) ”
  &&  (os_inv sg_semaphore_ic before_semaphore_ic )
.

Definition LinklistSuspend_partial_solve_wit_3 := LinklistSuspend_partial_solve_wit_3_pure -> LinklistSuspend_partial_solve_wit_3_aux.

Definition LinklistSuspend_partial_solve_wit_4_pure :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (task_id: Z) (PreH1 : (0 <= task_id)) (PreH2 : (task_id < 65536)) (PreH3 : (get_task_with_idnode_success sg_semaphore_ic before_semaphore_ic task_id task_pre )) (PreH4 : (flag_pre = 0)) (PreH5 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH6 : (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH7 : (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic )) (PreH8 : (ret = 0)) (PreH9 : (node = 0)) (PreH10 : (tail = 0)) (PreH11 : (tmp_task = 0)),
  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  (os_inv sg_semaphore_ic before_semaphore_ic )
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  ((( &( "ret" ) )) # Int  |-> ret)
  **  ((( &( "node" ) )) # Ptr  |-> node)
  **  ((( &( "tail" ) )) # Ptr  |-> tail)
  **  ((( &( "tmp_task" ) )) # Ptr  |-> tmp_task)
  **  ((( &( "suspend_id" ) )) # Int  |-> task_id)
|--
  “ (task_id < 65536) ”
.

Definition LinklistSuspend_partial_solve_wit_4_aux :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (task_id: Z) (PreH1 : (0 <= task_id)) (PreH2 : (task_id < 65536)) (PreH3 : (get_task_with_idnode_success sg_semaphore_ic before_semaphore_ic task_id task_pre )) (PreH4 : (flag_pre = 0)) (PreH5 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH6 : (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH7 : (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic )) (PreH8 : (ret = 0)) (PreH9 : (node = 0)) (PreH10 : (tail = 0)) (PreH11 : (tmp_task = 0)),
  (os_inv sg_semaphore_ic before_semaphore_ic )
|--
  “ (task_id < 65536) ”
  &&  “ (0 <= task_id) ”
  &&  “ (task_id < 65536) ”
  &&  “ (get_task_with_idnode_success sg_semaphore_ic before_semaphore_ic task_id task_pre ) ”
  &&  “ (flag_pre = 0) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic ) ”
  &&  “ (ret = 0) ”
  &&  “ (node = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (tmp_task = 0) ”
  &&  (os_inv sg_semaphore_ic before_semaphore_ic )
.

Definition LinklistSuspend_partial_solve_wit_4 := LinklistSuspend_partial_solve_wit_4_pure -> LinklistSuspend_partial_solve_wit_4_aux.

Definition LinklistSuspend_partial_solve_wit_5_pure :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (task_id: Z) (staged: VarGlobalState) (ignored: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (after_fifo: VarGlobalState) (PreH1 : (flag_pre = 0)) (PreH2 : (ret = 0)) (PreH3 : (node = 0)) (PreH4 : (tail = 0)) (PreH5 : (tmp_task = 0)) (PreH6 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH7 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 0 staged after_fifo )) (PreH8 : ((sched_link_of (task_pre)) = &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH9 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH10 : (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) list_pre )) (PreH11 : ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (list_pre) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))),
  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  ((( &( "ret" ) )) # Int  |-> ret)
  **  ((( &( "node" ) )) # Ptr  |-> node)
  **  ((( &( "tail" ) )) # Ptr  |-> tail)
  **  ((( &( "tmp_task" ) )) # Ptr  |-> tmp_task)
  **  ((( &( "suspend_id" ) )) # Int  |-> task_id)
  **  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) ((map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))) (os_inv (sg_semaphore_ic) (after_fifo)) )
|--
  “ (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) list_pre ) ”
  &&  “ (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0) ”
.

Definition LinklistSuspend_partial_solve_wit_5_aux :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (after_fifo: VarGlobalState) (PreH1 : (flag_pre = 0)) (PreH2 : (ret = 0)) (PreH3 : (node = 0)) (PreH4 : (tail = 0)) (PreH5 : (tmp_task = 0)) (PreH6 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH7 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 0 staged after_fifo )) (PreH8 : ((sched_link_of (task_pre)) = &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH9 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH10 : (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) list_pre )) (PreH11 : ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (list_pre) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) ((map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))) (os_inv (sg_semaphore_ic) (after_fifo)) )
|--
  “ (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) list_pre ) ”
  &&  “ (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0) ”
  &&  “ (flag_pre = 0) ”
  &&  “ (ret = 0) ”
  &&  “ (node = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (tmp_task = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (linklist_semaphore_enqueue sem_semaphore_ic task_pre 0 staged after_fifo ) ”
  &&  “ ((sched_link_of (task_pre)) = &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ”
  &&  “ (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0) ”
  &&  “ (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) list_pre ) ”
  &&  “ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (list_pre) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))) ”
  &&  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) ((map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))) (os_inv (sg_semaphore_ic) (after_fifo)) )
.

Definition LinklistSuspend_partial_solve_wit_5 := LinklistSuspend_partial_solve_wit_5_pure -> LinklistSuspend_partial_solve_wit_5_aux.

Definition LinklistSuspend_partial_solve_wit_6_pure :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (task_id: Z) (staged: VarGlobalState) (ignored: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (after_fifo: VarGlobalState) (PreH1 : (flag_pre = 0)) (PreH2 : (ret = 0)) (PreH3 : (node = 0)) (PreH4 : (tail = 0)) (PreH5 : (tmp_task = 0)) (PreH6 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH7 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 0 staged after_fifo )) (PreH8 : ((sched_link_of (task_pre)) = &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH9 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH10 : (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) list_pre )) (PreH11 : ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (list_pre) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (list_pre) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  ((( &( "ret" ) )) # Int  |-> ret)
  **  ((( &( "node" ) )) # Ptr  |-> node)
  **  ((( &( "tail" ) )) # Ptr  |-> tail)
  **  ((( &( "tmp_task" ) )) # Ptr  |-> tmp_task)
  **  ((( &( "suspend_id" ) )) # Int  |-> task_id)
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) ((map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))) (os_inv (sg_semaphore_ic) (after_fifo)) )
|--
  “ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (list_pre) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))) ”
.

Definition LinklistSuspend_partial_solve_wit_6_aux :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (after_fifo: VarGlobalState) (PreH1 : (flag_pre = 0)) (PreH2 : (ret = 0)) (PreH3 : (node = 0)) (PreH4 : (tail = 0)) (PreH5 : (tmp_task = 0)) (PreH6 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH7 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 0 staged after_fifo )) (PreH8 : ((sched_link_of (task_pre)) = &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH9 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH10 : (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) list_pre )) (PreH11 : ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (list_pre) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (list_pre) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) ((map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))) (os_inv (sg_semaphore_ic) (after_fifo)) )
|--
  “ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (list_pre) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))) ”
  &&  “ (flag_pre = 0) ”
  &&  “ (ret = 0) ”
  &&  “ (node = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (tmp_task = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (linklist_semaphore_enqueue sem_semaphore_ic task_pre 0 staged after_fifo ) ”
  &&  “ ((sched_link_of (task_pre)) = &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ”
  &&  “ (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0) ”
  &&  “ (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) list_pre ) ”
  &&  “ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (list_pre) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))) ”
  &&  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (list_pre) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) ((map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))) (os_inv (sg_semaphore_ic) (after_fifo)) )
.

Definition LinklistSuspend_partial_solve_wit_6 := LinklistSuspend_partial_solve_wit_6_pure -> LinklistSuspend_partial_solve_wit_6_aux.

Definition LinklistSuspend_partial_solve_wit_7_pure :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (task_id: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (PreH1 : (flag_pre = 1)) (PreH2 : (flag_pre <> 0)) (PreH3 : (flag_pre = 1)) (PreH4 : (ret = 0)) (PreH5 : (node = 0)) (PreH6 : (tail = 0)) (PreH7 : (tmp_task = 0)) (PreH8 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH9 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH10 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH11 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH12 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH13 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH14 : (ktask_not_os_service task_pre staged )),
  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  ((( &( "ret" ) )) # Int  |-> ret)
  **  ((( &( "node" ) )) # Ptr  |-> node)
  **  ((( &( "tail" ) )) # Ptr  |-> tail)
  **  ((( &( "tmp_task" ) )) # Ptr  |-> tmp_task)
  **  ((( &( "suspend_id" ) )) # Int  |-> task_id)
  **  (os_inv sg_semaphore_ic staged )
|--
  “ (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
.

Definition LinklistSuspend_partial_solve_wit_7_aux :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (ret: Z) (node: Z) (tail: Z) (tmp_task: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (PreH1 : (flag_pre = 1)) (PreH2 : (flag_pre <> 0)) (PreH3 : (flag_pre = 1)) (PreH4 : (ret = 0)) (PreH5 : (node = 0)) (PreH6 : (tail = 0)) (PreH7 : (tmp_task = 0)) (PreH8 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH9 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH10 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH11 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH12 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH13 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH14 : (ktask_not_os_service task_pre staged )),
  (os_inv sg_semaphore_ic staged )
|--
  “ (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ (flag_pre = 1) ”
  &&  “ (flag_pre <> 0) ”
  &&  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (node = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (tmp_task = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc))) ”
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (In task_pre (sched_owned_tasks ((os_tasks (staged)))) ) ”
  &&  “ (ktask_not_os_service task_pre staged ) ”
  &&  (os_inv sg_semaphore_ic staged )
.

Definition LinklistSuspend_partial_solve_wit_7 := LinklistSuspend_partial_solve_wit_7_pure -> LinklistSuspend_partial_solve_wit_7_aux.

Definition LinklistSuspend_partial_solve_wit_8_pure :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (task_id: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (prefix_loop: (@list Z)) (old_tmp: Z) (other_desc: TaskDescriptorAbs) (ret: Z) (tail: Z) (node: Z) (current_task: Z) (next_link: Z) (rest_tasks: (@list Z)) (current_desc: TaskDescriptorAbs) (PreH1 : (next_link = list_pre)) (PreH2 : (flag_pre = 1)) (PreH3 : (ret = 0)) (PreH4 : (tail = 0)) (PreH5 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH6 : (next_link = (semaphore_pending_head (sem_semaphore_ic)))) (PreH7 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH8 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH9 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH10 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH11 : (ktask_not_os_service task_pre staged )) (PreH12 : (waiting_semaphore_ic = (app (prefix_loop) ((cons (current_task) (rest_tasks)))))) (PreH13 : forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) ))))) (PreH14 : (node = (sched_link_of (current_task)))) (PreH15 : (node <> next_link)) (PreH16 : (addr_aligned current_task 4 )) (PreH17 : ((task_desc_map ((os_tasks (staged))) (current_task)) = (Some (current_desc)))) (PreH18 : (rest_tasks = (@nil Z))),
  ((( &( "list" ) )) # Ptr  |-> next_link)
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  ((( &( "ret" ) )) # Int  |-> ret)
  **  ((( &( "tail" ) )) # Ptr  |-> tail)
  **  ((( &( "tmp_task" ) )) # Ptr  |-> old_tmp)
  **  ((( &( "suspend_id" ) )) # Int  |-> task_id)
  **  ((( &( "node" ) )) # Ptr  |-> node)
  **  ((&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((current_desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next_link)
  **  (wand (sepcon ((store_uchar (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((desc.(tdSchedMember) ).(tsmCurPrio) )))) ((sepcon ((store_uchar (&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((current_desc.(tdSchedMember) ).(tsmCurPrio) )))) ((store_ptr (&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) (next_link)))))) (os_inv (sg_semaphore_ic) (staged)) )
|--
  “ (addr_aligned current_task 4 ) ”
  &&  “ (node = (sched_link_of (current_task))) ”
.

Definition LinklistSuspend_partial_solve_wit_8_aux :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (prefix_loop: (@list Z)) (other_desc: TaskDescriptorAbs) (ret: Z) (tail: Z) (node: Z) (current_task: Z) (next_link: Z) (rest_tasks: (@list Z)) (current_desc: TaskDescriptorAbs) (PreH1 : (next_link = list_pre)) (PreH2 : (flag_pre = 1)) (PreH3 : (ret = 0)) (PreH4 : (tail = 0)) (PreH5 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH6 : (next_link = (semaphore_pending_head (sem_semaphore_ic)))) (PreH7 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH8 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH9 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH10 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH11 : (ktask_not_os_service task_pre staged )) (PreH12 : (waiting_semaphore_ic = (app (prefix_loop) ((cons (current_task) (rest_tasks)))))) (PreH13 : forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) ))))) (PreH14 : (node = (sched_link_of (current_task)))) (PreH15 : (node <> next_link)) (PreH16 : (addr_aligned current_task 4 )) (PreH17 : ((task_desc_map ((os_tasks (staged))) (current_task)) = (Some (current_desc)))) (PreH18 : (rest_tasks = (@nil Z))),
  ((&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((current_desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next_link)
  **  (wand (sepcon ((store_uchar (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((desc.(tdSchedMember) ).(tsmCurPrio) )))) ((sepcon ((store_uchar (&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((current_desc.(tdSchedMember) ).(tsmCurPrio) )))) ((store_ptr (&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) (next_link)))))) (os_inv (sg_semaphore_ic) (staged)) )
|--
  “ (addr_aligned current_task 4 ) ”
  &&  “ (node = (sched_link_of (current_task))) ”
  &&  “ (next_link = list_pre) ”
  &&  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (next_link = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc))) ”
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (In task_pre (sched_owned_tasks ((os_tasks (staged)))) ) ”
  &&  “ (ktask_not_os_service task_pre staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_loop) ((cons (current_task) (rest_tasks))))) ”
  &&  “ forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) )))) ”
  &&  “ (node = (sched_link_of (current_task))) ”
  &&  “ (node <> next_link) ”
  &&  “ (addr_aligned current_task 4 ) ”
  &&  “ ((task_desc_map ((os_tasks (staged))) (current_task)) = (Some (current_desc))) ”
  &&  “ (rest_tasks = (@nil Z)) ”
  &&  ((&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((current_desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next_link)
  **  (wand (sepcon ((store_uchar (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((desc.(tdSchedMember) ).(tsmCurPrio) )))) ((sepcon ((store_uchar (&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((current_desc.(tdSchedMember) ).(tsmCurPrio) )))) ((store_ptr (&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) (next_link)))))) (os_inv (sg_semaphore_ic) (staged)) )
.

Definition LinklistSuspend_partial_solve_wit_8 := LinklistSuspend_partial_solve_wit_8_pure -> LinklistSuspend_partial_solve_wit_8_aux.

Definition LinklistSuspend_partial_solve_wit_9_pure :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (task_id: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (prefix_loop: (@list Z)) (old_tmp: Z) (other_desc: TaskDescriptorAbs) (next_task: Z) (next_rest: (@list Z)) (ret: Z) (tail: Z) (node: Z) (current_task: Z) (next_link: Z) (rest_tasks: (@list Z)) (current_desc: TaskDescriptorAbs) (PreH1 : (flag_pre = 1)) (PreH2 : (ret = 0)) (PreH3 : (tail = 0)) (PreH4 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH5 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH6 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH7 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH8 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH9 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH10 : (ktask_not_os_service task_pre staged )) (PreH11 : (waiting_semaphore_ic = (app (prefix_loop) ((cons (current_task) (rest_tasks)))))) (PreH12 : forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) ))))) (PreH13 : (node = (sched_link_of (current_task)))) (PreH14 : (node <> list_pre)) (PreH15 : (addr_aligned current_task 4 )) (PreH16 : ((task_desc_map ((os_tasks (staged))) (current_task)) = (Some (current_desc)))) (PreH17 : (rest_tasks = (cons (next_task) (next_rest)))) (PreH18 : (next_link = (sched_link_of (next_task)))),
  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  ((( &( "ret" ) )) # Int  |-> ret)
  **  ((( &( "tail" ) )) # Ptr  |-> tail)
  **  ((( &( "tmp_task" ) )) # Ptr  |-> old_tmp)
  **  ((( &( "suspend_id" ) )) # Int  |-> task_id)
  **  ((( &( "node" ) )) # Ptr  |-> node)
  **  ((&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((current_desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next_link)
  **  (wand (sepcon ((store_uchar (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((desc.(tdSchedMember) ).(tsmCurPrio) )))) ((sepcon ((store_uchar (&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((current_desc.(tdSchedMember) ).(tsmCurPrio) )))) ((store_ptr (&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) (next_link)))))) (os_inv (sg_semaphore_ic) (staged)) )
|--
  “ (addr_aligned current_task 4 ) ”
  &&  “ (node = (sched_link_of (current_task))) ”
.

Definition LinklistSuspend_partial_solve_wit_9_aux :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (prefix_loop: (@list Z)) (other_desc: TaskDescriptorAbs) (next_task: Z) (next_rest: (@list Z)) (ret: Z) (tail: Z) (node: Z) (current_task: Z) (next_link: Z) (rest_tasks: (@list Z)) (current_desc: TaskDescriptorAbs) (PreH1 : (flag_pre = 1)) (PreH2 : (ret = 0)) (PreH3 : (tail = 0)) (PreH4 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH5 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH6 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH7 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH8 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH9 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH10 : (ktask_not_os_service task_pre staged )) (PreH11 : (waiting_semaphore_ic = (app (prefix_loop) ((cons (current_task) (rest_tasks)))))) (PreH12 : forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) ))))) (PreH13 : (node = (sched_link_of (current_task)))) (PreH14 : (node <> list_pre)) (PreH15 : (addr_aligned current_task 4 )) (PreH16 : ((task_desc_map ((os_tasks (staged))) (current_task)) = (Some (current_desc)))) (PreH17 : (rest_tasks = (cons (next_task) (next_rest)))) (PreH18 : (next_link = (sched_link_of (next_task)))),
  ((&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((current_desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next_link)
  **  (wand (sepcon ((store_uchar (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((desc.(tdSchedMember) ).(tsmCurPrio) )))) ((sepcon ((store_uchar (&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((current_desc.(tdSchedMember) ).(tsmCurPrio) )))) ((store_ptr (&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) (next_link)))))) (os_inv (sg_semaphore_ic) (staged)) )
|--
  “ (addr_aligned current_task 4 ) ”
  &&  “ (node = (sched_link_of (current_task))) ”
  &&  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc))) ”
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (In task_pre (sched_owned_tasks ((os_tasks (staged)))) ) ”
  &&  “ (ktask_not_os_service task_pre staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_loop) ((cons (current_task) (rest_tasks))))) ”
  &&  “ forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) )))) ”
  &&  “ (node = (sched_link_of (current_task))) ”
  &&  “ (node <> list_pre) ”
  &&  “ (addr_aligned current_task 4 ) ”
  &&  “ ((task_desc_map ((os_tasks (staged))) (current_task)) = (Some (current_desc))) ”
  &&  “ (rest_tasks = (cons (next_task) (next_rest))) ”
  &&  “ (next_link = (sched_link_of (next_task))) ”
  &&  ((&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((current_desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next_link)
  **  (wand (sepcon ((store_uchar (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((desc.(tdSchedMember) ).(tsmCurPrio) )))) ((sepcon ((store_uchar (&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((current_desc.(tdSchedMember) ).(tsmCurPrio) )))) ((store_ptr (&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) (next_link)))))) (os_inv (sg_semaphore_ic) (staged)) )
.

Definition LinklistSuspend_partial_solve_wit_9 := LinklistSuspend_partial_solve_wit_9_pure -> LinklistSuspend_partial_solve_wit_9_aux.

Definition LinklistSuspend_partial_solve_wit_10 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (prefix_loop: (@list Z)) (other_desc: TaskDescriptorAbs) (next_task: Z) (next_rest: (@list Z)) (ret: Z) (tail: Z) (node: Z) (current_task: Z) (next_link: Z) (rest_tasks: (@list Z)) (current_desc: TaskDescriptorAbs) (retval: Z) (PreH1 : (retval = current_task)) (PreH2 : (addr_aligned retval 4 )) (PreH3 : (node = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH4 : (flag_pre = 1)) (PreH5 : (ret = 0)) (PreH6 : (tail = 0)) (PreH7 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH8 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))) (PreH9 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH10 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH11 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH12 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH13 : (ktask_not_os_service task_pre staged )) (PreH14 : (waiting_semaphore_ic = (app (prefix_loop) ((cons (current_task) (rest_tasks)))))) (PreH15 : forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) ))))) (PreH16 : (node = (sched_link_of (current_task)))) (PreH17 : (node <> list_pre)) (PreH18 : (addr_aligned current_task 4 )) (PreH19 : ((task_desc_map ((os_tasks (staged))) (current_task)) = (Some (current_desc)))) (PreH20 : (rest_tasks = (cons (next_task) (next_rest)))) (PreH21 : (next_link = (sched_link_of (next_task)))),
  ((&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((current_desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next_link)
  **  (wand (sepcon ((store_uchar (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((desc.(tdSchedMember) ).(tsmCurPrio) )))) ((sepcon ((store_uchar (&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((current_desc.(tdSchedMember) ).(tsmCurPrio) )))) ((store_ptr (&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) (next_link)))))) (os_inv (sg_semaphore_ic) (staged)) )
|--
  “ (retval = current_task) ”
  &&  “ (addr_aligned retval 4 ) ”
  &&  “ (node = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ”
  &&  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc))) ”
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (In task_pre (sched_owned_tasks ((os_tasks (staged)))) ) ”
  &&  “ (ktask_not_os_service task_pre staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_loop) ((cons (current_task) (rest_tasks))))) ”
  &&  “ forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) )))) ”
  &&  “ (node = (sched_link_of (current_task))) ”
  &&  “ (node <> list_pre) ”
  &&  “ (addr_aligned current_task 4 ) ”
  &&  “ ((task_desc_map ((os_tasks (staged))) (current_task)) = (Some (current_desc))) ”
  &&  “ (rest_tasks = (cons (next_task) (next_rest))) ”
  &&  “ (next_link = (sched_link_of (next_task))) ”
  &&  ((&((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((current_desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next_link)
  **  (wand (sepcon ((store_uchar (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((desc.(tdSchedMember) ).(tsmCurPrio) )))) ((sepcon ((store_uchar (&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((current_desc.(tdSchedMember) ).(tsmCurPrio) )))) ((store_ptr (&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) (next_link)))))) (os_inv (sg_semaphore_ic) (staged)) )
.

Definition LinklistSuspend_partial_solve_wit_11 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (desc: TaskDescriptorAbs) (prefix_loop: (@list Z)) (other_desc: TaskDescriptorAbs) (ret: Z) (tail: Z) (node: Z) (current_task: Z) (next_link: Z) (rest_tasks: (@list Z)) (current_desc: TaskDescriptorAbs) (retval: Z) (PreH1 : (retval = current_task)) (PreH2 : (addr_aligned retval 4 )) (PreH3 : (node = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH4 : (next_link = list_pre)) (PreH5 : (flag_pre = 1)) (PreH6 : (ret = 0)) (PreH7 : (tail = 0)) (PreH8 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH9 : (next_link = (semaphore_pending_head (sem_semaphore_ic)))) (PreH10 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH11 : ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc)))) (PreH12 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH13 : (In task_pre (sched_owned_tasks ((os_tasks (staged)))) )) (PreH14 : (ktask_not_os_service task_pre staged )) (PreH15 : (waiting_semaphore_ic = (app (prefix_loop) ((cons (current_task) (rest_tasks)))))) (PreH16 : forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) ))))) (PreH17 : (node = (sched_link_of (current_task)))) (PreH18 : (node <> next_link)) (PreH19 : (addr_aligned current_task 4 )) (PreH20 : ((task_desc_map ((os_tasks (staged))) (current_task)) = (Some (current_desc)))) (PreH21 : (rest_tasks = (@nil Z))),
  ((&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((current_desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next_link)
  **  (wand (sepcon ((store_uchar (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((desc.(tdSchedMember) ).(tsmCurPrio) )))) ((sepcon ((store_uchar (&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((current_desc.(tdSchedMember) ).(tsmCurPrio) )))) ((store_ptr (&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) (next_link)))))) (os_inv (sg_semaphore_ic) (staged)) )
|--
  “ (retval = current_task) ”
  &&  “ (addr_aligned retval 4 ) ”
  &&  “ (node = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ”
  &&  “ (next_link = list_pre) ”
  &&  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (next_link = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ ((task_desc_map ((os_tasks (staged))) (task_pre)) = (Some (desc))) ”
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (In task_pre (sched_owned_tasks ((os_tasks (staged)))) ) ”
  &&  “ (ktask_not_os_service task_pre staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_loop) ((cons (current_task) (rest_tasks))))) ”
  &&  “ forall (scanned: Z), ((In scanned prefix_loop ) -> exists (other_desc: TaskDescriptorAbs), (((task_desc_map ((os_tasks (staged))) (scanned)) = (Some (other_desc))) /\ (((desc.(tdSchedMember) ).(tsmCurPrio) ) <= ((other_desc.(tdSchedMember) ).(tsmCurPrio) )))) ”
  &&  “ (node = (sched_link_of (current_task))) ”
  &&  “ (node <> next_link) ”
  &&  “ (addr_aligned current_task 4 ) ”
  &&  “ ((task_desc_map ((os_tasks (staged))) (current_task)) = (Some (current_desc))) ”
  &&  “ (rest_tasks = (@nil Z)) ”
  &&  ((&((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((current_desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) # UChar  |-> ((desc.(tdSchedMember) ).(tsmCurPrio) ))
  **  ((&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next_link)
  **  (wand (sepcon ((store_uchar (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((desc.(tdSchedMember) ).(tsmCurPrio) )))) ((sepcon ((store_uchar (&((current_task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (((current_desc.(tdSchedMember) ).(tsmCurPrio) )))) ((store_ptr (&((node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) (next_link)))))) (os_inv (sg_semaphore_ic) (staged)) )
.

Definition LinklistSuspend_partial_solve_wit_12_pure :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (task_id: Z) (staged: VarGlobalState) (ignored: Z) (rest_tasks: (@list Z)) (ret: Z) (tail: Z) (node: Z) (prefix_done: (@list Z)) (suffix_done: (@list Z)) (last_tmp: Z) (new_nodes: (@list (@DL_Node Z))) (after_prio: VarGlobalState) (PreH1 : (node <> list_pre)) (PreH2 : (flag_pre = 1)) (PreH3 : (ret = 0)) (PreH4 : (tail = 0)) (PreH5 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH6 : (waiting_semaphore_ic = (app (prefix_done) (suffix_done)))) (PreH7 : (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done)))))))) (PreH8 : (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes )) (PreH9 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio )) (PreH10 : (suffix_done = (cons (last_tmp) (rest_tasks)))) (PreH11 : (node = &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH12 : (node <> list_pre)) (PreH13 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH14 : ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)))) (PreH15 : ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))))),
  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  ((( &( "ret" ) )) # Int  |-> ret)
  **  ((( &( "tmp_task" ) )) # Ptr  |-> last_tmp)
  **  ((( &( "tail" ) )) # Ptr  |-> tail)
  **  ((( &( "suspend_id" ) )) # Int  |-> task_id)
  **  ((( &( "node" ) )) # Ptr  |-> node)
  **  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
|--
  “ (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) ”
  &&  “ (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0) ”
  &&  “ (dll_insert_anchor list_pre (map (sched_link_node) ((app (prefix_done) (suffix_done)))) node ) ”
.

Definition LinklistSuspend_partial_solve_wit_12_aux :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (rest_tasks: (@list Z)) (ret: Z) (tail: Z) (node: Z) (prefix_done: (@list Z)) (suffix_done: (@list Z)) (last_tmp: Z) (new_nodes: (@list (@DL_Node Z))) (after_prio: VarGlobalState) (PreH1 : (node <> list_pre)) (PreH2 : (flag_pre = 1)) (PreH3 : (ret = 0)) (PreH4 : (tail = 0)) (PreH5 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH6 : (waiting_semaphore_ic = (app (prefix_done) (suffix_done)))) (PreH7 : (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done)))))))) (PreH8 : (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes )) (PreH9 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio )) (PreH10 : (suffix_done = (cons (last_tmp) (rest_tasks)))) (PreH11 : (node = &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH12 : (node <> list_pre)) (PreH13 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH14 : ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)))) (PreH15 : ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))))),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
|--
  “ (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) ”
  &&  “ (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0) ”
  &&  “ (dll_insert_anchor list_pre (map (sched_link_node) ((app (prefix_done) (suffix_done)))) node ) ”
  &&  “ (node <> list_pre) ”
  &&  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_done) (suffix_done))) ”
  &&  “ (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done))))))) ”
  &&  “ (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes ) ”
  &&  “ (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio ) ”
  &&  “ (suffix_done = (cons (last_tmp) (rest_tasks))) ”
  &&  “ (node = &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ”
  &&  “ (node <> list_pre) ”
  &&  “ (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0) ”
  &&  “ ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes))) ”
  &&  “ ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))) ”
  &&  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
.

Definition LinklistSuspend_partial_solve_wit_12 := LinklistSuspend_partial_solve_wit_12_pure -> LinklistSuspend_partial_solve_wit_12_aux.

Definition LinklistSuspend_partial_solve_wit_13_pure :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (task_id: Z) (staged: VarGlobalState) (ignored: Z) (rest_tasks: (@list Z)) (ret: Z) (tail: Z) (node: Z) (prefix_done: (@list Z)) (suffix_done: (@list Z)) (last_tmp: Z) (new_nodes: (@list (@DL_Node Z))) (after_prio: VarGlobalState) (PreH1 : (node <> list_pre)) (PreH2 : (flag_pre = 1)) (PreH3 : (ret = 0)) (PreH4 : (tail = 0)) (PreH5 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH6 : (waiting_semaphore_ic = (app (prefix_done) (suffix_done)))) (PreH7 : (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done)))))))) (PreH8 : (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes )) (PreH9 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio )) (PreH10 : (suffix_done = (cons (last_tmp) (rest_tasks)))) (PreH11 : (node = &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH12 : (node <> list_pre)) (PreH13 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH14 : ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)))) (PreH15 : ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))))),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  ((( &( "ret" ) )) # Int  |-> ret)
  **  ((( &( "tmp_task" ) )) # Ptr  |-> last_tmp)
  **  ((( &( "tail" ) )) # Ptr  |-> tail)
  **  ((( &( "suspend_id" ) )) # Int  |-> task_id)
  **  ((( &( "node" ) )) # Ptr  |-> node)
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
|--
  “ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes) ”
  &&  “ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) ((app (prefix_done) (suffix_done))))) (node) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done))))))) ”
.

Definition LinklistSuspend_partial_solve_wit_13_aux :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (rest_tasks: (@list Z)) (ret: Z) (tail: Z) (node: Z) (prefix_done: (@list Z)) (suffix_done: (@list Z)) (last_tmp: Z) (new_nodes: (@list (@DL_Node Z))) (after_prio: VarGlobalState) (PreH1 : (node <> list_pre)) (PreH2 : (flag_pre = 1)) (PreH3 : (ret = 0)) (PreH4 : (tail = 0)) (PreH5 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH6 : (waiting_semaphore_ic = (app (prefix_done) (suffix_done)))) (PreH7 : (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done)))))))) (PreH8 : (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes )) (PreH9 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio )) (PreH10 : (suffix_done = (cons (last_tmp) (rest_tasks)))) (PreH11 : (node = &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH12 : (node <> list_pre)) (PreH13 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH14 : ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)))) (PreH15 : ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))))),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
|--
  “ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes) ”
  &&  “ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) ((app (prefix_done) (suffix_done))))) (node) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done))))))) ”
  &&  “ (node <> list_pre) ”
  &&  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_done) (suffix_done))) ”
  &&  “ (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done))))))) ”
  &&  “ (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes ) ”
  &&  “ (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio ) ”
  &&  “ (suffix_done = (cons (last_tmp) (rest_tasks))) ”
  &&  “ (node = &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ”
  &&  “ (node <> list_pre) ”
  &&  “ (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0) ”
  &&  “ ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes))) ”
  &&  “ ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))) ”
  &&  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
.

Definition LinklistSuspend_partial_solve_wit_13 := LinklistSuspend_partial_solve_wit_13_pure -> LinklistSuspend_partial_solve_wit_13_aux.

Definition LinklistSuspend_partial_solve_wit_14_pure :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (task_id: Z) (staged: VarGlobalState) (ignored: Z) (ret: Z) (tail: Z) (node: Z) (prefix_done: (@list Z)) (suffix_done: (@list Z)) (last_tmp: Z) (new_nodes: (@list (@DL_Node Z))) (after_prio: VarGlobalState) (PreH1 : (node = list_pre)) (PreH2 : (flag_pre = 1)) (PreH3 : (ret = 0)) (PreH4 : (tail = 0)) (PreH5 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH6 : (waiting_semaphore_ic = (app (prefix_done) (suffix_done)))) (PreH7 : (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done)))))))) (PreH8 : (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes )) (PreH9 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio )) (PreH10 : (node = list_pre)) (PreH11 : (suffix_done = (@nil Z))) (PreH12 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH13 : ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)))) (PreH14 : ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))))),
  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  ((( &( "ret" ) )) # Int  |-> ret)
  **  ((( &( "tmp_task" ) )) # Ptr  |-> last_tmp)
  **  ((( &( "tail" ) )) # Ptr  |-> tail)
  **  ((( &( "suspend_id" ) )) # Int  |-> task_id)
  **  ((( &( "node" ) )) # Ptr  |-> node)
  **  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
|--
  “ (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))) ”
  &&  “ ((map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done)))))) = (map (sched_link_node) ((app ((app (prefix_done) (suffix_done))) ((cons (task_pre) (suffix_done))))))) ”
.

Definition LinklistSuspend_partial_solve_wit_14_aux :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (ret: Z) (tail: Z) (node: Z) (prefix_done: (@list Z)) (suffix_done: (@list Z)) (last_tmp: Z) (new_nodes: (@list (@DL_Node Z))) (after_prio: VarGlobalState) (PreH1 : (node = list_pre)) (PreH2 : (flag_pre = 1)) (PreH3 : (ret = 0)) (PreH4 : (tail = 0)) (PreH5 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH6 : (waiting_semaphore_ic = (app (prefix_done) (suffix_done)))) (PreH7 : (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done)))))))) (PreH8 : (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes )) (PreH9 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio )) (PreH10 : (node = list_pre)) (PreH11 : (suffix_done = (@nil Z))) (PreH12 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH13 : ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)))) (PreH14 : ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))))),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
|--
  “ (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))) ”
  &&  “ ((map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done)))))) = (map (sched_link_node) ((app ((app (prefix_done) (suffix_done))) ((cons (task_pre) (suffix_done))))))) ”
  &&  “ (node = list_pre) ”
  &&  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_done) (suffix_done))) ”
  &&  “ (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done))))))) ”
  &&  “ (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes ) ”
  &&  “ (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio ) ”
  &&  “ (node = list_pre) ”
  &&  “ (suffix_done = (@nil Z)) ”
  &&  “ (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0) ”
  &&  “ ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes))) ”
  &&  “ ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))) ”
  &&  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
.

Definition LinklistSuspend_partial_solve_wit_14 := LinklistSuspend_partial_solve_wit_14_pure -> LinklistSuspend_partial_solve_wit_14_aux.

Definition LinklistSuspend_partial_solve_wit_15 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (ret: Z) (tail: Z) (node: Z) (prefix_done: (@list Z)) (suffix_done: (@list Z)) (last_tmp: Z) (new_nodes: (@list (@DL_Node Z))) (after_prio: VarGlobalState) (last_link: Z) (PreH1 : (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) last_link )) (PreH2 : ((dll_insert_after_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (last_link) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)) (PreH3 : (node = list_pre)) (PreH4 : (flag_pre = 1)) (PreH5 : (ret = 0)) (PreH6 : (tail = 0)) (PreH7 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH8 : (waiting_semaphore_ic = (app (prefix_done) (suffix_done)))) (PreH9 : (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done)))))))) (PreH10 : (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes )) (PreH11 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio )) (PreH12 : (node = list_pre)) (PreH13 : (suffix_done = (@nil Z))) (PreH14 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH15 : ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)))) (PreH16 : ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))))),
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> last_link)
  **  (wand (store_ptr (&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) (last_link)) (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) ((map (sched_link_node) (waiting_semaphore_ic)))) )
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
|--
  “ (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) last_link ) ”
  &&  “ ((dll_insert_after_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (last_link) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes) ”
  &&  “ (node = list_pre) ”
  &&  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_done) (suffix_done))) ”
  &&  “ (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done))))))) ”
  &&  “ (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes ) ”
  &&  “ (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio ) ”
  &&  “ (node = list_pre) ”
  &&  “ (suffix_done = (@nil Z)) ”
  &&  “ (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0) ”
  &&  “ ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes))) ”
  &&  “ ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))) ”
  &&  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> last_link)
  **  (wand (store_ptr (&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) (last_link)) (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) ((map (sched_link_node) (waiting_semaphore_ic)))) )
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
.

Definition LinklistSuspend_partial_solve_wit_16_pure :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (task_id: Z) (staged: VarGlobalState) (ignored: Z) (ret: Z) (tail: Z) (node: Z) (prefix_done: (@list Z)) (suffix_done: (@list Z)) (last_tmp: Z) (new_nodes: (@list (@DL_Node Z))) (after_prio: VarGlobalState) (last_link: Z) (PreH1 : (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) last_link )) (PreH2 : ((dll_insert_after_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (last_link) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)) (PreH3 : (node = list_pre)) (PreH4 : (flag_pre = 1)) (PreH5 : (ret = 0)) (PreH6 : (tail = 0)) (PreH7 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH8 : (waiting_semaphore_ic = (app (prefix_done) (suffix_done)))) (PreH9 : (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done)))))))) (PreH10 : (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes )) (PreH11 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio )) (PreH12 : (node = list_pre)) (PreH13 : (suffix_done = (@nil Z))) (PreH14 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH15 : ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)))) (PreH16 : ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))))),
  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  ((( &( "ret" ) )) # Int  |-> ret)
  **  ((( &( "tmp_task" ) )) # Ptr  |-> last_tmp)
  **  ((( &( "tail" ) )) # Ptr  |-> last_link)
  **  ((( &( "suspend_id" ) )) # Int  |-> task_id)
  **  ((( &( "node" ) )) # Ptr  |-> node)
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
|--
  “ (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) last_link ) ”
  &&  “ (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0) ”
.

Definition LinklistSuspend_partial_solve_wit_16_aux :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (ret: Z) (tail: Z) (node: Z) (prefix_done: (@list Z)) (suffix_done: (@list Z)) (last_tmp: Z) (new_nodes: (@list (@DL_Node Z))) (after_prio: VarGlobalState) (last_link: Z) (PreH1 : (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) last_link )) (PreH2 : ((dll_insert_after_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (last_link) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)) (PreH3 : (node = list_pre)) (PreH4 : (flag_pre = 1)) (PreH5 : (ret = 0)) (PreH6 : (tail = 0)) (PreH7 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH8 : (waiting_semaphore_ic = (app (prefix_done) (suffix_done)))) (PreH9 : (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done)))))))) (PreH10 : (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes )) (PreH11 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio )) (PreH12 : (node = list_pre)) (PreH13 : (suffix_done = (@nil Z))) (PreH14 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH15 : ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)))) (PreH16 : ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))))),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
|--
  “ (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) last_link ) ”
  &&  “ (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0) ”
  &&  “ (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) last_link ) ”
  &&  “ ((dll_insert_after_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (last_link) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes) ”
  &&  “ (node = list_pre) ”
  &&  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_done) (suffix_done))) ”
  &&  “ (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done))))))) ”
  &&  “ (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes ) ”
  &&  “ (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio ) ”
  &&  “ (node = list_pre) ”
  &&  “ (suffix_done = (@nil Z)) ”
  &&  “ (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0) ”
  &&  “ ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes))) ”
  &&  “ ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))) ”
  &&  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
  **  (pure_suspend_sched_link (task_desc_map ((os_tasks (staged)))) &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") task_pre )
  **  (occupy_dll_node &((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
.

Definition LinklistSuspend_partial_solve_wit_16 := LinklistSuspend_partial_solve_wit_16_pure -> LinklistSuspend_partial_solve_wit_16_aux.

Definition LinklistSuspend_partial_solve_wit_17_pure :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (task_id: Z) (staged: VarGlobalState) (ignored: Z) (ret: Z) (tail: Z) (node: Z) (prefix_done: (@list Z)) (suffix_done: (@list Z)) (last_tmp: Z) (new_nodes: (@list (@DL_Node Z))) (after_prio: VarGlobalState) (last_link: Z) (PreH1 : (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) last_link )) (PreH2 : ((dll_insert_after_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (last_link) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)) (PreH3 : (node = list_pre)) (PreH4 : (flag_pre = 1)) (PreH5 : (ret = 0)) (PreH6 : (tail = 0)) (PreH7 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH8 : (waiting_semaphore_ic = (app (prefix_done) (suffix_done)))) (PreH9 : (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done)))))))) (PreH10 : (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes )) (PreH11 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio )) (PreH12 : (node = list_pre)) (PreH13 : (suffix_done = (@nil Z))) (PreH14 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH15 : ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)))) (PreH16 : ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))))),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (dll_insert_after_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (last_link) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) )
  **  ((( &( "task" ) )) # Ptr  |-> task_pre)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "flag" ) )) # UChar  |-> flag_pre)
  **  ((( &( "ret" ) )) # Int  |-> ret)
  **  ((( &( "tmp_task" ) )) # Ptr  |-> last_tmp)
  **  ((( &( "tail" ) )) # Ptr  |-> last_link)
  **  ((( &( "suspend_id" ) )) # Int  |-> task_id)
  **  ((( &( "node" ) )) # Ptr  |-> node)
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
|--
  “ ((dll_insert_after_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (last_link) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes) ”
.

Definition LinklistSuspend_partial_solve_wit_17_aux :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (flag_pre: Z) (staged: VarGlobalState) (ignored: Z) (ret: Z) (tail: Z) (node: Z) (prefix_done: (@list Z)) (suffix_done: (@list Z)) (last_tmp: Z) (new_nodes: (@list (@DL_Node Z))) (after_prio: VarGlobalState) (last_link: Z) (PreH1 : (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) last_link )) (PreH2 : ((dll_insert_after_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (last_link) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)) (PreH3 : (node = list_pre)) (PreH4 : (flag_pre = 1)) (PreH5 : (ret = 0)) (PreH6 : (tail = 0)) (PreH7 : (ktask_suspend_step task_pre before_semaphore_ic ignored staged )) (PreH8 : (waiting_semaphore_ic = (app (prefix_done) (suffix_done)))) (PreH9 : (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done)))))))) (PreH10 : (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes )) (PreH11 : (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio )) (PreH12 : (node = list_pre)) (PreH13 : (suffix_done = (@nil Z))) (PreH14 : (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0)) (PreH15 : ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)))) (PreH16 : ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z)))))))))),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (dll_insert_after_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (last_link) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
|--
  “ ((dll_insert_after_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (last_link) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes) ”
  &&  “ (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) last_link ) ”
  &&  “ ((dll_insert_after_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (last_link) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes) ”
  &&  “ (node = list_pre) ”
  &&  “ (flag_pre = 1) ”
  &&  “ (ret = 0) ”
  &&  “ (tail = 0) ”
  &&  “ (ktask_suspend_step task_pre before_semaphore_ic ignored staged ) ”
  &&  “ (waiting_semaphore_ic = (app (prefix_done) (suffix_done))) ”
  &&  “ (new_nodes = (map (sched_link_node) ((app (prefix_done) ((cons (task_pre) (suffix_done))))))) ”
  &&  “ (linklist_priority_insert (task_desc_map ((os_tasks (staged)))) task_pre (map (sched_link_node) (waiting_semaphore_ic)) new_nodes ) ”
  &&  “ (linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after_prio ) ”
  &&  “ (node = list_pre) ”
  &&  “ (suffix_done = (@nil Z)) ”
  &&  “ (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") <> 0) ”
  &&  “ ((node <> list_pre) -> ((dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) &((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link") ) /\ ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes))) ”
  &&  “ ((node = list_pre) -> (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))) ”
  &&  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (dll_insert_after_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (last_link) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
.

Definition LinklistSuspend_partial_solve_wit_17 := LinklistSuspend_partial_solve_wit_17_pure -> LinklistSuspend_partial_solve_wit_17_aux.

Definition LinklistSuspend_which_implies_wit_1 :=
(
forall (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (task_pre: Z) (task_id: Z),
  ((&((task_pre)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (wand (store_ushort (&((task_pre)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (task_id)) (os_inv (sg_semaphore_ic) (before_semaphore_ic)) )
|--
  (os_inv sg_semaphore_ic before_semaphore_ic )
) \/
(
forall (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (task_pre: Z) (task_id: Z),
  ((&((task_pre)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (wand (store_ushort (&((task_pre)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (task_id)) (os_inv (sg_semaphore_ic) (before_semaphore_ic)) )
|--
  (os_inv sg_semaphore_ic before_semaphore_ic )
).

Definition LinklistSuspend_which_implies_wit_1_split_goal_spatial :=
forall (before_semaphore_ic: VarGlobalState) (sg_semaphore_ic: StableGlobalState) (task_pre: Z) (task_id: Z),
  ((&((task_pre)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (wand (store_ushort (&((task_pre)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (task_id)) (os_inv (sg_semaphore_ic) (before_semaphore_ic)) )
|--
  (os_inv sg_semaphore_ic before_semaphore_ic )
.

Definition LinklistSuspend_which_implies_wit_2 :=
(
forall (waiting_semaphore_ic: (@list Z)) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (staged: VarGlobalState) (after_fifo: VarGlobalState) (PreH1 : ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (list_pre) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (list_pre) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) ((map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))) (os_inv (sg_semaphore_ic) (after_fifo)) )
|--
  (os_inv sg_semaphore_ic after_fifo )
) \/
(
forall (waiting_semaphore_ic: (@list Z)) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (staged: VarGlobalState) (after_fifo: VarGlobalState) (PreH1 : ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (list_pre) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (list_pre) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) ((map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))) (os_inv (sg_semaphore_ic) (after_fifo)) )
|--
  (os_inv sg_semaphore_ic after_fifo )
).

Definition LinklistSuspend_which_implies_wit_2_split_goal_spatial :=
forall (waiting_semaphore_ic: (@list Z)) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (staged: VarGlobalState) (after_fifo: VarGlobalState) (PreH1 : ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (list_pre) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (list_pre) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) ((map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))) (os_inv (sg_semaphore_ic) (after_fifo)) )
|--
  (os_inv sg_semaphore_ic after_fifo )
.

Definition LinklistSuspend_which_implies_wit_3 :=
forall (waiting_semaphore_ic: (@list Z)) (sem_semaphore_ic: Z) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (staged: VarGlobalState) (PreH1 : (semaphore_pending_nodes sem_semaphore_ic staged (map (sched_link_node) (waiting_semaphore_ic)) )) (PreH2 : (list_pre = (semaphore_pending_head (sem_semaphore_ic)))),
  (os_inv sg_semaphore_ic staged )
|--
  (EX (first_link: Z),
  “ (waiting_semaphore_ic = (@nil Z)) ”
  &&  “ (first_link = list_pre) ”
  &&  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> first_link)
  **  (wand (store_ptr (&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) (first_link)) (os_inv (sg_semaphore_ic) (staged)) ))
  ||
  (EX (first_link: Z) (first_task: Z) (rest_tasks: (@list Z)),
  “ (waiting_semaphore_ic = (cons (first_task) (rest_tasks))) ”
  &&  “ (first_link = (sched_link_of (first_task))) ”
  &&  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> first_link)
  **  (wand (store_ptr (&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) (first_link)) (os_inv (sg_semaphore_ic) (staged)) ))
.

Definition LinklistSuspend_which_implies_wit_4 :=
(
forall (waiting_semaphore_ic: (@list Z)) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (staged: VarGlobalState) (last_tmp: Z) (new_nodes: (@list (@DL_Node Z))) (after_prio: VarGlobalState) (PreH1 : ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
|--
  (os_inv sg_semaphore_ic after_prio )
) \/
(
forall (waiting_semaphore_ic: (@list Z)) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (staged: VarGlobalState) (last_tmp: Z) (new_nodes: (@list (@DL_Node Z))) (after_prio: VarGlobalState) (PreH1 : ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
|--
  (os_inv sg_semaphore_ic after_prio )
).

Definition LinklistSuspend_which_implies_wit_4_split_goal_spatial :=
forall (waiting_semaphore_ic: (@list Z)) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (staged: VarGlobalState) (last_tmp: Z) (new_nodes: (@list (@DL_Node Z))) (after_prio: VarGlobalState) (PreH1 : ((dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (dll_insert_before_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (&((last_tmp)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
|--
  (os_inv sg_semaphore_ic after_prio )
.

Definition LinklistSuspend_which_implies_wit_5 :=
(
forall (waiting_semaphore_ic: (@list Z)) (list_pre: Z) (task_pre: Z) (staged: VarGlobalState) (new_nodes: (@list (@DL_Node Z))) (PreH1 : (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
|--
  EX (last_link: Z),
  “ (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) last_link ) ”
  &&  “ ((dll_insert_after_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (last_link) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes) ”
  &&  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> last_link)
  **  (wand (store_ptr (&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) (last_link)) (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) ((map (sched_link_node) (waiting_semaphore_ic)))) )
) \/
(
forall (waiting_semaphore_ic: (@list Z)) (list_pre: Z) (task_pre: Z) (staged: VarGlobalState) (new_nodes: (@list (@DL_Node Z))) (PreH1 : (new_nodes = (map (sched_link_node) ((app (waiting_semaphore_ic) ((cons (task_pre) ((@nil Z))))))))),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
|--
  EX (last_link: Z),
  “ (dll_insert_anchor list_pre (map (sched_link_node) (waiting_semaphore_ic)) last_link ) ”
  &&  “ ((dll_insert_after_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (last_link) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes) ”
  &&  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> last_link)
  **  (wand (store_ptr (&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) (last_link)) (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) ((map (sched_link_node) (waiting_semaphore_ic)))) )
).

Definition LinklistSuspend_which_implies_wit_6 :=
(
forall (waiting_semaphore_ic: (@list Z)) (list_pre: Z) (staged: VarGlobalState) (last_link: Z),
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> last_link)
  **  (wand (store_ptr (&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) (last_link)) (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) ((map (sched_link_node) (waiting_semaphore_ic)))) )
|--
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
) \/
(
forall (waiting_semaphore_ic: (@list Z)) (list_pre: Z) (staged: VarGlobalState) (last_link: Z),
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> last_link)
  **  (wand (store_ptr (&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) (last_link)) (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) ((map (sched_link_node) (waiting_semaphore_ic)))) )
|--
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
).

Definition LinklistSuspend_which_implies_wit_6_split_goal_spatial :=
forall (waiting_semaphore_ic: (@list Z)) (list_pre: Z) (staged: VarGlobalState) (last_link: Z),
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> last_link)
  **  (wand (store_ptr (&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) (last_link)) (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) ((map (sched_link_node) (waiting_semaphore_ic)))) )
|--
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (map (sched_link_node) (waiting_semaphore_ic)) )
.

Definition LinklistSuspend_which_implies_wit_7 :=
(
forall (waiting_semaphore_ic: (@list Z)) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (staged: VarGlobalState) (new_nodes: (@list (@DL_Node Z))) (after_prio: VarGlobalState) (last_link: Z) (PreH1 : ((dll_insert_after_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (last_link) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (dll_insert_after_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (last_link) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
|--
  (os_inv sg_semaphore_ic after_prio )
) \/
(
forall (waiting_semaphore_ic: (@list Z)) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (staged: VarGlobalState) (new_nodes: (@list (@DL_Node Z))) (after_prio: VarGlobalState) (last_link: Z) (PreH1 : ((dll_insert_after_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (last_link) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (dll_insert_after_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (last_link) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
|--
  (os_inv sg_semaphore_ic after_prio )
).

Definition LinklistSuspend_which_implies_wit_7_split_goal_spatial :=
forall (waiting_semaphore_ic: (@list Z)) (sg_semaphore_ic: StableGlobalState) (list_pre: Z) (task_pre: Z) (staged: VarGlobalState) (new_nodes: (@list (@DL_Node Z))) (after_prio: VarGlobalState) (last_link: Z) (PreH1 : ((dll_insert_after_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (last_link) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) = new_nodes)),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (staged)))))) list_pre (dll_insert_after_dispatch (list_pre) ((map (sched_link_node) (waiting_semaphore_ic))) (last_link) ((Build_DL_Node (task_pre) (&((task_pre)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (staged))))))) (list_pre) (new_nodes)) (os_inv (sg_semaphore_ic) (after_prio)) )
|--
  (os_inv sg_semaphore_ic after_prio )
.

(* Shallow FunAssertion specs for LinklistSuspend. *)
Definition LinklistSuspend_sig : FuncSig := ([ * struct "SysDoubleLinklistNode";  * struct "TaskDescriptor"; u8], i32)%ctype.

Definition LinklistSuspend_semaphore_ic : Spec LinklistSuspend_sig :=
  fun F =>
ALL (sg: StableGlobalState),
ALL (before: VarGlobalState),
ALL (sem: Z),
ALL (waiting: (@list Z)),
HoareFun ([ * struct "SysDoubleLinklistNode";  * struct "TaskDescriptor"; u8], i32)%ctype
  (fun '(list_pre, (task_pre, flag_pre)) =>
  (“ (list_pre = (semaphore_pending_head (sem))) ”
  &&  “ (semaphore_pending_nodes sem before (map (sched_link_node) (waiting)) ) ”
  &&  “ (linklist_suspend_admissible task_pre flag_pre before ) ”
  &&  (os_inv sg before )))
  (fun '(list_pre, (task_pre, flag_pre)) retval =>
  (EX (after: VarGlobalState),
  “ (linklist_suspend_step sem task_pre flag_pre before retval after ) ”
  &&  (os_inv sg after )))
  F.

Definition LinklistSuspend_semaphore_prio_ic : Spec LinklistSuspend_sig :=
  fun F =>
ALL (sg: StableGlobalState),
ALL (before: VarGlobalState),
ALL (sem: Z),
ALL (waiting: (@list Z)),
HoareFun ([ * struct "SysDoubleLinklistNode";  * struct "TaskDescriptor"; u8], i32)%ctype
  (fun '(list_pre, (task_pre, flag_pre)) =>
  (“ (list_pre = (semaphore_pending_head (sem))) ”
  &&  “ (flag_pre = 1) ”
  &&  “ (semaphore_pending_nodes sem before (map (sched_link_node) (waiting)) ) ”
  &&  “ (linklist_suspend_admissible task_pre flag_pre before ) ”
  &&  (os_inv sg before )))
  (fun '(list_pre, (task_pre, flag_pre)) retval =>
  (EX (after: VarGlobalState),
  “ (retval = 0) ”
  &&  “ (linklist_suspend_prio sem task_pre before after ) ”
  &&  (os_inv sg after )))
  F.

Definition LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic :=
forall (list_pre: Z) (task_pre: Z) (flag_pre: Z) (sg_semaphore_prio_ic: StableGlobalState) (before_semaphore_prio_ic: VarGlobalState) (sem_semaphore_prio_ic: Z) (waiting_semaphore_prio_ic: (@list Z)),
  (“ (list_pre = (semaphore_pending_head (sem_semaphore_prio_ic))) ”
  &&  “ (flag_pre = 1) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_prio_ic before_semaphore_prio_ic (map (sched_link_node) (waiting_semaphore_prio_ic)) ) ”
  &&  “ (linklist_suspend_admissible task_pre flag_pre before_semaphore_prio_ic ) ”
  &&  (os_inv sg_semaphore_prio_ic before_semaphore_prio_ic ))
|--
EX (sg_semaphore_ic: StableGlobalState)(before_semaphore_ic: VarGlobalState)(sem_semaphore_ic: Z)(waiting_semaphore_ic: (@list Z)),
  (“ (list_pre = (semaphore_pending_head (sem_semaphore_ic))) ”
  &&  “ (semaphore_pending_nodes sem_semaphore_ic before_semaphore_ic (map (sched_link_node) (waiting_semaphore_ic)) ) ”
  &&  “ (linklist_suspend_admissible task_pre flag_pre before_semaphore_ic ) ”
  &&  (os_inv sg_semaphore_ic before_semaphore_ic ))
  **
  (ALL (retval: Z),
  (EX (after_2: VarGlobalState),
  “ (linklist_suspend_step sem_semaphore_ic task_pre flag_pre before_semaphore_ic retval after_2 ) ”
  &&  (os_inv sg_semaphore_ic after_2 ))
  -*
  (EX (after: VarGlobalState),
  “ (retval = 0) ”
  &&  “ (linklist_suspend_prio sem_semaphore_prio_ic task_pre before_semaphore_prio_ic after ) ”
  &&  (os_inv sg_semaphore_prio_ic after )))
.

Module Type VC_Correct.


Axiom proof_of_LinklistSuspend_safety_wit_1 : LinklistSuspend_safety_wit_1.
Axiom proof_of_LinklistSuspend_safety_wit_2 : LinklistSuspend_safety_wit_2.
Axiom proof_of_LinklistSuspend_safety_wit_3 : LinklistSuspend_safety_wit_3.
Axiom proof_of_LinklistSuspend_safety_wit_4 : LinklistSuspend_safety_wit_4.
Axiom proof_of_LinklistSuspend_safety_wit_5 : LinklistSuspend_safety_wit_5.
Axiom proof_of_LinklistSuspend_safety_wit_6 : LinklistSuspend_safety_wit_6.
Axiom proof_of_LinklistSuspend_safety_wit_7 : LinklistSuspend_safety_wit_7.
Axiom proof_of_LinklistSuspend_safety_wit_8 : LinklistSuspend_safety_wit_8.
Axiom proof_of_LinklistSuspend_safety_wit_9 : LinklistSuspend_safety_wit_9.
Axiom proof_of_LinklistSuspend_safety_wit_10 : LinklistSuspend_safety_wit_10.
Axiom proof_of_LinklistSuspend_safety_wit_11 : LinklistSuspend_safety_wit_11.
Axiom proof_of_LinklistSuspend_safety_wit_12 : LinklistSuspend_safety_wit_12.
Axiom proof_of_LinklistSuspend_safety_wit_13 : LinklistSuspend_safety_wit_13.
Axiom proof_of_LinklistSuspend_safety_wit_14 : LinklistSuspend_safety_wit_14.
Axiom proof_of_LinklistSuspend_safety_wit_15 : LinklistSuspend_safety_wit_15.
Axiom proof_of_LinklistSuspend_safety_wit_16 : LinklistSuspend_safety_wit_16.
Axiom proof_of_LinklistSuspend_safety_wit_17 : LinklistSuspend_safety_wit_17.
Axiom proof_of_LinklistSuspend_entail_wit_1_1 : LinklistSuspend_entail_wit_1_1.
Axiom proof_of_LinklistSuspend_entail_wit_1_2 : LinklistSuspend_entail_wit_1_2.
Axiom proof_of_LinklistSuspend_entail_wit_2_1 : LinklistSuspend_entail_wit_2_1.
Axiom proof_of_LinklistSuspend_entail_wit_2_2 : LinklistSuspend_entail_wit_2_2.
Axiom proof_of_LinklistSuspend_entail_wit_3 : LinklistSuspend_entail_wit_3.
Axiom proof_of_LinklistSuspend_entail_wit_4_1 : LinklistSuspend_entail_wit_4_1.
Axiom proof_of_LinklistSuspend_entail_wit_4_2 : LinklistSuspend_entail_wit_4_2.
Axiom proof_of_LinklistSuspend_entail_wit_5 : LinklistSuspend_entail_wit_5.
Axiom proof_of_LinklistSuspend_entail_wit_6_1 : LinklistSuspend_entail_wit_6_1.
Axiom proof_of_LinklistSuspend_entail_wit_6_2 : LinklistSuspend_entail_wit_6_2.
Axiom proof_of_LinklistSuspend_entail_wit_7_1 : LinklistSuspend_entail_wit_7_1.
Axiom proof_of_LinklistSuspend_entail_wit_7_2 : LinklistSuspend_entail_wit_7_2.
Axiom proof_of_LinklistSuspend_entail_wit_7_3 : LinklistSuspend_entail_wit_7_3.
Axiom proof_of_LinklistSuspend_entail_wit_7_4 : LinklistSuspend_entail_wit_7_4.
Axiom proof_of_LinklistSuspend_return_wit_1 : LinklistSuspend_return_wit_1.
Axiom proof_of_LinklistSuspend_return_wit_2 : LinklistSuspend_return_wit_2.
Axiom proof_of_LinklistSuspend_return_wit_3 : LinklistSuspend_return_wit_3.
Axiom proof_of_LinklistSuspend_return_wit_4 : LinklistSuspend_return_wit_4.
Axiom proof_of_LinklistSuspend_partial_solve_wit_1 : LinklistSuspend_partial_solve_wit_1.
Axiom proof_of_LinklistSuspend_partial_solve_wit_2 : LinklistSuspend_partial_solve_wit_2.
Axiom proof_of_LinklistSuspend_partial_solve_wit_3_pure : LinklistSuspend_partial_solve_wit_3_pure.
Axiom proof_of_LinklistSuspend_partial_solve_wit_3 : LinklistSuspend_partial_solve_wit_3.
Axiom proof_of_LinklistSuspend_partial_solve_wit_4_pure : LinklistSuspend_partial_solve_wit_4_pure.
Axiom proof_of_LinklistSuspend_partial_solve_wit_4 : LinklistSuspend_partial_solve_wit_4.
Axiom proof_of_LinklistSuspend_partial_solve_wit_5_pure : LinklistSuspend_partial_solve_wit_5_pure.
Axiom proof_of_LinklistSuspend_partial_solve_wit_5 : LinklistSuspend_partial_solve_wit_5.
Axiom proof_of_LinklistSuspend_partial_solve_wit_6_pure : LinklistSuspend_partial_solve_wit_6_pure.
Axiom proof_of_LinklistSuspend_partial_solve_wit_6 : LinklistSuspend_partial_solve_wit_6.
Axiom proof_of_LinklistSuspend_partial_solve_wit_7_pure : LinklistSuspend_partial_solve_wit_7_pure.
Axiom proof_of_LinklistSuspend_partial_solve_wit_7 : LinklistSuspend_partial_solve_wit_7.
Axiom proof_of_LinklistSuspend_partial_solve_wit_8_pure : LinklistSuspend_partial_solve_wit_8_pure.
Axiom proof_of_LinklistSuspend_partial_solve_wit_8 : LinklistSuspend_partial_solve_wit_8.
Axiom proof_of_LinklistSuspend_partial_solve_wit_9_pure : LinklistSuspend_partial_solve_wit_9_pure.
Axiom proof_of_LinklistSuspend_partial_solve_wit_9 : LinklistSuspend_partial_solve_wit_9.
Axiom proof_of_LinklistSuspend_partial_solve_wit_10 : LinklistSuspend_partial_solve_wit_10.
Axiom proof_of_LinklistSuspend_partial_solve_wit_11 : LinklistSuspend_partial_solve_wit_11.
Axiom proof_of_LinklistSuspend_partial_solve_wit_12_pure : LinklistSuspend_partial_solve_wit_12_pure.
Axiom proof_of_LinklistSuspend_partial_solve_wit_12 : LinklistSuspend_partial_solve_wit_12.
Axiom proof_of_LinklistSuspend_partial_solve_wit_13_pure : LinklistSuspend_partial_solve_wit_13_pure.
Axiom proof_of_LinklistSuspend_partial_solve_wit_13 : LinklistSuspend_partial_solve_wit_13.
Axiom proof_of_LinklistSuspend_partial_solve_wit_14_pure : LinklistSuspend_partial_solve_wit_14_pure.
Axiom proof_of_LinklistSuspend_partial_solve_wit_14 : LinklistSuspend_partial_solve_wit_14.
Axiom proof_of_LinklistSuspend_partial_solve_wit_15 : LinklistSuspend_partial_solve_wit_15.
Axiom proof_of_LinklistSuspend_partial_solve_wit_16_pure : LinklistSuspend_partial_solve_wit_16_pure.
Axiom proof_of_LinklistSuspend_partial_solve_wit_16 : LinklistSuspend_partial_solve_wit_16.
Axiom proof_of_LinklistSuspend_partial_solve_wit_17_pure : LinklistSuspend_partial_solve_wit_17_pure.
Axiom proof_of_LinklistSuspend_partial_solve_wit_17 : LinklistSuspend_partial_solve_wit_17.
Axiom proof_of_LinklistSuspend_which_implies_wit_1 : LinklistSuspend_which_implies_wit_1.
Axiom proof_of_LinklistSuspend_which_implies_wit_2 : LinklistSuspend_which_implies_wit_2.
Axiom proof_of_LinklistSuspend_which_implies_wit_3 : LinklistSuspend_which_implies_wit_3.
Axiom proof_of_LinklistSuspend_which_implies_wit_4 : LinklistSuspend_which_implies_wit_4.
Axiom proof_of_LinklistSuspend_which_implies_wit_5 : LinklistSuspend_which_implies_wit_5.
Axiom proof_of_LinklistSuspend_which_implies_wit_6 : LinklistSuspend_which_implies_wit_6.
Axiom proof_of_LinklistSuspend_which_implies_wit_7 : LinklistSuspend_which_implies_wit_7.
Axiom proof_of_LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic : LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic.

End VC_Correct.
