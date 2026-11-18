# 0 "/home/xinra/crtos-verify/annotated_C/src/kernel/dataqueue/InitDataqueue.c"
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
# 1 "/home/xinra/crtos-verify/annotated_C/src/kernel/dataqueue/InitDataqueue.c"
/* Source: /home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/data_queue.c; SHA-256 a8b12c43c3f2061df08320f50daaabda7ada033e40670c2d37ea2d8ef774f601.
 * User-approved verification-copy defect repair; formal design draft; no VC generated.
 */
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
# 5 "/home/xinra/crtos-verify/annotated_C/src/kernel/dataqueue/InitDataqueue.c" 2

/* Trusted TrustBase critical resource transfer; non-SMP, ILP32. */
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
/* KERNEL_MALLOC exact macro target, trusted; byte_manage.c size==0 branch. */
void *x_malloc(x_size_t size)
/*@ Require emp
    Ensure (size == 0 && __return == 0) ||
      (size > 0 && __return == 0) ||
      (size > 0 && __return > 0 && __return <= UINT_MAX - size &&
       addr_aligned(__return, 4) && CharArray::undef_full(__return, size))
*/;
/* C standard-library model; owns all bytes, including struct padding. */
void *memset(void *s, int c, size_t n)
/*@ Require 0 <= c && c <= 127 && CharArray::undef_full(s, n)
    Ensure __return == s && CharArray::full(s, n, repeat_Z(c, n))
*/;

int32 KSemaphoreCreate(uint16 val)
/*@ dataqueue_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require os_inv(sg, before)
    Ensure exists after,
      ((__return == -5) || (0 <= __return && __return < 128)) &&
      semaphore_create_ic_effect(sg, val, before, __return, after) &&
      os_inv(sg, after)
*/;

void DeInitDataqueue(DataQueueType *p_queue)
/*@ init_cleanup
    With (sg : StableGlobalState) (before : VarGlobalState)
         (q : DataQueueAbs) (refs : DataqueueSemRefs) X
    Require 
      safeExec(LastSeen(before), abs_deinit_dataqueue(sg, p_queue, q, refs), X) &&
      store_dataqueue(p_queue, q) * OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) &&
      store_dataqueue(p_queue, dataqueue_retired(q)) * OutsideCritical(sg, after)
*/;

x_err_t InitDataqueue(DataQueueType *p_queue, uint16 NodeNumber)
/* Lifecycle: caller supplies fresh or fully retired queue storage, with no
 * old allocation/semaphore obligation; this does not initialize a live queue. */
/*@ With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_init_dataqueue(sg, p_queue, NodeNumber), X) &&
      DataqueueStorage(p_queue) * OutsideCritical(sg, before)
    Ensure
      (exists after q,
        __return == 0 && dataqueue_map(os_dataqueues(after), p_queue) == Some(q) &&
         dq_max_len(q) == NodeNumber &&
        dq_front(q) == 0 && dq_rear(q) == 0 && dq_base(q) != 0 &&
        0 <= dq_sem_blank(q) && 0 <= dq_sem_data(q) &&
        dq_sem_blank(q) != dq_sem_data(q) &&
        safeExec(LastSeen(after), return(0), X) && OutsideCritical(sg, after))
      ||
      (exists after q,
        __return == -1 && 
        dq_max_len(q) == NodeNumber && dq_front(q) == 0 && dq_rear(q) == 0 &&
        dq_base(q) == 0 &&
        ((dq_sem_blank(q) == -1 && dq_sem_data(q) == -1) ||
         (dq_sem_blank(q) == -5 && dq_sem_data(q) == -1) ||
         (dq_sem_blank(q) == -1 && dq_sem_data(q) == -5)) &&
        safeExec(LastSeen(after), return(-1), X) &&
        store_dataqueue(p_queue, q) * OutsideCritical(sg, after))
*/
{
    x_base lock = 0;

    /* NULL_PARAM_CHECK(p_queue); latest log/count diagnostic omitted. */

    /* KPrintf("InitDataqueue\n"); trusted debug removal */

    /*@ DataqueueStorage(p_queue)
        which implies p_queue != 0 && addr_aligned(p_queue, 4) &&
          CharArray::undef_full(p_queue, sizeof(DataQueueType)) */
    lock = CriticalAreaLock();
    /*@ Given observed */
    do {
        memset(p_queue, 0, sizeof(DataQueueType));
        /*@ addr_aligned(p_queue, 4) &&
            CharArray::full(p_queue, sizeof(DataQueueType), repeat_Z(0, sizeof(DataQueueType)))
            which implies
              addr_aligned(p_queue, 4) &&
              p_queue->front == 0 && p_queue->rear == 0 &&
              p_queue->max_len == 0 && p_queue->base == 0 &&
              p_queue->sem_blank == 0 && p_queue->sem_data == 0 &&
              CharArray::undef_full((char *)p_queue + 6, 2) */
        /* Approved verification-copy bug fix: zero is a valid semaphore ID.
         * Original code left both IDs at the memset value zero. */
        p_queue->sem_blank = -1;
        p_queue->sem_data = -1;
        /* QCP equivalent of p_queue->front = p_queue->rear = 0. */
        p_queue->rear = 0;
        p_queue->front = 0;
        p_queue->max_len = NodeNumber;
        p_queue->base = (DataElemType *)x_malloc(p_queue->max_len * sizeof(DataElemType));
        if (!p_queue->base) {
            break;
        }

        // The semaphore is initialized to len-1, because the full condition of the loop queue is real + 1 = = front, 
        // a vacancy is always wasted
        p_queue->sem_blank = KSemaphoreCreate( p_queue->max_len - 1);
        /* Original buggy check: if (!p_queue->sem_blank) */
        if (p_queue->sem_blank < 0) {
            break;
        }

        p_queue->sem_data = KSemaphoreCreate( 0);
        /* Original buggy check: if (!p_queue->sem_data) */
        if (p_queue->sem_data < 0) {
            break;
        }

        /*@ Assert exists after q saved,
          lock == saved && p_queue == p_queue@pre && NodeNumber == NodeNumber@pre &&
          dataqueue_map(os_dataqueues(after), p_queue) == Some(q) && 
          dq_max_len(q) == NodeNumber && dq_front(q) == 0 && dq_rear(q) == 0 &&
          dq_base(q) != 0 && 0 <= dq_sem_blank(q) && 0 <= dq_sem_data(q) &&
          dq_sem_blank(q) != dq_sem_data(q) &&
          safeExec(LastSeen(after), return(0), X) && Crtos_GTrans(observed, after) &&
          InsideCritical(sg, observed) * os_inv(sg, after) */
        /*@ Given after q saved */
        CriticalAreaUnLock(lock) /*@ where sg = sg, held = observed, after = after */;
        return 0;
    } while (0);

    /*@ Assert exists held after q refs Y saved,
      lock == saved && p_queue == p_queue@pre && NodeNumber == NodeNumber@pre &&
       dq_max_len(q) == NodeNumber &&
      dq_front(q) == 0 && dq_rear(q) == 0 &&
      ((dq_sem_blank(q) == -1 && dq_sem_data(q) == -1) ||
       (dq_sem_blank(q) == -5 && dq_sem_data(q) == -1) ||
       (0 <= dq_sem_blank(q) && dq_sem_data(q) == -5)) &&
      safeExec(LastSeen(after), abs_deinit_dataqueue(sg, p_queue, q, refs), Y) &&
      (forall (final : VarGlobalState),
        safeExec(LastSeen(final), return(tt), Y) =>
        safeExec(LastSeen(final), return(-1), X)) &&
      Crtos_GTrans(held, after) &&
      InsideCritical(sg, held) * os_inv(sg, after) * store_dataqueue(p_queue, q) */
    /*@ Given held after q refs Y saved */
    CriticalAreaUnLock(lock) /*@ where sg = sg, held = held, after = after */;
    DeInitDataqueue(p_queue) /*@ where (init_cleanup) sg = sg, before = after, q = q, refs = refs, X = Y */;
    return -1;
}
