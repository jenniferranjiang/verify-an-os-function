/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/data_queue.c; SHA-256 a8b12c43c3f2061df08320f50daaabda7ada033e40670c2d37ea2d8ef774f601.
 * Approved repair copy for module analysis; no formal spec or VC target yet.
 */
#include <xs_dataqueue.h>

x_err_t PushDataqueue(DataQueueType *p_queue, const void *StartAddr, x_size_t DataSize, int32 timeout)
{
    x_base lock = 0;
    int obtain_id;
    int abandon_id;

    NULL_PARAM_CHECK(p_queue);
    NULL_PARAM_CHECK(StartAddr);

    KPrintf("PushDataqueue\n");

    /* Bug fix approved for this trial only: retain the original code below.
    do {
        if (WAITING_FOREVER == timeout) {
            // block
            KSemaphoreObtain(p_queue->sem_blank, WAITING_FOREVER);
            break;
        } else if (0 == timeout) {
            // Nonblocking
            if (EOK == KSemaphoreObtain(p_queue->sem_blank, 0)) {
                break;
            } else {
                return -ERROR;
            }
        }
    } while (0);
    */
    /* Shared-access adaptation: the original call read p_queue->sem_blank
     * outside the critical section. Cache this shared field under the lock. */
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
    /* Cache the second shared ID before releasing this critical section. */
    abandon_id = p_queue->sem_data;
    CriticalAreaUnLock(lock);

    /* Original shared read: KSemaphoreAbandon(p_queue->sem_data); */
    KSemaphoreAbandon(abandon_id);
    return EOK;
}
