#include "dataqueue_semaphore_create_logic.h"
/* Active body source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/semaphore.c
 * SHA256 d5b41c3bde69e0416431d2425c61e35453778ae4b1569747f2c2258f3dfe16ec; done-table dispatch resolved from its static initializer. */

/* Source canonical (original OC contract/body, unchanged there):
 * ../../../annotated_C/src/kernel/semaphore/KSemaphoreCreate.c
 * SHA256 327769e9d7769fb1c630d74245e76ff24a3a7057f551cfb47e26468716072ead
 * This file's only active contract is the NEW dataqueue_ic design.
 * OC provenance does not establish this IC contract or C implementation proof.
 * Nested locks are removed only for execution under the caller's critical/IRQ
 * ownership, as authorized by the source-processing rule. */

int32 _SemaphoreCreate(uint16 val)
/*@ dataqueue_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require os_inv(sg, before)
    Ensure exists after,
      (__return == -5 || (0 <= __return && __return < 128)) &&
      dq_semaphore_create_effect(sg, val, before, __return, after) &&
      os_inv(sg, after)
 */;

int32 KSemaphoreCreate(uint16 val)
/*@ dataqueue_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require os_inv(sg, before)
    Ensure exists after,
      (__return == -5 || (0 <= __return && __return < 128)) &&
      dq_semaphore_create_effect(sg, val, before, __return, after) &&
      os_inv(sg, after)
 */
{
    return _SemaphoreCreate(val) /*@ where (dataqueue_ic) sg = sg, before = before */;
}
