From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
Require Import CRTOS_Verify.lib.idnode CRTOS_Verify.lib.dll.
Require Import CRTOS_Verify.sem.SemaphorePure.
Import ListNotations DLL IDNode.
Import CRTOS_Verify.lib.CrtosRules.Task_C_Rules.
Local Open Scope Z_scope.
Local Open Scope string_scope.
Local Open Scope sac.

(** 本文件仍在共享 heap carrier 上组合表示，供统一 OS carrier 的 heap lift
    复用。没有 STS token；任何模块 heap 都只拥有内存，协议另在 Critical 层。 *)

(** 完整分配对象的子对象地址 metadata。它只描述真实 Semaphore 对象中的
    id、id.link、pend_list、link 本体地址，不拥有字节，也不是已证明的
    eval_addr_expr ABI 等式。候选的 trusted/static 来源闭合尚待审阅。 *)
Definition semaphore_object_addresses (p : addr) : Prop :=
  let idp : addr := &(p # "Semaphore" ->ₛ "id") in
  p <> 0 /\
  &(p # "Semaphore" ->ₛ "id") <> 0 /\
  &(idp # "IdNode" ->ₛ "link") <> 0 /\
  &(p # "Semaphore" ->ₛ "pend_list") <> 0 /\
  &(p # "Semaphore" ->ₛ "link") <> 0.

(** Cortex-M3 ILP32 的 Semaphore 为32字节；分配返回完整未初始化块。
    零化契约随后交出字段与 padding 的精确分解。 *)
Definition store_sem_allocated (p : addr) : Assertion :=
  “ semaphore_object_addresses p ” && CharArray.undef_full p 32.

(** ID node 尚未挂桶时，id 和两个 link 指针由私有对象所有。
    同时保存真实 IdNode 与嵌入 link 的非零地址；不由字段有效范围推导。
    参数保留原值，IdInsertObj 失败必须原样返回，不可退化成 undef。 *)
Definition store_sem_id_detached (p : addr) (id prev next : Z) : Assertion :=
  “ p <> 0 /\ &(p # "IdNode" ->ₛ "link") <> 0 ” &&
  &(p # "IdNode" ->ₛ "id") # UShort |-> id **
  &(p # "IdNode" ->ₛ "link" .ₛ "node_prev") # Ptr |-> prev **
  &(p # "IdNode" ->ₛ "link" .ₛ "node_next") # Ptr |-> next.

(** 私有 detached 双链表节点的两个槽，无 DLL membership 假设。用于刚清零
    的 pend/list link，以及删除后返还的自环 link。节点地址非零随对象生命周期保持。 *)
Definition store_sem_link_detached (p prev next : addr) : Assertion :=
  “ p <> 0 ” &&
  &(p # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> prev **
  &(p # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next.

(** 真实32-byte布局的两个2-byte padding，分别位于 id.id 后与 value 后。
    QCP 当前 CommonAssertion.struct_padding 定义为 emp，没有物理 byte owner；
    这里显式拥有这4字节以满足 malloc/memset/free 整块 ownership。
    不与字段资源或 ID bucket 所有的 id/link 字段重叠。 *)
Definition store_sem_padding (p : addr) : Assertion :=
  CharArray.full (p + 2) 2 [0;0] ** CharArray.full (p + 14) 2 [0;0].

(** 已清零、未发布的完整私有对象。三个嵌入节点都尚未交给容器。
    字段偏移为 id=0,value=12,pend_list=16,link=24。 *)
Definition store_sem_zeroed_private (p : addr) : Assertion :=
  “ semaphore_object_addresses p ” &&
  store_sem_id_detached (&(p # "Semaphore" ->ₛ "id")) 0 0 0 **
  &(p # "Semaphore" ->ₛ "value") # UShort |-> 0 **
  store_sem_link_detached (&(p # "Semaphore" ->ₛ "pend_list")) 0 0 **
  store_sem_link_detached (&(p # "Semaphore" ->ₛ "link")) 0 0 **
  store_sem_padding p.

(** ID 已交给 manager，但 semaphore 尚未加入 k_sem_list 的私有余部。
    本谓词故意不再拥有 id.id 或 id.link；padding仍随对象本体。 *)
Definition store_sem_registered_private (p : addr) : Assertion :=
  “ semaphore_object_addresses p ” &&
  &(p # "Semaphore" ->ₛ "value") # UShort |-> 0 **
  store_sem_link_detached (&(p # "Semaphore" ->ₛ "pend_list")) 0 0 **
  store_sem_link_detached (&(p # "Semaphore" ->ₛ "link")) 0 0 **
  store_sem_padding p.

(** 已发布对象本体拥有 value、padding、pend_list 头及等待任务的 sched_link。
    等待任务仅借出这个嵌入节点；其 exstatus、优先级、栈等仍属于 task 模块。
    完整 id 节点由 ID manager 所有，sem.link 由 registry 所有。 *)
Definition store_semaphore_body (obj : SemaphoreObject) : Assertion :=
  let p := obj.(semaphore_addr) in
  &(p # "Semaphore" ->ₛ "value") # UShort |-> obj.(semaphore_value) **
  store_sem_padding p **
  store_dll (fun _ _ => emp) (&(p # "Semaphore" ->ₛ "pend_list"))
    (map semaphore_pending_node obj.(semaphore_pending_addrs)).

(** registry 以真实 struct 内嵌 link 为 spine，payload 只拥有对象本体。
    对象不是连续数组，链表 spine 依次交出每个分配对象的本体资源。 *)
Definition store_sem_registry (sg : SemaphoreStable) (objects : SemaphoreState)
    : Assertion :=
  store_dll (fun _ obj => store_semaphore_body obj) sg.(semaphore_registry_addr)
    (map (fun obj => let p := obj.(semaphore_addr) in
      Build_DL_Node obj (&(p # "Semaphore" ->ₛ "link"))) objects).

(** 直接复用正式 ID manager：覆盖 manager 的四字段、16-byte bitmap、
    16 个连续 bucket heads、每个已发布 sem.id 的值及 link。
    空桶允许 BSS(0,0) 或已初始化空自环，复用根 store_idbucket 的真实两种形态。 *)
Definition store_sem_manager (sg : SemaphoreStable) (objects : SemaphoreState)
    : Assertion :=
  store_idmanager sg.(semaphore_manager_abs)
    (semaphore_manager_state sg objects) sg.(semaphore_manager_addr).

(** 完整 semaphore 模块的稳定内存：manager/container 与 registry/body
    分离；每个对象的32字节恰由 id manager、registry、本体三者分割。 *)
Definition store_semaphore (sg : SemaphoreStable) (objects : SemaphoreState)
    : Assertion :=
  “ semaphore_valid objects ” &&
  store_sem_manager sg objects ** store_sem_registry sg objects.

(** DECLARE_ID_MANAGER 静态数组中一个尚未触碰的元素：只列两个零槽。
    真实数组对象的地址有效性由 static_initial 单独携带，不能从槽值推导。 *)
Definition store_sem_static_bucket_at (base index : addr) (_ : unit) : Assertion :=
  let head := base + index * sizeof("SysDoubleLinklistNode") in
  &(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> 0 **
  &(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> 0.

(** 来自 xs_id.h 声明宏及 semaphore.c initializer 的原始静态对象资源。
    地址 metadata 对应实际16元素数组的各元素与 k_sem_list 本体；它来自
    C 静态对象有效性，不是下列零槽的推论，也不引入新的初始化token。
    下层只拥有 raw 字段，SemaphoreInitialization 的构造引理把它们组合为
    已修订的 manager/registry invariant，覆盖所有16个桶。 *)
Definition store_semaphore_static_initial (sg : SemaphoreStable) : Assertion :=
  let manager := sg.(semaphore_manager_addr) in
  let table := sg.(semaphore_manager_abs).(htable) in
  let registry := sg.(semaphore_registry_addr) in
  “ registry <> 0 /\
    (forall index, 0 <= index < 16 ->
       table + index * sizeof("SysDoubleLinklistNode") <> 0) ” &&
  &(manager # "IdManager" ->ₛ "id_max") # UShort |-> 128 **
  &(manager # "IdManager" ->ₛ "hoffset") # UShort |-> 16 **
  &(manager # "IdManager" ->ₛ "id_map") # Ptr
    |-> sg.(semaphore_manager_abs).(id_map) **
  &(manager # "IdManager" ->ₛ "htable") # Ptr |-> table **
  UCharArray.full sg.(semaphore_manager_abs).(id_map) 16 (repeat 0 16) **
  store_array store_sem_static_bucket_at table 16 (repeat tt 16) **
  &(registry # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> registry **
  &(registry # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> registry.

(** 删除在容器都交还节点、等待者均移走后形成的退休对象。它仍拥有32字节；
    正常 delete 的 x_free 不属于当前已批准仅零私有对象的 trusted contract，
    这里只记录模块生命周期 representation，不扩大本次 C 验证闭包。 *)
Definition store_sem_retired (obj : SemaphoreObject) : Assertion :=
  let p := obj.(semaphore_addr) in
  “ obj.(semaphore_pending_addrs) = [] ” &&
  store_sem_id_detached (&(p # "Semaphore" ->ₛ "id")) 65535
    (&(p # "Semaphore" ->ₛ "id" .ₛ "link"))
    (&(p # "Semaphore" ->ₛ "id" .ₛ "link")) **
  store_semaphore_body obj **
  store_sem_link_detached (&(p # "Semaphore" ->ₛ "link"))
    (&(p # "Semaphore" ->ₛ "link")) (&(p # "Semaphore" ->ₛ "link")).
