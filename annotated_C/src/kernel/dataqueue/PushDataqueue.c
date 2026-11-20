/* Source: crtoslatest/kernel/thread/data_queue.c (actual repository path and
 * SHA-256 are recorded in source-analysis.md). DQ-02/03 approved repair:
 * every timeout is forwarded once and an Obtain error returns -ERROR.
 * Shared ID reads are protected using the source-processing rule.
 * This is a repaired verification copy, not an equivalence claim for original C. */
#define CRTOS_DATAQUEUE_WITH_OPERATIONS 1
#include "dataqueue.h"
#include "semaphore_runtime_logic.h"

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

/* abs_push_dataqueue describes each critical phase. In the non-full ring
 * branch, dataqueue_push appends {StartAddr, DataSize} to dq_slots.
 * The existing full branch is a no-op even though this C function returns 0. */
x_err_t PushDataqueue(DataQueueType *p_queue, const void *StartAddr, x_size_t DataSize, int32 timeout)
/*@ With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before),
      abs_push_dataqueue(sg, p_queue, StartAddr, DataSize, timeout), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      (__return == -1 || __return == 0) &&
      safeExec(LastSeen(after), return(__return), X) && OutsideCritical(sg, after)
*/
{
    x_base lock = 0;
    int32 obtain_id;
    int32 abandon_id;
    /* NULL_PARAM_CHECK(p_queue); NULL_PARAM_CHECK(StartAddr);
     * KPrintf("PushDataqueue\n"); log/count-only diagnostics omitted. */
    /* Original DQ-02/03 block (replaced by approved repair):
     * do {
     *   if (WAITING_FOREVER == timeout) {
     *     KSemaphoreObtain(p_queue->sem_blank, WAITING_FOREVER); break;
     *   } else if (0 == timeout) {
     *     if (EOK == KSemaphoreObtain(p_queue->sem_blank, 0)) break;
     *     else return -ERROR;
     *   }
     * } while (0);
     */
    lock = CriticalAreaLock();
    obtain_id = p_queue->sem_blank;
    CriticalAreaUnLock(lock);
    if (EOK != KSemaphoreObtain(obtain_id, timeout)) {
        return -ERROR;
    }
    lock = CriticalAreaLock();
    if ((p_queue->rear + 1) % p_queue->max_len != p_queue->front) {
        DataElemType *pElem = &(p_queue->base[p_queue->rear]);
        pElem->data = StartAddr;
        pElem->length = DataSize;
        p_queue->rear = (p_queue->rear + 1) % p_queue->max_len;
    }
    abandon_id = p_queue->sem_data;
    CriticalAreaUnLock(lock);
    /* Original OC shared read: KSemaphoreAbandon(p_queue->sem_data); */
    KSemaphoreAbandon(abandon_id);
    return EOK;
}
