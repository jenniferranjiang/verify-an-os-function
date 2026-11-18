#include "m_semaphore.h"
#include "semaphore_runtime_logic.h"
/* Source semaphore.c, fixed dispatch and diagnostic removal; full timeout paths retained. */
x_base CriticalAreaLock(void)
/*@ ordinary
    With (sg : StableGlobalState) (st1 : VarGlobalState)
    Require
      OutsideCritical(sg, st1)
    Ensure
      exists st_lock,
        Crtos_RTrans(st1, st_lock) &&
        InsideCritical(sg, st_lock) *
        os_inv(sg, st_lock)
 */;

void CriticalAreaUnLock(x_base lock)
/*@ stable
    With (sg : StableGlobalState) (st1 st2 : VarGlobalState)
    Require
      Crtos_GTrans(st1, st2) &&
      InsideCritical(sg, st1) *
      os_inv(sg, st2)
    Ensure
      OutsideCritical(sg, st2)
 */;

struct IdNode *IdGetObj(struct IdManager *manager, uint16 id)
/*@ dataqueue_ic_import
    With (sm: StableIdmanager) (m: VarIdmanager)
    Require 0 <= id && id < 65536 && store_idmanager(sm, m, manager)
    Ensure (manager == 0 &&
            __return == 0 &&
            store_idmanager(sm, m, manager))
           ||
           (manager != 0 &&
            __return == 0 &&
            idmanager_query(m, id) == false &&
            store_idmanager(sm, m, manager))
           ||
           (manager != 0 &&
            __return != 0 &&
            idmanager_query(m, id) == true &&
            store_idmanager_found(sm, m, manager, __return, id))
*/;

struct Semaphore *CONTAINER_OF_SEMAPHORE_ID(struct IdNode *id_ptr)
/*@ dataqueue_ic_import
    With (sem_ptr : Z)
    Require id_ptr == field_addr(sem_ptr, struct Semaphore, id) && emp
    Ensure __return == sem_ptr && id_ptr == &(__return->id) && emp
*/;
void KTASK_ASSIGN(void)
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_ktask_assign, X) && OutsideCritical(sg, before)
    Ensure exists after, safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */;


/* New current-source conversion canonical: kernel/common/CalculateTickFromTimeMs.c. */
x_ticks_t CalculateTickFromTimeMs(uint32 ms)
/*@ Require emp Ensure __return == tick_from_time_ms(ms) && emp */;
/* reused-spec: VRTOS kernel/task/get_ktask_descriptor.c / inside_critical. */
KTaskDescriptorType GetKTaskDescriptor(void)
/*@ inside_critical
    With (running_task : Z)
    Require store_ptr(&(Assign.os_running_task), running_task)
    Ensure __return == running_task && store_ptr(&(Assign.os_running_task), running_task)
 */;
/* New semaphore specialization, canonical kernel/pendlist/LinklistSuspend.c. */
x_err_t LinklistSuspend(DoubleLinklistType *list, struct TaskDescriptor *task, uint8 flag)
/*@ semaphore_ic
 With (sg : StableGlobalState) (before : VarGlobalState) (sem : Z) (waiting : list Z)
 Require list == semaphore_pending_head(sem) &&
   semaphore_pending_nodes(sem, before, map(sched_link_node, waiting)) &&
   linklist_suspend_admissible(task, flag, before) && os_inv(sg, before)
 Ensure exists after, linklist_suspend_step(sem, task, flag, before, __return, after) &&
   os_inv(sg, after)
*/
/*@ semaphore_prio_ic <= semaphore_ic
 With (sg : StableGlobalState) (before : VarGlobalState) (sem : Z) (waiting : list Z)
 Require list == semaphore_pending_head(sem) && flag == 1 &&
   semaphore_pending_nodes(sem, before, map(sched_link_node, waiting)) &&
   linklist_suspend_admissible(task, flag, before) && os_inv(sg, before)
 Ensure __return == 0 && exists after,
   linklist_suspend_prio(sem, task, before, after) && os_inv(sg, after)
*/;
x_err_t KTaskSetDelay(KTaskDescriptorType task, x_ticks_t ticks)
/*@ for_null_inactive
    With (sg : StableGlobalState) (st_before : VarGlobalState) (desc : TaskDescriptorAbs)
    Require 0 <= ticks && ticks < KTICK_HALF_RANGE &&
      st_before.os_tasks.task_desc_map(task) == Some(desc) && os_global_context(sg) &&
      (desc.tdDelay == 0 || st_before.os_delays.delay_inactive_map(desc.tdDelay) != None) &&
      delay_list_window(st_before.os_tick, st_before.os_delays.delay_active_nodes) &&
      store_ptr(&(task->task_dync_sched_member.delay), desc.tdDelay) *
      delay_inv(sg, st_before) * tick_inv(sg, st_before)
    Ensure exists st_after delay_after,
      ktask_set_delay_step(task, desc, ticks, delay_after, st_before, __return, st_after) &&
      store_ptr(&(task->task_dync_sched_member.delay), delay_after) *
      delay_inv(sg, st_after) * tick_inv(sg, st_after)
 */
/*@ tick_out_of_bound
    Require ticks >= KTICK_HALF_RANGE && emp
    Ensure __return == -10 && emp
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
;

int32 _SemaphoreObtain(int32 id, int32 msec)
/*@ semaphore_obtain_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_semaphore_obtain(sg, id, msec), X) && OutsideCritical(sg, before)
    Ensure exists after, safeExec(LastSeen(after), return(__return), X) && OutsideCritical(sg, after)
 */
{
    int lock = 0;
    int32 wait_time = 0;
    struct TaskDescriptor *task = NONE;
    struct Semaphore *sem = NONE;
    struct IdNode *idnode = NONE;
    if (id < 0 || id > 65535) return -1;
    if (msec < 0 && msec != -1) return -1;
    if (msec == 0) wait_time = 0;
    else if (msec == -1) wait_time = -1;
    else wait_time = CalculateTickFromTimeMs((uint32)msec);
    lock = CriticalAreaLock();
    idnode = IdGetObj(&k_sem_id_manager, id);
    if (idnode == NONE) { CriticalAreaUnLock(lock); return -1; }
    sem = CONTAINER_OF_SEMAPHORE_ID(idnode);
    if (sem->value > 0) {
        sem->value--;
        CriticalAreaUnLock(lock);
        return 0;
    }
    if (wait_time == 0) { CriticalAreaUnLock(lock); return -2; }
    task = GetKTaskDescriptor();
    task->exstatus = 0;
    LinklistSuspend(&sem->pend_list, task, 1);
    if (wait_time > 0) {
        if (KTaskSetDelay(task, wait_time) != 0) {
            KTaskWakeup(task->id.id);
            CriticalAreaUnLock(lock);
            return -5;
        }
    }
    CriticalAreaUnLock(lock);
    KTASK_ASSIGN();
    /* Source-processing rule: protect only the shared exstatus read. */
    lock = CriticalAreaLock();
    int32 result = task->exstatus;
    CriticalAreaUnLock(lock);
    return result;
}
