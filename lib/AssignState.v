Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From AUXLib Require Import ListLib.
From SimpleC.SL Require Import Mem CNotation.
Require Export CRTOS_Verify.lib.CrtosConfig.
Require Export CRTOS_Verify.lib.dll_abs CRTOS_Verify.lib.idnode_abs.
Require Export CRTOS_Verify.lib.StructFieldOffsetAxiom.
Require Export CRTOS_Verify.lib.TaskState.
Import KTaskCNotation ListNotations.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope list.

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

(** 非 SMP Assign 对象和独立 ready-vector 函数表的稳定地址及快照。 *)
Record AssignStable : Type := {
  assign_ptr : addr;
  ready_vector_done_ptr : addr;
  ready_vector_done_abs : PriorityReadyVectorDoneAbs
}.

(** 非 SMP Assign 及其独立回调表的纯绑定，只依赖 AssignStable。 *)
Definition assign_context (sg : AssignStable) : Prop :=
  sg.(assign_ptr) = &("Assign") /\
  sg.(ready_vector_done_ptr) = &("SingleReadyVectorDone") /\
  (sg.(ready_vector_done_abs)).(prvdInit) = &("OsAssignReadyVectorInit") /\
  (sg.(ready_vector_done_abs)).(prvdInsert) = &("KTaskInsertToReadyVector") /\
  (sg.(ready_vector_done_abs)).(prvdRemove) = &("KTaskOsAssignRemoveKTask").

(**
  [empty_os_assign_ready_vector] 是 [OsAssignReadyVectorInit] 的预期纯后态：
  32 个空桶、清零的位图和按 CRTOS 约定取 0 的最高优先级缓存。
  空桶列表只描述逻辑内容；对应哨兵自环的内存由
  [store_os_assign_ready_vector] 解释。
*)
Definition empty_os_assign_ready_vector : OsAssignReadyVectorAbs :=
  mkOsAssignReadyVectorAbs
    (List.repeat nil (Z.to_nat PRIORITY_MAX)) 0 0.

(** 汇总 32 个优先级桶中的全部调度链表节点。 *)
Definition os_ready_nodes
    (buckets : list (list (DL_Node addr)))
    : list (DL_Node addr) :=
  List.concat buckets.

(**
  [ready_task_node task] 是任务地址到就绪表抽象节点的规范投影。节点
  payload 直接保存所属 [TaskDescriptor] 的基址 [task]，节点指针则是
  [sched_link_of task]。这个 payload 不复制调度状态；它只使
  [store_dll] 的 payload 参数具有真实的 owner 语义。
*)
Definition ready_task_node (task : addr) : DL_Node addr :=
  Build_DL_Node task (sched_link_of task).

(**
  [ready_node_task_desc task_desc_map node desc] 建立节点、owner 与描述符的
  纯对应：

  - [node.(ptr)] 是 C 中的 [sched_link] 地址；
  - [node.(data)] 直接记录所属 [TaskDescriptor] 基址；
  - [task_desc_map node.(data) = Some desc] 把该地址关联到权威
    [TaskDescriptorAbs]。

  该关系不拥有内存，也不加入节点地址 [NoDup] 条件。相同节点或任务造成
  的内存重叠由后面的分离逻辑空间谓词排除。[task <> 0] 是后续通过
  container-of 恢复并解引用任务描述符所需的有效性条件，不是地址唯一性
  约束。
*)
Definition ready_node_task_desc
    (task_desc_map : addr -> option TaskDescriptorAbs)
    (node : DL_Node addr)
    (desc : TaskDescriptorAbs) : Prop :=
  let task := getData node in
  task <> 0 /\
  getPtr node = sched_link_of task /\
  task_desc_map task = Some desc.

(**
  [ready_node_at_priority_ok task_desc_map index node] 在上述地址对应关系之上
  约束稳定就绪表所需的三个调度元数据：任务当前优先级等于桶下标，
  [bitmap_column] 是该下标的单比特掩码，状态低三位为 [TSK_READY]。

  这些值来自 [task_desc_map] 中关联的 [desc.(tdSchedMember)]；
  节点 payload 只保存所属任务基址，不复制调度状态。
*)
Definition ready_node_at_priority_ok
    (task_desc_map : addr -> option TaskDescriptorAbs)
    (index : Z)
    (node : DL_Node addr) : Prop :=
  exists desc : TaskDescriptorAbs,
    ready_node_task_desc task_desc_map node desc /\
    (desc.(tdSchedMember)).(tsmCurPrio) = index /\
    (desc.(tdSchedMember)).(tsmBitmapColumn) = Z.shiftl 1 index /\
    (desc.(tdSchedMember)).(tsmStat) = TSK_READY.

(**
  [priority_ready_buckets_task_ok task_desc_map index buckets] 把
  [ready_node_at_priority_ok] 逐桶提升到整个数组。从 [index = 0] 开始时，
  第 i 个桶中的每个 [sched_link] 都对应映射中的一个任务描述符，且其
  [tdSchedMember] 与桶 i 一致。
*)
Fixpoint priority_ready_buckets_task_ok
    (task_desc_map : addr -> option TaskDescriptorAbs)
    (index : Z)
    (buckets : list (list (DL_Node addr))) : Prop :=
  match buckets with
  | nil => True
  | bucket :: rest =>
      Forall (ready_node_at_priority_ok task_desc_map index) bucket /\
      priority_ready_buckets_task_ok task_desc_map (index + 1) rest
  end.

(**
  [priority_ready_buckets_ok task_desc_map buckets] 是桶节点与任务的纯
  关联条件：每个桶节点都通过 [task_desc_map] 关联到一个
  [TaskDescriptorAbs]，其 [tdSchedMember] 与桶下标一致。

  完整数组的 [Zlength buckets = PRIORITY_MAX] 已由
  [store_priority_ready_vector] 保证，不在正式全局不变量的
  纯分量重复。

  本命题刻意不要求地址非零或地址互不重复。[store_dll] 已经要求节点地址
  非零；各节点和 payload 通过分离合取组合，重复地址会导致空间断言不可
  满足，无需在抽象状态中保存重复的地址唯一性约束。

  该命题不规定 RR_REMAINSLICE 的队列排序。排序是调度策略的函数语义，
  不属于通用 [OsAssignReadyVector] 内存布局；尤其“达到提前执行次数上限
  后直接追加到队尾”的分支不能在没有额外前提时证明全局时间片有序。
*)
Definition priority_ready_buckets_ok
    (task_desc_map : addr -> option TaskDescriptorAbs)
    (buckets : list (list (DL_Node addr))) : Prop :=
  priority_ready_buckets_task_ok task_desc_map 0 buckets.

(**
  [priority_ready_group_ok buckets group] 表示 C 位图字段与 32 个就绪桶
  一致：对每个合法优先级 i，位 i 为 1 当且仅当第 i 个桶非空。

  [group] 的无符号 32 位范围由 [priority_ready_group]
  字段的 [UInt] points-to 提供，不在本纯关系中重复。
*)
Definition priority_ready_group_ok
    (buckets : list (list (DL_Node addr)))
    (group : Z) : Prop :=
  forall index,
    0 <= index < PRIORITY_MAX ->
    (Z.testbit group index = true <-> Znth index buckets nil <> nil).

(**
  [highest_ready_prio_ok buckets highest] 描述 [highest_prio] 的缓存语义。

  - 所有桶为空时，CRTOS 使用 [highest = 0] 作为约定值；
  - 存在就绪任务时，第 [highest] 个桶非空，且更高下标的桶全部为空。

  因为当前调度器把更大的数值视为更高优先级，该命题刻画的是最大的
  非空桶下标。它同样只是纯一致性条件，不拥有 C 字段。
*)
Definition highest_ready_prio_ok
    (buckets : list (list (DL_Node addr)))
    (highest : Z) : Prop :=
  (os_ready_nodes buckets = nil /\ highest = 0) \/
  (0 <= highest < PRIORITY_MAX /\
  Znth highest buckets nil <> nil /\
  forall index,
     highest < index < PRIORITY_MAX ->
     Znth index buckets nil = nil).

(**
  [os_assign_ready_vector_ok task_desc_map state] 汇总可在调度器公共稳定点
  使用的纯不变量。

  它把桶节点、权威任务描述符映射、位图和最高优先级缓存联系起来，但与
  空间所有权分离。
  验证只修改某一层的辅助函数时，应使用较弱的
  [store_os_assign_ready_vector]，并由外层函数在完成其余更新后重新建立
  本命题。
*)
Definition os_assign_ready_vector_ok
    (task_desc_map : addr -> option TaskDescriptorAbs)
    (state : OsAssignReadyVectorAbs) : Prop :=
  priority_ready_buckets_ok task_desc_map state.(orvBuckets) /\
  priority_ready_group_ok state.(orvBuckets) state.(orvReadyGroup) /\
  highest_ready_prio_ok state.(orvBuckets) state.(orvHighestPrio).

(**
  [assign_world_wf] 集中保存非 SMP Assign 的纯一致性条件。
  参数为任务 descriptor map 和 Assign 抽象状态；running 指针的登记关系
  和就绪桶、位图、最高优先级缓存的一致性分别成为具名字段。READY 完整
  覆盖由 os_wf_sched_coverage 与各容器状态限制共同保证，不在此重复。
  就绪节点到已登记 READY 任务的反向关联也在此保存，
  因而底层就绪容器的空间谓词无需携带任务 map。

  current-priority 的范围仍由 [assign_inv] 中的 UChar points-to 保证。
*)
Record assign_world_wf
    (task_desc_map : addr -> option TaskDescriptorAbs)
    (state : VarAssignAbs) : Prop := {
  (** running 指针为空，或者引用一个已登记的完整任务描述符。 *)
  assign_wf_running_registered :
    state.(assignRunningTask) = 0 \/
    exists desc, task_desc_map state.(assignRunningTask) = Some desc;

  (** 桶中节点引用已登记 READY 任务，且优先级、位图与最高优先级缓存一致。 *)
  assign_wf_ready_valid :
    os_assign_ready_vector_ok task_desc_map state.(assignReadyVector)
}.

