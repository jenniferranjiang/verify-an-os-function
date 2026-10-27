Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export KSemaphoreDeleteTrial.CrtosInv.
Require Export CRTOS_Verify.lib.OsAssignReadyVector.
From MonadLib.MonadErr Require Export MonadErrBasic monadesafe_lib.
Import ListNotations DLL IDNode MonadErr.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.
Local Open Scope list.
Local Open Scope Z_scope.

(** 仅更新指定任务的 exstatus；LinklistResumeAll 写 -ERROR=-1。
    所有调度字段、delay 指针、栈和回调地址保持原值。 *)
Definition set_task_desc_exstatus (d : TaskDescriptorAbs) (value : Z)
    : TaskDescriptorAbs :=
  Build_TaskDescriptorAbs d.(tdStackPoint) d.(tdStackRaw) d.(tdStackContext)
    d.(tdBaseInfo) d.(tdSchedMember) d.(tdDelay) d.(tdEventIdTrigger)
    d.(tdEventMode) value d.(tdDone).

(** READY setter 只改变 stat 低三位所代表的语义状态。
    store_task_status 隐藏 raw 高五位；本抽象操作不额外承诺其跨调用等值。 *)
Definition set_task_desc_ready (d : TaskDescriptorAbs) : TaskDescriptorAbs :=
  let s := d.(tdSchedMember) in
  update_sched_member d (mkTaskSchedMemberAbs TSK_READY s.(tsmAdvanceCnt)
    s.(tsmCurPrio) s.(tsmOriginTimeslice) s.(tsmRestTimeslice) s.(tsmBitmapColumn)).

(** 对应 Assign.os_assign_ready_vector；返回地址不拥有内存。 *)
Definition assign_ready_vector_addr (sg : StableGlobalState) : addr :=
  let assign := sg.(os_assign_stable).(assign_ptr) in
  &(assign # "Assign" ->ₛ "os_assign_ready_vector").

(** 就绪表更新保持 running/current-priority 以及所有其他模块。 *)
Definition replace_global_ready_vector (ready : OsAssignReadyVectorAbs)
    (st : VarGlobalState) : VarGlobalState :=
  {| os_semaphores := st.(os_semaphores); os_tasks := st.(os_tasks);
     os_tick := st.(os_tick); os_delays := st.(os_delays);
     os_assign := mkVarAssignAbs ready st.(os_assign).(assignRunningTask)
       st.(os_assign).(assignCurrentPriority);
     zombie_queue := st.(zombie_queue); os_recycle := st.(os_recycle);
     os_idle := st.(os_idle); os_mutexes := st.(os_mutexes);
     os_msgqueues := st.(os_msgqueues); os_events := st.(os_events);
     os_isr := st.(os_isr); os_exstatus := st.(os_exstatus) |}.

(** 延时取消仅替换 delay 分区；task.delay 指针不变，也没有释放对象。 *)
Definition replace_global_delays (delays : DelayState) (st : VarGlobalState)
    : VarGlobalState :=
  {| os_semaphores := st.(os_semaphores); os_tasks := st.(os_tasks);
     os_tick := st.(os_tick); os_delays := delays; os_assign := st.(os_assign);
     zombie_queue := st.(zombie_queue); os_recycle := st.(os_recycle);
     os_idle := st.(os_idle); os_mutexes := st.(os_mutexes);
     os_msgqueues := st.(os_msgqueues); os_events := st.(os_events);
     os_isr := st.(os_isr); os_exstatus := st.(os_exstatus) |}.

(** 按序扫描当前优先级桶，插在第一个 rest_timeslice 严格较大的节点前；
    找不到时尾插。这里不要求整个桶按 timeslice 排序，因为 advance_cnt
    达到上限的另一条路径无条件尾插。缺失 descriptor 不被当作已知字段值：
    调用规格的 registered_ready_nodes 提供每个被扫描节点的登记事实。 *)
Fixpoint rrr_scan_insert (T : addr -> option TaskDescriptorAbs)
    (ticks : Z) (node : DL_Node addr) (bucket : list (DL_Node addr))
    : list (DL_Node addr) :=
  match bucket with
  | nil => [node]
  | current :: rest =>
      match T current.(getData) with
      | Some d => if Z.ltb ticks d.(tdSchedMember).(tsmRestTimeslice)
                  then node :: bucket
                  else current :: rrr_scan_insert T ticks node rest
      | None => current :: rrr_scan_insert T ticks node rest
      end
  end.

(** KTASK_MAX_ADVANCE_PROCESS_TIME=1；本插入函数不修改 advance_cnt。
    来源为 assign_roundrobinremain.c:33-61 的两个分支。 *)
Definition rrr_bucket_insert (T : addr -> option TaskDescriptorAbs)
    (sched : TaskSchedMemberAbs) (node : DL_Node addr)
    (before after : list (DL_Node addr)) : Prop :=
  after = if Z.ltb sched.(tsmAdvanceCnt) 1
          then rrr_scan_insert T sched.(tsmRestTimeslice) node before
          else before ++ [node].

(** 单桶替换保留 group/highest；用于 RRR helper 的真实中间状态。 *)
Definition os_assign_ready_vector_replace_bucket
    (ready : OsAssignReadyVectorAbs) (prio : Z) (bucket : list (DL_Node addr))
    : OsAssignReadyVectorAbs :=
  mkOsAssignReadyVectorAbs (replace_Znth prio bucket ready.(orvBuckets))
    ready.(orvReadyGroup) ready.(orvHighestPrio).
Definition assign_policy_highest_after (ready : OsAssignReadyVectorAbs)
    (sched : TaskSchedMemberAbs) : Z :=
  Z.max ready.(orvHighestPrio) sched.(tsmCurPrio).

(** AssignPolicyInsert 在 RRR 插入后只更新最高优先级缓存；group 在外层
    KTaskInsertToReadyVector 的 MERGE_FLAG 中更新，不能提前改变。 *)
Definition assign_policy_insert_ready_vector (ready : OsAssignReadyVectorAbs)
    (sched : TaskSchedMemberAbs) (bucket : list (DL_Node addr))
    : OsAssignReadyVectorAbs :=
  mkOsAssignReadyVectorAbs (replace_Znth sched.(tsmCurPrio) bucket ready.(orvBuckets))
    ready.(orvReadyGroup) (assign_policy_highest_after ready sched).

(** 完整 ready 插入的精确效果，包括实际 bitmap_column 的按位或。
    调用者要重建稳定 assign_inv 时，仍须由任务生命周期提供正确掩码。
    不通过把字段替换成理想掩码隐藏源代码的读取。 *)
Definition assign_insert_step_ic (T : addr -> option TaskDescriptorAbs)
    (task : addr) (desc : TaskDescriptorAbs)
    (before after : OsAssignReadyVectorAbs) : Prop :=
  exists bucket,
    rrr_bucket_insert T desc.(tdSchedMember) (ready_task_node task)
      (Znth desc.(tdSchedMember).(tsmCurPrio) before.(orvBuckets) nil) bucket /\
    after = mkOsAssignReadyVectorAbs
      (replace_Znth desc.(tdSchedMember).(tsmCurPrio) bucket before.(orvBuckets))
      (Z.lor before.(orvReadyGroup) desc.(tdSchedMember).(tsmBitmapColumn))
      (assign_policy_highest_after before desc.(tdSchedMember)).

(** Active delay 的唯一对象从 DLL 转入 inactive map；ticks/task 不变，
    只将 status 置零并删除该 link。prefix/suffix 保留其他节点顺序。 *)
Definition unset_linked_delay_step (delay : addr) (info : TaskDelayAbs)
    (before after : VarGlobalState) : Prop :=
  exists prefix suffix,
    delay <> 0 /\ info.(tdStatus) = TASK_DELAY_ACTIVE_VALUE /\
    before.(os_delays).(delay_active_nodes) =
      prefix ++ Build_DL_Node info (&(delay # "Delay" ->ₛ "link")) :: suffix /\
    after = replace_global_delays
      {| delay_inactive_map := fun p =>
           if Z.eq_dec p delay then
             Some (mkTaskDelayAbs info.(tdTaskPtr) info.(tdTicks) TASK_DELAY_INACTIVE_VALUE)
           else before.(os_delays).(delay_inactive_map) p;
         delay_active_nodes := prefix ++ suffix |} before.

(** KTaskUnSetDelay 的三条合法生命周期路径：NULL、已有 inactive、active。
    active 路径以精确摘链关系描述；未登记的悬空 delay 不被假装成 no-op。 *)
Definition ktask_unset_delay_step (delay : addr)
    (before after : VarGlobalState) : Prop :=
  (delay = 0 /\ after = before) \/
  (exists info, delay <> 0 /\
     before.(os_delays).(delay_inactive_map) delay = Some info /\
     info.(tdStatus) = TASK_DELAY_INACTIVE_VALUE /\ after = before) \/
  (exists info, unset_linked_delay_step delay info before after).

(** 已登记描述符 map 和 ID manager 的共享局部 view。其余任务管理链、
    自持 sched_link 和 Done 表保留在 caller frame；不重复拥有源等待队列。
    全部 descriptor 字段仍使用唯一 store_published_task 表示。 *)
Definition task_fields (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
  “ task_world_wf st ” &&
  store_idmanager sg.(os_task_stable).(task_stable_ids)
    st.(os_tasks).(task_idmanager_abs) sg.(os_task_stable).(task_idmanager_ptr) **
  store_map store_published_task st.(os_tasks).(task_desc_map).

(** 这是 ready helper 能读取的登记事实，不要求中间状态的 bitmap/highest
    已同步，也不要求正在插入的节点状态已经在所有队列关系中同步。
    完整稳定一致性仍由 assign_inv 表达。 *)
Definition registered_ready_nodes (T : addr -> option TaskDescriptorAbs)
    (ready : OsAssignReadyVectorAbs) : Prop :=
  Forall (fun n => exists d, T n.(getData) = Some d /\
    n.(getPtr) = sched_link_of n.(getData))
    (os_ready_nodes ready.(orvBuckets)).
Definition assign_ready_pending (sg : StableGlobalState) (st : VarGlobalState)
    : Assertion :=
  “ registered_ready_nodes st.(os_tasks).(task_desc_map)
      st.(os_assign).(assignReadyVector) ” &&
  store_os_assign_ready_vector (assign_ready_vector_addr sg)
    st.(os_assign).(assignReadyVector).

(** 就绪桶的尾节点视图：空桶的 tail 是哨兵，非空为最后一个节点。
    空间资源仍只有原桶的哨兵和 links；该纯尾指针关系不重复取得内存。 *)
Definition store_ready_dll_tail_view (head : addr) (nodes : list (DL_Node addr))
    (tail : addr) : Assertion :=
  “ tail = match rev nodes with nil => head | node :: _ => node.(getPtr) end ” &&
  store_priority_ready_bucket head nodes.

(** 调用处使用的纯对齐结论；ready 参数不添加第二份任务状态。
    typed descriptor 与 task_world_wf 已提供此基址条件。 *)
Definition task_addr_aligned (task : addr) (_ : OsAssignReadyVectorAbs) : Prop :=
  addr_aligned task ALIGN_SIZE.

(** 由 task ID manager 的实际 ID node 查回原任务，不能仅用 ID 数值推断。
    非负 int32 到 uint16 的转换在上层 API 明确处理。 *)
Definition get_task_with_idnode_success (sg : StableGlobalState)
    (st : VarGlobalState) (id task : Z) : Prop :=
  0 <= id < sg.(os_task_stable).(task_stable_ids).(idmax) /\
  In (Build_IdNodeAbs id (&(task # "TaskDescriptor" ->ₛ "id")))
    (Znth (id mod sg.(os_task_stable).(task_stable_ids).(hoffset))
      st.(os_tasks).(task_idmanager_abs).(idbuckets) nil).

(** 调度源链视图保留完整哨兵及首尾上下文，避免只凭 SUSPEND 猜来源。
    Detached 仅为 caller 局部自环；是否属于全局自持列表由 caller 处理。 *)
Inductive vSchedView : Type :=
| vSchedLinked (head : addr) (prefix suffix : list (DL_Node addr))
| vSchedDetached.
Definition pure_task_sched_link_member (T : addr -> option TaskDescriptorAbs)
    (link task : addr) : Assertion :=
  “ link = sched_link_of task /\ exists d, T task = Some d ” && emp.
Definition store_ktask_wakeup_sched_pre (T : addr -> option TaskDescriptorAbs)
    (task : addr) (view : vSchedView) : Assertion :=
  match view with
  | vSchedLinked head prefix suffix =>
      store_dll (pure_task_sched_link_member T) head
        (prefix ++ ready_task_node task :: suffix)
  | vSchedDetached => store_node_self_linked (sched_link_of task)
  end.
Definition store_ktask_wakeup_source_post (T : addr -> option TaskDescriptorAbs)
    (view : vSchedView) : Assertion :=
  match view with
  | vSchedLinked head prefix suffix =>
      store_dll (pure_task_sched_link_member T) head (prefix ++ suffix)
  | vSchedDetached => emp
  end.

(** 唤醒的纯组合：取消 delay，更新该描述符为 READY，插入就绪队列。
    不修改 exstatus；写 -ERROR 是 LinklistResumeAll 自己的前一步动作。
    源 sched_link 的容器迁移由 caller 的 source view 与模块状态负责。 *)
Definition ktask_wakeup_step (task : addr) (desc : TaskDescriptorAbs)
    (before after : VarGlobalState) : Prop :=
  before.(os_tasks).(task_desc_map) task = Some desc /\
  desc.(tdSchedMember).(tsmStat) = TSK_SUSPEND /\
  exists delayed ready,
    ktask_unset_delay_step desc.(tdDelay) before delayed /\
    assign_insert_step_ic before.(os_tasks).(task_desc_map) task desc
      before.(os_assign).(assignReadyVector) ready /\
    after = replace_global_ready_vector ready
      (replace_task_desc_map
        (update_task_desc_map task (set_task_desc_ready desc)
          before.(os_tasks).(task_desc_map)) delayed).
