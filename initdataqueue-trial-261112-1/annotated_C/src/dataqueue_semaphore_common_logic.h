#ifndef CRTOS_DATAQUEUE_SEMAPHORE_COMMON_LOGIC_H
#define CRTOS_DATAQUEUE_SEMAPHORE_COMMON_LOGIC_H
#include "../../../annotated_C/src/headers/m_semaphore.h"
/* Minimal vocabulary for the active IC contracts only. No C API contract is
 * stored here; unused historical task/delay view adapters are not imported. */
/*@ Import Coq Require Import CRTOS_Verify.lib.id.IdModuleSpec CRTOS_Verify.lib.common.CrtosInv CRTOS_Verify.lib.semaphore.KSemaphoreDelete */
/*@ Import Coq Require Import Logic.LogicGenerator.demo932.Interface */
/*@ Import Coq Require Import InitDataqueueTrial.lib.CrtosRules InitDataqueueTrial.lib.CrtosInv InitDataqueueTrial.lib.DataqueueSemaphore */
/*@ Import Coq Import IDNode DLL MonadErr Monad MonadNotation */
/*@ Extern Coq addr := Z */
/*@ Extern Coq
  (StableGlobalState :: *) (VarGlobalState :: *) (CoreVarGlobalState :: *)
  (StableIdmanager :: *) (VarIdmanager :: *)
  (DL_Node :: * => *) (program :: * => * => *)
  (unit :: *) (bool :: *)
 */
/*@ Extern Coq
  (addr_aligned : Z -> Z -> Prop)
  (ALIGN_SIZE : Z)
  (CharArray::undef_full : Z -> Z -> Assertion)
  (CharArray::full : Z -> Z -> list Z -> Assertion)
  (repeat_Z : {A} -> A -> Z -> list A)
  (store_idnode_insert_ready : Z -> Assertion)
  (store_idmanager : StableIdmanager -> VarIdmanager -> Z -> Assertion)
  (store_idmanager_found : StableIdmanager -> VarIdmanager -> Z -> Z -> Z -> Assertion)
  (idmanager_min_free_id : StableIdmanager -> VarIdmanager -> Z -> Prop)
  (idmanager_add : VarIdmanager -> Z -> VarIdmanager)
  (idmanager_link : StableIdmanager -> VarIdmanager -> Z -> Z -> VarIdmanager)
  (idmanager_query : VarIdmanager -> Z -> bool)
  (idmanager_contains : StableIdmanager -> VarIdmanager -> Z -> Z -> Prop)
  (idmanager_remove : StableIdmanager -> VarIdmanager -> Z -> VarIdmanager)
  (store_node_self_linked : Z -> Assertion)
  (store_dll : {A} -> (Z -> A -> Assertion) -> Z -> list(DL_Node A) -> Assertion)
  (occupy_dll_node : Z -> Assertion)
  (dll_insert_anchor : {A} -> Z -> list(DL_Node A) -> Z -> Prop)
  (dll_insert_after_dispatch : {A} -> Z -> list(DL_Node A) -> Z -> DL_Node A -> list(DL_Node A))
  (Build_DL_Node : {A} -> A -> Z -> DL_Node A)
  (SemaphoreRaw : Z -> Assertion)
  (semaphore_pending_head : Z -> Z)
  (sched_link_node : Z -> DL_Node Z)
  (semaphore_pending_nodes : Z -> CoreVarGlobalState -> list(DL_Node Z) -> Prop)
  (semaphore_resume_all_effect : Z -> list Z -> CoreVarGlobalState -> CoreVarGlobalState -> Prop)
  (map : {A} {B} -> (A -> B) -> list A -> list B)
  (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
  (safeExec : {Sigma} {A} -> (Sigma -> Prop) -> program Sigma A -> (A -> Sigma -> Prop) -> Prop)
  (return : {Sigma} {A} -> A -> program Sigma A)
  (tt : unit)
  (true : bool) (false : bool)
  (abs_ktask_assign : program (CoreVarGlobalState -> Prop) unit)
  (OutsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
  (os_inv : StableGlobalState -> VarGlobalState -> Assertion)
  (InsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
  (Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop)
  (Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop)
  (core_os_inv : StableGlobalState -> CoreVarGlobalState -> Assertion)
  (core_LastSeen : CoreVarGlobalState -> (CoreVarGlobalState -> Prop) -> Prop)
  (core_OutsideCritical : StableGlobalState -> CoreVarGlobalState -> Assertion)
 */
/*@ Printing Coq Name program := MonadErr.M */
/*@ Printing Strategy Name program := MonadErr.M */
/*@ Printing Coq Name safeExec := monadesafe_lib.safeExec */
/*@ Printing Coq Name return := MonadErr.ret */
/*@ Printing Coq Name StableGlobalState := InitDataqueueTrial.lib.CrtosGlobState.StableGlobalState */
/*@ Printing Coq Name VarGlobalState := InitDataqueueTrial.lib.CrtosGlobState.VarGlobalState */
/*@ Printing Coq Name CoreVarGlobalState := InitDataqueueTrial.lib.CrtosGlobState.CoreVarGlobalState */
/*@ Printing Coq Name os_inv := InitDataqueueTrial.lib.CrtosInv.os_inv */
/*@ Printing Coq Name core_os_inv := InitDataqueueTrial.lib.CrtosInv.core_os_inv */
/*@ Printing Coq Name InsideCritical := InitDataqueueTrial.lib.CrtosRules.InsideCritical */
/*@ Printing Coq Name OutsideCritical := InitDataqueueTrial.lib.CrtosRules.OutsideCritical */
/*@ Printing Coq Name LastSeen := InitDataqueueTrial.lib.CrtosRules.LastSeen */
/*@ Printing Coq Name Crtos_RTrans := InitDataqueueTrial.lib.CrtosRules.Crtos_RTrans */
/*@ Printing Coq Name Crtos_GTrans := InitDataqueueTrial.lib.CrtosRules.Crtos_GTrans */
/*@ Printing Coq Name core_OutsideCritical := InitDataqueueTrial.lib.CrtosRules.core_OutsideCritical */
/*@ Printing Coq Name core_LastSeen := InitDataqueueTrial.lib.CrtosRules.core_LastSeen */
#endif
