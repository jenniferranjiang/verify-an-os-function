Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
Require Import Coq.Sorting.Permutation Coq.Sorting.Sorted Coq.micromega.Lia.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.common.CrtosRules.
Require Export CRTOS_Verify.lib.common.dll CRTOS_Verify.lib.id.idnode.
Require Export CRTOS_Verify.lib.task.TaskInv CRTOS_Verify.lib.assign.AssignInv.
Require Export CRTOS_Verify.lib.delay.DelayInv CRTOS_Verify.lib.tick.TickInv.
Require Export CRTOS_Verify.lib.task.ExstatusInv CRTOS_Verify.lib.assign.Bitmap.
Require Export CRTOS_Verify.lib.isr.IsrManagerInv.
Require Export CRTOS_Verify.lib.semaphore.SemaphoreInv.
Require Export CRTOS_Verify.lib.mutex.MutexInv.
Require Export CRTOS_Verify.lib.event.EventInv.
Require Export CRTOS_Verify.lib.list.DoubleLinkListSpec.
Require Export CRTOS_Verify.lib.event.EventLayoutABI.
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
  semaphore_waiters st.(os_semaphores) ++
  mutex_waiters st.(os_mutexes) ++
  event_waiters st.(os_events).

(** 同步 VRTOS：NoDup 表示调度所有者互斥，定义域对应表示已发布任务的
    完整覆盖；服务任务生命周期另由 service_slot_wf 约束。 *)
Record os_world_wf (sg : StableGlobalState) (st : VarGlobalState) : Prop := {
  os_wf_context : os_global_context sg;
  os_wf_recycler : service_slot_wf st sg.(os_recycler_entry) st.(os_recycle);
  os_wf_idle : Forall (service_slot_wf st sg.(os_idle_entry)) st.(os_idle);
  os_wf_sched_nodup : NoDup (os_sched_owners st);
  os_wf_sched_domain : forall task,
    In task (os_sched_owners st) <->
    st.(os_tasks).(task_desc_map) task <> None
}.

(**
  当前范围内的资源组合（msg_buf 缓冲区暂缓）。包含统一任务字段和独立调度节点；每个
  模块只出现一次，semaphore/mutex/event 使用同一 task map 的纯等待关联。
  event 等待节点纳入统一排他和覆盖检查；msgqueue 尚不在当前建模范围内。
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
  sg.(os_recycler_slot) # Int |-> st.(os_recycle).(service_id) **
  IntArray.full sg.(os_idle_array) CORE_COUNT (map service_id st.(os_idle)) **
  isrmanager_inv sg.(os_isr_stable) st.(os_isr) **
  exstatus_inv sg st **
  semaphore_inv wait sg.(os_semaphore_stable) st.(os_semaphores) **
  mutex_inv wait sg.(os_mutex_stable) st.(os_mutexes) **
  event_inv wait sg.(os_event_stable) st.(os_events).

(** 保留本地调用者使用的引理名；对应上游 Record 的两个投影。 *)
Lemma os_sched_owners_domain : forall sg st task,
  os_world_wf sg st ->
  (In task (os_sched_owners st) <-> st.(os_tasks).(task_desc_map) task <> None).
Proof. intros sg st task Hwf; exact (os_wf_sched_domain sg st Hwf task). Qed.

Lemma os_sched_owners_nodup : forall sg st,
  os_world_wf sg st -> NoDup (os_sched_owners st).
Proof. intros sg st Hwf; exact (os_wf_sched_nodup sg st Hwf). Qed.

Lemma os_sched_owners_in_task_list : forall sg st task,
  task_world_wf st -> os_world_wf sg st ->
  In task (os_sched_owners st) -> In task st.(os_tasks).(task_ptr_list).
Proof.
  intros sg st task Htask Hos Hin.
  apply (proj1 (os_wf_sched_domain sg st Hos task)) in Hin.
  destruct (task_desc_map (os_tasks st) task) as [desc |] eqn:Hlookup;
    [eapply task_wf_map_present; eauto | contradiction].
Qed.

(** 对任意状态都排除自持/等待重叠；对 SUSPEND 与容器状态条件合用即为二选一。 *)
Lemma sched_owned_not_waiting : forall sg st task,
  os_world_wf sg st -> In task st.(os_tasks).(sched_owned_tasks) ->
  ~ In task (semaphore_waiters st.(os_semaphores) ++
             mutex_waiters st.(os_mutexes) ++
             event_waiters st.(os_events)).
Proof.
  intros sg st task Hwf Howned Hwait.
  pose proof (os_wf_sched_nodup sg st Hwf) as Hunique.
  unfold os_sched_owners in Hunique.
  apply in_split in Howned as [left [right Howned]].
  rewrite Howned, <- app_assoc in Hunique.
  apply NoDup_remove_2 in Hunique.
  apply Hunique.
  apply in_or_app; right; apply in_or_app; right.
  apply in_or_app; right; apply in_or_app; right; exact Hwait.
Qed.


Lemma os_sched_owners_absent sg st task :
  os_world_wf sg st ->
  (~ In task (os_sched_owners st) <-> st.(os_tasks).(task_desc_map) task = None).
Proof.
  intro Hwf. rewrite (os_wf_sched_domain _ _ Hwf).
  destruct (task_desc_map (os_tasks st) task); split; intro H;
    try reflexivity; try discriminate; try tauto; exfalso; apply H; discriminate.
Qed.

Definition observed_ktask_published (sg : StableGlobalState) (task : Z)
    (states : VarGlobalState -> Prop) : Prop :=
  forall observed, states observed ->
    os_inv sg observed |-- “ observed.(os_tasks).(task_desc_map) task <> None ”.

(** 创建接口共用的 frame 与恢复义务；KEventCreate 继续导出这些定义。 *)
(** Create 借出 event_inv 后留下的精确资源：既有全局良构事实与全部其他
    模块、任务字段和队列仍由本 frame 唯一持有。新对象pending为空，因此
    发布不增加任何调度节点所有者；恢复义务在下面显式陈述。 *)
Definition event_create_frame (sg : StableGlobalState) (st : VarGlobalState)
    : Assertion :=
  let wait := pure_suspend_sched_link st.(os_tasks).(task_desc_map) in
  “ os_world_wf sg st ” &&
  task_inv sg st ** tick_inv sg st ** delay_inv sg st ** assign_inv sg st **
  store_prio_lookup_table **
  store_zombie_queue st.(os_tasks).(task_desc_map)
    sg.(os_zombie_head) st.(zombie_queue) **
  sg.(os_recycler_slot) # Int |-> st.(os_recycle).(service_id) **
  IntArray.full sg.(os_idle_array) CORE_COUNT (map service_id st.(os_idle)) **
  isrmanager_inv sg.(os_isr_stable) st.(os_isr) ** exstatus_inv sg st **
  semaphore_inv wait sg.(os_semaphore_stable) st.(os_semaphores) **
  mutex_inv wait sg.(os_mutex_stable) st.(os_mutexes).

(** 待证的拆出接口；Definition只保存命题，不提供证明事实。 *)
Definition event_create_split_obligation : Prop :=
  forall sg before,
    os_inv sg before |--
    event_create_frame sg before **
    event_inv (pure_suspend_sched_link before.(os_tasks).(task_desc_map))
      sg.(os_event_stable) before.(os_events).

(** ID头插和管理链头插的纯一致性义务；不创建第二份manager状态。 *)
Definition event_publish_manager_obligation : Prop :=
  forall sg before p id options,
    event_context sg ->
    idmanager_min_free_id sg.(event_manager_stable) (event_manager before) id ->
    event_manager (event_publish p id options before) =
      idmanager_link sg.(event_manager_stable)
        (idmanager_add (event_manager before) id) id (&(p # "Event" ->ₛ "id")).

(** 新建事件等待链为空，故所有调度节点的唯一归属和覆盖完全不变。
    该命题仅陈述需要证明的纯关联，不借助新不变量假设排除创建输入。 *)
Definition event_publish_world_obligation : Prop :=
  forall sg before p id options,
    os_world_wf sg before ->
    os_world_wf sg (replace_events
      (event_publish p id options before.(os_events)) before).

(** 完成两个容器头插后，以更新后的事件模块恢复系统资源。所有其他模块
    从精确frame返还；ID/管理link不再留给调用者。布局/字节及ID/DLL操作
    各自还有明确待证义务，本陈述不冒充已完成的C实现证明。 *)
Definition event_create_restore_obligation : Prop :=
  forall sg before p id options,
    idmanager_min_free_id sg.(os_event_stable).(event_manager_stable)
      (event_manager before.(os_events)) id ->
    event_create_frame sg before **
    store_idmanager sg.(os_event_stable).(event_manager_stable)
      (idmanager_link sg.(os_event_stable).(event_manager_stable)
        (idmanager_add (event_manager before.(os_events)) id) id
        (&(p # "Event" ->ₛ "id"))) sg.(os_event_stable).(event_manager_ptr) **
    store_dll
      (store_event (pure_suspend_sched_link before.(os_tasks).(task_desc_map)))
      sg.(os_event_stable).(event_list_head)
      (map event_link_node (event_publish p id options before.(os_events)))
    |-- os_inv sg (replace_events
      (event_publish p id options before.(os_events)) before).

(** 以下辅助证明迁自 kmutexcreate-trial-261101-1/VC/MutexCreate_lib.v。
    frame 按当前全局状态组合，event 资源保留在 mutex 创建之外。 *)
(** 拆出mutex模块时保留系统其他模块及跨模块一致性；创建结束后与新的
    mutex_inv重组os_inv。它只描述真实未触达资源，不断言新的调用前提。 *)
Definition mutex_create_frame (sg : StableGlobalState) (st : VarGlobalState)
    : Assertion :=
  let wait := pure_suspend_sched_link st.(os_tasks).(task_desc_map) in
  “ os_world_wf sg st ” &&
  task_inv sg st ** tick_inv sg st ** delay_inv sg st ** assign_inv sg st **
  store_prio_lookup_table **
  store_zombie_queue st.(os_tasks).(task_desc_map)
    sg.(os_zombie_head) st.(zombie_queue) **
  sg.(os_recycler_slot) # Int |-> st.(os_recycle).(service_id) **
  IntArray.full sg.(os_idle_array) CORE_COUNT (map service_id st.(os_idle)) **
  event_inv wait sg.(os_event_stable) st.(os_events) **
  isrmanager_inv sg.(os_isr_stable) st.(os_isr) ** exstatus_inv sg st **
  semaphore_inv wait sg.(os_semaphore_stable) st.(os_semaphores).


Lemma mutex_two_zero_uchars__zero_bytes : forall p,
  CharArray.full p 2 (repeat_Z 0 2) |--
  p # UChar |-> 0 ** (p+1) # UChar |-> 0.
Proof.
  intros p. change (repeat_Z 0 2) with [0;0].
  unfold CharArray.full, store_array. cbn [store_array_rec].
  unfold StoreCharAsElement.storeA. rewrite sizeof_char.
  replace (p+0*1) with p by lia.
  replace (p+(0+1)*1) with (p+1) by lia.
  unfold store_char, store_uchar. Intros.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; unfold Byte.max_unsigned; intuition lia.
Qed.
Lemma mutex_zero_bytes__zero_bytes : forall p,
  0 < p -> p <= UINT_MAX - sizeof("Mutex"%string) -> addr_aligned p 4 ->
  CharArray.full p sizeof("Mutex"%string) (repeat_Z 0 sizeof("Mutex"%string)) |-- MutexZero p.
Proof.
  intros p Hpos Hbound Halign.
  assert (Hsize : sizeof("Mutex"%string) = 36) by exact mutex_size_axiom.
  rewrite Hsize.
  sep_apply (CharArray.full_split_to_full p 32 36 (repeat_Z 0 36)); try lia.
  change (sublist 0 32 (repeat_Z 0 36)) with (repeat_Z 0 32).
  change (sublist 32 36 (repeat_Z 0 36)) with (repeat_Z 0 4).
  change (36-32) with 4.
  unfold StoreCharAsElement.sizeA. rewrite sizeof_char.
  replace (p+32*1) with (p+32) by lia.
  sep_apply (semaphore_zero_bytes_fields p Halign).
  sep_apply (mutex_two_zero_uchars__zero_bytes (p+14)).
  replace (p+14+1) with (p+15) by lia.
  assert (Ha32 : addr_aligned (p+32) 4).
  { unfold addr_aligned in *. rewrite Z.add_mod by lia. rewrite Halign. reflexivity. }
  sep_apply (semaphore_four_zero_bytes_ptr (p+32) Ha32).
  pose proof (mutex_field_offset_axiom p Halign) as Hlayout.
  destruct Hlayout as [Hid [Hidval [Hidlink [Hval [Hrec [Hprio [Hholder [Hpend [Hlink Hnodes]]]]]]]]].
  destruct (Hnodes (p+4) ltac:(simpl; auto)) as [Hnext4 Hprev4].
  destruct (Hnodes (p+20) ltac:(simpl; auto)) as [Hnext20 Hprev20].
  destruct (Hnodes (p+28) ltac:(simpl; auto)) as [Hnext28 Hprev28].
  unfold MutexZero, ZeroIdNode, NodeZero, MutexPadding.
  rewrite Hid, Hidval, Hidlink, Hval, Hrec, Hprio, Hholder, Hpend, Hlink.
  rewrite Hnext4, Hprev4, Hnext20, Hprev20, Hnext28, Hprev28.
  replace (p+4+4) with (p+8) by lia.
  replace (p+20+4) with (p+24) by lia.
  replace (p+28+4) with (p+32) by lia.
  split_pure_spatial.
  - repeat progress cancel.
  - split_pures; dump_pre_spatial; intuition lia.
Qed.
Lemma mutex_payload_conflict__invariant_open_failure : forall wait link m p,
mutex_addr m = p -> store_mutex wait link m ** MutexZero p |-- “False”.
Proof.
intros wait link m p Heq.
unfold store_mutex, MutexZero.
rewrite Heq.
Intros_p Hm.
Intros_p Hp.
sep_apply_l_atomic (store_ptr_undef_store_ptr ((&(p # "Mutex" ->ₛ "holder"))%string) (mutex_holder m)).
sep_apply_l_atomic (store_ptr_undef_store_ptr ((&(p # "Mutex" ->ₛ "holder"))%string) 0).
sep_apply_l_atomic (dup_undef_store_ptr ((&(p # "Mutex" ->ₛ "holder"))%string)).
Intros_p Hfalse.
contradiction.
Qed.
Lemma mutex_publish_world_wf__publish_invariant : forall sg st p id,
  os_world_wf sg st ->
  os_world_wf sg (replace_mutexes (mutex_publish p id (os_mutexes st)) st).
Proof.
  intros sg st p id H.
  destruct H as [Hcontext Hrecycler Hidle Hnodup Hdomain].
  constructor; try assumption.
  - unfold service_slot_wf in *. simpl.
    destruct (service_phase (os_recycle st)); try assumption.
    destruct Hrecycler as [desc Hd]. exists desc.
    destruct Hd. constructor; assumption.
  - eapply List.Forall_impl; [|exact Hidle]. intros a Ha.
    unfold service_slot_wf in *. destruct (service_phase a); try assumption.
    destruct Ha as [desc Hd]. exists desc. destruct Hd. constructor; assumption.
Qed.
Lemma mutex_manager_publish__publish_invariant : forall ms old p id,
  hoffset ms = 16 ->
  mutex_manager (mutex_created p id :: old) =
  idmanager_link ms (idmanager_add (mutex_manager old) id) id
    (idnode_addr (mutex_idnode (mutex_created p id))).
Proof.
  intros ms old p id Hhoff.
  unfold mutex_manager, idmanager_link, idmanager_insert_bucket,
    idmanager_add, idlist_add.
  simpl idlist. simpl idbuckets. rewrite Hhoff.
  assert (Hmod : 0 <= id mod 16 < 16) by (apply Z.mod_pos_bound; lia).
  assert (Hcases : id mod 16 = 0 \/ id mod 16 = 1 \/ id mod 16 = 2 \/ id mod 16 = 3 \/ id mod 16 = 4 \/ id mod 16 = 5 \/ id mod 16 = 6 \/ id mod 16 = 7 \/ id mod 16 = 8 \/ id mod 16 = 9 \/ id mod 16 = 10 \/ id mod 16 = 11 \/ id mod 16 = 12 \/ id mod 16 = 13 \/ id mod 16 = 14 \/ id mod 16 = 15) by lia.
  repeat destruct Hcases as [Hcase|Hcases]; try rename Hcases into Hcase;
    cbn [seq map filter mutex_created mutex_id]; rewrite Hcase; reflexivity.
Qed.

(** 以下辅助证明迁自 keventcreate-trial-261101-1/VC/EventCreate_lib.v。 *)
Lemma event_byte_layout__zero_layout : forall p, addr_aligned p 4 -> event_byte_layout p.
Proof.
intros p Ha.
pose proof (event_top_level_field_offset_axiom p Ha) as E.
pose proof (mutex_field_offset_axiom p Ha) as M.
unfold event_top_level_field_offset_ok in E.
unfold mutex_field_offset_ok in M.
unfold event_byte_layout.
destruct E as [E1 [E2 [E3 [E4 E5]]]].
destruct M as [_ [M1 [M2 [_ [_ [_ [_ [_ [_ Mn]]]]]]]]].
repeat split; try assumption.
all: simpl in H; destruct H as [<-|[<-|[<-|[]]]]; apply Mn; simpl; auto.
Qed.
Lemma four_zero_uint__zero_layout : forall p, addr_aligned p 4 -> (CharArray.full p 4 (repeat_Z 0 4) |-- p # UInt |-> 0)%sac.
Proof.
  intros p Ha.
  change (repeat_Z 0 4) with [0; 0; 0; 0].
  unfold CharArray.full, store_array.
  cbn [store_array_rec].
  unfold StoreCharAsElement.storeA.
  rewrite sizeof_char.
  replace (p + 0 * 1) with p by lia.
  replace (p + (0 + 1) * 1) with (p + 1) by lia.
  replace (p + (0 + 1 + 1) * 1) with (p + 2) by lia.
  replace (p + (0 + 1 + 1 + 1) * 1) with (p + 3) by lia.
  rewrite store_uint_store_char.
  Exists 0 0 0 0.
  cbv [Vector.hd Vector.tl].
  entailer!.
  change Int.max_unsigned with 4294967295; lia.
Qed.
Lemma event_zero_bytes__zero_layout : forall p, 0 < p -> p <= 4294967295-36 -> addr_aligned p 4 -> (CharArray.full p 36 (repeat_Z 0 36) |-- EventZero p)%sac.
Proof.
intros p Hp Hb Ha.
sep_apply_l_atomic (CharArray.full_split_to_full p 2 36 (repeat_Z 0 36) ltac:(lia)).
change (ListLib.Base.Positional.sublist 0 2 (repeat_Z 0 36)) with (repeat_Z 0 2).
change (ListLib.Base.Positional.sublist 2 36 (repeat_Z 0 36)) with (repeat_Z 0 34).
change (36-2) with 34.
unfold StoreCharAsElement.sizeA.
rewrite sizeof_char.
replace (p+2*1) with (p+2) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+2) 2 34 (repeat_Z 0 34) ltac:(lia)).
change (ListLib.Base.Positional.sublist 0 2 (repeat_Z 0 34)) with (repeat_Z 0 2).
change (ListLib.Base.Positional.sublist 2 34 (repeat_Z 0 34)) with (repeat_Z 0 32).
change (34-2) with 32.
unfold StoreCharAsElement.sizeA.
rewrite sizeof_char.
replace ((p+2)+2*1) with (p+4) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+4) 4 32 (repeat_Z 0 32) ltac:(lia)).
change (ListLib.Base.Positional.sublist 0 4 (repeat_Z 0 32)) with (repeat_Z 0 4).
change (ListLib.Base.Positional.sublist 4 32 (repeat_Z 0 32)) with (repeat_Z 0 28).
change (32-4) with 28.
unfold StoreCharAsElement.sizeA.
rewrite sizeof_char.
replace ((p+4)+4*1) with (p+8) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+8) 4 28 (repeat_Z 0 28) ltac:(lia)).
change (ListLib.Base.Positional.sublist 0 4 (repeat_Z 0 28)) with (repeat_Z 0 4).
change (ListLib.Base.Positional.sublist 4 28 (repeat_Z 0 28)) with (repeat_Z 0 24).
change (28-4) with 24.
unfold StoreCharAsElement.sizeA.
rewrite sizeof_char.
replace ((p+8)+4*1) with (p+12) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+12) 4 24 (repeat_Z 0 24) ltac:(lia)).
change (ListLib.Base.Positional.sublist 0 4 (repeat_Z 0 24)) with (repeat_Z 0 4).
change (ListLib.Base.Positional.sublist 4 24 (repeat_Z 0 24)) with (repeat_Z 0 20).
change (24-4) with 20.
unfold StoreCharAsElement.sizeA.
rewrite sizeof_char.
replace ((p+12)+4*1) with (p+16) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+16) 4 20 (repeat_Z 0 20) ltac:(lia)).
change (ListLib.Base.Positional.sublist 0 4 (repeat_Z 0 20)) with (repeat_Z 0 4).
change (ListLib.Base.Positional.sublist 4 20 (repeat_Z 0 20)) with (repeat_Z 0 16).
change (20-4) with 16.
unfold StoreCharAsElement.sizeA.
rewrite sizeof_char.
replace ((p+16)+4*1) with (p+20) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+20) 4 16 (repeat_Z 0 16) ltac:(lia)).
change (ListLib.Base.Positional.sublist 0 4 (repeat_Z 0 16)) with (repeat_Z 0 4).
change (ListLib.Base.Positional.sublist 4 16 (repeat_Z 0 16)) with (repeat_Z 0 12).
change (16-4) with 12.
unfold StoreCharAsElement.sizeA.
rewrite sizeof_char.
replace ((p+20)+4*1) with (p+24) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+24) 4 12 (repeat_Z 0 12) ltac:(lia)).
change (ListLib.Base.Positional.sublist 0 4 (repeat_Z 0 12)) with (repeat_Z 0 4).
change (ListLib.Base.Positional.sublist 4 12 (repeat_Z 0 12)) with (repeat_Z 0 8).
change (12-4) with 8.
unfold StoreCharAsElement.sizeA.
rewrite sizeof_char.
replace ((p+24)+4*1) with (p+28) by lia.
sep_apply_l_atomic (CharArray.full_split_to_full (p+28) 4 8 (repeat_Z 0 8) ltac:(lia)).
change (ListLib.Base.Positional.sublist 0 4 (repeat_Z 0 8)) with (repeat_Z 0 4).
change (ListLib.Base.Positional.sublist 4 8 (repeat_Z 0 8)) with (repeat_Z 0 4).
change (8-4) with 4.
unfold StoreCharAsElement.sizeA.
rewrite sizeof_char.
replace ((p+28)+4*1) with (p+32) by lia.
assert (Ha2 : addr_aligned p 2).
{ unfold addr_aligned in *.
apply Z.mod_divide in Ha; [|lia].
destruct Ha as [k Hk].
apply Z.mod_divide; [lia|].
exists (2*k).
lia.
} sep_apply_l_atomic (semaphore_two_zero_bytes_ushort p Ha2).
assert (Ha4 : addr_aligned (p+4) 4).
{ unfold addr_aligned in *.
rewrite Z.add_mod by lia.
rewrite Ha.
reflexivity.
} sep_apply_l_atomic (semaphore_four_zero_bytes_ptr (p+4) Ha4).
assert (Ha8 : addr_aligned (p+8) 4).
{ unfold addr_aligned in *.
rewrite Z.add_mod by lia.
rewrite Ha.
reflexivity.
} sep_apply_l_atomic (semaphore_four_zero_bytes_ptr (p+8) Ha8).
assert (Ha12 : addr_aligned (p+12) 4).
{ unfold addr_aligned in *.
rewrite Z.add_mod by lia.
rewrite Ha.
reflexivity.
} sep_apply_l_atomic (four_zero_uint__zero_layout (p+12) Ha12).
assert (Ha16 : addr_aligned (p+16) 4).
{ unfold addr_aligned in *.
rewrite Z.add_mod by lia.
rewrite Ha.
reflexivity.
} sep_apply_l_atomic (four_zero_uint__zero_layout (p+16) Ha16).
assert (Ha20 : addr_aligned (p+20) 4).
{ unfold addr_aligned in *.
rewrite Z.add_mod by lia.
rewrite Ha.
reflexivity.
} sep_apply_l_atomic (semaphore_four_zero_bytes_ptr (p+20) Ha20).
assert (Ha24 : addr_aligned (p+24) 4).
{ unfold addr_aligned in *.
rewrite Z.add_mod by lia.
rewrite Ha.
reflexivity.
} sep_apply_l_atomic (semaphore_four_zero_bytes_ptr (p+24) Ha24).
assert (Ha28 : addr_aligned (p+28) 4).
{ unfold addr_aligned in *.
rewrite Z.add_mod by lia.
rewrite Ha.
reflexivity.
} sep_apply_l_atomic (semaphore_four_zero_bytes_ptr (p+28) Ha28).
assert (Ha32 : addr_aligned (p+32) 4).
{ unfold addr_aligned in *.
rewrite Z.add_mod by lia.
rewrite Ha.
reflexivity.
} sep_apply_l_atomic (semaphore_four_zero_bytes_ptr (p+32) Ha32).
pose proof (event_byte_layout__zero_layout p Ha) as Hl.
destruct Hl as [Hid [Hidval [Hidlink [Hopt [Hevt [Hpend [Hlink Hnodes]]]]]]].
destruct (Hnodes 4 ltac:(simpl; auto)) as [Hnext4 Hprev4].
destruct (Hnodes 20 ltac:(simpl; auto)) as [Hnext20 Hprev20].
destruct (Hnodes 28 ltac:(simpl; auto)) as [Hnext28 Hprev28].
unfold EventZero, ZeroIdNode, NodeZero, EventPadding.
rewrite Hid, Hidval, Hidlink, Hopt, Hevt, Hpend, Hlink.
rewrite Hnext4, Hprev4, Hnext20, Hprev20, Hnext28, Hprev28.
replace (p+4+4) with (p+8) by lia.
replace (p+20+4) with (p+24) by lia.
replace (p+28+4) with (p+32) by lia.
split_pure_spatial.
- cancel.
cancel (p # UShort |-> 0)%sac.
cancel ((p+4) # Ptr |-> 0)%sac.
cancel ((p+8) # Ptr |-> 0)%sac.
cancel ((p+12) # UInt |-> 0)%sac.
cancel ((p+16) # UInt |-> 0)%sac.
cancel ((p+20) # Ptr |-> 0)%sac.
cancel ((p+24) # Ptr |-> 0)%sac.
cancel ((p+28) # Ptr |-> 0)%sac.
cancel ((p+32) # Ptr |-> 0)%sac.
- split_pures; dump_pre_spatial.
all: split; assumption || lia.
Qed.
Lemma dll_event_fresh__open_event_state : forall wait es x px y py p,
  (DLL.dllseg (store_event wait) x px y py (map event_link_node es) ** EventZero p
  |-- “ ~ In p (map event_addr es) ”)%sac.
Proof.
  intros wait es. induction es as [|e es IH]; intros x px y py p.
  - simpl. dump_pre_spatial. tauto.
  - simpl map. destruct (Z.eq_dec p (event_addr e)) as [Heq|Hneq].
    + cbn [DLL.dllseg event_link_node]. Intros z.
      unfold store_event, EventZero. Intros. subst p.
      unfold event_link_node. cbn.
      sep_apply_l_atomic (store_uint_undef_store_uint
        (&(event_addr e # "Event" ->ₛ "options")) (event_options e)).
      sep_apply_l_atomic (store_uint_undef_store_uint
        (&(event_addr e # "Event" ->ₛ "options")) 0).
      prop_apply_p (undef_store_int_exclusive 4 4
        (&(event_addr e # "Event" ->ₛ "options")) ltac:(lia)).
      Intros_p Hfalse. dump_pre_spatial. contradiction.
    + cbn [DLL.dllseg event_link_node]. Intros z.
      fold (DLL.dllseg (store_event wait) z x y py (map event_link_node es)).
      prop_apply_p (IH z x y py p). Intros_p Hfresh.
      dump_pre_spatial. simpl. intuition congruence.
Qed.
Lemma event_fresh__open_event_state : forall sg st p,
  (os_inv sg st ** EventZero p |-- “ ~ In p (map event_addr (os_events st)) ”)%sac.
Proof.
  intros sg st p. unfold os_inv, event_inv. Intros.
  unfold DLL.store_dll at 1. Intros h pt.
  prop_apply_p (dll_event_fresh__open_event_state
    (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_events st)
    h (event_list_head (os_event_stable sg))
    (event_list_head (os_event_stable sg)) pt p).
  Intros_p Hfresh. dump_pre_spatial. exact Hfresh.
Qed.
Lemma event_publish_world__publish_world : event_publish_world_obligation.
Proof.
  intros sg before p id options H.
  destruct H as [Hcontext Hrecycler Hidle Hnodup Hdomain].
  constructor; cbn [replace_events]; try assumption.
  - unfold service_slot_wf in *; simpl.
    destruct (service_phase (os_recycle before)); try assumption.
    destruct Hrecycler as [d Hd]. exists d.
    destruct Hd; constructor; assumption.
  - simpl. eapply List.Forall_impl; [|eassumption].
    intros x Hx. unfold service_slot_wf in *.
    destruct (service_phase x); try assumption.
    destruct Hx as [d Hd]. exists d.
    destruct Hd; constructor; assumption.
Qed.
Lemma event_publish_manager__publish_world : event_publish_manager_obligation.
Proof.
  intros sg before p id options Hctx Hmin.
  destruct Hctx as [_ [_ [Hoff _]]].
  unfold event_manager, event_publish, IDNode.idmanager_link, IDNode.idmanager_add,
    IDNode.idmanager_insert_bucket, IDNode.idlist_add.
  cbn [idlist idbuckets]. rewrite Hoff.
  assert (Hmod : 0 <= id mod 16 < 16) by (apply Z.mod_pos_bound; lia).
  cbn [map filter event_created event_id].
  remember (id mod 16) as k eqn:Hk.
  assert (Hcases : k = 0 \/ k = 1 \/ k = 2 \/ k = 3 \/ k = 4 \/
    k = 5 \/ k = 6 \/ k = 7 \/ k = 8 \/ k = 9 \/ k = 10 \/
    k = 11 \/ k = 12 \/ k = 13 \/ k = 14 \/ k = 15) by lia.
  repeat destruct Hcases as [Hcases | Hcases]; rewrite Hcases; reflexivity.
Qed.
