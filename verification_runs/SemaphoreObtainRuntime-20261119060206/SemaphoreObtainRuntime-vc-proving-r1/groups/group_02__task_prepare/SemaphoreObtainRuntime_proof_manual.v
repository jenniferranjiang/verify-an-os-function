From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.semaphore Require Import SemaphoreObtainRuntime_goal.
From CRTOS_Verify.VC.semaphore Require Import SemaphoreObtainRuntime_proof_auto.
Require Import CRTOS_Verify.lib.id.IdModuleSpec.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreDelete CRTOS_Verify.lib.delay.KTaskUnSetDelay.
Require Import CRTOS_Verify.lib.list.DoubleLinkListSpec CRTOS_Verify.lib.task.TaskStatusMemory CRTOS_Verify.lib.task.KTaskParseInfo.
Import IDNode DLL.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreAbandon.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreObtain.
Local Open Scope sac.

Lemma proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_1 : _SemaphoreObtain_entail_wit_1_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_2 : _SemaphoreObtain_entail_wit_1_1_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_1_1 : _SemaphoreObtain_entail_wit_1_1.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_1 : _SemaphoreObtain_entail_wit_1_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_2 : _SemaphoreObtain_entail_wit_1_2_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_1_2 : _SemaphoreObtain_entail_wit_1_2.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_1 : _SemaphoreObtain_entail_wit_1_3_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_2 : _SemaphoreObtain_entail_wit_1_3_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_3 : _SemaphoreObtain_entail_wit_1_3_split_goal_3.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_1_3 : _SemaphoreObtain_entail_wit_1_3.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_1 : _SemaphoreObtain_entail_wit_3_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_2 : _SemaphoreObtain_entail_wit_3_1_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_spatial : _SemaphoreObtain_entail_wit_3_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_3_1 : _SemaphoreObtain_entail_wit_3_1.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_1 : _SemaphoreObtain_entail_wit_3_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_2 : _SemaphoreObtain_entail_wit_3_2_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_spatial : _SemaphoreObtain_entail_wit_3_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_3_2 : _SemaphoreObtain_entail_wit_3_2.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_4 : _SemaphoreObtain_entail_wit_4.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_5_split_goal_1 : _SemaphoreObtain_entail_wit_5_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_5_split_goal_2 : _SemaphoreObtain_entail_wit_5_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_5_split_goal_spatial : _SemaphoreObtain_entail_wit_5_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_5 : _SemaphoreObtain_entail_wit_5.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_6_split_goal_1 : _SemaphoreObtain_entail_wit_6_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_6_split_goal_2 : _SemaphoreObtain_entail_wit_6_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_6 : _SemaphoreObtain_entail_wit_6.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_7_split_goal_1 : _SemaphoreObtain_entail_wit_7_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_7_split_goal_2 : _SemaphoreObtain_entail_wit_7_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_7 : _SemaphoreObtain_entail_wit_7.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hvalid : orb (semaphore_id_invalid id_pre)
      (andb (Z.ltb msec_pre 0) (negb (Z.eqb msec_pre (-1)))) = false).
  { unfold semaphore_id_invalid.
    repeat match goal with |- context [Z.ltb ?x ?y] => destruct (Z.ltb_spec x y) end;
    repeat match goal with |- context [Z.eqb ?x ?y] => destruct (Z.eqb_spec x y) end;
    simpl; try lia; reflexivity. }
  assert (Hentry : semaphore_obtain_entry sg_semaphore_obtain_oc id_pre
      (semaphore_wait_ticks msec_pre) (Crtos_RTrans before_semaphore_obtain_oc)).
  { destruct PreH24 as [states [Hstates Hsafe]].
    unfold LastSeen in Hstates.
    unfold safe, abs_semaphore_obtain in Hsafe.
    rewrite Hvalid in Hsafe.
    rewrite wp_bind, wp_assertS in Hsafe.
    destruct Hsafe as [Hentry _].
    unfold semaphore_obtain_entry in Hentry |- *.
    intros obs Hobs. apply Hentry.
    apply (proj2 (Hstates obs)). exact Hobs. }
  pose proof (Hentry held PreH23) as Hguard.
  prop_apply_p Hguard. Intros_p Hg.
  specialize (Hg original PreH17 PreH18 PreH4).
  assert (Hnz : semaphore_wait_ticks msec_pre <> 0) by lia.
  specialize (Hg Hnz). destruct Hg as [Ha Hfuture].
  split_pure_spatial; [repeat progress cancel |].
  split_pures; dump_pre_spatial; try assumption.
  rewrite PreH10. exact Hfuture.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_8 : _SemaphoreObtain_entail_wit_8.
Proof. LLM_pre_process ltac:(lia || int_auto). Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_9_split_goal_1 : _SemaphoreObtain_entail_wit_9_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  unfold linklist_suspend_admissible in *.
  destruct PreH18 as [d [Hd Hadm]].
  rewrite <- PreH10 in Hd, Hadm.
  rewrite PreH12 in Hd. inversion Hd; subst d.
  exists (set_task_desc_exstatus desc 0).
  unfold semaphore_clear_status, replace_task_desc_map; simpl.
  split.
  - unfold update_task_desc_map. destruct (Z.eq_dec task task); congruence.
  - intros _. specialize (Hadm ltac:(auto)).
    unfold ktask_not_os_service in *. simpl in *. rewrite <- PreH10. exact Hadm.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_9_split_goal_2 : _SemaphoreObtain_entail_wit_9_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial. unfold semaphore_pending_nodes.
  exists original. unfold semaphore_clear_status, replace_task_desc_map; simpl.
  repeat split; auto; congruence.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_9_split_goal_3 : _SemaphoreObtain_entail_wit_9_split_goal_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_9_split_goal_spatial : _SemaphoreObtain_entail_wit_9_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  sep_apply_r_atomic (derivable1_wand_elim1
    (store_int (&(task # "TaskDescriptor" ->ₛ "exstatus")) 0)
    (os_inv sg_semaphore_obtain_oc (semaphore_clear_status task desc held))).
  repeat progress cancel.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_9 : _SemaphoreObtain_entail_wit_9.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreObtain_entail_wit_9_split_goal_spatial.
  - Goal_apply proof_of__SemaphoreObtain_entail_wit_9_split_goal_1.
  - Goal_apply proof_of__SemaphoreObtain_entail_wit_9_split_goal_2.
  - Goal_apply proof_of__SemaphoreObtain_entail_wit_9_split_goal_3.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_10 : _SemaphoreObtain_entail_wit_10.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  pose proof PreH2 as Hprio.
  unfold linklist_suspend_prio, linklist_suspend_step in Hprio.
  destruct Hprio as [[Hbad _]|[_ [_ [staged [ignored [Hs Henq]]]]]]; [tauto|].
  unfold linklist_semaphore_enqueue in Henq.
  destruct Henq as [obj [sd [nodes [Hi [Ha [Hlookup [Hstat [Howned [Hins Hafter]]]]]]]]].
  assert (Hlookupafter : task_desc_map (os_tasks after) task = Some sd).
  { rewrite Hafter. unfold replace_sched_owned_tasks, semaphore_enqueue_state,
      replace_semaphores. simpl. exact Hlookup. }
  Exists sd after.
  split_pure_spatial; [repeat progress cancel|].
  split_pures; dump_pre_spatial; try assumption.
  rewrite <- PreH10, <- PreH13 in PreH19.
  exact (PreH19 desc after sd PreH12 PreH2 Hlookupafter).
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_11 : _SemaphoreObtain_entail_wit_11.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_12_1_split_goal_1 : _SemaphoreObtain_entail_wit_12_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_12_1_split_goal_spatial : _SemaphoreObtain_entail_wit_12_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_12_1 : _SemaphoreObtain_entail_wit_12_1.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_12_2_split_goal_1 : _SemaphoreObtain_entail_wit_12_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_12_2_split_goal_spatial : _SemaphoreObtain_entail_wit_12_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_12_2 : _SemaphoreObtain_entail_wit_12_2.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_13_1_split_goal_1 : _SemaphoreObtain_entail_wit_13_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_13_1_split_goal_2 : _SemaphoreObtain_entail_wit_13_1_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_13_1 : _SemaphoreObtain_entail_wit_13_1.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_13_2_split_goal_1 : _SemaphoreObtain_entail_wit_13_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_13_2_split_goal_2 : _SemaphoreObtain_entail_wit_13_2_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_13_2 : _SemaphoreObtain_entail_wit_13_2.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_14_1 : _SemaphoreObtain_entail_wit_14_1.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_14_2 : _SemaphoreObtain_entail_wit_14_2.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_14_3 : _SemaphoreObtain_entail_wit_14_3.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_15_split_goal_1 : _SemaphoreObtain_entail_wit_15_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_15 : _SemaphoreObtain_entail_wit_15.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_16 : _SemaphoreObtain_entail_wit_16.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_17_split_goal_1 : _SemaphoreObtain_entail_wit_17_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_17_split_goal_2 : _SemaphoreObtain_entail_wit_17_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_17_split_goal_spatial : _SemaphoreObtain_entail_wit_17_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_17 : _SemaphoreObtain_entail_wit_17.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_return_wit_6_split_goal_1 : _SemaphoreObtain_return_wit_6_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_return_wit_6 : _SemaphoreObtain_return_wit_6.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_return_wit_7_split_goal_1 : _SemaphoreObtain_return_wit_7_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_return_wit_7 : _SemaphoreObtain_return_wit_7.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_return_wit_8_split_goal_1 : _SemaphoreObtain_return_wit_8_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_return_wit_8 : _SemaphoreObtain_return_wit_8.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_partial_solve_wit_19_pure_split_goal_1 : _SemaphoreObtain_partial_solve_wit_19_pure_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_partial_solve_wit_19_pure : _SemaphoreObtain_partial_solve_wit_19_pure.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_which_implies_wit_1_split_goal_spatial : _SemaphoreObtain_which_implies_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_which_implies_wit_1 : _SemaphoreObtain_which_implies_wit_1.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_which_implies_wit_2_split_goal_spatial : _SemaphoreObtain_which_implies_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_which_implies_wit_2 : _SemaphoreObtain_which_implies_wit_2.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_which_implies_wit_3_split_goal_spatial : _SemaphoreObtain_which_implies_wit_3_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_which_implies_wit_3 : _SemaphoreObtain_which_implies_wit_3.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_which_implies_wit_4 : _SemaphoreObtain_which_implies_wit_4.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_which_implies_wit_6_split_goal_spatial : _SemaphoreObtain_which_implies_wit_6_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_which_implies_wit_6 : _SemaphoreObtain_which_implies_wit_6.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_which_implies_wit_7_split_goal_spatial : _SemaphoreObtain_which_implies_wit_7_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv. Intros_p Hworld.
  assert (Hassign : assign_ptr (os_assign_stable sg_semaphore_obtain_oc) = &("Assign")).
  { pose proof (os_wf_context _ _ Hworld) as Hctx.
    unfold os_global_context, assign_context in Hctx; tauto. }
  unfold assign_inv. Intros_p Hawf. rewrite Hassign.
  csimpl. cancel (store_ptr (&(&("Assign") ->ₛ "os_running_task")) (assignRunningTask (os_assign held))). apply_sepcon_adjoint.
  split_pure_spatial; [repeat progress cancel|].
  split_pures; dump_pre_spatial; assumption.
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_7 : _SemaphoreObtain_which_implies_wit_7.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreObtain_which_implies_wit_7_split_goal_spatial.
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_8_split_goal_spatial : _SemaphoreObtain_which_implies_wit_8_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  sep_apply_r_atomic (derivable1_wand_elim1
    (store_ptr (&(&("Assign") ->ₛ "os_running_task")) task)
    (os_inv sg_semaphore_obtain_oc held)).
  cancel.
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_8 : _SemaphoreObtain_which_implies_wit_8.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreObtain_which_implies_wit_8_split_goal_spatial.
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_10 : _SemaphoreObtain_which_implies_wit_10.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_which_implies_wit_11_split_goal_spatial : _SemaphoreObtain_which_implies_wit_11_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_which_implies_wit_11 : _SemaphoreObtain_which_implies_wit_11.
Proof. Admitted.

