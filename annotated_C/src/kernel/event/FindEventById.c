#include "event_delete_types.h"
#include "event_delete_logic.h"

/* Imported contract boundary; source/revision: checks/source-slices/manifest.json. */
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

/* This named boundary is valid only under the user-approved D1/D2 execution
 * restrictions of this EventDelete experiment. It is NOT derived from ordinary
 * locking and does not assert that the kernel enforces those restrictions.
 * D1 concerns the same allocation throughout the lookup-to-unpublish interval;
 * equal pointer/ID snapshots alone do not establish freedom from ABA. */
x_base CriticalAreaLock(void)
/*@ event_delete_gap
    With (sg : StableGlobalState) (before : VarGlobalState)
         (id p : Z) (empty : bool)
    Require event_delete_guard(id, p, empty, before) &&
            OutsideCritical(sg, before)
    Ensure exists current,
      event_delete_gap(id, p, empty, before, current) &&
      InsideCritical(sg, current) * os_inv(sg, current)
 */;

/* Imported contract boundary; source/revision: checks/source-slices/manifest.json. */
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

/* Imported contract boundary; source/revision: checks/source-slices/manifest.json. */
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

/* TrustBase CONTAINER_OF model; pure address relation, no lifetime ownership. */
struct Event *CONTAINER_OF_EVENT_ID(struct IdNode *id_ptr)
/*@ With (event_ptr : addr)
    Require id_ptr == field_addr(event_ptr, struct Event, id) && emp
    Ensure __return == event_ptr && id_ptr == &(__return->id) && emp
 */;

struct Event *FindEventById(int32 id)
/*@ event_lookup_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require 0 <= id && id < 65536 &&
      safeExec(LastSeen(before), abs_find_event(id), X) &&
      OutsideCritical(sg, before)
    Ensure
      (exists after,
        __return == 0 &&
        safeExec(LastSeen(after), return(0), X) && OutsideCritical(sg, after))
      ||
      (exists after,
        __return != 0 && event_delete_guard(id, __return, false, after) &&
        safeExec(LastSeen(after), return(__return), X) && OutsideCritical(sg, after))
 */
{
    x_base lock = 0;
    struct IdNode *idnode = NONE;
    struct Event *event = NONE;

    if (id < 0)
        return NONE;
    lock = CriticalAreaLock() /*@ where (ordinary) sg = sg */;
    idnode = IdGetObj(&k_event_id_manager, id);
    if (idnode == NONE) {
        CriticalAreaUnLock(lock) /*@ where (stable) sg = sg */;
        return NONE;
    }

    event = CONTAINER_OF_EVENT_ID(idnode);
    CriticalAreaUnLock(lock) /*@ where (stable) sg = sg */;
    
    return event;
}
