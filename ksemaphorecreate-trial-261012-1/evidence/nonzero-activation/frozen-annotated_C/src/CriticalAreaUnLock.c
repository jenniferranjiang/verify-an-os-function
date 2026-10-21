#include "../include/crtos_semaphore_layout.h"
#include "../include/semaphore_logic.h"

/* Same source-static object shared by both extracted functions. */
extern uint16 KTaskOsAssignLockNest;

/* Candidate contracts: design only; callees are not yet body-verified. */
void EnableLocalInterrupt(x_base level)
/*@ With (sg : CrtosOSStable) (hs : list Z) (before : CrtosOSState) (after : CrtosOSState)
    Require semaphore_irq_handler_ok(level) && SemaphoreGuarantee(before, after) &&
      SemaphoreInsideCritical(sg, hs, level, before) * SemaphoreOSInvariant(sg, after)
    Ensure SemaphoreOutsideCritical(sg, hs, after)
*/;

void CriticalAreaUnLock(x_base lock)
/*@ With (sg : CrtosOSStable) (hs : list Z) (before : CrtosOSState) (after : CrtosOSState)
    Require semaphore_irq_handler_ok(lock) &&
      SemaphoreGuarantee(before, semaphore_nest_decrement(after)) &&
      SemaphoreInsideCritical(sg, hs, lock, before) * SemaphoreOSInvariant(sg, after)
    Ensure SemaphoreOutsideCritical(sg, hs, semaphore_nest_decrement(after))
*/
{
    /*@ Assert
        lock == lock@pre && semaphore_irq_handler_ok(lock) &&
        SemaphoreGuarantee(before, semaphore_nest_decrement(after)) && CrtosOSValid(after) &&
        SemaphoreInsideCritical(sg, hs, lock, before) *
        data_at(&KTaskOsAssignLockNest, unsigned short, scheduler_lock_nest(os_scheduler(after))) *
        SemaphoreCriticalFrame(sg, after)
    */
    if (KTaskOsAssignLockNest >= 1) {
        KTaskOsAssignLockNest --;
    }

    /*@ Assert
        lock == lock@pre && semaphore_irq_handler_ok(lock) &&
        SemaphoreGuarantee(before, semaphore_nest_decrement(after)) &&
        SemaphoreInsideCritical(sg, hs, lock, before) *
        SemaphoreOSInvariant(sg, semaphore_nest_decrement(after))
    */
    EnableLocalInterrupt(lock);
}
