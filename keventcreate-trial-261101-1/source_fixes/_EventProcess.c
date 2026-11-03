/*
 * Trial 专用源码修复候选：E2，延时建立失败后的等待回滚。
 * 来源：Ubiquitous/XiZi_IIoT_Macro/kernel/thread/event.c::_EventProcess。
 * 按用户要求，权威源码保持原样；仅此 trial 副本包含修复。
 * 除标注的 E2 分支外，保留原函数正文、签名和控制流。
 * 本文件用于修复回归，未加入 KEventCreate 的 QCP 调用闭包，尚无实现证明。
 * 原文件版权及许可：Copyright (c) 2020 AIIT XUOS Lab；Mulan PSL v2。
 */
#include <xizi.h>

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

        if (timeout > 0) {
            status = KTaskSetDelay(task,timeout);
            if (status != EOK) {
                /* Trial 修改 E2：原实现忽略 KTaskSetDelay 失败，会使有限等待
                 * 没有超时保障。这里保存错误码，并在原临界区内撤销挂起/入队。
                 * KTaskWakeup 只恢复 READY，随后仍走原有解锁、调度及错误返回
                 * 路径，不能在这里直接返回。本改动仅存在于 trial。 */
                task->exstatus = status;
                KTaskWakeup(task->id.id);
            }
        }

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
