From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.

Require Import Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.KMutexDelete CRTOS_Verify.lib.IdModuleSpec.
From MonadLib.MonadErr Require Import MonadErrHoare monadesafe_lib.
Import DLL IDNode MonadErr.
Local Open Scope string_scope.
Local Open Scope sac.

(** LinklistResumeAll返回后继续执行原helper第二段临界区；这只是bind的
    continuation，不加强函数规格或限制其余环境状态。 *)
Definition mutex_delete_after_resume (p id : Z)
    (X : unit -> (VarGlobalState -> Prop) -> Prop)
    : unit -> (VarGlobalState -> Prop) -> Prop :=
  fun _ states => weakestpre (abs_mutex_retire p id) X states.

(** 读取即将注销对象的ID时只借出该字段；返回同一值即可恢复同一os_inv。
    wand为空间资源，不是可以复制的纯假设。 *)
Definition mutex_delete_id_restore (sg : StableGlobalState) (st : VarGlobalState)
    (p id : Z) : Assertion :=
  (&(p # "Mutex" ->ₛ "id" .ₛ "id") # UShort |-> id) -* os_inv sg st.

(** 完整ID manager之外的精确frame：沿用已审阅非Mutex资源与Mutex管理DLL。
    管理DLL在ID摘除后仍然由本地持有，可继续完成管理节点摘除。 *)
Definition mutex_delete_manager_frame (sg : StableGlobalState) (st : VarGlobalState)
    : Assertion :=
  “ mutex_context sg.(os_mutex_stable) ” &&
  mutex_create_frame sg st **
  store_dll (store_mutex (pure_suspend_sched_link st.(os_tasks).(task_desc_map)))
    sg.(os_mutex_stable).(mutex_list_head) (map mutex_link_node st.(os_mutexes)).


From Coq Require Import Lia.
Lemma mapped_nodup_injective__retire_state :
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
Lemma selected_bucket_member__retire_state :
  forall (A : Type) (buckets : list (list A)) i x,
    In x (Znth i buckets nil) -> exists bucket, In bucket buckets /\ In x bucket.
Proof.
  intros A buckets i x Hin. unfold Znth in Hin.
  destruct (lt_dec (Z.to_nat i) (List.length buckets)) as [Hlt|Hge].
  - exists (nth (Z.to_nat i) buckets nil). split; [apply nth_In; exact Hlt|exact Hin].
  - rewrite nth_overflow in Hin by lia. contradiction.
Qed.
Lemma deleted_id_node_unique__retire_state :
  forall sm sems current id returned,
    NoDup (map mutex_id sems) -> In current sems -> mutex_id current = id ->
    In (Build_IdNodeAbs id returned)
      (Znth (id mod hoffset sm) (idbuckets (mutex_manager sems)) nil) ->
    returned = &(((mutex_addr current)) # "Mutex" ->ₛ "id").
Proof.
  intros sm sems current id returned Hnd Hcurrent Hid Hin.
  apply selected_bucket_member__retire_state in Hin as [bucket [Hbucket Hnode]].
  cbn [mutex_manager] in Hbucket.
  apply in_map_iff in Hbucket as [i [Hbucket Hi]]. subst bucket.
  apply in_map_iff in Hnode as [actual [Hactual Hin]].
  apply filter_In in Hin as [Hin Hhash].
  assert (Hactual_id : mutex_id actual = id).
  { apply (f_equal idnode_id) in Hactual. exact Hactual. }
  assert (actual = current) as ->.
  { eapply mapped_nodup_injective__retire_state; eauto. congruence. }
  apply (f_equal idnode_addr) in Hactual. cbn [mutex_idnode] in Hactual.
  symmetry. exact Hactual.
Qed.
Lemma unpublish_current__retire_state : forall prefix suffix current p,
  mutex_addr current = p ->
  Forall (fun obj => mutex_addr obj <> p) ((prefix ++ suffix)%list) ->
  mutex_delete_unpublish p ((prefix ++ current :: suffix)%list) = (prefix ++ suffix)%list.
Proof.
  intros prefix suffix current p Haddr Hrest.
  unfold mutex_delete_unpublish. rewrite filter_app. cbn.
  rewrite Haddr, Z.eqb_refl. cbn.
  apply Forall_app in Hrest as [Hp Hs].
  assert (forall xs, Forall (fun obj => mutex_addr obj <> p) xs ->
    filter (fun s => negb (Z.eqb (mutex_addr s) p)) xs = xs) as Hfilter.
  { intros xs H. induction H; cbn; auto.
    apply Z.eqb_neq in H. rewrite H. cbn. now rewrite IHForall. }
  rewrite (Hfilter prefix Hp), (Hfilter suffix Hs). reflexivity.
Qed.
Lemma task_world_reindex__retire_state : forall st sems,
  task_world_wf st -> task_world_wf (replace_mutexes sems st).
Proof.
  intros st sems H. destruct H. constructor; cbn [replace_mutexes]; assumption.
Qed.
Lemma service_reindex__retire_state : forall st sems entry slot,
  service_slot_wf st entry slot -> service_slot_wf (replace_mutexes sems st) entry slot.
Proof.
  intros st sems entry slot. unfold service_slot_wf.
  destruct (service_phase slot); try tauto.
  intros [desc H]. exists desc. destruct H. constructor; assumption.
Qed.
Lemma world_reindex__retire_state : forall sg st sems,
  mutex_waiters sems = mutex_waiters (os_mutexes st) ->
  os_world_wf sg st -> os_world_wf sg (replace_mutexes sems st).
Proof.
  intros sg st sems Hwait H. destruct H as [Hcontext Hrecycler Hidle Hnodup Hdomain].
  assert (Howners : os_sched_owners (replace_mutexes sems st) = os_sched_owners st).
  { unfold os_sched_owners.
    change ((sched_owned_tasks (os_tasks st) ++
      map (@getData addr) (os_ready_nodes (orvBuckets (assignReadyVector (os_assign st)))) ++
      map (@getData addr) (zombie_nodes (zombie_queue st)) ++
      semaphore_waiters (os_semaphores st) ++ mutex_waiters sems ++ event_waiters (os_events st))%list =
      (sched_owned_tasks (os_tasks st) ++
      map (@getData addr) (os_ready_nodes (orvBuckets (assignReadyVector (os_assign st)))) ++
      map (@getData addr) (zombie_nodes (zombie_queue st)) ++
      semaphore_waiters (os_semaphores st) ++ mutex_waiters (os_mutexes st) ++ event_waiters (os_events st))%list).
    now rewrite Hwait. }
  constructor.
  - exact Hcontext.
  - apply service_reindex__retire_state. exact Hrecycler.
  - cbn [replace_mutexes os_tasks os_tick os_delays os_assign zombie_queue os_recycle os_idle os_mutexes os_events os_isr os_exstatus os_semaphores]. eapply Forall_impl; [|exact Hidle].
    intros slot Hslot. apply service_reindex__retire_state. exact Hslot.
  - rewrite Howners. exact Hnodup.
  - rewrite Howners. cbn [replace_mutexes os_tasks os_tick os_delays os_assign zombie_queue os_recycle os_idle os_mutexes os_events os_isr os_exstatus os_semaphores]. exact Hdomain.
Qed.
Lemma task_inv_reindex__retire_state : forall sg st sems,
  task_inv sg st |-- task_inv sg (replace_mutexes sems st).
Proof.
  intros sg st sems. unfold task_inv. Intros_p Htask.
  cbn [replace_mutexes os_tasks].
  split_pure_spatial.
  - sepcon_assoc_change. cancel.
  - dump_pre_spatial. apply task_world_reindex__retire_state. exact Htask.
Qed.
Lemma global_frame_reindex__retire_state : forall sg st sems,
  mutex_waiters sems = mutex_waiters (os_mutexes st) ->
  mutex_create_frame sg st |-- mutex_create_frame sg (replace_mutexes sems st).
Proof.
  intros sg st sems Hwait. unfold mutex_create_frame. Intros_p Hworld.
  sep_apply_l_atomic (task_inv_reindex__retire_state sg st sems).
  assert (E1 : tick_inv sg (replace_mutexes sems st) = tick_inv sg st) by reflexivity.
  assert (E2 : delay_inv sg (replace_mutexes sems st) = delay_inv sg st) by reflexivity.
  assert (E3 : assign_inv sg (replace_mutexes sems st) = assign_inv sg st) by reflexivity.
  assert (E4 : exstatus_inv sg (replace_mutexes sems st) = exstatus_inv sg st) by reflexivity.
  rewrite E1, E2, E3, E4. cbn [replace_mutexes os_tasks os_tick os_delays os_assign zombie_queue os_recycle os_idle os_mutexes os_events os_isr os_exstatus os_semaphores].
  split_pure_spatial.
  - sepcon_assoc_change. cancel.
  - dump_pre_spatial. eapply world_reindex__retire_state; eauto.
Qed.
Lemma empty_dll_self__retire_state : forall (A : Type) (storeA : addr -> A -> Assertion) head,
  store_dll storeA head nil |-- (“ head <> 0 ” && store_node_self_linked head)%sac.
Proof.
  intros A storeA head. unfold store_dll. left_intro first_node. left_intro last_node. Intros_p Hnonzero.
  cbn [dllseg]. Intros_p Hempty. destruct Hempty as [-> <-].
  unfold store_node_self_linked. split_pure_spatial; [cancel|dump_pre_spatial; tauto].
Qed.
Lemma idnodes_remove_app__retire_state : forall id xs ys,
  idnodes_remove_id id ((xs ++ ys)%list) = (idnodes_remove_id id xs ++ idnodes_remove_id id ys)%list.
Proof.
  intros id xs. induction xs as [|x xs IH]; intro ys; cbn [app idnodes_remove_id]; auto.
  destruct (Z.eq_dec (idnode_id x) id); cbn; now rewrite IH.
Qed.
Lemma idnodes_remove_absent__retire_state : forall id nodes,
  (forall n, In n nodes -> idnode_id n <> id) -> idnodes_remove_id id nodes = nodes.
Proof.
  intros id nodes. induction nodes as [|n nodes IH]; intro H; cbn [idnodes_remove_id]; auto.
  destruct (Z.eq_dec (idnode_id n) id) as [Heq|Hne].
  - exfalso. apply (H n (or_introl eq_refl)); exact Heq.
  - f_equal. apply IH. intros x Hin. apply H. right; exact Hin.
Qed.
Lemma filtered_remove_absent__retire_state : forall id sems test,
  ~ In id (map mutex_id sems) ->
  idnodes_remove_id id (map mutex_idnode (filter test sems)) =
  map mutex_idnode (filter test sems).
Proof.
  intros id sems test Hnot. apply idnodes_remove_absent__retire_state.
  intros node Hin Heq. apply in_map_iff in Hin as [s [<- Hin]].
  apply filter_In in Hin as [Hin Htest]. apply Hnot.
  apply in_map_iff. exists s. split; [exact Heq|exact Hin].
Qed.
Lemma map_seq_nth__retire_state : forall (A : Type) (f : nat -> A) start len n d,
  (start <= n < start + len)%nat ->
  nth (n-start) (map f (seq start len)) d = f n.
Proof.
  intros A f start len n d Hrange.
  rewrite (@List.nth_indep A (map f (seq start len)) (n-start)%nat d (f 0%nat)) by (rewrite length_map, length_seq; lia).
  rewrite map_nth, seq_nth by lia. f_equal; lia.
Qed.
Lemma replace_map_seq__retire_state : forall (A : Type) (f g : nat -> A) len start n,
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
Lemma idlist_remove_current__retire_state : forall prefix suffix current,
  NoDup (map mutex_id ((prefix ++ current :: suffix)%list)) ->
  idlist_remove (mutex_id current) (map mutex_id ((prefix ++ current :: suffix)%list)) =
  map mutex_id ((prefix ++ suffix)%list).
Proof.
  intros prefix suffix current Hnd.
  rewrite map_app in Hnd. cbn [map] in Hnd.
  pose proof (NoDup_remove_2 (map mutex_id prefix) (map mutex_id suffix)
    (mutex_id current) Hnd) as Hnot.
  unfold idlist_remove. rewrite !map_app. cbn [map].
  rewrite remove_app, remove_cons.
  rewrite !notin_remove; [reflexivity| |]; intro Hin; apply Hnot;
    apply in_or_app; auto.
Qed.
Lemma idnodes_remove_current_cons__retire_state : forall current nodes,
  idnodes_remove_id (mutex_id current) (mutex_idnode current :: nodes) =
  idnodes_remove_id (mutex_id current) nodes.
Proof.
  intros current nodes.
  cbn [idnodes_remove_id mutex_idnode idnode_id].
  destruct (Z.eq_dec (mutex_id current) (mutex_id current)); [reflexivity|contradiction].
Qed.
Lemma bucket_remove_current__retire_state : forall prefix suffix current i,
  NoDup (map mutex_id ((prefix ++ current :: suffix)%list)) ->
  idnodes_remove_id (mutex_id current)
    (map mutex_idnode (filter (fun s => Z.eqb (mutex_id s mod 16) (Z.of_nat i))
      ((prefix ++ current :: suffix)%list))) =
  map mutex_idnode (filter (fun s => Z.eqb (mutex_id s mod 16) (Z.of_nat i)) ((prefix ++ suffix)%list)).
Proof.
  intros prefix suffix current i Hnd.
  rewrite map_app in Hnd. cbn [map] in Hnd.
  pose proof (NoDup_remove_2 (map mutex_id prefix) (map mutex_id suffix)
    (mutex_id current) Hnd) as Hnot.
  assert (Hp : ~ In (mutex_id current) (map mutex_id prefix)).
  { intro H; apply Hnot; apply in_or_app; auto. }
  assert (Hs : ~ In (mutex_id current) (map mutex_id suffix)).
  { intro H; apply Hnot; apply in_or_app; auto. }
  rewrite !filter_app. cbn [filter].
  destruct (Z.eqb (mutex_id current mod 16) (Z.of_nat i)); cbn [map];
    rewrite map_app, idnodes_remove_app__retire_state,
      (filtered_remove_absent__retire_state _ _ _ Hp).
  - cbn [map]. rewrite idnodes_remove_current_cons__retire_state.
    rewrite (filtered_remove_absent__retire_state _ _ _ Hs). try rewrite map_app. reflexivity.
  - rewrite (filtered_remove_absent__retire_state _ _ _ Hs). try rewrite map_app. reflexivity.
Qed.
Lemma other_bucket_current__retire_state : forall prefix suffix current i,
  i <> Z.to_nat (mutex_id current mod 16) ->
  map mutex_idnode (filter (fun s => Z.eqb (mutex_id s mod 16) (Z.of_nat i))
    ((prefix ++ current :: suffix)%list)) =
  map mutex_idnode (filter (fun s => Z.eqb (mutex_id s mod 16) (Z.of_nat i))
    ((prefix ++ suffix)%list)).
Proof.
  intros prefix suffix current i Hne. rewrite !filter_app. cbn [filter].
  assert (Heq : Z.eqb (mutex_id current mod 16) (Z.of_nat i) = false).
  { apply Z.eqb_neq. intro H. apply Hne. rewrite H, Nat2Z.id. reflexivity. }
  rewrite Heq. reflexivity.
Qed.
Lemma manager_remove_current__retire_state : forall sm prefix suffix current,
  hoffset sm = 16 -> NoDup (map mutex_id ((prefix ++ current :: suffix)%list)) ->
  idmanager_remove sm (mutex_manager ((prefix ++ current :: suffix)%list)) (mutex_id current) =
  mutex_manager ((prefix ++ suffix)%list).
Proof.
  intros sm prefix suffix current Hoff Hnd.
  unfold idmanager_remove, mutex_manager. cbn [idlist idbuckets].
  f_equal.
  - apply idlist_remove_current__retire_state. exact Hnd.
  - unfold idmanager_remove_bucket. rewrite Hoff. unfold replace_Znth, Znth.
    set (idx := Z.to_nat (mutex_id current mod 16)).
    set (oldb := fun i : nat => map mutex_idnode
      (filter (fun s => Z.eqb (mutex_id s mod 16) (Z.of_nat i))
        (prefix ++ current :: suffix)%list)).
    set (newb := fun i : nat => map mutex_idnode
      (filter (fun s => Z.eqb (mutex_id s mod 16) (Z.of_nat i))
        (prefix ++ suffix)%list)).
    change (replace_nth idx (map oldb (seq 0 16))
      (idnodes_remove_id (mutex_id current) (nth idx (map oldb (seq 0 16)) nil))
      = map newb (seq 0 16)).
    assert (Hrange : (0 <= idx < 0 + 16)%nat).
    { unfold idx. pose proof (Z.mod_pos_bound (mutex_id current) 16 ltac:(lia)); lia. }
    pose proof (map_seq_nth__retire_state _ oldb 0 16 idx nil Hrange) as Hnth.
    rewrite Nat.sub_0_r in Hnth. rewrite Hnth.
    assert (Hbucket : idnodes_remove_id (mutex_id current) (oldb idx) = newb idx).
    { unfold oldb, newb. apply bucket_remove_current__retire_state. exact Hnd. }
    rewrite Hbucket.
    pose proof (replace_map_seq__retire_state _ oldb newb 16 0 idx Hrange) as Hreplace.
    rewrite Nat.sub_0_r in Hreplace. apply Hreplace.
    intros i Hne. unfold oldb, newb.
    apply other_bucket_current__retire_state. exact Hne.
Qed.
Lemma inv_recompose__retire_state : forall sg st,
  mutex_context (os_mutex_stable sg) ->
  mutex_create_frame sg st **
  store_idmanager (mutex_manager_stable (os_mutex_stable sg))
    (mutex_manager (os_mutexes st)) &("k_mutex_id_manager") **
  store_dll (store_mutex (pure_suspend_sched_link (task_desc_map (os_tasks st))))
    &("k_mutex_list") (map mutex_link_node (os_mutexes st))
  |-- os_inv sg st.
Proof.
  intros sg st Hcontext.
  pose proof Hcontext as [Hmanager [_ [_ [_ [_ Hhead]]]]].
  unfold mutex_create_frame, os_inv, mutex_inv. Intros_p Hworld.
  rewrite Hmanager, Hhead.
  split_pure_spatial; [sepcon_assoc_change; cancel|split_pures; dump_pre_spatial; assumption].
Qed.
Lemma waiters_remove_empty__retire_state : forall prefix suffix current,
  mutex_pending_addrs current = nil ->
  mutex_waiters ((prefix ++ suffix)%list) = mutex_waiters ((prefix ++ current :: suffix)%list).
Proof.
  intros prefix suffix current Hempty.
  unfold mutex_waiters. rewrite !map_app, !concat_app.
  cbn [map concat]. rewrite Hempty. reflexivity.
Qed.
Lemma embedded_field_addr__retire_state : forall (L : lvalue_expr) (ty field : string),
  eval_addr_expr (RE_addr_of (LE_dot_field L field)) =
  eval_addr_expr (RE_addr_of (LE_arrow_field
    (RE_const (eval_addr_expr (RE_addr_of L)) (FET_alias ty)) field)).
Proof.
  intros L ty field.
  rewrite (eval_addr (RE_addr_of L) (FET_alias ty)).
  rewrite <- (addr_of_arrow_field L field). reflexivity.
Qed.
Lemma retired_payload__retire_state : forall wait current returned,
  returned = &(((mutex_addr current)) # "Mutex" ->ₛ "id") ->
  returned <> 0 -> &(returned # "IdNode" ->ₛ "link") <> 0 ->
  mutex_pending_addrs current = nil ->
  store_mutex wait (&(((mutex_addr current)) # "Mutex" ->ₛ "link")) current **
  store_node_self_linked (&(((mutex_addr current)) # "Mutex" ->ₛ "link")) **
  &(returned # "IdNode" ->ₛ "id") # UShort |-> 65535 **
  &(returned # "IdNode" ->ₛ "link" .ₛ "node_prev") # Ptr |-> &(returned # "IdNode" ->ₛ "link") **
  &(returned # "IdNode" ->ₛ "link" .ₛ "node_next") # Ptr |-> &(returned # "IdNode" ->ₛ "link")
  |-- MutexRetired current.
Proof.
  intros wait current returned Hret Hret0 Hidlink Hempty.
  unfold store_mutex. Intros_p Hpayload.
  destruct Hpayload as [Hp [Halign Hlinkeq]].
  rewrite Hempty. sep_apply_l_atomic (empty_dll_self__retire_state addr wait
    (&(((mutex_addr current)) # "Mutex" ->ₛ "pend_list"))).
  Intros_p Hpend.
  prop_apply_p (valid_store_ushort (&(returned # "IdNode" ->ₛ "id")) 65535).
  Intros_p Hvalid.
  pose proof (mutex_field_offset_axiom (mutex_addr current) Halign) as Hlayout.
  unfold mutex_field_offset_ok in Hlayout.
  destruct Hlayout as [Hsid [Hiid [Hilink [Hval [Hrecursive [Hprio [Hholder [Hpending [Hlink Hnodes]]]]]]]]].
  assert (Hreturned : returned = mutex_addr current) by congruence.
  assert (Hpos : 0 < mutex_addr current).
  { rewrite Hreturned, Hiid in Hvalid. unfold isvalidptr_short in Hvalid. lia. }
  assert (Hlink0 : &(((mutex_addr current)) # "Mutex" ->ₛ "link") <> 0).
  { rewrite Hlink. lia. }
  rewrite Hret in Hidlink |- *.
  unfold MutexRetired, store_idnode, store_node_self_linked.
  cbn [idnode_addr idnode_id].
  rewrite (embedded_field_addr__retire_state
    (LE_arrow_field (RE_const (mutex_addr current) (FET_alias "Mutex")) "id")
    "IdNode" "link").
  rewrite (embedded_field_addr__retire_state
    (LE_arrow_field (RE_const (&(((mutex_addr current)) # "Mutex" ->ₛ "id"))
      (FET_alias "IdNode")) "link") "SysDoubleLinklistNode" "node_prev").
  rewrite (embedded_field_addr__retire_state
    (LE_arrow_field (RE_const (&(((mutex_addr current)) # "Mutex" ->ₛ "id"))
      (FET_alias "IdNode")) "link") "SysDoubleLinklistNode" "node_next").
  split_pure_spatial.
  - sepcon_assoc_change. cancel.
  - split_pures; dump_pre_spatial; intuition.
Qed.
Lemma retire_continuation__retire_state : forall p id drained locked X,
  monadesafe_lib.safeExec (LastSeen drained) (abs_mutex_retire p id) X ->
  Crtos_RTrans drained locked -> mutex_delete_drained p id locked ->
  monadesafe_lib.safeExec
    (LastSeen (replace_mutexes (mutex_delete_unpublish p (os_mutexes locked)) locked))
    (MonadErr.ret tt) X.
Proof.
  intros p id drained locked X Hsafe Hrely Hguard.
  unfold monadesafe_lib.safeExec, monadesafe_lib.safe in Hsafe.
  destruct Hsafe as [states [Hlast Hwp]].
  change (forall st, states st <-> Crtos_RTrans drained st) in Hlast.
  unfold MonadErrHoare.weakestpre in Hwp. destruct Hwp as [Herr Hnormal].
  unfold monadesafe_lib.safeExec, monadesafe_lib.safe.
  exists (Crtos_RTrans (replace_mutexes (mutex_delete_unpublish p (os_mutexes locked)) locked)).
  split.
  - change (forall st, Crtos_RTrans (replace_mutexes (mutex_delete_unpublish p (os_mutexes locked)) locked) st <-> Crtos_RTrans (replace_mutexes (mutex_delete_unpublish p (os_mutexes locked)) locked) st). tauto.
  - unfold MonadErrHoare.weakestpre. split.
    + cbn. tauto.
    + intros r s Hret. destruct Hret as [Hr Hs]. subst.
      apply Hnormal. cbn [abs_mutex_retire mutex_delete_scoped_atomic abs_mutex_retire_locked].
      exists locked, (replace_mutexes (mutex_delete_unpublish p (os_mutexes locked)) locked).
      repeat split; try assumption; try reflexivity; try tauto.
      apply (proj2 (Hlast locked)). exact Hrely.
      all: unfold mutex_delete_drained in Hguard; tauto.
Qed.
Lemma retire_empty_mutex_memory__retire_state :
 forall sg drained prefix suffix current returned,
 os_mutexes drained = (prefix ++ current :: suffix)%list ->
 mutex_context (os_mutex_stable sg) ->
 NoDup (map mutex_id (os_mutexes drained)) ->
 NoDup (map mutex_addr (os_mutexes drained)) ->
 In (Build_IdNodeAbs (mutex_id current) returned)
   (Znth (mutex_id current mod hoffset (mutex_manager_stable (os_mutex_stable sg)))
     (idbuckets (mutex_manager (os_mutexes drained))) nil) ->
 returned <> 0 -> &(returned # "IdNode" ->ₛ "link") <> 0 ->
 mutex_pending_addrs current = nil ->
 store_dll (store_mutex (pure_suspend_sched_link (task_desc_map (os_tasks drained))))
   &("k_mutex_list") ((map mutex_link_node prefix ++ map mutex_link_node suffix)%list) **
 store_mutex (pure_suspend_sched_link (task_desc_map (os_tasks drained)))
   (&(((mutex_addr current)) # "Mutex" ->ₛ "link")) current **
 store_node_self_linked (&(((mutex_addr current)) # "Mutex" ->ₛ "link")) **
 mutex_create_frame sg drained **
 store_idmanager (mutex_manager_stable (os_mutex_stable sg))
   (idmanager_remove (mutex_manager_stable (os_mutex_stable sg))
     (mutex_manager (os_mutexes drained)) (mutex_id current)) &("k_mutex_id_manager") **
 &(returned # "IdNode" ->ₛ "id") # UShort |-> 65535 **
 &(returned # "IdNode" ->ₛ "link" .ₛ "node_prev") # Ptr |-> &(returned # "IdNode" ->ₛ "link") **
 &(returned # "IdNode" ->ₛ "link" .ₛ "node_next") # Ptr |-> &(returned # "IdNode" ->ₛ "link")
 |-- os_inv sg (replace_mutexes
   (mutex_delete_unpublish (mutex_addr current) (os_mutexes drained)) drained) **
 MutexRetired current.
Proof.
 intros sg drained prefix suffix current returned Hsems Hcontext Hnd Haddrnd Hcontains Hr0 Hrlink Hempty.
 assert (Hret : returned = &(((mutex_addr current)) # "Mutex" ->ₛ "id")).
 { eapply deleted_id_node_unique__retire_state; [exact Hnd| |reflexivity|exact Hcontains].
   rewrite Hsems. apply in_or_app. right. left. reflexivity. }
 rewrite <- map_app.
 sepcon_assoc_change.
 assert (Hrest : Forall (fun obj => mutex_addr obj <> mutex_addr current) ((prefix ++ suffix)%list)).
 { rewrite Hsems, map_app in Haddrnd. cbn [map] in Haddrnd.
   pose proof (NoDup_remove_2 (map mutex_addr prefix) (map mutex_addr suffix)
     (mutex_addr current) Haddrnd) as Hnot.
   apply Forall_forall. intros obj Hin Heq. apply Hnot.
   rewrite <- map_app. apply in_map_iff. exists obj. auto. }
 assert (Hunpub : mutex_delete_unpublish (mutex_addr current) (os_mutexes drained) = (prefix ++ suffix)%list).
 { rewrite Hsems. apply unpublish_current__retire_state; [reflexivity|exact Hrest]. }
 rewrite Hunpub.
 pose proof Hcontext as [_ [_ [Hoff _]]].
 rewrite Hsems in Hnd.
 rewrite Hsems, manager_remove_current__retire_state by assumption.
 assert (Hwait : mutex_waiters ((prefix ++ suffix)%list) = mutex_waiters (os_mutexes drained)).
 { rewrite Hsems. apply waiters_remove_empty__retire_state. exact Hempty. }
 sep_apply_l_atomic (global_frame_reindex__retire_state sg drained ((prefix ++ suffix)%list) Hwait).
 sep_apply_l_atomic (retired_payload__retire_state
   (pure_suspend_sched_link (task_desc_map (os_tasks drained))) current returned Hret Hr0 Hrlink Hempty).
 pose proof (inv_recompose__retire_state sg
   (replace_mutexes ((prefix ++ suffix)%list) drained) Hcontext) as Hinv.
 cbn [replace_mutexes os_tasks os_mutexes] in Hinv.
 sep_apply_l_atomic Hinv.
 cancel.
Qed.
Lemma dllseg_focus__borrow_id : forall A (storeA : addr -> A -> Assertion)
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
Lemma dll_focus__borrow_id : forall A (storeA : addr -> A -> Assertion)
    head nodes (node : DL_Node A),
  In node nodes ->
  store_dll storeA head nodes |--
  storeA node.(ptr) node.(data) **
    (storeA node.(ptr) node.(data) -* store_dll storeA head nodes).
Proof.
  intros A storeA head nodes node Hin.
  unfold store_dll. Intros h pt. rename H into Hwf.
  sep_apply_l_atomic (dllseg_focus__borrow_id A storeA nodes node h head head pt Hin).
  cancel.
  apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)). match goal with |- context[?P -* ?Q] =>
      sep_apply_l_atomic (derivable1_wand_elim2 P Q) end.
  Exists h pt. split_pure_spatial; [sepcon_right_assoc; cancel | dump_pre_spatial; exact Hwf].
Qed.
Lemma idbucket_focus__borrow_id : forall head bucket node,
  In node bucket ->
  store_idbucket head bucket |--
  store_idnode (idnode_link node) node **
  (store_idnode (idnode_link node) node -* store_idbucket head bucket).
Proof.
  intros head bucket node Hin.
  destruct bucket as [|a rest]; [contradiction|].
  cbn [store_idbucket]. unfold store_idnodes.
  apply (dll_focus__borrow_id IdNodeAbs store_idnode head
    (idnodes_to_dll (a :: rest)) (idnode_to_dll node)).
  apply in_map. exact Hin.
Qed.
Lemma idbuckets_focus__borrow_id : forall buckets node h start,
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
  - sep_apply_l_atomic (idbucket_focus__borrow_id
      (h + start * sizeof("SysDoubleLinklistNode")) b node Hin).
    subst result. cancel.
    apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)). match goal with |- context[?P -* ?Q] =>
      sep_apply_l_atomic (derivable1_wand_elim2 P Q) end. unfold store_idbucket_list; sepcon_right_assoc; cancel.
  - sep_apply_l_atomic (IH node h (start + 1) Hin).
    subst result. cancel.
    apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)). match goal with |- context[?P -* ?Q] =>
      sep_apply_l_atomic (derivable1_wand_elim2 P Q) end. unfold store_idbucket_list; sepcon_right_assoc; cancel.
Qed.
Lemma mutex_idnode_in_buckets__borrow_id : forall st sem,
  In sem st -> In (mutex_idnode sem)
    (List.concat (idbuckets (mutex_manager st))).
Proof.
  intros st sem Hin. unfold mutex_manager. cbn [idbuckets].
  apply in_concat.
  exists (map mutex_idnode
    (filter (fun s => Z.eqb (mutex_id s mod 16) (mutex_id sem mod 16)) st)).
  split.
  - apply in_map_iff. exists (Z.to_nat (mutex_id sem mod 16)).
    assert (Hr : 0 <= mutex_id sem mod 16 < 16) by (apply Z.mod_pos_bound; lia).
    split.
    + rewrite Z2Nat.id by lia. reflexivity.
    + apply in_seq. lia.
  - apply in_map. apply filter_In. split; [exact Hin|apply Z.eqb_refl].
Qed.
Lemma idnode_scalar_focus__borrow_id : forall link node,
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
Lemma os_id_cell_focus__borrow_id : forall sg st current,
  In current (os_mutexes st) ->
  os_inv sg st |--
  (&(((mutex_addr current)) # "Mutex" ->ₛ "id" .ₛ "id") # UShort |-> mutex_id current) **
  mutex_delete_id_restore sg st (mutex_addr current) (mutex_id current).
Proof.
  intros sg st current Hin.
  pose proof (mutex_idnode_in_buckets__borrow_id _ _ Hin) as Hbucket.
  unfold os_inv at 1. unfold mutex_inv at 1.
  unfold store_idmanager at 1. unfold store_idbuckets at 1. Intros.
  sep_apply_l_atomic (idbuckets_focus__borrow_id
    (idbuckets (mutex_manager (os_mutexes st))) (mutex_idnode current)
    (htable (mutex_manager_stable (os_mutex_stable sg))) 0 Hbucket).
  match goal with |- context[(store_idnode ?l ?n -* ?Q)] =>
    remember (store_idnode l n -* Q) as bucket_restore eqn:Hrestore end.
  sep_apply_l_atomic (idnode_scalar_focus__borrow_id
    (idnode_link (mutex_idnode current)) (mutex_idnode current)).
  unfold mutex_delete_id_restore. cbn [mutex_idnode idnode_addr idnode_id]. csimpl.
  cancel.
  apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)).
  match goal with |- context[?P -* store_idnode ?l ?n] =>
    sep_apply_l_atomic (derivable1_wand_elim2 P (store_idnode l n)) end.
  subst bucket_restore.
  match goal with |- context[?P -* ?Q] =>
    sep_apply_l_atomic (derivable1_wand_elim2 P Q) end.
  unfold os_inv, mutex_inv, store_idmanager, store_idbuckets.
  split_pure_spatial; [sepcon_right_assoc; cancel | split_pures; dump_pre_spatial; assumption].
Qed.
Lemma payload_neq__borrow_id : forall wait l1 l2 m1 m2,
  store_mutex wait l1 m1 ** store_mutex wait l2 m2 |--
  “ mutex_addr m1 <> mutex_addr m2 ”.
Proof.
  intros. destruct (Z.eq_dec (mutex_addr m1) (mutex_addr m2)) as [Heq|Hneq].
  - unfold store_mutex. rewrite Heq. Intros.
    match goal with |- context[?p # Ptr |-> mutex_holder m1] =>
      sep_apply_l_atomic (dup_store_ptr p (mutex_holder m1) (mutex_holder m2)) end.
    Intros_p HF. contradiction.
  - dump_pre_spatial. exact Hneq.
Qed.
Lemma dllseg_addresses_unique__borrow_id : forall wait ms x px y py,
 dllseg (store_mutex wait) x px y py (map mutex_link_node ms) |-- “ NoDup (map mutex_addr ms) ”.
Proof.
intros wait ms.
induction ms as [|m rest IH]; intros x px y py.
- dump_pre_spatial.
constructor.
- cbn [map dllseg].
Intros z.
rename H into Hx.
subst x.
destruct (in_dec Z.eq_dec (mutex_addr m) (map mutex_addr rest)) as [Hin|Hnot].
+ apply in_map_iff in Hin.
destruct Hin as [other [Heq Hin]].
assert (Hnode : In (mutex_link_node other) (map mutex_link_node rest)) by (apply in_map; exact Hin).
sep_apply_l_atomic (dllseg_focus__borrow_id MutexAbs (store_mutex wait) (map mutex_link_node rest) (mutex_link_node other) z (getPtr (mutex_link_node m)) y py Hnode).
cbn [mutex_link_node getPtr getData].
match goal with |- context[store_mutex wait ?l1 m] => match goal with |- context[store_mutex wait ?l2 other] => sep_apply_l_atomic (payload_neq__borrow_id wait l1 l2 m other) end end.
Intros_p Hneq.
exfalso.
apply Hneq.
symmetry.
exact Heq.
+ prop_apply_p (IH z (getPtr (mutex_link_node m)) y py).
Intros_p Hnd.
dump_pre_spatial.
constructor; assumption.
Qed.
Lemma mutex_addresses_unique__borrow_id : forall sg st, os_inv sg st |-- “ NoDup (map mutex_addr (os_mutexes st)) ”.
Proof.
intros sg st.
unfold os_inv, mutex_inv.
Intros.
match goal with |- context[store_dll (store_mutex ?w) ?h ?ms] => unfold store_dll at 1 end.
Intros h pt.
sep_apply_l_atomic (dllseg_addresses_unique__borrow_id (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_mutexes st) h (mutex_list_head (os_mutex_stable sg)) (mutex_list_head (os_mutex_stable sg)) pt).
Intros_p Hnd.
dump_pre_spatial.
exact Hnd.
Qed.
Lemma mutex_ids_unique__borrow_id : forall sg st,
  os_inv sg st |-- “ NoDup (map mutex_id (os_mutexes st)) ”.
Proof.
  intros sg st. unfold os_inv, mutex_inv, store_idmanager. Intros.
  dump_pre_spatial.
  match goal with H : idbuckets_ok _ _ _ _ |- _ =>
    destruct H as [_ [_ [[_ Hnd] _]]]; exact Hnd end.
Qed.
