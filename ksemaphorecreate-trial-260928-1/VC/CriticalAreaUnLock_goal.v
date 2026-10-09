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

(*----- Function CriticalAreaUnLock -----*)

Definition CriticalAreaUnLock_safety_wit_1 := 
forall (lock_pre: Z) (after_ordinary: CrtosOSWorld) (before_ordinary: CrtosOSWorld) (stable_ordinary: CrtosOSStable) (PreH1 : (semaphore_irq_handler_ok lock_pre )) (PreH2 : (SemaphoreGuarantee stable_ordinary before_ordinary after_ordinary )) ,
  ((( &( "lock" ) )) # Int  |-> lock_pre)
  **  (SemaphoreInsideCritical lock_pre (@nil Z) stable_ordinary before_ordinary )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> 1)
  **  (crtos_semaphore_os_inv stable_ordinary after_ordinary )
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition CriticalAreaUnLock_return_wit_1 := 
(
forall (lock_pre: Z) (after_ordinary: CrtosOSWorld) (before_ordinary: CrtosOSWorld) (stable_ordinary: CrtosOSStable) (PreH1 : (semaphore_irq_handler_ok lock_pre )) (PreH2 : (SemaphoreGuarantee stable_ordinary before_ordinary after_ordinary )) ,
  (SemaphoreOutsideCritical stable_ordinary after_ordinary )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> (1 - 1 ))
|--
  (SemaphoreCriticalOutside stable_ordinary after_ordinary )
) \/
(
forall (lock_pre: Z) (after_ordinary: CrtosOSWorld) (before_ordinary: CrtosOSWorld) (stable_ordinary: CrtosOSStable) (PreH1 : (semaphore_irq_handler_ok lock_pre )) (PreH2 : (SemaphoreGuarantee stable_ordinary before_ordinary after_ordinary )) ,
  (SemaphoreOutsideCritical stable_ordinary after_ordinary )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> (1 - 1 ))
|--
  (SemaphoreCriticalOutside stable_ordinary after_ordinary )
).

Definition CriticalAreaUnLock_return_wit_1_split_goal_spatial := 
forall (lock_pre: Z) (after_ordinary: CrtosOSWorld) (before_ordinary: CrtosOSWorld) (stable_ordinary: CrtosOSStable) (PreH1 : (semaphore_irq_handler_ok lock_pre )) (PreH2 : (SemaphoreGuarantee stable_ordinary before_ordinary after_ordinary )) ,
  (SemaphoreOutsideCritical stable_ordinary after_ordinary )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> (1 - 1 ))
|--
  (SemaphoreCriticalOutside stable_ordinary after_ordinary )
.

Definition CriticalAreaUnLock_partial_solve_wit_1 := 
forall (lock_pre: Z) (after_ordinary: CrtosOSWorld) (before_ordinary: CrtosOSWorld) (stable_ordinary: CrtosOSStable) (PreH1 : (semaphore_irq_handler_ok lock_pre )) (PreH2 : (SemaphoreGuarantee stable_ordinary before_ordinary after_ordinary )) ,
  (SemaphoreCriticalHeld lock_pre (@nil Z) stable_ordinary before_ordinary )
  **  (crtos_semaphore_os_inv stable_ordinary after_ordinary )
|--
  “ (semaphore_irq_handler_ok lock_pre ) ” 
  &&  “ (SemaphoreGuarantee stable_ordinary before_ordinary after_ordinary ) ”
  &&  (SemaphoreCriticalHeld lock_pre (@nil Z) stable_ordinary before_ordinary )
  **  (crtos_semaphore_os_inv stable_ordinary after_ordinary )
.

Definition CriticalAreaUnLock_partial_solve_wit_2_pure := 
forall (lock_pre: Z) (after_ordinary: CrtosOSWorld) (before_ordinary: CrtosOSWorld) (stable_ordinary: CrtosOSStable) (PreH1 : (semaphore_irq_handler_ok lock_pre )) (PreH2 : (SemaphoreGuarantee stable_ordinary before_ordinary after_ordinary )) ,
  ((( &( "lock" ) )) # Int  |-> lock_pre)
  **  (SemaphoreInsideCritical lock_pre (@nil Z) stable_ordinary before_ordinary )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> (1 - 1 ))
  **  (crtos_semaphore_os_inv stable_ordinary after_ordinary )
|--
  “ (semaphore_irq_handler_ok lock_pre ) ” 
  &&  “ (SemaphoreGuarantee stable_ordinary before_ordinary after_ordinary ) ”
.

Definition CriticalAreaUnLock_partial_solve_wit_2_aux := 
forall (lock_pre: Z) (after_ordinary: CrtosOSWorld) (before_ordinary: CrtosOSWorld) (stable_ordinary: CrtosOSStable) (PreH1 : (semaphore_irq_handler_ok lock_pre )) (PreH2 : (SemaphoreGuarantee stable_ordinary before_ordinary after_ordinary )) ,
  (SemaphoreInsideCritical lock_pre (@nil Z) stable_ordinary before_ordinary )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> (1 - 1 ))
  **  (crtos_semaphore_os_inv stable_ordinary after_ordinary )
|--
  “ (semaphore_irq_handler_ok lock_pre ) ” 
  &&  “ (SemaphoreGuarantee stable_ordinary before_ordinary after_ordinary ) ” 
  &&  “ (semaphore_irq_handler_ok lock_pre ) ” 
  &&  “ (SemaphoreGuarantee stable_ordinary before_ordinary after_ordinary ) ”
  &&  (SemaphoreInsideCritical lock_pre (@nil Z) stable_ordinary before_ordinary )
  **  (crtos_semaphore_os_inv stable_ordinary after_ordinary )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> (1 - 1 ))
.

Definition CriticalAreaUnLock_partial_solve_wit_2 := CriticalAreaUnLock_partial_solve_wit_2_pure -> CriticalAreaUnLock_partial_solve_wit_2_aux.

Definition CriticalAreaUnLock_which_implies_wit_1 := 
(
forall (before_ordinary: CrtosOSWorld) (stable_ordinary: CrtosOSStable) (lock: Z) ,
  (SemaphoreCriticalHeld lock (@nil Z) stable_ordinary before_ordinary )
|--
  (SemaphoreInsideCritical lock (@nil Z) stable_ordinary before_ordinary )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> 1)
) \/
(
forall (before_ordinary: CrtosOSWorld) (stable_ordinary: CrtosOSStable) (lock: Z) ,
  (SemaphoreCriticalHeld lock (@nil Z) stable_ordinary before_ordinary )
|--
  (SemaphoreInsideCritical lock (@nil Z) stable_ordinary before_ordinary )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> 1)
).

Definition CriticalAreaUnLock_which_implies_wit_1_split_goal_spatial := 
forall (before_ordinary: CrtosOSWorld) (stable_ordinary: CrtosOSStable) (lock: Z) ,
  (SemaphoreCriticalHeld lock (@nil Z) stable_ordinary before_ordinary )
|--
  (SemaphoreInsideCritical lock (@nil Z) stable_ordinary before_ordinary )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> 1)
.

Module Type VC_Correct.


Axiom proof_of_CriticalAreaUnLock_safety_wit_1 : CriticalAreaUnLock_safety_wit_1.
Axiom proof_of_CriticalAreaUnLock_return_wit_1 : CriticalAreaUnLock_return_wit_1.
Axiom proof_of_CriticalAreaUnLock_partial_solve_wit_1 : CriticalAreaUnLock_partial_solve_wit_1.
Axiom proof_of_CriticalAreaUnLock_partial_solve_wit_2_pure : CriticalAreaUnLock_partial_solve_wit_2_pure.
Axiom proof_of_CriticalAreaUnLock_partial_solve_wit_2 : CriticalAreaUnLock_partial_solve_wit_2.
Axiom proof_of_CriticalAreaUnLock_which_implies_wit_1 : CriticalAreaUnLock_which_implies_wit_1.

End VC_Correct.
