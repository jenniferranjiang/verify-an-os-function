#include "../include/slice_types.h"
#include "../include/logic.h"

/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c. Current 32-bit non-SMP configuration. */
struct TaskDescriptor *GetTaskWithIdnodeInfo(int32 id)
/*@ inside_critical
    With (sg : StableGlobalState) (st : VarGlobalState)
    Require
      id < 65536 &&
      task_world_wf(st) &&
      store_idmanager(
        sg.os_task_stable.task_stable_ids, st.os_tasks.task_idmanager_abs,
        &k_task_id_manager)
    Ensure
      ((__return == 0 &&
        (id < 0 || idmanager_query(st.os_tasks.task_idmanager_abs, id) == false))
       ||
       get_task_with_idnode_success(sg, st, id, __return)) &&
      store_idmanager(
        sg.os_task_stable.task_stable_ids, st.os_tasks.task_idmanager_abs,
        &k_task_id_manager)
 */
/*@ inside_known <= inside_critical
    With (sg : StableGlobalState) (st : VarGlobalState) (target : Z)
    Require
      id < 65536 &&
      task_world_wf(st) &&
      get_task_with_idnode_success(sg, st, id, target) &&
      store_idmanager(
        sg.os_task_stable.task_stable_ids, st.os_tasks.task_idmanager_abs,
        &k_task_id_manager)
    Ensure
      __return == target &&
      store_idmanager(
        sg.os_task_stable.task_stable_ids, st.os_tasks.task_idmanager_abs,
        &k_task_id_manager)
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
 */
{
    x_base lock = 0;
    struct TaskDescriptor *task = NONE;

    task = GetTaskWithIdnodeInfo(id) /*@ where (inside_known) sg = sg, st = st, target = target */;
    if (task == NONE) { while (1) { } }

    return _KTaskWakeup(task) /*@ where (not_suspended) old_stat = old_stat $ not_suspended where (wakeup_unified) sg = sg, st = st, desc = desc, ready_before = ready_before, sched_view = sched_view $ wakeup_unified */;
}
