#include "../include/slice_types.h"
#include "../include/logic.h"

/* Source: kernel/thread/mutex.c:235-257. Original lock boundaries kept.
 * Assumptions A1/A2 are approved for this call chain; see source-review.md.
 * KDEBUG_NOT_IN_INTERRUPT is removed under TrustBase; fixed done dispatch
 * resolves to _MutexDelete. Nonnegative int32 IDs still convert to uint16.
 */
x_base CriticalAreaLock(void)
/*@ ordinary
    With (sg : StableGlobalState) (st1 : VarGlobalState)
    Require OutsideCritical(sg, st1)
    Ensure exists st_lock,
      Crtos_RTrans(st1, st_lock) &&
      InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
 */;

void CriticalAreaUnLock(x_base lock)
/*@ stable
    With (sg : StableGlobalState) (st1 st2 : VarGlobalState)
    Require Crtos_GTrans(st1, st2) &&
      InsideCritical(sg, st1) * os_inv(sg, st2)
    Ensure OutsideCritical(sg, st2)
 */;

struct IdNode *IdGetObj(struct IdManager *manager, uint16 id)
/*@ With (sm: StableIdmanager) (m: VarIdmanager)
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

struct Mutex *CONTAINER_OF_MUTEX_ID(struct IdNode *id_ptr)
/*@ With (mutex_ptr : addr)
    Require id_ptr == field_addr(mutex_ptr, struct Mutex, id) && emp
    Ensure __return == mutex_ptr && id_ptr == &(__return->id) && emp
 */;

void _MutexDelete(struct Mutex *mutex)
/*@ assumed_environment
    With (sg : StableGlobalState) (before : VarGlobalState) (id : Z) X
    Require mutex_delete_live(mutex, id, before) &&
      safeExec(LastSeen(before), abs_mutex_delete_object(mutex, id), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */;

void KMutexDelete(int32 id)
/*@ assumed_environment
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_mutex_delete(id), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */
{
    x_base lock = 0;
    struct Mutex *mutex = NONE;
    struct IdNode *idnode = NONE;

    if (id < 0)
        return;

    lock = CriticalAreaLock() /*@ where (ordinary) sg = sg, st1 = before */;
    idnode = IdGetObj(&k_mutex_id_manager, id)
      /*@ where sm = mutex_manager_stable(os_mutex_stable(sg)) */;
    if (idnode == NONE) {
        CriticalAreaUnLock(lock) /*@ where (stable) sg = sg */;
        return;
    }

    mutex = CONTAINER_OF_MUTEX_ID(idnode);
    CriticalAreaUnLock(lock) /*@ where (stable) sg = sg */;
    _MutexDelete(mutex) /*@ where (assumed_environment) sg = sg */;
}
