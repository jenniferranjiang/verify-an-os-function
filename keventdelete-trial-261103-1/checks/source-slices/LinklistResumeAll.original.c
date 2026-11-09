 x_err_t LinklistResumeAll(DoubleLinklistType *list)
{
    x_ubase lock = 0;
    struct TaskDescriptor *task = NONE;
    DoubleLinklistType *node = NONE;

    NULL_PARAM_CHECK(list);

    lock = CriticalAreaLock();
    for(;;) {
        node = list->node_next;
        if(node != list) {
            task = SYS_DOUBLE_LINKLIST_ENTRY(node, struct TaskDescriptor, task_dync_sched_member.sched_link);
            task->exstatus = -ERROR;
            KTaskWakeup(task->id.id);
        } else {
            break;
        }
    }
    CriticalAreaUnLock(lock);

    return EOK;
}
