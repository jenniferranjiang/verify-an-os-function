Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Strings.String.
From AUXLib Require Import ListLib.
From SimpleC.SL Require Import Mem CNotation.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import CRTOS_Verify.sem.SemaphorePure.
Require Import CRTOS_Verify.sem.SemaphoreProtocol.

Import ListNotations.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

(** 批准的 32 位 ABI 下 Semaphore 的字段与两段 padding 边界。 *)
Definition semaphore_layout_32_ok (sem : addr) : Prop :=
  let idnode := &(sem # "Semaphore" ->ₛ "id") in
  let idlink := &(idnode # "IdNode" ->ₛ "link") in
  let pend := &(sem # "Semaphore" ->ₛ "pend_list") in
  let registry := &(sem # "Semaphore" ->ₛ "link") in
  sizeof("Semaphore") = 32 /\
  idnode = sem /\
  &(idnode # "IdNode" ->ₛ "id") = sem /\
  idlink = sem + 4 /\
  &(idlink # "SysDoubleLinklistNode" ->ₛ "node_next") = sem + 4 /\
  &(idlink # "SysDoubleLinklistNode" ->ₛ "node_prev") = sem + 8 /\
  &(sem # "Semaphore" ->ₛ "id" .ₛ "id") = sem /\
  &(sem # "Semaphore" ->ₛ "id" .ₛ "link") = sem + 4 /\
  &(sem # "Semaphore" ->ₛ "id" .ₛ "link" .ₛ "node_next") = sem + 4 /\
  &(sem # "Semaphore" ->ₛ "id" .ₛ "link" .ₛ "node_prev") = sem + 8 /\
  &(sem # "Semaphore" ->ₛ "value") = sem + 12 /\
  pend = sem + 16 /\
  &(pend # "SysDoubleLinklistNode" ->ₛ "node_next") = sem + 16 /\
  &(pend # "SysDoubleLinklistNode" ->ₛ "node_prev") = sem + 20 /\
  &(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_next") = sem + 16 /\
  &(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev") = sem + 20 /\
  registry = sem + 24 /\
  &(registry # "SysDoubleLinklistNode" ->ₛ "node_next") = sem + 24 /\
  &(registry # "SysDoubleLinklistNode" ->ₛ "node_prev") = sem + 28 /\
  &(sem # "Semaphore" ->ₛ "link" .ₛ "node_next") = sem + 24 /\
  &(sem # "Semaphore" ->ₛ "link" .ₛ "node_prev") = sem + 28.

(** 本 carrier 内部使用的 intrusive DLL 节点；[sem_node_ptr] 是节点地址。 *)
Record SemDLNode (A : Type) : Type := Build_SemDLNode {
  sem_node_data : A;
  sem_node_ptr : addr
}.
Arguments Build_SemDLNode {A} _ _.
Arguments sem_node_data {A} _.
Arguments sem_node_ptr {A} _.

(** DLL spine 拥有 prev/next，payload 只拥有外围对象中不重叠的字段。 *)
Definition sem_dllseg {A : Type}
    (store_payload : addr -> A -> Assertion)
    (first previous stop last : addr) (nodes : list (SemDLNode A))
    : Assertion :=
  (fix go current prev remaining :=
     match remaining with
     | nil => “ current = stop /\ prev = last ” && emp
     | node :: rest =>
         EX next : addr,
           “ current = node.(sem_node_ptr) ” &&
           store_payload current node.(sem_node_data) **
           &(current # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> prev **
           &(current # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next **
           go next current rest
     end) first previous nodes.

(** 完整环形 DLL；[head] 是真实 C 哨兵地址。 *)
Definition store_sem_dll {A : Type}
    (store_payload : addr -> A -> Assertion)
    (head : addr) (nodes : list (SemDLNode A)) : Assertion :=
  EX first last : addr,
    “ head <> 0 /\ first <> 0 /\ last <> 0 /\
      Forall (fun node => node.(sem_node_ptr) <> 0) nodes ” &&
    &(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> last **
    &(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> first **
    sem_dllseg store_payload first head head last nodes.

(** task 基址到 sched_link 地址的转换；不拥有任务其他字段。 *)
Definition semaphore_task_sched_link (task : addr) : addr :=
  &(task # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link").

Definition semaphore_pending_nodes (tasks : list addr) : list (SemDLNode unit) :=
  map (fun task => Build_SemDLNode tt (semaphore_task_sched_link task)) tasks.

(** pend_list 只取得 sched_link 的 prev/next ownership。 *)
Definition store_semaphore_pending_list
    (head : addr) (tasks : list addr) : Assertion :=
  store_sem_dll (fun _ _ => emp) head (semaphore_pending_nodes tasks).

Definition semaphore_id_node (object : SemaphoreObject)
    : SemDLNode SemaphoreObject :=
  let sem := object.(semaphore_addr) in
  Build_SemDLNode object (&(sem # "Semaphore" ->ₛ "id" .ₛ "link")).

Definition semaphore_registry_node (object : SemaphoreObject)
    : SemDLNode SemaphoreObject :=
  let sem := object.(semaphore_addr) in
  Build_SemDLNode object (&(sem # "Semaphore" ->ₛ "link")).

(** ID bucket payload 只拥有 id；link 槽由 DLL spine 拥有。 *)
Definition store_semaphore_id_payload
    (node : addr) (object : SemaphoreObject) : Assertion :=
  let sem := object.(semaphore_addr) in
  “ sem <> 0 /\ semaphore_layout_32_ok sem /\
    node = &(sem # "Semaphore" ->ₛ "id" .ₛ "link") ” &&
  &(sem # "Semaphore" ->ₛ "id" .ₛ "id") # UShort |-> object.(semaphore_id) **
  CharArray.full (sem + 2) 2 (repeat_Z 0 2).

(** registry payload 拥有 value 和 pend_list，不拥有两个容器节点。 *)
Definition store_semaphore_body
    (node : addr) (object : SemaphoreObject) : Assertion :=
  let sem := object.(semaphore_addr) in
  “ sem <> 0 /\ node = &(sem # "Semaphore" ->ₛ "link") ” &&
  &(sem # "Semaphore" ->ₛ "value") # UShort |-> object.(semaphore_value) **
  CharArray.full (sem + 14) 2 (repeat_Z 0 2) **
  store_semaphore_pending_list
    (&(sem # "Semaphore" ->ₛ "pend_list")) object.(semaphore_pending_addrs).

(** bitmap bytes与对象 ID 集合逐 bit 一致。 *)
Definition semaphore_id_in (ids : list Z) (id : Z) : bool :=
  if in_dec Z.eq_dec id ids then true else false.

Definition semaphore_bitmap_ids_ok (stable : SemaphoreStable)
    (ids : list Z) (bytes : list Z) : Prop :=
  Zlength bytes = (stable.(semaphore_id_limit) + 7) / 8 /\
  Forall (fun byte => 0 <= byte <= 255) bytes /\
  forall id, 0 <= id < stable.(semaphore_id_limit) ->
    Z.testbit (Znth (id / 8) bytes 0) (id mod 8) = semaphore_id_in ids id.

Definition semaphore_bitmap_ok (stable : SemaphoreStable)
    (state : SemaphoreState) (bytes : list Z) : Prop :=
  semaphore_bitmap_ids_ok stable (semaphore_ids state.(semaphore_objects)) bytes.

Definition store_semaphore_bitmap_ids
    (stable : SemaphoreStable) (ids : list Z) : Assertion :=
  EX bytes : list Z,
    “ semaphore_bitmap_ids_ok stable ids bytes ” &&
    UCharArray.full stable.(semaphore_bitmap_addr)
      ((stable.(semaphore_id_limit) + 7) / 8) bytes.

Definition store_semaphore_bitmap
    (stable : SemaphoreStable) (state : SemaphoreState) : Assertion :=
  EX bytes : list Z,
    “ semaphore_bitmap_ok stable state bytes ” &&
    UCharArray.full stable.(semaphore_bitmap_addr)
      ((stable.(semaphore_id_limit) + 7) / 8) bytes.

(** 未插入新节点的 link 槽；用于 DLL helper contract。 *)
Definition store_sem_standalone_node {A : Type}
    (store_payload : addr -> A -> Assertion)
    (node : addr) (payload : A) : Assertion :=
  store_payload node payload **
  &(node # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |->_ **
  &(node # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |->_.

(** BSS 尚未 lazy-init 的 bucket head 是有效的连续数组元素，基址非 NULL，
    两个 intrusive 指针仍保持链接器清零值。非空事实支持首次解引用。 *)
Definition store_sem_uninitialized_bucket (head : addr) : Assertion :=
  “ head <> 0 ” &&
  &(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> 0 **
  &(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> 0.

Definition store_sem_initialized_bucket
    (head : addr) (objects : list SemaphoreObject) : Assertion :=
  store_sem_dll store_semaphore_id_payload head
    (map semaphore_id_node objects).

(** None/Some 精确区分 BSS、已初始化空桶与非空桶。 *)
Definition store_sem_bucket (head : addr) (bucket : SemBucket) : Assertion :=
  match bucket with
  | None => store_sem_uninitialized_bucket head
  | Some objects => store_sem_initialized_bucket head objects
  end.

Fixpoint store_sem_buckets_from
    (stable : SemaphoreStable) (index : Z) (buckets : list SemBucket)
    : Assertion :=
  match buckets with
  | nil => emp
  | bucket :: rest =>
      store_sem_bucket
        (stable.(semaphore_buckets_addr) +
          index * sizeof("SysDoubleLinklistNode")) bucket **
      store_sem_buckets_from stable (index + 1) rest
  end.

Definition store_semaphore_buckets
    (stable : SemaphoreStable) (state : SemaphoreState) : Assertion :=
  EX buckets : list SemBucket,
    “ semaphore_buckets_ok stable state buckets ” &&
    store_sem_buckets_from stable 0 buckets.

(** 完整 manager：四字段、bitmap 和连续 bucket-head 数组。 *)
Definition store_semaphore_id_manager
    (stable : SemaphoreStable) (state : SemaphoreState) : Assertion :=
  let manager := stable.(semaphore_manager_addr) in
  &(manager # "IdManager" ->ₛ "id_max") # UShort
    |-> stable.(semaphore_id_limit) **
  &(manager # "IdManager" ->ₛ "hoffset") # UShort
    |-> stable.(semaphore_bucket_count) **
  &(manager # "IdManager" ->ₛ "id_map") # Ptr
    |-> stable.(semaphore_bitmap_addr) **
  &(manager # "IdManager" ->ₛ "htable") # Ptr
    |-> stable.(semaphore_buckets_addr) **
  store_semaphore_bitmap stable state **
  store_semaphore_buckets stable state.

(** [k_sem_list] 及每个已发布对象主体；顺序即抽象状态顺序。 *)
Definition store_semaphore_registry
    (stable : SemaphoreStable) (state : SemaphoreState) : Assertion :=
  store_sem_dll store_semaphore_body stable.(semaphore_registry_addr)
    (map semaphore_registry_node state.(semaphore_objects)).

(** 固定逻辑地址与批准配置下 C 静态对象的对应；不拥有内存。 *)
Definition SemaphoreStableContext (stable : SemaphoreStable) : Prop :=
  stable.(semaphore_manager_addr) = &("k_sem_id_manager") /\
  stable.(semaphore_bitmap_addr) = &("__id_map_k_sem_id_manager") /\
  stable.(semaphore_buckets_addr) = &("__htable_k_sem_id_manager") /\
  stable.(semaphore_registry_addr) = &("k_sem_list") /\
  stable.(semaphore_id_limit) = SEM_ID_MAX /\
  stable.(semaphore_bucket_count) = SEM_BUCKET_COUNT.

(** semaphore 模块稳定全局不变量及其唯一 owner 划分。 *)
Definition semaphore_inv
    (stable : SemaphoreStable) (state : SemaphoreState) : Assertion :=
  “ SemaphoreStableContext stable /\ semaphore_state_wf stable state ” &&
  store_semaphore_id_manager stable state **
  store_semaphore_registry stable state.

(**
  链接器 BSS 与 [k_sem_list] 的显式自环 initializer 在公开操作前共同建立
  此端点；这里直接使用空状态下的普通 invariant，不虚构额外初始化 token。
*)
Definition store_semaphore_static_initial
    (stable : SemaphoreStable) : Assertion :=
  semaphore_inv stable semaphore_initial_state.


(** malloc 成功后、memset 前的全部可访问字段写权限。 *)
Definition store_sem_allocated (sem : addr) : Assertion :=
  “ sem <> 0 /\ semaphore_layout_32_ok sem ” &&
  &(sem # "Semaphore" ->ₛ "id" .ₛ "id") # UShort |->_ **
  CharArray.undef_full (sem + 2) 2 **
  &(sem # "Semaphore" ->ₛ "id" .ₛ "link" .ₛ "node_next") # Ptr |->_ **
  &(sem # "Semaphore" ->ₛ "id" .ₛ "link" .ₛ "node_prev") # Ptr |->_ **
  &(sem # "Semaphore" ->ₛ "value") # UShort |->_ **
  CharArray.undef_full (sem + 14) 2 **
  &(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_next") # Ptr |->_ **
  &(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev") # Ptr |->_ **
  &(sem # "Semaphore" ->ₛ "link" .ₛ "node_next") # Ptr |->_ **
  &(sem # "Semaphore" ->ₛ "link" .ₛ "node_prev") # Ptr |->_.

(** memset 后完整 32 bytes 为零，包括当前 QCP 未自动生成的两段 padding。 *)
Definition store_sem_zeroed_private (sem : addr) : Assertion :=
  “ sem <> 0 /\ semaphore_layout_32_ok sem ” &&
  &(sem # "Semaphore" ->ₛ "id" .ₛ "id") # UShort |-> 0 **
  CharArray.full (sem + 2) 2 (repeat_Z 0 2) **
  &(sem # "Semaphore" ->ₛ "id" .ₛ "link" .ₛ "node_next") # Ptr |-> 0 **
  &(sem # "Semaphore" ->ₛ "id" .ₛ "link" .ₛ "node_prev") # Ptr |-> 0 **
  &(sem # "Semaphore" ->ₛ "value") # UShort |-> 0 **
  CharArray.full (sem + 14) 2 (repeat_Z 0 2) **
  &(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_next") # Ptr |-> 0 **
  &(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev") # Ptr |-> 0 **
  &(sem # "Semaphore" ->ₛ "link" .ₛ "node_next") # Ptr |-> 0 **
  &(sem # "Semaphore" ->ₛ "link" .ₛ "node_prev") # Ptr |-> 0.

(** IdInsertObj 成功后，id/id-link 已转入 manager。 *)
Definition store_sem_after_id_insert_private (sem : addr) : Assertion :=
  “ sem <> 0 ” &&
  &(sem # "Semaphore" ->ₛ "value") # UShort |-> 0 **
  CharArray.full (sem + 14) 2 (repeat_Z 0 2) **
  &(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_next") # Ptr |-> 0 **
  &(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev") # Ptr |-> 0 **
  &(sem # "Semaphore" ->ₛ "link" .ₛ "node_next") # Ptr |-> 0 **
  &(sem # "Semaphore" ->ₛ "link" .ₛ "node_prev") # Ptr |-> 0.

(** value 已设置且 pend_list 已初始化，registry link 尚待发布。 *)
Definition store_sem_publish_ready_private (sem : addr) (value : Z) : Assertion :=
  “ sem <> 0 /\ 0 <= value <= 65535 ” &&
  &(sem # "Semaphore" ->ₛ "value") # UShort |-> value **
  CharArray.full (sem + 14) 2 (repeat_Z 0 2) **
  store_semaphore_pending_list (&(sem # "Semaphore" ->ₛ "pend_list")) nil **
  &(sem # "Semaphore" ->ₛ "link" .ₛ "node_next") # Ptr |-> 0 **
  &(sem # "Semaphore" ->ₛ "link" .ₛ "node_prev") # Ptr |-> 0.

(** ID 已登记但 registry 尚未发布的完整 create 中间资源。 *)
Definition store_sem_registered_unpublished
    (stable : SemaphoreStable) (before : SemaphoreState)
    (sem : addr) (id : Z) : Assertion :=
  store_semaphore_id_manager stable (semaphore_reserve_state before sem id) **
  store_semaphore_registry stable before **
  store_sem_after_id_insert_private sem.

(** registry insert 前的中间资源。 *)
Definition store_sem_publish_ready
    (stable : SemaphoreStable) (before : SemaphoreState)
    (sem : addr) (id value : Z) : Assertion :=
  store_semaphore_id_manager stable (semaphore_reserve_state before sem id) **
  store_semaphore_registry stable before **
  store_sem_publish_ready_private sem value.

(**
  [store_sem_detached] 是 delete 从两个容器移除、清空 waiter 后交给 x_free
  的对象 view；两个 intrusive link 都已经恢复为自环。
*)
Definition store_sem_detached (sem : addr) (value : Z) : Assertion :=
  “ sem <> 0 /\ 0 <= value <= 65535 ” &&
  &(sem # "Semaphore" ->ₛ "id" .ₛ "id") # UShort |-> 65535 **
  CharArray.full (sem + 2) 2 (repeat_Z 0 2) **
  store_sem_dll (fun _ (_ : unit) => emp)
    (&(sem # "Semaphore" ->ₛ "id" .ₛ "link")) nil **
  &(sem # "Semaphore" ->ₛ "value") # UShort |-> value **
  CharArray.full (sem + 14) 2 (repeat_Z 0 2) **
  store_semaphore_pending_list (&(sem # "Semaphore" ->ₛ "pend_list")) nil **
  store_sem_dll (fun _ (_ : unit) => emp)
    (&(sem # "Semaphore" ->ₛ "link")) nil.

(**
  Semaphore heap 在统一 OS world 中的模块投影。bridge 不再接受任意纯谓词：
  [semaphore_task_bridge] 直接查询现有 [VarGlobalState.task_desc_map]，并要求
  每个 pend-list 节点的真实 task status 为 SUSPEND、placement 指向该 semaphore。
  task/scheduler 的空间 owner 由 [CrtosOSRep.crtos_os_inv] 在同一 carrier 中组合。
*)
Definition semaphore_slice_inv
    (stable : CrtosOSStable) (world : CrtosOSWorld) : Assertion :=
  “ semaphore_task_bridge stable world ” &&
  semaphore_inv stable.(crtos_semaphore_stable)
    world.(crtos_semaphore_state).

(**
  [AllocId] 成功后的 transient manager：bitmap 已加入首个空闲 ID，bucket
  尚未改变。它不是稳定模块状态，只供 [InsertObj]/[IdInsertObj] 使用。
*)
Definition store_sem_manager_id_allocated
    (stable : SemaphoreStable) (before : SemaphoreState) (id : Z)
    : Assertion :=
  let manager := stable.(semaphore_manager_addr) in
  “ semaphore_first_free stable before = Some id ” &&
  &(manager # "IdManager" ->ₛ "id_max") # UShort
    |-> stable.(semaphore_id_limit) **
  &(manager # "IdManager" ->ₛ "hoffset") # UShort
    |-> stable.(semaphore_bucket_count) **
  &(manager # "IdManager" ->ₛ "id_map") # Ptr
    |-> stable.(semaphore_bitmap_addr) **
  &(manager # "IdManager" ->ₛ "htable") # Ptr
    |-> stable.(semaphore_buckets_addr) **
  store_semaphore_bitmap_ids stable
    (id :: semaphore_ids before.(semaphore_objects)) **
  store_semaphore_buckets stable before.

(** IdInsertObj 写入 ID 后、InsertObj 接管 link 前的嵌入节点资源。 *)
Definition store_sem_id_node_insert_ready
    (sem : addr) (id : Z) : Assertion :=
  “ sem <> 0 /\ 0 <= id < SEM_ID_MAX ” &&
  CharArray.full (sem + 2) 2 (repeat_Z 0 2) **
  &(sem # "Semaphore" ->ₛ "id" .ₛ "id") # UShort |-> id **
  &(sem # "Semaphore" ->ₛ "id" .ₛ "link" .ₛ "node_prev") # Ptr |->_ **
  &(sem # "Semaphore" ->ₛ "id" .ₛ "link" .ₛ "node_next") # Ptr |->_.

(** memset 后、IdInsertObj 尚未写入时的精确 node；失败路径原样返还。 *)
Definition store_sem_id_node_zeroed (sem : addr) : Assertion :=
  “ sem <> 0 ” &&
  &(sem # "Semaphore" ->ₛ "id" .ₛ "id") # UShort |-> 0 **
  CharArray.full (sem + 2) 2 (repeat_Z 0 2) **
  &(sem # "Semaphore" ->ₛ "id" .ₛ "link" .ₛ "node_prev") # Ptr |-> 0 **
  &(sem # "Semaphore" ->ₛ "id" .ₛ "link" .ₛ "node_next") # Ptr |-> 0.
