From Coq Require Import ZArith List Strings.String micromega.Psatz.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import CRTOS_Verify.lib.SemaphoreInv.
Import ListNotations.
Local Open Scope Z_scope.
Local Open Scope string_scope.
Local Open Scope sac.

(** The layout proposition is declared beside the object predicates in
    CRTOS_Verify.lib.SemaphoreInv. Proofs below retain it as an explicit premise;
    they do not use semaphore_field_offsets_trusted. *)

(** Two owned zero bytes become a zero uint16 slot when the address is aligned.
    Bounds come from the actual character stores, not from a layout assertion. *)
Lemma semaphore_two_zero_chars_ushort : forall p,
  addr_aligned p 2 ->
  p # Char |-> 0 ** (p + 1) # Char |-> 0 |-- p # UShort |-> 0.
Proof.
  intros p Halign.
  unfold store_char, store_ushort, store_2byte.
  Intros.
  Exists 0 0.
  entailer!.
  - unfold isvalidptr_short, isvalidptr_char, aligned_2, addr_aligned in *.
    lia.
Qed.

Lemma semaphore_two_zero_bytes_ushort : forall p,
  addr_aligned p 2 ->
  CharArray.full p 2 (repeat_Z 0 2) |-- p # UShort |-> 0.
Proof.
  intros p Halign.
  eapply derivable1_trans; [|apply semaphore_two_zero_chars_ushort; exact Halign].
  change (repeat_Z 0 2) with [0; 0].
  unfold CharArray.full, store_array.
  cbn [store_array_rec].
  unfold StoreCharAsElement.storeA.
  rewrite sizeof_char.
  replace (p + 0 * 1) with p by lia.
  replace (p + (0 + 1) * 1) with (p + 1) by lia.
  entailer!.
Qed.

(** Four owned zero bytes are the null pointer representation in the current
    Arch32 memory carrier.  This lemma assumes neither object layout nor life. *)
Lemma semaphore_four_zero_chars_ptr : forall p,
  addr_aligned p 4 ->
  p # Char |-> 0 ** (p + 1) # Char |-> 0 **
  (p + 2) # Char |-> 0 ** (p + 3) # Char |-> 0 |-- p # Ptr |-> 0.
Proof.
  intros p Halign.
  unfold store_char, store_ptr.
  change ptr_size with 4%nat.
  unfold store_4byte.
  Intros.
  Exists 0 0 0 0.
  entailer!.
  - unfold isvalidptr, isvalidptr_char, valid_ptr_value, addr_aligned in *.
    change ptr_size_Z with 4.
    change (Arch32.aligned Arch32.ptr_align p) with (p mod 4 = 0).
    lia.
  - unfold valid_ptr_value. change addr_max_unsigned with 4294967295. lia.
Qed.

Lemma semaphore_four_zero_bytes_ptr : forall p,
  addr_aligned p 4 ->
  CharArray.full p 4 (repeat_Z 0 4) |-- p # Ptr |-> 0.
Proof.
  intros p Halign.
  eapply derivable1_trans; [|apply semaphore_four_zero_chars_ptr; exact Halign].
  change (repeat_Z 0 4) with [0; 0; 0; 0].
  unfold CharArray.full, store_array.
  cbn [store_array_rec].
  unfold StoreCharAsElement.storeA.
  rewrite sizeof_char.
  replace (p + 0 * 1) with p by lia.
  replace (p + (0 + 1) * 1) with (p + 1) by lia.
  replace (p + (0 + 1 + 1) * 1) with (p + 2) by lia.
  replace (p + (0 + 1 + 1 + 1) * 1) with (p + 3) by lia.
  entailer!.
Qed.

(** A concrete split of the complete allocation; the two padding ranges remain
    owned. This statement uses arithmetic addresses and needs no struct layout. *)
Lemma semaphore_zero_bytes_fields : forall p,
  addr_aligned p 4 ->
  CharArray.full p 32 (repeat_Z 0 32) |--
  p # UShort |-> 0 ** CharArray.full (p+2) 2 (repeat_Z 0 2) **
  (p+4) # Ptr |-> 0 ** (p+8) # Ptr |-> 0 **
  (p+12) # UShort |-> 0 ** CharArray.full (p+14) 2 (repeat_Z 0 2) **
  (p+16) # Ptr |-> 0 ** (p+20) # Ptr |-> 0 **
  (p+24) # Ptr |-> 0 ** (p+28) # Ptr |-> 0.
Proof.
  intros p Halign.
  sep_apply (CharArray.full_split_to_full p 2 32 (repeat_Z 0 32)); try lia.
  change (sublist 0 2 (repeat_Z 0 32)) with (repeat_Z 0 2).
  change (sublist 2 32 (repeat_Z 0 32)) with (repeat_Z 0 30).
  change (32 - 2) with 30.
  unfold StoreCharAsElement.sizeA. rewrite sizeof_char.
  replace (p + 2 * 1) with (p+2) by lia.
  sep_apply (CharArray.full_split_to_full (p+2) 2 30 (repeat_Z 0 30)); try lia.
  change (sublist 0 2 (repeat_Z 0 30)) with (repeat_Z 0 2).
  change (sublist 2 30 (repeat_Z 0 30)) with (repeat_Z 0 28).
  change (30 - 2) with 28.
  unfold StoreCharAsElement.sizeA. rewrite sizeof_char.
  replace ((p+2) + 2 * 1) with (p+4) by lia.
  sep_apply (CharArray.full_split_to_full (p+4) 4 28 (repeat_Z 0 28)); try lia.
  change (sublist 0 4 (repeat_Z 0 28)) with (repeat_Z 0 4).
  change (sublist 4 28 (repeat_Z 0 28)) with (repeat_Z 0 24).
  change (28 - 4) with 24.
  unfold StoreCharAsElement.sizeA. rewrite sizeof_char.
  replace ((p+4) + 4 * 1) with (p+8) by lia.
  sep_apply (CharArray.full_split_to_full (p+8) 4 24 (repeat_Z 0 24)); try lia.
  change (sublist 0 4 (repeat_Z 0 24)) with (repeat_Z 0 4).
  change (sublist 4 24 (repeat_Z 0 24)) with (repeat_Z 0 20).
  change (24 - 4) with 20.
  unfold StoreCharAsElement.sizeA. rewrite sizeof_char.
  replace ((p+8) + 4 * 1) with (p+12) by lia.
  sep_apply (CharArray.full_split_to_full (p+12) 2 20 (repeat_Z 0 20)); try lia.
  change (sublist 0 2 (repeat_Z 0 20)) with (repeat_Z 0 2).
  change (sublist 2 20 (repeat_Z 0 20)) with (repeat_Z 0 18).
  change (20 - 2) with 18.
  unfold StoreCharAsElement.sizeA. rewrite sizeof_char.
  replace ((p+12) + 2 * 1) with (p+14) by lia.
  sep_apply (CharArray.full_split_to_full (p+14) 2 18 (repeat_Z 0 18)); try lia.
  change (sublist 0 2 (repeat_Z 0 18)) with (repeat_Z 0 2).
  change (sublist 2 18 (repeat_Z 0 18)) with (repeat_Z 0 16).
  change (18 - 2) with 16.
  unfold StoreCharAsElement.sizeA. rewrite sizeof_char.
  replace ((p+14) + 2 * 1) with (p+16) by lia.
  sep_apply (CharArray.full_split_to_full (p+16) 4 16 (repeat_Z 0 16)); try lia.
  change (sublist 0 4 (repeat_Z 0 16)) with (repeat_Z 0 4).
  change (sublist 4 16 (repeat_Z 0 16)) with (repeat_Z 0 12).
  change (16 - 4) with 12.
  unfold StoreCharAsElement.sizeA. rewrite sizeof_char.
  replace ((p+16) + 4 * 1) with (p+20) by lia.
  sep_apply (CharArray.full_split_to_full (p+20) 4 12 (repeat_Z 0 12)); try lia.
  change (sublist 0 4 (repeat_Z 0 12)) with (repeat_Z 0 4).
  change (sublist 4 12 (repeat_Z 0 12)) with (repeat_Z 0 8).
  change (12 - 4) with 8.
  unfold StoreCharAsElement.sizeA. rewrite sizeof_char.
  replace ((p+20) + 4 * 1) with (p+24) by lia.
  sep_apply (CharArray.full_split_to_full (p+24) 4 8 (repeat_Z 0 8)); try lia.
  change (sublist 0 4 (repeat_Z 0 8)) with (repeat_Z 0 4).
  change (sublist 4 8 (repeat_Z 0 8)) with (repeat_Z 0 4).
  change (8 - 4) with 4.
  unfold StoreCharAsElement.sizeA. rewrite sizeof_char.
  replace ((p+24) + 4 * 1) with (p+28) by lia.
  assert (Htwoalign : addr_aligned p 2).
  { unfold addr_aligned in *.
    apply Z.mod_divide in Halign; [|lia].
    destruct Halign as [k Hk].
    apply Z.mod_divide; try lia. exists (2*k). lia. }
  sep_apply (semaphore_two_zero_bytes_ushort p Htwoalign).
  assert (Ha4 : addr_aligned (p+4) 4).
  { unfold addr_aligned in *. rewrite Z.add_mod by lia. rewrite Halign. reflexivity. }
  sep_apply (semaphore_four_zero_bytes_ptr (p+4) Ha4).
  assert (Ha8 : addr_aligned (p+8) 4).
  { unfold addr_aligned in *. rewrite Z.add_mod by lia. rewrite Halign. reflexivity. }
  sep_apply (semaphore_four_zero_bytes_ptr (p+8) Ha8).
  assert (Ha12 : addr_aligned (p+12) 2).
  { unfold addr_aligned in *. rewrite Z.add_mod by lia. rewrite Htwoalign. reflexivity. }
  sep_apply (semaphore_two_zero_bytes_ushort (p+12) Ha12).
  assert (Ha16 : addr_aligned (p+16) 4).
  { unfold addr_aligned in *. rewrite Z.add_mod by lia. rewrite Halign. reflexivity. }
  sep_apply (semaphore_four_zero_bytes_ptr (p+16) Ha16).
  assert (Ha20 : addr_aligned (p+20) 4).
  { unfold addr_aligned in *. rewrite Z.add_mod by lia. rewrite Halign. reflexivity. }
  sep_apply (semaphore_four_zero_bytes_ptr (p+20) Ha20).
  assert (Ha24 : addr_aligned (p+24) 4).
  { unfold addr_aligned in *. rewrite Z.add_mod by lia. rewrite Halign. reflexivity. }
  sep_apply (semaphore_four_zero_bytes_ptr (p+24) Ha24).
  assert (Ha28 : addr_aligned (p+28) 4).
  { unfold addr_aligned in *. rewrite Z.add_mod by lia. rewrite Halign. reflexivity. }
  sep_apply (semaphore_four_zero_bytes_ptr (p+28) Ha28).
  entailer!.
Qed.

(** Complete zeroed malloc block to the private typed object, conditional on
    the explicit ABI proposition.  The additional nonzero embedded-node facts
    must survive calls whose postconditions forget them.  The upper bound is
    the malloc guarantee; character stores additionally establish slot bounds.
    Nothing here establishes [semaphore_byte_layout] globally. *)
Theorem semaphore_zero_bytes_object : forall p,
  semaphore_byte_layout p ->
  0 < p -> p <= 4294967295 - 32 -> addr_aligned p 4 ->
  CharArray.full p 32 (repeat_Z 0 32) |--
  “ &(p # "Semaphore" ->ₛ "pend_list") <> 0 /\
     &(p # "Semaphore" ->ₛ "link") <> 0 ” && SemaphoreZero p.
Proof.
  intros p Hlayout Hpos Hbound Halign.
  destruct Hlayout as [Hid [Hidval [Hidlink [Hval [Hpend [Hlink Hnodes]]]]]].
  destruct (Hnodes 4 ltac:(simpl; auto)) as [Hnext4 Hprev4].
  destruct (Hnodes 16 ltac:(simpl; auto)) as [Hnext16 Hprev16].
  destruct (Hnodes 24 ltac:(simpl; auto)) as [Hnext24 Hprev24].
  sep_apply (semaphore_zero_bytes_fields p Halign).
  unfold SemaphoreZero, ZeroIdNode, NodeZero, SemaphorePadding.
  rewrite Hid, Hidval, Hidlink, Hval, Hpend, Hlink.
  rewrite Hnext4, Hprev4, Hnext16, Hprev16, Hnext24, Hprev24.
  replace (p+4+4) with (p+8) by lia.
  replace (p+16+4) with (p+20) by lia.
  replace (p+24+4) with (p+28) by lia.
  entailer!.
Qed.
