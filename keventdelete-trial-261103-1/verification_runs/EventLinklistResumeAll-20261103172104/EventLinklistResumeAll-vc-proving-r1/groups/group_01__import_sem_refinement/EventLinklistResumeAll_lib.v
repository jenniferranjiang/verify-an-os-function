From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.
Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.KEventDelete.
Import ListNotations DLL IDNode MonadErr.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

(** 循环借出等待哨兵next单元后，归还同值即可恢复同一个os_inv。
    此wand是空间资源，不是额外可信事实；拆出义务由which implies生成。 *)
Definition event_resume_next_restore (sg : StableGlobalState) (st : VarGlobalState)
    (head next : addr) : Assertion :=
  (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next) -* os_inv sg st.

(** 写入exstatus后的归还视图，st已经是只更新该描述符exstatus的新状态。 *)
Definition event_resume_exstatus_restore (sg : StableGlobalState) (st : VarGlobalState)
    (task value : Z) : Assertion :=
  (&(task # "TaskDescriptor" ->ₛ "exstatus") # Int |-> value) -* os_inv sg st.

(** task ID只读；归还同值恢复当前os_inv以满足通用KTaskWakeup合同。 *)
Definition event_resume_id_restore (sg : StableGlobalState) (st : VarGlobalState)
    (task id : Z) : Assertion :=
  (&(task # "TaskDescriptor" ->ₛ "id" .ₛ "id") # UShort |-> id) -* os_inv sg st.

(** 已处理前缀的数学进度：完成当前剩余队列的整体效果，足以完成原waiting
    的整体效果。不重定义逐步唤醒或公共批量语义，不包含堆所有权。 *)
Definition event_resume_remaining_effect (p : addr) (waiting : list addr)
    (before : VarGlobalState) (remaining : list addr) (current : VarGlobalState) : Prop :=
  forall after,
    event_resume_all_effect p remaining current after ->
    event_resume_all_effect p waiting before after.
Require Import Coq.micromega.Lia.
Lemma dllseg_pure__import_sem_refinement {A} (P : addr -> A -> Assertion) (Q : A -> Prop) :
 (forall p a, P p a |-- “ Q a ”) ->
 forall nodes x px y py, dllseg P x px y py nodes |-- “ Forall (fun n => Q (getData n)) nodes ”.
Proof.
 intros H. induction nodes as [|n ns IH]; intros.
 - simpl. Intros. dump_pre_spatial. constructor.
 - cbn [dllseg]. Intros z. prop_apply_p (H x (getData n)). Intros_p Hn.
   prop_apply_p (IH z x y py). Intros_p Hns.
   dump_pre_spatial. constructor; assumption.
Qed.

Lemma dllseg_absent__import_sem_refinement {A} (P : addr -> A -> Assertion) :
 forall ns x px y py p v,
 dllseg P x px y py ns ** &(p # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> v
 |-- “ ~ In p (map (@getPtr A) ns) ”.
Proof.
 induction ns as [|n ns IH]; intros.
 - simpl. dump_pre_spatial. tauto.
 - cbn [dllseg]. Intros z. subst x. fold (dllseg P z (getPtr n) y py ns).
   destruct (Z.eq_dec p (getPtr n)) as [->|Hneq].
   + match goal with |- context [store_ptr ?a px] => prop_apply_p (dup_store_ptr a px v) end.
     Intros_p Hfalse. dump_pre_spatial. contradiction.
   + prop_apply_p (IH z (getPtr n) y py p v). Intros_p Hnot.
     dump_pre_spatial. simpl. intuition congruence.
Qed.
Lemma dllseg_nodup__import_sem_refinement {A} (P : addr -> A -> Assertion) :
 forall ns x px y py, dllseg P x px y py ns |-- “ NoDup (map (@getPtr A) ns) ”.
Proof.
 induction ns as [|n ns IH]; intros.
 - simpl. dump_pre_spatial. constructor.
 - cbn [dllseg]. Intros z. subst x. fold (dllseg P z (getPtr n) y py ns).
   prop_apply_p (dllseg_absent__import_sem_refinement P ns z (getPtr n) y py (getPtr n) px).
   Intros_p Hnot. prop_apply_p (IH z (getPtr n) y py). Intros_p Hnd.
   dump_pre_spatial. constructor; assumption.
Qed.
Lemma dll_pure__import_sem_refinement {A} (P : addr -> A -> Assertion) (Q : A -> Prop) :
 (forall p a, P p a |-- “ Q a ”) ->
 forall ns head, store_dll P head ns |-- “ Forall (fun n => Q (getData n)) ns ”.
Proof.
 intros H ns head. unfold store_dll. Intros h pt.
 prop_apply_p (dllseg_pure__import_sem_refinement P Q H ns h head head pt).
 Intros_p Hf. dump_pre_spatial. exact Hf.
Qed.
Lemma dll_nodup__import_sem_refinement {A} (P : addr -> A -> Assertion) :
 forall ns head, store_dll P head ns |-- “ NoDup (map (@getPtr A) ns) ”.
Proof.
 intros ns head. unfold store_dll. Intros h pt.
 prop_apply_p (dllseg_nodup__import_sem_refinement P ns h head head pt).
 Intros_p Hf. dump_pre_spatial. exact Hf.
Qed.

Lemma suspend_pure__import_sem_refinement T p task :
 pure_suspend_sched_link T p task |-- “ exists d, T task = Some d /\ (tdSchedMember d).(tsmStat) = TSK_SUSPEND ”.
Proof. unfold pure_suspend_sched_link, pure_published_slink. Intros d. dump_pre_spatial. exists d. tauto. Qed.
Lemma semaphore_pure__import_sem_refinement T p s :
 store_semaphore (pure_suspend_sched_link T) p s |--
 “ Forall (fun t => exists d, T t = Some d /\ (tdSchedMember d).(tsmStat) = TSK_SUSPEND) s.(semaphore_pending_addrs) ”.
Proof.
 unfold store_semaphore. Intros.
 prop_apply_p (dll_pure__import_sem_refinement (pure_suspend_sched_link T)
 (fun t => exists d, T t = Some d /\ (tdSchedMember d).(tsmStat) = TSK_SUSPEND)
 (suspend_pure__import_sem_refinement T) (map semaphore_wait_node s.(semaphore_pending_addrs))
 (&(((s.(semaphore_addr))) # "Semaphore" ->ₛ "pend_list"))).
 Intros_p Hf. dump_pre_spatial. rewrite Forall_map in Hf. exact Hf.
Qed.
Lemma semaphore_inv_pure__import_sem_refinement T sg ss :
 semaphore_inv (pure_suspend_sched_link T) sg ss |--
 “ NoDup (map semaphore_addr ss) /\
   Forall (fun s => Forall (fun t => exists d, T t = Some d /\ (tdSchedMember d).(tsmStat) = TSK_SUSPEND) s.(semaphore_pending_addrs)) ss ”.
Proof.
 unfold semaphore_inv. Intros.
 prop_apply_p (dll_nodup__import_sem_refinement (store_semaphore (pure_suspend_sched_link T)) (map semaphore_link_node ss) sg.(semaphore_list_head)). Intros_p Hnd.
 prop_apply_p (dll_pure__import_sem_refinement (store_semaphore (pure_suspend_sched_link T))
 (fun s => Forall (fun t => exists d, T t = Some d /\ (tdSchedMember d).(tsmStat) = TSK_SUSPEND) s.(semaphore_pending_addrs))
 (semaphore_pure__import_sem_refinement T) (map semaphore_link_node ss) sg.(semaphore_list_head)).
 Intros_p Hf. dump_pre_spatial. split.
 - rewrite map_map in Hnd.
   apply (@NoDup_map_inv _ _ (fun p => &(p # "Semaphore" ->ₛ "link"))).
   rewrite map_map. exact Hnd.
 - rewrite Forall_map in Hf. exact Hf.
Qed.
Lemma os_pure__import_sem_refinement sg st :
 os_inv sg st |-- “ os_world_wf sg st /\ task_world_wf st /\
 idbuckets_ok (idmax (task_stable_ids (os_task_stable sg))) (hoffset (task_stable_ids (os_task_stable sg))) (idlist (task_idmanager_abs (os_tasks st))) (idbuckets (task_idmanager_abs (os_tasks st))) /\
 NoDup (map semaphore_addr st.(os_semaphores)) /\
 Forall (fun s => Forall (fun t => exists d, st.(os_tasks).(task_desc_map) t = Some d /\ (tdSchedMember d).(tsmStat) = TSK_SUSPEND) s.(semaphore_pending_addrs)) st.(os_semaphores) ”.
Proof.
 unfold os_inv. Intros.
 prop_apply_p (semaphore_inv_pure__import_sem_refinement st.(os_tasks).(task_desc_map) sg.(os_semaphore_stable) st.(os_semaphores)). Intros_p Hsem.
 unfold task_inv, store_idmanager. Intros.
 dump_pre_spatial. intuition.
Qed.

Lemma map_nodup_eq__import_sem_refinement {A B} (f : A -> B) xs x y :
 NoDup (map f xs) -> In x xs -> In y xs -> f x = f y -> x = y.
Proof.
 induction xs as [|a xs IH]; simpl; intros Hnd Hx Hy Heq; [contradiction|].
 inversion Hnd as [|? ? Hnot Htail]; subst.
 destruct Hx as [<-|Hx]; destruct Hy as [<-|Hy]; auto.
 - exfalso. apply Hnot. rewrite Heq. apply in_map. exact Hy.
 - exfalso. apply Hnot. rewrite <- Heq. apply in_map. exact Hx.
Qed.
Lemma app_disjoint__import_sem_refinement {A} (xs ys : list A) x :
 NoDup (xs ++ ys) -> In x xs -> ~ In x ys.
Proof.
 induction xs as [|a xs IH]; simpl; intros Hnd Hin Hy; [contradiction|].
 inversion Hnd as [|? ? Hnot Htail]; subst.
 destruct Hin as [<-|Hin].
 - apply Hnot. apply in_or_app; auto.
 - eapply IH; eauto.
Qed.
Lemma concat_in__import_sem_refinement {A B} (f : A -> list B) xs x t :
 In x xs -> In t (f x) -> In t (List.concat (map f xs)).
Proof. intros Hx Ht. apply in_concat. exists (f x). split; auto. now apply in_map. Qed.
Lemma concat_nodup__import_sem_refinement {A B} (f : A -> list B) xs x :
 NoDup (List.concat (map f xs)) -> In x xs -> NoDup (f x).
Proof.
 induction xs as [|a xs IH]; simpl; intros Hnd Hin; [contradiction|].
 destruct Hin as [<-|Hin].
 - eapply NoDup_app_remove_r; eauto.
 - apply IH; auto. eapply NoDup_app_remove_l; eauto.
Qed.
Lemma concat_disjoint__import_sem_refinement {A B} (f : A -> list B) xs x y t :
 NoDup (List.concat (map f xs)) -> In x xs -> In y xs -> x <> y ->
 In t (f x) -> ~ In t (f y).
Proof.
 induction xs as [|a xs IH]; simpl; intros Hnd Hx Hy Hneq Htx Hty; [contradiction|].
 destruct Hx as [<-|Hx]; destruct Hy as [<-|Hy]; [congruence| | |].
 - eapply app_disjoint__import_sem_refinement; [exact Hnd|exact Htx|].
   eapply concat_in__import_sem_refinement; eauto.
 - eapply app_disjoint__import_sem_refinement; [exact Hnd|exact Hty|].
   eapply concat_in__import_sem_refinement; eauto.
 - eapply IH; eauto. eapply NoDup_app_remove_l; eauto.
Qed.
Lemma remove_absent_eq__import_sem_refinement {A} (a : A) xs ys :
 ~ In a xs -> remove_found_prop a xs ys -> ys = xs.
Proof.
 intros Hnot [[_ ->]|[p [q [-> ->]]]]; auto.
 exfalso. apply Hnot. apply in_or_app; right; simpl; auto.
Qed.
Lemma id_unique__import_sem_refinement sg st id t u d e :
 task_world_wf st ->
 idbuckets_ok (idmax (task_stable_ids (os_task_stable sg))) (hoffset (task_stable_ids (os_task_stable sg))) (idlist (task_idmanager_abs (os_tasks st))) (idbuckets (task_idmanager_abs (os_tasks st))) ->
 get_task_with_idnode_success sg st id t ->
 get_task_with_idnode_success sg st id u ->
 st.(os_tasks).(task_desc_map) t = Some d ->
 st.(os_tasks).(task_desc_map) u = Some e -> t = u.
Proof.
 intros Hwf Hb Ht Hu Htd Hue.
 destruct Ht as [Hid [_ [p [-> [Hp _]]]]].
 destruct Hu as [_ [_ [q [-> [Hq _]]]]].
 destruct Hb as [Hoff [Hlen [_ [Hall _]]]].
 assert (Hrange : 0 <= idmanager_bucket_index (task_stable_ids (os_task_stable sg)) id < Zlength (idbuckets (task_idmanager_abs (os_tasks st)))).
 { unfold idmanager_bucket_index. rewrite Hlen. apply Z.mod_pos_bound. exact Hoff. }
 pose proof (Forall_Znth_Zlength _ _ [] _ Hall Hrange) as Hbucket.
 destruct Hbucket as [[_ Hnd] _].
 assert (Heq : Build_IdNodeAbs id (&(t # "TaskDescriptor" ->ₛ "id")) = Build_IdNodeAbs id (&(u # "TaskDescriptor" ->ₛ "id"))).
 { eapply map_nodup_eq__import_sem_refinement; eauto. }
 injection Heq as Hptr.
 pose proof (task_descriptor_field_offset_axiom t (task_wf_aligned st Hwf t d Htd)) as Htl.
 pose proof (task_descriptor_field_offset_axiom u (task_wf_aligned st Hwf u e Hue)) as Hul.
 unfold ktask_descriptor_field_offset_ok in Htl, Hul.
 do 25 destruct Htl as [_ Htl]. destruct Htl as [Htl _].
 do 25 destruct Hul as [_ Hul]. destruct Hul as [Hul _].
 clear -Hptr Htl Hul. lia.
Qed.

Lemma events_absent__import_sem_refinement task before after :
 ~ In task (event_waiters before) -> event_remove_waiter_step task before after -> after = before.
Proof.
 intros Habs Hstep. induction Hstep as [|x y xs ys Hr Hs IH]; auto.
 simpl in Habs. unfold event_waiters in Habs. cbn [map List.concat] in Habs.
 destruct Hr as [Ha [Hi [Ho [He Hr]]]].
 assert (Hpend : event_pending_addrs y = event_pending_addrs x).
 { eapply remove_absent_eq__import_sem_refinement; eauto. intro Hin. apply Habs. apply in_or_app; auto. }
 assert (Htail : ys = xs).
 { apply IH. intro Hin. apply Habs. apply in_or_app; auto. }
 subst ys. f_equal. destruct x, y; simpl in *; congruence.
Qed.
Lemma mutexes_absent__import_sem_refinement task before after :
 ~ In task (mutex_waiters before) -> mutex_remove_waiter_step task before after -> after = before.
Proof.
 intros Habs Hstep. induction Hstep as [|x y xs ys Hr Hs IH]; auto.
 unfold mutex_waiters in Habs. cbn [map List.concat] in Habs.
 destruct Hr as [Ha [Hi [Hv [Hr [Hp [Hh Hrm]]]]]].
 assert (Hpend : mutex_pending_addrs y = mutex_pending_addrs x).
 { eapply remove_absent_eq__import_sem_refinement; eauto. intro Hin. apply Habs. apply in_or_app; auto. }
 assert (Htail : ys = xs).
 { apply IH. intro Hin. apply Habs. apply in_or_app; auto. }
 subst ys. f_equal. destruct x, y; simpl in *; congruence.
Qed.
Lemma sem_remove_head__import_sem_refinement task source rest before after :
 NoDup (map semaphore_addr before) ->
 NoDup (semaphore_waiters before) ->
 In source before -> source.(semaphore_pending_addrs) = task :: rest ->
 semaphore_remove_waiter_step task before after ->
 after = semaphore_set_pending source.(semaphore_addr) rest before.
Proof.
 intros Haddr Hnd Hin Hhead Hstep.
 assert (Hrel : forall old new, In old before ->
   new.(semaphore_addr) = old.(semaphore_addr) /\
   new.(semaphore_id) = old.(semaphore_id) /\
   new.(semaphore_value) = old.(semaphore_value) /\
   remove_found_prop task old.(semaphore_pending_addrs) new.(semaphore_pending_addrs) ->
   new = (if Z.eq_dec old.(semaphore_addr) source.(semaphore_addr) then
    {| semaphore_addr := old.(semaphore_addr); semaphore_id := old.(semaphore_id);
       semaphore_value := old.(semaphore_value); semaphore_pending_addrs := rest |} else old)).
 { intros old new Hold [Ha [Hi [Hv Hr]]].
   destruct (Z.eq_dec old.(semaphore_addr) source.(semaphore_addr)) as [Heq|Hneq].
   - assert (old = source) as -> by (eapply map_nodup_eq__import_sem_refinement; eauto).
     assert (Hp : new.(semaphore_pending_addrs) = rest).
     { eapply remove_found_deterministic; [|exact Hr|].
       - eapply concat_nodup__import_sem_refinement; eauto.
       - rewrite Hhead. apply (remove_found_at_split task [] rest). }
     destruct source, new; simpl in *; congruence.
   - assert (Hp : new.(semaphore_pending_addrs) = old.(semaphore_pending_addrs)).
     { eapply remove_absent_eq__import_sem_refinement; [|exact Hr].
       eapply concat_disjoint__import_sem_refinement; [exact Hnd|exact Hin|exact Hold| |].
       - intro He; subst; contradiction.
       - rewrite Hhead; simpl; auto. }
     destruct old, new; simpl in *; congruence. }
 unfold semaphore_set_pending. clear Haddr Hnd Hin Hhead.
 induction Hstep as [|x y xs ys Hr Hs IH]; simpl; auto.
 f_equal.
 - apply Hrel; auto. simpl; auto.
 - apply IH. intros old new Hold. apply Hrel. simpl; auto.
Qed.

Lemma sem_head_pure__import_sem_refinement sg before after sem task rest desc :
 os_world_wf sg before ->
 NoDup (map semaphore_addr before.(os_semaphores)) ->
 semaphore_pending_nodes sem before (sched_link_node task :: rest) ->
 ktask_wakeup_step task desc before after ->
 wakeup_semaphore_head sem task desc before after /\
 semaphore_pending_nodes sem after rest.
Proof.
 intros Hworld Haddr [source [Hin [Hsem Hnodes]]] Hstep.
 destruct (semaphore_pending_addrs source) as [|t tail] eqn:Hhead; [discriminate|].
 cbn [map] in Hnodes. injection Hnodes as Hnode Hrest.
 subst t.
 assert (Hwait : In task (semaphore_waiters before.(os_semaphores))).
 { unfold semaphore_waiters. eapply concat_in__import_sem_refinement; eauto. rewrite Hhead. simpl; auto. }
 pose proof (os_wf_sched_nodup sg before Hworld) as Hnd.
 unfold os_sched_owners in Hnd.
 apply NoDup_app_remove_l in Hnd. apply NoDup_app_remove_l in Hnd.
 apply NoDup_app_remove_l in Hnd.
 assert (Hsemnd : NoDup (semaphore_waiters before.(os_semaphores))).
 { eapply NoDup_app_remove_r; eauto. }
 assert (Hother : ~ In task (mutex_waiters before.(os_mutexes) ++ event_waiters before.(os_events))).
 { eapply app_disjoint__import_sem_refinement; eauto. }
 assert (Howned : ~ In task before.(os_tasks).(sched_owned_tasks)).
 { intro Ho. eapply sched_owned_not_waiting; eauto. apply in_or_app; auto. }
 assert (Hsems : after.(os_semaphores) = semaphore_set_pending sem tail before.(os_semaphores)).
 { rewrite <- Hsem. eapply sem_remove_head__import_sem_refinement; eauto. exact (wakeup_semaphores _ _ _ _ Hstep). }
 split.
 - split.
   + constructor.
     * exact (wakeup_ready _ _ _ _ Hstep).
     * exact (wakeup_task_map _ _ _ _ Hstep).
     * eapply remove_absent_eq__import_sem_refinement; eauto. exact (wakeup_owned _ _ _ _ Hstep).
     * exact (wakeup_task_ids _ _ _ _ Hstep).
     * exact (wakeup_task_ptrs _ _ _ _ Hstep).
     * exact (wakeup_running _ _ _ _ Hstep).
     * exact (wakeup_priority _ _ _ _ Hstep).
     * exact (wakeup_delays _ _ _ _ Hstep).
     * apply (events_absent__import_sem_refinement task).
       -- intro He. apply Hother. apply in_or_app; auto.
       -- exact (wakeup_events _ _ _ _ Hstep).
     * apply (mutexes_absent__import_sem_refinement task).
       -- intro He. apply Hother. apply in_or_app; auto.
       -- exact (wakeup_mutexes _ _ _ _ Hstep).
     * exact (wakeup_tick _ _ _ _ Hstep).
     * exact (wakeup_zombie _ _ _ _ Hstep).
     * exact (wakeup_recycle _ _ _ _ Hstep).
     * exact (wakeup_idle _ _ _ _ Hstep).
     * exact (wakeup_isr _ _ _ _ Hstep).
     * exact (wakeup_exstatus _ _ _ _ Hstep).
   + exists source, tail. auto.
 - exists {| semaphore_addr := source.(semaphore_addr); semaphore_id := source.(semaphore_id); semaphore_value := source.(semaphore_value); semaphore_pending_addrs := tail |}.
   split.
   + rewrite Hsems. unfold semaphore_set_pending.
     apply in_map_iff. exists source. split; auto.
     destruct (Z.eq_dec (semaphore_addr source) sem); [reflexivity|contradiction].
   + simpl. auto.
Qed.
Lemma generic_wakeup_sem_head__import_sem_refinement sg before sem task rest id :
 get_task_with_idnode_success sg before id task ->
 semaphore_pending_nodes sem before (sched_link_node task :: rest) ->
 os_inv sg before |--
 “ exists desc,
 before.(os_tasks).(task_desc_map) task = Some desc /\
 (tdSchedMember desc).(tsmStat) = TSK_SUSPEND /\
 forall other otherdesc after,
 get_task_with_idnode_success sg before id other ->
 before.(os_tasks).(task_desc_map) other = Some otherdesc ->
 other = task /\ otherdesc = desc /\
 (ktask_wakeup_step other otherdesc before after ->
 wakeup_semaphore_head sem task desc before after /\ semaphore_pending_nodes sem after rest) ”.
Proof.
 intros Hid Hpending. prop_apply_p (os_pure__import_sem_refinement sg before). Intros_p Hpure.
 dump_pre_spatial.
 destruct Hpure as [Hworld [Htask [Hb [Haddr Hall]]]].
 destruct Hpending as [source [Hin [Hsem Hnodes]]].
 assert (Ht : In task source.(semaphore_pending_addrs)).
 { assert (Hn : In (sched_link_node task) (map sched_link_node source.(semaphore_pending_addrs))) by (rewrite Hnodes; simpl; auto).
   apply in_map_iff in Hn as [t [Heq Ht]]. assert (t = task) by (injection Heq; auto). subst. exact Ht. }
 apply Forall_forall with (x := source) in Hall; auto.
 apply Forall_forall with (x := task) in Hall; auto.
 destruct Hall as [desc [Hdesc Hstatus]]. exists desc. split; [exact Hdesc|]. split; [exact Hstatus|].
 intros other otherdesc after Hother Hdother.
 assert (other = task) as -> by (eapply id_unique__import_sem_refinement; eauto).
 assert (otherdesc = desc) as -> by congruence.
 split; [reflexivity|]. split; [reflexivity|]. intro Hstep.
 eapply sem_head_pure__import_sem_refinement; eauto.
 exists source. auto.
Qed.
