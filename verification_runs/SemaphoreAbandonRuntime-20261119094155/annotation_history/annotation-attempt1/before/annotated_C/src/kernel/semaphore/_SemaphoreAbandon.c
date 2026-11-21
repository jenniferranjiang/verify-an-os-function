#include "m_semaphore.h"
#include "semaphore_runtime_logic.h"
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
    idnode = IdGetObj(&k_sem_id_manager, id);
    if (idnode == NONE) { CriticalAreaUnLock(lock); return -1; }
    sem = CONTAINER_OF_SEMAPHORE_ID(idnode);
    if (!IsDoubleLinkListEmpty(&sem->pend_list)) {
        resched = 1;
        LinklistResume(&sem->pend_list);
    } else {
        if (sem->value == 65535) { CriticalAreaUnLock(lock); return -3; }
        sem->value++;
    }
    CriticalAreaUnLock(lock);
    if (resched) { KTASK_ASSIGN(); }
    return 0;
}
