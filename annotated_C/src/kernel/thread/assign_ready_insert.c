/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskWakeup */
// 本文件是设定 assign.c 的 KTaskInsertToReadyVector 在临界区内被调用版本

#include "m_assign.h"
#include "ktask_set_status.h"
#include "task_stat_view.h"
#include "ready_cache_strategy.h"
/*@ include strategies "task_sched_view.strategies" */
/*@ include strategies "ready_cache.strategies" */
/*@ include strategies "task_stat_view.strategies" */

/*@ Import Coq Require Import CRTOS_Verify.libai.AssignInCritical */
/*@ Import Coq Require Import CRTOS_Verify.libai.AssignCommon */

/*@ Extern Coq
      (option :: * => *)
      (OsAssignReadyVectorAbs :: *)
 */

/*@ Extern Coq
      (task_fields_except_sched : StableGlobalState -> VarGlobalState -> Z -> TaskDescriptorAbs -> Assertion)
      (set_task_desc_ready :
        TaskDescriptorAbs -> TaskDescriptorAbs)
      (update_task_desc_map :
        Z -> TaskDescriptorAbs ->
        (Z -> option TaskDescriptorAbs) ->
        Z -> option TaskDescriptorAbs)
      (assign_insert_step_ic :
        (Z -> option TaskDescriptorAbs) -> Z -> TaskDescriptorAbs ->
        OsAssignReadyVectorAbs -> OsAssignReadyVectorAbs -> Prop)
      (store_assign_insert_sched_except_stat :
        Z -> TaskSchedMemberAbs -> Assertion)
      (store_assign_insert_group_frame :
        StableGlobalState -> VarGlobalState -> Z -> Z ->
        TaskDescriptorAbs -> OsAssignReadyVectorAbs ->
        list(DL_Node Z) -> Assertion)
 */

/*@ Extern Coq
      (task_addr_aligned :
        Z -> OsAssignReadyVectorAbs -> Prop)
      (store_os_assign_ready_vector :
        Z -> OsAssignReadyVectorAbs -> Assertion)

      (ready_task_node : Z -> DL_Node Z)
      (rrr_bucket_insert :
        (Z -> option TaskDescriptorAbs) -> TaskSchedMemberAbs ->
        DL_Node Z -> list(DL_Node Z) -> list(DL_Node Z) -> Prop)
      (assign_policy_insert_ready_vector :
        OsAssignReadyVectorAbs -> TaskSchedMemberAbs ->
        list(DL_Node Z) -> OsAssignReadyVectorAbs)
 */

/*
 * Contract synchronized with assignstat.c.  After
 * KTaskStatSetAsReady, the caller restores task_inv with the
 * single-cell descriptor-map update for the now-READY task.
 */
void AssignPolicyInsert(struct TaskDescriptor *task,
                        struct OsAssignReadyVector* ready_table)
/*@ With (sg : StableGlobalState)
         (st : VarGlobalState)
         (desc : TaskDescriptorAbs)
         (before : OsAssignReadyVectorAbs)
    Require
      before == st.os_assign.assignReadyVector &&
      ready_table == assign_ready_vector_addr(sg) &&
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      task_fields(sg, st) * assign_ready_pending(sg, st) *
      occupy_dll_node(sched_link_of(task))
    Ensure
      task != 0 && ready_table != 0 &&
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      exists new_bucket,
        rrr_bucket_insert(st.os_tasks.task_desc_map, desc.tdSchedMember, ready_task_node(task),
          Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil), new_bucket) &&
        task_fields(sg, replace_global_ready_vector(assign_policy_insert_ready_vector(before, desc.tdSchedMember, new_bucket), st)) *
        assign_ready_pending(sg, replace_global_ready_vector(assign_policy_insert_ready_vector(before, desc.tdSchedMember, new_bucket), st))
 */
;

/*
 * insert a ready task to system ready table with READY state and remove it from suspend list
 *
 * @param task the task descriptor
 *
 */
void KTaskInsertToReadyVector(struct TaskDescriptor *task)
/*@ With (sg : StableGlobalState)
         (st : VarGlobalState)
         (desc : TaskDescriptorAbs)
    Require
      os_global_context(sg) &&
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      task_fields(sg, st) * assign_ready_pending(sg, st) *
      occupy_dll_node(sched_link_of(task))
    Ensure
      exists (before after : OsAssignReadyVectorAbs) (st' : VarGlobalState),
        before == st.os_assign.assignReadyVector &&
        assign_insert_step_ic(st.os_tasks.task_desc_map, task, desc, before, after) &&
        st' ==
          replace_global_ready_vector(after,
            replace_task_desc_map(
              update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st)) &&
        task_fields(sg, st') * assign_ready_pending(sg, st')
 */
{
    /* 打开暂态视图，登记关系作为纯事实跨链表和缓存更新保留。 */
    /*@ os_global_context(sg) && assign_ready_pending(sg, st)
        which implies
        exists (before : OsAssignReadyVectorAbs),
          before == st.os_assign.assignReadyVector &&
          assign_ready_vector_addr(sg) == &(Assign.os_assign_ready_vector) &&
          assign_ready_published(st) &&
          store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), before)
     */
    /*@ Given before */
    /* 已发布任务的范围和布局事实由 task_inv 局部导出。 */
    /*@ assign_ready_published(st) &&
      before == st.os_assign.assignReadyVector &&
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      task_fields(sg, st) *
      store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), before)
      which implies
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      0 <= desc.tdSchedMember.tsmCurPrio &&
      desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX &&
      task_addr_aligned(task, before) &&
      task_fields(sg, st) *
      store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), before)
     */

    /* READY 状态仅更新 task_inv 的目标 cell，节点交给 ready-vector。 */
    x_base lock = 0;

    NULL_PARAM_CHECK_1(task);

    // lock = DISABLE_INTERRUPT();

    KTaskStatSetAsReady(task);

    /*@
      task != 0 &&
      task == task@pre &&
      (st.os_tasks.task_desc_map(task) == Some(desc) &&
        0 <= desc.tdSchedMember.tsmCurPrio &&
        desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) &&
      task_addr_aligned(task, before) &&
      store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), before) *
      store_task_status(
        &(task->task_dync_sched_member.stat),
        TSK_READY) *
      store_assign_insert_sched_except_stat(
        task, desc.tdSchedMember) *
      occupy_dll_node(sched_link_of(task)) *
      store(&lock, signed long, 0) *
      task_fields_except_sched(sg, st, task@pre, desc)
which implies
      task != 0 &&
      task == task@pre &&
      (st.os_tasks.task_desc_map(task) == Some(desc) &&
        0 <= desc.tdSchedMember.tsmCurPrio &&
        desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) &&
      ((replace_task_desc_map(update_task_desc_map(task@pre, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st)).os_tasks.task_desc_map(task) == Some(set_task_desc_ready(desc)) &&
        0 <= ((set_task_desc_ready(desc)).tdSchedMember).tsmCurPrio &&
        ((set_task_desc_ready(desc)).tdSchedMember).tsmCurPrio < PRIORITY_MAX) &&
      task_addr_aligned(task, before) &&
      store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), before) *
      task_fields(sg, replace_task_desc_map(update_task_desc_map(task@pre, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st)) *
      occupy_dll_node(sched_link_of(task)) *
      store(&lock, signed long, 0)
      */
    /*@ before == st.os_assign.assignReadyVector &&
        assign_ready_vector_addr(sg) == &(Assign.os_assign_ready_vector) &&
        assign_ready_published(st) &&
        store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), before)
        which implies
        before == (replace_task_desc_map(update_task_desc_map(task@pre, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st)).os_assign.assignReadyVector &&
        assign_ready_pending(sg, replace_task_desc_map(update_task_desc_map(task@pre, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st))
     */
    AssignPolicyInsert(task, &Assign.os_assign_ready_vector)
/*@ where
            sg = sg,
            st = replace_task_desc_map(update_task_desc_map(task@pre, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st),
            desc = set_task_desc_ready(desc),
            before = before  */
;

    /*@ Given new_bucket */
    /*@ assign_ready_vector_addr(sg) == &(Assign.os_assign_ready_vector) &&
        task_fields(sg, replace_global_ready_vector(assign_policy_insert_ready_vector(before, (set_task_desc_ready(desc)).tdSchedMember, new_bucket), replace_task_desc_map(update_task_desc_map(task@pre, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st))) * assign_ready_pending(sg, replace_global_ready_vector(assign_policy_insert_ready_vector(before, (set_task_desc_ready(desc)).tdSchedMember, new_bucket), replace_task_desc_map(update_task_desc_map(task@pre, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st)))
        which implies
        assign_ready_published(replace_global_ready_vector(assign_policy_insert_ready_vector(before, (set_task_desc_ready(desc)).tdSchedMember, new_bucket), replace_task_desc_map(update_task_desc_map(task@pre, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st))) &&
        task_fields(sg, replace_task_desc_map(update_task_desc_map(task@pre, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st)) *
        store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), assign_policy_insert_ready_vector(before, (set_task_desc_ready(desc)).tdSchedMember, new_bucket))
     */
    /*@ Assert
      before == st.os_assign.assignReadyVector &&
      assign_ready_vector_addr(sg) == &(Assign.os_assign_ready_vector) &&
      assign_ready_published(st) &&
      task != 0 &&
      task == task@pre &&
      (st.os_tasks.task_desc_map(task) == Some(desc) &&
        0 <= desc.tdSchedMember.tsmCurPrio &&
        desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) &&
      ((replace_task_desc_map(update_task_desc_map(task@pre, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st)).os_tasks.task_desc_map(task) == Some(set_task_desc_ready(desc)) &&
        0 <= ((set_task_desc_ready(desc)).tdSchedMember).tsmCurPrio &&
        ((set_task_desc_ready(desc)).tdSchedMember).tsmCurPrio < PRIORITY_MAX) &&
      task_addr_aligned(task, before) &&
        rrr_bucket_insert(
          (replace_task_desc_map(update_task_desc_map(task@pre, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st)).os_tasks.task_desc_map,
          (set_task_desc_ready(desc)).tdSchedMember,
          ready_task_node(task),
          Znth(
            ((set_task_desc_ready(desc)).tdSchedMember).tsmCurPrio,
            before.orvBuckets, nil),
          new_bucket) &&
        store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), assign_policy_insert_ready_vector(
            before, (set_task_desc_ready(desc)).tdSchedMember,
            new_bucket)) *
        store(&lock, signed long, 0) *
      task_fields(sg, replace_task_desc_map(update_task_desc_map(task@pre, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st))
 */



    // SYS_KDEBUG_LOG(KDBG_SCHED, ("insert task[%.*s], the priority: %d\n",
    //                                   NAME_NUM_MAX, task->task_base_info.name, task->task_dync_sched_member.cur_prio));

    Assign.os_assign_ready_vector.priority_ready_group |=
        task->task_dync_sched_member.bitmap_column;

    /*@
      task != 0 &&
      task == task@pre &&
      (st.os_tasks.task_desc_map(task) == Some(desc) &&
        0 <= desc.tdSchedMember.tsmCurPrio &&
        desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) &&
      ((replace_task_desc_map(update_task_desc_map(task@pre, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st)).os_tasks.task_desc_map(task) == Some(set_task_desc_ready(desc)) &&
        0 <= ((set_task_desc_ready(desc)).tdSchedMember).tsmCurPrio &&
        ((set_task_desc_ready(desc)).tdSchedMember).tsmCurPrio < PRIORITY_MAX) &&
      task_addr_aligned(task, before) &&
      rrr_bucket_insert(
        (replace_task_desc_map(update_task_desc_map(task@pre, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st)).os_tasks.task_desc_map,
        (set_task_desc_ready(desc)).tdSchedMember,
        ready_task_node(task),
        Znth(
          ((set_task_desc_ready(desc)).tdSchedMember).tsmCurPrio,
          before.orvBuckets, nil),
        new_bucket) &&
      store(
        &(Assign.os_assign_ready_vector.priority_ready_group),
        unsigned int,
        unsigned_last_nbits(
          before.orvReadyGroup |
          ((set_task_desc_ready(desc)).tdSchedMember).tsmBitmapColumn,
          32)) *
      store(
        &(task->task_dync_sched_member.bitmap_column),
        unsigned int,
        ((set_task_desc_ready(desc)).tdSchedMember).tsmBitmapColumn) *
      store_assign_insert_group_frame(
        sg, replace_task_desc_map(update_task_desc_map(task@pre, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st), &(Assign.os_assign_ready_vector),
        task, set_task_desc_ready(desc), before, new_bucket) *
      store(&lock, signed long, 0)
      which implies
      exists after,
        task == task@pre &&
        (st.os_tasks.task_desc_map(task) == Some(desc) &&
        0 <= desc.tdSchedMember.tsmCurPrio &&
        desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) &&
        assign_insert_step_ic(
          st.os_tasks.task_desc_map, task, desc, before, after) &&
        store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), after) *
        store(&lock, signed long, 0) *
      task_fields(sg, replace_task_desc_map(update_task_desc_map(task@pre, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st))
 */

    /*@ Given after */
    /*@ before == st.os_assign.assignReadyVector &&
        assign_ready_vector_addr(sg) == &(Assign.os_assign_ready_vector) &&
        assign_ready_published(st) &&
        assign_insert_step_ic(st.os_tasks.task_desc_map, task@pre, desc, before, after) &&
        store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), after) *
        task_fields(sg, replace_task_desc_map(update_task_desc_map(task@pre, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st))
        which implies
        assign_insert_step_ic(st.os_tasks.task_desc_map, task@pre, desc, before, after) &&
        task_fields(sg, replace_global_ready_vector(after, replace_task_desc_map(update_task_desc_map(task@pre, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st))) *
        assign_ready_pending(sg, replace_global_ready_vector(after, replace_task_desc_map(update_task_desc_map(task@pre, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st)))
     */
    // ENABLE_INTERRUPT(lock);
}
