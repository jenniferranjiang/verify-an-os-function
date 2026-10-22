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
From CRTOS_Verify.VC Require Import SemaphoreCreate_goal.
From CRTOS_Verify.VC Require Import SemaphoreCreate_proof_auto.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import KSemaphoreCreateTrial.KSemaphoreCreate.
Require Import TrialShared.CrtosInv TrialShared.SemaphoreInv.
Require Import TrialShared.DoubleLinkListSpec.
Import IDNode DLL.
From MonadLib.MonadErr
      Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.VC.SemaphoreCreate_lib.
Local Open Scope sac.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_1 : _SemaphoreCreate_entail_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_2 : _SemaphoreCreate_entail_wit_1_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1 : _SemaphoreCreate_entail_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  prop_apply_p (store_ushort_range (&("val")) val_pre).
  Intros_p Hrange.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; tauto.
Qed. 

Lemma proof_of__SemaphoreCreate_entail_wit_2_split_goal_1 : _SemaphoreCreate_entail_wit_2_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  assert (Halign : addr_aligned retval 4) by assumption.
  pose proof (semaphore_field_offsets_trusted retval Halign) as Hlayout.
  destruct Hlayout as [Hid [Hidval [Hidlink [Hval [Hpend [Hlink Hnodes]]]]]].
  rewrite Hlink. lia.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_2_split_goal_2 : _SemaphoreCreate_entail_wit_2_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  assert (Halign : addr_aligned retval 4) by assumption.
  pose proof (semaphore_field_offsets_trusted retval Halign) as Hlayout.
  destruct Hlayout as [Hid [Hidval [Hidlink [Hval [Hpend [Hlink Hnodes]]]]]].
  rewrite Hpend. lia.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_2_split_goal_3 : _SemaphoreCreate_entail_wit_2_split_goal_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_2_split_goal_spatial : _SemaphoreCreate_entail_wit_2_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Halign : addr_aligned retval 4) by assumption.
  assert (Hpos : 0 < retval) by lia.
  assert (Hbound : retval <= 4294967295 - 32) by (int_auto; lia).
  pose proof (semaphore_field_offsets_trusted retval Halign) as Hlayout.
  sep_apply_l_atomic (KSemaphoreCreateTrial.SemaphoreByteLayout.semaphore_zero_bytes_object retval Hlayout Hpos Hbound Halign).
  Intros_p Hnodes.
  cancel (OutsideCritical sg before).
  cancel (SemaphoreZero retval).
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_2 : _SemaphoreCreate_entail_wit_2.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_2_split_goal_spatial.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_2_split_goal_1.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_2_split_goal_2.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_2_split_goal_3.
Qed. 

Lemma proof_of__SemaphoreCreate_entail_wit_3_split_goal_1 : _SemaphoreCreate_entail_wit_3_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv, semaphore_inv, SemaphoreZero. Intros_p Hwf. Intros_p Hctx. Intros_p Hz.
  unfold store_dll. Intros h pt.
  sepcon_right_assoc.
  sep_apply_l_atomic (dllseg_fresh_value__open_id (pure_suspend_sched_link (task_desc_map (os_tasks st_lock))) sem (os_semaphores st_lock) h (semaphore_list_head (os_semaphore_stable sg)) (semaphore_list_head (os_semaphore_stable sg)) pt).
  Intros_p Hfresh. dump_pre_spatial. exact Hfresh.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_3_split_goal_2 : _SemaphoreCreate_entail_wit_3_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv, semaphore_inv. Intros_p Hwf. Intros_p Hctx.
  dump_pre_spatial. exact Hctx.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_3_split_goal_3 : _SemaphoreCreate_entail_wit_3_split_goal_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv. Intros_p Hwf. dump_pre_spatial. exact Hwf.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_3_split_goal_spatial : _SemaphoreCreate_entail_wit_3_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv, semaphore_inv. Intros_p Hwf. Intros_p Hctx.
  sepcon_right_assoc.
  sep_apply_l_atomic (KSemaphoreCreateTrial.SemaphoreOwnership.semaphore_zero_insert_ready sem). Intros_p Hz.
  destruct Hctx as [Hm [_ [_ [_ [_ Hl]]]]]. rewrite Hm, Hl.
  cancel.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_3 : _SemaphoreCreate_entail_wit_3.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_3_split_goal_spatial.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_3_split_goal_1.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_3_split_goal_2.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_3_split_goal_3.
Qed. 

Lemma proof_of__SemaphoreCreate_entail_wit_4_1_split_goal_1 : _SemaphoreCreate_entail_wit_4_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  apply (proj1 (KSemaphoreCreateTrial.SemaphoreSpecBridge.idmanager_first_free_id_none_iff_full _ _)).
  assumption.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_4_1_split_goal_spatial : _SemaphoreCreate_entail_wit_4_1_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  sep_apply_l_atomic (KSemaphoreCreateTrial.SemaphoreOwnership.semaphore_insert_failure_raw sem ltac:(assumption) ltac:(assumption) ltac:(assumption) ltac:(assumption)).
  unfold os_inv, semaphore_inv.
  assert (Hcontext := PreH16).
  unfold semaphore_context in Hcontext.
  destruct Hcontext as [Hmanager [_ [_ [_ [_ Hlist]]]]].
  rewrite Hmanager, Hlist.
  split_pure_spatial; [repeat progress cancel | split_pures; dump_pre_spatial; assumption].
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_4_1 : _SemaphoreCreate_entail_wit_4_1.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreCreate_entail_wit_4_1_split_goal_spatial.
  Goal_apply proof_of__SemaphoreCreate_entail_wit_4_1_split_goal_1.
Qed. 

Lemma proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_1 : _SemaphoreCreate_entail_wit_4_2_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold idmanager_min_free_id in *.
  exfalso; lia.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_2 : _SemaphoreCreate_entail_wit_4_2_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold idmanager_min_free_id in *.
  exfalso; lia.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_spatial : _SemaphoreCreate_entail_wit_4_2_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold idmanager_min_free_id in *.
  exfalso; lia.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_4_2 : _SemaphoreCreate_entail_wit_4_2.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_spatial.
  Goal_apply proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_1.
  Goal_apply proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_2.
Qed. 

Lemma proof_of__SemaphoreCreate_entail_wit_5 : _SemaphoreCreate_entail_wit_5.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hrange : retval < 128).
  { unfold idmanager_min_free_id in PreH2.
    unfold semaphore_context in PreH13. destruct PreH13 as [_ [Hmax _]].
    rewrite Hmax in PreH2. tauto. }
  sep_apply_l_atomic (pend_zero_ready__list_prepare sem).
  split_pure_spatial; [sepcon_right_assoc; cancel | split_pures; dump_pre_spatial; auto; lia].
Qed. 

Lemma proof_of__SemaphoreCreate_entail_wit_6_split_goal_spatial : _SemaphoreCreate_entail_wit_6_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  sep_apply_l_atomic (new_object_payload__list_prepare
    (pure_suspend_sched_link (task_desc_map (os_tasks st_lock))) sem id val_pre PreH4 PreH5 PreH1).
  sepcon_right_assoc; cancel.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_6 : _SemaphoreCreate_entail_wit_6.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreCreate_entail_wit_6_split_goal_spatial.
Qed. 

Lemma proof_of__SemaphoreCreate_entail_wit_7_split_goal_1 : _SemaphoreCreate_entail_wit_7_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto);
  dump_pre_spatial; exact I.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_7_split_goal_spatial : _SemaphoreCreate_entail_wit_7_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  pose proof (published_world_wf__publish sg st_lock sem id val_pre PreH14) as Hworld.
  pose proof PreH15 as Hcontext.
  destruct Hcontext as [Hmanager [Hmax [Hoffset [Hmap [Htable Hhead]]]]].
  unfold dll_insert_after_dispatch.
  destruct (Z.eq_dec &("k_sem_list") &("k_sem_list")); [|contradiction].
  sep_apply_l_atomic (task_inv_replace__publish sg st_lock
    (semaphore_publish sem id val_pre (os_semaphores st_lock))).
  unfold os_inv, semaphore_inv.
  cbn [replace_semaphores os_tasks os_tick os_delays os_assign zombie_queue os_recycle os_idle os_mutexes os_msgqueues os_events os_isr os_exstatus os_semaphores].
  rewrite (published_manager__publish
    (semaphore_manager_stable (os_semaphore_stable sg))
    (os_semaphores st_lock) sem id val_pre Hoffset).
  rewrite Hmanager, Hhead.
  cbn [semaphore_publish semaphore_link_node semaphore_created semaphore_addr map].
  split_pure_spatial.
  - change (tick_inv sg (replace_semaphores (semaphore_publish sem id val_pre (os_semaphores st_lock)) st_lock)) with (tick_inv sg st_lock).
    change (delay_inv sg (replace_semaphores (semaphore_publish sem id val_pre (os_semaphores st_lock)) st_lock)) with (delay_inv sg st_lock).
    change (assign_inv sg (replace_semaphores (semaphore_publish sem id val_pre (os_semaphores st_lock)) st_lock)) with (assign_inv sg st_lock).
    change (exstatus_inv sg (replace_semaphores (semaphore_publish sem id val_pre (os_semaphores st_lock)) st_lock)) with (exstatus_inv sg st_lock).
    change (semaphore_link_node (semaphore_created sem id val_pre)) with
      (Build_DL_Node (semaphore_created sem id val_pre) (&(sem # "Semaphore" ->ₛ "link"))).
    cancel (task_inv sg (replace_semaphores
      (semaphore_publish sem id val_pre (os_semaphores st_lock)) st_lock)).
    cancel (store_dll (store_semaphore (pure_suspend_sched_link (task_desc_map (os_tasks st_lock))))
      (&("k_sem_list"))
      (Build_DL_Node (semaphore_created sem id val_pre) (&(sem # "Semaphore" ->ₛ "link"))
       :: map semaphore_link_node (os_semaphores st_lock))).
    cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_7 : _SemaphoreCreate_entail_wit_7.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreCreate_entail_wit_7_split_goal_spatial.
Qed. 

Lemma proof_of__SemaphoreCreate_return_wit_1_split_goal_1 : _SemaphoreCreate_return_wit_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold abs_semaphore_create in PreH8 at 1.
  prog_nf in PreH8.
  safe_choice_r PreH8.
  eapply atomic_normal_return__returns; [exact PreH7 | | exact PreH8].
  cbn. right. exists sem.
  exact (conj PreH3 (conj PreH4 (conj PreH12 (conj PreH11 eq_refl)))).
Qed.

Lemma proof_of__SemaphoreCreate_return_wit_1 : _SemaphoreCreate_return_wit_1.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreCreate_return_wit_1_split_goal_1.
Qed. 

Lemma proof_of__SemaphoreCreate_return_wit_2_split_goal_1 : _SemaphoreCreate_return_wit_2_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold abs_semaphore_create in PreH8 at 1.
  prog_nf in PreH8.
  safe_choice_r PreH8.
  eapply atomic_normal_return__returns; [exact PreH7 | | exact PreH8].
  cbn. left. exact (conj eq_refl (conj PreH10 eq_refl)).
Qed.

Lemma proof_of__SemaphoreCreate_return_wit_2 : _SemaphoreCreate_return_wit_2.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreCreate_return_wit_2_split_goal_1.
Qed. 

Lemma proof_of__SemaphoreCreate_return_wit_3_split_goal_1 : _SemaphoreCreate_return_wit_3_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold abs_semaphore_create in PreH5 at 1.
  prog_nf in PreH5.
  safe_choice_l PreH5.
  exact PreH5.
Qed.

Lemma proof_of__SemaphoreCreate_return_wit_3 : _SemaphoreCreate_return_wit_3.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreCreate_return_wit_3_split_goal_1.
Qed. 

Lemma proof_of__SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1 : _SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_6_pure : _SemaphoreCreate_partial_solve_wit_6_pure.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1.
Qed. 

Lemma proof_of__SemaphoreCreate_partial_solve_wit_8_pure_split_goal_1 : _SemaphoreCreate_partial_solve_wit_8_pure_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial. unfold dll_insert_anchor. right. reflexivity.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_8_pure : _SemaphoreCreate_partial_solve_wit_8_pure.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreCreate_partial_solve_wit_8_pure_split_goal_1.
Qed.

Lemma proof_of__SemaphoreCreate_safety_wit_1 : _SemaphoreCreate_safety_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_2 : _SemaphoreCreate_safety_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_3 : _SemaphoreCreate_safety_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_4 : _SemaphoreCreate_safety_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_5 : _SemaphoreCreate_safety_wit_5.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_6 : _SemaphoreCreate_safety_wit_6.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_7 : _SemaphoreCreate_safety_wit_7.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_8 : _SemaphoreCreate_safety_wit_8.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_9 : _SemaphoreCreate_safety_wit_9.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_10 : _SemaphoreCreate_safety_wit_10.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_11 : _SemaphoreCreate_safety_wit_11.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_12 : _SemaphoreCreate_safety_wit_12.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_13 : _SemaphoreCreate_safety_wit_13.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_14 : _SemaphoreCreate_safety_wit_14.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_15 : _SemaphoreCreate_safety_wit_15.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_16 : _SemaphoreCreate_safety_wit_16.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_safety_wit_17 : _SemaphoreCreate_safety_wit_17.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_1_pure : _SemaphoreCreate_partial_solve_wit_1_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_1 : _SemaphoreCreate_partial_solve_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_2_pure : _SemaphoreCreate_partial_solve_wit_2_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_2 : _SemaphoreCreate_partial_solve_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_3 : _SemaphoreCreate_partial_solve_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_4 : _SemaphoreCreate_partial_solve_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_5 : _SemaphoreCreate_partial_solve_wit_5.
Proof.
  LLM_pre_process ltac:(lia || int_auto);
  split_pure_spatial; [cancel | split_pures; dump_pre_spatial; assumption].
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_6 : _SemaphoreCreate_partial_solve_wit_6.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  LLM_pre_process ltac:(lia || int_auto || reflexivity).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_7 : _SemaphoreCreate_partial_solve_wit_7.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_8 : _SemaphoreCreate_partial_solve_wit_8.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  LLM_pre_process ltac:(lia || int_auto).
  all: try (split_pure_spatial; [sepcon_right_assoc; cancel | split_pures; dump_pre_spatial; auto]).
  all: try dump_pre_spatial.
  all: unfold dll_insert_anchor; try (right; reflexivity).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_9_pure : _SemaphoreCreate_partial_solve_wit_9_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_9 : _SemaphoreCreate_partial_solve_wit_9.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  cbv beta delta [_SemaphoreCreate_partial_solve_wit_9_aux].
  intros.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed.
