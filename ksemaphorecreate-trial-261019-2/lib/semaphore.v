Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Export Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.CrtosRules.
Require Import CRTOS_Verify.lib.idnode CRTOS_Verify.lib.dll.
Import ListNotations DLL IDNode.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

(** 分配器交付整个 32 字节未初始化块。地址/对齐是 malloc 保证，
    不是 KSemaphoreCreate 对 val 或全局状态的额外前提。 *)
Definition semaphore_allocated (p : addr) : Assertion :=
  “ p <> 0 /\ addr_aligned p 4 ” && CharArray.undef_full p 32.

(** QCP CommonAssertion.struct_padding = emp，故全块 memset/free 的四个
    padding 字节必须有实际 owner；这里只拥有 [2,4) 与 [14,16)。 *)
Definition semaphore_padding (p : addr) : Assertion :=
  CharArray.full (p + 2) 2 (repeat_Z 0 2) **
  CharArray.full (p + 14) 2 (repeat_Z 0 2).

(** 可写的独立 DLL 两字段；供初始化和插入，允许尚未初始化。 *)
Definition store_uninit_dlnode (p : addr) : Assertion :=
  &(p # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |->_ **
  &(p # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |->_ .

(** 局部 IdNode 精确快照，不拥有 IdNode 的 padding。
    IdInsertObj 失败必须返还这两个原指针和原 ID，才能重新组成零对象。 *)
Definition store_private_idnode (p : addr) (id prev next : Z) : Assertion :=
  let link := &(p # "IdNode" ->ₛ "link") in
  &(p # "IdNode" ->ₛ "id") # UShort |-> id **
  &(link # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> prev **
  &(link # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next.

Definition store_zero_dlnode (p : addr) : Assertion :=
  &(p # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> 0 **
  &(p # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> 0.

(** memset 后尚未发布的完整对象：32 字节均且仅拥有一次。
    注意零 pend_list 尚不是自环，失败 free 消费整个本谓词。 *)
Definition semaphore_zero (p : addr) : Assertion :=
  “ p <> 0 /\ addr_aligned p 4 ” &&
  store_private_idnode &(p # "Semaphore" ->ₛ "id") 0 0 0 **
  &(p # "Semaphore" ->ₛ "value") # UShort |-> 0 **
  store_zero_dlnode &(p # "Semaphore" ->ₛ "pend_list") **
  store_zero_dlnode &(p # "Semaphore" ->ₛ "link") **
  semaphore_padding p.

(** IdInsertObj 成功后，ID 数值/ID link 已转交 manager；此局部余项保留
    value、两个尚未成环的节点及 padding。不能交给 free。 *)
Definition semaphore_after_id (p : addr) : Assertion :=
  “ p <> 0 /\ addr_aligned p 4 ” &&
  &(p # "Semaphore" ->ₛ "value") # UShort |-> 0 **
  store_zero_dlnode &(p # "Semaphore" ->ₛ "pend_list") **
  store_zero_dlnode &(p # "Semaphore" ->ₛ "link") **
  semaphore_padding p.

(** 已初始化对象主体：value 与等待链头由对象自身拥有；等待任务只贡献
    sched_link，wait payload 不得复制任务字段。ID 和管理link另由容器拥有。 *)
Definition store_semaphore_body (wait : addr -> addr -> Assertion)
    (p : addr) (obj : SemaphoreAbs) : Assertion :=
  “ p <> 0 /\ addr_aligned p 4 ” &&
  &(p # "Semaphore" ->ₛ "value") # UShort |-> obj.(sem_value) **
  store_dll wait &(p # "Semaphore" ->ₛ "pend_list") obj.(sem_pending) **
  semaphore_padding p.

Definition semaphore_node (obj : SemaphoreObject) : DL_Node SemaphoreObject :=
  let p := obj.(sem_address) in Build_DL_Node obj &(p # "Semaphore" ->ₛ "link").
Definition store_semaphore_member (wait : addr -> addr -> Assertion)
    (link : addr) (obj : SemaphoreObject) : Assertion :=
  let p := obj.(sem_address) in
  “ link = &(p # "Semaphore" ->ₛ "link") ” &&
  store_semaphore_body wait obj.(sem_address) obj.(sem_contents).

(** 模块全部已发布对象由真实管理 DLL 逐一拥有。manager 的 ID list/桶
    从同一个对象列表派生，保留插入顺序，不有第二份权威状态或 done 表。 *)
Definition semaphore_inv (wait : addr -> addr -> Assertion)
    (sg : SemaphoreStable) (st : SemaphoreState) : Assertion :=
  “ semaphore_context sg ” &&
  store_idmanager sg.(sem_idmanager_stable) (sem_idmanager_abs st)
    sg.(sem_idmanager_ptr) **
  store_dll (store_semaphore_member wait) sg.(sem_list_head)
    (map semaphore_node st.(sem_objects)).

Definition semaphore_waiters (st : SemaphoreState) : list addr :=
  flat_map (fun obj => map (@getData addr) obj.(sem_contents).(sem_pending))
    st.(sem_objects).

(** 创建内的分步转交：新 ID 已登记而管理link尚未插入。
    原模块对象和全部未访问等待资源原样保留。 *)
Definition semaphore_registered (wait : addr -> addr -> Assertion)
    (sg : SemaphoreStable) (st : SemaphoreState) (p : addr) (id : Z) : Assertion :=
  “ semaphore_context sg ” &&
  store_idmanager sg.(sem_idmanager_stable)
    (idmanager_link sg.(sem_idmanager_stable)
      (idmanager_add (sem_idmanager_abs st) id) id
      &(p # "Semaphore" ->ₛ "id")) sg.(sem_idmanager_ptr) **
  store_dll (store_semaphore_member wait) sg.(sem_list_head)
    (map semaphore_node st.(sem_objects)).

(** 初始化完毕、尚未加入管理 DLL。value 已写，pend_list 已自环，管理
    link 仍保留 memset 后零值；ID资源仍在 semaphore_registered 中。 *)
Definition semaphore_ready (wait : addr -> addr -> Assertion)
    (p : addr) (value : Z) : Assertion :=
  store_semaphore_body wait p {| sem_value := value; sem_pending := [] |} **
  store_zero_dlnode &(p # "Semaphore" ->ₛ "link").

(** C 静态初始化后的空模块；管理链顺序、ID列表和哈希桶均从空对象列表导出。 *)
Definition semaphore_initial_state : SemaphoreState := {| sem_objects := [] |}.

(** DECLARE_ID_MANAGER 的两个BSS数组及显式manager初始化器；hash桶是
    两个零指针，不假装已调用InitDoubleLinkList。数组结构复用QCP store_array。
    k_sem_list则由声明中的自引用初始化器建立自环。 *)
Definition semaphore_static_resources (sg : SemaphoreStable) : Assertion :=
  let manager := sg.(sem_idmanager_ptr) in
  let ids := sg.(sem_idmanager_stable) in
  let head := sg.(sem_list_head) in
  “ semaphore_context sg ” &&
  &(manager # "IdManager" ->ₛ "id_max") # UShort |-> 128 **
  &(manager # "IdManager" ->ₛ "hoffset") # UShort |-> 16 **
  &(manager # "IdManager" ->ₛ "id_map") # Ptr |-> ids.(id_map) **
  &(manager # "IdManager" ->ₛ "htable") # Ptr |-> ids.(htable) **
  UCharArray.full ids.(id_map) 16 (repeat_Z 0 16) **
  store_array (fun base index (_ : unit) =>
    store_zero_dlnode (base + index * sizeof("SysDoubleLinklistNode")))
    ids.(htable) 16 (repeat tt 16) **
  &(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> head **
  &(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> head.

(** 待证初始化折叠义务的陈述，不是公理、已证引理或额外Require。
    未来初始化证明需要把上面的具体静态owner折成运行态不变量；空队列不
    使用wait payload。当前仅编译检查接口，不将该命题当作成立的假设。 *)
Definition semaphore_static_initialization_obligation : Prop :=
  forall wait sg,
    semaphore_static_resources sg |--
    semaphore_inv wait sg semaphore_initial_state.
