/* Source: crtoslatest/kernel/thread/data_queue.c (actual repository path and
 * SHA-256 are recorded in source-analysis.md). DQ-02/03 approved repair:
 * every timeout is forwarded once and an Obtain error returns -ERROR.
 * Shared ID reads are protected using the source-processing rule.
 * This is a repaired verification copy, not an equivalence claim for original C. */
#define CRTOS_DATAQUEUE_WITH_OPERATIONS 1
#include "dataqueue.h"
#include "crtos_constants.h"
/* KPopDataqueue imports both runtime semantic modules.  Keep the caller's
 * vocabulary local: the broad runtime header also redeclares C macro names. */
/*@ Extern Coq
 (abs_semaphore_obtain : StableGlobalState -> Z -> Z -> program (VarGlobalState -> Prop) Z)
 (abs_semaphore_abandon : StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
 (wand : Assertion -> Assertion -> Assertion)
 (dataqueue_buffer : DataQueueAbs -> Assertion)
 (dataqueue_ready : DataQueueAbs -> Prop)
 (dataqueue_peak : DataQueueAbs -> option DataqueueElem)
 (dataqueue_slot : Z -> Z -> DataqueueElem -> Assertion)
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
      (__return == -KERROR &&
        (exists after,
          safeExec(LastSeen(after), return(DqPopFailed), X) &&
          OutsideCritical(sg, after) *
          peak_data_slot(StartAddr, old_data) * peak_length_slot(size, old_length)))
      ||
      (__return == KOK &&
        (exists after,
          safeExec(LastSeen(after), return(DqPopEmpty), X) &&
          OutsideCritical(sg, after) *
          peak_data_slot(StartAddr, old_data) * peak_length_slot(size, old_length)))
      ||
      (__return == KOK &&
        (exists after (e : DataqueueElem),
          safeExec(LastSeen(after), return(DqPopItem(e)), X) &&
          OutsideCritical(sg, after) *
          peak_data_slot(StartAddr, Some(e.dq_data)) *
          peak_length_slot(size, Some(e.dq_length))))
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
      (seen_id.os_dataqueues.dataqueue_map)(p_queue) == Some(q_id) &&
      dataqueue_ready(q_id) &&
      InsideCritical(sg, seen_id) * store_dataqueue(p_queue, q_id) *
      wand(store_dataqueue(p_queue, q_id), os_inv(sg, seen_id)) *
      peak_data_slot(StartAddr, old_data) * peak_length_slot(size, old_length) *
      undef_data_at(&obtain_id) * undef_data_at(&abandon_id) */
    /*@ Given seen_id q_id saved_id */
    /*@ dataqueue_ready(q_id) && store_dataqueue(p_queue, q_id)
        which implies dataqueue_ready(q_id) && p_queue != 0 && addr_aligned(p_queue, 4) &&
          p_queue->front == q_id.dq_front && p_queue->rear == q_id.dq_rear &&
          p_queue->max_len == q_id.dq_max_len && p_queue->base == q_id.dq_base &&
          p_queue->sem_blank == q_id.dq_sem_blank && p_queue->sem_data == q_id.dq_sem_data &&
          CharArray::undef_full((char *)p_queue + 6, 2) * dataqueue_buffer(q_id) */
    obtain_id = p_queue->sem_data;
    /*@ Assert exists (Y : Z -> (VarGlobalState -> Prop) -> Prop),
      p_queue == p_queue@pre && StartAddr == StartAddr@pre && size == size@pre &&
      timeout == timeout@pre && lock == saved_id && obtain_id == q_id.dq_sem_data &&
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
    if (EOK != KSemaphoreObtain(obtain_id, timeout)) {
        return -ERROR;
    }
    /*@ Assert exists (after_get : VarGlobalState),
      p_queue == p_queue@pre && StartAddr == StartAddr@pre && size == size@pre &&
      timeout == timeout@pre && lock == saved_id && obtain_id == q_id.dq_sem_data &&
      safeExec(LastSeen(after_get), dataqueue_pop_after_obtain(sg, p_queue, 0), X) &&
      OutsideCritical(sg, after_get) * peak_data_slot(StartAddr, old_data) *
      peak_length_slot(size, old_length) * undef_data_at(&abandon_id) */
    /*@ Given after_get */
    lock = CriticalAreaLock();
    /*@ Assert exists (seen_ring : VarGlobalState) (q : DataQueueAbs) saved_ring,
      p_queue == p_queue@pre && StartAddr == StartAddr@pre && size == size@pre &&
      timeout == timeout@pre && lock == saved_ring && obtain_id == q_id.dq_sem_data &&
      Crtos_RTrans(after_get, seen_ring) &&
      safeExec(LastSeen(after_get), dataqueue_pop_after_obtain(sg, p_queue, 0), X) &&
      (seen_ring.os_dataqueues.dataqueue_map)(p_queue) == Some(q) &&
      dataqueue_ready(q) && 0 < q.dq_max_len && q.dq_max_len <= 65535 &&
      0 <= q.dq_front && q.dq_front < q.dq_max_len &&
      InsideCritical(sg, seen_ring) * store_dataqueue(p_queue, q) *
      ((q.dq_front == q.dq_rear && wand(store_dataqueue(p_queue, q), os_inv(sg, seen_ring))) ||
       (q.dq_front != q.dq_rear &&
         wand(store_dataqueue(p_queue, dataqueue_pop(q)),
           os_inv(sg, replace_dataqueues(dataqueue_publish(p_queue, dataqueue_pop(q), seen_ring.os_dataqueues), seen_ring))))) *
      peak_data_slot(StartAddr, old_data) * peak_length_slot(size, old_length) *
      undef_data_at(&abandon_id) */
    /*@ Given seen_ring q saved_ring */
    /*@ dataqueue_ready(q) && store_dataqueue(p_queue, q)
        which implies dataqueue_ready(q) && p_queue != 0 && addr_aligned(p_queue, 4) &&
          p_queue->front == q.dq_front && p_queue->rear == q.dq_rear &&
          p_queue->max_len == q.dq_max_len && p_queue->base == q.dq_base &&
          p_queue->sem_blank == q.dq_sem_blank && p_queue->sem_data == q.dq_sem_data &&
          CharArray::undef_full((char *)p_queue + 6, 2) * dataqueue_buffer(q) */
    if (p_queue->front != p_queue->rear) {
        /*@ dataqueue_ready(q) && q.dq_front != q.dq_rear && dataqueue_buffer(q)
          which implies exists (e : DataqueueElem) (rest : list DataqueueElem),
            q.dq_slots == cons(e, rest) &&
            dataqueue_ready(q) && dataqueue_peak(q) == Some(e) &&
            dataqueue_slot(q.dq_base, q.dq_front, e) *
            wand(dataqueue_slot(q.dq_base, q.dq_front, e), dataqueue_buffer(q)) */
        /*@ Given e rest */
        /*@ dataqueue_slot(q.dq_base, q.dq_front, e)
          which implies
            store(field_addr(pointer_offset(q.dq_base, q.dq_front, struct DataElem), struct DataElem, data), void *, e.dq_data) *
            store(field_addr(pointer_offset(q.dq_base, q.dq_front, struct DataElem), struct DataElem, length), unsigned int, e.dq_length) */
        /*@ peak_data_slot(StartAddr, old_data) * peak_length_slot(size, old_length)
          which implies undef_data_at(StartAddr) * undef_data_at(size) */
        DataElemType *pElem = &(p_queue->base[p_queue->front]);
        *StartAddr = pElem->data;
        *size = pElem->length;
        /* The bytes are not cleared. Rebuild the old buffer after reading,
         * then forget the removed head value and retain the FIFO tail. */
        /*@ dataqueue_slot(q.dq_base, q.dq_front, e) *
            wand(dataqueue_slot(q.dq_base, q.dq_front, e), dataqueue_buffer(q))
            which implies dataqueue_buffer(q) */
        /*@ dataqueue_ready(q) && q.dq_slots == cons(e, rest) && dataqueue_buffer(q)
            which implies (dataqueue_pop(q)).dq_slots == rest &&
              dataqueue_buffer(dataqueue_pop(q)) */
        p_queue->front = (p_queue->front + 1) % p_queue->max_len;
    }
    abandon_id = p_queue->sem_blank;
    /*@ Assert exists (after_ring : VarGlobalState) (result : DataqueuePopResult)
                     (new_data new_length : option Z)
                     (Y_finish : Z -> (VarGlobalState -> Prop) -> Prop),
      p_queue == p_queue@pre && StartAddr == StartAddr@pre && size == size@pre &&
      timeout == timeout@pre && lock == saved_ring && obtain_id == q_id.dq_sem_data &&
      abandon_id == q.dq_sem_blank &&
      ((result == DqPopEmpty && new_data == old_data && new_length == old_length) ||
       (exists (item : DataqueueElem), result == DqPopItem(item) &&
         new_data == Some(item.dq_data) && new_length == Some(item.dq_length))) &&
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
    return EOK;
}
