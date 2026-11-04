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


Require Import Coq.Sorting.Permutation Coq.micromega.Lia.
Require Import Coq.Logic.FunctionalExtensionality.
Require Import Coq.micromega.Lia.
From Coq Require Import Logic.FunctionalExtensionality Logic.PropExtensionality.
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
Lemma remove_absent_eq__import_detached_refinement {A} (x : A) old new :
  ~ In x old -> remove_found_prop x old new -> new = old.
Proof.
  intros Habs [[_ Heq]|[p [s [Heq Hnew]]]]; [symmetry; exact Heq|].
  exfalso; apply Habs. rewrite Heq. apply in_or_app; right; now left.
Qed.
Lemma event_remove_absent__import_detached_refinement task old new :
  ~ In task (event_waiters old) -> event_remove_waiter_step task old new -> new = old.
Proof.
  intros Habs Hstep. induction Hstep as [|x y xs ys Hxy Hrest IH].
  - reflexivity.
  - unfold event_waiters in Habs; simpl in Habs; rewrite in_app_iff in Habs.
    destruct Hxy as [Ha [Hi [Ho [He Hp]]]].
    pose proof (remove_absent_eq__import_detached_refinement task (event_pending_addrs x) (event_pending_addrs y) ltac:(tauto) Hp) as Hpeq.
    assert (y = x) by (destruct x, y; simpl in *; subst; reflexivity).
    subst y. f_equal. apply IH. unfold event_waiters; tauto.
Qed.
Lemma mutex_remove_absent__import_detached_refinement task old new :
  ~ In task (mutex_waiters old) -> mutex_remove_waiter_step task old new -> new = old.
Proof.
  intros Habs Hstep. induction Hstep as [|x y xs ys Hxy Hrest IH].
  - reflexivity.
  - unfold mutex_waiters in Habs; simpl in Habs; rewrite in_app_iff in Habs.
    destruct Hxy as [Ha [Hi [Hv [Hrc [Hp [Hh Hr]]]]]].
    pose proof (remove_absent_eq__import_detached_refinement task (mutex_pending_addrs x) (mutex_pending_addrs y) ltac:(tauto) Hr) as Hpeq.
    assert (y = x) by (destruct x, y; simpl in *; subst; reflexivity).
    subst y. f_equal. apply IH. unfold mutex_waiters; tauto.
Qed.
Lemma semaphore_remove_absent__import_detached_refinement task old new :
  ~ In task (semaphore_waiters old) -> semaphore_remove_waiter_step task old new -> new = old.
Proof.
  intros Habs Hstep. induction Hstep as [|x y xs ys Hxy Hrest IH].
  - reflexivity.
  - unfold semaphore_waiters in Habs; simpl in Habs; rewrite in_app_iff in Habs.
    destruct Hxy as [Ha [Hi [Hv Hr]]].
    pose proof (remove_absent_eq__import_detached_refinement task (semaphore_pending_addrs x) (semaphore_pending_addrs y) ltac:(tauto) Hr) as Hpeq.
    assert (y = x) by (destruct x, y; simpl in *; subst; reflexivity).
    subst y. f_equal. apply IH. unfold semaphore_waiters; tauto.
Qed.
Lemma generic_wakeup_detached_null__import_detached_refinement sg task desc before after :
  os_world_wf sg before ->
  desc.(tdDelay) = 0 ->
  In task before.(os_tasks).(sched_owned_tasks) ->
  ktask_wakeup_step task desc before after ->
  ktask_wakeup_detached_null_step task desc before after.
Proof.
  intros Hwf Hdelay Howned Hstep.
  pose proof (sched_owned_not_waiting sg before task Hwf Howned) as Habs.
  rewrite !in_app_iff in Habs.
  destruct Hstep as [Hr Hmap Hown Hids Hptr Hrunn Hprio Hd He Hm Hs Htick Hz Hrec Hi Hisr Hex].
  constructor; try assumption.
  - destruct Hown as [[Hnot _]|Hsplit]; [contradiction|exact Hsplit].
  - destruct Hd as [d [Hd Heq]]. unfold ktask_unset_delay_step in Hd.
    rewrite Hdelay in Hd. destruct Hd as [[_ ->]|[[Hfalse _]|[Hfalse _]]]; try contradiction; exact Heq.
  - eapply (event_remove_absent__import_detached_refinement task (os_events before) (os_events after)); [tauto|exact He].
  - eapply (mutex_remove_absent__import_detached_refinement task (os_mutexes before) (os_mutexes after)); [tauto|exact Hm].
  - eapply (semaphore_remove_absent__import_detached_refinement task (os_semaphores before) (os_semaphores after)); [tauto|exact Hs].
Qed.
Lemma os_world_extract__import_detached_refinement sg st :
  os_inv sg st |-- “ os_world_wf sg st ”.
Proof. unfold os_inv. Intros_p Hwf. dump_pre_spatial. exact Hwf. Qed.
Lemma dllseg_payload_borrow__pending_head_access : forall (A : Type) (storeA : addr -> A -> Assertion) (x px y py : addr) (l1 l2 : list (DL_Node A)) (e : DL_Node A), dllseg storeA x px y py (l1 ++ e :: l2) |-- storeA e.(ptr) e.(data) ** (storeA e.(ptr) e.(data) -* dllseg storeA x px y py (l1 ++ e :: l2)).
Proof.
intros.
pose proof (dllseg_split storeA x px y py l1 (e::l2)) as Hsplit.
rewrite Hsplit at 1.
clear Hsplit.
Intros q pq.
simpl dllseg at 2.
Intros z.
subst q.
cancel (storeA e.(ptr) e.(data)).
apply_sepcon_adjoint.
sep_apply_r_atomic (dllseg_concat storeA x px e.(ptr) pq y py l1 (e::l2)).
simpl dllseg at 4.
Exists z.
split_pure_spatial.
- cancel.
cancel (storeA e.(ptr) e.(data)).
cancel (dllseg storeA x px e.(ptr) pq l1).
cancel (dllseg storeA z e.(ptr) y py l2).
match goal with |- ?P ** _ |-- _ => cancel P end.
match goal with |- ?P |-- _ => cancel P end.
- dump_pre_spatial.
reflexivity.
Qed.
Lemma dll_payload_borrow__pending_head_access : forall (A : Type) (storeA : addr -> A -> Assertion) (head : addr) (l : list (DL_Node A)) (e : DL_Node A), In e l -> store_dll storeA head l |-- storeA e.(ptr) e.(data) ** (storeA e.(ptr) e.(data) -* store_dll storeA head l).
Proof.
intros A storeA head l e Hin.
apply in_split in Hin.
destruct Hin as [l1 [l2 Hl]].
subst l.
unfold store_dll at 1.
Intros h pt.
sep_apply_l_atomic (dllseg_payload_borrow__pending_head_access A storeA h head head pt l1 l2 e).
cancel (storeA e.(ptr) e.(data)).
apply_sepcon_adjoint.
sep_apply_l_atomic (derivable1_wand_elim1 (storeA e.(ptr) e.(data)) (dllseg storeA h head head pt (l1 ++ e :: l2))).
unfold store_dll.
Exists h pt.
split_pure_spatial.
- repeat match goal with |- _ |-- ?P ** _ => cancel P | |- ?P |-- _ => cancel P end.
sepcon_assoc_change.
repeat match goal with |- _ |-- ?P ** _ => cancel P | |- ?P |-- _ => cancel P end.
- dump_pre_spatial.
auto.
Qed.
Lemma dll_head_borrow__pending_head_access : forall (A : Type) (storeA : addr -> A -> Assertion) (head : addr) (l : list (DL_Node A)), store_dll storeA head l |-- EX next, “ (match l with nil => next = head | a :: _ => next = a.(ptr) /\ next <> head end) ” && (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next) ** ((&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next) -* store_dll storeA head l).
Proof.
intros.
unfold store_dll at 1.
Intros h pt.
destruct l as [|a l].
- simpl dllseg at 1.
Intros.
destruct H0.
subst h pt.
Exists head.
split_pure_spatial.
+ cancel (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> head).
apply_sepcon_adjoint.
unfold store_dll.
Exists head head.
simpl dllseg.
split_pure_spatial.
* sepcon_assoc_change.
repeat match goal with |- _ |-- ?P ** _ => cancel P | |- ?P |-- _ => cancel P end.
* split_pures; dump_pre_spatial; tauto.
+ dump_pre_spatial.
reflexivity.
- simpl dllseg at 1.
Intros z.
subst h.
destruct (Z.eq_dec a.(ptr) head) as [Heq|Hneq].
+ rewrite Heq.
sep_apply_l_atomic (dup_store_ptr (&(head # "SysDoubleLinklistNode" ->ₛ "node_next")) z head).
Intros.
contradiction.
+ Exists a.(ptr).
split_pure_spatial.
* match goal with |- _ |-- ?P ** _ => cancel P end.
apply_sepcon_adjoint.
unfold store_dll.
Exists a.(ptr) pt.
simpl dllseg.
Exists z.
split_pure_spatial.
-- sepcon_assoc_change.
repeat match goal with |- _ |-- ?P ** _ => cancel P | |- ?P |-- _ => cancel P end.
-- split_pures; dump_pre_spatial; tauto.
* dump_pre_spatial.
auto.
Qed.
Lemma pending_head_borrow__pending_head_access : forall id p remaining sg st head, head = event_pending_head p -> event_pending_at id p remaining st -> os_inv sg st |-- EX next, “ (match remaining with nil => next = head | first :: _ => next = sched_link_of first /\ next <> head end) ” && (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next) ** event_resume_next_restore sg st head next.
Proof.
intros id p remaining sg st head Hhead [e [Hin [Haddr [Hid Hremaining]]]].
unfold os_inv at 1.
cbv zeta.
Intros.
unfold event_inv at 1.
Intros.
pose proof (in_map event_link_node (os_events st) e Hin) as Hmember.
sep_apply_l_atomic (dll_payload_borrow__pending_head_access EventAbs (store_event (pure_suspend_sched_link (task_desc_map (os_tasks st)))) (event_list_head (os_event_stable sg)) (map event_link_node (os_events st)) (event_link_node e) Hmember).
cbn [event_link_node getPtr getData].
unfold store_event at 1.
cbv zeta.
Intros.
subst p remaining.
unfold event_pending_head in Hhead.
rewrite <- Hhead.
sep_apply_l_atomic (dll_head_borrow__pending_head_access addr (pure_suspend_sched_link (task_desc_map (os_tasks st))) head (map event_wait_node (event_pending_addrs e))).
Intros next.
Exists next.
split_pure_spatial.
- cancel (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next).
unfold event_resume_next_restore.
apply_sepcon_adjoint.
sep_apply_l_atomic (derivable1_wand_elim1 (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next) (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st))) head (map event_wait_node (event_pending_addrs e)))).
unfold os_inv, event_inv.
cbv zeta.
split_pure_spatial.
+ sepcon_assoc_change.
repeat match goal with |- _ |-- ?P ** _ => cancel P end.
sep_apply_r_atomic (derivable1_wand_elim1 (store_event (pure_suspend_sched_link (task_desc_map (os_tasks st))) (getPtr (event_link_node e)) e) (store_dll (store_event (pure_suspend_sched_link (task_desc_map (os_tasks st)))) (event_list_head (os_event_stable sg)) (map event_link_node (os_events st)))).
cbn [event_link_node getPtr].
match goal with |- _ |-- ?P ** _ => cancel P end.
unfold store_event.
cbv zeta.
rewrite <- Hhead.
split_pure_spatial.
* sepcon_assoc_change.
repeat match goal with |- _ |-- ?P ** _ => cancel P | |- ?P |-- _ => cancel P end.
* dump_pre_spatial.
exact H1.
+ split_pures; dump_pre_spatial; assumption.
- dump_pre_spatial.
destruct (event_pending_addrs e); exact H2.
Qed.
Lemma lookup_old__exstatus_write_view : forall T target desc value task new,
  T target = Some desc ->
  update_task_desc_map target (set_task_desc_exstatus desc value) T task = Some new ->
  exists old, T task = Some old /\ tdBaseInfo old = tdBaseInfo new /\
    tdSchedMember old = tdSchedMember new /\ tdDelay old = tdDelay new.
Proof.
  intros T target desc value task new HT Hnew.
  unfold update_task_desc_map in Hnew.
  destruct (Z.eq_dec task target) as [->|Hneq].
  - inversion Hnew; subst new. exists desc; auto.
  - exists new; auto.
Qed.
Lemma lookup_new__exstatus_write_view : forall T target desc value task old,
  T target = Some desc -> T task = Some old ->
  exists new, update_task_desc_map target (set_task_desc_exstatus desc value) T task = Some new /\
    tdBaseInfo old = tdBaseInfo new /\ tdSchedMember old = tdSchedMember new /\
    tdDelay old = tdDelay new.
Proof.
  intros T target desc value task old HT Hold.
  unfold update_task_desc_map.
  destruct (Z.eq_dec task target) as [->|Hneq].
  - rewrite HT in Hold; inversion Hold; subst old.
    exists (set_task_desc_exstatus desc value); auto.
  - exists old; auto.
Qed.
Lemma task_wf_update__exstatus_write_view : forall st target desc value,
  st.(os_tasks).(task_desc_map) target = Some desc -> task_world_wf st ->
  task_world_wf (replace_task_desc_map
    (update_task_desc_map target (set_task_desc_exstatus desc value) st.(os_tasks).(task_desc_map)) st).
Proof.
  intros st target desc value HT HW. destruct HW as [Hmap Howned Hid Hprio Halign Hrun Hinit].
  constructor; cbn.
  - intros task new Hnew. destruct (lookup_old__exstatus_write_view _ _ _ _ _ _ HT Hnew) as [old [Hlookup _]]. eauto.
  - intros task new Hnew Hstatus. destruct (lookup_old__exstatus_write_view _ _ _ _ _ _ HT Hnew) as [old [Hlookup [_ [Hs _]]]]. rewrite <- Hs in Hstatus. eauto.
  - exact Hid.
  - intros task new Hnew. destruct (lookup_old__exstatus_write_view _ _ _ _ _ _ HT Hnew) as [old [Hlookup [Hb [Hs _]]]]. rewrite <- Hb, <- Hs. eauto.
  - intros task new Hnew. destruct (lookup_old__exstatus_write_view _ _ _ _ _ _ HT Hnew) as [old [Hlookup _]]. eauto.
  - intros task new Hnew Hstatus. destruct (lookup_old__exstatus_write_view _ _ _ _ _ _ HT Hnew) as [old [Hlookup [_ [Hs _]]]]. rewrite <- Hs in *. eauto.
  - intros task new Hnew Hstatus. destruct (lookup_old__exstatus_write_view _ _ _ _ _ _ HT Hnew) as [old [Hlookup [_ [Hs _]]]]. rewrite <- Hs in *. eauto.
Qed.
Lemma service_update__exstatus_write_view : forall st target desc value entry slot,
  st.(os_tasks).(task_desc_map) target = Some desc -> service_slot_wf st entry slot ->
  service_slot_wf (replace_task_desc_map
    (update_task_desc_map target (set_task_desc_exstatus desc value) st.(os_tasks).(task_desc_map)) st) entry slot.
Proof.
  intros st target desc value entry slot HT. unfold service_slot_wf.
  destruct (service_phase slot); auto. intros [old HW].
  destruct HW as [Hl He Hd Ho Hi].
  destruct (lookup_new__exstatus_write_view _ _ _ value _ _ HT Hl) as [new [Hn [Hb [Hs Hdelay]]]].
  exists new; constructor; cbn; try assumption.
  - rewrite <- Hb; assumption.
  - rewrite <- Hdelay; assumption.
  - rewrite <- Hs; assumption.
Qed.
Lemma world_update__exstatus_write_view : forall sg st target desc value,
  st.(os_tasks).(task_desc_map) target = Some desc -> os_world_wf sg st ->
  os_world_wf sg (replace_task_desc_map
    (update_task_desc_map target (set_task_desc_exstatus desc value) st.(os_tasks).(task_desc_map)) st).
Proof.
  intros sg st target desc value HT HW. destruct HW as [Hctx Hr Hi Hn Hd].
  constructor; cbn.
  - exact Hctx.
  - apply service_update__exstatus_write_view; assumption.
  - rewrite Forall_forall in *. intros slot Hslot.
    apply service_update__exstatus_write_view; auto.
  - exact Hn.
  - intro task. change (In task (os_sched_owners st) <->
      update_task_desc_map target (set_task_desc_exstatus desc value) (task_desc_map (os_tasks st)) task <> None).
    rewrite Hd. unfold update_task_desc_map.
    destruct (Z.eq_dec task target) as [->|Hneq]; [rewrite HT; split; congruence|tauto].
Qed.
Lemma delay_update__exstatus_write_view : forall T target desc value inactive active,
  T target = Some desc -> delay_world_wf T inactive active ->
  delay_world_wf (update_task_desc_map target (set_task_desc_exstatus desc value) T) inactive active.
Proof.
  intros T target desc value inactive active HT HW. destruct HW as [Hz Hi Ha Hsort Hstatus].
  constructor; try assumption.
  - intros task new Hnew. destruct (lookup_old__exstatus_write_view _ _ _ _ _ _ HT Hnew) as [old [Hl [_ [_ Hd]]]]. rewrite <- Hd. eauto.
  - intros d info Hl. destruct (Hi d info Hl) as [old [Hlookup Hd]].
    destruct (lookup_new__exstatus_write_view _ _ _ value _ _ HT Hlookup) as [new [Hn [_ [_ Heq]]]].
    exists new; split; [exact Hn|congruence].
  - intros node Hin. destruct (Ha node Hin) as [old [Hlookup Hd]].
    destruct (lookup_new__exstatus_write_view _ _ _ value _ _ HT Hlookup) as [new [Hn [_ [_ Heq]]]].
    exists new; split; [exact Hn|rewrite <- Heq; exact Hd].
Qed.
Lemma ready_buckets_update__exstatus_write_view : forall T target desc value buckets i,
  T target = Some desc -> priority_ready_buckets_task_ok T i buckets ->
  priority_ready_buckets_task_ok (update_task_desc_map target (set_task_desc_exstatus desc value) T) i buckets.
Proof.
  intros T target desc value buckets. induction buckets as [|bucket rest IH]; intros i HT HW; cbn in *; auto.
  destruct HW as [Hb Hr]. split; [|apply IH; assumption].
  rewrite Forall_forall in *. intros node Hin. specialize (Hb node Hin).
  unfold ready_node_at_priority_ok, ready_node_task_desc in *.
  destruct Hb as [old [[Hnonzero [Hlink Hl]] Hprops]].
  destruct (lookup_new__exstatus_write_view _ _ _ value _ _ HT Hl) as [new [Hn [_ [Hs _]]]].
  exists new. rewrite <- Hs. auto.
Qed.
Lemma assign_update__exstatus_write_view : forall T target desc value state,
  T target = Some desc -> assign_world_wf T state ->
  assign_world_wf (update_task_desc_map target (set_task_desc_exstatus desc value) T) state.
Proof.
  intros T target desc value state HT [Hr Hv]. constructor.
  - destruct Hr as [Hz|[old Hl]]; [left; exact Hz|right].
    destruct (lookup_new__exstatus_write_view _ _ _ value _ _ HT Hl) as [new [Hn _]]. eauto.
  - destruct Hv as [Hb [Hg Hh]]. split; [|auto].
    unfold priority_ready_buckets_ok in *. apply ready_buckets_update__exstatus_write_view; assumption.
Qed.
Lemma slink_update_eq__exstatus_write_view : forall T target desc value status,
  T target = Some desc ->
  pure_published_slink T status =
  pure_published_slink (update_task_desc_map target (set_task_desc_exstatus desc value) T) status.
Proof.
  intros T target desc value status HT.
  apply functional_extensionality; intro link.
  apply functional_extensionality; intro task.
  apply functional_extensionality; intro heap.
  apply propositional_extensionality.
  change ((exists old, (T task = Some old /\ link = sched_link_of task /\ tsmStat (tdSchedMember old) = status) /\ emp heap) <->
    (exists new, (update_task_desc_map target (set_task_desc_exstatus desc value) T task = Some new /\ link = sched_link_of task /\ tsmStat (tdSchedMember new) = status) /\ emp heap)).
  split; intros [d [[Hl [Hlink Hstatus]] Hemp]].
  - destruct (lookup_new__exstatus_write_view _ _ _ value _ _ HT Hl) as [new [Hn [_ [Hs _]]]].
    exists new; rewrite <- Hs; auto.
  - destruct (lookup_old__exstatus_write_view _ _ _ _ _ _ HT Hl) as [old [Ho [_ [Hs _]]]].
    exists old; rewrite Hs; auto.
Qed.
Lemma detached_update_eq__exstatus_write_view : forall T target desc value,
  T target = Some desc ->
  store_detached_sched_link T =
  store_detached_sched_link (update_task_desc_map target (set_task_desc_exstatus desc value) T).
Proof.
  intros T target desc value HT.
  apply functional_extensionality; intro task.
  apply functional_extensionality; intro heap.
  apply propositional_extensionality.
  change ((exists old, (T task = Some old /\
    (tsmStat (tdSchedMember old) = TSK_INIT \/ tsmStat (tdSchedMember old) = TSK_RUNNING \/ tsmStat (tdSchedMember old) = TSK_SUSPEND)) /\ store_node_self_linked (sched_link_of task) heap) <->
    (exists new, (update_task_desc_map target (set_task_desc_exstatus desc value) T task = Some new /\
    (tsmStat (tdSchedMember new) = TSK_INIT \/ tsmStat (tdSchedMember new) = TSK_RUNNING \/ tsmStat (tdSchedMember new) = TSK_SUSPEND)) /\ store_node_self_linked (sched_link_of task) heap)).
  split; intros [d [[Hl Hstatus] Hheap]].
  - destruct (lookup_new__exstatus_write_view _ _ _ value _ _ HT Hl) as [new [Hn [_ [Hs _]]]].
    exists new; rewrite <- Hs; auto.
  - destruct (lookup_old__exstatus_write_view _ _ _ _ _ _ HT Hl) as [old [Ho [_ [Hs _]]]].
    exists old; rewrite Hs; auto.
Qed.
Lemma zombie_update_eq__exstatus_write_view : forall T target desc value head q,
  T target = Some desc ->
  store_zombie_queue T head q =
  store_zombie_queue (update_task_desc_map target (set_task_desc_exstatus desc value) T) head q.
Proof.
  intros T target desc value head q HT. destruct q; cbn; [reflexivity|].
  unfold pure_close_sched_link. rewrite (slink_update_eq__exstatus_write_view T target desc value TSK_CLOSE HT). reflexivity.
Qed.
Lemma exstatus_borrow_update__exstatus_write_view : forall sg st target desc,
  st.(os_tasks).(task_desc_map) target = Some desc ->
  os_inv sg st |--
  (&(target # "TaskDescriptor" ->ₛ "exstatus") # Int |-> tdExstatus desc) **
  event_resume_exstatus_restore sg
    (replace_task_desc_map
      (update_task_desc_map target (set_task_desc_exstatus desc (-1)) st.(os_tasks).(task_desc_map)) st)
    target (-1).
Proof.
  intros sg st target desc HT.
  unfold os_inv at 1. unfold task_inv at 1.
  Intros.
  sep_apply_l_atomic (store_map_split store_published_task target desc (task_desc_map (os_tasks st)) HT).
  unfold store_published_task at 2. unfold store_task_descriptor at 1.
  Intros.
  cancel (&(target # "TaskDescriptor" ->ₛ "exstatus") # Int |-> tdExstatus desc).
  unfold event_resume_exstatus_restore. apply_sepcon_adjoint.
  unfold os_inv, task_inv, delay_inv, assign_inv, tick_inv, exstatus_inv.
  cbn [replace_task_desc_map os_tasks task_desc_map task_idmanager_abs task_ptr_list sched_owned_tasks os_tick os_delays os_assign zombie_queue os_recycle os_idle os_isr os_exstatus os_semaphores os_mutexes os_events].
  unfold pure_suspend_sched_link, store_owned_sched_nodes.
  rewrite <- (slink_update_eq__exstatus_write_view _ _ _ (-1) TSK_SUSPEND HT).
  rewrite <- (detached_update_eq__exstatus_write_view _ _ _ (-1) HT).
  rewrite <- (zombie_update_eq__exstatus_write_view _ _ _ (-1) _ _ HT).
  Intros.
  split_pure_spatial.
  - cancel.
    assert (Hnew : update_task_desc_map target (set_task_desc_exstatus desc (-1)) (task_desc_map (os_tasks st)) target = Some (set_task_desc_exstatus desc (-1))).
    { unfold update_task_desc_map; destruct (Z.eq_dec target target); congruence. }
    sep_apply_r_atomic (store_map_merge store_published_task target (set_task_desc_exstatus desc (-1)) _ Hnew).
    assert (Hsame : forall other, other <> target -> task_desc_map (os_tasks st) other = update_task_desc_map target (set_task_desc_exstatus desc (-1)) (task_desc_map (os_tasks st)) other).
    { intros other Hneq. unfold update_task_desc_map. destruct (Z.eq_dec other target); congruence. }
    sep_apply_l_atomic (proj1 (store_map_missing_i_equiv store_published_task (task_desc_map (os_tasks st)) (update_task_desc_map target (set_task_desc_exstatus desc (-1)) (task_desc_map (os_tasks st))) target Hsame)).
    unfold store_published_task at 3. unfold store_task_descriptor. cbn [set_task_desc_exstatus tdStackPoint tdStackRaw tdStackContext tdBaseInfo tdSchedMember tdDelay tdEventIdTrigger tdEventMode tdExstatus tdDone].
    split_pure_spatial.
    + cancel.
      repeat match goal with |- ?P ** _ |-- _ => cancel P end.
      match goal with |- ?P |-- ?P => cancel P end.
    + split_pures; dump_pre_spatial; tauto.
  - split_pures; dump_pre_spatial;
      eauto using world_update__exstatus_write_view, task_wf_update__exstatus_write_view,
        delay_update__exstatus_write_view, assign_update__exstatus_write_view.
Qed.
Lemma guarded_resume_commit__atomic_exit :
  forall id p before locked waiting current X,
    event_delete_gap id p false before locked ->
    event_pending_at id p waiting locked ->
    event_resume_all_effect p waiting locked current ->
    monadesafe_lib.safeExec (LastSeen before) (abs_event_resume_all id p) X ->
    monadesafe_lib.safeExec (LastSeen current) (MonadErr.ret tt) X.
Proof.
  intros id p before locked waiting current X [Hrely Hguard] Hpending Heffect
    [states [Hstates Hsafe]].
  unfold monadesafe_lib.safe, MonadErrHoare.weakestpre in Hsafe.
  destruct Hsafe as [Hnoerr Hnormal].
  exists (Crtos_RTrans current).
  split.
  - unfold LastSeen. change (forall st, Crtos_RTrans current st <-> Crtos_RTrans current st). tauto.
  - unfold monadesafe_lib.safe, MonadErrHoare.weakestpre. simpl.
    split; [tauto|].
    intros result next [Hr Hnext]. subst result next.
    apply Hnormal.
    unfold abs_event_resume_all, event_delete_atomic_cmd,
      abs_event_resume_all_locked. simpl.
    exists locked, current. split.
    + apply (proj2 (Hstates locked)). exact Hrely.
    + split; [exact Hguard|].
      split.
      * exists waiting. auto.
      * change (forall st, Crtos_RTrans current st <-> Crtos_RTrans current st). tauto.
Qed.
Lemma idnode_address_unique__wakeup_failure : forall nodes id a b,
  NoDup (idnode_ids nodes) ->
  In (Build_IdNodeAbs id a) nodes ->
  In (Build_IdNodeAbs id b) nodes -> a = b.
Proof.
  intros nodes id a b.
  induction nodes as [|node nodes IH]; simpl; intros Hnd Ha Hb;
    [contradiction|].
  inversion Hnd as [|x xs Hnot Hndtail].
  destruct Ha as [Ha|Ha]; destruct Hb as [Hb|Hb].
  - congruence.
  - subst node. exfalso. apply Hnot.
    change (In id (map idnode_id nodes)).
    apply in_map_iff. exists (Build_IdNodeAbs id b).
    split; [reflexivity|exact Hb].
  - subst node. exfalso. apply Hnot.
    change (In id (map idnode_id nodes)).
    apply in_map_iff. exists (Build_IdNodeAbs id a).
    split; [reflexivity|exact Ha].
  - eapply IH; eauto.
Qed.
