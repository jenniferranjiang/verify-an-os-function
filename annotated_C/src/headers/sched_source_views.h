#ifndef CRTOS_SCHED_SOURCE_VIEWS_H
#define CRTOS_SCHED_SOURCE_VIEWS_H
#include "m_ktask.h"
/*@ Import Coq Require Import CRTOS_Verify.libai.SchedNodeCases */
/*@ Extern Coq (dll_node_source :: *) */
/*@ Extern Coq
 (In : {A} -> A -> list A -> Prop)
 (dll_detached : dll_node_source)
 (dll_linked : Z -> list(DL_Node Z) -> list(DL_Node Z) -> dll_node_source)
 (suspend_source_facts : StableGlobalState -> VarGlobalState -> Z -> Prop)
 (suspend_source_restore : (Z -> option TaskDescriptorAbs) -> (Z -> option TaskDescriptorAbs) -> StableGlobalState -> VarGlobalState -> Z -> dll_node_source -> Assertion)
 (suspend_sched_pool : (Z -> option TaskDescriptorAbs) -> StableGlobalState -> VarGlobalState -> Assertion)
 (suspend_unlink_state : Z -> VarGlobalState -> VarGlobalState)
 (pure_suspend_sched_link : (Z -> option TaskDescriptorAbs) -> Z -> Z -> Assertion)
 */
#endif
