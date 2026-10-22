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
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_entail_wit_2_split_goal_1 : _SemaphoreCreate_entail_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_2_split_goal_2 : _SemaphoreCreate_entail_wit_2_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_2_split_goal_3 : _SemaphoreCreate_entail_wit_2_split_goal_3.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_2_split_goal_spatial : _SemaphoreCreate_entail_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_2 : _SemaphoreCreate_entail_wit_2.
Proof. Admitted. 

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
  - Show. Goal_apply proof_of__SemaphoreCreate_entail_wit_3_split_goal_1.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_3_split_goal_2.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_3_split_goal_3.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_3_split_goal_spatial.
Qed. 

Lemma proof_of__SemaphoreCreate_entail_wit_4_1_split_goal_1 : _SemaphoreCreate_entail_wit_4_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_4_1_split_goal_spatial : _SemaphoreCreate_entail_wit_4_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_4_1 : _SemaphoreCreate_entail_wit_4_1.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_1 : _SemaphoreCreate_entail_wit_4_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_2 : _SemaphoreCreate_entail_wit_4_2_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_4_2_split_goal_spatial : _SemaphoreCreate_entail_wit_4_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_4_2 : _SemaphoreCreate_entail_wit_4_2.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_entail_wit_5 : _SemaphoreCreate_entail_wit_5.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_entail_wit_6_split_goal_spatial : _SemaphoreCreate_entail_wit_6_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_6 : _SemaphoreCreate_entail_wit_6.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_entail_wit_7_split_goal_1 : _SemaphoreCreate_entail_wit_7_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_7_split_goal_spatial : _SemaphoreCreate_entail_wit_7_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_7 : _SemaphoreCreate_entail_wit_7.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_return_wit_1_split_goal_1 : _SemaphoreCreate_return_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_return_wit_1 : _SemaphoreCreate_return_wit_1.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_return_wit_2_split_goal_1 : _SemaphoreCreate_return_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_return_wit_2 : _SemaphoreCreate_return_wit_2.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_return_wit_3_split_goal_1 : _SemaphoreCreate_return_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_return_wit_3 : _SemaphoreCreate_return_wit_3.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1 : _SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_6_pure : _SemaphoreCreate_partial_solve_wit_6_pure.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_partial_solve_wit_8_pure_split_goal_1 : _SemaphoreCreate_partial_solve_wit_8_pure_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_8_pure : _SemaphoreCreate_partial_solve_wit_8_pure.
Proof. Admitted.

Lemma proof_of__SemaphoreCreate_safety_wit_1 : _SemaphoreCreate_safety_wit_1.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_2 : _SemaphoreCreate_safety_wit_2.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_3 : _SemaphoreCreate_safety_wit_3.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_4 : _SemaphoreCreate_safety_wit_4.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_5 : _SemaphoreCreate_safety_wit_5.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_6 : _SemaphoreCreate_safety_wit_6.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_7 : _SemaphoreCreate_safety_wit_7.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_8 : _SemaphoreCreate_safety_wit_8.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_9 : _SemaphoreCreate_safety_wit_9.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_10 : _SemaphoreCreate_safety_wit_10.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_11 : _SemaphoreCreate_safety_wit_11.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_12 : _SemaphoreCreate_safety_wit_12.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_13 : _SemaphoreCreate_safety_wit_13.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_14 : _SemaphoreCreate_safety_wit_14.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_15 : _SemaphoreCreate_safety_wit_15.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_16 : _SemaphoreCreate_safety_wit_16.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_17 : _SemaphoreCreate_safety_wit_17.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_1_pure : _SemaphoreCreate_partial_solve_wit_1_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_1 : _SemaphoreCreate_partial_solve_wit_1.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_2_pure : _SemaphoreCreate_partial_solve_wit_2_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_2 : _SemaphoreCreate_partial_solve_wit_2.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_3 : _SemaphoreCreate_partial_solve_wit_3.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_4 : _SemaphoreCreate_partial_solve_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  split_pure_spatial; [cancel | split_pures; dump_pre_spatial; auto].
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_5 : _SemaphoreCreate_partial_solve_wit_5.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_6 : _SemaphoreCreate_partial_solve_wit_6.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_7 : _SemaphoreCreate_partial_solve_wit_7.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_8 : _SemaphoreCreate_partial_solve_wit_8.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_9_pure : _SemaphoreCreate_partial_solve_wit_9_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_9 : _SemaphoreCreate_partial_solve_wit_9.
Proof. Admitted.
