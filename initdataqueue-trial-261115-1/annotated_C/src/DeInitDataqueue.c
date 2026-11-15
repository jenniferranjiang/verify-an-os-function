/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/data_queue.c; SHA-256 a8b12c43c3f2061df08320f50daaabda7ada033e40670c2d37ea2d8ef774f601.
 * User-approved trial-only defect repair; no formal spec or VC generated.
 */
#include <xs_dataqueue.h>

void DeInitDataqueue(DataQueueType *p_queue)
{
    x_base lock = 0;

    NULL_PARAM_CHECK(p_queue);

    KPrintf("DeInitDataqueue\n");

    lock = DISABLE_INTERRUPT();

    if (p_queue->base) {
        x_free(p_queue->base);
        p_queue->base = NONE;
    }

    /* Approved trial-only bug fix; original: if (p_queue->sem_blank) */
    if (p_queue->sem_blank >= 0) {
        KSemaphoreDelete(p_queue->sem_blank);
        /* Original buggy reset: p_queue->sem_blank = NONE; */
        p_queue->sem_blank = -1;
    }

    /* Approved trial-only bug fix; original: if (p_queue->sem_data) */
    if (p_queue->sem_data >= 0) {
        KSemaphoreDelete(p_queue->sem_data);
        /* Original buggy reset: p_queue->sem_data = NONE; */
        p_queue->sem_data = -1;
    }
    ENABLE_INTERRUPT(lock);
}
