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
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_2 : _SemaphoreObtain_entail_wit_1_1_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_1_1 : _SemaphoreObtain_entail_wit_1_1.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_1.
  Goal_apply proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_2.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_1 : _SemaphoreObtain_entail_wit_1_2_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_2 : _SemaphoreObtain_entail_wit_1_2_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_1_2 : _SemaphoreObtain_entail_wit_1_2.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_1.
  Goal_apply proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_2.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_1 : _SemaphoreObtain_entail_wit_1_3_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hq : 0 <= msec_pre * 100 / 1000 <= 214748365).
  { split; [apply Z.div_pos; lia | apply Z.div_le_upper_bound; lia]. }
  assert (Ht : 0 <= tick_from_time_ms msec_pre <= 214748366).
  { unfold tick_from_time_ms. destruct (Z.eq_dec (msec_pre * 100 / 1000) 0); [lia |].
    destruct (andb (Z.leb 5 (msec_pre * 100 mod 1000)) (Z.leb (msec_pre * 100 mod 1000) 9)); lia. }
  rewrite signed_last_nbits_eq by (try (change (-2147483648 <= retval < 2147483648)); lia).
  change (retval < 2147483647). lia.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_2 : _SemaphoreObtain_entail_wit_1_3_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hq : 0 <= msec_pre * 100 / 1000 <= 214748365).
  { split; [apply Z.div_pos; lia | apply Z.div_le_upper_bound; lia]. }
  assert (Ht : 0 <= tick_from_time_ms msec_pre <= 214748366).
  { unfold tick_from_time_ms. destruct (Z.eq_dec (msec_pre * 100 / 1000) 0); [lia |].
    destruct (andb (Z.leb 5 (msec_pre * 100 mod 1000)) (Z.leb (msec_pre * 100 mod 1000) 9)); lia. }
  rewrite signed_last_nbits_eq by (try (change (-2147483648 <= retval < 2147483648)); lia).
  lia.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_3 : _SemaphoreObtain_entail_wit_1_3_split_goal_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hq : 0 <= msec_pre * 100 / 1000 <= 214748365).
  { split; [apply Z.div_pos; lia | apply Z.div_le_upper_bound; lia]. }
  assert (Ht : 0 <= tick_from_time_ms msec_pre <= 214748366).
  { unfold tick_from_time_ms. destruct (Z.eq_dec (msec_pre * 100 / 1000) 0); [lia |].
    destruct (andb (Z.leb 5 (msec_pre * 100 mod 1000)) (Z.leb (msec_pre * 100 mod 1000) 9)); lia. }
  rewrite signed_last_nbits_eq by (try (change (-2147483648 <= retval < 2147483648)); lia).
  unfold semaphore_wait_ticks. destruct (Z.eq_dec msec_pre 0); [lia |].
  destruct (Z.eq_dec msec_pre (-1)); lia.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_1_3 : _SemaphoreObtain_entail_wit_1_3.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_1.
  Goal_apply proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_2.
  Goal_apply proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_3.
Qed.

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
Proof. Abort.

Lemma proof_of__SemaphoreObtain_partial_solve_wit_19_pure : _SemaphoreObtain_partial_solve_wit_19_pure.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_which_implies_wit_1_split_goal_spatial : _SemaphoreObtain_which_implies_wit_1_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_1 : _SemaphoreObtain_which_implies_wit_1.
Proof.
  aggressive_pre_process. Goal_apply proof_of__SemaphoreObtain_which_implies_wit_1_split_goal_spatial.
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_2_split_goal_spatial : _SemaphoreObtain_which_implies_wit_2_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_2 : _SemaphoreObtain_which_implies_wit_2.
Proof.
  aggressive_pre_process. Goal_apply proof_of__SemaphoreObtain_which_implies_wit_2_split_goal_spatial.
Qed.

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

