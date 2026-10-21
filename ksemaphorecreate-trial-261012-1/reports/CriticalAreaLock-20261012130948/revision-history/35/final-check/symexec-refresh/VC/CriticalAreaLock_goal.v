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

(*----- Function CriticalAreaLock -----*)

Definition CriticalAreaLock_entail_wit_1 := 
(
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (retval: Z) (current: CrtosOSState) (PreH1 : (semaphore_irq_handler_ok retval )) (PreH2 : (SemaphoreRely hs before current )) (PreH3 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  (SemaphoreInsideCritical sg hs retval current )
  **  (SemaphoreOSInvariant sg current )
|--
  “ (semaphore_irq_handler_ok retval ) ” 
  &&  “ (SemaphoreRely hs before current ) ” 
  &&  “ ((scheduler_lock_nest ((os_scheduler (before)))) < 65535) ” 
  &&  “ (CrtosOSValid current ) ”
  &&  (SemaphoreInsideCritical sg hs retval current )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> (scheduler_lock_nest ((os_scheduler (current)))))
  **  (SemaphoreCriticalFrame sg current )
) \/
(
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (retval: Z) (current: CrtosOSState) (PreH1 : (semaphore_irq_handler_ok retval )) (PreH2 : (SemaphoreRely hs before current )) (PreH3 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  (SemaphoreInsideCritical sg hs retval current )
  **  (SemaphoreOSInvariant sg current )
|--
  “ (CrtosOSValid current ) ”
  &&  (SemaphoreInsideCritical sg hs retval current )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> (scheduler_lock_nest ((os_scheduler (current)))))
  **  (SemaphoreCriticalFrame sg current )
).

Definition CriticalAreaLock_entail_wit_1_split_goal_1 := 
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (retval: Z) (current: CrtosOSState) (PreH1 : (semaphore_irq_handler_ok retval )) (PreH2 : (SemaphoreRely hs before current )) (PreH3 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  (SemaphoreInsideCritical sg hs retval current )
  **  (SemaphoreOSInvariant sg current )
|--
  “ (CrtosOSValid current ) ”
.

Definition CriticalAreaLock_entail_wit_1_split_goal_spatial := 
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (retval: Z) (current: CrtosOSState) (PreH1 : (semaphore_irq_handler_ok retval )) (PreH2 : (SemaphoreRely hs before current )) (PreH3 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  (SemaphoreInsideCritical sg hs retval current )
  **  (SemaphoreOSInvariant sg current )
|--
  (SemaphoreInsideCritical sg hs retval current )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> (scheduler_lock_nest ((os_scheduler (current)))))
  **  (SemaphoreCriticalFrame sg current )
.

Definition CriticalAreaLock_return_wit_1 := 
(
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current_2: CrtosOSState) (lock: Z) (PreH1 : (semaphore_irq_handler_ok lock )) (PreH2 : (SemaphoreRely hs before current_2 )) (PreH3 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH4 : (CrtosOSValid current_2 )) ,
  (SemaphoreInsideCritical sg hs lock current_2 )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> (unsigned_last_nbits (((scheduler_lock_nest ((os_scheduler (current_2)))) + 1 )) (16)))
  **  (SemaphoreCriticalFrame sg current_2 )
|--
  EX (current: CrtosOSState) ,
  “ (semaphore_irq_handler_ok lock ) ” 
  &&  “ (SemaphoreRely hs before current ) ”
  &&  (SemaphoreInsideCritical sg hs lock current )
  **  (SemaphoreOSInvariant sg (semaphore_nest_increment (current)) )
) \/
(
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current_2: CrtosOSState) (lock: Z) (PreH1 : (semaphore_irq_handler_ok lock )) (PreH2 : (SemaphoreRely hs before current_2 )) (PreH3 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH4 : (CrtosOSValid current_2 )) ,
  (SemaphoreInsideCritical sg hs lock current_2 )
  **  ((( &( "KTaskOsAssignLockNest" ) )) # UShort  |-> (unsigned_last_nbits (((scheduler_lock_nest ((os_scheduler (current_2)))) + 1 )) (16)))
  **  (SemaphoreCriticalFrame sg current_2 )
|--
  EX (current: CrtosOSState) ,
  “ (semaphore_irq_handler_ok lock ) ” 
  &&  “ (SemaphoreRely hs before current ) ”
  &&  (SemaphoreInsideCritical sg hs lock current )
  **  (SemaphoreOSInvariant sg (semaphore_nest_increment (current)) )
).

Definition CriticalAreaLock_partial_solve_wit_1 := 
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (PreH1 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  (SemaphoreOutsideCritical sg hs before )
|--
  “ ((scheduler_lock_nest ((os_scheduler (before)))) < 65535) ”
  &&  (SemaphoreOutsideCritical sg hs before )
.

Module Type VC_Correct.


Axiom proof_of_CriticalAreaLock_entail_wit_1 : CriticalAreaLock_entail_wit_1.
Axiom proof_of_CriticalAreaLock_return_wit_1 : CriticalAreaLock_return_wit_1.
Axiom proof_of_CriticalAreaLock_partial_solve_wit_1 : CriticalAreaLock_partial_solve_wit_1.

End VC_Correct.
