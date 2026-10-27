#include "../include/slice_types.h"
#include "../include/logic.h"

/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/semaphore.c. Current 32-bit non-SMP configuration. */
x_base CriticalAreaLock(void)
/*@ ordinary
    With (sg : StableGlobalState) (st1 : VarGlobalState)
    Require
      OutsideCritical(sg, st1)
    Ensure
      exists st_lock,
        Crtos_RTrans(st1, st_lock) &&
        InsideCritical(sg, st_lock) *
        os_inv(sg, st_lock)
 */;

struct IdNode *IdGetObj(struct IdManager *manager, uint16 id)
/*@ With (sidm: StableIdmanager) (idm: VarIdmanager)
    Require 0 <= id && id < 65536 && store_idmanager(sidm, idm, manager)
    Ensure (manager == 0 &&
            __return == 0 &&
            store_idmanager(sidm, idm, manager))
           ||
           (manager != 0 &&
            __return == 0 &&
            idmanager_query(idm, id) == false &&
            store_idmanager(sidm, idm, manager))
           ||
           (manager != 0 &&
            __return != 0 &&
            idmanager_query(idm, id) == true &&
            store_idmanager_found(sidm, idm, manager, __return, id))
*/;

void CriticalAreaUnLock(x_base lock)
/*@ stable
    With (sg : StableGlobalState) (st1 st2 : VarGlobalState)
    Require
      Crtos_GTrans(st1, st2) &&
      InsideCritical(sg, st1) *
      os_inv(sg, st2)
    Ensure
      OutsideCritical(sg, st2)
 */;

struct Semaphore *CONTAINER_OF_SEMAPHORE_ID(struct IdNode *id_ptr)
/*@ With (sem_ptr : addr)
    Require id_ptr == field_addr(sem_ptr, struct Semaphore, id) && emp
    Ensure __return == sem_ptr && id_ptr == &(__return->id) && emp
 */;

int IsDoubleLinkListEmpty(const DoubleLinklistType *linklist)
/*@ ready_dll
    With (nodes : list(DL_Node Z))
    Require
      store_priority_ready_bucket(linklist, nodes)
    Ensure
      ((__return == 1 && nodes == nil) ||
       (__return == 0 && nodes != nil)) &&
      store_priority_ready_bucket(linklist, nodes)
 */
/*@ dll
    With {A} (storeA : Z -> A -> Assertion)
             (nodes : list(DL_Node A))
    Require
      store_dll(storeA, linklist, nodes)
    Ensure
      ((__return == 1 && nodes == nil) ||
       (__return == 0 && nodes != nil)) &&
      store_dll(storeA, linklist, nodes)
 */;

x_err_t LinklistResumeAll(DoubleLinklistType *list)
/*@ semaphore_waiters
    With (sg : StableGlobalState) (st : VarGlobalState) (sem : SemaphoreAbs)
    Require In(sem, st.os_semaphores) &&
      list == semaphore_pending_head(sem.semaphore_addr) &&
      os_global_context(sg) &&
      task_fields(sg, st) *
      delay_inv(sg, st) *
      assign_ready_pending(sg, st) *
      store_dll(pure_suspend_sched_link(st.os_tasks.task_desc_map),
        list, map(semaphore_wait_node, sem.semaphore_pending_addrs))
    Ensure __return == KOK && exists after,
      semaphore_resume_all_steps(sem.semaphore_addr, sem.semaphore_pending_addrs, st, after) &&
      task_fields(sg, after) *
      delay_inv(sg, after) *
      assign_ready_pending(sg, after) *
      store_node_self_linked(list)
 */;

void IdRemoveObj(struct IdManager *manager, uint16 id)
/*@ known_node
    With (sidm: StableIdmanager) (idm: VarIdmanager) (idnode: addr)
    Require manager != 0 &&
            0 <= id && id < 65536 &&
            idmanager_query(
              idmanager_link(sidm, idmanager_add(idm, id), id, idnode), id)
              == true &&
            store_idmanager(sidm,
              idmanager_link(sidm, idmanager_add(idm, id), id, idnode),
              manager)
    Ensure idnode != 0 &&
           &(idnode->link) != 0 &&
           store_idmanager(sidm,
             idmanager_remove(sidm,
               idmanager_link(sidm, idmanager_add(idm, id), id, idnode), id),
             manager) *
           (idnode->id == 65535) *
           store_node_self_linked(&(idnode->link))
*/
/*@ current_node
    With (sidm : StableIdmanager) (idm : VarIdmanager) (idnode : addr)
    Require store_idmanager_found(sidm, idm, manager, idnode, id)
    Ensure store_idmanager(sidm, idmanager_remove(sidm, idm, id), manager) *
      store_idnode(&(idnode->link), Build_IdNodeAbs(65535, idnode)) *
      store_node_self_linked(&(idnode->link))
 */
/*@ found_node
    With (sidm : StableIdmanager) (idm : VarIdmanager) (idnode : addr)
    Require store_idmanager_found(sidm, idm, manager, idnode, id)
    Ensure store_idmanager(sidm, idmanager_remove(sidm, idm, id), manager) *
      store_idnode(&(idnode->link), Build_IdNodeAbs(65535, idnode)) *
      store_node_self_linked(&(idnode->link))
 */
/*@ absent_node
    With (sidm : StableIdmanager) (idm : VarIdmanager)
    Require idmanager_query(idm, id) == false && store_idmanager(sidm, idm, manager)
    Ensure store_idmanager(sidm, idm, manager)
 */;

void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
/*@ remove_ready_member
    With (task head : Z)
         (prefix suffix : list(DL_Node Z))
    Require
      linklist_node == sched_link_of(task) &&
      store_priority_ready_bucket(
        head,
        app(prefix, cons(ready_task_node(task), suffix)))
    Ensure
      linklist_node == sched_link_of(task) &&
      store_priority_ready_bucket(head, app(prefix, suffix)) *
      store_node_self_linked(linklist_node)
 */
/*@ remove_sched_self
    With (task : Z) (sched : TaskSchedMemberAbs)
    Require
      linklist_node == sched_link_of(task) &&
      linklist_node != 0 &&
      store_task_sched_member(sched_link_of(task), sched) *
      store_node_self_linked(sched_link_of(task))
    Ensure
      store_task_sched_member(sched_link_of(task), sched) *
      store_node_self_linked(sched_link_of(task))
 */
/*@ remove_self
    With (node : Z)
    Require
      linklist_node == node &&
      node != 0 &&
      store_node_self_linked(node)
    Ensure
      store_node_self_linked(node)
 */
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
/*@ remove_from_head
    With {A} (storeA: addr -> A -> Assertion)
             (head: addr) (a: A)
             (suffix: list(DL_Node A))
    Require linklist_node != 0 && 
            store_dll(storeA, head,
              cons(Build_DL_Node(a, linklist_node), suffix))
    Ensure store_dll(storeA, head, suffix) *
           storeA(linklist_node, a) *
           store_node_self_linked(linklist_node)
*/;

void x_free(void *ptr)
/*@ Require SemaphoreRaw(ptr)
    Ensure emp
 */;

void KTASK_ASSIGN(void)
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_ktask_assign, X) && OutsideCritical(sg, before)
    Ensure exists after, safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */;

void _SemaphoreDelete(int32 id)
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_semaphore_delete(sg, id), X) &&
            OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */
{
    int resched = 0;
    x_base lock = 0;
    struct Semaphore *sem = NONE;
    struct IdNode *idnode = NONE;

    if (id < 0)
        return;

    lock = CriticalAreaLock() /*@ where (ordinary) sg = sg, st1 = before */;
    idnode = IdGetObj(&k_sem_id_manager, id);
    if (idnode == NONE) {
        CriticalAreaUnLock(lock) /*@ where (stable) sg = sg */;
        return;
    }
    sem = CONTAINER_OF_SEMAPHORE_ID(idnode);

    
    if (!IsDoubleLinkListEmpty(&sem->pend_list) /*@ where (dll) */) {
        resched = 1;
        LinklistResumeAll(&sem->pend_list) /*@ where (semaphore_waiters) sg = sg */;
    }

    IdRemoveObj(&k_sem_id_manager, sem->id.id) /*@ where (current_node) */;
    DoubleLinkListRmNode(&sem->link) /*@ where (remove_member) */;
    CriticalAreaUnLock(lock) /*@ where (stable) sg = sg */;

    x_free(sem);

    if (resched){
        KTASK_ASSIGN() /*@ where (outside_critical) sg = sg */;
    }
}
