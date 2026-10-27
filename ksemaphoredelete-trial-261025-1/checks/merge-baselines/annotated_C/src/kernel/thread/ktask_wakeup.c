#include "m_assign.h"
#include "task_stat_view.h"
#include "ktask_set_status.h"
#include "ktask_unset_delay.h"
#include "delay_views_strategy.h"

/*@ Import Coq Require Import CRTOS_Verify.libai.AssignInCritical */
/*@ Import Coq Require Import CRTOS_Verify.libai.AssignCommon */
/*@ Import Coq Require Import CRTOS_Verify.libai.RRR_ReadyInsert */
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskSetDelay */
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskWakeup */
/*@ Import Coq Require Import CRTOS_Verify.libai.GetTaskWithIdnodeInside */
/*@ Import Coq Require Import CRTOS_Verify.VC.code.kernel.thread.ktask_wakeup_lib */
/*@ Import Coq Import DLL */

/*@ Extern Coq
      (DL_Node :: * => *)
      (option :: * => *)
      (TaskSchedMemberAbs :: *)
      (TaskDescriptorAbs :: *)
      (OsAssignReadyVectorAbs :: *)
      (vSchedView :: *)
 */


/*@ Extern Coq Record TaskDelayAbs {
      tdTaskPtr: Z;
      tdTicks: Z;
      tdStatus: Z;
    }
 */

/*@ Extern Coq
      (store_ktask_wakeup_sched_stat_frame :
        StableGlobalState -> VarGlobalState -> Z -> TaskDescriptorAbs -> Assertion)
      (replace_task_desc_map :
        (Z -> option TaskDescriptorAbs) -> VarGlobalState -> VarGlobalState)
      (KOK : Z)
      (KERROR : Z)
      (TSK_SUSPEND : TaskStatus)
      (TASK_STAT_MASK : Z)
      (TASK_DELAY_INACTIVE_VALUE : Z)
      (task_addr_aligned :
        Z -> OsAssignReadyVectorAbs -> Prop)
      (sched_link_of : Z -> Z)
      (set_task_desc_ready :
        TaskDescriptorAbs -> TaskDescriptorAbs)
      (update_task_desc_map :
        Z -> TaskDescriptorAbs ->
        (Z -> option TaskDescriptorAbs) ->
        Z -> option TaskDescriptorAbs)
      (assign_insert_step_ic :
        (Z -> option TaskDescriptorAbs) -> Z -> TaskDescriptorAbs ->
        OsAssignReadyVectorAbs -> OsAssignReadyVectorAbs -> Prop)
      (store_os_assign_ready_vector :
        Z -> OsAssignReadyVectorAbs -> Assertion)
      (store_task_sched_member :
        Z -> TaskSchedMemberAbs -> Assertion)
      (pure_task_sched_link_member :
        (Z -> option TaskDescriptorAbs) -> Z -> Z -> Assertion)
      (store_node_self_linked : Z -> Assertion)
      (store_delay_info : Z -> TaskDelayAbs -> Assertion)
      (delay_nodes_wf : list(DL_Node TaskDelayAbs) -> Prop)
      (mkTaskDelayAbs : Z -> Z -> Z -> TaskDelayAbs)
      (store_ktask_wakeup_sched_pre :
        (Z -> option TaskDescriptorAbs) -> Z -> vSchedView -> Assertion)
      (store_ktask_wakeup_source_post :
        (Z -> option TaskDescriptorAbs) -> vSchedView -> Assertion)
      (vSchedLinked : Z -> list(DL_Node Z) -> list(DL_Node Z) -> vSchedView)
      (vSchedDetached : vSchedView)
      (KNONE : Z)
      (task_fields_id_frame : StableGlobalState -> VarGlobalState -> Assertion)
      (task_world_wf : VarGlobalState -> Prop)
      (get_task_with_idnode_success :
        StableGlobalState -> VarGlobalState -> Z -> Z -> Prop)
 */

/*@ include strategies "task_id_view.strategies" */
/*@ include strategies "task_stat_view.strategies" */

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
        st' == replace_global_ready_vector(after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st)) &&
        task_fields(sg, st') * assign_ready_pending(sg, st')
 */;


struct TaskDescriptor *GetTaskWithIdnodeInfo(int32 id)
/*@ inside_critical
    With (sg : StableGlobalState) (st : VarGlobalState)
    Require id < 65536 && task_world_wf(st) &&
      store_idmanager(sg.os_task_stable.task_stable_ids,
        st.os_tasks.task_idmanager_abs, &k_task_id_manager)
    Ensure
      ((__return == KNONE &&
        (id < 0 || idmanager_query(st.os_tasks.task_idmanager_abs, id) == false))
       || get_task_with_idnode_success(sg, st, id, __return)) &&
      store_idmanager(sg.os_task_stable.task_stable_ids,
        st.os_tasks.task_idmanager_abs, &k_task_id_manager)
 */
/*@ inside_known
    With (sg : StableGlobalState) (st : VarGlobalState) (target : Z)
    Require id < 65536 && task_world_wf(st) &&
      get_task_with_idnode_success(sg, st, id, target) &&
      store_idmanager(sg.os_task_stable.task_stable_ids,
        st.os_tasks.task_idmanager_abs, &k_task_id_manager)
    Ensure __return == target &&
      store_idmanager(sg.os_task_stable.task_stable_ids,
        st.os_tasks.task_idmanager_abs, &k_task_id_manager)
 */
;

/*
 * The error behavior deliberately owns only the status byte.  Every resource
 * not inspected before the early return is a separation-logic frame.
 */
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
;

/*
 * 方案2：成功接口统一借用 task_inv 中的 descriptor 标量。
 * 来源队列只拥有 sched_link；delay_inv 拥有 inactive map 与 active DLL。
 * 六个派生接口保留 sched 的 linked/detached 及 Delay 的 N/U/L 覆盖。
 * Stage 1：取消延时后的 st_delay 与插入 READY 后的完整状态显式关联；
 * KTaskUnSetDelay 借还指针槽，不取得整个 task_fields。
 */
x_err_t _KTaskWakeup(KTaskDescriptorType task)
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
;

x_err_t _KTaskWakeup(KTaskDescriptorType task)
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
;

x_err_t _KTaskWakeup(KTaskDescriptorType task)
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
;

x_err_t _KTaskWakeup(KTaskDescriptorType task)
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
;

/* sched_link already is a detached/self-linked node. */
x_err_t _KTaskWakeup(KTaskDescriptorType task)
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
;

x_err_t _KTaskWakeup(KTaskDescriptorType task)
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
;

x_err_t _KTaskWakeup(KTaskDescriptorType task)
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
;

/**
 * This function will resume a task. All called point is in critical area, so no need to lock.
 *
 * @param id task id
 *
 */
x_err_t _KTaskWakeup(KTaskDescriptorType task)
/*@ not_suspended */
/*@ wakeup_unified */
{
    /* 已发布任务的范围和布局事实由 task_inv 局部导出。 */
    /*@ ready_before == st.os_assign.assignReadyVector &&
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      task_fields(sg, st) *
      assign_ready_pending(sg, st)
      $ wakeup_unified
      which implies
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      0 <= desc.tdSchedMember.tsmCurPrio &&
      desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX &&
      task_addr_aligned(task, ready_before) &&
      task_fields(sg, st) *
      assign_ready_pending(sg, st)
     */

    x_base lock = 0;
    NULL_PARAM_CHECK_1(task);

    if (RET_TRUE != JudgeKTaskStatIsSuspend(task)) {
        return -ERROR;
    }

    /*@ (st.os_tasks.task_desc_map(task) == Some(desc) &&
        0 <= desc.tdSchedMember.tsmCurPrio &&
        desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) &&
        task_addr_aligned(task, ready_before) && task_fields(sg, st) *
        store_ktask_wakeup_sched_pre(st.os_tasks.task_desc_map, task, sched_view) $ wakeup_unified
        which implies
        task_fields(sg, st) *
        ((exists source_head source_prefix source_suffix,
          sched_view == vSchedLinked(source_head, source_prefix, source_suffix) &&
          sched_view != vSchedDetached &&
          store_dll(pure_task_sched_link_member(st.os_tasks.task_desc_map), source_head,
            app(source_prefix, cons(Build_DL_Node(task, &(task->task_dync_sched_member.sched_link)), source_suffix))))
        ||
        (sched_view == vSchedDetached && &(task->task_dync_sched_member.sched_link) != 0 &&
         store_node_self_linked(&(task->task_dync_sched_member.sched_link))))
     */
    /*@ Branch name
          wakeup_linked: sched_view != vSchedDetached;
          wakeup_detached: sched_view == vSchedDetached */
    DoubleLinkListRmNode(&(task->task_dync_sched_member.sched_link))
      /*@ where (remove_member) storeA = pure_task_sched_link_member(st.os_tasks.task_desc_map), a = task;
              A = Z $ wakeup_linked
          where (remove_self) node = &(task->task_dync_sched_member.sched_link) $ wakeup_detached */;
    /*@ Assert
          ready_before == st.os_assign.assignReadyVector &&
          os_global_context(sg) &&
          lock == 0 && task == task@pre &&
          (st.os_tasks.task_desc_map(task) == Some(desc) &&
        0 <= desc.tdSchedMember.tsmCurPrio &&
        desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) &&
          task_addr_aligned(task, ready_before) &&
          task_fields(sg, st) *
          delay_inv(sg, st) *
          store_ktask_wakeup_source_post(st.os_tasks.task_desc_map, sched_view) *
          occupy_dll_node(sched_link_of(task)) *
          assign_ready_pending(sg, st)
          $ wakeup_linked wakeup_detached
     */
    KTaskUnSetDelay(task)
      /*@ where (all_case_delay) sg = sg, st_before = st, desc = desc */;
    /*@ Given st_delay from st_after */
    /* Delay 只改 os_delays；这里按已发生的转换重索引调用者资源。 */
    /*@ ktask_unset_delay_step(desc.tdDelay, st, st_delay) &&
        task_fields(sg, st) * assign_ready_pending(sg, st)
        which implies
        ktask_unset_delay_step(desc.tdDelay, st, st_delay) &&
        st_delay.os_tasks == st.os_tasks &&
        st_delay.os_assign == st.os_assign &&
        task_fields(sg, st_delay) * assign_ready_pending(sg, st_delay)
     */
    KTaskInsertToReadyVector(task)
      /*@ where sg = sg, st = st_delay, desc = desc */;
    /*@ Given ready_after from after */
    /*@ (st.os_tasks.task_desc_map(task) == Some(desc) &&
        0 <= desc.tdSchedMember.tsmCurPrio &&
        desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) &&
        st_delay.os_tasks == st.os_tasks &&
        store_ktask_wakeup_source_post(st.os_tasks.task_desc_map, sched_view) *
        delay_inv(sg, st_delay)
        which implies
        store_ktask_wakeup_source_post(
          update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), sched_view) *
        delay_inv(sg, replace_global_ready_vector(ready_after, replace_task_desc_map(update_task_desc_map(task, set_task_desc_ready(desc), st.os_tasks.task_desc_map), st_delay)))
     */
    return EOK;
}

/* 成功分支的 task_inv 已含 ID manager；纯地址等式对应 C 中固定的全局对象。 */
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

    task = GetTaskWithIdnodeInfo(id)
      /*@ where (inside_known) */;

    NULL_PARAM_CHECK_1(task);
    return _KTaskWakeup(task)
      /*@ where (not_suspended) old_stat = old_stat $ not_suspended
          where (wakeup_unified) sg = sg, st = st, desc = desc,
            ready_before = ready_before, sched_view = sched_view $ wakeup_unified */;
}
