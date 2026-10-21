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
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  pose proof (id_map_bytes_ok_Znth_range _ _ _ index PreH9 ltac:(lia)) as Hb.
  destruct PreH8 as [Hidrange [Hentry [offset [Hid [Hoffset [Hshift Hlow]]]]]].
  assert (Hoff : 0 <= offset < 8).
  { split; [lia|]. destruct (Z.eq_dec offset 8); [|lia].
    exfalso; apply PreH6; apply byte_eq_255_of_low_bits; [exact Hb|].
    intros bit Hbit; apply Hlow; lia. }
  assert (Hnonneg : 0 <= id) by lia.
  assert (Hdiv : id / 8 = index) by (rewrite Hid; apply div8_add_offset; exact Hoff).
  assert (Hmod : id mod 8 = offset) by (rewrite Hid; apply mod8_add_offset; exact Hoff).
  assert (Hfreebit : Z.testbit (Znth index bytes 0) offset = false).
  { pose proof (f_equal (fun z => Z.testbit z 0) PreH11) as Hbit.
    cbn beta in Hbit.
    rewrite Z.land_spec, Hshift, Z.shiftr_spec in Hbit by lia.
    simpl in Hbit. rewrite Bool.andb_true_r in Hbit. exact Hbit. }
  assert (Hfree : idmanager_query before id = false).
  { rewrite (id_map_bytes_ok_query_eq sm before bytes id PreH9 ltac:(lia)).
    rewrite Hdiv, Hmod; exact Hfreebit. }
  assert (Hmin : idmanager_min_free_id sm before id).
  { split; [lia|]. split; [exact Hfree|]. intros query Hquery.
    rewrite (id_map_bytes_ok_query_eq sm before bytes query PreH9 ltac:(lia)).
    pose proof (Z.mod_pos_bound query 8 ltac:(lia)) as Hqr.
    pose proof (Z.div_mod query 8 ltac:(lia)) as Hrepr.
    assert (Hqnonneg : 0 <= query / 8) by (apply Z.div_pos; lia).
    destruct (Z_lt_ge_dec (query / 8) index) as [Hbefore|Hsame].
    - rewrite (proj2 PreH7 (query / 8) ltac:(lia)). apply Ztestbit_255_low; exact Hqr.
    - assert (Hqi : query / 8 = index) by lia.
      rewrite Hqi. apply Hlow; lia. }
  assert (Hmask : 0 <= Z.shiftl 1 offset <= 255).
  { assert (offset = 0 \/ offset = 1 \/ offset = 2 \/ offset = 3 \/
            offset = 4 \/ offset = 5 \/ offset = 6 \/ offset = 7) by lia.
    destruct H as [-> | [-> | [-> | [-> | [-> | [-> | [-> | ->]]]]]]]; vm_compute; intuition discriminate. }
  rewrite Z.rem_mod_nonneg by lia.
  rewrite Hmod.
  rewrite (unsigned_last_nbits_eq (Znth index bytes 0) 8 ltac:(change (0 <= Znth index bytes 0 < 256); lia)).
  rewrite (unsigned_last_nbits_eq (Z.shiftl 1 offset) 8 ltac:(change (0 <= Z.shiftl 1 offset < 256); lia)).
  set (newbyte := Z.lor (Znth index bytes 0) (Z.shiftl 1 offset)).
  assert (Hnewbyte : 0 <= newbyte <= 255).
  { unfold newbyte; split.
    - apply Z.lor_nonneg; lia.
    - assert (Z.log2 (Znth index bytes 0) <= 7).
      { change (Z.log2 (Znth index bytes 0) <= Z.log2 255); apply Z.log2_le_mono; lia. }
      assert (Z.log2 (Z.shiftl 1 offset) <= 7).
      { change (Z.log2 (Z.shiftl 1 offset) <= Z.log2 255); apply Z.log2_le_mono; lia. }
      assert (Z.lor (Znth index bytes 0) (Z.shiftl 1 offset) < 256).
      { apply Z.log2_lt_cancel. rewrite Z.log2_lor by lia. change (Z.max (Z.log2 (Znth index bytes 0)) (Z.log2 (Z.shiftl 1 offset)) < 8). lia. }
      lia. }
  destruct PreH9 as [Hmax0 [Hmax [Hlen [[Hids Hnodup] [Hbytes Hbits]]]]].
  assert (Hidx : 0 <= index < Zlength bytes).
  { rewrite Hlen. rewrite Z.quot_div_nonneg in PreH3 by lia. lia. }
  assert (Hupdated : id_map_bytes_ok (idmax sm) (idlist_add id (idlist before))
    (replace_Znth index newbyte bytes)).
  { unfold id_map_bytes_ok. split; [exact Hmax0|]. split; [exact Hmax|].
    split; [rewrite Zlength_replace_Znth; exact Hlen|].
    split.
    - unfold idlist_ok, idlist_add. split.
      + constructor; [lia|exact Hids].
      + constructor; [apply id_in_ids_false_iff; exact Hfree|exact Hnodup].
    - split; [apply Forall_replace_Znth; assumption|].
      intros query Hquery.
      assert (Hqr : 0 <= query mod 8 < 8) by (apply Z.mod_pos_bound; lia).
      assert (Hqi : 0 <= query / 8 < Zlength bytes).
      { split; [apply Z.div_pos; lia|]. rewrite Hlen.
        pose proof (id_div8_lt_quot_ceil8 query (idmax sm) Hquery) as Hq.
        rewrite Z.quot_div_nonneg in Hq by lia; exact Hq. }
      destruct (Z.eq_dec query id) as [->|Hneq].
      + rewrite Hdiv, Hmod, Znth_replace_Znth_Same by exact Hidx.
        unfold newbyte. rewrite Z.lor_spec, Z.shiftl_spec by lia.
        rewrite Z.sub_diag. simpl. rewrite Bool.orb_true_r.
        symmetry; apply id_in_ids_true_iff. unfold idlist_add; simpl; auto.
      + rewrite id_in_ids_add_neq by exact Hneq.
        destruct (Z.eq_dec (query / 8) index) as [Heq|Hneqidx].
        * rewrite Heq, Znth_replace_Znth_Same by exact Hidx.
          unfold newbyte. rewrite Z.lor_spec, Z.shiftl_spec by lia.
          rewrite Ztestbit_1_neq0.
          -- rewrite Bool.orb_false_r. rewrite <- Heq; apply Hbits; exact Hquery.
          -- pose proof (same_div8_mod8_neq query id index ltac:(lia) Hnonneg Heq Hdiv Hneq).
             lia.
        * rewrite Znth_replace_Znth_Diff by lia. apply Hbits; exact Hquery. }
  assert (Huchar : forall p v, OSHeap (Task_C_Rules.store_uchar p v) = store_uchar p v).
  { intros; unfold Task_C_Rules.store_uchar, store_uchar.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq, SemaphoreCriticalViews.OSHeap_byte_eq; reflexivity. }
  assert (Hptr : forall p v, OSHeap (Task_C_Rules.store_ptr p v) = store_ptr p v).
  { intros; unfold Task_C_Rules.store_ptr, store_ptr.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq. f_equal.
    change (OSHeap (Task_C_Rules.store_4byte p v) = store_4byte p v).
    unfold Task_C_Rules.store_4byte, store_4byte.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq; f_equal; apply functional_extensionality; intro z1.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq; f_equal; apply functional_extensionality; intro z2.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq; f_equal; apply functional_extensionality; intro z3.
    rewrite SemaphoreCriticalViews.OSHeap_exp_eq; f_equal; apply functional_extensionality; intro z4.
    rewrite SemaphoreCriticalViews.OSHeap_pure_and_eq, !SemaphoreCriticalViews.OSHeap_sep_eq, !SemaphoreCriticalViews.OSHeap_byte_eq; reflexivity. }
  assert (Hemp : OSHeap Task_C_Rules.emp = emp).
  { apply functional_extensionality; intro st. clear - st.
    apply propositional_extensionality.
    unfold OSHeap, CrtosHeapBridge.crtos_heap_lift, Task_C_Rules.emp, emp,
      Task_C_Rules.is_unit, is_unit, ConAssertion.state_empty, CrtosHeapBridge.crtos_heap_state.
    simpl. split.
    - intros [Ht [Hs [Hm _]]]. exact (conj Hm (conj Ht Hs)).
    - intros [Hm [Ht Hs]]. split; [exact Ht|]. split; [exact Hs|].
      split; [exact Hm|]. split; intro x; reflexivity.
  }
  assert (Harray : forall (l : list Z) p lo hi,
    OSHeap (Task_C_Rules.store_array_rec Task_C_Rules.StoreUCharAsElement.storeA p lo hi l) =
      store_array_rec StoreUCharAsElement.storeA p lo hi l).
  { induction l as [|b l IH]; intros p lo hi.
    - change (OSHeap (Task_C_Rules.andp
        (Task_C_Rules.coq_prop (lo = hi /\ @nil Z = @nil Z)) Task_C_Rules.emp) =
        “ lo = hi /\ @nil Z = @nil Z ” && emp).
      rewrite !SemaphoreCriticalViews.OSHeap_pure_and_eq, Hemp; reflexivity.
    - change (OSHeap (Task_C_Rules.sepcon
        (Task_C_Rules.StoreUCharAsElement.storeA p lo b)
        (Task_C_Rules.store_array_rec Task_C_Rules.StoreUCharAsElement.storeA p (lo + 1) hi l)) =
        StoreUCharAsElement.storeA p lo b **
        store_array_rec StoreUCharAsElement.storeA p (lo + 1) hi l).
      rewrite SemaphoreCriticalViews.OSHeap_sep_eq, IH.
      unfold Task_C_Rules.StoreUCharAsElement.storeA, StoreUCharAsElement.storeA.
      rewrite Huchar; reflexivity. }
  Right.
  unfold store_idmanager_allocated_unlinked, store_id_map, store_uchar_array.
  rewrite !SemaphoreCriticalViews.OSHeap_pure_and_eq, !SemaphoreCriticalViews.OSHeap_sep_eq, !OSHeap_ushort_eq, !Hptr, SemaphoreCriticalViews.OSHeap_exp_eq.
  Exists (replace_Znth index newbyte bytes).
  rewrite !SemaphoreCriticalViews.OSHeap_pure_and_eq.
  unfold Task_C_Rules.UCharArray.full, UCharArray.full, Task_C_Rules.store_array, store_array.
  rewrite Harray.
  rewrite Z.quot_div_nonneg by lia.
  split_pure_spatial.
  - unfold StoreUCharAsElement.storeA.
    cancel (OSHeap (store_idbuckets (htable sm) (hoffset sm) (idbuckets before))).
    cancel (store_array_rec
      (fun (x : addr) (lo a : Z) => (x + lo * sizeof(UCHAR)) # UChar |-> a)
      (id_map sm) 0 ((idmax sm + 7) / 8) (replace_Znth index newbyte bytes)).
    cancel (&(manager_pre # "IdManager" ->ₛ "id_max") # UShort |-> idmax sm).
    cancel (&(manager_pre # "IdManager" ->ₛ "hoffset") # UShort |-> hoffset sm).
    cancel (&(manager_pre # "IdManager" ->ₛ "id_map") # Ptr |-> id_map sm).
    cancel (&(manager_pre # "IdManager" ->ₛ "htable") # Ptr |-> htable sm).
  - split_pures; dump_pre_spatial; assumption.
Qed.

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
