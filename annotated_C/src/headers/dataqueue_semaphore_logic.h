#ifndef CRTOS_DATAQUEUE_SEMAPHORE_LOGIC_H
#define CRTOS_DATAQUEUE_SEMAPHORE_LOGIC_H
#include "m_semaphore.h"
/* Native shared predicates: vocabulary only; contracts remain in each C file.
 * Source: /home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_sem.h; SHA-256 c2c6edfde22823863a655d6d2a3f59fb749085a8b426166c885c2d5354174fab.
 * Source: /home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_assign.h; SHA-256 939b9f9b498ef33a02863dd0063220017610364f423e36c93a9be7c66848a472.
 * Source: /home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_static_objects.h; SHA-256 7299746e499097857ca3a2f0fbb67352fba9f4efbb94c7b52280b998d61d1576.
 * Selected annotated_C/src/include/xsconfig.h leaves KERNEL_DEFER_IPC_SCHED
 * and KERNEL_STATIC_OBJECTS undefined: ON_WAKE uses DO_KTASK_ASSIGN and
 * lifecycle-check macros are empty. Other configurations require new review. */
/*@ Import Coq Require Import CRTOS_Verify.lib.semaphore.KSemaphoreDelete */
/*@ Import Coq Require Import CRTOS_Verify.lib.id.idnode CRTOS_Verify.lib.id.IdModuleSpec CRTOS_Verify.lib.common.dll CRTOS_Verify.lib.list.NodeSelfLinked */
/*@ Import Coq Import IDNode DLL */
#ifndef CRTOS_DATAQUEUE_COQ_OPTION
#define CRTOS_DATAQUEUE_COQ_OPTION
/*@ Extern Coq
  (option :: * => *)
*/
/*@ Extern Coq
  (Some : {A} -> A -> option A) (None : {A} -> option A)
*/
#endif
/*@ Extern Coq addr := Z */
/*@ Extern Coq Record StableIdmanager { idmax: Z; hoffset: Z; id_map: Z; htable: Z; } */
/*@ Extern Coq
  (VarIdmanager :: *) (IdNodeAbs :: *) (DL_Node :: * => *)
*/
/*@ Extern Coq
  (store_idmanager : StableIdmanager -> VarIdmanager -> Z -> Assertion)
  (Build_IdNodeAbs : Z -> Z -> IdNodeAbs)
  (store_idmanager_allocated_unlinked : StableIdmanager -> VarIdmanager -> Z -> Z -> Assertion)
  (store_idmanager_remove_ready : StableIdmanager -> VarIdmanager -> Z -> Z -> Z -> Assertion)
  (store_idmanager_removeobj_post : StableIdmanager -> VarIdmanager -> Z -> Z -> Z -> Assertion)
  (store_idnode_unlinked : Z -> IdNodeAbs -> Assertion)
  (idmanager_first_free_id : StableIdmanager -> VarIdmanager -> option Z)
  (store_idmanager_found : StableIdmanager -> VarIdmanager -> Z -> Z -> Z -> Assertion)
  (store_idnode_insert_ready : Z -> Assertion)
  (idmanager_min_free_id : StableIdmanager -> VarIdmanager -> Z -> Prop)
  (idmanager_add : VarIdmanager -> Z -> VarIdmanager)
  (idmanager_link : StableIdmanager -> VarIdmanager -> Z -> Z -> VarIdmanager)
  (idmanager_query : VarIdmanager -> Z -> bool)
  (idmanager_contains : StableIdmanager -> VarIdmanager -> Z -> Z -> Prop)
  (idmanager_remove : StableIdmanager -> VarIdmanager -> Z -> VarIdmanager)
  (store_node_self_linked : Z -> Assertion)
  (occupy_dll_node : Z -> Assertion)
  (store_dll : {A} -> (Z -> A -> Assertion) -> Z -> list(DL_Node A) -> Assertion)
  (Build_DL_Node : {A} -> A -> Z -> DL_Node A)
  (dll_insert_anchor : {A} -> Z -> list(DL_Node A) -> Z -> Prop)
  (dll_insert_after_dispatch : {A} -> Z -> list(DL_Node A) -> Z -> DL_Node A -> list(DL_Node A))
  (map : {A} {B} -> (A -> B) -> list A -> list B)
  (app : {A} -> list A -> list A -> list A)
  (semaphore_pending_head : Z -> Z)
  (sched_link_node : Z -> DL_Node Z)
  (semaphore_pending_nodes_ic : Z -> VarGlobalState -> list(DL_Node Z) -> Prop)
  (semaphore_resume_all_ic_effect : Z -> list Z -> VarGlobalState -> VarGlobalState -> Prop)
  (abs_ktask_assign : program (VarGlobalState -> Prop) unit)
*/
/*@ Printing Coq Name semaphore_pending_nodes_ic := CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_pending_nodes_ic */
/*@ Printing Coq Name semaphore_resume_all_ic_effect := CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_resume_all_ic_effect */
/*@ Printing Coq Name abs_ktask_assign := CRTOS_Verify.lib.assign.KTaskOsAssign.abs_ktask_assign */
/*@ Printing Coq Name store_idmanager := CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager */
/*@ Printing Coq Name store_idmanager_allocated_unlinked := CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager_allocated_unlinked */
/*@ Printing Coq Name store_idmanager_remove_ready := CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager_remove_ready */
/*@ Printing Coq Name store_idmanager_removeobj_post := CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager_removeobj_post */
/*@ Printing Coq Name store_idnode_unlinked := CRTOS_Verify.lib.id.idnode.IDNode.store_idnode_unlinked */
/*@ Printing Coq Name store_idmanager_found := CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager_found */
/*@ Printing Coq Name store_idnode_insert_ready := CRTOS_Verify.lib.id.idnode.IDNode.store_idnode_insert_ready */
/*@ Printing Coq Name occupy_dll_node := CRTOS_Verify.lib.common.dll.DLL.occupy_dll_node */
/*@ Printing Coq Name store_dll := CRTOS_Verify.lib.common.dll.DLL.store_dll */
/*@ Printing Coq Name store_node_self_linked := CRTOS_Verify.lib.list.NodeSelfLinked.store_node_self_linked */
/*@ Printing Coq Name idmanager_min_free_id := CRTOS_Verify.lib.id.idnode.IDNode.idmanager_min_free_id */
/*@ Printing Coq Name idmanager_first_free_id := CRTOS_Verify.lib.id.idnode.IDNode.idmanager_first_free_id */
/*@ Printing Coq Name idmanager_remove := CRTOS_Verify.lib.id.idnode.IDNode.idmanager_remove */
/*@ Printing Coq Name idmanager_add := CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add */
/*@ Printing Coq Name idmanager_link := CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link */
/*@ Printing Coq Name idmanager_query := CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query */
/*@ Printing Coq Name idmanager_contains := CRTOS_Verify.lib.id.IdModuleSpec.idmanager_contains */
/*@ Printing Coq Name StableIdmanager := CRTOS_Verify.lib.id.idnode_abs.StableIdmanager */
/*@ Printing Coq Name VarIdmanager := CRTOS_Verify.lib.id.idnode_abs.VarIdmanager */
/*@ Printing Coq Name IdNodeAbs := CRTOS_Verify.lib.id.idnode_abs.IdNodeAbs */
/*@ Printing Coq Name Build_IdNodeAbs := CRTOS_Verify.lib.id.idnode_abs.Build_IdNodeAbs */
/*@ Printing Coq Name DL_Node := CRTOS_Verify.lib.common.dll_abs.DL_Node */
/*@ Printing Coq Name Build_DL_Node := CRTOS_Verify.lib.common.dll_abs.Build_DL_Node */
/*@ Printing Coq Name dll_insert_anchor := CRTOS_Verify.lib.list.DoubleLinkListSpec.dll_insert_anchor */
/*@ Printing Coq Name dll_insert_after_dispatch := CRTOS_Verify.lib.list.DoubleLinkListSpec.dll_insert_after_dispatch */
#endif
