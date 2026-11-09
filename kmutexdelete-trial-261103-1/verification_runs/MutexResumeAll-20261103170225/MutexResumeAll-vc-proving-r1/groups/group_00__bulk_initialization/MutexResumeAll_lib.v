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
