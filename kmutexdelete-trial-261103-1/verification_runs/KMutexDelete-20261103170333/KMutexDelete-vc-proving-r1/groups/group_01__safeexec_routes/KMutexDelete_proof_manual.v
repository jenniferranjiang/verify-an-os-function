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
From KMutexDeleteProof.VC Require Import KMutexDelete_goal.
From KMutexDeleteProof.VC Require Import KMutexDelete_proof_auto.
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
Require Import KMutexDeleteProof.VC.KMutexDelete_lib.
Local Open Scope sac.


Lemma proof_of_KMutexDelete_safety_wit_1 : KMutexDelete_safety_wit_1.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_safety_wit_2 : KMutexDelete_safety_wit_2.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_safety_wit_3 : KMutexDelete_safety_wit_3.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_safety_wit_4 : KMutexDelete_safety_wit_4.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_safety_wit_5 : KMutexDelete_safety_wit_5.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_safety_wit_6 : KMutexDelete_safety_wit_6.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_safety_wit_7 : KMutexDelete_safety_wit_7.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_safety_wit_8 : KMutexDelete_safety_wit_8.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_safety_wit_9 : KMutexDelete_safety_wit_9.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_safety_wit_10 : KMutexDelete_safety_wit_10.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_entail_wit_1 : KMutexDelete_entail_wit_1.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_return_wit_4 : KMutexDelete_return_wit_4.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_partial_solve_wit_1 : KMutexDelete_partial_solve_wit_1.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_partial_solve_wit_2 : KMutexDelete_partial_solve_wit_2.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_partial_solve_wit_3 : KMutexDelete_partial_solve_wit_3.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_partial_solve_wit_4 : KMutexDelete_partial_solve_wit_4.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_partial_solve_wit_5 : KMutexDelete_partial_solve_wit_5.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_partial_solve_wit_6 : KMutexDelete_partial_solve_wit_6.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_partial_solve_wit_7 : KMutexDelete_partial_solve_wit_7.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_partial_solve_wit_8 : KMutexDelete_partial_solve_wit_8.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_partial_solve_wit_9_pure : KMutexDelete_partial_solve_wit_9_pure.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_partial_solve_wit_9 : KMutexDelete_partial_solve_wit_9.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_partial_solve_wit_10 : KMutexDelete_partial_solve_wit_10.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_partial_solve_wit_11 : KMutexDelete_partial_solve_wit_11.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  LLM_pre_process ltac:(lia || int_auto).
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; try assumption.
    + subst retval. assumption.
    + subst retval. eapply (mutex_delete_found_continuation__safeexec_routes id_pre before_assumed_environment st_lock (mutex_addr original) (mutex_id original) X_assumed_environment); [lia|eassumption|eassumption|eassumption|eassumption].
Qed. 

Lemma proof_of_KMutexDelete_return_wit_1_split_goal_1 : KMutexDelete_return_wit_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  eapply (mutex_delete_void_continuation__safeexec_routes id_pre before_assumed_environment st_lock X_assumed_environment); [lia|eassumption].
Qed.

Lemma proof_of_KMutexDelete_return_wit_1 : KMutexDelete_return_wit_1.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_KMutexDelete_return_wit_1_split_goal_1.
Qed. 

Lemma proof_of_KMutexDelete_return_wit_2_split_goal_1 : KMutexDelete_return_wit_2_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  eapply (mutex_delete_void_continuation__safeexec_routes id_pre before_assumed_environment st_lock X_assumed_environment); [lia|eassumption].
Qed.

Lemma proof_of_KMutexDelete_return_wit_2 : KMutexDelete_return_wit_2.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_KMutexDelete_return_wit_2_split_goal_1.
Qed. 

Lemma proof_of_KMutexDelete_return_wit_3_split_goal_1 : KMutexDelete_return_wit_3_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold abs_mutex_delete in PreH4 at 1. prog_nf in PreH4.
  assert (Htest : (Z.ltb id_pre 0) = true) by (apply Z.ltb_lt; lia).
  rewrite Htest in PreH4. exact PreH4.
Qed.

Lemma proof_of_KMutexDelete_return_wit_3 : KMutexDelete_return_wit_3.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_KMutexDelete_return_wit_3_split_goal_1.
Qed. 

Lemma proof_of_KMutexDelete_partial_solve_wit_3_pure_split_goal_1 : KMutexDelete_partial_solve_wit_3_pure_split_goal_1.
Proof. Abort.

Lemma proof_of_KMutexDelete_partial_solve_wit_3_pure_split_goal_2 : KMutexDelete_partial_solve_wit_3_pure_split_goal_2.
Proof. Abort.

Lemma proof_of_KMutexDelete_partial_solve_wit_3_pure : KMutexDelete_partial_solve_wit_3_pure.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_partial_solve_wit_6_pure_split_goal_1 : KMutexDelete_partial_solve_wit_6_pure_split_goal_1.
Proof. Abort.

Lemma proof_of_KMutexDelete_partial_solve_wit_6_pure : KMutexDelete_partial_solve_wit_6_pure.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_partial_solve_wit_7_pure_split_goal_1 : KMutexDelete_partial_solve_wit_7_pure_split_goal_1.
Proof. Abort.

Lemma proof_of_KMutexDelete_partial_solve_wit_7_pure : KMutexDelete_partial_solve_wit_7_pure.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_partial_solve_wit_10_pure_split_goal_1 : KMutexDelete_partial_solve_wit_10_pure_split_goal_1.
Proof. Abort.

Lemma proof_of_KMutexDelete_partial_solve_wit_10_pure : KMutexDelete_partial_solve_wit_10_pure.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_partial_solve_wit_11_pure_split_goal_1 : KMutexDelete_partial_solve_wit_11_pure_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial. subst retval.
  eapply (mutex_delete_found_continuation__safeexec_routes id_pre before_assumed_environment st_lock (mutex_addr original) (mutex_id original) X_assumed_environment); [lia|eassumption|eassumption|eassumption|eassumption].
Qed.

Lemma proof_of_KMutexDelete_partial_solve_wit_11_pure : KMutexDelete_partial_solve_wit_11_pure.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_KMutexDelete_partial_solve_wit_11_pure_split_goal_1.
Qed. 

Lemma proof_of_KMutexDelete_which_implies_wit_1_split_goal_spatial : KMutexDelete_which_implies_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of_KMutexDelete_which_implies_wit_1 : KMutexDelete_which_implies_wit_1.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_which_implies_wit_2_split_goal_spatial : KMutexDelete_which_implies_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of_KMutexDelete_which_implies_wit_2 : KMutexDelete_which_implies_wit_2.
Proof. Admitted. 

Lemma proof_of_KMutexDelete_which_implies_wit_3 : KMutexDelete_which_implies_wit_3.
Proof. Admitted. 

