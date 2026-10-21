#include "m_assign.h"
#include "ktask_set_status.h"
#include "ktask_unset_delay.h"

/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskSuspend */
/*@ Extern Coq
      (ktask_suspend_step : Z -> VarGlobalState -> Z -> VarGlobalState -> Prop)
 */

/*
 * 来源：../crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c。
 * 按《源代码处理.md》保留锁内调用切片：注释调试、hook 和嵌套锁操作，
 * 将复杂宏及函数指针调用替换为已有封装或实际目标函数。
 * 当前 xsconfig.h 未启用 ARCH_SMP，SMP 分支仅以注释保留。
 */

/*
 * Stage 1 候选规格，尚未执行 QCP 验证。
 * os_inv 已包含 task/assign/delay 的良构条件及位图查表资源；不重复要求
 * priority 范围、地址对齐、ready 覆盖或 sched_link 自环。
 * LONE 的节点归 task_inv，LINKED 的节点归 assign_inv；成功后均归 task_inv。
 * RUNNING 的掩码由 task_wf_running_bitmap 保证；结合既有空桶/位图关系，
 * LONE 清位保持 ready group，无需调用者另行提供清位条件。
 * 通用 delay 调用使用 all_case_delay 的语义；WqueueWait 的先设延时路径
 * 排除了无条件使用 null_or_inactive。下面的派生接口只服务已知 N/U 的调用者。
 */

/**
 * This function will suspend a task.
 *
 * @param id task id
 *
 */
x_err_t _SuspendKTask(KTaskDescriptorType task)
/*@ inside_critical
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require os_inv(sg, before)
    Ensure exists after,
      ktask_suspend_step(task, before, __return, after) &&
      os_inv(sg, after)
 */
/*@ null_or_inactive <= inside_critical
    With (sg : StableGlobalState) (before : VarGlobalState)
         (desc : TaskDescriptorAbs)
    Require before.os_tasks.task_desc_map(task) == Some(desc) &&
      (desc.tdDelay == 0 ||
       before.os_delays.delay_inactive_map(desc.tdDelay) != None) &&
      os_inv(sg, before)
    Ensure exists after,
      ktask_suspend_step(task, before, __return, after) &&
      after.os_delays == before.os_delays &&
      os_inv(sg, after)
 */
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

    // lock = CriticalAreaLock();
// #ifdef ARCH_SMP
//     HwLockSpinlock(&AssignSpinLock);
// #endif
    KTaskOsAssignRemoveKTask(task);
// #ifdef ARCH_SMP
//     HwUnlockSpinlock(&AssignSpinLock);
// #endif
    KTaskStateSet(task, KTASK_SUSPEND);
    KTaskUnSetDelay(task);

    // CriticalAreaUnLock(lock);

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

    return _SuspendKTask(task);
}
