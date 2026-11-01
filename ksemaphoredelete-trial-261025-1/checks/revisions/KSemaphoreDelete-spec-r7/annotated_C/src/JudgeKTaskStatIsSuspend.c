#include "../include/slice_types.h"
#include "../include/logic.h"

/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask_stat.c. Current 32-bit non-SMP configuration. */


BOOL JudgeKTaskStatIsSuspend(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure ((__return == 1 && old_stat == TSK_SUSPEND) ||
            (__return == 0 && old_stat != TSK_SUSPEND)) &&
           store_task_status(&(task->task_dync_sched_member.stat), old_stat)
*/
{
    if (task == NONE) { while (1) { } }
    return ((task->task_dync_sched_member.stat & KTASK_STAT_MASK) == KTASK_SUSPEND);
}
