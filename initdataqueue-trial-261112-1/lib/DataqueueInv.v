Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export InitDataqueueTrial.lib.CrtosRules InitDataqueueTrial.lib.DataqueueState.
Import ListNotations.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

(** DataElemType连续数组中的一个元素，data只借用外部payload地址，不拥有
    其指向的数据。None表示malloc后尚未写入的两个字段。 *)
Definition store_dataqueue_elem (base : addr) (index : Z)
    (v : option DataElemAbs) : Assertion :=
  let p := base + index * 8 in
  match v with
  | None => CharArray.undef_full p 8
  | Some e =>
      &(p # "DataElemType" ->ₛ "data") # Ptr |-> e.(dq_elem_data) **
      &(p # "DataElemType" ->ₛ "length") # UInt |-> e.(dq_elem_length)
  end.

(** 原始对象存储为20字节，供整对象memset写入；不假定旧值为零，不拥有
    旧指针的pointee。调用初始化必须对这块内存具有独占权限。 *)
Definition DataqueueRaw (p : addr) : Assertion :=
  “ p <> 0 /\ addr_aligned p 4 ” && CharArray.undef_full p 20.

(** 结构体字段的唯一owner；QCP结构体机制管理padding，下面的字节转换
    义务需保留[6,8)的资源，不能凭字段ownership就声称拥有整个20字节。 *)
Definition dataqueue_field_values (p : addr) (q : DataqueueAbs) : Assertion :=
  “ p <> 0 /\ addr_aligned p 4 ” &&
  &(p # "DataQueueType" ->ₛ "front") # UShort |-> q.(dq_front) **
  &(p # "DataQueueType" ->ₛ "rear") # UShort |-> q.(dq_rear) **
  &(p # "DataQueueType" ->ₛ "max_len") # UShort |-> q.(dq_max_len) **
  &(p # "DataQueueType" ->ₛ "base") # Ptr |-> q.(dq_base) **
  &(p # "DataQueueType" ->ₛ "sem_blank") # Int |-> q.(dq_blank) **
  &(p # "DataQueueType" ->ₛ "sem_data") # Int |-> q.(dq_data).

(** 整个20字节的唯一ownership和typed字段view用普通合取关联同一个heap。
    fields ** TT允许字段view之外的两字节剩余；它不是第二份分离权限，
    不手工添加与QCP自动结构资源重复的padding。整对象memset及free可从
    左侧字节资源得到，读写字段使用右侧view，更新后须保留rest并重组。 *)
Definition store_dataqueue_fields (p : addr) (q : DataqueueAbs) : Assertion :=
  DataqueueRaw p && (dataqueue_field_values p q ** TT).

(** 数组是连续元素本体；只拥有队列数组，不递归拥有元素data指向的payload。
    初始化返回的slots全为None；运行时Push/Pop可以用Some记录已写入字段。
    base=0时不拥有数组，长度仍由C保留，不强制清零max_len。 *)
Definition dataqueue_buffer (q : DataqueueAbs)
    (slots : list (option DataElemAbs)) : Assertion :=
  if Z.eq_dec q.(dq_base) 0 then “ slots = nil ” && emp
  else “ Z.of_nat (List.length slots) = q.(dq_max_len) ” &&
    store_array store_dataqueue_elem q.(dq_base) q.(dq_max_len) slots.

(** 对象本体与buffer分离归属，信号量共享资源不在此重复组合。发布前由初始化者私有持有；成功后由dataqueue_inv中的map唯一持有。
    模块函数须通过共享os_inv借出对象，不能仅凭知道ID取得其内存。 *)
Definition dataqueue_storage (p : addr) (q : DataqueueAbs)
    (slots : list (option DataElemAbs)) : Assertion :=
  store_dataqueue_fields p q ** dataqueue_buffer q slots.


(** 共享map的元素owner；它拥有对象整个20字节和数组，信号量对象只由
    semaphore_inv持有。没有永久强制sem存在或count=环长度，故通用信号量
    删除及等待/abandon的中间阶段不被本模块不变量错误禁止。 *)
Definition store_published_dataqueue (p : addr) (o : PublishedDataqueue) : Assertion :=
  dataqueue_storage p o.(published_queue) o.(published_slots).

(** 模块全局资源通过既有store_map管理非连续对象；finite-domain和地址
    唯一性由该通用谓词提供，不手写第二套map或重复NoDup条件。
    normal运行front/rear与slots由上述状态完整保存，Retiring可暂有base=0。
    与其他模块的互斥由os_inv中的分离组合保证。 *)
Definition dataqueue_inv (st : DataqueueState) : Assertion :=
  “ dataqueue_valid st ” && store_map store_published_dataqueue st.

(** map拆出与重组均直接使用已有通用接口；以下仅保存本轮需要证明的
    生命周期资源交接命题，不是已证事实。 *)
Definition dataqueue_publish_obligation : Prop :=
  forall st p o, st p = None -> dataqueue_object_valid o ->
    dataqueue_inv st ** store_published_dataqueue p o |--
    dataqueue_inv (dataqueue_replace p (Some o) st).
Definition dataqueue_withdraw_obligation : Prop :=
  forall st p o, st p = Some o ->
    dataqueue_inv st |--
    dataqueue_inv (dataqueue_withdraw p st) ** store_published_dataqueue p o.

(** 启动时没有已发布queue，所以模块部分初始为空heap；第一次成功Init
    才转入外部提供的对象和新数组。没有虚构静态queue全局地址或额外token。 *)
Definition dataqueue_initial_inv_obligation : Prop :=
  emp |-- dataqueue_inv dataqueue_initial.

(** 读取Pop/Peak或写入Push元素时直接复用通用array missing-index接口，
    只拆目标元素，保留其余槽；Some提供data/length的已知typed字段。
    下列成对命题为待证接口，不自行新造array representation。 *)
Definition dataqueue_slot_split_obligation : Prop :=
  forall q slots i e,
    q.(dq_base) <> 0 -> 0 <= i < q.(dq_max_len) ->
    nth (Z.to_nat i) slots None = Some e ->
    dataqueue_buffer q slots |--
    store_array_missing_i_rec store_dataqueue_elem q.(dq_base) i 0 q.(dq_max_len) slots **
    store_dataqueue_elem q.(dq_base) i (Some e).
Definition dataqueue_slot_merge_obligation : Prop :=
  forall q slots i value,
    q.(dq_base) <> 0 -> 0 <= i < q.(dq_max_len) ->
    Z.of_nat (List.length slots) = q.(dq_max_len) ->
    nth (Z.to_nat i) slots None = value ->
    store_array_missing_i_rec store_dataqueue_elem q.(dq_base) i 0 q.(dq_max_len) slots **
    store_dataqueue_elem q.(dq_base) i value |-- dataqueue_buffer q slots.
