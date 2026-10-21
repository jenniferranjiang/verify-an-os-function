#include "../include/crtos_semaphore_layout.h"
#include "../include/semaphore_logic.h"

/* Same source-static object shared by both extracted functions. */
extern uint16 KTaskOsAssignLockNest;

/* Candidate contracts: design only; callees are not yet body-verified. */
x_base DisableLocalInterrupt(void)
/*@ With (sg : CrtosOSStable) (before : CrtosOSState)
    Require SemaphoreOutsideCritical(sg, before)
    Ensure exists current,
      semaphore_irq_handler_ok(__return) && SemaphoreRely(before, current) &&
      SemaphoreInsideCritical(sg, __return, current) * SemaphoreOSInvariant(sg, current)
*/;

x_base CriticalAreaLock(void)
/*@ With (sg : CrtosOSStable) (before : CrtosOSState)
    Require SemaphoreOutsideCritical(sg, before)
    Ensure exists current,
      semaphore_irq_handler_ok(__return) && SemaphoreRely(before, current) &&
      SemaphoreInsideCritical(sg, __return, current) *
      SemaphoreOSInvariant(sg, semaphore_nest_increment(current))
*/
{
    x_base lock;

    lock = DisableLocalInterrupt() /*@ where sg = sg, before = before */;
    /*@ Given current */

    KTaskOsAssignLockNest ++;

    return lock;
}
