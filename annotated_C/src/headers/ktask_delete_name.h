#ifndef CRTOS_KTASK_DELETE_NAME_H
#define CRTOS_KTASK_DELETE_NAME_H
#include "m_ktask.h"
#include "monad.h"
/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskDeleteName */
/*@ Extern Coq
  (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
  (task_atomic_cmd : {A} -> program VarGlobalState A -> program (VarGlobalState -> Prop) A)
  (abs_ktask_delete_name : StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
  (ktask_delete_name_locked : Z -> program VarGlobalState Z)
  (ktask_delete_name_result : list Z -> Z -> Prop)
 */
static inline x_err_t __JudgeKTaskIsIdleOrZombierecycle(KTaskDescriptorType task)
/*@ delete_name_oc
    With LitMap (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_ktask_delete_name(sg, task), X) &&
      OutsideCritical(sg, before) * GlobalStrings(LitMap)
    Ensure exists after,
      safeExec(LastSeen(after), return(__return), X) &&
      (__return == 0 || __return == 1) &&
      OutsideCritical(sg, after) * GlobalStrings(LitMap)
 */;
#endif
