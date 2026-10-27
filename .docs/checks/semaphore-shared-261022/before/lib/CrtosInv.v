Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
Require Import Coq.Sorting.Permutation Coq.Sorting.Sorted Coq.micromega.Lia.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.CrtosRules.
Require Export CRTOS_Verify.lib.dll CRTOS_Verify.lib.idnode.
Require Export CRTOS_Verify.lib.TaskInv CRTOS_Verify.lib.AssignInv.
Require Export CRTOS_Verify.lib.DelayInv CRTOS_Verify.lib.TickInv.
Require Export CRTOS_Verify.lib.ExstatusInv CRTOS_Verify.lib.Bitmap.
Require Export CRTOS_Verify.lib.MutexInv CRTOS_Verify.lib.EventInv.
Require Export CRTOS_Verify.lib.MsgQueueInv CRTOS_Verify.lib.IsrManagerInv.
Import ListNotations DLL IDNode.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope list.
Local Open Scope sac.

(** 调度节点的拥有者由可变自持列表和实际队列汇总，不再查询管理链。
    各列表顺序保留在各自状态中；该串接只用于全局覆盖和互斥检查。 *)
Definition os_sched_owners (st : VarGlobalState) : list addr :=
  st.(os_tasks).(sched_owned_tasks) ++
  map (@getData addr)
    (os_ready_nodes st.(os_assign).(assignReadyVector).(orvBuckets)) ++
  map (@getData addr) (zombie_nodes st.(zombie_queue)) ++
  mutex_waiters st.(os_mutexes) ++
  msgqueue_waiters st.(os_msgqueues) ++ event_waiters st.(os_events).

(** 一个计数条件同时表达：已发布任务恰有一个 sched_link 所有者，未发布
    任务没有全局调度节点。无需另加 NoDup、两两不交或 owner 属于管理链：
    前两者由计数推出，后者由 task_wf_map_present 推出。容器各自的状态
    检查使 INIT/RUNNING 只能自持、CLOSE 只能在 zombie，SUSPEND 恰在
    自持列表或一个 pend_list 中。角色关系不把锁外回收对象视为已发布。 *)
Record os_world_wf (sg : StableGlobalState) (st : VarGlobalState) : Prop := {
  os_wf_context : os_global_context sg;
  os_wf_recycler : role_slot_wf st sg.(os_recycler_entry) st.(os_recycle);
  os_wf_idle : Forall (role_slot_wf st sg.(os_idle_entry)) st.(os_idle);
  os_wf_sched_coverage : forall task,
    count_occ Z.eq_dec (os_sched_owners st) task =
    match st.(os_tasks).(task_desc_map) task with
    | Some _ => 1%nat
    | None => 0%nat
    end
}.

(**
  当前范围内的资源组合（msg_buf 缓冲区暂缓）。包含统一任务字段和独立调度节点；每个
  模块只出现一次，三条 IPC 接口固定使用同一 task map 的纯等待关联。
  Bitmap 表在此唯一持有；Assign padding 只在 assign_inv 内。
  ISR/exstatus 的普通锁外访问、静态函数表读取及锁外回收仍有协议义务。
*)
Definition os_inv (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
  let wait := pure_suspend_sched_link st.(os_tasks).(task_desc_map) in
  “ os_world_wf sg st ” &&
  task_inv sg st **
  tick_inv sg st **
  delay_inv sg st **
  assign_inv sg st **
  store_prio_lookup_table **
  store_zombie_queue st.(os_tasks).(task_desc_map)
    sg.(os_zombie_head) st.(zombie_queue) **
  sg.(os_recycler_slot) # Int |-> st.(os_recycle).(role_id) **
  IntArray.full sg.(os_idle_array) CORE_COUNT (map role_id st.(os_idle)) **
  mutex_inv wait sg.(os_mutex_stable) st.(os_mutexes) **
  msgqueue_inv wait sg.(os_msgqueue_stable) st.(os_msgqueues) **
  event_inv wait sg.(os_event_stable) st.(os_events) **
  isrmanager_inv sg.(os_isr_stable) st.(os_isr) **
  exstatus_inv sg st.

(** 定义域、唯一性与管理链包含关系都是总覆盖的推论，不重复存入 Record。 *)
Lemma os_sched_owners_domain : forall sg st task,
  os_world_wf sg st ->
  (In task (os_sched_owners st) <->
   st.(os_tasks).(task_desc_map) task <> None).
Proof.
  intros sg st task Hwf.
  rewrite (count_occ_In Z.eq_dec), (os_wf_sched_coverage sg st Hwf).
  destruct (task_desc_map (os_tasks st) task); split; intros; try discriminate;
    try lia; contradiction.
Qed.

Lemma os_sched_owners_nodup : forall sg st,
  os_world_wf sg st -> NoDup (os_sched_owners st).
Proof.
  intros sg st Hwf.
  apply (proj2 (NoDup_count_occ Z.eq_dec _)).
  intro task; rewrite (os_wf_sched_coverage sg st Hwf).
  destruct (task_desc_map (os_tasks st) task); lia.
Qed.

Lemma os_sched_owners_in_task_list : forall sg st task,
  task_world_wf st -> os_world_wf sg st ->
  In task (os_sched_owners st) -> In task st.(os_tasks).(task_ptr_list).
Proof.
  intros sg st task Htask Hos Hin.
  apply (proj1 (os_sched_owners_domain sg st task Hos)) in Hin.
  destruct (task_desc_map (os_tasks st) task) as [desc |] eqn:Hlookup;
    [eapply task_wf_map_present; eauto | contradiction].
Qed.

(** 对任意状态都排除自持/等待重叠；对 SUSPEND 与容器状态条件合用即为二选一。 *)
Lemma sched_owned_not_waiting : forall sg st task,
  os_world_wf sg st -> In task st.(os_tasks).(sched_owned_tasks) ->
  ~ In task (mutex_waiters st.(os_mutexes) ++
             msgqueue_waiters st.(os_msgqueues) ++
             event_waiters st.(os_events)).
Proof.
  intros sg st task Hwf Howned Hwait.
  pose proof (os_sched_owners_nodup sg st Hwf) as Hunique.
  unfold os_sched_owners in Hunique.
  apply in_split in Howned as [left [right Howned]].
  rewrite Howned, <- app_assoc in Hunique.
  apply NoDup_remove_2 in Hunique.
  apply Hunique.
  apply in_or_app; right; apply in_or_app; right.
  apply in_or_app; right; apply in_or_app; right; exact Hwait.
Qed.

