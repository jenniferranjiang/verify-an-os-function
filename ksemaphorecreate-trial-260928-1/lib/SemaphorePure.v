Require Import Coq.ZArith.ZArith.
Require Import Lia.
Require Import Coq.Lists.List.
Require Import Coq.Sorting.Permutation.
Require Import Coq.Relations.Relation_Operators.
Require Import Coq.Strings.String.
Require Import SetsClass.SetsClass.
From SimpleC.SL Require Import Mem CNotation.
From MonadLib.StateRelMonad Require Import StateRelBasic safeexec_lib.

Import ListNotations SetsNotation Monad MonadNotation.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sets.
Local Open Scope monad.

(** 当前批准的 stm32f103-nano 配置常量：128 个 ID、16 个桶。 *)
Definition SEM_ID_MAX : Z := 128.
Definition SEM_BUCKET_COUNT : Z := 16.
Definition SEM_OBJECT_SIZE : Z := 32.
Definition SEM_NO_MEMORY : Z := -5.

(**
  [SemaphoreStable] 只保存 semaphore 模块静态对象的地址和固定容量：
  [k_sem_id_manager]、其 BSS bitmap/bucket 数组以及 [k_sem_list]。
  静态 [done] 表不在此处；验证切片依据同 TU 唯一 initializer 把 dispatch
  解析为直接调用，QCP 不表示函数指针。
*)
Record SemaphoreStable : Type := Build_SemaphoreStable {
  semaphore_manager_addr : addr;
  semaphore_bitmap_addr : addr;
  semaphore_buckets_addr : addr;
  semaphore_registry_addr : addr;
  semaphore_id_limit : Z;
  semaphore_bucket_count : Z
}.

(**
  一个已发布 semaphore 以分配地址作为生命周期身份；ID 仅在注册期间有效。
  [semaphore_pending_addrs] 按 [pend_list] 顺序保存等待任务基址，不复制任务状态。
*)
Record SemaphoreObject : Type := Build_SemaphoreObject {
  semaphore_addr : addr;
  semaphore_id : Z;
  semaphore_value : Z;
  semaphore_pending_addrs : list addr
}.

(** 模块可变抽象状态只有 [k_sem_list] 顺序中的已发布对象。 *)
Record SemaphoreState : Type := Build_SemaphoreState {
  semaphore_objects : list SemaphoreObject
}.
(** 链接器 BSS 初态中尚无已发布 semaphore。 *)
Definition semaphore_initial_state : SemaphoreState :=
  Build_SemaphoreState nil.


Definition semaphore_addresses (objects : list SemaphoreObject) : list addr :=
  map semaphore_addr objects.
Definition semaphore_ids (objects : list SemaphoreObject) : list Z :=
  map semaphore_id objects.
Definition semaphore_all_pending (objects : list SemaphoreObject) : list addr :=
  List.concat (map semaphore_pending_addrs objects).

Fixpoint semaphore_find_id (id : Z) (objects : list SemaphoreObject)
    : option SemaphoreObject :=
  match objects with
  | nil => None
  | object :: rest =>
      if Z.eq_dec object.(semaphore_id) id then Some object
      else semaphore_find_id id rest
  end.

Fixpoint semaphore_find_addr (p : addr) (objects : list SemaphoreObject)
    : option SemaphoreObject :=
  match objects with
  | nil => None
  | object :: rest =>
      if Z.eq_dec object.(semaphore_addr) p then Some object
      else semaphore_find_addr p rest
  end.

Fixpoint semaphore_replace_addr
    (p : addr) (replacement : SemaphoreObject) (objects : list SemaphoreObject)
    : list SemaphoreObject :=
  match objects with
  | nil => nil
  | object :: rest =>
      if Z.eq_dec object.(semaphore_addr) p
      then replacement :: rest
      else object :: semaphore_replace_addr p replacement rest
  end.

Fixpoint semaphore_remove_addr (p : addr) (objects : list SemaphoreObject)
    : list SemaphoreObject :=
  match objects with
  | nil => nil
  | object :: rest =>
      if Z.eq_dec object.(semaphore_addr) p
      then rest else object :: semaphore_remove_addr p rest
  end.

Definition semaphore_with_value (object : SemaphoreObject) (value : Z)
    : SemaphoreObject :=
  Build_SemaphoreObject object.(semaphore_addr) object.(semaphore_id)
    value object.(semaphore_pending_addrs).

Definition semaphore_with_pending (object : SemaphoreObject) (pending : list addr)
    : SemaphoreObject :=
  Build_SemaphoreObject object.(semaphore_addr) object.(semaphore_id)
    object.(semaphore_value) pending.

Definition semaphore_replace_object (before : SemaphoreState)
    (object : SemaphoreObject) : SemaphoreState :=
  Build_SemaphoreState
    (semaphore_replace_addr object.(semaphore_addr) object
      before.(semaphore_objects)).

(** create 发布时同时加入 ID manager 与 [k_sem_list]；表头插入对应列表头。 *)
Definition semaphore_create_state (before : SemaphoreState)
    (p : addr) (id value : Z) : SemaphoreState :=
  Build_SemaphoreState
    (Build_SemaphoreObject p id value nil :: before.(semaphore_objects)).

(** ID 已进入 bitmap/bucket、但对象尚未进入 [k_sem_list] 的创建中间态。 *)
Definition semaphore_reserve_state (before : SemaphoreState)
    (p : addr) (id : Z) : SemaphoreState :=
  semaphore_create_state before p id 0.

Definition semaphore_delete_state (before : SemaphoreState)
    (object : SemaphoreObject) : SemaphoreState :=
  Build_SemaphoreState
    (semaphore_remove_addr object.(semaphore_addr) before.(semaphore_objects)).

Definition semaphore_id_used (state : SemaphoreState) (id : Z) : bool :=
  if in_dec Z.eq_dec id (semaphore_ids state.(semaphore_objects))
  then true else false.

Fixpoint semaphore_first_free_from (state : SemaphoreState)
    (fuel : nat) (id : Z) : option Z :=
  match fuel with
  | O => None
  | S fuel' =>
      if semaphore_id_used state id
      then semaphore_first_free_from state fuel' (id + 1)
      else Some id
  end.

Definition semaphore_first_free (stable : SemaphoreStable)
    (state : SemaphoreState) : option Z :=
  semaphore_first_free_from state (Z.to_nat stable.(semaphore_id_limit)) 0.

(** [AllocId] 外层循环已确认前 [index] 个 bitmap byte 全满。 *)
Definition semaphore_alloc_index_inv (stable : SemaphoreStable)
    (state : SemaphoreState) (index : Z) : Prop :=
  0 <= index <= (stable.(semaphore_id_limit) + 7) / 8 /\
  forall id,
    0 <= id < Z.min (index * 8) stable.(semaphore_id_limit) ->
    semaphore_id_used state id = true.

(**
  [AllocId] 内层循环的 [entry] 是当前 bitmap byte 右移 [offset] 位后的值；
  该不变式只暴露扫描语义，不把 byte representation 泄漏给上层调用者。
*)
Definition semaphore_alloc_entry_inv (stable : SemaphoreStable)
    (state : SemaphoreState) (index id entry : Z) : Prop :=
  exists offset,
    id = index * 8 + offset /\
    0 <= offset <= 8 /\
    0 <= entry <= 255 /\
    (forall bit,
      0 <= bit < offset ->
      semaphore_id_used state (index * 8 + bit) = true) /\
    (exists free_bit,
      0 <= free_bit < 8 /\
      semaphore_id_used state (index * 8 + free_bit) = false) /\
    (forall bit,
      0 <= bit < 8 - offset ->
      Z.testbit entry bit = semaphore_id_used state (id + bit)) /\
    id <= stable.(semaphore_id_limit) + 7.

(** 8-bit 值不是 [0xff] 时，低八位中必有一个零 bit。 *)
Lemma semaphore_byte_not_full_has_zero_bit :
  forall entry,
    0 <= entry <= 255 ->
    entry <> 255 ->
    exists bit, 0 <= bit < 8 /\ Z.testbit entry bit = false.
Proof.
  intros entry Hrange Hneq.
  destruct (Z.testbit entry 0) eqn:H0; [| exists 0; split; [lia | exact H0]].
  destruct (Z.testbit entry 1) eqn:H1; [| exists 1; split; [lia | exact H1]].
  destruct (Z.testbit entry 2) eqn:H2; [| exists 2; split; [lia | exact H2]].
  destruct (Z.testbit entry 3) eqn:H3; [| exists 3; split; [lia | exact H3]].
  destruct (Z.testbit entry 4) eqn:H4; [| exists 4; split; [lia | exact H4]].
  destruct (Z.testbit entry 5) eqn:H5; [| exists 5; split; [lia | exact H5]].
  destruct (Z.testbit entry 6) eqn:H6; [| exists 6; split; [lia | exact H6]].
  destruct (Z.testbit entry 7) eqn:H7; [| exists 7; split; [lia | exact H7]].
  exfalso. apply Hneq. apply Z.bits_inj. intros bit.
  destruct (Z_lt_ge_dec bit 0) as [Hneg | Hnonneg].
  - rewrite !Z.testbit_neg_r by lia. reflexivity.
  - destruct (Z_lt_ge_dec bit 8) as [Hlow | Hhigh].
    + assert (bit = 0 \/ bit = 1 \/ bit = 2 \/ bit = 3 \/
              bit = 4 \/ bit = 5 \/ bit = 6 \/ bit = 7) by lia.
      destruct H as [-> | [-> | [-> | [-> | [-> | [-> | [-> | ->]]]]]]];
        vm_compute; assumption.
    + assert (Hentry_bit : Z.testbit entry bit = false).
      { destruct (Z.eq_dec entry 0) as [-> | Hpositive].
        - apply Z.bits_0.
        - apply Z.bits_above_log2; [lia |].
          assert (Z.log2 entry < 8).
          { apply (proj1 (Z.log2_lt_pow2 entry 8 ltac:(lia))).
            change (entry < 256). lia. }
          lia. }
      assert (Hfull_bit : Z.testbit 255 bit = false).
      { change (Z.testbit (Z.ones 8) bit = false).
        apply Z.ones_spec_high. lia. }
      rewrite Hentry_bit, Hfull_bit. reflexivity.
Qed.

(** 内层扫描从当前 byte 的 bit 0 开始时，不变式成立。 *)
Lemma semaphore_alloc_entry_inv_init :
  forall stable state index entry,
    0 <= entry <= 255 ->
    (forall bit, 0 <= bit < 8 ->
      Z.testbit entry bit =
      semaphore_id_used state (index * 8 + bit)) ->
    entry <> 255 ->
    index * 8 <= stable.(semaphore_id_limit) + 7 ->
    semaphore_alloc_entry_inv
      stable state index (index * 8) entry.
Proof.
  intros stable state index entry Hrange Hbits Hnotfull Hlimit.
  destruct (semaphore_byte_not_full_has_zero_bit entry Hrange Hnotfull)
    as [free_bit [Hfree_range Hfree_bit]].
  assert (Hfree : exists bit, 0 <= bit < 8 /\
      semaphore_id_used state (index * 8 + bit) = false).
  { exists free_bit. split; [exact Hfree_range |].
    rewrite <- Hbits by exact Hfree_range. exact Hfree_bit. }
  exists 0.
  split; [lia |].
  split; [lia |].
  split; [exact Hrange |].
  split.
  - intros bit Hempty. lia.
  - split.
    + exact Hfree.
    + split.
      * intros bit Hbit.
        replace (index * 8 + 0 + bit) with (index * 8 + bit) by lia.
        apply Hbits. lia.
      * exact Hlimit.
Qed.

(** while body 右移一次时，已扫描前缀扩展一个 bit。 *)
Lemma semaphore_alloc_entry_inv_step :
  forall stable state index id entry,
    semaphore_alloc_entry_inv stable state index id entry ->
    Z.testbit entry 0 = true ->
    0 <= Z.shiftr entry 1 <= 255 ->
    id + 1 <= stable.(semaphore_id_limit) + 7 ->
    semaphore_alloc_entry_inv
      stable state index (id + 1) (Z.shiftr entry 1).
Proof.
  intros stable state index id entry Hinv Hcurrent Hshift Hlimit.
  destruct Hinv as
    [offset [Hid [Hoff [Hentry [Hprefix [Hfree [Hremaining Holdlimit]]]]]]].
  destruct Hfree as [free_bit [Hfree_range Hfree]].
  assert (Hoffset8 : offset < 8).
  { destruct (Z.eq_dec offset 8) as [Heq | Hneq]; [| lia].
    subst offset.
    specialize (Hprefix free_bit Hfree_range).
    rewrite Hfree in Hprefix. discriminate. }
  exists (offset + 1).
  split; [lia |].
  split; [lia |].
  split; [exact Hshift |].
  split.
  - intros bit Hbit.
    destruct (Z.eq_dec bit offset) as [-> | Hneq].
    + specialize (Hremaining 0).
      replace (id + 0) with id in Hremaining by lia.
      rewrite Hremaining in Hcurrent by lia.
      rewrite <- Hid. exact Hcurrent.
    + apply Hprefix. lia.
  - split.
    + exists free_bit. split; assumption.
    + split.
      * intros bit Hbit.
        rewrite Z.shiftr_spec by lia.
        replace (bit + 1) with (1 + bit) by lia.
        rewrite Hremaining by lia.
        f_equal. lia.
      * exact Hlimit.
Qed.

(** guard 为假且尚在当前 byte 内时，当前 ID 的 bit 确为未占用。 *)
Lemma semaphore_alloc_entry_inv_exit :
  forall stable state index id entry,
    semaphore_alloc_entry_inv stable state index id entry ->
    Z.testbit entry 0 = false ->
    semaphore_id_used state id = false.
Proof.
  intros stable state index id entry Hinv Hzero.
  destruct Hinv as
    [offset [Hid [Hoff [Hentry [Hprefix [Hfree [Hremaining Hlimit]]]]]]].
  destruct Hfree as [free_bit [Hfree_range Hfree]].
  assert (Hoffset8 : offset < 8).
  { destruct (Z.eq_dec offset 8) as [Heq | Hneq]; [| lia].
    subst offset.
    specialize (Hprefix free_bit Hfree_range).
    rewrite Hfree in Hprefix. discriminate. }
  specialize (Hremaining 0).
  replace (id + 0) with id in Hremaining by lia.
  rewrite Hremaining in Hzero by lia.
  exact Hzero.
Qed.

(** 从起点起此前 ID 全占用而当前 ID 空闲时，有限扫描返回当前 ID。 *)
Lemma semaphore_first_free_from_of_candidate :
  forall state fuel start id,
    0 <= start ->
    start <= id < start + Z.of_nat fuel ->
    (forall prior, start <= prior < id ->
      semaphore_id_used state prior = true) ->
    semaphore_id_used state id = false ->
    semaphore_first_free_from state fuel start = Some id.
Proof.
  intros state fuel. induction fuel as [| fuel IH];
    intros start id Hstart Hid Hall Hfree.
  - simpl in Hid. lia.
  - simpl. destruct (semaphore_id_used state start) eqn:Hused.
    + apply (IH (start + 1) id).
      * lia.
      * assert (Hstart_id : start < id).
        { destruct (Z.eq_dec id start) as [Heq | Hneq].
          - subst id. rewrite Hused in Hfree. discriminate.
          - lia. }
        rewrite Nat2Z.inj_succ in Hid.
        unfold Z.succ in Hid. lia.
      * intros prior Hprior. apply Hall. lia.
      * exact Hfree.
    + assert (id = start).
      { destruct (Z.eq_dec id start) as [Heq | Hneq]; [exact Heq |].
        assert (Hused_true : semaphore_id_used state start = true).
        { apply Hall. lia. }
        rewrite Hused in Hused_true. discriminate. }
      subst id. reflexivity.
Qed.

(** 全局 0-based ID 范围内的首个候选与 [semaphore_first_free] 一致。 *)
Lemma semaphore_first_free_of_candidate :
  forall stable state id,
    0 <= stable.(semaphore_id_limit) ->
    0 <= id < stable.(semaphore_id_limit) ->
    (forall prior, 0 <= prior < id ->
      semaphore_id_used state prior = true) ->
    semaphore_id_used state id = false ->
    semaphore_first_free stable state = Some id.
Proof.
  intros stable state id Hlimit Hid Hall Hfree.
  unfold semaphore_first_free.
  apply semaphore_first_free_from_of_candidate; try assumption; try lia.
Qed.

(** outer prefix 与 inner prefix 合并后，循环退出 ID 即全局首个空闲 ID。 *)
Lemma semaphore_alloc_entry_inv_first_free :
  forall stable state index id entry,
    semaphore_alloc_index_inv stable state index ->
    semaphore_alloc_entry_inv stable state index id entry ->
    Z.testbit entry 0 = false ->
    0 <= id < stable.(semaphore_id_limit) ->
    semaphore_first_free stable state = Some id.
Proof.
  intros stable state index id entry Hindex Hentry Hzero Hidrange.
  pose proof Hentry as Hentry_exit.
  apply semaphore_alloc_entry_inv_exit in Hentry_exit; [| exact Hzero].
  unfold semaphore_alloc_index_inv in Hindex.
  destruct Hindex as [Hindex_range Houter].
  destruct Hentry as
    [offset [Hid [Hoff [Hentry_range [Hprefix [Hfree [Hremaining Hlimit]]]]]]].
  apply semaphore_first_free_of_candidate; try lia; try assumption.
  intros prior Hprior.
  destruct (Z_lt_ge_dec prior (index * 8)) as [Hbefore | Hcurrent].
  - apply Houter. split; [lia |].
    apply Z.min_glb_lt; lia.
  - specialize (Hprefix (prior - index * 8)).
    replace (index * 8 + (prior - index * 8)) with prior in Hprefix by lia.
    apply Hprefix. lia.
Qed.

(** None 是 BSS `(NULL,NULL)`；Some nil 是已初始化空桶；Some xs 是非空桶。 *)
Definition SemBucket := option (list SemaphoreObject).

(** ID manager 的 bucket 只按分配地址与 ID 识别对象。value 与 pending
    membership 属于 registry/task 一侧的不变量，因此从 bucket 纯视图中擦除。 *)
Definition semaphore_id_view (object : SemaphoreObject) : SemaphoreObject :=
  Build_SemaphoreObject object.(semaphore_addr) object.(semaphore_id) 0 nil.

Definition semaphore_objects_in_bucket (stable : SemaphoreStable)
    (index : Z) (objects : list SemaphoreObject) : list SemaphoreObject :=
  map semaphore_id_view
    (filter
      (fun object =>
         if Z.eq_dec
              (object.(semaphore_id) mod stable.(semaphore_bucket_count)) index
         then true else false)
      objects).

Fixpoint semaphore_buckets_match_from (stable : SemaphoreStable)
    (index : Z) (buckets : list SemBucket) (objects : list SemaphoreObject) : Prop :=
  match buckets with
  | nil => True
  | bucket :: rest =>
      (match bucket with
       | None => semaphore_objects_in_bucket stable index objects = nil
       | Some bucket_objects =>
           bucket_objects = semaphore_objects_in_bucket stable index objects
       end) /\
      semaphore_buckets_match_from stable (index + 1) rest objects
  end.

Definition semaphore_buckets_ok (stable : SemaphoreStable)
    (state : SemaphoreState) (buckets : list SemBucket) : Prop :=
  Zlength buckets = stable.(semaphore_bucket_count) /\
  semaphore_buckets_match_from stable 0 buckets state.(semaphore_objects).

Definition semaphore_object_wf (stable : SemaphoreStable)
    (object : SemaphoreObject) : Prop :=
  object.(semaphore_addr) <> 0 /\
  0 <= object.(semaphore_id) < stable.(semaphore_id_limit) /\
  0 <= object.(semaphore_value) <= 65535 /\
  Forall (fun task => task <> 0) object.(semaphore_pending_addrs) /\
  NoDup object.(semaphore_pending_addrs).

(**
  模块合法性约束配置、对象地址/ID 唯一性和 intrusive pending membership。
  pending task 是否处于可唤醒 SUSPEND 状态由 task/semaphore bridge 约束，
  不在 semaphore state 中复制一份任务抽象。
*)
Definition semaphore_state_wf (stable : SemaphoreStable)
    (state : SemaphoreState) : Prop :=
  stable.(semaphore_id_limit) = SEM_ID_MAX /\
  stable.(semaphore_bucket_count) = SEM_BUCKET_COUNT /\
  Forall (semaphore_object_wf stable) state.(semaphore_objects) /\
  NoDup (semaphore_addresses state.(semaphore_objects)) /\
  NoDup (semaphore_ids state.(semaphore_objects)) /\
  NoDup (semaphore_all_pending state.(semaphore_objects)).

(** semaphore 模块在一次临界区内允许提交的抽象动作。 *)
Inductive semaphore_atomic_step (stable : SemaphoreStable)
    : SemaphoreState -> SemaphoreState -> Prop :=
  | SemStepCreate : forall before after p id value,
      semaphore_find_addr p before.(semaphore_objects) = None ->
      semaphore_first_free stable before = Some id ->
      after = semaphore_create_state before p id value ->
      semaphore_state_wf stable before ->
      semaphore_state_wf stable after ->
      semaphore_atomic_step stable before after
  | SemStepDelete : forall before after object,
      semaphore_find_id object.(semaphore_id) before.(semaphore_objects) =
        Some object ->
      after = semaphore_delete_state before object ->
      semaphore_state_wf stable before ->
      semaphore_state_wf stable after ->
      semaphore_atomic_step stable before after
  | SemStepObtainImmediate : forall before after object,
      semaphore_find_id object.(semaphore_id) before.(semaphore_objects) =
        Some object ->
      object.(semaphore_value) > 0 ->
      after = semaphore_replace_object before
        (semaphore_with_value object (object.(semaphore_value) - 1)) ->
      semaphore_state_wf stable before ->
      semaphore_state_wf stable after ->
      semaphore_atomic_step stable before after
  | SemStepPend : forall (before after : SemaphoreState)
      (object : SemaphoreObject) (task : addr) (prefix suffix : list addr),
      semaphore_find_id object.(semaphore_id) before.(semaphore_objects) =
        Some object ->
      object.(semaphore_value) = 0 ->
      object.(semaphore_pending_addrs) = List.app prefix suffix ->
      after = semaphore_replace_object before
        (semaphore_with_pending object (List.app prefix (task :: suffix))) ->
      semaphore_state_wf stable before ->
      semaphore_state_wf stable after ->
      semaphore_atomic_step stable before after
  | SemStepAbandonValue : forall before after object,
      semaphore_find_id object.(semaphore_id) before.(semaphore_objects) =
        Some object ->
      object.(semaphore_pending_addrs) = nil ->
      after = semaphore_replace_object before
        (semaphore_with_value object ((object.(semaphore_value) + 1) mod 65536)) ->
      semaphore_state_wf stable before ->
      semaphore_state_wf stable after ->
      semaphore_atomic_step stable before after
  | SemStepWakeOne : forall before after object task rest,
      semaphore_find_id object.(semaphore_id) before.(semaphore_objects) =
        Some object ->
      object.(semaphore_pending_addrs) = task :: rest ->
      after = semaphore_replace_object before (semaphore_with_pending object rest) ->
      semaphore_state_wf stable before ->
      semaphore_state_wf stable after ->
      semaphore_atomic_step stable before after
  | SemStepTimeout : forall before after object task prefix suffix,
      semaphore_find_id object.(semaphore_id) before.(semaphore_objects) =
        Some object ->
      object.(semaphore_pending_addrs) = List.app prefix (task :: suffix) ->
      after = semaphore_replace_object before
        (semaphore_with_pending object (List.app prefix suffix)) ->
      semaphore_state_wf stable before ->
      semaphore_state_wf stable after ->
      semaphore_atomic_step stable before after
  | SemStepSetValue : forall before after object value,
      semaphore_find_id object.(semaphore_id) before.(semaphore_objects) =
        Some object ->
      0 <= value <= 65535 ->
      object.(semaphore_value) <> value ->
      after = semaphore_replace_object before
        (semaphore_with_pending (semaphore_with_value object value) nil) ->
      semaphore_state_wf stable before ->
      semaphore_state_wf stable after ->
      semaphore_atomic_step stable before after.

(** Rely/guarantee 都是上述真实模块动作的有限自反传递闭包。 *)
Definition SemaphoreRTrans (stable : SemaphoreStable)
    (before after : SemaphoreState) : Prop :=
  @Relation_Operators.clos_refl_trans
    SemaphoreState (semaphore_atomic_step stable) before after.
Definition SemaphoreGTrans := SemaphoreRTrans.

Lemma SemaphoreGTrans_refl :
  forall stable state, SemaphoreGTrans stable state state.
Proof.
  intros. unfold SemaphoreGTrans, SemaphoreRTrans.
  apply Relation_Operators.rt_refl.
Qed.

Definition SemaphoreLastSeen (stable : SemaphoreStable)
    (state : SemaphoreState) : (SemaphoreState -> Prop) -> Prop :=
  fun states => states == SemaphoreRTrans stable state.

(** 公开 create 的原子语义：失败 stutter；成功发布首个空闲 ID。 *)
Definition abs_semaphore_create (stable : SemaphoreStable) (value : Z)
    : program SemaphoreState Z :=
  fun before result after =>
    (result = SEM_NO_MEMORY /\ after = before) \/
    (exists p id,
      p <> 0 /\ 0 <= value <= 65535 /\
      semaphore_find_addr p before.(semaphore_objects) = None /\
      semaphore_first_free stable before = Some id /\
      result = id /\ after = semaphore_create_state before p id value /\
      semaphore_state_wf stable before /\ semaphore_state_wf stable after).

Definition semaphore_atomic_cmd {A : Type} (stable : SemaphoreStable)
    (command : program SemaphoreState A)
    : program (SemaphoreState -> Prop) A :=
  fun states_before result states_after =>
    exists before after,
      states_before before /\ command before result after /\
      states_after == SemaphoreRTrans stable after.

Definition abs_ksemaphore_create (stable : SemaphoreStable) (value : Z)
    : program (SemaphoreState -> Prop) Z :=
  semaphore_atomic_cmd stable (abs_semaphore_create stable value).
