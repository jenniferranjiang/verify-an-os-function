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
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_1_2 : LinklistSuspend_entail_wit_1_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_2_1 : LinklistSuspend_entail_wit_2_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_2_2 : LinklistSuspend_entail_wit_2_2.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_3 : LinklistSuspend_entail_wit_3.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_4_1 : LinklistSuspend_entail_wit_4_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_entail_wit_4_2 : LinklistSuspend_entail_wit_4_2.
Proof. Admitted.

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
Proof. Abort.

Lemma proof_of_LinklistSuspend_which_implies_wit_1 : LinklistSuspend_which_implies_wit_1.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_which_implies_wit_2_split_goal_spatial : LinklistSuspend_which_implies_wit_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistSuspend_which_implies_wit_2 : LinklistSuspend_which_implies_wit_2.
Proof. Admitted.

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
Proof. Abort.

Lemma proof_of_LinklistSuspend_which_implies_wit_4 : LinklistSuspend_which_implies_wit_4.
Proof. Admitted.

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
Proof. Abort.

Lemma proof_of_LinklistSuspend_which_implies_wit_7 : LinklistSuspend_which_implies_wit_7.
Proof. Admitted.

Lemma proof_of_LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic : LinklistSuspend_semaphore_ic_entail_semaphore_prio_ic.
Proof. Admitted.

