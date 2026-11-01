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

From Coq Require Import Sorting.Permutation micromega.Lia.

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
