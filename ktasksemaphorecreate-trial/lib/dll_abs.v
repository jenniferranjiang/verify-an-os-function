
From SimpleC.SL Require Import SeparationLogic.

(**
  本文件逐字复用 CRTOS Task lib revision [8e01372] 的双链表纯节点类型。
  它只记录 payload 与嵌入链表节点地址，不拥有 C 内存。
*)

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
