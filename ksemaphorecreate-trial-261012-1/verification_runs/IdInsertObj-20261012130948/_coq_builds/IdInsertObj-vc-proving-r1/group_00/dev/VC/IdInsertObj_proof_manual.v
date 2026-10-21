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
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold store_idmanager_allocated_unlinked.
  rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq,
    !SemaphoreCriticalViews.OSHeap_sep_eq, !OSHeap_ushort_eq.
  Intros.
  prop_apply (store_ushort_range (&(manager_pre # "IdManager" ->ₛ "id_max")) (idmax sm)).
  Intros. dump_pre_spatial. unfold idmanager_min_free_id in *; lia.
Qed.

Lemma proof_of_IdInsertObj_entail_wit_3_split_goal_2 : IdInsertObj_entail_wit_3_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold store_sem_id_detached.
  rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq.
  Intros. dump_pre_spatial. tauto.
Qed.

Lemma proof_of_IdInsertObj_entail_wit_3_split_goal_spatial : IdInsertObj_entail_wit_3_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hptr : forall p v, OSHeap (Task_C_Rules.store_ptr p v) = store_ptr p v).
  { intros p v. unfold Task_C_Rules.store_ptr, store_ptr.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq. f_equal.
    change (OSHeap (Task_C_Rules.store_4byte p v) = store_4byte p v).
    unfold Task_C_Rules.store_4byte, store_4byte.
    do 4 (rewrite SemaphoreCriticalViews.OSHeap_exp_eq; f_equal; apply functional_extensionality; intro).
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq,
      !SemaphoreCriticalViews.OSHeap_sep_eq,
      !SemaphoreCriticalViews.OSHeap_byte_eq. reflexivity. }
  unfold store_sem_id_detached.
  rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq,
    !SemaphoreCriticalViews.OSHeap_sep_eq, !OSHeap_ushort_eq, !Hptr.
  Intros. cancel.
Qed.

Lemma proof_of_IdInsertObj_entail_wit_3 : IdInsertObj_entail_wit_3.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of_IdInsertObj_entail_wit_3_split_goal_spatial.
  - Goal_apply proof_of_IdInsertObj_entail_wit_3_split_goal_1.
  - Goal_apply proof_of_IdInsertObj_entail_wit_3_split_goal_2.
Qed. 

Lemma proof_of_IdInsertObj_entail_wit_4_split_goal_spatial : IdInsertObj_entail_wit_4_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hptr : forall p v, OSHeap (Task_C_Rules.store_ptr p v) = store_ptr p v).
  { intros p v. unfold Task_C_Rules.store_ptr, store_ptr.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq. f_equal.
    change (OSHeap (Task_C_Rules.store_4byte p v) = store_4byte p v).
    unfold Task_C_Rules.store_4byte, store_4byte.
    do 4 (rewrite SemaphoreCriticalViews.OSHeap_exp_eq; f_equal; apply functional_extensionality; intro).
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq,
      !SemaphoreCriticalViews.OSHeap_sep_eq,
      !SemaphoreCriticalViews.OSHeap_byte_eq. reflexivity. }
  cancel (OSHeap (store_idmanager_allocated_unlinked sm before manager_pre id)).
  unfold store_sem_id_detached.
  rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq,
    !SemaphoreCriticalViews.OSHeap_sep_eq, !OSHeap_ushort_eq, !Hptr.
  split_pure_spatial.
  - cancel. Show.
  - split_pures; dump_pre_spatial; tauto.
Qed.

Lemma proof_of_IdInsertObj_entail_wit_4 : IdInsertObj_entail_wit_4.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_IdInsertObj_entail_wit_4_split_goal_spatial.
Qed. 

Lemma proof_of_IdInsertObj_return_wit_3 : IdInsertObj_return_wit_3.
Proof. Admitted.

Lemma proof_of_IdInsertObj_safety_wit_1 : IdInsertObj_safety_wit_1.
Proof. Admitted. 


Lemma proof_of_IdInsertObj_safety_wit_2 : IdInsertObj_safety_wit_2.
Proof. Admitted. 


Lemma proof_of_IdInsertObj_safety_wit_3 : IdInsertObj_safety_wit_3.
Proof. Admitted. 


Lemma proof_of_IdInsertObj_safety_wit_4 : IdInsertObj_safety_wit_4.
Proof. Admitted. 


Lemma proof_of_IdInsertObj_safety_wit_5 : IdInsertObj_safety_wit_5.
Proof. Admitted. 


Lemma proof_of_IdInsertObj_safety_wit_6 : IdInsertObj_safety_wit_6.
Proof. Admitted. 


Lemma proof_of_IdInsertObj_safety_wit_7 : IdInsertObj_safety_wit_7.
Proof. Admitted. 


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
