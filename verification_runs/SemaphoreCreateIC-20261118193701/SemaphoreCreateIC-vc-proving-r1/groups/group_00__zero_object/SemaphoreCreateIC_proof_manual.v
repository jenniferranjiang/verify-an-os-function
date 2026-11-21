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
Proof.
LLM_pre_process ltac:(lia || int_auto).
assert (Hfresh : forall wait l x px y py p,
  dllseg (store_semaphore wait) x px y py (map semaphore_link_node l) **
  &(p # "Semaphore" ->ₛ "value") # UShort |-> 0 |--
  “ ~ In p (map semaphore_addr l) ”).
{ clear.
  intros wait l. induction l as [|a l IH]; intros x px y py p.
  - cbn [map]. dump_pre_spatial. simpl. tauto.
  - cbn [map dllseg]. Intros z.
    destruct (Z.eq_dec p (semaphore_addr a)) as [Heq|Hneq].
    + unfold store_semaphore. Intros. rewrite Heq.
      let q := constr:(semaphore_addr a) in
      sep_apply_l_atomic (store_ushort_undef_store_ushort (&(q # "Semaphore" ->ₛ "value")) (semaphore_value a)).
      let q := constr:(semaphore_addr a) in
      sep_apply_l_atomic (store_ushort_undef_store_ushort (&(q # "Semaphore" ->ₛ "value")) 0).
      let q := constr:(semaphore_addr a) in
      sep_apply_l_atomic (undef_store_int_exclusive 2 2 (&(q # "Semaphore" ->ₛ "value")) ltac:(lia)).
      Intros_p Hbad. contradiction.
    + change (store_semaphore wait x a **
        (&(x # "SysDoubleLinklistNode" ->ₛ "node_prev") # Ptr |-> px **
        (&(x # "SysDoubleLinklistNode" ->ₛ "node_next") # Ptr |-> z **
        (dllseg (store_semaphore wait) z x y py (map semaphore_link_node l) **
        &(p # "Semaphore" ->ₛ "value") # UShort |-> 0))) |--
        “ ~ In p (semaphore_addr a :: map semaphore_addr l) ”).
      sep_apply (IH z x y py p).
      Intros_p Htail. dump_pre_spatial. simpl. intuition congruence.
}
sep_apply_l_atomic (semaphore_zero_bytes_object retval (semaphore_field_offsets_trusted retval PreH6) ltac:(lia) PreH5 PreH6).
unfold os_inv, semaphore_inv, SemaphoreZero.
Intros.
unfold store_dll at 1. Intros h pt. Intros.
sep_apply (Hfresh (pure_suspend_sched_link (task_desc_map (os_tasks before_dataqueue_ic))) (os_semaphores before_dataqueue_ic) h (semaphore_list_head (os_semaphore_stable sg_dataqueue_ic)) (semaphore_list_head (os_semaphore_stable sg_dataqueue_ic)) pt retval).
Intros_p Habsent. dump_pre_spatial. exact Habsent.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_2 : _SemaphoreCreate_entail_wit_1_split_goal_2.
Proof.
LLM_pre_process ltac:(lia || int_auto).
unfold os_inv, semaphore_inv. Intros.
dump_pre_spatial. assumption.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_3 : _SemaphoreCreate_entail_wit_1_split_goal_3.
Proof.
LLM_pre_process ltac:(lia || int_auto).
unfold os_inv. Intros.
dump_pre_spatial. assumption.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_4 : _SemaphoreCreate_entail_wit_1_split_goal_4.
Proof.
LLM_pre_process ltac:(lia || int_auto).
dump_pre_spatial.
pose proof (semaphore_field_offsets_trusted retval PreH6) as Hlayout.
unfold semaphore_byte_layout in Hlayout.
destruct Hlayout as [_ [_ [_ [_ [_ [Hlink _]]]]]].
rewrite Hlink. lia.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_5 : _SemaphoreCreate_entail_wit_1_split_goal_5.
Proof.
LLM_pre_process ltac:(lia || int_auto).
dump_pre_spatial.
pose proof (semaphore_field_offsets_trusted retval PreH6) as Hlayout.
unfold semaphore_byte_layout in Hlayout.
destruct Hlayout as [_ [_ [_ [_ [Hpend _]]]]].
rewrite Hpend. lia.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_spatial : _SemaphoreCreate_entail_wit_1_split_goal_spatial.
Proof.
LLM_pre_process ltac:(lia || int_auto).
sep_apply_l_atomic (semaphore_zero_bytes_object retval (semaphore_field_offsets_trusted retval PreH6) ltac:(lia) PreH5 PreH6).
Intros.
sep_apply_l_atomic (semaphore_zero_insert_ready retval).
unfold os_inv, semaphore_inv. Intros.
match goal with H : semaphore_context _ |- _ =>
  destruct H as [Hmanager [_ [_ [_ [_ Hlist]]]]]
end.
rewrite Hmanager, Hlist.
repeat progress cancel.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_1 : _SemaphoreCreate_entail_wit_1.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_1_split_goal_spatial.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_1_split_goal_1.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_1_split_goal_2.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_1_split_goal_3.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_1_split_goal_4.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_1_split_goal_5.
Qed.

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
Proof. Admitted.

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

