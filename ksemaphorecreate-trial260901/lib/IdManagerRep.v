Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Export CRTOS_Verify.lib.IdManagerPure.
Require Export CRTOS_Verify.lib.DoublyLinkedList.

Import ListNotations.

Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

Definition id_node_link (node_addr : addr) : addr :=
  &(node_addr # "IdNode" ->ₛ "link").

(** ID bucket payload 拥有 [idnode->id]，DLL spine 拥有两个 link 指针。 *)
Definition store_id_node_payload
    (link : addr) (node : IdNodeAbs) : Assertion :=
  let node_addr := node.(id_node_addr) in
  “ link = id_node_link node.(id_node_addr) /\
    node.(id_node_addr) <> 0 ” &&
  &(node_addr # "IdNode" ->ₛ "id")
    # UShort |-> node.(id_node_id).

Definition id_node_to_dll (node : IdNodeAbs) : DllNode IdNodeAbs :=
  Build_DllNode node (id_node_link node.(id_node_addr)).

Definition id_nodes_to_dll
    (nodes : list IdNodeAbs) : list (DllNode IdNodeAbs) :=
  map id_node_to_dll nodes.

(** 新对象交给 [IdInsertObj] 前拥有 id 槽和两个可写 link 槽。 *)
Definition store_id_node_insert_ready (node_addr : addr) : Assertion :=
  “ node_addr <> 0 ” &&
  &(node_addr # "IdNode" ->ₛ "id") # UShort |->_ **
  store_dll_node_uninitialized (id_node_link node_addr).

(** [AllocId] 写入 ID 后、尚未插入 bucket 的 node ownership。 *)
Definition store_id_node_unlinked (node : IdNodeAbs) : Assertion :=
  let node_addr := node.(id_node_addr) in
  “ node.(id_node_addr) <> 0 ” &&
  &(node_addr # "IdNode" ->ₛ "id")
    # UShort |-> node.(id_node_id) **
  store_dll_node_uninitialized (id_node_link node.(id_node_addr)).

Definition store_id_bucket (head : addr) (bucket : IdBucket) : Assertion :=
  match bucket with
  | None => store_dll_node_zeroed head
  | Some nodes =>
      store_dll store_id_node_payload head (id_nodes_to_dll nodes)
  end.

(** 连续 bucket-head 数组的真实元素递归。 *)
Fixpoint store_id_buckets_from
    (base : addr) (index : Z) (buckets : list IdBucket) : Assertion :=
  match buckets with
  | nil => emp
  | bucket :: rest =>
      store_id_bucket
        (base + index * sizeof("SysDoubleLinklistNode")) bucket **
      store_id_buckets_from base (index + 1) rest
  end.

Definition store_id_manager_bitmap
    (sm : StableIdManager) (st : IdManagerState) : Assertion :=
  EX bytes : list Z,
    “ id_manager_bitmap_bytes_wf sm st bytes ” &&
    UCharArray.full sm.(id_manager_bitmap_addr)
      ((sm.(id_manager_max) + 7) / 8) bytes.

(**
  [store_id_manager] 是 manager 的稳定完整 representation，包含四字段、
  bitmap、连续 bucket heads 以及所有已链接 ID nodes。
*)
Definition store_id_manager
    (sm : StableIdManager) (st : IdManagerState)
    (manager : addr) : Assertion :=
  “ manager <> 0 /\ id_manager_state_wf sm st ” &&
  &(manager # "IdManager" ->ₛ "id_max")
    # UShort |-> sm.(id_manager_max) **
  &(manager # "IdManager" ->ₛ "hoffset")
    # UShort |-> sm.(id_manager_bucket_count) **
  &(manager # "IdManager" ->ₛ "id_map")
    # Ptr |-> sm.(id_manager_bitmap_addr) **
  store_id_manager_bitmap sm st **
  &(manager # "IdManager" ->ₛ "htable")
    # Ptr |-> sm.(id_manager_buckets_addr) **
  store_id_buckets_from sm.(id_manager_buckets_addr) 0
    st.(id_manager_buckets).

(**
  [AllocId] 成功后 bitmap 已加入最小空闲 ID，而 buckets 暂时保持旧状态；
  该 predicate 只能交给后续 [InsertObj]，不能冒充完整 manager invariant。
*)
Definition store_id_manager_allocated_unlinked
    (sm : StableIdManager) (before : IdManagerState)
    (manager : addr) (id : Z) : Assertion :=
  “ manager <> 0 /\ id_manager_state_wf sm before /\
    id_manager_min_free_id sm before id ” &&
  &(manager # "IdManager" ->ₛ "id_max")
    # UShort |-> sm.(id_manager_max) **
  &(manager # "IdManager" ->ₛ "hoffset")
    # UShort |-> sm.(id_manager_bucket_count) **
  &(manager # "IdManager" ->ₛ "id_map")
    # Ptr |-> sm.(id_manager_bitmap_addr) **
  store_id_manager_bitmap sm (id_manager_after_alloc before id) **
  &(manager # "IdManager" ->ₛ "htable")
    # Ptr |-> sm.(id_manager_buckets_addr) **
  store_id_buckets_from sm.(id_manager_buckets_addr) 0
    before.(id_manager_buckets).

(**
  [InsertObj] 的入口把 bitmap-only manager 中间态与已经写入 ID 的 standalone
  node 组合；成功后两者整体折叠为完整 [store_id_manager]。
*)
Definition store_id_manager_insert_ready
    (sm : StableIdManager) (before : IdManagerState)
    (manager : addr) (id : Z) (node_addr : addr) : Assertion :=
  store_id_manager_allocated_unlinked sm before manager id **
  store_id_node_unlinked (Build_IdNodeAbs id node_addr).
