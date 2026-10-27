From Coq Require Import ZArith List Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import CRTOS_Verify.lib.SemaphoreInv.
Import ListNotations IDNode DLL.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

(** Forget the zero values of the private embedded ID node before calling the
    existing IdInsertObj API.  Its two nonzero facts already occur in ZeroIdNode;
    this conversion does not assume numeric struct offsets. *)
Lemma zero_idnode_insert_ready : forall p,
  ZeroIdNode p |-- store_idnode_insert_ready p.
Proof.
  intros p. unfold ZeroIdNode, NodeZero, store_idnode_insert_ready.
  Intros_p Hnonzero.
  sep_apply_l_atomic (store_ushort_undef_store_ushort
    (&(p # "IdNode" ->ₛ "id")) 0).
  let q := constr:(&(p # "IdNode" ->ₛ "link")) in
  sep_apply_l_atomic (store_ptr_undef_store_ptr (&(q # "SysDoubleLinklistNode" ->ₛ "node_prev")) 0).
  let q := constr:(&(p # "IdNode" ->ₛ "link")) in
  sep_apply_l_atomic (store_ptr_undef_store_ptr (&(q # "SysDoubleLinklistNode" ->ₛ "node_next")) 0).
  csimpl.
  split_pure_spatial; [cancel | dump_pre_spatial; exact Hnonzero].
Qed.

(** Only the embedded ID ownership is transferred to IdInsertObj; the object's
    value, two other links, padding, base validity and alignment are framed. *)
Lemma semaphore_zero_insert_ready : forall p,
  SemaphoreZero p |--
  “ p <> 0 /\ addr_aligned p 4 ” &&
  store_idnode_insert_ready (&(p # "Semaphore" ->ₛ "id")) **
  &(p # "Semaphore" ->ₛ "value") # UShort |-> 0 **
  NodeZero (&(p # "Semaphore" ->ₛ "pend_list")) **
  NodeZero (&(p # "Semaphore" ->ₛ "link")) ** SemaphorePadding p.
Proof.
  intros p. unfold SemaphoreZero. Intros_p Hbase.
  sep_apply_l_atomic (zero_idnode_insert_ready (&(p # "Semaphore" ->ₛ "id"))).
  split_pure_spatial; [cancel | dump_pre_spatial; exact Hbase].
Qed.

(** Expose the embedded ID object's unknown fields in the enclosing Semaphore
    notation. Only compositional field-address rules are needed. *)
Lemma semaphore_id_ready_fields : forall p,
  store_idnode_insert_ready (&(p # "Semaphore" ->ₛ "id")) |--
  &(p # "Semaphore" ->ₛ "id" .ₛ "id") # UShort |->_ **
  NodeStorage (&(p # "Semaphore" ->ₛ "id" .ₛ "link")).
Proof.
  intros p. unfold store_idnode_insert_ready, NodeStorage.
  Intros_p Hid. csimpl.
  split_pure_spatial; [repeat progress cancel | dump_pre_spatial; destruct Hid as [_ H]; revert H; csimpl; auto].
Qed.

(** The ID failure contract returns unknown-owned ID fields.  Together with the
    unchanged zero payload and padding they recover the full allocation for
    x_free. Pending/list-link nonzero facts must be retained from the checked
    malloc/zero-byte layout conversion: NodeZero alone does not establish them. *)
Lemma semaphore_insert_failure_raw : forall p,
  p <> 0 -> addr_aligned p 4 ->
  &(p # "Semaphore" ->ₛ "pend_list") <> 0 ->
  &(p # "Semaphore" ->ₛ "link") <> 0 ->
  store_idnode_insert_ready (&(p # "Semaphore" ->ₛ "id")) **
  &(p # "Semaphore" ->ₛ "value") # UShort |-> 0 **
  NodeZero (&(p # "Semaphore" ->ₛ "pend_list")) **
  NodeZero (&(p # "Semaphore" ->ₛ "link")) ** SemaphorePadding p
  |-- SemaphoreRaw p.
Proof.
  intros p Hp Halign Hpend Hlink.
  sep_apply_l_atomic (semaphore_id_ready_fields p).
  unfold NodeZero, SemaphorePadding, SemaphoreRaw, NodeStorage.
  Intros_p Hid.
  sep_apply_l_atomic (store_ushort_undef_store_ushort
    (&(p # "Semaphore" ->ₛ "value")) 0).
  let q := constr:(&(p # "Semaphore" ->ₛ "pend_list")) in
  sep_apply_l_atomic (store_ptr_undef_store_ptr (&(q # "SysDoubleLinklistNode" ->ₛ "node_prev")) 0).
  let q := constr:(&(p # "Semaphore" ->ₛ "pend_list")) in
  sep_apply_l_atomic (store_ptr_undef_store_ptr (&(q # "SysDoubleLinklistNode" ->ₛ "node_next")) 0).
  let q := constr:(&(p # "Semaphore" ->ₛ "link")) in
  sep_apply_l_atomic (store_ptr_undef_store_ptr (&(q # "SysDoubleLinklistNode" ->ₛ "node_prev")) 0).
  let q := constr:(&(p # "Semaphore" ->ₛ "link")) in
  sep_apply_l_atomic (store_ptr_undef_store_ptr (&(q # "SysDoubleLinklistNode" ->ₛ "node_next")) 0).
  sep_apply_l_atomic (CharArray.full_to_undef_full (p+2) 2 (repeat_Z 0 2)).
  sep_apply_l_atomic (CharArray.full_to_undef_full (p+14) 2 (repeat_Z 0 2)).
  split_pure_spatial; [repeat progress cancel | split_pures; dump_pre_spatial; intuition].
Qed.
