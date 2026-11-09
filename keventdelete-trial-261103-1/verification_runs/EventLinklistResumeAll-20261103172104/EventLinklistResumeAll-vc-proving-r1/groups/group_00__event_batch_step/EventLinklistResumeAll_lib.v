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

Lemma dllseg_payload_pure__event_batch_step : forall A (rep:addr -> A -> Assertion) (P:A->Prop),
  (forall p a, rep p a |-- “ P a ”) ->
  forall nodes x px y py,
    dllseg rep x px y py nodes |-- “ Forall (fun n => P (getData n)) nodes ”.
Proof.
intros A rep P HP nodes.
induction nodes as [|a nodes IH]; intros x px y py.
- simpl.
Intros.
dump_pre_spatial.
constructor.
- cbn [dllseg].
Intros z.
prop_apply_p (HP x (getData a)).
Intros_p Ha.
prop_apply_p (IH z x y py).
Intros_p Htail.
dump_pre_spatial.
constructor; assumption.
Qed.
Lemma dll_payload_pure__event_batch_step : forall A (rep:addr -> A -> Assertion) (P:A->Prop),
  (forall p a, rep p a |-- “ P a ”) ->
  forall nodes head,
    store_dll rep head nodes |-- “ Forall (fun n => P (getData n)) nodes ”.
Proof.
intros A rep P HP nodes head.
unfold store_dll.
Intros h pt.
prop_apply_p (dllseg_payload_pure__event_batch_step A rep P HP nodes h head head pt).
Intros_p Hall.
dump_pre_spatial.
exact Hall.
Qed.
Lemma event_payload_pending_pure__event_batch_step : forall T link e,
 store_event (pure_suspend_sched_link T) link e |--
 “ Forall (fun t => exists d, T t = Some d /\ tsmStat (tdSchedMember d) = TSK_SUSPEND) (event_pending_addrs e) ”.
Proof.
intros T link e.
unfold store_event.
Intros.
prop_apply_p (dll_payload_pure__event_batch_step addr (pure_suspend_sched_link T)
   (fun t => exists d, T t = Some d /\ tsmStat (tdSchedMember d) = TSK_SUSPEND)
   ltac:(intros l t; unfold pure_suspend_sched_link, pure_published_slink; Intros d; dump_pre_spatial; exists d; tauto)
   (map event_wait_node (event_pending_addrs e))
   (event_pending_head (event_addr e))).
Intros_p Hall.
dump_pre_spatial.
rewrite Forall_forall in *.
intros t Ht.
specialize (Hall (event_wait_node t) (in_map event_wait_node _ _ Ht)).
exact Hall.
Qed.
Lemma event_pending_head_facts__event_batch_step : forall sg st id p t rest,
 event_pending_at id p (t::rest) st ->
 os_inv sg st |-- “ os_world_wf sg st /\ task_world_wf st /\
   exists d, task_desc_map (os_tasks st) t = Some d /\
      tsmStat (tdSchedMember d)=TSK_SUSPEND /\ addr_aligned t ALIGN_SIZE ”.
Proof.
intros sg st id p t rest [e [He [Haddr [Hid Hpend]]]].
unfold os_inv, task_inv, event_inv.
Intros.
prop_apply_p (dll_payload_pure__event_batch_step EventAbs
   (store_event (pure_suspend_sched_link (task_desc_map (os_tasks st))))
   (fun e => Forall (fun t => exists d, task_desc_map (os_tasks st) t=Some d /\ tsmStat (tdSchedMember d)=TSK_SUSPEND) (event_pending_addrs e))
   (event_payload_pending_pure__event_batch_step (task_desc_map (os_tasks st)))
   (map event_link_node (os_events st)) (event_list_head (os_event_stable sg))).
Intros_p Hall.
dump_pre_spatial.
rewrite Forall_forall in Hall.
specialize (Hall (event_link_node e) (in_map event_link_node _ _ He)).
change (Forall (fun t => exists d, task_desc_map (os_tasks st) t=Some d /\ tsmStat (tdSchedMember d)=TSK_SUSPEND) (event_pending_addrs e)) in Hall.
rewrite Hpend in Hall.
inversion Hall as [|? ? Hd Hrest]; subst.
destruct Hd as [d [Hd Hstat]].
split; [assumption|].
split; [assumption|].
exists d.
repeat split; try assumption.
eapply task_wf_aligned; eauto.
Qed.

Require Import Coq.Sorting.Permutation Coq.micromega.Lia.
Lemma idnode_member_facts__event_batch_step : forall sm m n,
 idbuckets_ok (idmax sm) (hoffset sm) (idlist m) (idbuckets m) ->
 In n (List.concat (idbuckets m)) ->
 0 <= idnode_id n < idmax sm /\ idmanager_query m (idnode_id n)=true /\
 In n (Znth (idmanager_bucket_index sm (idnode_id n)) (idbuckets m) nil).
Proof.
 intros sm m node [Hoff [Hlen [[Hrange Hnd] [Hnodes [Hidx Hperm]]]]] Hin.
 assert (Hid : In (idnode_id node) (idlist m)).
 { eapply Permutation_in; [exact Hperm|]. unfold idnode_ids. apply in_map. exact Hin. }
 assert (Hr : 0 <= idnode_id node < idmax sm).
 { rewrite Forall_forall in Hrange. apply Hrange; exact Hid. }
 split; [exact Hr|]. split.
 - unfold idmanager_query. apply id_in_ids_true_iff. exact Hid.
 - apply in_concat in Hin. destruct Hin as [bucket [Hb Hn]].
   destruct (In_nth (idbuckets m) bucket nil Hb) as [k [Hk Hnth]].
   assert (Hbounds : 0 <= Z.of_nat k < Zlength (idbuckets m)) by (rewrite Zlength_correct; lia).
   pose proof (idbuckets_index_ok_Znth (hoffset sm) 0 (idbuckets m) (Z.of_nat k) Hbounds Hidx) as Hi.
   assert (Heq : Znth (Z.of_nat k) (idbuckets m) nil = bucket) by (unfold Znth; rewrite Nat2Z.id; exact Hnth).
   rewrite Heq in Hi. rewrite Forall_forall in Hi. specialize (Hi node Hn).
   unfold idmanager_bucket_index. rewrite Hi. rewrite Z.add_0_l, Heq. exact Hn.
Qed.
Lemma event_pending_head_view__event_batch_step : forall sg st id p t rest,
 event_pending_at id p (t::rest) st ->
 os_inv sg st |-- EX d,
 “ addr_aligned t ALIGN_SIZE /\ task_desc_map(os_tasks st)t=Some d /\ tsmStat(tdSchedMember d)=TSK_SUSPEND /\ os_world_wf sg st /\ task_world_wf st ” && os_inv sg st.
Proof.
intros sg st id p t rest Hp.
prop_apply_p (event_pending_head_facts__event_batch_step sg st id p t rest Hp).
Intros_p Hfacts.
destruct Hfacts as [Hw [Ht [d [Hd [Hs Ha]]]]].
Exists d.
split_pure_spatial; [cancel|].
dump_pre_spatial.
tauto.
Qed.
Lemma task_id_exists_pure__event_batch_step : forall sg st t desc,
 task_world_wf st -> task_desc_map(os_tasks st)t = Some desc ->
 idbuckets_ok (idmax (task_stable_ids (os_task_stable sg)))
  (hoffset(task_stable_ids(os_task_stable sg)))
  (idlist(task_idmanager_abs(os_tasks st))) (idbuckets(task_idmanager_abs(os_tasks st))) ->
 exists tid, 0 <= tid < idmax(task_stable_ids(os_task_stable sg)) /\
 get_task_with_idnode_success sg st tid t.
Proof.
intros sg st t desc Htw Hd Hib.
pose proof (task_wf_map_present st Htw t desc Hd) as Htin.
pose proof (task_wf_id_nodes st Htw) as Hperm.
assert (Hptr : In (&(t # "TaskDescriptor" ->ₛ "id")) (map idnode_addr (task_id_nodes st))).
{ eapply Permutation_in; [apply Permutation_sym; exact Hperm|].
apply in_map_iff.
exists t.
split; [reflexivity|exact Htin].
}
 apply in_map_iff in Hptr.
destruct Hptr as [node [Haddr Hnode]].
pose proof (idnode_member_facts__event_batch_step (task_stable_ids(os_task_stable sg)) (task_idmanager_abs(os_tasks st)) node Hib Hnode) as [Hrange [Hquery Hbucket]].
exists (idnode_id node).
split; [exact Hrange|].
unfold get_task_with_idnode_success.
split; [exact Hrange|].
split; [exact Hquery|].
exists (idnode_addr node).
split; [exact Haddr|].
split; [|exact Htin].
destruct node; exact Hbucket.
Qed.

Lemma dllseg_borrow_payload__event_batch_step : forall A (rep:addr -> A -> Assertion) nodes n,
 In n nodes -> forall x px y py,
 dllseg rep x px y py nodes |--
 rep (getPtr n) (getData n) ** (rep (getPtr n) (getData n) -* dllseg rep x px y py nodes).
Proof.
intros A rep nodes.
induction nodes as [|a nodes IH]; intros n Hin x px y py.
- contradiction.
- destruct Hin as [<-|Hin].
+ cbn [dllseg].
Intros z.
subst x.
cancel (rep (getPtr a) (getData a)).
apply_sepcon_adjoint.
Exists z.
split_pure_spatial; [cancel|].
fold (dllseg rep z (getPtr a) y py nodes).
cancel (rep (getPtr a) (getData a)).
cancel.
dump_pre_spatial.
reflexivity.
+ cbn [dllseg].
Intros z.
fold (dllseg rep z x y py nodes).
sep_apply_l_atomic (IH n Hin z x y py).
cancel (rep (getPtr n) (getData n)).
apply_sepcon_adjoint.
sep_apply_l_atomic (derivable1_wand_elim2 (rep (getPtr n) (getData n)) (dllseg rep z x y py nodes)).
Exists z.
split_pure_spatial.
* fold (dllseg rep z x y py nodes).
cancel.
cancel (rep x (getData a)).
cancel.
* dump_pre_spatial.
assumption.
Qed.

Lemma dll_borrow_payload__event_batch_step : forall A (rep:addr -> A -> Assertion) nodes n,
 In n nodes -> forall head,
 store_dll rep head nodes |--
 rep (getPtr n) (getData n) ** (rep (getPtr n) (getData n) -* store_dll rep head nodes).
Proof.
intros A rep nodes n Hin head.
unfold store_dll.
Intros h pt.
sep_apply_l_atomic (dllseg_borrow_payload__event_batch_step A rep nodes n Hin h head head pt).
cancel (rep (getPtr n) (getData n)).
apply_sepcon_adjoint.
sep_apply_l_atomic (derivable1_wand_elim2 (rep (getPtr n) (getData n)) (dllseg rep h head head pt nodes)).
Exists h pt.
split_pure_spatial; [cancel|].
dump_pre_spatial.
assumption.
Qed.

Lemma idnode_scalar_borrow__event_batch_step : forall link p id,
 store_idnode link (Build_IdNodeAbs id p) |--
 ( &(p # "IdNode" ->ₛ "id") # UShort |-> id) **
 (( &(p # "IdNode" ->ₛ "id") # UShort |-> id) -* store_idnode link (Build_IdNodeAbs id p)).
Proof.
intros link p id.
unfold store_idnode.
simpl.
Intros.
cancel ( &(p # "IdNode" ->ₛ "id") # UShort |-> id).
apply_sepcon_adjoint.
split_pure_spatial; [cancel|].
dump_pre_spatial.
assumption.
Qed.

Lemma idnodes_scalar_borrow__event_batch_step : forall head nodes p id,
 In (Build_IdNodeAbs id p) nodes ->
 store_idnodes head nodes |--
 ( &(p # "IdNode" ->ₛ "id") # UShort |-> id) **
 (( &(p # "IdNode" ->ₛ "id") # UShort |-> id) -* store_idnodes head nodes).
Proof.
intros head nodes p id Hin.
unfold store_idnodes.
assert (Hm : In (idnode_to_dll (Build_IdNodeAbs id p)) (idnodes_to_dll nodes)) by (apply in_map; exact Hin).
rewrite (dll_borrow_payload__event_batch_step IdNodeAbs store_idnode (idnodes_to_dll nodes) (idnode_to_dll (Build_IdNodeAbs id p)) Hm head) at 1.
cbn [getPtr getData idnode_to_dll].
rewrite (idnode_scalar_borrow__event_batch_step (idnode_link (Build_IdNodeAbs id p)) p id) at 1.
cancel ( &(p # "IdNode" ->ₛ "id") # UShort |-> id).
apply_sepcon_adjoint.
sep_apply_l_atomic (derivable1_wand_elim2
  ( &(p # "IdNode" ->ₛ "id") # UShort |-> id)
  (store_idnode (idnode_link (Build_IdNodeAbs id p)) (Build_IdNodeAbs id p))).
sep_apply_l_atomic (derivable1_wand_elim2
  (store_idnode (idnode_link (Build_IdNodeAbs id p)) (Build_IdNodeAbs id p))
  (store_dll store_idnode head (idnodes_to_dll nodes))).
cancel.
Qed.

Lemma idbucket_scalar_borrow__event_batch_step : forall head nodes p id,
 In (Build_IdNodeAbs id p) nodes ->
 store_idbucket head nodes |--
 ( &(p # "IdNode" ->ₛ "id") # UShort |-> id) **
 (( &(p # "IdNode" ->ₛ "id") # UShort |-> id) -* store_idbucket head nodes).
Proof.
intros head [|n ns] p id Hin; [contradiction|].
cbn [store_idbucket].
apply idnodes_scalar_borrow__event_batch_step.
exact Hin.
Qed.

Lemma idbucket_list_scalar_borrow__event_batch_step : forall buckets p id,
 In (Build_IdNodeAbs id p) (List.concat buckets) -> forall h start,
 store_idbucket_list h start buckets |--
 ( &(p # "IdNode" ->ₛ "id") # UShort |-> id) **
 (( &(p # "IdNode" ->ₛ "id") # UShort |-> id) -* store_idbucket_list h start buckets).
Proof.
intros buckets.
induction buckets as [|b bs IH]; intros p id Hin h start; [contradiction|].
cbn [List.concat] in Hin.
apply in_app_or in Hin.
destruct Hin as [Hin|Hin].
- cbn [store_idbucket_list].
rewrite (idbucket_scalar_borrow__event_batch_step (h + start * sizeof("SysDoubleLinklistNode")) b p id Hin) at 1.
cancel ( &(p # "IdNode" ->ₛ "id") # UShort |-> id).
apply_sepcon_adjoint.
sep_apply_l_atomic (derivable1_wand_elim2
     ( &(p # "IdNode" ->ₛ "id") # UShort |-> id)
     (store_idbucket (h + start * sizeof("SysDoubleLinklistNode")) b)).
cancel.
- cbn [store_idbucket_list].
rewrite (IH p id Hin h (start+1)) at 1.
cancel ( &(p # "IdNode" ->ₛ "id") # UShort |-> id).
apply_sepcon_adjoint.
sep_apply_l_atomic (derivable1_wand_elim2
     ( &(p # "IdNode" ->ₛ "id") # UShort |-> id)
     (store_idbucket_list h (start+1) bs)).
cancel.
Qed.

Lemma idmanager_scalar_borrow__event_batch_step : forall sm m manager p id,
 In (Build_IdNodeAbs id p) (List.concat (idbuckets m)) ->
 store_idmanager sm m manager |--
 ( &(p # "IdNode" ->ₛ "id") # UShort |-> id) **
 (( &(p # "IdNode" ->ₛ "id") # UShort |-> id) -* store_idmanager sm m manager).
Proof.
intros sm m manager p id Hin.
unfold store_idmanager, store_idbuckets.
Intros.
rewrite (idbucket_list_scalar_borrow__event_batch_step (idbuckets m) p id Hin (htable sm) 0) at 1.
cancel ( &(p # "IdNode" ->ₛ "id") # UShort |-> id).
apply_sepcon_adjoint.
sep_apply_l_atomic (derivable1_wand_elim2 ( &(p # "IdNode" ->ₛ "id") # UShort |-> id) (store_idbucket_list (htable sm) 0 (idbuckets m))).
split_pure_spatial; [cancel|].
dump_pre_spatial.
assumption.
Qed.

Lemma task_id_scalar_address__event_batch_step : forall t,
 &(t # "TaskDescriptor" ->ₛ "id" .ₛ "id") =
 let p := &(t # "TaskDescriptor" ->ₛ "id") in &(p # "IdNode" ->ₛ "id").
Proof.
intros t.
simpl.
rewrite addr_of_arrow_field.
rewrite eval_addr.
reflexivity.
Qed.

Lemma idmanager_buckets_pure__event_batch_step : forall sm m manager,
 store_idmanager sm m manager |-- “ idbuckets_ok (idmax sm) (hoffset sm) (idlist m) (idbuckets m) ”.
Proof.
intros sm m manager.
unfold store_idmanager.
Intros.
dump_pre_spatial.
assumption.
Qed.

Lemma task_id_available_pure__event_batch_step : forall sg st t desc,
 task_desc_map (os_tasks st) t = Some desc ->
 os_inv sg st |-- “ exists tid, 0 <= tid < 65536 /\ get_task_with_idnode_success sg st tid t ”.
Proof.
intros sg st t desc Hd.
unfold os_inv, task_inv.
Intros.
prop_apply_p (idmanager_buckets_pure__event_batch_step (task_stable_ids(os_task_stable sg)) (task_idmanager_abs(os_tasks st)) (task_idmanager_ptr(os_task_stable sg))).
Intros_p Hbucket.
assert (Ht : task_world_wf st) by assumption.
assert (Hib : idbuckets_ok (idmax(task_stable_ids(os_task_stable sg))) (hoffset(task_stable_ids(os_task_stable sg))) (idlist(task_idmanager_abs(os_tasks st))) (idbuckets(task_idmanager_abs(os_tasks st)))) by assumption.
pose proof (task_id_exists_pure__event_batch_step sg st t desc Ht Hd Hib) as [tid [Hr Hlookup]].
assert (Hctx : os_global_context sg) by (eapply os_wf_context; eauto).
unfold os_global_context in Hctx.
destruct Hctx as [_ [_ [_ [Htc _]]]].
unfold task_context in Htc.
destruct Htc as [_ [_ [_ [Hmax _]]]].
unfold ID_MAX_NUM in Hmax.
rewrite Hmax in Hr.
dump_pre_spatial.
exists tid.
split; [lia|exact Hlookup].
Qed.

Lemma nth_list_member_concat__event_batch_step : forall A (ls:list(list A)) n a,
 In a (nth n ls nil) -> In a (List.concat ls).
Proof.
intros A ls.
induction ls as [|b bs IH]; intros [|n] a H; simpl in *; try contradiction.
- apply in_or_app; left; exact H.
- apply in_or_app; right; eapply IH; exact H.
Qed.

Lemma task_id_borrow__event_batch_step : forall sg st tid t,
 get_task_with_idnode_success sg st tid t ->
 os_inv sg st |--
 (&(t # "TaskDescriptor" ->ₛ "id" .ₛ "id") # UShort |-> tid) **
 event_resume_id_restore sg st t tid.
Proof.
intros sg st tid t Hlookup.
destruct Hlookup as [Hr [Hq [p [Hp [Hin Htask]]]]].
subst p.
unfold Znth in Hin.
pose proof (nth_list_member_concat__event_batch_step _ _ _ _ Hin) as Hmember.
unfold event_resume_id_restore.
rewrite task_id_scalar_address__event_batch_step.
unfold os_inv, task_inv at 1.
Intros_p Hw.
Intros_p Htw.
rewrite (idmanager_scalar_borrow__event_batch_step
  (task_stable_ids(os_task_stable sg)) (task_idmanager_abs(os_tasks st))
  (task_idmanager_ptr(os_task_stable sg)) (&(t # "TaskDescriptor" ->ₛ "id")) tid Hmember) at 1.
cbv [Crtos_C_Rules.sizeof_front_end_type sizeof_front_end_type sizeof_front_end_type_of_ptr_size].
cancel.
cbn zeta.
match goal with |- _ |-- ?A ** _ => cancel A end.
apply_sepcon_adjoint.
match goal with |- context [?A -* ?P] => sep_apply_l_atomic (derivable1_wand_elim2 A P) end.
unfold task_inv.
split_pure_spatial.
sepcon_right_assoc.
repeat match goal with |- ?A ** _ |-- ?A ** _ => cancel A end.
cancel.
split_pures; dump_pre_spatial; assumption.
Qed.
Require Import Coq.Logic.FunctionalExtensionality.
Lemma nodup_map_same__event_batch_step : forall A B (f:A->B) xs a b,
 NoDup (map f xs) -> In a xs -> In b xs -> f a = f b -> a=b.
Proof.
intros A B f xs.
induction xs as [|x xs IH]; intros a b Hnd Ha Hb Heq; [contradiction|].
inversion Hnd as [|? ? Hnot Htail]; subst.
destruct Ha as [<-|Ha]; destruct Hb as [<-|Hb]; auto.
- exfalso.
apply Hnot.
rewrite Heq.
apply in_map; exact Hb.
- exfalso.
apply Hnot.
rewrite <- Heq.
apply in_map; exact Ha.
Qed.
Lemma task_lookup_same__event_batch_step : forall sg st tid t u,
 idbuckets_ok (idmax(task_stable_ids(os_task_stable sg)))
 (hoffset(task_stable_ids(os_task_stable sg)))
 (idlist(task_idmanager_abs(os_tasks st))) (idbuckets(task_idmanager_abs(os_tasks st))) ->
 get_task_with_idnode_success sg st tid t ->
 get_task_with_idnode_success sg st tid u -> t=u.
Proof.
intros sg st tid t u Hib [_ [_ [pt [Hpt [Ht _]]]]] [_ [_ [pu [Hpu [Hu _]]]]].
destruct Hib as [_ [_ [[Hrange Hnd] [_ [_ Hperm]]]]].
assert (Hnodes : NoDup(idnode_ids(List.concat(idbuckets(task_idmanager_abs(os_tasks st)))))).
{ eapply Permutation_NoDup; [apply Permutation_sym; exact Hperm|exact Hnd].
}
 unfold Znth in Ht, Hu.
apply nth_list_member_concat__event_batch_step in Ht, Hu.
pose proof (nodup_map_same__event_batch_step _ _ idnode_id _ _ _ Hnodes Ht Hu eq_refl) as Hnodesame.
injection Hnodesame as Hptr.
rewrite Hpt, Hpu in Hptr.
apply addr_of_arrow_field_inv in Hptr.
inversion Hptr.
reflexivity.
Qed.
Lemma resume_task_map_cons__event_batch_step : forall T t d rest,
 T t = Some d ->
 resume_all_task_map
  (update_task_desc_map t (set_task_desc_ready(set_task_desc_exstatus d (-1))) T) rest =
 resume_all_task_map T (t::rest).
Proof.
intros T t d rest Hd.
apply functional_extensionality.
intro x.
unfold resume_all_task_map, update_task_desc_map.
destruct (Z.eq_dec x t) as [->|Hne].
- rewrite Hd.
destruct (in_dec Z.eq_dec t rest);
   destruct (in_dec Z.eq_dec t (t::rest)); try (exfalso; apply n; left; reflexivity).
+ destruct d; reflexivity.
+ reflexivity.
+ exfalso.
match goal with H : ~ In t (t::rest) |- _ => apply H; left; reflexivity end.
- destruct (T x) as [dx|]; [|reflexivity].
destruct (in_dec Z.eq_dec x rest) as [Hin|Hnot];
   destruct (in_dec Z.eq_dec x (t::rest)) as [Hinall|Hnotall]; auto.
+ exfalso.
apply Hnotall.
right; exact Hin.
+ destruct Hinall as [Heq|Hin]; [congruence|contradiction].
Qed.
Lemma ready_rest_observation__event_batch_step : forall T U node r,
 (forall x, option_map (fun d => tsmRestTimeslice(tdSchedMember d)) (T x) =
            option_map (fun d => tsmRestTimeslice(tdSchedMember d)) (U x)) ->
 ready_node_rest_timeslice T node r -> ready_node_rest_timeslice U node r.
Proof.
intros T U node r Hobs [d [[Hnz [Hptr Hd]] [Halign Hr]]].
specialize (Hobs (getData node)).
rewrite Hd in Hobs.
destruct (U (getData node)) as [e|] eqn:He; [|discriminate].
cbn in Hobs.
injection Hobs as Hrest.
exists e.
repeat split; auto.
congruence.
Qed.
Lemma rrr_observation__event_batch_step : forall T U sched node before after,
 (forall x, option_map (fun d => tsmRestTimeslice(tdSchedMember d)) (T x) =
            option_map (fun d => tsmRestTimeslice(tdSchedMember d)) (U x)) ->
 rrr_bucket_insert T sched node before after -> rrr_bucket_insert U sched node before after.
Proof.
intros T U sched node before after Hobs [[Hlt [prefix [suffix [Hb [Ha [Hp Hs]]]]]]|Htail].
- left.
split; [exact Hlt|].
exists prefix,suffix.
repeat split; try assumption.
+ eapply Forall_impl; [|exact Hp].
intros n [r [Hr Hle]].
exists r.
split; [eapply ready_rest_observation__event_batch_step; eauto|exact Hle].
+ destruct suffix as [|n suffix]; [exact I|].
destruct Hs as [r [Hr Hgt]].
exists r.
split; [eapply ready_rest_observation__event_batch_step; eauto|exact Hgt].
- right.
exact Htail.
Qed.
Lemma assign_insert_observation__event_batch_step : forall T U task d e before after,
 U task=Some e ->
 set_sched_member_status (tdSchedMember d) TSK_READY =
 set_sched_member_status (tdSchedMember e) TSK_READY ->
 (forall x, option_map (fun q => tsmRestTimeslice(tdSchedMember q)) (T x) =
            option_map (fun q => tsmRestTimeslice(tdSchedMember q)) (U x)) ->
 assign_insert_step_ic T task d before after ->
 assign_insert_step_ic U task e before after.
Proof.
intros T U task d e before after Hue Hsched Hobs [[Htd Hrange] [Halign [Hnz [bucket [Hrrr Hafter]]]]].
assert (Hp : tsmCurPrio(tdSchedMember d)=tsmCurPrio(tdSchedMember e)).
{ exact (f_equal tsmCurPrio Hsched).
}
 assert (Hr : tsmRestTimeslice(tdSchedMember d)=tsmRestTimeslice(tdSchedMember e)).
{ exact (f_equal tsmRestTimeslice Hsched).
}
 unfold assign_insert_step_ic.
split; [split; [exact Hue|rewrite <- Hp; exact Hrange]|].
split; [exact Halign|].
split; [exact Hnz|].
exists bucket.
rewrite <- Hsched.
split; [|exact Hafter].
eapply rrr_observation__event_batch_step; [|exact Hrrr].
intro x.
unfold update_task_desc_map.
destruct (Z.eq_dec x task); [cbn; rewrite Hr; reflexivity|apply Hobs].
Qed.
Lemma ready_fold_transport__event_batch_step : forall waiting T U (P Q : OsAssignReadyVectorAbs->Prop),
 (forall x, In x waiting -> T x=U x) ->
 (forall x, option_map (fun d => tsmRestTimeslice(tdSchedMember d)) (T x) =
            option_map (fun d => tsmRestTimeslice(tdSchedMember d)) (U x)) ->
 (forall r, P r -> Q r) ->
 forall after,
 fold_left (fun states task => fun ra => exists rb d,
   states rb /\ T task=Some d /\ assign_insert_step_ic T task d rb ra) waiting P after ->
 fold_left (fun states task => fun ra => exists rb d,
   states rb /\ U task=Some d /\ assign_insert_step_ic U task d rb ra) waiting Q after.
Proof.
induction waiting as [|t waiting IH]; intros T U P Q Heq Hobs HP after Hfold.
- exact (HP after Hfold).
- cbn [fold_left] in *.
eapply IH; [|exact Hobs| |exact Hfold].
+ intros x Hx.
apply Heq.
right; exact Hx.
+ intros ra [rb [d [Hrb [Htd Hstep]]]].
exists rb,d.
split; [apply HP; exact Hrb|].
split.
* rewrite <- (Heq t (or_introl eq_refl)); exact Htd.
* eapply assign_insert_observation__event_batch_step; [|reflexivity|exact Hobs|exact Hstep].
rewrite <- (Heq t (or_introl eq_refl)); exact Htd.
Qed.
Lemma ready_head_compose__event_batch_step : forall T t d rest r0 r1 r2,
 T t=Some d -> ~ In t rest ->
 assign_insert_step_ic (update_task_desc_map t (set_task_desc_exstatus d (-1)) T)
   t (set_task_desc_exstatus d (-1)) r0 r1 ->
 resume_all_ready (update_task_desc_map t (set_task_desc_ready(set_task_desc_exstatus d (-1))) T)
   rest r1 r2 ->
 resume_all_ready T (t::rest) r0 r2.
Proof.
intros T t d rest r0 r1 r2 Hd Hnot Hhead Htail.
assert (Hfailedobs : forall x,
 option_map (fun d => tsmRestTimeslice(tdSchedMember d))
  (update_task_desc_map t (set_task_desc_exstatus d (-1)) T x) =
 option_map (fun d => tsmRestTimeslice(tdSchedMember d)) (T x)).
{ intro x.
unfold update_task_desc_map.
destruct (Z.eq_dec x t) as [->|Hne]; [rewrite Hd|]; reflexivity.
}
 assert (Hreadyobs : forall x,
 option_map (fun d => tsmRestTimeslice(tdSchedMember d))
  (update_task_desc_map t (set_task_desc_ready(set_task_desc_exstatus d (-1))) T x) =
 option_map (fun d => tsmRestTimeslice(tdSchedMember d)) (T x)).
{ intro x.
unfold update_task_desc_map.
destruct (Z.eq_dec x t) as [->|Hne]; [rewrite Hd|]; reflexivity.
}
 assert (Hhead' : assign_insert_step_ic T t d r0 r1).
{ eapply assign_insert_observation__event_batch_step with (d:=set_task_desc_exstatus d (-1)); [exact Hd|reflexivity|exact Hfailedobs|exact Hhead].
}
unfold resume_all_ready in *.
cbn [fold_left].
eapply ready_fold_transport__event_batch_step; [|exact Hreadyobs| |exact Htail].
- intros x Hx.
unfold update_task_desc_map.
destruct (Z.eq_dec x t) as [->|Hne]; [contradiction|reflexivity].
- intros r ->.
exists r0,d.
split; [reflexivity|].
auto.
Qed.
Lemma delay_payload_exclusive__event_batch_step : forall link i j,
 store_delay_info link i ** store_delay_info link j |-- “ False ”.
Proof.
intros link i j.
unfold store_delay_info.
Intros p q.
assert (Hpq : p=q).
{ destruct H as [_ [Hp _]].
destruct H0 as [_ [Hq _]].
assert (Heq : &(p # "Delay" ->ₛ "link") = &(q # "Delay" ->ₛ "link")) by congruence.
apply addr_of_arrow_field_inv in Heq.
inversion Heq.
reflexivity.
}
subst q.
prop_apply_p (dup_store_ptr (&(p # "Delay" ->ₛ "task")) (tdTaskPtr i) (tdTaskPtr j)).
Intros_p Hfalse.
contradiction.
Qed.
Lemma delay_inactive_active_apart__event_batch_step : forall p info head nodes,
 store_inactive_delay p info ** store_dll store_delay_info head nodes |--
 “ ~ In (&(p # "Delay" ->ₛ "link")) (map (@getPtr TaskDelayAbs) nodes) ”.
Proof.
intros p info head nodes.
destruct (in_dec Z.eq_dec (&(p # "Delay" ->ₛ "link")) (map (@getPtr TaskDelayAbs) nodes)) as [Hin|Hnot].
- apply in_map_iff in Hin.
destruct Hin as [node [Hptr Hnode]].
sep_apply_l_atomic (dll_borrow_payload__event_batch_step TaskDelayAbs store_delay_info nodes node Hnode head).
unfold store_inactive_delay.
Intros_p Hstat.
rewrite Hptr.
prop_apply_p (delay_payload_exclusive__event_batch_step (&(p # "Delay" ->ₛ "link")) info (getData node)).
Intros_p Hfalse.
contradiction.
- dump_pre_spatial.
exact Hnot.
Qed.
Lemma delay_map_active_apart_at__event_batch_step : forall m head nodes p info,
 m p=Some info ->
 store_map store_inactive_delay m ** store_dll store_delay_info head nodes |--
 “ ~ In (&(p # "Delay" ->ₛ "link")) (map (@getPtr TaskDelayAbs) nodes) ”.
Proof.
intros m head nodes p info Hip.
sep_apply_l_atomic (store_map_split store_inactive_delay p info m Hip).
prop_apply_p (delay_inactive_active_apart__event_batch_step p info head nodes).
Intros_p Hnot.
dump_pre_spatial.
exact Hnot.
Qed.
Lemma delay_nonoverlap__event_batch_step : forall sg st,
 os_inv sg st |-- “ forall p info, delay_inactive_map(os_delays st)p=Some info ->
 ~ In (&(p # "Delay" ->ₛ "link")) (map (@getPtr TaskDelayAbs) (delay_active_nodes(os_delays st))) ”.
Proof.
intros sg st.
assert (Hpoint : forall p info, delay_inactive_map(os_delays st)p=Some info ->
 os_inv sg st |-- “ ~ In (&(p # "Delay" ->ₛ "link"))
 (map (@getPtr TaskDelayAbs) (delay_active_nodes(os_delays st))) ”).
{ intros p info Hip.
unfold os_inv,delay_inv.
Intros.
prop_apply_p (delay_map_active_apart_at__event_batch_step
    (delay_inactive_map(os_delays st)) (delay_head_ptr sg) (delay_active_nodes(os_delays st)) p info Hip).
Intros_p Hnot.
dump_pre_spatial.
exact Hnot.
}
 unfold derivable1,coq_prop in *.
intros heap Hheap p info Hip.
exact (Hpoint p info Hip heap Hheap).
Qed.
Lemma delay_link_injective__event_batch_step : forall p q,
 &(p # "Delay" ->ₛ "link") = &(q # "Delay" ->ₛ "link") -> p=q.
Proof.
intros p q H.
apply addr_of_arrow_field_inv in H.
inversion H.
reflexivity.
Qed.
Lemma selected_delays_observation__event_batch_step : forall (waiting:list addr) T U,
 (forall x, option_map tdDelay (T x)=option_map tdDelay(U x)) ->
 fold_right (fun task delays =>
  match T task with Some desc => if Z.eq_dec (tdDelay desc) 0 then delays else tdDelay desc::delays | None=>delays end) [] waiting =
 fold_right (fun task delays =>
  match U task with Some desc => if Z.eq_dec (tdDelay desc) 0 then delays else tdDelay desc::delays | None=>delays end) [] waiting.
Proof.
induction waiting as [|t rest IH]; intros T U Hobs; [reflexivity|].
cbn [fold_right].
rewrite (IH T U Hobs).
specialize (Hobs t).
destruct (T t) as [d|]; destruct (U t) as [e|]; cbn in Hobs; try discriminate; try reflexivity.
injection Hobs as Heq.
rewrite Heq.
reflexivity.
Qed.
Lemma resume_delays_observation__event_batch_step : forall waiting T U ds,
 (forall x, option_map tdDelay (T x)=option_map tdDelay(U x)) ->
 resume_all_delays T waiting ds=resume_all_delays U waiting ds.
Proof.
intros waiting T U ds Hobs.
unfold resume_all_delays.
rewrite (selected_delays_observation__event_batch_step waiting T U Hobs).
reflexivity.
Qed.
Lemma filter_cons_absent_key__event_batch_step : forall A (key:A->Z) k xs (f:A->bool),
 ~In k (map key xs) ->
 filter (fun x=>negb(Z.eqb(key x) k || negb(f x))) xs = filter f xs.
Proof.
intros A key k xs f Hnot.
induction xs as [|x xs IH]; [reflexivity|].
cbn in Hnot.
assert (Hne : key x <> k) by intuition congruence.
cbn [filter].
rewrite (proj2 (Z.eqb_neq _ _) Hne).
cbn.
rewrite Bool.negb_involutive.
rewrite IH by intuition.
reflexivity.
Qed.
Lemma find_absent_key__event_batch_step : forall A (key:A->Z) k xs,
 ~In k(map key xs) -> find (fun x=>Z.eqb(key x)k) xs=None.
Proof.
intros A key k xs Hnot.
induction xs as [|x xs IH]; [reflexivity|].
cbn in Hnot.
assert (Hne:key x<>k) by intuition congruence.
cbn.
rewrite (proj2(Z.eqb_neq _ _) Hne).
apply IH; intuition.
Qed.
Lemma find_insert_other_key__event_batch_step : forall A (key:A->Z) k pre x suf,
 key x<>k ->
 find (fun a=>Z.eqb(key a)k) (pre++x::suf)=find(fun a=>Z.eqb(key a)k)(pre++suf).
Proof.
intros A key k pre.
induction pre as [|a pre IH]; intros x suf Hne; cbn.
- rewrite (proj2(Z.eqb_neq _ _) Hne).
reflexivity.
- destruct (Z.eqb(key a)k); [reflexivity|apply IH; exact Hne].
Qed.
Lemma find_insert_same_key__event_batch_step : forall A (key:A->Z) k pre x suf,
 key x=k -> ~In k(map key pre) ->
 find (fun a=>Z.eqb(key a)k) (pre++x::suf)=Some x.
Proof.
intros A key k pre.
induction pre as [|a pre IH]; intros x suf Heq Hnot; cbn.
- rewrite Heq, Z.eqb_refl.
reflexivity.
- cbn in Hnot.
assert (Hne:key a<>k) by intuition congruence.
rewrite (proj2(Z.eqb_neq _ _) Hne).
apply IH; [exact Heq|intuition].
Qed.
Lemma filter_or_absent_key__event_batch_step : forall A (key:A->Z) k xs (f:A->bool),
 ~In k(map key xs) ->
 filter(fun x=>negb(Z.eqb(key x)k || f x))xs=filter(fun x=>negb(f x))xs.
Proof.
intros A key k xs f Hnot.
induction xs as [|x xs IH]; [reflexivity|].
cbn in Hnot.
assert(Hne:key x<>k) by intuition congruence.
cbn [filter].
rewrite (proj2(Z.eqb_neq _ _) Hne).
cbn.
rewrite IH by intuition.
reflexivity.
Qed.
Lemma resume_delays_absent_cons__event_batch_step : forall T t d rest ds,
 T t=Some d ->
 ~In (&(((tdDelay d)) # "Delay" ->ₛ "link")) (map (@getPtr TaskDelayAbs)(delay_active_nodes ds)) ->
 resume_all_delays T rest ds=resume_all_delays T (t::rest) ds.
Proof.
intros T t d rest ds Hd Hnot.
unfold resume_all_delays.
cbn [fold_right].
rewrite Hd.
destruct (Z.eq_dec(tdDelay d)0); [reflexivity|].
cbn zeta.
f_equal.
- apply functional_extensionality.
intro p.
destruct (Z.eq_dec p (tdDelay d)) as [->|Hne].
+ rewrite (find_absent_key__event_batch_step _ (@getPtr TaskDelayAbs) _ _ Hnot).
destruct (in_dec Z.eq_dec (tdDelay d)
      (fold_right (fun task delays => match T task with Some desc => if Z.eq_dec(tdDelay desc)0 then delays else tdDelay desc::delays|None=>delays end) [] rest));
     destruct (in_dec Z.eq_dec (tdDelay d)
      (tdDelay d::fold_right (fun task delays => match T task with Some desc => if Z.eq_dec(tdDelay desc)0 then delays else tdDelay desc::delays|None=>delays end) [] rest)); try reflexivity;
     exfalso; match goal with H : ~In _ (_::_) |- _=>apply H; left; reflexivity end.
+ repeat match goal with |- context[in_dec Z.eq_dec p ?ls]=>destruct(in_dec Z.eq_dec p ls) end; try reflexivity; exfalso; intuition.
destruct i as [Heq|Hin]; [congruence|contradiction].
- cbn [existsb].
symmetry.
apply filter_or_absent_key__event_batch_step.
exact Hnot.
Qed.
Lemma resume_delays_active_cons__event_batch_step : forall T t d rest m pre suf info,
 T t=Some d -> tdDelay d<>0 ->
 ~In (&(((tdDelay d)) # "Delay" ->ₛ "link")) (map (@getPtr TaskDelayAbs)(pre++suf)) ->
 resume_all_delays T rest
  {|delay_inactive_map:=Mapping.partial_mapping_update m (tdDelay d)(delay_mark_inactive info);
    delay_active_nodes:=pre++suf|} =
 resume_all_delays T (t::rest)
  {|delay_inactive_map:=m;
    delay_active_nodes:=pre++Build_DL_Node info (&(((tdDelay d)) # "Delay" ->ₛ "link"))::suf|}.
Proof.
intros T t d rest m pre suf info Hd Hnz Hnot.
assert (Hpre : ~In (&(((tdDelay d)) # "Delay" ->ₛ "link")) (map (@getPtr TaskDelayAbs)pre)).
{ rewrite map_app in Hnot.
intro H; apply Hnot; apply in_or_app; left; exact H.
}
 assert (Hsuf : ~In (&(((tdDelay d)) # "Delay" ->ₛ "link")) (map (@getPtr TaskDelayAbs)suf)).
{ rewrite map_app in Hnot.
intro H; apply Hnot; apply in_or_app; right; exact H.
}
 unfold resume_all_delays.
cbn [fold_right].
rewrite Hd.
destruct (Z.eq_dec(tdDelay d)0); [contradiction|].
cbn zeta.
cbn [delay_active_nodes delay_inactive_map].
f_equal.
- apply functional_extensionality.
intro p.
destruct (Z.eq_dec p (tdDelay d)) as [->|Hne].
+ rewrite (find_absent_key__event_batch_step _ (@getPtr TaskDelayAbs) _ _ Hnot).
pose proof (find_insert_same_key__event_batch_step _ (@getPtr TaskDelayAbs) (&(((tdDelay d)) # "Delay" ->ₛ "link")) pre (Build_DL_Node info (&(((tdDelay d)) # "Delay" ->ₛ "link"))) suf eq_refl Hpre) as Hfind.
cbn [getPtr] in Hfind.
rewrite Hfind.
unfold Mapping.partial_mapping_update.
destruct (Z.eq_dec(tdDelay d)(tdDelay d)); [|contradiction].
repeat match goal with |- context[in_dec Z.eq_dec (tdDelay d) ?ls]=>destruct(in_dec Z.eq_dec (tdDelay d) ls) end;
     try reflexivity; exfalso; match goal with H : ~In _ (_::_) |- _=>apply H; left; reflexivity end.
+ assert (Hlink : (&(((tdDelay d)) # "Delay" ->ₛ "link")) <> (&(p # "Delay" ->ₛ "link"))).
{ intro Heq.
apply delay_link_injective__event_batch_step in Heq.
congruence.
}
     rewrite (find_insert_other_key__event_batch_step _ (@getPtr TaskDelayAbs) _ pre
      (Build_DL_Node info (&(((tdDelay d)) # "Delay" ->ₛ "link"))) suf Hlink).
unfold Mapping.partial_mapping_update.
destruct (Z.eq_dec p (tdDelay d)); [contradiction|].
destruct (Z.eq_dec (tdDelay d) p); [congruence|].
repeat match goal with |- context[in_dec Z.eq_dec p ?ls]=>destruct(in_dec Z.eq_dec p ls) end;
try reflexivity; exfalso; simpl in *; intuition congruence.
- cbn [existsb].
rewrite !filter_app.
cbn [filter getPtr].
rewrite Z.eqb_refl.
cbn.
rewrite (filter_or_absent_key__event_batch_step _ (@getPtr TaskDelayAbs) _ pre _ Hpre).
rewrite (filter_or_absent_key__event_batch_step _ (@getPtr TaskDelayAbs) _ suf _ Hsuf).
reflexivity.
Qed.
Lemma resume_delays_unset_compose__event_batch_step : forall T t d rest before after,
 T t=Some d ->
 ktask_unset_delay_step (tdDelay d) before after ->
 (forall p info, delay_inactive_map(os_delays after)p=Some info ->
 ~In (&(p # "Delay" ->ₛ "link")) (map (@getPtr TaskDelayAbs)(delay_active_nodes(os_delays after)))) ->
 resume_all_delays T rest (os_delays after)=resume_all_delays T (t::rest)(os_delays before).
Proof.
intros T t d rest before after Hd Hstep Hapart.
destruct Hstep as [[Hz ->]|[[Hnz [info [Hip ->]]]|[Hnz [info [Hin Hstep]]]]].
- unfold resume_all_delays.
cbn [fold_right].
rewrite Hd,Hz.
destruct (Z.eq_dec 0 0); [reflexivity|contradiction].
- eapply resume_delays_absent_cons__event_batch_step; [exact Hd|eapply Hapart; exact Hip].
- pose proof (unset_delay_active_nodes _ _ _ _ Hstep) as Hactive.
pose proof (unset_delay_inactive_map _ _ _ _ Hstep) as Hmap.
assert (Hip : delay_inactive_map(os_delays after)(tdDelay d)=Some(delay_mark_inactive info)).
{ rewrite Hmap.
unfold Mapping.partial_mapping_update.
destruct (Z.eq_dec(tdDelay d)(tdDelay d)); [reflexivity|contradiction].
}
   pose proof (Hapart _ _ Hip) as Hnot.
destruct Hactive as [[Habs Heq]|[pre [suf [Hbefore Hafter]]]]; [contradiction|].
assert (Dbefore : os_delays before =
    {|delay_inactive_map:=delay_inactive_map(os_delays before);
      delay_active_nodes:=pre++Build_DL_Node info (&(((tdDelay d)) # "Delay" ->ₛ "link"))::suf|}).
{ destruct(os_delays before); simpl in *.
subst.
reflexivity.
}
   assert (Dafter : os_delays after =
    {|delay_inactive_map:=Mapping.partial_mapping_update (delay_inactive_map(os_delays before))
       (tdDelay d)(delay_mark_inactive info); delay_active_nodes:=pre++suf|}).
{ destruct(os_delays after); simpl in *.
subst.
reflexivity.
}
   rewrite Hafter in Hnot.
rewrite Dafter,Dbefore.
cbn [delay_inactive_map].
eapply resume_delays_active_cons__event_batch_step; eassumption.
Qed.
Lemma dll_same_head_exclusive__event_batch_step : forall A B (rep:addr->A->Assertion) (rep':addr->B->Assertion) h ns ms,
 store_dll rep h ns ** store_dll rep' h ms |-- “ False ”.
Proof.
intros A B rep rep' h ns ms.
unfold store_dll.
Intros h1 pt1 h2 pt2.
prop_apply_p (dup_store_ptr (&(h # "SysDoubleLinklistNode" ->ₛ "node_prev")) pt1 pt2).
Intros_p Hfalse.
contradiction.
Qed.
Lemma event_payload_exclusive__event_batch_step : forall wait l l' e e',
 event_addr e=event_addr e' ->
 store_event wait l e ** store_event wait l' e' |-- “ False ”.
Proof.
intros wait l l' e e' Heq.
unfold store_event.
Intros.
rewrite Heq.
prop_apply_p (dll_same_head_exclusive__event_batch_step addr addr wait wait
  (&(((event_addr e')) # "Event" ->ₛ "pend_list"))
  (map event_wait_node(event_pending_addrs e)) (map event_wait_node(event_pending_addrs e'))).
Intros_p Hfalse.
contradiction.
Qed.
Lemma event_payload_segment_apart__event_batch_step : forall wait es l e x px y py,
 store_event wait l e ** dllseg (store_event wait) x px y py (map event_link_node es)
 |-- “ ~In (event_addr e)(map event_addr es) ”.
Proof.
intros wait es l e x px y py.
destruct (in_dec Z.eq_dec (event_addr e)(map event_addr es)) as [Hin|Hnot].
- apply in_map_iff in Hin.
destruct Hin as [e' [Haddr Hin]].
assert (Hnode:In (event_link_node e')(map event_link_node es)) by (apply in_map; exact Hin).
sep_apply_l_atomic (dllseg_borrow_payload__event_batch_step EventAbs (store_event wait)
    (map event_link_node es)(event_link_node e') Hnode x px y py).
cbn [event_link_node getPtr getData].
prop_apply_p (event_payload_exclusive__event_batch_step wait l
     (&(((event_addr e')) # "Event" ->ₛ "link")) e e' (eq_sym Haddr)).
Intros_p Hfalse.
contradiction.
- dump_pre_spatial.
exact Hnot.
Qed.
Lemma event_segment_nodup__event_batch_step : forall wait es x px y py,
 dllseg (store_event wait) x px y py (map event_link_node es)
 |-- “ NoDup(map event_addr es) ”.
Proof.
intros wait es.
induction es as [|e es IH]; intros x px y py.
- dump_pre_spatial.
constructor.
- cbn [map dllseg].
Intros z.
fold (dllseg (store_event wait) z x y py (map event_link_node es)).
prop_apply_p (IH z x y py).
Intros_p Hnd.
cbn [event_link_node getData].
prop_apply_p (event_payload_segment_apart__event_batch_step wait es x e z x y py).
Intros_p Hnot.
dump_pre_spatial.
constructor; assumption.
Qed.
Lemma event_addresses_nodup__event_batch_step : forall sg st,
 os_inv sg st |-- “ NoDup(map event_addr(os_events st)) ”.
Proof.
intros sg st.
unfold os_inv,event_inv.
Intros.
unfold store_dll at 1.
Intros h.
Intros pt.
prop_apply_p (event_segment_nodup__event_batch_step
  (pure_suspend_sched_link(task_desc_map(os_tasks st))) (os_events st)
  h (event_list_head(os_event_stable sg)) (event_list_head(os_event_stable sg)) pt).
Intros_p Hnd.
dump_pre_spatial.
exact Hnd.
Qed.
Lemma nodup_app_disjoint__event_batch_step : forall A (xs ys:list A) x,
 NoDup(xs++ys) -> In x xs -> ~In x ys.
Proof.
intros A xs.
induction xs as [|a xs IH]; intros ys x Hnd Hin; [contradiction|].
inversion Hnd as [|? ? Hnot Htail]; subst.
destruct Hin as [<-|Hin].
- intro H; apply Hnot; apply in_or_app; right; exact H.
- eapply IH; eauto.
Qed.
Lemma remove_found_absent_eq__event_batch_step : forall A (x:A) before after,
 ~In x before -> remove_found_prop x before after -> after=before.
Proof.
intros A x before after Hnot [[_ Heq]|[pre [suf [Heq Ha]]]]; [symmetry; exact Heq|].
exfalso.
apply Hnot.
rewrite Heq.
apply in_or_app; right; left; reflexivity.
Qed.
Lemma event_remove_absent__event_batch_step : forall t before after,
 ~In t(event_waiters before) -> event_remove_waiter_step t before after -> after=before.
Proof.
intros t before after Hnot Hstep.
induction Hstep as [|e e' es es' Hstep Htail IH]; [reflexivity|].
cbn [event_waiters map List.concat] in Hnot.
destruct Hstep as [Ha [Hi [Ho [He Hr]]]].
assert (Hp:event_pending_addrs e'=event_pending_addrs e).
{ eapply remove_found_absent_eq__event_batch_step; [|exact Hr].
intro H; apply Hnot; apply in_or_app; left; exact H.
}
 assert (HtailEq:es'=es).
{ apply IH.
intro H; apply Hnot; apply in_or_app; right; exact H.
}
 subst es'.
f_equal.
destruct e,e'; cbn in *; subst; reflexivity.
Qed.
Lemma mutex_remove_absent__event_batch_step : forall t before after,
 ~In t(mutex_waiters before) -> mutex_remove_waiter_step t before after -> after=before.
Proof.
intros t before after Hnot Hstep.
induction Hstep as [|e e' es es' Hstep Htail IH]; [reflexivity|].
cbn [mutex_waiters map List.concat] in Hnot.
destruct Hstep as [Ha [Hi [Hv [Hr [Ho [Hh Hp]]]]]].
assert (Hpending:mutex_pending_addrs e'=mutex_pending_addrs e).
{ eapply remove_found_absent_eq__event_batch_step; [|exact Hp].
intro H; apply Hnot; apply in_or_app; left; exact H.
}
 assert (HtailEq:es'=es).
{ apply IH.
intro H; apply Hnot; apply in_or_app; right; exact H.
}
 subst es'.
f_equal.
destruct e,e'; cbn in *; subst; reflexivity.
Qed.
Lemma semaphore_remove_absent__event_batch_step : forall t before after,
 ~In t(semaphore_waiters before) -> semaphore_remove_waiter_step t before after -> after=before.
Proof.
intros t before after Hnot Hstep.
induction Hstep as [|e e' es es' Hstep Htail IH]; [reflexivity|].
cbn [semaphore_waiters map List.concat] in Hnot.
destruct Hstep as [Ha [Hi [Hv Hp]]].
assert (Hpending:semaphore_pending_addrs e'=semaphore_pending_addrs e).
{ eapply remove_found_absent_eq__event_batch_step; [|exact Hp].
intro H; apply Hnot; apply in_or_app; left; exact H.
}
 assert (HtailEq:es'=es).
{ apply IH.
intro H; apply Hnot; apply in_or_app; right; exact H.
}
 subst es'.
f_equal.
destruct e,e'; cbn in *; subst; reflexivity.
Qed.
Lemma event_remove_addresses__event_batch_step : forall t before after,
 event_remove_waiter_step t before after -> map event_addr after=map event_addr before.
Proof.
intros t before after H.
induction H; [reflexivity|].
cbn.
destruct H as [Ha _].
rewrite Ha,IHForall2.
reflexivity.
Qed.
Lemma event_waiters_member__event_batch_step : forall events e t,
 In e events -> In t(event_pending_addrs e) -> In t(event_waiters events).
Proof.
intros events e t He Ht.
unfold event_waiters.
apply in_concat.
exists(event_pending_addrs e).
split; [apply in_map;exact He|exact Ht].
Qed.
Lemma event_set_pending_absent__event_batch_step : forall es p rest,
 ~In p(map event_addr es) -> event_set_pending p rest es=es.
Proof.
induction es as [|e es IH]; intros p rest Hnot; [reflexivity|].
unfold event_set_pending in *.
cbn [map] in *.
destruct (Z.eq_dec(event_addr e)p); [exfalso; apply Hnot; left; exact e0|].
f_equal.
apply IH.
intuition.
Qed.
Lemma event_remove_head_frame__event_batch_step : forall t before after e rest,
 event_remove_waiter_step t before after ->
 NoDup(map event_addr before) -> NoDup(event_waiters before) ->
 In e before -> event_pending_addrs e=t::rest ->
 after=event_set_pending(event_addr e)rest before.
Proof.
intros t before after e rest Hstep.
revert e rest.
induction Hstep as [|a b xs ys Hstep Htail IH]; intros e rest Haddr Hwait Hin He; [contradiction|].
inversion Haddr as [|? ? Haddrnot HaddrTail]; subst.
change (NoDup(event_pending_addrs a ++ event_waiters xs)) in Hwait.
pose proof (NoDup_app_remove_r _ _ Hwait) as Hpend.
pose proof (NoDup_app_remove_l _ _ Hwait) as HwaitTail.
destruct Hstep as [Ha [Hi [Ho [Hv Hp]]]].
destruct Hin as [<-|Hin].
- assert(Hnot : ~In t(event_waiters xs)).
{ eapply nodup_app_disjoint__event_batch_step; [exact Hwait|rewrite He; left; reflexivity].
}
   pose proof (event_remove_absent__event_batch_step t xs ys Hnot Htail) as Hys.
subst ys.
assert (Hrest:event_pending_addrs b=rest).
{ rewrite He in Hp,Hpend.
eapply remove_found_deterministic; [exact Hpend|exact Hp|].
change (remove_found_prop t ([]++t::rest)([]++rest)).
apply remove_found_at_split.
}
   unfold event_set_pending.
cbn [map].
destruct(Z.eq_dec(event_addr a)(event_addr a)); [|contradiction].
assert(Hmap:map (fun e=>if Z.eq_dec(event_addr e)(event_addr a) then
     {|event_addr:=event_addr e;event_id:=event_id e;event_options:=event_options e;
       event_events:=event_events e;event_pending_addrs:=rest|} else e) xs=xs).
{ apply event_set_pending_absent__event_batch_step.
exact Haddrnot.
}
   rewrite Hmap.
f_equal.
destruct a,b; cbn in *; subst; reflexivity.
- assert(Htin:In t(event_waiters xs)).
{ eapply event_waiters_member__event_batch_step; [exact Hin|rewrite He; left; reflexivity].
}
   assert(Hnot:~In t(event_pending_addrs a)).
{ intro H.
exact (nodup_app_disjoint__event_batch_step _ _ _ t Hwait H Htin).
}
   pose proof (remove_found_absent_eq__event_batch_step _ t _ _ Hnot Hp) as Hpending.
assert(Hba:b=a) by (destruct a,b; cbn in *; subst; reflexivity).
subst b.
rewrite (IH e rest HaddrTail HwaitTail Hin He).
unfold event_set_pending.
cbn [map].
destruct(Z.eq_dec(event_addr a)(event_addr e)) as [Heq|Hne]; [|reflexivity].
exfalso.
apply Haddrnot.
rewrite Heq.
apply in_map; exact Hin.
Qed.
Lemma event_set_pending_at__event_batch_step : forall id p waiting st rest,
 event_pending_at id p waiting st ->
 event_pending_at id p rest (replace_events(event_set_pending p rest(os_events st))st).
Proof.
intros id p waiting st rest [e [Hin [Ha [Hi Hp]]]].
unfold event_pending_at.
cbn [replace_events].
exists {|event_addr:=event_addr e;event_id:=event_id e;event_options:=event_options e;
 event_events:=event_events e;event_pending_addrs:=rest|}.
split.
- unfold event_set_pending.
apply in_map_iff.
exists e.
split; [|exact Hin].
destruct(Z.eq_dec(event_addr e)p); [reflexivity|contradiction].
- cbn.
auto.
Qed.
Lemma nodup_concat_member__event_batch_step : forall A (ls:list(list A)) l,
 NoDup(List.concat ls) -> In l ls -> NoDup l.
Proof.
intros A ls.
induction ls as [|a ls IH]; intros l Hnd Hin; [contradiction|].
cbn in Hnd.
destruct Hin as [<-|Hin].
- eapply NoDup_app_remove_r; exact Hnd.
- apply IH; [eapply NoDup_app_remove_l;exact Hnd|exact Hin].
Qed.
Lemma event_pending_nodup__event_batch_step : forall sg st id p waiting,
 os_world_wf sg st -> event_pending_at id p waiting st -> NoDup waiting.
Proof.
intros sg st id p waiting Hw [e [Hin [Ha [Hi Hp]]]].
pose proof (os_wf_sched_nodup _ _ Hw) as Hnd.
unfold os_sched_owners in Hnd.
repeat match type of Hnd with NoDup(?a++?b) =>
  apply NoDup_app_remove_l in Hnd end.
unfold event_waiters in Hnd.
rewrite <- Hp.
eapply nodup_concat_member__event_batch_step; [exact Hnd|apply in_map; exact Hin].
Qed.
Lemma event_task_other_queues_absent__event_batch_step : forall sg st id p t rest,
 os_world_wf sg st -> event_pending_at id p(t::rest)st ->
 ~In t(sched_owned_tasks(os_tasks st)) /\
 ~In t(semaphore_waiters(os_semaphores st)) /\
 ~In t(mutex_waiters(os_mutexes st)) /\ NoDup(event_waiters(os_events st)).
Proof.
intros sg st id p t rest Hw [e [Hin [Ha [Hi Hp]]]].
assert(Htin:In t(event_waiters(os_events st))).
{ eapply event_waiters_member__event_batch_step; [exact Hin|rewrite Hp;left;reflexivity].
}
 pose proof (os_wf_sched_nodup _ _ Hw) as Hnd.
unfold os_sched_owners in Hnd.
repeat rewrite app_assoc in Hnd.
pose proof (NoDup_app_remove_l _ _ Hnd) as Hev.
assert(Hnot:~In t (sched_owned_tasks(os_tasks st) ++
  map (@getData addr)(os_ready_nodes(orvBuckets(assignReadyVector(os_assign st)))) ++
  map (@getData addr)(zombie_nodes(zombie_queue st)) ++
  semaphore_waiters(os_semaphores st) ++ mutex_waiters(os_mutexes st))).
{ intro H.
repeat rewrite app_assoc in H.
exact (nodup_app_disjoint__event_batch_step _ _ _ t Hnd H Htin).
}
 repeat rewrite in_app_iff in Hnot.
tauto.
Qed.
Lemma event_wakeup_exact_frame__event_batch_step : forall sg current marked after id p t rest d,
 os_world_wf sg current -> event_pending_at id p(t::rest)current ->
 marked=replace_task_desc_map(update_task_desc_map t (set_task_desc_exstatus d (-1))
  (task_desc_map(os_tasks current)))current ->
 ktask_wakeup_step t (set_task_desc_exstatus d (-1)) marked after ->
 NoDup(map event_addr(os_events current)) ->
 after=replace_events(event_set_pending p rest(os_events current))
  (replace_global_ready_vector(assignReadyVector(os_assign after))
   (replace_global_delays(os_delays after)
    (replace_task_desc_map(update_task_desc_map t (set_task_desc_ready(set_task_desc_exstatus d (-1)))
      (task_desc_map(os_tasks current)))current))).
Proof.
intros sg current marked after id p t rest d Hw Hpending Hmarked Hstep Haddr.
pose proof(event_task_other_queues_absent__event_batch_step sg current id p t rest Hw Hpending)
 as [Howned [Hsem [Hmutex Hndev]]].
subst marked.
destruct Hstep as [Hready Hmap Hown Hids Hptrs Hrun Hprio Hdelay Hevent Hmu Hse Htick Hzombie Hrec Hidle Hisr Hex].
cbn [replace_task_desc_map] in *.
assert(HownEq:sched_owned_tasks(os_tasks after)=sched_owned_tasks(os_tasks current)).
{ eapply remove_found_absent_eq__event_batch_step; eauto.
}
 assert(HmuEq:os_mutexes after=os_mutexes current).
{ eapply mutex_remove_absent__event_batch_step; eauto.
}
 assert(HseEq:os_semaphores after=os_semaphores current).
{ eapply semaphore_remove_absent__event_batch_step; eauto.
}
 assert(HeventEq:os_events after=event_set_pending p rest(os_events current)).
{ destruct Hpending as [e [Hin [Ha [Hi Hp]]]].
rewrite <- Ha.
eapply event_remove_head_frame__event_batch_step; eauto.
}
 assert(HmapEq:task_desc_map(os_tasks after)=
  update_task_desc_map t (set_task_desc_ready(set_task_desc_exstatus d (-1)))(task_desc_map(os_tasks current))).
{ rewrite Hmap.
apply functional_extensionality.
intro x.
unfold update_task_desc_map.
cbn [replace_task_desc_map task_desc_map os_tasks].
destruct(Z.eq_dec x t); reflexivity.
} destruct current,after.
destruct os_tasks,os_tasks0,os_assign,os_assign0.
cbn in *.
subst.
rewrite HmapEq.
reflexivity.
Qed.
Lemma resume_task_map_nil__event_batch_step : forall T, resume_all_task_map T []=T.
Proof.
intro T.
apply functional_extensionality.
intro x.
unfold resume_all_task_map.
destruct(T x); reflexivity.
Qed.
Lemma resume_delays_nil__event_batch_step : forall T ds, resume_all_delays T [] ds=ds.
Proof.
intros T [m nodes].
unfold resume_all_delays.
cbn.
assert(Hfilter:filter(fun _ : DL_Node TaskDelayAbs=>true)nodes=nodes).
{ induction nodes; cbn; congruence.
}
 rewrite Hfilter.
reflexivity.
Qed.
Lemma event_set_pending_compose__event_batch_step : forall p xs ys es,
 event_set_pending p ys(event_set_pending p xs es)=event_set_pending p ys es.
Proof.
intros p xs ys es.
induction es as [|e es IH]; [reflexivity|].
unfold event_set_pending in *.
cbn [map].
destruct(Z.eq_dec(event_addr e)p); cbn; rewrite IH;
 destruct(Z.eq_dec(event_addr e)p); try contradiction; reflexivity.
Qed.
Lemma event_batch_pure_compose__event_batch_step : forall current p t rest d r1 ds1 final,
 task_desc_map(os_tasks current)t=Some d ->
 tsmStat(tdSchedMember d)=TSK_SUSPEND ->
 NoDup(t::rest) ->
 assign_insert_step_ic (update_task_desc_map t (set_task_desc_exstatus d (-1))(task_desc_map(os_tasks current)))
 t (set_task_desc_exstatus d (-1))(assignReadyVector(os_assign current))r1 ->
 resume_all_delays
  (update_task_desc_map t (set_task_desc_ready(set_task_desc_exstatus d (-1)))(task_desc_map(os_tasks current)))
  rest ds1 = resume_all_delays(task_desc_map(os_tasks current))(t::rest)(os_delays current) ->
 event_resume_all_effect p rest
  (replace_events(event_set_pending p rest(os_events current))
   (replace_global_ready_vector r1 (replace_global_delays ds1
    (replace_task_desc_map(update_task_desc_map t (set_task_desc_ready(set_task_desc_exstatus d (-1)))
      (task_desc_map(os_tasks current)))current)))) final ->
 event_resume_all_effect p(t::rest)current final.
Proof.
intros current p t rest d r1 ds1 final Hd Hs Hnd Hready Hdelay Htail.
assert(Hnot:~In t rest) by (inversion Hnd; assumption).
destruct rest as [|a rest].
- cbn [event_resume_all_effect] in Htail.
subst final.
cbn [event_resume_all_effect].
split; [exact Hnd|].
split.
+ constructor; [exists d;auto|constructor].
+ exists r1.
split.
* eapply ready_head_compose__event_batch_step; [exact Hd|exact Hnot|exact Hready|].
unfold resume_all_ready; reflexivity.
* rewrite <- (resume_task_map_cons__event_batch_step _ _ _ [] Hd), resume_task_map_nil__event_batch_step.
rewrite resume_delays_nil__event_batch_step in Hdelay.
rewrite <- Hdelay.
reflexivity.
- cbn [event_resume_all_effect] in Htail.
destruct Htail as [Hndrest [Hregs [rf [Hrf Hfinal]]]].
change (Forall (fun x=>exists q,
    update_task_desc_map t (set_task_desc_ready(set_task_desc_exstatus d (-1)))
     (task_desc_map(os_tasks current)) x=Some q /\ tsmStat(tdSchedMember q)=TSK_SUSPEND)(a::rest)) in Hregs.
change (resume_all_ready
     (update_task_desc_map t (set_task_desc_ready(set_task_desc_exstatus d (-1)))(task_desc_map(os_tasks current)))
     (a::rest) r1 rf) in Hrf.
cbn [event_resume_all_effect].
split; [exact Hnd|].
split.
+ constructor; [exists d;auto|].
rewrite Forall_forall in *.
intros x Hx.
destruct(Hregs x Hx) as [q [Hq Hstat]].
exists q.
split; [|exact Hstat].
unfold update_task_desc_map in Hq.
destruct(Z.eq_dec x t) as [->|Hne]; [contradiction|exact Hq].
+ exists rf.
split.
* eapply ready_head_compose__event_batch_step; eauto.
* change (final =
       replace_events(event_set_pending p [] (event_set_pending p (a::rest)(os_events current)))
        (replace_global_ready_vector rf
         (replace_global_delays
          (resume_all_delays
           (update_task_desc_map t (set_task_desc_ready(set_task_desc_exstatus d (-1)))(task_desc_map(os_tasks current)))
            (a::rest)ds1)
          (replace_task_desc_map
           (resume_all_task_map
            (update_task_desc_map t (set_task_desc_ready(set_task_desc_exstatus d (-1)))(task_desc_map(os_tasks current)))
            (a::rest))current)))) in Hfinal.
rewrite event_set_pending_compose__event_batch_step,
        (resume_task_map_cons__event_batch_step _ _ _ (a::rest) Hd),Hdelay in Hfinal.
exact Hfinal.
Qed.
Lemma os_task_buckets_pure__event_batch_step : forall sg st,
 os_inv sg st |-- “ idbuckets_ok
 (idmax(task_stable_ids(os_task_stable sg)))(hoffset(task_stable_ids(os_task_stable sg)))
 (idlist(task_idmanager_abs(os_tasks st)))(idbuckets(task_idmanager_abs(os_tasks st))) ”.
Proof.
intros sg st.
unfold os_inv,task_inv.
Intros.
prop_apply_p (idmanager_buckets_pure__event_batch_step
  (task_stable_ids(os_task_stable sg))(task_idmanager_abs(os_tasks st))(task_idmanager_ptr(os_task_stable sg))).
Intros_p Hib.
dump_pre_spatial.
exact Hib.
Qed.
Lemma event_batch_after_head__event_batch_step : forall sg id p current marked after t rest desc task returned_desc tid,
 event_pending_at id p(t::rest)current ->
 task_desc_map(os_tasks current)t=Some desc ->
 tsmStat(tdSchedMember desc)=TSK_SUSPEND ->
 marked=replace_task_desc_map(update_task_desc_map t(set_task_desc_exstatus desc(-1))(task_desc_map(os_tasks current)))current ->
 os_world_wf sg current -> task_world_wf current ->
 os_world_wf sg marked -> task_world_wf marked ->
 get_task_with_idnode_success sg marked tid t ->
 get_task_with_idnode_success sg marked tid task ->
 ktask_wakeup_step task returned_desc marked after ->
 os_inv sg after |-- “ event_pending_at id p rest after /\
   forall final, event_resume_all_effect p rest after final ->
   event_resume_all_effect p(t::rest)current final ”.
Proof.
intros sg id p current marked after t rest desc task returned_desc tid
 Hp Hd Hstat Hmarked Hw Htw Hwm Htwm Htarget Htask Hstep.
prop_apply_p (os_task_buckets_pure__event_batch_step sg after).
Intros_p Hbucket.
pose proof (wakeup_task_ids _ _ _ _ Hstep) as Hids.
rewrite Hids in Hbucket.
pose proof (task_lookup_same__event_batch_step sg marked tid t task Hbucket Htarget Htask) as Hsame.
subst task.
pose proof (wakeup_ready _ _ _ _ Hstep) as Hready.
destruct Hready as [[Hregistered _] _].
rewrite Hmarked in Hregistered.
change (update_task_desc_map t(set_task_desc_exstatus desc(-1))(task_desc_map(os_tasks current)) t=Some returned_desc) in Hregistered.
unfold update_task_desc_map in Hregistered.
destruct(Z.eq_dec t t); [|contradiction].
injection Hregistered as Hdesc.
subst returned_desc.
prop_apply_p (event_addresses_nodup__event_batch_step sg after).
Intros_p HaddrAfter.
prop_apply_p (delay_nonoverlap__event_batch_step sg after).
Intros_p HdelayApart.
assert(Haddr:NoDup(map event_addr(os_events current))).
{ pose proof(event_remove_addresses__event_batch_step _ _ _ (wakeup_events _ _ _ _ Hstep)) as Heq.
rewrite Hmarked in Heq.
change (map event_addr(os_events after)=map event_addr(os_events current)) in Heq.
rewrite <-Heq.
exact HaddrAfter.
}
 pose proof(event_wakeup_exact_frame__event_batch_step sg current marked after id p t rest desc Hw Hp Hmarked Hstep Haddr) as Hframe.
assert(Hpending:event_pending_at id p rest after).
{ rewrite Hframe.
exact (event_set_pending_at__event_batch_step id p (t::rest)current rest Hp).
}
 pose proof(event_pending_nodup__event_batch_step sg current id p(t::rest) Hw Hp) as Hnd.
assert(Hready0:assign_insert_step_ic
  (update_task_desc_map t(set_task_desc_exstatus desc(-1))(task_desc_map(os_tasks current)))
  t(set_task_desc_exstatus desc(-1))(assignReadyVector(os_assign current))(assignReadyVector(os_assign after))).
{ pose proof(wakeup_ready _ _ _ _ Hstep) as H.
rewrite Hmarked in H.
exact H.
}
 assert(Hdelays:resume_all_delays
  (update_task_desc_map t(set_task_desc_ready(set_task_desc_exstatus desc(-1)))(task_desc_map(os_tasks current)))
   rest(os_delays after)=resume_all_delays(task_desc_map(os_tasks current))(t::rest)(os_delays current)).
{ assert(Hobs:forall x,option_map tdDelay
    (update_task_desc_map t(set_task_desc_ready(set_task_desc_exstatus desc(-1)))(task_desc_map(os_tasks current))x)=
    option_map tdDelay(task_desc_map(os_tasks current)x)).
{ intro x.
unfold update_task_desc_map.
destruct(Z.eq_dec x t) as [->|Hne]; [rewrite Hd|]; reflexivity.
}
   rewrite (resume_delays_observation__event_batch_step rest _ _ _ Hobs).
destruct(wakeup_delays _ _ _ _ Hstep) as [mid [Hunset Hmid]].
rewrite Hmid.
assert(Hapart:forall p info,delay_inactive_map(os_delays mid)p=Some info ->
    ~In (&(p # "Delay" ->ₛ "link"))(map (@getPtr TaskDelayAbs)(delay_active_nodes(os_delays mid)))).
{ rewrite <-Hmid.
exact HdelayApart.
}
   pose proof(resume_delays_unset_compose__event_batch_step
    (task_desc_map(os_tasks current)) t desc rest marked mid Hd Hunset Hapart) as Hcompose.
rewrite Hmarked in Hcompose.
exact Hcompose.
}
 dump_pre_spatial.
split; [exact Hpending|].
intros final Hfinal.
eapply event_batch_pure_compose__event_batch_step with
  (d:=desc)(r1:=assignReadyVector(os_assign after))(ds1:=os_delays after);
  [exact Hd|exact Hstat|exact Hnd|exact Hready0|exact Hdelays|].
rewrite <-Hframe.
exact Hfinal.
Qed.
