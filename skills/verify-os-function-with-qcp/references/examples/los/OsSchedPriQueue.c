#include "../los_sched.h"

//----------------------------- include strategy -----------------------------//
/*@ include strategies "los_list.strategies" */
/*@ include strategies "los_sched.strategies" */  


//----------------------------- some spec -----------------------------//
LITE_OS_SEC_ALW_INLINE STATIC_INLINE BOOL LOS_ListEmpty(LOS_DL_LIST *node)
/*@
    With (l: list Z) (sg: StableGlobVars)
    Require store_pend_list_dll(sg, node, l)
    Ensure  store_pend_list_dll(sg, node, l) && 
            __return == is_nil(l) 
*/
;

LITE_OS_SEC_ALW_INLINE STATIC INLINE VOID LOS_ListAdd(LOS_DL_LIST *list, LOS_DL_LIST *node)
/*@
    With (l: list Z) (a: Z) (sg:StableGlobVars)
    Require exists pu un,
            data_at(field_addr(node, LOS_DL_LIST, pstPrev), struct LOS_DL_LIST *, pu) *
            data_at(field_addr(node, LOS_DL_LIST, pstNext), struct LOS_DL_LIST *, un) *
            store_tid(sg, node, a) *
            store_pend_list_dll(sg, list, l)
    Ensure  store_pend_list_dll(sg, list, cons(a, l))
*/
;

static inline void LOS_ListTailInsert(LOS_DL_LIST *list, LOS_DL_LIST *node)
/*@ 
    With (l: list Z) (a: Z) (sg:StableGlobVars)
    Require exists pu un,
            data_at(field_addr(node, LOS_DL_LIST, pstPrev), struct LOS_DL_LIST *, pu) *
            data_at(field_addr(node, LOS_DL_LIST, pstNext), struct LOS_DL_LIST *, un) *
            store_tid(sg, node, a) *
            store_pend_list_dll(sg, list, l)
    Ensure
            store_pend_list_dll(sg, list, app(l, cons(a, nil)))
*/
;

static inline void LOS_ListDelete(LOS_DL_LIST *node)
/*@ 
    With (l : list Z) (a : Z) (sg : StableGlobVars) (p : addr)  
    Require
            In(a, l) &&
            store_tid(sg, node, a) *
            store_pend_list_dll(sg, p, l) 
    Ensure
            undef_data_at(&node->pstNext) *
            undef_data_at(&node->pstPrev) *
            store_pend_list_dll(sg, p, remove(Z_eq_dec, a, l))
*/
;


//----------------------------- C program with annotations -----------------------------//
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
{
    /*@
        prio_in_range(priority@pre) &&
        g_priQueueList_store(sg, priQueueList)
      which implies
        exists queueBitmap,
        prio_in_range(priority@pre) &&
        g_priQueueList_prop(priQueueList, queueBitmap) &&
        data_at(&g_queueBitmap, queueBitmap) *
        store_pend_list_dll(sg, &g_priQueueList[priority@pre], Znth(priority@pre, priQueueList, nil)) *
        store_array_missing_i_rec(g_priQueueList_element_store(sg), &g_priQueueList, priority@pre, 0, OS_PRIORITY_QUEUE_NUM, priQueueList)
    */ 
    if (LOS_ListEmpty(&g_priQueueList[priority])/*@ where l = Znth(priority, priQueueList, nil), sg = sg */) {
        g_queueBitmap |= PRIQUEUE_PRIOR0_BIT >> priority;
    }

    LOS_ListAdd(&g_priQueueList[priority], priqueueItem)/*@ where l = Znth(priority, priQueueList, nil), a = task_id, sg = sg */;  
}  



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
{
    /*@
        prio_in_range(priority@pre) &&
        g_priQueueList_store(sg, priQueueList)
      which implies
        exists queueBitmap,
        g_priQueueList_prop(priQueueList, queueBitmap) &&
        data_at(&g_queueBitmap, queueBitmap) *
        store_pend_list_dll(sg, &g_priQueueList[priority@pre], Znth(priority@pre, priQueueList, nil)) *
        store_array_missing_i_rec(g_priQueueList_element_store(sg), &g_priQueueList, priority@pre, 0, OS_PRIORITY_QUEUE_NUM, priQueueList)
    */ 
    if (LOS_ListEmpty(&g_priQueueList[priority])/*@ where l = Znth(priority, priQueueList, nil), sg = sg */) {
        g_queueBitmap |= PRIQUEUE_PRIOR0_BIT >> priority;
    }

    LOS_ListTailInsert(&g_priQueueList[priority], priqueueItem)/*@ where l = Znth(priority, priQueueList, nil), a = task_id, sg = sg */;
}



STATIC INLINE VOID OsSchedPriQueueDelete(LOS_DL_LIST *priqueueItem, UINT32 priority)
/*@ With (task_id: Z) (sg: StableGlobVars) (priQueueList: list (list Z))
    Require 
            prio_in_range(priority) &&
            In(task_id, Znth(priority, priQueueList, nil)) &&
            store_tid(sg, priqueueItem, task_id) *
            g_priQueueList_store(sg, priQueueList)
    Ensure
            undef_data_at(&priqueueItem->pstPrev) *
            undef_data_at(&priqueueItem->pstNext) *
            g_priQueueList_store(sg, OsSchedPriQueueDelete_update_priQueueList(priority, priQueueList, task_id))
*/
{
    /*@
        prio_in_range(priority@pre) &&
        g_priQueueList_store(sg, priQueueList)
      which implies
        exists queueBitmap,
        g_priQueueList_prop(priQueueList, queueBitmap) &&
        data_at(&g_queueBitmap, queueBitmap) *
        store_pend_list_dll(sg, &g_priQueueList[priority@pre], Znth(priority@pre, priQueueList, nil)) *
        store_array_missing_i_rec(g_priQueueList_element_store(sg), &g_priQueueList, priority@pre, 0, OS_PRIORITY_QUEUE_NUM, priQueueList)
    */ 
    LOS_ListDelete(priqueueItem)/*@ where l = Znth(priority, priQueueList, nil), a = task_id, sg = sg, p = &g_priQueueList[priority] */;
    if (LOS_ListEmpty(&g_priQueueList[priority])/*@ where l = remove(Z_eq_dec, task_id, Znth(priority, priQueueList, nil)), sg = sg */) {
        g_queueBitmap &= ~(PRIQUEUE_PRIOR0_BIT >> priority);
    }
}
