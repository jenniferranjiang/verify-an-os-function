/* Source: /home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/semaphore.c; SHA-256 dafd02bf7c6fa5a7324c6e0f824d9a1ddc1544c43f9e71aabeb902d832f30ab8.
 * Selected 32-bit non-SMP config: KERNEL_STATIC_OBJECTS and KERNEL_DEFER_IPC_SCHED undefined. */
/* One canonical body, with selectable calling context.
 * CRTOS_DATAQUEUE_SEMAPHORE_IC defaults to 1 for this dataqueue verification.
 * Define it as 0 to retain the original OC contracts, annotations and locks.
 * IC uses the reviewed dataqueue contract and removes only nested lock/unlock
 * operations under the source-processing rule; all other C paths are shared.
 * Selecting a contract is not an implementation-proof result.
 */
#ifndef CRTOS_DATAQUEUE_SEMAPHORE_IC
#define CRTOS_DATAQUEUE_SEMAPHORE_IC 1
#endif
#if CRTOS_DATAQUEUE_SEMAPHORE_IC
#include "dataqueue.h"
#include "dataqueue_semaphore_logic.h"

/* Current source: kernel/thread/semaphore.c; non-SMP ILP32.
 * New IC contract for dataqueue's existing locked call site. The global
 * OC contract and IC specialization remain separate design interfaces.
 */

void _SemaphoreDelete(int32 id)
/*@ dataqueue_cleanup_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require semaphore_delete_quiescent(id, before) && os_inv(sg, before)
    Ensure exists after,
      semaphore_delete_ic_effect(id, before, after) && os_inv(sg, after)
*/;


#else


/* OC input: existing contracts/annotations retained; latest-source adaptations marked below. */
#include "m_semaphore.h"
#include "semaphore_delete_logic.h"

/* Source: /home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/semaphore.c. Current 32-bit non-SMP configuration. */
void _SemaphoreDelete(int32 id)
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_semaphore_delete(sg, id), X) &&
            OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */;

#endif

void KSemaphoreDelete(int32 id)
#if CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ dataqueue_cleanup_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require semaphore_delete_quiescent(id, before) && os_inv(sg, before)
    Ensure exists after,
      semaphore_delete_ic_effect(id, before, after) && os_inv(sg, after)
*/
#else
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_semaphore_delete(sg, id), X) &&
            OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */
#endif
{
    

    /* KDEBUG_NOT_IN_INTERRUPT: TrustBase debug removal.
     * KERNEL_OBJECT_LIFECYCLE_CHECK_VOID(): empty because KERNEL_STATIC_OBJECTS is undefined. */
    _SemaphoreDelete(id) 
#if CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ where (dataqueue_cleanup_ic) */
#else
/*@ where (outside_critical) sg = sg, before = before, X = X */
#endif
;
}
