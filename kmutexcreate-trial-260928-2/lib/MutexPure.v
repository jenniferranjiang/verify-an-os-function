Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
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

(** 已批准的 stm32f103-nano 非 SMP 配置常量。 *)
Definition MUTEX_ID_MAX : Z := 128.
Definition MUTEX_BUCKET_COUNT : Z := 16.
Definition MUTEX_PRIORITY_MAX : Z := 32.
Definition MUTEX_OBJECT_SIZE : Z := 36.
Definition MUTEX_NO_MEMORY : Z := -5.

(**
  [MutexStable] 保存 [k_mutex_id_manager]、其 BSS bitmap/bucket 数组和
  [k_mutex_list] 的地址及固定容量。静态 [done] 表只有同一翻译单元中的
  唯一 initializer；annotated slice 将其 dispatch 解析为直接调用，故不进入状态。
*)
Record MutexStable : Type := Build_MutexStable {
  mutex_manager_addr : addr;
  mutex_bitmap_addr : addr;
  mutex_buckets_addr : addr;
  mutex_registry_addr : addr;
  mutex_id_limit : Z;
  mutex_bucket_count : Z
}.

(**
  一个已发布 mutex 以分配地址作为生命周期身份。[mutex_holder_addr] 为 0
  表示无持有者；[mutex_pending_addrs] 按 [pend_list] 的物理顺序保存等待
  TaskDescriptor 基址，只记录 mutex 可观察的关联，不复制 task 状态。
*)
Record MutexObject : Type := Build_MutexObject {
  mutex_addr : addr;
  mutex_id : Z;
  mutex_value : Z;
  mutex_recursive_count : Z;
  mutex_origin_priority : Z;
  mutex_holder_addr : addr;
  mutex_pending_addrs : list addr
}.

(** 模块可变状态是 [k_mutex_list] 顺序中的全部已发布对象。 *)
Record MutexState : Type := Build_MutexState {
  mutex_objects : list MutexObject
}.

Definition mutex_initial_state : MutexState := Build_MutexState nil.

Definition mutex_addresses (objects : list MutexObject) : list addr :=
  map mutex_addr objects.
Definition mutex_ids (objects : list MutexObject) : list Z :=
  map mutex_id objects.
Definition mutex_all_pending (objects : list MutexObject) : list addr :=
  List.concat (map mutex_pending_addrs objects).

Fixpoint mutex_find_id (id : Z) (objects : list MutexObject)
    : option MutexObject :=
  match objects with
  | nil => None
  | object :: rest =>
      if Z.eq_dec object.(mutex_id) id then Some object
      else mutex_find_id id rest
  end.

Fixpoint mutex_find_addr (p : addr) (objects : list MutexObject)
    : option MutexObject :=
  match objects with
  | nil => None
  | object :: rest =>
      if Z.eq_dec object.(mutex_addr) p then Some object
      else mutex_find_addr p rest
  end.

Fixpoint mutex_replace_addr
    (p : addr) (replacement : MutexObject) (objects : list MutexObject)
    : list MutexObject :=
  match objects with
  | nil => nil
  | object :: rest =>
      if Z.eq_dec object.(mutex_addr) p
      then replacement :: rest
      else object :: mutex_replace_addr p replacement rest
  end.

Fixpoint mutex_remove_addr (p : addr) (objects : list MutexObject)
    : list MutexObject :=
  match objects with
  | nil => nil
  | object :: rest =>
      if Z.eq_dec object.(mutex_addr) p
      then rest else object :: mutex_remove_addr p rest
  end.

(** 替换 mutex 的运行期字段，保持分配地址和注册 ID 不变。 *)
Definition mutex_with_runtime (object : MutexObject)
    (value recursive origin : Z) (holder : addr) (pending : list addr)
    : MutexObject :=
  Build_MutexObject object.(mutex_addr) object.(mutex_id)
    value recursive origin holder pending.

Definition mutex_replace_object (before : MutexState)
    (object : MutexObject) : MutexState :=
  Build_MutexState
    (mutex_replace_addr object.(mutex_addr) object before.(mutex_objects)).

(** create 表头发布的稳定对象：可用值 1、无 holder、递归计数 0、原优先级 255。 *)
Definition mutex_create_state (before : MutexState) (p : addr) (id : Z)
    : MutexState :=
  Build_MutexState
    (Build_MutexObject p id 1 0 255 0 nil :: before.(mutex_objects)).

(** ID 已进入 bitmap/bucket、对象尚未进入 [k_mutex_list] 的瞬时逻辑状态。 *)
Definition mutex_reserve_state (before : MutexState) (p : addr) (id : Z)
    : MutexState :=
  Build_MutexState
    (Build_MutexObject p id 0 0 0 0 nil :: before.(mutex_objects)).

Definition mutex_delete_state (before : MutexState) (object : MutexObject)
    : MutexState :=
  Build_MutexState
    (mutex_remove_addr object.(mutex_addr) before.(mutex_objects)).

Definition mutex_id_used (state : MutexState) (id : Z) : bool :=
  if in_dec Z.eq_dec id (mutex_ids state.(mutex_objects)) then true else false.

Fixpoint mutex_first_free_from (state : MutexState)
    (fuel : nat) (id : Z) : option Z :=
  match fuel with
  | O => None
  | S fuel' =>
      if mutex_id_used state id
      then mutex_first_free_from state fuel' (id + 1)
      else Some id
  end.

Definition mutex_first_free (stable : MutexStable)
    (state : MutexState) : option Z :=
  mutex_first_free_from state (Z.to_nat stable.(mutex_id_limit)) 0.

(** [AllocId] 外层循环已经确认前 [index] 个 bitmap byte 全满。 *)
Definition mutex_alloc_index_inv (stable : MutexStable)
    (state : MutexState) (index : Z) : Prop :=
  0 <= index <= (stable.(mutex_id_limit) + 7) / 8 /\
  forall id,
    0 <= id < Z.min (index * 8) stable.(mutex_id_limit) ->
    mutex_id_used state id = true.

(** [AllocId] 内层扫描只公开“右移后的 byte 与剩余 ID bit 一致”。 *)
Definition mutex_alloc_entry_inv (stable : MutexStable)
    (state : MutexState) (index id entry : Z) : Prop :=
  exists offset,
    id = index * 8 + offset /\
    0 <= offset <= 8 /\
    0 <= entry <= 255 /\
    (forall bit,
      0 <= bit < 8 - offset ->
      Z.testbit entry bit = mutex_id_used state (id + bit)) /\
    id <= stable.(mutex_id_limit) + 7.

(** None 是 BSS `(NULL,NULL)`；Some nil 是已 lazy-init 的空 bucket。 *)
Definition MutexBucket := option (list MutexObject).

Definition mutex_objects_in_bucket (stable : MutexStable)
    (index : Z) (objects : list MutexObject) : list MutexObject :=
  filter
    (fun object =>
       if Z.eq_dec
            (object.(mutex_id) mod stable.(mutex_bucket_count)) index
       then true else false)
    objects.

Fixpoint mutex_buckets_match_from (stable : MutexStable)
    (index : Z) (buckets : list MutexBucket) (objects : list MutexObject)
    : Prop :=
  match buckets with
  | nil => True
  | bucket :: rest =>
      (match bucket with
       | None => mutex_objects_in_bucket stable index objects = nil
       | Some bucket_objects =>
           bucket_objects = mutex_objects_in_bucket stable index objects
       end) /\
      mutex_buckets_match_from stable (index + 1) rest objects
  end.

Definition mutex_buckets_ok (stable : MutexStable)
    (state : MutexState) (buckets : list MutexBucket) : Prop :=
  Zlength buckets = stable.(mutex_bucket_count) /\
  mutex_buckets_match_from stable 0 buckets state.(mutex_objects).

(**
  稳定 mutex 的 C 字段范围及互斥语义。源码允许 uint8 递归计数回绕，
  因而不能无依据加强为“holder 非空时计数必大于 0”。空闲态则由源码
  唯一建立为 value=1、holder=NULL、count=0、origin=255、无 waiter。
*)
Definition mutex_object_wf (stable : MutexStable) (object : MutexObject) : Prop :=
  object.(mutex_addr) <> 0 /\
  0 <= object.(mutex_id) < stable.(mutex_id_limit) /\
  (object.(mutex_value) = 0 \/ object.(mutex_value) = 1) /\
  0 <= object.(mutex_recursive_count) <= 255 /\
  0 <= object.(mutex_origin_priority) <= 255 /\
  (object.(mutex_holder_addr) <> 0 ->
    0 <= object.(mutex_origin_priority) < MUTEX_PRIORITY_MAX) /\
  (object.(mutex_holder_addr) = 0 ->
    object.(mutex_value) = 1 /\
    object.(mutex_recursive_count) = 0 /\
    object.(mutex_origin_priority) = 255 /\
    object.(mutex_pending_addrs) = nil) /\
  (object.(mutex_holder_addr) <> 0 -> object.(mutex_value) = 0) /\
  Forall (fun task => task <> 0) object.(mutex_pending_addrs) /\
  NoDup object.(mutex_pending_addrs) /\
  ~ In object.(mutex_holder_addr) object.(mutex_pending_addrs).

(**
  模块合法性约束配置、对象地址/ID 唯一性和 intrusive pending membership。
  holder/waiter 的 task 状态由跨模块 bridge 约束，不复制 task abstract state。
*)
Definition mutex_state_wf (stable : MutexStable) (state : MutexState) : Prop :=
  stable.(mutex_id_limit) = MUTEX_ID_MAX /\
  stable.(mutex_bucket_count) = MUTEX_BUCKET_COUNT /\
  Forall (mutex_object_wf stable) state.(mutex_objects) /\
  NoDup (mutex_addresses state.(mutex_objects)) /\
  NoDup (mutex_ids state.(mutex_objects)) /\
  NoDup (mutex_all_pending state.(mutex_objects)).

(** mutex 模块在临界区中可提交的真实抽象动作。 *)
Inductive mutex_atomic_step (stable : MutexStable)
    : MutexState -> MutexState -> Prop :=
  | MutexStepCreate : forall before after p id,
      mutex_find_addr p before.(mutex_objects) = None ->
      mutex_first_free stable before = Some id ->
      after = mutex_create_state before p id ->
      mutex_state_wf stable before ->
      mutex_state_wf stable after ->
      mutex_atomic_step stable before after
  | MutexStepDelete : forall before after object,
      mutex_find_id object.(mutex_id) before.(mutex_objects) = Some object ->
      after = mutex_delete_state before object ->
      mutex_state_wf stable before ->
      mutex_state_wf stable after ->
      mutex_atomic_step stable before after
  | MutexStepObtainRecursive : forall before after object task,
      mutex_find_id object.(mutex_id) before.(mutex_objects) = Some object ->
      object.(mutex_holder_addr) = task ->
      task <> 0 ->
      after = mutex_replace_object before
        (mutex_with_runtime object object.(mutex_value)
          ((object.(mutex_recursive_count) + 1) mod 256)
          object.(mutex_origin_priority) object.(mutex_holder_addr)
          object.(mutex_pending_addrs)) ->
      mutex_state_wf stable before ->
      mutex_state_wf stable after ->
      mutex_atomic_step stable before after
  | MutexStepObtainFree : forall before after object task priority,
      mutex_find_id object.(mutex_id) before.(mutex_objects) = Some object ->
      object.(mutex_value) > 0 -> task <> 0 -> 0 <= priority < MUTEX_PRIORITY_MAX ->
      after = mutex_replace_object before
        (mutex_with_runtime object (object.(mutex_value) - 1)
          ((object.(mutex_recursive_count) + 1) mod 256)
          priority task object.(mutex_pending_addrs)) ->
      mutex_state_wf stable before ->
      mutex_state_wf stable after ->
      mutex_atomic_step stable before after
  | MutexStepPend : forall before after object task prefix suffix,
      mutex_find_id object.(mutex_id) before.(mutex_objects) = Some object ->
      object.(mutex_value) = 0 -> task <> 0 ->
      object.(mutex_pending_addrs) = List.app prefix suffix ->
      after = mutex_replace_object before
        (mutex_with_runtime object object.(mutex_value)
          object.(mutex_recursive_count) object.(mutex_origin_priority)
          object.(mutex_holder_addr) (List.app prefix (task :: suffix))) ->
      mutex_state_wf stable before ->
      mutex_state_wf stable after ->
      mutex_atomic_step stable before after
  | MutexStepTimeout : forall before after object task prefix suffix,
      mutex_find_id object.(mutex_id) before.(mutex_objects) = Some object ->
      object.(mutex_pending_addrs) = List.app prefix (task :: suffix) ->
      after = mutex_replace_object before
        (mutex_with_runtime object object.(mutex_value)
          object.(mutex_recursive_count) object.(mutex_origin_priority)
          object.(mutex_holder_addr) (List.app prefix suffix)) ->
      mutex_state_wf stable before ->
      mutex_state_wf stable after ->
      mutex_atomic_step stable before after
  | MutexStepAbandonNested : forall before after object,
      mutex_find_id object.(mutex_id) before.(mutex_objects) = Some object ->
      ((object.(mutex_recursive_count) - 1) mod 256) <> 0 ->
      after = mutex_replace_object before
        (mutex_with_runtime object object.(mutex_value)
          ((object.(mutex_recursive_count) - 1) mod 256)
          object.(mutex_origin_priority) object.(mutex_holder_addr)
          object.(mutex_pending_addrs)) ->
      mutex_state_wf stable before ->
      mutex_state_wf stable after ->
      mutex_atomic_step stable before after
  | MutexStepAbandonTransfer : forall before after object next rest priority,
      mutex_find_id object.(mutex_id) before.(mutex_objects) = Some object ->
      ((object.(mutex_recursive_count) - 1) mod 256) = 0 ->
      object.(mutex_pending_addrs) = next :: rest ->
      0 <= priority < MUTEX_PRIORITY_MAX ->
      after = mutex_replace_object before
        (mutex_with_runtime object object.(mutex_value) 1 priority next rest) ->
      mutex_state_wf stable before ->
      mutex_state_wf stable after ->
      mutex_atomic_step stable before after
  | MutexStepAbandonFree : forall before after object,
      mutex_find_id object.(mutex_id) before.(mutex_objects) = Some object ->
      ((object.(mutex_recursive_count) - 1) mod 256) = 0 ->
      object.(mutex_pending_addrs) = nil ->
      after = mutex_replace_object before
        (mutex_with_runtime object ((object.(mutex_value) + 1) mod 65536)
          0 255 0 nil) ->
      mutex_state_wf stable before ->
      mutex_state_wf stable after ->
      mutex_atomic_step stable before after.

(** Rely/guarantee 是上述模块动作的有限自反传递闭包。 *)
Definition MutexRTrans (stable : MutexStable)
    (before after : MutexState) : Prop :=
  @Relation_Operators.clos_refl_trans
    MutexState (mutex_atomic_step stable) before after.
Definition MutexGTrans := MutexRTrans.

Lemma MutexGTrans_refl :
  forall stable state, MutexGTrans stable state state.
Proof.
  intros. unfold MutexGTrans, MutexRTrans.
  apply Relation_Operators.rt_refl.
Qed.

Definition MutexLastSeen (stable : MutexStable) (state : MutexState)
    : (MutexState -> Prop) -> Prop :=
  fun states => states == MutexRTrans stable state.

(** 公开 create 的原子语义：两种分配失败均 stutter；成功发布首个空闲 ID。 *)
Definition abs_mutex_create (stable : MutexStable) : program MutexState Z :=
  fun before result after =>
    (result = MUTEX_NO_MEMORY /\ after = before) \/
    (exists p id,
      p <> 0 /\ mutex_find_addr p before.(mutex_objects) = None /\
      mutex_first_free stable before = Some id /\
      result = id /\ after = mutex_create_state before p id /\
      mutex_state_wf stable before /\ mutex_state_wf stable after).

Definition mutex_atomic_cmd {A : Type} (stable : MutexStable)
    (command : program MutexState A) : program (MutexState -> Prop) A :=
  fun states_before result states_after =>
    exists before after,
      states_before before /\ command before result after /\
      states_after == MutexRTrans stable after.

Definition abs_kmutex_create (stable : MutexStable)
    : program (MutexState -> Prop) Z :=
  mutex_atomic_cmd stable (abs_mutex_create stable).
