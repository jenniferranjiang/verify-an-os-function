/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/semaphore.c; SHA-256 d5b41c3bde69e0416431d2425c61e35453778ae4b1569747f2c2258f3dfe16ec.
 * User-approved trial-only zero-timeout repair; source-processing copy, no formal spec or VC.
 * Only the approved timeout selection is changed; other source adaptation remains pending.
 */
#include <xizi.h>

static int32 _SemaphoreObtain(int32 id, int32 msec)
{
    int lock = 0;
    int32  wait_time = 0;
    struct TaskDescriptor *task = NONE;
    struct Semaphore *sem = NONE;
    struct IdNode *idnode = NONE;

    if (id < 0)
        return -ERROR;
    /* User-approved trial-only zero-timeout fix. Original selection:
    if(WAITING_FOREVER == msec)
        wait_time = WAITING_FOREVER;
    else
        wait_time = CalculateTickFromTimeMs(msec);
    */
    if (msec == 0)
        wait_time = 0;
    else if(WAITING_FOREVER == msec)
        wait_time = WAITING_FOREVER;
    else
        wait_time = CalculateTickFromTimeMs(msec);
    lock = CriticalAreaLock();
    idnode = IdGetObj(&k_sem_id_manager, id);
    if (idnode == NONE) {
        CriticalAreaUnLock(lock);
        return -ERROR;
    }
    sem = CONTAINER_OF(idnode, struct Semaphore, id);

    SYS_KDEBUG_LOG(KDBG_IPC, ("obtain semaphore: id %d, value %d, by task %s\n",
            (int)sem->id.id, (int)sem->value, GetKTaskDescriptor()->task_base_info.name));

    if (sem->value > 0) {
        sem->value--;
        CriticalAreaUnLock(lock);
        return EOK;
    }

    if (wait_time == 0) {
        CriticalAreaUnLock(lock);
        return -ETIMEOUT;
    }

    task = GetKTaskDescriptor();
    task->exstatus = EOK;

    SYS_KDEBUG_LOG(KDBG_IPC, ("obtain semaphore: suspending task %s\n",
            GetKTaskDescriptor()->task_base_info.name));

    LinklistSuspend(&sem->pend_list, task, LINKLIST_FLAG_PRIO);

    if (wait_time > 0) {
         KTaskSetDelay(task, wait_time);
    }

    CriticalAreaUnLock(lock);


    DO_KTASK_ASSIGN;

    return task->exstatus;
}
