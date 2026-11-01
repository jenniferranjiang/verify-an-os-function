#include "../include/slice_types.h"
#include "../include/logic.h"

/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/delay.c. Current 32-bit non-SMP configuration. */
void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
/*@ remove_ready_member
    With (task head : Z)
         (prefix suffix : list(DL_Node Z))
    Require
      linklist_node == sched_link_of(task) &&
      store_priority_ready_bucket(
        head,
        app(prefix, cons(ready_task_node(task), suffix)))
    Ensure
      linklist_node == sched_link_of(task) &&
      store_priority_ready_bucket(head, app(prefix, suffix)) *
      store_node_self_linked(linklist_node)
 */
/*@ remove_sched_self
    With (task : Z) (sched : TaskSchedMemberAbs)
    Require
      linklist_node == sched_link_of(task) &&
      linklist_node != 0 &&
      store_task_sched_member(sched_link_of(task), sched) *
      store_node_self_linked(sched_link_of(task))
    Ensure
      store_task_sched_member(sched_link_of(task), sched) *
      store_node_self_linked(sched_link_of(task))
 */
/*@ remove_self
    With (node : Z)
    Require
      linklist_node == node &&
      node != 0 &&
      store_node_self_linked(node)
    Ensure
      store_node_self_linked(node)
 */
/*@ remove_member
    With {A} (storeA: addr -> A -> Assertion)
             (head: addr)  (a: A)
             (prefix: list(DL_Node A))
             (suffix: list(DL_Node A))
    Require store_dll(storeA, head,
              app(prefix, cons(Build_DL_Node(a, linklist_node), suffix)))
    Ensure store_dll(storeA, head, app(prefix, suffix)) *
           storeA(linklist_node, a) *
           store_node_self_linked(linklist_node)
*/
/*@ remove_from_head
    With {A} (storeA: addr -> A -> Assertion)
             (head: addr) (a: A)
             (suffix: list(DL_Node A))
    Require linklist_node != 0 && 
            store_dll(storeA, head,
              cons(Build_DL_Node(a, linklist_node), suffix))
    Ensure store_dll(storeA, head, suffix) *
           storeA(linklist_node, a) *
           store_node_self_linked(linklist_node)
*/;

x_err_t KTaskUnSetDelay(KTaskDescriptorType task)
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
{
	x_base lock = 0;
    struct Delay *delay = NONE;

	if (task == NONE) { while (1) { } }

	delay = task->task_dync_sched_member.delay;
   
	if( delay != NONE && delay->status == TASK_DELAY_ACTIVE) {
	    /* Nested critical operation removed under the documented inside-critical adaptation. */
        delay->status = TASK_DELAY_INACTIVE;
        DoubleLinkListRmNode(&(delay->link)) /*@ where (remove_member) */;
        
	}

	return EOK;
}
