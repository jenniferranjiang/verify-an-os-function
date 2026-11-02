#ifndef CRTOS_TIMEOUT_VIEWS_H
#define CRTOS_TIMEOUT_VIEWS_H

#include "sched_source_views.h"
#include "ktask_assign_oc.h"
#include "task_exstatus_view.h"
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskTimeoutViews */
/*@ Extern Coq
 (timeout_global_frame : StableGlobalState -> VarGlobalState -> Assertion)
 (ktask_timeout_body : Z -> program (VarGlobalState -> Prop) unit)
 (ktask_timeout_descriptor : TaskDescriptorAbs -> TaskDescriptorAbs)
 (ktask_timeout_state : VarGlobalState -> Z -> TaskDescriptorAbs -> OsAssignReadyVectorAbs -> VarGlobalState)
 (abs_ktask_timeout : StableGlobalState -> Z -> program (VarGlobalState -> Prop) unit)
 (set_task_desc_ready : TaskDescriptorAbs -> TaskDescriptorAbs)
 (update_task_desc_map : Z -> TaskDescriptorAbs -> (Z -> option TaskDescriptorAbs) -> Z -> option TaskDescriptorAbs)
 (assign_insert_step_ic : (Z -> option TaskDescriptorAbs) -> Z -> TaskDescriptorAbs -> OsAssignReadyVectorAbs -> OsAssignReadyVectorAbs -> Prop)
 */

#endif
