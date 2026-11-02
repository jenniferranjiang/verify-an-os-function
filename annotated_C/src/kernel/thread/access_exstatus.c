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

#include "access_exstatus_view.h"
#include "m_isr.h"

/*@ include strategies "access_exstatus_view.strategies" */

/*
 * 来源：../crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c。
 * 按“源代码处理.md”提取 KUpdateExstatus 和 KObtainExstatus 的锁内切片。
 * 调用者已持有临界区；原函数没有加解锁语句，此处也不新增。
 * 当前 xsconfig.h 未启用 ARCH_SMP；isr.c 的 SysInitIsrManager 将
 * isrManager.done 绑定到 isrDone，其 getCounter 指向 GetIsrCounter。
 * 与 kdebug_not_in_interrupt.c 一样，直接调用以 ISR manager 已初始化为前提。
 * GetKTaskDescriptor 复用 kernel/thread/get_ktask_descriptor.c 的锁内切片，
 * 其中原有的嵌套加解锁已注释；共享访问使用调用者持有的资源。
 * 锁外调用使用 outside_critical/access_exstatus_oc.c。
 * 两个入口只借还 task_inv、assign_inv、exstatus_inv 和 ISR 计数槽。
 * GetIsrCounter 的读取权限不在前三者中，因此单独列出 unsigned short 单元。
 * Assign 与 __exstatus 的地址绑定显式给出，不要求完整 os_global_context。
 * InsideCritical token 和其他子系统资源留在调用者 frame，不要求整个 os_inv。
 * 返回指针不复制槽的所有权；解引用时从 task_inv 或 exstatus_inv 聚焦资源。
 * access_exstatus_view 策略按需借还 running 指针及 exstatus 写权限。
 * 完整 VC 接口由 access_exstatus_checked.v 检查，不依赖 proof_auto 占位。
 */

static volatile int __exstatus;

/* 复用 kdebug_not_in_interrupt.c 中已验证的临界区内计数读取接口。 */
uint16 GetIsrCounter(void)
/*@ With count
    Require store(&(isrManager.isr_count), unsigned short, count)
    Ensure __return == count &&
           store(&(isrManager.isr_count), unsigned short, count)
 */;

/* 与 get_ktask_descriptor.c 的 inside_critical Spec 保持一致。 */
KTaskDescriptorType GetKTaskDescriptor(void)
/*@ inside_critical
    With (running_task : Z)
    Require store_ptr(&(Assign.os_running_task), running_task)
    Ensure __return == running_task &&
           store_ptr(&(Assign.os_running_task), running_task)
 */;

/*
 * update the exception status
 *
 * 非法 status 原态返回；合法 status 写入 -status，其他状态分量保持。
 */
void KUpdateExstatus(x_err_t status)
/*@ inside_critical
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require
      sg.os_assign_stable.assign_ptr == &Assign &&
      os_exstatus_slot(sg) == &__exstatus &&
      task_inv(sg, before) * assign_inv(sg, before) *
      exstatus_inv(sg, before) *
      store(&(isrManager.isr_count), unsigned short, before.os_isr.isrCount)
    Ensure exists after,
      kupdate_exstatus_step(status, before, after) &&
      task_inv(sg, after) * assign_inv(sg, after) *
      exstatus_inv(sg, after) *
      store(&(isrManager.isr_count), unsigned short, after.os_isr.isrCount)
 */
{
    if (status < EOK || status >= INVALID_TASK_ERROR) {
        // KPrintf("Illegal status code %d\n", status);
        return;
    }

    /* 原调用：isrManager.done->getCounter()。 */
    if (GetIsrCounter() == 0) {
        KTaskDescriptorType CurrentTask;
        CurrentTask = GetKTaskDescriptor();
        if (CurrentTask != NONE) {
            CurrentTask->exstatus = -status;
        } else {
            __exstatus = -status;
            return;
        }
    } else {
        __exstatus = -status;
        return;
    }
}

/**
 * obtain current exception status
 *
 * 返回表达式只计算地址，不读取 exstatus 的值；保持原始指针返回接口。
 * ISR 计数非零或当前任务为空时返回全局槽，否则返回当前任务的字段槽。
 * 各资源原样归还；目标槽仍由 task_inv 或 exstatus_inv 持有，不重复授予权限。
 */
int *KObtainExstatus(void)
/*@ inside_critical
    With (sg : StableGlobalState) (st : VarGlobalState)
    Require
      sg.os_assign_stable.assign_ptr == &Assign &&
      os_exstatus_slot(sg) == &__exstatus &&
      task_inv(sg, st) * assign_inv(sg, st) * exstatus_inv(sg, st) *
      store(&(isrManager.isr_count), unsigned short, st.os_isr.isrCount)
    Ensure
      exstatus_slot(sg, st, __return) &&
      task_inv(sg, st) * assign_inv(sg, st) * exstatus_inv(sg, st) *
      store(&(isrManager.isr_count), unsigned short, st.os_isr.isrCount)
 */
{
    /* 原调用：isrManager.done->getCounter()。 */
    if (GetIsrCounter() == 0) { // 中断外
        KTaskDescriptorType CurrentTask;
        CurrentTask = GetKTaskDescriptor();
        if (CurrentTask != NONE) {
            return (int *) & (CurrentTask->exstatus);
        } else {
            return (int *)&__exstatus;
        }
    } else {
        return (int *)&__exstatus;
    }
}
