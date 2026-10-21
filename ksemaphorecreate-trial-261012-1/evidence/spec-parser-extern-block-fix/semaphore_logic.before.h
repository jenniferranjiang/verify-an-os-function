#ifndef CRTOS_SEMAPHORE_LOGIC_H
#define CRTOS_SEMAPHORE_LOGIC_H
/* Logical imports and names only. Every C callee contract lives in its caller. */
/*@ Import Coq Require Import CRTOS_Verify.lib.idnode */
/*@ Import Coq Require Import CRTOS_Verify.sem.SemaphorePure */
/*@ Import Coq Require Import CRTOS_Verify.sem.SemaphoreRep */
/*@ Import Coq Require Import CRTOS_Verify.sem.CrtosOSPure */
/*@ Import Coq Require Import CRTOS_Verify.sem.CrtosOSProtocol */
/*@ Import Coq Require Import CRTOS_Verify.sem.CrtosOSInv */
/*@ Import Coq Require Import CRTOS_Verify.sem.SemaphoreCritical */
/*@ Import Coq Import IDNode */
/*@ Import Coq Import Crtos_C_Rules */

/*@ Extern Coq
    (StableIdmanager :: *)
    (VarIdmanager :: *)
    (SemaphoreState :: *)
    (SemaphoreStable :: *)
    (CrtosOSState :: *)
    (SchedulerState :: *)
    (CrtosOSStable :: *)
    (Task_C_Rules::expr :: *)
    (OSHeap : Task_C_Rules::expr -> Assertion)
    (store_sem_allocated : Z -> Task_C_Rules::expr)
    (store_sem_zeroed_private : Z -> Task_C_Rules::expr)
    (store_sem_id_detached : Z -> Z -> Z -> Z -> Task_C_Rules::expr)
    (store_idmanager : StableIdmanager -> VarIdmanager -> Z -> Task_C_Rules::expr)
    (store_idmanager_allocated_unlinked : StableIdmanager -> VarIdmanager -> Z -> Z -> Task_C_Rules::expr)
    (idmanager_add : VarIdmanager -> Z -> VarIdmanager)
    (idmanager_link : StableIdmanager -> VarIdmanager -> Z -> Z -> VarIdmanager)
    (idmanager_min_free_id : StableIdmanager -> VarIdmanager -> Z -> Prop)
    (idmanager_full : StableIdmanager -> VarIdmanager -> Prop)
    (os_sem_stable : CrtosOSStable -> SemaphoreStable)
    (os_semaphores : CrtosOSState -> SemaphoreState)
    (os_scheduler : CrtosOSState -> SchedulerState)
    (scheduler_lock_nest : SchedulerState -> Z)
    (semaphore_manager_abs : SemaphoreStable -> StableIdmanager)
    (semaphore_manager_state : SemaphoreStable -> SemaphoreState -> VarIdmanager)
    (semaphore_os_publish : Z -> Z -> Z -> CrtosOSState -> CrtosOSState)
    (semaphore_nest_increment : CrtosOSState -> CrtosOSState)
    (semaphore_nest_decrement : CrtosOSState -> CrtosOSState)
    (SemaphoreRely : list Z -> CrtosOSState -> CrtosOSState -> Prop)
    (SemaphoreGuarantee : CrtosOSState -> CrtosOSState -> Prop)
    (semaphore_irq_handler_ok : Z -> Prop)
    (SemaphoreOutsideCritical : CrtosOSStable -> list Z -> CrtosOSState -> Assertion)
    (SemaphoreInsideCritical : CrtosOSStable -> list Z -> Z -> CrtosOSState -> Assertion)
    (SemaphoreOSInvariant : CrtosOSStable -> CrtosOSState -> Assertion)
*/
#endif
