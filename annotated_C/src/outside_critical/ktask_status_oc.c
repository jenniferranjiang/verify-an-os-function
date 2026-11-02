#include "ktask_status_oc.h"
#include "task_stat_view.h"
#include "critical_task_view.h"

/*@ include strategies "task_status.strategies" */
/*@ include strategies "task_stat_view.strategies" */
/*@ include strategies "critical_task_view.strategies" */
/*@ include strategies "task_status_oc_views.strategies" */

/* 来源：CRTOS kernel/thread/ktask_stat.c 的五个 JudgeKTaskStatIs*。
 * 保留 NULL 检查和原来的掩码比较；把单次共享读取包在新增的短临界区。
 * 只有本地 result 穿过解锁，调用者可以直接使用原来的短路表达式。
 * checked 发布条件沿用已有 OC 模型，不把 getter 的旧快照视作保活权限。 */

BOOL JudgeKTaskStatIsInit(KTaskDescriptorType task)
/*@ judge_oc */
{
    x_base lock = 0;
    BOOL result = 0;

    NULL_PARAM_CHECK_1(task);
    lock = CriticalAreaLock()
        /*@ where (ordinary) sg = sg, st1 = before */;
    /*@ Given st_lock */
    /*@ safeExec(LastSeen(before), abs_ktask_judge_statusOC(sg, task, TSK_INIT), X) &&
        Crtos_RTrans(before, st_lock) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
        which implies exists desc,
          safeExec(LastSeen(before), task_atomic_cmd(ktask_judge_status_lockedOC(task, TSK_INIT)), X) &&
          st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
          Crtos_RTrans(before, st_lock) &&
          InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
     */
    /*@ Given desc */

    result = ((task->task_dync_sched_member.stat & KTASK_STAT_MASK) == KTASK_INIT);

    /*@ ktask_judge_status_resultOC(desc.tdSchedMember.tsmStat, TSK_INIT, result) &&
        safeExec(LastSeen(before), task_atomic_cmd(ktask_judge_status_lockedOC(task, TSK_INIT)), X) &&
        st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
        Crtos_RTrans(before, st_lock) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
        which implies
        0 <= result && result <= 1 &&
        safeExec(LastSeen(st_lock), return(result), X) &&
        Crtos_GTrans(st_lock, st_lock) &&
        store_ptr(&task, task) * InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
     */
    CriticalAreaUnLock(lock)
        /*@ where (stable) sg = sg, st1 = st_lock, st2 = st_lock */;
    return result;
}

BOOL JudgeKTaskStatIsReady(KTaskDescriptorType task)
/*@ judge_oc */
{
    x_base lock = 0;
    BOOL result = 0;

    NULL_PARAM_CHECK_1(task);
    lock = CriticalAreaLock()
        /*@ where (ordinary) sg = sg, st1 = before */;
    /*@ Given st_lock */
    /*@ safeExec(LastSeen(before), abs_ktask_judge_statusOC(sg, task, TSK_READY), X) &&
        Crtos_RTrans(before, st_lock) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
        which implies exists desc,
          safeExec(LastSeen(before), task_atomic_cmd(ktask_judge_status_lockedOC(task, TSK_READY)), X) &&
          st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
          Crtos_RTrans(before, st_lock) &&
          InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
     */
    /*@ Given desc */

    result = ((task->task_dync_sched_member.stat & KTASK_STAT_MASK) == KTASK_READY);

    /*@ ktask_judge_status_resultOC(desc.tdSchedMember.tsmStat, TSK_READY, result) &&
        safeExec(LastSeen(before), task_atomic_cmd(ktask_judge_status_lockedOC(task, TSK_READY)), X) &&
        st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
        Crtos_RTrans(before, st_lock) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
        which implies
        0 <= result && result <= 1 &&
        safeExec(LastSeen(st_lock), return(result), X) &&
        Crtos_GTrans(st_lock, st_lock) &&
        store_ptr(&task, task) * InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
     */
    CriticalAreaUnLock(lock)
        /*@ where (stable) sg = sg, st1 = st_lock, st2 = st_lock */;
    return result;
}

BOOL JudgeKTaskStatIsSuspend(KTaskDescriptorType task)
/*@ judge_oc */
{
    x_base lock = 0;
    BOOL result = 0;

    NULL_PARAM_CHECK_1(task);
    lock = CriticalAreaLock()
        /*@ where (ordinary) sg = sg, st1 = before */;
    /*@ Given st_lock */
    /*@ safeExec(LastSeen(before), abs_ktask_judge_statusOC(sg, task, TSK_SUSPEND), X) &&
        Crtos_RTrans(before, st_lock) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
        which implies exists desc,
          safeExec(LastSeen(before), task_atomic_cmd(ktask_judge_status_lockedOC(task, TSK_SUSPEND)), X) &&
          st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
          Crtos_RTrans(before, st_lock) &&
          InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
     */
    /*@ Given desc */

    result = ((task->task_dync_sched_member.stat & KTASK_STAT_MASK) == KTASK_SUSPEND);

    /*@ ktask_judge_status_resultOC(desc.tdSchedMember.tsmStat, TSK_SUSPEND, result) &&
        safeExec(LastSeen(before), task_atomic_cmd(ktask_judge_status_lockedOC(task, TSK_SUSPEND)), X) &&
        st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
        Crtos_RTrans(before, st_lock) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
        which implies
        0 <= result && result <= 1 &&
        safeExec(LastSeen(st_lock), return(result), X) &&
        Crtos_GTrans(st_lock, st_lock) &&
        store_ptr(&task, task) * InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
     */
    CriticalAreaUnLock(lock)
        /*@ where (stable) sg = sg, st1 = st_lock, st2 = st_lock */;
    return result;
}

BOOL JudgeKTaskStatIsRunning(KTaskDescriptorType task)
/*@ judge_oc */
{
    x_base lock = 0;
    BOOL result = 0;

    NULL_PARAM_CHECK_1(task);
    lock = CriticalAreaLock()
        /*@ where (ordinary) sg = sg, st1 = before */;
    /*@ Given st_lock */
    /*@ safeExec(LastSeen(before), abs_ktask_judge_statusOC(sg, task, TSK_RUNNING), X) &&
        Crtos_RTrans(before, st_lock) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
        which implies exists desc,
          safeExec(LastSeen(before), task_atomic_cmd(ktask_judge_status_lockedOC(task, TSK_RUNNING)), X) &&
          st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
          Crtos_RTrans(before, st_lock) &&
          InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
     */
    /*@ Given desc */

    result = ((task->task_dync_sched_member.stat & KTASK_STAT_MASK) == KTASK_RUNNING);

    /*@ ktask_judge_status_resultOC(desc.tdSchedMember.tsmStat, TSK_RUNNING, result) &&
        safeExec(LastSeen(before), task_atomic_cmd(ktask_judge_status_lockedOC(task, TSK_RUNNING)), X) &&
        st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
        Crtos_RTrans(before, st_lock) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
        which implies
        0 <= result && result <= 1 &&
        safeExec(LastSeen(st_lock), return(result), X) &&
        Crtos_GTrans(st_lock, st_lock) &&
        store_ptr(&task, task) * InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
     */
    CriticalAreaUnLock(lock)
        /*@ where (stable) sg = sg, st1 = st_lock, st2 = st_lock */;
    return result;
}

BOOL JudgeKTaskStatIsClose(KTaskDescriptorType task)
/*@ judge_oc */
{
    x_base lock = 0;
    BOOL result = 0;

    NULL_PARAM_CHECK_1(task);
    lock = CriticalAreaLock()
        /*@ where (ordinary) sg = sg, st1 = before */;
    /*@ Given st_lock */
    /*@ safeExec(LastSeen(before), abs_ktask_judge_statusOC(sg, task, TSK_CLOSE), X) &&
        Crtos_RTrans(before, st_lock) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
        which implies exists desc,
          safeExec(LastSeen(before), task_atomic_cmd(ktask_judge_status_lockedOC(task, TSK_CLOSE)), X) &&
          st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
          Crtos_RTrans(before, st_lock) &&
          InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
     */
    /*@ Given desc */

    result = ((task->task_dync_sched_member.stat & KTASK_STAT_MASK) == KTASK_CLOSE);

    /*@ ktask_judge_status_resultOC(desc.tdSchedMember.tsmStat, TSK_CLOSE, result) &&
        safeExec(LastSeen(before), task_atomic_cmd(ktask_judge_status_lockedOC(task, TSK_CLOSE)), X) &&
        st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
        Crtos_RTrans(before, st_lock) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
        which implies
        0 <= result && result <= 1 &&
        safeExec(LastSeen(st_lock), return(result), X) &&
        Crtos_GTrans(st_lock, st_lock) &&
        store_ptr(&task, task) * InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
     */
    CriticalAreaUnLock(lock)
        /*@ where (stable) sg = sg, st1 = st_lock, st2 = st_lock */;
    return result;
}
