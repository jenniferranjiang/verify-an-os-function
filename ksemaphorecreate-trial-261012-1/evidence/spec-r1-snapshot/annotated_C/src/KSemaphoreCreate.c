#include "../include/crtos_semaphore_layout.h"
#include "../include/semaphore_logic.h"

/* Candidate contracts: design only; callees are not yet body-verified. */
int32 _SemaphoreCreate(uint16 val)
/*@ With (sg : CrtosOSStable) (before : CrtosOSState)
    Require SemaphoreOutsideCritical(sg, before)
    Ensure
      (__return == -5 && SemaphoreOutsideCritical(sg, before)) ||
      (exists current,
        __return == -5 && SemaphoreRely(before, current) &&
        idmanager_full(semaphore_manager_abs(os_sem_stable(sg)),
          semaphore_manager_state(os_sem_stable(sg), os_semaphores(current))) &&
        SemaphoreOutsideCritical(sg, current)) ||
      (exists current p,
        p != 0 && SemaphoreRely(before, current) &&
        idmanager_min_free_id(semaphore_manager_abs(os_sem_stable(sg)),
          semaphore_manager_state(os_sem_stable(sg), os_semaphores(current)), __return) &&
        SemaphoreGuarantee(current, semaphore_os_publish(p, __return, val, current)) &&
        SemaphoreOutsideCritical(sg, semaphore_os_publish(p, __return, val, current)))
*/;

int32 KSemaphoreCreate(uint16 val)
/*@ With (sg : CrtosOSStable) (before : CrtosOSState)
    Require SemaphoreOutsideCritical(sg, before)
    Ensure
      (__return == -5 && SemaphoreOutsideCritical(sg, before)) ||
      (exists current,
        __return == -5 && SemaphoreRely(before, current) &&
        idmanager_full(semaphore_manager_abs(os_sem_stable(sg)),
          semaphore_manager_state(os_sem_stable(sg), os_semaphores(current))) &&
        SemaphoreOutsideCritical(sg, current)) ||
      (exists current p,
        p != 0 && SemaphoreRely(before, current) &&
        idmanager_min_free_id(semaphore_manager_abs(os_sem_stable(sg)),
          semaphore_manager_state(os_sem_stable(sg), os_semaphores(current)), __return) &&
        SemaphoreGuarantee(current, semaphore_os_publish(p, __return, val, current)) &&
        SemaphoreOutsideCritical(sg, semaphore_os_publish(p, __return, val, current)))
*/
{

    return _SemaphoreCreate(val) /*@ where sg = sg, before = before */;
}
