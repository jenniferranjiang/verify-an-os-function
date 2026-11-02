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
#include "xs_ktick.h"
#include "monad.h"

/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskMDelay */
/*@ Import Coq Require Import CRTOS_Verify.VC.code.kernel.thread.ktask_mdelay_lib */
/*@ Extern Coq
      (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
      (abs_get_ktask_descriptor : program (VarGlobalState -> Prop) Z)
      (abs_ktask_delay : StableGlobalState -> Z -> Z -> program (VarGlobalState -> Prop) Z)
      (abs_ktask_mdelay : StableGlobalState -> Z -> Z -> program (VarGlobalState -> Prop) Z)
      (abs_ktask_mdelay_current : StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
      (tick_from_time_ms : Z -> Z)
      (mdelay_lookup_post : StableGlobalState -> Z -> (Z -> (VarGlobalState -> Prop) -> Prop) -> Z -> (VarGlobalState -> Prop) -> Prop)
 */

/* 与 outside_critical/get_task_descriptor_oc.c 的 OC 接口一致。 */
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

/* 与 tick.c 的已验证纯换算接口一致，调用者的 OC 资源留在 frame。 */
x_ticks_t CalculateTickFromTimeMs(uint32 ms)
/*@ Require
      0 <= ms && ms <= UINT_MAX && emp
    Ensure
      __return == tick_from_time_ms(ms) && emp
 */;

/* 与 ktask_delay.c 已验证接口一致；非负性来自无符号 tick 换算。 */
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
 */;

/*
 * 来源：../crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c。
 * 按“源代码处理.md”导入 _MdelayKTask 和 MdelayKTask 的锁外切片：
 * NULL_PARAM_CHECK -> NULL_PARAM_CHECK_1；task->Done 在任务初始化时
 * 指向 Done，Done.mdelay 指向 _MdelayKTask，故改为直接调用。
 * CalculateTickFromTimeMs 复用 tick.c 的实现，不改换算或零值分支。
 * _DelayKTask 使用 ktask_delay.c；GetKTaskDescriptor 使用
 * outside_critical/get_task_descriptor_oc.c，保留被调函数自身的锁。
 * 两个函数没有其他共享内存访问，无需新增临界区。
 * 两个入口的 OC Spec 与抽象组合见 libai/KTaskMDelay.v；纯换算不增加锁边界。
 * 沿用实际 uint32 换算，继承 _DelayKTask 的 checked 条件。
 * Spec 中的 ms 范围记录 uint32 参数表示，不添加调度语义条件。
 */

/**
 * This function will delay current task wite milliseconds.
 *
 * @param ms milliseconds of delay time
 *
 */
x_err_t _MdelayKTask(KTaskDescriptorType task, uint32 ms)
/*@ mdelay_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require
      0 <= ms && ms <= UINT_MAX &&
      safeExec(LastSeen(before), abs_ktask_mdelay(sg, task, ms), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(__return), X) &&
      OutsideCritical(sg, after)
 */
{
    x_ticks_t ticks = 0;

    NULL_PARAM_CHECK_1(task);

    if (0 == ms) {
        return -EINVALED;
    }

    ticks = CalculateTickFromTimeMs(ms);

    /*@ task != 0 && ms@pre != 0 && ticks == tick_from_time_ms(ms@pre) &&
        safeExec(LastSeen(before), abs_ktask_mdelay(sg, task, ms@pre), X)
        which implies 0 <= ticks &&
        safeExec(LastSeen(before), abs_ktask_delay(sg, task, ticks), X) */
    return  _DelayKTask(task, ticks) /*@ where (delay_oc) sg = sg, before = before, X = X */;
}

/**
 * This function will delay current task wite milliseconds.
 *
 * @param ms milliseconds of delay time
 *
 * @return EOK on success; EINVALED/EEMPTY on failure
 *
 */
x_err_t MdelayKTask(uint32 ms)
/*@ mdelay_current_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require
      0 <= ms && ms <= UINT_MAX &&
      safeExec(LastSeen(before), abs_ktask_mdelay_current(sg, ms), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(__return), X) &&
      OutsideCritical(sg, after)
 */
{
    KTaskDescriptorType task = NONE;

    if (0 == ms) {
        return -EINVALED;
    }

    /*@ ms != 0 && safeExec(LastSeen(before), abs_ktask_mdelay_current(sg, ms), X)
        which implies safeExec(LastSeen(before), abs_get_ktask_descriptor, mdelay_lookup_post(sg, ms, X)) */
    task = GetKTaskDescriptor()
        /*@ where (outside_critical) sg = sg, before = before, X = mdelay_lookup_post(sg, ms, X) */;
    /*@ Given current_seen from after */
    if (task == NONE)
    {
        return -EEMPTY;
    }
    // 原调用：task->Done->mdelay(task, ms)。
    /*@ task != 0 && safeExec(LastSeen(current_seen), return(task), mdelay_lookup_post(sg, ms, X))
        which implies safeExec(LastSeen(current_seen), abs_ktask_mdelay(sg, task, ms), X) */
    return _MdelayKTask(task, ms) /*@ where (mdelay_oc) sg = sg, before = current_seen, X = X */;
}
