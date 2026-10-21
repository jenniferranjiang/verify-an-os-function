Require Import Coq.ZArith.ZArith.

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
