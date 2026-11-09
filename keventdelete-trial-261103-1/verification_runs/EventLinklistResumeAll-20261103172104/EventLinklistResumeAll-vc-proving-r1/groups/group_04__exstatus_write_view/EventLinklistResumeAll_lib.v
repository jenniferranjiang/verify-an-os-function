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

From Coq Require Import Logic.FunctionalExtensionality Logic.PropExtensionality.

Lemma lookup_old__exstatus_write_view : forall T target desc value task new,
  T target = Some desc ->
  update_task_desc_map target (set_task_desc_exstatus desc value) T task = Some new ->
  exists old, T task = Some old /\ tdBaseInfo old = tdBaseInfo new /\
    tdSchedMember old = tdSchedMember new /\ tdDelay old = tdDelay new.
Proof.
  intros T target desc value task new HT Hnew.
  unfold update_task_desc_map in Hnew.
  destruct (Z.eq_dec task target) as [->|Hneq].
  - inversion Hnew; subst new. exists desc; auto.
  - exists new; auto.
Qed.

Lemma lookup_new__exstatus_write_view : forall T target desc value task old,
  T target = Some desc -> T task = Some old ->
  exists new, update_task_desc_map target (set_task_desc_exstatus desc value) T task = Some new /\
    tdBaseInfo old = tdBaseInfo new /\ tdSchedMember old = tdSchedMember new /\
    tdDelay old = tdDelay new.
Proof.
  intros T target desc value task old HT Hold.
  unfold update_task_desc_map.
  destruct (Z.eq_dec task target) as [->|Hneq].
  - rewrite HT in Hold; inversion Hold; subst old.
    exists (set_task_desc_exstatus desc value); auto.
  - exists old; auto.
Qed.

Lemma task_wf_update__exstatus_write_view : forall st target desc value,
  st.(os_tasks).(task_desc_map) target = Some desc -> task_world_wf st ->
  task_world_wf (replace_task_desc_map
    (update_task_desc_map target (set_task_desc_exstatus desc value) st.(os_tasks).(task_desc_map)) st).
Proof.
  intros st target desc value HT HW. destruct HW as [Hmap Howned Hid Hprio Halign Hrun Hinit].
  constructor; cbn.
  - intros task new Hnew. destruct (lookup_old__exstatus_write_view _ _ _ _ _ _ HT Hnew) as [old [Hlookup _]]. eauto.
  - intros task new Hnew Hstatus. destruct (lookup_old__exstatus_write_view _ _ _ _ _ _ HT Hnew) as [old [Hlookup [_ [Hs _]]]]. rewrite <- Hs in Hstatus. eauto.
  - exact Hid.
  - intros task new Hnew. destruct (lookup_old__exstatus_write_view _ _ _ _ _ _ HT Hnew) as [old [Hlookup [Hb [Hs _]]]]. rewrite <- Hb, <- Hs. eauto.
  - intros task new Hnew. destruct (lookup_old__exstatus_write_view _ _ _ _ _ _ HT Hnew) as [old [Hlookup _]]. eauto.
  - intros task new Hnew Hstatus. destruct (lookup_old__exstatus_write_view _ _ _ _ _ _ HT Hnew) as [old [Hlookup [_ [Hs _]]]]. rewrite <- Hs in *. eauto.
  - intros task new Hnew Hstatus. destruct (lookup_old__exstatus_write_view _ _ _ _ _ _ HT Hnew) as [old [Hlookup [_ [Hs _]]]]. rewrite <- Hs in *. eauto.
Qed.

Lemma service_update__exstatus_write_view : forall st target desc value entry slot,
  st.(os_tasks).(task_desc_map) target = Some desc -> service_slot_wf st entry slot ->
  service_slot_wf (replace_task_desc_map
    (update_task_desc_map target (set_task_desc_exstatus desc value) st.(os_tasks).(task_desc_map)) st) entry slot.
Proof.
  intros st target desc value entry slot HT. unfold service_slot_wf.
  destruct (service_phase slot); auto. intros [old HW].
  destruct HW as [Hl He Hd Ho Hi].
  destruct (lookup_new__exstatus_write_view _ _ _ value _ _ HT Hl) as [new [Hn [Hb [Hs Hdelay]]]].
  exists new; constructor; cbn; try assumption.
  - rewrite <- Hb; assumption.
  - rewrite <- Hdelay; assumption.
  - rewrite <- Hs; assumption.
Qed.

Lemma world_update__exstatus_write_view : forall sg st target desc value,
  st.(os_tasks).(task_desc_map) target = Some desc -> os_world_wf sg st ->
  os_world_wf sg (replace_task_desc_map
    (update_task_desc_map target (set_task_desc_exstatus desc value) st.(os_tasks).(task_desc_map)) st).
Proof.
  intros sg st target desc value HT HW. destruct HW as [Hctx Hr Hi Hn Hd].
  constructor; cbn.
  - exact Hctx.
  - apply service_update__exstatus_write_view; assumption.
  - rewrite Forall_forall in *. intros slot Hslot.
    apply service_update__exstatus_write_view; auto.
  - exact Hn.
  - intro task. change (In task (os_sched_owners st) <->
      update_task_desc_map target (set_task_desc_exstatus desc value) (task_desc_map (os_tasks st)) task <> None).
    rewrite Hd. unfold update_task_desc_map.
    destruct (Z.eq_dec task target) as [->|Hneq]; [rewrite HT; split; congruence|tauto].
Qed.

Lemma delay_update__exstatus_write_view : forall T target desc value inactive active,
  T target = Some desc -> delay_world_wf T inactive active ->
  delay_world_wf (update_task_desc_map target (set_task_desc_exstatus desc value) T) inactive active.
Proof.
  intros T target desc value inactive active HT HW. destruct HW as [Hz Hi Ha Hsort Hstatus].
  constructor; try assumption.
  - intros task new Hnew. destruct (lookup_old__exstatus_write_view _ _ _ _ _ _ HT Hnew) as [old [Hl [_ [_ Hd]]]]. rewrite <- Hd. eauto.
  - intros d info Hl. destruct (Hi d info Hl) as [old [Hlookup Hd]].
    destruct (lookup_new__exstatus_write_view _ _ _ value _ _ HT Hlookup) as [new [Hn [_ [_ Heq]]]].
    exists new; split; [exact Hn|congruence].
  - intros node Hin. destruct (Ha node Hin) as [old [Hlookup Hd]].
    destruct (lookup_new__exstatus_write_view _ _ _ value _ _ HT Hlookup) as [new [Hn [_ [_ Heq]]]].
    exists new; split; [exact Hn|rewrite <- Heq; exact Hd].
Qed.

Lemma ready_buckets_update__exstatus_write_view : forall T target desc value buckets i,
  T target = Some desc -> priority_ready_buckets_task_ok T i buckets ->
  priority_ready_buckets_task_ok (update_task_desc_map target (set_task_desc_exstatus desc value) T) i buckets.
Proof.
  intros T target desc value buckets. induction buckets as [|bucket rest IH]; intros i HT HW; cbn in *; auto.
  destruct HW as [Hb Hr]. split; [|apply IH; assumption].
  rewrite Forall_forall in *. intros node Hin. specialize (Hb node Hin).
  unfold ready_node_at_priority_ok, ready_node_task_desc in *.
  destruct Hb as [old [[Hnonzero [Hlink Hl]] Hprops]].
  destruct (lookup_new__exstatus_write_view _ _ _ value _ _ HT Hl) as [new [Hn [_ [Hs _]]]].
  exists new. rewrite <- Hs. auto.
Qed.

Lemma assign_update__exstatus_write_view : forall T target desc value state,
  T target = Some desc -> assign_world_wf T state ->
  assign_world_wf (update_task_desc_map target (set_task_desc_exstatus desc value) T) state.
Proof.
  intros T target desc value state HT [Hr Hv]. constructor.
  - destruct Hr as [Hz|[old Hl]]; [left; exact Hz|right].
    destruct (lookup_new__exstatus_write_view _ _ _ value _ _ HT Hl) as [new [Hn _]]. eauto.
  - destruct Hv as [Hb [Hg Hh]]. split; [|auto].
    unfold priority_ready_buckets_ok in *. apply ready_buckets_update__exstatus_write_view; assumption.
Qed.

Lemma slink_update_eq__exstatus_write_view : forall T target desc value status,
  T target = Some desc ->
  pure_published_slink T status =
  pure_published_slink (update_task_desc_map target (set_task_desc_exstatus desc value) T) status.
Proof.
  intros T target desc value status HT.
  apply functional_extensionality; intro link.
  apply functional_extensionality; intro task.
  apply functional_extensionality; intro heap.
  apply propositional_extensionality.
  change ((exists old, (T task = Some old /\ link = sched_link_of task /\ tsmStat (tdSchedMember old) = status) /\ emp heap) <->
    (exists new, (update_task_desc_map target (set_task_desc_exstatus desc value) T task = Some new /\ link = sched_link_of task /\ tsmStat (tdSchedMember new) = status) /\ emp heap)).
  split; intros [d [[Hl [Hlink Hstatus]] Hemp]].
  - destruct (lookup_new__exstatus_write_view _ _ _ value _ _ HT Hl) as [new [Hn [_ [Hs _]]]].
    exists new; rewrite <- Hs; auto.
  - destruct (lookup_old__exstatus_write_view _ _ _ _ _ _ HT Hl) as [old [Ho [_ [Hs _]]]].
    exists old; rewrite Hs; auto.
Qed.

Lemma detached_update_eq__exstatus_write_view : forall T target desc value,
  T target = Some desc ->
  store_detached_sched_link T =
  store_detached_sched_link (update_task_desc_map target (set_task_desc_exstatus desc value) T).
Proof.
  intros T target desc value HT.
  apply functional_extensionality; intro task.
  apply functional_extensionality; intro heap.
  apply propositional_extensionality.
  change ((exists old, (T task = Some old /\
    (tsmStat (tdSchedMember old) = TSK_INIT \/ tsmStat (tdSchedMember old) = TSK_RUNNING \/ tsmStat (tdSchedMember old) = TSK_SUSPEND)) /\ store_node_self_linked (sched_link_of task) heap) <->
    (exists new, (update_task_desc_map target (set_task_desc_exstatus desc value) T task = Some new /\
    (tsmStat (tdSchedMember new) = TSK_INIT \/ tsmStat (tdSchedMember new) = TSK_RUNNING \/ tsmStat (tdSchedMember new) = TSK_SUSPEND)) /\ store_node_self_linked (sched_link_of task) heap)).
  split; intros [d [[Hl Hstatus] Hheap]].
  - destruct (lookup_new__exstatus_write_view _ _ _ value _ _ HT Hl) as [new [Hn [_ [Hs _]]]].
    exists new; rewrite <- Hs; auto.
  - destruct (lookup_old__exstatus_write_view _ _ _ _ _ _ HT Hl) as [old [Ho [_ [Hs _]]]].
    exists old; rewrite Hs; auto.
Qed.

Lemma zombie_update_eq__exstatus_write_view : forall T target desc value head q,
  T target = Some desc ->
  store_zombie_queue T head q =
  store_zombie_queue (update_task_desc_map target (set_task_desc_exstatus desc value) T) head q.
Proof.
  intros T target desc value head q HT. destruct q; cbn; [reflexivity|].
  unfold pure_close_sched_link. rewrite (slink_update_eq__exstatus_write_view T target desc value TSK_CLOSE HT). reflexivity.
Qed.

Lemma exstatus_borrow_update__exstatus_write_view : forall sg st target desc,
  st.(os_tasks).(task_desc_map) target = Some desc ->
  os_inv sg st |--
  (&(target # "TaskDescriptor" ->ₛ "exstatus") # Int |-> tdExstatus desc) **
  event_resume_exstatus_restore sg
    (replace_task_desc_map
      (update_task_desc_map target (set_task_desc_exstatus desc (-1)) st.(os_tasks).(task_desc_map)) st)
    target (-1).
Proof.
  intros sg st target desc HT.
  unfold os_inv at 1. unfold task_inv at 1.
  Intros.
  sep_apply_l_atomic (store_map_split store_published_task target desc (task_desc_map (os_tasks st)) HT).
  unfold store_published_task at 2. unfold store_task_descriptor at 1.
  Intros.
  cancel (&(target # "TaskDescriptor" ->ₛ "exstatus") # Int |-> tdExstatus desc).
  unfold event_resume_exstatus_restore. apply_sepcon_adjoint.
  unfold os_inv, task_inv, delay_inv, assign_inv, tick_inv, exstatus_inv.
  cbn [replace_task_desc_map os_tasks task_desc_map task_idmanager_abs task_ptr_list sched_owned_tasks os_tick os_delays os_assign zombie_queue os_recycle os_idle os_isr os_exstatus os_semaphores os_mutexes os_events].
  unfold pure_suspend_sched_link, store_owned_sched_nodes.
  rewrite <- (slink_update_eq__exstatus_write_view _ _ _ (-1) TSK_SUSPEND HT).
  rewrite <- (detached_update_eq__exstatus_write_view _ _ _ (-1) HT).
  rewrite <- (zombie_update_eq__exstatus_write_view _ _ _ (-1) _ _ HT).
  Intros.
  split_pure_spatial.
  - cancel.
    assert (Hnew : update_task_desc_map target (set_task_desc_exstatus desc (-1)) (task_desc_map (os_tasks st)) target = Some (set_task_desc_exstatus desc (-1))).
    { unfold update_task_desc_map; destruct (Z.eq_dec target target); congruence. }
    sep_apply_r_atomic (store_map_merge store_published_task target (set_task_desc_exstatus desc (-1)) _ Hnew).
    assert (Hsame : forall other, other <> target -> task_desc_map (os_tasks st) other = update_task_desc_map target (set_task_desc_exstatus desc (-1)) (task_desc_map (os_tasks st)) other).
    { intros other Hneq. unfold update_task_desc_map. destruct (Z.eq_dec other target); congruence. }
    sep_apply_l_atomic (proj1 (store_map_missing_i_equiv store_published_task (task_desc_map (os_tasks st)) (update_task_desc_map target (set_task_desc_exstatus desc (-1)) (task_desc_map (os_tasks st))) target Hsame)).
    unfold store_published_task at 3. unfold store_task_descriptor. cbn [set_task_desc_exstatus tdStackPoint tdStackRaw tdStackContext tdBaseInfo tdSchedMember tdDelay tdEventIdTrigger tdEventMode tdExstatus tdDone].
    split_pure_spatial.
    + cancel.
      repeat match goal with |- ?P ** _ |-- _ => cancel P end.
      match goal with |- ?P |-- ?P => cancel P end.
    + split_pures; dump_pre_spatial; tauto.
  - split_pures; dump_pre_spatial;
      eauto using world_update__exstatus_write_view, task_wf_update__exstatus_write_view,
        delay_update__exstatus_write_view, assign_update__exstatus_write_view.
Qed.
