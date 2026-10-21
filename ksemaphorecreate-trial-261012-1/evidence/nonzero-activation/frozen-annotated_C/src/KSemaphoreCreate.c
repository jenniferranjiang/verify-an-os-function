#include "../include/crtos_semaphore_layout.h"
#include "../include/semaphore_logic.h"

/* Candidate contracts: design only; callees are not yet body-verified. */
int32 _SemaphoreCreate(uint16 val)
/*@ With (sg : CrtosOSStable) (hs : list Z) (before : CrtosOSState)
    Require scheduler_lock_nest(os_scheduler(before)) < 65535 &&
      SemaphoreOutsideCritical(sg, hs, before)
    Ensure
      (__return == -5 && SemaphoreOutsideCritical(sg, hs, before)) ||
      (exists current,
        __return == -5 && SemaphoreRely(hs, before, current) &&
        idmanager_full(semaphore_manager_abs(os_sem_stable(sg)),
          semaphore_manager_state(os_sem_stable(sg), os_semaphores(current))) &&
        SemaphoreOutsideCritical(sg, hs, current)) ||
      (exists current p,
        p != 0 && SemaphoreRely(hs, before, current) &&
        idmanager_min_free_id(semaphore_manager_abs(os_sem_stable(sg)),
          semaphore_manager_state(os_sem_stable(sg), os_semaphores(current)), __return) &&
        SemaphoreGuarantee(current, semaphore_os_publish(p, __return, val, current)) &&
        SemaphoreOutsideCritical(sg, hs, semaphore_os_publish(p, __return, val, current)))
*/;

int32 KSemaphoreCreate(uint16 val)
/*@ With (sg : CrtosOSStable) (hs : list Z) (before : CrtosOSState)
    Require scheduler_lock_nest(os_scheduler(before)) < 65535 &&
      SemaphoreOutsideCritical(sg, hs, before)
    Ensure
      (__return == -5 && SemaphoreOutsideCritical(sg, hs, before)) ||
      (exists current,
        __return == -5 && SemaphoreRely(hs, before, current) &&
        idmanager_full(semaphore_manager_abs(os_sem_stable(sg)),
          semaphore_manager_state(os_sem_stable(sg), os_semaphores(current))) &&
        SemaphoreOutsideCritical(sg, hs, current)) ||
      (exists current p,
        p != 0 && SemaphoreRely(hs, before, current) &&
        idmanager_min_free_id(semaphore_manager_abs(os_sem_stable(sg)),
          semaphore_manager_state(os_sem_stable(sg), os_semaphores(current)), __return) &&
        SemaphoreGuarantee(current, semaphore_os_publish(p, __return, val, current)) &&
        SemaphoreOutsideCritical(sg, hs, semaphore_os_publish(p, __return, val, current)))
*/
{

    return _SemaphoreCreate(val) /*@ where sg = sg, hs = hs, before = before */;
}
