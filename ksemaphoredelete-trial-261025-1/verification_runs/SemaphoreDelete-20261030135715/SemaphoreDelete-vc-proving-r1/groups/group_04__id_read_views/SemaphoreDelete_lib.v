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

From Coq Require Import Lia.

Lemma dllseg_focus__id_read_views : forall A (storeA : addr -> A -> Assertion)
    nodes (node : DL_Node A) x px y py,
  In node nodes ->
  dllseg storeA x px y py nodes |--
  storeA node.(ptr) node.(data) **
    (storeA node.(ptr) node.(data) -* dllseg storeA x px y py nodes).
Proof.
  intros A storeA nodes. induction nodes as [|a rest IH];
    intros node x px y py Hin; [contradiction|].
  destruct Hin as [<-|Hin].
  - cbn [dllseg]. Intros z. rename H into Hx. subst x.
    cancel.
    apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)).
    Exists z. split_pure_spatial; [sepcon_right_assoc; cancel | dump_pre_spatial; reflexivity].
  - cbn [dllseg]. Intros z. rename H into Hx.
    sep_apply_l_atomic (IH node z x y py Hin).
    cancel.
    apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)). match goal with |- context[?P -* ?Q] =>
      sep_apply_l_atomic (derivable1_wand_elim2 P Q) end.
    Exists z. split_pure_spatial; [unfold dllseg; sepcon_right_assoc; cancel | dump_pre_spatial; exact Hx].
Qed.

Lemma dll_focus__id_read_views : forall A (storeA : addr -> A -> Assertion)
    head nodes (node : DL_Node A),
  In node nodes ->
  store_dll storeA head nodes |--
  storeA node.(ptr) node.(data) **
    (storeA node.(ptr) node.(data) -* store_dll storeA head nodes).
Proof.
  intros A storeA head nodes node Hin.
  unfold store_dll. Intros h pt. rename H into Hwf.
  sep_apply_l_atomic (dllseg_focus__id_read_views A storeA nodes node h head head pt Hin).
  cancel.
  apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)). match goal with |- context[?P -* ?Q] =>
      sep_apply_l_atomic (derivable1_wand_elim2 P Q) end.
  Exists h pt. split_pure_spatial; [sepcon_right_assoc; cancel | dump_pre_spatial; exact Hwf].
Qed.

Lemma idbucket_focus__id_read_views : forall head bucket node,
  In node bucket ->
  store_idbucket head bucket |--
  store_idnode (idnode_link node) node **
  (store_idnode (idnode_link node) node -* store_idbucket head bucket).
Proof.
  intros head bucket node Hin.
  destruct bucket as [|a rest]; [contradiction|].
  cbn [store_idbucket]. unfold store_idnodes.
  apply (dll_focus__id_read_views IdNodeAbs store_idnode head
    (idnodes_to_dll (a :: rest)) (idnode_to_dll node)).
  apply in_map. exact Hin.
Qed.

Lemma idbuckets_focus__id_read_views : forall buckets node h start,
  In node (List.concat buckets) ->
  store_idbucket_list h start buckets |--
  store_idnode (idnode_link node) node **
  (store_idnode (idnode_link node) node -* store_idbucket_list h start buckets).
Proof.
  intros buckets. induction buckets as [|b rest IH];
    intros node h start Hin; [contradiction|].
  cbn [List.concat] in Hin. apply in_app_or in Hin.
  remember (store_idnode (idnode_link node) node **
    (store_idnode (idnode_link node) node -* store_idbucket_list h start (b :: rest)))
    as result eqn:Hresult.
  cbn [store_idbucket_list]. destruct Hin as [Hin|Hin].
  - sep_apply_l_atomic (idbucket_focus__id_read_views
      (h + start * sizeof("SysDoubleLinklistNode")) b node Hin).
    subst result. cancel.
    apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)). match goal with |- context[?P -* ?Q] =>
      sep_apply_l_atomic (derivable1_wand_elim2 P Q) end. unfold store_idbucket_list; sepcon_right_assoc; cancel.
  - sep_apply_l_atomic (IH node h (start + 1) Hin).
    subst result. cancel.
    apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)). match goal with |- context[?P -* ?Q] =>
      sep_apply_l_atomic (derivable1_wand_elim2 P Q) end. unfold store_idbucket_list; sepcon_right_assoc; cancel.
Qed.

Lemma semaphore_idnode_in_buckets__id_read_views : forall st sem,
  In sem st -> In (semaphore_idnode sem)
    (List.concat (idbuckets (semaphore_manager st))).
Proof.
  intros st sem Hin. unfold semaphore_manager. cbn [idbuckets].
  apply in_concat.
  exists (map semaphore_idnode
    (filter (fun s => Z.eqb (semaphore_id s mod 16) (semaphore_id sem mod 16)) st)).
  split.
  - apply in_map_iff. exists (Z.to_nat (semaphore_id sem mod 16)).
    assert (Hr : 0 <= semaphore_id sem mod 16 < 16) by (apply Z.mod_pos_bound; lia).
    split.
    + rewrite Z2Nat.id by lia. reflexivity.
    + apply in_seq. lia.
  - apply in_map. apply filter_In. split; [exact Hin|apply Z.eqb_refl].
Qed.

Lemma resume_current_sem__id_read_views : forall before original drained p,
  In original (os_semaphores before) -> p = semaphore_addr original ->
  semaphore_resume_all_effect p (semaphore_pending_addrs original) before drained ->
  exists current, In current (os_semaphores drained) /\
    semaphore_addr current = p /\ semaphore_id current = semaphore_id original.
Proof.
  intros before original drained p Hin Hp Heffect.
  unfold semaphore_resume_all_effect in Heffect.
  destruct (semaphore_pending_addrs original) as [|task tail].
  - subst drained. exists original. auto.
  - destruct Heffect as [_ [_ [ready [_ ->]]]].
    cbn [os_semaphores replace_semaphores].
    unfold semaphore_set_pending.
    exists {| semaphore_addr := semaphore_addr original;
      semaphore_id := semaphore_id original; semaphore_value := semaphore_value original;
      semaphore_pending_addrs := nil |}.
    split; [|simpl; auto].
    apply in_map_iff. exists original. split; [|exact Hin].
    destruct (Z.eq_dec (semaphore_addr original) p); [reflexivity|congruence].
Qed.

Lemma idnode_scalar_focus__id_read_views : forall link node,
  store_idnode link node |--
  &(((idnode_addr node)) # "IdNode" ->ₛ "id") # UShort |-> idnode_id node **
  ((&(((idnode_addr node)) # "IdNode" ->ₛ "id") # UShort |-> idnode_id node)
    -* store_idnode link node).
Proof.
  intros link node. unfold store_idnode. Intros.
  cancel.
  apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)). Intros.
  split_pure_spatial; [sepcon_right_assoc; cancel | dump_pre_spatial; assumption].
Qed.

Lemma os_id_cell_focus__id_read_views : forall sg st current,
  In current (os_semaphores st) ->
  os_inv sg st |--
  (&(((semaphore_addr current)) # "Semaphore" ->ₛ "id" .ₛ "id") # UShort |-> semaphore_id current) **
  delete_id_restore sg st (semaphore_addr current) (semaphore_id current).
Proof.
  intros sg st current Hin.
  pose proof (semaphore_idnode_in_buckets__id_read_views _ _ Hin) as Hbucket.
  unfold os_inv at 1. unfold semaphore_inv at 1.
  unfold store_idmanager at 1. unfold store_idbuckets at 1. Intros.
  sep_apply_l_atomic (idbuckets_focus__id_read_views
    (idbuckets (semaphore_manager (os_semaphores st))) (semaphore_idnode current)
    (htable (semaphore_manager_stable (os_semaphore_stable sg))) 0 Hbucket).
  match goal with |- context[(store_idnode ?l ?n -* ?Q)] =>
    remember (store_idnode l n -* Q) as bucket_restore eqn:Hrestore end.
  sep_apply_l_atomic (idnode_scalar_focus__id_read_views
    (idnode_link (semaphore_idnode current)) (semaphore_idnode current)).
  unfold delete_id_restore. cbn [semaphore_idnode idnode_addr idnode_id]. csimpl.
  cancel.
  apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)).
  match goal with |- context[?P -* store_idnode ?l ?n] =>
    sep_apply_l_atomic (derivable1_wand_elim2 P (store_idnode l n)) end.
  subst bucket_restore.
  match goal with |- context[?P -* ?Q] =>
    sep_apply_l_atomic (derivable1_wand_elim2 P Q) end.
  unfold os_inv, semaphore_inv, store_idmanager, store_idbuckets.
  split_pure_spatial; [sepcon_right_assoc; cancel | split_pures; dump_pre_spatial; assumption].
Qed.

Lemma resume_id_cell_focus__id_read_views : forall sg before original drained p,
  In original (os_semaphores before) -> p = semaphore_addr original ->
  semaphore_resume_all_effect p (semaphore_pending_addrs original) before drained ->
  os_inv sg drained |--
  (&(p # "Semaphore" ->ₛ "id" .ₛ "id") # UShort |-> semaphore_id original) **
  delete_id_restore sg drained p (semaphore_id original).
Proof.
  intros sg before original drained p Hin Hp Heffect.
  destruct (resume_current_sem__id_read_views before original drained p Hin Hp Heffect)
    as [current [Hcurrent [Haddr Hid]]].
  rewrite <- Haddr, <- Hid.
  apply os_id_cell_focus__id_read_views. exact Hcurrent.
Qed.
