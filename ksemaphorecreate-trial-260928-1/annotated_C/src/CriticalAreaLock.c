/* Source: kernel/thread/CriticalArea.c:117-125 under approved !ARCH_SMP.
 * TU-static KTaskOsAssignLockNest is externalized for the one-function slice.
 * The source CriticalAreaLock declaration is not inline (the inline declaration
 * at line 109 belongs to ResetCriticalAreaLock), so no inline normalization occurs.
 * xs_isr.h maps DISABLE_INTERRUPT to DisableLocalInterrupt. */
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
               (SemaphoreRely :
                 CrtosOSStable -> CrtosOSWorld -> CrtosOSWorld -> Prop)
               (crtos_semaphore_os_inv :
                 CrtosOSStable -> CrtosOSWorld -> Assertion)
               (SemaphoreOutsideCritical :
                 CrtosOSStable -> CrtosOSWorld -> Assertion)
               (SemaphoreInsideCritical :
                 Z -> list Z -> CrtosOSStable -> CrtosOSWorld -> Assertion)
               (SemaphoreCriticalOutside :
                 CrtosOSStable -> CrtosOSWorld -> Assertion)
               (SemaphoreCriticalHeld :
                 Z -> list Z -> CrtosOSStable -> CrtosOSWorld -> Assertion)
 */

x_base DisableLocalInterrupt(void)
/*@ irq_enter
    With (stable : CrtosOSStable) (before : CrtosOSWorld)
    Require SemaphoreOutsideCritical(stable, before)
    Ensure exists handler current,
      __return == handler && semaphore_irq_handler_ok(handler) &&
      SemaphoreRely(stable, before, current) &&
      SemaphoreInsideCritical(handler, nil, stable, current) *
      crtos_semaphore_os_inv(stable, current)
 */;

x_base CriticalAreaLock(void)
/*@ ordinary
    With (stable : CrtosOSStable) (before : CrtosOSWorld)
    Require SemaphoreCriticalOutside(stable, before)
    Ensure exists handler current,
      __return == handler && semaphore_irq_handler_ok(handler) &&
      SemaphoreRely(stable, before, current) &&
      SemaphoreCriticalHeld(handler, nil, stable, current) *
      crtos_semaphore_os_inv(stable, current)
 */
{
    x_base lock;
    /*@ SemaphoreCriticalOutside(stable, before)
        which implies
          SemaphoreOutsideCritical(stable, before) *
          store(&KTaskOsAssignLockNest, unsigned short, 0)
     */
    lock = DisableLocalInterrupt()
      /*@ where (irq_enter) stable = stable, before = before */;
    /*@ Given handler current */
    KTaskOsAssignLockNest++;
    return lock;
}
