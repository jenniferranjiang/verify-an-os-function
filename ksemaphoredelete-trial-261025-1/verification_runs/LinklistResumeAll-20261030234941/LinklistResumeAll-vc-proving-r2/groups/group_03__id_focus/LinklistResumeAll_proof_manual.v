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
From CRTOS_Verify.VC Require Import LinklistResumeAll_goal.
From CRTOS_Verify.VC Require Import LinklistResumeAll_proof_auto.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.lib.IdModuleSpec.
Require Import CRTOS_Verify.lib.KSemaphoreDelete CRTOS_Verify.lib.KTaskUnSetDelay.
Require Import CRTOS_Verify.lib.DoubleLinkListSpec CRTOS_Verify.lib.TaskStatusMemory CRTOS_Verify.lib.KTaskParseInfo.
Import IDNode DLL.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.VC.LinklistResumeAll_lib.
Local Open Scope sac.

Lemma proof_of_LinklistResumeAll_entail_wit_1 : LinklistResumeAll_entail_wit_1.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_entail_wit_2 : LinklistResumeAll_entail_wit_2.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_return_wit_1_split_goal_1 : LinklistResumeAll_return_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_return_wit_1_split_goal_2 : LinklistResumeAll_return_wit_1_split_goal_2.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_return_wit_1_split_goal_3 : LinklistResumeAll_return_wit_1_split_goal_3.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_return_wit_1 : LinklistResumeAll_return_wit_1.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_1 : LinklistResumeAll_which_implies_wit_1.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_2_split_goal_spatial : LinklistResumeAll_which_implies_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_which_implies_wit_2 : LinklistResumeAll_which_implies_wit_2.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_3 : LinklistResumeAll_which_implies_wit_3.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_4_split_goal_spatial : LinklistResumeAll_which_implies_wit_4_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_which_implies_wit_4 : LinklistResumeAll_which_implies_wit_4.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_5_split_goal_spatial : LinklistResumeAll_which_implies_wit_5_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_which_implies_wit_5 : LinklistResumeAll_which_implies_wit_5.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_6 : LinklistResumeAll_which_implies_wit_6.
Proof.
 LLM_pre_process ltac:(lia || int_auto).
 assert (Hp : semaphore_pending_nodes sem_semaphore_waiters marked (sched_link_node target :: map sched_link_node rest)).
 { rewrite PreH3. exact PreH2. }
 unfold os_inv at 1. Intros.
 unfold task_inv at 1. Intros.

 pose proof (pending_member__id_focus sg_semaphore_waiters marked sem_semaphore_waiters target rest H H0 Hp) as Ht.
 assert (Haddr : In (&(target # "TaskDescriptor" ->ₛ "id")) (map idnode_addr (task_id_nodes marked))).
 { eapply Permutation_in; [apply Permutation_sym; exact (task_wf_id_nodes marked H0)|].
   apply in_map_iff. exists target. split; [reflexivity|exact Ht]. }
 apply in_map_iff in Haddr. destruct Haddr as [node [Haddr Hnode]].
 unfold store_idmanager at 1. Intros.
 pose proof (bucket_pure__id_focus _ _ node H1 Hnode) as [Hbounds [Hquery Hbucket]].
 unfold store_idbuckets at 1.
 sep_apply_l_atomic (buckets_focus__id_focus (htable (task_stable_ids (os_task_stable sg_semaphore_waiters))) 0 (idbuckets (task_idmanager_abs (os_tasks marked))) node Hnode).
 unfold store_idnode at 1. Intros.
 prop_apply_p (store_ushort_range (&(((idnode_addr node)) # "IdNode" ->ₛ "id")) (idnode_id node)).

 Intros.
 Exists (idnode_id node).
 split_pure_spatial.
 - rewrite Haddr, id_addr__id_focus.
   cancel (&(target # "TaskDescriptor" ->ₛ "id" .ₛ "id") # UShort |-> idnode_id node).
   unfold resume_id_restore.
   apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)).
   rewrite <- id_addr__id_focus, <- Haddr.
   sep_apply_l_atomic (node_close__id_focus node (proj1 H2)).
   sep_apply_l_atomic (derivable1_wand_elim2 (store_idnode (idnode_link node) node)
      (store_idbucket_list (htable (task_stable_ids (os_task_stable sg_semaphore_waiters))) 0 (idbuckets (task_idmanager_abs (os_tasks marked))))).
   unfold os_inv, task_inv, store_idmanager, store_idbuckets.
   split_pure_spatial.
   + cancel (store_idbucket_list (htable (task_stable_ids (os_task_stable sg_semaphore_waiters))) 0 (idbuckets (task_idmanager_abs (os_tasks marked)))). cancel.
   + split_pures; dump_pre_spatial; auto.
 - split_pures; dump_pre_spatial; try assumption; try lia.
   unfold get_task_with_idnode_success.
   split; [exact Hbounds|]. split; [exact Hquery|].
   exists (idnode_addr node). split; [exact Haddr|].
   split; [destruct node; exact Hbucket|exact Ht].
Qed. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_7_split_goal_spatial : LinklistResumeAll_which_implies_wit_7_split_goal_spatial.
Proof. LLM_pre_process ltac:(lia || int_auto). unfold resume_id_restore. apply derivable1_wand_elim2. Qed.

Lemma proof_of_LinklistResumeAll_which_implies_wit_7 : LinklistResumeAll_which_implies_wit_7.
Proof. aggressive_pre_process. Goal_apply proof_of_LinklistResumeAll_which_implies_wit_7_split_goal_spatial. Qed.

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


Lemma proof_of_LinklistResumeAll_partial_solve_wit_1 : LinklistResumeAll_partial_solve_wit_1.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_2_pure : LinklistResumeAll_partial_solve_wit_2_pure.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_2 : LinklistResumeAll_partial_solve_wit_2.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_3 : LinklistResumeAll_partial_solve_wit_3.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_4 : LinklistResumeAll_partial_solve_wit_4.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_5_pure : LinklistResumeAll_partial_solve_wit_5_pure.
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


Lemma proof_of_LinklistResumeAll_partial_solve_wit_8 : LinklistResumeAll_partial_solve_wit_8.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_9 : LinklistResumeAll_partial_solve_wit_9.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_10_pure : LinklistResumeAll_partial_solve_wit_10_pure.
Proof. LLM_pre_process ltac:(lia || int_auto). Qed. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_10 : LinklistResumeAll_partial_solve_wit_10.
Proof. LLM_pre_process ltac:(lia || int_auto). unfold LinklistResumeAll_partial_solve_wit_10_aux. intros. split_pure_spatial. - cancel. - split_pures; dump_pre_spatial; auto. Qed. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_11 : LinklistResumeAll_partial_solve_wit_11.
Proof. LLM_pre_process ltac:(lia || int_auto).
 rewrite PreH10.
 split_pure_spatial.
 - cancel.
 - split_pures; dump_pre_spatial; auto. Qed. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_12 : LinklistResumeAll_partial_solve_wit_12.
Proof. LLM_pre_process ltac:(lia || int_auto).
 rewrite PreH10.
 split_pure_spatial.
 - cancel.
 - split_pures; dump_pre_spatial; auto. Qed. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_13_pure : LinklistResumeAll_partial_solve_wit_13_pure.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_13 : LinklistResumeAll_partial_solve_wit_13.
Proof. Admitted.
