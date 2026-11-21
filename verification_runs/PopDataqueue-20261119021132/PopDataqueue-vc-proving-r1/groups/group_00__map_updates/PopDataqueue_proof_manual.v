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
Proof. Admitted.

Lemma proof_of_PopDataqueue_entail_wit_3_split_goal_1 : PopDataqueue_entail_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of_PopDataqueue_entail_wit_3 : PopDataqueue_entail_wit_3.
Proof. Admitted.

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
Proof. Admitted.

Lemma proof_of_PopDataqueue_entail_wit_5_2 : PopDataqueue_entail_wit_5_2.
Proof. Admitted.

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

