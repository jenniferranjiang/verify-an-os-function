/* Proposal only: not an active verification input and not an assumed contract. */
x_err_t KTaskWakeup(int32 id)
/*@ wakeup_unified_nonnull
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
      target != 0 &&
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
