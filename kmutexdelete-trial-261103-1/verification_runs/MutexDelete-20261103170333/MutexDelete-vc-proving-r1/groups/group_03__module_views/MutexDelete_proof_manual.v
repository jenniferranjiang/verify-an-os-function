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
From KMutexDeleteProof.VC Require Import MutexDelete_goal.
From KMutexDeleteProof.VC Require Import MutexDelete_proof_auto.
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
Require Import KMutexDeleteProof.VC.MutexDelete_lib.
Local Open Scope sac.


Lemma proof_of__MutexDelete_safety_wit_1 : _MutexDelete_safety_wit_1.
Proof. Admitted. 

Lemma proof_of__MutexDelete_safety_wit_2 : _MutexDelete_safety_wit_2.
Proof. Admitted. 

Lemma proof_of__MutexDelete_safety_wit_3 : _MutexDelete_safety_wit_3.
Proof. Admitted. 

Lemma proof_of__MutexDelete_entail_wit_1 : _MutexDelete_entail_wit_1.
Proof. Admitted. 

Lemma proof_of__MutexDelete_entail_wit_2 : _MutexDelete_entail_wit_2.
Proof. Admitted. 

Lemma proof_of__MutexDelete_return_wit_1 : _MutexDelete_return_wit_1.
Proof. Admitted. 

Lemma proof_of__MutexDelete_partial_solve_wit_1_pure : _MutexDelete_partial_solve_wit_1_pure.
Proof. Admitted. 

Lemma proof_of__MutexDelete_partial_solve_wit_1 : _MutexDelete_partial_solve_wit_1.
Proof. Admitted. 

Lemma proof_of__MutexDelete_partial_solve_wit_2 : _MutexDelete_partial_solve_wit_2.
Proof. Admitted. 

Lemma proof_of__MutexDelete_partial_solve_wit_3_pure : _MutexDelete_partial_solve_wit_3_pure.
Proof. Admitted. 

Lemma proof_of__MutexDelete_partial_solve_wit_3 : _MutexDelete_partial_solve_wit_3.
Proof. Admitted. 

Lemma proof_of__MutexDelete_partial_solve_wit_4_pure : _MutexDelete_partial_solve_wit_4_pure.
Proof. Admitted. 

Lemma proof_of__MutexDelete_partial_solve_wit_4 : _MutexDelete_partial_solve_wit_4.
Proof. Admitted. 

Lemma proof_of__MutexDelete_partial_solve_wit_5_pure : _MutexDelete_partial_solve_wit_5_pure.
Proof. Admitted. 

Lemma proof_of__MutexDelete_partial_solve_wit_5 : _MutexDelete_partial_solve_wit_5.
Proof. Admitted. 

Lemma proof_of__MutexDelete_partial_solve_wit_6 : _MutexDelete_partial_solve_wit_6.
Proof. Admitted. 

Lemma proof_of__MutexDelete_partial_solve_wit_7 : _MutexDelete_partial_solve_wit_7.
Proof. Admitted. 

Lemma proof_of__MutexDelete_partial_solve_wit_8 : _MutexDelete_partial_solve_wit_8.
Proof. Admitted. 

Lemma proof_of__MutexDelete_partial_solve_wit_9_pure : _MutexDelete_partial_solve_wit_9_pure.
Proof. Admitted. 

Lemma proof_of__MutexDelete_partial_solve_wit_9 : _MutexDelete_partial_solve_wit_9.
Proof. Admitted. 

Lemma proof_of__MutexDelete_partial_solve_wit_10_pure : _MutexDelete_partial_solve_wit_10_pure.
Proof. Admitted. 

Lemma proof_of__MutexDelete_partial_solve_wit_10 : _MutexDelete_partial_solve_wit_10.
Proof. Admitted. 

Lemma proof_of__MutexDelete_partial_solve_wit_11 : _MutexDelete_partial_solve_wit_11.
Proof. Admitted. 

Lemma proof_of__MutexDelete_partial_solve_wit_12 : _MutexDelete_partial_solve_wit_12.
Proof. Admitted. 

Lemma proof_of__MutexDelete_partial_solve_wit_13_pure : _MutexDelete_partial_solve_wit_13_pure.
Proof. Admitted. 

Lemma proof_of__MutexDelete_partial_solve_wit_13 : _MutexDelete_partial_solve_wit_13.
Proof. Admitted. 

Lemma proof_of__MutexDelete_partial_solve_wit_14 : _MutexDelete_partial_solve_wit_14.
Proof. Admitted. 

Lemma proof_of__MutexDelete_partial_solve_wit_15 : _MutexDelete_partial_solve_wit_15.
Proof. Admitted. 

Lemma proof_of__MutexDelete_entail_wit_3_1_split_goal_1 : _MutexDelete_entail_wit_3_1_split_goal_1.
Proof. Abort.

Lemma proof_of__MutexDelete_entail_wit_3_1_split_goal_2 : _MutexDelete_entail_wit_3_1_split_goal_2.
Proof. Abort.

Lemma proof_of__MutexDelete_entail_wit_3_1_split_goal_spatial : _MutexDelete_entail_wit_3_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__MutexDelete_entail_wit_3_1 : _MutexDelete_entail_wit_3_1.
Proof. Admitted. 

Lemma proof_of__MutexDelete_entail_wit_3_2_split_goal_1 : _MutexDelete_entail_wit_3_2_split_goal_1.
Proof. Abort.

Lemma proof_of__MutexDelete_entail_wit_3_2_split_goal_2 : _MutexDelete_entail_wit_3_2_split_goal_2.
Proof. Abort.

Lemma proof_of__MutexDelete_entail_wit_3_2_split_goal_spatial : _MutexDelete_entail_wit_3_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__MutexDelete_entail_wit_3_2 : _MutexDelete_entail_wit_3_2.
Proof. Admitted. 

Lemma proof_of__MutexDelete_partial_solve_wit_2_pure_split_goal_1 : _MutexDelete_partial_solve_wit_2_pure_split_goal_1.
Proof. Abort.

Lemma proof_of__MutexDelete_partial_solve_wit_2_pure : _MutexDelete_partial_solve_wit_2_pure.
Proof. Admitted. 

Lemma proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_1 : _MutexDelete_partial_solve_wit_8_pure_split_goal_1.
Proof. Abort.

Lemma proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_2 : _MutexDelete_partial_solve_wit_8_pure_split_goal_2.
Proof. Abort.

Lemma proof_of__MutexDelete_partial_solve_wit_8_pure_split_goal_3 : _MutexDelete_partial_solve_wit_8_pure_split_goal_3.
Proof. Abort.

Lemma proof_of__MutexDelete_partial_solve_wit_8_pure : _MutexDelete_partial_solve_wit_8_pure.
Proof. Admitted. 

Lemma proof_of__MutexDelete_which_implies_wit_1_split_goal_1 : _MutexDelete_which_implies_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of__MutexDelete_which_implies_wit_1 : _MutexDelete_which_implies_wit_1.
Proof. Admitted. 

Lemma proof_of__MutexDelete_which_implies_wit_2_split_goal_1 : _MutexDelete_which_implies_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of__MutexDelete_which_implies_wit_2 : _MutexDelete_which_implies_wit_2.
Proof. Admitted. 

Lemma proof_of__MutexDelete_which_implies_wit_3 : _MutexDelete_which_implies_wit_3.
Proof. Admitted. 

Lemma proof_of__MutexDelete_which_implies_wit_4_split_goal_spatial : _MutexDelete_which_implies_wit_4_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold mutex_delete_id_restore.
  apply derivable1_wand_elim2.
Qed.

Lemma proof_of__MutexDelete_which_implies_wit_4 : _MutexDelete_which_implies_wit_4.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__MutexDelete_which_implies_wit_4_split_goal_spatial.
Qed. 

Lemma proof_of__MutexDelete_which_implies_wit_5_split_goal_spatial : _MutexDelete_which_implies_wit_5_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv, mutex_inv, mutex_delete_manager_frame, mutex_create_frame.
  Intros_p Hworld.
  Intros_p Hctx.
  assert (Hptr : mutex_manager_ptr (os_mutex_stable sg_assumed_environment) = &("k_mutex_id_manager")) by (unfold mutex_context in Hctx; tauto).
  rewrite Hptr.
  split_pure_spatial.
  - cancel (store_idmanager (mutex_manager_stable (os_mutex_stable sg_assumed_environment)) (mutex_manager (os_mutexes st_lock)) &("k_mutex_id_manager")).
    cancel (task_inv sg_assumed_environment st_lock).
    cancel (tick_inv sg_assumed_environment st_lock).
    cancel (delay_inv sg_assumed_environment st_lock).
    cancel (assign_inv sg_assumed_environment st_lock).
    cancel store_prio_lookup_table.
    cancel (store_zombie_queue (task_desc_map (os_tasks st_lock)) (os_zombie_head sg_assumed_environment) (zombie_queue st_lock)).
    cancel (os_recycler_slot sg_assumed_environment # Int |-> service_id (os_recycle st_lock)).
    cancel (IntArray.full (os_idle_array sg_assumed_environment) CORE_COUNT (map service_id (os_idle st_lock))).
    cancel (isrmanager_inv (os_isr_stable sg_assumed_environment) (os_isr st_lock)).
    cancel (exstatus_inv sg_assumed_environment st_lock).
    cancel (semaphore_inv (pure_suspend_sched_link (task_desc_map (os_tasks st_lock))) (os_semaphore_stable sg_assumed_environment) (os_semaphores st_lock)).
    cancel (event_inv (pure_suspend_sched_link (task_desc_map (os_tasks st_lock))) (os_event_stable sg_assumed_environment) (os_events st_lock)).
    cancel (store_dll (store_mutex (pure_suspend_sched_link (task_desc_map (os_tasks st_lock)))) (mutex_list_head (os_mutex_stable sg_assumed_environment)) (map mutex_link_node (os_mutexes st_lock))).
  - split_pures; dump_pre_spatial; assumption.
Qed.

Lemma proof_of__MutexDelete_which_implies_wit_5 : _MutexDelete_which_implies_wit_5.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__MutexDelete_which_implies_wit_5_split_goal_spatial.
Qed. 

Lemma proof_of__MutexDelete_which_implies_wit_6_split_goal_1 : _MutexDelete_which_implies_wit_6_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold mutex_delete_manager_frame.
  Intros_p Hctx.
  dump_pre_spatial.
  exact Hctx.
Qed.

Lemma proof_of__MutexDelete_which_implies_wit_6_split_goal_spatial : _MutexDelete_which_implies_wit_6_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold mutex_delete_manager_frame.
  Intros_p Hctx.
  rewrite PreH1, map_app.
  cbn [map mutex_link_node].
  unfold mutex_link_node at 2.
  rewrite PreH2.
  assert (Hhead : mutex_list_head (os_mutex_stable sg_assumed_environment) = &("k_mutex_list")) by (unfold mutex_context in Hctx; tauto).
  rewrite Hhead.
  cancel.
Qed.

Lemma proof_of__MutexDelete_which_implies_wit_6 : _MutexDelete_which_implies_wit_6.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__MutexDelete_which_implies_wit_6_split_goal_spatial.
  - Goal_apply proof_of__MutexDelete_which_implies_wit_6_split_goal_1.
Qed. 

Lemma proof_of__MutexDelete_which_implies_wit_7_split_goal_spatial : _MutexDelete_which_implies_wit_7_split_goal_spatial.
Proof. Abort.

Lemma proof_of__MutexDelete_which_implies_wit_7 : _MutexDelete_which_implies_wit_7.
Proof. Admitted. 

