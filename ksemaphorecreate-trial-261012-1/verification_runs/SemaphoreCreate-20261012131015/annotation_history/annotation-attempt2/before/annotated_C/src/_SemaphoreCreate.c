#include "../include/crtos_semaphore_layout.h"
#include "../include/semaphore_logic.h"

/*@ Import Coq Require Import Coq.Program.Basics */
/*@ Extern Coq (VarGlobalState :: *) (SemaphoreObject :: *) (DL_Node :: * => *) */
/*@ Extern Coq
    (Basics::const : (SemaphoreObject -> Task_C_Rules::expr) -> Z -> SemaphoreObject -> Task_C_Rules::expr)
    (map : (DL_Node SemaphoreObject -> SemaphoreObject) -> list (DL_Node SemaphoreObject) -> SemaphoreState)
    (In : {A} -> A -> list A -> Prop)
    (data : {A} -> DL_Node A -> A)
    (ptr : {A} -> DL_Node A -> Z)
    (semaphore_addr : SemaphoreObject -> Z)
    (store_semaphore_body : SemaphoreObject -> Task_C_Rules::expr)
    (DLL::dll_nodes_nonzero : {A} -> list (DL_Node A) -> Prop)
    (DLL::dllseg_shift_rev : {A} -> (Z -> A -> Task_C_Rules::expr) -> Z -> Z -> list (DL_Node A) -> Task_C_Rules::expr)
    (os_tasks : CrtosOSState -> VarGlobalState)
    (CrtosBorrowedRep::store_task_semaphore_views : VarGlobalState -> Task_C_Rules::expr)
    (CrtosBorrowedRep::store_scheduler_view : SchedulerState -> Task_C_Rules::expr)
    (store_sem_registry : SemaphoreStable -> SemaphoreState -> Task_C_Rules::expr)
    (store_sem_registered_private : Z -> Task_C_Rules::expr)
    (store_sem_padding : Z -> Task_C_Rules::expr)
    (semaphore_object_addresses : Z -> Prop)
*/

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
    lock = CriticalAreaLock();
    /*@ Given current */
    /*@ Assert
      val == val@pre && id == 0 && sem != 0 && &k_sem_id_manager != 0 && &(sem->id) != 0 &&
      semaphore_irq_handler_ok(lock) && SemaphoreRely(hs, before, current) &&
      scheduler_lock_nest(os_scheduler(before)) < 65535 &&
      CrtosOSValid(semaphore_nest_increment(current)) &&
      SemaphoreInsideCritical(sg, hs, lock, current) *
      OSHeap(CrtosBorrowedRep::store_task_semaphore_views(os_tasks(current))) *
      OSHeap(CrtosBorrowedRep::store_scheduler_view(os_scheduler(semaphore_nest_increment(current)))) *
      OSHeap(store_idmanager(semaphore_manager_abs(os_sem_stable(sg)),
        semaphore_manager_state(os_sem_stable(sg), os_semaphores(current)), &k_sem_id_manager)) *
      OSHeap(store_sem_registry(os_sem_stable(sg), os_semaphores(current))) *
      OSHeap(store_sem_id_detached(&sem->id, 0, 0, 0)) *
      OSHeap(store_sem_registered_private(sem)) */
    id = IdInsertObj(&k_sem_id_manager, &sem->id);
    if (id < 0) {
        /*@ Assert
          val == val@pre && id == -1 && sem != 0 && semaphore_irq_handler_ok(lock) &&
          SemaphoreRely(hs, before, current) &&
          idmanager_full(semaphore_manager_abs(os_sem_stable(sg)),
            semaphore_manager_state(os_sem_stable(sg), os_semaphores(current))) &&
          SemaphoreGuarantee(current, semaphore_nest_decrement(semaphore_nest_increment(current))) &&
          SemaphoreInsideCritical(sg, hs, lock, current) *
          SemaphoreOSInvariant(sg, semaphore_nest_increment(current)) *
          OSHeap(store_sem_zeroed_private(sem)) */
        x_free(sem);
        CriticalAreaUnLock(lock);
        return -ENOMEMORY;
    }

    /*@ Assert
      val == val@pre && sem != 0 && semaphore_object_addresses(sem) &&
      &(sem->pend_list) != 0 && &(sem->link) != 0 &&
      semaphore_irq_handler_ok(lock) && SemaphoreRely(hs, before, current) &&
      scheduler_lock_nest(os_scheduler(before)) < 65535 &&
      CrtosOSValid(semaphore_nest_increment(current)) &&
      idmanager_min_free_id(semaphore_manager_abs(os_sem_stable(sg)),
        semaphore_manager_state(os_sem_stable(sg), os_semaphores(current)), id) &&
      SemaphoreInsideCritical(sg, hs, lock, current) *
      OSHeap(CrtosBorrowedRep::store_task_semaphore_views(os_tasks(current))) *
      OSHeap(CrtosBorrowedRep::store_scheduler_view(os_scheduler(semaphore_nest_increment(current)))) *
      OSHeap(store_idmanager(semaphore_manager_abs(os_sem_stable(sg)),
        idmanager_link(semaphore_manager_abs(os_sem_stable(sg)),
          idmanager_add(semaphore_manager_state(os_sem_stable(sg), os_semaphores(current)), id), id, &sem->id),
        &k_sem_id_manager)) *
      OSHeap(store_sem_registry(os_sem_stable(sg), os_semaphores(current))) *
      store(&(sem->value), unsigned short, 0) *
      undef_data_at(&(sem->pend_list.node_prev), struct SysDoubleLinklistNode *) *
      undef_data_at(&(sem->pend_list.node_next), struct SysDoubleLinklistNode *) *
      undef_data_at(&(sem->link.node_prev), struct SysDoubleLinklistNode *) *
      undef_data_at(&(sem->link.node_next), struct SysDoubleLinklistNode *) *
      OSHeap(store_sem_padding(sem)) */
    sem->value = val;
    InitDoubleLinkList(&sem->pend_list);

    
    /*@ Assert exists (nodes : list (DL_Node SemaphoreObject)) (successor : Z),
      map(data, nodes) == os_semaphores(current) &&
      (forall (node : DL_Node SemaphoreObject), In(node, nodes) =>
        ptr(node) == &(((struct Semaphore *)semaphore_addr(data(node)))->link)) &&
      DLL::dll_nodes_nonzero(nodes) &&
      &k_sem_list != 0 && successor != 0 &&
      val == val@pre && sem != 0 && semaphore_object_addresses(sem) &&
      &(sem->pend_list) != 0 && &(sem->link) != 0 &&
      semaphore_irq_handler_ok(lock) && SemaphoreRely(hs, before, current) &&
      scheduler_lock_nest(os_scheduler(before)) < 65535 &&
      CrtosOSValid(semaphore_nest_increment(current)) &&
      idmanager_min_free_id(semaphore_manager_abs(os_sem_stable(sg)),
        semaphore_manager_state(os_sem_stable(sg), os_semaphores(current)), id) &&
      SemaphoreInsideCritical(sg, hs, lock, current) *
      OSHeap(CrtosBorrowedRep::store_task_semaphore_views(os_tasks(current))) *
      OSHeap(CrtosBorrowedRep::store_scheduler_view(os_scheduler(semaphore_nest_increment(current)))) *
      OSHeap(store_idmanager(semaphore_manager_abs(os_sem_stable(sg)),
        idmanager_link(semaphore_manager_abs(os_sem_stable(sg)),
          idmanager_add(semaphore_manager_state(os_sem_stable(sg), os_semaphores(current)), id), id, &sem->id),
        &k_sem_id_manager)) *
      store(&(k_sem_list.node_next), struct SysDoubleLinklistNode *, successor) *
      store(&(((struct SysDoubleLinklistNode *)successor)->node_prev), struct SysDoubleLinklistNode *, &k_sem_list) *
      OSHeap(DLL::dllseg_shift_rev(Basics::const(store_semaphore_body), successor, &k_sem_list, nodes)) *
      store(&(sem->value), unsigned short, val) *
      store(&(sem->pend_list.node_prev), struct SysDoubleLinklistNode *, &sem->pend_list) *
      store(&(sem->pend_list.node_next), struct SysDoubleLinklistNode *, &sem->pend_list) *
      undef_data_at(&(sem->link.node_prev), struct SysDoubleLinklistNode *) *
      undef_data_at(&(sem->link.node_next), struct SysDoubleLinklistNode *) *
      OSHeap(store_sem_padding(sem)) */
    DoubleLinkListInsertNodeAfter(&k_sem_list, &sem->link);
    /*@ Assert
      val == val@pre && sem != 0 && semaphore_irq_handler_ok(lock) &&
      SemaphoreRely(hs, before, current) &&
      idmanager_min_free_id(semaphore_manager_abs(os_sem_stable(sg)),
        semaphore_manager_state(os_sem_stable(sg), os_semaphores(current)), id) &&
      SemaphoreGuarantee(current, semaphore_os_publish(sem, id, val, current)) &&
      SemaphoreGuarantee(current, semaphore_nest_decrement(
        semaphore_nest_increment(semaphore_os_publish(sem, id, val, current)))) &&
      SemaphoreInsideCritical(sg, hs, lock, current) *
      SemaphoreOSInvariant(sg, semaphore_nest_increment(semaphore_os_publish(sem, id, val, current))) */
    CriticalAreaUnLock(lock);


    return id;
}
