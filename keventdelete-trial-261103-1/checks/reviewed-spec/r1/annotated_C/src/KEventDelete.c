#include "../include/slice_types.h"
#include "../include/logic.h"

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
 */;

void _EventDelete(struct Event *event)
/*@ event_delete_at_oc
    With (sg : StableGlobalState) (before : VarGlobalState) (id : Z) X
    Require event_delete_guard(id, event, false, before) &&
      safeExec(LastSeen(before), abs_event_delete_at(id, event), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */;

void KEventDelete(int32 id)
/*@ event_delete_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require 0 <= id && id < 65536 &&
      safeExec(LastSeen(before), abs_event_delete(id), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */
{
    /* KDEBUG_NOT_IN_INTERRUPT removed under TrustBase. */
    struct Event *event = FindEventById(id) /*@ where (event_lookup_oc) sg = sg */;
    if (event == NONE)
        return;
    /* done.EventDelete resolves to _EventDelete in the immutable initializer. */
    _EventDelete(event) /*@ where (event_delete_at_oc) sg = sg, id = id */;
}
