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
Proof. Abort.

Lemma proof_of_AllocId_safety_wit_9_split_goal_2 : AllocId_safety_wit_9_split_goal_2.
Proof. Abort.

Lemma proof_of_AllocId_safety_wit_9 : AllocId_safety_wit_9.
Proof. Admitted. 

Lemma proof_of_AllocId_safety_wit_19_split_goal_1 : AllocId_safety_wit_19_split_goal_1.
Proof. Abort.

Lemma proof_of_AllocId_safety_wit_19_split_goal_2 : AllocId_safety_wit_19_split_goal_2.
Proof. Abort.

Lemma proof_of_AllocId_safety_wit_19 : AllocId_safety_wit_19.
Proof. Admitted. 

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
Proof. Admitted. 

Lemma proof_of_AllocId_entail_wit_3_split_goal_1 : AllocId_entail_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of_AllocId_entail_wit_3_split_goal_2 : AllocId_entail_wit_3_split_goal_2.
Proof. Abort.

Lemma proof_of_AllocId_entail_wit_3 : AllocId_entail_wit_3.
Proof. Admitted. 

Lemma proof_of_AllocId_entail_wit_4_split_goal_1 : AllocId_entail_wit_4_split_goal_1.
Proof. Abort.

Lemma proof_of_AllocId_entail_wit_4 : AllocId_entail_wit_4.
Proof. Admitted. 

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
Proof.
  LLM_pre_process ltac:(auto).
  pose proof PreH9 as Hmap.
  assert (Hfull : idmanager_full sm before).
  { unfold idmanager_full; intros j Hj.
    rewrite (id_map_bytes_ok_query_eq sm before bytes j Hmap Hj).
    pose proof (Z.mod_pos_bound j 8 ltac:(lia)) as Hmod.
    pose proof (Z.div_pos j 8 ltac:(lia) ltac:(lia)) as Hdivnonneg.
    destruct PreH8 as [Hid [Hentry [offset [Hoff [Hoffrange [Hshift Hbits]]]]]].
    assert (Hofflt : offset < 8).
    { destruct (Z.eq_dec offset 8) as [Heq|Hneq]; [|lia].
      exfalso; apply PreH6; apply byte_eq_255_of_low_bits.
      - eapply id_map_bytes_ok_Znth_range; [exact Hmap|lia].
      - intros bit Hb; apply Hbits; lia. }
    destruct (Z_lt_ge_dec (j / 8) index) as [Hprefix|Hcurrent].
    - rewrite (proj2 PreH7 (j / 8) ltac:(lia)). apply Ztestbit_255_low; exact Hmod.
    - pose proof (Z.div_mod j 8 ltac:(lia)) as Hdiv.
      assert (Hidx : j / 8 = index) by nia.
      rewrite Hidx. apply Hbits. split; [lia|]. rewrite Hidx in Hdiv; lia. }
  Left.
  pose proof SemaphoreCriticalViews.OSHeap_sep_eq as Hsep.
  pose proof SemaphoreCriticalViews.OSHeap_pure_and_eq as Hpure.
  pose proof SemaphoreCriticalViews.OSHeap_exp_eq as Hexp.
  pose proof SemaphoreCriticalViews.OSHeap_byte_eq as Hbyte.
  assert (Hemp : OSHeap Task_C_Rules.emp = emp).
  { apply functional_extensionality; intro m.
    apply propositional_extensionality.
    clear - m.
    unfold OSHeap, CrtosHeapBridge.crtos_heap_lift, Task_C_Rules.emp, emp, CrtosHeapBridge.crtos_heap_state; simpl.
    unfold Task_C_Rules.is_unit, is_unit, ConAssertion.state_empty; simpl.
    split.
    - tauto.
    - intros [Hm [Ht Hs]]. split; [exact Ht|]. split; [exact Hs|].
      split; [exact Hm|]. split; intro x; reflexivity. }
  assert (Hptr : forall p v, OSHeap (Task_C_Rules.store_ptr p v) = store_ptr p v).
  { intros; unfold Task_C_Rules.store_ptr, store_ptr.
    rewrite Hpure. f_equal.
    change (OSHeap (Task_C_Rules.store_4byte p v) = store_4byte p v).
    unfold Task_C_Rules.store_4byte, store_4byte.
    do 4 (rewrite Hexp; f_equal; apply functional_extensionality; intro).
    rewrite Hpure, !Hsep, !Hbyte. reflexivity. }
  assert (Huchar : forall p v, OSHeap (Task_C_Rules.store_uchar p v) = store_uchar p v).
  { intros; unfold Task_C_Rules.store_uchar, store_uchar.
    rewrite Hpure, Hbyte. reflexivity. }
  assert (Harray : forall p lo hi bs,
    OSHeap (Task_C_Rules.store_array_rec Task_C_Rules.StoreUCharAsElement.storeA p lo hi bs) =
      store_array_rec StoreUCharAsElement.storeA p lo hi bs).
  { intros p lo hi bs; revert lo; induction bs as [|b bs IHbs]; intro lo.
    - change (OSHeap (Task_C_Rules.andp (Task_C_Rules.coq_prop (lo = hi /\ @nil Z = nil))
        Task_C_Rules.emp) =
        “ lo = hi ” && “ @nil Z = nil ” && emp).
      rewrite !Hpure, Hemp. reflexivity.
    - change (OSHeap (Task_C_Rules.sepcon
        (Task_C_Rules.StoreUCharAsElement.storeA p lo b)
        (Task_C_Rules.store_array_rec Task_C_Rules.StoreUCharAsElement.storeA p (lo+1) hi bs)) =
        StoreUCharAsElement.storeA p lo b **
        store_array_rec StoreUCharAsElement.storeA p (lo+1) hi bs).
      rewrite Hsep, IHbs.
      unfold Task_C_Rules.StoreUCharAsElement.storeA, StoreUCharAsElement.storeA.
      rewrite Huchar. reflexivity. }
  unfold store_idmanager, store_id_map, store_uchar_array.
  rewrite !Hsep, !OSHeap_ushort_eq, !Hptr, Hexp.
  Exists bytes.
  rewrite !Hpure.
  unfold Task_C_Rules.UCharArray.full, Task_C_Rules.store_array.
  rewrite Harray.
  unfold UCharArray.full, store_array, StoreUCharAsElement.storeA.
  rewrite Z.quot_div_nonneg by (pose proof (proj1 Hmap); lia).
  split_pure_spatial.
  - sepcon_right_assoc; cancel.
  - split_pures; dump_pre_spatial; auto.
Qed. 

Lemma proof_of_AllocId_return_wit_3 : AllocId_return_wit_3.
Proof.
  LLM_pre_process ltac:(auto).
  pose proof PreH10 as Hmap.
  assert (Hfull : idmanager_full sm before).
  { unfold idmanager_full; intros j Hj.
    rewrite (id_map_bytes_ok_query_eq sm before bytes j Hmap Hj).
    pose proof (id_div8_lt_quot_ceil8 j (idmax sm) Hj) as Hbound.
    pose proof (Z.div_pos j 8 ltac:(lia) ltac:(lia)) as Hnonneg.
    rewrite (proj2 PreH9 (j / 8) ltac:(lia)).
    apply Ztestbit_255_low; apply Z.mod_pos_bound; lia. }
  Left.
  pose proof SemaphoreCriticalViews.OSHeap_sep_eq as Hsep.
  pose proof SemaphoreCriticalViews.OSHeap_pure_and_eq as Hpure.
  pose proof SemaphoreCriticalViews.OSHeap_exp_eq as Hexp.
  pose proof SemaphoreCriticalViews.OSHeap_byte_eq as Hbyte.
  assert (Hemp : OSHeap Task_C_Rules.emp = emp).
  { apply functional_extensionality; intro m.
    apply propositional_extensionality.
    clear - m.
    unfold OSHeap, CrtosHeapBridge.crtos_heap_lift, Task_C_Rules.emp, emp, CrtosHeapBridge.crtos_heap_state; simpl.
    unfold Task_C_Rules.is_unit, is_unit, ConAssertion.state_empty; simpl.
    split.
    - tauto.
    - intros [Hm [Ht Hs]]. split; [exact Ht|]. split; [exact Hs|].
      split; [exact Hm|]. split; intro x; reflexivity. }
  assert (Hptr : forall p v, OSHeap (Task_C_Rules.store_ptr p v) = store_ptr p v).
  { intros; unfold Task_C_Rules.store_ptr, store_ptr.
    rewrite Hpure. f_equal.
    change (OSHeap (Task_C_Rules.store_4byte p v) = store_4byte p v).
    unfold Task_C_Rules.store_4byte, store_4byte.
    do 4 (rewrite Hexp; f_equal; apply functional_extensionality; intro).
    rewrite Hpure, !Hsep, !Hbyte. reflexivity. }
  assert (Huchar : forall p v, OSHeap (Task_C_Rules.store_uchar p v) = store_uchar p v).
  { intros; unfold Task_C_Rules.store_uchar, store_uchar.
    rewrite Hpure, Hbyte. reflexivity. }
  assert (Harray : forall p lo hi bs,
    OSHeap (Task_C_Rules.store_array_rec Task_C_Rules.StoreUCharAsElement.storeA p lo hi bs) =
      store_array_rec StoreUCharAsElement.storeA p lo hi bs).
  { intros p lo hi bs; revert lo; induction bs as [|b bs IHbs]; intro lo.
    - change (OSHeap (Task_C_Rules.andp (Task_C_Rules.coq_prop (lo = hi /\ @nil Z = nil))
        Task_C_Rules.emp) =
        “ lo = hi ” && “ @nil Z = nil ” && emp).
      rewrite !Hpure, Hemp. reflexivity.
    - change (OSHeap (Task_C_Rules.sepcon
        (Task_C_Rules.StoreUCharAsElement.storeA p lo b)
        (Task_C_Rules.store_array_rec Task_C_Rules.StoreUCharAsElement.storeA p (lo+1) hi bs)) =
        StoreUCharAsElement.storeA p lo b **
        store_array_rec StoreUCharAsElement.storeA p (lo+1) hi bs).
      rewrite Hsep, IHbs.
      unfold Task_C_Rules.StoreUCharAsElement.storeA, StoreUCharAsElement.storeA.
      rewrite Huchar. reflexivity. }
  unfold store_idmanager, store_id_map, store_uchar_array.
  rewrite !Hsep, !OSHeap_ushort_eq, !Hptr, Hexp.
  Exists bytes.
  rewrite !Hpure.
  unfold Task_C_Rules.UCharArray.full, Task_C_Rules.store_array.
  rewrite Harray.
  unfold UCharArray.full, store_array, StoreUCharAsElement.storeA.
  rewrite Z.quot_div_nonneg by (pose proof (proj1 Hmap); lia).
  split_pure_spatial.
  - sepcon_right_assoc; cancel.
  - split_pures; dump_pre_spatial; auto.
Qed.

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
Proof. Admitted. 


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
