Require Import Coq.ZArith.ZArith.
Require Import Coq.Bool.Bool.
Require Import Coq.Lists.List.
Require Import Coq.Sorting.Permutation.
Require Import Coq.Sorting.Sorted.
Require Import Coq.Relations.Relation_Operators.
Require Import Coq.micromega.Lia.
From AUXLib Require Import ListLib.
From SimpleC.SL Require Import Mem.

Require Import CRTOS_Verify.lib.CrtosGlobState.
Require Import CRTOS_Verify.lib.KTaskPure.
Require Import CRTOS_Verify.libai.TaskProtocolSTS.
Require Import CRTOS_Verify.sem.SemaphorePure.

Import ListNotations.
Local Open Scope Z_scope.

(**
  本文件是 task/scheduler/semaphore 的纯组合层。Task 的唯一权威状态仍是
  [VarGlobalState] 与 [TaskDescriptorAbs]；这里新增的 scheduler state 只记录
  [sched_link] 当前属于 ready、running、外部等待或 zombie 中的哪一处，以及
  delay 对象的生命周期，不复制 descriptor 字段。
*)

Definition CRTOS_READY_QUEUE_COUNT : Z := 32.

(** 一个 [struct Delay] 分配块的纯内容；inactive 对象仍由 task->delay 引用。 *)
Record CrtosDelayAbs : Type := Build_CrtosDelayAbs {
  crtos_delay_addr : addr;
  crtos_delay_task : addr;
  crtos_delay_ticks : Z;
  crtos_delay_active : bool
}.

(** 非 semaphore 的 mutex/event/queue 等等待链表，只记录公共 head 与 task 顺序。 *)
Record CrtosWaitQueue : Type := Build_CrtosWaitQueue {
  crtos_wait_head : addr;
  crtos_wait_tasks : list addr
}.

(**
  [CrtosSchedulerState] 记录非 SMP [Assign] 和 delay 子系统的可变内容。
  ready queues 按 priority 下标保存 task 基址；status=RUNNING 时 sched_link 是
  detached self-loop。[crtos_running_task] 只是 Assign 当前指针：当前任务变成
  SUSPEND/CLOSE 后、下一次调度前它仍可指向该任务，因而不是 link owner 集合。
  external waiting/zombie 由公共 integration container 层拥有 heads 与节点；
  各 IPC 模块 body 仍只拥有自己的非链表字段。
*)
Record CrtosSchedulerState : Type := Build_CrtosSchedulerState {
  crtos_ready_queues : list (list addr);
  crtos_ready_group : Z;
  crtos_highest_prio : Z;
  crtos_running_task : option addr;
  crtos_ready_vector_done : addr;
  crtos_current_priority : Z;
  crtos_external_wait_queues : list CrtosWaitQueue;
  crtos_zombie_tasks : list addr;
  crtos_delay_entries : list CrtosDelayAbs
}.

(** 稳定地址由现有 Task 与 Semaphore stable records 共同给出。 *)
Record CrtosOSStable : Type := Build_CrtosOSStable {
  crtos_task_stable : StableGlobalState;
  crtos_semaphore_stable : SemaphoreStable
}.

(** 统一可变 world：Task、scheduler/delay 与 semaphore 各只有一个权威分量。 *)
Record CrtosOSWorld : Type := Build_CrtosOSWorld {
  crtos_task_state : VarGlobalState;
  crtos_scheduler_state : CrtosSchedulerState;
  crtos_semaphore_state : SemaphoreState
}.

Definition crtos_task_status (desc : TaskDescriptorAbs) : Z :=
  Z.land desc.(tdSchedMember).(tsmStat) TASK_STAT_MASK.

Definition crtos_ready_tasks (scheduler : CrtosSchedulerState) : list addr :=
  List.concat scheduler.(crtos_ready_queues).

Definition crtos_delay_tasks (scheduler : CrtosSchedulerState) : list addr :=
  map crtos_delay_task scheduler.(crtos_delay_entries).

Definition crtos_active_delay_tasks
    (scheduler : CrtosSchedulerState) : list addr :=
  map crtos_delay_task
    (filter (fun delay => crtos_delay_active delay)
      scheduler.(crtos_delay_entries)).

Definition crtos_external_waiting_tasks
    (scheduler : CrtosSchedulerState) : list addr :=
  List.concat (map crtos_wait_tasks scheduler.(crtos_external_wait_queues)).

(** 在有限注册表中查询已经发布的 Normal descriptor。 *)
Definition crtos_registered_desc
    (task_state : VarGlobalState) (task : addr) (desc : TaskDescriptorAbs) : Prop :=
  In task task_state.(task_ptr_list) /\
  task_state.(task_virtual_status) task = VTS_NORMAL /\
  task_state.(task_desc_map) task = Some desc.

(** task 是否位于第 [priority] 条 ready DLL；priority 使用真实数组下标。 *)
Definition crtos_ready_at
    (scheduler : CrtosSchedulerState) (priority : Z) (task : addr) : Prop :=
  0 <= priority < CRTOS_READY_QUEUE_COUNT /\
  In task (Znth priority scheduler.(crtos_ready_queues) nil).

Definition crtos_ready_slot_nonempty
    (scheduler : CrtosSchedulerState) (priority : Z) : bool :=
  if list_eq_dec Z.eq_dec
       (Znth priority scheduler.(crtos_ready_queues) nil) nil
  then false else true.

(** ready bitmap 与 32 个 queue heads 一致；highest 是最高的非空 priority。 *)
Definition crtos_ready_metadata_ok (scheduler : CrtosSchedulerState) : Prop :=
  (forall priority,
    0 <= priority < CRTOS_READY_QUEUE_COUNT ->
    Z.testbit scheduler.(crtos_ready_group) priority =
      crtos_ready_slot_nonempty scheduler priority) /\
  (scheduler.(crtos_ready_group) = 0 /\
     scheduler.(crtos_highest_prio) = 0 \/
   scheduler.(crtos_ready_group) <> 0 /\
     crtos_ready_slot_nonempty scheduler scheduler.(crtos_highest_prio) = true /\
     forall priority,
       scheduler.(crtos_highest_prio) < priority < CRTOS_READY_QUEUE_COUNT ->
       crtos_ready_slot_nonempty scheduler priority = false).

Inductive CrtosSchedPlacement : Type :=
  | CSP_INIT
  | CSP_READY (priority : Z)
  | CSP_RUNNING
  | CSP_SUSPEND_DETACHED
  | CSP_SEMAPHORE_PENDING (semaphore : addr)
  | CSP_EXTERNAL_WAITING
  | CSP_ZOMBIE.

(**
  [crtos_task_placement] 是 sched_link 的纯 owner 路由。空间 owner 分别是
  descriptor self-loop、ready queue、running self-loop、具体 semaphore
  pend_list、外部模块 wait queue 或 zombie queue。
*)
Inductive crtos_task_placement
    (world : CrtosOSWorld) (task : addr) : CrtosSchedPlacement -> Prop :=
  | PlaceInit : forall desc,
      crtos_registered_desc world.(crtos_task_state) task desc ->
      crtos_task_status desc = TASK_INIT ->
      crtos_task_placement world task CSP_INIT
  | PlaceReady : forall desc priority,
      crtos_registered_desc world.(crtos_task_state) task desc ->
      crtos_task_status desc = TASK_READY ->
      priority = desc.(tdSchedMember).(tsmCurPrio) ->
      crtos_ready_at world.(crtos_scheduler_state) priority task ->
      crtos_task_placement world task (CSP_READY priority)
  | PlaceRunning : forall desc,
      crtos_registered_desc world.(crtos_task_state) task desc ->
      crtos_task_status desc = TASK_RUNNING ->
      world.(crtos_scheduler_state).(crtos_running_task) = Some task ->
      crtos_task_placement world task CSP_RUNNING
  | PlaceSemaphorePending : forall desc object,
      crtos_registered_desc world.(crtos_task_state) task desc ->
      crtos_task_status desc = TASK_SUSPEND ->
      In object world.(crtos_semaphore_state).(semaphore_objects) ->
      In task object.(semaphore_pending_addrs) ->
      crtos_task_placement world task
        (CSP_SEMAPHORE_PENDING object.(semaphore_addr))
  | PlaceSuspendDetached : forall desc,
      crtos_registered_desc world.(crtos_task_state) task desc ->
      crtos_task_status desc = TASK_SUSPEND ->
      ~ In task
          (semaphore_all_pending
            world.(crtos_semaphore_state).(semaphore_objects)) ->
      ~ In task
          (crtos_external_waiting_tasks world.(crtos_scheduler_state)) ->
      crtos_task_placement world task CSP_SUSPEND_DETACHED
  | PlaceExternalWaiting : forall desc,
      crtos_registered_desc world.(crtos_task_state) task desc ->
      crtos_task_status desc = TASK_SUSPEND ->
      In task (crtos_external_waiting_tasks world.(crtos_scheduler_state)) ->
      crtos_task_placement world task CSP_EXTERNAL_WAITING
  | PlaceZombie : forall desc,
      crtos_registered_desc world.(crtos_task_state) task desc ->
      crtos_task_status desc = TASK_CLOSE ->
      In task world.(crtos_scheduler_state).(crtos_zombie_tasks) ->
      crtos_task_placement world task CSP_ZOMBIE.

(** 非 INIT task 的 ready-vector 索引字段由 __BitmapSiteMask 建立并保持。 *)
Definition crtos_task_ready_metadata (desc : TaskDescriptorAbs) : Prop :=
  0 <= desc.(tdSchedMember).(tsmCurPrio) < CRTOS_READY_QUEUE_COUNT /\
  0 <= desc.(tdSchedMember).(tsmAdvanceCnt) <= 255 /\
  0 <= desc.(tdSchedMember).(tsmOriginTimeslice) <= 4294967295 /\
  0 <= desc.(tdSchedMember).(tsmRestTimeslice) <= 4294967295 /\
  desc.(tdSchedMember).(tsmBitmapColumn) =
    Z.shiftl 1 desc.(tdSchedMember).(tsmCurPrio).

Definition crtos_delay_order (left right : CrtosDelayAbs) : Prop :=
  left.(crtos_delay_ticks) <= right.(crtos_delay_ticks).

Definition crtos_active_delays_ordered (scheduler : CrtosSchedulerState) : Prop :=
  StronglySorted crtos_delay_order
    (filter crtos_delay_active scheduler.(crtos_delay_entries)).

(**
  具体 semaphore/task bridge：每个 pending 地址必须是注册的 Normal task，
  descriptor 低三位为 SUSPEND，且其唯一 placement 指向当前 semaphore。
*)
Definition semaphore_task_bridge
    (stable : CrtosOSStable) (world : CrtosOSWorld) : Prop :=
  forall object task,
    In object world.(crtos_semaphore_state).(semaphore_objects) ->
    In task object.(semaphore_pending_addrs) ->
    exists desc,
      crtos_registered_desc world.(crtos_task_state) task desc /\
      crtos_task_status desc = TASK_SUSPEND /\
      desc.(tdDone) = stable.(crtos_task_stable).(task_done_ptr) /\
      crtos_task_ready_metadata desc /\
      crtos_task_placement world task
        (CSP_SEMAPHORE_PENDING object.(semaphore_addr)).

Definition crtos_delay_entry_wf
    (task_state : VarGlobalState) (delay : CrtosDelayAbs) : Prop :=
  delay.(crtos_delay_addr) <> 0 /\
  exists desc,
    crtos_registered_desc task_state delay.(crtos_delay_task) desc /\
    desc.(tdDelay) = delay.(crtos_delay_addr).

Definition crtos_wait_queue_wf (queue : CrtosWaitQueue) : Prop :=
  queue.(crtos_wait_head) <> 0 /\ NoDup queue.(crtos_wait_tasks).

(**
  调度状态的稳定一致性。所有可见 sched_link placement 地址全局 NoDup；
  每个 Normal 注册任务恰有一个 placement。active delay task 只能是 suspend。
*)
Definition crtos_scheduler_wf
    (stable : CrtosOSStable) (world : CrtosOSWorld) : Prop :=
  let task_state := world.(crtos_task_state) in
  let scheduler := world.(crtos_scheduler_state) in
  let sem_pending :=
    semaphore_all_pending world.(crtos_semaphore_state).(semaphore_objects) in
  Zlength scheduler.(crtos_ready_queues) = CRTOS_READY_QUEUE_COUNT /\
  0 <= scheduler.(crtos_ready_group) <= 4294967295 /\
  0 <= scheduler.(crtos_highest_prio) < CRTOS_READY_QUEUE_COUNT /\
  0 <= scheduler.(crtos_current_priority) <= 255 /\
  scheduler.(crtos_ready_vector_done) <> 0 /\
  crtos_ready_metadata_ok scheduler /\
  crtos_active_delays_ordered scheduler /\
  NoDup
    (crtos_ready_tasks scheduler ++
     sem_pending ++
     crtos_external_waiting_tasks scheduler ++
     scheduler.(crtos_zombie_tasks)) /\
  NoDup (map crtos_wait_head scheduler.(crtos_external_wait_queues)) /\
  Forall crtos_wait_queue_wf scheduler.(crtos_external_wait_queues) /\
  NoDup (map crtos_delay_addr scheduler.(crtos_delay_entries)) /\
  NoDup (crtos_delay_tasks scheduler) /\
  Forall (crtos_delay_entry_wf task_state)
    scheduler.(crtos_delay_entries) /\
  (forall task desc,
    crtos_registered_desc task_state task desc ->
    desc.(tdDelay) = 0 \/
    exists delay,
      In delay scheduler.(crtos_delay_entries) /\
      delay.(crtos_delay_task) = task /\
      delay.(crtos_delay_addr) = desc.(tdDelay)) /\
  (forall task desc,
    crtos_registered_desc task_state task desc ->
    desc.(tdDone) = stable.(crtos_task_stable).(task_done_ptr) /\
    (crtos_task_status desc = TASK_INIT \/ crtos_task_ready_metadata desc)) /\
  (forall task desc,
    crtos_registered_desc task_state task desc ->
    exists placement, crtos_task_placement world task placement) /\
  (forall priority task,
    crtos_ready_at scheduler priority task ->
    exists desc,
      crtos_registered_desc task_state task desc /\
      crtos_task_status desc = TASK_READY /\
      priority = desc.(tdSchedMember).(tsmCurPrio)) /\
  (forall task,
    scheduler.(crtos_running_task) = Some task ->
    exists desc,
      crtos_registered_desc task_state task desc /\
      (crtos_task_status desc = TASK_RUNNING \/
       crtos_task_status desc = TASK_READY \/
       crtos_task_status desc = TASK_SUSPEND \/
       crtos_task_status desc = TASK_CLOSE)) /\
  (forall task,
    In task (crtos_external_waiting_tasks scheduler) ->
    exists desc,
      crtos_registered_desc task_state task desc /\
      crtos_task_status desc = TASK_SUSPEND) /\
  (forall task,
    In task scheduler.(crtos_zombie_tasks) ->
    exists desc,
      crtos_registered_desc task_state task desc /\
      crtos_task_status desc = TASK_CLOSE) /\
  (forall task,
    In task (crtos_active_delay_tasks scheduler) ->
    exists desc,
      crtos_registered_desc task_state task desc /\
      crtos_task_status desc = TASK_SUSPEND).

(** 统一 world 的纯稳定条件；不拥有任何 C 字节。 *)
Definition crtos_os_world_wf
    (stable : CrtosOSStable) (world : CrtosOSWorld) : Prop :=
  task_world_wf world.(crtos_task_state) /\
  semaphore_state_wf stable.(crtos_semaphore_stable)
    world.(crtos_semaphore_state) /\
  semaphore_task_bridge stable world /\
  crtos_scheduler_wf stable world.

(** pending 头调用 KTaskWakeup 所需的真实 descriptor/dispatch/ready 索引前提。 *)
Definition crtos_pending_task_wake_ready
    (stable : CrtosOSStable) (world : CrtosOSWorld) (task : addr) : Prop :=
  exists object desc,
    In object world.(crtos_semaphore_state).(semaphore_objects) /\
    In task object.(semaphore_pending_addrs) /\
    crtos_registered_desc world.(crtos_task_state) task desc /\
    crtos_task_status desc = TASK_SUSPEND /\
    desc.(tdDone) = stable.(crtos_task_stable).(task_done_ptr) /\
    crtos_task_ready_metadata desc.

Lemma semaphore_pending_member_wake_ready :
  forall stable world object task,
    semaphore_task_bridge stable world ->
    In object world.(crtos_semaphore_state).(semaphore_objects) ->
    In task object.(semaphore_pending_addrs) ->
    crtos_pending_task_wake_ready stable world task.
Proof.
  intros stable world object task Hbridge Hobject Htask.
  specialize (Hbridge object task Hobject Htask).
  destruct Hbridge as [desc [Hreg [Hstatus [Hdone [Hmeta _]]]]].
  exists object, desc.
  refine (conj Hobject _).
  refine (conj Htask _).
  refine (conj Hreg _).
  refine (conj Hstatus _).
  exact (conj Hdone Hmeta).
Qed.

(** pending 总数是 [LinklistResumeAll] 的循环变元。 *)
Definition semaphore_pending_measure (world : CrtosOSWorld) : Z :=
  Zlength
    (semaphore_all_pending
      world.(crtos_semaphore_state).(semaphore_objects)).

(**
  相邻稳定 world 的 semaphore pending 变化只有三种：不变、插入一个、
  删除一个。删除构造器携带精确 measure 等式，直接提供 resume-all 进展性。
*)
Inductive semaphore_pending_delta :
    CrtosOSWorld -> CrtosOSWorld -> Prop :=
  | PendingUnchanged : forall before after,
      semaphore_all_pending before.(crtos_semaphore_state).(semaphore_objects) =
      semaphore_all_pending after.(crtos_semaphore_state).(semaphore_objects) ->
      semaphore_pending_delta before after
  | PendingInserted : forall before after task prefix suffix,
      semaphore_all_pending before.(crtos_semaphore_state).(semaphore_objects) =
        prefix ++ suffix ->
      semaphore_all_pending after.(crtos_semaphore_state).(semaphore_objects) =
        prefix ++ task :: suffix ->
      (exists priority,
        crtos_task_placement before task (CSP_READY priority)) \/
        crtos_task_placement before task CSP_RUNNING ->
      (exists semaphore,
        crtos_task_placement after task
          (CSP_SEMAPHORE_PENDING semaphore)) ->
      semaphore_pending_delta before after
  | PendingRemoved : forall before after task prefix suffix,
      semaphore_all_pending before.(crtos_semaphore_state).(semaphore_objects) =
        prefix ++ task :: suffix ->
      semaphore_all_pending after.(crtos_semaphore_state).(semaphore_objects) =
        prefix ++ suffix ->
      (exists semaphore,
        crtos_task_placement before task
          (CSP_SEMAPHORE_PENDING semaphore)) ->
      (exists priority,
        crtos_task_placement after task (CSP_READY priority)) ->
      semaphore_pending_delta before after.

Lemma semaphore_pending_removed_progress :
  forall before after task prefix suffix,
    semaphore_all_pending before.(crtos_semaphore_state).(semaphore_objects) =
      prefix ++ task :: suffix ->
    semaphore_all_pending after.(crtos_semaphore_state).(semaphore_objects) =
      prefix ++ suffix ->
    semaphore_pending_measure after + 1 = semaphore_pending_measure before.
Proof.
  intros before after task prefix suffix Hbefore Hafter.
  unfold semaphore_pending_measure. rewrite Hbefore, Hafter.
  repeat rewrite Zlength_app. rewrite Zlength_cons. lia.
Qed.

(** 一次组合提交至多包含一个 semaphore atomic step；task-only 动作为 stutter。 *)
Definition crtos_semaphore_single_step
    (stable : SemaphoreStable) (before after : SemaphoreState) : Prop :=
  before = after \/ semaphore_atomic_step stable before after.

(** KTaskStateSet 的精确低三位更新；其余五个 status bits 保持。 *)
Definition crtos_sched_status_write
    (status : Z) (before after : TaskSchedMemberAbs) : Prop :=
  after.(tsmStat) =
    Z.lor status (Z.land before.(tsmStat) (Z.lnot TASK_STAT_MASK)) /\
  after.(tsmAdvanceCnt) = before.(tsmAdvanceCnt) /\
  after.(tsmCurPrio) = before.(tsmCurPrio) /\
  after.(tsmOriginTimeslice) = before.(tsmOriginTimeslice) /\
  after.(tsmRestTimeslice) = before.(tsmRestTimeslice) /\
  after.(tsmBitmapColumn) = before.(tsmBitmapColumn).

(** status/delay/exstatus 是 semaphore 可达 task paths 唯一可写的 descriptor 分量。 *)
Definition crtos_desc_runtime_write
    (status delay exstatus : Z)
    (before after : TaskDescriptorAbs) : Prop :=
  before.(tdStackPoint) = after.(tdStackPoint) /\
  before.(tdStackContext) = after.(tdStackContext) /\
  before.(tdBaseInfo) = after.(tdBaseInfo) /\
  crtos_sched_status_write status before.(tdSchedMember) after.(tdSchedMember) /\
  after.(tdDelay) = delay /\
  before.(tdEventIdTrigger) = after.(tdEventIdTrigger) /\
  before.(tdEventMode) = after.(tdEventMode) /\
  after.(tdExstatus) = exstatus /\
  before.(tdDone) = after.(tdDone).

Definition crtos_desc_delay_write
    (delay : Z) (before after : TaskDescriptorAbs) : Prop :=
  before.(tdStackPoint) = after.(tdStackPoint) /\
  before.(tdStackContext) = after.(tdStackContext) /\
  before.(tdBaseInfo) = after.(tdBaseInfo) /\
  before.(tdSchedMember) = after.(tdSchedMember) /\
  after.(tdDelay) = delay /\
  before.(tdEventIdTrigger) = after.(tdEventIdTrigger) /\
  before.(tdEventMode) = after.(tdEventMode) /\
  before.(tdExstatus) = after.(tdExstatus) /\
  before.(tdDone) = after.(tdDone).

(** 只更新一个 descriptor cell；Task manager、注册顺序和所有其他 cell frame。 *)
Definition crtos_task_state_one_update
    (task : addr) (before_desc after_desc : TaskDescriptorAbs)
    (before after : VarGlobalState) : Prop :=
  before.(task_virtual_status) = after.(task_virtual_status) /\
  before.(task_idmanager_abs) = after.(task_idmanager_abs) /\
  before.(task_ptr_list) = after.(task_ptr_list) /\
  before.(task_desc_map) task = Some before_desc /\
  after.(task_desc_map) task = Some after_desc /\
  forall other, other <> task ->
    before.(task_desc_map) other = after.(task_desc_map) other.

Definition crtos_task_state_two_updates
    (first second : addr)
    (first_before first_after second_before second_after : TaskDescriptorAbs)
    (before after : VarGlobalState) : Prop :=
  first <> second /\
  before.(task_virtual_status) = after.(task_virtual_status) /\
  before.(task_idmanager_abs) = after.(task_idmanager_abs) /\
  before.(task_ptr_list) = after.(task_ptr_list) /\
  before.(task_desc_map) first = Some first_before /\
  after.(task_desc_map) first = Some first_after /\
  before.(task_desc_map) second = Some second_before /\
  after.(task_desc_map) second = Some second_after /\
  forall other, other <> first -> other <> second ->
    before.(task_desc_map) other = after.(task_desc_map) other.

Definition crtos_ready_queues_except
    (task : addr) (scheduler : CrtosSchedulerState) : list (list addr) :=
  map (remove Z.eq_dec task) scheduler.(crtos_ready_queues).

Definition crtos_delay_entries_except
    (task : addr) (scheduler : CrtosSchedulerState) : list CrtosDelayAbs :=
  filter
    (fun delay => negb (Z.eqb delay.(crtos_delay_task) task))
    scheduler.(crtos_delay_entries).

(** suspend/wake/pend 针对一个 task 时，所有非目标 scheduler 资源完整 frame。 *)
Definition crtos_scheduler_one_task_frame
    (task : addr) (before after : CrtosSchedulerState) : Prop :=
  crtos_ready_queues_except task before = crtos_ready_queues_except task after /\
  before.(crtos_running_task) = after.(crtos_running_task) /\
  before.(crtos_ready_vector_done) = after.(crtos_ready_vector_done) /\
  before.(crtos_current_priority) = after.(crtos_current_priority) /\
  before.(crtos_external_wait_queues) = after.(crtos_external_wait_queues) /\
  before.(crtos_zombie_tasks) = after.(crtos_zombie_tasks) /\
  crtos_delay_entries_except task before = crtos_delay_entries_except task after.

Definition crtos_ready_queues_except_two
    (first second : addr) (scheduler : CrtosSchedulerState) : list (list addr) :=
  map (fun tasks => remove Z.eq_dec second (remove Z.eq_dec first tasks))
    scheduler.(crtos_ready_queues).

(** KTaskOsAssign switch 只改变两个 sched links、running/current 与 ready metadata。 *)
Definition crtos_scheduler_switch_frame
    (first second : addr)
    (before after : CrtosSchedulerState) : Prop :=
  crtos_ready_queues_except_two first second before =
    crtos_ready_queues_except_two first second after /\
  before.(crtos_ready_vector_done) = after.(crtos_ready_vector_done) /\
  before.(crtos_external_wait_queues) = after.(crtos_external_wait_queues) /\
  before.(crtos_zombie_tasks) = after.(crtos_zombie_tasks) /\
  before.(crtos_delay_entries) = after.(crtos_delay_entries).

(** strict-compare 循环的稳定插入：prefix 全部不大于 target，suffix 首项严格大。 *)
Definition crtos_stable_insert {A : Type}
    (less : A -> A -> Prop) (target : A)
    (before after : list A) : Prop :=
  exists prefix suffix,
    before = prefix ++ suffix /\
    after = prefix ++ target :: suffix /\
    Forall (fun item => ~ less target item) prefix /\
    match suffix with
    | nil => True
    | first :: _ => less target first
    end.

Definition crtos_ready_rest_less
    (task_state : VarGlobalState) (target_desc : TaskDescriptorAbs)
    (other : addr) : Prop :=
  exists other_desc,
    crtos_registered_desc task_state other other_desc /\
    target_desc.(tdSchedMember).(tsmRestTimeslice) <
      other_desc.(tdSchedMember).(tsmRestTimeslice).

(**
  RoundRobinRemainReadyVectorInsert：advance<1 时 stable insert before first
  strictly-greater rest；advance>=1 时严格 tail insert。其余 priority queues 不变。
*)
Definition crtos_ready_insert_step
    (task : addr) (desc : TaskDescriptorAbs) (task_state : VarGlobalState)
    (before after : list (list addr)) : Prop :=
  let priority := desc.(tdSchedMember).(tsmCurPrio) in
  exists new_queue,
    (if Z.ltb desc.(tdSchedMember).(tsmAdvanceCnt) 1
     then crtos_stable_insert
       (fun _ other => crtos_ready_rest_less task_state desc other) task
       (Znth priority before nil) new_queue
     else new_queue = Znth priority before nil ++ task :: nil) /\
    after = replace_Znth priority new_queue before.

(** ready remove 保持所有非目标节点及每条 priority queue 的物理顺序。 *)
Definition crtos_ready_remove_step
    (task : addr) (before after : list (list addr)) : Prop :=
  after = map (remove Z.eq_dec task) before.

(** YieldOsAssign 的真实顺序：先按策略插入 from，再删除此前已选定的 to。 *)
Definition crtos_ready_switch_step
    (from to : addr) (from_desc : TaskDescriptorAbs)
    (task_state : VarGlobalState)
    (before after : list (list addr)) : Prop :=
  exists inserted,
    crtos_ready_insert_step from from_desc task_state before inserted /\
    crtos_ready_remove_step to inserted after.

(** ChooseTaskWithHighestPrio 精确选择 before.highest_prio queue 的 node_next。 *)
Definition crtos_selected_ready_task
    (scheduler : CrtosSchedulerState) (task : addr) : Prop :=
  exists rest,
    Znth scheduler.(crtos_highest_prio)
      scheduler.(crtos_ready_queues) nil = task :: rest.

(** KTaskUnSetDelay：无 active entry 时 stutter；否则只把同一 entry 置 inactive。 *)
Inductive crtos_delay_unset_step (task : addr) :
    list CrtosDelayAbs -> list CrtosDelayAbs -> Prop :=
  | CrtosDelayUnsetStutter : forall entries,
      (forall delay,
        In delay entries ->
        delay.(crtos_delay_task) = task ->
        delay.(crtos_delay_active) = false) ->
      crtos_delay_unset_step task entries entries
  | CrtosDelayUnsetActive : forall before after before_delay after_delay,
      In before_delay before ->
      In after_delay after ->
      before_delay.(crtos_delay_task) = task ->
      after_delay.(crtos_delay_task) = task ->
      before_delay.(crtos_delay_addr) = after_delay.(crtos_delay_addr) ->
      before_delay.(crtos_delay_ticks) = after_delay.(crtos_delay_ticks) ->
      before_delay.(crtos_delay_active) = true ->
      after_delay.(crtos_delay_active) = false ->
      map crtos_delay_addr (filter crtos_delay_active after) =
        remove Z.eq_dec before_delay.(crtos_delay_addr)
          (map crtos_delay_addr (filter crtos_delay_active before)) ->
      filter (fun delay => negb (Z.eqb delay.(crtos_delay_task) task)) before =
      filter (fun delay => negb (Z.eqb delay.(crtos_delay_task) task)) after ->
      crtos_delay_unset_step task before after.

(** KTaskSetDelay：复用或新建 target entry，after 地址匹配 task->delay 且 active。 *)
Inductive crtos_delay_set_step (task delay_addr : addr) (deadline : Z) :
    list CrtosDelayAbs -> list CrtosDelayAbs -> Prop :=
  | CrtosDelaySetExisting : forall before after before_delay after_delay,
      In before_delay before ->
      In after_delay after ->
      before_delay.(crtos_delay_task) = task ->
      after_delay.(crtos_delay_task) = task ->
      before_delay.(crtos_delay_addr) = delay_addr ->
      after_delay.(crtos_delay_addr) = delay_addr ->
      after_delay.(crtos_delay_ticks) = deadline ->
      after_delay.(crtos_delay_active) = true ->
      crtos_stable_insert
        (fun target existing =>
          target.(crtos_delay_ticks) < existing.(crtos_delay_ticks))
        after_delay
        (filter
          (fun item => andb item.(crtos_delay_active)
            (negb (Z.eqb item.(crtos_delay_task) task))) before)
        (filter crtos_delay_active after) ->
      filter (fun delay => negb (Z.eqb delay.(crtos_delay_task) task)) before =
      filter (fun delay => negb (Z.eqb delay.(crtos_delay_task) task)) after ->
      crtos_delay_set_step task delay_addr deadline before after
  | CrtosDelaySetNew : forall before after after_delay,
      ~ In task (map crtos_delay_task before) ->
      In after_delay after ->
      after_delay.(crtos_delay_task) = task ->
      after_delay.(crtos_delay_addr) = delay_addr ->
      after_delay.(crtos_delay_ticks) = deadline ->
      after_delay.(crtos_delay_active) = true ->
      crtos_stable_insert
        (fun target existing =>
          target.(crtos_delay_ticks) < existing.(crtos_delay_ticks))
        after_delay
        (filter crtos_delay_active before)
        (filter crtos_delay_active after) ->
      filter (fun delay => negb (Z.eqb delay.(crtos_delay_task) task)) before =
      filter (fun delay => negb (Z.eqb delay.(crtos_delay_task) task)) after ->
      crtos_delay_set_step task delay_addr deadline before after.

(** 调度器发现 current 已非 RUNNING 时，sched_link 可能处于以下任一 owner。 *)
Inductive crtos_nonrunning_placement : CrtosSchedPlacement -> Prop :=
  | NonrunningDetached :
      crtos_nonrunning_placement CSP_SUSPEND_DETACHED
  | NonrunningSemaphore : forall semaphore,
      crtos_nonrunning_placement (CSP_SEMAPHORE_PENDING semaphore)
  | NonrunningExternal :
      crtos_nonrunning_placement CSP_EXTERNAL_WAITING
  | NonrunningZombie :
      crtos_nonrunning_placement CSP_ZOMBIE.

(**
  每个 constructor 对应一个权威 C symbol/path，一次只更新列出的 target。
  其他 descriptor 由 [crtos_task_state_one_update] 完整 frame；scheduler 的
  非目标队列与 delay entries 由 [crtos_scheduler_one_task_frame] frame。
*)
Inductive crtos_task_scheduler_step : CrtosOSWorld -> CrtosOSWorld -> Prop :=
  | CrtosRuntimeFrame : forall before after,
      before.(crtos_task_state) = after.(crtos_task_state) ->
      before.(crtos_scheduler_state) = after.(crtos_scheduler_state) ->
      crtos_task_scheduler_step before after
  | CrtosRuntimePend : forall before after task before_desc after_desc semaphore,
      (exists prefix suffix,
        semaphore_all_pending
          before.(crtos_semaphore_state).(semaphore_objects) = prefix ++ suffix /\
        semaphore_all_pending
          after.(crtos_semaphore_state).(semaphore_objects) =
            prefix ++ task :: suffix) ->
      crtos_task_state_one_update task before_desc after_desc
        before.(crtos_task_state) after.(crtos_task_state) ->
      crtos_desc_runtime_write TASK_SUSPEND before_desc.(tdDelay) 0
        before_desc after_desc ->
      (exists priority, crtos_task_placement before task (CSP_READY priority)) \/
        crtos_task_placement before task CSP_RUNNING ->
      crtos_task_placement after task (CSP_SEMAPHORE_PENDING semaphore) ->
      crtos_ready_remove_step task
        before.(crtos_scheduler_state).(crtos_ready_queues)
        after.(crtos_scheduler_state).(crtos_ready_queues) ->
      crtos_scheduler_one_task_frame task
        before.(crtos_scheduler_state) after.(crtos_scheduler_state) ->
      crtos_delay_unset_step task
        before.(crtos_scheduler_state).(crtos_delay_entries)
        after.(crtos_scheduler_state).(crtos_delay_entries) ->
      crtos_task_scheduler_step before after
  | CrtosRuntimeSuspend : forall before after task before_desc after_desc,
      before.(crtos_semaphore_state) = after.(crtos_semaphore_state) ->
      crtos_task_state_one_update task before_desc after_desc
        before.(crtos_task_state) after.(crtos_task_state) ->
      crtos_desc_runtime_write TASK_SUSPEND before_desc.(tdDelay)
        before_desc.(tdExstatus) before_desc after_desc ->
      (exists priority, crtos_task_placement before task (CSP_READY priority)) \/
        crtos_task_placement before task CSP_RUNNING ->
      crtos_task_placement after task CSP_SUSPEND_DETACHED ->
      crtos_ready_remove_step task
        before.(crtos_scheduler_state).(crtos_ready_queues)
        after.(crtos_scheduler_state).(crtos_ready_queues) ->
      crtos_scheduler_one_task_frame task
        before.(crtos_scheduler_state) after.(crtos_scheduler_state) ->
      crtos_delay_unset_step task
        before.(crtos_scheduler_state).(crtos_delay_entries)
        after.(crtos_scheduler_state).(crtos_delay_entries) ->
      crtos_task_scheduler_step before after
  | CrtosRuntimePendingInsert : forall before after task semaphore,
      (exists prefix suffix,
        semaphore_all_pending
          before.(crtos_semaphore_state).(semaphore_objects) = prefix ++ suffix /\
        semaphore_all_pending
          after.(crtos_semaphore_state).(semaphore_objects) =
            prefix ++ task :: suffix) ->
      before.(crtos_task_state) = after.(crtos_task_state) ->
      before.(crtos_scheduler_state) = after.(crtos_scheduler_state) ->
      crtos_task_placement before task CSP_SUSPEND_DETACHED ->
      crtos_task_placement after task (CSP_SEMAPHORE_PENDING semaphore) ->
      crtos_task_scheduler_step before after
  | CrtosRuntimeWake : forall before after task before_desc after_desc semaphore priority,
      (exists prefix suffix,
        semaphore_all_pending
          before.(crtos_semaphore_state).(semaphore_objects) =
            prefix ++ task :: suffix /\
        semaphore_all_pending
          after.(crtos_semaphore_state).(semaphore_objects) = prefix ++ suffix) ->
      crtos_task_state_one_update task before_desc after_desc
        before.(crtos_task_state) after.(crtos_task_state) ->
      crtos_desc_runtime_write TASK_READY before_desc.(tdDelay)
        before_desc.(tdExstatus) before_desc after_desc ->
      crtos_task_placement before task (CSP_SEMAPHORE_PENDING semaphore) ->
      crtos_task_placement after task (CSP_READY priority) ->
      crtos_ready_insert_step task after_desc after.(crtos_task_state)
        before.(crtos_scheduler_state).(crtos_ready_queues)
        after.(crtos_scheduler_state).(crtos_ready_queues) ->
      crtos_scheduler_one_task_frame task
        before.(crtos_scheduler_state) after.(crtos_scheduler_state) ->
      crtos_delay_unset_step task
        before.(crtos_scheduler_state).(crtos_delay_entries)
        after.(crtos_scheduler_state).(crtos_delay_entries) ->
      crtos_task_scheduler_step before after
  | CrtosRuntimeResumeAllWake : forall before after task before_desc after_desc semaphore priority,
      (exists prefix suffix,
        semaphore_all_pending
          before.(crtos_semaphore_state).(semaphore_objects) =
            prefix ++ task :: suffix /\
        semaphore_all_pending
          after.(crtos_semaphore_state).(semaphore_objects) = prefix ++ suffix) ->
      crtos_task_state_one_update task before_desc after_desc
        before.(crtos_task_state) after.(crtos_task_state) ->
      crtos_desc_runtime_write TASK_READY before_desc.(tdDelay) (-1)
        before_desc after_desc ->
      crtos_task_placement before task (CSP_SEMAPHORE_PENDING semaphore) ->
      crtos_task_placement after task (CSP_READY priority) ->
      crtos_ready_insert_step task after_desc after.(crtos_task_state)
        before.(crtos_scheduler_state).(crtos_ready_queues)
        after.(crtos_scheduler_state).(crtos_ready_queues) ->
      crtos_scheduler_one_task_frame task
        before.(crtos_scheduler_state) after.(crtos_scheduler_state) ->
      crtos_delay_unset_step task
        before.(crtos_scheduler_state).(crtos_delay_entries)
        after.(crtos_scheduler_state).(crtos_delay_entries) ->
      crtos_task_scheduler_step before after
  | CrtosRuntimeTimeout : forall before after task before_desc after_desc semaphore priority,
      (exists prefix suffix,
        semaphore_all_pending
          before.(crtos_semaphore_state).(semaphore_objects) =
            prefix ++ task :: suffix /\
        semaphore_all_pending
          after.(crtos_semaphore_state).(semaphore_objects) = prefix ++ suffix) ->
      crtos_task_state_one_update task before_desc after_desc
        before.(crtos_task_state) after.(crtos_task_state) ->
      crtos_desc_runtime_write TASK_READY before_desc.(tdDelay) (-2)
        before_desc after_desc ->
      crtos_task_placement before task (CSP_SEMAPHORE_PENDING semaphore) ->
      crtos_task_placement after task (CSP_READY priority) ->
      crtos_ready_insert_step task after_desc after.(crtos_task_state)
        before.(crtos_scheduler_state).(crtos_ready_queues)
        after.(crtos_scheduler_state).(crtos_ready_queues) ->
      crtos_scheduler_one_task_frame task
        before.(crtos_scheduler_state) after.(crtos_scheduler_state) ->
      crtos_delay_unset_step task
        before.(crtos_scheduler_state).(crtos_delay_entries)
        after.(crtos_scheduler_state).(crtos_delay_entries) ->
      crtos_task_scheduler_step before after
  | CrtosRuntimeDelaySet : forall before after task before_desc after_desc
      placement delay deadline,
      before.(crtos_semaphore_state) = after.(crtos_semaphore_state) ->
      crtos_task_state_one_update task before_desc after_desc
        before.(crtos_task_state) after.(crtos_task_state) ->
      crtos_desc_delay_write delay before_desc after_desc ->
      crtos_nonrunning_placement placement ->
      crtos_task_placement before task placement ->
      crtos_task_placement after task placement ->
      before.(crtos_scheduler_state).(crtos_ready_queues) =
        after.(crtos_scheduler_state).(crtos_ready_queues) ->
      crtos_scheduler_one_task_frame task
        before.(crtos_scheduler_state) after.(crtos_scheduler_state) ->
      crtos_delay_set_step task delay deadline
        before.(crtos_scheduler_state).(crtos_delay_entries)
        after.(crtos_scheduler_state).(crtos_delay_entries) ->
      crtos_task_scheduler_step before after
  | CrtosRuntimeScheduleSwitch : forall before after from to
      from_before from_after to_before to_after from_priority to_priority,
      before.(crtos_semaphore_state) = after.(crtos_semaphore_state) ->
      crtos_task_state_two_updates from to
        from_before from_after to_before to_after
        before.(crtos_task_state) after.(crtos_task_state) ->
      crtos_desc_runtime_write TASK_READY from_before.(tdDelay)
        from_before.(tdExstatus) from_before from_after ->
      crtos_desc_runtime_write TASK_RUNNING to_before.(tdDelay)
        to_before.(tdExstatus) to_before to_after ->
      crtos_task_placement before from CSP_RUNNING ->
      crtos_task_placement before to (CSP_READY to_priority) ->
      crtos_selected_ready_task before.(crtos_scheduler_state) to ->
      to_priority = before.(crtos_scheduler_state).(crtos_highest_prio) ->
      to_priority >= from_before.(tdSchedMember).(tsmCurPrio) ->
      crtos_task_placement after from (CSP_READY from_priority) ->
      crtos_task_placement after to CSP_RUNNING ->
      crtos_ready_switch_step from to from_after after.(crtos_task_state)
        before.(crtos_scheduler_state).(crtos_ready_queues)
        after.(crtos_scheduler_state).(crtos_ready_queues) ->
      after.(crtos_scheduler_state).(crtos_running_task) = Some to ->
      after.(crtos_scheduler_state).(crtos_current_priority) = to_priority ->
      crtos_scheduler_switch_frame from to
        before.(crtos_scheduler_state) after.(crtos_scheduler_state) ->
      crtos_task_scheduler_step before after
  | CrtosRuntimeScheduleBlocked : forall before after blocked to
      to_before to_after blocked_placement to_priority,
      blocked <> to ->
      before.(crtos_semaphore_state) = after.(crtos_semaphore_state) ->
      crtos_task_state_one_update to to_before to_after
        before.(crtos_task_state) after.(crtos_task_state) ->
      crtos_desc_runtime_write TASK_RUNNING to_before.(tdDelay)
        to_before.(tdExstatus) to_before to_after ->
      before.(crtos_scheduler_state).(crtos_running_task) = Some blocked ->
      crtos_nonrunning_placement blocked_placement ->
      crtos_task_placement before blocked blocked_placement ->
      crtos_task_placement after blocked blocked_placement ->
      crtos_task_placement before to (CSP_READY to_priority) ->
      crtos_selected_ready_task before.(crtos_scheduler_state) to ->
      to_priority = before.(crtos_scheduler_state).(crtos_highest_prio) ->
      crtos_task_placement after to CSP_RUNNING ->
      crtos_ready_remove_step to
        before.(crtos_scheduler_state).(crtos_ready_queues)
        after.(crtos_scheduler_state).(crtos_ready_queues) ->
      after.(crtos_scheduler_state).(crtos_running_task) = Some to ->
      after.(crtos_scheduler_state).(crtos_current_priority) = to_priority ->
      crtos_scheduler_switch_frame blocked to
        before.(crtos_scheduler_state) after.(crtos_scheduler_state) ->
      crtos_task_scheduler_step before after.

(**
  一次 OS 原子提交同时约束 task/scheduler/semaphore。它保留 Task create
  reservation，semaphore 分量至多执行一个真实 atomic step，并要求两端都能
  重建唯一 sched_link owner。pending 改变被限制为一次插入或删除。
*)
Inductive crtos_os_atomic_step (stable : CrtosOSStable) :
    CrtosOSWorld -> CrtosOSWorld -> Prop :=
  | CrtosOSStep : forall before after,
      all_reservations_stable
        before.(crtos_task_state) after.(crtos_task_state) ->
      crtos_semaphore_single_step stable.(crtos_semaphore_stable)
        before.(crtos_semaphore_state) after.(crtos_semaphore_state) ->
      crtos_task_scheduler_step before after ->
      semaphore_pending_delta before after ->
      crtos_os_world_wf stable before ->
      crtos_os_world_wf stable after ->
      crtos_os_atomic_step stable before after.

(**
  成功 KTaskWakeup 的组合接口：调用前 task 已满足 wrapper dispatch、SUSPEND
  与 ready metadata 前提；提交时从一个 pending 位置删除并进入统一 OS step。
*)
Definition crtos_wakeup_step
    (stable : CrtosOSStable)
    (before after : CrtosOSWorld) (task : addr) : Prop :=
  crtos_pending_task_wake_ready stable before task /\
  exists prefix suffix,
    semaphore_all_pending before.(crtos_semaphore_state).(semaphore_objects) =
      prefix ++ task :: suffix /\
    semaphore_all_pending after.(crtos_semaphore_state).(semaphore_objects) =
      prefix ++ suffix /\
    crtos_os_atomic_step stable before after.

Lemma crtos_wakeup_step_progress :
  forall stable before after task,
    crtos_wakeup_step stable before after task ->
    semaphore_pending_measure after + 1 = semaphore_pending_measure before.
Proof.
  intros stable before after task [_ [prefix [suffix [Hbefore [Hafter _]]]]].
  eapply semaphore_pending_removed_progress; eauto.
Qed.

Definition CrtosOSGTrans (stable : CrtosOSStable)
    (before after : CrtosOSWorld) : Prop :=
  @clos_refl_trans CrtosOSWorld (crtos_os_atomic_step stable) before after.

Definition CrtosOSRTrans := CrtosOSGTrans.

Lemma CrtosOSGTrans_refl :
  forall stable world, CrtosOSGTrans stable world world.
Proof.
  intros. apply rt_refl.
Qed.

(** 任意普通 OS rely/guarantee 步骤都保持现有 Task create reservations。 *)
Lemma CrtosOSGTrans_reservations_stable :
  forall stable before after,
    CrtosOSGTrans stable before after ->
    all_reservations_stable
      before.(crtos_task_state) after.(crtos_task_state).
Proof.
  intros stable before after Hsteps.
  induction Hsteps.
  - inversion H; subst. assumption.
  - intros owner. tauto.
  - intros owner. specialize (IHHsteps1 owner). specialize (IHHsteps2 owner).
    tauto.
Qed.
