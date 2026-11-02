#ifndef CRTOS_TASK_CREATE_STRATEGY_H
#define CRTOS_TASK_CREATE_STRATEGY_H
#include "ktask_create.h"
#include "critical_task_view.h"
/*@ Extern Coq (TaskDoneAbs :: *) */
/*@ Extern Coq
      (store_zeroed_task_descriptor : Z -> Assertion)
      (store_ktask_create_private_zeroed : Z -> Assertion)
      (store_ktask_create_init_frame : Z -> Assertion)
      (store_ktask_create_init_failure_private : Z -> TaskStatus -> Z -> Assertion)
      (store_task_descriptor_free_ready : Z -> TaskStatus -> Assertion)
      (store_ktask_create_shared_open : StableGlobalState -> VarGlobalState -> Assertion)
      (pure_task_link_member : Z -> Z -> Assertion)
      (store_published_task : Z -> TaskDescriptorAbs -> Assertion)
      (store_task_done : Z -> TaskDoneAbs -> Assertion)
      (task_done_ptr : TaskStable -> Z)
      (task_done_abs : TaskStable -> TaskDoneAbs)
      (task_link_nodes : list Z -> list(DL_Node Z))
      (store_map : {A} {B} -> (A -> B -> Assertion) -> (A -> option B) -> Assertion)
 */
#endif
