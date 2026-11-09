#include "../include/slice_types.h"
#include "../include/logic.h"

/* Source: kernel/thread/linklist.c:110-132.  LinklistResumeAll is a common
 * pend-list operation.  Its canonical OC contract is parameterized by one
 * PendlistTarget; Mutex is only an instantiation at its caller.  Both real
 * lock/unlock calls are retained. */
/* The checked safeExec condition guarantees that the selected target is
 * still published at the actual lock observation.  This named contract is
 * not an unconditional consequence of the system-wide True rely. */
x_base CriticalAreaLock(void)
/*@ pendlist_live_target
    With (sg : StableGlobalState) (before : VarGlobalState)
         (target : PendlistTarget)
    Require linklist_resume_all_entry_condition(target, Crtos_RTrans(before)) &&
      OutsideCritical(sg, before)
    Ensure exists st_lock,
      Crtos_RTrans(before, st_lock) && pendlist_live(target, st_lock) &&
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
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState)
         (target : PendlistTarget) X
    Require list == pendlist_head(target) &&
      safeExec(LastSeen(before), abs_linklist_resume_all(target), X) &&
      OutsideCritical(sg, before)
    Ensure __return == KOK && exists after,
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */
{
    x_ubase lock = 0;
    struct TaskDescriptor *task = NONE;
    DoubleLinklistType *node = NONE;
    if (list == NONE) {
        /*@ Inv Assert list == list@pre && list == 0 &&
          list == pendlist_head(target) &&
          safeExec(LastSeen(before), abs_linklist_resume_all(target), X) &&
          has_permission(&task) * has_permission(&node) * has_permission(&lock) *
          OutsideCritical(sg, before)
         */
        while (1) { }
    }

    /*@ safeExec(LastSeen(before), abs_linklist_resume_all(target), X)
        which implies
        linklist_resume_all_entry_condition(target, Crtos_RTrans(before))
     */
    lock = CriticalAreaLock()
      /*@ where (pendlist_live_target) sg = sg, before = before, target = target */;
    while (1) {
        node = list->node_next;
        if (node != list) {
            task = CONTAINER_OF_TASK_SCHED(node);
            task->exstatus = -ERROR;
            /* Equivalent normalization: read the original uint16 argument once;
             * only ghost annotations separate this read from its call. */
            int32 resume_task_id = task->id.id;
            KTaskWakeup(resume_task_id);
        } else {
            break;
        }
    }
    CriticalAreaUnLock(lock);
    return EOK;
}
