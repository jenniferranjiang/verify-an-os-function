#ifndef GET_ISR_COUNTER_OC_H
#define GET_ISR_COUNTER_OC_H

#include "m_isr.h"
#include "m_ktask.h"
#include "monad.h"

/*@ Import Coq Require Import CRTOS_Verify.libai.GetIsrCounterOC */
/*@ Extern Coq
      (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
      (abs_get_isr_counterOC : program (VarGlobalState -> Prop) Z)
 */

/* 已验证的 OC 合同：实现自行加锁，返回本次观察值。
 * 不要求入口处 ISR 计数为零；不沿用 IC 的裸字段所有权合同。 */
uint16 GetIsrCounter(void)
/*@ get_isr_counter_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require
      safeExec(LastSeen(before), abs_get_isr_counterOC, X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(__return), X) &&
      OutsideCritical(sg, after)
 */;

#endif
