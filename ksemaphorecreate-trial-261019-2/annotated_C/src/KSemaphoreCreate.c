/* Fresh extraction: kernel/thread/semaphore.c:246; see source-analysis.md. */
#include "../include/types.h"
#include "../include/logic.h"

int32 _SemaphoreCreate(uint16 val)
/*@ With (owned : bool) (saved : Z) (sg : StableGlobalState)
         (anchor before : VarGlobalState) (n : Z) X Y
    Require
      (owned == false && saved == 0 &&
       safeExec(LastSeen(before), abs_semaphore_create(sg, val), X) &&
       OutsideCriticalIRQ(0, sg, before)) ||
      (owned == false && saved == 1 &&
       safeExec(ExactSeen(before), abs_semaphore_create_masked(sg, val), Y) &&
       OutsideCriticalIRQ(1, sg, before)) ||
      (owned == true && saved == 1 &&
       safeExec(ExactSeen(before), abs_semaphore_create_masked(sg, val), Y) &&
       InsideCritical(sg, anchor) * critical_projection(sg, before) * critical_nest(n))
    Ensure
      (exists after, owned == false && saved == 0 && __return == -5 &&
       safeExec(LastSeen(after), return(__return), X) && OutsideCriticalIRQ(0, sg, after)) ||
      (exists after, owned == false && saved == 0 && 0 <= __return && __return < 128 &&
       safeExec(LastSeen(after), return(__return), X) && OutsideCriticalIRQ(0, sg, after)) ||
      (exists after, owned == false && saved == 1 && __return == -5 &&
       safeExec(ExactSeen(after), return(__return), Y) && OutsideCriticalIRQ(1, sg, after)) ||
      (exists after, owned == false && saved == 1 && 0 <= __return && __return < 128 &&
       safeExec(ExactSeen(after), return(__return), Y) && OutsideCriticalIRQ(1, sg, after)) ||
      (exists after count_after, owned == true && saved == 1 && __return == -5 &&
       semaphore_create_nest_result(sg, val, before, n, __return, after, count_after) &&
       safeExec(ExactSeen(after), return(__return), Y) &&
       InsideCritical(sg, anchor) * critical_projection(sg, after) * critical_nest(count_after)) ||
      (exists after, owned == true && saved == 1 && 0 <= __return && __return < 128 &&
       semaphore_create_nest_result(sg, val, before, n, __return, after, critical_nest_roundtrip(n)) &&
       safeExec(ExactSeen(after), return(__return), Y) &&
       InsideCritical(sg, anchor) * critical_projection(sg, after) *
       critical_nest(critical_nest_roundtrip(n)))
*/;

int32 KSemaphoreCreate(uint16 val)
/*@ With (owned : bool) (saved : Z) (sg : StableGlobalState)
         (anchor before : VarGlobalState) (n : Z) X Y
    Require
      (owned == false && saved == 0 &&
       safeExec(LastSeen(before), abs_semaphore_create(sg, val), X) &&
       OutsideCriticalIRQ(0, sg, before)) ||
      (owned == false && saved == 1 &&
       safeExec(ExactSeen(before), abs_semaphore_create_masked(sg, val), Y) &&
       OutsideCriticalIRQ(1, sg, before)) ||
      (owned == true && saved == 1 &&
       safeExec(ExactSeen(before), abs_semaphore_create_masked(sg, val), Y) &&
       InsideCritical(sg, anchor) * critical_projection(sg, before) * critical_nest(n))
    Ensure
      (exists after, owned == false && saved == 0 && __return == -5 &&
       safeExec(LastSeen(after), return(__return), X) && OutsideCriticalIRQ(0, sg, after)) ||
      (exists after, owned == false && saved == 0 && 0 <= __return && __return < 128 &&
       safeExec(LastSeen(after), return(__return), X) && OutsideCriticalIRQ(0, sg, after)) ||
      (exists after, owned == false && saved == 1 && __return == -5 &&
       safeExec(ExactSeen(after), return(__return), Y) && OutsideCriticalIRQ(1, sg, after)) ||
      (exists after, owned == false && saved == 1 && 0 <= __return && __return < 128 &&
       safeExec(ExactSeen(after), return(__return), Y) && OutsideCriticalIRQ(1, sg, after)) ||
      (exists after count_after, owned == true && saved == 1 && __return == -5 &&
       semaphore_create_nest_result(sg, val, before, n, __return, after, count_after) &&
       safeExec(ExactSeen(after), return(__return), Y) &&
       InsideCritical(sg, anchor) * critical_projection(sg, after) * critical_nest(count_after)) ||
      (exists after, owned == true && saved == 1 && 0 <= __return && __return < 128 &&
       semaphore_create_nest_result(sg, val, before, n, __return, after, critical_nest_roundtrip(n)) &&
       safeExec(ExactSeen(after), return(__return), Y) &&
       InsideCritical(sg, anchor) * critical_projection(sg, after) *
       critical_nest(critical_nest_roundtrip(n)))
*/
{
    ;

    return _SemaphoreCreate(val)
        /*@ where owned = owned, saved = saved, sg = sg, anchor = anchor,
                  before = before, n = n, X = X, Y = Y */;
}
