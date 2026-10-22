Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
Require Import Coq.Sorting.Permutation Coq.Sorting.Sorted Coq.micromega.Lia.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export TrialShared.CrtosRules.
Require Export TrialShared.dll TrialShared.idnode.
Require Export TrialShared.KTaskStackSetup TrialShared.KTaskSchedMember.
Require Export TrialShared.NodeSelfLinked.
Import ListNotations DLL IDNode.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope list.
Local Open Scope sac.

(** 正式全局不变量，使用 CrtosGlobState 的同一权威状态及 CrtosRules 断言模型。
    下述资源仅描述已建模的稳定状态；消息队列 msg_buf 按前轮审阅明确暂缓。
    普通锁外 ISR/exstatus 访问、分步发布和回收仍须在后续 Spec 中建立交接协议。 *)

(**
  [task_world_wf] 是 task_inv 使用的最小纯一致性条件。
  它在空间谓词层定义，避免抽象状态及 Critical Rules 反向依赖不变量。

  已发布 descriptor map 的定义域只是实际管理链的子集，允许创建中的
  任务已入链但尚未发布，以及回收中的任务先撤回 map、稍后再摘管理链。
  已发布 INIT/RUNNING 的自持关系在此直接约束，使 task_inv 单独保证
  其 sched_link 自环；两个指针槽仍由 store_owned_sched_nodes 拥有。
  ID manager 节点地址多重集合与任务地址派生的嵌入
  [task->id] 地址关联。按 2026-09-23 审阅确认，每个已登记 descriptor
  的 origin_prio 和 cur_prio 均在闭区间 [0, 31] 内，与 C 的 32 个
  优先级配置一致。此范围本身不保证有符号 [1 << prio] 在 31 处安全；
  bitmap helper 的表达式和算术规则仍须单独审阅。
  按 2026-10-18 审阅，已发布 RUNNING 的 bitmap_column 等于当前优先级
  的单比特掩码；READY 的对应关系仍由 ready_node_at_priority_ok 给出。
  这是临界区交接边界的条件，允许锁内分步修改优先级与掩码的暂态；
  不约束 INIT 的初始零掩码，也不要求该优先级的 ready 桶为空。
  每个已发布 map cell 的 TaskDescriptor 基址还满足 [ALIGN_SIZE] 对齐，
  使锁内局部证明可由登记关系取得集中 ABI 布局公理的前提。该条件与
  [store_published_task] 已持有的基址对齐一致，不约束尚未发布的地址，
  也不把字段或链表节点的空间所有权变成纯事实。
  它不提供目标登记或跨解锁保活保证，也不额外拥有任何字段。
  这里不增加地址非零、[NoDup] 或地址唯一性条件；相关重叠由后续
  separation-logic 空间断言排除。
*)
Record task_world_wf (st : VarGlobalState) : Prop := {
  task_wf_map_present :
    forall task desc, st.(os_tasks).(task_desc_map) task = Some desc ->
    In task st.(os_tasks).(task_ptr_list);
  task_wf_init_running_owned :
    forall task desc, st.(os_tasks).(task_desc_map) task = Some desc ->
    (desc.(tdSchedMember).(tsmStat) = TSK_INIT \/
     desc.(tdSchedMember).(tsmStat) = TSK_RUNNING) ->
    In task st.(os_tasks).(sched_owned_tasks);
  task_wf_id_nodes :
    Permutation
      (map idnode_addr (task_id_nodes st))
      (map (fun task => &(task # "TaskDescriptor" ->ₛ "id"))
           st.(os_tasks).(task_ptr_list));
  task_wf_priority :
    forall task desc,
    st.(os_tasks).(task_desc_map) task = Some desc ->
    0 <= desc.(tdBaseInfo).(tbOriginPrio) <= 31 /\
    0 <= desc.(tdSchedMember).(tsmCurPrio) <= 31;
  task_wf_aligned :
    forall task desc,
    st.(os_tasks).(task_desc_map) task = Some desc ->
    addr_aligned task ALIGN_SIZE;
  task_wf_running_bitmap :
    forall task desc,
    st.(os_tasks).(task_desc_map) task = Some desc ->
    desc.(tdSchedMember).(tsmStat) = TSK_RUNNING ->
    desc.(tdSchedMember).(tsmBitmapColumn) =
      Z.shiftl 1 desc.(tdSchedMember).(tsmCurPrio)
}.

(**
  [store_task_descriptor_padding task] 拥有当前 32 位 TaskDescriptor 布局
  中由创建时清零并保持不变的三段填充字节，不涉及独立嵌入链表节点。
*)
Definition store_task_descriptor_padding (task : addr) : Assertion :=
  CharArray.full (task + 7) 1 (repeat_Z 0 1) **
  CharArray.full (task + 73) 3 (repeat_Z 0 3) **
  CharArray.full (task + 106) 2 (repeat_Z 0 2).

(**
  [store_task_descriptor task desc] 直接拥有 descriptor 主体字段及全部
  六个 sched 标量：stat、advance_cnt、cur_prio、origin_timeslice、
  rest_timeslice、bitmap_column。task 是任务基址，desc 是字段的唯一
  抽象值；INIT/READY/RUNNING/SUSPEND/CLOSE 均使用同一个 map cell。

  完整所有权不依赖局部取字段时使用的补集谓词。不拥有 sched_link、
  task->link、task->id 或外部分配任务栈；队列移动只转移 sched_link
  的两个指针槽，六个标量始终由 task_inv 内的本谓词提供。
*)
Definition store_task_descriptor
    (task : addr) (desc : TaskDescriptorAbs) : Assertion :=
  store_task_sched_member
    (&(task # "TaskDescriptor" ->ₛ
      "task_dync_sched_member" .ₛ "sched_link")) desc.(tdSchedMember) **
  &(task # "TaskDescriptor" ->ₛ "stack_point") # Ptr
    |-> desc.(tdStackPoint) **
  store_task_base_info task desc.(tdBaseInfo) **
  &(task # "TaskDescriptor" ->ₛ
    "task_dync_sched_member" .ₛ "delay") # Ptr |-> desc.(tdDelay) **
  &(task # "TaskDescriptor" ->ₛ "event_id_trigger") # UInt
    |-> desc.(tdEventIdTrigger) **
  &(task # "TaskDescriptor" ->ₛ "event_mode") # UInt |-> desc.(tdEventMode) **
  &(task # "TaskDescriptor" ->ₛ "exstatus") # Int |-> desc.(tdExstatus) **
  &(task # "TaskDescriptor" ->ₛ "Done") # Ptr |-> desc.(tdDone) **
  store_task_descriptor_padding task.

(** 自持 sched_link 的唯一 cell：INIT/RUNNING 必须自持，SUSPEND 可以自持。
    CLOSE 不在此分支；仍发布的 CLOSE 由 zombie 队列拥有，摘除后的节点
    交给回收者的局部资源。INIT/RUNNING 的成员资格由 task_world_wf 保证；
    所有状态的完整覆盖与互斥仍由 os_wf_sched_coverage 统一保证。 *)
Definition store_detached_sched_link
    (T : addr -> option TaskDescriptorAbs) (task : addr) : Assertion :=
  EX desc : TaskDescriptorAbs,
    “ T task = Some desc /\
      (desc.(tdSchedMember).(tsmStat) = TSK_INIT \/
       desc.(tdSchedMember).(tsmStat) = TSK_RUNNING \/
       desc.(tdSchedMember).(tsmStat) = TSK_SUSPEND) ” &&
    store_node_self_linked (sched_link_of task).

(** 可变自持列表只拥有节点的两个指针槽；描述符标量由 map cell 拥有。 *)
Definition store_owned_sched_nodes
    (T : addr -> option TaskDescriptorAbs) (tasks : list addr) : Assertion :=
  iter_sepcon (map (store_detached_sched_link T) tasks).

(**
  [store_published_task task desc] 是 descriptor map 的完整 cell：
  descriptor 主体（含六标量）与独立任务栈，不拥有任何 sched_link。
  参数 task 是动态分配任务基址，desc 同时保存字段值和栈图像。
  对齐、stack-point 边界以及栈图像的所有权沿用原已发布任务条件；
  INIT/READY/RUNNING/SUSPEND/CLOSE 的区别不影响这些字段的查找方式。
*)
Definition store_published_task
    (task : addr) (desc : TaskDescriptorAbs) : Assertion :=
  let info := desc.(tdBaseInfo) in
  “ addr_aligned task ALIGN_SIZE /\
    aligned_reglen desc.(tdStackPoint) /\
    info.(tbStackStart) <= desc.(tdStackPoint) /\
    desc.(tdStackPoint) + sizeof("StackRegisterContext") <=
      kss_aligned_top info ” &&
  store_task_descriptor task desc **
  store_ktask_stack info.(tbStackStart) info.(tbStackDepth)
    desc.(tdStackRaw) desc.(tdStackContext).

(**
  全局 task DLL 的纯 container 关系；DLL 拥有 task->link 槽，
  payload 不重复拥有 descriptor 的字段。
*)
Definition pure_task_link_member (link task : addr) : Assertion :=
  “ link = &(task # "TaskDescriptor" ->ₛ "link") ” && emp.

(** KTaskDone 的八个函数指针槽；task_inv 在模块级仅持有一份。
    task->Done 字段只保存指针值，不复制所指函数表。锁外读取该表须另行
    建立资源借用/归还协议，InsideCritical/OutsideCritical 不携带此权限。 *)
Definition store_task_done
    (table : addr)
    (done : TaskDoneAbs) : Assertion :=
  &(table # "KTaskDone" ->ₛ "init")
      # Ptr |-> done.(task_done_init) **
  &(table # "KTaskDone" ->ₛ "start")
      # Ptr |-> done.(task_done_start) **
  &(table # "KTaskDone" ->ₛ "Delete")
      # Ptr |-> done.(task_done_delete) **
  &(table # "KTaskDone" ->ₛ "delay")
      # Ptr |-> done.(task_done_delay) **
  &(table # "KTaskDone" ->ₛ "mdelay")
      # Ptr |-> done.(task_done_mdelay) **
  &(table # "KTaskDone" ->ₛ "prioset")
      # Ptr |-> done.(task_done_prioset) **
  &(table # "KTaskDone" ->ₛ "suspend")
      # Ptr |-> done.(task_done_suspend) **
  &(table # "KTaskDone" ->ₛ "wake")
      # Ptr |-> done.(task_done_wake).

(** task_inv 拥有 ID manager、实际管理链、已发布 descriptor/栈、
    sched_owned_tasks 指定的自环节点和唯一 KTaskDone 表。管理链/ID 节点
    可以早于 descriptor 发布；未发布的其余内存由创建者或回收者局部持有。
    ready/pend/zombie 链的 sched_link 由对应队列拥有，独立 Delay 由
    delay_inv 拥有。操作自持节点时须先从本谓词借出，不能另行重复提供。 *)
Definition task_inv (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
  “ task_world_wf st ” &&
  store_idmanager sg.(os_task_stable).(task_stable_ids)
    st.(os_tasks).(task_idmanager_abs)
    sg.(os_task_stable).(task_idmanager_ptr) **
  store_dll pure_task_link_member sg.(os_task_stable).(task_list_head)
    (task_link_nodes st.(os_tasks).(task_ptr_list)) **
  store_map store_published_task st.(os_tasks).(task_desc_map) **
  store_owned_sched_nodes st.(os_tasks).(task_desc_map)
    st.(os_tasks).(sched_owned_tasks) **
  store_task_done sg.(os_task_stable).(task_done_ptr)
    sg.(os_task_stable).(task_done_abs).

(**
  可复用的调度 payload：link/task 是两个不同地址，T 是共享的纯 map。
  此 payload 只给出 map、节点和状态的纯关联，不拥有 sched 标量；
  所有状态的六标量统一由 task_inv.store_task_descriptor 拥有，真实 DLL
  或自环谓词另拥有 node_prev/next。
  状态检查只使用 TaskStatus 构造子，不约束表示层 stat 的高五位。
*)
Definition pure_published_slink
    (T : addr -> option TaskDescriptorAbs) (status : TaskStatus)
    (link task : addr) : Assertion :=
  EX desc : TaskDescriptorAbs,
    “ T task = Some desc /\ link = sched_link_of task /\
      desc.(tdSchedMember).(tsmStat) = status ” &&
    emp.

(** 各 IPC 的总组合固定使用该纯关联，保留登记、节点地址及 SUSPEND 状态。 *)
Definition pure_suspend_sched_link
    (T : addr -> option TaskDescriptorAbs) (link task : addr) : Assertion :=
  pure_published_slink T TSK_SUSPEND link task.

(** Zombie 成员必须为 CLOSE；反向覆盖由总覆盖及其他容器的状态排除推出。 *)
Definition pure_close_sched_link
    (T : addr -> option TaskDescriptorAbs) (link task : addr) : Assertion :=
  pure_published_slink T TSK_CLOSE link task.

(**
  两个分支都拥有完整的 zombie 哨兵，Linked 还拥有各 CLOSE sched_link，
  payload 只保留节点与 map/CLOSE 状态的纯关联；不拥有调度标量。
  回收者摘除 CLOSE 节点后须撤回其全局发布并接管局部资源，不能丢弃
  或加入 sched_owned_tasks；撤回本身不授予仍在管理链/ID 表中的节点权限。
*)
Definition store_zombie_queue
    (T : addr -> option TaskDescriptorAbs) (head : addr)
    (q : ZombieQueueAbs) : Assertion :=
  match q with
  | ZombieRaw =>
      &(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> 0 **
      &(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> 0
  | ZombieLinked nodes =>
      store_dll (pure_close_sched_link T) head nodes
  end.

(**
  成功角色通过 task->id.id 的登记值联系同一 descriptor 及角色入口。
  ID 不属于 TaskBaseInfo。未初始化/失败分支保留实际槽值，不假设 ID 0
  意味着失败。本纯关系不会证明 idle getter 的 container-of 地址正确。
  源码删除保护检查任务名称前缀，当前入口/ID 关系也不蕴含该保护；
  后续证明需要另行建立任务名称事实。
*)
Definition role_slot_wf
    (core : VarGlobalState) (entry : addr) (role : RoleSlotAbs) : Prop :=
  match role.(role_phase) with
  | RoleUninitialized => role.(role_id) = 0
  | RoleCreateFailed => role.(role_id) < 0
  | RoleRegistered task =>
      exists desc,
        core.(os_tasks).(task_desc_map) task = Some desc /\
        desc.(tdBaseInfo).(tbFuncEntry) = entry /\
        exists node,
          In node (task_id_nodes core) /\
          node.(idnode_addr) = &(task # "TaskDescriptor" ->ₛ "id") /\
          node.(idnode_id) = role.(role_id)
  end.

Lemma pure_suspend_sched_link_open : forall T link task desc,
  T task = Some desc ->
  pure_suspend_sched_link T link task |--
  “ link = sched_link_of task /\ desc.(tdSchedMember).(tsmStat) = TSK_SUSPEND ” &&
  emp.
Proof.
  intros T link task desc Hlookup.
  unfold pure_suspend_sched_link, pure_published_slink.
  Intros actual.
  assert (actual = desc) by (intuition congruence).
  subst actual; entailer!.
Qed.

Lemma pure_suspend_sched_link_close : forall T link task desc,
  T task = Some desc -> link = sched_link_of task ->
  desc.(tdSchedMember).(tsmStat) = TSK_SUSPEND ->
  emp |-- pure_suspend_sched_link T link task.
Proof.
  intros T link task desc Hlookup Hlink Hstatus.
  unfold pure_suspend_sched_link, pure_published_slink.
  Exists desc; entailer!.
Qed.

(** 等待链摘除后归还自环节点，并转交纯登记/状态关系；不涉及调度标量。 *)
Lemma suspend_sched_link_to_owned : forall T task,
  pure_suspend_sched_link T (sched_link_of task) task **
  store_node_self_linked (sched_link_of task) |--
  store_detached_sched_link T task.
Proof.
  intros T task.
  unfold pure_suspend_sched_link, pure_published_slink,
    store_detached_sched_link.
  Intros desc; Exists desc; entailer!; tauto.
Qed.

(** CLOSE 即便物理上已自环，也不能作为全局 sched_owned_tasks 的成员。 *)
Lemma owned_sched_link_not_close : forall T task desc,
  T task = Some desc ->
  store_detached_sched_link T task |--
  “ desc.(tdSchedMember).(tsmStat) <> TSK_CLOSE ”.
Proof.
  intros T task desc Hlookup.
  unfold store_detached_sched_link.
  Intros actual.
  assert (actual = desc) by (intuition congruence).
  subst actual; entailer!; intuition congruence.
Qed.

(** Zombie 摘除后只得到局部 CLOSE 自环，不能折叠为全局自持 cell。
    map/队列撤回、栈/Delay/管理链/ID 交接须由回收 Spec 另行证明。 *)
Lemma close_sched_link_to_local : forall T task,
  pure_close_sched_link T (sched_link_of task) task **
  store_node_self_linked (sched_link_of task) |--
  EX desc : TaskDescriptorAbs,
    “ T task = Some desc /\ desc.(tdSchedMember).(tsmStat) = TSK_CLOSE ” &&
    store_node_self_linked (sched_link_of task).
Proof.
  intros T task.
  unfold pure_close_sched_link, pure_published_slink.
  Intros desc; Exists desc; entailer!.
Qed.

