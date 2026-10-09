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

Lemma proof_of_AllocId_safety_wit_8 : AllocId_safety_wit_8.
Proof.
  unfold AllocId_safety_wit_8. left. intros. entailer!.
  all: unfold SemaphoreStableContext in PreH4;
    destruct PreH4 as (_ & _ & _ & _ & Hidlimit & _);
    unfold SEM_ID_MAX in Hidlimit; rewrite Hidlimit; lia.
Qed.

Lemma proof_of_AllocId_safety_wit_18 : AllocId_safety_wit_18.
Proof.
  unfold AllocId_safety_wit_18. left. intros. entailer!.
  all: unfold SemaphoreStableContext in PreH5;
    destruct PreH5 as (_ & _ & _ & _ & Hidlimit & _);
    unfold SEM_ID_MAX in Hidlimit; rewrite Hidlimit in PreH6;
    vm_compute in PreH6; lia.
Qed.

Lemma proof_of_AllocId_safety_wit_21 : AllocId_safety_wit_21.
Proof.
  unfold AllocId_safety_wit_21. left. intros. entailer!.
  all: unfold SemaphoreStableContext in PreH2;
    destruct PreH2 as (_ & _ & _ & _ & Hidlimit & _);
    unfold semaphore_alloc_entry_inv in PreH7;
    destruct PreH7 as (offset & Hid & Hoff & _ & _ & _ & _ & _);
    unfold SEM_ID_MAX in Hidlimit; rewrite Hidlimit in *;
    vm_compute in PreH3; lia.
Qed.

Lemma proof_of_AllocId_safety_wit_26 : AllocId_safety_wit_26.
Proof.
  unfold AllocId_safety_wit_26. left. intros.
  pose proof PreH8 as Hentry.
  unfold semaphore_alloc_entry_inv in Hentry.
  destruct Hentry as
    (offset & Hid & Hoff & _ & _ & _ & _ & _).
  assert (Hid_nonneg : 0 <= id) by nia.
  entailer!.
  - pose proof
      (Z.rem_bound_pos_pos id 8 ltac:(lia) Hid_nonneg) as Hrem.
    lia.
  - pose proof
      (Z.rem_bound_pos_pos id 8 ltac:(lia) Hid_nonneg) as Hrem.
    lia.
  - pose proof (signed_Lastnbits_range
      (1 * 2 ^ (Z.rem id 8)) 32 ltac:(lia)) as Hsigned.
    change (-2147483648 <= signed_last_nbits
      (1 * 2 ^ (Z.rem id 8)) 32 < 2147483648) in Hsigned.
    lia.
  - pose proof (signed_Lastnbits_range
      (1 * 2 ^ (Z.rem id 8)) 32 ltac:(lia)) as Hsigned.
    change (-2147483648 <= signed_last_nbits
      (1 * 2 ^ (Z.rem id 8)) 32 < 2147483648) in Hsigned.
    lia.
Qed.

Lemma proof_of_AllocId_entail_wit_1 : AllocId_entail_wit_1.
Proof.
  unfold AllocId_entail_wit_1. left. intros.
  pose proof PreH4 as Hstable.
  unfold SemaphoreStableContext in Hstable.
  destruct Hstable as (_ & _ & _ & _ & Hidlimit & _).
  assert (Hinit : semaphore_alloc_index_inv stable before 0).
  { apply semaphore_alloc_index_inv_init_local.
    unfold SEM_ID_MAX in Hidlimit. lia. }
  entailer!.
  unfold SEM_ID_MAX in Hidlimit. rewrite Hidlimit. vm_compute.
  intro Hfalse. discriminate Hfalse.
Qed.

Lemma proof_of_AllocId_entail_wit_2 : AllocId_entail_wit_2.
Proof.
  unfold AllocId_entail_wit_2. left. intros.
  pose proof PreH4 as Hstable.
  unfold SemaphoreStableContext in Hstable.
  destruct Hstable as (_ & _ & _ & _ & Hidlimit & _).
  assert (Hnum : 0 <= semaphore_id_limit stable + 7).
  { unfold SEM_ID_MAX in Hidlimit. rewrite Hidlimit. lia. }
  pose proof PreH5 as Hscan_div.
  rewrite (Z.quot_div_nonneg _ 8 Hnum ltac:(lia)) in Hscan_div.
  assert (Hrange :
      0 <= index < (semaphore_id_limit stable + 7) / 8).
  { split; [exact PreH6 |]. rewrite <- Hscan_div. exact PreH2. }
  pose proof (semaphore_alloc_index_inv_step_local
      stable before bytes index PreH9 PreH8 Hrange PreH1) as Hstep.
  entailer!.
Qed.

Lemma proof_of_AllocId_entail_wit_3 : AllocId_entail_wit_3.
Proof.
  unfold AllocId_entail_wit_3. left. intros.
  pose proof PreH5 as Hstable.
  unfold SemaphoreStableContext in Hstable.
  destruct Hstable as (_ & _ & _ & _ & Hidlimit & _).
  unfold SEM_ID_MAX in Hidlimit.
  assert (Hscan : scan_end = 16).
  { rewrite Hidlimit in PreH6. vm_compute in PreH6. exact PreH6. }
  assert (Hbyte_range : 0 <= Znth index bytes 0 <= 255).
  { apply semaphore_bitmap_ok_Znth_range_local with
      (stable := stable) (state := before).
    - exact PreH10.
    - rewrite Hidlimit. change (0 <= index < 16). lia. }
  assert (Hcovered : (index + 1) * 8 <= semaphore_id_limit stable).
  { rewrite Hidlimit. lia. }
  assert (Hbits : forall bit, 0 <= bit < 8 ->
      Z.testbit (Znth index bytes 0) bit =
      semaphore_id_used before (index * 8 + bit)).
  { eapply semaphore_bitmap_ok_byte_bits_local; eauto. }
  assert (Hentry : semaphore_alloc_entry_inv stable before index
      (index * 8) (Znth index bytes 0)).
  { apply semaphore_alloc_entry_inv_init; try assumption; lia. }
  entailer!.
Qed.

Lemma proof_of_AllocId_entail_wit_4 : AllocId_entail_wit_4.
Proof.
  unfold AllocId_entail_wit_4. left. intros.
  pose proof PreH7 as Hentry_data.
  unfold semaphore_alloc_entry_inv in Hentry_data.
  destruct Hentry_data as
    (offset & Hid & Hoff & Hentry_range & _ & _ & _ & Hlimit).
  pose proof PreH2 as Hstable.
  unfold SemaphoreStableContext in Hstable.
  destruct Hstable as (_ & _ & _ & _ & Hidlimit & _).
  unfold SEM_ID_MAX in Hidlimit.
  assert (Hscan : scan_end_2 = 16).
  { rewrite Hidlimit in PreH3. vm_compute in PreH3. exact PreH3. }
  assert (Hstep_limit : id + 1 <= semaphore_id_limit stable + 7).
  { rewrite Hidlimit. lia. }
  assert (Hbit : Z.testbit entry 0 = true).
  { apply sem_land_one_nonzero_testbit. exact PreH24. }
  assert (Hshift : 0 <= Z.shiftr entry 1 <= 255).
  { apply sem_shiftr_one_range. exact Hentry_range. }
  assert (Hnext_raw : semaphore_alloc_entry_inv stable before index_2
      (id + 1) (Z.shiftr entry 1)).
  { eapply semaphore_alloc_entry_inv_step; eauto. }
  assert (Hnext : semaphore_alloc_entry_inv stable before index_2
      (id + 1) (unsigned_last_nbits (Z.shiftr entry 1) 8)).
  { rewrite unsigned_last_nbits_eq; [exact Hnext_raw |].
    change (0 <= Z.shiftr entry 1 < 256). lia. }
  entailer!.
Qed.

Lemma proof_of_AllocId_return_wit_1 : AllocId_return_wit_1.
Proof.
  unfold AllocId_return_wit_1. intros.
  pose proof PreH3 as Hstable.
  unfold SemaphoreStableContext in Hstable.
  destruct Hstable as (_ & _ & _ & _ & Hidlimit & _).
  assert (Hnum : 0 <= semaphore_id_limit stable + 7).
  { unfold SEM_ID_MAX in Hidlimit. rewrite Hidlimit. lia. }
  assert (Hbit : Z.testbit entry 0 = false).
  { apply sem_land_one_zero_testbit. exact PreH25. }
  pose proof PreH8 as Hentry_data.
  unfold semaphore_alloc_entry_inv in Hentry_data.
  destruct Hentry_data as
    (offset & Hid & Hoff & _ & Hprefix & Hfree & _ & _).
  destruct Hfree as (free_bit & Hfree_range & Hfree).
  assert (Hoffset8 : offset < 8).
  { destruct (Z.eq_dec offset 8) as [Heq | Hneq]; [| lia].
    subst offset. specialize (Hprefix free_bit Hfree_range).
    rewrite Hfree in Hprefix. discriminate. }
  assert (Hidrange : 0 <= id < semaphore_id_limit stable) by lia.
  assert (Hcell : index_2 * 8 <= id < (index_2 + 1) * 8).
  { rewrite Hid. lia. }
  assert (Hindex : index_2 = id / 8).
  { symmetry. exact (sem_div8_eq_of_range index_2 id Hcell). }
  pose proof (semaphore_alloc_entry_inv_first_free
    stable before index_2 id entry PreH7 PreH8 Hbit Hidrange) as Hfirst.
  pose proof (semaphore_bitmap_ids_ok_add_local
    stable (semaphore_ids (semaphore_objects before)) bytes index_2 id
    Hidlimit PreH9 Hidrange Hindex) as Hbitmap.
  change (semaphore_bitmap_ids_ok stable
      (id :: semaphore_ids (semaphore_objects before))
      (replace_Znth index_2
        (Z.lor (unsigned_last_nbits (Znth index_2 bytes 0) 8)
          (unsigned_last_nbits (Z.shiftl 1 (Z.rem id 8)) 8)) bytes))
    in Hbitmap.
  rewrite Z.quot_div_nonneg by lia.
  sep_apply (store_semaphore_bitmap_ids_intro_local stable
    (id :: semaphore_ids (semaphore_objects before))
    (replace_Znth index_2
      (Z.lor (unsigned_last_nbits (Znth index_2 bytes 0) 8)
        (unsigned_last_nbits (Z.shiftl 1 (Z.rem id 8)) 8)) bytes)
    Hbitmap).
  sep_apply (store_sem_manager_id_allocated_from_parts_local
    stable before id manager_pre PreH24 Hfirst).
  left.
  entailer!.
  Unshelve.
  unfold andp, coq_prop in |- *.
  split; [exact PreH2 |].
  split; [exact PreH3 |].
  split; [lia |].
  split; [exact Hfirst | exact H].
Qed.

Lemma proof_of_AllocId_return_wit_2 : AllocId_return_wit_2.
Proof.
  unfold AllocId_return_wit_2. left. intros.
  pose proof PreH3 as Hstable.
  unfold SemaphoreStableContext in Hstable.
  destruct Hstable as (_ & _ & _ & _ & Hidlimit & _).
  assert (Hlimit_nonneg : 0 <= semaphore_id_limit stable).
  { unfold SEM_ID_MAX in Hidlimit. rewrite Hidlimit. lia. }
  assert (Hpast : semaphore_id_limit stable <= id) by lia.
  pose proof (semaphore_alloc_entry_inv_no_free_local
    stable before index_2 id entry Hlimit_nonneg PreH7 PreH8 Hpast) as Hnone.
  assert (Hnum : 0 <= semaphore_id_limit stable + 7) by lia.
  rewrite Z.quot_div_nonneg by lia.
  sep_apply (store_semaphore_bitmap_intro_local stable before bytes PreH9).
  sep_apply (store_semaphore_id_manager_from_parts_local
    stable before manager_pre PreH24).
  entailer!.
Qed.

Lemma proof_of_AllocId_return_wit_3 : AllocId_return_wit_3.
Proof.
  unfold AllocId_return_wit_3. left. intros.
  pose proof PreH4 as Hstable.
  unfold SemaphoreStableContext in Hstable.
  destruct Hstable as (_ & _ & _ & _ & Hidlimit & _).
  assert (Hlimit_nonneg : 0 <= semaphore_id_limit stable).
  { unfold SEM_ID_MAX in Hidlimit. rewrite Hidlimit. lia. }
  assert (Hscan : scan_end = 16).
  { unfold SEM_ID_MAX in Hidlimit.
    rewrite Hidlimit in PreH5. vm_compute in PreH5. exact PreH5. }
  assert (Hcovered : semaphore_id_limit stable <= index * 8).
  { unfold SEM_ID_MAX in Hidlimit. rewrite Hidlimit. lia. }
  pose proof (semaphore_alloc_index_inv_no_free_local
    stable before index Hlimit_nonneg PreH8 Hcovered) as Hnone.
  assert (Hnum : 0 <= semaphore_id_limit stable + 7) by lia.
  rewrite Z.quot_div_nonneg by lia.
  sep_apply (store_semaphore_bitmap_intro_local stable before bytes PreH9).
  sep_apply (store_semaphore_id_manager_from_parts_local
    stable before manager_pre PreH14).
  entailer!.
Qed.

Lemma proof_of_AllocId_which_implies_wit_1 : AllocId_which_implies_wit_1.
Proof.
  unfold AllocId_which_implies_wit_1. left. intros.
  subst manager_pre.
  pose proof PreH2 as Hstable.
  unfold SemaphoreStableContext in Hstable.
  destruct Hstable as (_ & _ & _ & _ & Hidlimit & _).
  assert (Hnum : 0 <= semaphore_id_limit stable + 7).
  { unfold SEM_ID_MAX in Hidlimit. rewrite Hidlimit. lia. }
  unfold store_semaphore_id_manager, store_semaphore_bitmap.
  Intros bytes.
  Exists bytes.
  rewrite Z.quot_div_nonneg by lia.
  entailer!.
Qed.
