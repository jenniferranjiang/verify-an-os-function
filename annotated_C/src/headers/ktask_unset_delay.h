#ifndef KTASK_UNSET_DELAY_H
#define KTASK_UNSET_DELAY_H

#include "m_ktask.h"

/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskSchedDelayState */
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskUnSetDelayState */
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskUnSetDelaySpec */
/*@ Extern Coq
      (In : {A} -> A -> list A -> Prop)
      (None : {A} -> option A)
      (ktask_unset_delay_step : Z -> VarGlobalState -> VarGlobalState -> Prop)
      (unset_linked_delay_step :
        Z -> TaskDelayAbs -> VarGlobalState -> VarGlobalState -> Prop)
*/
/*@ Extern Coq (vDelayView :: *) */
/*@ Extern Coq
      (vDelayNull : vDelayView)
      (vDelayInactive : Z -> TaskDelayAbs -> vDelayView)
      (vDelayActive :
        Z -> TaskDelayAbs ->
        list(DL_Node TaskDelayAbs) ->
        list(DL_Node TaskDelayAbs) -> vDelayView)
      (store_ktask_unset_delay_pre :
        Z -> vDelayView -> Assertion)
      (store_ktask_unset_delay_post :
        Z -> vDelayView -> Assertion)
 */

/*
令 `d` 表示**被唤醒任务**的 `task_dync_sched_member.delay`，三种状态记为：

- **NULL**：`d == NULL`。
- **LONE**：`d != NULL`，但 `d->link` 已脱链，处于自链接状态。
- **LINKED**：`d->link` 挂在延时链表 `xiaoshan_delay_head` 上。
------------------------------------------------------------
- spec **null_delay** 处理NULL;
- spec **in_delay_list** 处理LINKED;
- spec **null_or_inactive** 处理NULL or LONE;
- spec **all_case_delay** 处理 NULL or LONE or LINKED；
*/
x_err_t KTaskUnSetDelay(struct TaskDescriptor *task)
/*@ unset_delay_unified
    With (delay_view : vDelayView)
    Require store_ktask_unset_delay_pre(task, delay_view)
    Ensure __return == KOK &&
      store_ktask_unset_delay_post(task, delay_view)
 */
/*@ null_delay <= unset_delay_unified
    With (sg : StableGlobalState) (st_before : VarGlobalState)
         (desc : TaskDescriptorAbs)
    Require st_before.os_tasks.task_desc_map(task) == Some(desc) &&
      desc.tdDelay == 0 &&
      store_ptr(&(task->task_dync_sched_member.delay), desc.tdDelay) *
      delay_inv(sg, st_before)
    Ensure __return == KOK &&
      store_ptr(&(task->task_dync_sched_member.delay), desc.tdDelay) *
      delay_inv(sg, st_before)
 */
/*@ in_delay_list <= unset_delay_unified
    With (sg : StableGlobalState) (st_before : VarGlobalState)
         (desc : TaskDescriptorAbs) (delay_data : TaskDelayAbs)
    Require st_before.os_tasks.task_desc_map(task) == Some(desc) &&
      sg.delay_head_ptr == &xiaoshan_delay_head &&
      desc.tdDelay != 0 &&
      In(Build_DL_Node(delay_data, field_addr(desc.tdDelay, struct Delay, link)),
         st_before.os_delays.delay_active_nodes) &&
      store_ptr(&(task->task_dync_sched_member.delay), desc.tdDelay) *
      delay_inv(sg, st_before)
    Ensure __return == KOK &&
      exists st_after,
        unset_linked_delay_step(desc.tdDelay, delay_data, st_before, st_after) &&
        store_ptr(&(task->task_dync_sched_member.delay), desc.tdDelay) *
        delay_inv(sg, st_after)
 */
/*@ null_or_inactive <= unset_delay_unified
    With (sg : StableGlobalState) (st_before : VarGlobalState)
         (desc : TaskDescriptorAbs)
    Require st_before.os_tasks.task_desc_map(task) == Some(desc) &&
      (desc.tdDelay == 0 ||
       st_before.os_delays.delay_inactive_map(desc.tdDelay) != None) &&
      store_ptr(&(task->task_dync_sched_member.delay), desc.tdDelay) *
      delay_inv(sg, st_before)
    Ensure __return == KOK &&
      store_ptr(&(task->task_dync_sched_member.delay), desc.tdDelay) *
      delay_inv(sg, st_before)
 */
/*@ all_case_delay <= unset_delay_unified
    With (sg : StableGlobalState) (st_before : VarGlobalState)
         (desc : TaskDescriptorAbs)
    Require st_before.os_tasks.task_desc_map(task) == Some(desc) &&
      sg.delay_head_ptr == &xiaoshan_delay_head &&
      store_ptr(&(task->task_dync_sched_member.delay), desc.tdDelay) *
      delay_inv(sg, st_before)
    Ensure __return == KOK &&
      exists st_after,
        ktask_unset_delay_step(desc.tdDelay, st_before, st_after) &&
        store_ptr(&(task->task_dync_sched_member.delay), desc.tdDelay) *
        delay_inv(sg, st_after)
 */
;

#endif
