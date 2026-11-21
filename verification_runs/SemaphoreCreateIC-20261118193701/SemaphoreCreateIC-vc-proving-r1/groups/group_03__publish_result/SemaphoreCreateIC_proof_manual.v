From SimpleC.Verification Require Import VCPrelude.
From CRTOS_Verify.VC.semaphore Require Import SemaphoreCreateIC_goal.
From CRTOS_Verify.VC.semaphore Require Import SemaphoreCreateIC_proof_auto.
Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreDelete.
Require Import CRTOS_Verify.lib.id.idnode CRTOS_Verify.lib.id.IdModuleSpec CRTOS_Verify.lib.common.dll CRTOS_Verify.lib.list.NodeSelfLinked.
Import IDNode DLL.
Local Open Scope sac.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_1 : _SemaphoreCreate_entail_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_2 : _SemaphoreCreate_entail_wit_1_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_3 : _SemaphoreCreate_entail_wit_1_split_goal_3.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_4 : _SemaphoreCreate_entail_wit_1_split_goal_4.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_5 : _SemaphoreCreate_entail_wit_1_split_goal_5.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_spatial : _SemaphoreCreate_entail_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1 : _SemaphoreCreate_entail_wit_1.
Proof. Admitted.

Lemma proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_spatial : _SemaphoreCreate_entail_wit_2_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_2_1 : _SemaphoreCreate_entail_wit_2_1.
Proof. Admitted.

Lemma proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_1 : _SemaphoreCreate_entail_wit_2_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_spatial : _SemaphoreCreate_entail_wit_2_2_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_2_2 : _SemaphoreCreate_entail_wit_2_2.
Proof. Admitted.

Lemma proof_of__SemaphoreCreate_entail_wit_3 : _SemaphoreCreate_entail_wit_3.
Proof. Admitted.

Lemma proof_of__SemaphoreCreate_entail_wit_4_split_goal_spatial : _SemaphoreCreate_entail_wit_4_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_4 : _SemaphoreCreate_entail_wit_4.
Proof. Admitted.

Lemma proof_of__SemaphoreCreate_return_wit_1 : _SemaphoreCreate_return_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  rename before_dataqueue_ic into before, sg_dataqueue_ic into sg.
  assert (Hworld : os_world_wf sg
    (replace_semaphores (semaphore_publish sem id val_pre (os_semaphores before)) before)).
  { destruct PreH9 as [Hctx Hrec Hidle Hnd Hdom].
    constructor; cbn [replace_semaphores]; try assumption.
    - unfold service_slot_wf in *; simpl.
      destruct (service_phase (os_recycle before)); try assumption.
      destruct Hrec as [d Hd]. exists d. destruct Hd; constructor; assumption.
    - simpl. eapply List.Forall_impl; [|exact Hidle].
      intros x Hx. unfold service_slot_wf in *.
      destruct (service_phase x); try assumption.
      destruct Hx as [d Hd]. exists d. destruct Hd; constructor; assumption.
  }
  assert (Hmanager : semaphore_manager (semaphore_publish sem id val_pre (os_semaphores before)) =
    idmanager_link (semaphore_manager_stable (os_semaphore_stable sg))
      (idmanager_add (semaphore_manager (os_semaphores before)) id) id
      (&(sem # "Semaphore" ->ₛ "id"))).
  { destruct PreH10 as [_ [_ [Hoff _]]].
    unfold semaphore_manager, semaphore_publish, idmanager_link, idmanager_add,
      idmanager_insert_bucket, idlist_add.
    cbn [idlist idbuckets]. rewrite Hoff.
    assert (Hmod : 0 <= id mod 16 < 16) by (apply Z.mod_pos_bound; lia).
    cbn [map filter semaphore_created semaphore_id].
    remember (id mod 16) as k eqn:Hk.
    assert (Hcases : k = 0 \/ k = 1 \/ k = 2 \/ k = 3 \/ k = 4 \/
      k = 5 \/ k = 6 \/ k = 7 \/ k = 8 \/ k = 9 \/ k = 10 \/
      k = 11 \/ k = 12 \/ k = 13 \/ k = 14 \/ k = 15) by lia.
    repeat destruct Hcases as [Hcases | Hcases]; rewrite Hcases; reflexivity.
  }
  Exists (replace_semaphores (semaphore_publish sem id val_pre (os_semaphores before)) before).
  split_pure_spatial.
  - unfold os_inv. Intros.
    rewrite dll_insert_after_dispatch_at_head.
    unfold semaphore_inv.
    cbn [replace_semaphores os_tasks os_semaphores os_dataqueues os_tick os_delays
      os_assign zombie_queue os_recycle os_idle os_isr os_exstatus os_mutexes os_events].
    rewrite Hmanager.
    destruct PreH10 as [Hptr [Hmax [Hoff [Hmap [Htable Hhead]]]]].
    rewrite Hptr, Hhead.
    change (map semaphore_link_node (semaphore_publish sem id val_pre (os_semaphores before)))
      with (Build_DL_Node (semaphore_created sem id val_pre) (&(sem # "Semaphore" ->ₛ "link")) ::
        map semaphore_link_node (os_semaphores before)).
    unfold dataqueue_inv. Intros_p Hqueues.
    unfold task_inv, tick_inv, delay_inv, assign_inv, exstatus_inv.
    cbn [replace_semaphores os_tasks os_tick os_delays os_assign os_exstatus].
    Intros.
    split_pure_spatial.
    + repeat progress cancel.
    + split_pures; dump_pre_spatial.
      all: try assumption.
      all: try (unfold semaphore_context; repeat split; assumption).
      all: try (destruct H; constructor; assumption).
      intros p q Hlookup.
      destruct (Hqueues p q Hlookup) as [Hr [[sb [Hb Hbid]] [sd [Hd Hdid]]]].
      split; [exact Hr|].
      unfold dataqueue_semaphores, semaphore_publish.
      split; [exists sb | exists sd]; simpl; auto.
  - split_pures; dump_pre_spatial; try lia.
    unfold semaphore_create_ic_effect. right. exists sem.
    split; [exact PreH4|]. split; [exact PreH5|].
    split; [exact PreH11|]. split; [exact PreH8|reflexivity].
Qed.

Lemma proof_of__SemaphoreCreate_return_wit_2_split_goal_1 : _SemaphoreCreate_return_wit_2_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_return_wit_2 : _SemaphoreCreate_return_wit_2.
Proof. Admitted.

Lemma proof_of__SemaphoreCreate_return_wit_3_split_goal_1 : _SemaphoreCreate_return_wit_3_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_return_wit_3 : _SemaphoreCreate_return_wit_3.
Proof. Admitted.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1 : _SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_6_pure : _SemaphoreCreate_partial_solve_wit_6_pure.
Proof. Admitted.

