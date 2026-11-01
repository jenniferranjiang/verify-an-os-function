From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.
From Coq Require Import Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.KSemaphoreDelete.
Local Open Scope string.
Local Open Scope sac.

(** 借出等待哨兵 next 槽后的空间归还条件。调用者还回读出的原值时，
    恢复同一状态的 os_inv；此 wand 本身不重复拥有该槽。 *)
Definition resume_next_restore (sg : StableGlobalState) (st : VarGlobalState)
    (head next : addr) : Assertion :=
  (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next) -* os_inv sg st.

(** 借出 exstatus 写槽后的归还条件；st 是写入后应重建的状态，value 是
    写入后的值。构造这个 wand 的 VC 必须证明所有 task-map 关联重索引。 *)
Definition resume_exstatus_restore (sg : StableGlobalState) (st : VarGlobalState)
    (task value : Z) : Assertion :=
  (&(task # "TaskDescriptor" ->ₛ "exstatus") # Int |-> value) -* os_inv sg st.

(** ID 只读槽的归还条件。先读取调用参数再交回该槽，避免在调用 Wakeup
    时同时声称完整 os_inv 与独立 ID 字段的重复所有权。 *)
Definition resume_id_restore (sg : StableGlobalState) (st : VarGlobalState)
    (task id : Z) : Assertion :=
  (&(task # "TaskDescriptor" ->ₛ "id" .ₛ "id") # UShort |-> id) -* os_inv sg st.

(** 剩余队列的完成条件：从当前状态完成 remaining 的任意合法逐步唤醒，
    均应得到原 waiting 相对 before 的整体效果。仅封装原循环不变量中的
    高阶量化语句，不增加前提或改变函数输出关系。 *)
Definition resume_remaining_effect (p : addr) (waiting : list addr)
    (before : VarGlobalState) (remaining : list addr) (current : VarGlobalState) : Prop :=
  forall final,
    semaphore_resume_all_steps p remaining current final ->
    semaphore_resume_all_effect p waiting before final.


From Coq Require Import FunctionalExtensionality.
From Coq Require Import Strings.String.
From Coq Require Import Classical.
From Coq Require Import Logic.FunctionalExtensionality Logic.PropExtensionality.
From Coq Require Import Sorting.Permutation micromega.Lia.
Lemma step_task_map__steps_effect : forall p task tail before after,
 semaphore_resume_one p task tail before after ->
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
 destruct Hwake as [Hframe _].
 pose proof (pending_wakeup_task_map _ _ _ _ Hframe) as Hmap.
 cbn in Hmap. rewrite Hmap.
 apply functional_extensionality. intro x.
 unfold update_task_desc_map. destruct (Z.eq_dec x task); reflexivity.
Qed.
Lemma steps_task_facts__steps_effect : forall p waiting before after,
 semaphore_resume_all_steps p waiting before after ->
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
   destruct (step_task_map__steps_effect _ _ _ _ _ Hstep)
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
Lemma rest_transfer__steps_effect : forall (T U : Z -> option TaskDescriptorAbs),
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
Lemma rrr_transfer__steps_effect : forall (T U : Z -> option TaskDescriptorAbs),
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
     exists ticks. split; [eapply rest_transfer__steps_effect; eauto|exact Hle].
   + destruct suffix as [|first suffix]; [exact I|].
     destruct Hsuf as [ticks [Hr Hgt]]. exists ticks.
     split; [eapply rest_transfer__steps_effect; eauto|exact Hgt].
 - right. auto.
Qed.
Lemma assign_transfer__steps_effect : forall T U task d e before after,
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
 eapply rrr_transfer__steps_effect; [|exact Hinsert].
 intro x. unfold update_task_desc_map.
 destruct (Z.eq_dec x task); [|apply Hrest].
 cbn. apply f_equal. apply (f_equal tsmRestTimeslice) in Hsched.
 exact Hsched.
Qed.
Lemma normalized_lookup__steps_effect : forall (T U : Z -> option TaskDescriptorAbs),
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
Lemma normalized_rest__steps_effect : forall (T U : Z -> option TaskDescriptorAbs),
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
Lemma ready_fold_transfer__steps_effect : forall waiting T U P Q,
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
   destruct (normalized_lookup__steps_effect T U Hnorm task d Hd)
     as [e [He Hsched]].
   exists b, e. split; [apply Hpq, Hb|].
   split; [exact He|].
   eapply (assign_transfer__steps_effect T U task d e b r).
   + exact (normalized_rest__steps_effect T U Hnorm).
   + exact He.
   + exact Hsched.
   + exact Hins.
Qed.
Lemma normalized_update__steps_effect : forall T task d,
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
Lemma steps_ready__steps_effect : forall p waiting before after,
 semaphore_resume_all_steps p waiting before after ->
 resume_all_ready (task_desc_map (os_tasks before)) waiting
  (assignReadyVector (os_assign before)) (assignReadyVector (os_assign after)).
Proof.
 intros p waiting. induction waiting as [|task tail IH]; intros before after Hsteps.
 - cbn in Hsteps. subst after. reflexivity.
 - destruct Hsteps as [middle [Hstep Htail]].
   pose proof (IH _ _ Htail) as Hreadytail.
   destruct (step_task_map__steps_effect _ _ _ _ _ Hstep)
     as [d [Hd [Hs Hmap]]].
   assert (Hnorm : forall x,
      option_map (fun a => set_task_desc_ready (set_task_desc_exstatus a (-1)))
        (task_desc_map (os_tasks middle) x) =
      option_map (fun a => set_task_desc_ready (set_task_desc_exstatus a (-1)))
        (task_desc_map (os_tasks before) x)).
   { rewrite Hmap. apply normalized_update__steps_effect, Hd. }
   assert (Hfirst : assign_insert_step_ic (task_desc_map (os_tasks before)) task d
       (assignReadyVector (os_assign before)) (assignReadyVector (os_assign middle))).
   { destruct Hstep as [sem [e [Hin [Ha [Hp [He [Hstat [Hframe Hsem]]]]]]]].
     rewrite Hd in He. injection He as <-.
     pose proof (pending_wakeup_ready _ _ _ _ Hframe) as Hr.
     cbn in Hr. eapply assign_transfer__steps_effect; [|exact Hd| |exact Hr].
     - intro x. unfold update_task_desc_map. destruct (Z.eq_dec x task).
       + subst x. rewrite Hd. reflexivity.
       + reflexivity.
     - reflexivity. }
   unfold resume_all_ready in *. cbn.
   eapply ready_fold_transfer__steps_effect; [exact Hnorm| |exact Hreadytail].
   intros r ->. exists (assignReadyVector (os_assign before)), d.
   split; [reflexivity|]. split; [exact Hd|exact Hfirst].
Qed.
Lemma dllseg_conflict__steps_effect : forall A (storeA : addr -> A -> Assertion)
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
Lemma dllseg_nodup__steps_effect : forall A (storeA : addr -> A -> Assertion)
 l x px y py,
 DLL.dllseg storeA x px y py l |-- “ NoDup (map (@getPtr A) l) ”.
Proof.
 intros A storeA l. induction l as [|n tail IH]; intros x px y py.
 - cbn [DLL.dllseg]. Intros. dump_pre_spatial. constructor.
 - cbn [DLL.dllseg]. Intros z. fold (@DLL.dllseg A storeA). subst x.
   prop_apply_p (IH z (getPtr n) y py).
   Intros_p Hnd.
   destruct (in_dec Z.eq_dec (getPtr n) (map (@getPtr A) tail)) as [Hin|Hnot].
   + prop_apply_p (dllseg_conflict__steps_effect A storeA tail
       z (getPtr n) y py (getPtr n) px Hin).
     Intros_p Hfalse. contradiction.
   + dump_pre_spatial. constructor; assumption.
Qed.
Lemma dll_nodup__steps_effect : forall A (storeA : addr -> A -> Assertion) head l,
 DLL.store_dll storeA head l |-- “ NoDup (map (@getPtr A) l) ”.
Proof.
 intros. unfold DLL.store_dll. Intros h pt.
 prop_apply_p (dllseg_nodup__steps_effect A storeA l h head head pt).
 Intros_p Hnd. dump_pre_spatial. exact Hnd.
Qed.
Lemma dll_conflict__steps_effect : forall A (storeA : addr -> A -> Assertion)
 l head q v,
 In q (map (@getPtr A) l) ->
 (&(q # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> v) **
 DLL.store_dll storeA head l |-- “ False ”.
Proof.
 intros. unfold DLL.store_dll. Intros h pt.
 prop_apply_p (dllseg_conflict__steps_effect A storeA l h head head pt q v H).
 Intros_p Hfalse. contradiction.
Qed.
Lemma delay_disjoint__steps_effect : forall inactive active head,
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
   prop_apply_p (dll_conflict__steps_effect TaskDelayAbs store_delay_info active head
      (&(delay # "Delay" ->ₛ "link")) (&(delay # "Delay" ->ₛ "link")) Hin).
   Intros_p Hfalse. contradiction.
Qed.
Lemma os_shapes__steps_effect : forall sg st,
 os_inv sg st |--
 “ (NoDup (map semaphore_addr (os_semaphores st)) /\
    NoDup (map (@getPtr TaskDelayAbs) (delay_active_nodes (os_delays st))) /\
    (forall delay info, delay_inactive_map (os_delays st) delay = Some info ->
      ~ In (&(delay # "Delay" ->ₛ "link"))
        (map (@getPtr TaskDelayAbs) (delay_active_nodes (os_delays st))))) ”.
Proof.
 intros sg st. unfold os_inv, semaphore_inv, delay_inv. Intros.
 prop_apply_p (dll_nodup__steps_effect SemaphoreAbs
   (store_semaphore (pure_suspend_sched_link (task_desc_map (os_tasks st))))
   (semaphore_list_head (os_semaphore_stable sg))
   (map semaphore_link_node (os_semaphores st))).
 Intros_p Hsem.
 prop_apply_p (dll_nodup__steps_effect TaskDelayAbs store_delay_info
   (delay_head_ptr sg) (delay_active_nodes (os_delays st))).
 Intros_p Hnd.
 prop_apply_p (delay_disjoint__steps_effect
   (delay_inactive_map (os_delays st)) (delay_active_nodes (os_delays st)) (delay_head_ptr sg)).
 Intros_p Hdis.
 dump_pre_spatial. split; [|auto].
 assert (Heq : map (@getPtr SemaphoreAbs) (map semaphore_link_node (os_semaphores st)) =
   map (fun p => &(p # "Semaphore" ->ₛ "link")) (map semaphore_addr (os_semaphores st))).
 { rewrite !map_map. reflexivity. }
 rewrite Heq in Hsem. now apply NoDup_map_inv in Hsem.
Qed.
Lemma ptr_unique__steps_effect : forall A (l : list (DL_Node A)),
 NoDup (map (@getPtr A) l) ->
 forall n m, In n l -> In m l -> getPtr n = getPtr m -> n = m.
Proof.
 intros A l. induction l as [|a l IH]; intros Hnd n m Hn Hm Heq; [contradiction|].
 inversion Hnd as [|? ? Hnot Htail]; subst.
 destruct Hn as [<-|Hn], Hm as [<-|Hm]; auto.
 - exfalso. apply Hnot. rewrite Heq. now apply in_map.
 - exfalso. apply Hnot. rewrite <- Heq. now apply in_map.
Qed.
Lemma find_ptr__steps_effect : forall A (l : list (DL_Node A)) n,
 NoDup (map (@getPtr A) l) -> In n l ->
 find (fun x => Z.eqb (getPtr x) (getPtr n)) l = Some n.
Proof.
 intros A l n Hnd Hin.
 destruct (find (fun x => Z.eqb (getPtr x) (getPtr n)) l) as [m|] eqn:Hfind.
 - apply find_some in Hfind as [Hm Heq].
   apply Z.eqb_eq in Heq.
   assert (m=n) by (eapply ptr_unique__steps_effect; eauto).
   now subst.
 - apply find_none with (x:=n) in Hfind; [|exact Hin].
   rewrite Z.eqb_refl in Hfind. discriminate.
Qed.
Lemma filter_all__steps_effect : forall A (f : A -> bool) l,
 (forall x, In x l -> f x = true) -> filter f l = l.
Proof.
 intros A f l. induction l as [|x l IH]; intros H; [reflexivity|].
 cbn. rewrite H by now left. f_equal. apply IH. intros y Hy. apply H. now right.
Qed.
Lemma remove_ptr_filter__steps_effect : forall A (l r : list (DL_Node A)) n,
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
 { apply filter_all__steps_effect. intros x Hx.
   apply Bool.negb_true_iff, Z.eqb_neq. intro Heq.
   apply Hnot. rewrite <- Heq. apply in_map. apply in_or_app. now left. }
 assert (Hb : filter (fun x : DL_Node A => negb (Z.eqb (getPtr x) (getPtr n))) b = b).
 { apply filter_all__steps_effect. intros x Hx.
   apply Bool.negb_true_iff, Z.eqb_neq. intro Heq.
   apply Hnot. rewrite <- Heq. apply in_map. apply in_or_app. now right. }
 now rewrite Ha, Hb.
Qed.
Lemma filter_nodup_ptr__steps_effect : forall A (f : DL_Node A -> bool) l,
 NoDup (map (@getPtr A) l) -> NoDup (map (@getPtr A) (filter f l)).
Proof.
 intros A f l. induction l as [|x l IH]; intro H; [constructor|].
 inversion H as [|? ? Hnot Htail]; subst. cbn.
 destruct (f x); [constructor|]; auto.
 intro Hin. apply in_map_iff in Hin as [y [Heq Hy]].
 apply filter_In in Hy as [Hy _]. apply Hnot. rewrite <- Heq. now apply in_map.
Qed.
Lemma unset_summary__steps_effect : forall p before after,
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
     apply filter_all__steps_effect. intros node Hnode.
     apply Bool.negb_true_iff, Z.eqb_neq. intro Heq.
     apply (Hdis p info Hlookup). rewrite <- Heq. now apply in_map.
   + split; [auto|]. split; [auto|]. intros _. rewrite Hlookup. discriminate.
 - pose proof (unset_delay_active_nodes _ _ _ _ Hrec) as Hr.
   pose proof (unset_delay_inactive_map _ _ _ _ Hrec) as Hm.
   pose proof (remove_ptr_filter__steps_effect _ _ _
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
   + rewrite Ha. now apply filter_nodup_ptr__steps_effect.
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
Lemma selected_normalized__steps_effect : forall waiting (T U : addr -> option TaskDescriptorAbs),
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
Lemma filter_selected_cons__steps_effect : forall p selected nodes,
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
Lemma steps_delays_summary__steps_effect : forall p waiting before after,
 semaphore_resume_all_steps p waiting before after ->
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
   + symmetry. apply filter_all__steps_effect. reflexivity.
   + split; [auto|]. split; [auto|]. intros x Hx. contradiction.
 - destruct Hsteps as [middle [Hone Htail]].
   destruct (step_task_map__steps_effect _ _ _ _ _ Hone) as [desc [Hdesc [Hstat Hmap]]].
   assert (Hnorm : forall x,
      option_map (fun a => set_task_desc_ready (set_task_desc_exstatus a (-1)))
        (task_desc_map (os_tasks middle) x) =
      option_map (fun a => set_task_desc_ready (set_task_desc_exstatus a (-1)))
        (task_desc_map (os_tasks before) x)).
   { rewrite Hmap. apply normalized_update__steps_effect, Hdesc. }
   destruct Hone as [sem [d [Hin [Ha [Hp [Hd [Hs [Hframe Hsem]]]]]]]].
   rewrite Hdesc in Hd. injection Hd as <-.
   destruct (pending_wakeup_delays _ _ _ _ Hframe) as [delayafter [Hun Hdelays]].
   pose proof (unset_summary__steps_effect _
      (replace_task_desc_map (update_task_desc_map task (set_task_desc_exstatus desc (-1))
        (task_desc_map (os_tasks before))) before) delayafter Hnd Hdis Hun) as Hsingle.
   cbn in Hsingle. rewrite <- Hdelays in Hsingle.
   destruct Hsingle as [Hndmid [Hdismid [Hactive [Hpres [Hnew Hpresent]]]]].
   pose proof (IH middle after Htail Hndmid Hdismid) as Hrest.
   cbn zeta in Hrest.
   rewrite (selected_normalized__steps_effect tail _ _ Hnorm) in Hrest.
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
     apply filter_selected_cons__steps_effect.
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
Lemma steps_delays__steps_effect : forall p waiting before after,
 semaphore_resume_all_steps p waiting before after ->
 NoDup (map (@getPtr TaskDelayAbs) (delay_active_nodes (os_delays before))) ->
 (forall x info, delay_inactive_map (os_delays before) x = Some info ->
   ~ In (&(x # "Delay" ->ₛ "link"))
       (map (@getPtr TaskDelayAbs) (delay_active_nodes (os_delays before)))) ->
 os_delays after = resume_all_delays (task_desc_map (os_tasks before)) waiting (os_delays before).
Proof.
 intros p waiting before after Hsteps Hnd Hdis.
 pose proof (steps_delays_summary__steps_effect _ _ _ _ Hsteps Hnd Hdis) as Hsum.
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
         (eapply ptr_unique__steps_effect; eauto; congruence).
       subst node'. exact Hvalue.
   + destruct (Hnew x) as [Heq|[_ [node [Hnode [Hptr Hvalue]]]]]; [exact Heq|].
     pose proof (find_none _ _ Hfind node Hnode) as Hfalse.
     cbn in Hfalse. rewrite Hptr, Z.eqb_refl in Hfalse. discriminate.
 - destruct (Hnew x) as [Heq|[Hin _]]; [exact Heq|contradiction].
Qed.
Lemma nodup_map_injective__steps_effect : forall A B (f : A -> B) l,
 NoDup (map f l) ->
 forall a b, In a l -> In b l -> f a = f b -> a = b.
Proof.
 intros A B f l. induction l as [|x l IH]; intros Hnd a b Ha Hb Heq; [contradiction|].
 inversion Hnd as [|? ? Hnot Htail]; subst.
 destruct Ha as [<-|Ha], Hb as [<-|Hb]; auto.
 - exfalso. apply Hnot. rewrite Heq. now apply in_map.
 - exfalso. apply Hnot. rewrite <- Heq. now apply in_map.
Qed.
Lemma semaphore_pending_addresses__steps_effect : forall p waiting sems,
 map semaphore_addr (semaphore_set_pending p waiting sems) = map semaphore_addr sems.
Proof.
 intros p waiting sems. unfold semaphore_set_pending. rewrite map_map.
 apply map_ext. intro sem. destruct (Z.eq_dec (semaphore_addr sem) p); reflexivity.
Qed.
Lemma semaphore_pending_twice__steps_effect : forall p a b sems,
 semaphore_set_pending p a (semaphore_set_pending p b sems) =
 semaphore_set_pending p a sems.
Proof.
 intros p a b sems. unfold semaphore_set_pending. rewrite map_map.
 apply map_ext. intro sem. destruct (Z.eq_dec (semaphore_addr sem) p) as [Heq|Hneq].
 - cbn. destruct (Z.eq_dec (semaphore_addr sem) p); [reflexivity|contradiction].
 - destruct (Z.eq_dec (semaphore_addr sem) p); [contradiction|reflexivity].
Qed.
Lemma step_semaphores__steps_effect : forall p task tail before after,
 NoDup (map semaphore_addr (os_semaphores before)) ->
 semaphore_resume_one p task tail before after ->
 os_semaphores after = semaphore_set_pending p tail (os_semaphores before).
Proof.
 intros p task tail before after Hnd
 [sem [desc [Hin [Haddr [Hpending [Hd [Hs [Hframe [Hmq Hsem]]]]]]]]].
 destruct Hsem as [old [rest [Hinold [HaddrOld [HpendingOld Hafter]]]]].
 cbn in Hinold, Hafter.
 assert (Heq : sem=old) by (eapply nodup_map_injective__steps_effect; eauto; congruence).
 subst old. rewrite Hpending in HpendingOld. injection HpendingOld as <-.
 exact Hafter.
Qed.
Lemma steps_semaphores__steps_effect : forall p waiting before after,
 waiting <> [] ->
 NoDup (map semaphore_addr (os_semaphores before)) ->
 semaphore_resume_all_steps p waiting before after ->
 os_semaphores after = semaphore_set_pending p [] (os_semaphores before).
Proof.
 intros p waiting. induction waiting as [|task tail IH]; intros before after Hnon Hnd Hsteps;
 [contradiction|].
 destruct Hsteps as [middle [Hone Htail]].
 pose proof (step_semaphores__steps_effect _ _ _ _ _ Hnd Hone) as Hsem.
 destruct tail as [|next rest].
 - cbn in Htail. subst after. exact Hsem.
 - rewrite (IH middle after ltac:(discriminate)).
   + rewrite Hsem. apply semaphore_pending_twice__steps_effect.
   + rewrite Hsem, semaphore_pending_addresses__steps_effect. exact Hnd.
   + exact Htail.
Qed.
Lemma steps_preserved__steps_effect : forall p waiting before after,
 semaphore_resume_all_steps p waiting before after ->
 (task_idmanager_abs (os_tasks after), task_ptr_list (os_tasks after),
 sched_owned_tasks (os_tasks after), os_tick after,
 assignRunningTask (os_assign after), assignCurrentPriority (os_assign after),
 zombie_queue after, os_recycle after, os_idle after,
 os_mutexes after, os_msgqueues after, os_events after, os_isr after, os_exstatus after) = (task_idmanager_abs (os_tasks before), task_ptr_list (os_tasks before),
 sched_owned_tasks (os_tasks before), os_tick before,
 assignRunningTask (os_assign before), assignCurrentPriority (os_assign before),
 zombie_queue before, os_recycle before, os_idle before,
 os_mutexes before, os_msgqueues before, os_events before, os_isr before, os_exstatus before).
Proof.
 intros p waiting. induction waiting as [|task tail IH]; intros before after Hsteps.
 - cbn in Hsteps. subst after. reflexivity.
 - destruct Hsteps as [middle [Hone Htail]].
   rewrite (IH _ _ Htail).
   destruct Hone as [sem [desc [Hin [Ha [Hp [Hd [Hs [Hframe [Hmq Hsem]]]]]]]]].
   destruct Hframe.
   cbn in *. repeat first [assumption | progress f_equal].
Qed.
Lemma steps_global_state__steps_effect : forall p waiting before after,
 semaphore_resume_all_steps p waiting before after ->
 after = replace_semaphores (os_semaphores after)
   (replace_global_ready_vector (assignReadyVector (os_assign after))
     (replace_global_delays (os_delays after)
       (replace_task_desc_map (task_desc_map (os_tasks after)) before))).
Proof.
 intros p waiting before after Hsteps.
 pose proof (steps_preserved__steps_effect _ _ _ _ Hsteps) as Hframe.
 destruct before as [bs bt btk bd ba bz br bi bm bmq be bisr bex].
 destruct after as [as_ ats atk ad aa az ar ai am amq ae aisr aex].
 destruct bt, ats, ba, aa. cbn in Hframe. inversion Hframe. subst. reflexivity.
Qed.
Lemma steps_to_effect__steps_effect : forall sg p waiting before,
 semaphore_pending_nodes p before (map sched_link_node waiting) ->
 os_inv sg before |-- “ (forall final,
 semaphore_resume_all_steps p waiting before final ->
 semaphore_resume_all_effect p waiting before final) ”.
Proof.
 intros sg p waiting before Hpending.
 prop_apply_p (os_shapes__steps_effect sg before).
 Intros_p Hshapes.
 destruct Hshapes as [Hsem [Hnd Hdis]].
 dump_pre_spatial. intros final Hsteps.
 destruct waiting as [|task tail].
 - exact Hsteps.
 - pose proof (steps_task_facts__steps_effect _ _ _ _ Hsteps) as [Htasks [Hsuspended Hmap]].
   cbn [semaphore_resume_all_effect]. split; [exact Htasks|].
   split; [exact Hsuspended|].
   exists (assignReadyVector (os_assign final)). split.
   + eapply steps_ready__steps_effect; exact Hsteps.
   + pose proof (steps_global_state__steps_effect _ _ _ _ Hsteps) as Hglobal.
     rewrite (steps_semaphores__steps_effect p (task::tail) before final ltac:(discriminate) Hsem Hsteps) in Hglobal.
     rewrite (steps_delays__steps_effect _ _ _ _ Hsteps Hnd Hdis) in Hglobal.
     rewrite Hmap in Hglobal. exact Hglobal.
Qed.
Lemma lookup_new__exstatus_focus : forall T target desc value task old,
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
Lemma lookup_old__exstatus_focus : forall T target desc value task new,
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
Lemma task_wf_mark__exstatus_focus : forall st target desc value,
  st.(os_tasks).(task_desc_map) target = Some desc -> task_world_wf st ->
  task_world_wf (replace_task_desc_map
    (update_task_desc_map target (set_task_desc_exstatus desc value) st.(os_tasks).(task_desc_map)) st).
Proof.
  intros st target desc value Htarget Hwf. constructor; simpl.
  - intros task new Hnew.
    destruct (lookup_old__exstatus_focus _ _ _ _ _ _ Htarget Hnew) as [old [Hlookup Hfields]].
    eapply task_wf_map_present; eauto.
  - intros task new Hnew Hstatus.
    destruct (lookup_old__exstatus_focus _ _ _ _ _ _ Htarget Hnew) as [old [Hlookup [Hs Hb]]].
    rewrite Hs in Hstatus. eapply task_wf_init_running_owned; eauto.
  - exact (task_wf_id_nodes st Hwf).
  - intros task new Hnew.
    destruct (lookup_old__exstatus_focus _ _ _ _ _ _ Htarget Hnew) as [old [Hlookup [Hs [Hb Hd]]]].
    rewrite Hs, Hb. eapply task_wf_priority; eauto.
  - intros task new Hnew.
    destruct (lookup_old__exstatus_focus _ _ _ _ _ _ Htarget Hnew) as [old [Hlookup Hfields]].
    eapply task_wf_aligned; eauto.
  - intros task new Hnew Hstatus.
    destruct (lookup_old__exstatus_focus _ _ _ _ _ _ Htarget Hnew) as [old [Hlookup [Hs Hb]]].
    rewrite Hs in *. eapply task_wf_running_bitmap; eauto.
  - intros task new Hnew Hstatus.
    destruct (lookup_old__exstatus_focus _ _ _ _ _ _ Htarget Hnew) as [old [Hlookup [Hs Hb]]].
    rewrite Hs in *. eapply task_wf_init_close_bitmap; eauto.
Qed.
Lemma service_wf_mark__exstatus_focus : forall st target desc value entry slot,
  st.(os_tasks).(task_desc_map) target = Some desc -> service_slot_wf st entry slot ->
  service_slot_wf (replace_task_desc_map
    (update_task_desc_map target (set_task_desc_exstatus desc value) st.(os_tasks).(task_desc_map)) st) entry slot.
Proof.
  intros st target desc value entry slot Htarget Hwf.
  unfold service_slot_wf in *. destruct (service_phase slot); auto.
  destruct Hwf as [old Hwf]. destruct Hwf as [Hlookup Hentry Hdelay Howned Hid].
  destruct (lookup_new__exstatus_focus _ _ _ value _ _ Htarget Hlookup) as [new [Hnew [Hs [Hb Hd]]]].
  exists new. constructor; simpl; auto.
  - rewrite Hb; exact Hentry.
  - rewrite Hd; exact Hdelay.
  - rewrite Hs; exact Howned.
Qed.
Lemma os_wf_mark__exstatus_focus : forall sg st target desc value,
  st.(os_tasks).(task_desc_map) target = Some desc -> os_world_wf sg st ->
  os_world_wf sg (replace_task_desc_map
    (update_task_desc_map target (set_task_desc_exstatus desc value) st.(os_tasks).(task_desc_map)) st).
Proof.
  intros sg st target desc value Htarget Hwf.
  destruct Hwf as [Hcontext Hrecycler Hidle Hnodup Hdomain]. constructor; simpl; auto.
  - apply service_wf_mark__exstatus_focus; auto.
  - rewrite Forall_forall in *. intros slot Hin.
    apply service_wf_mark__exstatus_focus; auto.
  - intros task. change (In task (os_sched_owners st) <->
      update_task_desc_map target (set_task_desc_exstatus desc value) (task_desc_map (os_tasks st)) task <> None).
    rewrite Hdomain. unfold update_task_desc_map.
    destruct (Z.eq_dec task target); subst; [rewrite Htarget|]; intuition discriminate.
Qed.
Lemma delay_wf_mark__exstatus_focus : forall T target desc value inactive active,
  T target = Some desc -> delay_world_wf T inactive active ->
  delay_world_wf (update_task_desc_map target (set_task_desc_exstatus desc value) T) inactive active.
Proof.
  intros T target desc value inactive active Htarget Hwf.
  destruct Hwf as [Hz Hi Ha Hsort Hstatus]. constructor; auto.
  - intros task new Hnew.
    destruct (lookup_old__exstatus_focus _ _ _ _ _ _ Htarget Hnew) as [old [Hlookup [Hs [Hb Hd]]]].
    rewrite Hd. eapply Hz; eauto.
  - intros delay info Hinfo. destruct (Hi _ _ Hinfo) as [old [Hlookup Hd]].
    destruct (lookup_new__exstatus_focus _ _ _ value _ _ Htarget Hlookup) as [new [Hnew [Hs [Hb He]]]].
    exists new. split; auto. rewrite He; auto.
  - intros node Hin. destruct (Ha _ Hin) as [old [Hlookup Hd]].
    destruct (lookup_new__exstatus_focus _ _ _ value _ _ Htarget Hlookup) as [new [Hnew [Hs [Hb He]]]].
    exists new. split; auto. rewrite He; auto.
Qed.
Lemma ready_wf_mark__exstatus_focus : forall T target desc value index buckets,
  T target = Some desc -> priority_ready_buckets_task_ok T index buckets ->
  priority_ready_buckets_task_ok (update_task_desc_map target (set_task_desc_exstatus desc value) T) index buckets.
Proof.
  intros T target desc value index buckets Htarget. revert index.
  induction buckets as [|bucket rest IH]; simpl; intros index H; auto.
  destruct H as [Hb Hr]. split; [|apply IH; exact Hr].
  rewrite Forall_forall in *. intros node Hin.
  specialize (Hb node Hin). unfold ready_node_at_priority_ok, ready_node_task_desc in *.
  destruct Hb as [old [[Hnonnull [Hlink Hlookup]] Hfields]].
  destruct (lookup_new__exstatus_focus _ _ _ value _ _ Htarget Hlookup) as [new [Hnew [Hs [Hbase Hd]]]].
  exists new. rewrite Hs. auto.
Qed.
Lemma assign_wf_mark__exstatus_focus : forall T target desc value assign,
  T target = Some desc -> assign_world_wf T assign ->
  assign_world_wf (update_task_desc_map target (set_task_desc_exstatus desc value) T) assign.
Proof.
  intros T target desc value assign Htarget [Hr [Hb Hrest]]. constructor.
  - destruct Hr as [Hz|[old Hlookup]]; [left; exact Hz|right].
    destruct (lookup_new__exstatus_focus _ _ _ value _ _ Htarget Hlookup) as [new [Hnew Hfields]].
    exists new; exact Hnew.
  - split; [|exact Hrest]. apply ready_wf_mark__exstatus_focus; auto.
Qed.
Lemma published_slink_mark__exstatus_focus : forall T target desc value status,
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
  - destruct (lookup_old__exstatus_focus _ _ _ _ _ _ Htarget Hlookup) as [old [Ho [Hs Hb]]].
    exists old. rewrite Hs in Hstatus. auto.
  - destruct (lookup_new__exstatus_focus _ _ _ value _ _ Htarget Hlookup) as [new [Hn [Hs Hb]]].
    exists new. rewrite Hs. auto.
Qed.
Lemma detached_slink_mark__exstatus_focus : forall T target desc value,
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
  - destruct (lookup_old__exstatus_focus _ _ _ _ _ _ Htarget Hlookup) as [old [Ho [Hs Hb]]].
    exists old. rewrite Hs in Hstatus. auto.
  - destruct (lookup_new__exstatus_focus _ _ _ value _ _ Htarget Hlookup) as [new [Hn [Hs Hb]]].
    exists new. rewrite Hs. auto.
Qed.
Lemma zombie_mark__exstatus_focus : forall T target desc value head q,
  T target = Some desc ->
  store_zombie_queue (update_task_desc_map target (set_task_desc_exstatus desc value) T) head q =
  store_zombie_queue T head q.
Proof.
  intros T target desc value head q Htarget. destruct q; simpl; auto.
  unfold pure_close_sched_link. rewrite (published_slink_mark__exstatus_focus T target desc value TSK_CLOSE Htarget). reflexivity.
Qed.
Lemma cell_focus__exstatus_focus : forall task desc value, store_published_task task desc |-- (&(task # "TaskDescriptor" ->ₛ "exstatus") # Int |-> desc.(tdExstatus)) ** ((&(task # "TaskDescriptor" ->ₛ "exstatus") # Int |-> value) -* store_published_task task (set_task_desc_exstatus desc value)).
Proof. intros. unfold store_published_task, store_task_descriptor. simpl. Intros.
cancel (&(task # "TaskDescriptor" ->ₛ "exstatus") # Int |-> desc.(tdExstatus)).
apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)).
split_pure_spatial.
- cancel. repeat match goal with |- ?P ** _ |-- _ => cancel P end. match goal with |- ?P |-- ?P => cancel P end.
- split_pures; dump_pre_spatial; tauto.
Qed.
Lemma exstatus_focus__exstatus_focus : forall sg st target desc,
st.(os_tasks).(task_desc_map) target = Some desc ->
os_inv sg st |-- (&(target # "TaskDescriptor" ->ₛ "exstatus") # Int |-> desc.(tdExstatus)) **
resume_exstatus_restore sg (replace_task_desc_map (update_task_desc_map target (set_task_desc_exstatus desc (-1)) st.(os_tasks).(task_desc_map)) st) target (-1).
Proof.
intros sg st target desc Hlookup.
unfold resume_exstatus_restore, os_inv, task_inv, delay_inv, assign_inv.
cbn [replace_task_desc_map os_tasks task_desc_map task_idmanager_abs task_ptr_list sched_owned_tasks os_tick os_delays os_assign zombie_queue os_recycle os_idle os_mutexes os_msgqueues os_events os_isr os_exstatus os_semaphores].
Intros.
pose proof (os_wf_mark__exstatus_focus sg st target desc (-1) Hlookup H) as Hos.
pose proof (task_wf_mark__exstatus_focus st target desc (-1) Hlookup H0) as Htask.
pose proof (assign_wf_mark__exstatus_focus _ target desc (-1) _ Hlookup H1) as Hassign.
pose proof (delay_wf_mark__exstatus_focus _ target desc (-1) _ _ Hlookup H2) as Hdelay.
sep_apply_l_atomic (store_map_split store_published_task target desc _ Hlookup).
sep_apply_l_atomic (cell_focus__exstatus_focus target desc (-1)).
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
rewrite (detached_slink_mark__exstatus_focus _ target desc (-1) Hlookup).
rewrite (published_slink_mark__exstatus_focus _ target desc (-1) TSK_SUSPEND Hlookup).
rewrite (zombie_mark__exstatus_focus _ target desc (-1) _ _ Hlookup).
unfold tick_inv, exstatus_inv.
cbn [replace_task_desc_map os_tasks task_desc_map task_idmanager_abs task_ptr_list sched_owned_tasks os_tick os_delays os_assign zombie_queue os_recycle os_idle os_mutexes os_msgqueues os_events os_isr os_exstatus os_semaphores].
Intros.
split_pure_spatial.
- cancel; repeat match goal with |- ?P ** _ |-- _ => cancel P end;
  try match goal with |- ?P |-- ?P => cancel P end.
- split_pures; dump_pre_spatial; assumption.
Qed.
Lemma dllseg_payload__pending_head : forall {A} (P:addr -> A -> Assertion) l n x px y py,
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
Lemma dll_payload__pending_head : forall {A} (P:addr -> A -> Assertion) l n head,
 In n l -> DLL.store_dll P head l |-- P (getPtr n) (getData n) ** (P (getPtr n) (getData n) -* DLL.store_dll P head l).
Proof.
 intros A P l n head Hin. unfold DLL.store_dll at 1. Intros h pt.
 sep_apply_l_atomic (dllseg_payload__pending_head P l n h head head pt Hin).
 cancel (P (getPtr n) (getData n)). apply_sepcon_adjoint.
 sep_apply_l_atomic (derivable1_wand_elim1 (P (getPtr n) (getData n)) (DLL.dllseg P h head head pt l)).
 unfold DLL.store_dll. Exists h pt. split_pure_spatial; [sepcon_right_assoc; cancel|dump_pre_spatial; tauto].
Qed.
Lemma pending_borrow__pending_head : forall sg st sem nodes,
 semaphore_pending_nodes sem st nodes ->
 os_inv sg st |-- DLL.store_dll (pure_suspend_sched_link st.(os_tasks).(task_desc_map)) (semaphore_pending_head sem) nodes **
 (DLL.store_dll (pure_suspend_sched_link st.(os_tasks).(task_desc_map)) (semaphore_pending_head sem) nodes -* os_inv sg st).
Proof.
 intros sg st sem nodes [obj [Hin [Haddr Hnodes]]].
 unfold os_inv at 1. Intros.
 unfold semaphore_inv at 1. Intros.
 sep_apply_l_atomic (dll_payload__pending_head (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map))) (map semaphore_link_node st.(os_semaphores)) (semaphore_link_node obj) sg.(os_semaphore_stable).(semaphore_list_head) (in_map semaphore_link_node _ _ Hin)).
 cbn [semaphore_link_node getPtr getData].
 unfold store_semaphore at 1. Intros.
 change (map semaphore_wait_node (semaphore_pending_addrs obj)) with (map sched_link_node (semaphore_pending_addrs obj)).
 rewrite Hnodes, Haddr.
 change (&(sem # "Semaphore" ->ₛ "pend_list")) with (semaphore_pending_head sem).
 cancel (DLL.store_dll (pure_suspend_sched_link st.(os_tasks).(task_desc_map)) (semaphore_pending_head sem) nodes).
 apply_sepcon_adjoint.
 unfold os_inv, semaphore_inv. split_pure_spatial.
 - sep_apply_r_atomic (derivable1_wand_elim1 (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map)) (&(sem # "Semaphore" ->ₛ "link")) obj) (DLL.store_dll (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map))) sg.(os_semaphore_stable).(semaphore_list_head) (map semaphore_link_node st.(os_semaphores)))).
   cancel (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map)) (&(sem # "Semaphore" ->ₛ "link")) obj -* DLL.store_dll (store_semaphore (pure_suspend_sched_link st.(os_tasks).(task_desc_map))) sg.(os_semaphore_stable).(semaphore_list_head) (map semaphore_link_node st.(os_semaphores))).
   unfold store_semaphore. rewrite Haddr. change (map semaphore_wait_node (semaphore_pending_addrs obj)) with (map sched_link_node (semaphore_pending_addrs obj)). rewrite Hnodes.
   unfold semaphore_pending_head. split_pure_spatial; [sepcon_right_assoc; cancel|dump_pre_spatial; rewrite <- Haddr; tauto].
 - split_pures; dump_pre_spatial; tauto.
Qed.
Lemma pending_desc__pending_head : forall sg st sem target rest,
 semaphore_pending_nodes sem st (sched_link_node target :: rest) ->
 os_inv sg st |-- “ exists desc, task_desc_map (os_tasks st) target = Some desc /\ tsmStat (tdSchedMember desc) = TSK_SUSPEND ”.
Proof.
 intros sg st sem target rest Hpending.
 sep_apply_l_atomic (pending_borrow__pending_head sg st sem (sched_link_node target :: rest) Hpending).
 unfold DLL.store_dll at 1. Intros h pt.
 cbn [DLL.dllseg sched_link_node getPtr getData]. Intros z. subst h.
 unfold pure_suspend_sched_link, pure_published_slink. Intros desc.
 dump_pre_spatial. exists desc. tauto.
Qed.
Lemma task_alignment__pending_head : forall sg st task desc,
 task_desc_map (os_tasks st) task = Some desc ->
 os_inv sg st |-- “ addr_aligned task ALIGN_SIZE ”.
Proof.
 intros sg st task desc Hlookup. unfold os_inv, task_inv. Intros.
 dump_pre_spatial. eapply task_wf_aligned; eauto.
Qed.
Lemma dll_focus__id_focus : forall {A} (P : addr -> A -> Assertion) l n x px y py,
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
Lemma bucket_focus__id_focus : forall head nodes node,
 In node nodes ->
 IDNode.store_idbucket head nodes |--
 IDNode.store_idnode (IDNode.idnode_link node) node **
 (IDNode.store_idnode (IDNode.idnode_link node) node -* IDNode.store_idbucket head nodes).
Proof.
 intros head nodes node Hin. destruct nodes as [|a ns]; [contradiction|].
 unfold IDNode.store_idbucket, IDNode.store_idnodes, DLL.store_dll.
 Intros x y.
 sep_apply (dll_focus__id_focus IDNode.store_idnode (IDNode.idnodes_to_dll (a::ns))
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
Lemma buckets_focus__id_focus : forall ht i bs node,
 In node (List.concat bs) ->
 IDNode.store_idbucket_list ht i bs |--
 IDNode.store_idnode (IDNode.idnode_link node) node **
 (IDNode.store_idnode (IDNode.idnode_link node) node -* IDNode.store_idbucket_list ht i bs).
Proof.
 intros ht i bs. revert i. induction bs as [|b bs IH]; intros i node H.
 - contradiction.
 - simpl in H. apply in_app_iff in H. unfold IDNode.store_idbucket_list at 1; fold IDNode.store_idbucket_list.
   destruct H as [H|H].
   + sep_apply (bucket_focus__id_focus (ht+i*sizeof("SysDoubleLinklistNode")) b node H).
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
Lemma in_Znth__id_focus : forall {A} (l:list A) a d,
 In a l -> exists i, 0<=i<Zlength l /\ Znth i l d = a.
Proof.
 intros A l. induction l as [|b l IH]; intros a d H; [contradiction|].
 destruct H as [<-|H].
 - exists 0. split; [rewrite Zlength_cons; pose proof (Zlength_nonneg l); lia|reflexivity].
 - destruct (IH a d H) as [i [Hr He]]. exists (i+1).
   split; [rewrite Zlength_cons; lia|].
   rewrite Znth_cons by lia. replace (i+1-1) with i by lia. exact He.
Qed.
Lemma bucket_pure__id_focus : forall sm m n,
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
     destruct (in_Znth__id_focus _ bucket nil Hb) as [i [Hi He]].
     pose proof (IDNode.idbuckets_index_ok_Znth (hoffset sm) 0 (idbuckets m) i Hi Hidx) as Hfor.
     rewrite He in Hfor. apply (proj1 (Forall_forall _ _) Hfor) in Hn as Heq.
     unfold IDNode.idmanager_bucket_index. rewrite Heq. replace (0+i) with i by lia. rewrite He. exact Hn.
Qed.
Lemma pending_member__id_focus : forall sg st sem t rest,
 os_world_wf sg st -> task_world_wf st ->
 semaphore_pending_nodes sem st (sched_link_node t :: map sched_link_node rest) ->
 In t (task_ptr_list (os_tasks st)).
Proof.
 intros sg st sem t rest Hos Htask [obj [Hin [Haddr Hmap]]].
 apply (os_sched_owners_in_task_list sg st t Htask Hos).
 assert (Ht : In t (semaphore_pending_addrs obj)).
 { assert (Hn : In (sched_link_node t) (map sched_link_node (semaphore_pending_addrs obj))) by (rewrite Hmap; left; reflexivity).
   apply in_map_iff in Hn. destruct Hn as [x [He Hx]].
   apply (f_equal (@getData addr)) in He. cbn [sched_link_node getData] in He. subst x. exact Hx. }
 assert (Hs : In t (semaphore_waiters (os_semaphores st))).
 { unfold semaphore_waiters. apply in_concat. exists (semaphore_pending_addrs obj).
   split; [apply in_map; exact Hin|exact Ht]. }
 unfold os_sched_owners. repeat rewrite in_app_iff. tauto.
Qed.
Lemma id_addr__id_focus : forall t, &((( &(t # "TaskDescriptor" ->ₛ "id"))) # "IdNode" ->ₛ "id") = &(t # "TaskDescriptor" ->ₛ "id" .ₛ "id").
Proof. intros. csimpl. reflexivity. Qed.
Lemma node_close__id_focus : forall node,
 idnode_addr node <> 0 ->
 (&(((idnode_addr node)) # "IdNode" ->ₛ "id") # UShort |-> idnode_id node) |--
 IDNode.store_idnode (IDNode.idnode_link node) node.
Proof. intros. unfold IDNode.store_idnode. split_pure_spatial; [cancel|split_pures; dump_pre_spatial; auto]. Qed.
