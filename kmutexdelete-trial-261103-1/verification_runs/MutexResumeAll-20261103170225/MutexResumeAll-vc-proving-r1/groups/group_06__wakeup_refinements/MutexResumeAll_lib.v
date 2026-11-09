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

Lemma dllseg_conflict__wakeup_refinements : forall A (storeA : addr -> A -> Assertion)
 l x px y py q v,
 In q (map (@getPtr A) l) ->
 (&(q # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> v) **
 DLL.dllseg storeA x px y py l |-- “ False ”.
Proof.
 intros A storeA l. induction l as [|n tail IH]; intros x px y py q v Hin.
 - contradiction.
 - cbn in Hin. cbn [DLL.dllseg]. Intros z. subst x. fold (DLL.dllseg storeA z (getPtr n) y py tail).
   destruct Hin as [Heq|Hin].
   + subst q.
     prop_apply_p (dup_store_ptr
       (&(((getPtr n)) # "SysDoubleLinklistNode" ->ₛ "node_prev")) v px).
     Intros_p Hfalse. contradiction.
   + prop_apply_p (IH z (getPtr n) y py q v Hin).
     Intros_p Hfalse. contradiction.
Qed.
Lemma dllseg_nodup__wakeup_refinements : forall A (storeA : addr -> A -> Assertion)
 l x px y py,
 DLL.dllseg storeA x px y py l |-- “ NoDup (map (@getPtr A) l) ”.
Proof.
 intros A storeA l. induction l as [|n tail IH]; intros x px y py.
 - cbn [DLL.dllseg]. Intros. dump_pre_spatial. constructor.
 - cbn [DLL.dllseg]. Intros z. fold (@DLL.dllseg A storeA). subst x.
   prop_apply_p (IH z (getPtr n) y py).
   Intros_p Hnd.
   destruct (in_dec Z.eq_dec (getPtr n) (map (@getPtr A) tail)) as [Hin|Hnot].
   + prop_apply_p (dllseg_conflict__wakeup_refinements A storeA tail
       z (getPtr n) y py (getPtr n) px Hin).
     Intros_p Hfalse. contradiction.
   + dump_pre_spatial. constructor; assumption.
Qed.
Lemma dll_nodup__wakeup_refinements : forall A (storeA : addr -> A -> Assertion) head l,
 DLL.store_dll storeA head l |-- “ NoDup (map (@getPtr A) l) ”.
Proof.
 intros. unfold DLL.store_dll. Intros h pt.
 prop_apply_p (dllseg_nodup__wakeup_refinements A storeA l h head head pt).
 Intros_p Hnd. dump_pre_spatial. exact Hnd.
Qed.
Lemma dllseg_payload__wakeup_refinements : forall {A} (P:addr -> A -> Assertion) l n x px y py,
 In n l -> DLL.dllseg P x px y py l |-- P (getPtr n) (getData n) ** (P (getPtr n) (getData n) -* DLL.dllseg P x px y py l).
Proof.
 intros A P l. induction l as [|a l IH]; intros n x px y py Hin; [contradiction|].
 simpl in Hin. simpl DLL.dllseg. Intros z. subst x.
 destruct Hin as [Heq|Hin].
 - subst a. cancel (P (getPtr n) (getData n)). apply_sepcon_adjoint.
   Exists z. split_pure_spatial; [sepcon_right_assoc; cancel|dump_pre_spatial; reflexivity].
 - sep_apply_l_atomic (IH n z (getPtr a) y py Hin).
   cancel (P (getPtr n) (getData n)). apply_sepcon_adjoint.
   sep_apply_l_atomic (derivable1_wand_elim1 (P (getPtr n) (getData n)) (DLL.dllseg P z (getPtr a) y py l)).
   Exists z. split_pure_spatial; [sepcon_right_assoc; cancel|dump_pre_spatial; reflexivity].
Qed.
Lemma dll_payload__wakeup_refinements : forall {A} (P:addr -> A -> Assertion) l n head,
 In n l -> DLL.store_dll P head l |-- P (getPtr n) (getData n) ** (P (getPtr n) (getData n) -* DLL.store_dll P head l).
Proof.
 intros A P l n head Hin. unfold DLL.store_dll at 1. Intros h pt.
 sep_apply_l_atomic (dllseg_payload__wakeup_refinements P l n h head head pt Hin).
 cancel (P (getPtr n) (getData n)). apply_sepcon_adjoint.
 sep_apply_l_atomic (derivable1_wand_elim1 (P (getPtr n) (getData n)) (DLL.dllseg P h head head pt l)).
 unfold DLL.store_dll. Exists h pt. split_pure_spatial; [sepcon_right_assoc; cancel|dump_pre_spatial; tauto].
Qed.
Lemma pending_desc__wakeup_refinements : forall sg st sem target rest,
 semaphore_pending_nodes sem st (sched_link_node target :: rest) ->
 os_inv sg st |-- “ exists desc, task_desc_map (os_tasks st) target = Some desc /\ tsmStat (tdSchedMember desc) = TSK_SUSPEND ”.
Proof.
 intros sg st sem target rest [obj [Hin [Haddr Hnodes]]].
 unfold os_inv, semaphore_inv. Intros.
 sep_apply_l_atomic (dll_payload__wakeup_refinements (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map))) (map semaphore_link_node st.(os_semaphores)) (semaphore_link_node obj) sg.(os_semaphore_stable).(semaphore_list_head) (in_map semaphore_link_node _ _ Hin)).
 cbn [semaphore_link_node getPtr getData].
 unfold store_semaphore at 1. Intros.
 change (map semaphore_wait_node (semaphore_pending_addrs obj)) with (map sched_link_node (semaphore_pending_addrs obj)).
 rewrite Hnodes. unfold DLL.store_dll at 1. Intros h pt.
 cbn [DLL.dllseg sched_link_node getPtr getData]. Intros z. subst h.
 unfold pure_suspend_sched_link, pure_published_slink. Intros desc.
 dump_pre_spatial. exists desc. tauto.
Qed.
From Coq Require Import Sorting.Permutation micromega.Lia.
Lemma absent_remove__wakeup_refinements {A} (x:A) l r :
 ~ In x l -> remove_found_prop x l r -> r = l.
Proof. intros H [[_ ->]|[p [s [-> ->]]]]; auto.
 exfalso; apply H; apply in_or_app; right; now left. Qed.
Lemma app_disjoint__wakeup_refinements {A} (l r:list A) x :
 NoDup (l++r) -> In x l -> ~ In x r.
Proof. intros H Hin Hr. apply in_split in Hin as [p [s ->]].
 rewrite <- app_assoc in H. apply NoDup_remove_2 in H.
 apply H. apply in_or_app; right; apply in_or_app; right; exact Hr. Qed.
Lemma map_unique__wakeup_refinements {A B} (f:A->B) l a b :
 NoDup (map f l) -> In a l -> In b l -> f a = f b -> a=b.
Proof. induction l as [|x l IH]; intros H Ha Hb He; [contradiction|].
 inversion H as [|? ? Hnot Hnd]; subst.
 destruct Ha as [<-|Ha], Hb as [<-|Hb]; auto.
 - exfalso; apply Hnot; rewrite He; apply in_map; assumption.
 - exfalso; apply Hnot; rewrite <- He; apply in_map; assumption.
Qed.
Lemma nth_concat__wakeup_refinements {A} (ls:list (list A)) i x :
 In x (nth i ls nil) -> In x (List.concat ls).
Proof. revert i. induction ls as [|l ls IH]; intros [|i] H; simpl in *; try contradiction;
 apply in_or_app; [left; exact H|right; apply IH with i; exact H]. Qed.
Lemma same_id__wakeup_refinements sg st :
 task_world_wf st ->
 IDNode.idbuckets_ok (idmax (task_stable_ids (os_task_stable sg)))
 (hoffset (task_stable_ids (os_task_stable sg)))
 (idlist (task_idmanager_abs (os_tasks st)))
 (idbuckets (task_idmanager_abs (os_tasks st))) ->
 forall id a b da db, task_desc_map (os_tasks st) a = Some da ->
 task_desc_map (os_tasks st) b = Some db -> get_task_with_idnode_success sg st id a ->
 get_task_with_idnode_success sg st id b -> a=b.
Proof.
 intros Htask [_ [_ [[_ Hnd] [_ [_ Hp]]]]] id a b da db Hda Hdb
 [_ [_ [pa [Hpa [Ha _]]]]] [_ [_ [pb [Hpb [Hb _]]]]].
 assert (Hnds : NoDup (map idnode_id (List.concat (idbuckets (task_idmanager_abs (os_tasks st)))))).
 { apply (Permutation_NoDup (Permutation_sym Hp)); exact Hnd. }
 apply nth_concat__wakeup_refinements in Ha.
 apply nth_concat__wakeup_refinements in Hb.
 assert (He : Build_IdNodeAbs id pa = Build_IdNodeAbs id pb).
 { eapply map_unique__wakeup_refinements; eauto. }
 injection He as He. rewrite Hpa,Hpb in He. pose proof (task_descriptor_field_offset_axiom a (task_wf_aligned st Htask a da Hda)) as Hfa.
 pose proof (task_descriptor_field_offset_axiom b (task_wf_aligned st Htask b db Hdb)) as Hfb.
 unfold ktask_descriptor_field_offset_ok in Hfa,Hfb.
 assert (Haoff : &(a # "TaskDescriptor" ->ₛ "id") = a+104) by tauto.
 assert (Hboff : &(b # "TaskDescriptor" ->ₛ "id") = b+104) by tauto.
 rewrite Haoff,Hboff in He. lia.
Qed.
Lemma source_facts__wakeup_refinements sg st :
 os_inv sg st |-- “ (os_world_wf sg st /\
 NoDup (map semaphore_addr (os_semaphores st)) /\
 forall id a b da db, task_desc_map (os_tasks st) a = Some da ->
 task_desc_map (os_tasks st) b = Some db -> get_task_with_idnode_success sg st id a ->
 get_task_with_idnode_success sg st id b -> a=b) ”.
Proof.
 unfold os_inv, task_inv, IDNode.store_idmanager, semaphore_inv. Intros.
 prop_apply_p (dll_nodup__wakeup_refinements SemaphoreAbs
 (store_semaphore (pure_suspend_sched_link (task_desc_map (os_tasks st))))
 (semaphore_list_head (os_semaphore_stable sg))
 (map semaphore_link_node (os_semaphores st))).
 Intros_p Hsem. dump_pre_spatial. split; [assumption|]. split.
 - assert (Heq : map (@getPtr SemaphoreAbs) (map semaphore_link_node (os_semaphores st)) =
   map (fun p => &(p # "Semaphore" ->ₛ "link")) (map semaphore_addr (os_semaphores st)))
   by (rewrite !map_map; reflexivity).
   rewrite Heq in Hsem. now apply NoDup_map_inv in Hsem.
 - apply same_id__wakeup_refinements; assumption.
Qed.
Lemma os_pure__wakeup_refinements sg st : os_inv sg st |-- “ os_world_wf sg st ”.
Proof. unfold os_inv. Intros. dump_pre_spatial. assumption. Qed.
Lemma sem_absent__wakeup_refinements task b a :
 ~ In task (semaphore_waiters b) -> semaphore_remove_waiter_step task b a -> a=b.
Proof.
 intros H Hstep. induction Hstep as [|x y xs ys Hxy Hxs IH]; [reflexivity|].
 unfold semaphore_waiters in H; simpl in H; rewrite in_app_iff in H.
 destruct Hxy as [Ha [Hi [Hv Hp]]].
 assert (Hpend : semaphore_pending_addrs y = semaphore_pending_addrs x)
 by (eapply (absent_remove__wakeup_refinements task); [tauto|exact Hp]).
 assert (Hy:y=x) by (destruct x,y; simpl in *; subst; reflexivity).
 subst y. f_equal. apply IH. exact (fun Hin => H (or_intror Hin)).
Qed.
Lemma mutex_absent__wakeup_refinements task b a :
 ~ In task (mutex_waiters b) -> mutex_remove_waiter_step task b a -> a=b.
Proof.
 intros H Hstep. induction Hstep as [|x y xs ys Hxy Hxs IH]; [reflexivity|].
 unfold mutex_waiters in H; simpl in H; rewrite in_app_iff in H.
 destruct Hxy as [Ha [Hi [Hv [Hrc [Hop [Hh Hp]]]]]].
 assert (Hpend : mutex_pending_addrs y = mutex_pending_addrs x)
 by (eapply (absent_remove__wakeup_refinements task); [tauto|exact Hp]).
 assert (Hy:y=x) by (destruct x,y; simpl in *; subst; reflexivity).
 subst y. f_equal. apply IH. exact (fun Hin => H (or_intror Hin)).
Qed.
Lemma event_absent__wakeup_refinements task b a :
 ~ In task (event_waiters b) -> event_remove_waiter_step task b a -> a=b.
Proof.
 intros H Hstep. induction Hstep as [|x y xs ys Hxy Hxs IH]; [reflexivity|].
 unfold event_waiters in H; simpl in H; rewrite in_app_iff in H.
 destruct Hxy as [Ha [Hi [Ho [He Hp]]]].
 assert (Hpend : event_pending_addrs y = event_pending_addrs x)
 by (eapply (absent_remove__wakeup_refinements task); [tauto|exact Hp]).
 assert (Hy:y=x) by (destruct x,y; simpl in *; subst; reflexivity).
 subst y. f_equal. apply IH. exact (fun Hin => H (or_intror Hin)).
Qed.
Lemma general_wakeup_detached_refinement__wakeup_refinements sg before after task desc :
 os_world_wf sg before -> tdDelay desc = 0 ->
 In task (sched_owned_tasks (os_tasks before)) ->
 ktask_wakeup_step task desc before after ->
 ktask_wakeup_detached_null_step task desc before after.
Proof.
 intros Hwf Hd Hin Hstep.
 pose proof (sched_owned_not_waiting sg before task Hwf Hin) as Habs.
 repeat rewrite in_app_iff in Habs.
 destruct Hstep. constructor; try assumption.
 - destruct wakeup_owned as [[Hbad _]|Hsplit]; [contradiction|exact Hsplit].
 - destruct wakeup_delays as [d [Hstep Heq]]. rewrite Hd in Hstep.
   destruct Hstep as [[_ ->]|[[Hbad _]|[Hbad _]]]; congruence.
 - eapply (event_absent__wakeup_refinements task); [tauto|eassumption].
 - eapply (mutex_absent__wakeup_refinements task); [tauto|eassumption].
 - eapply (sem_absent__wakeup_refinements task); [tauto|eassumption].
Qed.
Lemma sem_member__wakeup_refinements task obj sems :
 In obj sems -> In task (semaphore_pending_addrs obj) -> In task (semaphore_waiters sems).
Proof. intros Hobj Htask. unfold semaphore_waiters. apply in_concat.
 exists (semaphore_pending_addrs obj). split; [apply in_map; exact Hobj|exact Htask]. Qed.
Lemma sem_set_absent__wakeup_refinements p rest sems :
 ~ In p (map semaphore_addr sems) -> semaphore_set_pending p rest sems = sems.
Proof. induction sems as [|s ss IH]; intros H; [reflexivity|].
 unfold semaphore_set_pending in *. simpl in *. destruct (Z.eq_dec (semaphore_addr s) p); [exfalso; tauto|].
 f_equal. apply IH. tauto. Qed.
Lemma sem_remove_exact__wakeup_refinements task before after old rest :
 NoDup (map semaphore_addr before) -> NoDup (semaphore_waiters before) ->
 In old before -> semaphore_pending_addrs old = task::rest ->
 semaphore_remove_waiter_step task before after ->
 after = semaphore_set_pending (semaphore_addr old) rest before.
Proof.
 intros Haddr Hwait Hin Hpending Hstep.
 revert old rest Haddr Hwait Hin Hpending.
 induction Hstep as [|x y xs ys Hxy Hxs IH]; intros old rest Haddr Hwait Hin Hpending; [contradiction|].
 inversion Haddr as [|? ? Hnot Hnd]; subst.
 change (NoDup (semaphore_pending_addrs x ++ semaphore_waiters xs)) in Hwait.
 destruct Hxy as [Ha [Hi [Hv Hp]]].
 destruct Hin as [<-|Hin].
 - assert (Hys : ys=xs).
   { eapply (sem_absent__wakeup_refinements task); [|exact Hxs].
     eapply app_disjoint__wakeup_refinements; [exact Hwait|]. rewrite Hpending. now left. }
   assert (Hpy : semaphore_pending_addrs y = rest).
   { eapply remove_found_deterministic; [eapply NoDup_app_remove_r; exact Hwait|exact Hp|].
     rewrite Hpending. apply (remove_found_at_split task nil rest). }
   unfold semaphore_set_pending. simpl. destruct (Z.eq_dec (semaphore_addr x) (semaphore_addr x)); [|contradiction].
   fold (semaphore_set_pending (semaphore_addr x) rest xs).
   rewrite sem_set_absent__wakeup_refinements by exact Hnot.
   subst ys. f_equal. destruct x,y; simpl in *; subst; reflexivity.
 - assert (Htask : In task (semaphore_waiters xs)).
   { eapply sem_member__wakeup_refinements; [exact Hin|]. rewrite Hpending. now left. }
   assert (Habs : ~ In task (semaphore_pending_addrs x)).
   { intro Hbad. eapply app_disjoint__wakeup_refinements; eauto. }
   assert (Hpy : semaphore_pending_addrs y = semaphore_pending_addrs x)
     by (eapply (absent_remove__wakeup_refinements task); eauto).
   assert (Heq : y=x) by (destruct x,y; simpl in *; subst; reflexivity). subst y.
   unfold semaphore_set_pending. simpl.
   destruct (Z.eq_dec (semaphore_addr x) (semaphore_addr old)) as [Heq|Hneq].
   + exfalso; apply Hnot. rewrite Heq. apply in_map; exact Hin.
   + f_equal. apply IH; auto. eapply NoDup_app_remove_l; exact Hwait.
Qed.
Lemma general_wakeup_semaphore_refinement__wakeup_refinements sg before after sem task desc nodes :
 os_world_wf sg before -> NoDup (map semaphore_addr (os_semaphores before)) ->
 semaphore_pending_nodes sem before (sched_link_node task :: nodes) ->
 ktask_wakeup_step task desc before after ->
 wakeup_semaphore_head sem task desc before after /\ semaphore_pending_nodes sem after nodes.
Proof.
 intros Hwf Haddr [old [Hin [Hsem Hnodes]]] Hstep.
 destruct (semaphore_pending_addrs old) as [|t rest] eqn:Hpending; [discriminate|].
 cbn in Hnodes. injection Hnodes as Ht Hrest.
 subst t.
 assert (Htask : In task (semaphore_waiters (os_semaphores before))).
 { eapply sem_member__wakeup_refinements; [exact Hin|]. rewrite Hpending. now left. }
 pose proof (os_wf_sched_nodup sg before Hwf) as Hnd.
 unfold os_sched_owners in Hnd.
 assert (Howned : ~ In task (sched_owned_tasks (os_tasks before))).
 { intro Hbad. eapply app_disjoint__wakeup_refinements; [exact Hnd|exact Hbad|].
   repeat rewrite in_app_iff. tauto. }
 apply NoDup_app_remove_l in Hnd. apply NoDup_app_remove_l in Hnd.
 apply NoDup_app_remove_l in Hnd.
 assert (Hother : ~ In task (mutex_waiters (os_mutexes before) ++ event_waiters (os_events before))).
 { eapply app_disjoint__wakeup_refinements; eauto. }
 assert (Hsemnd : NoDup (semaphore_waiters (os_semaphores before)))
 by (eapply NoDup_app_remove_r; exact Hnd).
 destruct Hstep.
 assert (Hafter : os_semaphores after = semaphore_set_pending sem rest (os_semaphores before)).
 { rewrite <- Hsem. eapply sem_remove_exact__wakeup_refinements; eauto. }
 split.
 - split.
   + constructor; try assumption.
     * eapply (absent_remove__wakeup_refinements task); eauto.
     * eapply (event_absent__wakeup_refinements task); [rewrite in_app_iff in Hother; tauto|eassumption].
     * eapply (mutex_absent__wakeup_refinements task); [rewrite in_app_iff in Hother; tauto|eassumption].
   + exists old, rest. auto.
 - unfold semaphore_pending_nodes. rewrite Hafter. unfold semaphore_set_pending.
   exists {|semaphore_addr := semaphore_addr old; semaphore_id := semaphore_id old;
     semaphore_value := semaphore_value old; semaphore_pending_addrs := rest|}.
   split.
   + apply in_map_iff. exists old. split; [|exact Hin].
     destruct (Z.eq_dec (semaphore_addr old) sem); [reflexivity|contradiction].
   + simpl. auto.
Qed.
