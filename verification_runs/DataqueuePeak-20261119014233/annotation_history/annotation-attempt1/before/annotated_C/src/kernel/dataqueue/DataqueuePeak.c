/* Source: /home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/data_queue.c; SHA-256 a8b12c43c3f2061df08320f50daaabda7ada033e40670c2d37ea2d8ef774f601.
 * Rule-authorized shared-access adaptation; new formal spec draft; no VC generated.
 */
#include "dataqueue.h"

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
    if (p_queue->front != p_queue->rear) {
        
        /* Original lock position: lock = CriticalAreaLock(); */
        DataElemType *pElem = &(p_queue->base[p_queue->front]);
        *StartAddr = pElem->data;
        *size = pElem->length;
        CriticalAreaUnLock(lock);
        return EOK;
    } else {
        CriticalAreaUnLock(lock);
        return -ERROR;
    }
}
