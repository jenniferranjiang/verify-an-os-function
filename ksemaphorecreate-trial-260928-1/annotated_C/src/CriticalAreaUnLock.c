/* Source: kernel/thread/CriticalArea.c:132-138 under approved !ARCH_SMP.
 * TU-static counter is externalized; xs_isr.h maps ENABLE_INTERRUPT to the
 * direct trusted call EnableLocalInterrupt. */
typedef long x_base;
typedef unsigned short uint16;
extern uint16 KTaskOsAssignLockNest;

/*@ Import Coq Require Import CRTOS_Verify.sem.CrtosOSProtocol */
/*@ Import Coq Import CrtosOS_C_Rules */
/*@ Import Coq Require Import CRTOS_Verify.sem.CrtosOSPure */
/*@ Import Coq Require Import CRTOS_Verify.sem.SemaphoreProtocol */
/*@ Import Coq Require Import CRTOS_Verify.sem.CrtosOSRep */
/*@ Import Coq Require Import CRTOS_Verify.sem.SemaphoreCritical */

/*@ Extern Coq (CrtosOSStable :: *) (CrtosOSWorld :: *) */
/*@ Extern Coq (semaphore_irq_handler_ok : Z -> Prop)
               (SemaphoreGuarantee :
                 CrtosOSStable -> CrtosOSWorld -> CrtosOSWorld -> Prop)
               (crtos_semaphore_os_inv :
                 CrtosOSStable -> CrtosOSWorld -> Assertion)
               (SemaphoreInsideCritical :
                 Z -> list Z -> CrtosOSStable -> CrtosOSWorld -> Assertion)
               (SemaphoreOutsideCritical :
                 CrtosOSStable -> CrtosOSWorld -> Assertion)
               (SemaphoreCriticalOutside :
                 CrtosOSStable -> CrtosOSWorld -> Assertion)
               (SemaphoreCriticalHeld :
                 Z -> list Z -> CrtosOSStable -> CrtosOSWorld -> Assertion)
 */

void EnableLocalInterrupt(x_base level)
/*@ irq_exit
    With (stable : CrtosOSStable)
         (before after : CrtosOSWorld)
    Require
      semaphore_irq_handler_ok(level) &&
      SemaphoreGuarantee(stable, before, after) &&
      SemaphoreInsideCritical(level, nil, stable, before) *
      crtos_semaphore_os_inv(stable, after)
    Ensure SemaphoreOutsideCritical(stable, after)
 */;

void CriticalAreaUnLock(x_base lock)
/*@ ordinary
    With (stable : CrtosOSStable)
         (before after : CrtosOSWorld)
    Require
      semaphore_irq_handler_ok(lock) &&
      SemaphoreGuarantee(stable, before, after) &&
      SemaphoreCriticalHeld(lock, nil, stable, before) *
      crtos_semaphore_os_inv(stable, after)
    Ensure SemaphoreCriticalOutside(stable, after)
 */
{
    /*@ SemaphoreCriticalHeld(lock, nil, stable, before)
        which implies
          SemaphoreInsideCritical(lock, nil, stable, before) *
          store(&KTaskOsAssignLockNest, unsigned short, 1)
     */
    if (KTaskOsAssignLockNest >= 1) {
        KTaskOsAssignLockNest--;
    }
    EnableLocalInterrupt(lock)
      /*@ where (irq_exit) stable = stable, before = before, after = after */;
}
