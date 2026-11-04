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

Lemma remove_absent_eq__import_detached_refinement {A} (x : A) old new :
  ~ In x old -> remove_found_prop x old new -> new = old.
Proof.
  intros Habs [[_ Heq]|[p [s [Heq Hnew]]]]; [symmetry; exact Heq|].
  exfalso; apply Habs. rewrite Heq. apply in_or_app; right; now left.
Qed.

Lemma event_remove_absent__import_detached_refinement task old new :
  ~ In task (event_waiters old) -> event_remove_waiter_step task old new -> new = old.
Proof.
  intros Habs Hstep. induction Hstep as [|x y xs ys Hxy Hrest IH].
  - reflexivity.
  - unfold event_waiters in Habs; simpl in Habs; rewrite in_app_iff in Habs.
    destruct Hxy as [Ha [Hi [Ho [He Hp]]]].
    pose proof (remove_absent_eq__import_detached_refinement task (event_pending_addrs x) (event_pending_addrs y) ltac:(tauto) Hp) as Hpeq.
    assert (y = x) by (destruct x, y; simpl in *; subst; reflexivity).
    subst y. f_equal. apply IH. unfold event_waiters; tauto.
Qed.

Lemma mutex_remove_absent__import_detached_refinement task old new :
  ~ In task (mutex_waiters old) -> mutex_remove_waiter_step task old new -> new = old.
Proof.
  intros Habs Hstep. induction Hstep as [|x y xs ys Hxy Hrest IH].
  - reflexivity.
  - unfold mutex_waiters in Habs; simpl in Habs; rewrite in_app_iff in Habs.
    destruct Hxy as [Ha [Hi [Hv [Hrc [Hp [Hh Hr]]]]]].
    pose proof (remove_absent_eq__import_detached_refinement task (mutex_pending_addrs x) (mutex_pending_addrs y) ltac:(tauto) Hr) as Hpeq.
    assert (y = x) by (destruct x, y; simpl in *; subst; reflexivity).
    subst y. f_equal. apply IH. unfold mutex_waiters; tauto.
Qed.

Lemma semaphore_remove_absent__import_detached_refinement task old new :
  ~ In task (semaphore_waiters old) -> semaphore_remove_waiter_step task old new -> new = old.
Proof.
  intros Habs Hstep. induction Hstep as [|x y xs ys Hxy Hrest IH].
  - reflexivity.
  - unfold semaphore_waiters in Habs; simpl in Habs; rewrite in_app_iff in Habs.
    destruct Hxy as [Ha [Hi [Hv Hr]]].
    pose proof (remove_absent_eq__import_detached_refinement task (semaphore_pending_addrs x) (semaphore_pending_addrs y) ltac:(tauto) Hr) as Hpeq.
    assert (y = x) by (destruct x, y; simpl in *; subst; reflexivity).
    subst y. f_equal. apply IH. unfold semaphore_waiters; tauto.
Qed.

Lemma generic_wakeup_detached_null__import_detached_refinement sg task desc before after :
  os_world_wf sg before ->
  desc.(tdDelay) = 0 ->
  In task before.(os_tasks).(sched_owned_tasks) ->
  ktask_wakeup_step task desc before after ->
  ktask_wakeup_detached_null_step task desc before after.
Proof.
  intros Hwf Hdelay Howned Hstep.
  pose proof (sched_owned_not_waiting sg before task Hwf Howned) as Habs.
  rewrite !in_app_iff in Habs.
  destruct Hstep as [Hr Hmap Hown Hids Hptr Hrunn Hprio Hd He Hm Hs Htick Hz Hrec Hi Hisr Hex].
  constructor; try assumption.
  - destruct Hown as [[Hnot _]|Hsplit]; [contradiction|exact Hsplit].
  - destruct Hd as [d [Hd Heq]]. unfold ktask_unset_delay_step in Hd.
    rewrite Hdelay in Hd. destruct Hd as [[_ ->]|[[Hfalse _]|[Hfalse _]]]; try contradiction; exact Heq.
  - eapply (event_remove_absent__import_detached_refinement task (os_events before) (os_events after)); [tauto|exact He].
  - eapply (mutex_remove_absent__import_detached_refinement task (os_mutexes before) (os_mutexes after)); [tauto|exact Hm].
  - eapply (semaphore_remove_absent__import_detached_refinement task (os_semaphores before) (os_semaphores after)); [tauto|exact Hs].
Qed.

Lemma os_world_extract__import_detached_refinement sg st :
  os_inv sg st |-- “ os_world_wf sg st ”.
Proof. unfold os_inv. Intros_p Hwf. dump_pre_spatial. exact Hwf. Qed.
