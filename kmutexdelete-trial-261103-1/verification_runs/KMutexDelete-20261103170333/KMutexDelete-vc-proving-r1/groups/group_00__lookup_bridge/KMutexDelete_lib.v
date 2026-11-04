From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.
Require Import CRTOS_Verify.lib.KMutexDelete.
Require Import Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Import DLL IDNode MonadErr.
Local Open Scope string.
Local Open Scope sac.

(** 查询借出 Mutex manager 后的精确剩余：其他模块由共享frame持有，
    Mutex管理链保留全部payload。它与manager相分离；不是新生命周期假设。 *)
Definition mutex_lookup_frame (sg : StableGlobalState) (st : VarGlobalState)
    : Assertion :=
  “ mutex_context sg.(os_mutex_stable) ” &&
  mutex_create_frame sg st **
  store_dll (store_mutex (pure_suspend_sched_link st.(os_tasks).(task_desc_map)))
    sg.(os_mutex_stable).(mutex_list_head)
    (map mutex_link_node st.(os_mutexes)).

(** Group-local query ownership and membership bridges, checked interactively. *)
Lemma mutex_lookup_split__lookup_bridge : forall sg st, os_inv sg st |-- store_idmanager (mutex_manager_stable (os_mutex_stable sg)) (mutex_manager (os_mutexes st)) (&("k_mutex_id_manager")) ** mutex_lookup_frame sg st.
Proof.
intros sg st.
unfold os_inv, mutex_inv, mutex_lookup_frame, mutex_create_frame.
Intros.
pose proof (proj1 H0) as Haddr.
rewrite Haddr.
split_pure_spatial.
- repeat progress cancel.
- split_pures; dump_pre_spatial; assumption.
Qed.
Lemma mutex_lookup_restore__lookup_bridge : forall sg st, store_idmanager (mutex_manager_stable (os_mutex_stable sg)) (mutex_manager (os_mutexes st)) (&("k_mutex_id_manager")) ** mutex_lookup_frame sg st |-- os_inv sg st.
Proof.
intros sg st.
unfold os_inv, mutex_inv, mutex_lookup_frame, mutex_create_frame.
Intros.
pose proof (proj1 H) as Haddr.
rewrite Haddr.
split_pure_spatial.
- repeat progress cancel.
- split_pures; dump_pre_spatial; assumption.
Qed.
Require Import Coq.micromega.Lia.
Lemma mutex_manager_member__lookup_bridge : forall objects index key node,
 In (Build_IdNodeAbs key node) (Znth index (idbuckets (mutex_manager objects)) nil) ->
 exists m, In m objects /\ mutex_id m = key /\ node = idnode_addr (mutex_idnode m).
Proof.
intros objects index key node Hmem.
remember (idbuckets (mutex_manager objects)) as buckets eqn:Hb.
destruct (lt_dec (Z.to_nat index) (List.length buckets)) as [Hlt|Hge].
- assert (Hbucket : In (Znth index buckets nil) buckets) by (unfold Znth; apply nth_In; exact Hlt).
rewrite Hb in Hbucket.
cbn [mutex_manager idbuckets] in Hbucket.
apply in_map_iff in Hbucket as [i [Heq Hi]].
rewrite Hb in Hmem.
cbn [mutex_manager idbuckets] in Hmem.
rewrite <- Heq in Hmem.
apply in_map_iff in Hmem as [m [Hnode Hin]].
apply filter_In in Hin as [Hin Hfilter].
exists m.
unfold mutex_idnode in Hnode.
inversion Hnode.
auto.
- unfold Znth in Hmem.
rewrite nth_overflow in Hmem by lia.
contradiction.
Qed.
Lemma mutex_segment_member_nonzero__lookup_bridge : forall wait objects x px y py m,
 In m objects -> dllseg (store_mutex wait) x px y py (map mutex_link_node objects) |-- “ mutex_addr m <> 0 ”.
Proof.
intros wait objects.
induction objects as [|a rest IH]; intros x px y py m Hin.
- contradiction.
- simpl in Hin.
destruct Hin as [Heq|Hin].
+ subst a.
cbn [map dllseg mutex_link_node].
Intros z.
unfold store_mutex.
Intros.
dump_pre_spatial.
tauto.
+ cbn [map dllseg mutex_link_node].
Intros z.
fold (dllseg (store_mutex wait) z x y py (map mutex_link_node rest)).
prop_apply_p (IH z x y py m Hin).
Intros_p Hnz.
dump_pre_spatial.
exact Hnz.
Qed.
Lemma mutex_member_nonzero__lookup_bridge : forall wait head objects m,
 In m objects -> store_dll (store_mutex wait) head (map mutex_link_node objects) |-- “ mutex_addr m <> 0 ”.
Proof.
intros wait head objects m Hin.
unfold store_dll.
Intros h pt.
prop_apply_p (mutex_segment_member_nonzero__lookup_bridge wait objects h head head pt m Hin).
Intros_p Hnz.
dump_pre_spatial.
exact Hnz.
Qed.
Lemma idmanager_found_member__lookup_bridge : forall sm m manager node id,
 store_idmanager_found sm m manager node id |--
 “ 0 <= id < idmax sm /\ In (Build_IdNodeAbs id node) (Znth (id mod hoffset sm) (idbuckets m) nil) ”.
Proof.
intros sm m manager node id.
unfold store_idmanager_found.
Intros bytes prefix suffix bucket.
destruct H as [Hr [Hbytes [Hwf [Hbucket Hsplit]]]].
dump_pre_spatial.
split; [exact Hr|].
rewrite <- Hbucket, Hsplit.
apply in_or_app.
right.
simpl.
auto.
Qed.
Lemma mutex_lookup_frame_member__lookup_bridge : forall sg st m,
 In m (os_mutexes st) -> mutex_lookup_frame sg st |-- “ mutex_context (os_mutex_stable sg) /\ mutex_addr m <> 0 ”.
Proof.
intros sg st m Hin.
unfold mutex_lookup_frame.
Intros_p Hctx.
prop_apply_p (mutex_member_nonzero__lookup_bridge (pure_suspend_sched_link (task_desc_map (os_tasks st))) (mutex_list_head (os_mutex_stable sg)) (os_mutexes st) m Hin).
Intros_p Hnz.
dump_pre_spatial.
auto.
Qed.
Lemma mutex_lookup_found__lookup_bridge : forall sg st key node,
 store_idmanager_found (mutex_manager_stable (os_mutex_stable sg)) (mutex_manager (os_mutexes st)) (&("k_mutex_id_manager")) node key ** mutex_lookup_frame sg st |--
 EX m : MutexAbs, “ In m (os_mutexes st) ” && “ mutex_id m = key ” && “ node = idnode_addr (mutex_idnode m) ” && “ mutex_delete_live (mutex_addr m) (mutex_id m) st ” && os_inv sg st.
Proof.
intros sg st key node.
prop_apply_p (idmanager_found_member__lookup_bridge (mutex_manager_stable (os_mutex_stable sg)) (mutex_manager (os_mutexes st)) (&("k_mutex_id_manager")) node key).
Intros_p Hfound.
destruct Hfound as [Hrange Hmem].
destruct (mutex_manager_member__lookup_bridge (os_mutexes st) (key mod hoffset (mutex_manager_stable (os_mutex_stable sg))) key node Hmem) as [m [Hin [Hid Hnode]]].
prop_apply_p (mutex_lookup_frame_member__lookup_bridge sg st m Hin).
Intros_p Hframe.
destruct Hframe as [Hctx Hnz].
sep_apply_l_atomic (store_idmanager_found_store_idmanager (mutex_manager_stable (os_mutex_stable sg)) (mutex_manager (os_mutexes st)) (&("k_mutex_id_manager")) node key).
Exists m.
split_pure_spatial.
- apply mutex_lookup_restore__lookup_bridge.
- split_pures; dump_pre_spatial; try assumption.
unfold mutex_delete_live.
split; [exact Hnz|].
split.
+ destruct Hctx as [_ [Hmax _]].
rewrite Hmax in Hrange.
rewrite Hid.
lia.
+ exists m.
auto.
Qed.

