#include "../include/slice_types.h"
#include "../include/logic.h"

/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/assignstat.c. Current 32-bit non-SMP configuration. */
void RoundRobinRemainReadyVectorInsert(struct TaskDescriptor *task, struct OsAssignReadyVector* ready_table)
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
 */
{
	DoubleLinklistType* node = NONE;
	DoubleLinklistType* tail = NONE;
	struct TaskDescriptor *tmp = NONE;

	if (task == NONE) { while (1) { } }
    if (ready_table == NONE) { while (1) { } }

RoundRobinRemainReadyVectorInsert(task, ready_table);

    if(NONE == task || NONE == ready_table) {
		
		return;
	}

    if(task->task_dync_sched_member.cur_prio > ready_table->highest_prio) {
		ready_table->highest_prio = task->task_dync_sched_member.cur_prio;
	}
}
