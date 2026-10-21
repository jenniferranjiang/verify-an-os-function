Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
Require Import Coq.Sorting.Permutation.
From AUXLib Require Import ListLib.
From SimpleC.SL Require Import Mem CNotation.
Require Export CRTOS_Verify.lib.dll_abs CRTOS_Verify.lib.idnode_abs.
Require Export CRTOS_Verify.lib.KTaskPure CRTOS_Verify.lib.KTaskDelay.
Require Export CRTOS_Verify.lib.StructFieldOffsetAxiom.
Import KTaskCNotation ListNotations.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope list.

(** 全局纯状态：任务/Delay/Assign 分组，IPC、ISR、角色及调度节点位置共用
    同一权威状态。此层先于 Critical Rules，不依赖空间谓词；内存由 CrtosInv 解释。 *)
Definition ID_MAX_NUM : Z := 128.
Definition BUCKET_NUM : Z := 16.
Definition PRIORITY_MAX : Z := 32.
Definition CORE_COUNT : Z := 1.
Definition IRQ_COUNT : Z := 66.

(**
  [TaskDoneAbs] 保存 C 中 [struct KTaskDone Done] 的八个函数指针值。

  [Done] 在静态初始化后不再写入。它被记录在 [StableGlobalState]
  中，以便规格把 [task->Done] 与相同的函数表关联起来。纯记录不拥有
  内存；函数表的线性权限由 [task_inv] 统一保存。
*)
Record TaskDoneAbs : Type := {
  task_done_init : addr;
  task_done_start : addr;
  task_done_delete : addr;
  task_done_delay : addr;
  task_done_mdelay : addr;
  task_done_prioset : addr;
  task_done_suspend : addr;
  task_done_wake : addr;
}.

(**
  [OsAssignReadyVectorAbs] 是 C 结构体 [OsAssignReadyVector] 的纯抽象。
  [orvBuckets] 按优先级保存只含 [sched_link] 地址的 DLL 节点；另外两个
  字段对应 ready bitmap 和最高优先级缓存。该 record 不拥有内存。
*)
Record OsAssignReadyVectorAbs : Type := mkOsAssignReadyVectorAbs {
  orvBuckets : list (list (DL_Node addr));
  orvReadyGroup : Z;
  orvHighestPrio : Z
}.

(** 静态 [SingleReadyVectorDone] 函数表中三个回调地址的纯快照。 *)
Record PriorityReadyVectorDoneAbs : Type :=
  mkPriorityReadyVectorDoneAbs {
    prvdInit : addr;
    prvdInsert : addr;
    prvdRemove : addr
  }.

(**
  [VarAssignAbs] 保存非 SMP [struct Assign] 的共享可变部分。静态
  [ready_vector_done] 指针值属于稳定状态，不在此重复记录。
*)
Record VarAssignAbs : Type := mkVarAssignAbs {
  assignReadyVector : OsAssignReadyVectorAbs;
  assignRunningTask : addr;
  assignCurrentPriority : Z
}.

(**
  [TaskDescriptorAbs] 是已经完成初始化并发布到全局不变量的任务抽象。

  [tdStackPoint] 保存 descriptor 中可变的当前栈指针；它不再由
  [store_ktask_stack] 固定为初始 context 地址。[tdStackRaw] 和
  [tdStackContext] 描述 [KTaskStackSetup] 建立的初始栈镜像：raw 列表
  只按顺序保存 [stack_start, kss_context_addr) 的字节，context 自身
  由寄存器记录解释，aligned padding 则由空间谓词固定为
  [CHAR_SHARP]。[tdBaseInfo] 和 [tdSchedMember] 复用下沉后的纯
  任务类型；其余字段对应 TaskDescriptor 中除三个独立嵌入链表节点以外
  的直接字段。该 record 本身不拥有内存，空间解释位于 [CrtosInv.v]。
*)
Record TaskDescriptorAbs : Type := Build_TaskDescriptorAbs {
  tdStackPoint : addr;
  tdStackRaw : list Z;
  tdStackContext : StackRegisterContextAbs;
  tdBaseInfo : TaskBaseInfoAbs;
  tdSchedMember : TaskSchedMemberAbs;
  tdDelay : addr;
  tdEventIdTrigger : Z;
  tdEventMode : Z;
  tdExstatus : Z;
  tdDone : addr;
}.

(**
  [update_sched_member desc sched] 只替换权威任务描述符中的动态调度成员，
  栈、基础信息、delay、事件字段和函数表地址均保持不变。

  该构造器属于 [TaskDescriptorAbs] 的通用纯更新接口，不拥有任何 C 内存；
  状态 setter、优先级修改等需要重建 descriptor map cell 的模块均可直接
  复用它，而不应在各函数规格模块中重复定义同构 wrapper。
*)
Definition update_sched_member
    (desc : TaskDescriptorAbs)
    (sched : TaskSchedMemberAbs) : TaskDescriptorAbs :=
  Build_TaskDescriptorAbs
    desc.(tdStackPoint)
    desc.(tdStackRaw)
    desc.(tdStackContext)
    desc.(tdBaseInfo)
    sched
    desc.(tdDelay)
    desc.(tdEventIdTrigger)
    desc.(tdEventMode)
    desc.(tdExstatus)
    desc.(tdDone).

(** 每个已登记对象以分配地址为身份；id 是创建后固定的属性，pending 只保存任务基址。 *)
Record SemaphoreAbs : Type := {
  sem_id : Z;
  sem_value : Z;
  sem_pending_addrs : list addr
}.
(** 对应 k_sem_id_manager、k_sem_list 与由宏生成的数组；静态 done 已唯一解析，不进入模型。 *)
Record SemaphoreStable : Type := {
  sem_idmanager_ptr : addr;
  sem_idmanager_stable : StableIdmanager;
  sem_list_head : addr
}.
(** 管理链顺序与对象map关联。ID manager状态由这两项推导，避免两份权威ID记录。 *)
Record SemaphoreState : Type := {
  sem_ptr_list : list addr;
  sem_obj_map : addr -> option SemaphoreAbs
}.

(**
  Mutex 稳定登记阶段的模型，依据 xs_mutex.h / mutex.c。
  holder 是单个指针值，不拥有所指任务；解引用前必须从同一核心 task map
  取得存活及字段权限。当前优先级调整代码被注释，本模型不假定优先级继承。
  recursive_cnt 为 uint8，C 的增减存在截断/回绕，不能假定非零或无限计数。
*)
Record MutexAbs : Type := {
  mutex_val : Z;
  mutex_recursive_cnt : Z;
  mutex_origin_prio : Z;
  mutex_holder : addr;
  mutex_pending : list (DL_Node addr)
}.

(** 本模块独立 static done 的四个回调值；仅记录地址，不提供回调 Spec。 *)
Record MutexDoneAbs : Type := {
  mutex_done_create : addr;
  mutex_done_delete : addr;
  mutex_done_obtain : addr;
  mutex_done_abandon : addr
}.

(** 独立 ID manager、管理链哨兵及静态回调表的稳定地址；无任务状态副本。 *)
Record MutexStable : Type := {
  mutex_idmanager_ptr : addr;
  mutex_idmanager_stable : StableIdmanager;
  mutex_list_head : addr;
  mutex_done_ptr : addr;
  mutex_done_abs : MutexDoneAbs
}.

(** 已登记 Mutex 对象的纯 map、真实管理链顺序和 ID manager 状态。 *)
Record MutexState : Type := {
  mutex_idmanager_abs : VarIdmanager;
  mutex_ptr_list : list addr;
  mutex_obj_map : addr -> option MutexAbs
}.

(**
  Event 模型对应验证副本 xs_event.h 的两个普通 uint32 字段。
  evOptions/evEvents 保留实际 32 位值；evWaitNodes 保存 pend_list 的真实
  顺序及任务基址。原始 C 的 3/29 位自动截断不在本模型中，Spec 接入前
  必须另证合法输入/写入保持性或建立位域与普通字段的对应关系。
*)
Record EventAbs : Type := {
  evOptions : Z;
  evEvents : Z;
  evWaitNodes : list (DL_Node addr)
}.

(** event.c 的 static done 四个函数指针值；只记录值，不赋予调用权限。 *)
Record EventDoneAbs : Type := {
  evdCreate : addr;
  evdDelete : addr;
  evdTrigger : addr;
  evdProcess : addr
}.

(** 稳定地址分别指向独立 k_event_id_manager、k_event_list 和 event.c::done。 *)
Record EventStable : Type := {
  event_idmanager_ptr : addr;
  event_stable_ids : StableIdmanager;
  event_list_head : addr;
  event_done_ptr : addr;
  event_done_abs : EventDoneAbs
}.

(** 已完整发布对象的唯一 map；ID 值由 event_ids 保存，不复制 ID 字段。 *)
Record EventState : Type := {
  event_objects : addr -> option EventAbs;
  event_ptrs : list addr;
  event_ids : VarIdmanager
}.

(**
  对应 struct MsgQueue 的实际字段和两个等待 DLL。
  mqIndex 保留 int16 的有符号值，三个容量字段保留 uint16 截断后的值。
  msg_buf 长度由 each_len*max_msgs 导出，字节内容只在空间谓词中存在量化。
  当前为所有权草案，尚无逻辑消息序列；后续收发功能 Spec 应以消息内容
  关联占用槽，而不把整个分配区的逐字节快照放入全局抽象状态。
*)
Record MsgQueueAbs : Type := {
  mqBuffer : addr;
  mqIndex : Z;
  mqNumMsgs : Z;
  mqEachLen : Z;
  mqMaxMsgs : Z;
  mqDone : addr;
  mqSendWaitNodes : list (DL_Node addr);
  mqRecvWaitNodes : list (DL_Node addr)
}.

(** msgqueue.c::Done 六槽回调表的值快照，不自动提供函数调用 Spec。 *)
Record MsgQueueDoneAbs : Type := {
  mqdInit : addr;
  mqdUrgentSend : addr;
  mqdSend : addr;
  mqdRecv : addr;
  mqdReinit : addr;
  mqdDelete : addr
}.

(** 各地址分别属于独立 ID manager、全局 DLL 和本翻译单元静态 Done。 *)
Record MsgQueueStable : Type := {
  msgqueue_idmanager_ptr : addr;
  msgqueue_stable_ids : StableIdmanager;
  msgqueue_list_head : addr;
  msgqueue_done_ptr : addr;
  msgqueue_done_abs : MsgQueueDoneAbs
}.

Record MsgQueueState : Type := {
  msgqueue_objects : addr -> option MsgQueueAbs;
  msgqueue_ptrs : list addr;
  msgqueue_ids : VarIdmanager
}.

(** IrqDesc 的两个纯指针值；param 指向的对象和 handler 的可调用权限不在内。 *)
Record IrqDescAbs := mkIrqDescAbs {
  irqHandler : addr;
  irqParam : addr
}.

(** 按 xs_isr.h 声明次序保存 isrDone 的十二个纯函数地址。 *)
Record IsrDoneAbs := mkIsrDoneAbs {
  isrDoneIsInIsr : addr;
  isrDoneRegisterIrq : addr;
  isrDoneFreeIrq : addr;
  isrDoneEnableIrq : addr;
  isrDoneDisableIrq : addr;
  isrDoneHandleIrq : addr;
  isrDoneGetCounter : addr;
  isrDoneIncCounter : addr;
  isrDoneDecCounter : addr;
  isrDoneGetSwitchFlag : addr;
  isrDoneSetSwitchFlag : addr;
  isrDoneClearSwitchFlag : addr
}.

(** 稳定地址与函数表纯快照，不含任何独立可复制的内存权限。 *)
Record IsrStable := mkIsrStable {
  isrManagerAddr : addr;
  isrDoneAddr : addr;
  isrDoneSnapshot : IsrDoneAbs
}.

(**
  InterruptServiceRoutines 的可变纯状态。table 按 IRQ 编号顺序保存条目，
  完整长度由 store_irq_table 的 QCP 数组谓词保证。done 仍为真实字段值：
  静态初始化时为 0，SysInitIsrManager 后才指向 isrDone。
*)
Record IsrAbs := mkIsrAbs {
  isrCount : Z;
  isrSwitchFlag : Z;
  isrTable : list IrqDescAbs;
  isrDonePtr : addr
}.

(**
  角色槽保存真实 int32 ID；阶段是 ghost 信息，不是额外 C 字段。
  静态零值与合法 ID 0 必须区分。Registered 只描述当前 task/ID 登记，
  不授予跨解锁存活或禁止删除的保证；注销/失败的真实协议另行建立。
*)
Inductive RolePhase : Type :=
| RoleUninitialized
| RoleCreateFailed
| RoleRegistered (task : addr).

Record RoleSlotAbs : Type := {
  role_id : Z;
  role_phase : RolePhase
}.

(**
  KTaskZombie 静态初值是两个零指针，初始化后才成为 DLL 哨兵自环。
  Linked 分支的节点 payload 是 task 基址，节点地址仍为 sched_link。
  Raw 不伪装成 store_dll nil，也不保存不可见的 zombie 成员。
*)
Inductive ZombieQueueAbs : Type :=
| ZombieRaw
| ZombieLinked (nodes : list (DL_Node addr)).

(** 任务子系统的稳定地址、ID 配置及函数表快照。 *)
Record TaskStable : Type := {
  task_idmanager_ptr : addr;  (** 指向稳定/可变 ID manager 的空间表示。 *)
  task_stable_ids : StableIdmanager;
  task_list_head : addr;      (** 全局任务链表头；元素 payload 为任务基址。 *)
  task_done_ptr : addr;       (** 指向 TaskDoneAbs 描述的静态函数表。 *)
  task_done_abs : TaskDoneAbs
}.

(** task_ptr_list 记录实际管理链，可能包含尚未发布或已撤回的任务。
    task_desc_map 只保存已发布的完整描述符，其定义域是管理链的子集。
    sched_owned_tasks 随调度变化，记录 INIT/RUNNING 及未挂等待链的
    SUSPEND 任务；对应自环节点的线性权限由 task_inv 持有。 *)
Record TaskState : Type := {
  task_idmanager_abs : VarIdmanager;
  task_ptr_list : list addr;
  task_desc_map : addr -> option TaskDescriptorAbs;
  sched_owned_tasks : list addr
}.

(** 非 SMP Assign 对象和独立 ready-vector 函数表的稳定地址及快照。 *)
Record AssignStable : Type := {
  assign_ptr : addr;
  ready_vector_done_ptr : addr;
  ready_vector_done_abs : PriorityReadyVectorDoneAbs
}.

(** Delay 对象按 inactive map / active DLL 分区，空间层保证不重叠。 *)
Record DelayState : Type := {
  delay_inactive_map : addr -> option TaskDelayAbs;
  delay_active_nodes : list (DL_Node TaskDelayAbs)
}.

(** 各子系统稳定上下文分组保存；每个翻译单元的静态回调表仍各自独立。 *)
Record StableGlobalState : Type := {
  os_task_stable : TaskStable;
  os_tick_ptr : addr;
  delay_head_ptr : addr;
  os_assign_stable : AssignStable;
  os_semaphore_stable : SemaphoreStable;
  os_mutex_stable : MutexStable;
  os_msgqueue_stable : MsgQueueStable;
  os_event_stable : EventStable;
  os_isr_stable : IsrStable;
  os_zombie_head : addr;
  os_recycler_slot : addr;
  os_idle_array : addr;
  os_exstatus_slot : addr;
  os_recycler_entry : addr;
  os_idle_entry : addr;
}.

(** os_tasks 内唯一 task_desc_map 保存全部任务字段；os_delays 保存 Delay
    分区。zombie_queue 保存 CLOSE 链，os_recycle/os_idle 保存真实全局 ID 槽。
    os_exstatus 对应独立 __exstatus；msg_buf 内容按审阅决定暂不建模。 *)
Record VarGlobalState : Type := Build_VarGlobalState {
  os_tasks : TaskState;
  os_tick : Z;
  os_delays : DelayState;
  os_assign : VarAssignAbs;
  zombie_queue : ZombieQueueAbs;
  os_recycle : RoleSlotAbs;
  os_idle : list RoleSlotAbs;
  os_semaphores : SemaphoreState;
  os_mutexes : MutexState;
  os_msgqueues : MsgQueueState;
  os_events : EventState;
  os_isr : IsrAbs;
  os_exstatus : Z;
}.

(** 任务稳定地址、ID 配置和八个回调值的纯绑定，不提供函数表内存权限。
    manager 非空由具名 C 对象地址的既有 QCP 性质推出，无需重复假设。 *)
Definition task_context (sg : TaskStable) : Prop :=
  sg.(task_idmanager_ptr) = &("k_task_id_manager") /\
  sg.(task_list_head) = &("xiaoshan_task_head") /\
  sg.(task_done_ptr) = &("Done") /\
  (sg.(task_stable_ids)).(idmax) = ID_MAX_NUM /\
  (sg.(task_stable_ids)).(hoffset) = BUCKET_NUM /\
  (sg.(task_stable_ids)).(id_map) = &("__id_map_k_task_id_manager") /\
  (sg.(task_stable_ids)).(htable) = &("__htable_k_task_id_manager") /\
  (sg.(task_done_abs)).(task_done_init) = &("_InitKTask") /\
  (sg.(task_done_abs)).(task_done_start) = &("_StartupKTask") /\
  (sg.(task_done_abs)).(task_done_delete) = &("_DeleteKTask") /\
  (sg.(task_done_abs)).(task_done_delay) = &("_DelayKTask") /\
  (sg.(task_done_abs)).(task_done_mdelay) = &("_MdelayKTask") /\
  (sg.(task_done_abs)).(task_done_prioset) = &("_KTaskPrioSet") /\
  (sg.(task_done_abs)).(task_done_suspend) = &("_SuspendKTask") /\
  (sg.(task_done_abs)).(task_done_wake) = &("_KTaskWakeup").

(** 与现有 GetTaskWithIdnodeInfo 锁内证明使用同一 QCP 地址性质。 *)
Lemma task_context_idmanager_nonnull : forall sg,
  task_context sg -> sg.(task_idmanager_ptr) <> 0.
Proof.
  intros sg [Haddress _].
  rewrite Haddress.
  apply addr_of_LE_var_not_zero.
Qed.

(** 非 SMP Assign 及其独立回调表的纯绑定，只依赖 AssignStable。 *)
Definition assign_context (sg : AssignStable) : Prop :=
  sg.(assign_ptr) = &("Assign") /\
  sg.(ready_vector_done_ptr) = &("SingleReadyVectorDone") /\
  (sg.(ready_vector_done_abs)).(prvdInit) = &("OsAssignReadyVectorInit") /\
  (sg.(ready_vector_done_abs)).(prvdInsert) = &("KTaskInsertToReadyVector") /\
  (sg.(ready_vector_done_abs)).(prvdRemove) = &("KTaskOsAssignRemoveKTask").

(** 本次配置的Semaphore具名全局；dispatch已归一直呼，无done字段。 *)
Definition semaphore_context (sg : SemaphoreStable) : Prop :=
  sg.(sem_idmanager_ptr) = &("k_sem_id_manager") /\
  sg.(sem_list_head) = &("k_sem_list") /\
  sg.(sem_idmanager_stable).(idmax) = ID_MAX_NUM /\
  sg.(sem_idmanager_stable).(hoffset) = BUCKET_NUM /\
  sg.(sem_idmanager_stable).(id_map) = &("__id_map_k_sem_id_manager") /\
  sg.(sem_idmanager_stable).(htable) = &("__htable_k_sem_id_manager").

(** 绑定具名全局、当前128 ID/16桶配置与四个回调值。 *)
Definition mutex_context (sg : MutexStable) : Prop :=
  sg.(mutex_idmanager_ptr) = &("k_mutex_id_manager") /\
  sg.(mutex_list_head) = &("k_mutex_list") /\
  sg.(mutex_idmanager_stable).(idmax) = ID_MAX_NUM /\
  sg.(mutex_idmanager_stable).(hoffset) = BUCKET_NUM /\
  sg.(mutex_idmanager_stable).(id_map) = &("__id_map_k_mutex_id_manager") /\
  sg.(mutex_idmanager_stable).(htable) = &("__htable_k_mutex_id_manager") /\
  sg.(mutex_done_abs).(mutex_done_create) = &("_MutexCreate") /\
  sg.(mutex_done_abs).(mutex_done_delete) = &("_MutexDelete") /\
  sg.(mutex_done_abs).(mutex_done_obtain) = &("_MutexObtain") /\
  sg.(mutex_done_abs).(mutex_done_abandon) = &("_MutexAbandon").

(**
  绑定本模块公开根和独立 ID 存储；static done 地址保持 TU 局部参数，
  不与其他文件同名 done/Done 合并。回调值的具体链接关系待各函数 Spec 接入。
*)
Definition event_context (sg : EventStable) : Prop :=
  sg.(event_idmanager_ptr) = &("k_event_id_manager") /\
  sg.(event_list_head) = &("k_event_list") /\
  sg.(event_stable_ids).(idmax) = ID_MAX_NUM /\
  sg.(event_stable_ids).(hoffset) = BUCKET_NUM /\
  sg.(event_stable_ids).(id_map) = &("__id_map_k_event_id_manager") /\
  sg.(event_stable_ids).(htable) = &("__htable_k_event_id_manager").

(**
  绑定本模块全局根；static Done 不与其他翻译单元的同名对象混为一体。
  具体函数地址及静态表地址的链接关系在后续 Spec 接入时建立。
*)
Definition msgqueue_context (sg : MsgQueueStable) : Prop :=
  sg.(msgqueue_idmanager_ptr) = &("k_mq_id_manager") /\
  sg.(msgqueue_list_head) = &("k_mq_list") /\
  sg.(msgqueue_stable_ids).(idmax) = ID_MAX_NUM /\
  sg.(msgqueue_stable_ids).(hoffset) = BUCKET_NUM /\
  sg.(msgqueue_stable_ids).(id_map) = &("__id_map_k_mq_id_manager") /\
  sg.(msgqueue_stable_ids).(htable) = &("__htable_k_mq_id_manager").

(** 全局符号及 C 静态初始化器的纯对应；此关系本身不拥有函数表内存。 *)
Definition IsrGlobalContext (sg : IsrStable) : Prop :=
  sg.(isrManagerAddr) = &("isrManager") /\
  sg.(isrDoneAddr) = &("isrDone") /\
  sg.(isrDoneSnapshot).(isrDoneIsInIsr) = &("IsInIsr") /\
  sg.(isrDoneSnapshot).(isrDoneRegisterIrq) = &("RegisterHwIrq") /\
  sg.(isrDoneSnapshot).(isrDoneFreeIrq) = &("FreeHwIrq") /\
  sg.(isrDoneSnapshot).(isrDoneEnableIrq) = &("EnableHwIrq") /\
  sg.(isrDoneSnapshot).(isrDoneDisableIrq) = &("DisableHwIrq") /\
  sg.(isrDoneSnapshot).(isrDoneHandleIrq) = &("IsrCommon") /\
  sg.(isrDoneSnapshot).(isrDoneGetCounter) = &("GetIsrCounter") /\
  sg.(isrDoneSnapshot).(isrDoneIncCounter) = &("IncIsrCounter") /\
  sg.(isrDoneSnapshot).(isrDoneDecCounter) = &("DecIsrCounter") /\
  sg.(isrDoneSnapshot).(isrDoneGetSwitchFlag) = &("GetIsrSwitchTrigerFlag") /\
  sg.(isrDoneSnapshot).(isrDoneSetSwitchFlag) = &("SetIsrSwitchTrigerFlag") /\
  sg.(isrDoneSnapshot).(isrDoneClearSwitchFlag) = &("ClearIsrSwitchTrigerFlag").

(**
  公开全局根与真实 C 符号相联系；static done 的 TU 地址仍由各 Stable
  参数分别保存，接入对应翻译单元时再建立链接关系。此 Prop 不拥有内存。
*)
Definition os_global_context (sg : StableGlobalState) : Prop :=
  task_context sg.(os_task_stable) /\
  sg.(os_tick_ptr) = &("heartbeat_ticks") /\
  sg.(delay_head_ptr) = &("xiaoshan_delay_head") /\
  assign_context sg.(os_assign_stable) /\
  semaphore_context sg.(os_semaphore_stable) /\
  mutex_context sg.(os_mutex_stable) /\
  msgqueue_context sg.(os_msgqueue_stable) /\
  event_context sg.(os_event_stable) /\
  IsrGlobalContext sg.(os_isr_stable) /\
  sg.(os_zombie_head) = &("KTaskZombie") /\
  sg.(os_recycler_slot) = &("zombie_recycle") /\
  sg.(os_idle_array) = &("idle") /\
  sg.(os_exstatus_slot) = &("__exstatus") /\
  sg.(os_recycler_entry) = &("ZombieKTaskEntry") /\
  sg.(os_idle_entry) = &("IdleKTaskEntry").

(**
  从任务基址直接派生全局 task DLL 使用的嵌入 [task->link] 节点。
  payload 保存稳定的外围 [TaskDescriptor] 基址，供 DLL 局部规格在
  不依赖无信息 [unit] 参数的情况下恢复 container owner。
*)
Definition task_link_node (task : addr) : DL_Node addr :=
  Build_DL_Node task (&(task # "TaskDescriptor" ->ₛ "link")).

(** 从权威任务地址顺序派生物理 DLL 节点顺序，不保存第二份可变列表。 *)
Definition task_link_nodes (tasks : list addr) : list (DL_Node addr) :=
  map task_link_node tasks.

(** 汇总 ID manager 各哈希桶中的抽象 ID 节点。 *)
Definition task_id_nodes (st : VarGlobalState) : list IdNodeAbs :=
  List.concat st.(os_tasks).(task_idmanager_abs).(idbuckets).

(**
  [replace_id_manager new_manager before] 只替换 ID 管理器抽象值，
  保持任务管理链表不变。不可变 [Done] 状态位于单独的
  [StableGlobalState]，不受该更新影响。
*)
Definition replace_id_manager
    (new_manager : VarIdmanager)
    (before : VarGlobalState) : VarGlobalState :=
  {|
    os_tasks := {|
      task_idmanager_abs := new_manager;
      task_ptr_list := before.(os_tasks).(task_ptr_list);
      task_desc_map := before.(os_tasks).(task_desc_map);
      sched_owned_tasks := before.(os_tasks).(sched_owned_tasks);
    |};
    os_tick := before.(os_tick);
    os_delays := before.(os_delays);
    os_assign := before.(os_assign);
    zombie_queue := before.(zombie_queue);
    os_recycle := before.(os_recycle);
    os_idle := before.(os_idle);
    os_semaphores := before.(os_semaphores);
    os_mutexes := before.(os_mutexes);
    os_msgqueues := before.(os_msgqueues);
    os_events := before.(os_events);
    os_isr := before.(os_isr);
    os_exstatus := before.(os_exstatus);
  |}.

(**
  [update_task_id_map ids before] 替换 ID 管理器中的已分配 ID 列表，
  保持 [idmax]、[hoffset] 和哈希桶不变。

  这是描述 [AllocId]/[FreeId] 局部中间状态的辅助函数。单独更新位图
  后，ID 列表与哈希桶可能暂时不满足 [idbuckets_ok]；只有在后续
  哈希桶更新也完成并重新满足 shared 中的合法性条件后，才应折叠回
  完整 [store_idmanager]。
*)
Definition update_task_id_bitmap
    (ids : list Z)
    (before : VarGlobalState) : VarGlobalState :=
  let idm := before.(os_tasks).(task_idmanager_abs) in
  replace_id_manager
    (Build_VarIdmanager ids idm.(idbuckets))
    before.

(**
  [update_task_htable buckets before] 替换 ID 管理器中的哈希桶内容，
  保持 [idmax]、[hoffset] 和已分配 ID 列表不变。

  与 [update_task_id_map] 一样，该函数可以表示内部函数之间的局部
  中间状态；完整临界区操作提交前仍需恢复 [store_idmanager] 所要求
  的位图、ID 列表和桶内容一致性。
*)
Definition update_task_htable
    (buckets : list (list IdNodeAbs))
    (before : VarGlobalState) : VarGlobalState :=
  let idm := before.(os_tasks).(task_idmanager_abs) in
  replace_id_manager
    (Build_VarIdmanager idm.(idlist) buckets)
    before.

(** 只替换权威任务地址顺序；物理 DLL 节点由 [task_link_nodes] 派生。 *)
Definition replace_task_ptr_list
    (tasks : list addr)
    (before : VarGlobalState) : VarGlobalState :=
  {|
    os_tasks := {|
      task_idmanager_abs := before.(os_tasks).(task_idmanager_abs);
      task_ptr_list := tasks;
      task_desc_map := before.(os_tasks).(task_desc_map);
      sched_owned_tasks := before.(os_tasks).(sched_owned_tasks);
    |};
    os_tick := before.(os_tick);
    os_delays := before.(os_delays);
    os_assign := before.(os_assign);
    zombie_queue := before.(zombie_queue);
    os_recycle := before.(os_recycle);
    os_idle := before.(os_idle);
    os_semaphores := before.(os_semaphores);
    os_mutexes := before.(os_mutexes);
    os_msgqueues := before.(os_msgqueues);
    os_events := before.(os_events);
    os_isr := before.(os_isr);
    os_exstatus := before.(os_exstatus);
  |}.

(** 只替换 descriptor map，保持注册表、ID manager 和其他共享状态不变。 *)
Definition replace_task_desc_map
    (descs : addr -> option TaskDescriptorAbs)
    (before : VarGlobalState) : VarGlobalState :=
  {|
    os_tasks := {|
      task_idmanager_abs := before.(os_tasks).(task_idmanager_abs);
      task_ptr_list := before.(os_tasks).(task_ptr_list);
      task_desc_map := descs;
      sched_owned_tasks := before.(os_tasks).(sched_owned_tasks);
    |};
    os_tick := before.(os_tick);
    os_delays := before.(os_delays);
    os_assign := before.(os_assign);
    zombie_queue := before.(zombie_queue);
    os_recycle := before.(os_recycle);
    os_idle := before.(os_idle);
    os_semaphores := before.(os_semaphores);
    os_mutexes := before.(os_mutexes);
    os_msgqueues := before.(os_msgqueues);
    os_events := before.(os_events);
    os_isr := before.(os_isr);
    os_exstatus := before.(os_exstatus);
  |}.

(** 自环 sched_link 转交队列时更新其所有者集合；不改任何 C 字段的抽象值。 *)
Definition replace_sched_owned_tasks (owned : list addr) (st : VarGlobalState)
    : VarGlobalState :=
  {| os_tasks :=
       {| task_idmanager_abs := st.(os_tasks).(task_idmanager_abs);
          task_ptr_list := st.(os_tasks).(task_ptr_list);
          task_desc_map := st.(os_tasks).(task_desc_map);
          sched_owned_tasks := owned |};
     os_tick := st.(os_tick); os_delays := st.(os_delays); os_assign := st.(os_assign);
     zombie_queue := st.(zombie_queue); os_recycle := st.(os_recycle);
     os_idle := st.(os_idle); os_semaphores := st.(os_semaphores);
     os_mutexes := st.(os_mutexes); os_msgqueues := st.(os_msgqueues);
     os_events := st.(os_events); os_isr := st.(os_isr); os_exstatus := st.(os_exstatus) |}.

(**
  按任务基址写入一个已发布 descriptor，结果 cell 必为 [Some value]，
  其他地址保持不变。此更新用于已发布任务的共享状态操作。
*)
Definition update_task_desc_map
    (task : addr)
    (value : TaskDescriptorAbs)
    (before : addr -> option TaskDescriptorAbs)
    : addr -> option TaskDescriptorAbs :=
  fun current =>
    if Z.eq_dec current task then Some value else before current.

Definition empty_irq_desc : IrqDescAbs := mkIrqDescAbs 0 0.

(** 静态 isrManager = {0} 的字段值候选，不描述独立 isrDone 的非零初始化器。 *)
Definition isr_static_zero_state : IsrAbs :=
  mkIsrAbs 0 0 (repeat empty_irq_desc (Z.to_nat IRQ_COUNT)) 0.

(**
  SysInitIsrManager 从链接器表按次序复制。重复 IRQ 编号保留最后一次写入，
  不额外要求编号唯一；索引合法性是该 C 循环的独立内存安全义务。
  registrations 的每对值对应 *__isrtbl_idx 与 *__isrtbl 中一个元素。
*)
Definition isr_linker_indices_ok (registrations : list (Z * IrqDescAbs)) : Prop :=
  Forall (fun registration => 0 <= fst registration < IRQ_COUNT) registrations.

Definition isr_linker_table (registrations : list (Z * IrqDescAbs))
    : list IrqDescAbs :=
  fold_left
    (fun table registration => replace_Znth (fst registration) (snd registration) table)
    registrations isr_static_zero_state.(isrTable).

(**
  初始化后的纯候选值：count/flag 清零、done 安装、IRQ 表由链接器输入覆盖。
  这不是 SysInitIsrManager 的已证明后置条件；链接器源表内存、索引范围和
  循环边界仍须在后续 Spec/验证阶段证明，绝不宣称最终 IRQ 表一律全零。
*)
Definition isr_initialized_state
    (sg : IsrStable) (registrations : list (Z * IrqDescAbs)) : IsrAbs :=
  mkIsrAbs 0 0 (isr_linker_table registrations) sg.(isrDoneAddr).

Definition isr_initialized_from
    (sg : IsrStable) (registrations : list (Z * IrqDescAbs)) (st : IsrAbs) : Prop :=
  isr_linker_indices_ok registrations /\ st = isr_initialized_state sg registrations.
