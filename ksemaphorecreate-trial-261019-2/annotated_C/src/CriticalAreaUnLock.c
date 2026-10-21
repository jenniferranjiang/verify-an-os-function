/* Fresh extraction: kernel/thread/CriticalArea.c:132; see source-analysis.md. */
#include "../include/types.h"
#include "../include/logic.h"

void EnableLocalInterrupt(x_base lock)
/*@ With (owned : bool) (sg : StableGlobalState)
         (anchor current : VarGlobalState) (n : Z)
    Require (lock == 0 || lock == 1) &&
            (owned == false || lock == 1) && Crtos_GTrans(anchor, current) &&
            InsideCritical(sg, anchor) * critical_projection(sg, current) * critical_nest(n)
    Ensure
      (owned == false && OutsideCriticalIRQ(lock, sg, current)) ||
      (owned == true && InsideCritical(sg, anchor) *
       critical_projection(sg, current) * critical_nest(n))
*/;
extern uint16 KTaskOsAssignLockNest;

void CriticalAreaUnLock(x_base lock)
/*@ With (owned : bool) (sg : StableGlobalState)
         (anchor current : VarGlobalState) (n : Z)
    Require (lock == 0 || lock == 1) &&
            (owned == false || lock == 1) && Crtos_GTrans(anchor, current) &&
            InsideCritical(sg, anchor) * critical_projection(sg, current) * critical_nest(n)
    Ensure
      (owned == false && OutsideCriticalIRQ(lock, sg, current)) ||
      (owned == true && InsideCritical(sg, anchor) *
       critical_projection(sg, current) * critical_nest(critical_nest_dec(n)))
*/
{
    if (KTaskOsAssignLockNest >= 1) {
        KTaskOsAssignLockNest --;
    }

    EnableLocalInterrupt(lock)
        /*@ where owned = owned, sg = sg, anchor = anchor, current = current,
                  n = critical_nest_dec(n) */;
}
