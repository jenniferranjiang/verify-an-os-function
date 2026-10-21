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
From CRTOS_Verify.VC Require Import CriticalAreaLock_proof_auto.
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

Lemma proof_of_CriticalAreaLock_entail_wit_1_split_goal_1 : CriticalAreaLock_entail_wit_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  exact (proj1 (proj2 PreH2)).
Qed.

Lemma proof_of_CriticalAreaLock_entail_wit_1_split_goal_spatial : CriticalAreaLock_entail_wit_1_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  sep_apply_l_atomic (SemaphoreOSInvariant_split_nest sg current).
  Intros_p Hvalid.
  cancel (SemaphoreInsideCritical sg hs retval current).
  cancel (&("KTaskOsAssignLockNest") # UShort |-> scheduler_lock_nest (os_scheduler current)).
  cancel (SemaphoreCriticalFrame sg current).
Qed.

Lemma proof_of_CriticalAreaLock_entail_wit_1 : CriticalAreaLock_entail_wit_1.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of_CriticalAreaLock_entail_wit_1_split_goal_spatial.
  - Goal_apply proof_of_CriticalAreaLock_entail_wit_1_split_goal_1.
Qed. 

Lemma proof_of_CriticalAreaLock_return_wit_1 : CriticalAreaLock_return_wit_1.
Proof. Admitted.

Lemma proof_of_CriticalAreaLock_partial_solve_wit_1 : CriticalAreaLock_partial_solve_wit_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed.
