#include "../slice_types.h"
#include "../logic.h"
/*@ Import Coq Require Import CRTOS_Verify.VC.SemaphoreCreate_lib */

/* Existing semantic interfaces used only to expose call-site resources. */
/*@ Extern Coq
      (TaskState :: *)
      (TaskDescriptorAbs :: *)
      (RoleSlotAbs :: *)
      (ZombieQueueAbs :: *)
      (MutexStable :: *)
      (MutexState :: *)
      (MsgQueueStable :: *)
      (MsgQueueState :: *)
      (EventStable :: *)
      (EventState :: *)
      (IsrStable :: *)
      (IsrAbs :: *)
*/
/*@ Extern Coq
      (map : {A} {B} -> (A -> B) -> list A -> list B)
      (In : {A} -> A -> list A -> Prop)
      (os_world_wf : StableGlobalState -> VarGlobalState -> Prop)
      (semaphore_context : SemaphoreStable -> Prop)
      (os_tasks : VarGlobalState -> TaskState)
      (task_desc_map : TaskState -> Z -> option TaskDescriptorAbs)
      (pure_suspend_sched_link : (Z -> option TaskDescriptorAbs) -> Z -> Z -> Assertion)
      (os_zombie_head : StableGlobalState -> Z)
      (zombie_queue : VarGlobalState -> ZombieQueueAbs)
      (os_recycler_slot : StableGlobalState -> Z)
      (os_recycle : VarGlobalState -> RoleSlotAbs)
      (role_id : RoleSlotAbs -> Z)
      (os_idle_array : StableGlobalState -> Z)
      (os_idle : VarGlobalState -> list RoleSlotAbs)
      (CORE_COUNT : Z)
      (os_mutex_stable : StableGlobalState -> MutexStable)
      (os_mutexes : VarGlobalState -> MutexState)
      (os_msgqueue_stable : StableGlobalState -> MsgQueueStable)
      (os_msgqueues : VarGlobalState -> MsgQueueState)
      (os_event_stable : StableGlobalState -> EventStable)
      (os_events : VarGlobalState -> EventState)
      (os_isr_stable : StableGlobalState -> IsrStable)
      (os_isr : VarGlobalState -> IsrAbs)
      (store_prio_lookup_table : Assertion)
      (store_zombie_queue : (Z -> option TaskDescriptorAbs) -> Z -> ZombieQueueAbs -> Assertion)
      (mutex_inv : (Z -> Z -> Assertion) -> MutexStable -> MutexState -> Assertion)
      (msgqueue_inv : (Z -> Z -> Assertion) -> MsgQueueStable -> MsgQueueState -> Assertion)
      (event_inv : (Z -> Z -> Assertion) -> EventStable -> EventState -> Assertion)
      (isrmanager_inv : IsrStable -> IsrAbs -> Assertion)
      (NodeZero : Z -> Assertion)
      (SemaphorePadding : Z -> Assertion)
      (semaphore_created : Z -> Z -> Z -> SemaphoreAbs)
      (semaphore_addr : SemaphoreAbs -> Z)
      (semaphore_link_node : SemaphoreAbs -> DL_Node SemaphoreAbs)
      (store_semaphore : (Z -> Z -> Assertion) -> Z -> SemaphoreAbs -> Assertion)
      (dll_nodes_nonzero : {A} -> list(DL_Node A) -> Prop)
      (dllseg_shift_rev : {A} -> (Z -> A -> Assertion) -> Z -> Z -> list(DL_Node A) -> Assertion)
      (task_inv : StableGlobalState -> VarGlobalState -> Assertion)
      (tick_inv : StableGlobalState -> VarGlobalState -> Assertion)
      (delay_inv : StableGlobalState -> VarGlobalState -> Assertion)
      (assign_inv : StableGlobalState -> VarGlobalState -> Assertion)
      (exstatus_inv : StableGlobalState -> VarGlobalState -> Assertion)
*/


void *x_malloc(x_size_t size)
/*@ delay_object
    Require 0 <= size && size <= UINT_MAX
    Ensure (__return == 0) ||
           (0 < __return &&
            __return <= UINT_MAX - size &&
            addr_aligned(__return, ALIGN_SIZE) &&
            CharArray::undef_full(__return, size))
 */;

void *memset(void *s, int c, size_t n)
/*@ Require 0 <= n && n <= UINT_MAX &&
            0 <= c && c <= 127 &&
            CharArray::undef_full(s, n)
    Ensure __return == s && CharArray::full(s, n, repeat_Z(c, n))
*/;

/* Trusted primitive: TrustBase.md; VRTOS m_ktask.h ordinary/stable spec. */
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
/*@ With (sidm: StableIdmanager) (idm: VarIdmanager)
    Require store_idmanager(sidm, idm, manager) *
            store_idnode_insert_ready(idnode)
    Ensure (__return == -1 &&
            idmanager_first_free_id(sidm, idm) == None &&
            store_idmanager(sidm, idm, manager) *
            store_idnode_insert_ready(idnode))
           ||
           (idmanager_min_free_id(sidm, idm, __return) &&
            store_idmanager(sidm,
              idmanager_link(sidm, idmanager_add(idm, __return), __return, idnode),
              manager))
*/;

/* Trusted KERNEL_FREE macro target (xs_memory.h): reclaim the complete private
 * allocation; its field values need not remain zero after IdInsertObj failure.
 * The caller supplies the original malloc base and all 32 bytes of ownership.
 * This is a trial-specific free interface, not a copied VRTOS helper proof. */
void x_free(void *ptr)
/*@ Require SemaphoreRaw(ptr)
    Ensure emp
*/;

void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ Require
      undef_data_at(&(linklist_head->node_prev)) *
      undef_data_at(&(linklist_head->node_next))
    Ensure
      linklist_head != 0 && store_node_self_linked(linklist_head)
 */;

void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist,
                                   DoubleLinklistType *linklist_node)
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

/* Trusted primitive: TrustBase.md; VRTOS m_ktask.h ordinary/stable spec. */
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

/* Trusted debug removal (TrustBase.md): variadic KPrintf declaration omitted. */

/* Canonical: _SemaphoreCreate. Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/semaphore.c:33. */
int32 _SemaphoreCreate(uint16 val)
/*@ With (sg : StableGlobalState) (before : VarGlobalState) X
    Require
      safeExec(LastSeen(before), abs_semaphore_create(sg, val), X) &&
      OutsideCritical(sg, before)
    Ensure
      (exists after,
        __return == -5 &&
        safeExec(LastSeen(after), return(-5), X) &&
        OutsideCritical(sg, after))
      ||
      (exists after,
        0 <= __return && __return < 128 &&
        safeExec(LastSeen(after), return(__return), X) &&
        OutsideCritical(sg, after))
*/
{
    /*@ 0 <= val && val <= 65535 by local */
    int32 id = 0;
    x_base lock = 0;
    struct Semaphore *sem = (0);

    sem = (struct Semaphore *)x_malloc(32);
    if (sem == (0))
        return -5;

    memset(sem, 0, 32);
    /* Convert the complete zero byte array, retaining embedded-node validity. */
    /*@ Assert val == val@pre && 0 <= val && val <= 65535 &&
      sem != 0 && addr_aligned(sem, 4) &&
      &sem->pend_list != 0 && &sem->link != 0 &&
      id == 0 && lock == 0 &&
      safeExec(LastSeen(before), abs_semaphore_create(sg, val), X) &&
      OutsideCritical(sg, before) * SemaphoreZero(sem)
    */
    lock = CriticalAreaLock();
    /*@ Given st_lock */
    /* Expose the frozen ID interface while framing the complete payload. */
    /*@ Assert exists (saved_lock : Z), lock == saved_lock &&
      val == val@pre && 0 <= val && val <= 65535 &&
      sem != 0 && addr_aligned(sem, 4) &&
      &sem->pend_list != 0 && &sem->link != 0 &&
      Crtos_RTrans(before, st_lock) &&
      safeExec(LastSeen(before), abs_semaphore_create(sg, val), X) && id == 0 &&
      os_world_wf(sg, st_lock) && semaphore_context(os_semaphore_stable(sg)) &&
      !(In(sem, map(semaphore_addr, os_semaphores(st_lock)))) &&
      InsideCritical(sg, st_lock) *
      task_inv(sg, st_lock) * tick_inv(sg, st_lock) * delay_inv(sg, st_lock) *
      assign_inv(sg, st_lock) * store_prio_lookup_table *
      store_zombie_queue(task_desc_map(os_tasks(st_lock)), os_zombie_head(sg), zombie_queue(st_lock)) *
      data_at(os_recycler_slot(sg), int, role_id(os_recycle(st_lock))) *
      IntArray::full(os_idle_array(sg), CORE_COUNT, map(role_id, os_idle(st_lock))) *
      mutex_inv(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock))), os_mutex_stable(sg), os_mutexes(st_lock)) *
      msgqueue_inv(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock))), os_msgqueue_stable(sg), os_msgqueues(st_lock)) *
      event_inv(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock))), os_event_stable(sg), os_events(st_lock)) *
      isrmanager_inv(os_isr_stable(sg), os_isr(st_lock)) * exstatus_inv(sg, st_lock) *
      store_idmanager(semaphore_manager_stable(os_semaphore_stable(sg)), semaphore_manager(os_semaphores(st_lock)), &k_sem_id_manager) *
      store_dll(store_semaphore(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock)))), &k_sem_list, map(semaphore_link_node, os_semaphores(st_lock))) *
      store_idnode_insert_ready(&sem->id) * data_at(&sem->value, unsigned short, 0) *
      NodeZero(&sem->pend_list) * NodeZero(&sem->link) * SemaphorePadding(sem)
    */
    id = IdInsertObj(&k_sem_id_manager, &sem->id);
    if (id < 0) {
        /* The ID API returns unknown-owned fields, sufficient for full reclamation. */
        /*@ Assert exists (saved_lock : Z), lock == saved_lock &&
      val == val@pre && 0 <= val && val <= 65535 &&
      sem != 0 && addr_aligned(sem, 4) &&
      &sem->pend_list != 0 && &sem->link != 0 &&
      Crtos_RTrans(before, st_lock) &&
      safeExec(LastSeen(before), abs_semaphore_create(sg, val), X) && id == -1 &&
      idmanager_full(semaphore_manager_stable(os_semaphore_stable(sg)), semaphore_manager(os_semaphores(st_lock))) &&
      InsideCritical(sg, st_lock) * os_inv(sg, st_lock) * SemaphoreRaw(sem)
        */
        x_free(sem);
        CriticalAreaUnLock(lock);
        return -5;
    }
    sem->value = val;

    /* Expose exactly the pending-list fields overwritten by initialization. */
    /*@ Assert exists (saved_lock : Z), lock == saved_lock &&
      val == val@pre && 0 <= val && val <= 65535 &&
      sem != 0 && addr_aligned(sem, 4) &&
      &sem->pend_list != 0 && &sem->link != 0 &&
      Crtos_RTrans(before, st_lock) &&
      safeExec(LastSeen(before), abs_semaphore_create(sg, val), X) && 0 <= id && id < 128 &&
      idmanager_min_free_id(semaphore_manager_stable(os_semaphore_stable(sg)), semaphore_manager(os_semaphores(st_lock)), id) &&
      os_world_wf(sg, st_lock) && semaphore_context(os_semaphore_stable(sg)) &&
      !(In(sem, map(semaphore_addr, os_semaphores(st_lock)))) &&
      InsideCritical(sg, st_lock) *
      task_inv(sg, st_lock) * tick_inv(sg, st_lock) * delay_inv(sg, st_lock) *
      assign_inv(sg, st_lock) * store_prio_lookup_table *
      store_zombie_queue(task_desc_map(os_tasks(st_lock)), os_zombie_head(sg), zombie_queue(st_lock)) *
      data_at(os_recycler_slot(sg), int, role_id(os_recycle(st_lock))) *
      IntArray::full(os_idle_array(sg), CORE_COUNT, map(role_id, os_idle(st_lock))) *
      mutex_inv(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock))), os_mutex_stable(sg), os_mutexes(st_lock)) *
      msgqueue_inv(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock))), os_msgqueue_stable(sg), os_msgqueues(st_lock)) *
      event_inv(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock))), os_event_stable(sg), os_events(st_lock)) *
      isrmanager_inv(os_isr_stable(sg), os_isr(st_lock)) * exstatus_inv(sg, st_lock) *
      store_idmanager(semaphore_manager_stable(os_semaphore_stable(sg)), idmanager_link(semaphore_manager_stable(os_semaphore_stable(sg)), idmanager_add(semaphore_manager(os_semaphores(st_lock)), id), id, &sem->id), &k_sem_id_manager) *
      store_dll(store_semaphore(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock)))), &k_sem_list, map(semaphore_link_node, os_semaphores(st_lock))) *
      data_at(&sem->value, unsigned short, val) * SemaphorePadding(sem) *
      undef_data_at(&sem->pend_list.node_prev) * undef_data_at(&sem->pend_list.node_next) *
      NodeZero(&sem->link)
    */
    InitDoubleLinkList(&sem->pend_list);
    /* Pack the newly initialized payload for VRTOS's complete-DLL interface. */
    /*@ Assert exists (saved_lock : Z), lock == saved_lock &&
      val == val@pre && 0 <= val && val <= 65535 &&
      sem != 0 && addr_aligned(sem, 4) &&
      &sem->pend_list != 0 && &sem->link != 0 &&
      Crtos_RTrans(before, st_lock) &&
      safeExec(LastSeen(before), abs_semaphore_create(sg, val), X) && 0 <= id && id < 128 &&
      idmanager_min_free_id(semaphore_manager_stable(os_semaphore_stable(sg)), semaphore_manager(os_semaphores(st_lock)), id) &&
      os_world_wf(sg, st_lock) && semaphore_context(os_semaphore_stable(sg)) &&
      !(In(sem, map(semaphore_addr, os_semaphores(st_lock)))) &&
      InsideCritical(sg, st_lock) *
      task_inv(sg, st_lock) * tick_inv(sg, st_lock) * delay_inv(sg, st_lock) *
      assign_inv(sg, st_lock) * store_prio_lookup_table *
      store_zombie_queue(task_desc_map(os_tasks(st_lock)), os_zombie_head(sg), zombie_queue(st_lock)) *
      data_at(os_recycler_slot(sg), int, role_id(os_recycle(st_lock))) *
      IntArray::full(os_idle_array(sg), CORE_COUNT, map(role_id, os_idle(st_lock))) *
      mutex_inv(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock))), os_mutex_stable(sg), os_mutexes(st_lock)) *
      msgqueue_inv(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock))), os_msgqueue_stable(sg), os_msgqueues(st_lock)) *
      event_inv(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock))), os_event_stable(sg), os_events(st_lock)) *
      isrmanager_inv(os_isr_stable(sg), os_isr(st_lock)) * exstatus_inv(sg, st_lock) *
      store_idmanager(semaphore_manager_stable(os_semaphore_stable(sg)), idmanager_link(semaphore_manager_stable(os_semaphore_stable(sg)), idmanager_add(semaphore_manager(os_semaphores(st_lock)), id), id, &sem->id), &k_sem_id_manager) *
      store_dll(store_semaphore(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock)))), &k_sem_list, map(semaphore_link_node, os_semaphores(st_lock))) *
      store_semaphore(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock))), &sem->link, semaphore_created(sem, id, val)) *
      occupy_dll_node(&sem->link)
    */
    DoubleLinkListInsertNodeAfter(&k_sem_list, &sem->link)
        /*@ where (dispatch_case)
              storeA = store_semaphore(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock)))),
              nodes = map(semaphore_link_node, os_semaphores(st_lock)),
              a = semaphore_created(sem, id, val), head = &k_sem_list;
              A = SemaphoreAbs */;
    /* Restore the complete invariant for the newly published abstract object. */
    /*@ Assert exists (saved_lock : Z), lock == saved_lock &&
      val == val@pre && 0 <= val && val <= 65535 &&
      sem != 0 && addr_aligned(sem, 4) &&
      &sem->pend_list != 0 && &sem->link != 0 &&
      Crtos_RTrans(before, st_lock) &&
      safeExec(LastSeen(before), abs_semaphore_create(sg, val), X) && 0 <= id && id < 128 &&
      idmanager_min_free_id(semaphore_manager_stable(os_semaphore_stable(sg)), semaphore_manager(os_semaphores(st_lock)), id) &&
      !(In(sem, map(semaphore_addr, os_semaphores(st_lock)))) &&
      Crtos_GTrans(st_lock, replace_semaphores(semaphore_publish(sem, id, val, os_semaphores(st_lock)), st_lock)) &&
      InsideCritical(sg, st_lock) * os_inv(sg, replace_semaphores(semaphore_publish(sem, id, val, os_semaphores(st_lock)), st_lock))
    */
    CriticalAreaUnLock(lock);

    return id;
}
