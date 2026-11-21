From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.semaphore Require Import LinklistResumeSemaphore_goal.
From CRTOS_Verify.VC.semaphore Require Import LinklistResumeSemaphore_proof_auto.
Require Import CRTOS_Verify.lib.id.IdModuleSpec.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreDelete CRTOS_Verify.lib.delay.KTaskUnSetDelay.
Require Import CRTOS_Verify.lib.list.DoubleLinkListSpec CRTOS_Verify.lib.task.TaskStatusMemory CRTOS_Verify.lib.task.KTaskParseInfo.
Import IDNode DLL.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreAbandon.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreObtain.
Import SimpleC.CoreLang.CTypes.SimpleCtypeNotations.
Local Open Scope sac.

Lemma proof_of_LinklistResume_return_wit_1_split_goal_1 : LinklistResume_return_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistResume_return_wit_1 : LinklistResume_return_wit_1.
Proof. Admitted.

Lemma proof_of_LinklistResume_which_implies_wit_1 : LinklistResume_which_implies_wit_1.
Proof. Admitted.

Lemma proof_of_LinklistResume_which_implies_wit_2_split_goal_spatial : LinklistResume_which_implies_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistResume_which_implies_wit_2 : LinklistResume_which_implies_wit_2.
Proof. Admitted.

Lemma proof_of_LinklistResume_which_implies_wit_3 : LinklistResume_which_implies_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hseg : forall ns x px y py n, In n ns ->
    dllseg store_idnode x px y py (idnodes_to_dll ns) |--
    store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n) **
    (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n) -*
      dllseg store_idnode x px y py (idnodes_to_dll ns))).
  { induction ns as [|a ns IH]; intros x px y py n Hin; [contradiction|].
    remember (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n) -*
      dllseg store_idnode x px y py (idnodes_to_dll (a::ns))) as W eqn:HW.
    cbn [idnodes_to_dll map idnode_to_dll getData getPtr dllseg]. Intros z.
    fold (dllseg store_idnode z x y py (idnodes_to_dll ns)).
    destruct Hin as [Heq|Hin].
    - subst n. unfold store_idnode at 1. Intros.
      cancel (store_ushort (&(((idnode_addr a)) # "IdNode" ->ₛ "id")) (idnode_id a)).
      subst W. apply_sepcon_adjoint.
      cbn [idnodes_to_dll map idnode_to_dll getData getPtr dllseg]. Exists z.
      unfold store_idnode. split_pure_spatial; [sepcon_assoc_change; cancel | split_pures; dump_pre_spatial; tauto].
      all: cbn [idnode_to_dll getData getPtr]; cancel.
    - sep_apply_l_atomic (IH z x y py n Hin).
      cancel (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n)).
      subst W. apply_sepcon_adjoint.
      sep_apply_l_atomic (derivable1_wand_elim1
        (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n))
        (dllseg store_idnode z x y py (idnodes_to_dll ns))).
      cbn [idnodes_to_dll map idnode_to_dll getData getPtr dllseg]. Exists z.
      split_pure_spatial; [sepcon_assoc_change; cancel | split_pures; dump_pre_spatial; assumption].
      change (dllseg store_idnode z x y py (idnodes_to_dll ns) |-- dllseg store_idnode z x y py (idnodes_to_dll ns)). cancel.
  }
  assert (Hnodes : forall ns h n, In n ns ->
    store_idnodes h ns |--
    store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n) **
    (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n) -* store_idnodes h ns)).
  { intros ns h n Hin.
    remember (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n) -* store_idnodes h ns) as W eqn:HW.
    unfold store_idnodes, store_dll at 1. Intros hd pt.
    sep_apply_l_atomic (Hseg ns hd h h pt n Hin).
    cancel (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n)).
    subst W. apply_sepcon_adjoint.
    sep_apply_l_atomic (derivable1_wand_elim1
      (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n))
      (dllseg store_idnode hd h h pt (idnodes_to_dll ns))).
    unfold store_idnodes, store_dll. Exists hd pt.
    split_pure_spatial; [sepcon_assoc_change; cancel | split_pures; dump_pre_spatial; assumption].
  }
  assert (Hbucket : forall ns h n, In n ns ->
    store_idbucket h ns |--
    store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n) **
    (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n) -* store_idbucket h ns)).
  { intros ns h n Hin. destruct ns as [|a ns]; [contradiction|].
    cbn [store_idbucket]. apply Hnodes. exact Hin. }
  assert (Hbuckets : forall bs ht idx n, In n (List.concat bs) ->
    store_idbucket_list ht idx bs |--
    store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n) **
    (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n) -* store_idbucket_list ht idx bs)).
  { induction bs as [|b bs IH]; intros ht idx n Hin; [contradiction|].
    remember (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n) -* store_idbucket_list ht idx (b::bs)) as W eqn:HW.
    cbn [store_idbucket_list]. cbn [List.concat] in Hin. apply in_app_iff in Hin.
    destruct Hin as [Hin|Hin].
    - sep_apply_l_atomic (Hbucket b (ht + idx * sizeof("SysDoubleLinklistNode")) n Hin).
      cancel (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n)).
      subst W. apply_sepcon_adjoint.
      sep_apply_l_atomic (derivable1_wand_elim1
        (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n))
        (store_idbucket (ht + idx * sizeof("SysDoubleLinklistNode")) b)).
      cbn [store_idbucket_list]. sepcon_assoc_change. cancel.
    - sep_apply_l_atomic (IH ht (idx+1) n Hin).
      cancel (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n)).
      subst W. apply_sepcon_adjoint.
      sep_apply_l_atomic (derivable1_wand_elim1
        (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n))
        (store_idbucket_list ht (idx+1) bs)).
      cbn [store_idbucket_list]. sepcon_assoc_change. cancel.
  }
  assert (Hindexed : forall off bs start n,
    idbuckets_index_ok off start bs -> In n (List.concat bs) ->
    0 <= idnode_id n mod off - start < Zlength bs /\
    In n (Znth (idnode_id n mod off - start) bs nil)).
  { intros off bs; induction bs as [|b bs IH]; intros start n Hidx Hin; [contradiction|].
    cbn [idbuckets_index_ok] in Hidx. destruct Hidx as [Hb Hbs].
    cbn [List.concat] in Hin. apply in_app_iff in Hin. destruct Hin as [Hin|Hin].
    - apply Forall_forall with (x:=n) in Hb; [|exact Hin].
      rewrite Hb, Z.sub_diag. split.
      + rewrite Zlength_cons. pose proof (Zlength_nonneg bs); lia.
      + exact Hin.
    - specialize (IH (start+1) n Hbs Hin). destruct IH as [Hrange Hmem].
      split.
      + rewrite Zlength_cons. lia.
      + rewrite Znth_cons by lia.
        replace (idnode_id n mod off - start - 1) with (idnode_id n mod off - (start+1)) by lia. exact Hmem.
  }
  unfold os_inv at 1. Intros_p Hworld.
  unfold task_inv at 1. Intros_p Htask.
  unfold store_idmanager at 1. Intros_p Hbucketok.
  assert (Hwait : In first (semaphore_waiters (os_semaphores before_semaphore_head_ic))).
  { destruct PreH1 as [obj [Hobj [Haddr Hpending]]].
    unfold semaphore_waiters. apply in_concat.
    exists (semaphore_pending_addrs obj). split.
    - apply in_map. exact Hobj.
    - destruct (semaphore_pending_addrs obj) as [|a xs] eqn:Hp; [discriminate|].
      cbn [map] in Hpending. injection Hpending as Hfirst Htail.
      subst a. left. reflexivity. }
  assert (Ht : In first (task_ptr_list (os_tasks before_semaphore_head_ic))).
  { eapply os_sched_owners_in_task_list; [exact Htask|exact Hworld|].
    unfold os_sched_owners. repeat rewrite in_app_iff. tauto. }
  assert (Hnodeaddr : In (&(first # "TaskDescriptor" ->ₛ "id")) (map idnode_addr (task_id_nodes before_semaphore_head_ic))).
  { eapply Permutation_in.
    - apply Permutation_sym. exact (task_wf_id_nodes before_semaphore_head_ic Htask).
    - apply in_map_iff. exists first. split; [reflexivity|exact Ht]. }
  apply in_map_iff in Hnodeaddr. destruct Hnodeaddr as [n [Haddrn Hinn]].
  unfold task_id_nodes in Hinn.
  pose proof Hbucketok as Hbok.
  destruct Hbok as [Hoff [Hlen [Hids [Hnodesok [Hindices Hperm]]]]].
  pose proof (Hindexed _ _ 0 n Hindices Hinn) as [_ Hmember].
  rewrite Z.sub_0_r in Hmember.
  assert (Hidin : In (idnode_id n) (idlist (task_idmanager_abs (os_tasks before_semaphore_head_ic)))).
  { eapply Permutation_in; [exact Hperm|]. unfold idnode_ids. apply in_map. exact Hinn. }
  assert (Hidrange : 0 <= idnode_id n < idmax (task_stable_ids (os_task_stable sg_semaphore_head_ic))).
  { pose proof (proj1 Hids) as Hrange. apply Forall_forall with (x:=idnode_id n) in Hrange; [exact Hrange|exact Hidin]. }
  assert (Hquery : get_task_with_idnode_success sg_semaphore_head_ic before_semaphore_head_ic (idnode_id n) first).
  { unfold get_task_with_idnode_success. split; [exact Hidrange|]. split.
    - apply id_in_ids_true_iff. exact Hidin.
    - exists (idnode_addr n). split; [exact Haddrn|]. split; [|exact Ht].
      destruct n; exact Hmember. }
  assert (Haddr : &(((idnode_addr n)) # "IdNode" ->ₛ "id") = &(first # "TaskDescriptor" ->ₛ "id" .ₛ "id")).
  { rewrite Haddrn. csimpl. reflexivity. }
  unfold store_idbuckets.
  sep_apply_l_atomic (Hbuckets (idbuckets (task_idmanager_abs (os_tasks before_semaphore_head_ic))) (htable (task_stable_ids (os_task_stable sg_semaphore_head_ic))) 0 n Hinn).
  prop_apply_p (valid_store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n)). Intros.
  Exists (idnode_id n). split_pure_spatial.
  - rewrite <- Haddr.
    cancel (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n)).
    apply_sepcon_adjoint.
    sep_apply_l_atomic (derivable1_wand_elim1
      (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n))
      (store_idbucket_list (htable (task_stable_ids (os_task_stable sg_semaphore_head_ic))) 0
        (idbuckets (task_idmanager_abs (os_tasks before_semaphore_head_ic))))).
    unfold os_inv, task_inv, store_idmanager, store_idbuckets.
    split_pure_spatial; [sepcon_assoc_change; cancel | split_pures; dump_pre_spatial; assumption].
  - split_pures; dump_pre_spatial; try assumption; try reflexivity; lia.
Qed.

Lemma proof_of_LinklistResume_which_implies_wit_4_split_goal_spatial : LinklistResume_which_implies_wit_4_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  sep_apply_l_atomic (derivable1_wand_elim1 (store_ushort (&(first # "TaskDescriptor" ->ₛ "id" .ₛ "id")) task_id) (os_inv sg_semaphore_head_ic before_semaphore_head_ic)).
  cancel.
Qed.

Lemma proof_of_LinklistResume_which_implies_wit_4 : LinklistResume_which_implies_wit_4.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_LinklistResume_which_implies_wit_4_split_goal_spatial.
Qed.

