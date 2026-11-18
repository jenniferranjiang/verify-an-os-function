From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.dataqueue Require Import DeInitDataqueue_goal.
From CRTOS_Verify.VC.dataqueue Require Import DeInitDataqueue_proof_auto.
Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Local Open Scope sac.


Lemma proof_of_DeInitDataqueue_safety_wit_1 : DeInitDataqueue_safety_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DeInitDataqueue_safety_wit_2 : DeInitDataqueue_safety_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DeInitDataqueue_safety_wit_3 : DeInitDataqueue_safety_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DeInitDataqueue_safety_wit_4 : DeInitDataqueue_safety_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DeInitDataqueue_safety_wit_5 : DeInitDataqueue_safety_wit_5.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DeInitDataqueue_safety_wit_6 : DeInitDataqueue_safety_wit_6.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DeInitDataqueue_safety_wit_7 : DeInitDataqueue_safety_wit_7.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DeInitDataqueue_safety_wit_8 : DeInitDataqueue_safety_wit_8.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DeInitDataqueue_safety_wit_9 : DeInitDataqueue_safety_wit_9.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DeInitDataqueue_safety_wit_10 : DeInitDataqueue_safety_wit_10.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DeInitDataqueue_safety_wit_11 : DeInitDataqueue_safety_wit_11.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DeInitDataqueue_safety_wit_12 : DeInitDataqueue_safety_wit_12.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DeInitDataqueue_safety_wit_13 : DeInitDataqueue_safety_wit_13.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DeInitDataqueue_safety_wit_14 : DeInitDataqueue_safety_wit_14.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DeInitDataqueue_safety_wit_15 : DeInitDataqueue_safety_wit_15.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DeInitDataqueue_safety_wit_16 : DeInitDataqueue_safety_wit_16.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_2_1 : DeInitDataqueue_entail_wit_2_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_2_2 : DeInitDataqueue_entail_wit_2_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_3_1 : DeInitDataqueue_entail_wit_3_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_3_2 : DeInitDataqueue_entail_wit_3_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DeInitDataqueue_return_wit_1 : DeInitDataqueue_return_wit_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
Exists final.
LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_1 : DeInitDataqueue_partial_solve_wit_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_2 : DeInitDataqueue_partial_solve_wit_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_3_pure : DeInitDataqueue_partial_solve_wit_3_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_3 : DeInitDataqueue_partial_solve_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  intros X.
  unfold DeInitDataqueue_partial_solve_wit_3_aux.
  LLM_pre_process ltac:(lia || int_auto).
  subst.
  split_pure_spatial.
  - repeat progress cancel.
  - split_pures; dump_pre_spatial; auto; try lia.
Qed.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_4_pure : DeInitDataqueue_partial_solve_wit_4_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial. subst. assumption.
Qed.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_4 : DeInitDataqueue_partial_solve_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  intros X.
  unfold DeInitDataqueue_partial_solve_wit_4_aux.
  LLM_pre_process ltac:(lia || int_auto).
  subst.
  split_pure_spatial.
  - repeat progress cancel.
  - split_pures; dump_pre_spatial; auto; try lia.
Qed.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_5_pure : DeInitDataqueue_partial_solve_wit_5_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial. subst. assumption.
Qed.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_5 : DeInitDataqueue_partial_solve_wit_5.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  intros X.
  unfold DeInitDataqueue_partial_solve_wit_5_aux.
  LLM_pre_process ltac:(lia || int_auto).
  subst.
  split_pure_spatial.
  - repeat progress cancel.
  - split_pures; dump_pre_spatial; auto; try lia.
Qed.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_6_pure : DeInitDataqueue_partial_solve_wit_6_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  all: (dump_pre_spatial; subst; assumption).
Qed.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_6 : DeInitDataqueue_partial_solve_wit_6.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold DeInitDataqueue_partial_solve_wit_6_aux.
  LLM_pre_process ltac:(lia || int_auto).
  subst.
  split_pure_spatial.
  - repeat progress cancel.
  - split_pures; dump_pre_spatial; auto; try lia.
Qed.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_7_pure : DeInitDataqueue_partial_solve_wit_7_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  all: (dump_pre_spatial; subst; assumption).
Qed.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_7 : DeInitDataqueue_partial_solve_wit_7.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold DeInitDataqueue_partial_solve_wit_7_aux.
  LLM_pre_process ltac:(lia || int_auto).
  subst.
  split_pure_spatial.
  - repeat progress cancel.
  - split_pures; dump_pre_spatial; auto; try lia.
Qed.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_8_pure : DeInitDataqueue_partial_solve_wit_8_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  all: (dump_pre_spatial; subst; assumption).
Qed.

Lemma proof_of_DeInitDataqueue_partial_solve_wit_8 : DeInitDataqueue_partial_solve_wit_8.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold DeInitDataqueue_partial_solve_wit_8_aux.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_1_split_goal_1 : DeInitDataqueue_entail_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of_DeInitDataqueue_entail_wit_1_split_goal_2 : DeInitDataqueue_entail_wit_1_split_goal_2.
Proof. Abort.

Lemma proof_of_DeInitDataqueue_entail_wit_1 : DeInitDataqueue_entail_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hentry : dataqueue_cleanup_entry sg_init_cleanup p_queue_pre
      q_init_cleanup refs_init_cleanup (Crtos_RTrans before_init_cleanup)).
  { destruct PreH2 as [states [Hstates Hsafe]].
    unfold LastSeen in Hstates.
    unfold safe, abs_deinit_dataqueue in Hsafe.
    rewrite wp_bind, wp_assertS in Hsafe.
    destruct Hsafe as [Hentry _].
    unfold dataqueue_cleanup_entry in Hentry |- *.
    intros obs Hobs.
    apply Hentry.
    apply (proj2 (Hstates obs)). exact Hobs. }
  pose proof (Hentry observed PreH1) as Hguard.
  prop_apply_p Hguard.
  Intros_p Hg.
  unfold dataqueue_cleanup_guard in Hg.
  destruct Hg as [Hnone [Href1 [Href2 [Hblank Hdata]]]].
  split_pure_spatial.
  - repeat progress cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_1 : DeInitDataqueue_entail_wit_4_1_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
rewrite PreH10.
unfold semaphore_delete_ic_effect in PreH1.
destruct PreH1 as [[Hinvalid Heq] | [Hvalid [[Hmiss Heq] | [s [Hin [Hid [Hpend Heq]]]]]]].
- subst after; exact PreH15.
- subst after; exact PreH15.
- subst after. unfold semaphore_delete_quiescent in *. intros Hrange.
  specialize (PreH15 Hrange). destruct PreH15 as [Htasks Hqueues].
  split.
  + intros t Ht Hid2. cbn [replace_semaphores] in Ht.
    unfold semaphore_unpublish in Ht. apply filter_In in Ht.
    apply Htasks; tauto.
  + intros p q Hq. cbn [replace_semaphores] in Hq.
    exact (Hqueues p q Hq).
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_2 : DeInitDataqueue_entail_wit_4_1_split_goal_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
cbn [dataqueue_retired dq_sem_blank].
destruct (Z.leb 0 (dq_sem_blank q_init_cleanup)) eqn:Hsign; [reflexivity|].
apply Z.leb_gt in Hsign. lia.
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_3 : DeInitDataqueue_entail_wit_4_1_split_goal_3.
Proof.
LLM_pre_process ltac:(lia || int_auto).
cbn [dataqueue_retired dq_sem_blank].
destruct (Z.leb 0 (dq_sem_blank q_init_cleanup)) eqn:Hsign; [reflexivity|].
apply Z.leb_gt in Hsign. lia.
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_1 : DeInitDataqueue_entail_wit_4_1.
Proof.
aggressive_pre_process.
Goal_apply proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_1.
Goal_apply proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_2.
Goal_apply proof_of_DeInitDataqueue_entail_wit_4_1_split_goal_3.
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_1 : DeInitDataqueue_entail_wit_4_2_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
rewrite PreH10.
unfold semaphore_delete_ic_effect in PreH1.
destruct PreH1 as [[Hinvalid Heq] | [Hvalid [[Hmiss Heq] | [s [Hin [Hid [Hpend Heq]]]]]]].
- subst after; exact PreH16.
- subst after; exact PreH16.
- subst after. unfold semaphore_delete_quiescent in *. intros Hrange.
  specialize (PreH16 Hrange). destruct PreH16 as [Htasks Hqueues].
  split.
  + intros t Ht Hid2. cbn [replace_semaphores] in Ht.
    unfold semaphore_unpublish in Ht. apply filter_In in Ht.
    apply Htasks; tauto.
  + intros p q Hq. cbn [replace_semaphores] in Hq.
    exact (Hqueues p q Hq).
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_2 : DeInitDataqueue_entail_wit_4_2_split_goal_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
cbn [dataqueue_retired dq_sem_blank].
destruct (Z.leb 0 (dq_sem_blank q_init_cleanup)) eqn:Hsign; [reflexivity|].
apply Z.leb_gt in Hsign. lia.
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_3 : DeInitDataqueue_entail_wit_4_2_split_goal_3.
Proof.
LLM_pre_process ltac:(lia || int_auto).
cbn [dataqueue_retired dq_sem_blank].
destruct (Z.leb 0 (dq_sem_blank q_init_cleanup)) eqn:Hsign; [reflexivity|].
apply Z.leb_gt in Hsign. lia.
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_2 : DeInitDataqueue_entail_wit_4_2.
Proof.
aggressive_pre_process.
Goal_apply proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_1.
Goal_apply proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_2.
Goal_apply proof_of_DeInitDataqueue_entail_wit_4_2_split_goal_3.
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_3_split_goal_1 : DeInitDataqueue_entail_wit_4_3_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
cbn [dataqueue_retired dq_sem_blank].
destruct (Z.leb 0 (dq_sem_blank q_init_cleanup)) eqn:Hsign.
- apply Z.leb_le in Hsign. lia.
- assumption.
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_3_split_goal_2 : DeInitDataqueue_entail_wit_4_3_split_goal_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
cbn [dataqueue_retired dq_sem_blank].
destruct (Z.leb 0 (dq_sem_blank q_init_cleanup)) eqn:Hsign.
- apply Z.leb_le in Hsign. lia.
- assumption.
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_3 : DeInitDataqueue_entail_wit_4_3.
Proof.
aggressive_pre_process.
Goal_apply proof_of_DeInitDataqueue_entail_wit_4_3_split_goal_1.
Goal_apply proof_of_DeInitDataqueue_entail_wit_4_3_split_goal_2.
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_4_split_goal_1 : DeInitDataqueue_entail_wit_4_4_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
cbn [dataqueue_retired dq_sem_blank].
destruct (Z.leb 0 (dq_sem_blank q_init_cleanup)) eqn:Hsign.
- apply Z.leb_le in Hsign. lia.
- assumption.
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_4_split_goal_2 : DeInitDataqueue_entail_wit_4_4_split_goal_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
cbn [dataqueue_retired dq_sem_blank].
destruct (Z.leb 0 (dq_sem_blank q_init_cleanup)) eqn:Hsign.
- apply Z.leb_le in Hsign. lia.
- assumption.
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_4_4 : DeInitDataqueue_entail_wit_4_4.
Proof.
aggressive_pre_process.
Goal_apply proof_of_DeInitDataqueue_entail_wit_4_4_split_goal_1.
Goal_apply proof_of_DeInitDataqueue_entail_wit_4_4_split_goal_2.
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_5_1 : DeInitDataqueue_entail_wit_5_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
Exists after.
split_pure_spatial.
- subst p_queue_front p_queue_rear p_queue_max_len p_queue_base p_queue_sem_blank p_queue_sem_data.
unfold store_dataqueue, dataqueue_fields, dataqueue_buffer.
cbn [dataqueue_retired dq_front dq_rear dq_max_len dq_base dq_sem_blank dq_sem_data dq_slots].
assert (Hd : Z.leb 0 (dq_sem_data q_init_cleanup) = true) by (apply Z.leb_le; lia).
rewrite Hd.
cbn.
split_pure_spatial.
+ repeat progress cancel.
rewrite sizeof_char.
cbn.
repeat progress cancel.
+ split_pures; dump_pre_spatial; auto.
- split_pures.
+ dump_pre_spatial.
assert (Heffect : dataqueue_cleanup_effect q_init_cleanup observed after).
{ unfold dataqueue_cleanup_effect.
exists middle.
assert (Hb : Z.leb 0 (dq_sem_blank q_init_cleanup) = true) by (apply Z.leb_le; lia).
assert (Hd : Z.leb 0 (dq_sem_data q_init_cleanup) = true) by (apply Z.leb_le; lia).
rewrite Hb, Hd.
split; [exact PreH8|].
rewrite <- PreH15.
exact PreH1.
}
assert (Hstep : hs_eval (os_atomic_cmd (abs_deinit_dataqueue_locked q_init_cleanup)) (LastSeen before_init_cleanup) (LastSeen after) tt).
{ intros states Hseen.
exists (Crtos_RTrans after).
split.
- cbn [os_atomic_cmd abs_deinit_dataqueue_locked MonadErr.nrm].
exists observed, after.
split.
+ apply Hseen.
exact PreH5.
+ split; [exact Heffect|reflexivity].
- unfold LastSeen.
reflexivity.
}
eapply (highstependret_derive _ _ tt (fun _ => LastSeen after) Hstep).
unfold abs_deinit_dataqueue in PreH6 at 1.
prog_nf in PreH6.
destruct PreH6 as [states [Hseen Hwp]].
exists states.
split; [exact Hseen|].
unfold safe in Hwp |- *.
rewrite wp_bind in Hwp.
rewrite wp_assertS in Hwp.
exact (proj2 Hwp).
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_5_2 : DeInitDataqueue_entail_wit_5_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
Exists after.
split_pure_spatial.
- subst p_queue_front p_queue_rear p_queue_max_len p_queue_base p_queue_sem_blank p_queue_sem_data.
unfold store_dataqueue, dataqueue_fields, dataqueue_buffer.
cbn [dataqueue_retired dq_front dq_rear dq_max_len dq_base dq_sem_blank dq_sem_data dq_slots].
assert (Hd : Z.leb 0 (dq_sem_data q_init_cleanup) = true) by (apply Z.leb_le; lia).
rewrite Hd.
cbn.
split_pure_spatial.
+ repeat progress cancel.
rewrite sizeof_char.
cbn.
cancel (os_inv sg_init_cleanup after).
cancel (InsideCritical sg_init_cleanup observed).
repeat progress cancel.
+ split_pures; dump_pre_spatial; auto.
- split_pures.
+ dump_pre_spatial.
assert (Heffect : dataqueue_cleanup_effect q_init_cleanup observed after).
{ unfold dataqueue_cleanup_effect.
exists middle.
assert (Hb : Z.leb 0 (dq_sem_blank q_init_cleanup) = false) by (apply Z.leb_gt; lia).
assert (Hd : Z.leb 0 (dq_sem_data q_init_cleanup) = true) by (apply Z.leb_le; lia).
rewrite Hb, Hd.
split; [exact PreH8|].
rewrite <- PreH15.
exact PreH1.
}
assert (Hstep : hs_eval (os_atomic_cmd (abs_deinit_dataqueue_locked q_init_cleanup)) (LastSeen before_init_cleanup) (LastSeen after) tt).
{ intros states Hseen.
exists (Crtos_RTrans after).
split.
- cbn [os_atomic_cmd abs_deinit_dataqueue_locked MonadErr.nrm].
exists observed, after.
split.
+ apply Hseen.
exact PreH5.
+ split; [exact Heffect|reflexivity].
- unfold LastSeen.
reflexivity.
}
eapply (highstependret_derive _ _ tt (fun _ => LastSeen after) Hstep).
unfold abs_deinit_dataqueue in PreH6 at 1.
prog_nf in PreH6.
destruct PreH6 as [states [Hseen Hwp]].
exists states.
split; [exact Hseen|].
unfold safe in Hwp |- *.
rewrite wp_bind in Hwp.
rewrite wp_assertS in Hwp.
exact (proj2 Hwp).
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_5_3 : DeInitDataqueue_entail_wit_5_3.
Proof.
LLM_pre_process ltac:(lia || int_auto).
Exists middle.
split_pure_spatial.
- subst p_queue_front p_queue_rear p_queue_max_len p_queue_base p_queue_sem_blank p_queue_sem_data.
unfold store_dataqueue, dataqueue_fields, dataqueue_buffer.
cbn [dataqueue_retired dq_front dq_rear dq_max_len dq_base dq_sem_blank dq_sem_data dq_slots].
assert (Hd : Z.leb 0 (dq_sem_data q_init_cleanup) = false) by (apply Z.leb_gt; lia).
rewrite Hd.
cbn.
split_pure_spatial.
+ repeat progress cancel.
rewrite sizeof_char.
cbn.
repeat progress cancel.
+ split_pures; dump_pre_spatial; auto.
- split_pures.
+ dump_pre_spatial.
assert (Heffect : dataqueue_cleanup_effect q_init_cleanup observed middle).
{ unfold dataqueue_cleanup_effect.
exists middle.
assert (Hb : Z.leb 0 (dq_sem_blank q_init_cleanup) = true) by (apply Z.leb_le; lia).
assert (Hd : Z.leb 0 (dq_sem_data q_init_cleanup) = false) by (apply Z.leb_gt; lia).
rewrite Hb, Hd.
split; [exact PreH7|reflexivity].
}
assert (Hstep : hs_eval (os_atomic_cmd (abs_deinit_dataqueue_locked q_init_cleanup)) (LastSeen before_init_cleanup) (LastSeen middle) tt).
{ intros states Hseen.
exists (Crtos_RTrans middle).
split.
- cbn [os_atomic_cmd abs_deinit_dataqueue_locked MonadErr.nrm].
exists observed, middle.
split.
+ apply Hseen.
exact PreH4.
+ split; [exact Heffect|reflexivity].
- unfold LastSeen.
reflexivity.
}
eapply (highstependret_derive _ _ tt (fun _ => LastSeen middle) Hstep).
unfold abs_deinit_dataqueue in PreH5 at 1.
prog_nf in PreH5.
destruct PreH5 as [states [Hseen Hwp]].
exists states.
split; [exact Hseen|].
unfold safe in Hwp |- *.
rewrite wp_bind in Hwp.
rewrite wp_assertS in Hwp.
exact (proj2 Hwp).
Qed.

Lemma proof_of_DeInitDataqueue_entail_wit_5_4 : DeInitDataqueue_entail_wit_5_4.
Proof.
LLM_pre_process ltac:(lia || int_auto).
Exists middle.
split_pure_spatial.
- subst p_queue_front p_queue_rear p_queue_max_len p_queue_base p_queue_sem_blank p_queue_sem_data.
unfold store_dataqueue, dataqueue_fields, dataqueue_buffer.
cbn [dataqueue_retired dq_front dq_rear dq_max_len dq_base dq_sem_blank dq_sem_data dq_slots].
assert (Hd : Z.leb 0 (dq_sem_data q_init_cleanup) = false) by (apply Z.leb_gt; lia).
rewrite Hd.
cbn.
split_pure_spatial.
+ repeat progress cancel.
rewrite sizeof_char.
cbn.
repeat progress cancel.
+ split_pures; dump_pre_spatial; auto.
- split_pures.
+ dump_pre_spatial.
assert (Heffect : dataqueue_cleanup_effect q_init_cleanup observed middle).
{ unfold dataqueue_cleanup_effect.
exists middle.
assert (Hb : Z.leb 0 (dq_sem_blank q_init_cleanup) = false) by (apply Z.leb_gt; lia).
assert (Hd : Z.leb 0 (dq_sem_data q_init_cleanup) = false) by (apply Z.leb_gt; lia).
rewrite Hb, Hd.
split; [exact PreH7|reflexivity].
}
assert (Hstep : hs_eval (os_atomic_cmd (abs_deinit_dataqueue_locked q_init_cleanup)) (LastSeen before_init_cleanup) (LastSeen middle) tt).
{ intros states Hseen.
exists (Crtos_RTrans middle).
split.
- cbn [os_atomic_cmd abs_deinit_dataqueue_locked MonadErr.nrm].
exists observed, middle.
split.
+ apply Hseen.
exact PreH4.
+ split; [exact Heffect|reflexivity].
- unfold LastSeen.
reflexivity.
}
eapply (highstependret_derive _ _ tt (fun _ => LastSeen middle) Hstep).
unfold abs_deinit_dataqueue in PreH5 at 1.
prog_nf in PreH5.
destruct PreH5 as [states [Hseen Hwp]].
exists states.
split; [exact Hseen|].
unfold safe in Hwp |- *.
rewrite wp_bind in Hwp.
rewrite wp_assertS in Hwp.
exact (proj2 Hwp).
Qed.

Lemma proof_of_DeInitDataqueue_which_implies_wit_1 : DeInitDataqueue_which_implies_wit_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
assert (Hptr : forall p, (p # Ptr |->_) |-- (p # UInt |->_)).
{
intros p.
unfold poly_undef_store, undef_store_ptr, undef_store_uint, undef_store_integer.
simpl_nonptr_sizeof.
cbn.
cancel.
change (valid_object p 4 4) with (valid_object p sizeof(PTR) Arch.ptr_align).
change (Z.to_nat sizeof(PTR)) with 4%nat.
cbn [undef_store_bytes].
repeat progress cancel.
}
assert (Huint : forall p, (p # UInt |->_) |-- CharArray.undef_full p 4).
{
intros p.
rewrite undef_store_uint_undef_store_char.
Intros_p H.
unfold CharArray.undef_full, store_undef_array.
cbn [store_undef_array_rec Z.to_nat].
simpl_nonptr_sizeof.
repeat progress cancel.
change (Pos.to_nat 4) with 4%nat.
cbn [store_undef_array_rec].
repeat rewrite Z.add_0_r.
repeat rewrite Z.mul_1_r.
split_pure_spatial.
- repeat progress cancel.
cbn [Z.add].
repeat progress cancel.
change (Z.pos (1+1)) with 2.
change (Z.pos (1+1+1)) with 3.
repeat progress cancel.
- split_pures; dump_pre_spatial; reflexivity.
}
assert (Hslot : forall b i e, dataqueue_slot b i e |-- CharArray.undef_full (b+i*8) 8).
{
intros b i e.
unfold dataqueue_slot.
destruct dataqueue_layout_abi as [_ [_ Hlayout]].
specialize (Hlayout (b+i*8)).
destruct Hlayout as [_ [_ [_ [_ [_ [_ [Hd Hl]]]]]]].
rewrite Hd,Hl.
destruct e as [e|].
- sep_apply_l_atomic (store_ptr_undef_store_ptr (b+i*8) (dq_data e)).
sep_apply_l_atomic (store_uint_undef_store_uint (b+i*8+4) (dq_length e)).
sep_apply_l_atomic (Hptr (b+i*8)).
sep_apply_l_atomic (Huint (b+i*8)).
sep_apply_l_atomic (Huint (b+i*8+4)).
sep_apply_r_atomic (CharArray.undef_full_merge_to_undef_full (b+i*8) 4 8 ltac:(lia)).
simpl_nonptr_sizeof.
change (8-4) with 4.
change (4*1) with 4.
repeat progress cancel.
- sep_apply_l_atomic (Hptr (b+i*8)).
sep_apply_l_atomic (Huint (b+i*8)).
sep_apply_l_atomic (Huint (b+i*8+4)).
sep_apply_r_atomic (CharArray.undef_full_merge_to_undef_full (b+i*8) 4 8 ltac:(lia)).
simpl_nonptr_sizeof.
change (8-4) with 4.
change (4*1) with 4.
repeat progress cancel.
}
assert (Harr : forall l b i n, store_array_rec dataqueue_slot b i n l |-- CharArray.undef_full (b+i*8) ((n-i)*8)).
{
induction l as [|e l IH]; intros b i n.
- cbn [store_array_rec].
Intros_p H.
subst n.
replace ((i-i)*8) with 0 by lia.
rewrite CharArray.undef_full_empty.
repeat progress cancel.
Intros_p Hnil.
cancel.
- cbn [store_array_rec].
prop_apply_p (store_array_rec_valid (option DataqueueElem) dataqueue_slot b (i+1) n l).
Intros_p Hn.
sep_apply_l_atomic (Hslot b i e).
sep_apply_l_atomic (IH b (i+1) n).
sep_apply_r_atomic (CharArray.undef_full_merge_to_undef_full (b+i*8) 8 ((n-i)*8) ltac:(lia)).
simpl_nonptr_sizeof.
replace (b+i*8+8*1) with (b+(i+1)*8) by lia.
replace ((n-i)*8-8) with ((n-(i+1))*8) by lia.
repeat progress cancel.
}
unfold store_dataqueue, dataqueue_fields, dataqueue_buffer.
Intros_p Hp.
destruct (Z.eq_dec (dq_base q_init_cleanup) 0) as [Hz|Hnz].
- Intros_p Hnil.
Left.
Exists (dq_sem_data q_init_cleanup) (dq_sem_blank q_init_cleanup) (dq_base q_init_cleanup) (dq_max_len q_init_cleanup) (dq_rear q_init_cleanup) (dq_front q_init_cleanup).
simpl_nonptr_sizeof.
change (6*1) with 6.
split_pure_spatial.
+ repeat progress cancel.
cancel (CharArray.undef_full (p_queue+6) 2).
repeat progress cancel.
+ split_pures; dump_pre_spatial; tauto.
- Intros_p Hbuf.
Right.
Exists (dq_sem_data q_init_cleanup) (dq_sem_blank q_init_cleanup) (dq_base q_init_cleanup) (dq_max_len q_init_cleanup) (dq_rear q_init_cleanup) (dq_front q_init_cleanup).
unfold store_array.
sep_apply_l_atomic (Harr (dq_slots q_init_cleanup) (dq_base q_init_cleanup) 0 (dq_max_len q_init_cleanup)).
replace (dq_base q_init_cleanup+0*8) with (dq_base q_init_cleanup) by lia.
replace ((dq_max_len q_init_cleanup-0)*8) with (dq_max_len q_init_cleanup*8) by lia.
simpl_nonptr_sizeof.
change (6*1) with 6.
split_pure_spatial.
+ cancel (CharArray.undef_full (p_queue+6) 2).
cancel (CharArray.undef_full (dq_base q_init_cleanup) (dq_max_len q_init_cleanup*8)).
repeat progress cancel.
+ split_pures; dump_pre_spatial; tauto.
Qed.

