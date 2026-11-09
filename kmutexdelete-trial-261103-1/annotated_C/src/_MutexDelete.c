#include "../include/slice_types.h"
#include "../include/logic.h"

/*@ Import Coq Require Import KMutexDeleteProof.VC.MutexDelete_lib */
/*@ Extern Coq
  (mutex_delete_after_resume : Z -> Z -> (unit -> (VarGlobalState -> Prop) -> Prop) -> unit -> (VarGlobalState -> Prop) -> Prop)
  (mutex_delete_id_restore : StableGlobalState -> VarGlobalState -> Z -> Z -> Assertion)
  (mutex_delete_manager_frame : StableGlobalState -> VarGlobalState -> Assertion)
  (mutex_create_frame : StableGlobalState -> VarGlobalState -> Assertion)
  (mutex_context : MutexStable -> Prop)
  (mutex_link_node : MutexAbs -> DL_Node MutexAbs)
  (mutex_addr : MutexAbs -> addr)
  (mutex_id : MutexAbs -> Z)
  (mutex_delete_unpublish : addr -> MutexState -> MutexState)
  (replace_mutexes : MutexState -> VarGlobalState -> VarGlobalState)
  (store_mutex : (addr -> addr -> Assertion) -> addr -> MutexAbs -> Assertion)
  (NoDup : {A} -> list A -> Prop)
 */

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
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState)
         (target : PendlistTarget) X
    Require list == pendlist_head(target) &&
      safeExec(LastSeen(before), abs_linklist_resume_all(target), X) &&
      OutsideCritical(sg, before)
    Ensure __return == KOK && exists after,
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
           field_addr(idnode, struct IdNode, link) != 0 &&
           store_idmanager(sm,
             idmanager_remove(sm,
               idmanager_link(sm, idmanager_add(m, id), id, idnode), id),
             manager) *
           store(field_addr(idnode, struct IdNode, id), unsigned short, 65535) *
           store(field_addr(field_addr(idnode, struct IdNode, link), struct SysDoubleLinklistNode, node_prev), struct SysDoubleLinklistNode *, field_addr(idnode, struct IdNode, link)) *
           store(field_addr(field_addr(idnode, struct IdNode, link), struct SysDoubleLinklistNode, node_next), struct SysDoubleLinklistNode *, field_addr(idnode, struct IdNode, link))
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
              field_addr(idnode, struct IdNode, link) != 0 &&
              store_idmanager(sm, idmanager_remove(sm, m, id), manager) *
              store(field_addr(idnode, struct IdNode, id), unsigned short, 65535) *
              store(field_addr(field_addr(idnode, struct IdNode, link), struct SysDoubleLinklistNode, node_prev), struct SysDoubleLinklistNode *, field_addr(idnode, struct IdNode, link)) *
              store(field_addr(field_addr(idnode, struct IdNode, link), struct SysDoubleLinklistNode, node_next), struct SysDoubleLinklistNode *, field_addr(idnode, struct IdNode, link)))
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
*/;

void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
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
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require mutex != 0 && exists id,
      mutex_delete_live(mutex, id, before) &&
      safeExec(LastSeen(before), abs_mutex_delete_object_with_id(mutex, id), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */
{
    x_base lock = 0;
    /*@ Given id */
    if (mutex == NONE) {
        /*@ Inv Assert mutex == mutex@pre && mutex == 0 &&
          mutex_delete_live(mutex, id, before) &&
          has_permission(&lock) * OutsideCritical(sg, before)
         */
        while (1) { }
    }
    /*@ safeExec(LastSeen(before), abs_mutex_delete_object_with_id(mutex@pre, id), X)
        which implies
        safeExec(LastSeen(before), abs_linklist_resume_all(PendMutex(mutex@pre, id)),
          mutex_delete_after_resume(mutex@pre, id, X))
     */
    LinklistResumeAll(&mutex->pend_list)
      /*@ where (outside_critical) sg = sg, before = before,
          target = PendMutex(mutex, id),
          X = mutex_delete_after_resume(mutex, id, X) */;
    /*@ Given drained from after */
    /*@ safeExec(LastSeen(drained), return(tt), mutex_delete_after_resume(mutex@pre, id, X))
        which implies safeExec(LastSeen(drained), abs_mutex_retire(mutex@pre, id), X)
     */
    lock = CriticalAreaLock()
      /*@ where (mutex_drained) sg = sg, before = drained, p = mutex, id = id */;
    /*@ Given st_lock */
    /*@ mutex_delete_drained(mutex@pre, id, st_lock) && os_inv(sg, st_lock)
        which implies exists (current : MutexAbs) (prefix suffix : list MutexAbs),
          os_mutexes(st_lock) == app(prefix, cons(current, suffix)) &&
          current.mutex_addr == mutex@pre && current.mutex_id == id &&
          current.mutex_pending_addrs == nil &&
          NoDup(map(mutex_addr, os_mutexes(st_lock))) &&
          NoDup(map(mutex_id, os_mutexes(st_lock))) &&
          idmanager_query(mutex_manager(os_mutexes(st_lock)), id) == true &&
          store(field_addr(field_addr(mutex@pre, struct Mutex, id), struct IdNode, id),
            unsigned short, id) * mutex_delete_id_restore(sg, st_lock, mutex@pre, id)
     */
    /*@ Given current prefix suffix */
    /* Equivalent slice normalization: one original ID read, same critical section. */
    uint16 delete_mutex_id = mutex->id.id;
    /*@ store(field_addr(field_addr(mutex@pre, struct Mutex, id), struct IdNode, id),
          unsigned short, id) * mutex_delete_id_restore(sg, st_lock, mutex@pre, id)
        which implies os_inv(sg, st_lock)
     */
    /*@ os_inv(sg, st_lock)
        which implies
        store_idmanager(mutex_manager_stable(os_mutex_stable(sg)),
          mutex_manager(os_mutexes(st_lock)), &k_mutex_id_manager) *
        mutex_delete_manager_frame(sg, st_lock)
     */
    IdRemoveObj(&k_mutex_id_manager, delete_mutex_id)
      /*@ where (low_level_spec) sm = mutex_manager_stable(os_mutex_stable(sg)),
          m = mutex_manager(os_mutexes(st_lock)) */;
    /*@ os_mutexes(st_lock) == app(prefix, cons(current, suffix)) &&
        current.mutex_addr == mutex@pre &&
        mutex_delete_manager_frame(sg, st_lock)
        which implies
        os_mutexes(st_lock) == app(prefix, cons(current, suffix)) &&
        current.mutex_addr == mutex@pre && mutex_context(os_mutex_stable(sg)) &&
        mutex_create_frame(sg, st_lock) *
        store_dll(store_mutex(pure_suspend_sched_link(st_lock.os_tasks.task_desc_map)),
          &k_mutex_list, app(map(mutex_link_node, prefix),
            cons(Build_DL_Node(current, &mutex@pre->link), map(mutex_link_node, suffix))))
     */
    DoubleLinkListRmNode(&(mutex->link))
      /*@ where (remove_member)
          storeA = store_mutex(pure_suspend_sched_link(st_lock.os_tasks.task_desc_map)),
          head = &k_mutex_list, a = current,
          prefix = map(mutex_link_node, prefix), suffix = map(mutex_link_node, suffix);
          A = MutexAbs */;
    /*@ Assert exists (after : VarGlobalState) (saved_lock : Z),
      lock == saved_lock && mutex == mutex@pre && mutex == current.mutex_addr &&
      delete_mutex_id == id &&
      after == replace_mutexes(mutex_delete_unpublish(mutex, os_mutexes(st_lock)), st_lock) &&
      safeExec(LastSeen(after), return(tt), X) && Crtos_GTrans(st_lock, after) &&
      InsideCritical(sg, st_lock) * os_inv(sg, after) * MutexRetired(current)
     */
    /*@ Given after saved_lock */
    CriticalAreaUnLock(lock)
      /*@ where (stable) sg = sg, st1 = st_lock, st2 = after */;
    /*@ MutexRetired(current) which implies MutexRaw(current.mutex_addr) */
    x_free(mutex);
}
