// 本文件是设定assign.c的KTaskInsertToReadyVector与KTaskOsAssignRemoveKTask在临界区内被调用版本

#include "m_assign.h"
#include "ktask_set_status.h"
#include "task_sched_view.h"
#include "ready_cache_strategy.h"
#include "ready_views_strategy.h"
/*@ include strategies "task_sched_view.strategies" */
/*@ include strategies "ready_cache.strategies" */
/*@ include strategies "ready_views.strategies" */

/*@ Import Coq Require Import CRTOS_Verify.libai.AssignInCritical */
/*@ Import Coq Require Import CRTOS_Verify.libai.AssignCommon */
/*@ Import Coq Require Import CRTOS_Verify.libai.Bitmap */
/*@ Import Coq Require Import CRTOS_Verify.libai.TaskOwnedMemoryLemmas */

/*@ Extern Coq
      (option :: * => *)
      (OsAssignReadyVectorAbs :: *)
 */

/*@ Extern Coq
      (assign_remove_member_step_ic :
        (Z -> option TaskDescriptorAbs) -> Z -> TaskDescriptorAbs ->
        OsAssignReadyVectorAbs -> list(DL_Node Z) -> list(DL_Node Z) ->
        OsAssignReadyVectorAbs -> Prop)
      (assign_remove_detached_step_ic :
        (Z -> option TaskDescriptorAbs) -> Z -> TaskDescriptorAbs ->
        OsAssignReadyVectorAbs -> OsAssignReadyVectorAbs -> Prop)
 */

/*@ Extern Coq
      (store_os_assign_ready_vector :
        Z -> OsAssignReadyVectorAbs -> Assertion)
      (store_priority_ready_vector_except :
        Z -> Z ->
        list(DL_Node Z) -> list(list(DL_Node Z)) -> Assertion)

      (task_fields_except_sched :
        StableGlobalState -> VarGlobalState -> Z -> TaskDescriptorAbs -> Assertion)
      (store_assign_remove_sched_frame :
        Z -> TaskSchedMemberAbs -> Assertion)
      (ready_task_node : Z -> DL_Node Z)
      (bitmap_highest_priority : Z -> Z)
      (store_prio_lookup_table : Assertion)
 */

/* Functional bitmap interface; bitmap.c remains a separate Stage-2 target. */
int PrioCaculate(uint32 bitmap)
/*@ functional
    Require
      0 <= bitmap && bitmap <= UINT_MAX &&
      store_prio_lookup_table
    Ensure
      __return == bitmap_highest_priority(bitmap) &&
      store_prio_lookup_table
 */
;

/*
 * a task will be removed from ready table.
 *
 * @param task  task descriptor
 *
 * Both behaviors describe the same interrupt-free core.  Critical-section
 * protocol resources are caller frames and are intentionally absent here.
 */
void KTaskOsAssignRemoveKTask(struct TaskDescriptor *task)
/*@ linked_ic
    With (sg : StableGlobalState)
         (st : VarGlobalState)
         (desc : TaskDescriptorAbs)
         (before : OsAssignReadyVectorAbs)
         (prefix suffix : list(DL_Node Z))
    Require
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil) ==
        app(prefix, cons(ready_task_node(task), suffix)) &&
      task_fields(sg, st) *
      store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), before) *
      store_prio_lookup_table
    Ensure
      exists after,
        assign_remove_member_step_ic(
          st.os_tasks.task_desc_map, task, desc, before, prefix, suffix, after) &&
        task_fields(sg, st) *
        store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), after) *
        store_node_self_linked(sched_link_of(task)) *
        store_prio_lookup_table
 */
;

void KTaskOsAssignRemoveKTask(struct TaskDescriptor *task)
/*@ detached_ic
    With (sg : StableGlobalState)
         (st : VarGlobalState)
         (desc : TaskDescriptorAbs)
         (before : OsAssignReadyVectorAbs)
    Require
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      task_fields(sg, st) *
      store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), before) *
      store_node_self_linked(sched_link_of(task)) *
      store_prio_lookup_table
    Ensure
      exists after,
        assign_remove_detached_step_ic(
          st.os_tasks.task_desc_map, task, desc, before, after) &&
        task_fields(sg, st) *
        store_os_assign_ready_vector(&(Assign.os_assign_ready_vector), after) *
        store_node_self_linked(sched_link_of(task)) *
        store_prio_lookup_table
 */
;

void KTaskOsAssignRemoveKTask(struct TaskDescriptor *task)
/*@ linked_ic */
/*@ detached_ic */
{
    /* 已发布任务的范围和布局事实由 task_inv 局部导出。 */
    /*@ st_linked_ic.os_tasks.task_desc_map(task) == Some(desc_linked_ic) &&
      task_fields(sg_linked_ic, st_linked_ic)
      $ linked_ic
      which implies
      st_linked_ic.os_tasks.task_desc_map(task) == Some(desc_linked_ic) &&
      0 <= desc_linked_ic.tdSchedMember.tsmCurPrio &&
      desc_linked_ic.tdSchedMember.tsmCurPrio < PRIORITY_MAX &&
      addr_aligned(task, ALIGN_SIZE) &&
      task_fields(sg_linked_ic, st_linked_ic)
     */

    /* 已发布任务的范围和布局事实由 task_inv 局部导出。 */
    /*@ st_detached_ic.os_tasks.task_desc_map(task) == Some(desc_detached_ic) &&
      task_fields(sg_detached_ic, st_detached_ic)
      $ detached_ic
      which implies
      st_detached_ic.os_tasks.task_desc_map(task) == Some(desc_detached_ic) &&
      0 <= desc_detached_ic.tdSchedMember.tsmCurPrio &&
      desc_detached_ic.tdSchedMember.tsmCurPrio < PRIORITY_MAX &&
      addr_aligned(task, ALIGN_SIZE) &&
      task_fields(sg_detached_ic, st_detached_ic)
     */

    /* 调度标量从 task_inv 局部借出；返回前归还同一 descriptor cell。 */
    x_base lock = 0;
    x_ubase number = 0;
    x_ubase highest_priority = 0;

    NULL_PARAM_CHECK_1(task);

    /*@ sched_link_of(task) ==
          &(task->task_dync_sched_member.sched_link) by local */

    // lock = DISABLE_INTERRUPT();

    // SYS_KDEBUG_LOG(KDBG_SCHED, ("remove task[%.*s], the priority: %d\n", NAME_NUM_MAX, task->task_base_info.name, task->task_dync_sched_member.cur_prio));


    DoubleLinkListRmNode(&(task->task_dync_sched_member.sched_link))
        /*@ where (remove_ready_member)
              head = &(Assign.os_assign_ready_vector.priority_ready_vector[desc_linked_ic.tdSchedMember.tsmCurPrio]),
              task = task,
              prefix = prefix_linked_ic,
              suffix = suffix_linked_ic
              $ linked_ic
            where (remove_self)
              node = sched_link_of(task)
              $ detached_ic */;




    if (IsDoubleLinkListEmpty(&(Assign.os_assign_ready_vector.priority_ready_vector[task->task_dync_sched_member.cur_prio]))
        /*@ where (ready_dll)
              nodes = app(prefix_linked_ic, suffix_linked_ic)
              $ linked_ic
            where (ready_dll)
              nodes = Znth(
                desc_detached_ic.tdSchedMember.tsmCurPrio,
                before_detached_ic.orvBuckets, nil)
              $ detached_ic */
            ) {

        Assign.os_assign_ready_vector.priority_ready_group &=
            ~task->task_dync_sched_member.bitmap_column;
        highest_priority = PrioCaculate(Assign.os_assign_ready_vector.priority_ready_group)
            /*@ where (functional) $ linked_ic detached_ic */;

        Assign.os_assign_ready_vector.highest_prio = highest_priority;
    }

    // ENABLE_INTERRUPT(lock);
}
