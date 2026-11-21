/* Source: /home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/data_queue.c; SHA-256 a8b12c43c3f2061df08320f50daaabda7ada033e40670c2d37ea2d8ef774f601.
 * User-approved verification-copy defect repair; formal design draft; no VC generated.
 */
#include "dataqueue.h"

/* User-authorized IRQ resource boundary, context.md. The body passes the
 * same saved Disable value unchanged to Enable; no mstatus correctness claim. */
x_base DisableLocalInterrupt(void)
/*@ With (sg : StableGlobalState) (before : VarGlobalState)
    Require OutsideCritical(sg, before)
    Ensure exists observed,
      Crtos_RTrans(before, observed) &&
      InsideCritical(sg, observed) * os_inv(sg, observed)
*/;
void EnableLocalInterrupt(x_base lock)
/*@ With (sg : StableGlobalState) (held after : VarGlobalState)
    Require Crtos_GTrans(held, after) &&
      InsideCritical(sg, held) * os_inv(sg, after)
    Ensure OutsideCritical(sg, after)
*/;
/* Trusted KERNEL_FREE boundary: consume the buffer in its existing FIFO
 * representation; the queue descriptor remains with the caller. */
void x_free(void *p)
/*@ dataqueue_free_buffer
    With (q : DataQueueAbs)
    Require p == q.dq_base && p != 0 && dataqueue_buffer(q)
    Ensure emp
*/;

void KSemaphoreDelete(int32 id)
/*@ dataqueue_cleanup_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require semaphore_delete_quiescent(id, before) && os_inv(sg, before)
    Ensure exists after,
      semaphore_delete_ic_effect(id, before, after) && os_inv(sg, after)
*/;

void DeInitDataqueue(DataQueueType *p_queue)
/*@ init_cleanup
    With (sg : StableGlobalState) (before : VarGlobalState)
         (q : DataQueueAbs) (refs : DataqueueSemRefs) X
    Require 
      safeExec(LastSeen(before), abs_deinit_dataqueue(sg, p_queue, q, refs), X) &&
      store_dataqueue(p_queue, q) * OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) &&
      store_dataqueue(p_queue, dataqueue_retired(q)) * OutsideCritical(sg, after)
*/
{
    x_base lock = 0;

    /* NULL_PARAM_CHECK(p_queue); latest log/count diagnostic omitted. */

    /* KPrintf("DeInitDataqueue\n"); trusted debug removal */

    lock = DisableLocalInterrupt();
    /*@ Given observed */
    /*@ Assert exists saved,
      p_queue == p_queue@pre && lock == saved &&
      Crtos_RTrans(before, observed) &&
      safeExec(LastSeen(before), abs_deinit_dataqueue(sg, p_queue, q, refs), X) &&
      semaphore_delete_quiescent(q.dq_sem_blank, observed) &&
      semaphore_delete_quiescent(q.dq_sem_data, observed) &&
      InsideCritical(sg, observed) * os_inv(sg, observed) * store_dataqueue(p_queue, q) */
    /*@ Given saved */
    /*@ store_dataqueue(p_queue, q)
        which implies p_queue != 0 && addr_aligned(p_queue, 4) &&
          p_queue->front == q.dq_front && p_queue->rear == q.dq_rear &&
          p_queue->max_len == q.dq_max_len && p_queue->base == q.dq_base &&
          p_queue->sem_blank == q.dq_sem_blank && p_queue->sem_data == q.dq_sem_data &&
          CharArray::undef_full((char *)p_queue + 6, 2) *
          ((q.dq_base == 0 && emp) ||
           (q.dq_base != 0 && dataqueue_buffer(q))) */

    if (p_queue->base) {
        x_free(p_queue->base) /*@ where (dataqueue_free_buffer) q = q */;
        p_queue->base = NONE;
    }

    /* Approved trial-only bug fix; original: if (p_queue->sem_blank) */
    if (p_queue->sem_blank >= 0) {
        KSemaphoreDelete(p_queue->sem_blank) /*@ where (dataqueue_cleanup_ic) sg = sg, before = observed */;
        /*@ Given after */
        /* Original buggy reset: p_queue->sem_blank = NONE; */
        p_queue->sem_blank = -1;
    }

    /*@ Assert exists middle,
      p_queue == p_queue@pre && lock == saved && p_queue != 0 && addr_aligned(p_queue, 4) &&
      Crtos_RTrans(before, observed) &&
      safeExec(LastSeen(before), abs_deinit_dataqueue(sg, p_queue, q, refs), X) &&
      ((0 <= q.dq_sem_blank && semaphore_delete_ic_effect(q.dq_sem_blank, observed, middle)) ||
       (q.dq_sem_blank < 0 && middle == observed)) &&
      semaphore_delete_quiescent(q.dq_sem_data, middle) &&
      p_queue->front == q.dq_front && p_queue->rear == q.dq_rear &&
      p_queue->max_len == q.dq_max_len && p_queue->base == 0 &&
      p_queue->sem_blank == (dataqueue_retired(q)).dq_sem_blank &&
      p_queue->sem_data == q.dq_sem_data &&
      InsideCritical(sg, observed) * os_inv(sg, middle) *
      CharArray::undef_full((char *)p_queue + 6, 2) */
    /*@ Given middle */

    /* Approved trial-only bug fix; original: if (p_queue->sem_data) */
    if (p_queue->sem_data >= 0) {
        KSemaphoreDelete(p_queue->sem_data) /*@ where (dataqueue_cleanup_ic) sg = sg, before = middle */;
        /*@ Given after */
        /* Original buggy reset: p_queue->sem_data = NONE; */
        p_queue->sem_data = -1;
    }
    /*@ Assert exists final,
      p_queue == p_queue@pre && lock == saved &&
      safeExec(LastSeen(final), return(tt), X) && Crtos_GTrans(observed, final) &&
      InsideCritical(sg, observed) * os_inv(sg, final) *
      store_dataqueue(p_queue, dataqueue_retired(q)) */
    /*@ Given final */
    EnableLocalInterrupt(lock) /*@ where sg = sg, held = observed, after = final */;
}
