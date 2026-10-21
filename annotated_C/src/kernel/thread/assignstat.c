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
* @file:    assignstat.c
* @brief:   check system read ready and task stack
* @version: 1.0
* @author:  AIIT XUOS Lab
* @date:    2020/3/15
*
*/

#include "m_assign.h"
#include "ready_init_strategy.h"
#include "ready_cache_strategy.h"
/*@ include strategies "task_sched_view.strategies" */
/*@ include strategies "ready_cache.strategies" */
/*@ include strategies "ready_init.strategies" */

/*@ Import Coq Require Import CRTOS_Verify.libai.AssignStat */

/*@ Extern Coq
      (TaskDescriptorAbs :: *)
      (TaskSchedMemberAbs :: *)
      (OsAssignReadyVectorAbs :: *)
      (DL_Node :: * => *)
 */
/*@ Extern Coq
      (getData : {A} -> DL_Node A -> Z)
      (getPtr : {A} -> DL_Node A -> Z)
      (ready_task_node : Z -> DL_Node Z)
      (ready_node_task_desc :
        (Z -> option TaskDescriptorAbs) -> DL_Node Z ->
        TaskDescriptorAbs -> Prop)
      (empty_os_assign_ready_vector : OsAssignReadyVectorAbs)
      (rrr_bucket_insert :
        (Z -> option TaskDescriptorAbs) -> TaskSchedMemberAbs ->
        DL_Node Z -> list(DL_Node Z) -> list(DL_Node Z) -> Prop)
      (os_assign_ready_vector_replace_bucket :
        OsAssignReadyVectorAbs -> Z -> list(DL_Node Z) ->
        OsAssignReadyVectorAbs)
      (assign_policy_insert_ready_vector :
        OsAssignReadyVectorAbs -> TaskSchedMemberAbs ->
        list(DL_Node Z) -> OsAssignReadyVectorAbs)
      (assign_policy_highest_after :
        OsAssignReadyVectorAbs -> TaskSchedMemberAbs -> Z)
      (has_permission_os_assign_ready_vector : Z -> Assertion)
      (store_os_assign_ready_vector_init_frontier :
        Z -> Z -> Assertion)
      (store_os_assign_ready_vector_init_frame :
        Z -> Z -> Assertion)
      (store_empty_priority_ready_buckets :
        Z -> Assertion)
      (store_assign_policy_insert_frame :
        StableGlobalState -> VarGlobalState -> Z -> Z ->
        TaskDescriptorAbs -> OsAssignReadyVectorAbs ->
        list(DL_Node Z) -> Assertion)
      (store_os_assign_ready_vector :
        Z -> OsAssignReadyVectorAbs -> Assertion)
      (os_assign_ready_vector_ok :
        (Z -> option TaskDescriptorAbs) -> OsAssignReadyVectorAbs -> Prop)

      (occupy_dll_node : Z -> Assertion)
 */

/* AssignPolicyInsert 使用借入并归还 task_inv 的 RRR helper Spec。 */
void RoundRobinRemainReadyVectorInsert(
    struct TaskDescriptor *task,
    struct OsAssignReadyVector *ready_table)
/*@ With (sg : StableGlobalState)
         (st : VarGlobalState)
         (desc : TaskDescriptorAbs)
         (before : OsAssignReadyVectorAbs)
    Require
      before == st.os_assign.assignReadyVector &&
      ready_table == assign_ready_vector_addr(sg) &&
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      task_fields(sg, st) *
      assign_ready_pending(sg, st) *
      occupy_dll_node(sched_link_of(task))
    Ensure
      task != 0 && ready_table != 0 &&
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      exists new_bucket,
        rrr_bucket_insert(
          st.os_tasks.task_desc_map, desc.tdSchedMember, ready_task_node(task),
          Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil),
          new_bucket) &&
        task_fields(sg, replace_global_ready_vector(
          os_assign_ready_vector_replace_bucket(
            before, desc.tdSchedMember.tsmCurPrio, new_bucket), st)) *
        assign_ready_pending(sg, replace_global_ready_vector(
          os_assign_ready_vector_replace_bucket(
            before, desc.tdSchedMember.tsmCurPrio, new_bucket), st))
 */
;

// #ifdef KERNEL_STACK_OVERFLOW_CHECK
/**
 * a task stack check function
 *
 * @param task task descriptor
 */
void _KTaskOsAssignStackCheck(struct TaskDescriptor *task)
/*@ With stack_point stack_start stack_depth
    Require
      store_ptr(&(task->stack_point), stack_point) *
      store_ptr(&(task->task_base_info.stack_start), stack_start) *
      store_uint(&(task->task_base_info.stack_depth), stack_depth)
    Ensure
      task != 0 &&
      stack_start < stack_point &&
      stack_point <=
        unsigned_last_nbits(stack_start + stack_depth, 32) &&
      store_ptr(&(task->stack_point), stack_point) *
      store_ptr(&(task->task_base_info.stack_start), stack_start) *
      store_uint(&(task->task_base_info.stack_depth), stack_depth)
 */
{
	NULL_PARAM_CHECK_1(task);
        if ((x_ubase)task->stack_point <= (x_ubase)task->task_base_info.stack_start
            || (x_ubase)task->stack_point > (x_ubase)task->task_base_info.stack_start + (x_ubase)task->task_base_info.stack_depth) {

            // KPrintf("task name:%s id:%d stack overflow,sp %p stacktop %p stack depth 0x%x\n",
            //     task->task_base_info.name, task->id.id, task->stack_point,
            //     (uint32*)task->task_base_info.stack_start + task->task_base_info.stack_depth,
            //     task->task_base_info.stack_depth);

            /*@ Inv Assert
                  ((stack_point <= stack_start) ||
                   (stack_point >
                     unsigned_last_nbits(
                       stack_start + stack_depth, 32))) &&
                  store_ptr(&(task->stack_point), stack_point) *
                  store_ptr(
                    &(task->task_base_info.stack_start), stack_start) *
                  store_uint(
                    &(task->task_base_info.stack_depth), stack_depth)
             */
            while (1)
                ;
        }
}
// #endif

int32 JudgeAssignReadyBitmapIsEmpty(struct OsAssignReadyVector *ready_vector)
/*@ With ready_group
    Require
      store_uint(
        &(ready_vector->priority_ready_group), ready_group)
    Ensure
      ready_vector != 0 &&
      (((ready_group == 0) && (__return == 1)) ||
       ((ready_group != 0) && (__return == 0))) &&
      store_uint(
        &(ready_vector->priority_ready_group), ready_group)
 */
{
    NULL_PARAM_CHECK_1(ready_vector);
    return ((ready_vector->priority_ready_group == 0) ? RET_TRUE: 0);
}

struct TaskDescriptor * ChooseTaskWithHighestPrio(struct OsAssignReadyVector *ready_vector)
/*@ With (task_desc_map: Z -> option TaskDescriptorAbs)
         (desc: TaskDescriptorAbs)
         (highest: Z) (first: DL_Node Z)
    Require
      0 <= highest && highest < PRIORITY_MAX &&
      addr_aligned(getData(first), ALIGN_SIZE) &&
      ready_node_task_desc(task_desc_map, first, desc) &&
      store_uint(&(ready_vector->highest_prio), highest) *
      store_ptr(
        &(ready_vector->priority_ready_vector[highest].node_next),
        getPtr(first))
    Ensure
      ready_vector != 0 &&
      __return == getData(first) &&
      __return != 0 &&
      addr_aligned(__return, ALIGN_SIZE) &&
      ready_node_task_desc(task_desc_map, first, desc) &&
      store_uint(&(ready_vector->highest_prio), highest) *
      store_ptr(
        &(ready_vector->priority_ready_vector[highest].node_next),
        getPtr(first))
 */
{
    struct TaskDescriptor *target_task = NONE;

    NULL_PARAM_CHECK_1(ready_vector);

    target_task = CONTAINER_OF_TASK_SCHED(
        ready_vector->priority_ready_vector[
          ready_vector->highest_prio].node_next)
        /*@ where task_ptr = getData(first) */;

    return target_task;
}

void OsAssignReadyVectorInit(struct OsAssignReadyVector *ready_vector)
/*@ With (task_desc_map: Z -> option TaskDescriptorAbs)
    Require
      has_permission_os_assign_ready_vector(ready_vector)
    Ensure
      ready_vector != 0 &&
      os_assign_ready_vector_ok(task_desc_map, empty_os_assign_ready_vector) &&
      store_os_assign_ready_vector(ready_vector, empty_os_assign_ready_vector)
 */
{
    register x_base prio = 0;
    NULL_PARAM_CHECK_1(ready_vector);

    /*
     * The frontier predicate says exactly that every priority in [0, prio)
     * is already an initialized empty DLL, while [prio, PRIORITY_MAX) still
     * consists of uninitialized writable sentinel cells.
     */
    /*@ Inv Assert
          ready_vector != 0 &&
          ready_vector == ready_vector@pre &&
          store_os_assign_ready_vector_init_frontier(ready_vector, prio)
     */
    while(prio < KTASK_PRIORITY_MAX)
    {
        InitDoubleLinkList(&ready_vector->priority_ready_vector[prio]);
        prio++;
    }
    ready_vector->highest_prio = 0;
    ready_vector->priority_ready_group = 0;
}

/*
 * This function will insert a task to system ready table according to sched policy(FIFO/RR/RR+remain timeslice)
 *
 * @param task task descriptor
 * @param ready_table task ready_table
 */
void AssignPolicyInsert(struct TaskDescriptor *task, struct OsAssignReadyVector* ready_table)
/*@ With (sg : StableGlobalState)
         (st : VarGlobalState)
         (desc : TaskDescriptorAbs)
         (before : OsAssignReadyVectorAbs)
    Require
      before == st.os_assign.assignReadyVector &&
      ready_table == assign_ready_vector_addr(sg) &&
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      task_fields(sg, st) *
      assign_ready_pending(sg, st) *
      occupy_dll_node(sched_link_of(task))
    Ensure
      task != 0 && ready_table != 0 &&
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      exists new_bucket,
        rrr_bucket_insert(
          st.os_tasks.task_desc_map, desc.tdSchedMember, ready_task_node(task),
          Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil),
          new_bucket) &&
        task_fields(sg, replace_global_ready_vector(
          assign_policy_insert_ready_vector(
            before, desc.tdSchedMember, new_bucket), st)) *
        assign_ready_pending(sg, replace_global_ready_vector(
          assign_policy_insert_ready_vector(
            before, desc.tdSchedMember, new_bucket), st))
 */
{
    /* 从已发布任务不变量取得后续标量读取所需的范围和基址对齐。 */
    /*@ st.os_tasks.task_desc_map(task) == Some(desc) &&
        task_fields(sg, st)
        which implies
        0 <= desc.tdSchedMember.tsmCurPrio &&
        desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX &&
        addr_aligned(task, ALIGN_SIZE) &&
        task_fields(sg, st)
     */

    /* 从 task_inv 取出 cur_prio，比较后归还原任务状态。 */
	DoubleLinklistType* node = NONE;
	DoubleLinklistType* tail = NONE;
	struct TaskDescriptor *tmp = NONE;

	NULL_PARAM_CHECK_1(task);
    NULL_PARAM_CHECK_1(ready_table);

    RoundRobinRemainReadyVectorInsert(task, ready_table)
        /*@ where sg = sg, st = st, desc = desc, before = before */;

    /*
     * Both NULL checks are preserved across the call.  Keeping the complete
     * RRR result in this cutpoint makes the following true branch explicitly
     * unreachable without dropping the ready-vector ownership.
     */
    /*@ Assert
          node == 0 && tail == 0 && tmp == 0 &&
          task != 0 &&
          ready_table != 0 &&
          ready_table == assign_ready_vector_addr(sg) &&
          task == task@pre && ready_table == ready_table@pre &&
          (st.os_tasks.task_desc_map(task) == Some(desc) &&
        0 <= desc.tdSchedMember.tsmCurPrio &&
        desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) && addr_aligned(task, ALIGN_SIZE) &&
          exists new_bucket,
            rrr_bucket_insert(
              st.os_tasks.task_desc_map, desc.tdSchedMember, ready_task_node(task),
              Znth(
                desc.tdSchedMember.tsmCurPrio,
                before.orvBuckets, nil),
              new_bucket) &&
            task_fields(sg, replace_global_ready_vector(
              os_assign_ready_vector_replace_bucket(
                before, desc.tdSchedMember.tsmCurPrio, new_bucket), st)) *
            assign_ready_pending(sg, replace_global_ready_vector(
              os_assign_ready_vector_replace_bucket(
                before, desc.tdSchedMember.tsmCurPrio, new_bucket), st))
 */
    /*@ Given new_bucket  */



    if(NONE == task || NONE == ready_table) {
		// KPrintf("PARAM CHECK FAILED ...%s %d param is NULL.\n",__FUNCTION__,__LINE__);
		return;
	}

    if(task->task_dync_sched_member.cur_prio > ready_table->highest_prio) {
		ready_table->highest_prio = task->task_dync_sched_member.cur_prio;
	}

    /*@
      node == 0 && tail == 0 && tmp == 0 &&
      task != 0 && ready_table != 0 &&
      ready_table == assign_ready_vector_addr(sg) &&
      task == task@pre && ready_table == ready_table@pre &&
      (st.os_tasks.task_desc_map(task) == Some(desc) &&
        0 <= desc.tdSchedMember.tsmCurPrio &&
        desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) &&
      addr_aligned(task, ALIGN_SIZE) &&
      rrr_bucket_insert(
        st.os_tasks.task_desc_map, desc.tdSchedMember, ready_task_node(task),
        Znth(
          desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil),
        new_bucket) &&
      assign_ready_published(replace_global_ready_vector(
        os_assign_ready_vector_replace_bucket(
          before, desc.tdSchedMember.tsmCurPrio, new_bucket), st)) &&
      store_uchar(
        &(task->task_dync_sched_member.cur_prio),
        desc.tdSchedMember.tsmCurPrio) *
      store_uint(
        &(ready_table->highest_prio),
        assign_policy_highest_after(before, desc.tdSchedMember)) *
      store_assign_policy_insert_frame(
        sg, st, ready_table, task, desc, before, new_bucket)
      which implies
      node == 0 && tail == 0 && tmp == 0 &&
      task != 0 && ready_table != 0 &&
      task == task@pre && ready_table == ready_table@pre &&
      (st.os_tasks.task_desc_map(task) == Some(desc) &&
        0 <= desc.tdSchedMember.tsmCurPrio &&
        desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) &&
      addr_aligned(task, ALIGN_SIZE) &&
      exists final_bucket,
        rrr_bucket_insert(
          st.os_tasks.task_desc_map, desc.tdSchedMember, ready_task_node(task),
          Znth(
            desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil),
          final_bucket) &&
        task_fields(sg, replace_global_ready_vector(
          assign_policy_insert_ready_vector(
            before, desc.tdSchedMember, final_bucket), st)) *
        assign_ready_pending(sg, replace_global_ready_vector(
          assign_policy_insert_ready_vector(
            before, desc.tdSchedMember, final_bucket), st))
 */
}
