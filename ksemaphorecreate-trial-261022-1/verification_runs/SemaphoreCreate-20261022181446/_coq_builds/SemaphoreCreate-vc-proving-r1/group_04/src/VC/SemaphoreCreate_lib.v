From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.

(* Current model imports for proof helpers; no generated-artifact dependency. *)
From Coq Require Import Bool Strings.String Classes.RelationClasses Classes.Morphisms.
From Coq Require Import micromega.Psatz Sorting.Permutation.
From AUXLib Require Import int_auto Axioms Feq Idents ListLib VMap.
Require Import SetsClass.SetsClass.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Import KSemaphoreCreateTrial.KSemaphoreCreate.
Require Import TrialShared.CrtosInv TrialShared.SemaphoreInv.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import SetsNotation IDNode DLL Monad MonadNotation.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Local Open Scope monad.
Local Open Scope sac.



(* Bridges proved against the frozen VRTOS interfaces and explicit layout premise. *)
Require Import KSemaphoreCreateTrial.SemaphoreByteLayout.
Require Import KSemaphoreCreateTrial.SemaphoreOwnership.
Require Import KSemaphoreCreateTrial.SemaphoreSpecBridge.
Require Import TrialShared.DoubleLinkListSpec.

Lemma new_object_payload__list_prepare : forall wait p id val,
  p <> 0 -> addr_aligned p 4 -> &(p # "Semaphore" ->ₛ "pend_list") <> 0 ->
  store_node_self_linked (&(p # "Semaphore" ->ₛ "pend_list")) **
  &(p # "Semaphore" ->ₛ "value") # UShort |-> val **
  SemaphorePadding p ** NodeZero (&(p # "Semaphore" ->ₛ "link")) |--
  store_semaphore wait (&(p # "Semaphore" ->ₛ "link")) (semaphore_created p id val) **
  occupy_dll_node (&(p # "Semaphore" ->ₛ "link")).
Proof.
  intros wait p id val Hp Ha Hpend.
  unfold store_semaphore, semaphore_created; cbn.
  unfold store_dll, store_node_self_linked, NodeZero, occupy_dll_node.
  Exists (&(p # "Semaphore" ->ₛ "pend_list")) (&(p # "Semaphore" ->ₛ "pend_list")) 0 0.
  cbn [dllseg].
  split_pure_spatial; [sepcon_right_assoc; cancel | split_pures; dump_pre_spatial; repeat split; auto; constructor].
Qed.

Lemma pend_zero_ready__list_prepare : forall p,
  NodeZero (&(p # "Semaphore" ->ₛ "pend_list")) |--
  &(p # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev") # Ptr |->_ **
  &(p # "Semaphore" ->ₛ "pend_list" .ₛ "node_next") # Ptr |->_ .
Proof.
  intros p. unfold NodeZero.
  set (q := (&(p # "Semaphore" ->ₛ "pend_list") : addr)).
  assert (Hprev : &(p # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev") =
    &(q # "SysDoubleLinklistNode" ->ₛ "node_prev")).
  { unfold q. simpl. rewrite addr_of_arrow_field, eval_addr. reflexivity. }
  assert (Hnext : &(p # "Semaphore" ->ₛ "pend_list" .ₛ "node_next") =
    &(q # "SysDoubleLinklistNode" ->ₛ "node_next")).
  { unfold q. simpl. rewrite addr_of_arrow_field, eval_addr. reflexivity. }
  rewrite Hprev, Hnext. fold q.
  sep_apply_l_atomic (store_ptr_undef_store_ptr (&(q # "SysDoubleLinklistNode" ->ₛ "node_prev")) 0).
  sep_apply_l_atomic (store_ptr_undef_store_ptr (&(q # "SysDoubleLinklistNode" ->ₛ "node_next")) 0).
  sepcon_right_assoc; cancel.
Qed.
