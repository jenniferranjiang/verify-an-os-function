Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Sorting.Permutation.
From AUXLib Require Import ListLib.
From SimpleC.SL Require Import Mem.

Import ListNotations.

Local Open Scope Z_scope.

(** ID node 的业务抽象只有 ID 与外层嵌入对象地址。 *)
Record IdNodeAbs : Type := Build_IdNodeAbs {
  id_node_id : Z;
  id_node_addr : addr;
}.

(** ID manager 初始化后不变的容量和两个外部地址。 *)
Record StableIdManager : Type := Build_StableIdManager {
  id_manager_max : Z;
  id_manager_bucket_count : Z;
  id_manager_bitmap_addr : addr;
  id_manager_buckets_addr : addr;
}.

(**
  bucket 的 [None] 对应 BSS `(NULL,NULL)`；[Some nil] 对应已经 lazy-init
  的空 circular DLL；[Some nodes] 保存实际 intrusive nodes。
*)
Definition IdBucket : Type := option (list IdNodeAbs).

Record IdManagerState : Type := Build_IdManagerState {
  id_manager_ids : list Z;
  id_manager_buckets : list IdBucket;
}.

Definition id_bucket_nodes (bucket : IdBucket) : list IdNodeAbs :=
  match bucket with
  | None => nil
  | Some nodes => nodes
  end.

Definition id_manager_nodes (st : IdManagerState) : list IdNodeAbs :=
  concat (map id_bucket_nodes st.(id_manager_buckets)).

Definition id_manager_node_ids (nodes : list IdNodeAbs) : list Z :=
  map id_node_id nodes.

Definition id_manager_node_addrs (nodes : list IdNodeAbs) : list addr :=
  map id_node_addr nodes.

Definition id_manager_id_used (id : Z) (st : IdManagerState) : Prop :=
  In id st.(id_manager_ids).

Fixpoint id_buckets_index_wf
    (bucket_count index : Z) (buckets : list IdBucket) : Prop :=
  match buckets with
  | nil => True
  | bucket :: rest =>
      Forall
        (fun node => node.(id_node_id) mod bucket_count = index)
        (id_bucket_nodes bucket) /\
      id_buckets_index_wf bucket_count (index + 1) rest
  end.

(**
  [id_manager_state_wf] 连接 ID list、bitmap 语义和 lazy bucket 内容：ID
  唯一且在范围内，每个 node 地址非零且位于正确 bucket，全部 node ID 与
  allocated ID list 互为排列。
*)
Definition id_manager_state_wf
    (sm : StableIdManager) (st : IdManagerState) : Prop :=
  0 < sm.(id_manager_max) <= 65535 /\
  0 < sm.(id_manager_bucket_count) <= sm.(id_manager_max) /\
  sm.(id_manager_bitmap_addr) <> 0 /\
  sm.(id_manager_buckets_addr) <> 0 /\
  Zlength st.(id_manager_buckets) = sm.(id_manager_bucket_count) /\
  Forall (fun id => 0 <= id < sm.(id_manager_max)) st.(id_manager_ids) /\
  NoDup st.(id_manager_ids) /\
  Forall
    (fun node =>
      0 <= node.(id_node_id) < sm.(id_manager_max) /\
      node.(id_node_addr) <> 0)
    (id_manager_nodes st) /\
  NoDup (id_manager_node_addrs (id_manager_nodes st)) /\
  id_buckets_index_wf sm.(id_manager_bucket_count) 0
    st.(id_manager_buckets) /\
  Permutation
    (id_manager_node_ids (id_manager_nodes st))
    st.(id_manager_ids).

(** bitmap 每个有效 bit 当且仅当相应 ID 已 allocated。 *)
Definition id_manager_bitmap_bytes_wf
    (sm : StableIdManager) (st : IdManagerState)
    (bytes : list Z) : Prop :=
  Zlength bytes = (sm.(id_manager_max) + 7) / 8 /\
  Forall (fun byte => 0 <= byte <= 255) bytes /\
  forall id,
    0 <= id < sm.(id_manager_max) ->
    (id_manager_id_used id st <->
     Z.testbit (Znth (id / 8) bytes 0) (id mod 8) = true).

(** [AllocId] 成功时选择从零开始的最小空闲 ID。 *)
Definition id_manager_min_free_id
    (sm : StableIdManager) (st : IdManagerState) (id : Z) : Prop :=
  0 <= id < sm.(id_manager_max) /\
  ~ id_manager_id_used id st /\
  forall earlier,
    0 <= earlier < id -> id_manager_id_used earlier st.

Definition id_manager_full
    (sm : StableIdManager) (st : IdManagerState) : Prop :=
  forall id,
    0 <= id < sm.(id_manager_max) -> id_manager_id_used id st.

(** bitmap 已置位但 node 尚未进入 bucket 的真实 [AllocId] 中间态。 *)
Definition id_manager_after_alloc
    (st : IdManagerState) (id : Z) : IdManagerState :=
  Build_IdManagerState (id :: st.(id_manager_ids)) st.(id_manager_buckets).

Definition id_manager_bucket_index
    (sm : StableIdManager) (id : Z) : Z :=
  id mod sm.(id_manager_bucket_count).

(**
  [InsertObj] 对未初始化 bucket 先 lazy-init，再把 node 插在 head 之后；
  对已初始化 bucket 直接 prepend。
*)
Definition id_manager_insert_bucket
    (sm : StableIdManager) (st : IdManagerState)
    (node : IdNodeAbs) : list IdBucket :=
  let index := id_manager_bucket_index sm node.(id_node_id) in
  let old := Znth index st.(id_manager_buckets) None in
  replace_Znth index (Some (node :: id_bucket_nodes old))
    st.(id_manager_buckets).

Definition id_manager_after_link
    (sm : StableIdManager) (st : IdManagerState)
    (node : IdNodeAbs) : IdManagerState :=
  Build_IdManagerState st.(id_manager_ids)
    (id_manager_insert_bucket sm st node).

(** [IdInsertObj] 成功的组合状态：先 allocate bit，再 link bucket。 *)
Definition id_manager_after_insert
    (sm : StableIdManager) (st : IdManagerState)
    (id : Z) (node_addr : addr) : IdManagerState :=
  id_manager_after_link sm (id_manager_after_alloc st id)
    (Build_IdNodeAbs id node_addr).
