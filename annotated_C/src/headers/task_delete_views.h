#ifndef CRTOS_TASK_DELETE_VIEWS_H
#define CRTOS_TASK_DELETE_VIEWS_H

#include "ktask_delete_resource.h"
#include "ktask_zombie_nonempty.h"
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskDeleteRestore */
/*@ Extern Coq (ServiceSlotAbs :: *) */
/*@ Extern Coq
  (os_recycle : VarGlobalState -> ServiceSlotAbs)
  (zombie_queue : VarGlobalState -> ZombieQueueAbs)
  (ktask_delete_not_service : Z -> VarGlobalState -> Prop)
  (ktask_delete_enqueue_transition : Z -> VarGlobalState -> VarGlobalState -> Prop)
  (delete_outer_frame : StableGlobalState -> VarGlobalState -> Z -> TaskDescriptorAbs -> Assertion)
  (delete_enqueue_restore : StableGlobalState -> VarGlobalState -> VarGlobalState -> Z -> list(DL_Node Z) -> Assertion)
  (pure_close_sched_link : (Z -> option TaskDescriptorAbs) -> Z -> Z -> Assertion)
 */

#endif
