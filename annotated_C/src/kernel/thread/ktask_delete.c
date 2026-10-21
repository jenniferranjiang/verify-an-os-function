/*
 * Copyright (c) 2020 AIIT XUOS Lab
 * XiUOS is licensed under Mulan PSL v2.
 * You can use this software according to the terms and conditions of the Mulan PSL v2.
 * You may obtain a copy of Mulan PSL v2 at:
 *        http://license.coscl.org.cn/MulanPSL2
 * THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
 * EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
 * MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
 * See the Mulan PSL v2 for more details.
 */

#include "m_ktask.h"
#include "ktask_set_status.h"
#include "ktask_assign_oc.h"

/*
 * 来源：../crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c。
 * 按“源代码处理.md”提取 _DeleteKTask 及其两个文件内辅助函数。
 * 当前 annotated_C/src/include/xsconfig.h 未启用 ARCH_SMP。
 * 本文件是锁外调用的源码切片；删除操作及辅助函数的 Spec 待后续设计。
 * KTASK_ASSIGN 的 outside_critical Spec 复用 ktask_assign_oc.h。
 */

extern DoubleLinklistType KTaskZombie;
extern int32 zombie_recycle;
extern int JudgeZombieKTaskIsNotEmpty(void);

/* 保留 libc 的实际接口；任务名比较的 Spec 待后续设计。 */
size_t strlen(const char *s);
int strncmp(const char *s1, const char *s2, size_t n);

/*
 * 在 _DeleteKTask 的原有临界区内调用。
 * assign.c 的 SingleReadyVectorDone.remove 指向 KTaskOsAssignRemoveKTask；
 * 复用 assign_ready_remove.c 的临界区内切片，内部中断开关已注释。
 */
static inline void _KTaskResourceDelete(struct TaskDescriptor *task)
{
    NULL_PARAM_CHECK_1(task);

    // #ifdef ARCH_SMP
    // HwLockSpinlock(&AssignSpinLock);
    // #endif
    // 原调用：Assign.ready_vector_done->remove(task);
    KTaskOsAssignRemoveKTask(task);
    // #ifdef ARCH_SMP
    // HwUnlockSpinlock(&AssignSpinLock);
    // #endif
    KTaskStatSetAsClose(task);

    return;
}

/*
 * 原调用发生在锁外；按切片规则给读取共享任务名的 if 语句加临界区。
 * 保留三个前缀比较及其短路顺序，各返回路径均先解锁。
 * 检查后仍退出临界区，再由 _DeleteKTask 进入原有删除临界区。
 */
static inline x_err_t __JudgeKTaskIsIdleOrZombierecycle(KTaskDescriptorType task)
{
    x_base lock = 0;

    NULL_PARAM_CHECK_1(task);
    lock = CriticalAreaLock();
    if(0 == strncmp(task->task_base_info.name,"ktaskidle0",strlen("ktaskidle0")) ||
        0 == strncmp(task->task_base_info.name,"ktaskidle1",strlen("ktaskidle1")) ||
        0 == strncmp(task->task_base_info.name,"ZombieRecycleKTask",strlen("ZombieRecycleKTask")) )
    {
        CriticalAreaUnLock(lock);
        return RET_TRUE;
    }

    CriticalAreaUnLock(lock);
    return EOK;
}

/**
 * This function will remove a dynamic task out of the task manage list.
 *
 * @param task task descriptor
 */
x_err_t _DeleteKTask(KTaskDescriptorType task)
{
    x_base lock = 0;

    NULL_PARAM_CHECK_1(task);

    if(RET_TRUE == __JudgeKTaskIsIdleOrZombierecycle(task)) {
        // KPrintf("idle or zombierecycle is not permitted to delete.\n");
        return -EINVALED;
    }

    lock = CriticalAreaLock();

    _KTaskResourceDelete(task);

    DoubleLinkListInsertNodeAfter(&KTaskZombie, &(task->task_dync_sched_member.sched_link));
    if (JudgeZombieKTaskIsNotEmpty()) {
        /* 复用 ktask_wakeup.c 的临界区内切片，保留按 ID 唤醒的调用。 */
        KTaskWakeup(zombie_recycle);
    }
    CriticalAreaUnLock(lock);

    // 原语句：DO_KTASK_ASSIGN;
    KTASK_ASSIGN();

    return EOK;
}
