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

(** 每个连续元素仅拥有data指针槽和length整数槽；None拥有未知值而非emp。
    8字节步长与32位DataElemType布局一致，不拥有data指向的payload。 *)
Definition dataqueue_slot (base index : Z) (entry : option DataqueueElem) : Assertion :=
  let p := base + index * 8 in
  match entry with
  | None => &(p # "DataElem" ->ₛ "data") # Ptr |->_ **
            &(p # "DataElem" ->ₛ "length") # UInt |->_
  | Some e => &(p # "DataElem" ->ₛ "data") # Ptr |-> e.(dq_data) **
              &(p # "DataElem" ->ₛ "length") # UInt |-> e.(dq_length)
  end.

(** base=0表示尚未分配或已回收，数组没有owner；否则拥有恰好n个元素。
    所有空闲/已pop槽仍在数组谓词中，不因缺少逻辑有效数据而丢失内存。 *)
Definition dataqueue_buffer (q : DataQueueAbs) : Assertion :=
  if Z.eq_dec q.(dq_base) 0 then “ q.(dq_slots) = nil ” && emp
  else “ 0 < q.(dq_max_len) /\ addr_aligned q.(dq_base) 4 ” &&
    store_array dataqueue_slot q.(dq_base) q.(dq_max_len) q.(dq_slots).

(** 完整对象内存；既用于私有的部分初始化/退役，也用于共享ready对象。
    sem_blank/sem_data只拥有ID字段，不拥有Semaphore的任何字节。 *)
Definition store_dataqueue (p : addr) (q : DataQueueAbs) : Assertion :=
  “ p <> 0 /\ addr_aligned p 4 ” &&
  dataqueue_fields p q ** dataqueue_buffer q.

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

Definition dataqueue_buffer_alloc_obligation : Prop := forall p n,
  0 < n <= 65535 -> p <> 0 -> addr_aligned p 4 -> dataqueue_layout ->
  CharArray.undef_full p (n*8) |--
    store_array dataqueue_slot p n (repeat None (Z.to_nat n)).
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

(** 数组读写共用的单槽拆合接口：复用QCP missing_i表示，其余槽和整个结构
    仍在同一断言中。Some槽拆出两个已知字段后可原样合回；不拥有payload。
    这是待证的等价陈述，不另建逐字段状态或假定split已获证明。 *)
Definition dataqueue_slot_view_obligation : Prop := forall p q i e,
  dataqueue_ready q -> 0 <= i < q.(dq_max_len) ->
  nth (Z.to_nat i) q.(dq_slots) None = Some e ->
  store_dataqueue p q --||--
    (“ p <> 0 /\ addr_aligned p 4 /\
       addr_aligned q.(dq_base) 4 ” &&
     dataqueue_fields p q ** dataqueue_slot q.(dq_base) i (Some e) **
     store_array_missing_i_rec dataqueue_slot q.(dq_base) i 0
       q.(dq_max_len) q.(dq_slots)).

(** ready的FIFO区间已初始化；front!=rear时front就是该区间首槽。
    Peak/Pop可据此取得data与length，纯陈述本身不提供字段访问权限。 *)
Definition dataqueue_nonempty_front_obligation : Prop := forall q,
  dataqueue_ready q -> q.(dq_front) <> q.(dq_rear) ->
  exists e, dataqueue_peak q = Some e.
