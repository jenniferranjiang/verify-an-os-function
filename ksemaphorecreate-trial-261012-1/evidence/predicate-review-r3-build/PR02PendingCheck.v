Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.micromega.Lia Coq.Strings.String.
From SimpleC.SL Require Import CNotation.
Require Import CRTOS_Verify.sem.SemaphorePure CRTOS_Verify.sem.CrtosOSPure.
Require Import CRTOS_Verify.lib.CrtosGlobState CRTOS_Verify.lib.idnode_abs CRTOS_Verify.lib.KTaskPure.
Import ListNotations.
Local Open Scope Z_scope.
Local Open Scope string_scope.

(** 合法非空pending样例；running指针仍指向刚挂起、尚未完成调度的当前任务。
    构造同时给出真实task registry和嵌入ID节点身份，没有禁止所有pending来修复PR02。 *)
Definition pending_example (desc : TaskDescriptorAbs) : CrtosOSState :=
 Build_CrtosOSState
   (Build_VarGlobalState (fun _ => VTS_NORMAL)
     (Build_VarIdmanager [0]
       ([Build_IdNodeAbs 0 (&(1000 # "TaskDescriptor" ->ₛ "id"))] :: repeat [] 15)) [1000]
     (fun p => if Z.eq_dec p 1000 then Some desc else None))
   (Build_SchedulerState 0 1000 0 (repeat [] 32) 0 0)
   [Build_SemaphoreObject 2000 0 0 [1000]].

Lemma pending_example_world : forall desc,
  task_world_wf (os_tasks (pending_example desc)).
Proof.
  intros desc. unfold task_world_wf, pending_example, task_id_nodes; cbn.
  split.
  - intros task [<-|H]; [exists desc; reflexivity|contradiction].
  - split.
    + intros task Hnot. destruct (Z.eq_dec task 1000) as [->|Hneq].
      * exfalso. apply Hnot. left; reflexivity.
      * reflexivity.
    + reflexivity.
Qed.

Lemma nonempty_suspended_pending_valid : forall desc,
  Z.land desc.(tdSchedMember).(tsmStat) TASK_STAT_MASK = TASK_SUSPEND ->
  CrtosOSValid (pending_example desc).
Proof.
  intros desc Hsuspend. unfold CrtosOSValid.
  split.
  - unfold pending_example, semaphore_valid; cbn.
    repeat split; repeat constructor; simpl; intuition lia.
  - split; [apply pending_example_world|].
    cbn [pending_example os_scheduler scheduler_lock_nest scheduler_ready os_semaphores
      os_tasks task_desc_map scheduler_running].
    split; [lia|]. split; [reflexivity|]. split; [repeat constructor|].
    split.
    + intros t [<-|H]; [|contradiction].
      split; [simpl; tauto|]. exists desc; split; [reflexivity|exact Hsuspend].
    + split.
      * intros priority t Hin. rewrite nth_repeat in Hin. contradiction.
      * split.
        -- intros _. exists desc; reflexivity.
        -- intros t actual Hmap Hrunning.
           destruct (Z.eq_dec t 1000) as [->|Hneq].
           ++ reflexivity.
           ++ discriminate.
Qed.

Lemma nonsuspended_pending_rejected : forall desc,
  Z.land desc.(tdSchedMember).(tsmStat) TASK_STAT_MASK <> TASK_SUSPEND ->
  ~ CrtosOSValid (pending_example desc).
Proof.
  intros desc Hbad Hvalid. apply Hbad.
  eapply CrtosOSValid_pending_suspended; [exact Hvalid| |].
  - cbn. left; reflexivity.
  - cbn. reflexivity.
Qed.

(** Wakeup/timeout移走pending节点后，READY状态与ready队列0相配。
    exstatus不受本validity限制，因而0、-ERROR、-ETIMEOUT均可保留真实结果。
    本例只检查合法稳定端点，不冒充Wakeup/timeout函数体证明。 *)
Definition awakened_example (desc : TaskDescriptorAbs) : CrtosOSState :=
 Build_CrtosOSState (os_tasks (pending_example desc))
   (Build_SchedulerState 0 1000 0 ([1000] :: repeat [] 31) 1 0)
   [Build_SemaphoreObject 2000 0 0 []].

Lemma awakened_ready_endpoint_valid : forall desc,
  Z.land desc.(tdSchedMember).(tsmStat) TASK_STAT_MASK = TASK_READY ->
  desc.(tdSchedMember).(tsmCurPrio) = 0 ->
  CrtosOSValid (awakened_example desc).
Proof.
  intros desc Hready Hprio. unfold CrtosOSValid.
  split.
  - unfold awakened_example, semaphore_valid; cbn.
    repeat split; repeat constructor; simpl; intuition lia.
  - split; [apply pending_example_world|].
    cbn [awakened_example pending_example os_scheduler scheduler_lock_nest scheduler_ready
      os_semaphores os_tasks task_desc_map scheduler_running].
    split; [lia|]. split; [reflexivity|].
    split; [repeat constructor; simpl; tauto|].
    split.
    + intros t H. contradiction.
    + split.
      * intros [|priority] t Hin.
        -- simpl in Hin. destruct Hin as [<-|H]; [|contradiction].
           exists desc; repeat split; auto.
        -- change (In t (List.nth priority (repeat [] 31) [])) in Hin.
           rewrite nth_repeat in Hin. contradiction.
      * split.
        -- intros _. exists desc; reflexivity.
        -- intros t actual Hmap Hrunning.
           destruct (Z.eq_dec t 1000) as [->|Hneq].
           ++ reflexivity.
           ++ discriminate.
Qed.
