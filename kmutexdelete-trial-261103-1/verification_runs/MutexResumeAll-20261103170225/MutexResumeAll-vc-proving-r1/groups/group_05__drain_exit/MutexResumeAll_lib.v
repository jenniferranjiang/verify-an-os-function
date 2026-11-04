From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.
From Coq Require Import Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.KMutexDelete.
Local Open Scope string.
Local Open Scope sac.

(** 等待哨兵next的借出/归还资源：wand不能被当成可复制的纯事实。 *)
Definition mutex_resume_next_restore (sg : StableGlobalState) (st : VarGlobalState)
    (head next : addr) : Assertion :=
  (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next) -* os_inv sg st.

(** 写exstatus后恢复新的task-map索引全局资源；构造此wand必须证明关联保持。 *)
Definition mutex_resume_exstatus_restore (sg : StableGlobalState) (st : VarGlobalState)
    (task value : Z) : Assertion :=
  (&(task # "TaskDescriptor" ->ₛ "exstatus") # Int |-> value) -* os_inv sg st.

(** 任务ID只读字段，原值归还后重新得到完整os_inv，供Wakeup调用。 *)
Definition mutex_resume_id_restore (sg : StableGlobalState) (st : VarGlobalState)
    (task id : Z) : Assertion :=
  (&(task # "TaskDescriptor" ->ₛ "id" .ₛ "id") # UShort |-> id) -* os_inv sg st.

(** 剩余队列完成后的整体结果仍是原drain临界区的批量效果。
    复用已审阅逐步关系，不另定义一套执行链；初始化/保持均是显式VC义务。 *)
Definition mutex_resume_remaining_effect (p : addr) (waiting : list addr)
    (before : VarGlobalState) (remaining : list addr) (current : VarGlobalState) : Prop :=
  forall final,
    mutex_resume_all_steps p remaining current final ->
    mutex_resume_all_effect p waiting before final.

(** 批量效果只清目标pending；在非空分支选择原对象的map像，保留其ID。
    本证明不从两个可能不同的纯成员witness拼接身份，也不额外假设唯一性。 *)
Lemma resume_effect_keeps_drained_identity__drain_exit : forall before after original,
  In original (os_mutexes before) ->
  mutex_delete_live (mutex_addr original) (mutex_id original) before ->
  mutex_resume_all_effect (mutex_addr original) (mutex_pending_addrs original) before after ->
  mutex_delete_drained (mutex_addr original) (mutex_id original) after.
Proof.
  intros before after original Hin [Hp [Hid Hlive]] Heffect.
  unfold mutex_resume_all_effect in Heffect.
  destruct (mutex_pending_addrs original) as [|task tail] eqn:Hpending.
  - subst after. split; [exact Hp|]. split; [exact Hid|].
    exists original. repeat split; auto.
  - destruct Heffect as [_ [_ [ready_after [_ Hafter]]]].
    subst after. unfold mutex_delete_drained.
    split; [exact Hp|]. split; [exact Hid|].
    change (exists m,
      In m (mutex_delete_set_pending (mutex_addr original) [] (os_mutexes before)) /\ mutex_addr m = mutex_addr original /\ mutex_id m = mutex_id original /\ mutex_pending_addrs m = []).
    exists {| mutex_addr := mutex_addr original; mutex_id := mutex_id original;
      mutex_value := mutex_value original; mutex_recursive_count := mutex_recursive_count original;
      mutex_original_priority := mutex_original_priority original; mutex_holder := mutex_holder original;
      mutex_pending_addrs := [] |}.
    split.
    + unfold mutex_delete_set_pending. apply in_map_iff.
      exists original. split; [|exact Hin].
      destruct (Z.eq_dec (mutex_addr original) (mutex_addr original));
        [reflexivity|contradiction].
    + repeat split; reflexivity.
Qed.

(** 从本次具体加锁状态与真实批量效果构造受限操作的normal执行，
    经库的high-step规则保留原continuation。没有重建bind或新增safeExec前提。 *)
Lemma scoped_resume_safe_continuation__drain_exit : forall p id before locked original current X,
  Crtos_RTrans before locked ->
  mutex_delete_live p id locked ->
  In original (os_mutexes locked) -> mutex_addr original = p -> mutex_id original = id ->
  mutex_resume_all_effect p (mutex_pending_addrs original) locked current ->
  safeExec (LastSeen before) (abs_mutex_resume_all p id) X ->
  safeExec (LastSeen current) (MonadErr.ret tt) X.
Proof.
  intros p id before locked original current X Hrely Hlive Hin Haddr Hid Heffect Hsafe.
  eapply (highstependret_derive (abs_mutex_resume_all p id) (LastSeen before) tt
    (fun _ => LastSeen current)); [|exact Hsafe].
  intros states Hseen.
  exists (Crtos_RTrans current). split.
  - unfold abs_mutex_resume_all, mutex_delete_scoped_atomic.
    cbn [MonadErr.nrm].
    exists locked, current. split.
    + change (forall observed, states observed <-> Crtos_RTrans before observed) in Hseen.
      apply (proj2 (Hseen locked)). exact Hrely.
    + split; [exact Hlive|]. split.
      * cbn [abs_mutex_resume_all_locked MonadErr.nrm].
        exists original. repeat split; assumption.
      * intro observed. reflexivity.
  - unfold LastSeen.
    change (forall observed, Crtos_RTrans current observed <-> Crtos_RTrans current observed).
    intros observed; reflexivity.
Qed.
