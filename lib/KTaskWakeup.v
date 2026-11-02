(** VRTOS bc601a1 的调用关系同步到共享库；保留 CRTOS 的 LittleEndian
    和 list SemaphoreState 表示。semaphore_remove_waiter_step 使用 Forall2
    保留管理顺序、地址、ID 和 value，仅移除各等待序列中的目标任务。 *)
Require Export CRTOS_Verify.lib.KTaskUnSetDelay CRTOS_Verify.lib.RemoveFound.
Require Export CRTOS_Verify.lib.SemaphoreOps.
Require Export CRTOS_Verify.lib.MutexOps.
Require Export CRTOS_Verify.lib.EventOps.
From QCPCompat Require Import Mapping.
From Logic.lib Require Import Coqlib.
Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.CrtosInv.
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

Definition set_sched_member_status
    (sched : TaskSchedMemberAbs)
    (status : TaskStatus) : TaskSchedMemberAbs :=
  mkTaskSchedMemberAbs
    status
    sched.(tsmAdvanceCnt)
    sched.(tsmCurPrio)
    sched.(tsmOriginTimeslice)
    sched.(tsmRestTimeslice)
    sched.(tsmBitmapColumn).

(** READY setter 只改变 stat 低三位所代表的语义状态。
    store_task_status 隐藏 raw 高五位；本抽象操作不额外承诺其跨调用等值。 *)
Definition set_task_desc_ready
    (desc : TaskDescriptorAbs) : TaskDescriptorAbs :=
  update_sched_member desc
    (set_sched_member_status desc.(tdSchedMember) TSK_READY).

(** 对应 Assign.os_assign_ready_vector；返回地址不拥有内存。 *)
Definition assign_ready_vector_addr (sg : StableGlobalState) : addr :=
  let assign := sg.(os_assign_stable).(assign_ptr) in
  &(assign # "Assign" ->ₛ "os_assign_ready_vector").

(** 就绪表更新保持 running/current-priority 以及所有其他模块。 *)
Definition replace_global_ready_vector (ready : OsAssignReadyVectorAbs)
    (st : VarGlobalState) : VarGlobalState :=
  {| os_events := st.(os_events); os_mutexes := st.(os_mutexes); os_semaphores := st.(os_semaphores); os_tasks := st.(os_tasks);
     os_tick := st.(os_tick); os_delays := st.(os_delays);
     os_assign := mkVarAssignAbs ready st.(os_assign).(assignRunningTask)
       st.(os_assign).(assignCurrentPriority);
     zombie_queue := st.(zombie_queue); os_recycle := st.(os_recycle);
     os_idle := st.(os_idle);
     os_isr := st.(os_isr); os_exstatus := st.(os_exstatus) |}.

(** 延时取消仅替换 delay 分区；task.delay 指针不变，也没有释放对象。 *)
Definition replace_global_delays (delays : DelayState) (st : VarGlobalState)
    : VarGlobalState :=
  {| os_events := st.(os_events); os_mutexes := st.(os_mutexes); os_semaphores := st.(os_semaphores); os_tasks := st.(os_tasks);
     os_tick := st.(os_tick); os_delays := delays; os_assign := st.(os_assign);
     zombie_queue := st.(zombie_queue); os_recycle := st.(os_recycle);
     os_idle := st.(os_idle);
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

Definition KTASK_MAX_ADVANCE : Z := 1.

Definition ready_node_rest_timeslice
    (task_desc_map : addr -> option TaskDescriptorAbs)
    (node : DL_Node addr)
    (rest : Z) : Prop :=
  exists desc : TaskDescriptorAbs,
    ready_node_task_desc task_desc_map node desc /\
    addr_aligned (getData node) ALIGN_SIZE /\
    (desc.(tdSchedMember)).(tsmRestTimeslice) = rest.

Definition ready_node_rest_timeslice_gt
    (task_desc_map : addr -> option TaskDescriptorAbs)
    (bound : Z)
    (node : DL_Node addr) : Prop :=
  exists rest : Z,
    ready_node_rest_timeslice task_desc_map node rest /\
    bound < rest.

Definition ready_node_rest_timeslice_le
    (task_desc_map : addr -> option TaskDescriptorAbs)
    (bound : Z)
    (node : DL_Node addr) : Prop :=
  exists rest : Z,
    ready_node_rest_timeslice task_desc_map node rest /\
    rest <= bound.

Definition rrr_ordered_bucket_insert
    (task_desc_map : addr -> option TaskDescriptorAbs)
    (new_rest : Z)
    (inserted : DL_Node addr)
    (old_bucket new_bucket : list (DL_Node addr)) : Prop :=
  exists prefix suffix : list (DL_Node addr),
    old_bucket = prefix ++ suffix /\
    new_bucket = prefix ++ inserted :: suffix /\
    Forall (ready_node_rest_timeslice_le task_desc_map new_rest) prefix /\
    match suffix with
    | nil => True
    | first :: _ =>
        ready_node_rest_timeslice_gt task_desc_map new_rest first
    end.

(** KTASK_MAX_ADVANCE_PROCESS_TIME=1；本插入函数不修改 advance_cnt。
    来源为 assign_roundrobinremain.c:33-61 的两个分支。 *)
Definition rrr_bucket_insert
    (task_desc_map : addr -> option TaskDescriptorAbs)
    (sched : TaskSchedMemberAbs)
    (inserted : DL_Node addr)
    (old_bucket new_bucket : list (DL_Node addr)) : Prop :=
  (sched.(tsmAdvanceCnt) < KTASK_MAX_ADVANCE /\
   rrr_ordered_bucket_insert
     task_desc_map sched.(tsmRestTimeslice) inserted old_bucket new_bucket) \/
  (KTASK_MAX_ADVANCE <= sched.(tsmAdvanceCnt) /\
   new_bucket = old_bucket ++ inserted :: nil).

(** 单桶替换保留 group/highest；用于 RRR helper 的真实中间状态。 *)
Definition os_assign_ready_vector_replace_bucket
    (state : OsAssignReadyVectorAbs)
    (prio : Z)
    (new_bucket : list (DL_Node addr)) : OsAssignReadyVectorAbs :=
  mkOsAssignReadyVectorAbs
    (replace_Znth prio new_bucket state.(orvBuckets))
    state.(orvReadyGroup)
    state.(orvHighestPrio).

Definition assign_policy_highest_after
    (before : OsAssignReadyVectorAbs)
    (sched : TaskSchedMemberAbs) : Z :=
  Z.max before.(orvHighestPrio) sched.(tsmCurPrio).

(** AssignPolicyInsert 在 RRR 插入后只更新最高优先级缓存；group 在外层
    KTaskInsertToReadyVector 的 MERGE_FLAG 中更新，不能提前改变。 *)
Definition assign_policy_insert_ready_vector
    (before : OsAssignReadyVectorAbs)
    (sched : TaskSchedMemberAbs)
    (new_bucket : list (DL_Node addr)) : OsAssignReadyVectorAbs :=
  mkOsAssignReadyVectorAbs
    (replace_Znth
      sched.(tsmCurPrio) new_bucket before.(orvBuckets))
    before.(orvReadyGroup)
    (assign_policy_highest_after before sched).

Definition ready_bucket_owners_aligned
    (bucket : list (DL_Node addr)) : Prop :=
  Forall (fun node => addr_aligned (getData node) ALIGN_SIZE) bucket.

(** 同步 VRTOS 的目标与就绪桶 owner 对齐条件；不拥有额外内存。 *)
Definition task_addr_aligned
    (task : addr)
    (state : OsAssignReadyVectorAbs) : Prop :=
  addr_aligned task ALIGN_SIZE /\
  Forall ready_bucket_owners_aligned state.(orvBuckets).

Definition assign_insert_ready_vector_after
    (before : OsAssignReadyVectorAbs)
    (sched : TaskSchedMemberAbs)
    (new_bucket : list (DL_Node addr)) : OsAssignReadyVectorAbs :=
  let policy_after :=
    assign_policy_insert_ready_vector before sched new_bucket in
  mkOsAssignReadyVectorAbs
    policy_after.(orvBuckets)
    (unsigned_last_nbits
      (Z.lor policy_after.(orvReadyGroup) sched.(tsmBitmapColumn)) 32)
    policy_after.(orvHighestPrio).

Definition sched_link_node (task : addr) : DL_Node addr :=
  Build_DL_Node task (sched_link_of task).

(** 同步 VRTOS 的完整 ready 插入关系：登记、范围、对齐、非空，
    更新后的 READY map、RRR 插入，以及 32 位位图截断。 *)
Definition assign_insert_step_ic
    (descs : addr -> option TaskDescriptorAbs)
    (task : addr)
    (desc : TaskDescriptorAbs)
    (before after : OsAssignReadyVectorAbs) : Prop :=
  (descs task = Some desc /\
     0 <= (tdSchedMember desc).(tsmCurPrio) < PRIORITY_MAX) /\
  task_addr_aligned task before /\
  task <> 0 /\
  exists new_bucket : list (DL_Node addr),
    let ready_sched :=
      set_sched_member_status desc.(tdSchedMember) TSK_READY in
    rrr_bucket_insert
      (update_task_desc_map task (set_task_desc_ready desc) descs)
      ready_sched
      (sched_link_node task)
      (Znth ready_sched.(tsmCurPrio) before.(orvBuckets) nil)
      new_bucket /\
    after =
      assign_insert_ready_vector_after before ready_sched new_bucket.

(** Active delay 的唯一对象从 DLL 转入 inactive map；ticks/task 不变，
    只将 status 置零并删除该 link。prefix/suffix 保留其他节点顺序。 *)
Record unset_linked_delay_step
    (delay_ptr : addr) (delay_data : TaskDelayAbs)
    (st_before st_after : VarGlobalState) : Prop := {
  unset_delay_active_nodes :
    remove_found_prop (Build_DL_Node delay_data (&(delay_ptr # "Delay" ->ₛ "link")))
      st_before.(os_delays).(delay_active_nodes)
      st_after.(os_delays).(delay_active_nodes);
  unset_delay_inactive_map :
    st_after.(os_delays).(delay_inactive_map) =
      partial_mapping_update st_before.(os_delays).(delay_inactive_map)
        delay_ptr (delay_mark_inactive delay_data);
  unset_delay_tasks : st_after.(os_tasks) = st_before.(os_tasks);
  unset_delay_tick : st_after.(os_tick) = st_before.(os_tick);
  unset_delay_assign : st_after.(os_assign) = st_before.(os_assign);
  unset_delay_zombie : st_after.(zombie_queue) = st_before.(zombie_queue);
  unset_delay_recycle : st_after.(os_recycle) = st_before.(os_recycle);
  unset_delay_idle : st_after.(os_idle) = st_before.(os_idle);
  unset_delay_events : st_after.(os_events) = st_before.(os_events);
  unset_delay_mutexes : st_after.(os_mutexes) = st_before.(os_mutexes);
  unset_delay_semaphores : st_after.(os_semaphores) = st_before.(os_semaphores);
  unset_delay_isr : st_after.(os_isr) = st_before.(os_isr);
  unset_delay_exstatus : st_after.(os_exstatus) = st_before.(os_exstatus)
}.

(** KTaskUnSetDelay 的三条合法生命周期路径：NULL、已有 inactive、active。
    active 路径以精确摘链关系描述；未登记的悬空 delay 不被假装成 no-op。 *)
Definition ktask_unset_delay_step
    (delay_ptr : addr)
    (st_before st_after : VarGlobalState) : Prop :=
  (delay_ptr = 0 /\ st_after = st_before) \/
  (delay_ptr <> 0 /\
   exists delay_data,
     st_before.(os_delays).(delay_inactive_map) delay_ptr = Some delay_data /\
     st_after = st_before) \/
  (delay_ptr <> 0 /\
   exists delay_data,
     In (Build_DL_Node delay_data (&(delay_ptr # "Delay" ->ₛ "link")))
       st_before.(os_delays).(delay_active_nodes) /\
     unset_linked_delay_step delay_ptr delay_data st_before st_after).

(** 整批唤醒后的任务表：只更新 waiting 中已有任务的 stat/exstatus，
    不创建新任务，其他描述符项和被唤醒任务的其余字段均保持。 *)
Definition resume_all_task_map
    (T : addr -> option TaskDescriptorAbs) (waiting : list addr)
    : addr -> option TaskDescriptorAbs :=
  fun task =>
    match T task with
    | Some desc =>
        if in_dec Z.eq_dec task waiting
        then Some (set_task_desc_ready (set_task_desc_exstatus desc (-1)))
        else Some desc
    | None => None
    end.

(** 整批取消延时：按原任务的非零 tdDelay 选择对象，而非只看 Delay.task。
    原 active DLL 中被选中的对象转入 inactive map，保留 task/ticks 并置
    INACTIVE；其余 active 节点保持顺序。NULL、原 inactive 和其他对象不变。
    地址唯一性、active/inactive 分离及任务指针对应由调用者的 delay_inv
    提供；本纯更新不为损坏的延时结构提供内存权限或成功保证。 *)
Definition resume_all_delays
    (T : addr -> option TaskDescriptorAbs) (waiting : list addr)
    (before : DelayState) : DelayState :=
  let selected_delays := fold_right
    (fun task delays =>
       match T task with
       | Some desc => if Z.eq_dec desc.(tdDelay) 0 then delays
                      else desc.(tdDelay) :: delays
       | None => delays
       end) nil waiting in
  let selected_node := fun node : DL_Node TaskDelayAbs =>
    existsb (fun delay => Z.eqb (getPtr node)
      (&(delay # "Delay" ->ₛ "link"))) selected_delays in
  {| delay_active_nodes :=
       filter (fun node => negb (selected_node node)) before.(delay_active_nodes);
     delay_inactive_map := fun delay =>
       if in_dec Z.eq_dec delay selected_delays then
         match find (fun node => Z.eqb (getPtr node)
             (&(delay # "Delay" ->ₛ "link"))) before.(delay_active_nodes) with
         | Some node =>
             let info := getData node in
             Some (mkTaskDelayAbs info.(tdTaskPtr) info.(tdTicks)
               TASK_DELAY_INACTIVE_VALUE)
         | None => before.(delay_inactive_map) delay
         end
       else before.(delay_inactive_map) delay |}.

(** 整批就绪插入的前后关系。fold_left 按 waiting 原顺序组合已有插入
    关系，保持 RRR 严格比较、bitmap_column 按位或及 highest 的更新。
    每次传递当前 ready，不把结果简化为集合并或排序。T 固定为原任务表：
    唤醒只改 stat/exstatus，插入读取的优先级、时间片和掩码均不变。 *)
Definition resume_all_ready
    (T : addr -> option TaskDescriptorAbs) (waiting : list addr)
    (before after : OsAssignReadyVectorAbs) : Prop :=
  fold_left
    (fun (states : OsAssignReadyVectorAbs -> Prop) task =>
       fun ready_after => exists ready_before desc,
         states ready_before /\ T task = Some desc /\
         assign_insert_step_ic T task desc ready_before ready_after)
    waiting (fun ready => ready = before) after.

(** 同步 VRTOS task_fields：持有 ID manager、任务管理链、已发布描述符
    和 Done 表；调度节点的所有权由相应队列或自持列表另行提供。 *)
Definition task_fields (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
  “ task_world_wf st ” &&
  store_idmanager sg.(os_task_stable).(task_stable_ids)
    st.(os_tasks).(task_idmanager_abs) sg.(os_task_stable).(task_idmanager_ptr) **
  store_dll pure_task_link_member sg.(os_task_stable).(task_list_head)
    (task_link_nodes st.(os_tasks).(task_ptr_list)) **
  store_map store_published_task st.(os_tasks).(task_desc_map) **
  store_task_done sg.(os_task_stable).(task_done_ptr)
    sg.(os_task_stable).(task_done_abs).

(** 这是 ready helper 能读取的登记事实，不要求中间状态的 bitmap/highest
    已同步，也不要求正在插入的节点状态已经在所有队列关系中同步。
    完整稳定一致性仍由 assign_inv 表达。 *)
Definition registered_ready_nodes (T : addr -> option TaskDescriptorAbs)
    (ready : OsAssignReadyVectorAbs) : Prop :=
  Forall (fun n => exists d, T n.(getData) = Some d /\
    n.(getPtr) = sched_link_of n.(getData))
    (os_ready_nodes ready.(orvBuckets)).

Definition assign_ready_published (st : VarGlobalState) : Prop :=
  forall node,
    In node (os_ready_nodes st.(os_assign).(assignReadyVector).(orvBuckets)) ->
    getData node <> 0 /\
    exists desc, st.(os_tasks).(task_desc_map) (getData node) = Some desc.

Definition assign_ready_pending
    (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
  “ assign_ready_published st ” &&
  store_os_assign_ready_vector (assign_ready_vector_addr sg)
    st.(os_assign).(assignReadyVector).

(** 任务唤醒操作的统一资源接口：task_fields 提供已登记任务字段和 ID
    manager，delay_inv 提供延时对象，assign_ready_pending 提供就绪队列。
    调用前后用同一谓词表示这些资源与当前 st 对应，具体唤醒效果由 spec
    单独描述。源等待链由调用者另行提供，不在这里重复拥有；也不包含锁
    token 或完整 os_inv，不要求恢复就绪队列更新过程中的全部稳定一致性。 *)
Definition task_wakeup_inv (sg : StableGlobalState) (st : VarGlobalState)
    : Assertion :=
  task_fields sg st ** delay_inv sg st ** assign_ready_pending sg st.

(** tasks 保存任务基址；每个任务在 st 的描述符 map 中存在，状态为
    READY，且其 exstatus 字段等于给定值。仅表达这组任务的结果状态，
    不拥有内存，也不描述唤醒顺序、就绪队列位置或其他任务的保持性；
    这些内容由调用规格中的资源谓词和精确操作关系另行给出。 *)
Definition tasks_ready_with_exstatus
    (st : VarGlobalState) (tasks : list addr) (exstatus : Z) : Prop :=
  forall task, In task tasks -> exists desc,
    st.(os_tasks).(task_desc_map) task = Some desc /\
    desc.(tdSchedMember).(tsmStat) = TSK_READY /\
    desc.(tdExstatus) = exstatus.

Definition store_ready_dll_tail_frame
    (head : addr)
    (nodes : list (DL_Node addr))
    (tail : addr) : Assertion :=
  EX first : addr,
    “ head <> 0 /\ tail <> 0 /\ first <> 0 /\
      dll_nodes_nonzero nodes ” &&
    &(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> first **
    dllseg (fun slink task => “ slink = sched_link_of task ” && emp)
      first head head tail nodes.

(** 就绪桶的尾节点视图：空桶的 tail 是哨兵，非空为最后一个节点。
    空间资源仍只有原桶的哨兵和 links；该纯尾指针关系不重复取得内存。 *)
Definition store_ready_dll_tail_view
    (head : addr)
    (nodes : list (DL_Node addr))
    (tail : addr) : Assertion :=
  &(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> tail **
  store_ready_dll_tail_frame head nodes tail.

(** 由 task ID manager 的实际 ID node 查回原任务，不能仅用 ID 数值推断。
    非负 int32 到 uint16 的转换在上层 API 明确处理。 *)
Definition get_task_with_idnode_success
    (sg : StableGlobalState)
    (st : VarGlobalState)
    (id task : addr) : Prop :=
  let sidm := sg.(os_task_stable).(task_stable_ids) in
  let idm := st.(os_tasks).(task_idmanager_abs) in
  0 <= id < sidm.(idmax) /\
  idmanager_query idm id = true /\
  exists id_ptr : addr,
    id_ptr = &(task # "TaskDescriptor" ->ₛ "id") /\
    In (Build_IdNodeAbs id id_ptr)
      (Znth (idmanager_bucket_index sidm id) idm.(idbuckets) nil) /\
    In task st.(os_tasks).(task_ptr_list).

(** 调度源链视图保留完整哨兵及首尾上下文，避免只凭 SUSPEND 猜来源。
    Detached 仅为 caller 局部自环；是否属于全局自持列表由 caller 处理。 *)
Inductive vSchedView : Type :=
  | vSchedLinked
      (source_head : addr)
      (source_prefix source_suffix : list (DL_Node addr))
  | vSchedDetached.

Definition pure_task_sched_link_member
    (descs : addr -> option TaskDescriptorAbs)
    (link task : addr) : Assertion :=
  EX desc : TaskDescriptorAbs,
    “ link = sched_link_of task /\
      descs task = Some desc ” && emp.

Definition store_ktask_wakeup_sched_pre
    (descs : addr -> option TaskDescriptorAbs)
    (task : addr)
    (view : vSchedView) : Assertion :=
  let link := sched_link_of task in
  match view with
  | vSchedLinked head prefix suffix =>
      store_dll (pure_task_sched_link_member descs) head
        (prefix ++ Build_DL_Node task link :: suffix)
  | vSchedDetached =>
      store_node_self_linked link
  end.

Definition store_ktask_wakeup_source_post
    (descs : addr -> option TaskDescriptorAbs)
    (view : vSchedView) : Assertion :=
  match view with
  | vSchedLinked head prefix suffix =>
      store_dll (pure_task_sched_link_member descs) head (prefix ++ suffix)
  | vSchedDetached => emp
  end.

Definition semaphore_remove_waiter_step (task : addr)
    (before after : SemaphoreState) : Prop :=
  Forall2 (fun old new =>
    new.(semaphore_addr) = old.(semaphore_addr) /\
    new.(semaphore_id) = old.(semaphore_id) /\
    new.(semaphore_value) = old.(semaphore_value) /\
    remove_found_prop task old.(semaphore_pending_addrs) new.(semaphore_pending_addrs))
    before after.

(** 同步 VRTOS KTaskWakeupSpec 的成功转移：更新 READY、取消 Delay，
    从自持表或当前建模的 semaphore/mutex/event 等待队列摘除来源节点，
    并保持其余全局分量；msgqueue 不在此关系的当前范围内。
    不修改 exstatus；写 -ERROR 是 LinklistResumeAll 的前一步动作。 *)
Record ktask_wakeup_step (task : addr) (desc : TaskDescriptorAbs)
    (before after : VarGlobalState) : Prop := {
  wakeup_ready : assign_insert_step_ic
    before.(os_tasks).(task_desc_map) task desc
    before.(os_assign).(assignReadyVector) after.(os_assign).(assignReadyVector);
  wakeup_task_map : after.(os_tasks).(task_desc_map) =
    update_task_desc_map task (set_task_desc_ready desc)
      before.(os_tasks).(task_desc_map);
  wakeup_owned : remove_found_prop task
    before.(os_tasks).(sched_owned_tasks) after.(os_tasks).(sched_owned_tasks);
  wakeup_task_ids : after.(os_tasks).(task_idmanager_abs) =
    before.(os_tasks).(task_idmanager_abs);
  wakeup_task_ptrs : after.(os_tasks).(task_ptr_list) = before.(os_tasks).(task_ptr_list);
  wakeup_running : after.(os_assign).(assignRunningTask) = before.(os_assign).(assignRunningTask);
  wakeup_priority : after.(os_assign).(assignCurrentPriority) = before.(os_assign).(assignCurrentPriority);
  wakeup_delays : exists delay_after,
    ktask_unset_delay_step desc.(tdDelay) before delay_after /\
    after.(os_delays) = delay_after.(os_delays);
  wakeup_events : event_remove_waiter_step task before.(os_events) after.(os_events);
  wakeup_mutexes : mutex_remove_waiter_step task before.(os_mutexes) after.(os_mutexes);
  wakeup_semaphores : semaphore_remove_waiter_step task before.(os_semaphores) after.(os_semaphores);
  wakeup_tick : after.(os_tick) = before.(os_tick);
  wakeup_zombie : after.(zombie_queue) = before.(zombie_queue);
  wakeup_recycle : after.(os_recycle) = before.(os_recycle);
  wakeup_idle : after.(os_idle) = before.(os_idle);
  wakeup_isr : after.(os_isr) = before.(os_isr);
  wakeup_exstatus : after.(os_exstatus) = before.(os_exstatus)
}.

(** VRTOS 162a5e7 的已知队首接口，目前只保留 Semaphore 分支。
    Semaphore 的 map 更新适配为本地对象序列更新，保留管理次序、
    ID/value 和其他对象。本地只导入契约，未迁移或宣称其实现证明。 *)
(** 本地 SemaphoreState 保存对象序列及任务地址序列；nodes 是同一等待链
    的规范 DLL 节点投影。纯关联不重复拥有 pend_list 或任务字段。 *)
Definition semaphore_pending_nodes (sem : addr) (st : VarGlobalState)
    (nodes : list (DL_Node addr)) : Prop :=
  exists obj, In obj st.(os_semaphores) /\ obj.(semaphore_addr) = sem /\
    map sched_link_node obj.(semaphore_pending_addrs) = nodes.

(** Semaphore pend_list 的调度/Delay 效果。节点从等待链直接转入
    READY，自持列表不变。保留原有 RRR 插入和 UnSetDelay 的 N/U/L 分支；
    desc 的 exstatus、优先级、时间片及 Delay 指针由 set_task_desc_ready
    保持。Semaphore 的具体来源由 wakeup_semaphore_head 补齐；
    Mutex/Event 分量作为 frame 保持。 *)
Record ktask_wakeup_pending_frame (task : addr) (desc : TaskDescriptorAbs)
    (before after : VarGlobalState) : Prop := {
  pending_wakeup_ready : assign_insert_step_ic
    before.(os_tasks).(task_desc_map) task desc
    before.(os_assign).(assignReadyVector) after.(os_assign).(assignReadyVector);
  pending_wakeup_task_map : after.(os_tasks).(task_desc_map) =
    update_task_desc_map task (set_task_desc_ready desc)
      before.(os_tasks).(task_desc_map);
  pending_wakeup_owned : after.(os_tasks).(sched_owned_tasks) =
    before.(os_tasks).(sched_owned_tasks);
  pending_wakeup_ids : after.(os_tasks).(task_idmanager_abs) =
    before.(os_tasks).(task_idmanager_abs);
  pending_wakeup_ptrs : after.(os_tasks).(task_ptr_list) = before.(os_tasks).(task_ptr_list);
  pending_wakeup_running : after.(os_assign).(assignRunningTask) =
    before.(os_assign).(assignRunningTask);
  pending_wakeup_priority : after.(os_assign).(assignCurrentPriority) =
    before.(os_assign).(assignCurrentPriority);
  pending_wakeup_delays : exists delay_after,
    ktask_unset_delay_step desc.(tdDelay) before delay_after /\
    after.(os_delays) = delay_after.(os_delays);
  pending_wakeup_events : after.(os_events) = before.(os_events);
  pending_wakeup_mutexes : after.(os_mutexes) = before.(os_mutexes);
  pending_wakeup_tick : after.(os_tick) = before.(os_tick);
  pending_wakeup_zombie : after.(zombie_queue) = before.(zombie_queue);
  pending_wakeup_recycle : after.(os_recycle) = before.(os_recycle);
  pending_wakeup_idle : after.(os_idle) = before.(os_idle);
  pending_wakeup_isr : after.(os_isr) = before.(os_isr);
  pending_wakeup_exstatus : after.(os_exstatus) = before.(os_exstatus)
}.

(** 直接从 sem->pend_list 摘除队首，其他 semaphore 对象逐个相等。
    sem_value 在本次 Wakeup 内不变；调用者的后续赋值另行描述。 *)
Definition wakeup_semaphore_head (sem task : addr)
    (desc : TaskDescriptorAbs) (before after : VarGlobalState) : Prop :=
  ktask_wakeup_pending_frame task desc before after /\
  exists old rest,
    In old before.(os_semaphores) /\ old.(semaphore_addr) = sem /\
    old.(semaphore_pending_addrs) = task :: rest /\
    after.(os_semaphores) = semaphore_set_pending sem rest before.(os_semaphores).

Definition ktask_wakeup_detached_null_condition
    (sg : StableGlobalState) (before : VarGlobalState) (id : Z) : Prop :=
  forall task desc,
    get_task_with_idnode_success sg before id task ->
    before.(os_tasks).(task_desc_map) task = Some desc ->
    desc.(tdDelay) = 0 /\
    (desc.(tdSchedMember).(tsmStat) = TSK_SUSPEND ->
      In task before.(os_tasks).(sched_owned_tasks)).

Record ktask_wakeup_detached_null_step (task : addr) (desc : TaskDescriptorAbs)
    (before after : VarGlobalState) : Prop := {
  wakeup_detached_ready : assign_insert_step_ic
    before.(os_tasks).(task_desc_map) task desc
    before.(os_assign).(assignReadyVector) after.(os_assign).(assignReadyVector);
  wakeup_detached_task_map : after.(os_tasks).(task_desc_map) =
    update_task_desc_map task (set_task_desc_ready desc)
      before.(os_tasks).(task_desc_map);
  wakeup_detached_owned : exists prefix suffix,
    before.(os_tasks).(sched_owned_tasks) = prefix ++ task :: suffix /\
    after.(os_tasks).(sched_owned_tasks) = prefix ++ suffix;
  wakeup_detached_task_ids : after.(os_tasks).(task_idmanager_abs) =
    before.(os_tasks).(task_idmanager_abs);
  wakeup_detached_task_ptrs : after.(os_tasks).(task_ptr_list) = before.(os_tasks).(task_ptr_list);
  wakeup_detached_running : after.(os_assign).(assignRunningTask) = before.(os_assign).(assignRunningTask);
  wakeup_detached_priority : after.(os_assign).(assignCurrentPriority) = before.(os_assign).(assignCurrentPriority);
  wakeup_detached_delays : after.(os_delays) = before.(os_delays);
  wakeup_detached_events : after.(os_events) = before.(os_events);
  wakeup_detached_mutexes : after.(os_mutexes) = before.(os_mutexes);
  wakeup_detached_semaphores : after.(os_semaphores) = before.(os_semaphores);
  wakeup_detached_tick : after.(os_tick) = before.(os_tick);
  wakeup_detached_zombie : after.(zombie_queue) = before.(zombie_queue);
  wakeup_detached_recycle : after.(os_recycle) = before.(os_recycle);
  wakeup_detached_idle : after.(os_idle) = before.(os_idle);
  wakeup_detached_isr : after.(os_isr) = before.(os_isr);
  wakeup_detached_exstatus : after.(os_exstatus) = before.(os_exstatus)
}.
