# 0 "/home/xinra/crtos-verify/annotated_C/src/kernel/dataqueue/PopDataqueue.c"
# 0 "<built-in>"
#define __STDC__ 1
# 0 "<built-in>"
#define __STDC_VERSION__ 201710L
# 0 "<built-in>"
#define __STDC_UTF_16__ 1
# 0 "<built-in>"
#define __STDC_UTF_32__ 1
# 0 "<built-in>"
#define __STDC_HOSTED__ 0
# 0 "<command-line>"
# 1 "/home/xinra/crtos-verify/annotated_C/src/kernel/dataqueue/PopDataqueue.c"
/* Source: crtoslatest/kernel/thread/data_queue.c (actual repository path and
 * SHA-256 are recorded in source-analysis.md). DQ-02/03 approved repair:
 * every timeout is forwarded once and an Obtain error returns -ERROR.
 * Shared ID reads are protected using the source-processing rule.
 * This is a repaired verification copy, not an equivalence claim for original C. */
#define CRTOS_DATAQUEUE_WITH_OPERATIONS 1
# 1 "annotated_C/src/headers/dataqueue.h" 1

#define CRTOS_DATAQUEUE_H 
/* Source ABI: /home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_dataqueue.h; current ILP32 non-SMP configuration.
 * Source SHA-256: fb10a4ae331e8646d0cf26c3302c63d0b199e3bb6562d351a9130aa705454df8.
 * Shared scalar, ID and semaphore layouts are imported without copying.
 * Latest NULL_PARAM_CHECK is log/count-only and supplies no non-null fact. */
# 1 "annotated_C/src/headers/m_semaphore.h" 1

#define CRTOS_M_SEMAPHORE_H 

/*
 * Shared Semaphore ABI for the current 32-bit, non-SMP verification model.
 * Function contracts and scenario-specific Rocq vocabulary remain in the
 * annotated C files or logic adapters; this header is stable across APIs.
 */
typedef signed int int32;
typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;
typedef signed long x_base;
typedef unsigned long x_ubase;
typedef x_base x_err_t;
typedef unsigned int x_ticks_t;
typedef x_ubase x_size_t;
typedef unsigned int size_t;
typedef unsigned char BOOL;

#define NONE ((void *)0)
#define EOK 0
#define ERROR 1
#define ENOMEMORY 5
#define RET_TRUE 1
#define UINT_MAX 4294967295U
#define ALIGN_SIZE 4
#define ID_NUM_MAX 128
#define ID_HTABLE_SIZE 16
#define KTASK_READY 1
#define KTASK_SUSPEND 2
#define KTASK_STAT_MASK 7
#define KTASK_MAX_ADVANCE_PROCESS_TIME 1
#define TASK_DELAY_INACTIVE 0
#define TASK_DELAY_ACTIVE 1
#define KERNEL_SEMAPHORE 

struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
};
typedef struct SysDoubleLinklistNode DoubleLinklistType;

struct IdNode {
    uint16 id;
    DoubleLinklistType link;
};

struct IdManager {
    uint16 id_max;
    uint16 hoffset;
    uint8 *id_map;
    DoubleLinklistType *htable;
};

struct Semaphore {
    struct IdNode id;
    uint16 value;
    DoubleLinklistType pend_list;
    DoubleLinklistType link;
};

struct TaskDescriptor;
struct Delay {
    struct TaskDescriptor *task;
    x_ticks_t ticks;
    uint8 status;
    DoubleLinklistType link;
};
typedef struct Delay *DelayType;

struct TaskBaseInfo {
    char name[32];
    void *func_entry;
    void *func_param;
    uint8 origin_prio;
    uint32 stack_depth;
    void *stack_start;
};
typedef struct TaskBaseInfo TaskBaseInfoType;

struct TaskDyncSchedMember {
    uint8 stat;
    uint8 advance_cnt;
    uint8 cur_prio;
    x_ubase origin_timeslice;
    x_ubase rest_timeslice;
    DoubleLinklistType sched_link;
    uint32 bitmap_column;
    DelayType delay;
};
typedef struct TaskDyncSchedMember TaskDyncSchedMembeType;

struct KTaskDone;
struct TaskDescriptor {
    void *stack_point;
    TaskDyncSchedMembeType task_dync_sched_member;
    TaskBaseInfoType task_base_info;
    uint32 event_id_trigger;
    uint32 event_mode;
    x_err_t exstatus;
    DoubleLinklistType link;
    struct IdNode id;
    struct KTaskDone *Done;
};
typedef struct TaskDescriptor *KTaskDescriptorType;

struct OsAssignReadyVector {
    DoubleLinklistType priority_ready_vector[32];
    uint32 priority_ready_group;
    x_ubase highest_prio;
};

struct PriorityReadyVectorDone;
struct Assign {
    struct OsAssignReadyVector os_assign_ready_vector;
    struct TaskDescriptor *os_running_task;
    struct PriorityReadyVectorDone *ready_vector_done;
    uint8 current_priority;
};

extern uint16 KTaskOsAssignLockNest;
extern struct IdManager k_sem_id_manager;
extern struct IdManager k_task_id_manager;
extern DoubleLinklistType k_sem_list;
extern DoubleLinklistType xiaoshan_delay_head;
extern struct Assign Assign;
# 8 "annotated_C/src/headers/dataqueue.h" 2

typedef struct DataElem {
    const void *data;
    x_size_t length;
} DataElemType;
typedef struct DataQueue {
    uint16 front;
    uint16 rear;
    uint16 max_len;
    DataElemType *base;
    int sem_blank;
    int sem_data;
} DataQueueType;
/*@ Import Coq Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak */
/*@ Import Coq From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib */
/*@ Import Coq Import Monad MonadNotation */
/*@ Import Coq Local Open Scope monad */
/*@ Extern Coq
  (program :: * => * => *) (unit :: *)
*/
/*@ Extern Coq
  (tt : unit)
  (safeExec : {Sigma} {A} -> (Sigma -> Prop) -> program Sigma A -> (A -> Sigma -> Prop) -> Prop)
  (return : {Sigma} {A} -> A -> program Sigma A)
  (addr_aligned : Z -> Z -> Prop)
  (CharArray::undef_full : Z -> Z -> Assertion)
  (CharArray::full : Z -> Z -> list Z -> Assertion)
  (repeat_Z : {A} -> A -> Z -> list A)
*/
/*@ Printing Coq Name program := MonadErr.M */
/*@ Printing Strategy Name program := MonadErr.M */
/*@ Printing Coq Name safeExec := monadesafe_lib.safeExec */
/*@ Printing Coq Name return := MonadErr.ret */

#define CRTOS_DATAQUEUE_COQ_OPTION 
/*@ Extern Coq
  (option :: * => *)
*/
/*@ Extern Coq
  (Some : {A} -> A -> option A) (None : {A} -> option A)
*/

/*@ Extern Coq
  (StableGlobalState :: *) (VarGlobalState :: *)
  (DataQueueAbs :: *) (DataqueueState :: *) (DataqueueSemRefs :: *)
*/
/*@ Extern Coq
  (InsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
  (OutsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
  (os_inv : StableGlobalState -> VarGlobalState -> Assertion)
  (Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop)
  (Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop)
  (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
  (DataqueueStorage : Z -> Assertion)
  (store_dataqueue : Z -> DataQueueAbs -> Assertion)
  (dataqueue_retired : DataQueueAbs -> DataQueueAbs)
  (dq_base : DataQueueAbs -> Z)
  (dq_max_len : DataQueueAbs -> Z) (dq_front : DataQueueAbs -> Z)
  (dq_rear : DataQueueAbs -> Z) (dq_sem_blank : DataQueueAbs -> Z)
  (dq_sem_data : DataQueueAbs -> Z)
  (os_dataqueues : VarGlobalState -> DataqueueState)
  (dataqueue_map : DataqueueState -> Z -> option DataQueueAbs)
  (In : {A} -> A -> list A -> Prop)
  (abs_init_dataqueue : StableGlobalState -> Z -> Z -> program (VarGlobalState -> Prop) Z)
  (abs_deinit_dataqueue : StableGlobalState -> Z -> DataQueueAbs -> DataqueueSemRefs -> program (VarGlobalState -> Prop) unit)
  (semaphore_create_ic_effect : StableGlobalState -> Z -> VarGlobalState -> Z -> VarGlobalState -> Prop)
  (semaphore_delete_quiescent : Z -> VarGlobalState -> Prop)
  (semaphore_delete_ic_effect : Z -> VarGlobalState -> VarGlobalState -> Prop)
*/
/*@ Printing Coq Name StableGlobalState := CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState */
/*@ Printing Coq Name VarGlobalState := CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState */
/*@ Printing Coq Name os_dataqueues := CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues */
/*@ Printing Coq Name InsideCritical := CRTOS_Verify.lib.common.CrtosRules.InsideCritical */
/*@ Printing Coq Name OutsideCritical := CRTOS_Verify.lib.common.CrtosRules.OutsideCritical */
/*@ Printing Coq Name Crtos_RTrans := CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans */
/*@ Printing Coq Name Crtos_GTrans := CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans */
/*@ Printing Coq Name LastSeen := CRTOS_Verify.lib.common.CrtosRules.LastSeen */
/*@ Printing Coq Name os_inv := CRTOS_Verify.lib.common.CrtosInv.os_inv */
/*@ Printing Coq Name DataqueueState := CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueState */
/*@ Printing Coq Name dataqueue_map := CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map */
/*@ Printing Coq Name DataQueueAbs := CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs */
/*@ Printing Coq Name dataqueue_retired := CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired */
/*@ Printing Coq Name dq_base := CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base */
/*@ Printing Coq Name dq_max_len := CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len */
/*@ Printing Coq Name dq_front := CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front */
/*@ Printing Coq Name dq_rear := CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear */
/*@ Printing Coq Name dq_sem_blank := CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank */
/*@ Printing Coq Name dq_sem_data := CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data */
/*@ Printing Coq Name DataqueueStorage := CRTOS_Verify.lib.common.DataqueueInv.DataqueueStorage */
/*@ Printing Coq Name store_dataqueue := CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue */
/*@ Printing Coq Name DataqueueSemRefs := CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs */
/*@ Printing Coq Name abs_deinit_dataqueue := CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue */
/*@ Printing Coq Name abs_init_dataqueue := CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue */
/*@ Printing Coq Name semaphore_create_ic_effect := CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect */
/*@ Printing Coq Name semaphore_delete_quiescent := CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent */
/*@ Printing Coq Name semaphore_delete_ic_effect := CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect */
/*@ Extern Coq
  (DataqueueElem :: *)
*/
/*@ Extern Coq
  (dq_data : DataqueueElem -> Z) (dq_length : DataqueueElem -> Z)
  (peak_data_slot : Z -> option Z -> Assertion)
  (peak_length_slot : Z -> option Z -> Assertion)
  (abs_dataqueue_peak : StableGlobalState -> Z -> program (VarGlobalState -> Prop) (option DataqueueElem))
*/
/*@ Printing Coq Name DataqueueElem := CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem */
/*@ Printing Coq Name dq_data := CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data */
/*@ Printing Coq Name dq_length := CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length */
/*@ Printing Coq Name peak_data_slot := CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot */
/*@ Printing Coq Name peak_length_slot := CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot */
/*@ Printing Coq Name abs_dataqueue_peak := CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak */

/* Pop/Push semantic components; contracts remain caller-local in C files. */
/*@ Import Coq Require Import CRTOS_Verify.lib.dataqueue.KPopDataqueue CRTOS_Verify.lib.dataqueue.KPushDataqueue */
/*@ Extern Coq (DataqueuePopResult :: *) */
/*@ Extern Coq
  (DqPopFailed : DataqueuePopResult) (DqPopEmpty : DataqueuePopResult)
  (DqPopItem : DataqueueElem -> DataqueuePopResult)
  (abs_pop_dataqueue : StableGlobalState -> Z -> Z -> program (VarGlobalState -> Prop) DataqueuePopResult)
  (abs_push_dataqueue : StableGlobalState -> Z -> Z -> Z -> Z -> program (VarGlobalState -> Prop) Z)
*/
# 8 "/home/xinra/crtos-verify/annotated_C/src/kernel/dataqueue/PopDataqueue.c" 2
/* KPopDataqueue imports both runtime semantic modules.  Keep the caller's
 * vocabulary local: the broad runtime header also redeclares C macro names. */
/*@ Extern Coq
 (abs_semaphore_obtain : StableGlobalState -> Z -> Z -> program (VarGlobalState -> Prop) Z)
 (abs_semaphore_abandon : StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
 (wand : Assertion -> Assertion -> Assertion)
 (dataqueue_buffer : DataQueueAbs -> Assertion)
 (dataqueue_ready : DataQueueAbs -> Prop)
 (dataqueue_peak : DataQueueAbs -> option DataqueueElem)
 (dataqueue_slot : Z -> Z -> option DataqueueElem -> Assertion)
 (dataqueue_pop : DataQueueAbs -> DataQueueAbs)
 (dataqueue_publish : Z -> DataQueueAbs -> DataqueueState -> DataqueueState)
 (replace_dataqueues : DataqueueState -> VarGlobalState -> VarGlobalState)
 (dataqueue_pop_after_obtain : StableGlobalState -> Z -> Z -> program (VarGlobalState -> Prop) DataqueuePopResult)
*/

x_base CriticalAreaLock(void)
/*@ With (sg : StableGlobalState) (before : VarGlobalState)
    Require OutsideCritical(sg, before)
    Ensure exists observed,
      Crtos_RTrans(before, observed) &&
      InsideCritical(sg, observed) * os_inv(sg, observed)
*/;
void CriticalAreaUnLock(x_base lock)
/*@ With (sg : StableGlobalState) (held after : VarGlobalState)
    Require Crtos_GTrans(held, after) &&
      InsideCritical(sg, held) * os_inv(sg, after)
    Ensure OutsideCritical(sg, after)
*/;


/* Caller-local copies of the canonical runtime OC contracts; definition and
 * revision are frozen together with the new semaphore canonical files. */
int32 KSemaphoreObtain(int32 id, int32 msec)
/*@ semaphore_obtain_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_semaphore_obtain(sg, id, msec), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(__return), X) && OutsideCritical(sg, after)
*/;
int32 KSemaphoreAbandon(int32 id)
/*@ semaphore_abandon_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_semaphore_abandon(sg, id), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(__return), X) && OutsideCritical(sg, after)
*/;

x_err_t PopDataqueue(DataQueueType *p_queue, const void **StartAddr, x_size_t *size, int32 timeout)
/*@ With (sg : StableGlobalState) (before : VarGlobalState)
         (old_data old_length : option Z) X
    Require safeExec(LastSeen(before), abs_pop_dataqueue(sg, p_queue, timeout), X) &&
      OutsideCritical(sg, before) *
      peak_data_slot(StartAddr, old_data) * peak_length_slot(size, old_length)
    Ensure
      (exists after,
        __return == -1 && safeExec(LastSeen(after), return(DqPopFailed), X) &&
        OutsideCritical(sg, after) *
        peak_data_slot(StartAddr, old_data) * peak_length_slot(size, old_length))
      ||
      (exists after,
        __return == 0 && safeExec(LastSeen(after), return(DqPopEmpty), X) &&
        OutsideCritical(sg, after) *
        peak_data_slot(StartAddr, old_data) * peak_length_slot(size, old_length))
      ||
      (exists after (e : DataqueueElem),
        __return == 0 && safeExec(LastSeen(after), return(DqPopItem(e)), X) &&
        OutsideCritical(sg, after) *
        peak_data_slot(StartAddr, Some(dq_data(e))) *
        peak_length_slot(size, Some(dq_length(e))))
*/
{
    x_base lock = 0;
    int32 obtain_id;
    int32 abandon_id;
    /* NULL_PARAM_CHECK(p_queue); KPrintf("PopDataqueue\n");
     * log/count-only diagnostics omitted. */
    /* Original DQ-02/03 block (replaced by approved repair):
     * do {
     *   if (WAITING_FOREVER == timeout) {
     *     KSemaphoreObtain(p_queue->sem_data, WAITING_FOREVER); break;
     *   } else if (0 == timeout) {
     *     if (EOK == KSemaphoreObtain(p_queue->sem_data, 0)) break;
     *     else return -ERROR;
     *   }
     * } while (0);
     */
    lock = CriticalAreaLock();
    /*@ Assert exists (seen_id : VarGlobalState) (q_id : DataQueueAbs) saved_id,
      p_queue == p_queue@pre && StartAddr == StartAddr@pre && size == size@pre &&
      timeout == timeout@pre && lock == saved_id &&
      Crtos_RTrans(before, seen_id) &&
      safeExec(LastSeen(before), abs_pop_dataqueue(sg, p_queue, timeout), X) &&
      dataqueue_map(os_dataqueues(seen_id), p_queue) == Some(q_id) &&
      dataqueue_ready(q_id) &&
      InsideCritical(sg, seen_id) * store_dataqueue(p_queue, q_id) *
      wand(store_dataqueue(p_queue, q_id), os_inv(sg, seen_id)) *
      peak_data_slot(StartAddr, old_data) * peak_length_slot(size, old_length) *
      undef_data_at(&obtain_id) * undef_data_at(&abandon_id) */
    /*@ Given seen_id q_id saved_id */
    /*@ store_dataqueue(p_queue, q_id)
        which implies p_queue != 0 && addr_aligned(p_queue, 4) &&
          p_queue->front == dq_front(q_id) && p_queue->rear == dq_rear(q_id) &&
          p_queue->max_len == dq_max_len(q_id) && p_queue->base == dq_base(q_id) &&
          p_queue->sem_blank == dq_sem_blank(q_id) && p_queue->sem_data == dq_sem_data(q_id) &&
          CharArray::undef_full((char *)p_queue + 6, 2) * dataqueue_buffer(q_id) */
    obtain_id = p_queue->sem_data;
    /*@ Assert exists (Y : Z -> (VarGlobalState -> Prop) -> Prop),
      p_queue == p_queue@pre && StartAddr == StartAddr@pre && size == size@pre &&
      timeout == timeout@pre && lock == saved_id && obtain_id == dq_sem_data(q_id) &&
      safeExec(LastSeen(seen_id), abs_semaphore_obtain(sg, obtain_id, timeout), Y) &&
      (forall (st : VarGlobalState) (status : Z),
        safeExec(LastSeen(st), return(status), Y) =>
        safeExec(LastSeen(st), dataqueue_pop_after_obtain(sg, p_queue, status), X)) &&
      Crtos_GTrans(seen_id, seen_id) &&
      InsideCritical(sg, seen_id) * os_inv(sg, seen_id) *
      peak_data_slot(StartAddr, old_data) * peak_length_slot(size, old_length) *
      undef_data_at(&abandon_id) */
    /*@ Given Y */
    CriticalAreaUnLock(lock);
    if (0 != KSemaphoreObtain(obtain_id, timeout)) {
        return -1;
    }
    /*@ Assert exists (after_get : VarGlobalState),
      p_queue == p_queue@pre && StartAddr == StartAddr@pre && size == size@pre &&
      timeout == timeout@pre && lock == saved_id && obtain_id == dq_sem_data(q_id) &&
      safeExec(LastSeen(after_get), dataqueue_pop_after_obtain(sg, p_queue, 0), X) &&
      OutsideCritical(sg, after_get) * peak_data_slot(StartAddr, old_data) *
      peak_length_slot(size, old_length) * undef_data_at(&abandon_id) */
    /*@ Given after_get */
    lock = CriticalAreaLock();
    /*@ Assert exists (seen_ring : VarGlobalState) (q : DataQueueAbs) saved_ring,
      p_queue == p_queue@pre && StartAddr == StartAddr@pre && size == size@pre &&
      timeout == timeout@pre && lock == saved_ring && obtain_id == dq_sem_data(q_id) &&
      Crtos_RTrans(after_get, seen_ring) &&
      safeExec(LastSeen(after_get), dataqueue_pop_after_obtain(sg, p_queue, 0), X) &&
      dataqueue_map(os_dataqueues(seen_ring), p_queue) == Some(q) &&
      dataqueue_ready(q) && 0 < dq_max_len(q) && dq_max_len(q) <= 65535 &&
      0 <= dq_front(q) && dq_front(q) < dq_max_len(q) &&
      InsideCritical(sg, seen_ring) * store_dataqueue(p_queue, q) *
      ((dq_front(q) == dq_rear(q) && wand(store_dataqueue(p_queue, q), os_inv(sg, seen_ring))) ||
       (dq_front(q) != dq_rear(q) &&
         wand(store_dataqueue(p_queue, dataqueue_pop(q)),
           os_inv(sg, replace_dataqueues(dataqueue_publish(p_queue, dataqueue_pop(q), os_dataqueues(seen_ring)), seen_ring))))) *
      peak_data_slot(StartAddr, old_data) * peak_length_slot(size, old_length) *
      undef_data_at(&abandon_id) */
    /*@ Given seen_ring q saved_ring */
    /*@ store_dataqueue(p_queue, q)
        which implies p_queue != 0 && addr_aligned(p_queue, 4) &&
          p_queue->front == dq_front(q) && p_queue->rear == dq_rear(q) &&
          p_queue->max_len == dq_max_len(q) && p_queue->base == dq_base(q) &&
          p_queue->sem_blank == dq_sem_blank(q) && p_queue->sem_data == dq_sem_data(q) &&
          CharArray::undef_full((char *)p_queue + 6, 2) * dataqueue_buffer(q) */
    if (p_queue->front != p_queue->rear) {
        /*@ dataqueue_ready(q) && dq_front(q) != dq_rear(q) && dataqueue_buffer(q)
          which implies exists (e : DataqueueElem),
            dataqueue_ready(q) && dataqueue_peak(q) == Some(e) &&
            dataqueue_slot(dq_base(q), dq_front(q), Some(e)) *
            wand(dataqueue_slot(dq_base(q), dq_front(q), Some(e)), dataqueue_buffer(q)) */
        /*@ Given e */
        /*@ dataqueue_slot(dq_base(q), dq_front(q), Some(e))
          which implies
            store(field_addr(pointer_offset(dq_base(q), dq_front(q), struct DataElem), struct DataElem, data), void *, dq_data(e)) *
            store(field_addr(pointer_offset(dq_base(q), dq_front(q), struct DataElem), struct DataElem, length), unsigned int, dq_length(e)) */
        /*@ peak_data_slot(StartAddr, old_data) * peak_length_slot(size, old_length)
          which implies undef_data_at(StartAddr) * undef_data_at(size) */
        DataElemType *pElem = &(p_queue->base[p_queue->front]);
        *StartAddr = pElem->data;
        *size = pElem->length;
        p_queue->front = (p_queue->front + 1) % p_queue->max_len;
    }
    abandon_id = p_queue->sem_blank;
    /*@ Assert exists (after_ring : VarGlobalState) (result : DataqueuePopResult)
                     (new_data new_length : option Z)
                     (Y_finish : Z -> (VarGlobalState -> Prop) -> Prop),
      p_queue == p_queue@pre && StartAddr == StartAddr@pre && size == size@pre &&
      timeout == timeout@pre && lock == saved_ring && obtain_id == dq_sem_data(q_id) &&
      abandon_id == dq_sem_blank(q) &&
      ((result == DqPopEmpty && new_data == old_data && new_length == old_length) ||
       (exists (item : DataqueueElem), result == DqPopItem(item) &&
         new_data == Some(dq_data(item)) && new_length == Some(dq_length(item)))) &&
      safeExec(LastSeen(after_ring), abs_semaphore_abandon(sg, abandon_id), Y_finish) &&
      (forall (st : VarGlobalState) (status : Z),
        safeExec(LastSeen(st), return(status), Y_finish) =>
        safeExec(LastSeen(st), return(result), X)) &&
      Crtos_GTrans(seen_ring, after_ring) &&
      InsideCritical(sg, seen_ring) * os_inv(sg, after_ring) *
      peak_data_slot(StartAddr, new_data) * peak_length_slot(size, new_length) */
    /*@ Given after_ring result new_data new_length Y_finish */
    CriticalAreaUnLock(lock);
    /* Original OC shared read: KSemaphoreAbandon(p_queue->sem_blank); */
    KSemaphoreAbandon(abandon_id);
    return 0;
}
