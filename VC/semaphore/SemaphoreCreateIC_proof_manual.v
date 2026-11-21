From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.semaphore Require Import SemaphoreCreateIC_goal.
From CRTOS_Verify.VC.semaphore Require Import SemaphoreCreateIC_proof_auto.
Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreDelete.
Require Import CRTOS_Verify.lib.id.idnode CRTOS_Verify.lib.id.IdModuleSpec CRTOS_Verify.lib.common.dll CRTOS_Verify.lib.list.NodeSelfLinked.
Import IDNode DLL.
Local Open Scope sac.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_1 : _SemaphoreCreate_entail_wit_1_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
assert (Hfresh : forall wait l x px y py p,
  dllseg (store_semaphore wait) x px y py (map semaphore_link_node l) **
  &(p # "Semaphore" ->ₛ "value") # UShort |-> 0 |--
  “ ~ In p (map semaphore_addr l) ”).
{ clear.
  intros wait l. induction l as [|a l IH]; intros x px y py p.
  - cbn [map]. dump_pre_spatial. simpl. tauto.
  - cbn [map dllseg]. Intros z.
    destruct (Z.eq_dec p (semaphore_addr a)) as [Heq|Hneq].
    + unfold store_semaphore. Intros. rewrite Heq.
      let q := constr:(semaphore_addr a) in
      sep_apply_l_atomic (store_ushort_undef_store_ushort (&(q # "Semaphore" ->ₛ "value")) (semaphore_value a)).
      let q := constr:(semaphore_addr a) in
      sep_apply_l_atomic (store_ushort_undef_store_ushort (&(q # "Semaphore" ->ₛ "value")) 0).
      let q := constr:(semaphore_addr a) in
      sep_apply_l_atomic (undef_store_int_exclusive 2 2 (&(q # "Semaphore" ->ₛ "value")) ltac:(lia)).
      Intros_p Hbad. contradiction.
    + change (store_semaphore wait x a **
        (&(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
        (&(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
        (dllseg (store_semaphore wait) z x y py (map semaphore_link_node l) **
        &(p # "Semaphore" ->ₛ "value") # UShort |-> 0))) |--
        “ ~ In p (semaphore_addr a :: map semaphore_addr l) ”).
      sep_apply (IH z x y py p).
      Intros_p Htail. dump_pre_spatial. simpl. intuition congruence.
}
sep_apply_l_atomic (semaphore_zero_bytes_object retval (semaphore_field_offsets_trusted retval PreH6) ltac:(lia) PreH5 PreH6).
unfold os_inv, semaphore_inv, SemaphoreZero.
Intros.
unfold store_dll at 1. Intros h pt. Intros.
sep_apply (Hfresh (pure_suspend_sched_link (task_desc_map (os_tasks before_dataqueue_ic))) (os_semaphores before_dataqueue_ic) h (semaphore_list_head (os_semaphore_stable sg_dataqueue_ic)) (semaphore_list_head (os_semaphore_stable sg_dataqueue_ic)) pt retval).
Intros_p Habsent. dump_pre_spatial. exact Habsent.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_2 : _SemaphoreCreate_entail_wit_1_split_goal_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
unfold os_inv, semaphore_inv. Intros.
dump_pre_spatial. assumption.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_3 : _SemaphoreCreate_entail_wit_1_split_goal_3.
Proof.
LLM_pre_process ltac:(lia || int_auto).
unfold os_inv. Intros.
dump_pre_spatial. assumption.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_4 : _SemaphoreCreate_entail_wit_1_split_goal_4.
Proof.
LLM_pre_process ltac:(lia || int_auto).
dump_pre_spatial.
pose proof (semaphore_field_offsets_trusted retval PreH6) as Hlayout.
unfold semaphore_byte_layout in Hlayout.
destruct Hlayout as [_ [_ [_ [_ [_ [Hlink _]]]]]].
rewrite Hlink. lia.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_5 : _SemaphoreCreate_entail_wit_1_split_goal_5.
Proof.
LLM_pre_process ltac:(lia || int_auto).
dump_pre_spatial.
pose proof (semaphore_field_offsets_trusted retval PreH6) as Hlayout.
unfold semaphore_byte_layout in Hlayout.
destruct Hlayout as [_ [_ [_ [_ [Hpend _]]]]].
rewrite Hpend. lia.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_spatial : _SemaphoreCreate_entail_wit_1_split_goal_spatial.
Proof.
LLM_pre_process ltac:(lia || int_auto).
sep_apply_l_atomic (semaphore_zero_bytes_object retval (semaphore_field_offsets_trusted retval PreH6) ltac:(lia) PreH5 PreH6).
Intros.
sep_apply_l_atomic (semaphore_zero_insert_ready retval).
unfold os_inv, semaphore_inv. Intros.
match goal with H : semaphore_context _ |- _ =>
  destruct H as [Hmanager [_ [_ [_ [_ Hlist]]]]]
end.
rewrite Hmanager, Hlist.
repeat progress cancel.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_1 : _SemaphoreCreate_entail_wit_1.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_1_split_goal_spatial.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_1_split_goal_1.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_1_split_goal_2.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_1_split_goal_3.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_1_split_goal_4.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_1_split_goal_5.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_spatial : _SemaphoreCreate_entail_wit_2_1_split_goal_spatial.
Proof.
LLM_pre_process ltac:(lia || int_auto).
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
{ intros p. rewrite undef_store_uint_undef_store_char. Intros_p H.
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
assert (Hraw : SemaphoreRaw sem |-- CharArray.undef_full sem 32).
{
unfold SemaphoreRaw, NodeStorage.
Intros.
pose proof (semaphore_field_offsets_trusted sem PreH8) as Hl.
unfold semaphore_byte_layout in Hl.
destruct Hl as [Hid [Hiid [Hil [Hv [Hp [Hlink Hnodes]]]]]].
assert (Hidid : &(sem # "Semaphore" ->ₛ "id" .ₛ "id") =
  (let q : addr := &(sem # "Semaphore" ->ₛ "id") in &(q # "IdNode" ->ₛ "id"))).
{ simpl. rewrite addr_of_arrow_field. rewrite eval_addr. reflexivity. }
assert (Hidlink : &(sem # "Semaphore" ->ₛ "id" .ₛ "link") =
  (let q : addr := &(sem # "Semaphore" ->ₛ "id") in &(q # "IdNode" ->ₛ "link"))).
{ simpl. rewrite addr_of_arrow_field. rewrite eval_addr. reflexivity. }
rewrite Hidid,Hidlink.
rewrite ?Hid. cbn zeta.
rewrite ?Hiid, ?Hil, ?Hv, ?Hp, ?Hlink.
destruct (Hnodes 4 ltac:(simpl; auto)) as [H4n H4p].
destruct (Hnodes 16 ltac:(simpl; auto)) as [H16n H16p].
destruct (Hnodes 24 ltac:(simpl; auto)) as [H24n H24p].
rewrite ?H4n,?H4p,?H16n,?H16p,?H24n,?H24p.
replace (sem+4+4) with (sem+8) by lia.
replace (sem+16+4) with (sem+20) by lia.
replace (sem+24+4) with (sem+28) by lia.
sep_apply_l_atomic (Hshort sem).
sep_apply_l_atomic (Hshort (sem+12)).
sep_apply_l_atomic (Hptr (sem+4)). sep_apply_l_atomic (Huint (sem+4)).
sep_apply_l_atomic (Hptr (sem+8)). sep_apply_l_atomic (Huint (sem+8)).
sep_apply_l_atomic (Hptr (sem+16)). sep_apply_l_atomic (Huint (sem+16)).
sep_apply_l_atomic (Hptr (sem+20)). sep_apply_l_atomic (Huint (sem+20)).
sep_apply_l_atomic (Hptr (sem+24)). sep_apply_l_atomic (Huint (sem+24)).
sep_apply_l_atomic (Hptr (sem+28)). sep_apply_l_atomic (Huint (sem+28)).
sep_apply_r_atomic (CharArray.undef_full_merge_to_undef_full sem 28 32 ltac:(lia)).
sepcon_right_assoc.
sep_apply_r_atomic (CharArray.undef_full_merge_to_undef_full sem 24 28 ltac:(lia)).
sepcon_right_assoc.
sep_apply_r_atomic (CharArray.undef_full_merge_to_undef_full sem 20 24 ltac:(lia)).
sepcon_right_assoc.
sep_apply_r_atomic (CharArray.undef_full_merge_to_undef_full sem 16 20 ltac:(lia)).
sepcon_right_assoc.
sep_apply_r_atomic (CharArray.undef_full_merge_to_undef_full sem 14 16 ltac:(lia)).
sepcon_right_assoc.
sep_apply_r_atomic (CharArray.undef_full_merge_to_undef_full sem 12 14 ltac:(lia)).
sepcon_right_assoc.
sep_apply_r_atomic (CharArray.undef_full_merge_to_undef_full sem 8 12 ltac:(lia)).
sepcon_right_assoc.
sep_apply_r_atomic (CharArray.undef_full_merge_to_undef_full sem 4 8 ltac:(lia)).
sepcon_right_assoc.
sep_apply_r_atomic (CharArray.undef_full_merge_to_undef_full sem 2 4 ltac:(lia)).
sepcon_right_assoc.
simpl_nonptr_sizeof. cbn. repeat rewrite Z.mul_1_r.
repeat progress cancel.
}
sep_apply_l_atomic (semaphore_insert_failure_raw sem PreH7 PreH8 PreH9 PreH10).
sep_apply_l_atomic Hraw.
unfold os_inv, semaphore_inv.
pose proof PreH12 as Hcontext.
unfold semaphore_context in Hcontext.
destruct Hcontext as [Hmanager [_ [_ [_ [_ Hhead]]]]].
rewrite Hmanager,Hhead.
split_pure_spatial.
- repeat progress cancel.
- split_pures; dump_pre_spatial; assumption.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_2_1 : _SemaphoreCreate_entail_wit_2_1.
Proof.
aggressive_pre_process.
Goal_apply proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_spatial.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_1 : _SemaphoreCreate_entail_wit_2_2_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
unfold IDNode.idmanager_min_free_id in PreH4.
destruct PreH4 as [[Hnonneg _] _]. exfalso; lia.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_spatial : _SemaphoreCreate_entail_wit_2_2_split_goal_spatial.
Proof.
LLM_pre_process ltac:(lia || int_auto).
unfold IDNode.idmanager_min_free_id in PreH4.
destruct PreH4 as [[Hnonneg _] _]. exfalso; lia.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_2_2 : _SemaphoreCreate_entail_wit_2_2.
Proof.
aggressive_pre_process.
- Goal_apply proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_spatial.
- Goal_apply proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_1.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_3 : _SemaphoreCreate_entail_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  pose proof PreH2 as Hr.
  unfold idmanager_min_free_id in Hr.
  pose proof PreH10 as Hctx.
  unfold semaphore_context in Hctx.
  unfold NodeZero.
  destruct Hr as [[Hlo Hhi] _].
  destruct Hctx as [_ [Hmax _]].
  rewrite Hmax in Hhi.
  split_pure_spatial.
  - repeat progress cancel.
    assert (Hp : &(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev") =
       (let pend := &(sem # "Semaphore" ->ₛ "pend_list") in &(pend # "SysDoubleLinklistNode" ->ₛ "node_prev")))
      by (simpl; rewrite addr_of_arrow_field, eval_addr; reflexivity).
    assert (Hn : &(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_next") =
       (let pend := &(sem # "Semaphore" ->ₛ "pend_list") in &(pend # "SysDoubleLinklistNode" ->ₛ "node_next")))
      by (simpl; rewrite addr_of_arrow_field, eval_addr; reflexivity).
    rewrite Hp, Hn.
    set (pend := (&(sem # "Semaphore" ->ₛ "pend_list")) : addr).
    sep_apply (store_ptr_undef_store_ptr (&(pend # "SysDoubleLinklistNode" ->ₛ "node_prev")) 0).
    sep_apply (store_ptr_undef_store_ptr (&(pend # "SysDoubleLinklistNode" ->ₛ "node_next")) 0).
    cbn zeta. cancel.
  - split_pures; dump_pre_spatial; auto.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_4_split_goal_spatial : _SemaphoreCreate_entail_wit_4_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold store_semaphore, semaphore_created; cbn [semaphore_addr semaphore_value semaphore_pending_addrs map].
  repeat progress cancel.
  unfold store_node_self_linked, NodeZero, occupy_dll_node.
  unfold store_dll.
  Exists (&(sem # "Semaphore" ->ₛ "pend_list")) (&(sem # "Semaphore" ->ₛ "pend_list")) 0 0.
  cbn [dllseg].
  cbn zeta beta.
  split_pure_spatial.
  - set (pend := (&(sem # "Semaphore" ->ₛ "pend_list")) : addr).
    set (link := (&(sem # "Semaphore" ->ₛ "link")) : addr).
    sepcon_assoc_change. cancel.
  - split_pures; dump_pre_spatial; unfold dll_nodes_nonzero; repeat split; auto; constructor.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_4 : _SemaphoreCreate_entail_wit_4.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreCreate_entail_wit_4_split_goal_spatial.
Qed.

Lemma proof_of__SemaphoreCreate_return_wit_1 : _SemaphoreCreate_return_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  rename before_dataqueue_ic into before, sg_dataqueue_ic into sg.
  assert (Hworld : os_world_wf sg
    (replace_semaphores (semaphore_publish sem id val_pre (os_semaphores before)) before)).
  { destruct PreH9 as [Hctx Hrec Hidle Hnd Hdom].
    constructor; cbn [replace_semaphores]; try assumption.
    - unfold service_slot_wf in *; simpl.
      destruct (service_phase (os_recycle before)); try assumption.
      destruct Hrec as [d Hd]. exists d. destruct Hd; constructor; assumption.
    - simpl. eapply List.Forall_impl; [|exact Hidle].
      intros x Hx. unfold service_slot_wf in *.
      destruct (service_phase x); try assumption.
      destruct Hx as [d Hd]. exists d. destruct Hd; constructor; assumption.
  }
  assert (Hmanager : semaphore_manager (semaphore_publish sem id val_pre (os_semaphores before)) =
    idmanager_link (semaphore_manager_stable (os_semaphore_stable sg))
      (idmanager_add (semaphore_manager (os_semaphores before)) id) id
      (&(sem # "Semaphore" ->ₛ "id"))).
  { destruct PreH10 as [_ [_ [Hoff _]]].
    unfold semaphore_manager, semaphore_publish, idmanager_link, idmanager_add,
      idmanager_insert_bucket, idlist_add.
    cbn [idlist idbuckets]. rewrite Hoff.
    assert (Hmod : 0 <= id mod 16 < 16) by (apply Z.mod_pos_bound; lia).
    cbn [map filter semaphore_created semaphore_id].
    remember (id mod 16) as k eqn:Hk.
    assert (Hcases : k = 0 \/ k = 1 \/ k = 2 \/ k = 3 \/ k = 4 \/
      k = 5 \/ k = 6 \/ k = 7 \/ k = 8 \/ k = 9 \/ k = 10 \/
      k = 11 \/ k = 12 \/ k = 13 \/ k = 14 \/ k = 15) by lia.
    repeat destruct Hcases as [Hcases | Hcases]; rewrite Hcases; reflexivity.
  }
  Exists (replace_semaphores (semaphore_publish sem id val_pre (os_semaphores before)) before).
  split_pure_spatial.
  - unfold os_inv. Intros.
    rewrite dll_insert_after_dispatch_at_head.
    unfold semaphore_inv.
    cbn [replace_semaphores os_tasks os_semaphores os_dataqueues os_tick os_delays
      os_assign zombie_queue os_recycle os_idle os_isr os_exstatus os_mutexes os_events].
    rewrite Hmanager.
    destruct PreH10 as [Hptr [Hmax [Hoff [Hmap [Htable Hhead]]]]].
    rewrite Hptr, Hhead.
    change (map semaphore_link_node (semaphore_publish sem id val_pre (os_semaphores before)))
      with (Build_DL_Node (semaphore_created sem id val_pre) (&(sem # "Semaphore" ->ₛ "link")) ::
        map semaphore_link_node (os_semaphores before)).
    unfold dataqueue_inv. Intros_p Hqueues.
    unfold task_inv, tick_inv, delay_inv, assign_inv, exstatus_inv.
    cbn [replace_semaphores os_tasks os_tick os_delays os_assign os_exstatus].
    Intros.
    split_pure_spatial.
    + repeat progress cancel.
    + split_pures; dump_pre_spatial.
      all: try assumption.
      all: try (unfold semaphore_context; repeat split; assumption).
      all: try (destruct H; constructor; assumption).
      intros p q Hlookup.
      destruct (Hqueues p q Hlookup) as [Hr [[sb [Hb Hbid]] [sd [Hd Hdid]]]].
      split; [exact Hr|].
      unfold dataqueue_semaphores, semaphore_publish.
      split; [exists sb | exists sd]; simpl; auto.
  - split_pures; dump_pre_spatial; try lia.
    unfold semaphore_create_ic_effect. right. exists sem.
    split; [exact PreH4|]. split; [exact PreH5|].
    split; [exact PreH11|]. split; [exact PreH8|reflexivity].
Qed.

Lemma proof_of__SemaphoreCreate_return_wit_2_split_goal_1 : _SemaphoreCreate_return_wit_2_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
unfold semaphore_create_ic_effect. left; auto.
Qed.

Lemma proof_of__SemaphoreCreate_return_wit_2 : _SemaphoreCreate_return_wit_2.
Proof.
aggressive_pre_process.
Goal_apply proof_of__SemaphoreCreate_return_wit_2_split_goal_1.
Qed.

Lemma proof_of__SemaphoreCreate_return_wit_3_split_goal_1 : _SemaphoreCreate_return_wit_3_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
unfold semaphore_create_ic_effect. left; auto.
Qed.

Lemma proof_of__SemaphoreCreate_return_wit_3 : _SemaphoreCreate_return_wit_3.
Proof.
aggressive_pre_process.
Goal_apply proof_of__SemaphoreCreate_return_wit_3_split_goal_1.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1 : _SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  unfold DoubleLinkListSpec.dll_insert_anchor. right; reflexivity.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_6_pure : _SemaphoreCreate_partial_solve_wit_6_pure.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1.
Qed.

