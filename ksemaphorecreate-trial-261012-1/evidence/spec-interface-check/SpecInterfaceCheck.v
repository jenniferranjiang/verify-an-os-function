(* Interface type checks only; no copied C function contracts or added definitions. *)
From Coq Require Import ZArith.ZArith Lists.List.
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
Import ListNotations.
Local Open Scope Z_scope.
Check ((fun (P : Assertion) => P) : Crtos_C_Rules.expr -> Crtos_C_Rules.expr).
Check (StableIdmanager : Type).
Check (VarIdmanager : Type).
Check (SemaphoreState : Type).
Check (SemaphoreStable : Type).
Check (CrtosOSState : Type).
Check (SchedulerState : Type).
Check (CrtosOSStable : Type).
Check (Task_C_Rules.expr : Type).
Check (OSHeap : Task_C_Rules.expr -> Crtos_C_Rules.expr).
Check (store_sem_allocated : Z -> Task_C_Rules.expr).
Check (store_sem_zeroed_private : Z -> Task_C_Rules.expr).
Check (store_sem_id_detached : Z -> Z -> Z -> Z -> Task_C_Rules.expr).
Check (store_idmanager : StableIdmanager -> VarIdmanager -> Z -> Task_C_Rules.expr).
Check (store_idmanager_allocated_unlinked : StableIdmanager -> VarIdmanager -> Z -> Z -> Task_C_Rules.expr).
Check (idmanager_add : VarIdmanager -> Z -> VarIdmanager).
Check (idmanager_link : StableIdmanager -> VarIdmanager -> Z -> Z -> VarIdmanager).
Check (idmanager_min_free_id : StableIdmanager -> VarIdmanager -> Z -> Prop).
Check (idmanager_full : StableIdmanager -> VarIdmanager -> Prop).
Check (os_sem_stable : CrtosOSStable -> SemaphoreStable).
Check (os_semaphores : CrtosOSState -> SemaphoreState).
Check (os_scheduler : CrtosOSState -> SchedulerState).
Check (scheduler_lock_nest : SchedulerState -> Z).
Check (semaphore_manager_abs : SemaphoreStable -> StableIdmanager).
Check (semaphore_manager_state : SemaphoreStable -> SemaphoreState -> VarIdmanager).
Check (semaphore_os_publish : Z -> Z -> Z -> CrtosOSState -> CrtosOSState).
Check (semaphore_nest_increment : CrtosOSState -> CrtosOSState).
Check (semaphore_nest_decrement : CrtosOSState -> CrtosOSState).
Check (SemaphoreRely : list Z -> CrtosOSState -> CrtosOSState -> Prop).
Check (SemaphoreGuarantee : CrtosOSState -> CrtosOSState -> Prop).
Check (semaphore_irq_handler_ok : Z -> Prop).
Check (SemaphoreOutsideCritical : CrtosOSStable -> list Z -> CrtosOSState -> Crtos_C_Rules.expr).
Check (SemaphoreInsideCritical : CrtosOSStable -> list Z -> Z -> CrtosOSState -> Crtos_C_Rules.expr).
Check (SemaphoreOSInvariant : CrtosOSStable -> CrtosOSState -> Crtos_C_Rules.expr).
Check (SemaphoreCriticalFrame : CrtosOSStable -> CrtosOSState -> Crtos_C_Rules.expr).
Check (CrtosOSValid : CrtosOSState -> Prop).
(* Representative composed terms appearing within contracts; these are not full specs. *)
Section ContractTermTypes.
Variables (sg : CrtosOSStable) (hs : list Z) (before current after : CrtosOSState).
Variables (sm : StableIdmanager) (manager_before : VarIdmanager).
Variables (p id value handler old_id previous next : Z).
Check (scheduler_lock_nest (os_scheduler before) < 65535 : Prop).
Check (idmanager_full (semaphore_manager_abs (os_sem_stable sg))
  (semaphore_manager_state (os_sem_stable sg) (os_semaphores current)) : Prop).
Check (idmanager_min_free_id (semaphore_manager_abs (os_sem_stable sg))
  (semaphore_manager_state (os_sem_stable sg) (os_semaphores current)) id : Prop).
Check (SemaphoreGuarantee current (semaphore_os_publish p id value current) : Prop).
Check (SemaphoreOutsideCritical sg hs (semaphore_os_publish p id value current) : Crtos_C_Rules.expr).
Check (SemaphoreOSInvariant sg (semaphore_nest_increment current) : Crtos_C_Rules.expr).
Check (SemaphoreGuarantee before (semaphore_nest_decrement after) : Prop).
Check (SemaphoreOutsideCritical sg hs (semaphore_nest_decrement after) : Crtos_C_Rules.expr).
Check (semaphore_nest_increment (semaphore_os_publish p id value current) : CrtosOSState).
Check (OSHeap (store_idmanager sm (idmanager_link sm (idmanager_add manager_before id) id p) p) : Crtos_C_Rules.expr).
Check (OSHeap (store_idmanager_allocated_unlinked sm manager_before p id) : Crtos_C_Rules.expr).
Check (OSHeap (store_sem_id_detached p old_id previous next) : Crtos_C_Rules.expr).
End ContractTermTypes.

