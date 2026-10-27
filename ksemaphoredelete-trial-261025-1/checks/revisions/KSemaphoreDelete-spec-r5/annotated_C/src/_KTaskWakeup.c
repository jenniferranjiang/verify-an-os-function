#include "../include/slice_types.h"
#include "../include/logic.h"

/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c. Current 32-bit non-SMP configuration. */
BOOL JudgeKTaskStatIsSuspend(KTaskDescriptorType task)
/*@ With (old_stat : TaskStatus)
    Require store_task_status(&(task->task_dync_sched_member.stat), old_stat)
    Ensure ((__return == 1 && old_stat == TSK_SUSPEND) ||
            (__return == 0 && old_stat != TSK_SUSPEND)) &&
           store_task_status(&(task->task_dync_sched_member.stat), old_stat)
*/;

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
 */;

x_err_t _KTaskWakeup(KTaskDescriptorType task)
/*@ not_suspended
    With (old_stat : TaskStatus)
    Require
      old_stat != TSK_SUSPEND &&
      store_task_status(
        &(task->task_dync_sched_member.stat), old_stat)
    Ensure
      __return == -KERROR &&
      store_task_status(
        &(task->task_dync_sched_member.stat), old_stat)
 */
/*@ wakeup_unified
    With (sg : StableGlobalState) (st : VarGlobalState)
         (desc : TaskDescriptorAbs)
         (ready_before : OsAssignReadyVectorAbs)
         (sched_view : vSchedView)
    Require
      ready_before == st.os_assign.assignReadyVector &&
      os_global_context(sg) &&
      desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      task_fields(sg, st) *
      delay_inv(sg, st) *
      store_ktask_wakeup_sched_pre(
        st.os_tasks.task_desc_map, task, sched_view) *
      assign_ready_pending(sg, st)
    Ensure
      __return == KOK &&
      exists st_delay ready_after,
        ktask_unset_delay_step(desc.tdDelay, st, st_delay) &&
        assign_insert_step_ic(st.os_tasks.task_desc_map, task, desc, ready_before, ready_after) &&
        task_fields(sg, replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st_delay))) *
        store_ktask_wakeup_source_post(
          update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), sched_view) *
        delay_inv(sg, replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st_delay))) *
        assign_ready_pending(sg, replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st_delay)))
 */
/*@ sched_linked_delay_null <= wakeup_unified
    With (sg : StableGlobalState) (st : VarGlobalState)
         (desc : TaskDescriptorAbs)
         (ready_before : OsAssignReadyVectorAbs)
         (source_head : Z)
         (source_prefix source_suffix : list(DL_Node Z))
    Require
      ready_before == st.os_assign.assignReadyVector &&
      os_global_context(sg) &&
      desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      desc.tdDelay == 0 &&
      task_fields(sg, st) *
      delay_inv(sg, st) *
      store_ktask_wakeup_sched_pre(
        st.os_tasks.task_desc_map, task, vSchedLinked(source_head, source_prefix, source_suffix)) *
      assign_ready_pending(sg, st)
    Ensure
      __return == KOK &&
      exists st_delay ready_after,
        ktask_unset_delay_step(desc.tdDelay, st, st_delay) &&
        assign_insert_step_ic(st.os_tasks.task_desc_map, task, desc, ready_before, ready_after) &&
        task_fields(sg, replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st_delay))) *
        store_ktask_wakeup_source_post(
          update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), vSchedLinked(source_head, source_prefix, source_suffix)) *
        delay_inv(sg, replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st_delay))) *
        assign_ready_pending(sg, replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st_delay)))
 */
/*@ sched_linked_delay_inactive <= wakeup_unified
    With (sg : StableGlobalState) (st : VarGlobalState)
         (desc : TaskDescriptorAbs)
         (ready_before : OsAssignReadyVectorAbs)
         (source_head : Z)
         (source_prefix source_suffix : list(DL_Node Z))
         (delay_ptr : Z) (delay_abs : TaskDelayAbs)
    Require
      ready_before == st.os_assign.assignReadyVector &&
      os_global_context(sg) &&
      desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      desc.tdDelay == delay_ptr &&
      st.os_delays.delay_inactive_map(delay_ptr) == Some(delay_abs) &&
      task_fields(sg, st) *
      delay_inv(sg, st) *
      store_ktask_wakeup_sched_pre(
        st.os_tasks.task_desc_map, task, vSchedLinked(source_head, source_prefix, source_suffix)) *
      assign_ready_pending(sg, st)
    Ensure
      __return == KOK &&
      exists st_delay ready_after,
        ktask_unset_delay_step(desc.tdDelay, st, st_delay) &&
        assign_insert_step_ic(st.os_tasks.task_desc_map, task, desc, ready_before, ready_after) &&
        task_fields(sg, replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st_delay))) *
        store_ktask_wakeup_source_post(
          update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), vSchedLinked(source_head, source_prefix, source_suffix)) *
        delay_inv(sg, replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st_delay))) *
        assign_ready_pending(sg, replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st_delay)))
 */
/*@ sched_linked_delay_active <= wakeup_unified
    With (sg : StableGlobalState) (st : VarGlobalState)
         (desc : TaskDescriptorAbs)
         (ready_before : OsAssignReadyVectorAbs)
         (source_head : Z)
         (source_prefix source_suffix : list(DL_Node Z))
         (delay_ptr : Z) (delay_abs_before : TaskDelayAbs)
         (task_delay_node : DL_Node TaskDelayAbs)
         (delay_prefix delay_suffix : list(DL_Node TaskDelayAbs))
    Require
      ready_before == st.os_assign.assignReadyVector &&
      os_global_context(sg) &&
      desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      task_delay_node == Build_DL_Node(
        delay_abs_before, field_addr(delay_ptr, struct Delay, link)) &&
      desc.tdDelay == delay_ptr && delay_ptr != 0 &&
      st.os_delays.delay_active_nodes ==
        app(delay_prefix, cons(task_delay_node, delay_suffix)) &&
      task_fields(sg, st) *
      delay_inv(sg, st) *
      store_ktask_wakeup_sched_pre(
        st.os_tasks.task_desc_map, task, vSchedLinked(source_head, source_prefix, source_suffix)) *
      assign_ready_pending(sg, st)
    Ensure
      __return == KOK &&
      exists st_delay ready_after,
        ktask_unset_delay_step(desc.tdDelay, st, st_delay) &&
        assign_insert_step_ic(st.os_tasks.task_desc_map, task, desc, ready_before, ready_after) &&
        task_fields(sg, replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st_delay))) *
        store_ktask_wakeup_source_post(
          update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), vSchedLinked(source_head, source_prefix, source_suffix)) *
        delay_inv(sg, replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st_delay))) *
        assign_ready_pending(sg, replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st_delay)))
 */
/*@ sched_detached_delay_null <= wakeup_unified
    With (sg : StableGlobalState) (st : VarGlobalState)
         (desc : TaskDescriptorAbs)
         (ready_before : OsAssignReadyVectorAbs)
    Require
      ready_before == st.os_assign.assignReadyVector &&
      os_global_context(sg) &&
      desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      desc.tdDelay == 0 &&
      task_fields(sg, st) *
      delay_inv(sg, st) *
      store_ktask_wakeup_sched_pre(
        st.os_tasks.task_desc_map, task, vSchedDetached) *
      assign_ready_pending(sg, st)
    Ensure
      __return == KOK &&
      exists st_delay ready_after,
        ktask_unset_delay_step(desc.tdDelay, st, st_delay) &&
        assign_insert_step_ic(st.os_tasks.task_desc_map, task, desc, ready_before, ready_after) &&
        task_fields(sg, replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st_delay))) *
        store_ktask_wakeup_source_post(
          update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), vSchedDetached) *
        delay_inv(sg, replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st_delay))) *
        assign_ready_pending(sg, replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st_delay)))
 */
/*@ sched_detached_delay_inactive <= wakeup_unified
    With (sg : StableGlobalState) (st : VarGlobalState)
         (desc : TaskDescriptorAbs)
         (ready_before : OsAssignReadyVectorAbs)
         (delay_ptr : Z) (delay_abs : TaskDelayAbs)
    Require
      ready_before == st.os_assign.assignReadyVector &&
      os_global_context(sg) &&
      desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      desc.tdDelay == delay_ptr &&
      st.os_delays.delay_inactive_map(delay_ptr) == Some(delay_abs) &&
      task_fields(sg, st) *
      delay_inv(sg, st) *
      store_ktask_wakeup_sched_pre(
        st.os_tasks.task_desc_map, task, vSchedDetached) *
      assign_ready_pending(sg, st)
    Ensure
      __return == KOK &&
      exists st_delay ready_after,
        ktask_unset_delay_step(desc.tdDelay, st, st_delay) &&
        assign_insert_step_ic(st.os_tasks.task_desc_map, task, desc, ready_before, ready_after) &&
        task_fields(sg, replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st_delay))) *
        store_ktask_wakeup_source_post(
          update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), vSchedDetached) *
        delay_inv(sg, replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st_delay))) *
        assign_ready_pending(sg, replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st_delay)))
 */
/*@ sched_detached_delay_active <= wakeup_unified
    With (sg : StableGlobalState) (st : VarGlobalState)
         (desc : TaskDescriptorAbs)
         (ready_before : OsAssignReadyVectorAbs)
         (delay_ptr : Z) (delay_abs_before : TaskDelayAbs)
         (task_delay_node : DL_Node TaskDelayAbs)
         (delay_prefix delay_suffix : list(DL_Node TaskDelayAbs))
    Require
      ready_before == st.os_assign.assignReadyVector &&
      os_global_context(sg) &&
      desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      task_delay_node == Build_DL_Node(
        delay_abs_before, field_addr(delay_ptr, struct Delay, link)) &&
      desc.tdDelay == delay_ptr && delay_ptr != 0 &&
      st.os_delays.delay_active_nodes ==
        app(delay_prefix, cons(task_delay_node, delay_suffix)) &&
      task_fields(sg, st) *
      delay_inv(sg, st) *
      store_ktask_wakeup_sched_pre(
        st.os_tasks.task_desc_map, task, vSchedDetached) *
      assign_ready_pending(sg, st)
    Ensure
      __return == KOK &&
      exists st_delay ready_after,
        ktask_unset_delay_step(desc.tdDelay, st, st_delay) &&
        assign_insert_step_ic(st.os_tasks.task_desc_map, task, desc, ready_before, ready_after) &&
        task_fields(sg, replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st_delay))) *
        store_ktask_wakeup_source_post(
          update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), vSchedDetached) *
        delay_inv(sg, replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st_delay))) *
        assign_ready_pending(sg, replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st_delay)))
 */
{
    x_base lock = 0;

    if (task == NONE) { while (1) { } }

    if (RET_TRUE != JudgeKTaskStatIsSuspend(task)) {
        
        return -ERROR;
    }

    

    /* Nested critical operation removed under the documented inside-critical adaptation. */
    
    DoubleLinkListRmNode(&(task->task_dync_sched_member.sched_link));
    KTaskUnSetDelay(task) /*@ where (all_case_delay) sg = sg, st_before = st, desc = desc $ wakeup_unified */;
 
    KTaskInsertToReadyVector(task);

    
	
    
    return EOK;
}
