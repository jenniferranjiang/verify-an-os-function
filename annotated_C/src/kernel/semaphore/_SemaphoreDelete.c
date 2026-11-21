/* Source: /home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/semaphore.c; SHA-256 dafd02bf7c6fa5a7324c6e0f824d9a1ddc1544c43f9e71aabeb902d832f30ab8.
 * Selected 32-bit non-SMP config: KERNEL_STATIC_OBJECTS and KERNEL_DEFER_IPC_SCHED undefined. */
/* One canonical body, with selectable calling context.
 * CRTOS_DATAQUEUE_SEMAPHORE_IC defaults to 1 for this dataqueue verification.
 * Define it as 0 to retain the original OC contracts, annotations and locks.
 * IC uses the reviewed dataqueue contract and removes only nested lock/unlock
 * operations under the source-processing rule; all other C paths are shared.
 * Selecting a contract is not an implementation-proof result.
 */
#ifndef CRTOS_DATAQUEUE_SEMAPHORE_IC
#define CRTOS_DATAQUEUE_SEMAPHORE_IC 1
#endif
#if CRTOS_DATAQUEUE_SEMAPHORE_IC
#include "dataqueue.h"
#include "dataqueue_semaphore_logic.h"

/*@ Extern Coq (SemaphoreStable :: *) (SemaphoreAbs :: *) */
/*@ Extern Coq SemaphoreState := list SemaphoreAbs */
/*@ Extern Coq
 (os_semaphores : VarGlobalState -> SemaphoreState)
 (os_semaphore_stable : StableGlobalState -> SemaphoreStable)
 (semaphore_manager_stable : SemaphoreStable -> StableIdmanager)
 (semaphore_manager : SemaphoreState -> VarIdmanager)
 (dataqueue_inv : SemaphoreState -> DataqueueState -> Assertion)
*/
/*@ Extern Coq Record VarGlobalState {
  os_semaphores: SemaphoreState;
} */
/*@ Extern Coq Record StableGlobalState {
  os_semaphore_stable: SemaphoreStable;
} */
/*@ Extern Coq Record SemaphoreStable {
  semaphore_manager_stable: StableIdmanager;
} */
/* Existing semantic interfaces used only to expose call-site resources. */
/*@ Extern Coq
      (TaskState :: *)
      (TaskDescriptorAbs :: *)
      (ServiceSlotAbs :: *)
      (ZombieQueueAbs :: *)
      (MutexStable :: *)
      (MutexState :: *)
      (EventStable :: *)
      (EventState :: *)
      (IsrStable :: *)
      (IsrAbs :: *)
*/
/*@ Extern Coq
      (os_world_wf : StableGlobalState -> VarGlobalState -> Prop)
      (semaphore_context : SemaphoreStable -> Prop)
      (os_tasks : VarGlobalState -> TaskState)
      (task_desc_map : TaskState -> Z -> option TaskDescriptorAbs)
      (pure_suspend_sched_link : (Z -> option TaskDescriptorAbs) -> Z -> Z -> Assertion)
      (os_zombie_head : StableGlobalState -> Z)
      (zombie_queue : VarGlobalState -> ZombieQueueAbs)
      (os_recycler_slot : StableGlobalState -> Z)
      (os_recycle : VarGlobalState -> ServiceSlotAbs)
      (service_id : ServiceSlotAbs -> Z)
      (os_idle_array : StableGlobalState -> Z)
      (os_idle : VarGlobalState -> list ServiceSlotAbs)
      (CORE_COUNT : Z)
      (os_mutex_stable : StableGlobalState -> MutexStable)
      (os_mutexes : VarGlobalState -> MutexState)
      (os_event_stable : StableGlobalState -> EventStable)
      (os_events : VarGlobalState -> EventState)
      (os_isr_stable : StableGlobalState -> IsrStable)
      (os_isr : VarGlobalState -> IsrAbs)
      (store_prio_lookup_table : Assertion)
      (store_zombie_queue : (Z -> option TaskDescriptorAbs) -> Z -> ZombieQueueAbs -> Assertion)
      (mutex_inv : (Z -> Z -> Assertion) -> MutexStable -> MutexState -> Assertion)
      (event_inv : (Z -> Z -> Assertion) -> EventStable -> EventState -> Assertion)
      (isrmanager_inv : IsrStable -> IsrAbs -> Assertion)
      (semaphore_addr : SemaphoreAbs -> Z)
      (semaphore_link_node : SemaphoreAbs -> DL_Node SemaphoreAbs)
      (store_semaphore : (Z -> Z -> Assertion) -> Z -> SemaphoreAbs -> Assertion)
      (task_inv : StableGlobalState -> VarGlobalState -> Assertion)
      (tick_inv : StableGlobalState -> VarGlobalState -> Assertion)
      (delay_inv : StableGlobalState -> VarGlobalState -> Assertion)
      (assign_inv : StableGlobalState -> VarGlobalState -> Assertion)
      (exstatus_inv : StableGlobalState -> VarGlobalState -> Assertion)
*/
/*@ Extern Coq Record VarGlobalState {
  os_tasks: TaskState;
  zombie_queue: ZombieQueueAbs;
  os_recycle: ServiceSlotAbs;
  os_idle: list ServiceSlotAbs;
  os_mutexes: MutexState;
  os_events: EventState;
  os_isr: IsrAbs;
} */
/*@ Extern Coq Record TaskState {
  task_desc_map: Z -> option TaskDescriptorAbs;
} */
/*@ Extern Coq Record StableGlobalState {
  os_zombie_head: Z;
  os_recycler_slot: Z;
  os_idle_array: Z;
  os_mutex_stable: MutexStable;
  os_event_stable: EventStable;
  os_isr_stable: IsrStable;
} */
/*@ Extern Coq Record ServiceSlotAbs {
  service_id: Z;
} */
/*@ Extern Coq Record SemaphoreAbs {
  semaphore_addr: Z;
} */

/*@ Extern Coq
 (true : bool) (false : bool)
 (wand : Assertion -> Assertion -> Assertion)
 (store_ushort : Z -> Z -> Assertion)
 (NoDup : {A} -> list A -> Prop)
 (semaphore_id : SemaphoreAbs -> Z)
 (semaphore_value : SemaphoreAbs -> Z)
 (semaphore_pending_addrs : SemaphoreAbs -> list Z)
*/
/*@ Extern Coq Record SemaphoreAbs {
  semaphore_id: Z;
  semaphore_value: Z;
  semaphore_pending_addrs: list Z;
} */

/* Current source: kernel/thread/semaphore.c; non-SMP ILP32.
 * New IC contract for dataqueue's existing locked call site. The global
 * OC contract and IC specialization remain separate design interfaces.
 */

/* reused-spec: annotated_C/src/kernel/id/IdGetObj.c; IdGetObj.
 * Source SHA-256: 6f5447b61e00e565c578815331e1b9c4d777a6b70e17f6a653a73dc6f9349cae.
 * Contract imported with the current predicate names; body/proof status is not
 * a reason to add a local implementation target. See .docs/Report/dataqueue/2026-11-16-InitDataqueue-DataqueuePeak/design.md. */
struct IdNode *IdGetObj(struct IdManager *manager, uint16 id)
/*@ dataqueue_ic_import
    With (sm: StableIdmanager) (m: VarIdmanager)
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
*/;

/* TrustBase CONTAINER_OF model: exact embedding, no dereference permission. */
struct Semaphore *CONTAINER_OF_SEMAPHORE_ID(struct IdNode *id_ptr)
/*@ dataqueue_ic_import
    With (sem_ptr : Z)
    Require id_ptr == field_addr(sem_ptr, struct Semaphore, id) && emp
    Ensure __return == sem_ptr && id_ptr == &(__return->id) && emp
*/;

/* reused-spec: annotated_C/src/kernel/list/IsDoubleLinkListEmpty.c; IsDoubleLinkListEmpty.
 * Source SHA-256: 4b22b601357f81ec24f89cdcfd28a186b27fc7d9db2c7930811c5cc9b14ef1ca.
 * Contract imported with the current predicate names; body/proof status is not
 * a reason to add a local implementation target. See .docs/Report/dataqueue/2026-11-16-InitDataqueue-DataqueuePeak/design.md. */
int IsDoubleLinkListEmpty(const DoubleLinklistType *linklist)
/*@ dataqueue_ic_dll
    With {A} (storeA : Z -> A -> Assertion)
             (nodes : list(DL_Node A))
    Require
      store_dll(storeA, linklist, nodes)
    Ensure
      ((__return == 1 && nodes == nil) ||
       (__return == 0 && nodes != nil)) &&
      store_dll(storeA, linklist, nodes)
 */;

/* reused-spec: annotated_C/src/kernel/semaphore/LinklistResumeAll.c / semaphore_waiters.
 * Source SHA-256: 29ca9f354357150f450eed11198bff152a258c1611f8a3e3d153330f70a13b05.
 * Native shared-state effect preserves the dataqueue component. Its adaptation
 * obligations remain explicit. The nonempty branch is retained but unreachable
 * under dataqueue_cleanup_ic's empty-pending guard. */
x_err_t LinklistResumeAll(DoubleLinklistType *list)
/*@ dataqueue_ic_semaphore_waiters
    With (sg : StableGlobalState) (before : VarGlobalState)
         (sem : Z) (waiting : list Z)
    Require list == semaphore_pending_head(sem) &&
      semaphore_pending_nodes_ic(sem, before, map(sched_link_node, waiting)) && os_inv(sg, before)
    Ensure __return == 0 && exists after,
      semaphore_resume_all_ic_effect(sem, waiting, before, after) &&
      semaphore_pending_nodes_ic(sem, after, nil) && os_inv(sg, after)
*/;

/* reused-spec: annotated_C/src/kernel/id/IdRemoveObj.c; IdRemoveObj / low_level_spec.
 * Source SHA-256: 5694b0d103788e448d12bb48a1090312f54e0760c2fc09bf6c576e5104a49bf7.
 * Contract imported with the current predicate names; body/proof status is not
 * a reason to add a local implementation target. See .docs/Report/dataqueue/2026-11-16-InitDataqueue-DataqueuePeak/design.md. */
void IdRemoveObj(struct IdManager *manager, uint16 id)
/*@ dataqueue_ic_low_level_spec
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
              store(field_addr(field_addr(idnode, struct IdNode, link), struct SysDoubleLinklistNode, node_prev), void *, field_addr(idnode, struct IdNode, link)) *
              store(field_addr(field_addr(idnode, struct IdNode, link), struct SysDoubleLinklistNode, node_next), void *, field_addr(idnode, struct IdNode, link)))
*/;

/* reused-spec: annotated_C/src/headers/m_double_linklist.h; DoubleLinkListRmNode / remove_member.
 * Source SHA-256: 8e67a7da9673c31ca64c330eac42066d37ef2c6257c7323792659a6580435a40.
 * Contract imported with the current predicate names; body/proof status is not
 * a reason to add a local implementation target. See .docs/Report/dataqueue/2026-11-16-InitDataqueue-DataqueuePeak/design.md. */
void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
/*@ dataqueue_ic_remove_member
    With {A} (storeA: addr -> A -> Assertion)
             (head: addr) (a: A)
             (prefix: list(DL_Node A))
             (suffix: list(DL_Node A))
    Require store_dll(storeA, head,
              app(prefix, cons(Build_DL_Node(a, linklist_node), suffix)))
    Ensure store_dll(storeA, head, app(prefix, suffix)) *
           storeA(linklist_node, a) *
           store_node_self_linked(linklist_node)
*/;

/* Source-processing model: empty critical section, current shared protocol. */
void KTASK_ASSIGN(void)
/*@ dataqueue_ic_outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_ktask_assign, X) && OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
*/;
/* KERNEL_FREE exact macro target; entire original allocation is returned. */
void x_free(void *p)
/*@ dataqueue_ic_import
    With n
    Require p != 0 && 0 < n && CharArray::undef_full(p, n)
    Ensure emp
*/;


#else


/* OC input: existing contracts/annotations retained; latest-source adaptations marked below. */
#include "m_semaphore.h"
#include "semaphore_delete_logic.h"
/*@ Import Coq Require Import CRTOS_Verify.VC.semaphore.SemaphoreDelete_lib */
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
  (semaphore_id : SemaphoreAbs -> Z)
  (SemaphoreRetired : addr -> Z -> Assertion)
*/
/*@ Extern Coq Record StableGlobalState {
  os_semaphore_stable: SemaphoreStable;
} */
/*@ Extern Coq Record SemaphoreStable {
  semaphore_manager_stable: StableIdmanager;
} */
/*@ Extern Coq Record SemaphoreAbs {
  semaphore_id: Z;
} */


/* Source: /home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/semaphore.c. Current 32-bit non-SMP configuration. */
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
    With {A} (storeA: addr -> A -> Assertion)
             (head: addr) (a: A)
             (suffix: list(DL_Node A))
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

#endif

void _SemaphoreDelete(int32 id)
#if CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ dataqueue_cleanup_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require semaphore_delete_quiescent(id, before) && os_inv(sg, before)
    Ensure exists after,
      semaphore_delete_ic_effect(id, before, after) && os_inv(sg, after)
*/
#else
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_semaphore_delete(sg, id), X) &&
            OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */
#endif
{
    
#if !CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ -2147483648 <= id && id <= 2147483647 by local */
#endif

    int resched = 0;
    x_base lock = 0;
    struct Semaphore *sem = NONE;
    struct IdNode *idnode = NONE;

    /* SemIdInvalid(id), inlined from the latest pure helper. */
    if (id < 0 || id > 65535)
        return;

    
#if !CRTOS_DATAQUEUE_SEMAPHORE_IC
lock = CriticalAreaLock() /*@ where (ordinary) sg = sg, st1 = before */;
#endif

    
#if !CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ Given st_lock */
#endif

    
#if !CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ os_inv(sg, st_lock)
        which implies
        store_idmanager(sg.os_semaphore_stable.semaphore_manager_stable,
          semaphore_manager(st_lock.os_semaphores), &k_sem_id_manager) *
        delete_manager_frame(sg, st_lock)
    */
#endif

#if CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ os_inv(sg, before)
      which implies
      os_world_wf(sg, before) && semaphore_context(sg.os_semaphore_stable) &&
      NoDup(map(semaphore_id, before.os_semaphores)) &&
      store_idmanager(sg.os_semaphore_stable.semaphore_manager_stable, semaphore_manager(before.os_semaphores), &k_sem_id_manager) *
      store_dll(store_semaphore(pure_suspend_sched_link(before.os_tasks.task_desc_map)), &k_sem_list, map(semaphore_link_node, before.os_semaphores)) *
      task_inv(sg, before) * tick_inv(sg, before) * delay_inv(sg, before) *
      assign_inv(sg, before) * store_prio_lookup_table *
      store_zombie_queue(before.os_tasks.task_desc_map, sg.os_zombie_head, before.zombie_queue) *
      data_at(sg.os_recycler_slot, int, before.os_recycle.service_id) *
      IntArray::full(sg.os_idle_array, CORE_COUNT, map(service_id, before.os_idle)) *
      mutex_inv(pure_suspend_sched_link(before.os_tasks.task_desc_map), sg.os_mutex_stable, before.os_mutexes) *
      event_inv(pure_suspend_sched_link(before.os_tasks.task_desc_map), sg.os_event_stable, before.os_events) *
      isrmanager_inv(sg.os_isr_stable, before.os_isr) * exstatus_inv(sg, before) *
      dataqueue_inv(before.os_semaphores, before.os_dataqueues) */
#endif
    idnode = IdGetObj(&k_sem_id_manager, id)
#if CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ where (dataqueue_ic_import) */
#endif
;
    if (idnode == NONE) {
        
#if !CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ Assert exists (saved_lock : Z), lock == saved_lock &&
          id == id@pre && 0 <= id && id <= 2147483647 && resched == 0 &&
          sem == 0 && idnode == 0 &&
          safeExec(LastSeen(st_lock), return(tt), X) &&
          Crtos_GTrans(st_lock, st_lock) &&
          InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
        */
#endif

        
#if !CRTOS_DATAQUEUE_SEMAPHORE_IC
CriticalAreaUnLock(lock) /*@ where (stable) sg = sg, st1 = st_lock, st2 = st_lock */;
#endif

        return;
    }
    
#if !CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ store_idmanager_found(sg.os_semaphore_stable.semaphore_manager_stable,
          semaphore_manager(st_lock.os_semaphores), &k_sem_id_manager,
          idnode, unsigned_last_nbits(id, 16)) * delete_manager_frame(sg, st_lock)
        which implies exists (original : SemaphoreAbs),
          In(original, st_lock.os_semaphores) &&
          original.semaphore_id == unsigned_last_nbits(id, 16) &&
          idnode == field_addr(original.semaphore_addr, struct Semaphore, id) &&
          original.semaphore_addr != 0 && os_inv(sg, st_lock)
    */
#endif

    
#if !CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ Given original */
#endif

#if CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ Assert exists (original : SemaphoreAbs),
      id == id@pre && 0 <= id && id <= 65535 && lock == 0 && resched == 0 && sem == 0 &&
      In(original, before.os_semaphores) && original.semaphore_id == id &&
      original.semaphore_pending_addrs == nil &&
      idnode == field_addr(original.semaphore_addr, struct Semaphore, id) &&
      original.semaphore_addr != 0 && semaphore_delete_quiescent(id, before) && os_inv(sg, before) */
#endif
#if CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ Given original */
#endif
    sem = CONTAINER_OF_SEMAPHORE_ID(idnode)
      
#if CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ where (dataqueue_ic_import) */
#else
/*@ where sem_ptr = original.semaphore_addr */
#endif
;
    
#if !CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ In(original, st_lock.os_semaphores) && sem == original.semaphore_addr &&
        os_inv(sg, st_lock)
        which implies In(original, st_lock.os_semaphores) && sem == original.semaphore_addr &&
        store_dll(pure_suspend_sched_link(st_lock.os_tasks.task_desc_map),
          &sem->pend_list, map(sched_link_node, original.semaphore_pending_addrs)) *
        delete_pending_restore(sg, st_lock, sem, original.semaphore_pending_addrs)
    */
#endif

#if CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ In(original, before.os_semaphores) && sem == original.semaphore_addr &&
      original.semaphore_pending_addrs == nil && os_inv(sg, before)
      which implies
      sem == original.semaphore_addr &&
      store_dll(pure_suspend_sched_link(before.os_tasks.task_desc_map), &sem->pend_list, nil) * wand(store_dll(pure_suspend_sched_link(before.os_tasks.task_desc_map), &sem->pend_list, nil), os_inv(sg, before)) */
#endif
    if (!IsDoubleLinkListEmpty(&sem->pend_list)
        
#if CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ where (dataqueue_ic_dll) {A = Z} */
#else
/*@ where (dll) storeA = pure_suspend_sched_link(st_lock.os_tasks.task_desc_map),
             nodes = map(sched_link_node, original.semaphore_pending_addrs); A = addr */
#endif
) {
        resched = 1;
        
#if !CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ In(original, st_lock.os_semaphores) && sem == original.semaphore_addr &&
            store_dll(pure_suspend_sched_link(st_lock.os_tasks.task_desc_map),
              &sem->pend_list, map(sched_link_node, original.semaphore_pending_addrs)) *
            delete_pending_restore(sg, st_lock, sem, original.semaphore_pending_addrs)
            which implies In(original, st_lock.os_semaphores) && sem == original.semaphore_addr &&
            semaphore_pending_nodes(sem, st_lock, map(sched_link_node, original.semaphore_pending_addrs)) &&
            os_inv(sg, st_lock)
        */
#endif

        LinklistResumeAll(&sem->pend_list)
          
#if CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ where (dataqueue_ic_semaphore_waiters) */
#else
/*@ where (semaphore_waiters) sg = sg, before = st_lock, sem = sem,
               waiting = original.semaphore_pending_addrs */
#endif
;
    }
    
#if !CRTOS_DATAQUEUE_SEMAPHORE_IC
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
#endif

    
#if !CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ Given drained saved_lock */
#endif

    
#if !CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ In(original, st_lock.os_semaphores) && sem == original.semaphore_addr &&
        semaphore_resume_all_effect(sem, original.semaphore_pending_addrs, st_lock, drained) &&
        os_inv(sg, drained)
        which implies In(original, st_lock.os_semaphores) && sem == original.semaphore_addr &&
        semaphore_resume_all_effect(sem, original.semaphore_pending_addrs, st_lock, drained) &&
        store(field_addr(field_addr(sem, struct Semaphore, id), struct IdNode, id),
          unsigned short, original.semaphore_id) *
        delete_id_restore(sg, drained, sem, original.semaphore_id)
    */
#endif

#if CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ sem == original.semaphore_addr && store_dll(pure_suspend_sched_link(before.os_tasks.task_desc_map), &sem->pend_list, nil) * wand(store_dll(pure_suspend_sched_link(before.os_tasks.task_desc_map), &sem->pend_list, nil), os_inv(sg, before))
      which implies sem == original.semaphore_addr && os_inv(sg, before) */
#endif
#if CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ In(original, before.os_semaphores) && sem == original.semaphore_addr && os_inv(sg, before)
      which implies sem == original.semaphore_addr &&
      store(field_addr(field_addr(sem, struct Semaphore, id), struct IdNode, id), unsigned short, original.semaphore_id) * wand(store_ushort(field_addr(field_addr(sem, struct Semaphore, id), struct IdNode, id), original.semaphore_id), os_inv(sg, before)) */
#endif
    uint16 delete_sem_id = sem->id.id;
#if CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ sem == original.semaphore_addr && store(field_addr(field_addr(sem, struct Semaphore, id), struct IdNode, id), unsigned short, original.semaphore_id) * wand(store_ushort(field_addr(field_addr(sem, struct Semaphore, id), struct IdNode, id), original.semaphore_id), os_inv(sg, before))
      which implies sem == original.semaphore_addr && os_inv(sg, before) */
#endif

    
#if !CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ sem == original.semaphore_addr &&
        store(field_addr(field_addr(sem, struct Semaphore, id), struct IdNode, id),
          unsigned short, original.semaphore_id) *
        delete_id_restore(sg, drained, sem, original.semaphore_id)
        which implies sem == original.semaphore_addr && os_inv(sg, drained)
    */
#endif

    
#if !CRTOS_DATAQUEUE_SEMAPHORE_IC
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
          store_idmanager(sg.os_semaphore_stable.semaphore_manager_stable,
            semaphore_manager(drained.os_semaphores), &k_sem_id_manager) *
          delete_manager_frame(sg, drained)
    */
#endif

    
#if !CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ Given current prefix suffix */
#endif

    /* Keep the old manager's ID uniqueness as a pure fact across removal.
     * The previous os_inv entailment must derive it from idbuckets_ok/idlist_ok;
     * the post-removal manager alone cannot recover uniqueness of deleted IDs. */
#if CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ Assert exists (prefix suffix : list SemaphoreAbs),
      id == id@pre && 0 <= id && id <= 65535 && lock == 0 && resched == 0 &&
      sem == original.semaphore_addr && idnode == &sem->id && delete_sem_id == original.semaphore_id &&
      original.semaphore_id == id && original.semaphore_pending_addrs == nil &&
      before.os_semaphores == app(prefix, cons(original, suffix)) &&
      NoDup(map(semaphore_id, before.os_semaphores)) &&
      idmanager_query(semaphore_manager(before.os_semaphores), original.semaphore_id) == true &&
      semaphore_delete_quiescent(id, before) &&
      os_world_wf(sg, before) && semaphore_context(sg.os_semaphore_stable) &&
      store_idmanager(sg.os_semaphore_stable.semaphore_manager_stable, semaphore_manager(before.os_semaphores), &k_sem_id_manager) *
      store_dll(store_semaphore(pure_suspend_sched_link(before.os_tasks.task_desc_map)),
        &k_sem_list, app(map(semaphore_link_node, prefix),
          cons(Build_DL_Node(original, &sem->link), map(semaphore_link_node, suffix)))) *
      task_inv(sg, before) * tick_inv(sg, before) * delay_inv(sg, before) *
      assign_inv(sg, before) * store_prio_lookup_table *
      store_zombie_queue(before.os_tasks.task_desc_map, sg.os_zombie_head, before.zombie_queue) *
      data_at(sg.os_recycler_slot, int, before.os_recycle.service_id) *
      IntArray::full(sg.os_idle_array, CORE_COUNT, map(service_id, before.os_idle)) *
      mutex_inv(pure_suspend_sched_link(before.os_tasks.task_desc_map), sg.os_mutex_stable, before.os_mutexes) *
      event_inv(pure_suspend_sched_link(before.os_tasks.task_desc_map), sg.os_event_stable, before.os_events) *
      isrmanager_inv(sg.os_isr_stable, before.os_isr) * exstatus_inv(sg, before) *
      dataqueue_inv(before.os_semaphores, before.os_dataqueues) */
#endif
#if CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ Given prefix suffix */
#endif
    IdRemoveObj(&k_sem_id_manager, delete_sem_id)
      
#if CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ where (dataqueue_ic_low_level_spec) */
#else
/*@ where (low_level_spec) sm = sg.os_semaphore_stable.semaphore_manager_stable,
           m = semaphore_manager(drained.os_semaphores) */
#endif
;
    
#if !CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ drained.os_semaphores == app(prefix, cons(current, suffix)) &&
        current.semaphore_addr == sem && delete_manager_frame(sg, drained)
        which implies drained.os_semaphores == app(prefix, cons(current, suffix)) &&
        current.semaphore_addr == sem &&
        semaphore_context(sg.os_semaphore_stable) && delete_global_frame(sg, drained) *
        store_dll(store_semaphore(pure_suspend_sched_link(drained.os_tasks.task_desc_map)),
          &k_sem_list, app(map(semaphore_link_node, prefix),
            cons(Build_DL_Node(current, &sem->link), map(semaphore_link_node, suffix))))
    */
#endif

    DoubleLinkListRmNode(&sem->link)
      
#if CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ where (dataqueue_ic_remove_member) {A = SemaphoreAbs} */
#else
/*@ where (remove_member) storeA = store_semaphore(pure_suspend_sched_link(drained.os_tasks.task_desc_map)),
           head = &k_sem_list, a = current, prefix = map(semaphore_link_node, prefix),
           suffix = map(semaphore_link_node, suffix); A = SemaphoreAbs */
#endif
;
    
#if !CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ Assert exists (after : VarGlobalState),
      lock == saved_lock && id == id@pre && sem == original.semaphore_addr &&
      idnode == field_addr(sem, struct Semaphore, id) && delete_sem_id == original.semaphore_id &&
      ((resched == 0 && safeExec(LastSeen(after), return(tt), X)) ||
       (resched == 1 && safeExec(LastSeen(after), abs_ktask_assign, X))) &&
      Crtos_GTrans(st_lock, after) &&
      InsideCritical(sg, st_lock) * os_inv(sg, after) *
      SemaphoreRetired(sem, original.semaphore_value)
    */
#endif

    
#if !CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ Given after */
#endif

    
#if !CRTOS_DATAQUEUE_SEMAPHORE_IC
CriticalAreaUnLock(lock) /*@ where (stable) sg = sg, st1 = st_lock, st2 = after */;
#endif

    
#if !CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ SemaphoreRetired(sem, original.semaphore_value)
        which implies SemaphoreRaw(sem)
    */
#endif

#if CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ Assert exists (after : VarGlobalState),
      id == id@pre && sem == original.semaphore_addr && sem != 0 &&
      lock == 0 && resched == 0 && idnode == &sem->id && delete_sem_id == original.semaphore_id &&
      semaphore_delete_ic_effect(id, before, after) &&
      os_inv(sg, after) * CharArray::undef_full(sem, 32) */
#endif
#if CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ Given after */
#endif
    x_free(sem)
#if CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ where (dataqueue_ic_import) */
#endif
;

    if (resched){
        /* DO_KTASK_ASSIGN_ON_WAKE() == DO_KTASK_ASSIGN in the selected
         * config (KERNEL_DEFER_IPC_SCHED undefined); use the existing model. */
        KTASK_ASSIGN() 
#if CRTOS_DATAQUEUE_SEMAPHORE_IC
/*@ where (dataqueue_ic_outside_critical) */
#else
/*@ where (outside_critical) sg = sg, before = after, X = X */
#endif
;
    }
}
