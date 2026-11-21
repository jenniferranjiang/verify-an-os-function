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
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  pose proof PreH2 as Hr.
  unfold idmanager_min_free_id in Hr.
  pose proof PreH10 as Hctx.
  unfold semaphore_context in Hctx.
  unfold NodeZero.
  destruct Hr as [[Hlo Hhi] _].
  destruct Hctx as [_ [Hmax _]].
  rewrite Hmax in Hhi.
  split_pure_spatial.
  - repeat progress cancel.
    assert (Hp : &(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev") =
       (let pend := &(sem # "Semaphore" ->ₛ "pend_list") in &(pend # "SysDoubleLinklistNode" ->ₛ "node_prev")))
      by (simpl; rewrite addr_of_arrow_field, eval_addr; reflexivity).
    assert (Hn : &(sem # "Semaphore" ->ₛ "pend_list" .ₛ "node_next") =
       (let pend := &(sem # "Semaphore" ->ₛ "pend_list") in &(pend # "SysDoubleLinklistNode" ->ₛ "node_next")))
      by (simpl; rewrite addr_of_arrow_field, eval_addr; reflexivity).
    rewrite Hp, Hn.
    set (pend := (&(sem # "Semaphore" ->ₛ "pend_list")) : addr).
    sep_apply (store_ptr_undef_store_ptr (&(pend # "SysDoubleLinklistNode" ->ₛ "node_prev")) 0).
    sep_apply (store_ptr_undef_store_ptr (&(pend # "SysDoubleLinklistNode" ->ₛ "node_next")) 0).
    cbn zeta. cancel.
  - split_pures; dump_pre_spatial; auto.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_4_split_goal_spatial : _SemaphoreCreate_entail_wit_4_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold store_semaphore, semaphore_created; cbn [semaphore_addr semaphore_value semaphore_pending_addrs map].
  repeat progress cancel.
  unfold store_node_self_linked, NodeZero, occupy_dll_node.
  unfold store_dll.
  Exists (&(sem # "Semaphore" ->ₛ "pend_list")) (&(sem # "Semaphore" ->ₛ "pend_list")) 0 0.
  cbn [dllseg].
  cbn zeta beta.
  split_pure_spatial.
  - set (pend := (&(sem # "Semaphore" ->ₛ "pend_list")) : addr).
    set (link := (&(sem # "Semaphore" ->ₛ "link")) : addr).
    sepcon_assoc_change. cancel.
  - split_pures; dump_pre_spatial; unfold dll_nodes_nonzero; repeat split; auto; constructor.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_4 : _SemaphoreCreate_entail_wit_4.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreCreate_entail_wit_4_split_goal_spatial.
Qed.

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
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  unfold DoubleLinkListSpec.dll_insert_anchor. right; reflexivity.
Qed.

Lemma proof_of__SemaphoreCreate_partial_solve_wit_6_pure : _SemaphoreCreate_partial_solve_wit_6_pure.
Proof.
  aggressive_pre_process.
  Goal_apply proof_of__SemaphoreCreate_partial_solve_wit_6_pure_split_goal_1.
Qed.

