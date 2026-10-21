#ifndef TASK_STAT_VIEW_STRATEGY_H
#define TASK_STAT_VIEW_STRATEGY_H

#include "task_id_view.h"

/*@ Extern Coq
      (task_fields_except_sched : StableGlobalState -> VarGlobalState -> Z -> TaskDescriptorAbs -> Assertion)
      (store_assign_insert_sched_except_stat : Z -> TaskSchedMemberAbs -> Assertion)
      (store_ktask_suspend_sched_stat_frame :
        StableGlobalState -> VarGlobalState -> Z -> TaskDescriptorAbs -> Assertion)
 */

#endif
