#include "../include/slice_types.h"
#include "../include/logic.h"

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
/*@ event_delete_live
    With (sg : StableGlobalState) (before : VarGlobalState) (id p : Z)
    Require p != 0 && event_delete_guard(id, p, before) &&
      OutsideCritical(sg, before)
    Ensure exists current,
      event_delete_gap(id, p, before, current) &&
      InsideCritical(sg, current) * os_inv(sg, current)
 */;

x_base CriticalAreaLock(void)
/*@ event_delete_empty
    With (sg : StableGlobalState) (before : VarGlobalState) (id p : Z)
    Require p != 0 && event_delete_guard(id, p, before) &&
      event_pending_at(id, p, nil, before) && OutsideCritical(sg, before)
    Ensure exists current,
      event_delete_empty_gap(id, p, before, current) &&
      InsideCritical(sg, current) * os_inv(sg, current)
 */;
