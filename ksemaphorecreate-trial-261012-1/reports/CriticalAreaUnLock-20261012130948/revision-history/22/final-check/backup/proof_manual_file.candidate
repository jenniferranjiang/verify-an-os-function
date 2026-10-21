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
From CRTOS_Verify.VC Require Import CriticalAreaUnLock_goal.
From CRTOS_Verify.VC Require Import CriticalAreaUnLock_proof_auto.
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

Lemma proof_of_CriticalAreaUnLock_entail_wit_1_split_goal_1 : CriticalAreaUnLock_entail_wit_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  sep_apply_l_atomic (SemaphoreOSInvariant_split_nest sg after).
  Intros_p Hvalid.
  dump_pre_spatial. exact Hvalid.
Qed.

Lemma proof_of_CriticalAreaUnLock_entail_wit_1_split_goal_spatial : CriticalAreaUnLock_entail_wit_1_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  sep_apply_l_atomic (SemaphoreOSInvariant_split_nest sg after).
  Intros_p Hvalid.
  cancel (SemaphoreInsideCritical sg hs lock_pre before).
  cancel (SemaphoreCriticalFrame sg after).
  cancel (&("KTaskOsAssignLockNest") # UShort |-> scheduler_lock_nest (os_scheduler after)).
Qed.

Lemma proof_of_CriticalAreaUnLock_entail_wit_1 : CriticalAreaUnLock_entail_wit_1.
Proof.
  aggressive_pre_process.
  - Goal_apply (proof_of_CriticalAreaUnLock_entail_wit_1_split_goal_spatial lock_pre after before hs sg).
  - Goal_apply (proof_of_CriticalAreaUnLock_entail_wit_1_split_goal_1 lock_pre after before hs sg).
Qed. 

Lemma proof_of_CriticalAreaUnLock_entail_wit_2_1_split_goal_spatial : CriticalAreaUnLock_entail_wit_2_1_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hnest : 0 <= scheduler_lock_nest (os_scheduler after) <= 65535).
  { match goal with H : CrtosOSValid after |- _ => destruct H as [_ [_ [Hnest _]]]; exact Hnest end. }
  unfold unsigned_last_nbits.
  change (2 ^ 16) with 65536.
  rewrite Z.mod_small by lia.
  sep_apply_r_atomic (SemaphoreOSInvariant_merge_decrement sg after).
  rewrite Z.max_r by lia.
  split_pure_spatial.
  - cancel (SemaphoreInsideCritical sg hs lock_pre before).
    cancel (SemaphoreCriticalFrame sg after).
    cancel (&("KTaskOsAssignLockNest") # UShort |-> (scheduler_lock_nest (os_scheduler after) - 1)).
  - dump_pre_spatial. assumption.
Qed.

Lemma proof_of_CriticalAreaUnLock_entail_wit_2_1 : CriticalAreaUnLock_entail_wit_2_1.
Proof.
  aggressive_pre_process.
  Goal_apply (proof_of_CriticalAreaUnLock_entail_wit_2_1_split_goal_spatial lock_pre after before hs sg).
Qed. 

Lemma proof_of_CriticalAreaUnLock_entail_wit_2_2_split_goal_spatial : CriticalAreaUnLock_entail_wit_2_2_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Hnest : 0 <= scheduler_lock_nest (os_scheduler after) <= 65535).
  { match goal with H : CrtosOSValid after |- _ => destruct H as [_ [_ [Hnest _]]]; exact Hnest end. }
  assert (Hzero : scheduler_lock_nest (os_scheduler after) = 0) by lia.
  sep_apply_r_atomic (SemaphoreOSInvariant_merge_decrement sg after).
  rewrite Hzero. cbn.
  split_pure_spatial.
  - cancel (SemaphoreInsideCritical sg hs lock_pre before).
    cancel (SemaphoreCriticalFrame sg after).
    cancel (&("KTaskOsAssignLockNest") # UShort |-> 0).
  - dump_pre_spatial. assumption.
Qed.

Lemma proof_of_CriticalAreaUnLock_entail_wit_2_2 : CriticalAreaUnLock_entail_wit_2_2.
Proof.
  aggressive_pre_process.
  Goal_apply (proof_of_CriticalAreaUnLock_entail_wit_2_2_split_goal_spatial lock_pre after before hs sg).
Qed.

Lemma proof_of_CriticalAreaUnLock_safety_wit_1 : CriticalAreaUnLock_safety_wit_1.
Proof.
  LLM_pre_process ltac:(lia || assumption).
Qed. 


Lemma proof_of_CriticalAreaUnLock_return_wit_1 : CriticalAreaUnLock_return_wit_1.
Proof.
  LLM_pre_process ltac:(lia || assumption).
Qed. 


Lemma proof_of_CriticalAreaUnLock_partial_solve_wit_1_pure : CriticalAreaUnLock_partial_solve_wit_1_pure.
Proof.
  LLM_pre_process ltac:(lia || assumption).
Qed. 


Lemma proof_of_CriticalAreaUnLock_partial_solve_wit_1 : CriticalAreaUnLock_partial_solve_wit_1.
Proof.
  LLM_pre_process ltac:(lia || assumption).
  LLM_pre_process ltac:(lia || assumption).
Qed.
