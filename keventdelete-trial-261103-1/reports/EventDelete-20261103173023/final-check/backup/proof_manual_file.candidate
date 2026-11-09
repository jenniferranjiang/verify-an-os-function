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
From CRTOS_Verify.VC Require Import EventDelete_goal.
From CRTOS_Verify.VC Require Import EventDelete_proof_auto.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.lib.IdModuleSpec CRTOS_Verify.lib.DoubleLinkListSpec.
Require Import CRTOS_Verify.lib.KEventDelete.
Import IDNode DLL MonadErr.
Require Import CRTOS_Verify.VC.EventDelete_lib.
Local Open Scope sac.


Lemma proof_of__EventDelete_safety_wit_1 : _EventDelete_safety_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventDelete_safety_wit_2 : _EventDelete_safety_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventDelete_safety_wit_3 : _EventDelete_safety_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventDelete_safety_wit_4 : _EventDelete_safety_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventDelete_safety_wit_5 : _EventDelete_safety_wit_5.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventDelete_safety_wit_6 : _EventDelete_safety_wit_6.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventDelete_safety_wit_7 : _EventDelete_safety_wit_7.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventDelete_safety_wit_8 : _EventDelete_safety_wit_8.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventDelete_safety_wit_9 : _EventDelete_safety_wit_9.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventDelete_safety_wit_10 : _EventDelete_safety_wit_10.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventDelete_entail_wit_1 : _EventDelete_entail_wit_1.
Proof.
  LLM_pre_process ltac:(unfold event_delete_guard in *; intuition congruence).
Qed.

Lemma proof_of__EventDelete_entail_wit_2 : _EventDelete_entail_wit_2.
Proof.
  LLM_pre_process ltac:(unfold event_delete_guard in *; intuition congruence).
Qed.

Lemma proof_of__EventDelete_entail_wit_3_1 : _EventDelete_entail_wit_3_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Exists drained.
  split_pure_spatial.
  - sep_apply_l_atomic (store_int_undef_store_int (&("lock")) 0).
    sep_apply_l_atomic (store_int_undef_store_int (&("inspect_lock")) retval).
    sep_apply_l_atomic (store_int_undef_store_int (&("pending_empty")) retval_2).
    cancel.
  - split_pures; dump_pre_spatial; auto.
Qed. 

Lemma proof_of__EventDelete_entail_wit_3_2 : _EventDelete_entail_wit_3_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Exists checked.
  split_pure_spatial.
  - sep_apply_l_atomic (store_int_undef_store_int (&("lock")) 0).
    sep_apply_l_atomic (store_int_undef_store_int (&("inspect_lock")) retval).
    sep_apply_l_atomic (store_int_undef_store_int (&("pending_empty")) retval_2).
    cancel.
  - split_pures; dump_pre_spatial; auto.
Qed. 

Lemma proof_of__EventDelete_entail_wit_5_1 : _EventDelete_entail_wit_5_1.
Proof.
  LLM_pre_process ltac:(lia || assumption || int_auto).
Qed. 

Lemma proof_of__EventDelete_entail_wit_5_2 : _EventDelete_entail_wit_5_2.
Proof.
  LLM_pre_process ltac:(lia || assumption || int_auto).
Qed. 

Lemma proof_of__EventDelete_entail_wit_6_1 : _EventDelete_entail_wit_6_1.
Proof.
  LLM_pre_process ltac:(lia || assumption || int_auto).
Qed. 

Lemma proof_of__EventDelete_entail_wit_6_2 : _EventDelete_entail_wit_6_2.
Proof.
  LLM_pre_process ltac:(lia || assumption || int_auto).
Qed. 

Lemma proof_of__EventDelete_return_wit_1 : _EventDelete_return_wit_1.
Proof.
  LLM_pre_process ltac:(lia || assumption || int_auto).
  all: match goal with
  | |- OutsideCritical ?sg ?s |-- _ =>
      Exists s; split_pure_spatial;
      [ cancel (OutsideCritical sg s) | dump_pre_spatial; assumption ]
  end.
Qed. 

Lemma proof_of__EventDelete_return_wit_2 : _EventDelete_return_wit_2.
Proof.
  LLM_pre_process ltac:(lia || assumption || int_auto).
  all: match goal with
  | |- OutsideCritical ?sg ?s |-- _ =>
      Exists s; split_pure_spatial;
      [ cancel (OutsideCritical sg s) | dump_pre_spatial; assumption ]
  end.
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_1_pure : _EventDelete_partial_solve_wit_1_pure.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_1 : _EventDelete_partial_solve_wit_1.
Proof.
  LLM_pre_process ltac:(auto).
  LLM_pre_process ltac:(auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_2_pure : _EventDelete_partial_solve_wit_2_pure.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_2 : _EventDelete_partial_solve_wit_2.
Proof.
  LLM_pre_process ltac:(auto).
  LLM_pre_process ltac:(auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_3 : _EventDelete_partial_solve_wit_3.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_4_pure : _EventDelete_partial_solve_wit_4_pure.
Proof.
  LLM_pre_process ltac:(assumption || lia || int_auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_4 : _EventDelete_partial_solve_wit_4.
Proof.
  LLM_pre_process ltac:(assumption || lia || int_auto).
  LLM_pre_process ltac:(assumption || lia || int_auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_5_pure : _EventDelete_partial_solve_wit_5_pure.
Proof.
  LLM_pre_process ltac:(assumption || lia || int_auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_5 : _EventDelete_partial_solve_wit_5.
Proof.
  LLM_pre_process ltac:(assumption || lia || int_auto).
  LLM_pre_process ltac:(assumption || lia || int_auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_6_pure : _EventDelete_partial_solve_wit_6_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_6 : _EventDelete_partial_solve_wit_6.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_7_pure : _EventDelete_partial_solve_wit_7_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_7 : _EventDelete_partial_solve_wit_7.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_8_pure : _EventDelete_partial_solve_wit_8_pure.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_8 : _EventDelete_partial_solve_wit_8.
Proof.
  LLM_pre_process ltac:(auto).
  LLM_pre_process ltac:(auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_9_pure : _EventDelete_partial_solve_wit_9_pure.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_9 : _EventDelete_partial_solve_wit_9.
Proof.
  LLM_pre_process ltac:(auto).
  LLM_pre_process ltac:(auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_10_pure : _EventDelete_partial_solve_wit_10_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_10 : _EventDelete_partial_solve_wit_10.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _EventDelete_partial_solve_wit_10_aux.
  intros.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; auto.
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_11_pure : _EventDelete_partial_solve_wit_11_pure.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_11 : _EventDelete_partial_solve_wit_11.
Proof.
  LLM_pre_process ltac:(auto).
  LLM_pre_process ltac:(auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_12_pure : _EventDelete_partial_solve_wit_12_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_12 : _EventDelete_partial_solve_wit_12.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _EventDelete_partial_solve_wit_12_aux. intros.
  split_pure_spatial.
  - cancel (OutsideCritical sg_event_delete_at_oc ready).
  - split_pures; dump_pre_spatial; assumption.
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_13_pure : _EventDelete_partial_solve_wit_13_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_13 : _EventDelete_partial_solve_wit_13.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _EventDelete_partial_solve_wit_13_aux. intros.
  split_pure_spatial.
  - cancel (OutsideCritical sg_event_delete_at_oc ready).
  - split_pures; dump_pre_spatial; assumption.
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_14_pure : _EventDelete_partial_solve_wit_14_pure.
Proof.
  LLM_pre_process ltac:(lia || assumption).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_14 : _EventDelete_partial_solve_wit_14.
Proof.
  LLM_pre_process ltac:(lia || assumption).
  LLM_pre_process ltac:(lia || assumption).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_15_pure : _EventDelete_partial_solve_wit_15_pure.
Proof.
  LLM_pre_process ltac:(lia || assumption).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_15 : _EventDelete_partial_solve_wit_15.
Proof.
  LLM_pre_process ltac:(lia || assumption).
  LLM_pre_process ltac:(lia || assumption).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_16 : _EventDelete_partial_solve_wit_16.
Proof.
  LLM_pre_process ltac:(auto || lia || int_auto).
  all: try cancel.
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_17 : _EventDelete_partial_solve_wit_17.
Proof.
  LLM_pre_process ltac:(auto || lia || int_auto).
  all: try cancel.
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_18_pure : _EventDelete_partial_solve_wit_18_pure.
Proof.
  LLM_pre_process ltac:(auto || lia || int_auto).
  all: try cancel.
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_18 : _EventDelete_partial_solve_wit_18.
Proof.
  LLM_pre_process ltac:(auto || lia || int_auto).
  LLM_pre_process ltac:(auto || lia || int_auto).
  all: try cancel.
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_19_pure : _EventDelete_partial_solve_wit_19_pure.
Proof.
  LLM_pre_process ltac:(auto || lia || int_auto).
  all: try cancel.
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_19 : _EventDelete_partial_solve_wit_19.
Proof.
  LLM_pre_process ltac:(auto || lia || int_auto).
  LLM_pre_process ltac:(auto || lia || int_auto).
  all: try cancel.
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_20 : _EventDelete_partial_solve_wit_20.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  LLM_pre_process ltac:(lia || int_auto || apply addr_of_LE_var_not_zero).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_21 : _EventDelete_partial_solve_wit_21.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  LLM_pre_process ltac:(lia || int_auto || apply addr_of_LE_var_not_zero).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_22 : _EventDelete_partial_solve_wit_22.
Proof.
  LLM_pre_process ltac:(congruence).
  all: congruence.
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_23 : _EventDelete_partial_solve_wit_23.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_24 : _EventDelete_partial_solve_wit_24.
Proof.
  LLM_pre_process ltac:(congruence).
  all: congruence.
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_25 : _EventDelete_partial_solve_wit_25.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_26_pure : _EventDelete_partial_solve_wit_26_pure.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_26 : _EventDelete_partial_solve_wit_26.
Proof.
  LLM_pre_process ltac:(auto).
  LLM_pre_process ltac:(auto); try cancel.
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_27_pure : _EventDelete_partial_solve_wit_27_pure.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_27 : _EventDelete_partial_solve_wit_27.
Proof.
  LLM_pre_process ltac:(auto).
  LLM_pre_process ltac:(auto); try cancel.
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_28 : _EventDelete_partial_solve_wit_28.
Proof.
 LLM_pre_process ltac:(lia || int_auto); cancel.
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_29 : _EventDelete_partial_solve_wit_29.
Proof.
 LLM_pre_process ltac:(lia || int_auto); cancel.
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_30 : _EventDelete_partial_solve_wit_30.
Proof.
 LLM_pre_process ltac:(lia || int_auto); cancel.
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_31 : _EventDelete_partial_solve_wit_31.
Proof.
 LLM_pre_process ltac:(lia || int_auto); cancel.
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_32_pure : _EventDelete_partial_solve_wit_32_pure.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_32 : _EventDelete_partial_solve_wit_32.
Proof.
  LLM_pre_process ltac:(auto).
  LLM_pre_process ltac:(auto); try cancel.
Qed. 

Lemma proof_of__EventDelete_entail_wit_4_1_split_goal_1 : _EventDelete_entail_wit_4_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(congruence).
  all: congruence.
Qed.

Lemma proof_of__EventDelete_entail_wit_4_1_split_goal_2 : _EventDelete_entail_wit_4_1_split_goal_2.
Proof.
  LLM_pre_process ltac:(congruence).
  all: congruence.
Qed.

Lemma proof_of__EventDelete_entail_wit_4_1_split_goal_spatial : _EventDelete_entail_wit_4_1_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(congruence).
  all: congruence.
Qed.

Lemma proof_of__EventDelete_entail_wit_4_1 : _EventDelete_entail_wit_4_1.
Proof.
  aggressive_pre_process.
  - Goal_apply (proof_of__EventDelete_entail_wit_4_1_split_goal_spatial event_pre X_event_delete_at_oc id_event_delete_at_oc sg_event_delete_at_oc resched ready locked original prefix suffix).
  - Goal_apply (proof_of__EventDelete_entail_wit_4_1_split_goal_2 event_pre X_event_delete_at_oc id_event_delete_at_oc sg_event_delete_at_oc resched ready locked original prefix suffix).
Qed. 

Lemma proof_of__EventDelete_entail_wit_4_2_split_goal_1 : _EventDelete_entail_wit_4_2_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__EventDelete_entail_wit_4_2_split_goal_2 : _EventDelete_entail_wit_4_2_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  eapply (event_finish_commit__retire_success id_event_delete_at_oc event_pre true ready locked X_event_delete_at_oc); [eassumption| |eassumption].
  exists original. split.
  - rewrite PreH5. apply in_or_app; right; simpl; auto.
  - repeat split; assumption.
Qed.

Lemma proof_of__EventDelete_entail_wit_4_2_split_goal_spatial : _EventDelete_entail_wit_4_2_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hin : In original (os_events locked)).
  { rewrite PreH5. apply in_or_app; right; simpl; auto. }
  assert (Enode : idnode = &(event_pre # "Event" ->ₛ "id")).
  { pose proof (event_contains_unique_target__retire_success
      (event_manager_stable (os_event_stable sg_event_delete_at_oc))
      (os_events locked) id_event_delete_at_oc idnode original
      PreH15 Hin PreH9 PreH2) as E.
    unfold event_idnode in E. simpl in E. rewrite PreH6 in E. exact E. }
  assert (Eunpub : event_unpublish event_pre (os_events locked) = prefix ++ suffix).
  { rewrite <- PreH6, PreH5. apply event_unpublish_split__retire_success.
    rewrite <- PreH5. exact PreH14. }
  assert (Ewait : event_waiters (event_unpublish event_pre (os_events locked)) =
      event_waiters (os_events locked)).
  { rewrite Eunpub, PreH5. unfold event_waiters.
    rewrite !map_app, !concat_app. simpl. rewrite PreH10. simpl. reflexivity. }
  sep_apply_l_atomic (event_retired_pack__retire_success
    (pure_suspend_sched_link (task_desc_map (os_tasks locked)))
    original event_pre idnode PreH6 PreH10 Enode PreH3 PreH4).
  rewrite PreH16.
  replace (map event_link_node prefix ++ map event_link_node suffix)
    with (map event_link_node (event_unpublish event_pre (os_events locked)))
    by (rewrite Eunpub, map_app; reflexivity).
  sep_apply_l_atomic (event_restore_frame__retire_success sg_event_delete_at_oc locked
    (event_unpublish event_pre (os_events locked)) Ewait).
  repeat progress cancel.
Qed.

Lemma proof_of__EventDelete_entail_wit_4_2 : _EventDelete_entail_wit_4_2.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__EventDelete_entail_wit_4_2_split_goal_spatial.
  - Goal_apply proof_of__EventDelete_entail_wit_4_2_split_goal_2.
Qed. 

Lemma proof_of__EventDelete_entail_wit_4_3_split_goal_1 : _EventDelete_entail_wit_4_3_split_goal_1.
Proof.
  LLM_pre_process ltac:(congruence).
  all: congruence.
Qed.

Lemma proof_of__EventDelete_entail_wit_4_3_split_goal_2 : _EventDelete_entail_wit_4_3_split_goal_2.
Proof.
  LLM_pre_process ltac:(congruence).
  all: congruence.
Qed.

Lemma proof_of__EventDelete_entail_wit_4_3_split_goal_spatial : _EventDelete_entail_wit_4_3_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(congruence).
  all: congruence.
Qed.

Lemma proof_of__EventDelete_entail_wit_4_3 : _EventDelete_entail_wit_4_3.
Proof.
  aggressive_pre_process.
  - Goal_apply (proof_of__EventDelete_entail_wit_4_3_split_goal_spatial event_pre X_event_delete_at_oc id_event_delete_at_oc sg_event_delete_at_oc resched ready locked original prefix suffix).
  - Goal_apply (proof_of__EventDelete_entail_wit_4_3_split_goal_2 event_pre X_event_delete_at_oc id_event_delete_at_oc sg_event_delete_at_oc resched ready locked original prefix suffix).
Qed. 

Lemma proof_of__EventDelete_entail_wit_4_4_split_goal_1 : _EventDelete_entail_wit_4_4_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__EventDelete_entail_wit_4_4_split_goal_2 : _EventDelete_entail_wit_4_4_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  eapply (event_finish_commit__retire_success id_event_delete_at_oc event_pre false ready locked X_event_delete_at_oc); [eassumption| |eassumption].
  exists original. split.
  - rewrite PreH5. apply in_or_app; right; simpl; auto.
  - repeat split; assumption.
Qed.

Lemma proof_of__EventDelete_entail_wit_4_4_split_goal_spatial : _EventDelete_entail_wit_4_4_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hin : In original (os_events locked)).
  { rewrite PreH5. apply in_or_app; right; simpl; auto. }
  assert (Enode : idnode = &(event_pre # "Event" ->ₛ "id")).
  { pose proof (event_contains_unique_target__retire_success
      (event_manager_stable (os_event_stable sg_event_delete_at_oc))
      (os_events locked) id_event_delete_at_oc idnode original
      PreH15 Hin PreH9 PreH2) as E.
    unfold event_idnode in E. simpl in E. rewrite PreH6 in E. exact E. }
  assert (Eunpub : event_unpublish event_pre (os_events locked) = prefix ++ suffix).
  { rewrite <- PreH6, PreH5. apply event_unpublish_split__retire_success.
    rewrite <- PreH5. exact PreH14. }
  assert (Ewait : event_waiters (event_unpublish event_pre (os_events locked)) =
      event_waiters (os_events locked)).
  { rewrite Eunpub, PreH5. unfold event_waiters.
    rewrite !map_app, !concat_app. simpl. rewrite PreH10. simpl. reflexivity. }
  sep_apply_l_atomic (event_retired_pack__retire_success
    (pure_suspend_sched_link (task_desc_map (os_tasks locked)))
    original event_pre idnode PreH6 PreH10 Enode PreH3 PreH4).
  rewrite PreH16.
  replace (map event_link_node prefix ++ map event_link_node suffix)
    with (map event_link_node (event_unpublish event_pre (os_events locked)))
    by (rewrite Eunpub, map_app; reflexivity).
  sep_apply_l_atomic (event_restore_frame__retire_success sg_event_delete_at_oc locked
    (event_unpublish event_pre (os_events locked)) Ewait).
  repeat progress cancel.
Qed.

Lemma proof_of__EventDelete_entail_wit_4_4 : _EventDelete_entail_wit_4_4.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__EventDelete_entail_wit_4_4_split_goal_spatial.
  - Goal_apply proof_of__EventDelete_entail_wit_4_4_split_goal_2.
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_20_pure_split_goal_1 : _EventDelete_partial_solve_wit_20_pure_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  apply addr_of_LE_var_not_zero.
Qed.

Lemma proof_of__EventDelete_partial_solve_wit_20_pure : _EventDelete_partial_solve_wit_20_pure.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__EventDelete_partial_solve_wit_20_pure_split_goal_1.
Qed. 

Lemma proof_of__EventDelete_partial_solve_wit_21_pure_split_goal_1 : _EventDelete_partial_solve_wit_21_pure_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  apply addr_of_LE_var_not_zero.
Qed.

Lemma proof_of__EventDelete_partial_solve_wit_21_pure : _EventDelete_partial_solve_wit_21_pure.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__EventDelete_partial_solve_wit_21_pure_split_goal_1.
Qed. 

Lemma proof_of__EventDelete_which_implies_wit_1 : _EventDelete_which_implies_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  pose proof (proj2 PreH1) as Hg.
  destruct Hg as [Hnz [e [Hin [Hp [Hid Hempty]]]]].
  Exists (event_pending_addrs e).
  split_pure_spatial.
  - unfold event_delete_pending_restore, event_pending_head.
    rewrite <- Hp.
    apply in_split in Hin as [prefix [suffix Hlist]].
    unfold os_inv at 1. unfold event_inv at 1. Intros.
    unfold store_dll at 1. Intros h pt.
    rewrite Hlist, map_app. cbn [map].
    sep_apply_l_atomic (dllseg_split
      (store_event (pure_suspend_sched_link (task_desc_map (os_tasks checked))))
      h (event_list_head (os_event_stable sg_event_delete_at_oc))
      (event_list_head (os_event_stable sg_event_delete_at_oc)) pt
      (map event_link_node prefix) (event_link_node e :: map event_link_node suffix)).
    Intros y py. cbn [dllseg event_link_node]. Intros z.
    unfold store_event at 1. Intros.
    change ((event_link_node e).(data)) with e in *.
    match goal with |- _ |-- ?P ** _ => cancel P end.
    apply_sepcon_adjoint.
    unfold os_inv, event_inv. rewrite Hlist. split_pure_spatial.
    + cancel. unfold store_dll at 2. Exists h pt. split_pure_spatial.
      * rewrite map_app. cbn [map].
        cancel (task_inv sg_event_delete_at_oc checked).
        sep_apply_r_atomic (dllseg_concat
          (store_event (pure_suspend_sched_link (task_desc_map (os_tasks checked))))
          h (event_list_head (os_event_stable sg_event_delete_at_oc)) y py
          (event_list_head (os_event_stable sg_event_delete_at_oc)) pt
          (map event_link_node prefix) (event_link_node e :: map event_link_node suffix)).
        cbn [dllseg]. Exists z. unfold store_event.
        change ((event_link_node e).(data)) with e.
        split_pure_spatial.
        -- cancel.
           repeat match goal with |- ?P ** _ |-- _ => progress cancel P end.
           cancel.
        -- split_pures; dump_pre_spatial; assumption.
      * dump_pre_spatial. rewrite <- Hlist. exact H1.
    + split_pures; dump_pre_spatial; assumption.
  - split_pures; dump_pre_spatial.
    + exists e. auto.
    + exact PreH1.
    + exact (proj2 PreH1).
    + reflexivity.
Qed. 

Lemma proof_of__EventDelete_which_implies_wit_2_split_goal_1 : _EventDelete_which_implies_wit_2_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__EventDelete_which_implies_wit_2_split_goal_spatial : _EventDelete_which_implies_wit_2_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold event_delete_pending_restore, event_pending_head. apply derivable1_wand_elim2.
Qed.

Lemma proof_of__EventDelete_which_implies_wit_2 : _EventDelete_which_implies_wit_2.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__EventDelete_which_implies_wit_2_split_goal_spatial.
Qed. 

Lemma proof_of__EventDelete_which_implies_wit_3_split_goal_1 : _EventDelete_which_implies_wit_3_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  pose proof (event_inspection_residual__inspect_continuations _ _ _ _ _ _ PreH2 PreH1 PreH4) as Hwp.
  destruct waiting as [|a tail]; [contradiction |].
  cbn [List.length Nat.eqb negb] in Hwp.
  apply MonadErrHoare.wp_bind in Hwp.
  exists (Crtos_RTrans checked); split.
  - change (forall st, Crtos_RTrans checked st <-> Crtos_RTrans checked st); tauto.
  - exact Hwp.
Qed.

Lemma proof_of__EventDelete_which_implies_wit_3_split_goal_2 : _EventDelete_which_implies_wit_3_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  exact (proj2 PreH2).
Qed.

Lemma proof_of__EventDelete_which_implies_wit_3 : _EventDelete_which_implies_wit_3.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__EventDelete_which_implies_wit_3_split_goal_1.
  - Goal_apply proof_of__EventDelete_which_implies_wit_3_split_goal_2.
Qed. 

Lemma proof_of__EventDelete_which_implies_wit_4_split_goal_1 : _EventDelete_which_implies_wit_4_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  destruct PreH1 as [states [Hseen Hwp]].
  unfold monadesafe_lib.safe in Hwp.
  apply (proj1 (MonadErrHoare.wp_ret tt _ states)) in Hwp.
  exists states; split; [exact Hseen | exact Hwp].
Qed.

Lemma proof_of__EventDelete_which_implies_wit_4 : _EventDelete_which_implies_wit_4.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__EventDelete_which_implies_wit_4_split_goal_1.
Qed. 

Lemma proof_of__EventDelete_which_implies_wit_5_split_goal_1 : _EventDelete_which_implies_wit_5_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  pose proof (event_inspection_residual__inspect_continuations _ _ _ _ _ _ PreH2 PreH1 PreH4) as Hwp.
  destruct waiting as [|a tail]; [| discriminate].
  cbn [List.length Nat.eqb negb] in Hwp.
  apply MonadErrHoare.wp_bind in Hwp.
  apply (proj1 (MonadErrHoare.wp_ret tt _ (Crtos_RTrans checked))) in Hwp.
  exists (Crtos_RTrans checked); split.
  - change (forall st, Crtos_RTrans checked st <-> Crtos_RTrans checked st); tauto.
  - exact Hwp.
Qed.

Lemma proof_of__EventDelete_which_implies_wit_5_split_goal_2 : _EventDelete_which_implies_wit_5_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  destruct waiting as [|a tail]; [| discriminate].
  destruct PreH2 as [_ [Hnonnull _]].
  destruct PreH1 as [e [Hin [Hp [Hid Hempty]]]].
  split; [exact Hnonnull |].
  exists e; repeat split; auto.
Qed.

Lemma proof_of__EventDelete_which_implies_wit_5 : _EventDelete_which_implies_wit_5.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__EventDelete_which_implies_wit_5_split_goal_1.
  - Goal_apply proof_of__EventDelete_which_implies_wit_5_split_goal_2.
Qed. 

Lemma proof_of__EventDelete_which_implies_wit_6 : _EventDelete_which_implies_wit_6.
Proof.
LLM_pre_process ltac:(lia || int_auto).
destruct PreH1 as [_ [Hnonnull [original [Hin [Hp [Hid Hempty]]]]]].
specialize (Hempty eq_refl).
pose proof Hin as Hsplit.
apply in_split in Hsplit as [prefix [suffix Hsplit]].
prop_apply_p (event_sequence_facts__id_snapshot sg_event_delete_at_oc locked original Hin).
Intros_p Hfacts.
destruct Hfacts as [Haddr [Hids [Hrange [Hquery Hremove]]]].
Exists prefix original suffix.
split_pure_spatial.
- unfold event_delete_id_restore.
apply (event_id_focus__id_snapshot sg_event_delete_at_oc locked original event_pre id_event_delete_at_oc Hin Hp Hid).
- split_pures; dump_pre_spatial; try assumption; try congruence; lia.
Qed.

Lemma proof_of__EventDelete_which_implies_wit_7_split_goal_spatial : _EventDelete_which_implies_wit_7_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold event_delete_id_restore.
  apply derivable1_wand_elim2.
Qed.

Lemma proof_of__EventDelete_which_implies_wit_7 : _EventDelete_which_implies_wit_7.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__EventDelete_which_implies_wit_7_split_goal_spatial.
Qed. 

Lemma proof_of__EventDelete_which_implies_wit_8_split_goal_spatial : _EventDelete_which_implies_wit_8_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv, event_inv, event_create_frame.
  Intros_p Hworld.
  Intros_p Hevent.
  unfold event_context in Hevent.
  destruct Hevent as [Hmanager Hevent].
  rewrite Hmanager.
  rewrite PreH1, map_app.
  simpl map.
  unfold event_link_node.
  rewrite PreH2.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed.

Lemma proof_of__EventDelete_which_implies_wit_8 : _EventDelete_which_implies_wit_8.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__EventDelete_which_implies_wit_8_split_goal_spatial.
Qed. 

Lemma proof_of__EventDelete_which_implies_wit_9_split_goal_spatial : _EventDelete_which_implies_wit_9_split_goal_spatial.
Proof.
 LLM_pre_process ltac:(lia || int_auto).
 apply event_retired_forget__reclaim.
Qed.

Lemma proof_of__EventDelete_which_implies_wit_9 : _EventDelete_which_implies_wit_9.
Proof.
 aggressive_pre_process.
 Goal_apply proof_of__EventDelete_which_implies_wit_9_split_goal_spatial.
Qed. 

