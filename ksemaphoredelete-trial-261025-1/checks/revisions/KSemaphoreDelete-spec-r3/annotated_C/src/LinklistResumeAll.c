#include "../include/slice_types.h"
#include "../include/logic.h"

/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/linklist.c. Current 32-bit non-SMP configuration. */
struct TaskDescriptor *CONTAINER_OF_TASK_SCHED(DoubleLinklistType *sched_link_ptr)
/*@ With task_ptr
    Require addr_aligned(task_ptr, ALIGN_SIZE) &&
            sched_link_ptr == sched_link_of(task_ptr) &&
            emp
    Ensure __return == task_ptr &&
           addr_aligned(__return, ALIGN_SIZE) &&
           sched_link_ptr ==
             &(__return->task_dync_sched_member.sched_link)
 */;

x_err_t KTaskWakeup(int32 id)
/*@ not_suspended
    With (sg : StableGlobalState) (st : VarGlobalState)
         (target : Z) (old_stat : TaskStatus)
    Require
      id < 65536 && task_world_wf(st) &&
      get_task_with_idnode_success(sg, st, id, target) &&
      old_stat != TSK_SUSPEND &&
      store_idmanager(sg.os_task_stable.task_stable_ids,
        st.os_tasks.task_idmanager_abs, &k_task_id_manager) *
      store_task_status(&(target->task_dync_sched_member.stat), old_stat)
    Ensure __return == -KERROR &&
      store_idmanager(sg.os_task_stable.task_stable_ids,
        st.os_tasks.task_idmanager_abs, &k_task_id_manager) *
      store_task_status(&(target->task_dync_sched_member.stat), old_stat)
 */
/*@ wakeup_unified
    With (sg : StableGlobalState) (st : VarGlobalState)
         (target : Z)
         (desc : TaskDescriptorAbs)
         (ready_before : OsAssignReadyVectorAbs)
         (sched_view : vSchedView)
    Require
      ready_before == st.os_assign.assignReadyVector &&
      os_global_context(sg) &&
      id < 65536 && task_world_wf(st) &&
      sg.os_task_stable.task_idmanager_ptr == &k_task_id_manager &&
      get_task_with_idnode_success(sg, st, id, target) &&
      desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
      (st.os_tasks.task_desc_map(target) == Some(desc) &&
        0 <= desc.tdSchedMember.tsmCurPrio &&
        desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) &&
      task_addr_aligned(target, ready_before) &&
      task_fields(sg, st) *
      delay_inv(sg, st) *
      store_ktask_wakeup_sched_pre(
        st.os_tasks.task_desc_map, target, sched_view) *
      assign_ready_pending(sg, st)
    Ensure
      __return == KOK &&
      exists st_delay ready_after,
        ktask_unset_delay_step(desc.tdDelay, st, st_delay) &&
        assign_insert_step_ic(st.os_tasks.task_desc_map, target, desc, ready_before, ready_after) &&
        task_fields(sg, replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(target, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st_delay))) *
        store_ktask_wakeup_source_post(
          update_task_desc_map(target, set_task_desc_ready(desc), st.os_tasks.task_desc_map), sched_view) *
        delay_inv(sg, replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(target, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st_delay))) *
        assign_ready_pending(sg, replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(target, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st_delay)))
 */;

x_err_t LinklistResumeAll(DoubleLinklistType *list)
/*@ semaphore_waiters
    With (sg : StableGlobalState) (st : VarGlobalState) (sem : SemaphoreAbs)
    Require In(sem, st.os_semaphores) &&
      list == semaphore_pending_head(sem.semaphore_addr) &&
      os_global_context(sg) &&
      task_fields(sg, st) *
      delay_inv(sg, st) *
      assign_ready_pending(sg, st) *
      store_dll(pure_suspend_sched_link(st.os_tasks.task_desc_map),
        list, map(semaphore_wait_node, sem.semaphore_pending_addrs))
    Ensure __return == KOK && exists after,
      semaphore_resume_all_steps(sem.semaphore_addr, sem.semaphore_pending_addrs, st, after) &&
      task_fields(sg, after) *
      delay_inv(sg, after) *
      assign_ready_pending(sg, after) *
      store_node_self_linked(list)
 */
{
    x_ubase lock = 0;
    struct TaskDescriptor *task = NONE;
    DoubleLinklistType *node = NONE;

    if (list == NONE) { while (1) { } }

    /* Nested critical operation removed under the documented inside-critical adaptation. */
    for(;;) {
        node = list->node_next;
        if(node != list) {
            task = CONTAINER_OF_TASK_SCHED(node);
            task->exstatus = -ERROR;
            KTaskWakeup(task->id.id) /*@ where (wakeup_unified) sg = sg */;
        } else {
            break;
        }
    }
    

    return EOK;
}
