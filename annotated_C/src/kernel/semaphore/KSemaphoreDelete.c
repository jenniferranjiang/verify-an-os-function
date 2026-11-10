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
