/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/data_queue.c; SHA-256 a8b12c43c3f2061df08320f50daaabda7ada033e40670c2d37ea2d8ef774f601.
 * Approved repair copy for module analysis; no formal spec or VC target yet.
 */
#include <xs_dataqueue.h>

x_err_t PopDataqueue(DataQueueType *p_queue, const void **StartAddr, x_size_t *size, int32 timeout)
{
    x_base lock = 0;
    int obtain_id;
    int abandon_id;

    NULL_PARAM_CHECK(p_queue);

    KPrintf("PopDataqueue\n");

    /* Bug fix approved for this trial only: retain the original code below.
    do {
        if (WAITING_FOREVER == timeout) {
            // block
            KSemaphoreObtain(p_queue->sem_data, WAITING_FOREVER);
            break;
        } else if (0 == timeout) {
            // Nonblocking
            if (EOK == KSemaphoreObtain(p_queue->sem_data, 0)) {
                // Get success
                break;
            } else {
                // Get failed, exit directly
                return -ERROR;
            }
        }
    } while (0);
    */
    /* Shared-access adaptation: the original call read p_queue->sem_data
     * outside the critical section. Cache this shared field under the lock. */
    lock = CriticalAreaLock();
    obtain_id = p_queue->sem_data;
    CriticalAreaUnLock(lock);
    if (EOK != KSemaphoreObtain(obtain_id, timeout)) {
        return -ERROR;
    }

    
    lock = CriticalAreaLock();
    // Semaphore surplus, read data directly
    if (p_queue->front != p_queue->rear) {
        DataElemType *pElem = &(p_queue->base[p_queue->front]);
        *StartAddr = pElem->data;
        *size = pElem->length;
        p_queue->front = (p_queue->front + 1) % p_queue->max_len;
    }
    /* Cache the second shared ID before releasing this critical section. */
    abandon_id = p_queue->sem_blank;
    CriticalAreaUnLock(lock);

    // Release data semaphore
    /* Original shared read: KSemaphoreAbandon(p_queue->sem_blank); */
    KSemaphoreAbandon(abandon_id);
    return EOK;
}
