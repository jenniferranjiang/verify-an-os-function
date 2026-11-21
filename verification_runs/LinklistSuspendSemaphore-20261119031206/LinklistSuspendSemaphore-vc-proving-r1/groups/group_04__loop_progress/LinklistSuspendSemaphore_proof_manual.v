From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.pendlist Require Import LinklistSuspendSemaphore_goal.
From CRTOS_Verify.VC.pendlist Require Import LinklistSuspendSemaphore_proof_auto.
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

Lemma proof_of_LinklistSuspend_entail_wit_1_1 : LinklistSuspend_entail_wit_1_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_1_2 : LinklistSuspend_entail_wit_1_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_2_1 : LinklistSuspend_entail_wit_2_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_2_2 : LinklistSuspend_entail_wit_2_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_3 : LinklistSuspend_entail_wit_3.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_4_1 : LinklistSuspend_entail_wit_4_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Left. Exists (@nil Z) waiting_semaphore_ic.
  split_pure_spatial.
  - sep_apply_r_atomic (derivable1_wand_elim1
      (store_ptr (&((list_pre) # "SysDoubleLinklistNode" ->ₛ "node_next")) first_link)
      (os_inv sg_semaphore_ic staged)).
    cancel.
  - split_pures; dump_pre_spatial; simpl; auto.
    intros scanned Hfalse. contradiction.
Qed.

Lemma proof_of_LinklistSuspend_entail_wit_4_2 : LinklistSuspend_entail_wit_4_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Right. Exists first_task_2 rest_tasks_2 (@nil Z) waiting_semaphore_ic.
  split_pure_spatial.
  - sep_apply_r_atomic (derivable1_wand_elim1
      (store_ptr (&((list_pre) # "SysDoubleLinklistNode" ->ₛ "node_next")) first_link)
      (os_inv sg_semaphore_ic staged)).
    cancel.
  - split_pures; dump_pre_spatial; simpl; auto.
    intros scanned Hfalse. contradiction.
Qed.

Lemma proof_of_LinklistSuspend_entail_wit_5 : LinklistSuspend_entail_wit_5.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_6_1 : LinklistSuspend_entail_wit_6_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst retval.
  assert (Hprefix : forall scanned, In scanned (prefix_loop_2 ++ [current_task]) ->
    exists d, task_desc_map (os_tasks staged) scanned = Some d /\
      tsmCurPrio (tdSchedMember desc) <= tsmCurPrio (tdSchedMember d)).
  { intros scanned Hin. apply in_app_iff in Hin. destruct Hin as [Hin | Hin].
    - exact (PreH16 scanned Hin).
    - simpl in Hin. destruct Hin as [<- | []]. exists current_desc. auto. }
  Right. Exists next_task next_rest (prefix_loop_2 ++ [current_task]) rest_tasks_2.
  split_pure_spatial.
  - sep_apply_r_atomic (derivable1_wand_elim1
      (store_uchar (&((task_pre) # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (tsmCurPrio (tdSchedMember desc)) **
       (store_uchar (&((current_task) # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (tsmCurPrio (tdSchedMember current_desc)) **
        store_ptr (&((node) # "SysDoubleLinklistNode" ->ₛ "node_next")) next_link))
      (os_inv sg_semaphore_ic staged)).
    repeat progress cancel.
  - split_pures; dump_pre_spatial; auto.
    rewrite <- app_assoc. simpl. exact PreH15.
Qed.

Lemma proof_of_LinklistSuspend_entail_wit_6_2 : LinklistSuspend_entail_wit_6_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst retval. subst next_link.
  assert (Hprefix : forall scanned, In scanned (prefix_loop_2 ++ [current_task]) ->
    exists d, task_desc_map (os_tasks staged) scanned = Some d /\
      tsmCurPrio (tdSchedMember desc) <= tsmCurPrio (tdSchedMember d)).
  { intros scanned Hin. apply in_app_iff in Hin. destruct Hin as [Hin | Hin].
    - exact (PreH17 scanned Hin).
    - simpl in Hin. destruct Hin as [<- | []]. exists current_desc. auto. }
  Left. Exists (prefix_loop_2 ++ [current_task]) rest_tasks_2.
  split_pure_spatial.
  - sep_apply_r_atomic (derivable1_wand_elim1
      (store_uchar (&((task_pre) # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (tsmCurPrio (tdSchedMember desc)) **
       (store_uchar (&((current_task) # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (tsmCurPrio (tdSchedMember current_desc)) **
        store_ptr (&((node) # "SysDoubleLinklistNode" ->ₛ "node_next")) list_pre))
      (os_inv sg_semaphore_ic staged)).
    repeat progress cancel.
  - split_pures; dump_pre_spatial; auto.
    rewrite <- app_assoc. simpl. exact PreH16.
Qed.

Lemma proof_of_LinklistSuspend_entail_wit_7_1 : LinklistSuspend_entail_wit_7_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_7_2 : LinklistSuspend_entail_wit_7_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_7_3 : LinklistSuspend_entail_wit_7_3.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_7_4 : LinklistSuspend_entail_wit_7_4.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_return_wit_1_split_goal_1 : LinklistSuspend_return_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistSuspend_return_wit_1 : LinklistSuspend_return_wit_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_return_wit_2_split_goal_1 : LinklistSuspend_return_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistSuspend_return_wit_2 : LinklistSuspend_return_wit_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_return_wit_3_split_goal_1 : LinklistSuspend_return_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistSuspend_return_wit_3 : LinklistSuspend_return_wit_3.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_return_wit_4_split_goal_1 : LinklistSuspend_return_wit_4_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistSuspend_return_wit_4 : LinklistSuspend_return_wit_4.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_1_split_goal_spatial : LinklistSuspend_which_implies_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistSuspend_which_implies_wit_1 : LinklistSuspend_which_implies_wit_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_2_split_goal_spatial : LinklistSuspend_which_implies_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistSuspend_which_implies_wit_2 : LinklistSuspend_which_implies_wit_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_3 : LinklistSuspend_which_implies_wit_3.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_4_split_goal_spatial : LinklistSuspend_which_implies_wit_4_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistSuspend_which_implies_wit_4 : LinklistSuspend_which_implies_wit_4.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_5 : LinklistSuspend_which_implies_wit_5.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_6_split_goal_spatial : LinklistSuspend_which_implies_wit_6_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistSuspend_which_implies_wit_6 : LinklistSuspend_which_implies_wit_6.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_7_split_goal_spatial : LinklistSuspend_which_implies_wit_7_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistSuspend_which_implies_wit_7 : LinklistSuspend_which_implies_wit_7.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic : LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic.
Proof. Admitted.

