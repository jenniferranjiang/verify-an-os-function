#include "m_semaphore.h"
#include "semaphore_runtime_logic.h"
/* done.SemaphoreAbandon = _SemaphoreAbandon in source static initializer. */
int32 _SemaphoreAbandon(int32 id)
/*@ semaphore_abandon_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_semaphore_abandon(sg, id), X) && OutsideCritical(sg, before)
    Ensure exists after, safeExec(LastSeen(after), return(__return), X) && OutsideCritical(sg, after)
 */;
int32 KSemaphoreAbandon(int32 id)
/*@ semaphore_abandon_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_semaphore_abandon(sg, id), X) && OutsideCritical(sg, before)
    Ensure exists after, safeExec(LastSeen(after), return(__return), X) && OutsideCritical(sg, after)
 */
{ return _SemaphoreAbandon(id); }
