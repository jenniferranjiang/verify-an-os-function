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

Lemma guarded_resume_commit__atomic_exit :
  forall id p before locked waiting current X,
    event_delete_gap id p false before locked ->
    event_pending_at id p waiting locked ->
    event_resume_all_effect p waiting locked current ->
    monadesafe_lib.safeExec (LastSeen before) (abs_event_resume_all id p) X ->
    monadesafe_lib.safeExec (LastSeen current) (MonadErr.ret tt) X.
Proof.
  intros id p before locked waiting current X [Hrely Hguard] Hpending Heffect
    [states [Hstates Hsafe]].
  unfold monadesafe_lib.safe, MonadErrHoare.weakestpre in Hsafe.
  destruct Hsafe as [Hnoerr Hnormal].
  exists (Crtos_RTrans current).
  split.
  - unfold LastSeen. change (forall st, Crtos_RTrans current st <-> Crtos_RTrans current st). tauto.
  - unfold monadesafe_lib.safe, MonadErrHoare.weakestpre. simpl.
    split; [tauto|].
    intros result next [Hr Hnext]. subst result next.
    apply Hnormal.
    unfold abs_event_resume_all, event_delete_atomic_cmd,
      abs_event_resume_all_locked. simpl.
    exists locked, current. split.
    + apply (proj2 (Hstates locked)). exact Hrely.
    + split; [exact Hguard|].
      split.
      * exists waiting. auto.
      * change (forall st, Crtos_RTrans current st <-> Crtos_RTrans current st). tauto.
Qed.
