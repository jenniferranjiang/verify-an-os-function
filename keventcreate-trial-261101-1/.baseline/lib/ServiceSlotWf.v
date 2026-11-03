From Coq Require Import ZArith List Strings.String.
From SimpleC.SL Require Import Mem CNotation.
Require Export CRTOS_Verify.lib.CrtosGlobState.

Local Open Scope Z_scope.
Local Open Scope string_scope.

(** 已登记 recycler/idle 的纯生命周期约束；不额外拥有 descriptor、ID
    或 sched_link 内存。READY 由 ready 队列拥有；其余稳定状态自持。
    NULL Delay 约束整个登记生命期，使无延时挂起可由前态服务任务关系保持。 *)
Record recycler_idler_published_wf
    (core : VarGlobalState) (entry : addr) (os_service : ServiceSlotAbs)
    (task : addr) (desc : TaskDescriptorAbs) : Prop := {
  service_published_lookup : core.(os_tasks).(task_desc_map) task = Some desc;
  service_published_entry : desc.(tdBaseInfo).(tbFuncEntry) = entry;
  service_published_null_delay : desc.(tdDelay) = 0;
  service_published_nonready_owned :
    desc.(tdSchedMember).(tsmStat) <> TSK_READY ->
    In task core.(os_tasks).(sched_owned_tasks);
  service_published_id : exists node,
    In node (task_id_nodes core) /\
    node.(idnode_addr) = &(task # "TaskDescriptor" ->ₛ "id") /\
    node.(idnode_id) = os_service.(service_id)
}.
