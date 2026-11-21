From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.pendlist Require Import LinklistSuspendSemaphore_goal.
From CRTOS_Verify.VC.pendlist Require Import LinklistSuspendSemaphore_proof_auto.
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

Lemma proof_of_LinklistSuspend_entail_wit_1_1 : LinklistSuspend_entail_wit_1_1.
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
  pose proof PreH4 as Hadmissible.
  destruct Hadmissible as [desc [Hlookup Hadmissible]].
  unfold os_inv at 1. unfold task_inv at 1. unfold store_idmanager at 1. Intros.
  assert (Ht : In task_pre (task_ptr_list (os_tasks before_semaphore_ic))) by (eapply task_wf_map_present; eauto).
  assert (Hnodeaddr : In (&(task_pre # "TaskDescriptor" ->ₛ "id")) (map idnode_addr (task_id_nodes before_semaphore_ic))).
  { eapply Permutation_in.
    - apply Permutation_sym. exact (task_wf_id_nodes before_semaphore_ic H0).
    - apply in_map_iff. exists task_pre. split; [reflexivity|exact Ht]. }
  apply in_map_iff in Hnodeaddr. destruct Hnodeaddr as [n [Haddrn Hinn]].
  unfold task_id_nodes in Hinn.
  pose proof H1 as Hbok.
  destruct Hbok as [Hoff [Hlen [Hids [Hnodesok [Hindices Hperm]]]]].
  pose proof (Hindexed _ _ 0 n Hindices Hinn) as [_ Hmember].
  rewrite Z.sub_0_r in Hmember.
  assert (Hidin : In (idnode_id n) (idlist (task_idmanager_abs (os_tasks before_semaphore_ic)))).
  { eapply Permutation_in; [exact Hperm|]. unfold idnode_ids. apply in_map. exact Hinn. }
  assert (Hidrange : 0 <= idnode_id n < idmax (task_stable_ids (os_task_stable sg_semaphore_ic))).
  { pose proof (proj1 Hids) as Hrange. apply Forall_forall with (x:=idnode_id n) in Hrange; [exact Hrange|exact Hidin]. }
  assert (Hquery : get_task_with_idnode_success sg_semaphore_ic before_semaphore_ic (idnode_id n) task_pre).
  { unfold get_task_with_idnode_success. split; [exact Hidrange|]. split.
    - apply id_in_ids_true_iff. exact Hidin.
    - exists (idnode_addr n). split; [exact Haddrn|]. split; [|exact Ht].
      destruct n; exact Hmember. }
  assert (Haddr : &(((idnode_addr n)) # "IdNode" ->ₛ "id") = &(task_pre # "TaskDescriptor" ->ₛ "id" .ₛ "id")).
  { rewrite Haddrn. csimpl. reflexivity. }
  unfold store_idbuckets.
  sep_apply_l_atomic (Hbuckets (idbuckets (task_idmanager_abs (os_tasks before_semaphore_ic))) (htable (task_stable_ids (os_task_stable sg_semaphore_ic))) 0 n Hinn).
  prop_apply_p (valid_store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n)). Intros.
  Exists (idnode_id n). split_pure_spatial.
  - rewrite <- Haddr.
    cancel (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n)).
    apply_sepcon_adjoint.
    sep_apply_l_atomic (derivable1_wand_elim1
      (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n))
      (store_idbucket_list (htable (task_stable_ids (os_task_stable sg_semaphore_ic))) 0
        (idbuckets (task_idmanager_abs (os_tasks before_semaphore_ic))))).
    unfold os_inv, task_inv, store_idmanager, store_idbuckets.
    split_pure_spatial; [sepcon_assoc_change; cancel | split_pures; dump_pre_spatial; assumption].
  - split_pures; dump_pre_spatial; try assumption; try reflexivity; lia.
Qed.

Lemma proof_of_LinklistSuspend_entail_wit_1_2 : LinklistSuspend_entail_wit_1_2.
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
  pose proof PreH5 as Hadmissible.
  destruct Hadmissible as [desc [Hlookup Hadmissible]].
  unfold os_inv at 1. unfold task_inv at 1. unfold store_idmanager at 1. Intros.
  assert (Ht : In task_pre (task_ptr_list (os_tasks before_semaphore_ic))) by (eapply task_wf_map_present; eauto).
  assert (Hnodeaddr : In (&(task_pre # "TaskDescriptor" ->ₛ "id")) (map idnode_addr (task_id_nodes before_semaphore_ic))).
  { eapply Permutation_in.
    - apply Permutation_sym. exact (task_wf_id_nodes before_semaphore_ic H0).
    - apply in_map_iff. exists task_pre. split; [reflexivity|exact Ht]. }
  apply in_map_iff in Hnodeaddr. destruct Hnodeaddr as [n [Haddrn Hinn]].
  unfold task_id_nodes in Hinn.
  pose proof H1 as Hbok.
  destruct Hbok as [Hoff [Hlen [Hids [Hnodesok [Hindices Hperm]]]]].
  pose proof (Hindexed _ _ 0 n Hindices Hinn) as [_ Hmember].
  rewrite Z.sub_0_r in Hmember.
  assert (Hidin : In (idnode_id n) (idlist (task_idmanager_abs (os_tasks before_semaphore_ic)))).
  { eapply Permutation_in; [exact Hperm|]. unfold idnode_ids. apply in_map. exact Hinn. }
  assert (Hidrange : 0 <= idnode_id n < idmax (task_stable_ids (os_task_stable sg_semaphore_ic))).
  { pose proof (proj1 Hids) as Hrange. apply Forall_forall with (x:=idnode_id n) in Hrange; [exact Hrange|exact Hidin]. }
  assert (Hquery : get_task_with_idnode_success sg_semaphore_ic before_semaphore_ic (idnode_id n) task_pre).
  { unfold get_task_with_idnode_success. split; [exact Hidrange|]. split.
    - apply id_in_ids_true_iff. exact Hidin.
    - exists (idnode_addr n). split; [exact Haddrn|]. split; [|exact Ht].
      destruct n; exact Hmember. }
  assert (Haddr : &(((idnode_addr n)) # "IdNode" ->ₛ "id") = &(task_pre # "TaskDescriptor" ->ₛ "id" .ₛ "id")).
  { rewrite Haddrn. csimpl. reflexivity. }
  unfold store_idbuckets.
  sep_apply_l_atomic (Hbuckets (idbuckets (task_idmanager_abs (os_tasks before_semaphore_ic))) (htable (task_stable_ids (os_task_stable sg_semaphore_ic))) 0 n Hinn).
  prop_apply_p (valid_store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n)). Intros.
  Exists (idnode_id n). split_pure_spatial.
  - rewrite <- Haddr.
    cancel (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n)).
    apply_sepcon_adjoint.
    sep_apply_l_atomic (derivable1_wand_elim1
      (store_ushort (&(((idnode_addr n)) # "IdNode" ->ₛ "id")) (idnode_id n))
      (store_idbucket_list (htable (task_stable_ids (os_task_stable sg_semaphore_ic))) 0
        (idbuckets (task_idmanager_abs (os_tasks before_semaphore_ic))))).
    unfold os_inv, task_inv, store_idmanager, store_idbuckets.
    split_pure_spatial; [sepcon_assoc_change; cancel | split_pures; dump_pre_spatial; assumption].
  - split_pures; dump_pre_spatial; try assumption; try reflexivity; lia.
Qed.

Lemma proof_of_LinklistSuspend_entail_wit_2_1 : LinklistSuspend_entail_wit_2_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hdelayframe : forall p s t, ktask_unset_delay_step p s t ->
    os_tasks t = os_tasks s /\ os_semaphores t = os_semaphores s /\
    os_recycle t = os_recycle s /\ os_idle t = os_idle s).
  { intros p s t Hu. unfold ktask_unset_delay_step in Hu.
    destruct Hu as [[Hp Heq]|[[Hp [dd [Hl Heq]]]|[Hp [dd [Hin Hu]]]]].
    - subst t; auto.
    - subst t; auto.
    - destruct Hu. repeat split; assumption. }
  assert (Hframe : forall task s r t, ktask_suspend_step task s r t ->
    task_idmanager_abs (os_tasks t) = task_idmanager_abs (os_tasks s) /\
    os_semaphores t = os_semaphores s /\
    os_recycle t = os_recycle s /\ os_idle t = os_idle s).
  { intros task s r t Hstep. unfold ktask_suspend_step in Hstep.
    destruct Hstep as [_ [[Hbad [Hr Heq]]|[Hrun [d [Hl [[Ha [Hb [Hr Heq]]]|[Hr [mid [Hs Hu]]]]]]]]].
    - subst t; auto.
    - subst t; auto.
    - pose proof (Hdelayframe _ _ _ Hu) as [Htasks [Hsem [Hrecycle Hidle]]].
      rewrite Htasks, Hsem, Hrecycle, Hidle.
      repeat split; [exact (suspend_sched_ids _ _ _ _ Hs)|exact (suspend_sched_semaphores _ _ _ _ Hs)|exact (suspend_sched_recycle _ _ _ _ Hs)|exact (suspend_sched_idle _ _ _ _ Hs)]. }
  pose proof (Hframe _ _ _ _ PreH3) as [Hids [Hsem [Hrecycle Hidle]]].
  assert (Hinfo : os_inv sg_semaphore_ic after |--
    “ idbuckets_ok (idmax (task_stable_ids (os_task_stable sg_semaphore_ic)))
       (hoffset (task_stable_ids (os_task_stable sg_semaphore_ic)))
       (idlist (task_idmanager_abs (os_tasks before_semaphore_ic)))
       (idbuckets (task_idmanager_abs (os_tasks before_semaphore_ic))) ”).
  { unfold os_inv, task_inv, store_idmanager. Intros. dump_pre_spatial.
    rewrite <- Hids. assumption. }
  prop_apply_p Hinfo. Intros_p Hbk.
  destruct Hbk as [Hoff [Hlen [Hidsok [Hnodes [Hindices Hperm]]]]].
  assert (Hnd : NoDup (map idnode_id (List.concat (idbuckets (task_idmanager_abs (os_tasks before_semaphore_ic)))))).
  { eapply Permutation_NoDup; [apply Permutation_sym; exact Hperm|exact (proj2 Hidsok)]. }
  assert (Huniq : forall ns (a b : IdNodeAbs), NoDup (map idnode_id ns) ->
    In a ns -> In b ns -> idnode_id a = idnode_id b -> a = b).
  { induction ns as [|n ns IH]; intros a b Hno Ha Hb Heq; [contradiction|].
    cbn [map] in Hno. inversion Hno as [|nid ids Hnot Htail]; subst.
    destruct Ha as [Ha|Ha]; destruct Hb as [Hb|Hb].
    - congruence.
    - subst a. exfalso. apply Hnot. rewrite Heq. apply in_map. exact Hb.
    - subst b. exfalso. apply Hnot. rewrite <- Heq. apply in_map. exact Ha.
    - eapply IH; eauto. }
  assert (Hfound : found = task_pre).
  { destruct PreH2 as [Hr [Hq [p [Hp [Hin Htask]]]]].
    destruct PreH6 as [Hr2 [Hq2 [p2 [Hp2 [Hin2 Htask2]]]]].
    assert (Hidx : 0 <= idmanager_bucket_index (task_stable_ids (os_task_stable sg_semaphore_ic)) task_id < Zlength (idbuckets (task_idmanager_abs (os_tasks before_semaphore_ic)))) by
      (unfold idmanager_bucket_index; rewrite Hlen; apply Z.mod_pos_bound; exact Hoff).
    assert (Hbucket : In (Znth (idmanager_bucket_index (task_stable_ids (os_task_stable sg_semaphore_ic)) task_id)
      (idbuckets (task_idmanager_abs (os_tasks before_semaphore_ic))) nil)
      (idbuckets (task_idmanager_abs (os_tasks before_semaphore_ic)))) by (apply Znth_In_Zlength; exact Hidx).
    assert (Hina : In (Build_IdNodeAbs task_id p) (List.concat (idbuckets (task_idmanager_abs (os_tasks before_semaphore_ic))))) by
      (apply in_concat; eexists; split; [exact Hbucket|exact Hin]).
    assert (Hinb : In (Build_IdNodeAbs task_id p2) (List.concat (idbuckets (task_idmanager_abs (os_tasks before_semaphore_ic))))) by
      (apply in_concat; eexists; split; [exact Hbucket|exact Hin2]).
    pose proof (Huniq _ _ _ Hnd Hina Hinb eq_refl) as Heq.
    injection Heq as Heq. rewrite Hp, Hp2 in Heq. apply addr_of_arrow_field_inv in Heq. injection Heq as Heq. exact Heq. }
  subst found.
  pose proof PreH10 as Hadm. destruct Hadm as [desc [Hlookup Hadm]].
  specialize (Hadm ltac:(auto)). destruct Hadm as [Hservice Hadm].
  assert (Hpost : exists d,
    task_desc_map (os_tasks after) task_pre = Some d /\
    tsmStat (tdSchedMember d) = TSK_SUSPEND /\
    In task_pre (sched_owned_tasks (os_tasks after))).
  { pose proof PreH3 as Hstep. unfold ktask_suspend_step in Hstep.
    destruct Hstep as [_ [[Hbad [Hr Heq]]|[Hrun [d [Hl [[Ha [Hb [Hr Heq]]]|[Hr [mid [Hs Hu]]]]]]]]].
    - subst after. destruct Hadm as [[Heq _]|[Hst Hown]]; [contradiction|]. exists desc; auto.
    - subst after. assert (d = desc) by congruence. subst d.
      destruct Hadm as [[_ [Hst|Hst]]|[Hst Hown]]; try contradiction. exists desc; auto.
    - pose proof (Hdelayframe _ _ _ Hu) as [Ht _]. rewrite Ht.
      exists (update_sched_member d (set_sched_member_status (tdSchedMember d) TSK_SUSPEND)).
      split.
      + rewrite (suspend_sched_map _ _ _ _ Hs). unfold update_task_desc_map.
        destruct (Z.eq_dec task_pre task_pre); congruence.
      + split; [reflexivity|].
        destruct (suspend_sched_owned _ _ _ _ Hs) as [[Hin Heq]|[Hnin Heq]]; rewrite Heq; simpl; auto. }
  destruct Hpost as [d [Hd [Hst Hown]]].
  assert (Hpending : semaphore_pending_nodes sem_semaphore_ic after (map sched_link_node waiting_semaphore_ic)).
  { unfold semaphore_pending_nodes in *. rewrite Hsem. exact PreH9. }
  assert (Hservice_after : ktask_not_os_service task_pre after).
  { unfold ktask_not_os_service in *. rewrite Hrecycle, Hidle. exact Hservice. }
  Exists d retval after. split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed.

Lemma proof_of_LinklistSuspend_entail_wit_2_2 : LinklistSuspend_entail_wit_2_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hdelayframe : forall p s t, ktask_unset_delay_step p s t ->
    os_tasks t = os_tasks s /\ os_semaphores t = os_semaphores s /\
    os_recycle t = os_recycle s /\ os_idle t = os_idle s).
  { intros p s t Hu. unfold ktask_unset_delay_step in Hu.
    destruct Hu as [[Hp Heq]|[[Hp [dd [Hl Heq]]]|[Hp [dd [Hin Hu]]]]].
    - subst t; auto.
    - subst t; auto.
    - destruct Hu. repeat split; assumption. }
  assert (Hframe : forall task s r t, ktask_suspend_step task s r t ->
    task_idmanager_abs (os_tasks t) = task_idmanager_abs (os_tasks s) /\
    os_semaphores t = os_semaphores s /\
    os_recycle t = os_recycle s /\ os_idle t = os_idle s).
  { intros task s r t Hstep. unfold ktask_suspend_step in Hstep.
    destruct Hstep as [_ [[Hbad [Hr Heq]]|[Hrun [d [Hl [[Ha [Hb [Hr Heq]]]|[Hr [mid [Hs Hu]]]]]]]]].
    - subst t; auto.
    - subst t; auto.
    - pose proof (Hdelayframe _ _ _ Hu) as [Htasks [Hsem [Hrecycle Hidle]]].
      rewrite Htasks, Hsem, Hrecycle, Hidle.
      repeat split; [exact (suspend_sched_ids _ _ _ _ Hs)|exact (suspend_sched_semaphores _ _ _ _ Hs)|exact (suspend_sched_recycle _ _ _ _ Hs)|exact (suspend_sched_idle _ _ _ _ Hs)]. }
  pose proof (Hframe _ _ _ _ PreH3) as [Hids [Hsem [Hrecycle Hidle]]].
  assert (Hinfo : os_inv sg_semaphore_ic after |--
    “ idbuckets_ok (idmax (task_stable_ids (os_task_stable sg_semaphore_ic)))
       (hoffset (task_stable_ids (os_task_stable sg_semaphore_ic)))
       (idlist (task_idmanager_abs (os_tasks before_semaphore_ic)))
       (idbuckets (task_idmanager_abs (os_tasks before_semaphore_ic))) ”).
  { unfold os_inv, task_inv, store_idmanager. Intros. dump_pre_spatial.
    rewrite <- Hids. assumption. }
  prop_apply_p Hinfo. Intros_p Hbk.
  destruct Hbk as [Hoff [Hlen [Hidsok [Hnodes [Hindices Hperm]]]]].
  assert (Hnd : NoDup (map idnode_id (List.concat (idbuckets (task_idmanager_abs (os_tasks before_semaphore_ic)))))).
  { eapply Permutation_NoDup; [apply Permutation_sym; exact Hperm|exact (proj2 Hidsok)]. }
  assert (Huniq : forall ns (a b : IdNodeAbs), NoDup (map idnode_id ns) ->
    In a ns -> In b ns -> idnode_id a = idnode_id b -> a = b).
  { induction ns as [|n ns IH]; intros a b Hno Ha Hb Heq; [contradiction|].
    cbn [map] in Hno. inversion Hno as [|nid ids Hnot Htail]; subst.
    destruct Ha as [Ha|Ha]; destruct Hb as [Hb|Hb].
    - congruence.
    - subst a. exfalso. apply Hnot. rewrite Heq. apply in_map. exact Hb.
    - subst b. exfalso. apply Hnot. rewrite <- Heq. apply in_map. exact Ha.
    - eapply IH; eauto. }
  assert (Hfound : found = task_pre).
  { destruct PreH2 as [Hr [Hq [p [Hp [Hin Htask]]]]].
    destruct PreH6 as [Hr2 [Hq2 [p2 [Hp2 [Hin2 Htask2]]]]].
    assert (Hidx : 0 <= idmanager_bucket_index (task_stable_ids (os_task_stable sg_semaphore_ic)) task_id < Zlength (idbuckets (task_idmanager_abs (os_tasks before_semaphore_ic)))) by
      (unfold idmanager_bucket_index; rewrite Hlen; apply Z.mod_pos_bound; exact Hoff).
    assert (Hbucket : In (Znth (idmanager_bucket_index (task_stable_ids (os_task_stable sg_semaphore_ic)) task_id)
      (idbuckets (task_idmanager_abs (os_tasks before_semaphore_ic))) nil)
      (idbuckets (task_idmanager_abs (os_tasks before_semaphore_ic)))) by (apply Znth_In_Zlength; exact Hidx).
    assert (Hina : In (Build_IdNodeAbs task_id p) (List.concat (idbuckets (task_idmanager_abs (os_tasks before_semaphore_ic))))) by
      (apply in_concat; eexists; split; [exact Hbucket|exact Hin]).
    assert (Hinb : In (Build_IdNodeAbs task_id p2) (List.concat (idbuckets (task_idmanager_abs (os_tasks before_semaphore_ic))))) by
      (apply in_concat; eexists; split; [exact Hbucket|exact Hin2]).
    pose proof (Huniq _ _ _ Hnd Hina Hinb eq_refl) as Heq.
    injection Heq as Heq. rewrite Hp, Hp2 in Heq. apply addr_of_arrow_field_inv in Heq. injection Heq as Heq. exact Heq. }
  subst found.
  pose proof PreH10 as Hadm. destruct Hadm as [desc [Hlookup Hadm]].
  specialize (Hadm ltac:(auto)). destruct Hadm as [Hservice Hadm].
  assert (Hpost : exists d,
    task_desc_map (os_tasks after) task_pre = Some d /\
    tsmStat (tdSchedMember d) = TSK_SUSPEND /\
    In task_pre (sched_owned_tasks (os_tasks after))).
  { pose proof PreH3 as Hstep. unfold ktask_suspend_step in Hstep.
    destruct Hstep as [_ [[Hbad [Hr Heq]]|[Hrun [d [Hl [[Ha [Hb [Hr Heq]]]|[Hr [mid [Hs Hu]]]]]]]]].
    - subst after. destruct Hadm as [[Heq _]|[Hst Hown]]; [contradiction|]. exists desc; auto.
    - subst after. assert (d = desc) by congruence. subst d.
      destruct Hadm as [[_ [Hst|Hst]]|[Hst Hown]]; try contradiction. exists desc; auto.
    - pose proof (Hdelayframe _ _ _ Hu) as [Ht _]. rewrite Ht.
      exists (update_sched_member d (set_sched_member_status (tdSchedMember d) TSK_SUSPEND)).
      split.
      + rewrite (suspend_sched_map _ _ _ _ Hs). unfold update_task_desc_map.
        destruct (Z.eq_dec task_pre task_pre); congruence.
      + split; [reflexivity|].
        destruct (suspend_sched_owned _ _ _ _ Hs) as [[Hin Heq]|[Hnin Heq]]; rewrite Heq; simpl; auto. }
  destruct Hpost as [d [Hd [Hst Hown]]].
  assert (Hpending : semaphore_pending_nodes sem_semaphore_ic after (map sched_link_node waiting_semaphore_ic)).
  { unfold semaphore_pending_nodes in *. rewrite Hsem. exact PreH9. }
  assert (Hservice_after : ktask_not_os_service task_pre after).
  { unfold ktask_not_os_service in *. rewrite Hrecycle, Hidle. exact Hservice. }
  Exists d retval after. split_pure_spatial.
  - cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed.

Lemma proof_of_LinklistSuspend_entail_wit_3 : LinklistSuspend_entail_wit_3.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_4_1 : LinklistSuspend_entail_wit_4_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_4_2 : LinklistSuspend_entail_wit_4_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_5 : LinklistSuspend_entail_wit_5.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_6_1 : LinklistSuspend_entail_wit_6_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_6_2 : LinklistSuspend_entail_wit_6_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_7_1 : LinklistSuspend_entail_wit_7_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_7_2 : LinklistSuspend_entail_wit_7_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_7_3 : LinklistSuspend_entail_wit_7_3.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_7_4 : LinklistSuspend_entail_wit_7_4.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_return_wit_1_split_goal_1 : LinklistSuspend_return_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistSuspend_return_wit_1 : LinklistSuspend_return_wit_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_return_wit_2_split_goal_1 : LinklistSuspend_return_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistSuspend_return_wit_2 : LinklistSuspend_return_wit_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_return_wit_3_split_goal_1 : LinklistSuspend_return_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistSuspend_return_wit_3 : LinklistSuspend_return_wit_3.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_return_wit_4_split_goal_1 : LinklistSuspend_return_wit_4_split_goal_1.
Proof. Abort.

Lemma proof_of_LinklistSuspend_return_wit_4 : LinklistSuspend_return_wit_4.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_1_split_goal_spatial : LinklistSuspend_which_implies_wit_1_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  sep_apply_r_atomic (derivable1_wand_elim1 (store_ushort (&(task_pre # "TaskDescriptor" ->ₛ "id" .ₛ "id")) task_id) (os_inv sg_semaphore_ic before_semaphore_ic)).
  cancel.
Qed.

Lemma proof_of_LinklistSuspend_which_implies_wit_1 : LinklistSuspend_which_implies_wit_1.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_LinklistSuspend_which_implies_wit_1_split_goal_spatial.
Qed.

Lemma proof_of_LinklistSuspend_which_implies_wit_2_split_goal_spatial : LinklistSuspend_which_implies_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistSuspend_which_implies_wit_2 : LinklistSuspend_which_implies_wit_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_3 : LinklistSuspend_which_implies_wit_3.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_4_split_goal_spatial : LinklistSuspend_which_implies_wit_4_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistSuspend_which_implies_wit_4 : LinklistSuspend_which_implies_wit_4.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_5 : LinklistSuspend_which_implies_wit_5.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_6_split_goal_spatial : LinklistSuspend_which_implies_wit_6_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistSuspend_which_implies_wit_6 : LinklistSuspend_which_implies_wit_6.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_7_split_goal_spatial : LinklistSuspend_which_implies_wit_7_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistSuspend_which_implies_wit_7 : LinklistSuspend_which_implies_wit_7.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic : LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic.
Proof. Admitted.

