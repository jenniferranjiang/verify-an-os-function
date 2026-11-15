#include "dataqueue_logic.h"

/* Legacy NULL_PARAM_CHECK API: default source-processing rule; source
 * canonical annotated_C/src/kernel/common/null_paramter_check.c. */
inline void NULL_PARAM_CHECK_1(void *p)
/*@ Require emp Ensure p != 0 */;

/* Reused IRQ API: VRTOS kernel/common/kdebug_not_in_interrupt.c,
 * SHA256 523889774adaaf1c2faa3852c7366e9d372ac1ea5b52857d3b8685ca1ca04afd.
 * CRTOS same shared resource protocol; hardware register implementation is an
 * existing API assumption, not proved here. */
x_base DisableLocalInterrupt(void)
/*@ ordinary
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require OutsideCritical(sg, before)
    Ensure exists observed,
      Crtos_RTrans(before, observed) &&
      InsideCritical(sg, observed) * os_inv(sg, observed)
 */;

void EnableLocalInterrupt(x_base level)
/*@ restore
    With (sg : StableGlobalState) (observed after : VarGlobalState)
    Require Crtos_GTrans(observed, after) &&
      InsideCritical(sg, observed) * os_inv(sg, after)
    Ensure OutsideCritical(sg, after)
 */;

/* Trusted KERNEL_FREE/x_free allocator model. Caller provides the original
 * allocation base and all size bytes; this generic API also permits size=0. */
void x_free(void *ptr)
/*@ With (size : Z)
    Require ptr != 0 && 0 <= size && CharArray::undef_full(ptr, size)
    Ensure emp
 */;

void KSemaphoreDelete(int32 id)
/*@ dataqueue_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require dq_sem_delete_empty(id, before) && os_inv(sg, before)
    Ensure exists after,
      dq_semaphore_delete_effect(id, before, after) && os_inv(sg, after)
 */;

void DeInitDataqueue(DataQueueType *p_queue)
/*@ init_rollback
    With (sg : StableGlobalState) (before : VarGlobalState)
         (q : DataqueueAbs) (slots : list(option DataElemAbs)) X
    Require
      safeExec(LastSeen(before), abs_dataqueue_deinit(sg, q), X) &&
      OutsideCritical(sg, before) * dataqueue_storage(p_queue, q, slots)
    Ensure exists after,
      safeExec(LastSeen(after), return(dq_cleared(q)), X) &&
      OutsideCritical(sg, after) *
      dataqueue_storage(p_queue, dq_cleared(q), nil)
 */
{
    x_base lock = 0;

    NULL_PARAM_CHECK_1(p_queue);

    /* KPrintf debug output omitted by source-processing rule. */

    lock = DisableLocalInterrupt() /*@ where (ordinary) sg = sg, before = before */;

    if (p_queue->base) {
        x_free(p_queue->base) /*@ where size = dq_max_len(q) * 8 */;
        p_queue->base = NONE;
    }

    /* Original buggy check: if (p_queue->sem_blank) */
    if (p_queue->sem_blank >= 0) {
        KSemaphoreDelete(p_queue->sem_blank) /*@ where (dataqueue_ic) sg = sg */;
        /* Original buggy reset: p_queue->sem_blank = NONE; */
        p_queue->sem_blank = -1;
    }

    /* Original buggy check: if (p_queue->sem_data) */
    if (p_queue->sem_data >= 0) {
        KSemaphoreDelete(p_queue->sem_data) /*@ where (dataqueue_ic) sg = sg */;
        /* Original buggy reset: p_queue->sem_data = NONE; */
        p_queue->sem_data = -1;
    }
    EnableLocalInterrupt(lock) /*@ where (restore) sg = sg */;
}
