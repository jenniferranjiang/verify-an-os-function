/* Source: crtoslatest/kernel/thread/data_queue.c (actual repository path and
 * SHA-256 are recorded in source-analysis.md). DQ-02/03 approved repair:
 * every timeout is forwarded once and an Obtain error returns -ERROR.
 * Shared ID reads are protected using the source-processing rule.
 * This is a repaired verification copy, not an equivalence claim for original C. */
#define CRTOS_DATAQUEUE_WITH_OPERATIONS 1
#include "dataqueue.h"
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
    if (EOK != KSemaphoreObtain(obtain_id, timeout)) {
        return -ERROR;
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
          which implies exists (e : DataqueueElem) (rest : list DataqueueElem),
            dq_slots(q) == cons(e, rest) &&
            dataqueue_ready(q) && dataqueue_peak(q) == Some(e) &&
            dataqueue_slot(dq_base(q), dq_front(q), e) *
            wand(dataqueue_slot(dq_base(q), dq_front(q), e), dataqueue_buffer(q)) */
        /*@ Given e rest */
        /*@ dataqueue_slot(dq_base(q), dq_front(q), e)
          which implies
            store(field_addr(pointer_offset(dq_base(q), dq_front(q), struct DataElem), struct DataElem, data), void *, dq_data(e)) *
            store(field_addr(pointer_offset(dq_base(q), dq_front(q), struct DataElem), struct DataElem, length), unsigned int, dq_length(e)) */
        /*@ peak_data_slot(StartAddr, old_data) * peak_length_slot(size, old_length)
          which implies undef_data_at(StartAddr) * undef_data_at(size) */
        DataElemType *pElem = &(p_queue->base[p_queue->front]);
        *StartAddr = pElem->data;
        *size = pElem->length;
        /* The bytes are not cleared. Rebuild the old buffer after reading,
         * then forget the removed head value and retain the FIFO tail. */
        /*@ dataqueue_slot(dq_base(q), dq_front(q), e) *
            wand(dataqueue_slot(dq_base(q), dq_front(q), e), dataqueue_buffer(q))
            which implies dataqueue_buffer(q) */
        /*@ dataqueue_ready(q) && dq_slots(q) == cons(e, rest) && dataqueue_buffer(q)
            which implies dq_slots(dataqueue_pop(q)) == rest &&
              dataqueue_buffer(dataqueue_pop(q)) */
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
    return EOK;
}
