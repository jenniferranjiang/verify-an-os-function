#ifndef KTASK_SET_STATUS_H
#define KTASK_SET_STATUS_H

#include "m_ktask.h"
#include "m_stdbool.h"


/*@ Import Coq Require Import CRTOS_Verify.libai.TaskStatusMemory */
/*@ include strategies "task_status.strategies" */

void KTaskStateSet(KTaskDescriptorType task, uint8 stat)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure  store_task_status(&(task->task_dync_sched_member.stat), decode_task_status(stat))
*/
;

void KTaskStatSetAsInit(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure  store_task_status(&(task->task_dync_sched_member.stat), TSK_INIT)
*/
;

void KTaskStatSetAsReady(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure  store_task_status(&(task->task_dync_sched_member.stat), TSK_READY)
*/
;

void KTaskStatSetAsSuspend(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure  store_task_status(&(task->task_dync_sched_member.stat), TSK_SUSPEND)
*/
;

void KTaskStatSetAsRunning(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure  store_task_status(&(task->task_dync_sched_member.stat), TSK_RUNNING)
*/
;

void KTaskStatSetAsClose(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure  store_task_status(&(task->task_dync_sched_member.stat), TSK_CLOSE)
*/
;

uint8 KTaskStatGet(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure task_status_matches(old_stat, __return) &&
           store_task_status(&(task->task_dync_sched_member.stat), old_stat)
*/
;

BOOL JudgeKTaskStatIsInit(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure ((__return == 1 && old_stat == TSK_INIT) ||
            (__return == 0 && old_stat != TSK_INIT)) &&
           store_task_status(&(task->task_dync_sched_member.stat), old_stat)
*/
;

BOOL JudgeKTaskStatIsReady(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure ((__return == 1 && old_stat == TSK_READY) ||
            (__return == 0 && old_stat != TSK_READY)) &&
           store_task_status(&(task->task_dync_sched_member.stat), old_stat)
*/
;

BOOL JudgeKTaskStatIsSuspend(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure ((__return == 1 && old_stat == TSK_SUSPEND) ||
            (__return == 0 && old_stat != TSK_SUSPEND)) &&
           store_task_status(&(task->task_dync_sched_member.stat), old_stat)
*/
;

BOOL JudgeKTaskStatIsRunning(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure ((__return == 1 && old_stat == TSK_RUNNING) ||
            (__return == 0 && old_stat != TSK_RUNNING)) &&
           store_task_status(&(task->task_dync_sched_member.stat), old_stat)
*/
;

BOOL JudgeKTaskStatIsClose(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure ((__return == 1 && old_stat == TSK_CLOSE) ||
            (__return == 0 && old_stat != TSK_CLOSE)) &&
           store_task_status(&(task->task_dync_sched_member.stat), old_stat)
*/
;

#endif
