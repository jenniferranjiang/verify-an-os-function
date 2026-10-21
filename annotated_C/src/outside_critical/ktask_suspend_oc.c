
#include "m_assign.h"
#include "ktask_unset_delay.h"

/**
 * This function will suspend a task.
 *
 * @param id task id
 *
 */
x_err_t _SuspendKTask(KTaskDescriptorType task)
{
    x_base lock = 0;

    NULL_PARAM_CHECK_1(task);

    if (task != GetKTaskDescriptor()) {
        // SYS_KDEBUG_LOG(KDBG_KTASK, ("running task is forbidden to suspend the others.\n"));
        return -ERROR;
    }
    
    if(RET_TRUE != JudgeKTaskStatIsReady(task) && RET_TRUE != JudgeKTaskStatIsRunning(task)) {
        // SYS_KDEBUG_LOG(KDBG_KTASK, ("task stat  0x%2x is forbidden to suspend.\n", KTaskStatGet(task)));
        return -ERROR;
    }

    if(RET_TRUE == JudgeKTaskStatIsSuspend(task)) {
        // SYS_KDEBUG_LOG(KDBG_KTASK, ("task stat is already suspend.\n"));
        return -ERROR;
    }

    // SYS_KDEBUG_LOG(KDBG_KTASK, ("suspend task name:  %s\n", task->task_base_info.name));

    lock = CriticalAreaLock();

    Assign.ready_vector_done->remove(task);

    KTaskStateSet(task, KTASK_SUSPEND);
    KTaskUnSetDelay(task);

    CriticalAreaUnLock(lock);

    // HOOK(hook.task.hook_TaskSuspend,(task));
    return EOK;
}

/**
 * This function will suspend a task.
 *
 * @param id task id
 *
 * @return EOK
 */
x_err_t SuspendKTask(int32 id)
{
    struct TaskDescriptor *task = NONE;

    task = GetTaskWithIdnodeInfo(id);
    NULL_PARAM_CHECK_1(task);

    return task->Done->suspend(task);
}
