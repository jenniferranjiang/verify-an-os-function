#include "../include/slice_types.h"
#include "../include/logic.h"
/*@ Import Coq Require Import CRTOS_Verify.VC.FindEventById_lib */
/*@ Extern Coq
  (EventStable :: *) (EventAbs :: *)
 */
/*@ Extern Coq EventState := list EventAbs */
/*@ Extern Coq
  (os_event_stable : StableGlobalState -> EventStable)
  (os_events : VarGlobalState -> EventState)
  (event_manager_stable : EventStable -> StableIdmanager)
  (event_manager : EventState -> VarIdmanager)
  (find_event_manager_frame : StableGlobalState -> VarGlobalState -> Assertion)
  (event_lookup_result : Z -> addr -> VarGlobalState -> Prop)
 */


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
        __return != 0 && event_delete_guard(id, __return, after) &&
        safeExec(LastSeen(after), return(__return), X) && OutsideCritical(sg, after))
 */
{
    x_base lock = 0;
    struct IdNode *idnode = NONE;
    struct Event *event = NONE;

    if (id < 0)
        return NONE;
    lock = CriticalAreaLock() /*@ where (ordinary) sg = sg, st1 = before */;
    /*@ Given st_lock */
    /*@ os_inv(sg, st_lock)
        which implies
        &k_event_id_manager != 0 &&
        store_idmanager(event_manager_stable(os_event_stable(sg)),
          event_manager(os_events(st_lock)), &k_event_id_manager) *
        find_event_manager_frame(sg, st_lock)
    */
    idnode = IdGetObj(&k_event_id_manager, id)
      /*@ where sm = event_manager_stable(os_event_stable(sg)),
                m = event_manager(os_events(st_lock)) */;
    if (idnode == NONE) {
        /*@ idmanager_query(event_manager(os_events(st_lock)), id) == false &&
            store_idmanager(event_manager_stable(os_event_stable(sg)),
              event_manager(os_events(st_lock)), &k_event_id_manager) *
            find_event_manager_frame(sg, st_lock)
            which implies event_lookup_result(id, 0, st_lock) && os_inv(sg, st_lock)
        */
        /*@ safeExec(LastSeen(before), abs_find_event(id), X) &&
            Crtos_RTrans(before, st_lock) && 0 <= id && id < 65536 &&
            event_lookup_result(id, 0, st_lock) && os_inv(sg, st_lock)
            which implies
            safeExec(LastSeen(st_lock), return(0), X) &&
            0 <= id && id < 65536 && Crtos_GTrans(st_lock, st_lock) && os_inv(sg, st_lock)
        */
        CriticalAreaUnLock(lock) /*@ where (stable) sg = sg, st1 = st_lock, st2 = st_lock */;
        return NONE;
    }

    /*@ idnode != 0 &&
        store_idmanager_found(event_manager_stable(os_event_stable(sg)),
          event_manager(os_events(st_lock)), &k_event_id_manager, idnode, id) *
        find_event_manager_frame(sg, st_lock)
        which implies exists found,
          found != 0 && idnode == field_addr(found, struct Event, id) &&
          event_delete_guard(id, found, st_lock) &&
          event_lookup_result(id, found, st_lock) && os_inv(sg, st_lock)
    */
    /*@ Given found */
    event = CONTAINER_OF_EVENT_ID(idnode) /*@ where event_ptr = found */;
    /*@ safeExec(LastSeen(before), abs_find_event(id), X) &&
        Crtos_RTrans(before, st_lock) && 0 <= id && id < 65536 &&
        event_lookup_result(id, event, st_lock) && os_inv(sg, st_lock)
        which implies
        safeExec(LastSeen(st_lock), return(event), X) &&
        0 <= id && id < 65536 && Crtos_GTrans(st_lock, st_lock) && os_inv(sg, st_lock)
    */
    CriticalAreaUnLock(lock) /*@ where (stable) sg = sg, st1 = st_lock, st2 = st_lock */;
    return event;
}
