#ifndef CRTOS_READY_VIEWS_STRATEGY_H
#define CRTOS_READY_VIEWS_STRATEGY_H
#include "m_ktask.h"
/*@ Import Coq Require Import CRTOS_Verify.libai.RRR_ReadyInsert */
/*@ Import Coq Require Import CRTOS_Verify.libai.ReadyViews */
/*@ Extern Coq
      (task_fields_except_sched : StableGlobalState -> VarGlobalState -> Z -> TaskDescriptorAbs -> Assertion)
      (rrr_ready_bucket_head : Z -> Z -> Z)
      (store_os_assign_ready_vector : Z -> OsAssignReadyVectorAbs -> Assertion)
      (store_ready_dll_tail_frame : Z -> list(DL_Node Z) -> Z -> Assertion)
      (store_ready_dll_head_frame : Z -> list(DL_Node Z) -> Z -> Assertion)
      (store_rrr_vector_except : Z -> Z -> list(DL_Node Z) -> OsAssignReadyVectorAbs -> Assertion)
      (os_assign_ready_vector_replace_bucket : OsAssignReadyVectorAbs -> Z -> list(DL_Node Z) -> OsAssignReadyVectorAbs)
 */
#endif
