From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.pendlist Require Import LinklistSuspendSemaphore_goal.
From CRTOS_Verify.VC.pendlist Require Import LinklistSuspendSemaphore_proof_auto.
Require Import CRTOS_Verify.lib.id.IdModuleSpec.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreDelete CRTOS_Verify.lib.delay.KTaskUnSetDelay.
Require Import CRTOS_Verify.lib.list.DoubleLinkListSpec CRTOS_Verify.lib.task.TaskStatusMemory CRTOS_Verify.lib.task.KTaskParseInfo.
Import IDNode DLL.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreAbandon.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreObtain.
Import SimpleC.CoreLang.CTypes.SimpleCtypeNotations.
Local Open Scope sac.

Lemma proof_of_LinklistSuspend_entail_wit_1_1 : LinklistSuspend_entail_wit_1_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_1_2 : LinklistSuspend_entail_wit_1_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_2_1 : LinklistSuspend_entail_wit_2_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_2_2 : LinklistSuspend_entail_wit_2_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_3 : LinklistSuspend_entail_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hremove_same : forall (l:list Z) t, ~ In t l -> remove Z.eq_dec t l = l).
  { clear. induction l as [|x xs IH]; intros t H; simpl; auto.
    destruct (Z.eq_dec t x); [subst; exfalso; apply H; simpl; tauto|].
    f_equal. apply IH. intro Hin; apply H; simpl; tauto. }
  assert (Hownedcut : forall T l t, NoDup l -> In t l ->
    store_owned_sched_nodes T l |--
    store_detached_sched_link T t ** store_owned_sched_nodes T (remove Z.eq_dec t l)).
  { intros T l. induction l as [|x xs IH]; intros t Hnd Hin; [contradiction|].
    inversion Hnd as [|? ? Hnot Htail]; subst.
    unfold store_owned_sched_nodes in *. cbn [map remove].
    rewrite logic_equiv_iter_sepcon_cons.
    destruct (Z.eq_dec t x) as [Heq|Hneq].
    - subst t. rewrite Hremove_same by exact Hnot. cancel.
    - cbn [map]. rewrite logic_equiv_iter_sepcon_cons.
      sep_apply_l_atomic (IH t Htail ltac:(simpl in Hin; intuition congruence)).
      cancel. }
  assert (Hfresh : forall wait l x px y py p v,
    dllseg (store_semaphore wait) x px y py (map semaphore_link_node l) **
    &(p # "Semaphore" ->ₛ "value") # UShort |-> v |--
    “ ~ In p (map semaphore_addr l) ”).
  { clear.
    intros wait l. induction l as [|a l IH]; intros x px y py p v.
    - cbn [map]. dump_pre_spatial. simpl. tauto.
    - cbn [map dllseg]. Intros z.
      destruct (Z.eq_dec p (semaphore_addr a)) as [Heq|Hneq].
      + unfold store_semaphore. Intros. rewrite Heq.
        let q := constr:(semaphore_addr a) in
        sep_apply_l_atomic (store_ushort_undef_store_ushort (&(q # "Semaphore" ->ₛ "value")) (semaphore_value a)).
        let q := constr:(semaphore_addr a) in
        sep_apply_l_atomic (store_ushort_undef_store_ushort (&(q # "Semaphore" ->ₛ "value")) v).
        let q := constr:(semaphore_addr a) in
        sep_apply_l_atomic (undef_store_int_exclusive 2 2 (&(q # "Semaphore" ->ₛ "value")) ltac:(lia)).
        Intros_p Hbad. contradiction.
      + change (store_semaphore wait x a **
          (&(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
          (&(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
          (dllseg (store_semaphore wait) z x y py (map semaphore_link_node l) **
          &(p # "Semaphore" ->ₛ "value") # UShort |-> v))) |--
          “ ~ In p (semaphore_addr a :: map semaphore_addr l) ”).
        sep_apply (IH z x y py p v). Intros_p Htail.
        dump_pre_spatial. simpl. intuition congruence. }
  assert (Hsemcut : forall wait hd pre obj post,
    store_dll (store_semaphore wait) hd (map semaphore_link_node (pre ++ obj::post)) |--
    EX h pt x px z,
    “ hd<>0 /\ pt<>0 /\ h<>0 /\
       dll_nodes_nonzero (map semaphore_link_node (pre ++ obj::post)) /\
       x = getPtr (semaphore_link_node obj) ” &&
    &(hd # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> pt **
    &(hd # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> h **
    dllseg (store_semaphore wait) h hd x px (map semaphore_link_node pre) **
    store_semaphore wait x obj **
    &(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
    &(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
    dllseg (store_semaphore wait) z x hd pt (map semaphore_link_node post)).
  { intros. unfold store_dll. Intros h pt. rewrite map_app.
    sep_apply_l_atomic (dllseg_split (store_semaphore wait) h hd hd pt
      (map semaphore_link_node pre) (map semaphore_link_node (obj::post))).
    Intros x px. cbn [map dllseg]. Intros z.
    Exists h pt x px z. split_pure_spatial.
    - cbn [semaphore_link_node getData]. fold (@dllseg SemaphoreAbs (store_semaphore wait)). sepcon_assoc_change; repeat progress cancel.
      change (dllseg (store_semaphore wait) z x hd pt (map semaphore_link_node post) |-- dllseg (store_semaphore wait) z x hd pt (map semaphore_link_node post)).
      cancel.
    - rewrite map_app in H. cbn [map] in H. split_pures; dump_pre_spatial; intuition. }
  destruct PreH8 as [obj [Hobj [Haddr Hnodes]]].
  assert (Hwaiting : semaphore_pending_addrs obj = waiting_semaphore_ic).
  { apply (f_equal (map (@getData Z))) in Hnodes.
    rewrite !map_map in Hnodes. change (map (fun x:Z=>x) (semaphore_pending_addrs obj) = map (fun x:Z=>x) waiting_semaphore_ic) in Hnodes.
    now rewrite !map_id in Hnodes. }
  apply in_split in Hobj as [pre [post Hsems]].
  unfold os_inv at 1. Intros_p Hworld.
  unfold task_inv at 1. Intros_p Htask.
  unfold semaphore_inv at 1. Intros_p Hcontext.
  assert (Hndowned : NoDup (sched_owned_tasks (os_tasks staged))).
  { pose proof (os_wf_sched_nodup _ _ Hworld) as Hnd. unfold os_sched_owners in Hnd.
    apply NoDup_app_remove_r in Hnd. exact Hnd. }
  sep_apply_l_atomic (Hownedcut (task_desc_map (os_tasks staged))
    (sched_owned_tasks (os_tasks staged)) task_pre Hndowned PreH12).
  rewrite Hsems.
  sep_apply_l_atomic (Hsemcut (pure_suspend_sched_link (task_desc_map (os_tasks staged)))
    (semaphore_list_head (os_semaphore_stable sg_semaphore_ic)) pre obj post).
  Intros h pt x px z.
  unfold store_semaphore at 2. Intros.
  prop_apply_p (Hfresh (pure_suspend_sched_link (task_desc_map (os_tasks staged))) pre
    h (semaphore_list_head (os_semaphore_stable sg_semaphore_ic)) x px
    (semaphore_addr obj) (semaphore_value obj)).
  Intros_p Hpre_absent.
  prop_apply_p (Hfresh (pure_suspend_sched_link (task_desc_map (os_tasks staged))) post
    z x (semaphore_list_head (os_semaphore_stable sg_semaphore_ic)) pt
    (semaphore_addr obj) (semaphore_value obj)).
  Intros_p Hpost_absent.
  set (obj' := {| semaphore_addr := semaphore_addr obj;
    semaphore_id := semaphore_id obj; semaphore_value := semaphore_value obj;
    semaphore_pending_addrs := waiting_semaphore_ic ++ [task_pre] |}).
  set (after := replace_sched_owned_tasks (remove Z.eq_dec task_pre (sched_owned_tasks (os_tasks staged)))
    (semaphore_enqueue_state sem_semaphore_ic (waiting_semaphore_ic ++ [task_pre]) staged)).
  assert (Hmap_same : forall l,
    ~ In (semaphore_addr obj) (map semaphore_addr l) ->
    map (fun s => if Z.eq_dec (semaphore_addr s) sem_semaphore_ic then
      {|semaphore_addr:=semaphore_addr s;semaphore_id:=semaphore_id s;
        semaphore_value:=semaphore_value s;semaphore_pending_addrs:=waiting_semaphore_ic++[task_pre]|}
      else s) l = l).
  { intros l. induction l as [|a l IH]; intro Hnot; simpl; [reflexivity|].
    destruct (Z.eq_dec (semaphore_addr a) sem_semaphore_ic) as [Heq|Hneq].
    - exfalso. apply Hnot. simpl. left. congruence.
    - f_equal. apply IH. intro Hin; apply Hnot; simpl; auto. }
  assert (Haftersems : os_semaphores after = pre ++ obj' :: post).
  { unfold after, semaphore_enqueue_state, replace_sched_owned_tasks, replace_semaphores. cbn.
    rewrite Hsems, map_app. cbn [map]. rewrite Haddr.
    destruct (Z.eq_dec sem_semaphore_ic sem_semaphore_ic); [|contradiction].
    rewrite (Hmap_same pre Hpre_absent), (Hmap_same post Hpost_absent). unfold obj'. rewrite Haddr. reflexivity. }
  assert (Hmanager : semaphore_manager (os_semaphores after) = semaphore_manager (os_semaphores staged)).
  { rewrite Haftersems, Hsems. unfold semaphore_manager.
    f_equal.
    - rewrite !map_app. reflexivity.
    - apply map_ext. intro i. rewrite !filter_app, !map_app. cbn [filter].
      unfold obj'. cbn. destruct (Z.eqb (semaphore_id obj mod 16) (Z.of_nat i)); reflexivity. }
  assert (Hownperm : Permutation (sched_owned_tasks (os_tasks staged))
      (task_pre :: remove Z.eq_dec task_pre (sched_owned_tasks (os_tasks staged)))).
  { revert Hndowned PreH12. generalize (sched_owned_tasks (os_tasks staged)) as l.
    intros l. induction l as [|a l IH]; intros Hnd Hin; [contradiction|].
    inversion Hnd as [|? ? Hnot Hnd']; subst. cbn [remove].
    destruct (Z.eq_dec task_pre a) as [Heq|Hneq].
    - subst a. rewrite Hremove_same by exact Hnot. apply Permutation_refl.
    - eapply Permutation_trans. apply perm_skip. apply IH; [exact Hnd'|simpl in Hin; intuition congruence].
      apply perm_swap. }
  set (mid := map (@getData addr) (os_ready_nodes (orvBuckets (assignReadyVector (os_assign staged)))) ++
     map (@getData addr) (zombie_nodes (zombie_queue staged)) ++
     semaphore_waiters pre ++ waiting_semaphore_ic).
  set (last := semaphore_waiters post ++ mutex_waiters (os_mutexes staged) ++ event_waiters (os_events staged)).
  assert (Howners_old : os_sched_owners staged = sched_owned_tasks (os_tasks staged) ++ mid ++ last).
  { unfold os_sched_owners, mid,last. rewrite Hsems. unfold semaphore_waiters.
    rewrite map_app, concat_app. cbn [map concat]. rewrite Hwaiting. now rewrite !app_assoc. }
  assert (Howners_new : os_sched_owners after = remove Z.eq_dec task_pre (sched_owned_tasks (os_tasks staged)) ++ mid ++ task_pre :: last).
  { unfold os_sched_owners. rewrite Haftersems.
    unfold after, replace_sched_owned_tasks, semaphore_enqueue_state, replace_semaphores.
    cbn [os_tasks sched_owned_tasks os_assign zombie_queue os_mutexes os_events].
    unfold mid,last,semaphore_waiters. rewrite map_app, concat_app. cbn [map concat obj' semaphore_pending_addrs].
    repeat rewrite <- app_assoc. cbn [app]. reflexivity. }
  assert (Hownersperm : Permutation (os_sched_owners staged) (os_sched_owners after)).
  { rewrite Howners_old,Howners_new. eapply Permutation_trans.
    - apply Permutation_app_tail. exact Hownperm.
    - change (Permutation (task_pre :: (remove Z.eq_dec task_pre (sched_owned_tasks (os_tasks staged)) ++ mid ++ last))
       (remove Z.eq_dec task_pre (sched_owned_tasks (os_tasks staged)) ++ mid ++ task_pre :: last)).
      rewrite !app_assoc. apply Permutation_middle. }
  assert (Htaskafter : task_world_wf after).
  { destruct Htask as [Hpresent Hinit Hid Hprio Halign Hrun Hclose]. constructor;
      cbn [after replace_sched_owned_tasks semaphore_enqueue_state replace_semaphores os_tasks task_desc_map task_ptr_list sched_owned_tasks task_idmanager_abs].
    - exact Hpresent.
    - intros t d Hlookup Hstatus. apply in_in_remove; [|eapply Hinit; eauto].
      intro Heq; subst t. rewrite PreH10 in Hlookup. inversion Hlookup; subst d.
      destruct Hstatus; congruence.
    - exact Hid.
    - exact Hprio.
    - exact Halign.
    - exact Hrun.
    - exact Hclose. }
  assert (Hservice : forall entry slot,
    service_slot_wf staged entry slot -> service_phase slot <> ServiceRegistered task_pre ->
    service_slot_wf after entry slot).
  { intros entry slot Hwf Hnot. destruct slot as [id phase]. destruct phase; cbn [service_slot_wf service_phase] in *; try exact Hwf.
    destruct Hwf as [d Hd]. exists d. destruct Hd as [Hlookup Hentry Hdelay Howned Hid].
    constructor; cbn [after replace_sched_owned_tasks semaphore_enqueue_state replace_semaphores os_tasks task_desc_map sched_owned_tasks task_idmanager_abs]; try assumption.
    intro Hnr. apply in_in_remove; [intro Heq; subst; contradiction|auto]. }
  assert (Hworldafter : os_world_wf sg_semaphore_ic after).
  { constructor.
    - exact (os_wf_context _ _ Hworld).
    - apply Hservice; [exact (os_wf_recycler _ _ Hworld)|exact (proj1 PreH13)].
    - change (Forall (service_slot_wf after (os_idle_entry sg_semaphore_ic)) (os_idle staged)).
      rewrite Forall_forall in *. intros slot Hin. apply Hservice.
      + pose proof (os_wf_idle _ _ Hworld) as Hw. rewrite Forall_forall in Hw. auto.
      + destruct PreH13 as [_ Hi]. rewrite Forall_forall in Hi. auto.
    - eapply Permutation_NoDup; [exact Hownersperm|exact (os_wf_sched_nodup _ _ Hworld)].
    - intro t. change (In t (os_sched_owners after) <-> task_desc_map (os_tasks staged) t <> None).
      rewrite <- (os_wf_sched_domain _ _ Hworld t). split; intro Hi.
      + eapply Permutation_in; [apply Permutation_sym; exact Hownersperm|exact Hi].
      + eapply Permutation_in; eauto. }
  assert (Hidkeep : forall a, In a (pre ++ obj::post) ->
    exists b, In b (pre ++ obj'::post) /\ semaphore_id b = semaphore_id a).
  { intros a Ha. apply in_app_or in Ha. destruct Ha as [Ha|Ha].
    - exists a; split; [apply in_or_app;auto|reflexivity].
    - destruct Ha as [<-|Ha].
      + exists obj'; split; [apply in_or_app; right; simpl;auto|reflexivity].
      + exists a; split; [apply in_or_app;right;simpl;auto|reflexivity]. }
  assert (Hqueues : forall qs,
    dataqueue_inv (pre++obj::post) qs |-- dataqueue_inv (pre++obj'::post) qs).
  { intros qs. unfold dataqueue_inv. Intros_p Hqs.
    split_pure_spatial; [cancel|]. dump_pre_spatial.
    intros p q Hq. destruct (Hqs p q Hq) as [Hready [[s1 [Hs1 Hi1]] [s2 [Hs2 Hi2]]]].
    split; [exact Hready|]. split.
    - destruct (Hidkeep s1 Hs1) as [s1' [Hs1' Hi1']]. exists s1'; split; [exact Hs1'|congruence].
    - destruct (Hidkeep s2 Hs2) as [s2' [Hs2' Hi2']]. exists s2'; split; [exact Hs2'|congruence]. }
  sep_apply_l_atomic (Hqueues (os_dataqueues staged)).
  assert (Hmap_nonzero : forall T t d, T t = Some d -> addr_aligned t ALIGN_SIZE ->
    store_map store_published_task T |-- “ sched_link_of t <> 0 ”).
  { clear. intros T t d Hlookup Halign.
    pose proof (task_descriptor_field_offset_axiom t Halign) as Hlayout.
    unfold ktask_descriptor_field_offset_ok in Hlayout.
    assert (Hstack : &(t # "TaskDescriptor" ->ₛ "stack_point") = t) by (assert (Htmp : &(t # "TaskDescriptor" ->ₛ "stack_point") = t+0) by tauto; lia).
    assert (Hsl : sched_link_of t = t+16) by (unfold sched_link_of; tauto).
    sep_apply_l_atomic (store_map_split store_published_task t d T Hlookup).
    unfold store_published_task, store_task_descriptor. Intros.
    prop_apply_p (valid_store_ptr (&(t # "TaskDescriptor" ->ₛ "stack_point")) (tdStackPoint d)).
    Intros_p Hv. dump_pre_spatial. rewrite Hstack in Hv.
    unfold valid_object, valid_addr_range in Hv. rewrite Hsl. lia. }
  prop_apply_p (Hmap_nonzero (task_desc_map (os_tasks staged)) task_pre desc PreH10
    (task_wf_aligned _ Htask _ _ PreH10)).
  Intros_p Hslnonzero.
  unfold store_detached_sched_link at 1. Intros actual.
  assert (Hactual : actual=desc) by (rewrite PreH10 in H1; intuition congruence).
  subst actual.
  sep_apply_l_atomic (store_node_self_linked_occupy (sched_link_of task_pre)).
  set (psem := semaphore_addr obj).
  assert (Hhead : list_pre = &(psem # "Semaphore" ->ₛ "pend_list"))
    by (unfold psem; rewrite PreH9, <-Haddr; reflexivity).
  assert (Hstep : linklist_semaphore_enqueue sem_semaphore_ic task_pre 0 staged after).
  { unfold linklist_semaphore_enqueue. exists obj,desc,(map sched_link_node (waiting_semaphore_ic++[task_pre])).
    split; [rewrite Hsems;apply in_or_app;right;simpl;auto|].
    split; [exact Haddr|]. split; [exact PreH10|]. split; [exact PreH11|]. split; [exact PreH12|].
    split; [left;split; [reflexivity|now rewrite Hwaiting]|].
    unfold after. rewrite map_map. cbn [sched_link_node getData]. now rewrite map_id. }
  assert (Hins : dll_insert_before_dispatch list_pre (map sched_link_node waiting_semaphore_ic)
    list_pre (Build_DL_Node task_pre (sched_link_of task_pre)) = map sched_link_node (waiting_semaphore_ic++[task_pre])).
  { unfold dll_insert_before_dispatch. destruct (Z.eq_dec list_pre list_pre); [|contradiction].
    rewrite map_app. reflexivity. }
  assert (Hsemmerge : forall wait hd pre s post h pt x px z,
    hd<>0 -> pt<>0 -> h<>0 -> dll_nodes_nonzero (map semaphore_link_node (pre++s::post)) ->
    x=getPtr (semaphore_link_node s) ->
    &(hd # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> pt **
    &(hd # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> h **
    dllseg (store_semaphore wait) h hd x px (map semaphore_link_node pre) **
    store_semaphore wait x s **
    &(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
    &(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
    dllseg (store_semaphore wait) z x hd pt (map semaphore_link_node post)
    |-- store_dll (store_semaphore wait) hd (map semaphore_link_node (pre++s::post))).
  { clear. intros wait hd pre s post h pt x px z Hhd Hpt Hh Hnz Hx.
    assert (Hnode : semaphore_link_node s=Build_DL_Node s x)
      by (unfold semaphore_link_node in *; cbn in Hx; now rewrite Hx).
    sep_apply_l_atomic (dllseg_head_insert SemaphoreAbs (store_semaphore wait) px x z hd pt s (map semaphore_link_node post)).
    sep_apply_l_atomic (dllseg_concat (store_semaphore wait) h hd x px hd pt
      (map semaphore_link_node pre) (Build_DL_Node s x :: map semaphore_link_node post)).
    unfold store_dll. Exists h pt. split_pure_spatial.
    - rewrite map_app. cbn [map]. rewrite Hnode. sepcon_assoc_change; repeat progress cancel.
    - split_pures; dump_pre_spatial; tauto. }
  destruct H as [Hhd [Hpt [Hh [Hnz Hx]]]].
  assert (Hnewnz : dll_nodes_nonzero (map semaphore_link_node (pre++obj'::post))).
  { unfold dll_nodes_nonzero in Hnz |- *. rewrite map_app in Hnz |- *.
    rewrite Forall_app in Hnz |- *. destruct Hnz as [Hpre Htail]. split; [exact Hpre|].
    cbn [map] in Htail |- *. inversion Htail as [|? ? Hptr Hpost]; subst.
    constructor; [change (getPtr (semaphore_link_node obj) <> 0); exact Hptr|exact Hpost]. }
  assert (Hclosepayload :
    &(psem # "Semaphore" ->ₛ "value") # UShort |-> semaphore_value obj **
    SemaphorePadding psem **
    store_dll (pure_suspend_sched_link (task_desc_map (os_tasks staged))) list_pre
      (map sched_link_node (waiting_semaphore_ic++[task_pre])) |--
    store_semaphore (pure_suspend_sched_link (task_desc_map (os_tasks staged))) x obj').
  { unfold store_semaphore. cbn [obj' semaphore_addr semaphore_value semaphore_pending_addrs].
    fold psem. rewrite <-Hhead. split_pure_spatial.
    - change (map semaphore_wait_node (waiting_semaphore_ic++[task_pre])) with (map sched_link_node (waiting_semaphore_ic++[task_pre])).
      fold psem. cancel.
    - dump_pre_spatial. exact H0. }
  Exists after. split_pure_spatial.
  - fold (sched_link_of task_pre).
    sepcon_assoc_change.
    sep_apply_r_atomic (pure_suspend_sched_link_close (task_desc_map (os_tasks staged))
      (sched_link_of task_pre) task_pre desc PreH10 eq_refl PreH11).
    rewrite Hwaiting. fold psem. rewrite <-Hhead.
    change (map semaphore_wait_node waiting_semaphore_ic) with (map sched_link_node waiting_semaphore_ic).
    sepcon_assoc_change.
    cancel (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks staged))) list_pre (map sched_link_node waiting_semaphore_ic)).
    cancel (occupy_dll_node (sched_link_of task_pre)).
    asrt_simpl_pure.
    apply_sepcon_adjoint.
    sepcon_assoc_change.
    sep_apply_l_atomic Hclosepayload.
    sepcon_assoc_change.
    sep_apply_l_atomic (Hsemmerge (pure_suspend_sched_link (task_desc_map (os_tasks staged)))
      (semaphore_list_head (os_semaphore_stable sg_semaphore_ic)) pre obj' post h pt x px z Hhd Hpt Hh Hnewnz Hx).
    unfold os_inv at 1. rewrite Haftersems.
    unfold task_inv at 1, semaphore_inv at 1, tick_inv,delay_inv,assign_inv,exstatus_inv.
    cbn [after replace_sched_owned_tasks semaphore_enqueue_state replace_semaphores os_tasks task_desc_map task_ptr_list task_idmanager_abs sched_owned_tasks os_tick os_delays os_assign zombie_queue os_recycle os_idle os_isr os_dataqueues os_events os_mutexes os_exstatus].
    rewrite Haftersems,Hsems in Hmanager. rewrite Hmanager.
    Intros. split_pure_spatial.
    + sepcon_assoc_change; repeat progress cancel.
    + split_pures; dump_pre_spatial; try exact Hworldafter; try exact Htaskafter; try exact Hcontext; assumption.
  - split_pures; dump_pre_spatial; try assumption; try reflexivity; try exact Hstep; try exact Hslnonzero; try exact Hins; try (unfold dll_insert_anchor; auto).
Qed.

Lemma proof_of_LinklistSuspend_entail_wit_4_1 : LinklistSuspend_entail_wit_4_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_4_2 : LinklistSuspend_entail_wit_4_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_5 : LinklistSuspend_entail_wit_5.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_6_1 : LinklistSuspend_entail_wit_6_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_6_2 : LinklistSuspend_entail_wit_6_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_7_1 : LinklistSuspend_entail_wit_7_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_7_2 : LinklistSuspend_entail_wit_7_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_7_3 : LinklistSuspend_entail_wit_7_3.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_7_4 : LinklistSuspend_entail_wit_7_4.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_return_wit_1_split_goal_1 : LinklistSuspend_return_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistSuspend_return_wit_1 : LinklistSuspend_return_wit_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_return_wit_2_split_goal_1 : LinklistSuspend_return_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistSuspend_return_wit_2 : LinklistSuspend_return_wit_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_return_wit_3_split_goal_1 : LinklistSuspend_return_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistSuspend_return_wit_3 : LinklistSuspend_return_wit_3.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_return_wit_4_split_goal_1 : LinklistSuspend_return_wit_4_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistSuspend_return_wit_4 : LinklistSuspend_return_wit_4.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_1_split_goal_spatial : LinklistSuspend_which_implies_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistSuspend_which_implies_wit_1 : LinklistSuspend_which_implies_wit_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_2_split_goal_spatial : LinklistSuspend_which_implies_wit_2_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  rewrite PreH1.
  sep_apply_r_atomic (derivable1_wand_elim1 (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks staged))) list_pre (map sched_link_node (waiting_semaphore_ic ++ [task_pre]))) (os_inv sg_semaphore_ic after_fifo)).
  cancel.
Qed.

Lemma proof_of_LinklistSuspend_which_implies_wit_2 : LinklistSuspend_which_implies_wit_2.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_LinklistSuspend_which_implies_wit_2_split_goal_spatial.
Qed.

Lemma proof_of_LinklistSuspend_which_implies_wit_3 : LinklistSuspend_which_implies_wit_3.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_4_split_goal_spatial : LinklistSuspend_which_implies_wit_4_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistSuspend_which_implies_wit_4 : LinklistSuspend_which_implies_wit_4.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_5 : LinklistSuspend_which_implies_wit_5.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_6_split_goal_spatial : LinklistSuspend_which_implies_wit_6_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistSuspend_which_implies_wit_6 : LinklistSuspend_which_implies_wit_6.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_7_split_goal_spatial : LinklistSuspend_which_implies_wit_7_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistSuspend_which_implies_wit_7 : LinklistSuspend_which_implies_wit_7.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic : LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic.
Proof. Admitted.

