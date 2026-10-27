Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From AUXLib Require Import ListLib.
From SimpleC.SL Require Import Mem CNotation.
Require Export CRTOS_Verify.lib.CrtosConfig.
Require Export CRTOS_Verify.lib.dll_abs CRTOS_Verify.lib.idnode_abs.
Require Export CRTOS_Verify.lib.StructFieldOffsetAxiom.
Require Export CRTOS_Verify.lib.KTaskPure.
Import KTaskCNotation ListNotations.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope list.

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
  [TaskDescriptorAbs] 是已经完成初始化并发布到全局不变量的任务抽象。

  [tdStackPoint] 保存 descriptor 中可变的当前栈指针；它不再由
  [store_ktask_stack] 固定为初始 context 地址。[tdStackRaw] 和
  [tdStackContext] 描述 [KTaskStackSetup] 建立的初始栈镜像：raw 列表
  只按顺序保存 [stack_start, kss_context_addr) 的字节，context 自身
  由寄存器记录解释，aligned padding 则由空间谓词固定为
  [CHAR_SHARP]。[tdBaseInfo] 和 [tdSchedMember] 复用下沉后的纯
  任务类型；其余字段对应 TaskDescriptor 中除三个独立嵌入链表节点以外
  的直接字段。该 record 本身不拥有内存，空间解释位于 [TaskInv.v]。
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

(**
  [sched_link_of task] 从 [TaskDescriptor] 基址计算其内嵌
  [task_dync_sched_member.sched_link] 地址。它只描述 C 字段地址，不拥有
  任务或链表节点内存。
*)
Definition sched_link_of (task : addr) : addr :=
  &(task # "TaskDescriptor" ->ₛ
    "task_dync_sched_member" .ₛ "sched_link").

Definition zombie_nodes (q : ZombieQueueAbs) : list (DL_Node addr) :=
  match q with ZombieRaw => [] | ZombieLinked nodes => nodes end.

(** 与现有 GetTaskWithIdnodeInfo 锁内证明使用同一 QCP 地址性质。 *)
Lemma task_context_idmanager_nonnull : forall sg,
  task_context sg -> sg.(task_idmanager_ptr) <> 0.
Proof.
  intros sg [Haddress _].
  rewrite Haddress.
  apply addr_of_LE_var_not_zero.
Qed.

