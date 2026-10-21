#include "../include/crtos_semaphore_layout.h"
#include "../include/semaphore_logic.h"

/* Same source-static object shared by both extracted functions. */
extern uint16 KTaskOsAssignLockNest;

/* Candidate contracts: design only; callees are not yet body-verified. */
x_base DisableLocalInterrupt(void)
/*@ With (sg : CrtosOSStable) (hs : list Z) (before : CrtosOSState)
    Require SemaphoreOutsideCritical(sg, hs, before)
    Ensure exists current,
      semaphore_irq_handler_ok(__return) && SemaphoreRely(hs, before, current) &&
      SemaphoreInsideCritical(sg, hs, __return, current) * SemaphoreOSInvariant(sg, current)
*/;

x_base CriticalAreaLock(void)
/*@ With (sg : CrtosOSStable) (hs : list Z) (before : CrtosOSState)
    Require scheduler_lock_nest(os_scheduler(before)) < 65535 &&
      SemaphoreOutsideCritical(sg, hs, before)
    Ensure exists current,
      semaphore_irq_handler_ok(__return) && SemaphoreRely(hs, before, current) &&
      SemaphoreInsideCritical(sg, hs, __return, current) *
      SemaphoreOSInvariant(sg, semaphore_nest_increment(current))
*/
{
    x_base lock;

    lock = DisableLocalInterrupt();
    /*@ Given current */

    /*@ Assert
        semaphore_irq_handler_ok(lock) && SemaphoreRely(hs, before, current) &&
        scheduler_lock_nest(os_scheduler(before)) < 65535 && CrtosOSValid(current) &&
        SemaphoreInsideCritical(sg, hs, lock, current) *
        data_at(&KTaskOsAssignLockNest, unsigned short, scheduler_lock_nest(os_scheduler(current))) *
        SemaphoreCriticalFrame(sg, current)
    */
    KTaskOsAssignLockNest ++;

    return lock;
}
