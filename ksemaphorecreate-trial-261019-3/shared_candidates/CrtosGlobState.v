(** OS 总状态及跨模块组合；模块类型和上下文由各 State 文件提供。 *)
Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem CNotation.
Require Export CRTOS_Verify.lib.TaskState CRTOS_Verify.lib.AssignState.
Require Export CRTOS_Verify.lib.DelayState CRTOS_Verify.lib.MutexState.
Require Export CRTOS_Verify.lib.EventState CRTOS_Verify.lib.MsgQueueState.
Require Export CRTOS_Verify.lib.IsrState.
Require Export TrialShared.SemaphoreState.
Import KTaskCNotation ListNotations.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope list.

(** 各子系统稳定上下文分组保存；每个翻译单元的静态回调表仍各自独立。 *)
Record StableGlobalState : Type := {
  os_semaphore_stable : SemaphoreStable;
  os_task_stable : TaskStable;
  os_tick_ptr : addr;
  delay_head_ptr : addr;
  os_assign_stable : AssignStable;
  os_mutex_stable : MutexStable;
  os_msgqueue_stable : MsgQueueStable;
  os_event_stable : EventStable;
  os_isr_stable : IsrStable;
  os_zombie_head : addr;
  os_recycler_slot : addr;
  os_idle_array : addr;
  os_exstatus_slot : addr;
  os_recycler_entry : addr;
  os_idle_entry : addr;
}.

(** os_tasks 内唯一 task_desc_map 保存全部任务字段；os_delays 保存 Delay
    分区。zombie_queue 保存 CLOSE 链，os_recycle/os_idle 保存真实全局 ID 槽。
    os_exstatus 对应独立 __exstatus；msg_buf 内容按审阅决定暂不建模。 *)
(** 当前全局状态只描述 OS 数据；硬件中断状态及其保存、恢复不在本次建模范围。
    临界区内外的资源交接由 CrtosRules 中的抽象协议描述。 *)
Record VarGlobalState : Type := Build_VarGlobalState {
  os_semaphores : SemaphoreState;
  os_tasks : TaskState;
  os_tick : Z;
  os_delays : DelayState;
  os_assign : VarAssignAbs;
  zombie_queue : ZombieQueueAbs;
  os_recycle : RoleSlotAbs;
  os_idle : list RoleSlotAbs;
  os_mutexes : MutexState;
  os_msgqueues : MsgQueueState;
  os_events : EventState;
  os_isr : IsrAbs;
  os_exstatus : Z;
}.

(**
  公开全局根与真实 C 符号相联系；static done 的 TU 地址仍由各 Stable
  参数分别保存，接入对应翻译单元时再建立链接关系。此 Prop 不拥有内存。
*)
Definition os_global_context (sg : StableGlobalState) : Prop :=
  semaphore_context sg.(os_semaphore_stable) /\
  task_context sg.(os_task_stable) /\
  sg.(os_tick_ptr) = &("heartbeat_ticks") /\
  sg.(delay_head_ptr) = &("xiaoshan_delay_head") /\
  assign_context sg.(os_assign_stable) /\
  mutex_context sg.(os_mutex_stable) /\
  msgqueue_context sg.(os_msgqueue_stable) /\
  event_context sg.(os_event_stable) /\
  IsrGlobalContext sg.(os_isr_stable) /\
  sg.(os_zombie_head) = &("KTaskZombie") /\
  sg.(os_recycler_slot) = &("zombie_recycle") /\
  sg.(os_idle_array) = &("idle") /\
  sg.(os_exstatus_slot) = &("__exstatus") /\
  sg.(os_recycler_entry) = &("ZombieKTaskEntry") /\
  sg.(os_idle_entry) = &("IdleKTaskEntry").

(** 汇总 ID manager 各哈希桶中的抽象 ID 节点。 *)
Definition task_id_nodes (st : VarGlobalState) : list IdNodeAbs :=
  List.concat st.(os_tasks).(task_idmanager_abs).(idbuckets).

(**
  [replace_id_manager new_manager before] 只替换 ID 管理器抽象值，
  保持任务管理链表不变。不可变 [Done] 状态位于单独的
  [StableGlobalState]，不受该更新影响。
*)
Definition replace_id_manager
    (new_manager : VarIdmanager)
    (before : VarGlobalState) : VarGlobalState :=
  {|
    os_tasks := {|
      task_idmanager_abs := new_manager;
      task_ptr_list := before.(os_tasks).(task_ptr_list);
      task_desc_map := before.(os_tasks).(task_desc_map);
      sched_owned_tasks := before.(os_tasks).(sched_owned_tasks);
    |};
    os_tick := before.(os_tick);
    os_delays := before.(os_delays);
    os_assign := before.(os_assign);
    zombie_queue := before.(zombie_queue);
    os_recycle := before.(os_recycle);
    os_idle := before.(os_idle);
    os_mutexes := before.(os_mutexes);
    os_msgqueues := before.(os_msgqueues);
    os_events := before.(os_events);
    os_isr := before.(os_isr);
    os_semaphores := before.(os_semaphores);
    os_exstatus := before.(os_exstatus);
  |}.

(**
  [update_task_id_map ids before] 替换 ID 管理器中的已分配 ID 列表，
  保持 [idmax]、[hoffset] 和哈希桶不变。

  这是描述 [AllocId]/[FreeId] 局部中间状态的辅助函数。单独更新位图
  后，ID 列表与哈希桶可能暂时不满足 [idbuckets_ok]；只有在后续
  哈希桶更新也完成并重新满足 shared 中的合法性条件后，才应折叠回
  完整 [store_idmanager]。
*)
Definition update_task_id_bitmap
    (ids : list Z)
    (before : VarGlobalState) : VarGlobalState :=
  let idm := before.(os_tasks).(task_idmanager_abs) in
  replace_id_manager
    (Build_VarIdmanager ids idm.(idbuckets))
    before.

(**
  [update_task_htable buckets before] 替换 ID 管理器中的哈希桶内容，
  保持 [idmax]、[hoffset] 和已分配 ID 列表不变。

  与 [update_task_id_map] 一样，该函数可以表示内部函数之间的局部
  中间状态；完整临界区操作提交前仍需恢复 [store_idmanager] 所要求
  的位图、ID 列表和桶内容一致性。
*)
Definition update_task_htable
    (buckets : list (list IdNodeAbs))
    (before : VarGlobalState) : VarGlobalState :=
  let idm := before.(os_tasks).(task_idmanager_abs) in
  replace_id_manager
    (Build_VarIdmanager idm.(idlist) buckets)
    before.

(** 只替换权威任务地址顺序；物理 DLL 节点由 [task_link_nodes] 派生。 *)
Definition replace_task_ptr_list
    (tasks : list addr)
    (before : VarGlobalState) : VarGlobalState :=
  {|
    os_tasks := {|
      task_idmanager_abs := before.(os_tasks).(task_idmanager_abs);
      task_ptr_list := tasks;
      task_desc_map := before.(os_tasks).(task_desc_map);
      sched_owned_tasks := before.(os_tasks).(sched_owned_tasks);
    |};
    os_tick := before.(os_tick);
    os_delays := before.(os_delays);
    os_assign := before.(os_assign);
    zombie_queue := before.(zombie_queue);
    os_recycle := before.(os_recycle);
    os_idle := before.(os_idle);
    os_mutexes := before.(os_mutexes);
    os_msgqueues := before.(os_msgqueues);
    os_events := before.(os_events);
    os_isr := before.(os_isr);
    os_semaphores := before.(os_semaphores);
    os_exstatus := before.(os_exstatus);
  |}.

(** 只替换 descriptor map，保持注册表、ID manager 和其他共享状态不变。 *)
Definition replace_task_desc_map
    (descs : addr -> option TaskDescriptorAbs)
    (before : VarGlobalState) : VarGlobalState :=
  {|
    os_tasks := {|
      task_idmanager_abs := before.(os_tasks).(task_idmanager_abs);
      task_ptr_list := before.(os_tasks).(task_ptr_list);
      task_desc_map := descs;
      sched_owned_tasks := before.(os_tasks).(sched_owned_tasks);
    |};
    os_tick := before.(os_tick);
    os_delays := before.(os_delays);
    os_assign := before.(os_assign);
    zombie_queue := before.(zombie_queue);
    os_recycle := before.(os_recycle);
    os_idle := before.(os_idle);
    os_mutexes := before.(os_mutexes);
    os_msgqueues := before.(os_msgqueues);
    os_events := before.(os_events);
    os_isr := before.(os_isr);
    os_semaphores := before.(os_semaphores);
    os_exstatus := before.(os_exstatus);
  |}.

(** 自环 sched_link 转交队列时更新其所有者集合；不改任何 C 字段的抽象值。 *)
Definition replace_sched_owned_tasks (owned : list addr) (st : VarGlobalState)
    : VarGlobalState :=
  {| os_tasks :=
       {| task_idmanager_abs := st.(os_tasks).(task_idmanager_abs);
          task_ptr_list := st.(os_tasks).(task_ptr_list);
          task_desc_map := st.(os_tasks).(task_desc_map);
          sched_owned_tasks := owned |};
     os_tick := st.(os_tick); os_delays := st.(os_delays); os_assign := st.(os_assign);
     zombie_queue := st.(zombie_queue); os_recycle := st.(os_recycle);
     os_idle := st.(os_idle);
     os_mutexes := st.(os_mutexes); os_msgqueues := st.(os_msgqueues);
     os_events := st.(os_events); os_isr := st.(os_isr); os_semaphores := st.(os_semaphores);
    os_exstatus := st.(os_exstatus) |}.


(** 发布一个信号量只替换 semaphore 分量，所有其他 OS 模块保持。 *)
Definition replace_semaphores (sems : SemaphoreState) (st : VarGlobalState)
    : VarGlobalState :=
  {| os_semaphores := sems;
     os_tasks := st.(os_tasks); os_tick := st.(os_tick); os_delays := st.(os_delays);
     os_assign := st.(os_assign); zombie_queue := st.(zombie_queue);
     os_recycle := st.(os_recycle); os_idle := st.(os_idle);
     os_mutexes := st.(os_mutexes); os_msgqueues := st.(os_msgqueues);
     os_events := st.(os_events); os_isr := st.(os_isr); os_exstatus := st.(os_exstatus) |}.
