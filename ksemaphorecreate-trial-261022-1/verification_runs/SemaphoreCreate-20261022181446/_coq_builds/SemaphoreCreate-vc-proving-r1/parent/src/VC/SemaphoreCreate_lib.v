From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.

(* Current model imports for proof helpers; no generated-artifact dependency. *)
From Coq Require Import Bool Strings.String Classes.RelationClasses Classes.Morphisms.
From Coq Require Import micromega.Psatz Sorting.Permutation.
From AUXLib Require Import int_auto Axioms Feq Idents ListLib VMap.
Require Import SetsClass.SetsClass.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import KSemaphoreCreateTrial.KSemaphoreCreate.
Require Import TrialShared.CrtosInv TrialShared.SemaphoreInv.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import SetsNotation IDNode DLL Monad MonadNotation.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Local Open Scope monad.
Local Open Scope sac.



(* Bridges proved against the frozen VRTOS interfaces and explicit layout premise. *)
Require Import KSemaphoreCreateTrial.SemaphoreByteLayout.
Require Import KSemaphoreCreateTrial.SemaphoreOwnership.
Require Import KSemaphoreCreateTrial.SemaphoreSpecBridge.
Require Import TrialShared.DoubleLinkListSpec.


Lemma published_manager__publish : forall sidm ss p id val,
  hoffset sidm = 16 ->
  semaphore_manager (semaphore_publish p id val ss) =
  idmanager_link sidm (idmanager_add (semaphore_manager ss) id)
    id (&(p # "Semaphore" ->ₛ "id")).
Proof.
  intros sidm ss p id val Hoffset.
  unfold semaphore_manager, semaphore_publish, idmanager_link,
    idmanager_add, idmanager_insert_bucket, idlist_add.
  simpl idlist; simpl idbuckets. rewrite Hoffset.
  assert (Hrange : 0 <= id mod 16 < 16) by (apply Z.mod_pos_bound; lia).
  assert (Hcases : id mod 16 = 0 \/ id mod 16 = 1 \/ id mod 16 = 2 \/ id mod 16 = 3 \/ id mod 16 = 4 \/ id mod 16 = 5 \/ id mod 16 = 6 \/ id mod 16 = 7 \/ id mod 16 = 8 \/ id mod 16 = 9 \/ id mod 16 = 10 \/ id mod 16 = 11 \/ id mod 16 = 12 \/ id mod 16 = 13 \/ id mod 16 = 14 \/ id mod 16 = 15) by lia.
  destruct Hcases as [Hk|[Hk|[Hk|[Hk|[Hk|[Hk|[Hk|[Hk|[Hk|[Hk|[Hk|[Hk|[Hk|[Hk|[Hk|Hk]]]]]]]]]]]]]]];
    cbn [map seq filter semaphore_created semaphore_id semaphore_idnode semaphore_addr];
    rewrite Hk; reflexivity.
Qed.
Lemma task_world_replace__publish : forall st ss,
  task_world_wf st -> task_world_wf (replace_semaphores ss st).
Proof.
  intros st ss H; destruct H; constructor; assumption.
Qed.
Lemma published_world_wf__publish : forall sg st p id val,
  os_world_wf sg st ->
  os_world_wf sg (replace_semaphores (semaphore_publish p id val (os_semaphores st)) st).
Proof.
  intros sg st p id val H. destruct H as [Hcontext Hrecycler Hidle Hcoverage].
  constructor; try assumption.
Qed.
Lemma task_inv_replace__publish : forall sg st ss,
  task_inv sg st |-- task_inv sg (replace_semaphores ss st).
Proof.
  intros sg st ss. unfold task_inv.
  Intros_p Hwf. split_pure_spatial.
  - cbn [replace_semaphores os_tasks]. cancel.
  - dump_pre_spatial. apply task_world_replace__publish. exact Hwf.
Qed.
Lemma dllseg_fresh_value__open_id : forall wait sem l x px y py,
  dllseg (store_semaphore wait) x px y py (map semaphore_link_node l) **
  &(sem # "Semaphore" ->ₛ "value") # UShort |-> 0
  |-- “ ~ In sem (map semaphore_addr l) ”.
Proof.
  intros wait sem l. induction l as [|a l IH]; intros x px y py.
  - simpl. Intros_p Hends. dump_pre_spatial. simpl. tauto.
  - simpl dllseg. Intros z.
    destruct (Z.eq_dec sem (semaphore_addr a)) as [Heq|Hneq].
    + unfold store_semaphore. Intros_p Ha.
      subst sem. unfold store_ushort. Intros_p H1. Intros_p H2.
      sepcon_right_assoc.
      let p := constr:(semaphore_addr a) in
      sep_apply_l_atomic (dup_store_2bytes (&(p # "Semaphore" ->ₛ "value")) (semaphore_value a) 0).
      Intros_p Hfalse. contradiction.
    + sepcon_right_assoc. sep_apply_l_atomic (IH z x y py). Intros_p Hfresh.
      dump_pre_spatial. simpl. intuition.
Qed.
Lemma new_object_payload__list_prepare : forall wait p id val,
  p <> 0 -> addr_aligned p 4 -> &(p # "Semaphore" ->ₛ "pend_list") <> 0 ->
  store_node_self_linked (&(p # "Semaphore" ->ₛ "pend_list")) **
  &(p # "Semaphore" ->ₛ "value") # UShort |-> val **
  SemaphorePadding p ** NodeZero (&(p # "Semaphore" ->ₛ "link")) |--
  store_semaphore wait (&(p # "Semaphore" ->ₛ "link")) (semaphore_created p id val) **
  occupy_dll_node (&(p # "Semaphore" ->ₛ "link")).
Proof.
  intros wait p id val Hp Ha Hpend.
  unfold store_semaphore, semaphore_created; cbn.
  unfold store_dll, store_node_self_linked, NodeZero, occupy_dll_node.
  Exists (&(p # "Semaphore" ->ₛ "pend_list")) (&(p # "Semaphore" ->ₛ "pend_list")) 0 0.
  cbn [dllseg].
  split_pure_spatial; [sepcon_right_assoc; cancel | split_pures; dump_pre_spatial; repeat split; auto; constructor].
Qed.
Lemma pend_zero_ready__list_prepare : forall p,
  NodeZero (&(p # "Semaphore" ->ₛ "pend_list")) |--
  &(p # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev") # Ptr |->_ **
  &(p # "Semaphore" ->ₛ "pend_list" .ₛ "node_next") # Ptr |->_ .
Proof.
  intros p. unfold NodeZero.
  set (q := (&(p # "Semaphore" ->ₛ "pend_list") : addr)).
  assert (Hprev : &(p # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev") =
    &(q # "SysDoubleLinklistNode" ->ₛ "node_prev")).
  { unfold q. simpl. rewrite addr_of_arrow_field, eval_addr. reflexivity. }
  assert (Hnext : &(p # "Semaphore" ->ₛ "pend_list" .ₛ "node_next") =
    &(q # "SysDoubleLinklistNode" ->ₛ "node_next")).
  { unfold q. simpl. rewrite addr_of_arrow_field, eval_addr. reflexivity. }
  rewrite Hprev, Hnext. fold q.
  sep_apply_l_atomic (store_ptr_undef_store_ptr (&(q # "SysDoubleLinklistNode" ->ₛ "node_prev")) 0).
  sep_apply_l_atomic (store_ptr_undef_store_ptr (&(q # "SysDoubleLinklistNode" ->ₛ "node_next")) 0).
  sepcon_right_assoc; cancel.
Qed.
Lemma atomic_normal_return__returns {A : Type}
    (cmd : program VarGlobalState A)
    (before st after : VarGlobalState) (a : A) X :
  Crtos_RTrans before st ->
  MonadErr.nrm cmd st a after ->
  safeExec (LastSeen before) (task_atomic_cmd cmd) X ->
  safeExec (LastSeen after) (MonadErr.ret a) X.
Proof.
  intros Hrely Hstep Hsafe.
  eapply (highstependret_derive (task_atomic_cmd cmd)
    (LastSeen before) a (fun _ => LastSeen after)); [|exact Hsafe].
  intros states Hstates.
  exists (Crtos_RTrans after).
  split.
  - exists st, after. split.
    + apply (proj2 (Hstates st)). exact Hrely.
    + split; [exact Hstep | reflexivity].
  - unfold LastSeen. reflexivity.
Qed.
