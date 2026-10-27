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

/**
* @file:    ktask_stat.c
* @brief:   the stat function definition of task
* @version: 1.0
* @author:  AIIT XUOS Lab
* @date:    2020/3/15
*
*/

#ifndef XS_KTASK_STAT_H
#define XS_KTASK_STAT_H

#include "xs_kdbg.h"
#include "xs_base.h"
#include "m_ktask.h"
#include "m_stdbool.h"

/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskPure */

/*@ Import Coq Require Import CRTOS_Verify.libai.TaskStatusMemory */
/*@ include strategies "task_status.strategies" */

void KTaskStateSet(KTaskDescriptorType task, uint8 stat)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure  store_task_status(&(task->task_dync_sched_member.stat), decode_task_status(stat))
*/
{
    NULL_PARAM_CHECK_1(task);
	task->task_dync_sched_member.stat = stat | (task->task_dync_sched_member.stat & ~KTASK_STAT_MASK);
}

void KTaskStatSetAsInit(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure  store_task_status(&(task->task_dync_sched_member.stat), TSK_INIT)
*/
{
    NULL_PARAM_CHECK_1(task);
	KTaskStateSet(task, KTASK_INIT);
}

void KTaskStatSetAsReady(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure  store_task_status(&(task->task_dync_sched_member.stat), TSK_READY)
*/
{
    NULL_PARAM_CHECK_1(task);
	KTaskStateSet(task, KTASK_READY);
}

void KTaskStatSetAsSuspend(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure  store_task_status(&(task->task_dync_sched_member.stat), TSK_SUSPEND)
*/
{
    NULL_PARAM_CHECK_1(task);
	KTaskStateSet(task, KTASK_SUSPEND);
}

void KTaskStatSetAsRunning(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure  store_task_status(&(task->task_dync_sched_member.stat), TSK_RUNNING)
*/
{
    NULL_PARAM_CHECK_1(task);
	KTaskStateSet(task, KTASK_RUNNING);
}

void KTaskStatSetAsClose(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure  store_task_status(&(task->task_dync_sched_member.stat), TSK_CLOSE)
*/
{
    NULL_PARAM_CHECK_1(task);
	KTaskStateSet(task, KTASK_CLOSE);
}

uint8 KTaskStatGet(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure task_status_matches(old_stat, __return) &&
            store_task_status(&(task->task_dync_sched_member.stat), old_stat)
*/
{
    NULL_PARAM_CHECK_1(task);
    return task->task_dync_sched_member.stat & KTASK_STAT_MASK;
}

BOOL JudgeKTaskStatIsInit(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure ((__return == 1 && old_stat == TSK_INIT) ||
            (__return == 0 && old_stat != TSK_INIT)) &&
            store_task_status(&(task->task_dync_sched_member.stat), old_stat)
*/
{
    NULL_PARAM_CHECK_1(task);
    return ((task->task_dync_sched_member.stat & KTASK_STAT_MASK) == KTASK_INIT);
}

BOOL JudgeKTaskStatIsReady(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure ((__return == 1 && old_stat == TSK_READY) ||
            (__return == 0 && old_stat != TSK_READY)) &&
            store_task_status(&(task->task_dync_sched_member.stat), old_stat)
*/
{
    NULL_PARAM_CHECK_1(task);
    return ((task->task_dync_sched_member.stat & KTASK_STAT_MASK) == KTASK_READY);
}

BOOL JudgeKTaskStatIsSuspend(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure ((__return == 1 && old_stat == TSK_SUSPEND) ||
            (__return == 0 && old_stat != TSK_SUSPEND)) &&
            store_task_status(&(task->task_dync_sched_member.stat), old_stat)
*/
{
    NULL_PARAM_CHECK_1(task);
    return ((task->task_dync_sched_member.stat & KTASK_STAT_MASK) == KTASK_SUSPEND);
}

BOOL JudgeKTaskStatIsRunning(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure ((__return == 1 && old_stat == TSK_RUNNING) ||
            (__return == 0 && old_stat != TSK_RUNNING)) &&
            store_task_status(&(task->task_dync_sched_member.stat), old_stat)
*/
{
    NULL_PARAM_CHECK_1(task);
    return ((task->task_dync_sched_member.stat & KTASK_STAT_MASK) == KTASK_RUNNING);
}

BOOL JudgeKTaskStatIsClose(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure ((__return == 1 && old_stat == TSK_CLOSE) ||
            (__return == 0 && old_stat != TSK_CLOSE)) &&
            store_task_status(&(task->task_dync_sched_member.stat), old_stat)
*/
{
    NULL_PARAM_CHECK_1(task);
    return ((task->task_dync_sched_member.stat & KTASK_STAT_MASK) == KTASK_CLOSE);
}

#endif
