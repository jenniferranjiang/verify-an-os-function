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
Proof.
LLM_pre_process ltac:(lia || int_auto).

Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_2 : _SemaphoreObtain_entail_wit_3_1_split_goal_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
exfalso. exact (addr_of_LE_var_not_zero "k_sem_id_manager" PreH2).
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_spatial : _SemaphoreObtain_entail_wit_3_1_split_goal_spatial.
Proof.
LLM_pre_process ltac:(lia || int_auto).
sepcon_assoc_change. cancel (InsideCritical sg_semaphore_obtain_oc held). apply derivable1_wand_elim2.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_3_1 : _SemaphoreObtain_entail_wit_3_1.
Proof.
aggressive_pre_process.
Goal_apply proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_spatial.
Goal_apply proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_2.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_1 : _SemaphoreObtain_entail_wit_3_2_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).

Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_2 : _SemaphoreObtain_entail_wit_3_2_split_goal_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
dump_pre_spatial.
unfold abs_semaphore_obtain in PreH15 at 1. prog_nf in PreH15.
assert (Hv : orb (semaphore_id_invalid id_pre) (andb (Z.ltb msec_pre 0) (negb (Z.eqb msec_pre (-1)))) = false).
{ unfold semaphore_id_invalid. apply Bool.orb_false_iff. split.
  - apply Bool.orb_false_iff. split; apply Z.ltb_ge; lia.
  - destruct (Z.ltb_spec msec_pre 0); simpl; [assert (msec_pre = -1) by lia; subst; reflexivity|reflexivity]. }
rewrite Hv in PreH15.
destruct PreH15 as [states [Hstates Hsafe]].
unfold safe in Hsafe.
apply (proj1 (wp_bind _ _ _ states)) in Hsafe.
apply (proj1 (wp_assertS _ _ states)) in Hsafe.
destruct Hsafe as [Hentry Hsafe].
apply (proj1 (wp_bind _ _ _ states)) in Hsafe.
pose proof (wp_spec (task_atomic_cmd (abs_semaphore_obtain_locked id_pre (semaphore_wait_ticks msec_pre))) states (Crtos_RTrans held) (inl (-1))) as Hstep.
assert (Hnormal : MonadErr.nrm (task_atomic_cmd (abs_semaphore_obtain_locked id_pre (semaphore_wait_ticks msec_pre))) states (inl (-1)) (Crtos_RTrans held)).
{ exists held, held. split; [apply (proj2 (Hstates held)); exact PreH14|]. split; [|reflexivity].
  left. split; [|auto]. intros sm Hin Heq.
  unfold idmanager_query, semaphore_manager in PreH4. cbn in PreH4.
  apply id_in_ids_false_iff in PreH4. apply PreH4. rewrite <- Heq. apply in_map. exact Hin. }
specialize (Hstep Hnormal _ Hsafe).
exists (Crtos_RTrans held). split; [unfold LastSeen; reflexivity|exact Hstep].
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_spatial : _SemaphoreObtain_entail_wit_3_2_split_goal_spatial.
Proof.
LLM_pre_process ltac:(lia || int_auto).
sepcon_assoc_change. cancel (InsideCritical sg_semaphore_obtain_oc held). apply derivable1_wand_elim2.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_3_2 : _SemaphoreObtain_entail_wit_3_2.
Proof.
aggressive_pre_process.
Goal_apply proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_spatial.
Goal_apply proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_2.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_4 : _SemaphoreObtain_entail_wit_4.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_5_split_goal_1 : _SemaphoreObtain_entail_wit_5_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).

Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_5_split_goal_2 : _SemaphoreObtain_entail_wit_5_split_goal_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
rewrite PreH3. dump_pre_spatial.
unfold abs_semaphore_obtain in PreH22 at 1. prog_nf in PreH22.
assert (Hv : orb (semaphore_id_invalid id_pre) (andb (Z.ltb msec_pre 0) (negb (Z.eqb msec_pre (-1)))) = false).
{ unfold semaphore_id_invalid. apply Bool.orb_false_iff. split.
  - apply Bool.orb_false_iff. split; apply Z.ltb_ge; lia.
  - destruct (Z.ltb_spec msec_pre 0); simpl; [assert (msec_pre = -1) by lia; subst; reflexivity|reflexivity]. }
rewrite Hv in PreH22.
destruct PreH22 as [states [Hstates Hsafe]].
unfold safe in Hsafe.
apply (proj1 (wp_bind _ _ _ states)) in Hsafe.
apply (proj1 (wp_assertS _ _ states)) in Hsafe.
destruct Hsafe as [Hentry Hsafe].
apply (proj1 (wp_bind _ _ _ states)) in Hsafe.
pose proof (wp_spec (task_atomic_cmd (abs_semaphore_obtain_locked id_pre (semaphore_wait_ticks msec_pre))) states (Crtos_RTrans (replace_semaphores (semaphore_set_value (semaphore_addr original) (semaphore_value original-1) (os_semaphores held)) held)) (inl 0)) as Hstep.
assert (Hnormal : MonadErr.nrm (task_atomic_cmd (abs_semaphore_obtain_locked id_pre (semaphore_wait_ticks msec_pre))) states (inl 0) (Crtos_RTrans (replace_semaphores (semaphore_set_value (semaphore_addr original) (semaphore_value original-1) (os_semaphores held)) held))).
{ exists held, (replace_semaphores (semaphore_set_value (semaphore_addr original) (semaphore_value original-1) (os_semaphores held)) held).
  split; [apply (proj2 (Hstates held)); exact PreH21|]. split; [|reflexivity].
  right. exists original. split; [exact PreH15|]. split; [exact PreH16|]. left. repeat split; auto. }
specialize (Hstep Hnormal _ Hsafe).
exists (Crtos_RTrans (replace_semaphores (semaphore_set_value (semaphore_addr original) (semaphore_value original-1) (os_semaphores held)) held)). split; [unfold LastSeen; reflexivity|exact Hstep].
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_5_split_goal_spatial : _SemaphoreObtain_entail_wit_5_split_goal_spatial.
Proof.
LLM_pre_process ltac:(lia || int_auto).
sepcon_assoc_change. cancel (InsideCritical sg_semaphore_obtain_oc held). apply derivable1_wand_elim2.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_5 : _SemaphoreObtain_entail_wit_5.
Proof.
aggressive_pre_process.
Goal_apply proof_of__SemaphoreObtain_entail_wit_5_split_goal_spatial.
Goal_apply proof_of__SemaphoreObtain_entail_wit_5_split_goal_2.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_6_split_goal_1 : _SemaphoreObtain_entail_wit_6_split_goal_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_6_split_goal_2 : _SemaphoreObtain_entail_wit_6_split_goal_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
unfold abs_semaphore_obtain in PreH23 at 1. prog_nf in PreH23.
assert (Hv : orb (semaphore_id_invalid id_pre) (andb (Z.ltb msec_pre 0) (negb (Z.eqb msec_pre (-1)))) = false).
{ unfold semaphore_id_invalid. apply Bool.orb_false_iff. split.
  - apply Bool.orb_false_iff. split; apply Z.ltb_ge; lia.
  - destruct (Z.ltb_spec msec_pre 0); simpl; [assert (msec_pre = -1) by lia; subst; reflexivity|reflexivity]. }
rewrite Hv in PreH23.
destruct PreH23 as [states [Hstates Hsafe]].
unfold safe in Hsafe.
apply (proj1 (wp_bind _ _ _ states)) in Hsafe.
apply (proj1 (wp_assertS _ _ states)) in Hsafe.
destruct Hsafe as [Hentry Hsafe].
apply (proj1 (wp_bind _ _ _ states)) in Hsafe.
pose proof (wp_spec (task_atomic_cmd (abs_semaphore_obtain_locked id_pre (semaphore_wait_ticks msec_pre))) states (Crtos_RTrans held) (inl (-2))) as Hstep.
assert (Hnormal : MonadErr.nrm (task_atomic_cmd (abs_semaphore_obtain_locked id_pre (semaphore_wait_ticks msec_pre))) states (inl (-2)) (Crtos_RTrans held)).
{ exists held, held. split; [apply (proj2 (Hstates held)); exact PreH22|]. split; [|reflexivity].
  right. exists original. repeat split; auto. right. split; [exact PreH3|]. left. repeat split; auto; lia. }
specialize (Hstep Hnormal _ Hsafe).
exists (Crtos_RTrans held). split; [unfold LastSeen; reflexivity|exact Hstep].
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_6 : _SemaphoreObtain_entail_wit_6.
Proof.
aggressive_pre_process.
Goal_apply proof_of__SemaphoreObtain_entail_wit_6_split_goal_2.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_7_split_goal_1 : _SemaphoreObtain_entail_wit_7_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_7_split_goal_2 : _SemaphoreObtain_entail_wit_7_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_7 : _SemaphoreObtain_entail_wit_7.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_8 : _SemaphoreObtain_entail_wit_8.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_9_split_goal_1 : _SemaphoreObtain_entail_wit_9_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_9_split_goal_2 : _SemaphoreObtain_entail_wit_9_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_9_split_goal_3 : _SemaphoreObtain_entail_wit_9_split_goal_3.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_9_split_goal_spatial : _SemaphoreObtain_entail_wit_9_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_9 : _SemaphoreObtain_entail_wit_9.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_10 : _SemaphoreObtain_entail_wit_10.
Proof. Admitted.

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
Proof.
LLM_pre_process ltac:(lia || int_auto).

Qed.

Lemma proof_of__SemaphoreObtain_partial_solve_wit_19_pure : _SemaphoreObtain_partial_solve_wit_19_pure.
Proof.
aggressive_pre_process.
Goal_apply proof_of__SemaphoreObtain_partial_solve_wit_19_pure_split_goal_1.
Qed.

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
Proof. Abort.

Lemma proof_of__SemaphoreObtain_which_implies_wit_7 : _SemaphoreObtain_which_implies_wit_7.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_which_implies_wit_8_split_goal_spatial : _SemaphoreObtain_which_implies_wit_8_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_which_implies_wit_8 : _SemaphoreObtain_which_implies_wit_8.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_which_implies_wit_10 : _SemaphoreObtain_which_implies_wit_10.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_which_implies_wit_11_split_goal_spatial : _SemaphoreObtain_which_implies_wit_11_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_which_implies_wit_11 : _SemaphoreObtain_which_implies_wit_11.
Proof. Admitted.

