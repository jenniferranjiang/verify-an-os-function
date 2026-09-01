Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Export CRTOS_Verify.lib.SemaphoreCritical.

Import ListNotations.

Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

(**
  [DllNode] 把 intrusive DLL 中由容器决定的 link 地址与 payload 的纯
  抽象值配对。link 的两个指针由容器 spine 拥有，payload predicate
  只能拥有外层对象的其余互不重叠字段。
*)
Record DllNode (A : Type) : Type := Build_DllNode {
  dll_payload : A;
  dll_link_addr : addr;
}.

Arguments Build_DllNode {A} _ _.
Arguments dll_payload {A} _.
Arguments dll_link_addr {A} _.

(** 每个 intrusive link 都必须是可解引用的非空地址。 *)
Definition dll_nodes_nonzero {A : Type} (nodes : list (DllNode A)) : Prop :=
  Forall (fun node => node.(dll_link_addr) <> 0) nodes.

(**
  [dllseg] 描述从 [current] 到 [stop] 的双向链表段。每个节点同时保存
  与前驱一致的 prev、指向后继的 next，并委托 payload predicate 拥有
  非 link 字段。
*)
Definition dllseg {A : Type}
    (store_payload : addr -> A -> Assertion)
    (current previous stop stop_previous : addr)
    (nodes : list (DllNode A)) : Assertion :=
  (fix go current previous stop stop_previous nodes :=
     match nodes with
     | nil => “ current = stop /\ previous = stop_previous ” && emp
     | node :: rest =>
         EX next : addr,
           “ current = node.(dll_link_addr) ” &&
           store_payload current node.(dll_payload) **
           &(current # "SysDoubleLinklistNode" ->ₛ "node_prev")
             # Ptr |-> previous **
           &(current # "SysDoubleLinklistNode" ->ₛ "node_next")
             # Ptr |-> next **
           go next current stop stop_previous rest
     end) current previous stop stop_previous nodes.

(**
  [store_dll] 拥有 circular list head、全部 spine 指针及每个 payload。
  空表退化为 head 的 next/prev 都指回自身。
*)
Definition store_dll {A : Type}
    (store_payload : addr -> A -> Assertion)
    (head : addr) (nodes : list (DllNode A)) : Assertion :=
  EX first last : addr,
    “ head <> 0 /\ dll_nodes_nonzero nodes ” &&
    &(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> last **
    &(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> first **
    dllseg store_payload first head head last nodes.

(** 尚未初始化的 DLL 节点只提供两个可写指针槽，不承诺旧值。 *)
Definition store_dll_node_uninitialized (node : addr) : Assertion :=
  “ node <> 0 ” &&
  &(node # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |->_ **
  &(node # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |->_.

(** [memset] 后的 DLL 节点具体保存两个空指针，尚不是合法 circular list。 *)
Definition store_dll_node_zeroed (node : addr) : Assertion :=
  “ node <> 0 ” &&
  &(node # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> 0 **
  &(node # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> 0.

(**
  [store_dll_node_standalone] 表示 [InitDoubleLinkList] 建立的单节点自环；
  插入容器后这两个槽的 ownership 必须整体转给新的 [store_dll]。
*)
Definition store_dll_node_standalone (node : addr) : Assertion :=
  “ node <> 0 ” &&
  &(node # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> node **
  &(node # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> node.

(** 在普通节点后插入时，只改变纯节点顺序；head 自身不在 [nodes] 中。 *)
Fixpoint dll_insert_after_node {A : Type}
    (focus : addr) (new_node : DllNode A)
    (nodes : list (DllNode A)) : option (list (DllNode A)) :=
  match nodes with
  | nil => None
  | node :: rest =>
      if Z.eq_dec node.(dll_link_addr) focus
      then Some (node :: new_node :: rest)
      else
        match dll_insert_after_node focus new_node rest with
        | None => None
        | Some updated => Some (node :: updated)
        end
  end.

(**
  [dll_insert_after] 是 [DoubleLinkListInsertNodeAfter] 的抽象 effect：focus
  为 head 时 prepend，否则必须在现有 spine 中唯一找到 focus。
*)
Definition dll_insert_after {A : Type}
    (head focus : addr) (new_node : DllNode A)
    (before after : list (DllNode A)) : Prop :=
  (focus = head /\ after = new_node :: before) \/
  (focus <> head /\ dll_insert_after_node focus new_node before = Some after).
