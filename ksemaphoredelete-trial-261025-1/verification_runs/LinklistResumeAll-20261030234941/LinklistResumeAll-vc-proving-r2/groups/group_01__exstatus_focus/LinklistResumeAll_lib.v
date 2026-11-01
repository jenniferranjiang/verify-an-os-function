From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.
From Coq Require Import Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.KSemaphoreDelete.
Local Open Scope string.
Local Open Scope sac.

(** 借出等待哨兵 next 槽后的空间归还条件。调用者还回读出的原值时，
    恢复同一状态的 os_inv；此 wand 本身不重复拥有该槽。 *)
Definition resume_next_restore (sg : StableGlobalState) (st : VarGlobalState)
    (head next : addr) : Assertion :=
  (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next) -* os_inv sg st.

(** 借出 exstatus 写槽后的归还条件；st 是写入后应重建的状态，value 是
    写入后的值。构造这个 wand 的 VC 必须证明所有 task-map 关联重索引。 *)
Definition resume_exstatus_restore (sg : StableGlobalState) (st : VarGlobalState)
    (task value : Z) : Assertion :=
  (&(task # "TaskDescriptor" ->ₛ "exstatus") # Int |-> value) -* os_inv sg st.

(** ID 只读槽的归还条件。先读取调用参数再交回该槽，避免在调用 Wakeup
    时同时声称完整 os_inv 与独立 ID 字段的重复所有权。 *)
Definition resume_id_restore (sg : StableGlobalState) (st : VarGlobalState)
    (task id : Z) : Assertion :=
  (&(task # "TaskDescriptor" ->ₛ "id" .ₛ "id") # UShort |-> id) -* os_inv sg st.

(** 剩余队列的完成条件：从当前状态完成 remaining 的任意合法逐步唤醒，
    均应得到原 waiting 相对 before 的整体效果。仅封装原循环不变量中的
    高阶量化语句，不增加前提或改变函数输出关系。 *)
Definition resume_remaining_effect (p : addr) (waiting : list addr)
    (before : VarGlobalState) (remaining : list addr) (current : VarGlobalState) : Prop :=
  forall final,
    semaphore_resume_all_steps p remaining current final ->
    semaphore_resume_all_effect p waiting before final.

From Coq Require Import Logic.FunctionalExtensionality Logic.PropExtensionality.

Lemma lookup_new__exstatus_focus : forall T target desc value task old,
  T target = Some desc -> T task = Some old ->
  exists new, update_task_desc_map target (set_task_desc_exstatus desc value) T task = Some new /\
    new.(tdSchedMember) = old.(tdSchedMember) /\
    new.(tdBaseInfo) = old.(tdBaseInfo) /\ new.(tdDelay) = old.(tdDelay).
Proof.
  intros T target desc value task old Htarget Htask.
  unfold update_task_desc_map. destruct (Z.eq_dec task target) as [E|E].
  - subst task. rewrite Htarget in Htask. inversion Htask; subst old.
    exists (set_task_desc_exstatus desc value). repeat split; reflexivity.
  - exists old. repeat split; auto.
Qed.

Lemma lookup_old__exstatus_focus : forall T target desc value task new,
  T target = Some desc ->
  update_task_desc_map target (set_task_desc_exstatus desc value) T task = Some new ->
  exists old, T task = Some old /\ new.(tdSchedMember) = old.(tdSchedMember) /\
    new.(tdBaseInfo) = old.(tdBaseInfo) /\ new.(tdDelay) = old.(tdDelay).
Proof.
  intros T target desc value task new Htarget Htask.
  unfold update_task_desc_map in Htask. destruct (Z.eq_dec task target) as [E|E].
  - subst task. inversion Htask; subst new. exists desc. repeat split; auto.
  - exists new. repeat split; auto.
Qed.

Lemma task_wf_mark__exstatus_focus : forall st target desc value,
  st.(os_tasks).(task_desc_map) target = Some desc -> task_world_wf st ->
  task_world_wf (replace_task_desc_map
    (update_task_desc_map target (set_task_desc_exstatus desc value) st.(os_tasks).(task_desc_map)) st).
Proof.
  intros st target desc value Htarget Hwf. constructor; simpl.
  - intros task new Hnew.
    destruct (lookup_old__exstatus_focus _ _ _ _ _ _ Htarget Hnew) as [old [Hlookup Hfields]].
    eapply task_wf_map_present; eauto.
  - intros task new Hnew Hstatus.
    destruct (lookup_old__exstatus_focus _ _ _ _ _ _ Htarget Hnew) as [old [Hlookup [Hs Hb]]].
    rewrite Hs in Hstatus. eapply task_wf_init_running_owned; eauto.
  - exact (task_wf_id_nodes st Hwf).
  - intros task new Hnew.
    destruct (lookup_old__exstatus_focus _ _ _ _ _ _ Htarget Hnew) as [old [Hlookup [Hs [Hb Hd]]]].
    rewrite Hs, Hb. eapply task_wf_priority; eauto.
  - intros task new Hnew.
    destruct (lookup_old__exstatus_focus _ _ _ _ _ _ Htarget Hnew) as [old [Hlookup Hfields]].
    eapply task_wf_aligned; eauto.
  - intros task new Hnew Hstatus.
    destruct (lookup_old__exstatus_focus _ _ _ _ _ _ Htarget Hnew) as [old [Hlookup [Hs Hb]]].
    rewrite Hs in *. eapply task_wf_running_bitmap; eauto.
  - intros task new Hnew Hstatus.
    destruct (lookup_old__exstatus_focus _ _ _ _ _ _ Htarget Hnew) as [old [Hlookup [Hs Hb]]].
    rewrite Hs in *. eapply task_wf_init_close_bitmap; eauto.
Qed.

Lemma service_wf_mark__exstatus_focus : forall st target desc value entry slot,
  st.(os_tasks).(task_desc_map) target = Some desc -> service_slot_wf st entry slot ->
  service_slot_wf (replace_task_desc_map
    (update_task_desc_map target (set_task_desc_exstatus desc value) st.(os_tasks).(task_desc_map)) st) entry slot.
Proof.
  intros st target desc value entry slot Htarget Hwf.
  unfold service_slot_wf in *. destruct (service_phase slot); auto.
  destruct Hwf as [old Hwf]. destruct Hwf as [Hlookup Hentry Hdelay Howned Hid].
  destruct (lookup_new__exstatus_focus _ _ _ value _ _ Htarget Hlookup) as [new [Hnew [Hs [Hb Hd]]]].
  exists new. constructor; simpl; auto.
  - rewrite Hb; exact Hentry.
  - rewrite Hd; exact Hdelay.
  - rewrite Hs; exact Howned.
Qed.

Lemma os_wf_mark__exstatus_focus : forall sg st target desc value,
  st.(os_tasks).(task_desc_map) target = Some desc -> os_world_wf sg st ->
  os_world_wf sg (replace_task_desc_map
    (update_task_desc_map target (set_task_desc_exstatus desc value) st.(os_tasks).(task_desc_map)) st).
Proof.
  intros sg st target desc value Htarget Hwf.
  destruct Hwf as [Hcontext Hrecycler Hidle Hnodup Hdomain]. constructor; simpl; auto.
  - apply service_wf_mark__exstatus_focus; auto.
  - rewrite Forall_forall in *. intros slot Hin.
    apply service_wf_mark__exstatus_focus; auto.
  - intros task. change (In task (os_sched_owners st) <->
      update_task_desc_map target (set_task_desc_exstatus desc value) (task_desc_map (os_tasks st)) task <> None).
    rewrite Hdomain. unfold update_task_desc_map.
    destruct (Z.eq_dec task target); subst; [rewrite Htarget|]; intuition discriminate.
Qed.

Lemma delay_wf_mark__exstatus_focus : forall T target desc value inactive active,
  T target = Some desc -> delay_world_wf T inactive active ->
  delay_world_wf (update_task_desc_map target (set_task_desc_exstatus desc value) T) inactive active.
Proof.
  intros T target desc value inactive active Htarget Hwf.
  destruct Hwf as [Hz Hi Ha Hsort Hstatus]. constructor; auto.
  - intros task new Hnew.
    destruct (lookup_old__exstatus_focus _ _ _ _ _ _ Htarget Hnew) as [old [Hlookup [Hs [Hb Hd]]]].
    rewrite Hd. eapply Hz; eauto.
  - intros delay info Hinfo. destruct (Hi _ _ Hinfo) as [old [Hlookup Hd]].
    destruct (lookup_new__exstatus_focus _ _ _ value _ _ Htarget Hlookup) as [new [Hnew [Hs [Hb He]]]].
    exists new. split; auto. rewrite He; auto.
  - intros node Hin. destruct (Ha _ Hin) as [old [Hlookup Hd]].
    destruct (lookup_new__exstatus_focus _ _ _ value _ _ Htarget Hlookup) as [new [Hnew [Hs [Hb He]]]].
    exists new. split; auto. rewrite He; auto.
Qed.

Lemma ready_wf_mark__exstatus_focus : forall T target desc value index buckets,
  T target = Some desc -> priority_ready_buckets_task_ok T index buckets ->
  priority_ready_buckets_task_ok (update_task_desc_map target (set_task_desc_exstatus desc value) T) index buckets.
Proof.
  intros T target desc value index buckets Htarget. revert index.
  induction buckets as [|bucket rest IH]; simpl; intros index H; auto.
  destruct H as [Hb Hr]. split; [|apply IH; exact Hr].
  rewrite Forall_forall in *. intros node Hin.
  specialize (Hb node Hin). unfold ready_node_at_priority_ok, ready_node_task_desc in *.
  destruct Hb as [old [[Hnonnull [Hlink Hlookup]] Hfields]].
  destruct (lookup_new__exstatus_focus _ _ _ value _ _ Htarget Hlookup) as [new [Hnew [Hs [Hbase Hd]]]].
  exists new. rewrite Hs. auto.
Qed.

Lemma assign_wf_mark__exstatus_focus : forall T target desc value assign,
  T target = Some desc -> assign_world_wf T assign ->
  assign_world_wf (update_task_desc_map target (set_task_desc_exstatus desc value) T) assign.
Proof.
  intros T target desc value assign Htarget [Hr [Hb Hrest]]. constructor.
  - destruct Hr as [Hz|[old Hlookup]]; [left; exact Hz|right].
    destruct (lookup_new__exstatus_focus _ _ _ value _ _ Htarget Hlookup) as [new [Hnew Hfields]].
    exists new; exact Hnew.
  - split; [|exact Hrest]. apply ready_wf_mark__exstatus_focus; auto.
Qed.

Lemma published_slink_mark__exstatus_focus : forall T target desc value status,
  T target = Some desc ->
  pure_published_slink (update_task_desc_map target (set_task_desc_exstatus desc value) T) status =
  pure_published_slink T status.
Proof.
  intros T target desc value status Htarget.
  apply functional_extensionality; intro link.
  apply functional_extensionality; intro task.
  apply functional_extensionality; intro heap.
  apply propositional_extensionality.
  unfold pure_published_slink, exp, andp, coq_prop.
  split; intros [d [[Hlookup [Hlink Hstatus]] Hemp]].
  - destruct (lookup_old__exstatus_focus _ _ _ _ _ _ Htarget Hlookup) as [old [Ho [Hs Hb]]].
    exists old. rewrite Hs in Hstatus. auto.
  - destruct (lookup_new__exstatus_focus _ _ _ value _ _ Htarget Hlookup) as [new [Hn [Hs Hb]]].
    exists new. rewrite Hs. auto.
Qed.

Lemma detached_slink_mark__exstatus_focus : forall T target desc value,
  T target = Some desc ->
  store_detached_sched_link (update_task_desc_map target (set_task_desc_exstatus desc value) T) =
  store_detached_sched_link T.
Proof.
  intros T target desc value Htarget.
  apply functional_extensionality; intro task.
  apply functional_extensionality; intro heap.
  apply propositional_extensionality.
  unfold store_detached_sched_link, exp, andp, coq_prop.
  split; intros [d [[Hlookup Hstatus] Hnode]].
  - destruct (lookup_old__exstatus_focus _ _ _ _ _ _ Htarget Hlookup) as [old [Ho [Hs Hb]]].
    exists old. rewrite Hs in Hstatus. auto.
  - destruct (lookup_new__exstatus_focus _ _ _ value _ _ Htarget Hlookup) as [new [Hn [Hs Hb]]].
    exists new. rewrite Hs. auto.
Qed.

Lemma zombie_mark__exstatus_focus : forall T target desc value head q,
  T target = Some desc ->
  store_zombie_queue (update_task_desc_map target (set_task_desc_exstatus desc value) T) head q =
  store_zombie_queue T head q.
Proof.
  intros T target desc value head q Htarget. destruct q; simpl; auto.
  unfold pure_close_sched_link. rewrite (published_slink_mark__exstatus_focus T target desc value TSK_CLOSE Htarget). reflexivity.
Qed.

Lemma cell_focus__exstatus_focus : forall task desc value, store_published_task task desc |-- (&(task # "TaskDescriptor" ->ₛ "exstatus") # Int |-> desc.(tdExstatus)) ** ((&(task # "TaskDescriptor" ->ₛ "exstatus") # Int |-> value) -* store_published_task task (set_task_desc_exstatus desc value)).
Proof. intros. unfold store_published_task, store_task_descriptor. simpl. Intros.
cancel (&(task # "TaskDescriptor" ->ₛ "exstatus") # Int |-> desc.(tdExstatus)).
apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)).
split_pure_spatial.
- cancel. repeat match goal with |- ?P ** _ |-- _ => cancel P end. match goal with |- ?P |-- ?P => cancel P end.
- split_pures; dump_pre_spatial; tauto.
Qed.
Lemma exstatus_focus__exstatus_focus : forall sg st target desc,
st.(os_tasks).(task_desc_map) target = Some desc ->
os_inv sg st |-- (&(target # "TaskDescriptor" ->ₛ "exstatus") # Int |-> desc.(tdExstatus)) **
resume_exstatus_restore sg (replace_task_desc_map (update_task_desc_map target (set_task_desc_exstatus desc (-1)) st.(os_tasks).(task_desc_map)) st) target (-1).
Proof.
intros sg st target desc Hlookup.
unfold resume_exstatus_restore, os_inv, task_inv, delay_inv, assign_inv.
cbn [replace_task_desc_map os_tasks task_desc_map task_idmanager_abs task_ptr_list sched_owned_tasks os_tick os_delays os_assign zombie_queue os_recycle os_idle os_mutexes os_msgqueues os_events os_isr os_exstatus os_semaphores].
Intros.
pose proof (os_wf_mark__exstatus_focus sg st target desc (-1) Hlookup H) as Hos.
pose proof (task_wf_mark__exstatus_focus st target desc (-1) Hlookup H0) as Htask.
pose proof (assign_wf_mark__exstatus_focus _ target desc (-1) _ Hlookup H1) as Hassign.
pose proof (delay_wf_mark__exstatus_focus _ target desc (-1) _ _ Hlookup H2) as Hdelay.
sep_apply_l_atomic (store_map_split store_published_task target desc _ Hlookup).
sep_apply_l_atomic (cell_focus__exstatus_focus target desc (-1)).
cancel (&(target # "TaskDescriptor" ->ₛ "exstatus") # Int |-> desc.(tdExstatus)).
apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)).
sep_apply_l_atomic (derivable1_wand_elim1
  (&(target # "TaskDescriptor" ->ₛ "exstatus") # Int |-> (-1))
  (store_published_task target (set_task_desc_exstatus desc (-1)))).
assert (Hnew : update_task_desc_map target (set_task_desc_exstatus desc (-1)) (task_desc_map (os_tasks st)) target = Some (set_task_desc_exstatus desc (-1))).
{ unfold update_task_desc_map. destruct (Z.eq_dec target target); congruence. }
assert (Hmiss : store_map_missing_i store_published_task (task_desc_map (os_tasks st)) target --||--
  store_map_missing_i store_published_task (update_task_desc_map target (set_task_desc_exstatus desc (-1)) (task_desc_map (os_tasks st))) target).
{ apply store_map_missing_i_equiv. intros task Hneq. unfold update_task_desc_map. destruct (Z.eq_dec task target); congruence. }
rewrite Hmiss.
sep_apply_l_atomic (store_map_merge store_published_task target (set_task_desc_exstatus desc (-1)) _ Hnew).
unfold store_owned_sched_nodes, pure_suspend_sched_link.
rewrite (detached_slink_mark__exstatus_focus _ target desc (-1) Hlookup).
rewrite (published_slink_mark__exstatus_focus _ target desc (-1) TSK_SUSPEND Hlookup).
rewrite (zombie_mark__exstatus_focus _ target desc (-1) _ _ Hlookup).
unfold tick_inv, exstatus_inv.
cbn [replace_task_desc_map os_tasks task_desc_map task_idmanager_abs task_ptr_list sched_owned_tasks os_tick os_delays os_assign zombie_queue os_recycle os_idle os_mutexes os_msgqueues os_events os_isr os_exstatus os_semaphores].
Intros.
split_pure_spatial.
- cancel; repeat match goal with |- ?P ** _ |-- _ => cancel P end;
  try match goal with |- ?P |-- ?P => cancel P end.
- split_pures; dump_pre_spatial; assumption.
Qed.

