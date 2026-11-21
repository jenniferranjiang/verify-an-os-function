/* Source: /home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/data_queue.c; SHA-256 a8b12c43c3f2061df08320f50daaabda7ada033e40670c2d37ea2d8ef774f601.
 * Rule-authorized shared-access adaptation; reviewed map-based spec.
 */
#include "dataqueue.h"

/*@ Extern Coq
 (wand : Assertion -> Assertion -> Assertion)
 (dataqueue_buffer : DataQueueAbs -> Assertion)
 (dataqueue_ready : DataQueueAbs -> Prop)
 (dataqueue_peak : DataQueueAbs -> option DataqueueElem)
 (dataqueue_slot : Z -> Z -> option DataqueueElem -> Assertion)
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


x_err_t DataqueuePeak(DataQueueType *p_queue, const void **StartAddr, x_size_t *size)
/*@ With (sg : StableGlobalState) (before : VarGlobalState)
         (old_data old_length : option Z) X
    Require safeExec(LastSeen(before), abs_dataqueue_peak(sg, p_queue), X) &&
      OutsideCritical(sg, before) *
      peak_data_slot(StartAddr, old_data) * peak_length_slot(size, old_length)
    Ensure
      (exists after,
        __return == -1 && safeExec(LastSeen(after), return(None), X) &&
        OutsideCritical(sg, after) *
        peak_data_slot(StartAddr, old_data) * peak_length_slot(size, old_length))
      ||
      (exists after (e : DataqueueElem),
        __return == 0 && safeExec(LastSeen(after), return(Some(e)), X) &&
        OutsideCritical(sg, after) *
        peak_data_slot(StartAddr, Some(dq_data(e))) *
        peak_length_slot(size, Some(dq_length(e))))
*/
{
    x_base lock = 0;

    /* NULL_PARAM_CHECK(p_queue); latest log/count diagnostic omitted. */

    /* KPrintf("DataqueuePeak\n"); TrustBase debug removal. */

    /* Source-processing adaptation: protect the shared condition and element
     * reads in one critical section in this callee. The source acquired the
     * lock only after testing front != rear. */
    lock = CriticalAreaLock();
    /*@ Given observed */
    /*@ Assert exists (q : DataQueueAbs) saved,
      p_queue == p_queue@pre && StartAddr == StartAddr@pre && size == size@pre && lock == saved &&
      Crtos_RTrans(before, observed) &&
      safeExec(LastSeen(before), abs_dataqueue_peak(sg, p_queue), X) &&
      dataqueue_map(os_dataqueues(observed), p_queue) == Some(q) &&
      dataqueue_ready(q) &&
      InsideCritical(sg, observed) * store_dataqueue(p_queue, q) *
      wand(store_dataqueue(p_queue, q), os_inv(sg, observed)) *
      peak_data_slot(StartAddr, old_data) * peak_length_slot(size, old_length) */
    /*@ Given q saved */
    /*@ store_dataqueue(p_queue, q)
        which implies p_queue != 0 && addr_aligned(p_queue, 4) &&
          p_queue->front == dq_front(q) && p_queue->rear == dq_rear(q) &&
          p_queue->max_len == dq_max_len(q) && p_queue->base == dq_base(q) &&
          p_queue->sem_blank == dq_sem_blank(q) && p_queue->sem_data == dq_sem_data(q) &&
          CharArray::undef_full((char *)p_queue + 6, 2) * dataqueue_buffer(q) */
    if (p_queue->front != p_queue->rear) {
        
        /* Original lock position: lock = CriticalAreaLock(); */
        /*@ dataqueue_ready(q) && dq_front(q) != dq_rear(q) && dataqueue_buffer(q)
          which implies exists (e : DataqueueElem),
            dataqueue_peak(q) == Some(e) &&
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
        /*@ Assert
          p_queue == p_queue@pre && StartAddr == StartAddr@pre && size == size@pre &&
          pElem == pointer_offset(dq_base(q), dq_front(q), struct DataElem) && lock == saved &&
          safeExec(LastSeen(observed), return(Some(e)), X) && Crtos_GTrans(observed, observed) &&
          InsideCritical(sg, observed) * os_inv(sg, observed) *
          peak_data_slot(StartAddr, Some(dq_data(e))) * peak_length_slot(size, Some(dq_length(e))) */
        CriticalAreaUnLock(lock);
        return EOK;
    } else {
        /*@ Assert p_queue == p_queue@pre && StartAddr == StartAddr@pre && size == size@pre && lock == saved &&
          safeExec(LastSeen(observed), return(None), X) && Crtos_GTrans(observed, observed) &&
          InsideCritical(sg, observed) * os_inv(sg, observed) *
          peak_data_slot(StartAddr, old_data) * peak_length_slot(size, old_length) */
        CriticalAreaUnLock(lock);
        return -ERROR;
    }
}
