Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem CNotation.
Require Export CRTOS_Verify.lib.task.KTaskWakeup.
From SimpleC.StrategyLib Require Import Mapping.
Import ListNotations KTaskCNotation.
Local Open Scope Z_scope.
Local Open Scope string_scope.

(** 从 VRTOS KTaskSetDelay 的纯语义移植；适配当前全局状态，保持 dataqueue。未导入其 C 证明。 *)
Definition delay_list_window
    (now : Z) (nodes : list (DL_Node TaskDelayAbs)) : Prop :=
  tick_window now
    (map (fun node => (getData node).(tdTicks)) nodes).

(**
  在第一个满足 C 半区间比较且不相等的节点前插入，否则继续或尾插。
  相等 deadline 的旧节点仍在新节点之前，精确对应 continue 分支。
*)
Fixpoint delay_insert_by_ticks
    (inserted : DL_Node TaskDelayAbs)
    (nodes : list (DL_Node TaskDelayAbs)) : list (DL_Node TaskDelayAbs) :=
  match nodes with
  | nil => inserted :: nil
  | current :: rest =>
      if tick_beforeb
           (getData inserted).(tdTicks)
           (getData current).(tdTicks)
      then inserted :: current :: rest
      else current :: delay_insert_by_ticks inserted rest
  end.

(**
  旧证明使用的纯地址投影，与 C 字段/符号一致，不拥有内存。
  当前独立头文件已能直接使用字段地址，for_null_inactive 不再需要这些投影。
*)
Definition task_delay_pointer_addr (task : addr) : addr :=
  &(task # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay").

Definition task_delay_head_addr : addr := &("xiaoshan_delay_head").

(**
  [replace_descriptor_delay delay desc] 只替换 TaskDescriptor 的 delay 指针。
  栈、基础信息、调度成员、事件字段、exstatus 和 Done 均从原描述符复制。
  这是纯抽象值更新，不拥有内存；for_null_inactive 只接收该指针槽的
  store_ptr，其他 descriptor 字段保留在调用者的 frame 中。
*)
Definition replace_descriptor_delay
    (delay : addr)
    (desc : TaskDescriptorAbs) : TaskDescriptorAbs :=
  {|
    tdStackPoint := desc.(tdStackPoint);
    tdStackRaw := desc.(tdStackRaw);
    tdStackContext := desc.(tdStackContext);
    tdBaseInfo := desc.(tdBaseInfo);
    tdSchedMember := desc.(tdSchedMember);
    tdDelay := delay;  (* <-- Update *)
    tdEventIdTrigger := desc.(tdEventIdTrigger);
    tdEventMode := desc.(tdEventMode);
    tdExstatus := desc.(tdExstatus);
    tdDone := desc.(tdDone)
  |}.

(**
  [replace_delay_inactive_map inactive st_before] 只替换 inactive Delay map。
  其余可变全局分量（包括 IPC/ISR 与服务任务）直接复制。该函数本身不表示一次 C 操作，也不声称
  单独更新 map 后已经恢复良构性；完整状态更新与空间后置统一负责这一点。
*)
Definition replace_delay_inactive_map
    (inactive : addr -> option TaskDelayAbs)
    (st_before : VarGlobalState) : VarGlobalState :=
  {|
    os_tasks := st_before.(os_tasks);
    os_tick := st_before.(os_tick);
    os_delays := {| delay_inactive_map := inactive; delay_active_nodes := st_before.(os_delays).(delay_active_nodes) |};
    os_assign := st_before.(os_assign);
    zombie_queue := st_before.(zombie_queue);
    os_recycle := st_before.(os_recycle);
    os_idle := st_before.(os_idle);
    os_semaphores := st_before.(os_semaphores);
    os_mutexes := st_before.(os_mutexes);
    os_dataqueues := st_before.(os_dataqueues);
    os_events := st_before.(os_events);
    os_isr := st_before.(os_isr);
    os_exstatus := st_before.(os_exstatus)
  |}.

(**
  [replace_delay_active_nodes active st_before] 只替换 active Delay DLL 序列。
  序列记录 Delay payload 及其嵌入 link 的地址；实际双向链表所有权仍由
  [delay_inv] 解释。其他全局分量均从传入状态复制。
*)
Definition replace_delay_active_nodes
    (active : list (DL_Node TaskDelayAbs))
    (st_before : VarGlobalState) : VarGlobalState :=
  {|
    os_tasks := st_before.(os_tasks);
    os_tick := st_before.(os_tick);
    os_delays := {| delay_inactive_map := st_before.(os_delays).(delay_inactive_map); delay_active_nodes := active |};
    os_assign := st_before.(os_assign);
    zombie_queue := st_before.(zombie_queue);
    os_recycle := st_before.(os_recycle);
    os_idle := st_before.(os_idle);
    os_semaphores := st_before.(os_semaphores);
    os_mutexes := st_before.(os_mutexes);
    os_dataqueues := st_before.(os_dataqueues);
    os_events := st_before.(os_events);
    os_isr := st_before.(os_isr);
    os_exstatus := st_before.(os_exstatus)
  |}.

(**
  [ktask_set_delay_updated_state] 从 for_null_inactive 的前态构造成功后态。
  [desc] 由调用前置的 descriptor map 命中等式绑定；
  [delay_after] 是复用或新分配的 Delay 地址，不是额外的调用前状态。

  [delay_ticks] 对应 C 形参 ticks，表示本次请求的延迟时长；
  [st_before.(os_tick)] 对应 CurrentTicksGain() 读取的 heartbeat。
  二者是不同输入，C 实际写入的是当前 heartbeat 加上请求时长，
  因此不能用当前 heartbeat 代替 delay_ticks。

  只对三个实际改变的分量应用 replace：目标 descriptor 的 delay 指针、
  inactive map、active DLL。其他任务的 map cell、目标任务的其他字段、
  ID 管理器、任务地址链表、heartbeat 与 Assign 自然保持原值。

  目标对象从 inactive map 移除：复用 total_mapping_update 将对应值设为
  None，其余键保持原值。更新后的 TaskDelayAbs 插入原 active 列表。
  NULL/inactive 前置与 delay_inv 的分离性保证目标不在该列表中，
  不再用 delay_remove_old 描述不可达的 active 重设分支。插入使用
  C 的模减法半区间比较，并先跳过相等项，因此旧相等节点仍在前。
  TaskDelayAbs 对应 C 的 task/ticks/status 三条写入，到期值按 uint32
  加法回绕。DLL 中相邻节点的 link 写入由新的序列解释。
*)
Definition ktask_set_delay_updated_state
    (task delay_ticks : Z)
    (desc : TaskDescriptorAbs)
    (delay_after : addr)
    (st_before : VarGlobalState) : VarGlobalState :=
  replace_delay_active_nodes
    (delay_insert_by_ticks
      (Build_DL_Node
        (mkTaskDelayAbs task
          (tick_add st_before.(os_tick) delay_ticks)
          TASK_DELAY_ACTIVE_VALUE)
        (&(delay_after # "Delay" ->ₛ "link")))
      st_before.(os_delays).(delay_active_nodes))
    (replace_delay_inactive_map
      (total_mapping_update
        st_before.(os_delays).(delay_inactive_map) delay_after None)
      (replace_task_desc_map
        (update_task_desc_map task
          (replace_descriptor_delay delay_after desc)
          st_before.(os_tasks).(task_desc_map))
        st_before)).

(**
  [ktask_set_delay_step] 专用于 for_null_inactive 的精确纯状态关系，独立于
  旧局部资源规格。合法时长和 NULL/inactive Delay 由调用前置约束，
  本关系不重复时长范围；成功时直接向原 active 列表插入。
  本关系须与该前置一起使用，不单独描述 active 重设或超长请求。
  [desc] 是调用前置已经绑定的同一个描述符；使用本关系时必须
  已有 st_before.(os_tasks).(task_desc_map) task = Some desc。
  不重新引入描述符存在量或重复前态 map 命中等式。
  [delay_after] 是显式输出参数，与 Ensure 中 store_ptr 使用同一个见证；
  成功时精确状态更新已保证后态 map 命中 replace_descriptor_delay，
  不再重复该等式。失败时既保持原态，也显式令输出指针为零；结合前态
  命中等式和 desc.(tdDelay) = 0，同样可推出后态 map 与输出指针对应。

  超长请求由独立 tick_out_of_bound Spec 描述，不在本关系中增加不可达
  的 -INVALID 分支。合法时长且原 delay 为零时，x_malloc 可以失败并返回
  C 的 -ENOMEMORY（Rocq 常量 -5），整个共享状态保持。
  成功分支直接要求输出地址非空，已有非空对象原址复用，并执行确定的
  replace 组合；已有非空对象不执行分配，因此没有分配失败分支。
  allocator 容量没有纳入 VarGlobalState，本关系保留分配失败的可能性。
  新分配块与已有对象的分离仍由分配器规格和空间不变量建立，不另建
  allocator 状态或把这些空间义务当作额外调用前提。

  此关系不包含后态良构性或临界区 guarantee 假设；对应义务必须由函数体
  和调用前空间资源建立。成功分支的后态必须恰好等于 replace 组合的结果，
  没有额外自由分量；只替换该调用实际修改的三个全局状态分量。
*)
Definition ktask_set_delay_step
    (task : Z)
    (desc : TaskDescriptorAbs)
    (delay_ticks : Z)
    (delay_after : addr)
    (st_before : VarGlobalState)
    (result : Z)
    (st_after : VarGlobalState) : Prop :=
  (result = -5 /\ desc.(tdDelay) = 0 /\
   delay_after = 0 /\ st_after = st_before) \/
  (result = 0 /\ delay_after <> 0 /\
   (desc.(tdDelay) <> 0 -> delay_after = desc.(tdDelay)) /\
   st_after =
     ktask_set_delay_updated_state
       task delay_ticks desc delay_after st_before).
(* 以 delay_ticks delay_after 更新st_before*)
