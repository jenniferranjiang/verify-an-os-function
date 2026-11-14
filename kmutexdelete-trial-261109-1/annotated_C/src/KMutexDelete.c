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

/* Reused-spec: root annotated_C/src/kernel/id/IdGetObj.c, current source hash
 * recorded in spec-design.md. The uint16 conversion is retained at the call. */
struct IdNode *IdGetObj(struct IdManager *manager, uint16 id)
/*@ With (sm: StableIdmanager) (m: VarIdmanager)
    Require 0 <= id && id < 65536 && store_idmanager(sm, m, manager)
    Ensure (manager == 0 && __return == 0 && store_idmanager(sm, m, manager))
      || (manager != 0 && __return == 0 && idmanager_query(m, id) == false &&
          store_idmanager(sm, m, manager))
      || (manager != 0 && __return != 0 && idmanager_query(m, id) == true &&
          store_idmanager_found(sm, m, manager, __return, id))
 */;
/* TrustBase CONTAINER_OF model, Mutex.id offset 0. */
struct Mutex *CONTAINER_OF_MUTEX_ID(struct IdNode *idnode)
/*@ With (p : addr)
    Require idnode == p && addr_aligned(p, ALIGN_SIZE) && emp
    Ensure __return == p && idnode == &(__return->id) &&
      addr_aligned(__return, ALIGN_SIZE)
 */;
void _MutexDelete(struct Mutex *mutex)
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_mutex_delete(sg, mutex), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) &&
      OutsideCritical(sg, after)
 */;

/* Conditional trial execution scope A1--A3: see spec-design.md. */
void KMutexDelete(int32 id)
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_kmutex_delete(sg, id), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) &&
      OutsideCritical(sg, after)
 */
{
    /* KDEBUG_NOT_IN_INTERRUPT removed under TrustBase. */
    x_base lock = 0;
    struct Mutex *mutex = NONE;
    struct IdNode *idnode = NONE;
    if (id < 0)
        return;
    lock = CriticalAreaLock();
    idnode = IdGetObj(&k_mutex_id_manager, id);
    if (idnode == NONE) {
        CriticalAreaUnLock(lock);
        return;
    }
    mutex = CONTAINER_OF_MUTEX_ID(idnode);
    CriticalAreaUnLock(lock);
    /* done.MutexDelete initializer resolves uniquely to _MutexDelete. */
    _MutexDelete(mutex) /*@ where (outside_critical) sg = sg */;
}

