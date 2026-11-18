From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.dataqueue Require Import InitDataqueue_goal.
From CRTOS_Verify.VC.dataqueue Require Import InitDataqueue_proof_auto.
Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Local Open Scope sac.


Lemma proof_of_InitDataqueue_safety_wit_1 : InitDataqueue_safety_wit_1.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_2 : InitDataqueue_safety_wit_2.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_3 : InitDataqueue_safety_wit_3.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_4 : InitDataqueue_safety_wit_4.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_5 : InitDataqueue_safety_wit_5.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_6 : InitDataqueue_safety_wit_6.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_7 : InitDataqueue_safety_wit_7.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_8 : InitDataqueue_safety_wit_8.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_9 : InitDataqueue_safety_wit_9.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_10 : InitDataqueue_safety_wit_10.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_11 : InitDataqueue_safety_wit_11.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_13 : InitDataqueue_safety_wit_13.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_14 : InitDataqueue_safety_wit_14.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_15 : InitDataqueue_safety_wit_15.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_16 : InitDataqueue_safety_wit_16.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_17 : InitDataqueue_safety_wit_17.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_18 : InitDataqueue_safety_wit_18.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_19 : InitDataqueue_safety_wit_19.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_20 : InitDataqueue_safety_wit_20.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_21 : InitDataqueue_safety_wit_21.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_22 : InitDataqueue_safety_wit_22.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_23 : InitDataqueue_safety_wit_23.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_24 : InitDataqueue_safety_wit_24.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_25 : InitDataqueue_safety_wit_25.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_26 : InitDataqueue_safety_wit_26.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_27 : InitDataqueue_safety_wit_27.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_28 : InitDataqueue_safety_wit_28.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_29 : InitDataqueue_safety_wit_29.
Proof. Admitted.

Lemma proof_of_InitDataqueue_partial_solve_wit_1 : InitDataqueue_partial_solve_wit_1.
Proof. Admitted.

Lemma proof_of_InitDataqueue_partial_solve_wit_2 : InitDataqueue_partial_solve_wit_2.
Proof. Admitted.

Lemma proof_of_InitDataqueue_partial_solve_wit_3_pure : InitDataqueue_partial_solve_wit_3_pure.
Proof. Admitted.

Lemma proof_of_InitDataqueue_partial_solve_wit_3 : InitDataqueue_partial_solve_wit_3.
Proof. Admitted.

Lemma proof_of_InitDataqueue_partial_solve_wit_4_pure : InitDataqueue_partial_solve_wit_4_pure.
Proof.
LLM_pre_process ltac:(lia || int_auto).

Qed.

Lemma proof_of_InitDataqueue_partial_solve_wit_4 : InitDataqueue_partial_solve_wit_4.
Proof.
LLM_pre_process ltac:(lia || int_auto).
intros. unfold InitDataqueue_partial_solve_wit_4_aux. LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_InitDataqueue_partial_solve_wit_5 : InitDataqueue_partial_solve_wit_5.
Proof. Admitted.

Lemma proof_of_InitDataqueue_partial_solve_wit_6 : InitDataqueue_partial_solve_wit_6.
Proof. Admitted.

Lemma proof_of_InitDataqueue_partial_solve_wit_7 : InitDataqueue_partial_solve_wit_7.
Proof. Admitted.

Lemma proof_of_InitDataqueue_partial_solve_wit_8_pure : InitDataqueue_partial_solve_wit_8_pure.
Proof. Admitted.

Lemma proof_of_InitDataqueue_partial_solve_wit_8 : InitDataqueue_partial_solve_wit_8.
Proof. Admitted.

Lemma proof_of_InitDataqueue_partial_solve_wit_9_pure : InitDataqueue_partial_solve_wit_9_pure.
Proof. Admitted.

Lemma proof_of_InitDataqueue_partial_solve_wit_9 : InitDataqueue_partial_solve_wit_9.
Proof. Admitted.

Lemma proof_of_InitDataqueue_partial_solve_wit_10_pure : InitDataqueue_partial_solve_wit_10_pure.
Proof. Admitted.

Lemma proof_of_InitDataqueue_partial_solve_wit_10 : InitDataqueue_partial_solve_wit_10.
Proof. Admitted.

Lemma proof_of_InitDataqueue_partial_solve_wit_11_pure : InitDataqueue_partial_solve_wit_11_pure.
Proof. Admitted.

Lemma proof_of_InitDataqueue_partial_solve_wit_11 : InitDataqueue_partial_solve_wit_11.
Proof. Admitted.

Lemma proof_of_InitDataqueue_partial_solve_wit_12_pure : InitDataqueue_partial_solve_wit_12_pure.
Proof. Admitted.

Lemma proof_of_InitDataqueue_partial_solve_wit_12 : InitDataqueue_partial_solve_wit_12.
Proof. Admitted.

Lemma proof_of_InitDataqueue_partial_solve_wit_13_pure : InitDataqueue_partial_solve_wit_13_pure.
Proof. Admitted.

Lemma proof_of_InitDataqueue_partial_solve_wit_13 : InitDataqueue_partial_solve_wit_13.
Proof. Admitted.

Lemma proof_of_InitDataqueue_partial_solve_wit_14_pure : InitDataqueue_partial_solve_wit_14_pure.
Proof. Admitted.

Lemma proof_of_InitDataqueue_partial_solve_wit_14 : InitDataqueue_partial_solve_wit_14.
Proof. Admitted.

Lemma proof_of_InitDataqueue_safety_wit_12_split_goal_1 : InitDataqueue_safety_wit_12_split_goal_1.
Proof. Abort.

Lemma proof_of_InitDataqueue_safety_wit_12_split_goal_2 : InitDataqueue_safety_wit_12_split_goal_2.
Proof. Abort.

Lemma proof_of_InitDataqueue_safety_wit_12 : InitDataqueue_safety_wit_12.
Proof. Admitted.

Lemma proof_of_InitDataqueue_entail_wit_1 : InitDataqueue_entail_wit_1.
Proof. Admitted.

Lemma proof_of_InitDataqueue_entail_wit_2_1 : InitDataqueue_entail_wit_2_1.
Proof. Admitted.

Lemma proof_of_InitDataqueue_entail_wit_2_2 : InitDataqueue_entail_wit_2_2.
Proof. Admitted.

Lemma proof_of_InitDataqueue_entail_wit_2_3 : InitDataqueue_entail_wit_2_3.
Proof. Admitted.

Lemma proof_of_InitDataqueue_entail_wit_2_4 : InitDataqueue_entail_wit_2_4.
Proof. Admitted.

Lemma proof_of_InitDataqueue_return_wit_1 : InitDataqueue_return_wit_1.
Proof. Admitted.

Lemma proof_of_InitDataqueue_return_wit_2 : InitDataqueue_return_wit_2.
Proof. Admitted.

Lemma proof_of_InitDataqueue_return_wit_3 : InitDataqueue_return_wit_3.
Proof. Admitted.

Lemma proof_of_InitDataqueue_return_wit_4 : InitDataqueue_return_wit_4.
Proof. Admitted.

Lemma proof_of_InitDataqueue_which_implies_wit_1_split_goal_1 : InitDataqueue_which_implies_wit_1_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
unfold DataqueueStorage. Intros_p H. dump_pre_spatial. tauto.
Qed.

Lemma proof_of_InitDataqueue_which_implies_wit_1_split_goal_2 : InitDataqueue_which_implies_wit_1_split_goal_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
unfold DataqueueStorage. Intros_p H. dump_pre_spatial. tauto.
Qed.

Lemma proof_of_InitDataqueue_which_implies_wit_1_split_goal_spatial : InitDataqueue_which_implies_wit_1_split_goal_spatial.
Proof.
LLM_pre_process ltac:(lia || int_auto).
unfold DataqueueStorage. Intros_p H. pose proof (proj1 dataqueue_layout_abi) as Hsize. unfold KTaskCNotation.sizeof_front_end_type, sizeof_front_end_type in *. rewrite Hsize. cancel.
Qed.

Lemma proof_of_InitDataqueue_which_implies_wit_1 : InitDataqueue_which_implies_wit_1.
Proof.
aggressive_pre_process.
Goal_apply proof_of_InitDataqueue_which_implies_wit_1_split_goal_spatial.
Goal_apply proof_of_InitDataqueue_which_implies_wit_1_split_goal_1.
Goal_apply proof_of_InitDataqueue_which_implies_wit_1_split_goal_2.
Qed.

Lemma proof_of_InitDataqueue_which_implies_wit_2_split_goal_spatial : InitDataqueue_which_implies_wit_2_split_goal_spatial.
Proof.
LLM_pre_process ltac:(lia || int_auto).
pose proof (proj1 dataqueue_layout_abi) as Hsize.
pose proof (proj2 (proj2 dataqueue_layout_abi) p_queue) as Ho.
destruct Ho as [Hf [Hr [Hm [Hb [Hs [Ht _]]]]]].
unfold KTaskCNotation.sizeof_front_end_type, sizeof_front_end_type in *.
rewrite Hsize. rewrite Hf,Hr,Hm,Hb,Hs,Ht. simpl_nonptr_sizeof.
rename p_queue into p.
assert (H2 : addr_aligned p 2).
{ unfold addr_aligned in *. apply Z.mod_divide; try lia.
  apply Z.mod_divide in PreH1; try lia. destruct PreH1 as [k Hk].
  exists (2*k). lia. }
assert (Ha : forall k, addr_aligned (p+4*k) 4).
{ intro k. unfold addr_aligned in *. rewrite Z.add_mod,Z.mul_mod by lia.
  rewrite PreH1. cbn. reflexivity. }
assert (Ha2 : forall k, addr_aligned (p+2*k) 2).
{ intro k. unfold addr_aligned in *. rewrite Z.add_mod,Z.mul_mod by lia.
  rewrite H2. cbn. reflexivity. }
sep_apply_l_atomic (CharArray.full_split_to_full p 2 20 (repeat_Z 0 20) ltac:(lia)).
change (sublist 0 2 (repeat_Z 0 20)) with (repeat_Z 0 2).
change (sublist 2 20 (repeat_Z 0 20)) with (repeat_Z 0 18).
change (20-2) with 18.
unfold StoreCharAsElement.sizeA. rewrite sizeof_char.
replace (p+2*1) with (p+2) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+2) 2 18 (repeat_Z 0 18) ltac:(lia)).
change (sublist 0 2 (repeat_Z 0 18)) with (repeat_Z 0 2).
change (sublist 2 18 (repeat_Z 0 18)) with (repeat_Z 0 16).
change (18-2) with 16.
unfold StoreCharAsElement.sizeA. rewrite sizeof_char.
replace ((p+2)+2*1) with (p+4) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+4) 2 16 (repeat_Z 0 16) ltac:(lia)).
change (sublist 0 2 (repeat_Z 0 16)) with (repeat_Z 0 2).
change (sublist 2 16 (repeat_Z 0 16)) with (repeat_Z 0 14).
change (16-2) with 14.
unfold StoreCharAsElement.sizeA. rewrite sizeof_char.
replace ((p+4)+2*1) with (p+6) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+6) 2 14 (repeat_Z 0 14) ltac:(lia)).
change (sublist 0 2 (repeat_Z 0 14)) with (repeat_Z 0 2).
change (sublist 2 14 (repeat_Z 0 14)) with (repeat_Z 0 12).
change (14-2) with 12.
unfold StoreCharAsElement.sizeA. rewrite sizeof_char.
replace ((p+6)+2*1) with (p+8) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+8) 4 12 (repeat_Z 0 12) ltac:(lia)).
change (sublist 0 4 (repeat_Z 0 12)) with (repeat_Z 0 4).
change (sublist 4 12 (repeat_Z 0 12)) with (repeat_Z 0 8).
change (12-4) with 8.
unfold StoreCharAsElement.sizeA. rewrite sizeof_char.
replace ((p+8)+4*1) with (p+12) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+12) 4 8 (repeat_Z 0 8) ltac:(lia)).
change (sublist 0 4 (repeat_Z 0 8)) with (repeat_Z 0 4).
change (sublist 4 8 (repeat_Z 0 8)) with (repeat_Z 0 4).
change (8-4) with 4.
unfold StoreCharAsElement.sizeA. rewrite sizeof_char.
replace ((p+12)+4*1) with (p+16) by lia.
sep_apply_l_atomic (semaphore_two_zero_bytes_ushort p H2).
sep_apply_l_atomic (semaphore_two_zero_bytes_ushort (p+2) (Ha2 1)).
sep_apply_l_atomic (semaphore_two_zero_bytes_ushort (p+4) (Ha2 2)).
sep_apply_l_atomic (semaphore_four_zero_bytes_ptr (p+8) (Ha 2)).
sep_apply_l_atomic (four_zero_uint__zero_layout (p+12) (Ha 3)).
sep_apply_l_atomic (four_zero_uint__zero_layout (p+16) (Ha 4)).
sep_apply_l_atomic (store_uint_cast (p+12) 0).
sep_apply_l_atomic (store_uint_cast (p+16) 0).
change (signed_last_nbits 0 32) with 0.
sep_apply_l_atomic (CharArray.full_to_undef_full (p+6) 2 (repeat_Z 0 2)).
replace (p+6*1) with (p+6) by lia.
repeat progress cancel.

Qed.

Lemma proof_of_InitDataqueue_which_implies_wit_2 : InitDataqueue_which_implies_wit_2.
Proof.
aggressive_pre_process. Goal_apply proof_of_InitDataqueue_which_implies_wit_2_split_goal_spatial.
Qed.

