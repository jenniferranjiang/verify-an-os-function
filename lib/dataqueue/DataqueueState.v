Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem CNotation.
Require Export CRTOS_Verify.lib.semaphore.SemaphoreState.
Import ListNotations KTaskCNotation.
Local Open Scope Z_scope.

(** DataElemType 只保存借用的 payload 地址和长度；本模块从不解引用或释放 payload。 *)
Record DataqueueElem := { dq_data : addr; dq_length : Z }.

(** 同一 DataQueueType 的持久字段和连续数组槽。None 表示未知/未初始化槽，
    Some 保留已写值；Pop 不清槽，因此出队后的槽仍可保留旧值。
    qaddr 是调用者分配的结构地址；base 是本轮 malloc 返回的数组地址。 *)
Record DataqueueObject := {
  dq_addr : addr;
  dq_base : addr;
  dq_max_len : Z;
  dq_front : Z;
  dq_rear : Z;
  dq_sem_blank : Z;
  dq_sem_data : Z;
  dq_slots : list (option DataqueueElem)
}.

(** 无 C 管理链；此列表只是共享对象的逻辑集合，不拥有虚构的链表根。
    尚未成功 Init 的对象仍由 caller 独占，不在此集合。 *)
Definition DataqueueState := list DataqueueObject.
Definition dataqueue_initial : DataqueueState := nil.

(** 模运算定义当前 FIFO 的长度和槽序列；只在 ready 的正容量条件下使用。 *)
Definition dataqueue_count (q : DataqueueObject) : Z :=
  (q.(dq_rear) - q.(dq_front) + q.(dq_max_len)) mod q.(dq_max_len).
Definition dataqueue_contents (q : DataqueueObject) : list (option DataqueueElem) :=
  map (fun k => nth (Z.to_nat ((q.(dq_front) + Z.of_nat k) mod q.(dq_max_len)))
    q.(dq_slots) None) (seq 0 (Z.to_nat (dataqueue_count q))).

(** ready 允许 n=1 的零有效容量；仅当前 FIFO 区间必须已初始化。
    semaphore 计数不等于队列长度：Obtain、槽更新、Abandon 是不同临界阶段。 *)
Definition dataqueue_ready (q : DataqueueObject) : Prop :=
  0 < q.(dq_max_len) <= 65535 /\ q.(dq_base) <> 0 /\
  0 <= q.(dq_front) < q.(dq_max_len) /\
  0 <= q.(dq_rear) < q.(dq_max_len) /\
  Z.of_nat (List.length q.(dq_slots)) = q.(dq_max_len) /\
  0 <= q.(dq_sem_blank) /\ 0 <= q.(dq_sem_data) /\
  q.(dq_sem_blank) <> q.(dq_sem_data) /\
  Forall (fun e => exists v, e = Some v) (dataqueue_contents q).

(** 仅连接 ID 与 semaphore 权威状态，不重复保存或拥有 Semaphore 对象。
    允许等待者及进行中的预订；计数和等待节点仍由 semaphore invariant 管理。 *)
Definition dataqueue_semaphores (ss : SemaphoreState) (q : DataqueueObject) : Prop :=
  (exists s, In s ss /\ s.(semaphore_id) = q.(dq_sem_blank)) /\
  (exists s, In s ss /\ s.(semaphore_id) = q.(dq_sem_data)).

(** 缓存ID后的字段一致条件；不排除地址/ID发生ABA复用，不提供保活。
    真实跨锁使用还须环境禁止该对象退役及相关semaphore删除/复用，
    或由函数assertS检查所需观察；Rely=True本身不保证这些条件。 *)
Definition dataqueue_same_configuration (old current : DataqueueObject) : Prop :=
  current.(dq_addr) = old.(dq_addr) /\ current.(dq_base) = old.(dq_base) /\
  current.(dq_max_len) = old.(dq_max_len) /\
  current.(dq_sem_blank) = old.(dq_sem_blank) /\
  current.(dq_sem_data) = old.(dq_sem_data).

(** DeInit 保留 front/rear/max_len；已负的创建错误码不改写为 -1。 *)
Definition dataqueue_retired (q : DataqueueObject) : DataqueueObject :=
  {| dq_addr := q.(dq_addr); dq_base := 0; dq_max_len := q.(dq_max_len);
     dq_front := q.(dq_front); dq_rear := q.(dq_rear);
     dq_sem_blank := if Z.leb 0 q.(dq_sem_blank) then -1 else q.(dq_sem_blank);
     dq_sem_data := if Z.leb 0 q.(dq_sem_data) then -1 else q.(dq_sem_data);
     dq_slots := nil |}.

(** 发布和撤回逻辑集合；结构本体从不由 DeInit 释放。 *)
Definition dataqueue_publish (q : DataqueueObject) (qs : DataqueueState) := q :: qs.
Definition dataqueue_remove (p : addr) (qs : DataqueueState) :=
  filter (fun q => negb (Z.eqb q.(dq_addr) p)) qs.

(** 环形槽写入只改变rear处的元素和rear；未触达槽（包括旧值）原样保持。
    Push真正执行该步前须有ready、非满及调用所需的semaphore预订条件。 *)
Definition dataqueue_push (q : DataqueueObject) (e : DataqueueElem) : DataqueueObject :=
  {| dq_addr := q.(dq_addr); dq_base := q.(dq_base); dq_max_len := q.(dq_max_len);
     dq_front := q.(dq_front); dq_rear := (q.(dq_rear)+1) mod q.(dq_max_len);
     dq_sem_blank := q.(dq_sem_blank); dq_sem_data := q.(dq_sem_data);
     dq_slots := firstn (Z.to_nat q.(dq_rear)) q.(dq_slots) ++
       Some e :: skipn (S (Z.to_nat q.(dq_rear))) q.(dq_slots) |}.

(** Pop只推进front，不覆盖数组槽；Peak返回相同front元素且整个q保持。 *)
Definition dataqueue_pop (q : DataqueueObject) : DataqueueObject :=
  {| dq_addr := q.(dq_addr); dq_base := q.(dq_base); dq_max_len := q.(dq_max_len);
     dq_front := (q.(dq_front)+1) mod q.(dq_max_len); dq_rear := q.(dq_rear);
     dq_sem_blank := q.(dq_sem_blank); dq_sem_data := q.(dq_sem_data);
     dq_slots := q.(dq_slots) |}.
Definition dataqueue_peak (q : DataqueueObject) : option DataqueueElem :=
  nth (Z.to_nat q.(dq_front)) q.(dq_slots) None.

(** calloc不是此处行为：结构被清零，但后续malloc数组仍未初始化。 *)
Definition dataqueue_zero (p : addr) : DataqueueObject :=
  {| dq_addr := p; dq_base := 0; dq_max_len := 0; dq_front := 0; dq_rear := 0;
     dq_sem_blank := 0; dq_sem_data := 0; dq_slots := nil |}.
