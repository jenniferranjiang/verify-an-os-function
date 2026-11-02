#ifndef CRTOS_SUSPEND_VIEWS_H
#define CRTOS_SUSPEND_VIEWS_H
#include "critical_views_strategy.h"
#include "critical_task_view.h"
#include "task_stat_view.h"
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskSuspend */
/*@ Import Coq Require Import CRTOS_Verify.libai.AssignCommon */
/*@ Extern Coq
 (OsAssignReadyVectorAbs :: *)
 */
/*@ Extern Coq
 (ktask_suspend_step : Z -> VarGlobalState -> Z -> VarGlobalState -> Prop)
 (ktask_suspend_frame : StableGlobalState -> VarGlobalState -> Z -> Assertion)
 (assign_remove_running_ready : Z -> TaskDescriptorAbs -> OsAssignReadyVectorAbs -> OsAssignReadyVectorAbs -> Prop)
 (ktask_suspend_state : VarGlobalState -> Z -> TaskDescriptorAbs -> OsAssignReadyVectorAbs -> VarGlobalState)
 (ktask_suspend_sched_step : Z -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop)
 (store_os_assign_ready_vector : Z -> OsAssignReadyVectorAbs -> Assertion)
 (store_prio_lookup_table : Assertion)
 (sched_link_of : Z -> Z)
 (sched_link_node : Z -> DL_Node Z)
 (store_node_self_linked : Z -> Assertion)
 (set_sched_member_status : TaskSchedMemberAbs -> TaskStatus -> TaskSchedMemberAbs)
 (update_sched_member : TaskDescriptorAbs -> TaskSchedMemberAbs -> TaskDescriptorAbs)
 */
/*@ include strategies "suspend_views.strategies" */
/*@ include strategies "task_stat_view.strategies" */
#endif
