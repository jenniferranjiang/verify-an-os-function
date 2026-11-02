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

#include "m_assign.h"
#include "ktask_delete_resource.h"
#include "ktask_zombie_nonempty.h"
#include "ktask_assign_oc.h"
#include "ktask_wakeup.h"
#include "zombie_views.h"
#include "critical_views_strategy.h"
#include "task_delete_views.h"
/*@ include strategies "task_delete_views.strategies" */
/*@ include strategies "critical_views.strategies" */
/*@ include strategies "zombie_views.strategies" */
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskDeleteRestore */
/*@ Import Coq Require Import CRTOS_Verify.VC.code.kernel.thread.ktask_quit_lib */
/*@ Extern Coq (ServicePhase :: *) */

/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskQuitSpec */
/*@ Extern Coq
      (abs_ktask_quit : StableGlobalState -> program (VarGlobalState -> Prop) unit)
      (ktask_quit_body : StableGlobalState -> program (VarGlobalState -> Prop) unit)
      (service_phase : ServiceSlotAbs -> ServicePhase)
      (ServiceRegistered : Z -> ServicePhase)
 */

/*
 * 来源：../crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c 的 KTaskQuit。
 * 按“源代码处理.md”导入：保留外层临界区及 NONE 分支；唯一的函数体
 * 转换是 DO_KTASK_ASSIGN -> KTASK_ASSIGN()，规格由 ktask_assign_oc.h 提供。
 * 当前 xsconfig.h 未启用 ARCH_SMP。
 *
 * GetKTaskDescriptor 和 KTaskWakeup 分别复用 get_ktask_descriptor.c、
 * ktask_wakeup.c 的已验证锁内切片，其中嵌套加解锁已注释。
 * _KTaskResourceDelete 及 zombie 非空判断复用对应 header 的已验证接口。
 * 所有共享访问均发生在原有临界区内，无需另加锁；本函数没有日志或 hook。
 * 非空分支与 _DeleteKTask 共用锁内关系和 task_delete_views 策略。
 * 用户已选择保留 ktask_quit_entry_condition 的受限调用域；Stage 2
 * 检查该条件契约，不证明 True rely 下的一般调用者可建立入口条件。
 */

extern int32 zombie_recycle;

/* 与 get_ktask_descriptor.c 的 inside_critical Spec 保持一致。 */
KTaskDescriptorType GetKTaskDescriptor(void)
/*@ inside_critical
    With (running_task : Z)
    Require store_ptr(&(Assign.os_running_task), running_task)
    Ensure __return == running_task &&
           store_ptr(&(Assign.os_running_task), running_task)
 */;

/**
 * Kernel task exit function: insert the current task into the zombie queue.
 */
void KTaskQuit(void)
/*@ ktask_quit_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require
      safeExec(LastSeen(before), abs_ktask_quit(sg), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) &&
      OutsideCritical(sg, after)
 */
{
    x_base lock = 0;
    struct TaskDescriptor *task = NONE;

    lock = CriticalAreaLock() /*@ where (ordinary) sg = sg, st1 = before */;
    /*@ Given st_lock */
    task = GetKTaskDescriptor()
        /*@ where (inside_critical) running_task = st_lock.os_assign.assignRunningTask */;
    /*@ Assert exists (running : Z) saved_lock,
        running == st_lock.os_assign.assignRunningTask &&
        Crtos_RTrans(before, st_lock) &&
        safeExec(LastSeen(before), abs_ktask_quit(sg), X) &&
        store_ptr(&task, running) *
        store(&lock, signed long, saved_lock) *
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
     */
    /*@ Given running saved_lock */
    if (NONE != task) {
        /*@ running == st_lock.os_assign.assignRunningTask && running != 0 &&
            safeExec(LastSeen(before), abs_ktask_quit(sg), X) &&
            Crtos_RTrans(before, st_lock) &&
            InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
            which implies exists desc initial_nodes registered_recycler,
            st_lock.os_tasks.task_desc_map(running) == Some(desc) &&
            ktask_delete_not_service(running, st_lock) &&
            zombie_queue(st_lock) == ZombieLinked(initial_nodes) &&
            service_phase(os_recycle(st_lock)) == ServiceRegistered(registered_recycler) &&
            service_id(os_recycle(st_lock)) < 65536 &&
            safeExec(LastSeen(before), ktask_quit_body(sg), X) &&
            InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
         */
        /*@ Given desc initial_nodes registered_recycler */
        /*@ Assert
            running == st_lock.os_assign.assignRunningTask &&
            running != 0 &&
            Crtos_RTrans(before, st_lock) &&
            st_lock.os_tasks.task_desc_map(running) == Some(desc) &&
            ktask_delete_not_service(running, st_lock) &&
            zombie_queue(st_lock) == ZombieLinked(initial_nodes) &&
            service_phase(os_recycle(st_lock)) == ServiceRegistered(registered_recycler) &&
            service_id(os_recycle(st_lock)) < 65536 &&
            safeExec(LastSeen(before), ktask_quit_body(sg), X) &&
            store_ptr(&task, running) *
            store(&lock, signed long, saved_lock) *
            InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
         */
        _KTaskResourceDelete(task)
            /*@ where (resource_delete_registered_ic) sg = sg, before = st_lock, desc = desc */;
        /*@ Given removed from after */
        /* 资源展开由 task_delete_views 按插入需求触发；此 cut 只命名后态，
         * 并保留当前函数的控制流、锁 token 和 continuation。 */
        /*@ Assert exists queued nodes,
            running == st_lock.os_assign.assignRunningTask && running != 0 &&
            Crtos_RTrans(before, st_lock) &&
            st_lock.os_tasks.task_desc_map(running) == Some(desc) &&
            ktask_resource_delete_transition(running, desc, st_lock, removed) &&
            service_phase(os_recycle(st_lock)) == ServiceRegistered(registered_recycler) &&
            service_id(os_recycle(st_lock)) < 65536 &&
            safeExec(LastSeen(before), ktask_quit_body(sg), X) &&
            ktask_delete_enqueue_transition(running, removed, queued) &&
            os_recycle(queued) == os_recycle(st_lock) &&
            zombie_queue(queued) == ZombieLinked(cons(sched_link_node(running), nodes)) &&
            os_world_wf(sg, removed) &&
            sched_link_of(running) != 0 && sched_link_of(running) == &(running->task_dync_sched_member.sched_link) &&
            &(running->task_dync_sched_member.sched_link) != 0 &&
            dll_insert_anchor(&KTaskZombie, nodes, &KTaskZombie) &&
            store_ptr(&task, running) * store(&lock, signed long, saved_lock) *
            InsideCritical(sg, st_lock) *
            store_dll(pure_close_sched_link(removed.os_tasks.task_desc_map), &KTaskZombie, nodes) *
            pure_close_sched_link(removed.os_tasks.task_desc_map, &(running->task_dync_sched_member.sched_link), running) *
            occupy_dll_node(&(running->task_dync_sched_member.sched_link)) * delete_enqueue_restore(sg, removed, queued, running, nodes)
         */
        /*@ Given queued nodes */
        DoubleLinkListInsertNodeAfter(&KTaskZombie, &(task->task_dync_sched_member.sched_link))
            /*@ where (dispatch_case) head = &KTaskZombie, nodes = nodes,
                storeA = pure_close_sched_link(removed.os_tasks.task_desc_map), a = running; A = Z */;
        if (JudgeZombieKTaskIsNotEmpty()
            /*@ where (zombie_known_nonempty_ic) T = queued.os_tasks.task_desc_map,
                nodes = cons(sched_link_node(running), nodes) */) {
            /*@ service_phase(os_recycle(st_lock)) == ServiceRegistered(registered_recycler) &&
                os_recycle(queued) == os_recycle(st_lock) && os_inv(sg, queued)
                which implies
                ktask_wakeup_detached_null_condition(sg, queued, service_id(os_recycle(queued))) &&
                store_int(&zombie_recycle, service_id(os_recycle(queued))) * os_recycler_id_frame(sg, queued)
             */
            KTaskWakeup(zombie_recycle)
                /*@ where (detached_sched_null_delay) sg = sg, before = queued */;
            /*@ Given recycler from task */
            /*@ Given rdesc from desc */
            /*@ Given after_wakeup from after */
        }
    }
    /*@ Assert exists final_locked,
        Crtos_GTrans(st_lock, final_locked) &&
        safeExec(LastSeen(final_locked), abs_ktask_assign, X) &&
        store_ptr(&task, running) *
        store(&lock, signed long, saved_lock) *
        InsideCritical(sg, st_lock) * os_inv(sg, final_locked)
     */
    /*@ Given final_locked */
    CriticalAreaUnLock(lock) /*@ where (stable) sg = sg, st1 = st_lock, st2 = final_locked */;

    // 原语句：DO_KTASK_ASSIGN;
    KTASK_ASSIGN() /*@ where (outside_critical) sg = sg, before = final_locked, X = X */;
}
