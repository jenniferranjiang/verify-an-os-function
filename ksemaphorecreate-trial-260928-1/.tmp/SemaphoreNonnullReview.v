Require Import Coq.ZArith.ZArith.
Require Import Coq.micromega.Lia.
Require Import Coq.Lists.List.
Require Import Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic CNotation.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import CRTOS_Verify.sem.SemaphorePure.
Require Import CRTOS_Verify.sem.SemaphoreRep.
Require Import CRTOS_Verify.sem.CrtosOSProtocol.
Import CrtosOS_C_Rules.

Import ListNotations.
Local Open Scope Z_scope.
Local Open Scope string_scope.
Local Open Scope sac.

Lemma review_id_payload_node_nonnull :
  forall node object,
    store_semaphore_id_payload node object |--
      “ node <> 0 ”.
Proof.
  intros node [sem id value pending].
  unfold store_semaphore_id_payload; simpl.
  unfold semaphore_layout_32_ok, store_ushort, isvalidptr_short.
  entailer!.
Qed.

Lemma review_registry_payload_node_nonnull :
  forall node object,
    “ semaphore_layout_32_ok object.(semaphore_addr) ” &&
      store_semaphore_body node object |--
      “ node <> 0 ”.
Proof.
  intros node [sem id value pending].
  unfold store_semaphore_body; simpl.
  unfold semaphore_layout_32_ok, store_ushort, isvalidptr_short.
  entailer!.
Qed.

Lemma review_id_insert_ready_link_nonnull :
  forall sem id,
    “ semaphore_layout_32_ok sem ” &&
      store_sem_id_node_insert_ready sem id |--
      “ &(sem # "Semaphore" ->ₛ "id" .ₛ "link") <> 0 ”.
Proof.
  intros sem id.
  unfold store_sem_id_node_insert_ready.
  unfold semaphore_layout_32_ok, store_ushort, isvalidptr_short.
  entailer!.
Qed.

Lemma review_after_id_registry_link_nonnull :
  forall sem,
    “ semaphore_layout_32_ok sem ” &&
      store_sem_after_id_insert_private sem |--
      “ &(sem # "Semaphore" ->ₛ "link") <> 0 ”.
Proof.
  intros sem.
  unfold store_sem_after_id_insert_private.
  unfold semaphore_layout_32_ok, store_ushort, isvalidptr_short.
  entailer!.
Qed.
