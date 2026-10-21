#ifndef CRTOS_TASK_EXSTATUS_VIEW_H
#define CRTOS_TASK_EXSTATUS_VIEW_H
#include "m_ktask.h"
/*@ Import Coq Require Import CRTOS_Verify.libai.TaskExstatusView */
/*@ Extern Coq
 (task_fields_exstatus_frame : StableGlobalState -> VarGlobalState -> Z -> TaskDescriptorAbs -> Assertion)
 (replace_descriptor_exstatus : Z -> TaskDescriptorAbs -> TaskDescriptorAbs)
 (update_task_desc_map : Z -> TaskDescriptorAbs -> (Z -> option TaskDescriptorAbs) -> Z -> option TaskDescriptorAbs)
 */
#endif
