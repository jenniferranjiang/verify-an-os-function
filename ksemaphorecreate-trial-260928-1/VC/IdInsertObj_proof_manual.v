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

Lemma proof_of_IdInsertObj_partial_solve_wit_3_pure_split_goal_1 : IdInsertObj_partial_solve_wit_3_pure_split_goal_1.
Proof.
  unfold IdInsertObj_partial_solve_wit_3_pure_split_goal_1.
  intros.
  pose proof (semaphore_first_free_some_bound_local
    stable before retval PreH12 PreH7) as Hbound.
  entailer!.
Qed.

Lemma proof_of_IdInsertObj_partial_solve_wit_3_pure : IdInsertObj_partial_solve_wit_3_pure.
Proof.
  right. exact proof_of_IdInsertObj_partial_solve_wit_3_pure_split_goal_1.
Qed.

Lemma proof_of_IdInsertObj_which_implies_wit_1_split_goal_spatial : IdInsertObj_which_implies_wit_1_split_goal_spatial.
Proof.
  unfold IdInsertObj_which_implies_wit_1_split_goal_spatial.
  intros. subst idnode_pre.
  unfold store_sem_id_node_zeroed, store_sem_id_node_zeroed_rest.
  unfold semaphore_layout_32_ok in PreH1.
  destruct PreH1 as
    (Hsize & Hidbase & Hidfield & Hidlink & Hidnext & Hidprev &
     Hnid & Hnlink & Hnnext & Hnprev & Hvalue & Hpend &
     Hpnext & Hpprev & Hnpnext & Hnpprev & Hreg &
     Hrnext & Hrprev & Hnrnext & Hnrprev).
  Intros. rewrite Hidfield, Hnid. entailer!.
Qed.

Lemma proof_of_IdInsertObj_which_implies_wit_1 : IdInsertObj_which_implies_wit_1.
Proof.
  left. exact proof_of_IdInsertObj_which_implies_wit_1_split_goal_spatial.
Qed.

Lemma proof_of_IdInsertObj_which_implies_wit_2_split_goal_spatial : IdInsertObj_which_implies_wit_2_split_goal_spatial.
Proof.
  unfold IdInsertObj_which_implies_wit_2_split_goal_spatial.
  intros. subst idnode_pre.
  pose proof PreH1 as Hstable.
  unfold SemaphoreStableContext in Hstable.
  destruct Hstable as (Hm & Hb & Hba & Hr & Hil & Hbc).
  unfold store_sem_id_node_zeroed_rest,
    store_sem_id_node_insert_ready.
  unfold semaphore_layout_32_ok in PreH2.
  destruct PreH2 as
    (Hsize & Hidbase & Hidfield & Hidlink & Hidnext & Hidprev &
     Hnid & Hnlink & Hnnext & Hnprev & Hvalue & Hpend &
     Hpnext & Hpprev & Hnpnext & Hnpprev & Hreg &
     Hrnext & Hrprev & Hnrnext & Hnrprev).
  rewrite unsigned_last_nbits_eq by
    (rewrite Hil in PreH5; unfold SEM_ID_MAX in PreH5; lia).
  rewrite Hidfield, Hnid. entailer!.
  sep_apply (store_ptr_undef_store_ptr
    (&(sem # "Semaphore" ->ₛ "id" .ₛ "link" .ₛ "node_prev")) 0).
  sep_apply (store_ptr_undef_store_ptr
    (&(sem # "Semaphore" ->ₛ "id" .ₛ "link" .ₛ "node_next")) 0).
  entailer!.
Qed.

Lemma proof_of_IdInsertObj_which_implies_wit_2 : IdInsertObj_which_implies_wit_2.
Proof.
  left. exact proof_of_IdInsertObj_which_implies_wit_2_split_goal_spatial.
Qed.
