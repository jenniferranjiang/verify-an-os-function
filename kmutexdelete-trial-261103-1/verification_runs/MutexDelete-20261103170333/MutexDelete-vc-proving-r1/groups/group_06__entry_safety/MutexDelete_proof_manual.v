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
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__MutexDelete_safety_wit_2 : _MutexDelete_safety_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__MutexDelete_safety_wit_3 : _MutexDelete_safety_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

Lemma proof_of__MutexDelete_entail_wit_1 : _MutexDelete_entail_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  exfalso.
  unfold mutex_delete_live in PreH2.
  destruct PreH2 as [Hnonzero _].
  exact (Hnonzero PreH1).
Qed. 

Lemma proof_of__MutexDelete_entail_wit_2 : _MutexDelete_entail_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 

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
Proof. Abort.

Lemma proof_of__MutexDelete_which_implies_wit_4 : _MutexDelete_which_implies_wit_4.
Proof. Admitted. 

Lemma proof_of__MutexDelete_which_implies_wit_5_split_goal_spatial : _MutexDelete_which_implies_wit_5_split_goal_spatial.
Proof. Abort.

Lemma proof_of__MutexDelete_which_implies_wit_5 : _MutexDelete_which_implies_wit_5.
Proof. Admitted. 

Lemma proof_of__MutexDelete_which_implies_wit_6_split_goal_1 : _MutexDelete_which_implies_wit_6_split_goal_1.
Proof. Abort.

Lemma proof_of__MutexDelete_which_implies_wit_6_split_goal_spatial : _MutexDelete_which_implies_wit_6_split_goal_spatial.
Proof. Abort.

Lemma proof_of__MutexDelete_which_implies_wit_6 : _MutexDelete_which_implies_wit_6.
Proof. Admitted. 

Lemma proof_of__MutexDelete_which_implies_wit_7_split_goal_spatial : _MutexDelete_which_implies_wit_7_split_goal_spatial.
Proof. Abort.

Lemma proof_of__MutexDelete_which_implies_wit_7 : _MutexDelete_which_implies_wit_7.
Proof. Admitted. 

