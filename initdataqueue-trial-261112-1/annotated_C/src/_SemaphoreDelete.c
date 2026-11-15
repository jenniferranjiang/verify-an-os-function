#include "dataqueue_semaphore_delete_logic.h"
/* Active body source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/semaphore.c
 * SHA256 d5b41c3bde69e0416431d2425c61e35453778ae4b1569747f2c2258f3dfe16ec; done-table dispatch resolved from its static initializer. */

/* Source canonical (original OC contract/body, unchanged there):
 * ../../../annotated_C/src/kernel/semaphore/_SemaphoreDelete.c
 * SHA256 953c7644c4fdacdafacdb505f86b201eb0f6b5347cbfad50d9815353f824c32a
 * This file's only active contract is the NEW dataqueue_ic design.
 * OC provenance does not establish this IC contract or C implementation proof.
 * Nested locks are removed only for execution under the caller's critical/IRQ
 * ownership, as authorized by the source-processing rule. */

/* Imported API from annotated_C/src/kernel/semaphore/_SemaphoreDelete.c; same source revision above. */
struct IdNode *IdGetObj(struct IdManager *manager, uint16 id)
/*@ With (sm: StableIdmanager) (m: VarIdmanager)
    Require 0 <= id && id < 65536 && store_idmanager(sm, m, manager)
    Ensure (manager == 0 &&
            __return == 0 &&
            store_idmanager(sm, m, manager))
           ||
           (manager != 0 &&
            __return == 0 &&
            idmanager_query(m, id) == false &&
            store_idmanager(sm, m, manager))
           ||
           (manager != 0 &&
            __return != 0 &&
            idmanager_query(m, id) == true &&
            store_idmanager_found(sm, m, manager, __return, id))
*/
;

/* Imported API from annotated_C/src/kernel/semaphore/_SemaphoreDelete.c; same source revision above. */
struct Semaphore *CONTAINER_OF_SEMAPHORE_ID(struct IdNode *id_ptr)
/*@ With (sem_ptr : addr)
    Require id_ptr == field_addr(sem_ptr, struct Semaphore, id) && emp
    Ensure __return == sem_ptr && id_ptr == &(__return->id) && emp
 */;

/* Imported API from annotated_C/src/kernel/semaphore/_SemaphoreDelete.c; same source revision above. */
int IsDoubleLinkListEmpty(const DoubleLinklistType *linklist)
/*@ dll
    With {A} (storeA : Z -> A -> Assertion)
             (nodes : list(DL_Node A))
    Require
      store_dll(storeA, linklist, nodes)
    Ensure
      ((__return == 1 && nodes == nil) ||
       (__return == 0 && nodes != nil)) &&
      store_dll(storeA, linklist, nodes)
 */
;

/* Imported API from annotated_C/src/kernel/semaphore/_SemaphoreDelete.c; same source revision above. */
x_err_t LinklistResumeAll(DoubleLinklistType *list)
/*@ semaphore_waiters
    With (sg : StableGlobalState) (before : CoreVarGlobalState)
         (sem : addr) (waiting : list addr)
    Require list == semaphore_pending_head(sem) &&
      semaphore_pending_nodes(sem, before, map(sched_link_node, waiting)) &&
      core_os_inv(sg, before)
    Ensure __return == 0 && exists after,
      semaphore_resume_all_effect(sem, waiting, before, after) &&
      semaphore_pending_nodes(sem, after, nil) && core_os_inv(sg, after)
 */;

/* Imported API from annotated_C/src/kernel/semaphore/_SemaphoreDelete.c; same source revision above. */
void IdRemoveObj(struct IdManager *manager, uint16 id)
/*@ low_level_spec
    With (sm: StableIdmanager) (m: VarIdmanager)
    Require manager != 0 &&
            0 <= id && id < 65536 &&
            store_idmanager(sm, m, manager)
    Ensure (idmanager_query(m, id) == false &&
            store_idmanager(sm, m, manager))
           ||
           (exists idnode,
              idmanager_query(m, id) == true &&
              idmanager_contains(sm, m, id, idnode) &&
              idnode != 0 &&
              &(idnode->link) != 0 &&
              store_idmanager(sm, idmanager_remove(sm, m, id), manager) *
              (idnode->id == 65535) *
              (idnode->link.node_prev == &(idnode->link)) *
              (idnode->link.node_next == &(idnode->link)))
*/
;

/* Imported API from annotated_C/src/kernel/semaphore/_SemaphoreDelete.c; same source revision above. */
void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
/*@ remove_member
    With {A} (storeA: addr -> A -> Assertion)
             (head: addr)  (a: A)
             (prefix: list(DL_Node A))
             (suffix: list(DL_Node A))
    Require store_dll(storeA, head,
              app(prefix, cons(Build_DL_Node(a, linklist_node), suffix)))
    Ensure store_dll(storeA, head, app(prefix, suffix)) *
           storeA(linklist_node, a) *
           store_node_self_linked(linklist_node)
*/
;

/* Imported API from annotated_C/src/kernel/semaphore/_SemaphoreDelete.c; same source revision above. */
void x_free(void *ptr)
/*@ Require SemaphoreRaw(ptr)
    Ensure emp
 */;

/* Imported API from annotated_C/src/kernel/semaphore/_SemaphoreDelete.c; same source revision above. */
void KTASK_ASSIGN(void)
/*@ outside_critical
    With (sg : StableGlobalState) (before : CoreVarGlobalState) X
    Require safeExec(core_LastSeen(before), abs_ktask_assign, X) && core_OutsideCritical(sg, before)
    Ensure exists after, safeExec(core_LastSeen(after), return(tt), X) && core_OutsideCritical(sg, after)
 */;

/* This named IC scenario covers dataqueue cleanup of freshly created,
 * empty-pending semaphores. dq_sem_delete_empty is an explicit precondition;
 * it is established by the caller's reviewed cleanup observation guard.
 * The original nonempty-pending and reschedule branches remain in the body,
 * with their imported APIs, but are unreachable under this scenario. */

void _SemaphoreDelete(int32 id)
/*@ dataqueue_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require dq_sem_delete_empty(id, before) && os_inv(sg, before)
    Ensure exists after,
      dq_semaphore_delete_effect(id, before, after) && os_inv(sg, after)
 */
{
    int resched = 0;
    x_base lock = 0;
    struct Semaphore *sem = NONE;
    struct IdNode *idnode = NONE;

    if (id < 0)
        return;

    /* Nested lock acquisition omitted: caller owns the critical region. */
    idnode = IdGetObj(&k_sem_id_manager, id);
    if (idnode == NONE) {
        /* Nested unlock omitted: caller retains the critical region. */
        return;
    }
    sem = CONTAINER_OF_SEMAPHORE_ID(idnode);

    /* Diagnostic removed under TrustBase. */
    if (!IsDoubleLinkListEmpty(&sem->pend_list) /*@ where (dll) */) {
        resched = 1;
        LinklistResumeAll(&sem->pend_list) /*@ where (semaphore_waiters) */;
    }

    IdRemoveObj(&k_sem_id_manager, sem->id.id) /*@ where (low_level_spec) */;
    DoubleLinkListRmNode(&sem->link) /*@ where (remove_member) */;
    /* Nested unlock omitted: caller retains the critical region. */

    x_free(sem);

    if (resched){
        KTASK_ASSIGN() /*@ where (outside_critical) */;
    }
}
