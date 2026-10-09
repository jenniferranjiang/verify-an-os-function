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
From CRTOS_Verify.VC Require Import InitDoubleLinkList_goal.
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

Lemma proof_of_InitDoubleLinkList_return_wit_1_split_goal_spatial : InitDoubleLinkList_return_wit_1_split_goal_spatial.
Proof.
  unfold InitDoubleLinkList_return_wit_1_split_goal_spatial.
  intros linklist_head_pre Hne.
  unfold store_sem_dll, semaphore_unit_empty.
  simpl.
  Exists linklist_head_pre linklist_head_pre.
  entailer!.
Qed.

Lemma proof_of_InitDoubleLinkList_return_wit_1 : InitDoubleLinkList_return_wit_1.
Proof.
  left.
  exact proof_of_InitDoubleLinkList_return_wit_1_split_goal_spatial.
Qed.
