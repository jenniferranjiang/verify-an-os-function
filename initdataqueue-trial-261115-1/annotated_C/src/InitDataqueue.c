/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/data_queue.c; SHA-256 a8b12c43c3f2061df08320f50daaabda7ada033e40670c2d37ea2d8ef774f601.
 * User-approved trial-only defect repair; no formal spec or VC generated.
 */
#include <xs_dataqueue.h>

void DeInitDataqueue(DataQueueType *p_queue);

x_err_t InitDataqueue(DataQueueType *p_queue, uint16 NodeNumber)
{
    x_base lock = 0;

    NULL_PARAM_CHECK(p_queue);

    KPrintf("InitDataqueue\n");

    lock = CriticalAreaLock();
    do {
        memset(p_queue, 0, sizeof(DataQueueType));
        /* Approved trial-only bug fix: zero is a valid semaphore ID.
         * Original code left both IDs at the memset value zero. */
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

        CriticalAreaUnLock(lock);
        return EOK;
    } while (0);

    CriticalAreaUnLock(lock);
    DeInitDataqueue(p_queue);
    return -ERROR;
}
