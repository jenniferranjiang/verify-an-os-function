#include "../include/slice_types.h"
#include "../include/logic.h"

/* Source: kernel/thread/mutex.c:62-75. static is normalized to slice
 * external linkage. No lock is moved: ResumeAll returns outside critical,
 * then the original removal critical section begins. A1/A2 constrain only
 * the environment in the two gaps. NULL checking retains nontermination.
 */
/* A1 + A2: caller-scoped trusted environment contract. After ResumeAll,
 * the same allocation remains published and no new waiter joins before
 * this acquisition. No equality of unrelated state or scalar fields is
 * assumed. This contract cannot be exported as an unconditional lock API. */
x_base CriticalAreaLock(void)
/*@ mutex_drained
    With (sg : StableGlobalState) (before : VarGlobalState) (p id : Z)
    Require mutex_delete_drained(p, id, before) && OutsideCritical(sg, before)
    Ensure exists st_lock,
      Crtos_RTrans(before, st_lock) && mutex_delete_drained(p, id, st_lock) &&
      InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
 */;

void CriticalAreaUnLock(x_base lock)
/*@ stable
    With (sg : StableGlobalState) (st1 st2 : VarGlobalState)
    Require Crtos_GTrans(st1, st2) &&
      InsideCritical(sg, st1) * os_inv(sg, st2)
    Ensure OutsideCritical(sg, st2)
 */;

x_err_t LinklistResumeAll(DoubleLinklistType *list)
/*@ mutex_waiters_oc
    With (sg : StableGlobalState) (before : VarGlobalState) (p id : Z) X
    Require list == mutex_pending_head(p) &&
      mutex_delete_live(p, id, before) &&
      safeExec(LastSeen(before), abs_mutex_resume_all(p, id), X) &&
      OutsideCritical(sg, before)
    Ensure __return == KOK && exists after,
      mutex_delete_drained(p, id, after) &&
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */;

void IdRemoveObj(struct IdManager *manager, uint16 id)
/*@ high_level_spec
    With (sm: StableIdmanager) (m: VarIdmanager) (idnode: addr)
    Require manager != 0 &&
            0 <= id && id < 65536 &&
            idmanager_query(
              idmanager_link(sm, idmanager_add(m, id), id, idnode), id)
              == true &&
            store_idmanager(sm,
              idmanager_link(sm, idmanager_add(m, id), id, idnode),
              manager)
    Ensure idnode != 0 &&
           &(idnode->link) != 0 &&
           store_idmanager(sm,
             idmanager_remove(sm,
               idmanager_link(sm, idmanager_add(m, id), id, idnode), id),
             manager) *
           (idnode->id == 65535) *
           (idnode->link.node_prev == &(idnode->link)) *
           (idnode->link.node_next == &(idnode->link))
*/
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
*/;

void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
/*@ remove_ready_member
    With (task head : Z)
         (prefix suffix : list(DL_Node Z))
    Require
      linklist_node == sched_link_of(task) &&
      store_priority_ready_bucket(
        head,
        app(prefix, cons(sched_link_node(task), suffix)))
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

/* TrustBase allocator boundary, specialized to the original Mutex base.
 * MutexRaw includes every field, both external links and two padding bytes;
 * the typed-byte conversion is an explicit design obligation. */
void x_free(void *ptr)
/*@ Require MutexRaw(ptr)
    Ensure emp
 */;

void _MutexDelete(struct Mutex *mutex)
/*@ assumed_environment
    With (sg : StableGlobalState) (before : VarGlobalState) (id : Z) X
    Require mutex_delete_live(mutex, id, before) &&
      safeExec(LastSeen(before), abs_mutex_delete_object(mutex, id), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */
{
    x_base lock = 0;
    if (mutex == NONE) { while (1) { } }

    LinklistResumeAll(&mutex->pend_list)
      /*@ where (mutex_waiters_oc) sg = sg, before = before, p = mutex, id = id */;
    lock = CriticalAreaLock()
      /*@ where (mutex_drained) sg = sg, p = mutex, id = id */;
    IdRemoveObj(&k_mutex_id_manager, mutex->id.id)
      /*@ where (low_level_spec) sm = mutex_manager_stable(os_mutex_stable(sg)) */;
    DoubleLinkListRmNode(&(mutex->link)) /*@ where (remove_member) head = &k_mutex_list; A = MutexAbs */;
    CriticalAreaUnLock(lock) /*@ where (stable) sg = sg */;
    x_free(mutex);
}
