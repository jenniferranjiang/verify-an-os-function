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

(*----- Function KSemaphoreCreate -----*)

Definition KSemaphoreCreate_return_wit_1 := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (retval: Z) (PreH1 : (retval = (-5))) (PreH2 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  (SemaphoreOutsideCritical sg hs before )
|--
  (“ (retval = (-5)) ”
  &&  (SemaphoreOutsideCritical sg hs before ))
  ||
  (EX (current: CrtosOSState) ,
  “ (retval = (-5)) ” 
  &&  “ (SemaphoreRely hs before current ) ” 
  &&  “ (idmanager_full (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) ) ”
  &&  (SemaphoreOutsideCritical sg hs current ))
  ||
  (EX (current_2: CrtosOSState)  (p: Z) ,
  “ (p <> 0) ” 
  &&  “ (SemaphoreRely hs before current_2 ) ” 
  &&  “ (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current_2)))) retval ) ” 
  &&  “ (SemaphoreGuarantee current_2 (semaphore_os_publish (p) (retval) (val_pre) (current_2)) ) ”
  &&  (SemaphoreOutsideCritical sg hs (semaphore_os_publish (p) (retval) (val_pre) (current_2)) ))
.

Definition KSemaphoreCreate_return_wit_2 := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current_3: CrtosOSState) (retval: Z) (PreH1 : (retval = (-5))) (PreH2 : (SemaphoreRely hs before current_3 )) (PreH3 : (idmanager_full (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current_3)))) )) (PreH4 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  (SemaphoreOutsideCritical sg hs current_3 )
|--
  (“ (retval = (-5)) ”
  &&  (SemaphoreOutsideCritical sg hs before ))
  ||
  (EX (current: CrtosOSState) ,
  “ (retval = (-5)) ” 
  &&  “ (SemaphoreRely hs before current ) ” 
  &&  “ (idmanager_full (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) ) ”
  &&  (SemaphoreOutsideCritical sg hs current ))
  ||
  (EX (current_2: CrtosOSState)  (p: Z) ,
  “ (p <> 0) ” 
  &&  “ (SemaphoreRely hs before current_2 ) ” 
  &&  “ (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current_2)))) retval ) ” 
  &&  “ (SemaphoreGuarantee current_2 (semaphore_os_publish (p) (retval) (val_pre) (current_2)) ) ”
  &&  (SemaphoreOutsideCritical sg hs (semaphore_os_publish (p) (retval) (val_pre) (current_2)) ))
.

Definition KSemaphoreCreate_return_wit_3 := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current_3: CrtosOSState) (p_2: Z) (retval: Z) (PreH1 : (p_2 <> 0)) (PreH2 : (SemaphoreRely hs before current_3 )) (PreH3 : (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current_3)))) retval )) (PreH4 : (SemaphoreGuarantee current_3 (semaphore_os_publish (p_2) (retval) (val_pre) (current_3)) )) (PreH5 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  (SemaphoreOutsideCritical sg hs (semaphore_os_publish (p_2) (retval) (val_pre) (current_3)) )
|--
  (“ (retval = (-5)) ”
  &&  (SemaphoreOutsideCritical sg hs before ))
  ||
  (EX (current: CrtosOSState) ,
  “ (retval = (-5)) ” 
  &&  “ (SemaphoreRely hs before current ) ” 
  &&  “ (idmanager_full (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) ) ”
  &&  (SemaphoreOutsideCritical sg hs current ))
  ||
  (EX (current_2: CrtosOSState)  (p: Z) ,
  “ (p <> 0) ” 
  &&  “ (SemaphoreRely hs before current_2 ) ” 
  &&  “ (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current_2)))) retval ) ” 
  &&  “ (SemaphoreGuarantee current_2 (semaphore_os_publish (p) (retval) (val_pre) (current_2)) ) ”
  &&  (SemaphoreOutsideCritical sg hs (semaphore_os_publish (p) (retval) (val_pre) (current_2)) ))
.

Definition KSemaphoreCreate_partial_solve_wit_1_pure := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (PreH1 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreOutsideCritical sg hs before )
|--
  “ ((scheduler_lock_nest ((os_scheduler (before)))) < 65535) ”
.

Definition KSemaphoreCreate_partial_solve_wit_1_aux := 
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (PreH1 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  (SemaphoreOutsideCritical sg hs before )
|--
  “ ((scheduler_lock_nest ((os_scheduler (before)))) < 65535) ” 
  &&  “ ((scheduler_lock_nest ((os_scheduler (before)))) < 65535) ”
  &&  (SemaphoreOutsideCritical sg hs before )
.

Definition KSemaphoreCreate_partial_solve_wit_1 := KSemaphoreCreate_partial_solve_wit_1_pure -> KSemaphoreCreate_partial_solve_wit_1_aux.

Module Type VC_Correct.


Axiom proof_of_KSemaphoreCreate_return_wit_1 : KSemaphoreCreate_return_wit_1.
Axiom proof_of_KSemaphoreCreate_return_wit_2 : KSemaphoreCreate_return_wit_2.
Axiom proof_of_KSemaphoreCreate_return_wit_3 : KSemaphoreCreate_return_wit_3.
Axiom proof_of_KSemaphoreCreate_partial_solve_wit_1_pure : KSemaphoreCreate_partial_solve_wit_1_pure.
Axiom proof_of_KSemaphoreCreate_partial_solve_wit_1 : KSemaphoreCreate_partial_solve_wit_1.

End VC_Correct.
