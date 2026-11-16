/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/data_queue.c; SHA-256 a8b12c43c3f2061df08320f50daaabda7ada033e40670c2d37ea2d8ef774f601.
 * User-approved verification-copy defect repair; formal design draft; no VC generated.
 */
#include "dataqueue.h"

/* Old NULL_PARAM_CHECK normal-return model, source-processing rule. */
void NULL_PARAM_CHECK_1(void *p)
/*@ Require emp Ensure p != 0 */;
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
         (q : DataqueueObject) (refs : DataqueueSemRefs) X
    Require dq_addr(q) == p_queue &&
      safeExec(LastSeen(before), abs_deinit_dataqueue(sg, q, refs), X) &&
      dataqueue_owned(q) * OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) &&
      dataqueue_owned(dataqueue_retired(q)) * OutsideCritical(sg, after)
*/
{
    x_base lock = 0;

    NULL_PARAM_CHECK_1(p_queue); /* old NULL_PARAM_CHECK normal-return model */

    /* KPrintf("DeInitDataqueue\n"); trusted debug removal */

    lock = DisableLocalInterrupt();

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
    EnableLocalInterrupt(lock);
}
