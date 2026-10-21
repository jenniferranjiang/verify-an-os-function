#include "../include/types.h"
#include "../include/logic.h"

/* BEGIN CALLER-LOCAL CONTRACTS */
x_base DisableLocalInterrupt(void)
/*@ With (mode : Z) (sg : StableGlobalState)
         (anchor before : VarGlobalState) (n irq : Z)
    Require
      (mode == 0 && OutsideCritical(sg, before) * IRQMask(irq)) ||
      (mode == 1 && InsideCritical(sg, anchor) *
       slice_OS_inv(sg, before, n) * IRQMask(1))
    Ensure exists acquired old_n,
      ((mode == 0 && __return == irq && Crtos_RTrans(before, acquired)) ||
       (mode == 1 && __return == 1 && acquired == before && old_n == n)) &&
      InsideCritical(sg, critical_anchor(mode, anchor, acquired)) *
      slice_OS_inv(sg, acquired, old_n) * IRQMask(1)
*/;
/* END CALLER-LOCAL CONTRACTS */

/* Source kernel/thread/CriticalArea.c:117. */
x_base CriticalAreaLock(void)
/*@ With (mode : Z) (sg : StableGlobalState)
         (anchor before : VarGlobalState) (n irq : Z)
    Require
      (mode == 0 && OutsideCritical(sg, before) * IRQMask(irq)) ||
      (mode == 1 && InsideCritical(sg, anchor) *
       slice_OS_inv(sg, before, n) * IRQMask(1))
    Ensure exists acquired old_n,
      ((mode == 0 && __return == irq && Crtos_RTrans(before, acquired)) ||
       (mode == 1 && __return == 1 && acquired == before && old_n == n)) &&
      InsideCritical(sg, critical_anchor(mode, anchor, acquired)) *
      slice_OS_inv(sg, acquired, nest_inc(old_n)) * IRQMask(1)
*/
{
    x_base lock;

    lock = DisableLocalInterrupt()
        /*@ where mode = mode, sg = sg, anchor = anchor, before = before,
                  n = n, irq = irq */;
    /*@ Given acquired old_n */

    KTaskOsAssignLockNest ++;

    return lock;
}
