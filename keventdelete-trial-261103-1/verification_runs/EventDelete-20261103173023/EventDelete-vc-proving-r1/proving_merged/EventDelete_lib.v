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


From Coq Require Import Lia.
From Coq Require Import Classes.RelationClasses Classes.Morphisms micromega.Lia.
Lemma dll_focus__id_snapshot : forall (A:Type) (storeA:addr -> A -> Assertion) (es:list (DL_Node A)) e x px y py, In e es -> dllseg storeA x px y py es |-- storeA e.(ptr) e.(data) ** (storeA e.(ptr) e.(data) -* dllseg storeA x px y py es).
Proof.
intros A storeA es.
induction es as [|a es IH]; intros e x px y py Hin.
- contradiction.
- simpl in Hin.
destruct Hin as [Heq|Hin].
+ subst a.
cbn [dllseg].
Intros z.
subst x.
cancel.
apply_sepcon_adjoint.
Exists z.
split_pure_spatial.
* cancel.
fold (dllseg storeA z e.(ptr) y py es).
cancel (storeA e.(ptr) e.(data)).
cancel (dllseg storeA z e.(ptr) y py es).
cancel.
* dump_pre_spatial.
reflexivity.
+ cbn [dllseg].
Intros z.
fold (dllseg storeA z x y py es).
sep_apply_l_atomic (IH e z x y py Hin).
cancel (storeA e.(ptr) e.(data)).
apply_sepcon_adjoint.
Exists z.
split_pure_spatial.
* sep_apply_l_atomic (derivable1_wand_elim2 (storeA e.(ptr) e.(data)) (dllseg storeA z x y py es)).
cancel.
fold (dllseg storeA z x y py es).
cancel.
* dump_pre_spatial.
assumption.
Qed.
Lemma store_dll_focus__id_snapshot : forall (A:Type) (storeA:addr -> A -> Assertion) es e head, In e es -> store_dll storeA head es |-- storeA e.(ptr) e.(data) ** (storeA e.(ptr) e.(data) -* store_dll storeA head es).
Proof.
intros A storeA es e head Hin.
unfold store_dll.
Intros h pt.
sep_apply_l_atomic (dll_focus__id_snapshot A storeA es e h head head pt Hin).
cancel (storeA e.(ptr) e.(data)).
apply_sepcon_adjoint.
sep_apply_l_atomic (derivable1_wand_elim2 (storeA e.(ptr) e.(data)) (dllseg storeA h head head pt es)).
Exists h pt.
split_pure_spatial.
- cancel.
- dump_pre_spatial.
assumption.
Qed.
Lemma idbucket_focus__id_snapshot : forall nodes node head, In node nodes -> store_idbucket head nodes |-- store_idnode (idnode_link node) node ** (store_idnode (idnode_link node) node -* store_idbucket head nodes).
Proof.
intros nodes node head Hin.
destruct nodes as [|a ns].
- contradiction.
- cbn [store_idbucket].
unfold store_idnodes, idnodes_to_dll.
apply (store_dll_focus__id_snapshot IdNodeAbs store_idnode (map idnode_to_dll (a::ns)) (idnode_to_dll node) head).
apply in_map.
assumption.
Qed.
Lemma bucketlist_focus__id_snapshot : forall bs node ht k, In node (List.concat bs) -> store_idbucket_list ht k bs |-- store_idnode (idnode_link node) node ** (store_idnode (idnode_link node) node -* store_idbucket_list ht k bs).
Proof.
induction bs as [|b bs IH]; intros node ht k Hin.
- contradiction.
- simpl in Hin.
apply in_app_or in Hin.
cbn [store_idbucket_list].
destruct Hin as [Hin|Hin].
+ match goal with |- _ |-- ?Q => set (target := Q) end.
sep_apply_l_atomic (idbucket_focus__id_snapshot b node (ht+k*sizeof("SysDoubleLinklistNode")) Hin).
unfold target.
cancel (store_idnode (idnode_link node) node).
apply_sepcon_adjoint.
sep_apply_l_atomic (derivable1_wand_elim2 (store_idnode (idnode_link node) node) (store_idbucket (ht+k*sizeof("SysDoubleLinklistNode")) b)).
cancel.
+ match goal with |- _ |-- ?Q => set (target := Q) end.
sep_apply_l_atomic (IH node ht (k+1) Hin).
unfold target.
cancel (store_idnode (idnode_link node) node).
apply_sepcon_adjoint.
sep_apply_l_atomic (derivable1_wand_elim2 (store_idnode (idnode_link node) node) (store_idbucket_list ht (k+1) bs)).
cancel.
Qed.
Lemma event_node_in__id_snapshot : forall es e, In e es -> In (event_idnode e) (List.concat (idbuckets (event_manager es))).
Proof.
intros es e Hin.
change (In (event_idnode e) (List.concat (map (fun i => map event_idnode (filter (fun a => Z.eqb (event_id a mod 16) (Z.of_nat i)) es)) (seq 0 16)))).
apply in_concat.
exists (map event_idnode (filter (fun a => Z.eqb (event_id a mod 16) (Z.of_nat (Z.to_nat (event_id e mod 16)))) es)).
split.
- apply in_map_iff.
exists (Z.to_nat (event_id e mod 16)).
split; [reflexivity|].
apply in_seq.
pose proof (Z.mod_pos_bound (event_id e) 16 ltac:(lia)).
lia.
- apply in_map.
apply filter_In.
split; auto.
rewrite Z2Nat.id by (pose proof (Z.mod_pos_bound (event_id e) 16 ltac:(lia)); lia).
apply Z.eqb_refl.
Qed.
Lemma manager_node_focus__id_snapshot : forall sidm idm p node, In node (List.concat (idbuckets idm)) -> store_idmanager sidm idm p |-- store_idnode (idnode_link node) node ** (store_idnode (idnode_link node) node -* store_idmanager sidm idm p).
Proof.
intros sidm idm p node Hin.
unfold store_idmanager, store_idbuckets.
Intros.
match goal with |- _ |-- ?Q => set (target := Q) end.
sep_apply_l_atomic (bucketlist_focus__id_snapshot (idbuckets idm) node (htable sidm) 0 Hin).
unfold target.
cancel (store_idnode (idnode_link node) node).
apply_sepcon_adjoint.
sep_apply_l_atomic (derivable1_wand_elim2 (store_idnode (idnode_link node) node) (store_idbucket_list (htable sidm) 0 (idbuckets idm))).
split_pure_spatial.
- cancel.
- dump_pre_spatial.
assumption.
Qed.
Lemma event_id_focus__id_snapshot : forall sg st e p id, In e (os_events st) -> event_addr e = p -> event_id e = id -> os_inv sg st |-- (&(p # "Event" ->ₛ "id" .ₛ "id") # UShort |-> id) ** ((&(p # "Event" ->ₛ "id" .ₛ "id") # UShort |-> id) -* os_inv sg st).
Proof.
intros sg st e p id Hin Hp Hid.
unfold os_inv, event_inv.
Intros.
match goal with |- _ |-- ?Q => set (target := Q) end.
sep_apply_l_atomic (manager_node_focus__id_snapshot (event_manager_stable (os_event_stable sg)) (event_manager (os_events st)) (event_manager_ptr (os_event_stable sg)) (event_idnode e) (event_node_in__id_snapshot (os_events st) e Hin)).
unfold target.
unfold store_idnode at 1.
cbn [event_idnode idnode_addr idnode_id].
Intros.
rewrite Hp, Hid.
csimpl.
cancel.
apply_sepcon_adjoint.
split_pure_spatial.
- cancel.
sep_apply_r_atomic (derivable1_wand_elim2 (store_idnode (idnode_link (event_idnode e)) (event_idnode e)) (store_idmanager (event_manager_stable (os_event_stable sg)) (event_manager (os_events st)) (event_manager_ptr (os_event_stable sg)))).
cancel (store_idnode (idnode_link (event_idnode e)) (event_idnode e) -* store_idmanager (event_manager_stable (os_event_stable sg)) (event_manager (os_events st)) (event_manager_ptr (os_event_stable sg))).
cancel.
unfold store_idnode.
cbn [event_idnode idnode_addr idnode_id].
rewrite Hp, Hid.
split_pure_spatial.
+ csimpl.
cancel.
+ dump_pre_spatial.
rewrite Hp in H1.
exact H1.
- split_pures; dump_pre_spatial; assumption.
Qed.
Lemma event_fresh__id_snapshot : forall wait es x px y py link e, dllseg (store_event wait) x px y py (map event_link_node es) ** store_event wait link e |-- “ ~ In (event_addr e) (map event_addr es) ”.
Proof.
intros wait es.
induction es as [|a es IH]; intros x px y py link e.
- simpl.
dump_pre_spatial.
tauto.
- cbn [map dllseg event_link_node].
Intros z.
fold (dllseg (store_event wait) z x y py (map event_link_node es)).
destruct (Z.eq_dec (event_addr a) (event_addr e)) as [Heq|Hneq].
+ unfold store_event.
Intros.
unfold store_uint.
Intros.
cbn [event_link_node getData] in *.
rewrite Heq.
match goal with |- context [store_4byte ?p (event_options a)] => prop_apply_p (dup_store_4bytes p (event_options a) (event_options e)) end.
Intros_p Hfalse.
dump_pre_spatial.
contradiction.
+ cbn [event_link_node getData].
prop_apply_p (IH z x y py link e).
Intros_p Hfresh.
dump_pre_spatial.
simpl.
intuition.
Qed.
Lemma event_addr_nodup_dll__id_snapshot : forall wait es x px y py, dllseg (store_event wait) x px y py (map event_link_node es) |-- “ NoDup (map event_addr es) ”.
Proof.
intros wait es.
induction es as [|a es IH]; intros x px y py.
- simpl.
dump_pre_spatial.
constructor.
- cbn [map dllseg event_link_node].
Intros z.
fold (dllseg (store_event wait) z x y py (map event_link_node es)).
cbn [event_link_node getData].
prop_apply_p (IH z x y py).
Intros_p Hnd.
prop_apply_p (event_fresh__id_snapshot wait es z x y py x a).
Intros_p Hfresh.
dump_pre_spatial.
constructor; assumption.
Qed.
Lemma nodup_key_injective__id_snapshot : forall (A:Type) (f:A->Z) es a b, NoDup (map f es) -> In a es -> In b es -> f a = f b -> a=b.
Proof.
intros A f es.
induction es as [|e es IH]; intros a b Hnd Ha Hb Heq.
- contradiction.
- inversion Hnd as [|? ? Hfresh Htail]; subst.
simpl in Ha,Hb.
destruct Ha as [<-|Ha]; destruct Hb as [<-|Hb]; auto.
+ exfalso.
apply Hfresh.
rewrite Heq.
apply in_map.
exact Hb.
+ exfalso.
apply Hfresh.
rewrite <- Heq.
apply in_map.
exact Ha.
Qed.
Lemma event_filter_id__id_snapshot : forall es e, NoDup (map event_addr es) -> NoDup (map event_id es) -> In e es -> event_unpublish (event_addr e) es = filter (fun a => negb (Z.eqb (event_id a) (event_id e))) es.
Proof.
intros es e Ha Hi Hin.
unfold event_unpublish.
apply filter_ext_in.
intros a Hain.
destruct (Z.eqb (event_addr a) (event_addr e)) eqn:Hae; destruct (Z.eqb (event_id a) (event_id e)) eqn:Hie; auto.
- apply Z.eqb_eq in Hae.
assert (a=e) by (exact (nodup_key_injective__id_snapshot EventAbs event_addr es a e Ha Hain Hin Hae)).
subst a.
rewrite Z.eqb_refl in Hie.
discriminate.
- apply Z.eqb_eq in Hie.
assert (a=e) by (exact (nodup_key_injective__id_snapshot EventAbs event_id es a e Hi Hain Hin Hie)).
subst a.
rewrite Z.eqb_refl in Hae.
discriminate.
Qed.
Lemma event_remove_idlist__id_snapshot : forall es id, idlist_remove id (map event_id es) = map event_id (filter (fun a => negb (Z.eqb (event_id a) id)) es).
Proof.
induction es as [|a es IH]; intros id.
- reflexivity.
- unfold idlist_remove in *.
cbn [map filter remove].
destruct (Z.eq_dec id (event_id a)) as [Heq|Hneq].
+ subst id.
rewrite Z.eqb_refl.
simpl.
apply IH.
+ assert (Hb: Z.eqb (event_id a) id = false) by (apply Z.eqb_neq; congruence).
rewrite Hb.
simpl.
f_equal.
apply IH.
Qed.
Lemma event_bucket_remove__id_snapshot : forall es id i, idnodes_remove_id id (map event_idnode (filter (fun a => Z.eqb (event_id a mod 16) i) es)) = map event_idnode (filter (fun a => Z.eqb (event_id a mod 16) i) (filter (fun a => negb (Z.eqb (event_id a) id)) es)).
Proof.
induction es as [|a es IH]; intros id i; [reflexivity|].
cbn [filter].
destruct (Z.eqb (event_id a mod 16) i) eqn:Hb; destruct (Z.eqb (event_id a) id) eqn:Hd; cbn [filter map idnodes_remove_id event_idnode idnode_id]; rewrite ?Hb; cbn [map].
- apply Z.eqb_eq in Hd.
destruct (Z.eq_dec (event_id a) id); [apply IH|congruence].
- apply Z.eqb_neq in Hd.
destruct (Z.eq_dec (event_id a) id); [congruence|].
f_equal.
cbn [negb filter].
rewrite Hb.
cbn [map].
f_equal.
apply IH.
- cbn [negb].
apply IH.
- cbn [negb filter].
rewrite Hb.
apply IH.
Qed.
Lemma event_bucket_other__id_snapshot : forall es id i, id mod 16 <> i -> map event_idnode (filter (fun a => Z.eqb (event_id a mod 16) i) (filter (fun a => negb (Z.eqb (event_id a) id)) es)) = map event_idnode (filter (fun a => Z.eqb (event_id a mod 16) i) es).
Proof.
induction es as [|a es IH]; intros id i Hneq; [reflexivity|].
cbn [filter].
destruct (Z.eqb (event_id a) id) eqn:Hd.
- apply Z.eqb_eq in Hd.
rewrite Hd.
assert (Hb:Z.eqb (id mod 16) i=false) by (apply Z.eqb_neq; auto).
rewrite Hb.
simpl.
apply IH.
exact Hneq.
- cbn [negb filter].
destruct (Z.eqb (event_id a mod 16) i); cbn [map]; rewrite IH by assumption; reflexivity.
Qed.
Lemma Znth_map_seq__id_snapshot : forall (A:Type) (f:nat->A) n i d, 0 <= i < Z.of_nat n -> Znth i (map f (seq 0 n)) d = f (Z.to_nat i).
Proof.
intros A f n i d Hi.
unfold Znth.
rewrite nth_indep with (d':=f 0%nat).
- rewrite map_nth, seq_nth by lia.
reflexivity.
- rewrite map_length, seq_length.
lia.
Qed.
Lemma list_Znth_ext__id_snapshot : forall (A:Type) (l r:list A) d, Zlength l = Zlength r -> (forall i, 0<=i<Zlength l -> Znth i l d = Znth i r d) -> l=r.
Proof.
intros A l r d Hlen Hnth.
apply (@nth_ext A l r d d).
- rewrite !Zlength_correct in Hlen.
lia.
- intros n Hn.
specialize (Hnth (Z.of_nat n)).
unfold Znth in Hnth.
rewrite Nat2Z.id in Hnth.
apply Hnth.
rewrite Zlength_correct.
lia.
Qed.
Lemma event_buckets_remove__id_snapshot : forall es id, idmanager_remove_bucket 16 id (idbuckets (event_manager es)) = idbuckets (event_manager (filter (fun a => negb (Z.eqb (event_id a) id)) es)).
Proof.
intros es id.
unfold idmanager_remove_bucket.
pose proof (Z.mod_pos_bound id 16 ltac:(lia)) as Hrange.
assert (Hlen: forall xs, Zlength (idbuckets (event_manager xs)) = 16).
{ intros xs.
change (Zlength (map (fun i => map event_idnode (filter (fun a => Z.eqb (event_id a mod 16) (Z.of_nat i)) xs)) (seq 0 16))=16).
rewrite Zlength_correct, map_length, seq_length.
reflexivity.
} apply (list_Znth_ext__id_snapshot (list IdNodeAbs) _ _ nil).
- rewrite Zlength_replace_Znth, !Hlen.
reflexivity.
- intros i Hi.
rewrite Zlength_replace_Znth, Hlen in Hi.
destruct (Z.eq_dec i (id mod 16)) as [Heq|Hneq].
+ subst i.
rewrite Znth_replace_Znth_Same by (rewrite Hlen; exact Hrange).
change (idnodes_remove_id id (Znth (id mod 16) (map (fun j => map event_idnode (filter (fun a => Z.eqb (event_id a mod 16) (Z.of_nat j)) es)) (seq 0 16)) nil) = Znth (id mod 16) (map (fun j => map event_idnode (filter (fun a => Z.eqb (event_id a mod 16) (Z.of_nat j)) (filter (fun a => negb (Z.eqb (event_id a) id)) es))) (seq 0 16)) nil).
rewrite !Znth_map_seq__id_snapshot by (simpl; lia).
apply event_bucket_remove__id_snapshot.
+ rewrite Znth_replace_Znth_Diff by (rewrite ?Hlen; lia).
change (Znth i (map (fun j => map event_idnode (filter (fun a => Z.eqb (event_id a mod 16) (Z.of_nat j)) es)) (seq 0 16)) nil = Znth i (map (fun j => map event_idnode (filter (fun a => Z.eqb (event_id a mod 16) (Z.of_nat j)) (filter (fun a => negb (Z.eqb (event_id a) id)) es))) (seq 0 16)) nil).
rewrite !Znth_map_seq__id_snapshot by (simpl; lia).
symmetry.
apply event_bucket_other__id_snapshot.
rewrite Z2Nat.id by lia.
congruence.
Qed.
Lemma event_manager_remove__id_snapshot : forall sidm es e, hoffset sidm=16 -> NoDup (map event_addr es) -> NoDup (map event_id es) -> In e es -> idmanager_remove sidm (event_manager es) (event_id e) = event_manager (event_unpublish (event_addr e) es).
Proof.
intros sidm es e Hoff Ha Hi Hin.
rewrite (event_filter_id__id_snapshot es e Ha Hi Hin).
unfold idmanager_remove.
rewrite Hoff.
rewrite event_buckets_remove__id_snapshot.
change (Build_VarIdmanager (idlist_remove (event_id e) (map event_id es)) (idbuckets (event_manager (filter (fun a => negb (Z.eqb (event_id a) (event_id e))) es))) = event_manager (filter (fun a => negb (Z.eqb (event_id a) (event_id e))) es)).
rewrite event_remove_idlist__id_snapshot.
reflexivity.
Qed.
Lemma event_dll_nodup__id_snapshot : forall wait head es, store_dll (store_event wait) head (map event_link_node es) |-- “ NoDup (map event_addr es) ”.
Proof.
intros wait head es.
unfold store_dll.
Intros h pt.
prop_apply_p (event_addr_nodup_dll__id_snapshot wait es h head head pt).
Intros_p Hnd.
dump_pre_spatial.
exact Hnd.
Qed.
Lemma event_sequence_facts__id_snapshot : forall sg st e, In e (os_events st) -> os_inv sg st |-- “ NoDup (map event_addr (os_events st)) /\ NoDup (map event_id (os_events st)) /\ 0 <= event_id e < 128 /\ idmanager_query (event_manager (os_events st)) (event_id e)=true /\ idmanager_remove (event_manager_stable (os_event_stable sg)) (event_manager (os_events st)) (event_id e) = event_manager (event_unpublish (event_addr e) (os_events st)) ”.
Proof.
intros sg st e Hin.
unfold os_inv, event_inv, store_idmanager.
Intros.
Timeout 30 prop_apply_p (event_dll_nodup__id_snapshot (pure_suspend_sched_link (task_desc_map (os_tasks st))) (event_list_head (os_event_stable sg)) (os_events st)).
Intros_p Haddr.
dump_pre_spatial.
unfold event_context in H0.
destruct H0 as [_ [Hmax [Hoff _]]].
unfold idbuckets_ok in H1.
destruct H1 as [_ [_ [Hids _]]].
unfold idlist_ok in Hids.
destruct Hids as [Hbounds Hids].
change (NoDup (map event_id (os_events st))) in Hids.
assert (HidIn: In (event_id e) (map event_id (os_events st))) by (apply in_map; exact Hin).
split; [exact Haddr|].
split; [exact Hids|].
split.
- rewrite Forall_forall in Hbounds.
specialize (Hbounds (event_id e) HidIn).
rewrite Hmax in Hbounds.
exact Hbounds.
- split.
+ apply id_in_ids_true_iff.
exact HidIn.
+ apply event_manager_remove__id_snapshot; assumption.
Qed.
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
Lemma event_inspection_residual__inspect_continuations :
  forall id p before checked waiting X,
  event_delete_gap id p false before checked ->
  event_pending_at id p waiting checked ->
  monadesafe_lib.safeExec (LastSeen before) (abs_event_delete_at id p) X ->
  weakestpre
    (MonadErr.bind
      (if negb (Nat.eqb (List.length waiting) 0)
       then abs_event_resume_all id p else MonadErr.ret tt)
      (fun _ => event_delete_finish id p
        (negb (Nat.eqb (List.length waiting) 0)))) X
    (Crtos_RTrans checked).
Proof.
  intros id p before checked waiting X [Hrely Hguard] Hpending Hsafe.
  destruct Hsafe as [states [Hseen Hwp]].
  unfold monadesafe_lib.safe in Hwp.
  unfold abs_event_delete_at in Hwp.
  apply wp_bind in Hwp.
  destruct Hwp as [_ Hpost].
  apply (Hpost (negb (Nat.eqb (List.length waiting) 0))
    (Crtos_RTrans checked)).
  cbn [event_delete_atomic_cmd nrm].
  exists checked, checked.
  split.
  - apply (proj2 (Hseen checked)); exact Hrely.
  - split; [exact Hguard |].
    split.
    + cbn [abs_event_pending_nonempty_locked nrm].
      split; [reflexivity |]. exists waiting; auto.
    + change (forall st, Crtos_RTrans checked st <-> Crtos_RTrans checked st).
      tauto.
Qed.
Lemma event_retired_forget__reclaim : forall p options events,
  EventRetired p options events |-- EventRaw p.
Proof.
  intros p options events.
  unfold EventRetired, EventRaw, store_idnode, store_idnode_insert_ready,
    store_node_self_linked, NodeStorage, EventPadding.
  simpl idnode_addr; simpl idnode_id.
  Intros.
  set (idp := (&(p # "Event" ->ₛ "id") : addr)) in *.
  set (ilink := (&(p # "Event" ->ₛ "id" .ₛ "link") : addr)) in *.
  set (pend := (&(p # "Event" ->ₛ "pend_list") : addr)) in *.
  set (link := (&(p # "Event" ->ₛ "link") : addr)) in *.
  destruct H0 as [Hid Hlink].
  change (ilink = &(idp # "IdNode" ->ₛ "link")) in Hlink.
  rewrite idnode_link_node_prev_addr, idnode_link_node_next_addr.
  rewrite <- Hlink.
  sep_apply_l_atomic (store_ushort_undef_store_ushort (&(idp # "IdNode" ->ₛ "id")) 65535).
  sep_apply_l_atomic (store_uint_undef_store_uint (&(p # "Event" ->ₛ "options")) options).
  sep_apply_l_atomic (store_uint_undef_store_uint (&(p # "Event" ->ₛ "events")) events).
  sep_apply_l_atomic (store_ptr_undef_store_ptr (&(ilink # "SysDoubleLinklistNode" ->ₛ "node_prev")) ilink).
  sep_apply_l_atomic (store_ptr_undef_store_ptr (&(ilink # "SysDoubleLinklistNode" ->ₛ "node_next")) ilink).
  sep_apply_l_atomic (store_ptr_undef_store_ptr (&(pend # "SysDoubleLinklistNode" ->ₛ "node_prev")) pend).
  sep_apply_l_atomic (store_ptr_undef_store_ptr (&(pend # "SysDoubleLinklistNode" ->ₛ "node_next")) pend).
  sep_apply_l_atomic (store_ptr_undef_store_ptr (&(link # "SysDoubleLinklistNode" ->ₛ "node_prev")) link).
  sep_apply_l_atomic (store_ptr_undef_store_ptr (&(link # "SysDoubleLinklistNode" ->ₛ "node_next")) link).
  sep_apply_l_atomic (CharArray.full_to_undef_full (p+2) 2 (repeat_Z 0 2)).
  cbv zeta.
  split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; tauto.
Qed.
