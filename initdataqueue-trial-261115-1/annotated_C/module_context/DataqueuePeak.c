/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/data_queue.c; SHA-256 a8b12c43c3f2061df08320f50daaabda7ada033e40670c2d37ea2d8ef774f601.
 * Rule-authorized shared-access adaptation; no formal spec or VC generated.
 */
#include <xs_dataqueue.h>

x_err_t DataqueuePeak(DataQueueType *p_queue, const void **StartAddr, x_size_t *size)
{
    x_base lock = 0;

    NULL_PARAM_CHECK(p_queue);

    KPrintf("DataqueuePeak\n");

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
