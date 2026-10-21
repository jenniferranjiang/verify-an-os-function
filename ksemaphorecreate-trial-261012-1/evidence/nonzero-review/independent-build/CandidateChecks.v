From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String Coq.micromega.Lia.
Require Import CRTOS_Verify.lib.idnode CRTOS_Verify.sem.SemaphoreRep.
Import CRTOS_Verify.lib.CrtosRules.Task_C_Rules IDNode.
Local Open Scope Z_scope.
Local Open Scope string_scope.
Local Open Scope sac.

(** 只检查条件式 ABI 桥：所有等式均显式作为前提，绝不把 C probe 当作
    eval_addr_expr 的内核定理。此引理本身不能消除来源义务。 *)
Lemma source_layout_implies_object_addresses : forall p,
  0 < p ->
  &(p # "Semaphore" ->ₛ "id") = p ->
  (let idp : addr := &(p # "Semaphore" ->ₛ "id") in
    &(idp # "IdNode" ->ₛ "link")) = p + 4 ->
  &(p # "Semaphore" ->ₛ "pend_list") = p + 16 ->
  &(p # "Semaphore" ->ₛ "link") = p + 24 ->
  semaphore_object_addresses p.
Proof. unfold semaphore_object_addresses; intros; repeat split; lia. Qed.

(** 这条引理展示 BSS 桶来源需要的具体条件；sizeof=8 仍是未接入的 ABI 事实。 *)
Lemma source_array_layout_implies_bucket_nonzero : forall base index,
  0 < base -> 0 <= index -> sizeof("SysDoubleLinklistNode") = 8 ->
  base + index * sizeof("SysDoubleLinklistNode") <> 0.
Proof. intros; nia. Qed.

(** 分配候选仍交出全部32字节，不可用纯地址事实替换 byte ownership。 *)
Lemma allocated_full_bytes : forall p,
  store_sem_allocated p |--
  “ p <> 0 ” && CharArray.undef_full p 32.
Proof. intros; unfold store_sem_allocated, semaphore_object_addresses; entailer!. Qed.

(** 分配起点已经携带同一组metadata，零化不负责制造这些地址事实。 *)
Lemma allocated_object_addresses : forall p,
  store_sem_allocated p |-- “ semaphore_object_addresses p ”.
Proof. intros; unfold store_sem_allocated; entailer!. Qed.

(** ID交给manager后，余部继续保留pending/registry及本体地址事实。 *)
Lemma registered_private_addresses : forall p,
  store_sem_registered_private p |-- “ semaphore_object_addresses p ”.
Proof. intros; unfold store_sem_registered_private; entailer!. Qed.

(** 零化后全部字段及两段padding保持；这个检查仅导出已有metadata。 *)
Lemma zeroed_object_addresses : forall p,
  store_sem_zeroed_private p |-- “ semaphore_object_addresses p ”.
Proof. intros; unfold store_sem_zeroed_private; entailer!. Qed.

Lemma detached_id_addresses : forall p id prev next,
  store_sem_id_detached p id prev next |--
  “ p <> 0 /\ &(p # "IdNode" ->ₛ "link") <> 0 ”.
Proof. intros; unfold store_sem_id_detached; entailer!. Qed.

Lemma detached_link_address : forall p prev next,
  store_sem_link_detached p prev next |-- “ p <> 0 ”.
Proof. intros; unfold store_sem_link_detached; entailer!. Qed.

Lemma bss_bucket_address : forall head,
  store_uninit_idbucket head |-- “ head <> 0 ”.
Proof. intros; unfold store_uninit_idbucket; entailer!. Qed.

(** 私有对象拆为ID节点和不含ID字段的余部；纯metadata保持，不复制字节。 *)
Lemma zeroed_split_id : forall p,
  let idp : addr := &(p # "Semaphore" ->ₛ "id") in
  store_sem_zeroed_private p |--
    store_sem_id_detached idp 0 0 0 ** store_sem_registered_private p.
Proof.
  intros; cbn zeta; unfold store_sem_zeroed_private, store_sem_registered_private.
  entailer!.
Qed.

(** ID失败返还三个零字段后，恢复trusted free所消费的完整私有对象。 *)
Lemma zeroed_failure_rejoin : forall p,
  let idp : addr := &(p # "Semaphore" ->ₛ "id") in
  store_sem_id_detached idp 0 0 0 ** store_sem_registered_private p |--
    store_sem_zeroed_private p.
Proof.
  intros; cbn zeta; unfold store_sem_zeroed_private, store_sem_registered_private.
  entailer!.
Qed.

(** 以下负向检查只表明框架不按所需 ABI 做定义计算，不能声称不可证明。 *)
Fail Definition id_link_offset_by_reduction : forall p,
  &(p # "IdNode" ->ₛ "link") = p + 4 := fun p => eq_refl.
Fail Definition bucket_size_by_reduction : sizeof("SysDoubleLinklistNode") = 8 := eq_refl.

Print Assumptions source_layout_implies_object_addresses.
Print Assumptions source_array_layout_implies_bucket_nonzero.
Print Assumptions allocated_full_bytes.
Print Assumptions zeroed_object_addresses.
Print Assumptions detached_id_addresses.
Print Assumptions detached_link_address.
Print Assumptions bss_bucket_address.

Print Assumptions zeroed_split_id.
Print Assumptions zeroed_failure_rejoin.

Print Assumptions allocated_object_addresses.
Print Assumptions registered_private_addresses.
