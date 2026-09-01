Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Export CRTOS_Verify.lib.IdManagerRep.
Require Export CRTOS_Verify.lib.DoublyLinkedList.

Import ListNotations.

Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

Definition SEMAPHORE_MEM_SIZE : Z := 32.
Definition SEMAPHORE_DONE_SIZE : Z := 20.

(**
  [semaphore_field_offset_ok] 固定当前 Cortex-M3 ABI 下
  [struct Semaphore] 的全部字段地址、两段 padding 与总大小。该命题只
  描述地址关系；ownership 由后续空间谓词给出。
*)
Definition semaphore_field_offset_ok (sem : addr) : Prop :=
  &(sem # "Semaphore" ->ₛ "id") = sem + 0 /\
  &(sem # "Semaphore" ->ₛ "id" .ₛ "id") = sem + 0 /\
  &(sem # "Semaphore" ->ₛ "id" .ₛ "link") = sem + 4 /\
  &(sem # "Semaphore" ->ₛ "id" .ₛ "link" .ₛ "node_next") = sem + 4 /\
  &(sem # "Semaphore" ->ₛ "id" .ₛ "link" .ₛ "node_prev") = sem + 8 /\
  &(sem # "Semaphore" ->ₛ "value") = sem + 12 /\
  &(sem # "Semaphore" ->ₛ "pend_list") = sem + 16 /\
  &(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_next") = sem + 16 /\
  &(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev") = sem + 20 /\
  &(sem # "Semaphore" ->ₛ "link") = sem + 24 /\
  &(sem # "Semaphore" ->ₛ "link" .ₛ "node_next") = sem + 24 /\
  &(sem # "Semaphore" ->ₛ "link" .ₛ "node_prev") = sem + 28 /\
  sizeof("Semaphore") = SEMAPHORE_MEM_SIZE.

(**
  权威 [SemaphoreDoneType] 是匿名 typedef struct。验证 slice 使用
  字段顺序与函数指针类型完全相同的 tagged [SemaphoreDone]
  作 ABI normalization；本关系把五个真实 32-bit slot 与该 C 载体
  逐一绑定。
*)
Definition semaphore_done_field_offset_ok (table : addr) : Prop :=
  &(table # "SemaphoreDone" ->ₛ "SemaphoreCreate") = table + 0 /\
  &(table # "SemaphoreDone" ->ₛ "SemaphoreDelete") = table + 4 /\
  &(table # "SemaphoreDone" ->ₛ "SemaphoreObtain") = table + 8 /\
  &(table # "SemaphoreDone" ->ₛ "SemaphoreAbandon") = table + 12 /\
  &(table # "SemaphoreDone" ->ₛ "SemaphoreSetValue") = table + 16 /\
  sizeof("SemaphoreDone") = SEMAPHORE_DONE_SIZE.

Definition semaphore_id_link (sem : addr) : addr :=
  &(sem # "Semaphore" ->ₛ "id" .ₛ "link").

Definition semaphore_pend_head (sem : addr) : addr :=
  &(sem # "Semaphore" ->ₛ "pend_list").

Definition semaphore_global_link (sem : addr) : addr :=
  &(sem # "Semaphore" ->ₛ "link").

Definition waiter_sched_link (task : addr) : addr :=
  &(task # "TaskDescriptor" ->ₛ
    "task_dync_sched_member" .ₛ "sched_link").

(**
  两段 padding 在整块 [memset] 后保持为零。所有具名字段谓词都排除这些
  字节，因此该谓词是完整 32-byte ownership ledger 中不可省略的部分。
*)
Definition store_semaphore_padding (sem : addr) : Assertion :=
  UCharArray.full (sem + 2) 2 [0; 0] **
  UCharArray.full (sem + 14) 2 [0; 0].

(**
  pending DLL payload 只把 link 地址与 task 基址绑定。spine 唯一
  持有 [sched_link] 的两个指针；task 的 id/priority/name/exstatus 等
  所有字段始终留在 task-owned view，不进入 semaphore invariant。
*)
Definition store_semaphore_waiter_payload
    (link : addr) (waiter : SemaphoreWaiter) : Assertion :=
  “ link = waiter_sched_link waiter.(waiter_task) ” && emp.

(**
  task 模块在 critical scope 中转交的字段分片。该分片是
  [SemaphoreTaskView] 的唯一 spatial 解释，不得与拥有同一字段的
  完整 task invariant 同时分离合取；调用边界必须是线性拆出—返还。
*)
Definition store_semaphore_task_view
    (view : SemaphoreTaskView) : Assertion :=
  let task := view.(sem_task_addr) in
  “ semaphore_task_view_wf view ” &&
  &(task # "TaskDescriptor" ->ₛ "id" .ₛ "id")
    # UShort |-> view.(sem_task_id) **
  &(task # "TaskDescriptor" ->ₛ
    "task_dync_sched_member" .ₛ "cur_prio")
    # UChar |-> view.(sem_task_priority) **
  CharArray.full
    (&(task # "TaskDescriptor" ->ₛ "task_base_info" .ₛ "name"))
    32 view.(sem_task_name) **
  &(task # "TaskDescriptor" ->ₛ "exstatus")
    # Int |-> view.(sem_task_exstatus).

Fixpoint store_semaphore_task_views
    (views : list SemaphoreTaskView) : Assertion :=
  match views with
  | nil => emp
  | view :: rest =>
      store_semaphore_task_view view ** store_semaphore_task_views rest
  end.

(**
  semaphore 遍历/Linklist 调用的跨模块组合视图。纯关系保证
  每个 pending task 都唯一对应某个真实 `(task,id)` 字段分片；
  [ShowSem]/[GetSuspendedTask] 的 name 读取也来自同一分片。
*)
Definition semaphore_task_borrow_view
    (waiters : list SemaphoreWaiter)
    (views : list SemaphoreTaskView) : Assertion :=
  “ semaphore_task_views_cover views waiters ” &&
  store_semaphore_task_views views.

(**
  task/scheduler 与 semaphore pending DLL 之间转交单个 sched-link 时使用的
  边界资源。插入 pending list 后该 standalone link 消失；wakeup/timeout
  移除后必须把同一资源返还给 task/scheduler。
*)
Definition store_semaphore_waiter_transfer
    (waiter : SemaphoreWaiter) : Assertion :=
  store_dll_node_standalone (waiter_sched_link waiter.(waiter_task)).

Definition semaphore_waiter_node
    (waiter : SemaphoreWaiter) : DllNode SemaphoreWaiter :=
  Build_DllNode waiter (waiter_sched_link waiter.(waiter_task)).

Definition semaphore_waiter_nodes
    (waiters : list SemaphoreWaiter) : list (DllNode SemaphoreWaiter) :=
  map semaphore_waiter_node waiters.

(**
  [store_semaphore_body] 拥有 published semaphore 除两个 intrusive index
  links 和 [id.id] 外的全部字节：value、pend head/spine 及 padding。
*)
Definition store_semaphore_body
    (sem_addr : addr) (sem : SemaphoreObject) : Assertion :=
  “ sem_addr = sem.(semaphore_addr) /\
    semaphore_field_offset_ok sem_addr ” &&
  &(sem_addr # "Semaphore" ->ₛ "value") # UShort
    |-> sem.(semaphore_value) **
  store_dll store_semaphore_waiter_payload
    (semaphore_pend_head sem_addr)
    (semaphore_waiter_nodes sem.(semaphore_waiters)) **
  store_semaphore_padding sem_addr.

(** 全局 [k_sem_list] 的 payload 拥有 object body，spine 拥有 [sem->link]。 *)
Definition store_semaphore_list_payload
    (link : addr) (sem : SemaphoreObject) : Assertion :=
  “ link = semaphore_global_link sem.(semaphore_addr) ” &&
  store_semaphore_body sem.(semaphore_addr) sem.

Definition semaphore_list_node
    (sem : SemaphoreObject) : DllNode SemaphoreObject :=
  Build_DllNode sem (semaphore_global_link sem.(semaphore_addr)).

Definition semaphore_list_nodes
    (objects : list SemaphoreObject) : list (DllNode SemaphoreObject) :=
  map semaphore_list_node objects.

(**
  [store_sem_id_manager] 复用通用 manager representation，并用纯排列关系
  连接 published semaphore。通用 manager 独占 bitmap、bucket heads、
  所有 [sem->id.link] 与 [sem->id.id]。
*)
Definition store_sem_id_manager
    (sg : SemaphoreStable) (st : SemaphoreState) : Assertion :=
  EX idm : IdManagerState,
    “ id_manager_matches_semaphores st idm ” &&
    store_id_manager (semaphore_id_stable sg) idm sg.(sem_manager_addr).

(** [k_sem_list] 拥有所有已发布 object body 与 [sem->link]。 *)
Definition store_sem_registry
    (sg : SemaphoreStable) (st : SemaphoreState) : Assertion :=
  store_dll store_semaphore_list_payload sg.(sem_list_head_addr)
    (semaphore_list_nodes st.(sem_objects)).

(**
  [semaphore_inv] 是模块稳定状态的完整空间解释。ID manager 与全局 list
  分别拥有两个不同 intrusive links；list payload 拥有 body，因此每个
  published 32-byte semaphore 的每个字节恰有一个 owner。
*)
Definition semaphore_inv
    (sg : SemaphoreStable) (st : SemaphoreState) : Assertion :=
  “ SemaphoreStableContext sg /\ semaphore_world_wf sg st ” &&
  store_sem_id_manager sg st **
  store_sem_registry sg st.

(**
  [ShowSem]/[GetSuspendedTask] 在同一 critical scope 中遍历 registry、
  pending spine 与 task name。该组合断言为每次 load 提供唯一 owner：
  semaphore 部分持有链表，task 分片持有 id/priority/name/exstatus。
*)
Definition semaphore_with_task_borrows
    (sg : SemaphoreStable) (st : SemaphoreState)
    (views : list SemaphoreTaskView) : Assertion :=
  semaphore_inv sg st **
  semaphore_task_borrow_view
    (semaphore_all_waiters st.(sem_objects)) views.

(** static dispatch 表的五个指针槽由 public wrapper 线性借用并返还。 *)
Definition store_semaphore_done (sg : SemaphoreStable) : Assertion :=
  let done := sg.(sem_done_abs) in
  let table := sg.(sem_done_addr) in
  “ semaphore_done_field_offset_ok table ” &&
  &(table # "SemaphoreDone" ->ₛ "SemaphoreCreate")
    # Ptr |-> done.(sem_done_create) **
  &(table # "SemaphoreDone" ->ₛ "SemaphoreDelete")
    # Ptr |-> done.(sem_done_delete) **
  &(table # "SemaphoreDone" ->ₛ "SemaphoreObtain")
    # Ptr |-> done.(sem_done_obtain) **
  &(table # "SemaphoreDone" ->ₛ "SemaphoreAbandon")
    # Ptr |-> done.(sem_done_abandon) **
  &(table # "SemaphoreDone" ->ₛ "SemaphoreSetValue")
    # Ptr |-> done.(sem_done_set_value).

(** 非 SMP critical wrapper 访问的静态 nesting counter。 *)
Definition store_critical_nest (nest : Z) : Assertion :=
  &("KTaskOsAssignLockNest") # UShort |-> nest.

(**
  非空 handler 栈表示当前执行已经取得共享 semaphore invariant；空栈时
  invariant 留在 nested-critical 协议中。Lock/Unlock 用该定义统一处理
  外层进入与真实嵌套调用，而不把 outside 资源冒充 caller-owned memory。
*)
Definition semaphore_critical_owned_memory
    (handlers : list Z) (sg : SemaphoreStable) (st : SemaphoreState)
    : Assertion :=
  match handlers with
  | nil => emp
  | _ => semaphore_inv sg st
  end.

(**
  critical 协议、真实 uint16 nesting counter 与条件化共享内存的
  单一空间接口。counter 的值精确等于 ghost handler 栈深度；
  外层规格不得再分别组装三块资源。
*)
Definition semaphore_critical_interface
    (handlers : list Z) (sg : SemaphoreStable) (st : SemaphoreState)
    : Assertion :=
  SemaphoreCritical handlers sg st **
  store_critical_nest (semaphore_handler_depth handlers) **
  semaphore_critical_owned_memory handlers sg st.

(** 进入新一层前额外要求 uint16 counter 不会溢出。 *)
Definition semaphore_critical_enterable
    (handlers : list Z) (sg : SemaphoreStable) (st : SemaphoreState)
    : Assertion :=
  “ SemaphoreCanEnter handlers ” &&
  semaphore_critical_interface handlers sg st.

(**
  [DisableLocalInterrupt] 已完成 ghost enter 而 wrapper 尚未执行
  `KTaskOsAssignLockNest++` 的唯一中间态。协议深度已增加，
  真实 counter 仍是旧深度。
*)
Definition semaphore_critical_lock_pending
    (saved : Z) (handlers : list Z)
    (sg : SemaphoreStable) (st : SemaphoreState) : Assertion :=
  SemaphoreCritical (saved :: handlers) sg st **
  semaphore_critical_owned_memory (saved :: handlers) sg st **
  store_critical_nest (semaphore_handler_depth handlers).

(**
  wrapper 已执行 `KTaskOsAssignLockNest--` 而
  [EnableLocalInterrupt] 尚未提交本次 guarantee 的唯一中间态。
  ghost protocol 仍指向 [protocol_state]，线性内存已是
  [memory_state]；两者只能由精确单步 guarantee 连接。
*)
Definition semaphore_critical_unlock_pending
    (saved : Z) (rest : list Z) (sg : SemaphoreStable)
    (protocol_state memory_state : SemaphoreState) : Assertion :=
  “ SemaphoreGuarantee sg protocol_state memory_state ” &&
  SemaphoreCritical (saved :: rest) sg protocol_state **
  semaphore_inv sg memory_state **
  store_critical_nest (semaphore_handler_depth rest).

(** trusted allocator 成功后交付的完整 32-byte 未初始化对象。 *)
Definition store_sem_allocated (sem : addr) : Assertion :=
  “ sem <> 0 /\ semaphore_field_offset_ok sem ” &&
  UCharArray.undef_full sem SEMAPHORE_MEM_SIZE.

(**
  trusted [memset] 后对象的全部字段和 padding 均为零。pend/id/global 三个
  link 此时只是 zeroed node，尚不能冒充合法 circular list。
*)
Definition store_sem_zeroed_private (sem : addr) : Assertion :=
  “ sem <> 0 /\ semaphore_field_offset_ok sem ” &&
  &(sem # "Semaphore" ->ₛ "id" .ₛ "id") # UShort |-> 0 **
  store_dll_node_zeroed (semaphore_id_link sem) **
  &(sem # "Semaphore" ->ₛ "value") # UShort |-> 0 **
  store_dll_node_zeroed (semaphore_pend_head sem) **
  store_dll_node_zeroed (semaphore_global_link sem) **
  store_semaphore_padding sem.

(**
  [IdInsertObj] 成功后 ID manager 已取得 [id.id/id.link]；创建者继续私有
  持有 value、两个尚未发布的 list nodes 与 padding。
*)
Definition store_sem_after_id_insert_private (sem : addr) : Assertion :=
  “ sem <> 0 /\ semaphore_field_offset_ok sem ” &&
  &(sem # "Semaphore" ->ₛ "value") # UShort |-> 0 **
  store_dll_node_zeroed (semaphore_pend_head sem) **
  store_dll_node_zeroed (semaphore_global_link sem) **
  store_semaphore_padding sem.

(**
  ID 已登记但 [k_sem_list] 尚未发布的临界区中间态。它故意不是
  [semaphore_inv]：manager 使用加入新 ref 的状态，而 registry 仍保持旧态。
*)
Definition semaphore_id_registered
    (sg : SemaphoreStable) (before : SemaphoreState)
    (idm_before : IdManagerState) (sem : SemaphoreObject) : Assertion :=
  let sm := semaphore_id_stable sg in
  “ id_manager_matches_semaphores before idm_before /\
    id_manager_min_free_id sm idm_before sem.(semaphore_id) /\
    sem.(semaphore_value) = 0 /\ sem.(semaphore_waiters) = nil ” &&
  store_id_manager sm
    (id_manager_after_insert sm idm_before
      sem.(semaphore_id) sem.(semaphore_addr))
    sg.(sem_manager_addr) **
  store_sem_registry sg before.

(**
  初始化完成、等待插入 [k_sem_list] 的 private remainder。pend head 已是
  空 circular list，global link 仍由创建者持有可写零值槽。
*)
Definition store_sem_publish_ready_private
    (sem_addr : addr) (sem : SemaphoreObject) : Assertion :=
  “ sem_addr = sem.(semaphore_addr) /\
    sem.(semaphore_waiters) = nil /\ semaphore_field_offset_ok sem_addr ” &&
  &(sem_addr # "Semaphore" ->ₛ "value") # UShort
    |-> sem.(semaphore_value) **
  store_dll store_semaphore_waiter_payload
    (semaphore_pend_head sem_addr) nil **
  store_dll_node_zeroed (semaphore_global_link sem_addr) **
  store_semaphore_padding sem_addr.

(**
  delete 已清空 pending list、移除 ID bucket 与 [k_sem_list] 后的完整 private
  block。`IdRemoveObj` 把 uint16 ID 写成 65535，两个 intrusive links 均由
  remove helper 重置为 standalone；该资源随后由 trusted [x_free] 消费。
*)
Definition store_sem_detached
    (sem : addr) (value : Z) : Assertion :=
  “ sem <> 0 /\ semaphore_field_offset_ok sem /\
    0 <= value <= 65535 ” &&
  &(sem # "Semaphore" ->ₛ "id" .ₛ "id") # UShort |-> 65535 **
  store_dll_node_standalone (semaphore_id_link sem) **
  &(sem # "Semaphore" ->ₛ "value") # UShort |-> value **
  store_dll store_semaphore_waiter_payload
    (semaphore_pend_head sem) nil **
  store_dll_node_standalone (semaphore_global_link sem) **
  store_semaphore_padding sem.

Definition semaphore_initial_state : SemaphoreState :=
  Build_SemaphoreState nil.

Definition semaphore_initial_id_manager : IdManagerState :=
  Build_IdManagerState nil (repeat None 16).

(**
  模块没有显式 init 函数；链接器的静态/BSS 初始化直接建立空 manager、
  空 registry 与 dispatch 表。该 interface 是生命周期 ownership 的起点。
*)
Definition semaphore_static_initialized (sg : SemaphoreStable) : Assertion :=
  “ SemaphoreStableContext sg /\
    semaphore_world_wf sg semaphore_initial_state /\
    id_manager_state_wf (semaphore_id_stable sg)
      semaphore_initial_id_manager /\
    id_manager_matches_semaphores semaphore_initial_state
      semaphore_initial_id_manager ” &&
  store_id_manager (semaphore_id_stable sg)
    semaphore_initial_id_manager sg.(sem_manager_addr) **
  store_sem_registry sg semaphore_initial_state **
  store_critical_nest 0 **
  store_semaphore_done sg.

(**
  协议安装前/ 后的生命周期端点。链接器 BSS 提供的端点拥有
  空 invariant 与值为 0 的 counter；STS 安装线性消耗 invariant
  后，运行时端点是精确的 outside/depth-0 组合接口。
*)
Inductive SemaphoreCriticalLifecycle : Type :=
| SemaphoreBeforeProtocolInstall
| SemaphoreAfterProtocolInstall.

Definition semaphore_critical_lifecycle
    (phase : SemaphoreCriticalLifecycle) (sg : SemaphoreStable) : Assertion :=
  match phase with
  | SemaphoreBeforeProtocolInstall => semaphore_static_initialized sg
  | SemaphoreAfterProtocolInstall =>
      semaphore_critical_interface nil sg semaphore_initial_state **
      store_semaphore_done sg
  end.

Definition SemaphoreProtocolInstallEffect
    (before after : SemaphoreState) : Prop :=
  before = semaphore_initial_state /\ after = semaphore_initial_state.

Inductive SemaphoreCriticalLifecycleStep
    : SemaphoreCriticalLifecycle -> SemaphoreState ->
      SemaphoreCriticalLifecycle -> SemaphoreState -> Prop :=
| SemaphoreInstallProtocol : forall before after,
    SemaphoreProtocolInstallEffect before after ->
    SemaphoreCriticalLifecycleStep
      SemaphoreBeforeProtocolInstall before
      SemaphoreAfterProtocolInstall after.
