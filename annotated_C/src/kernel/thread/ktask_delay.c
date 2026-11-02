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

#include "ktask_set_delay.h"
#include "ktask_wakeup.h"
#include "ktask_assign_oc.h"
#include "task_registered_id.h"
#include "ktask_delay_views.h"
/*@ include strategies "ktask_delay_views.strategies" */
/*@ include strategies "task_registered_id.strategies" */
/*@ Import Coq Require Import CRTOS_Verify.VC.code.kernel.thread.ktask_delay_lib */
/*@ Extern Coq
 (delay_assign_post : StableGlobalState -> Z -> (Z -> (VarGlobalState -> Prop) -> Prop) -> unit -> (VarGlobalState -> Prop) -> Prop)
 (delay_lookup_post : StableGlobalState -> Z -> (Z -> (VarGlobalState -> Prop) -> Prop) -> Z -> (VarGlobalState -> Prop) -> Prop)
 (delay_after_assign : StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
 (delay_after_read : StableGlobalState -> Z -> Z -> program (VarGlobalState -> Prop) Z)
 (delay_read_body : StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
 (delay_write_body : Z -> program (VarGlobalState -> Prop) Z)
 (ktask_delay_wakeup_locked : StableGlobalState -> Z -> program VarGlobalState unit)
 (nrm : {S A} -> program S A -> S -> A -> S -> Prop)
 (ktask_delay_set_locked : Z -> Z -> program VarGlobalState Z)
 (delay_after_locked : StableGlobalState -> Z -> Z -> program (VarGlobalState -> Prop) Z)
 (delay_body : StableGlobalState -> Z -> Z -> program (VarGlobalState -> Prop) Z)
 (delay_entry_facts : StableGlobalState -> Z -> Z -> VarGlobalState -> Prop)
 */

/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskDelay */
/*@ Printing Coq Name nrm := MonadErr.nrm */
/*@ Extern Coq
      (abs_get_ktask_descriptor : program (VarGlobalState -> Prop) Z)
      (abs_ktask_delay : StableGlobalState -> Z -> Z -> program (VarGlobalState -> Prop) Z)
      (abs_ktask_delay_current : StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
      (ktask_suspend_step : Z -> VarGlobalState -> Z -> VarGlobalState -> Prop)
 */

/* 复用 outside_critical/get_task_descriptor_oc.c 的已验证 OC 接口。 */
KTaskDescriptorType GetKTaskDescriptor(void)
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require
      safeExec(LastSeen(before), abs_get_ktask_descriptor, X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(__return), X) &&
      OutsideCritical(sg, after)
 */;

/* 复用 ktask_suspend.c 已验证包装层；known 规格由通用规格精化。 */
x_err_t SuspendKTask(int32 id)
/*@ suspend_by_id_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require id < 65536 && os_inv(sg, before)
    Ensure exists (found : Z) (after : VarGlobalState),
      found != 0 && get_task_with_idnode_success(sg, before, id, found) &&
      ktask_suspend_step(found, before, __return, after) && os_inv(sg, after)
 */;

x_err_t SuspendKTask(int32 id)
/*@ suspend_known_ic <= suspend_by_id_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
         (task : Z) (desc : TaskDescriptorAbs)
    Require id < 65536 &&
      get_task_with_idnode_success(sg, before, id, task) &&
      before.os_tasks.task_desc_map(task) == Some(desc) &&
      os_inv(sg, before)
    Ensure exists after,
      ktask_suspend_step(task, before, __return, after) && os_inv(sg, after)
 */;

/* 查询得到已知任务后，忽略 C 唤醒返回值；纯步骤仍记录真实后态。 */
x_err_t KTaskWakeup(int32 id)
/*@ delay_known_wakeup_ic <= wakeup_by_id_ic
    With (sg : StableGlobalState) (before : VarGlobalState) (task : Z)
    Require id < 65536 && get_task_with_idnode_success(sg, before, id, task) && os_inv(sg, before)
    Ensure exists after,
      nrm(ktask_delay_wakeup_locked(sg, task), before, tt, after) && os_inv(sg, after)
 */;

/*
 * 来源：../crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c。
 * 按“源代码处理.md”导入 _DelayKTask 和 DelayKTask 的锁外切片：
 * 注释打印，NULL_PARAM_CHECK -> NULL_PARAM_CHECK_1，
 * DO_KTASK_ASSIGN -> KTASK_ASSIGN()，其规格复用 ktask_assign_oc.h。
 * task->Done 在任务初始化时指向 Done，Done.delay 指向 _DelayKTask。
 *
 * 保留 _DelayKTask 的原有临界区。锁内的 SuspendKTask、
 * KTaskSetDelay、KTaskWakeup 复用 kernel/thread/ 下的切片；其被调
 * 函数中的嵌套加解锁已注释。按 2026-10-24 用户授权，切片检查
 * SuspendKTask 的返回值，失败时解锁并立即返回，跳过 SetDelay 和调度；
 * 此行为变更只用于切片，../crtos 原实现仍忽略该返回值，见“源代码处理.md”。
 * 调度后的 exstatus 读取与条件写入分别加锁，分支使用局部读取值；
 * 与 outside_critical/access_exstatus_oc.c 的处理一致。
 * DelayKTask 的 GetKTaskDescriptor 使用 outside_critical/
 * get_task_descriptor_oc.c，保留查询自身的临界区。
 * 两个入口的 OC Spec 与 Stage 2 注解使用原生 safeExec；checked 调用条件见
 * libai/KTaskDelay.v。零参数 / 空 getter 分支不虚构临界区，失败后的
 * 唤醒不承诺恢复原态；成功返回也不承诺经过指定时长或任务仍然发布。
 * 完整 VC 接口由 ktask_delay_checked.v 检查，包含本文件的 DelayKTask 包装层。
 * 显式 0 <= ticks/tick 仅记录 uint32 参数的表示范围，不增加调度语义条件。
 */

/**
 * This function will delay current task running with some ticks.
 *
 * @param tick delay ticks
 *
 */
x_err_t _DelayKTask(KTaskDescriptorType task, x_ticks_t ticks)
/*@ delay_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require
      0 <= ticks &&
      safeExec(LastSeen(before), abs_ktask_delay(sg, task, ticks), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(__return), X) &&
      OutsideCritical(sg, after)
 */
{
    x_base lock = 0;
    x_err_t err = EOK;
    x_err_t exstatus = EOK;

    NULL_PARAM_CHECK_1(task);

    if (ticks == 0) {
        // KPrintf("Timeout ticks must be setted more than 0.\n");
        return -EINVALED;
    }

    lock = CriticalAreaLock() /*@ where (ordinary) sg = sg, st1 = before */;
    /*@ Given observed from st_lock */
    /*@ task != 0 && ticks != 0 && Crtos_RTrans(before, observed) &&
        safeExec(LastSeen(before), abs_ktask_delay(sg, task, ticks), X) && os_inv(sg, observed)
        which implies exists desc,
        observed.os_tasks.task_desc_map(task) == Some(desc) &&
        delay_entry_facts(sg, task, ticks, observed) &&
        safeExec(LastSeen(before), delay_body(sg, task, ticks), X) && os_inv(sg, observed)
     */
    /*@ Given desc */
    err = SuspendKTask(task->id.id)
        /*@ where (suspend_known_ic) sg = sg, before = observed, task = task, desc = desc */;
    /*@ Given suspended from after */
    /*@ Given taskid */
    if (err != EOK) {
        CriticalAreaUnLock(lock) /*@ where (stable) */;
        return err;
    }

    /*@ ktask_suspend_step(task, observed, 0, suspended) &&
        delay_entry_facts(sg, task, ticks, observed) &&
        get_task_with_idnode_success(sg, observed, taskid, task) && os_inv(sg, suspended)
        which implies exists sdesc,
        suspended.os_tasks.task_desc_map(task) == Some(sdesc) &&
        ((ticks < KTICK_HALF_RANGE && ktask_delete_not_service(task, suspended) &&
          (sdesc.tdDelay == 0 || suspended.os_delays.delay_inactive_map(sdesc.tdDelay) != None) &&
          delay_list_window(suspended.os_tick, suspended.os_delays.delay_active_nodes) && os_inv(sg, suspended)) ||
         (ticks >= KTICK_HALF_RANGE && os_inv(sg, suspended)))
     */
    /*@ Given sdesc */
    /*@ Branch name delay_null: ticks < KTICK_HALF_RANGE && sdesc.tdDelay == 0; delay_inactive: ticks < KTICK_HALF_RANGE && suspended.os_delays.delay_inactive_map(sdesc.tdDelay) != None; delay_long: ticks >= KTICK_HALF_RANGE */
    err = KTaskSetDelay(task, ticks)
        /*@ where (delay_null_ic) sg = sg, st_before = suspended, desc = sdesc $ delay_null
            where (delay_inactive_ic) sg = sg, st_before = suspended, desc = sdesc $ delay_inactive
            where (tick_out_of_bound) $ delay_long */;
    /*@ Given set_after from st_after $ delay_null delay_inactive */
    /*@ Given delay_after $ delay_null delay_inactive */
    /*@ Assert exists set_state set_desc saved_lock set_result,
        nrm(ktask_delay_set_locked(task@pre, ticks@pre), suspended, set_result, set_state) &&
        set_state.os_tasks.task_desc_map(task@pre) == Some(set_desc) &&
        ktask_suspend_step(task@pre, observed, 0, suspended) &&
        get_task_with_idnode_success(sg, observed, taskid, task@pre) &&
        Crtos_RTrans(before, observed) &&
        safeExec(LastSeen(before), delay_body(sg, task@pre, ticks@pre), X) &&
        task@pre != 0 &&
        store_ptr(&task, task@pre) * store_uint(&ticks, ticks@pre) *
        store_int(&err, set_result) * store_int(&lock, saved_lock) * store_int(&exstatus, 0) *
        InsideCritical(sg, observed) * os_inv(sg, set_state)
     */
    /*@ Given set_state set_desc saved_lock set_result */
    /*@ Branch name delay_joined: 1 == 1 */
    if (err != EOK) {
        KTaskWakeup(task->id.id)
          /*@ where (delay_known_wakeup_ic) sg = sg, before = set_state, task = task */;
        /*@ Given wake_after from after */
        CriticalAreaUnLock(lock) /*@ where (stable) */;
        return err;
    }
    /*@ Assert
        safeExec(LastSeen(set_state), abs_ktask_assign, delay_assign_post(sg, task@pre, X)) &&
        Crtos_GTrans(observed, set_state) &&
        store_ptr(&task, task@pre) * store_uint(&ticks, ticks@pre) *
        store_int(&err, 0) * store_int(&lock, saved_lock) * store_int(&exstatus, 0) *
        InsideCritical(sg, observed) * os_inv(sg, set_state)
     */
    CriticalAreaUnLock(lock) /*@ where (stable) sg = sg, st1 = observed, st2 = set_state */;

    // 原语句：DO_KTASK_ASSIGN;
    KTASK_ASSIGN() /*@ where (outside_critical) sg = sg, before = set_state, X = delay_assign_post(sg, task, X) */;
    /*@ Given assigned from after */
    /*@ safeExec(LastSeen(assigned), return(tt), delay_assign_post(sg, task, X))
        which implies safeExec(LastSeen(assigned), delay_after_assign(sg, task), X) */

    /* 原条件中的共享读取：task->exstatus == -ETIMEOUT。 */
    lock = CriticalAreaLock() /*@ where (ordinary) sg = sg, st1 = assigned */;
    /*@ Given read_state from st_lock */
    /*@ Crtos_RTrans(assigned, read_state) &&
        safeExec(LastSeen(assigned), delay_after_assign(sg, task), X) && os_inv(sg, read_state)
        which implies exists read_desc,
        read_state.os_tasks.task_desc_map(task) == Some(read_desc) &&
        safeExec(LastSeen(assigned), delay_read_body(sg, task), X) && os_inv(sg, read_state)
     */
    /*@ Given read_desc */
    exstatus = task->exstatus;
    /*@ Assert exists read_lock value,
        safeExec(LastSeen(read_state), delay_after_read(sg, task@pre, value), X) &&
        Crtos_GTrans(read_state, read_state) &&
        store_ptr(&task, task@pre) * store_uint(&ticks, ticks@pre) *
        store_int(&err, 0) * store_int(&lock, read_lock) * store_int(&exstatus, value) *
        InsideCritical(sg, read_state) * os_inv(sg, read_state)
     */
    /*@ Given read_lock value */
    CriticalAreaUnLock(lock) /*@ where (stable) sg = sg, st1 = read_state, st2 = read_state */;

    if (exstatus == -ETIMEOUT) {
        lock = CriticalAreaLock() /*@ where (ordinary) sg = sg, st1 = read_state */;
        /*@ Given write_state from st_lock */
        /*@ value == -2 && Crtos_RTrans(read_state, write_state) &&
            safeExec(LastSeen(read_state), delay_after_read(sg, task, value), X) && os_inv(sg, write_state)
            which implies exists write_desc,
            write_state.os_tasks.task_desc_map(task) == Some(write_desc) &&
            safeExec(LastSeen(read_state), delay_write_body(task), X) && os_inv(sg, write_state)
         */
        /*@ Given write_desc */
        task->exstatus = EOK;
        /*@ Assert exists final_state write_lock,
            safeExec(LastSeen(final_state), return(0), X) &&
            Crtos_GTrans(write_state, final_state) &&
            store_ptr(&task, task@pre) * store_uint(&ticks, ticks@pre) *
            store_int(&err, 0) * store_int(&lock, write_lock) * store_int(&exstatus, value) *
            InsideCritical(sg, write_state) * os_inv(sg, final_state)
         */
        /*@ Given final_state write_lock */
        CriticalAreaUnLock(lock) /*@ where (stable) sg = sg, st1 = write_state, st2 = final_state */;
    }

    return EOK;
}

/**
 * This function will delay current task running with some ticks.
 *
 * @param tick delay ticks
 * @return EOK on success; EINVALED/EEMPTY on failure
 */
x_err_t DelayKTask(x_ticks_t tick)
/*@ delay_current_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require
      0 <= tick &&
      safeExec(LastSeen(before), abs_ktask_delay_current(sg, tick), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(__return), X) &&
      OutsideCritical(sg, after)
 */
{
    KTaskDescriptorType task = NONE;

    if (tick == 0) {
        // KPrintf("Timeout tick must be setted more than 0.\n");
        return -EINVALED;
    }

    /*@ tick != 0 && safeExec(LastSeen(before), abs_ktask_delay_current(sg, tick), X)
        which implies safeExec(LastSeen(before), abs_get_ktask_descriptor, delay_lookup_post(sg, tick, X)) */
    task = GetKTaskDescriptor()
        /*@ where (outside_critical) sg = sg, before = before, X = delay_lookup_post(sg, tick, X) */;
    /*@ Given current_seen from after */
    if (task == NONE)
    {
        return -EEMPTY;
    }
    // 原调用：task->Done->delay(task, tick)。
    /*@ task != 0 && safeExec(LastSeen(current_seen), return(task), delay_lookup_post(sg, tick, X))
        which implies safeExec(LastSeen(current_seen), abs_ktask_delay(sg, task, tick), X) */
    return _DelayKTask(task, tick) /*@ where (delay_oc) sg = sg, before = current_seen, X = X */;
}
