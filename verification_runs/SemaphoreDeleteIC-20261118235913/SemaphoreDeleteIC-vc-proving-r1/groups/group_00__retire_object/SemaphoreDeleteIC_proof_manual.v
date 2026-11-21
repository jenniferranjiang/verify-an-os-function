From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.semaphore Require Import SemaphoreDeleteIC_goal.
From CRTOS_Verify.VC.semaphore Require Import SemaphoreDeleteIC_proof_auto.
Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreDelete.
Require Import CRTOS_Verify.lib.id.idnode CRTOS_Verify.lib.id.IdModuleSpec CRTOS_Verify.lib.common.dll CRTOS_Verify.lib.list.NodeSelfLinked.
Import IDNode DLL.
Local Open Scope sac.

Lemma proof_of__SemaphoreDelete_entail_wit_1 : _SemaphoreDelete_entail_wit_1.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_entail_wit_2 : _SemaphoreDelete_entail_wit_2.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_entail_wit_3_1 : _SemaphoreDelete_entail_wit_3_1.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_entail_wit_3_2 : _SemaphoreDelete_entail_wit_3_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
assert (Hfresh : forall wait l x px y py p v,
  dllseg (store_semaphore wait) x px y py (map semaphore_link_node l) **
  &(p # "Semaphore" ->ₛ "value") # UShort |-> v |--
  “ ~ In p (map semaphore_addr l) ”).
{ clear.
  intros wait l. induction l as [|a l IH]; intros x px y py p v.
  - cbn [map]. dump_pre_spatial. simpl. tauto.
  - cbn [map dllseg]. Intros z.
    destruct (Z.eq_dec p (semaphore_addr a)) as [Heq|Hneq].
    + unfold store_semaphore. Intros. rewrite Heq.
      let q := constr:(semaphore_addr a) in
      sep_apply_l_atomic (store_ushort_undef_store_ushort (&(q # "Semaphore" ->ₛ "value")) (semaphore_value a)).
      let q := constr:(semaphore_addr a) in
      sep_apply_l_atomic (store_ushort_undef_store_ushort (&(q # "Semaphore" ->ₛ "value")) v).
      let q := constr:(semaphore_addr a) in
      sep_apply_l_atomic (undef_store_int_exclusive 2 2 (&(q # "Semaphore" ->ₛ "value")) ltac:(lia)).
      Intros_p Hbad. contradiction.
    + change (store_semaphore wait x a **
        (&(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
        (&(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
        (dllseg (store_semaphore wait) z x y py (map semaphore_link_node l) **
        &(p # "Semaphore" ->ₛ "value") # UShort |-> v))) |--
        “ ~ In p (semaphore_addr a :: map semaphore_addr l) ”).
      sep_apply (IH z x y py p v).
      Intros_p Htail. dump_pre_spatial. simpl. intuition congruence.
}
  rename before_dataqueue_cleanup_ic into before, sg_dataqueue_cleanup_ic into sg.
  rewrite <- map_app.
  unfold store_semaphore at 2. Intros.
  unfold store_dll at 1. Intros h pt. Intros.
  prop_apply_p (Hfresh (pure_suspend_sched_link (task_desc_map (os_tasks before)))
    (prefix ++ suffix) h (&("k_sem_list")) (&("k_sem_list")) pt
    (semaphore_addr original) (semaphore_value original)).
  Intros_p Hfresh_remaining.
  rewrite PreH13. cbn [map]. unfold store_dll. Intros ph pp. cbn [dllseg]. Intros. destruct H2 as [Hph Hpp]. subst ph pp. 
  assert (Hfilter : forall l, ~ In (semaphore_addr original) (map semaphore_addr l) ->
    semaphore_unpublish (semaphore_addr original) l = l).
  { intros l. induction l as [|x xs IH]; intro Hnot; [reflexivity|].
    unfold semaphore_unpublish in *. cbn [filter].
    assert (Hneq : semaphore_addr x <> semaphore_addr original).
    { intro Heq. apply Hnot. cbn. auto. }
    apply Z.eqb_neq in Hneq. rewrite Hneq. cbn.
    f_equal. apply IH. intro Hin. apply Hnot. cbn. auto. }
  assert (Hunpublish : semaphore_unpublish (semaphore_addr original) (os_semaphores before) = prefix ++ suffix).
  { rewrite PreH14. unfold semaphore_unpublish at 1. rewrite filter_app.
    cbn [filter]. rewrite Z.eqb_refl. cbn.
    change (semaphore_unpublish (semaphore_addr original) prefix ++
      semaphore_unpublish (semaphore_addr original) suffix = prefix ++ suffix).
    rewrite !Hfilter; try reflexivity;
      rewrite map_app in Hfresh_remaining; intro Hin; apply Hfresh_remaining;
      apply in_or_app; auto. }
  assert (Hunique : forall l a b, NoDup (map semaphore_id l) ->
    In a l -> In b l -> semaphore_id a = semaphore_id b -> a = b).
  { clear. induction l as [|x xs IH]; intros a b Hnd Ha Hb Hid; [contradiction|].
    inversion Hnd as [|? ? Hnot Htail]; subst. simpl in Ha,Hb.
    destruct Ha as [<-|Ha]; destruct Hb as [<-|Hb]; auto.
    - exfalso. apply Hnot. rewrite Hid. apply in_map; assumption.
    - exfalso. apply Hnot. rewrite <- Hid. apply in_map; assumption.
    }
  assert (Hnode : idnode_2 = &(sem # "Semaphore" ->ₛ "id")).
  { rewrite PreH9. assert (Hoff : hoffset (semaphore_manager_stable (os_semaphore_stable sg)) = 16)
      by (destruct PreH19 as [_ [_ [Ht _]]]; exact Ht).
    unfold idmanager_contains, semaphore_manager in PreH2.
    cbn [idbuckets] in PreH2. rewrite Hoff in PreH2.
    assert (Hmod : 0 <= delete_sem_id mod 16 < 16) by (apply Z.mod_pos_bound; lia).
    remember (delete_sem_id mod 16) as k eqn:Hk.
    assert (Hcases : k=0 \/ k=1 \/ k=2 \/ k=3 \/ k=4 \/ k=5 \/ k=6 \/ k=7 \/
      k=8 \/ k=9 \/ k=10 \/ k=11 \/ k=12 \/ k=13 \/ k=14 \/ k=15) by lia.
    repeat destruct Hcases as [Hcases|Hcases]; rewrite Hcases in PreH2;
      cbn [seq map Znth] in PreH2;
      apply in_map_iff in PreH2; destruct PreH2 as [found [Heq Hin]];
      apply filter_In in Hin; destruct Hin as [Hin _];
      unfold semaphore_idnode in Heq; inversion Heq;
      assert (found = original) by
        (eapply Hunique; [exact PreH15|exact Hin|rewrite PreH14; apply in_or_app; right; simpl; auto|congruence]);
      subst found; congruence. }
  assert (Hwait : semaphore_waiters (os_semaphores before) = semaphore_waiters (prefix ++ suffix)).
  { rewrite PreH14. unfold semaphore_waiters. rewrite !map_app, !concat_app.
    cbn [map concat]. rewrite PreH13. reflexivity. }
  assert (Howners : os_sched_owners (replace_semaphores (prefix ++ suffix) before) = os_sched_owners before).
  { unfold os_sched_owners. cbn [replace_semaphores os_semaphores os_mutexes os_events os_tasks os_assign os_delays]. rewrite <- Hwait. reflexivity. }
  assert (Hworld : os_world_wf sg (replace_semaphores (prefix ++ suffix) before)).
  { destruct PreH18 as [Hctx Hrec Hidle Hnd Hdom].
    constructor; cbn [replace_semaphores]; try assumption.
    - unfold service_slot_wf in *; simpl.
      destruct (service_phase (os_recycle before)); try assumption.
      destruct Hrec as [d Hd]. exists d. destruct Hd; constructor; assumption.
    - simpl. eapply List.Forall_impl; [|exact Hidle]. intros x Hx.
      unfold service_slot_wf in *. destruct (service_phase x); try assumption.
      destruct Hx as [d Hd]. exists d. destruct Hd; constructor; assumption.
    - rewrite Howners. exact Hnd.
    - intro task. rewrite Howners. apply Hdom. }
  assert (Hidabsent : ~ In (semaphore_id original) (map semaphore_id (prefix ++ suffix))).
  { rewrite map_app. apply NoDup_remove_2.
    rewrite PreH14, map_app in PreH15. exact PreH15. }
  assert (Hremove_ids : forall l, ~ In (semaphore_id original) l ->
    remove Z.eq_dec (semaphore_id original) l = l).
  { clear -original. intros l. induction l as [|x xs IH]; intro Hn; [reflexivity|].
    cbn. destruct (Z.eq_dec (semaphore_id original) x); [subst; exfalso; apply Hn; simpl; auto|].
    f_equal. apply IH. intro Hin. apply Hn. simpl; auto. }
  assert (Hremove_nodes_app : forall id l1 l2,
    idnodes_remove_id id (l1 ++ l2) = idnodes_remove_id id l1 ++ idnodes_remove_id id l2).
  { clear. intros id l1. induction l1 as [|x xs IH]; intro l2; [reflexivity|].
    cbn. destruct (Z.eq_dec (idnode_id x) id); simpl; rewrite IH; reflexivity. }
  assert (Hremove_nodes_keep : forall l test,
    ~ In (semaphore_id original) (map semaphore_id l) ->
    idnodes_remove_id (semaphore_id original) (map semaphore_idnode (filter test l)) =
      map semaphore_idnode (filter test l)).
  { clear -original. intros l. induction l as [|x xs IH]; intros test Hn; [reflexivity|].
    cbn [filter]. destruct (test x); cbn [map idnodes_remove_id semaphore_idnode idnode_id].
    - destruct (Z.eq_dec (semaphore_id x) (semaphore_id original)) as [He|He].
      + exfalso. apply Hn. cbn. auto.
      + f_equal. apply IH. intro Hin. apply Hn. cbn; auto.
    - apply IH. intro Hin. apply Hn. cbn; auto. }
  assert (Hpreid : ~ In (semaphore_id original) (map semaphore_id prefix)).
  { intro Hin. apply Hidabsent. rewrite map_app. apply in_or_app; auto. }
  assert (Hsufid : ~ In (semaphore_id original) (map semaphore_id suffix)).
  { intro Hin. apply Hidabsent. rewrite map_app. apply in_or_app; auto. }
  assert (Hmanager : idmanager_remove (semaphore_manager_stable (os_semaphore_stable sg))
      (semaphore_manager (os_semaphores before)) delete_sem_id = semaphore_manager (prefix ++ suffix)).
  { rewrite PreH11, PreH14.
    destruct PreH19 as [_ [_ [Hoff _]]].
    unfold idmanager_remove, semaphore_manager, idmanager_remove_bucket, idlist_remove.
    cbn [idlist idbuckets]. rewrite Hoff. f_equal.
    - rewrite !map_app, remove_app. cbn [map]. rewrite remove_cons.
      rewrite !Hremove_ids; auto.
    - assert (Hmod : 0 <= semaphore_id original mod 16 < 16) by (apply Z.mod_pos_bound; lia).
      remember (semaphore_id original mod 16) as k eqn:Hk.
      assert (Hcases : k=0 \/ k=1 \/ k=2 \/ k=3 \/ k=4 \/ k=5 \/ k=6 \/ k=7 \/
        k=8 \/ k=9 \/ k=10 \/ k=11 \/ k=12 \/ k=13 \/ k=14 \/ k=15) by lia.
      cbn [seq map]. repeat rewrite filter_app. repeat rewrite map_app.
      cbn [filter map]. rewrite <- Hk.
      repeat destruct Hcases as [Hcases|Hcases]; rewrite Hcases;
        cbn; cbv [Pos.to_nat Pos.iter_op]; cbn;
        repeat rewrite Hremove_nodes_app;
        repeat rewrite Hremove_nodes_keep by assumption;
        cbn [idnodes_remove_id semaphore_idnode idnode_id];
        destruct (Z.eq_dec (semaphore_id original) (semaphore_id original)); try congruence;
        repeat rewrite Hremove_nodes_keep by assumption; try reflexivity.
    }
assert (Hshort : forall p, (p # UShort |->_) |-- CharArray.undef_full p 2).
{ intros p.
  unfold poly_undef_store, undef_store_ushort, undef_store_char, undef_store_integer,
    CharArray.undef_full, store_undef_array.
  simpl_nonptr_sizeof.
  cbn [store_undef_array_rec Z.to_nat Pos.to_nat undef_store_bytes].
  repeat rewrite Z.mul_1_r. repeat rewrite Z.add_0_r.
  Intros.
  change (Pos.to_nat 2) with 2%nat.
  cbn [store_undef_array_rec].
  unfold poly_undef_store, undef_store_char, undef_store_integer.
  simpl_nonptr_sizeof. cbn [undef_store_bytes Z.to_nat].
  repeat rewrite Z.mul_1_r. repeat rewrite Z.add_0_r.
  split_pure_spatial.
  - cbn [Z.add]. repeat progress cancel.
  - split_pures; dump_pre_spatial;
    unfold valid_object, Arch.valid_object, Arch.valid_addr_range, aligned, Arch.aligned in *;
    simpl_nonptr_sizeof; repeat rewrite Z.mod_1_r; cbn in *; lia.
}
assert (Hptr : forall p, (p # Ptr |->_) |-- (p # UInt |->_)).
{ intros p.
  unfold poly_undef_store, undef_store_ptr, undef_store_uint, undef_store_integer.
  simpl_nonptr_sizeof. cbn. cancel.
  change (valid_object p 4 4) with (valid_object p sizeof(PTR) Arch.ptr_align).
  change (Z.to_nat sizeof(PTR)) with 4%nat.
  cbn [undef_store_bytes]. repeat progress cancel.
}
assert (Huint : forall p, (p # UInt |->_) |-- CharArray.undef_full p 4).
{ intros p. rewrite undef_store_uint_undef_store_char. Intros_p Hbytes.
  unfold CharArray.undef_full, store_undef_array.
  cbn [store_undef_array_rec Z.to_nat]. simpl_nonptr_sizeof.
  repeat progress cancel. change (Pos.to_nat 4) with 4%nat.
  cbn [store_undef_array_rec].
  repeat rewrite Z.add_0_r. repeat rewrite Z.mul_1_r.
  split_pure_spatial.
  - repeat progress cancel. cbn [Z.add]. repeat progress cancel.
    change (Z.pos (1+1)) with 2. change (Z.pos (1+1+1)) with 3.
    repeat progress cancel.
  - split_pures; dump_pre_spatial; reflexivity.
}
assert (Hraw : forall sem, addr_aligned sem 4 -> SemaphoreRaw sem |-- CharArray.undef_full sem 32).
{
intros q Halign.
unfold SemaphoreRaw, NodeStorage.
Intros.
pose proof (semaphore_field_offsets_trusted q Halign) as Hl.
unfold semaphore_byte_layout in Hl.
destruct Hl as [Hid [Hiid [Hil [Hv [Hp [Hlink Hnodes]]]]]].
assert (Hidid : &(q # "Semaphore" ->ₛ "id" .ₛ "id") =
  (let q : addr := &(q # "Semaphore" ->ₛ "id") in &(q # "IdNode" ->ₛ "id"))).
{ simpl. rewrite addr_of_arrow_field. rewrite eval_addr. reflexivity. }
assert (Hidlink : &(q # "Semaphore" ->ₛ "id" .ₛ "link") =
  (let q : addr := &(q # "Semaphore" ->ₛ "id") in &(q # "IdNode" ->ₛ "link"))).
{ simpl. rewrite addr_of_arrow_field. rewrite eval_addr. reflexivity. }
rewrite Hidid,Hidlink.
rewrite ?Hid. cbn zeta.
rewrite ?Hiid, ?Hil, ?Hv, ?Hp, ?Hlink.
destruct (Hnodes 4 ltac:(simpl; auto)) as [H4n H4p].
destruct (Hnodes 16 ltac:(simpl; auto)) as [H16n H16p].
destruct (Hnodes 24 ltac:(simpl; auto)) as [H24n H24p].
rewrite ?H4n,?H4p,?H16n,?H16p,?H24n,?H24p.
replace (q+4+4) with (q+8) by lia.
replace (q+16+4) with (q+20) by lia.
replace (q+24+4) with (q+28) by lia.
sep_apply_l_atomic (Hshort q).
sep_apply_l_atomic (Hshort (q+12)).
sep_apply_l_atomic (Hptr (q+4)). sep_apply_l_atomic (Huint (q+4)).
sep_apply_l_atomic (Hptr (q+8)). sep_apply_l_atomic (Huint (q+8)).
sep_apply_l_atomic (Hptr (q+16)). sep_apply_l_atomic (Huint (q+16)).
sep_apply_l_atomic (Hptr (q+20)). sep_apply_l_atomic (Huint (q+20)).
sep_apply_l_atomic (Hptr (q+24)). sep_apply_l_atomic (Huint (q+24)).
sep_apply_l_atomic (Hptr (q+28)). sep_apply_l_atomic (Huint (q+28)).
sep_apply_r_atomic (CharArray.undef_full_merge_to_undef_full q 28 32 ltac:(lia)).
sepcon_right_assoc.
sep_apply_r_atomic (CharArray.undef_full_merge_to_undef_full q 24 28 ltac:(lia)).
sepcon_right_assoc.
sep_apply_r_atomic (CharArray.undef_full_merge_to_undef_full q 20 24 ltac:(lia)).
sepcon_right_assoc.
sep_apply_r_atomic (CharArray.undef_full_merge_to_undef_full q 16 20 ltac:(lia)).
sepcon_right_assoc.
sep_apply_r_atomic (CharArray.undef_full_merge_to_undef_full q 14 16 ltac:(lia)).
sepcon_right_assoc.
sep_apply_r_atomic (CharArray.undef_full_merge_to_undef_full q 12 14 ltac:(lia)).
sepcon_right_assoc.
sep_apply_r_atomic (CharArray.undef_full_merge_to_undef_full q 8 12 ltac:(lia)).
sepcon_right_assoc.
sep_apply_r_atomic (CharArray.undef_full_merge_to_undef_full q 4 8 ltac:(lia)).
sepcon_right_assoc.
sep_apply_r_atomic (CharArray.undef_full_merge_to_undef_full q 2 4 ltac:(lia)).
sepcon_right_assoc.
simpl_nonptr_sizeof. cbn. repeat rewrite Z.mul_1_r.
repeat progress cancel.
}
  assert (Hquery : semaphore_query_id id_pre = id_pre).
  { unfold semaphore_query_id. apply Z.mod_small. lia. }
  assert (Hqueues : dataqueue_inv (os_semaphores before) (os_dataqueues before) |--
    dataqueue_inv (prefix ++ suffix) (os_dataqueues before)).
  { unfold dataqueue_inv. Intros_p Hq. split_pure_spatial; [cancel|].
    dump_pre_spatial. intros p q Hlookup.
    destruct (Hq p q Hlookup) as [Hr [[sb [Hb Hbid]] [sd [Hd Hdid]]]].
    destruct (PreH17 ltac:(lia)) as [_ Hn].
    destruct (Hn p q Hlookup) as [Hblank Hdata]. rewrite Hquery in Hblank,Hdata.
    split; [exact Hr|]. unfold dataqueue_semaphores.
    split; [exists sb|exists sd]; split; try assumption.
    - rewrite PreH14 in Hb. apply in_app_iff in Hb. apply in_app_iff.
      destruct Hb as [Hb|[Hb|Hb]]; auto. subst sb. exfalso. apply Hblank; congruence.
    - rewrite PreH14 in Hd. apply in_app_iff in Hd. apply in_app_iff.
      destruct Hd as [Hd|[Hd|Hd]]; auto. subst sd. exfalso. apply Hdata; congruence. }
  assert (Halign : addr_aligned sem 4) by (rewrite PreH9; tauto).
  assert (Hnonnull : sem <> 0) by (rewrite PreH9; tauto).
  let p := constr:(semaphore_addr original) in
    prop_apply_p (valid_store_ushort (&(p # "Semaphore" ->ₛ "value")) (semaphore_value original)).
  Intros_p Hvalvalid.
  assert (Hlinknonzero : &(sem # "Semaphore" ->ₛ "link") <> 0).
  { pose proof (semaphore_field_offsets_trusted sem Halign) as Hl.
    unfold semaphore_byte_layout in Hl.
    destruct Hl as [_ [_ [_ [Hv [_ [Hlink _]]]]]].
    rewrite <- PreH9 in Hvalvalid. rewrite Hv in Hvalvalid. rewrite Hlink.
    unfold valid_object, Arch.valid_object, Arch.valid_addr_range in Hvalvalid.
    lia. }
  Exists (replace_semaphores (prefix ++ suffix) before).
  split_pure_spatial.
  - sep_apply_r_atomic (Hraw sem Halign).
    unfold os_inv, semaphore_inv.
    cbn [replace_semaphores os_tasks os_semaphores os_dataqueues os_tick os_delays
      os_assign zombie_queue os_recycle os_idle os_isr os_exstatus os_mutexes os_events].
    rewrite <- Hmanager.
    destruct PreH19 as [Hmanagerptr [Hmax [Hoff [Hmap [Htable Hhead]]]]].
    rewrite Hmanagerptr,Hhead. sep_apply Hqueues.
    unfold store_dll. Exists h pt.
    unfold task_inv, tick_inv, delay_inv, assign_inv, exstatus_inv.
    cbn [replace_semaphores os_tasks os_tick os_delays os_assign os_exstatus]. Intros.
    unfold SemaphoreRaw, NodeStorage, store_node_self_linked.
    rewrite Hnode. cbn [map].
    rewrite <- PreH9.

    assert (Hidid : &(sem # "Semaphore" ->ₛ "id" .ₛ "id") =
      (let q : addr := &(sem # "Semaphore" ->ₛ "id") in &(q # "IdNode" ->ₛ "id"))).
    { simpl. rewrite addr_of_arrow_field, eval_addr. reflexivity. }
    assert (Hidlink : &(sem # "Semaphore" ->ₛ "id" .ₛ "link") =
      (let q : addr := &(sem # "Semaphore" ->ₛ "id") in &(q # "IdNode" ->ₛ "link"))).
    { simpl. rewrite addr_of_arrow_field, eval_addr. reflexivity. }
    rewrite Hidid,Hidlink.
    rewrite idnode_link_node_prev_addr, idnode_link_node_next_addr. cbn zeta.
    split_pure_spatial.
    + repeat progress cancel.
      let q := constr:(&(sem # "Semaphore" ->ₛ "id")) in
      sep_apply_l_atomic (store_ushort_undef_store_ushort (&(q # "IdNode" ->ₛ "id")) 65535).
    sep_apply_l_atomic (store_ushort_undef_store_ushort (&(sem # "Semaphore" ->ₛ "value")) (semaphore_value original)).
    let idp := constr:(&(sem # "Semaphore" ->ₛ "id")) in
    let q := constr:(&(idp # "IdNode" ->ₛ "link")) in
      sep_apply_l_atomic (store_ptr_undef_store_ptr (&(q # "SysDoubleLinklistNode" ->ₛ "node_prev")) q).
    let idp := constr:(&(sem # "Semaphore" ->ₛ "id")) in
    let q := constr:(&(idp # "IdNode" ->ₛ "link")) in
      sep_apply_l_atomic (store_ptr_undef_store_ptr (&(q # "SysDoubleLinklistNode" ->ₛ "node_next")) q).
    let q := constr:(&(sem # "Semaphore" ->ₛ "pend_list")) in
      sep_apply_l_atomic (store_ptr_undef_store_ptr (&(q # "SysDoubleLinklistNode" ->ₛ "node_prev")) q).
    let q := constr:(&(sem # "Semaphore" ->ₛ "pend_list")) in
      sep_apply_l_atomic (store_ptr_undef_store_ptr (&(q # "SysDoubleLinklistNode" ->ₛ "node_next")) q).
    let q := constr:(&(sem # "Semaphore" ->ₛ "link")) in
      sep_apply_l_atomic (store_ptr_undef_store_ptr (&(q # "SysDoubleLinklistNode" ->ₛ "node_prev")) q).
    let q := constr:(&(sem # "Semaphore" ->ₛ "link")) in
      sep_apply_l_atomic (store_ptr_undef_store_ptr (&(q # "SysDoubleLinklistNode" ->ₛ "node_next")) q).
    unfold SemaphorePadding.
    sep_apply_l_atomic (CharArray.full_to_undef_full (sem+2) 2 (repeat_Z 0 2)).
    sep_apply_l_atomic (CharArray.full_to_undef_full (sem+14) 2 (repeat_Z 0 2)).
      repeat progress cancel.
    + split_pures; dump_pre_spatial; try assumption; try tauto.
      all: try (unfold semaphore_context; tauto).
      all: try (destruct H2; constructor; assumption).
      all: try exact Hlinknonzero.
      all: try (rewrite PreH9; tauto).
      rewrite <- Hnode. exact PreH4.
  - split_pures; dump_pre_spatial; try assumption; try reflexivity.
    unfold semaphore_delete_ic_effect. right. split; [lia|]. right.
    exists original. split.
    + rewrite PreH14. apply in_or_app. right. simpl; auto.
    + split; [rewrite Hquery; exact PreH12|]. split; [exact PreH13|].
      rewrite Hunpublish. reflexivity.
Qed.


Lemma proof_of__SemaphoreDelete_return_wit_1 : _SemaphoreDelete_return_wit_1.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_return_wit_2 : _SemaphoreDelete_return_wit_2.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_return_wit_3_split_goal_1 : _SemaphoreDelete_return_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_return_wit_3 : _SemaphoreDelete_return_wit_3.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_return_wit_4_split_goal_1 : _SemaphoreDelete_return_wit_4_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_return_wit_4 : _SemaphoreDelete_return_wit_4.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_9_pure_split_goal_1 : _SemaphoreDelete_partial_solve_wit_9_pure_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_9_pure : _SemaphoreDelete_partial_solve_wit_9_pure.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_1 : _SemaphoreDelete_which_implies_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_2 : _SemaphoreDelete_which_implies_wit_1_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_3 : _SemaphoreDelete_which_implies_wit_1_split_goal_3.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_spatial : _SemaphoreDelete_which_implies_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1 : _SemaphoreDelete_which_implies_wit_1.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_which_implies_wit_2_split_goal_spatial : _SemaphoreDelete_which_implies_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_2 : _SemaphoreDelete_which_implies_wit_2.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_which_implies_wit_3_split_goal_spatial : _SemaphoreDelete_which_implies_wit_3_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_3 : _SemaphoreDelete_which_implies_wit_3.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_spatial : _SemaphoreDelete_which_implies_wit_4_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_4 : _SemaphoreDelete_which_implies_wit_4.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_which_implies_wit_5_split_goal_spatial : _SemaphoreDelete_which_implies_wit_5_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_5 : _SemaphoreDelete_which_implies_wit_5.
Proof. Admitted.

