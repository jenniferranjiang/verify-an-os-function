#ifndef KTASK_STATUS_OC_H
#define KTASK_STATUS_OC_H

#include "m_assign.h"
#include "m_stdbool.h"
#include "monad.h"

/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskStatusOC */
/*@ Extern Coq
      (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
      (task_atomic_cmd : {A} -> program VarGlobalState A -> program (VarGlobalState -> Prop) A)
      (ktask_judge_status_resultOC : TaskStatus -> TaskStatus -> Z -> Prop)
      (ktask_judge_status_lockedOC : Z -> TaskStatus -> program VarGlobalState Z)
      (abs_ktask_judge_statusOC :
        StableGlobalState -> Z -> TaskStatus -> program (VarGlobalState -> Prop) Z)
 */

/* OC 调用自行加锁；返回本次观察的 BOOL，不授予任务跨解锁存活或状态稳定性。 */

BOOL JudgeKTaskStatIsInit(KTaskDescriptorType task)
/*@ judge_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require
      safeExec(LastSeen(before), abs_ktask_judge_statusOC(sg, task, TSK_INIT), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      (__return == 0 || __return == 1) &&
      safeExec(LastSeen(after), return(__return), X) &&
      OutsideCritical(sg, after)
 */;

BOOL JudgeKTaskStatIsReady(KTaskDescriptorType task)
/*@ judge_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require
      safeExec(LastSeen(before), abs_ktask_judge_statusOC(sg, task, TSK_READY), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      (__return == 0 || __return == 1) &&
      safeExec(LastSeen(after), return(__return), X) &&
      OutsideCritical(sg, after)
 */;

BOOL JudgeKTaskStatIsSuspend(KTaskDescriptorType task)
/*@ judge_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require
      safeExec(LastSeen(before), abs_ktask_judge_statusOC(sg, task, TSK_SUSPEND), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      (__return == 0 || __return == 1) &&
      safeExec(LastSeen(after), return(__return), X) &&
      OutsideCritical(sg, after)
 */;

BOOL JudgeKTaskStatIsRunning(KTaskDescriptorType task)
/*@ judge_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require
      safeExec(LastSeen(before), abs_ktask_judge_statusOC(sg, task, TSK_RUNNING), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      (__return == 0 || __return == 1) &&
      safeExec(LastSeen(after), return(__return), X) &&
      OutsideCritical(sg, after)
 */;

BOOL JudgeKTaskStatIsClose(KTaskDescriptorType task)
/*@ judge_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require
      safeExec(LastSeen(before), abs_ktask_judge_statusOC(sg, task, TSK_CLOSE), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      (__return == 0 || __return == 1) &&
      safeExec(LastSeen(after), return(__return), X) &&
      OutsideCritical(sg, after)
 */;

#endif
