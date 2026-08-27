typedef unsigned short uint16;
typedef int int32;

#define ENOMEMORY 5

typedef struct {
    int32 (*SemaphoreCreate)(uint16 val);
    void (*SemaphoreDelete)(int32 id);
    int32 (*SemaphoreObtain)(int32 id, int32 wait_time);
    int32 (*SemaphoreAbandon)(int32 id);
    int32 (*SemaphoreSetValue)(int32 id, uint16 val);
} SemaphoreDoneType;

/* Extracted-slice APIs; the authoritative semaphore.c definitions are static. */
int32 _SemaphoreCreate(uint16 val);
void _SemaphoreDelete(int32 id);
int32 _SemaphoreObtain(int32 id, int32 wait_time);
int32 _SemaphoreAbandon(int32 id);
int32 _SemaphoreSetValue(int32 id, uint16 val);

static SemaphoreDoneType done = {
    .SemaphoreCreate = _SemaphoreCreate,
    .SemaphoreDelete = _SemaphoreDelete,
    .SemaphoreObtain = _SemaphoreObtain,
    .SemaphoreAbandon = _SemaphoreAbandon,
    .SemaphoreSetValue = _SemaphoreSetValue
};

/*@ Import Coq Require Import CRTOS_Verify.lib.SemaphoreInv */
/*@ Import Coq Require Import SetsClass.SetsClass. Import SetsNotation */
/*@ Import Coq From MonadLib.StateRelMonad Require Import StateRelBasic safeexec_lib */
/*@ Import Coq Import Monad MonadNotation */
/*@ Import Coq Local Open Scope sets */
/*@ Import Coq Local Open Scope monad */

/*@ Printing Coq Name program := StateRelMonad.M */
/*@ Printing Strategy Name program := StateRelMonad.M */
/*@ Printing Strategy No @ bind */

/*@ Extern Coq
      (SemaphoreStable :: *)
      (SemaphoreState :: *)
      (SemaphoreCreateResult :: *)
      (program :: * => * => *)
 */
/*@ Extern Coq
      (SEM_CREATE_NO_MEMORY : SemaphoreCreateResult)
      (SEM_CREATE_OK : Z -> Z -> Z -> SemaphoreCreateResult)
      (SemaphoreStableContext : SemaphoreStable -> Prop)
      (SemaphoreLastSeen : SemaphoreState -> (SemaphoreState -> Prop) -> Prop)
      (SemaphoreRTrans : SemaphoreState -> SemaphoreState -> Prop)
      (SemaphoreAcquireTrans : list Z -> SemaphoreState -> SemaphoreState -> Prop)
      (semaphore_create_state : SemaphoreState -> Z -> Z -> Z -> SemaphoreState)
      (semaphore_create_effect : SemaphoreStable -> SemaphoreState -> SemaphoreState -> Z -> Z -> Prop)
      (abs_semaphore_create : SemaphoreStable -> Z -> program (SemaphoreState -> Prop) SemaphoreCreateResult)
      (safeExec : {Sigma} {A} -> (Sigma -> Prop) -> program Sigma A -> (A -> Sigma -> Prop) -> Prop)
      (return : {Sigma} {A} -> A -> program Sigma A)
      (semaphore_callable_context :
        SemaphoreStable -> list Z -> SemaphoreState -> Assertion)
      (store_semaphore_done : SemaphoreStable -> Assertion)
      (store_semaphore_done_rest : SemaphoreStable -> Assertion)
 */

int32 KSemaphoreCreate(uint16 val)
/*@ With (sg : SemaphoreStable) (st_bef : SemaphoreState)
         (handlers : list Z) X
    Require 0 <= val && val < 65536 &&
      SemaphoreStableContext(sg) &&
      safeExec(SemaphoreLastSeen(st_bef), abs_semaphore_create(sg, val), X) &&
      store_semaphore_done_rest(sg) *
      (done.SemaphoreCreate |= int (uint16 arg)
        With (callee_sg : SemaphoreStable)
             (callee_st_bef : SemaphoreState)
             (callee_handlers : list Z) callee_X
        Require 0 <= arg && arg < 65536 &&
          SemaphoreStableContext(callee_sg) &&
          safeExec(SemaphoreLastSeen(callee_st_bef),
            abs_semaphore_create(callee_sg, arg), callee_X) &&
          semaphore_callable_context(callee_sg, callee_handlers,
            callee_st_bef)
        Ensure 0 <= arg && arg < 65536 &&
          exists callee_st_lock callee_st_aft,
            SemaphoreAcquireTrans(callee_handlers, callee_st_bef,
              callee_st_lock) &&
            semaphore_create_effect(callee_sg, callee_st_lock,
              callee_st_aft, arg, __return) &&
            ((__return == -ENOMEMORY &&
              safeExec(SemaphoreLastSeen(callee_st_aft),
                return(SEM_CREATE_NO_MEMORY), callee_X)) ||
             (0 <= __return && __return < 128 &&
              exists sem_addr,
                callee_st_aft == semaphore_create_state(
                  callee_st_lock, __return, sem_addr, arg) &&
                safeExec(SemaphoreLastSeen(callee_st_aft),
                  return(SEM_CREATE_OK(__return, sem_addr, arg)), callee_X))) &&
            semaphore_callable_context(callee_sg, callee_handlers,
              callee_st_aft)) *
      semaphore_callable_context(sg, handlers, st_bef)
    Ensure 0 <= val && val < 65536 &&
      store_semaphore_done_rest(sg) *
      (done.SemaphoreCreate |= int (uint16 arg)
        With (callee_sg : SemaphoreStable)
             (callee_st_bef : SemaphoreState)
             (callee_handlers : list Z) callee_X
        Require 0 <= arg && arg < 65536 &&
          SemaphoreStableContext(callee_sg) &&
          safeExec(SemaphoreLastSeen(callee_st_bef),
            abs_semaphore_create(callee_sg, arg), callee_X) &&
          semaphore_callable_context(callee_sg, callee_handlers,
            callee_st_bef)
        Ensure 0 <= arg && arg < 65536 &&
          exists callee_st_lock callee_st_aft,
            SemaphoreAcquireTrans(callee_handlers, callee_st_bef,
              callee_st_lock) &&
            semaphore_create_effect(callee_sg, callee_st_lock,
              callee_st_aft, arg, __return) &&
            ((__return == -ENOMEMORY &&
              safeExec(SemaphoreLastSeen(callee_st_aft),
                return(SEM_CREATE_NO_MEMORY), callee_X)) ||
             (0 <= __return && __return < 128 &&
              exists sem_addr,
                callee_st_aft == semaphore_create_state(
                  callee_st_lock, __return, sem_addr, arg) &&
                safeExec(SemaphoreLastSeen(callee_st_aft),
                  return(SEM_CREATE_OK(__return, sem_addr, arg)), callee_X))) &&
            semaphore_callable_context(callee_sg, callee_handlers,
              callee_st_aft)) *
      (exists st_lock st_aft,
        SemaphoreAcquireTrans(handlers, st_bef, st_lock) &&
        semaphore_create_effect(sg, st_lock, st_aft, val, __return) &&
        (( __return == -ENOMEMORY &&
           safeExec(SemaphoreLastSeen(st_aft), return(SEM_CREATE_NO_MEMORY), X)) ||
         (0 <= __return && __return < 128 &&
          exists sem_addr,
            st_aft == semaphore_create_state(
              st_lock, __return, sem_addr, val) &&
            safeExec(SemaphoreLastSeen(st_aft),
              return(SEM_CREATE_OK(__return, sem_addr, val)), X))) &&
        semaphore_callable_context(sg, handlers, st_aft))
 */
{
    /* KDEBUG_NOT_IN_INTERRUPT is forcibly redefined empty in semaphore.c. */
    return done.SemaphoreCreate(val)
      /*@ where callee_sg = sg, callee_st_bef = st_bef,
          callee_handlers = handlers, callee_X = X */;
}
