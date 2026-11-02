#include "m_ktask.h"

/* 来源：../crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/delay.c。
 * Stage 1 只同步切片，暂不提供 KTaskSetDelay 的 OC 入口 Spec。
 * 原有两处 lock/unlock 原样保留；新增 access_lock 对应原锁外的
 * 单条共享访问。条件中的 delay 指针读取与 else 中的第二次读取仍然
 * 分开，不能因常规单线程优化而跨解锁复用旧值。
 * x_malloc / memset 操作尚未发布的新块；发布后的字段写入各自加锁。
 * 旧局部资源 Spec、重复 Extern 声明及遗留 Given/where 已移除。
 * 共享 Delay 谓词仍被 IC 和 UnSetDelay 证明使用，不能随 OC Spec 删除。
 * 每次解锁所需的不变量恢复与对象保活协议仍待独立设计，不能把新增锁
 * 本身当作内存安全或 OC 验证完成的证明。 */

x_ticks_t CurrentTicksGain(void)
/*@ With os_tick
    Require store_uint(heartbeat_ticks_addr, os_tick)
    Ensure __return == os_tick &&
           store_uint(heartbeat_ticks_addr, os_tick)
 */;

struct Delay *CONTAINER_OF_DELAY_LINK(DoubleLinklistType *link_ptr)
/*@ With delay_ptr
    Require link_ptr == field_addr(delay_ptr, struct Delay, link) && emp
    Ensure __return == delay_ptr &&
           link_ptr == &(__return->link)
 */;

x_err_t KTaskSetDelay(KTaskDescriptorType task, x_ticks_t ticks)
{
    x_base lock = 0;
    x_base access_lock = 0;
    struct Delay *delay = NONE;
    struct Delay *delay_for_test = NONE;
    struct Delay *dnode = NONE;
    DoubleLinklistType *nodelink = NONE;

    NULL_PARAM_CHECK_1(task);

    if (ticks >= (TICK_SIZE_MAX / 2))
        return -EINVALED;

    access_lock = CriticalAreaLock();
    delay_for_test = task->task_dync_sched_member.delay;
    CriticalAreaUnLock(access_lock);
    if (delay_for_test == NONE) {
        delay = (struct Delay *)x_malloc(sizeof(struct Delay));
        if (delay == NONE) {
            return -ENOMEMORY;
        }
        memset(delay, 0x0, sizeof(struct Delay));
        access_lock = CriticalAreaLock();
        task->task_dync_sched_member.delay = delay;
        CriticalAreaUnLock(access_lock);
    } else {
        access_lock = CriticalAreaLock();
        delay = task->task_dync_sched_member.delay;
        CriticalAreaUnLock(access_lock);
        /* 原源码的 active 摘链临界区。 */
        lock = CriticalAreaLock();
        if (delay->status == TASK_DELAY_ACTIVE) {
            delay->status = TASK_DELAY_INACTIVE;
            DoubleLinkListRmNode(&(delay->link));
        }
        CriticalAreaUnLock(lock);
    }

    access_lock = CriticalAreaLock();
    delay->ticks = CurrentTicksGain() + ticks;
    CriticalAreaUnLock(access_lock);
    access_lock = CriticalAreaLock();
    delay->task = task;
    CriticalAreaUnLock(access_lock);
    access_lock = CriticalAreaLock();
    delay->status = TASK_DELAY_ACTIVE;
    CriticalAreaUnLock(access_lock);

    /* 原源码的有序插入临界区；continue 保留 for 的增量读取。 */
    lock = CriticalAreaLock();
    for (nodelink = xiaoshan_delay_head.node_next;
         nodelink != &xiaoshan_delay_head;
         nodelink = nodelink->node_next) {
        dnode = CONTAINER_OF_DELAY_LINK(nodelink);
        if ((dnode->ticks - delay->ticks) == 0)
            continue;
        if ((dnode->ticks - delay->ticks) < (TICK_SIZE_MAX / 2)) {
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
