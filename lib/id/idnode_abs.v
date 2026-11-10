Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.

From AUXLib Require Import ListLib.
From SimpleC.SL Require Import SeparationLogic.

Record StableIdmanager: Type :=
  Build_StableIdmanager {
    idmax: Z;
    hoffset: Z;
    id_map: addr;
    htable: addr;
  }.

Record IdNodeAbs: Type :=
  Build_IdNodeAbs {
    idnode_id: Z;
    idnode_addr: addr;
  }.

Record VarIdmanager: Type :=
  Build_VarIdmanager {
    idlist: list Z;
    idbuckets: list (list IdNodeAbs);
  }.

Arguments Build_StableIdmanager _ _ _ _ : assert.
Arguments Build_IdNodeAbs _ _ : assert.
Arguments Build_VarIdmanager _ _ : assert.

Notation "x '.(idmax)'" := (idmax x) (at level 1).
Notation "x '.(hoffset)'" := (hoffset x) (at level 1).
Notation "x '.(id_map)'" := (id_map x) (at level 1).
Notation "x '.(htable)'" := (htable x) (at level 1).
Notation "x '.(idnode_id)'" := (idnode_id x) (at level 1).
Notation "x '.(idnode_addr)'" := (idnode_addr x) (at level 1).
Notation "x '.(idlist)'" := (idlist x) (at level 1).
Notation "x '.(idbuckets)'" := (idbuckets x) (at level 1).

(**
  以下六个纯函数从 idnode.v 原样移入 ID 抽象层，不拥有 C 内存，
  也不依赖 store_node_self_linked 或 ID 管理器的空间谓词。
  NodeSelfLinked.v 因而可以证明 ID 插入后的查询性质，而 idnode.v
  仍可复用自环节点谓词，不形成循环依赖。

  idnode.v 在既有 Module IDNode 中 Include IDNodePure，保留原来的
  IDNode.idmanager_link 等限定名称；记录、函数参数和计算公式均不变。
*)
Module IDNodePure.

Local Open Scope Z_scope.
Local Open Scope list_scope.

Definition id_in_ids (id: Z) (ids: list Z): bool :=
  if in_dec Z.eq_dec id ids then true else false.

Definition idlist_add (id: Z) (ids: list Z): list Z :=
  id :: ids.

Definition idmanager_add (idm: VarIdmanager) (id: Z): VarIdmanager :=
  Build_VarIdmanager (idlist_add id idm.(idlist)) idm.(idbuckets).

Definition idmanager_insert_bucket
  (hoffset id: Z) (p: addr)
  (buckets: list (list IdNodeAbs)): list (list IdNodeAbs) :=
  let index := id mod hoffset in
  replace_Znth index
    (Build_IdNodeAbs id p :: Znth index buckets nil) buckets.

Definition idmanager_link
  (sidm: StableIdmanager) (idm: VarIdmanager)
  (id: Z) (p: addr): VarIdmanager :=
  Build_VarIdmanager
    idm.(idlist)
    (idmanager_insert_bucket sidm.(hoffset) id p idm.(idbuckets)).

Definition idmanager_query (idm: VarIdmanager) (id: Z): bool :=
  id_in_ids id idm.(idlist).

End IDNodePure.
