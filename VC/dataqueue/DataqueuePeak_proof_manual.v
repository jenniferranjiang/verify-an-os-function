From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.dataqueue Require Import DataqueuePeak_goal.
From CRTOS_Verify.VC.dataqueue Require Import DataqueuePeak_proof_auto.
Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Local Open Scope sac.

Lemma proof_of_DataqueuePeak_entail_wit_1 : DataqueuePeak_entail_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hentry : dataqueue_peak_entry sg p_queue_pre (Crtos_RTrans before)).
  { destruct PreH2 as [states [Hstates Hsafe]].
    unfold LastSeen in Hstates.
    unfold safe, abs_dataqueue_peak in Hsafe.
    rewrite wp_bind, wp_assertS in Hsafe.
    destruct Hsafe as [Hentry _].
    unfold dataqueue_peak_entry in Hentry |- *.
    intros obs Hobs. apply Hentry.
    apply (proj2 (Hstates obs)). exact Hobs. }
  pose proof (Hentry observed PreH1) as Hguard.
  prop_apply_p Hguard. Intros_p Hg. destruct Hg as [q Hq].
  assert (Hfocus : os_inv sg observed |--
      “ dataqueue_ready q ” &&
      store_dataqueue p_queue_pre q **
      (store_dataqueue p_queue_pre q -* os_inv sg observed)).
  { remember (store_dataqueue p_queue_pre q -* os_inv sg observed) as W eqn:HW.
    unfold os_inv at 1. unfold dataqueue_inv at 1. Intros.
    sep_apply_l_atomic (store_map_split store_dataqueue p_queue_pre q
      (dataqueue_map (os_dataqueues observed)) Hq).
    split_pure_spatial.
    - cancel (store_dataqueue p_queue_pre q).
      subst W. apply_sepcon_adjoint.
      sep_apply_l_atomic (store_map_merge store_dataqueue p_queue_pre q
        (dataqueue_map (os_dataqueues observed)) Hq).
      unfold os_inv, dataqueue_inv.
      split_pure_spatial; [sepcon_assoc_change; cancel | split_pures; dump_pre_spatial; assumption].
    - dump_pre_spatial.
      match goal with H : forall p q, _ p = Some q -> _ |- _ => exact (proj1 (H _ _ Hq)) end. }
  sep_apply_l_atomic Hfocus. Intros.
  Exists q. split_pure_spatial.
  - sepcon_assoc_change; cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed.

Lemma proof_of_DataqueuePeak_entail_wit_2_split_goal_1 : DataqueuePeak_entail_wit_2_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DataqueuePeak_entail_wit_2_split_goal_2 : DataqueuePeak_entail_wit_2_split_goal_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
dump_pre_spatial.
assert (Hstep : hs_eval (os_atomic_cmd (abs_dataqueue_peak_locked p_queue_pre)) (LastSeen before) (LastSeen observed) (Some e)).
{ intros states Hseen.
  exists (Crtos_RTrans observed). split.
  - cbn [os_atomic_cmd abs_dataqueue_peak_locked MonadErr.nrm].
    exists observed, observed. split.
    + apply Hseen. exact PreH17.
    + split.
      * split; [reflexivity|]. exists q. split; [exact PreH19|]. right. split; [congruence|]. exists e; auto.
      * reflexivity.
  - unfold LastSeen. reflexivity.
}
eapply (highstependret_derive _ _ (Some e) (fun _ => LastSeen observed) Hstep).
unfold abs_dataqueue_peak in PreH18 at 1.
prog_nf in PreH18.
destruct PreH18 as [states [Hseen Hwp]].
exists states. split; [exact Hseen|].
unfold safe in Hwp |- *.
rewrite wp_bind in Hwp. rewrite wp_assertS in Hwp.
exact (proj2 Hwp).
Qed.

Lemma proof_of_DataqueuePeak_entail_wit_2_split_goal_spatial : DataqueuePeak_entail_wit_2_split_goal_spatial.
Proof.
LLM_pre_process ltac:(lia || int_auto).
subst p_queue_front p_queue_rear p_queue_max_len p_queue_base p_queue_sem_blank p_queue_sem_data.
rewrite sizeof_char. replace (6 * 1) with 6 by lia.
sep_apply_r_atomic (derivable1_wand_elim1 (store_dataqueue p_queue_pre q) (os_inv sg observed)).
cancel (store_dataqueue p_queue_pre q -* os_inv sg observed).
unfold store_dataqueue, dataqueue_fields.
unfold peak_data_slot, peak_length_slot.
split_pure_spatial.
- sepcon_assoc_change. cancel.
  sep_apply_r_atomic (derivable1_wand_elim1 (dataqueue_slot (dq_base q) (dq_front q) (Some e)) (dataqueue_buffer q)).
  cancel (dataqueue_slot (dq_base q) (dq_front q) (Some e) -* dataqueue_buffer q).
  unfold dataqueue_slot.
  pose proof dataqueue_layout_abi as Hlayout.
  destruct Hlayout as [_ [Helem _]].
  unfold KTaskCNotation.sizeof_front_end_type in Helem.
  unfold sizeof_front_end_type.
  rewrite Helem.
  sepcon_assoc_change. cancel.
- split_pures; dump_pre_spatial; auto.
Qed.

Lemma proof_of_DataqueuePeak_entail_wit_2 : DataqueuePeak_entail_wit_2.
Proof.
  aggressive_pre_process.
  Goal_apply (proof_of_DataqueuePeak_entail_wit_2_split_goal_spatial X before sg p_queue_pre StartAddr_pre size_pre observed q p_queue_sem_data p_queue_sem_blank p_queue_base p_queue_max_len p_queue_rear p_queue_front e PreH1 PreH2 PreH3 PreH4 PreH5 PreH6 PreH7 PreH8 PreH9 PreH10 PreH11 PreH12 PreH13 PreH14 PreH15 PreH16 PreH17 PreH18 PreH19 PreH20).
  Goal_apply (proof_of_DataqueuePeak_entail_wit_2_split_goal_2 X before sg p_queue_pre StartAddr_pre size_pre observed q p_queue_sem_data p_queue_sem_blank p_queue_base p_queue_max_len p_queue_rear p_queue_front e PreH1 PreH2 PreH3 PreH4 PreH5 PreH6 PreH7 PreH8 PreH9 PreH10 PreH11 PreH12 PreH13 PreH14 PreH15 PreH16 PreH17 PreH18 PreH19 PreH20).
Qed.

Lemma proof_of_DataqueuePeak_entail_wit_3_split_goal_1 : DataqueuePeak_entail_wit_3_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DataqueuePeak_entail_wit_3_split_goal_2 : DataqueuePeak_entail_wit_3_split_goal_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
dump_pre_spatial.
assert (Hstep : hs_eval (os_atomic_cmd (abs_dataqueue_peak_locked p_queue_pre)) (LastSeen before) (LastSeen observed) (None)).
{ intros states Hseen.
  exists (Crtos_RTrans observed). split.
  - cbn [os_atomic_cmd abs_dataqueue_peak_locked MonadErr.nrm].
    exists observed, observed. split.
    + apply Hseen. exact PreH14.
    + split.
      * split; [reflexivity|]. exists q. split; [exact PreH16|]. left. split; [congruence|reflexivity].
      * reflexivity.
  - unfold LastSeen. reflexivity.
}
eapply (highstependret_derive _ _ (None) (fun _ => LastSeen observed) Hstep).
unfold abs_dataqueue_peak in PreH15 at 1.
prog_nf in PreH15.
destruct PreH15 as [states [Hseen Hwp]].
exists states. split; [exact Hseen|].
unfold safe in Hwp |- *.
rewrite wp_bind in Hwp. rewrite wp_assertS in Hwp.
exact (proj2 Hwp).
Qed.

Lemma proof_of_DataqueuePeak_entail_wit_3_split_goal_spatial : DataqueuePeak_entail_wit_3_split_goal_spatial.
Proof.
LLM_pre_process ltac:(lia || int_auto).
subst p_queue_front p_queue_rear p_queue_max_len p_queue_base p_queue_sem_blank p_queue_sem_data.
rewrite sizeof_char. replace (6 * 1) with 6 by lia.
sep_apply_r_atomic (derivable1_wand_elim1 (store_dataqueue p_queue_pre q) (os_inv sg observed)).
cancel (store_dataqueue p_queue_pre q -* os_inv sg observed).
unfold store_dataqueue, dataqueue_fields.
split_pure_spatial.
- sepcon_assoc_change. cancel. rewrite PreH9. cancel.
- split_pures; dump_pre_spatial; auto.
Qed.

Lemma proof_of_DataqueuePeak_entail_wit_3 : DataqueuePeak_entail_wit_3.
Proof.
  aggressive_pre_process.
  Goal_apply (proof_of_DataqueuePeak_entail_wit_3_split_goal_spatial X old_length old_data before sg p_queue_pre StartAddr_pre size_pre observed q p_queue_sem_data p_queue_sem_blank p_queue_base p_queue_max_len p_queue_rear p_queue_front PreH1 PreH2 PreH3 PreH4 PreH5 PreH6 PreH7 PreH8 PreH9 PreH10 PreH11 PreH12 PreH13 PreH14 PreH15 PreH16 PreH17).
  Goal_apply (proof_of_DataqueuePeak_entail_wit_3_split_goal_2 X old_length old_data before sg p_queue_pre StartAddr_pre size_pre observed q p_queue_sem_data p_queue_sem_blank p_queue_base p_queue_max_len p_queue_rear p_queue_front PreH1 PreH2 PreH3 PreH4 PreH5 PreH6 PreH7 PreH8 PreH9 PreH10 PreH11 PreH12 PreH13 PreH14 PreH15 PreH16 PreH17).
Qed.

Lemma proof_of_DataqueuePeak_which_implies_wit_1_split_goal_1 : DataqueuePeak_which_implies_wit_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold store_dataqueue. Intros. dump_pre_spatial. tauto.
Qed.

Lemma proof_of_DataqueuePeak_which_implies_wit_1_split_goal_2 : DataqueuePeak_which_implies_wit_1_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold store_dataqueue. Intros. dump_pre_spatial. tauto.
Qed.

Lemma proof_of_DataqueuePeak_which_implies_wit_1_split_goal_spatial : DataqueuePeak_which_implies_wit_1_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold store_dataqueue, dataqueue_fields. Intros. change (6 * sizeof(CHAR)) with 6. csimpl. sepcon_assoc_change. cancel.
Qed.

Lemma proof_of_DataqueuePeak_which_implies_wit_1 : DataqueuePeak_which_implies_wit_1.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of_DataqueuePeak_which_implies_wit_1_split_goal_spatial.
  - Goal_apply proof_of_DataqueuePeak_which_implies_wit_1_split_goal_1.
  - Goal_apply proof_of_DataqueuePeak_which_implies_wit_1_split_goal_2.
Qed.

Lemma proof_of_DataqueuePeak_which_implies_wit_2 : DataqueuePeak_which_implies_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  destruct PreH1 as [Hmax [Hbase [Hfront [Hrear [Hlen [Hb [Hd [Hdiff Hcontents]]]]]]]].
  assert (Hcount : 0 < dataqueue_count q).
  { unfold dataqueue_count.
    destruct (Z_lt_ge_dec (dq_rear q) (dq_front q)).
    - rewrite Z.mod_small; lia.
    - replace (dq_rear q - dq_front q + dq_max_len q)
        with (dq_rear q - dq_front q + 1 * dq_max_len q) by lia.
      rewrite Z.mod_add by lia. rewrite Z.mod_small; lia. }
  assert (Hnat : (0 < Z.to_nat (dataqueue_count q))%nat).
  { pose proof (Z2Nat.id (dataqueue_count q) ltac:(lia)); lia. }
  unfold dataqueue_contents in Hcontents.
  destruct (Z.to_nat (dataqueue_count q)) as [|n] eqn:Hn; [lia|].
  cbn [seq map] in Hcontents.
  inversion Hcontents as [|a l Ha Hl]; subst.
  rewrite Z.add_0_r, Z.mod_small in Ha by lia.
  destruct Ha as [e He].
  assert (Hpeak : dataqueue_peak q = Some e) by exact He.
  unfold dataqueue_buffer; destruct (Z.eq_dec (dq_base q) 0); [contradiction|].
  Intros.
  assert (Hz : Znth (dq_front q) (dq_slots q) None = Some e).
  { unfold Znth. exact He. }
  sep_apply_l_atomic (store_array_split_to_missing_i (option DataqueueElem) dataqueue_slot
    (dq_base q) (dq_front q) (dq_max_len q) (dq_slots q) None Hfront).
  rewrite Hz.
  Exists e.
  split_pure_spatial; [|dump_pre_spatial; exact Hpeak].
  cancel (dataqueue_slot (dq_base q) (dq_front q) (Some e)).
  apply_sepcon_adjoint.
  sep_apply_l_atomic (store_array_missing_i_merge_to_array (option DataqueueElem) dataqueue_slot
    (dq_base q) (dq_front q) (dq_max_len q) (Some e) (dq_slots q) Hfront).
  rewrite <- Hz.
  rewrite replace_Znth_Znth by (unfold Zlength; lia).
  split_pure_spatial; [cancel | dump_pre_spatial; tauto].
Qed.

Lemma proof_of_DataqueuePeak_which_implies_wit_3_split_goal_spatial : DataqueuePeak_which_implies_wit_3_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold dataqueue_slot.
  pose proof (proj1 (proj2 dataqueue_layout_abi)) as Hsize.
  unfold KTaskCNotation.sizeof_front_end_type in Hsize.
  unfold sizeof_front_end_type.
  rewrite Hsize.
  cancel.
Qed.

Lemma proof_of_DataqueuePeak_which_implies_wit_3 : DataqueuePeak_which_implies_wit_3.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_DataqueuePeak_which_implies_wit_3_split_goal_spatial.
Qed.

Lemma proof_of_DataqueuePeak_which_implies_wit_4 : DataqueuePeak_which_implies_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  destruct old_data as [v|]; destruct old_length as [n|];
    unfold peak_data_slot, peak_length_slot.
  - sep_apply_l_atomic (store_ptr_undef_store_ptr StartAddr v).
    sep_apply_l_atomic (store_uint_undef_store_uint size n). cancel.
  - sep_apply_l_atomic (store_ptr_undef_store_ptr StartAddr v). cancel.
  - sep_apply_l_atomic (store_uint_undef_store_uint size n). cancel.
  - cancel.
Qed.

