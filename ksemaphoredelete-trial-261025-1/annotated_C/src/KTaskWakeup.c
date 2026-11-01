#include "../include/slice_types.h"
#include "../include/logic.h"

/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/ktask.c. Current 32-bit non-SMP configuration. */
struct TaskDescriptor *GetTaskWithIdnodeInfo(int32 id)
/*@ inside_critical
    With (sg : StableGlobalState) (st : VarGlobalState)
    Require
      id < 65536 && task_world_wf(st) &&
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
 */
;

x_err_t _KTaskWakeup(KTaskDescriptorType task)
/*@ wakeup_general_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
         (desc : TaskDescriptorAbs)
    Require
      before.os_tasks.task_desc_map(task) == Some(desc) &&
      os_inv(sg, before)
    Ensure exists after,
      task != 0 &&
      ((desc.tdSchedMember.tsmStat != TSK_SUSPEND &&
        __return == -1 && after == before) ||
       (desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
        __return == 0 && ktask_wakeup_step(task, desc, before, after))) &&
      os_inv(sg, after)
 */
;

x_err_t KTaskWakeup(int32 id)
/*@ wakeup_by_id_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require id < 65536 && os_inv(sg, before)
    Ensure exists (task : Z) (desc : TaskDescriptorAbs) (after : VarGlobalState),
      task != 0 && get_task_with_idnode_success(sg, before, id, task) &&
      before.os_tasks.task_desc_map(task) == Some(desc) &&
      ((desc.tdSchedMember.tsmStat != TSK_SUSPEND && __return == -1 && after == before)
       ||
       (desc.tdSchedMember.tsmStat == TSK_SUSPEND && __return == 0 &&
        ktask_wakeup_step(task, desc, before, after))) && os_inv(sg, after)
 */
/*@ detached_sched_null_delay <= wakeup_by_id_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require id < 65536 && ktask_wakeup_detached_null_condition(sg, before, id) &&
      os_inv(sg, before)
    Ensure exists (task : Z) (desc : TaskDescriptorAbs) (after : VarGlobalState),
      task != 0 && get_task_with_idnode_success(sg, before, id, task) &&
      before.os_tasks.task_desc_map(task) == Some(desc) && desc.tdDelay == 0 &&
      ((desc.tdSchedMember.tsmStat != TSK_SUSPEND && __return == -1 && after == before)
       ||
       (desc.tdSchedMember.tsmStat == TSK_SUSPEND && __return == 0 &&
          ktask_wakeup_detached_null_step(task, desc, before, after))) &&
      os_inv(sg, after)
 */
/*@ semaphore_pending_head_ic <= wakeup_by_id_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
      (sem task : Z) (rest : list(DL_Node Z))
    Require id < 65536 && get_task_with_idnode_success(sg, before, id, task) &&
      semaphore_pending_nodes(sem, before, cons(sched_link_node(task), rest)) &&
      os_inv(sg, before)
    Ensure exists (desc : TaskDescriptorAbs) (after : VarGlobalState),
      __return == 0 && task != 0 &&
      before.os_tasks.task_desc_map(task) == Some(desc) &&
      desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
      wakeup_semaphore_head(sem, task, desc, before, after) &&
      semaphore_pending_nodes(sem, after, rest) && os_inv(sg, after)
 */
/*@ msgqueue_send_pending_head_ic <= wakeup_by_id_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
      (mq task : Z) (rest : list(DL_Node Z))
    Require id < 65536 && get_task_with_idnode_success(sg, before, id, task) &&
      msgqueue_send_pending_nodes(mq, before, cons(sched_link_node(task), rest)) &&
      os_inv(sg, before)
    Ensure exists (desc : TaskDescriptorAbs) (after : VarGlobalState),
      __return == 0 && task != 0 &&
      before.os_tasks.task_desc_map(task) == Some(desc) &&
      desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
      wakeup_msgqueue_send_head(mq, task, desc, before, after) &&
      msgqueue_send_pending_nodes(mq, after, rest) && os_inv(sg, after)
 */
/*@ msgqueue_recv_pending_head_ic <= wakeup_by_id_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
      (mq task : Z) (rest : list(DL_Node Z))
    Require id < 65536 && get_task_with_idnode_success(sg, before, id, task) &&
      msgqueue_recv_pending_nodes(mq, before, cons(sched_link_node(task), rest)) &&
      os_inv(sg, before)
    Ensure exists (desc : TaskDescriptorAbs) (after : VarGlobalState),
      __return == 0 && task != 0 &&
      before.os_tasks.task_desc_map(task) == Some(desc) &&
      desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
      wakeup_msgqueue_recv_head(mq, task, desc, before, after) &&
      msgqueue_recv_pending_nodes(mq, after, rest) && os_inv(sg, after)
 */
{
    x_base lock = 0;
    struct TaskDescriptor *task = NONE;

    task = GetTaskWithIdnodeInfo(id) /*@ where (inside_critical) sg = sg, st = before */;
    if (task == NONE) { while (1) { } }

    return _KTaskWakeup(task) /*@ where (wakeup_general_ic) sg = sg, before = before */;
}
