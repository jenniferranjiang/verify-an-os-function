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
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hentry : dataqueue_peak_entry sg p_queue_pre (Crtos_RTrans before)).
  { destruct PreH2 as [states [Hstates Hsafe]].
    unfold LastSeen in Hstates.
    unfold safe, abs_pop_dataqueue in Hsafe.
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
  Exists q observed. split_pure_spatial.
  - sepcon_assoc_change; cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed.

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
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst retval. exact (PreH5 after 0 PreH2).
Qed.

Lemma proof_of_PopDataqueue_entail_wit_3 : PopDataqueue_entail_wit_3.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_PopDataqueue_entail_wit_3_split_goal_1.
Qed.

Lemma proof_of_PopDataqueue_entail_wit_4 : PopDataqueue_entail_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hpopready : forall q, dataqueue_ready q -> dq_front q <> dq_rear q -> dataqueue_ready (dataqueue_pop q)).
  { clear. intros q Hready Hne.
    destruct Hready as [Hmax [Hb [Hf [Hr [Hlen [Hsb [Hsd [Hdiff Hcontent]]]]]]]].
    assert (Hnewf : 0 <= (dq_front q + 1) mod dq_max_len q < dq_max_len q) by (apply Z.mod_pos_bound; lia).
    assert (Hcount : dataqueue_count (dataqueue_pop q) = dataqueue_count q - 1 /\ 0 < dataqueue_count q).
    { unfold dataqueue_count, dataqueue_pop; cbn [dq_front dq_rear dq_max_len].
      destruct (Z.eq_dec (dq_front q + 1) (dq_max_len q)) as [Hwrap|Hnowrap].
      - rewrite Hwrap, Z.mod_same by lia.
        replace (dq_rear q - 0 + dq_max_len q) with (dq_rear q + 1 * dq_max_len q) by lia.
        rewrite Z.mod_add by lia. rewrite Z.mod_small by lia.
        rewrite Z.mod_small by lia. lia.
      - rewrite (Z.mod_small (dq_front q+1) (dq_max_len q)) by lia.
        destruct (Z_lt_ge_dec (dq_rear q) (dq_front q)).
        + rewrite !Z.mod_small by lia. lia.
        + replace (dq_rear q - (dq_front q+1) + dq_max_len q) with (dq_rear q-dq_front q-1+1*dq_max_len q) by lia.
          replace (dq_rear q - dq_front q + dq_max_len q) with (dq_rear q-dq_front q+1*dq_max_len q) by lia.
          rewrite !Z.mod_add by lia. rewrite !Z.mod_small by lia. lia. }
    assert (Hnatcount : Z.to_nat (dataqueue_count q) = S (Z.to_nat (dataqueue_count (dataqueue_pop q)))).
    { apply Nat2Z.inj. rewrite Nat2Z.inj_succ. rewrite !Z2Nat.id by lia. lia. }
    unfold dataqueue_ready. cbn [dataqueue_pop dq_base dq_max_len dq_front dq_rear dq_slots dq_sem_blank dq_sem_data].
    repeat split; try tauto; try lia.
    rewrite Forall_forall in Hcontent |- *.
    intros item Hin. unfold dataqueue_contents in Hin.
    apply in_map_iff in Hin as [k [Heq Hk]].
    apply in_seq in Hk.
    apply Hcontent. unfold dataqueue_contents.
    apply in_map_iff. exists (S k). split.
    - subst item. cbn [dataqueue_pop dq_front dq_max_len dq_slots].
      rewrite Nat2Z.inj_succ.
      rewrite Z.add_mod_idemp_l by lia.
      f_equal. f_equal. f_equal. lia.
    - apply in_seq. rewrite Hnatcount. lia.
  }
  assert (Hentry : dataqueue_peak_entry sg p_queue_pre (Crtos_RTrans after_get)).
  { destruct PreH3 as [states [Hstates Hsafe]].
    unfold LastSeen in Hstates.
    unfold safe, dataqueue_pop_after_obtain in Hsafe.
    destruct (Z.eq_dec 0 0); [|contradiction].
    rewrite wp_bind, wp_assertS in Hsafe.
    destruct Hsafe as [Hentry _].
    unfold dataqueue_peak_entry in Hentry |- *.
    intros obs Hobs. apply Hentry.
    apply (proj2 (Hstates obs)). exact Hobs. }
  pose proof (Hentry observed PreH1) as Hguard.
  prop_apply_p Hguard. Intros_p Hg. destruct Hg as [q Hq].
  assert (Hfacts : os_inv sg observed |-- “ dataqueue_ready q /\ dataqueue_semaphores (os_semaphores observed) q ”).
  { unfold os_inv, dataqueue_inv. Intros. dump_pre_spatial.
    match goal with H : forall p q, _ p = Some q -> _ |- _ => exact (H _ _ Hq) end. }
  prop_apply_p Hfacts. Intros_p Hfacts'. destruct Hfacts' as [Hready Hsem].
  pose proof Hready as Hbounds.
  destruct Hbounds as [Hmax [Hb [Hf Hrest]]].
  destruct (Z.eq_dec (dq_front q) (dq_rear q)) as [Heq|Hne].
  - Right.
    assert (Hfocus : os_inv sg observed |-- store_dataqueue p_queue_pre q **
      (store_dataqueue p_queue_pre q -* os_inv sg observed)).
    { remember (store_dataqueue p_queue_pre q -* os_inv sg observed) as W eqn:HW.
      unfold os_inv at 1. unfold dataqueue_inv at 1. Intros.
      sep_apply_l_atomic (store_map_split store_dataqueue p_queue_pre q
        (dataqueue_map (os_dataqueues observed)) Hq).
      cancel (store_dataqueue p_queue_pre q).
      subst W. apply_sepcon_adjoint.
      sep_apply_l_atomic (store_map_merge store_dataqueue p_queue_pre q
        (dataqueue_map (os_dataqueues observed)) Hq).
      unfold os_inv, dataqueue_inv.
      split_pure_spatial; [sepcon_assoc_change; cancel | split_pures; dump_pre_spatial; assumption]. }
    sep_apply_l_atomic Hfocus. Exists q observed.
    split_pure_spatial; [sepcon_assoc_change; cancel | split_pures; dump_pre_spatial; auto; lia].
  - Left.
    assert (Hupdate : forall (sg : StableGlobalState) (st : VarGlobalState) p q qnew,
      dataqueue_map (os_dataqueues st) p = Some q ->
      dataqueue_ready qnew -> dataqueue_semaphores (os_semaphores st) qnew ->
      os_inv sg st |-- store_dataqueue p q **
       (store_dataqueue p qnew -* os_inv sg (replace_dataqueues (dataqueue_publish p qnew (os_dataqueues st)) st))).
    { clear. intros sg st p q qnew Hlook Hready Hsem.
      remember (store_dataqueue p qnew -* os_inv sg (replace_dataqueues (dataqueue_publish p qnew (os_dataqueues st)) st)) as W eqn:HW.
      unfold os_inv at 1. unfold dataqueue_inv at 1. Intros.
      sep_apply_l_atomic (store_map_split store_dataqueue p q (dataqueue_map (os_dataqueues st)) Hlook).
      cancel (store_dataqueue p q). subst W. apply_sepcon_adjoint.
      unfold os_inv, dataqueue_inv. cbn [replace_dataqueues].
      split_pure_spatial.
      - assert (Htf : forall sg st qs, task_inv sg st |-- task_inv sg (replace_dataqueues qs st)).
        { clear. intros sg st qs. unfold task_inv. Intros_p Htw.
          split_pure_spatial.
          - cbn [replace_dataqueues]. repeat progress cancel.
            unfold replace_dataqueues. cbn.
            cancel (store_map store_published_task (task_desc_map (os_tasks st))).
            repeat progress cancel.
          - dump_pre_spatial. destruct Htw. constructor; cbn; assumption. }
        sep_apply_l_atomic (Htf sg st (dataqueue_publish p qnew (os_dataqueues st))).
        cancel (task_inv sg (replace_dataqueues (dataqueue_publish p qnew (os_dataqueues st)) st)).
        change (tick_inv sg (replace_dataqueues (dataqueue_publish p qnew (os_dataqueues st)) st)) with (tick_inv sg st).
        change (delay_inv sg (replace_dataqueues (dataqueue_publish p qnew (os_dataqueues st)) st)) with (delay_inv sg st).
        change (assign_inv sg (replace_dataqueues (dataqueue_publish p qnew (os_dataqueues st)) st)) with (assign_inv sg st).
        change (exstatus_inv sg (replace_dataqueues (dataqueue_publish p qnew (os_dataqueues st)) st)) with (exstatus_inv sg st).
        cbv beta iota zeta delta [replace_dataqueues os_tasks zombie_queue os_recycle os_idle os_isr os_semaphores os_mutexes os_events os_dataqueues].
        sepcon_assoc_change. repeat progress cancel.
        fold (os_dataqueues st).
        set (oldm := dataqueue_map (os_dataqueues st)).
        set (newm := dataqueue_map (dataqueue_publish p qnew (os_dataqueues st))).
        assert (Hnew : newm p = Some qnew).
        { unfold newm,dataqueue_publish. cbn [dataqueue_map]. destruct (Z.eq_dec p p); [reflexivity|contradiction]. }
        assert (Hmaps : forall key, key <> p -> oldm key = newm key).
        { intros key Hneq. unfold oldm,newm,dataqueue_publish. cbn [dataqueue_map].
          destruct (Z.eq_dec key p); [contradiction|reflexivity]. }
        rewrite (store_map_missing_i_equiv store_dataqueue oldm newm p Hmaps).
        sep_apply_l_atomic (store_map_merge store_dataqueue p qnew newm Hnew).
        cancel.
      - split_pures; dump_pre_spatial.
        + destruct H.
          assert (Hsf : forall st qs entry slot, service_slot_wf st entry slot -> service_slot_wf (replace_dataqueues qs st) entry slot).
          { clear. intros st qs entry slot Hw. unfold service_slot_wf in *.
            destruct (service_phase slot); try assumption.
            destruct Hw as [desc Hw]. exists desc. destruct Hw. constructor; assumption. }
          constructor.
          * exact os_wf_context.
          * change (os_recycle (replace_dataqueues (dataqueue_publish p qnew (os_dataqueues st)) st)) with (os_recycle st).
            apply Hsf. exact os_wf_recycler.
          * change (os_idle (replace_dataqueues (dataqueue_publish p qnew (os_dataqueues st)) st)) with (os_idle st).
            eapply Forall_impl; [|exact os_wf_idle]. intros slot Hw. apply Hsf. exact Hw.
          * change (NoDup (os_sched_owners st)). exact os_wf_sched_nodup.
          * change (forall task, In task (os_sched_owners st) <-> task_desc_map (os_tasks st) task <> None). exact os_wf_sched_domain.
        + intros key v Hv. change (dataqueue_map (dataqueue_publish p qnew (os_dataqueues st)) key = Some v) in Hv.
          unfold dataqueue_publish in Hv. cbn [dataqueue_map] in Hv.
          destruct (Z.eq_dec key p).
          * inversion Hv; subst; auto.
          * eapply H0; eauto.
    }
    sep_apply_l_atomic (Hupdate sg observed p_queue_pre q (dataqueue_pop q) Hq (Hpopready q Hready Hne) Hsem).
    Exists q observed.
    split_pure_spatial; [sepcon_assoc_change; cancel | split_pures; dump_pre_spatial; auto; lia].
Qed.

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
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst result new_data new_length.
  Right. Exists after_4 item.
  split_pure_spatial.
  - repeat progress cancel.
  - split_pures; dump_pre_spatial; try reflexivity.
    exact (PreH8 after_4 retval PreH1).
Qed.

Lemma proof_of_PopDataqueue_return_wit_2 : PopDataqueue_return_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst result new_data new_length.
  Left. Exists after_4.
  split_pure_spatial.
  - repeat progress cancel.
  - split_pures; dump_pre_spatial; try reflexivity.
    exact (PreH8 after_4 retval PreH1).
Qed.

Lemma proof_of_PopDataqueue_return_wit_3_split_goal_1 : PopDataqueue_return_wit_3_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  specialize (PreH5 after_4 retval PreH2).
  unfold dataqueue_pop_after_obtain in PreH5.
  prog_nf in PreH5.
  destruct (Z.eq_dec retval 0); [lia | exact PreH5].
Qed.

Lemma proof_of_PopDataqueue_return_wit_3 : PopDataqueue_return_wit_3.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_PopDataqueue_return_wit_3_split_goal_1.
Qed.

Lemma proof_of_PopDataqueue_which_implies_wit_1_split_goal_1 : PopDataqueue_which_implies_wit_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold store_dataqueue. Intros. dump_pre_spatial. tauto.
Qed.

Lemma proof_of_PopDataqueue_which_implies_wit_1_split_goal_2 : PopDataqueue_which_implies_wit_1_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold store_dataqueue. Intros. dump_pre_spatial. tauto.
Qed.

Lemma proof_of_PopDataqueue_which_implies_wit_1_split_goal_spatial : PopDataqueue_which_implies_wit_1_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold store_dataqueue, dataqueue_fields. Intros. change (6 * sizeof(CHAR)) with 6. csimpl. sepcon_assoc_change. cancel.
Qed.

Lemma proof_of_PopDataqueue_which_implies_wit_1 : PopDataqueue_which_implies_wit_1.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of_PopDataqueue_which_implies_wit_1_split_goal_spatial.
  - Goal_apply proof_of_PopDataqueue_which_implies_wit_1_split_goal_1.
  - Goal_apply proof_of_PopDataqueue_which_implies_wit_1_split_goal_2.
Qed.

Lemma proof_of_PopDataqueue_which_implies_wit_2_split_goal_1 : PopDataqueue_which_implies_wit_2_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold store_dataqueue. Intros. dump_pre_spatial. tauto.
Qed.

Lemma proof_of_PopDataqueue_which_implies_wit_2_split_goal_2 : PopDataqueue_which_implies_wit_2_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold store_dataqueue. Intros. dump_pre_spatial. tauto.
Qed.

Lemma proof_of_PopDataqueue_which_implies_wit_2_split_goal_spatial : PopDataqueue_which_implies_wit_2_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold store_dataqueue, dataqueue_fields. Intros. change (6 * sizeof(CHAR)) with 6. csimpl. sepcon_assoc_change. cancel.
Qed.

Lemma proof_of_PopDataqueue_which_implies_wit_2 : PopDataqueue_which_implies_wit_2.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of_PopDataqueue_which_implies_wit_2_split_goal_spatial.
  - Goal_apply proof_of_PopDataqueue_which_implies_wit_2_split_goal_1.
  - Goal_apply proof_of_PopDataqueue_which_implies_wit_2_split_goal_2.
Qed.

Lemma proof_of_PopDataqueue_which_implies_wit_3 : PopDataqueue_which_implies_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  pose proof PreH1 as Hready.
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
  split_pure_spatial; [|split_pures; dump_pre_spatial; tauto].
  cancel (dataqueue_slot (dq_base q) (dq_front q) (Some e)).
  apply_sepcon_adjoint.
  sep_apply_l_atomic (store_array_missing_i_merge_to_array (option DataqueueElem) dataqueue_slot
    (dq_base q) (dq_front q) (dq_max_len q) (Some e) (dq_slots q) Hfront).
  rewrite <- Hz.
  rewrite replace_Znth_Znth by (unfold Zlength; lia).
  split_pure_spatial; [cancel | dump_pre_spatial; tauto].
Qed.

Lemma proof_of_PopDataqueue_which_implies_wit_4_split_goal_spatial : PopDataqueue_which_implies_wit_4_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold dataqueue_slot.
  pose proof (proj1 (proj2 dataqueue_layout_abi)) as Hsize.
  unfold KTaskCNotation.sizeof_front_end_type in Hsize.
  unfold sizeof_front_end_type.
  rewrite Hsize.
  cancel.
Qed.

Lemma proof_of_PopDataqueue_which_implies_wit_4 : PopDataqueue_which_implies_wit_4.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_PopDataqueue_which_implies_wit_4_split_goal_spatial.
Qed.

Lemma proof_of_PopDataqueue_which_implies_wit_5 : PopDataqueue_which_implies_wit_5.
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

