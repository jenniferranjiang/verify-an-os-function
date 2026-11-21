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
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hfind : forall sm st manager ret id,
    0 < sm.(hoffset) ->
    store_idmanager_found sm (semaphore_manager st) manager ret id |--
    “ exists original, In original st /\ semaphore_id original = id /\
      ret = &(((semaphore_addr original)) # "Semaphore" ->ₛ "id") ”).
  { intros sm st manager ret id Hpos.
    unfold store_idmanager_found. Intros bytes prefix suffix bucket.
    dump_pre_spatial.
    destruct H as [Hrange [Hmap [Hb [Hbucket Hsplit]]]].
    assert (Hbin : In bucket (idbuckets (semaphore_manager st))).
    { rewrite Hbucket. apply Znth_In_Zlength.
      destruct Hb as [_ [Hlen _]]. rewrite Hlen.
      apply Z.mod_pos_bound; assumption. }
    assert (Hnode : In (Build_IdNodeAbs id ret) bucket).
    { rewrite Hsplit. apply in_or_app. right. left. reflexivity. }
    cbn [semaphore_manager idbuckets] in Hbin.
    apply in_map_iff in Hbin. destruct Hbin as [i [Heq Hi]].
    rewrite <- Heq in Hnode. apply in_map_iff in Hnode.
    destruct Hnode as [original [Hnode Hmem]].
    apply filter_In in Hmem. destruct Hmem as [Hmem _].
    exists original. split; [assumption|].
    split.
    - exact (f_equal idnode_id Hnode).
    - symmetry. exact (f_equal idnode_addr Hnode). }
  assert (Hnz : forall wait st x px y py original,
    In original st ->
    dllseg (store_semaphore wait) x px y py (map semaphore_link_node st) |--
    “ semaphore_addr original <> 0 ”).
  { intros wait st. induction st as [|a st IH]; intros x px y py original Hin.
    - contradiction.
    - cbn [map]. unfold dllseg at 1. fold (@dllseg SemaphoreAbs).
      cbn [semaphore_link_node getPtr getData]. Intros z.
      destruct Hin as [Heq|Hin].
      + subst original. unfold store_semaphore. Intros. dump_pre_spatial. tauto.
      + prop_apply_p (IH z x y py original Hin). Intros. dump_pre_spatial. assumption. }
  assert (Hnzdll : forall wait st head original,
    In original st -> store_dll (store_semaphore wait) head (map semaphore_link_node st) |--
    “ semaphore_addr original <> 0 ”).
  { intros wait st head original Hin. unfold store_dll. Intros h pt.
    prop_apply_p (Hnz wait st h head head pt original Hin). Intros. dump_pre_spatial. assumption. }
  assert (Hpos : 0 < hoffset (semaphore_manager_stable (os_semaphore_stable sg_dataqueue_cleanup_ic))).
  { unfold semaphore_context in *. lia. }
  prop_apply_p (Hfind (semaphore_manager_stable (os_semaphore_stable sg_dataqueue_cleanup_ic))
    (os_semaphores before_dataqueue_cleanup_ic) &("k_sem_id_manager") retval id_pre Hpos).
  Intros.
  match goal with Hx : exists _, _ |- _ => destruct Hx as [original [Hin [Hid Haddr]]] end.
  prop_apply_p (Hnzdll (pure_suspend_sched_link (task_desc_map (os_tasks before_dataqueue_cleanup_ic)))
    (os_semaphores before_dataqueue_cleanup_ic) &("k_sem_list") original Hin).
  Intros.
  sep_apply (store_idmanager_found_store_idmanager
    (semaphore_manager_stable (os_semaphore_stable sg_dataqueue_cleanup_ic))
    (semaphore_manager (os_semaphores before_dataqueue_cleanup_ic)) &("k_sem_id_manager") retval id_pre).
  assert (Hpending : semaphore_pending_addrs original = nil).
  { unfold semaphore_delete_quiescent in *.
    match goal with Hq : 0 <= id_pre <= 65535 -> _ |- _ =>
      destruct (Hq ltac:(lia)) as [Hq' _]; apply Hq'; [exact Hin|] end.
    unfold semaphore_query_id. rewrite Z.mod_small by lia. exact Hid. }
  Exists original.
  unfold os_inv, semaphore_inv.
  match goal with Hc : semaphore_context _ |- _ => pose proof Hc as Hctx; destruct Hc as [Hp [_ [_ [_ [_ Hl]]]]] end.
  rewrite Hp, Hl.
  split_pure_spatial; [sepcon_assoc_change; repeat progress cancel|].
  split_pures; dump_pre_spatial; try assumption; try reflexivity; try lia.
Qed.

Lemma proof_of__SemaphoreDelete_entail_wit_2 : _SemaphoreDelete_entail_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hnd : forall sm m p, store_idmanager sm m p |-- “ NoDup m.(idlist) ”).
  { intros sm m p. unfold store_idmanager. Intros.
    dump_pre_spatial. unfold idbuckets_ok, idlist_ok in *. tauto. }
  unfold os_inv, semaphore_inv. Intros.
  prop_apply_p (Hnd (semaphore_manager_stable (os_semaphore_stable sg_dataqueue_cleanup_ic))
    (semaphore_manager (os_semaphores before_dataqueue_cleanup_ic))
    (semaphore_manager_ptr (os_semaphore_stable sg_dataqueue_cleanup_ic))).
  Intros.
  match goal with Hi : In original _ |- _ => destruct (in_split _ _ Hi) as [prefix [suffix Hsplit]] end.
  Exists prefix suffix.
  assert (Hquery : IDNodePure.idmanager_query (semaphore_manager (os_semaphores before_dataqueue_cleanup_ic)) (semaphore_id original) = true).
  { unfold IDNodePure.idmanager_query. apply IDNode.id_in_ids_true_iff.
    cbn [semaphore_manager idlist]. apply in_map. assumption. }
  match goal with Hc : semaphore_context _ |- _ => pose proof Hc as Hctx; destruct Hc as [Hp [_ [_ [_ [_ Hl]]]]] end.
  rewrite Hp, Hl.
  split_pure_spatial.
  - rewrite Hsplit, map_app. cbn [map semaphore_link_node]. sepcon_assoc_change. repeat progress cancel. unfold semaphore_link_node. cancel.
  - split_pures; dump_pre_spatial; try assumption; try reflexivity; try lia.
Qed.

Lemma proof_of__SemaphoreDelete_entail_wit_3_1 : _SemaphoreDelete_entail_wit_3_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst. congruence.
Qed.

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
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  exfalso. apply (addr_of_LE_var_not_zero "k_sem_id_manager"). assumption.
Qed.

Lemma proof_of__SemaphoreDelete_return_wit_2 : _SemaphoreDelete_return_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hmiss : forall s, In s (os_semaphores before_dataqueue_cleanup_ic) ->
      semaphore_id s <> semaphore_query_id id_pre).
  { unfold semaphore_query_id. rewrite Z.mod_small by lia.
    intros s Hin Heq.
    unfold IDNodePure.idmanager_query, semaphore_manager in PreH4.
    cbn in PreH4. apply id_in_ids_false_iff in PreH4.
    apply PreH4. rewrite <- Heq. apply in_map. exact Hin. }
  Exists before_dataqueue_cleanup_ic.
  unfold os_inv, semaphore_inv.
  split_pure_spatial.
  - destruct PreH6 as (Hmanager & Hmax & Hoffset & Hmap & Htable & Hhead).
    rewrite Hmanager, Hhead. repeat progress cancel.
  - split_pures; dump_pre_spatial; auto.
    unfold semaphore_delete_ic_effect. right. split; [lia|].
    left. split; auto.
Qed.

Lemma proof_of__SemaphoreDelete_return_wit_3_split_goal_1 : _SemaphoreDelete_return_wit_3_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold semaphore_delete_ic_effect. left. split; [left; lia | reflexivity].
Qed.

Lemma proof_of__SemaphoreDelete_return_wit_3 : _SemaphoreDelete_return_wit_3.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreDelete_return_wit_3_split_goal_1.
Qed.

Lemma proof_of__SemaphoreDelete_return_wit_4_split_goal_1 : _SemaphoreDelete_return_wit_4_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold semaphore_delete_ic_effect. left. split; [right; lia | reflexivity].
Qed.

Lemma proof_of__SemaphoreDelete_return_wit_4 : _SemaphoreDelete_return_wit_4.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreDelete_return_wit_4_split_goal_1.
Qed.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_9_pure_split_goal_1 : _SemaphoreDelete_partial_solve_wit_9_pure_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial. apply addr_of_LE_var_not_zero.
Qed.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_9_pure : _SemaphoreDelete_partial_solve_wit_9_pure.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreDelete_partial_solve_wit_9_pure_split_goal_1.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_1 : _SemaphoreDelete_which_implies_wit_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv, semaphore_inv, store_idmanager.
  Intros.
  dump_pre_spatial.
  unfold idbuckets_ok, idlist_ok in *.
  cbn [semaphore_manager idlist] in *. tauto.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_2 : _SemaphoreDelete_which_implies_wit_1_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv, semaphore_inv. Intros.
  dump_pre_spatial. assumption.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_3 : _SemaphoreDelete_which_implies_wit_1_split_goal_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv. Intros.
  dump_pre_spatial. assumption.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_spatial : _SemaphoreDelete_which_implies_wit_1_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv, semaphore_inv. Intros.
  match goal with Hc : semaphore_context _ |- _ => pose proof Hc as Hctx; destruct Hc as [Hp [_ [_ [_ [_ Hl]]]]] end.
  rewrite Hp, Hl. cancel.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1 : _SemaphoreDelete_which_implies_wit_1.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_spatial.
  - Goal_apply proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_1.
  - Goal_apply proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_2.
  - Goal_apply proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_3.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_2_split_goal_spatial : _SemaphoreDelete_which_implies_wit_2_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst sem.
  assert (HB : forall (A:Type) (sa: addr -> A -> Assertion) (l:list (DL_Node A))
    (n:DL_Node A) x px y py,
    In n l -> dllseg sa x px y py l |--
    sa n.(ptr) n.(data) ** (sa n.(ptr) n.(data) -* dllseg sa x px y py l)).
  { intros A sa l n x px y py Hin.
    apply in_split in Hin. destruct Hin as [l1 [l2 Heq]]. subst l.
    remember (sa n.(ptr) n.(data) -* dllseg sa x px y py (l1 ++ n::l2)) as W eqn:HW.
    sep_apply_l_atomic (dllseg_split sa x px y py l1 (n::l2)).
    Intros q pq. cbn [dllseg]. Intros z. subst q.
    cancel (sa n.(ptr) n.(data)).
    subst W. apply_sepcon_adjoint.
    sep_apply_r_atomic (dllseg_concat sa x px n.(ptr) pq y py l1 (n::l2)).
    cbn [dllseg]. Exists z.
    split_pure_spatial; [sepcon_assoc_change; cancel | dump_pre_spatial; reflexivity].
  }
  match goal with |- _ |-- ?P ** ?R => remember R as W eqn:HW end.
  unfold os_inv at 1. unfold semaphore_inv at 1. Intros.
  unfold store_dll at 1. Intros h pt.
  sep_apply_l_atomic (HB SemaphoreAbs
    (store_semaphore (pure_suspend_sched_link (task_desc_map (os_tasks before_dataqueue_cleanup_ic))))
    (map semaphore_link_node (os_semaphores before_dataqueue_cleanup_ic))
    (semaphore_link_node original) h
    (semaphore_list_head (os_semaphore_stable sg_dataqueue_cleanup_ic))
    (semaphore_list_head (os_semaphore_stable sg_dataqueue_cleanup_ic)) pt
    (in_map semaphore_link_node _ _ PreH1)).
  cbn [semaphore_link_node getPtr getData].
  unfold store_semaphore at 1. Intros.
  rewrite PreH3. cbn [map].
  match goal with |- ?L |-- _ => match L with context[?P -* ?Q] => remember (P -* Q) as Wseg eqn:HWseg end end.
  csimpl. sepcon_assoc_change.
  match goal with |- _ |-- ?P ** _ => sepcon_lift P end.
  match goal with |- _ ** (_ ** (?L ** _)) |-- ?R ** _ =>
    assert (L = R) as Hsame by reflexivity; try rewrite <- Hsame
  end.
  match goal with |- _ |-- ?P ** _ => cancel P end.
  subst W. apply_sepcon_adjoint.
  subst Wseg.
  unfold os_inv, semaphore_inv. unfold store_dll at 2. Exists h pt.
  split_pure_spatial.
  - sepcon_assoc_change. cancel.
    match goal with |- ?L |-- ?Q => match L with context[?P -* Q] =>
      sep_apply_r_atomic (derivable1_wand_elim1 P Q);
      cancel (P -* Q)
    end end.
    unfold store_semaphore. rewrite PreH3. cbn [map].
    split_pure_spatial; [csimpl; sepcon_assoc_change; repeat progress cancel; reflexivity | dump_pre_spatial; exact H2].
  - split_pures; dump_pre_spatial; tauto.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_2 : _SemaphoreDelete_which_implies_wit_2.
Proof. aggressive_pre_process. Goal_apply proof_of__SemaphoreDelete_which_implies_wit_2_split_goal_spatial. Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_3_split_goal_spatial : _SemaphoreDelete_which_implies_wit_3_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  apply derivable1_wand_elim2.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_3 : _SemaphoreDelete_which_implies_wit_3.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreDelete_which_implies_wit_3_split_goal_spatial.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_spatial : _SemaphoreDelete_which_implies_wit_4_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst sem.
  assert (HB : forall (A:Type) (sa: addr -> A -> Assertion) (l:list (DL_Node A))
    (n:DL_Node A) x px y py,
    In n l -> dllseg sa x px y py l |--
    sa n.(ptr) n.(data) ** (sa n.(ptr) n.(data) -* dllseg sa x px y py l)).
  { intros A sa l n x px y py Hin.
    apply in_split in Hin. destruct Hin as [l1 [l2 Heq]]. subst l.
    remember (sa n.(ptr) n.(data) -* dllseg sa x px y py (l1 ++ n::l2)) as W eqn:HW.
    sep_apply_l_atomic (dllseg_split sa x px y py l1 (n::l2)).
    Intros q pq. cbn [dllseg]. Intros z. subst q.
    cancel (sa n.(ptr) n.(data)).
    subst W. apply_sepcon_adjoint.
    sep_apply_r_atomic (dllseg_concat sa x px n.(ptr) pq y py l1 (n::l2)).
    cbn [dllseg]. Exists z.
    split_pure_spatial; [sepcon_assoc_change; cancel | dump_pre_spatial; reflexivity].
  }

  assert (HN : forall head nodes node, let p := idnode_addr node in
    In node nodes -> store_idnodes head nodes |--
    store_ushort (&(p # "IdNode" ->ₛ "id")) node.(idnode_id) **
    (store_ushort (&(p # "IdNode" ->ₛ "id")) node.(idnode_id) -* store_idnodes head nodes)).
  { intros head nodes node. cbv zeta. intro Hin.
    match goal with |- _ |-- _ ** ?R => remember R as W eqn:HW end.
    unfold store_idnodes at 1. unfold store_dll at 1. Intros h pt.
    sep_apply_l_atomic (HB IdNodeAbs store_idnode (idnodes_to_dll nodes)
      (idnode_to_dll node) h head head pt (in_map idnode_to_dll _ _ Hin)).
    cbn [idnode_to_dll getPtr getData].
    unfold store_idnode at 1. Intros.
    match goal with |- _ |-- ?P ** _ => cancel P end.
    subst W. apply_sepcon_adjoint.
    unfold store_idnodes, store_dll. Exists h pt.
    split_pure_spatial.
    - sepcon_assoc_change. cancel.
      match goal with |- ?L |-- ?Q => match L with context[?P -* Q] =>
        sep_apply_r_atomic (derivable1_wand_elim1 P Q); cancel (P -* Q)
      end end.
      unfold store_idnode. split_pure_spatial; [reflexivity | dump_pre_spatial; assumption].
    - dump_pre_spatial. assumption.
  }
  assert (HK : forall buckets node h start, let p := idnode_addr node in
    (exists bucket, In bucket buckets /\ In node bucket) ->
    store_idbucket_list h start buckets |--
    store_ushort (&(p # "IdNode" ->ₛ "id")) node.(idnode_id) **
    (store_ushort (&(p # "IdNode" ->ₛ "id")) node.(idnode_id) -* store_idbucket_list h start buckets)).
  { intro buckets. induction buckets as [|b bs IH]; intros node h start; cbv zeta; intros [bucket [Hin Hnode]].
    - contradiction.
    - destruct Hin as [Heq | Hin].
      + subst bucket. destruct b as [|n ns]; [contradiction|].
        match goal with |- _ |-- _ ** ?R => remember R as W eqn:HW end.
        cbn [store_idbucket_list store_idbucket].
        sep_apply_l_atomic (HN (h + start * sizeof("SysDoubleLinklistNode")) (n::ns) node Hnode).
        match goal with |- _ |-- ?P ** _ => sepcon_lift P; cancel P end.
        subst W. apply_sepcon_adjoint.
        cbn [store_idbucket_list store_idbucket].
        cancel (store_idbucket_list h (start+1) bs).
        apply derivable1_wand_elim1.
      + match goal with |- _ |-- _ ** ?R => remember R as W eqn:HW end.
        cbn [store_idbucket_list].
        sep_apply_l_atomic (IH node h (start+1) (ex_intro _ bucket (conj Hin Hnode))).
        match goal with |- _ |-- ?P ** _ => sepcon_lift P; cancel P end.
        subst W. apply_sepcon_adjoint.
        cbn [store_idbucket_list].
        cancel (store_idbucket (h + start * sizeof("SysDoubleLinklistNode")) b).
        apply derivable1_wand_elim1.
  }
  assert (Hex : exists bucket,
      In bucket (idbuckets (semaphore_manager (os_semaphores before_dataqueue_cleanup_ic))) /\
      In (semaphore_idnode original) bucket).
  { set (i := semaphore_id original mod 16).
    assert (Hi : 0 <= i < 16) by (unfold i; apply Z.mod_pos_bound; lia).
    exists (map semaphore_idnode
      (filter (fun s => Z.eqb (semaphore_id s mod 16) (Z.of_nat (Z.to_nat i)))
      (os_semaphores before_dataqueue_cleanup_ic))).
    split.
    - unfold semaphore_manager. cbn [idbuckets].
      apply in_map_iff. exists (Z.to_nat i). split; [reflexivity|].
      apply in_seq. split; [lia|].
      apply (proj1 (Z2Nat.inj_lt i 16 ltac:(lia) ltac:(lia))). lia.
    - apply in_map. apply filter_In. split; [exact PreH1|].
      apply Z.eqb_eq. rewrite Z2Nat.id by lia. reflexivity.
  }
  match goal with |- _ |-- _ ** ?R => remember R as W eqn:HW end.
  unfold os_inv at 1. unfold semaphore_inv at 1.
  unfold store_idmanager, store_idbuckets. Intros.
  sep_apply_l_atomic (HK
    (idbuckets (semaphore_manager (os_semaphores before_dataqueue_cleanup_ic)))
    (semaphore_idnode original)
    (htable (semaphore_manager_stable (os_semaphore_stable sg_dataqueue_cleanup_ic))) 0 Hex).
  cbn [semaphore_idnode idnode_addr idnode_id]. csimpl.
  match goal with |- ?L ** _ |-- ?R ** _ =>
    assert (L = R) as Hsame by reflexivity; try rewrite <- Hsame
  end.
  match goal with |- _ |-- ?P ** _ => cancel P end.
  subst W. apply_sepcon_adjoint.
  unfold os_inv, semaphore_inv, store_idmanager, store_idbuckets.
  split_pure_spatial.
  - sepcon_assoc_change. repeat progress cancel.
    csimpl. apply derivable1_wand_elim1.
  - split_pures; dump_pre_spatial; assumption.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_4 : _SemaphoreDelete_which_implies_wit_4.
Proof. aggressive_pre_process. Goal_apply proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_spatial. Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_5_split_goal_spatial : _SemaphoreDelete_which_implies_wit_5_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  apply derivable1_wand_elim2.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_5 : _SemaphoreDelete_which_implies_wit_5.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreDelete_which_implies_wit_5_split_goal_spatial.
Qed.

