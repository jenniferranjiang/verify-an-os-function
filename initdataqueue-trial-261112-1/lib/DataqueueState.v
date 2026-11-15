Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem CNotation.
Require Export CRTOS_Verify.lib.common.StructFieldOffsetAxiom.
Import ListNotations KTaskCNotation.
Local Open Scope Z_scope.
Local Open Scope string.

(** DataElemType的payload引用和长度；不拥有payload内存。 *)
Record DataElemAbs := { dq_elem_data : addr; dq_elem_length : Z }.
(** 六个字段直接对应caller提供的DataQueueType对象，不复制Semaphore对象。
    信号量ID仅是引用；对象/ID manager内存继续由os_inv唯一持有。
    两个_object为创建时的对象基址ghost witness，用于跨解锁窗口保持身份；
    它们不对应额外C字段，不拥有Semaphore内存。
    front/rear/max_len保持原uint16值，允许初始化0/1容量的真实路径。 *)
Record DataqueueAbs := {
  dq_front : Z; dq_rear : Z; dq_max_len : Z;
  dq_base : addr; dq_blank : Z; dq_data : Z;
  dq_blank_object : addr; dq_data_object : addr
}.

(** 初始化时未写数组内容；非空malloc可在NodeNumber=0时返回零长度分配。
    返回资源仍区分空指针和非空零长度地址，不假定malloc(0)必失败。 *)
Definition dataqueue_init_slots (q : DataqueueAbs) : list (option DataElemAbs) :=
  if Z.eq_dec q.(dq_base) 0 then nil
  else repeat None (Z.to_nat q.(dq_max_len)).

(** 当前ILP32 ABI的检查目标；仅命题陈述，不是新公理或已证布局事实。 *)
Definition dataqueue_layout_obligation : Prop :=
  sizeof("DataQueueType") = 20 /\ sizeof("DataElemType") = 8 /\
  forall p : addr,
    &(p # "DataQueueType" ->ₛ "front") = p /\
    &(p # "DataQueueType" ->ₛ "rear") = p+2 /\
    &(p # "DataQueueType" ->ₛ "max_len") = p+4 /\
    &(p # "DataQueueType" ->ₛ "base") = p+8 /\
    &(p # "DataQueueType" ->ₛ "sem_blank") = p+12 /\
    &(p # "DataQueueType" ->ₛ "sem_data") = p+16 /\
    &(p # "DataElemType" ->ₛ "data") = p /\
    &(p # "DataElemType" ->ₛ "length") = p+4.

(** 清理只清空base及成功获取的句柄。负错误码不会进入if，必须保留原值；
    front/rear/max_len在DeInit中没有写入。 *)
Definition dq_cleared (q : DataqueueAbs) : DataqueueAbs :=
  {| dq_front := q.(dq_front); dq_rear := q.(dq_rear);
     dq_max_len := q.(dq_max_len); dq_base := 0;
     dq_blank := if Z.leb 0 q.(dq_blank) then -1 else q.(dq_blank);
     dq_data := if Z.leb 0 q.(dq_data) then -1 else q.(dq_data);
     dq_blank_object := 0; dq_data_object := 0 |}.

(** 已发布队列由共享模块按真实DataQueueType基址索引，ghost map不对应
    新增C全局表。Active表示已发布且尚未retire，Retiring表示资源正在回收。
    Init失败尚未发布，仍归当前初始化者；不进入这个map。 *)
Inductive DataqueuePhase := DQActive | DQRetiring.
Record PublishedDataqueue := {
  published_queue : DataqueueAbs;
  published_slots : list (option DataElemAbs);
  published_phase : DataqueuePhase
}.
Definition DataqueueState := addr -> option PublishedDataqueue.
Definition dataqueue_initial : DataqueueState := fun _ => None.
Definition dataqueue_replace (p : addr) (value : option PublishedDataqueue)
    (st : DataqueueState) : DataqueueState :=
  fun location => if Z.eq_dec location p then value else st location.

(** 运行期环下标需要非零容量；初始化的0容量状态仍允许发布，但不能
    假装它支持后续取模访问。1容量有完整下标却永远没有空余可入队位置。 *)
Definition dataqueue_ring_usable (q : DataqueueAbs) : Prop :=
  0 < dq_max_len q /\ 0 <= dq_front q < dq_max_len q /\
  0 <= dq_rear q < dq_max_len q.
Definition dataqueue_ring_count (q : DataqueueAbs) : Z :=
  (dq_rear q - dq_front q + dq_max_len q) mod dq_max_len q.
Definition dataqueue_ring_indices (q : DataqueueAbs) : list Z :=
  map (fun i => (dq_front q + Z.of_nat i) mod dq_max_len q)
      (seq 0 (Z.to_nat (dataqueue_ring_count q))).
Definition dataqueue_contents (o : PublishedDataqueue) : list (option DataElemAbs) :=
  map (fun i => nth (Z.to_nat i) o.(published_slots) None)
      (dataqueue_ring_indices o.(published_queue)).

(** 更新rear处元素并前移rear；caller须按源码检查not-full和usable，
    信号量等待/释放发生在另外阶段，不在这里机械等同计数与环长度。 *)
Definition dataqueue_push_fields (value : DataElemAbs) (o : PublishedDataqueue)
    : PublishedDataqueue :=
  let q := o.(published_queue) in
  {| published_queue := {| dq_front := q.(dq_front);
       dq_rear := (q.(dq_rear)+1) mod q.(dq_max_len); dq_max_len := q.(dq_max_len);
       dq_base := q.(dq_base); dq_blank := q.(dq_blank); dq_data := q.(dq_data);
       dq_blank_object := q.(dq_blank_object); dq_data_object := q.(dq_data_object) |};
     published_slots := firstn (Z.to_nat q.(dq_rear)) o.(published_slots) ++
       Some value :: skipn (S (Z.to_nat q.(dq_rear))) o.(published_slots);
     published_phase := o.(published_phase) |}.

(** Pop只前移front，不清除原槽；Peek只观察front槽。slot保存旧写入值，
    活跃内容从当前front/rear派生，避免把stale槽当作仍在队列中的元素。 *)
Definition dataqueue_pop_fields (o : PublishedDataqueue) : PublishedDataqueue :=
  let q := o.(published_queue) in
  {| published_queue := {| dq_front := (q.(dq_front)+1) mod q.(dq_max_len);
       dq_rear := q.(dq_rear); dq_max_len := q.(dq_max_len);
       dq_base := q.(dq_base); dq_blank := q.(dq_blank); dq_data := q.(dq_data);
       dq_blank_object := q.(dq_blank_object); dq_data_object := q.(dq_data_object) |};
     published_slots := o.(published_slots); published_phase := o.(published_phase) |}.
Definition dataqueue_peek_value (o : PublishedDataqueue) : option DataElemAbs :=
  nth (Z.to_nat o.(published_queue).(dq_front)) o.(published_slots) None.
Definition dataqueue_begin_retire (o : PublishedDataqueue) : PublishedDataqueue :=
  {| published_queue := o.(published_queue); published_slots := o.(published_slots);
     published_phase := DQRetiring |}.
Definition dataqueue_withdraw (p : addr) (st : DataqueueState) : DataqueueState :=
  dataqueue_replace p None st.

(** 活跃环中的槽必须已写入，支持Pop/Peak的load；出队后保留的stale槽
    不计为当前内容。初始化0/1容量的空环也满足此条件。 *)
Definition dataqueue_active_slots_known (o : PublishedDataqueue) : Prop :=
  Forall (fun value => exists e, value = Some e) (dataqueue_contents o).
Definition dataqueue_object_valid (o : PublishedDataqueue) : Prop :=
  match o.(published_phase) with
  | DQActive =>
      let q := o.(published_queue) in
      q.(dq_base) <> 0 /\ Z.of_nat (List.length o.(published_slots)) = q.(dq_max_len) /\
      ((q.(dq_max_len) = 0 /\ q.(dq_front) = 0 /\ q.(dq_rear) = 0) \/
       dataqueue_ring_usable q) /\ dataqueue_active_slots_known o
  | DQRetiring => True
  end.
Definition dataqueue_valid (st : DataqueueState) : Prop :=
  forall p o, st p = Some o -> dataqueue_object_valid o.

(** 对应Push/Pop临界区的完整字段分支：满/空时保持，不伪造数组写入或
    输出；外层Obtain/Abandon和timeout行为由其各自API程序表达，不把这些
    局部内存效果误称为已证明的完整Push/Pop函数契约。 *)
Definition dataqueue_push_fields_step (value : DataElemAbs)
    (before after : PublishedDataqueue) : Prop :=
  let q := before.(published_queue) in
  dataqueue_ring_usable q /\
  after = (if Z.eqb ((q.(dq_rear)+1) mod q.(dq_max_len)) q.(dq_front)
           then before else dataqueue_push_fields value before).
Definition dataqueue_pop_fields_step (before after : PublishedDataqueue)
    (result : option DataElemAbs) : Prop :=
  let q := before.(published_queue) in
  dataqueue_ring_usable q /\
  ((q.(dq_front) = q.(dq_rear) /\ after = before /\ result = None) \/
   (q.(dq_front) <> q.(dq_rear) /\ after = dataqueue_pop_fields before /\
    result = dataqueue_peek_value before)).

(** 释放数组并注销本对象引用的sem之后，仍保留原caller提供的20字节
    struct；最终withdraw把这块内存返还caller，不对struct本身调用free。 *)
Definition dataqueue_finish_retire (o : PublishedDataqueue) : PublishedDataqueue :=
  {| published_queue := dq_cleared o.(published_queue); published_slots := nil;
     published_phase := DQRetiring |}.

(** Peek的空/非空路径；只读当前front槽，不改变queue或旧slot。 *)
Definition dataqueue_peek_fields_step (o : PublishedDataqueue)
    (result : option DataElemAbs) : Prop :=
  let q := o.(published_queue) in
  dataqueue_ring_usable q /\
  ((q.(dq_front) = q.(dq_rear) /\ result = None) \/
   (q.(dq_front) <> q.(dq_rear) /\ result = dataqueue_peek_value o)).

(** 以下是运行时共享接口的待证纯性质；活动区typed保证读取Some，
    guarded字段操作保持模块合法性。不是完整Push/Pop/Peak的C实现证明。 *)
Definition dataqueue_front_known_obligation : Prop :=
  forall o, dataqueue_object_valid o -> o.(published_phase) = DQActive ->
    o.(published_queue).(dq_front) <> o.(published_queue).(dq_rear) ->
    exists e, dataqueue_peek_value o = Some e.
Definition dataqueue_push_valid_obligation : Prop :=
  forall value before after,
    dataqueue_object_valid before -> before.(published_phase) = DQActive ->
    dataqueue_push_fields_step value before after -> dataqueue_object_valid after.
Definition dataqueue_pop_valid_obligation : Prop :=
  forall before after result,
    dataqueue_object_valid before -> before.(published_phase) = DQActive ->
    dataqueue_pop_fields_step before after result -> dataqueue_object_valid after.
