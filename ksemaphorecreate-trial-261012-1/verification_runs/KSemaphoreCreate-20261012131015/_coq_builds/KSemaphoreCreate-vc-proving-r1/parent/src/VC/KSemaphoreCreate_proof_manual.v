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
From CRTOS_Verify.VC Require Import KSemaphoreCreate_goal.
From CRTOS_Verify.VC Require Import KSemaphoreCreate_proof_auto.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.lib.idnode.
Require Import CRTOS_Verify.sem.SemaphorePure.
Require Import CRTOS_Verify.sem.SemaphoreRep.
Require Import CRTOS_Verify.sem.CrtosOSPure.
Require Import CRTOS_Verify.sem.CrtosOSProtocol.
Require Import CRTOS_Verify.sem.CrtosOSInv.
Require Import CRTOS_Verify.sem.SemaphoreCritical.
Require Import CRTOS_Verify.sem.SemaphoreCriticalViews.
Import IDNode.
Import Crtos_C_Rules.
Local Open Scope sac.

Lemma proof_of_KSemaphoreCreate_return_wit_1 : KSemaphoreCreate_return_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Left. Left.
  split_pure_spatial.
  - cancel (SemaphoreOutsideCritical sg hs before).
  - dump_pre_spatial. assumption.
Qed.


Lemma proof_of_KSemaphoreCreate_return_wit_2 : KSemaphoreCreate_return_wit_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Left. Right. Exists current_3.
  split_pure_spatial.
  - cancel (SemaphoreOutsideCritical sg hs current_3).
  - split_pures; dump_pre_spatial; assumption.
Qed.


Lemma proof_of_KSemaphoreCreate_return_wit_3 : KSemaphoreCreate_return_wit_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  Right. Exists current_3 p_2.
  split_pure_spatial.
  - cancel (SemaphoreOutsideCritical sg hs (semaphore_os_publish p_2 retval val_pre current_3)).
  - split_pures; dump_pre_spatial; assumption.
Qed.


Lemma proof_of_KSemaphoreCreate_partial_solve_wit_1_pure : KSemaphoreCreate_partial_solve_wit_1_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.


Lemma proof_of_KSemaphoreCreate_partial_solve_wit_1 : KSemaphoreCreate_partial_solve_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold KSemaphoreCreate_partial_solve_wit_1_aux.
  LLM_pre_process ltac:(lia || int_auto).
Qed.
