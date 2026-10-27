#include "../include/slice_types.h"
#include "../include/logic.h"

/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/assign_roundrobinremain.c. Current 32-bit non-SMP configuration. */
void *CONTAINER_OF(void *member, unsigned int offset)
/*@ Require emp
    Ensure __return == member - offset && emp
 */;

void DoubleLinkListInsertNodeBefore(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ rrr_ready_insert_before
    With (head: Z) (prefix: list(DL_Node Z))
         (current_task current_link task_ptr: Z) (suffix: list(DL_Node Z))
         (nodes: list(DL_Node Z)) (ready_table_guard: Z)
    Require ready_table_guard != 0 &&
            task_ptr != 0 &&
            linklist == current_link &&
            linklist_node != 0 &&
            linklist_node == sched_link_of(task_ptr) &&
            nodes == app(prefix,
              cons(Build_DL_Node(current_task, current_link), suffix)) &&
            store_priority_ready_bucket(head, nodes) *
            occupy_dll_node(linklist_node)
    Ensure task_ptr != 0 && ready_table_guard != 0 &&
           store_priority_ready_bucket(
             head,
             app(prefix,
               cons(Build_DL_Node(task_ptr, linklist_node),
                 cons(Build_DL_Node(current_task, current_link), suffix))))
 */
/*@ dispatch_case
    With {A} (storeA: Z -> A -> Assertion)
             (head: Z) (nodes: list(DL_Node A)) (inserted_data: A)
    Require dll_insert_anchor(head, nodes, linklist) &&
            linklist_node != 0 &&
            store_dll(storeA, head, nodes) *
            storeA(linklist_node, inserted_data) *
            occupy_dll_node(linklist_node)
    Ensure store_dll(
             storeA, head,
             dll_insert_before_dispatch(
               head, nodes, linklist,
               Build_DL_Node(inserted_data, linklist_node)))
*/;

void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ rrr_ready_insert_after
    With (head: Z) (nodes: list(DL_Node Z))
         (task_ptr ready_table_guard: Z)
    Require ready_table_guard != 0 &&
            task_ptr != 0 &&
            linklist_node != 0 &&
            linklist_node == sched_link_of(task_ptr) &&
            store_ready_dll_tail_view(head, nodes, linklist) *
            occupy_dll_node(linklist_node)
    Ensure task_ptr != 0 && ready_table_guard != 0 &&
           store_priority_ready_bucket(
             head,
             app(nodes, cons(Build_DL_Node(task_ptr, linklist_node), nil)))
 */
/*@ dispatch_case
    With {A} (storeA: addr -> A -> Assertion)
             (nodes: list(DL_Node A)) (a: A) (head: addr)
    Require dll_insert_anchor(head, nodes, linklist) &&
            linklist_node != 0 &&
            store_dll(storeA, head, nodes) *
            storeA(linklist_node, a) *
            occupy_dll_node(linklist_node)
    Ensure store_dll(
             storeA, head,
             dll_insert_after_dispatch(
               head, nodes, linklist,
               Build_DL_Node(a, linklist_node)))
*/;

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
 */
{
    DoubleLinklistType* node = NONE;
	DoubleLinklistType* tail = NONE;
	struct TaskDescriptor *tmp = NONE;

    if (task == NONE) { while (1) { } }
    if (ready_table == NONE) { while (1) { } }

    if ( task->task_dync_sched_member.advance_cnt < KTASK_MAX_ADVANCE_PROCESS_TIME ) {
		for (node = (&ready_table->priority_ready_vector[task->task_dync_sched_member.cur_prio])->node_next; node != &ready_table->priority_ready_vector[task->task_dync_sched_member.cur_prio]; node = node->node_next) {
			tmp = CONTAINER_OF(node, 16);
			if (task->task_dync_sched_member.rest_timeslice < tmp->task_dync_sched_member.rest_timeslice) {
				break;
			}
		}

		if ( node != &ready_table->priority_ready_vector[task->task_dync_sched_member.cur_prio]) {
			DoubleLinkListInsertNodeBefore(node, &(task->task_dync_sched_member.sched_link)) /*@ where (dispatch_case) */;
		} else {
			tail = ready_table->priority_ready_vector[task->task_dync_sched_member.cur_prio].node_prev;
			DoubleLinkListInsertNodeAfter(tail, &(task->task_dync_sched_member.sched_link)) /*@ where (dispatch_case) */;
		}
	} else {
		tail = ready_table->priority_ready_vector[task->task_dync_sched_member.cur_prio].node_prev;
		DoubleLinkListInsertNodeAfter(tail, &(task->task_dync_sched_member.sched_link)) /*@ where (dispatch_case) */;
	}

}
