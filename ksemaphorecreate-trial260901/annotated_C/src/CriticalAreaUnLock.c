/*
 * Extraction: kernel/thread/CriticalArea.c:132-138, active non-SMP branch.
 * KTaskOsAssignLockNest is slice-externalized from the original TU static.
 */

typedef unsigned short uint16;
typedef signed long x_base;

extern uint16 KTaskOsAssignLockNest;

/*@ Extern Coq (SemaphoreStable :: *)
               (SemaphoreState :: *)
               (SemaphoreCritical : list Z -> SemaphoreStable -> SemaphoreState -> Assertion)
               (SemaphoreGuarantee : SemaphoreStable -> SemaphoreState -> SemaphoreState -> Prop)
               (semaphore_inv : SemaphoreStable -> SemaphoreState -> Assertion)
               (semaphore_critical_enterable : list Z -> SemaphoreStable -> SemaphoreState -> Assertion)
               (semaphore_critical_unlock_pending : Z -> list Z -> SemaphoreStable -> SemaphoreState -> SemaphoreState -> Assertion)
               (store_critical_nest : Z -> Assertion)
               (semaphore_handler_depth : list Z -> Z) */
/*@ Import Coq Require Import CRTOS_Verify.lib.SemaphoreRep */

void EnableLocalInterrupt(x_base level)
/*@ With (sg : SemaphoreStable) saved rest protocol_state memory_state
    Require level == saved &&
            semaphore_critical_unlock_pending(saved, rest, sg,
                                              protocol_state, memory_state)
    Ensure semaphore_critical_enterable(rest, sg, memory_state)
*/;

void CriticalAreaUnLock(x_base lock)
/*@ With (sg : SemaphoreStable) rest protocol_state memory_state
    Require SemaphoreGuarantee(sg, protocol_state, memory_state) &&
            SemaphoreCritical(cons(lock, rest), sg, protocol_state) *
            semaphore_inv(sg, memory_state) *
            store_critical_nest(semaphore_handler_depth(cons(lock, rest)))
    Ensure semaphore_critical_enterable(rest, sg, memory_state)
*/
{
    /*@ store_critical_nest(semaphore_handler_depth(cons(lock, rest)))
        which implies
        KTaskOsAssignLockNest ==
          semaphore_handler_depth(cons(lock, rest)) */
    if (KTaskOsAssignLockNest >= 1) {
        KTaskOsAssignLockNest--;
    }

    /*@ semaphore_critical_unlock_pending(lock, rest, sg,
                                         protocol_state, memory_state) */

    EnableLocalInterrupt(lock)
      /*@ where sg = sg, saved = lock, rest = rest,
                   protocol_state = protocol_state,
                   memory_state = memory_state */;
}
