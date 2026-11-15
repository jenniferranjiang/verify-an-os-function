#include "dataqueue_logic.h"

/* Legacy NULL_PARAM_CHECK API: default source-processing rule; source
 * canonical annotated_C/src/kernel/common/null_paramter_check.c. */
inline void NULL_PARAM_CHECK_1(void *p)
/*@ Require emp Ensure p != 0 */;

/* Trusted critical API: existing CRTOS semaphore canonical contract. */
x_base CriticalAreaLock(void)
/*@ ordinary
    With (sg : StableGlobalState) (st1 : VarGlobalState)
    Require OutsideCritical(sg, st1)
    Ensure exists st_lock,
      Crtos_RTrans(st1, st_lock) &&
      InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
 */;

void CriticalAreaUnLock(x_base lock)
/*@ stable
    With (sg : StableGlobalState) (st1 st2 : VarGlobalState)
    Require Crtos_GTrans(st1, st2) &&
      InsideCritical(sg, st1) * os_inv(sg, st2)
    Ensure OutsideCritical(sg, st2)
 */;

/* Trusted allocator/standard library APIs from existing semaphore source. */
void *x_malloc(x_size_t size)
/*@ delay_object
    Require 0 <= size && size <= UINT_MAX
    Ensure (__return == 0) ||
           (0 < __return &&
            __return <= UINT_MAX - size &&
            addr_aligned(__return, ALIGN_SIZE) &&
            CharArray::undef_full(__return, size))
 */;

void *memset(void *s, int c, size_t n)
/*@ Require 0 <= n && n <= UINT_MAX &&
            0 <= c && c <= 127 &&
            CharArray::undef_full(s, n)
    Ensure __return == s && CharArray::full(s, n, repeat_Z(c, n))
*/;

int32 KSemaphoreCreate(uint16 val)
/*@ dataqueue_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require os_inv(sg, before)
    Ensure exists after,
      (__return == -5 || (0 <= __return && __return < 128)) &&
      dq_semaphore_create_effect(sg, val, before, __return, after) &&
      os_inv(sg, after)
 */;

void DeInitDataqueue(DataQueueType *p_queue)
/*@ init_rollback
    With (sg : StableGlobalState) (before : VarGlobalState)
         (q : DataqueueAbs) (slots : list(option DataElemAbs)) X
    Require
      safeExec(LastSeen(before), abs_dataqueue_deinit(sg, q), X) &&
      OutsideCritical(sg, before) * dataqueue_storage(p_queue, q, slots)
    Ensure exists after,
      safeExec(LastSeen(after), return(dq_cleared(q)), X) &&
      OutsideCritical(sg, after) *
      dataqueue_storage(p_queue, dq_cleared(q), nil)
 */;

x_err_t InitDataqueue(DataQueueType *p_queue, uint16 NodeNumber)
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require 0 <= NodeNumber && NodeNumber <= 65535 &&
      safeExec(LastSeen(before), abs_init_dataqueue(sg, p_queue, NodeNumber), X) &&
      OutsideCritical(sg, before) * DataqueueRaw(p_queue)
    Ensure
      (exists after q,
        __return == EOK &&
        dq_front(q) == 0 && dq_rear(q) == 0 && dq_max_len(q) == NodeNumber &&
        dq_base(q) != 0 && 0 <= dq_blank(q) && dq_blank(q) < 128 &&
        0 <= dq_data(q) && dq_data(q) < 128 && dq_created_refs(q, after) &&
        dq_published_at(p_queue, q, after) &&
        safeExec(LastSeen(after), return(q), X) &&
        OutsideCritical(sg, after))
      ||
      (exists after q,
        __return == -ERROR &&
        dq_front(q) == 0 && dq_rear(q) == 0 && dq_max_len(q) == NodeNumber &&
        dq_base(q) == 0 && dq_blank(q) < 0 && dq_data(q) < 0 &&
        safeExec(LastSeen(after), return(q), X) &&
        OutsideCritical(sg, after) * dataqueue_storage(p_queue, q, nil))
 */
{
    x_base lock = 0;

    NULL_PARAM_CHECK_1(p_queue);

    /* KPrintf debug output omitted by source-processing rule. */

    lock = CriticalAreaLock() /*@ where (ordinary) sg = sg, st1 = before */;
    do {
        memset(p_queue, 0, sizeof(DataQueueType));
        /* Bug fix: zero is a valid semaphore ID; -1 means not acquired. */
        p_queue->sem_blank = -1;
        p_queue->sem_data = -1;
        p_queue->front = p_queue->rear = 0;
        p_queue->max_len = NodeNumber;
        p_queue->base = (DataElemType *)x_malloc(p_queue->max_len * sizeof(DataElemType));
        if (!p_queue->base) {
            break;
        }

        // The semaphore is initialized to len-1, because the full condition of the loop queue is real + 1 = = front, 
        // a vacancy is always wasted
        p_queue->sem_blank = KSemaphoreCreate( p_queue->max_len - 1) /*@ where (dataqueue_ic) sg = sg */;
        /* Original buggy check: if (!p_queue->sem_blank) */
        if (p_queue->sem_blank < 0) {
            break;
        }

        p_queue->sem_data = KSemaphoreCreate( 0) /*@ where (dataqueue_ic) sg = sg */;
        /* Original buggy check: if (!p_queue->sem_data) */
        if (p_queue->sem_data < 0) {
            break;
        }

        CriticalAreaUnLock(lock) /*@ where (stable) sg = sg */;
        return EOK;
    } while (0);

    CriticalAreaUnLock(lock) /*@ where (stable) sg = sg */;
    DeInitDataqueue(p_queue) /*@ where (init_rollback) sg = sg */;
    return -ERROR;
}
