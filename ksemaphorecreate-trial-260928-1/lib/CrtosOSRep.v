Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Strings.String.
Require Import Coq.Sorting.Permutation.
From AUXLib Require Import ListLib.
From SimpleC.SL Require Import Mem CNotation.
Require Import Logic.LogicGenerator.demo932.Interface.

Require Import CRTOS_Verify.lib.idnode_abs.
Require Import CRTOS_Verify.lib.KTaskPure.
Require Import CRTOS_Verify.lib.CrtosGlobState.
Require Import CRTOS_Verify.sem.CrtosOSPure.
Require Import CRTOS_Verify.sem.CrtosOSProtocol.
Require Import CRTOS_Verify.sem.SemaphoreRep.

Import ListNotations.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

(**
  本文件把现有 Task pure state 解释到统一 OS carrier。它没有 import
  [CrtosInv] 的旧 Task carrier，也不使用其 event 双字段布局；真实 Cortex-M3
  ABI 的 event bitfield 在 offset 84 只占一个 [UInt]。
*)

(** 现有 [StableGlobalState] 在批准配置下与真实 Task 全局对象的对应。 *)
Definition CrtosTaskStableContext (stable : StableGlobalState) : Prop :=
  stable.(task_idmanager_ptr) = &("k_task_id_manager") /\
  stable.(task_list_head) = &("xiaoshan_task_head") /\
  stable.(task_done_ptr) = &("Done") /\
  stable.(stable_idmanager_abs).(idmax) = 128 /\
  stable.(stable_idmanager_abs).(hoffset) = 16 /\
  stable.(stable_idmanager_abs).(id_map) =
    &("__id_map_k_task_id_manager") /\
  stable.(stable_idmanager_abs).(htable) =
    &("__htable_k_task_id_manager") /\
  stable.(task_done_abs).(task_done_init) = &("_InitKTask") /\
  stable.(task_done_abs).(task_done_start) = &("_StartupKTask") /\
  stable.(task_done_abs).(task_done_delete) = &("_DeleteKTask") /\
  stable.(task_done_abs).(task_done_delay) = &("_DelayKTask") /\
  stable.(task_done_abs).(task_done_mdelay) = &("_MdelayKTask") /\
  stable.(task_done_abs).(task_done_prioset) = &("_KTaskPrioSet") /\
  stable.(task_done_abs).(task_done_suspend) = &("_SuspendKTask") /\
  stable.(task_done_abs).(task_done_wake) = &("_KTaskWakeup").

(**
  全局 [struct KTaskDone Done] 的八个稳定函数指针槽。SuspendKTask/KTaskWakeup
  的真实 wrapper 会先经 task->Done 再读取 suspend/wake；本资源只出现一次，
  不随每个 descriptor 复制。
*)
Definition store_crtos_task_done (stable : StableGlobalState) : Assertion :=
  let table := stable.(task_done_ptr) in
  let done := stable.(task_done_abs) in
  &(table # "KTaskDone" ->ₛ "init") # Ptr |-> done.(task_done_init) **
  &(table # "KTaskDone" ->ₛ "start") # Ptr |-> done.(task_done_start) **
  &(table # "KTaskDone" ->ₛ "Delete") # Ptr |-> done.(task_done_delete) **
  &(table # "KTaskDone" ->ₛ "delay") # Ptr |-> done.(task_done_delay) **
  &(table # "KTaskDone" ->ₛ "mdelay") # Ptr |-> done.(task_done_mdelay) **
  &(table # "KTaskDone" ->ₛ "prioset") # Ptr |-> done.(task_done_prioset) **
  &(table # "KTaskDone" ->ₛ "suspend") # Ptr |-> done.(task_done_suspend) **
  &(table # "KTaskDone" ->ₛ "wake") # Ptr |-> done.(task_done_wake).

(** 当前非 SMP scheduler policy table 的稳定地址与三个唯一 dispatch。 *)
Definition CrtosSchedulerStableContext
    (scheduler : CrtosSchedulerState) : Prop :=
  scheduler.(crtos_ready_vector_done) = &("SingleReadyVectorDone").

Definition store_crtos_ready_vector_done
    (scheduler : CrtosSchedulerState) : Assertion :=
  let table := scheduler.(crtos_ready_vector_done) in
  &(table # "PriorityReadyVectorDone" ->ₛ "init") # Ptr
    |-> &("OsAssignReadyVectorInit") **
  &(table # "PriorityReadyVectorDone" ->ₛ "insert") # Ptr
    |-> &("KTaskInsertToReadyVector") **
  &(table # "PriorityReadyVectorDone" ->ₛ "remove") # Ptr
    |-> &("KTaskOsAssignRemoveKTask").

(** 当前批准的 32 位、非 SMP、event-enabled TaskDescriptor ABI。 *)
Definition crtos_task_layout_32_ok (task : addr) : Prop :=
  sizeof("TaskDescriptor") = 116 /\
  &(task # "TaskDescriptor" ->ₛ "stack_point") = task /\
  &(task # "TaskDescriptor" ->ₛ
      "task_dync_sched_member" .ₛ "sched_link") = task + 16 /\
  &(task # "TaskDescriptor" ->ₛ
      "task_dync_sched_member" .ₛ "delay") = task + 28 /\
  &(task # "TaskDescriptor" ->ₛ "task_base_info") = task + 32 /\
  &(task # "TaskDescriptor" ->ₛ "exstatus") = task + 88 /\
  &(task # "TaskDescriptor" ->ₛ "link") = task + 92 /\
  &(task # "TaskDescriptor" ->ₛ "id") = task + 100 /\
  &(task # "TaskDescriptor" ->ₛ "Done") = task + 112.

Definition crtos_task_event_word (desc : TaskDescriptorAbs) : Z :=
  Z.land desc.(tdEventIdTrigger) 536870911 +
  Z.shiftl (Z.land desc.(tdEventMode) 7) 29.

Definition store_crtos_task_name
    (task : addr) (name : list Z) : Assertion :=
  “ Zlength name <= 32 ” &&
  CharArray.full
    (&(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "name"))
    32 (name ++ repeat_Z 0 (32 - Zlength name)).

(**
  descriptor 主体拥有 semaphore 路径可能读取/更新的 status、priority、delay、
  exstatus，以及所有未触达但必须 frame 的普通字段。三个 intrusive links
  (sched/link/id.link) 均排除，由各自容器唯一拥有。
*)
Definition store_crtos_task_body
    (task : addr) (desc : TaskDescriptorAbs) : Assertion :=
  let sched := desc.(tdSchedMember) in
  let base := desc.(tdBaseInfo) in
  “ task <> 0 /\ crtos_task_layout_32_ok task /\
    0 <= desc.(tdEventIdTrigger) < 536870912 /\
    0 <= desc.(tdEventMode) < 8 ” &&
  &(task # "TaskDescriptor" ->ₛ "stack_point") # Ptr
    |-> desc.(tdStackPoint) **
  &(task # "TaskDescriptor" ->ₛ
      "task_dync_sched_member" .ₛ "stat") # UChar |-> sched.(tsmStat) **
  &(task # "TaskDescriptor" ->ₛ
      "task_dync_sched_member" .ₛ "advance_cnt") # UChar
    |-> sched.(tsmAdvanceCnt) **
  &(task # "TaskDescriptor" ->ₛ
      "task_dync_sched_member" .ₛ "cur_prio") # UChar
    |-> sched.(tsmCurPrio) **
  CharArray.full (task + 7) 1 (repeat_Z 0 1) **
  &(task # "TaskDescriptor" ->ₛ
      "task_dync_sched_member" .ₛ "origin_timeslice") # UInt
    |-> sched.(tsmOriginTimeslice) **
  &(task # "TaskDescriptor" ->ₛ
      "task_dync_sched_member" .ₛ "rest_timeslice") # UInt
    |-> sched.(tsmRestTimeslice) **
  &(task # "TaskDescriptor" ->ₛ
      "task_dync_sched_member" .ₛ "bitmap_column") # UInt
    |-> sched.(tsmBitmapColumn) **
  &(task # "TaskDescriptor" ->ₛ
      "task_dync_sched_member" .ₛ "delay") # Ptr |-> desc.(tdDelay) **
  store_crtos_task_name task base.(tbName) **
  &(task # "TaskDescriptor" ->ₛ
      "task_base_info" .ₛ "func_entry") # Ptr |-> base.(tbFuncEntry) **
  &(task # "TaskDescriptor" ->ₛ
      "task_base_info" .ₛ "func_param") # Ptr |-> base.(tbFuncParam) **
  &(task # "TaskDescriptor" ->ₛ
      "task_base_info" .ₛ "origin_prio") # UChar |-> base.(tbOriginPrio) **
  CharArray.full (task + 73) 3 (repeat_Z 0 3) **
  &(task # "TaskDescriptor" ->ₛ
      "task_base_info" .ₛ "stack_depth") # UInt |-> base.(tbStackDepth) **
  &(task # "TaskDescriptor" ->ₛ
      "task_base_info" .ₛ "stack_start") # Ptr |-> base.(tbStackStart) **
  (task + 84) # UInt |-> crtos_task_event_word desc **
  &(task # "TaskDescriptor" ->ₛ "exstatus") # Int |-> desc.(tdExstatus) **
  &(task # "TaskDescriptor" ->ₛ "Done") # Ptr |-> desc.(tdDone).

(** semaphore 不解释 live stack 内容；它仍线性拥有整个外部分配区作为 frame。 *)
Definition store_crtos_task_stack_frame (desc : TaskDescriptorAbs) : Assertion :=
  EX bytes : list Z,
    “ 0 < desc.(tdBaseInfo).(tbStackDepth) /\
      Zlength bytes = desc.(tdBaseInfo).(tbStackDepth) ” &&
    UCharArray.full desc.(tdBaseInfo).(tbStackStart)
      desc.(tdBaseInfo).(tbStackDepth) bytes.

Definition crtos_task_sched_link (task : addr) : addr :=
  &(task # "TaskDescriptor" ->ₛ
    "task_dync_sched_member" .ₛ "sched_link").

(** INIT/RUNNING 的 sched_link 是 detached self-loop；容器状态在本 cell 为 emp。 *)
Definition store_crtos_local_sched_link
    (task : addr) (placement : CrtosSchedPlacement) : Assertion :=
  match placement with
  | CSP_INIT =>
      store_sem_dll (fun _ (_ : unit) => emp)
        (crtos_task_sched_link task) nil
  | CSP_RUNNING =>
      store_sem_dll (fun _ (_ : unit) => emp)
        (crtos_task_sched_link task) nil
  | CSP_SUSPEND_DETACHED =>
      store_sem_dll (fun _ (_ : unit) => emp)
        (crtos_task_sched_link task) nil
  | _ => emp
  end.

(** 一个已发布 task map cell；placement 决定 sched_link 是否留在 cell。 *)
Definition store_crtos_published_task
    (world : CrtosOSWorld) (task : addr) (desc : TaskDescriptorAbs) : Assertion :=
  EX placement : CrtosSchedPlacement,
    “ crtos_task_placement world task placement ” &&
    store_crtos_task_body task desc **
    store_crtos_task_stack_frame desc **
    store_crtos_local_sched_link task placement.

Definition store_crtos_task_desc_map (world : CrtosOSWorld) : Assertion :=
  store_map (store_crtos_published_task world)
    world.(crtos_task_state).(task_desc_map).

(** Task 全局注册 DLL；payload 不重复拥有 descriptor 或 ID node。 *)
Definition crtos_task_registry_node (task : addr) : SemDLNode unit :=
  Build_SemDLNode tt (&(task # "TaskDescriptor" ->ₛ "link")).

Definition store_crtos_task_registry
    (stable : StableGlobalState) (state : VarGlobalState) : Assertion :=
  store_sem_dll (fun _ (_ : unit) => emp) stable.(task_list_head)
    (map crtos_task_registry_node state.(task_ptr_list)).

(** 下列定义在统一 carrier 中重建 Task ID manager，不导入旧 Task_C_Rules。 *)
Definition crtos_id_in (ids : list Z) (id : Z) : bool :=
  if in_dec Z.eq_dec id ids then true else false.

Definition crtos_idnode_ids (nodes : list IdNodeAbs) : list Z :=
  map idnode_id nodes.

Definition crtos_idlist_ok (limit : Z) (ids : list Z) : Prop :=
  Forall (fun id => 0 <= id < limit) ids /\ NoDup ids.

Fixpoint crtos_idbuckets_index_ok
    (count index : Z) (buckets : list (list IdNodeAbs)) : Prop :=
  match buckets with
  | nil => True
  | nodes :: rest =>
      Forall (fun node => node.(idnode_id) mod count = index) nodes /\
      crtos_idbuckets_index_ok count (index + 1) rest
  end.

Definition crtos_idbuckets_ok
    (stable : StableIdmanager) (state : VarIdmanager) : Prop :=
  0 < stable.(hoffset) /\
  Zlength state.(idbuckets) = stable.(hoffset) /\
  crtos_idlist_ok stable.(idmax) state.(idlist) /\
  Forall
    (fun nodes =>
      crtos_idlist_ok stable.(idmax) (crtos_idnode_ids nodes) /\
      Forall (fun node => node.(idnode_addr) <> 0) nodes)
    state.(idbuckets) /\
  crtos_idbuckets_index_ok stable.(hoffset) 0 state.(idbuckets) /\
  Permutation (crtos_idnode_ids (List.concat state.(idbuckets))) state.(idlist).

Definition crtos_task_bitmap_ok
    (stable : StableIdmanager) (state : VarIdmanager) (bytes : list Z) : Prop :=
  0 <= stable.(idmax) <= 65535 /\
  Zlength bytes = (stable.(idmax) + 7) / 8 /\
  Forall (fun byte => 0 <= byte <= 255) bytes /\
  forall id, 0 <= id < stable.(idmax) ->
    Z.testbit (Znth (id / 8) bytes 0) (id mod 8) =
      crtos_id_in state.(idlist) id.

Definition crtos_task_id_node (node : IdNodeAbs) : SemDLNode IdNodeAbs :=
  let p := node.(idnode_addr) in
  Build_SemDLNode node (&(p # "IdNode" ->ₛ "link")).

(** ID bucket payload owns id 与真实 2-byte padding；DLL spine owns link。 *)
Definition store_crtos_task_id_payload
    (link : addr) (node : IdNodeAbs) : Assertion :=
  let idnode := node.(idnode_addr) in
  “ idnode <> 0 /\ link = &(idnode # "IdNode" ->ₛ "link") ” &&
  &(idnode # "IdNode" ->ₛ "id") # UShort |-> node.(idnode_id) **
  CharArray.full (idnode + 2) 2 (repeat_Z 0 2).

Definition store_crtos_task_id_bucket
    (head : addr) (nodes : list IdNodeAbs) : Assertion :=
  match nodes with
  | nil =>
      store_sem_dll store_crtos_task_id_payload head nil ||
      store_sem_uninitialized_bucket head
  | _ =>
      store_sem_dll store_crtos_task_id_payload head
        (map crtos_task_id_node nodes)
  end.

Fixpoint store_crtos_task_id_buckets
    (base : addr) (index : Z) (buckets : list (list IdNodeAbs)) : Assertion :=
  match buckets with
  | nil => emp
  | nodes :: rest =>
      store_crtos_task_id_bucket
        (base + index * sizeof("SysDoubleLinklistNode")) nodes **
      store_crtos_task_id_buckets base (index + 1) rest
  end.

Definition store_crtos_task_id_manager
    (stable : StableGlobalState) (state : VarGlobalState) : Assertion :=
  let manager := stable.(task_idmanager_ptr) in
  let fixed := stable.(stable_idmanager_abs) in
  let current := state.(task_idmanager_abs) in
  EX bytes : list Z,
    “ crtos_task_bitmap_ok fixed current bytes /\
      crtos_idbuckets_ok fixed current ” &&
    &(manager # "IdManager" ->ₛ "id_max") # UShort |-> fixed.(idmax) **
    &(manager # "IdManager" ->ₛ "hoffset") # UShort |-> fixed.(hoffset) **
    &(manager # "IdManager" ->ₛ "id_map") # Ptr |-> fixed.(id_map) **
    UCharArray.full fixed.(id_map) ((fixed.(idmax) + 7) / 8) bytes **
    &(manager # "IdManager" ->ₛ "htable") # Ptr |-> fixed.(htable) **
    store_crtos_task_id_buckets fixed.(htable) 0 current.(idbuckets).

Definition crtos_ready_head (priority : Z) : addr :=
  let assign := &("Assign") in
  &(assign # "Assign" ->ₛ
      "os_assign_ready_vector" .ₛ "priority_ready_vector") +
    priority * sizeof("SysDoubleLinklistNode").

Definition crtos_ready_nodes (tasks : list addr) : list (SemDLNode unit) :=
  map (fun task => Build_SemDLNode tt (crtos_task_sched_link task)) tasks.

Fixpoint store_crtos_ready_queues_from
    (priority : Z) (queues : list (list addr)) : Assertion :=
  match queues with
  | nil => emp
  | tasks :: rest =>
      store_sem_dll (fun _ (_ : unit) => emp)
        (crtos_ready_head priority) (crtos_ready_nodes tasks) **
      store_crtos_ready_queues_from (priority + 1) rest
  end.

(** mutex/event/queue 等公共等待链表的 heads 与 sched_link spines。 *)
Definition crtos_wait_nodes (tasks : list addr) : list (SemDLNode unit) :=
  map (fun task => Build_SemDLNode tt (crtos_task_sched_link task)) tasks.

Fixpoint store_crtos_external_wait_queues
    (queues : list CrtosWaitQueue) : Assertion :=
  match queues with
  | nil => emp
  | queue :: rest =>
      store_sem_dll (fun _ (_ : unit) => emp)
        queue.(crtos_wait_head) (crtos_wait_nodes queue.(crtos_wait_tasks)) **
      store_crtos_external_wait_queues rest
  end.

(** CLOSED task 的 sched_link 由全局 KTaskZombie DLL 唯一拥有。 *)
Definition store_crtos_zombie_queue (tasks : list addr) : Assertion :=
  store_sem_dll (fun _ (_ : unit) => emp) &("KTaskZombie")
    (crtos_wait_nodes tasks).

(** 非 SMP Assign 的 ready heads、bitmap metadata、running slot 与 policy pointer。 *)
Definition store_crtos_scheduler
    (scheduler : CrtosSchedulerState) : Assertion :=
  let assign := &("Assign") in
  store_crtos_ready_queues_from 0 scheduler.(crtos_ready_queues) **
  &(assign # "Assign" ->ₛ
      "os_assign_ready_vector" .ₛ "priority_ready_group") # UInt
    |-> scheduler.(crtos_ready_group) **
  &(assign # "Assign" ->ₛ
      "os_assign_ready_vector" .ₛ "highest_prio") # UInt
    |-> scheduler.(crtos_highest_prio) **
  &(assign # "Assign" ->ₛ "os_running_task") # Ptr
    |-> match scheduler.(crtos_running_task) with
        | None => 0 | Some task => task end **
  &(assign # "Assign" ->ₛ "ready_vector_done") # Ptr
    |-> scheduler.(crtos_ready_vector_done) **
  &(assign # "Assign" ->ₛ "current_priority") # UChar
    |-> scheduler.(crtos_current_priority).

Definition store_crtos_delay_payload
    (link : addr) (delay : CrtosDelayAbs) : Assertion :=
  let p := delay.(crtos_delay_addr) in
  “ p <> 0 /\ link = &(p # "Delay" ->ₛ "link") ” &&
  &(p # "Delay" ->ₛ "task") # Ptr |-> delay.(crtos_delay_task) **
  &(p # "Delay" ->ₛ "ticks") # UInt |-> delay.(crtos_delay_ticks) **
  &(p # "Delay" ->ₛ "status") # UChar
    |-> (if delay.(crtos_delay_active) then 1 else 0) **
  CharArray.full (p + 9) 3 (repeat_Z 0 3).

Definition crtos_delay_node (delay : CrtosDelayAbs) : SemDLNode CrtosDelayAbs :=
  let p := delay.(crtos_delay_addr) in
  Build_SemDLNode delay (&(p # "Delay" ->ₛ "link")).

Fixpoint store_crtos_inactive_delays (delays : list CrtosDelayAbs) : Assertion :=
  match delays with
  | nil => emp
  | delay :: rest =>
      (if delay.(crtos_delay_active) then emp else
         let p := delay.(crtos_delay_addr) in
         store_crtos_delay_payload
           (&(p # "Delay" ->ₛ "link")) delay **
         store_sem_dll (fun _ (_ : unit) => emp)
           (&(p # "Delay" ->ₛ "link")) nil) **
      store_crtos_inactive_delays rest
  end.

(** active Delay links belong to xiaoshan_delay_head；inactive links are self-loops。 *)
Definition store_crtos_delays (scheduler : CrtosSchedulerState) : Assertion :=
  let active := filter crtos_delay_active scheduler.(crtos_delay_entries) in
  store_sem_dll store_crtos_delay_payload &("xiaoshan_delay_head")
    (map crtos_delay_node active) **
  store_crtos_inactive_delays scheduler.(crtos_delay_entries).

(**
  Semaphore 验证切片的共享 invariant。task manager/descriptor、全部 sched_link
  placements、ready/external/zombie/delay 与 semaphore 字节均在同一
  [CrtosOS_C_Rules] carrier 中唯一拥有。
*)
Definition crtos_semaphore_os_inv
    (stable : CrtosOSStable) (world : CrtosOSWorld) : Assertion :=
  “ CrtosTaskStableContext stable.(crtos_task_stable) /\
    CrtosSchedulerStableContext world.(crtos_scheduler_state) /\
    crtos_os_world_wf stable world ” &&
  store_crtos_task_done stable.(crtos_task_stable) **
  store_crtos_ready_vector_done world.(crtos_scheduler_state) **
  store_crtos_task_id_manager stable.(crtos_task_stable)
    world.(crtos_task_state) **
  store_crtos_task_registry stable.(crtos_task_stable)
    world.(crtos_task_state) **
  store_crtos_task_desc_map world **
  store_crtos_scheduler world.(crtos_scheduler_state) **
  store_crtos_external_wait_queues
    world.(crtos_scheduler_state).(crtos_external_wait_queues) **
  store_crtos_zombie_queue
    world.(crtos_scheduler_state).(crtos_zombie_tasks) **
  store_crtos_delays world.(crtos_scheduler_state) **
  semaphore_inv stable.(crtos_semaphore_stable)
    world.(crtos_semaphore_state).
