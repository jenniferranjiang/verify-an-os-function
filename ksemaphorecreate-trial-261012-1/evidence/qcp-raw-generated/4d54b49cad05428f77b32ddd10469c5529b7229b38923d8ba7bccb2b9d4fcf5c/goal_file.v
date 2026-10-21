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

(*----- Function _SemaphoreCreate -----*)

Definition _SemaphoreCreate_safety_wit_1 := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (PreH1 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  ((( &( "id" ) )) # Int  |->_)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreOutsideCritical sg hs before )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_2 := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (PreH1 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  ((( &( "lock" ) )) # Int  |->_)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreOutsideCritical sg hs before )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_3 := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (PreH1 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  ((( &( "sem" ) )) # Ptr  |->_)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreOutsideCritical sg hs before )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_4 := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreOutsideCritical sg hs before )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_5 := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  (OSHeap (store_sem_allocated (retval)) )
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreOutsideCritical sg hs before )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_6 := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (retval = 0)) (PreH3 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreOutsideCritical sg hs before )
|--
  “ False ”
.

Definition _SemaphoreCreate_safety_wit_7 := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval <> 0)) (PreH3 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  (OSHeap (store_sem_allocated (retval)) )
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreOutsideCritical sg hs before )
|--
  “ False ”
.

Definition _SemaphoreCreate_safety_wit_8 := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreOutsideCritical sg hs before )
|--
  “ (5 <> (INT_MIN)) ”
.

Definition _SemaphoreCreate_safety_wit_9 := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreOutsideCritical sg hs before )
|--
  “ (5 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 5) ”
.

Definition _SemaphoreCreate_safety_wit_10 := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (retval <> 0)) (PreH3 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  (OSHeap (store_sem_allocated (retval)) )
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreOutsideCritical sg hs before )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_11 := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (id: Z) (sem: Z) (lock: Z) (retval: Z) (PreH1 : (retval = (-1))) (PreH2 : (idmanager_full (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) )) (PreH3 : (id = 0)) (PreH4 : (sem <> 0)) (PreH5 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "id") <> 0)) (PreH7 : (semaphore_irq_handler_ok lock )) (PreH8 : (SemaphoreRely hs before current )) (PreH9 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH10 : (CrtosOSValid (semaphore_nest_increment (current)) )) ,
  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (( &( "k_sem_id_manager" ) ))) )
  **  (OSHeap (store_sem_id_detached (&((sem)  # "Semaphore" ->ₛ "id")) (0) (0) (0)) )
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  (OSHeap (store_sem_registered_private (sem)) )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_12 := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (id: Z) (sem: Z) (lock: Z) (retval: Z) (PreH1 : (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) retval )) (PreH2 : (id = 0)) (PreH3 : (sem <> 0)) (PreH4 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH5 : (&((sem)  # "Semaphore" ->ₛ "id") <> 0)) (PreH6 : (semaphore_irq_handler_ok lock )) (PreH7 : (SemaphoreRely hs before current )) (PreH8 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH9 : (CrtosOSValid (semaphore_nest_increment (current)) )) ,
  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  (OSHeap (store_sem_registered_private (sem)) )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_13 := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (id: Z) (sem: Z) (lock: Z) (retval: Z) (PreH1 : (retval >= 0)) (PreH2 : (retval = (-1))) (PreH3 : (idmanager_full (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) )) (PreH4 : (id = 0)) (PreH5 : (sem <> 0)) (PreH6 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH7 : (&((sem)  # "Semaphore" ->ₛ "id") <> 0)) (PreH8 : (semaphore_irq_handler_ok lock )) (PreH9 : (SemaphoreRely hs before current )) (PreH10 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH11 : (CrtosOSValid (semaphore_nest_increment (current)) )) ,
  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (( &( "k_sem_id_manager" ) ))) )
  **  (OSHeap (store_sem_id_detached (&((sem)  # "Semaphore" ->ₛ "id")) (0) (0) (0)) )
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  (OSHeap (store_sem_registered_private (sem)) )
|--
  “ False ”
.

Definition _SemaphoreCreate_safety_wit_14 := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (id: Z) (sem: Z) (lock: Z) (PreH1 : (id = (-1))) (PreH2 : (sem <> 0)) (PreH3 : (semaphore_irq_handler_ok lock )) (PreH4 : (SemaphoreRely hs before current )) (PreH5 : (idmanager_full (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) )) (PreH6 : (SemaphoreGuarantee current (semaphore_nest_decrement ((semaphore_nest_increment (current)))) )) ,
  (SemaphoreOutsideCritical sg hs (semaphore_nest_decrement ((semaphore_nest_increment (current)))) )
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "lock" ) )) # Int  |-> lock)
|--
  “ (5 <> (INT_MIN)) ”
.

Definition _SemaphoreCreate_safety_wit_15 := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (id: Z) (sem: Z) (lock: Z) (PreH1 : (id = (-1))) (PreH2 : (sem <> 0)) (PreH3 : (semaphore_irq_handler_ok lock )) (PreH4 : (SemaphoreRely hs before current )) (PreH5 : (idmanager_full (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) )) (PreH6 : (SemaphoreGuarantee current (semaphore_nest_decrement ((semaphore_nest_increment (current)))) )) ,
  (SemaphoreOutsideCritical sg hs (semaphore_nest_decrement ((semaphore_nest_increment (current)))) )
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "lock" ) )) # Int  |-> lock)
|--
  “ (5 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 5) ”
.

Definition _SemaphoreCreate_entail_wit_1 := 
(
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (retval: Z) (retval_3: Z) (retval_2: Z) (current: CrtosOSState) (PreH1 : (semaphore_irq_handler_ok retval_2 )) (PreH2 : (SemaphoreRely hs before current )) (PreH3 : (retval_3 = retval)) (PreH4 : (retval <> 0)) (PreH5 : (retval <> 0)) (PreH6 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  (SemaphoreInsideCritical sg hs retval_2 current )
  **  (SemaphoreOSInvariant sg (semaphore_nest_increment (current)) )
  **  (OSHeap (store_sem_zeroed_private (retval)) )
|--
  “ (0 = 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (&((retval)  # "Semaphore" ->ₛ "id") <> 0) ” 
  &&  “ (semaphore_irq_handler_ok retval_2 ) ” 
  &&  “ (SemaphoreRely hs before current ) ” 
  &&  “ ((scheduler_lock_nest ((os_scheduler (before)))) < 65535) ” 
  &&  “ (CrtosOSValid (semaphore_nest_increment (current)) ) ”
  &&  (SemaphoreInsideCritical sg hs retval_2 current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (( &( "k_sem_id_manager" ) ))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  (OSHeap (store_sem_id_detached (&((retval)  # "Semaphore" ->ₛ "id")) (0) (0) (0)) )
  **  (OSHeap (store_sem_registered_private (retval)) )
) \/
(
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (retval: Z) (retval_3: Z) (retval_2: Z) (current: CrtosOSState) (PreH1 : (semaphore_irq_handler_ok retval_2 )) (PreH2 : (SemaphoreRely hs before current )) (PreH3 : (retval_3 = retval)) (PreH4 : (retval <> 0)) (PreH5 : (retval <> 0)) (PreH6 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  (SemaphoreInsideCritical sg hs retval_2 current )
  **  (SemaphoreOSInvariant sg (semaphore_nest_increment (current)) )
  **  (OSHeap (store_sem_zeroed_private (retval)) )
|--
  “ (CrtosOSValid (semaphore_nest_increment (current)) ) ” 
  &&  “ (&((retval)  # "Semaphore" ->ₛ "id") <> 0) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ”
  &&  (SemaphoreInsideCritical sg hs retval_2 current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (( &( "k_sem_id_manager" ) ))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  (OSHeap (store_sem_id_detached (&((retval)  # "Semaphore" ->ₛ "id")) (0) (0) (0)) )
  **  (OSHeap (store_sem_registered_private (retval)) )
).

Definition _SemaphoreCreate_entail_wit_1_split_goal_1 := 
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (retval: Z) (retval_3: Z) (retval_2: Z) (current: CrtosOSState) (PreH1 : (semaphore_irq_handler_ok retval_2 )) (PreH2 : (SemaphoreRely hs before current )) (PreH3 : (retval_3 = retval)) (PreH4 : (retval <> 0)) (PreH5 : (retval <> 0)) (PreH6 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  (SemaphoreInsideCritical sg hs retval_2 current )
  **  (SemaphoreOSInvariant sg (semaphore_nest_increment (current)) )
  **  (OSHeap (store_sem_zeroed_private (retval)) )
|--
  “ (CrtosOSValid (semaphore_nest_increment (current)) ) ”
.

Definition _SemaphoreCreate_entail_wit_1_split_goal_2 := 
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (retval: Z) (retval_3: Z) (retval_2: Z) (current: CrtosOSState) (PreH1 : (semaphore_irq_handler_ok retval_2 )) (PreH2 : (SemaphoreRely hs before current )) (PreH3 : (retval_3 = retval)) (PreH4 : (retval <> 0)) (PreH5 : (retval <> 0)) (PreH6 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  (SemaphoreInsideCritical sg hs retval_2 current )
  **  (SemaphoreOSInvariant sg (semaphore_nest_increment (current)) )
  **  (OSHeap (store_sem_zeroed_private (retval)) )
|--
  “ (&((retval)  # "Semaphore" ->ₛ "id") <> 0) ”
.

Definition _SemaphoreCreate_entail_wit_1_split_goal_3 := 
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (retval: Z) (retval_3: Z) (retval_2: Z) (current: CrtosOSState) (PreH1 : (semaphore_irq_handler_ok retval_2 )) (PreH2 : (SemaphoreRely hs before current )) (PreH3 : (retval_3 = retval)) (PreH4 : (retval <> 0)) (PreH5 : (retval <> 0)) (PreH6 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  (SemaphoreInsideCritical sg hs retval_2 current )
  **  (SemaphoreOSInvariant sg (semaphore_nest_increment (current)) )
  **  (OSHeap (store_sem_zeroed_private (retval)) )
|--
  “ (( &( "k_sem_id_manager" ) ) <> 0) ”
.

Definition _SemaphoreCreate_entail_wit_1_split_goal_spatial := 
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (retval: Z) (retval_3: Z) (retval_2: Z) (current: CrtosOSState) (PreH1 : (semaphore_irq_handler_ok retval_2 )) (PreH2 : (SemaphoreRely hs before current )) (PreH3 : (retval_3 = retval)) (PreH4 : (retval <> 0)) (PreH5 : (retval <> 0)) (PreH6 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  (SemaphoreInsideCritical sg hs retval_2 current )
  **  (SemaphoreOSInvariant sg (semaphore_nest_increment (current)) )
  **  (OSHeap (store_sem_zeroed_private (retval)) )
|--
  (SemaphoreInsideCritical sg hs retval_2 current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (( &( "k_sem_id_manager" ) ))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  (OSHeap (store_sem_id_detached (&((retval)  # "Semaphore" ->ₛ "id")) (0) (0) (0)) )
  **  (OSHeap (store_sem_registered_private (retval)) )
.

Definition _SemaphoreCreate_entail_wit_2_1 := 
(
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (id: Z) (sem: Z) (lock: Z) (retval: Z) (PreH1 : (retval < 0)) (PreH2 : (retval = (-1))) (PreH3 : (idmanager_full (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) )) (PreH4 : (id = 0)) (PreH5 : (sem <> 0)) (PreH6 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH7 : (&((sem)  # "Semaphore" ->ₛ "id") <> 0)) (PreH8 : (semaphore_irq_handler_ok lock )) (PreH9 : (SemaphoreRely hs before current )) (PreH10 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH11 : (CrtosOSValid (semaphore_nest_increment (current)) )) ,
  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (( &( "k_sem_id_manager" ) ))) )
  **  (OSHeap (store_sem_id_detached (&((sem)  # "Semaphore" ->ₛ "id")) (0) (0) (0)) )
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  (OSHeap (store_sem_registered_private (sem)) )
|--
  “ (retval = (-1)) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (semaphore_irq_handler_ok lock ) ” 
  &&  “ (SemaphoreRely hs before current ) ” 
  &&  “ (idmanager_full (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) ) ” 
  &&  “ (SemaphoreGuarantee current (semaphore_nest_decrement ((semaphore_nest_increment (current)))) ) ”
  &&  (SemaphoreInsideCritical sg hs lock current )
  **  (SemaphoreOSInvariant sg (semaphore_nest_increment (current)) )
  **  (OSHeap (store_sem_zeroed_private (sem)) )
) \/
(
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (id: Z) (sem: Z) (lock: Z) (retval: Z) (PreH1 : (retval < 0)) (PreH2 : (retval = (-1))) (PreH3 : (idmanager_full (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) )) (PreH4 : (id = 0)) (PreH5 : (sem <> 0)) (PreH6 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH7 : (&((sem)  # "Semaphore" ->ₛ "id") <> 0)) (PreH8 : (semaphore_irq_handler_ok lock )) (PreH9 : (SemaphoreRely hs before current )) (PreH10 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH11 : (CrtosOSValid (semaphore_nest_increment (current)) )) ,
  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (( &( "k_sem_id_manager" ) ))) )
  **  (OSHeap (store_sem_id_detached (&((sem)  # "Semaphore" ->ₛ "id")) (0) (0) (0)) )
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  (OSHeap (store_sem_registered_private (sem)) )
|--
  “ (SemaphoreGuarantee current (semaphore_nest_decrement ((semaphore_nest_increment (current)))) ) ”
  &&  (SemaphoreInsideCritical sg hs lock current )
  **  (SemaphoreOSInvariant sg (semaphore_nest_increment (current)) )
  **  (OSHeap (store_sem_zeroed_private (sem)) )
).

Definition _SemaphoreCreate_entail_wit_2_1_split_goal_1 := 
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (id: Z) (sem: Z) (lock: Z) (retval: Z) (PreH1 : (retval < 0)) (PreH2 : (retval = (-1))) (PreH3 : (idmanager_full (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) )) (PreH4 : (id = 0)) (PreH5 : (sem <> 0)) (PreH6 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH7 : (&((sem)  # "Semaphore" ->ₛ "id") <> 0)) (PreH8 : (semaphore_irq_handler_ok lock )) (PreH9 : (SemaphoreRely hs before current )) (PreH10 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH11 : (CrtosOSValid (semaphore_nest_increment (current)) )) ,
  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (( &( "k_sem_id_manager" ) ))) )
  **  (OSHeap (store_sem_id_detached (&((sem)  # "Semaphore" ->ₛ "id")) (0) (0) (0)) )
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  (OSHeap (store_sem_registered_private (sem)) )
|--
  “ (SemaphoreGuarantee current (semaphore_nest_decrement ((semaphore_nest_increment (current)))) ) ”
.

Definition _SemaphoreCreate_entail_wit_2_1_split_goal_spatial := 
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (id: Z) (sem: Z) (lock: Z) (retval: Z) (PreH1 : (retval < 0)) (PreH2 : (retval = (-1))) (PreH3 : (idmanager_full (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) )) (PreH4 : (id = 0)) (PreH5 : (sem <> 0)) (PreH6 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH7 : (&((sem)  # "Semaphore" ->ₛ "id") <> 0)) (PreH8 : (semaphore_irq_handler_ok lock )) (PreH9 : (SemaphoreRely hs before current )) (PreH10 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH11 : (CrtosOSValid (semaphore_nest_increment (current)) )) ,
  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (( &( "k_sem_id_manager" ) ))) )
  **  (OSHeap (store_sem_id_detached (&((sem)  # "Semaphore" ->ₛ "id")) (0) (0) (0)) )
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  (OSHeap (store_sem_registered_private (sem)) )
|--
  (SemaphoreInsideCritical sg hs lock current )
  **  (SemaphoreOSInvariant sg (semaphore_nest_increment (current)) )
  **  (OSHeap (store_sem_zeroed_private (sem)) )
.

Definition _SemaphoreCreate_entail_wit_2_2 := 
(
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (id: Z) (sem: Z) (lock: Z) (retval: Z) (PreH1 : (retval < 0)) (PreH2 : (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) retval )) (PreH3 : (id = 0)) (PreH4 : (sem <> 0)) (PreH5 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "id") <> 0)) (PreH7 : (semaphore_irq_handler_ok lock )) (PreH8 : (SemaphoreRely hs before current )) (PreH9 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH10 : (CrtosOSValid (semaphore_nest_increment (current)) )) ,
  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  (OSHeap (store_sem_registered_private (sem)) )
|--
  “ (retval = (-1)) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (semaphore_irq_handler_ok lock ) ” 
  &&  “ (SemaphoreRely hs before current ) ” 
  &&  “ (idmanager_full (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) ) ” 
  &&  “ (SemaphoreGuarantee current (semaphore_nest_decrement ((semaphore_nest_increment (current)))) ) ”
  &&  (SemaphoreInsideCritical sg hs lock current )
  **  (SemaphoreOSInvariant sg (semaphore_nest_increment (current)) )
  **  (OSHeap (store_sem_zeroed_private (sem)) )
) \/
(
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (id: Z) (sem: Z) (lock: Z) (retval: Z) (PreH1 : (retval < 0)) (PreH2 : (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) retval )) (PreH3 : (id = 0)) (PreH4 : (sem <> 0)) (PreH5 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "id") <> 0)) (PreH7 : (semaphore_irq_handler_ok lock )) (PreH8 : (SemaphoreRely hs before current )) (PreH9 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH10 : (CrtosOSValid (semaphore_nest_increment (current)) )) ,
  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  (OSHeap (store_sem_registered_private (sem)) )
|--
  “ (SemaphoreGuarantee current (semaphore_nest_decrement ((semaphore_nest_increment (current)))) ) ” 
  &&  “ (idmanager_full (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) ) ” 
  &&  “ (retval = (-1)) ”
  &&  (SemaphoreInsideCritical sg hs lock current )
  **  (SemaphoreOSInvariant sg (semaphore_nest_increment (current)) )
  **  (OSHeap (store_sem_zeroed_private (sem)) )
).

Definition _SemaphoreCreate_entail_wit_2_2_split_goal_1 := 
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (id: Z) (sem: Z) (lock: Z) (retval: Z) (PreH1 : (retval < 0)) (PreH2 : (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) retval )) (PreH3 : (id = 0)) (PreH4 : (sem <> 0)) (PreH5 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "id") <> 0)) (PreH7 : (semaphore_irq_handler_ok lock )) (PreH8 : (SemaphoreRely hs before current )) (PreH9 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH10 : (CrtosOSValid (semaphore_nest_increment (current)) )) ,
  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  (OSHeap (store_sem_registered_private (sem)) )
|--
  “ (SemaphoreGuarantee current (semaphore_nest_decrement ((semaphore_nest_increment (current)))) ) ”
.

Definition _SemaphoreCreate_entail_wit_2_2_split_goal_2 := 
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (id: Z) (sem: Z) (lock: Z) (retval: Z) (PreH1 : (retval < 0)) (PreH2 : (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) retval )) (PreH3 : (id = 0)) (PreH4 : (sem <> 0)) (PreH5 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "id") <> 0)) (PreH7 : (semaphore_irq_handler_ok lock )) (PreH8 : (SemaphoreRely hs before current )) (PreH9 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH10 : (CrtosOSValid (semaphore_nest_increment (current)) )) ,
  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  (OSHeap (store_sem_registered_private (sem)) )
|--
  “ (idmanager_full (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) ) ”
.

Definition _SemaphoreCreate_entail_wit_2_2_split_goal_3 := 
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (id: Z) (sem: Z) (lock: Z) (retval: Z) (PreH1 : (retval < 0)) (PreH2 : (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) retval )) (PreH3 : (id = 0)) (PreH4 : (sem <> 0)) (PreH5 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "id") <> 0)) (PreH7 : (semaphore_irq_handler_ok lock )) (PreH8 : (SemaphoreRely hs before current )) (PreH9 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH10 : (CrtosOSValid (semaphore_nest_increment (current)) )) ,
  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  (OSHeap (store_sem_registered_private (sem)) )
|--
  “ (retval = (-1)) ”
.

Definition _SemaphoreCreate_entail_wit_2_2_split_goal_spatial := 
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (id: Z) (sem: Z) (lock: Z) (retval: Z) (PreH1 : (retval < 0)) (PreH2 : (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) retval )) (PreH3 : (id = 0)) (PreH4 : (sem <> 0)) (PreH5 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "id") <> 0)) (PreH7 : (semaphore_irq_handler_ok lock )) (PreH8 : (SemaphoreRely hs before current )) (PreH9 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH10 : (CrtosOSValid (semaphore_nest_increment (current)) )) ,
  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  (OSHeap (store_sem_registered_private (sem)) )
|--
  (SemaphoreInsideCritical sg hs lock current )
  **  (SemaphoreOSInvariant sg (semaphore_nest_increment (current)) )
  **  (OSHeap (store_sem_zeroed_private (sem)) )
.

Definition _SemaphoreCreate_entail_wit_3 := 
(
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (id: Z) (sem: Z) (lock: Z) (retval: Z) (PreH1 : (retval >= 0)) (PreH2 : (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) retval )) (PreH3 : (id = 0)) (PreH4 : (sem <> 0)) (PreH5 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "id") <> 0)) (PreH7 : (semaphore_irq_handler_ok lock )) (PreH8 : (SemaphoreRely hs before current )) (PreH9 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH10 : (CrtosOSValid (semaphore_nest_increment (current)) )) ,
  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  (OSHeap (store_sem_registered_private (sem)) )
|--
  “ (sem <> 0) ” 
  &&  “ (semaphore_object_addresses sem ) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ” 
  &&  “ (semaphore_irq_handler_ok lock ) ” 
  &&  “ (SemaphoreRely hs before current ) ” 
  &&  “ ((scheduler_lock_nest ((os_scheduler (before)))) < 65535) ” 
  &&  “ (CrtosOSValid (semaphore_nest_increment (current)) ) ” 
  &&  “ (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) retval ) ”
  &&  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |->_)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  (OSHeap (store_sem_padding (sem)) )
) \/
(
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (id: Z) (sem: Z) (lock: Z) (retval: Z) (PreH1 : (retval >= 0)) (PreH2 : (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) retval )) (PreH3 : (id = 0)) (PreH4 : (sem <> 0)) (PreH5 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH6 : (&((sem)  # "Semaphore" ->ₛ "id") <> 0)) (PreH7 : (semaphore_irq_handler_ok lock )) (PreH8 : (SemaphoreRely hs before current )) (PreH9 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH10 : (CrtosOSValid (semaphore_nest_increment (current)) )) ,
  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  (OSHeap (store_sem_registered_private (sem)) )
|--
  EX (x_4: Z)  (x_3: Z)  (x_2: Z)  (x: Z) ,
  “ (sem <> 0) ” 
  &&  “ (semaphore_object_addresses sem ) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ” 
  &&  “ (semaphore_irq_handler_ok lock ) ” 
  &&  “ (SemaphoreRely hs before current ) ” 
  &&  “ ((scheduler_lock_nest ((os_scheduler (before)))) < 65535) ” 
  &&  “ (CrtosOSValid (semaphore_nest_increment (current)) ) ” 
  &&  “ (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) retval ) ”
  &&  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> x_4)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> x_3)
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |-> x_2)
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |-> x)
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (retval))) (retval) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (OSHeap (store_sem_padding (sem)) )
).

Definition _SemaphoreCreate_entail_wit_4 := 
(
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (sem: Z) (lock: Z) (id: Z) (PreH1 : (sem <> 0)) (PreH2 : (semaphore_object_addresses sem )) (PreH3 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH4 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH5 : (semaphore_irq_handler_ok lock )) (PreH6 : (SemaphoreRely hs before current )) (PreH7 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH8 : (CrtosOSValid (semaphore_nest_increment (current)) )) (PreH9 : (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) id )) ,
  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "pend_list"))
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "pend_list"))
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  (OSHeap (store_sem_padding (sem)) )
|--
  EX (successor: Z)  (nodes: (@list (@DL_Node SemaphoreObject)))  (payload: (Z -> (SemaphoreObject -> Task_C_Rules.expr))) ,
  “ forall (address: Z) , forall (obj: SemaphoreObject) , ((payload (address) (obj)) = (store_semaphore_body (obj))) ” 
  &&  “ ((map (data) (nodes)) = (os_semaphores (current))) ” 
  &&  “ forall (node: (@DL_Node SemaphoreObject)) , ((In node nodes ) -> ((ptr (node)) = &(((semaphore_addr ((data (node)))))  # "Semaphore" ->ₛ "link"))) ” 
  &&  “ (DLL.dll_nodes_nonzero nodes ) ” 
  &&  “ (( &( "k_sem_list" ) ) <> 0) ” 
  &&  “ (successor <> 0) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (semaphore_object_addresses sem ) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ” 
  &&  “ (semaphore_irq_handler_ok lock ) ” 
  &&  “ (SemaphoreRely hs before current ) ” 
  &&  “ ((scheduler_lock_nest ((os_scheduler (before)))) < 65535) ” 
  &&  “ (CrtosOSValid (semaphore_nest_increment (current)) ) ” 
  &&  “ (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) id ) ”
  &&  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  ((&(( &( "k_sem_list" ) )->ₛ "node_next")) # Ptr  |-> successor)
  **  ((&((successor)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> ( &( "k_sem_list" ) ))
  **  (OSHeap (DLL.dllseg_shift_rev (payload) (successor) (( &( "k_sem_list" ) )) (nodes)) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "pend_list"))
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "pend_list"))
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  (OSHeap (store_sem_padding (sem)) )
) \/
(
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (sem: Z) (lock: Z) (id: Z) (PreH1 : (sem <> 0)) (PreH2 : (semaphore_object_addresses sem )) (PreH3 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH4 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH5 : (semaphore_irq_handler_ok lock )) (PreH6 : (SemaphoreRely hs before current )) (PreH7 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH8 : (CrtosOSValid (semaphore_nest_increment (current)) )) (PreH9 : (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) id )) ,
  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  (OSHeap (store_sem_padding (sem)) )
|--
  EX (successor: Z)  (nodes: (@list (@DL_Node SemaphoreObject)))  (payload: (Z -> (SemaphoreObject -> Task_C_Rules.expr))) ,
  “ forall (address: Z) , forall (obj: SemaphoreObject) , ((payload (address) (obj)) = (store_semaphore_body (obj))) ” 
  &&  “ ((map (data) (nodes)) = (os_semaphores (current))) ” 
  &&  “ forall (node: (@DL_Node SemaphoreObject)) , ((In node nodes ) -> ((ptr (node)) = &(((semaphore_addr ((data (node)))))  # "Semaphore" ->ₛ "link"))) ” 
  &&  “ (DLL.dll_nodes_nonzero nodes ) ” 
  &&  “ (( &( "k_sem_list" ) ) <> 0) ” 
  &&  “ (successor <> 0) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (semaphore_object_addresses sem ) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ” 
  &&  “ (semaphore_irq_handler_ok lock ) ” 
  &&  “ (SemaphoreRely hs before current ) ” 
  &&  “ ((scheduler_lock_nest ((os_scheduler (before)))) < 65535) ” 
  &&  “ (CrtosOSValid (semaphore_nest_increment (current)) ) ” 
  &&  “ (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) id ) ”
  &&  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  ((&(( &( "k_sem_list" ) )->ₛ "node_next")) # Ptr  |-> successor)
  **  ((&((successor)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> ( &( "k_sem_list" ) ))
  **  (OSHeap (DLL.dllseg_shift_rev (payload) (successor) (( &( "k_sem_list" ) )) (nodes)) )
  **  (OSHeap (store_sem_padding (sem)) )
).

Definition _SemaphoreCreate_entail_wit_5 := 
(
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (payload: (Z -> (SemaphoreObject -> Task_C_Rules.expr))) (nodes: (@list (@DL_Node SemaphoreObject))) (successor: Z) (sem: Z) (lock: Z) (id: Z) (PreH1 : forall (address: Z) , forall (obj: SemaphoreObject) , ((payload (address) (obj)) = (store_semaphore_body (obj)))) (PreH2 : ((map (data) (nodes)) = (os_semaphores (current)))) (PreH3 : forall (node: (@DL_Node SemaphoreObject)) , ((In node nodes ) -> ((ptr (node)) = &(((semaphore_addr ((data (node)))))  # "Semaphore" ->ₛ "link")))) (PreH4 : (DLL.dll_nodes_nonzero nodes )) (PreH5 : (( &( "k_sem_list" ) ) <> 0)) (PreH6 : (successor <> 0)) (PreH7 : (sem <> 0)) (PreH8 : (semaphore_object_addresses sem )) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH10 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH11 : (semaphore_irq_handler_ok lock )) (PreH12 : (SemaphoreRely hs before current )) (PreH13 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH14 : (CrtosOSValid (semaphore_nest_increment (current)) )) (PreH15 : (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) id )) ,
  ((&(( &( "k_sem_list" ) )->ₛ "node_next")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "link"))
  **  ((&((successor)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "link"))
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> successor)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> ( &( "k_sem_list" ) ))
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  (OSHeap (DLL.dllseg_shift_rev (payload) (successor) (( &( "k_sem_list" ) )) (nodes)) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "pend_list"))
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "pend_list"))
  **  (OSHeap (store_sem_padding (sem)) )
|--
  “ (sem <> 0) ” 
  &&  “ (semaphore_irq_handler_ok lock ) ” 
  &&  “ (SemaphoreRely hs before current ) ” 
  &&  “ (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) id ) ” 
  &&  “ (SemaphoreGuarantee current (semaphore_os_publish (sem) (id) (val_pre) (current)) ) ” 
  &&  “ (SemaphoreGuarantee current (semaphore_nest_decrement ((semaphore_nest_increment ((semaphore_os_publish (sem) (id) (val_pre) (current)))))) ) ”
  &&  (SemaphoreInsideCritical sg hs lock current )
  **  (SemaphoreOSInvariant sg (semaphore_nest_increment ((semaphore_os_publish (sem) (id) (val_pre) (current)))) )
) \/
(
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (payload: (Z -> (SemaphoreObject -> Task_C_Rules.expr))) (nodes: (@list (@DL_Node SemaphoreObject))) (successor: Z) (sem: Z) (lock: Z) (id: Z) (PreH1 : forall (address: Z) , forall (obj: SemaphoreObject) , ((payload (address) (obj)) = (store_semaphore_body (obj)))) (PreH2 : ((map (data) (nodes)) = (os_semaphores (current)))) (PreH3 : forall (node: (@DL_Node SemaphoreObject)) , ((In node nodes ) -> ((ptr (node)) = &(((semaphore_addr ((data (node)))))  # "Semaphore" ->ₛ "link")))) (PreH4 : (DLL.dll_nodes_nonzero nodes )) (PreH5 : (( &( "k_sem_list" ) ) <> 0)) (PreH6 : (successor <> 0)) (PreH7 : (sem <> 0)) (PreH8 : (semaphore_object_addresses sem )) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH10 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH11 : (semaphore_irq_handler_ok lock )) (PreH12 : (SemaphoreRely hs before current )) (PreH13 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH14 : (CrtosOSValid (semaphore_nest_increment (current)) )) (PreH15 : (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) id )) ,
  ((&(( &( "k_sem_list" ) )->ₛ "node_next")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "link"))
  **  ((&((successor)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "link"))
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> successor)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> ( &( "k_sem_list" ) ))
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  (OSHeap (DLL.dllseg_shift_rev (payload) (successor) (( &( "k_sem_list" ) )) (nodes)) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "pend_list"))
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "pend_list"))
  **  (OSHeap (store_sem_padding (sem)) )
|--
  “ (SemaphoreGuarantee current (semaphore_nest_decrement ((semaphore_nest_increment ((semaphore_os_publish (sem) (id) (val_pre) (current)))))) ) ” 
  &&  “ (SemaphoreGuarantee current (semaphore_os_publish (sem) (id) (val_pre) (current)) ) ”
  &&  (SemaphoreInsideCritical sg hs lock current )
  **  (SemaphoreOSInvariant sg (semaphore_nest_increment ((semaphore_os_publish (sem) (id) (val_pre) (current)))) )
).

Definition _SemaphoreCreate_entail_wit_5_split_goal_1 := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (payload: (Z -> (SemaphoreObject -> Task_C_Rules.expr))) (nodes: (@list (@DL_Node SemaphoreObject))) (successor: Z) (sem: Z) (lock: Z) (id: Z) (PreH1 : forall (address: Z) , forall (obj: SemaphoreObject) , ((payload (address) (obj)) = (store_semaphore_body (obj)))) (PreH2 : ((map (data) (nodes)) = (os_semaphores (current)))) (PreH3 : forall (node: (@DL_Node SemaphoreObject)) , ((In node nodes ) -> ((ptr (node)) = &(((semaphore_addr ((data (node)))))  # "Semaphore" ->ₛ "link")))) (PreH4 : (DLL.dll_nodes_nonzero nodes )) (PreH5 : (( &( "k_sem_list" ) ) <> 0)) (PreH6 : (successor <> 0)) (PreH7 : (sem <> 0)) (PreH8 : (semaphore_object_addresses sem )) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH10 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH11 : (semaphore_irq_handler_ok lock )) (PreH12 : (SemaphoreRely hs before current )) (PreH13 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH14 : (CrtosOSValid (semaphore_nest_increment (current)) )) (PreH15 : (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) id )) ,
  ((&(( &( "k_sem_list" ) )->ₛ "node_next")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "link"))
  **  ((&((successor)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "link"))
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> successor)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> ( &( "k_sem_list" ) ))
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  (OSHeap (DLL.dllseg_shift_rev (payload) (successor) (( &( "k_sem_list" ) )) (nodes)) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "pend_list"))
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "pend_list"))
  **  (OSHeap (store_sem_padding (sem)) )
|--
  “ (SemaphoreGuarantee current (semaphore_nest_decrement ((semaphore_nest_increment ((semaphore_os_publish (sem) (id) (val_pre) (current)))))) ) ”
.

Definition _SemaphoreCreate_entail_wit_5_split_goal_2 := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (payload: (Z -> (SemaphoreObject -> Task_C_Rules.expr))) (nodes: (@list (@DL_Node SemaphoreObject))) (successor: Z) (sem: Z) (lock: Z) (id: Z) (PreH1 : forall (address: Z) , forall (obj: SemaphoreObject) , ((payload (address) (obj)) = (store_semaphore_body (obj)))) (PreH2 : ((map (data) (nodes)) = (os_semaphores (current)))) (PreH3 : forall (node: (@DL_Node SemaphoreObject)) , ((In node nodes ) -> ((ptr (node)) = &(((semaphore_addr ((data (node)))))  # "Semaphore" ->ₛ "link")))) (PreH4 : (DLL.dll_nodes_nonzero nodes )) (PreH5 : (( &( "k_sem_list" ) ) <> 0)) (PreH6 : (successor <> 0)) (PreH7 : (sem <> 0)) (PreH8 : (semaphore_object_addresses sem )) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH10 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH11 : (semaphore_irq_handler_ok lock )) (PreH12 : (SemaphoreRely hs before current )) (PreH13 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH14 : (CrtosOSValid (semaphore_nest_increment (current)) )) (PreH15 : (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) id )) ,
  ((&(( &( "k_sem_list" ) )->ₛ "node_next")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "link"))
  **  ((&((successor)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "link"))
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> successor)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> ( &( "k_sem_list" ) ))
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  (OSHeap (DLL.dllseg_shift_rev (payload) (successor) (( &( "k_sem_list" ) )) (nodes)) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "pend_list"))
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "pend_list"))
  **  (OSHeap (store_sem_padding (sem)) )
|--
  “ (SemaphoreGuarantee current (semaphore_os_publish (sem) (id) (val_pre) (current)) ) ”
.

Definition _SemaphoreCreate_entail_wit_5_split_goal_spatial := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (payload: (Z -> (SemaphoreObject -> Task_C_Rules.expr))) (nodes: (@list (@DL_Node SemaphoreObject))) (successor: Z) (sem: Z) (lock: Z) (id: Z) (PreH1 : forall (address: Z) , forall (obj: SemaphoreObject) , ((payload (address) (obj)) = (store_semaphore_body (obj)))) (PreH2 : ((map (data) (nodes)) = (os_semaphores (current)))) (PreH3 : forall (node: (@DL_Node SemaphoreObject)) , ((In node nodes ) -> ((ptr (node)) = &(((semaphore_addr ((data (node)))))  # "Semaphore" ->ₛ "link")))) (PreH4 : (DLL.dll_nodes_nonzero nodes )) (PreH5 : (( &( "k_sem_list" ) ) <> 0)) (PreH6 : (successor <> 0)) (PreH7 : (sem <> 0)) (PreH8 : (semaphore_object_addresses sem )) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH10 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH11 : (semaphore_irq_handler_ok lock )) (PreH12 : (SemaphoreRely hs before current )) (PreH13 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH14 : (CrtosOSValid (semaphore_nest_increment (current)) )) (PreH15 : (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) id )) ,
  ((&(( &( "k_sem_list" ) )->ₛ "node_next")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "link"))
  **  ((&((successor)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "link"))
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> successor)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> ( &( "k_sem_list" ) ))
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  (OSHeap (DLL.dllseg_shift_rev (payload) (successor) (( &( "k_sem_list" ) )) (nodes)) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "pend_list"))
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "pend_list"))
  **  (OSHeap (store_sem_padding (sem)) )
|--
  (SemaphoreInsideCritical sg hs lock current )
  **  (SemaphoreOSInvariant sg (semaphore_nest_increment ((semaphore_os_publish (sem) (id) (val_pre) (current)))) )
.

Definition _SemaphoreCreate_return_wit_1 := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current_3: CrtosOSState) (sem: Z) (lock: Z) (id: Z) (PreH1 : (sem <> 0)) (PreH2 : (semaphore_irq_handler_ok lock )) (PreH3 : (SemaphoreRely hs before current_3 )) (PreH4 : (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current_3)))) id )) (PreH5 : (SemaphoreGuarantee current_3 (semaphore_os_publish (sem) (id) (val_pre) (current_3)) )) (PreH6 : (SemaphoreGuarantee current_3 (semaphore_nest_decrement ((semaphore_nest_increment ((semaphore_os_publish (sem) (id) (val_pre) (current_3)))))) )) ,
  (SemaphoreOutsideCritical sg hs (semaphore_nest_decrement ((semaphore_nest_increment ((semaphore_os_publish (sem) (id) (val_pre) (current_3)))))) )
|--
  (“ (id = (-5)) ”
  &&  (SemaphoreOutsideCritical sg hs before ))
  ||
  (EX (current: CrtosOSState) ,
  “ (id = (-5)) ” 
  &&  “ (SemaphoreRely hs before current ) ” 
  &&  “ (idmanager_full (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) ) ”
  &&  (SemaphoreOutsideCritical sg hs current ))
  ||
  (EX (current_2: CrtosOSState)  (p: Z) ,
  “ (p <> 0) ” 
  &&  “ (SemaphoreRely hs before current_2 ) ” 
  &&  “ (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current_2)))) id ) ” 
  &&  “ (SemaphoreGuarantee current_2 (semaphore_os_publish (p) (id) (val_pre) (current_2)) ) ”
  &&  (SemaphoreOutsideCritical sg hs (semaphore_os_publish (p) (id) (val_pre) (current_2)) ))
.

Definition _SemaphoreCreate_return_wit_2 := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current_3: CrtosOSState) (id: Z) (sem: Z) (lock: Z) (PreH1 : (id = (-1))) (PreH2 : (sem <> 0)) (PreH3 : (semaphore_irq_handler_ok lock )) (PreH4 : (SemaphoreRely hs before current_3 )) (PreH5 : (idmanager_full (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current_3)))) )) (PreH6 : (SemaphoreGuarantee current_3 (semaphore_nest_decrement ((semaphore_nest_increment (current_3)))) )) ,
  (SemaphoreOutsideCritical sg hs (semaphore_nest_decrement ((semaphore_nest_increment (current_3)))) )
|--
  (“ ((-5) = (-5)) ”
  &&  (SemaphoreOutsideCritical sg hs before ))
  ||
  (EX (current: CrtosOSState) ,
  “ ((-5) = (-5)) ” 
  &&  “ (SemaphoreRely hs before current ) ” 
  &&  “ (idmanager_full (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) ) ”
  &&  (SemaphoreOutsideCritical sg hs current ))
  ||
  (EX (current_2: CrtosOSState)  (p: Z) ,
  “ (p <> 0) ” 
  &&  “ (SemaphoreRely hs before current_2 ) ” 
  &&  “ (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current_2)))) (-5) ) ” 
  &&  “ (SemaphoreGuarantee current_2 (semaphore_os_publish (p) ((-5)) (val_pre) (current_2)) ) ”
  &&  (SemaphoreOutsideCritical sg hs (semaphore_os_publish (p) ((-5)) (val_pre) (current_2)) ))
.

Definition _SemaphoreCreate_return_wit_3 := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  (SemaphoreOutsideCritical sg hs before )
|--
  (“ ((-5) = (-5)) ”
  &&  (SemaphoreOutsideCritical sg hs before ))
  ||
  (EX (current: CrtosOSState) ,
  “ ((-5) = (-5)) ” 
  &&  “ (SemaphoreRely hs before current ) ” 
  &&  “ (idmanager_full (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) ) ”
  &&  (SemaphoreOutsideCritical sg hs current ))
  ||
  (EX (current_2: CrtosOSState)  (p: Z) ,
  “ (p <> 0) ” 
  &&  “ (SemaphoreRely hs before current_2 ) ” 
  &&  “ (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current_2)))) (-5) ) ” 
  &&  “ (SemaphoreGuarantee current_2 (semaphore_os_publish (p) ((-5)) (val_pre) (current_2)) ) ”
  &&  (SemaphoreOutsideCritical sg hs (semaphore_os_publish (p) ((-5)) (val_pre) (current_2)) ))
.

Definition _SemaphoreCreate_partial_solve_wit_1_pure := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (PreH1 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreOutsideCritical sg hs before )
|--
  “ (sizeof( "Semaphore" ) = 32) ”
.

Definition _SemaphoreCreate_partial_solve_wit_1_aux := 
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (PreH1 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  (SemaphoreOutsideCritical sg hs before )
|--
  “ (sizeof( "Semaphore" ) = 32) ” 
  &&  “ ((scheduler_lock_nest ((os_scheduler (before)))) < 65535) ”
  &&  (SemaphoreOutsideCritical sg hs before )
.

Definition _SemaphoreCreate_partial_solve_wit_1 := _SemaphoreCreate_partial_solve_wit_1_pure -> _SemaphoreCreate_partial_solve_wit_1_aux.

Definition _SemaphoreCreate_partial_solve_wit_2_pure := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (retval <> 0)) (PreH3 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  (OSHeap (store_sem_allocated (retval)) )
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreOutsideCritical sg hs before )
|--
  “ (0 = 0) ” 
  &&  “ (sizeof( "Semaphore" ) = 32) ”
.

Definition _SemaphoreCreate_partial_solve_wit_2_aux := 
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (retval <> 0)) (PreH3 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  (OSHeap (store_sem_allocated (retval)) )
  **  (SemaphoreOutsideCritical sg hs before )
|--
  “ (0 = 0) ” 
  &&  “ (sizeof( "Semaphore" ) = 32) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ ((scheduler_lock_nest ((os_scheduler (before)))) < 65535) ”
  &&  (OSHeap (store_sem_allocated (retval)) )
  **  (SemaphoreOutsideCritical sg hs before )
.

Definition _SemaphoreCreate_partial_solve_wit_2 := _SemaphoreCreate_partial_solve_wit_2_pure -> _SemaphoreCreate_partial_solve_wit_2_aux.

Definition _SemaphoreCreate_partial_solve_wit_3_pure := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 = retval)) (PreH2 : (retval <> 0)) (PreH3 : (retval <> 0)) (PreH4 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  (OSHeap (store_sem_zeroed_private (retval)) )
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreOutsideCritical sg hs before )
|--
  “ ((scheduler_lock_nest ((os_scheduler (before)))) < 65535) ”
.

Definition _SemaphoreCreate_partial_solve_wit_3_aux := 
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 = retval)) (PreH2 : (retval <> 0)) (PreH3 : (retval <> 0)) (PreH4 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) ,
  (OSHeap (store_sem_zeroed_private (retval)) )
  **  (SemaphoreOutsideCritical sg hs before )
|--
  “ ((scheduler_lock_nest ((os_scheduler (before)))) < 65535) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ ((scheduler_lock_nest ((os_scheduler (before)))) < 65535) ”
  &&  (SemaphoreOutsideCritical sg hs before )
  **  (OSHeap (store_sem_zeroed_private (retval)) )
.

Definition _SemaphoreCreate_partial_solve_wit_3 := _SemaphoreCreate_partial_solve_wit_3_pure -> _SemaphoreCreate_partial_solve_wit_3_aux.

Definition _SemaphoreCreate_partial_solve_wit_4_pure := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (id: Z) (sem: Z) (lock: Z) (PreH1 : (id = 0)) (PreH2 : (sem <> 0)) (PreH3 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH4 : (&((sem)  # "Semaphore" ->ₛ "id") <> 0)) (PreH5 : (semaphore_irq_handler_ok lock )) (PreH6 : (SemaphoreRely hs before current )) (PreH7 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH8 : (CrtosOSValid (semaphore_nest_increment (current)) )) ,
  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (( &( "k_sem_id_manager" ) ))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  (OSHeap (store_sem_id_detached (&((sem)  # "Semaphore" ->ₛ "id")) (0) (0) (0)) )
  **  (OSHeap (store_sem_registered_private (sem)) )
|--
  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "id") <> 0) ”
.

Definition _SemaphoreCreate_partial_solve_wit_4_aux := 
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (id: Z) (sem: Z) (lock: Z) (PreH1 : (id = 0)) (PreH2 : (sem <> 0)) (PreH3 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH4 : (&((sem)  # "Semaphore" ->ₛ "id") <> 0)) (PreH5 : (semaphore_irq_handler_ok lock )) (PreH6 : (SemaphoreRely hs before current )) (PreH7 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH8 : (CrtosOSValid (semaphore_nest_increment (current)) )) ,
  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (( &( "k_sem_id_manager" ) ))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  (OSHeap (store_sem_id_detached (&((sem)  # "Semaphore" ->ₛ "id")) (0) (0) (0)) )
  **  (OSHeap (store_sem_registered_private (sem)) )
|--
  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "id") <> 0) ” 
  &&  “ (id = 0) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "id") <> 0) ” 
  &&  “ (semaphore_irq_handler_ok lock ) ” 
  &&  “ (SemaphoreRely hs before current ) ” 
  &&  “ ((scheduler_lock_nest ((os_scheduler (before)))) < 65535) ” 
  &&  “ (CrtosOSValid (semaphore_nest_increment (current)) ) ”
  &&  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (( &( "k_sem_id_manager" ) ))) )
  **  (OSHeap (store_sem_id_detached (&((sem)  # "Semaphore" ->ₛ "id")) (0) (0) (0)) )
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  (OSHeap (store_sem_registered_private (sem)) )
.

Definition _SemaphoreCreate_partial_solve_wit_4 := _SemaphoreCreate_partial_solve_wit_4_pure -> _SemaphoreCreate_partial_solve_wit_4_aux.

Definition _SemaphoreCreate_partial_solve_wit_5 := 
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (id: Z) (sem: Z) (lock: Z) (PreH1 : (id = (-1))) (PreH2 : (sem <> 0)) (PreH3 : (semaphore_irq_handler_ok lock )) (PreH4 : (SemaphoreRely hs before current )) (PreH5 : (idmanager_full (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) )) (PreH6 : (SemaphoreGuarantee current (semaphore_nest_decrement ((semaphore_nest_increment (current)))) )) ,
  (SemaphoreInsideCritical sg hs lock current )
  **  (SemaphoreOSInvariant sg (semaphore_nest_increment (current)) )
  **  (OSHeap (store_sem_zeroed_private (sem)) )
|--
  “ (id = (-1)) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (semaphore_irq_handler_ok lock ) ” 
  &&  “ (SemaphoreRely hs before current ) ” 
  &&  “ (idmanager_full (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) ) ” 
  &&  “ (SemaphoreGuarantee current (semaphore_nest_decrement ((semaphore_nest_increment (current)))) ) ”
  &&  (OSHeap (store_sem_zeroed_private (sem)) )
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (SemaphoreOSInvariant sg (semaphore_nest_increment (current)) )
.

Definition _SemaphoreCreate_partial_solve_wit_6_pure := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (id: Z) (sem: Z) (lock: Z) (PreH1 : (id = (-1))) (PreH2 : (sem <> 0)) (PreH3 : (semaphore_irq_handler_ok lock )) (PreH4 : (SemaphoreRely hs before current )) (PreH5 : (idmanager_full (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) )) (PreH6 : (SemaphoreGuarantee current (semaphore_nest_decrement ((semaphore_nest_increment (current)))) )) ,
  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (SemaphoreOSInvariant sg (semaphore_nest_increment (current)) )
|--
  “ (semaphore_irq_handler_ok lock ) ” 
  &&  “ (SemaphoreGuarantee current (semaphore_nest_decrement ((semaphore_nest_increment (current)))) ) ”
.

Definition _SemaphoreCreate_partial_solve_wit_6_aux := 
forall (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (id: Z) (sem: Z) (lock: Z) (PreH1 : (id = (-1))) (PreH2 : (sem <> 0)) (PreH3 : (semaphore_irq_handler_ok lock )) (PreH4 : (SemaphoreRely hs before current )) (PreH5 : (idmanager_full (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) )) (PreH6 : (SemaphoreGuarantee current (semaphore_nest_decrement ((semaphore_nest_increment (current)))) )) ,
  (SemaphoreInsideCritical sg hs lock current )
  **  (SemaphoreOSInvariant sg (semaphore_nest_increment (current)) )
|--
  “ (semaphore_irq_handler_ok lock ) ” 
  &&  “ (SemaphoreGuarantee current (semaphore_nest_decrement ((semaphore_nest_increment (current)))) ) ” 
  &&  “ (id = (-1)) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (semaphore_irq_handler_ok lock ) ” 
  &&  “ (SemaphoreRely hs before current ) ” 
  &&  “ (idmanager_full (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) ) ” 
  &&  “ (SemaphoreGuarantee current (semaphore_nest_decrement ((semaphore_nest_increment (current)))) ) ”
  &&  (SemaphoreInsideCritical sg hs lock current )
  **  (SemaphoreOSInvariant sg (semaphore_nest_increment (current)) )
.

Definition _SemaphoreCreate_partial_solve_wit_6 := _SemaphoreCreate_partial_solve_wit_6_pure -> _SemaphoreCreate_partial_solve_wit_6_aux.

Definition _SemaphoreCreate_partial_solve_wit_7_pure := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (sem: Z) (lock: Z) (id: Z) (PreH1 : (sem <> 0)) (PreH2 : (semaphore_object_addresses sem )) (PreH3 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH4 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH5 : (semaphore_irq_handler_ok lock )) (PreH6 : (SemaphoreRely hs before current )) (PreH7 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH8 : (CrtosOSValid (semaphore_nest_increment (current)) )) (PreH9 : (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) id )) ,
  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |->_)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  (OSHeap (store_sem_padding (sem)) )
|--
  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") = &((sem)  # "Semaphore" ->ₛ "pend_list")) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ”
.

Definition _SemaphoreCreate_partial_solve_wit_7_aux := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (sem: Z) (lock: Z) (id: Z) (PreH1 : (sem <> 0)) (PreH2 : (semaphore_object_addresses sem )) (PreH3 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH4 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH5 : (semaphore_irq_handler_ok lock )) (PreH6 : (SemaphoreRely hs before current )) (PreH7 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH8 : (CrtosOSValid (semaphore_nest_increment (current)) )) (PreH9 : (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) id )) ,
  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |->_)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  (OSHeap (store_sem_padding (sem)) )
|--
  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") = &((sem)  # "Semaphore" ->ₛ "pend_list")) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (semaphore_object_addresses sem ) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ” 
  &&  “ (semaphore_irq_handler_ok lock ) ” 
  &&  “ (SemaphoreRely hs before current ) ” 
  &&  “ ((scheduler_lock_nest ((os_scheduler (before)))) < 65535) ” 
  &&  “ (CrtosOSValid (semaphore_nest_increment (current)) ) ” 
  &&  “ (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) id ) ”
  &&  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |->_)
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |->_)
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  (OSHeap (store_sem_registry ((os_sem_stable (sg))) ((os_semaphores (current)))) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  (OSHeap (store_sem_padding (sem)) )
.

Definition _SemaphoreCreate_partial_solve_wit_7 := _SemaphoreCreate_partial_solve_wit_7_pure -> _SemaphoreCreate_partial_solve_wit_7_aux.

Definition _SemaphoreCreate_partial_solve_wit_8_pure := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (payload: (Z -> (SemaphoreObject -> Task_C_Rules.expr))) (nodes: (@list (@DL_Node SemaphoreObject))) (successor: Z) (sem: Z) (lock: Z) (id: Z) (PreH1 : forall (address: Z) , forall (obj: SemaphoreObject) , ((payload (address) (obj)) = (store_semaphore_body (obj)))) (PreH2 : ((map (data) (nodes)) = (os_semaphores (current)))) (PreH3 : forall (node: (@DL_Node SemaphoreObject)) , ((In node nodes ) -> ((ptr (node)) = &(((semaphore_addr ((data (node)))))  # "Semaphore" ->ₛ "link")))) (PreH4 : (DLL.dll_nodes_nonzero nodes )) (PreH5 : (( &( "k_sem_list" ) ) <> 0)) (PreH6 : (successor <> 0)) (PreH7 : (sem <> 0)) (PreH8 : (semaphore_object_addresses sem )) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH10 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH11 : (semaphore_irq_handler_ok lock )) (PreH12 : (SemaphoreRely hs before current )) (PreH13 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH14 : (CrtosOSValid (semaphore_nest_increment (current)) )) (PreH15 : (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) id )) ,
  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  ((&(( &( "k_sem_list" ) )->ₛ "node_next")) # Ptr  |-> successor)
  **  ((&((successor)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> ( &( "k_sem_list" ) ))
  **  (OSHeap (DLL.dllseg_shift_rev (payload) (successor) (( &( "k_sem_list" ) )) (nodes)) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "pend_list"))
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "pend_list"))
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  (OSHeap (store_sem_padding (sem)) )
|--
  “ (( &( "k_sem_list" ) ) <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ” 
  &&  “ (successor <> 0) ”
.

Definition _SemaphoreCreate_partial_solve_wit_8_aux := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (payload: (Z -> (SemaphoreObject -> Task_C_Rules.expr))) (nodes: (@list (@DL_Node SemaphoreObject))) (successor: Z) (sem: Z) (lock: Z) (id: Z) (PreH1 : forall (address: Z) , forall (obj: SemaphoreObject) , ((payload (address) (obj)) = (store_semaphore_body (obj)))) (PreH2 : ((map (data) (nodes)) = (os_semaphores (current)))) (PreH3 : forall (node: (@DL_Node SemaphoreObject)) , ((In node nodes ) -> ((ptr (node)) = &(((semaphore_addr ((data (node)))))  # "Semaphore" ->ₛ "link")))) (PreH4 : (DLL.dll_nodes_nonzero nodes )) (PreH5 : (( &( "k_sem_list" ) ) <> 0)) (PreH6 : (successor <> 0)) (PreH7 : (sem <> 0)) (PreH8 : (semaphore_object_addresses sem )) (PreH9 : (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0)) (PreH10 : (&((sem)  # "Semaphore" ->ₛ "link") <> 0)) (PreH11 : (semaphore_irq_handler_ok lock )) (PreH12 : (SemaphoreRely hs before current )) (PreH13 : ((scheduler_lock_nest ((os_scheduler (before)))) < 65535)) (PreH14 : (CrtosOSValid (semaphore_nest_increment (current)) )) (PreH15 : (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) id )) ,
  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  ((&(( &( "k_sem_list" ) )->ₛ "node_next")) # Ptr  |-> successor)
  **  ((&((successor)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> ( &( "k_sem_list" ) ))
  **  (OSHeap (DLL.dllseg_shift_rev (payload) (successor) (( &( "k_sem_list" ) )) (nodes)) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "pend_list"))
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "pend_list"))
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  (OSHeap (store_sem_padding (sem)) )
|--
  “ (( &( "k_sem_list" ) ) <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ” 
  &&  “ (successor <> 0) ” 
  &&  “ forall (address: Z) , forall (obj: SemaphoreObject) , ((payload (address) (obj)) = (store_semaphore_body (obj))) ” 
  &&  “ ((map (data) (nodes)) = (os_semaphores (current))) ” 
  &&  “ forall (node: (@DL_Node SemaphoreObject)) , ((In node nodes ) -> ((ptr (node)) = &(((semaphore_addr ((data (node)))))  # "Semaphore" ->ₛ "link"))) ” 
  &&  “ (DLL.dll_nodes_nonzero nodes ) ” 
  &&  “ (( &( "k_sem_list" ) ) <> 0) ” 
  &&  “ (successor <> 0) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (semaphore_object_addresses sem ) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") <> 0) ” 
  &&  “ (&((sem)  # "Semaphore" ->ₛ "link") <> 0) ” 
  &&  “ (semaphore_irq_handler_ok lock ) ” 
  &&  “ (SemaphoreRely hs before current ) ” 
  &&  “ ((scheduler_lock_nest ((os_scheduler (before)))) < 65535) ” 
  &&  “ (CrtosOSValid (semaphore_nest_increment (current)) ) ” 
  &&  “ (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) id ) ”
  &&  ((&(( &( "k_sem_list" ) )->ₛ "node_next")) # Ptr  |-> successor)
  **  ((&((successor)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> ( &( "k_sem_list" ) ))
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (OSHeap (CrtosBorrowedRep.store_task_semaphore_views ((os_tasks (current)))) )
  **  (OSHeap (CrtosBorrowedRep.store_scheduler_view ((os_scheduler ((semaphore_nest_increment (current)))))) )
  **  (OSHeap (store_idmanager ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_link ((semaphore_manager_abs ((os_sem_stable (sg))))) ((idmanager_add ((semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current))))) (id))) (id) (&((sem)  # "Semaphore" ->ₛ "id")))) (( &( "k_sem_id_manager" ) ))) )
  **  (OSHeap (DLL.dllseg_shift_rev (payload) (successor) (( &( "k_sem_list" ) )) (nodes)) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "pend_list"))
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |-> &((sem)  # "Semaphore" ->ₛ "pend_list"))
  **  (OSHeap (store_sem_padding (sem)) )
.

Definition _SemaphoreCreate_partial_solve_wit_8 := _SemaphoreCreate_partial_solve_wit_8_pure -> _SemaphoreCreate_partial_solve_wit_8_aux.

Definition _SemaphoreCreate_partial_solve_wit_9_pure := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (sem: Z) (lock: Z) (id: Z) (PreH1 : (sem <> 0)) (PreH2 : (semaphore_irq_handler_ok lock )) (PreH3 : (SemaphoreRely hs before current )) (PreH4 : (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) id )) (PreH5 : (SemaphoreGuarantee current (semaphore_os_publish (sem) (id) (val_pre) (current)) )) (PreH6 : (SemaphoreGuarantee current (semaphore_nest_decrement ((semaphore_nest_increment ((semaphore_os_publish (sem) (id) (val_pre) (current)))))) )) ,
  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "lock" ) )) # Int  |-> lock)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  (SemaphoreInsideCritical sg hs lock current )
  **  (SemaphoreOSInvariant sg (semaphore_nest_increment ((semaphore_os_publish (sem) (id) (val_pre) (current)))) )
|--
  “ (semaphore_irq_handler_ok lock ) ” 
  &&  “ (SemaphoreGuarantee current (semaphore_nest_decrement ((semaphore_nest_increment ((semaphore_os_publish (sem) (id) (val_pre) (current)))))) ) ”
.

Definition _SemaphoreCreate_partial_solve_wit_9_aux := 
forall (val_pre: Z) (before: CrtosOSState) (hs: (@list Z)) (sg: CrtosOSStable) (current: CrtosOSState) (sem: Z) (lock: Z) (id: Z) (PreH1 : (sem <> 0)) (PreH2 : (semaphore_irq_handler_ok lock )) (PreH3 : (SemaphoreRely hs before current )) (PreH4 : (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) id )) (PreH5 : (SemaphoreGuarantee current (semaphore_os_publish (sem) (id) (val_pre) (current)) )) (PreH6 : (SemaphoreGuarantee current (semaphore_nest_decrement ((semaphore_nest_increment ((semaphore_os_publish (sem) (id) (val_pre) (current)))))) )) ,
  (SemaphoreInsideCritical sg hs lock current )
  **  (SemaphoreOSInvariant sg (semaphore_nest_increment ((semaphore_os_publish (sem) (id) (val_pre) (current)))) )
|--
  “ (semaphore_irq_handler_ok lock ) ” 
  &&  “ (SemaphoreGuarantee current (semaphore_nest_decrement ((semaphore_nest_increment ((semaphore_os_publish (sem) (id) (val_pre) (current)))))) ) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (semaphore_irq_handler_ok lock ) ” 
  &&  “ (SemaphoreRely hs before current ) ” 
  &&  “ (idmanager_min_free_id (semaphore_manager_abs ((os_sem_stable (sg)))) (semaphore_manager_state ((os_sem_stable (sg))) ((os_semaphores (current)))) id ) ” 
  &&  “ (SemaphoreGuarantee current (semaphore_os_publish (sem) (id) (val_pre) (current)) ) ” 
  &&  “ (SemaphoreGuarantee current (semaphore_nest_decrement ((semaphore_nest_increment ((semaphore_os_publish (sem) (id) (val_pre) (current)))))) ) ”
  &&  (SemaphoreInsideCritical sg hs lock current )
  **  (SemaphoreOSInvariant sg (semaphore_nest_increment ((semaphore_os_publish (sem) (id) (val_pre) (current)))) )
.

Definition _SemaphoreCreate_partial_solve_wit_9 := _SemaphoreCreate_partial_solve_wit_9_pure -> _SemaphoreCreate_partial_solve_wit_9_aux.

Module Type VC_Correct.


Axiom proof_of__SemaphoreCreate_safety_wit_1 : _SemaphoreCreate_safety_wit_1.
Axiom proof_of__SemaphoreCreate_safety_wit_2 : _SemaphoreCreate_safety_wit_2.
Axiom proof_of__SemaphoreCreate_safety_wit_3 : _SemaphoreCreate_safety_wit_3.
Axiom proof_of__SemaphoreCreate_safety_wit_4 : _SemaphoreCreate_safety_wit_4.
Axiom proof_of__SemaphoreCreate_safety_wit_5 : _SemaphoreCreate_safety_wit_5.
Axiom proof_of__SemaphoreCreate_safety_wit_6 : _SemaphoreCreate_safety_wit_6.
Axiom proof_of__SemaphoreCreate_safety_wit_7 : _SemaphoreCreate_safety_wit_7.
Axiom proof_of__SemaphoreCreate_safety_wit_8 : _SemaphoreCreate_safety_wit_8.
Axiom proof_of__SemaphoreCreate_safety_wit_9 : _SemaphoreCreate_safety_wit_9.
Axiom proof_of__SemaphoreCreate_safety_wit_10 : _SemaphoreCreate_safety_wit_10.
Axiom proof_of__SemaphoreCreate_safety_wit_11 : _SemaphoreCreate_safety_wit_11.
Axiom proof_of__SemaphoreCreate_safety_wit_12 : _SemaphoreCreate_safety_wit_12.
Axiom proof_of__SemaphoreCreate_safety_wit_13 : _SemaphoreCreate_safety_wit_13.
Axiom proof_of__SemaphoreCreate_safety_wit_14 : _SemaphoreCreate_safety_wit_14.
Axiom proof_of__SemaphoreCreate_safety_wit_15 : _SemaphoreCreate_safety_wit_15.
Axiom proof_of__SemaphoreCreate_entail_wit_1 : _SemaphoreCreate_entail_wit_1.
Axiom proof_of__SemaphoreCreate_entail_wit_2_1 : _SemaphoreCreate_entail_wit_2_1.
Axiom proof_of__SemaphoreCreate_entail_wit_2_2 : _SemaphoreCreate_entail_wit_2_2.
Axiom proof_of__SemaphoreCreate_entail_wit_3 : _SemaphoreCreate_entail_wit_3.
Axiom proof_of__SemaphoreCreate_entail_wit_4 : _SemaphoreCreate_entail_wit_4.
Axiom proof_of__SemaphoreCreate_entail_wit_5 : _SemaphoreCreate_entail_wit_5.
Axiom proof_of__SemaphoreCreate_return_wit_1 : _SemaphoreCreate_return_wit_1.
Axiom proof_of__SemaphoreCreate_return_wit_2 : _SemaphoreCreate_return_wit_2.
Axiom proof_of__SemaphoreCreate_return_wit_3 : _SemaphoreCreate_return_wit_3.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_1_pure : _SemaphoreCreate_partial_solve_wit_1_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_1 : _SemaphoreCreate_partial_solve_wit_1.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_2_pure : _SemaphoreCreate_partial_solve_wit_2_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_2 : _SemaphoreCreate_partial_solve_wit_2.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_3_pure : _SemaphoreCreate_partial_solve_wit_3_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_3 : _SemaphoreCreate_partial_solve_wit_3.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_4_pure : _SemaphoreCreate_partial_solve_wit_4_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_4 : _SemaphoreCreate_partial_solve_wit_4.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_5 : _SemaphoreCreate_partial_solve_wit_5.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_6_pure : _SemaphoreCreate_partial_solve_wit_6_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_6 : _SemaphoreCreate_partial_solve_wit_6.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_7_pure : _SemaphoreCreate_partial_solve_wit_7_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_7 : _SemaphoreCreate_partial_solve_wit_7.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_8_pure : _SemaphoreCreate_partial_solve_wit_8_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_8 : _SemaphoreCreate_partial_solve_wit_8.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_9_pure : _SemaphoreCreate_partial_solve_wit_9_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_9 : _SemaphoreCreate_partial_solve_wit_9.

End VC_Correct.
