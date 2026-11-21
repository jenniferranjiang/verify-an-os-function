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
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  rename waiting_semaphore_head_ic into waiting, sem_semaphore_head_ic into sem,
    before_semaphore_head_ic into st, sg_semaphore_head_ic into sg.
  destruct waiting as [|first rest]; [contradiction|].
  subst list_pre.
  pose proof PreH3 as Hpending.
  destruct PreH3 as [obj [Hin [Haddr Hnodes]]].
  assert (Hpendinglist : semaphore_pending_addrs obj = first :: rest).
  { apply (f_equal (map (@getData Z))) in Hnodes.
    rewrite !map_map in Hnodes. cbn [sched_link_node getData] in Hnodes.
    rewrite !map_id in Hnodes. exact Hnodes. }
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

  assert (Hfocusdll : forall (A : Type) (P : Z -> A -> Assertion)
      (nodes : list (DL_Node A)) (n : DL_Node A), In n nodes -> forall head,
      store_dll P head nodes |-- P (getPtr n) (getData n) **
      (P (getPtr n) (getData n) -* store_dll P head nodes)).
  { intros A P nodes [data ptr] Hn head.
    apply in_split in Hn. destruct Hn as [pre [post Heq]]. subst nodes.
    exact (Hcut A P head pre post ptr data data). }
  assert (Hfield : forall wait link,
    store_semaphore wait link obj |--
    &(((semaphore_pending_head sem)) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> sched_link_of first **
    (&(((semaphore_pending_head sem)) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> sched_link_of first -*
      store_semaphore wait link obj)).
  { intros wait link.
    remember (&(((semaphore_pending_head sem)) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> sched_link_of first -*
      store_semaphore wait link obj) as W eqn:HW.
    unfold store_semaphore at 1. Intros_p Hobj.
    unfold store_dll at 1. Intros hd pt.
    assert (Hv : &(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list") <> 0 /\
      pt <> 0 /\ hd <> 0 /\ dll_nodes_nonzero (map semaphore_wait_node (semaphore_pending_addrs obj))) by assumption.
    rewrite Hpendinglist. cbn [map dllseg semaphore_wait_node getPtr getData]. Intros nxt.
    assert (Hhd : hd = object_wait_link_of first) by assumption. subst hd.
    fold (@dllseg addr wait).
    unfold semaphore_pending_head. rewrite <- Haddr.
    change (object_wait_link_of first) with (sched_link_of first) in *.
    let pend := constr:(&(((semaphore_addr obj)) # "Semaphore" ->ₛ "pend_list")) in
    cancel (&(pend # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> sched_link_of first).
    subst W. apply_sepcon_adjoint.
    unfold semaphore_pending_head. rewrite <- Haddr.
    unfold store_semaphore, store_dll. Exists (sched_link_of first) pt.
    rewrite Hpendinglist. cbn [map dllseg semaphore_wait_node getPtr getData]. Exists nxt.
    split_pure_spatial.
    - sepcon_assoc_change; cancel.
    - split_pures; dump_pre_spatial; try tauto.
      rewrite Hpendinglist in Hv. exact Hv.
  }
  unfold os_inv at 1. Intros_p Hworld.
  unfold task_inv at 1. Intros_p Htask.
  assert (Hwaiting : In first (os_sched_owners st)).
  { assert (Hw : In first (semaphore_waiters (os_semaphores st))).
    { unfold semaphore_waiters. apply in_concat.
      exists (semaphore_pending_addrs obj). split.
      - apply in_map. exact Hin.
      - rewrite Hpendinglist; simpl; auto. }
    unfold os_sched_owners. repeat rewrite in_app_iff. tauto. }
  pose proof (proj1 (os_wf_sched_domain sg st Hworld first) Hwaiting) as Hpresent.
  destruct (task_desc_map (os_tasks st) first) as [desc|] eqn:Hlookup; [|contradiction].
  pose proof (task_wf_aligned st Htask first desc Hlookup) as Halign.
  change (addr_aligned first 4) in Halign.
  Exists first rest. split_pure_spatial.
  2: { split_pures; dump_pre_spatial; auto. }
  remember (&(((semaphore_pending_head sem)) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> sched_link_of first -* os_inv sg st) as W eqn:HW.
  unfold semaphore_inv at 1. Intros_p Hsem.
  set (wait := pure_suspend_sched_link (task_desc_map (os_tasks st))).
  assert (Hnodein : In (semaphore_link_node obj) (map semaphore_link_node (os_semaphores st)))
    by (apply in_map; exact Hin).
  sep_apply_l_atomic (Hfocusdll SemaphoreAbs (store_semaphore wait)
    (map semaphore_link_node (os_semaphores st)) (semaphore_link_node obj) Hnodein
    (semaphore_list_head (os_semaphore_stable sg))).
  cbn [semaphore_link_node getPtr getData].
  remember (store_semaphore wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) obj -*
    store_dll (store_semaphore wait) (semaphore_list_head (os_semaphore_stable sg))
      (map semaphore_link_node (os_semaphores st))) as R eqn:HR.
  sep_apply_l_atomic (Hfield wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link"))).
  cancel (&(((semaphore_pending_head sem)) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> sched_link_of first).
  subst W. apply_sepcon_adjoint.
  sep_apply_l_atomic (derivable1_wand_elim2
    (&(((semaphore_pending_head sem)) # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> sched_link_of first)
    (store_semaphore wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) obj)).
  subst R.
  sep_apply_l_atomic (derivable1_wand_elim2
    (store_semaphore wait (&(((semaphore_addr obj)) # "Semaphore" ->ₛ "link")) obj)
    (store_dll (store_semaphore wait) (semaphore_list_head (os_semaphore_stable sg))
      (map semaphore_link_node (os_semaphores st)))).
  unfold os_inv, task_inv, semaphore_inv. cbv beta iota zeta.
  split_pure_spatial.
  - unfold wait. sepcon_assoc_change; cancel.
  - split_pures; dump_pre_spatial; assumption.
Qed.

Lemma proof_of_LinklistResume_which_implies_wit_2_split_goal_spatial : LinklistResume_which_implies_wit_2_split_goal_spatial.
Proof. LLM_pre_process ltac:(lia || int_auto). apply derivable1_wand_elim2. Qed.

Lemma proof_of_LinklistResume_which_implies_wit_2 : LinklistResume_which_implies_wit_2.
Proof. aggressive_pre_process. Goal_apply proof_of_LinklistResume_which_implies_wit_2_split_goal_spatial. Qed.

Lemma proof_of_LinklistResume_which_implies_wit_3 : LinklistResume_which_implies_wit_3.
Proof. Admitted.

Lemma proof_of_LinklistResume_which_implies_wit_4_split_goal_spatial : LinklistResume_which_implies_wit_4_split_goal_spatial.
Proof. Abort.

Lemma proof_of_LinklistResume_which_implies_wit_4 : LinklistResume_which_implies_wit_4.
Proof. Admitted.

