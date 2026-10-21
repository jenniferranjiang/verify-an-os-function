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

(*----- Function CriticalAreaUnLock -----*)

Definition CriticalAreaUnLock_safety_wit_1 := 
forall (lock_pre: Z) (after: CrtosOSState) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (PreH1 : (semaphore_irq_handler_ok lock_pre )) (PreH2 : (SemaphoreGuarantee before (semaphore_nest_decrement (after)) )) (PreH3 : (CrtosOSValid after )) ,
  ((( &( "lock" ) )) # Int  |-> lock_pre)
  **  (SemaphoreInsideCritical sg hs lock_pre before )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> (scheduler_lock_nest ((os_scheduler (after)))))
  **  (SemaphoreCriticalFrame sg after )
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition CriticalAreaUnLock_entail_wit_1 := 
(
forall (lock_pre: Z) (after: CrtosOSState) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (PreH1 : (semaphore_irq_handler_ok lock_pre )) (PreH2 : (SemaphoreGuarantee before (semaphore_nest_decrement (after)) )) ,
  (SemaphoreInsideCritical sg hs lock_pre before )
  **  (SemaphoreOSInvariant sg after )
|--
  “ (semaphore_irq_handler_ok lock_pre ) ” 
  &&  “ (SemaphoreGuarantee before (semaphore_nest_decrement (after)) ) ” 
  &&  “ (CrtosOSValid after ) ”
  &&  (SemaphoreInsideCritical sg hs lock_pre before )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> (scheduler_lock_nest ((os_scheduler (after)))))
  **  (SemaphoreCriticalFrame sg after )
) \/
(
forall (lock_pre: Z) (after: CrtosOSState) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (PreH1 : (semaphore_irq_handler_ok lock_pre )) (PreH2 : (SemaphoreGuarantee before (semaphore_nest_decrement (after)) )) ,
  (SemaphoreInsideCritical sg hs lock_pre before )
  **  (SemaphoreOSInvariant sg after )
|--
  “ (CrtosOSValid after ) ”
  &&  (SemaphoreInsideCritical sg hs lock_pre before )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> (scheduler_lock_nest ((os_scheduler (after)))))
  **  (SemaphoreCriticalFrame sg after )
).

Definition CriticalAreaUnLock_entail_wit_1_split_goal_1 := 
forall (lock_pre: Z) (after: CrtosOSState) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (PreH1 : (semaphore_irq_handler_ok lock_pre )) (PreH2 : (SemaphoreGuarantee before (semaphore_nest_decrement (after)) )) ,
  (SemaphoreInsideCritical sg hs lock_pre before )
  **  (SemaphoreOSInvariant sg after )
|--
  “ (CrtosOSValid after ) ”
.

Definition CriticalAreaUnLock_entail_wit_1_split_goal_spatial := 
forall (lock_pre: Z) (after: CrtosOSState) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (PreH1 : (semaphore_irq_handler_ok lock_pre )) (PreH2 : (SemaphoreGuarantee before (semaphore_nest_decrement (after)) )) ,
  (SemaphoreInsideCritical sg hs lock_pre before )
  **  (SemaphoreOSInvariant sg after )
|--
  (SemaphoreInsideCritical sg hs lock_pre before )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> (scheduler_lock_nest ((os_scheduler (after)))))
  **  (SemaphoreCriticalFrame sg after )
.

Definition CriticalAreaUnLock_entail_wit_2_1 := 
(
forall (lock_pre: Z) (after: CrtosOSState) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (PreH1 : ((scheduler_lock_nest ((os_scheduler (after)))) >= 1)) (PreH2 : (semaphore_irq_handler_ok lock_pre )) (PreH3 : (SemaphoreGuarantee before (semaphore_nest_decrement (after)) )) (PreH4 : (CrtosOSValid after )) ,
  (SemaphoreInsideCritical sg hs lock_pre before )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> (unsigned_last_nbits (((scheduler_lock_nest ((os_scheduler (after)))) - 1 )) (16)))
  **  (SemaphoreCriticalFrame sg after )
|--
  “ (semaphore_irq_handler_ok lock_pre ) ” 
  &&  “ (SemaphoreGuarantee before (semaphore_nest_decrement (after)) ) ”
  &&  (SemaphoreInsideCritical sg hs lock_pre before )
  **  (SemaphoreOSInvariant sg (semaphore_nest_decrement (after)) )
) \/
(
forall (lock_pre: Z) (after: CrtosOSState) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (PreH1 : ((scheduler_lock_nest ((os_scheduler (after)))) >= 1)) (PreH2 : (semaphore_irq_handler_ok lock_pre )) (PreH3 : (SemaphoreGuarantee before (semaphore_nest_decrement (after)) )) (PreH4 : (CrtosOSValid after )) ,
  (SemaphoreInsideCritical sg hs lock_pre before )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> (unsigned_last_nbits (((scheduler_lock_nest ((os_scheduler (after)))) - 1 )) (16)))
  **  (SemaphoreCriticalFrame sg after )
|--
  (SemaphoreInsideCritical sg hs lock_pre before )
  **  (SemaphoreOSInvariant sg (semaphore_nest_decrement (after)) )
).

Definition CriticalAreaUnLock_entail_wit_2_1_split_goal_spatial := 
forall (lock_pre: Z) (after: CrtosOSState) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (PreH1 : ((scheduler_lock_nest ((os_scheduler (after)))) >= 1)) (PreH2 : (semaphore_irq_handler_ok lock_pre )) (PreH3 : (SemaphoreGuarantee before (semaphore_nest_decrement (after)) )) (PreH4 : (CrtosOSValid after )) ,
  (SemaphoreInsideCritical sg hs lock_pre before )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> (unsigned_last_nbits (((scheduler_lock_nest ((os_scheduler (after)))) - 1 )) (16)))
  **  (SemaphoreCriticalFrame sg after )
|--
  (SemaphoreInsideCritical sg hs lock_pre before )
  **  (SemaphoreOSInvariant sg (semaphore_nest_decrement (after)) )
.

Definition CriticalAreaUnLock_entail_wit_2_2 := 
(
forall (lock_pre: Z) (after: CrtosOSState) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (PreH1 : ((scheduler_lock_nest ((os_scheduler (after)))) < 1)) (PreH2 : (semaphore_irq_handler_ok lock_pre )) (PreH3 : (SemaphoreGuarantee before (semaphore_nest_decrement (after)) )) (PreH4 : (CrtosOSValid after )) ,
  (SemaphoreInsideCritical sg hs lock_pre before )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> (scheduler_lock_nest ((os_scheduler (after)))))
  **  (SemaphoreCriticalFrame sg after )
|--
  “ (semaphore_irq_handler_ok lock_pre ) ” 
  &&  “ (SemaphoreGuarantee before (semaphore_nest_decrement (after)) ) ”
  &&  (SemaphoreInsideCritical sg hs lock_pre before )
  **  (SemaphoreOSInvariant sg (semaphore_nest_decrement (after)) )
) \/
(
forall (lock_pre: Z) (after: CrtosOSState) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (PreH1 : ((scheduler_lock_nest ((os_scheduler (after)))) < 1)) (PreH2 : (semaphore_irq_handler_ok lock_pre )) (PreH3 : (SemaphoreGuarantee before (semaphore_nest_decrement (after)) )) (PreH4 : (CrtosOSValid after )) ,
  (SemaphoreInsideCritical sg hs lock_pre before )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> (scheduler_lock_nest ((os_scheduler (after)))))
  **  (SemaphoreCriticalFrame sg after )
|--
  (SemaphoreInsideCritical sg hs lock_pre before )
  **  (SemaphoreOSInvariant sg (semaphore_nest_decrement (after)) )
).

Definition CriticalAreaUnLock_entail_wit_2_2_split_goal_spatial := 
forall (lock_pre: Z) (after: CrtosOSState) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (PreH1 : ((scheduler_lock_nest ((os_scheduler (after)))) < 1)) (PreH2 : (semaphore_irq_handler_ok lock_pre )) (PreH3 : (SemaphoreGuarantee before (semaphore_nest_decrement (after)) )) (PreH4 : (CrtosOSValid after )) ,
  (SemaphoreInsideCritical sg hs lock_pre before )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> (scheduler_lock_nest ((os_scheduler (after)))))
  **  (SemaphoreCriticalFrame sg after )
|--
  (SemaphoreInsideCritical sg hs lock_pre before )
  **  (SemaphoreOSInvariant sg (semaphore_nest_decrement (after)) )
.

Definition CriticalAreaUnLock_return_wit_1 := 
forall (lock_pre: Z) (after: CrtosOSState) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (PreH1 : (semaphore_irq_handler_ok lock_pre )) (PreH2 : (SemaphoreGuarantee before (semaphore_nest_decrement (after)) )) ,
  (SemaphoreOutsideCritical sg hs (semaphore_nest_decrement (after)) )
|--
  (SemaphoreOutsideCritical sg hs (semaphore_nest_decrement (after)) )
.

Definition CriticalAreaUnLock_partial_solve_wit_1_pure := 
forall (lock_pre: Z) (after: CrtosOSState) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (PreH1 : (semaphore_irq_handler_ok lock_pre )) (PreH2 : (SemaphoreGuarantee before (semaphore_nest_decrement (after)) )) ,
  ((( &( "lock" ) )) # Int  |-> lock_pre)
  **  (SemaphoreInsideCritical sg hs lock_pre before )
  **  (SemaphoreOSInvariant sg (semaphore_nest_decrement (after)) )
|--
  “ (semaphore_irq_handler_ok lock_pre ) ” 
  &&  “ (SemaphoreGuarantee before (semaphore_nest_decrement (after)) ) ”
.

Definition CriticalAreaUnLock_partial_solve_wit_1_aux := 
forall (lock_pre: Z) (after: CrtosOSState) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (PreH1 : (semaphore_irq_handler_ok lock_pre )) (PreH2 : (SemaphoreGuarantee before (semaphore_nest_decrement (after)) )) ,
  (SemaphoreInsideCritical sg hs lock_pre before )
  **  (SemaphoreOSInvariant sg (semaphore_nest_decrement (after)) )
|--
  “ (semaphore_irq_handler_ok lock_pre ) ” 
  &&  “ (SemaphoreGuarantee before (semaphore_nest_decrement (after)) ) ” 
  &&  “ (semaphore_irq_handler_ok lock_pre ) ” 
  &&  “ (SemaphoreGuarantee before (semaphore_nest_decrement (after)) ) ”
  &&  (SemaphoreInsideCritical sg hs lock_pre before )
  **  (SemaphoreOSInvariant sg (semaphore_nest_decrement (after)) )
.

Definition CriticalAreaUnLock_partial_solve_wit_1 := CriticalAreaUnLock_partial_solve_wit_1_pure -> CriticalAreaUnLock_partial_solve_wit_1_aux.

Module Type VC_Correct.


Axiom proof_of_CriticalAreaUnLock_safety_wit_1 : CriticalAreaUnLock_safety_wit_1.
Axiom proof_of_CriticalAreaUnLock_entail_wit_1 : CriticalAreaUnLock_entail_wit_1.
Axiom proof_of_CriticalAreaUnLock_entail_wit_2_1 : CriticalAreaUnLock_entail_wit_2_1.
Axiom proof_of_CriticalAreaUnLock_entail_wit_2_2 : CriticalAreaUnLock_entail_wit_2_2.
Axiom proof_of_CriticalAreaUnLock_return_wit_1 : CriticalAreaUnLock_return_wit_1.
Axiom proof_of_CriticalAreaUnLock_partial_solve_wit_1_pure : CriticalAreaUnLock_partial_solve_wit_1_pure.
Axiom proof_of_CriticalAreaUnLock_partial_solve_wit_1 : CriticalAreaUnLock_partial_solve_wit_1.

End VC_Correct.
