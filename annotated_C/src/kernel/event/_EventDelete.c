#include "event_delete_types.h"
#include "event_delete_logic.h"

/* Imported contract boundary; source/revision: checks/source-slices/manifest.json. */
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

/* This named boundary is valid only under the user-approved D1/D2 execution
 * restrictions of this EventDelete experiment. It is NOT derived from ordinary
 * locking and does not assert that the kernel enforces those restrictions.
 * D1 concerns the same allocation throughout the lookup-to-unpublish interval;
 * equal pointer/ID snapshots alone do not establish freedom from ABA. */
x_base CriticalAreaLock(void)
/*@ event_delete_gap
    With (sg : StableGlobalState) (before : VarGlobalState)
         (id p : Z) (empty : bool)
    Require event_delete_guard(id, p, empty, before) &&
            OutsideCritical(sg, before)
    Ensure exists current,
      event_delete_gap(id, p, empty, before, current) &&
      InsideCritical(sg, current) * os_inv(sg, current)
 */;

/* Imported contract boundary; source/revision: checks/source-slices/manifest.json. */
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

/* Imported contract boundary; source/revision: checks/source-slices/manifest.json. */
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

/* Imported contract boundary; source/revision: checks/source-slices/manifest.json. */
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
*/;

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
              field_addr(idnode, struct IdNode, link) != 0 &&
              store_idmanager(sm, idmanager_remove(sm, m, id), manager) *
              store(field_addr(idnode, struct IdNode, id), unsigned short, 65535) *
              store(field_addr(field_addr(idnode, struct IdNode, link), struct SysDoubleLinklistNode, node_prev), struct SysDoubleLinklistNode *, field_addr(idnode, struct IdNode, link)) *
              store(field_addr(field_addr(idnode, struct IdNode, link), struct SysDoubleLinklistNode, node_next), struct SysDoubleLinklistNode *, field_addr(idnode, struct IdNode, link)))
*/;

/* Imported contract boundary; source/revision: checks/source-slices/manifest.json. */
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
 */;

void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
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
 */;

void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
/*@ remove_self
    With (node : Z)
    Require
      linklist_node == node &&
      node != 0 &&
      store_node_self_linked(node)
    Ensure
      store_node_self_linked(node)
 */;

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

/* Trusted KERNEL_FREE/x_free boundary under TrustBase; owns the complete
 * detached Event allocation, including padding. Not a new implementation proof. */
void x_free(void *ptr)
/*@ Require EventRaw(ptr)
    Ensure emp
 */;

/* Imported contract boundary; source/revision: checks/source-slices/manifest.json. */
void KTASK_ASSIGN(void)
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_ktask_assign, X) && OutsideCritical(sg, before)
    Ensure exists after, safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */;

x_err_t LinklistResumeAll(DoubleLinklistType *list)
/*@ event_waiters_oc
    With (sg : StableGlobalState) (before : VarGlobalState) (id p : Z) X
    Require list == event_pending_head(p) &&
      event_delete_guard(id, p, false, before) &&
      safeExec(LastSeen(before), abs_event_resume_all(id, p), X) &&
      OutsideCritical(sg, before)
    Ensure __return == 0 && exists after,
      event_delete_guard(id, p, true, after) &&
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */;

void _EventDelete(struct Event *event)
/*@ event_delete_at_oc
    With (sg : StableGlobalState) (before : VarGlobalState) (id : Z) X
    Require event_delete_guard(id, event, false, before) &&
      safeExec(LastSeen(before), abs_event_delete_at(id, event), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */
{
    int resched = 0;
    x_base lock = 0;
    x_base inspect_lock = 0;
    int pending_empty;

    /* NULL_PARAM_CHECK: printing removed; nonreturning branch retained. */
    if (event == NONE) { while (1) { } }

    /* Documented source adaptation: protect this one shared inspection.
     * Its unlock remains before ResumeAll and the original deletion lock. */
    inspect_lock = CriticalAreaLock()
      /*@ where (event_delete_gap) sg = sg, id = id, p = event, empty = false */;
    pending_empty = IsDoubleLinkListEmpty(&event->pend_list) /*@ where (dll) */;
    CriticalAreaUnLock(inspect_lock) /*@ where (stable) sg = sg */;
    if (!pending_empty) {
        resched = 1;
        LinklistResumeAll(&event->pend_list)
          /*@ where (event_waiters_oc) sg = sg, id = id, p = event */;
    }

    lock = CriticalAreaLock()
      /*@ where (event_delete_gap) sg = sg, id = id, p = event, empty = true */;
    IdRemoveObj(&k_event_id_manager, event->id.id) /*@ where (low_level_spec) */;
    DoubleLinkListRmNode(&event->link) /*@ where (remove_member) */;
    CriticalAreaUnLock(lock) /*@ where (stable) sg = sg */;
    x_free(event);

    if (resched)
        KTASK_ASSIGN() /*@ where (outside_critical) sg = sg */;
}
