From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.semaphore Require Import LinklistResumeSemaphore_goal.
From CRTOS_Verify.VC.semaphore Require Import LinklistResumeSemaphore_proof_auto.
Require Import CRTOS_Verify.lib.id.IdModuleSpec.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreDelete CRTOS_Verify.lib.delay.KTaskUnSetDelay.
Require Import CRTOS_Verify.lib.list.DoubleLinkListSpec CRTOS_Verify.lib.task.TaskStatusMemory CRTOS_Verify.lib.task.KTaskParseInfo.
Import IDNode DLL.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreAbandon.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreObtain.
Import SimpleC.CoreLang.CTypes.SimpleCtypeNotations.
Local Open Scope sac.

Lemma proof_of_LinklistResume_return_wit_1_split_goal_1 : LinklistResume_return_wit_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  match goal with
  | H : semaphore_pending_nodes ?sem ?before (cons (sched_link_node ?first) (map sched_link_node ?rest)) |- semaphore_resume_head_effect ?sem ?before ?after =>
    destruct H as (obj & Hin & Haddr & Hnodes);
    exists obj, first, rest;
    eexists;
    split; [exact Hin|]; split; [exact Haddr|];
    split
  end.
  - pose proof (f_equal (map (@getData Z)) Hnodes) as Hp.
    cbn [map] in Hp.
    rewrite !map_map in Hp.
    change (map (fun x : Z => x) (semaphore_pending_addrs obj) =
      first :: map (fun x : Z => x) rest) in Hp.
    rewrite !map_id in Hp. exact Hp.
  - split; eassumption.
Qed.

Lemma proof_of_LinklistResume_return_wit_1 : LinklistResume_return_wit_1.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_LinklistResume_return_wit_1_split_goal_1.
Qed.

Lemma proof_of_LinklistResume_which_implies_wit_1 : LinklistResume_which_implies_wit_1.
Proof. Admitted.

Lemma proof_of_LinklistResume_which_implies_wit_2_split_goal_spatial : LinklistResume_which_implies_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistResume_which_implies_wit_2 : LinklistResume_which_implies_wit_2.
Proof. Admitted.

Lemma proof_of_LinklistResume_which_implies_wit_3 : LinklistResume_which_implies_wit_3.
Proof. Admitted.

Lemma proof_of_LinklistResume_which_implies_wit_4_split_goal_spatial : LinklistResume_which_implies_wit_4_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistResume_which_implies_wit_4 : LinklistResume_which_implies_wit_4.
Proof. Admitted.

