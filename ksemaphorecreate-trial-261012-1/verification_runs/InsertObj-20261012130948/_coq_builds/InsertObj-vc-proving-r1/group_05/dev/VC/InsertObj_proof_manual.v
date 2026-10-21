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
From CRTOS_Verify.VC Require Import InsertObj_goal.
From CRTOS_Verify.VC Require Import InsertObj_proof_auto.
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

Lemma proof_of_InsertObj_entail_wit_1 : InsertObj_entail_wit_1.
Proof. Admitted. 

Lemma proof_of_InsertObj_entail_wit_2 : InsertObj_entail_wit_2.
Proof. Admitted. 

Lemma proof_of_InsertObj_entail_wit_3_1_split_goal_1 : InsertObj_entail_wit_3_1_split_goal_1.
Proof. Abort.

Lemma proof_of_InsertObj_entail_wit_3_1_split_goal_2 : InsertObj_entail_wit_3_1_split_goal_2.
Proof. Abort.

Lemma proof_of_InsertObj_entail_wit_3_1_split_goal_spatial : InsertObj_entail_wit_3_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of_InsertObj_entail_wit_3_1 : InsertObj_entail_wit_3_1.
Proof. Admitted. 

Lemma proof_of_InsertObj_entail_wit_3_2_split_goal_1 : InsertObj_entail_wit_3_2_split_goal_1.
Proof. Abort.

Lemma proof_of_InsertObj_entail_wit_3_2_split_goal_spatial : InsertObj_entail_wit_3_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of_InsertObj_entail_wit_3_2 : InsertObj_entail_wit_3_2.
Proof. Admitted. 

Lemma proof_of_InsertObj_return_wit_1_split_goal_spatial : InsertObj_return_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of_InsertObj_return_wit_1 : InsertObj_return_wit_1.
Proof. Admitted.

Lemma proof_of_InsertObj_safety_wit_1 : InsertObj_safety_wit_1.
Proof. Admitted. 


Lemma proof_of_InsertObj_safety_wit_2 : InsertObj_safety_wit_2.
Proof. Admitted. 


Lemma proof_of_InsertObj_safety_wit_3 : InsertObj_safety_wit_3.
Proof. Admitted. 


Lemma proof_of_InsertObj_safety_wit_4 : InsertObj_safety_wit_4.
Proof. Admitted. 


Lemma proof_of_InsertObj_safety_wit_5 : InsertObj_safety_wit_5.
Proof. Admitted. 


Lemma proof_of_InsertObj_safety_wit_6 : InsertObj_safety_wit_6.
Proof. Admitted. 


Lemma proof_of_InsertObj_safety_wit_7 : InsertObj_safety_wit_7.
Proof. Admitted. 


Lemma proof_of_InsertObj_safety_wit_8 : InsertObj_safety_wit_8.
Proof. Admitted. 


Lemma proof_of_InsertObj_safety_wit_9 : InsertObj_safety_wit_9.
Proof. Admitted. 


Lemma proof_of_InsertObj_safety_wit_10 : InsertObj_safety_wit_10.
Proof. Admitted. 


Lemma proof_of_InsertObj_partial_solve_wit_1_pure : InsertObj_partial_solve_wit_1_pure.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 


Lemma proof_of_InsertObj_partial_solve_wit_1 : InsertObj_partial_solve_wit_1.
Proof.
  LLM_pre_process ltac:(auto).
  LLM_pre_process ltac:(auto).
  all: match goal with |- ?G => idtac "CALL_PREPARATION_REMAINING" G end.
Qed. 


Lemma proof_of_InsertObj_partial_solve_wit_2_pure : InsertObj_partial_solve_wit_2_pure.
Proof.
  LLM_pre_process ltac:(auto).
Qed. 


Lemma proof_of_InsertObj_partial_solve_wit_2 : InsertObj_partial_solve_wit_2.
Proof.
  LLM_pre_process ltac:(auto).
  LLM_pre_process ltac:(auto).
Qed.
