From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Relations.Relation_Operators.
Require Import CRTOS_Verify.lib.CrtosGlobState CRTOS_Verify.lib.TaskProtocolSTS.
Require Import CRTOS_Verify.lib.KTaskPure.
Require Import CRTOS_Verify.sem.SemaphorePure.
Import ListNotations.
Local Open Scope Z_scope.

(** 非 SMP Assign 的运行指针、当前优先级、32 条 ready 队列和 ready-vector
    缓存，以及 CriticalArea.c 的调度禁止嵌套计数。pending 的 sched_link
    不属于 ready 队列。这里只保存真实对象内容，不保存 Assertion 或规则。 *)
Record SchedulerState := Build_SchedulerState {
  scheduler_lock_nest : Z;
  scheduler_running : addr;
  scheduler_current_priority : Z;
  scheduler_ready : list (list addr);
  scheduler_ready_group : Z;
  scheduler_highest_priority : Z
}.
(** 三模块在同一纯 OS carrier 上组合；task 分量直接复用根共享状态。 *)
Record CrtosOSState := Build_CrtosOSState {
  os_tasks : VarGlobalState;
  os_scheduler : SchedulerState;
  os_semaphores : SemaphoreState
}.
(** 当前slice只参数化semaphore全局地址；scheduler地址为固定C符号。
    task借用map不读取其ID manager/registry，因此不携带无客户端的task稳定记录。 *)
Record CrtosOSStable := Build_CrtosOSStable {
  os_sem_stable : SemaphoreStable
}.

(** 临界函数只修改真实 nest 单元，Assign 的所有其他内容保持。 *)
Definition scheduler_with_nest (n : Z) (s : SchedulerState) : SchedulerState :=
  Build_SchedulerState n s.(scheduler_running) s.(scheduler_current_priority)
    s.(scheduler_ready) s.(scheduler_ready_group) s.(scheduler_highest_priority).
Definition os_with_scheduler (s : SchedulerState) (before : CrtosOSState) : CrtosOSState :=
  Build_CrtosOSState before.(os_tasks) s before.(os_semaphores).
Definition os_with_semaphores (s : SemaphoreState) (before : CrtosOSState) : CrtosOSState :=
  Build_CrtosOSState before.(os_tasks) before.(os_scheduler) s.
Definition semaphore_nest_increment (before : CrtosOSState) : CrtosOSState :=
  os_with_scheduler (scheduler_with_nest
    ((before.(os_scheduler).(scheduler_lock_nest) + 1) mod 65536)
    before.(os_scheduler)) before.
Definition semaphore_nest_decrement (before : CrtosOSState) : CrtosOSState :=
  os_with_scheduler (scheduler_with_nest
    (Z.max 0 (before.(os_scheduler).(scheduler_lock_nest) - 1))
    before.(os_scheduler)) before.

(** 三模块共享同一task身份：根task_world_wf连接registry、ID节点和descriptor map。
    pending成员必须确为SUSPEND，且不同时占ready节点；这排除Wakeup因状态错误
    不摘节点而使ResumeAll无法清空的伪稳定态。Ready队列成员具有READY状态并
    位于cur_prio对应队列。运行指针只要求指向已发布descriptor：Obtain挂起当前
    任务后、调用调度前，它仍可指向SUSPEND任务；不能无依据强制其永远RUNNING。
    反向地，具有RUNNING状态的任务只能是这个指针指定的任务。不要求pending按
    当前优先级排序，因为PrioSet可修改已挂起任务的优先级而不重新排列pending。 *)
Definition CrtosOSValid (s : CrtosOSState) : Prop :=
  semaphore_valid s.(os_semaphores) /\
  task_world_wf s.(os_tasks) /\
  0 <= s.(os_scheduler).(scheduler_lock_nest) <= 65535 /\
  List.length s.(os_scheduler).(scheduler_ready) = 32%nat /\
  NoDup (List.concat s.(os_scheduler).(scheduler_ready)) /\
  (forall t, In t (List.concat (map semaphore_pending_addrs s.(os_semaphores))) ->
    ~ In t (List.concat s.(os_scheduler).(scheduler_ready)) /\
    exists desc, s.(os_tasks).(task_desc_map) t = Some desc /\
      Z.land desc.(tdSchedMember).(tsmStat) TASK_STAT_MASK = TASK_SUSPEND) /\
  (forall priority t,
    In t (List.nth priority s.(os_scheduler).(scheduler_ready) []) ->
    exists desc, s.(os_tasks).(task_desc_map) t = Some desc /\
      Z.land desc.(tdSchedMember).(tsmStat) TASK_STAT_MASK = TASK_READY /\
      desc.(tdSchedMember).(tsmCurPrio) = Z.of_nat priority) /\
  (s.(os_scheduler).(scheduler_running) <> 0 ->
    exists desc, s.(os_tasks).(task_desc_map)
      s.(os_scheduler).(scheduler_running) = Some desc) /\
  (forall t desc, s.(os_tasks).(task_desc_map) t = Some desc ->
    Z.land desc.(tdSchedMember).(tsmStat) TASK_STAT_MASK = TASK_RUNNING ->
    t = s.(os_scheduler).(scheduler_running)).

(** 临界区环境可以运行其他 semaphore 操作并调度任务；只要求前后模块有效。
    task 环境行为复用共享 TaskRTrans，允许其他创建者持自己 token 完成创建。
    该过近似不声称环境只运行 create，也不冻结 task/scheduler。
    两端nest=0是本次对外API非嵌套IRQ边界；inside中间状态由表示层另行持有。 *)
Definition CrtosOSTransition (before after : CrtosOSState) : Prop :=
  CrtosOSValid before /\ CrtosOSValid after /\
  before.(os_scheduler).(scheduler_lock_nest) = 0 /\
  after.(os_scheduler).(scheduler_lock_nest) = 0 /\
  CRTOS_Verify.lib.CrtosRules.TaskRTrans before.(os_tasks) after.(os_tasks).

(** create 的 guarantee 精确保持 task 和完整 scheduler 分量；nest 的局部
    加减在 IRQ exit 之前恢复，不能作为 API 的持久 effect。 *)
Definition SemaphoreGuarantee (before after : CrtosOSState) : Prop :=
  CrtosOSTransition before after /\
  after.(os_tasks) = before.(os_tasks) /\
  after.(os_scheduler) = before.(os_scheduler).
Definition SemaphoreRely := CrtosOSTransition.

(** KSemaphoreCreate 的成功抽象状态，包含 unchanged 的 task/scheduler frame。 *)
Definition semaphore_os_publish (p id value : Z) (before : CrtosOSState) : CrtosOSState :=
  os_with_semaphores (semaphore_publish p id value before.(os_semaphores)) before.

Lemma semaphore_publish_preserves_tasks : forall p id value s,
  (semaphore_os_publish p id value s).(os_tasks) = s.(os_tasks).
Proof. reflexivity. Qed.
Lemma semaphore_publish_preserves_scheduler : forall p id value s,
  (semaphore_os_publish p id value s).(os_scheduler) = s.(os_scheduler).
Proof. reflexivity. Qed.

(** 对外非嵌套IRQ边界的真实两次uint16写闭合；内部不声称任意nest可配对恢复。 *)
Lemma semaphore_nesting_roundtrip : forall s,
  s.(os_scheduler).(scheduler_lock_nest) = 0 ->
  semaphore_nest_decrement (semaphore_nest_increment s) = s.
Proof.
  intros [tasks [nest running priority ready bitmap highest] sems] H.
  cbn in H; subst nest. reflexivity.
Qed.


(** 对已经存在的同一descriptor作判断，不能靠换一份描述符绕过pending的SUSPEND义务。 *)
Lemma CrtosOSValid_pending_suspended : forall s task desc,
  CrtosOSValid s ->
  In task (List.concat (map semaphore_pending_addrs s.(os_semaphores))) ->
  s.(os_tasks).(task_desc_map) task = Some desc ->
  Z.land desc.(tdSchedMember).(tsmStat) TASK_STAT_MASK = TASK_SUSPEND.
Proof.
  intros s task desc [_ [_ [_ [_ [_ [Hpending _]]]]]] Hin Hmap.
  destruct (Hpending task Hin) as [_ [actual [Hactual Hstatus]]].
  rewrite Hmap in Hactual. inversion Hactual; subst. exact Hstatus.
Qed.

(** pending中的task确实在根任务注册表中；map项不再可与身份容器脱节。 *)
Lemma CrtosOSValid_pending_registered : forall s task,
  CrtosOSValid s ->
  In task (List.concat (map semaphore_pending_addrs s.(os_semaphores))) ->
  In task s.(os_tasks).(task_ptr_list).
Proof.
  intros s task [_ [Hworld [_ [_ [_ [Hpending _]]]]]] Hin.
  destruct (Hpending task Hin) as [_ [desc [Hmap _]]].
  destruct Hworld as [_ [Houtside _]].
  destruct (in_dec Z.eq_dec task s.(os_tasks).(task_ptr_list)) as [Hyes|Hno].
  - exact Hyes.
  - specialize (Houtside task Hno). rewrite Hmap in Houtside. discriminate.
Qed.
