From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.
Require Import Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.KSemaphoreDelete.
Import DLL IDNode.
Local Open Scope string_scope.
Local Open Scope sac.

(** 删除中临时借出信号量模块时保留的其余系统内存。纯全局条件保留于
    当前状态，节点摘除后须根据更新后的 semaphore 序列重建。 *)
Definition delete_global_frame (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
  let wait := pure_suspend_sched_link st.(os_tasks).(task_desc_map) in
  “ os_world_wf sg st ” &&
  task_inv sg st ** tick_inv sg st ** delay_inv sg st ** assign_inv sg st **
  store_prio_lookup_table **
  store_zombie_queue st.(os_tasks).(task_desc_map) sg.(os_zombie_head) st.(zombie_queue) **
  sg.(os_recycler_slot) # Int |-> st.(os_recycle).(service_id) **
  IntArray.full sg.(os_idle_array) CORE_COUNT (map service_id st.(os_idle)) **
  mutex_inv wait sg.(os_mutex_stable) st.(os_mutexes) **
  msgqueue_inv wait sg.(os_msgqueue_stable) st.(os_msgqueues) **
  event_inv wait sg.(os_event_stable) st.(os_events) **
  isrmanager_inv sg.(os_isr_stable) st.(os_isr) ** exstatus_inv sg st.

(** ID manager 外的实际空间 frame。删除 manager 后仍可借出管理 DLL；
    不能用要求旧 manager 的 wand 隐藏这一步需要修改的外层链。 *)
Definition delete_manager_frame (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
  “ semaphore_context sg.(os_semaphore_stable) ” &&
  delete_global_frame sg st **
  store_dll (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map)))
    sg.(os_semaphore_stable).(semaphore_list_head)
    (map semaphore_link_node st.(os_semaphores)).

(** 判空只借用等待 DLL；归还相同资源后恢复同一 os_inv。 *)
Definition delete_pending_restore (sg : StableGlobalState) (st : VarGlobalState)
    (sem : addr) (waiting : list addr) : Assertion :=
  store_dll (pure_suspend_sched_link st.(os_tasks).(task_desc_map))
    (semaphore_pending_head sem) (map sched_link_node waiting) -* os_inv sg st.

(** 调用 IdRemoveObj 前读 ID；读出值后先归还字段，再借出完整 manager。
    此 wand 是空间资源，不是可以复制的纯蕴含。 *)
Definition delete_id_restore (sg : StableGlobalState) (st : VarGlobalState)
    (sem id : Z) : Assertion :=
  (&(sem # "Semaphore" ->ₛ "id" .ₛ "id") # UShort |-> id) -* os_inv sg st.


From Coq Require Import Lia Bool.Bool Sorting.Permutation.
From Coq Require Import Lia.
Require Import Coq.micromega.Lia.
Lemma resume_keeps_semaphore_fields__manager_selection :
  forall p original before after,
    In original before.(os_semaphores) ->
    p = original.(semaphore_addr) ->
    semaphore_resume_all_effect p original.(semaphore_pending_addrs) before after ->
    exists current,
      In current after.(os_semaphores) /\
      current.(semaphore_addr) = p /\
      current.(semaphore_id) = original.(semaphore_id) /\
      current.(semaphore_value) = original.(semaphore_value) /\
      current.(semaphore_pending_addrs) = nil.
Proof.
  intros p original before after Hin Hp Heffect.
  subst p.
  unfold semaphore_resume_all_effect in Heffect.
  destruct (semaphore_pending_addrs original) as [|task tail] eqn:Hpending.
  - subst after. exists original. repeat split; assumption || reflexivity.
  - destruct Heffect as [_ [_ [ready [_ Hafter]]]].
    subst after.
    exists (semaphore_created original.(semaphore_addr)
      original.(semaphore_id) original.(semaphore_value)).
    split.
    + cbn [replace_semaphores]. unfold semaphore_set_pending.
      apply in_map_iff. exists original. split; [|exact Hin].
      destruct (Z.eq_dec (semaphore_addr original) (semaphore_addr original));
        [reflexivity | contradiction].
    + repeat split; reflexivity.
Qed.
Lemma manager_ids_nodup__manager_selection : forall sm m p,
  store_idmanager sm m p |-- “ NoDup m.(idlist) ”.
Proof.
  intros sm m p. unfold store_idmanager.
  Intros_p Hbucket.
  dump_pre_spatial. unfold idbuckets_ok, idlist_ok in Hbucket.
  tauto.
Qed.
Lemma os_inv_manager_view__manager_selection : forall sg st,
  os_inv sg st |--
    “ NoDup (map semaphore_id st.(os_semaphores)) ” &&
    store_idmanager sg.(os_semaphore_stable).(semaphore_manager_stable)
      (semaphore_manager st.(os_semaphores)) (&("k_sem_id_manager")) **
    delete_manager_frame sg st.
Proof.
  intros sg st.
  unfold os_inv, semaphore_inv, delete_manager_frame, delete_global_frame.
  Intros_p Hworld. Intros_p Hcontext.
  prop_apply_p (manager_ids_nodup__manager_selection
    sg.(os_semaphore_stable).(semaphore_manager_stable)
    (semaphore_manager st.(os_semaphores))
    sg.(os_semaphore_stable).(semaphore_manager_ptr)).
  Intros_p Hnodup.
  change (NoDup (map semaphore_id st.(os_semaphores))) in Hnodup.
  pose proof (proj1 Hcontext) as Hptr.
  rewrite Hptr.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; tauto.
Qed.
Lemma mapped_nodup_injective__retirement_commit :
  forall (A B : Type) (f : A -> B) (xs : list A) x y,
    NoDup (map f xs) -> In x xs -> In y xs -> f x = f y -> x = y.
Proof.
  intros A B f xs. induction xs as [|a xs IH]; intros x y Hnd Hx Hy Heq.
  - contradiction.
  - inversion Hnd as [|? ? Hnot Htail]; subst.
    destruct Hx as [Hx|Hx]; destruct Hy as [Hy|Hy].
    + congruence.
    + subst x. exfalso. apply Hnot. rewrite Heq. apply in_map; exact Hy.
    + subst y. exfalso. apply Hnot. rewrite <- Heq. apply in_map; exact Hx.
    + eapply IH; eauto.
Qed.
Lemma selected_bucket_member__retirement_commit :
  forall (A : Type) (buckets : list (list A)) i x,
    In x (Znth i buckets nil) -> exists bucket, In bucket buckets /\ In x bucket.
Proof.
  intros A buckets i x Hin. unfold Znth in Hin.
  destruct (lt_dec (Z.to_nat i) (List.length buckets)) as [Hlt|Hge].
  - exists (nth (Z.to_nat i) buckets nil). split; [apply nth_In; exact Hlt|exact Hin].
  - rewrite nth_overflow in Hin by lia. contradiction.
Qed.
Lemma deleted_id_node_unique__retirement_commit :
  forall sm sems current id returned,
    NoDup (map semaphore_id sems) -> In current sems -> semaphore_id current = id ->
    In (Build_IdNodeAbs id returned)
      (Znth (id mod hoffset sm) (idbuckets (semaphore_manager sems)) nil) ->
    returned = &(((semaphore_addr current)) # "Semaphore" ->ₛ "id").
Proof.
  intros sm sems current id returned Hnd Hcurrent Hid Hin.
  apply selected_bucket_member__retirement_commit in Hin as [bucket [Hbucket Hnode]].
  cbn [semaphore_manager] in Hbucket.
  apply in_map_iff in Hbucket as [i [Hbucket Hi]]. subst bucket.
  apply in_map_iff in Hnode as [actual [Hactual Hin]].
  apply filter_In in Hin as [Hin Hhash].
  assert (Hactual_id : semaphore_id actual = id).
  { apply (f_equal idnode_id) in Hactual. exact Hactual. }
  assert (actual = current) as ->.
  { eapply mapped_nodup_injective__retirement_commit; eauto. congruence. }
  apply (f_equal idnode_addr) in Hactual. cbn [semaphore_idnode] in Hactual.
  symmetry. exact Hactual.
Qed.
Lemma delete_atomic_continuation__retirement_commit :
  forall sg id before locked after resched X,
    0 <= id -> Crtos_RTrans before locked ->
    MonadErr.nrm (abs_semaphore_delete_locked id) locked resched after ->
    monadesafe_lib.safeExec (LastSeen before) (abs_semaphore_delete sg id) X ->
    monadesafe_lib.safeExec (LastSeen after)
      (if resched then abs_ktask_assign else MonadErr.ret tt) X.
Proof.
  intros sg id before locked after resched X Hid Hrely Hstep Hsafe.
  unfold monadesafe_lib.safeExec, monadesafe_lib.safe in Hsafe.
  destruct Hsafe as [states [Hlast Hwp]].
  change (forall st, states st <-> Crtos_RTrans before st) in Hlast.
  unfold abs_semaphore_delete in Hwp.
  assert (Hlt : Z.ltb id 0 = false) by (apply Z.ltb_ge; exact Hid).
  rewrite Hlt in Hwp.
  pose proof (proj1 (MonadErrHoare.wp_bind
    (task_atomic_cmd (abs_semaphore_delete_locked id))
    (fun r => if r then abs_ktask_assign else MonadErr.ret tt) X states) Hwp) as Hbound.
  unfold monadesafe_lib.safeExec, monadesafe_lib.safe.
  exists (Crtos_RTrans after). split.
  - change (forall st, Crtos_RTrans after st <-> Crtos_RTrans after st). tauto.
  - apply (proj2 Hbound resched (Crtos_RTrans after)).
    cbn [task_atomic_cmd]. exists locked, after. split.
    + apply (proj2 (Hlast locked)). exact Hrely.
    + split; [exact Hstep|]. change (forall st, Crtos_RTrans after st <-> Crtos_RTrans after st). tauto.
Qed.
Lemma ushort_distinct__retirement_commit : forall p q v w,
  p # UShort |-> v ** q # UShort |-> w |-- “ p <> q ”.
Proof.
  intros p q v w. destruct (Z.eq_dec p q) as [->|Hneq].
  - unfold store_ushort. Intros_p H1. Intros_p H2.
    sep_apply_l_atomic (dup_store_2bytes q v w).
    apply derivables_false_coq_prop. tauto.
  - dump_pre_spatial. exact Hneq.
Qed.
Lemma pure_framed__retirement_commit : forall (P R : Assertion) (fact : Prop),
  (P |-- “ fact ”) -> P ** R |-- “ fact ”.
Proof.
  intros P R fact H. sep_apply_l_atomic H.
  Intros_p Hfact. dump_pre_spatial. exact Hfact.
Qed.
Lemma payload_dllseg_distinct__retirement_commit :
  forall wait p value sems x px y py,
    &(p # "Semaphore" ->ₛ "value") # UShort |-> value **
    dllseg (store_semaphore wait) x px y py (map semaphore_link_node sems)
    |-- “ Forall (fun obj => semaphore_addr obj <> p) sems ”.
Proof.
  intros wait p value sems. induction sems as [|obj sems IH]; intros x px y py.
  - cbn [map dllseg]. Intros_p Hempty. dump_pre_spatial. constructor.
  - cbn [map dllseg semaphore_link_node]. left_intro next. Intros_p Hptr. subst x.
    unfold store_semaphore at 1. Intros_p Hobj.
    prop_apply_p (ushort_distinct__retirement_commit
      (&(p # "Semaphore" ->ₛ "value"))
      (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "value")) value (semaphore_value obj)).
    Intros_p Hneq.
    add_pure (Forall (fun s => semaphore_addr s <> p) sems) as Htail.
    {
      let link := constr:(&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) in
      let frame := constr:(
        &(((semaphore_addr obj)) # "Semaphore" ->ₛ "value") # UShort |-> semaphore_value obj **
        SemaphorePadding (semaphore_addr obj) **
        store_dll wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
          (map semaphore_wait_node (semaphore_pending_addrs obj)) **
        &(link # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
        &(link # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next) in
      sep_apply_r_atomic (pure_framed__retirement_commit _ frame _
        (IH next link y py)).
      cbn [semaphore_link_node getData getPtr]. unfold dllseg. sepcon_assoc_change. cancel.
    }
    dump_pre_spatial. constructor; [|exact Htail].
    intro Heq. apply Hneq. now rewrite Heq.
Qed.
Lemma payload_dll_distinct__retirement_commit :
  forall wait p value sems head,
    &(p # "Semaphore" ->ₛ "value") # UShort |-> value **
    store_dll (store_semaphore wait) head (map semaphore_link_node sems)
    |-- “ Forall (fun obj => semaphore_addr obj <> p) sems ”.
Proof.
  intros wait p value sems head. unfold store_dll. left_intro first_node. left_intro last_node.
  Intros_p Hnodes.
  sep_apply_l_atomic (payload_dllseg_distinct__retirement_commit wait p value sems first_node head head last_node).
  Intros_p Hdistinct. dump_pre_spatial. exact Hdistinct.
Qed.
Lemma unpublish_current__retirement_commit : forall prefix suffix current p,
  semaphore_addr current = p ->
  Forall (fun obj => semaphore_addr obj <> p) ((prefix ++ suffix)%list) ->
  semaphore_unpublish p ((prefix ++ current :: suffix)%list) = (prefix ++ suffix)%list.
Proof.
  intros prefix suffix current p Haddr Hrest.
  unfold semaphore_unpublish. rewrite filter_app. cbn.
  rewrite Haddr, Z.eqb_refl. cbn.
  apply Forall_app in Hrest as [Hp Hs].
  assert (forall xs, Forall (fun obj => semaphore_addr obj <> p) xs ->
    filter (fun s => negb (Z.eqb (semaphore_addr s) p)) xs = xs) as Hfilter.
  { intros xs H. induction H; cbn; auto.
    apply Z.eqb_neq in H. rewrite H. cbn. now rewrite IHForall. }
  rewrite (Hfilter prefix Hp), (Hfilter suffix Hs). reflexivity.
Qed.
Lemma task_world_reindex__retirement_commit : forall st sems,
  task_world_wf st -> task_world_wf (replace_semaphores sems st).
Proof.
  intros st sems H. destruct H. constructor; cbn [replace_semaphores]; assumption.
Qed.
Lemma service_reindex__retirement_commit : forall st sems entry slot,
  service_slot_wf st entry slot -> service_slot_wf (replace_semaphores sems st) entry slot.
Proof.
  intros st sems entry slot. unfold service_slot_wf.
  destruct (service_phase slot); try tauto.
  intros [desc H]. exists desc. destruct H. constructor; assumption.
Qed.
Lemma world_reindex__retirement_commit : forall sg st sems,
  semaphore_waiters sems = semaphore_waiters (os_semaphores st) ->
  os_world_wf sg st -> os_world_wf sg (replace_semaphores sems st).
Proof.
  intros sg st sems Hwait H. destruct H as [Hcontext Hrecycler Hidle Hnodup Hdomain].
  assert (Howners : os_sched_owners (replace_semaphores sems st) = os_sched_owners st).
  { unfold os_sched_owners.
    change ((sched_owned_tasks (os_tasks st) ++
      map (@getData addr) (os_ready_nodes (orvBuckets (assignReadyVector (os_assign st)))) ++
      map (@getData addr) (zombie_nodes (zombie_queue st)) ++
      semaphore_waiters sems ++ mutex_waiters (os_mutexes st) ++
      msgqueue_waiters (os_msgqueues st) ++ event_waiters (os_events st))%list =
      (sched_owned_tasks (os_tasks st) ++
      map (@getData addr) (os_ready_nodes (orvBuckets (assignReadyVector (os_assign st)))) ++
      map (@getData addr) (zombie_nodes (zombie_queue st)) ++
      semaphore_waiters (os_semaphores st) ++ mutex_waiters (os_mutexes st) ++
      msgqueue_waiters (os_msgqueues st) ++ event_waiters (os_events st))%list).
    now rewrite Hwait. }
  constructor.
  - exact Hcontext.
  - apply service_reindex__retirement_commit. exact Hrecycler.
  - cbn [replace_semaphores os_tasks os_tick os_delays os_assign zombie_queue os_recycle os_idle os_mutexes os_msgqueues os_events os_isr os_exstatus os_semaphores]. eapply Forall_impl; [|exact Hidle].
    intros slot Hslot. apply service_reindex__retirement_commit. exact Hslot.
  - rewrite Howners. exact Hnodup.
  - rewrite Howners. cbn [replace_semaphores os_tasks os_tick os_delays os_assign zombie_queue os_recycle os_idle os_mutexes os_msgqueues os_events os_isr os_exstatus os_semaphores]. exact Hdomain.
Qed.
Lemma task_inv_reindex__retirement_commit : forall sg st sems,
  task_inv sg st |-- task_inv sg (replace_semaphores sems st).
Proof.
  intros sg st sems. unfold task_inv. Intros_p Htask.
  cbn [replace_semaphores os_tasks].
  split_pure_spatial.
  - sepcon_assoc_change. cancel.
  - dump_pre_spatial. apply task_world_reindex__retirement_commit. exact Htask.
Qed.
Lemma global_frame_reindex__retirement_commit : forall sg st sems,
  semaphore_waiters sems = semaphore_waiters (os_semaphores st) ->
  delete_global_frame sg st |-- delete_global_frame sg (replace_semaphores sems st).
Proof.
  intros sg st sems Hwait. unfold delete_global_frame. Intros_p Hworld.
  sep_apply_l_atomic (task_inv_reindex__retirement_commit sg st sems).
  assert (E1 : tick_inv sg (replace_semaphores sems st) = tick_inv sg st) by reflexivity.
  assert (E2 : delay_inv sg (replace_semaphores sems st) = delay_inv sg st) by reflexivity.
  assert (E3 : assign_inv sg (replace_semaphores sems st) = assign_inv sg st) by reflexivity.
  assert (E4 : exstatus_inv sg (replace_semaphores sems st) = exstatus_inv sg st) by reflexivity.
  rewrite E1, E2, E3, E4. cbn [replace_semaphores os_tasks os_tick os_delays os_assign zombie_queue os_recycle os_idle os_mutexes os_msgqueues os_events os_isr os_exstatus os_semaphores].
  split_pure_spatial.
  - sepcon_assoc_change. cancel.
  - dump_pre_spatial. eapply world_reindex__retirement_commit; eauto.
Qed.
Lemma empty_dll_self__retirement_commit : forall (A : Type) (storeA : addr -> A -> Assertion) head,
  store_dll storeA head nil |-- (“ head <> 0 ” && store_node_self_linked head)%sac.
Proof.
  intros A storeA head. unfold store_dll. left_intro first_node. left_intro last_node. Intros_p Hnonzero.
  cbn [dllseg]. Intros_p Hempty. destruct Hempty as [-> <-].
  unfold store_node_self_linked. split_pure_spatial; [cancel|dump_pre_spatial; tauto].
Qed.
Lemma idnodes_remove_app__retirement_commit : forall id xs ys,
  idnodes_remove_id id ((xs ++ ys)%list) = (idnodes_remove_id id xs ++ idnodes_remove_id id ys)%list.
Proof.
  intros id xs. induction xs as [|x xs IH]; intro ys; cbn [app idnodes_remove_id]; auto.
  destruct (Z.eq_dec (idnode_id x) id); cbn; now rewrite IH.
Qed.
Lemma idnodes_remove_absent__retirement_commit : forall id nodes,
  (forall n, In n nodes -> idnode_id n <> id) -> idnodes_remove_id id nodes = nodes.
Proof.
  intros id nodes. induction nodes as [|n nodes IH]; intro H; cbn [idnodes_remove_id]; auto.
  destruct (Z.eq_dec (idnode_id n) id) as [Heq|Hne].
  - exfalso. apply (H n (or_introl eq_refl)); exact Heq.
  - f_equal. apply IH. intros x Hin. apply H. right; exact Hin.
Qed.
Lemma filtered_remove_absent__retirement_commit : forall id sems test,
  ~ In id (map semaphore_id sems) ->
  idnodes_remove_id id (map semaphore_idnode (filter test sems)) =
  map semaphore_idnode (filter test sems).
Proof.
  intros id sems test Hnot. apply idnodes_remove_absent__retirement_commit.
  intros node Hin Heq. apply in_map_iff in Hin as [s [<- Hin]].
  apply filter_In in Hin as [Hin Htest]. apply Hnot.
  apply in_map_iff. exists s. split; [exact Heq|exact Hin].
Qed.
Lemma map_seq_nth__retirement_commit : forall (A : Type) (f : nat -> A) start len n d,
  (start <= n < start + len)%nat ->
  nth (n-start) (map f (seq start len)) d = f n.
Proof.
  intros A f start len n d Hrange.
  rewrite (@List.nth_indep A (map f (seq start len)) (n-start)%nat d (f 0%nat)) by (rewrite length_map, length_seq; lia).
  rewrite map_nth, seq_nth by lia. f_equal; lia.
Qed.
Lemma replace_map_seq__retirement_commit : forall (A : Type) (f g : nat -> A) len start n,
  (start <= n < start + len)%nat ->
  (forall i, i <> n -> f i = g i) ->
  replace_nth (n-start) (map f (seq start len)) (g n) = map g (seq start len).
Proof.
  intros A f g len. induction len as [|len IH]; intros start n Hrange Hother; [lia|].
  cbn [seq map]. destruct (Nat.eq_dec n start) as [->|Hne].
  - rewrite Nat.sub_diag. cbn [replace_nth]. f_equal.
    apply map_ext_in. intros i Hi. apply Hother. apply in_seq in Hi. lia.
  - replace (n-start)%nat with (S (n-S start)) by lia. cbn [replace_nth].
    f_equal; [apply Hother; lia|apply IH; auto; lia].
Qed.
Lemma idlist_remove_current__retirement_commit : forall prefix suffix current,
  NoDup (map semaphore_id ((prefix ++ current :: suffix)%list)) ->
  idlist_remove (semaphore_id current) (map semaphore_id ((prefix ++ current :: suffix)%list)) =
  map semaphore_id ((prefix ++ suffix)%list).
Proof.
  intros prefix suffix current Hnd.
  rewrite map_app in Hnd. cbn [map] in Hnd.
  pose proof (NoDup_remove_2 (map semaphore_id prefix) (map semaphore_id suffix)
    (semaphore_id current) Hnd) as Hnot.
  unfold idlist_remove. rewrite !map_app. cbn [map].
  rewrite remove_app, remove_cons.
  rewrite !notin_remove; [reflexivity| |]; intro Hin; apply Hnot;
    apply in_or_app; auto.
Qed.
Lemma idnodes_remove_current_cons__retirement_commit : forall current nodes,
  idnodes_remove_id (semaphore_id current) (semaphore_idnode current :: nodes) =
  idnodes_remove_id (semaphore_id current) nodes.
Proof.
  intros current nodes.
  cbn [idnodes_remove_id semaphore_idnode idnode_id].
  destruct (Z.eq_dec (semaphore_id current) (semaphore_id current)); [reflexivity|contradiction].
Qed.
Lemma bucket_remove_current__retirement_commit : forall prefix suffix current i,
  NoDup (map semaphore_id ((prefix ++ current :: suffix)%list)) ->
  idnodes_remove_id (semaphore_id current)
    (map semaphore_idnode (filter (fun s => Z.eqb (semaphore_id s mod 16) (Z.of_nat i))
      ((prefix ++ current :: suffix)%list))) =
  map semaphore_idnode (filter (fun s => Z.eqb (semaphore_id s mod 16) (Z.of_nat i)) ((prefix ++ suffix)%list)).
Proof.
  intros prefix suffix current i Hnd.
  rewrite map_app in Hnd. cbn [map] in Hnd.
  pose proof (NoDup_remove_2 (map semaphore_id prefix) (map semaphore_id suffix)
    (semaphore_id current) Hnd) as Hnot.
  assert (Hp : ~ In (semaphore_id current) (map semaphore_id prefix)).
  { intro H; apply Hnot; apply in_or_app; auto. }
  assert (Hs : ~ In (semaphore_id current) (map semaphore_id suffix)).
  { intro H; apply Hnot; apply in_or_app; auto. }
  rewrite !filter_app. cbn [filter].
  destruct (Z.eqb (semaphore_id current mod 16) (Z.of_nat i)); cbn [map];
    rewrite map_app, idnodes_remove_app__retirement_commit,
      (filtered_remove_absent__retirement_commit _ _ _ Hp).
  - cbn [map]. rewrite idnodes_remove_current_cons__retirement_commit.
    rewrite (filtered_remove_absent__retirement_commit _ _ _ Hs). try rewrite map_app. reflexivity.
  - rewrite (filtered_remove_absent__retirement_commit _ _ _ Hs). try rewrite map_app. reflexivity.
Qed.
Lemma other_bucket_current__retirement_commit : forall prefix suffix current i,
  i <> Z.to_nat (semaphore_id current mod 16) ->
  map semaphore_idnode (filter (fun s => Z.eqb (semaphore_id s mod 16) (Z.of_nat i))
    ((prefix ++ current :: suffix)%list)) =
  map semaphore_idnode (filter (fun s => Z.eqb (semaphore_id s mod 16) (Z.of_nat i))
    ((prefix ++ suffix)%list)).
Proof.
  intros prefix suffix current i Hne. rewrite !filter_app. cbn [filter].
  assert (Heq : Z.eqb (semaphore_id current mod 16) (Z.of_nat i) = false).
  { apply Z.eqb_neq. intro H. apply Hne. rewrite H, Nat2Z.id. reflexivity. }
  rewrite Heq. reflexivity.
Qed.
Lemma manager_remove_current__retirement_commit : forall sm prefix suffix current,
  hoffset sm = 16 -> NoDup (map semaphore_id ((prefix ++ current :: suffix)%list)) ->
  idmanager_remove sm (semaphore_manager ((prefix ++ current :: suffix)%list)) (semaphore_id current) =
  semaphore_manager ((prefix ++ suffix)%list).
Proof.
  intros sm prefix suffix current Hoff Hnd.
  unfold idmanager_remove, semaphore_manager. cbn [idlist idbuckets].
  f_equal.
  - apply idlist_remove_current__retirement_commit. exact Hnd.
  - unfold idmanager_remove_bucket. rewrite Hoff. unfold replace_Znth, Znth.
    set (idx := Z.to_nat (semaphore_id current mod 16)).
    set (oldb := fun i : nat => map semaphore_idnode
      (filter (fun s => Z.eqb (semaphore_id s mod 16) (Z.of_nat i))
        (prefix ++ current :: suffix)%list)).
    set (newb := fun i : nat => map semaphore_idnode
      (filter (fun s => Z.eqb (semaphore_id s mod 16) (Z.of_nat i))
        (prefix ++ suffix)%list)).
    change (replace_nth idx (map oldb (seq 0 16))
      (idnodes_remove_id (semaphore_id current) (nth idx (map oldb (seq 0 16)) nil))
      = map newb (seq 0 16)).
    assert (Hrange : (0 <= idx < 0 + 16)%nat).
    { unfold idx. pose proof (Z.mod_pos_bound (semaphore_id current) 16 ltac:(lia)); lia. }
    pose proof (map_seq_nth__retirement_commit _ oldb 0 16 idx nil Hrange) as Hnth.
    rewrite Nat.sub_0_r in Hnth. rewrite Hnth.
    assert (Hbucket : idnodes_remove_id (semaphore_id current) (oldb idx) = newb idx).
    { unfold oldb, newb. apply bucket_remove_current__retirement_commit. exact Hnd. }
    rewrite Hbucket.
    pose proof (replace_map_seq__retirement_commit _ oldb newb 16 0 idx Hrange) as Hreplace.
    rewrite Nat.sub_0_r in Hreplace. apply Hreplace.
    intros i Hne. unfold oldb, newb.
    apply other_bucket_current__retirement_commit. exact Hne.
Qed.
Lemma inv_recompose__retirement_commit : forall sg st,
  semaphore_context (os_semaphore_stable sg) ->
  delete_global_frame sg st **
  store_idmanager (semaphore_manager_stable (os_semaphore_stable sg))
    (semaphore_manager (os_semaphores st)) &("k_sem_id_manager") **
  store_dll (store_semaphore (pure_suspend_sched_link (task_desc_map (os_tasks st))))
    &("k_sem_list") (map semaphore_link_node (os_semaphores st))
  |-- os_inv sg st.
Proof.
  intros sg st Hcontext.
  pose proof Hcontext as [Hmanager [_ [_ [_ [_ Hhead]]]]].
  unfold delete_global_frame, os_inv, semaphore_inv. Intros_p Hworld.
  rewrite Hmanager, Hhead.
  split_pure_spatial; [sepcon_assoc_change; cancel|split_pures; dump_pre_spatial; assumption].
Qed.
Lemma waiters_remove_empty__retirement_commit : forall prefix suffix current,
  semaphore_pending_addrs current = nil ->
  semaphore_waiters ((prefix ++ suffix)%list) = semaphore_waiters ((prefix ++ current :: suffix)%list).
Proof.
  intros prefix suffix current Hempty.
  unfold semaphore_waiters. rewrite !map_app, !concat_app.
  cbn [map concat]. rewrite Hempty. reflexivity.
Qed.
Lemma embedded_field_addr__retirement_commit : forall (L : lvalue_expr) (ty field : string),
  eval_addr_expr (RE_addr_of (LE_dot_field L field)) =
  eval_addr_expr (RE_addr_of (LE_arrow_field
    (RE_const (eval_addr_expr (RE_addr_of L)) (FET_alias ty)) field)).
Proof.
  intros L ty field.
  rewrite (eval_addr (RE_addr_of L) (FET_alias ty)).
  rewrite <- (addr_of_arrow_field L field). reflexivity.
Qed.
Lemma retired_payload__retirement_commit : forall wait current returned,
  returned = &(((semaphore_addr current)) # "Semaphore" ->ₛ "id") ->
  returned <> 0 -> &(returned # "IdNode" ->ₛ "link") <> 0 ->
  semaphore_pending_addrs current = nil ->
  store_semaphore wait (&(((semaphore_addr current)) # "Semaphore" ->ₛ "link")) current **
  store_node_self_linked (&(((semaphore_addr current)) # "Semaphore" ->ₛ "link")) **
  &(returned # "IdNode" ->ₛ "id") # UShort |-> 65535 **
  &(returned # "IdNode" ->ₛ "link" .ₛ "node_prev") # Ptr |-> &(returned # "IdNode" ->ₛ "link") **
  &(returned # "IdNode" ->ₛ "link" .ₛ "node_next") # Ptr |-> &(returned # "IdNode" ->ₛ "link")
  |-- SemaphoreRetired (semaphore_addr current) (semaphore_value current).
Proof.
  intros wait current returned Hret Hret0 Hidlink Hempty.
  unfold store_semaphore. Intros_p Hpayload.
  destruct Hpayload as [Hp [Halign Hlinkeq]].
  rewrite Hempty. sep_apply_l_atomic (empty_dll_self__retirement_commit addr wait
    (&(((semaphore_addr current)) # "Semaphore" ->ₛ "pend_list"))).
  Intros_p Hpend.
  prop_apply_p (valid_store_ushort (&(returned # "IdNode" ->ₛ "id")) 65535).
  Intros_p Hvalid.
  pose proof (semaphore_field_offsets_trusted (semaphore_addr current) Halign) as Hlayout.
  destruct Hlayout as [Hsid [Hiid [Hilink [Hval [Hpending [Hlink Hnodes]]]]]].
  assert (Hreturned : returned = semaphore_addr current) by congruence.
  assert (Hpos : 0 < semaphore_addr current).
  { rewrite Hreturned, Hiid in Hvalid. unfold isvalidptr_short in Hvalid. lia. }
  assert (Hlink0 : &(((semaphore_addr current)) # "Semaphore" ->ₛ "link") <> 0).
  { rewrite Hlink. lia. }
  rewrite Hret in Hidlink |- *.
  unfold SemaphoreRetired, store_idnode, store_node_self_linked.
  cbn [idnode_addr idnode_id].
  rewrite (embedded_field_addr__retirement_commit
    (LE_arrow_field (RE_const (semaphore_addr current) (FET_alias "Semaphore")) "id")
    "IdNode" "link").
  rewrite (embedded_field_addr__retirement_commit
    (LE_arrow_field (RE_const (&(((semaphore_addr current)) # "Semaphore" ->ₛ "id"))
      (FET_alias "IdNode")) "link") "SysDoubleLinklistNode" "node_prev").
  rewrite (embedded_field_addr__retirement_commit
    (LE_arrow_field (RE_const (&(((semaphore_addr current)) # "Semaphore" ->ₛ "id"))
      (FET_alias "IdNode")) "link") "SysDoubleLinklistNode" "node_next").
  split_pure_spatial.
  - sepcon_assoc_change. cancel.
  - split_pures; dump_pre_spatial; intuition.
Qed.
Lemma payload_rest_distinct__retirement_commit :
 forall wait current sems head,
 store_semaphore wait (&(((semaphore_addr current)) # "Semaphore" ->ₛ "link")) current **
 store_dll (store_semaphore wait) head (map semaphore_link_node sems)
 |-- “ Forall (fun obj => semaphore_addr obj <> semaphore_addr current) sems ”.
Proof.
 intros wait current sems head. unfold store_semaphore at 1. Intros_p Hpayload.
 sepcon_assoc_change.
 sep_apply_l_atomic (payload_dll_distinct__retirement_commit wait
   (semaphore_addr current) (semaphore_value current) sems head).
 Intros_p Hrest. dump_pre_spatial. exact Hrest.
Qed.
Lemma retire_empty_semaphore_memory__retirement_commit :
 forall sg drained prefix suffix current returned,
 os_semaphores drained = (prefix ++ current :: suffix)%list ->
 semaphore_context (os_semaphore_stable sg) ->
 NoDup (map semaphore_id (os_semaphores drained)) ->
 In (Build_IdNodeAbs (semaphore_id current) returned)
   (Znth (semaphore_id current mod hoffset (semaphore_manager_stable (os_semaphore_stable sg)))
     (idbuckets (semaphore_manager (os_semaphores drained))) nil) ->
 returned <> 0 -> &(returned # "IdNode" ->ₛ "link") <> 0 ->
 semaphore_pending_addrs current = nil ->
 store_dll (store_semaphore (pure_suspend_sched_link (task_desc_map (os_tasks drained))))
   &("k_sem_list") ((map semaphore_link_node prefix ++ map semaphore_link_node suffix)%list) **
 store_semaphore (pure_suspend_sched_link (task_desc_map (os_tasks drained)))
   (&(((semaphore_addr current)) # "Semaphore" ->ₛ "link")) current **
 store_node_self_linked (&(((semaphore_addr current)) # "Semaphore" ->ₛ "link")) **
 delete_global_frame sg drained **
 store_idmanager (semaphore_manager_stable (os_semaphore_stable sg))
   (idmanager_remove (semaphore_manager_stable (os_semaphore_stable sg))
     (semaphore_manager (os_semaphores drained)) (semaphore_id current)) &("k_sem_id_manager") **
 &(returned # "IdNode" ->ₛ "id") # UShort |-> 65535 **
 &(returned # "IdNode" ->ₛ "link" .ₛ "node_prev") # Ptr |-> &(returned # "IdNode" ->ₛ "link") **
 &(returned # "IdNode" ->ₛ "link" .ₛ "node_next") # Ptr |-> &(returned # "IdNode" ->ₛ "link")
 |-- os_inv sg (replace_semaphores
   (semaphore_unpublish (semaphore_addr current) (os_semaphores drained)) drained) **
 SemaphoreRetired (semaphore_addr current) (semaphore_value current).
Proof.
 intros sg drained prefix suffix current returned Hsems Hcontext Hnd Hcontains Hr0 Hrlink Hempty.
 assert (Hret : returned = &(((semaphore_addr current)) # "Semaphore" ->ₛ "id")).
 { eapply deleted_id_node_unique__retirement_commit; [exact Hnd| |reflexivity|exact Hcontains].
   rewrite Hsems. apply in_or_app. right. left. reflexivity. }
 rewrite <- map_app.
 sepcon_assoc_change.
 prop_apply_p (payload_rest_distinct__retirement_commit
   (pure_suspend_sched_link (task_desc_map (os_tasks drained))) current ((prefix ++ suffix)%list) &("k_sem_list")).
 Intros_p Hrest.
 assert (Hunpub : semaphore_unpublish (semaphore_addr current) (os_semaphores drained) = (prefix ++ suffix)%list).
 { rewrite Hsems. apply unpublish_current__retirement_commit; [reflexivity|exact Hrest]. }
 rewrite Hunpub.
 pose proof Hcontext as [_ [_ [Hoff _]]].
 rewrite Hsems in Hnd.
 rewrite Hsems, manager_remove_current__retirement_commit by assumption.
 assert (Hwait : semaphore_waiters ((prefix ++ suffix)%list) = semaphore_waiters (os_semaphores drained)).
 { rewrite Hsems. apply waiters_remove_empty__retirement_commit. exact Hempty. }
 sep_apply_l_atomic (global_frame_reindex__retirement_commit sg drained ((prefix ++ suffix)%list) Hwait).
 sep_apply_l_atomic (retired_payload__retirement_commit
   (pure_suspend_sched_link (task_desc_map (os_tasks drained))) current returned Hret Hr0 Hrlink Hempty).
 pose proof (inv_recompose__retirement_commit sg
   (replace_semaphores ((prefix ++ suffix)%list) drained) Hcontext) as Hinv.
 cbn [replace_semaphores os_tasks os_semaphores] in Hinv.
 sep_apply_l_atomic Hinv.
 cancel.
Qed.
Lemma retired_nonzero__retirement_commit : forall p v,
 SemaphoreRetired p v |-- “ p <> 0 ”.
Proof.
 intros p v. unfold SemaphoreRetired. Intros_p Hp.
 dump_pre_spatial. tauto.
Qed.
Lemma semaphore_bucket_member__lookup_views : forall sems bucket node,
  In bucket (idbuckets (semaphore_manager sems)) -> In node bucket ->
  exists sem, In sem sems /\ semaphore_idnode sem = node.
Proof.
  intros sems bucket node Hb Hn.
  unfold semaphore_manager in Hb; cbn [idbuckets] in Hb.
  apply in_map_iff in Hb as [i [Hb Hi]]. subst bucket.
  apply in_map_iff in Hn as [sem [Heq Hsem]].
  apply filter_In in Hsem as [Hin _]. eauto.
Qed.
Lemma semaphore_found_member__lookup_views : forall sg st manager node id,
  store_idmanager_found (semaphore_manager_stable sg)
    (semaphore_manager st) manager node id |--
  “ exists sem, In sem st /\ semaphore_id sem = id /\
      node = &(((semaphore_addr sem)) # "Semaphore" ->ₛ "id") ”.
Proof.
  intros sg st manager node id. unfold store_idmanager_found.
  Intros bytes prefix suffix bucket. rename H into Hfound.
  destruct Hfound as [Hr [Hm [Hb [Hbucket Hsplit]]]].
  assert (Hindex : 0 <= id mod hoffset (semaphore_manager_stable sg) <
    Zlength (idbuckets (semaphore_manager st))).
  { destruct Hb as [Hpos [Hlen Hb]]. rewrite Hlen.
    apply Z.mod_pos_bound; exact Hpos. }
  pose proof (Znth_In_Zlength (idbuckets (semaphore_manager st)) nil
    (id mod hoffset (semaphore_manager_stable sg)) Hindex) as Hin.
  rewrite <- Hbucket in Hin.
  assert (Hnode : In (Build_IdNodeAbs id node) bucket).
  { rewrite Hsplit. apply in_or_app. right. simpl; auto. }
  destruct (semaphore_bucket_member__lookup_views st bucket
    (Build_IdNodeAbs id node) Hin Hnode) as [sem [Hsem Heq]].
  unfold semaphore_idnode in Heq. inversion Heq.
  dump_pre_spatial. exists sem. auto.
Qed.
Lemma semaphore_segment_nonzero__lookup_views : forall wait sems sem x px y py,
  In sem sems ->
  dllseg (store_semaphore wait) x px y py (map semaphore_link_node sems) |--
  “ semaphore_addr sem <> 0 ”.
Proof.
  intros wait sems; induction sems as [| a rest IH]; intros sem x px y py Hin.
  - contradiction.
  - cbn [map dllseg]. Intros z.
    destruct Hin as [<- | Hin].
    + unfold store_semaphore. Intros_p Ha. dump_pre_spatial. tauto.
    + prop_apply_p (IH sem z x y py Hin). Intros_p Hnonzero.
      dump_pre_spatial. exact Hnonzero.
Qed.
Lemma semaphore_dll_nonzero__lookup_views : forall wait sems sem head,
  In sem sems ->
  store_dll (store_semaphore wait) head (map semaphore_link_node sems) |--
  “ semaphore_addr sem <> 0 ”.
Proof.
  intros wait sems sem head Hin. unfold store_dll. Intros first last.
  prop_apply_p (semaphore_segment_nonzero__lookup_views wait sems sem
    first head head last Hin).
  Intros_p Hnonzero. dump_pre_spatial. exact Hnonzero.
Qed.
Lemma semaphore_manager_close__lookup_views : forall sg st,
  store_idmanager (semaphore_manager_stable (os_semaphore_stable sg))
    (semaphore_manager (os_semaphores st)) &("k_sem_id_manager") **
  delete_manager_frame sg st |-- os_inv sg st.
Proof.
  intros sg st.
  unfold delete_manager_frame, delete_global_frame, os_inv, semaphore_inv.
  Intros_p Hctx. Intros_p Hwf.
  rewrite (proj1 Hctx).
  split_pure_spatial; [cancel | split_pures; dump_pre_spatial; auto].
Qed.
Lemma semaphore_frame_nonzero__lookup_views : forall sg st sem,
  In sem (os_semaphores st) -> delete_manager_frame sg st |--
  “ semaphore_addr sem <> 0 ”.
Proof.
  intros sg st sem Hin. unfold delete_manager_frame. Intros_p Hctx.
  prop_apply_p (semaphore_dll_nonzero__lookup_views
    (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_semaphores st)
    sem (semaphore_list_head (os_semaphore_stable sg)) Hin).
  Intros_p Hnonzero. dump_pre_spatial. exact Hnonzero.
Qed.
Lemma semaphore_found_close__lookup_views : forall sg st node id,
  store_idmanager_found (semaphore_manager_stable (os_semaphore_stable sg))
    (semaphore_manager (os_semaphores st)) &("k_sem_id_manager") node id **
  delete_manager_frame sg st |--
  EX sem, “ In sem (os_semaphores st) ” && “ semaphore_id sem = id ” &&
    “ node = &(((semaphore_addr sem)) # "Semaphore" ->ₛ "id") ” &&
    “ semaphore_addr sem <> 0 ” && os_inv sg st.
Proof.
  intros sg st node id.
  prop_apply_p (semaphore_found_member__lookup_views (os_semaphore_stable sg)
    (os_semaphores st) &("k_sem_id_manager") node id).
  Intros_p Hmember. destruct Hmember as [sem [Hin [Hid Haddr]]].
  sep_apply_l_atomic (store_idmanager_found_store_idmanager
    (semaphore_manager_stable (os_semaphore_stable sg))
    (semaphore_manager (os_semaphores st)) &("k_sem_id_manager") node id).
  prop_apply_p (semaphore_frame_nonzero__lookup_views sg st sem Hin).
  Intros_p Hnonzero.
  sep_apply_l_atomic (semaphore_manager_close__lookup_views sg st).
  Exists sem. split_pure_spatial; [cancel | split_pures; dump_pre_spatial; auto].
Qed.
Lemma dllseg_focus__pending_views {A : Type} (storeA : addr -> A -> Assertion)
    (l : list (DL_Node A)) (node : DL_Node A) :
  In node l -> forall x px y py,
  dllseg storeA x px y py l |--
  storeA node.(ptr) node.(data) **
  (storeA node.(ptr) node.(data) -* dllseg storeA x px y py l).
Proof.
  induction l as [|a tail IH]; intros Hin x px y py.
  - contradiction.
  - destruct Hin as [Heq|Hin].
    + subst a. cbn [dllseg]. Intros next. subst x.
      cancel.
      apply_sepcon_adjoint. Exists next.
      split_pure_spatial; [sepcon_assoc_change; cancel | split_pures; dump_pre_spatial; reflexivity].
    + cbn [dllseg]. Intros next. subst x.
      fold (dllseg storeA next (getPtr a) y py tail).
      sep_apply_l_atomic (IH Hin next (getPtr a) y py).
      cancel.
      apply_sepcon_adjoint.
      sep_apply_l_atomic (derivable1_wand_elim1
        (storeA (getPtr node) (getData node)) (dllseg storeA next (getPtr a) y py tail)).
      Exists next.
      fold (dllseg storeA next (getPtr a) y py tail).
      split_pure_spatial; [sepcon_assoc_change; cancel | split_pures; dump_pre_spatial; reflexivity].
Qed.
Lemma dll_focus__pending_views {A : Type} (storeA : addr -> A -> Assertion)
    (l : list (DL_Node A)) (node : DL_Node A) :
  In node l -> forall head,
  store_dll storeA head l |-- storeA node.(ptr) node.(data) **
    (storeA node.(ptr) node.(data) -* store_dll storeA head l).
Proof.
  intros Hin head. unfold store_dll at 1. Intros h last.
  sep_apply_l_atomic (dllseg_focus__pending_views storeA l node Hin h head head last).
  cancel. apply_sepcon_adjoint.
  sep_apply_l_atomic (derivable1_wand_elim1
    (storeA node.(ptr) node.(data)) (dllseg storeA h head head last l)).
  unfold store_dll. Exists h last.
  split_pure_spatial.
  - sepcon_assoc_change; cancel.
  - split_pures; dump_pre_spatial; tauto.
Qed.
Lemma semaphore_payload_pending__pending_views wait link sem :
  store_semaphore wait link sem |--
  store_dll wait (semaphore_pending_head sem.(semaphore_addr))
    (map sched_link_node sem.(semaphore_pending_addrs)) **
  (store_dll wait (semaphore_pending_head sem.(semaphore_addr))
    (map sched_link_node sem.(semaphore_pending_addrs)) -* store_semaphore wait link sem).
Proof.
  unfold store_semaphore at 1. Intros.
  change (map semaphore_wait_node (semaphore_pending_addrs sem)) with
    (map sched_link_node (semaphore_pending_addrs sem)).
  unfold semaphore_pending_head. sepcon_assoc_change; cancel.
  apply_sepcon_adjoint. unfold store_semaphore.
  change (map semaphore_wait_node (semaphore_pending_addrs sem)) with
    (map sched_link_node (semaphore_pending_addrs sem)).
  split_pure_spatial.
  - sepcon_assoc_change; cancel.
  - split_pures; dump_pre_spatial; tauto.
Qed.
Lemma os_inv_payload_focus__pending_views sg st original :
  In original st.(os_semaphores) ->
  os_inv sg st |--
  store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map))
    (&(((original.(semaphore_addr))) # "Semaphore" ->ₛ "link")) original **
  (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map))
    (&(((original.(semaphore_addr))) # "Semaphore" ->ₛ "link")) original -* os_inv sg st).
Proof.
  intro Hin. unfold os_inv at 1. Intros.
  unfold semaphore_inv at 1. Intros.
  pose proof (in_map semaphore_link_node _ _ Hin) as Hnode.
  sep_apply_l_atomic (dll_focus__pending_views
    (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map)))
    (map semaphore_link_node st.(os_semaphores))
    (semaphore_link_node original) Hnode
    sg.(os_semaphore_stable).(semaphore_list_head)).
  cbn [semaphore_link_node getPtr getData].
  sepcon_assoc_change; cancel. apply_sepcon_adjoint.
  sep_apply_l_atomic (derivable1_wand_elim1
    (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map))
      (&(((original.(semaphore_addr))) # "Semaphore" ->ₛ "link")) original)
    (store_dll (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map)))
      sg.(os_semaphore_stable).(semaphore_list_head)
      (map semaphore_link_node st.(os_semaphores)))).
  unfold os_inv, semaphore_inv.
  split_pure_spatial.
  - sepcon_assoc_change; cancel.
  - split_pures; dump_pre_spatial; tauto.
Qed.
Lemma pending_dll_focus__pending_views sg st original p :
  In original st.(os_semaphores) -> p = original.(semaphore_addr) ->
  os_inv sg st |--
  store_dll (pure_suspend_sched_link st.(os_tasks).(task_desc_map))
    (semaphore_pending_head p) (map sched_link_node original.(semaphore_pending_addrs)) **
  delete_pending_restore sg st p original.(semaphore_pending_addrs).
Proof.
  intros Hin Hp. subst p.
  sep_apply_l_atomic (os_inv_payload_focus__pending_views sg st original Hin).
  remember (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map))
    (&(((original.(semaphore_addr))) # "Semaphore" ->ₛ "link")) original -* os_inv sg st)
    as restore eqn:Hrestore.
  sep_apply_l_atomic (semaphore_payload_pending__pending_views
    (pure_suspend_sched_link st.(os_tasks).(task_desc_map))
    (&(((original.(semaphore_addr))) # "Semaphore" ->ₛ "link")) original).
  subst restore.
  sepcon_assoc_change; cancel. unfold delete_pending_restore.
  apply_sepcon_adjoint.
  sep_apply_l_atomic (derivable1_wand_elim1
    (store_dll (pure_suspend_sched_link st.(os_tasks).(task_desc_map))
      (semaphore_pending_head original.(semaphore_addr))
      (map sched_link_node original.(semaphore_pending_addrs)))
    (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map))
      (&(((original.(semaphore_addr))) # "Semaphore" ->ₛ "link")) original)).
  sep_apply_l_atomic (derivable1_wand_elim1
    (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map))
      (&(((original.(semaphore_addr))) # "Semaphore" ->ₛ "link")) original)
    (os_inv sg st)).
  cancel.
Qed.
Lemma dllseg_focus__id_read_views : forall A (storeA : addr -> A -> Assertion)
    nodes (node : DL_Node A) x px y py,
  In node nodes ->
  dllseg storeA x px y py nodes |--
  storeA node.(ptr) node.(data) **
    (storeA node.(ptr) node.(data) -* dllseg storeA x px y py nodes).
Proof.
  intros A storeA nodes. induction nodes as [|a rest IH];
    intros node x px y py Hin; [contradiction|].
  destruct Hin as [<-|Hin].
  - cbn [dllseg]. Intros z. rename H into Hx. subst x.
    cancel.
    apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)).
    Exists z. split_pure_spatial; [sepcon_right_assoc; cancel | dump_pre_spatial; reflexivity].
  - cbn [dllseg]. Intros z. rename H into Hx.
    sep_apply_l_atomic (IH node z x y py Hin).
    cancel.
    apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)). match goal with |- context[?P -* ?Q] =>
      sep_apply_l_atomic (derivable1_wand_elim2 P Q) end.
    Exists z. split_pure_spatial; [unfold dllseg; sepcon_right_assoc; cancel | dump_pre_spatial; exact Hx].
Qed.
Lemma dll_focus__id_read_views : forall A (storeA : addr -> A -> Assertion)
    head nodes (node : DL_Node A),
  In node nodes ->
  store_dll storeA head nodes |--
  storeA node.(ptr) node.(data) **
    (storeA node.(ptr) node.(data) -* store_dll storeA head nodes).
Proof.
  intros A storeA head nodes node Hin.
  unfold store_dll. Intros h pt. rename H into Hwf.
  sep_apply_l_atomic (dllseg_focus__id_read_views A storeA nodes node h head head pt Hin).
  cancel.
  apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)). match goal with |- context[?P -* ?Q] =>
      sep_apply_l_atomic (derivable1_wand_elim2 P Q) end.
  Exists h pt. split_pure_spatial; [sepcon_right_assoc; cancel | dump_pre_spatial; exact Hwf].
Qed.
Lemma idbucket_focus__id_read_views : forall head bucket node,
  In node bucket ->
  store_idbucket head bucket |--
  store_idnode (idnode_link node) node **
  (store_idnode (idnode_link node) node -* store_idbucket head bucket).
Proof.
  intros head bucket node Hin.
  destruct bucket as [|a rest]; [contradiction|].
  cbn [store_idbucket]. unfold store_idnodes.
  apply (dll_focus__id_read_views IdNodeAbs store_idnode head
    (idnodes_to_dll (a :: rest)) (idnode_to_dll node)).
  apply in_map. exact Hin.
Qed.
Lemma idbuckets_focus__id_read_views : forall buckets node h start,
  In node (List.concat buckets) ->
  store_idbucket_list h start buckets |--
  store_idnode (idnode_link node) node **
  (store_idnode (idnode_link node) node -* store_idbucket_list h start buckets).
Proof.
  intros buckets. induction buckets as [|b rest IH];
    intros node h start Hin; [contradiction|].
  cbn [List.concat] in Hin. apply in_app_or in Hin.
  remember (store_idnode (idnode_link node) node **
    (store_idnode (idnode_link node) node -* store_idbucket_list h start (b :: rest)))
    as result eqn:Hresult.
  cbn [store_idbucket_list]. destruct Hin as [Hin|Hin].
  - sep_apply_l_atomic (idbucket_focus__id_read_views
      (h + start * sizeof("SysDoubleLinklistNode")) b node Hin).
    subst result. cancel.
    apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)). match goal with |- context[?P -* ?Q] =>
      sep_apply_l_atomic (derivable1_wand_elim2 P Q) end. unfold store_idbucket_list; sepcon_right_assoc; cancel.
  - sep_apply_l_atomic (IH node h (start + 1) Hin).
    subst result. cancel.
    apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)). match goal with |- context[?P -* ?Q] =>
      sep_apply_l_atomic (derivable1_wand_elim2 P Q) end. unfold store_idbucket_list; sepcon_right_assoc; cancel.
Qed.
Lemma semaphore_idnode_in_buckets__id_read_views : forall st sem,
  In sem st -> In (semaphore_idnode sem)
    (List.concat (idbuckets (semaphore_manager st))).
Proof.
  intros st sem Hin. unfold semaphore_manager. cbn [idbuckets].
  apply in_concat.
  exists (map semaphore_idnode
    (filter (fun s => Z.eqb (semaphore_id s mod 16) (semaphore_id sem mod 16)) st)).
  split.
  - apply in_map_iff. exists (Z.to_nat (semaphore_id sem mod 16)).
    assert (Hr : 0 <= semaphore_id sem mod 16 < 16) by (apply Z.mod_pos_bound; lia).
    split.
    + rewrite Z2Nat.id by lia. reflexivity.
    + apply in_seq. lia.
  - apply in_map. apply filter_In. split; [exact Hin|apply Z.eqb_refl].
Qed.
Lemma resume_current_sem__id_read_views : forall before original drained p,
  In original (os_semaphores before) -> p = semaphore_addr original ->
  semaphore_resume_all_effect p (semaphore_pending_addrs original) before drained ->
  exists current, In current (os_semaphores drained) /\
    semaphore_addr current = p /\ semaphore_id current = semaphore_id original.
Proof.
  intros before original drained p Hin Hp Heffect.
  unfold semaphore_resume_all_effect in Heffect.
  destruct (semaphore_pending_addrs original) as [|task tail].
  - subst drained. exists original. auto.
  - destruct Heffect as [_ [_ [ready [_ ->]]]].
    cbn [os_semaphores replace_semaphores].
    unfold semaphore_set_pending.
    exists {| semaphore_addr := semaphore_addr original;
      semaphore_id := semaphore_id original; semaphore_value := semaphore_value original;
      semaphore_pending_addrs := nil |}.
    split; [|simpl; auto].
    apply in_map_iff. exists original. split; [|exact Hin].
    destruct (Z.eq_dec (semaphore_addr original) p); [reflexivity|congruence].
Qed.
Lemma idnode_scalar_focus__id_read_views : forall link node,
  store_idnode link node |--
  &(((idnode_addr node)) # "IdNode" ->ₛ "id") # UShort |-> idnode_id node **
  ((&(((idnode_addr node)) # "IdNode" ->ₛ "id") # UShort |-> idnode_id node)
    -* store_idnode link node).
Proof.
  intros link node. unfold store_idnode. Intros.
  cancel.
  apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)). Intros.
  split_pure_spatial; [sepcon_right_assoc; cancel | dump_pre_spatial; assumption].
Qed.
Lemma os_id_cell_focus__id_read_views : forall sg st current,
  In current (os_semaphores st) ->
  os_inv sg st |--
  (&(((semaphore_addr current)) # "Semaphore" ->ₛ "id" .ₛ "id") # UShort |-> semaphore_id current) **
  delete_id_restore sg st (semaphore_addr current) (semaphore_id current).
Proof.
  intros sg st current Hin.
  pose proof (semaphore_idnode_in_buckets__id_read_views _ _ Hin) as Hbucket.
  unfold os_inv at 1. unfold semaphore_inv at 1.
  unfold store_idmanager at 1. unfold store_idbuckets at 1. Intros.
  sep_apply_l_atomic (idbuckets_focus__id_read_views
    (idbuckets (semaphore_manager (os_semaphores st))) (semaphore_idnode current)
    (htable (semaphore_manager_stable (os_semaphore_stable sg))) 0 Hbucket).
  match goal with |- context[(store_idnode ?l ?n -* ?Q)] =>
    remember (store_idnode l n -* Q) as bucket_restore eqn:Hrestore end.
  sep_apply_l_atomic (idnode_scalar_focus__id_read_views
    (idnode_link (semaphore_idnode current)) (semaphore_idnode current)).
  unfold delete_id_restore. cbn [semaphore_idnode idnode_addr idnode_id]. csimpl.
  cancel.
  apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)).
  match goal with |- context[?P -* store_idnode ?l ?n] =>
    sep_apply_l_atomic (derivable1_wand_elim2 P (store_idnode l n)) end.
  subst bucket_restore.
  match goal with |- context[?P -* ?Q] =>
    sep_apply_l_atomic (derivable1_wand_elim2 P Q) end.
  unfold os_inv, semaphore_inv, store_idmanager, store_idbuckets.
  split_pure_spatial; [sepcon_right_assoc; cancel | split_pures; dump_pre_spatial; assumption].
Qed.
Lemma resume_id_cell_focus__id_read_views : forall sg before original drained p,
  In original (os_semaphores before) -> p = semaphore_addr original ->
  semaphore_resume_all_effect p (semaphore_pending_addrs original) before drained ->
  os_inv sg drained |--
  (&(p # "Semaphore" ->ₛ "id" .ₛ "id") # UShort |-> semaphore_id original) **
  delete_id_restore sg drained p (semaphore_id original).
Proof.
  intros sg before original drained p Hin Hp Heffect.
  destruct (resume_current_sem__id_read_views before original drained p Hin Hp Heffect)
    as [current [Hcurrent [Haddr Hid]]].
  rewrite <- Haddr, <- Hid.
  apply os_id_cell_focus__id_read_views. exact Hcurrent.
Qed.
Lemma delete_miss_continuation__lookup_miss : forall sg id before st X,
  id >= 0 -> Crtos_RTrans before st ->
  idmanager_query (semaphore_manager st.(os_semaphores))
    (unsigned_last_nbits id 16) = false ->
  monadesafe_lib.safeExec (LastSeen before) (abs_semaphore_delete sg id) X ->
  monadesafe_lib.safeExec (LastSeen st) (MonadErr.ret tt) X.
Proof.
  intros sg id before st X Hid Hrel Hquery Hexec.
  assert (Hmiss : forall sem, In sem st.(os_semaphores) ->
      sem.(semaphore_id) <> semaphore_query_id id).
  { unfold idmanager_query, semaphore_manager in Hquery; simpl in Hquery.
    apply id_in_ids_false_iff in Hquery.
    intros sem Hin Heq. apply Hquery.
    change (In (semaphore_query_id id) (map semaphore_id (os_semaphores st))).
    rewrite <- Heq. apply in_map. exact Hin. }
  unfold abs_semaphore_delete in Hexec.
  prog_nf in Hexec.
  assert (Hnonneg : (Z.ltb id 0) = false) by (apply Z.ltb_ge; lia).
  rewrite Hnonneg in Hexec.
  eapply (monadesafe_lib.highstepbind_derive
    (task_atomic_cmd (abs_semaphore_delete_locked id))
    (fun resched => if resched then abs_ktask_assign else MonadErr.ret tt)
    (LastSeen before) false (LastSeen st)).
  - intros states Hstates. exists (Crtos_RTrans st). split.
    + exists st, st. split.
      * apply (proj2 (Hstates st)). exact Hrel.
      * split; [exists 0; left; repeat split; auto | intro state; split; auto].
    + intro state; split; auto.
  - exact Hexec.
Qed.
Lemma self_to_storage__retired_raw : forall p, p <> 0 ->
 store_node_self_linked p |-- NodeStorage p.
Proof.
 intros p Hp. unfold store_node_self_linked, NodeStorage.
 sep_apply_l_atomic (store_ptr_undef_store_ptr (&(p # "SysDoubleLinklistNode" ->ₛ "node_prev")) p).
 sep_apply_l_atomic (store_ptr_undef_store_ptr (&(p # "SysDoubleLinklistNode" ->ₛ "node_next")) p).
 split_pure_spatial; [cancel | dump_pre_spatial; exact Hp].
Qed.
Lemma retired_to_raw__retired_raw : forall p value, SemaphoreRetired p value |-- SemaphoreRaw p.
Proof.
 intros p value. unfold SemaphoreRetired.
 Intros_p H. destruct H as [Hp [Ha [Hi [Hpend Hlink]]]].
 sep_apply_l_atomic (self_to_storage__retired_raw (&(p # "Semaphore" ->ₛ "id" .ₛ "link")) Hi).
 sep_apply_l_atomic (self_to_storage__retired_raw (&(p # "Semaphore" ->ₛ "pend_list")) Hpend).
 sep_apply_l_atomic (self_to_storage__retired_raw (&(p # "Semaphore" ->ₛ "link")) Hlink).
 unfold store_idnode. Intros_p Hid.
 cbn [idnode_addr idnode_id].
 let q := constr:(&(p # "Semaphore" ->ₛ "id")) in
 assert (Hfield : &(q # "IdNode" ->ₛ "id") = &(p # "Semaphore" ->ₛ "id" .ₛ "id")) by
   (rewrite addr_of_arrow_field; rewrite eval_addr; reflexivity).
 rewrite Hfield.
 sep_apply_l_atomic (store_ushort_undef_store_ushort (&(p # "Semaphore" ->ₛ "id" .ₛ "id")) 65535).
 sep_apply_l_atomic (store_ushort_undef_store_ushort (&(p # "Semaphore" ->ₛ "value")) value).
 unfold SemaphorePadding.
 sep_apply_l_atomic (CharArray.full_to_undef_full (p+2) 2 (repeat_Z 0 2)).
 sep_apply_l_atomic (CharArray.full_to_undef_full (p+14) 2 (repeat_Z 0 2)).
 unfold SemaphoreRaw.
 split_pure_spatial; [repeat progress cancel | dump_pre_spatial; auto].
Qed.
