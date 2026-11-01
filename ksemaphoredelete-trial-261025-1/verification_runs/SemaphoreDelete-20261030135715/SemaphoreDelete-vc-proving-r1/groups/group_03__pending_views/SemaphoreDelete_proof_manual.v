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
From CRTOS_Verify.VC Require Import SemaphoreDelete_goal.
From CRTOS_Verify.VC Require Import SemaphoreDelete_proof_auto.
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
Require Import CRTOS_Verify.VC.SemaphoreDelete_lib.
Local Open Scope sac.

Lemma proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_1 : _SemaphoreDelete_entail_wit_2_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_2 : _SemaphoreDelete_entail_wit_2_1_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_entail_wit_2_1_split_goal_spatial : _SemaphoreDelete_entail_wit_2_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_entail_wit_2_1 : _SemaphoreDelete_entail_wit_2_1.
Proof. Admitted. 

Lemma proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_1 : _SemaphoreDelete_entail_wit_2_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_2 : _SemaphoreDelete_entail_wit_2_2_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_entail_wit_2_2_split_goal_spatial : _SemaphoreDelete_entail_wit_2_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_entail_wit_2_2 : _SemaphoreDelete_entail_wit_2_2.
Proof. Admitted. 

Lemma proof_of__SemaphoreDelete_entail_wit_3_1_split_goal_1 : _SemaphoreDelete_entail_wit_3_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  intro Hnil. rewrite Hnil in PreH8. contradiction.
Qed.

Lemma proof_of__SemaphoreDelete_entail_wit_3_1 : _SemaphoreDelete_entail_wit_3_1.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreDelete_entail_wit_3_1_split_goal_1.
Qed. 

Lemma proof_of__SemaphoreDelete_entail_wit_3_2 : _SemaphoreDelete_entail_wit_3_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  apply map_eq_nil in PreH3.
  Exists st_lock.
  split_pure_spatial.
  - unfold delete_pending_restore, semaphore_pending_head.
    sep_apply_l_atomic (derivable1_wand_elim1
      (store_dll (pure_suspend_sched_link st_lock.(os_tasks).(task_desc_map))
        (&(((original.(semaphore_addr))) # "Semaphore" ->ₛ "pend_list"))
        (map sched_link_node original.(semaphore_pending_addrs)))
      (os_inv sg_outside_critical st_lock)).
    sepcon_assoc_change; cancel.
  - split_pures; dump_pre_spatial; try assumption; try reflexivity; try lia.
    + unfold semaphore_resume_all_effect. rewrite PreH3. reflexivity.
    + unfold semaphore_pending_nodes. exists original.
      repeat split; auto. rewrite PreH3. reflexivity.
Qed. 

Lemma proof_of__SemaphoreDelete_entail_wit_4_1 : _SemaphoreDelete_entail_wit_4_1.
Proof. Admitted. 

Lemma proof_of__SemaphoreDelete_entail_wit_4_2 : _SemaphoreDelete_entail_wit_4_2.
Proof. Admitted. 

Lemma proof_of__SemaphoreDelete_entail_wit_4_3 : _SemaphoreDelete_entail_wit_4_3.
Proof. Admitted. 

Lemma proof_of__SemaphoreDelete_entail_wit_4_4 : _SemaphoreDelete_entail_wit_4_4.
Proof. Admitted. 

Lemma proof_of__SemaphoreDelete_return_wit_2_split_goal_1 : _SemaphoreDelete_return_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_return_wit_2 : _SemaphoreDelete_return_wit_2.
Proof. Admitted. 

Lemma proof_of__SemaphoreDelete_partial_solve_wit_3_pure_split_goal_1 : _SemaphoreDelete_partial_solve_wit_3_pure_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_3_pure_split_goal_2 : _SemaphoreDelete_partial_solve_wit_3_pure_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_3_pure : _SemaphoreDelete_partial_solve_wit_3_pure.
Proof. Admitted. 

Lemma proof_of__SemaphoreDelete_partial_solve_wit_10_pure_split_goal_1 : _SemaphoreDelete_partial_solve_wit_10_pure_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_10_pure_split_goal_2 : _SemaphoreDelete_partial_solve_wit_10_pure_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_10_pure : _SemaphoreDelete_partial_solve_wit_10_pure.
Proof. Admitted. 

Lemma proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_1 : _SemaphoreDelete_partial_solve_wit_17_pure_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_2 : _SemaphoreDelete_partial_solve_wit_17_pure_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_17_pure_split_goal_3 : _SemaphoreDelete_partial_solve_wit_17_pure_split_goal_3.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_17_pure : _SemaphoreDelete_partial_solve_wit_17_pure.
Proof. Admitted. 

Lemma proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_1 : _SemaphoreDelete_partial_solve_wit_18_pure_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_2 : _SemaphoreDelete_partial_solve_wit_18_pure_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_18_pure_split_goal_3 : _SemaphoreDelete_partial_solve_wit_18_pure_split_goal_3.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_18_pure : _SemaphoreDelete_partial_solve_wit_18_pure.
Proof. Admitted. 

Lemma proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_spatial : _SemaphoreDelete_which_implies_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1 : _SemaphoreDelete_which_implies_wit_1.
Proof. Admitted. 

Lemma proof_of__SemaphoreDelete_which_implies_wit_2 : _SemaphoreDelete_which_implies_wit_2.
Proof. Admitted. 

Lemma proof_of__SemaphoreDelete_which_implies_wit_3_split_goal_spatial : _SemaphoreDelete_which_implies_wit_3_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  apply pending_dll_focus__pending_views; assumption.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_3 : _SemaphoreDelete_which_implies_wit_3.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreDelete_which_implies_wit_3_split_goal_spatial.
Qed. 

Lemma proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_1 : _SemaphoreDelete_which_implies_wit_4_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial. unfold semaphore_pending_nodes.
  exists original. repeat split; auto.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_spatial : _SemaphoreDelete_which_implies_wit_4_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold delete_pending_restore, semaphore_pending_head.
  apply derivable1_wand_elim2.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_4 : _SemaphoreDelete_which_implies_wit_4.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_spatial.
  - Goal_apply proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_1.
Qed. 

Lemma proof_of__SemaphoreDelete_which_implies_wit_5_split_goal_spatial : _SemaphoreDelete_which_implies_wit_5_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_5 : _SemaphoreDelete_which_implies_wit_5.
Proof. Admitted. 

Lemma proof_of__SemaphoreDelete_which_implies_wit_6_split_goal_spatial : _SemaphoreDelete_which_implies_wit_6_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_6 : _SemaphoreDelete_which_implies_wit_6.
Proof. Admitted. 

Lemma proof_of__SemaphoreDelete_which_implies_wit_7 : _SemaphoreDelete_which_implies_wit_7.
Proof. Admitted. 

Lemma proof_of__SemaphoreDelete_which_implies_wit_8_split_goal_1 : _SemaphoreDelete_which_implies_wit_8_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_8_split_goal_spatial : _SemaphoreDelete_which_implies_wit_8_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_8 : _SemaphoreDelete_which_implies_wit_8.
Proof. Admitted. 

Lemma proof_of__SemaphoreDelete_which_implies_wit_9_split_goal_spatial : _SemaphoreDelete_which_implies_wit_9_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_9 : _SemaphoreDelete_which_implies_wit_9.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_safety_wit_1 : _SemaphoreDelete_safety_wit_1.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_safety_wit_2 : _SemaphoreDelete_safety_wit_2.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_safety_wit_3 : _SemaphoreDelete_safety_wit_3.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_safety_wit_4 : _SemaphoreDelete_safety_wit_4.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_safety_wit_5 : _SemaphoreDelete_safety_wit_5.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_safety_wit_6 : _SemaphoreDelete_safety_wit_6.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_safety_wit_7 : _SemaphoreDelete_safety_wit_7.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_safety_wit_8 : _SemaphoreDelete_safety_wit_8.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_safety_wit_9 : _SemaphoreDelete_safety_wit_9.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_safety_wit_10 : _SemaphoreDelete_safety_wit_10.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_safety_wit_11 : _SemaphoreDelete_safety_wit_11.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_safety_wit_12 : _SemaphoreDelete_safety_wit_12.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_safety_wit_13 : _SemaphoreDelete_safety_wit_13.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_safety_wit_14 : _SemaphoreDelete_safety_wit_14.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_safety_wit_15 : _SemaphoreDelete_safety_wit_15.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_safety_wit_16 : _SemaphoreDelete_safety_wit_16.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_entail_wit_1 : _SemaphoreDelete_entail_wit_1.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_entail_wit_5_1 : _SemaphoreDelete_entail_wit_5_1.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_entail_wit_5_2 : _SemaphoreDelete_entail_wit_5_2.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_entail_wit_6_1 : _SemaphoreDelete_entail_wit_6_1.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_entail_wit_6_2 : _SemaphoreDelete_entail_wit_6_2.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_return_wit_1 : _SemaphoreDelete_return_wit_1.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_return_wit_3 : _SemaphoreDelete_return_wit_3.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_return_wit_4 : _SemaphoreDelete_return_wit_4.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_1 : _SemaphoreDelete_partial_solve_wit_1.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_2 : _SemaphoreDelete_partial_solve_wit_2.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_3 : _SemaphoreDelete_partial_solve_wit_3.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_4_pure : _SemaphoreDelete_partial_solve_wit_4_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_4 : _SemaphoreDelete_partial_solve_wit_4.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_5 : _SemaphoreDelete_partial_solve_wit_5.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_6_pure : _SemaphoreDelete_partial_solve_wit_6_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_6 : _SemaphoreDelete_partial_solve_wit_6.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_7_pure : _SemaphoreDelete_partial_solve_wit_7_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_7 : _SemaphoreDelete_partial_solve_wit_7.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_8 : _SemaphoreDelete_partial_solve_wit_8.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_9_pure : _SemaphoreDelete_partial_solve_wit_9_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_9 : _SemaphoreDelete_partial_solve_wit_9.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_10 : _SemaphoreDelete_partial_solve_wit_10.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_11_pure : _SemaphoreDelete_partial_solve_wit_11_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_11 : _SemaphoreDelete_partial_solve_wit_11.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_12_pure : _SemaphoreDelete_partial_solve_wit_12_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_12 : _SemaphoreDelete_partial_solve_wit_12.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_13_pure : _SemaphoreDelete_partial_solve_wit_13_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_13 : _SemaphoreDelete_partial_solve_wit_13.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_14_pure : _SemaphoreDelete_partial_solve_wit_14_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_14 : _SemaphoreDelete_partial_solve_wit_14.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_15_pure : _SemaphoreDelete_partial_solve_wit_15_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_15 : _SemaphoreDelete_partial_solve_wit_15.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_16_pure : _SemaphoreDelete_partial_solve_wit_16_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_16 : _SemaphoreDelete_partial_solve_wit_16.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_17 : _SemaphoreDelete_partial_solve_wit_17.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_18 : _SemaphoreDelete_partial_solve_wit_18.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_19_pure : _SemaphoreDelete_partial_solve_wit_19_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_19 : _SemaphoreDelete_partial_solve_wit_19.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_20_pure : _SemaphoreDelete_partial_solve_wit_20_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_20 : _SemaphoreDelete_partial_solve_wit_20.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_21_pure : _SemaphoreDelete_partial_solve_wit_21_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_21 : _SemaphoreDelete_partial_solve_wit_21.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_22_pure : _SemaphoreDelete_partial_solve_wit_22_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_22 : _SemaphoreDelete_partial_solve_wit_22.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_23 : _SemaphoreDelete_partial_solve_wit_23.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_24 : _SemaphoreDelete_partial_solve_wit_24.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_25 : _SemaphoreDelete_partial_solve_wit_25.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_26 : _SemaphoreDelete_partial_solve_wit_26.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_27_pure : _SemaphoreDelete_partial_solve_wit_27_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_27 : _SemaphoreDelete_partial_solve_wit_27.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_28_pure : _SemaphoreDelete_partial_solve_wit_28_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_28 : _SemaphoreDelete_partial_solve_wit_28.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_29 : _SemaphoreDelete_partial_solve_wit_29.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_30 : _SemaphoreDelete_partial_solve_wit_30.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_31 : _SemaphoreDelete_partial_solve_wit_31.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_32 : _SemaphoreDelete_partial_solve_wit_32.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_33_pure : _SemaphoreDelete_partial_solve_wit_33_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreDelete_partial_solve_wit_33 : _SemaphoreDelete_partial_solve_wit_33.
Proof. Admitted.
