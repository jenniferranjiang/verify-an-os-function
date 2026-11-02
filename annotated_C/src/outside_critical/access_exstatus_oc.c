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

#include "get_ktask_descriptor_oc.h"
#include "get_isr_counter_oc.h"
#include "access_exstatus_oc_views.h"
#include "ktask_delay_views.h"
/*@ include strategies "ktask_delay_views.strategies" */
/*@ include strategies "access_exstatus_oc_views.strategies" */

/*@ Import Coq Require Import CRTOS_Verify.libai.AccessExstatusOC */
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskDelay */
/*@ Import Coq Require Import CRTOS_Verify.VC.code.outside_critical.access_exstatus_oc_lib */
/*@ Extern Coq
      (abs_kupdate_exstatusOC :
        StableGlobalState -> Z -> program (VarGlobalState -> Prop) unit)
      (abs_kobtain_exstatusOC :
        StableGlobalState -> program (VarGlobalState -> Prop) Z)
      (task_atomic_cmd : {A} -> program VarGlobalState A -> program (VarGlobalState -> Prop) A)
      (global_exstatus_set_lockedOC : Z -> program VarGlobalState unit)
      (ktask_set_exstatus_locked : Z -> Z -> program VarGlobalState unit)
      (exstatus_task_writeOC : StableGlobalState -> Z -> Z -> program (VarGlobalState -> Prop) unit)
      (update_current_postOC : StableGlobalState -> Z -> (unit -> (VarGlobalState -> Prop) -> Prop) -> Z -> (VarGlobalState -> Prop) -> Prop)
      (update_counter_postOC : StableGlobalState -> Z -> (unit -> (VarGlobalState -> Prop) -> Prop) -> Z -> (VarGlobalState -> Prop) -> Prop)
      (obtain_current_postOC : StableGlobalState -> (Z -> (VarGlobalState -> Prop) -> Prop) -> Z -> (VarGlobalState -> Prop) -> Prop)
      (obtain_counter_postOC : StableGlobalState -> (Z -> (VarGlobalState -> Prop) -> Prop) -> Z -> (VarGlobalState -> Prop) -> Prop)
 */

/*
 * 来源：../crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c。
 * 按“源代码处理.md”提取 KUpdateExstatus 和 KObtainExstatus 的锁外切片。
 * 当前 xsconfig.h 未启用 ARCH_SMP；isr.c 的 SysInitIsrManager 将
 * isrManager.done 绑定到 isrDone，其 getCounter 指向 GetIsrCounter。
 * 与 kdebug_not_in_interrupt.c 一样，直接调用以 ISR manager 已初始化为前提。
 * GetIsrCounter 使用 get_isr_counter_oc.c 中自行加锁的 OC 实现，
 * 保留原条件表达式；每次状态写入和返回地址的计算也各自加锁。
 * GetKTaskDescriptor 复用 outside_critical/get_task_descriptor_oc.c，
 * 保留该被调函数自身的临界区，不把查询和后续访问合并为一个原子操作。
 * 临界区内调用使用 kernel/thread/access_exstatus.c。
 * 原源码的两个函数没有直接的 lock/unlock；access_lock 明确标识本切片
 * 新增的短锁；计数读取的短锁迁入 OC callee，getter 的原锁保持。
 * 两个入口可以在锁外调用，
 * 调用依据与 libc 配置限制见 2026-10-25-04-OC-Stage1 报告。
 * 已审阅的 OC 合同按各次观察分别组合；完整 VC 检查见 check-exstatus-oc。
 * OutsideCritical 中的 os_global_context 绑定 Assign、ISR manager 与
 * 本翻译单元的 __exstatus；不在公开 Spec 中暴露锁内共享内存。
 */

static volatile int __exstatus;

/*
 * update the exception status
 *
 */
void KUpdateExstatus(x_err_t status)
/*@ update_exstatus_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require
      safeExec(LastSeen(before), abs_kupdate_exstatusOC(sg, status), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) &&
      OutsideCritical(sg, after)
 */
{
    x_base access_lock = 0;

    if (status < EOK || status >= INVALID_TASK_ERROR) {
        // KPrintf("Illegal status code %d\n", status);
        return;
    }

    /*@ 0 <= status && status < 11 &&
        safeExec(LastSeen(before), abs_kupdate_exstatusOC(sg, status), X) &&
        OutsideCritical(sg, before)
        which implies
        0 <= status && status < 11 &&
        os_exstatus_slot(sg) == &__exstatus &&
        safeExec(LastSeen(before), abs_get_isr_counterOC, update_counter_postOC(sg, status, X)) &&
        OutsideCritical(sg, before)
     */
    /* 原调用：isrManager.done->getCounter()；OC callee 自行加锁。 */
    if (GetIsrCounter()
        /*@ where (get_isr_counter_oc) sg = sg, before = before, X = update_counter_postOC(sg, status, X) */ == 0) {
        /*@ Given count_seen from after */
        /*@ safeExec(LastSeen(count_seen), return(0), update_counter_postOC(sg, status, X)) &&
            OutsideCritical(sg, count_seen)
            which implies
            safeExec(LastSeen(count_seen), abs_get_ktask_descriptor, update_current_postOC(sg, status, X)) &&
            OutsideCritical(sg, count_seen)
         */
        KTaskDescriptorType CurrentTask;
        CurrentTask = GetKTaskDescriptor()
            /*@ where (outside_critical) sg = sg, before = count_seen, X = update_current_postOC(sg, status, X) */;
        /*@ Given task_seen from after */
        if (CurrentTask != NONE) {
            /*@ CurrentTask != 0 &&
                safeExec(LastSeen(task_seen), return(CurrentTask), update_current_postOC(sg, status, X)) &&
                OutsideCritical(sg, task_seen)
                which implies
                safeExec(LastSeen(task_seen), exstatus_task_writeOC(sg, CurrentTask, status), X) &&
                OutsideCritical(sg, task_seen)
             */
            access_lock = CriticalAreaLock()
                /*@ where (ordinary) sg = sg, st1 = task_seen */;
            /*@ Given observed from st_lock */
            /*@ Crtos_RTrans(task_seen, observed) &&
                safeExec(LastSeen(task_seen), exstatus_task_writeOC(sg, CurrentTask, status), X) &&
                InsideCritical(sg, observed) * os_inv(sg, observed)
                which implies exists desc,
                observed.os_tasks.task_desc_map(CurrentTask) == Some(desc) &&
                Crtos_RTrans(task_seen, observed) &&
                safeExec(LastSeen(task_seen), task_atomic_cmd(ktask_set_exstatus_locked(CurrentTask, -status)), X) &&
                InsideCritical(sg, observed) * os_inv(sg, observed)
             */
            /*@ Given desc */
            CurrentTask->exstatus = -status;
            /*@ observed.os_tasks.task_desc_map(CurrentTask) == Some(desc) &&
                Crtos_RTrans(task_seen, observed) &&
                safeExec(LastSeen(task_seen), task_atomic_cmd(ktask_set_exstatus_locked(CurrentTask, -status)), X) &&
                InsideCritical(sg, observed) *
                os_inv(sg, replace_task_desc_map(update_task_desc_map(CurrentTask,
                  replace_descriptor_exstatus(-status, desc), observed.os_tasks.task_desc_map), observed))
                which implies exists written,
                safeExec(LastSeen(written), return(tt), X) &&
                Crtos_GTrans(observed, written) &&
                store(&status, int, status) * store_ptr(&CurrentTask, CurrentTask) *
                InsideCritical(sg, observed) * os_inv(sg, written)
             */
            /*@ Given written */
            CriticalAreaUnLock(access_lock)
                /*@ where (stable) sg = sg, st1 = observed, st2 = written */;
        } else {
            /*@ safeExec(LastSeen(task_seen), return(0), update_current_postOC(sg, status, X)) &&
                OutsideCritical(sg, task_seen)
                which implies
                safeExec(LastSeen(task_seen), task_atomic_cmd(global_exstatus_set_lockedOC(-status)), X) &&
                OutsideCritical(sg, task_seen)
             */
            access_lock = CriticalAreaLock()
                /*@ where (ordinary) sg = sg, st1 = task_seen */;
            /*@ Given observed from st_lock */
            __exstatus = -status;
            /*@ Crtos_RTrans(task_seen, observed) &&
                safeExec(LastSeen(task_seen), task_atomic_cmd(global_exstatus_set_lockedOC(-status)), X) &&
                InsideCritical(sg, observed) * os_inv(sg, replace_global_exstatus(-status, observed))
                which implies
                safeExec(LastSeen(replace_global_exstatus(-status, observed)), return(tt), X) &&
                Crtos_GTrans(observed, replace_global_exstatus(-status, observed)) &&
                InsideCritical(sg, observed) * os_inv(sg, replace_global_exstatus(-status, observed))
             */
            CriticalAreaUnLock(access_lock)
                /*@ where (stable) sg = sg, st1 = observed, st2 = replace_global_exstatus(-status, observed) */;
            return;
        }
    } else {
        /*@ Given count_seen from after */
        /*@ Assert exists count,
            count != 0 && status == status@pre && access_lock == 0 &&
            0 <= status && status < 11 && os_exstatus_slot(sg) == &__exstatus &&
            safeExec(LastSeen(count_seen), return(count), update_counter_postOC(sg, status, X)) &&
            OutsideCritical(sg, count_seen) */
        /*@ Given count */
        /*@ count != 0 &&
            safeExec(LastSeen(count_seen), return(count), update_counter_postOC(sg, status, X)) &&
            OutsideCritical(sg, count_seen)
            which implies
            safeExec(LastSeen(count_seen), task_atomic_cmd(global_exstatus_set_lockedOC(-status)), X) &&
            OutsideCritical(sg, count_seen)
         */
        access_lock = CriticalAreaLock()
            /*@ where (ordinary) sg = sg, st1 = count_seen */;
        /*@ Given observed from st_lock */
        __exstatus = -status;
        /*@ Crtos_RTrans(count_seen, observed) &&
            safeExec(LastSeen(count_seen), task_atomic_cmd(global_exstatus_set_lockedOC(-status)), X) &&
            InsideCritical(sg, observed) * os_inv(sg, replace_global_exstatus(-status, observed))
            which implies
            safeExec(LastSeen(replace_global_exstatus(-status, observed)), return(tt), X) &&
            Crtos_GTrans(observed, replace_global_exstatus(-status, observed)) &&
            InsideCritical(sg, observed) * os_inv(sg, replace_global_exstatus(-status, observed))
         */
        CriticalAreaUnLock(access_lock)
            /*@ where (stable) sg = sg, st1 = observed, st2 = replace_global_exstatus(-status, observed) */;
        return;
    }
}

/**
 * obtain current exception status
 *
 * 返回表达式只计算地址，不读取 exstatus 的值；保持原始指针返回接口。
 * 锁内保存原返回地址，解锁后返回；不授予调用者锁外解引用该地址的权限。
 */
int *KObtainExstatus(void)
/*@ obtain_exstatus_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require
      safeExec(LastSeen(before), abs_kobtain_exstatusOC(sg), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(__return), X) &&
      OutsideCritical(sg, after)
 */
{
    x_base access_lock = 0;
    int *result = NONE;

    /*@ safeExec(LastSeen(before), abs_kobtain_exstatusOC(sg), X) && OutsideCritical(sg, before)
        which implies
        os_exstatus_slot(sg) == &__exstatus &&
        safeExec(LastSeen(before), abs_get_isr_counterOC, obtain_counter_postOC(sg, X)) &&
        OutsideCritical(sg, before)
     */
    /* 原调用：isrManager.done->getCounter()；OC callee 自行加锁。 */
    if (GetIsrCounter()
        /*@ where (get_isr_counter_oc) sg = sg, before = before, X = obtain_counter_postOC(sg, X) */ == 0) { // 中断外
        /*@ Given count_seen from after */
        /*@ safeExec(LastSeen(count_seen), return(0), obtain_counter_postOC(sg, X)) &&
            OutsideCritical(sg, count_seen)
            which implies
            safeExec(LastSeen(count_seen), abs_get_ktask_descriptor, obtain_current_postOC(sg, X)) &&
            OutsideCritical(sg, count_seen)
         */
        KTaskDescriptorType CurrentTask;
        CurrentTask = GetKTaskDescriptor()
            /*@ where (outside_critical) sg = sg, before = count_seen, X = obtain_current_postOC(sg, X) */;
        /*@ Given task_seen from after */
        if (CurrentTask != NONE) {
            /*@ CurrentTask != 0 &&
                safeExec(LastSeen(task_seen), return(CurrentTask), obtain_current_postOC(sg, X)) &&
                OutsideCritical(sg, task_seen)
                which implies
                safeExec(LastSeen(task_seen), task_atomic_cmd(return(&(CurrentTask->exstatus))), X) &&
                OutsideCritical(sg, task_seen)
             */
            access_lock = CriticalAreaLock()
                /*@ where (ordinary) sg = sg, st1 = task_seen */;
            /*@ Given observed from st_lock */
            result = (int *) & (CurrentTask->exstatus);
            /*@ Crtos_RTrans(task_seen, observed) &&
                safeExec(LastSeen(task_seen), task_atomic_cmd(return(result)), X) &&
                InsideCritical(sg, observed) * os_inv(sg, observed)
                which implies
                safeExec(LastSeen(observed), return(result), X) &&
                Crtos_GTrans(observed, observed) &&
                InsideCritical(sg, observed) * os_inv(sg, observed)
             */
            CriticalAreaUnLock(access_lock)
                /*@ where (stable) sg = sg, st1 = observed, st2 = observed */;
            return result;
        } else {
            /*@ safeExec(LastSeen(task_seen), return(0), obtain_current_postOC(sg, X)) &&
                OutsideCritical(sg, task_seen)
                which implies
                safeExec(LastSeen(task_seen), task_atomic_cmd(return(os_exstatus_slot(sg))), X) &&
                OutsideCritical(sg, task_seen)
             */
            access_lock = CriticalAreaLock()
                /*@ where (ordinary) sg = sg, st1 = task_seen */;
            /*@ Given observed from st_lock */
            result = (int *)&__exstatus;
            /*@ Crtos_RTrans(task_seen, observed) &&
                safeExec(LastSeen(task_seen), task_atomic_cmd(return(result)), X) &&
                InsideCritical(sg, observed) * os_inv(sg, observed)
                which implies
                safeExec(LastSeen(observed), return(result), X) &&
                Crtos_GTrans(observed, observed) &&
                InsideCritical(sg, observed) * os_inv(sg, observed)
             */
            CriticalAreaUnLock(access_lock)
                /*@ where (stable) sg = sg, st1 = observed, st2 = observed */;
            return result;
        }
    } else {
        /*@ Given count_seen from after */
        /*@ Assert exists count,
            count != 0 && access_lock == 0 && result == 0 &&
            os_exstatus_slot(sg) == &__exstatus &&
            safeExec(LastSeen(count_seen), return(count), obtain_counter_postOC(sg, X)) &&
            OutsideCritical(sg, count_seen) */
        /*@ Given count */
        /*@ count != 0 &&
            safeExec(LastSeen(count_seen), return(count), obtain_counter_postOC(sg, X)) &&
            OutsideCritical(sg, count_seen)
            which implies
            safeExec(LastSeen(count_seen), task_atomic_cmd(return(os_exstatus_slot(sg))), X) &&
            OutsideCritical(sg, count_seen)
         */
        access_lock = CriticalAreaLock()
            /*@ where (ordinary) sg = sg, st1 = count_seen */;
        /*@ Given observed from st_lock */
        result = (int *)&__exstatus;
        /*@ Crtos_RTrans(count_seen, observed) &&
            safeExec(LastSeen(count_seen), task_atomic_cmd(return(result)), X) &&
            InsideCritical(sg, observed) * os_inv(sg, observed)
            which implies
            safeExec(LastSeen(observed), return(result), X) &&
            Crtos_GTrans(observed, observed) &&
            InsideCritical(sg, observed) * os_inv(sg, observed)
         */
        CriticalAreaUnLock(access_lock)
            /*@ where (stable) sg = sg, st1 = observed, st2 = observed */;
        return result;
    }
}
