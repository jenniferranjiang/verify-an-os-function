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
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_entail_wit_2 : _SemaphoreDelete_entail_wit_2.
Proof. Admitted.

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
Proof. Abort.

Lemma proof_of__SemaphoreDelete_partial_solve_wit_9_pure : _SemaphoreDelete_partial_solve_wit_9_pure.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_1 : _SemaphoreDelete_which_implies_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_2 : _SemaphoreDelete_which_implies_wit_1_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_3 : _SemaphoreDelete_which_implies_wit_1_split_goal_3.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1_split_goal_spatial : _SemaphoreDelete_which_implies_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreDelete_which_implies_wit_1 : _SemaphoreDelete_which_implies_wit_1.
Proof. Admitted.

Lemma proof_of__SemaphoreDelete_which_implies_wit_2_split_goal_spatial : _SemaphoreDelete_which_implies_wit_2_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst sem.
  assert (HB : forall (A:Type) (sa: addr -> A -> Assertion) (l:list (DL_Node A))
    (n:DL_Node A) x px y py,
    In n l -> dllseg sa x px y py l |--
    sa n.(ptr) n.(data) ** (sa n.(ptr) n.(data) -* dllseg sa x px y py l)).
  { intros A sa l n x px y py Hin.
    apply in_split in Hin. destruct Hin as [l1 [l2 Heq]]. subst l.
    remember (sa n.(ptr) n.(data) -* dllseg sa x px y py (l1 ++ n::l2)) as W eqn:HW.
    sep_apply_l_atomic (dllseg_split sa x px y py l1 (n::l2)).
    Intros q pq. cbn [dllseg]. Intros z. subst q.
    cancel (sa n.(ptr) n.(data)).
    subst W. apply_sepcon_adjoint.
    sep_apply_r_atomic (dllseg_concat sa x px n.(ptr) pq y py l1 (n::l2)).
    cbn [dllseg]. Exists z.
    split_pure_spatial; [sepcon_assoc_change; cancel | dump_pre_spatial; reflexivity].
  }
  match goal with |- _ |-- ?P ** ?R => remember R as W eqn:HW end.
  unfold os_inv at 1. unfold semaphore_inv at 1. Intros.
  unfold store_dll at 1. Intros h pt.
  sep_apply_l_atomic (HB SemaphoreAbs
    (store_semaphore (pure_suspend_sched_link (task_desc_map (os_tasks before_dataqueue_cleanup_ic))))
    (map semaphore_link_node (os_semaphores before_dataqueue_cleanup_ic))
    (semaphore_link_node original) h
    (semaphore_list_head (os_semaphore_stable sg_dataqueue_cleanup_ic))
    (semaphore_list_head (os_semaphore_stable sg_dataqueue_cleanup_ic)) pt
    (in_map semaphore_link_node _ _ PreH1)).
  cbn [semaphore_link_node getPtr getData].
  unfold store_semaphore at 1. Intros.
  rewrite PreH3. cbn [map].
  match goal with |- ?L |-- _ => match L with context[?P -* ?Q] => remember (P -* Q) as Wseg eqn:HWseg end end.
  csimpl. sepcon_assoc_change.
  match goal with |- _ |-- ?P ** _ => sepcon_lift P end.
  match goal with |- _ ** (_ ** (?L ** _)) |-- ?R ** _ =>
    assert (L = R) as Hsame by reflexivity; try rewrite <- Hsame
  end.
  match goal with |- _ |-- ?P ** _ => cancel P end.
  subst W. apply_sepcon_adjoint.
  subst Wseg.
  unfold os_inv, semaphore_inv. unfold store_dll at 2. Exists h pt.
  split_pure_spatial.
  - sepcon_assoc_change. cancel.
    match goal with |- ?L |-- ?Q => match L with context[?P -* Q] =>
      sep_apply_r_atomic (derivable1_wand_elim1 P Q);
      cancel (P -* Q)
    end end.
    unfold store_semaphore. rewrite PreH3. cbn [map].
    split_pure_spatial; [csimpl; sepcon_assoc_change; repeat progress cancel; reflexivity | dump_pre_spatial; exact H2].
  - split_pures; dump_pre_spatial; tauto.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_2 : _SemaphoreDelete_which_implies_wit_2.
Proof. aggressive_pre_process. Goal_apply proof_of__SemaphoreDelete_which_implies_wit_2_split_goal_spatial. Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_3_split_goal_spatial : _SemaphoreDelete_which_implies_wit_3_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  apply derivable1_wand_elim2.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_3 : _SemaphoreDelete_which_implies_wit_3.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreDelete_which_implies_wit_3_split_goal_spatial.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_spatial : _SemaphoreDelete_which_implies_wit_4_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst sem.
  assert (HB : forall (A:Type) (sa: addr -> A -> Assertion) (l:list (DL_Node A))
    (n:DL_Node A) x px y py,
    In n l -> dllseg sa x px y py l |--
    sa n.(ptr) n.(data) ** (sa n.(ptr) n.(data) -* dllseg sa x px y py l)).
  { intros A sa l n x px y py Hin.
    apply in_split in Hin. destruct Hin as [l1 [l2 Heq]]. subst l.
    remember (sa n.(ptr) n.(data) -* dllseg sa x px y py (l1 ++ n::l2)) as W eqn:HW.
    sep_apply_l_atomic (dllseg_split sa x px y py l1 (n::l2)).
    Intros q pq. cbn [dllseg]. Intros z. subst q.
    cancel (sa n.(ptr) n.(data)).
    subst W. apply_sepcon_adjoint.
    sep_apply_r_atomic (dllseg_concat sa x px n.(ptr) pq y py l1 (n::l2)).
    cbn [dllseg]. Exists z.
    split_pure_spatial; [sepcon_assoc_change; cancel | dump_pre_spatial; reflexivity].
  }

  assert (HN : forall head nodes node, let p := idnode_addr node in
    In node nodes -> store_idnodes head nodes |--
    store_ushort (&(p # "IdNode" ->ₛ "id")) node.(idnode_id) **
    (store_ushort (&(p # "IdNode" ->ₛ "id")) node.(idnode_id) -* store_idnodes head nodes)).
  { intros head nodes node. cbv zeta. intro Hin.
    match goal with |- _ |-- _ ** ?R => remember R as W eqn:HW end.
    unfold store_idnodes at 1. unfold store_dll at 1. Intros h pt.
    sep_apply_l_atomic (HB IdNodeAbs store_idnode (idnodes_to_dll nodes)
      (idnode_to_dll node) h head head pt (in_map idnode_to_dll _ _ Hin)).
    cbn [idnode_to_dll getPtr getData].
    unfold store_idnode at 1. Intros.
    match goal with |- _ |-- ?P ** _ => cancel P end.
    subst W. apply_sepcon_adjoint.
    unfold store_idnodes, store_dll. Exists h pt.
    split_pure_spatial.
    - sepcon_assoc_change. cancel.
      match goal with |- ?L |-- ?Q => match L with context[?P -* Q] =>
        sep_apply_r_atomic (derivable1_wand_elim1 P Q); cancel (P -* Q)
      end end.
      unfold store_idnode. split_pure_spatial; [reflexivity | dump_pre_spatial; assumption].
    - dump_pre_spatial. assumption.
  }
  assert (HK : forall buckets node h start, let p := idnode_addr node in
    (exists bucket, In bucket buckets /\ In node bucket) ->
    store_idbucket_list h start buckets |--
    store_ushort (&(p # "IdNode" ->ₛ "id")) node.(idnode_id) **
    (store_ushort (&(p # "IdNode" ->ₛ "id")) node.(idnode_id) -* store_idbucket_list h start buckets)).
  { intro buckets. induction buckets as [|b bs IH]; intros node h start; cbv zeta; intros [bucket [Hin Hnode]].
    - contradiction.
    - destruct Hin as [Heq | Hin].
      + subst bucket. destruct b as [|n ns]; [contradiction|].
        match goal with |- _ |-- _ ** ?R => remember R as W eqn:HW end.
        cbn [store_idbucket_list store_idbucket].
        sep_apply_l_atomic (HN (h + start * sizeof("SysDoubleLinklistNode")) (n::ns) node Hnode).
        match goal with |- _ |-- ?P ** _ => sepcon_lift P; cancel P end.
        subst W. apply_sepcon_adjoint.
        cbn [store_idbucket_list store_idbucket].
        cancel (store_idbucket_list h (start+1) bs).
        apply derivable1_wand_elim1.
      + match goal with |- _ |-- _ ** ?R => remember R as W eqn:HW end.
        cbn [store_idbucket_list].
        sep_apply_l_atomic (IH node h (start+1) (ex_intro _ bucket (conj Hin Hnode))).
        match goal with |- _ |-- ?P ** _ => sepcon_lift P; cancel P end.
        subst W. apply_sepcon_adjoint.
        cbn [store_idbucket_list].
        cancel (store_idbucket (h + start * sizeof("SysDoubleLinklistNode")) b).
        apply derivable1_wand_elim1.
  }
  assert (Hex : exists bucket,
      In bucket (idbuckets (semaphore_manager (os_semaphores before_dataqueue_cleanup_ic))) /\
      In (semaphore_idnode original) bucket).
  { set (i := semaphore_id original mod 16).
    assert (Hi : 0 <= i < 16) by (unfold i; apply Z.mod_pos_bound; lia).
    exists (map semaphore_idnode
      (filter (fun s => Z.eqb (semaphore_id s mod 16) (Z.of_nat (Z.to_nat i)))
      (os_semaphores before_dataqueue_cleanup_ic))).
    split.
    - unfold semaphore_manager. cbn [idbuckets].
      apply in_map_iff. exists (Z.to_nat i). split; [reflexivity|].
      apply in_seq. split; [lia|].
      apply (proj1 (Z2Nat.inj_lt i 16 ltac:(lia) ltac:(lia))). lia.
    - apply in_map. apply filter_In. split; [exact PreH1|].
      apply Z.eqb_eq. rewrite Z2Nat.id by lia. reflexivity.
  }
  match goal with |- _ |-- _ ** ?R => remember R as W eqn:HW end.
  unfold os_inv at 1. unfold semaphore_inv at 1.
  unfold store_idmanager, store_idbuckets. Intros.
  sep_apply_l_atomic (HK
    (idbuckets (semaphore_manager (os_semaphores before_dataqueue_cleanup_ic)))
    (semaphore_idnode original)
    (htable (semaphore_manager_stable (os_semaphore_stable sg_dataqueue_cleanup_ic))) 0 Hex).
  cbn [semaphore_idnode idnode_addr idnode_id]. csimpl.
  match goal with |- ?L ** _ |-- ?R ** _ =>
    assert (L = R) as Hsame by reflexivity; try rewrite <- Hsame
  end.
  match goal with |- _ |-- ?P ** _ => cancel P end.
  subst W. apply_sepcon_adjoint.
  unfold os_inv, semaphore_inv, store_idmanager, store_idbuckets.
  split_pure_spatial.
  - sepcon_assoc_change. repeat progress cancel.
    csimpl. apply derivable1_wand_elim1.
  - split_pures; dump_pre_spatial; assumption.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_4 : _SemaphoreDelete_which_implies_wit_4.
Proof. aggressive_pre_process. Goal_apply proof_of__SemaphoreDelete_which_implies_wit_4_split_goal_spatial. Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_5_split_goal_spatial : _SemaphoreDelete_which_implies_wit_5_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  apply derivable1_wand_elim2.
Qed.

Lemma proof_of__SemaphoreDelete_which_implies_wit_5 : _SemaphoreDelete_which_implies_wit_5.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreDelete_which_implies_wit_5_split_goal_spatial.
Qed.

