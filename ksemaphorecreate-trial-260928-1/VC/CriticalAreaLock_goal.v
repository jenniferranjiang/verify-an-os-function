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

(*----- Function CriticalAreaLock -----*)

Definition CriticalAreaLock_return_wit_1 := 
(
forall (before_ordinary: CrtosOSWorld) (stable_ordinary: CrtosOSStable) (retval: Z) (handler_2: Z) (current_2: CrtosOSWorld) (PreH1 : (retval = handler_2)) (PreH2 : (semaphore_irq_handler_ok handler_2 )) (PreH3 : (SemaphoreRely stable_ordinary before_ordinary current_2 )) ,
  (SemaphoreInsideCritical handler_2 (@nil Z) stable_ordinary current_2 )
  **  (crtos_semaphore_os_inv stable_ordinary current_2 )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> (0 + 1 ))
|--
  EX (current: CrtosOSWorld)  (handler: Z) ,
  “ (retval = handler) ” 
  &&  “ (semaphore_irq_handler_ok handler ) ” 
  &&  “ (SemaphoreRely stable_ordinary before_ordinary current ) ”
  &&  (SemaphoreCriticalHeld handler (@nil Z) stable_ordinary current )
  **  (crtos_semaphore_os_inv stable_ordinary current )
) \/
(
forall (before_ordinary: CrtosOSWorld) (stable_ordinary: CrtosOSStable) (retval: Z) (handler_2: Z) (current_2: CrtosOSWorld) (PreH1 : (retval = handler_2)) (PreH2 : (semaphore_irq_handler_ok handler_2 )) (PreH3 : (SemaphoreRely stable_ordinary before_ordinary current_2 )) ,
  (SemaphoreInsideCritical handler_2 (@nil Z) stable_ordinary current_2 )
  **  (crtos_semaphore_os_inv stable_ordinary current_2 )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> (0 + 1 ))
|--
  EX (current: CrtosOSWorld) ,
  “ (semaphore_irq_handler_ok retval ) ” 
  &&  “ (SemaphoreRely stable_ordinary before_ordinary current ) ”
  &&  (SemaphoreCriticalHeld retval (@nil Z) stable_ordinary current )
  **  (crtos_semaphore_os_inv stable_ordinary current )
).

Definition CriticalAreaLock_partial_solve_wit_1 := 
forall (before_ordinary: CrtosOSWorld) (stable_ordinary: CrtosOSStable) ,
  (SemaphoreCriticalOutside stable_ordinary before_ordinary )
|--
  (SemaphoreCriticalOutside stable_ordinary before_ordinary )
.

Definition CriticalAreaLock_partial_solve_wit_2 := 
forall (before_ordinary: CrtosOSWorld) (stable_ordinary: CrtosOSStable) ,
  (SemaphoreOutsideCritical stable_ordinary before_ordinary )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> 0)
|--
  (SemaphoreOutsideCritical stable_ordinary before_ordinary )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> 0)
.

Definition CriticalAreaLock_which_implies_wit_1 := 
(
forall (before_ordinary: CrtosOSWorld) (stable_ordinary: CrtosOSStable) ,
  (SemaphoreCriticalOutside stable_ordinary before_ordinary )
|--
  (SemaphoreOutsideCritical stable_ordinary before_ordinary )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> 0)
) \/
(
forall (before_ordinary: CrtosOSWorld) (stable_ordinary: CrtosOSStable) ,
  (SemaphoreCriticalOutside stable_ordinary before_ordinary )
|--
  (SemaphoreOutsideCritical stable_ordinary before_ordinary )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> 0)
).

Definition CriticalAreaLock_which_implies_wit_1_split_goal_spatial := 
forall (before_ordinary: CrtosOSWorld) (stable_ordinary: CrtosOSStable) ,
  (SemaphoreCriticalOutside stable_ordinary before_ordinary )
|--
  (SemaphoreOutsideCritical stable_ordinary before_ordinary )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> 0)
.

Module Type VC_Correct.


Axiom proof_of_CriticalAreaLock_return_wit_1 : CriticalAreaLock_return_wit_1.
Axiom proof_of_CriticalAreaLock_partial_solve_wit_1 : CriticalAreaLock_partial_solve_wit_1.
Axiom proof_of_CriticalAreaLock_partial_solve_wit_2 : CriticalAreaLock_partial_solve_wit_2.
Axiom proof_of_CriticalAreaLock_which_implies_wit_1 : CriticalAreaLock_which_implies_wit_1.

End VC_Correct.
