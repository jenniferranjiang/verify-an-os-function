Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic CNotation.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.CrtosInv.
From MonadLib.MonadErr Require Export MonadErrBasic monadesafe_lib.
Import KTaskCNotation ListNotations IDNode DLL MonadErr.
Local Open Scope Z_scope.
Local Open Scope sac.
Local Open Scope string.

(** 锁内创建失败返回-ENOMEMORY=-5且模块不变；复用IdInsertObj规格不保证
    失败必然容量满。成功选择最小空闲ID，发布options低3位/events=0/空等待链
    的新对象，并保持其他所有OS分量。地址新鲜性由malloc分离所有权支持。 *)
Definition abs_event_create_locked (sg : StableGlobalState) (options : Z)
    : program VarGlobalState Z :=
  {| nrm := fun before result after =>
       let sidm := sg.(os_event_stable).(event_manager_stable) in
       let idm := event_manager before.(os_events) in
       (result = -5 /\ after = before) \/
       (exists p,
         p <> 0 /\ addr_aligned p 4 /\
         ~ In p (map event_addr before.(os_events)) /\
         idmanager_min_free_id sidm idm result /\
         after = replace_events
           (event_publish p result options before.(os_events)) before);
     err := fun _ => False |}.

(** malloc失败在锁外直接返回；其余路径执行一次原子创建。
    LastSeen允许进入临界区前环境推进，不能断言入口/返回状态相等，亦不保证
    解锁后对象仍存在；操作自身的效果由锁内关系明确约束。 *)
Definition abs_event_create (sg : StableGlobalState) (options : Z)
    : program (VarGlobalState -> Prop) Z :=
  choice (MonadErr.ret (-5))
    (task_atomic_cmd (abs_event_create_locked sg options)).

(** Create 借出 event_inv 后留下的精确资源：既有全局良构事实与全部其他
    模块、任务字段和队列仍由本 frame 唯一持有。新对象pending为空，因此
    发布不增加任何调度节点所有者；恢复义务在下面显式陈述。 *)
Definition event_create_frame (sg : StableGlobalState) (st : VarGlobalState)
    : Assertion :=
  let wait := pure_suspend_sched_link st.(os_tasks).(task_desc_map) in
  “ os_world_wf sg st ” &&
  task_inv sg st ** tick_inv sg st ** delay_inv sg st ** assign_inv sg st **
  store_prio_lookup_table **
  store_zombie_queue st.(os_tasks).(task_desc_map)
    sg.(os_zombie_head) st.(zombie_queue) **
  sg.(os_recycler_slot) # Int |-> st.(os_recycle).(service_id) **
  IntArray.full sg.(os_idle_array) CORE_COUNT (map service_id st.(os_idle)) **
  isrmanager_inv sg.(os_isr_stable) st.(os_isr) ** exstatus_inv sg st **
  semaphore_inv wait sg.(os_semaphore_stable) st.(os_semaphores) **
  mutex_inv wait sg.(os_mutex_stable) st.(os_mutexes).

(** 待证的拆出接口；Definition只保存命题，不提供证明事实。 *)
Definition event_create_split_obligation : Prop :=
  forall sg before,
    os_inv sg before |--
    event_create_frame sg before **
    event_inv (pure_suspend_sched_link before.(os_tasks).(task_desc_map))
      sg.(os_event_stable) before.(os_events).

(** ID头插和管理链头插的纯一致性义务；不创建第二份manager状态。 *)
Definition event_publish_manager_obligation : Prop :=
  forall sg before p id options,
    event_context sg ->
    idmanager_min_free_id sg.(event_manager_stable) (event_manager before) id ->
    event_manager (event_publish p id options before) =
      idmanager_link sg.(event_manager_stable)
        (idmanager_add (event_manager before) id) id (&(p # "Event" ->ₛ "id")).

(** 新建事件等待链为空，故所有调度节点的唯一归属和覆盖完全不变。
    该命题仅陈述需要证明的纯关联，不借助新不变量假设排除创建输入。 *)
Definition event_publish_world_obligation : Prop :=
  forall sg before p id options,
    os_world_wf sg before ->
    os_world_wf sg (replace_events
      (event_publish p id options before.(os_events)) before).

(** 完成两个容器头插后，以更新后的事件模块恢复系统资源。所有其他模块
    从精确frame返还；ID/管理link不再留给调用者。布局/字节及ID/DLL操作
    各自还有明确待证义务，本陈述不冒充已完成的C实现证明。 *)
Definition event_create_restore_obligation : Prop :=
  forall sg before p id options,
    idmanager_min_free_id sg.(os_event_stable).(event_manager_stable)
      (event_manager before.(os_events)) id ->
    event_create_frame sg before **
    store_idmanager sg.(os_event_stable).(event_manager_stable)
      (idmanager_link sg.(os_event_stable).(event_manager_stable)
        (idmanager_add (event_manager before.(os_events)) id) id
        (&(p # "Event" ->ₛ "id"))) sg.(os_event_stable).(event_manager_ptr) **
    store_dll
      (store_event (pure_suspend_sched_link before.(os_tasks).(task_desc_map)))
      sg.(os_event_stable).(event_list_head)
      (map event_link_node (event_publish p id options before.(os_events)))
    |-- os_inv sg (replace_events
      (event_publish p id options before.(os_events)) before).

Check @safeExec.
Check LastSeen.
Check abs_event_create.
Check EventRaw.
Check EventZero.
