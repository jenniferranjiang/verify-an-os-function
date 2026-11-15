#include "mutex_delete_types.h"
#include "mutex_delete_logic.h"

/* TrustBase ordinary global critical contracts; no delete-specific variant. */
x_base CriticalAreaLock(void)
/*@ ordinary
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require OutsideCritical(sg, before)
    Ensure exists current,
      Crtos_RTrans(before, current) &&
      InsideCritical(sg, current) * os_inv(sg, current)
 */;
void CriticalAreaUnLock(x_base lock)
/*@ ordinary
    With (sg : StableGlobalState) (before after : VarGlobalState)
    Require Crtos_GTrans(before, after) &&
      InsideCritical(sg, before) * os_inv(sg, after)
    Ensure OutsideCritical(sg, after)
 */;

/* Source-processing NULL_PARAM_CHECK model: null does not normally return. */
inline void NULL_PARAM_CHECK_1(void *p)
/*@ Require emp Ensure p != 0 */;

x_err_t LinklistResumeAll(DoubleLinklistType *list)
/*@ mutex_waiters_oc
    With (sg : StableGlobalState) (before : VarGlobalState) (p : addr) X
    Require list == mutex_pending_head(p) &&
      safeExec(LastSeen(before), abs_linklist_resume_all(sg, p), X) &&
      OutsideCritical(sg, before)
    Ensure __return == 0 && exists after,
      safeExec(LastSeen(after), return(__return), X) &&
      OutsideCritical(sg, after)
 */;

/* Reused-spec: root annotated_C/src/kernel/id/IdRemoveObj.c, low_level_spec. */
void IdRemoveObj(struct IdManager *manager, uint16 id)
/*@ low_level_spec
    With (sm: StableIdmanager) (m: VarIdmanager)
    Require manager != 0 && 0 <= id && id < 65536 &&
      store_idmanager(sm, m, manager)
    Ensure (idmanager_query(m, id) == false && store_idmanager(sm, m, manager))
      || (exists idnode,
          idmanager_query(m, id) == true &&
          idmanager_contains(sm, m, id, idnode) &&
          idnode != 0 && &(idnode->link) != 0 &&
          store_idmanager(sm, idmanager_remove(sm, m, id), manager) *
          (idnode->id == 65535) *
          (idnode->link.node_prev == &(idnode->link)) *
          (idnode->link.node_next == &(idnode->link)))
 */;
/* Reused-spec: root annotated_C/src/headers/m_double_linklist.h remove_member. */
void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
/*@ remove_member
    With {A} (storeA: addr -> A -> Assertion)
      (head: addr) (a: A) (prefix: list(DL_Node A)) (suffix: list(DL_Node A))
    Require store_dll(storeA, head,
      app(prefix, cons(Build_DL_Node(a, linklist_node), suffix)))
    Ensure store_dll(storeA, head, app(prefix, suffix)) *
      storeA(linklist_node, a) * store_node_self_linked(linklist_node)
 */;
/* TrustBase KERNEL_FREE(ptr) expands to x_free(ptr); same mutex_object API
 * as root kernel/mutex/_MutexCreate.c. MutexRaw covers all 36 bytes;
 * allocation-base provenance remains the existing allocator assumption. */
void x_free(void *ptr)
/*@ mutex_object Require MutexRaw(ptr) Ensure emp */;

/* Conditional trial scope A1--A3; no public ghost ID. */
void _MutexDelete(struct Mutex *mutex)
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_mutex_delete(sg, mutex), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) &&
      OutsideCritical(sg, after)
 */
/*@ null_only
    Require mutex == 0 && emp
    Ensure 0 == 1 && emp
 */
{
    x_base lock = 0;
    NULL_PARAM_CHECK_1(mutex);
    LinklistResumeAll(&mutex->pend_list) /*@ where (mutex_waiters_oc) sg = sg, p = mutex */;
    lock = CriticalAreaLock();
    IdRemoveObj(&k_mutex_id_manager, mutex->id.id) /*@ where (low_level_spec) */;
    DoubleLinkListRmNode(&(mutex->link)) /*@ where (remove_member) */;
    CriticalAreaUnLock(lock);
    x_free(mutex) /*@ where (mutex_object) */;
}

