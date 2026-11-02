Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From Coq Require Import micromega.Psatz.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.CrtosRules CRTOS_Verify.lib.idnode CRTOS_Verify.lib.dll.
Require Export CRTOS_Verify.lib.SemaphoreState CRTOS_Verify.lib.NodeSelfLinked.
Import ListNotations DLL IDNode.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

(** 当前32位信号量对象的字段布局，按 LiteOS lib/memory.v 的组织方式，
    与使用这些布局的内存谓词放在同一文件。这里只描述字段地址，不提供
    内存所有权、分配来源或字段值。两个padding区间为[2,4)和[14,16)。 *)
Definition semaphore_byte_layout (p : addr) : Prop :=
  &(p # "Semaphore" ->ₛ "id") = p /\
  &(p # "IdNode" ->ₛ "id") = p /\
  &(p # "IdNode" ->ₛ "link") = p + 4 /\
  &(p # "Semaphore" ->ₛ "value") = p + 12 /\
  &(p # "Semaphore" ->ₛ "pend_list") = p + 16 /\
  &(p # "Semaphore" ->ₛ "link") = p + 24 /\
  forall off : Z, In off [4; 16; 24] ->
    let node := p + off in
    &(node # "SysDoubleLinklistNode" ->ₛ "node_next") = node /\
    &(node # "SysDoubleLinklistNode" ->ₛ "node_prev") = node + 4.

(** 显式ABI信任入口：用户于2026-10-22选择按LiteOS方式列出经核对的布局前提。
    ksemaphorecreate-trial-261022-1/checks/abi-current.json记录真实/切片头文件的
    GCC ILP32检查，并非ARM交叉编译
    或Rocq布局证明。没有增加sizeof公理；C切片使用已检查的常量32。
    字节到字段的资源转换见本文件后部已证明的条件引理。 *)
Axiom semaphore_field_offsets_trusted :
  forall p, addr_aligned p 4 -> semaphore_byte_layout p.

(** NodeStorage 拥有两个未知指针槽，供 InitDoubleLinkList 覆写。 *)
Definition NodeStorage (p : addr) : Assertion :=
  “ p <> 0 ” &&
  &(p # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |->_ **
  &(p # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |->_.
Definition NodeZero (p : addr) : Assertion :=
  &(p # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> 0 **
  &(p # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> 0.
(** 底层插入切口：head.next与next.prev是不同字段，即使head=next也不重叠。
    未触达的head.prev与next.next留在调用者frame；新节点两槽必须完整。 *)
Definition DllInsertAfterCut (head next node oldprev oldnext : addr) : Assertion :=
  “ head <> 0 /\ next <> 0 /\ node <> 0 ” &&
  &(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next **
  &(next # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> head **
  &(node # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> oldprev **
  &(node # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> oldnext.
Definition DllInsertedCut (head next node : addr) : Assertion :=
  &(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> node **
  &(next # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> node **
  &(node # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> head **
  &(node # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next.
(** 私有 ID 子对象，仅十个具名字段字节；padding由SemaphorePadding持有。 *)
Definition ZeroIdNode (p : addr) : Assertion :=
  “ p <> 0 /\ &(p # "IdNode" ->ₛ "link") <> 0 ” &&
  &(p # "IdNode" ->ₛ "id") # UShort |-> 0 **
  NodeZero (&(p # "IdNode" ->ₛ "link")).
Definition AssignedIdNode (p id : Z) : Assertion :=
  “ p <> 0 /\ &(p # "IdNode" ->ₛ "link") <> 0 ” &&
  &(p # "IdNode" ->ₛ "id") # UShort |-> id **
  NodeZero (&(p # "IdNode" ->ₛ "link")).
(** 当前QCP struct_padding=emp，因此显式拥有ABI的[2,4)和[14,16)。 *)
Definition SemaphorePadding (p : addr) : Assertion :=
  CharArray.full (p+2) 2 (repeat_Z 0 2) **
  CharArray.full (p+14) 2 (repeat_Z 0 2).
(** 完整私有32字节对象的typed未知字段与padding所有权，可用于回收。
    x_malloc的VRTOS规约只交出字节数组；数组到本表示的转换须另行证明。
    本谓词不记录分配来源；x_free调用者仍须使用本次malloc返回的原基址。 *)
Definition SemaphoreRaw (p : addr) : Assertion :=
  “ p <> 0 /\ addr_aligned p 4 ” &&
  &(p # "Semaphore" ->ₛ "id" .ₛ "id") # UShort |->_ **
  NodeStorage (&(p # "Semaphore" ->ₛ "id" .ₛ "link")) **
  &(p # "Semaphore" ->ₛ "value") # UShort |->_ **
  NodeStorage (&(p # "Semaphore" ->ₛ "pend_list")) **
  NodeStorage (&(p # "Semaphore" ->ₛ "link")) **
  CharArray.undef_full (p+2) 2 ** CharArray.undef_full (p+14) 2.
(** memset零化且尚未发布的整个对象。VRTOS的ID失败后置会忘记ID节点值，
    因而失败后不能声称仍满足本谓词；回收使用完整未知值所有权SemaphoreRaw。 *)
Definition SemaphoreZero (p : addr) : Assertion :=
  “ p <> 0 /\ addr_aligned p 4 ” &&
  ZeroIdNode (&(p # "Semaphore" ->ₛ "id")) **
  &(p # "Semaphore" ->ₛ "value") # UShort |-> 0 **
  NodeZero (&(p # "Semaphore" ->ₛ "pend_list")) **
  NodeZero (&(p # "Semaphore" ->ₛ "link")) **
  SemaphorePadding p.
(** 等待链使用任务内嵌 task_dync_sched_member.sched_link；
    与 task/source-view/ready 三处复用同一地址函数，不假定不存在的直接字段别名。 *)
Definition semaphore_wait_node (task : addr) : DL_Node addr :=
  Build_DL_Node task (sched_link_of task).
Definition semaphore_link_node (s : SemaphoreAbs) : DL_Node SemaphoreAbs :=
  let p := s.(semaphore_addr) in
  Build_DL_Node s (&(p # "Semaphore" ->ₛ "link")).
(** 发布后ID字段/ID link归manager、管理link归全局DLL；payload仅持有
    value、padding、pend_list及其中等待节点，等待任务字段由task_inv持有。 *)
Definition store_semaphore (wait : addr -> addr -> Assertion)
    (link : addr) (s : SemaphoreAbs) : Assertion :=
  let p := s.(semaphore_addr) in
  “ p <> 0 /\ addr_aligned p 4 /\ link = &(p # "Semaphore" ->ₛ "link") ” &&
  &(p # "Semaphore" ->ₛ "value") # UShort |-> s.(semaphore_value) **
  SemaphorePadding p **
  store_dll wait (&(p # "Semaphore" ->ₛ "pend_list"))
    (map semaphore_wait_node s.(semaphore_pending_addrs)).
(** 全模块共享内存：manager含bitmap/懒初始化桶/ID nodes；管理DLL含对象本体。
    done表已根据不可变dispatch等价归一为直接调用，无运行时table ownership。 *)
Definition semaphore_inv (wait : addr -> addr -> Assertion)
    (sg : SemaphoreStable) (st : SemaphoreState) : Assertion :=
  “ semaphore_context sg ” &&
  store_idmanager sg.(semaphore_manager_stable) (semaphore_manager st)
    sg.(semaphore_manager_ptr) **
  store_dll (store_semaphore wait) sg.(semaphore_list_head)
    (map semaphore_link_node st).

(** 编译时零初始化的私有全局内存，交接给协议前仍由启动代码持有。
    无新token；初始化义务是由此建立 semaphore_inv wait sg nil。 *)
Definition semaphore_initial_memory (sg : SemaphoreStable) : Assertion :=
  let sidm := sg.(semaphore_manager_stable) in
  let manager := sg.(semaphore_manager_ptr) in
  “ semaphore_context sg ” &&
  &(manager # "IdManager" ->ₛ "id_max") # UShort |-> 128 **
  &(manager # "IdManager" ->ₛ "hoffset") # UShort |-> 16 **
  &(manager # "IdManager" ->ₛ "id_map") # Ptr |-> sidm.(id_map) **
  &(manager # "IdManager" ->ₛ "htable") # Ptr |-> sidm.(htable) **
  UCharArray.full sidm.(id_map) 16 (repeat_Z 0 16) **
  PtrArray.full sidm.(htable) 32 (repeat_Z 0 32) **
  store_node_self_linked sg.(semaphore_list_head).

(** DLL调用处的实际首节点：空链返回哨兵，不假设next与head不同。 *)
Definition semaphore_first_link (sg : SemaphoreStable) (st : SemaphoreState) : addr :=
  match st with
  | nil => sg.(semaphore_list_head)
  | s :: _ => (semaphore_link_node s).(getPtr)
  end.
(** 懒桶经过Init之后，空桶首节点同样是自身哨兵；非空使用已有ID链接地址。 *)
Definition idbucket_first_link (sidm : StableIdmanager) (idm : VarIdmanager)
    (id : Z) : addr :=
  match Znth (id mod sidm.(hoffset)) idm.(idbuckets) nil with
  | nil => sidm.(htable) + (id mod sidm.(hoffset)) * sizeof("SysDoubleLinklistNode")
  | n :: _ => idnode_link n
  end.

(** 私有信号量对象的资源拆分与失败回收。 *)
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

(** 零字节到字段资源的转换。布局作为显式前提传入，
    以下证明不使用 semaphore_field_offsets_trusted。 *)
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
