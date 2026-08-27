Require Import Coq.ZArith.ZArith.
Require Import Coq.Bool.Bool.
Require Import Coq.Strings.String.
Require Import Coq.Lists.List.
Require Import Coq.Sorting.Permutation.
From AUXLib Require Import ListLib.
Require Import SetsClass.SetsClass.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
From MonadLib.StateRelMonad Require Import StateRelBasic safeexec_lib.

Require Import CRTOS_Verify.lib.SemaphoreRules.
Require Import CRTOS_Verify.lib.dll.

Import ListNotations SetsNotation Monad MonadNotation.
Import DLL.
Local Open Scope Z_scope.
Local Open Scope string_scope.
Local Open Scope list_scope.
Local Open Scope sets.
Local Open Scope sac.
Local Open Scope monad.

(**
  该纯条件把 spec 量化的稳定记录绑定到真实静态符号；它不拥有这些
  符号的内存，具体权限由下方 manager/list/done predicates 提供。
*)
Definition SemaphoreStableContext (sg : SemaphoreStable) : Prop :=
  sg = semaphore_fixed_stable.

(** malloc/memset bridge 使用的 LP64 ABI 地址关系；它是纯条件。 *)
Definition aligned_8 (p : Z) : Prop := p mod 8 = 0.

Definition semaphore_layout_ok (p : Z) : Prop :=
  sizeof("Semaphore") = 64 /\
  &(p # "Semaphore" ->ₛ "id") = p /\
  &(p # "Semaphore" ->ₛ "id" .ₛ "id") = p /\
  &(p # "Semaphore" ->ₛ "id" .ₛ "link") = p + 8 /\
  &(p # "Semaphore" ->ₛ "value") = p + 24 /\
  &(p # "Semaphore" ->ₛ "pend_list") = p + 32 /\
  &(p # "Semaphore" ->ₛ "link") = p + 48.

Definition sem_waiter_node (waiter : SemaphoreWaiter) : DL_Node unit :=
  Build_DL_Node tt waiter.(sem_waiter_link).

Definition sem_waiter_nodes (waiters : list SemaphoreWaiter)
    : list (DL_Node unit) :=
  map sem_waiter_node waiters.

(** waiter payload 不拥有 TaskDescriptor；pend DLL 只接管 sched links。 *)
Definition sem_waiter_payload (_ : addr) (_ : unit) : Assertion := emp.

Definition sem_id_node (sem : SemaphoreObject) : DL_Node SemaphoreObject :=
  let p := sem.(sem_object_addr) in
  Build_DL_Node sem (&(p # "Semaphore" ->ₛ "id" .ₛ "link")).

Definition sem_global_node (sem : SemaphoreObject)
    : DL_Node SemaphoreObject :=
  let p := sem.(sem_object_addr) in
  Build_DL_Node sem (&(p # "Semaphore" ->ₛ "link")).

Definition sem_id_nodes (objects : list SemaphoreObject)
    : list (DL_Node SemaphoreObject) :=
  map sem_id_node objects.

Definition sem_global_nodes (objects : list SemaphoreObject)
    : list (DL_Node SemaphoreObject) :=
  map sem_global_node objects.

Definition sem_objects_in_bucket
    (sg : SemaphoreStable) (index : Z) (objects : list SemaphoreObject)
    : list SemaphoreObject :=
  filter
    (fun sem => Z.eqb (sem.(sem_object_id) mod sg.(sem_bucket_count)) index)
    objects.

(**
  ID bucket 的 payload 只拥有 embedded [IdNode.id]；其 [link] 两个指针
  由 bucket 的 [store_dll] spine 唯一拥有，Semaphore 其余字段不在此处。
*)
Definition store_sem_id_payload
    (link : addr) (sem : SemaphoreObject) : Assertion :=
  let p := sem.(sem_object_addr) in
  “ link = &(p # "Semaphore" ->ₛ "id" .ₛ "link") ” &&
  &(p # "Semaphore" ->ₛ "id" .ₛ "id") # UShort |-> sem.(sem_object_id).

(**
  一个 bucket 可保持 BSS 的 `(NULL,NULL)` 未初始化形状，或处于正常 DLL
  形状。只要 bucket 含节点就必须选择 initialized；空 bucket 两种形状
  都是源码 [IdGetObj]/[InsertObj] 可产生的稳定 concrete 状态。
*)
Definition store_sem_bucket
    (head : addr) (initialized : bool) (objects : list SemaphoreObject)
    : Assertion :=
  if initialized then
    store_dll store_sem_id_payload head (sem_id_nodes objects)
  else
    “ objects = nil ” &&
    &(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> 0 **
    &(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> 0.

Fixpoint store_sem_buckets_from
    (sg : SemaphoreStable) (index : Z) (flags : list bool)
    (objects : list SemaphoreObject) : Assertion :=
  match flags with
  | nil => emp
  | initialized :: rest =>
      store_sem_bucket
        (sg.(sem_buckets_addr) +
          index * sizeof("SysDoubleLinklistNode"))
        initialized (sem_objects_in_bucket sg index objects) **
      store_sem_buckets_from sg (index + 1) rest objects
  end.

Definition semaphore_bitmap_ok
    (sg : SemaphoreStable) (st : SemaphoreState) (bytes : list Z) : Prop :=
  Zlength bytes = (sg.(sem_id_max) + 7) / 8 /\
  Forall (fun byte => 0 <= byte <= 255) bytes /\
  forall id,
    0 <= id < sg.(sem_id_max) ->
    Z.testbit (Znth (id / 8) bytes 0) (id mod 8) =
      if in_dec Z.eq_dec id (semaphore_ids st) then true else false.

Definition semaphore_bucket_flags_ok
    (sg : SemaphoreStable) (st : SemaphoreState) (flags : list bool) : Prop :=
  Zlength flags = sg.(sem_bucket_count) /\
  forall index,
    0 <= index < sg.(sem_bucket_count) ->
    sem_objects_in_bucket sg index st.(sem_objects) <> nil ->
    Znth index flags false = true.

(** IdInsertObj 只初始化/保持目标 hash bucket，其他 lazy flags 原样 frame。 *)
Definition semaphore_mark_bucket_initialized
    (sg : SemaphoreStable) (id : Z) (flags : list bool) : list bool :=
  replace_Znth (id mod sg.(sem_bucket_count)) true flags.

(** [AllocId] 返回 [-1] 当且仅当配置范围内已经没有空闲 ID。 *)
Definition semaphore_no_free_id
    (sg : SemaphoreStable) (st : SemaphoreState) : Prop :=
  forall id,
    0 <= id < sg.(sem_id_max) ->
    In id (semaphore_ids st).

(**
  ID manager owns its四个 header fields、LP64 offset 4..7 的零 padding、
  bitmap bytes、所有 bucket heads，以及每个 live semaphore 的
  [id.id/id.link]。懒初始化 flags 是 concrete extra，不进入抽象状态。
*)
Definition store_sem_id_manager
    (sg : SemaphoreStable) (st : SemaphoreState) (flags : list bool)
    : Assertion :=
  let manager := sg.(sem_manager_addr) in
  let bitmap := sg.(sem_bitmap_addr) in
  EX bytes : list Z,
    “ semaphore_bitmap_ok sg st bytes /\
      semaphore_bucket_flags_ok sg st flags ” &&
    &(manager # "IdManager" ->ₛ "id_max")
      # UShort |-> sg.(sem_id_max) **
    &(manager # "IdManager" ->ₛ "hoffset")
      # UShort |-> sg.(sem_bucket_count) **
    &(manager # "IdManager" ->ₛ "id_map")
      # Ptr |-> bitmap **
    &(manager # "IdManager" ->ₛ "htable")
      # Ptr |-> sg.(sem_buckets_addr) **
    UCharArray.full (manager + 4) 4 [0; 0; 0; 0] **
    UCharArray.full bitmap
      ((sg.(sem_id_max) + 7) / 8) bytes **
    store_sem_buckets_from sg 0 flags st.(sem_objects).

(** AllocId已置bitmap bit、但尚未把IdNode链接进bucket的精确中间态。 *)
Definition semaphore_bitmap_reserved_ok
    (sg : SemaphoreStable) (st : SemaphoreState)
    (reserved : Z) (bytes : list Z) : Prop :=
  0 <= reserved < sg.(sem_id_max) /\
  ~ In reserved (semaphore_ids st) /\
  Zlength bytes = (sg.(sem_id_max) + 7) / 8 /\
  Forall (fun byte => 0 <= byte <= 255) bytes /\
  forall id,
    0 <= id < sg.(sem_id_max) ->
    Z.testbit (Znth (id / 8) bytes 0) (id mod 8) =
      if Z.eq_dec id reserved then true
      else if in_dec Z.eq_dec id (semaphore_ids st) then true else false.

Definition store_sem_id_manager_reserved
    (sg : SemaphoreStable) (st : SemaphoreState)
    (flags : list bool) (reserved : Z) : Assertion :=
  let manager := sg.(sem_manager_addr) in
  let bitmap := sg.(sem_bitmap_addr) in
  EX bytes : list Z,
    “ semaphore_bitmap_reserved_ok sg st reserved bytes /\
      semaphore_bucket_flags_ok sg st flags ” &&
    &(manager # "IdManager" ->ₛ "id_max")
      # UShort |-> sg.(sem_id_max) **
    &(manager # "IdManager" ->ₛ "hoffset")
      # UShort |-> sg.(sem_bucket_count) **
    &(manager # "IdManager" ->ₛ "id_map")
      # Ptr |-> bitmap **
    &(manager # "IdManager" ->ₛ "htable")
      # Ptr |-> sg.(sem_buckets_addr) **
    UCharArray.full (manager + 4) 4 [0; 0; 0; 0] **
    UCharArray.full bitmap
      ((sg.(sem_id_max) + 7) / 8) bytes **
    store_sem_buckets_from sg 0 flags st.(sem_objects).

(**
  LP64 ABI 中 Semaphore 的两个 padding 区间是 offset 2..7 与 26..31。
  create 的整块 memset 将其清零；后续 API 不触碰它们，但 delete/free 前
  必须保留这 12 bytes 的唯一 ownership。
*)
Definition store_sem_zero_padding (sem : addr) : Assertion :=
  UCharArray.full (sem + 2) 6 [0; 0; 0; 0; 0; 0] **
  UCharArray.full (sem + 26) 6 [0; 0; 0; 0; 0; 0].

(**
  全局 semaphore list 的 payload 拥有 value、pend-list sentinel/spine 与
  padding；不拥有 [id/id.link] 或 [sem.link]，后二者分别属于 ID manager
  bucket 与全局 list spine。
*)
Definition store_sem_body
    (link : addr) (sem : SemaphoreObject) : Assertion :=
  let p := sem.(sem_object_addr) in
  “ link = &(p # "Semaphore" ->ₛ "link") ” &&
  &(p # "Semaphore" ->ₛ "value") # UShort |-> sem.(sem_object_value) **
  store_dll sem_waiter_payload
    (&(p # "Semaphore" ->ₛ "pend_list"))
    (sem_waiter_nodes sem.(sem_object_waiters)) **
  store_sem_zero_padding p.

Definition store_sem_global_list
    (sg : SemaphoreStable) (st : SemaphoreState) : Assertion :=
  store_dll store_sem_body sg.(sem_list_head_addr)
    (sem_global_nodes st.(sem_objects)).

(** 完整共享 heap：ID registry 与 global-list/payload footprints 互不重叠。 *)
Definition store_semaphore_shared
    (sg : SemaphoreStable) (st : SemaphoreState) (flags : list bool)
    : Assertion :=
  store_sem_id_manager sg st flags ** store_sem_global_list sg st.

(**
  semaphore invariant 只拥有本模块的 ID registry、global list 与对象 body。
  Task/ready/Delay/ISR 字节属于显式 external dependency interface；等待期间
  只有 sched-link 两个指针槽转交给 semaphore pend DLL spine。
*)
Definition semaphore_inv
    (sg : SemaphoreStable) (st : SemaphoreState) : Assertion :=
  EX flags : list bool,
    “ SemaphoreStableContext sg /\ semaphore_state_valid sg st ” &&
    store_semaphore_shared sg st flags.

(**
  create 的 caller context：outermost 调用尚未取得 shared invariant；nested
  调用者已持物理 critical，必须把同一份 invariant 线性交给 inner call。
*)
Definition semaphore_caller_context
    (sg : SemaphoreStable) (handlers : list Z) (st : SemaphoreState)
    : Assertion :=
  match handlers with
  | nil => SemaphoreCritical nil st
  | _ :: _ => SemaphoreCritical handlers st ** semaphore_inv sg st
  end.

(** 可调用 create/lock 的 context：caller ownership 加上 uint16 push余量。 *)
Definition semaphore_callable_context
    (sg : SemaphoreStable) (handlers : list Z) (st : SemaphoreState)
    : Assertion :=
  “ SemaphoreCanAcquire handlers ” &&
  semaphore_caller_context sg handlers st.

(**
  [DisableLocalInterrupt] 已取得raw IRQ状态并完成nested-critical token push，
  但 [CriticalAreaLock] 尚未执行物理uint16 counter的自增。
*)
Definition semaphore_irq_disabled_acquire_post
    (sg : SemaphoreStable) (handlers : list Z)
    (before : SemaphoreState) (lock : Z) : Assertion :=
  EX after : SemaphoreState,
    “ SemaphoreAcquireTrans handlers before after ” &&
    store_crtos_lock_nest (SemaphoreHandlerDepth handlers) **
    SemaphoreCriticalCore (lock :: handlers) after **
    semaphore_inv sg after.

(**
  [CriticalAreaUnLock] 已执行物理counter自减，但 [EnableLocalInterrupt] 尚未
  pop nested-critical token并恢复caller/raw IRQ context。
*)
Definition semaphore_irq_disabled_release_pre
    (sg : SemaphoreStable) (handlers : list Z)
    (before after : SemaphoreState) (lock : Z) : Assertion :=
  “ SemaphoreGTrans before after ” &&
  store_crtos_lock_nest (SemaphoreHandlerDepth handlers) **
  SemaphoreCriticalCore (lock :: handlers) before **
  semaphore_inv sg after.

(**
  静态 [done] 表在 critical 外被 wrappers 读取，因此单独作为稳定线性
  frame。它绑定五个 private 实现地址，不与 shared semaphore heap 重叠。
*)
Definition store_semaphore_done (sg : SemaphoreStable) : Assertion :=
  let table := sg.(sem_done_addr) in
  &(table # "SemaphoreDoneType" ->ₛ "SemaphoreCreate")
    # Ptr |-> &("_SemaphoreCreate") **
  &(table # "SemaphoreDoneType" ->ₛ "SemaphoreDelete")
    # Ptr |-> &("_SemaphoreDelete") **
  &(table # "SemaphoreDoneType" ->ₛ "SemaphoreObtain")
    # Ptr |-> &("_SemaphoreObtain") **
  &(table # "SemaphoreDoneType" ->ₛ "SemaphoreAbandon")
    # Ptr |-> &("_SemaphoreAbandon") **
  &(table # "SemaphoreDoneType" ->ₛ "SemaphoreSetValue")
    # Ptr |-> &("_SemaphoreSetValue").

(** wrapper 调用 create 函数指针时保留的另外四个静态表字段。 *)
Definition store_semaphore_done_rest (sg : SemaphoreStable) : Assertion :=
  let table := sg.(sem_done_addr) in
  &(table # "SemaphoreDoneType" ->ₛ "SemaphoreDelete")
    # Ptr |-> &("_SemaphoreDelete") **
  &(table # "SemaphoreDoneType" ->ₛ "SemaphoreObtain")
    # Ptr |-> &("_SemaphoreObtain") **
  &(table # "SemaphoreDoneType" ->ₛ "SemaphoreAbandon")
    # Ptr |-> &("_SemaphoreAbandon") **
  &(table # "SemaphoreDoneType" ->ₛ "SemaphoreSetValue")
    # Ptr |-> &("_SemaphoreSetValue").

Definition semaphore_module
    (sg : SemaphoreStable) (st : SemaphoreState) : Assertion :=
  store_semaphore_done sg ** semaphore_inv sg st.

(** 静态/BSS 初始化完成后尚无 task boundary 或 live semaphore。 *)
Definition semaphore_initial_state : SemaphoreState :=
  Build_SemaphoreState nil nil.

Definition semaphore_initial_bucket_flags : list bool :=
  repeat false 16.

(**
  权威静态初始化资源：bitmap 与 16 个 bucket 处于 BSS 零态，
  [k_sem_list] 是空自环，manager headers 和 [done] 表已由各自 initializer
  建立。该接口不虚构 initialization token。
*)
Definition semaphore_static_initial_resource
    (sg : SemaphoreStable) : Assertion :=
  “ SemaphoreStableContext sg /\
    semaphore_state_valid sg semaphore_initial_state ” &&
  store_semaphore_done sg **
  store_semaphore_shared
    sg semaphore_initial_state semaphore_initial_bucket_flags.

(** 静态资源按固定 lazy flags 建立正式运行时 module predicate。 *)
Lemma semaphore_static_initial_establishes_module :
  forall sg,
    semaphore_static_initial_resource sg |--
    semaphore_module sg semaphore_initial_state.
Proof.
  intros sg.
  unfold semaphore_static_initial_resource, semaphore_module,
    semaphore_inv.
  Exists semaphore_initial_bucket_flags.
  entailer!.
Qed.

(** 整块 memset 后、两个 embedded nodes 尚未发布时的精确 64-byte view。 *)
Definition store_zeroed_semaphore (sem : addr) : Assertion :=
  &(sem # "Semaphore" ->ₛ "id" .ₛ "id") # UShort |-> 0 **
  &(sem # "Semaphore" ->ₛ "id" .ₛ "link" .ₛ "node_next") # Ptr |-> 0 **
  &(sem # "Semaphore" ->ₛ "id" .ₛ "link" .ₛ "node_prev") # Ptr |-> 0 **
  &(sem # "Semaphore" ->ₛ "value") # UShort |-> 0 **
  &(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_next") # Ptr |-> 0 **
  &(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev") # Ptr |-> 0 **
  &(sem # "Semaphore" ->ₛ "link" .ₛ "node_next") # Ptr |-> 0 **
  &(sem # "Semaphore" ->ₛ "link" .ₛ "node_prev") # Ptr |-> 0 **
  store_sem_zero_padding sem.

(** ID manager 调用前可接管的 detached [IdNode]。 *)
Definition store_sem_idnode_insert_ready (sem : addr) : Assertion :=
  &(sem # "Semaphore" ->ₛ "id" .ₛ "id") # UShort |->_ **
  DLL.occupy_dll_node (&(sem # "Semaphore" ->ₛ "id" .ₛ "link")).

(**
  ID 成功发布后仍由 create 私有持有的 remainder；pend-list 与 global link
  尚未发布，value/padding 也仍属于新对象。
*)
Definition store_sem_create_remainder (sem : addr) : Assertion :=
  &(sem # "Semaphore" ->ₛ "value") # UShort |->_ **
  DLL.occupy_dll_node (&(sem # "Semaphore" ->ₛ "pend_list")) **
  DLL.occupy_dll_node (&(sem # "Semaphore" ->ₛ "link")) **
  store_sem_zero_padding sem.

(** 失败回滚在 x_free 前重新聚合全部 64 bytes 的字段级 ownership。 *)
Definition store_semaphore_freeable (sem : addr) : Assertion :=
  store_sem_idnode_insert_ready sem ** store_sem_create_remainder sem.

Definition semaphore_create_state
    (before : SemaphoreState) (id sem_addr value : Z) : SemaphoreState :=
  Build_SemaphoreState
    (Build_SemaphoreObject id sem_addr value nil :: before.(sem_objects))
    before.(sem_task_boundary).

Inductive SemaphoreCreateResult : Type :=
| SEM_CREATE_NO_MEMORY
| SEM_CREATE_OK (id sem_addr value : Z).

(**
  concrete return/effect：两个失败点都返回 [-ENOMEMORY] 且状态不变；成功
  返回 lock 时状态的最小空闲 ID，并将空 pend-list 对象插到全局表头。
*)
Definition semaphore_create_effect
    (sg : SemaphoreStable) (before after : SemaphoreState)
    (value ret : Z) : Prop :=
  (ret = -5 /\ after = before) \/
  (exists id sem_addr,
     ret = id /\ sem_addr <> 0 /\
     ~ In sem_addr (semaphore_addrs before) /\
     semaphore_min_free_id sg before id /\
     after = semaphore_create_state before id sem_addr value /\
     semaphore_valid_step sg before after).

(** LastSeen 允许从上次 Outside 观察沿模块真实 transition closure 推进。 *)
Definition SemaphoreLastSeen
    (st : SemaphoreState) : (SemaphoreState -> Prop) -> Prop :=
  fun states => states == SemaphoreRTrans st.

Definition semaphore_atomic_cmd {A : Type}
    (cmd : program SemaphoreState A)
    : program (SemaphoreState -> Prop) A :=
  fun states_before result states_after =>
    exists before after,
      states_before before /\ cmd before result after /\
      states_after == SemaphoreRTrans after.

Definition abs_semaphore_create_local
    (sg : SemaphoreStable) (value : Z)
    : program SemaphoreState SemaphoreCreateResult :=
  fun before result after =>
    match result with
    | SEM_CREATE_NO_MEMORY => after = before
    | SEM_CREATE_OK id sem_addr result_value =>
        result_value = value /\
        sem_addr <> 0 /\
        ~ In sem_addr (semaphore_addrs before) /\
        semaphore_min_free_id sg before id /\
        after = semaphore_create_state before id sem_addr value /\
        semaphore_valid_step sg before after
    end.

(** 对外 create 的唯一 abstract command；allocator failure 是允许的结果。 *)
Definition abs_semaphore_create
    (sg : SemaphoreStable) (value : Z)
    : program (SemaphoreState -> Prop) SemaphoreCreateResult :=
  semaphore_atomic_cmd (abs_semaphore_create_local sg value).

(** int32 handle 在传给 [IdGetObj(uint16)] 前的真实截断规则。 *)
Definition semaphore_effective_id (id : Z) : option Z :=
  if Z.ltb id 0 then None else Some (id mod 65536).

Definition semaphore_object_has_id (id : Z) (sem : SemaphoreObject) : bool :=
  Z.eqb sem.(sem_object_id) id.

Definition semaphore_id_present (st : SemaphoreState) (id : Z) : Prop :=
  exists sem, In sem st.(sem_objects) /\ sem.(sem_object_id) = id.

Definition semaphore_lookup_split
    (st : SemaphoreState) (id : Z)
    (prefix : list SemaphoreObject) (sem : SemaphoreObject)
    (suffix : list SemaphoreObject) : Prop :=
  st.(sem_objects) = prefix ++ sem :: suffix /\
  sem.(sem_object_id) = id.

(** Delete 的 public command；void result 仍区分 invalid/miss stutter 与 hit。 *)
Definition abs_semaphore_delete_local
    (sg : SemaphoreStable) (id : Z) : program SemaphoreState unit :=
  fun before result after =>
    result = tt /\
    match semaphore_effective_id id with
    | None => after = before
    | Some effective =>
        (~ semaphore_id_present before effective /\ after = before) \/
        (exists prefix sem suffix,
           semaphore_lookup_split before effective prefix sem suffix /\
           after =
             Build_SemaphoreState
               (prefix ++ suffix)
               (resume_waiters (-1)
                 sem.(sem_object_waiters) before.(sem_task_boundary)) /\
           semaphore_valid_step sg before after)
    end.

Definition abs_semaphore_delete
    (sg : SemaphoreStable) (id : Z)
    : program (SemaphoreState -> Prop) unit :=
  semaphore_atomic_cmd (abs_semaphore_delete_local sg id).

Inductive SemaphoreObtainResult : Type :=
| SEM_OBTAIN_INVALID
| SEM_OBTAIN_ACQUIRED
| SEM_OBTAIN_RESUMED (status : Z).

Definition semaphore_resume_status (status : Z) : Prop :=
  status = 0 \/ status = -1 \/ status = -2.

Definition semaphore_boundary_matches_waiter
    (st : SemaphoreState) (waiter : SemaphoreWaiter)
    (task : SemaphoreTaskBoundary) : Prop :=
  In task st.(sem_task_boundary) /\
  task.(sem_task_addr) = waiter.(sem_waiter_task) /\
  task.(sem_task_sched_link) = waiter.(sem_waiter_link).

(** Obtain 真正返回时，同一个 waiter 对应 task 已在 ready owner，且 C 返回值
    就是该 task 的 [exstatus]；任何 wake/timeout 路径都已取消 active delay。 *)
Definition semaphore_resumed_task_matches
    (st : SemaphoreState) (waiter : SemaphoreWaiter) (status : Z) : Prop :=
  exists task,
    semaphore_boundary_matches_waiter st waiter task /\
    task.(sem_task_link_owner) = SEM_TASK_READY /\
    task.(sem_task_exstatus) = status /\
    task.(sem_task_delay_active) = false.

(**
  Obtain command 包含三类真实终止：invalid/miss，计数递减，或先把一个
  fresh sched-link 挂入 pend 后等待环境的 abandon/delete/timeout 将其移出。
  当前配置的 ms->tick 转换最少返回 1，因此 value=0 时不会走 wait_time=0
  的即时 timeout 分支。
*)
Definition abs_semaphore_obtain_local
    (sg : SemaphoreStable) (id msec : Z)
    : program SemaphoreState SemaphoreObtainResult :=
  fun before result after =>
    match semaphore_effective_id id with
    | None => result = SEM_OBTAIN_INVALID /\ after = before
    | Some effective =>
        (~ semaphore_id_present before effective /\
           result = SEM_OBTAIN_INVALID /\ after = before) \/
        (exists prefix sem suffix,
           semaphore_lookup_split before effective prefix sem suffix /\
           ((0 < sem.(sem_object_value) /\
             result = SEM_OBTAIN_ACQUIRED /\
             after =
               Build_SemaphoreState
                 (prefix ++
                  Build_SemaphoreObject
                    sem.(sem_object_id) sem.(sem_object_addr)
                    (sem.(sem_object_value) - 1)
                    sem.(sem_object_waiters) :: suffix)
                 before.(sem_task_boundary) /\
             semaphore_valid_step sg before after) \/
            (sem.(sem_object_value) = 0 /\
             exists suspended waiter suspended_task status,
               ~ In waiter.(sem_waiter_link) (semaphore_waiter_links before) /\
               In waiter.(sem_waiter_link) (semaphore_waiter_links suspended) /\
               semaphore_boundary_matches_waiter
                 suspended waiter suspended_task /\
               (msec = -1 ->
                  suspended_task.(sem_task_delay_active) = false) /\
               (status = -2 ->
                  suspended_task.(sem_task_delay_active) = true) /\
               semaphore_valid_step sg before suspended /\
               SemaphoreTransition sg suspended after /\
               ~ In waiter.(sem_waiter_link) (semaphore_waiter_links after) /\
               semaphore_resume_status status /\
               semaphore_resumed_task_matches after waiter status /\
               result = SEM_OBTAIN_RESUMED status)))
    end.

Definition abs_semaphore_obtain
    (sg : SemaphoreStable) (id msec : Z)
    : program (SemaphoreState -> Prop) SemaphoreObtainResult :=
  semaphore_atomic_cmd (abs_semaphore_obtain_local sg id msec).

Inductive SemaphoreAbandonResult : Type :=
| SEM_ABANDON_INVALID
| SEM_ABANDON_OK.

Definition abs_semaphore_abandon_local
    (sg : SemaphoreStable) (id : Z)
    : program SemaphoreState SemaphoreAbandonResult :=
  fun before result after =>
    match semaphore_effective_id id with
    | None => result = SEM_ABANDON_INVALID /\ after = before
    | Some effective =>
        (~ semaphore_id_present before effective /\
           result = SEM_ABANDON_INVALID /\ after = before) \/
        (result = SEM_ABANDON_OK /\
         exists prefix sem suffix,
           semaphore_lookup_split before effective prefix sem suffix /\
           ((sem.(sem_object_waiters) = nil /\
             after =
               Build_SemaphoreState
                 (prefix ++
                  Build_SemaphoreObject
                    sem.(sem_object_id) sem.(sem_object_addr)
                    ((sem.(sem_object_value) + 1) mod 65536) nil :: suffix)
                 before.(sem_task_boundary)) \/
            (exists waiter rest,
               sem.(sem_object_waiters) = waiter :: rest /\
               after =
                 Build_SemaphoreState
                   (prefix ++
                    Build_SemaphoreObject
                      sem.(sem_object_id) sem.(sem_object_addr)
                      sem.(sem_object_value) rest :: suffix)
                   (resume_waiters 0 [waiter] before.(sem_task_boundary)))) /\
           semaphore_valid_step sg before after)
    end.

Definition abs_semaphore_abandon
    (sg : SemaphoreStable) (id : Z)
    : program (SemaphoreState -> Prop) SemaphoreAbandonResult :=
  semaphore_atomic_cmd (abs_semaphore_abandon_local sg id).

Inductive SemaphoreSetValueResult : Type :=
| SEM_SET_INVALID
| SEM_SET_OK.

(**
  SetValue 与实现一致：值相等时 stutter；不等时即使新值为 0 也唤醒全部
  waiters，再写入给定 uint16 值。
*)
Definition abs_semaphore_set_value_local
    (sg : SemaphoreStable) (id value : Z)
    : program SemaphoreState SemaphoreSetValueResult :=
  fun before result after =>
    match semaphore_effective_id id with
    | None => result = SEM_SET_INVALID /\ after = before
    | Some effective =>
        (~ semaphore_id_present before effective /\
           result = SEM_SET_INVALID /\ after = before) \/
        (result = SEM_SET_OK /\
         exists prefix sem suffix,
           semaphore_lookup_split before effective prefix sem suffix /\
           ((sem.(sem_object_value) = value /\ after = before) \/
            (sem.(sem_object_value) <> value /\
             after =
               Build_SemaphoreState
                 (prefix ++
                  Build_SemaphoreObject
                    sem.(sem_object_id) sem.(sem_object_addr) value nil :: suffix)
                 (resume_waiters (-1)
                   sem.(sem_object_waiters) before.(sem_task_boundary)) /\
             semaphore_valid_step sg before after)))
    end.

Definition abs_semaphore_set_value
    (sg : SemaphoreStable) (id value : Z)
    : program (SemaphoreState -> Prop) SemaphoreSetValueResult :=
  semaphore_atomic_cmd (abs_semaphore_set_value_local sg id value).
