Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem CNotation.
Require Export CRTOS_Verify.lib.task.KTaskSuspend.
Import ListNotations KTaskCNotation.
Local Open Scope Z_scope.
Local Open Scope string_scope.
Local Open Scope list_scope.

(** 排除已登记服务任务；其非READY节点必须自持，不能移交IPC等待链。 *)
Definition ktask_not_os_service (task : addr) (st : VarGlobalState) : Prop :=
 st.(os_recycle).(service_phase) <> ServiceRegistered task /\
 Forall (fun slot => slot.(service_phase) <> ServiceRegistered task) st.(os_idle).

(** 沿用VRTOS合法flag的挂起及优先级插入语义；未知flag在当前源码提前失败。 *)
Definition linklist_suspend_admissible
    (task flag : Z) (before : VarGlobalState) : Prop :=
  exists desc,
    before.(os_tasks).(task_desc_map) task = Some desc /\
    ((flag = 0 \/ flag = 1) ->
      ktask_not_os_service task before /\
      ((task = before.(os_assign).(assignRunningTask) /\
        (desc.(tdSchedMember).(tsmStat) = TSK_READY \/
         desc.(tdSchedMember).(tsmStat) = TSK_RUNNING))
       \/
       (desc.(tdSchedMember).(tsmStat) = TSK_SUSPEND /\
        In task before.(os_tasks).(sched_owned_tasks)))).

(** 首个严格较低优先级的位置。已扫描前缀中的相等优先级留在新节点
    前面；停止后不读取 suffix 的其余元素。不要求原等待链整体有序。
    task 固定规范 sched_link，并由 descs 查询待插入任务的当前优先级。
    RRR 的既有插入关系比较剩余时间片，不能替代这里的优先级比较。 *)

(* cc: 数字越大，优先级越高，优先级从高到低。 *)
Definition linklist_priority_insert
    (descs : addr -> option TaskDescriptorAbs)
    (task : addr) (nodes_bef nodes_aft : list (DL_Node addr)) : Prop :=
  exists desc prefix suffix,
    descs task = Some desc /\
    nodes_bef = prefix ++ suffix /\
    nodes_aft = prefix ++ sched_link_node task :: suffix /\
    Forall (fun node => exists other,
      descs (getData node) = Some other /\
      desc.(tdSchedMember).(tsmCurPrio) <= other.(tdSchedMember).(tsmCurPrio)) prefix /\
    match suffix with
    | [] => True
    | first :: _ => exists other,
        descs (getData first) = Some other /\
        other.(tdSchedMember).(tsmCurPrio) < desc.(tdSchedMember).(tsmCurPrio)
    end.



(** 信号量只替换等待地址序列，地址、ID、value和管理顺序均保持。 *)
Definition semaphore_enqueue_state (sem : addr) (waiting : list addr)
 (before : VarGlobalState) : VarGlobalState :=
 replace_semaphores
  (map (fun s => if Z.eq_dec s.(semaphore_addr) sem then
    {| semaphore_addr := s.(semaphore_addr); semaphore_id := s.(semaphore_id);
       semaphore_value := s.(semaphore_value); semaphore_pending_addrs := waiting |}
    else s) before.(os_semaphores)) before.

(** 已挂起任务的自环sched_link转交给一个信号量；其他资源精确frame。
    顺序序列保存任务地址，空间仍使用SemaphoreInv中的规范sched_link。 *)
Definition linklist_semaphore_enqueue (sem task : addr) (flag : Z)
 (before after : VarGlobalState) : Prop :=
 exists s desc nodes,
  In s before.(os_semaphores) /\ s.(semaphore_addr) = sem /\
  before.(os_tasks).(task_desc_map) task = Some desc /\
  desc.(tdSchedMember).(tsmStat) = TSK_SUSPEND /\
  In task before.(os_tasks).(sched_owned_tasks) /\
  ((flag = 0 /\ nodes = map sched_link_node (s.(semaphore_pending_addrs) ++ [task])) \/
   (flag = 1 /\ linklist_priority_insert before.(os_tasks).(task_desc_map) task
     (map sched_link_node s.(semaphore_pending_addrs)) nodes)) /\
  after = replace_sched_owned_tasks
    (remove Z.eq_dec task before.(os_tasks).(sched_owned_tasks))
    (semaphore_enqueue_state sem (map (@getData addr) nodes) before).

(** 合法分支忽略SuspendKTask返回值再插入；非法flag提前返回-10且不挂起。 *)
Definition linklist_suspend_step (sem task flag : Z)
 (before : VarGlobalState) (result : Z) (after : VarGlobalState) : Prop :=
 ((flag <> 0 /\ flag <> 1) /\ result = -10 /\ after = before) \/
 ((flag = 0 \/ flag = 1) /\ result = 0 /\ exists staged ignored,
  ktask_suspend_step task before ignored staged /\
  linklist_semaphore_enqueue sem task flag staged after).

(** Obtain固定PRIO=1；本接口来自新写信号量场景规格，不冒充旧Msg/Event契约特化。 *)
Definition linklist_suspend_prio (sem task : Z) (before after : VarGlobalState) : Prop :=
 linklist_suspend_step sem task 1 before 0 after.
