#include "monad.h"
#include "m_assign.h"

/*@ Import Coq Require Import CRTOS_Verify.libai.GetKTaskDescriptor */

/*@ Extern Coq (VarAssignAbs :: *) */
/*@ Extern Coq
      (LastSeen :
        VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
      (abs_get_ktask_descriptor :
        program (VarGlobalState -> Prop) Z)
      (get_ktask_descriptor_frame :
        StableGlobalState -> VarGlobalState -> Assertion)
 */

/*@ include strategies "critical_views.strategies" */

/**
 * This function will get a task descriptor
 *
 * safeExec carries the abstract read and its continuation across this call;
 * lock-time states and transition facts remain internal to the proof.
 * Inside-critical calls use kernel/thread/get_ktask_descriptor.c.
 */
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
 */
{
    x_base lock = 0;
    KTaskDescriptorType task = NONE;
   
    lock = CriticalAreaLock()
        /*@ where (ordinary) sg = sg, st1 = before */;
    /*@ Given st_lock */

    if(Assign.os_running_task != NONE){
        task = Assign.os_running_task;
    }

    /*@ task == st_lock.os_assign.assignRunningTask &&
        Crtos_RTrans(before, st_lock) &&
        safeExec(LastSeen(before), abs_get_ktask_descriptor, X) &&
        InsideCritical(sg, st_lock) *
        os_inv(sg, st_lock)
        which implies
        safeExec(LastSeen(st_lock), return(task), X) &&
        Crtos_GTrans(st_lock, st_lock) &&
        InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
     */
    CriticalAreaUnLock(lock)
        /*@ where (stable) sg = sg, st1 = st_lock, st2 = st_lock */;
    return task;
}
