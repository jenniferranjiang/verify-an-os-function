#ifndef CRTOS_WAKEUP_VIEWS_H
#define CRTOS_WAKEUP_VIEWS_H
#include "sched_source_views.h"
#include "ktask_unset_delay.h"
#include "ktask_assign_oc.h"
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskWakeupViews */
/*@ Extern Coq
 (wakeup_global_frame : StableGlobalState -> VarGlobalState -> Assertion)
 (assign_insert_step_ic : (Z -> option TaskDescriptorAbs) -> Z -> TaskDescriptorAbs -> OsAssignReadyVectorAbs -> OsAssignReadyVectorAbs -> Prop)
 (wakeup_state : VarGlobalState -> Z -> TaskDescriptorAbs -> OsAssignReadyVectorAbs -> VarGlobalState)
 (set_task_desc_ready : TaskDescriptorAbs -> TaskDescriptorAbs)
 (update_task_desc_map : Z -> TaskDescriptorAbs -> (Z -> option TaskDescriptorAbs) -> Z -> option TaskDescriptorAbs)
 (ktask_wakeup_step : Z -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop)
 */
#endif
