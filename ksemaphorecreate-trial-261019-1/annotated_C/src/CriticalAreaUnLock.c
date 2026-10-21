#include "../include/types.h"
#include "../include/logic.h"

/* BEGIN CALLER-LOCAL CONTRACTS */
void EnableLocalInterrupt(x_base level)
/*@ With (mode : Z) (sg : StableGlobalState)
         (anchor current : VarGlobalState) (n : Z)
    Require
      (mode == 0 && Crtos_GTrans(anchor, current) &&
       (level == 0 || level == 1) &&
       InsideCritical(sg, anchor) * slice_OS_inv(sg, current, n) * IRQMask(1)) ||
      (mode == 1 && level == 1 &&
       InsideCritical(sg, anchor) * slice_OS_inv(sg, current, n) * IRQMask(1))
    Ensure
      (mode == 0 && OutsideCritical(sg, current) * IRQMask(level)) ||
      (mode == 1 && InsideCritical(sg, anchor) *
       slice_OS_inv(sg, current, n) * IRQMask(1))
*/;
/* END CALLER-LOCAL CONTRACTS */

/* Source kernel/thread/CriticalArea.c:132. */
void CriticalAreaUnLock(x_base lock)
/*@ With (mode : Z) (sg : StableGlobalState)
         (anchor current : VarGlobalState) (n : Z)
    Require
      (mode == 0 && Crtos_GTrans(anchor, current) &&
       (lock == 0 || lock == 1) &&
       InsideCritical(sg, anchor) * slice_OS_inv(sg, current, n) * IRQMask(1)) ||
      (mode == 1 && lock == 1 &&
       InsideCritical(sg, anchor) * slice_OS_inv(sg, current, n) * IRQMask(1))
    Ensure
      (mode == 0 && OutsideCritical(sg, current) * IRQMask(lock)) ||
      (mode == 1 && InsideCritical(sg, anchor) *
       slice_OS_inv(sg, current, nest_dec(n)) * IRQMask(1))
*/
{
    if (KTaskOsAssignLockNest >= 1) {
        KTaskOsAssignLockNest --;
    }

    EnableLocalInterrupt(lock)
        /*@ where mode = mode, sg = sg, anchor = anchor, current = current,
                  n = nest_dec(n) */;
}
