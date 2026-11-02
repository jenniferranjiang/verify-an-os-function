#ifndef CRTOS_ZOMBIE_VIEWS_H
#define CRTOS_ZOMBIE_VIEWS_H
#include "ktask_zombie_nonempty.h"
extern int32 zombie_recycle;
/*@ Import Coq Require Import CRTOS_Verify.libai.ZombieViews */
/*@ Extern Coq (ServiceSlotAbs :: *) */
/*@ Extern Coq
  (zombie_queue : VarGlobalState -> ZombieQueueAbs)
  (os_recycle : VarGlobalState -> ServiceSlotAbs)
  (service_id : ServiceSlotAbs -> Z)
  (os_zombie_queue_frame : StableGlobalState -> VarGlobalState -> Assertion)
  (os_recycler_id_frame : StableGlobalState -> VarGlobalState -> Assertion)
 */
#endif
