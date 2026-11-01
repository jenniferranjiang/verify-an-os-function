Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export KMutexCreateTrial.lib.CrtosRules KMutexCreateTrial.lib.idnode KMutexCreateTrial.lib.dll.
Require Export KMutexCreateTrial.lib.MutexState KMutexCreateTrial.lib.NodeSelfLinked.
Require Import KMutexCreateTrial.lib.SemaphoreInv.
Import ListNotations DLL IDNode.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

(** 当前 QCP struct_padding 不提供字节资源；Mutex 唯一 padding 是 ID 的 [2,4)。
    memset 后其值保持零，回收时与具名字段一起覆盖完整36字节。 *)
Definition MutexPadding (p : addr) : Assertion :=
  CharArray.full (p+2) 2 (repeat_Z 0 2).

(** 私有完整对象的未知字段表示，含 ID 和两个独立链节点及 padding。
    此谓词不证明分配来源；x_free 仍须使用本次 malloc 的原始基址。
    NodeStorage/ZeroIdNode 直接复用现有通用槽表示，不重定义同义谓词。 *)
Definition MutexRaw (p : addr) : Assertion :=
  “ p <> 0 /\ addr_aligned p 4 ” &&
  store_idnode_insert_ready (&(p # "Mutex" ->ₛ "id")) **
  &(p # "Mutex" ->ₛ "val") # UShort |->_ **
  &(p # "Mutex" ->ₛ "recursive_cnt") # UChar |->_ **
  &(p # "Mutex" ->ₛ "origin_prio") # UChar |->_ **
  &(p # "Mutex" ->ₛ "holder") # Ptr |->_ **
  NodeStorage (&(p # "Mutex" ->ₛ "pend_list")) **
  NodeStorage (&(p # "Mutex" ->ₛ "link")) **
  CharArray.undef_full (p+2) 2.

(** memset 后尚未登记 ID 的私有对象；所有36字节均被唯一拥有。
    ID 插入失败会忘记 ID 节点值，故失败回收用 MutexRaw 而非声称仍全零。 *)
Definition MutexZero (p : addr) : Assertion :=
  “ p <> 0 /\ addr_aligned p 4 ” &&
  ZeroIdNode (&(p # "Mutex" ->ₛ "id")) **
  &(p # "Mutex" ->ₛ "val") # UShort |-> 0 **
  &(p # "Mutex" ->ₛ "recursive_cnt") # UChar |-> 0 **
  &(p # "Mutex" ->ₛ "origin_prio") # UChar |-> 0 **
  &(p # "Mutex" ->ₛ "holder") # Ptr |-> 0 **
  NodeZero (&(p # "Mutex" ->ₛ "pend_list")) **
  NodeZero (&(p # "Mutex" ->ₛ "link")) ** MutexPadding p.

Definition mutex_wait_node (task : addr) : DL_Node addr :=
  Build_DL_Node task (sched_link_of task).
Definition mutex_link_node (m : MutexAbs) : DL_Node MutexAbs :=
  let p := m.(mutex_addr) in
  Build_DL_Node m (&(p # "Mutex" ->ₛ "link")).

(** 已发布对象的 payload：ID字段与ID link归manager，管理link归全局DLL；
    这里拥有四个值字段、padding、等待链哨兵及等待任务的 sched_link。
    wait 参数只提供任务关联，不转移或复制 TaskDescriptor 字段。 *)
Definition store_mutex (wait : addr -> addr -> Assertion)
    (link : addr) (m : MutexAbs) : Assertion :=
  let p := m.(mutex_addr) in
  “ p <> 0 /\ addr_aligned p 4 /\ link = &(p # "Mutex" ->ₛ "link") ” &&
  &(p # "Mutex" ->ₛ "val") # UShort |-> m.(mutex_value) **
  &(p # "Mutex" ->ₛ "recursive_cnt") # UChar |-> m.(mutex_recursive_count) **
  &(p # "Mutex" ->ₛ "origin_prio") # UChar |-> m.(mutex_original_priority) **
  &(p # "Mutex" ->ₛ "holder") # Ptr |-> m.(mutex_holder) **
  MutexPadding p **
  store_dll wait (&(p # "Mutex" ->ₛ "pend_list"))
    (map mutex_wait_node m.(mutex_pending_addrs)).

(** 完整互斥量模块：manager唯一拥有位图、懒初始化桶及ID节点；管理DLL
    唯一拥有管理链节点及对象payload。等待任务本体由全局 task_inv 持有。 *)
Definition mutex_inv (wait : addr -> addr -> Assertion)
    (sg : MutexStable) (st : MutexState) : Assertion :=
  “ mutex_context sg ” &&
  store_idmanager sg.(mutex_manager_stable) (mutex_manager st)
    sg.(mutex_manager_ptr) **
  store_dll (store_mutex wait) sg.(mutex_list_head)
    (map mutex_link_node st).

(** 编译期静态初始化提供的全局私有内存；交给系统协议前由启动代码持有。
    不引入初始化 token；从这里建立 mutex_inv wait sg nil 的蕴含待后续证明。 *)
Definition mutex_initial_memory (sg : MutexStable) : Assertion :=
  let sidm := sg.(mutex_manager_stable) in
  let manager := sg.(mutex_manager_ptr) in
  “ mutex_context sg ” &&
  &(manager # "IdManager" ->ₛ "id_max") # UShort |-> 128 **
  &(manager # "IdManager" ->ₛ "hoffset") # UShort |-> 16 **
  &(manager # "IdManager" ->ₛ "id_map") # Ptr |-> sidm.(id_map) **
  &(manager # "IdManager" ->ₛ "htable") # Ptr |-> sidm.(htable) **
  UCharArray.full sidm.(id_map) 16 (repeat_Z 0 16) **
  PtrArray.full sidm.(htable) 32 (repeat_Z 0 32) **
  store_node_self_linked sg.(mutex_list_head).

(** 待证义务的类型化陈述：不是公理、lemma 或已证明结果；本轮只编译这些
    Prop 定义。转换使用共享库已存在的 mutex_field_offset_ok/size 布局依据。 *)
Definition mutex_zero_bytes_obligation : Prop :=
  forall p, mutex_field_offset_ok p ->
  0 < p -> p <= 4294967295 - MUTEX_MEM_SIZE -> addr_aligned p 4 ->
  CharArray.full p MUTEX_MEM_SIZE (repeat_Z 0 MUTEX_MEM_SIZE) |--
  “ &(p # "Mutex" ->ₛ "pend_list") <> 0 /\
     &(p # "Mutex" ->ₛ "link") <> 0 ” && MutexZero p.
Definition mutex_reclaim_bytes_obligation : Prop :=
  forall p, mutex_field_offset_ok p ->
  MutexRaw p |-- CharArray.undef_full p MUTEX_MEM_SIZE.
Definition mutex_initialization_obligation : Prop :=
  forall wait sg,
    mutex_initial_memory sg |-- mutex_inv wait sg mutex_initial.
