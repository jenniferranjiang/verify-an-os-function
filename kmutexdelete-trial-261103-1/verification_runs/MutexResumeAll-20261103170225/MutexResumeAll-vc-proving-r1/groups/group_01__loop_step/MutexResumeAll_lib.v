From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.
From Coq Require Import Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.KMutexDelete.
Local Open Scope string.
Local Open Scope sac.

(** 等待哨兵next的借出/归还资源：wand不能被当成可复制的纯事实。 *)
Definition mutex_resume_next_restore (sg : StableGlobalState) (st : VarGlobalState)
    (head next : addr) : Assertion :=
  (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next) -* os_inv sg st.

(** 写exstatus后恢复新的task-map索引全局资源；构造此wand必须证明关联保持。 *)
Definition mutex_resume_exstatus_restore (sg : StableGlobalState) (st : VarGlobalState)
    (task value : Z) : Assertion :=
  (&(task # "TaskDescriptor" ->ₛ "exstatus") # Int |-> value) -* os_inv sg st.

(** 任务ID只读字段，原值归还后重新得到完整os_inv，供Wakeup调用。 *)
Definition mutex_resume_id_restore (sg : StableGlobalState) (st : VarGlobalState)
    (task id : Z) : Assertion :=
  (&(task # "TaskDescriptor" ->ₛ "id" .ₛ "id") # UShort |-> id) -* os_inv sg st.

(** 剩余队列完成后的整体结果仍是原drain临界区的批量效果。
    复用已审阅逐步关系，不另定义一套执行链；初始化/保持均是显式VC义务。 *)
Definition mutex_resume_remaining_effect (p : addr) (waiting : list addr)
    (before : VarGlobalState) (remaining : list addr) (current : VarGlobalState) : Prop :=
  forall final,
    mutex_resume_all_steps p remaining current final ->
    mutex_resume_all_effect p waiting before final.

From Coq Require Import Lia Sorting.Permutation.

Lemma map_key_unique__loop_step {A B : Type} (f : A -> B) xs a b :
  NoDup (map f xs) -> In a xs -> In b xs -> f a = f b -> a = b.
Proof.
  induction xs as [|x xs IH]; simpl; intros Hnd Ha Hb Heq; [contradiction|].
  inversion Hnd as [|? ? Hnot Htail]; subst.
  destruct Ha as [<-|Ha], Hb as [<-|Hb]; auto.
  - exfalso. apply Hnot. rewrite Heq. now apply in_map.
  - exfalso. apply Hnot. rewrite <- Heq. now apply in_map.
Qed.

Lemma task_id_offset__loop_step p :
  addr_aligned p ALIGN_SIZE -> &(p # "TaskDescriptor" ->ₛ "id") = p + 104.
Proof.
  intro H. pose proof (task_descriptor_field_offset_axiom p H) as L.
  unfold ktask_descriptor_field_offset_ok in L. tauto.
Qed.

Lemma sched_nodes_injective__loop_step xs ys :
  map sched_link_node xs = map sched_link_node ys -> xs = ys.
Proof.
  revert ys. induction xs as [|x xs IH]; intros [|y ys] H; simpl in H;
    try discriminate; auto.
  injection H as Hxy Htl. subst y. f_equal. now apply IH.
Qed.


Lemma remove_head_exact__loop_step (task : addr) rest after :
  remove_found_prop task (task :: rest) after -> ~ In task after -> after = rest.
Proof.
  intros [[Hmissing _]|[prefix [suffix [Hbefore Hafter]]]] Hnot.
  - exfalso. apply Hmissing. now left.
  - destruct prefix as [|a prefix].
    + simpl in Hbefore, Hafter. injection Hbefore as Hrest. subst suffix. exact Hafter.
    + simpl in Hbefore, Hafter. injection Hbefore as Hhead Htail. subst a.
      subst after. exfalso. apply Hnot. now left.
Qed.

Lemma os_id_facts__loop_step sg st :
  os_inv sg st |-- “ task_world_wf st /\
    IDNode.idbuckets_ok sg.(os_task_stable).(task_stable_ids).(idmax)
      sg.(os_task_stable).(task_stable_ids).(hoffset)
      st.(os_tasks).(task_idmanager_abs).(idlist)
      st.(os_tasks).(task_idmanager_abs).(idbuckets) ”.
Proof.
  unfold os_inv, task_inv, IDNode.store_idmanager.
  Intros. dump_pre_spatial. tauto.
Qed.

Lemma lookup_unique_from_os__loop_step sg before observed id a b da :
  observed.(os_tasks).(task_desc_map) a = Some da ->
  addr_aligned b ALIGN_SIZE ->
  observed.(os_tasks).(task_idmanager_abs) = before.(os_tasks).(task_idmanager_abs) ->
  get_task_with_idnode_success sg before id a ->
  get_task_with_idnode_success sg before id b ->
  os_inv sg observed |-- “ a = b ”.
Proof.
  intros Ha Hb Hids Hla Hlb.
  prop_apply_p (os_id_facts__loop_step sg observed). Intros_p Hfacts.
  dump_pre_spatial.
  destruct Hfacts as [Hwf Hbk].
  pose proof (task_wf_aligned observed Hwf a da Ha) as Haa.
  rewrite Hids in Hbk.
  unfold get_task_with_idnode_success in Hla, Hlb.
  destruct Hla as [_ [_ [pa [Hpa [Hina _]]]]].
  destruct Hlb as [_ [_ [pb [Hpb [Hinb _]]]]].
  subst pa pb.
  destruct Hbk as [Hhoff [Hlen [_ [Hnodes _]]]].
  assert (Hi : 0 <= IDNode.idmanager_bucket_index
      sg.(os_task_stable).(task_stable_ids) id <
      Zlength before.(os_tasks).(task_idmanager_abs).(idbuckets)).
  { unfold IDNode.idmanager_bucket_index. rewrite Hlen.
    apply Z.mod_pos_bound. exact Hhoff. }
  pose proof (IDNode.Forall_Znth_Zlength
    (IDNode.idnodes_ok sg.(os_task_stable).(task_stable_ids).(idmax))
    before.(os_tasks).(task_idmanager_abs).(idbuckets) nil
    (IDNode.idmanager_bucket_index sg.(os_task_stable).(task_stable_ids) id)
    Hnodes Hi) as Hbucket.
  destruct Hbucket as [[_ Hnd] _].
  pose proof (map_key_unique__loop_step idnode_id _
    (Build_IdNodeAbs id (&(a # "TaskDescriptor" ->ₛ "id")))
    (Build_IdNodeAbs id (&(b # "TaskDescriptor" ->ₛ "id")))
    Hnd Hina Hinb eq_refl) as Hnode.
  apply (f_equal idnode_addr) in Hnode. simpl in Hnode.
  rewrite (task_id_offset__loop_step a Haa),
    (task_id_offset__loop_step b Hb) in Hnode. lia.
Qed.

Lemma marked_descriptor__loop_step before marked target desc desc2 :
  marked = replace_task_desc_map
    (update_task_desc_map target (set_task_desc_exstatus desc (-1))
      before.(os_tasks).(task_desc_map)) before ->
  marked.(os_tasks).(task_desc_map) target = Some desc2 ->
  desc2 = set_task_desc_exstatus desc (-1).
Proof.
  intros -> H. cbn [replace_task_desc_map] in H.
  unfold update_task_desc_map in H.
  unfold replace_task_desc_map in H. cbn in H.
  destruct (Z.eq_dec target target); congruence.
Qed.

Lemma dllseg_payload_forall__loop_step {A : Type}
    (storeA : addr -> A -> Assertion) (P : A -> Prop)
    (Hpayload : forall p a, storeA p a |-- “ P a ”) :
  forall nodes x px y py,
    DLL.dllseg storeA x px y py nodes |--
    “ Forall (fun n => P n.(getData)) nodes ”.
Proof.
  induction nodes as [|a nodes IH]; intros x px y py.
  - cbn [DLL.dllseg]. Intros. dump_pre_spatial. constructor.
  - cbn [DLL.dllseg]. Intros z.
    prop_apply_p (Hpayload x a.(getData)). Intros_p Ha.
    prop_apply_p (IH z x y py). Intros_p Htail.
    dump_pre_spatial. constructor; assumption.
Qed.

Lemma dll_payload_forall__loop_step {A : Type}
    (storeA : addr -> A -> Assertion) (P : A -> Prop)
    (Hpayload : forall p a, storeA p a |-- “ P a ”) head nodes :
  DLL.store_dll storeA head nodes |--
    “ Forall (fun n => P n.(getData)) nodes ”.
Proof.
  unfold DLL.store_dll. Intros x py.
  prop_apply_p (dllseg_payload_forall__loop_step storeA P Hpayload
    nodes x head head py). Intros_p Hresult.
  dump_pre_spatial. exact Hresult.
Qed.

Lemma suspend_payload_fact__loop_step T link task :
  pure_suspend_sched_link T link task |--
    “ exists d, T task = Some d /\ d.(tdSchedMember).(tsmStat) = TSK_SUSPEND ”.
Proof.
  unfold pure_suspend_sched_link, pure_published_slink.
  Intros d. dump_pre_spatial. exists d. tauto.
Qed.

Lemma mutex_waiters_fact__loop_step T link m :
  store_mutex (pure_suspend_sched_link T) link m |--
    “ Forall (fun task => exists d, T task = Some d /\
        d.(tdSchedMember).(tsmStat) = TSK_SUSPEND) m.(mutex_pending_addrs) ”.
Proof.
  unfold store_mutex. Intros_p Hm.
  prop_apply_p (dll_payload_forall__loop_step
    (pure_suspend_sched_link T)
    (fun task => exists d, T task = Some d /\ d.(tdSchedMember).(tsmStat) = TSK_SUSPEND)
    (suspend_payload_fact__loop_step T)
    (mutex_pending_head m.(mutex_addr))
    (map mutex_wait_node m.(mutex_pending_addrs))).
  Intros_p Hresult. dump_pre_spatial. apply Forall_forall.
  intros task Hin.
  apply (proj1 (Forall_forall _ _) Hresult) with (x := mutex_wait_node task).
  now apply in_map.
Qed.

Lemma os_mutex_waiters_fact__loop_step sg st m :
  In m st.(os_mutexes) ->
  os_inv sg st |--
    “ Forall (fun task => exists d, st.(os_tasks).(task_desc_map) task = Some d /\
       d.(tdSchedMember).(tsmStat) = TSK_SUSPEND) m.(mutex_pending_addrs) ”.
Proof.
  intro Hm. unfold os_inv, mutex_inv. Intros.
  prop_apply_p (dll_payload_forall__loop_step
    (store_mutex (pure_suspend_sched_link st.(os_tasks).(task_desc_map)))
    (fun obj => Forall (fun task => exists d, st.(os_tasks).(task_desc_map) task = Some d /\
      d.(tdSchedMember).(tsmStat) = TSK_SUSPEND) obj.(mutex_pending_addrs))
    (mutex_waiters_fact__loop_step st.(os_tasks).(task_desc_map))
    sg.(os_mutex_stable).(mutex_list_head)
    (map mutex_link_node st.(os_mutexes))).
  Intros_p Hresult. dump_pre_spatial.
  apply (proj1 (Forall_forall _ _) Hresult) with (x := mutex_link_node m).
  now apply in_map.
Qed.

Lemma mutex_member_after__loop_step task before after :
  mutex_remove_waiter_step task before after ->
  forall m, In m before -> exists n,
    In n after /\ n.(mutex_addr) = m.(mutex_addr) /\
    n.(mutex_id) = m.(mutex_id) /\
    remove_found_prop task m.(mutex_pending_addrs) n.(mutex_pending_addrs).
Proof.
  unfold mutex_remove_waiter_step.
  intro H. induction H as [|x y xs ys Hxy Hrel IH]; intros m Hm.
  - contradiction.
  - simpl in Hm. destruct Hm as [<-|Hm].
    + exists y. split; [now left|]. tauto.
    + destruct (IH m Hm) as [n [Hn Hrest]].
      exists n. split; [now right|exact Hrest].
Qed.

Lemma mutex_live_after__loop_step task before after p id :
  mutex_remove_waiter_step task before.(os_mutexes) after.(os_mutexes) ->
  mutex_delete_live p id before -> mutex_delete_live p id after.
Proof.
  intros Hrel [Hp [Hid [m [Hm [Haddr Hkey]]]]].
  destruct (mutex_member_after__loop_step task _ _ Hrel m Hm)
    as [n [Hn [Hna [Hni Hr]]]].
  split; [exact Hp|]. split; [exact Hid|].
  exists n. repeat split; auto; congruence.
Qed.

Lemma mutex_pending_tail__loop_step sg before after task p rest ready :
  mutex_pending_nodes p before (map sched_link_node (task :: rest)) ->
  mutex_remove_waiter_step task before.(os_mutexes) after.(os_mutexes) ->
  after.(os_tasks).(task_desc_map) task = Some ready ->
  ready.(tdSchedMember).(tsmStat) = TSK_READY ->
  os_inv sg after |-- “ mutex_pending_nodes p after (map sched_link_node rest) ”.
Proof.
  intros [m [Hm [Hp Hnodes]]] Hrel Hready Hstat.
  apply sched_nodes_injective__loop_step in Hnodes.
  destruct (mutex_member_after__loop_step task _ _ Hrel m Hm)
    as [n [Hn [Hna [Hni Hr]]]].
  prop_apply_p (os_mutex_waiters_fact__loop_step sg after n Hn).
  Intros_p Hwait. dump_pre_spatial.
  assert (Habs : ~ In task n.(mutex_pending_addrs)).
  { intro Hin. apply (proj1 (Forall_forall _ _) Hwait) in Hin.
    destruct Hin as [d [Hd Hds]]. rewrite Hready in Hd.
    injection Hd as <-. rewrite Hstat in Hds. discriminate. }
  rewrite Hnodes in Hr.
  pose proof (remove_head_exact__loop_step task rest _ Hr Habs) as Htail.
  exists n. repeat split; auto; try congruence.
Qed.

Lemma wakeup_map_self__loop_step task desc before after :
  ktask_wakeup_step task desc before after ->
  after.(os_tasks).(task_desc_map) task = Some (set_task_desc_ready desc).
Proof.
  intro H. rewrite (wakeup_task_map _ _ _ _ H).
  unfold update_task_desc_map. destruct (Z.eq_dec task task); congruence.
Qed.

Lemma remaining_step__loop_step p waiting initial current marked after target rest desc :
  current.(os_tasks).(task_desc_map) target = Some desc ->
  desc.(tdSchedMember).(tsmStat) = TSK_SUSPEND ->
  marked = replace_task_desc_map
    (update_task_desc_map target (set_task_desc_exstatus desc (-1))
      current.(os_tasks).(task_desc_map)) current ->
  mutex_pending_nodes p current (map sched_link_node (target :: rest)) ->
  ktask_wakeup_step target (set_task_desc_exstatus desc (-1)) marked after ->
  mutex_resume_remaining_effect p waiting initial (target :: rest) current ->
  mutex_resume_remaining_effect p waiting initial rest after.
Proof.
  intros Hd Hstat Hmarked [m [Hm [Hp Hnodes]]] Hw Hremaining final Htail.
  apply sched_nodes_injective__loop_step in Hnodes.
  apply Hremaining. cbn [mutex_resume_all_steps].
  exists after. split; [|exact Htail].
  unfold mutex_resume_one. exists m, desc.
  split; [exact Hm|]. split; [exact Hp|]. split; [exact Hnodes|].
  split; [exact Hd|]. split; [exact Hstat|].
  rewrite <- Hmarked. exact Hw.
Qed.

Lemma nonsuspend_impossible__loop_step sg before marked target desc task desc2 key :
  addr_aligned target ALIGN_SIZE ->
  marked = replace_task_desc_map
    (update_task_desc_map target (set_task_desc_exstatus desc (-1))
      before.(os_tasks).(task_desc_map)) before ->
  get_task_with_idnode_success sg marked key target ->
  get_task_with_idnode_success sg marked key task ->
  marked.(os_tasks).(task_desc_map) task = Some desc2 ->
  desc.(tdSchedMember).(tsmStat) = TSK_SUSPEND ->
  desc2.(tdSchedMember).(tsmStat) <> TSK_SUSPEND ->
  os_inv sg marked |-- “ False ”.
Proof.
  intros Hal Hmark Htarget Htask Hd Hstat Hbad.
  prop_apply_p (lookup_unique_from_os__loop_step sg marked marked key task target desc2
    Hd Hal eq_refl Htask Htarget).
  Intros_p Heq. subst task. dump_pre_spatial.
  pose proof (marked_descriptor__loop_step before marked target desc desc2 Hmark Hd) as E.
  subst desc2. apply Hbad. exact Hstat.
Qed.

Lemma wakeup_head_facts__loop_step sg before marked after
    target desc task desc2 key p id rest :
  addr_aligned target ALIGN_SIZE ->
  marked = replace_task_desc_map
    (update_task_desc_map target (set_task_desc_exstatus desc (-1))
      before.(os_tasks).(task_desc_map)) before ->
  get_task_with_idnode_success sg marked key target ->
  get_task_with_idnode_success sg marked key task ->
  marked.(os_tasks).(task_desc_map) task = Some desc2 ->
  mutex_delete_live p id before ->
  mutex_pending_nodes p before (map sched_link_node (target :: rest)) ->
  ktask_wakeup_step task desc2 marked after ->
  os_inv sg after |--
    “ task = target /\ desc2 = set_task_desc_exstatus desc (-1) /\
      mutex_delete_live p id after /\
      mutex_pending_nodes p after (map sched_link_node rest) ”.
Proof.
  intros Hal Hmark Htarget Htask Hd Hlive Hpending Hstep.
  pose proof (wakeup_map_self__loop_step task desc2 marked after Hstep) as Hself.
  prop_apply_p (lookup_unique_from_os__loop_step sg marked after key task target
    (set_task_desc_ready desc2) Hself Hal
    (wakeup_task_ids _ _ _ _ Hstep) Htask Htarget).
  Intros_p Heq. subst task.
  pose proof (marked_descriptor__loop_step before marked target desc desc2 Hmark Hd) as E.
  subst desc2.
  assert (Hpm : mutex_pending_nodes p marked (map sched_link_node (target :: rest))).
  { rewrite Hmark. change (mutex_pending_nodes p before (map sched_link_node (target :: rest))).
    exact Hpending. }
  assert (Hlm : mutex_delete_live p id marked).
  { rewrite Hmark. change (mutex_delete_live p id before). exact Hlive. }
  pose proof (wakeup_mutexes _ _ _ _ Hstep) as Hmutex.
  pose proof (mutex_live_after__loop_step target marked after p id Hmutex Hlm) as Hlive2.
  prop_apply_p (mutex_pending_tail__loop_step sg marked after target p rest
    (set_task_desc_ready (set_task_desc_exstatus desc (-1)))
    Hpm Hmutex Hself eq_refl).
  Intros_p Hpending2. dump_pre_spatial.
  split; [reflexivity|]. split; [reflexivity|].
  split; assumption.
Qed.

