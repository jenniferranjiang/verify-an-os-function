void InitDoubleLinkList(DoubleLinklistType *linklist_head)
{
    linklist_head->node_next = linklist_head;
    linklist_head->node_prev = linklist_head;
}

void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
{
    linklist->node_next->node_prev = linklist_node;
    linklist_node->node_next = linklist->node_next;

    linklist->node_next = linklist_node;
    linklist_node->node_prev = linklist;
}

void DoubleLinkListInsertNodeBefore(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
{
    linklist->node_prev->node_next = linklist_node;
    linklist_node->node_prev = linklist->node_prev;

    linklist->node_prev = linklist_node;
    linklist_node->node_next = linklist;
}

void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
{
    linklist_node->node_next->node_prev = linklist_node->node_prev;
    linklist_node->node_prev->node_next = linklist_node->node_next;

    linklist_node->node_next = linklist_node;
    linklist_node->node_prev = linklist_node;
}

int IsDoubleLinkListEmpty(const DoubleLinklistType *linklist)
{
    return linklist->node_next == linklist;
}

x_base CriticalAreaLock(void) {
    x_base lock;

    lock = DISABLE_INTERRUPT();

    KTaskOsAssignLockNest ++;

    return lock;
}

void CriticalAreaUnLock(x_base lock) {
    if (KTaskOsAssignLockNest >= 1) {
        KTaskOsAssignLockNest --;
    }

    ENABLE_INTERRUPT(lock);
}

x_err_t KTaskSetDelay(KTaskDescriptorType task, x_ticks_t ticks)
{
	x_base lock = 0;
    struct Delay *delay = NONE;
    struct Delay *dnode = NONE;
    DoubleLinklistType *nodelink = NONE;

    NULL_PARAM_CHECK(task);

    if (task->task_dync_sched_member.delay == NONE) {
	   delay = (struct Delay *)x_malloc(sizeof(struct Delay));
       if (delay == NONE)
       {
           return -ENOMEMORY;
       }
       memset(delay, 0x0, sizeof(struct Delay));
       task->task_dync_sched_member.delay = delay;
    } else {
        delay = task->task_dync_sched_member.delay;
        lock = CriticalAreaLock();
        if(delay->status == TASK_DELAY_ACTIVE){
            delay->status = TASK_DELAY_INACTIVE;
            DoubleLinkListRmNode(&(delay->link));
        }
        CriticalAreaUnLock(lock);
    }

	delay->ticks = CurrentTicksGain() + ticks;
    delay->task = task;
    delay->status = TASK_DELAY_ACTIVE;

	lock = CriticalAreaLock();
    DOUBLE_LINKLIST_FOR_EACH(nodelink, &xiaoshan_delay_head) {
        dnode =CONTAINER_OF(nodelink, struct Delay, link);
        if (delay->ticks < dnode->ticks) {
            DoubleLinkListInsertNodeBefore(nodelink, &delay->link);

            break;
        }
    }

    if (nodelink == &xiaoshan_delay_head) {
        DoubleLinkListInsertNodeBefore(&xiaoshan_delay_head, &(delay->link));
    }

    CriticalAreaUnLock(lock);

	return EOK;
}

x_err_t KTaskUnSetDelay(KTaskDescriptorType task)
{
	x_base lock = 0;
    struct Delay *delay = NONE;

	NULL_PARAM_CHECK(task);

	delay = task->task_dync_sched_member.delay;
   
	if( delay != NONE && delay->status == TASK_DELAY_ACTIVE) {
	    lock = CriticalAreaLock();
        delay->status = TASK_DELAY_INACTIVE;
        DoubleLinkListRmNode(&(delay->link));
        CriticalAreaUnLock(lock);
	}

	return EOK;
}

x_err_t _SuspendKTask(KTaskDescriptorType task)
{
    x_base lock = 0;

    NULL_PARAM_CHECK(task);

    if (task != GetKTaskDescriptor()) {
        SYS_KDEBUG_LOG(KDBG_KTASK, ("running task is forbidden to suspend the others.\n"));
        return -ERROR;
    }
    
    if(RET_TRUE != JudgeKTaskStatIsReady(task) && RET_TRUE != JudgeKTaskStatIsRunning(task)) {
        SYS_KDEBUG_LOG(KDBG_KTASK, ("task stat  0x%2x is forbidden to suspend.\n", KTaskStatGet(task)));
        return -ERROR;
    }

    if(RET_TRUE == JudgeKTaskStatIsSuspend(task)) {
        SYS_KDEBUG_LOG(KDBG_KTASK, ("task stat is already suspend.\n"));
        return -ERROR;
    }

    SYS_KDEBUG_LOG(KDBG_KTASK, ("suspend task name:  %s\n", task->task_base_info.name));

    lock = CriticalAreaLock();
#ifdef ARCH_SMP
    HwLockSpinlock(&AssignSpinLock);
#endif
    Assign.ready_vector_done->remove(task);
#ifdef ARCH_SMP
    HwUnlockSpinlock(&AssignSpinLock);
#endif
    KTaskStateSet(task, KTASK_SUSPEND);
    KTaskUnSetDelay(task);

    CriticalAreaUnLock(lock);

    HOOK(hook.task.hook_TaskSuspend,(task));
    return EOK;
}

x_err_t _KTaskWakeup(KTaskDescriptorType task)
{
    x_base lock = 0;

    NULL_PARAM_CHECK(task);

    if (RET_TRUE != JudgeKTaskStatIsSuspend(task)) {
        SYS_KDEBUG_LOG(KDBG_KTASK, ("task stat must be suspend error stat is , %d\n", KTaskStatGet(task)));
        return -ERROR;
    }

    SYS_KDEBUG_LOG(KDBG_KTASK, ("wakeup task name:  %s\n", task->task_base_info.name));

    lock = CriticalAreaLock();
    
    DoubleLinkListRmNode(&(task->task_dync_sched_member.sched_link));
    KTaskUnSetDelay(task);
#ifdef ARCH_SMP
    HwLockSpinlock(&AssignSpinLock);
#endif 
    Assign.ready_vector_done->insert(task);
#ifdef ARCH_SMP
    HwUnlockSpinlock(&AssignSpinLock);
#endif
    CriticalAreaUnLock(lock);
	
    HOOK(hook.task.hook_TaskResume,(task));
    return EOK;
}

x_err_t SuspendKTask(int32 id)
{
    struct TaskDescriptor *task = NONE;

    task = GetTaskWithIdnodeInfo(id);
    NULL_PARAM_CHECK(task);

    return task->Done->suspend(task);
}

x_err_t KTaskWakeup(int32 id)
{
    x_base lock = 0;
    struct TaskDescriptor *task = NONE;

    task = GetTaskWithIdnodeInfo(id);
    NULL_PARAM_CHECK(task);

    return task->Done->wake(task);
}

void KTaskTimeout(void *parameter)
{
    x_base lock = 0;
    struct TaskDescriptor *task = NONE;
    
	NULL_PARAM_CHECK(parameter);

    lock = CriticalAreaLock();
    
    task = (struct TaskDescriptor *)parameter;

    if(RET_TRUE == JudgeKTaskStatIsSuspend(task)) {
        task->exstatus = -ETIMEOUT;
        DoubleLinkListRmNode(&(task->task_dync_sched_member.sched_link));
#ifdef ARCH_SMP
        HwLockSpinlock(&AssignSpinLock);
#endif
        Assign.ready_vector_done->insert(task);
#ifdef ARCH_SMP
        HwUnlockSpinlock(&AssignSpinLock);
#endif
        CriticalAreaUnLock(lock);
        DO_KTASK_ASSIGN;
    } else {
        CriticalAreaUnLock(lock);
    }
}

x_err_t LinklistSuspend(DoubleLinklistType        *list,
                                       struct TaskDescriptor *task,
                                       uint8        flag)
{
    int32 ret = EOK;
    x_ubase lock = 0;
    DoubleLinklistType *node = NONE;
    DoubleLinklistType *tail = NONE;
    struct TaskDescriptor *tmp_task = NONE;

    NULL_PARAM_CHECK(list);
    NULL_PARAM_CHECK(task);

    lock = CriticalAreaLock();

    SuspendKTask(task->id.id);
    switch (flag)
    {
    case LINKLIST_FLAG_FIFO:
        DoubleLinkListInsertNodeBefore(list, &(task->task_dync_sched_member.sched_link));
        break;

    case LINKLIST_FLAG_PRIO:
        DOUBLE_LINKLIST_FOR_EACH(node,list)
        {
            tmp_task = SYS_DOUBLE_LINKLIST_ENTRY(node, struct TaskDescriptor, task_dync_sched_member.sched_link);
            if (task->task_dync_sched_member.cur_prio < tmp_task->task_dync_sched_member.cur_prio)
            {
                break;
            }
        }
        if(node != list) {
            DoubleLinkListInsertNodeBefore(&(tmp_task->task_dync_sched_member.sched_link), &(task->task_dync_sched_member.sched_link));
        } else {
            tail = list->node_prev;
            DoubleLinkListInsertNodeAfter(tail,&(task->task_dync_sched_member.sched_link));
        }       
        break;

    default:
        ret = -EINVALED;
        break;
    }
    CriticalAreaUnLock(lock);
    return ret;
}

x_ticks_t CalculateTickFromTimeMs(uint32 ms)
{
    uint32 tmp = 0;
    x_ticks_t ticks = 0;
    
    ticks = (uint32)(((uint64)(ms * TICK_PER_SECOND)) / 1000) ;
    if (0 == ticks) {
        ticks = MIN_TICKS;
    } else {
        tmp = (uint32)(((uint64)(ms * TICK_PER_SECOND)) % 1000);

        if(tmp >= 5 && tmp <= 9) {
            ticks = ticks + MIN_TICKS;
        }
    }
    
    return ticks;
}

static int32 _EventTrigger(struct Event *event, uint32 events)
{
    x_bool resched;
    x_ubase lock = 0;
    x_base status = 0;
    struct TaskDescriptor *task = NONE;
    struct SysDoubleLinklistNode *n = NONE;
    
    NULL_PARAM_CHECK(event);

    if (events == 0)
        return -ERROR;

    resched = RET_FALSE;

    lock = CriticalAreaLock();

    event->events |= events;

    if (IsDoubleLinkListEmpty(&event->pend_list)) {
        CriticalAreaUnLock(lock);
        return EOK;
    }

    n = event->pend_list.node_next;
    while (n != &(event->pend_list)) {
        task = SYS_DOUBLE_LINKLIST_ENTRY(n, struct TaskDescriptor, task_dync_sched_member.sched_link);
        status = -ERROR;
        if (task->event_mode & EVENT_AND) {
            if ((task->event_id_trigger & (event->events & EVENT_EVENTS_MASK)) == task->event_id_trigger)
                status = EOK;
        } else if (task->event_mode & EVENT_OR) {
            if (task->event_id_trigger & (event->events & EVENT_EVENTS_MASK)) {
                task->event_id_trigger = task->event_id_trigger & (event->events & EVENT_EVENTS_MASK);
                status = EOK;
            }
        }

        n = n->node_next;

        if (status == EOK) {
            if (task->event_mode & EVENT_AUTOCLEAN)
                event->events &= ~task->event_id_trigger;

            KTaskWakeup(task->id.id);

            resched = RET_TRUE;
        }
    }

    CriticalAreaUnLock(lock);

    if (resched == RET_TRUE)
        DO_KTASK_ASSIGN;

    return EOK;
}

static int32 _EventProcess(struct Event *event, uint32 events, uint32 options, int32 msec, uint32 *processed)
{
    
    x_ubase lock = 0;
    x_base status = 0;
    int32 timeout = 0;
    struct TaskDescriptor *task = NONE;

    KDEBUG_IN_KTASK_CONTEXT;

    NULL_PARAM_CHECK(event);

    if (events == 0)
        return -ERROR;

    status = -ERROR;
    task = GetKTaskDescriptor();
    task->exstatus = EOK;

    timeout = CalculateTickFromTimeMs(msec);

    lock = CriticalAreaLock();

    if (options & EVENT_AND) {
        if ((event->events & events) == events)
            status = EOK;
    } else if (options & EVENT_OR) {
        if (event->events & events)
            status = EOK;
    } else {
        CHECK(0);
    }

    if (status == EOK) {
        if (processed)
            *processed = (event->events & events);

        if (options & EVENT_AUTOCLEAN)
            event->events &= ~events;
    } else if (timeout == 0) {
        task->exstatus = -ETIMEOUT;
    } else {
        task->event_id_trigger  = (events & EVENT_EVENTS_MASK);
        task->event_mode  = (options & EVENT_OPTIONS_MASK);

        LinklistSuspend(&(event->pend_list), task, event->options);

        if (timeout > 0)
            KTaskSetDelay(task,timeout);

        CriticalAreaUnLock(lock);

        DO_KTASK_ASSIGN;

        if (task->exstatus != EOK)
            return task->exstatus;

        lock = CriticalAreaLock();

        if (processed)
           *processed = task->event_id_trigger;
    }

    CriticalAreaUnLock(lock);

    return task->exstatus;
}
