#include "m_assign.h"
#include "ktask_wakeup.h"
#include "ktask_set_status.h"
#include "ktask_unset_delay.h"
#include "suspend_views.h"
#include "delay_views_strategy.h"
#include "wakeup_views.h"
/*@ include strategies "sched_source_views.strategies" */
/*@ include strategies "wakeup_views.strategies" */
/*@ include strategies "delay_views.strategies" */
/*@ include strategies "critical_task_view.strategies" */
/*@ include strategies "task_id_view.strategies" */

/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskWakeupProof */
/*@ Import Coq Require Import CRTOS_Verify.libai.GetTaskWithIdnodeInside */
/*@ Extern Coq
      (KNONE : Z)
      (get_task_with_idnode_success : StableGlobalState -> VarGlobalState -> Z -> Z -> Prop)
 */

/*
 * 来源：../crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c。
 * 按《源代码处理.md》保留锁内调用切片：注释日志、hook 和嵌套锁，
 * NULL_PARAM_CHECK 使用已有封装，ready_vector_done->insert 展开为实际目标。
 * 当前 xsconfig.h 未启用 ARCH_SMP，启用 32 优先级和 RR_REMAINSLICE。
 *
 * Stage 2：沿用已审阅的 os_inv Spec，从零构造 Wakeup 的实现证明。
 * 入口/出口直接使用 os_inv；调用者须为当前调用状态重建它，持锁本身不蕴含它。
 * 临界区入口的 InsideCritical token 由调用者作为 frame 保留，不重新观察全局状态。
 * detached 的 sched_link 已由 task_inv 的 sched_owned_tasks 管理，不能重复给出。
 * Delay 的 NULL/inactive/active 三分支由 delay_inv 提供，不预先限定来源。
 * SUSPEND 的掩码由 task_wf_running_bitmap 提供；os_world_wf 已包含在 os_inv 中。
 * 优先级范围、对齐、登记后的节点覆盖等已有事实不再重复要求。
 * Ensure 直接区分非 SUSPEND/成功两种返回；ktask_wakeup_step 仅描述成功转移。
 * 空参数在 NULL_PARAM_CHECK 中不返回；正常返回仍保证 task != 0。
 */

void KTaskInsertToReadyVector(struct TaskDescriptor *task)
/*@ With (sg : StableGlobalState)
         (st : VarGlobalState)
         (desc : TaskDescriptorAbs)
    Require
      os_global_context(sg) &&
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      task_fields(sg, st) * assign_ready_pending(sg, st) *
      occupy_dll_node(sched_link_of(task))
    Ensure
      exists (insert_before ready_after : OsAssignReadyVectorAbs) (st_insert : VarGlobalState),
        insert_before == st.os_assign.assignReadyVector &&
        assign_insert_step_ic(st.os_tasks.task_desc_map, task, desc, insert_before, ready_after) &&
        st_insert ==
          replace_global_ready_vector(ready_after,
            replace_task_desc_map(
              update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st)) &&
        task_fields(sg, st_insert) * assign_ready_pending(sg, st_insert)
 */;


/**
 * This function will resume a task.
 *
 * @param id task id
 *
 */
x_err_t _KTaskWakeup(KTaskDescriptorType task)
/*@ wakeup_general_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
         (desc : TaskDescriptorAbs)
    Require
      before.os_tasks.task_desc_map(task) == Some(desc) &&
      os_inv(sg, before)
    Ensure exists after,
      task != 0 &&
      ((desc.tdSchedMember.tsmStat != TSK_SUSPEND &&
        __return == -1 && after == before) ||
       (desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
        __return == 0 && ktask_wakeup_step(task, desc, before, after))) &&
      os_inv(sg, after)
 */
{
    x_base lock = 0;

    NULL_PARAM_CHECK_1(task);

    if (RET_TRUE != JudgeKTaskStatIsSuspend(task)) {
        // SYS_KDEBUG_LOG(KDBG_KTASK, ("task stat must be suspend error stat is , %d\n", KTaskStatGet(task)));
        return -ERROR;
    }

    // SYS_KDEBUG_LOG(KDBG_KTASK, ("wakeup task name:  %s\n", task->task_base_info.name));

    // lock = CriticalAreaLock();

    /* 来源先由纯条件分类，随后每条路径确定性地借出节点。 */
    /*@ do suspend_source_facts */
    /*@ Destruct with
        wakeup_detached_path: In(task, before.os_tasks.sched_owned_tasks);
        wakeup_linked_path: !In(task, before.os_tasks.sched_owned_tasks) */
    /*@ do wakeup_unfold $ wakeup_detached_path */
    /*@ do wakeup_unfold $ wakeup_linked_path */
    DoubleLinkListRmNode(&(task->task_dync_sched_member.sched_link))
      /*@ where (remove_member) storeA = pure_suspend_sched_link(before.os_tasks.task_desc_map), a = task;
                A = Z $ wakeup_linked_path
          where (remove_self) node = &(task->task_dync_sched_member.sched_link) $ wakeup_detached_path */;
    /*@ do sched_source_fold */
    KTaskUnSetDelay(task) /*@ where (all_case_delay) sg = sg, st_before = before, desc = desc */;
    /*@ Given st_after */
    /*@ suspend_source_facts(sg, before, task) &&
        ktask_unset_delay_step(desc.tdDelay, before, st_after) &&
        before.os_tasks.task_desc_map(task) == Some(desc) &&
        wakeup_global_frame(sg, before) * task_fields(sg, before) *
        assign_ready_pending(sg, before) *
        suspend_sched_pool(update_task_desc_map(task, set_task_desc_ready(desc), before.os_tasks.task_desc_map),
          sg, suspend_unlink_state(task, before))
        which implies suspend_source_facts(sg, st_after, task) &&
        st_after.os_tasks.task_desc_map(task) == Some(desc) &&
        wakeup_global_frame(sg, st_after) * task_fields(sg, st_after) *
        assign_ready_pending(sg, st_after) *
        suspend_sched_pool(update_task_desc_map(task, set_task_desc_ready(desc), st_after.os_tasks.task_desc_map),
          sg, suspend_unlink_state(task, st_after))
     */
// #ifdef ARCH_SMP
//     HwLockSpinlock(&AssignSpinLock);
// #endif
    KTaskInsertToReadyVector(task) /*@ where sg = sg, st = st_after, desc = desc */;
    /*@ Given insert_before ready_after st_insert */
    /*@ do wakeup_fold_os */
// #ifdef ARCH_SMP
//     HwUnlockSpinlock(&AssignSpinLock);
// #endif
    // CriticalAreaUnLock(lock);

    // HOOK(hook.task.hook_TaskResume,(task));
    return EOK;
}

/* 原样复用 get_task_with_idnode.c 的 inside_critical Spec。
 * 查询只借还 ID-manager，允许返回空指针；其余资源保留为 frame。 */
struct TaskDescriptor *GetTaskWithIdnodeInfo(int32 id)
/*@ inside_critical
    With (sg : StableGlobalState) (st : VarGlobalState)
    Require
      id < 65536 &&
      task_world_wf(st) &&
      store_idmanager(
        sg.os_task_stable.task_stable_ids, st.os_tasks.task_idmanager_abs,
        &k_task_id_manager)
    Ensure
      ((__return == KNONE &&
        (id < 0 || idmanager_query(st.os_tasks.task_idmanager_abs, id) == false))
       ||
       get_task_with_idnode_success(sg, st, id, __return)) &&
      store_idmanager(
        sg.os_task_stable.task_stable_ids, st.os_tasks.task_idmanager_abs,
        &k_task_id_manager)
 */;

/* ID 包装层的锁内 Spec：入口不要求 ID 已登记，也不预先指定目标描述符。
 * id < 65536 来自现有查询契约；负 ID 或查询失败路径在非空检查处不正常返回。
 * 正常返回的 found/desc 由实际查询结果确定，查询和唤醒共享同一 before。
 * 发布性仅在下方指定切点使用用户授权假设；本 C 单元不导入该公理。
 * 调用者须提供当前状态的 os_inv，InsideCritical token 作为 frame 保留。 */
x_err_t KTaskWakeup(int32 id)
/*@ wakeup_by_id_ic */
{
    x_base lock = 0;
    struct TaskDescriptor *task = NONE;

    task = GetTaskWithIdnodeInfo(id)
        /*@ where (inside_critical) sg = sg, st = before */;
    NULL_PARAM_CHECK_1(task);

    /* 唯一允许使用查询发布性公理的切点：Stage 2 在此 VC 中直接应用一次，
     * 只引出当前查询结果的 desc；其余资源与 _KTaskWakeup 的证明照常处理。 */
    /*@ task != 0 &&
        get_task_with_idnode_success(sg, before, id, task) &&
        os_inv(sg, before)
        which implies exists (desc : TaskDescriptorAbs),
        task != 0 &&
        get_task_with_idnode_success(sg, before, id, task) &&
        before.os_tasks.task_desc_map(task) == Some(desc) &&
        os_inv(sg, before)
     */
    /*@ Given desc */
    return _KTaskWakeup(task)
        /*@ where (wakeup_general_ic) sg = sg, before = before, desc = desc */;
}
