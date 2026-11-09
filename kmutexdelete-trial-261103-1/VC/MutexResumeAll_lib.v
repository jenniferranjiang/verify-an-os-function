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


From Coq Require Import Logic.FunctionalExtensionality Logic.Classical Sorting.Permutation micromega.Lia.
From Coq Require Import Lia Sorting.Permutation.
From Coq Require Import Logic.FunctionalExtensionality Logic.PropExtensionality.

(** 仅改变task.exstatus的资源更新；按当前共享状态重检历史通用字段桥。 *)
Require Import Coq.micromega.Lia Coq.Sorting.Permutation.
From Coq Require Import Sorting.Permutation micromega.Lia.
Lemma step_task_map__bulk_initialization : forall p task tail before after,
 mutex_resume_one p task tail before after ->
 exists desc,
 task_desc_map (os_tasks before) task = Some desc /\
 tsmStat (tdSchedMember desc) = TSK_SUSPEND /\
 task_desc_map (os_tasks after) =
 update_task_desc_map task
   (set_task_desc_ready (set_task_desc_exstatus desc (-1)))
   (task_desc_map (os_tasks before)).
Proof.
 intros p task tail before after
  [sem [desc [Hin [Ha [Hp [Hd [Hs Hwake]]]]]]].
 exists desc. split; [exact Hd|]. split; [exact Hs|].
 pose proof (wakeup_task_map _ _ _ _ Hwake) as Hmap.
 cbn in Hmap. rewrite Hmap.
 apply functional_extensionality. intro x.
 unfold update_task_desc_map. destruct (Z.eq_dec x task); reflexivity.
Qed.
Lemma steps_task_facts__bulk_initialization : forall p waiting before after,
 mutex_resume_all_steps p waiting before after ->
 NoDup waiting /\
 Forall (fun task => exists desc,
 task_desc_map (os_tasks before) task = Some desc /\
 tsmStat (tdSchedMember desc) = TSK_SUSPEND) waiting /\
 task_desc_map (os_tasks after) =
 resume_all_task_map (task_desc_map (os_tasks before)) waiting.
Proof.
 intros p waiting. induction waiting as [|task tail IH]; intros before after Hsteps.
 - cbn in Hsteps. subst after. split; [constructor|].
   split; [constructor|]. apply functional_extensionality. intro x.
   unfold resume_all_task_map. cbn. destruct (task_desc_map (os_tasks before) x); reflexivity.
 - destruct Hsteps as [middle [Hstep Hsteps]].
   destruct (step_task_map__bulk_initialization _ _ _ _ _ Hstep)
    as [desc [Hd [Hs Hmap]]].
   destruct (IH _ _ Hsteps) as [Hnd [Hall Hfinal]].
   assert (Hnot : ~ In task tail).
   { intro Hin. rewrite Forall_forall in Hall.
     destruct (Hall task Hin) as [d [Hd' Hs']].
     rewrite Hmap in Hd'. unfold update_task_desc_map in Hd'.
     destruct (Z.eq_dec task task); [|contradiction].
     injection Hd' as <-. discriminate. }
   assert (Horig : Forall (fun t => exists d,
     task_desc_map (os_tasks before) t = Some d /\
     tsmStat (tdSchedMember d) = TSK_SUSPEND) tail).
   { apply Forall_forall. intros t Hin.
     rewrite Forall_forall in Hall.
     destruct (Hall t Hin) as [d [Hd' Hs']].
     exists d. split; [|exact Hs'].
     rewrite Hmap in Hd'. unfold update_task_desc_map in Hd'.
     destruct (Z.eq_dec t task); [subst; contradiction|exact Hd']. }
   split; [constructor; assumption|].
   split; [constructor; [eauto|exact Horig]|].
   rewrite Hfinal, Hmap.
   apply functional_extensionality. intro x.
   unfold resume_all_task_map, update_task_desc_map.
   destruct (Z.eq_dec x task) as [->|Hneq].
   + rewrite Hd. destruct (in_dec Z.eq_dec task tail) as [Hin|Hout]; [contradiction|].
     destruct (in_dec Z.eq_dec task (task :: tail)) as [Hinall|Houtall]; [reflexivity|].
     exfalso. apply Houtall. now left.
   + destruct (task_desc_map (os_tasks before) x); [|reflexivity].
     destruct (in_dec Z.eq_dec x tail) as [Hin|Hout];
       destruct (in_dec Z.eq_dec x (task :: tail)) as [Hinall|Houtall]; try reflexivity.
     * exfalso. apply Houtall. now right.
     * exfalso. apply Hout. destruct Hinall; congruence.
Qed.
Lemma rest_transfer__bulk_initialization : forall (T U : Z -> option TaskDescriptorAbs),
 (forall x, option_map (fun d => tsmRestTimeslice (tdSchedMember d)) (T x) =
            option_map (fun d => tsmRestTimeslice (tdSchedMember d)) (U x)) ->
 forall node ticks, ready_node_rest_timeslice T node ticks ->
 ready_node_rest_timeslice U node ticks.
Proof.
 intros T U H node ticks [d [[Hnz [Hptr Hd]] [Hal Hticks]]].
 specialize (H (getData node)). rewrite Hd in H.
 destruct (U (getData node)) as [d'|] eqn:Hu; [|discriminate].
 cbn in H. injection H as Hrest.
 exists d'. unfold ready_node_task_desc.
 repeat split; try assumption; congruence.
Qed.
Lemma rrr_transfer__bulk_initialization : forall (T U : Z -> option TaskDescriptorAbs),
 (forall x, option_map (fun d => tsmRestTimeslice (tdSchedMember d)) (T x) =
            option_map (fun d => tsmRestTimeslice (tdSchedMember d)) (U x)) ->
 forall sched node before after,
 rrr_bucket_insert T sched node before after ->
 rrr_bucket_insert U sched node before after.
Proof.
 intros T U H sched node before after [[Hadv Hord]|[Hadv Heq]].
 - left. split; [assumption|].
   destruct Hord as [prefix [suffix [Hb [Ha [Hpre Hsuf]]]]].
   exists prefix, suffix. repeat split; try assumption.
   + eapply Forall_impl; [|exact Hpre]. intros n [ticks [Hr Hle]].
     exists ticks. split; [eapply rest_transfer__bulk_initialization; eauto|exact Hle].
   + destruct suffix as [|first suffix]; [exact I|].
     destruct Hsuf as [ticks [Hr Hgt]]. exists ticks.
     split; [eapply rest_transfer__bulk_initialization; eauto|exact Hgt].
 - right. auto.
Qed.
Lemma assign_transfer__bulk_initialization : forall T U task d e before after,
 (forall x, option_map (fun a => tsmRestTimeslice (tdSchedMember a)) (T x) =
            option_map (fun a => tsmRestTimeslice (tdSchedMember a)) (U x)) ->
 U task = Some e ->
 set_sched_member_status (tdSchedMember d) TSK_READY =
 set_sched_member_status (tdSchedMember e) TSK_READY ->
 assign_insert_step_ic T task d before after ->
 assign_insert_step_ic U task e before after.
Proof.
 intros T U task d e before after Hrest Hu Hsched
 [[Hd Hprio] [Halign [Hnz [bucket [Hinsert Hafter]]]]].
 assert (Hprioeq : tsmCurPrio (tdSchedMember d) = tsmCurPrio (tdSchedMember e)).
 { apply (f_equal tsmCurPrio) in Hsched. exact Hsched. }
 unfold assign_insert_step_ic. split; [split; [exact Hu|congruence]|].
 split; [exact Halign|]. split; [exact Hnz|]. exists bucket.
 rewrite <- Hsched. split; [|exact Hafter].
 eapply rrr_transfer__bulk_initialization; [|exact Hinsert].
 intro x. unfold update_task_desc_map.
 destruct (Z.eq_dec x task); [|apply Hrest].
 cbn. apply f_equal. apply (f_equal tsmRestTimeslice) in Hsched.
 exact Hsched.
Qed.
Lemma normalized_lookup__bulk_initialization : forall (T U : Z -> option TaskDescriptorAbs),
 (forall x, option_map (fun d => set_task_desc_ready (set_task_desc_exstatus d (-1))) (T x) =
            option_map (fun d => set_task_desc_ready (set_task_desc_exstatus d (-1))) (U x)) ->
 forall task d, T task = Some d ->
 exists e, U task = Some e /\
 set_sched_member_status (tdSchedMember d) TSK_READY =
 set_sched_member_status (tdSchedMember e) TSK_READY.
Proof.
 intros T U H task d Hd. specialize (H task). rewrite Hd in H.
 destruct (U task) as [e|] eqn:He; [|discriminate].
 exists e. split; [reflexivity|].
 apply (f_equal (fun x => match x with Some a => tdSchedMember a | None => tdSchedMember d end)) in H. exact H.
Qed.
Lemma normalized_rest__bulk_initialization : forall (T U : Z -> option TaskDescriptorAbs),
 (forall x, option_map (fun d => set_task_desc_ready (set_task_desc_exstatus d (-1))) (T x) =
            option_map (fun d => set_task_desc_ready (set_task_desc_exstatus d (-1))) (U x)) ->
 forall x, option_map (fun d => tsmRestTimeslice (tdSchedMember d)) (T x) =
            option_map (fun d => tsmRestTimeslice (tdSchedMember d)) (U x).
Proof.
 intros T U H x. specialize (H x).
 destruct (T x) as [d|], (U x) as [e|]; try discriminate; try reflexivity.
 apply (f_equal (option_map (fun a => tsmRestTimeslice (tdSchedMember a)))) in H.
 exact H.
Qed.
Lemma ready_fold_transfer__bulk_initialization : forall waiting T U P Q,
 (forall x, option_map (fun d => set_task_desc_ready (set_task_desc_exstatus d (-1))) (T x) =
            option_map (fun d => set_task_desc_ready (set_task_desc_exstatus d (-1))) (U x)) ->
 (forall r, P r -> Q r) ->
 forall after,
 fold_left (fun states task => fun r => exists b d,
   states b /\ T task = Some d /\ assign_insert_step_ic T task d b r) waiting P after ->
 fold_left (fun states task => fun r => exists b d,
   states b /\ U task = Some d /\ assign_insert_step_ic U task d b r) waiting Q after.
Proof.
 intros waiting. induction waiting as [|task tail IH]; intros T U P Q Hnorm Hpq after H.
 - apply Hpq, H.
 - cbn in *. eapply IH; [exact Hnorm| |exact H].
   intros r [b [d [Hb [Hd Hins]]]].
   destruct (normalized_lookup__bulk_initialization T U Hnorm task d Hd)
     as [e [He Hsched]].
   exists b, e. split; [apply Hpq, Hb|].
   split; [exact He|].
   eapply (assign_transfer__bulk_initialization T U task d e b r).
   + exact (normalized_rest__bulk_initialization T U Hnorm).
   + exact He.
   + exact Hsched.
   + exact Hins.
Qed.
Lemma normalized_update__bulk_initialization : forall T task d,
 T task = Some d ->
 forall x,
 option_map (fun a => set_task_desc_ready (set_task_desc_exstatus a (-1)))
  (update_task_desc_map task (set_task_desc_ready (set_task_desc_exstatus d (-1))) T x) =
 option_map (fun a => set_task_desc_ready (set_task_desc_exstatus a (-1))) (T x).
Proof.
 intros T task d Hd x. unfold update_task_desc_map.
 destruct (Z.eq_dec x task); [subst x; rewrite Hd|reflexivity].
 destruct d as [a b c e s f g h i j]. destruct s. reflexivity.
Qed.
Lemma steps_ready__bulk_initialization : forall p waiting before after,
 mutex_resume_all_steps p waiting before after ->
 resume_all_ready (task_desc_map (os_tasks before)) waiting
  (assignReadyVector (os_assign before)) (assignReadyVector (os_assign after)).
Proof.
 intros p waiting. induction waiting as [|task tail IH]; intros before after Hsteps.
 - cbn in Hsteps. subst after. reflexivity.
 - destruct Hsteps as [middle [Hstep Htail]].
   pose proof (IH _ _ Htail) as Hreadytail.
   destruct (step_task_map__bulk_initialization _ _ _ _ _ Hstep)
     as [d [Hd [Hs Hmap]]].
   assert (Hnorm : forall x,
      option_map (fun a => set_task_desc_ready (set_task_desc_exstatus a (-1)))
        (task_desc_map (os_tasks middle) x) =
      option_map (fun a => set_task_desc_ready (set_task_desc_exstatus a (-1)))
        (task_desc_map (os_tasks before) x)).
   { rewrite Hmap. apply normalized_update__bulk_initialization, Hd. }
   assert (Hfirst : assign_insert_step_ic (task_desc_map (os_tasks before)) task d
       (assignReadyVector (os_assign before)) (assignReadyVector (os_assign middle))).
   { destruct Hstep as [sem [e [Hin [Ha [Hp [He [Hstat Hframe]]]]]]].
     rewrite Hd in He. injection He as <-.
     pose proof (wakeup_ready _ _ _ _ Hframe) as Hr.
     cbn in Hr. eapply assign_transfer__bulk_initialization; [|exact Hd| |exact Hr].
     - intro x. unfold update_task_desc_map. destruct (Z.eq_dec x task).
       + subst x. rewrite Hd. reflexivity.
       + reflexivity.
     - reflexivity. }
   unfold resume_all_ready in *. cbn.
   eapply ready_fold_transfer__bulk_initialization; [exact Hnorm| |exact Hreadytail].
   intros r ->. exists (assignReadyVector (os_assign before)), d.
   split; [reflexivity|]. split; [exact Hd|exact Hfirst].
Qed.
Lemma dllseg_conflict__bulk_initialization : forall A (storeA : addr -> A -> Assertion)
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
Lemma dllseg_nodup__bulk_initialization : forall A (storeA : addr -> A -> Assertion)
 l x px y py,
 DLL.dllseg storeA x px y py l |-- “ NoDup (map (@getPtr A) l) ”.
Proof.
 intros A storeA l. induction l as [|n tail IH]; intros x px y py.
 - cbn [DLL.dllseg]. Intros. dump_pre_spatial. constructor.
 - cbn [DLL.dllseg]. Intros z. fold (@DLL.dllseg A storeA). subst x.
   prop_apply_p (IH z (getPtr n) y py).
   Intros_p Hnd.
   destruct (in_dec Z.eq_dec (getPtr n) (map (@getPtr A) tail)) as [Hin|Hnot].
   + prop_apply_p (dllseg_conflict__bulk_initialization A storeA tail
       z (getPtr n) y py (getPtr n) px Hin).
     Intros_p Hfalse. contradiction.
   + dump_pre_spatial. constructor; assumption.
Qed.
Lemma dll_nodup__bulk_initialization : forall A (storeA : addr -> A -> Assertion) head l,
 DLL.store_dll storeA head l |-- “ NoDup (map (@getPtr A) l) ”.
Proof.
 intros. unfold DLL.store_dll. Intros h pt.
 prop_apply_p (dllseg_nodup__bulk_initialization A storeA l h head head pt).
 Intros_p Hnd. dump_pre_spatial. exact Hnd.
Qed.
Lemma dll_conflict__bulk_initialization : forall A (storeA : addr -> A -> Assertion)
 l head q v,
 In q (map (@getPtr A) l) ->
 (&(q # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> v) **
 DLL.store_dll storeA head l |-- “ False ”.
Proof.
 intros. unfold DLL.store_dll. Intros h pt.
 prop_apply_p (dllseg_conflict__bulk_initialization A storeA l h head head pt q v H).
 Intros_p Hfalse. contradiction.
Qed.
Lemma delay_disjoint__bulk_initialization : forall inactive active head,
 store_map store_inactive_delay inactive **
 DLL.store_dll store_delay_info head active |--
 “ (forall delay info, inactive delay = Some info ->
    ~ In (&(delay # "Delay" ->ₛ "link")) (map (@getPtr TaskDelayAbs) active)) ”.
Proof.
 intros inactive active head.
 destruct (classic (forall delay info, inactive delay = Some info ->
    ~ In (&(delay # "Delay" ->ₛ "link")) (map (@getPtr TaskDelayAbs) active))) as [Hgood|Hbad].
 - dump_pre_spatial. exact Hgood.
 - apply not_all_ex_not in Hbad. destruct Hbad as [delay Hbad].
   apply not_all_ex_not in Hbad. destruct Hbad as [info Hbad].
   assert (Hlookup : inactive delay = Some info) by tauto.
   assert (Hin : In (&(delay # "Delay" ->ₛ "link")) (map (@getPtr TaskDelayAbs) active)) by tauto.
   sep_apply_l_atomic (store_map_split store_inactive_delay delay info inactive Hlookup).
   unfold store_inactive_delay, store_node_self_linked. Intros.
   prop_apply_p (dll_conflict__bulk_initialization TaskDelayAbs store_delay_info active head
      (&(delay # "Delay" ->ₛ "link")) (&(delay # "Delay" ->ₛ "link")) Hin).
   Intros_p Hfalse. contradiction.
Qed.
Lemma ptr_unique__bulk_initialization : forall A (l : list (DL_Node A)),
 NoDup (map (@getPtr A) l) ->
 forall n m, In n l -> In m l -> getPtr n = getPtr m -> n = m.
Proof.
 intros A l. induction l as [|a l IH]; intros Hnd n m Hn Hm Heq; [contradiction|].
 inversion Hnd as [|? ? Hnot Htail]; subst.
 destruct Hn as [<-|Hn], Hm as [<-|Hm]; auto.
 - exfalso. apply Hnot. rewrite Heq. now apply in_map.
 - exfalso. apply Hnot. rewrite <- Heq. now apply in_map.
Qed.
Lemma filter_all__bulk_initialization : forall A (f : A -> bool) l,
 (forall x, In x l -> f x = true) -> filter f l = l.
Proof.
 intros A f l. induction l as [|x l IH]; intros H; [reflexivity|].
 cbn. rewrite H by now left. f_equal. apply IH. intros y Hy. apply H. now right.
Qed.
Lemma remove_ptr_filter__bulk_initialization : forall A (l r : list (DL_Node A)) n,
 NoDup (map (@getPtr A) l) -> In n l ->
 remove_found_prop n l r ->
 r = filter (fun x => negb (Z.eqb (getPtr x) (getPtr n))) l.
Proof.
 intros A l r n Hnd Hin [[Habs _]|[a [b [Hl Hr]]]]; [contradiction|].
 subst l r. rewrite filter_app. cbn. rewrite Z.eqb_refl. cbn.
 assert (Hnot : ~ In (getPtr n) (map (@getPtr A) (a++b))).
 { rewrite map_app in Hnd. cbn in Hnd.
   pose proof (NoDup_remove_2 _ _ _ Hnd) as Hnot.
   rewrite map_app. exact Hnot. }
 assert (Ha : filter (fun x : DL_Node A => negb (Z.eqb (getPtr x) (getPtr n))) a = a).
 { apply filter_all__bulk_initialization. intros x Hx.
   apply Bool.negb_true_iff, Z.eqb_neq. intro Heq.
   apply Hnot. rewrite <- Heq. apply in_map. apply in_or_app. now left. }
 assert (Hb : filter (fun x : DL_Node A => negb (Z.eqb (getPtr x) (getPtr n))) b = b).
 { apply filter_all__bulk_initialization. intros x Hx.
   apply Bool.negb_true_iff, Z.eqb_neq. intro Heq.
   apply Hnot. rewrite <- Heq. apply in_map. apply in_or_app. now right. }
 now rewrite Ha, Hb.
Qed.
Lemma filter_nodup_ptr__bulk_initialization : forall A (f : DL_Node A -> bool) l,
 NoDup (map (@getPtr A) l) -> NoDup (map (@getPtr A) (filter f l)).
Proof.
 intros A f l. induction l as [|x l IH]; intro H; [constructor|].
 inversion H as [|? ? Hnot Htail]; subst. cbn.
 destruct (f x); [constructor|]; auto.
 intro Hin. apply in_map_iff in Hin as [y [Heq Hy]].
 apply filter_In in Hy as [Hy _]. apply Hnot. rewrite <- Heq. now apply in_map.
Qed.
Lemma unset_summary__bulk_initialization : forall p before after,
 NoDup (map (@getPtr TaskDelayAbs) (delay_active_nodes (os_delays before))) ->
 (forall x info, delay_inactive_map (os_delays before) x = Some info ->
   ~ In (&(x # "Delay" ->ₛ "link"))
       (map (@getPtr TaskDelayAbs) (delay_active_nodes (os_delays before)))) ->
 ktask_unset_delay_step p before after ->
 NoDup (map (@getPtr TaskDelayAbs) (delay_active_nodes (os_delays after))) /\
 (forall x info, delay_inactive_map (os_delays after) x = Some info ->
   ~ In (&(x # "Delay" ->ₛ "link"))
       (map (@getPtr TaskDelayAbs) (delay_active_nodes (os_delays after)))) /\
 delay_active_nodes (os_delays after) =
   (if Z.eq_dec p 0 then delay_active_nodes (os_delays before) else
     filter (fun n => negb (Z.eqb (getPtr n) (&(p # "Delay" ->ₛ "link"))))
       (delay_active_nodes (os_delays before))) /\
 (forall x info, delay_inactive_map (os_delays before) x = Some info ->
   delay_inactive_map (os_delays after) x = Some info) /\
 (forall x, delay_inactive_map (os_delays after) x = delay_inactive_map (os_delays before) x \/
   (x = p /\ p <> 0 /\ exists node,
     In node (delay_active_nodes (os_delays before)) /\
     getPtr node = &(p # "Delay" ->ₛ "link") /\
     delay_inactive_map (os_delays after) x = Some (delay_mark_inactive (getData node)))) /\
 (p <> 0 -> delay_inactive_map (os_delays after) p <> None).
Proof.
 intros p before after Hnd Hdis Hstep.
 destruct Hstep as [[Hp ->]|[[Hnz [info [Hlookup ->]]]|[Hnz [info [Hin Hrec]]]]].
 - subst p. split; [exact Hnd|]. split; [exact Hdis|].
   split; [destruct (Z.eq_dec 0 0); [reflexivity|contradiction]|].
   split; [auto|]. split; [auto|contradiction].
 - split; [exact Hnd|]. split; [exact Hdis|].
   split.
   + destruct (Z.eq_dec p 0); [contradiction|]. symmetry.
     apply filter_all__bulk_initialization. intros node Hnode.
     apply Bool.negb_true_iff, Z.eqb_neq. intro Heq.
     apply (Hdis p info Hlookup). rewrite <- Heq. now apply in_map.
   + split; [auto|]. split; [auto|]. intros _. rewrite Hlookup. discriminate.
 - pose proof (unset_delay_active_nodes _ _ _ _ Hrec) as Hr.
   pose proof (unset_delay_inactive_map _ _ _ _ Hrec) as Hm.
   pose proof (remove_ptr_filter__bulk_initialization _ _ _
     (Build_DL_Node info (&(p # "Delay" ->ₛ "link"))) Hnd Hin Hr) as Ha.
   cbn in Ha.
   assert (Habs : delay_inactive_map (os_delays before) p = None).
   { destruct (delay_inactive_map (os_delays before) p) as [a|] eqn:Hpa; [|reflexivity].
     exfalso. apply (Hdis p a Hpa).
     apply in_map_iff. exists (Build_DL_Node info (&(p # "Delay" ->ₛ "link"))). auto. }
   assert (Hsub : forall node, In node (delay_active_nodes (os_delays after)) ->
     In node (delay_active_nodes (os_delays before))).
   { intros node Hnode. rewrite Ha in Hnode. now apply filter_In in Hnode as [Hnode _]. }
   split.
   + rewrite Ha. now apply filter_nodup_ptr__bulk_initialization.
   + split.
     * intros x a Hxa Hina. rewrite Hm in Hxa.
       unfold Mapping.partial_mapping_update in Hxa.
       destruct (Z.eq_dec p x) as [<-|Hneq].
       -- apply in_map_iff in Hina as [node [Heq Hnode]].
          rewrite Ha in Hnode. apply filter_In in Hnode as [_ Hf].
          rewrite Heq, Z.eqb_refl in Hf. discriminate.
       -- apply (Hdis x a Hxa).
          apply in_map_iff in Hina as [node [Heq Hnode]].
          apply in_map_iff. exists node. split; [exact Heq|now apply Hsub].
     * split; [rewrite Ha; destruct (Z.eq_dec p 0); [contradiction|reflexivity]|].
       split.
       -- intros x a Hxa. rewrite Hm. unfold Mapping.partial_mapping_update.
          destruct (Z.eq_dec p x); [subst; congruence|exact Hxa].
       -- split.
          ++ intro x. rewrite Hm. unfold Mapping.partial_mapping_update.
             destruct (Z.eq_dec p x) as [<-|Hneq]; [right|now left].
             split; [reflexivity|]. split; [exact Hnz|].
             exists (Build_DL_Node info (&(p # "Delay" ->ₛ "link"))).
             repeat split; assumption || reflexivity.
          ++ intros _. rewrite Hm, Mapping.partial_mapping_update_eq. discriminate.
Qed.
Lemma selected_normalized__bulk_initialization : forall waiting (T U : addr -> option TaskDescriptorAbs),
 (forall x, option_map (fun d => set_task_desc_ready (set_task_desc_exstatus d (-1))) (T x) =
            option_map (fun d => set_task_desc_ready (set_task_desc_exstatus d (-1))) (U x)) ->
 fold_right (fun task delays => match T task with
   | Some d => if Z.eq_dec (tdDelay d) 0 then delays else tdDelay d :: delays
   | None => delays end) [] waiting =
 fold_right (fun task delays => match U task with
   | Some d => if Z.eq_dec (tdDelay d) 0 then delays else tdDelay d :: delays
   | None => delays end) [] waiting.
Proof.
 intros waiting T U H. induction waiting as [|task tail IH]; [reflexivity|].
 cbn. rewrite IH. specialize (H task).
 destruct (T task) as [d|], (U task) as [e|]; try discriminate; try reflexivity.
 apply (f_equal (fun x => match x with Some a => tdDelay a | None => 0 end)) in H.
 cbn in H. now rewrite H.
Qed.
Lemma filter_selected_cons__bulk_initialization : forall p selected nodes,
 filter (fun n : DL_Node TaskDelayAbs =>
   negb (existsb (fun d => Z.eqb (getPtr n) (&(d # "Delay" ->ₛ "link"))) selected))
 (filter (fun n => negb (Z.eqb (getPtr n) (&(p # "Delay" ->ₛ "link")))) nodes) =
 filter (fun n : DL_Node TaskDelayAbs =>
   negb (existsb (fun d => Z.eqb (getPtr n) (&(d # "Delay" ->ₛ "link"))) (p::selected))) nodes.
Proof.
 intros p selected nodes. induction nodes as [|n nodes IH]; [reflexivity|].
 cbn. destruct (Z.eqb (getPtr n) (&(p # "Delay" ->ₛ "link"))) eqn:Hone;
 destruct (existsb (fun d => Z.eqb (getPtr n) (&(d # "Delay" ->ₛ "link"))) selected) eqn:Htail;
 cbn; rewrite ?Htail; cbn; rewrite ?IH; reflexivity.
Qed.
Lemma steps_delays_summary__bulk_initialization : forall p waiting before after,
 mutex_resume_all_steps p waiting before after ->
 NoDup (map (@getPtr TaskDelayAbs) (delay_active_nodes (os_delays before))) ->
 (forall x info, delay_inactive_map (os_delays before) x = Some info ->
   ~ In (&(x # "Delay" ->ₛ "link"))
       (map (@getPtr TaskDelayAbs) (delay_active_nodes (os_delays before)))) ->
 let selected := fold_right (fun task delays =>
   match task_desc_map (os_tasks before) task with
   | Some d => if Z.eq_dec (tdDelay d) 0 then delays else tdDelay d :: delays
   | None => delays end) [] waiting in
 NoDup (map (@getPtr TaskDelayAbs) (delay_active_nodes (os_delays after))) /\
 (forall x info, delay_inactive_map (os_delays after) x = Some info ->
   ~ In (&(x # "Delay" ->ₛ "link"))
       (map (@getPtr TaskDelayAbs) (delay_active_nodes (os_delays after)))) /\
 delay_active_nodes (os_delays after) =
   filter (fun n => negb (existsb (fun d => Z.eqb (getPtr n) (&(d # "Delay" ->ₛ "link"))) selected))
     (delay_active_nodes (os_delays before)) /\
 (forall x info, delay_inactive_map (os_delays before) x = Some info ->
   delay_inactive_map (os_delays after) x = Some info) /\
 (forall x, delay_inactive_map (os_delays after) x = delay_inactive_map (os_delays before) x \/
   (In x selected /\ exists node,
     In node (delay_active_nodes (os_delays before)) /\
     getPtr node = &(x # "Delay" ->ₛ "link") /\
     delay_inactive_map (os_delays after) x = Some (delay_mark_inactive (getData node)))) /\
 (forall x, In x selected -> delay_inactive_map (os_delays after) x <> None).
Proof.
 intros p waiting. induction waiting as [|task tail IH]; intros before after Hsteps Hnd Hdis.
 - cbn in Hsteps. subst after. cbn zeta. split; [exact Hnd|]. split; [exact Hdis|].
   split.
   + symmetry. apply filter_all__bulk_initialization. reflexivity.
   + split; [auto|]. split; [auto|]. intros x Hx. contradiction.
 - destruct Hsteps as [middle [Hone Htail]].
   destruct (step_task_map__bulk_initialization _ _ _ _ _ Hone) as [desc [Hdesc [Hstat Hmap]]].
   assert (Hnorm : forall x,
      option_map (fun a => set_task_desc_ready (set_task_desc_exstatus a (-1)))
        (task_desc_map (os_tasks middle) x) =
      option_map (fun a => set_task_desc_ready (set_task_desc_exstatus a (-1)))
        (task_desc_map (os_tasks before) x)).
   { rewrite Hmap. apply normalized_update__bulk_initialization, Hdesc. }
   destruct Hone as [sem [d [Hin [Ha [Hp [Hd [Hs Hframe]]]]]]].
   rewrite Hdesc in Hd. injection Hd as <-.
   destruct (wakeup_delays _ _ _ _ Hframe) as [delayafter [Hun Hdelays]].
   pose proof (unset_summary__bulk_initialization _
      (replace_task_desc_map (update_task_desc_map task (set_task_desc_exstatus desc (-1))
        (task_desc_map (os_tasks before))) before) delayafter Hnd Hdis Hun) as Hsingle.
   cbn in Hsingle. rewrite <- Hdelays in Hsingle.
   destruct Hsingle as [Hndmid [Hdismid [Hactive [Hpres [Hnew Hpresent]]]]].
   pose proof (IH middle after Htail Hndmid Hdismid) as Hrest.
   cbn zeta in Hrest.
   rewrite (selected_normalized__bulk_initialization tail _ _ Hnorm) in Hrest.
   destruct Hrest as [Hndend [Hdisend [Hactiveend [Hpresend [Hnewend Hpresentend]]]]].
   cbn zeta. cbn [fold_right]. rewrite Hdesc.
   set (selected := fold_right (fun t delays => match task_desc_map (os_tasks before) t with
     | Some d => if Z.eq_dec (tdDelay d) 0 then delays else tdDelay d :: delays
     | None => delays end) [] tail) in *.
   assert (Hsub : forall node, In node (delay_active_nodes (os_delays middle)) ->
     In node (delay_active_nodes (os_delays before))).
   { intros node Hnode. rewrite Hactive in Hnode.
     destruct (Z.eq_dec (tdDelay desc) 0); [exact Hnode|].
     now apply filter_In in Hnode as [Hnode _]. }
   split; [exact Hndend|]. split; [exact Hdisend|].
   split.
   + rewrite Hactiveend, Hactive.
     destruct (Z.eq_dec (tdDelay desc) 0); [reflexivity|].
     apply filter_selected_cons__bulk_initialization.
   + split.
     * intros x info Hlookup. apply Hpresend, Hpres, Hlookup.
     * split.
       -- intro x. destruct (Hnewend x) as [Heq|[Hsel [node [Hnode [Hptr Hvalue]]]]].
          ++ rewrite Heq. destruct (Hnew x) as [Heq0|[Hx [Hnz [node [Hnode [Hptr Hvalue]]]]]].
             ** now left.
             ** right. subst x. split.
                --- destruct (Z.eq_dec (tdDelay desc) 0); [contradiction|now left].
                --- exists node. auto.
          ++ right. split.
             ** destruct (Z.eq_dec (tdDelay desc) 0); [exact Hsel|now right].
             ** exists node. split; [now apply Hsub|auto].
       -- intros x Hsel. destruct (Z.eq_dec (tdDelay desc) 0) as [Hz|Hnz].
          ++ now apply Hpresentend.
          ++ destruct Hsel as [<-|Hsel]; [|now apply Hpresentend].
             specialize (Hpresent Hnz).
             destruct (delay_inactive_map (os_delays middle) (tdDelay desc)) as [info|] eqn:Hlookup;
               [|contradiction].
             rewrite (Hpresend _ _ Hlookup). discriminate.
Qed.
Lemma steps_delays__bulk_initialization : forall p waiting before after,
 mutex_resume_all_steps p waiting before after ->
 NoDup (map (@getPtr TaskDelayAbs) (delay_active_nodes (os_delays before))) ->
 (forall x info, delay_inactive_map (os_delays before) x = Some info ->
   ~ In (&(x # "Delay" ->ₛ "link"))
       (map (@getPtr TaskDelayAbs) (delay_active_nodes (os_delays before)))) ->
 os_delays after = resume_all_delays (task_desc_map (os_tasks before)) waiting (os_delays before).
Proof.
 intros p waiting before after Hsteps Hnd Hdis.
 pose proof (steps_delays_summary__bulk_initialization _ _ _ _ Hsteps Hnd Hdis) as Hsum.
 cbn zeta in Hsum.
 destruct Hsum as [_ [_ [Hactive [Hpres [Hnew Hpresent]]]]].
 unfold resume_all_delays.
 set (selected := fold_right (fun t delays => match task_desc_map (os_tasks before) t with
   | Some d => if Z.eq_dec (tdDelay d) 0 then delays else tdDelay d :: delays
   | None => delays end) [] waiting) in *.
 destruct (os_delays after) as [ma la]. cbn in *. f_equal; [|exact Hactive].
 apply functional_extensionality. intro x.
 destruct (in_dec Z.eq_dec x selected) as [Hin|Hout].
 - destruct (find (fun n : DL_Node TaskDelayAbs => Z.eqb (getPtr n) (&(x # "Delay" ->ₛ "link")))
     (delay_active_nodes (os_delays before))) as [node|] eqn:Hfind.
   + apply find_some in Hfind as [Hnode Hptr]. apply Z.eqb_eq in Hptr.
     destruct (Hnew x) as [Heq|[_ [node' [Hnode' [Hptr' Hvalue]]]]].
     * specialize (Hpresent x Hin). rewrite Heq in Hpresent.
       destruct (delay_inactive_map (os_delays before) x) as [info|] eqn:Hold;
         [|contradiction].
       exfalso. apply (Hdis x info Hold). rewrite <- Hptr. now apply in_map.
     * assert (Hnodes : node'=node) by
         (eapply ptr_unique__bulk_initialization; eauto; congruence).
       subst node'. exact Hvalue.
   + destruct (Hnew x) as [Heq|[_ [node [Hnode [Hptr Hvalue]]]]]; [exact Heq|].
     pose proof (find_none _ _ Hfind node Hnode) as Hfalse.
     cbn in Hfalse. rewrite Hptr, Z.eqb_refl in Hfalse. discriminate.
 - destruct (Hnew x) as [Heq|[Hin _]]; [exact Heq|contradiction].
Qed.
Lemma nodup_app_disjoint__bulk_initialization : forall {A} (a b : list A),
 NoDup (a ++ b) -> forall x, In x a -> ~ In x b.
Proof.
 intros A a. induction a as [|y a IH]; intros b Hnd x Hin Hbin; [contradiction|].
 inversion Hnd as [|? ? Hnot Htail]; subst.
 destruct Hin as [<-|Hin].
 - apply Hnot. apply in_or_app; now right.
 - exact (IH b Htail x Hin Hbin).
Qed.
Lemma remove_in__bulk_initialization : forall {A} (x : A) a b,
 remove_found_prop x a b -> forall y, In y b -> In y a.
Proof.
 intros A x a b [[_ <-]|[p [q [-> ->]]]] y Hy; [exact Hy|].
 apply in_app_iff in Hy as [Hy|Hy]; apply in_or_app; [now left|right; now right].
Qed.
Lemma remove_absent_eq__bulk_initialization : forall {A} (x : A) a b,
 ~ In x a -> remove_found_prop x a b -> b = a.
Proof.
 intros A x a b Hnot [[_ ->]|[p [q [-> ->]]]]; [reflexivity|].
 exfalso; apply Hnot; apply in_or_app; right; now left.
Qed.
Lemma remove_nodup__bulk_initialization : forall {A} (x : A) a b,
 NoDup a -> remove_found_prop x a b -> NoDup b.
Proof.
 intros A x a b Hnd [[_ <-]|[p [q [-> ->]]]]; [exact Hnd|].
 exact (NoDup_remove_1 p q x Hnd).
Qed.
Lemma concat_member__bulk_initialization : forall {A} (f : A -> list addr) l a t,
 In a l -> In t (f a) -> In t (List.concat (map f l)).
Proof.
 intros A f l a t Ha Ht. apply in_concat. exists (f a). split; [now apply in_map|exact Ht].
Qed.
Lemma concat_nodup_member__bulk_initialization : forall {A} (f : A -> list addr) l a,
 NoDup (List.concat (map f l)) -> In a l -> NoDup (f a).
Proof.
 intros A f l. induction l as [|x l IH]; intros a Hnd Hin; [contradiction|].
 cbn in Hnd. destruct Hin as [<-|Hin].
 - eapply NoDup_app_remove_r; exact Hnd.
 - apply IH; [eapply NoDup_app_remove_l; exact Hnd|exact Hin].
Qed.
Lemma concat_nodup_disjoint__bulk_initialization : forall {A} (f : A -> list addr) l a b,
 NoDup (List.concat (map f l)) -> In a l -> In b l -> a <> b ->
 forall t, In t (f a) -> ~ In t (f b).
Proof.
 intros A f l. induction l as [|x l IH]; intros a b Hnd Ha Hb Hneq t Hta Htb;
 [contradiction|]. cbn in Hnd.
 destruct Ha as [<-|Ha], Hb as [<-|Hb]; [contradiction| | |].
 - eapply (nodup_app_disjoint__bulk_initialization (f x) (List.concat (map f l)) Hnd t Hta).
   eapply concat_member__bulk_initialization; eauto.
 - eapply (nodup_app_disjoint__bulk_initialization (f x) (List.concat (map f l)) Hnd t Htb).
   eapply concat_member__bulk_initialization; eauto.
 - eapply IH; [eapply NoDup_app_remove_l; exact Hnd|exact Ha|exact Hb|exact Hneq|exact Hta|exact Htb].
Qed.
Lemma nodup_map_injective__bulk_initialization : forall A B (f : A -> B) l,
 NoDup (map f l) ->
 forall a b, In a l -> In b l -> f a = f b -> a = b.
Proof.
 intros A B f l. induction l as [|x l IH]; intros Hnd a b Ha Hb Heq; [contradiction|].
 inversion Hnd as [|? ? Hnot Htail]; subst.
 destruct Ha as [<-|Ha], Hb as [<-|Hb]; auto.
 - exfalso. apply Hnot. rewrite Heq. now apply in_map.
 - exfalso. apply Hnot. rewrite <- Heq. now apply in_map.
Qed.
Lemma sem_absent_step__bulk_initialization : forall task before after,
 ~ In task (semaphore_waiters before) ->
 semaphore_remove_waiter_step task before after -> after = before.
Proof.
 intros task before after Hnot Hr. unfold semaphore_remove_waiter_step in Hr.
 induction Hr as [|a b before after Hrel Hr IH]; [reflexivity|].
 cbn [semaphore_waiters] in Hnot.
 destruct Hrel as [Ha [Hi [Hv Hp]]].
 assert (Hpending : semaphore_pending_addrs b = semaphore_pending_addrs a).
 { apply (remove_absent_eq__bulk_initialization task _ _); [|exact Hp].
   intro Hin; apply Hnot; apply in_or_app; now left. }
 assert (Htail : after = before).
 { apply IH. intro Hin; apply Hnot; apply in_or_app; now right. }
 subst after. f_equal. destruct a, b. cbn in *. subst. reflexivity.
Qed.
Lemma event_absent_step__bulk_initialization : forall task before after,
 ~ In task (event_waiters before) ->
 event_remove_waiter_step task before after -> after = before.
Proof.
 intros task before after Hnot Hr. unfold event_remove_waiter_step in Hr.
 induction Hr as [|a b before after Hrel Hr IH]; [reflexivity|].
 cbn [event_waiters] in Hnot.
 destruct Hrel as [Ha [Hi [Ho [He Hp]]]].
 assert (Hpending : event_pending_addrs b = event_pending_addrs a).
 { apply (remove_absent_eq__bulk_initialization task _ _); [|exact Hp].
   intro Hin; apply Hnot; apply in_or_app; now left. }
 assert (Htail : after = before).
 { apply IH. intro Hin; apply Hnot; apply in_or_app; now right. }
 subst after. f_equal. destruct a, b. cbn in *. subst. reflexivity.
Qed.
Lemma mutex_waiters_subset__bulk_initialization : forall task before after,
 mutex_remove_waiter_step task before after ->
 forall x, In x (mutex_waiters after) -> In x (mutex_waiters before).
Proof.
 intros task before after Hr. unfold mutex_remove_waiter_step in Hr.
 induction Hr as [|a b before after Hrel Hr IH]; intros x Hin; [contradiction|].
 cbn [mutex_waiters] in *. apply in_app_iff in Hin as [Hin|Hin]; apply in_or_app.
 - left. destruct Hrel as [_ [_ [_ [_ [_ [_ Hp]]]]]].
   eapply remove_in__bulk_initialization; eauto.
 - right; now apply IH.
Qed.
Lemma mutex_waiters_nodup__bulk_initialization : forall task before after,
 mutex_remove_waiter_step task before after ->
 NoDup (mutex_waiters before) -> NoDup (mutex_waiters after).
Proof.
 intros task before after Hr. unfold mutex_remove_waiter_step in Hr.
 induction Hr as [|a b before after Hrel Hr IH]; intro Hnd; [constructor|].
 cbn [mutex_waiters] in *. destruct Hrel as [_ [_ [_ [_ [_ [_ Hp]]]]]].
 apply NoDup_app.
 - eapply remove_nodup__bulk_initialization; [eapply NoDup_app_remove_r; exact Hnd|exact Hp].
 - apply IH. eapply NoDup_app_remove_l; exact Hnd.
 - intros x Hx Hy.
   eapply (nodup_app_disjoint__bulk_initialization _ _ Hnd x).
   + eapply remove_in__bulk_initialization; eauto.
   + eapply mutex_waiters_subset__bulk_initialization; [exact Hr|exact Hy].
Qed.
Lemma mutex_step_map__bulk_initialization : forall task p tail before after,
 (forall m, In m before ->
   (mutex_addr m = p -> mutex_pending_addrs m = task :: tail /\ NoDup (mutex_pending_addrs m)) /\
   (mutex_addr m <> p -> ~ In task (mutex_pending_addrs m))) ->
 mutex_remove_waiter_step task before after ->
 after = mutex_delete_set_pending p tail before.
Proof.
 intros task p tail before after Hconds Hr. unfold mutex_remove_waiter_step in Hr.
 induction Hr as [|a b before after Hrel Hr IH]; [reflexivity|].
 destruct (Hconds a (or_introl eq_refl)) as [Heq Hneq].
 assert (Htail : after = mutex_delete_set_pending p tail before).
 { apply IH. intros m Hin. apply Hconds. now right. }
 rewrite Htail. unfold mutex_delete_set_pending at 2. cbn [map]. fold (mutex_delete_set_pending p tail before).
 f_equal. destruct Hrel as [Ha [Hi [Hv [Hrct [Hpr [Hholder Hp]]]]]].
 destruct (Z.eq_dec (mutex_addr a) p) as [Hap|Hap].
 - destruct (Heq Hap) as [Hpending Hnd].
   assert (Hnew : mutex_pending_addrs b = tail).
   { eapply (remove_found_deterministic task (mutex_pending_addrs a)); [exact Hnd|exact Hp|].
     rewrite Hpending. apply (remove_found_at_split task [] tail). }
   destruct a, b. cbn in *. subst. reflexivity.
 - assert (Hnew : mutex_pending_addrs b = mutex_pending_addrs a).
   { eapply remove_absent_eq__bulk_initialization; [apply Hneq,Hap|exact Hp]. }
   destruct a, b. cbn in *. subst. reflexivity.
Qed.
Lemma step_mutexes__bulk_initialization : forall p task tail before after,
 NoDup (map mutex_addr (os_mutexes before)) ->
 NoDup (mutex_waiters (os_mutexes before)) ->
 mutex_resume_one p task tail before after ->
 os_mutexes after = mutex_delete_set_pending p tail (os_mutexes before).
Proof.
 intros p task tail before after Haddr Hwait
 [m [desc [Hin [Ha [Hp [Hd [Hs Hwake]]]]]]].
 apply (mutex_step_map__bulk_initialization task p tail).
 - intros other Hother. split.
   + intro Hpa. assert (Hobj : other=m).
     { eapply nodup_map_injective__bulk_initialization; eauto; congruence. }
     subst other. split; [exact Hp|].
     eapply concat_nodup_member__bulk_initialization; [exact Hwait|exact Hin].
   + intros Hne Htin.
     eapply (concat_nodup_disjoint__bulk_initialization mutex_pending_addrs
       (os_mutexes before) m other Hwait Hin Hother).
     * intro Heq; subst other; contradiction.
     * rewrite Hp; now left.
     * exact Htin.
 - exact (wakeup_mutexes _ _ _ _ Hwake).
Qed.
Lemma mutex_pending_addresses__bulk_initialization : forall p waiting sems,
 map mutex_addr (mutex_delete_set_pending p waiting sems) = map mutex_addr sems.
Proof.
 intros p waiting sems. unfold mutex_delete_set_pending. rewrite map_map.
 apply map_ext. intro sem. destruct (Z.eq_dec (mutex_addr sem) p); reflexivity.
Qed.
Lemma mutex_pending_twice__bulk_initialization : forall p a b sems,
 mutex_delete_set_pending p a (mutex_delete_set_pending p b sems) =
 mutex_delete_set_pending p a sems.
Proof.
 intros p a b sems. unfold mutex_delete_set_pending. rewrite map_map.
 apply map_ext. intro sem. destruct (Z.eq_dec (mutex_addr sem) p) as [Heq|Hneq].
 - cbn. destruct (Z.eq_dec (mutex_addr sem) p); [reflexivity|contradiction].
 - destruct (Z.eq_dec (mutex_addr sem) p); [contradiction|reflexivity].
Qed.
Lemma steps_mutexes__bulk_initialization : forall p waiting before after,
 waiting <> [] ->
 NoDup (map mutex_addr (os_mutexes before)) ->
 NoDup (mutex_waiters (os_mutexes before)) ->
 mutex_resume_all_steps p waiting before after ->
 os_mutexes after = mutex_delete_set_pending p [] (os_mutexes before).
Proof.
 intros p waiting. induction waiting as [|task tail IH]; intros before after Hnon Hnd Hw Hsteps;
 [contradiction|].
 destruct Hsteps as [middle [Hone Htail]].
 pose proof (step_mutexes__bulk_initialization _ _ _ _ _ Hnd Hw Hone) as Hsem.
 destruct tail as [|next rest].
 - cbn in Htail. subst after. exact Hsem.
 - rewrite (IH middle after ltac:(discriminate)).
   + rewrite Hsem. apply mutex_pending_twice__bulk_initialization.
   + rewrite Hsem, mutex_pending_addresses__bulk_initialization. exact Hnd.
   + destruct Hone as [m [d [_ [_ [_ [_ [_ Hwake]]]]]]].
     eapply mutex_waiters_nodup__bulk_initialization; [exact (wakeup_mutexes _ _ _ _ Hwake)|exact Hw].
   + exact Htail.
Qed.
Lemma scheduler_parts__bulk_initialization : forall st,
 NoDup (os_sched_owners st) ->
 NoDup (mutex_waiters (os_mutexes st)) /\
 (forall t, In t (mutex_waiters (os_mutexes st)) ->
   ~ In t (sched_owned_tasks (os_tasks st)) /\
   ~ In t (semaphore_waiters (os_semaphores st)) /\
   ~ In t (event_waiters (os_events st))).
Proof.
 intros st Hnd. unfold os_sched_owners in Hnd.
 pose proof (NoDup_app_remove_l _ _ Hnd) as H1.
 pose proof (NoDup_app_remove_l _ _ H1) as H2.
 pose proof (NoDup_app_remove_l _ _ H2) as H3.
 pose proof (NoDup_app_remove_l _ _ H3) as H4.
 split; [eapply NoDup_app_remove_r; exact H4|].
 intros t Ht. split.
 - intro Howned. eapply (nodup_app_disjoint__bulk_initialization _ _ Hnd t Howned).
   apply in_or_app; right. apply in_or_app; right. apply in_or_app; right.
   apply in_or_app; now left.
 - split.
   + intro Hsem. eapply (nodup_app_disjoint__bulk_initialization _ _ H3 t Hsem).
     apply in_or_app; now left.
   + eapply nodup_app_disjoint__bulk_initialization; [exact H4|exact Ht].
Qed.
Lemma os_shapes__bulk_initialization : forall sg st,
 os_inv sg st |--
 “ (NoDup (map mutex_addr (os_mutexes st)) /\
    NoDup (map (@getPtr TaskDelayAbs) (delay_active_nodes (os_delays st))) /\
    (forall delay info, delay_inactive_map (os_delays st) delay = Some info ->
      ~ In (&(delay # "Delay" ->ₛ "link"))
        (map (@getPtr TaskDelayAbs) (delay_active_nodes (os_delays st))))) /\
    NoDup (os_sched_owners st) ”.
Proof.
 intros sg st. unfold os_inv, mutex_inv, delay_inv. Intros.
 prop_apply_p (dll_nodup__bulk_initialization MutexAbs
   (store_mutex (pure_suspend_sched_link (task_desc_map (os_tasks st))))
   (mutex_list_head (os_mutex_stable sg))
   (map mutex_link_node (os_mutexes st))).
 Intros_p Hmutex.
 prop_apply_p (dll_nodup__bulk_initialization TaskDelayAbs store_delay_info
   (delay_head_ptr sg) (delay_active_nodes (os_delays st))).
 Intros_p Hnd.
 prop_apply_p (delay_disjoint__bulk_initialization
   (delay_inactive_map (os_delays st)) (delay_active_nodes (os_delays st)) (delay_head_ptr sg)).
 Intros_p Hdis.
 dump_pre_spatial. split.
 - split; [|auto].
   assert (Heq : map (@getPtr MutexAbs) (map mutex_link_node (os_mutexes st)) =
     map (fun p => &(p # "Mutex" ->ₛ "link")) (map mutex_addr (os_mutexes st))).
   { rewrite !map_map. reflexivity. }
   rewrite Heq in Hmutex. now apply NoDup_map_inv in Hmutex.
 - match goal with H : os_world_wf sg st |- _ => exact (os_wf_sched_nodup _ _ H) end.
Qed.
Lemma steps_preserved__bulk_initialization : forall p waiting before after,
 (forall t, In t waiting ->
   ~ In t (sched_owned_tasks (os_tasks before)) /\
   ~ In t (semaphore_waiters (os_semaphores before)) /\
   ~ In t (event_waiters (os_events before))) ->
 mutex_resume_all_steps p waiting before after ->
 (task_idmanager_abs (os_tasks after), task_ptr_list (os_tasks after),
 sched_owned_tasks (os_tasks after), os_tick after,
 assignRunningTask (os_assign after), assignCurrentPriority (os_assign after),
 zombie_queue after, os_recycle after, os_idle after,
 os_semaphores after, os_events after, os_isr after, os_exstatus after) =
 (task_idmanager_abs (os_tasks before), task_ptr_list (os_tasks before),
 sched_owned_tasks (os_tasks before), os_tick before,
 assignRunningTask (os_assign before), assignCurrentPriority (os_assign before),
 zombie_queue before, os_recycle before, os_idle before,
 os_semaphores before, os_events before, os_isr before, os_exstatus before).
Proof.
 intros p waiting. induction waiting as [|task tail IH]; intros before after Hforeign Hsteps.
 - cbn in Hsteps. subst after. reflexivity.
 - destruct Hsteps as [middle [Hone Htail]].
   destruct (Hforeign task (or_introl eq_refl)) as [Howned [Hsem Hevent]].
   destruct Hone as [m [d [Hin [Ha [Hp [Hd [Hs Hwake]]]]]]].
   pose proof (wakeup_owned _ _ _ _ Hwake) as Ho.
   pose proof (wakeup_semaphores _ _ _ _ Hwake) as Hsrel.
   pose proof (wakeup_events _ _ _ _ Hwake) as Herel.
   cbn in Ho, Hsrel, Herel.
   assert (Hoeq : sched_owned_tasks (os_tasks middle) = sched_owned_tasks (os_tasks before)).
   { eapply remove_absent_eq__bulk_initialization; eauto. }
   assert (Hseq : os_semaphores middle = os_semaphores before).
   { eapply sem_absent_step__bulk_initialization; eauto. }
   assert (Heeq : os_events middle = os_events before).
   { eapply event_absent_step__bulk_initialization; eauto. }
   assert (Hforeign_tail : forall t, In t tail ->
     ~ In t (sched_owned_tasks (os_tasks middle)) /\
     ~ In t (semaphore_waiters (os_semaphores middle)) /\
     ~ In t (event_waiters (os_events middle))).
   { intros t Ht. rewrite Hoeq, Hseq, Heeq. apply Hforeign. now right. }
   rewrite (IH _ _ Hforeign_tail Htail).
   destruct Hwake. cbn in *.
   repeat first [assumption | progress f_equal].
Qed.
Lemma steps_global_state__bulk_initialization : forall p waiting before after,
 (forall t, In t waiting ->
   ~ In t (sched_owned_tasks (os_tasks before)) /\
   ~ In t (semaphore_waiters (os_semaphores before)) /\
   ~ In t (event_waiters (os_events before))) ->
 mutex_resume_all_steps p waiting before after ->
 after = replace_mutexes (os_mutexes after)
   (replace_global_ready_vector (assignReadyVector (os_assign after))
     (replace_global_delays (os_delays after)
       (replace_task_desc_map (task_desc_map (os_tasks after)) before))).
Proof.
 intros p waiting before after Hforeign Hsteps.
 pose proof (steps_preserved__bulk_initialization _ _ _ _ Hforeign Hsteps) as Hframe.
 destruct before as [be bm bs bt btk bd ba bz br bi bisr bex].
 destruct after as [ae am as_ ats atk ad aa az ar ai aisr aex].
 destruct bt, ats, ba, aa. cbn in Hframe. inversion Hframe. subst. reflexivity.
Qed.
Lemma resume_steps_bulk__bulk_initialization : forall sg before m,
 In m (os_mutexes before) ->
 os_inv sg before |-- “ forall final,
 mutex_resume_all_steps (mutex_addr m) (mutex_pending_addrs m) before final ->
 mutex_resume_all_effect (mutex_addr m) (mutex_pending_addrs m) before final ”.
Proof.
 intros sg before m Hin.
 prop_apply_p (os_shapes__bulk_initialization sg before).
 Intros_p Hshapes. destruct Hshapes as [[Hmutex [Hnd Hdis]] Hsched].
 destruct (scheduler_parts__bulk_initialization before Hsched) as [Hwaiting Hforeign].
 assert (Hf : forall t, In t (mutex_pending_addrs m) ->
   ~ In t (sched_owned_tasks (os_tasks before)) /\
   ~ In t (semaphore_waiters (os_semaphores before)) /\
   ~ In t (event_waiters (os_events before))).
 { intros t Ht. apply Hforeign.
   eapply concat_member__bulk_initialization; [exact Hin|exact Ht]. }
 dump_pre_spatial. intros final Hsteps.
 destruct (mutex_pending_addrs m) as [|task tail] eqn:Hpending.
 - exact Hsteps.
 - pose proof (steps_task_facts__bulk_initialization _ _ _ _ Hsteps) as [Htasks [Hsuspended Hmap]].
   cbn [mutex_resume_all_effect]. split; [exact Htasks|].
   split; [exact Hsuspended|].
   exists (assignReadyVector (os_assign final)). split.
   + eapply steps_ready__bulk_initialization; exact Hsteps.
   + pose proof (steps_global_state__bulk_initialization _ _ _ _ Hf Hsteps) as Hglobal.
     rewrite (steps_mutexes__bulk_initialization (mutex_addr m) (task::tail) before final
       ltac:(discriminate) Hmutex Hwaiting Hsteps) in Hglobal.
     rewrite (steps_delays__bulk_initialization _ _ _ _ Hsteps Hnd Hdis) in Hglobal.
     rewrite Hmap in Hglobal. exact Hglobal.
Qed.
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
Lemma dllseg_payload__head_view : forall {A} (P:addr -> A -> Assertion) l n x px y py,
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
Lemma dll_payload__head_view : forall {A} (P:addr -> A -> Assertion) l n head,
 In n l -> DLL.store_dll P head l |-- P (getPtr n) (getData n) ** (P (getPtr n) (getData n) -* DLL.store_dll P head l).
Proof.
 intros A P l n head Hin. unfold DLL.store_dll at 1. Intros h pt.
 sep_apply_l_atomic (dllseg_payload__head_view P l n h head head pt Hin).
 cancel (P (getPtr n) (getData n)). apply_sepcon_adjoint.
 sep_apply_l_atomic (derivable1_wand_elim1 (P (getPtr n) (getData n)) (DLL.dllseg P h head head pt l)).
 unfold DLL.store_dll. Exists h pt. split_pure_spatial; [sepcon_right_assoc; cancel|dump_pre_spatial; tauto].
Qed.
Lemma pending_borrow__head_view : forall sg st sem nodes,
 mutex_pending_nodes sem st nodes ->
 os_inv sg st |-- DLL.store_dll (pure_suspend_sched_link st.(os_tasks).(task_desc_map)) (mutex_pending_head sem) nodes **
 (DLL.store_dll (pure_suspend_sched_link st.(os_tasks).(task_desc_map)) (mutex_pending_head sem) nodes -* os_inv sg st).
Proof.
 intros sg st sem nodes [obj [Hin [Haddr Hnodes]]].
 unfold os_inv at 1. Intros.
 unfold mutex_inv at 1. Intros.
 sep_apply_l_atomic (dll_payload__head_view (store_mutex (pure_suspend_sched_link st.(os_tasks).(task_desc_map))) (map mutex_link_node st.(os_mutexes)) (mutex_link_node obj) sg.(os_mutex_stable).(mutex_list_head) (in_map mutex_link_node _ _ Hin)).
 cbn [mutex_link_node getPtr getData].
 unfold store_mutex at 1. Intros.
 change (map mutex_wait_node (mutex_pending_addrs obj)) with (map sched_link_node (mutex_pending_addrs obj)).
 rewrite Hnodes, Haddr.
 change (&(sem # "Mutex" ->ₛ "pend_list")) with (mutex_pending_head sem).
 cancel (DLL.store_dll (pure_suspend_sched_link st.(os_tasks).(task_desc_map)) (mutex_pending_head sem) nodes).
 apply_sepcon_adjoint.
 unfold os_inv, mutex_inv. split_pure_spatial.
 - sepcon_right_assoc. sep_apply_r_atomic (derivable1_wand_elim1 (store_mutex (pure_suspend_sched_link st.(os_tasks).(task_desc_map)) (&(sem # "Mutex" ->ₛ "link")) obj) (DLL.store_dll (store_mutex (pure_suspend_sched_link st.(os_tasks).(task_desc_map))) sg.(os_mutex_stable).(mutex_list_head) (map mutex_link_node st.(os_mutexes)))).
   cancel (store_mutex (pure_suspend_sched_link st.(os_tasks).(task_desc_map)) (&(sem # "Mutex" ->ₛ "link")) obj -* DLL.store_dll (store_mutex (pure_suspend_sched_link st.(os_tasks).(task_desc_map))) sg.(os_mutex_stable).(mutex_list_head) (map mutex_link_node st.(os_mutexes))).
   unfold store_mutex. rewrite Haddr. change (map mutex_wait_node (mutex_pending_addrs obj)) with (map sched_link_node (mutex_pending_addrs obj)). rewrite Hnodes.
   unfold mutex_pending_head. split_pure_spatial; [sepcon_right_assoc; cancel|dump_pre_spatial; rewrite <- Haddr; tauto].
 - split_pures; dump_pre_spatial; tauto.
Qed.
Lemma pending_desc__head_view : forall sg st sem target rest,
 mutex_pending_nodes sem st (sched_link_node target :: rest) ->
 os_inv sg st |-- “ exists desc, task_desc_map (os_tasks st) target = Some desc /\ tsmStat (tdSchedMember desc) = TSK_SUSPEND ”.
Proof.
 intros sg st sem target rest Hpending.
 sep_apply_l_atomic (pending_borrow__head_view sg st sem (sched_link_node target :: rest) Hpending).
 unfold DLL.store_dll at 1. Intros h pt.
 cbn [DLL.dllseg sched_link_node getPtr getData]. Intros z. subst h.
 unfold pure_suspend_sched_link, pure_published_slink. Intros desc.
 dump_pre_spatial. exists desc. tauto.
Qed.
Lemma task_alignment__head_view : forall sg st task desc,
 task_desc_map (os_tasks st) task = Some desc ->
 os_inv sg st |-- “ addr_aligned task ALIGN_SIZE ”.
Proof.
 intros sg st task desc Hlookup. unfold os_inv, task_inv. Intros.
 dump_pre_spatial. eapply task_wf_aligned; eauto.
Qed.
Lemma lookup_new__exstatus_update : forall T target desc value task old,
  T target = Some desc -> T task = Some old ->
  exists new, update_task_desc_map target (set_task_desc_exstatus desc value) T task = Some new /\
    new.(tdSchedMember) = old.(tdSchedMember) /\
    new.(tdBaseInfo) = old.(tdBaseInfo) /\ new.(tdDelay) = old.(tdDelay).
Proof.
  intros T target desc value task old Htarget Htask.
  unfold update_task_desc_map. destruct (Z.eq_dec task target) as [E|E].
  - subst task. rewrite Htarget in Htask. inversion Htask; subst old.
    exists (set_task_desc_exstatus desc value). repeat split; reflexivity.
  - exists old. repeat split; auto.
Qed.
Lemma lookup_old__exstatus_update : forall T target desc value task new,
  T target = Some desc ->
  update_task_desc_map target (set_task_desc_exstatus desc value) T task = Some new ->
  exists old, T task = Some old /\ new.(tdSchedMember) = old.(tdSchedMember) /\
    new.(tdBaseInfo) = old.(tdBaseInfo) /\ new.(tdDelay) = old.(tdDelay).
Proof.
  intros T target desc value task new Htarget Htask.
  unfold update_task_desc_map in Htask. destruct (Z.eq_dec task target) as [E|E].
  - subst task. inversion Htask; subst new. exists desc. repeat split; auto.
  - exists new. repeat split; auto.
Qed.
Lemma task_wf_mark__exstatus_update : forall st target desc value,
  st.(os_tasks).(task_desc_map) target = Some desc -> task_world_wf st ->
  task_world_wf (replace_task_desc_map
    (update_task_desc_map target (set_task_desc_exstatus desc value) st.(os_tasks).(task_desc_map)) st).
Proof.
  intros st target desc value Htarget Hwf. constructor; simpl.
  - intros task new Hnew.
    destruct (lookup_old__exstatus_update _ _ _ _ _ _ Htarget Hnew) as [old [Hlookup Hfields]].
    eapply task_wf_map_present; eauto.
  - intros task new Hnew Hstatus.
    destruct (lookup_old__exstatus_update _ _ _ _ _ _ Htarget Hnew) as [old [Hlookup [Hs Hb]]].
    rewrite Hs in Hstatus. eapply task_wf_init_running_owned; eauto.
  - exact (task_wf_id_nodes st Hwf).
  - intros task new Hnew.
    destruct (lookup_old__exstatus_update _ _ _ _ _ _ Htarget Hnew) as [old [Hlookup [Hs [Hb Hd]]]].
    rewrite Hs, Hb. eapply task_wf_priority; eauto.
  - intros task new Hnew.
    destruct (lookup_old__exstatus_update _ _ _ _ _ _ Htarget Hnew) as [old [Hlookup Hfields]].
    eapply task_wf_aligned; eauto.
  - intros task new Hnew Hstatus.
    destruct (lookup_old__exstatus_update _ _ _ _ _ _ Htarget Hnew) as [old [Hlookup [Hs Hb]]].
    rewrite Hs in *. eapply task_wf_running_bitmap; eauto.
  - intros task new Hnew Hstatus.
    destruct (lookup_old__exstatus_update _ _ _ _ _ _ Htarget Hnew) as [old [Hlookup [Hs Hb]]].
    rewrite Hs in *. eapply task_wf_init_close_bitmap; eauto.
Qed.
Lemma service_wf_mark__exstatus_update : forall st target desc value entry slot,
  st.(os_tasks).(task_desc_map) target = Some desc -> service_slot_wf st entry slot ->
  service_slot_wf (replace_task_desc_map
    (update_task_desc_map target (set_task_desc_exstatus desc value) st.(os_tasks).(task_desc_map)) st) entry slot.
Proof.
  intros st target desc value entry slot Htarget Hwf.
  unfold service_slot_wf in *. destruct (service_phase slot); auto.
  destruct Hwf as [old Hwf]. destruct Hwf as [Hlookup Hentry Hdelay Howned Hid].
  destruct (lookup_new__exstatus_update _ _ _ value _ _ Htarget Hlookup) as [new [Hnew [Hs [Hb Hd]]]].
  exists new. constructor; simpl; auto.
  - rewrite Hb; exact Hentry.
  - rewrite Hd; exact Hdelay.
  - rewrite Hs; exact Howned.
Qed.
Lemma os_wf_mark__exstatus_update : forall sg st target desc value,
  st.(os_tasks).(task_desc_map) target = Some desc -> os_world_wf sg st ->
  os_world_wf sg (replace_task_desc_map
    (update_task_desc_map target (set_task_desc_exstatus desc value) st.(os_tasks).(task_desc_map)) st).
Proof.
  intros sg st target desc value Htarget Hwf.
  destruct Hwf as [Hcontext Hrecycler Hidle Hnodup Hdomain]. constructor; simpl; auto.
  - apply service_wf_mark__exstatus_update; auto.
  - rewrite Forall_forall in *. intros slot Hin.
    apply service_wf_mark__exstatus_update; auto.
  - intros task. change (In task (os_sched_owners st) <->
      update_task_desc_map target (set_task_desc_exstatus desc value) (task_desc_map (os_tasks st)) task <> None).
    rewrite Hdomain. unfold update_task_desc_map.
    destruct (Z.eq_dec task target); subst; [rewrite Htarget|]; intuition discriminate.
Qed.
Lemma delay_wf_mark__exstatus_update : forall T target desc value inactive active,
  T target = Some desc -> delay_world_wf T inactive active ->
  delay_world_wf (update_task_desc_map target (set_task_desc_exstatus desc value) T) inactive active.
Proof.
  intros T target desc value inactive active Htarget Hwf.
  destruct Hwf as [Hz Hi Ha Hsort Hstatus]. constructor; auto.
  - intros task new Hnew.
    destruct (lookup_old__exstatus_update _ _ _ _ _ _ Htarget Hnew) as [old [Hlookup [Hs [Hb Hd]]]].
    rewrite Hd. eapply Hz; eauto.
  - intros delay info Hinfo. destruct (Hi _ _ Hinfo) as [old [Hlookup Hd]].
    destruct (lookup_new__exstatus_update _ _ _ value _ _ Htarget Hlookup) as [new [Hnew [Hs [Hb He]]]].
    exists new. split; auto. rewrite He; auto.
  - intros node Hin. destruct (Ha _ Hin) as [old [Hlookup Hd]].
    destruct (lookup_new__exstatus_update _ _ _ value _ _ Htarget Hlookup) as [new [Hnew [Hs [Hb He]]]].
    exists new. split; auto. rewrite He; auto.
Qed.
Lemma ready_wf_mark__exstatus_update : forall T target desc value index buckets,
  T target = Some desc -> priority_ready_buckets_task_ok T index buckets ->
  priority_ready_buckets_task_ok (update_task_desc_map target (set_task_desc_exstatus desc value) T) index buckets.
Proof.
  intros T target desc value index buckets Htarget. revert index.
  induction buckets as [|bucket rest IH]; simpl; intros index H; auto.
  destruct H as [Hb Hr]. split; [|apply IH; exact Hr].
  rewrite Forall_forall in *. intros node Hin.
  specialize (Hb node Hin). unfold ready_node_at_priority_ok, ready_node_task_desc in *.
  destruct Hb as [old [[Hnonnull [Hlink Hlookup]] Hfields]].
  destruct (lookup_new__exstatus_update _ _ _ value _ _ Htarget Hlookup) as [new [Hnew [Hs [Hbase Hd]]]].
  exists new. rewrite Hs. auto.
Qed.
Lemma assign_wf_mark__exstatus_update : forall T target desc value assign,
  T target = Some desc -> assign_world_wf T assign ->
  assign_world_wf (update_task_desc_map target (set_task_desc_exstatus desc value) T) assign.
Proof.
  intros T target desc value assign Htarget [Hr [Hb Hrest]]. constructor.
  - destruct Hr as [Hz|[old Hlookup]]; [left; exact Hz|right].
    destruct (lookup_new__exstatus_update _ _ _ value _ _ Htarget Hlookup) as [new [Hnew Hfields]].
    exists new; exact Hnew.
  - split; [|exact Hrest]. apply ready_wf_mark__exstatus_update; auto.
Qed.
Lemma published_slink_mark__exstatus_update : forall T target desc value status,
  T target = Some desc ->
  pure_published_slink (update_task_desc_map target (set_task_desc_exstatus desc value) T) status =
  pure_published_slink T status.
Proof.
  intros T target desc value status Htarget.
  apply functional_extensionality; intro link.
  apply functional_extensionality; intro task.
  apply functional_extensionality; intro heap.
  apply propositional_extensionality.
  unfold pure_published_slink, exp, andp, coq_prop.
  split; intros [d [[Hlookup [Hlink Hstatus]] Hemp]].
  - destruct (lookup_old__exstatus_update _ _ _ _ _ _ Htarget Hlookup) as [old [Ho [Hs Hb]]].
    exists old. rewrite Hs in Hstatus. auto.
  - destruct (lookup_new__exstatus_update _ _ _ value _ _ Htarget Hlookup) as [new [Hn [Hs Hb]]].
    exists new. rewrite Hs. auto.
Qed.
Lemma detached_slink_mark__exstatus_update : forall T target desc value,
  T target = Some desc ->
  store_detached_sched_link (update_task_desc_map target (set_task_desc_exstatus desc value) T) =
  store_detached_sched_link T.
Proof.
  intros T target desc value Htarget.
  apply functional_extensionality; intro task.
  apply functional_extensionality; intro heap.
  apply propositional_extensionality.
  unfold store_detached_sched_link, exp, andp, coq_prop.
  split; intros [d [[Hlookup Hstatus] Hnode]].
  - destruct (lookup_old__exstatus_update _ _ _ _ _ _ Htarget Hlookup) as [old [Ho [Hs Hb]]].
    exists old. rewrite Hs in Hstatus. auto.
  - destruct (lookup_new__exstatus_update _ _ _ value _ _ Htarget Hlookup) as [new [Hn [Hs Hb]]].
    exists new. rewrite Hs. auto.
Qed.
Lemma zombie_mark__exstatus_update : forall T target desc value head q,
  T target = Some desc ->
  store_zombie_queue (update_task_desc_map target (set_task_desc_exstatus desc value) T) head q =
  store_zombie_queue T head q.
Proof.
  intros T target desc value head q Htarget. destruct q; simpl; auto.
  unfold pure_close_sched_link. rewrite (published_slink_mark__exstatus_update T target desc value TSK_CLOSE Htarget). reflexivity.
Qed.
Lemma cell_focus__exstatus_update : forall task desc value, store_published_task task desc |-- (&(task # "TaskDescriptor" ->ₛ "exstatus") # Int |-> desc.(tdExstatus)) ** ((&(task # "TaskDescriptor" ->ₛ "exstatus") # Int |-> value) -* store_published_task task (set_task_desc_exstatus desc value)).
Proof. intros. unfold store_published_task, store_task_descriptor. simpl. Intros.
cancel (&(task # "TaskDescriptor" ->ₛ "exstatus") # Int |-> desc.(tdExstatus)).
apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)).
split_pure_spatial.
- cancel. repeat match goal with |- ?P ** _ |-- _ => cancel P end. match goal with |- ?P |-- ?P => cancel P end.
- split_pures; dump_pre_spatial; tauto.
Qed.
Lemma exstatus_focus__exstatus_update : forall sg st target desc,
st.(os_tasks).(task_desc_map) target = Some desc ->
os_inv sg st |-- (&(target # "TaskDescriptor" ->ₛ "exstatus") # Int |-> desc.(tdExstatus)) **
mutex_resume_exstatus_restore sg (replace_task_desc_map (update_task_desc_map target (set_task_desc_exstatus desc (-1)) st.(os_tasks).(task_desc_map)) st) target (-1).
Proof.
intros sg st target desc Hlookup.
unfold mutex_resume_exstatus_restore, os_inv, task_inv, delay_inv, assign_inv.
cbn [replace_task_desc_map os_tasks task_desc_map task_idmanager_abs task_ptr_list sched_owned_tasks os_tick os_delays os_assign zombie_queue os_recycle os_idle os_mutexes os_events os_isr os_exstatus os_semaphores].
Intros.
pose proof (os_wf_mark__exstatus_update sg st target desc (-1) Hlookup H) as Hos.
pose proof (task_wf_mark__exstatus_update st target desc (-1) Hlookup H0) as Htask.
pose proof (assign_wf_mark__exstatus_update _ target desc (-1) _ Hlookup H1) as Hassign.
pose proof (delay_wf_mark__exstatus_update _ target desc (-1) _ _ Hlookup H2) as Hdelay.
sep_apply_l_atomic (store_map_split store_published_task target desc _ Hlookup).
sep_apply_l_atomic (cell_focus__exstatus_update target desc (-1)).
cancel (&(target # "TaskDescriptor" ->ₛ "exstatus") # Int |-> desc.(tdExstatus)).
apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)).
sep_apply_l_atomic (derivable1_wand_elim1
  (&(target # "TaskDescriptor" ->ₛ "exstatus") # Int |-> (-1))
  (store_published_task target (set_task_desc_exstatus desc (-1)))).
assert (Hnew : update_task_desc_map target (set_task_desc_exstatus desc (-1)) (task_desc_map (os_tasks st)) target = Some (set_task_desc_exstatus desc (-1))).
{ unfold update_task_desc_map. destruct (Z.eq_dec target target); congruence. }
assert (Hmiss : store_map_missing_i store_published_task (task_desc_map (os_tasks st)) target --||--
  store_map_missing_i store_published_task (update_task_desc_map target (set_task_desc_exstatus desc (-1)) (task_desc_map (os_tasks st))) target).
{ apply store_map_missing_i_equiv. intros task Hneq. unfold update_task_desc_map. destruct (Z.eq_dec task target); congruence. }
rewrite Hmiss.
sep_apply_l_atomic (store_map_merge store_published_task target (set_task_desc_exstatus desc (-1)) _ Hnew).
unfold store_owned_sched_nodes, pure_suspend_sched_link.
rewrite (detached_slink_mark__exstatus_update _ target desc (-1) Hlookup).
rewrite (published_slink_mark__exstatus_update _ target desc (-1) TSK_SUSPEND Hlookup).
rewrite (zombie_mark__exstatus_update _ target desc (-1) _ _ Hlookup).
unfold tick_inv, exstatus_inv.
cbn [replace_task_desc_map os_tasks task_desc_map task_idmanager_abs task_ptr_list sched_owned_tasks os_tick os_delays os_assign zombie_queue os_recycle os_idle os_mutexes os_events os_isr os_exstatus os_semaphores].
Intros.
split_pure_spatial.
- cancel; repeat match goal with |- ?P ** _ |-- _ => cancel P end;
  try match goal with |- ?P |-- ?P => cancel P end.
- split_pures; dump_pre_spatial; assumption.
Qed.
Lemma dll_focus__task_id_view : forall {A} (P : addr -> A -> Assertion) l n x px y py,
 In n l ->
 DLL.dllseg P x px y py l |--
 P (getPtr n) (getData n) ** (P (getPtr n) (getData n) -* DLL.dllseg P x px y py l).
Proof.
 intros A P l. induction l as [|a l IH]; intros n x px y py H; simpl in H; [contradiction|].
 destruct H as [<-|H].
 - cbn [DLL.dllseg]. Intros z. subst x.
   cancel (P (getPtr a) (getData a)).
   apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)).
   Exists z. split_pure_spatial; [fold (DLL.dllseg P z (getPtr a) y py l); cancel (P (getPtr a) (getData a)); cancel (DLL.dllseg P z (getPtr a) y py l); cancel| split_pures; dump_pre_spatial; auto].
 - cbn [DLL.dllseg]. Intros z. subst x.
   sep_apply_l_atomic (IH n z (getPtr a) y py H).
   cancel (P (getPtr n) (getData n)).
   apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)).
   sep_apply_l_atomic (derivable1_wand_elim2 (P (getPtr n) (getData n)) (DLL.dllseg P z (getPtr a) y py l)).
   Exists z. split_pure_spatial; [fold (DLL.dllseg P z (getPtr a) y py l); cancel (P (getPtr a) (getData a)); cancel (DLL.dllseg P z (getPtr a) y py l); cancel| split_pures; dump_pre_spatial; auto].
Qed.
Lemma bucket_focus__task_id_view : forall head nodes node,
 In node nodes ->
 IDNode.store_idbucket head nodes |--
 IDNode.store_idnode (IDNode.idnode_link node) node **
 (IDNode.store_idnode (IDNode.idnode_link node) node -* IDNode.store_idbucket head nodes).
Proof.
 intros head nodes node Hin. destruct nodes as [|a ns]; [contradiction|].
 unfold IDNode.store_idbucket, IDNode.store_idnodes, DLL.store_dll.
 Intros x y.
 sep_apply (dll_focus__task_id_view IDNode.store_idnode (IDNode.idnodes_to_dll (a::ns))
   (IDNode.idnode_to_dll node) x head head y (in_map _ _ _ Hin)).
 cbn [getPtr getData IDNode.idnode_to_dll].
 cancel (IDNode.store_idnode (IDNode.idnode_link node) node).
 apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)).
 sep_apply (derivable1_wand_elim2 (IDNode.store_idnode (IDNode.idnode_link node) node)
   (DLL.dllseg IDNode.store_idnode x head head y (IDNode.idnodes_to_dll (a::ns)))).
 Exists x y. split_pure_spatial.
 - cancel (DLL.dllseg IDNode.store_idnode x head head y (IDNode.idnodes_to_dll (a::ns))). cancel.
 - split_pures; dump_pre_spatial; auto.
Qed.
Lemma buckets_focus__task_id_view : forall ht i bs node,
 In node (List.concat bs) ->
 IDNode.store_idbucket_list ht i bs |--
 IDNode.store_idnode (IDNode.idnode_link node) node **
 (IDNode.store_idnode (IDNode.idnode_link node) node -* IDNode.store_idbucket_list ht i bs).
Proof.
 intros ht i bs. revert i. induction bs as [|b bs IH]; intros i node H.
 - contradiction.
 - simpl in H. apply in_app_iff in H. unfold IDNode.store_idbucket_list at 1; fold IDNode.store_idbucket_list.
   destruct H as [H|H].
   + sep_apply (bucket_focus__task_id_view (ht+i*sizeof("SysDoubleLinklistNode")) b node H).
     cancel (IDNode.store_idnode (IDNode.idnode_link node) node).
     apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)).
     sep_apply (derivable1_wand_elim2 (IDNode.store_idnode (IDNode.idnode_link node) node)
       (IDNode.store_idbucket (ht+i*sizeof("SysDoubleLinklistNode")) b)).
     cbn [IDNode.store_idbucket_list].
     cancel (IDNode.store_idbucket (ht+i*sizeof("SysDoubleLinklistNode")) b).
     cancel (IDNode.store_idbucket_list ht (i+1) bs).
   + sep_apply (IH (i+1) node H).
     cancel (IDNode.store_idnode (IDNode.idnode_link node) node).
     apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)).
     sep_apply (derivable1_wand_elim2 (IDNode.store_idnode (IDNode.idnode_link node) node)
       (IDNode.store_idbucket_list ht (i+1) bs)).
     cbn [IDNode.store_idbucket_list].
     cancel (IDNode.store_idbucket (ht+i*sizeof("SysDoubleLinklistNode")) b).
     cancel (IDNode.store_idbucket_list ht (i+1) bs).
Qed.
Lemma in_Znth__task_id_view : forall {A} (l:list A) a d,
 In a l -> exists i, 0<=i<Zlength l /\ Znth i l d = a.
Proof.
 intros A l. induction l as [|b l IH]; intros a d H; [contradiction|].
 destruct H as [<-|H].
 - exists 0. split; [rewrite Zlength_cons; pose proof (Zlength_nonneg l); lia|reflexivity].
 - destruct (IH a d H) as [i [Hr He]]. exists (i+1).
   split; [rewrite Zlength_cons; lia|].
   rewrite Znth_cons by lia. replace (i+1-1) with i by lia. exact He.
Qed.
Lemma bucket_pure__task_id_view : forall sm m n,
 IDNode.idbuckets_ok (idmax sm) (hoffset sm) (idlist m) (idbuckets m) ->
 In n (List.concat (idbuckets m)) ->
 0 <= idnode_id n < idmax sm /\
 IDNode.idmanager_query m (idnode_id n) = true /\
 In n (Znth (IDNode.idmanager_bucket_index sm (idnode_id n)) (idbuckets m) nil).
Proof.
 intros sm m n Hok Hin.
 destruct Hok as [Hoff [Hlen [Hids [Hnodes [Hidx Hperm]]]]].
 assert (HidIn : In (idnode_id n) (idlist m)).
 { eapply Permutation_in; [exact Hperm|]. apply in_map. exact Hin. }
 split.
 - destruct Hids as [Hb _]. apply (proj1 (Forall_forall _ _) Hb _ HidIn).
 - split.
   + unfold IDNode.idmanager_query. apply IDNode.id_in_ids_true_iff. exact HidIn.
   + apply in_concat in Hin. destruct Hin as [bucket [Hb Hn]].
     destruct (in_Znth__task_id_view _ bucket nil Hb) as [i [Hi He]].
     pose proof (IDNode.idbuckets_index_ok_Znth (hoffset sm) 0 (idbuckets m) i Hi Hidx) as Hfor.
     rewrite He in Hfor. apply (proj1 (Forall_forall _ _) Hfor) in Hn as Heq.
     unfold IDNode.idmanager_bucket_index. rewrite Heq. replace (0+i) with i by lia. rewrite He. exact Hn.
Qed.
Lemma pending_member__task_id_view : forall sg st sem t rest,
 os_world_wf sg st -> task_world_wf st ->
 mutex_pending_nodes sem st (sched_link_node t :: map sched_link_node rest) ->
 In t (task_ptr_list (os_tasks st)).
Proof.
 intros sg st sem t rest Hos Htask [obj [Hin [Haddr Hmap]]].
 apply (os_sched_owners_in_task_list sg st t Htask Hos).
 assert (Ht : In t (mutex_pending_addrs obj)).
 { assert (Hn : In (sched_link_node t) (map sched_link_node (mutex_pending_addrs obj))) by (rewrite Hmap; left; reflexivity).
   apply in_map_iff in Hn. destruct Hn as [x [He Hx]].
   apply (f_equal (@getData addr)) in He. cbn [sched_link_node getData] in He. subst x. exact Hx. }
 assert (Hs : In t (mutex_waiters (os_mutexes st))).
 { unfold mutex_waiters. apply in_concat. exists (mutex_pending_addrs obj).
   split; [apply in_map; exact Hin|exact Ht]. }
 unfold os_sched_owners. repeat rewrite in_app_iff. tauto.
Qed.
Lemma id_addr__task_id_view : forall t, &((( &(t # "TaskDescriptor" ->ₛ "id"))) # "IdNode" ->ₛ "id") = &(t # "TaskDescriptor" ->ₛ "id" .ₛ "id").
Proof. intros. csimpl. reflexivity. Qed.
Lemma node_close__task_id_view : forall node,
 idnode_addr node <> 0 ->
 (&(((idnode_addr node)) # "IdNode" ->ₛ "id") # UShort |-> idnode_id node) |--
 IDNode.store_idnode (IDNode.idnode_link node) node.
Proof. intros. unfold IDNode.store_idnode. split_pure_spatial; [cancel|split_pures; dump_pre_spatial; auto]. Qed.
Lemma resume_effect_keeps_drained_identity__drain_exit : forall before after original,
  In original (os_mutexes before) ->
  mutex_delete_live (mutex_addr original) (mutex_id original) before ->
  mutex_resume_all_effect (mutex_addr original) (mutex_pending_addrs original) before after ->
  mutex_delete_drained (mutex_addr original) (mutex_id original) after.
Proof.
  intros before after original Hin [Hp [Hid Hlive]] Heffect.
  unfold mutex_resume_all_effect in Heffect.
  destruct (mutex_pending_addrs original) as [|task tail] eqn:Hpending.
  - subst after. split; [exact Hp|]. split; [exact Hid|].
    exists original. repeat split; auto.
  - destruct Heffect as [_ [_ [ready_after [_ Hafter]]]].
    subst after. unfold mutex_delete_drained.
    split; [exact Hp|]. split; [exact Hid|].
    change (exists m,
      In m (mutex_delete_set_pending (mutex_addr original) [] (os_mutexes before)) /\ mutex_addr m = mutex_addr original /\ mutex_id m = mutex_id original /\ mutex_pending_addrs m = []).
    exists {| mutex_addr := mutex_addr original; mutex_id := mutex_id original;
      mutex_value := mutex_value original; mutex_recursive_count := mutex_recursive_count original;
      mutex_original_priority := mutex_original_priority original; mutex_holder := mutex_holder original;
      mutex_pending_addrs := [] |}.
    split.
    + unfold mutex_delete_set_pending. apply in_map_iff.
      exists original. split; [|exact Hin].
      destruct (Z.eq_dec (mutex_addr original) (mutex_addr original));
        [reflexivity|contradiction].
    + repeat split; reflexivity.
Qed.

(** 从本次具体加锁状态与真实批量效果构造受限操作的normal执行，
    经库的high-step规则保留原continuation。没有重建bind或新增safeExec前提。 *)
Lemma scoped_resume_safe_continuation__drain_exit : forall p id before locked original current X,
  Crtos_RTrans before locked ->
  mutex_delete_live p id locked ->
  In original (os_mutexes locked) -> mutex_addr original = p -> mutex_id original = id ->
  mutex_resume_all_effect p (mutex_pending_addrs original) locked current ->
  safeExec (LastSeen before) (abs_mutex_resume_all p id) X ->
  safeExec (LastSeen current) (MonadErr.ret tt) X.
Proof.
  intros p id before locked original current X Hrely Hlive Hin Haddr Hid Heffect Hsafe.
  eapply (highstependret_derive (abs_mutex_resume_all p id) (LastSeen before) tt
    (fun _ => LastSeen current)); [|exact Hsafe].
  intros states Hseen.
  exists (Crtos_RTrans current). split.
  - unfold abs_mutex_resume_all, mutex_delete_scoped_atomic.
    cbn [MonadErr.nrm].
    exists locked, current. split.
    + change (forall observed, states observed <-> Crtos_RTrans before observed) in Hseen.
      apply (proj2 (Hseen locked)). exact Hrely.
    + split; [exact Hlive|]. split.
      * cbn [abs_mutex_resume_all_locked MonadErr.nrm].
        exists original. repeat split; assumption.
      * intro observed. reflexivity.
  - unfold LastSeen.
    change (forall observed, Crtos_RTrans current observed <-> Crtos_RTrans current observed).
    intros observed; reflexivity.
Qed.
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
