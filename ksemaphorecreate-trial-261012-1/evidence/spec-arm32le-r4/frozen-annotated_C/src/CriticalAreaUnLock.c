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
    if (KTaskOsAssignLockNest >= 1) {
        KTaskOsAssignLockNest --;
    }

    EnableLocalInterrupt(lock) /*@ where sg = sg, hs = hs, before = before, after = semaphore_nest_decrement(after) */;
}
