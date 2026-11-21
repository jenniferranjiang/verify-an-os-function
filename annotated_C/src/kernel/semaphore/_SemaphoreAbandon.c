#include "m_semaphore.h"
#include "semaphore_runtime_logic.h"
/*@ Import Coq Import SimpleC.CoreLang.CTypes.SimpleCtypeNotations */
/*@ Extern Coq
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
 (os_tasks : VarGlobalState -> TaskState)
 (task_desc_map : TaskState -> Z -> option TaskDescriptorAbs)
 (wand : Assertion -> Assertion -> Assertion)
 (store_ushort : Z -> Z -> Assertion)
*/
/*@ Extern Coq Record VarGlobalState {
  os_semaphores: SemaphoreState;
  os_tasks: TaskState;
} */
/*@ Extern Coq Record StableGlobalState {
  os_semaphore_stable: SemaphoreStable;
} */
/*@ Extern Coq Record SemaphoreStable {
  semaphore_manager_stable: StableIdmanager;
} */
/*@ Extern Coq Record SemaphoreAbs {
  semaphore_addr: Z;
  semaphore_id: Z;
  semaphore_value: Z;
  semaphore_pending_addrs: list Z;
} */
/*@ Extern Coq Record TaskState {
  task_desc_map: Z -> option TaskDescriptorAbs;
} */
/* Source semaphore.c: fixed done dispatch; diagnostics removed under TrustBase. */
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

int IsDoubleLinkListEmpty(const DoubleLinklistType *linklist)
/*@ dataqueue_ic_dll
    With {A} (storeA : Z -> A -> Assertion)
             (nodes : list(DL_Node A))
    Require
      store_dll(storeA, linklist, nodes)
    Ensure
      ((__return == 1 && nodes == nil) ||
       (__return == 0 && nodes != nil)) &&
      store_dll(storeA, linklist, nodes)
 */;
x_err_t LinklistResume(DoubleLinklistType *list)
/*@ semaphore_head_ic
    With (sg : StableGlobalState) (before : VarGlobalState) (sem : Z) (waiting : list Z)
    Require list == semaphore_pending_head(sem) && waiting != nil &&
      semaphore_pending_nodes(sem, before, map(sched_link_node, waiting)) && os_inv(sg, before)
    Ensure __return == 0 && exists after, semaphore_resume_head_effect(sem, before, after) && os_inv(sg, after)
 */;
int32 _SemaphoreAbandon(int32 id)
/*@ semaphore_abandon_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_semaphore_abandon(sg, id), X) && OutsideCritical(sg, before)
    Ensure exists after, safeExec(LastSeen(after), return(__return), X) && OutsideCritical(sg, after)
 */
{
    int lock = 0;
    int resched = 0;
    struct Semaphore *sem = NONE;
    struct IdNode *idnode = NONE;
    if (id < 0 || id > 65535) return -1;
    lock = CriticalAreaLock();
    /*@ Assert exists (held : VarGlobalState) saved,
      id == id@pre && 0 <= id && id <= 65535 && lock == saved &&
      resched == 0 && sem == 0 && idnode == 0 && Crtos_RTrans(before, held) &&
      safeExec(LastSeen(before), abs_semaphore_abandon(sg, id), X) &&
      InsideCritical(sg, held) * os_inv(sg, held) */
    /*@ Given held saved */
    /*@ os_inv(sg, held) which implies
      store_idmanager(sg.os_semaphore_stable.semaphore_manager_stable, semaphore_manager(held.os_semaphores), &k_sem_id_manager) *
      wand(store_idmanager(sg.os_semaphore_stable.semaphore_manager_stable, semaphore_manager(held.os_semaphores), &k_sem_id_manager), os_inv(sg, held)) */
    idnode = IdGetObj(&k_sem_id_manager, id);
    if (idnode == NONE) {
        /*@ Assert id == id@pre && 0 <= id && id <= 65535 && lock == saved &&
          resched == 0 && sem == 0 && idnode == 0 &&
          safeExec(LastSeen(held), return(-1), X) && Crtos_GTrans(held, held) &&
          InsideCritical(sg, held) * os_inv(sg, held) */
        CriticalAreaUnLock(lock); return -1;
    }
    /*@ Assert exists (original : SemaphoreAbs),
      id == id@pre && 0 <= id && id <= 65535 && lock == saved && resched == 0 && sem == 0 &&
      In(original, held.os_semaphores) && original.semaphore_id == id &&
      original.semaphore_addr != 0 && 0 <= original.semaphore_value && original.semaphore_value <= 65535 &&
      idnode == field_addr(original.semaphore_addr, struct Semaphore, id) &&
      Crtos_RTrans(before, held) && safeExec(LastSeen(before), abs_semaphore_abandon(sg, id), X) &&
      InsideCritical(sg, held) * os_inv(sg, held) */
    /*@ Given original */
    sem = CONTAINER_OF_SEMAPHORE_ID(idnode);
    /*@ In(original, held.os_semaphores) && sem == original.semaphore_addr && os_inv(sg, held)
      which implies sem == original.semaphore_addr &&
      semaphore_pending_nodes(sem, held, map(sched_link_node, original.semaphore_pending_addrs)) &&
      store_dll(pure_suspend_sched_link(held.os_tasks.task_desc_map), &sem->pend_list, map(sched_link_node, original.semaphore_pending_addrs)) *
      wand(store_dll(pure_suspend_sched_link(held.os_tasks.task_desc_map), &sem->pend_list, map(sched_link_node, original.semaphore_pending_addrs)), os_inv(sg, held)) */
    if (!IsDoubleLinkListEmpty(&sem->pend_list) /*@ where (dataqueue_ic_dll) {A = Z} */) {
        /*@ sem == original.semaphore_addr &&
          store_dll(pure_suspend_sched_link(held.os_tasks.task_desc_map), &sem->pend_list, map(sched_link_node, original.semaphore_pending_addrs)) *
          wand(store_dll(pure_suspend_sched_link(held.os_tasks.task_desc_map), &sem->pend_list, map(sched_link_node, original.semaphore_pending_addrs)), os_inv(sg, held))
          which implies sem == original.semaphore_addr && os_inv(sg, held) */
        /*@ Assert id == id@pre && 0 <= id && id <= 65535 && lock == saved && resched == 0 &&
          sem == original.semaphore_addr && idnode == field_addr(sem, struct Semaphore, id) &&
          In(original, held.os_semaphores) && original.semaphore_id == id &&
          original.semaphore_pending_addrs != nil &&
          semaphore_pending_nodes(sem, held, map(sched_link_node, original.semaphore_pending_addrs)) &&
          Crtos_RTrans(before, held) && safeExec(LastSeen(before), abs_semaphore_abandon(sg, id), X) &&
          InsideCritical(sg, held) * os_inv(sg, held) */
        resched = 1;
        LinklistResume(&sem->pend_list) /*@ where (semaphore_head_ic) sg = sg, before = held,
          sem = sem, waiting = original.semaphore_pending_addrs */;
    } else {
        /*@ sem == original.semaphore_addr &&
          store_dll(pure_suspend_sched_link(held.os_tasks.task_desc_map), &sem->pend_list, map(sched_link_node, original.semaphore_pending_addrs)) *
          wand(store_dll(pure_suspend_sched_link(held.os_tasks.task_desc_map), &sem->pend_list, map(sched_link_node, original.semaphore_pending_addrs)), os_inv(sg, held))
          which implies sem == original.semaphore_addr && os_inv(sg, held) */
        /*@ In(original, held.os_semaphores) && sem == original.semaphore_addr &&
          map(sched_link_node, original.semaphore_pending_addrs) == nil && os_inv(sg, held)
          which implies sem == original.semaphore_addr && original.semaphore_pending_addrs == nil &&
          ((0 <= original.semaphore_value && original.semaphore_value < 65535 &&
            store_ushort(&sem->value, original.semaphore_value) *
            wand(store_ushort(&sem->value, original.semaphore_value+1),
              os_inv(sg, replace_semaphores(semaphore_set_value(sem, original.semaphore_value+1, held.os_semaphores), held)))) ||
           (original.semaphore_value == 65535 &&
            store_ushort(&sem->value, 65535) * wand(store_ushort(&sem->value, 65535), os_inv(sg, held)))) */
        /*@ store_ushort(&sem->value, original.semaphore_value) which implies sem->value == original.semaphore_value */
        if (sem->value == 65535) {
            /*@ Assert id == id@pre && 0 <= id && id <= 65535 && lock == saved && resched == 0 &&
              sem == original.semaphore_addr && idnode == field_addr(sem, struct Semaphore, id) &&
              safeExec(LastSeen(held), return(-3), X) && Crtos_GTrans(held, held) &&
              InsideCritical(sg, held) * os_inv(sg, held) */
            CriticalAreaUnLock(lock); return -3;
        }
        sem->value++;
    }
    /*@ Assert exists (released : VarGlobalState) (Y : unit -> (VarGlobalState -> Prop) -> Prop),
      id == id@pre && 0 <= id && id <= 65535 && lock == saved &&
      sem == original.semaphore_addr && idnode == field_addr(sem, struct Semaphore, id) &&
      ((resched == 0 && safeExec(LastSeen(released), return(0), X)) ||
       (resched == 1 && safeExec(LastSeen(released), abs_ktask_assign, Y))) &&
      (forall (st : VarGlobalState), safeExec(LastSeen(st), return(tt), Y) =>
        safeExec(LastSeen(st), return(0), X)) &&
      Crtos_GTrans(held, released) && InsideCritical(sg, held) * os_inv(sg, released) */
    /*@ Given released Y */
    CriticalAreaUnLock(lock);
    if (resched) { KTASK_ASSIGN() /*@ where (outside_critical) sg = sg, before = released, X = Y */; }
    return 0;
}
