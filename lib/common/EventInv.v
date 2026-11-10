Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.common.CrtosRules CRTOS_Verify.lib.id.idnode CRTOS_Verify.lib.common.dll.
Require Export CRTOS_Verify.lib.event.EventState CRTOS_Verify.lib.list.NodeSelfLinked.
Require Export CRTOS_Verify.lib.common.ObjectWaitNode.
Require Import CRTOS_Verify.lib.common.SemaphoreInv.
Import ListNotations DLL IDNode.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

(** TrustBase 允许位域展开为普通 uint32；适配布局为36字节，真实位域ABI
    为32字节。本常量只用于切片模型的字节资源，不能解释真实位域内存。 *)
Definition EVENT_MEM_SIZE : Z := 36.

(** 展开位域后的 ILP32 地址关系。这里只定义待核对条件，不声明公理；
    后续字节转换必须显式使用经布局检查支持的条件。ID padding 为[2,4)。 *)
Definition event_byte_layout (p : addr) : Prop :=
  &(p # "Event" ->ₛ "id") = p /\
  &(p # "IdNode" ->ₛ "id") = p /\
  &(p # "IdNode" ->ₛ "link") = p + 4 /\
  &(p # "Event" ->ₛ "options") = p + 12 /\
  &(p # "Event" ->ₛ "events") = p + 16 /\
  &(p # "Event" ->ₛ "pend_list") = p + 20 /\
  &(p # "Event" ->ₛ "link") = p + 28 /\
  forall off : Z, In off [4; 20; 28] ->
    let node := p + off in
    &(node # "SysDoubleLinklistNode" ->ₛ "node_next") = node /\
    &(node # "SysDoubleLinklistNode" ->ₛ "node_prev") = node + 4.

(** QCP struct_padding 当前为空资源，显式保留 memset 清零的 ID padding。 *)
Definition EventPadding (p : addr) : Assertion :=
  CharArray.full (p+2) 2 (repeat_Z 0 2).

(** 私有完整未知值对象，供 ID 插入失败后的回收；ID字段/link未发布时
    由本谓词唯一拥有。分配来源由真实 malloc/free 数据流保证，非此谓词。 *)
Definition EventRaw (p : addr) : Assertion :=
  “ p <> 0 /\ addr_aligned p 4 ” &&
  store_idnode_insert_ready (&(p # "Event" ->ₛ "id")) **
  &(p # "Event" ->ₛ "options") # UInt |->_ **
  &(p # "Event" ->ₛ "events") # UInt |->_ **
  NodeStorage (&(p # "Event" ->ₛ "pend_list")) **
  NodeStorage (&(p # "Event" ->ₛ "link")) **
  CharArray.undef_full (p+2) 2.

(** memset 后尚未登记的完整对象；所有36模型字节恰好由本谓词拥有。
    IdInsertObj 失败只归还未知 ID 字段，不能在失败回收时继续声称全零。 *)
Definition EventZero (p : addr) : Assertion :=
  “ p <> 0 /\ addr_aligned p 4 ” &&
  ZeroIdNode (&(p # "Event" ->ₛ "id")) **
  &(p # "Event" ->ₛ "options") # UInt |-> 0 **
  &(p # "Event" ->ₛ "events") # UInt |-> 0 **
  NodeZero (&(p # "Event" ->ₛ "pend_list")) **
  NodeZero (&(p # "Event" ->ₛ "link")) ** EventPadding p.

Definition event_wait_node (owner : addr) : DL_Node addr :=
  Build_DL_Node owner (object_wait_link_of owner).
Definition event_link_node (e : EventAbs) : DL_Node EventAbs :=
  let p := e.(event_addr) in
  Build_DL_Node e (&(p # "Event" ->ₛ "link")).

(** 已发布 payload 拥有 options/events 两个模型字、padding、等待哨兵和
    等待 owner 的嵌入 link；ID字段/link归manager，管理link归全局DLL。
    保留真实位域取值范围；wait payload 由调用者选择。 *)
Definition store_event (wait : addr -> addr -> Assertion)
    (link : addr) (e : EventAbs) : Assertion :=
  let p := e.(event_addr) in
  “ p <> 0 /\ addr_aligned p 4 /\ link = &(p # "Event" ->ₛ "link") /\
    0 <= e.(event_options) < 8 /\ 0 <= e.(event_events) < 536870912 ” &&
  &(p # "Event" ->ₛ "options") # UInt |-> e.(event_options) **
  &(p # "Event" ->ₛ "events") # UInt |-> e.(event_events) **
  EventPadding p **
  store_dll wait (&(p # "Event" ->ₛ "pend_list"))
    (map event_wait_node e.(event_pending_addrs)).

(** 事件模块的完整共享资源：ID manager唯一持有bitmap、懒桶和ID节点；
    管理 DLL 持有管理 link 及 payload。 *)
Definition event_inv (wait : addr -> addr -> Assertion)
    (sg : EventStable) (st : EventState) : Assertion :=
  “ event_context sg ” &&
  store_idmanager sg.(event_manager_stable) (event_manager st)
    sg.(event_manager_ptr) **
  store_dll (store_event wait) sg.(event_list_head) (map event_link_node st).

(** 编译期静态初始化的原始资源，尚未交给临界区协议；不引入初始化token。
    BSS bitmap和16个连续桶为零，管理哨兵自环。 *)
Definition event_initial_memory (sg : EventStable) : Assertion :=
  let sidm := sg.(event_manager_stable) in
  let manager := sg.(event_manager_ptr) in
  “ event_context sg ” &&
  &(manager # "IdManager" ->ₛ "id_max") # UShort |-> 128 **
  &(manager # "IdManager" ->ₛ "hoffset") # UShort |-> 16 **
  &(manager # "IdManager" ->ₛ "id_map") # Ptr |-> sidm.(id_map) **
  &(manager # "IdManager" ->ₛ "htable") # Ptr |-> sidm.(htable) **
  UCharArray.full sidm.(id_map) 16 (repeat_Z 0 16) **
  PtrArray.full sidm.(htable) 32 (repeat_Z 0 32) **
  store_node_self_linked sg.(event_list_head).

(** ID 注销且管理 link 摘除后独占的完整 Event 对象。ID 已写成65535，
    ID link、pending 哨兵和管理 link 都自环；options/events/padding 保持。
    资源不再归 event_inv，允许跨解锁携带至 x_free；p 必须是原分配基址。
    不拥有任何已摘除 owner 的嵌入 link 或其他字段。 *)
Definition EventRetired (p options events : Z) : Assertion :=
  “ p <> 0 /\ addr_aligned p 4 /\
    &(p # "Event" ->ₛ "id" .ₛ "link") <> 0 /\
    &(p # "Event" ->ₛ "pend_list") <> 0 /\
    &(p # "Event" ->ₛ "link") <> 0 /\
    0 <= options < 8 /\ 0 <= events < 536870912 ” &&
  store_idnode (&(p # "Event" ->ₛ "id" .ₛ "link"))
    (Build_IdNodeAbs 65535 (&(p # "Event" ->ₛ "id"))) **
  store_node_self_linked (&(p # "Event" ->ₛ "id" .ₛ "link")) **
  &(p # "Event" ->ₛ "options") # UInt |-> options **
  &(p # "Event" ->ₛ "events") # UInt |-> events **
  store_node_self_linked (&(p # "Event" ->ₛ "pend_list")) **
  store_node_self_linked (&(p # "Event" ->ₛ "link")) ** EventPadding p.

(** 以下仅是类型检查过的待证陈述，不是公理或已证明结论。
    字节转换显式依赖模型布局；后续实现阶段须完成转换证明。 *)
Definition event_zero_bytes_obligation : Prop :=
  forall p, event_byte_layout p ->
  0 < p -> p <= 4294967295 - EVENT_MEM_SIZE -> addr_aligned p 4 ->
  CharArray.full p EVENT_MEM_SIZE (repeat_Z 0 EVENT_MEM_SIZE) |--
  “ &(p # "Event" ->ₛ "pend_list") <> 0 /\
     &(p # "Event" ->ₛ "link") <> 0 ” && EventZero p.
Definition event_reclaim_bytes_obligation : Prop :=
  forall p, event_byte_layout p ->
  EventRaw p |-- CharArray.undef_full p EVENT_MEM_SIZE.
Definition event_initialization_obligation : Prop :=
  forall wait sg,
    event_initial_memory sg |-- event_inv wait sg event_initial.

(** 删除回收桥仅是待证命题，不是已证明事实。遗忘字段值后恰好覆盖
    EventRaw；其后再使用已有36模型字节重组义务交给可信 x_free。 *)
Definition event_retired_raw_obligation : Prop :=
  forall p options events,
    EventRetired p options events |-- EventRaw p.
