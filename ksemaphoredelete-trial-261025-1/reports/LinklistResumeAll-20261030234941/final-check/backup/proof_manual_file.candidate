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
Proof.
 LLM_pre_process ltac:(lia || int_auto).
 prop_apply_p (steps_to_effect__steps_effect sg_semaphore_waiters sem_semaphore_waiters
   waiting_semaphore_waiters before_semaphore_waiters PreH3).
 Intros_p Hsteps.
 Exists before_semaphore_waiters waiting_semaphore_waiters.
 split_pure_spatial.
 - sep_apply_l_atomic (store_ptr_undef_store_ptr (&("task")) 0).
   sep_apply_l_atomic (store_ptr_undef_store_ptr (&("node")) 0).
   sep_apply_l_atomic (store_uint_undef_store_uint (&("lock")) 0).
   cancel.
 - split_pures; dump_pre_spatial; assumption.
Qed. 

Lemma proof_of_LinklistResumeAll_entail_wit_2 : LinklistResumeAll_entail_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  clear PreH2.
  Exists next_state rest.
  split_pure_spatial.
  - sep_apply_l_atomic (store_ptr_undef_store_ptr (&("task")) retval).
    sep_apply_l_atomic (store_ptr_undef_store_ptr (&("node")) next).
    cancel.
  - split_pures; dump_pre_spatial; try assumption.
    unfold resume_remaining_effect. intros final Htail.
    apply PreH35. rewrite PreH7. simpl.
    exists next_state. split; [|exact Htail].
    destruct PreH8 as [obj [Hin [Haddr Hnodes]]].
    assert (Hpending : semaphore_pending_addrs obj = target :: rest).
    { apply (f_equal (map (@getData addr))) in Hnodes.
      rewrite map_map in Hnodes. simpl in Hnodes.
      rewrite map_id in Hnodes. rewrite map_map in Hnodes.
      simpl in Hnodes. rewrite map_id in Hnodes. exact Hnodes. }
    assert (Hwoke : woke_desc = set_task_desc_exstatus desc (-1)).
    { rewrite PreH9 in PreH3.
      unfold replace_task_desc_map, update_task_desc_map in PreH3.
      simpl in PreH3.
      destruct (Z.eq_dec target target); [congruence|contradiction]. }
    exists obj, desc.
    split; [exact Hin|]. split; [exact Haddr|].
    split; [exact Hpending|]. split; [exact PreH14|].
    split; [exact PreH23|].
    cbv zeta. rewrite <- PreH9, <- Hwoke. exact PreH5.
Qed.

Lemma proof_of_LinklistResumeAll_return_wit_1_split_goal_1 : LinklistResumeAll_return_wit_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst remaining. exact PreH4.
Qed.

Lemma proof_of_LinklistResumeAll_return_wit_1_split_goal_2 : LinklistResumeAll_return_wit_1_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold resume_remaining_effect in PreH10.
  subst remaining.
  apply PreH10. reflexivity.
Qed.

Lemma proof_of_LinklistResumeAll_return_wit_1_split_goal_3 : LinklistResumeAll_return_wit_1_split_goal_3.
Proof.
  LLM_pre_process ltac:(reflexivity).
Qed.

Lemma proof_of_LinklistResumeAll_return_wit_1 : LinklistResumeAll_return_wit_1.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of_LinklistResumeAll_return_wit_1_split_goal_1.
  - Goal_apply proof_of_LinklistResumeAll_return_wit_1_split_goal_2.
  - Goal_apply proof_of_LinklistResumeAll_return_wit_1_split_goal_3.
Qed.

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
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  apply exstatus_focus__exstatus_focus. exact PreH1.
Qed.

Lemma proof_of_LinklistResumeAll_which_implies_wit_4 : LinklistResumeAll_which_implies_wit_4.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_LinklistResumeAll_which_implies_wit_4_split_goal_spatial.
Qed. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_5_split_goal_spatial : LinklistResumeAll_which_implies_wit_5_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold resume_exstatus_restore. apply derivable1_wand_elim2.
Qed.

Lemma proof_of_LinklistResumeAll_which_implies_wit_5 : LinklistResumeAll_which_implies_wit_5.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_LinklistResumeAll_which_implies_wit_5_split_goal_spatial.
Qed. 

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
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_LinklistResumeAll_safety_wit_2 : LinklistResumeAll_safety_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_LinklistResumeAll_safety_wit_3 : LinklistResumeAll_safety_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_LinklistResumeAll_safety_wit_4 : LinklistResumeAll_safety_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_LinklistResumeAll_safety_wit_5 : LinklistResumeAll_safety_wit_5.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_LinklistResumeAll_safety_wit_6 : LinklistResumeAll_safety_wit_6.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_LinklistResumeAll_safety_wit_7 : LinklistResumeAll_safety_wit_7.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_LinklistResumeAll_safety_wit_8 : LinklistResumeAll_safety_wit_8.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_LinklistResumeAll_safety_wit_9 : LinklistResumeAll_safety_wit_9.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_1 : LinklistResumeAll_partial_solve_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_2_pure : LinklistResumeAll_partial_solve_wit_2_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_2 : LinklistResumeAll_partial_solve_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_3 : LinklistResumeAll_partial_solve_wit_3.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_4 : LinklistResumeAll_partial_solve_wit_4.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_5_pure : LinklistResumeAll_partial_solve_wit_5_pure.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_5 : LinklistResumeAll_partial_solve_wit_5.
Proof.
  LLM_pre_process ltac:(auto).
  LLM_pre_process ltac:(auto).
Qed. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_6_pure : LinklistResumeAll_partial_solve_wit_6_pure.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_6 : LinklistResumeAll_partial_solve_wit_6.
Proof.
  LLM_pre_process ltac:(auto).
  LLM_pre_process ltac:(auto).
Qed. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_7_pure : LinklistResumeAll_partial_solve_wit_7_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_7 : LinklistResumeAll_partial_solve_wit_7.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_8 : LinklistResumeAll_partial_solve_wit_8.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  rewrite PreH3. split_pure_spatial.
  - cancel (resume_exstatus_restore sg_semaphore_waiters marked target (-1)).
    apply store_int_undef_store_int.
  - split_pures; dump_pre_spatial; auto.
Qed. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_9 : LinklistResumeAll_partial_solve_wit_9.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  rewrite PreH3. split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; auto.
Qed. 


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
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.


Lemma proof_of_LinklistResumeAll_partial_solve_wit_13 : LinklistResumeAll_partial_solve_wit_13.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold LinklistResumeAll_partial_solve_wit_13_aux. intros.
  split_pure_spatial.
  - cancel (os_inv sg_semaphore_waiters marked).
  - split_pures; dump_pre_spatial; assumption.
Qed.
