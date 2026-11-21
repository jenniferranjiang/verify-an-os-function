#include "m_semaphore.h"
#include "semaphore_runtime_logic.h"
/* done.SemaphoreObtain = _SemaphoreObtain; KDEBUG_NOT_IN_INTERRUPT removed per TrustBase. */
int32 _SemaphoreObtain(int32 id, int32 msec)
/*@ semaphore_obtain_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_semaphore_obtain(sg, id, msec), X) && OutsideCritical(sg, before)
    Ensure exists after, safeExec(LastSeen(after), return(__return), X) && OutsideCritical(sg, after)
 */;
int32 KSemaphoreObtain(int32 id, int32 msec)
/*@ semaphore_obtain_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_semaphore_obtain(sg, id, msec), X) && OutsideCritical(sg, before)
    Ensure exists after, safeExec(LastSeen(after), return(__return), X) && OutsideCritical(sg, after)
 */
{ return _SemaphoreObtain(id, msec); }
