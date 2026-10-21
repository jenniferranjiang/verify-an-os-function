Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.

Require Import CRTOS_Verify.lib.CrtosRules.
Require Import CRTOS_Verify.lib.dll.
Require Import CRTOS_Verify.lib.idnode_abs.

Import DLL.
Import IDNodePure.

Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

(**
  [store_node_self_linked x] 表示地址 [x] 处的
  [SysDoubleLinklistNode] 已形成自环：node_prev 与 node_next 都指向 [x]。
  它恰好拥有这两个指针槽，不拥有外围对象的 payload、padding 或其他字段，
  也不额外添加 [x <> 0] 等纯事实；调用方原有的非空条件仍须单独保留。

  本定义供 inactive Delay、脱链 ID 节点以及调度节点复用，避免重复
  书写指针槽；不依赖 ID 管理器的空间谓词，保持共享依赖方向无环。
  QCP 在读取具体字段前可通过局部 [which implies] 展开这两个槽；聚合
  Spec 和资源谓词应复用本定义，不必展开整个外围对象。
*)
Definition store_node_self_linked (x : addr) : Assertion :=
  &(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> x **
  &(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> x.

Lemma store_node_self_linked_occupy :
  forall x, store_node_self_linked x |-- occupy_dll_node x.
Proof.
  intros x.
  unfold store_node_self_linked, occupy_dll_node.
  Exists x x.
  cancel.
Qed.

(**
  下面两个引理仅在 Rocq 中连接 C 注解产生的“扁平嵌套
  字段”取址与 [IdNode.link] 作为独立双链表节点时的取址。
  它们不提供内存所有权，也不假定具体数值偏移。
*)
Lemma idnode_link_node_prev_addr :
  forall p,
    &(p # "IdNode" ->ₛ "link" .ₛ "node_prev") =
    let link := &(p # "IdNode" ->ₛ "link") in
    &(link # "SysDoubleLinklistNode" ->ₛ "node_prev").
Proof.
  intros p; simpl.
  rewrite addr_of_arrow_field.
  rewrite eval_addr.
  reflexivity.
Qed.

Lemma idnode_link_node_next_addr :
  forall p,
    &(p # "IdNode" ->ₛ "link" .ₛ "node_next") =
    let link := &(p # "IdNode" ->ₛ "link") in
    &(link # "SysDoubleLinklistNode" ->ₛ "node_next").
Proof.
  intros p; simpl.
  rewrite addr_of_arrow_field.
  rewrite eval_addr.
  reflexivity.
Qed.

(**
  [idmanager_link] 在抽象 ID 列表中保留了刚申请的 ID。本引理只依赖
  [idnode_abs] 的纯操作，不导入依赖本文件的 ID 管理器空间谓词。
  这些操作也由既有 [IDNode] 接口包含，因此调用方无需改变逻辑状态。
*)
Lemma idmanager_link_query :
  forall sidm idm id p,
    idmanager_query
      (idmanager_link sidm (idmanager_add idm id) id p) id = true.
Proof.
  intros sidm idm id p.
  change ((if in_dec Z.eq_dec id (id :: idlist idm) then true else false) = true).
  destruct (in_dec Z.eq_dec id (id :: idlist idm)) as [_ | Habsent].
  - reflexivity.
  - exfalso; apply Habsent; left; reflexivity.
Qed.
