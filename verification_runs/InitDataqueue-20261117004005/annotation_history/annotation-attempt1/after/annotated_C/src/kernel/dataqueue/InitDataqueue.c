/* Source: /home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/data_queue.c; SHA-256 a8b12c43c3f2061df08320f50daaabda7ada033e40670c2d37ea2d8ef774f601.
 * User-approved verification-copy defect repair; formal design draft; no VC generated.
 */
#include "dataqueue.h"

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
         (q : DataqueueObject) (refs : DataqueueSemRefs) X
    Require dq_addr(q) == p_queue &&
      safeExec(LastSeen(before), abs_deinit_dataqueue(sg, q, refs), X) &&
      dataqueue_owned(q) * OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) &&
      dataqueue_owned(dataqueue_retired(q)) * OutsideCritical(sg, after)
*/;

x_err_t InitDataqueue(DataQueueType *p_queue, uint16 NodeNumber)
/* Lifecycle: caller supplies fresh or fully retired queue storage, with no
 * old allocation/semaphore obligation; this does not initialize a live queue. */
/*@ With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_init_dataqueue(sg, p_queue, NodeNumber), X) &&
      DataqueueStorage(p_queue) * OutsideCritical(sg, before)
    Ensure
      (exists after q,
        __return == 0 && In(q, os_dataqueues(after)) &&
        dq_addr(q) == p_queue && dq_max_len(q) == NodeNumber &&
        dq_front(q) == 0 && dq_rear(q) == 0 && dq_base(q) != 0 &&
        0 <= dq_sem_blank(q) && 0 <= dq_sem_data(q) &&
        dq_sem_blank(q) != dq_sem_data(q) &&
        safeExec(LastSeen(after), return(0), X) && OutsideCritical(sg, after))
      ||
      (exists after q,
        __return == -1 && dq_addr(q) == p_queue &&
        dq_max_len(q) == NodeNumber && dq_front(q) == 0 && dq_rear(q) == 0 &&
        dq_base(q) == 0 &&
        ((dq_sem_blank(q) == -1 && dq_sem_data(q) == -1) ||
         (dq_sem_blank(q) == -5 && dq_sem_data(q) == -1) ||
         (dq_sem_blank(q) == -1 && dq_sem_data(q) == -5)) &&
        safeExec(LastSeen(after), return(-1), X) &&
        dataqueue_owned(q) * OutsideCritical(sg, after))
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
        /*@ CharArray::full(p_queue, sizeof(DataQueueType), repeat_Z(0, sizeof(DataQueueType)))
            which implies
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
          In(q, os_dataqueues(after)) && dq_addr(q) == p_queue &&
          dq_max_len(q) == NodeNumber && dq_front(q) == 0 && dq_rear(q) == 0 &&
          dq_base(q) != 0 && 0 <= dq_sem_blank(q) && 0 <= dq_sem_data(q) &&
          dq_sem_blank(q) != dq_sem_data(q) &&
          safeExec(LastSeen(after), return(0), X) && Crtos_GTrans(observed, after) &&
          InsideCritical(sg, observed) * os_inv(sg, after) */
        /*@ Given after q saved */
        CriticalAreaUnLock(lock) /*@ where sg = sg, held = observed, after = after */;
        return EOK;
    } while (0);

    /*@ Assert exists held after q refs Y saved,
      lock == saved && p_queue == p_queue@pre && NodeNumber == NodeNumber@pre &&
      dq_addr(q) == p_queue && dq_max_len(q) == NodeNumber &&
      dq_front(q) == 0 && dq_rear(q) == 0 &&
      ((dq_sem_blank(q) == -1 && dq_sem_data(q) == -1) ||
       (dq_sem_blank(q) == -5 && dq_sem_data(q) == -1) ||
       (0 <= dq_sem_blank(q) && dq_sem_data(q) == -5)) &&
      safeExec(LastSeen(after), abs_deinit_dataqueue(sg, q, refs), Y) &&
      (forall (final : VarGlobalState),
        safeExec(LastSeen(final), return(tt), Y) =>
        safeExec(LastSeen(final), return(-1), X)) &&
      Crtos_GTrans(held, after) &&
      InsideCritical(sg, held) * os_inv(sg, after) * dataqueue_owned(q) */
    /*@ Given held after q refs Y saved */
    CriticalAreaUnLock(lock) /*@ where sg = sg, held = held, after = after */;
    DeInitDataqueue(p_queue) /*@ where (init_cleanup) sg = sg, before = after, q = q, refs = refs, X = Y */;
    return -ERROR;
}
