/*
 * Extraction: kernel/thread/CriticalArea.c:117-127, active non-SMP branch.
 * KTaskOsAssignLockNest is slice-externalized from the original TU static.
 */

typedef unsigned short uint16;
typedef signed long x_base;

extern uint16 KTaskOsAssignLockNest;

/*@ Extern Coq (SemaphoreStable :: *)
               (SemaphoreState :: *)
               (SemaphoreCritical : list Z -> SemaphoreStable -> SemaphoreState -> Assertion)
               (SemaphoreVisible : SemaphoreStable -> list Z -> SemaphoreState -> SemaphoreState -> Prop)
               (semaphore_critical_enterable : list Z -> SemaphoreStable -> SemaphoreState -> Assertion)
               (semaphore_critical_interface : list Z -> SemaphoreStable -> SemaphoreState -> Assertion)
               (semaphore_critical_lock_pending : Z -> list Z -> SemaphoreStable -> SemaphoreState -> Assertion)
               (semaphore_critical_owned_memory : list Z -> SemaphoreStable -> SemaphoreState -> Assertion)
               (store_critical_nest : Z -> Assertion)
               (semaphore_handler_depth : list Z -> Z) */
/*@ Import Coq Require Import CRTOS_Verify.lib.SemaphoreRep */

x_base DisableLocalInterrupt(void)
/*@ With (sg : SemaphoreStable) handlers before
    Require semaphore_critical_enterable(handlers, sg, before)
    Ensure exists current saved,
            __return == saved &&
            SemaphoreVisible(sg, handlers, before, current) &&
            semaphore_critical_lock_pending(saved, handlers, sg, current)
*/;

x_base CriticalAreaLock(void)
/*@ With (sg : SemaphoreStable) handlers before
    Require semaphore_critical_enterable(handlers, sg, before)
    Ensure exists current saved,
            __return == saved &&
            SemaphoreVisible(sg, handlers, before, current) &&
            semaphore_critical_interface(cons(saved, handlers), sg, current)
*/
{
    x_base lock;

    lock = DisableLocalInterrupt()
      /*@ where sg = sg, handlers = handlers, before = before */;

    /*@ semaphore_critical_lock_pending(lock, handlers, sg, current)
        which implies
        SemaphoreCritical(cons(lock, handlers), sg, current) *
        semaphore_critical_owned_memory(cons(lock, handlers), sg, current) *
        store_critical_nest(semaphore_handler_depth(handlers)) &&
        KTaskOsAssignLockNest == semaphore_handler_depth(handlers) */
    KTaskOsAssignLockNest++;

    return lock;
}
