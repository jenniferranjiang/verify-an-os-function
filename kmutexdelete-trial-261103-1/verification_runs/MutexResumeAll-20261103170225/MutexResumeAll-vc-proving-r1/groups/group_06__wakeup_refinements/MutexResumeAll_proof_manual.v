Require Import Coq.ZArith.ZArith.
Require Import Coq.Bool.Bool.
Require Import Coq.Strings.String.
Require Import Coq.Strings.Ascii.
Require Import Coq.Lists.List.
Require Import Coq.Classes.RelationClasses.
Require Import Coq.Classes.Morphisms.
Require Import Coq.micromega.Psatz.
Require Import Coq.Sorting.Permutation.
From AUXLib Require Import int_auto Axioms Feq Idents ListLib VMap.
Require Import SetsClass.SetsClass. Import SetsNotation.
From SimpleC.SL Require Import Mem SeparationLogic.
From KMutexDeleteProof.VC Require Import MutexResumeAll_goal.
From KMutexDeleteProof.VC Require Import MutexResumeAll_proof_auto.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.lib.IdModuleSpec.
Require Import CRTOS_Verify.lib.KTaskWakeup.
Require Import CRTOS_Verify.lib.DoubleLinkListSpec CRTOS_Verify.lib.TaskStatusMemory CRTOS_Verify.lib.KTaskParseInfo.
Import IDNode DLL.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.KMutexDelete.
Require Import KMutexDeleteProof.VC.MutexResumeAll_lib.
Local Open Scope sac.


Lemma proof_of_LinklistResumeAll_safety_wit_1 : LinklistResumeAll_safety_wit_1.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_safety_wit_2 : LinklistResumeAll_safety_wit_2.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_safety_wit_3 : LinklistResumeAll_safety_wit_3.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_safety_wit_4 : LinklistResumeAll_safety_wit_4.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_safety_wit_5 : LinklistResumeAll_safety_wit_5.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_safety_wit_6 : LinklistResumeAll_safety_wit_6.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_safety_wit_7 : LinklistResumeAll_safety_wit_7.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_safety_wit_8 : LinklistResumeAll_safety_wit_8.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_safety_wit_9 : LinklistResumeAll_safety_wit_9.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_safety_wit_10 : LinklistResumeAll_safety_wit_10.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_safety_wit_11 : LinklistResumeAll_safety_wit_11.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_entail_wit_1 : LinklistResumeAll_entail_wit_1.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_entail_wit_2 : LinklistResumeAll_entail_wit_2.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_1_pure : LinklistResumeAll_partial_solve_wit_1_pure.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_1 : LinklistResumeAll_partial_solve_wit_1.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_2_pure : LinklistResumeAll_partial_solve_wit_2_pure.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_2 : LinklistResumeAll_partial_solve_wit_2.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_3_pure : LinklistResumeAll_partial_solve_wit_3_pure.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_3 : LinklistResumeAll_partial_solve_wit_3.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_4 : LinklistResumeAll_partial_solve_wit_4.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_5 : LinklistResumeAll_partial_solve_wit_5.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_6_pure : LinklistResumeAll_partial_solve_wit_6_pure.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_6 : LinklistResumeAll_partial_solve_wit_6.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_7_pure : LinklistResumeAll_partial_solve_wit_7_pure.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_7 : LinklistResumeAll_partial_solve_wit_7.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_8_pure : LinklistResumeAll_partial_solve_wit_8_pure.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_8 : LinklistResumeAll_partial_solve_wit_8.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_9 : LinklistResumeAll_partial_solve_wit_9.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_10 : LinklistResumeAll_partial_solve_wit_10.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_11_pure : LinklistResumeAll_partial_solve_wit_11_pure.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_11 : LinklistResumeAll_partial_solve_wit_11.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_12 : LinklistResumeAll_partial_solve_wit_12.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_13 : LinklistResumeAll_partial_solve_wit_13.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_14_pure : LinklistResumeAll_partial_solve_wit_14_pure.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_14 : LinklistResumeAll_partial_solve_wit_14.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_15_pure : LinklistResumeAll_partial_solve_wit_15_pure.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_15 : LinklistResumeAll_partial_solve_wit_15.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_16_pure : LinklistResumeAll_partial_solve_wit_16_pure.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_16 : LinklistResumeAll_partial_solve_wit_16.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_entail_wit_3 : LinklistResumeAll_entail_wit_3.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_entail_wit_4_1 : LinklistResumeAll_entail_wit_4_1.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_entail_wit_4_2 : LinklistResumeAll_entail_wit_4_2.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_return_wit_1_split_goal_1 : LinklistResumeAll_return_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_return_wit_1 : LinklistResumeAll_return_wit_1.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_1 : LinklistResumeAll_which_implies_wit_1.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_2 : LinklistResumeAll_which_implies_wit_2.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_3_split_goal_spatial : LinklistResumeAll_which_implies_wit_3_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_which_implies_wit_3 : LinklistResumeAll_which_implies_wit_3.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_4 : LinklistResumeAll_which_implies_wit_4.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_5_split_goal_spatial : LinklistResumeAll_which_implies_wit_5_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_which_implies_wit_5 : LinklistResumeAll_which_implies_wit_5.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_6_split_goal_spatial : LinklistResumeAll_which_implies_wit_6_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_which_implies_wit_6 : LinklistResumeAll_which_implies_wit_6.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_7 : LinklistResumeAll_which_implies_wit_7.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_8_split_goal_spatial : LinklistResumeAll_which_implies_wit_8_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_which_implies_wit_8 : LinklistResumeAll_which_implies_wit_8.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_1 : LinklistResumeAll_which_implies_wit_9_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_2 : LinklistResumeAll_which_implies_wit_9_split_goal_2.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_3 : LinklistResumeAll_which_implies_wit_9_split_goal_3.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_which_implies_wit_9 : LinklistResumeAll_which_implies_wit_9.
Proof. Admitted. 

Lemma proof_of_KTaskWakeup_derive_semaphore_pending_head_ic_by_wakeup_by_id_ic : KTaskWakeup_derive_semaphore_pending_head_ic_by_wakeup_by_id_ic.
Proof.
 LLM_pre_process ltac:(lia || int_auto).
 rename before_semaphore_pending_head_ic into before.
 rename sg_semaphore_pending_head_ic into sg.
 rename sem_semaphore_pending_head_ic into sem.
 rename task_semaphore_pending_head_ic into target.
 rename rest_semaphore_pending_head_ic into rest.
 prop_apply_p (source_facts__wakeup_refinements sg before). Intros_p Hfacts.
 destruct Hfacts as [Hwf [Haddr Hunique]].
 prop_apply_p (pending_desc__wakeup_refinements sg before sem target rest H1).
 Intros_p Hdesc. destruct Hdesc as [old [Hold Hsuspend]].
 Exists sg before. split_pure_spatial.
 - cancel (os_inv sg before). apply_sepcon_adjoint. Split.
   + Intros after desc task retval.
     assert (Heq : task=target) by (eapply Hunique; eauto).
     subst task. rewrite Hold in H4. injection H4 as <-. contradiction.
   + Intros after desc task retval.
     assert (Heq : task=target) by (eapply Hunique; eauto).
     subst task. Exists after desc retval.
     assert (Hspecial : wakeup_semaphore_head sem target desc before after /\
       semaphore_pending_nodes sem after rest).
     { eapply general_wakeup_semaphore_refinement__wakeup_refinements; eauto. }
     destruct Hspecial as [Hwake Hpending].
     split_pure_spatial; [cancel (os_inv sg after)|split_pures; dump_pre_spatial; assumption].
 - dump_pre_spatial. exact H.
Qed. 

Lemma proof_of_KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic : KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic.
Proof.
 LLM_pre_process ltac:(lia || int_auto).
 rename before_detached_sched_null_delay into before.
 rename sg_detached_sched_null_delay into sg.
 prop_apply_p (os_pure__wakeup_refinements sg before). Intros_p Hwf.
 Exists sg before. split_pure_spatial.
 - cancel (os_inv sg before). apply_sepcon_adjoint. Split.
   + Intros after desc task retval. Left. Exists after desc task retval.
     pose proof (H0 task desc H2 H3) as [Hd Howned].
     split_pure_spatial; [cancel (os_inv sg after)|split_pures; dump_pre_spatial; assumption].
   + Intros after desc task retval. Right. Exists after desc task retval.
     pose proof (H0 task desc H2 H3) as [Hd Howned].
     assert (Hstep : ktask_wakeup_detached_null_step task desc before after).
     { eapply general_wakeup_detached_refinement__wakeup_refinements; eauto. }
     split_pure_spatial; [cancel (os_inv sg after)|split_pures; dump_pre_spatial; assumption].
 - dump_pre_spatial. exact H.
Qed.
