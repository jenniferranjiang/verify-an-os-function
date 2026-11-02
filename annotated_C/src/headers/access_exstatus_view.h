#ifndef CRTOS_ACCESS_EXSTATUS_VIEW_H
#define CRTOS_ACCESS_EXSTATUS_VIEW_H

#include "m_assign.h"
#include "task_exstatus_view.h"

/*@ Import Coq Require Import CRTOS_Verify.libai.AccessExstatus */
/*@ Extern Coq
      (assign_inv : StableGlobalState -> VarGlobalState -> Assertion)
      (exstatus_inv : StableGlobalState -> VarGlobalState -> Assertion)
      (os_exstatus_slot : StableGlobalState -> Z)
      (os_exstatus : VarGlobalState -> Z)
      (assign_running_frame : StableGlobalState -> VarGlobalState -> Assertion)
      (task_inv_exstatus_frame : StableGlobalState -> VarGlobalState -> Z -> TaskDescriptorAbs -> Assertion)
      (exstatus_slot : StableGlobalState -> VarGlobalState -> Z -> Prop)
      (kupdate_exstatus_step : Z -> VarGlobalState -> VarGlobalState -> Prop)
 */

#endif
