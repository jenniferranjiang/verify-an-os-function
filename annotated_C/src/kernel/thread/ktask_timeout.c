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
#include "critical_task_view.h"
#include "task_stat_view.h"
#include "task_exstatus_view.h"
/*@ include strategies "critical_task_view.strategies" */
/*@ include strategies "task_stat_view.strategies" */
/*@ include strategies "task_exstatus_view.strategies" */
/*@ Import Coq Require Import CRTOS_Verify.VC.code.kernel.thread.ktask_timeout_lib */
/*@ Extern Coq
 (timeout_source :: *)
 */
/*@ Extern Coq
 (timeout_detached : timeout_source)
 (timeout_linked : Z -> list(DL_Node Z) -> list(DL_Node Z) -> timeout_source)
 (timeout_source_pre : (Z -> option TaskDescriptorAbs) -> Z -> timeout_source -> Assertion)
 (timeout_source_post : (Z -> option TaskDescriptorAbs) -> timeout_source -> Assertion)
 (timeout_source_frame : StableGlobalState -> VarGlobalState -> Z -> TaskDescriptorAbs -> timeout_source -> Assertion)
 (timeout_global_frame : StableGlobalState -> VarGlobalState -> Z -> Assertion)
 (timeout_sched_pool : (Z -> option TaskDescriptorAbs) -> StableGlobalState -> VarGlobalState -> Assertion)
 (ktask_timeout_body : Z -> program (VarGlobalState -> Prop) unit)
 (ktask_timeout_descriptor : TaskDescriptorAbs -> TaskDescriptorAbs)
 (ktask_timeout_unlink_state : Z -> VarGlobalState -> VarGlobalState)
 (ktask_timeout_state : VarGlobalState -> Z -> TaskDescriptorAbs -> OsAssignReadyVectorAbs -> VarGlobalState)
 (pure_suspend_sched_link : (Z -> option TaskDescriptorAbs) -> Z -> Z -> Assertion)
 */

/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskTimeout */
/*@ Extern Coq
      (abs_ktask_timeout :
        StableGlobalState -> Z -> program (VarGlobalState -> Prop) unit)
      (set_task_desc_ready : TaskDescriptorAbs -> TaskDescriptorAbs)
      (update_task_desc_map :
        Z -> TaskDescriptorAbs -> (Z -> option TaskDescriptorAbs) ->
        Z -> option TaskDescriptorAbs)
      (assign_insert_step_ic :
        (Z -> option TaskDescriptorAbs) -> Z -> TaskDescriptorAbs ->
        OsAssignReadyVectorAbs -> OsAssignReadyVectorAbs -> Prop)
 */

/*
 * 来源：../crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c。
 * 按“源代码处理.md”提取 KTaskTimeout。
 * delay.c 的 CheckTaskDelay 在解锁后调用本函数，故保留原有临界区；
 * 任务状态读取、exstatus 写入和调度链表操作均在该临界区内。
 * 当前 annotated_C/src/include/xsconfig.h 未启用 ARCH_SMP。
 * 本文件是锁外调用的源码切片；证明覆盖下方 OC Spec 的两个状态分支。
 * KTASK_ASSIGN 的 outside_critical Spec 复用 ktask_assign_oc.h。
 */

/*
 * assign.c 的 SingleReadyVectorDone.insert 指向 KTaskInsertToReadyVector。
 * 在本函数的原有临界区内调用，复用 assign_ready_insert.c 的锁内切片；
 * 该切片已注释内部 DISABLE_INTERRUPT / ENABLE_INTERRUPT。
 * 调用 Spec 与 assign_ready_insert.c 一致；task_fields 包含已写入的
 * exstatus，来源节点由 remove_self/remove_member 取得后交给 ready 表。
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
 * timeout function of task timer,this function removes the suspend task and add to ready queue
 * then start a new schedule
 *
 * @param parameter arg for task timeout function
 *
 * assertS 在首次加锁观察处要求 task_desc_map(parameter) != None，即任务已发布；
 * 只在旧 before 中存在不够，单独管理链登记也不够。该纯检查不提供内存。
 * 对 SUSPEND 任务还检查 bitmap_column == 1 << cur_prio；插入 helper
 * 直接使用此字段，而 KTaskTimeout 本身不重新计算位图。
 * 非 SUSPEND 原样解锁返回；SUSPEND 写 -ETIMEOUT、摘除 sched_link 并入
 * READY 队列，解锁后执行 KTASK_ASSIGN。不读取或改变 Delay 对象。
 * 后续调度允许环境推进，故返回时不保证目标仍 READY 或仍然存活。
 */
void KTaskTimeout(void *parameter)
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require
      safeExec(LastSeen(before), abs_ktask_timeout(sg, parameter), X) &&
      OutsideCritical(sg, before)
    Ensure
      exists after,
        safeExec(LastSeen(after), return(tt), X) &&
        OutsideCritical(sg, after)
 */
{
    x_base lock = 0;
    struct TaskDescriptor *task = NONE;

    NULL_PARAM_CHECK_1(parameter);

    lock = CriticalAreaLock() /*@ where (ordinary) sg = sg, st1 = before */;
    /*@ Given st_lock */
    /*@ safeExec(LastSeen(before), abs_ktask_timeout(sg, parameter), X) &&
        Crtos_RTrans(before, st_lock) && InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
        which implies exists desc,
        safeExec(LastSeen(before), ktask_timeout_body(parameter), X) &&
        st_lock.os_tasks.task_desc_map(parameter) == Some(desc) &&
        (desc.tdSchedMember.tsmStat != TSK_SUSPEND ||
         desc.tdSchedMember.tsmBitmapColumn == (1 << desc.tdSchedMember.tsmCurPrio)) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
     */
    /*@ Given desc */
    /* 首次检查在此完整 cut 消耗；后续只使用固定锁观察及 body 的 safeExec。 */
    /*@ Assert exists lock_saved,
        safeExec(LastSeen(before), ktask_timeout_body(parameter@pre), X) &&
        st_lock.os_tasks.task_desc_map(parameter@pre) == Some(desc) &&
        (desc.tdSchedMember.tsmStat != TSK_SUSPEND ||
         desc.tdSchedMember.tsmBitmapColumn == (1 << desc.tdSchedMember.tsmCurPrio)) &&
        Crtos_RTrans(before, st_lock) &&
        store_ptr(&parameter, parameter@pre) * store_ptr(&task, 0) *
        store(&lock, signed long, lock_saved) *
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
     */
    /*@ Given lock_saved */

    task = (struct TaskDescriptor *)parameter;

    if(RET_TRUE == JudgeKTaskStatIsSuspend(task)) {
        /*@ st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
            desc.tdSchedMember.tsmStat == TSK_SUSPEND && os_inv(sg, st_lock)
            which implies exists source,
            os_global_context(sg) && sched_link_of(task) != 0 &&
            timeout_global_frame(sg, st_lock, task) * task_fields(sg, st_lock) *
            assign_ready_pending(sg, st_lock) *
            timeout_source_pre(st_lock.os_tasks.task_desc_map, task, source) *
            timeout_source_frame(sg, st_lock, task, desc, source)
         */
        /*@ Given source */
        task->exstatus = -ETIMEOUT;
        /*@ timeout_source_pre(st_lock.os_tasks.task_desc_map, task, source)
            which implies
            ((exists head prefix suffix,
              source == timeout_linked(head, prefix, suffix) && source != timeout_detached &&
              store_dll(pure_suspend_sched_link(st_lock.os_tasks.task_desc_map), head,
                app(prefix, cons(Build_DL_Node(task, &(task->task_dync_sched_member.sched_link)), suffix)))) ||
             (source == timeout_detached && store_node_self_linked(&(task->task_dync_sched_member.sched_link))))
         */
        /*@ Branch name
            timeout_linked_path: source != timeout_detached;
            timeout_detached_path: source == timeout_detached */
        DoubleLinkListRmNode(&(task->task_dync_sched_member.sched_link))
          /*@ where (remove_member) storeA = pure_suspend_sched_link(st_lock.os_tasks.task_desc_map), a = task;
                    A = Z $ timeout_linked_path
              where (remove_self) node = &(task->task_dync_sched_member.sched_link) $ timeout_detached_path */;
        // #ifdef ARCH_SMP
        // HwLockSpinlock(&AssignSpinLock);
        // #endif
        /*@ Assert
            safeExec(LastSeen(before), ktask_timeout_body(parameter@pre), X) &&
            st_lock.os_tasks.task_desc_map(parameter@pre) == Some(desc) &&
            desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
            desc.tdSchedMember.tsmBitmapColumn == (1 << desc.tdSchedMember.tsmCurPrio) &&
            Crtos_RTrans(before, st_lock) && os_global_context(sg) &&
            store_ptr(&parameter, parameter@pre) * store_ptr(&task, parameter@pre) *
            store(&lock, signed long, lock_saved) * InsideCritical(sg, st_lock) *
            timeout_global_frame(sg, st_lock, parameter@pre) *
            task_fields(sg, replace_task_desc_map(update_task_desc_map(parameter@pre, replace_descriptor_exstatus(-2, desc), st_lock.os_tasks.task_desc_map), st_lock)) * assign_ready_pending(sg, st_lock) *
            timeout_source_post(st_lock.os_tasks.task_desc_map, source) *
            store_node_self_linked(sched_link_of(parameter@pre)) *
            timeout_source_frame(sg, st_lock, parameter@pre, desc, source)
            $ timeout_linked_path timeout_detached_path
         */
        /*@ task_fields(sg, replace_task_desc_map(update_task_desc_map(task, replace_descriptor_exstatus(-2, desc), st_lock.os_tasks.task_desc_map), st_lock)) * assign_ready_pending(sg, st_lock) *
            timeout_source_post(st_lock.os_tasks.task_desc_map, source) *
            store_node_self_linked(sched_link_of(task)) *
            timeout_source_frame(sg, st_lock, task, desc, source)
            which implies
            (replace_task_desc_map(update_task_desc_map(task, replace_descriptor_exstatus(-2, desc), st_lock.os_tasks.task_desc_map), st_lock)).os_tasks.task_desc_map(task) == Some(replace_descriptor_exstatus(-2, desc)) &&
            task_fields(sg, replace_task_desc_map(update_task_desc_map(task, replace_descriptor_exstatus(-2, desc), st_lock.os_tasks.task_desc_map), st_lock)) * assign_ready_pending(sg, replace_task_desc_map(update_task_desc_map(task, replace_descriptor_exstatus(-2, desc), st_lock.os_tasks.task_desc_map), st_lock)) *
            occupy_dll_node(sched_link_of(task)) * timeout_sched_pool(update_task_desc_map(task, set_task_desc_ready(ktask_timeout_descriptor(desc)), st_lock.os_tasks.task_desc_map), sg, ktask_timeout_unlink_state(task, st_lock))
         */
        // 原调用：Assign.ready_vector_done->insert(task);
        KTaskInsertToReadyVector(task)
          /*@ where sg = sg, st = replace_task_desc_map(update_task_desc_map(task, replace_descriptor_exstatus(-2, desc), st_lock.os_tasks.task_desc_map), st_lock), desc = replace_descriptor_exstatus(-2, desc) */;
        /*@ Given insert_before ready_after st_insert */
        // #ifdef ARCH_SMP
        // HwUnlockSpinlock(&AssignSpinLock);
        // #endif
        /*@ st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
            desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
            desc.tdSchedMember.tsmBitmapColumn == (1 << desc.tdSchedMember.tsmCurPrio) &&
            safeExec(LastSeen(before), ktask_timeout_body(task), X) && Crtos_RTrans(before, st_lock) &&
            insert_before == st_lock.os_assign.assignReadyVector &&
            assign_insert_step_ic((replace_task_desc_map(update_task_desc_map(task, replace_descriptor_exstatus(-2, desc), st_lock.os_tasks.task_desc_map), st_lock)).os_tasks.task_desc_map, task, replace_descriptor_exstatus(-2, desc), insert_before, ready_after) &&
            st_insert == replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(replace_descriptor_exstatus(-2, desc)), (replace_task_desc_map(update_task_desc_map(task, replace_descriptor_exstatus(-2, desc), st_lock.os_tasks.task_desc_map), st_lock)).os_tasks.task_desc_map), replace_task_desc_map(update_task_desc_map(task, replace_descriptor_exstatus(-2, desc), st_lock.os_tasks.task_desc_map), st_lock))) &&
            timeout_global_frame(sg, st_lock, task) * task_fields(sg, st_insert) *
            assign_ready_pending(sg, st_insert) * timeout_sched_pool(update_task_desc_map(task, set_task_desc_ready(ktask_timeout_descriptor(desc)), st_lock.os_tasks.task_desc_map), sg, ktask_timeout_unlink_state(task, st_lock))
            which implies
            Crtos_GTrans(st_lock, ktask_timeout_state(st_lock, task, desc, ready_after)) &&
            safeExec(LastSeen(ktask_timeout_state(st_lock, task, desc, ready_after)), abs_ktask_assign, X) && os_inv(sg, ktask_timeout_state(st_lock, task, desc, ready_after))
         */
        CriticalAreaUnLock(lock) /*@ where (stable) st1 = st_lock, st2 = ktask_timeout_state(st_lock, task, desc, ready_after) */;
        // 原语句：DO_KTASK_ASSIGN;
        KTASK_ASSIGN() /*@ where (outside_critical) before = ktask_timeout_state(st_lock, task, desc, ready_after), X = X */;
    } else {
        /*@ task == parameter@pre && st_lock.os_tasks.task_desc_map(task) == Some(desc) &&
            desc.tdSchedMember.tsmStat != TSK_SUSPEND &&
            safeExec(LastSeen(before), ktask_timeout_body(task), X) && Crtos_RTrans(before, st_lock) &&
            os_inv(sg, st_lock)
            which implies task == parameter@pre && Crtos_GTrans(st_lock, st_lock) &&
            safeExec(LastSeen(st_lock), return(tt), X) && os_inv(sg, st_lock)
         */
        CriticalAreaUnLock(lock) /*@ where (stable) st1 = st_lock, st2 = st_lock */;
    }
}
