#include "../include/types.h"
#include "../include/logic.h"

/* BEGIN CALLER-LOCAL CONTRACTS */
int32 _SemaphoreCreate(uint16 val)
/*@ With (mode : Z) (sg : StableGlobalState)
         (anchor before : VarGlobalState) (n irq : Z) X Y
    Require
      (mode == 0 &&
       safeExec(LastSeen(before), abs_semaphore_create(sg, val), X) &&
       OutsideCritical(sg, before) * IRQMask(irq)) ||
      (mode == 1 &&
       safeExec(ExactSeen(before), abs_semaphore_create_nested(sg, val), Y) &&
       InsideCritical(sg, anchor) * slice_OS_inv(sg, before, n) * IRQMask(1))
    Ensure
      (exists after, mode == 0 &&
       __return == -5 &&
       safeExec(LastSeen(after), return(__return), X) &&
       OutsideCritical(sg, after) * IRQMask(irq)) ||
      (exists after, mode == 0 &&
       0 <= __return && __return < 128 &&
       safeExec(LastSeen(after), return(__return), X) &&
       OutsideCritical(sg, after) * IRQMask(irq)) ||
      (exists after n_after, mode == 1 &&
       __return == -5 &&
       semaphore_create_nested_result(sg, val, before, n, __return, after, n_after) &&
       safeExec(ExactSeen(after), return(__return), Y) &&
       InsideCritical(sg, anchor) * slice_OS_inv(sg, after, n_after) * IRQMask(1)) ||
      (exists after, mode == 1 &&
       0 <= __return && __return < 128 &&
       semaphore_create_nested_result(sg, val, before, n, __return, after, nest_roundtrip(n)) &&
       safeExec(ExactSeen(after), return(__return), Y) &&
       InsideCritical(sg, anchor) *
       slice_OS_inv(sg, after, nest_roundtrip(n)) * IRQMask(1))
*/;
/* END CALLER-LOCAL CONTRACTS */

/* Source kernel/thread/semaphore.c:246. */
int32 KSemaphoreCreate(uint16 val)
/*@ With (mode : Z) (sg : StableGlobalState)
         (anchor before : VarGlobalState) (n irq : Z) X Y
    Require
      (mode == 0 &&
       safeExec(LastSeen(before), abs_semaphore_create(sg, val), X) &&
       OutsideCritical(sg, before) * IRQMask(irq)) ||
      (mode == 1 &&
       safeExec(ExactSeen(before), abs_semaphore_create_nested(sg, val), Y) &&
       InsideCritical(sg, anchor) * slice_OS_inv(sg, before, n) * IRQMask(1))
    Ensure
      (exists after, mode == 0 &&
       __return == -5 &&
       safeExec(LastSeen(after), return(__return), X) &&
       OutsideCritical(sg, after) * IRQMask(irq)) ||
      (exists after, mode == 0 &&
       0 <= __return && __return < 128 &&
       safeExec(LastSeen(after), return(__return), X) &&
       OutsideCritical(sg, after) * IRQMask(irq)) ||
      (exists after n_after, mode == 1 &&
       __return == -5 &&
       semaphore_create_nested_result(sg, val, before, n, __return, after, n_after) &&
       safeExec(ExactSeen(after), return(__return), Y) &&
       InsideCritical(sg, anchor) * slice_OS_inv(sg, after, n_after) * IRQMask(1)) ||
      (exists after, mode == 1 &&
       0 <= __return && __return < 128 &&
       semaphore_create_nested_result(sg, val, before, n, __return, after, nest_roundtrip(n)) &&
       safeExec(ExactSeen(after), return(__return), Y) &&
       InsideCritical(sg, anchor) *
       slice_OS_inv(sg, after, nest_roundtrip(n)) * IRQMask(1))
*/
{
    ; /* source-local empty macro */

    return _SemaphoreCreate(val)
        /*@ where mode = mode, sg = sg, anchor = anchor, before = before,
                  n = n, irq = irq, X = X, Y = Y */;
}
