/* Source: /home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/semaphore.c; SHA-256 dafd02bf7c6fa5a7324c6e0f824d9a1ddc1544c43f9e71aabeb902d832f30ab8.
 * Selected 32-bit non-SMP config: KERNEL_STATIC_OBJECTS and KERNEL_DEFER_IPC_SCHED undefined. */
/* Dataqueue IC design input (not an additional implementation proof).
 * The OC definition is synchronized to the latest source; its contracts and proof annotations are retained.
 * This named IC contract targets a temporary slice adapted from that same body:
 * remove nested CriticalAreaLock/UnLock calls and OC-only proof annotations;
 * select the dataqueue_ic* callee contracts recorded below.
 * Wrapper bodies themselves need no lock removal. The OC body is NOT asserted
 * to satisfy the IC contract without that documented source adaptation.
 * See .docs/Report/dataqueue/2026-11-16-InitDataqueue-DataqueuePeak/design.md for the complete reconstruction choices.
 */
#include "dataqueue.h"
#include "dataqueue_semaphore_logic.h"

/* Current source: kernel/thread/semaphore.c; non-SMP ILP32.
 * New IC contract for dataqueue's existing locked call site. The global
 * OC contract and IC specialization remain separate design interfaces.
 */

int32 _SemaphoreCreate(uint16 val)
/*@ dataqueue_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require os_inv(sg, before)
    Ensure exists after,
      ((__return == -5) || (0 <= __return && __return < 128)) &&
      semaphore_create_ic_effect(sg, val, before, __return, after) &&
      os_inv(sg, after)
*/;


/* IC target contract; original OC target contract remains below. */
int32 KSemaphoreCreate(uint16 val)
/*@ dataqueue_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require os_inv(sg, before)
    Ensure exists after,
      ((__return == -5) || (0 <= __return && __return < 128)) &&
      semaphore_create_ic_effect(sg, val, before, __return, after) &&
      os_inv(sg, after)
*/;

/* OC input: existing contracts/annotations retained; latest-source adaptations marked below. */
#include "m_semaphore.h"
#include "semaphore_create_logic.h"

int32 _SemaphoreCreate(uint16 val)
/*@ With (sg : StableGlobalState) (before : VarGlobalState) X
    Require
      safeExec(LastSeen(before), abs_semaphore_create(sg, val), X) &&
      OutsideCritical(sg, before)
    Ensure
      (exists after,
        __return == -5 &&
        safeExec(LastSeen(after), return(-5), X) &&
        OutsideCritical(sg, after))
      ||
      (exists after,
        0 <= __return && __return < 128 &&
        safeExec(LastSeen(after), return(__return), X) &&
        OutsideCritical(sg, after))
*/;

/* Canonical: KSemaphoreCreate. Source: /home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/semaphore.c:259. */
int32 KSemaphoreCreate(uint16 val)
/*@ With (sg : StableGlobalState) (before : VarGlobalState) X
    Require
      safeExec(LastSeen(before), abs_semaphore_create(sg, val), X) &&
      OutsideCritical(sg, before)
    Ensure
      (exists after,
        __return == -5 &&
        safeExec(LastSeen(after), return(-5), X) &&
        OutsideCritical(sg, after))
      ||
      (exists after,
        0 <= __return && __return < 128 &&
        safeExec(LastSeen(after), return(__return), X) &&
        OutsideCritical(sg, after))
*/
{
    ;
    /* KDEBUG_NOT_IN_INTERRUPT: TrustBase debug removal.
     * KERNEL_OBJECT_LIFECYCLE_CHECK_RET(-ERROR): empty because KERNEL_STATIC_OBJECTS is undefined. */
    return _SemaphoreCreate(val);
}
