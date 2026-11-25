#include "task.h"
#include "OsNewTaskInit.h"
#include "LOS_TaskCreateOnly.h"
#include "LOS_TaskCreate.h"

/*@ include strategies "task_safeexec.strategies" */
/*@ include strategies "task_common.strategies" */
/*@ include strategies "task_task.strategies"*/
/*@ include strategies "LOS_TaskCreateOnly.strategies" */
/*@ include strategies "LOS_TaskCreate.strategies" */


void enter_critical()
/*@ With (sg: StableGlobVars) (l : Los_Verify_State)
    Require OutsideCritical(sg, l)
    Ensure exists sg0 l0,
             RTrans_C(sg, l, sg0, l0) &&
             InsideCritical(sg0, l0) * task_inv(sg0, l0.TskState)
*/
;

void exit_critical()
/*@ With (sg1: StableGlobVars) (l1: Los_Verify_State) (sg2: StableGlobVars) (l2: Los_Verify_State) (st2 : TcbGlobalState)
    Require GTrans_C(sg1, l1, sg2, l2) && l2 == replace_tskS(st2, l1) &&
            InsideCritical(sg1, l1) * task_inv(sg2, st2)
    Ensure  OutsideCritical(sg2, l2)
*/
;


UINT32 LOS_TaskCreateOnly(UINT32 *taskID, TSK_INIT_PARAM_S *taskInitParam)    // 临界区内版本
/*@ With (sg: StableGlobVars) (st : TcbGlobalState) (param : TaskInitParamState)
    Require g_taskCBArray_C == sg.g_taskCBArray &&
            task_inv(sg, st)  * store_taskInitParam(taskInitParam, param) * undef_data_at(taskID)
    Ensure (exists param1, __return != 0 && 
            g_taskCBArray_C == sg.g_taskCBArray && task_inv(sg, st) &&
            store_taskInitParam(taskInitParam, param1) * undef_data_at(taskID))
          ||
           (exists param1 tid remain tskabs, __return == 0 && g_taskCBArray_C == sg.g_taskCBArray && 
            st.freeTask == cons(tid, remain) &&  is_suspend(tskabs) && tid != sg.idleTaskID &&
            task_inv(sg, task_create_only(st, tid, tskabs, remain)) * 
            store_taskInitParam_without_stack(taskInitParam, param1) * data_at(taskID, tid) )
*/
;

LosTaskCB * OS_TCB_FROM_TID(UINT32 taskID)
/*@   Require g_taskCBArray_C == g_taskCBArray_C
      Ensure __return == g_taskCBArray_C@pre + taskID * sizeof(struct LosTaskCB) 
      && g_taskCBArray_C ==  g_taskCBArray_C@pre
   */ 
;


void OsSchedTaskEnQueue(LosTaskCB *taskCB) 
/*@
With
  (sg : StableGlobVars) (st : TcbGlobalState)
  (tid : Z) (tskabs : TaskAbstractState)
  (schedTimeSlice schedTimeSliceMin : Z)
Require
  g_schedTimeSlice == schedTimeSlice &&
  g_schedTimeSliceMin == schedTimeSliceMin &&
  g_taskCBArray_C == sg.g_taskCBArray &&
  taskCB == g_taskCBArray_C + tid * sizeof(struct LosTaskCB) &&
  tid != sg.idleTaskID &&
  (st.usedTask)(tid) == Some(tskabs) &&
  task_enqueue_status(tskabs) &&
  tskabs.tPrio >=0 && tskabs.tPrio < 32 &&
  task_inv(sg, st)
Ensure
  exists new_tcb new_st,
  is_ready(new_tcb) &&
  new_st == update_usedTask(st, update_map(st.usedTask, tid, new_tcb)) &&
  g_schedTimeSlice == schedTimeSlice &&
  g_schedTimeSliceMin == schedTimeSliceMin &&
  g_taskCBArray_C == sg.g_taskCBArray &&
  task_inv(sg, new_st)
*/
;


UINT32 LOS_TaskCreate(UINT32 *taskID, TSK_INIT_PARAM_S *taskInitParam)
/*@ With (sg: StableGlobVars) (l1 : Los_Verify_State) (param : TaskInitParamState) X  (schedTimeSlice schedTimeSliceMin : Z)
    Require safeExec(LastSeen(l1), abs_taskCreate(param), X) &&
            g_taskCBArray_C == sg.g_taskCBArray && 
            g_schedTimeSlice == schedTimeSlice &&
            g_schedTimeSliceMin == schedTimeSliceMin &&
            OutsideCritical(sg, l1)  * store_taskInitParam(taskInitParam, param) * undef_data_at(taskID)
    Ensure (exists l2 param1, __return != 0 && safeExec(LastSeen(l2), return(false), X) && 
            g_schedTimeSlice == schedTimeSlice &&
            g_schedTimeSliceMin == schedTimeSliceMin &&
            g_taskCBArray_C == sg.g_taskCBArray &&  OutsideCritical(sg,l2) * 
            store_taskInitParam(taskInitParam, param1) * undef_data_at(taskID))
          ||
           (exists l2 v param1, __return == 0 && safeExec(LastSeen(l2), return(true), X) && 
            g_schedTimeSlice == schedTimeSlice &&
            g_schedTimeSliceMin == schedTimeSliceMin &&
            g_taskCBArray_C == sg.g_taskCBArray &&  OutsideCritical(sg,l2) * 
            store_taskInitParam_without_stack(taskInitParam, param1) * data_at(taskID, v) )
*/
{
    UINT32 retVal;
    UINT32 intSave;
    LosTaskCB *taskCB = 0;

    enter_critical();

    retVal = LOS_TaskCreateOnly(taskID, taskInitParam);

    if (retVal != (UINT32) 0) {
        exit_critical();
        return retVal;
    }

    taskCB = OS_TCB_FROM_TID(*taskID);

    OsSchedTaskEnQueue(taskCB) /*@ where tid = *taskID */;
    
    exit_critical();

    // LOS_Schedule();

    return (UINT32) 0;
}
