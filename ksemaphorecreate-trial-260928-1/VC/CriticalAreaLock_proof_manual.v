Require Import Coq.ZArith.ZArith.
Require Import Coq.Bool.Bool.
Require Import Coq.Strings.String.
Require Import Coq.Strings.Ascii.
Require Import Coq.Lists.List.
Require Import Coq.Classes.RelationClasses.
Require Import Coq.Classes.Morphisms.
Require Import Coq.micromega.Psatz.
Require Import Coq.Sorting.Permutation.
From AUXLib Require Import int_auto Axioms Feq Idents ListLib VMap.
Require Import SetsClass.SetsClass. Import SetsNotation.
From SimpleC.SL Require Import Mem SeparationLogic.
From CRTOS_Verify.VC Require Import CriticalAreaLock_goal.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.sem.CrtosOSProtocol.
Import CrtosOS_C_Rules.
Require Import CRTOS_Verify.sem.CrtosOSPure.
Require Import CRTOS_Verify.sem.SemaphoreProtocol.
Require Import CRTOS_Verify.sem.CrtosOSRep.
Require Import CRTOS_Verify.sem.SemaphoreCritical.
Local Open Scope sac.

Lemma proof_of_CriticalAreaLock_return_wit_1 : CriticalAreaLock_return_wit_1.
Proof.
  unfold CriticalAreaLock_return_wit_1.
  left.
  intros.
  Exists current_2 handler_2.
  unfold SemaphoreCriticalHeld, store_semaphore_critical_nest.
  simpl.
  entailer!.
  unfold semaphore_handler_stack_ok.
  split.
  - constructor; [exact PreH2 | constructor].
  - change (1 <= 65535). lia.
Qed.

Lemma proof_of_CriticalAreaLock_which_implies_wit_1_split_goal_spatial : CriticalAreaLock_which_implies_wit_1_split_goal_spatial.
Proof.
  unfold CriticalAreaLock_which_implies_wit_1_split_goal_spatial.
  intros.
  unfold SemaphoreCriticalOutside, store_semaphore_critical_nest.
  simpl.
  entailer!.
Qed.

Lemma proof_of_CriticalAreaLock_which_implies_wit_1 : CriticalAreaLock_which_implies_wit_1.
Proof.
  left.
  exact proof_of_CriticalAreaLock_which_implies_wit_1_split_goal_spatial.
Qed.
