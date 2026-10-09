/* Source: kernel/thread/semaphore.c:232-250.
 * Normalization: KDEBUG_NOT_IN_INTERRUPT is redefined empty by this TU.
 * The static done.SemaphoreCreate slot has the unique initializer
 * `_SemaphoreCreate` and no writer, so the unsupported function-pointer dispatch
 * is resolved to the direct call below. The source-static `_SemaphoreCreate` is
 * slice-externalized solely to connect its one-function canonical file; neither
 * normalization changes the body, return value, call ABI, or side effects, and
 * no done-table heap predicate is invented. The complete Semaphore layout from
 * xs_sem.h is retained below only so the ABI fact used by both synchronized
 * contracts is parsed in this standalone slice. */
typedef signed int int32;
typedef unsigned short uint16;
typedef struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
} DoubleLinklistType;
struct IdNode { uint16 id; DoubleLinklistType link; };
struct Semaphore {
    struct IdNode id;
    uint16 value;
    DoubleLinklistType pend_list;
    DoubleLinklistType link;
};

/*@ Import Coq Require Import CRTOS_Verify.sem.CrtosOSProtocol */
/*@ Import Coq Import CrtosOS_C_Rules */
/*@ Import Coq Require Import CRTOS_Verify.lib.CrtosGlobState */
/*@ Import Coq Require Import CRTOS_Verify.sem.SemaphorePure */
/*@ Import Coq Require Import CRTOS_Verify.sem.CrtosOSPure */
/*@ Import Coq Require Import CRTOS_Verify.sem.SemaphoreProtocol */
/*@ Import Coq Require Import CRTOS_Verify.sem.SemaphoreCritical */
/*@ Import Coq From MonadLib.StateRelMonad Require Import StateRelBasic safeexec_lib */
/*@ Import Coq Import Monad MonadNotation */
/*@ Import Coq Local Open Scope monad */

/*@ Extern Coq (SemaphoreStable :: *) (SemaphoreState :: *)
               (CrtosOSStable :: *) (CrtosOSWorld :: *)
               (VarGlobalState :: *) (CrtosSchedulerState :: *)
               (program :: * => * => *) */
/*@ Extern Coq (crtos_semaphore_stable : CrtosOSStable -> SemaphoreStable)
               (crtos_task_state : CrtosOSWorld -> VarGlobalState)
               (crtos_scheduler_state : CrtosOSWorld -> CrtosSchedulerState)
               (crtos_semaphore_state : CrtosOSWorld -> SemaphoreState)
               (Build_CrtosOSWorld :
                 VarGlobalState -> CrtosSchedulerState -> SemaphoreState -> CrtosOSWorld)
               (SemaphoreLastSeen :
                 SemaphoreStable -> SemaphoreState -> (SemaphoreState -> Prop) -> Prop)
               (abs_ksemaphore_create :
                 SemaphoreStable -> Z -> program (SemaphoreState -> Prop) Z)
               (safeExec : {Sigma} {A} ->
                 (Sigma -> Prop) -> program Sigma A ->
                 (A -> Sigma -> Prop) -> Prop)
               (return : {Sigma} {A} -> A -> program Sigma A)
               (semaphore_first_free : SemaphoreStable -> SemaphoreState -> option Z)
               (semaphore_create_state : SemaphoreState -> Z -> Z -> Z -> SemaphoreState)
               (SemaphoreRely :
                 CrtosOSStable -> CrtosOSWorld -> CrtosOSWorld -> Prop)
               (SemaphoreCriticalOutside :
                 CrtosOSStable -> CrtosOSWorld -> Assertion)
 */

int32 _SemaphoreCreate(uint16 val)
/*@ With (stable : CrtosOSStable) (before : CrtosOSWorld) X
    Require
      sizeof(struct Semaphore) == 32 &&
      0 <= val && val <= 65535 &&
      safeExec(SemaphoreLastSeen(crtos_semaphore_stable(stable),
        crtos_semaphore_state(before)),
        abs_ksemaphore_create(crtos_semaphore_stable(stable), val), X) &&
      SemaphoreCriticalOutside(stable, before)
    Ensure
      (exists current after,
        __return == -5 && SemaphoreRely(stable, before, current) &&
        after == current &&
        safeExec(SemaphoreLastSeen(crtos_semaphore_stable(stable),
          crtos_semaphore_state(after)), return(__return), X) &&
        SemaphoreCriticalOutside(stable, after))
      ||
      (exists current after sem id,
        __return == id && 0 <= id && id < 128 && sem != 0 &&
        SemaphoreRely(stable, before, current) &&
        semaphore_first_free(crtos_semaphore_stable(stable),
          crtos_semaphore_state(current)) == Some(id) &&
        after == Build_CrtosOSWorld(
          crtos_task_state(current), crtos_scheduler_state(current),
          semaphore_create_state(crtos_semaphore_state(current), sem, id, val)) &&
        safeExec(SemaphoreLastSeen(crtos_semaphore_stable(stable),
          crtos_semaphore_state(after)), return(__return), X) &&
        SemaphoreCriticalOutside(stable, after))
 */;

int32 KSemaphoreCreate(uint16 val)
/*@ With (stable : CrtosOSStable) (before : CrtosOSWorld) X
    Require
      sizeof(struct Semaphore) == 32 &&
      0 <= val && val <= 65535 &&
      safeExec(SemaphoreLastSeen(crtos_semaphore_stable(stable),
        crtos_semaphore_state(before)),
        abs_ksemaphore_create(crtos_semaphore_stable(stable), val), X) &&
      SemaphoreCriticalOutside(stable, before)
    Ensure
      (exists current after,
        __return == -5 && SemaphoreRely(stable, before, current) &&
        after == current &&
        safeExec(SemaphoreLastSeen(crtos_semaphore_stable(stable),
          crtos_semaphore_state(after)), return(__return), X) &&
        SemaphoreCriticalOutside(stable, after))
      ||
      (exists current after sem id,
        __return == id && 0 <= id && id < 128 && sem != 0 &&
        SemaphoreRely(stable, before, current) &&
        semaphore_first_free(crtos_semaphore_stable(stable),
          crtos_semaphore_state(current)) == Some(id) &&
        after == Build_CrtosOSWorld(
          crtos_task_state(current), crtos_scheduler_state(current),
          semaphore_create_state(crtos_semaphore_state(current), sem, id, val)) &&
        safeExec(SemaphoreLastSeen(crtos_semaphore_stable(stable),
          crtos_semaphore_state(after)), return(__return), X) &&
        SemaphoreCriticalOutside(stable, after))
 */
{
    return _SemaphoreCreate(val)
      /*@ where stable = stable, before = before, X = X */;
}
