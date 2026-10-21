#include "../slice_types.h"
#include "../logic.h"

/* Existing semantic interfaces used only to expose call-site resources. */
/*@ Extern Coq
      (DL_Node :: * => *)
      (option :: * => *)
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
      (addr_aligned : Z -> Z -> Prop)
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
      (semaphore_addr : SemaphoreAbs -> Z)
      (semaphore_link_node : SemaphoreAbs -> DL_Node SemaphoreAbs)
      (store_semaphore : (Z -> Z -> Assertion) -> Z -> SemaphoreAbs -> Assertion)
      (store_dll : {A} -> (Z -> A -> Assertion) -> Z -> list(DL_Node A) -> Assertion)
      (dllseg_shift_rev : {A} -> (Z -> A -> Assertion) -> Z -> Z -> list(DL_Node A) -> Assertion)
      (task_inv : StableGlobalState -> VarGlobalState -> Assertion)
      (tick_inv : StableGlobalState -> VarGlobalState -> Assertion)
      (delay_inv : StableGlobalState -> VarGlobalState -> Assertion)
      (assign_inv : StableGlobalState -> VarGlobalState -> Assertion)
      (exstatus_inv : StableGlobalState -> VarGlobalState -> Assertion)
*/

void *x_malloc(x_size_t nbytes)
/*@ Require nbytes == 32 && emp
    Ensure (__return == 0 && emp) ||
      (__return != 0 && SemaphoreRaw(__return))
*/;

void *memset(void *dest, int c, size_t n)
/*@ Require c == 0 && n == 32 && SemaphoreRaw(dest)
    Ensure __return == dest && SemaphoreZero(dest)
*/;

/* Trusted primitive: TrustBase.md; VRTOS m_ktask.h ordinary/stable spec. */
x_base CriticalAreaLock(void)
/*@ With (sg : StableGlobalState) (before : VarGlobalState)
    Require OutsideCritical(sg, before)
    Ensure exists locked,
      Crtos_RTrans(before, locked) &&
      InsideCritical(sg, locked) * os_inv(sg, locked)
*/;

int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sidm : StableIdmanager) (before : VarIdmanager)
    Require manager != 0 && idnode != 0 &&
      store_idmanager(sidm, before, manager) * ZeroIdNode(idnode)
    Ensure
      (__return == -1 && idmanager_full(sidm, before) &&
        store_idmanager(sidm, before, manager) * ZeroIdNode(idnode))
      ||
      (0 <= __return && __return < sidm.idmax &&
        idmanager_min_free_id(sidm, before, __return) &&
        store_idmanager(sidm,
          idmanager_link(sidm, idmanager_add(before, __return), __return, idnode),
          manager))
*/;

void x_free(void *ptr)
/*@ Require SemaphoreZero(ptr)
    Ensure emp
*/;

void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ Require NodeStorage(linklist_head)
    Ensure store_node_self_linked(linklist_head)
*/;

void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ With (next : Z) (oldprev : Z) (oldnext : Z)
    Require DllInsertAfterCut(linklist, next, linklist_node, oldprev, oldnext)
    Ensure DllInsertedCut(linklist, next, linklist_node)
*/;

/* Trusted primitive: TrustBase.md; VRTOS m_ktask.h ordinary/stable spec. */
void CriticalAreaUnLock(x_base lock)
/*@ With (sg : StableGlobalState) (locked : VarGlobalState)
         (after : VarGlobalState)
    Require Crtos_GTrans(locked, after) &&
      InsideCritical(sg, locked) * os_inv(sg, after)
    Ensure OutsideCritical(sg, after)
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
    sem = (struct Semaphore *)x_malloc(sizeof(struct Semaphore));
    if (sem == (0))
        return -5;
    memset(sem, 0, sizeof(struct Semaphore));
    lock = CriticalAreaLock() /*@ where sg = sg, before = before */;
    /*@ Given locked */
    /* Expose the ID manager and private zeroed fields required by the helper. */
    /*@ Assert exists (saved_lock : Z), lock == saved_lock &&
      val == val@pre && 0 <= val && val <= 65535 &&
      sem != 0 && addr_aligned(sem, 4) &&
      Crtos_RTrans(before, locked) &&
      safeExec(LastSeen(before), abs_semaphore_create(sg, val), X) && id == 0 &&
      os_world_wf(sg, locked) && semaphore_context(os_semaphore_stable(sg)) &&
      !(In(sem, map(semaphore_addr, os_semaphores(locked)))) &&
      InsideCritical(sg, locked) *
      task_inv(sg, locked) * tick_inv(sg, locked) * delay_inv(sg, locked) *
      assign_inv(sg, locked) * store_prio_lookup_table *
      store_zombie_queue(task_desc_map(os_tasks(locked)), os_zombie_head(sg), zombie_queue(locked)) *
      data_at(os_recycler_slot(sg), int, role_id(os_recycle(locked))) *
      IntArray::full(os_idle_array(sg), CORE_COUNT, map(role_id, os_idle(locked))) *
      mutex_inv(pure_suspend_sched_link(task_desc_map(os_tasks(locked))), os_mutex_stable(sg), os_mutexes(locked)) *
      msgqueue_inv(pure_suspend_sched_link(task_desc_map(os_tasks(locked))), os_msgqueue_stable(sg), os_msgqueues(locked)) *
      event_inv(pure_suspend_sched_link(task_desc_map(os_tasks(locked))), os_event_stable(sg), os_events(locked)) *
      isrmanager_inv(os_isr_stable(sg), os_isr(locked)) * exstatus_inv(sg, locked) *
      store_idmanager(semaphore_manager_stable(os_semaphore_stable(sg)), semaphore_manager(os_semaphores(locked)), &k_sem_id_manager) *
      store_dll(store_semaphore(pure_suspend_sched_link(task_desc_map(os_tasks(locked)))), &k_sem_list, map(semaphore_link_node, os_semaphores(locked))) *
      ZeroIdNode(&sem->id) * data_at(&sem->value, unsigned short, 0) *
      NodeZero(&sem->pend_list) * NodeZero(&sem->link) * SemaphorePadding(sem)
    */
    id = IdInsertObj(&k_sem_id_manager, &sem->id)
        /*@ where sidm = semaphore_manager_stable(os_semaphore_stable(sg)),
                  before = semaphore_manager(os_semaphores(locked)) */;
    if (id < 0) {
        /* Reassemble the unchanged world and full private allocation on failure. */
        /*@ Assert exists (saved_lock : Z), lock == saved_lock &&
      val == val@pre && 0 <= val && val <= 65535 &&
      sem != 0 && addr_aligned(sem, 4) &&
      Crtos_RTrans(before, locked) &&
      safeExec(LastSeen(before), abs_semaphore_create(sg, val), X) && id == -1 &&
          idmanager_full(semaphore_manager_stable(os_semaphore_stable(sg)), semaphore_manager(os_semaphores(locked))) &&
          InsideCritical(sg, locked) * os_inv(sg, locked) * SemaphoreZero(sem)
        */
        x_free(sem);
        CriticalAreaUnLock(lock) /*@ where sg = sg, locked = locked, after = locked */;
        return -5;
    }
    sem->value = val;
    /* Expose the empty pending list and insertion cut, preserving the old DLL tail. */
    /*@ Assert exists (saved_lock : Z), lock == saved_lock &&
      val == val@pre && 0 <= val && val <= 65535 &&
      sem != 0 && addr_aligned(sem, 4) &&
      Crtos_RTrans(before, locked) &&
      safeExec(LastSeen(before), abs_semaphore_create(sg, val), X) && 0 <= id && id < 128 &&
      idmanager_min_free_id(semaphore_manager_stable(os_semaphore_stable(sg)), semaphore_manager(os_semaphores(locked)), id) &&
      os_world_wf(sg, locked) && semaphore_context(os_semaphore_stable(sg)) &&
      !(In(sem, map(semaphore_addr, os_semaphores(locked)))) &&
      InsideCritical(sg, locked) *
      task_inv(sg, locked) * tick_inv(sg, locked) * delay_inv(sg, locked) *
      assign_inv(sg, locked) * store_prio_lookup_table *
      store_zombie_queue(task_desc_map(os_tasks(locked)), os_zombie_head(sg), zombie_queue(locked)) *
      data_at(os_recycler_slot(sg), int, role_id(os_recycle(locked))) *
      IntArray::full(os_idle_array(sg), CORE_COUNT, map(role_id, os_idle(locked))) *
      mutex_inv(pure_suspend_sched_link(task_desc_map(os_tasks(locked))), os_mutex_stable(sg), os_mutexes(locked)) *
      msgqueue_inv(pure_suspend_sched_link(task_desc_map(os_tasks(locked))), os_msgqueue_stable(sg), os_msgqueues(locked)) *
      event_inv(pure_suspend_sched_link(task_desc_map(os_tasks(locked))), os_event_stable(sg), os_events(locked)) *
      isrmanager_inv(os_isr_stable(sg), os_isr(locked)) * exstatus_inv(sg, locked) *
      store_idmanager(semaphore_manager_stable(os_semaphore_stable(sg)), idmanager_link(semaphore_manager_stable(os_semaphore_stable(sg)), idmanager_add(semaphore_manager(os_semaphores(locked)), id), id, &sem->id), &k_sem_id_manager) *
      dllseg_shift_rev(store_semaphore(pure_suspend_sched_link(task_desc_map(os_tasks(locked)))), semaphore_first_link(os_semaphore_stable(sg), os_semaphores(locked)), &k_sem_list, map(semaphore_link_node, os_semaphores(locked))) *
      DllInsertAfterCut(&k_sem_list, semaphore_first_link(os_semaphore_stable(sg), os_semaphores(locked)), &sem->link, 0, 0) *
      data_at(&sem->value, unsigned short, val) * NodeStorage(&sem->pend_list) * SemaphorePadding(sem)
    */
    InitDoubleLinkList(&sem->pend_list);
    DoubleLinkListInsertNodeAfter(&k_sem_list, &sem->link)
        /*@ where next = semaphore_first_link(os_semaphore_stable(sg), os_semaphores(locked)),
                  oldprev = 0, oldnext = 0 */;
    /* Publish the new object by restoring the complete invariant before unlocking. */
    /*@ Assert exists (saved_lock : Z), lock == saved_lock &&
      val == val@pre && 0 <= val && val <= 65535 &&
      sem != 0 && addr_aligned(sem, 4) &&
      Crtos_RTrans(before, locked) &&
      safeExec(LastSeen(before), abs_semaphore_create(sg, val), X) && 0 <= id && id < 128 &&
      idmanager_min_free_id(semaphore_manager_stable(os_semaphore_stable(sg)), semaphore_manager(os_semaphores(locked)), id) &&
      !(In(sem, map(semaphore_addr, os_semaphores(locked)))) &&
      Crtos_GTrans(locked, replace_semaphores(semaphore_publish(sem, id, val, os_semaphores(locked)), locked)) &&
      InsideCritical(sg, locked) * os_inv(sg, replace_semaphores(semaphore_publish(sem, id, val, os_semaphores(locked)), locked))
    */
    CriticalAreaUnLock(lock)
        /*@ where sg = sg, locked = locked,
                  after = replace_semaphores(semaphore_publish(sem, id, val, os_semaphores(locked)), locked) */;
    /* Trusted debug removal (TrustBase.md): disabled if (0) KPrintf macro omitted. */
    return id;
}
