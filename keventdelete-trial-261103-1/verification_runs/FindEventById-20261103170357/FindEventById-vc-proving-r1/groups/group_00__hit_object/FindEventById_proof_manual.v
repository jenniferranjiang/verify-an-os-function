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
Proof. Abort.

Lemma proof_of_FindEventById_which_implies_wit_1_split_goal_spatial : FindEventById_which_implies_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of_FindEventById_which_implies_wit_1 : FindEventById_which_implies_wit_1.
Proof. Admitted. 

Lemma proof_of_FindEventById_which_implies_wit_2_split_goal_1 : FindEventById_which_implies_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of_FindEventById_which_implies_wit_2_split_goal_spatial : FindEventById_which_implies_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of_FindEventById_which_implies_wit_2 : FindEventById_which_implies_wit_2.
Proof. Admitted. 

Lemma proof_of_FindEventById_which_implies_wit_3_split_goal_1 : FindEventById_which_implies_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of_FindEventById_which_implies_wit_3_split_goal_2 : FindEventById_which_implies_wit_3_split_goal_2.
Proof. Abort.

Lemma proof_of_FindEventById_which_implies_wit_3 : FindEventById_which_implies_wit_3.
Proof. Admitted. 

Lemma proof_of_FindEventById_which_implies_wit_4 : FindEventById_which_implies_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  rename sg_event_lookup_oc into sg.
  rename st_lock into st.
  rename idnode into node.
  rename PreH1 into Hnode.
  prop_apply_p (event_found_member__hit_object
    (event_manager_stable (os_event_stable sg)) (os_events st)
    &("k_event_id_manager") node id).
  Intros_p Hmember. destruct Hmember as [e [Hin He]].
  unfold find_event_manager_frame.
  prop_apply_p (event_dll_member_nonzero__hit_object
    (pure_suspend_sched_link (task_desc_map (os_tasks st)))
    (event_list_head (os_event_stable sg)) (os_events st) e Hin).
  Intros_p Hnz.
  pose proof (f_equal idnode_id He) as Hid.
  pose proof (f_equal idnode_addr He) as Haddr.
  cbn [event_idnode idnode_id idnode_addr] in Hid, Haddr.
  sep_apply_l_atomic (store_idmanager_found_store_idmanager
    (event_manager_stable (os_event_stable sg)) (event_manager (os_events st))
    &("k_event_id_manager") node id).
  unfold event_create_frame. Intros. Exists (event_addr e).
  split_pure_spatial.
  - pose proof (proj1 (os_wf_context sg st H)) as Hctx.
    pose proof (proj1 Hctx) as Hmanager.
    unfold os_inv, event_inv. rewrite Hmanager. split_pure_spatial.
    + cancel.
      cancel (task_inv sg st). cancel (tick_inv sg st).
      cancel (delay_inv sg st). cancel (assign_inv sg st).
      cancel store_prio_lookup_table.
      cancel (store_zombie_queue (task_desc_map (os_tasks st))
        (os_zombie_head sg) (zombie_queue st)).
      cancel (os_recycler_slot sg # Int |-> service_id (os_recycle st)).
      cancel (IntArray.full (os_idle_array sg) CORE_COUNT (map service_id (os_idle st))).
      cancel (isrmanager_inv (os_isr_stable sg) (os_isr st)).
      cancel (exstatus_inv sg st). cancel.
    + split_pures; dump_pre_spatial; assumption.
  - split_pures; dump_pre_spatial.
    + exact Hnz.
    + symmetry; exact Haddr.
    + unfold event_delete_guard. split; [exact Hnz|].
      exists e. repeat split; auto; discriminate.
    + unfold event_lookup_result. right. split; [exact Hnz|].
      exists e. auto.
Qed. 

Lemma proof_of_FindEventById_which_implies_wit_5_split_goal_1 : FindEventById_which_implies_wit_5_split_goal_1.
Proof. Abort.

Lemma proof_of_FindEventById_which_implies_wit_5_split_goal_2 : FindEventById_which_implies_wit_5_split_goal_2.
Proof. Abort.

Lemma proof_of_FindEventById_which_implies_wit_5 : FindEventById_which_implies_wit_5.
Proof. Admitted. 

