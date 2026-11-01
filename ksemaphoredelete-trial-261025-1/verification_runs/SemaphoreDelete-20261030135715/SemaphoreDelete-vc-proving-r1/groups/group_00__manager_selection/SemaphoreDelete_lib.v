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


Lemma resume_keeps_semaphore_fields__manager_selection :
  forall p original before after,
    In original before.(os_semaphores) ->
    p = original.(semaphore_addr) ->
    semaphore_resume_all_effect p original.(semaphore_pending_addrs) before after ->
    exists current,
      In current after.(os_semaphores) /\
      current.(semaphore_addr) = p /\
      current.(semaphore_id) = original.(semaphore_id) /\
      current.(semaphore_value) = original.(semaphore_value) /\
      current.(semaphore_pending_addrs) = nil.
Proof.
  intros p original before after Hin Hp Heffect.
  subst p.
  unfold semaphore_resume_all_effect in Heffect.
  destruct (semaphore_pending_addrs original) as [|task tail] eqn:Hpending.
  - subst after. exists original. repeat split; assumption || reflexivity.
  - destruct Heffect as [_ [_ [ready [_ Hafter]]]].
    subst after.
    exists (semaphore_created original.(semaphore_addr)
      original.(semaphore_id) original.(semaphore_value)).
    split.
    + cbn [replace_semaphores]. unfold semaphore_set_pending.
      apply in_map_iff. exists original. split; [|exact Hin].
      destruct (Z.eq_dec (semaphore_addr original) (semaphore_addr original));
        [reflexivity | contradiction].
    + repeat split; reflexivity.
Qed.

Lemma manager_ids_nodup__manager_selection : forall sm m p,
  store_idmanager sm m p |-- “ NoDup m.(idlist) ”.
Proof.
  intros sm m p. unfold store_idmanager.
  Intros_p Hbucket.
  dump_pre_spatial. unfold idbuckets_ok, idlist_ok in Hbucket.
  tauto.
Qed.

Lemma os_inv_manager_view__manager_selection : forall sg st,
  os_inv sg st |--
    “ NoDup (map semaphore_id st.(os_semaphores)) ” &&
    store_idmanager sg.(os_semaphore_stable).(semaphore_manager_stable)
      (semaphore_manager st.(os_semaphores)) (&("k_sem_id_manager")) **
    delete_manager_frame sg st.
Proof.
  intros sg st.
  unfold os_inv, semaphore_inv, delete_manager_frame, delete_global_frame.
  Intros_p Hworld. Intros_p Hcontext.
  prop_apply_p (manager_ids_nodup__manager_selection
    sg.(os_semaphore_stable).(semaphore_manager_stable)
    (semaphore_manager st.(os_semaphores))
    sg.(os_semaphore_stable).(semaphore_manager_ptr)).
  Intros_p Hnodup.
  change (NoDup (map semaphore_id st.(os_semaphores))) in Hnodup.
  pose proof (proj1 Hcontext) as Hptr.
  rewrite Hptr.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; tauto.
Qed.
