#ifndef CRTOS_TASK_DESCRIPTOR_STATUS_H
#define CRTOS_TASK_DESCRIPTOR_STATUS_H

#include "task_sched_view.h"
#include "ktask_set_status.h"

/*@ Import Coq Require Import CRTOS_Verify.libai.TaskDescriptorStatus */
/*@ Extern Coq
      (task_descriptor_status_frame : Z -> TaskDescriptorAbs -> Assertion)
      (set_sched_member_status : TaskSchedMemberAbs -> TaskStatus -> TaskSchedMemberAbs)
      (update_sched_member : TaskDescriptorAbs -> TaskSchedMemberAbs -> TaskDescriptorAbs)
 */
/*@ include strategies "task_descriptor_status.strategies" */

#endif
