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
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  destruct PreH7 as [[Hidlo Hidhi] _].
  destruct PreH8 as [Hm0 [Hmmax _]].
  assert (qcp_local_end < 8193) as Hend.
  { rewrite PreH2, Z.quot_div_nonneg by lia.
    apply Z.div_lt_upper_bound; lia. }
  change (id + 1 <= 2147483647). lia.
Qed.

Lemma proof_of_AllocId_safety_wit_22_split_goal_2 : AllocId_safety_wit_22_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  destruct PreH7 as [[Hidlo Hidhi] _].
  change (-2147483648 <= id + 1). lia.
Qed.

Lemma proof_of_AllocId_safety_wit_22 : AllocId_safety_wit_22.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_AllocId_safety_wit_22_split_goal_1.
  Goal_apply proof_of_AllocId_safety_wit_22_split_goal_2.
Qed. 

Lemma proof_of_AllocId_safety_wit_27_split_goal_1 : AllocId_safety_wit_27_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  all: dump_pre_spatial.
  all: match goal with
       | |- context [signed_last_nbits ?x 32] =>
         pose proof (signed_Lastnbits_range x 32 ltac:(lia)) as Hrange
       end.
  all: change (-2147483648 <= signed_last_nbits (1 * 2 ^ (id % 8)) 32 < 2147483648) in Hrange; int_auto.
Qed.

Lemma proof_of_AllocId_safety_wit_27_split_goal_2 : AllocId_safety_wit_27_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  all: dump_pre_spatial.
  all: match goal with
       | |- context [signed_last_nbits ?x 32] =>
         pose proof (signed_Lastnbits_range x 32 ltac:(lia)) as Hrange
       end.
  all: change (-2147483648 <= signed_last_nbits (1 * 2 ^ (id % 8)) 32 < 2147483648) in Hrange; int_auto.
Qed.

Lemma proof_of_AllocId_safety_wit_27_split_goal_3 : AllocId_safety_wit_27_split_goal_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  all: dump_pre_spatial.
  all: unfold allocid_entry_scan_inv in *.
  all: assert (Hid : 0 <= id) by lia.
  all: rewrite Z.rem_mod_nonneg by lia.
  all: pose proof (Z.mod_pos_bound id 8 ltac:(lia)); lia.
Qed.

Lemma proof_of_AllocId_safety_wit_27_split_goal_4 : AllocId_safety_wit_27_split_goal_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  all: dump_pre_spatial.
  all: unfold allocid_entry_scan_inv in *.
  all: assert (Hid : 0 <= id) by lia.
  all: rewrite Z.rem_mod_nonneg by lia.
  all: pose proof (Z.mod_pos_bound id 8 ltac:(lia)); lia.
Qed.

Lemma proof_of_AllocId_safety_wit_27 : AllocId_safety_wit_27.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of_AllocId_safety_wit_27_split_goal_1.
  - Goal_apply proof_of_AllocId_safety_wit_27_split_goal_2.
  - Goal_apply proof_of_AllocId_safety_wit_27_split_goal_3.
  - Goal_apply proof_of_AllocId_safety_wit_27_split_goal_4.
Qed. 

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
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  pose proof (id_map_bytes_ok_Znth_range (idmax sm) (idlist before) bytes index PreH11 ltac:(lia)) as Hb.
  unfold allocid_entry_scan_inv.
  split; [lia|]. split; [exact Hb|].
  exists 0. rewrite Z.shiftr_0_r.
  repeat split; try lia.
Qed.

Lemma proof_of_AllocId_entail_wit_5 : AllocId_entail_wit_5.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_AllocId_entail_wit_5_split_goal_1.
Qed. 

Lemma proof_of_AllocId_entail_wit_6_split_goal_1 : AllocId_entail_wit_6_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  pose proof (id_map_bytes_ok_Znth_range (idmax sm) (idlist before) bytes index PreH8 ltac:(lia)) as Hb.
  destruct PreH7 as [Hid [He [offset [Hiddef [Hoffset [Hentry Hprefix]]]]]].
  assert (offset < 8) as Hoffsetlt.
  { destruct (Z.eq_dec offset 8) as [Heq | Hneq]; [|lia].
    exfalso. apply PreH5. apply byte_eq_255_of_low_bits; [exact Hb|].
    intros bit Hbit. apply Hprefix. lia. }
  assert (Z.testbit entry 0 = true) as Hcurrent.
  { rewrite Z.bit0_odd.
    replace 1 with (Z.ones 1) in PreH10 by reflexivity.
    rewrite Z.land_ones in PreH10 by lia.
    change (entry mod 2 <> 0) in PreH10.
    rewrite Zmod_odd in PreH10.
    destruct (Z.odd entry); congruence. }
  assert (Z.testbit (Znth index bytes 0) offset = true) as Hnextbit.
  { rewrite Hentry, Z.shiftr_spec in Hcurrent by lia.
    exact Hcurrent. }
  assert (0 <= Z.shiftr entry 1 <= 255) as Hshift.
  { rewrite Z.shiftr_div_pow2 by lia. change (0 <= entry / 2 <= 255).
    split; [apply Z.div_pos; lia|apply Z.div_le_upper_bound; lia]. }
  assert (unsigned_last_nbits (Z.shiftr entry 1) 8 = Z.shiftr entry 1) as Hcast.
  { unfold unsigned_last_nbits. rewrite Z.mod_small; lia. }
  rewrite Hcast.
  unfold allocid_entry_scan_inv.
  split; [lia|]. split; [exact Hshift|].
  exists (offset + 1). repeat split; try lia.
  - rewrite Hentry, Z.shiftr_shiftr by lia. reflexivity.
  - intros bit Hbit. destruct (Z.eq_dec bit offset) as [->|Hneq].
    + exact Hnextbit.
    + apply Hprefix. lia.
Qed.

Lemma proof_of_AllocId_entail_wit_6 : AllocId_entail_wit_6.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_AllocId_entail_wit_6_split_goal_1.
Qed. 

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
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_AllocId_safety_wit_2 : AllocId_safety_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_AllocId_safety_wit_3 : AllocId_safety_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_AllocId_safety_wit_4 : AllocId_safety_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_AllocId_safety_wit_5 : AllocId_safety_wit_5.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_AllocId_safety_wit_6 : AllocId_safety_wit_6.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_AllocId_safety_wit_7 : AllocId_safety_wit_7.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_AllocId_safety_wit_8 : AllocId_safety_wit_8.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_AllocId_safety_wit_10 : AllocId_safety_wit_10.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_AllocId_safety_wit_11 : AllocId_safety_wit_11.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_AllocId_safety_wit_12 : AllocId_safety_wit_12.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_AllocId_safety_wit_13 : AllocId_safety_wit_13.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


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
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_AllocId_safety_wit_16 : AllocId_safety_wit_16.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_AllocId_safety_wit_17 : AllocId_safety_wit_17.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_AllocId_safety_wit_18 : AllocId_safety_wit_18.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_AllocId_safety_wit_20 : AllocId_safety_wit_20.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_AllocId_safety_wit_21 : AllocId_safety_wit_21.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_AllocId_safety_wit_23 : AllocId_safety_wit_23.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_AllocId_safety_wit_24 : AllocId_safety_wit_24.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_AllocId_safety_wit_25 : AllocId_safety_wit_25.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_AllocId_safety_wit_26 : AllocId_safety_wit_26.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_AllocId_safety_wit_28 : AllocId_safety_wit_28.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_AllocId_safety_wit_29 : AllocId_safety_wit_29.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_AllocId_safety_wit_30 : AllocId_safety_wit_30.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_AllocId_entail_wit_1 : AllocId_entail_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of_AllocId_partial_solve_wit_1 : AllocId_partial_solve_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  split_pure_spatial.
  - sep_apply_l_atomic (UCharArray.full_split_to_missing_i
      (id_map sm) index ((idmax sm + 7) ÷ 8) bytes 0 ltac:(lia)).
    cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed. 


Lemma proof_of_AllocId_partial_solve_wit_2 : AllocId_partial_solve_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  split_pure_spatial.
  - sep_apply_l_atomic (UCharArray.full_split_to_missing_i
      (id_map sm) index ((idmax sm + 7) ÷ 8) bytes 0 ltac:(lia)).
    cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed. 


Lemma proof_of_AllocId_partial_solve_wit_3 : AllocId_partial_solve_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  split_pure_spatial.
  - sep_apply_l_atomic (UCharArray.full_split_to_missing_i
      (id_map sm) index ((idmax sm + 7) ÷ 8) bytes 0 ltac:(lia)).
    cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed. 


Lemma proof_of_AllocId_partial_solve_wit_4 : AllocId_partial_solve_wit_4.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  split_pure_spatial.
  - sep_apply_l_atomic (UCharArray.full_split_to_missing_i
      (id_map sm) index ((idmax sm + 7) ÷ 8) bytes 0 ltac:(lia)).
    unfold StoreUCharAsElement.storeA.
    sep_apply_l_atomic (store_uchar_undef_store_uchar
      (id_map sm + index * sizeof(UCHAR)) (Znth index bytes 0)).
    cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed.
