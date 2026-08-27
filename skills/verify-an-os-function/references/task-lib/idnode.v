Require Import Coq.ZArith.ZArith.
Require Import Coq.Bool.Bool.
Require Import Coq.Strings.String.
Require Import Coq.Lists.List.
Require Import Coq.Classes.RelationClasses.
Require Import Coq.Classes.Morphisms.
Require Import Coq.micromega.Psatz.
Require Import Coq.Sorting.Permutation.
From AUXLib Require Import int_auto Axioms Feq Idents ListLib VMap.
Require Import SetsClass.SetsClass.
Import SetsNotation.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.


Require Import SL.ConAssertion SL.CriticalSTS SL.NestedCriticalSTS.
From MonadLib.StateRelMonad Require Export StateRelMonad.
Export MonadNotation.

Require Export CRTOS_Verify.lib.dll_abs.
Require Export CRTOS_Verify.lib.idnode_abs.
Require Export CRTOS_Verify.lib.dll.
(* Require Export CRTOS_Verify.lib.bitmap. *)

Require Export CRTOS_Verify.lib.CrtosRules.

Import DLL.

Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string.
Local Open Scope list.
Local Open Scope sac.
Local Open Scope monad.

Module IDNode.

Definition id_in_ids (id: Z) (ids: list Z): bool :=
  if in_dec Z.eq_dec id ids then true else false.

Definition idlist_add (id: Z) (ids: list Z): list Z :=
  id :: ids.

Definition idlist_remove (id: Z) (ids: list Z): list Z :=
  remove Z.eq_dec id ids.

Definition idnode_ids (nodes: list IdNodeAbs): list Z :=
  map idnode_id nodes.

Definition idnode_eq_dec (x y: IdNodeAbs): {x = y} + {x <> y}.
Proof.
  decide equality; apply Z.eq_dec.
Defined.

Fixpoint idnodes_remove_id (id: Z) (nodes: list IdNodeAbs): list IdNodeAbs :=
  match nodes with
  | nil => nil
  | node :: rest =>
      if Z.eq_dec node.(idnode_id) id
      then idnodes_remove_id id rest
      else node :: idnodes_remove_id id rest
  end.

Definition idmanager_add (m: VarIdmanager) (id: Z): VarIdmanager :=
  Build_VarIdmanager (idlist_add id m.(idlist)) m.(idbuckets).

Definition idmanager_delete (m: VarIdmanager) (id: Z): VarIdmanager :=
  Build_VarIdmanager (idlist_remove id m.(idlist)) m.(idbuckets).

Definition idmanager_bucket_index (m: StableIdmanager) (id: Z): Z :=
  id mod m.(hoffset).

Definition idmanager_insert_bucket
  (hoffset id: Z) (p: addr)
  (buckets: list (list IdNodeAbs)): list (list IdNodeAbs) :=
  let index := id mod hoffset in
  replace_Znth index
    (Build_IdNodeAbs id p :: Znth index buckets nil) buckets.

Definition idmanager_link
  (sm: StableIdmanager) (m: VarIdmanager)
  (id: Z) (p: addr): VarIdmanager :=
  Build_VarIdmanager
    m.(idlist)
    (idmanager_insert_bucket sm.(hoffset) id p m.(idbuckets)).

Definition idmanager_remove_bucket
  (hoffset id: Z) (buckets: list (list IdNodeAbs)): list (list IdNodeAbs) :=
  let index := id mod hoffset in
  replace_Znth index
    (idnodes_remove_id id (Znth index buckets nil)) buckets.

Definition idmanager_remove
  (sm: StableIdmanager) (m: VarIdmanager) (id: Z): VarIdmanager :=
  Build_VarIdmanager
    (idlist_remove id m.(idlist))
    (idmanager_remove_bucket sm.(hoffset) id m.(idbuckets)).

Definition idnodes_no_id (id: Z) (nodes: list IdNodeAbs): Prop :=
  ~ In id (idnode_ids nodes).

Definition idmanager_query (m: VarIdmanager) (id: Z): bool :=
  id_in_ids id m.(idlist).

Definition idmanager_min_free_id
  (sm: StableIdmanager) (m: VarIdmanager) (id: Z): Prop :=
  0 <= id < sm.(idmax) /\
  idmanager_query m id = false /\
  forall id',
    0 <= id' < id ->
    idmanager_query m id' = true.

Definition idmanager_full (sm: StableIdmanager) (m: VarIdmanager): Prop :=
  forall id,
    0 <= id < sm.(idmax) ->
    idmanager_query m id = true.

Fixpoint idmanager_first_free_id_from
  (m: VarIdmanager) (fuel: nat) (id: Z): option Z :=
  match fuel with
  | O => None
  | S fuel' =>
      if idmanager_query m id
      then idmanager_first_free_id_from m fuel' (id + 1)
      else Some id
  end.

Definition idmanager_first_free_id
  (sm: StableIdmanager) (m: VarIdmanager): option Z :=
  idmanager_first_free_id_from m (Z.to_nat sm.(idmax)) 0.

Lemma id_in_ids_true_iff:
  forall id ids,
    id_in_ids id ids = true <-> In id ids.
Proof.
  intros id ids.
  unfold id_in_ids.
  destruct (in_dec Z.eq_dec id ids); intuition congruence.
Qed.

Lemma id_in_ids_false_iff:
  forall id ids,
    id_in_ids id ids = false <-> ~ In id ids.
Proof.
  intros id ids.
  unfold id_in_ids.
  destruct (in_dec Z.eq_dec id ids); intuition congruence.
Qed.

Definition allocid_index_scan_inv (bytes: list Z) (index: Z): Prop :=
  0 <= index /\
  forall i,
    0 <= i < index ->
    Znth i bytes 0 = 255.

Definition allocid_entry_scan_inv (bytes: list Z) (index id entry: Z): Prop :=
  index * 8 <= id <= index * 8 + 8 /\
  0 <= entry <= 255 /\
  exists offset,
    id = index * 8 + offset /\
    0 <= offset <= 8 /\
    entry = Z.shiftr (Znth index bytes 0) offset /\
    forall bit,
      0 <= bit < offset ->
      Z.testbit (Znth index bytes 0) bit = true.

Definition idlist_ok (idmax: Z) (ids: list Z): Prop :=
  Forall (fun id => 0 <= id < idmax) ids /\
  NoDup ids.

Fixpoint idbuckets_index_ok
  (hoffset index: Z) (buckets: list (list IdNodeAbs)): Prop :=
  match buckets with
  | nil => True
  | nodes :: buckets' =>
      Forall (fun node => node.(idnode_id) mod hoffset = index) nodes /\
      idbuckets_index_ok hoffset (index + 1) buckets'
  end.

Definition idnodes_ok (idmax: Z) (nodes: list IdNodeAbs): Prop :=
  idlist_ok idmax (idnode_ids nodes) /\
  Forall (fun node => node.(idnode_addr) <> 0) nodes.

Definition idbuckets_ok
  (idmax hoffset: Z) (ids: list Z) (buckets: list (list IdNodeAbs)): Prop :=
  0 < hoffset /\
  Zlength buckets = hoffset /\
  idlist_ok idmax ids /\
  Forall (idnodes_ok idmax) buckets /\
  idbuckets_index_ok hoffset 0 buckets /\
  Permutation (idnode_ids (concat buckets)) ids.

Definition id_map_bytes_ok (idmax: Z) (ids bytes: list Z): Prop :=
  0 <= idmax /\
  idmax <= 65535 /\
  Zlength bytes = (idmax + 7) / 8 /\
  idlist_ok idmax ids /\
  Forall (fun byte => 0 <= byte <= 255) bytes /\
  forall id,
    0 <= id < idmax ->
    Z.testbit (Znth (id / 8) bytes 0) (id mod 8) = id_in_ids id ids.

Lemma Forall_Znth_Zlength:
  forall {A: Type} (P: A -> Prop) (l: list A) (d: A) (i: Z),
    Forall P l ->
    0 <= i < Zlength l ->
    P (Znth i l d).
Proof.
  intros A P l d i HForall Hrange.
  apply Forall_forall with (x := Znth i l d) in HForall; auto.
  unfold Znth.
  apply nth_In.
  apply Nat2Z.inj_lt.
  rewrite Z2Nat.id by lia.
  rewrite <- Zlength_correct.
  lia.
Qed.

Lemma id_map_bytes_ok_Znth_range:
  forall idmax ids bytes index,
    id_map_bytes_ok idmax ids bytes ->
    0 <= index < (idmax + 7) ÷ 8 ->
    0 <= Znth index bytes 0 <= 255.
Proof.
  intros idmax ids bytes index Hok Hindex.
  unfold id_map_bytes_ok in Hok.
  destruct Hok as [Hnonneg [_ [Hlen [_ [Hbytes _]]]]].
  apply Forall_Znth_Zlength; auto.
  rewrite Hlen.
  rewrite Z.quot_div_nonneg in Hindex by lia.
  lia.
Qed.

Lemma id_map_bytes_ok_query_eq:
  forall sm m bytes id,
    id_map_bytes_ok sm.(idmax) m.(idlist) bytes ->
    0 <= id < sm.(idmax) ->
    idmanager_query m id =
    Z.testbit (Znth (id / 8) bytes 0) (id mod 8).
Proof.
  intros sm m bytes id Hok Hid.
  unfold idmanager_query.
  unfold id_map_bytes_ok in Hok.
  destruct Hok as [_ [_ [_ [_ [_ Hbits]]]]].
  symmetry.
  apply Hbits.
  exact Hid.
Qed.

Lemma Ztestbit_255_low:
  forall bit,
    0 <= bit < 8 ->
    Z.testbit 255 bit = true.
Proof.
  intros bit Hbit.
  assert (bit = 0 \/ bit = 1 \/ bit = 2 \/ bit = 3 \/
          bit = 4 \/ bit = 5 \/ bit = 6 \/ bit = 7) as Hcases by lia.
  destruct Hcases as [-> | [-> | [-> | [-> | [-> | [-> | [-> | ->]]]]]]];
    reflexivity.
Qed.

Lemma div8_add_offset:
  forall index offset,
    0 <= offset < 8 ->
    (index * 8 + offset) / 8 = index.
Proof.
  intros index offset Hoff.
  rewrite Z.add_comm.
  rewrite Z.div_add by lia.
  rewrite Z.div_small by lia.
  lia.
Qed.

Lemma mod8_add_offset:
  forall index offset,
    0 <= offset < 8 ->
    (index * 8 + offset) mod 8 = offset.
Proof.
  intros index offset Hoff.
  rewrite Z.add_comm.
  rewrite Z.add_mod by lia.
  replace (8 * index) with (index * 8) by lia.
  rewrite Z_mod_mult by lia.
  rewrite Z.add_0_r.
  replace (offset mod 8) with offset by (symmetry; apply Z.mod_small; lia).
  apply Z.mod_small; lia.
Qed.

Lemma div8_eq_of_range:
  forall index id,
    index * 8 <= id < index * 8 + 8 ->
    id / 8 = index.
Proof.
  intros index id Hid.
  assert (exists offset, id = index * 8 + offset /\ 0 <= offset < 8) as Hoff.
  {
    exists (id - index * 8).
    split; lia.
  }
  destruct Hoff as [offset [Hid_eq Hoff]].
  subst id.
  apply div8_add_offset; lia.
Qed.

Lemma same_div8_mod8_neq:
  forall x y index,
    0 <= x ->
    0 <= y ->
    x / 8 = index ->
    y / 8 = index ->
    x <> y ->
    x mod 8 <> y mod 8.
Proof.
  intros x y index Hx Hy Hxdiv Hydiv Hneq Hmod.
  apply Hneq.
  pose proof (Z.div_mod x 8 ltac:(lia)) as Hxrepr.
  pose proof (Z.div_mod y 8 ltac:(lia)) as Hyrepr.
  lia.
Qed.

Lemma idmax_le_8_quot_ceil8:
  forall idmax,
    0 <= idmax ->
    idmax <= 8 * ((idmax + 7) ÷ 8).
Proof.
  intros idmax Hnonneg.
  rewrite Z.quot_div_nonneg by lia.
  pose proof (Z.div_mod (idmax + 7) 8 ltac:(lia)) as Hdiv.
  pose proof (Z.mod_pos_bound (idmax + 7) 8 ltac:(lia)) as Hmod.
  lia.
Qed.

Lemma id_div8_lt_quot_ceil8:
  forall id idmax,
    0 <= id < idmax ->
    id / 8 < (idmax + 7) ÷ 8.
Proof.
  intros id idmax Hid.
  rewrite Z.quot_div_nonneg by lia.
  apply Z.div_lt_upper_bound; try lia.
  pose proof (idmax_le_8_quot_ceil8 idmax ltac:(lia)) as Hceil.
  rewrite Z.quot_div_nonneg in Hceil by lia.
  lia.
Qed.

Lemma byte_eq_255_of_low_bits:
  forall b,
    0 <= b <= 255 ->
    (forall bit, 0 <= bit < 8 -> Z.testbit b bit = true) ->
    b = 255.
Proof.
  intros b Hb Hbits.
  apply Z.bits_inj.
  unfold Z.eqf.
  intros n.
  destruct (Z_lt_ge_dec n 0) as [Hnneg | Hnnonneg].
  - rewrite Z.testbit_neg_r by lia.
    rewrite Z.testbit_neg_r by lia.
    reflexivity.
  - destruct (Z_lt_ge_dec n 8) as [Hnlow | Hnhigh].
    + rewrite Hbits by lia.
      symmetry; apply Ztestbit_255_low; lia.
    + assert (256 <= 2 ^ n) as Hpow.
      { replace 256 with (2 ^ 8) by reflexivity.
        apply Z.pow_le_mono_r; lia. }
      assert (Z.testbit b n = false) as Hbhigh.
      { destruct (Z.eq_dec b 0) as [-> | Hbneq].
        - apply Z.bits_0.
        - apply Z.bits_above_log2.
          + lia.
          + apply (proj1 (Z.log2_lt_pow2 b n ltac:(lia))); lia. }
      rewrite Hbhigh.
      assert (Z.testbit 255 n = false) as H255high.
      { apply Z.bits_above_log2.
        - lia.
        - apply (proj1 (Z.log2_lt_pow2 255 n ltac:(lia))); lia. }
      rewrite H255high.
      reflexivity.
Qed.

Lemma Ztestbit_1_neq0:
  forall bit,
    bit <> 0 ->
    Z.testbit 1 bit = false.
Proof.
  intros bit Hneq.
  destruct (Z_lt_ge_dec bit 0) as [Hneg | Hnonneg].
  - apply Z.testbit_neg_r; lia.
  - assert (0 < bit) by lia.
    apply Z.bits_above_log2.
    + lia.
    + apply (proj1 (Z.log2_lt_pow2 1 bit ltac:(lia))).
      apply Zpow_facts.Zpower_gt_1; lia.
Qed.

Lemma id_in_ids_add_neq:
  forall query id ids,
    query <> id ->
    id_in_ids query (idlist_add id ids) = id_in_ids query ids.
Proof.
  intros query id ids Hneq.
  unfold idlist_add, id_in_ids.
  destruct (in_dec Z.eq_dec query (id :: ids)) as [Hin_cons | Hnotin_cons];
  destruct (in_dec Z.eq_dec query ids) as [Hin | Hnotin]; auto.
  - destruct Hin_cons as [Heq | Hin']; [congruence | contradiction].
  - exfalso; apply Hnotin_cons; right; exact Hin.
Qed.

Lemma Forall_replace_nth:
  forall {A: Type} (P: A -> Prop) n l a,
    Forall P l ->
    P a ->
    Forall P (replace_nth n l a).
Proof.
  intros A P n l a HForall Ha.
  revert n.
  induction HForall; intros n.
  - destruct n; constructor.
  - destruct n; simpl; constructor; auto.
Qed.

Lemma Forall_replace_Znth:
  forall {A: Type} (P: A -> Prop) i l a,
    Forall P l ->
    P a ->
    Forall P (replace_Znth i a l).
Proof.
  intros A P i l a HForall Ha.
  unfold replace_Znth.
  apply Forall_replace_nth; auto.
Qed.

Definition store_uchar_array (p: addr) (n: Z) (bytes: list Z): Assertion :=
  UCharArray.full p n bytes.

Definition store_id_map (id_map: addr) (idmax: Z) (ids: list Z): Assertion :=
  EX bytes: list Z,
    “ id_map_bytes_ok idmax ids bytes ” &&
    store_uchar_array id_map ((idmax + 7) / 8) bytes.

Definition idnode_link (node: IdNodeAbs): addr :=
  let p := node.(idnode_addr) in
  &(p # "IdNode" ->ₛ "link").

Definition idnode_to_dll (node: IdNodeAbs): DL_Node IdNodeAbs :=
  Build_DL_Node node (idnode_link node).

Definition idnodes_to_dll (nodes: list IdNodeAbs): list (DL_Node IdNodeAbs) :=
  map idnode_to_dll nodes.

Definition idnodes_nonzero (nodes: list IdNodeAbs): Prop :=
  dll_nodes_nonzero (idnodes_to_dll nodes).

Definition store_idnode (link: addr) (node: IdNodeAbs): Assertion :=
  let p := node.(idnode_addr) in
  “ p <> 0 /\ link = idnode_link node ” &&
  &(p # "IdNode" ->ₛ "id") # UShort |-> node.(idnode_id).

Definition store_idnode_unlinked (link: addr) (node: IdNodeAbs): Assertion :=
  “ link <> 0 ” &&
  store_idnode link node **
  &(link # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |->_ **
  &(link # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |->_.

Definition store_idnode_insert_ready (p: addr): Assertion :=
  “ p <> 0 /\ &(p # "IdNode" ->ₛ "link") <> 0 ” &&
  &(p # "IdNode" ->ₛ "id") # UShort |->_ **
  &(p # "IdNode" ->ₛ "link" .ₛ "node_prev") # Ptr |->_ **
  &(p # "IdNode" ->ₛ "link" .ₛ "node_next") # Ptr |->_.

Definition store_idnodes (head: addr) (nodes: list IdNodeAbs): Assertion :=
  store_dll store_idnode head (idnodes_to_dll nodes).

Definition idnodes_dllseg
  (x px y py: addr) (nodes: list IdNodeAbs): Assertion :=
  dllseg store_idnode x px y py (idnodes_to_dll nodes).

Definition store_uninit_idbucket (head: addr): Assertion :=
  &(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> 0 **
  &(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> 0.

Definition store_idbucket (head: addr) (nodes: list IdNodeAbs): Assertion :=
  match nodes with
  | nil => store_idnodes head nil || store_uninit_idbucket head
  | _ => store_idnodes head nodes
  end.

Fixpoint store_idbucket_list
  (htable: addr) (index: Z) (buckets: list (list IdNodeAbs)): Assertion :=
  match buckets with
  | nil => emp
  | nodes :: rest =>
      store_idbucket (htable + index * sizeof("SysDoubleLinklistNode")) nodes **
      store_idbucket_list htable (index + 1) rest
  end.

Definition store_idbuckets_except
  (htable: addr) (index: Z)
  (bucket: list IdNodeAbs) (buckets: list (list IdNodeAbs)): Assertion :=
  EX prefix suffix: list (list IdNodeAbs),
    “ buckets = prefix ++ bucket :: suffix /\ Zlength prefix = index ” &&
    store_idbucket_list htable 0 prefix **
    store_idbucket_list htable (index + 1) suffix.

Definition store_idbuckets
  (htable: addr) (hoffset: Z) (buckets: list (list IdNodeAbs)): Assertion :=
  store_idbucket_list htable 0 buckets.

Definition store_idmanager
  (sm: StableIdmanager) (m: VarIdmanager) (p: addr): Assertion :=
  &(p # "IdManager" ->ₛ "id_max") # UShort |-> sm.(idmax) **
  &(p # "IdManager" ->ₛ "hoffset") # UShort |-> sm.(hoffset) **
  &(p # "IdManager" ->ₛ "id_map") # Ptr |-> sm.(id_map) **
  store_id_map sm.(id_map) sm.(idmax) m.(idlist) **
  &(p # "IdManager" ->ₛ "htable") # Ptr |-> sm.(htable) **
  (“ idbuckets_ok sm.(idmax) sm.(hoffset) m.(idlist) m.(idbuckets) ” &&
   store_idbuckets sm.(htable) sm.(hoffset) m.(idbuckets)).

Definition store_idmanager_found
  (sm: StableIdmanager) (m: VarIdmanager)
  (manager idnode: addr) (id: Z): Assertion :=
  EX bytes: list Z,
  EX prefix suffix bucket: list IdNodeAbs,
    “ 0 <= id < sm.(idmax) /\
      id_map_bytes_ok sm.(idmax) m.(idlist) bytes /\
      idbuckets_ok sm.(idmax) sm.(hoffset) m.(idlist) m.(idbuckets) /\
      bucket = Znth (id mod sm.(hoffset)) m.(idbuckets) nil /\
      bucket = prefix ++ Build_IdNodeAbs id idnode :: suffix ” &&
    &(manager # "IdManager" ->ₛ "id_max") # UShort |-> sm.(idmax) **
    &(manager # "IdManager" ->ₛ "hoffset") # UShort |-> sm.(hoffset) **
    &(manager # "IdManager" ->ₛ "id_map") # Ptr |-> sm.(id_map) **
    store_uchar_array sm.(id_map) ((sm.(idmax) + 7) / 8) bytes **
    &(manager # "IdManager" ->ₛ "htable") # Ptr |-> sm.(htable) **
    store_idbuckets_except
      sm.(htable) (id mod sm.(hoffset)) bucket m.(idbuckets) **
    store_idnodes
      (sm.(htable) + (id mod sm.(hoffset)) * sizeof("SysDoubleLinklistNode"))
      bucket.

Definition store_idmanager_allocated_unlinked
  (sm: StableIdmanager) (m: VarIdmanager) (p: addr) (id: Z): Assertion :=
  “ idmanager_min_free_id sm m id ” &&
  &(p # "IdManager" ->ₛ "id_max") # UShort |-> sm.(idmax) **
  &(p # "IdManager" ->ₛ "hoffset") # UShort |-> sm.(hoffset) **
  &(p # "IdManager" ->ₛ "id_map") # Ptr |-> sm.(id_map) **
  store_id_map sm.(id_map) sm.(idmax) (idlist_add id m.(idlist)) **
  &(p # "IdManager" ->ₛ "htable") # Ptr |-> sm.(htable) **
  (“ idbuckets_ok sm.(idmax) sm.(hoffset) m.(idlist) m.(idbuckets) ” &&
   store_idbuckets sm.(htable) sm.(hoffset) m.(idbuckets)).

Definition store_idmanager_freeid_post
  (sm: StableIdmanager) (m: VarIdmanager) (p: addr) (id: Z): Assertion :=
  &(p # "IdManager" ->ₛ "id_max") # UShort |-> sm.(idmax) **
  &(p # "IdManager" ->ₛ "hoffset") # UShort |-> sm.(hoffset) **
  &(p # "IdManager" ->ₛ "id_map") # Ptr |-> sm.(id_map) **
  store_id_map sm.(id_map) sm.(idmax) (remove Z.eq_dec id m.(idlist)) **
  &(p # "IdManager" ->ₛ "htable") # Ptr |-> sm.(htable) **
  (“ idbuckets_ok sm.(idmax) sm.(hoffset) m.(idlist) m.(idbuckets) ” &&
   store_idbuckets sm.(htable) sm.(hoffset) m.(idbuckets)).

Definition store_idmanager_remove_ready
  (sm: StableIdmanager) (m: VarIdmanager)
  (manager idnode: addr) (id: Z): Assertion :=
  EX bytes: list Z,
  EX prefix suffix bucket: list IdNodeAbs,
    “ 0 <= id < sm.(idmax) /\
      id_map_bytes_ok sm.(idmax) (idlist_remove id m.(idlist)) bytes /\
      idbuckets_ok sm.(idmax) sm.(hoffset) m.(idlist) m.(idbuckets) /\
      idbuckets_ok sm.(idmax) sm.(hoffset) (idlist_remove id m.(idlist))
        (idmanager_remove_bucket sm.(hoffset) id m.(idbuckets)) /\
      bucket = Znth (id mod sm.(hoffset)) m.(idbuckets) nil /\
      bucket = prefix ++ Build_IdNodeAbs id idnode :: suffix /\
      idnodes_remove_id id bucket = prefix ++ suffix ” &&
    &(manager # "IdManager" ->ₛ "id_max") # UShort |-> sm.(idmax) **
    &(manager # "IdManager" ->ₛ "hoffset") # UShort |-> sm.(hoffset) **
    &(manager # "IdManager" ->ₛ "id_map") # Ptr |-> sm.(id_map) **
    store_uchar_array sm.(id_map) ((sm.(idmax) + 7) / 8) bytes **
    &(manager # "IdManager" ->ₛ "htable") # Ptr |-> sm.(htable) **
    store_idbuckets_except
      sm.(htable) (id mod sm.(hoffset)) bucket m.(idbuckets) **
    store_idnodes
      (sm.(htable) + (id mod sm.(hoffset)) * sizeof("SysDoubleLinklistNode"))
      bucket.

Definition store_idmanager_removeobj_post
  (sm: StableIdmanager) (m: VarIdmanager)
  (manager idnode: addr) (id: Z): Assertion :=
  store_idmanager sm (idmanager_remove sm m id) manager **
  store_idnode &(idnode # "IdNode" ->ₛ "link") (Build_IdNodeAbs id idnode) **
  &(idnode # "IdNode" ->ₛ "link" .ₛ "node_prev") # Ptr
    |-> &(idnode # "IdNode" ->ₛ "link") **
  &(idnode # "IdNode" ->ₛ "link" .ₛ "node_next") # Ptr
    |-> &(idnode # "IdNode" ->ₛ "link").

Lemma Znth_In_Zlength:
  forall {A: Type} (l: list A) (d: A) (i: Z),
    0 <= i < Zlength l ->
    In (Znth i l d) l.
Proof.
  intros A l d i Hrange.
  unfold Znth.
  apply nth_In.
  apply Nat2Z.inj_lt.
  rewrite Z2Nat.id by lia.
  rewrite <- Zlength_correct.
  lia.
Qed.

Lemma idbuckets_index_ok_Znth:
  forall hoffset start buckets index,
    0 <= index < Zlength buckets ->
    idbuckets_index_ok hoffset start buckets ->
    Forall (fun node => node.(idnode_id) mod hoffset = start + index)
      (Znth index buckets nil).
Proof.
  intros hoffset start buckets; revert start.
  induction buckets as [| b bs IH]; intros start index Hrange Hidx; simpl in *.
  - rewrite Zlength_nil in Hrange; lia.
  - destruct (Z.eq_dec index 0) as [H0 | Hn0].
    + subst index. destruct Hidx as [Hhead _].
      replace (start + 0) with start by lia. exact Hhead.
    + destruct Hidx as [_ Htail].
      rewrite Znth_cons by lia.
      replace (start + index) with (start + 1 + (index - 1)) by lia.
      apply IH; [rewrite Zlength_cons in Hrange; lia | exact Htail].
Qed.

Lemma store_idbucket_list_app:
  forall (htable start: Z) (l1 l2: list (list IdNodeAbs)),
    store_idbucket_list htable start l1 **
    store_idbucket_list htable (start + Zlength l1) l2 |--
    store_idbucket_list htable start (l1 ++ l2).
Proof.
  intros htable start l1; revert start.
  induction l1 as [| b bs IH]; intros start l2; simpl.
  - rewrite Zlength_nil.
    replace (start + 0) with start by lia.
    entailer!.
  - rewrite Zlength_cons.
    replace (start + Z.succ (Zlength bs)) with (start + 1 + Zlength bs) by lia.
    sep_apply (IH (start + 1) l2).
    entailer!.
Qed.

Lemma store_idbucket_list_bucket_dll:
  forall (htable start: Z) (bucket: list IdNodeAbs)
         (buckets: list (list IdNodeAbs)),
    store_idbucket_list htable (start + 1) buckets **
    store_idnodes
      (htable + start * sizeof("SysDoubleLinklistNode")) bucket |--
    store_idbucket_list htable start (bucket :: buckets).
Proof.
  intros htable start bucket buckets.
  simpl.
  unfold store_idbucket.
  destruct bucket.
  - Left. entailer!.
  - entailer!.
Qed.

Lemma store_idbucket_cases:
  forall (head: addr) (bucket: list IdNodeAbs),
    store_idbucket head bucket |--
    (“ bucket = nil ” &&
     &(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> 0 **
     &(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> 0) ||
    (EX prev next: addr,
      “ head <> 0 /\ prev <> 0 /\ next <> 0 /\ idnodes_nonzero bucket ” &&
      &(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> prev **
      &(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next **
      idnodes_dllseg next head head prev bucket).
Proof.
  intros head bucket.
  destruct bucket as [| x xs].
  - cbn [store_idbucket].
    apply derivable1_orp_elim.
    + unfold store_idnodes.
      sep_apply (@store_dll_nonzero IdNodeAbs).
      Intros h pt.
      Right.
      Exists pt h.
      unfold idnodes_nonzero, idnodes_dllseg.
      entailer!.
    + Left.
      unfold store_uninit_idbucket.
      entailer!.
  - cbn [store_idbucket].
    unfold store_idnodes.
    sep_apply (@store_dll_nonzero IdNodeAbs).
    Intros h pt.
    Right.
    Exists pt h.
    unfold idnodes_nonzero, idnodes_dllseg.
    entailer!.
Qed.

Lemma store_idbucket_list_split:
  forall (htable start index: Z) (buckets: list (list IdNodeAbs)),
    0 <= index < Zlength buckets ->
    store_idbucket_list htable start buckets |--
    EX bucket: list IdNodeAbs, EX prefix suffix: list (list IdNodeAbs),
      “ bucket = Znth index buckets nil /\
        buckets = prefix ++ bucket :: suffix /\
        Zlength prefix = index ” &&
      store_idbucket
        (htable + (start + index) * sizeof("SysDoubleLinklistNode")) bucket **
      store_idbucket_list htable start prefix **
      store_idbucket_list htable (start + index + 1) suffix.
Proof.
  intros htable start index buckets Hrange.
  revert start index Hrange.
  induction buckets as [| b bs IH]; intros start index Hrange.
  - unfold derivable1. intros m Hm.
    rewrite Zlength_nil in Hrange. lia.
  - destruct (Z.eq_dec index 0) as [Hidx | Hidx].
    + subst index. simpl.
      Exists b (@nil (list IdNodeAbs)) bs.
      replace (start + 0) with start by lia.
      replace (start + 0 + 1) with (start + 1) by lia.
      entailer!.
    + assert (0 <= index - 1 < Zlength bs) as Htail
        by (rewrite Zlength_cons in Hrange; lia).
      specialize (IH (start + 1) (index - 1) Htail).
      simpl. sep_apply IH. Intros bucket prefix suffix.
      Exists bucket (b :: prefix) suffix.
      simpl.
      replace (Zlength prefix + 1) with (1 + Zlength prefix) by lia.
      replace (start + index) with (start + 1 + (index - 1)) by lia.
      replace (start + index + 1) with (start + 1 + (index - 1) + 1) by lia.
      entailer!.
      all: destruct H as [Hz [Happ Hlen]].
      all: try (rewrite Znth_cons by lia; exact Hz).
      all: try (rewrite Happ; reflexivity).
      all: try (rewrite Zlength_cons; lia).
Qed.

Lemma store_idbuckets_split:
  forall (htable hoffset index: Z) (buckets: list (list IdNodeAbs)),
    0 <= index < Zlength buckets ->
    store_idbuckets htable hoffset buckets |--
    EX bucket: list IdNodeAbs,
      “ bucket = Znth index buckets nil ” &&
      store_idbucket
        (htable + index * sizeof("SysDoubleLinklistNode")) bucket **
      store_idbuckets_except htable index bucket buckets.
Proof.
  intros htable hoffset index buckets Hrange.
  unfold store_idbuckets.
  sep_apply (store_idbucket_list_split htable 0 index buckets Hrange).
  Intros bucket prefix suffix.
  Exists bucket.
  unfold store_idbuckets_except.
  Exists prefix suffix.
  replace (0 + index) with index by lia.
  replace (0 + index + 1) with (index + 1) by lia.
  entailer!.
Qed.

Lemma store_idbuckets_replace:
  forall (htable hoffset index: Z)
         (bucket new_bucket: list IdNodeAbs)
         (buckets: list (list IdNodeAbs)),
    0 <= index ->
    bucket = Znth index buckets nil ->
    store_idbuckets_except htable index bucket buckets **
    store_idnodes
      (htable + index * sizeof("SysDoubleLinklistNode")) new_bucket |--
    store_idbuckets htable hoffset
      (replace_Znth index new_bucket buckets).
Proof.
  intros htable hoffset index bucket new_bucket buckets Hindex Hbucket.
  unfold store_idbuckets_except, store_idbuckets.
  Intros prefix suffix.
  destruct H as [Hbuckets Hprefix].
  rewrite Hbuckets.
  rewrite replace_Znth_app_r by lia.
  rewrite replace_Znth_nothing by lia.
  replace (index - Zlength prefix) with 0 by lia.
  simpl.
  sep_apply (store_idbucket_list_bucket_dll htable index
    new_bucket suffix).
  replace index with (0 + Zlength prefix) by lia.
  sep_apply (store_idbucket_list_app htable 0 prefix
    (new_bucket :: suffix)).
  entailer!.
Qed.

Lemma store_idmanager_found_store_idmanager:
  forall (sm: StableIdmanager) (m: VarIdmanager)
         (manager idnode id: addr),
    store_idmanager_found sm m manager idnode id |--
    store_idmanager sm m manager.
Proof.
  intros sm m manager idnode id.
  unfold store_idmanager_found, store_idmanager,
    store_id_map, store_uchar_array.
  Intros bytes prefix suffix bucket.
  destruct H as [Hrange [Hmap [Hbuckets [Hbucket Hsplit]]]].
  assert (Hindex: 0 <= id mod sm.(hoffset)).
  {
    unfold idbuckets_ok in Hbuckets.
    apply Z.mod_pos_bound.
    lia.
  }
  Exists bytes.
  entailer!.
  sep_apply (store_idbuckets_replace sm.(htable) sm.(hoffset)
    (id mod sm.(hoffset)) bucket bucket m.(idbuckets)
    Hindex Hbucket).
  rewrite Hbucket.
  rewrite replace_Znth_Znth.
  entailer!.
Qed.

End IDNode.
