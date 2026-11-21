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
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_2 : _SemaphoreCreate_entail_wit_1_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_3 : _SemaphoreCreate_entail_wit_1_split_goal_3.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_4 : _SemaphoreCreate_entail_wit_1_split_goal_4.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_5 : _SemaphoreCreate_entail_wit_1_split_goal_5.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_spatial : _SemaphoreCreate_entail_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1 : _SemaphoreCreate_entail_wit_1.
Proof. Admitted.

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
Proof. Admitted.

Lemma proof_of__SemaphoreCreate_entail_wit_4_split_goal_spatial : _SemaphoreCreate_entail_wit_4_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_4 : _SemaphoreCreate_entail_wit_4.
Proof. Admitted.

Lemma proof_of__SemaphoreCreate_return_wit_1 : _SemaphoreCreate_return_wit_1.
Proof. Admitted.

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
Proof. Abort.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_6_pure : _SemaphoreCreate_partial_solve_wit_6_pure.
Proof. Admitted.

