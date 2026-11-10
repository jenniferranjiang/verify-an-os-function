(** KMutexDelete fresh experiment: 共享任务模型 os_inv 上的空间增量。 *)
Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.CrtosInv.
Require Export CRTOS_Verify.lib.IdModuleSpec.
Require Export KMutexDeleteTrial.lib.MutexState.

Import ListNotations DLL IDNode.
Local Open Scope Z_scope.
Local Open Scope string_scope.
Local Open Scope list_scope.
Local Open Scope sac.

(** 直接复用全局 mutex_inv、os_inv 及 mutex_create_frame。
    本文件只陈述删除操作需要的局部资源交接，不另定义模块或系统 invariant。 *)

(**
  IdRemoveObj 与管理 DLL remove 的真实 caller-local post：ID 和两个 link
  被返还为私有资源，其余 manager/list 已按 after 重建。
*)
Definition mutex_delete_detach_callee_post
    (sg : StableGlobalState) (p : addr) (removed : MutexAbs)
    (before after : VarGlobalState) : Assertion :=
  let stable := sg.(os_mutex_stable) in
  let sidm := stable.(mutex_manager_stable) in
  let manager := stable.(mutex_manager_ptr) in
  let idnode := &(p # "Mutex" ->ₛ "id") in
  let idlink := &(idnode # "IdNode" ->ₛ "link") in
  let object_link := &(p # "Mutex" ->ₛ "link") in
  let wait := pure_suspend_sched_link after.(os_tasks).(task_desc_map) in
  “ mutex_delete_find_addr p before.(os_mutexes) = Some removed /\
    removed.(mutex_addr) = p /\ removed.(mutex_pending_addrs) = nil /\
    mutex_field_offset_ok p /\
    after = replace_mutexes (mutex_delete_remove p before.(os_mutexes)) before /\
    mutex_manager after.(os_mutexes) =
      idmanager_remove sidm (mutex_manager before.(os_mutexes)) removed.(mutex_id) ” &&
  mutex_create_frame sg after **
  store_idmanager sidm (mutex_manager after.(os_mutexes)) manager **
  store_dll (store_mutex wait) stable.(mutex_list_head)
    (map mutex_link_node after.(os_mutexes)) **
  idnode # UShort |-> 65535 ** store_node_self_linked idlink **
  store_mutex wait object_link removed ** store_node_self_linked object_link.

Definition mutex_delete_detach_spatial_obligation : Prop :=
  forall sg p removed before after,
    mutex_delete_detach_callee_post sg p removed before after |--
    os_inv sg after ** MutexRaw p.

(** 合法已发布对象上的批量关系必须有后继。前提使用完整 os_inv，
    不把只有域覆盖的 os_world_wf 误当成 task/ready/delay 的完整良构性。
    这是待证明的设计义务，不是可供 Require 自动使用的公理。 *)
Definition mutex_delete_resume_nonvacuity_obligation : Prop :=
  forall sg p before,
    mutex_present p before ->
    os_inv sg before |--
      “ exists after, mutex_delete_resume_all_step p before after ” &&
      os_inv sg before.

(** 完整 invariant 提供 ready 数组长度/字段合法性等 pure world-wf
    不包含的条件；这些条件是批量更新保持世界一致性的必要依据。 *)
Definition mutex_delete_resume_preserves_world_obligation : Prop :=
  forall sg p before after,
    mutex_delete_resume_all_step p before after ->
    os_inv sg before |--
      “ os_world_wf sg after ” && os_inv sg before.

(** 完整 invariant 排除 active/inactive delay 重叠和非法 ready 布局；
    仅纯 os_world_wf 不足以把逐头执行轨迹精化为批量结果。 *)
Definition mutex_delete_resume_trace_obligation : Prop :=
  forall sg p before after mutex,
    mutex_delete_find_addr p before.(os_mutexes) = Some mutex ->
    mutex_delete_resume_waiters p mutex.(mutex_pending_addrs) before after ->
    os_inv sg before |--
      “ mutex_delete_resume_all_step p before after ” && os_inv sg before.

Check mutex_inv.
Check os_inv.

