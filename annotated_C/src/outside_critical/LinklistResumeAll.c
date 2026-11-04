#include "../../include/mutex_delete_types.h"
#include "../../include/mutex_delete_logic.h"

/* Source: kernel/thread/linklist.c:110-132. This is a NEW mutex/outside
 * contract, not derived from the root semaphore_waiters contract. Both
 * real lock/unlock calls are retained. KTaskWakeup is the existing inside
 * reused-spec boundary; its nested locks are covered by that adaptation.
 */
/* A1: caller-scoped trusted environment contract, NOT a consequence of
 * ordinary CriticalAreaLock. Only this experiment's approved delete chain
 * may select it. The same allocation stays published between its lookup
 * and this acquisition; other fields and OS modules may change. */
x_base CriticalAreaLock(void)
/*@ mutex_live
    With (sg : StableGlobalState) (before : VarGlobalState) (p id : Z)
    Require mutex_delete_live(p, id, before) && OutsideCritical(sg, before)
    Ensure exists st_lock,
      Crtos_RTrans(before, st_lock) && mutex_delete_live(p, id, st_lock) &&
      InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
 */;

void CriticalAreaUnLock(x_base lock)
/*@ stable
    With (sg : StableGlobalState) (st1 st2 : VarGlobalState)
    Require Crtos_GTrans(st1, st2) &&
      InsideCritical(sg, st1) * os_inv(sg, st2)
    Ensure OutsideCritical(sg, st2)
 */;

struct TaskDescriptor *CONTAINER_OF_TASK_SCHED(DoubleLinklistType *sched_link_ptr)
/*@ With task_ptr
    Require addr_aligned(task_ptr, ALIGN_SIZE) &&
      sched_link_ptr == sched_link_of(task_ptr) && emp
    Ensure __return == task_ptr && addr_aligned(__return, ALIGN_SIZE) &&
      sched_link_ptr == &(__return->task_dync_sched_member.sched_link)
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
 */;

x_err_t LinklistResumeAll(DoubleLinklistType *list)
/*@ mutex_waiters_oc
    With (sg : StableGlobalState) (before : VarGlobalState) (p id : Z) X
    Require list == mutex_pending_head(p) &&
      mutex_delete_live(p, id, before) &&
      safeExec(LastSeen(before), abs_mutex_resume_all(p, id), X) &&
      OutsideCritical(sg, before)
    Ensure __return == KOK && exists after,
      mutex_delete_drained(p, id, after) &&
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */
{
    x_ubase lock = 0;
    struct TaskDescriptor *task = NONE;
    DoubleLinklistType *node = NONE;
    if (list == NONE) { while (1) { } }

    lock = CriticalAreaLock()
      /*@ where (mutex_live) sg = sg, before = before, p = p, id = id */;
    for (;;) {
        node = list->node_next;
        if (node != list) {
            task = CONTAINER_OF_TASK_SCHED(node);
            task->exstatus = -ERROR;
            KTaskWakeup(task->id.id) /*@ where (wakeup_by_id_ic) sg = sg */;
        } else {
            break;
        }
    }
    CriticalAreaUnLock(lock) /*@ where (stable) sg = sg */;
    return EOK;
}
