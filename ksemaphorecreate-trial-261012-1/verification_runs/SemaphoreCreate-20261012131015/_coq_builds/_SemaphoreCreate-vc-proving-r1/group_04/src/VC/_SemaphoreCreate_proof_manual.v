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
From CRTOS_Verify.VC Require Import _SemaphoreCreate_goal.
From CRTOS_Verify.VC Require Import _SemaphoreCreate_proof_auto.
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
Require Coq.Program.Basics.
Local Open Scope sac.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_1 : _SemaphoreCreate_entail_wit_1_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_2 : _SemaphoreCreate_entail_wit_1_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_3 : _SemaphoreCreate_entail_wit_1_split_goal_3.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1_split_goal_spatial : _SemaphoreCreate_entail_wit_1_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_1 : _SemaphoreCreate_entail_wit_1.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_1 : _SemaphoreCreate_entail_wit_2_1_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  dump_pre_spatial.
  destruct PreH9 as [_ [Hvalid [Hnest _]]].
  pose proof Hvalid as Hbounds.
  unfold CrtosOSValid in Hbounds.
  destruct Hbounds as [_ [_ [Hbounds _]]].
  rewrite semaphore_nesting_roundtrip_bounded by lia.
  unfold SemaphoreGuarantee; auto.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_spatial : _SemaphoreCreate_entail_wit_2_1_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  assert (Esep : forall P Q, OSHeap (Task_C_Rules.sepcon P Q) = OSHeap P ** OSHeap Q).
  { intros; apply functional_extensionality; intro m.
    apply propositional_extensionality; apply CrtosHeapBridge.crtos_heap_lift_sep. }
  assert (Epure : forall P Q, OSHeap (Task_C_Rules.andp (Task_C_Rules.coq_prop P) Q) = “ P ” && OSHeap Q).
  { intros; apply functional_extensionality; intro m.
    apply propositional_extensionality.
    unfold OSHeap, CrtosHeapBridge.crtos_heap_lift, Task_C_Rules.andp, Task_C_Rules.coq_prop, andp, coq_prop; tauto. }
  unfold SemaphoreInsideCritical.
  Intros_p Hinside.
  destruct Hinside as [Hstable [Hstack Hzero]].
  pose proof Hstable as Hmanager.
  unfold SemaphoreStableContext in Hmanager.
  destruct Hmanager as [Hmanager _].
  pose proof (proj1 PreH11) as Hsemvalid.
  unfold SemaphoreOSInvariant, store_semaphore, store_sem_manager,
    store_sem_zeroed_private, store_sem_registered_private.
  repeat rewrite Epure.
  repeat rewrite Esep.
  replace (os_tasks (semaphore_nest_increment current)) with (os_tasks current) by reflexivity.
  replace (os_semaphores (semaphore_nest_increment current)) with (os_semaphores current) by reflexivity.
  rewrite Hmanager.
  LLM_pre_process ltac:(tauto || lia || int_auto).
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_2_1 : _SemaphoreCreate_entail_wit_2_1.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_spatial.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_2_1_split_goal_1.
Qed. 

Lemma proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_1 : _SemaphoreCreate_entail_wit_2_2_split_goal_1.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold idmanager_min_free_id in PreH2.
  destruct PreH2 as [Hbound _].
  exfalso; lia.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_2 : _SemaphoreCreate_entail_wit_2_2_split_goal_2.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold idmanager_min_free_id in PreH2.
  destruct PreH2 as [Hbound _].
  exfalso; lia.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_3 : _SemaphoreCreate_entail_wit_2_2_split_goal_3.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold idmanager_min_free_id in PreH2.
  destruct PreH2 as [Hbound _].
  exfalso; lia.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_spatial : _SemaphoreCreate_entail_wit_2_2_split_goal_spatial.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold idmanager_min_free_id in PreH2.
  destruct PreH2 as [Hbound _].
  exfalso; lia.
Qed.

Lemma proof_of__SemaphoreCreate_entail_wit_2_2 : _SemaphoreCreate_entail_wit_2_2.
Proof.
  aggressive_pre_process.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_spatial.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_1.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_2.
  - Goal_apply proof_of__SemaphoreCreate_entail_wit_2_2_split_goal_3.
Qed. 

Lemma proof_of__SemaphoreCreate_entail_wit_3 : _SemaphoreCreate_entail_wit_3.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_entail_wit_4 : _SemaphoreCreate_entail_wit_4.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_entail_wit_5_split_goal_1 : _SemaphoreCreate_entail_wit_5_split_goal_1.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_5_split_goal_2 : _SemaphoreCreate_entail_wit_5_split_goal_2.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_5_split_goal_spatial : _SemaphoreCreate_entail_wit_5_split_goal_spatial.
Proof. Abort.

Lemma proof_of__SemaphoreCreate_entail_wit_5 : _SemaphoreCreate_entail_wit_5.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_return_wit_1 : _SemaphoreCreate_return_wit_1.
Proof. Admitted. 

Lemma proof_of__SemaphoreCreate_return_wit_2 : _SemaphoreCreate_return_wit_2.
Proof. Admitted.

Lemma proof_of__SemaphoreCreate_safety_wit_1 : _SemaphoreCreate_safety_wit_1.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_2 : _SemaphoreCreate_safety_wit_2.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_3 : _SemaphoreCreate_safety_wit_3.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_4 : _SemaphoreCreate_safety_wit_4.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_5 : _SemaphoreCreate_safety_wit_5.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_6 : _SemaphoreCreate_safety_wit_6.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_7 : _SemaphoreCreate_safety_wit_7.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_8 : _SemaphoreCreate_safety_wit_8.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_9 : _SemaphoreCreate_safety_wit_9.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_10 : _SemaphoreCreate_safety_wit_10.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_11 : _SemaphoreCreate_safety_wit_11.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_12 : _SemaphoreCreate_safety_wit_12.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_13 : _SemaphoreCreate_safety_wit_13.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_14 : _SemaphoreCreate_safety_wit_14.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_15 : _SemaphoreCreate_safety_wit_15.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_16 : _SemaphoreCreate_safety_wit_16.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_safety_wit_17 : _SemaphoreCreate_safety_wit_17.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_return_wit_3 : _SemaphoreCreate_return_wit_3.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_1_pure : _SemaphoreCreate_partial_solve_wit_1_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_1 : _SemaphoreCreate_partial_solve_wit_1.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_2_pure : _SemaphoreCreate_partial_solve_wit_2_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_2 : _SemaphoreCreate_partial_solve_wit_2.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_3_pure : _SemaphoreCreate_partial_solve_wit_3_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_3 : _SemaphoreCreate_partial_solve_wit_3.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_4_pure : _SemaphoreCreate_partial_solve_wit_4_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_4 : _SemaphoreCreate_partial_solve_wit_4.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_5 : _SemaphoreCreate_partial_solve_wit_5.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_6_pure : _SemaphoreCreate_partial_solve_wit_6_pure.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_6 : _SemaphoreCreate_partial_solve_wit_6.
Proof.
  LLM_pre_process ltac:(lia || int_auto).
  unfold _SemaphoreCreate_partial_solve_wit_6_aux.
  LLM_pre_process ltac:(lia || int_auto).
Qed. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_7_pure : _SemaphoreCreate_partial_solve_wit_7_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_7 : _SemaphoreCreate_partial_solve_wit_7.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_8_pure : _SemaphoreCreate_partial_solve_wit_8_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_8 : _SemaphoreCreate_partial_solve_wit_8.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_9_pure : _SemaphoreCreate_partial_solve_wit_9_pure.
Proof. Admitted. 


Lemma proof_of__SemaphoreCreate_partial_solve_wit_9 : _SemaphoreCreate_partial_solve_wit_9.
Proof. Admitted.
