#ifndef CRTOS_TASK_SCHED_VIEW_H
#define CRTOS_TASK_SCHED_VIEW_H
#include "m_ktask.h"
/*@ Import Coq Require Import CRTOS_Verify.libai.TaskOwnedMemoryLemmas */
/*@ Import Coq Require Import CRTOS_Verify.libai.TaskSchedViews */
/*@ Import Coq Require Import CRTOS_Verify.libai.AssignInCritical */
/*@ Extern Coq
      (store_assign_remove_sched_frame : Z -> TaskSchedMemberAbs -> Assertion)
      (task_fields_except_sched : StableGlobalState -> VarGlobalState -> Z -> TaskDescriptorAbs -> Assertion)
      (store_task_sched_except_cur_prio : Z -> TaskSchedMemberAbs -> Assertion)
      (store_task_sched_except_bitmap_column : Z -> TaskSchedMemberAbs -> Assertion)
      (store_task_sched_except_advance_cnt : Z -> TaskSchedMemberAbs -> Assertion)
 */
#endif
