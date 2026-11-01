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
From CRTOS_Verify.VC Require Import LinklistResumeAll_goal.
From CRTOS_Verify.VC Require Import LinklistResumeAll_proof_auto.
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
Require Import CRTOS_Verify.VC.LinklistResumeAll_lib.
Local Open Scope sac.

Lemma proof_of_LinklistResumeAll_entail_wit_1 : LinklistResumeAll_entail_wit_1.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_entail_wit_2 : LinklistResumeAll_entail_wit_2.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_return_wit_1_split_goal_1 : LinklistResumeAll_return_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_return_wit_1_split_goal_2 : LinklistResumeAll_return_wit_1_split_goal_2.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_return_wit_1_split_goal_3 : LinklistResumeAll_return_wit_1_split_goal_3.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_return_wit_1 : LinklistResumeAll_return_wit_1.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_1 : LinklistResumeAll_which_implies_wit_1.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_2_split_goal_spatial : LinklistResumeAll_which_implies_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_which_implies_wit_2 : LinklistResumeAll_which_implies_wit_2.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_3 : LinklistResumeAll_which_implies_wit_3.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_4_split_goal_spatial : LinklistResumeAll_which_implies_wit_4_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_which_implies_wit_4 : LinklistResumeAll_which_implies_wit_4.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_5_split_goal_spatial : LinklistResumeAll_which_implies_wit_5_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_which_implies_wit_5 : LinklistResumeAll_which_implies_wit_5.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_6 : LinklistResumeAll_which_implies_wit_6.
Proof. Admitted. 

Lemma proof_of_LinklistResumeAll_which_implies_wit_7_split_goal_spatial : LinklistResumeAll_which_implies_wit_7_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistResumeAll_which_implies_wit_7 : LinklistResumeAll_which_implies_wit_7.
Proof. Admitted.

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
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_safety_wit_5 : LinklistResumeAll_safety_wit_5.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_safety_wit_6 : LinklistResumeAll_safety_wit_6.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_safety_wit_7 : LinklistResumeAll_safety_wit_7.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_safety_wit_8 : LinklistResumeAll_safety_wit_8.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_safety_wit_9 : LinklistResumeAll_safety_wit_9.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_1 : LinklistResumeAll_partial_solve_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_2_pure : LinklistResumeAll_partial_solve_wit_2_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_2 : LinklistResumeAll_partial_solve_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_3 : LinklistResumeAll_partial_solve_wit_3.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_4 : LinklistResumeAll_partial_solve_wit_4.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_5_pure : LinklistResumeAll_partial_solve_wit_5_pure.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_5 : LinklistResumeAll_partial_solve_wit_5.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_6_pure : LinklistResumeAll_partial_solve_wit_6_pure.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_6 : LinklistResumeAll_partial_solve_wit_6.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_7_pure : LinklistResumeAll_partial_solve_wit_7_pure.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_7 : LinklistResumeAll_partial_solve_wit_7.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_8 : LinklistResumeAll_partial_solve_wit_8.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_9 : LinklistResumeAll_partial_solve_wit_9.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_10_pure : LinklistResumeAll_partial_solve_wit_10_pure.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_10 : LinklistResumeAll_partial_solve_wit_10.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_11 : LinklistResumeAll_partial_solve_wit_11.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_12 : LinklistResumeAll_partial_solve_wit_12.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_13_pure : LinklistResumeAll_partial_solve_wit_13_pure.
Proof. Admitted. 


Lemma proof_of_LinklistResumeAll_partial_solve_wit_13 : LinklistResumeAll_partial_solve_wit_13.
Proof. Admitted.
