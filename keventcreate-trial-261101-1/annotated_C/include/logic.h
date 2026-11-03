#ifndef KEVENT_LOGIC_H
#define KEVENT_LOGIC_H
/* Only logic declarations: canonical function contracts live in the src C files. */
/*@ Import Coq Require Import CRTOS_Verify.lib.KEventCreate */
/*@ Import Coq Require Import CRTOS_Verify.lib.DoubleLinkListSpec */
/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskWakeup */
/*@ Import Coq Import DLL IDNode */
#include "monad.h"
/*@ Extern Coq addr := Z */
/*@ Extern Coq (StableGlobalState :: *) (VarGlobalState :: *)
               (StableIdmanager :: *) (VarIdmanager :: *)
               (DL_Node :: * => *) (EventStable :: *) (EventAbs :: *)
               (TaskState :: *) (TaskDescriptorAbs :: *) (option :: * => *) */
/*@ Extern Coq EventState := list EventAbs */
/*@ Extern Coq
 (os_event_stable : StableGlobalState -> EventStable)
 (os_events : VarGlobalState -> EventState)
 (event_manager_stable : EventStable -> StableIdmanager)
 (event_manager : EventState -> VarIdmanager)
 (event_created : Z -> Z -> Z -> EventAbs)
 (event_publish : Z -> Z -> Z -> EventState -> EventState)
 (event_link_node : EventAbs -> DL_Node EventAbs)
 (store_event : (addr -> addr -> Assertion) -> addr -> EventAbs -> Assertion)
 (replace_events : EventState -> VarGlobalState -> VarGlobalState)
 (os_tasks : VarGlobalState -> TaskState)
 (task_desc_map : TaskState -> addr -> option TaskDescriptorAbs)
 (pure_suspend_sched_link : (addr -> option TaskDescriptorAbs) -> addr -> addr -> Assertion)
 (map : {A} {B} -> (A -> B) -> list A -> list B)
 (OutsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
 (InsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
 (os_inv : StableGlobalState -> VarGlobalState -> Assertion)
 (Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop)
 (Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop)
 (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
 (abs_event_create : StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
 (addr_aligned : Z -> Z -> Prop)
 (EventRaw : addr -> Assertion)
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
