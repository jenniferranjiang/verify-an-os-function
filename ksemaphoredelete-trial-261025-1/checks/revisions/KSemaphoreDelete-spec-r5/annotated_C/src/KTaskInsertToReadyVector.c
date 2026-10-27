#include "../include/slice_types.h"
#include "../include/logic.h"

/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/assign.c. Current 32-bit non-SMP configuration. */
void KTaskStatSetAsReady(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure  store_task_status(&(task->task_dync_sched_member.stat), TSK_READY)
*/;

void AssignPolicyInsert(struct TaskDescriptor *task, struct OsAssignReadyVector* ready_table)
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
 */;

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
    x_base lock = 0;

    if (task == NONE) { while (1) { } }

    /* Nested critical operation removed under the documented inside-critical adaptation. */

    KTaskStatSetAsReady(task);
    AssignPolicyInsert(task, &Assign.os_assign_ready_vector);

    


    Assign.os_assign_ready_vector.priority_ready_group |= task->task_dync_sched_member.bitmap_column;

    
}
