#include "../include/crtos_semaphore_layout.h"
#include "../include/semaphore_logic.h"

extern struct IdManager k_sem_id_manager;
extern DoubleLinklistType k_sem_list;

/* Candidate contracts: design only; callees are not yet body-verified. */
/* Trusted boundary: exactly one 32-byte Semaphore allocation. */
void *x_malloc(x_size_t size)
/*@ Require size == 32 && emp
    Ensure (__return == 0 && emp) ||
      (__return != 0 && OSHeap(store_sem_allocated(__return)))
*/;
/* Trusted boundary: complete zero initialization, retaining ownership. */
void *memset(void *dest, int value, x_size_t size)
/*@ Require value == 0 && size == 32 && OSHeap(store_sem_allocated(dest))
    Ensure __return == dest && OSHeap(store_sem_zeroed_private(dest))
*/;
x_base CriticalAreaLock(void)
/*@ With (sg : CrtosOSStable) (hs : list Z) (before : CrtosOSState)
    Require scheduler_lock_nest(os_scheduler(before)) < 65535 &&
      SemaphoreOutsideCritical(sg, hs, before)
    Ensure exists current,
      semaphore_irq_handler_ok(__return) && SemaphoreRely(hs, before, current) &&
      SemaphoreInsideCritical(sg, hs, __return, current) *
      SemaphoreOSInvariant(sg, semaphore_nest_increment(current))
*/;
int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sm : StableIdmanager) (before : VarIdmanager)
         (old_id : Z) (previous : Z) (next : Z)
    Require manager != 0 && idnode != 0 &&
      OSHeap(store_idmanager(sm, before, manager)) *
      OSHeap(store_sem_id_detached(idnode, old_id, previous, next))
    Ensure
      (__return == -1 && idmanager_full(sm, before) &&
        OSHeap(store_idmanager(sm, before, manager)) *
        OSHeap(store_sem_id_detached(idnode, old_id, previous, next))) ||
      (idmanager_min_free_id(sm, before, __return) &&
        OSHeap(store_idmanager(sm,
          idmanager_link(sm, idmanager_add(before, __return), __return, idnode), manager)))
*/;
/* Trusted boundary: consumes the complete zeroed unpublished object. */
void x_free(void *ptr)
/*@ Require OSHeap(store_sem_zeroed_private(ptr))
    Ensure emp
*/;
void CriticalAreaUnLock(x_base lock)
/*@ With (sg : CrtosOSStable) (hs : list Z) (before : CrtosOSState) (after : CrtosOSState)
    Require semaphore_irq_handler_ok(lock) &&
      SemaphoreGuarantee(before, semaphore_nest_decrement(after)) &&
      SemaphoreInsideCritical(sg, hs, lock, before) * SemaphoreOSInvariant(sg, after)
    Ensure SemaphoreOutsideCritical(sg, hs, semaphore_nest_decrement(after))
*/;
void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ With (head : Z)
    Require linklist_head == head && head != 0 &&
      undef_data_at(&(linklist_head->node_next), struct SysDoubleLinklistNode *) *
      undef_data_at(&(linklist_head->node_prev), struct SysDoubleLinklistNode *)
    Ensure
      store(&(linklist_head->node_next), struct SysDoubleLinklistNode *, head) *
      store(&(linklist_head->node_prev), struct SysDoubleLinklistNode *, head)
*/;
void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ With (successor : Z) (previous : Z)
    Require linklist != 0 && linklist_node != 0 && successor != 0 &&
      store(&(linklist->node_next), struct SysDoubleLinklistNode *, successor) *
      store(&(((struct SysDoubleLinklistNode *)successor)->node_prev), struct SysDoubleLinklistNode *, previous) *
      undef_data_at(&(linklist_node->node_next), struct SysDoubleLinklistNode *) *
      undef_data_at(&(linklist_node->node_prev), struct SysDoubleLinklistNode *)
    Ensure
      store(&(linklist->node_next), struct SysDoubleLinklistNode *, linklist_node) *
      store(&(((struct SysDoubleLinklistNode *)successor)->node_prev), struct SysDoubleLinklistNode *, linklist_node) *
      store(&(linklist_node->node_next), struct SysDoubleLinklistNode *, successor) *
      store(&(linklist_node->node_prev), struct SysDoubleLinklistNode *, linklist)
*/;

int32 _SemaphoreCreate(uint16 val)
/*@ With (sg : CrtosOSStable) (hs : list Z) (before : CrtosOSState)
    Require scheduler_lock_nest(os_scheduler(before)) < 65535 &&
      SemaphoreOutsideCritical(sg, hs, before)
    Ensure
      (__return == -5 && SemaphoreOutsideCritical(sg, hs, before)) ||
      (exists current,
        __return == -5 && SemaphoreRely(hs, before, current) &&
        idmanager_full(semaphore_manager_abs(os_sem_stable(sg)),
          semaphore_manager_state(os_sem_stable(sg), os_semaphores(current))) &&
        SemaphoreOutsideCritical(sg, hs, current)) ||
      (exists current p,
        p != 0 && SemaphoreRely(hs, before, current) &&
        idmanager_min_free_id(semaphore_manager_abs(os_sem_stable(sg)),
          semaphore_manager_state(os_sem_stable(sg), os_semaphores(current)), __return) &&
        SemaphoreGuarantee(current, semaphore_os_publish(p, __return, val, current)) &&
        SemaphoreOutsideCritical(sg, hs, semaphore_os_publish(p, __return, val, current)))
*/
{
    int32 id = 0;
    x_base lock = 0;
    struct Semaphore *sem = NONE;

    sem = (struct Semaphore *)x_malloc(sizeof(struct Semaphore));
    if (sem == NONE)
        return -ENOMEMORY;

    memset(sem, 0, sizeof(struct Semaphore));
    lock = CriticalAreaLock() /*@ where sg = sg, hs = hs, before = before */;
    /*@ Given current */
    id = IdInsertObj(&k_sem_id_manager, &sem->id)
      /*@ where sm = semaphore_manager_abs(os_sem_stable(sg)),
                before = semaphore_manager_state(os_sem_stable(sg), os_semaphores(current)),
                old_id = 0, previous = 0, next = 0 */;
    if (id < 0) {
        x_free(sem);
        CriticalAreaUnLock(lock)
          /*@ where sg = sg, hs = hs, before = current, after = semaphore_nest_increment(current) */;
        return -ENOMEMORY;
    }

    sem->value = val;
    InitDoubleLinkList(&sem->pend_list) /*@ where head = &sem->pend_list */;

    
    DoubleLinkListInsertNodeAfter(&k_sem_list, &sem->link)
      /*@ where successor = k_sem_list.node_next,
                previous = k_sem_list.node_next->node_prev */;
    CriticalAreaUnLock(lock)
      /*@ where sg = sg, hs = hs, before = current,
                after = semaphore_nest_increment(semaphore_os_publish(sem, id, val, current)) */;


    return id;
}
