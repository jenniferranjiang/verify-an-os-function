#include "assign_ready_remove.h"
#include "ktask_set_status.h"
#include "ktask_unset_delay.h"
#include "suspend_views.h"
#include "suspend_sched_views.h"
/*@ include strategies "suspend_sched_views.strategies" */
#include "task_sched_view.h"
/*@ include strategies "task_sched_view.strategies" */
#include "delay_views_strategy.h"
/*@ include strategies "delay_views.strategies" */
/*@ include strategies "critical_task_view.strategies" */
/*@ include strategies "task_id_view.strategies" */

/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskSuspend */
/*@ Import Coq Require Import CRTOS_Verify.libai.GetTaskWithIdnodeInside */
/*@ Extern Coq
      (KNONE : Z)
      (ktask_suspend_step : Z -> VarGlobalState -> Z -> VarGlobalState -> Prop)
      (get_task_with_idnode_success : StableGlobalState -> VarGlobalState -> Z -> Z -> Prop)
 */

KTaskDescriptorType GetKTaskDescriptor(void)
/*@ inside_critical
    With (running_task : Z)
    Require store_ptr(&(Assign.os_running_task), running_task)
    Ensure __return == running_task &&
           store_ptr(&(Assign.os_running_task), running_task)
 */;

/*
 * 来源：../crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c。
 * 按《源代码处理.md》保留锁内调用切片：注释调试、hook 和嵌套锁操作，
 * 将复杂宏及函数指针调用替换为已有封装或实际目标函数。
 * 当前 xsconfig.h 未启用 ARCH_SMP，SMP 分支仅以注释保留。
 */

/*
 * 公开锁内规格；中间的资源转交不要求维持完整 os_inv。
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
/*@ suspend_general_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require os_inv(sg, before)
    Ensure exists after,
      ktask_suspend_step(task, before, __return, after) &&
      os_inv(sg, after)
 */;

x_err_t _SuspendKTask(KTaskDescriptorType task)
/*@ suspend_null_or_inactive_ic <= suspend_general_ic
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
 */;

x_err_t _SuspendKTask(KTaskDescriptorType task)
/*@ suspend_general_ic */
{
    x_base lock = 0;

    NULL_PARAM_CHECK_1(task);

    if (task != GetKTaskDescriptor()
        /*@ where (inside_critical) running_task = before.os_assign.assignRunningTask */) {
        // SYS_KDEBUG_LOG(KDBG_KTASK, ("running task is forbidden to suspend the others.\n"));
        return -ERROR;
    }

    /* 当前指针非零且相等的分支才需要 descriptor 登记见证。 */
    /*@ task != 0 && task == before.os_assign.assignRunningTask && os_inv(sg, before)
        which implies
        exists desc, before.os_tasks.task_desc_map(task) == Some(desc) && os_inv(sg, before) */
    /*@ Given desc */
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
    /* 由入口不变量借出节点；分支仅用于选择底层调用所需的内存权限。 */
    /*@ do suspend_unfold */
    /*@ Branch name linked: desc.tdSchedMember.tsmStat != TSK_RUNNING;
                    detached: desc.tdSchedMember.tsmStat == TSK_RUNNING */
    KTaskOsAssignRemoveKTask(task)
      /*@ where (linked_ic) desc=desc,
            before=before.os_assign.assignReadyVector $ linked
          where (detached_ic) desc=desc,
            before=before.os_assign.assignReadyVector $ detached */;
    /*@ Given ready from after */
    /*@ do suspend_fold_remove */
// #ifdef ARCH_SMP
//     HwUnlockSpinlock(&AssignSpinLock);
// #endif
    KTaskStateSet(task, KTASK_SUSPEND);
    /*@ do suspend_prepare_delay */
    /*@ Given staged */
    KTaskUnSetDelay(task)
      /*@ where (all_case_delay) sg=sg, st_before=staged,
        desc=update_sched_member(desc, set_sched_member_status(desc.tdSchedMember, TSK_SUSPEND)) */;

    /*@ do suspend_fold_os */

    // CriticalAreaUnLock(lock);

    // HOOK(hook.task.hook_TaskSuspend,(task));
    return EOK;
}

#undef false

/* 复用已验证的 ID 查询契约，仅使用简洁的本地 Spec 名称。
 * 查询只借还 ID-manager，其余资源由既有策略保留并恢复。 */
struct TaskDescriptor *GetTaskWithIdnodeInfo(int32 id)
/*@ task_lookup_ic
    With (sg : StableGlobalState) (st : VarGlobalState)
    Require
      id < 65536 && task_world_wf(st) &&
      store_idmanager(
        sg.os_task_stable.task_stable_ids, st.os_tasks.task_idmanager_abs,
        &k_task_id_manager)
    Ensure
      ((__return == KNONE &&
        (id < 0 || idmanager_query(st.os_tasks.task_idmanager_abs, id) == false))
       || get_task_with_idnode_success(sg, st, id, __return)) &&
      store_idmanager(
        sg.os_task_stable.task_stable_ids, st.os_tasks.task_idmanager_abs,
        &k_task_id_manager)
 */;

/**
 * This function will suspend a task.
 *
 * @param id task id
 *
 * @return EOK
 */
/* 锁内 ID 包装层，查询与挂起共享同一个 before。
 * id < 65536 沿用现有查询契约；负 ID / 查询失败在 NULL 检查处不正常返回。
 * 通用入口不要求查询成功或目标发布，也不限制 sched_link / Delay 的来源。
 * 非 current 目标由内层直接拒绝；current 的登记性由 os_inv 保证，
 * 因而不需要 Wakeup 包装层的查询发布性公理。InsideCritical token 由调用者 frame 保留。
 * 已知目标及其 N/U 条件的调用者使用下方派生接口，并取得 Delay 状态不变。 */
x_err_t SuspendKTask(int32 id)
/*@ suspend_by_id_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require id < 65536 && os_inv(sg, before)
    Ensure exists (found : Z) (after : VarGlobalState),
      found != 0 && get_task_with_idnode_success(sg, before, id, found) &&
      ktask_suspend_step(found, before, __return, after) &&
      os_inv(sg, after)
 */;

/* target/desc 必须绑定到本次 id 查询的任务，不能用无关 descriptor 的 Delay 条件。
 * 查询只读并保持同一 before；ID 唯一性把实际结果与 target 对齐，随后对应
 * _SuspendKTask.suspend_null_or_inactive_ic 的前置和 Delay 不变保证。 */
x_err_t SuspendKTask(int32 id)
/*@ suspend_by_id_null_or_inactive_ic <= suspend_by_id_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
         (target : Z) (desc : TaskDescriptorAbs)
    Require id < 65536 &&
      get_task_with_idnode_success(sg, before, id, target) &&
      before.os_tasks.task_desc_map(target) == Some(desc) &&
      (desc.tdDelay == 0 ||
       before.os_delays.delay_inactive_map(desc.tdDelay) != None) &&
      os_inv(sg, before)
    Ensure exists after,
      ktask_suspend_step(target, before, __return, after) &&
      after.os_delays == before.os_delays &&
      os_inv(sg, after)
 */;

x_err_t SuspendKTask(int32 id)
/*@ suspend_by_id_ic */
{
    struct TaskDescriptor *task = NONE;

    task = GetTaskWithIdnodeInfo(id)
        /*@ where (task_lookup_ic) sg = sg, st = before */;
    NULL_PARAM_CHECK_1(task);

    return _SuspendKTask(task)
        /*@ where (suspend_general_ic) sg = sg, before = before */;
}
