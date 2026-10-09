#include "../los_sched.h"

//----------------------------- include strategy -----------------------------//
/*@ include strategies "los_list.strategies" */
/*@ include strategies "los_sched.strategies" */


//----------------------------- some spec -----------------------------//
STATIC INLINE VOID OsSchedPriQueueDelete(LOS_DL_LIST *priqueueItem, UINT32 priority)
/*@ With (task_id: Z) (sg: StableGlobVars) (priQueueList: list (list Z))
    Require 
            prio_in_range(priority) &&
            in_priQueueList(task_id, priority, priQueueList) &&
            store_tid(sg, priqueueItem, task_id) *
            g_priQueueList_store(sg, priQueueList)
    Ensure
            occupy_dll_node(priqueueItem) *
            g_priQueueList_store(sg, OsSchedPriQueueDelete_update_priQueueList(priority, priQueueList, task_id))
*/
;

STATIC INLINE VOID OsSchedPriQueueEnHead(LOS_DL_LIST *priqueueItem, UINT32 priority)
/*@ With (task_id: Z) (sg: StableGlobVars) (priQueueList: list (list Z))
    Require 
        exists pu un,
            prio_in_range(priority) &&
            store_tid(sg, priqueueItem, task_id) &&
            data_at(field_addr(priqueueItem, LOS_DL_LIST, pstPrev), struct LOS_DL_LIST *, pu) *
            data_at(field_addr(priqueueItem, LOS_DL_LIST, pstNext), struct LOS_DL_LIST *, un) *
            g_priQueueList_store(sg, priQueueList)
    Ensure
            g_priQueueList_store(sg, OsSchedPriQueueEnHead_update_priQueueList(priority, priQueueList, task_id))
*/
;

STATIC INLINE VOID OsSchedPriQueueEnTail(LOS_DL_LIST *priqueueItem, UINT32 priority)
/*@ With (task_id: Z) (sg: StableGlobVars) (priQueueList: list (list Z))
    Require 
        exists pu un,
            prio_in_range(priority) &&
            store_tid(sg, priqueueItem, task_id) &&
            data_at(field_addr(priqueueItem, LOS_DL_LIST, pstPrev), struct LOS_DL_LIST *, pu) *
            data_at(field_addr(priqueueItem, LOS_DL_LIST, pstNext), struct LOS_DL_LIST *, un) *
            g_priQueueList_store(sg, priQueueList)
    Ensure
            g_priQueueList_store(sg, OsSchedPriQueueEnTail_update_priQueueList(priority, priQueueList, task_id))
*/
;

//----------------------------- C program with annotations -----------------------------//
VOID OsSchedTaskEnQueue(LosTaskCB *taskCB) 
/*@
With
  (sg : StableGlobVars) (st : TcbGlobalState)
  (schedTimeSlice schedTimeSliceMin : Z)
  (task_id : Z) (tcb : TaskAbstractState)
  (priQueueList : list (list Z))
Require
  g_idleTaskID == sg.idleTaskID &&
  g_schedTimeSlice == schedTimeSlice &&
  g_schedTimeSliceMin == schedTimeSliceMin &&

  st.usedTask(task_id) == Some(tcb) &&
  task_enqueue_status(tcb) &&
  prio_in_range(tcb.tPrio) &&
  not_in_priQueueList(task_id, priQueueList) &&
  store_tid(sg, &taskCB->pendList, task_id) *

  used_complete_task(sg, taskCB, task_id, tcb) *
  g_priQueueList_inv(sg, st, priQueueList)
Ensure
  exists new_tcb new_st new_priQueueList,
  new_tcb == OsSchedTaskEnQueue_update_tcb(sg, task_id, tcb, schedTimeSliceMin, schedTimeSlice) &&
  new_st == update_usedTask(st, map_update(Z_eq_dec, st.usedTask, task_id, new_tcb)) &&
  new_priQueueList == OsSchedTaskEnQueue_update_priQueueList(sg, priQueueList, task_id, tcb, schedTimeSliceMin) &&

  g_idleTaskID == sg.idleTaskID &&
  g_schedTimeSlice == schedTimeSlice &&
  g_schedTimeSliceMin == schedTimeSliceMin &&

  used_complete_task(sg, taskCB, task_id, new_tcb) *
  g_priQueueList_inv(sg, new_st, new_priQueueList)
*/
{
    // LOS_ASSERT(!(taskCB->taskStatus & OS_TASK_STATUS_READY));

    /*@ do unfold_used_complete_task */
    /*@ tcb.status >= 0 &&
        tcb.status <= 65535 by local*/

    if (taskCB->taskID != g_idleTaskID) { 

        /*@ task_enqueue_status(tcb) && set_pendList(sg, taskCB, tcb.status, task_id) 
            which implies
            exists pu un,
            data_at(field_addr(&taskCB->pendList, LOS_DL_LIST, pstPrev), struct LOS_DL_LIST *, pu) *
            data_at(field_addr(&taskCB->pendList, LOS_DL_LIST, pstNext), struct LOS_DL_LIST *, un)
        */

        /*@ do unfold_g_priQueueList_inv */
        
        /*@ Zlength(priQueueList) == 32 by local */

        if (taskCB->timeSlice > g_schedTimeSliceMin) {
            OsSchedPriQueueEnHead(&taskCB->pendList, (UINT32)taskCB->priority)/*@ where task_id = task_id, sg = sg, priQueueList = priQueueList */;
        } else {
            taskCB->timeSlice = g_schedTimeSlice;
            OsSchedPriQueueEnTail(&taskCB->pendList, (UINT32)taskCB->priority)/*@ where task_id = task_id, sg = sg, priQueueList = priQueueList */;
        }
        // OsHookCall(LOS_HOOK_TYPE_MOVEDTASKTOREADYSTATE, taskCB);
    }

    taskCB->taskStatus &= ~(OS_TASK_STATUS_PEND | OS_TASK_STATUS_SUSPEND |
                            OS_TASK_STATUS_DELAY | OS_TASK_STATUS_PEND_TIME);

    taskCB->taskStatus |= OS_TASK_STATUS_READY;
}


VOID OsSchedTaskDeQueue(LosTaskCB *taskCB)
/*@
With
  (sg : StableGlobVars) (st : TcbGlobalState)
  (task_id : Z) (tcb : TaskAbstractState)
  (priQueueList : list (list Z))
Require
  g_idleTaskID == sg.idleTaskID &&

  st.usedTask(task_id) == Some(tcb) &&
  task_dequeue_status(tcb) &&
  prio_in_range(tcb.tPrio) &&
  in_priQueueList(task_id, tcb.tPrio, priQueueList) &&
  store_tid(sg, &taskCB->pendList, task_id) &&
  
  used_complete_task(sg, taskCB, task_id, tcb) &&
  g_priQueueList_inv(sg, st, priQueueList)
Ensure
  exists new_st new_tcb new_priQueueList,
  new_tcb == OsSchedTaskDeQueue_update_tcb(tcb) &&
  new_st == update_usedTask(st, map_update(Z_eq_dec, st.usedTask, task_id, new_tcb)) &&
  new_priQueueList == OsSchedTaskDeQueue_update_priQueueList(sg, priQueueList, task_id, tcb) &&

  g_idleTaskID == sg.idleTaskID &&

  used_complete_task(sg, taskCB, task_id, new_tcb) &&
  g_priQueueList_inv(sg, new_st, new_priQueueList)
*/
{
    // if (taskCB->taskStatus & OS_TASK_STATUS_READY) {

    /*@ do unfold_used_complete_task */
    /*@ tcb.status >= 0 &&
        tcb.status <= 65535 by local*/

    if (taskCB->taskID != g_idleTaskID) {

        /*@ do unfold_g_priQueueList_inv */
        
        /*@ Zlength(priQueueList) == 32 by local */

        OsSchedPriQueueDelete(&taskCB->pendList, (UINT32)taskCB->priority)/*@ where task_id = task_id, sg = sg, priQueueList = priQueueList */;
    }

    taskCB->taskStatus &= ~OS_TASK_STATUS_READY;

    // } 
} 

