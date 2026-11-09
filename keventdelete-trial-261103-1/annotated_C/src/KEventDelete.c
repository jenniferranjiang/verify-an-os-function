#include "../include/slice_types.h"
#include "../include/logic.h"

/*@ Import Coq Require Import CRTOS_Verify.VC.KEventDelete_lib */
/*@ Extern Coq
  (kevent_delete_lookup_cont : Z -> (unit -> (VarGlobalState -> Prop) -> Prop) -> addr -> (VarGlobalState -> Prop) -> Prop)
 */

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
 */;

void _EventDelete(struct Event *event)
/*@ event_delete_at_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require event != 0 && exists id,
      event_delete_guard(id, event, before) &&
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
    /*@ safeExec(LastSeen(before), abs_event_delete(id), X) && OutsideCritical(sg, before)
        which implies safeExec(LastSeen(before), abs_find_event(id),
          kevent_delete_lookup_cont(id, X)) && OutsideCritical(sg, before)
     */
    struct Event *event = FindEventById(id)
      /*@ where (event_lookup_oc) sg = sg, before = before, X = kevent_delete_lookup_cont(id, X) */;
    /*@ Given looked_up from after */
    if (event == NONE)
        return;
    /* done.EventDelete resolves to _EventDelete in the immutable initializer. */
    /*@ event != 0 &&
        safeExec(LastSeen(looked_up), return(event), kevent_delete_lookup_cont(id, X)) &&
        OutsideCritical(sg, looked_up)
        which implies exists internal_id,
          internal_id == id && event_delete_guard(internal_id, event, looked_up) &&
          safeExec(LastSeen(looked_up), abs_event_delete_at(internal_id, event), X) &&
          OutsideCritical(sg, looked_up)
     */
    /*@ Given internal_id */
    _EventDelete(event) /*@ where (event_delete_at_oc) sg = sg, before = looked_up, X = X */;
}
