#ifndef GET_TASK_WITH_IDNODE_OC_H
#define GET_TASK_WITH_IDNODE_OC_H

#include "m_ktask.h"
#include "monad.h"

/*@ Import Coq Require Import CRTOS_Verify.libai.GetTaskWithIdnode */
/*@ Import Coq Require Import CRTOS_Verify.libai.TaskSafeExec */
/*@ Extern Coq
      (KNONE : Z)
      (None : {A} -> option A)
      (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
      (abs_get_task_with_idnode :
        StableGlobalState -> Z -> program (VarGlobalState -> Prop) (option Z))
 */

/* 与 outside_critical/get_task_with_idnode_oc.c 的公开合同一致。
 * 查询保留自身锁边界；指针结果不提供任务所有权或跨解锁存活保证。 */
inline struct TaskDescriptor *GetTaskWithIdnodeInfo(int32 id)
/*@ With (sg : StableGlobalState) (before : VarGlobalState) X
    Require id < 65536 &&
      safeExec(LastSeen(before), abs_get_task_with_idnode(sg, id), X) &&
      OutsideCritical(sg, before)
    Ensure
      (exists after,
        __return == KNONE &&
        safeExec(LastSeen(after), return(None), X) &&
        OutsideCritical(sg, after))
      ||
      (exists after,
        safeExec(LastSeen(after), return(Some(__return)), X) &&
        OutsideCritical(sg, after))
 */;

#endif
