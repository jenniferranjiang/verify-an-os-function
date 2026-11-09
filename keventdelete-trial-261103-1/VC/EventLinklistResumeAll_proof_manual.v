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
From CRTOS_Verify.VC Require Import EventLinklistResumeAll_goal.
From CRTOS_Verify.VC Require Import EventLinklistResumeAll_proof_auto.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.lib.IdModuleSpec CRTOS_Verify.lib.DoubleLinkListSpec.
Require Import CRTOS_Verify.lib.KEventDelete.
Import IDNode DLL MonadErr.
Require Import CRTOS_Verify.VC.EventLinklistResumeAll_lib.
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
  LLM_pre_process ltac:(assumption || lia).
Qed. 

Lemma proof_of_LinklistResumeAll_safety_wit_8 : LinklistResumeAll_safety_wit_8.
Proof.
  LLM_pre_process ltac:(assumption || lia).
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
  LLM_pre_process ltac:(auto).
  split_pure_spatial.
  - sep_apply_l_atomic (store_ptr_undef_store_ptr (&("node")) 0).
    sep_apply_l_atomic (store_ptr_undef_store_ptr (&("task")) 0).
    sep_apply_l_atomic (store_uint_undef_store_uint (&("lock")) 0).
    cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed. 

Lemma proof_of_LinklistResumeAll_entail_wit_2 : LinklistResumeAll_entail_wit_2.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 

Lemma proof_of_LinklistResumeAll_return_wit_1 : LinklistResumeAll_return_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Exists current.
  split_pure_spatial.
  - cancel (OutsideCritical sg_event_waiters_oc current).
  - split_pures; dump_pre_spatial; auto.
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_1_pure : LinklistResumeAll_partial_solve_wit_1_pure.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_1 : LinklistResumeAll_partial_solve_wit_1.
Proof.
  LLM_pre_process ltac:(auto).
  LLM_pre_process ltac:(auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_2_pure : LinklistResumeAll_partial_solve_wit_2_pure.
Proof.
  LLM_pre_process ltac:(assumption || lia || int_auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_2 : LinklistResumeAll_partial_solve_wit_2.
Proof.
  LLM_pre_process ltac:(assumption || lia || int_auto).
  LLM_pre_process ltac:(assumption || lia || int_auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_3_pure : LinklistResumeAll_partial_solve_wit_3_pure.
Proof.
  LLM_pre_process ltac:(assumption || lia || int_auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_3 : LinklistResumeAll_partial_solve_wit_3.
Proof.
  LLM_pre_process ltac:(assumption || lia || int_auto).
  LLM_pre_process ltac:(assumption || lia || int_auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_4 : LinklistResumeAll_partial_solve_wit_4.
Proof.
  LLM_pre_process ltac:(assumption || lia || int_auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_5 : LinklistResumeAll_partial_solve_wit_5.
Proof.
  LLM_pre_process ltac:(assumption || lia || int_auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_6_pure : LinklistResumeAll_partial_solve_wit_6_pure.
Proof.
  LLM_pre_process ltac:(assumption || lia).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_6 : LinklistResumeAll_partial_solve_wit_6.
Proof.
  LLM_pre_process ltac:(assumption || lia).
  LLM_pre_process ltac:(assumption || lia).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_7_pure : LinklistResumeAll_partial_solve_wit_7_pure.
Proof.
  LLM_pre_process ltac:(assumption || lia).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_7 : LinklistResumeAll_partial_solve_wit_7.
Proof.
  LLM_pre_process ltac:(assumption || lia).
  LLM_pre_process ltac:(assumption || lia).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_8_pure : LinklistResumeAll_partial_solve_wit_8_pure.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_8 : LinklistResumeAll_partial_solve_wit_8.
Proof.
  LLM_pre_process ltac:(auto).
  unfold LinklistResumeAll_partial_solve_wit_8_aux; intros.
  split_pure_spatial.
  - cancel (os_inv sg_event_waiters_oc current).
    cancel (InsideCritical sg_event_waiters_oc locked).
  - split_pures; dump_pre_spatial; auto.
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_9 : LinklistResumeAll_partial_solve_wit_9.
Proof.
  LLM_pre_process ltac:(auto).
  subst retval.
  split_pure_spatial.
  - sep_apply_l_atomic (store_int_undef_store_int (&(target # "TaskDescriptor" ->ₛ "exstatus")) (tdExstatus desc)).
    cancel (&(target # "TaskDescriptor" ->ₛ "exstatus") # Int |->_).
    cancel (event_resume_exstatus_restore sg_event_waiters_oc marked target (-1)).
    cancel (InsideCritical sg_event_waiters_oc locked).
  - split_pures; dump_pre_spatial; auto.
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_10 : LinklistResumeAll_partial_solve_wit_10.
Proof.
  LLM_pre_process ltac:(auto).
  subst retval.
  split_pure_spatial.
  - cancel (&(target # "TaskDescriptor" ->ₛ "exstatus") # Int |-> (-1)).
    cancel (event_resume_exstatus_restore sg_event_waiters_oc marked target (-1)).
    cancel (InsideCritical sg_event_waiters_oc locked).
  - split_pures; dump_pre_spatial; auto.
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_11_pure : LinklistResumeAll_partial_solve_wit_11_pure.
Proof.
  LLM_pre_process ltac:(auto || lia || int_auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_11 : LinklistResumeAll_partial_solve_wit_11.
Proof.
  LLM_pre_process ltac:(auto || lia || int_auto).
  LLM_pre_process ltac:(auto || lia || int_auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_12 : LinklistResumeAll_partial_solve_wit_12.
Proof.
  LLM_pre_process ltac:(auto || lia || int_auto).
  subst retval.
  LLM_pre_process ltac:(auto || lia || int_auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_13 : LinklistResumeAll_partial_solve_wit_13.
Proof.
  LLM_pre_process ltac:(auto || lia || int_auto).
  subst retval.
  LLM_pre_process ltac:(auto || lia || int_auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_14_pure : LinklistResumeAll_partial_solve_wit_14_pure.
Proof.
  LLM_pre_process ltac:(auto || lia || int_auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_14 : LinklistResumeAll_partial_solve_wit_14.
Proof.
  LLM_pre_process ltac:(auto || lia || int_auto).
  LLM_pre_process ltac:(auto || lia || int_auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_15_pure : LinklistResumeAll_partial_solve_wit_15_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_15 : LinklistResumeAll_partial_solve_wit_15.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold LinklistResumeAll_partial_solve_wit_15_aux. intros.
  split_pure_spatial.
  - cancel (os_inv sg_event_waiters_oc current).
    cancel (InsideCritical sg_event_waiters_oc locked).
  - split_pures; dump_pre_spatial; auto.
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_16_pure : LinklistResumeAll_partial_solve_wit_16_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of_LinklistResumeAll_partial_solve_wit_16 : LinklistResumeAll_partial_solve_wit_16.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold LinklistResumeAll_partial_solve_wit_16_aux. intros.
  split_pure_spatial.
  - cancel (os_inv sg_event_waiters_oc current).
    cancel (InsideCritical sg_event_waiters_oc locked).
  - split_pures; dump_pre_spatial; auto.
Qed. 

Lemma proof_of_LinklistResumeAll_entail_wit_3 : LinklistResumeAll_entail_wit_3.
Proof.
  LLM_pre_process ltac:(auto).
  Exists waiting locked.
  split_pure_spatial.
  - sep_apply_l_atomic (store_ptr_undef_store_ptr (&("node")) 0).
    sep_apply_l_atomic (store_ptr_undef_store_ptr (&("task")) 0).
    cancel.
  - split_pures; dump_pre_spatial; try assumption.
    unfold event_resume_remaining_effect; auto.
Qed. 

Lemma proof_of_LinklistResumeAll_entail_wit_4_1 : LinklistResumeAll_entail_wit_4_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  rewrite PreH6.
  unfold os_inv, task_inv, store_idmanager.
  Intros.
  exfalso.
  unfold get_task_with_idnode_success in PreH2, PreH12.
  destruct PreH2 as [Hb1 [Hq1 [p1 [He1 [Hin1 Htask1]]]]].
  destruct PreH12 as [Hb2 [Hq2 [p2 [He2 [Hin2 Htask2]]]]].
  destruct H1 as [Hoffset [Hlen [Hids [Hnodes Hother]]]].
  assert (Hbound :
    0 <= idmanager_bucket_index
      (task_stable_ids (os_task_stable sg_event_waiters_oc)) task_id <
    Zlength (task_idmanager_abs (os_tasks marked)).(idbuckets)).
  { unfold idmanager_bucket_index. rewrite Hlen.
    apply Z.mod_pos_bound. exact Hoffset. }
  pose proof (Forall_Znth_Zlength _ _ nil _ Hnodes Hbound) as Hbucket.
  destruct Hbucket as [[_ Hnodup] _].
  pose proof (idnode_address_unique__wakeup_failure
    _ _ _ _ Hnodup Hin1 Hin2) as Heq.
  rewrite He1, He2 in Heq.
  apply addr_of_arrow_field_inv in Heq.
  injection Heq as Hsame.
  rewrite Hsame, PreH9 in PreH3.
  cbv [replace_task_desc_map os_tasks task_desc_map update_task_desc_map]
    in PreH3.
  destruct (Z.eq_dec target target) as [_|Hneq]; [|contradiction].
  injection PreH3 as Hdesc.
  rewrite <- Hdesc in PreH4.
  change (tsmStat (tdSchedMember desc) <> TSK_SUSPEND) in PreH4.
  contradiction.
Qed. 

Lemma proof_of_LinklistResumeAll_entail_wit_4_2 : LinklistResumeAll_entail_wit_4_2.
Proof.
 LLM_pre_process ltac:(lia).
 assert(Hp:event_pending_at id_event_waiters_oc p_event_waiters_oc (target::rest)current_2)
 by (rewrite <-PreH7; exact PreH8).
 prop_apply_p (event_batch_after_head__event_batch_step
  sg_event_waiters_oc id_event_waiters_oc p_event_waiters_oc current_2 marked after
  target rest desc task desc_2 task_id Hp PreH16 PreH26 PreH9 PreH27 PreH28 PreH14 PreH15
  PreH12 PreH2 PreH6).
 Intros_p Hbatch. destruct Hbatch as [Hpending Hcompose].
 assert(Hprogress:event_resume_remaining_effect p_event_waiters_oc waiting locked rest after).
 { unfold event_resume_remaining_effect in *. intros final Hfinal. apply PreH40.
   rewrite PreH7. apply Hcompose. exact Hfinal. }
 Exists rest after. split_pure_spatial.
 - sep_apply_l_atomic (store_ptr_undef_store_ptr (&("task")) retval).
   sep_apply_l_atomic (store_ptr_undef_store_ptr (&("node")) next).
   cancel.
 - split_pures; dump_pre_spatial; tauto.
Qed.

Lemma proof_of_LinklistResumeAll_which_implies_wit_1 : LinklistResumeAll_which_implies_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  destruct PreH1 as [Htrans [Hnz [e [Hin [Haddr [Hid Hempty]]]]]].
  Exists (event_pending_addrs e).
  split_pure_spatial.
  - cancel (os_inv sg_event_waiters_oc locked).
  - split_pures; dump_pre_spatial.
    + unfold event_delete_gap, event_delete_guard. eauto 10.
    + unfold event_pending_at. eauto 10.
Qed.

Lemma proof_of_LinklistResumeAll_which_implies_wit_2 : LinklistResumeAll_which_implies_wit_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
sep_apply_l_atomic (pending_head_borrow__pending_head_access id_event_waiters_oc p_event_waiters_oc remaining sg_event_waiters_oc current list_pre PreH1 PreH2).
Intros next.
destruct remaining as [|first tail].
- Left.
Exists next.
split_pure_spatial.
+ sepcon_assoc_change.
repeat match goal with |- _ |-- ?P ** _ => cancel P | |- ?P |-- _ => cancel P end.
+ split_pures; dump_pre_spatial; auto.
- Right.
Exists next first tail.
split_pure_spatial.
+ sepcon_assoc_change.
repeat match goal with |- _ |-- ?P ** _ => cancel P | |- ?P |-- _ => cancel P end.
+ split_pures; dump_pre_spatial; tauto.
Qed.

Lemma proof_of_LinklistResumeAll_which_implies_wit_3_split_goal_spatial : LinklistResumeAll_which_implies_wit_3_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold event_resume_next_restore.
  apply derivable1_wand_elim2.
Qed.

Lemma proof_of_LinklistResumeAll_which_implies_wit_3 : LinklistResumeAll_which_implies_wit_3.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_LinklistResumeAll_which_implies_wit_3_split_goal_spatial.
Qed. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_4 : LinklistResumeAll_which_implies_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hp : event_pending_at id_event_waiters_oc p_event_waiters_oc (target::rest) current) by (rewrite <- PreH1; exact PreH3).
  prop_apply_p (event_pending_head_facts__event_batch_step sg_event_waiters_oc current id_event_waiters_oc p_event_waiters_oc target rest Hp).
  Intros_p Hfacts. destruct Hfacts as [Hw [Ht [d [Hd [Hs Ha]]]]].
  Exists d. split_pure_spatial; [cancel|]. split_pures; dump_pre_spatial; tauto.
Qed. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_5_split_goal_spatial : LinklistResumeAll_which_implies_wit_5_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(auto).
  apply exstatus_borrow_update__exstatus_write_view. assumption.
Qed.

Lemma proof_of_LinklistResumeAll_which_implies_wit_5 : LinklistResumeAll_which_implies_wit_5.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_LinklistResumeAll_which_implies_wit_5_split_goal_spatial.
Qed. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_6_split_goal_spatial : LinklistResumeAll_which_implies_wit_6_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold event_resume_exstatus_restore.
  apply derivable1_wand_elim2.
Qed.

Lemma proof_of_LinklistResumeAll_which_implies_wit_6 : LinklistResumeAll_which_implies_wit_6.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_LinklistResumeAll_which_implies_wit_6_split_goal_spatial.
Qed. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_7 : LinklistResumeAll_which_implies_wit_7.
Proof.
 LLM_pre_process ltac:(lia || int_auto).
 assert (Hpm : event_pending_at id_event_waiters_oc p_event_waiters_oc remaining marked).
 { rewrite PreH3. exact PreH2. }
 assert (Hhead : event_pending_at id_event_waiters_oc p_event_waiters_oc (target::rest) marked)
 by (rewrite <- PreH1; exact Hpm).
 prop_apply_p (event_pending_head_facts__event_batch_step sg_event_waiters_oc marked id_event_waiters_oc p_event_waiters_oc target rest Hhead).
 Intros_p Hfacts. destruct Hfacts as [Hw [Ht [d [Hd [Hs Ha]]]]].
 prop_apply_p (task_id_available_pure__event_batch_step sg_event_waiters_oc marked target d Hd).
 Intros_p Hid. destruct Hid as [tid [Hr Hlookup]].
 Exists tid. split_pure_spatial.
 - apply task_id_borrow__event_batch_step. exact Hlookup.
 - split_pures; dump_pre_spatial; tauto.
Qed.

Lemma proof_of_LinklistResumeAll_which_implies_wit_8_split_goal_spatial : LinklistResumeAll_which_implies_wit_8_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold event_resume_id_restore.
  apply derivable1_wand_elim2.
Qed.

Lemma proof_of_LinklistResumeAll_which_implies_wit_8 : LinklistResumeAll_which_implies_wit_8.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_LinklistResumeAll_which_implies_wit_8_split_goal_spatial.
Qed. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_1 : LinklistResumeAll_which_implies_wit_9_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  eapply guarded_resume_commit__atomic_exit; eauto.
  apply PreH2. subst remaining. reflexivity.
Qed.

Lemma proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_2 : LinklistResumeAll_which_implies_wit_9_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_LinklistResumeAll_which_implies_wit_9_split_goal_3 : LinklistResumeAll_which_implies_wit_9_split_goal_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  destruct PreH4 as [_ [Hnz Hlive]].
  destruct PreH1 as [e [Hin [Hp [Hid Hwaiting]]]].
  unfold event_delete_guard. split; [exact Hnz|].
  exists e. repeat split; auto. intros _. rewrite Hwaiting, PreH3. reflexivity.
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
  rename rest_semaphore_pending_head_ic into rest.
  rename task_semaphore_pending_head_ic into headtask.
  rename sem_semaphore_pending_head_ic into sem.
  rename before_semaphore_pending_head_ic into before.
  rename sg_semaphore_pending_head_ic into sg.
  prop_apply_p (generic_wakeup_sem_head__import_sem_refinement
    sg before sem headtask rest id_pre H0 H1).
  Intros_p Href.
  destruct Href as [desc [Hdesc [Hstatus Href]]].
  Exists sg before.
  split_pure_spatial.
  - cancel (os_inv sg before).
    apply derivable1_wand_sepcon_adjoint. Intros. Split.
    + Intros after otherdesc other retval.
      destruct (Href other otherdesc after H3 H4) as [Heqt [Heqd _]].
      subst otherdesc. contradiction.
    + Intros after otherdesc other retval.
      destruct (Href other otherdesc after H3 H4) as [Heqt [Heqd Hstep]].
      subst other otherdesc.
      destruct (Hstep H7) as [Hwake Hpending].
      Exists after desc 0.
      split_pure_spatial.
      * cancel (os_inv sg after).
      * split_pures; dump_pre_spatial; auto.
  - dump_pre_spatial. exact H.
Qed. 

Lemma proof_of_KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic : KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  rename before_detached_sched_null_delay into before.
  rename sg_detached_sched_null_delay into sg.
  prop_apply_p (os_world_extract__import_detached_refinement sg before).
  Intros_p Hwf.
  Exists sg before.
  split_pure_spatial.
  - cancel (os_inv sg before).
    apply derivable1_wand_sepcon_adjoint.
    Intros. Split.
    + Intros after desc task retval.
      destruct (H0 task desc H2 H3) as [Hdelay Howned].
      Left. Exists after desc task retval.
      split_pure_spatial.
      * cancel (os_inv sg after).
      * split_pures; dump_pre_spatial; assumption.
    + Intros after desc task retval.
      destruct (H0 task desc H2 H3) as [Hdelay Howned].
      pose proof (generic_wakeup_detached_null__import_detached_refinement
        sg task desc before after Hwf Hdelay (Howned H4) H6) as Hspecial.
      Right. Exists after desc task retval.
      split_pure_spatial.
      * cancel (os_inv sg after).
      * split_pures; dump_pre_spatial; assumption.
  - dump_pre_spatial. exact H.
Qed.
