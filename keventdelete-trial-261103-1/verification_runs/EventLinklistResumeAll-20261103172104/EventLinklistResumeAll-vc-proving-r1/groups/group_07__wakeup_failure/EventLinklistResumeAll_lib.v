From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.
Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.KEventDelete.
Import ListNotations DLL IDNode MonadErr.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

(** 循环借出等待哨兵next单元后，归还同值即可恢复同一个os_inv。
    此wand是空间资源，不是额外可信事实；拆出义务由which implies生成。 *)
Definition event_resume_next_restore (sg : StableGlobalState) (st : VarGlobalState)
    (head next : addr) : Assertion :=
  (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next) -* os_inv sg st.

(** 写入exstatus后的归还视图，st已经是只更新该描述符exstatus的新状态。 *)
Definition event_resume_exstatus_restore (sg : StableGlobalState) (st : VarGlobalState)
    (task value : Z) : Assertion :=
  (&(task # "TaskDescriptor" ->ₛ "exstatus") # Int |-> value) -* os_inv sg st.

(** task ID只读；归还同值恢复当前os_inv以满足通用KTaskWakeup合同。 *)
Definition event_resume_id_restore (sg : StableGlobalState) (st : VarGlobalState)
    (task id : Z) : Assertion :=
  (&(task # "TaskDescriptor" ->ₛ "id" .ₛ "id") # UShort |-> id) -* os_inv sg st.

(** 已处理前缀的数学进度：完成当前剩余队列的整体效果，足以完成原waiting
    的整体效果。不重定义逐步唤醒或公共批量语义，不包含堆所有权。 *)
Definition event_resume_remaining_effect (p : addr) (waiting : list addr)
    (before : VarGlobalState) (remaining : list addr) (current : VarGlobalState) : Prop :=
  forall after,
    event_resume_all_effect p remaining current after ->
    event_resume_all_effect p waiting before after.

Lemma idnode_address_unique__wakeup_failure : forall nodes id a b,
  NoDup (idnode_ids nodes) ->
  In (Build_IdNodeAbs id a) nodes ->
  In (Build_IdNodeAbs id b) nodes -> a = b.
Proof.
  intros nodes id a b.
  induction nodes as [|node nodes IH]; simpl; intros Hnd Ha Hb;
    [contradiction|].
  inversion Hnd as [|x xs Hnot Hndtail].
  destruct Ha as [Ha|Ha]; destruct Hb as [Hb|Hb].
  - congruence.
  - subst node. exfalso. apply Hnot.
    change (In id (map idnode_id nodes)).
    apply in_map_iff. exists (Build_IdNodeAbs id b).
    split; [reflexivity|exact Hb].
  - subst node. exfalso. apply Hnot.
    change (In id (map idnode_id nodes)).
    apply in_map_iff. exists (Build_IdNodeAbs id a).
    split; [reflexivity|exact Ha].
  - eapply IH; eauto.
Qed.
