static int32 _MutexObtain(struct Mutex *mutex, int32 msec)
{
    x_base lock = 0;
    int32  wait_time = 0;
    struct TaskDescriptor *task = NONE;

    NULL_PARAM_CHECK(mutex);

    task = GetKTaskDescriptor();
    wait_time = CalculateTickFromTimeMs(msec);
    lock = CriticalAreaLock();

    SYS_KDEBUG_LOG(KDBG_IPC,
                 ("mutex_take: current task %s, mutex value: %d, hold: %d\n",
                  task->task_base_info.name, mutex->val, mutex->recursive_cnt));

    task->exstatus = EOK;

    if (mutex->holder == task) {
        mutex->recursive_cnt++;
    } else {
        if (mutex->val > 0) {
            mutex->val--;
            mutex->holder = task;
            mutex->origin_prio = task->task_dync_sched_member.cur_prio;
            mutex->recursive_cnt++;
        } else {
            if (wait_time == 0) {
               task->exstatus = -ETIMEOUT;
                CriticalAreaUnLock(lock);
                return -ETIMEOUT; 
            } else {
                SYS_KDEBUG_LOG(KDBG_IPC, ("mutex_take: suspend task: %s\n",
                                            task->task_base_info.name));

                /* pending task is removed from ready list,
                   so it wont affect the mutex holder;
                   if holder is stucked by others with higher priorities,
                   try fix this by design, instead of mutex.
                   Warning: dont use KTaskPrioSet, for it's bugged.
                 */
                // if (task->task_dync_sched_member.cur_prio > mutex->holder->task_dync_sched_member.cur_prio)
                // {
                //     KTaskPrioSet(mutex->holder->id.id, task->task_dync_sched_member.cur_prio);
                // }

                LinklistSuspend(&(mutex->pend_list), task, LINKLIST_FLAG_PRIO);

                if (wait_time > 0) {
                    SYS_KDEBUG_LOG(KDBG_IPC,
                                 ("mutex_take: start the timer of task:%s\n",
                                  task->task_base_info.name));
                    KTaskSetDelay(task,wait_time);
                }

                CriticalAreaUnLock(lock);

                DO_KTASK_ASSIGN;

                if (task->exstatus != EOK) {
                    return task->exstatus;
                } else {
                    lock = CriticalAreaLock();
                }
            }
        }
    }

    CriticalAreaUnLock(lock);

    return EOK;
}

static int32 _MutexAbandon(struct Mutex *mutex)
{
    int resched = 0;
    x_base lock = 0;
    struct TaskDescriptor *task = NONE;

    NULL_PARAM_CHECK(mutex);

    task = GetKTaskDescriptor();
    lock = CriticalAreaLock();

    SYS_KDEBUG_LOG(KDBG_IPC,
                 ("mutex_release:current task %s, mutex value: %d, hold: %d\n",
                  task->task_base_info.name, mutex->val, mutex->recursive_cnt));

    if (task != mutex->holder) {
        task->exstatus = -ERROR;
        CriticalAreaUnLock(lock);
        return -ERROR;
    }

    mutex->recursive_cnt --;
    if (mutex->recursive_cnt == 0) {
        // if (mutex->origin_prio != mutex->holder->task_dync_sched_member.cur_prio)
        // {
        //     KTaskPrioSet(mutex->holder->id.id, mutex->origin_prio);
        // }

        if (!IsDoubleLinkListEmpty(&mutex->pend_list)) {
            task = SYS_DOUBLE_LINKLIST_ENTRY(mutex->pend_list.node_next, struct TaskDescriptor, task_dync_sched_member.sched_link);
            SYS_KDEBUG_LOG(KDBG_IPC, ("mutex_release: resume task: %s\n",
                                        task->task_base_info.name));

            mutex->holder             = task;
            mutex->origin_prio = task->task_dync_sched_member.cur_prio;
            mutex->recursive_cnt++;

            LinklistResume(&(mutex->pend_list));

            resched = RET_TRUE;
        } else {
            mutex->val++;
            mutex->holder = NONE;
            mutex->origin_prio = 0xff;
        }
    }

    CriticalAreaUnLock(lock);

    if (resched == RET_TRUE)
        DO_KTASK_ASSIGN;

    return EOK;
}

int32 KMutexObtain(int32 id, int32 msec)
{
    KDEBUG_IN_KTASK_CONTEXT;

    x_base lock = 0;
    struct Mutex *mutex = NONE;
    struct IdNode *idnode = NONE;

    if (id < 0)
        return -ERROR;

    lock = CriticalAreaLock();
    idnode = IdGetObj(&k_mutex_id_manager, id);
    if (idnode == NONE){
        CriticalAreaUnLock(lock);
        return -ERROR;
    }
        

    mutex =CONTAINER_OF(idnode, struct Mutex, id);
    CriticalAreaUnLock(lock);

    return done.MutexObtain(mutex, msec);
}
