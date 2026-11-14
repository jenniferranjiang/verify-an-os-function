#include "mutex_delete_types.h"
#include "mutex_delete_logic.h"

/* TrustBase ordinary global critical contracts; no delete-specific variant. */
x_base CriticalAreaLock(void)
/*@ ordinary
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require OutsideCritical(sg, before)
    Ensure exists current,
      Crtos_RTrans(before, current) &&
      InsideCritical(sg, current) * os_inv(sg, current)
 */;
void CriticalAreaUnLock(x_base lock)
/*@ ordinary
    With (sg : StableGlobalState) (before after : VarGlobalState)
    Require Crtos_GTrans(before, after) &&
      InsideCritical(sg, before) * os_inv(sg, after)
    Ensure OutsideCritical(sg, after)
 */;

inline void NULL_PARAM_CHECK_1(void *p)
/*@ Require emp Ensure p != 0 */;
/* TrustBase CONTAINER_OF model; TaskDescriptor.sched_link offset 16. */
struct TaskDescriptor *CONTAINER_OF_TASK_SCHED(DoubleLinklistType *sched_link_ptr)
/*@ With (p : addr)
    Require addr_aligned(p, ALIGN_SIZE) && sched_link_ptr == sched_link_of(p) && emp
    Ensure __return == p && addr_aligned(__return, ALIGN_SIZE) &&
      sched_link_ptr == &(__return->task_dync_sched_member.sched_link)
 */;
/* Reused-spec: 8a16fffe3e029b56de598baa16f43865da85b92b,
 * annotated_C/src/headers/ktask_wakeup.h. No new trusted wakeup boundary. */
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
 */;

/* Fresh mutex scenario, not imported from any prior LinklistResumeAll spec.
 * The public operation denotes the whole batch, not its loop trace. */
x_err_t LinklistResumeAll(DoubleLinklistType *list)
/*@ mutex_waiters_oc
    With (sg : StableGlobalState) (before : VarGlobalState) (p : addr) X
    Require list == mutex_pending_head(p) &&
      safeExec(LastSeen(before), abs_linklist_resume_all(sg, p), X) &&
      OutsideCritical(sg, before)
    Ensure __return == 0 && exists after,
      safeExec(LastSeen(after), return(__return), X) &&
      OutsideCritical(sg, after)
 */
/*@ null_only
    Require list == 0 && emp
    Ensure 0 == 1 && emp
 */
{
    x_ubase lock = 0;
    struct TaskDescriptor *task = NONE;
    DoubleLinklistType *node = NONE;
    NULL_PARAM_CHECK_1(list);
    lock = CriticalAreaLock();
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
    CriticalAreaUnLock(lock);
    return EOK;
}

