#include "dataqueue_semaphore_delete_logic.h"
/* Active body source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/semaphore.c
 * SHA256 d5b41c3bde69e0416431d2425c61e35453778ae4b1569747f2c2258f3dfe16ec; done-table dispatch resolved from its static initializer. */

/* Source canonical (original OC contract/body, unchanged there):
 * ../../../annotated_C/src/kernel/semaphore/KSemaphoreDelete.c
 * SHA256 ef7c27f4fbfa0aab7c3b1039fa488da9e4b82f6d92be6129c462da1b85860c83
 * This file's only active contract is the NEW dataqueue_ic design.
 * OC provenance does not establish this IC contract or C implementation proof.
 * Nested locks are removed only for execution under the caller's critical/IRQ
 * ownership, as authorized by the source-processing rule. */

void _SemaphoreDelete(int32 id)
/*@ dataqueue_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require dq_sem_delete_empty(id, before) && os_inv(sg, before)
    Ensure exists after,
      dq_semaphore_delete_effect(id, before, after) && os_inv(sg, after)
 */;

/* This named IC scenario covers dataqueue cleanup of freshly created,
 * empty-pending semaphores. dq_sem_delete_empty is an explicit precondition;
 * it is established by the caller's reviewed cleanup observation guard.
 * The original nonempty-pending and reschedule branches remain in the body,
 * with their imported APIs, but are unreachable under this scenario. */

void KSemaphoreDelete(int32 id)
/*@ dataqueue_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require dq_sem_delete_empty(id, before) && os_inv(sg, before)
    Ensure exists after,
      dq_semaphore_delete_effect(id, before, after) && os_inv(sg, after)
 */
{
    _SemaphoreDelete(id) /*@ where (dataqueue_ic) sg = sg, before = before */;
}
