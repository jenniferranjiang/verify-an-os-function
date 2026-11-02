#ifndef GET_KTASK_DESCRIPTOR_OC_H
#define GET_KTASK_DESCRIPTOR_OC_H

#include "m_assign.h"
#include "monad.h"

/*@ Import Coq Require Import CRTOS_Verify.libai.GetKTaskDescriptor */
/*@ Extern Coq
      (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
      (abs_get_ktask_descriptor : program (VarGlobalState -> Prop) Z)
 */

/* 与 outside_critical/get_task_descriptor_oc.c 的公开合同一致。
 * 被调函数保留其自身的加锁/解锁；返回指针不提供锁外解引用权限。 */
KTaskDescriptorType GetKTaskDescriptor(void)
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require
      safeExec(LastSeen(before), abs_get_ktask_descriptor, X) &&
      OutsideCritical(sg, before)
    Ensure
      exists after,
        safeExec(LastSeen(after), return(__return), X) &&
        OutsideCritical(sg, after)
 */;

#endif
