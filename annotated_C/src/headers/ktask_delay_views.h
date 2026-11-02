#ifndef CRTOS_KTASK_DELAY_VIEWS_H
#define CRTOS_KTASK_DELAY_VIEWS_H
#include "ktask_set_delay.h"
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskDelayFrame */
/*@ Import Coq Require Import CRTOS_Verify.libai.TaskExstatusView */
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskDeleteSpec */
/*@ Extern Coq
 (delay_exstatus_frame : StableGlobalState -> VarGlobalState -> Z -> TaskDescriptorAbs -> Assertion)
 (replace_descriptor_exstatus : Z -> TaskDescriptorAbs -> TaskDescriptorAbs)
 (update_task_desc_map : Z -> TaskDescriptorAbs -> (Z -> option TaskDescriptorAbs) -> Z -> option TaskDescriptorAbs)
 (delay_global_frame : StableGlobalState -> VarGlobalState -> Assertion)
 (ktask_set_delay_task_frame : StableGlobalState -> VarGlobalState -> Z -> TaskDescriptorAbs -> Assertion)
 (ktask_delete_not_service : Z -> VarGlobalState -> Prop)
 */

/* 单分支派生规格仅固定 N/U 的选择，避免调用点把 NULL 路径选成 inactive。 */
x_err_t KTaskSetDelay(struct TaskDescriptor *task, x_ticks_t ticks)
/*@ delay_null_ic <= for_null_inactive
    With (sg : StableGlobalState) (st_before : VarGlobalState)
         (desc : TaskDescriptorAbs)
    Require 0 <= ticks && ticks < KTICK_HALF_RANGE &&
            st_before.os_tasks.task_desc_map(task) == Some(desc) &&
            os_global_context(sg) &&
            desc.tdDelay == 0 &&
            delay_list_window(st_before.os_tick,
              st_before.os_delays.delay_active_nodes) &&
            store_ptr(&(task->task_dync_sched_member.delay), desc.tdDelay) *
            delay_inv(sg, st_before) *
            tick_inv(sg, st_before)
    Ensure exists st_after delay_after,
             ktask_set_delay_step(
               task, desc, ticks, delay_after,
               st_before, __return, st_after) &&
             store_ptr(&(task->task_dync_sched_member.delay), delay_after) *
             delay_inv(sg, st_after) *
             tick_inv(sg, st_after)
 */
;
x_err_t KTaskSetDelay(struct TaskDescriptor *task, x_ticks_t ticks)
/*@ delay_inactive_ic <= for_null_inactive
    With (sg : StableGlobalState) (st_before : VarGlobalState)
         (desc : TaskDescriptorAbs)
    Require 0 <= ticks && ticks < KTICK_HALF_RANGE &&
            st_before.os_tasks.task_desc_map(task) == Some(desc) &&
            os_global_context(sg) &&
            st_before.os_delays.delay_inactive_map(desc.tdDelay) != None &&
            delay_list_window(st_before.os_tick,
              st_before.os_delays.delay_active_nodes) &&
            store_ptr(&(task->task_dync_sched_member.delay), desc.tdDelay) *
            delay_inv(sg, st_before) *
            tick_inv(sg, st_before)
    Ensure exists st_after delay_after,
             ktask_set_delay_step(
               task, desc, ticks, delay_after,
               st_before, __return, st_after) &&
             store_ptr(&(task->task_dync_sched_member.delay), delay_after) *
             delay_inv(sg, st_after) *
             tick_inv(sg, st_after)
 */
;

#endif
