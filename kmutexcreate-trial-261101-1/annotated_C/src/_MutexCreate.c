#include "../include/slice_types.h"
#include "../include/logic.h"

/* Source: kernel/thread/mutex.c::_MutexCreate; static-to-slice-external only. */
void *x_malloc(x_size_t size)
/*@ delay_object
    Require 0 <= size && size <= UINT_MAX
    Ensure (__return == 0) ||
           (0 < __return &&
            __return <= UINT_MAX - size &&
            addr_aligned(__return, ALIGN_SIZE) &&
            CharArray::undef_full(__return, size))
 */
;

void *memset(void *s, int c, size_t n)
/*@ Require 0 <= n && n <= UINT_MAX &&
            0 <= c && c <= 127 &&
            CharArray::undef_full(s, n)
    Ensure __return == s && CharArray::full(s, n, repeat_Z(c, n))
*/
;

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

int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sm: StableIdmanager) (m: VarIdmanager)
    Require store_idmanager(sm, m, manager) *
            store_idnode_insert_ready(idnode)
    Ensure (__return == -1 &&
            store_idmanager(sm, m, manager) *
            store_idnode_insert_ready(idnode))
           ||
           (idmanager_min_free_id(sm, m, __return) &&
            store_idmanager(sm,
              idmanager_link(sm, idmanager_add(m, __return), __return, idnode),
              manager))
*/;

void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ Require
      undef_data_at(&(linklist_head->node_prev)) *
      undef_data_at(&(linklist_head->node_next))
    Ensure
      linklist_head != 0 && store_node_self_linked(linklist_head)
 */;

void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ dispatch_case
    With {A} (storeA: addr -> A -> Assertion)
             (nodes: list(DL_Node A)) (a: A) (head: addr)
    Require dll_insert_anchor(head, nodes, linklist) &&
            linklist_node != 0 &&
            store_dll(storeA, head, nodes) *
            storeA(linklist_node, a) *
            occupy_dll_node(linklist_node)
    Ensure store_dll(
             storeA, head,
             dll_insert_after_dispatch(
               head, nodes, linklist,
               Build_DL_Node(a, linklist_node)))
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

void x_free(void *ptr)
/*@ mutex_object
    Require MutexRaw(ptr)
    Ensure emp
 */;

int32 _MutexCreate(void)
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_mutex_create(sg), X) &&
            OutsideCritical(sg, before)
    Ensure
      (exists after,
        __return == -5 &&
        safeExec(LastSeen(after), return(__return), X) &&
        OutsideCritical(sg, after))
      ||
      (exists after,
        0 <= __return && __return < 128 &&
        safeExec(LastSeen(after), return(__return), X) &&
        OutsideCritical(sg, after))
 */
{
    int32 id = 0;
    x_base lock = 0;
    struct Mutex *mutex = NONE;

	mutex = x_malloc(sizeof(struct Mutex));
	if (mutex == NONE) {
		return -ENOMEMORY;
	}

	memset(mutex, 0x0, sizeof(struct Mutex));
    lock = CriticalAreaLock();

    id = IdInsertObj(&k_mutex_id_manager, &mutex->id);
    if (id < 0) {
        CriticalAreaUnLock(lock);
        x_free(mutex);
        return -ENOMEMORY;
    }

	InitDoubleLinkList(&mutex->pend_list);

    mutex->val = 1;
    mutex->holder = NONE;
    mutex->origin_prio = 0xFF;
    mutex->recursive_cnt = 0;

	DoubleLinkListInsertNodeAfter(&k_mutex_list, &mutex->link);
    
    CriticalAreaUnLock(lock);
    
    return id;
}
