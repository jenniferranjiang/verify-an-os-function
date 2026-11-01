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

Require Import Coq.micromega.Lia.

Lemma delete_miss_continuation__lookup_miss : forall sg id before st X,
  id >= 0 -> Crtos_RTrans before st ->
  idmanager_query (semaphore_manager st.(os_semaphores))
    (unsigned_last_nbits id 16) = false ->
  monadesafe_lib.safeExec (LastSeen before) (abs_semaphore_delete sg id) X ->
  monadesafe_lib.safeExec (LastSeen st) (MonadErr.ret tt) X.
Proof.
  intros sg id before st X Hid Hrel Hquery Hexec.
  assert (Hmiss : forall sem, In sem st.(os_semaphores) ->
      sem.(semaphore_id) <> semaphore_query_id id).
  { unfold idmanager_query, semaphore_manager in Hquery; simpl in Hquery.
    apply id_in_ids_false_iff in Hquery.
    intros sem Hin Heq. apply Hquery.
    change (In (semaphore_query_id id) (map semaphore_id (os_semaphores st))).
    rewrite <- Heq. apply in_map. exact Hin. }
  unfold abs_semaphore_delete in Hexec.
  prog_nf in Hexec.
  assert (Hnonneg : (Z.ltb id 0) = false) by (apply Z.ltb_ge; lia).
  rewrite Hnonneg in Hexec.
  eapply (monadesafe_lib.highstepbind_derive
    (task_atomic_cmd (abs_semaphore_delete_locked id))
    (fun resched => if resched then abs_ktask_assign else MonadErr.ret tt)
    (LastSeen before) false (LastSeen st)).
  - intros states Hstates. exists (Crtos_RTrans st). split.
    + exists st, st. split.
      * apply (proj2 (Hstates st)). exact Hrel.
      * split; [exists 0; left; repeat split; auto | intro state; split; auto].
    + intro state; split; auto.
  - exact Hexec.
Qed.
