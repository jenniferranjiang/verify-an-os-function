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

Lemma proof_of_LinklistResumeAll_safety_wit_10 : LinklistResumeAll_safety_wit_10.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of_LinklistResumeAll_safety_wit_11 : LinklistResumeAll_safety_wit_11.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of_LinklistResumeAll_entail_wit_1 : LinklistResumeAll_entail_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  split_pure_spatial.
  - cancel (OutsideCritical sg_mutex_waiters_oc before_mutex_waiters_oc).
    sep_apply_l_atomic (store_ptr_undef_store_ptr (&("node")) 0).
    sep_apply_l_atomic (store_ptr_undef_store_ptr (&("task")) 0).
    sep_apply_l_atomic (store_uint_undef_store_uint (&("lock")) 0).
    cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed. 

Lemma proof_of_LinklistResumeAll_entail_wit_2 : LinklistResumeAll_entail_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_1_pure : LinklistResumeAll_partial_solve_wit_1_pure.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_1 : LinklistResumeAll_partial_solve_wit_1.
Proof.
  LLM_pre_process ltac:(auto).
  unfold LinklistResumeAll_partial_solve_wit_1_aux.
  intros.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; auto.
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_2_pure : LinklistResumeAll_partial_solve_wit_2_pure.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_2 : LinklistResumeAll_partial_solve_wit_2.
Proof.
  LLM_pre_process ltac:(auto).
  unfold LinklistResumeAll_partial_solve_wit_2_aux.
  intros.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; auto.
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_3_pure : LinklistResumeAll_partial_solve_wit_3_pure.
Proof.
  LLM_pre_process ltac:(auto).
  all: try cancel.
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_3 : LinklistResumeAll_partial_solve_wit_3.
Proof.
  LLM_pre_process ltac:(auto).
  unfold LinklistResumeAll_partial_solve_wit_3_aux.
  intros.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; auto.
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_4 : LinklistResumeAll_partial_solve_wit_4.
Proof.
  LLM_pre_process ltac:(auto).
  all: try cancel.
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_5 : LinklistResumeAll_partial_solve_wit_5.
Proof.
  LLM_pre_process ltac:(auto).
  all: try cancel.
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_6_pure : LinklistResumeAll_partial_solve_wit_6_pure.
Proof.
  LLM_pre_process ltac:(assumption || reflexivity || lia).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_6 : LinklistResumeAll_partial_solve_wit_6.
Proof.
  LLM_pre_process ltac:(assumption || reflexivity || lia).
  LLM_pre_process ltac:(assumption || reflexivity || lia).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_7_pure : LinklistResumeAll_partial_solve_wit_7_pure.
Proof.
  LLM_pre_process ltac:(assumption || reflexivity || lia).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_7 : LinklistResumeAll_partial_solve_wit_7.
Proof.
  LLM_pre_process ltac:(assumption || reflexivity || lia).
  LLM_pre_process ltac:(assumption || reflexivity || lia).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_8_pure : LinklistResumeAll_partial_solve_wit_8_pure.
Proof.
  LLM_pre_process ltac:(assumption || reflexivity || lia).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_8 : LinklistResumeAll_partial_solve_wit_8.
Proof.
  LLM_pre_process ltac:(assumption || reflexivity || lia).
  LLM_pre_process ltac:(assumption || reflexivity || lia).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_9 : LinklistResumeAll_partial_solve_wit_9.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst retval. split_pure_spatial.
  - sep_apply_l_atomic (store_int_undef_store_int
      (&(target # "TaskDescriptor" ->ₛ "exstatus")) (tdExstatus desc)).
    cancel.
  - split_pures; dump_pre_spatial; auto.
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_10 : LinklistResumeAll_partial_solve_wit_10.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst retval. split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; auto.
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_11_pure : LinklistResumeAll_partial_solve_wit_11_pure.
Proof.
  LLM_pre_process ltac:(auto || lia || int_auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_11 : LinklistResumeAll_partial_solve_wit_11.
Proof.
  LLM_pre_process ltac:(auto || lia || int_auto).
  unfold LinklistResumeAll_partial_solve_wit_11_aux.
  intros.
  split_pure_spatial; [cancel | split_pures; dump_pre_spatial; assumption].
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_12 : LinklistResumeAll_partial_solve_wit_12.
Proof.
 LLM_pre_process ltac:(lia || int_auto).
 all: try subst retval.
 all: split_pure_spatial; [cancel|split_pures; dump_pre_spatial; auto].
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_13 : LinklistResumeAll_partial_solve_wit_13.
Proof.
 LLM_pre_process ltac:(lia || int_auto).
 all: try subst retval.
 all: split_pure_spatial; [cancel|split_pures; dump_pre_spatial; auto].
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_14_pure : LinklistResumeAll_partial_solve_wit_14_pure.
Proof.
  LLM_pre_process ltac:(auto || lia || int_auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_14 : LinklistResumeAll_partial_solve_wit_14.
Proof.
  LLM_pre_process ltac:(auto || lia || int_auto).
  unfold LinklistResumeAll_partial_solve_wit_14_aux.
  intros.
  split_pure_spatial; [cancel | split_pures; dump_pre_spatial; assumption].
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_15_pure : LinklistResumeAll_partial_solve_wit_15_pure.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_15 : LinklistResumeAll_partial_solve_wit_15.
Proof.
  LLM_pre_process ltac:(auto).
  unfold LinklistResumeAll_partial_solve_wit_15_aux; intros.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_16_pure : LinklistResumeAll_partial_solve_wit_16_pure.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_16 : LinklistResumeAll_partial_solve_wit_16.
Proof.
  LLM_pre_process ltac:(auto).
  unfold LinklistResumeAll_partial_solve_wit_16_aux; intros.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed. 

Lemma proof_of_LinklistResumeAll_entail_wit_3 : LinklistResumeAll_entail_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  prop_apply_p (resume_steps_bulk__bulk_initialization sg_mutex_waiters_oc st_lock original PreH1).
  Intros_p Hbulk.
  Exists (mutex_pending_addrs original) st_lock.
  split_pure_spatial.
  - sep_apply_l_atomic (store_ptr_undef_store_ptr (&("task")) 0).
    sep_apply_l_atomic (store_ptr_undef_store_ptr (&("node")) 0).
    cancel.
  - split_pures; dump_pre_spatial; try assumption.
    unfold mutex_resume_remaining_effect. rewrite <- PreH2. exact Hbulk.
Qed. 

Lemma proof_of_LinklistResumeAll_entail_wit_4_1 : LinklistResumeAll_entail_wit_4_1.
Proof.
LLM_pre_process ltac:(lia || int_auto).
subst after.
prop_apply_p (nonsuspend_impossible__loop_step sg_mutex_waiters_oc
  current_2 marked target desc task desc_2 task_id
  PreH21 PreH9 PreH12 PreH2 PreH3 PreH23 PreH4).
Intros_p Hfalse. contradiction. Qed.

Lemma proof_of_LinklistResumeAll_entail_wit_4_2 : LinklistResumeAll_entail_wit_4_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
prop_apply_p (wakeup_head_facts__loop_step sg_mutex_waiters_oc current_2 marked after
  target desc task desc_2 task_id p_mutex_waiters_oc id_mutex_waiters_oc rest
  PreH21 PreH9 PreH12 PreH2 PreH3 PreH39 PreH8 PreH6).
Intros_p Hhead.
destruct Hhead as [Heq [Hdesc [Hlive Hpending]]].
subst task desc_2.
rewrite PreH7 in PreH41.
pose proof (remaining_step__loop_step p_mutex_waiters_oc
  original.(mutex_pending_addrs) st_lock current_2 marked after target rest desc
  PreH14 PreH23 PreH9 PreH8 PreH6 PreH41) as Hremaining.
Exists rest after.
sep_apply_l_atomic (store_ptr_undef_store_ptr (&("task")) retval).
sep_apply_l_atomic (store_ptr_undef_store_ptr (&("node")) next).
split_pure_spatial.
- cancel.
- split_pures; dump_pre_spatial; assumption.
Qed.

Lemma proof_of_LinklistResumeAll_return_wit_1_split_goal_1 : LinklistResumeAll_return_wit_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  all: reflexivity.
Qed.

Lemma proof_of_LinklistResumeAll_return_wit_1 : LinklistResumeAll_return_wit_1.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_LinklistResumeAll_return_wit_1_split_goal_1.
Qed. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_1 : LinklistResumeAll_which_implies_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  pose proof PreH1 as Hlive.
  unfold mutex_delete_live in PreH1.
  destruct PreH1 as [Hp [Hid [original [Hin [Haddr Hmid]]]]].
  Exists original.
  split_pure_spatial.
  - cancel (os_inv sg_mutex_waiters_oc st_lock).
  - split_pures; dump_pre_spatial; try assumption.
    unfold mutex_pending_nodes.
    exists original; repeat split; auto.
Qed. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_2 : LinklistResumeAll_which_implies_wit_2.
Proof.
 LLM_pre_process ltac:(lia || int_auto).
 subst list_pre.
 set (head := mutex_pending_head p_mutex_waiters_oc) in *.
 sep_apply_l_atomic (pending_borrow__head_view sg_mutex_waiters_oc current p_mutex_waiters_oc (map sched_link_node remaining) PreH3). fold head.
 unfold store_dll at 1. Intros h pt.
 destruct remaining as [|first tail].
 - cbn [map dllseg]. Intros. destruct H0 as [Hh Hpt]. subst h pt.
   Left. Exists (head).
   unfold mutex_resume_next_restore. split_pure_spatial.
   + cancel (&((head) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> head).
     apply_sepcon_adjoint.
     sep_apply_r_atomic (derivable1_wand_elim1 (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks current))) (head) nil) (os_inv sg_mutex_waiters_oc current)).
     cancel (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks current))) (head) nil -* os_inv sg_mutex_waiters_oc current).
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
     unfold mutex_resume_next_restore. split_pure_spatial.
     * cancel (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> sched_link_of first).
       apply_sepcon_adjoint.
       sep_apply_r_atomic (derivable1_wand_elim1 (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks current))) head (sched_link_node first :: map sched_link_node tail)) (os_inv sg_mutex_waiters_oc current)).
       cancel (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks current))) head (sched_link_node first :: map sched_link_node tail) -* os_inv sg_mutex_waiters_oc current).
       unfold store_dll. Exists (sched_link_of first) pt.
       cbn [dllseg sched_link_node getPtr getData]. Exists z.
       split_pure_spatial; [sepcon_right_assoc; cancel|split_pures; dump_pre_spatial; tauto].
     * split_pures; dump_pre_spatial; auto.
Qed. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_3_split_goal_spatial : LinklistResumeAll_which_implies_wit_3_split_goal_spatial.
Proof.
 LLM_pre_process ltac:(lia || int_auto).
 unfold mutex_resume_next_restore. apply derivable1_wand_elim2.
Qed.

Lemma proof_of_LinklistResumeAll_which_implies_wit_3 : LinklistResumeAll_which_implies_wit_3.
Proof.
 aggressive_pre_process.
 Goal_apply proof_of_LinklistResumeAll_which_implies_wit_3_split_goal_spatial.
Qed. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_4 : LinklistResumeAll_which_implies_wit_4.
Proof.
 LLM_pre_process ltac:(lia || int_auto).
 subst remaining next.
 prop_apply_p (pending_desc__head_view sg_mutex_waiters_oc current p_mutex_waiters_oc target (map sched_link_node rest) PreH3).
 Intros_p Hdesc. destruct Hdesc as [desc [Hlookup Hstatus]].
 prop_apply_p (task_alignment__head_view sg_mutex_waiters_oc current target desc Hlookup).
 Intros_p Halign.
 Exists desc.
 split_pure_spatial.
 - cancel (os_inv sg_mutex_waiters_oc current).
 - split_pures; dump_pre_spatial; try reflexivity; try assumption.
Qed. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_5_split_goal_spatial : LinklistResumeAll_which_implies_wit_5_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  apply (exstatus_focus__exstatus_update sg_mutex_waiters_oc current target desc PreH1).
Qed.

Lemma proof_of_LinklistResumeAll_which_implies_wit_5 : LinklistResumeAll_which_implies_wit_5.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_LinklistResumeAll_which_implies_wit_5_split_goal_spatial.
Qed. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_6_split_goal_spatial : LinklistResumeAll_which_implies_wit_6_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold mutex_resume_exstatus_restore.
  sep_apply_l_atomic (derivable1_wand_elim1
    (&(target # "TaskDescriptor" ->ₛ "exstatus") # Int |-> (-1))
    (os_inv sg_mutex_waiters_oc marked)).
  cancel.
Qed.

Lemma proof_of_LinklistResumeAll_which_implies_wit_6 : LinklistResumeAll_which_implies_wit_6.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_LinklistResumeAll_which_implies_wit_6_split_goal_spatial.
Qed. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_7 : LinklistResumeAll_which_implies_wit_7.
Proof.
 LLM_pre_process ltac:(lia || int_auto).
 assert (Hp : mutex_pending_nodes p_mutex_waiters_oc marked (sched_link_node target :: map sched_link_node rest)).
 { rewrite PreH3. exact PreH2. }
 unfold os_inv at 1. Intros.
 unfold task_inv at 1. Intros.

 pose proof (pending_member__task_id_view sg_mutex_waiters_oc marked p_mutex_waiters_oc target rest H H0 Hp) as Ht.
 assert (Haddr : In (&(target # "TaskDescriptor" ->ₛ "id")) (map idnode_addr (task_id_nodes marked))).
 { eapply Permutation_in; [apply Permutation_sym; exact (task_wf_id_nodes marked H0)|].
   apply in_map_iff. exists target. split; [reflexivity|exact Ht]. }
 apply in_map_iff in Haddr. destruct Haddr as [node [Haddr Hnode]].
 unfold store_idmanager at 1. Intros.
 pose proof (bucket_pure__task_id_view _ _ node H1 Hnode) as [Hbounds [Hquery Hbucket]].
 unfold store_idbuckets at 1.
 sep_apply_l_atomic (buckets_focus__task_id_view (htable (task_stable_ids (os_task_stable sg_mutex_waiters_oc))) 0 (idbuckets (task_idmanager_abs (os_tasks marked))) node Hnode).
 unfold store_idnode at 1. Intros.
 prop_apply_p (store_ushort_range (&(((idnode_addr node)) # "IdNode" ->ₛ "id")) (idnode_id node)).

 Intros.
 Exists (idnode_id node).
 split_pure_spatial.
 - rewrite Haddr, id_addr__task_id_view.
   cancel (&(target # "TaskDescriptor" ->ₛ "id" .ₛ "id") # UShort |-> idnode_id node).
   unfold mutex_resume_id_restore.
   apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)).
   rewrite <- id_addr__task_id_view, <- Haddr.
   sep_apply_l_atomic (node_close__task_id_view node (proj1 H2)).
   sep_apply_l_atomic (derivable1_wand_elim2 (store_idnode (idnode_link node) node)
      (store_idbucket_list (htable (task_stable_ids (os_task_stable sg_mutex_waiters_oc))) 0 (idbuckets (task_idmanager_abs (os_tasks marked))))).
   unfold os_inv, task_inv, store_idmanager, store_idbuckets.
   split_pure_spatial.
   + cancel (store_idbucket_list (htable (task_stable_ids (os_task_stable sg_mutex_waiters_oc))) 0 (idbuckets (task_idmanager_abs (os_tasks marked)))). cancel.
   + split_pures; dump_pre_spatial; auto.
 - split_pures; dump_pre_spatial; try assumption; try lia.
   unfold get_task_with_idnode_success.
   split; [exact Hbounds|]. split; [exact Hquery|].
   exists (idnode_addr node). split; [exact Haddr|].
   split; [destruct node; exact Hbucket|exact Ht].
Qed. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_8_split_goal_spatial : LinklistResumeAll_which_implies_wit_8_split_goal_spatial.
Proof.
 LLM_pre_process ltac:(lia || int_auto).
 unfold mutex_resume_id_restore. apply derivable1_wand_elim2.
Qed.

Lemma proof_of_LinklistResumeAll_which_implies_wit_8 : LinklistResumeAll_which_implies_wit_8.
Proof.
 aggressive_pre_process.
 Goal_apply proof_of_LinklistResumeAll_which_implies_wit_8_split_goal_spatial.
Qed. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_1 : LinklistResumeAll_which_implies_wit_9_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst.
  match goal with
  | Hrem : mutex_resume_remaining_effect ?p ?waiting ?before ?remaining ?current |- _ =>
      assert (Hsteps : mutex_resume_all_steps p remaining current current)
        by (cbn [mutex_resume_all_steps]; reflexivity);
      specialize (Hrem current Hsteps)
  end.
  eapply scoped_resume_safe_continuation__drain_exit; eauto.
Qed.

Lemma proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_2 : LinklistResumeAll_which_implies_wit_9_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  all: change True; exact I.
Qed.

Lemma proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_3 : LinklistResumeAll_which_implies_wit_9_split_goal_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst.
  match goal with
  | Hrem : mutex_resume_remaining_effect ?p ?waiting ?before ?remaining ?current |- _ =>
      assert (Hsteps : mutex_resume_all_steps p remaining current current)
        by (cbn [mutex_resume_all_steps]; reflexivity);
      specialize (Hrem current Hsteps)
  end.
  eapply resume_effect_keeps_drained_identity__drain_exit; eauto.
Qed.

Lemma proof_of_LinklistResumeAll_which_implies_wit_9 : LinklistResumeAll_which_implies_wit_9.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_1.
  - Goal_apply proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_3.
Qed. 

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
