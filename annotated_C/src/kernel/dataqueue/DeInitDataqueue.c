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
/* KERNEL_FREE exact macro target; entire original allocation is returned. */
void x_free(void *p)
/*@ With n
    Require p != 0 && 0 < n && CharArray::undef_full(p, n)
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
      semaphore_delete_quiescent(dq_sem_blank(q), observed) &&
      semaphore_delete_quiescent(dq_sem_data(q), observed) &&
      InsideCritical(sg, observed) * os_inv(sg, observed) * store_dataqueue(p_queue, q) */
    /*@ Given saved */
    /*@ store_dataqueue(p_queue, q)
        which implies p_queue != 0 && addr_aligned(p_queue, 4) &&
          p_queue->front == dq_front(q) && p_queue->rear == dq_rear(q) &&
          p_queue->max_len == dq_max_len(q) && p_queue->base == dq_base(q) &&
          p_queue->sem_blank == dq_sem_blank(q) && p_queue->sem_data == dq_sem_data(q) &&
          CharArray::undef_full((char *)p_queue + 6, 2) *
          ((dq_base(q) == 0 && emp) ||
           (dq_base(q) != 0 && 0 < dq_max_len(q) &&
            CharArray::undef_full(dq_base(q), dq_max_len(q) * 8))) */

    if (p_queue->base) {
        x_free(p_queue->base) /*@ where n = dq_max_len(q) * 8 */;
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
      ((0 <= dq_sem_blank(q) && semaphore_delete_ic_effect(dq_sem_blank(q), observed, middle)) ||
       (dq_sem_blank(q) < 0 && middle == observed)) &&
      semaphore_delete_quiescent(dq_sem_data(q), middle) &&
      p_queue->front == dq_front(q) && p_queue->rear == dq_rear(q) &&
      p_queue->max_len == dq_max_len(q) && p_queue->base == 0 &&
      p_queue->sem_blank == dq_sem_blank(dataqueue_retired(q)) &&
      p_queue->sem_data == dq_sem_data(q) &&
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
