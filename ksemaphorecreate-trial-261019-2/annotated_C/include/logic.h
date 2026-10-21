#ifndef FRESH_SEMAPHORE_LOGIC_H
#define FRESH_SEMAPHORE_LOGIC_H
#include "monad.h"
/* Formal vocabulary only; every C contract is in its canonical/caller-local .c. */
/*@ Import Coq Require Import Coq.ZArith.ZArith Coq.Lists.List */
/*@ Import Coq From AUXLib Require Import ListLib */
/*@ Import Coq Require Import CRTOS_Verify.lib.idnode CRTOS_Verify.lib.KSemaphoreCreate */
/*@ Import Coq Import DLL IDNode ListNotations */
/*@ Extern Coq
  (StableGlobalState :: *) (VarGlobalState :: *)
  (SemaphoreStable :: *) (SemaphoreState :: *) (SemaphoreObject :: *) (SemaphoreAbs :: *)
  (TaskState :: *) (TaskDescriptorAbs :: *)
  (StableIdmanager :: *) (VarIdmanager :: *) (IdNodeAbs :: *)
  (DL_Node :: * => *) (option :: * => *)
*/
/*@ Extern Coq
  (true : bool) (false : bool)
  (InsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
  (OutsideCriticalIRQ : Z -> StableGlobalState -> VarGlobalState -> Assertion)
  (critical_projection : StableGlobalState -> VarGlobalState -> Assertion)
  (critical_nest : Z -> Assertion)
  (critical_nest_inc : Z -> Z) (critical_nest_dec : Z -> Z) (critical_nest_roundtrip : Z -> Z)
  (critical_anchor : bool -> VarGlobalState -> VarGlobalState -> VarGlobalState)
  (Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop)
  (Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop)
  (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
  (ExactSeen : VarGlobalState -> VarGlobalState -> Prop)
  (abs_semaphore_create : StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
  (abs_semaphore_create_masked : StableGlobalState -> Z -> program VarGlobalState Z)
  (semaphore_create_nest_result : StableGlobalState -> Z -> VarGlobalState -> Z -> Z -> VarGlobalState -> Z -> Prop)
  (semaphore_allocated : Z -> Assertion) (semaphore_zero : Z -> Assertion)
  (semaphore_after_id : Z -> Assertion)
  (store_private_idnode : Z -> Z -> Z -> Z -> Assertion)
  (store_uninit_dlnode : Z -> Assertion)
  (store_dll : {A} -> (Z -> A -> Assertion) -> Z -> list (DL_Node A) -> Assertion)
  (Build_DL_Node : {A} -> A -> Z -> DL_Node A)
  (store_idmanager : StableIdmanager -> VarIdmanager -> Z -> Assertion)
  (store_idmanager_allocated_unlinked : StableIdmanager -> VarIdmanager -> Z -> Z -> Assertion)
  (store_idnode_unlinked : Z -> IdNodeAbs -> Assertion)
  (store_idnode : Z -> IdNodeAbs -> Assertion)
  (Build_IdNodeAbs : Z -> Z -> IdNodeAbs)
  (idmanager_full : StableIdmanager -> VarIdmanager -> Prop)
  (idmanager_min_free_id : StableIdmanager -> VarIdmanager -> Z -> Prop)
  (idmanager_add : VarIdmanager -> Z -> VarIdmanager)
  (idmanager_link : StableIdmanager -> VarIdmanager -> Z -> Z -> VarIdmanager)
  (idnodes_to_dll : list IdNodeAbs -> list (DL_Node IdNodeAbs))
  (idbuckets : VarIdmanager -> list (list IdNodeAbs))
  (hoffset : StableIdmanager -> Z)
  (sem_idmanager_abs : SemaphoreState -> VarIdmanager)
  (sem_idmanager_stable : SemaphoreStable -> StableIdmanager)
  (os_semaphore_stable : StableGlobalState -> SemaphoreStable)
  (os_semaphores : VarGlobalState -> SemaphoreState)
  (os_tasks : VarGlobalState -> TaskState)
  (task_desc_map : TaskState -> Z -> option TaskDescriptorAbs)
  (pure_suspend_sched_link : (Z -> option TaskDescriptorAbs) -> Z -> Z -> Assertion)
  (sem_objects : SemaphoreState -> list SemaphoreObject)
  (Build_SemaphoreObject : Z -> Z -> SemaphoreAbs -> SemaphoreObject)
  (Build_SemaphoreAbs : Z -> list (DL_Node Z) -> SemaphoreAbs)
  (semaphore_node : SemaphoreObject -> DL_Node SemaphoreObject)
  (store_semaphore_member : (Z -> Z -> Assertion) -> Z -> SemaphoreObject -> Assertion)
  (semaphore_publish : VarGlobalState -> Z -> Z -> Z -> VarGlobalState)
  (map : {A} {B} -> (A -> B) -> list A -> list B)
  (Znth : {A} -> Z -> list A -> A -> A)
*/
#endif
