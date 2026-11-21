From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.dataqueue Require Import PopDataqueue_goal.
From CRTOS_Verify.VC.dataqueue Require Import PopDataqueue_proof_auto.
Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.dataqueue.KPopDataqueue CRTOS_Verify.lib.dataqueue.KPushDataqueue.
Local Open Scope sac.

Lemma proof_of_PopDataqueue_entail_wit_1 : PopDataqueue_entail_wit_1.
Proof. Admitted.

Lemma proof_of_PopDataqueue_entail_wit_2 : PopDataqueue_entail_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst p_queue_front p_queue_rear p_queue_max_len p_queue_base p_queue_sem_blank p_queue_sem_data.
  Exists (fun status => weakestpre (dataqueue_pop_after_obtain sg p_queue_pre status) X).
  split_pure_spatial.
  - rewrite sizeof_char. replace (6 * 1) with 6 by lia.
    sepcon_assoc_change.
    sep_apply_r_atomic (derivable1_wand_elim1 (store_dataqueue p_queue_pre q_id) (os_inv sg seen_id)).
    cancel (store_dataqueue p_queue_pre q_id -* os_inv sg seen_id).
    unfold store_dataqueue, dataqueue_fields.
    split_pure_spatial.
    + sepcon_assoc_change. cancel.
    + split_pures; dump_pre_spatial; auto.
  - split_pures; dump_pre_spatial.
    + reflexivity.
    + unfold abs_pop_dataqueue in PreH10 at 1.
      prog_nf in PreH10.
      destruct PreH10 as [states [Hseen Hwp]].
      unfold safe in Hwp.
      rewrite wp_bind, wp_assertS in Hwp.
      destruct Hwp as [_ Hwp].
      exists (Crtos_RTrans seen_id). split; [unfold LastSeen; reflexivity|].
      unfold safe. rewrite <- wp_bind.
      change (weakestpre (dataqueue_pop_after_id sg p_queue_pre timeout_pre (dq_sem_data q_id)) X (Crtos_RTrans seen_id)).
      apply (proj1 (wp_bind (os_atomic_cmd (abs_dataqueue_pop_id p_queue_pre)) (dataqueue_pop_after_id sg p_queue_pre timeout_pre) X states)) in Hwp.
      eapply (wp_spec (os_atomic_cmd (abs_dataqueue_pop_id p_queue_pre)) states (Crtos_RTrans seen_id) (dq_sem_data q_id)) with (Q := fun id => weakestpre (dataqueue_pop_after_id sg p_queue_pre timeout_pre id) X); [|exact Hwp].
      cbn [os_atomic_cmd abs_dataqueue_pop_id MonadErr.nrm].
      exists seen_id, seen_id. split.
      * apply Hseen. exact PreH9.
      * split.
        -- split; [reflexivity|]. exists q_id; auto.
        -- reflexivity.
    + intros st status [states [Hseen Hwp]].
      exists states. split; [exact Hseen|].
      unfold safe in Hwp |- *.
      exact (proj1 (wp_ret status (fun r => weakestpre (dataqueue_pop_after_obtain sg p_queue_pre r) X) states) Hwp).
Qed.

Lemma proof_of_PopDataqueue_entail_wit_3_split_goal_1 : PopDataqueue_entail_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of_PopDataqueue_entail_wit_3 : PopDataqueue_entail_wit_3.
Proof. Admitted.

Lemma proof_of_PopDataqueue_entail_wit_4 : PopDataqueue_entail_wit_4.
Proof. Admitted.

Lemma proof_of_PopDataqueue_entail_wit_5_1 : PopDataqueue_entail_wit_5_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst p_queue_front p_queue_rear p_queue_max_len p_queue_base p_queue_sem_blank p_queue_sem_data.
  set (updated := replace_dataqueues (dataqueue_publish p_queue_pre (dataqueue_pop q) (os_dataqueues seen_ring)) seen_ring).
  Left.
  Exists updated (fun (_ : Z) => weakestpre (ret (DqPopItem e)) X) (Some (dq_length e)) (Some (dq_data e)) e (DqPopItem e).
  split_pure_spatial.
  - rewrite sizeof_char. replace (6 * 1) with 6 by lia.
    rewrite Z.rem_mod_nonneg by lia.
    rewrite unsigned_last_nbits_eq by (change (0 <= (dq_front q + 1) mod dq_max_len q < 65536); pose proof (Z.mod_pos_bound (dq_front q + 1) (dq_max_len q) PreH17); lia).
    sepcon_assoc_change.
    sep_apply_r_atomic (derivable1_wand_elim1 (store_dataqueue p_queue_pre (dataqueue_pop q)) (os_inv sg updated)).
    cancel (store_dataqueue p_queue_pre (dataqueue_pop q) -* os_inv sg updated).
    unfold store_dataqueue, dataqueue_fields.
    unfold peak_data_slot, peak_length_slot.
    cbn [dataqueue_pop dq_front dq_rear dq_max_len dq_base dq_sem_blank dq_sem_data].
    change (dataqueue_buffer (dataqueue_pop q)) with (dataqueue_buffer q).
    split_pure_spatial.
    + sepcon_assoc_change. cancel.
      sep_apply_r_atomic (derivable1_wand_elim1 (dataqueue_slot (dq_base q) (dq_front q) (Some e)) (dataqueue_buffer q)).
      cancel (dataqueue_slot (dq_base q) (dq_front q) (Some e) -* dataqueue_buffer q).
      unfold dataqueue_slot.
      pose proof dataqueue_layout_abi as Hlayout.
      destruct Hlayout as [_ [Helem _]].
      unfold KTaskCNotation.sizeof_front_end_type in Helem.
      unfold sizeof_front_end_type. rewrite Helem.
      sepcon_assoc_change. cancel.
    + split_pures; dump_pre_spatial; auto.
  - split_pures; dump_pre_spatial; try reflexivity; try assumption.
    + change (safeExec (LastSeen after_get)
        (assertS (dataqueue_peak_entry sg p_queue_pre) ;;
         r <- os_atomic_cmd (abs_dataqueue_pop_ring p_queue_pre);;
         dataqueue_pop_after_ring sg r) X) in PreH14.
      destruct PreH14 as [states [Hseen Hwp]].
      unfold safe in Hwp. rewrite wp_bind, wp_assertS in Hwp.
      destruct Hwp as [_ Hwp].
      apply (proj1 (wp_bind (os_atomic_cmd (abs_dataqueue_pop_ring p_queue_pre)) (dataqueue_pop_after_ring sg) X states)) in Hwp.
      exists (Crtos_RTrans updated). split; [unfold LastSeen; reflexivity|].
      unfold safe. rewrite <- wp_bind.
      change (weakestpre (dataqueue_pop_after_ring sg (dq_sem_blank q, Some e)) X (Crtos_RTrans updated)).
      eapply (wp_spec (os_atomic_cmd (abs_dataqueue_pop_ring p_queue_pre)) states (Crtos_RTrans updated) (dq_sem_blank q, Some e)) with (Q := fun r => weakestpre (dataqueue_pop_after_ring sg r) X); [|exact Hwp].
      cbn [os_atomic_cmd abs_dataqueue_pop_ring MonadErr.nrm].
      exists seen_ring, updated. split.
      * apply Hseen. exact PreH13.
      * split.
        -- exists q. split; [exact PreH15|]. split; [reflexivity|]. right. split; [exact PreH21|]. exists e; auto.
        -- reflexivity.
    + intros st status [states [Hseen Hwp]].
      exists states. split; [exact Hseen|].
      unfold safe in Hwp |- *.
      exact (proj1 (wp_ret status (fun (_ : Z) => weakestpre (ret (DqPopItem e)) X) states) Hwp).
Qed.

Lemma proof_of_PopDataqueue_entail_wit_5_2 : PopDataqueue_entail_wit_5_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst p_queue_front p_queue_rear p_queue_max_len p_queue_base p_queue_sem_blank p_queue_sem_data.
  Right.
  Exists seen_ring (fun (_ : Z) => weakestpre (ret DqPopEmpty) X) old_length old_data DqPopEmpty.
  split_pure_spatial.
  - rewrite sizeof_char. replace (6 * 1) with 6 by lia.
    sepcon_assoc_change.
    sep_apply_r_atomic (derivable1_wand_elim1 (store_dataqueue p_queue_pre q) (os_inv sg seen_ring)).
    cancel (store_dataqueue p_queue_pre q -* os_inv sg seen_ring).
    unfold store_dataqueue, dataqueue_fields.
    split_pure_spatial.
    + sepcon_assoc_change. cancel. rewrite PreH19. cancel.
    + split_pures; dump_pre_spatial; auto.
  - split_pures; dump_pre_spatial; try reflexivity; try assumption.
    + change (safeExec (LastSeen after_get)
        (assertS (dataqueue_peak_entry sg p_queue_pre) ;;
         r <- os_atomic_cmd (abs_dataqueue_pop_ring p_queue_pre);;
         dataqueue_pop_after_ring sg r) X) in PreH12.
      destruct PreH12 as [states [Hseen Hwp]].
      unfold safe in Hwp. rewrite wp_bind, wp_assertS in Hwp.
      destruct Hwp as [_ Hwp].
      apply (proj1 (wp_bind (os_atomic_cmd (abs_dataqueue_pop_ring p_queue_pre)) (dataqueue_pop_after_ring sg) X states)) in Hwp.
      exists (Crtos_RTrans seen_ring). split; [unfold LastSeen; reflexivity|].
      unfold safe. rewrite <- wp_bind.
      change (weakestpre (dataqueue_pop_after_ring sg (dq_sem_blank q, None)) X (Crtos_RTrans seen_ring)).
      eapply (wp_spec (os_atomic_cmd (abs_dataqueue_pop_ring p_queue_pre)) states (Crtos_RTrans seen_ring) (dq_sem_blank q, None)) with (Q := fun r => weakestpre (dataqueue_pop_after_ring sg r) X); [|exact Hwp].
      cbn [os_atomic_cmd abs_dataqueue_pop_ring MonadErr.nrm].
      exists seen_ring, seen_ring. split.
      * apply Hseen. exact PreH11.
      * split.
        -- exists q. split; [exact PreH13|]. split; [reflexivity|]. left; auto.
        -- reflexivity.
    + intros st status [states [Hseen Hwp]].
      exists states. split; [exact Hseen|].
      unfold safe in Hwp |- *.
      exact (proj1 (wp_ret status (fun (_ : Z) => weakestpre (ret DqPopEmpty) X) states) Hwp).
Qed.

Lemma proof_of_PopDataqueue_return_wit_1 : PopDataqueue_return_wit_1.
Proof. Admitted.

Lemma proof_of_PopDataqueue_return_wit_2 : PopDataqueue_return_wit_2.
Proof. Admitted.

Lemma proof_of_PopDataqueue_return_wit_3_split_goal_1 : PopDataqueue_return_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of_PopDataqueue_return_wit_3 : PopDataqueue_return_wit_3.
Proof. Admitted.

Lemma proof_of_PopDataqueue_which_implies_wit_1_split_goal_1 : PopDataqueue_which_implies_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of_PopDataqueue_which_implies_wit_1_split_goal_2 : PopDataqueue_which_implies_wit_1_split_goal_2.
Proof. Abort.

Lemma proof_of_PopDataqueue_which_implies_wit_1_split_goal_spatial : PopDataqueue_which_implies_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of_PopDataqueue_which_implies_wit_1 : PopDataqueue_which_implies_wit_1.
Proof. Admitted.

Lemma proof_of_PopDataqueue_which_implies_wit_2_split_goal_1 : PopDataqueue_which_implies_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of_PopDataqueue_which_implies_wit_2_split_goal_2 : PopDataqueue_which_implies_wit_2_split_goal_2.
Proof. Abort.

Lemma proof_of_PopDataqueue_which_implies_wit_2_split_goal_spatial : PopDataqueue_which_implies_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of_PopDataqueue_which_implies_wit_2 : PopDataqueue_which_implies_wit_2.
Proof. Admitted.

Lemma proof_of_PopDataqueue_which_implies_wit_3 : PopDataqueue_which_implies_wit_3.
Proof. Admitted.

Lemma proof_of_PopDataqueue_which_implies_wit_4_split_goal_spatial : PopDataqueue_which_implies_wit_4_split_goal_spatial.
Proof. Abort.

Lemma proof_of_PopDataqueue_which_implies_wit_4 : PopDataqueue_which_implies_wit_4.
Proof. Admitted.

Lemma proof_of_PopDataqueue_which_implies_wit_5 : PopDataqueue_which_implies_wit_5.
Proof. Admitted.

