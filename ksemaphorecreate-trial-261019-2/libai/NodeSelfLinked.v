Require Import Coq.ZArith.ZArith.
Require Import Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import CRTOS_Verify.lib.CrtosRules.

Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

(** 对应 double_link.c 的初始化/脱链后的两个指针槽。
    使用本 trial CrtosRules 的同一全局 assertion carrier；不复制token或实例。
    仅拥有链表节点的两个字段，不拥有外围对象/payload或另外的链表链接。 *)
Definition store_node_self_linked (node : addr) : Assertion :=
  &(node # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> node **
  &(node # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> node.
