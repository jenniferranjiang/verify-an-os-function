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
Proof.
 LLM_pre_process ltac:(lia || int_auto).
 subst list_pre.
 set (head := semaphore_pending_head sem_semaphore_waiters) in *.
 sep_apply_l_atomic (pending_borrow__pending_head sg_semaphore_waiters current sem_semaphore_waiters (map sched_link_node remaining) PreH3). fold head.
 unfold store_dll at 1. Intros h pt.
 destruct remaining as [|first tail].
 - cbn [map dllseg]. Intros. destruct H0 as [Hh Hpt]. subst h pt.
   Left. Exists (head).
   unfold resume_next_restore. split_pure_spatial.
   + cancel (&((head) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> head).
     apply_sepcon_adjoint.
     sep_apply_r_atomic (derivable1_wand_elim1 (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks current))) (head) nil) (os_inv sg_semaphore_waiters current)).
     cancel (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks current))) (head) nil -* os_inv sg_semaphore_waiters current).
     unfold store_dll. Exists (head) (head).
     cbn [dllseg]. split_pure_spatial; [sepcon_right_assoc; cancel|split_pures; dump_pre_spatial; tauto].
   + split_pures; dump_pre_spatial; auto.
 - cbn [map dllseg sched_link_node getPtr getData].
   Intros z. subst h.
   destruct (Z.eq_dec (sched_link_of first) head) as [Heq|Hneq].
   + rewrite Heq.
     sep_apply_l_atomic (dup_store_ptr (&(head # "SysDoubleLinklistNode" ->ₛ "node_next")) z head).
     Intros. contradiction.
   + Right. Exists (sched_link_of first) first tail.
     unfold resume_next_restore. split_pure_spatial.
     * cancel (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> sched_link_of first).
       apply_sepcon_adjoint.
       sep_apply_r_atomic (derivable1_wand_elim1 (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks current))) head (sched_link_node first :: map sched_link_node tail)) (os_inv sg_semaphore_waiters current)).
       cancel (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks current))) head (sched_link_node first :: map sched_link_node tail) -* os_inv sg_semaphore_waiters current).
       unfold store_dll. Exists (sched_link_of first) pt.
       cbn [dllseg sched_link_node getPtr getData]. Exists z.
       split_pure_spatial; [sepcon_right_assoc; cancel|split_pures; dump_pre_spatial; tauto].
     * split_pures; dump_pre_spatial; auto.
Qed.

Lemma proof_of_LinklistResumeAll_which_implies_wit_2_split_goal_spatial : LinklistResumeAll_which_implies_wit_2_split_goal_spatial.
Proof.
 LLM_pre_process ltac:(lia || int_auto).
 unfold resume_next_restore. apply derivable1_wand_elim2.
Qed.

Lemma proof_of_LinklistResumeAll_which_implies_wit_2 : LinklistResumeAll_which_implies_wit_2.
Proof.
 aggressive_pre_process.
 Goal_apply proof_of_LinklistResumeAll_which_implies_wit_2_split_goal_spatial.
Qed.

Lemma proof_of_LinklistResumeAll_which_implies_wit_3 : LinklistResumeAll_which_implies_wit_3.
Proof.
 LLM_pre_process ltac:(lia || int_auto).
 subst remaining next.
 prop_apply_p (pending_desc__pending_head sg_semaphore_waiters current sem_semaphore_waiters target (map sched_link_node rest) PreH3).
 Intros_p Hdesc. destruct Hdesc as [desc [Hlookup Hstatus]].
 prop_apply_p (task_alignment__pending_head sg_semaphore_waiters current target desc Hlookup).
 Intros_p Halign.
 Exists desc.
 split_pure_spatial.
 - cancel (os_inv sg_semaphore_waiters current).
 - split_pures; dump_pre_spatial; try reflexivity; try assumption.
Qed.

Lemma proof_of_LinklistResumeAll_which_implies_wit_4_split_goal_spatial : LinklistResumeAll_which_implies_wit_4_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_which_implies_wit_4 : LinklistResumeAll_which_implies_wit_4.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_5_split_goal_spatial : LinklistResumeAll_which_implies_wit_5_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_which_implies_wit_5 : LinklistResumeAll_which_implies_wit_5.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_6 : LinklistResumeAll_which_implies_wit_6.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_7_split_goal_spatial : LinklistResumeAll_which_implies_wit_7_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_which_implies_wit_7 : LinklistResumeAll_which_implies_wit_7.
Proof. Admitted.

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
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_10 : LinklistResumeAll_partial_solve_wit_10.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_11 : LinklistResumeAll_partial_solve_wit_11.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_12 : LinklistResumeAll_partial_solve_wit_12.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_13_pure : LinklistResumeAll_partial_solve_wit_13_pure.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_13 : LinklistResumeAll_partial_solve_wit_13.
Proof. Admitted.
