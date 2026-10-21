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
* @file:    assign_roundrobin.c
* @brief:   ready table and timeslice functions definitions of roundrobin scheduler algorithm
* @version: 1.0
* @author:  AIIT XUOS Lab
* @date:    2020/3/15
*
*/

/*
 * 从 CRTOS kernel/thread/assign_roundrobin.c 迁移。
 * 使用 vrtos 类型和已验证的 NULL_PARAM_CHECK_1 适配；原算法保持。
 * Init/Insert 原本就是直接函数调用，没有函数指针分派需要替换。
 * TimesliceUpdate 仅保留源码，暂不设计或验证其 Spec。
 */
#include "m_assign.h"
#include "ready_views_strategy.h"
#include "task_sched_view.h"

/*@ Import Coq Require Import CRTOS_Verify.libai.RRR_ReadyInsert */

/*@ Extern Coq (OsAssignReadyVectorAbs :: *) */
/*@ Extern Coq (task_fields_except_sched :
      StableGlobalState -> VarGlobalState -> Z -> TaskDescriptorAbs -> Assertion) */
/*@ Extern Coq
      (os_assign_ready_vector_replace_bucket :
        OsAssignReadyVectorAbs -> Z -> list(DL_Node Z) -> OsAssignReadyVectorAbs)
      (rrr_ready_bucket_head : Z -> Z -> Z)
      (store_rrr_vector_except :
        Z -> Z -> list(DL_Node Z) ->
        OsAssignReadyVectorAbs -> Assertion)
      (store_ready_dll_tail_frame :
        Z -> list(DL_Node Z) -> Z -> Assertion)
      (store_ready_dll_tail_view :
        Z -> list(DL_Node Z) -> Z -> Assertion)
      (store_os_assign_ready_vector :
        Z -> OsAssignReadyVectorAbs -> Assertion)
 */

/*@ include strategies "ready_views.strategies" */
/*@ include strategies "task_sched_view.strategies" */

void RoundRobinTaskTimesliceInit(struct TaskDescriptor *task)
/*@ Require
      has_permission(
        &(task->task_dync_sched_member.origin_timeslice)) *
      has_permission(
        &(task->task_dync_sched_member.rest_timeslice))
    Ensure
      task != 0 &&
      store(
        &(task->task_dync_sched_member.origin_timeslice),
        unsigned int, 10) *
      store(
        &(task->task_dync_sched_member.rest_timeslice),
        unsigned int, 10)
 */
{
    NULL_PARAM_CHECK_1(task);

    task->task_dync_sched_member.origin_timeslice = 10;
	task->task_dync_sched_member.rest_timeslice = 10;
}

/*
 * 使用项目 RRR 尾插调用已有的本地 DLL 接口。
 * 通过 assign_ready_pending 访问全局就绪表，只替换当前优先级桶。
 * 调度标量由 task_inv 保留并归还；位图和最高优先级由外层函数同步。
 * FIFO/RR 不扫描旧任务字段；待插入任务的优先级和基址对齐由 task_inv 提供。
 */
void RoundRobinReadyVectorInsert(struct TaskDescriptor *task, struct OsAssignReadyVector* ready_table)
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
      task_fields(sg, replace_global_ready_vector(
        os_assign_ready_vector_replace_bucket(
          before, desc.tdSchedMember.tsmCurPrio,
          app(Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil),
              cons(ready_task_node(task), nil))), st)) *
      assign_ready_pending(sg, replace_global_ready_vector(
        os_assign_ready_vector_replace_bucket(
          before, desc.tdSchedMember.tsmCurPrio,
          app(Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil),
              cons(ready_task_node(task), nil))), st))
 */
{
    /* 标量由 task_inv 局部取还；链表仅转移 sched_link。 */
    DoubleLinklistType* tail = NONE;

    NULL_PARAM_CHECK_1(task);
    NULL_PARAM_CHECK_1(ready_table);

    /* 策略按桶访问需求打开就绪视图，保留发布关系。 */

    /*@ st.os_tasks.task_desc_map(task) == Some(desc) &&
        task_fields(sg, st)
        which implies
        0 <= desc.tdSchedMember.tsmCurPrio &&
        desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX &&
        addr_aligned(task, ALIGN_SIZE) &&
        task_fields(sg, st)
     */
    
    

    tail = ready_table->priority_ready_vector[task->task_dync_sched_member.cur_prio].node_prev;

    
	DoubleLinkListInsertNodeAfter(tail, &(task->task_dync_sched_member.sched_link))
        /*@ where (rrr_ready_insert_after)
              head = rrr_ready_bucket_head(
                ready_table@pre, desc.tdSchedMember.tsmCurPrio),
              nodes = Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil),
              task_ptr = task@pre,
              ready_table_guard = ready_table@pre */;

    

    /* 只更新全局状态中的目标桶；位图、缓存及其余全局分量保持原值。 */
    /*@ task@pre != 0 &&
        before == st.os_assign.assignReadyVector &&
        ready_table@pre == assign_ready_vector_addr(sg) &&
        st.os_tasks.task_desc_map(task@pre) == Some(desc) &&
        0 <= desc.tdSchedMember.tsmCurPrio &&
        desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX &&
        assign_ready_published(st) &&
        task_fields(sg, st) *
        store_os_assign_ready_vector(ready_table@pre,
          os_assign_ready_vector_replace_bucket(
            before, desc.tdSchedMember.tsmCurPrio,
            app(Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil),
                cons(ready_task_node(task@pre), nil))))
        which implies
        task_fields(sg, replace_global_ready_vector(
          os_assign_ready_vector_replace_bucket(
            before, desc.tdSchedMember.tsmCurPrio,
            app(Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil),
                cons(ready_task_node(task@pre), nil))), st)) *
        assign_ready_pending(sg, replace_global_ready_vector(
          os_assign_ready_vector_replace_bucket(
            before, desc.tdSchedMember.tsmCurPrio,
            app(Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil),
                cons(ready_task_node(task@pre), nil))), st))
     */
}

// void RoundRobinTaskTimesliceUpdate(struct TaskDescriptor *task)
// {
//     NULL_PARAM_CHECK_1(task);

//     -- task->task_dync_sched_member.rest_timeslice;
//     if (task->task_dync_sched_member.rest_timeslice == 0)
//     {
//         task->task_dync_sched_member.rest_timeslice = task->task_dync_sched_member.origin_timeslice;

//         DO_KTASK_ASSIGN;
//     }
// }
