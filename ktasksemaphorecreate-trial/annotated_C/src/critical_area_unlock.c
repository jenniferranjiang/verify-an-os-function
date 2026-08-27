typedef unsigned short uint16;
typedef long x_base;

/* Shared authority object: static in CriticalArea.c, external in split slices. */
extern uint16 KTaskOsAssignLockNest;

/*@ Import Coq Require Import CRTOS_Verify.lib.SemaphoreInv */
/*@ Import Coq Local Open Scope sac */
/*@ Extern Coq (SemaphoreStable :: *) (SemaphoreState :: *) */
/*@ Extern Coq
      (SemaphoreGTrans : SemaphoreState -> SemaphoreState -> Prop)
      (SemaphoreHandlerDepth : list Z -> Z)
      (SemaphoreCriticalCore : list Z -> SemaphoreState -> Assertion)
      (SemaphoreInsideCritical : list Z -> SemaphoreState -> Assertion)
      (semaphore_inv : SemaphoreStable -> SemaphoreState -> Assertion)
      (semaphore_callable_context :
        SemaphoreStable -> list Z -> SemaphoreState -> Assertion)
      (semaphore_irq_disabled_release_pre :
        SemaphoreStable -> list Z -> SemaphoreState -> SemaphoreState -> Z -> Assertion)
 */

/* Nested implementation API: canonical declaration-only spec. */
void EnableLocalInterrupt(x_base lock)
/*@ With (sg : SemaphoreStable) (before after : SemaphoreState)
         (handlers : list Z)
    Require semaphore_irq_disabled_release_pre(
      sg, handlers, before, after, lock)
    Ensure semaphore_callable_context(sg, handlers, after)
 */
;

void CriticalAreaUnLock(x_base lock)
/*@ With (sg : SemaphoreStable) (before after : SemaphoreState)
         (handlers : list Z)
    Require SemaphoreGTrans(before, after) &&
      SemaphoreInsideCritical(cons(lock, handlers), before) *
      semaphore_inv(sg, after)
    Ensure semaphore_callable_context(sg, handlers, after)
 */
{
    /*@ SemaphoreGTrans(before, after) &&
        SemaphoreInsideCritical(cons(lock, handlers), before) *
        semaphore_inv(sg, after)
        which implies
        SemaphoreGTrans(before, after) &&
        SemaphoreHandlerDepth(cons(lock, handlers)) ==
          SemaphoreHandlerDepth(handlers) + 1 &&
        1 <= SemaphoreHandlerDepth(cons(lock, handlers)) &&
        (KTaskOsAssignLockNest ==
          SemaphoreHandlerDepth(cons(lock, handlers))) *
        SemaphoreCriticalCore(cons(lock, handlers), before) *
        semaphore_inv(sg, after)
     */

    if (KTaskOsAssignLockNest >= 1) {
        KTaskOsAssignLockNest --;
    }

    /*@ SemaphoreGTrans(before, after) &&
        (KTaskOsAssignLockNest == SemaphoreHandlerDepth(handlers)) *
        SemaphoreCriticalCore(cons(lock, handlers), before) *
        semaphore_inv(sg, after)
        which implies
        semaphore_irq_disabled_release_pre(
          sg, handlers, before, after, lock)
     */

    EnableLocalInterrupt(lock)
      /*@ where sg = sg, before = before, after = after,
          handlers = handlers */;
}
