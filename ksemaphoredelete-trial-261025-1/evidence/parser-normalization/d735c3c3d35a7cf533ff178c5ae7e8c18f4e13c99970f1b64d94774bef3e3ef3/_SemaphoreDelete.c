#include "../include/slice_types.h"
#include "../include/logic.h"
/*@ Import Coq Require Import CRTOS_Verify.VC.SemaphoreDelete_lib */
/*@ Extern Coq
  (delete_global_frame : StableGlobalState -> VarGlobalState -> Assertion)
  (delete_manager_frame : StableGlobalState -> VarGlobalState -> Assertion)
  (delete_pending_restore : StableGlobalState -> VarGlobalState -> addr -> list addr -> Assertion)
  (delete_id_restore : StableGlobalState -> VarGlobalState -> addr -> Z -> Assertion)
  (os_semaphore_stable : StableGlobalState -> SemaphoreStable)
  (semaphore_manager_stable : SemaphoreStable -> StableIdmanager)
  (semaphore_manager : SemaphoreState -> VarIdmanager)
  (semaphore_context : SemaphoreStable -> Prop)
  (semaphore_link_node : SemaphoreAbs -> DL_Node SemaphoreAbs)
  (store_semaphore : (addr -> addr -> Assertion) -> addr -> SemaphoreAbs -> Assertion)
  (unsigned_last_nbits : Z -> Z -> Z)
  (NoDup : {A} -> list A -> Prop)
  (SemaphoreRetired : addr -> Z -> Assertion)
*/


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
 */
;

x_err_t LinklistResumeAll(DoubleLinklistType *list)
/*@ semaphore_waiters
    With (sg : StableGlobalState) (before : VarGlobalState)
         (sem : addr) (waiting : list addr)
    Require list == semaphore_pending_head(sem) &&
      semaphore_pending_nodes(sem, before, map(sched_link_node, waiting)) &&
      os_inv(sg, before)
    Ensure __return == KOK && exists after,
      semaphore_resume_all_effect(sem, waiting, before, after) &&
      semaphore_pending_nodes(sem, after, nil) && os_inv(sg, after)
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
*/
;

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
    With {A_from_head} (storeA: addr -> A_from_head -> Assertion)
             (head: addr) (a: A_from_head)
             (suffix: list(DL_Node A_from_head))
    Require linklist_node != 0 && 
            store_dll(storeA, head,
              cons(Build_DL_Node(a, linklist_node), suffix))
    Ensure store_dll(storeA, head, suffix) *
           storeA(linklist_node, a) *
           store_node_self_linked(linklist_node)
*/
;

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
    /*@ -2147483648 <= id && id <= 2147483647 by local */
    int resched = 0;
    x_base lock = 0;
    struct Semaphore *sem = ((void *)0);
    struct IdNode *idnode = ((void *)0);

    if (id < 0)
        return;

    lock = CriticalAreaLock() /*@ where (ordinary) sg = sg, st1 = before */;
    /*@ Given st_lock */
    /*@ os_inv(sg, st_lock)
        which implies
        store_idmanager(semaphore_manager_stable(os_semaphore_stable(sg)),
          semaphore_manager(st_lock.os_semaphores), &k_sem_id_manager) *
        delete_manager_frame(sg, st_lock)
    */
    idnode = IdGetObj(&k_sem_id_manager, id);
    if (idnode == ((void *)0)) {
        /*@ Assert exists (saved_lock : Z), lock == saved_lock &&
          id == id@pre && 0 <= id && id <= 2147483647 && resched == 0 &&
          sem == 0 && idnode == 0 &&
          safeExec(LastSeen(st_lock), return(tt), X) &&
          Crtos_GTrans(st_lock, st_lock) &&
          InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
        */
        CriticalAreaUnLock(lock) /*@ where (stable) sg = sg, st1 = st_lock, st2 = st_lock */;
        return;
    }
    /*@ store_idmanager_found(semaphore_manager_stable(os_semaphore_stable(sg)),
          semaphore_manager(st_lock.os_semaphores), &k_sem_id_manager,
          idnode, unsigned_last_nbits(id, 16)) * delete_manager_frame(sg, st_lock)
        which implies exists (original : SemaphoreAbs),
          In(original, st_lock.os_semaphores) &&
          original.semaphore_id == unsigned_last_nbits(id, 16) &&
          idnode == field_addr(original.semaphore_addr, struct Semaphore, id) &&
          original.semaphore_addr != 0 && os_inv(sg, st_lock)
    */
    /*@ Given original */
    sem = CONTAINER_OF_SEMAPHORE_ID(idnode)
      /*@ where sem_ptr = original.semaphore_addr */;
    /*@ In(original, st_lock.os_semaphores) && sem == original.semaphore_addr &&
        os_inv(sg, st_lock)
        which implies In(original, st_lock.os_semaphores) && sem == original.semaphore_addr &&
        store_dll(pure_suspend_sched_link(st_lock.os_tasks.task_desc_map),
          &sem->pend_list, map(sched_link_node, original.semaphore_pending_addrs)) *
        delete_pending_restore(sg, st_lock, sem, original.semaphore_pending_addrs)
    */
    if (!IsDoubleLinkListEmpty(&sem->pend_list)
        /*@ where (dll) storeA = pure_suspend_sched_link(st_lock.os_tasks.task_desc_map),
             nodes = map(sched_link_node, original.semaphore_pending_addrs); A = addr */) {
        resched = 1;
        /*@ In(original, st_lock.os_semaphores) && sem == original.semaphore_addr &&
            store_dll(pure_suspend_sched_link(st_lock.os_tasks.task_desc_map),
              &sem->pend_list, map(sched_link_node, original.semaphore_pending_addrs)) *
            delete_pending_restore(sg, st_lock, sem, original.semaphore_pending_addrs)
            which implies In(original, st_lock.os_semaphores) && sem == original.semaphore_addr &&
            semaphore_pending_nodes(sem, st_lock, map(sched_link_node, original.semaphore_pending_addrs)) &&
            os_inv(sg, st_lock)
        */
        LinklistResumeAll(&sem->pend_list)
          /*@ where (semaphore_waiters) sg = sg, before = st_lock, sem = sem,
               waiting = original.semaphore_pending_addrs */;
    }
    /*@ Assert exists (drained : VarGlobalState) (saved_lock : Z),
      lock == saved_lock && id == id@pre && 0 <= id && id <= 2147483647 &&
      sem == original.semaphore_addr &&
      idnode == field_addr(sem, struct Semaphore, id) &&
      In(original, st_lock.os_semaphores) &&
      original.semaphore_id == unsigned_last_nbits(id, 16) &&
      ((resched == 0 && original.semaphore_pending_addrs == nil) ||
       (resched == 1 && original.semaphore_pending_addrs != nil)) &&
      Crtos_RTrans(before, st_lock) &&
      safeExec(LastSeen(before), abs_semaphore_delete(sg, id), X) &&
      semaphore_resume_all_effect(sem, original.semaphore_pending_addrs, st_lock, drained) &&
      semaphore_pending_nodes(sem, drained, nil) &&
      InsideCritical(sg, st_lock) * os_inv(sg, drained)
    */
    /*@ Given drained saved_lock */
    /*@ In(original, st_lock.os_semaphores) && sem == original.semaphore_addr &&
        semaphore_resume_all_effect(sem, original.semaphore_pending_addrs, st_lock, drained) &&
        os_inv(sg, drained)
        which implies In(original, st_lock.os_semaphores) && sem == original.semaphore_addr &&
        semaphore_resume_all_effect(sem, original.semaphore_pending_addrs, st_lock, drained) &&
        store(field_addr(field_addr(sem, struct Semaphore, id), struct IdNode, id),
          unsigned short, original.semaphore_id) *
        delete_id_restore(sg, drained, sem, original.semaphore_id)
    */
    uint16 delete_sem_id = sem->id.id;
    /*@ sem == original.semaphore_addr &&
        store(field_addr(field_addr(sem, struct Semaphore, id), struct IdNode, id),
          unsigned short, original.semaphore_id) *
        delete_id_restore(sg, drained, sem, original.semaphore_id)
        which implies sem == original.semaphore_addr && os_inv(sg, drained)
    */
    /*@ In(original, st_lock.os_semaphores) && sem == original.semaphore_addr &&
        semaphore_resume_all_effect(sem, original.semaphore_pending_addrs, st_lock, drained) &&
        semaphore_pending_nodes(sem, drained, nil) && os_inv(sg, drained)
        which implies exists (current : SemaphoreAbs) (prefix suffix : list SemaphoreAbs),
          In(original, st_lock.os_semaphores) && sem == original.semaphore_addr &&
          semaphore_resume_all_effect(sem, original.semaphore_pending_addrs, st_lock, drained) &&
          semaphore_pending_nodes(sem, drained, nil) &&
          drained.os_semaphores == app(prefix, cons(current, suffix)) &&
          current.semaphore_addr == sem && current.semaphore_id == original.semaphore_id &&
          current.semaphore_value == original.semaphore_value && current.semaphore_pending_addrs == nil &&
          NoDup(map(semaphore_id, drained.os_semaphores)) &&
          idmanager_query(semaphore_manager(drained.os_semaphores), original.semaphore_id) == true &&
          store_idmanager(semaphore_manager_stable(os_semaphore_stable(sg)),
            semaphore_manager(drained.os_semaphores), &k_sem_id_manager) *
          delete_manager_frame(sg, drained)
    */
    /*@ Given current prefix suffix */
    /* Keep the old manager's ID uniqueness as a pure fact across removal.
     * The previous os_inv entailment must derive it from idbuckets_ok/idlist_ok;
     * the post-removal manager alone cannot recover uniqueness of deleted IDs. */
    IdRemoveObj(&k_sem_id_manager, delete_sem_id)
      /*@ where (low_level_spec) sm = semaphore_manager_stable(os_semaphore_stable(sg)),
           m = semaphore_manager(drained.os_semaphores) */;
    /*@ drained.os_semaphores == app(prefix, cons(current, suffix)) &&
        current.semaphore_addr == sem && delete_manager_frame(sg, drained)
        which implies drained.os_semaphores == app(prefix, cons(current, suffix)) &&
        current.semaphore_addr == sem &&
        semaphore_context(os_semaphore_stable(sg)) && delete_global_frame(sg, drained) *
        store_dll(store_semaphore(pure_suspend_sched_link(drained.os_tasks.task_desc_map)),
          &k_sem_list, app(map(semaphore_link_node, prefix),
            cons(Build_DL_Node(current, &sem->link), map(semaphore_link_node, suffix))))
    */
    DoubleLinkListRmNode(&sem->link)
      /*@ where (remove_member) storeA = store_semaphore(pure_suspend_sched_link(drained.os_tasks.task_desc_map)),
           head = &k_sem_list, a = current, prefix = map(semaphore_link_node, prefix),
           suffix = map(semaphore_link_node, suffix); A = SemaphoreAbs */;
    /*@ Assert exists (after : VarGlobalState),
      lock == saved_lock && id == id@pre && sem == original.semaphore_addr &&
      idnode == field_addr(sem, struct Semaphore, id) && delete_sem_id == original.semaphore_id &&
      ((resched == 0 && safeExec(LastSeen(after), return(tt), X)) ||
       (resched == 1 && safeExec(LastSeen(after), abs_ktask_assign, X))) &&
      Crtos_GTrans(st_lock, after) &&
      InsideCritical(sg, st_lock) * os_inv(sg, after) *
      SemaphoreRetired(sem, original.semaphore_value)
    */
    /*@ Given after */
    CriticalAreaUnLock(lock) /*@ where (stable) sg = sg, st1 = st_lock, st2 = after */;
    /*@ SemaphoreRetired(sem, original.semaphore_value)
        which implies SemaphoreRaw(sem)
    */
    x_free(sem);

    if (resched){
        KTASK_ASSIGN() /*@ where (outside_critical) sg = sg, before = after, X = X */;
    }
}
