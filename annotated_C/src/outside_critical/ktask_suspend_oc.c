#include "get_ktask_descriptor_oc.h"
#include "assign_ready_remove.h"
#include "ktask_set_status.h"
#include "ktask_status_oc.h"
#include "ktask_unset_delay.h"
#include "suspend_views.h"
#include "suspend_sched_views.h"
/*@ include strategies "suspend_sched_views.strategies" */
#include "task_sched_view.h"
#include "delay_views_strategy.h"
/*@ include strategies "task_sched_view.strategies" */
/*@ include strategies "delay_views.strategies" */
/*@ include strategies "critical_task_view.strategies" */

/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskSuspendOC */
/*@ Import Coq Require Import CRTOS_Verify.VC.code.outside_critical.ktask_suspend_oc_lib */
/*@ Extern Coq
      (KNONE : Z)
      (KERROR : Z)
      (abs_get_task_with_idnode :
        StableGlobalState -> Z -> program (VarGlobalState -> Prop) (option Z))
      (abs_ktask_suspendOC :
        StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
      (abs_ktask_suspend_by_idOC :
        StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
      (suspend_commit_bodyOC : Z -> program (VarGlobalState -> Prop) Z)
      (suspend_checked_commitOC : StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
      (suspend_current_postOC : StableGlobalState -> Z -> (Z -> (VarGlobalState -> Prop) -> Prop) -> Z -> (VarGlobalState -> Prop) -> Prop)
      (suspend_ready_postOC : StableGlobalState -> Z -> (Z -> (VarGlobalState -> Prop) -> Prop) -> Z -> (VarGlobalState -> Prop) -> Prop)
      (suspend_accepted_postOC : StableGlobalState -> Z -> (Z -> (VarGlobalState -> Prop) -> Prop) -> Z -> (VarGlobalState -> Prop) -> Prop)
      (suspend_suspend_postOC : StableGlobalState -> Z -> (Z -> (VarGlobalState -> Prop) -> Prop) -> Z -> (VarGlobalState -> Prop) -> Prop)
      (suspend_lookup_postOC : StableGlobalState -> (Z -> (VarGlobalState -> Prop) -> Prop) -> option Z -> (VarGlobalState -> Prop) -> Prop)
 */

/* 与 CRTOS kernel/thread/ktask.c 核对后的 OC 切片。
 * 保留原更新临界区；当前未启用 ARCH_SMP，其锁分支以注释保留。
 * Judge 使用 ktask_status_oc.c
 * 中自行加锁的 OC 实现，保持原来的表达式与 READY/RUNNING 短路次序。
 * getter 使用上面声明的 OC 合同，自行保留其锁；不调用 IC getter。
 * ready_vector_done->remove 和 Done->suspend 按已确定的函数表绑定展开。
 * 公开 Spec 是条件契约：跨解锁的发布性及最终状态域由原生
 * safeExec 中的 checked 条件约束，不能从旧查询快照推出。
 * Stage 2 复用 IC 调度/延时恢复引理；各次 OC 观察有独立 continuation。 */

/**
 * This function will suspend a task.
 *
 * @param id task id
 *
 */
x_err_t _SuspendKTask(KTaskDescriptorType task)
/*@ suspend_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require
      safeExec(LastSeen(before), abs_ktask_suspendOC(sg, task), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      (__return == -KERROR || __return == KOK) &&
      safeExec(LastSeen(after), return(__return), X) &&
      OutsideCritical(sg, after)
 */
{
    x_base lock = 0;

    NULL_PARAM_CHECK_1(task);

    if (task != GetKTaskDescriptor()
        /*@ where (outside_critical) sg = sg, before = before, X = suspend_current_postOC(sg, task, X) */) {
        // SYS_KDEBUG_LOG(KDBG_KTASK, ("running task is forbidden to suspend the others.\n"));
        return -ERROR;
    }
    
    if (RET_TRUE != JudgeKTaskStatIsReady(task)
          /*@ where (judge_oc) sg = sg, X = suspend_ready_postOC(sg, task, X) */ &&
        RET_TRUE != JudgeKTaskStatIsRunning(task)
          /*@ where (judge_oc) sg = sg, X = suspend_accepted_postOC(sg, task, X) */) {
        // SYS_KDEBUG_LOG(KDBG_KTASK, ("task stat  0x%2x is forbidden to suspend.\n", KTaskStatGet(task)));
        return -ERROR;
    }

    /* 短路两条路径在此汇合；seen 是最后一次实际 OC 观察。 */
    /*@ Assert exists seen,
        task == task@pre && task != 0 && lock == 0 &&
        safeExec(LastSeen(seen), abs_ktask_judge_statusOC(sg, task, TSK_SUSPEND), suspend_suspend_postOC(sg, task, X)) &&
        OutsideCritical(sg, seen) */
    /*@ Given seen */
    if (RET_TRUE == JudgeKTaskStatIsSuspend(task)
        /*@ where (judge_oc) sg = sg, before = seen, X = suspend_suspend_postOC(sg, task, X) */) {
        // SYS_KDEBUG_LOG(KDBG_KTASK, ("task stat is already suspend.\n"));
        return -ERROR;
    }

    // SYS_KDEBUG_LOG(KDBG_KTASK, ("suspend task name:  %s\n", task->task_base_info.name));

    /*@ Given commit_seen from after */
    /*@ Assert task == task@pre && task != 0 && lock == 0 &&
        safeExec(LastSeen(commit_seen), suspend_checked_commitOC(sg, task), X) &&
        OutsideCritical(sg, commit_seen) */
    /* 原源码的更新临界区，保留其 lock/unlock。 */
    lock = CriticalAreaLock() /*@ where (ordinary) sg = sg, st1 = commit_seen */;
    /*@ Given st_lock */
    /*@ safeExec(LastSeen(commit_seen), suspend_checked_commitOC(sg, task), X) &&
        Crtos_RTrans(commit_seen, st_lock) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
        which implies exists desc,
        st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
        (desc.tdSchedMember.tsmStat == TSK_READY || desc.tdSchedMember.tsmStat == TSK_RUNNING) &&
        safeExec(LastSeen(commit_seen), suspend_commit_bodyOC(task), X) &&
        Crtos_RTrans(commit_seen, st_lock) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock) */
    /*@ Given desc */
// #ifdef ARCH_SMP
//     HwLockSpinlock(&AssignSpinLock);
// #endif
    /* 调度节点所属分支来自本次锁内不变量，不使用早先的 Judge 快照。 */
    /*@ do suspend_unfold */
    /*@ Branch name linked: desc.tdSchedMember.tsmStat != TSK_RUNNING;
                    detached: desc.tdSchedMember.tsmStat == TSK_RUNNING */
    KTaskOsAssignRemoveKTask(task)
      /*@ where (linked_ic) desc = desc, before = st_lock.os_assign.assignReadyVector $ linked
          where (detached_ic) desc = desc, before = st_lock.os_assign.assignReadyVector $ detached */;
    /*@ Given ready from after */
    /*@ do suspend_fold_remove */
// #ifdef ARCH_SMP
//     HwUnlockSpinlock(&AssignSpinLock);
// #endif

    KTaskStateSet(task, KTASK_SUSPEND);
    /*@ do suspend_prepare_delay */
    /*@ Given staged */
    KTaskUnSetDelay(task)
      /*@ where (all_case_delay) sg = sg, st_before = staged,
        desc = update_sched_member(desc, set_sched_member_status(desc.tdSchedMember, TSK_SUSPEND)) */;
    /*@ Given committed from st_after */
    /*@ do suspend_fold_os */


    /*@ Assert exists saved_lock, task == task@pre && lock == saved_lock &&
        safeExec(LastSeen(committed), return(KOK), X) &&
        Crtos_GTrans(st_lock, committed) &&
        InsideCritical(sg, st_lock) * os_inv(sg, committed) */
    CriticalAreaUnLock(lock)
      /*@ where (stable) sg = sg, st1 = st_lock, st2 = committed */;

    // HOOK(hook.task.hook_TaskSuspend,(task));
    return EOK;
}

/* 原 OC 查询合同；负 ID / 查询失败继续由 NULL 检查处理。 */
inline struct TaskDescriptor *GetTaskWithIdnodeInfo(int32 id)
/*@ With (sg : StableGlobalState) (before : VarGlobalState) X
    Require id < 65536 &&
      safeExec(LastSeen(before), abs_get_task_with_idnode(sg, id), X) &&
      OutsideCritical(sg, before)
    Ensure
      (exists after,
        __return == KNONE &&
        safeExec(LastSeen(after), return(None), X) &&
        OutsideCritical(sg, after))
      ||
      (exists after,
        safeExec(LastSeen(after), return(Some(__return)), X) &&
        OutsideCritical(sg, after))
 */;

/**
 * This function will suspend a task.
 *
 * @param id task id
 *
 * @return EOK
 */
x_err_t SuspendKTask(int32 id)
/*@ suspend_by_id_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require id < 65536 &&
      safeExec(LastSeen(before), abs_ktask_suspend_by_idOC(sg, id), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      (__return == -KERROR || __return == KOK) &&
      safeExec(LastSeen(after), return(__return), X) &&
      OutsideCritical(sg, after)
 */
{
    struct TaskDescriptor *task = NONE;

    task = GetTaskWithIdnodeInfo(id)
      /*@ where sg = sg, before = before, X = suspend_lookup_postOC(sg, X) */;
    /*@ Given lookup_seen from after */
    NULL_PARAM_CHECK_1(task);

    return _SuspendKTask(task)
      /*@ where (suspend_oc) sg = sg, before = lookup_seen, X = X */;
}
