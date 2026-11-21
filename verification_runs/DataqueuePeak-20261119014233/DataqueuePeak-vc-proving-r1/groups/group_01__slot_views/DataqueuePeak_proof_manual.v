From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.dataqueue Require Import DataqueuePeak_goal.
From CRTOS_Verify.VC.dataqueue Require Import DataqueuePeak_proof_auto.
Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Local Open Scope sac.

Lemma proof_of_DataqueuePeak_entail_wit_1 : DataqueuePeak_entail_wit_1.
Proof. Admitted.

Lemma proof_of_DataqueuePeak_entail_wit_2_split_goal_1 : DataqueuePeak_entail_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of_DataqueuePeak_entail_wit_2_split_goal_2 : DataqueuePeak_entail_wit_2_split_goal_2.
Proof. Abort.

Lemma proof_of_DataqueuePeak_entail_wit_2_split_goal_spatial : DataqueuePeak_entail_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of_DataqueuePeak_entail_wit_2 : DataqueuePeak_entail_wit_2.
Proof. Admitted.

Lemma proof_of_DataqueuePeak_entail_wit_3_split_goal_1 : DataqueuePeak_entail_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of_DataqueuePeak_entail_wit_3_split_goal_2 : DataqueuePeak_entail_wit_3_split_goal_2.
Proof. Abort.

Lemma proof_of_DataqueuePeak_entail_wit_3_split_goal_spatial : DataqueuePeak_entail_wit_3_split_goal_spatial.
Proof. Abort.

Lemma proof_of_DataqueuePeak_entail_wit_3 : DataqueuePeak_entail_wit_3.
Proof. Admitted.

Lemma proof_of_DataqueuePeak_which_implies_wit_1_split_goal_1 : DataqueuePeak_which_implies_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of_DataqueuePeak_which_implies_wit_1_split_goal_2 : DataqueuePeak_which_implies_wit_1_split_goal_2.
Proof. Abort.

Lemma proof_of_DataqueuePeak_which_implies_wit_1_split_goal_spatial : DataqueuePeak_which_implies_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of_DataqueuePeak_which_implies_wit_1 : DataqueuePeak_which_implies_wit_1.
Proof. Admitted.

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

