(** VRTOS contract vocabulary; origin pinned in checks/spec-alignment.json.
    Only the DLL import is rebound to this trial. This is not a C helper proof. *)
Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
From SimpleC.SL Require Import Mem.

Require Import TrialShared.dll.

Import ListNotations.

Local Open Scope Z_scope.
Local Open Scope list.

(**
  2026-09-22 审核说明：下述来源说明仅针对历史提交 6c0dae7。
  当前 ../crtosverify 的人工审核规格已经是多态、保留 payload 的接口，
  不能再把本文件中的旧迁移认作与当前审核规格完全一致。
  _StartupKTask 的直接删除操作改选审核 detached case；其他历史调用点
  的 carrier/谓词迁移问题见本轮 startup Spec 报告，不修改上游规格。

  本文件给出双向链表插入函数规格使用的纯列表变换。其行为来源于
  [../crtosverify] 的 [double_linklist] 分支提交 [6c0dae7] 中已经验证的
  [DoubleLinkListInsertNodeBefore/After] dispatch 规格。上游规格使用
  payload-free 的地址列表 [xizi_dll]；这里按当前项目的表示迁移为多态
  [DL_Node A]，从而在插入前后保留 [store_dll] payload 的所有权。

  不能直接复制上游 [xizi_double_link_lib.v]：它的地址专用谓词会丢失
  [store_delay_info]，并且其 layout module 使用当前项目禁止的占位声明。
  因此这里迁移经过验证的纯序列语义和公开调用边界，
  同时保留本项目当前版本的 [dll.v] 与 [idnode.v]。

  本文件不定义新的链表内存谓词；链表、节点和 payload 内存仍分别由
  [store_dll]、[occupy_dll_node] 和调用者提供的 [storeA] 表示。
*)

(**
  [dll_insert_anchor head nodes anchor] 表示 C 插入位置合法：它或者是
  [nodes] 中某个链表节点的地址，或者是循环链表哨兵 [head]。哨兵不是
  抽象节点列表的元素；Before 在哨兵前插入等价于尾插，After 在哨兵后
  插入等价于头插。
*)
Definition dll_insert_anchor {A : Type}
    (head : addr)
    (nodes : list (DL_Node A))
    (anchor : addr) : Prop :=
  In anchor (map (fun node => getPtr node) nodes) \/ anchor = head.

(**
  在第一个地址等于 [anchor] 的普通节点之前插入 [inserted]。若递归到
  列表末尾，则把节点追加到末尾；在合法 anchor 前提下，这个末尾分支
  对应 Before 的哨兵情形。
*)
Fixpoint dll_insert_before_member {A : Type}
    (nodes : list (DL_Node A))
    (anchor : addr)
    (inserted : DL_Node A) : list (DL_Node A) :=
  match nodes with
  | nil => inserted :: nil
  | current :: rest =>
      if Z.eq_dec (getPtr current) anchor
      then inserted :: current :: rest
      else current :: dll_insert_before_member rest anchor inserted
  end.

(**
  [DoubleLinkListInsertNodeBefore] 的完整纯序列语义。anchor 为哨兵时尾插；
  否则在第一个匹配的普通节点之前插入。
*)
Definition dll_insert_before_dispatch {A : Type}
    (head : addr)
    (nodes : list (DL_Node A))
    (anchor : addr)
    (inserted : DL_Node A) : list (DL_Node A) :=
  if Z.eq_dec anchor head
  then nodes ++ inserted :: nil
  else dll_insert_before_member nodes anchor inserted.

(**
  在第一个地址等于 [anchor] 的普通节点之后插入 [inserted]。anchor 不在
  列表中时保持原列表；公开规格的 [dll_insert_anchor] 会排除该普通节点
  缺失情形。
*)
Fixpoint dll_insert_after_member {A : Type}
    (nodes : list (DL_Node A))
    (anchor : addr)
    (inserted : DL_Node A) : list (DL_Node A) :=
  match nodes with
  | nil => nil
  | current :: rest =>
      if Z.eq_dec (getPtr current) anchor
      then current :: inserted :: rest
      else current :: dll_insert_after_member rest anchor inserted
  end.

(**
  [DoubleLinkListInsertNodeAfter] 的完整纯序列语义。anchor 为哨兵时头插；
  否则在第一个匹配的普通节点之后插入。
*)
Definition dll_insert_after_dispatch {A : Type}
    (head : addr)
    (nodes : list (DL_Node A))
    (anchor : addr)
    (inserted : DL_Node A) : list (DL_Node A) :=
  if Z.eq_dec anchor head
  then inserted :: nodes
  else dll_insert_after_member nodes anchor inserted.
