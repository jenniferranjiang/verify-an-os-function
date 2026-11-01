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
From CRTOS_Verify.VC Require Import _SemaphoreCreate_goal.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.sem.CrtosOSProtocol.
Import CrtosOS_C_Rules.
Require Import Coq.Lists.List.
Require Import CRTOS_Verify.lib.CrtosGlobState.
Require Import CRTOS_Verify.sem.SemaphorePure.
Require Import CRTOS_Verify.sem.CrtosOSPure.
Require Import CRTOS_Verify.sem.SemaphoreProtocol.
Require Import CRTOS_Verify.sem.SemaphoreRep.
Require Import CRTOS_Verify.sem.CrtosOSRep.
Require Import CRTOS_Verify.sem.SemaphoreCritical.
Require Import CRTOS_Verify.VC.SemaphoreProofLocal.
From MonadLib.StateRelMonad Require Import StateRelBasic safeexec_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Local Open Scope sac.

Lemma proof_of__SemaphoreCreate_safety_wit_1 : _SemaphoreCreate_safety_wit_1.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of__SemaphoreCreate_safety_wit_2 : _SemaphoreCreate_safety_wit_2.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of__SemaphoreCreate_safety_wit_3 : _SemaphoreCreate_safety_wit_3.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of__SemaphoreCreate_safety_wit_4 : _SemaphoreCreate_safety_wit_4.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of__SemaphoreCreate_safety_wit_5 : _SemaphoreCreate_safety_wit_5.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of__SemaphoreCreate_safety_wit_6 : _SemaphoreCreate_safety_wit_6.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of__SemaphoreCreate_safety_wit_7 : _SemaphoreCreate_safety_wit_7.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of__SemaphoreCreate_safety_wit_8 : _SemaphoreCreate_safety_wit_8.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of__SemaphoreCreate_safety_wit_9 : _SemaphoreCreate_safety_wit_9.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of__SemaphoreCreate_safety_wit_10 : _SemaphoreCreate_safety_wit_10.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of__SemaphoreCreate_safety_wit_11 : _SemaphoreCreate_safety_wit_11.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of__SemaphoreCreate_safety_wit_12 : _SemaphoreCreate_safety_wit_12.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of__SemaphoreCreate_safety_wit_13 : _SemaphoreCreate_safety_wit_13.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of__SemaphoreCreate_safety_wit_14 : _SemaphoreCreate_safety_wit_14.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of__SemaphoreCreate_safety_wit_15 : _SemaphoreCreate_safety_wit_15.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of__SemaphoreCreate_safety_wit_16 : _SemaphoreCreate_safety_wit_16.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of__SemaphoreCreate_partial_solve_wit_1_pure : _SemaphoreCreate_partial_solve_wit_1_pure.
Proof. red; intros; entailer!. Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_1 : _SemaphoreCreate_partial_solve_wit_1.
Proof.
  unfold _SemaphoreCreate_partial_solve_wit_1,
    _SemaphoreCreate_partial_solve_wit_1_aux.
  intros. entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_2_pure : _SemaphoreCreate_partial_solve_wit_2_pure.
Proof.
  unfold _SemaphoreCreate_partial_solve_wit_2_pure. intros.
  unfold store_sem_allocated, semaphore_layout_32_ok. Intros. entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_2 : _SemaphoreCreate_partial_solve_wit_2.
Proof.
  unfold _SemaphoreCreate_partial_solve_wit_2,
    _SemaphoreCreate_partial_solve_wit_2_aux.
  intros. unfold store_sem_allocated, semaphore_layout_32_ok.
  Intros. entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_3 : _SemaphoreCreate_partial_solve_wit_3.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of__SemaphoreCreate_partial_solve_wit_4 : _SemaphoreCreate_partial_solve_wit_4.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of__SemaphoreCreate_partial_solve_wit_5 : _SemaphoreCreate_partial_solve_wit_5.
Proof.
  unfold _SemaphoreCreate_partial_solve_wit_5,
    _SemaphoreCreate_partial_solve_wit_5_aux.
  intros. unfold crtos_semaphore_nonsem_frame. Intros.
  unfold SemaphoreStableContext in *. entailer!.
  - apply addr_of_LE_var_not_zero.
  - unfold semaphore_layout_32_ok in PreH1. entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_6_pure : _SemaphoreCreate_partial_solve_wit_6_pure.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of__SemaphoreCreate_partial_solve_wit_6 : _SemaphoreCreate_partial_solve_wit_6.
Proof.
  unfold _SemaphoreCreate_partial_solve_wit_6,
    _SemaphoreCreate_partial_solve_wit_6_aux.
  intros. entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_7 : _SemaphoreCreate_partial_solve_wit_7.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of__SemaphoreCreate_partial_solve_wit_8 : _SemaphoreCreate_partial_solve_wit_8.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of__SemaphoreCreate_partial_solve_wit_9 : _SemaphoreCreate_partial_solve_wit_9.
Proof.
  unfold _SemaphoreCreate_partial_solve_wit_9,
    _SemaphoreCreate_partial_solve_wit_9_aux.
  intros. subst retval. entailer!. apply SemaphoreGuarantee_refl.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_10 : _SemaphoreCreate_partial_solve_wit_10.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of__SemaphoreCreate_partial_solve_wit_11 : _SemaphoreCreate_partial_solve_wit_11.
Proof.
  unfold _SemaphoreCreate_partial_solve_wit_11,
    _SemaphoreCreate_partial_solve_wit_11_aux.
  intros.
  prop_apply (semaphore_value_cell_pend_head_nonzero_local
    retval val_pre PreH6).
  Intros. entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_12_pure : _SemaphoreCreate_partial_solve_wit_12_pure.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of__SemaphoreCreate_partial_solve_wit_12 : _SemaphoreCreate_partial_solve_wit_12.
Proof.
  unfold _SemaphoreCreate_partial_solve_wit_12,
    _SemaphoreCreate_partial_solve_wit_12_aux.
  intros. entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_13_pure : _SemaphoreCreate_partial_solve_wit_13_pure.
Proof. red; intros; entailer!. Qed. 

Lemma proof_of__SemaphoreCreate_partial_solve_wit_13 : _SemaphoreCreate_partial_solve_wit_13.
Proof.
  unfold _SemaphoreCreate_partial_solve_wit_13,
    _SemaphoreCreate_partial_solve_wit_13_aux.
  intros. entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_14 : _SemaphoreCreate_partial_solve_wit_14.
Proof.
  unfold _SemaphoreCreate_partial_solve_wit_14,
    _SemaphoreCreate_partial_solve_wit_14_aux.
  intros.
  unfold store_sem_standalone_node, store_semaphore_body at 1. simpl.
  Intros.
  sep_apply (semaphore_value_cell_registry_head_nonzero_keep_local
    retval val_pre PreH6).
  Intros. entailer!.
  unfold store_semaphore_body. simpl. entailer!.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_15 : _SemaphoreCreate_partial_solve_wit_15.
Proof.
  unfold _SemaphoreCreate_partial_solve_wit_15,
    _SemaphoreCreate_partial_solve_wit_15_aux.
  intros. entailer!.
  pose proof (semaphore_first_free_some_bound_local
    (crtos_semaphore_stable stable) (crtos_semaphore_state current)
    retval_2 PreH5 PreH8) as Hbound.
  unfold SemaphoreStableContext in PreH5.
  destruct PreH5 as (Hm & Hb & Hba & Hr & Hil & Hbc).
  rewrite Hil in Hbound. unfold SEM_ID_MAX in Hbound. lia.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_16 : _SemaphoreCreate_partial_solve_wit_16.
Proof.
  unfold _SemaphoreCreate_partial_solve_wit_16,
    _SemaphoreCreate_partial_solve_wit_16_aux.
  intros. entailer!.
  - subst retval_2. entailer!.
  - eapply SemaphoreGuarantee_create_local; eauto.
  - subst retval_2. exact PreH14.
Qed.
