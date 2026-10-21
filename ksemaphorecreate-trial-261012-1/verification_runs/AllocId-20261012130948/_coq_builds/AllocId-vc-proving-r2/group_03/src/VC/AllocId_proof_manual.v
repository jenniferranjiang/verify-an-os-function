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
From CRTOS_Verify.VC Require Import AllocId_goal.
From CRTOS_Verify.VC Require Import AllocId_proof_auto.
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

Lemma proof_of_AllocId_safety_wit_9_split_goal_1 : AllocId_safety_wit_9_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold id_map_bytes_ok in *.
  destruct PreH6 as [Hlo [Hhi Hrest]].
  try dump_pre_spatial.
  simpl in *; lia.
Qed.

Lemma proof_of_AllocId_safety_wit_9_split_goal_2 : AllocId_safety_wit_9_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold id_map_bytes_ok in *.
  destruct PreH6 as [Hlo [Hhi Hrest]].
  try dump_pre_spatial.
  simpl in *; lia.
Qed.

Lemma proof_of_AllocId_safety_wit_9 : AllocId_safety_wit_9.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of_AllocId_safety_wit_9_split_goal_1.
  - Goal_apply proof_of_AllocId_safety_wit_9_split_goal_2.
Qed. 

Lemma proof_of_AllocId_safety_wit_19_split_goal_1 : AllocId_safety_wit_19_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  match goal with H : id_map_bytes_ok _ _ _ |- _ => destruct H as [Hlo [Hhi Hrest]] end.
  assert (Hbound : (idmax sm + 7) ÷ 8 < 8193).
  { rewrite Z.quot_div_nonneg by lia.
    apply Z.div_lt_upper_bound; lia. }
  try dump_pre_spatial.
  simpl in *; lia.
Qed.

Lemma proof_of_AllocId_safety_wit_19_split_goal_2 : AllocId_safety_wit_19_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of_AllocId_safety_wit_19 : AllocId_safety_wit_19.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of_AllocId_safety_wit_19_split_goal_1.
  - Goal_apply proof_of_AllocId_safety_wit_19_split_goal_2.
Qed. 

Lemma proof_of_AllocId_safety_wit_22_split_goal_1 : AllocId_safety_wit_22_split_goal_1.
Proof. Abort.

Lemma proof_of_AllocId_safety_wit_22_split_goal_2 : AllocId_safety_wit_22_split_goal_2.
Proof. Abort.

Lemma proof_of_AllocId_safety_wit_22 : AllocId_safety_wit_22.
Proof. Admitted. 

Lemma proof_of_AllocId_safety_wit_27_split_goal_1 : AllocId_safety_wit_27_split_goal_1.
Proof. Abort.

Lemma proof_of_AllocId_safety_wit_27_split_goal_2 : AllocId_safety_wit_27_split_goal_2.
Proof. Abort.

Lemma proof_of_AllocId_safety_wit_27_split_goal_3 : AllocId_safety_wit_27_split_goal_3.
Proof. Abort.

Lemma proof_of_AllocId_safety_wit_27_split_goal_4 : AllocId_safety_wit_27_split_goal_4.
Proof. Abort.

Lemma proof_of_AllocId_safety_wit_27 : AllocId_safety_wit_27.
Proof. Admitted. 

Lemma proof_of_AllocId_entail_wit_2 : AllocId_entail_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hptr : forall p v, OSHeap (Task_C_Rules.store_ptr p v) = store_ptr p v).
  { intros p v. unfold Task_C_Rules.store_ptr, store_ptr.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq. f_equal.
    change (OSHeap (Task_C_Rules.store_4byte p v) = store_4byte p v).
    unfold Task_C_Rules.store_4byte, store_4byte.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq. f_equal.
    apply functional_extensionality; intro z1.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq. f_equal.
    apply functional_extensionality; intro z2.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq. f_equal.
    apply functional_extensionality; intro z3.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq. f_equal.
    apply functional_extensionality; intro z4.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq,
      !SemaphoreCriticalViews.OSHeap_sep_eq,
      !SemaphoreCriticalViews.OSHeap_byte_eq. reflexivity. }
  assert (Huchar : forall p v, OSHeap (Task_C_Rules.store_uchar p v) = store_uchar p v).
  { intros p v. unfold Task_C_Rules.store_uchar, store_uchar.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq,
      SemaphoreCriticalViews.OSHeap_byte_eq. reflexivity. }
  assert (Hemp : OSHeap Task_C_Rules.emp = emp).
  { apply functional_extensionality; intro m.
    apply propositional_extensionality.
    unfold OSHeap, CrtosHeapBridge.crtos_heap_lift, Task_C_Rules.emp, emp,
      Task_C_Rules.is_unit, is_unit, ConAssertion.state_empty, CrtosHeapBridge.crtos_heap_state.
    simpl. split.
    - intros [Ht [Hs [Hm _]]]. exact (conj Hm (conj Ht Hs)).
    - intros [Hm [Ht Hs]]. split; [exact Ht|]. split; [exact Hs|].
      split; [exact Hm|]. split; intro x; reflexivity. }
  assert (Harray : forall xs p lo hi,
    OSHeap (Task_C_Rules.store_array_rec Task_C_Rules.StoreUCharAsElement.storeA p lo hi xs) =
    store_array_rec StoreUCharAsElement.storeA p lo hi xs).
  { induction xs as [|x xs IH]; intros p lo hi.
    - change (OSHeap (Task_C_Rules.andp
        (Task_C_Rules.coq_prop (lo = hi /\ @nil Z = nil)) Task_C_Rules.emp) =
        (“ lo = hi /\ @nil Z = nil ” && emp)).
      rewrite !SemaphoreCriticalViews.OSHeap_pure_and_eq, Hemp. reflexivity.
    - change (OSHeap (Task_C_Rules.sepcon (Task_C_Rules.StoreUCharAsElement.storeA p lo x)
        (Task_C_Rules.store_array_rec Task_C_Rules.StoreUCharAsElement.storeA p (lo + 1) hi xs)) =
        (StoreUCharAsElement.storeA p lo x **
          store_array_rec StoreUCharAsElement.storeA p (lo + 1) hi xs)).
      rewrite SemaphoreCriticalViews.OSHeap_sep_eq, IH.
      unfold Task_C_Rules.StoreUCharAsElement.storeA, StoreUCharAsElement.storeA.
      rewrite Huchar. reflexivity. }
  unfold store_idmanager, store_id_map, store_uchar_array.
  rewrite !SemaphoreCriticalViews.OSHeap_sep_eq.
  rewrite SemaphoreCriticalViews.OSHeap_exp_eq.
  Intros bytes.
  rewrite !SemaphoreCriticalViews.OSHeap_pure_and_eq.
  Intros_p Hbytes. Intros_p Hbuckets.
  rewrite !OSHeap_ushort_eq.
  rewrite !Hptr.
  unfold Task_C_Rules.UCharArray.full, Task_C_Rules.store_array.
  rewrite Harray.
  change (store_array_rec StoreUCharAsElement.storeA (id_map sm) 0 ((idmax sm + 7) / 8) bytes)
    with (UCharArray.full (id_map sm) ((idmax sm + 7) / 8) bytes).
  assert (Hnonneg : 0 <= idmax sm) by (destruct Hbytes; assumption).
  rewrite <- Z.quot_div_nonneg by lia.
  Exists bytes.
  split_pure_spatial.
  - cancel (UCharArray.full (id_map sm) ((idmax sm + 7) ÷ 8) bytes).
    cancel (&(manager_pre # "IdManager" ->ₛ "id_max") # UShort |-> idmax sm).
    cancel (&(manager_pre # "IdManager" ->ₛ "hoffset") # UShort |-> hoffset sm).
    cancel (&(manager_pre # "IdManager" ->ₛ "id_map") # Ptr |-> id_map sm).
    cancel (&(manager_pre # "IdManager" ->ₛ "htable") # Ptr |-> htable sm).
    cancel (OSHeap (store_idbuckets (htable sm) (hoffset sm) (idbuckets before))).
  - split_pures; dump_pre_spatial; assumption.
Qed. 

Lemma proof_of_AllocId_entail_wit_3_split_goal_1 : AllocId_entail_wit_3_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold allocid_index_scan_inv; split; [lia|].
  intros; lia.
Qed.

Lemma proof_of_AllocId_entail_wit_3_split_goal_2 : AllocId_entail_wit_3_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  destruct PreH6 as [Hlo Hrest].
  apply Z.quot_pos; lia.
Qed.

Lemma proof_of_AllocId_entail_wit_3 : AllocId_entail_wit_3.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of_AllocId_entail_wit_3_split_goal_1.
  - Goal_apply proof_of_AllocId_entail_wit_3_split_goal_2.
Qed. 

Lemma proof_of_AllocId_entail_wit_4_split_goal_1 : AllocId_entail_wit_4_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  destruct PreH9 as [Hnonneg Hprefix].
  unfold allocid_index_scan_inv; split; [lia|].
  intros i Hi. destruct (Z_lt_ge_dec i index).
  - apply Hprefix; lia.
  - assert (i = index) by lia. subst; assumption.
Qed.

Lemma proof_of_AllocId_entail_wit_4 : AllocId_entail_wit_4.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_AllocId_entail_wit_4_split_goal_1.
Qed. 

Lemma proof_of_AllocId_entail_wit_5_split_goal_1 : AllocId_entail_wit_5_split_goal_1.
Proof. Abort.

Lemma proof_of_AllocId_entail_wit_5 : AllocId_entail_wit_5.
Proof. Admitted. 

Lemma proof_of_AllocId_entail_wit_6_split_goal_1 : AllocId_entail_wit_6_split_goal_1.
Proof. Abort.

Lemma proof_of_AllocId_entail_wit_6 : AllocId_entail_wit_6.
Proof. Admitted. 

Lemma proof_of_AllocId_return_wit_1 : AllocId_return_wit_1.
Proof. Admitted. 

Lemma proof_of_AllocId_return_wit_2 : AllocId_return_wit_2.
Proof. Admitted. 

Lemma proof_of_AllocId_return_wit_3 : AllocId_return_wit_3.
Proof. Admitted.

Lemma proof_of_AllocId_safety_wit_1 : AllocId_safety_wit_1.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_2 : AllocId_safety_wit_2.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_3 : AllocId_safety_wit_3.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_4 : AllocId_safety_wit_4.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_5 : AllocId_safety_wit_5.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_6 : AllocId_safety_wit_6.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_7 : AllocId_safety_wit_7.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_8 : AllocId_safety_wit_8.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_10 : AllocId_safety_wit_10.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_11 : AllocId_safety_wit_11.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_12 : AllocId_safety_wit_12.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_13 : AllocId_safety_wit_13.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_14 : AllocId_safety_wit_14.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  match goal with H : id_map_bytes_ok _ _ _ |- _ => destruct H as [Hlo [Hhi Hrest]] end.
  assert (Hbound : (idmax sm + 7) ÷ 8 < 8193).
  { rewrite Z.quot_div_nonneg by lia.
    apply Z.div_lt_upper_bound; lia. }
  split_pures; dump_pre_spatial; simpl in *; lia.
Qed. 


Lemma proof_of_AllocId_safety_wit_15 : AllocId_safety_wit_15.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_16 : AllocId_safety_wit_16.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_17 : AllocId_safety_wit_17.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_18 : AllocId_safety_wit_18.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_20 : AllocId_safety_wit_20.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_21 : AllocId_safety_wit_21.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_23 : AllocId_safety_wit_23.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_24 : AllocId_safety_wit_24.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_25 : AllocId_safety_wit_25.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_26 : AllocId_safety_wit_26.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_28 : AllocId_safety_wit_28.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_29 : AllocId_safety_wit_29.
Proof. Admitted. 


Lemma proof_of_AllocId_safety_wit_30 : AllocId_safety_wit_30.
Proof. Admitted. 


Lemma proof_of_AllocId_entail_wit_1 : AllocId_entail_wit_1.
Proof. Admitted. 


Lemma proof_of_AllocId_partial_solve_wit_1 : AllocId_partial_solve_wit_1.
Proof. Admitted. 


Lemma proof_of_AllocId_partial_solve_wit_2 : AllocId_partial_solve_wit_2.
Proof. Admitted. 


Lemma proof_of_AllocId_partial_solve_wit_3 : AllocId_partial_solve_wit_3.
Proof. Admitted. 


Lemma proof_of_AllocId_partial_solve_wit_4 : AllocId_partial_solve_wit_4.
Proof. Admitted.
