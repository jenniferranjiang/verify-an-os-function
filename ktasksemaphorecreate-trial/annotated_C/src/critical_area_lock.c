typedef unsigned short uint16;
typedef long x_base;

/* Shared authority object: static in CriticalArea.c, external in split slices. */
extern uint16 KTaskOsAssignLockNest;

/*@ Import Coq Require Import CRTOS_Verify.lib.SemaphoreInv */
/*@ Import Coq Local Open Scope sac */
/*@ Extern Coq (SemaphoreStable :: *) (SemaphoreState :: *) */
/*@ Extern Coq
      (SemaphoreStableContext : SemaphoreStable -> Prop)
      (SemaphoreAcquireTrans : list Z -> SemaphoreState -> SemaphoreState -> Prop)
      (SemaphoreHandlerDepth : list Z -> Z)
      (SemaphoreCriticalCore : list Z -> SemaphoreState -> Assertion)
      (SemaphoreInsideCritical : list Z -> SemaphoreState -> Assertion)
      (semaphore_inv : SemaphoreStable -> SemaphoreState -> Assertion)
      (semaphore_callable_context :
        SemaphoreStable -> list Z -> SemaphoreState -> Assertion)
      (semaphore_irq_disabled_acquire_post :
        SemaphoreStable -> list Z -> SemaphoreState -> Z -> Assertion)
 */

/* Nested implementation API: canonical declaration-only spec. */
x_base DisableLocalInterrupt(void)
/*@ With (sg : SemaphoreStable) (st : SemaphoreState) (handlers : list Z)
    Require SemaphoreStableContext(sg) &&
      semaphore_callable_context(sg, handlers, st)
    Ensure semaphore_irq_disabled_acquire_post(
      sg, handlers, st, __return)
 */
;

x_base CriticalAreaLock(void)
/*@ With (sg : SemaphoreStable) (st : SemaphoreState) (handlers : list Z)
    Require SemaphoreStableContext(sg) &&
      semaphore_callable_context(sg, handlers, st)
    Ensure exists st_lock,
      SemaphoreAcquireTrans(handlers, st, st_lock) &&
      SemaphoreInsideCritical(cons(__return, handlers), st_lock) *
      semaphore_inv(sg, st_lock)
 */
{
    x_base lock;

    lock = DisableLocalInterrupt()
      /*@ where sg = sg, st = st, handlers = handlers */;

    /*@ semaphore_irq_disabled_acquire_post(sg, handlers, st, lock)
        which implies
        exists st_lock,
          SemaphoreAcquireTrans(handlers, st, st_lock) &&
          (KTaskOsAssignLockNest == SemaphoreHandlerDepth(handlers)) *
          SemaphoreCriticalCore(cons(lock, handlers), st_lock) *
          semaphore_inv(sg, st_lock)
     */

    KTaskOsAssignLockNest ++;

    /*@ exists st_lock,
          SemaphoreAcquireTrans(handlers, st, st_lock) &&
          (KTaskOsAssignLockNest == SemaphoreHandlerDepth(handlers) + 1) *
          SemaphoreCriticalCore(cons(lock, handlers), st_lock) *
          semaphore_inv(sg, st_lock)
        which implies
        exists st_lock,
          SemaphoreAcquireTrans(handlers, st, st_lock) &&
          SemaphoreInsideCritical(cons(lock, handlers), st_lock) *
          semaphore_inv(sg, st_lock)
     */

    return lock;
}
