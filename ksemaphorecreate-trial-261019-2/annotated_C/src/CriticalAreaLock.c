/* Fresh extraction: kernel/thread/CriticalArea.c:117; see source-analysis.md. */
#include "../include/types.h"
#include "../include/logic.h"

x_base DisableLocalInterrupt(void)
/*@ With (owned : bool) (saved : Z) (sg : StableGlobalState)
         (anchor before : VarGlobalState) (n : Z)
    Require
      (owned == false && OutsideCriticalIRQ(saved, sg, before)) ||
      (owned == true && saved == 1 && InsideCritical(sg, anchor) *
       critical_projection(sg, before) * critical_nest(n))
    Ensure exists acquired old_n,
      __return == saved &&
      ((owned == false &&
        ((saved == 0 && Crtos_RTrans(before, acquired)) ||
         (saved == 1 && acquired == before))) ||
       (owned == true && acquired == before && old_n == n)) &&
      InsideCritical(sg, critical_anchor(owned, anchor, acquired)) *
      critical_projection(sg, acquired) * critical_nest(old_n)
*/;
extern uint16 KTaskOsAssignLockNest;

x_base CriticalAreaLock(void)
/*@ With (owned : bool) (saved : Z) (sg : StableGlobalState)
         (anchor before : VarGlobalState) (n : Z)
    Require
      (owned == false && OutsideCriticalIRQ(saved, sg, before)) ||
      (owned == true && saved == 1 && InsideCritical(sg, anchor) *
       critical_projection(sg, before) * critical_nest(n))
    Ensure exists acquired old_n,
      __return == saved &&
      ((owned == false &&
        ((saved == 0 && Crtos_RTrans(before, acquired)) ||
         (saved == 1 && acquired == before))) ||
       (owned == true && acquired == before && old_n == n)) &&
      InsideCritical(sg, critical_anchor(owned, anchor, acquired)) *
      critical_projection(sg, acquired) * critical_nest(critical_nest_inc(old_n))
*/
{
    x_base lock;

    lock = DisableLocalInterrupt()
        /*@ where owned = owned, saved = saved, sg = sg, anchor = anchor,
                  before = before, n = n */;
    /*@ Given acquired old_n */

    KTaskOsAssignLockNest ++;

    return lock;
}
