
From SimpleC.SL Require Import SeparationLogic.

Record DL_Node (A: Type): Type :=
  Build_DL_Node {
    getData: A;
    getPtr: addr;
  }.

Arguments getData {A} _.
Arguments getPtr {A} _.
Arguments Build_DL_Node {A} _ _.


Notation "x '.(data)'" := (getData x) (at level 1).
Notation "x '.(ptr)'" := (getPtr x) (at level 1).