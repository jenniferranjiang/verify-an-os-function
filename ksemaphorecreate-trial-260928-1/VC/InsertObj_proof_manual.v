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
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.sem.CrtosOSProtocol.
Import CrtosOS_C_Rules.
Require Import Coq.Lists.List.
Require Import CRTOS_Verify.sem.SemaphorePure.
Require Import CRTOS_Verify.sem.SemaphoreRep.
Require Import CRTOS_Verify.VC.SemaphoreProofLocal.
Local Open Scope sac.

Lemma proof_of_InsertObj_safety_wit_5_split_goal_1 : InsertObj_safety_wit_5_split_goal_1.
Proof.
  unfold InsertObj_safety_wit_5_split_goal_1. intros. entailer!.
Qed.

Lemma proof_of_InsertObj_safety_wit_5_split_goal_2 : InsertObj_safety_wit_5_split_goal_2.
Proof.
  unfold InsertObj_safety_wit_5_split_goal_2. intros.
  unfold SemaphoreStableContext in PreH9.
  destruct PreH9 as (Hm & Hb & Hba & Hr & Hil & Hbc).
  unfold SEM_BUCKET_COUNT in Hbc. entailer!.
Qed.

Lemma proof_of_InsertObj_safety_wit_5 : InsertObj_safety_wit_5.
Proof.
  left. intros.
  unfold SemaphoreStableContext in PreH9.
  destruct PreH9 as (Hm & Hb & Hba & Hr & Hil & Hbc).
  unfold SEM_BUCKET_COUNT in Hbc. entailer!.
Qed.

Lemma proof_of_InsertObj_return_wit_1_split_goal_spatial : InsertObj_return_wit_1_split_goal_spatial.
Proof.
  unfold InsertObj_return_wit_1_split_goal_spatial.
  intros. subst manager_pre. subst idnode_pre.
  pose proof PreH10 as Hstable.
  unfold SemaphoreStableContext in Hstable.
  destruct Hstable as (Hm & Hb & Hba & Hr & Hil & Hcount0).
  unfold SEM_BUCKET_COUNT in Hcount0.
  assert (Hcount : semaphore_bucket_count stable = 16)
    by exact Hcount0.
  pose proof PreH11 as Hlayout.
  unfold semaphore_layout_32_ok in Hlayout.
  destruct Hlayout as
    (Hsize & Hidbase & Hidfield & Hidlink & Hidnext & Hidprev &
     Hnid & Hnlink & Hnnext & Hnprev & Hvalue & Hpend &
     Hpnext & Hpprev & Hnpnext & Hnpprev & Hreg &
     Hrnext & Hrprev & Hnrnext & Hnrprev).
  pose proof (eq_trans Hidlink (eq_sym Hnlink)) as Hnodeeq.
  rewrite !Z.rem_mod_nonneg by lia. rewrite Hcount. rewrite Hnodeeq.
  apply store_semaphore_id_manager_reserve_none_insert_local.
  exact Hcount.
Qed.

Lemma proof_of_InsertObj_return_wit_1 : InsertObj_return_wit_1.
Proof.
  right. exact proof_of_InsertObj_return_wit_1_split_goal_spatial.
Qed.

Lemma proof_of_InsertObj_return_wit_2_split_goal_spatial : InsertObj_return_wit_2_split_goal_spatial.
Proof.
  unfold InsertObj_return_wit_2_split_goal_spatial.
  intros. subst manager_pre. subst idnode_pre.
  pose proof PreH12 as Hstable.
  unfold SemaphoreStableContext in Hstable.
  destruct Hstable as (Hm & Hb & Hba & Hr & Hil & Hcount0).
  unfold SEM_BUCKET_COUNT in Hcount0.
  assert (Hcount : semaphore_bucket_count stable = 16)
    by exact Hcount0.
  pose proof PreH13 as Hlayout.
  unfold semaphore_layout_32_ok in Hlayout.
  destruct Hlayout as
    (Hsize & Hidbase & Hidfield & Hidlink & Hidnext & Hidprev &
     Hnid & Hnlink & Hnnext & Hnprev & Hvalue & Hpend &
     Hpnext & Hpprev & Hnpnext & Hnpprev & Hreg &
     Hrnext & Hrprev & Hnrnext & Hnrprev).
  pose proof (eq_trans Hidlink (eq_sym Hnlink)) as Hnodeeq.
  rewrite !Z.rem_mod_nonneg by lia. rewrite Hcount. rewrite Hnodeeq.
  apply store_semaphore_id_manager_reserve_some_insert_local.
  exact Hcount.
Qed.

Lemma proof_of_InsertObj_return_wit_2 : InsertObj_return_wit_2.
Proof.
  right. exact proof_of_InsertObj_return_wit_2_split_goal_spatial.
Qed.

Lemma proof_of_InsertObj_which_implies_wit_1_split_goal_spatial : InsertObj_which_implies_wit_1_split_goal_spatial.
Proof.
  unfold InsertObj_which_implies_wit_1_split_goal_spatial.
  intros. subst manager_pre.
  unfold store_sem_manager_id_allocated. Intros. entailer!.
Qed.

Lemma proof_of_InsertObj_which_implies_wit_1 : InsertObj_which_implies_wit_1.
Proof.
  left. exact proof_of_InsertObj_which_implies_wit_1_split_goal_spatial.
Qed.

Lemma proof_of_InsertObj_which_implies_wit_2_split_goal_1 : InsertObj_which_implies_wit_2_split_goal_1.
Proof.
  unfold InsertObj_which_implies_wit_2_split_goal_1.
  intros. subst idnode_pre.
  unfold store_sem_id_node_insert_ready. Intros.
  unfold semaphore_layout_32_ok in PreH2.
  destruct PreH2 as
    (Hsize & Hidbase & Hidfield & Hidlink & Hidnext & Hidprev &
     Hnid & Hnlink & Hnnext & Hnprev & Hvalue & Hpend &
     Hpnext & Hpprev & Hnpnext & Hnpprev & Hreg &
     Hrnext & Hrprev & Hnrnext & Hnrprev).
  sep_apply (valid_store_ushort
    (&(sem # "Semaphore" ->ₛ "id" .ₛ "id")) id).
  Intros. rewrite Hidlink. rewrite Hnid in H0.
  unfold isvalidptr_short in H0. entailer!.
Qed.

Lemma proof_of_InsertObj_which_implies_wit_2_split_goal_2 : InsertObj_which_implies_wit_2_split_goal_2.
Proof.
  unfold InsertObj_which_implies_wit_2_split_goal_2. intros.
  pose proof PreH1 as Hstable.
  unfold SemaphoreStableContext in Hstable.
  destruct Hstable as (Hm & Hb & Hba & Hr & Hil & Hbc).
  unfold store_sem_id_node_insert_ready. Intros.
  rewrite Hil. entailer!.
Qed.

Lemma proof_of_InsertObj_which_implies_wit_2_split_goal_3 : InsertObj_which_implies_wit_2_split_goal_3.
Proof.
  unfold InsertObj_which_implies_wit_2_split_goal_3. intros.
  unfold store_sem_id_node_insert_ready. Intros. entailer!.
Qed.

Lemma proof_of_InsertObj_which_implies_wit_2_split_goal_4 : InsertObj_which_implies_wit_2_split_goal_4.
Proof.
  unfold InsertObj_which_implies_wit_2_split_goal_4. intros.
  unfold store_sem_id_node_insert_ready. Intros. entailer!.
Qed.

Lemma proof_of_InsertObj_which_implies_wit_2_split_goal_spatial : InsertObj_which_implies_wit_2_split_goal_spatial.
Proof.
  unfold InsertObj_which_implies_wit_2_split_goal_spatial.
  intros. subst idnode_pre.
  unfold store_sem_id_node_insert_ready,
    store_sem_id_node_insert_ready_rest.
  unfold semaphore_layout_32_ok in PreH2.
  destruct PreH2 as
    (Hsize & Hidbase & Hidfield & Hidlink & Hidnext & Hidprev &
     Hnid & Hnlink & Hnnext & Hnprev & Hvalue & Hpend &
     Hpnext & Hpprev & Hnpnext & Hnpprev & Hreg &
     Hrnext & Hrprev & Hnrnext & Hnrprev).
  Intros. rewrite Hidfield, Hnid. entailer!.
Qed.

Lemma proof_of_InsertObj_which_implies_wit_2 : InsertObj_which_implies_wit_2.
Proof.
  unfold InsertObj_which_implies_wit_2. right. intros.
  apply _derivable1_andp_intros.
  - apply _derivable1_andp_intros.
    + apply _derivable1_andp_intros.
      * apply _derivable1_andp_intros.
        -- exact (proof_of_InsertObj_which_implies_wit_2_split_goal_1
             idnode_pre id sem stable PreH1 PreH2 PreH3).
        -- exact (proof_of_InsertObj_which_implies_wit_2_split_goal_2
             idnode_pre id sem stable PreH1 PreH2 PreH3).
      * exact (proof_of_InsertObj_which_implies_wit_2_split_goal_3
           idnode_pre id sem stable PreH1 PreH2 PreH3).
    + exact (proof_of_InsertObj_which_implies_wit_2_split_goal_4
         idnode_pre id sem stable PreH1 PreH2 PreH3).
  - exact (proof_of_InsertObj_which_implies_wit_2_split_goal_spatial
       idnode_pre id sem stable PreH1 PreH2 PreH3).
Qed.

Lemma proof_of_InsertObj_which_implies_wit_3 : InsertObj_which_implies_wit_3.
Proof.
  unfold InsertObj_which_implies_wit_3. intros.
  pose proof PreH1 as Hstable.
  unfold SemaphoreStableContext in Hstable.
  destruct Hstable as (Hm & Hb & Hba & Hr & Hil & Hbc).
  unfold SEM_BUCKET_COUNT in Hbc.
  rewrite !Z.rem_mod_nonneg by lia.
  apply store_semaphore_buckets_focus_local; [exact PreH1 | lia].
Qed.

Lemma proof_of_InsertObj_which_implies_wit_4_split_goal_spatial : InsertObj_which_implies_wit_4_split_goal_spatial.
Proof.
  unfold InsertObj_which_implies_wit_4_split_goal_spatial.
  intros. apply store_sem_dll_empty_none_rest_local.
Qed.

Lemma proof_of_InsertObj_which_implies_wit_4 : InsertObj_which_implies_wit_4.
Proof.
  left. exact proof_of_InsertObj_which_implies_wit_4_split_goal_spatial.
Qed.

Lemma proof_of_InsertObj_which_implies_wit_5_split_goal_spatial : InsertObj_which_implies_wit_5_split_goal_spatial.
Proof.
  unfold InsertObj_which_implies_wit_5_split_goal_spatial. intros.
  sep_apply (store_sem_dll_without_prev_merge_local
    store_semaphore_id_payload
    (semaphore_buckets_addr stable +
      id % (semaphore_bucket_count stable) *
        sizeof("SysDoubleLinklistNode"))
    (map semaphore_id_node
      (semaphore_objects_in_bucket stable (id % 16)
        before.(semaphore_objects))) previous).
  entailer!.
Qed.

Lemma proof_of_InsertObj_which_implies_wit_5 : InsertObj_which_implies_wit_5.
Proof.
  left. exact proof_of_InsertObj_which_implies_wit_5_split_goal_spatial.
Qed.

Lemma proof_of_InsertObj_which_implies_wit_6_split_goal_spatial : InsertObj_which_implies_wit_6_split_goal_spatial.
Proof.
  unfold InsertObj_which_implies_wit_6_split_goal_spatial.
  intros. subst idnode_pre. pose proof PreH1 as Hlayout.
  unfold store_sem_id_node_insert_ready_rest,
    store_sem_standalone_node, store_semaphore_id_payload. simpl.
  unfold semaphore_layout_32_ok in PreH1.
  destruct PreH1 as
    (Hsize & Hidbase & Hidfield & Hidlink & Hidnext & Hidprev &
     Hnid & Hnlink & Hnnext & Hnprev & Hvalue & Hpend &
     Hpnext & Hpprev & Hnpnext & Hnpprev & Hreg &
     Hrnext & Hrprev & Hnrnext & Hnrprev).
  entailer!.
  - rewrite Hidfield, Hnid, Hidprev, Hnprev, Hidnext, Hnnext.
    entailer!.
Qed.

Lemma proof_of_InsertObj_which_implies_wit_6 : InsertObj_which_implies_wit_6.
Proof.
  left. exact proof_of_InsertObj_which_implies_wit_6_split_goal_spatial.
Qed.
