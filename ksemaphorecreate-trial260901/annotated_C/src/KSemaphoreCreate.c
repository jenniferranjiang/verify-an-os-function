/*
 * Extraction: kernel/thread/semaphore.c:246-251.
 * KDEBUG_NOT_IN_INTERRUPT is empty because semaphore.c:24-28 undefines and
 * redefines it with no replacement list. The unique done.SemaphoreCreate
 * dispatch (semaphore.c:232-238) is normalized to _SemaphoreCreate. The table
 * is TU-static, has no writers, and its exact initializer is fixed by
 * SemaphoreStableContext.
 */

typedef signed int int32;
typedef unsigned short uint16;

/*
 * ABI normalization for the anonymous SemaphoreDoneType in xs_sem.h:42-48.
 * The tag exists only in this one-function slice; field order and function
 * pointer types are identical to the authoritative typedef.
 */
typedef struct SemaphoreDone {
    int32 (*SemaphoreCreate)(uint16 val);
    void  (*SemaphoreDelete)(int32 id);
    int32 (*SemaphoreObtain)(int32 id, int32 wait_time);
    int32 (*SemaphoreAbandon)(int32 id);
    int32 (*SemaphoreSetValue)(int32 id, uint16 val);
} SemaphoreDoneType;

extern SemaphoreDoneType done;

typedef char semaphore_done_size_check[
    sizeof(SemaphoreDoneType) == 20 ? 1 : -1];
typedef char semaphore_done_create_offset_check[
    __builtin_offsetof(SemaphoreDoneType, SemaphoreCreate) == 0 ? 1 : -1];
typedef char semaphore_done_delete_offset_check[
    __builtin_offsetof(SemaphoreDoneType, SemaphoreDelete) == 4 ? 1 : -1];
typedef char semaphore_done_obtain_offset_check[
    __builtin_offsetof(SemaphoreDoneType, SemaphoreObtain) == 8 ? 1 : -1];
typedef char semaphore_done_abandon_offset_check[
    __builtin_offsetof(SemaphoreDoneType, SemaphoreAbandon) == 12 ? 1 : -1];
typedef char semaphore_done_set_value_offset_check[
    __builtin_offsetof(SemaphoreDoneType, SemaphoreSetValue) == 16 ? 1 : -1];

/*@ Extern Coq (program :: * => * => *)
               (SemaphoreStable :: *)
               (SemaphoreState :: *)
               (SemaphoreCreateAtomic : SemaphoreStable -> Z -> program SemaphoreState Z)
               (SemaphoreCreateEffect : SemaphoreStable -> Z -> SemaphoreState -> Z -> SemaphoreState -> Prop)
               (SemaphoreVisible : SemaphoreStable -> list Z -> SemaphoreState -> SemaphoreState -> Prop)
               (SemaphoreStableContext : SemaphoreStable -> Prop)
               (semaphore_critical_enterable : list Z -> SemaphoreStable -> SemaphoreState -> Assertion)
               (store_semaphore_done : SemaphoreStable -> Assertion)
               (safeExec : {Sigma} {A} -> (Sigma -> Prop) -> program Sigma A -> (A -> Sigma -> Prop) -> Prop)
               (return : {Sigma} {A} -> A -> program Sigma A)) */
/*@ Printing Coq Name program := StateRelMonad.M */
/*@ Printing Strategy Name program := StateRelMonad.M */
/*@ Import Coq From MonadLib.StateRelMonad Require Export StateRelMonad */
/*@ Import Coq Export MonadNotation */
/*@ Import Coq Local Open Scope monad */
/*@ Import Coq Require Import CRTOS_Verify.lib.SemaphoreRep */

int32 _SemaphoreCreate(uint16 val)
/*@ With (sg : SemaphoreStable) handlers before
    Require 0 <= val && val <= 65535 &&
            SemaphoreStableContext(sg) &&
            semaphore_critical_enterable(handlers, sg, before)
    Ensure exists observed after,
            SemaphoreVisible(sg, handlers, before, observed) &&
            SemaphoreStableContext(sg) &&
            SemaphoreCreateEffect(sg, val, observed, __return, after) &&
            semaphore_critical_enterable(handlers, sg, after)
*/;

int32 KSemaphoreCreate(uint16 val)
/*@ With (sg : SemaphoreStable) handlers before X
    Require 0 <= val && val <= 65535 &&
            SemaphoreStableContext(sg) &&
            safeExec(SemaphoreVisible(sg, handlers, before),
                     SemaphoreCreateAtomic(sg, val), X) &&
            semaphore_critical_enterable(handlers, sg, before) *
            store_semaphore_done(sg)
    Ensure exists observed after,
            SemaphoreVisible(sg, handlers, before, observed) &&
            SemaphoreStableContext(sg) &&
            SemaphoreCreateEffect(sg, val, observed, __return, after) &&
            safeExec(SemaphoreVisible(sg, handlers, after),
                     return(__return), X) &&
            semaphore_critical_enterable(handlers, sg, after) *
            store_semaphore_done(sg)
*/
{
    int32 (*create)(uint16 val) = done.SemaphoreCreate;

    (void)create;
    return _SemaphoreCreate(val)
      /*@ where sg = sg, handlers = handlers, before = before */;
}
