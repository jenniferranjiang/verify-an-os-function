#ifndef CRTOS_MUTEX_CREATE_LOGIC_H
#define CRTOS_MUTEX_CREATE_LOGIC_H
/* Only logic declarations: canonical function contracts live in the src C files. */
/*@ Import Coq Require Import CRTOS_Verify.lib.mutex.KMutexCreate */
/*@ Import Coq Require Import CRTOS_Verify.lib.list.DoubleLinkListSpec */
/*@ Import Coq Require Import CRTOS_Verify.lib.task.KTaskWakeup */
/*@ Import Coq Import DLL IDNode */
#include "monad.h"
/*@ Extern Coq addr := Z */
/*@ Extern Coq (StableGlobalState :: *) (VarGlobalState :: *)
               (StableIdmanager :: *) (VarIdmanager :: *)
               (DL_Node :: * => *) */
/*@ Extern Coq
 (OutsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
 (InsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
 (os_inv : StableGlobalState -> VarGlobalState -> Assertion)
 (Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop)
 (Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop)
 (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
 (abs_mutex_create : StableGlobalState -> program (VarGlobalState -> Prop) Z)
 (addr_aligned : Z -> Z -> Prop)
 (MutexRaw : addr -> Assertion)
 (store_idmanager : StableIdmanager -> VarIdmanager -> addr -> Assertion)
 (store_idnode_insert_ready : addr -> Assertion)
 (idmanager_min_free_id : StableIdmanager -> VarIdmanager -> Z -> Prop)
 (idmanager_add : VarIdmanager -> Z -> VarIdmanager)
 (idmanager_link : StableIdmanager -> VarIdmanager -> Z -> addr -> VarIdmanager)
 (CharArray::undef_full : Z -> Z -> Assertion)
 (CharArray::full : Z -> Z -> list Z -> Assertion)
 (repeat_Z : {A} -> A -> Z -> list A)
 (store_node_self_linked : addr -> Assertion)
 (store_dll : {A} -> (addr -> A -> Assertion) -> addr -> list (DL_Node A) -> Assertion)
 (occupy_dll_node : addr -> Assertion)
 (nil : {A} -> list A)
 (cons : {A} -> A -> list A -> list A)
 (app : {A} -> list A -> list A -> list A)
 (Build_DL_Node : {A} -> A -> addr -> DL_Node A)
 (dll_insert_anchor : {A} -> addr -> list (DL_Node A) -> addr -> Prop)
 (dll_insert_after_dispatch : {A} -> addr -> list (DL_Node A) -> addr -> DL_Node A -> list (DL_Node A))
 (sched_link_of : addr -> addr)
 (store_ready_dll_tail_view : addr -> list (DL_Node Z) -> addr -> Assertion)
 (store_priority_ready_bucket : addr -> list (DL_Node Z) -> Assertion)
*/
#endif
