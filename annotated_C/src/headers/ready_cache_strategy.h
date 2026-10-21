#ifndef CRTOS_READY_CACHE_STRATEGY_H
#define CRTOS_READY_CACHE_STRATEGY_H
#include "m_assign.h"
#include "task_sched_view.h"
/*@ Import Coq Require Import CRTOS_Verify.libai.AssignStat */
/*@ Import Coq Require Import CRTOS_Verify.libai.ReadyCacheViews */
/*@ Extern Coq
      (os_assign_ready_vector_replace_bucket : OsAssignReadyVectorAbs -> Z -> list(DL_Node Z) -> OsAssignReadyVectorAbs)
      (store_assign_policy_insert_frame : StableGlobalState -> VarGlobalState -> Z -> Z -> TaskDescriptorAbs -> OsAssignReadyVectorAbs -> list(DL_Node Z) -> Assertion)
      (store_assign_insert_group_frame : StableGlobalState -> VarGlobalState -> Z -> Z -> TaskDescriptorAbs -> OsAssignReadyVectorAbs -> list(DL_Node Z) -> Assertion)
      (assign_policy_insert_ready_vector : OsAssignReadyVectorAbs -> TaskSchedMemberAbs -> list(DL_Node Z) -> OsAssignReadyVectorAbs)
      (store_os_assign_ready_vector : Z -> OsAssignReadyVectorAbs -> Assertion)
      (store_ready_except_highest : Z -> OsAssignReadyVectorAbs -> Assertion)
      (store_ready_except_group : Z -> OsAssignReadyVectorAbs -> Assertion)
      (store_rrr_vector_except : Z -> Z -> list(DL_Node Z) -> OsAssignReadyVectorAbs -> Assertion)
      (store_priority_ready_vector_except : Z -> Z -> list(DL_Node Z) -> list(list(DL_Node Z)) -> Assertion)
      (mkOsAssignReadyVectorAbs : list(list(DL_Node Z)) -> Z -> Z -> OsAssignReadyVectorAbs)
 */
#endif
