From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.

Require Import Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.KEventDelete CRTOS_Verify.lib.IdModuleSpec.
From MonadLib.MonadErr Require Import MonadErrHoare.
Import DLL IDNode MonadErr.
Local Open Scope string.
Local Open Scope sac.

(** IsEmpty检查只借出当前事件的pending DLL；原样归还后恢复同一os_inv。
    wand是实际剩余资源的接口，其构造由which implies产生证明义务。 *)
Definition event_delete_pending_restore (sg : StableGlobalState) (st : VarGlobalState)
    (p : addr) (waiting : list addr) : Assertion :=
  store_dll (pure_suspend_sched_link st.(os_tasks).(task_desc_map))
    (event_pending_head p) (map event_wait_node waiting) -* os_inv sg st.

(** 删除前只读对象ID，归还同值后再把完整manager交给IdRemoveObj。 *)
Definition event_delete_id_restore (sg : StableGlobalState) (st : VarGlobalState)
    (p id : Z) : Assertion :=
  (&(p # "Event" ->ₛ "id" .ₛ "id") # UShort |-> id) -* os_inv sg st.

(** 对象已经确认排空后的剩余抽象操作：最后一次受限环境加锁完成注销，
    按较早IsEmpty检查记录的resched决定是否调度。复用冻结的注销及调度语义。 *)
Definition event_delete_finish (id p : Z) (resched : bool)
    : program (VarGlobalState -> Prop) unit :=
  MonadErr.bind
    (event_delete_atomic_cmd id p true (abs_event_unpublish_locked id p))
    (fun _ => if resched then abs_ktask_assign else MonadErr.ret tt).

(** ResumeAll的后续continuation：其返回状态还须执行注销和调度；不把
    caller最终X直接当作ResumeAll的X而遗漏后面的真实效果。 *)
Definition event_delete_resume_cont (id p : Z)
    (X : unit -> (VarGlobalState -> Prop) -> Prop)
    : unit -> (VarGlobalState -> Prop) -> Prop :=
  fun _ states => weakestpre (event_delete_finish id p true) X states.

From Coq Require Import Classes.RelationClasses Classes.Morphisms micromega.Lia.
Lemma event_finish_commit__retire_success : forall id p r ready locked X,
 event_delete_gap id p true ready locked ->
 event_pending_at id p nil locked ->
 monadesafe_lib.safeExec (LastSeen ready) (event_delete_finish id p r) X ->
 monadesafe_lib.safeExec (LastSeen (replace_events (event_unpublish p (os_events locked)) locked))
 (if r then abs_ktask_assign else ret tt) X.
Proof.
 intros id p r ready locked X [Hgap Hguard] Hpending H.
 destruct H as [states [Hstates Hwp]].
 unfold monadesafe_lib.safe in Hwp. unfold event_delete_finish in Hwp.
 apply (proj1 (wp_bind _ _ _ states)) in Hwp.
 exists (Crtos_RTrans (replace_events (event_unpublish p (os_events locked)) locked)).
 split; [change (forall s, Crtos_RTrans (replace_events (event_unpublish p (os_events locked)) locked) s <-> Crtos_RTrans (replace_events (event_unpublish p (os_events locked)) locked) s); intro s; split; trivial|].
 unfold monadesafe_lib.safe. apply (proj2 Hwp tt).
 cbn [event_delete_atomic_cmd nrm].
 exists locked, (replace_events (event_unpublish p (os_events locked)) locked).
 split.
 - apply (proj2 (Hstates locked)). exact Hgap.
 - split; [exact Hguard|]. split.
   + split; [exact Hpending|reflexivity].
   + change (forall s, Crtos_RTrans (replace_events (event_unpublish p (os_events locked)) locked) s <-> Crtos_RTrans (replace_events (event_unpublish p (os_events locked)) locked) s); intro s; split; trivial.
Qed.
Lemma key_unique__retire_success : forall (A B:Type) (f:A->B) l x y,
 NoDup (map f l) -> In x l -> In y l -> f x = f y -> x = y.
Proof.
 intros A B f l; induction l as [|a l IH]; intros x y Hnd Hx Hy Heq; simpl in *; [contradiction|].
 inversion Hnd as [|? ? Hnot Htail]; subst.
 destruct Hx as [<-|Hx]; destruct Hy as [<-|Hy]; auto.
 - exfalso; apply Hnot. rewrite Heq. apply in_map; exact Hy.
 - exfalso; apply Hnot. rewrite <- Heq. apply in_map; exact Hx.
Qed.
Lemma nth_bucket_member__retire_success : forall A (ls:list (list A)) n x,
 In x (nth n ls nil) -> exists l, In l ls /\ In x l.
Proof.
 intros A ls; induction ls as [|l ls IH]; intros [|n] x H; simpl in *; try contradiction.
 - exists l; auto.
 - destruct (IH n x H) as [l' [Hi Hx]]. exists l'; auto.
Qed.
Lemma event_contains_unique_target__retire_success : forall sm es id node e,
 NoDup (map event_id es) -> In e es -> event_id e = id ->
 idmanager_contains sm (event_manager es) id node ->
 node = idnode_addr (event_idnode e).
Proof.
 intros sm es id node e Hnd He Hid Hcontains.
 unfold idmanager_contains, event_manager in Hcontains; cbn [idbuckets] in Hcontains.
 unfold ListLib.Base.Positional.Znth in Hcontains.
 apply nth_bucket_member__retire_success in Hcontains.
 destruct Hcontains as [bucket [Hbucket Hnode]].
 apply in_map_iff in Hbucket. destruct Hbucket as [i [<- Hi]].
 apply in_map_iff in Hnode. destruct Hnode as [e' [He' Hin]].
 apply filter_In in Hin. destruct Hin as [Hin Hfilter].
 assert (Heid : event_id e' = id) by (inversion He'; reflexivity).
 assert (E : e' = e) by (eapply key_unique__retire_success; eauto; congruence).
 subst e'. inversion He'. reflexivity.
Qed.

Lemma event_filter_absent__retire_success : forall es p,
 ~ In p (map event_addr es) -> event_unpublish p es = es.
Proof.
 intros es; induction es as [|e es IH]; intros p H; simpl; [reflexivity|].
 unfold event_unpublish in *. simpl.
 assert (Hne : event_addr e <> p) by (intro E; apply H; simpl; auto).
 apply Z.eqb_neq in Hne. rewrite Hne. simpl. f_equal.
 apply IH. intro Hin. apply H. simpl; auto.
Qed.
Lemma event_unpublish_split__retire_success : forall pre e suf,
 NoDup (map event_addr (List.app pre (e :: suf))) ->
 event_unpublish (event_addr e) (List.app pre (e :: suf)) = (List.app pre suf).
Proof.
 intros pre e suf Hnd.
 rewrite map_app in Hnd; simpl in Hnd.
 pose proof (NoDup_remove_2 _ _ _ Hnd) as Hnot.
 assert (Hp : ~ In (event_addr e) (map event_addr pre)) by (intro H; apply Hnot; apply in_or_app; auto).
 assert (Hs : ~ In (event_addr e) (map event_addr suf)) by (intro H; apply Hnot; apply in_or_app; auto).
 unfold event_unpublish at 1. rewrite filter_app. simpl. rewrite Z.eqb_refl. simpl.
 change (List.app (event_unpublish (event_addr e) pre) (event_unpublish (event_addr e) suf) = (List.app pre suf)).
 rewrite !event_filter_absent__retire_success by assumption. reflexivity.
Qed.
Lemma event_replace_world__retire_success : forall sg st es,
 event_waiters es = event_waiters (os_events st) ->
 os_world_wf sg st -> os_world_wf sg (replace_events es st).
Proof.
 intros sg st es E H.
 destruct H as [Hcontext Hrecycler Hidle Hnodup Hdomain].
 constructor; cbn [replace_events]; try assumption.
 - unfold service_slot_wf in *; simpl.
   destruct (service_phase (os_recycle st)); try assumption.
   destruct Hrecycler as [d Hd]. exists d. destruct Hd; constructor; assumption.
 - simpl. eapply List.Forall_impl; [|eassumption].
   intros x Hx. unfold service_slot_wf in *.
   destruct (service_phase x); try assumption.
   destruct Hx as [d Hd]. exists d. destruct Hd; constructor; assumption.
 - unfold os_sched_owners in *. unfold replace_events; simpl. rewrite E. exact Hnodup.
 - unfold os_sched_owners in *. unfold replace_events; simpl. rewrite E. exact Hdomain.
Qed.


Lemma event_restore_frame__retire_success : forall sg st es,
 event_waiters es = event_waiters (os_events st) ->
 event_create_frame sg st **
 store_idmanager (event_manager_stable (os_event_stable sg)) (event_manager es) (&("k_event_id_manager")) **
 store_dll (store_event (pure_suspend_sched_link (task_desc_map (os_tasks st))))
   (event_list_head (os_event_stable sg)) (map event_link_node es)
 |-- os_inv sg (replace_events es st).
Proof.
 intros sg st es E.
 unfold event_create_frame, task_inv. Intros_p Hw. Intros_p Htask.
 pose proof (event_replace_world__retire_success sg st es E Hw) as Hw'.
 pose proof (proj1 (os_wf_context _ _ Hw)) as Hctx.
 assert (Ht : task_world_wf (replace_events es st)) by (destruct Htask; constructor; assumption).
 unfold os_inv, CRTOS_Verify.lib.EventInv.event_inv, task_inv.
 
 change (tick_inv sg (replace_events es st)) with (tick_inv sg st).
 change (delay_inv sg (replace_events es st)) with (delay_inv sg st).
 change (assign_inv sg (replace_events es st)) with (assign_inv sg st).
 change (exstatus_inv sg (replace_events es st)) with (exstatus_inv sg st).
 unfold replace_events; simpl.
 rewrite (proj1 Hctx).
 split_pure_spatial.
 - repeat progress cancel.
 - split_pures; dump_pre_spatial; assumption.
Qed.



Lemma event_retired_pack__retire_success : forall wait e p node,
 event_addr e = p -> event_pending_addrs e = nil ->
 node = &(p # "Event" ->ₛ "id") ->
 node <> 0 -> &(node # "IdNode" ->ₛ "link") <> 0 ->
 store_event wait &(p # "Event" ->ₛ "link") e **
 store_node_self_linked &(p # "Event" ->ₛ "link") **
 &(node # "IdNode" ->ₛ "id") # UShort |-> 65535 **
 &(node # "IdNode" ->ₛ "link" .ₛ "node_prev") # Ptr |-> &(node # "IdNode" ->ₛ "link") **
 &(node # "IdNode" ->ₛ "link" .ₛ "node_next") # Ptr |-> &(node # "IdNode" ->ₛ "link")
 |-- EventRetired p (event_options e) (event_events e).
Proof.
 intros wait e p node Ep En Eno Hnode Hidlink.
 unfold store_event. rewrite Ep, En. Intros_p He.
 destruct He as [Hp [Ha [Hlink [Hopt Hevt]]]].
 prop_apply_p (valid_store_uint (&(p # "Event" ->ₛ "options")) (event_options e)).
 Intros_p Hv.
 pose proof (event_byte_layout__zero_layout p Ha) as Hlayout.
 destruct Hlayout as [Hi [Hiv [Hil [Ho [Hev [Hpend [Hml Hnodes]]]]]]].
 assert (Hmnonzero : &(p # "Event" ->ₛ "link") <> 0).
 { rewrite Hml. rewrite Ho in Hv. unfold isvalidptr_int in Hv. lia. }
 unfold EventRetired, store_idnode, store_node_self_linked.
 cbn [idnode_addr idnode_id idnode_link].
 unfold store_dll. Intros h pt. cbn [map dllseg]. Intros.
 assert (F : &(p # "Event" ->ₛ "id" .ₛ "link") = &(node # "IdNode" ->ₛ "link")).
 { rewrite Eno. simpl. rewrite addr_of_arrow_field, eval_addr. reflexivity. }
 rewrite F, <- Eno, !idnode_link_node_prev_addr, !idnode_link_node_next_addr.
 unfold idnode_link; simpl.
 destruct H0 as [-> <-].
 split_pure_spatial.
 - repeat progress cancel.
 - split_pures; dump_pre_spatial; intuition congruence.
Qed.
