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

Lemma semaphore_bucket_member__lookup_views : forall sems bucket node,
  In bucket (idbuckets (semaphore_manager sems)) -> In node bucket ->
  exists sem, In sem sems /\ semaphore_idnode sem = node.
Proof.
  intros sems bucket node Hb Hn.
  unfold semaphore_manager in Hb; cbn [idbuckets] in Hb.
  apply in_map_iff in Hb as [i [Hb Hi]]. subst bucket.
  apply in_map_iff in Hn as [sem [Heq Hsem]].
  apply filter_In in Hsem as [Hin _]. eauto.
Qed.

Lemma semaphore_found_member__lookup_views : forall sg st manager node id,
  store_idmanager_found (semaphore_manager_stable sg)
    (semaphore_manager st) manager node id |--
  “ exists sem, In sem st /\ semaphore_id sem = id /\
      node = &(((semaphore_addr sem)) # "Semaphore" ->ₛ "id") ”.
Proof.
  intros sg st manager node id. unfold store_idmanager_found.
  Intros bytes prefix suffix bucket. rename H into Hfound.
  destruct Hfound as [Hr [Hm [Hb [Hbucket Hsplit]]]].
  assert (Hindex : 0 <= id mod hoffset (semaphore_manager_stable sg) <
    Zlength (idbuckets (semaphore_manager st))).
  { destruct Hb as [Hpos [Hlen Hb]]. rewrite Hlen.
    apply Z.mod_pos_bound; exact Hpos. }
  pose proof (Znth_In_Zlength (idbuckets (semaphore_manager st)) nil
    (id mod hoffset (semaphore_manager_stable sg)) Hindex) as Hin.
  rewrite <- Hbucket in Hin.
  assert (Hnode : In (Build_IdNodeAbs id node) bucket).
  { rewrite Hsplit. apply in_or_app. right. simpl; auto. }
  destruct (semaphore_bucket_member__lookup_views st bucket
    (Build_IdNodeAbs id node) Hin Hnode) as [sem [Hsem Heq]].
  unfold semaphore_idnode in Heq. inversion Heq.
  dump_pre_spatial. exists sem. auto.
Qed.

Lemma semaphore_segment_nonzero__lookup_views : forall wait sems sem x px y py,
  In sem sems ->
  dllseg (store_semaphore wait) x px y py (map semaphore_link_node sems) |--
  “ semaphore_addr sem <> 0 ”.
Proof.
  intros wait sems; induction sems as [| a rest IH]; intros sem x px y py Hin.
  - contradiction.
  - cbn [map dllseg]. Intros z.
    destruct Hin as [<- | Hin].
    + unfold store_semaphore. Intros_p Ha. dump_pre_spatial. tauto.
    + prop_apply_p (IH sem z x y py Hin). Intros_p Hnonzero.
      dump_pre_spatial. exact Hnonzero.
Qed.

Lemma semaphore_dll_nonzero__lookup_views : forall wait sems sem head,
  In sem sems ->
  store_dll (store_semaphore wait) head (map semaphore_link_node sems) |--
  “ semaphore_addr sem <> 0 ”.
Proof.
  intros wait sems sem head Hin. unfold store_dll. Intros first last.
  prop_apply_p (semaphore_segment_nonzero__lookup_views wait sems sem
    first head head last Hin).
  Intros_p Hnonzero. dump_pre_spatial. exact Hnonzero.
Qed.

Lemma semaphore_manager_close__lookup_views : forall sg st,
  store_idmanager (semaphore_manager_stable (os_semaphore_stable sg))
    (semaphore_manager (os_semaphores st)) &("k_sem_id_manager") **
  delete_manager_frame sg st |-- os_inv sg st.
Proof.
  intros sg st.
  unfold delete_manager_frame, delete_global_frame, os_inv, semaphore_inv.
  Intros_p Hctx. Intros_p Hwf.
  rewrite (proj1 Hctx).
  split_pure_spatial; [cancel | split_pures; dump_pre_spatial; auto].
Qed.

Lemma semaphore_frame_nonzero__lookup_views : forall sg st sem,
  In sem (os_semaphores st) -> delete_manager_frame sg st |--
  “ semaphore_addr sem <> 0 ”.
Proof.
  intros sg st sem Hin. unfold delete_manager_frame. Intros_p Hctx.
  prop_apply_p (semaphore_dll_nonzero__lookup_views
    (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_semaphores st)
    sem (semaphore_list_head (os_semaphore_stable sg)) Hin).
  Intros_p Hnonzero. dump_pre_spatial. exact Hnonzero.
Qed.

Lemma semaphore_found_close__lookup_views : forall sg st node id,
  store_idmanager_found (semaphore_manager_stable (os_semaphore_stable sg))
    (semaphore_manager (os_semaphores st)) &("k_sem_id_manager") node id **
  delete_manager_frame sg st |--
  EX sem, “ In sem (os_semaphores st) ” && “ semaphore_id sem = id ” &&
    “ node = &(((semaphore_addr sem)) # "Semaphore" ->ₛ "id") ” &&
    “ semaphore_addr sem <> 0 ” && os_inv sg st.
Proof.
  intros sg st node id.
  prop_apply_p (semaphore_found_member__lookup_views (os_semaphore_stable sg)
    (os_semaphores st) &("k_sem_id_manager") node id).
  Intros_p Hmember. destruct Hmember as [sem [Hin [Hid Haddr]]].
  sep_apply_l_atomic (store_idmanager_found_store_idmanager
    (semaphore_manager_stable (os_semaphore_stable sg))
    (semaphore_manager (os_semaphores st)) &("k_sem_id_manager") node id).
  prop_apply_p (semaphore_frame_nonzero__lookup_views sg st sem Hin).
  Intros_p Hnonzero.
  sep_apply_l_atomic (semaphore_manager_close__lookup_views sg st).
  Exists sem. split_pure_spatial; [cancel | split_pures; dump_pre_spatial; auto].
Qed.
