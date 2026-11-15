/* New IC low-level design, not an OC refinement or reused implementation proof.
 * Global OC source remains unchanged: annotated_C/src/kernel/semaphore/KSemaphoreCreate.c
 * Source SHA256 327769e9d7769fb1c630d74245e76ff24a3a7057f551cfb47e26468716072ead.
 * C baseline: kernel/thread/semaphore.c; done-table resolved to static functions.
 * No QCP execution or implementation proof has been performed in this trial.
 */
#include "../headers/semaphore.h"

int32 _SemaphoreCreate(uint16 val)
/*@ inside_critical
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require os_inv(sg, before)
    Ensure exists after,
      ((__return == -5) || (0 <= __return && __return < 128)) &&
      semaphore_create_ic_effect(sg, val, __return, before, after) &&
      os_inv(sg, after)
 */;

int32 KSemaphoreCreate(uint16 val)
/*@ inside_critical
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require os_inv(sg, before)
    Ensure exists after,
      ((__return == -5) || (0 <= __return && __return < 128)) &&
      semaphore_create_ic_effect(sg, val, __return, before, after) &&
      os_inv(sg, after)
 */
{
    ;
    return _SemaphoreCreate(val);
}
