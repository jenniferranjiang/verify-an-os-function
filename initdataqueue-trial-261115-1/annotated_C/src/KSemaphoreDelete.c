/* New IC low-level design, not an OC refinement or reused implementation proof.
 * Global OC source remains unchanged: annotated_C/src/kernel/semaphore/KSemaphoreDelete.c
 * Source SHA256 ef7c27f4fbfa0aab7c3b1039fa488da9e4b82f6d92be6129c462da1b85860c83.
 * C baseline: kernel/thread/semaphore.c; done-table resolved to static functions.
 * No QCP execution or implementation proof has been performed in this trial.
 */
#include "../headers/semaphore.h"

void _SemaphoreDelete(int32 id)
/*@ cleanup_inside_critical
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require semaphore_delete_quiescent(id, before) &&
      semaphore_unreferenced(id, before) && os_inv(sg, before)
    Ensure exists after,
      semaphore_delete_ic_effect(id, before, after) && os_inv(sg, after)
 */;

void KSemaphoreDelete(int32 id)
/*@ cleanup_inside_critical
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require semaphore_delete_quiescent(id, before) &&
      semaphore_unreferenced(id, before) && os_inv(sg, before)
    Ensure exists after,
      semaphore_delete_ic_effect(id, before, after) && os_inv(sg, after)
 */
{
    

    _SemaphoreDelete(id) ;
}
