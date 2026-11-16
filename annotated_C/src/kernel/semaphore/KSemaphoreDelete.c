/* Dataqueue IC design input (not an additional implementation proof).
 * The original OC definition, contract and proof annotations below are retained.
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
 * New IC contract for dataqueue's existing locked call site. Original global
 * OC contract is unchanged and is not claimed to prove this IC specialization.
 */

void _SemaphoreDelete(int32 id)
/*@ dataqueue_cleanup_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require semaphore_delete_quiescent(id, before) && os_inv(sg, before)
    Ensure exists after,
      semaphore_delete_ic_effect(id, before, after) && os_inv(sg, after)
*/;


/* IC target contract; original OC target contract remains below. */
void KSemaphoreDelete(int32 id)
/*@ dataqueue_cleanup_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require semaphore_delete_quiescent(id, before) && os_inv(sg, before)
    Ensure exists after,
      semaphore_delete_ic_effect(id, before, after) && os_inv(sg, after)
*/;

/* Original OC input, preserved verbatim below. */
#include "m_semaphore.h"
#include "semaphore_delete_logic.h"

/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/semaphore.c. Current 32-bit non-SMP configuration. */
void _SemaphoreDelete(int32 id)
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_semaphore_delete(sg, id), X) &&
            OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */;

void KSemaphoreDelete(int32 id)
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_semaphore_delete(sg, id), X) &&
            OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */
{
    

    _SemaphoreDelete(id) /*@ where (outside_critical) sg = sg, before = before, X = X */;
}
