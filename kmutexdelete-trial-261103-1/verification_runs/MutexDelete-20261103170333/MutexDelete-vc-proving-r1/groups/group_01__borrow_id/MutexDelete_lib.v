From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.

Require Import Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic MapLib.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.KMutexDelete CRTOS_Verify.lib.IdModuleSpec.
From MonadLib.MonadErr Require Import MonadErrHoare monadesafe_lib.
Import DLL IDNode MonadErr.
Local Open Scope string_scope.
Local Open Scope sac.

(** LinklistResumeAll返回后继续执行原helper第二段临界区；这只是bind的
    continuation，不加强函数规格或限制其余环境状态。 *)
Definition mutex_delete_after_resume (p id : Z)
    (X : unit -> (VarGlobalState -> Prop) -> Prop)
    : unit -> (VarGlobalState -> Prop) -> Prop :=
  fun _ states => weakestpre (abs_mutex_retire p id) X states.

(** 读取即将注销对象的ID时只借出该字段；返回同一值即可恢复同一os_inv。
    wand为空间资源，不是可以复制的纯假设。 *)
Definition mutex_delete_id_restore (sg : StableGlobalState) (st : VarGlobalState)
    (p id : Z) : Assertion :=
  (&(p # "Mutex" ->ₛ "id" .ₛ "id") # UShort |-> id) -* os_inv sg st.

(** 完整ID manager之外的精确frame：沿用已审阅非Mutex资源与Mutex管理DLL。
    管理DLL在ID摘除后仍然由本地持有，可继续完成管理节点摘除。 *)
Definition mutex_delete_manager_frame (sg : StableGlobalState) (st : VarGlobalState)
    : Assertion :=
  “ mutex_context sg.(os_mutex_stable) ” &&
  mutex_create_frame sg st **
  store_dll (store_mutex (pure_suspend_sched_link st.(os_tasks).(task_desc_map)))
    sg.(os_mutex_stable).(mutex_list_head) (map mutex_link_node st.(os_mutexes)).

From Coq Require Import Lia.

Lemma dllseg_focus__borrow_id : forall A (storeA : addr -> A -> Assertion)
    nodes (node : DL_Node A) x px y py,
  In node nodes ->
  dllseg storeA x px y py nodes |--
  storeA node.(ptr) node.(data) **
    (storeA node.(ptr) node.(data) -* dllseg storeA x px y py nodes).
Proof.
  intros A storeA nodes. induction nodes as [|a rest IH];
    intros node x px y py Hin; [contradiction|].
  destruct Hin as [<-|Hin].
  - cbn [dllseg]. Intros z. rename H into Hx. subst x.
    cancel.
    apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)).
    Exists z. split_pure_spatial; [sepcon_right_assoc; cancel | dump_pre_spatial; reflexivity].
  - cbn [dllseg]. Intros z. rename H into Hx.
    sep_apply_l_atomic (IH node z x y py Hin).
    cancel.
    apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)). match goal with |- context[?P -* ?Q] =>
      sep_apply_l_atomic (derivable1_wand_elim2 P Q) end.
    Exists z. split_pure_spatial; [unfold dllseg; sepcon_right_assoc; cancel | dump_pre_spatial; exact Hx].
Qed.
Lemma dll_focus__borrow_id : forall A (storeA : addr -> A -> Assertion)
    head nodes (node : DL_Node A),
  In node nodes ->
  store_dll storeA head nodes |--
  storeA node.(ptr) node.(data) **
    (storeA node.(ptr) node.(data) -* store_dll storeA head nodes).
Proof.
  intros A storeA head nodes node Hin.
  unfold store_dll. Intros h pt. rename H into Hwf.
  sep_apply_l_atomic (dllseg_focus__borrow_id A storeA nodes node h head head pt Hin).
  cancel.
  apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)). match goal with |- context[?P -* ?Q] =>
      sep_apply_l_atomic (derivable1_wand_elim2 P Q) end.
  Exists h pt. split_pure_spatial; [sepcon_right_assoc; cancel | dump_pre_spatial; exact Hwf].
Qed.
Lemma idbucket_focus__borrow_id : forall head bucket node,
  In node bucket ->
  store_idbucket head bucket |--
  store_idnode (idnode_link node) node **
  (store_idnode (idnode_link node) node -* store_idbucket head bucket).
Proof.
  intros head bucket node Hin.
  destruct bucket as [|a rest]; [contradiction|].
  cbn [store_idbucket]. unfold store_idnodes.
  apply (dll_focus__borrow_id IdNodeAbs store_idnode head
    (idnodes_to_dll (a :: rest)) (idnode_to_dll node)).
  apply in_map. exact Hin.
Qed.
Lemma idbuckets_focus__borrow_id : forall buckets node h start,
  In node (List.concat buckets) ->
  store_idbucket_list h start buckets |--
  store_idnode (idnode_link node) node **
  (store_idnode (idnode_link node) node -* store_idbucket_list h start buckets).
Proof.
  intros buckets. induction buckets as [|b rest IH];
    intros node h start Hin; [contradiction|].
  cbn [List.concat] in Hin. apply in_app_or in Hin.
  remember (store_idnode (idnode_link node) node **
    (store_idnode (idnode_link node) node -* store_idbucket_list h start (b :: rest)))
    as result eqn:Hresult.
  cbn [store_idbucket_list]. destruct Hin as [Hin|Hin].
  - sep_apply_l_atomic (idbucket_focus__borrow_id
      (h + start * sizeof("SysDoubleLinklistNode")) b node Hin).
    subst result. cancel.
    apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)). match goal with |- context[?P -* ?Q] =>
      sep_apply_l_atomic (derivable1_wand_elim2 P Q) end. unfold store_idbucket_list; sepcon_right_assoc; cancel.
  - sep_apply_l_atomic (IH node h (start + 1) Hin).
    subst result. cancel.
    apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)). match goal with |- context[?P -* ?Q] =>
      sep_apply_l_atomic (derivable1_wand_elim2 P Q) end. unfold store_idbucket_list; sepcon_right_assoc; cancel.
Qed.
Lemma mutex_idnode_in_buckets__borrow_id : forall st sem,
  In sem st -> In (mutex_idnode sem)
    (List.concat (idbuckets (mutex_manager st))).
Proof.
  intros st sem Hin. unfold mutex_manager. cbn [idbuckets].
  apply in_concat.
  exists (map mutex_idnode
    (filter (fun s => Z.eqb (mutex_id s mod 16) (mutex_id sem mod 16)) st)).
  split.
  - apply in_map_iff. exists (Z.to_nat (mutex_id sem mod 16)).
    assert (Hr : 0 <= mutex_id sem mod 16 < 16) by (apply Z.mod_pos_bound; lia).
    split.
    + rewrite Z2Nat.id by lia. reflexivity.
    + apply in_seq. lia.
  - apply in_map. apply filter_In. split; [exact Hin|apply Z.eqb_refl].
Qed.
Lemma idnode_scalar_focus__borrow_id : forall link node,
  store_idnode link node |--
  &(((idnode_addr node)) # "IdNode" ->ₛ "id") # UShort |-> idnode_id node **
  ((&(((idnode_addr node)) # "IdNode" ->ₛ "id") # UShort |-> idnode_id node)
    -* store_idnode link node).
Proof.
  intros link node. unfold store_idnode. Intros.
  cancel.
  apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)). Intros.
  split_pure_spatial; [sepcon_right_assoc; cancel | dump_pre_spatial; assumption].
Qed.
Lemma os_id_cell_focus__borrow_id : forall sg st current,
  In current (os_mutexes st) ->
  os_inv sg st |--
  (&(((mutex_addr current)) # "Mutex" ->ₛ "id" .ₛ "id") # UShort |-> mutex_id current) **
  mutex_delete_id_restore sg st (mutex_addr current) (mutex_id current).
Proof.
  intros sg st current Hin.
  pose proof (mutex_idnode_in_buckets__borrow_id _ _ Hin) as Hbucket.
  unfold os_inv at 1. unfold mutex_inv at 1.
  unfold store_idmanager at 1. unfold store_idbuckets at 1. Intros.
  sep_apply_l_atomic (idbuckets_focus__borrow_id
    (idbuckets (mutex_manager (os_mutexes st))) (mutex_idnode current)
    (htable (mutex_manager_stable (os_mutex_stable sg))) 0 Hbucket).
  match goal with |- context[(store_idnode ?l ?n -* ?Q)] =>
    remember (store_idnode l n -* Q) as bucket_restore eqn:Hrestore end.
  sep_apply_l_atomic (idnode_scalar_focus__borrow_id
    (idnode_link (mutex_idnode current)) (mutex_idnode current)).
  unfold mutex_delete_id_restore. cbn [mutex_idnode idnode_addr idnode_id]. csimpl.
  cancel.
  apply (proj1 (derivable1_wand_sepcon_adjoint _ _ _)).
  match goal with |- context[?P -* store_idnode ?l ?n] =>
    sep_apply_l_atomic (derivable1_wand_elim2 P (store_idnode l n)) end.
  subst bucket_restore.
  match goal with |- context[?P -* ?Q] =>
    sep_apply_l_atomic (derivable1_wand_elim2 P Q) end.
  unfold os_inv, mutex_inv, store_idmanager, store_idbuckets.
  split_pure_spatial; [sepcon_right_assoc; cancel | split_pures; dump_pre_spatial; assumption].
Qed.

Lemma payload_neq__borrow_id : forall wait l1 l2 m1 m2,
  store_mutex wait l1 m1 ** store_mutex wait l2 m2 |--
  “ mutex_addr m1 <> mutex_addr m2 ”.
Proof.
  intros. destruct (Z.eq_dec (mutex_addr m1) (mutex_addr m2)) as [Heq|Hneq].
  - unfold store_mutex. rewrite Heq. Intros.
    match goal with |- context[?p # Ptr |-> mutex_holder m1] =>
      sep_apply_l_atomic (dup_store_ptr p (mutex_holder m1) (mutex_holder m2)) end.
    Intros_p HF. contradiction.
  - dump_pre_spatial. exact Hneq.
Qed.

Lemma dllseg_addresses_unique__borrow_id : forall wait ms x px y py,
 dllseg (store_mutex wait) x px y py (map mutex_link_node ms) |-- “ NoDup (map mutex_addr ms) ”.
Proof.
intros wait ms.
induction ms as [|m rest IH]; intros x px y py.
- dump_pre_spatial.
constructor.
- cbn [map dllseg].
Intros z.
rename H into Hx.
subst x.
destruct (in_dec Z.eq_dec (mutex_addr m) (map mutex_addr rest)) as [Hin|Hnot].
+ apply in_map_iff in Hin.
destruct Hin as [other [Heq Hin]].
assert (Hnode : In (mutex_link_node other) (map mutex_link_node rest)) by (apply in_map; exact Hin).
sep_apply_l_atomic (dllseg_focus__borrow_id MutexAbs (store_mutex wait) (map mutex_link_node rest) (mutex_link_node other) z (getPtr (mutex_link_node m)) y py Hnode).
cbn [mutex_link_node getPtr getData].
match goal with |- context[store_mutex wait ?l1 m] => match goal with |- context[store_mutex wait ?l2 other] => sep_apply_l_atomic (payload_neq__borrow_id wait l1 l2 m other) end end.
Intros_p Hneq.
exfalso.
apply Hneq.
symmetry.
exact Heq.
+ prop_apply_p (IH z (getPtr (mutex_link_node m)) y py).
Intros_p Hnd.
dump_pre_spatial.
constructor; assumption.
Qed.
Lemma mutex_addresses_unique__borrow_id : forall sg st, os_inv sg st |-- “ NoDup (map mutex_addr (os_mutexes st)) ”.
Proof.
intros sg st.
unfold os_inv, mutex_inv.
Intros.
match goal with |- context[store_dll (store_mutex ?w) ?h ?ms] => unfold store_dll at 1 end.
Intros h pt.
sep_apply_l_atomic (dllseg_addresses_unique__borrow_id (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_mutexes st) h (mutex_list_head (os_mutex_stable sg)) (mutex_list_head (os_mutex_stable sg)) pt).
Intros_p Hnd.
dump_pre_spatial.
exact Hnd.
Qed.

Lemma mutex_ids_unique__borrow_id : forall sg st,
  os_inv sg st |-- “ NoDup (map mutex_id (os_mutexes st)) ”.
Proof.
  intros sg st. unfold os_inv, mutex_inv, store_idmanager. Intros.
  dump_pre_spatial.
  match goal with H : idbuckets_ok _ _ _ _ |- _ =>
    destruct H as [_ [_ [[_ Hnd] _]]]; exact Hnd end.
Qed.
