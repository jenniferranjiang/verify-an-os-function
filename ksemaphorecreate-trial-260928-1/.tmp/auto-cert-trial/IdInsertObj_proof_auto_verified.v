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
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.sem.CrtosOSProtocol.
Import CrtosOS_C_Rules.
Require Import CRTOS_Verify.sem.SemaphorePure.
Require Import CRTOS_Verify.sem.SemaphoreRep.
Require Import CRTOS_Verify.VC.SemaphoreProofLocal.
Local Open Scope sac.

Lemma proof_of_IdInsertObj_safety_wit_1 : IdInsertObj_safety_wit_1.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of_IdInsertObj_safety_wit_2 : IdInsertObj_safety_wit_2.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of_IdInsertObj_safety_wit_3 : IdInsertObj_safety_wit_3.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of_IdInsertObj_safety_wit_4 : IdInsertObj_safety_wit_4.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of_IdInsertObj_safety_wit_5 : IdInsertObj_safety_wit_5.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of_IdInsertObj_safety_wit_6 : IdInsertObj_safety_wit_6.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of_IdInsertObj_safety_wit_7 : IdInsertObj_safety_wit_7.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of_IdInsertObj_safety_wit_8 : IdInsertObj_safety_wit_8.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of_IdInsertObj_safety_wit_9 : IdInsertObj_safety_wit_9.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of_IdInsertObj_safety_wit_10 : IdInsertObj_safety_wit_10.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of_IdInsertObj_safety_wit_11 : IdInsertObj_safety_wit_11.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of_IdInsertObj_return_wit_1 : IdInsertObj_return_wit_1.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of_IdInsertObj_return_wit_2 : IdInsertObj_return_wit_2.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of_IdInsertObj_partial_solve_wit_1_pure : IdInsertObj_partial_solve_wit_1_pure.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of_IdInsertObj_partial_solve_wit_1 : IdInsertObj_partial_solve_wit_1.
Proof.
  unfold IdInsertObj_partial_solve_wit_1,
    IdInsertObj_partial_solve_wit_1_aux.
  intros. entailer!.
Qed.

Lemma proof_of_IdInsertObj_partial_solve_wit_2_pure : IdInsertObj_partial_solve_wit_2_pure.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of_IdInsertObj_partial_solve_wit_2 : IdInsertObj_partial_solve_wit_2.
Proof.
  unfold IdInsertObj_partial_solve_wit_2,
    IdInsertObj_partial_solve_wit_2_aux.
  intros. entailer!.
Qed.

Lemma proof_of_IdInsertObj_partial_solve_wit_3 : IdInsertObj_partial_solve_wit_3.
Proof.
  unfold IdInsertObj_partial_solve_wit_3,
    IdInsertObj_partial_solve_wit_3_aux.
  intros.
  pose proof (semaphore_first_free_some_bound_local
    stable before retval PreH10 PreH5) as Hbound.
  entailer!.
Qed.

Lemma proof_of_IdInsertObj_partial_solve_wit_4_pure : IdInsertObj_partial_solve_wit_4_pure.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of_IdInsertObj_partial_solve_wit_4 : IdInsertObj_partial_solve_wit_4.
Proof.
  unfold IdInsertObj_partial_solve_wit_4,
    IdInsertObj_partial_solve_wit_4_aux.
  intros. entailer!.
Qed.
