#include "../include/slice_types.h"
#include "../include/logic.h"

/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask_stat.c. Current 32-bit non-SMP configuration. */
void KTaskStateSet(KTaskDescriptorType task, uint8 stat)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure  store_task_status(&(task->task_dync_sched_member.stat), decode_task_status(stat))
*/;

void KTaskStatSetAsReady(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure  store_task_status(&(task->task_dync_sched_member.stat), TSK_READY)
*/
{
    if (task == NONE) { while (1) { } }
	KTaskStateSet(task, KTASK_READY) /*@ where old_stat = old_stat */;
}
