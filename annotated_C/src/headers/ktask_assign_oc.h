#ifndef KTASK_ASSIGN_OC_H
#define KTASK_ASSIGN_OC_H

#include "m_ktask.h"
#include "monad.h"

/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskOsAssign */
/*@ Import Coq Require Import CRTOS_Verify.libai.TaskSafeExec */
/*@ Extern Coq
      (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
      (abs_ktask_assign : program (VarGlobalState -> Prop) unit)
 */

/*
 * Stage-1 model requested by the user: an empty critical section represents
 * the scheduling/yield boundary. No extra caller-owned data is required;
 * OutsideCritical remains necessary. This is not a proof of DO_KTASK_ASSIGN.
 */
void KTASK_ASSIGN()
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require
      safeExec(LastSeen(before), abs_ktask_assign, X) &&
      OutsideCritical(sg, before)
    Ensure
      exists after,
        safeExec(LastSeen(after), return(tt), X) &&
        OutsideCritical(sg, after)
 */;

#endif
