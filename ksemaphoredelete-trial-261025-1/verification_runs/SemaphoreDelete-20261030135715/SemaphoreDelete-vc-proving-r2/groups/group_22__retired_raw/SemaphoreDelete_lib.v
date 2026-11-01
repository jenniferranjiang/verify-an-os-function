From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.
Require Import Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.KSemaphoreDelete.
Import DLL IDNode.
Local Open Scope string_scope.
Local Open Scope sac.

(** 删除中临时借出信号量模块时保留的其余系统内存。纯全局条件保留于
    当前状态，节点摘除后须根据更新后的 semaphore 序列重建。 *)
Definition delete_global_frame (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
  let wait := pure_suspend_sched_link st.(os_tasks).(task_desc_map) in
  “ os_world_wf sg st ” &&
  task_inv sg st ** tick_inv sg st ** delay_inv sg st ** assign_inv sg st **
  store_prio_lookup_table **
  store_zombie_queue st.(os_tasks).(task_desc_map) sg.(os_zombie_head) st.(zombie_queue) **
  sg.(os_recycler_slot) # Int |-> st.(os_recycle).(service_id) **
  IntArray.full sg.(os_idle_array) CORE_COUNT (map service_id st.(os_idle)) **
  mutex_inv wait sg.(os_mutex_stable) st.(os_mutexes) **
  msgqueue_inv wait sg.(os_msgqueue_stable) st.(os_msgqueues) **
  event_inv wait sg.(os_event_stable) st.(os_events) **
  isrmanager_inv sg.(os_isr_stable) st.(os_isr) ** exstatus_inv sg st.

(** ID manager 外的实际空间 frame。删除 manager 后仍可借出管理 DLL；
    不能用要求旧 manager 的 wand 隐藏这一步需要修改的外层链。 *)
Definition delete_manager_frame (sg : StableGlobalState) (st : VarGlobalState) : Assertion :=
  “ semaphore_context sg.(os_semaphore_stable) ” &&
  delete_global_frame sg st **
  store_dll (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map)))
    sg.(os_semaphore_stable).(semaphore_list_head)
    (map semaphore_link_node st.(os_semaphores)).

(** 判空只借用等待 DLL；归还相同资源后恢复同一 os_inv。 *)
Definition delete_pending_restore (sg : StableGlobalState) (st : VarGlobalState)
    (sem : addr) (waiting : list addr) : Assertion :=
  store_dll (pure_suspend_sched_link st.(os_tasks).(task_desc_map))
    (semaphore_pending_head sem) (map sched_link_node waiting) -* os_inv sg st.

(** 调用 IdRemoveObj 前读 ID；读出值后先归还字段，再借出完整 manager。
    此 wand 是空间资源，不是可以复制的纯蕴含。 *)
Definition delete_id_restore (sg : StableGlobalState) (st : VarGlobalState)
    (sem id : Z) : Assertion :=
  (&(sem # "Semaphore" ->ₛ "id" .ₛ "id") # UShort |-> id) -* os_inv sg st.

Lemma self_to_storage__retired_raw : forall p, p <> 0 ->
 store_node_self_linked p |-- NodeStorage p.
Proof.
 intros p Hp. unfold store_node_self_linked, NodeStorage.
 sep_apply_l_atomic (store_ptr_undef_store_ptr (&(p # "SysDoubleLinklistNode" ->ₛ "node_prev")) p).
 sep_apply_l_atomic (store_ptr_undef_store_ptr (&(p # "SysDoubleLinklistNode" ->ₛ "node_next")) p).
 split_pure_spatial; [cancel | dump_pre_spatial; exact Hp].
Qed.

Lemma retired_to_raw__retired_raw : forall p value, SemaphoreRetired p value |-- SemaphoreRaw p.
Proof.
 intros p value. unfold SemaphoreRetired.
 Intros_p H. destruct H as [Hp [Ha [Hi [Hpend Hlink]]]].
 sep_apply_l_atomic (self_to_storage__retired_raw (&(p # "Semaphore" ->ₛ "id" .ₛ "link")) Hi).
 sep_apply_l_atomic (self_to_storage__retired_raw (&(p # "Semaphore" ->ₛ "pend_list")) Hpend).
 sep_apply_l_atomic (self_to_storage__retired_raw (&(p # "Semaphore" ->ₛ "link")) Hlink).
 unfold store_idnode. Intros_p Hid.
 cbn [idnode_addr idnode_id].
 let q := constr:(&(p # "Semaphore" ->ₛ "id")) in
 assert (Hfield : &(q # "IdNode" ->ₛ "id") = &(p # "Semaphore" ->ₛ "id" .ₛ "id")) by
   (rewrite addr_of_arrow_field; rewrite eval_addr; reflexivity).
 rewrite Hfield.
 sep_apply_l_atomic (store_ushort_undef_store_ushort (&(p # "Semaphore" ->ₛ "id" .ₛ "id")) 65535).
 sep_apply_l_atomic (store_ushort_undef_store_ushort (&(p # "Semaphore" ->ₛ "value")) value).
 unfold SemaphorePadding.
 sep_apply_l_atomic (CharArray.full_to_undef_full (p+2) 2 (repeat_Z 0 2)).
 sep_apply_l_atomic (CharArray.full_to_undef_full (p+14) 2 (repeat_Z 0 2)).
 unfold SemaphoreRaw.
 split_pure_spatial; [repeat progress cancel | dump_pre_spatial; auto].
Qed.

