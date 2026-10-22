Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export TrialShared.CrtosRules TrialShared.idnode TrialShared.dll.
Require Export TrialShared.SemaphoreState TrialShared.NodeSelfLinked.
Import ListNotations DLL IDNode.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

(** 当前32位信号量对象的字段布局，按 LiteOS lib/memory.v 的组织方式，
    与使用这些布局的内存谓词放在同一文件。这里只描述字段地址，不提供
    内存所有权、分配来源或字段值。两个padding区间为[2,4)和[14,16)。 *)
Definition semaphore_byte_layout (p : addr) : Prop :=
  &(p # "Semaphore" ->ₛ "id") = p /\
  &(p # "IdNode" ->ₛ "id") = p /\
  &(p # "IdNode" ->ₛ "link") = p + 4 /\
  &(p # "Semaphore" ->ₛ "value") = p + 12 /\
  &(p # "Semaphore" ->ₛ "pend_list") = p + 16 /\
  &(p # "Semaphore" ->ₛ "link") = p + 24 /\
  forall off : Z, In off [4; 16; 24] ->
    let node := p + off in
    &(node # "SysDoubleLinklistNode" ->ₛ "node_next") = node /\
    &(node # "SysDoubleLinklistNode" ->ₛ "node_prev") = node + 4.

(** 显式ABI信任入口：用户于2026-10-22选择按LiteOS方式列出经核对的布局前提。
    checks/abi-current.json记录真实/切片头文件的GCC ILP32检查，并非ARM交叉编译
    或Rocq布局证明。没有增加sizeof公理；C切片使用已检查的常量32。
    字节到字段的资源转换另见 lib/SemaphoreByteLayout.v 中已证明的条件引理。 *)
Axiom semaphore_field_offsets_trusted :
  forall p, addr_aligned p 4 -> semaphore_byte_layout p.

(** NodeStorage 拥有两个未知指针槽，供 InitDoubleLinkList 覆写。 *)
Definition NodeStorage (p : addr) : Assertion :=
  “ p <> 0 ” &&
  &(p # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |->_ **
  &(p # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |->_.
Definition NodeZero (p : addr) : Assertion :=
  &(p # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> 0 **
  &(p # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> 0.
(** 底层插入切口：head.next与next.prev是不同字段，即使head=next也不重叠。
    未触达的head.prev与next.next留在调用者frame；新节点两槽必须完整。 *)
Definition DllInsertAfterCut (head next node oldprev oldnext : addr) : Assertion :=
  “ head <> 0 /\ next <> 0 /\ node <> 0 ” &&
  &(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next **
  &(next # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> head **
  &(node # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> oldprev **
  &(node # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> oldnext.
Definition DllInsertedCut (head next node : addr) : Assertion :=
  &(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> node **
  &(next # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> node **
  &(node # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> head **
  &(node # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next.
(** 私有 ID 子对象，仅十个具名字段字节；padding由SemaphorePadding持有。 *)
Definition ZeroIdNode (p : addr) : Assertion :=
  “ p <> 0 /\ &(p # "IdNode" ->ₛ "link") <> 0 ” &&
  &(p # "IdNode" ->ₛ "id") # UShort |-> 0 **
  NodeZero (&(p # "IdNode" ->ₛ "link")).
Definition AssignedIdNode (p id : Z) : Assertion :=
  “ p <> 0 /\ &(p # "IdNode" ->ₛ "link") <> 0 ” &&
  &(p # "IdNode" ->ₛ "id") # UShort |-> id **
  NodeZero (&(p # "IdNode" ->ₛ "link")).
(** 当前QCP struct_padding=emp，因此显式拥有ABI的[2,4)和[14,16)。 *)
Definition SemaphorePadding (p : addr) : Assertion :=
  CharArray.full (p+2) 2 (repeat_Z 0 2) **
  CharArray.full (p+14) 2 (repeat_Z 0 2).
(** 完整私有32字节对象的typed未知字段与padding所有权，可用于回收。
    x_malloc的VRTOS规约只交出字节数组；数组到本表示的转换须另行证明。
    本谓词不记录分配来源；x_free调用者仍须使用本次malloc返回的原基址。 *)
Definition SemaphoreRaw (p : addr) : Assertion :=
  “ p <> 0 /\ addr_aligned p 4 ” &&
  &(p # "Semaphore" ->ₛ "id" .ₛ "id") # UShort |->_ **
  NodeStorage (&(p # "Semaphore" ->ₛ "id" .ₛ "link")) **
  &(p # "Semaphore" ->ₛ "value") # UShort |->_ **
  NodeStorage (&(p # "Semaphore" ->ₛ "pend_list")) **
  NodeStorage (&(p # "Semaphore" ->ₛ "link")) **
  CharArray.undef_full (p+2) 2 ** CharArray.undef_full (p+14) 2.
(** memset零化且尚未发布的整个对象。VRTOS的ID失败后置会忘记ID节点值，
    因而失败后不能声称仍满足本谓词；回收使用完整未知值所有权SemaphoreRaw。 *)
Definition SemaphoreZero (p : addr) : Assertion :=
  “ p <> 0 /\ addr_aligned p 4 ” &&
  ZeroIdNode (&(p # "Semaphore" ->ₛ "id")) **
  &(p # "Semaphore" ->ₛ "value") # UShort |-> 0 **
  NodeZero (&(p # "Semaphore" ->ₛ "pend_list")) **
  NodeZero (&(p # "Semaphore" ->ₛ "link")) **
  SemaphorePadding p.
Definition semaphore_wait_node (task : addr) : DL_Node addr :=
  Build_DL_Node task (&(task # "TaskDescriptor" ->ₛ "sched_link")).
Definition semaphore_link_node (s : SemaphoreAbs) : DL_Node SemaphoreAbs :=
  let p := s.(semaphore_addr) in
  Build_DL_Node s (&(p # "Semaphore" ->ₛ "link")).
(** 发布后ID字段/ID link归manager、管理link归全局DLL；payload仅持有
    value、padding、pend_list及其中等待节点，等待任务字段由task_inv持有。 *)
Definition store_semaphore (wait : addr -> addr -> Assertion)
    (link : addr) (s : SemaphoreAbs) : Assertion :=
  let p := s.(semaphore_addr) in
  “ p <> 0 /\ addr_aligned p 4 /\ link = &(p # "Semaphore" ->ₛ "link") ” &&
  &(p # "Semaphore" ->ₛ "value") # UShort |-> s.(semaphore_value) **
  SemaphorePadding p **
  store_dll wait (&(p # "Semaphore" ->ₛ "pend_list"))
    (map semaphore_wait_node s.(semaphore_pending_addrs)).
(** 全模块共享内存：manager含bitmap/懒初始化桶/ID nodes；管理DLL含对象本体。
    done表已根据不可变dispatch等价归一为直接调用，无运行时table ownership。 *)
Definition semaphore_inv (wait : addr -> addr -> Assertion)
    (sg : SemaphoreStable) (st : SemaphoreState) : Assertion :=
  “ semaphore_context sg ” &&
  store_idmanager sg.(semaphore_manager_stable) (semaphore_manager st)
    sg.(semaphore_manager_ptr) **
  store_dll (store_semaphore wait) sg.(semaphore_list_head)
    (map semaphore_link_node st).

(** 编译时零初始化的私有全局内存，交接给协议前仍由启动代码持有。
    无新token；初始化义务是由此建立 semaphore_inv wait sg nil。 *)
Definition semaphore_initial_memory (sg : SemaphoreStable) : Assertion :=
  let sidm := sg.(semaphore_manager_stable) in
  let manager := sg.(semaphore_manager_ptr) in
  “ semaphore_context sg ” &&
  &(manager # "IdManager" ->ₛ "id_max") # UShort |-> 128 **
  &(manager # "IdManager" ->ₛ "hoffset") # UShort |-> 16 **
  &(manager # "IdManager" ->ₛ "id_map") # Ptr |-> sidm.(id_map) **
  &(manager # "IdManager" ->ₛ "htable") # Ptr |-> sidm.(htable) **
  UCharArray.full sidm.(id_map) 16 (repeat_Z 0 16) **
  PtrArray.full sidm.(htable) 32 (repeat_Z 0 32) **
  store_node_self_linked sg.(semaphore_list_head).

(** DLL调用处的实际首节点：空链返回哨兵，不假设next与head不同。 *)
Definition semaphore_first_link (sg : SemaphoreStable) (st : SemaphoreState) : addr :=
  match st with
  | nil => sg.(semaphore_list_head)
  | s :: _ => (semaphore_link_node s).(getPtr)
  end.
(** 懒桶经过Init之后，空桶首节点同样是自身哨兵；非空使用已有ID链接地址。 *)
Definition idbucket_first_link (sidm : StableIdmanager) (idm : VarIdmanager)
    (id : Z) : addr :=
  match Znth (id mod sidm.(hoffset)) idm.(idbuckets) nil with
  | nil => sidm.(htable) + (id mod sidm.(hoffset)) * sizeof("SysDoubleLinklistNode")
  | n :: _ => idnode_link n
  end.
