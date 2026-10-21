Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Strings.String.
From AUXLib Require Import ListLib.
From SimpleC.SL Require Import Mem CNotation.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import CRTOS_Verify.mutex.MutexPure.
Require Import CRTOS_Verify.mutex.MutexProtocol.

Import ListNotations.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

(** 本 carrier 内部的 intrusive DLL 节点；[mutex_node_ptr] 是节点地址。 *)
Record MutexDLNode (A : Type) : Type := Build_MutexDLNode {
  mutex_node_data : A;
  mutex_node_ptr : addr
}.
Arguments Build_MutexDLNode {A} _ _.
Arguments mutex_node_data {A} _.
Arguments mutex_node_ptr {A} _.

(** DLL spine 独占 prev/next；payload 只能拥有外围对象中不重叠的字段。 *)
Definition mutex_dllseg {A : Type}
    (store_payload : addr -> A -> Assertion)
    (first previous stop last : addr) (nodes : list (MutexDLNode A))
    : Assertion :=
  (fix go current prev remaining :=
     match remaining with
     | nil => “ current = stop /\ prev = last ” && emp
     | node :: rest =>
         EX next : addr,
           “ current = node.(mutex_node_ptr) ” &&
           store_payload current node.(mutex_node_data) **
           &(current # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> prev **
           &(current # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next **
           go next current rest
     end) first previous nodes.

(** 完整环形 DLL；[head] 是真实 C 哨兵地址并由本谓词拥有两个 link 槽。 *)
Definition store_mutex_dll {A : Type}
    (store_payload : addr -> A -> Assertion)
    (head : addr) (nodes : list (MutexDLNode A)) : Assertion :=
  EX first last : addr,
    “ head <> 0 /\ first <> 0 /\ last <> 0 /\
      Forall (fun node => node.(mutex_node_ptr) <> 0) nodes ” &&
    &(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> last **
    &(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> first **
    mutex_dllseg store_payload first head head last nodes.

(** TaskDescriptor 基址到调度 intrusive link 的真实字段地址；不拥有 task 其余字段。 *)
Definition mutex_task_sched_link (task : addr) : addr :=
  &(task # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link").

Definition mutex_pending_nodes (tasks : list addr) : list (MutexDLNode unit) :=
  map (fun task => Build_MutexDLNode tt (mutex_task_sched_link task)) tasks.

(** [pend_list] 独占每个等待任务 sched_link 的 prev/next。 *)
Definition store_mutex_pending_list (head : addr) (tasks : list addr)
    : Assertion :=
  store_mutex_dll (fun _ _ => emp) head (mutex_pending_nodes tasks).

Definition mutex_id_node (object : MutexObject) : MutexDLNode MutexObject :=
  let p := object.(mutex_addr) in
  Build_MutexDLNode object (&(p # "Mutex" ->ₛ "id" .ₛ "link")).

Definition mutex_registry_node (object : MutexObject) : MutexDLNode MutexObject :=
  let p := object.(mutex_addr) in
  Build_MutexDLNode object (&(p # "Mutex" ->ₛ "link")).

(** ID bucket payload 只拥有 [id.id]；嵌入 link 两槽归 bucket DLL spine。 *)
Definition store_mutex_id_payload (node : addr) (object : MutexObject)
    : Assertion :=
  let p := object.(mutex_addr) in
  “ p <> 0 /\ node = &(p # "Mutex" ->ₛ "id" .ₛ "link") ” &&
  &(p # "Mutex" ->ₛ "id" .ₛ "id") # UShort |-> object.(mutex_id).

(**
  Registry payload 拥有 mutex 的运行字段和 pending 哨兵/节点；[id.link]
  与 [link] 的 prev/next 分别由 ID bucket 和 registry spine 唯一拥有。
*)
Definition store_mutex_body (node : addr) (object : MutexObject) : Assertion :=
  let p := object.(mutex_addr) in
  “ p <> 0 /\ node = &(p # "Mutex" ->ₛ "link") ” &&
  &(p # "Mutex" ->ₛ "val") # UShort |-> object.(mutex_value) **
  &(p # "Mutex" ->ₛ "recursive_cnt") # UChar
    |-> object.(mutex_recursive_count) **
  &(p # "Mutex" ->ₛ "origin_prio") # UChar
    |-> object.(mutex_origin_priority) **
  &(p # "Mutex" ->ₛ "holder") # Ptr |-> object.(mutex_holder_addr) **
  store_mutex_pending_list
    (&(p # "Mutex" ->ₛ "pend_list")) object.(mutex_pending_addrs).

Definition mutex_id_in (ids : list Z) (id : Z) : bool :=
  if in_dec Z.eq_dec id ids then true else false.

(** bitmap 的每一 bit 与已发布/保留对象的 ID 集合精确一致。 *)
Definition mutex_bitmap_ids_ok (stable : MutexStable)
    (ids : list Z) (bytes : list Z) : Prop :=
  Zlength bytes = (stable.(mutex_id_limit) + 7) / 8 /\
  Forall (fun byte => 0 <= byte <= 255) bytes /\
  forall id, 0 <= id < stable.(mutex_id_limit) ->
    Z.testbit (Znth (id / 8) bytes 0) (id mod 8) = mutex_id_in ids id.

Definition mutex_bitmap_ok (stable : MutexStable)
    (state : MutexState) (bytes : list Z) : Prop :=
  mutex_bitmap_ids_ok stable (mutex_ids state.(mutex_objects)) bytes.

Definition store_mutex_bitmap_ids
    (stable : MutexStable) (ids : list Z) : Assertion :=
  EX bytes : list Z,
    “ mutex_bitmap_ids_ok stable ids bytes ” &&
    UCharArray.full stable.(mutex_bitmap_addr)
      ((stable.(mutex_id_limit) + 7) / 8) bytes.

Definition store_mutex_bitmap
    (stable : MutexStable) (state : MutexState) : Assertion :=
  EX bytes : list Z,
    “ mutex_bitmap_ok stable state bytes ” &&
    UCharArray.full stable.(mutex_bitmap_addr)
      ((stable.(mutex_id_limit) + 7) / 8) bytes.

(** 未插入容器的 node：payload 与两个可写 link 槽精确组合。 *)
Definition store_mutex_standalone_node {A : Type}
    (store_payload : addr -> A -> Assertion)
    (node : addr) (payload : A) : Assertion :=
  store_payload node payload **
  &(node # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |->_ **
  &(node # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |->_.

(** BSS 尚未 lazy-init 的 bucket head 是两个 NULL 指针。 *)
Definition store_mutex_uninitialized_bucket (head : addr) : Assertion :=
  &(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> 0 **
  &(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> 0.

Definition store_mutex_initialized_bucket
    (head : addr) (objects : list MutexObject) : Assertion :=
  store_mutex_dll store_mutex_id_payload head (map mutex_id_node objects).

(** None/Some 区分 BSS、已初始化空桶和含对象的桶。 *)
Definition store_mutex_bucket (head : addr) (bucket : MutexBucket) : Assertion :=
  match bucket with
  | None => store_mutex_uninitialized_bucket head
  | Some objects => store_mutex_initialized_bucket head objects
  end.

Fixpoint store_mutex_buckets_from
    (stable : MutexStable) (index : Z) (buckets : list MutexBucket)
    : Assertion :=
  match buckets with
  | nil => emp
  | bucket :: rest =>
      store_mutex_bucket
        (stable.(mutex_buckets_addr) +
          index * sizeof("SysDoubleLinklistNode")) bucket **
      store_mutex_buckets_from stable (index + 1) rest
  end.

Definition store_mutex_buckets
    (stable : MutexStable) (state : MutexState) : Assertion :=
  EX buckets : list MutexBucket,
    “ mutex_buckets_ok stable state buckets ” &&
    store_mutex_buckets_from stable 0 buckets.

(** 完整 [k_mutex_id_manager]：四字段、16-byte bitmap 和 16 个 bucket heads。 *)
Definition store_mutex_id_manager
    (stable : MutexStable) (state : MutexState) : Assertion :=
  let manager := stable.(mutex_manager_addr) in
  &(manager # "IdManager" ->ₛ "id_max") # UShort
    |-> stable.(mutex_id_limit) **
  &(manager # "IdManager" ->ₛ "hoffset") # UShort
    |-> stable.(mutex_bucket_count) **
  &(manager # "IdManager" ->ₛ "id_map") # Ptr
    |-> stable.(mutex_bitmap_addr) **
  &(manager # "IdManager" ->ₛ "htable") # Ptr
    |-> stable.(mutex_buckets_addr) **
  store_mutex_bitmap stable state **
  store_mutex_buckets stable state.

(** [k_mutex_list] spine及每个已发布对象主体；顺序就是 abstract state 顺序。 *)
Definition store_mutex_registry
    (stable : MutexStable) (state : MutexState) : Assertion :=
  store_mutex_dll store_mutex_body stable.(mutex_registry_addr)
    (map mutex_registry_node state.(mutex_objects)).

(** 固定逻辑地址与当前 C 静态 symbols 的对应；本纯关系不拥有内存。 *)
Definition MutexStableContext (stable : MutexStable) : Prop :=
  stable.(mutex_manager_addr) = &("k_mutex_id_manager") /\
  stable.(mutex_bitmap_addr) = &("__id_map_k_mutex_id_manager") /\
  stable.(mutex_buckets_addr) = &("__htable_k_mutex_id_manager") /\
  stable.(mutex_registry_addr) = &("k_mutex_list") /\
  stable.(mutex_id_limit) = MUTEX_ID_MAX /\
  stable.(mutex_bucket_count) = MUTEX_BUCKET_COUNT.

(** mutex 模块稳定不变量；manager 与 registry footprints 必须互不重叠。 *)
Definition mutex_inv (stable : MutexStable) (state : MutexState) : Assertion :=
  “ MutexStableContext stable /\ mutex_state_wf stable state ” &&
  store_mutex_id_manager stable state **
  store_mutex_registry stable state.

(** BSS 与显式 self-linked [k_mutex_list] initializer 建立空模块初态。 *)
Definition store_mutex_static_initial (stable : MutexStable) : Assertion :=
  mutex_inv stable mutex_initial_state.

(** malloc 成功、memset 前，拥有 struct Mutex 中每个源码可访问字段。 *)
Definition store_mutex_allocated (p : addr) : Assertion :=
  “ p <> 0 ” &&
  &(p # "Mutex" ->ₛ "id" .ₛ "id") # UShort |->_ **
  &(p # "Mutex" ->ₛ "id" .ₛ "link" .ₛ "node_next") # Ptr |->_ **
  &(p # "Mutex" ->ₛ "id" .ₛ "link" .ₛ "node_prev") # Ptr |->_ **
  &(p # "Mutex" ->ₛ "val") # UShort |->_ **
  &(p # "Mutex" ->ₛ "recursive_cnt") # UChar |->_ **
  &(p # "Mutex" ->ₛ "origin_prio") # UChar |->_ **
  &(p # "Mutex" ->ₛ "holder") # Ptr |->_ **
  &(p # "Mutex" ->ₛ "pend_list" .ₛ "node_next") # Ptr |->_ **
  &(p # "Mutex" ->ₛ "pend_list" .ₛ "node_prev") # Ptr |->_ **
  &(p # "Mutex" ->ₛ "link" .ₛ "node_next") # Ptr |->_ **
  &(p # "Mutex" ->ₛ "link" .ₛ "node_prev") # Ptr |->_.

(** memset 后所有可见字段为零；struct padding 由 QCP 的整块视图处理。 *)
Definition store_mutex_zeroed_private (p : addr) : Assertion :=
  “ p <> 0 ” &&
  &(p # "Mutex" ->ₛ "id" .ₛ "id") # UShort |-> 0 **
  &(p # "Mutex" ->ₛ "id" .ₛ "link" .ₛ "node_next") # Ptr |-> 0 **
  &(p # "Mutex" ->ₛ "id" .ₛ "link" .ₛ "node_prev") # Ptr |-> 0 **
  &(p # "Mutex" ->ₛ "val") # UShort |-> 0 **
  &(p # "Mutex" ->ₛ "recursive_cnt") # UChar |-> 0 **
  &(p # "Mutex" ->ₛ "origin_prio") # UChar |-> 0 **
  &(p # "Mutex" ->ₛ "holder") # Ptr |-> 0 **
  &(p # "Mutex" ->ₛ "pend_list" .ₛ "node_next") # Ptr |-> 0 **
  &(p # "Mutex" ->ₛ "pend_list" .ₛ "node_prev") # Ptr |-> 0 **
  &(p # "Mutex" ->ₛ "link" .ₛ "node_next") # Ptr |-> 0 **
  &(p # "Mutex" ->ₛ "link" .ₛ "node_prev") # Ptr |-> 0.

(** IdInsertObj 成功后，id/id-link 已转给 manager；其余零值仍属私有对象。 *)
Definition store_mutex_after_id_insert_private (p : addr) : Assertion :=
  “ p <> 0 ” &&
  &(p # "Mutex" ->ₛ "val") # UShort |-> 0 **
  &(p # "Mutex" ->ₛ "recursive_cnt") # UChar |-> 0 **
  &(p # "Mutex" ->ₛ "origin_prio") # UChar |-> 0 **
  &(p # "Mutex" ->ₛ "holder") # Ptr |-> 0 **
  &(p # "Mutex" ->ₛ "pend_list" .ₛ "node_next") # Ptr |-> 0 **
  &(p # "Mutex" ->ₛ "pend_list" .ₛ "node_prev") # Ptr |-> 0 **
  &(p # "Mutex" ->ₛ "link" .ₛ "node_next") # Ptr |-> 0 **
  &(p # "Mutex" ->ₛ "link" .ₛ "node_prev") # Ptr |-> 0.

(** create 初始化完运行字段与 pend head、但 registry link 尚未发布的私有 view。 *)
Definition store_mutex_publish_ready_private (p : addr) : Assertion :=
  “ p <> 0 ” &&
  &(p # "Mutex" ->ₛ "val") # UShort |-> 1 **
  &(p # "Mutex" ->ₛ "recursive_cnt") # UChar |-> 0 **
  &(p # "Mutex" ->ₛ "origin_prio") # UChar |-> 255 **
  &(p # "Mutex" ->ₛ "holder") # Ptr |-> 0 **
  store_mutex_pending_list (&(p # "Mutex" ->ₛ "pend_list")) nil **
  &(p # "Mutex" ->ₛ "link" .ₛ "node_next") # Ptr |-> 0 **
  &(p # "Mutex" ->ₛ "link" .ₛ "node_prev") # Ptr |-> 0.

(** ID 已登记但 registry 尚未发布的 create 中间 ownership。 *)
Definition store_mutex_registered_unpublished
    (stable : MutexStable) (before : MutexState) (p : addr) (id : Z)
    : Assertion :=
  store_mutex_id_manager stable (mutex_reserve_state before p id) **
  store_mutex_registry stable before **
  store_mutex_after_id_insert_private p.

(** registry insert 前，manager 已含 ID，私有对象已具备最终初值。 *)
Definition store_mutex_publish_ready
    (stable : MutexStable) (before : MutexState) (p : addr) (id : Z)
    : Assertion :=
  store_mutex_id_manager stable (mutex_reserve_state before p id) **
  store_mutex_registry stable before **
  store_mutex_publish_ready_private p.

(** IdRemoveObj 完成但 registry link 尚未移除的嵌入 ID-node。 *)
Definition store_mutex_removed_id_node (p : addr) : Assertion :=
  “ p <> 0 ” &&
  &(p # "Mutex" ->ₛ "id" .ₛ "id") # UShort |-> 65535 **
  store_mutex_dll (fun _ (_ : unit) => emp)
    (&(p # "Mutex" ->ₛ "id" .ₛ "link")) nil.

(**
  [IdRemoveObj] 已更新 manager，但 [mutex->link] 仍在 [k_mutex_list]；
  该中间谓词精确分开已归还的 ID-node 与仍由 registry 拥有的对象主体。
*)
Definition store_mutex_id_removed_registered
    (stable : MutexStable) (before : MutexState) (object : MutexObject)
    : Assertion :=
  store_mutex_id_manager stable (mutex_delete_state before object) **
  store_mutex_registry stable before **
  store_mutex_removed_id_node object.(mutex_addr).

(**
  Delete 已清空 pending 并从两个容器移除后交给 x_free 的完整对象；
  [id.id] 的 -1 写入按 uint16 表示为 65535，两个 intrusive link 均为自环。
*)
Definition store_mutex_detached (object : MutexObject) : Assertion :=
  let p := object.(mutex_addr) in
  “ p <> 0 /\ object.(mutex_pending_addrs) = nil ” &&
  &(p # "Mutex" ->ₛ "id" .ₛ "id") # UShort |-> 65535 **
  store_mutex_dll (fun _ (_ : unit) => emp)
    (&(p # "Mutex" ->ₛ "id" .ₛ "link")) nil **
  &(p # "Mutex" ->ₛ "val") # UShort |-> object.(mutex_value) **
  &(p # "Mutex" ->ₛ "recursive_cnt") # UChar
    |-> object.(mutex_recursive_count) **
  &(p # "Mutex" ->ₛ "origin_prio") # UChar
    |-> object.(mutex_origin_priority) **
  &(p # "Mutex" ->ₛ "holder") # Ptr |-> object.(mutex_holder_addr) **
  store_mutex_pending_list (&(p # "Mutex" ->ₛ "pend_list")) nil **
  store_mutex_dll (fun _ (_ : unit) => emp)
    (&(p # "Mutex" ->ₛ "link")) nil.

(**
  mutex 对 task 的 holder/waiter 关联。两个参数由 task/scheduler 模块解释；
  此纯 bridge 不拥有 task 字段，也不把 task state 复制进 [MutexState]。
*)
Definition mutex_task_bridge (state : MutexState)
    (holder_is_live waiter_is_suspendable : addr -> Prop) : Prop :=
  (forall object,
    In object state.(mutex_objects) -> object.(mutex_holder_addr) <> 0 ->
    holder_is_live object.(mutex_holder_addr)) /\
  (forall task,
    In task (mutex_all_pending state.(mutex_objects)) ->
    waiter_is_suspendable task).

(**
  Debug guard 归一为直接调用 [GetIsrCounter] 后借用的跨模块字段。
  它拥有 [isrManager.isr_count] 两字节，但不属于 [mutex_inv]；caller 必须
  从 ISR 模块取得并原样归还。done-table pointer 不因 direct-call 归一而拥有。
*)
Definition store_mutex_debug_isr_counter (counter : Z) : Assertion :=
  “ 0 <= counter <= 65535 ” &&
  &(&("isrManager") ->ₛ "isr_count")
    # UShort |-> counter.

(** [AllocId] 成功后的瞬时 manager：bitmap 已置首个空闲 bit，bucket 未改。 *)
Definition store_mutex_manager_id_allocated
    (stable : MutexStable) (before : MutexState) (id : Z) : Assertion :=
  let manager := stable.(mutex_manager_addr) in
  “ mutex_first_free stable before = Some id ” &&
  &(manager # "IdManager" ->ₛ "id_max") # UShort
    |-> stable.(mutex_id_limit) **
  &(manager # "IdManager" ->ₛ "hoffset") # UShort
    |-> stable.(mutex_bucket_count) **
  &(manager # "IdManager" ->ₛ "id_map") # Ptr
    |-> stable.(mutex_bitmap_addr) **
  &(manager # "IdManager" ->ₛ "htable") # Ptr
    |-> stable.(mutex_buckets_addr) **
  store_mutex_bitmap_ids stable (id :: mutex_ids before.(mutex_objects)) **
  store_mutex_buckets stable before.

(** IdInsertObj 写入 id 后、InsertObj 接管嵌入 link 前的精确节点资源。 *)
Definition store_mutex_id_node_insert_ready (p : addr) (id : Z) : Assertion :=
  “ p <> 0 /\ 0 <= id < MUTEX_ID_MAX ” &&
  &(p # "Mutex" ->ₛ "id" .ₛ "id") # UShort |-> id **
  &(p # "Mutex" ->ₛ "id" .ₛ "link" .ₛ "node_prev") # Ptr |->_ **
  &(p # "Mutex" ->ₛ "id" .ₛ "link" .ₛ "node_next") # Ptr |->_.
