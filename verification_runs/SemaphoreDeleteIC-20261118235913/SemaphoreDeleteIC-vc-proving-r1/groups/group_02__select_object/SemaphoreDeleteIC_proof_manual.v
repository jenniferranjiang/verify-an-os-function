From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.semaphore Require Import SemaphoreDeleteIC_goal.
From CRTOS_Verify.VC.semaphore Require Import SemaphoreDeleteIC_proof_auto.
Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreDelete.
Require Import CRTOS_Verify.lib.id.idnode CRTOS_Verify.lib.id.IdModuleSpec CRTOS_Verify.lib.common.dll CRTOS_Verify.lib.list.NodeSelfLinked.
Import IDNode DLL.
Local Open Scope sac.

Lemma proof_of__SemaphoreDelete_entail_wit_1 : _SemaphoreDelete_entail_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hfind : forall sm st manager ret id,
    0 < sm.(hoffset) ->
    store_idmanager_found sm (semaphore_manager st) manager ret id |--
    “ exists original, In original st /\ semaphore_id original = id /\
      ret = &(((semaphore_addr original)) # "Semaphore" ->ₛ "id") ”).
  { intros sm st manager ret id Hpos.
    unfold store_idmanager_found. Intros bytes prefix suffix bucket.
    dump_pre_spatial.
    destruct H as [Hrange [Hmap [Hb [Hbucket Hsplit]]]].
    assert (Hbin : In bucket (idbuckets (semaphore_manager st))).
    { rewrite Hbucket. apply Znth_In_Zlength.
      destruct Hb as [_ [Hlen _]]. rewrite Hlen.
      apply Z.mod_pos_bound; assumption. }
    assert (Hnode : In (Build_IdNodeAbs id ret) bucket).
    { rewrite Hsplit. apply in_or_app. right. left. reflexivity. }
    cbn [semaphore_manager idbuckets] in Hbin.
    apply in_map_iff in Hbin. destruct Hbin as [i [Heq Hi]].
    rewrite <- Heq in Hnode. apply in_map_iff in Hnode.
    destruct Hnode as [original [Hnode Hmem]].
    apply filter_In in Hmem. destruct Hmem as [Hmem _].
    exists original. split; [assumption|].
    split.
    - exact (f_equal idnode_id Hnode).
    - symmetry. exact (f_equal idnode_addr Hnode). }
  assert (Hnz : forall wait st x px y py original,
    In original st ->
    dllseg (store_semaphore wait) x px y py (map semaphore_link_node st) |--
    “ semaphore_addr original <> 0 ”).
  { intros wait st. induction st as [|a st IH]; intros x px y py original Hin.
    - contradiction.
    - cbn [map]. unfold dllseg at 1. fold (@dllseg SemaphoreAbs).
      cbn [semaphore_link_node getPtr getData]. Intros z.
      destruct Hin as [Heq|Hin].
      + subst original. unfold store_semaphore. Intros. dump_pre_spatial. tauto.
      + prop_apply_p (IH z x y py original Hin). Intros. dump_pre_spatial. assumption. }
  assert (Hnzdll : forall wait st head original,
    In original st -> store_dll (store_semaphore wait) head (map semaphore_link_node st) |--
    “ semaphore_addr original <> 0 ”).
  { intros wait st head original Hin. unfold store_dll. Intros h pt.
    prop_apply_p (Hnz wait st h head head pt original Hin). Intros. dump_pre_spatial. assumption. }
  assert (Hpos : 0 < hoffset (semaphore_manager_stable (os_semaphore_stable sg_dataqueue_cleanup_ic))).
  { unfold semaphore_context in *. lia. }
  prop_apply_p (Hfind (semaphore_manager_stable (os_semaphore_stable sg_dataqueue_cleanup_ic))
    (os_semaphores before_dataqueue_cleanup_ic) &("k_sem_id_manager") retval id_pre Hpos).
  Intros.
  match goal with Hx : exists _, _ |- _ => destruct Hx as [original [Hin [Hid Haddr]]] end.
  prop_apply_p (Hnzdll (pure_suspend_sched_link (task_desc_map (os_tasks before_dataqueue_cleanup_ic)))
    (os_semaphores before_dataqueue_cleanup_ic) &("k_sem_list") original Hin).
  Intros.
  sep_apply (store_idmanager_found_store_idmanager
    (semaphore_manager_stable (os_semaphore_stable sg_dataqueue_cleanup_ic))
    (semaphore_manager (os_semaphores before_dataqueue_cleanup_ic)) &("k_sem_id_manager") retval id_pre).
  assert (Hpending : semaphore_pending_addrs original = nil).
  { unfold semaphore_delete_quiescent in *.
    match goal with Hq : 0 <= id_pre <= 65535 -> _ |- _ =>
      destruct (Hq ltac:(lia)) as [Hq' _]; apply Hq'; [exact Hin|] end.
    unfold semaphore_query_id. rewrite Z.mod_small by lia. exact Hid. }
  Exists original.
  unfold os_inv, semaphore_inv.
  match goal with Hc : semaphore_context _ |- _ => pose proof Hc as Hctx; destruct Hc as [Hp [_ [_ [_ [_ Hl]]]]] end.
  rewrite Hp, Hl.
  split_pure_spatial; [sepcon_assoc_change; repeat progress cancel|].
  split_pures; dump_pre_spatial; try assumption; try reflexivity; try lia.
Qed.

Lemma proof_of__SemaphoreDelete_entail_wit_2 : _SemaphoreDelete_entail_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hnd : forall sm m p, store_idmanager sm m p |-- “ NoDup m.(idlist) ”).
  { intros sm m p. unfold store_idmanager. Intros.
    dump_pre_spatial. unfold idbuckets_ok, idlist_ok in *. tauto. }
  unfold os_inv, semaphore_inv. Intros.
  prop_apply_p (Hnd (semaphore_manager_stable (os_semaphore_stable sg_dataqueue_cleanup_ic))
    (semaphore_manager (os_semaphores before_dataqueue_cleanup_ic))
    (semaphore_manager_ptr (os_semaphore_stable sg_dataqueue_cleanup_ic))).
  Intros.
  match goal with Hi : In original _ |- _ => destruct (in_split _ _ Hi) as [prefix [suffix Hsplit]] end.
  Exists prefix suffix.
  assert (Hquery : IDNodePure.idmanager_query (semaphore_manager (os_semaphores before_dataqueue_cleanup_ic)) (semaphore_id original) = true).
  { unfold IDNodePure.idmanager_query. apply IDNode.id_in_ids_true_iff.
    cbn [semaphore_manager idlist]. apply in_map. assumption. }
  match goal with Hc : semaphore_context _ |- _ => pose proof Hc as Hctx; destruct Hc as [Hp [_ [_ [_ [_ Hl]]]]] end.
  rewrite Hp, Hl.
  split_pure_spatial.
  - rewrite Hsplit, map_app. cbn [map semaphore_link_node]. sepcon_assoc_change. repeat progress cancel. unfold semaphore_link_node. cancel.
  - split_pures; dump_pre_spatial; try assumption; try reflexivity; try lia.
Qed.

Lemma proof_of__SemaphoreDelete_entail_wit_3_1 : _SemaphoreDelete_entail_wit_3_1.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_entail_wit_3_2 : _SemaphoreDelete_entail_wit_3_2.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_return_wit_1 : _SemaphoreDelete_return_wit_1.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_return_wit_2 : _SemaphoreDelete_return_wit_2.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_return_wit_3_split_goal_1 : _SemaphoreDelete_return_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_return_wit_3 : _SemaphoreDelete_return_wit_3.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_return_wit_4_split_goal_1 : _SemaphoreDelete_return_wit_4_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_return_wit_4 : _SemaphoreDelete_return_wit_4.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_9_pure_split_goal_1 : _SemaphoreDelete_partial_solve_wit_9_pure_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial. apply addr_of_LE_var_not_zero.
Qed.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_9_pure : _SemaphoreDelete_partial_solve_wit_9_pure.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreDelete_partial_solve_wit_9_pure_split_goal_1.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_1 : _SemaphoreDelete_which_implies_wit_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv, semaphore_inv, store_idmanager.
  Intros.
  dump_pre_spatial.
  unfold idbuckets_ok, idlist_ok in *.
  cbn [semaphore_manager idlist] in *. tauto.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_2 : _SemaphoreDelete_which_implies_wit_1_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv, semaphore_inv. Intros.
  dump_pre_spatial. assumption.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_3 : _SemaphoreDelete_which_implies_wit_1_split_goal_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv. Intros.
  dump_pre_spatial. assumption.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_spatial : _SemaphoreDelete_which_implies_wit_1_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold os_inv, semaphore_inv. Intros.
  match goal with Hc : semaphore_context _ |- _ => pose proof Hc as Hctx; destruct Hc as [Hp [_ [_ [_ [_ Hl]]]]] end.
  rewrite Hp, Hl. cancel.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1 : _SemaphoreDelete_which_implies_wit_1.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_spatial.
  - Goal_apply proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_1.
  - Goal_apply proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_2.
  - Goal_apply proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_3.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_2_split_goal_spatial : _SemaphoreDelete_which_implies_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_2 : _SemaphoreDelete_which_implies_wit_2.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_which_implies_wit_3_split_goal_spatial : _SemaphoreDelete_which_implies_wit_3_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_3 : _SemaphoreDelete_which_implies_wit_3.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_spatial : _SemaphoreDelete_which_implies_wit_4_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_4 : _SemaphoreDelete_which_implies_wit_4.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_which_implies_wit_5_split_goal_spatial : _SemaphoreDelete_which_implies_wit_5_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_5 : _SemaphoreDelete_which_implies_wit_5.
Proof. Admitted.

