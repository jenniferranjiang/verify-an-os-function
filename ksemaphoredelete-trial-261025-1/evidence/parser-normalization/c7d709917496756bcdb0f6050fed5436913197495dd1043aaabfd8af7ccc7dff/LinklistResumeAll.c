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
;

/* waiting 是调用前的挂起任务序列。正常返回时原等待任务均为 READY、
 * exstatus=-ERROR，等待链为空；整体效果还约束延时、就绪队列及其余状态变化。
 */
x_err_t LinklistResumeAll(DoubleLinklistType *list)
/*@ semaphore_waiters
    With (sg : StableGlobalState) (before : VarGlobalState)
         (sem : addr) (waiting : list addr)
    Require list == semaphore_pending_head(sem) &&
      semaphore_pending_nodes(sem, before, map(sched_link_node, waiting)) &&
      os_inv(sg, before)
    Ensure __return == KOK && exists after,
      semaphore_resume_all_effect(sem, waiting, before, after) &&
      semaphore_pending_nodes(sem, after, nil) && os_inv(sg, after)
 */
{
    x_ubase lock = 0;
    struct TaskDescriptor *task = ((void *)0);
    DoubleLinklistType *node = ((void *)0);

    if (list == ((void *)0)) { /*@ Inv os_inv(sg, before) */ while (1) { } }

    /* Nested critical operation removed under the documented inside-critical adaptation. */
    for(;;) {
        node = list->node_next;
        if(node != list) {
            task = CONTAINER_OF_TASK_SCHED(node);
            task->exstatus = -ERROR;
            KTaskWakeup(task->id.id) /*@ where (semaphore_pending_head_ic) sg = sg, sem = sem */;
        } else {
            break;
        }
    }
    

    return EOK;
}
