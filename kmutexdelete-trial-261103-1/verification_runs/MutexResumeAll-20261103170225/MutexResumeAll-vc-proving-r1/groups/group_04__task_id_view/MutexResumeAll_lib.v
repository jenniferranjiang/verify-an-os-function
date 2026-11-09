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

Require Import Coq.micromega.Lia Coq.Sorting.Permutation.

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
