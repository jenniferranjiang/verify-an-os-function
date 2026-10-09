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
Require Import Coq.Lists.List.
Require Import CRTOS_Verify.lib.CrtosGlobState.
Require Import CRTOS_Verify.sem.SemaphorePure.
Require Import CRTOS_Verify.sem.CrtosOSPure.
Require Import CRTOS_Verify.sem.SemaphoreProtocol.
Require Import CRTOS_Verify.sem.SemaphoreRep.
Require Import CRTOS_Verify.sem.CrtosOSRep.
Require Import CRTOS_Verify.sem.SemaphoreCritical.
Require Import CRTOS_Verify.VC.SemaphoreProofLocal.
From MonadLib.StateRelMonad Require Import StateRelBasic safeexec_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Local Open Scope sac.

(*----- Function _SemaphoreCreate -----*)

Definition _SemaphoreCreate_safety_wit_1 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (PreH1 : (sizeof( "Semaphore" ) = 32)) (PreH2 : (0 <= val_pre)) (PreH3 : (val_pre <= 65535)) (PreH4 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  ((( &( "id" ) )) # Int  |->_)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreCriticalOutside stable before )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_2 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (PreH1 : (sizeof( "Semaphore" ) = 32)) (PreH2 : (0 <= val_pre)) (PreH3 : (val_pre <= 65535)) (PreH4 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  ((( &( "lock" ) )) # Int  |->_)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreCriticalOutside stable before )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_3 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (PreH1 : (sizeof( "Semaphore" ) = 32)) (PreH2 : (0 <= val_pre)) (PreH3 : (val_pre <= 65535)) (PreH4 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  ((( &( "sem" ) )) # Ptr  |->_)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreCriticalOutside stable before )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_4 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (sizeof( "Semaphore" ) = 32)) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreCriticalOutside stable before )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_5 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (sizeof( "Semaphore" ) = 32)) (PreH3 : (0 <= val_pre)) (PreH4 : (val_pre <= 65535)) (PreH5 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (store_sem_allocated retval )
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreCriticalOutside stable before )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_6 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (retval = 0)) (PreH3 : (sizeof( "Semaphore" ) = 32)) (PreH4 : (0 <= val_pre)) (PreH5 : (val_pre <= 65535)) (PreH6 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreCriticalOutside stable before )
|--
  “ False ”
.

Definition _SemaphoreCreate_safety_wit_7 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval <> 0)) (PreH3 : (sizeof( "Semaphore" ) = 32)) (PreH4 : (0 <= val_pre)) (PreH5 : (val_pre <= 65535)) (PreH6 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (store_sem_allocated retval )
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreCriticalOutside stable before )
|--
  “ False ”
.

Definition _SemaphoreCreate_safety_wit_8 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : (sizeof( "Semaphore" ) = 32)) (PreH4 : (0 <= val_pre)) (PreH5 : (val_pre <= 65535)) (PreH6 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreCriticalOutside stable before )
|--
  “ (5 <> (INT_MIN)) ”
.

Definition _SemaphoreCreate_safety_wit_9 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : (sizeof( "Semaphore" ) = 32)) (PreH4 : (0 <= val_pre)) (PreH5 : (val_pre <= 65535)) (PreH6 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreCriticalOutside stable before )
|--
  “ (5 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 5) ”
.

Definition _SemaphoreCreate_safety_wit_10 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (retval <> 0)) (PreH3 : (sizeof( "Semaphore" ) = 32)) (PreH4 : (0 <= val_pre)) (PreH5 : (val_pre <= 65535)) (PreH6 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (store_sem_allocated retval )
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreCriticalOutside stable before )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_11 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH2 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH3 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH4 : (semaphore_layout_32_ok retval )) (PreH5 : (0 <= retval_4)) (PreH6 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_4)))) (PreH7 : (semaphore_layout_32_ok retval )) (PreH8 : (crtos_os_world_wf stable current )) (PreH9 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH10 : (retval_3 = handler)) (PreH11 : (semaphore_irq_handler_ok handler )) (PreH12 : (SemaphoreRely stable before current )) (PreH13 : (retval_2 = retval)) (PreH14 : (retval <> 0)) (PreH15 : (retval <> 0)) (PreH16 : (sizeof( "Semaphore" ) = 32)) (PreH17 : (0 <= val_pre)) (PreH18 : (val_pre <= 65535)) (PreH19 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (retval) (retval_4)) )
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_sem_after_id_insert_private retval )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_12 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH2 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH3 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH4 : (semaphore_layout_32_ok retval )) (PreH5 : (retval_4 = (-1))) (PreH6 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = None)) (PreH7 : (semaphore_layout_32_ok retval )) (PreH8 : (crtos_os_world_wf stable current )) (PreH9 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH10 : (retval_3 = handler)) (PreH11 : (semaphore_irq_handler_ok handler )) (PreH12 : (SemaphoreRely stable before current )) (PreH13 : (retval_2 = retval)) (PreH14 : (retval <> 0)) (PreH15 : (retval <> 0)) (PreH16 : (sizeof( "Semaphore" ) = 32)) (PreH17 : (0 <= val_pre)) (PreH18 : (val_pre <= 65535)) (PreH19 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_sem_id_node_zeroed retval )
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_sem_after_id_insert_private retval )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreCreate_safety_wit_13 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval_4 < 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH4 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH5 : (semaphore_layout_32_ok retval )) (PreH6 : (0 <= retval_4)) (PreH7 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_4)))) (PreH8 : (semaphore_layout_32_ok retval )) (PreH9 : (crtos_os_world_wf stable current )) (PreH10 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH11 : (retval_3 = handler)) (PreH12 : (semaphore_irq_handler_ok handler )) (PreH13 : (SemaphoreRely stable before current )) (PreH14 : (retval_2 = retval)) (PreH15 : (retval <> 0)) (PreH16 : (retval <> 0)) (PreH17 : (sizeof( "Semaphore" ) = 32)) (PreH18 : (0 <= val_pre)) (PreH19 : (val_pre <= 65535)) (PreH20 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (retval) (retval_4)) )
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_sem_after_id_insert_private retval )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ False ”
.

Definition _SemaphoreCreate_safety_wit_14 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval_4 >= 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH4 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH5 : (semaphore_layout_32_ok retval )) (PreH6 : (retval_4 = (-1))) (PreH7 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = None)) (PreH8 : (semaphore_layout_32_ok retval )) (PreH9 : (crtos_os_world_wf stable current )) (PreH10 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH11 : (retval_3 = handler)) (PreH12 : (semaphore_irq_handler_ok handler )) (PreH13 : (SemaphoreRely stable before current )) (PreH14 : (retval_2 = retval)) (PreH15 : (retval <> 0)) (PreH16 : (retval <> 0)) (PreH17 : (sizeof( "Semaphore" ) = 32)) (PreH18 : (0 <= val_pre)) (PreH19 : (val_pre <= 65535)) (PreH20 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_sem_id_node_zeroed retval )
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_sem_after_id_insert_private retval )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ False ”
.

Definition _SemaphoreCreate_safety_wit_15 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval_4 < 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH4 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH5 : (semaphore_layout_32_ok retval )) (PreH6 : (retval_4 = (-1))) (PreH7 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = None)) (PreH8 : (semaphore_layout_32_ok retval )) (PreH9 : (crtos_os_world_wf stable current )) (PreH10 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH11 : (retval_3 = handler)) (PreH12 : (semaphore_irq_handler_ok handler )) (PreH13 : (SemaphoreRely stable before current )) (PreH14 : (retval_2 = retval)) (PreH15 : (retval <> 0)) (PreH16 : (retval <> 0)) (PreH17 : (sizeof( "Semaphore" ) = 32)) (PreH18 : (0 <= val_pre)) (PreH19 : (val_pre <= 65535)) (PreH20 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (SemaphoreCriticalOutside stable current )
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (5 <> (INT_MIN)) ”
.

Definition _SemaphoreCreate_safety_wit_16 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval_4 < 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH4 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH5 : (semaphore_layout_32_ok retval )) (PreH6 : (retval_4 = (-1))) (PreH7 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = None)) (PreH8 : (semaphore_layout_32_ok retval )) (PreH9 : (crtos_os_world_wf stable current )) (PreH10 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH11 : (retval_3 = handler)) (PreH12 : (semaphore_irq_handler_ok handler )) (PreH13 : (SemaphoreRely stable before current )) (PreH14 : (retval_2 = retval)) (PreH15 : (retval <> 0)) (PreH16 : (retval <> 0)) (PreH17 : (sizeof( "Semaphore" ) = 32)) (PreH18 : (0 <= val_pre)) (PreH19 : (val_pre <= 65535)) (PreH20 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (SemaphoreCriticalOutside stable current )
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (5 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 5) ”
.

Definition _SemaphoreCreate_return_wit_1 := 
(
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval_2: Z) (retval_3: Z) (retval_4: Z) (handler: Z) (current_3: CrtosOSWorld) (retval: Z) (PreH1 : (crtos_os_world_wf stable (Build_CrtosOSWorld ((crtos_task_state (current_3))) ((crtos_scheduler_state (current_3))) ((semaphore_create_state ((crtos_semaphore_state (current_3))) (retval_2) (retval) (val_pre)))) )) (PreH2 : (retval_2 <> 0)) (PreH3 : (retval >= 0)) (PreH4 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH5 : (&((retval_2)  # "Semaphore" ->ₛ "id") <> 0)) (PreH6 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH7 : (semaphore_layout_32_ok retval_2 )) (PreH8 : (0 <= retval)) (PreH9 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current_3)))) = (Some (retval)))) (PreH10 : (semaphore_layout_32_ok retval_2 )) (PreH11 : (crtos_os_world_wf stable current_3 )) (PreH12 : ((semaphore_find_addr (retval_2) ((semaphore_objects ((crtos_semaphore_state (current_3)))))) = None)) (PreH13 : (retval_4 = handler)) (PreH14 : (semaphore_irq_handler_ok handler )) (PreH15 : (SemaphoreRely stable before current_3 )) (PreH16 : (retval_3 = retval_2)) (PreH17 : (retval_2 <> 0)) (PreH18 : (retval_2 <> 0)) (PreH19 : (sizeof( "Semaphore" ) = 32)) (PreH20 : (0 <= val_pre)) (PreH21 : (val_pre <= 65535)) (PreH22 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (SemaphoreCriticalOutside stable (Build_CrtosOSWorld ((crtos_task_state (current_3))) ((crtos_scheduler_state (current_3))) ((semaphore_create_state ((crtos_semaphore_state (current_3))) (retval_2) (retval) (val_pre)))) )
|--
  EX (after_2: CrtosOSWorld)  (current_2: CrtosOSWorld)  (sem: Z)  (id: Z) ,
  “ (retval = id) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id < 128) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (SemaphoreRely stable before current_2 ) ” 
  &&  “ ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current_2)))) = (Some (id))) ” 
  &&  “ (after_2 = (Build_CrtosOSWorld ((crtos_task_state (current_2))) ((crtos_scheduler_state (current_2))) ((semaphore_create_state ((crtos_semaphore_state (current_2))) (sem) (id) (val_pre))))) ” 
  &&  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (after_2)))) (return (retval)) X ) ”
  &&  (SemaphoreCriticalOutside stable after_2 )
) \/
(
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval_2: Z) (retval_3: Z) (retval_4: Z) (handler: Z) (current_3: CrtosOSWorld) (retval: Z) (PreH1 : (crtos_os_world_wf stable (Build_CrtosOSWorld ((crtos_task_state (current_3))) ((crtos_scheduler_state (current_3))) ((semaphore_create_state ((crtos_semaphore_state (current_3))) (retval_2) (retval) (val_pre)))) )) (PreH2 : (retval_2 <> 0)) (PreH3 : (retval >= 0)) (PreH4 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH5 : (&((retval_2)  # "Semaphore" ->ₛ "id") <> 0)) (PreH6 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH7 : (semaphore_layout_32_ok retval_2 )) (PreH8 : (0 <= retval)) (PreH9 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current_3)))) = (Some (retval)))) (PreH10 : (semaphore_layout_32_ok retval_2 )) (PreH11 : (crtos_os_world_wf stable current_3 )) (PreH12 : ((semaphore_find_addr (retval_2) ((semaphore_objects ((crtos_semaphore_state (current_3)))))) = None)) (PreH13 : (retval_4 = handler)) (PreH14 : (semaphore_irq_handler_ok handler )) (PreH15 : (SemaphoreRely stable before current_3 )) (PreH16 : (retval_3 = retval_2)) (PreH17 : (retval_2 <> 0)) (PreH18 : (retval_2 <> 0)) (PreH19 : (sizeof( "Semaphore" ) = 32)) (PreH20 : (0 <= val_pre)) (PreH21 : (val_pre <= 65535)) (PreH22 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  TT && emp 
|--
  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state ((Build_CrtosOSWorld ((crtos_task_state (current_3))) ((crtos_scheduler_state (current_3))) ((semaphore_create_state ((crtos_semaphore_state (current_3))) (retval_2) (retval) (val_pre)))))))) (return (retval)) X ) ” 
  &&  “ (retval < 128) ”
  &&  emp
).

Definition _SemaphoreCreate_return_wit_1_split_goal_1 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval_2: Z) (retval_3: Z) (retval_4: Z) (handler: Z) (current_3: CrtosOSWorld) (retval: Z) (PreH1 : (crtos_os_world_wf stable (Build_CrtosOSWorld ((crtos_task_state (current_3))) ((crtos_scheduler_state (current_3))) ((semaphore_create_state ((crtos_semaphore_state (current_3))) (retval_2) (retval) (val_pre)))) )) (PreH2 : (retval_2 <> 0)) (PreH3 : (retval >= 0)) (PreH4 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH5 : (&((retval_2)  # "Semaphore" ->ₛ "id") <> 0)) (PreH6 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH7 : (semaphore_layout_32_ok retval_2 )) (PreH8 : (0 <= retval)) (PreH9 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current_3)))) = (Some (retval)))) (PreH10 : (semaphore_layout_32_ok retval_2 )) (PreH11 : (crtos_os_world_wf stable current_3 )) (PreH12 : ((semaphore_find_addr (retval_2) ((semaphore_objects ((crtos_semaphore_state (current_3)))))) = None)) (PreH13 : (retval_4 = handler)) (PreH14 : (semaphore_irq_handler_ok handler )) (PreH15 : (SemaphoreRely stable before current_3 )) (PreH16 : (retval_3 = retval_2)) (PreH17 : (retval_2 <> 0)) (PreH18 : (retval_2 <> 0)) (PreH19 : (sizeof( "Semaphore" ) = 32)) (PreH20 : (0 <= val_pre)) (PreH21 : (val_pre <= 65535)) (PreH22 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state ((Build_CrtosOSWorld ((crtos_task_state (current_3))) ((crtos_scheduler_state (current_3))) ((semaphore_create_state ((crtos_semaphore_state (current_3))) (retval_2) (retval) (val_pre)))))))) (return (retval)) X )
.

Definition _SemaphoreCreate_return_wit_1_split_goal_2 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval_2: Z) (retval_3: Z) (retval_4: Z) (handler: Z) (current_3: CrtosOSWorld) (retval: Z) (PreH1 : (crtos_os_world_wf stable (Build_CrtosOSWorld ((crtos_task_state (current_3))) ((crtos_scheduler_state (current_3))) ((semaphore_create_state ((crtos_semaphore_state (current_3))) (retval_2) (retval) (val_pre)))) )) (PreH2 : (retval_2 <> 0)) (PreH3 : (retval >= 0)) (PreH4 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH5 : (&((retval_2)  # "Semaphore" ->ₛ "id") <> 0)) (PreH6 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH7 : (semaphore_layout_32_ok retval_2 )) (PreH8 : (0 <= retval)) (PreH9 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current_3)))) = (Some (retval)))) (PreH10 : (semaphore_layout_32_ok retval_2 )) (PreH11 : (crtos_os_world_wf stable current_3 )) (PreH12 : ((semaphore_find_addr (retval_2) ((semaphore_objects ((crtos_semaphore_state (current_3)))))) = None)) (PreH13 : (retval_4 = handler)) (PreH14 : (semaphore_irq_handler_ok handler )) (PreH15 : (SemaphoreRely stable before current_3 )) (PreH16 : (retval_3 = retval_2)) (PreH17 : (retval_2 <> 0)) (PreH18 : (retval_2 <> 0)) (PreH19 : (sizeof( "Semaphore" ) = 32)) (PreH20 : (0 <= val_pre)) (PreH21 : (val_pre <= 65535)) (PreH22 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (retval < 128)
.

Definition _SemaphoreCreate_return_wit_2 := 
(
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current_3: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval_4 < 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH4 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH5 : (semaphore_layout_32_ok retval )) (PreH6 : (retval_4 = (-1))) (PreH7 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current_3)))) = None)) (PreH8 : (semaphore_layout_32_ok retval )) (PreH9 : (crtos_os_world_wf stable current_3 )) (PreH10 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current_3)))))) = None)) (PreH11 : (retval_3 = handler)) (PreH12 : (semaphore_irq_handler_ok handler )) (PreH13 : (SemaphoreRely stable before current_3 )) (PreH14 : (retval_2 = retval)) (PreH15 : (retval <> 0)) (PreH16 : (retval <> 0)) (PreH17 : (sizeof( "Semaphore" ) = 32)) (PreH18 : (0 <= val_pre)) (PreH19 : (val_pre <= 65535)) (PreH20 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (SemaphoreCriticalOutside stable current_3 )
|--
  EX (after: CrtosOSWorld)  (current: CrtosOSWorld) ,
  “ ((-5) = (-5)) ” 
  &&  “ (SemaphoreRely stable before current ) ” 
  &&  “ (after = current) ” 
  &&  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (after)))) (return ((-5))) X ) ”
  &&  (SemaphoreCriticalOutside stable after )
) \/
(
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current_3: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval_4 < 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH4 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH5 : (semaphore_layout_32_ok retval )) (PreH6 : (retval_4 = (-1))) (PreH7 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current_3)))) = None)) (PreH8 : (semaphore_layout_32_ok retval )) (PreH9 : (crtos_os_world_wf stable current_3 )) (PreH10 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current_3)))))) = None)) (PreH11 : (retval_3 = handler)) (PreH12 : (semaphore_irq_handler_ok handler )) (PreH13 : (SemaphoreRely stable before current_3 )) (PreH14 : (retval_2 = retval)) (PreH15 : (retval <> 0)) (PreH16 : (retval <> 0)) (PreH17 : (sizeof( "Semaphore" ) = 32)) (PreH18 : (0 <= val_pre)) (PreH19 : (val_pre <= 65535)) (PreH20 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  TT && emp 
|--
  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current_3)))) (return ((-5))) X ) ”
  &&  emp
).

Definition _SemaphoreCreate_return_wit_2_split_goal_1 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current_3: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval_4 < 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH4 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH5 : (semaphore_layout_32_ok retval )) (PreH6 : (retval_4 = (-1))) (PreH7 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current_3)))) = None)) (PreH8 : (semaphore_layout_32_ok retval )) (PreH9 : (crtos_os_world_wf stable current_3 )) (PreH10 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current_3)))))) = None)) (PreH11 : (retval_3 = handler)) (PreH12 : (semaphore_irq_handler_ok handler )) (PreH13 : (SemaphoreRely stable before current_3 )) (PreH14 : (retval_2 = retval)) (PreH15 : (retval <> 0)) (PreH16 : (retval <> 0)) (PreH17 : (sizeof( "Semaphore" ) = 32)) (PreH18 : (0 <= val_pre)) (PreH19 : (val_pre <= 65535)) (PreH20 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current_3)))) (return ((-5))) X )
.

Definition _SemaphoreCreate_return_wit_3 := 
(
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : (sizeof( "Semaphore" ) = 32)) (PreH4 : (0 <= val_pre)) (PreH5 : (val_pre <= 65535)) (PreH6 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (SemaphoreCriticalOutside stable before )
|--
  EX (after: CrtosOSWorld)  (current: CrtosOSWorld) ,
  “ ((-5) = (-5)) ” 
  &&  “ (SemaphoreRely stable before current ) ” 
  &&  “ (after = current) ” 
  &&  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (after)))) (return ((-5))) X ) ”
  &&  (SemaphoreCriticalOutside stable after )
) \/
(
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : (sizeof( "Semaphore" ) = 32)) (PreH4 : (0 <= val_pre)) (PreH5 : (val_pre <= 65535)) (PreH6 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  TT && emp 
|--
  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (return ((-5))) X ) ” 
  &&  “ (SemaphoreRely stable before before ) ”
  &&  emp
).

Definition _SemaphoreCreate_return_wit_3_split_goal_1 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : (sizeof( "Semaphore" ) = 32)) (PreH4 : (0 <= val_pre)) (PreH5 : (val_pre <= 65535)) (PreH6 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (return ((-5))) X )
.

Definition _SemaphoreCreate_return_wit_3_split_goal_2 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (retval = 0)) (PreH3 : (sizeof( "Semaphore" ) = 32)) (PreH4 : (0 <= val_pre)) (PreH5 : (val_pre <= 65535)) (PreH6 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (SemaphoreRely stable before before )
.

Definition _SemaphoreCreate_partial_solve_wit_1_pure := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (PreH1 : (sizeof( "Semaphore" ) = 32)) (PreH2 : (0 <= val_pre)) (PreH3 : (val_pre <= 65535)) (PreH4 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreCriticalOutside stable before )
|--
  “ (sizeof( "Semaphore" ) = 32) ”
.

Definition _SemaphoreCreate_partial_solve_wit_1_aux := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (PreH1 : (sizeof( "Semaphore" ) = 32)) (PreH2 : (0 <= val_pre)) (PreH3 : (val_pre <= 65535)) (PreH4 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (SemaphoreCriticalOutside stable before )
|--
  “ (sizeof( "Semaphore" ) = 32) ” 
  &&  “ (sizeof( "Semaphore" ) = 32) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X ) ”
  &&  (SemaphoreCriticalOutside stable before )
.

Definition _SemaphoreCreate_partial_solve_wit_1 := _SemaphoreCreate_partial_solve_wit_1_pure -> _SemaphoreCreate_partial_solve_wit_1_aux.

Definition _SemaphoreCreate_partial_solve_wit_2_pure := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (retval <> 0)) (PreH3 : (sizeof( "Semaphore" ) = 32)) (PreH4 : (0 <= val_pre)) (PreH5 : (val_pre <= 65535)) (PreH6 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (store_sem_allocated retval )
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreCriticalOutside stable before )
|--
  “ (0 = 0) ” 
  &&  “ (sizeof( "Semaphore" ) = 32) ”
.

Definition _SemaphoreCreate_partial_solve_wit_2_aux := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (retval <> 0)) (PreH3 : (sizeof( "Semaphore" ) = 32)) (PreH4 : (0 <= val_pre)) (PreH5 : (val_pre <= 65535)) (PreH6 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (store_sem_allocated retval )
  **  (SemaphoreCriticalOutside stable before )
|--
  “ (0 = 0) ” 
  &&  “ (sizeof( "Semaphore" ) = 32) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (sizeof( "Semaphore" ) = 32) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X ) ”
  &&  (store_sem_allocated retval )
  **  (SemaphoreCriticalOutside stable before )
.

Definition _SemaphoreCreate_partial_solve_wit_2 := _SemaphoreCreate_partial_solve_wit_2_pure -> _SemaphoreCreate_partial_solve_wit_2_aux.

Definition _SemaphoreCreate_partial_solve_wit_3 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 = retval)) (PreH2 : (retval <> 0)) (PreH3 : (retval <> 0)) (PreH4 : (sizeof( "Semaphore" ) = 32)) (PreH5 : (0 <= val_pre)) (PreH6 : (val_pre <= 65535)) (PreH7 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (store_sem_zeroed_private retval )
  **  (SemaphoreCriticalOutside stable before )
|--
  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (sizeof( "Semaphore" ) = 32) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X ) ”
  &&  (SemaphoreCriticalOutside stable before )
  **  (store_sem_zeroed_private retval )
.

Definition _SemaphoreCreate_partial_solve_wit_4 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (PreH1 : (retval_3 = handler)) (PreH2 : (semaphore_irq_handler_ok handler )) (PreH3 : (SemaphoreRely stable before current )) (PreH4 : (retval_2 = retval)) (PreH5 : (retval <> 0)) (PreH6 : (retval <> 0)) (PreH7 : (sizeof( "Semaphore" ) = 32)) (PreH8 : (0 <= val_pre)) (PreH9 : (val_pre <= 65535)) (PreH10 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  (crtos_semaphore_os_inv stable current )
  **  (store_sem_zeroed_private retval )
|--
  “ (retval_3 = handler) ” 
  &&  “ (semaphore_irq_handler_ok handler ) ” 
  &&  “ (SemaphoreRely stable before current ) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (sizeof( "Semaphore" ) = 32) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X ) ”
  &&  (crtos_semaphore_os_inv stable current )
  **  (store_sem_zeroed_private retval )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
.

Definition _SemaphoreCreate_partial_solve_wit_5_pure := 
(
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (PreH1 : (semaphore_layout_32_ok retval )) (PreH2 : (crtos_os_world_wf stable current )) (PreH3 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH4 : (retval_3 = handler)) (PreH5 : (semaphore_irq_handler_ok handler )) (PreH6 : (SemaphoreRely stable before current )) (PreH7 : (retval_2 = retval)) (PreH8 : (retval <> 0)) (PreH9 : (retval <> 0)) (PreH10 : (sizeof( "Semaphore" ) = 32)) (PreH11 : (0 <= val_pre)) (PreH12 : (val_pre <= 65535)) (PreH13 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_sem_id_node_zeroed retval )
  **  (store_sem_after_id_insert_private retval )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (semaphore_layout_32_ok retval ) ” 
  &&  “ (&((retval)  # "Semaphore" ->ₛ "id") = &((retval)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) = (semaphore_manager_addr ((crtos_semaphore_stable (stable))))) ” 
  &&  “ (SemaphoreStableContext (crtos_semaphore_stable (stable)) ) ” 
  &&  “ (&((retval)  # "Semaphore" ->ₛ "id") <> 0) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ”
) \/
(
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (PreH1 : (0 <= INT_MAX)) (PreH2 : (retval_3 <= INT_MAX)) (PreH3 : (0 >= INT_MIN)) (PreH4 : (retval_3 >= INT_MIN)) (PreH5 : (semaphore_layout_32_ok retval )) (PreH6 : (crtos_os_world_wf stable current )) (PreH7 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH8 : (retval_3 = handler)) (PreH9 : (semaphore_irq_handler_ok handler )) (PreH10 : (SemaphoreRely stable before current )) (PreH11 : (retval_2 = retval)) (PreH12 : (retval <> 0)) (PreH13 : (retval <> 0)) (PreH14 : (sizeof( "Semaphore" ) = 32)) (PreH15 : (0 <= val_pre)) (PreH16 : (val_pre <= 65535)) (PreH17 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_sem_id_node_zeroed retval )
  **  (store_sem_after_id_insert_private retval )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (&((retval)  # "Semaphore" ->ₛ "id") <> 0) ” 
  &&  “ (SemaphoreStableContext (crtos_semaphore_stable (stable)) ) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) = (semaphore_manager_addr ((crtos_semaphore_stable (stable))))) ”
).

Definition _SemaphoreCreate_partial_solve_wit_5_pure_split_goal_1 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (PreH1 : (0 <= INT_MAX)) (PreH2 : (retval_3 <= INT_MAX)) (PreH3 : (0 >= INT_MIN)) (PreH4 : (retval_3 >= INT_MIN)) (PreH5 : (semaphore_layout_32_ok retval )) (PreH6 : (crtos_os_world_wf stable current )) (PreH7 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH8 : (retval_3 = handler)) (PreH9 : (semaphore_irq_handler_ok handler )) (PreH10 : (SemaphoreRely stable before current )) (PreH11 : (retval_2 = retval)) (PreH12 : (retval <> 0)) (PreH13 : (retval <> 0)) (PreH14 : (sizeof( "Semaphore" ) = 32)) (PreH15 : (0 <= val_pre)) (PreH16 : (val_pre <= 65535)) (PreH17 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_sem_id_node_zeroed retval )
  **  (store_sem_after_id_insert_private retval )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (( &( "k_sem_id_manager" ) ) <> 0) ”
.

Definition _SemaphoreCreate_partial_solve_wit_5_pure_split_goal_2 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (PreH1 : (0 <= INT_MAX)) (PreH2 : (retval_3 <= INT_MAX)) (PreH3 : (0 >= INT_MIN)) (PreH4 : (retval_3 >= INT_MIN)) (PreH5 : (semaphore_layout_32_ok retval )) (PreH6 : (crtos_os_world_wf stable current )) (PreH7 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH8 : (retval_3 = handler)) (PreH9 : (semaphore_irq_handler_ok handler )) (PreH10 : (SemaphoreRely stable before current )) (PreH11 : (retval_2 = retval)) (PreH12 : (retval <> 0)) (PreH13 : (retval <> 0)) (PreH14 : (sizeof( "Semaphore" ) = 32)) (PreH15 : (0 <= val_pre)) (PreH16 : (val_pre <= 65535)) (PreH17 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_sem_id_node_zeroed retval )
  **  (store_sem_after_id_insert_private retval )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (&((retval)  # "Semaphore" ->ₛ "id") <> 0) ”
.

Definition _SemaphoreCreate_partial_solve_wit_5_pure_split_goal_3 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (PreH1 : (0 <= INT_MAX)) (PreH2 : (retval_3 <= INT_MAX)) (PreH3 : (0 >= INT_MIN)) (PreH4 : (retval_3 >= INT_MIN)) (PreH5 : (semaphore_layout_32_ok retval )) (PreH6 : (crtos_os_world_wf stable current )) (PreH7 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH8 : (retval_3 = handler)) (PreH9 : (semaphore_irq_handler_ok handler )) (PreH10 : (SemaphoreRely stable before current )) (PreH11 : (retval_2 = retval)) (PreH12 : (retval <> 0)) (PreH13 : (retval <> 0)) (PreH14 : (sizeof( "Semaphore" ) = 32)) (PreH15 : (0 <= val_pre)) (PreH16 : (val_pre <= 65535)) (PreH17 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_sem_id_node_zeroed retval )
  **  (store_sem_after_id_insert_private retval )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (SemaphoreStableContext (crtos_semaphore_stable (stable)) ) ”
.

Definition _SemaphoreCreate_partial_solve_wit_5_pure_split_goal_4 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (PreH1 : (0 <= INT_MAX)) (PreH2 : (retval_3 <= INT_MAX)) (PreH3 : (0 >= INT_MIN)) (PreH4 : (retval_3 >= INT_MIN)) (PreH5 : (semaphore_layout_32_ok retval )) (PreH6 : (crtos_os_world_wf stable current )) (PreH7 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH8 : (retval_3 = handler)) (PreH9 : (semaphore_irq_handler_ok handler )) (PreH10 : (SemaphoreRely stable before current )) (PreH11 : (retval_2 = retval)) (PreH12 : (retval <> 0)) (PreH13 : (retval <> 0)) (PreH14 : (sizeof( "Semaphore" ) = 32)) (PreH15 : (0 <= val_pre)) (PreH16 : (val_pre <= 65535)) (PreH17 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_sem_id_node_zeroed retval )
  **  (store_sem_after_id_insert_private retval )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (( &( "k_sem_id_manager" ) ) = (semaphore_manager_addr ((crtos_semaphore_stable (stable))))) ”
.

Definition _SemaphoreCreate_partial_solve_wit_5_aux := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (PreH1 : (semaphore_layout_32_ok retval )) (PreH2 : (crtos_os_world_wf stable current )) (PreH3 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH4 : (retval_3 = handler)) (PreH5 : (semaphore_irq_handler_ok handler )) (PreH6 : (SemaphoreRely stable before current )) (PreH7 : (retval_2 = retval)) (PreH8 : (retval <> 0)) (PreH9 : (retval <> 0)) (PreH10 : (sizeof( "Semaphore" ) = 32)) (PreH11 : (0 <= val_pre)) (PreH12 : (val_pre <= 65535)) (PreH13 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_sem_id_node_zeroed retval )
  **  (store_sem_after_id_insert_private retval )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
|--
  “ (semaphore_layout_32_ok retval ) ” 
  &&  “ (&((retval)  # "Semaphore" ->ₛ "id") = &((retval)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) = (semaphore_manager_addr ((crtos_semaphore_stable (stable))))) ” 
  &&  “ (SemaphoreStableContext (crtos_semaphore_stable (stable)) ) ” 
  &&  “ (&((retval)  # "Semaphore" ->ₛ "id") <> 0) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (semaphore_layout_32_ok retval ) ” 
  &&  “ (crtos_os_world_wf stable current ) ” 
  &&  “ ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None) ” 
  &&  “ (retval_3 = handler) ” 
  &&  “ (semaphore_irq_handler_ok handler ) ” 
  &&  “ (SemaphoreRely stable before current ) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (sizeof( "Semaphore" ) = 32) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X ) ”
  &&  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_sem_id_node_zeroed retval )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_sem_after_id_insert_private retval )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
.

Definition _SemaphoreCreate_partial_solve_wit_5 := _SemaphoreCreate_partial_solve_wit_5_pure -> _SemaphoreCreate_partial_solve_wit_5_aux.

Definition _SemaphoreCreate_partial_solve_wit_6_pure := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval_4 < 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH4 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH5 : (semaphore_layout_32_ok retval )) (PreH6 : (retval_4 = (-1))) (PreH7 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = None)) (PreH8 : (semaphore_layout_32_ok retval )) (PreH9 : (crtos_os_world_wf stable current )) (PreH10 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH11 : (retval_3 = handler)) (PreH12 : (semaphore_irq_handler_ok handler )) (PreH13 : (SemaphoreRely stable before current )) (PreH14 : (retval_2 = retval)) (PreH15 : (retval <> 0)) (PreH16 : (retval <> 0)) (PreH17 : (sizeof( "Semaphore" ) = 32)) (PreH18 : (0 <= val_pre)) (PreH19 : (val_pre <= 65535)) (PreH20 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_sem_id_node_zeroed retval )
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_sem_after_id_insert_private retval )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (semaphore_layout_32_ok retval ) ”
.

Definition _SemaphoreCreate_partial_solve_wit_6_aux := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval_4 < 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH4 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH5 : (semaphore_layout_32_ok retval )) (PreH6 : (retval_4 = (-1))) (PreH7 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = None)) (PreH8 : (semaphore_layout_32_ok retval )) (PreH9 : (crtos_os_world_wf stable current )) (PreH10 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH11 : (retval_3 = handler)) (PreH12 : (semaphore_irq_handler_ok handler )) (PreH13 : (SemaphoreRely stable before current )) (PreH14 : (retval_2 = retval)) (PreH15 : (retval <> 0)) (PreH16 : (retval <> 0)) (PreH17 : (sizeof( "Semaphore" ) = 32)) (PreH18 : (0 <= val_pre)) (PreH19 : (val_pre <= 65535)) (PreH20 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_sem_id_node_zeroed retval )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_sem_after_id_insert_private retval )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
|--
  “ (semaphore_layout_32_ok retval ) ” 
  &&  “ (retval_4 < 0) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (&((retval)  # "Semaphore" ->ₛ "id") <> 0) ” 
  &&  “ (SemaphoreStableContext (crtos_semaphore_stable (stable)) ) ” 
  &&  “ (semaphore_layout_32_ok retval ) ” 
  &&  “ (retval_4 = (-1)) ” 
  &&  “ ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = None) ” 
  &&  “ (semaphore_layout_32_ok retval ) ” 
  &&  “ (crtos_os_world_wf stable current ) ” 
  &&  “ ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None) ” 
  &&  “ (retval_3 = handler) ” 
  &&  “ (semaphore_irq_handler_ok handler ) ” 
  &&  “ (SemaphoreRely stable before current ) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (sizeof( "Semaphore" ) = 32) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X ) ”
  &&  (store_sem_id_node_zeroed retval )
  **  (store_sem_after_id_insert_private retval )
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
.

Definition _SemaphoreCreate_partial_solve_wit_6 := _SemaphoreCreate_partial_solve_wit_6_pure -> _SemaphoreCreate_partial_solve_wit_6_aux.

Definition _SemaphoreCreate_partial_solve_wit_7 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval_4 < 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH4 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH5 : (semaphore_layout_32_ok retval )) (PreH6 : (retval_4 = (-1))) (PreH7 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = None)) (PreH8 : (semaphore_layout_32_ok retval )) (PreH9 : (crtos_os_world_wf stable current )) (PreH10 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH11 : (retval_3 = handler)) (PreH12 : (semaphore_irq_handler_ok handler )) (PreH13 : (SemaphoreRely stable before current )) (PreH14 : (retval_2 = retval)) (PreH15 : (retval <> 0)) (PreH16 : (retval <> 0)) (PreH17 : (sizeof( "Semaphore" ) = 32)) (PreH18 : (0 <= val_pre)) (PreH19 : (val_pre <= 65535)) (PreH20 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (store_sem_zeroed_private retval )
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
|--
  “ (retval_4 < 0) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (&((retval)  # "Semaphore" ->ₛ "id") <> 0) ” 
  &&  “ (SemaphoreStableContext (crtos_semaphore_stable (stable)) ) ” 
  &&  “ (semaphore_layout_32_ok retval ) ” 
  &&  “ (retval_4 = (-1)) ” 
  &&  “ ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = None) ” 
  &&  “ (semaphore_layout_32_ok retval ) ” 
  &&  “ (crtos_os_world_wf stable current ) ” 
  &&  “ ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None) ” 
  &&  “ (retval_3 = handler) ” 
  &&  “ (semaphore_irq_handler_ok handler ) ” 
  &&  “ (SemaphoreRely stable before current ) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (sizeof( "Semaphore" ) = 32) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X ) ”
  &&  (store_sem_zeroed_private retval )
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
.

Definition _SemaphoreCreate_partial_solve_wit_8 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval_4 < 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH4 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH5 : (semaphore_layout_32_ok retval )) (PreH6 : (retval_4 = (-1))) (PreH7 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = None)) (PreH8 : (semaphore_layout_32_ok retval )) (PreH9 : (crtos_os_world_wf stable current )) (PreH10 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH11 : (retval_3 = handler)) (PreH12 : (semaphore_irq_handler_ok handler )) (PreH13 : (SemaphoreRely stable before current )) (PreH14 : (retval_2 = retval)) (PreH15 : (retval <> 0)) (PreH16 : (retval <> 0)) (PreH17 : (sizeof( "Semaphore" ) = 32)) (PreH18 : (0 <= val_pre)) (PreH19 : (val_pre <= 65535)) (PreH20 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
|--
  “ (retval_4 < 0) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (&((retval)  # "Semaphore" ->ₛ "id") <> 0) ” 
  &&  “ (SemaphoreStableContext (crtos_semaphore_stable (stable)) ) ” 
  &&  “ (semaphore_layout_32_ok retval ) ” 
  &&  “ (retval_4 = (-1)) ” 
  &&  “ ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = None) ” 
  &&  “ (semaphore_layout_32_ok retval ) ” 
  &&  “ (crtos_os_world_wf stable current ) ” 
  &&  “ ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None) ” 
  &&  “ (retval_3 = handler) ” 
  &&  “ (semaphore_irq_handler_ok handler ) ” 
  &&  “ (SemaphoreRely stable before current ) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (sizeof( "Semaphore" ) = 32) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X ) ”
  &&  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
.

Definition _SemaphoreCreate_partial_solve_wit_9_pure := 
(
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval_2: Z) (retval_3: Z) (retval: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval_4 < 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (&((retval_2)  # "Semaphore" ->ₛ "id") <> 0)) (PreH4 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH5 : (semaphore_layout_32_ok retval_2 )) (PreH6 : (retval_4 = (-1))) (PreH7 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = None)) (PreH8 : (semaphore_layout_32_ok retval_2 )) (PreH9 : (crtos_os_world_wf stable current )) (PreH10 : ((semaphore_find_addr (retval_2) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH11 : (retval = handler)) (PreH12 : (semaphore_irq_handler_ok handler )) (PreH13 : (SemaphoreRely stable before current )) (PreH14 : (retval_3 = retval_2)) (PreH15 : (retval_2 <> 0)) (PreH16 : (retval_2 <> 0)) (PreH17 : (sizeof( "Semaphore" ) = 32)) (PreH18 : (0 <= val_pre)) (PreH19 : (val_pre <= 65535)) (PreH20 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (crtos_semaphore_os_inv stable current )
  **  ((( &( "sem" ) )) # Ptr  |-> retval_2)
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (semaphore_irq_handler_ok retval ) ” 
  &&  “ (SemaphoreGuarantee stable current current ) ”
) \/
(
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval_2: Z) (retval_3: Z) (retval: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval_4 <= INT_MAX)) (PreH2 : (retval <= INT_MAX)) (PreH3 : (retval_4 >= INT_MIN)) (PreH4 : (retval >= INT_MIN)) (PreH5 : (retval_4 < 0)) (PreH6 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH7 : (&((retval_2)  # "Semaphore" ->ₛ "id") <> 0)) (PreH8 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH9 : (semaphore_layout_32_ok retval_2 )) (PreH10 : (retval_4 = (-1))) (PreH11 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = None)) (PreH12 : (semaphore_layout_32_ok retval_2 )) (PreH13 : (crtos_os_world_wf stable current )) (PreH14 : ((semaphore_find_addr (retval_2) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH15 : (retval = handler)) (PreH16 : (semaphore_irq_handler_ok handler )) (PreH17 : (SemaphoreRely stable before current )) (PreH18 : (retval_3 = retval_2)) (PreH19 : (retval_2 <> 0)) (PreH20 : (retval_2 <> 0)) (PreH21 : (sizeof( "Semaphore" ) = 32)) (PreH22 : (0 <= val_pre)) (PreH23 : (val_pre <= 65535)) (PreH24 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (crtos_semaphore_os_inv stable current )
  **  ((( &( "sem" ) )) # Ptr  |-> retval_2)
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (SemaphoreGuarantee stable current current ) ”
).

Definition _SemaphoreCreate_partial_solve_wit_9_pure_split_goal_1 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval_2: Z) (retval_3: Z) (retval: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval_4 <= INT_MAX)) (PreH2 : (retval <= INT_MAX)) (PreH3 : (retval_4 >= INT_MIN)) (PreH4 : (retval >= INT_MIN)) (PreH5 : (retval_4 < 0)) (PreH6 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH7 : (&((retval_2)  # "Semaphore" ->ₛ "id") <> 0)) (PreH8 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH9 : (semaphore_layout_32_ok retval_2 )) (PreH10 : (retval_4 = (-1))) (PreH11 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = None)) (PreH12 : (semaphore_layout_32_ok retval_2 )) (PreH13 : (crtos_os_world_wf stable current )) (PreH14 : ((semaphore_find_addr (retval_2) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH15 : (retval = handler)) (PreH16 : (semaphore_irq_handler_ok handler )) (PreH17 : (SemaphoreRely stable before current )) (PreH18 : (retval_3 = retval_2)) (PreH19 : (retval_2 <> 0)) (PreH20 : (retval_2 <> 0)) (PreH21 : (sizeof( "Semaphore" ) = 32)) (PreH22 : (0 <= val_pre)) (PreH23 : (val_pre <= 65535)) (PreH24 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (crtos_semaphore_os_inv stable current )
  **  ((( &( "sem" ) )) # Ptr  |-> retval_2)
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (SemaphoreGuarantee stable current current ) ”
.

Definition _SemaphoreCreate_partial_solve_wit_9_aux := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval_2: Z) (retval_3: Z) (retval: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval_4 < 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (&((retval_2)  # "Semaphore" ->ₛ "id") <> 0)) (PreH4 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH5 : (semaphore_layout_32_ok retval_2 )) (PreH6 : (retval_4 = (-1))) (PreH7 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = None)) (PreH8 : (semaphore_layout_32_ok retval_2 )) (PreH9 : (crtos_os_world_wf stable current )) (PreH10 : ((semaphore_find_addr (retval_2) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH11 : (retval = handler)) (PreH12 : (semaphore_irq_handler_ok handler )) (PreH13 : (SemaphoreRely stable before current )) (PreH14 : (retval_3 = retval_2)) (PreH15 : (retval_2 <> 0)) (PreH16 : (retval_2 <> 0)) (PreH17 : (sizeof( "Semaphore" ) = 32)) (PreH18 : (0 <= val_pre)) (PreH19 : (val_pre <= 65535)) (PreH20 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (crtos_semaphore_os_inv stable current )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
|--
  “ (semaphore_irq_handler_ok retval ) ” 
  &&  “ (SemaphoreGuarantee stable current current ) ” 
  &&  “ (retval_4 < 0) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (&((retval_2)  # "Semaphore" ->ₛ "id") <> 0) ” 
  &&  “ (SemaphoreStableContext (crtos_semaphore_stable (stable)) ) ” 
  &&  “ (semaphore_layout_32_ok retval_2 ) ” 
  &&  “ (retval_4 = (-1)) ” 
  &&  “ ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = None) ” 
  &&  “ (semaphore_layout_32_ok retval_2 ) ” 
  &&  “ (crtos_os_world_wf stable current ) ” 
  &&  “ ((semaphore_find_addr (retval_2) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None) ” 
  &&  “ (retval = handler) ” 
  &&  “ (semaphore_irq_handler_ok handler ) ” 
  &&  “ (SemaphoreRely stable before current ) ” 
  &&  “ (retval_3 = retval_2) ” 
  &&  “ (retval_2 <> 0) ” 
  &&  “ (retval_2 <> 0) ” 
  &&  “ (sizeof( "Semaphore" ) = 32) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X ) ”
  &&  (SemaphoreCriticalHeld retval (@nil Z) stable current )
  **  (crtos_semaphore_os_inv stable current )
.

Definition _SemaphoreCreate_partial_solve_wit_9 := _SemaphoreCreate_partial_solve_wit_9_pure -> _SemaphoreCreate_partial_solve_wit_9_aux.

Definition _SemaphoreCreate_partial_solve_wit_10 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval_4 >= 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH4 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH5 : (semaphore_layout_32_ok retval )) (PreH6 : (0 <= retval_4)) (PreH7 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_4)))) (PreH8 : (semaphore_layout_32_ok retval )) (PreH9 : (crtos_os_world_wf stable current )) (PreH10 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH11 : (retval_3 = handler)) (PreH12 : (semaphore_irq_handler_ok handler )) (PreH13 : (SemaphoreRely stable before current )) (PreH14 : (retval_2 = retval)) (PreH15 : (retval <> 0)) (PreH16 : (retval <> 0)) (PreH17 : (sizeof( "Semaphore" ) = 32)) (PreH18 : (0 <= val_pre)) (PreH19 : (val_pre <= 65535)) (PreH20 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (retval) (retval_4)) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_sem_after_id_insert_private retval )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
|--
  “ (retval_4 >= 0) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (&((retval)  # "Semaphore" ->ₛ "id") <> 0) ” 
  &&  “ (SemaphoreStableContext (crtos_semaphore_stable (stable)) ) ” 
  &&  “ (semaphore_layout_32_ok retval ) ” 
  &&  “ (0 <= retval_4) ” 
  &&  “ ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_4))) ” 
  &&  “ (semaphore_layout_32_ok retval ) ” 
  &&  “ (crtos_os_world_wf stable current ) ” 
  &&  “ ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None) ” 
  &&  “ (retval_3 = handler) ” 
  &&  “ (semaphore_irq_handler_ok handler ) ” 
  &&  “ (SemaphoreRely stable before current ) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (sizeof( "Semaphore" ) = 32) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X ) ”
  &&  (store_sem_after_id_insert_private retval )
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (retval) (retval_4)) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
.

Definition _SemaphoreCreate_partial_solve_wit_11_pure := 
(
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval <> 0)) (PreH2 : (retval_4 >= 0)) (PreH3 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH4 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH5 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH6 : (semaphore_layout_32_ok retval )) (PreH7 : (0 <= retval_4)) (PreH8 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_4)))) (PreH9 : (semaphore_layout_32_ok retval )) (PreH10 : (crtos_os_world_wf stable current )) (PreH11 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH12 : (retval_3 = handler)) (PreH13 : (semaphore_irq_handler_ok handler )) (PreH14 : (SemaphoreRely stable before current )) (PreH15 : (retval_2 = retval)) (PreH16 : (retval <> 0)) (PreH17 : (retval <> 0)) (PreH18 : (sizeof( "Semaphore" ) = 32)) (PreH19 : (0 <= val_pre)) (PreH20 : (val_pre <= 65535)) (PreH21 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((&((retval)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (store_sem_body_padding_zero retval )
  **  ((&((retval)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((retval)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |-> 0)
  **  ((&((retval)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((retval)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> 0)
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (retval) (retval_4)) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (&((retval)  # "Semaphore" ->ₛ "pend_list") <> 0) ”
) \/
(
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval_4 <= INT_MAX)) (PreH2 : (retval_3 <= INT_MAX)) (PreH3 : (retval_4 >= INT_MIN)) (PreH4 : (retval_3 >= INT_MIN)) (PreH5 : (retval <> 0)) (PreH6 : (retval_4 >= 0)) (PreH7 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH8 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH9 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH10 : (semaphore_layout_32_ok retval )) (PreH11 : (0 <= retval_4)) (PreH12 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_4)))) (PreH13 : (semaphore_layout_32_ok retval )) (PreH14 : (crtos_os_world_wf stable current )) (PreH15 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH16 : (retval_3 = handler)) (PreH17 : (semaphore_irq_handler_ok handler )) (PreH18 : (SemaphoreRely stable before current )) (PreH19 : (retval_2 = retval)) (PreH20 : (retval <> 0)) (PreH21 : (retval <> 0)) (PreH22 : (sizeof( "Semaphore" ) = 32)) (PreH23 : (0 <= val_pre)) (PreH24 : (val_pre <= 65535)) (PreH25 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((&((retval)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (store_sem_body_padding_zero retval )
  **  ((&((retval)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((retval)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |-> 0)
  **  ((&((retval)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((retval)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> 0)
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (retval) (retval_4)) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (&((retval)  # "Semaphore" ->ₛ "pend_list") <> 0) ”
).

Definition _SemaphoreCreate_partial_solve_wit_11_pure_split_goal_1 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval_4 <= INT_MAX)) (PreH2 : (retval_3 <= INT_MAX)) (PreH3 : (retval_4 >= INT_MIN)) (PreH4 : (retval_3 >= INT_MIN)) (PreH5 : (retval <> 0)) (PreH6 : (retval_4 >= 0)) (PreH7 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH8 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH9 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH10 : (semaphore_layout_32_ok retval )) (PreH11 : (0 <= retval_4)) (PreH12 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_4)))) (PreH13 : (semaphore_layout_32_ok retval )) (PreH14 : (crtos_os_world_wf stable current )) (PreH15 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH16 : (retval_3 = handler)) (PreH17 : (semaphore_irq_handler_ok handler )) (PreH18 : (SemaphoreRely stable before current )) (PreH19 : (retval_2 = retval)) (PreH20 : (retval <> 0)) (PreH21 : (retval <> 0)) (PreH22 : (sizeof( "Semaphore" ) = 32)) (PreH23 : (0 <= val_pre)) (PreH24 : (val_pre <= 65535)) (PreH25 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((&((retval)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (store_sem_body_padding_zero retval )
  **  ((&((retval)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((retval)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |-> 0)
  **  ((&((retval)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((retval)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> 0)
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (retval) (retval_4)) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (&((retval)  # "Semaphore" ->ₛ "pend_list") <> 0) ”
.

Definition _SemaphoreCreate_partial_solve_wit_11_aux := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval <> 0)) (PreH2 : (retval_4 >= 0)) (PreH3 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH4 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH5 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH6 : (semaphore_layout_32_ok retval )) (PreH7 : (0 <= retval_4)) (PreH8 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_4)))) (PreH9 : (semaphore_layout_32_ok retval )) (PreH10 : (crtos_os_world_wf stable current )) (PreH11 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH12 : (retval_3 = handler)) (PreH13 : (semaphore_irq_handler_ok handler )) (PreH14 : (SemaphoreRely stable before current )) (PreH15 : (retval_2 = retval)) (PreH16 : (retval <> 0)) (PreH17 : (retval <> 0)) (PreH18 : (sizeof( "Semaphore" ) = 32)) (PreH19 : (0 <= val_pre)) (PreH20 : (val_pre <= 65535)) (PreH21 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  ((&((retval)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (store_sem_body_padding_zero retval )
  **  ((&((retval)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((retval)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |-> 0)
  **  ((&((retval)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((retval)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> 0)
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (retval) (retval_4)) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
|--
  “ (&((retval)  # "Semaphore" ->ₛ "pend_list") <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (retval_4 >= 0) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (&((retval)  # "Semaphore" ->ₛ "id") <> 0) ” 
  &&  “ (SemaphoreStableContext (crtos_semaphore_stable (stable)) ) ” 
  &&  “ (semaphore_layout_32_ok retval ) ” 
  &&  “ (0 <= retval_4) ” 
  &&  “ ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_4))) ” 
  &&  “ (semaphore_layout_32_ok retval ) ” 
  &&  “ (crtos_os_world_wf stable current ) ” 
  &&  “ ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None) ” 
  &&  “ (retval_3 = handler) ” 
  &&  “ (semaphore_irq_handler_ok handler ) ” 
  &&  “ (SemaphoreRely stable before current ) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (sizeof( "Semaphore" ) = 32) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X ) ”
  &&  ((&((retval)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((retval)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |-> 0)
  **  ((&((retval)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (store_sem_body_padding_zero retval )
  **  ((&((retval)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((retval)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> 0)
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (retval) (retval_4)) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
.

Definition _SemaphoreCreate_partial_solve_wit_11 := _SemaphoreCreate_partial_solve_wit_11_pure -> _SemaphoreCreate_partial_solve_wit_11_aux.

Definition _SemaphoreCreate_partial_solve_wit_12_pure := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval <> 0)) (PreH2 : (retval_4 >= 0)) (PreH3 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH4 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH5 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH6 : (semaphore_layout_32_ok retval )) (PreH7 : (0 <= retval_4)) (PreH8 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_4)))) (PreH9 : (semaphore_layout_32_ok retval )) (PreH10 : (crtos_os_world_wf stable current )) (PreH11 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH12 : (retval_3 = handler)) (PreH13 : (semaphore_irq_handler_ok handler )) (PreH14 : (SemaphoreRely stable before current )) (PreH15 : (retval_2 = retval)) (PreH16 : (retval <> 0)) (PreH17 : (retval <> 0)) (PreH18 : (sizeof( "Semaphore" ) = 32)) (PreH19 : (0 <= val_pre)) (PreH20 : (val_pre <= 65535)) (PreH21 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (store_sem_dll semaphore_unit_empty &((retval)  # "Semaphore" ->ₛ "pend_list") (@nil (@SemDLNode unit)) )
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((&((retval)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (store_sem_body_padding_zero retval )
  **  ((&((retval)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((retval)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> 0)
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (retval) (retval_4)) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (SemaphoreStableContext (crtos_semaphore_stable (stable)) ) ”
.

Definition _SemaphoreCreate_partial_solve_wit_12_aux := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval <> 0)) (PreH2 : (retval_4 >= 0)) (PreH3 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH4 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH5 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH6 : (semaphore_layout_32_ok retval )) (PreH7 : (0 <= retval_4)) (PreH8 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_4)))) (PreH9 : (semaphore_layout_32_ok retval )) (PreH10 : (crtos_os_world_wf stable current )) (PreH11 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH12 : (retval_3 = handler)) (PreH13 : (semaphore_irq_handler_ok handler )) (PreH14 : (SemaphoreRely stable before current )) (PreH15 : (retval_2 = retval)) (PreH16 : (retval <> 0)) (PreH17 : (retval <> 0)) (PreH18 : (sizeof( "Semaphore" ) = 32)) (PreH19 : (0 <= val_pre)) (PreH20 : (val_pre <= 65535)) (PreH21 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (store_sem_dll semaphore_unit_empty &((retval)  # "Semaphore" ->ₛ "pend_list") (@nil (@SemDLNode unit)) )
  **  ((&((retval)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (store_sem_body_padding_zero retval )
  **  ((&((retval)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((retval)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> 0)
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (retval) (retval_4)) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
|--
  “ (SemaphoreStableContext (crtos_semaphore_stable (stable)) ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (retval_4 >= 0) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (&((retval)  # "Semaphore" ->ₛ "id") <> 0) ” 
  &&  “ (SemaphoreStableContext (crtos_semaphore_stable (stable)) ) ” 
  &&  “ (semaphore_layout_32_ok retval ) ” 
  &&  “ (0 <= retval_4) ” 
  &&  “ ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_4))) ” 
  &&  “ (semaphore_layout_32_ok retval ) ” 
  &&  “ (crtos_os_world_wf stable current ) ” 
  &&  “ ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None) ” 
  &&  “ (retval_3 = handler) ” 
  &&  “ (semaphore_irq_handler_ok handler ) ” 
  &&  “ (SemaphoreRely stable before current ) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (sizeof( "Semaphore" ) = 32) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X ) ”
  &&  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_sem_dll semaphore_unit_empty &((retval)  # "Semaphore" ->ₛ "pend_list") (@nil (@SemDLNode unit)) )
  **  ((&((retval)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (store_sem_body_padding_zero retval )
  **  ((&((retval)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((retval)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> 0)
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (retval) (retval_4)) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
.

Definition _SemaphoreCreate_partial_solve_wit_12 := _SemaphoreCreate_partial_solve_wit_12_pure -> _SemaphoreCreate_partial_solve_wit_12_aux.

Definition _SemaphoreCreate_partial_solve_wit_13_pure := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval <> 0)) (PreH2 : (retval_4 >= 0)) (PreH3 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH4 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH5 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH6 : (semaphore_layout_32_ok retval )) (PreH7 : (0 <= retval_4)) (PreH8 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_4)))) (PreH9 : (semaphore_layout_32_ok retval )) (PreH10 : (crtos_os_world_wf stable current )) (PreH11 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH12 : (retval_3 = handler)) (PreH13 : (semaphore_irq_handler_ok handler )) (PreH14 : (SemaphoreRely stable before current )) (PreH15 : (retval_2 = retval)) (PreH16 : (retval <> 0)) (PreH17 : (retval <> 0)) (PreH18 : (sizeof( "Semaphore" ) = 32)) (PreH19 : (0 <= val_pre)) (PreH20 : (val_pre <= 65535)) (PreH21 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (store_sem_dll store_semaphore_body ( &( "k_sem_list" ) ) (map (semaphore_registry_node) ((semaphore_objects ((crtos_semaphore_state (current)))))) )
  **  (store_sem_dll semaphore_unit_empty &((retval)  # "Semaphore" ->ₛ "pend_list") (@nil (@SemDLNode unit)) )
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((&((retval)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (store_sem_body_padding_zero retval )
  **  ((&((retval)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((retval)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> 0)
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (retval) (retval_4)) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
  **  ((( &( "id" ) )) # Int  |-> retval_4)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (retval <> 0) ” 
  &&  “ (semaphore_layout_32_ok retval ) ”
.

Definition _SemaphoreCreate_partial_solve_wit_13_aux := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval <> 0)) (PreH2 : (retval_4 >= 0)) (PreH3 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH4 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH5 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH6 : (semaphore_layout_32_ok retval )) (PreH7 : (0 <= retval_4)) (PreH8 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_4)))) (PreH9 : (semaphore_layout_32_ok retval )) (PreH10 : (crtos_os_world_wf stable current )) (PreH11 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH12 : (retval_3 = handler)) (PreH13 : (semaphore_irq_handler_ok handler )) (PreH14 : (SemaphoreRely stable before current )) (PreH15 : (retval_2 = retval)) (PreH16 : (retval <> 0)) (PreH17 : (retval <> 0)) (PreH18 : (sizeof( "Semaphore" ) = 32)) (PreH19 : (0 <= val_pre)) (PreH20 : (val_pre <= 65535)) (PreH21 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (store_sem_dll store_semaphore_body ( &( "k_sem_list" ) ) (map (semaphore_registry_node) ((semaphore_objects ((crtos_semaphore_state (current)))))) )
  **  (store_sem_dll semaphore_unit_empty &((retval)  # "Semaphore" ->ₛ "pend_list") (@nil (@SemDLNode unit)) )
  **  ((&((retval)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (store_sem_body_padding_zero retval )
  **  ((&((retval)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((retval)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> 0)
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (retval) (retval_4)) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
|--
  “ (retval <> 0) ” 
  &&  “ (semaphore_layout_32_ok retval ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (retval_4 >= 0) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (&((retval)  # "Semaphore" ->ₛ "id") <> 0) ” 
  &&  “ (SemaphoreStableContext (crtos_semaphore_stable (stable)) ) ” 
  &&  “ (semaphore_layout_32_ok retval ) ” 
  &&  “ (0 <= retval_4) ” 
  &&  “ ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_4))) ” 
  &&  “ (semaphore_layout_32_ok retval ) ” 
  &&  “ (crtos_os_world_wf stable current ) ” 
  &&  “ ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None) ” 
  &&  “ (retval_3 = handler) ” 
  &&  “ (semaphore_irq_handler_ok handler ) ” 
  &&  “ (SemaphoreRely stable before current ) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (sizeof( "Semaphore" ) = 32) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X ) ”
  &&  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (retval) (retval_4)) )
  **  ((&((retval)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (store_sem_body_padding_zero retval )
  **  (store_sem_dll semaphore_unit_empty &((retval)  # "Semaphore" ->ₛ "pend_list") (@nil (@SemDLNode unit)) )
  **  ((&((retval)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((retval)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> 0)
  **  (store_sem_dll store_semaphore_body ( &( "k_sem_list" ) ) (map (semaphore_registry_node) ((semaphore_objects ((crtos_semaphore_state (current)))))) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
.

Definition _SemaphoreCreate_partial_solve_wit_13 := _SemaphoreCreate_partial_solve_wit_13_pure -> _SemaphoreCreate_partial_solve_wit_13_aux.

Definition _SemaphoreCreate_partial_solve_wit_14_pure := 
(
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval <> 0)) (PreH2 : (retval_4 >= 0)) (PreH3 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH4 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH5 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH6 : (semaphore_layout_32_ok retval )) (PreH7 : (0 <= retval_4)) (PreH8 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_4)))) (PreH9 : (semaphore_layout_32_ok retval )) (PreH10 : (crtos_os_world_wf stable current )) (PreH11 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH12 : (retval_3 = handler)) (PreH13 : (semaphore_irq_handler_ok handler )) (PreH14 : (SemaphoreRely stable before current )) (PreH15 : (retval_2 = retval)) (PreH16 : (retval <> 0)) (PreH17 : (retval <> 0)) (PreH18 : (sizeof( "Semaphore" ) = 32)) (PreH19 : (0 <= val_pre)) (PreH20 : (val_pre <= 65535)) (PreH21 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  ((( &( "id" ) )) # Int  |-> retval_4)
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (retval) (retval_4)) )
  **  (store_sem_standalone_node store_semaphore_body &((retval)  # "Semaphore" ->ₛ "link") (Build_SemaphoreObject (retval) (retval_4) (val_pre) ((@nil Z))) )
  **  (store_sem_dll store_semaphore_body ( &( "k_sem_list" ) ) (map (semaphore_registry_node) ((semaphore_objects ((crtos_semaphore_state (current)))))) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (&((retval)  # "Semaphore" ->ₛ "link") <> 0) ”
) \/
(
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval_3 <= INT_MAX)) (PreH2 : (retval_4 <= INT_MAX)) (PreH3 : (retval_3 >= INT_MIN)) (PreH4 : (retval_4 >= INT_MIN)) (PreH5 : (retval <> 0)) (PreH6 : (retval_4 >= 0)) (PreH7 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH8 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH9 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH10 : (semaphore_layout_32_ok retval )) (PreH11 : (0 <= retval_4)) (PreH12 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_4)))) (PreH13 : (semaphore_layout_32_ok retval )) (PreH14 : (crtos_os_world_wf stable current )) (PreH15 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH16 : (retval_3 = handler)) (PreH17 : (semaphore_irq_handler_ok handler )) (PreH18 : (SemaphoreRely stable before current )) (PreH19 : (retval_2 = retval)) (PreH20 : (retval <> 0)) (PreH21 : (retval <> 0)) (PreH22 : (sizeof( "Semaphore" ) = 32)) (PreH23 : (0 <= val_pre)) (PreH24 : (val_pre <= 65535)) (PreH25 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  ((( &( "id" ) )) # Int  |-> retval_4)
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (retval) (retval_4)) )
  **  (store_sem_standalone_node store_semaphore_body &((retval)  # "Semaphore" ->ₛ "link") (Build_SemaphoreObject (retval) (retval_4) (val_pre) ((@nil Z))) )
  **  (store_sem_dll store_semaphore_body ( &( "k_sem_list" ) ) (map (semaphore_registry_node) ((semaphore_objects ((crtos_semaphore_state (current)))))) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (&((retval)  # "Semaphore" ->ₛ "link") <> 0) ”
).

Definition _SemaphoreCreate_partial_solve_wit_14_pure_split_goal_1 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval_3 <= INT_MAX)) (PreH2 : (retval_4 <= INT_MAX)) (PreH3 : (retval_3 >= INT_MIN)) (PreH4 : (retval_4 >= INT_MIN)) (PreH5 : (retval <> 0)) (PreH6 : (retval_4 >= 0)) (PreH7 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH8 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH9 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH10 : (semaphore_layout_32_ok retval )) (PreH11 : (0 <= retval_4)) (PreH12 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_4)))) (PreH13 : (semaphore_layout_32_ok retval )) (PreH14 : (crtos_os_world_wf stable current )) (PreH15 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH16 : (retval_3 = handler)) (PreH17 : (semaphore_irq_handler_ok handler )) (PreH18 : (SemaphoreRely stable before current )) (PreH19 : (retval_2 = retval)) (PreH20 : (retval <> 0)) (PreH21 : (retval <> 0)) (PreH22 : (sizeof( "Semaphore" ) = 32)) (PreH23 : (0 <= val_pre)) (PreH24 : (val_pre <= 65535)) (PreH25 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  ((( &( "id" ) )) # Int  |-> retval_4)
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (retval) (retval_4)) )
  **  (store_sem_standalone_node store_semaphore_body &((retval)  # "Semaphore" ->ₛ "link") (Build_SemaphoreObject (retval) (retval_4) (val_pre) ((@nil Z))) )
  **  (store_sem_dll store_semaphore_body ( &( "k_sem_list" ) ) (map (semaphore_registry_node) ((semaphore_objects ((crtos_semaphore_state (current)))))) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval_3)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (&((retval)  # "Semaphore" ->ₛ "link") <> 0) ”
.

Definition _SemaphoreCreate_partial_solve_wit_14_aux := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_2: Z) (retval_3: Z) (handler: Z) (current: CrtosOSWorld) (retval_4: Z) (PreH1 : (retval <> 0)) (PreH2 : (retval_4 >= 0)) (PreH3 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH4 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH5 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH6 : (semaphore_layout_32_ok retval )) (PreH7 : (0 <= retval_4)) (PreH8 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_4)))) (PreH9 : (semaphore_layout_32_ok retval )) (PreH10 : (crtos_os_world_wf stable current )) (PreH11 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH12 : (retval_3 = handler)) (PreH13 : (semaphore_irq_handler_ok handler )) (PreH14 : (SemaphoreRely stable before current )) (PreH15 : (retval_2 = retval)) (PreH16 : (retval <> 0)) (PreH17 : (retval <> 0)) (PreH18 : (sizeof( "Semaphore" ) = 32)) (PreH19 : (0 <= val_pre)) (PreH20 : (val_pre <= 65535)) (PreH21 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (retval) (retval_4)) )
  **  (store_sem_standalone_node store_semaphore_body &((retval)  # "Semaphore" ->ₛ "link") (Build_SemaphoreObject (retval) (retval_4) (val_pre) ((@nil Z))) )
  **  (store_sem_dll store_semaphore_body ( &( "k_sem_list" ) ) (map (semaphore_registry_node) ((semaphore_objects ((crtos_semaphore_state (current)))))) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
|--
  “ (&((retval)  # "Semaphore" ->ₛ "link") <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (retval_4 >= 0) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (&((retval)  # "Semaphore" ->ₛ "id") <> 0) ” 
  &&  “ (SemaphoreStableContext (crtos_semaphore_stable (stable)) ) ” 
  &&  “ (semaphore_layout_32_ok retval ) ” 
  &&  “ (0 <= retval_4) ” 
  &&  “ ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_4))) ” 
  &&  “ (semaphore_layout_32_ok retval ) ” 
  &&  “ (crtos_os_world_wf stable current ) ” 
  &&  “ ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None) ” 
  &&  “ (retval_3 = handler) ” 
  &&  “ (semaphore_irq_handler_ok handler ) ” 
  &&  “ (SemaphoreRely stable before current ) ” 
  &&  “ (retval_2 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (sizeof( "Semaphore" ) = 32) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X ) ”
  &&  (store_sem_dll store_semaphore_body ( &( "k_sem_list" ) ) (map (semaphore_registry_node) ((semaphore_objects ((crtos_semaphore_state (current)))))) )
  **  (store_sem_standalone_node store_semaphore_body &((retval)  # "Semaphore" ->ₛ "link") (Build_SemaphoreObject (retval) (retval_4) (val_pre) ((@nil Z))) )
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (retval) (retval_4)) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
.

Definition _SemaphoreCreate_partial_solve_wit_14 := _SemaphoreCreate_partial_solve_wit_14_pure -> _SemaphoreCreate_partial_solve_wit_14_aux.

Definition _SemaphoreCreate_partial_solve_wit_15_pure := 
(
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_3: Z) (retval_4: Z) (handler: Z) (current: CrtosOSWorld) (retval_2: Z) (PreH1 : (retval <> 0)) (PreH2 : (retval_2 >= 0)) (PreH3 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH4 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH5 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH6 : (semaphore_layout_32_ok retval )) (PreH7 : (0 <= retval_2)) (PreH8 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_2)))) (PreH9 : (semaphore_layout_32_ok retval )) (PreH10 : (crtos_os_world_wf stable current )) (PreH11 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH12 : (retval_4 = handler)) (PreH13 : (semaphore_irq_handler_ok handler )) (PreH14 : (SemaphoreRely stable before current )) (PreH15 : (retval_3 = retval)) (PreH16 : (retval <> 0)) (PreH17 : (retval <> 0)) (PreH18 : (sizeof( "Semaphore" ) = 32)) (PreH19 : (0 <= val_pre)) (PreH20 : (val_pre <= 65535)) (PreH21 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (store_sem_dll store_semaphore_body ( &( "k_sem_list" ) ) (cons ((Build_SemDLNode ((Build_SemaphoreObject (retval) (retval_2) (val_pre) ((@nil Z)))) (&((retval)  # "Semaphore" ->ₛ "link")))) ((map (semaphore_registry_node) ((semaphore_objects ((crtos_semaphore_state (current)))))))) )
  **  ((( &( "id" ) )) # Int  |-> retval_2)
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (retval) (retval_2)) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval_4)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (retval <> 0) ” 
  &&  “ (0 <= retval_2) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (crtos_os_world_wf stable current ) ” 
  &&  “ ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None) ” 
  &&  “ ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_2))) ” 
  &&  “ (retval_2 < 128) ”
) \/
(
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_3: Z) (retval_4: Z) (handler: Z) (current: CrtosOSWorld) (retval_2: Z) (PreH1 : (retval_4 <= INT_MAX)) (PreH2 : (retval_2 <= INT_MAX)) (PreH3 : (retval_4 >= INT_MIN)) (PreH4 : (retval_2 >= INT_MIN)) (PreH5 : (retval <> 0)) (PreH6 : (retval_2 >= 0)) (PreH7 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH8 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH9 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH10 : (semaphore_layout_32_ok retval )) (PreH11 : (0 <= retval_2)) (PreH12 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_2)))) (PreH13 : (semaphore_layout_32_ok retval )) (PreH14 : (crtos_os_world_wf stable current )) (PreH15 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH16 : (retval_4 = handler)) (PreH17 : (semaphore_irq_handler_ok handler )) (PreH18 : (SemaphoreRely stable before current )) (PreH19 : (retval_3 = retval)) (PreH20 : (retval <> 0)) (PreH21 : (retval <> 0)) (PreH22 : (sizeof( "Semaphore" ) = 32)) (PreH23 : (0 <= val_pre)) (PreH24 : (val_pre <= 65535)) (PreH25 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (store_sem_dll store_semaphore_body ( &( "k_sem_list" ) ) (cons ((Build_SemDLNode ((Build_SemaphoreObject (retval) (retval_2) (val_pre) ((@nil Z)))) (&((retval)  # "Semaphore" ->ₛ "link")))) ((map (semaphore_registry_node) ((semaphore_objects ((crtos_semaphore_state (current)))))))) )
  **  ((( &( "id" ) )) # Int  |-> retval_2)
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (retval) (retval_2)) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval_4)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (retval_2 < 128) ”
).

Definition _SemaphoreCreate_partial_solve_wit_15_pure_split_goal_1 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_3: Z) (retval_4: Z) (handler: Z) (current: CrtosOSWorld) (retval_2: Z) (PreH1 : (retval_4 <= INT_MAX)) (PreH2 : (retval_2 <= INT_MAX)) (PreH3 : (retval_4 >= INT_MIN)) (PreH4 : (retval_2 >= INT_MIN)) (PreH5 : (retval <> 0)) (PreH6 : (retval_2 >= 0)) (PreH7 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH8 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH9 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH10 : (semaphore_layout_32_ok retval )) (PreH11 : (0 <= retval_2)) (PreH12 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_2)))) (PreH13 : (semaphore_layout_32_ok retval )) (PreH14 : (crtos_os_world_wf stable current )) (PreH15 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH16 : (retval_4 = handler)) (PreH17 : (semaphore_irq_handler_ok handler )) (PreH18 : (SemaphoreRely stable before current )) (PreH19 : (retval_3 = retval)) (PreH20 : (retval <> 0)) (PreH21 : (retval <> 0)) (PreH22 : (sizeof( "Semaphore" ) = 32)) (PreH23 : (0 <= val_pre)) (PreH24 : (val_pre <= 65535)) (PreH25 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (store_sem_dll store_semaphore_body ( &( "k_sem_list" ) ) (cons ((Build_SemDLNode ((Build_SemaphoreObject (retval) (retval_2) (val_pre) ((@nil Z)))) (&((retval)  # "Semaphore" ->ₛ "link")))) ((map (semaphore_registry_node) ((semaphore_objects ((crtos_semaphore_state (current)))))))) )
  **  ((( &( "id" ) )) # Int  |-> retval_2)
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (retval) (retval_2)) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval_4)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (retval_2 < 128) ”
.

Definition _SemaphoreCreate_partial_solve_wit_15_aux := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_3: Z) (retval_4: Z) (handler: Z) (current: CrtosOSWorld) (retval_2: Z) (PreH1 : (retval <> 0)) (PreH2 : (retval_2 >= 0)) (PreH3 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH4 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH5 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH6 : (semaphore_layout_32_ok retval )) (PreH7 : (0 <= retval_2)) (PreH8 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_2)))) (PreH9 : (semaphore_layout_32_ok retval )) (PreH10 : (crtos_os_world_wf stable current )) (PreH11 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH12 : (retval_4 = handler)) (PreH13 : (semaphore_irq_handler_ok handler )) (PreH14 : (SemaphoreRely stable before current )) (PreH15 : (retval_3 = retval)) (PreH16 : (retval <> 0)) (PreH17 : (retval <> 0)) (PreH18 : (sizeof( "Semaphore" ) = 32)) (PreH19 : (0 <= val_pre)) (PreH20 : (val_pre <= 65535)) (PreH21 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (store_sem_dll store_semaphore_body ( &( "k_sem_list" ) ) (cons ((Build_SemDLNode ((Build_SemaphoreObject (retval) (retval_2) (val_pre) ((@nil Z)))) (&((retval)  # "Semaphore" ->ₛ "link")))) ((map (semaphore_registry_node) ((semaphore_objects ((crtos_semaphore_state (current)))))))) )
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (retval) (retval_2)) )
  **  (crtos_semaphore_nonsem_frame stable current )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
|--
  “ (retval <> 0) ” 
  &&  “ (0 <= retval_2) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (crtos_os_world_wf stable current ) ” 
  &&  “ ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None) ” 
  &&  “ ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_2))) ” 
  &&  “ (retval_2 < 128) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (retval_2 >= 0) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (&((retval)  # "Semaphore" ->ₛ "id") <> 0) ” 
  &&  “ (SemaphoreStableContext (crtos_semaphore_stable (stable)) ) ” 
  &&  “ (semaphore_layout_32_ok retval ) ” 
  &&  “ (0 <= retval_2) ” 
  &&  “ ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_2))) ” 
  &&  “ (semaphore_layout_32_ok retval ) ” 
  &&  “ (crtos_os_world_wf stable current ) ” 
  &&  “ ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None) ” 
  &&  “ (retval_4 = handler) ” 
  &&  “ (semaphore_irq_handler_ok handler ) ” 
  &&  “ (SemaphoreRely stable before current ) ” 
  &&  “ (retval_3 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (sizeof( "Semaphore" ) = 32) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X ) ”
  &&  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (retval) (retval_2)) )
  **  (store_sem_dll store_semaphore_body ( &( "k_sem_list" ) ) (cons ((Build_SemDLNode ((Build_SemaphoreObject (retval) (retval_2) (val_pre) ((@nil Z)))) (&((retval)  # "Semaphore" ->ₛ "link")))) ((map (semaphore_registry_node) ((semaphore_objects ((crtos_semaphore_state (current)))))))) )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
.

Definition _SemaphoreCreate_partial_solve_wit_15 := _SemaphoreCreate_partial_solve_wit_15_pure -> _SemaphoreCreate_partial_solve_wit_15_aux.

Definition _SemaphoreCreate_partial_solve_wit_16_pure := 
(
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_4: Z) (retval_2: Z) (handler: Z) (current: CrtosOSWorld) (retval_3: Z) (PreH1 : (crtos_os_world_wf stable (Build_CrtosOSWorld ((crtos_task_state (current))) ((crtos_scheduler_state (current))) ((semaphore_create_state ((crtos_semaphore_state (current))) (retval) (retval_3) (val_pre)))) )) (PreH2 : (retval <> 0)) (PreH3 : (retval_3 >= 0)) (PreH4 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH5 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH6 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH7 : (semaphore_layout_32_ok retval )) (PreH8 : (0 <= retval_3)) (PreH9 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_3)))) (PreH10 : (semaphore_layout_32_ok retval )) (PreH11 : (crtos_os_world_wf stable current )) (PreH12 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH13 : (retval_2 = handler)) (PreH14 : (semaphore_irq_handler_ok handler )) (PreH15 : (SemaphoreRely stable before current )) (PreH16 : (retval_4 = retval)) (PreH17 : (retval <> 0)) (PreH18 : (retval <> 0)) (PreH19 : (sizeof( "Semaphore" ) = 32)) (PreH20 : (0 <= val_pre)) (PreH21 : (val_pre <= 65535)) (PreH22 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  ((( &( "id" ) )) # Int  |-> retval_3)
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  (crtos_semaphore_os_inv stable (Build_CrtosOSWorld ((crtos_task_state (current))) ((crtos_scheduler_state (current))) ((semaphore_create_state ((crtos_semaphore_state (current))) (retval) (retval_3) (val_pre)))) )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval_2)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (semaphore_irq_handler_ok retval_2 ) ” 
  &&  “ (SemaphoreGuarantee stable current (Build_CrtosOSWorld ((crtos_task_state (current))) ((crtos_scheduler_state (current))) ((semaphore_create_state ((crtos_semaphore_state (current))) (retval) (retval_3) (val_pre)))) ) ”
) \/
(
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_4: Z) (retval_2: Z) (handler: Z) (current: CrtosOSWorld) (retval_3: Z) (PreH1 : (retval_2 <= INT_MAX)) (PreH2 : (retval_3 <= INT_MAX)) (PreH3 : (retval_2 >= INT_MIN)) (PreH4 : (retval_3 >= INT_MIN)) (PreH5 : (crtos_os_world_wf stable (Build_CrtosOSWorld ((crtos_task_state (current))) ((crtos_scheduler_state (current))) ((semaphore_create_state ((crtos_semaphore_state (current))) (retval) (retval_3) (val_pre)))) )) (PreH6 : (retval <> 0)) (PreH7 : (retval_3 >= 0)) (PreH8 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH9 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH10 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH11 : (semaphore_layout_32_ok retval )) (PreH12 : (0 <= retval_3)) (PreH13 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_3)))) (PreH14 : (semaphore_layout_32_ok retval )) (PreH15 : (crtos_os_world_wf stable current )) (PreH16 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH17 : (retval_2 = handler)) (PreH18 : (semaphore_irq_handler_ok handler )) (PreH19 : (SemaphoreRely stable before current )) (PreH20 : (retval_4 = retval)) (PreH21 : (retval <> 0)) (PreH22 : (retval <> 0)) (PreH23 : (sizeof( "Semaphore" ) = 32)) (PreH24 : (0 <= val_pre)) (PreH25 : (val_pre <= 65535)) (PreH26 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  ((( &( "id" ) )) # Int  |-> retval_3)
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  (crtos_semaphore_os_inv stable (Build_CrtosOSWorld ((crtos_task_state (current))) ((crtos_scheduler_state (current))) ((semaphore_create_state ((crtos_semaphore_state (current))) (retval) (retval_3) (val_pre)))) )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval_2)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (SemaphoreGuarantee stable current (Build_CrtosOSWorld ((crtos_task_state (current))) ((crtos_scheduler_state (current))) ((semaphore_create_state ((crtos_semaphore_state (current))) (retval) (retval_3) (val_pre)))) ) ”
).

Definition _SemaphoreCreate_partial_solve_wit_16_pure_split_goal_1 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_4: Z) (retval_2: Z) (handler: Z) (current: CrtosOSWorld) (retval_3: Z) (PreH1 : (retval_2 <= INT_MAX)) (PreH2 : (retval_3 <= INT_MAX)) (PreH3 : (retval_2 >= INT_MIN)) (PreH4 : (retval_3 >= INT_MIN)) (PreH5 : (crtos_os_world_wf stable (Build_CrtosOSWorld ((crtos_task_state (current))) ((crtos_scheduler_state (current))) ((semaphore_create_state ((crtos_semaphore_state (current))) (retval) (retval_3) (val_pre)))) )) (PreH6 : (retval <> 0)) (PreH7 : (retval_3 >= 0)) (PreH8 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH9 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH10 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH11 : (semaphore_layout_32_ok retval )) (PreH12 : (0 <= retval_3)) (PreH13 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_3)))) (PreH14 : (semaphore_layout_32_ok retval )) (PreH15 : (crtos_os_world_wf stable current )) (PreH16 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH17 : (retval_2 = handler)) (PreH18 : (semaphore_irq_handler_ok handler )) (PreH19 : (SemaphoreRely stable before current )) (PreH20 : (retval_4 = retval)) (PreH21 : (retval <> 0)) (PreH22 : (retval <> 0)) (PreH23 : (sizeof( "Semaphore" ) = 32)) (PreH24 : (0 <= val_pre)) (PreH25 : (val_pre <= 65535)) (PreH26 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  ((( &( "id" ) )) # Int  |-> retval_3)
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  (crtos_semaphore_os_inv stable (Build_CrtosOSWorld ((crtos_task_state (current))) ((crtos_scheduler_state (current))) ((semaphore_create_state ((crtos_semaphore_state (current))) (retval) (retval_3) (val_pre)))) )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
  **  ((( &( "lock" ) )) # Int  |-> retval_2)
  **  ((( &( "val" ) )) # UShort  |-> val_pre)
|--
  “ (SemaphoreGuarantee stable current (Build_CrtosOSWorld ((crtos_task_state (current))) ((crtos_scheduler_state (current))) ((semaphore_create_state ((crtos_semaphore_state (current))) (retval) (retval_3) (val_pre)))) ) ”
.

Definition _SemaphoreCreate_partial_solve_wit_16_aux := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (retval: Z) (retval_4: Z) (retval_2: Z) (handler: Z) (current: CrtosOSWorld) (retval_3: Z) (PreH1 : (crtos_os_world_wf stable (Build_CrtosOSWorld ((crtos_task_state (current))) ((crtos_scheduler_state (current))) ((semaphore_create_state ((crtos_semaphore_state (current))) (retval) (retval_3) (val_pre)))) )) (PreH2 : (retval <> 0)) (PreH3 : (retval_3 >= 0)) (PreH4 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH5 : (&((retval)  # "Semaphore" ->ₛ "id") <> 0)) (PreH6 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) (PreH7 : (semaphore_layout_32_ok retval )) (PreH8 : (0 <= retval_3)) (PreH9 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_3)))) (PreH10 : (semaphore_layout_32_ok retval )) (PreH11 : (crtos_os_world_wf stable current )) (PreH12 : ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH13 : (retval_2 = handler)) (PreH14 : (semaphore_irq_handler_ok handler )) (PreH15 : (SemaphoreRely stable before current )) (PreH16 : (retval_4 = retval)) (PreH17 : (retval <> 0)) (PreH18 : (retval <> 0)) (PreH19 : (sizeof( "Semaphore" ) = 32)) (PreH20 : (0 <= val_pre)) (PreH21 : (val_pre <= 65535)) (PreH22 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (crtos_semaphore_os_inv stable (Build_CrtosOSWorld ((crtos_task_state (current))) ((crtos_scheduler_state (current))) ((semaphore_create_state ((crtos_semaphore_state (current))) (retval) (retval_3) (val_pre)))) )
  **  (SemaphoreCriticalHeld handler (@nil Z) stable current )
|--
  “ (semaphore_irq_handler_ok retval_2 ) ” 
  &&  “ (SemaphoreGuarantee stable current (Build_CrtosOSWorld ((crtos_task_state (current))) ((crtos_scheduler_state (current))) ((semaphore_create_state ((crtos_semaphore_state (current))) (retval) (retval_3) (val_pre)))) ) ” 
  &&  “ (crtos_os_world_wf stable (Build_CrtosOSWorld ((crtos_task_state (current))) ((crtos_scheduler_state (current))) ((semaphore_create_state ((crtos_semaphore_state (current))) (retval) (retval_3) (val_pre)))) ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (retval_3 >= 0) ” 
  &&  “ (( &( "k_sem_id_manager" ) ) <> 0) ” 
  &&  “ (&((retval)  # "Semaphore" ->ₛ "id") <> 0) ” 
  &&  “ (SemaphoreStableContext (crtos_semaphore_stable (stable)) ) ” 
  &&  “ (semaphore_layout_32_ok retval ) ” 
  &&  “ (0 <= retval_3) ” 
  &&  “ ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (retval_3))) ” 
  &&  “ (semaphore_layout_32_ok retval ) ” 
  &&  “ (crtos_os_world_wf stable current ) ” 
  &&  “ ((semaphore_find_addr (retval) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None) ” 
  &&  “ (retval_2 = handler) ” 
  &&  “ (semaphore_irq_handler_ok handler ) ” 
  &&  “ (SemaphoreRely stable before current ) ” 
  &&  “ (retval_4 = retval) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (sizeof( "Semaphore" ) = 32) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X ) ”
  &&  (SemaphoreCriticalHeld retval_2 (@nil Z) stable current )
  **  (crtos_semaphore_os_inv stable (Build_CrtosOSWorld ((crtos_task_state (current))) ((crtos_scheduler_state (current))) ((semaphore_create_state ((crtos_semaphore_state (current))) (retval) (retval_3) (val_pre)))) )
.

Definition _SemaphoreCreate_partial_solve_wit_16 := _SemaphoreCreate_partial_solve_wit_16_pure -> _SemaphoreCreate_partial_solve_wit_16_aux.

Definition _SemaphoreCreate_which_implies_wit_1 := 
(
forall (stable: CrtosOSStable) (current: CrtosOSWorld) (sem: Z) ,
  (crtos_semaphore_os_inv stable current )
  **  (store_sem_zeroed_private sem )
|--
  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (crtos_os_world_wf stable current ) ” 
  &&  “ ((semaphore_find_addr (sem) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None) ”
  &&  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_sem_id_node_zeroed sem )
  **  (store_sem_after_id_insert_private sem )
) \/
(
forall (stable: CrtosOSStable) (current: CrtosOSWorld) (sem: Z) ,
  (crtos_semaphore_os_inv stable current )
  **  (store_sem_zeroed_private sem )
|--
  “ ((semaphore_find_addr (sem) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None) ” 
  &&  “ (crtos_os_world_wf stable current ) ” 
  &&  “ (semaphore_layout_32_ok sem ) ”
  &&  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_sem_id_node_zeroed sem )
  **  (store_sem_after_id_insert_private sem )
).

Definition _SemaphoreCreate_which_implies_wit_1_split_goal_1 := 
forall (stable: CrtosOSStable) (current: CrtosOSWorld) (sem: Z) ,
  (crtos_semaphore_os_inv stable current )
  **  (store_sem_zeroed_private sem )
|--
  “ ((semaphore_find_addr (sem) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None) ”
.

Definition _SemaphoreCreate_which_implies_wit_1_split_goal_2 := 
forall (stable: CrtosOSStable) (current: CrtosOSWorld) (sem: Z) ,
  (crtos_semaphore_os_inv stable current )
  **  (store_sem_zeroed_private sem )
|--
  “ (crtos_os_world_wf stable current ) ”
.

Definition _SemaphoreCreate_which_implies_wit_1_split_goal_3 := 
forall (stable: CrtosOSStable) (current: CrtosOSWorld) (sem: Z) ,
  (crtos_semaphore_os_inv stable current )
  **  (store_sem_zeroed_private sem )
|--
  “ (semaphore_layout_32_ok sem ) ”
.

Definition _SemaphoreCreate_which_implies_wit_1_split_goal_spatial := 
forall (stable: CrtosOSStable) (current: CrtosOSWorld) (sem: Z) ,
  (crtos_semaphore_os_inv stable current )
  **  (store_sem_zeroed_private sem )
|--
  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_sem_id_node_zeroed sem )
  **  (store_sem_after_id_insert_private sem )
.

Definition _SemaphoreCreate_which_implies_wit_2 := 
(
forall (sem: Z) (PreH1 : (semaphore_layout_32_ok sem )) ,
  (store_sem_id_node_zeroed sem )
  **  (store_sem_after_id_insert_private sem )
|--
  (store_sem_zeroed_private sem )
) \/
(
forall (sem: Z) (PreH1 : (semaphore_layout_32_ok sem )) ,
  (store_sem_id_node_zeroed sem )
  **  (store_sem_after_id_insert_private sem )
|--
  (store_sem_zeroed_private sem )
).

Definition _SemaphoreCreate_which_implies_wit_2_split_goal_spatial := 
forall (sem: Z) (PreH1 : (semaphore_layout_32_ok sem )) ,
  (store_sem_id_node_zeroed sem )
  **  (store_sem_after_id_insert_private sem )
|--
  (store_sem_zeroed_private sem )
.

Definition _SemaphoreCreate_which_implies_wit_3 := 
(
forall (stable: CrtosOSStable) (current: CrtosOSWorld) ,
  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
|--
  (crtos_semaphore_os_inv stable current )
) \/
(
forall (stable: CrtosOSStable) (current: CrtosOSWorld) ,
  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
|--
  (crtos_semaphore_os_inv stable current )
).

Definition _SemaphoreCreate_which_implies_wit_3_split_goal_spatial := 
forall (stable: CrtosOSStable) (current: CrtosOSWorld) ,
  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
  **  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
|--
  (crtos_semaphore_os_inv stable current )
.

Definition _SemaphoreCreate_which_implies_wit_4 := 
(
forall (sem: Z) ,
  (store_sem_after_id_insert_private sem )
|--
  “ (sem <> 0) ”
  &&  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (store_sem_body_padding_zero sem )
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |-> 0)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> 0)
) \/
(
forall (sem: Z) ,
  (store_sem_after_id_insert_private sem )
|--
  “ (sem <> 0) ”
  &&  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (store_sem_body_padding_zero sem )
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |-> 0)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> 0)
).

Definition _SemaphoreCreate_which_implies_wit_4_split_goal_1 := 
forall (sem: Z) ,
  (store_sem_after_id_insert_private sem )
|--
  “ (sem <> 0) ”
.

Definition _SemaphoreCreate_which_implies_wit_4_split_goal_spatial := 
forall (sem: Z) ,
  (store_sem_after_id_insert_private sem )
|--
  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (store_sem_body_padding_zero sem )
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((sem)  # "Semaphore" ->ₛ "pend_list" .ₛ "node_prev")) # Ptr  |-> 0)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> 0)
.

Definition _SemaphoreCreate_which_implies_wit_5 := 
(
forall (stable: CrtosOSStable) (current: CrtosOSWorld) (PreH1 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) ,
  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
|--
  (store_sem_dll store_semaphore_body ( &( "k_sem_list" ) ) (map (semaphore_registry_node) ((semaphore_objects ((crtos_semaphore_state (current)))))) )
) \/
(
forall (stable: CrtosOSStable) (current: CrtosOSWorld) (PreH1 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) ,
  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
|--
  (store_sem_dll store_semaphore_body ( &( "k_sem_list" ) ) (map (semaphore_registry_node) ((semaphore_objects ((crtos_semaphore_state (current)))))) )
).

Definition _SemaphoreCreate_which_implies_wit_5_split_goal_spatial := 
forall (stable: CrtosOSStable) (current: CrtosOSWorld) (PreH1 : (SemaphoreStableContext (crtos_semaphore_stable (stable)) )) ,
  (store_semaphore_registry (crtos_semaphore_stable (stable)) (crtos_semaphore_state (current)) )
|--
  (store_sem_dll store_semaphore_body ( &( "k_sem_list" ) ) (map (semaphore_registry_node) ((semaphore_objects ((crtos_semaphore_state (current)))))) )
.

Definition _SemaphoreCreate_which_implies_wit_6 := 
(
forall (val_pre: Z) (stable: CrtosOSStable) (current: CrtosOSWorld) (sem: Z) (id: Z) (PreH1 : (sem <> 0)) (PreH2 : (semaphore_layout_32_ok sem )) ,
  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (sem) (id)) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (store_sem_body_padding_zero sem )
  **  (store_sem_dll semaphore_unit_empty &((sem)  # "Semaphore" ->ₛ "pend_list") (@nil (@SemDLNode unit)) )
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> 0)
|--
  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (sem) (id)) )
  **  (store_sem_standalone_node store_semaphore_body &((sem)  # "Semaphore" ->ₛ "link") (Build_SemaphoreObject (sem) (id) (val_pre) ((@nil Z))) )
) \/
(
forall (val_pre: Z) (stable: CrtosOSStable) (current: CrtosOSWorld) (sem: Z) (id: Z) (PreH1 : (sem <> 0)) (PreH2 : (semaphore_layout_32_ok sem )) ,
  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (sem) (id)) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (store_sem_body_padding_zero sem )
  **  (store_sem_dll semaphore_unit_empty &((sem)  # "Semaphore" ->ₛ "pend_list") (@nil (@SemDLNode unit)) )
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> 0)
|--
  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (sem) (id)) )
  **  (store_sem_standalone_node store_semaphore_body &((sem)  # "Semaphore" ->ₛ "link") (Build_SemaphoreObject (sem) (id) (val_pre) ((@nil Z))) )
).

Definition _SemaphoreCreate_which_implies_wit_6_split_goal_spatial := 
forall (val_pre: Z) (stable: CrtosOSStable) (current: CrtosOSWorld) (sem: Z) (id: Z) (PreH1 : (sem <> 0)) (PreH2 : (semaphore_layout_32_ok sem )) ,
  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (sem) (id)) )
  **  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> val_pre)
  **  (store_sem_body_padding_zero sem )
  **  (store_sem_dll semaphore_unit_empty &((sem)  # "Semaphore" ->ₛ "pend_list") (@nil (@SemDLNode unit)) )
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((sem)  # "Semaphore" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> 0)
|--
  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (sem) (id)) )
  **  (store_sem_standalone_node store_semaphore_body &((sem)  # "Semaphore" ->ₛ "link") (Build_SemaphoreObject (sem) (id) (val_pre) ((@nil Z))) )
.

Definition _SemaphoreCreate_which_implies_wit_7 := 
(
forall (val_pre: Z) (stable: CrtosOSStable) (current: CrtosOSWorld) (sem: Z) (id: Z) (PreH1 : (sem <> 0)) (PreH2 : (0 <= id)) (PreH3 : (id < 128)) (PreH4 : (0 <= val_pre)) (PreH5 : (val_pre <= 65535)) (PreH6 : (crtos_os_world_wf stable current )) (PreH7 : ((semaphore_find_addr (sem) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH8 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (id)))) ,
  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (sem) (id)) )
  **  (store_sem_dll store_semaphore_body ( &( "k_sem_list" ) ) (cons ((Build_SemDLNode ((Build_SemaphoreObject (sem) (id) (val_pre) ((@nil Z)))) (&((sem)  # "Semaphore" ->ₛ "link")))) ((map (semaphore_registry_node) ((semaphore_objects ((crtos_semaphore_state (current)))))))) )
|--
  “ (crtos_os_world_wf stable (Build_CrtosOSWorld ((crtos_task_state (current))) ((crtos_scheduler_state (current))) ((semaphore_create_state ((crtos_semaphore_state (current))) (sem) (id) (val_pre)))) ) ”
  &&  (crtos_semaphore_os_inv stable (Build_CrtosOSWorld ((crtos_task_state (current))) ((crtos_scheduler_state (current))) ((semaphore_create_state ((crtos_semaphore_state (current))) (sem) (id) (val_pre)))) )
) \/
(
forall (val_pre: Z) (stable: CrtosOSStable) (current: CrtosOSWorld) (sem: Z) (id: Z) (PreH1 : (sem <> 0)) (PreH2 : (0 <= id)) (PreH3 : (id < 128)) (PreH4 : (0 <= val_pre)) (PreH5 : (val_pre <= 65535)) (PreH6 : (crtos_os_world_wf stable current )) (PreH7 : ((semaphore_find_addr (sem) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH8 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (id)))) ,
  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (sem) (id)) )
  **  (store_sem_dll store_semaphore_body ( &( "k_sem_list" ) ) (cons ((Build_SemDLNode ((Build_SemaphoreObject (sem) (id) (val_pre) ((@nil Z)))) (&((sem)  # "Semaphore" ->ₛ "link")))) ((map (semaphore_registry_node) ((semaphore_objects ((crtos_semaphore_state (current)))))))) )
|--
  “ (crtos_os_world_wf stable (Build_CrtosOSWorld ((crtos_task_state (current))) ((crtos_scheduler_state (current))) ((semaphore_create_state ((crtos_semaphore_state (current))) (sem) (id) (val_pre)))) ) ”
  &&  (crtos_semaphore_os_inv stable (Build_CrtosOSWorld ((crtos_task_state (current))) ((crtos_scheduler_state (current))) ((semaphore_create_state ((crtos_semaphore_state (current))) (sem) (id) (val_pre)))) )
).

Definition _SemaphoreCreate_which_implies_wit_7_split_goal_1 := 
forall (val_pre: Z) (stable: CrtosOSStable) (current: CrtosOSWorld) (sem: Z) (id: Z) (PreH1 : (sem <> 0)) (PreH2 : (0 <= id)) (PreH3 : (id < 128)) (PreH4 : (0 <= val_pre)) (PreH5 : (val_pre <= 65535)) (PreH6 : (crtos_os_world_wf stable current )) (PreH7 : ((semaphore_find_addr (sem) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH8 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (id)))) ,
  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (sem) (id)) )
  **  (store_sem_dll store_semaphore_body ( &( "k_sem_list" ) ) (cons ((Build_SemDLNode ((Build_SemaphoreObject (sem) (id) (val_pre) ((@nil Z)))) (&((sem)  # "Semaphore" ->ₛ "link")))) ((map (semaphore_registry_node) ((semaphore_objects ((crtos_semaphore_state (current)))))))) )
|--
  “ (crtos_os_world_wf stable (Build_CrtosOSWorld ((crtos_task_state (current))) ((crtos_scheduler_state (current))) ((semaphore_create_state ((crtos_semaphore_state (current))) (sem) (id) (val_pre)))) ) ”
.

Definition _SemaphoreCreate_which_implies_wit_7_split_goal_spatial := 
forall (val_pre: Z) (stable: CrtosOSStable) (current: CrtosOSWorld) (sem: Z) (id: Z) (PreH1 : (sem <> 0)) (PreH2 : (0 <= id)) (PreH3 : (id < 128)) (PreH4 : (0 <= val_pre)) (PreH5 : (val_pre <= 65535)) (PreH6 : (crtos_os_world_wf stable current )) (PreH7 : ((semaphore_find_addr (sem) ((semaphore_objects ((crtos_semaphore_state (current)))))) = None)) (PreH8 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current)))) = (Some (id)))) ,
  (crtos_semaphore_nonsem_frame stable current )
  **  (store_semaphore_id_manager (crtos_semaphore_stable (stable)) (semaphore_reserve_state ((crtos_semaphore_state (current))) (sem) (id)) )
  **  (store_sem_dll store_semaphore_body ( &( "k_sem_list" ) ) (cons ((Build_SemDLNode ((Build_SemaphoreObject (sem) (id) (val_pre) ((@nil Z)))) (&((sem)  # "Semaphore" ->ₛ "link")))) ((map (semaphore_registry_node) ((semaphore_objects ((crtos_semaphore_state (current)))))))) )
|--
  (crtos_semaphore_os_inv stable (Build_CrtosOSWorld ((crtos_task_state (current))) ((crtos_scheduler_state (current))) ((semaphore_create_state ((crtos_semaphore_state (current))) (sem) (id) (val_pre)))) )
.

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
Axiom proof_of__SemaphoreCreate_safety_wit_16 : _SemaphoreCreate_safety_wit_16.
Axiom proof_of__SemaphoreCreate_return_wit_1 : _SemaphoreCreate_return_wit_1.
Axiom proof_of__SemaphoreCreate_return_wit_2 : _SemaphoreCreate_return_wit_2.
Axiom proof_of__SemaphoreCreate_return_wit_3 : _SemaphoreCreate_return_wit_3.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_1_pure : _SemaphoreCreate_partial_solve_wit_1_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_1 : _SemaphoreCreate_partial_solve_wit_1.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_2_pure : _SemaphoreCreate_partial_solve_wit_2_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_2 : _SemaphoreCreate_partial_solve_wit_2.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_3 : _SemaphoreCreate_partial_solve_wit_3.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_4 : _SemaphoreCreate_partial_solve_wit_4.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_5_pure : _SemaphoreCreate_partial_solve_wit_5_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_5 : _SemaphoreCreate_partial_solve_wit_5.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_6_pure : _SemaphoreCreate_partial_solve_wit_6_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_6 : _SemaphoreCreate_partial_solve_wit_6.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_7 : _SemaphoreCreate_partial_solve_wit_7.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_8 : _SemaphoreCreate_partial_solve_wit_8.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_9_pure : _SemaphoreCreate_partial_solve_wit_9_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_9 : _SemaphoreCreate_partial_solve_wit_9.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_10 : _SemaphoreCreate_partial_solve_wit_10.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_11_pure : _SemaphoreCreate_partial_solve_wit_11_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_11 : _SemaphoreCreate_partial_solve_wit_11.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_12_pure : _SemaphoreCreate_partial_solve_wit_12_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_12 : _SemaphoreCreate_partial_solve_wit_12.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_13_pure : _SemaphoreCreate_partial_solve_wit_13_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_13 : _SemaphoreCreate_partial_solve_wit_13.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_14_pure : _SemaphoreCreate_partial_solve_wit_14_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_14 : _SemaphoreCreate_partial_solve_wit_14.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_15_pure : _SemaphoreCreate_partial_solve_wit_15_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_15 : _SemaphoreCreate_partial_solve_wit_15.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_16_pure : _SemaphoreCreate_partial_solve_wit_16_pure.
Axiom proof_of__SemaphoreCreate_partial_solve_wit_16 : _SemaphoreCreate_partial_solve_wit_16.
Axiom proof_of__SemaphoreCreate_which_implies_wit_1 : _SemaphoreCreate_which_implies_wit_1.
Axiom proof_of__SemaphoreCreate_which_implies_wit_2 : _SemaphoreCreate_which_implies_wit_2.
Axiom proof_of__SemaphoreCreate_which_implies_wit_3 : _SemaphoreCreate_which_implies_wit_3.
Axiom proof_of__SemaphoreCreate_which_implies_wit_4 : _SemaphoreCreate_which_implies_wit_4.
Axiom proof_of__SemaphoreCreate_which_implies_wit_5 : _SemaphoreCreate_which_implies_wit_5.
Axiom proof_of__SemaphoreCreate_which_implies_wit_6 : _SemaphoreCreate_which_implies_wit_6.
Axiom proof_of__SemaphoreCreate_which_implies_wit_7 : _SemaphoreCreate_which_implies_wit_7.

End VC_Correct.
