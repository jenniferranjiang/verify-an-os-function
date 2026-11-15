(** Dataqueue 模块纯状态；依据本 trial 的五个修复/适配函数重新设计。
    这些定义不拥有内存，不对 payload 指向的数据作任何有效性或所有权承诺。 *)
From Coq Require Import ZArith List Strings.String.
From SimpleC.SL Require Import Mem CNotation.
Require Export CRTOS_Verify.lib.semaphore.SemaphoreState.
Import ListNotations KTaskCNotation.
Local Open Scope Z_scope.

(** DataElemType 保存指针和长度，既不复制也不释放指针所指 payload。 *)
Record DataqueueElem : Type := {
  dq_payload : addr;
  dq_length : Z
}.

(** 六个持久字段与连续元素数组。None 槽表示尚未初始化的两个字段；
    Some 保存上次写入的元素，即使 Pop 后槽不再占用也不抹去它。
    容量/base/ID 在 Init 与 DeInit 中变化，故不放在 StableGlobalState。 *)
Record DataqueueObject : Type := {
  dq_capacity : Z;
  dq_front : Z;
  dq_rear : Z;
  dq_base : addr;
  dq_blank : Z;
  dq_data : Z;
  dq_slots : list (option DataqueueElem)
}.

(** C 中没有统一 dataqueue 管理链；此有限地址映射是共享资源登记，
    地址指向调用者分配的 DataQueueType 本体，不是新分配的全局 C 表。
    只有已发布对象放入此映射；Init 私有过程和撤回后的回收不在其中。 *)
Definition DataqueueState : Type := addr -> option DataqueueObject.
Definition dataqueue_initial : DataqueueState := fun _ => None.
Definition dataqueue_set (qs : DataqueueState) (p : addr)
    (q : DataqueueObject) : DataqueueState :=
  fun a => if Z.eq_dec a p then Some q else qs a.
Definition dataqueue_remove (qs : DataqueueState) (p : addr) : DataqueueState :=
  fun a => if Z.eq_dec a p then None else qs a.

(** 环形距离只用于容量为正的 ready 对象；n=0 仍是 Init 合法输入，
    但分配失败，不能折叠为 ready。n=1 有零有效容量，并未被排除。 *)
Definition dataqueue_count (q : DataqueueObject) : Z :=
  (q.(dq_rear) - q.(dq_front)) mod q.(dq_capacity).
Definition dataqueue_occupied (q : DataqueueObject) (i : Z) : Prop :=
  0 <= i < q.(dq_capacity) /\
  (i - q.(dq_front)) mod q.(dq_capacity) < dataqueue_count q.

(** 抽象 FIFO 内容从环顺序及已初始化槽导出，不再维护第二份队列状态。
    dataqueue_ready 保证这些占用槽均为 Some。 *)
Definition dataqueue_contents (q : DataqueueObject) : list (option DataqueueElem) :=
  map (fun k => nth (Z.to_nat ((q.(dq_front) + Z.of_nat k) mod q.(dq_capacity)))
                     q.(dq_slots) None)
      (seq 0 (Z.to_nat (dataqueue_count q))).

(** ready 仅约束对象自身的环与合法ID；不声称 semaphore count 恒等于
    环长度，因为 Obtain、环更新、Abandon 是可被抢占的不同阶段。 *)
Definition dataqueue_ready (q : DataqueueObject) : Prop :=
  0 < q.(dq_capacity) <= 65535 /\
  0 <= q.(dq_front) < q.(dq_capacity) /\
  0 <= q.(dq_rear) < q.(dq_capacity) /\
  q.(dq_base) <> 0 /\
  Z.of_nat (List.length q.(dq_slots)) = q.(dq_capacity) /\
  0 <= q.(dq_blank) < 128 /\ 0 <= q.(dq_data) < 128 /\
  q.(dq_blank) <> q.(dq_data) /\
  forall i, dataqueue_occupied q i ->
    exists e, nth (Z.to_nat i) q.(dq_slots) None = Some e.

(** 两个ID引用 semaphore 模块，内存仍由 semaphore_inv 唯一持有。
    此关系同样适用于部分初始化：负值代表未取得资源，无相应对象要求。 *)
Definition dataqueue_sem_links (sems : SemaphoreState) (q : DataqueueObject) : Prop :=
  forall id, (id = q.(dq_blank) \/ id = q.(dq_data)) -> 0 <= id ->
    exists s, In s sems /\ s.(semaphore_id) = id.

(** 模块的共享对象分别拥有各自创建的两信号量ID；跨队列不得重复认领。
    这仅是引用一致性，不复制 semaphore 对象/等待链的空间权限。 *)
Definition dataqueue_module_wf (sems : SemaphoreState) (qs : DataqueueState) : Prop :=
  (forall p q, qs p = Some q -> dataqueue_ready q /\ dataqueue_sem_links sems q) /\
  (forall p q a r id, qs p = Some q -> qs a = Some r ->
    (id = q.(dq_blank) \/ id = q.(dq_data)) ->
    (id = r.(dq_blank) \/ id = r.(dq_data)) -> p = a).

(** Init 尚未触碰数组元素，成功发布时所有槽为 None；n、base和两ID
    由真实执行给出，不在此纯构造器断言 malloc/create 一定成功。 *)
Definition dataqueue_created (n base blank data : Z) : DataqueueObject :=
  {| dq_capacity := n; dq_front := 0; dq_rear := 0; dq_base := base;
     dq_blank := blank; dq_data := data;
     dq_slots := repeat None (Z.to_nat n) |}.

(** DeInit 只把非负ID置为-1；已为负的错误码原样保留，包括-5。
    它不释放本体，也不清零front/rear/max_len。 *)
Definition dataqueue_clean_id (id : Z) : Z := if Z.leb 0 id then -1 else id.
Definition dataqueue_cleaned (q : DataqueueObject) : DataqueueObject :=
  {| dq_capacity := q.(dq_capacity); dq_front := q.(dq_front);
     dq_rear := q.(dq_rear); dq_base := 0;
     dq_blank := dataqueue_clean_id q.(dq_blank);
     dq_data := dataqueue_clean_id q.(dq_data); dq_slots := [] |}.

(** 在非满分支写rear槽、推进rear；其他槽及所有其他字段保持。
    这是环更新本身，不包括先前 Obtain 或随后 Abandon 的信号量效果。 *)
Definition dataqueue_pushed (q : DataqueueObject) (e : DataqueueElem) : DataqueueObject :=
  {| dq_capacity := q.(dq_capacity); dq_front := q.(dq_front);
     dq_rear := (q.(dq_rear) + 1) mod q.(dq_capacity);
     dq_base := q.(dq_base); dq_blank := q.(dq_blank); dq_data := q.(dq_data);
     dq_slots := firstn (Z.to_nat q.(dq_rear)) q.(dq_slots) ++
       [Some e] ++ skipn (S (Z.to_nat q.(dq_rear))) q.(dq_slots) |}.

(** Pop 的非空分支只推进front，数组内存和值均保留；Peak不改变q。 *)
Definition dataqueue_popped (q : DataqueueObject) : DataqueueObject :=
  {| dq_capacity := q.(dq_capacity);
     dq_front := (q.(dq_front) + 1) mod q.(dq_capacity);
     dq_rear := q.(dq_rear); dq_base := q.(dq_base);
     dq_blank := q.(dq_blank); dq_data := q.(dq_data); dq_slots := q.(dq_slots) |}.
