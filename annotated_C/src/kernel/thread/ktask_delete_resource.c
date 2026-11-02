#include "ktask_delete_resource.h"
#include "ktask_set_status.h"
#include "task_descriptor_status.h"
/*@ include strategies "task_descriptor_status.strategies" */

/* 与 ktask_delete.c 中的 helper 使用同一个可执行函数体；此切片只验证
 * 已获授权的被调函数，外层 _DeleteKTask 仍处于规格设计阶段。 */
static inline void _KTaskResourceDelete(struct TaskDescriptor *task)
/*@ resource_delete_local_ic */
{
    NULL_PARAM_CHECK_1(task);
    /*@ Branch name ready: kind == 0; detached: kind == 1; external: kind == 2 */
    KTaskOsAssignRemoveKTask(task)
      /*@ where (linked_ic) desc=desc, before=before $ ready
          where (detached_ic) desc=desc, before=before $ detached
          where (external_list_ic) desc=desc, before=before,
            storeA=storeA, head=head, l=nodes $ external */;
    KTaskStatSetAsClose(task);
    return;
}
