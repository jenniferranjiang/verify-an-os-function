#include "m_assign.h"
#include "ktask_unset_delay.h"

// (_)KTaskWakeup is not verfied in this file, since all called point is in critical area, so no need to lock.

/**
 * This function will resume a task. 
 *
 * @param id task id
 *
 */
x_err_t _KTaskWakeup(KTaskDescriptorType task)
{
    x_base lock = 0;

    NULL_PARAM_CHECK_1(task);

    if (RET_TRUE != JudgeKTaskStatIsSuspend(task)) {
        // SYS_KDEBUG_LOG(KDBG_KTASK, ("task stat must be suspend error stat is , %d\n", KTaskStatGet(task)));
        return -ERROR;
    }

    // SYS_KDEBUG_LOG(KDBG_KTASK, ("wakeup task name:  %s\n", task->task_base_info.name));

    lock = CriticalAreaLock();
    
    DoubleLinkListRmNode(&(task->task_dync_sched_member.sched_link));
    KTaskUnSetDelay(task);

    Assign.ready_vector_done->insert(task);

    CriticalAreaUnLock(lock);
	
    // HOOK(hook.task.hook_TaskResume,(task));
    return EOK;
}
