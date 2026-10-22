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

Lemma published_manager__publish : forall sidm ss p id val,
  hoffset sidm = 16 ->
  semaphore_manager (semaphore_publish p id val ss) =
  idmanager_link sidm (idmanager_add (semaphore_manager ss) id)
    id (&(p # "Semaphore" ->ₛ "id")).
Proof.
  intros sidm ss p id val Hoffset.
  unfold semaphore_manager, semaphore_publish, idmanager_link,
    idmanager_add, idmanager_insert_bucket, idlist_add.
  simpl idlist; simpl idbuckets. rewrite Hoffset.
  assert (Hrange : 0 <= id mod 16 < 16) by (apply Z.mod_pos_bound; lia).
  assert (Hcases : id mod 16 = 0 \/ id mod 16 = 1 \/ id mod 16 = 2 \/ id mod 16 = 3 \/ id mod 16 = 4 \/ id mod 16 = 5 \/ id mod 16 = 6 \/ id mod 16 = 7 \/ id mod 16 = 8 \/ id mod 16 = 9 \/ id mod 16 = 10 \/ id mod 16 = 11 \/ id mod 16 = 12 \/ id mod 16 = 13 \/ id mod 16 = 14 \/ id mod 16 = 15) by lia.
  destruct Hcases as [Hk|[Hk|[Hk|[Hk|[Hk|[Hk|[Hk|[Hk|[Hk|[Hk|[Hk|[Hk|[Hk|[Hk|[Hk|Hk]]]]]]]]]]]]]]];
    cbn [map seq filter semaphore_created semaphore_id semaphore_idnode semaphore_addr];
    rewrite Hk; reflexivity.
Qed.

Lemma task_world_replace__publish : forall st ss,
  task_world_wf st -> task_world_wf (replace_semaphores ss st).
Proof.
  intros st ss H; destruct H; constructor; assumption.
Qed.

Lemma published_world_wf__publish : forall sg st p id val,
  os_world_wf sg st ->
  os_world_wf sg (replace_semaphores (semaphore_publish p id val (os_semaphores st)) st).
Proof.
  intros sg st p id val H. destruct H as [Hcontext Hrecycler Hidle Hcoverage].
  constructor; try assumption.
Qed.

Lemma task_inv_replace__publish : forall sg st ss,
  task_inv sg st |-- task_inv sg (replace_semaphores ss st).
Proof.
  intros sg st ss. unfold task_inv.
  Intros_p Hwf. split_pure_spatial.
  - cbn [replace_semaphores os_tasks]. cancel.
  - dump_pre_spatial. apply task_world_replace__publish. exact Hwf.
Qed.
