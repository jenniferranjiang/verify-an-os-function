From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.

From Coq Require Import String.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.KEventDelete CRTOS_Verify.lib.IdModuleSpec.
Import DLL IDNode MonadErr.
Local Open Scope string.
Local Open Scope sac.

(** 查询暂借事件ID manager时保留的其余资源：系统其余模块与完整事件
    管理链/payload。此view不拥有ID manager，也不增加新的前提或协议。 *)
Definition find_event_manager_frame (sg : StableGlobalState) (st : VarGlobalState)
    : Assertion :=
  event_create_frame sg st **
  store_dll (store_event (pure_suspend_sched_link st.(os_tasks).(task_desc_map)))
    sg.(os_event_stable).(event_list_head)
    (map event_link_node st.(os_events)).

From Coq Require Import Lia.

(** ID桶由事件序列的filter/map派生；选中桶的成员必来自同一事件序列。 *)
Lemma event_bucket_member__hit_object : forall es k id node,
  In (Build_IdNodeAbs id node) (Znth k (idbuckets (event_manager es)) nil) ->
  exists e, In e es /\ event_idnode e = Build_IdNodeAbs id node.
Proof.
  intros es k id node Hin.
  unfold event_manager in Hin. cbn [idbuckets] in Hin. unfold Znth in Hin.
  remember (map (fun i => map event_idnode
    (filter (fun e => Z.eqb (event_id e mod 16) (Z.of_nat i)) es))
    (seq 0 16)) as buckets eqn:Hb.
  destruct (lt_dec (Z.to_nat k) (List.length buckets)) as [Hlt|Hge].
  - pose proof (@nth_In _ (Z.to_nat k) buckets nil Hlt) as Hbucket.
    rewrite Hb in Hbucket. apply in_map_iff in Hbucket.
    destruct Hbucket as [i [Hi Hseq]]. rewrite Hb in Hin. rewrite <- Hi in Hin.
    apply in_map_iff in Hin. destruct Hin as [e [He Hin]].
    apply filter_In in Hin. exists e. split; [exact (proj1 Hin)|exact He].
  - rewrite nth_overflow in Hin by lia. contradiction.
Qed.

(** 每个存活payload显式保存其分配基址非零，不能由ID字段地址非零反推。 *)
Lemma event_dll_addr_nonzero__hit_object : forall wait es x px y py e,
  In e es ->
  dllseg (store_event wait) x px y py (map event_link_node es)
  |-- “ event_addr e <> 0 ”.
Proof.
  intros wait es. induction es as [|a es IH]; intros x px y py e Hin.
  - contradiction.
  - simpl in Hin. destruct Hin as [<-|Hin].
    + cbn [map dllseg event_link_node]. Intros z.
      unfold store_event. Intros. dump_pre_spatial. tauto.
    + cbn [map dllseg event_link_node]. Intros z.
      fold (dllseg (store_event wait) z x y py (map event_link_node es)).
      prop_apply_p (IH z x y py e Hin). Intros_p Hnz.
      dump_pre_spatial. exact Hnz.
Qed.

(** 从已找到ID节点视图导出纯事件成员关系；prop_apply使用时保留原资源。 *)
Lemma event_found_member__hit_object : forall sm es manager node id,
  store_idmanager_found sm (event_manager es) manager node id
  |-- “ exists e, In e es /\ event_idnode e = Build_IdNodeAbs id node ”.
Proof.
  intros sm es manager node id. unfold store_idmanager_found.
  Intros bytes prefix suffix bucket.
  destruct H as [Hrange [Hmap [Hok [Hbucket Hsplit]]]].
  dump_pre_spatial.
  apply (event_bucket_member__hit_object es (id mod hoffset sm) id node).
  rewrite <- Hbucket, Hsplit. apply in_or_app. right. left. reflexivity.
Qed.

Lemma event_dll_member_nonzero__hit_object : forall wait head es e,
  In e es -> store_dll (store_event wait) head (map event_link_node es)
  |-- “ event_addr e <> 0 ”.
Proof.
  intros wait head es e Hin. unfold store_dll. Intros h pt.
  prop_apply_p (event_dll_addr_nonzero__hit_object wait es h head head pt e Hin).
  Intros_p Hnz. dump_pre_spatial. exact Hnz.
Qed.
