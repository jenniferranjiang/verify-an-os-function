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
From CRTOS_Verify.VC Require Import IdInsertObj_goal.
From CRTOS_Verify.VC Require Import IdInsertObj_proof_auto.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.lib.idnode.
Require Import CRTOS_Verify.sem.SemaphorePure.
Require Import CRTOS_Verify.sem.SemaphoreRep.
Require Import CRTOS_Verify.sem.CrtosOSPure.
Require Import CRTOS_Verify.sem.CrtosOSProtocol.
Require Import CRTOS_Verify.sem.CrtosOSInv.
Require Import CRTOS_Verify.sem.SemaphoreCritical.
Require Import CRTOS_Verify.sem.SemaphoreCriticalViews.
Import IDNode.
Import Crtos_C_Rules.
Local Open Scope sac.

Lemma proof_of_IdInsertObj_entail_wit_3_split_goal_1 : IdInsertObj_entail_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of_IdInsertObj_entail_wit_3_split_goal_2 : IdInsertObj_entail_wit_3_split_goal_2.
Proof. Abort.

Lemma proof_of_IdInsertObj_entail_wit_3_split_goal_spatial : IdInsertObj_entail_wit_3_split_goal_spatial.
Proof. Abort.

Lemma proof_of_IdInsertObj_entail_wit_3 : IdInsertObj_entail_wit_3.
Proof. Admitted. 

Lemma proof_of_IdInsertObj_entail_wit_4_split_goal_spatial : IdInsertObj_entail_wit_4_split_goal_spatial.
Proof. Abort.

Lemma proof_of_IdInsertObj_entail_wit_4 : IdInsertObj_entail_wit_4.
Proof. Admitted. 

Lemma proof_of_IdInsertObj_return_wit_3 : IdInsertObj_return_wit_3.
Proof. Admitted.

Lemma proof_of_IdInsertObj_safety_wit_1 : IdInsertObj_safety_wit_1.
Proof.
  LLM_pre_process ltac:(lia).
Qed. 


Lemma proof_of_IdInsertObj_safety_wit_2 : IdInsertObj_safety_wit_2.
Proof.
  LLM_pre_process ltac:(lia).
Qed. 


Lemma proof_of_IdInsertObj_safety_wit_3 : IdInsertObj_safety_wit_3.
Proof. Admitted. 


Lemma proof_of_IdInsertObj_safety_wit_4 : IdInsertObj_safety_wit_4.
Proof.
  LLM_pre_process ltac:(lia).
Qed. 


Lemma proof_of_IdInsertObj_safety_wit_5 : IdInsertObj_safety_wit_5.
Proof.
  LLM_pre_process ltac:(lia).
Qed. 


Lemma proof_of_IdInsertObj_safety_wit_6 : IdInsertObj_safety_wit_6.
Proof. Admitted. 


Lemma proof_of_IdInsertObj_safety_wit_7 : IdInsertObj_safety_wit_7.
Proof.
  LLM_pre_process ltac:(lia).
Qed. 


Lemma proof_of_IdInsertObj_safety_wit_8 : IdInsertObj_safety_wit_8.
Proof. Admitted. 


Lemma proof_of_IdInsertObj_safety_wit_9 : IdInsertObj_safety_wit_9.
Proof. Admitted. 


Lemma proof_of_IdInsertObj_safety_wit_10 : IdInsertObj_safety_wit_10.
Proof. Admitted. 


Lemma proof_of_IdInsertObj_safety_wit_11 : IdInsertObj_safety_wit_11.
Proof. Admitted. 


Lemma proof_of_IdInsertObj_safety_wit_12 : IdInsertObj_safety_wit_12.
Proof. Admitted. 


Lemma proof_of_IdInsertObj_safety_wit_13 : IdInsertObj_safety_wit_13.
Proof. Admitted. 


Lemma proof_of_IdInsertObj_safety_wit_14 : IdInsertObj_safety_wit_14.
Proof. Admitted. 


Lemma proof_of_IdInsertObj_entail_wit_1 : IdInsertObj_entail_wit_1.
Proof. Admitted. 


Lemma proof_of_IdInsertObj_entail_wit_2 : IdInsertObj_entail_wit_2.
Proof. Admitted. 


Lemma proof_of_IdInsertObj_return_wit_1 : IdInsertObj_return_wit_1.
Proof. Admitted. 


Lemma proof_of_IdInsertObj_return_wit_2 : IdInsertObj_return_wit_2.
Proof. Admitted. 


Lemma proof_of_IdInsertObj_partial_solve_wit_1_pure : IdInsertObj_partial_solve_wit_1_pure.
Proof. Admitted. 


Lemma proof_of_IdInsertObj_partial_solve_wit_1 : IdInsertObj_partial_solve_wit_1.
Proof. Admitted. 


Lemma proof_of_IdInsertObj_partial_solve_wit_2_pure : IdInsertObj_partial_solve_wit_2_pure.
Proof. Admitted. 


Lemma proof_of_IdInsertObj_partial_solve_wit_2 : IdInsertObj_partial_solve_wit_2.
Proof. Admitted.
