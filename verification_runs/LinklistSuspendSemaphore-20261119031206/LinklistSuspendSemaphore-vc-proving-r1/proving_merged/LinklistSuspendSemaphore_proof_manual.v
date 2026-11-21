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
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hremove_same : forall (l:list Z) t, ~ In t l -> remove Z.eq_dec t l = l).
  { clear. induction l as [|x xs IH]; intros t H; simpl; auto.
    destruct (Z.eq_dec t x); [subst; exfalso; apply H; simpl; tauto|].
    f_equal. apply IH. intro Hin; apply H; simpl; tauto. }
  assert (Hownedcut : forall T l t, NoDup l -> In t l ->
    store_owned_sched_nodes T l |--
    store_detached_sched_link T t ** store_owned_sched_nodes T (remove Z.eq_dec t l)).
  { intros T l. induction l as [|x xs IH]; intros t Hnd Hin; [contradiction|].
    inversion Hnd as [|? ? Hnot Htail]; subst.
    unfold store_owned_sched_nodes in *. cbn [map remove].
    rewrite logic_equiv_iter_sepcon_cons.
    destruct (Z.eq_dec t x) as [Heq|Hneq].
    - subst t. rewrite Hremove_same by exact Hnot. cancel.
    - cbn [map]. rewrite logic_equiv_iter_sepcon_cons.
      sep_apply_l_atomic (IH t Htail ltac:(simpl in Hin; intuition congruence)).
      cancel. }
  assert (Hfresh : forall wait l x px y py p v,
    dllseg (store_semaphore wait) x px y py (map semaphore_link_node l) **
    &(p # "Semaphore" ->ₛ "value") # UShort |-> v |--
    “ ~ In p (map semaphore_addr l) ”).
  { clear.
    intros wait l. induction l as [|a l IH]; intros x px y py p v.
    - cbn [map]. dump_pre_spatial. simpl. tauto.
    - cbn [map dllseg]. Intros z.
      destruct (Z.eq_dec p (semaphore_addr a)) as [Heq|Hneq].
      + unfold store_semaphore. Intros. rewrite Heq.
        let q := constr:(semaphore_addr a) in
        sep_apply_l_atomic (store_ushort_undef_store_ushort (&(q # "Semaphore" ->ₛ "value")) (semaphore_value a)).
        let q := constr:(semaphore_addr a) in
        sep_apply_l_atomic (store_ushort_undef_store_ushort (&(q # "Semaphore" ->ₛ "value")) v).
        let q := constr:(semaphore_addr a) in
        sep_apply_l_atomic (undef_store_int_exclusive 2 2 (&(q # "Semaphore" ->ₛ "value")) ltac:(lia)).
        Intros_p Hbad. contradiction.
      + change (store_semaphore wait x a **
          (&(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
          (&(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
          (dllseg (store_semaphore wait) z x y py (map semaphore_link_node l) **
          &(p # "Semaphore" ->ₛ "value") # UShort |-> v))) |--
          “ ~ In p (semaphore_addr a :: map semaphore_addr l) ”).
        sep_apply (IH z x y py p v). Intros_p Htail.
        dump_pre_spatial. simpl. intuition congruence. }
  assert (Hsemcut : forall wait hd pre obj post,
    store_dll (store_semaphore wait) hd (map semaphore_link_node (pre ++ obj::post)) |--
    EX h pt x px z,
    “ hd<>0 /\ pt<>0 /\ h<>0 /\
       dll_nodes_nonzero (map semaphore_link_node (pre ++ obj::post)) /\
       x = getPtr (semaphore_link_node obj) ” &&
    &(hd # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> pt **
    &(hd # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> h **
    dllseg (store_semaphore wait) h hd x px (map semaphore_link_node pre) **
    store_semaphore wait x obj **
    &(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
    &(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
    dllseg (store_semaphore wait) z x hd pt (map semaphore_link_node post)).
  { intros. unfold store_dll. Intros h pt. rewrite map_app.
    sep_apply_l_atomic (dllseg_split (store_semaphore wait) h hd hd pt
      (map semaphore_link_node pre) (map semaphore_link_node (obj::post))).
    Intros x px. cbn [map dllseg]. Intros z.
    Exists h pt x px z. split_pure_spatial.
    - cbn [semaphore_link_node getData]. fold (@dllseg SemaphoreAbs (store_semaphore wait)). sepcon_assoc_change; repeat progress cancel.
      change (dllseg (store_semaphore wait) z x hd pt (map semaphore_link_node post) |-- dllseg (store_semaphore wait) z x hd pt (map semaphore_link_node post)).
      cancel.
    - rewrite map_app in H. cbn [map] in H. split_pures; dump_pre_spatial; intuition. }
  destruct PreH8 as [obj [Hobj [Haddr Hnodes]]].
  assert (Hwaiting : semaphore_pending_addrs obj = waiting_semaphore_ic).
  { apply (f_equal (map (@getData Z))) in Hnodes.
    rewrite !map_map in Hnodes. change (map (fun x:Z=>x) (semaphore_pending_addrs obj) = map (fun x:Z=>x) waiting_semaphore_ic) in Hnodes.
    now rewrite !map_id in Hnodes. }
  apply in_split in Hobj as [pre [post Hsems]].
  unfold os_inv at 1. Intros_p Hworld.
  unfold task_inv at 1. Intros_p Htask.
  unfold semaphore_inv at 1. Intros_p Hcontext.
  assert (Hndowned : NoDup (sched_owned_tasks (os_tasks staged))).
  { pose proof (os_wf_sched_nodup _ _ Hworld) as Hnd. unfold os_sched_owners in Hnd.
    apply NoDup_app_remove_r in Hnd. exact Hnd. }
  sep_apply_l_atomic (Hownedcut (task_desc_map (os_tasks staged))
    (sched_owned_tasks (os_tasks staged)) task_pre Hndowned PreH12).
  rewrite Hsems.
  sep_apply_l_atomic (Hsemcut (pure_suspend_sched_link (task_desc_map (os_tasks staged)))
    (semaphore_list_head (os_semaphore_stable sg_semaphore_ic)) pre obj post).
  Intros h pt x px z.
  unfold store_semaphore at 2. Intros.
  prop_apply_p (Hfresh (pure_suspend_sched_link (task_desc_map (os_tasks staged))) pre
    h (semaphore_list_head (os_semaphore_stable sg_semaphore_ic)) x px
    (semaphore_addr obj) (semaphore_value obj)).
  Intros_p Hpre_absent.
  prop_apply_p (Hfresh (pure_suspend_sched_link (task_desc_map (os_tasks staged))) post
    z x (semaphore_list_head (os_semaphore_stable sg_semaphore_ic)) pt
    (semaphore_addr obj) (semaphore_value obj)).
  Intros_p Hpost_absent.
  set (obj' := {| semaphore_addr := semaphore_addr obj;
    semaphore_id := semaphore_id obj; semaphore_value := semaphore_value obj;
    semaphore_pending_addrs := waiting_semaphore_ic ++ [task_pre] |}).
  set (after := replace_sched_owned_tasks (remove Z.eq_dec task_pre (sched_owned_tasks (os_tasks staged)))
    (semaphore_enqueue_state sem_semaphore_ic (waiting_semaphore_ic ++ [task_pre]) staged)).
  assert (Hmap_same : forall l,
    ~ In (semaphore_addr obj) (map semaphore_addr l) ->
    map (fun s => if Z.eq_dec (semaphore_addr s) sem_semaphore_ic then
      {|semaphore_addr:=semaphore_addr s;semaphore_id:=semaphore_id s;
        semaphore_value:=semaphore_value s;semaphore_pending_addrs:=waiting_semaphore_ic++[task_pre]|}
      else s) l = l).
  { intros l. induction l as [|a l IH]; intro Hnot; simpl; [reflexivity|].
    destruct (Z.eq_dec (semaphore_addr a) sem_semaphore_ic) as [Heq|Hneq].
    - exfalso. apply Hnot. simpl. left. congruence.
    - f_equal. apply IH. intro Hin; apply Hnot; simpl; auto. }
  assert (Haftersems : os_semaphores after = pre ++ obj' :: post).
  { unfold after, semaphore_enqueue_state, replace_sched_owned_tasks, replace_semaphores. cbn.
    rewrite Hsems, map_app. cbn [map]. rewrite Haddr.
    destruct (Z.eq_dec sem_semaphore_ic sem_semaphore_ic); [|contradiction].
    rewrite (Hmap_same pre Hpre_absent), (Hmap_same post Hpost_absent). unfold obj'. rewrite Haddr. reflexivity. }
  assert (Hmanager : semaphore_manager (os_semaphores after) = semaphore_manager (os_semaphores staged)).
  { rewrite Haftersems, Hsems. unfold semaphore_manager.
    f_equal.
    - rewrite !map_app. reflexivity.
    - apply map_ext. intro i. rewrite !filter_app, !map_app. cbn [filter].
      unfold obj'. cbn. destruct (Z.eqb (semaphore_id obj mod 16) (Z.of_nat i)); reflexivity. }
  assert (Hownperm : Permutation (sched_owned_tasks (os_tasks staged))
      (task_pre :: remove Z.eq_dec task_pre (sched_owned_tasks (os_tasks staged)))).
  { revert Hndowned PreH12. generalize (sched_owned_tasks (os_tasks staged)) as l.
    intros l. induction l as [|a l IH]; intros Hnd Hin; [contradiction|].
    inversion Hnd as [|? ? Hnot Hnd']; subst. cbn [remove].
    destruct (Z.eq_dec task_pre a) as [Heq|Hneq].
    - subst a. rewrite Hremove_same by exact Hnot. apply Permutation_refl.
    - eapply Permutation_trans. apply perm_skip. apply IH; [exact Hnd'|simpl in Hin; intuition congruence].
      apply perm_swap. }
  set (mid := map (@getData addr) (os_ready_nodes (orvBuckets (assignReadyVector (os_assign staged)))) ++
     map (@getData addr) (zombie_nodes (zombie_queue staged)) ++
     semaphore_waiters pre ++ waiting_semaphore_ic).
  set (last := semaphore_waiters post ++ mutex_waiters (os_mutexes staged) ++ event_waiters (os_events staged)).
  assert (Howners_old : os_sched_owners staged = sched_owned_tasks (os_tasks staged) ++ mid ++ last).
  { unfold os_sched_owners, mid,last. rewrite Hsems. unfold semaphore_waiters.
    rewrite map_app, concat_app. cbn [map concat]. rewrite Hwaiting. now rewrite !app_assoc. }
  assert (Howners_new : os_sched_owners after = remove Z.eq_dec task_pre (sched_owned_tasks (os_tasks staged)) ++ mid ++ task_pre :: last).
  { unfold os_sched_owners. rewrite Haftersems.
    unfold after, replace_sched_owned_tasks, semaphore_enqueue_state, replace_semaphores.
    cbn [os_tasks sched_owned_tasks os_assign zombie_queue os_mutexes os_events].
    unfold mid,last,semaphore_waiters. rewrite map_app, concat_app. cbn [map concat obj' semaphore_pending_addrs].
    repeat rewrite <- app_assoc. cbn [app]. reflexivity. }
  assert (Hownersperm : Permutation (os_sched_owners staged) (os_sched_owners after)).
  { rewrite Howners_old,Howners_new. eapply Permutation_trans.
    - apply Permutation_app_tail. exact Hownperm.
    - change (Permutation (task_pre :: (remove Z.eq_dec task_pre (sched_owned_tasks (os_tasks staged)) ++ mid ++ last))
       (remove Z.eq_dec task_pre (sched_owned_tasks (os_tasks staged)) ++ mid ++ task_pre :: last)).
      rewrite !app_assoc. apply Permutation_middle. }
  assert (Htaskafter : task_world_wf after).
  { destruct Htask as [Hpresent Hinit Hid Hprio Halign Hrun Hclose]. constructor;
      cbn [after replace_sched_owned_tasks semaphore_enqueue_state replace_semaphores os_tasks task_desc_map task_ptr_list sched_owned_tasks task_idmanager_abs].
    - exact Hpresent.
    - intros t d Hlookup Hstatus. apply in_in_remove; [|eapply Hinit; eauto].
      intro Heq; subst t. rewrite PreH10 in Hlookup. inversion Hlookup; subst d.
      destruct Hstatus; congruence.
    - exact Hid.
    - exact Hprio.
    - exact Halign.
    - exact Hrun.
    - exact Hclose. }
  assert (Hservice : forall entry slot,
    service_slot_wf staged entry slot -> service_phase slot <> ServiceRegistered task_pre ->
    service_slot_wf after entry slot).
  { intros entry slot Hwf Hnot. destruct slot as [id phase]. destruct phase; cbn [service_slot_wf service_phase] in *; try exact Hwf.
    destruct Hwf as [d Hd]. exists d. destruct Hd as [Hlookup Hentry Hdelay Howned Hid].
    constructor; cbn [after replace_sched_owned_tasks semaphore_enqueue_state replace_semaphores os_tasks task_desc_map sched_owned_tasks task_idmanager_abs]; try assumption.
    intro Hnr. apply in_in_remove; [intro Heq; subst; contradiction|auto]. }
  assert (Hworldafter : os_world_wf sg_semaphore_ic after).
  { constructor.
    - exact (os_wf_context _ _ Hworld).
    - apply Hservice; [exact (os_wf_recycler _ _ Hworld)|exact (proj1 PreH13)].
    - change (Forall (service_slot_wf after (os_idle_entry sg_semaphore_ic)) (os_idle staged)).
      rewrite Forall_forall in *. intros slot Hin. apply Hservice.
      + pose proof (os_wf_idle _ _ Hworld) as Hw. rewrite Forall_forall in Hw. auto.
      + destruct PreH13 as [_ Hi]. rewrite Forall_forall in Hi. auto.
    - eapply Permutation_NoDup; [exact Hownersperm|exact (os_wf_sched_nodup _ _ Hworld)].
    - intro t. change (In t (os_sched_owners after) <-> task_desc_map (os_tasks staged) t <> None).
      rewrite <- (os_wf_sched_domain _ _ Hworld t). split; intro Hi.
      + eapply Permutation_in; [apply Permutation_sym; exact Hownersperm|exact Hi].
      + eapply Permutation_in; eauto. }
  assert (Hidkeep : forall a, In a (pre ++ obj::post) ->
    exists b, In b (pre ++ obj'::post) /\ semaphore_id b = semaphore_id a).
  { intros a Ha. apply in_app_or in Ha. destruct Ha as [Ha|Ha].
    - exists a; split; [apply in_or_app;auto|reflexivity].
    - destruct Ha as [<-|Ha].
      + exists obj'; split; [apply in_or_app; right; simpl;auto|reflexivity].
      + exists a; split; [apply in_or_app;right;simpl;auto|reflexivity]. }
  assert (Hqueues : forall qs,
    dataqueue_inv (pre++obj::post) qs |-- dataqueue_inv (pre++obj'::post) qs).
  { intros qs. unfold dataqueue_inv. Intros_p Hqs.
    split_pure_spatial; [cancel|]. dump_pre_spatial.
    intros p q Hq. destruct (Hqs p q Hq) as [Hready [[s1 [Hs1 Hi1]] [s2 [Hs2 Hi2]]]].
    split; [exact Hready|]. split.
    - destruct (Hidkeep s1 Hs1) as [s1' [Hs1' Hi1']]. exists s1'; split; [exact Hs1'|congruence].
    - destruct (Hidkeep s2 Hs2) as [s2' [Hs2' Hi2']]. exists s2'; split; [exact Hs2'|congruence]. }
  sep_apply_l_atomic (Hqueues (os_dataqueues staged)).
  assert (Hmap_nonzero : forall T t d, T t = Some d -> addr_aligned t ALIGN_SIZE ->
    store_map store_published_task T |-- “ sched_link_of t <> 0 ”).
  { clear. intros T t d Hlookup Halign.
    pose proof (task_descriptor_field_offset_axiom t Halign) as Hlayout.
    unfold ktask_descriptor_field_offset_ok in Hlayout.
    assert (Hstack : &(t # "TaskDescriptor" ->ₛ "stack_point") = t) by (assert (Htmp : &(t # "TaskDescriptor" ->ₛ "stack_point") = t+0) by tauto; lia).
    assert (Hsl : sched_link_of t = t+16) by (unfold sched_link_of; tauto).
    sep_apply_l_atomic (store_map_split store_published_task t d T Hlookup).
    unfold store_published_task, store_task_descriptor. Intros.
    prop_apply_p (valid_store_ptr (&(t # "TaskDescriptor" ->ₛ "stack_point")) (tdStackPoint d)).
    Intros_p Hv. dump_pre_spatial. rewrite Hstack in Hv.
    unfold valid_object, valid_addr_range in Hv. rewrite Hsl. lia. }
  prop_apply_p (Hmap_nonzero (task_desc_map (os_tasks staged)) task_pre desc PreH10
    (task_wf_aligned _ Htask _ _ PreH10)).
  Intros_p Hslnonzero.
  unfold store_detached_sched_link at 1. Intros actual.
  assert (Hactual : actual=desc) by (rewrite PreH10 in H1; intuition congruence).
  subst actual.
  sep_apply_l_atomic (store_node_self_linked_occupy (sched_link_of task_pre)).
  set (psem := semaphore_addr obj).
  assert (Hhead : list_pre = &(psem # "Semaphore" ->ₛ "pend_list"))
    by (unfold psem; rewrite PreH9, <-Haddr; reflexivity).
  assert (Hstep : linklist_semaphore_enqueue sem_semaphore_ic task_pre 0 staged after).
  { unfold linklist_semaphore_enqueue. exists obj,desc,(map sched_link_node (waiting_semaphore_ic++[task_pre])).
    split; [rewrite Hsems;apply in_or_app;right;simpl;auto|].
    split; [exact Haddr|]. split; [exact PreH10|]. split; [exact PreH11|]. split; [exact PreH12|].
    split; [left;split; [reflexivity|now rewrite Hwaiting]|].
    unfold after. rewrite map_map. cbn [sched_link_node getData]. now rewrite map_id. }
  assert (Hins : dll_insert_before_dispatch list_pre (map sched_link_node waiting_semaphore_ic)
    list_pre (Build_DL_Node task_pre (sched_link_of task_pre)) = map sched_link_node (waiting_semaphore_ic++[task_pre])).
  { unfold dll_insert_before_dispatch. destruct (Z.eq_dec list_pre list_pre); [|contradiction].
    rewrite map_app. reflexivity. }
  assert (Hsemmerge : forall wait hd pre s post h pt x px z,
    hd<>0 -> pt<>0 -> h<>0 -> dll_nodes_nonzero (map semaphore_link_node (pre++s::post)) ->
    x=getPtr (semaphore_link_node s) ->
    &(hd # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> pt **
    &(hd # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> h **
    dllseg (store_semaphore wait) h hd x px (map semaphore_link_node pre) **
    store_semaphore wait x s **
    &(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
    &(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
    dllseg (store_semaphore wait) z x hd pt (map semaphore_link_node post)
    |-- store_dll (store_semaphore wait) hd (map semaphore_link_node (pre++s::post))).
  { clear. intros wait hd pre s post h pt x px z Hhd Hpt Hh Hnz Hx.
    assert (Hnode : semaphore_link_node s=Build_DL_Node s x)
      by (unfold semaphore_link_node in *; cbn in Hx; now rewrite Hx).
    sep_apply_l_atomic (dllseg_head_insert SemaphoreAbs (store_semaphore wait) px x z hd pt s (map semaphore_link_node post)).
    sep_apply_l_atomic (dllseg_concat (store_semaphore wait) h hd x px hd pt
      (map semaphore_link_node pre) (Build_DL_Node s x :: map semaphore_link_node post)).
    unfold store_dll. Exists h pt. split_pure_spatial.
    - rewrite map_app. cbn [map]. rewrite Hnode. sepcon_assoc_change; repeat progress cancel.
    - split_pures; dump_pre_spatial; tauto. }
  destruct H as [Hhd [Hpt [Hh [Hnz Hx]]]].
  assert (Hnewnz : dll_nodes_nonzero (map semaphore_link_node (pre++obj'::post))).
  { unfold dll_nodes_nonzero in Hnz |- *. rewrite map_app in Hnz |- *.
    rewrite Forall_app in Hnz |- *. destruct Hnz as [Hpre Htail]. split; [exact Hpre|].
    cbn [map] in Htail |- *. inversion Htail as [|? ? Hptr Hpost]; subst.
    constructor; [change (getPtr (semaphore_link_node obj) <> 0); exact Hptr|exact Hpost]. }
  assert (Hclosepayload :
    &(psem # "Semaphore" ->ₛ "value") # UShort |-> semaphore_value obj **
    SemaphorePadding psem **
    store_dll (pure_suspend_sched_link (task_desc_map (os_tasks staged))) list_pre
      (map sched_link_node (waiting_semaphore_ic++[task_pre])) |--
    store_semaphore (pure_suspend_sched_link (task_desc_map (os_tasks staged))) x obj').
  { unfold store_semaphore. cbn [obj' semaphore_addr semaphore_value semaphore_pending_addrs].
    fold psem. rewrite <-Hhead. split_pure_spatial.
    - change (map semaphore_wait_node (waiting_semaphore_ic++[task_pre])) with (map sched_link_node (waiting_semaphore_ic++[task_pre])).
      fold psem. cancel.
    - dump_pre_spatial. exact H0. }
  Exists after. split_pure_spatial.
  - fold (sched_link_of task_pre).
    sepcon_assoc_change.
    sep_apply_r_atomic (pure_suspend_sched_link_close (task_desc_map (os_tasks staged))
      (sched_link_of task_pre) task_pre desc PreH10 eq_refl PreH11).
    rewrite Hwaiting. fold psem. rewrite <-Hhead.
    change (map semaphore_wait_node waiting_semaphore_ic) with (map sched_link_node waiting_semaphore_ic).
    sepcon_assoc_change.
    cancel (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks staged))) list_pre (map sched_link_node waiting_semaphore_ic)).
    cancel (occupy_dll_node (sched_link_of task_pre)).
    asrt_simpl_pure.
    apply_sepcon_adjoint.
    sepcon_assoc_change.
    sep_apply_l_atomic Hclosepayload.
    sepcon_assoc_change.
    sep_apply_l_atomic (Hsemmerge (pure_suspend_sched_link (task_desc_map (os_tasks staged)))
      (semaphore_list_head (os_semaphore_stable sg_semaphore_ic)) pre obj' post h pt x px z Hhd Hpt Hh Hnewnz Hx).
    unfold os_inv at 1. rewrite Haftersems.
    unfold task_inv at 1, semaphore_inv at 1, tick_inv,delay_inv,assign_inv,exstatus_inv.
    cbn [after replace_sched_owned_tasks semaphore_enqueue_state replace_semaphores os_tasks task_desc_map task_ptr_list task_idmanager_abs sched_owned_tasks os_tick os_delays os_assign zombie_queue os_recycle os_idle os_isr os_dataqueues os_events os_mutexes os_exstatus].
    rewrite Haftersems,Hsems in Hmanager. rewrite Hmanager.
    Intros. split_pure_spatial.
    + sepcon_assoc_change; repeat progress cancel.
    + split_pures; dump_pre_spatial; try exact Hworldafter; try exact Htaskafter; try exact Hcontext; assumption.
  - split_pures; dump_pre_spatial; try assumption; try reflexivity; try exact Hstep; try exact Hslnonzero; try exact Hins; try (unfold dll_insert_anchor; auto).
Qed.

Lemma proof_of_LinklistSuspend_entail_wit_4_1 : LinklistSuspend_entail_wit_4_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Left. Exists (@nil Z) waiting_semaphore_ic.
  split_pure_spatial.
  - sep_apply_r_atomic (derivable1_wand_elim1
      (store_ptr (&((list_pre) # "SysDoubleLinklistNode" ->ₛ "node_next")) first_link)
      (os_inv sg_semaphore_ic staged)).
    cancel.
  - split_pures; dump_pre_spatial; simpl; auto.
    intros scanned Hfalse. contradiction.
Qed.

Lemma proof_of_LinklistSuspend_entail_wit_4_2 : LinklistSuspend_entail_wit_4_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Right. Exists first_task_2 rest_tasks_2 (@nil Z) waiting_semaphore_ic.
  split_pure_spatial.
  - sep_apply_r_atomic (derivable1_wand_elim1
      (store_ptr (&((list_pre) # "SysDoubleLinklistNode" ->ₛ "node_next")) first_link)
      (os_inv sg_semaphore_ic staged)).
    cancel.
  - split_pures; dump_pre_spatial; simpl; auto.
    intros scanned Hfalse. contradiction.
Qed.

Lemma proof_of_LinklistSuspend_entail_wit_5 : LinklistSuspend_entail_wit_5.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hcut : forall (A : Type) (P : Z -> A -> Assertion) hd ns n,
    In n ns -> store_dll P hd ns |-- P (getPtr n) (getData n) **
      (P (getPtr n) (getData n) -* store_dll P hd ns)).
  { intros A P hd ns n Hn.
    apply in_split in Hn as [pre [post Hns]]. subst ns.
    unfold store_dll. Intros h pt.
    sep_apply (dllseg_split P h hd hd pt pre (n::post)). Intros x px.
    change (dllseg P x px hd pt (n::post)) with
      (EX z, “ x = getPtr n ” && P x (getData n) **
        &(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
        &(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
        dllseg P z x hd pt post).
    Intros z. subst x. cancel (P (getPtr n) (getData n)).
    apply_sepcon_adjoint.
    Exists h pt. split_pure_spatial.
    - sep_apply (dllseg_head_insert A P px (getPtr n) z hd pt (getData n) post).
      replace (Build_DL_Node (getData n) (getPtr n)) with n by (destruct n; reflexivity).
      sep_apply (dllseg_concat P h hd (getPtr n) px hd pt pre (n::post)). cancel.
    - split_pures; dump_pre_spatial; tauto.
  }
  assert (Hfocus2 : forall sg st sem waiting,
    semaphore_pending_nodes sem st (map sched_link_node waiting) ->
    os_inv sg st |-- task_inv sg st **
    store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st)))
      (semaphore_pending_head sem) (map sched_link_node waiting) **
    ((task_inv sg st ** store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st)))
      (semaphore_pending_head sem) (map sched_link_node waiting)) -* os_inv sg st)).
  { intros sg st sem waiting [obj [Hin [Haddr Hnodes]]].
    unfold os_inv at 1. cbn zeta. unfold semaphore_inv at 1. Intros.
    sep_apply (Hcut SemaphoreAbs
      (store_semaphore (pure_suspend_sched_link (task_desc_map (os_tasks st))))
      (semaphore_list_head (os_semaphore_stable sg))
      (map semaphore_link_node (os_semaphores st)) (semaphore_link_node obj)
      ltac:(apply in_map; exact Hin)).
    cbn [semaphore_link_node getPtr getData].
    unfold store_semaphore at 1. cbn zeta. Intros.
    change (map semaphore_wait_node (semaphore_pending_addrs obj)) with
      (map sched_link_node (semaphore_pending_addrs obj)).
    rewrite Hnodes. rewrite Haddr. fold (semaphore_pending_head sem).
    cancel (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st)))
      (semaphore_pending_head sem) (map sched_link_node waiting)).
    cancel (task_inv sg st).
    apply_sepcon_adjoint.
    unfold os_inv, semaphore_inv. cbn zeta.
    split_pure_spatial; [sepcon_assoc_change; repeat progress cancel | split_pures; dump_pre_spatial; tauto].
    sep_apply_r_atomic (derivable1_wand_elim1
      (store_semaphore (pure_suspend_sched_link (task_desc_map (os_tasks st)))
        (&(sem # "Semaphore" ->ₛ "link")) obj)
      (store_dll (store_semaphore (pure_suspend_sched_link (task_desc_map (os_tasks st))))
        (semaphore_list_head (os_semaphore_stable sg))
        (map semaphore_link_node (os_semaphores st)))).
    repeat progress cancel.
    unfold store_semaphore. cbn zeta. rewrite Haddr.
    change (map semaphore_wait_node (semaphore_pending_addrs obj)) with
      (map sched_link_node (semaphore_pending_addrs obj)).
    rewrite Hnodes. fold (semaphore_pending_head sem).
    split_pure_spatial; [repeat progress cancel | split_pures; dump_pre_spatial; intuition congruence].
  }

  assert (Hmissing : forall (T : Z -> option TaskDescriptorAbs) a b db,
    T b = Some db -> b <> a ->
    store_map_missing_i store_published_task T a |-- store_published_task b db **
      (store_published_task b db -* store_map_missing_i store_published_task T a)).
  { intros T a b db Hb Hneq. unfold store_map_missing_i at 1. Intros l.
    assert (Hin : In b l) by (apply H; split; [exists db; exact Hb|exact Hneq]).
    apply in_split in Hin as [pre [post Hl]]. subst l.
    rewrite map_app, logic_equiv_iter_sepcon_app. cbn [map].
    rewrite Hb, logic_equiv_iter_sepcon_cons.
    cancel (store_published_task b db). apply_sepcon_adjoint.
    unfold store_map_missing_i. Exists (pre ++ b::post).
    split_pure_spatial.
    - rewrite map_app, logic_equiv_iter_sepcon_app. cbn [map]. rewrite Hb, logic_equiv_iter_sepcon_cons.
      sepcon_assoc_change; repeat progress cancel.
    - split_pures; dump_pre_spatial; assumption.
  }
  assert (Hmap2 : forall (T : Z -> option TaskDescriptorAbs) a b da db,
    T a = Some da -> T b = Some db -> b <> a ->
    store_map store_published_task T |--
      store_published_task a da ** store_published_task b db **
      ((store_published_task a da ** store_published_task b db) -* store_map store_published_task T)).
  { intros T a b da db Ha Hb Hneq.
    match goal with |- _ |-- ?Q => set (goalQ := Q) end.
    sep_apply_l_atomic (store_map_split store_published_task a da T Ha).
    sep_apply_l_atomic (Hmissing T a b db Hb Hneq).
    unfold goalQ; clear goalQ. sepcon_assoc_change. cancel (store_published_task a da). cancel (store_published_task b db).
    apply_sepcon_adjoint. sepcon_assoc_change.
    sep_apply_r_atomic (store_map_merge store_published_task a da T Ha).
    sepcon_assoc_change. cancel (store_published_task a da).
    sep_apply (derivable1_wand_elim1 (store_published_task b db)
      (store_map_missing_i store_published_task T a)). cancel.
  }
  assert (Hprio : forall p d,
    store_published_task p d |-- “ addr_aligned p 4 ” &&
      &(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio") # UChar |-> tsmCurPrio (tdSchedMember d) **
      (&(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio") # UChar |-> tsmCurPrio (tdSchedMember d)
        -* store_published_task p d)).
  { intros p d. unfold store_published_task at 1. cbn zeta.
    unfold store_task_descriptor at 1. Intros.
    unfold store_task_sched_member at 1. Intros inner.
    assert (Hbase : p = inner).
    { match goal with Heq : _ = _ |- _ =>
        first [revert Heq; csimpl; intro Heq;
          repeat apply addr_of_arrow_field_inv in Heq; inversion Heq; reflexivity] end. }
    subst inner. split_pure_spatial.
    - sepcon_assoc_change.
      cancel (store_uchar (&(p # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (tsmCurPrio (tdSchedMember d))).
      apply_sepcon_adjoint.
      unfold store_published_task, store_task_descriptor, store_task_sched_member. cbn zeta. Exists p.
      split_pure_spatial; [sepcon_assoc_change; repeat progress cancel | split_pures; dump_pre_spatial; intuition].
    - split_pures; dump_pre_spatial; assumption.
  }
  assert (Htask2 : forall sg st a b da db,
    task_desc_map (os_tasks st) a = Some da ->
    task_desc_map (os_tasks st) b = Some db -> b <> a ->
    task_inv sg st |-- “ addr_aligned a 4 /\ addr_aligned b 4 ” &&
      &(a # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio") # UChar |-> tsmCurPrio (tdSchedMember da) **
      &(b # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio") # UChar |-> tsmCurPrio (tdSchedMember db) **
      ((&(a # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio") # UChar |-> tsmCurPrio (tdSchedMember da) **
        &(b # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio") # UChar |-> tsmCurPrio (tdSchedMember db)) -* task_inv sg st)).
  { intros sg st a b da db Ha Hb Hneq. unfold task_inv at 1. Intros.
    sep_apply_l_atomic (Hmap2 (task_desc_map (os_tasks st)) a b da db Ha Hb Hneq).
    set (Wmap := (store_published_task a da ** store_published_task b db) -*
      store_map store_published_task (task_desc_map (os_tasks st))).
    sep_apply_l_atomic (Hprio a da). sep_apply_l_atomic (Hprio b db). Intros.
    split_pure_spatial.
    - sepcon_assoc_change.
      cancel (store_uchar (&(a # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (tsmCurPrio (tdSchedMember da))).
      cancel (store_uchar (&(b # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (tsmCurPrio (tdSchedMember db))).
      apply_sepcon_adjoint. unfold task_inv.
      split_pure_spatial; [sepcon_assoc_change; repeat progress cancel | split_pures; dump_pre_spatial; assumption].
      sep_apply (derivable1_wand_elim1
        (store_uchar (&(a # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (tsmCurPrio (tdSchedMember da)))
        (store_published_task a da)).
      sep_apply (derivable1_wand_elim1
        (store_uchar (&(b # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (tsmCurPrio (tdSchedMember db)))
        (store_published_task b db)).
      sepcon_assoc_change.
      unfold Wmap.
      sep_apply_r_atomic (derivable1_wand_elim1 (store_published_task a da ** store_published_task b db)
        (store_map store_published_task (task_desc_map (os_tasks st)))). sepcon_assoc_change; repeat progress cancel.
    - split_pures; dump_pre_spatial; tauto.
  }
  assert (Hfirst : forall (A : Type) (P : Z -> A -> Assertion) ns x px y py,
    dllseg P x px y py ns |-- “ x = match ns with [] => y | n::_ => getPtr n end ”).
  { intros A P ns x px y py. destruct ns as [|n ns].
    - cbn [dllseg]. Intros. split_pures; dump_pre_spatial; tauto.
    - cbn [dllseg]. Intros z. split_pures; dump_pre_spatial; tauto. }
  assert (Hnext : forall (T : Z -> option TaskDescriptorAbs) hd pre t rest,
    let link := sched_link_of t in
    let next := match rest with [] => hd | u::_ => sched_link_of u end in
    store_dll (pure_suspend_sched_link T) hd (map sched_link_node (pre ++ t::rest)) |--
    EX d : TaskDescriptorAbs,
      “ T t = Some d ” &&
      &(link # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next **
      (&(link # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> next -*
       store_dll (pure_suspend_sched_link T) hd (map sched_link_node (pre ++ t::rest)))).
  { clear -Hfirst. intros T hd pre t rest. cbn zeta.
    match goal with |- _ |-- ?Q => set (goalQ := Q) end.
    rewrite map_app. cbn [map]. unfold store_dll at 1. Intros h pt.
    sep_apply_l_atomic (dllseg_split (pure_suspend_sched_link T) h hd hd pt
      (map sched_link_node pre) (sched_link_node t :: map sched_link_node rest)). Intros x px.
    set (link := sched_link_of t).
    change (dllseg (pure_suspend_sched_link T) x px hd pt (sched_link_node t :: map sched_link_node rest)) with
      (EX z, “ x = link ” && pure_suspend_sched_link T x t **
        &(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
        &(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
        dllseg (pure_suspend_sched_link T) z x hd pt (map sched_link_node rest)).
    Intros z. subst x.
    prop_apply_p (Hfirst Z (pure_suspend_sched_link T) (map sched_link_node rest) z link hd pt).
    Intros_p Hz. assert (Hz' : z = match rest with [] => hd | u::_ => sched_link_of u end).
    { destruct rest; exact Hz. } clear Hz. subst z. unfold pure_suspend_sched_link at 1. unfold pure_published_slink at 1. Intros d.
    unfold goalQ; clear goalQ. fold link. Exists d. split_pure_spatial.
    - cbn [poly_store]. unfold link. sepcon_assoc_change.
      lazymatch goal with |- ?X ** (?Y ** ?Rest) |-- ?P ** ?Q =>
        change (X ** (P ** Rest) |-- P ** Q); cancel P
      end.
      apply_sepcon_adjoint. fold link. unfold store_dll. rewrite map_app. cbn [map]. Exists h pt.
      split_pure_spatial.
      + sepcon_assoc_change; repeat progress cancel.
        sep_apply_r_atomic (dllseg_concat (pure_suspend_sched_link T) h hd link px hd pt
          (map sched_link_node pre) (sched_link_node t :: map sched_link_node rest)).
        sepcon_assoc_change; repeat progress cancel.
        change (dllseg (pure_suspend_sched_link T) link px hd pt (sched_link_node t :: map sched_link_node rest)) with
          (EX z, “ link = link ” && pure_suspend_sched_link T link t **
            &(link # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
            &(link # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
            dllseg (pure_suspend_sched_link T) z link hd pt (map sched_link_node rest)).
        Exists (match rest with [] => hd | u::_ => sched_link_of u end).
        split_pure_spatial.
        * sepcon_assoc_change; repeat progress cancel.
          unfold pure_suspend_sched_link, pure_published_slink. Exists d.
          split_pure_spatial.
          -- sepcon_assoc_change; repeat progress cancel.
             lazymatch goal with |- ?A ** ?B |-- _ => change (A ** B |-- B ** A); cancel end.
          -- split_pures; dump_pre_spatial; intuition.
        * split_pures; dump_pre_spatial; reflexivity.
      + split_pures; dump_pre_spatial; assumption.
    - split_pures; dump_pre_spatial; tauto.
  }
  assert (Hcompose : forall (P1 P2 P3 A B C : Assertion),
    ((P1 ** P2) -* A) ** (P3 -* B) ** ((A ** B) -* C) |--
      ((P1 ** (P2 ** P3)) -* C)).
  { intros P1 P2 P3 A B C. clear -P1 P2 P3 A B C.
    apply_sepcon_adjoint.
    sep_apply_r_atomic (derivable1_wand_elim1 (A ** B) C).
    sepcon_assoc_change; repeat progress cancel.
    sep_apply_r_atomic (derivable1_wand_elim1 (P1 ** P2) A).
    sepcon_assoc_change; repeat progress cancel.
    sep_apply_r_atomic (derivable1_wand_elim1 P3 B).
    sepcon_assoc_change; repeat progress cancel.
  }
  assert (Hwf_extract : os_inv sg_semaphore_ic staged |-- “ os_world_wf sg_semaphore_ic staged ”).
  { unfold os_inv; cbn zeta; Intros; split_pures; dump_pre_spatial; assumption. }
  prop_apply_p Hwf_extract. Intros_p Hwf.
  assert (Hmember : In first_task (semaphore_waiters (os_semaphores staged))).
  { destruct PreH7 as [obj [Hin [_ Hnodes]]].
    apply (f_equal (map (@getData Z))) in Hnodes.
    repeat rewrite map_map in Hnodes.
    change (map (fun x : Z => x) (semaphore_pending_addrs obj) = map (fun x : Z => x) waiting_semaphore_ic) in Hnodes.
    rewrite !map_id in Hnodes.
    unfold semaphore_waiters. apply in_concat. exists (semaphore_pending_addrs obj).
    split; [apply in_map; exact Hin|]. rewrite Hnodes, PreH12, PreH14.
    apply in_or_app. right. simpl; auto. }
  assert (Hneq : first_task <> task_pre).
  { intro Heq. subst first_task.
    apply (sched_owned_not_waiting sg_semaphore_ic staged task_pre Hwf PreH10).
    apply in_or_app. left; exact Hmember. }
  match goal with |- _ |-- ?Q => set (goalQ := Q) end.
  sep_apply_l_atomic (Hfocus2 sg_semaphore_ic staged sem_semaphore_ic waiting_semaphore_ic PreH7).
  rewrite <- PreH6.
  set (Wos := (task_inv sg_semaphore_ic staged **
    store_dll (pure_suspend_sched_link (task_desc_map (os_tasks staged))) list_pre (map sched_link_node waiting_semaphore_ic)) -*
    os_inv sg_semaphore_ic staged).
  assert (Hw : waiting_semaphore_ic = prefix_loop ++ first_task :: rest_tasks_2) by (rewrite PreH12, PreH14; reflexivity).
  rewrite Hw.
  pose proof (Hnext (task_desc_map (os_tasks staged)) list_pre prefix_loop first_task rest_tasks_2) as Hnext_now.
  cbn zeta in Hnext_now. sep_apply_l_atomic Hnext_now. clear Hnext_now.
  Intros dcur.
  assert (Hlookup : task_desc_map (os_tasks staged) first_task = Some dcur) by assumption.
  sep_apply_l_atomic (Htask2 sg_semaphore_ic staged task_pre first_task desc dcur PreH8 Hlookup Hneq). Intros.
  set (nl := match rest_tasks_2 with [] => list_pre | u::_ => sched_link_of u end).
  unfold goalQ; clear goalQ.
  destruct rest_tasks_2 as [|nt nr].
  - Left. Exists dcur first_task (@nil Z). split_pure_spatial.
    +
      rewrite PreH15.
      lazymatch goal with |- context [ (?P1 ** (?P2 ** ?P3)) -* ?R ] =>
        sep_apply_r_atomic (Hcompose P1 P2 P3 (task_inv sg_semaphore_ic staged)
          (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks staged))) list_pre
            (map sched_link_node waiting_semaphore_ic)) R)
      end.
      unfold Wos. rewrite Hw. cbn [nl poly_store]. repeat rewrite map_app. cbn [map]. sepcon_assoc_change; repeat progress cancel;
        try (lazymatch goal with |- ?P |-- _ => change (P |-- P); cancel P end).
    + split_pures; dump_pre_spatial; intuition congruence.
  - Right. Exists nl nt nr dcur first_task (nt::nr). split_pure_spatial.
    +
      rewrite PreH15.
      lazymatch goal with |- context [ (?P1 ** (?P2 ** ?P3)) -* ?R ] =>
        sep_apply_r_atomic (Hcompose P1 P2 P3 (task_inv sg_semaphore_ic staged)
          (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks staged))) list_pre
            (map sched_link_node waiting_semaphore_ic)) R)
      end.
      unfold Wos. rewrite Hw. cbn [nl poly_store]. repeat rewrite map_app. cbn [map]. sepcon_assoc_change; repeat progress cancel;
        try (lazymatch goal with |- ?P |-- _ => change (P |-- P); cancel P end).
      lazymatch goal with |- ?P ** ?Q |-- _ => change (P ** Q |-- Q ** P); cancel end.
    + split_pures; dump_pre_spatial; intuition congruence.
Qed.

Lemma proof_of_LinklistSuspend_entail_wit_6_1 : LinklistSuspend_entail_wit_6_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst retval.
  assert (Hprefix : forall scanned, In scanned (prefix_loop_2 ++ [current_task]) ->
    exists d, task_desc_map (os_tasks staged) scanned = Some d /\
      tsmCurPrio (tdSchedMember desc) <= tsmCurPrio (tdSchedMember d)).
  { intros scanned Hin. apply in_app_iff in Hin. destruct Hin as [Hin | Hin].
    - exact (PreH16 scanned Hin).
    - simpl in Hin. destruct Hin as [<- | []]. exists current_desc. auto. }
  Right. Exists next_task next_rest (prefix_loop_2 ++ [current_task]) rest_tasks_2.
  split_pure_spatial.
  - sep_apply_r_atomic (derivable1_wand_elim1
      (store_uchar (&((task_pre) # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (tsmCurPrio (tdSchedMember desc)) **
       (store_uchar (&((current_task) # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (tsmCurPrio (tdSchedMember current_desc)) **
        store_ptr (&((node) # "SysDoubleLinklistNode" ->ₛ "node_next")) next_link))
      (os_inv sg_semaphore_ic staged)).
    repeat progress cancel.
  - split_pures; dump_pre_spatial; auto.
    rewrite <- app_assoc. simpl. exact PreH15.
Qed.

Lemma proof_of_LinklistSuspend_entail_wit_6_2 : LinklistSuspend_entail_wit_6_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst retval. subst next_link.
  assert (Hprefix : forall scanned, In scanned (prefix_loop_2 ++ [current_task]) ->
    exists d, task_desc_map (os_tasks staged) scanned = Some d /\
      tsmCurPrio (tdSchedMember desc) <= tsmCurPrio (tdSchedMember d)).
  { intros scanned Hin. apply in_app_iff in Hin. destruct Hin as [Hin | Hin].
    - exact (PreH17 scanned Hin).
    - simpl in Hin. destruct Hin as [<- | []]. exists current_desc. auto. }
  Left. Exists (prefix_loop_2 ++ [current_task]) rest_tasks_2.
  split_pure_spatial.
  - sep_apply_r_atomic (derivable1_wand_elim1
      (store_uchar (&((task_pre) # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (tsmCurPrio (tdSchedMember desc)) **
       (store_uchar (&((current_task) # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "cur_prio")) (tsmCurPrio (tdSchedMember current_desc)) **
        store_ptr (&((node) # "SysDoubleLinklistNode" ->ₛ "node_next")) list_pre))
      (os_inv sg_semaphore_ic staged)).
    repeat progress cancel.
  - split_pures; dump_pre_spatial; auto.
    rewrite <- app_assoc. simpl. exact PreH16.
Qed.

Lemma proof_of_LinklistSuspend_entail_wit_7_1 : LinklistSuspend_entail_wit_7_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hcut : forall (A:Type) (storeA:Z -> A -> Assertion) head prefix suffix ptr (data newdata:A),
    store_dll storeA head (prefix ++ Build_DL_Node data ptr :: suffix)
    |-- storeA ptr data **
      (storeA ptr newdata -* store_dll storeA head (prefix ++ Build_DL_Node newdata ptr :: suffix))).
  { clear. intros A storeA head prefix suffix ptr data newdata.
    remember (storeA ptr newdata -* store_dll storeA head (prefix ++ Build_DL_Node newdata ptr :: suffix)) as W eqn:HW.
    unfold store_dll at 1. Intros hd pt.
    sep_apply_l_atomic (@dllseg_split A storeA hd head head pt prefix (Build_DL_Node data ptr :: suffix)).
    Intros cut beforeptr.
    cbn [dllseg]. Intros nxt. subst cut.
    fold (@dllseg A storeA).
    sepcon_assoc_change.
    cancel (storeA ptr data). subst W. apply_sepcon_adjoint.
    unfold store_dll at 1. Exists hd pt.
    split_pure_spatial.
    - cbn [getPtr getData].
      change ((&(ptr # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> beforeptr **
        (&(ptr # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> nxt **
        (dllseg storeA nxt ptr head pt suffix **
        (&(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> pt **
        (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> hd **
        dllseg storeA hd head ptr beforeptr prefix))))) ** storeA ptr newdata
        |-- &(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> pt **
            &(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> hd **
            dllseg storeA hd head head pt (prefix ++ Build_DL_Node newdata ptr :: suffix)).
      sep_apply_l_atomic (dllseg_head_insert A storeA beforeptr ptr nxt head pt newdata suffix).
      sep_apply_l_atomic (@dllseg_concat A storeA hd head ptr beforeptr head pt prefix (Build_DL_Node newdata ptr :: suffix)).
      sepcon_assoc_change; cancel.
    - dump_pre_spatial.
      destruct H as [Hhead [Hpt [Hhd Hnodes]]].
      repeat split; try assumption.
      unfold dll_nodes_nonzero in *. rewrite Forall_app in *.
      destruct Hnodes as [Hp Hs]. split; [exact Hp|]. inversion Hs; subst. constructor; assumption.
  }
  assert (Hownedcut : forall T owned task,
    NoDup owned -> In task owned ->
    store_owned_sched_nodes T owned |--
      store_detached_sched_link T task ** store_owned_sched_nodes T (remove Z.eq_dec task owned)).
  { clear. intros T owned task Hnd Hin.
    destruct (in_split task owned Hin) as [lefts [rights Heq]]. subst owned.
    pose proof (NoDup_remove_2 lefts rights task Hnd) as Hnot.
    assert (Hrem : forall xs, ~ In task xs -> remove Z.eq_dec task xs = xs).
    { intros xs Habs. exact (notin_remove Z.eq_dec xs task Habs). }
    assert (Hr : remove Z.eq_dec task (lefts ++ task::rights) = lefts ++ rights).
    { rewrite remove_app. cbn. destruct (Z.eq_dec task task); [|contradiction].
      rewrite !Hrem; [reflexivity|intro Hmem; apply Hnot; apply in_or_app; right; exact Hmem|intro Hmem; apply Hnot; apply in_or_app; left; exact Hmem]. }
    rewrite Hr. unfold store_owned_sched_nodes. rewrite !map_app.
    cbn [map]. rewrite !logic_equiv_iter_sepcon_app, logic_equiv_iter_sepcon_cons.
    sepcon_assoc_change; cancel. }
  assert (Hsemcut : forall wait sg lefts rights obj newwaiting,
    semaphore_inv wait sg (lefts ++ obj::rights) |--
      store_dll wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
        (map semaphore_wait_node (semaphore_pending_addrs obj)) **
      (store_dll wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
        (map semaphore_wait_node newwaiting) -*
       semaphore_inv wait sg
        (lefts ++ {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
          semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}::rights))).
  { clear - Hcut. intros wait sg lefts rights obj newwaiting.
    set (newobj := {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
          semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}).
    assert (Hmanager : semaphore_manager (lefts ++ newobj::rights) = semaphore_manager (lefts ++ obj::rights)).
    { unfold semaphore_manager. f_equal.
      - rewrite !map_app. cbn [map newobj semaphore_id]. reflexivity.
      - apply map_ext. intro k. rewrite !filter_app, !map_app.
        cbn [filter newobj semaphore_id]. destruct (Z.eqb (semaphore_id obj mod 16) (Z.of_nat k));
          cbn [map semaphore_idnode newobj semaphore_id semaphore_addr]; reflexivity. }
    remember (store_dll wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
        (map semaphore_wait_node newwaiting) -* semaphore_inv wait sg (lefts ++ newobj::rights)) as W eqn:HW.
    unfold semaphore_inv at 1. Intros_p Hcontext.
    rewrite map_app. cbn [map].
    sep_apply_l_atomic (Hcut SemaphoreAbs (store_semaphore wait) (semaphore_list_head sg)
      (map semaphore_link_node lefts) (map semaphore_link_node rights)
      (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) obj newobj).
    unfold store_semaphore at 1. Intros_p Hobj.
    cancel (store_dll wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
      (map semaphore_wait_node (semaphore_pending_addrs obj))).
    subst W. apply_sepcon_adjoint.
    unfold semaphore_inv at 1. rewrite Hmanager.
    split_pure_spatial.
    - cancel (store_idmanager (semaphore_manager_stable sg) (semaphore_manager (lefts ++ obj::rights)) (semaphore_manager_ptr sg)).
      rewrite map_app. cbn [map semaphore_link_node newobj semaphore_addr].
      sep_apply_r_atomic (derivable1_wand_elim1
        (store_semaphore wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) newobj)
        (store_dll (store_semaphore wait) (semaphore_list_head sg)
          (map semaphore_link_node lefts ++ Build_DL_Node newobj (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) :: map semaphore_link_node rights))).
      cancel (store_semaphore wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) newobj -*
        store_dll (store_semaphore wait) (semaphore_list_head sg)
          (map semaphore_link_node lefts ++ Build_DL_Node newobj (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) :: map semaphore_link_node rights)).
      unfold store_semaphore. cbn [newobj semaphore_addr semaphore_value semaphore_pending_addrs].
      split_pure_spatial; [sepcon_assoc_change; cancel|dump_pre_spatial; exact Hobj].
    - dump_pre_spatial; exact Hcontext. }

  assert (Hpure : forall sg st task desc lefts rights obj newwaiting,
    os_world_wf sg st -> task_world_wf st -> os_semaphores st = lefts ++ obj::rights ->
    task_desc_map (os_tasks st) task = Some desc -> tsmStat (tdSchedMember desc) = TSK_SUSPEND ->
    In task (sched_owned_tasks (os_tasks st)) -> ktask_not_os_service task st ->
    Permutation newwaiting (task::semaphore_pending_addrs obj) ->
    let after := replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
      (replace_semaphores (lefts ++ {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
        semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}::rights) st) in
    task_world_wf after /\ os_world_wf sg after).
  { clear. intros sg st task desc lefts rights obj newwaiting Hw Htw Hsems Hlookup Hstatus Howned Hnotservice Hnewperm.
    set (after := replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
      (replace_semaphores (lefts ++ {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
        semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}::rights) st)).
    assert (Hslot : forall entry slot, service_phase slot <> ServiceRegistered task ->
      service_slot_wf st entry slot -> service_slot_wf after entry slot).
    { intros entry slot Hneq Hslot. unfold service_slot_wf in *.
      destruct (service_phase slot) as [| |service] eqn:Hphase; try exact Hslot.
      destruct Hslot as [sd Hsd]. exists sd. destruct Hsd as [Hl He Hd Ho Hi].
      constructor; try assumption.
      intros Hnonready. change (In service (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))).
      apply in_in_remove; [congruence|apply Ho; exact Hnonready]. }
    assert (Htwafter : task_world_wf after).
    { constructor.
      - exact (task_wf_map_present st Htw).
      - intros t d Hmap Hinit. change (task_desc_map (os_tasks st) t = Some d) in Hmap.
        change (In t (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))).
        apply in_in_remove.
        + intro Heq. subst t. rewrite Hlookup in Hmap. inversion Hmap; subst d.
          destruct Hinit; congruence.
        + eapply task_wf_init_running_owned; eauto.
      - exact (task_wf_id_nodes st Htw).
      - exact (task_wf_priority st Htw).
      - exact (task_wf_aligned st Htw).
      - exact (task_wf_running_bitmap st Htw).
      - exact (task_wf_init_close_bitmap st Htw). }
    assert (Hownednd : NoDup (sched_owned_tasks (os_tasks st))).
    { pose proof (os_wf_sched_nodup sg st Hw) as Hnd. unfold os_sched_owners in Hnd.
      exact (NoDup_app_remove_r _ _ Hnd). }
    destruct (in_split task _ Howned) as [ol [orr Ho]].
    pose proof (NoDup_remove_2 ol orr task ltac:(rewrite <- Ho; exact Hownednd)) as Hnot.
    assert (Hremove : remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) = ol ++ orr).
    { rewrite Ho, remove_app, remove_cons.
      rewrite !notin_remove; [reflexivity|intro Hi; apply Hnot; apply in_or_app; right; exact Hi|intro Hi; apply Hnot; apply in_or_app; left; exact Hi]. }
    assert (Hownedperm : Permutation (task :: remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
      (sched_owned_tasks (os_tasks st))).
    { rewrite Hremove, Ho. apply Permutation_middle. }
    assert (Howners : Permutation (os_sched_owners after) (os_sched_owners st)).
    { unfold os_sched_owners, after. cbn [replace_sched_owned_tasks replace_semaphores os_tasks sched_owned_tasks
        os_assign zombie_queue os_semaphores os_mutexes os_events].
      unfold semaphore_waiters. rewrite Hsems, !map_app, !concat_app.
      cbn [map List.concat semaphore_pending_addrs].
      set (pre := map (@getData addr) (os_ready_nodes (orvBuckets (assignReadyVector (os_assign st)))) ++
        map (@getData addr) (zombie_nodes (zombie_queue st)) ++ List.concat (map semaphore_pending_addrs lefts)).
      set (post := List.concat (map semaphore_pending_addrs rights) ++ mutex_waiters (os_mutexes st) ++ event_waiters (os_events st)).
      change (Permutation
        (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++
         map (@getData addr) (os_ready_nodes (orvBuckets (assignReadyVector (os_assign st)))) ++
         map (@getData addr) (zombie_nodes (zombie_queue st)) ++
         ((List.concat (map semaphore_pending_addrs lefts) ++ newwaiting ++ List.concat (map semaphore_pending_addrs rights))) ++
         mutex_waiters (os_mutexes st) ++ event_waiters (os_events st))
        (sched_owned_tasks (os_tasks st) ++
         map (@getData addr) (os_ready_nodes (orvBuckets (assignReadyVector (os_assign st)))) ++
         map (@getData addr) (zombie_nodes (zombie_queue st)) ++
         ((List.concat (map semaphore_pending_addrs lefts) ++ semaphore_pending_addrs obj ++ List.concat (map semaphore_pending_addrs rights))) ++
         mutex_waiters (os_mutexes st) ++ event_waiters (os_events st))).
      replace (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++ _)%list
        with (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++ pre ++ newwaiting ++ post)%list
        by (unfold pre, post; repeat rewrite <- app_assoc; reflexivity).
      replace (sched_owned_tasks (os_tasks st) ++ _)%list
        with (sched_owned_tasks (os_tasks st) ++ pre ++ semaphore_pending_addrs obj ++ post)%list
        by (unfold pre, post; repeat rewrite <- app_assoc; reflexivity).
      eapply Permutation_trans with
        (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++ pre ++ task :: semaphore_pending_addrs obj ++ post).
      - apply Permutation_app_head. apply Permutation_app_head.
        change (Permutation (newwaiting ++ post) ((task::semaphore_pending_addrs obj) ++ post)).
        apply Permutation_app_tail. exact Hnewperm.
      - eapply Permutation_trans with
          ((task::remove Z.eq_dec task (sched_owned_tasks (os_tasks st))) ++ pre ++ semaphore_pending_addrs obj ++ post).
        + rewrite (app_assoc _ pre (task :: semaphore_pending_addrs obj ++ post)).
          apply Permutation_sym.
          replace ((task::remove Z.eq_dec task (sched_owned_tasks (os_tasks st))) ++ pre ++ semaphore_pending_addrs obj ++ post)
            with (task :: (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++ pre) ++ (semaphore_pending_addrs obj ++ post))
            by (repeat rewrite <- app_assoc; reflexivity).
          apply Permutation_middle.
        + apply Permutation_app_tail. exact Hownedperm. }
    split; [exact Htwafter|]. constructor.
    - exact (os_wf_context sg st Hw).
    - change (service_slot_wf after (os_recycler_entry sg) (os_recycle st)).
      apply Hslot; [exact (proj1 Hnotservice)|exact (os_wf_recycler sg st Hw)].
    - change (Forall (service_slot_wf after (os_idle_entry sg)) (os_idle st)).
      apply Forall_forall. intros slot Hin.
      apply Hslot.
      + apply (proj1 (Forall_forall _ _) (proj2 Hnotservice) slot Hin).
      + apply (proj1 (Forall_forall _ _) (os_wf_idle sg st Hw) slot Hin).
    - eapply Permutation_NoDup; [apply Permutation_sym; exact Howners|exact (os_wf_sched_nodup sg st Hw)].
    - intro t. change (In t (os_sched_owners after) <-> task_desc_map (os_tasks st) t <> None).
      rewrite <- (os_wf_sched_domain sg st Hw t). split; intro Hin.
      + eapply Permutation_in; [exact Howners|exact Hin].
      + eapply Permutation_in; [apply Permutation_sym; exact Howners|exact Hin]. }
  assert (Havoid : forall (A:Type) (storeA:Z -> A -> Assertion) (l:list (DL_Node A)) x px y py t v,
    dllseg storeA x px y py l ** &(t # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> v
    |-- “ ~ In t (map (@getPtr A) l) ”).
  { clear. intros A storeA l; induction l as [|a rest IH]; intros x px y py t v.
    - unfold dllseg. Intros_p Heq. dump_pre_spatial. simpl; tauto.
    - unfold dllseg at 1. fold (@dllseg A storeA). Intros z. subst x. fold (@dllseg A storeA).
      destruct (Z.eq_dec (getPtr a) t) as [Heq|Hneq].
      + rewrite Heq. sep_apply_l_atomic (dup_store_ptr (&(t # "SysDoubleLinklistNode" ->ₛ "node_next")) z v).
        Intros_p Hfalse. contradiction.
      + change (storeA (getPtr a) (getData a) **
          (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
          (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
          (dllseg storeA z (getPtr a) y py rest **
           &(t # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> v)))
          |-- “ ~ In t (map (@getPtr A) (a::rest)) ”).
        sep_apply_l_atomic (IH z (getPtr a) y py t v). Intros_p Hrest.
        dump_pre_spatial. simpl; intuition congruence. }
  assert (Hnodup : forall (A:Type) (storeA:Z -> A -> Assertion) (l:list (DL_Node A)) x px y py,
    dllseg storeA x px y py l |-- “ NoDup (map (@getPtr A) l) ”).
  { clear - Havoid. intros A storeA l; induction l as [|a rest IH]; intros x px y py.
    - unfold dllseg. Intros_p Heq. dump_pre_spatial. constructor.
    - unfold dllseg at 1. fold (@dllseg A storeA). Intros z. subst x. fold (@dllseg A storeA).
      change (storeA (getPtr a) (getData a) **
        (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
        (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
        dllseg storeA z (getPtr a) y py rest))
        |-- “ NoDup (map (@getPtr A) (a::rest)) ”).
      prop_apply_p (Havoid A storeA rest z (getPtr a) y py (getPtr a) z). Intros_p Hnot.
      prop_apply_p (IH z (getPtr a) y py). Intros_p Hrest.
      dump_pre_spatial. simpl. constructor; assumption. }
  assert (Hdll : forall (A:Type) (storeA:Z -> A -> Assertion) h (l:list (DL_Node A)),
    store_dll storeA h l |-- “ NoDup (map (@getPtr A) l) /\ ~ In h (map (@getPtr A) l) ”).
  { clear - Havoid Hnodup. intros A storeA h l. unfold store_dll. Intros hd pt.
    change (&(h # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> pt **
      (&(h # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> hd **
      dllseg storeA hd h h pt l) |-- “ NoDup (map (@getPtr A) l) /\ ~ In h (map (@getPtr A) l) ”).
    prop_apply_p (Havoid A storeA l hd h h pt h hd). Intros_p Hnot.
    prop_apply_p (Hnodup A storeA l hd h h pt). Intros_p Hnd.
    dump_pre_spatial. auto. }

  assert (HsemND : forall wait sg ss,
    semaphore_inv wait sg ss |-- “ NoDup (map semaphore_addr ss) ”).
  { clear - Hdll. intros wait sg ss. unfold semaphore_inv. Intros_p Hctx.
    prop_apply_p (Hdll SemaphoreAbs (store_semaphore wait) (semaphore_list_head sg) (map semaphore_link_node ss)).
    Intros_p Hnd. dump_pre_spatial. destruct Hnd as [Hnd _].
    assert (Heq : map (@getPtr SemaphoreAbs) (map semaphore_link_node ss) =
      map (fun p:Z => &(p # "Semaphore" ->ₛ "link")) (map semaphore_addr ss)).
    { rewrite !map_map. reflexivity. }
    rewrite Heq in Hnd. eapply NoDup_map_inv; exact Hnd. }
  assert (Hprep : forall sg st sem task desc waiting newwaiting,
    semaphore_pending_nodes sem st (map sched_link_node waiting) ->
    task_desc_map (os_tasks st) task = Some desc -> tsmStat (tdSchedMember desc) = TSK_SUSPEND ->
    In task (sched_owned_tasks (os_tasks st)) -> ktask_not_os_service task st ->
    Permutation newwaiting (task::waiting) ->
    os_inv sg st |-- “ sched_link_of task <> 0 ” &&
      store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st))) (semaphore_pending_head sem) (map sched_link_node waiting) **
      pure_suspend_sched_link (task_desc_map (os_tasks st)) (sched_link_of task) task **
      occupy_dll_node (sched_link_of task) **
      (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st))) (semaphore_pending_head sem) (map sched_link_node newwaiting) -*
       os_inv sg (replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
          (semaphore_enqueue_state sem newwaiting st)))).
  { clear - Hownedcut Hsemcut Hpure HsemND.
    intros sg st sem task desc waiting newwaiting Hpending Hlookup Hstatus Howned Hnotservice Hnewperm.
    destruct Hpending as [obj [Hin [Haddr Hwaiting]]].
    assert (Hwait : semaphore_pending_addrs obj = waiting).
    { apply (f_equal (map (@getData Z))) in Hwaiting. rewrite !map_map in Hwaiting.
      change (map (fun x:Z => x) (semaphore_pending_addrs obj) = map (fun x:Z => x) waiting) in Hwaiting.
      rewrite !map_id in Hwaiting. exact Hwaiting. }
    destruct (in_split obj _ Hin) as [lefts [rights Hss]].
    set (newobj := {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
       semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}).
    set (after := replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
      (replace_semaphores (lefts ++ newobj::rights) st)).
    remember (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st))) (semaphore_pending_head sem) (map sched_link_node newwaiting) -*
       os_inv sg (replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
          (semaphore_enqueue_state sem newwaiting st))) as W eqn:HW.
    unfold os_inv at 1. Intros_p Hworld.
    prop_apply_p (HsemND (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_semaphore_stable sg) (os_semaphores st)). Intros_p Hunique.
    unfold task_inv at 1. Intros_p Htask.
    assert (Hsemupdate : semaphore_enqueue_state sem newwaiting st = replace_semaphores (lefts ++ newobj::rights) st).
    { unfold semaphore_enqueue_state. f_equal.
      rewrite Hss, map_app. cbn [map].
      destruct (Z.eq_dec (semaphore_addr obj) sem) as [Heq|Hneq]; [|contradiction].
      assert (Hnot : ~ In sem (map semaphore_addr lefts ++ map semaphore_addr rights)).
      { rewrite Hss, map_app in Hunique. cbn [map] in Hunique. rewrite Haddr in Hunique.
        exact (NoDup_remove_2 _ _ _ Hunique). }
      assert (Hident : forall xs, ~ In sem (map semaphore_addr xs) ->
        map (fun s => if Z.eq_dec (semaphore_addr s) sem then
          {| semaphore_addr:=semaphore_addr s; semaphore_id:=semaphore_id s; semaphore_value:=semaphore_value s;
             semaphore_pending_addrs:=newwaiting |} else s) xs = xs).
      { intros xs Hnotin. rewrite <- (map_id xs) at 2. apply map_ext_in. intros s Hmem.
        destruct (Z.eq_dec (semaphore_addr s) sem); [exfalso;apply Hnotin; rewrite <- e;apply in_map;exact Hmem|reflexivity]. }
      rewrite !Hident; [reflexivity|intro Hi;apply Hnot;apply in_or_app;right;exact Hi|intro Hi;apply Hnot;apply in_or_app;left;exact Hi]. }
    assert (Hownednd : NoDup (sched_owned_tasks (os_tasks st))).
    { pose proof (os_wf_sched_nodup sg st Hworld) as Hnd. unfold os_sched_owners in Hnd.
      exact (NoDup_app_remove_r _ _ Hnd). }
    assert (Hnewpermobj : Permutation newwaiting (task::semaphore_pending_addrs obj)) by (rewrite Hwait; exact Hnewperm).
    pose proof (Hpure sg st task desc lefts rights obj newwaiting Hworld Htask Hss Hlookup Hstatus Howned Hnotservice Hnewpermobj) as [Htaskafter Hworldafter].
    assert (Hnzero : store_map store_published_task (task_desc_map (os_tasks st)) |-- “ sched_link_of task <> 0 ”).
    { sep_apply_l_atomic (store_map_split store_published_task task desc (task_desc_map (os_tasks st)) Hlookup).
      unfold store_published_task, store_task_descriptor. Intros.
      prop_apply_p (valid_store_ptr (&(task # "TaskDescriptor" ->ₛ "stack_point")) (tdStackPoint desc)). Intros_p Hv.
      dump_pre_spatial.
      pose proof (task_descriptor_field_offset_axiom task (task_wf_aligned st Htask task desc Hlookup)) as Hl.
      unfold ktask_descriptor_field_offset_ok in Hl.
      assert (Hstack : &(task # "TaskDescriptor" ->ₛ "stack_point") = task + 0) by tauto.
      assert (Hlink : sched_link_of task = task + 16) by (unfold sched_link_of; tauto).
      unfold valid_object, valid_addr_range in Hv. rewrite Hstack in Hv. rewrite Hlink. intuition lia. }
    prop_apply_p Hnzero. Intros_p Hlinknz.
    assert (Hqueues : dataqueue_inv (lefts ++ obj::rights) (os_dataqueues st) |-- dataqueue_inv (lefts ++ newobj::rights) (os_dataqueues st)).
    { unfold dataqueue_inv. Intros_p Hq.
      split_pure_spatial; [cancel|]. dump_pre_spatial. intros p q Hmap.
      destruct (Hq p q Hmap) as [Hr [Hb Hd]]. split; [exact Hr|].
      assert (Hmove : forall id, (exists s, In s (lefts ++ obj::rights) /\ semaphore_id s = id) ->
          exists s, In s (lefts ++ newobj::rights) /\ semaphore_id s = id).
      { intros id [s [Hs Hid]]. apply in_app_iff in Hs. destruct Hs as [Hs|[Hs|Hs]].
        - exists s. split; [apply in_or_app;left;exact Hs|exact Hid].
        - subst s. exists newobj. split; [apply in_or_app;right;left;reflexivity|exact Hid].
        - exists s. split; [apply in_or_app;right;right;exact Hs|exact Hid]. }
      split; apply Hmove; assumption. }
    rewrite Hss.
    sep_apply_l_atomic (Hownedcut (task_desc_map (os_tasks st)) (sched_owned_tasks (os_tasks st)) task Hownednd Howned).
    sep_apply_l_atomic (Hsemcut (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_semaphore_stable sg) lefts rights obj newwaiting).
    unfold store_detached_sched_link at 1. Intros actual.
    sep_apply_l_atomic (store_node_self_linked_occupy (sched_link_of task)).
    change (map semaphore_wait_node (semaphore_pending_addrs obj)) with (map sched_link_node (semaphore_pending_addrs obj)).
    rewrite Hwait. unfold semaphore_pending_head. rewrite <- Haddr.
    split_pure_spatial.
    - sep_apply_r_atomic (pure_suspend_sched_link_close (task_desc_map (os_tasks st)) (sched_link_of task) task desc Hlookup eq_refl Hstatus).
      cancel (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st)))
        (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list")) (map sched_link_node waiting)).
      cancel (occupy_dll_node (sched_link_of task)).
      subst W. rewrite Hsemupdate. change (replace_sched_owned_tasks _ (replace_semaphores _ st)) with after.
      asrt_simpl. apply_sepcon_adjoint.
      change (map sched_link_node newwaiting) with (map semaphore_wait_node newwaiting).
      unfold semaphore_pending_head. rewrite <- Haddr. fold newobj.
      sep_apply_l_atomic (derivable1_wand_elim1
        (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st)))
          (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list")) (map semaphore_wait_node newwaiting))
        (semaphore_inv (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_semaphore_stable sg) (lefts ++ newobj::rights))).
      sep_apply_l_atomic Hqueues.
      unfold os_inv, task_inv. cbn [after replace_sched_owned_tasks replace_semaphores].
      split_pure_spatial.
      + change (os_tasks after) with
          ({| task_desc_map := task_desc_map (os_tasks st); task_ptr_list := task_ptr_list (os_tasks st);
              task_idmanager_abs := task_idmanager_abs (os_tasks st);
              sched_owned_tasks := remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) |}).
        change (tick_inv sg after) with (tick_inv sg st).
        change (delay_inv sg after) with (delay_inv sg st).
        change (assign_inv sg after) with (assign_inv sg st).
        change (exstatus_inv sg after) with (exstatus_inv sg st).
        change (zombie_queue after) with (zombie_queue st).
        change (os_recycle after) with (os_recycle st).
        change (os_idle after) with (os_idle st).
        change (os_isr after) with (os_isr st).
        change (os_semaphores after) with (lefts ++ newobj::rights).
        change (os_mutexes after) with (os_mutexes st).
        change (os_events after) with (os_events st).
        change (os_dataqueues after) with (os_dataqueues st).
        cbv beta iota zeta delta [task_idmanager_abs task_ptr_list task_desc_map sched_owned_tasks].
        sepcon_assoc_change; cancel.
      + split_pures; dump_pre_spatial; assumption.
    - dump_pre_spatial; exact Hlinknz. }

  assert (Hwaiting : waiting_semaphore_ic = prefix_loop).
  { rewrite PreH14, app_nil_r in PreH12. exact PreH12. }
  set (newwaiting := waiting_semaphore_ic ++ [task_pre]).
  set (newnodes := map sched_link_node newwaiting).
  set (after := replace_sched_owned_tasks (remove Z.eq_dec task_pre (sched_owned_tasks (os_tasks staged)))
    (semaphore_enqueue_state sem_semaphore_ic newwaiting staged)).
  assert (Hpriority : linklist_priority_insert (task_desc_map (os_tasks staged)) task_pre
      (map sched_link_node waiting_semaphore_ic) newnodes).
  { exists desc, (map sched_link_node waiting_semaphore_ic), [].
    repeat split; try assumption; try rewrite app_nil_r; try reflexivity.
    - unfold newnodes, newwaiting. rewrite map_app. reflexivity.
    - apply Forall_forall. intros n Hin. apply in_map_iff in Hin.
      destruct Hin as [a [<- Hin]]. apply PreH13. rewrite <- Hwaiting; exact Hin. }
  assert (Hperm : Permutation newwaiting (task_pre::waiting_semaphore_ic)).
  { unfold newwaiting. apply Permutation_sym.
    replace (task_pre::waiting_semaphore_ic) with (task_pre::waiting_semaphore_ic++[]) by (rewrite app_nil_r; reflexivity).
    apply Permutation_middle. }
  assert (Henqueue : linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after).
  { destruct PreH7 as [obj [Hin [Haddr Hnodes]]].
    exists obj, desc, newnodes. repeat split; try assumption.
    - right. split; [reflexivity|]. rewrite Hnodes. exact Hpriority.
    - unfold after, newnodes. rewrite map_map.
      change (map (fun x:Z => x) newwaiting) with (map (@id Z) newwaiting).
      rewrite map_id. reflexivity. }
  sep_apply_l_atomic (Hprep sg_semaphore_ic staged sem_semaphore_ic task_pre desc waiting_semaphore_ic newwaiting
     PreH7 PreH8 PreH9 PreH10 PreH11 Hperm).
  Intros_p Hnz.
  Exists after newnodes waiting_semaphore_ic (@nil Z).
  split_pure_spatial.
  - unfold after, newnodes. rewrite PreH6. unfold sched_link_of. sepcon_assoc_change; cancel.
  - split_pures; dump_pre_spatial; try assumption; try rewrite app_nil_r; try reflexivity;
      try (unfold newnodes, newwaiting; reflexivity); try congruence.
Qed.

Lemma proof_of_LinklistSuspend_entail_wit_7_2 : LinklistSuspend_entail_wit_7_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Havoid : forall (A:Type) (storeA:Z -> A -> Assertion) (l:list (DL_Node A)) x px y py t v,
    dllseg storeA x px y py l ** &(t # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> v
    |-- “ ~ In t (map (@getPtr A) l) ”).
  { clear. intros A storeA l; induction l as [|a rest IH]; intros x px y py t v.
    - unfold dllseg. Intros_p Heq. dump_pre_spatial. simpl; tauto.
    - unfold dllseg at 1. fold (@dllseg A storeA). Intros z. subst x. fold (@dllseg A storeA).
      destruct (Z.eq_dec (getPtr a) t) as [Heq|Hneq].
      + rewrite Heq. sep_apply_l_atomic (dup_store_ptr (&(t # "SysDoubleLinklistNode" ->ₛ "node_next")) z v).
        Intros_p Hfalse. contradiction.
      + change (storeA (getPtr a) (getData a) **
          (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
          (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
          (dllseg storeA z (getPtr a) y py rest **
           &(t # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> v)))
          |-- “ ~ In t (map (@getPtr A) (a::rest)) ”).
        sep_apply_l_atomic (IH z (getPtr a) y py t v). Intros_p Hrest.
        dump_pre_spatial. simpl; intuition congruence. }
  assert (Hnodup : forall (A:Type) (storeA:Z -> A -> Assertion) (l:list (DL_Node A)) x px y py,
    dllseg storeA x px y py l |-- “ NoDup (map (@getPtr A) l) ”).
  { clear - Havoid. intros A storeA l; induction l as [|a rest IH]; intros x px y py.
    - unfold dllseg. Intros_p Heq. dump_pre_spatial. constructor.
    - unfold dllseg at 1. fold (@dllseg A storeA). Intros z. subst x. fold (@dllseg A storeA).
      change (storeA (getPtr a) (getData a) **
        (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
        (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
        dllseg storeA z (getPtr a) y py rest))
        |-- “ NoDup (map (@getPtr A) (a::rest)) ”).
      prop_apply_p (Havoid A storeA rest z (getPtr a) y py (getPtr a) z). Intros_p Hnot.
      prop_apply_p (IH z (getPtr a) y py). Intros_p Hrest.
      dump_pre_spatial. simpl. constructor; assumption. }
  assert (Hdll : forall (A:Type) (storeA:Z -> A -> Assertion) h (l:list (DL_Node A)),
    store_dll storeA h l |-- “ NoDup (map (@getPtr A) l) /\ ~ In h (map (@getPtr A) l) ”).
  { clear - Havoid Hnodup. intros A storeA h l. unfold store_dll. Intros hd pt.
    change (&(h # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> pt **
      (&(h # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> hd **
      dllseg storeA hd h h pt l) |-- “ NoDup (map (@getPtr A) l) /\ ~ In h (map (@getPtr A) l) ”).
    prop_apply_p (Havoid A storeA l hd h h pt h hd). Intros_p Hnot.
    prop_apply_p (Hnodup A storeA l hd h h pt). Intros_p Hnd.
    dump_pre_spatial. auto. }
  assert (Hlift : forall (A:Type) (storeA:Z -> A -> Assertion) (l:list (DL_Node A)) (a:DL_Node A) (P:Prop),
    In a l -> (forall link, storeA link (getData a) |-- “ P ”) ->
    forall x px y py, dllseg storeA x px y py l |-- “ P ”).
  { clear. intros A storeA l; induction l as [|b rest IH]; intros a P Hin Hpayload x px y py.
    - contradiction.
    - unfold dllseg at 1. fold (@dllseg A storeA). Intros z. fold (@dllseg A storeA).
      destruct Hin as [Heq|Hin].
      + subst b. sep_apply_l_atomic (Hpayload x). Intros_p HP. dump_pre_spatial; exact HP.
      + sep_apply_l_atomic (IH a P Hin Hpayload z x y py). Intros_p HP. dump_pre_spatial; exact HP. }
  destruct PreH7 as [obj [Hin [Haddr Hwaiting]]].
  assert (Hnodeseq : semaphore_pending_addrs obj = waiting_semaphore_ic).
  { apply (f_equal (map (@getData Z))) in Hwaiting. rewrite !map_map in Hwaiting.
    change (map (fun x:Z => x) (semaphore_pending_addrs obj) = map (fun x:Z => x) waiting_semaphore_ic) in Hwaiting.
    rewrite !map_id in Hwaiting. exact Hwaiting. }
  assert (Hstore : forall (A:Type) (storeA:Z -> A -> Assertion) (l:list (DL_Node A)) (a:DL_Node A) (P:Prop),
    In a l -> (forall link, storeA link (getData a) |-- “ P ”) ->
    forall h, store_dll storeA h l |-- “ P ”).
  { clear - Hlift. intros A storeA l a P Hin HP h.
    unfold store_dll. Intros hd pt.
    change (&(h # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> pt **
      (&(h # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> hd **
      dllseg storeA hd h h pt l) |-- “ P ”).
    sep_apply_l_atomic (Hlift A storeA l a P Hin HP hd h h pt).
    Intros_p Hpure. dump_pre_spatial; exact Hpure. }
  assert (Hpayload : forall link, store_semaphore (pure_suspend_sched_link (task_desc_map (os_tasks staged))) link obj |-- “ False ”).
  { intros link. unfold store_semaphore. Intros_p Hp.
    prop_apply_p (Hdll Z (pure_suspend_sched_link (task_desc_map (os_tasks staged)))
      (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
      (map semaphore_wait_node (semaphore_pending_addrs obj))). Intros_p Hdistinct.
    dump_pre_spatial. destruct Hdistinct as [_ Hnot]. apply Hnot.
    rewrite Hnodeseq, PreH12, PreH14, !map_app. apply in_or_app; right.
    simpl. left. unfold semaphore_wait_node, getPtr, object_wait_link_of.
    rewrite Haddr. change (sched_link_of first_task = semaphore_pending_head sem_semaphore_ic).
    congruence. }
  assert (Hbad : os_inv sg_semaphore_ic staged |-- “ False ”).
  { unfold os_inv, semaphore_inv. Intros_p Hworld. Intros_p Hcontext.
    sep_apply_l_atomic (Hstore SemaphoreAbs (store_semaphore (pure_suspend_sched_link (task_desc_map (os_tasks staged))))
       (map semaphore_link_node (os_semaphores staged)) (semaphore_link_node obj) False
       (in_map semaphore_link_node _ _ Hin) Hpayload (semaphore_list_head (os_semaphore_stable sg_semaphore_ic))).
    Intros_p Hfalse. contradiction. }
  unfold derivable1, coq_prop in Hbad |- *. intros m Hm. exfalso. exact (Hbad m Hm).
Qed.

Lemma proof_of_LinklistSuspend_entail_wit_7_3 : LinklistSuspend_entail_wit_7_3.
Proof.
LLM_pre_process ltac:(lia || int_auto).
  assert (Hcut : forall (A:Type) (storeA:Z -> A -> Assertion) head prefix suffix ptr (data newdata:A),
    store_dll storeA head (prefix ++ Build_DL_Node data ptr :: suffix)
    |-- storeA ptr data **
      (storeA ptr newdata -* store_dll storeA head (prefix ++ Build_DL_Node newdata ptr :: suffix))).
  { clear. intros A storeA head prefix suffix ptr data newdata.
    remember (storeA ptr newdata -* store_dll storeA head (prefix ++ Build_DL_Node newdata ptr :: suffix)) as W eqn:HW.
    unfold store_dll at 1. Intros hd pt.
    sep_apply_l_atomic (@dllseg_split A storeA hd head head pt prefix (Build_DL_Node data ptr :: suffix)).
    Intros cut beforeptr.
    cbn [dllseg]. Intros nxt. subst cut.
    fold (@dllseg A storeA).
    sepcon_assoc_change.
    cancel (storeA ptr data). subst W. apply_sepcon_adjoint.
    unfold store_dll at 1. Exists hd pt.
    split_pure_spatial.
    - cbn [getPtr getData].
      change ((&(ptr # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> beforeptr **
        (&(ptr # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> nxt **
        (dllseg storeA nxt ptr head pt suffix **
        (&(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> pt **
        (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> hd **
        dllseg storeA hd head ptr beforeptr prefix))))) ** storeA ptr newdata
        |-- &(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> pt **
            &(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> hd **
            dllseg storeA hd head head pt (prefix ++ Build_DL_Node newdata ptr :: suffix)).
      sep_apply_l_atomic (dllseg_head_insert A storeA beforeptr ptr nxt head pt newdata suffix).
      sep_apply_l_atomic (@dllseg_concat A storeA hd head ptr beforeptr head pt prefix (Build_DL_Node newdata ptr :: suffix)).
      sepcon_assoc_change; cancel.
    - dump_pre_spatial.
      destruct H as [Hhead [Hpt [Hhd Hnodes]]].
      repeat split; try assumption.
      unfold dll_nodes_nonzero in *. rewrite Forall_app in *.
      destruct Hnodes as [Hp Hs]. split; [exact Hp|]. inversion Hs; subst. constructor; assumption.
  }
  assert (Hownedcut : forall T owned task,
    NoDup owned -> In task owned ->
    store_owned_sched_nodes T owned |--
      store_detached_sched_link T task ** store_owned_sched_nodes T (remove Z.eq_dec task owned)).
  { clear. intros T owned task Hnd Hin.
    destruct (in_split task owned Hin) as [lefts [rights Heq]]. subst owned.
    pose proof (NoDup_remove_2 lefts rights task Hnd) as Hnot.
    assert (Hrem : forall xs, ~ In task xs -> remove Z.eq_dec task xs = xs).
    { intros xs Habs. exact (notin_remove Z.eq_dec xs task Habs). }
    assert (Hr : remove Z.eq_dec task (lefts ++ task::rights) = lefts ++ rights).
    { rewrite remove_app. cbn. destruct (Z.eq_dec task task); [|contradiction].
      rewrite !Hrem; [reflexivity|intro Hmem; apply Hnot; apply in_or_app; right; exact Hmem|intro Hmem; apply Hnot; apply in_or_app; left; exact Hmem]. }
    rewrite Hr. unfold store_owned_sched_nodes. rewrite !map_app.
    cbn [map]. rewrite !logic_equiv_iter_sepcon_app, logic_equiv_iter_sepcon_cons.
    sepcon_assoc_change; cancel. }
  assert (Hsemcut : forall wait sg lefts rights obj newwaiting,
    semaphore_inv wait sg (lefts ++ obj::rights) |--
      store_dll wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
        (map semaphore_wait_node (semaphore_pending_addrs obj)) **
      (store_dll wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
        (map semaphore_wait_node newwaiting) -*
       semaphore_inv wait sg
        (lefts ++ {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
          semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}::rights))).
  { clear - Hcut. intros wait sg lefts rights obj newwaiting.
    set (newobj := {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
          semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}).
    assert (Hmanager : semaphore_manager (lefts ++ newobj::rights) = semaphore_manager (lefts ++ obj::rights)).
    { unfold semaphore_manager. f_equal.
      - rewrite !map_app. cbn [map newobj semaphore_id]. reflexivity.
      - apply map_ext. intro k. rewrite !filter_app, !map_app.
        cbn [filter newobj semaphore_id]. destruct (Z.eqb (semaphore_id obj mod 16) (Z.of_nat k));
          cbn [map semaphore_idnode newobj semaphore_id semaphore_addr]; reflexivity. }
    remember (store_dll wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
        (map semaphore_wait_node newwaiting) -* semaphore_inv wait sg (lefts ++ newobj::rights)) as W eqn:HW.
    unfold semaphore_inv at 1. Intros_p Hcontext.
    rewrite map_app. cbn [map].
    sep_apply_l_atomic (Hcut SemaphoreAbs (store_semaphore wait) (semaphore_list_head sg)
      (map semaphore_link_node lefts) (map semaphore_link_node rights)
      (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) obj newobj).
    unfold store_semaphore at 1. Intros_p Hobj.
    cancel (store_dll wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
      (map semaphore_wait_node (semaphore_pending_addrs obj))).
    subst W. apply_sepcon_adjoint.
    unfold semaphore_inv at 1. rewrite Hmanager.
    split_pure_spatial.
    - cancel (store_idmanager (semaphore_manager_stable sg) (semaphore_manager (lefts ++ obj::rights)) (semaphore_manager_ptr sg)).
      rewrite map_app. cbn [map semaphore_link_node newobj semaphore_addr].
      sep_apply_r_atomic (derivable1_wand_elim1
        (store_semaphore wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) newobj)
        (store_dll (store_semaphore wait) (semaphore_list_head sg)
          (map semaphore_link_node lefts ++ Build_DL_Node newobj (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) :: map semaphore_link_node rights))).
      cancel (store_semaphore wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) newobj -*
        store_dll (store_semaphore wait) (semaphore_list_head sg)
          (map semaphore_link_node lefts ++ Build_DL_Node newobj (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) :: map semaphore_link_node rights)).
      unfold store_semaphore. cbn [newobj semaphore_addr semaphore_value semaphore_pending_addrs].
      split_pure_spatial; [sepcon_assoc_change; cancel|dump_pre_spatial; exact Hobj].
    - dump_pre_spatial; exact Hcontext. }

  assert (Hpure : forall sg st task desc lefts rights obj newwaiting,
    os_world_wf sg st -> task_world_wf st -> os_semaphores st = lefts ++ obj::rights ->
    task_desc_map (os_tasks st) task = Some desc -> tsmStat (tdSchedMember desc) = TSK_SUSPEND ->
    In task (sched_owned_tasks (os_tasks st)) -> ktask_not_os_service task st ->
    Permutation newwaiting (task::semaphore_pending_addrs obj) ->
    let after := replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
      (replace_semaphores (lefts ++ {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
        semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}::rights) st) in
    task_world_wf after /\ os_world_wf sg after).
  { clear. intros sg st task desc lefts rights obj newwaiting Hw Htw Hsems Hlookup Hstatus Howned Hnotservice Hnewperm.
    set (after := replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
      (replace_semaphores (lefts ++ {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
        semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}::rights) st)).
    assert (Hslot : forall entry slot, service_phase slot <> ServiceRegistered task ->
      service_slot_wf st entry slot -> service_slot_wf after entry slot).
    { intros entry slot Hneq Hslot. unfold service_slot_wf in *.
      destruct (service_phase slot) as [| |service] eqn:Hphase; try exact Hslot.
      destruct Hslot as [sd Hsd]. exists sd. destruct Hsd as [Hl He Hd Ho Hi].
      constructor; try assumption.
      intros Hnonready. change (In service (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))).
      apply in_in_remove; [congruence|apply Ho; exact Hnonready]. }
    assert (Htwafter : task_world_wf after).
    { constructor.
      - exact (task_wf_map_present st Htw).
      - intros t d Hmap Hinit. change (task_desc_map (os_tasks st) t = Some d) in Hmap.
        change (In t (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))).
        apply in_in_remove.
        + intro Heq. subst t. rewrite Hlookup in Hmap. inversion Hmap; subst d.
          destruct Hinit; congruence.
        + eapply task_wf_init_running_owned; eauto.
      - exact (task_wf_id_nodes st Htw).
      - exact (task_wf_priority st Htw).
      - exact (task_wf_aligned st Htw).
      - exact (task_wf_running_bitmap st Htw).
      - exact (task_wf_init_close_bitmap st Htw). }
    assert (Hownednd : NoDup (sched_owned_tasks (os_tasks st))).
    { pose proof (os_wf_sched_nodup sg st Hw) as Hnd. unfold os_sched_owners in Hnd.
      exact (NoDup_app_remove_r _ _ Hnd). }
    destruct (in_split task _ Howned) as [ol [orr Ho]].
    pose proof (NoDup_remove_2 ol orr task ltac:(rewrite <- Ho; exact Hownednd)) as Hnot.
    assert (Hremove : remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) = ol ++ orr).
    { rewrite Ho, remove_app, remove_cons.
      rewrite !notin_remove; [reflexivity|intro Hi; apply Hnot; apply in_or_app; right; exact Hi|intro Hi; apply Hnot; apply in_or_app; left; exact Hi]. }
    assert (Hownedperm : Permutation (task :: remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
      (sched_owned_tasks (os_tasks st))).
    { rewrite Hremove, Ho. apply Permutation_middle. }
    assert (Howners : Permutation (os_sched_owners after) (os_sched_owners st)).
    { unfold os_sched_owners, after. cbn [replace_sched_owned_tasks replace_semaphores os_tasks sched_owned_tasks
        os_assign zombie_queue os_semaphores os_mutexes os_events].
      unfold semaphore_waiters. rewrite Hsems, !map_app, !concat_app.
      cbn [map List.concat semaphore_pending_addrs].
      set (pre := map (@getData addr) (os_ready_nodes (orvBuckets (assignReadyVector (os_assign st)))) ++
        map (@getData addr) (zombie_nodes (zombie_queue st)) ++ List.concat (map semaphore_pending_addrs lefts)).
      set (post := List.concat (map semaphore_pending_addrs rights) ++ mutex_waiters (os_mutexes st) ++ event_waiters (os_events st)).
      change (Permutation
        (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++
         map (@getData addr) (os_ready_nodes (orvBuckets (assignReadyVector (os_assign st)))) ++
         map (@getData addr) (zombie_nodes (zombie_queue st)) ++
         ((List.concat (map semaphore_pending_addrs lefts) ++ newwaiting ++ List.concat (map semaphore_pending_addrs rights))) ++
         mutex_waiters (os_mutexes st) ++ event_waiters (os_events st))
        (sched_owned_tasks (os_tasks st) ++
         map (@getData addr) (os_ready_nodes (orvBuckets (assignReadyVector (os_assign st)))) ++
         map (@getData addr) (zombie_nodes (zombie_queue st)) ++
         ((List.concat (map semaphore_pending_addrs lefts) ++ semaphore_pending_addrs obj ++ List.concat (map semaphore_pending_addrs rights))) ++
         mutex_waiters (os_mutexes st) ++ event_waiters (os_events st))).
      replace (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++ _)%list
        with (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++ pre ++ newwaiting ++ post)%list
        by (unfold pre, post; repeat rewrite <- app_assoc; reflexivity).
      replace (sched_owned_tasks (os_tasks st) ++ _)%list
        with (sched_owned_tasks (os_tasks st) ++ pre ++ semaphore_pending_addrs obj ++ post)%list
        by (unfold pre, post; repeat rewrite <- app_assoc; reflexivity).
      eapply Permutation_trans with
        (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++ pre ++ task :: semaphore_pending_addrs obj ++ post).
      - apply Permutation_app_head. apply Permutation_app_head.
        change (Permutation (newwaiting ++ post) ((task::semaphore_pending_addrs obj) ++ post)).
        apply Permutation_app_tail. exact Hnewperm.
      - eapply Permutation_trans with
          ((task::remove Z.eq_dec task (sched_owned_tasks (os_tasks st))) ++ pre ++ semaphore_pending_addrs obj ++ post).
        + rewrite (app_assoc _ pre (task :: semaphore_pending_addrs obj ++ post)).
          apply Permutation_sym.
          replace ((task::remove Z.eq_dec task (sched_owned_tasks (os_tasks st))) ++ pre ++ semaphore_pending_addrs obj ++ post)
            with (task :: (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++ pre) ++ (semaphore_pending_addrs obj ++ post))
            by (repeat rewrite <- app_assoc; reflexivity).
          apply Permutation_middle.
        + apply Permutation_app_tail. exact Hownedperm. }
    split; [exact Htwafter|]. constructor.
    - exact (os_wf_context sg st Hw).
    - change (service_slot_wf after (os_recycler_entry sg) (os_recycle st)).
      apply Hslot; [exact (proj1 Hnotservice)|exact (os_wf_recycler sg st Hw)].
    - change (Forall (service_slot_wf after (os_idle_entry sg)) (os_idle st)).
      apply Forall_forall. intros slot Hin.
      apply Hslot.
      + apply (proj1 (Forall_forall _ _) (proj2 Hnotservice) slot Hin).
      + apply (proj1 (Forall_forall _ _) (os_wf_idle sg st Hw) slot Hin).
    - eapply Permutation_NoDup; [apply Permutation_sym; exact Howners|exact (os_wf_sched_nodup sg st Hw)].
    - intro t. change (In t (os_sched_owners after) <-> task_desc_map (os_tasks st) t <> None).
      rewrite <- (os_wf_sched_domain sg st Hw t). split; intro Hin.
      + eapply Permutation_in; [exact Howners|exact Hin].
      + eapply Permutation_in; [apply Permutation_sym; exact Howners|exact Hin]. }
  assert (Havoid : forall (A:Type) (storeA:Z -> A -> Assertion) (l:list (DL_Node A)) x px y py t v,
    dllseg storeA x px y py l ** &(t # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> v
    |-- “ ~ In t (map (@getPtr A) l) ”).
  { clear. intros A storeA l; induction l as [|a rest IH]; intros x px y py t v.
    - unfold dllseg. Intros_p Heq. dump_pre_spatial. simpl; tauto.
    - unfold dllseg at 1. fold (@dllseg A storeA). Intros z. subst x. fold (@dllseg A storeA).
      destruct (Z.eq_dec (getPtr a) t) as [Heq|Hneq].
      + rewrite Heq. sep_apply_l_atomic (dup_store_ptr (&(t # "SysDoubleLinklistNode" ->ₛ "node_next")) z v).
        Intros_p Hfalse. contradiction.
      + change (storeA (getPtr a) (getData a) **
          (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
          (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
          (dllseg storeA z (getPtr a) y py rest **
           &(t # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> v)))
          |-- “ ~ In t (map (@getPtr A) (a::rest)) ”).
        sep_apply_l_atomic (IH z (getPtr a) y py t v). Intros_p Hrest.
        dump_pre_spatial. simpl; intuition congruence. }
  assert (Hnodup : forall (A:Type) (storeA:Z -> A -> Assertion) (l:list (DL_Node A)) x px y py,
    dllseg storeA x px y py l |-- “ NoDup (map (@getPtr A) l) ”).
  { clear - Havoid. intros A storeA l; induction l as [|a rest IH]; intros x px y py.
    - unfold dllseg. Intros_p Heq. dump_pre_spatial. constructor.
    - unfold dllseg at 1. fold (@dllseg A storeA). Intros z. subst x. fold (@dllseg A storeA).
      change (storeA (getPtr a) (getData a) **
        (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
        (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
        dllseg storeA z (getPtr a) y py rest))
        |-- “ NoDup (map (@getPtr A) (a::rest)) ”).
      prop_apply_p (Havoid A storeA rest z (getPtr a) y py (getPtr a) z). Intros_p Hnot.
      prop_apply_p (IH z (getPtr a) y py). Intros_p Hrest.
      dump_pre_spatial. simpl. constructor; assumption. }
  assert (Hdll : forall (A:Type) (storeA:Z -> A -> Assertion) h (l:list (DL_Node A)),
    store_dll storeA h l |-- “ NoDup (map (@getPtr A) l) /\ ~ In h (map (@getPtr A) l) ”).
  { clear - Havoid Hnodup. intros A storeA h l. unfold store_dll. Intros hd pt.
    change (&(h # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> pt **
      (&(h # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> hd **
      dllseg storeA hd h h pt l) |-- “ NoDup (map (@getPtr A) l) /\ ~ In h (map (@getPtr A) l) ”).
    prop_apply_p (Havoid A storeA l hd h h pt h hd). Intros_p Hnot.
    prop_apply_p (Hnodup A storeA l hd h h pt). Intros_p Hnd.
    dump_pre_spatial. auto. }

  assert (HsemND : forall wait sg ss,
    semaphore_inv wait sg ss |-- “ NoDup (map semaphore_addr ss) ”).
  { clear - Hdll. intros wait sg ss. unfold semaphore_inv. Intros_p Hctx.
    prop_apply_p (Hdll SemaphoreAbs (store_semaphore wait) (semaphore_list_head sg) (map semaphore_link_node ss)).
    Intros_p Hnd. dump_pre_spatial. destruct Hnd as [Hnd _].
    assert (Heq : map (@getPtr SemaphoreAbs) (map semaphore_link_node ss) =
      map (fun p:Z => &(p # "Semaphore" ->ₛ "link")) (map semaphore_addr ss)).
    { rewrite !map_map. reflexivity. }
    rewrite Heq in Hnd. eapply NoDup_map_inv; exact Hnd. }
  assert (Hprep : forall sg st sem task desc waiting newwaiting,
    semaphore_pending_nodes sem st (map sched_link_node waiting) ->
    task_desc_map (os_tasks st) task = Some desc -> tsmStat (tdSchedMember desc) = TSK_SUSPEND ->
    In task (sched_owned_tasks (os_tasks st)) -> ktask_not_os_service task st ->
    Permutation newwaiting (task::waiting) ->
    os_inv sg st |-- “ sched_link_of task <> 0 ” &&
      store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st))) (semaphore_pending_head sem) (map sched_link_node waiting) **
      pure_suspend_sched_link (task_desc_map (os_tasks st)) (sched_link_of task) task **
      occupy_dll_node (sched_link_of task) **
      (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st))) (semaphore_pending_head sem) (map sched_link_node newwaiting) -*
       os_inv sg (replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
          (semaphore_enqueue_state sem newwaiting st)))).
  { clear - Hownedcut Hsemcut Hpure HsemND.
    intros sg st sem task desc waiting newwaiting Hpending Hlookup Hstatus Howned Hnotservice Hnewperm.
    destruct Hpending as [obj [Hin [Haddr Hwaiting]]].
    assert (Hwait : semaphore_pending_addrs obj = waiting).
    { apply (f_equal (map (@getData Z))) in Hwaiting. rewrite !map_map in Hwaiting.
      change (map (fun x:Z => x) (semaphore_pending_addrs obj) = map (fun x:Z => x) waiting) in Hwaiting.
      rewrite !map_id in Hwaiting. exact Hwaiting. }
    destruct (in_split obj _ Hin) as [lefts [rights Hss]].
    set (newobj := {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
       semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}).
    set (after := replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
      (replace_semaphores (lefts ++ newobj::rights) st)).
    remember (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st))) (semaphore_pending_head sem) (map sched_link_node newwaiting) -*
       os_inv sg (replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
          (semaphore_enqueue_state sem newwaiting st))) as W eqn:HW.
    unfold os_inv at 1. Intros_p Hworld.
    prop_apply_p (HsemND (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_semaphore_stable sg) (os_semaphores st)). Intros_p Hunique.
    unfold task_inv at 1. Intros_p Htask.
    assert (Hsemupdate : semaphore_enqueue_state sem newwaiting st = replace_semaphores (lefts ++ newobj::rights) st).
    { unfold semaphore_enqueue_state. f_equal.
      rewrite Hss, map_app. cbn [map].
      destruct (Z.eq_dec (semaphore_addr obj) sem) as [Heq|Hneq]; [|contradiction].
      assert (Hnot : ~ In sem (map semaphore_addr lefts ++ map semaphore_addr rights)).
      { rewrite Hss, map_app in Hunique. cbn [map] in Hunique. rewrite Haddr in Hunique.
        exact (NoDup_remove_2 _ _ _ Hunique). }
      assert (Hident : forall xs, ~ In sem (map semaphore_addr xs) ->
        map (fun s => if Z.eq_dec (semaphore_addr s) sem then
          {| semaphore_addr:=semaphore_addr s; semaphore_id:=semaphore_id s; semaphore_value:=semaphore_value s;
             semaphore_pending_addrs:=newwaiting |} else s) xs = xs).
      { intros xs Hnotin. rewrite <- (map_id xs) at 2. apply map_ext_in. intros s Hmem.
        destruct (Z.eq_dec (semaphore_addr s) sem); [exfalso;apply Hnotin; rewrite <- e;apply in_map;exact Hmem|reflexivity]. }
      rewrite !Hident; [reflexivity|intro Hi;apply Hnot;apply in_or_app;right;exact Hi|intro Hi;apply Hnot;apply in_or_app;left;exact Hi]. }
    assert (Hownednd : NoDup (sched_owned_tasks (os_tasks st))).
    { pose proof (os_wf_sched_nodup sg st Hworld) as Hnd. unfold os_sched_owners in Hnd.
      exact (NoDup_app_remove_r _ _ Hnd). }
    assert (Hnewpermobj : Permutation newwaiting (task::semaphore_pending_addrs obj)) by (rewrite Hwait; exact Hnewperm).
    pose proof (Hpure sg st task desc lefts rights obj newwaiting Hworld Htask Hss Hlookup Hstatus Howned Hnotservice Hnewpermobj) as [Htaskafter Hworldafter].
    assert (Hnzero : store_map store_published_task (task_desc_map (os_tasks st)) |-- “ sched_link_of task <> 0 ”).
    { sep_apply_l_atomic (store_map_split store_published_task task desc (task_desc_map (os_tasks st)) Hlookup).
      unfold store_published_task, store_task_descriptor. Intros.
      prop_apply_p (valid_store_ptr (&(task # "TaskDescriptor" ->ₛ "stack_point")) (tdStackPoint desc)). Intros_p Hv.
      dump_pre_spatial.
      pose proof (task_descriptor_field_offset_axiom task (task_wf_aligned st Htask task desc Hlookup)) as Hl.
      unfold ktask_descriptor_field_offset_ok in Hl.
      assert (Hstack : &(task # "TaskDescriptor" ->ₛ "stack_point") = task + 0) by tauto.
      assert (Hlink : sched_link_of task = task + 16) by (unfold sched_link_of; tauto).
      unfold valid_object, valid_addr_range in Hv. rewrite Hstack in Hv. rewrite Hlink. intuition lia. }
    prop_apply_p Hnzero. Intros_p Hlinknz.
    assert (Hqueues : dataqueue_inv (lefts ++ obj::rights) (os_dataqueues st) |-- dataqueue_inv (lefts ++ newobj::rights) (os_dataqueues st)).
    { unfold dataqueue_inv. Intros_p Hq.
      split_pure_spatial; [cancel|]. dump_pre_spatial. intros p q Hmap.
      destruct (Hq p q Hmap) as [Hr [Hb Hd]]. split; [exact Hr|].
      assert (Hmove : forall id, (exists s, In s (lefts ++ obj::rights) /\ semaphore_id s = id) ->
          exists s, In s (lefts ++ newobj::rights) /\ semaphore_id s = id).
      { intros id [s [Hs Hid]]. apply in_app_iff in Hs. destruct Hs as [Hs|[Hs|Hs]].
        - exists s. split; [apply in_or_app;left;exact Hs|exact Hid].
        - subst s. exists newobj. split; [apply in_or_app;right;left;reflexivity|exact Hid].
        - exists s. split; [apply in_or_app;right;right;exact Hs|exact Hid]. }
      split; apply Hmove; assumption. }
    rewrite Hss.
    sep_apply_l_atomic (Hownedcut (task_desc_map (os_tasks st)) (sched_owned_tasks (os_tasks st)) task Hownednd Howned).
    sep_apply_l_atomic (Hsemcut (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_semaphore_stable sg) lefts rights obj newwaiting).
    unfold store_detached_sched_link at 1. Intros actual.
    sep_apply_l_atomic (store_node_self_linked_occupy (sched_link_of task)).
    change (map semaphore_wait_node (semaphore_pending_addrs obj)) with (map sched_link_node (semaphore_pending_addrs obj)).
    rewrite Hwait. unfold semaphore_pending_head. rewrite <- Haddr.
    split_pure_spatial.
    - sep_apply_r_atomic (pure_suspend_sched_link_close (task_desc_map (os_tasks st)) (sched_link_of task) task desc Hlookup eq_refl Hstatus).
      cancel (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st)))
        (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list")) (map sched_link_node waiting)).
      cancel (occupy_dll_node (sched_link_of task)).
      subst W. rewrite Hsemupdate. change (replace_sched_owned_tasks _ (replace_semaphores _ st)) with after.
      asrt_simpl. apply_sepcon_adjoint.
      change (map sched_link_node newwaiting) with (map semaphore_wait_node newwaiting).
      unfold semaphore_pending_head. rewrite <- Haddr. fold newobj.
      sep_apply_l_atomic (derivable1_wand_elim1
        (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st)))
          (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list")) (map semaphore_wait_node newwaiting))
        (semaphore_inv (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_semaphore_stable sg) (lefts ++ newobj::rights))).
      sep_apply_l_atomic Hqueues.
      unfold os_inv, task_inv. cbn [after replace_sched_owned_tasks replace_semaphores].
      split_pure_spatial.
      + change (os_tasks after) with
          ({| task_desc_map := task_desc_map (os_tasks st); task_ptr_list := task_ptr_list (os_tasks st);
              task_idmanager_abs := task_idmanager_abs (os_tasks st);
              sched_owned_tasks := remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) |}).
        change (tick_inv sg after) with (tick_inv sg st).
        change (delay_inv sg after) with (delay_inv sg st).
        change (assign_inv sg after) with (assign_inv sg st).
        change (exstatus_inv sg after) with (exstatus_inv sg st).
        change (zombie_queue after) with (zombie_queue st).
        change (os_recycle after) with (os_recycle st).
        change (os_idle after) with (os_idle st).
        change (os_isr after) with (os_isr st).
        change (os_semaphores after) with (lefts ++ newobj::rights).
        change (os_mutexes after) with (os_mutexes st).
        change (os_events after) with (os_events st).
        change (os_dataqueues after) with (os_dataqueues st).
        cbv beta iota zeta delta [task_idmanager_abs task_ptr_list task_desc_map sched_owned_tasks].
        sepcon_assoc_change; cancel.
      + split_pures; dump_pre_spatial; assumption.
    - dump_pre_spatial; exact Hlinknz. }

  rewrite PreH2.
  assert (Hrestore : forall A B C Q : Assertion,
      B ** A ** C ** ((A ** (B ** C)) -* Q) |-- Q).
  { clear. intros A B C Q.
    sep_apply_r_atomic (derivable1_wand_elim1 (A ** (B ** C)) Q).
    sepcon_assoc_change. cancel A. cancel B. cancel C. cancel. }
  sepcon_assoc_change.
  match goal with |- context [wand (?A ** (?B ** ?C)) (os_inv sg_semaphore_ic staged)] =>
    pose proof (Hrestore A B C (os_inv sg_semaphore_ic staged)) as Hrestore_now
  end.
  sepcon_assoc_change_in Hrestore_now.
  rewrite Hrestore_now.
  set (newwaiting := prefix_loop ++ task_pre::current_task::rest_tasks_2).
  set (newnodes := map sched_link_node newwaiting).
  set (after := replace_sched_owned_tasks (remove Z.eq_dec task_pre (sched_owned_tasks (os_tasks staged)))
    (semaphore_enqueue_state sem_semaphore_ic newwaiting staged)).
  assert (Hpriority : linklist_priority_insert (task_desc_map (os_tasks staged)) task_pre
      (map sched_link_node waiting_semaphore_ic) newnodes).
  { exists desc, (map sched_link_node prefix_loop), (map sched_link_node (current_task::rest_tasks_2)).
    split; [exact PreH11|]. split; [rewrite PreH15, map_app; reflexivity|].
    split; [unfold newnodes, newwaiting; rewrite map_app; reflexivity|]. split.
    - apply Forall_forall. intros n Hin. apply in_map_iff in Hin.
      destruct Hin as [a [<- Hin]]. apply PreH16; exact Hin.
    - simpl. exists current_desc; split; [exact PreH20|lia]. }
  assert (Hperm : Permutation newwaiting (task_pre::waiting_semaphore_ic)).
  { unfold newwaiting. rewrite PreH15. apply Permutation_sym. apply Permutation_middle. }
  assert (Henqueue : linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after).
  { destruct PreH10 as [obj [Hin [Haddr Hnodes]]].
    exists obj, desc, newnodes. repeat split; try assumption.
    - right. split; [reflexivity|]. rewrite Hnodes. exact Hpriority.
    - unfold after, newnodes. rewrite map_map.
      change (map (fun x:Z => x) newwaiting) with (map (@id Z) newwaiting).
      rewrite map_id. reflexivity. }
  sep_apply_l_atomic (Hprep sg_semaphore_ic staged sem_semaphore_ic task_pre desc waiting_semaphore_ic newwaiting
     PreH10 PreH11 PreH12 PreH13 PreH14 Hperm).
  Intros_p Hnz.
  prop_apply_p (Hdll Z (pure_suspend_sched_link (task_desc_map (os_tasks staged)))
     (semaphore_pending_head sem_semaphore_ic) (map sched_link_node waiting_semaphore_ic)).
  Intros_p Hnodeswf.
  assert (Hdispatch : dll_insert_before_dispatch list_pre (map sched_link_node waiting_semaphore_ic)
      (sched_link_of current_task) (sched_link_node task_pre) = newnodes).
  { unfold dll_insert_before_dispatch.
    destruct (Z.eq_dec (sched_link_of current_task) list_pre); [congruence|].
    destruct Hnodeswf as [Hnd Hsent]. rewrite PreH15 in Hnd |- *.
    unfold newnodes, newwaiting. rewrite !map_app in *.
    clear - Hnd. induction prefix_loop as [|a prefix IH].
    - simpl. destruct (Z.eq_dec (sched_link_of current_task) (sched_link_of current_task)); congruence.
    - simpl in Hnd |- *. inversion Hnd as [|x xs Hnot Htail]; subst.
      destruct (Z.eq_dec (sched_link_of a) (sched_link_of current_task)) as [Heq|Hne].
      + exfalso. apply Hnot. apply in_or_app; right. simpl. left; congruence.
      + f_equal. apply IH. exact Htail. }
  assert (Hanchor : dll_insert_anchor list_pre (map sched_link_node waiting_semaphore_ic) (sched_link_of current_task)).
  { left. rewrite PreH15, map_app, map_app. apply in_or_app; right. simpl; auto. }
  Exists rest_tasks_2 after newnodes prefix_loop (current_task::rest_tasks_2).
  split_pure_spatial.
  - unfold after, newnodes. rewrite PreH9. unfold sched_link_of. sepcon_assoc_change; cancel.
    match goal with |- ?P |-- _ => change (P |-- P); cancel P end.
  - split_pures; dump_pre_spatial; try assumption; try reflexivity; try congruence;
      try (unfold newnodes, newwaiting; reflexivity).
    intros _. split; [exact Hanchor|exact Hdispatch].
Qed.


Lemma proof_of_LinklistSuspend_entail_wit_7_4 : LinklistSuspend_entail_wit_7_4.
Proof.
LLM_pre_process ltac:(lia || int_auto).
  assert (Hcut : forall (A:Type) (storeA:Z -> A -> Assertion) head prefix suffix ptr (data newdata:A),
    store_dll storeA head (prefix ++ Build_DL_Node data ptr :: suffix)
    |-- storeA ptr data **
      (storeA ptr newdata -* store_dll storeA head (prefix ++ Build_DL_Node newdata ptr :: suffix))).
  { clear. intros A storeA head prefix suffix ptr data newdata.
    remember (storeA ptr newdata -* store_dll storeA head (prefix ++ Build_DL_Node newdata ptr :: suffix)) as W eqn:HW.
    unfold store_dll at 1. Intros hd pt.
    sep_apply_l_atomic (@dllseg_split A storeA hd head head pt prefix (Build_DL_Node data ptr :: suffix)).
    Intros cut beforeptr.
    cbn [dllseg]. Intros nxt. subst cut.
    fold (@dllseg A storeA).
    sepcon_assoc_change.
    cancel (storeA ptr data). subst W. apply_sepcon_adjoint.
    unfold store_dll at 1. Exists hd pt.
    split_pure_spatial.
    - cbn [getPtr getData].
      change ((&(ptr # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> beforeptr **
        (&(ptr # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> nxt **
        (dllseg storeA nxt ptr head pt suffix **
        (&(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> pt **
        (&(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> hd **
        dllseg storeA hd head ptr beforeptr prefix))))) ** storeA ptr newdata
        |-- &(head # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> pt **
            &(head # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> hd **
            dllseg storeA hd head head pt (prefix ++ Build_DL_Node newdata ptr :: suffix)).
      sep_apply_l_atomic (dllseg_head_insert A storeA beforeptr ptr nxt head pt newdata suffix).
      sep_apply_l_atomic (@dllseg_concat A storeA hd head ptr beforeptr head pt prefix (Build_DL_Node newdata ptr :: suffix)).
      sepcon_assoc_change; cancel.
    - dump_pre_spatial.
      destruct H as [Hhead [Hpt [Hhd Hnodes]]].
      repeat split; try assumption.
      unfold dll_nodes_nonzero in *. rewrite Forall_app in *.
      destruct Hnodes as [Hp Hs]. split; [exact Hp|]. inversion Hs; subst. constructor; assumption.
  }
  assert (Hownedcut : forall T owned task,
    NoDup owned -> In task owned ->
    store_owned_sched_nodes T owned |--
      store_detached_sched_link T task ** store_owned_sched_nodes T (remove Z.eq_dec task owned)).
  { clear. intros T owned task Hnd Hin.
    destruct (in_split task owned Hin) as [lefts [rights Heq]]. subst owned.
    pose proof (NoDup_remove_2 lefts rights task Hnd) as Hnot.
    assert (Hrem : forall xs, ~ In task xs -> remove Z.eq_dec task xs = xs).
    { intros xs Habs. exact (notin_remove Z.eq_dec xs task Habs). }
    assert (Hr : remove Z.eq_dec task (lefts ++ task::rights) = lefts ++ rights).
    { rewrite remove_app. cbn. destruct (Z.eq_dec task task); [|contradiction].
      rewrite !Hrem; [reflexivity|intro Hmem; apply Hnot; apply in_or_app; right; exact Hmem|intro Hmem; apply Hnot; apply in_or_app; left; exact Hmem]. }
    rewrite Hr. unfold store_owned_sched_nodes. rewrite !map_app.
    cbn [map]. rewrite !logic_equiv_iter_sepcon_app, logic_equiv_iter_sepcon_cons.
    sepcon_assoc_change; cancel. }
  assert (Hsemcut : forall wait sg lefts rights obj newwaiting,
    semaphore_inv wait sg (lefts ++ obj::rights) |--
      store_dll wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
        (map semaphore_wait_node (semaphore_pending_addrs obj)) **
      (store_dll wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
        (map semaphore_wait_node newwaiting) -*
       semaphore_inv wait sg
        (lefts ++ {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
          semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}::rights))).
  { clear - Hcut. intros wait sg lefts rights obj newwaiting.
    set (newobj := {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
          semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}).
    assert (Hmanager : semaphore_manager (lefts ++ newobj::rights) = semaphore_manager (lefts ++ obj::rights)).
    { unfold semaphore_manager. f_equal.
      - rewrite !map_app. cbn [map newobj semaphore_id]. reflexivity.
      - apply map_ext. intro k. rewrite !filter_app, !map_app.
        cbn [filter newobj semaphore_id]. destruct (Z.eqb (semaphore_id obj mod 16) (Z.of_nat k));
          cbn [map semaphore_idnode newobj semaphore_id semaphore_addr]; reflexivity. }
    remember (store_dll wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
        (map semaphore_wait_node newwaiting) -* semaphore_inv wait sg (lefts ++ newobj::rights)) as W eqn:HW.
    unfold semaphore_inv at 1. Intros_p Hcontext.
    rewrite map_app. cbn [map].
    sep_apply_l_atomic (Hcut SemaphoreAbs (store_semaphore wait) (semaphore_list_head sg)
      (map semaphore_link_node lefts) (map semaphore_link_node rights)
      (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) obj newobj).
    unfold store_semaphore at 1. Intros_p Hobj.
    cancel (store_dll wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list"))
      (map semaphore_wait_node (semaphore_pending_addrs obj))).
    subst W. apply_sepcon_adjoint.
    unfold semaphore_inv at 1. rewrite Hmanager.
    split_pure_spatial.
    - cancel (store_idmanager (semaphore_manager_stable sg) (semaphore_manager (lefts ++ obj::rights)) (semaphore_manager_ptr sg)).
      rewrite map_app. cbn [map semaphore_link_node newobj semaphore_addr].
      sep_apply_r_atomic (derivable1_wand_elim1
        (store_semaphore wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) newobj)
        (store_dll (store_semaphore wait) (semaphore_list_head sg)
          (map semaphore_link_node lefts ++ Build_DL_Node newobj (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) :: map semaphore_link_node rights))).
      cancel (store_semaphore wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) newobj -*
        store_dll (store_semaphore wait) (semaphore_list_head sg)
          (map semaphore_link_node lefts ++ Build_DL_Node newobj (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) :: map semaphore_link_node rights)).
      unfold store_semaphore. cbn [newobj semaphore_addr semaphore_value semaphore_pending_addrs].
      split_pure_spatial; [sepcon_assoc_change; cancel|dump_pre_spatial; exact Hobj].
    - dump_pre_spatial; exact Hcontext. }

  assert (Hpure : forall sg st task desc lefts rights obj newwaiting,
    os_world_wf sg st -> task_world_wf st -> os_semaphores st = lefts ++ obj::rights ->
    task_desc_map (os_tasks st) task = Some desc -> tsmStat (tdSchedMember desc) = TSK_SUSPEND ->
    In task (sched_owned_tasks (os_tasks st)) -> ktask_not_os_service task st ->
    Permutation newwaiting (task::semaphore_pending_addrs obj) ->
    let after := replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
      (replace_semaphores (lefts ++ {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
        semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}::rights) st) in
    task_world_wf after /\ os_world_wf sg after).
  { clear. intros sg st task desc lefts rights obj newwaiting Hw Htw Hsems Hlookup Hstatus Howned Hnotservice Hnewperm.
    set (after := replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
      (replace_semaphores (lefts ++ {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
        semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}::rights) st)).
    assert (Hslot : forall entry slot, service_phase slot <> ServiceRegistered task ->
      service_slot_wf st entry slot -> service_slot_wf after entry slot).
    { intros entry slot Hneq Hslot. unfold service_slot_wf in *.
      destruct (service_phase slot) as [| |service] eqn:Hphase; try exact Hslot.
      destruct Hslot as [sd Hsd]. exists sd. destruct Hsd as [Hl He Hd Ho Hi].
      constructor; try assumption.
      intros Hnonready. change (In service (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))).
      apply in_in_remove; [congruence|apply Ho; exact Hnonready]. }
    assert (Htwafter : task_world_wf after).
    { constructor.
      - exact (task_wf_map_present st Htw).
      - intros t d Hmap Hinit. change (task_desc_map (os_tasks st) t = Some d) in Hmap.
        change (In t (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))).
        apply in_in_remove.
        + intro Heq. subst t. rewrite Hlookup in Hmap. inversion Hmap; subst d.
          destruct Hinit; congruence.
        + eapply task_wf_init_running_owned; eauto.
      - exact (task_wf_id_nodes st Htw).
      - exact (task_wf_priority st Htw).
      - exact (task_wf_aligned st Htw).
      - exact (task_wf_running_bitmap st Htw).
      - exact (task_wf_init_close_bitmap st Htw). }
    assert (Hownednd : NoDup (sched_owned_tasks (os_tasks st))).
    { pose proof (os_wf_sched_nodup sg st Hw) as Hnd. unfold os_sched_owners in Hnd.
      exact (NoDup_app_remove_r _ _ Hnd). }
    destruct (in_split task _ Howned) as [ol [orr Ho]].
    pose proof (NoDup_remove_2 ol orr task ltac:(rewrite <- Ho; exact Hownednd)) as Hnot.
    assert (Hremove : remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) = ol ++ orr).
    { rewrite Ho, remove_app, remove_cons.
      rewrite !notin_remove; [reflexivity|intro Hi; apply Hnot; apply in_or_app; right; exact Hi|intro Hi; apply Hnot; apply in_or_app; left; exact Hi]. }
    assert (Hownedperm : Permutation (task :: remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
      (sched_owned_tasks (os_tasks st))).
    { rewrite Hremove, Ho. apply Permutation_middle. }
    assert (Howners : Permutation (os_sched_owners after) (os_sched_owners st)).
    { unfold os_sched_owners, after. cbn [replace_sched_owned_tasks replace_semaphores os_tasks sched_owned_tasks
        os_assign zombie_queue os_semaphores os_mutexes os_events].
      unfold semaphore_waiters. rewrite Hsems, !map_app, !concat_app.
      cbn [map List.concat semaphore_pending_addrs].
      set (pre := map (@getData addr) (os_ready_nodes (orvBuckets (assignReadyVector (os_assign st)))) ++
        map (@getData addr) (zombie_nodes (zombie_queue st)) ++ List.concat (map semaphore_pending_addrs lefts)).
      set (post := List.concat (map semaphore_pending_addrs rights) ++ mutex_waiters (os_mutexes st) ++ event_waiters (os_events st)).
      change (Permutation
        (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++
         map (@getData addr) (os_ready_nodes (orvBuckets (assignReadyVector (os_assign st)))) ++
         map (@getData addr) (zombie_nodes (zombie_queue st)) ++
         ((List.concat (map semaphore_pending_addrs lefts) ++ newwaiting ++ List.concat (map semaphore_pending_addrs rights))) ++
         mutex_waiters (os_mutexes st) ++ event_waiters (os_events st))
        (sched_owned_tasks (os_tasks st) ++
         map (@getData addr) (os_ready_nodes (orvBuckets (assignReadyVector (os_assign st)))) ++
         map (@getData addr) (zombie_nodes (zombie_queue st)) ++
         ((List.concat (map semaphore_pending_addrs lefts) ++ semaphore_pending_addrs obj ++ List.concat (map semaphore_pending_addrs rights))) ++
         mutex_waiters (os_mutexes st) ++ event_waiters (os_events st))).
      replace (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++ _)%list
        with (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++ pre ++ newwaiting ++ post)%list
        by (unfold pre, post; repeat rewrite <- app_assoc; reflexivity).
      replace (sched_owned_tasks (os_tasks st) ++ _)%list
        with (sched_owned_tasks (os_tasks st) ++ pre ++ semaphore_pending_addrs obj ++ post)%list
        by (unfold pre, post; repeat rewrite <- app_assoc; reflexivity).
      eapply Permutation_trans with
        (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++ pre ++ task :: semaphore_pending_addrs obj ++ post).
      - apply Permutation_app_head. apply Permutation_app_head.
        change (Permutation (newwaiting ++ post) ((task::semaphore_pending_addrs obj) ++ post)).
        apply Permutation_app_tail. exact Hnewperm.
      - eapply Permutation_trans with
          ((task::remove Z.eq_dec task (sched_owned_tasks (os_tasks st))) ++ pre ++ semaphore_pending_addrs obj ++ post).
        + rewrite (app_assoc _ pre (task :: semaphore_pending_addrs obj ++ post)).
          apply Permutation_sym.
          replace ((task::remove Z.eq_dec task (sched_owned_tasks (os_tasks st))) ++ pre ++ semaphore_pending_addrs obj ++ post)
            with (task :: (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) ++ pre) ++ (semaphore_pending_addrs obj ++ post))
            by (repeat rewrite <- app_assoc; reflexivity).
          apply Permutation_middle.
        + apply Permutation_app_tail. exact Hownedperm. }
    split; [exact Htwafter|]. constructor.
    - exact (os_wf_context sg st Hw).
    - change (service_slot_wf after (os_recycler_entry sg) (os_recycle st)).
      apply Hslot; [exact (proj1 Hnotservice)|exact (os_wf_recycler sg st Hw)].
    - change (Forall (service_slot_wf after (os_idle_entry sg)) (os_idle st)).
      apply Forall_forall. intros slot Hin.
      apply Hslot.
      + apply (proj1 (Forall_forall _ _) (proj2 Hnotservice) slot Hin).
      + apply (proj1 (Forall_forall _ _) (os_wf_idle sg st Hw) slot Hin).
    - eapply Permutation_NoDup; [apply Permutation_sym; exact Howners|exact (os_wf_sched_nodup sg st Hw)].
    - intro t. change (In t (os_sched_owners after) <-> task_desc_map (os_tasks st) t <> None).
      rewrite <- (os_wf_sched_domain sg st Hw t). split; intro Hin.
      + eapply Permutation_in; [exact Howners|exact Hin].
      + eapply Permutation_in; [apply Permutation_sym; exact Howners|exact Hin]. }
  assert (Havoid : forall (A:Type) (storeA:Z -> A -> Assertion) (l:list (DL_Node A)) x px y py t v,
    dllseg storeA x px y py l ** &(t # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> v
    |-- “ ~ In t (map (@getPtr A) l) ”).
  { clear. intros A storeA l; induction l as [|a rest IH]; intros x px y py t v.
    - unfold dllseg. Intros_p Heq. dump_pre_spatial. simpl; tauto.
    - unfold dllseg at 1. fold (@dllseg A storeA). Intros z. subst x. fold (@dllseg A storeA).
      destruct (Z.eq_dec (getPtr a) t) as [Heq|Hneq].
      + rewrite Heq. sep_apply_l_atomic (dup_store_ptr (&(t # "SysDoubleLinklistNode" ->ₛ "node_next")) z v).
        Intros_p Hfalse. contradiction.
      + change (storeA (getPtr a) (getData a) **
          (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
          (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
          (dllseg storeA z (getPtr a) y py rest **
           &(t # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> v)))
          |-- “ ~ In t (map (@getPtr A) (a::rest)) ”).
        sep_apply_l_atomic (IH z (getPtr a) y py t v). Intros_p Hrest.
        dump_pre_spatial. simpl; intuition congruence. }
  assert (Hnodup : forall (A:Type) (storeA:Z -> A -> Assertion) (l:list (DL_Node A)) x px y py,
    dllseg storeA x px y py l |-- “ NoDup (map (@getPtr A) l) ”).
  { clear - Havoid. intros A storeA l; induction l as [|a rest IH]; intros x px y py.
    - unfold dllseg. Intros_p Heq. dump_pre_spatial. constructor.
    - unfold dllseg at 1. fold (@dllseg A storeA). Intros z. subst x. fold (@dllseg A storeA).
      change (storeA (getPtr a) (getData a) **
        (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
        (&(((getPtr a)) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
        dllseg storeA z (getPtr a) y py rest))
        |-- “ NoDup (map (@getPtr A) (a::rest)) ”).
      prop_apply_p (Havoid A storeA rest z (getPtr a) y py (getPtr a) z). Intros_p Hnot.
      prop_apply_p (IH z (getPtr a) y py). Intros_p Hrest.
      dump_pre_spatial. simpl. constructor; assumption. }
  assert (Hdll : forall (A:Type) (storeA:Z -> A -> Assertion) h (l:list (DL_Node A)),
    store_dll storeA h l |-- “ NoDup (map (@getPtr A) l) /\ ~ In h (map (@getPtr A) l) ”).
  { clear - Havoid Hnodup. intros A storeA h l. unfold store_dll. Intros hd pt.
    change (&(h # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> pt **
      (&(h # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> hd **
      dllseg storeA hd h h pt l) |-- “ NoDup (map (@getPtr A) l) /\ ~ In h (map (@getPtr A) l) ”).
    prop_apply_p (Havoid A storeA l hd h h pt h hd). Intros_p Hnot.
    prop_apply_p (Hnodup A storeA l hd h h pt). Intros_p Hnd.
    dump_pre_spatial. auto. }

  assert (HsemND : forall wait sg ss,
    semaphore_inv wait sg ss |-- “ NoDup (map semaphore_addr ss) ”).
  { clear - Hdll. intros wait sg ss. unfold semaphore_inv. Intros_p Hctx.
    prop_apply_p (Hdll SemaphoreAbs (store_semaphore wait) (semaphore_list_head sg) (map semaphore_link_node ss)).
    Intros_p Hnd. dump_pre_spatial. destruct Hnd as [Hnd _].
    assert (Heq : map (@getPtr SemaphoreAbs) (map semaphore_link_node ss) =
      map (fun p:Z => &(p # "Semaphore" ->ₛ "link")) (map semaphore_addr ss)).
    { rewrite !map_map. reflexivity. }
    rewrite Heq in Hnd. eapply NoDup_map_inv; exact Hnd. }
  assert (Hprep : forall sg st sem task desc waiting newwaiting,
    semaphore_pending_nodes sem st (map sched_link_node waiting) ->
    task_desc_map (os_tasks st) task = Some desc -> tsmStat (tdSchedMember desc) = TSK_SUSPEND ->
    In task (sched_owned_tasks (os_tasks st)) -> ktask_not_os_service task st ->
    Permutation newwaiting (task::waiting) ->
    os_inv sg st |-- “ sched_link_of task <> 0 ” &&
      store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st))) (semaphore_pending_head sem) (map sched_link_node waiting) **
      pure_suspend_sched_link (task_desc_map (os_tasks st)) (sched_link_of task) task **
      occupy_dll_node (sched_link_of task) **
      (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st))) (semaphore_pending_head sem) (map sched_link_node newwaiting) -*
       os_inv sg (replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
          (semaphore_enqueue_state sem newwaiting st)))).
  { clear - Hownedcut Hsemcut Hpure HsemND.
    intros sg st sem task desc waiting newwaiting Hpending Hlookup Hstatus Howned Hnotservice Hnewperm.
    destruct Hpending as [obj [Hin [Haddr Hwaiting]]].
    assert (Hwait : semaphore_pending_addrs obj = waiting).
    { apply (f_equal (map (@getData Z))) in Hwaiting. rewrite !map_map in Hwaiting.
      change (map (fun x:Z => x) (semaphore_pending_addrs obj) = map (fun x:Z => x) waiting) in Hwaiting.
      rewrite !map_id in Hwaiting. exact Hwaiting. }
    destruct (in_split obj _ Hin) as [lefts [rights Hss]].
    set (newobj := {| semaphore_addr:=semaphore_addr obj; semaphore_id:=semaphore_id obj;
       semaphore_value:=semaphore_value obj; semaphore_pending_addrs:=newwaiting |}).
    set (after := replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
      (replace_semaphores (lefts ++ newobj::rights) st)).
    remember (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st))) (semaphore_pending_head sem) (map sched_link_node newwaiting) -*
       os_inv sg (replace_sched_owned_tasks (remove Z.eq_dec task (sched_owned_tasks (os_tasks st)))
          (semaphore_enqueue_state sem newwaiting st))) as W eqn:HW.
    unfold os_inv at 1. Intros_p Hworld.
    prop_apply_p (HsemND (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_semaphore_stable sg) (os_semaphores st)). Intros_p Hunique.
    unfold task_inv at 1. Intros_p Htask.
    assert (Hsemupdate : semaphore_enqueue_state sem newwaiting st = replace_semaphores (lefts ++ newobj::rights) st).
    { unfold semaphore_enqueue_state. f_equal.
      rewrite Hss, map_app. cbn [map].
      destruct (Z.eq_dec (semaphore_addr obj) sem) as [Heq|Hneq]; [|contradiction].
      assert (Hnot : ~ In sem (map semaphore_addr lefts ++ map semaphore_addr rights)).
      { rewrite Hss, map_app in Hunique. cbn [map] in Hunique. rewrite Haddr in Hunique.
        exact (NoDup_remove_2 _ _ _ Hunique). }
      assert (Hident : forall xs, ~ In sem (map semaphore_addr xs) ->
        map (fun s => if Z.eq_dec (semaphore_addr s) sem then
          {| semaphore_addr:=semaphore_addr s; semaphore_id:=semaphore_id s; semaphore_value:=semaphore_value s;
             semaphore_pending_addrs:=newwaiting |} else s) xs = xs).
      { intros xs Hnotin. rewrite <- (map_id xs) at 2. apply map_ext_in. intros s Hmem.
        destruct (Z.eq_dec (semaphore_addr s) sem); [exfalso;apply Hnotin; rewrite <- e;apply in_map;exact Hmem|reflexivity]. }
      rewrite !Hident; [reflexivity|intro Hi;apply Hnot;apply in_or_app;right;exact Hi|intro Hi;apply Hnot;apply in_or_app;left;exact Hi]. }
    assert (Hownednd : NoDup (sched_owned_tasks (os_tasks st))).
    { pose proof (os_wf_sched_nodup sg st Hworld) as Hnd. unfold os_sched_owners in Hnd.
      exact (NoDup_app_remove_r _ _ Hnd). }
    assert (Hnewpermobj : Permutation newwaiting (task::semaphore_pending_addrs obj)) by (rewrite Hwait; exact Hnewperm).
    pose proof (Hpure sg st task desc lefts rights obj newwaiting Hworld Htask Hss Hlookup Hstatus Howned Hnotservice Hnewpermobj) as [Htaskafter Hworldafter].
    assert (Hnzero : store_map store_published_task (task_desc_map (os_tasks st)) |-- “ sched_link_of task <> 0 ”).
    { sep_apply_l_atomic (store_map_split store_published_task task desc (task_desc_map (os_tasks st)) Hlookup).
      unfold store_published_task, store_task_descriptor. Intros.
      prop_apply_p (valid_store_ptr (&(task # "TaskDescriptor" ->ₛ "stack_point")) (tdStackPoint desc)). Intros_p Hv.
      dump_pre_spatial.
      pose proof (task_descriptor_field_offset_axiom task (task_wf_aligned st Htask task desc Hlookup)) as Hl.
      unfold ktask_descriptor_field_offset_ok in Hl.
      assert (Hstack : &(task # "TaskDescriptor" ->ₛ "stack_point") = task + 0) by tauto.
      assert (Hlink : sched_link_of task = task + 16) by (unfold sched_link_of; tauto).
      unfold valid_object, valid_addr_range in Hv. rewrite Hstack in Hv. rewrite Hlink. intuition lia. }
    prop_apply_p Hnzero. Intros_p Hlinknz.
    assert (Hqueues : dataqueue_inv (lefts ++ obj::rights) (os_dataqueues st) |-- dataqueue_inv (lefts ++ newobj::rights) (os_dataqueues st)).
    { unfold dataqueue_inv. Intros_p Hq.
      split_pure_spatial; [cancel|]. dump_pre_spatial. intros p q Hmap.
      destruct (Hq p q Hmap) as [Hr [Hb Hd]]. split; [exact Hr|].
      assert (Hmove : forall id, (exists s, In s (lefts ++ obj::rights) /\ semaphore_id s = id) ->
          exists s, In s (lefts ++ newobj::rights) /\ semaphore_id s = id).
      { intros id [s [Hs Hid]]. apply in_app_iff in Hs. destruct Hs as [Hs|[Hs|Hs]].
        - exists s. split; [apply in_or_app;left;exact Hs|exact Hid].
        - subst s. exists newobj. split; [apply in_or_app;right;left;reflexivity|exact Hid].
        - exists s. split; [apply in_or_app;right;right;exact Hs|exact Hid]. }
      split; apply Hmove; assumption. }
    rewrite Hss.
    sep_apply_l_atomic (Hownedcut (task_desc_map (os_tasks st)) (sched_owned_tasks (os_tasks st)) task Hownednd Howned).
    sep_apply_l_atomic (Hsemcut (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_semaphore_stable sg) lefts rights obj newwaiting).
    unfold store_detached_sched_link at 1. Intros actual.
    sep_apply_l_atomic (store_node_self_linked_occupy (sched_link_of task)).
    change (map semaphore_wait_node (semaphore_pending_addrs obj)) with (map sched_link_node (semaphore_pending_addrs obj)).
    rewrite Hwait. unfold semaphore_pending_head. rewrite <- Haddr.
    split_pure_spatial.
    - sep_apply_r_atomic (pure_suspend_sched_link_close (task_desc_map (os_tasks st)) (sched_link_of task) task desc Hlookup eq_refl Hstatus).
      cancel (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st)))
        (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list")) (map sched_link_node waiting)).
      cancel (occupy_dll_node (sched_link_of task)).
      subst W. rewrite Hsemupdate. change (replace_sched_owned_tasks _ (replace_semaphores _ st)) with after.
      asrt_simpl. apply_sepcon_adjoint.
      change (map sched_link_node newwaiting) with (map semaphore_wait_node newwaiting).
      unfold semaphore_pending_head. rewrite <- Haddr. fold newobj.
      sep_apply_l_atomic (derivable1_wand_elim1
        (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st)))
          (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list")) (map semaphore_wait_node newwaiting))
        (semaphore_inv (pure_suspend_sched_link (task_desc_map (os_tasks st))) (os_semaphore_stable sg) (lefts ++ newobj::rights))).
      sep_apply_l_atomic Hqueues.
      unfold os_inv, task_inv. cbn [after replace_sched_owned_tasks replace_semaphores].
      split_pure_spatial.
      + change (os_tasks after) with
          ({| task_desc_map := task_desc_map (os_tasks st); task_ptr_list := task_ptr_list (os_tasks st);
              task_idmanager_abs := task_idmanager_abs (os_tasks st);
              sched_owned_tasks := remove Z.eq_dec task (sched_owned_tasks (os_tasks st)) |}).
        change (tick_inv sg after) with (tick_inv sg st).
        change (delay_inv sg after) with (delay_inv sg st).
        change (assign_inv sg after) with (assign_inv sg st).
        change (exstatus_inv sg after) with (exstatus_inv sg st).
        change (zombie_queue after) with (zombie_queue st).
        change (os_recycle after) with (os_recycle st).
        change (os_idle after) with (os_idle st).
        change (os_isr after) with (os_isr st).
        change (os_semaphores after) with (lefts ++ newobj::rights).
        change (os_mutexes after) with (os_mutexes st).
        change (os_events after) with (os_events st).
        change (os_dataqueues after) with (os_dataqueues st).
        cbv beta iota zeta delta [task_idmanager_abs task_ptr_list task_desc_map sched_owned_tasks].
        sepcon_assoc_change; cancel.
      + split_pures; dump_pre_spatial; assumption.
    - dump_pre_spatial; exact Hlinknz. }

  rewrite PreH5 in *.
  rewrite PreH2.
  assert (Hrestore : forall A B C Q F : Assertion,
      B ** F ** A ** C ** ((A ** (B ** C)) -* Q) |-- F ** Q).
  { clear. intros A B C Q F.
    sep_apply_r_atomic (derivable1_wand_elim1 (A ** (B ** C)) Q).
    sepcon_assoc_change. cancel F. cancel A. cancel B. cancel C. cancel. }
  sepcon_assoc_change.
  match goal with |- context [wand (?A ** (?B ** ?C)) (os_inv sg_semaphore_ic staged)] =>
    pose proof (Hrestore A B C (os_inv sg_semaphore_ic staged) (&("list") # Ptr |-> list_pre)) as Hrestore_now
  end.
  sepcon_assoc_change_in Hrestore_now.
  rewrite Hrestore_now.
  set (newwaiting := prefix_loop ++ task_pre::current_task::rest_tasks_2).
  set (newnodes := map sched_link_node newwaiting).
  set (after := replace_sched_owned_tasks (remove Z.eq_dec task_pre (sched_owned_tasks (os_tasks staged)))
    (semaphore_enqueue_state sem_semaphore_ic newwaiting staged)).
  assert (Hpriority : linklist_priority_insert (task_desc_map (os_tasks staged)) task_pre
      (map sched_link_node waiting_semaphore_ic) newnodes).
  { exists desc, (map sched_link_node prefix_loop), (map sched_link_node (current_task::rest_tasks_2)).
    split; [exact PreH12|]. split; [rewrite PreH16, map_app; reflexivity|].
    split; [unfold newnodes, newwaiting; rewrite map_app; reflexivity|]. split.
    - apply Forall_forall. intros n Hin. apply in_map_iff in Hin.
      destruct Hin as [a [<- Hin]]. apply PreH17; exact Hin.
    - simpl. exists current_desc; split; [exact PreH21|lia]. }
  assert (Hperm : Permutation newwaiting (task_pre::waiting_semaphore_ic)).
  { unfold newwaiting. rewrite PreH16. apply Permutation_sym. apply Permutation_middle. }
  assert (Henqueue : linklist_semaphore_enqueue sem_semaphore_ic task_pre 1 staged after).
  { destruct PreH11 as [obj [Hin [Haddr Hnodes]]].
    exists obj, desc, newnodes. repeat split; try assumption.
    - right. split; [reflexivity|]. rewrite Hnodes. exact Hpriority.
    - unfold after, newnodes. rewrite map_map.
      change (map (fun x:Z => x) newwaiting) with (map (@id Z) newwaiting).
      rewrite map_id. reflexivity. }
  sep_apply_l_atomic (Hprep sg_semaphore_ic staged sem_semaphore_ic task_pre desc waiting_semaphore_ic newwaiting
     PreH11 PreH12 PreH13 PreH14 PreH15 Hperm).
  Intros_p Hnz.
  prop_apply_p (Hdll Z (pure_suspend_sched_link (task_desc_map (os_tasks staged)))
     (semaphore_pending_head sem_semaphore_ic) (map sched_link_node waiting_semaphore_ic)).
  Intros_p Hnodeswf.
  assert (Hdispatch : dll_insert_before_dispatch list_pre (map sched_link_node waiting_semaphore_ic)
      (sched_link_of current_task) (sched_link_node task_pre) = newnodes).
  { unfold dll_insert_before_dispatch.
    destruct (Z.eq_dec (sched_link_of current_task) list_pre); [congruence|].
    destruct Hnodeswf as [Hnd Hsent]. rewrite PreH16 in Hnd |- *.
    unfold newnodes, newwaiting. rewrite !map_app in *.
    clear - Hnd. induction prefix_loop as [|a prefix IH].
    - simpl. destruct (Z.eq_dec (sched_link_of current_task) (sched_link_of current_task)); congruence.
    - simpl in Hnd |- *. inversion Hnd as [|x xs Hnot Htail]; subst.
      destruct (Z.eq_dec (sched_link_of a) (sched_link_of current_task)) as [Heq|Hne].
      + exfalso. apply Hnot. apply in_or_app; right. simpl. left; congruence.
      + f_equal. apply IH. exact Htail. }
  assert (Hanchor : dll_insert_anchor list_pre (map sched_link_node waiting_semaphore_ic) (sched_link_of current_task)).
  { left. rewrite PreH16, map_app, map_app. apply in_or_app; right. simpl; auto. }
  Exists rest_tasks_2 after newnodes prefix_loop (current_task::rest_tasks_2).
  split_pure_spatial.
  - unfold after, newnodes. rewrite PreH10. unfold sched_link_of. sepcon_assoc_change; cancel.
    match goal with |- ?P |-- _ => change (P |-- P); cancel P end.
  - split_pures; dump_pre_spatial; try assumption; try reflexivity; try congruence;
      try (unfold newnodes, newwaiting; reflexivity).
    intros _. split; [exact Hanchor|exact Hdispatch].
Qed.



Lemma proof_of_LinklistSuspend_return_wit_1_split_goal_1 : LinklistSuspend_return_wit_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold linklist_suspend_step.
  right. split; [auto |]. split; [reflexivity |].
  exists staged, ignored. split; assumption.
Qed.

Lemma proof_of_LinklistSuspend_return_wit_1 : LinklistSuspend_return_wit_1.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_LinklistSuspend_return_wit_1_split_goal_1.
Qed.

Lemma proof_of_LinklistSuspend_return_wit_2_split_goal_1 : LinklistSuspend_return_wit_2_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold linklist_suspend_step.
  right. split; [auto |]. split; [reflexivity |].
  exists staged, ignored. split; assumption.
Qed.

Lemma proof_of_LinklistSuspend_return_wit_2 : LinklistSuspend_return_wit_2.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_LinklistSuspend_return_wit_2_split_goal_1.
Qed.

Lemma proof_of_LinklistSuspend_return_wit_3_split_goal_1 : LinklistSuspend_return_wit_3_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold linklist_suspend_step.
  right. split; [auto |]. split; [reflexivity |].
  exists staged, ignored. split; assumption.
Qed.

Lemma proof_of_LinklistSuspend_return_wit_3 : LinklistSuspend_return_wit_3.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_LinklistSuspend_return_wit_3_split_goal_1.
Qed.

Lemma proof_of_LinklistSuspend_return_wit_4_split_goal_1 : LinklistSuspend_return_wit_4_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold linklist_suspend_step.
  left. repeat split; auto.
Qed.

Lemma proof_of_LinklistSuspend_return_wit_4 : LinklistSuspend_return_wit_4.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_LinklistSuspend_return_wit_4_split_goal_1.
Qed.

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
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  rewrite PreH1.
  sep_apply_r_atomic (derivable1_wand_elim1 (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks staged))) list_pre (map sched_link_node (waiting_semaphore_ic ++ [task_pre]))) (os_inv sg_semaphore_ic after_fifo)).
  cancel.
Qed.

Lemma proof_of_LinklistSuspend_which_implies_wit_2 : LinklistSuspend_which_implies_wit_2.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_LinklistSuspend_which_implies_wit_2_split_goal_spatial.
Qed.

Lemma proof_of_LinklistSuspend_which_implies_wit_3 : LinklistSuspend_which_implies_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hcut : forall (A : Type) (P : Z -> A -> Assertion) hd ns n,
    In n ns -> store_dll P hd ns |-- P (getPtr n) (getData n) **
      (P (getPtr n) (getData n) -* store_dll P hd ns)).
  { intros A P hd ns n Hn.
    apply in_split in Hn as [pre [post Hns]]. subst ns.
    unfold store_dll. Intros h pt.
    sep_apply (dllseg_split P h hd hd pt pre (n::post)). Intros x px.
    change (dllseg P x px hd pt (n::post)) with
      (EX z, “ x = getPtr n ” && P x (getData n) **
        &(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
        &(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
        dllseg P z x hd pt post).
    Intros z. subst x. cancel (P (getPtr n) (getData n)).
    apply_sepcon_adjoint.
    Exists h pt. split_pure_spatial.
    - sep_apply (dllseg_head_insert A P px (getPtr n) z hd pt (getData n) post).
      replace (Build_DL_Node (getData n) (getPtr n)) with n by (destruct n; reflexivity).
      sep_apply (dllseg_concat P h hd (getPtr n) px hd pt pre (n::post)). cancel.
    - split_pures; dump_pre_spatial; tauto.
  }
  assert (Hfocus : forall sg st sem waiting,
    semaphore_pending_nodes sem st (map sched_link_node waiting) ->
    os_inv sg st |--
    store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st)))
      (semaphore_pending_head sem) (map sched_link_node waiting) **
    (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st)))
      (semaphore_pending_head sem) (map sched_link_node waiting) -* os_inv sg st)).
  { intros sg st sem waiting [obj [Hin [Haddr Hnodes]]].
    unfold os_inv at 1. cbn zeta. unfold semaphore_inv at 1. Intros.
    sep_apply (Hcut SemaphoreAbs
      (store_semaphore (pure_suspend_sched_link (task_desc_map (os_tasks st))))
      (semaphore_list_head (os_semaphore_stable sg))
      (map semaphore_link_node (os_semaphores st)) (semaphore_link_node obj)
      ltac:(apply in_map; exact Hin)).
    cbn [semaphore_link_node getPtr getData].
    unfold store_semaphore at 1. cbn zeta. Intros.
    change (map semaphore_wait_node (semaphore_pending_addrs obj)) with
      (map sched_link_node (semaphore_pending_addrs obj)).
    rewrite Hnodes. rewrite Haddr. fold (semaphore_pending_head sem).
    cancel (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks st)))
      (semaphore_pending_head sem) (map sched_link_node waiting)).
    apply_sepcon_adjoint.
    unfold os_inv, semaphore_inv. cbn zeta.
    split_pure_spatial; [sepcon_assoc_change; repeat progress cancel | split_pures; dump_pre_spatial; tauto].
    sep_apply_r_atomic (derivable1_wand_elim1
      (store_semaphore (pure_suspend_sched_link (task_desc_map (os_tasks st)))
        (&(sem # "Semaphore" ->ₛ "link")) obj)
      (store_dll (store_semaphore (pure_suspend_sched_link (task_desc_map (os_tasks st))))
        (semaphore_list_head (os_semaphore_stable sg))
        (map semaphore_link_node (os_semaphores st)))).
    repeat progress cancel.
    unfold store_semaphore. cbn zeta. rewrite Haddr.
    change (map semaphore_wait_node (semaphore_pending_addrs obj)) with
      (map sched_link_node (semaphore_pending_addrs obj)).
    rewrite Hnodes. fold (semaphore_pending_head sem).
    split_pure_spatial; [repeat progress cancel | split_pures; dump_pre_spatial; intuition congruence].
  }
  sep_apply (Hfocus sg_semaphore_ic staged sem_semaphore_ic waiting_semaphore_ic PreH1).
  rewrite <- PreH2. unfold store_dll at 1. Intros h pt.
  destruct waiting_semaphore_ic as [|t ts].
  - cbn [map dllseg]. Intros.
    repeat match goal with H : _ /\ _ |- _ => destruct H end. subst h pt.
    Left. Exists list_pre. split_pure_spatial.
    + sepcon_assoc_change. cancel (store_ptr (&(list_pre # "SysDoubleLinklistNode" ->ₛ "node_next")) list_pre).
      apply_sepcon_adjoint.
      sep_apply_r_atomic (derivable1_wand_elim1
        (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks staged))) list_pre [])
        (os_inv sg_semaphore_ic staged)).
      cancel (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks staged))) list_pre [] -* os_inv sg_semaphore_ic staged).
      unfold store_dll. Exists list_pre list_pre. cbn [dllseg].
      split_pure_spatial; [repeat progress cancel | split_pures; dump_pre_spatial; intuition].
    + split_pures; dump_pre_spatial; reflexivity.
  - cbn [map dllseg]. Intros z. 
    cbn [sched_link_node getPtr getData] in *.
    try subst h.
    Right. Exists (sched_link_of t) t ts. split_pure_spatial.
    + sepcon_assoc_change. cancel (store_ptr (&(list_pre # "SysDoubleLinklistNode" ->ₛ "node_next")) (sched_link_of t)).
      apply_sepcon_adjoint.
      sep_apply_r_atomic (derivable1_wand_elim1
        (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks staged))) list_pre (map sched_link_node (t::ts)))
        (os_inv sg_semaphore_ic staged)).
      cbn [map]. sepcon_assoc_change.
      cancel (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks staged))) list_pre (sched_link_node t :: map sched_link_node ts) -* os_inv sg_semaphore_ic staged).
      unfold store_dll. Exists (sched_link_of t) pt.
      cbn [map dllseg sched_link_node getPtr getData]. Exists z.
      split_pure_spatial; [repeat progress cancel | split_pures; dump_pre_spatial; intuition].
    + split_pures; dump_pre_spatial; reflexivity.
Qed.

Lemma proof_of_LinklistSuspend_which_implies_wit_4_split_goal_spatial : LinklistSuspend_which_implies_wit_4_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst new_nodes.
  match goal with
  | |- ?P ** wand ?P ?Q |-- ?Q => sep_apply_r_atomic (derivable1_wand_elim1 P Q); cancel
  end.
Qed.

Lemma proof_of_LinklistSuspend_which_implies_wit_4 : LinklistSuspend_which_implies_wit_4.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_LinklistSuspend_which_implies_wit_4_split_goal_spatial.
Qed.

Lemma proof_of_LinklistSuspend_which_implies_wit_5 : LinklistSuspend_which_implies_wit_5.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Havoid : forall (A : Type) (P : Z -> A -> Assertion) ns x px y py p v,
    dllseg P x px y py ns ** &(p # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> v
      |-- “ ~ In p (map (@getPtr A) ns) ”).
  { intros A P ns. induction ns as [|n ns IH]; intros x px y py p v.
    - cbn [dllseg map]. Intros. split_pures; dump_pre_spatial; tauto.
    - change (dllseg P x px y py (n::ns)) with
        (EX z, “ x = getPtr n ” && P x (getData n) **
        &(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
        &(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z ** dllseg P z x y py ns).
      Intros z. subst x. destruct (Z.eq_dec p (getPtr n)) as [Heq|Hneq].
      + subst p. let np := constr:(getPtr n) in
        sep_apply (dup_store_ptr (&(np # "SysDoubleLinklistNode" ->ₛ "node_next")) z v).
        Intros. split_pures; dump_pre_spatial; contradiction.
      + prop_apply_p (IH z (getPtr n) y py p v). Intros.
        split_pures; dump_pre_spatial; simpl; intuition congruence.
  }
  assert (Hnodup : forall (A : Type) (P : Z -> A -> Assertion) ns x px y py,
    dllseg P x px y py ns |-- “ NoDup (map (@getPtr A) ns) ”).
  { intros A P ns. induction ns as [|n ns IH]; intros x px y py.
    - cbn [dllseg map]. Intros. split_pures; dump_pre_spatial; constructor.
    - change (dllseg P x px y py (n::ns)) with
        (EX z, “ x = getPtr n ” && P x (getData n) **
        &(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
        &(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z ** dllseg P z x y py ns).
      Intros z. subst x. prop_apply_p (IH z (getPtr n) y py). Intros.
      sep_apply (Havoid A P ns z (getPtr n) y py (getPtr n) z). Intros.
      split_pures; dump_pre_spatial; simpl; constructor; assumption.
  }
  assert (Hfacts : forall (A : Type) (P : Z -> A -> Assertion) hd ns,
    store_dll P hd ns |-- “ NoDup (map (@getPtr A) ns) /\ ~ In hd (map (@getPtr A) ns) ”).
  { intros A P hd ns. unfold store_dll. Intros h pt.
    prop_apply_p (Hnodup A P ns h hd hd pt). Intros.
    sep_apply (Havoid A P ns h hd hd pt hd h). Intros.
    split_pures; dump_pre_spatial; tauto.
  }
  assert (Hafter : forall (A : Type) (pre : list (DL_Node A)) n inserted,
    ~ In (getPtr n) (map (@getPtr A) pre) ->
    dll_insert_after_member (pre ++ [n]) (getPtr n) inserted = pre ++ [n; inserted]).
  { intros A pre. induction pre as [|a pre IH]; intros n ins Hnot.
    - cbn [app dll_insert_after_member]. destruct (Z.eq_dec (getPtr n) (getPtr n)); congruence.
    - cbn [map] in Hnot. cbn [app dll_insert_after_member].
      destruct (Z.eq_dec (getPtr a) (getPtr n)) as [Heq|Hneq].
      + exfalso. apply Hnot. left; exact Heq.
      + f_equal. apply IH. intro Hin. apply Hnot. right; exact Hin.
  }
  subst new_nodes.
  prop_apply_p (Hfacts Z (pure_suspend_sched_link (task_desc_map (os_tasks staged))) list_pre
    (map sched_link_node waiting_semaphore_ic)). Intros_p Hfacts0.
  destruct Hfacts0 as [Hnd Hhead].
  destruct (rev waiting_semaphore_ic) as [|t revpre] eqn:Hrev.
  - assert (Hw : waiting_semaphore_ic = []).
    { apply (f_equal (@rev Z)) in Hrev. rewrite rev_involutive in Hrev. exact Hrev. }
    subst waiting_semaphore_ic.
    unfold store_dll. cbn [map dllseg]. Intros h pt.
    repeat match goal with H : _ /\ _ |- _ => destruct H end. subst h pt.
    Exists list_pre. split_pure_spatial.
    + sepcon_assoc_change. cancel (store_ptr (&(list_pre # "SysDoubleLinklistNode" ->ₛ "node_prev")) list_pre).
      apply_sepcon_adjoint. Exists list_pre list_pre. cbn [dllseg].
      split_pure_spatial; [sepcon_assoc_change; repeat progress cancel | split_pures; dump_pre_spatial; intuition].
    + split_pures; dump_pre_spatial.
      * unfold dll_insert_anchor. right; reflexivity.
      * rewrite dll_insert_after_dispatch_at_head. reflexivity.
  - set (pre := rev revpre).
    assert (Hw : waiting_semaphore_ic = pre ++ [t]).
    { apply (f_equal (@rev Z)) in Hrev. rewrite rev_involutive in Hrev. exact Hrev. }
    rewrite Hw. rewrite !map_app. cbn [map].
    rewrite Hw, map_app in Hnd, Hhead. cbn [map] in Hnd, Hhead.
    unfold store_dll at 1. Intros h pt. sepcon_assoc_change.
    sep_apply (dllseg_split (pure_suspend_sched_link (task_desc_map (os_tasks staged)))
      h list_pre list_pre pt (map sched_link_node pre) [sched_link_node t]). Intros x px.
    change (dllseg (pure_suspend_sched_link (task_desc_map (os_tasks staged))) x px list_pre pt [sched_link_node t]) with
      (EX z, “ x = sched_link_of t ” &&
        pure_suspend_sched_link (task_desc_map (os_tasks staged)) x t **
        &(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
        &(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
        (“ z = list_pre /\ x = pt ” && emp)).
    Intros z. repeat match goal with H : _ /\ _ |- _ => destruct H end. subst x z pt.
    assert (Hnot : ~ In (sched_link_of t) (map (@getPtr Z) (map sched_link_node pre))).
    { rewrite map_app in Hnd. cbn [map sched_link_node getPtr] in Hnd.
      apply NoDup_remove_2 in Hnd. rewrite app_nil_r in Hnd. exact Hnd. }
    Exists (sched_link_of t). split_pure_spatial.
    + sepcon_assoc_change. cancel (store_ptr (&(list_pre # "SysDoubleLinklistNode" ->ₛ "node_prev")) (sched_link_of t)).
      apply_sepcon_adjoint. unfold store_dll. Exists h (sched_link_of t).
      split_pure_spatial.
      * sepcon_assoc_change. repeat progress cancel.
        sep_apply_r_atomic (dllseg_concat (pure_suspend_sched_link (task_desc_map (os_tasks staged)))
          h list_pre (sched_link_of t) px list_pre (sched_link_of t) (map sched_link_node pre) [sched_link_node t]).
        sepcon_assoc_change. repeat progress cancel.
        cbn [dllseg sched_link_node getPtr getData]. Exists list_pre.
        split_pure_spatial; [repeat progress cancel | split_pures; dump_pre_spatial; intuition].
      * split_pures; dump_pre_spatial; intuition.
    + split_pures; dump_pre_spatial.
      * unfold dll_insert_anchor. left. rewrite map_app. apply in_or_app. right. simpl; auto.
      * unfold dll_insert_after_dispatch.
        destruct (Z.eq_dec (sched_link_of t) list_pre) as [Heq|Hneq].
        -- exfalso. apply Hhead. rewrite map_app. apply in_or_app. right. simpl. auto.
        -- change (dll_insert_after_member (map sched_link_node pre ++ [sched_link_node t])
             (sched_link_of t) (sched_link_node task_pre) =
             (map sched_link_node pre ++ [sched_link_node t]) ++ [sched_link_node task_pre]).
           rewrite <- app_assoc. apply Hafter. exact Hnot.
Qed.

Lemma proof_of_LinklistSuspend_which_implies_wit_6_split_goal_spatial : LinklistSuspend_which_implies_wit_6_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  sep_apply (derivable1_wand_elim1
    (store_ptr (&(list_pre # "SysDoubleLinklistNode" ->ₛ "node_prev")) last_link)
    (store_dll (pure_suspend_sched_link (task_desc_map (os_tasks staged))) list_pre (map sched_link_node waiting_semaphore_ic))).
  cancel.
Qed.

Lemma proof_of_LinklistSuspend_which_implies_wit_6 : LinklistSuspend_which_implies_wit_6.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_LinklistSuspend_which_implies_wit_6_split_goal_spatial.
Qed.

Lemma proof_of_LinklistSuspend_which_implies_wit_7_split_goal_spatial : LinklistSuspend_which_implies_wit_7_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  subst new_nodes.
  match goal with
  | |- ?P ** wand ?P ?Q |-- ?Q => sep_apply_r_atomic (derivable1_wand_elim1 P Q); cancel
  end.
Qed.

Lemma proof_of_LinklistSuspend_which_implies_wit_7 : LinklistSuspend_which_implies_wit_7.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of_LinklistSuspend_which_implies_wit_7_split_goal_spatial.
Qed.

Lemma proof_of_LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic : LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Exists sg_semaphore_prio_ic before_semaphore_prio_ic sem_semaphore_prio_ic waiting_semaphore_prio_ic.
  assert (Hstrengthen : emp |-- ALL (retval : Z),
    (EX after, “ linklist_suspend_step sem_semaphore_prio_ic task_pre 1 before_semaphore_prio_ic retval after ” && os_inv sg_semaphore_prio_ic after)
    -* (EX after, “ retval = 0 ” && “ linklist_suspend_prio sem_semaphore_prio_ic task_pre before_semaphore_prio_ic after ” && os_inv sg_semaphore_prio_ic after)).
  { Intros_r retval. apply_sepcon_adjoint. Intros after.
    match goal with H : linklist_suspend_step _ _ _ _ _ _ |- _ => rename H into Hstep end.
    assert (Hret : retval = 0).
    { unfold linklist_suspend_step in Hstep. destruct Hstep as [[Hbad _] | [_ [Hr _]]]; [lia | exact Hr]. }
    subst retval. Exists after.
    split_pure_spatial; [cancel | split_pures; dump_pre_spatial; auto].
  }
  subst flag_pre.
  split_pure_spatial.
  - cancel (os_inv sg_semaphore_prio_ic before_semaphore_prio_ic).
    exact Hstrengthen.
  - split_pures; dump_pre_spatial; auto.
Qed.

