Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From AUXLib Require Import ListLib.
From SimpleC.SL Require Import Mem CNotation.
Require Export CRTOS_Verify.lib.CrtosConfig.
Require Export CRTOS_Verify.lib.dll_abs CRTOS_Verify.lib.idnode_abs.
Require Export CRTOS_Verify.lib.StructFieldOffsetAxiom.
Require Import Coq.Sorting.Sorted.
Require Export CRTOS_Verify.lib.TaskState CRTOS_Verify.lib.KTaskDelay.
Import KTaskCNotation ListNotations.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope list.

(** Delay 对象按 inactive map / active DLL 分区，空间层保证不重叠。 *)
Record DelayState : Type := {
  delay_inactive_map : addr -> option TaskDelayAbs;
  delay_active_nodes : list (DL_Node TaskDelayAbs)
}.

(**
  [delay_world_wf] 逐项列出 Delay 子状态在稳定点的纯一致性条件。
  参数分别为任务 descriptor map、inactive 自环对象 map 和 active DLL 顺序。
  每个独立条件都有具名字段；存在量中的合取把地址和 payload 关联到同一对象。

  [delay_inv] 中的 map/DLL 分离所有权排除同一 link 同时 active 和 inactive，
  因而非空指针字段中的析取表示恰好一个存放位置。外围对象的非空、对齐、
  字段范围，以及 inactive 状态和自环均由内存谓词保证，不在纯字段中重复。
  active 链表的排序和 ACTIVE 状态在下面分别列出，便于直接审阅。
*)
Record delay_world_wf
    (task_desc_map : addr -> option TaskDescriptorAbs)
    (delay_inactive_map : addr -> option TaskDelayAbs)
    (delay_active_nodes : list (DL_Node TaskDelayAbs)) : Prop := {
  (** task对应的delay 节点可能所处的状态 *)
  delay_wf_zero_or_not: forall task desc,
    task_desc_map task = Some desc ->
    desc.(tdDelay) = 0  \/
    (desc.(tdDelay) <> 0 /\
      exists info, info.(tdTaskPtr) = task /\
      (delay_inactive_map desc.(tdDelay) = Some info \/
       In (Build_DL_Node info (&(((desc.(tdDelay))) # "Delay" ->ₛ "link")))
          delay_active_nodes));

  (** 每个 inactive 对象都由其所属任务的 delay 字段引用。 *)
  delay_wf_inactive_owner : forall delay info,
    delay_inactive_map delay = Some info ->
    exists desc,
      task_desc_map info.(tdTaskPtr) = Some desc /\
      desc.(tdDelay) = delay;

  (** 每个 active 节点都对应其所属任务 delay 对象中的规范 link 地址。 *)
  delay_wf_active_owner : forall node,
    In node delay_active_nodes ->
    exists desc,
      task_desc_map (getData node).(tdTaskPtr) = Some desc /\
      getPtr node = &(((desc.(tdDelay))) # "Delay" ->ₛ "link");

  (** active 链表的任意前后项满足循环次序；不使用绝对 tick 数值排序。
      插入时还须建立包含当前 tick 和新 deadline 的共同时间窗口。 *)
  delay_wf_ticks_sorted :
    StronglySorted tick_not_after
      (map (fun node => (getData node).(tdTicks)) delay_active_nodes);

  (** active 链表中的每个对象都具有 ACTIVE 状态。 *)
  delay_wf_active_status :
    Forall (fun node => (getData node).(tdStatus) = TASK_DELAY_ACTIVE_VALUE)
      delay_active_nodes
}.

