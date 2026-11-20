Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem CNotation.
Require Export CRTOS_Verify.lib.semaphore.SemaphoreState.
Import ListNotations KTaskCNotation.
Local Open Scope Z_scope.

(** DataElemType 只保存借用的 payload 地址和长度；本模块从不解引用或释放 payload。 *)
Record DataqueueElem := { dq_data : addr; dq_length : Z }.

(** dq_slots 只记录从队首到队尾的有效元素，不暴露物理空闲槽或出队后的旧值。
    front/rear 仍用于连接 C 字段和环形布局；具体分段与空闲区内存由 buffer 谓词描述。
    结构地址由 map 的 key 或局部 predicate 参数给出；base 是 malloc 数组地址。 *)
Record DataQueueAbs := {
  dq_base : addr;
  dq_max_len : Z;
  dq_front : Z;
  dq_rear : Z;
  dq_sem_blank : Z;
  dq_sem_data : Z;
  dq_slots : list DataqueueElem
}.

(** 地址是对象身份，value只记录该地址上的队列状态；Some表示已发布。
    这里没有对应的C全局管理链。有限定义域与对象资源由store_map给出。 *)
Record DataqueueState := {
  dataqueue_map : addr -> option DataQueueAbs
}.
Definition dataqueue_initial : DataqueueState :=
  {| dataqueue_map := fun _ => None |}.

(** 队列的逻辑内容和长度只取决于有效元素，不再遍历物理数组。 *)
Definition dataqueue_contents (q : DataQueueAbs) : list DataqueueElem :=
  q.(dq_slots).
Definition dataqueue_count (q : DataQueueAbs) : Z :=
  Z.of_nat (List.length q.(dq_slots)).

(** C 的 front/rear 与有效元素长度之间的表示关系。环形数组保留一个空槽，
    因此有效容量为 max_len-1；n=1 时只能表示空队列。 *)
Definition dataqueue_ring_count (q : DataQueueAbs) : Z :=
  (q.(dq_rear) - q.(dq_front) + q.(dq_max_len)) mod q.(dq_max_len).
Definition dataqueue_ring_shape (q : DataQueueAbs) : Prop :=
  0 < q.(dq_max_len) /\
  0 <= q.(dq_front) < q.(dq_max_len) /\
  0 <= q.(dq_rear) < q.(dq_max_len) /\
  dataqueue_count q = dataqueue_ring_count q.

(** ready 连接逻辑队列、物理索引和已创建的两个信号量。
    semaphore 计数不等于队列长度：Obtain、槽更新、Abandon 是不同临界阶段。 *)
Definition dataqueue_ready (q : DataQueueAbs) : Prop :=
  dataqueue_ring_shape q /\ q.(dq_max_len) <= 65535 /\ q.(dq_base) <> 0 /\
  0 <= q.(dq_sem_blank) /\ 0 <= q.(dq_sem_data) /\
  q.(dq_sem_blank) <> q.(dq_sem_data).

(** 仅连接 ID 与 semaphore 权威状态，不重复保存或拥有 Semaphore 对象。
    允许等待者及进行中的预订；计数和等待节点仍由 semaphore invariant 管理。 *)
Definition dataqueue_semaphores (ss : SemaphoreState) (q : DataQueueAbs) : Prop :=
  (exists s, In s ss /\ s.(semaphore_id) = q.(dq_sem_blank)) /\
  (exists s, In s ss /\ s.(semaphore_id) = q.(dq_sem_data)).

(** 缓存ID后的字段一致条件；不排除地址/ID发生ABA复用，不提供保活。
    真实跨锁使用还须环境禁止该对象退役及相关semaphore删除/复用，
    或由函数assertS检查所需观察；Rely=True本身不保证这些条件。 *)
Definition dataqueue_same_configuration (old current : DataQueueAbs) : Prop :=
  current.(dq_base) = old.(dq_base) /\
  current.(dq_max_len) = old.(dq_max_len) /\
  current.(dq_sem_blank) = old.(dq_sem_blank) /\
  current.(dq_sem_data) = old.(dq_sem_data).

(** DeInit 保留 front/rear/max_len；已负的创建错误码不改写为 -1。 *)
Definition dataqueue_retired (q : DataQueueAbs) : DataQueueAbs :=
  {| dq_base := 0; dq_max_len := q.(dq_max_len);
     dq_front := q.(dq_front); dq_rear := q.(dq_rear);
     dq_sem_blank := if Z.leb 0 q.(dq_sem_blank) then -1 else q.(dq_sem_blank);
     dq_sem_data := if Z.leb 0 q.(dq_sem_data) then -1 else q.(dq_sem_data);
     dq_slots := nil |}.

(** 发布和撤回逻辑集合；结构本体从不由 DeInit 释放。 *)
Definition dataqueue_publish (p : addr) (q : DataQueueAbs)
    (qs : DataqueueState) : DataqueueState :=
  {| dataqueue_map := fun key =>
       if Z.eq_dec key p then Some q else qs.(dataqueue_map) key |}.
Definition dataqueue_remove (p : addr) (qs : DataqueueState) : DataqueueState :=
  {| dataqueue_map := fun key =>
       if Z.eq_dec key p then None else qs.(dataqueue_map) key |}.

(** 成功入队在有效序列末尾追加元素；C 对应写 rear 槽并推进 rear。
    执行该步前须有 ready、非满及调用所需的 semaphore 预订条件。 *)
Definition dataqueue_push (q : DataQueueAbs) (e : DataqueueElem) : DataQueueAbs :=
  {| dq_base := q.(dq_base); dq_max_len := q.(dq_max_len);
     dq_front := q.(dq_front); dq_rear := (q.(dq_rear)+1) mod q.(dq_max_len);
     dq_sem_blank := q.(dq_sem_blank); dq_sem_data := q.(dq_sem_data);
     dq_slots := q.(dq_slots) ++ [e] |}.

(** 成功出队删除有效序列首元素，C 只推进 front，不清空旧槽。
    旧槽内存继续由 buffer 拥有，但旧值不再出现在队列状态中。Peak 只读队首。 *)
Definition dataqueue_pop (q : DataQueueAbs) : DataQueueAbs :=
  {| dq_base := q.(dq_base); dq_max_len := q.(dq_max_len);
     dq_front := (q.(dq_front)+1) mod q.(dq_max_len); dq_rear := q.(dq_rear);
     dq_sem_blank := q.(dq_sem_blank); dq_sem_data := q.(dq_sem_data);
     dq_slots := tl q.(dq_slots) |}.
Definition dataqueue_peak (q : DataQueueAbs) : option DataqueueElem :=
  hd_error q.(dq_slots).

(** calloc不是此处行为：结构被清零，但后续malloc数组仍未初始化。 *)
Definition dataqueue_zero : DataQueueAbs :=
  {| dq_base := 0; dq_max_len := 0; dq_front := 0; dq_rear := 0;
     dq_sem_blank := 0; dq_sem_data := 0; dq_slots := nil |}.

(** 入队、出队和查看队首的逻辑接口，不涉及物理槽位。 *)
Lemma dataqueue_push_contents : forall q e,
  dataqueue_contents (dataqueue_push q e) = dataqueue_contents q ++ [e].
Proof. reflexivity. Qed.

Lemma dataqueue_pop_contents : forall q,
  dataqueue_contents (dataqueue_pop q) = tl (dataqueue_contents q).
Proof. reflexivity. Qed.

Lemma dataqueue_peak_pop_contents : forall q e,
  dataqueue_peak q = Some e <->
  dataqueue_contents q = e :: dataqueue_contents (dataqueue_pop q).
Proof.
  intros q e. unfold dataqueue_peak, dataqueue_contents, dataqueue_pop; simpl.
  destruct (dq_slots q) as [|head tail]; simpl.
  - split; discriminate.
  - split; intro H; inversion H; reflexivity.
Qed.

Lemma dataqueue_push_count : forall q e,
  dataqueue_count (dataqueue_push q e) = dataqueue_count q + 1.
Proof.
  intros q e. unfold dataqueue_count, dataqueue_push; simpl.
  rewrite app_length, Nat2Z.inj_add. reflexivity.
Qed.
