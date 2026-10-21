#include "m_assign.h"

/*@ Import Coq Require Import CRTOS_Verify.lib.CrtosRules */

/**
 * This function will get a task descriptor
 *
 * Inside-critical verification slice: only the current-task pointer slot is
 * borrowed. The caller's critical-section resources remain a frame.
 */
KTaskDescriptorType GetKTaskDescriptor(void)
/*@ inside_critical
    With (running_task : Z)
    Require store_ptr(&(Assign.os_running_task), running_task)
    Ensure __return == running_task &&
           store_ptr(&(Assign.os_running_task), running_task)
*/
{
    x_base lock = 0;
    KTaskDescriptorType task = NONE;
   
    // lock = CriticalAreaLock();

    if(Assign.os_running_task != NONE){
        task = Assign.os_running_task;
    }    
    // CriticalAreaUnLock(lock);
    return task;
}
