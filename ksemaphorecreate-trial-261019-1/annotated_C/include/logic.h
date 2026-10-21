#ifndef TRIAL_LOGIC_H
#define TRIAL_LOGIC_H
#include "monad.h"
/* Formal names only: all function contracts are caller-local in the .c files. */
/*@ Import Coq Require Import Coq.Lists.List Coq.ZArith.ZArith */
/*@ Import Coq From AUXLib Require Import ListLib */
/*@ Import Coq Require Import CRTOS_Verify.lib.KSemaphoreCreate */
/*@ Import Coq Import DLL IDNode ListNotations */
/*@ Extern Coq
  (StableGlobalState :: *) (VarGlobalState :: *)
  (SemaphoreStable :: *) (SemaphoreState :: *)
  (StableIdmanager :: *) (VarIdmanager :: *) (IdNodeAbs :: *)
  (DL_Node :: * => *)
*/
/*@ Extern Coq
  (OutsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
  (InsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
  (IRQMask : Z -> Assertion)
  (slice_OS_inv : StableGlobalState -> VarGlobalState -> Z -> Assertion)
  (Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop)
  (Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop)
  (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
  (ExactSeen : VarGlobalState -> VarGlobalState -> Prop)
  (abs_semaphore_create : StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
  (abs_semaphore_create_nested : StableGlobalState -> Z -> program VarGlobalState Z)
  (semaphore_create_nested_result : StableGlobalState -> Z -> VarGlobalState -> Z -> Z -> VarGlobalState -> Z -> Prop)
  (nest_inc : Z -> Z) (nest_dec : Z -> Z) (nest_roundtrip : Z -> Z)
  (critical_anchor : Z -> VarGlobalState -> VarGlobalState -> VarGlobalState)
  (sem_allocated : Z -> Assertion) (sem_zero : Z -> Assertion)
  (sem_id_registered : Z -> Assertion)
  (sem_ready_to_publish : Z -> Z -> Assertion)
  (idnode_private : Z -> Z -> Z -> Z -> Assertion)
  (store_idmanager : StableIdmanager -> VarIdmanager -> Z -> Assertion)
  (store_idmanager_allocated_unlinked : StableIdmanager -> VarIdmanager -> Z -> Z -> Assertion)
  (store_idnode_unlinked : Z -> IdNodeAbs -> Assertion)
  (Build_IdNodeAbs : Z -> Z -> IdNodeAbs)
  (idmanager_full : StableIdmanager -> VarIdmanager -> Prop)
  (idmanager_min_free_id : StableIdmanager -> VarIdmanager -> Z -> Prop)
  (idmanager_add : VarIdmanager -> Z -> VarIdmanager)
  (idmanager_link : StableIdmanager -> VarIdmanager -> Z -> Z -> VarIdmanager)
  (occupy_dll_node : Z -> Assertion)
  (store_dll : {A} -> (Z -> A -> Assertion) -> Z -> list (DL_Node A) -> Assertion)
  (Build_DL_Node : {A} -> A -> Z -> DL_Node A)
  (store_idnode : Z -> IdNodeAbs -> Assertion)
  (idnodes_to_dll : list IdNodeAbs -> list (DL_Node IdNodeAbs))
  (idbuckets : VarIdmanager -> list (list IdNodeAbs))
  (hoffset : StableIdmanager -> Z)
  (semaphore_idmanager : SemaphoreStable -> SemaphoreState -> VarIdmanager)
  (os_semaphore_stable : StableGlobalState -> SemaphoreStable)
  (sem_idmanager_stable : SemaphoreStable -> StableIdmanager)
  (os_semaphores : VarGlobalState -> SemaphoreState)
  (sem_ptr_list : SemaphoreState -> list Z)
  (semaphore_link_nodes : list Z -> list (DL_Node Z))
  (pure_semaphore_link_member : Z -> Z -> Assertion)
  (semaphore_publish : Z -> Z -> Z -> SemaphoreState -> SemaphoreState)
  (replace_semaphores : SemaphoreState -> VarGlobalState -> VarGlobalState)
  (Znth : {A} -> Z -> list A -> A -> A)
*/
#endif
