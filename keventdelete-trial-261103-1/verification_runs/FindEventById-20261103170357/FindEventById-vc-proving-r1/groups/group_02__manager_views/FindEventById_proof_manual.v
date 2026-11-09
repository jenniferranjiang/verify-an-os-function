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
From CRTOS_Verify.VC Require Import FindEventById_goal.
From CRTOS_Verify.VC Require Import FindEventById_proof_auto.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.lib.IdModuleSpec CRTOS_Verify.lib.DoubleLinkListSpec.
Require Import CRTOS_Verify.lib.KEventDelete.
Import IDNode DLL MonadErr.
Require Import CRTOS_Verify.VC.FindEventById_lib.
Local Open Scope sac.


Lemma proof_of_FindEventById_safety_wit_1 : FindEventById_safety_wit_1.
Proof. Admitted. 

Lemma proof_of_FindEventById_safety_wit_2 : FindEventById_safety_wit_2.
Proof. Admitted. 

Lemma proof_of_FindEventById_safety_wit_3 : FindEventById_safety_wit_3.
Proof. Admitted. 

Lemma proof_of_FindEventById_safety_wit_4 : FindEventById_safety_wit_4.
Proof. Admitted. 

Lemma proof_of_FindEventById_safety_wit_5 : FindEventById_safety_wit_5.
Proof. Admitted. 

Lemma proof_of_FindEventById_safety_wit_6 : FindEventById_safety_wit_6.
Proof. Admitted. 

Lemma proof_of_FindEventById_safety_wit_7 : FindEventById_safety_wit_7.
Proof. Admitted. 

Lemma proof_of_FindEventById_safety_wit_8 : FindEventById_safety_wit_8.
Proof. Admitted. 

Lemma proof_of_FindEventById_safety_wit_9 : FindEventById_safety_wit_9.
Proof. Admitted. 

Lemma proof_of_FindEventById_safety_wit_10 : FindEventById_safety_wit_10.
Proof. Admitted. 

Lemma proof_of_FindEventById_safety_wit_11 : FindEventById_safety_wit_11.
Proof. Admitted. 

Lemma proof_of_FindEventById_return_wit_1 : FindEventById_return_wit_1.
Proof. Admitted. 

Lemma proof_of_FindEventById_return_wit_2 : FindEventById_return_wit_2.
Proof. Admitted. 

Lemma proof_of_FindEventById_partial_solve_wit_1 : FindEventById_partial_solve_wit_1.
Proof. Admitted. 

Lemma proof_of_FindEventById_partial_solve_wit_2 : FindEventById_partial_solve_wit_2.
Proof. Admitted. 

Lemma proof_of_FindEventById_partial_solve_wit_3_pure : FindEventById_partial_solve_wit_3_pure.
Proof. Admitted. 

Lemma proof_of_FindEventById_partial_solve_wit_3 : FindEventById_partial_solve_wit_3.
Proof. Admitted. 

Lemma proof_of_FindEventById_partial_solve_wit_4_pure : FindEventById_partial_solve_wit_4_pure.
Proof. Admitted. 

Lemma proof_of_FindEventById_partial_solve_wit_4 : FindEventById_partial_solve_wit_4.
Proof. Admitted. 

Lemma proof_of_FindEventById_partial_solve_wit_5_pure : FindEventById_partial_solve_wit_5_pure.
Proof. Admitted. 

Lemma proof_of_FindEventById_partial_solve_wit_5 : FindEventById_partial_solve_wit_5.
Proof. Admitted. 

Lemma proof_of_FindEventById_partial_solve_wit_6_pure : FindEventById_partial_solve_wit_6_pure.
Proof. Admitted. 

Lemma proof_of_FindEventById_partial_solve_wit_6 : FindEventById_partial_solve_wit_6.
Proof. Admitted. 

Lemma proof_of_FindEventById_partial_solve_wit_7_pure : FindEventById_partial_solve_wit_7_pure.
Proof. Admitted. 

Lemma proof_of_FindEventById_partial_solve_wit_7 : FindEventById_partial_solve_wit_7.
Proof. Admitted. 

Lemma proof_of_FindEventById_partial_solve_wit_8_pure : FindEventById_partial_solve_wit_8_pure.
Proof. Admitted. 

Lemma proof_of_FindEventById_partial_solve_wit_8 : FindEventById_partial_solve_wit_8.
Proof. Admitted. 

Lemma proof_of_FindEventById_partial_solve_wit_9_pure : FindEventById_partial_solve_wit_9_pure.
Proof. Admitted. 

Lemma proof_of_FindEventById_partial_solve_wit_9 : FindEventById_partial_solve_wit_9.
Proof. Admitted. 

Lemma proof_of_FindEventById_partial_solve_wit_10_pure : FindEventById_partial_solve_wit_10_pure.
Proof. Admitted. 

Lemma proof_of_FindEventById_partial_solve_wit_10 : FindEventById_partial_solve_wit_10.
Proof. Admitted. 

Lemma proof_of_FindEventById_which_implies_wit_1_split_goal_1 : FindEventById_which_implies_wit_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  apply addr_of_LE_var_not_zero.
Qed.

Lemma proof_of_FindEventById_which_implies_wit_1_split_goal_spatial : FindEventById_which_implies_wit_1_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv, event_inv, find_event_manager_frame, event_create_frame.
  Intros.
  pose proof (proj1 H0) as Hptr.
  rewrite Hptr.
  split_pure_spatial.
  - cancel.
  - dump_pre_spatial. exact H.
Qed.

Lemma proof_of_FindEventById_which_implies_wit_1 : FindEventById_which_implies_wit_1.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of_FindEventById_which_implies_wit_1_split_goal_spatial.
  - Goal_apply proof_of_FindEventById_which_implies_wit_1_split_goal_1.
Qed. 

Lemma proof_of_FindEventById_which_implies_wit_2_split_goal_1 : FindEventById_which_implies_wit_2_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  unfold event_lookup_result. left. split; [reflexivity |].
  unfold idmanager_query, event_manager in PreH1. simpl in PreH1.
  apply id_in_ids_false_iff in PreH1.
  intros e Hin Heq. apply PreH1. rewrite <- Heq.
  apply in_map. exact Hin.
Qed.

Lemma proof_of_FindEventById_which_implies_wit_2_split_goal_spatial : FindEventById_which_implies_wit_2_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold find_event_manager_frame, event_create_frame. Intros.
  pose proof (proj1 (os_wf_context sg_event_lookup_oc st_lock H)) as Hctx.
  pose proof (proj1 Hctx) as Hptr.
  unfold os_inv, event_inv. rewrite Hptr.
  split_pure_spatial.
  - cancel.
    cancel (task_inv sg_event_lookup_oc st_lock).
    cancel (tick_inv sg_event_lookup_oc st_lock).
    cancel (delay_inv sg_event_lookup_oc st_lock).
    cancel (assign_inv sg_event_lookup_oc st_lock).
    cancel store_prio_lookup_table.
    cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed.

Lemma proof_of_FindEventById_which_implies_wit_2 : FindEventById_which_implies_wit_2.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of_FindEventById_which_implies_wit_2_split_goal_spatial.
  - Goal_apply proof_of_FindEventById_which_implies_wit_2_split_goal_1.
Qed. 

Lemma proof_of_FindEventById_which_implies_wit_3_split_goal_1 : FindEventById_which_implies_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of_FindEventById_which_implies_wit_3_split_goal_2 : FindEventById_which_implies_wit_3_split_goal_2.
Proof. Abort.

Lemma proof_of_FindEventById_which_implies_wit_3 : FindEventById_which_implies_wit_3.
Proof. Admitted. 

Lemma proof_of_FindEventById_which_implies_wit_4 : FindEventById_which_implies_wit_4.
Proof. Admitted. 

Lemma proof_of_FindEventById_which_implies_wit_5_split_goal_1 : FindEventById_which_implies_wit_5_split_goal_1.
Proof. Abort.

Lemma proof_of_FindEventById_which_implies_wit_5_split_goal_2 : FindEventById_which_implies_wit_5_split_goal_2.
Proof. Abort.

Lemma proof_of_FindEventById_which_implies_wit_5 : FindEventById_which_implies_wit_5.
Proof. Admitted. 

