#include "m_semaphore.h"
#include "semaphore_runtime_logic.h"
/* Existing global vocabulary for lock-local ownership views. */
/*@ Extern Coq (nat :: *) */
/*@ Extern Coq
 (Z::to_nat : Z -> nat)
 (store_integer : nat -> Z -> Z -> Z -> Assertion)
 (os_tick : VarGlobalState -> Z)
 (os_tasks : VarGlobalState -> TaskState)
 (task_desc_map : TaskState -> Z -> option TaskDescriptorAbs)
 (os_assign : VarGlobalState -> VarAssignAbs)
 (assignRunningTask : VarAssignAbs -> Z)
 (os_semaphores : VarGlobalState -> SemaphoreState)
 (os_semaphore_stable : StableGlobalState -> SemaphoreStable)
 (semaphore_manager_stable : SemaphoreStable -> StableIdmanager)
 (semaphore_manager : SemaphoreState -> VarIdmanager)
 (semaphore_addr : SemaphoreAbs -> Z)
 (semaphore_id : SemaphoreAbs -> Z)
 (semaphore_value : SemaphoreAbs -> Z)
 (semaphore_pending_addrs : SemaphoreAbs -> list Z)
 (semaphore_set_value : Z -> Z -> SemaphoreState -> SemaphoreState)
 (replace_semaphores : SemaphoreState -> VarGlobalState -> VarGlobalState)
 (semaphore_wait_ticks : Z -> Z)
 (semaphore_obtain_after_assign : StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
 (semaphore_clear_status : Z -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState)
 (wand : Assertion -> Assertion -> Assertion)
 (sepcon : Assertion -> Assertion -> Assertion)
 (andp : Assertion -> Assertion -> Assertion)
 (coq_prop : Prop -> Assertion)
 (derivable1 : Assertion -> Assertion -> Prop)
 (store_ushort : Z -> Z -> Assertion)
 (store_int : Z -> Z -> Assertion)
*/
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
/*@ semaphore_prio_ic
 With (sg : StableGlobalState) (before : VarGlobalState) (sem : Z) (waiting : list Z)
 Require list == semaphore_pending_head(sem) && flag == 1 &&
   semaphore_pending_nodes(sem, before, map(sched_link_node, waiting)) &&
   linklist_suspend_admissible(task, flag, before) && os_inv(sg, before)
 Ensure __return == 0 && exists after,
   linklist_suspend_prio(sem, task, before, after) && os_inv(sg, after)
*/;
/* Reused for_null_inactive from VRTOS KTaskSetDelay: only the pure null-or-inactive
 * condition is logically rewritten using decidable integer equality; ownership
 * and Ensure are unchanged. This caller spelling is not textual alpha equality. */
x_err_t KTaskSetDelay(KTaskDescriptorType task, x_ticks_t ticks)
/*@ for_null_inactive
    With (sg : StableGlobalState) (st_before : VarGlobalState) (desc : TaskDescriptorAbs)
    Require 0 <= ticks && ticks < KTICK_HALF_RANGE &&
      st_before.os_tasks.task_desc_map(task) == Some(desc) && os_global_context(sg) &&
      (desc.tdDelay != 0 => st_before.os_delays.delay_inactive_map(desc.tdDelay) != None) &&
      delay_list_window(os_tick(st_before), st_before.os_delays.delay_active_nodes) &&
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
    /* Preserve the actual parameter range for tick conversion and returns. */
    /*@ data_at(&msec, int, msec@pre)
        which implies -2147483648 <= msec@pre && msec@pre <= 2147483647 &&
          store_integer(Z::to_nat(4), 4, &msec, msec@pre) */
    /*@ store_integer(Z::to_nat(4), 4, &msec, msec@pre)
        which implies data_at(&msec, int, msec@pre) */
    if (id < 0 || id > 65535) return -1;
    if (msec < 0 && msec != -1) return -1;
    if (msec == 0) wait_time = 0;
    else if (msec == -1) wait_time = -1;
    else wait_time = CalculateTickFromTimeMs((uint32)msec);
    /*@ Assert id == id@pre && msec == msec@pre &&
      0 <= id && id <= 65535 && -1 <= msec &&
      wait_time == semaphore_wait_ticks(msec) && -1 <= wait_time && wait_time < KTICK_HALF_RANGE &&
      lock == 0 && task == 0 && sem == 0 && idnode == 0 &&
      safeExec(LastSeen(before), abs_semaphore_obtain(sg, id, msec), X) && OutsideCritical(sg, before) */
    lock = CriticalAreaLock();
    /*@ Assert exists (held : VarGlobalState) saved,
      id == id@pre && msec == msec@pre &&
      0 <= id && id <= 65535 && -1 <= msec &&
      wait_time == semaphore_wait_ticks(msec) && -1 <= wait_time && wait_time < KTICK_HALF_RANGE &&
      lock == saved && task == 0 && sem == 0 && idnode == 0 &&
      Crtos_RTrans(before, held) &&
      safeExec(LastSeen(before), abs_semaphore_obtain(sg, id, msec), X) &&
      InsideCritical(sg, held) * os_inv(sg, held) */
    /*@ Given held saved */
    /*@ os_inv(sg, held) which implies
      store_idmanager(semaphore_manager_stable(os_semaphore_stable(sg)), semaphore_manager(os_semaphores(held)), &k_sem_id_manager) *
      wand(store_idmanager(semaphore_manager_stable(os_semaphore_stable(sg)), semaphore_manager(os_semaphores(held)), &k_sem_id_manager), os_inv(sg, held)) */
    idnode = IdGetObj(&k_sem_id_manager, id);
    if (idnode == NONE) {
        /*@ Assert id == id@pre && msec == msec@pre && 0 <= id && id <= 65535 && -1 <= msec && lock == saved &&
          wait_time == semaphore_wait_ticks(msec) && task == 0 && sem == 0 && idnode == 0 &&
          safeExec(LastSeen(held), return(-1), X) && Crtos_GTrans(held, held) &&
          InsideCritical(sg, held) * os_inv(sg, held) */
        CriticalAreaUnLock(lock); return -1;
    }
    /*@ Assert exists (original : SemaphoreAbs),
      id == id@pre && msec == msec@pre && 0 <= id && id <= 65535 && -1 <= msec && lock == saved &&
      wait_time == semaphore_wait_ticks(msec) && -1 <= wait_time && wait_time < KTICK_HALF_RANGE &&
      0 <= id && id <= 65535 && task == 0 && sem == 0 &&
      In(original, os_semaphores(held)) && semaphore_id(original) == id &&
      semaphore_addr(original) != 0 && 0 <= semaphore_value(original) && semaphore_value(original) <= 65535 &&
      idnode == field_addr(semaphore_addr(original), struct Semaphore, id) &&
      Crtos_RTrans(before, held) && safeExec(LastSeen(before), abs_semaphore_obtain(sg, id, msec), X) &&
      InsideCritical(sg, held) * os_inv(sg, held) */
    /*@ Given original */
    sem = CONTAINER_OF_SEMAPHORE_ID(idnode);
    /*@ In(original, os_semaphores(held)) && sem == semaphore_addr(original) && os_inv(sg, held)
      which implies sem == semaphore_addr(original) &&
      ((0 < semaphore_value(original) &&
        store_ushort(&sem->value, semaphore_value(original)) *
        wand(store_ushort(&sem->value, semaphore_value(original)-1),
          os_inv(sg, replace_semaphores(semaphore_set_value(sem, semaphore_value(original)-1, os_semaphores(held)), held)))) ||
       (semaphore_value(original) == 0 &&
        store_ushort(&sem->value, 0) * wand(store_ushort(&sem->value, 0), os_inv(sg, held)))) */
    /*@ store_ushort(&sem->value, semaphore_value(original)) which implies sem->value == semaphore_value(original) */
    if (sem->value > 0) {
        sem->value--;
        /*@ Assert id == id@pre && msec == msec@pre && 0 <= id && id <= 65535 && -1 <= msec && lock == saved &&
          wait_time == semaphore_wait_ticks(msec) && task == 0 && sem == semaphore_addr(original) &&
          idnode == field_addr(sem, struct Semaphore, id) &&
          safeExec(LastSeen(replace_semaphores(semaphore_set_value(sem, semaphore_value(original)-1, os_semaphores(held)), held)), return(0), X) &&
          Crtos_GTrans(held, replace_semaphores(semaphore_set_value(sem, semaphore_value(original)-1, os_semaphores(held)), held)) &&
          InsideCritical(sg, held) * os_inv(sg, replace_semaphores(semaphore_set_value(sem, semaphore_value(original)-1, os_semaphores(held)), held)) */
        CriticalAreaUnLock(lock);
        return 0;
    }
    /*@ sem == semaphore_addr(original) && (sem->value == 0) * wand(store_ushort(&sem->value, 0), os_inv(sg, held))
      which implies sem == semaphore_addr(original) && os_inv(sg, held) */
    if (wait_time == 0) {
        /*@ Assert id == id@pre && msec == msec@pre && 0 <= id && id <= 65535 && -1 <= msec && lock == saved &&
          wait_time == 0 && task == 0 && sem == semaphore_addr(original) &&
          idnode == field_addr(sem, struct Semaphore, id) &&
          safeExec(LastSeen(held), return(-2), X) && Crtos_GTrans(held, held) &&
          InsideCritical(sg, held) * os_inv(sg, held) */
        CriticalAreaUnLock(lock); return -2;
    }
    /*@ Assert id == id@pre && msec == msec@pre && 0 <= id && id <= 65535 && -1 <= msec && lock == saved &&
      wait_time == semaphore_wait_ticks(msec) && wait_time != 0 && -1 <= wait_time && wait_time < KTICK_HALF_RANGE &&
      task == 0 && sem == semaphore_addr(original) && idnode == field_addr(sem, struct Semaphore, id) &&
      In(original, os_semaphores(held)) && semaphore_id(original) == id && semaphore_value(original) == 0 &&
      linklist_suspend_admissible(assignRunningTask(os_assign(held)), 1, held) &&
      (forall (entry_desc : TaskDescriptorAbs) (entry_suspended : VarGlobalState) (entry_sd : TaskDescriptorAbs),
        task_desc_map(os_tasks(held), assignRunningTask(os_assign(held))) == Some(entry_desc) =>
        linklist_suspend_prio(semaphore_addr(original), assignRunningTask(os_assign(held)),
          semaphore_clear_status(assignRunningTask(os_assign(held)), entry_desc, held), entry_suspended) =>
        task_desc_map(os_tasks(entry_suspended), assignRunningTask(os_assign(held))) == Some(entry_sd) =>
        0 < wait_time =>
          ((entry_sd.tdDelay == 0 || entry_suspended.os_delays.delay_inactive_map(entry_sd.tdDelay) != None) &&
           delay_list_window(os_tick(entry_suspended), entry_suspended.os_delays.delay_active_nodes))) &&
      Crtos_RTrans(before, held) && safeExec(LastSeen(before), abs_semaphore_obtain(sg, id, msec), X) &&
      InsideCritical(sg, held) * os_inv(sg, held) */
    /*@ os_inv(sg, held) which implies
      store_ptr(&(Assign.os_running_task), assignRunningTask(os_assign(held))) *
      wand(store_ptr(&(Assign.os_running_task), assignRunningTask(os_assign(held))), os_inv(sg, held)) */
    task = GetKTaskDescriptor();
    /*@ task == assignRunningTask(os_assign(held)) &&
      store_ptr(&(Assign.os_running_task), task) *
      wand(store_ptr(&(Assign.os_running_task), task), os_inv(sg, held))
      which implies task == assignRunningTask(os_assign(held)) && os_inv(sg, held) */
    /*@ Assert exists (desc : TaskDescriptorAbs),
      id == id@pre && msec == msec@pre && 0 <= id && id <= 65535 && -1 <= msec && lock == saved &&
      wait_time == semaphore_wait_ticks(msec) && wait_time != 0 && -1 <= wait_time && wait_time < KTICK_HALF_RANGE &&
      task == assignRunningTask(os_assign(held)) && task_desc_map(os_tasks(held), task) == Some(desc) &&
      sem == semaphore_addr(original) && idnode == field_addr(sem, struct Semaphore, id) &&
      In(original, os_semaphores(held)) && semaphore_id(original) == id && semaphore_value(original) == 0 &&
      linklist_suspend_admissible(assignRunningTask(os_assign(held)), 1, held) &&
      (forall (entry_desc : TaskDescriptorAbs) (entry_suspended : VarGlobalState) (entry_sd : TaskDescriptorAbs),
        task_desc_map(os_tasks(held), assignRunningTask(os_assign(held))) == Some(entry_desc) =>
        linklist_suspend_prio(semaphore_addr(original), assignRunningTask(os_assign(held)),
          semaphore_clear_status(assignRunningTask(os_assign(held)), entry_desc, held), entry_suspended) =>
        task_desc_map(os_tasks(entry_suspended), assignRunningTask(os_assign(held))) == Some(entry_sd) =>
        0 < wait_time =>
          ((entry_sd.tdDelay == 0 || entry_suspended.os_delays.delay_inactive_map(entry_sd.tdDelay) != None) &&
           delay_list_window(os_tick(entry_suspended), entry_suspended.os_delays.delay_active_nodes))) &&
      Crtos_RTrans(before, held) && safeExec(LastSeen(before), abs_semaphore_obtain(sg, id, msec), X) &&
      InsideCritical(sg, held) * store_int(&task->exstatus, desc.tdExstatus) *
      wand(store_int(&task->exstatus, 0), os_inv(sg, semaphore_clear_status(task, desc, held))) */
    /*@ Given desc */
    /*@ store_int(&task->exstatus, desc.tdExstatus) which implies task->exstatus == desc.tdExstatus */
    task->exstatus = 0;
    /*@ Assert id == id@pre && msec == msec@pre && 0 <= id && id <= 65535 && -1 <= msec && lock == saved &&
      wait_time == semaphore_wait_ticks(msec) && wait_time != 0 && -1 <= wait_time && wait_time < KTICK_HALF_RANGE &&
      task == assignRunningTask(os_assign(held)) && task_desc_map(os_tasks(held), task) == Some(desc) &&
      sem == semaphore_addr(original) && idnode == field_addr(sem, struct Semaphore, id) &&
      In(original, os_semaphores(held)) && semaphore_id(original) == id && semaphore_value(original) == 0 &&
      linklist_suspend_admissible(assignRunningTask(os_assign(held)), 1, held) &&
      (forall (entry_desc : TaskDescriptorAbs) (entry_suspended : VarGlobalState) (entry_sd : TaskDescriptorAbs),
        task_desc_map(os_tasks(held), assignRunningTask(os_assign(held))) == Some(entry_desc) =>
        linklist_suspend_prio(semaphore_addr(original), assignRunningTask(os_assign(held)),
          semaphore_clear_status(assignRunningTask(os_assign(held)), entry_desc, held), entry_suspended) =>
        task_desc_map(os_tasks(entry_suspended), assignRunningTask(os_assign(held))) == Some(entry_sd) =>
        0 < wait_time =>
          ((entry_sd.tdDelay == 0 || entry_suspended.os_delays.delay_inactive_map(entry_sd.tdDelay) != None) &&
           delay_list_window(os_tick(entry_suspended), entry_suspended.os_delays.delay_active_nodes))) &&
      Crtos_RTrans(before, held) && safeExec(LastSeen(before), abs_semaphore_obtain(sg, id, msec), X) &&
      semaphore_pending_nodes(sem, semaphore_clear_status(task, desc, held), map(sched_link_node, semaphore_pending_addrs(original))) &&
      linklist_suspend_admissible(task, 1, semaphore_clear_status(task, desc, held)) &&
      InsideCritical(sg, held) * os_inv(sg, semaphore_clear_status(task, desc, held)) */
    LinklistSuspend(&sem->pend_list, task, 1)
      /*@ where (semaphore_prio_ic) sg = sg, before = semaphore_clear_status(task, desc, held),
          sem = sem, waiting = semaphore_pending_addrs(original) */;
    /*@ Assert exists (suspended : VarGlobalState) (sd : TaskDescriptorAbs),
      id == id@pre && msec == msec@pre && 0 <= id && id <= 65535 && -1 <= msec && lock == saved &&
      wait_time == semaphore_wait_ticks(msec) && wait_time != 0 && -1 <= wait_time && wait_time < KTICK_HALF_RANGE &&
      task == assignRunningTask(os_assign(held)) && task != 0 && task_desc_map(os_tasks(held), task) == Some(desc) &&
      sem == semaphore_addr(original) && idnode == field_addr(sem, struct Semaphore, id) &&
      In(original, os_semaphores(held)) && semaphore_id(original) == id && semaphore_value(original) == 0 &&
      linklist_suspend_prio(sem, task, semaphore_clear_status(task, desc, held), suspended) &&
      task_desc_map(os_tasks(suspended), task) == Some(sd) && sd.tdSchedMember.tsmStat == TSK_SUSPEND &&
      (0 < wait_time =>
        ((sd.tdDelay == 0 || suspended.os_delays.delay_inactive_map(sd.tdDelay) != None) &&
         delay_list_window(os_tick(suspended), suspended.os_delays.delay_active_nodes))) &&
      Crtos_RTrans(before, held) && safeExec(LastSeen(before), abs_semaphore_obtain(sg, id, msec), X) &&
      InsideCritical(sg, held) * os_inv(sg, suspended) */
    /*@ Given suspended sd */
    if (wait_time > 0) {
        /* The residual resource is fixed across the imported local Delay API.
         * Its restoration entailment is an actual generated VC, not a lemma assumption. */
        /*@ Assert exists (delay_frame : Assertion),
          id == id@pre && msec == msec@pre && 0 <= id && id <= 65535 && -1 <= msec && lock == saved &&
          wait_time == semaphore_wait_ticks(msec) && 0 < wait_time && wait_time < KTICK_HALF_RANGE &&
          task == assignRunningTask(os_assign(held)) && task != 0 && task_desc_map(os_tasks(held), task) == Some(desc) &&
          sem == semaphore_addr(original) && idnode == field_addr(sem, struct Semaphore, id) &&
          In(original, os_semaphores(held)) && semaphore_id(original) == id && semaphore_value(original) == 0 &&
          linklist_suspend_prio(sem, task, semaphore_clear_status(task, desc, held), suspended) &&
          task_desc_map(os_tasks(suspended), task) == Some(sd) && sd.tdSchedMember.tsmStat == TSK_SUSPEND &&
          (sd.tdDelay == 0 || suspended.os_delays.delay_inactive_map(sd.tdDelay) != None) &&
          delay_list_window(os_tick(suspended), suspended.os_delays.delay_active_nodes) && os_global_context(sg) &&
          (forall (delayed : VarGlobalState) (dp rc : Z),
            ktask_set_delay_step(task, sd, wait_time, dp, suspended, rc, delayed) =>
            derivable1(sepcon(store_ptr(&task->task_dync_sched_member.delay, dp),
              sepcon(delay_inv(sg, delayed), sepcon(tick_inv(sg, delayed), delay_frame))), os_inv(sg, delayed))) &&
          Crtos_RTrans(before, held) && safeExec(LastSeen(before), abs_semaphore_obtain(sg, id, msec), X) &&
          InsideCritical(sg, held) * store_ptr(&task->task_dync_sched_member.delay, sd.tdDelay) *
          delay_inv(sg, suspended) * tick_inv(sg, suspended) * andp(coq_prop(os_global_context(sg)), delay_frame) */
        /*@ Given delay_frame */
        if (KTaskSetDelay(task, wait_time) /*@ where (for_null_inactive) sg = sg, st_before = suspended, desc = sd */ != 0) {
            /*@ Assert id == id@pre && msec == msec@pre &&
              0 <= id && id <= 65535 && -1 <= msec && lock == saved &&
              wait_time == semaphore_wait_ticks(msec) && 0 < wait_time && wait_time < KTICK_HALF_RANGE &&
              task == assignRunningTask(os_assign(held)) && task != 0 && task_desc_map(os_tasks(held), task) == Some(desc) &&
              sem == semaphore_addr(original) && idnode == field_addr(sem, struct Semaphore, id) &&
              In(original, os_semaphores(held)) && semaphore_id(original) == id && semaphore_value(original) == 0 &&
              linklist_suspend_prio(sem, task, semaphore_clear_status(task, desc, held), suspended) &&
              task_desc_map(os_tasks(suspended), task) == Some(sd) && sd.tdSchedMember.tsmStat == TSK_SUSPEND &&
              ktask_set_delay_step(task, sd, wait_time, 0, suspended, -5, suspended) &&
              Crtos_RTrans(before, held) && safeExec(LastSeen(before), abs_semaphore_obtain(sg, id, msec), X) &&
              InsideCritical(sg, held) * os_inv(sg, suspended) */
            /*@ task == assignRunningTask(os_assign(held)) &&
                task_desc_map(os_tasks(suspended), task) == Some(sd) && os_inv(sg, suspended)
              which implies exists (rollback_id : Z),
                task == assignRunningTask(os_assign(held)) && 0 <= rollback_id && rollback_id < 65536 &&
                get_task_with_idnode_success(sg, suspended, rollback_id, task) &&
                (task->id.id == rollback_id) *
                wand(store_ushort(field_addr(field_addr(task, struct TaskDescriptor, id), struct IdNode, id), rollback_id), os_inv(sg, suspended)) */
            /*@ Given rollback_id */
            int32 wakeup_id = task->id.id;
            /*@ task == assignRunningTask(os_assign(held)) && wakeup_id == rollback_id &&
                (task->id.id == rollback_id) *
                wand(store_ushort(field_addr(field_addr(task, struct TaskDescriptor, id), struct IdNode, id), rollback_id), os_inv(sg, suspended))
              which implies task == assignRunningTask(os_assign(held)) && wakeup_id == rollback_id && os_inv(sg, suspended) */
            KTaskWakeup(wakeup_id) /*@ where (wakeup_by_id_ic) sg = sg, before = suspended */;
            /*@ Assert exists (after_wakeup : VarGlobalState),
              id == id@pre && msec == msec@pre && lock == saved &&
              wait_time == semaphore_wait_ticks(msec) && task == assignRunningTask(os_assign(held)) &&
              sem == semaphore_addr(original) && idnode == field_addr(sem, struct Semaphore, id) && wakeup_id == rollback_id &&
              safeExec(LastSeen(after_wakeup), return(-5), X) && Crtos_GTrans(held, after_wakeup) &&
              InsideCritical(sg, held) * os_inv(sg, after_wakeup) */
            /*@ Given after_wakeup */
            CriticalAreaUnLock(lock);
            return -5;
        }
    }
    /*@ Assert exists (prepared : VarGlobalState) (Y : unit -> (VarGlobalState -> Prop) -> Prop),
      id == id@pre && msec == msec@pre && lock == saved &&
      wait_time == semaphore_wait_ticks(msec) && task == assignRunningTask(os_assign(held)) && task != 0 &&
      sem == semaphore_addr(original) && idnode == field_addr(sem, struct Semaphore, id) &&
      safeExec(LastSeen(prepared), abs_ktask_assign, Y) &&
      (forall (st : VarGlobalState), safeExec(LastSeen(st), return(tt), Y) =>
        safeExec(LastSeen(st), semaphore_obtain_after_assign(sg, task), X)) &&
      Crtos_GTrans(held, prepared) && InsideCritical(sg, held) * os_inv(sg, prepared) */
    /*@ Given prepared Y */
    CriticalAreaUnLock(lock);
    KTASK_ASSIGN() /*@ where (outside_critical) sg = sg, before = prepared, X = Y */;
    /* Source-processing rule: protect only the shared exstatus read. */
    /*@ Assert exists (scheduled : VarGlobalState),
      id == id@pre && msec == msec@pre && lock == saved &&
      wait_time == semaphore_wait_ticks(msec) && task == assignRunningTask(os_assign(held)) &&
      sem == semaphore_addr(original) && idnode == field_addr(sem, struct Semaphore, id) &&
      safeExec(LastSeen(scheduled), semaphore_obtain_after_assign(sg, task), X) && OutsideCritical(sg, scheduled) */
    /*@ Given scheduled */
    lock = CriticalAreaLock();
    /*@ Assert exists (observed : VarGlobalState) (status_desc : TaskDescriptorAbs) saved_status,
      id == id@pre && msec == msec@pre && lock == saved_status &&
      wait_time == semaphore_wait_ticks(msec) && task == assignRunningTask(os_assign(held)) &&
      sem == semaphore_addr(original) && idnode == field_addr(sem, struct Semaphore, id) &&
      Crtos_RTrans(scheduled, observed) &&
      safeExec(LastSeen(scheduled), semaphore_obtain_after_assign(sg, task), X) &&
      task_desc_map(os_tasks(observed), task) == Some(status_desc) &&
      InsideCritical(sg, observed) * store_int(&task->exstatus, status_desc.tdExstatus) *
      wand(store_int(&task->exstatus, status_desc.tdExstatus), os_inv(sg, observed)) */
    /*@ Given observed status_desc saved_status */
    /*@ store_int(&task->exstatus, status_desc.tdExstatus) which implies task->exstatus == status_desc.tdExstatus */
    int32 result = task->exstatus;
    /*@ Assert id == id@pre && msec == msec@pre && lock == saved_status &&
      wait_time == semaphore_wait_ticks(msec) && task == assignRunningTask(os_assign(held)) &&
      sem == semaphore_addr(original) && idnode == field_addr(sem, struct Semaphore, id) && result == status_desc.tdExstatus &&
      safeExec(LastSeen(observed), return(result), X) && Crtos_GTrans(observed, observed) &&
      InsideCritical(sg, observed) * os_inv(sg, observed) */
    CriticalAreaUnLock(lock);
    return result;
}
