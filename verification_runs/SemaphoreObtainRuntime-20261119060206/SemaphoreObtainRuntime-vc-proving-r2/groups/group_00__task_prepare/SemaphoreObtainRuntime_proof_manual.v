From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.semaphore Require Import SemaphoreObtainRuntime_goal.
From CRTOS_Verify.VC.semaphore Require Import SemaphoreObtainRuntime_proof_auto.
Require Import CRTOS_Verify.lib.id.IdModuleSpec.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreDelete CRTOS_Verify.lib.delay.KTaskUnSetDelay.
Require Import CRTOS_Verify.lib.list.DoubleLinkListSpec CRTOS_Verify.lib.task.TaskStatusMemory CRTOS_Verify.lib.task.KTaskParseInfo.
Import IDNode DLL.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreAbandon.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreObtain.
Local Open Scope sac.

Lemma proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_1 : _SemaphoreObtain_entail_wit_1_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_1_1_split_goal_2 : _SemaphoreObtain_entail_wit_1_1_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_1_1 : _SemaphoreObtain_entail_wit_1_1.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_1 : _SemaphoreObtain_entail_wit_1_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_1_2_split_goal_2 : _SemaphoreObtain_entail_wit_1_2_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_1_2 : _SemaphoreObtain_entail_wit_1_2.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_1 : _SemaphoreObtain_entail_wit_1_3_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_2 : _SemaphoreObtain_entail_wit_1_3_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_1_3_split_goal_3 : _SemaphoreObtain_entail_wit_1_3_split_goal_3.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_1_3 : _SemaphoreObtain_entail_wit_1_3.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_1 : _SemaphoreObtain_entail_wit_3_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_2 : _SemaphoreObtain_entail_wit_3_1_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_3_1_split_goal_spatial : _SemaphoreObtain_entail_wit_3_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_3_1 : _SemaphoreObtain_entail_wit_3_1.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_1 : _SemaphoreObtain_entail_wit_3_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_2 : _SemaphoreObtain_entail_wit_3_2_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_3_2_split_goal_spatial : _SemaphoreObtain_entail_wit_3_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_3_2 : _SemaphoreObtain_entail_wit_3_2.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_4 : _SemaphoreObtain_entail_wit_4.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_5_split_goal_1 : _SemaphoreObtain_entail_wit_5_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_5_split_goal_2 : _SemaphoreObtain_entail_wit_5_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_5_split_goal_spatial : _SemaphoreObtain_entail_wit_5_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_5 : _SemaphoreObtain_entail_wit_5.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_6_split_goal_1 : _SemaphoreObtain_entail_wit_6_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_6_split_goal_2 : _SemaphoreObtain_entail_wit_6_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_6 : _SemaphoreObtain_entail_wit_6.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_7_split_goal_1 : _SemaphoreObtain_entail_wit_7_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_7_split_goal_2 : _SemaphoreObtain_entail_wit_7_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_7 : _SemaphoreObtain_entail_wit_7.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hvalid : orb (semaphore_id_invalid id_pre)
      (andb (Z.ltb msec_pre 0) (negb (Z.eqb msec_pre (-1)))) = false).
  { unfold semaphore_id_invalid.
    repeat match goal with |- context [Z.ltb ?x ?y] => destruct (Z.ltb_spec x y) end;
    repeat match goal with |- context [Z.eqb ?x ?y] => destruct (Z.eqb_spec x y) end;
    simpl; try lia; reflexivity. }
  assert (Hentry : semaphore_obtain_entry sg_semaphore_obtain_oc id_pre
      (semaphore_wait_ticks msec_pre) (Crtos_RTrans before_semaphore_obtain_oc)).
  { destruct PreH24 as [states [Hstates Hsafe]].
    unfold LastSeen in Hstates.
    unfold safe, abs_semaphore_obtain in Hsafe.
    rewrite Hvalid in Hsafe.
    rewrite wp_bind, wp_assertS in Hsafe.
    destruct Hsafe as [Hentry _].
    unfold semaphore_obtain_entry in Hentry |- *.
    intros obs Hobs. apply Hentry.
    apply (proj2 (Hstates obs)). exact Hobs. }
  pose proof (Hentry held PreH23) as Hguard.
  prop_apply_p Hguard. Intros_p Hg.
  specialize (Hg original PreH17 PreH18 PreH4).
  assert (Hnz : semaphore_wait_ticks msec_pre <> 0) by lia.
  specialize (Hg Hnz). destruct Hg as [Ha Hfuture].
  split_pure_spatial; [repeat progress cancel |].
  split_pures; dump_pre_spatial; try assumption.
  rewrite PreH10. exact Hfuture.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_8 : _SemaphoreObtain_entail_wit_8.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hmapnew : forall (T : Z -> option TaskDescriptorAbs) p d  q e,
    T p = Some d -> T q = Some e ->
    exists e', update_task_desc_map p (set_task_desc_exstatus d 0) T q = Some e' /\
      e'.(tdSchedMember) = e.(tdSchedMember) /\
      e'.(tdBaseInfo) = e.(tdBaseInfo)).
  { intros T p d  q e Hp Hq.
    unfold update_task_desc_map. destruct (Z.eq_dec q p) as [->|Hne].
    - rewrite Hp in Hq. inversion Hq; subst e.
      exists (set_task_desc_exstatus d 0); simpl; tauto.
    - exists e; tauto. }
  assert (Hmapold : forall (T : Z -> option TaskDescriptorAbs) p d  q e,
    T p = Some d ->
    update_task_desc_map p (set_task_desc_exstatus d 0) T q = Some e ->
    exists e', T q = Some e' /\
      e'.(tdSchedMember) = e.(tdSchedMember) /\
      e'.(tdBaseInfo) = e.(tdBaseInfo)).
  { intros T p d  q e Hp Hq.
    unfold update_task_desc_map in Hq. destruct (Z.eq_dec q p) as [->|Hne].
    - inversion Hq; subst e. exists d; simpl; tauto.
    - exists e; tauto. }
  assert (Htaskwf : forall st p d  ,
    st.(os_tasks).(task_desc_map) p = Some d -> task_world_wf st ->
    task_world_wf (semaphore_clear_status p d st)).
  { intros st p d   Hlookup Hwf.
    unfold semaphore_clear_status, replace_task_desc_map; cbn.
    constructor; cbn.
    - intros q e Hq.
      destruct (Hmapold _ _ _ _ _ Hlookup Hq) as [e' [He' _]].
      eapply task_wf_map_present; eauto.
    - intros q e Hq Hs.
      destruct (Hmapold _ _ _ _ _ Hlookup Hq) as [e' [He' [Hs' _]]].
      eapply task_wf_init_running_owned; eauto. rewrite Hs'; exact Hs.
    - exact (task_wf_id_nodes _ Hwf).
    - intros q e Hq.
      destruct (Hmapold _ _ _ _ _ Hlookup Hq) as [e' [He' [Hs' Hb']]].
      pose proof (task_wf_priority _ Hwf q e' He'). rewrite Hs', Hb' in H; exact H.
    - intros q e Hq.
      destruct (Hmapold _ _ _ _ _ Hlookup Hq) as [e' [He' _]].
      eapply task_wf_aligned; eauto.
    - intros q e Hq Hs.
      destruct (Hmapold _ _ _ _ _ Hlookup Hq) as [e' [He' [Hs' _]]].
      rewrite <- Hs'. eapply task_wf_running_bitmap; eauto. rewrite Hs'; exact Hs.
    - intros q e Hq Hs.
      destruct (Hmapold _ _ _ _ _ Hlookup Hq) as [e' [He' [Hs' _]]].
      rewrite <- Hs'. eapply task_wf_init_close_bitmap; eauto. rewrite Hs'; exact Hs.
  }
  assert (Hassignwf : forall T p d  a,
    T p = Some d -> assign_world_wf T a ->
    assign_world_wf (update_task_desc_map p (set_task_desc_exstatus d 0) T) a).
  { intros T p d  a Hlookup Hwf.
    destruct Hwf as [Hrun Hready]. constructor.
    - destruct Hrun as [Hrun | [e He]]; [left; exact Hrun|right].
      destruct (Hmapnew T p d  _ _ Hlookup He) as [e' [He' _]]. eauto.
    - unfold os_assign_ready_vector_ok in *.
      destruct Hready as [Hb [Hg Hh]]. split; [|tauto].
      unfold priority_ready_buckets_ok in *.
      assert (Hbs : forall bs index,
        priority_ready_buckets_task_ok T index bs ->
        priority_ready_buckets_task_ok (update_task_desc_map p (set_task_desc_exstatus d 0) T) index bs).
      { intro bs; induction bs as [|bucket rest IH]; intros index Hbs; simpl in *; auto.
        destruct Hbs as [Hbucket Hr]. split.
        - rewrite Forall_forall in *. intros n Hn. specialize (Hbucket n Hn).
          unfold ready_node_at_priority_ok, ready_node_task_desc in *.
          destruct Hbucket as [e [[Hnz [Hptr He]] [Hp [Hm Hst]]]].
          destruct (Hmapnew T p d  _ _ Hlookup He) as [e' [He' [Hs' _]]].
          exists e'; rewrite Hs'; repeat split; auto.
        - apply IH; exact Hr. }
      apply Hbs; exact Hb.
  }
  assert (Hworld : forall sg st p d,
    st.(os_tasks).(task_desc_map) p = Some d -> os_world_wf sg st ->
    os_world_wf sg (semaphore_clear_status p d st)).
  { intros sg st p d Hlookup Hwf.
    assert (Hs : forall entry slot, service_slot_wf st entry slot ->
      service_slot_wf (semaphore_clear_status p d st) entry slot).
    { intros entry slot Hs. unfold service_slot_wf in *.
      destruct (service_phase slot) as [| | q]; auto.
      destruct Hs as [e [He Hentry Hdelay Hown Hid]].
      destruct (Z.eq_dec q p) as [->|Hne].
      - rewrite Hlookup in He. inversion He; subst e.
        exists (set_task_desc_exstatus d 0). constructor; simpl; try assumption.
        unfold semaphore_clear_status, replace_task_desc_map; simpl.
        unfold update_task_desc_map. destruct (Z.eq_dec p p); congruence.
      - exists e. constructor; try assumption.
        unfold semaphore_clear_status, replace_task_desc_map; simpl.
        unfold update_task_desc_map. destruct (Z.eq_dec q p); congruence. }
    constructor.
    - exact (os_wf_context _ _ Hwf).
    - apply Hs. exact (os_wf_recycler _ _ Hwf).
    - change (Forall (service_slot_wf (semaphore_clear_status p d st)
        (os_idle_entry sg)) (os_idle st)).
      rewrite Forall_forall. intros sl Hsl. apply Hs.
      pose proof (os_wf_idle _ _ Hwf) as Hi. rewrite Forall_forall in Hi; auto.
    - exact (os_wf_sched_nodup _ _ Hwf).
    - intro q. change (In q (os_sched_owners st) <->
        update_task_desc_map p (set_task_desc_exstatus d 0)
          (task_desc_map (os_tasks st)) q <> None).
      rewrite (os_wf_sched_domain _ _ Hwf q).
      unfold update_task_desc_map. destruct (Z.eq_dec q p) as [->|Hne]; [rewrite Hlookup|];
        split; intros; discriminate || assumption.
  }
  assert (Hdllmono : forall (A : Type) (P Q : Z -> A -> Assertion),
    (forall l v, P l v |-- Q l v) ->
    forall nodes x px y py, dllseg P x px y py nodes |-- dllseg Q x px y py nodes).
  { intros A P Q HP nodes; induction nodes as [|a rest IH]; intros x px y py.
    - cbn [dllseg]; Intros. split_pure_spatial; [cancel|split_pures; dump_pre_spatial; tauto].
    - cbn [dllseg]. fold (@dllseg A P) (@dllseg A Q). Intros z.
      Exists z. split_pure_spatial.
      + sep_apply_l_atomic (HP x (getData a)).
        sep_apply_l_atomic (IH z x y py). cancel.
        change (dllseg Q z x y py rest |-- dllseg Q z x y py rest). cancel.
      + split_pures; dump_pre_spatial; auto.
  }
  assert (Hsdllmono : forall (A : Type) (P Q : Z -> A -> Assertion),
    (forall l v, P l v |-- Q l v) -> forall head nodes,
    store_dll P head nodes |-- store_dll Q head nodes).
  { intros A P Q HP head nodes. unfold store_dll. Intros h pt. Exists h pt.
    split_pure_spatial.
    - sep_apply_l_atomic (Hdllmono A P Q HP nodes h head head pt). cancel.
    - split_pures; dump_pre_spatial; tauto.
  }
  assert (Hpub : forall T p d  status l q,
    T p = Some d ->
    pure_published_slink T status l q |--
    pure_published_slink (update_task_desc_map p (set_task_desc_exstatus d 0) T) status l q).
  { intros T p d  status l q Hl. unfold pure_published_slink. Intros e.
    assert (He : T q = Some e) by tauto.
    destruct (Hmapnew T p d  q e Hl He) as [e' [He' [Hsch _]]].
    Exists e'. split_pure_spatial; [cancel|]. split_pures; dump_pre_spatial; rewrite ?Hsch; tauto.
  }
  assert (Howned : forall T p d  tasks,
    T p = Some d ->
    store_owned_sched_nodes T tasks |--
    store_owned_sched_nodes (update_task_desc_map p (set_task_desc_exstatus d 0) T) tasks).
  { intros T p d  tasks Hl.
    assert (Hdet : forall q, store_detached_sched_link T q |--
      store_detached_sched_link (update_task_desc_map p (set_task_desc_exstatus d 0) T) q).
    { intro q. unfold store_detached_sched_link. Intros e.
      assert (He : T q = Some e) by tauto.
      destruct (Hmapnew T p d  q e Hl He) as [e' [He' [Hsch _]]].
      Exists e'. split_pure_spatial; [cancel|]. split_pures; dump_pre_spatial; rewrite ?Hsch; tauto. }
    unfold store_owned_sched_nodes.
    induction tasks as [|q tasks IH]; cbn [map]; [cancel|].
    rewrite !logic_equiv_iter_sepcon_cons.
    sep_apply_l_atomic (Hdet q). sep_apply_l_atomic IH. cancel.
  }
  assert (Hsemmono : forall (P Q : Z -> Z -> Assertion),
    (forall l q, P l q |-- Q l q) -> forall sst sems,
    semaphore_inv P sst sems |-- semaphore_inv Q sst sems).
  { intros P Q HP sst sems.
    assert (Hpay : forall l v, store_semaphore P l v |-- store_semaphore Q l v).
    { intros l v. pose (p := semaphore_addr v). unfold store_semaphore. fold p. Intros. split_pure_spatial.
      - sep_apply_l_atomic (Hsdllmono Z P Q HP
          (&(p # "Semaphore" ->ₛ "pend_list"))
          (map semaphore_wait_node (semaphore_pending_addrs v))). unfold p. cancel.
        change (store_dll Q (&(p # "Semaphore" ->ₛ "pend_list")) (map semaphore_wait_node (semaphore_pending_addrs v)) |-- store_dll Q (&(p # "Semaphore" ->ₛ "pend_list")) (map semaphore_wait_node (semaphore_pending_addrs v))). cancel.
      - split_pures; dump_pre_spatial; tauto. }
    unfold semaphore_inv. Intros. split_pure_spatial.
    - sep_apply_l_atomic (Hsdllmono SemaphoreAbs (store_semaphore P) (store_semaphore Q)
        Hpay (semaphore_list_head sst) (map semaphore_link_node sems)). cancel.
    - split_pures; dump_pre_spatial; tauto.
  }
  assert (Hmutexmono : forall (P Q : Z -> Z -> Assertion),
    (forall l q, P l q |-- Q l q) -> forall sst vals,
    mutex_inv P sst vals |-- mutex_inv Q sst vals).
  { intros P Q HP sst vals.
    assert (Hpay : forall l v, store_mutex P l v |-- store_mutex Q l v).
    { intros l v. pose (p := mutex_addr v). unfold store_mutex. fold p. Intros. split_pure_spatial.
      - sep_apply_l_atomic (Hsdllmono Z P Q HP
          (&(p # "Mutex" ->ₛ "pend_list"))
          (map mutex_wait_node (mutex_pending_addrs v))). unfold p. cancel.
        change (store_dll Q (&(p # "Mutex" ->ₛ "pend_list")) (map mutex_wait_node (mutex_pending_addrs v)) |-- store_dll Q (&(p # "Mutex" ->ₛ "pend_list")) (map mutex_wait_node (mutex_pending_addrs v))). cancel.
      - split_pures; dump_pre_spatial; tauto. }
    unfold mutex_inv. Intros. split_pure_spatial.
    - sep_apply_l_atomic (Hsdllmono MutexAbs (store_mutex P) (store_mutex Q)
        Hpay (mutex_list_head sst) (map mutex_link_node vals)). cancel.
    - split_pures; dump_pre_spatial; tauto.
  }
  assert (Heventmono : forall (P Q : Z -> Z -> Assertion),
    (forall l q, P l q |-- Q l q) -> forall sst vals,
    event_inv P sst vals |-- event_inv Q sst vals).
  { intros P Q HP sst vals.
    assert (Hpay : forall l v, store_event P l v |-- store_event Q l v).
    { intros l v. pose (p := event_addr v). unfold store_event. fold p. Intros. split_pure_spatial.
      - sep_apply_l_atomic (Hsdllmono Z P Q HP
          (&(p # "Event" ->ₛ "pend_list"))
          (map event_wait_node (event_pending_addrs v))). unfold p. cancel.
        change (store_dll Q (&(p # "Event" ->ₛ "pend_list")) (map event_wait_node (event_pending_addrs v)) |-- store_dll Q (&(p # "Event" ->ₛ "pend_list")) (map event_wait_node (event_pending_addrs v))). cancel.
      - split_pures; dump_pre_spatial; tauto. }
    unfold event_inv. Intros. split_pure_spatial.
    - sep_apply_l_atomic (Hsdllmono EventAbs (store_event P) (store_event Q)
        Hpay (event_list_head sst) (map event_link_node vals)). cancel.
    - split_pures; dump_pre_spatial; tauto.
  }
  assert (Hzombie : forall T p d  head vals,
    T p = Some d ->
    store_zombie_queue T head vals |--
    store_zombie_queue (update_task_desc_map p (set_task_desc_exstatus d 0) T) head vals).
  { intros T p d  head vals Hl. destruct vals; cbn [store_zombie_queue]; [cancel|].
    apply Hsdllmono. intros l q. apply Hpub; exact Hl.
  }
  assert (Hassign : forall sg st p d  ,
    st.(os_tasks).(task_desc_map) p = Some d ->
    assign_inv sg st |-- assign_inv sg (semaphore_clear_status p d st)).
  { intros sg st p d   Hl.
    unfold assign_inv, semaphore_clear_status, replace_task_desc_map; cbn.
    Intros. split_pure_spatial; [cancel|].
    split_pures; dump_pre_spatial; apply Hassignwf; assumption.
  }

  assert (Hdelay : forall sg st p d,
    task_desc_map (os_tasks st) p = Some d ->
    delay_inv sg st |-- delay_inv sg (semaphore_clear_status p d st)).
  { intros sg st p d Hl. unfold delay_inv. Intros_p Hw.
    split_pure_spatial; [unfold semaphore_clear_status, replace_task_desc_map; cbn; cancel|]. split_pures; dump_pre_spatial.
    change (delay_world_wf (update_task_desc_map p (set_task_desc_exstatus d 0)
      (task_desc_map (os_tasks st))) (delay_inactive_map (os_delays st))
      (delay_active_nodes (os_delays st))).
    destruct Hw as [Hz Hi Ha Hsorted Hstatus]. constructor; auto.
    - intros q e He. unfold update_task_desc_map in He.
      destruct (Z.eq_dec q p) as [->|Hne].
      + inversion He; subst e. exact (Hz p d Hl).
      + exact (Hz q e He).
    - intros a info Hinfo. destruct (Hi a info Hinfo) as [e [He Hd]].
      unfold update_task_desc_map.
      destruct (Z.eq_dec (tdTaskPtr info) p) as [Hq|Hq].
      + rewrite Hq, Hl in He. inversion He; subst e.
        exists (set_task_desc_exstatus d 0); simpl; tauto.
      + exists e; tauto.
    - intros node Hnode. destruct (Ha node Hnode) as [e [He Hp]].
      unfold update_task_desc_map.
      destruct (Z.eq_dec (tdTaskPtr (getData node)) p) as [Hq|Hq].
      + rewrite Hq, Hl in He. inversion He; subst e.
        exists (set_task_desc_exstatus d 0); simpl; tauto.
      + exists e; tauto.
  }
 set (Drest := fun (p : addr) (d : TaskDescriptorAbs) =>
    “ aligned_reglen d.(tdStackPoint) /\
      d.(tdBaseInfo).(tbStackStart) <= d.(tdStackPoint) /\
      d.(tdStackPoint) + sizeof("StackRegisterContext") <= kss_aligned_top d.(tdBaseInfo) /\
      addr_aligned p ALIGN_SIZE ” &&
    store_task_sched_member (&(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) d.(tdSchedMember) **
    &(p # "TaskDescriptor" ->ₛ "stack_point") # Ptr |-> d.(tdStackPoint) **
    store_task_base_info p d.(tdBaseInfo) **
    &(p # "TaskDescriptor" ->ₛ "event_id_trigger") # UInt |-> d.(tdEventIdTrigger) **
    &(p # "TaskDescriptor" ->ₛ "event_mode") # UInt |-> d.(tdEventMode) **
    &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay") # Ptr |-> d.(tdDelay) **
    &(p # "TaskDescriptor" ->ₛ "Done") # Ptr |-> d.(tdDone) **
    store_task_descriptor_padding p **
    store_ktask_stack d.(tdBaseInfo).(tbStackStart) d.(tdBaseInfo).(tbStackDepth) d.(tdStackRaw) d.(tdStackContext)).
  assert (Hdescsplit : forall p d, store_published_task p d |--
    &(p # "TaskDescriptor" ->ₛ "exstatus") # Int |-> d.(tdExstatus) ** Drest p d).
  { intros p d. unfold Drest, store_published_task, store_task_descriptor.
    Intros. split_pure_spatial; [cancel|]. split_pures; dump_pre_spatial; tauto. }
  assert (Hdescnew : forall p d,
    &(p # "TaskDescriptor" ->ₛ "exstatus") # Int |-> 0 ** Drest p d
    |-- store_published_task p (set_task_desc_exstatus d 0)).
  { intros p d. unfold Drest, store_published_task, store_task_descriptor, set_task_desc_exstatus; cbn.
    Intros. split_pure_spatial; [cancel|]. split_pures; dump_pre_spatial; tauto. }
  destruct PreH16 as [desc [Hlookup Hadm]].
  assert (Hadmiss : linklist_suspend_admissible (assignRunningTask (os_assign held)) 1 held).
  { exists desc; tauto. }
  set (p := assignRunningTask (os_assign held)) in *.
set (R :=
    “ os_world_wf sg_semaphore_obtain_oc held /\ task_world_wf held ” &&
    store_idmanager sg_semaphore_obtain_oc.(os_task_stable).(task_stable_ids)
      held.(os_tasks).(task_idmanager_abs) sg_semaphore_obtain_oc.(os_task_stable).(task_idmanager_ptr) **
    store_dll pure_task_link_member sg_semaphore_obtain_oc.(os_task_stable).(task_list_head)
      (task_link_nodes held.(os_tasks).(task_ptr_list)) **
    store_map_missing_i store_published_task held.(os_tasks).(task_desc_map) p **
    Drest p desc **
    store_owned_sched_nodes held.(os_tasks).(task_desc_map) held.(os_tasks).(sched_owned_tasks) **
    store_task_done sg_semaphore_obtain_oc.(os_task_stable).(task_done_ptr)
      sg_semaphore_obtain_oc.(os_task_stable).(task_done_abs) **
    tick_inv sg_semaphore_obtain_oc held **
    delay_inv sg_semaphore_obtain_oc held **
    assign_inv sg_semaphore_obtain_oc held **
    store_prio_lookup_table **
    store_zombie_queue held.(os_tasks).(task_desc_map)
      sg_semaphore_obtain_oc.(os_zombie_head) held.(zombie_queue) **
    sg_semaphore_obtain_oc.(os_recycler_slot) # Int |-> held.(os_recycle).(service_id) **
    IntArray.full sg_semaphore_obtain_oc.(os_idle_array) CORE_COUNT (map service_id held.(os_idle)) **
    isrmanager_inv sg_semaphore_obtain_oc.(os_isr_stable) held.(os_isr) **
    exstatus_inv sg_semaphore_obtain_oc held **
    semaphore_inv (pure_suspend_sched_link held.(os_tasks).(task_desc_map))
      sg_semaphore_obtain_oc.(os_semaphore_stable) held.(os_semaphores) **
    mutex_inv (pure_suspend_sched_link held.(os_tasks).(task_desc_map))
      sg_semaphore_obtain_oc.(os_mutex_stable) held.(os_mutexes) **
    event_inv (pure_suspend_sched_link held.(os_tasks).(task_desc_map))
      sg_semaphore_obtain_oc.(os_event_stable) held.(os_events) **
    dataqueue_inv held.(os_semaphores) held.(os_dataqueues)).
  assert (Hcut : os_inv sg_semaphore_obtain_oc held |--
    &(p # "TaskDescriptor" ->ₛ "exstatus") # Int |-> desc.(tdExstatus) ** R).
  { unfold R, os_inv, task_inv. Intros.
    sep_apply_l_atomic (store_map_split store_published_task p desc
      (task_desc_map (os_tasks held)) Hlookup).
    sep_apply_l_atomic (Hdescsplit p desc).
    split_pure_spatial; [cancel|]. split_pures; dump_pre_spatial; tauto. }
  assert (Hrestore : &(p # "TaskDescriptor" ->ₛ "exstatus") # Int |-> 0 ** R
    |-- os_inv sg_semaphore_obtain_oc (semaphore_clear_status p desc held)).
  { unfold R. Intros.
    assert (How : os_world_wf sg_semaphore_obtain_oc (semaphore_clear_status p desc held)).
    { apply Hworld; auto; tauto. }
    assert (Htw : task_world_wf (semaphore_clear_status p desc held)).
    { apply Htaskwf; auto; tauto. }
      assert (Hlook : update_task_desc_map p (set_task_desc_exstatus desc 0)
        (task_desc_map (os_tasks held)) p = Some (set_task_desc_exstatus desc 0)).
      { unfold update_task_desc_map. destruct (Z.eq_dec p p); congruence. }

      assert (Hmiss : store_map_missing_i store_published_task (task_desc_map (os_tasks held)) p |--
        store_map_missing_i store_published_task
          (update_task_desc_map p (set_task_desc_exstatus desc 0) (task_desc_map (os_tasks held))) p).
      { assert (Heq : forall q, q <> p -> task_desc_map (os_tasks held) q =
          update_task_desc_map p (set_task_desc_exstatus desc 0) (task_desc_map (os_tasks held)) q).
        { intros q Hq. unfold update_task_desc_map; destruct (Z.eq_dec q p); [contradiction|reflexivity]. }
        exact (proj1 (store_map_missing_i_equiv store_published_task
          (task_desc_map (os_tasks held))
          (update_task_desc_map p (set_task_desc_exstatus desc 0) (task_desc_map (os_tasks held)))
          p Heq)). }

      sep_apply_l_atomic Hmiss.


      sep_apply_l_atomic (Hdescnew p desc ).
      sep_apply_l_atomic (store_map_merge store_published_task p (set_task_desc_exstatus desc 0)
        (update_task_desc_map p (set_task_desc_exstatus desc 0) (task_desc_map (os_tasks held))) Hlook).

      sep_apply_l_atomic (Howned (task_desc_map (os_tasks held)) p desc 
        (sched_owned_tasks (os_tasks held)) Hlookup).

      sep_apply_l_atomic (Hassign sg_semaphore_obtain_oc held p desc   Hlookup).

      sep_apply_l_atomic (Hzombie (task_desc_map (os_tasks held)) p desc 
        (os_zombie_head sg_semaphore_obtain_oc) (zombie_queue held) Hlookup).

      assert (Hwait : forall l q, pure_suspend_sched_link (task_desc_map (os_tasks held)) l q |--
        pure_suspend_sched_link
          (update_task_desc_map p (set_task_desc_exstatus desc 0) (task_desc_map (os_tasks held))) l q).
      { intros; apply Hpub; exact Hlookup. }
      sep_apply_l_atomic (Hsemmono _ _ Hwait (os_semaphore_stable sg_semaphore_obtain_oc) (os_semaphores held)).
      sep_apply_l_atomic (Hmutexmono _ _ Hwait (os_mutex_stable sg_semaphore_obtain_oc) (os_mutexes held)).
      sep_apply_l_atomic (Heventmono _ _ Hwait (os_event_stable sg_semaphore_obtain_oc) (os_events held)).

      sep_apply_l_atomic (Hdelay sg_semaphore_obtain_oc held p desc Hlookup).
      unfold os_inv, task_inv. cbv beta iota zeta. split_pure_spatial.
      + match goal with |- ?L |-- _ => change (L |--
store_idmanager sg_semaphore_obtain_oc.(os_task_stable).(task_stable_ids)
    held.(os_tasks).(task_idmanager_abs)
    sg_semaphore_obtain_oc.(os_task_stable).(task_idmanager_ptr) **
  store_dll pure_task_link_member sg_semaphore_obtain_oc.(os_task_stable).(task_list_head)
    (task_link_nodes held.(os_tasks).(task_ptr_list)) **
  store_map store_published_task (update_task_desc_map p (set_task_desc_exstatus desc 0) (task_desc_map (os_tasks held))) **
  store_owned_sched_nodes (update_task_desc_map p (set_task_desc_exstatus desc 0) (task_desc_map (os_tasks held)))
    held.(os_tasks).(sched_owned_tasks) **
  store_task_done sg_semaphore_obtain_oc.(os_task_stable).(task_done_ptr)
    sg_semaphore_obtain_oc.(os_task_stable).(task_done_abs) **
tick_inv sg_semaphore_obtain_oc held **
  delay_inv sg_semaphore_obtain_oc (semaphore_clear_status p desc held) **
  assign_inv sg_semaphore_obtain_oc (semaphore_clear_status p desc held) **
  store_prio_lookup_table **
  store_zombie_queue (update_task_desc_map p (set_task_desc_exstatus desc 0) (task_desc_map (os_tasks held)))
    sg_semaphore_obtain_oc.(os_zombie_head) held.(zombie_queue) **
  sg_semaphore_obtain_oc.(os_recycler_slot) # Int |-> held.(os_recycle).(service_id) **
  IntArray.full sg_semaphore_obtain_oc.(os_idle_array) CORE_COUNT (map service_id held.(os_idle)) **
  isrmanager_inv sg_semaphore_obtain_oc.(os_isr_stable) held.(os_isr) **
  exstatus_inv sg_semaphore_obtain_oc held **
  semaphore_inv (pure_suspend_sched_link (update_task_desc_map p (set_task_desc_exstatus desc 0) (task_desc_map (os_tasks held)))) sg_semaphore_obtain_oc.(os_semaphore_stable) held.(os_semaphores) **
  mutex_inv (pure_suspend_sched_link (update_task_desc_map p (set_task_desc_exstatus desc 0) (task_desc_map (os_tasks held)))) sg_semaphore_obtain_oc.(os_mutex_stable) held.(os_mutexes) **
  event_inv (pure_suspend_sched_link (update_task_desc_map p (set_task_desc_exstatus desc 0) (task_desc_map (os_tasks held)))) sg_semaphore_obtain_oc.(os_event_stable) held.(os_events) **
  dataqueue_inv held.(os_semaphores) held.(os_dataqueues)) end.
        sepcon_assoc_change; cancel.
      + split_pures; dump_pre_spatial; tauto.
  }
  Exists desc.
  split_pure_spatial.
  - sep_apply_l_atomic Hcut.
    cancel (InsideCritical sg_semaphore_obtain_oc held).
    cancel (&(p # "TaskDescriptor" ->ₛ "exstatus") # Int |-> tdExstatus desc).
    apply_sepcon_adjoint. sep_apply_l_atomic Hrestore. cancel.
  - split_pures; dump_pre_spatial; auto.
Qed.
Lemma proof_of__SemaphoreObtain_entail_wit_9_split_goal_1 : _SemaphoreObtain_entail_wit_9_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  unfold linklist_suspend_admissible in *.
  destruct PreH17 as [d [Hd Hadm]].
  rewrite <- PreH10 in Hd, Hadm.
  rewrite PreH11 in Hd. inversion Hd; subst d.
  exists (set_task_desc_exstatus desc 0).
  unfold semaphore_clear_status, replace_task_desc_map; simpl.
  split.
  - unfold update_task_desc_map. destruct (Z.eq_dec task task); congruence.
  - intros _. specialize (Hadm ltac:(auto)).
    unfold ktask_not_os_service in *. simpl in *. rewrite <- PreH10. exact Hadm.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_9_split_goal_2 : _SemaphoreObtain_entail_wit_9_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial. unfold semaphore_pending_nodes.
  exists original. unfold semaphore_clear_status, replace_task_desc_map; simpl.
  repeat split; auto; congruence.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_9_split_goal_3 : _SemaphoreObtain_entail_wit_9_split_goal_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_9_split_goal_spatial : _SemaphoreObtain_entail_wit_9_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  sep_apply_r_atomic (derivable1_wand_elim1
    (store_int (&(task # "TaskDescriptor" ->ₛ "exstatus")) 0)
    (os_inv sg_semaphore_obtain_oc (semaphore_clear_status task desc held))).
  repeat progress cancel.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_9 : _SemaphoreObtain_entail_wit_9.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreObtain_entail_wit_9_split_goal_spatial.
  - Goal_apply proof_of__SemaphoreObtain_entail_wit_9_split_goal_1.
  - Goal_apply proof_of__SemaphoreObtain_entail_wit_9_split_goal_2.
  - Goal_apply proof_of__SemaphoreObtain_entail_wit_9_split_goal_3.
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_10 : _SemaphoreObtain_entail_wit_10.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  pose proof PreH2 as Hprio.
  unfold linklist_suspend_prio, linklist_suspend_step in Hprio.
  destruct Hprio as [[Hbad _]|[_ [_ [staged [ignored [Hs Henq]]]]]]; [tauto|].
  assert (Hnonzero : task <> 0).
  { unfold ktask_suspend_step in Hs. tauto. }
  unfold linklist_semaphore_enqueue in Henq.
  destruct Henq as [obj [sd [nodes [Hi [Ha [Hlookup [Hstat [Howned [Hins Hafter]]]]]]]]].
  assert (Hlookupafter : task_desc_map (os_tasks after) task = Some sd).
  { rewrite Hafter. unfold replace_sched_owned_tasks, semaphore_enqueue_state,
      replace_semaphores. simpl. exact Hlookup. }
  Exists sd after.
  split_pure_spatial; [repeat progress cancel|].
  split_pures; dump_pre_spatial; try assumption.
  rewrite <- PreH10, <- PreH12 in PreH18.
  exact (PreH18 desc after sd PreH11 PreH2 Hlookupafter).
Qed.

Lemma proof_of__SemaphoreObtain_entail_wit_11 : _SemaphoreObtain_entail_wit_11.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_12_1_split_goal_1 : _SemaphoreObtain_entail_wit_12_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_12_1_split_goal_spatial : _SemaphoreObtain_entail_wit_12_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_12_1 : _SemaphoreObtain_entail_wit_12_1.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_12_2_split_goal_1 : _SemaphoreObtain_entail_wit_12_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_12_2_split_goal_spatial : _SemaphoreObtain_entail_wit_12_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_12_2 : _SemaphoreObtain_entail_wit_12_2.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_13_1_split_goal_1 : _SemaphoreObtain_entail_wit_13_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_13_1_split_goal_2 : _SemaphoreObtain_entail_wit_13_1_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_13_1 : _SemaphoreObtain_entail_wit_13_1.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_13_2_split_goal_1 : _SemaphoreObtain_entail_wit_13_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_13_2_split_goal_2 : _SemaphoreObtain_entail_wit_13_2_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_13_2 : _SemaphoreObtain_entail_wit_13_2.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_14_1 : _SemaphoreObtain_entail_wit_14_1.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_14_2 : _SemaphoreObtain_entail_wit_14_2.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_14_3 : _SemaphoreObtain_entail_wit_14_3.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_15_split_goal_1 : _SemaphoreObtain_entail_wit_15_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_15 : _SemaphoreObtain_entail_wit_15.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_16 : _SemaphoreObtain_entail_wit_16.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_entail_wit_17_split_goal_1 : _SemaphoreObtain_entail_wit_17_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_17_split_goal_2 : _SemaphoreObtain_entail_wit_17_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_17_split_goal_spatial : _SemaphoreObtain_entail_wit_17_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_entail_wit_17 : _SemaphoreObtain_entail_wit_17.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_return_wit_6_split_goal_1 : _SemaphoreObtain_return_wit_6_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_return_wit_6 : _SemaphoreObtain_return_wit_6.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_return_wit_7_split_goal_1 : _SemaphoreObtain_return_wit_7_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_return_wit_7 : _SemaphoreObtain_return_wit_7.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_return_wit_8_split_goal_1 : _SemaphoreObtain_return_wit_8_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_return_wit_8 : _SemaphoreObtain_return_wit_8.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_partial_solve_wit_19_pure_split_goal_1 : _SemaphoreObtain_partial_solve_wit_19_pure_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_partial_solve_wit_19_pure : _SemaphoreObtain_partial_solve_wit_19_pure.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_which_implies_wit_1_split_goal_spatial : _SemaphoreObtain_which_implies_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_which_implies_wit_1 : _SemaphoreObtain_which_implies_wit_1.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_which_implies_wit_2_split_goal_spatial : _SemaphoreObtain_which_implies_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_which_implies_wit_2 : _SemaphoreObtain_which_implies_wit_2.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_which_implies_wit_3_split_goal_spatial : _SemaphoreObtain_which_implies_wit_3_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_which_implies_wit_3 : _SemaphoreObtain_which_implies_wit_3.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_which_implies_wit_4 : _SemaphoreObtain_which_implies_wit_4.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_which_implies_wit_6_split_goal_spatial : _SemaphoreObtain_which_implies_wit_6_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_which_implies_wit_6 : _SemaphoreObtain_which_implies_wit_6.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_which_implies_wit_7_split_goal_spatial : _SemaphoreObtain_which_implies_wit_7_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv. Intros_p Hworld.
  assert (Hassign : assign_ptr (os_assign_stable sg_semaphore_obtain_oc) = &("Assign")).
  { pose proof (os_wf_context _ _ Hworld) as Hctx.
    unfold os_global_context, assign_context in Hctx; tauto. }
  unfold assign_inv. Intros_p Hawf. rewrite Hassign.
  csimpl. cancel (store_ptr (&(&("Assign") ->ₛ "os_running_task")) (assignRunningTask (os_assign held))). apply_sepcon_adjoint.
  split_pure_spatial; [repeat progress cancel|].
  split_pures; dump_pre_spatial; assumption.
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_7 : _SemaphoreObtain_which_implies_wit_7.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreObtain_which_implies_wit_7_split_goal_spatial.
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_8_split_goal_spatial : _SemaphoreObtain_which_implies_wit_8_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  sep_apply_r_atomic (derivable1_wand_elim1
    (store_ptr (&(&("Assign") ->ₛ "os_running_task")) task)
    (os_inv sg_semaphore_obtain_oc held)).
  cancel.
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_8 : _SemaphoreObtain_which_implies_wit_8.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreObtain_which_implies_wit_8_split_goal_spatial.
Qed.

Lemma proof_of__SemaphoreObtain_which_implies_wit_10 : _SemaphoreObtain_which_implies_wit_10.
Proof. Admitted.

Lemma proof_of__SemaphoreObtain_which_implies_wit_11_split_goal_spatial : _SemaphoreObtain_which_implies_wit_11_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreObtain_which_implies_wit_11 : _SemaphoreObtain_which_implies_wit_11.
Proof. Admitted.

