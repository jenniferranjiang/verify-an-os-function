Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem CNotation.
Require Export CRTOS_Verify.lib.common.CrtosRules.
Require Export CRTOS_Verify.lib.dataqueue.DataqueueState.
Import ListNotations KTaskCNotation.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope list.
Local Open Scope sac.

(** caller交出的20字节原始结构存储；没有仍需释放的旧base/信号量资源。
    该生命周期要求由调用约定说明，字节谓词本身不证明不存在泄漏。 *)
Definition DataqueueStorage (p : addr) : Assertion :=
  “ p <> 0 /\ addr_aligned p 4 ” && CharArray.undef_full p 20.

(** 本工程当前QCP struct_padding=emp；[6,8)是DataQueueType真实padding，
    只有这里拥有两字节，whole-struct memset/回收转换时不能丢弃。
    工具改为自动持有padding时须同步移除此显式残余，不可重复拥有。 *)
Definition dataqueue_fields (p : addr) (q : DataQueueAbs) : Assertion :=
  &(p # "DataQueue" ->ₛ "front") # UShort |-> q.(dq_front) **
  &(p # "DataQueue" ->ₛ "rear") # UShort |-> q.(dq_rear) **
  &(p # "DataQueue" ->ₛ "max_len") # UShort |-> q.(dq_max_len) **
  CharArray.undef_full (p+6) 2 **
  &(p # "DataQueue" ->ₛ "base") # Ptr |-> q.(dq_base) **
  &(p # "DataQueue" ->ₛ "sem_blank") # Int |-> q.(dq_sem_blank) **
  &(p # "DataQueue" ->ₛ "sem_data") # Int |-> q.(dq_sem_data).

(** 一个有效元素仅拥有data指针槽和length整数槽；不拥有payload。
    index是物理数组下标，8字节步长与当前32位DataElemType布局一致。 *)
Definition dataqueue_slot (base index : Z) (e : DataqueueElem) : Assertion :=
  let p := base + index * 8 in
  &(p # "DataElem" ->ₛ "data") # Ptr |-> e.(dq_data) **
  &(p # "DataElem" ->ₛ "length") # UInt |-> e.(dq_length).

(** 写入空闲槽只需要两个字段的写权限，不要求知道旧值。 *)
Definition dataqueue_empty_slot (base index : Z) : Assertion :=
  let p := base + index * 8 in
  &(p # "DataElem" ->ₛ "data") # Ptr |->_ **
  &(p # "DataElem" ->ₛ "length") # UInt |->_ .

(** 从p起的slots个连续DataElem槽：elements中的每个DataqueueElem占一个槽，
    直接复用dataqueue_slot描述data/length字段，不把单元素转换成列表。
    有效元素用尽后，余下槽保留全部字节的写权限，不约束旧值。
    调用处须保证0 <= Zlength elements <= slots；步长沿用当前32位ABI的8字节。 *)
Fixpoint store_dataqueue_segment (p : addr) (slots : Z)
    (elements : list DataqueueElem) : Assertion :=
  match elements with
  | nil => CharArray.undef_full p (slots * 8)
  | e :: rest =>
      dataqueue_slot p 0 e **
      store_dataqueue_segment (p + 8) (slots - 1) rest
  end.

(** 从front到数组末端最多容纳max_len-front个元素；FIFO前缀放高地址段，
    剩余后缀回绕到基址。firstn/skipn同时覆盖未环绕、恰到末端和已环绕。 *)
Definition dataqueue_split_at_end (q : DataQueueAbs) :=
  let cut := Z.to_nat (q.(dq_max_len) - q.(dq_front)) in
  (firstn cut q.(dq_slots), skipn cut q.(dq_slots)).

(** 已分配buffer的两段以内存中的front为界，分别存放FIFO后缀和前缀；
    每段空闲尾部由store_dataqueue_segment持有。ring_shape关联front/rear与
    有效元素数，保证分段容量并保留一个空槽；Pop只忘值，不清除C数组。
    此谓词只描述非空基址的数组；无buffer的生命周期状态在store_dataqueue描述。 *)
Definition dataqueue_buffer (q : DataQueueAbs) : Assertion :=
  let '(prefix, suffix) := dataqueue_split_at_end q in
  “ q.(dq_base) <> 0 /\ dataqueue_ring_shape q /\ addr_aligned q.(dq_base) 4 ” &&
  (store_dataqueue_segment q.(dq_base) q.(dq_front) suffix **
   store_dataqueue_segment (q.(dq_base) + q.(dq_front) * 8)
     (q.(dq_max_len) - q.(dq_front)) prefix).

(** 完整对象内存：本体字段始终存在；尚未分配或回收后base=0、逻辑内容为空，
    不拥有数组；base非零时由dataqueue_buffer拥有完整数组。
    保留私有初始化/退役及共享ready对象的统一接口，不另建buffer map。
    sem_blank/sem_data只拥有ID字段，不拥有Semaphore的任何字节。 *)
Definition store_dataqueue (p : addr) (q : DataQueueAbs) : Assertion :=
  “ p <> 0 /\ addr_aligned p 4 ” &&
  dataqueue_fields p q **
  ((“ q.(dq_base) = 0 /\ q.(dq_slots) = nil ” && emp) || dataqueue_buffer q).

(** map是已发布对象的唯一权威来源；lookup是纯事实，store_map拥有各key
    对应结构和数组。Semaphore只由原模块拥有，这里仅约束两个ID的关联。 *)
Definition dataqueue_inv (ss : SemaphoreState) (qs : DataqueueState) : Assertion :=
  “ forall p q, qs.(dataqueue_map) p = Some q ->
      dataqueue_ready q /\ dataqueue_semaphores ss q ” &&
  store_map store_dataqueue qs.(dataqueue_map).

(** ILP32布局事实的完整陈述；用户已授权以具体ABI公理接入。
    资源转换仍为待证义务，整结构padding保持在dataqueue_fields。 *)
Definition dataqueue_layout : Prop :=
  sizeof("DataQueue") = 20 /\ sizeof("DataElem") = 8 /\
  forall p,
  &(p # "DataQueue" ->ₛ "front") = p /\
  &(p # "DataQueue" ->ₛ "rear") = p+2 /\
  &(p # "DataQueue" ->ₛ "max_len") = p+4 /\
  &(p # "DataQueue" ->ₛ "base") = p+8 /\
  &(p # "DataQueue" ->ₛ "sem_blank") = p+12 /\
  &(p # "DataQueue" ->ₛ "sem_data") = p+16 /\
  &(p # "DataElem" ->ₛ "data") = p /\
  &(p # "DataElem" ->ₛ "length") = p+4.

(** 用户在2026-11-17继续验证对话中确认的具体ABI信任实例。
    当前dataqueue.h经gcc -m32静态断言核对：DataQueue大小20、DataElem大小8，
    二者对齐4，字段偏移与上面的dataqueue_layout一致。
    此公理仅连接不透明sizeof/字段地址与C ABI，不提供内存、生命周期、
    字节拆合、发布或任何函数行为保证；TrustBase文件保持用户维护。 *)
Axiom dataqueue_layout_abi : dataqueue_layout.

(** malloc得到的整块未知内存表示空FIFO，不生成公开的None槽列表。 *)
Definition dataqueue_buffer_alloc_obligation : Prop := forall q,
  q.(dq_base) <> 0 -> addr_aligned q.(dq_base) 4 ->
  dataqueue_ring_shape q -> q.(dq_slots) = nil -> dataqueue_layout ->
  CharArray.undef_full q.(dq_base) (q.(dq_max_len)*8) |-- dataqueue_buffer q.
Definition dataqueue_zero_obligation : Prop := forall p,
  p <> 0 -> addr_aligned p 4 -> dataqueue_layout ->
  CharArray.full p 20 (repeat_Z 0 20) |-- store_dataqueue p dataqueue_zero.
Definition dataqueue_buffer_free_obligation : Prop := forall q,
  q.(dq_base) <> 0 -> dataqueue_layout ->
  dataqueue_buffer q |-- CharArray.undef_full q.(dq_base) (q.(dq_max_len)*8).
Definition dataqueue_retired_storage_obligation : Prop := forall p q,
  dataqueue_layout ->
  store_dataqueue p (dataqueue_retired q) |-- DataqueueStorage p.

(** lookup后借出唯一对象，余下map资源不含该key；更新时恢复新value。
    复用QCP的store_map_missing_i，以下仍为待证明的模块接口。 *)
Definition dataqueue_split_obligation : Prop := forall ss qs p q,
  qs.(dataqueue_map) p = Some q ->
  dataqueue_inv ss qs |--
    “ forall key v, qs.(dataqueue_map) key = Some v ->
        dataqueue_ready v /\ dataqueue_semaphores ss v ” &&
    store_map_missing_i store_dataqueue qs.(dataqueue_map) p ** store_dataqueue p q.
Definition dataqueue_merge_obligation : Prop := forall ss qs p q,
  (forall key v, key <> p -> qs.(dataqueue_map) key = Some v ->
    dataqueue_ready v /\ dataqueue_semaphores ss v) ->
  dataqueue_ready q -> dataqueue_semaphores ss q ->
  store_map_missing_i store_dataqueue qs.(dataqueue_map) p ** store_dataqueue p q |--
    dataqueue_inv ss (dataqueue_publish p q qs).

(** 本模块没有静态根或初始化token；空模块贡献emp。其他模块仍由原os_inv初始化。 *)
Definition dataqueue_initial_obligation : Prop := forall ss,
  dataqueue_inv ss dataqueue_initial --||-- emp.

(** 只读队首时借出有效元素，归还后恢复原buffer。公开条件只谈FIFO队首，
    不让调用者用物理下标查询dq_slots。以下为待证接口，不是已证lemma。 *)
Definition dataqueue_slot_view_obligation : Prop := forall q e rest,
  dataqueue_ready q -> q.(dq_slots) = e :: rest ->
  dataqueue_buffer q |--
    dataqueue_slot q.(dq_base) q.(dq_front) e **
    (dataqueue_slot q.(dq_base) q.(dq_front) e -* dataqueue_buffer q).

(** 出队只忘掉原队首槽的值，仍保留全部数组内存；新的逻辑内容为rest。
    字段front的实际写入由调用处处理，此处只转换数组表示。 *)
Definition dataqueue_pop_buffer_obligation : Prop := forall q e rest,
  dataqueue_ready q -> q.(dq_slots) = e :: rest -> dataqueue_layout ->
  dataqueue_buffer q |-- dataqueue_buffer (dataqueue_pop q).

(** 入队借出rear空闲槽，写入e后恢复内容为dq_slots++[e]的buffer。 *)
Definition dataqueue_push_buffer_obligation : Prop := forall q e,
  dataqueue_ready q -> dataqueue_count q < q.(dq_max_len)-1 -> dataqueue_layout ->
  dataqueue_buffer q |--
    dataqueue_empty_slot q.(dq_base) q.(dq_rear) **
    (dataqueue_slot q.(dq_base) q.(dq_rear) e -*
      dataqueue_buffer (dataqueue_push q e)).

(** ready连接物理front/rear与FIFO长度；非空分支取得逻辑队首。 *)
Definition dataqueue_nonempty_front_obligation : Prop := forall q,
  dataqueue_ready q -> q.(dq_front) <> q.(dq_rear) ->
  exists e rest, q.(dq_slots) = e :: rest /\ dataqueue_peak q = Some e.
