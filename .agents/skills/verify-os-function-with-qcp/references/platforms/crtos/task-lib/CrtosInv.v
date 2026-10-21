Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Strings.String.
Require Import SetsClass.SetsClass.
Import SetsNotation.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import SL.ConAssertion.
Require Export CRTOS_Verify.lib.CrtosGlobState.

Require Import CRTOS_Verify.lib.dll.
Require Import CRTOS_Verify.lib.idnode.
Require Import CRTOS_Verify.lib.CrtosRules.
Require Import CRTOS_Verify.lib.KTaskStackSetup.
Require Import CRTOS_Verify.lib.KTaskSchedMember.

Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string.
Local Open Scope sac.


Import ListNotations.
Import DLL.
Import IDNode.
(**
  [store_task_descriptor_padding task] 拥有当前 32 位 TaskDescriptor 布局
  中由创建时整块清零并保持不变的三段填充字节。它与各字段谓词共同覆盖
  descriptor 分配块，但不触及三个独立嵌入链表节点。
*)
Definition store_task_descriptor_padding (task : addr) : Assertion :=
  CharArray.full (task + 7) 1 (repeat_Z 0 1) **
  CharArray.full (task + 73) 3 (repeat_Z 0 3) **
  CharArray.full (task + 106) 2 (repeat_Z 0 2).

(**
  [store_task_stack desc] 只拥有 [tdBaseInfo.tbStackStart] 指向的外部分配栈，
  不拥有 descriptor 内的 [stack_point] 槽或 base-info 字段。

  当前正式端点对应 Task Create 的 [TASK_INIT] 状态：低地址未使用区和
  对齐栈顶后的尾区保持 ['#']，中间 32 个 [UInt] 槽保存
  [tdStackContext]。纯合取保留 KTaskStackSetup 的布局、对齐、范围和精确
  初始寄存器上下文。未来调度改变栈指针或内容前必须推广或转移该谓词。
*)
Definition store_task_stack (desc : TaskDescriptorAbs) : Assertion :=
  let info := desc.(tdBaseInfo) in
  “ task_create_stack_ready desc ” &&
  store_ktask_stack_memset
    info.(tbStackStart)
    (desc.(tdStackPoint) - info.(tbStackStart)) **
  store_stack_register_context_slots
    desc.(tdStackPoint) desc.(tdStackContext) **
  store_ktask_stack_memset
    (kss_aligned_top info)
    (info.(tbStackStart) + info.(tbStackDepth) -
     kss_aligned_top info).

(**
  [store_task_descriptor_body task desc] 拥有已发布 TaskDescriptor 的主体。

  它拥有 stack_point 槽、base-info、调度标量、delay、事件字段、exstatus、
  Done 和填充字节；明确排除 [task->link]、完整 [task->id]、
  [sched_link.node_prev/node_next] 以及外部分配任务栈，从而与注册表、
  ID manager、调度节点和 [store_task_stack] 保持分离。
*)
Definition store_task_descriptor_body
    (task : addr)
    (desc : TaskDescriptorAbs) : Assertion :=
  &(task # "TaskDescriptor" ->ₛ "stack_point") # Ptr
    |-> desc.(tdStackPoint) **
  store_task_base_info task desc.(tdBaseInfo) **
  store_task_sched_member
    (&(task # "TaskDescriptor" ->ₛ
      "task_dync_sched_member" .ₛ "sched_link"))
    desc.(tdSchedMember) **
  &(task # "TaskDescriptor" ->ₛ
    "task_dync_sched_member" .ₛ "delay") # Ptr
    |-> desc.(tdDelay) **
  &(task # "TaskDescriptor" ->ₛ "event_id_trigger") # UInt
    |-> desc.(tdEventIdTrigger) **
  &(task # "TaskDescriptor" ->ₛ "event_mode") # UInt
    |-> desc.(tdEventMode) **
  &(task # "TaskDescriptor" ->ₛ "exstatus") # Int
    |-> desc.(tdExstatus) **
  &(task # "TaskDescriptor" ->ₛ "Done") # Ptr
    |-> desc.(tdDone) **
  store_task_descriptor_padding task.

(**
  [store_task_sched_link task desc] 按 C 的 masked 状态决定嵌入式调度节点
  的当前位置。当前只实现 [TASK_INIT]：节点尚未进入调度队列，因此由
  descriptor map cell 以空自环 DLL 拥有。其他状态暂为 [emp]，留待对应
  ready/suspend/delay/zombie 不变量接管，当前不提前设计调度结构。
*)
Definition store_task_sched_link
    (task : addr)
    (desc : TaskDescriptorAbs) : Assertion :=
  if Z.eq_dec
       (Z.land (desc.(tdSchedMember)).(tsmStat) TASK_STAT_MASK)
       TASK_INIT
  then
    store_dll
      store_task_sched_member
      (&(task # "TaskDescriptor" ->ₛ
        "task_dync_sched_member" .ₛ "sched_link"))
      nil
  else emp.

(**
  [store_published_task] 是 [task_desc_map task = Some desc] 的单 cell 空间
  解释。一个 cell 原子组合 descriptor 主体、当前 INIT 调度节点和完整外部
  任务栈；[None] 不产生任何这些资源。
*)
Definition store_published_task
    (task : addr)
    (desc : TaskDescriptorAbs) : Assertion :=
  store_task_descriptor_body task desc **
  store_task_sched_link task desc **
  store_task_stack desc.

(** 用 QCP 现有有限支持 [store_map] 拥有全部已最终发布的任务 cell。 *)
Definition store_task_desc_map (st : VarGlobalState) : Assertion :=
  store_map store_published_task st.(task_desc_map).

(**
  [store_task_idmanager sg st] 拥有任务 ID manager、位图、桶及其中的
  嵌入 ID 节点。稳定地址来自 [sg]，可变内容来自 [st]。
*)
Definition store_task_idmanager
    (sg : StableGlobalState)
    (st : VarGlobalState) : Assertion :=
  store_idmanager
    sg.(stable_idmanager_abs)
    st.(task_idmanager_abs)
    sg.(task_idmanager_ptr).

(**
  [store_task_dll sg st] 从权威 [task_ptr_list] 派生并拥有全局 task DLL。
  payload 为 [emp]；descriptor、栈和 ID-node 分别由其他谓词拥有。
*)
Definition store_task_dll
    (sg : StableGlobalState)
    (st : VarGlobalState) : Assertion :=
  store_dll (fun _ _ => emp)
    sg.(task_list_head)
    (task_link_nodes st.(task_ptr_list)).

(**
  [crtos_inv sg st] 是正式任务全局不变量。它同时保存最小纯一致性、
  ID manager、任务注册 DLL，以及只覆盖 Normal 任务的 descriptor map。

  Critical 任务已经出现在前两类容器中但 map 为 [None]，因此创建者能在
  第一次解锁后继续私有初始化 descriptor、sched_link 和任务栈；成功最终
  发布再把三类资源合并为同一个 [Some desc] map cell。
*)
Definition crtos_inv
    (sg : StableGlobalState)
    (st : VarGlobalState) : Assertion :=
  “ task_world_wf st ” &&
  store_task_idmanager sg st **
  store_task_dll sg st **
  store_task_desc_map st.
