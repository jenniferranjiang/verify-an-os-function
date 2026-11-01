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
From CRTOS_Verify.VC Require Import DoubleLinkListInsertNodeAfter_goal.
From CRTOS_Verify.VC Require Import DoubleLinkListInsertNodeAfter_proof_auto.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.sem.CrtosOSProtocol.
Import CrtosOS_C_Rules.
Require Import CRTOS_Verify.sem.SemaphoreRep.
Require Import CRTOS_Verify.VC.SemaphoreProofLocal.
Local Open Scope sac.

Lemma proof_of_DoubleLinkListInsertNodeAfter_return_wit_1_split_goal_spatial : DoubleLinkListInsertNodeAfter_return_wit_1_split_goal_spatial.
Proof.
  unfold DoubleLinkListInsertNodeAfter_return_wit_1_split_goal_spatial.
  intros A linklist_node_pre linklist_pre nodes payload store_payload Hhead Hnode.
  destruct nodes as [| node rest].
  - unfold sem_dll_front, store_sem_dll_insert_rest.
    simpl.
    unfold store_sem_dll.
    simpl.
    Exists linklist_node_pre linklist_node_pre linklist_pre.
    entailer!.
  - destruct node as [node_payload node_ptr].
    unfold sem_dll_front, store_sem_dll_insert_rest.
    simpl.
    Intros next last.
    unfold store_sem_dll.
    simpl.
    Exists linklist_node_pre last node_ptr.
    Exists next.
    entailer!.
Qed.

Lemma proof_of_DoubleLinkListInsertNodeAfter_return_wit_1 : DoubleLinkListInsertNodeAfter_return_wit_1.
Proof.
  left.
  exact proof_of_DoubleLinkListInsertNodeAfter_return_wit_1_split_goal_spatial.
Qed.

Lemma proof_of_DoubleLinkListInsertNodeAfter_which_implies_wit_1 : DoubleLinkListInsertNodeAfter_which_implies_wit_1.
Proof.
  unfold DoubleLinkListInsertNodeAfter_which_implies_wit_1.
  left.
  intros A nodes payload store_payload linklist linklist_node.
  destruct nodes as [| node rest].
  - unfold store_sem_dll, store_sem_standalone_node.
    simpl.
    Intros first last.
    entailer!.
    repeat sep_apply store_ptr_undef_store_ptr.
    Intros old_prev old_next.
    Exists old_next old_prev.
    unfold sem_dll_front, store_sem_dll_insert_rest.
    simpl.
    entailer!.
  - destruct node as [node_payload node_ptr].
    unfold store_sem_dll, store_sem_standalone_node.
    simpl.
    Intros first last next.
    entailer!.
    repeat sep_apply store_ptr_undef_store_ptr.
    Intros old_prev old_next.
    Exists old_next old_prev.
    unfold sem_dll_front, store_sem_dll_insert_rest.
    simpl.
    Exists next last.
    entailer!.
Qed.
