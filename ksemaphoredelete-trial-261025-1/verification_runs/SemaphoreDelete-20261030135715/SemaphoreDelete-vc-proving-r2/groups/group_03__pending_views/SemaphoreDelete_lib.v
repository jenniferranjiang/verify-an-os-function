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

Lemma dllseg_focus__pending_views {A : Type} (storeA : addr -> A -> Assertion)
    (l : list (DL_Node A)) (node : DL_Node A) :
  In node l -> forall x px y py,
  dllseg storeA x px y py l |--
  storeA node.(ptr) node.(data) **
  (storeA node.(ptr) node.(data) -* dllseg storeA x px y py l).
Proof.
  induction l as [|a tail IH]; intros Hin x px y py.
  - contradiction.
  - destruct Hin as [Heq|Hin].
    + subst a. cbn [dllseg]. Intros next. subst x.
      cancel.
      apply_sepcon_adjoint. Exists next.
      split_pure_spatial; [sepcon_assoc_change; cancel | split_pures; dump_pre_spatial; reflexivity].
    + cbn [dllseg]. Intros next. subst x.
      fold (dllseg storeA next (getPtr a) y py tail).
      sep_apply_l_atomic (IH Hin next (getPtr a) y py).
      cancel.
      apply_sepcon_adjoint.
      sep_apply_l_atomic (derivable1_wand_elim1
        (storeA (getPtr node) (getData node)) (dllseg storeA next (getPtr a) y py tail)).
      Exists next.
      fold (dllseg storeA next (getPtr a) y py tail).
      split_pure_spatial; [sepcon_assoc_change; cancel | split_pures; dump_pre_spatial; reflexivity].
Qed.

Lemma dll_focus__pending_views {A : Type} (storeA : addr -> A -> Assertion)
    (l : list (DL_Node A)) (node : DL_Node A) :
  In node l -> forall head,
  store_dll storeA head l |-- storeA node.(ptr) node.(data) **
    (storeA node.(ptr) node.(data) -* store_dll storeA head l).
Proof.
  intros Hin head. unfold store_dll at 1. Intros h last.
  sep_apply_l_atomic (dllseg_focus__pending_views storeA l node Hin h head head last).
  cancel. apply_sepcon_adjoint.
  sep_apply_l_atomic (derivable1_wand_elim1
    (storeA node.(ptr) node.(data)) (dllseg storeA h head head last l)).
  unfold store_dll. Exists h last.
  split_pure_spatial.
  - sepcon_assoc_change; cancel.
  - split_pures; dump_pre_spatial; tauto.
Qed.

Lemma semaphore_payload_pending__pending_views wait link sem :
  store_semaphore wait link sem |--
  store_dll wait (semaphore_pending_head sem.(semaphore_addr))
    (map sched_link_node sem.(semaphore_pending_addrs)) **
  (store_dll wait (semaphore_pending_head sem.(semaphore_addr))
    (map sched_link_node sem.(semaphore_pending_addrs)) -* store_semaphore wait link sem).
Proof.
  unfold store_semaphore at 1. Intros.
  change (map semaphore_wait_node (semaphore_pending_addrs sem)) with
    (map sched_link_node (semaphore_pending_addrs sem)).
  unfold semaphore_pending_head. sepcon_assoc_change; cancel.
  apply_sepcon_adjoint. unfold store_semaphore.
  change (map semaphore_wait_node (semaphore_pending_addrs sem)) with
    (map sched_link_node (semaphore_pending_addrs sem)).
  split_pure_spatial.
  - sepcon_assoc_change; cancel.
  - split_pures; dump_pre_spatial; tauto.
Qed.

Lemma os_inv_payload_focus__pending_views sg st original :
  In original st.(os_semaphores) ->
  os_inv sg st |--
  store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map))
    (&(((original.(semaphore_addr))) # "Semaphore" ->ₛ "link")) original **
  (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map))
    (&(((original.(semaphore_addr))) # "Semaphore" ->ₛ "link")) original -* os_inv sg st).
Proof.
  intro Hin. unfold os_inv at 1. Intros.
  unfold semaphore_inv at 1. Intros.
  pose proof (in_map semaphore_link_node _ _ Hin) as Hnode.
  sep_apply_l_atomic (dll_focus__pending_views
    (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map)))
    (map semaphore_link_node st.(os_semaphores))
    (semaphore_link_node original) Hnode
    sg.(os_semaphore_stable).(semaphore_list_head)).
  cbn [semaphore_link_node getPtr getData].
  sepcon_assoc_change; cancel. apply_sepcon_adjoint.
  sep_apply_l_atomic (derivable1_wand_elim1
    (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map))
      (&(((original.(semaphore_addr))) # "Semaphore" ->ₛ "link")) original)
    (store_dll (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map)))
      sg.(os_semaphore_stable).(semaphore_list_head)
      (map semaphore_link_node st.(os_semaphores)))).
  unfold os_inv, semaphore_inv.
  split_pure_spatial.
  - sepcon_assoc_change; cancel.
  - split_pures; dump_pre_spatial; tauto.
Qed.

Lemma pending_dll_focus__pending_views sg st original p :
  In original st.(os_semaphores) -> p = original.(semaphore_addr) ->
  os_inv sg st |--
  store_dll (pure_suspend_sched_link st.(os_tasks).(task_desc_map))
    (semaphore_pending_head p) (map sched_link_node original.(semaphore_pending_addrs)) **
  delete_pending_restore sg st p original.(semaphore_pending_addrs).
Proof.
  intros Hin Hp. subst p.
  sep_apply_l_atomic (os_inv_payload_focus__pending_views sg st original Hin).
  remember (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map))
    (&(((original.(semaphore_addr))) # "Semaphore" ->ₛ "link")) original -* os_inv sg st)
    as restore eqn:Hrestore.
  sep_apply_l_atomic (semaphore_payload_pending__pending_views
    (pure_suspend_sched_link st.(os_tasks).(task_desc_map))
    (&(((original.(semaphore_addr))) # "Semaphore" ->ₛ "link")) original).
  subst restore.
  sepcon_assoc_change; cancel. unfold delete_pending_restore.
  apply_sepcon_adjoint.
  sep_apply_l_atomic (derivable1_wand_elim1
    (store_dll (pure_suspend_sched_link st.(os_tasks).(task_desc_map))
      (semaphore_pending_head original.(semaphore_addr))
      (map sched_link_node original.(semaphore_pending_addrs)))
    (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map))
      (&(((original.(semaphore_addr))) # "Semaphore" ->ₛ "link")) original)).
  sep_apply_l_atomic (derivable1_wand_elim1
    (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map))
      (&(((original.(semaphore_addr))) # "Semaphore" ->ₛ "link")) original)
    (os_inv sg st)).
  cancel.
Qed.
