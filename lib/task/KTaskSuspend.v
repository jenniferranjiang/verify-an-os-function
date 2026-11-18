Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem CNotation.
Require Export CRTOS_Verify.lib.task.KTaskWakeup.
Require Import CRTOS_Verify.lib.assign.Bitmap.
From AUXLib Require Import ListLib.
Import ListNotations.
Local Open Scope Z_scope.

(** 移植 VRTOS SuspendKTask 契约使用的纯效果；仅保留必要定义，未导入其函数证明。当前工程无 msgqueue 分量，新增 dataqueue frame。 *)
Definition assign_remove_running_ready
    (task : addr) (desc : TaskDescriptorAbs)
    (before after : OsAssignReadyVectorAbs) : Prop :=
  let prio := desc.(tdSchedMember).(tsmCurPrio) in
  let bucket_before := Znth prio before.(orvBuckets) nil in
  let bucket_after := Znth prio after.(orvBuckets) nil in
  remove_found_prop (sched_link_node task) bucket_before bucket_after /\
  after.(orvBuckets) = replace_Znth prio bucket_after before.(orvBuckets) /\
  ((bucket_after <> nil /\
    after.(orvReadyGroup) = before.(orvReadyGroup) /\
    after.(orvHighestPrio) = before.(orvHighestPrio))
    \/
   (bucket_after = nil /\
    let new_group := clear_flag32 before.(orvReadyGroup)
      desc.(tdSchedMember).(tsmBitmapColumn) in
    after.(orvReadyGroup) = new_group /\
    after.(orvHighestPrio) = bitmap_highest_priority new_group)).

(** 已有自持项保持位置；原先不自持的任务只在表头加入一次。 *)
Definition fresh_added {A} (a : A) (before after : list A) : Prop :=
  (In a before /\ after = before) \/
  (~ In a before /\ after = a :: before).


(** 挂起从ready容器取回sched_link并设置SUSPEND；取消delay在后续步骤执行。 *)
Record ktask_suspend_sched_step
    (task : addr) (desc : TaskDescriptorAbs)
    (before after : VarGlobalState) : Prop := {
  suspend_sched_lookup : before.(os_tasks).(task_desc_map) task = Some desc;
  suspend_sched_status :
    desc.(tdSchedMember).(tsmStat) = TSK_READY \/
    desc.(tdSchedMember).(tsmStat) = TSK_RUNNING;
  suspend_sched_remove : assign_remove_running_ready task desc
    before.(os_assign).(assignReadyVector)
    after.(os_assign).(assignReadyVector);
  suspend_sched_map : after.(os_tasks).(task_desc_map) =
    update_task_desc_map task
      (update_sched_member desc (set_sched_member_status desc.(tdSchedMember) TSK_SUSPEND))
      before.(os_tasks).(task_desc_map);
  suspend_sched_owned : fresh_added task
    before.(os_tasks).(sched_owned_tasks) after.(os_tasks).(sched_owned_tasks);
  suspend_sched_ids : after.(os_tasks).(task_idmanager_abs) = before.(os_tasks).(task_idmanager_abs);
  suspend_sched_tasks : after.(os_tasks).(task_ptr_list) = before.(os_tasks).(task_ptr_list);
  suspend_sched_running : after.(os_assign).(assignRunningTask) = before.(os_assign).(assignRunningTask);
  suspend_sched_priority : after.(os_assign).(assignCurrentPriority) = before.(os_assign).(assignCurrentPriority);
  suspend_sched_delays : after.(os_delays) = before.(os_delays);
  suspend_sched_tick : after.(os_tick) = before.(os_tick);
  suspend_sched_zombie : after.(zombie_queue) = before.(zombie_queue);
  suspend_sched_recycle : after.(os_recycle) = before.(os_recycle);
  suspend_sched_idle : after.(os_idle) = before.(os_idle);
  suspend_sched_semaphores : after.(os_semaphores) = before.(os_semaphores);
  suspend_sched_mutexes : after.(os_mutexes) = before.(os_mutexes);
  suspend_sched_dataqueues : after.(os_dataqueues) = before.(os_dataqueues);
  suspend_sched_events : after.(os_events) = before.(os_events);
  suspend_sched_isr : after.(os_isr) = before.(os_isr);
  suspend_sched_exstatus : after.(os_exstatus) = before.(os_exstatus)
}.

(**
  完整正常返回关系：两个错误出口均保持原状态；成功先提交调度节点/状态，
  再复用 KTaskUnSetDelay 的 N/U/L 三分支关系。active 分支只改 Delay 状态和
  归属，N/U 分支保持 os_delays。返回 -ERROR 是普通 C 结果，不是抽象错误。
  当前源码诊断宏不提供非空事实；契约调用点从已登记任务资源取得非空。
  当前指针只要求登记，不要求它始终处于 RUNNING；成功后仍指向 SUSPEND。
*)
Definition ktask_suspend_step (task : addr) (before : VarGlobalState)
    (result : Z) (after : VarGlobalState) : Prop :=
  task <> 0 /\
  ((task <> before.(os_assign).(assignRunningTask) /\
    result = -1 /\ after = before)
   \/
   (task = before.(os_assign).(assignRunningTask) /\
    exists desc,
      before.(os_tasks).(task_desc_map) task = Some desc /\
      ((desc.(tdSchedMember).(tsmStat) <> TSK_READY /\
        desc.(tdSchedMember).(tsmStat) <> TSK_RUNNING /\
        result = -1 /\ after = before)
       \/
       (result = 0 /\ exists staged,
          ktask_suspend_sched_step task desc before staged /\
          ktask_unset_delay_step desc.(tdDelay) staged after)))).

