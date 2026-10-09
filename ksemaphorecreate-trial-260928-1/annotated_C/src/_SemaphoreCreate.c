/* Source: kernel/thread/semaphore.c:33-62 under the approved config.
 * The source-static helper is externalized only for this one-function slice.
 * NONE is normalized to 0. SYS_KDEBUG_LOG expands to do { if (KDBG_IPC) ... }
 * while (0); xs_kdbg.h fixes KDBG_IPC=0, so that constant-dead branch is
 * removed without changing calls or side effects. x_size_t is unsigned long
 * in xs_base.h and is represented by unsigned int here; both are 32-bit under
 * the approved Cortex-M3 ILP32 ABI, and the only values passed here are 32. */
typedef signed int int32;
typedef unsigned int x_size_t;
typedef unsigned short uint16;
typedef long x_base;
typedef struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
} DoubleLinklistType;
struct IdNode { uint16 id; DoubleLinklistType link; };
struct IdManager {
    uint16 id_max; uint16 hoffset; unsigned char *id_map; DoubleLinklistType *htable;
};
struct Semaphore {
    struct IdNode id;
    uint16 value;
    DoubleLinklistType pend_list;
    DoubleLinklistType link;
};

/*@ Import Coq Require Import CRTOS_Verify.sem.CrtosOSProtocol */
/*@ Import Coq Import CrtosOS_C_Rules */
/*@ Import Coq Require Import Coq.Lists.List */
/*@ Import Coq Require Import CRTOS_Verify.lib.CrtosGlobState */
/*@ Import Coq Require Import CRTOS_Verify.sem.SemaphorePure */
/*@ Import Coq Require Import CRTOS_Verify.sem.CrtosOSPure */
/*@ Import Coq Require Import CRTOS_Verify.sem.SemaphoreProtocol */
/*@ Import Coq Require Import CRTOS_Verify.sem.SemaphoreRep */
/*@ Import Coq Require Import CRTOS_Verify.sem.CrtosOSRep */
/*@ Import Coq Require Import CRTOS_Verify.sem.SemaphoreCritical */
/*@ Import Coq Require Import CRTOS_Verify.VC.SemaphoreProofLocal */
/*@ Import Coq From MonadLib.StateRelMonad Require Import StateRelBasic safeexec_lib */
/*@ Import Coq Import Monad MonadNotation */
/*@ Import Coq Local Open Scope monad */

extern struct IdManager k_sem_id_manager;
extern DoubleLinklistType k_sem_list;

/*@ Extern Coq (SemaphoreStable :: *) (SemaphoreState :: *)
               (CrtosOSStable :: *) (CrtosOSWorld :: *)
               (VarGlobalState :: *) (CrtosSchedulerState :: *)
               (SemaphoreObject :: *) (SemDLNode :: * => *)
               (unit :: *) (program :: * => * => *) */
/*@ Extern Coq (semaphore_unit_empty : Z -> unit -> Assertion)
               (map : {A B} -> (A -> B) -> list A -> list B)
               (crtos_semaphore_stable : CrtosOSStable -> SemaphoreStable)
               (crtos_task_state : CrtosOSWorld -> VarGlobalState)
               (crtos_scheduler_state : CrtosOSWorld -> CrtosSchedulerState)
               (crtos_semaphore_state : CrtosOSWorld -> SemaphoreState)
               (Build_CrtosOSWorld :
                 VarGlobalState -> CrtosSchedulerState -> SemaphoreState -> CrtosOSWorld)
               (Build_SemaphoreObject : Z -> Z -> Z -> list Z -> SemaphoreObject)
               (semaphore_objects : SemaphoreState -> list SemaphoreObject)
               (semaphore_registry_node : SemaphoreObject -> SemDLNode SemaphoreObject)
               (Build_SemDLNode : {A} -> A -> Z -> SemDLNode A)
               (SemaphoreLastSeen :
                 SemaphoreStable -> SemaphoreState -> (SemaphoreState -> Prop) -> Prop)
               (abs_ksemaphore_create : SemaphoreStable -> Z -> program (SemaphoreState -> Prop) Z)
               (safeExec : {Sigma} {A} ->
                 (Sigma -> Prop) -> program Sigma A ->
                 (A -> Sigma -> Prop) -> Prop)
               (return : {Sigma} {A} -> A -> program Sigma A)
               (semaphore_first_free : SemaphoreStable -> SemaphoreState -> option Z)
               (semaphore_find_addr : Z -> list SemaphoreObject -> option SemaphoreObject)
               (crtos_os_world_wf : CrtosOSStable -> CrtosOSWorld -> Prop)
               (SemaphoreStableContext : SemaphoreStable -> Prop)
               (semaphore_layout_32_ok : Z -> Prop)
               (semaphore_manager_addr : SemaphoreStable -> Z)
               (semaphore_create_state : SemaphoreState -> Z -> Z -> Z -> SemaphoreState)
               (semaphore_reserve_state : SemaphoreState -> Z -> Z -> SemaphoreState)
               (semaphore_irq_handler_ok : Z -> Prop)
               (SemaphoreRely :
                 CrtosOSStable -> CrtosOSWorld -> CrtosOSWorld -> Prop)
               (SemaphoreGuarantee :
                 CrtosOSStable -> CrtosOSWorld -> CrtosOSWorld -> Prop)
               (SemaphoreCriticalOutside :
                 CrtosOSStable -> CrtosOSWorld -> Assertion)
               (SemaphoreCriticalHeld :
                 Z -> list Z -> CrtosOSStable -> CrtosOSWorld -> Assertion)
               (crtos_semaphore_os_inv :
                 CrtosOSStable -> CrtosOSWorld -> Assertion)
               (crtos_semaphore_nonsem_frame :
                 CrtosOSStable -> CrtosOSWorld -> Assertion)
               (store_sem_allocated : Z -> Assertion)
               (store_sem_zeroed_private : Z -> Assertion)
               (store_sem_id_padding_zero : Z -> Assertion)
               (store_sem_body_padding_zero : Z -> Assertion)
               
               (store_sem_id_node_zeroed : Z -> Assertion)
               (store_sem_after_id_insert_private : Z -> Assertion)
               (store_sem_publish_ready_private : Z -> Z -> Assertion)
               (store_semaphore_id_manager :
                 SemaphoreStable -> SemaphoreState -> Assertion)
               (store_semaphore_registry :
                 SemaphoreStable -> SemaphoreState -> Assertion)
               (semaphore_registry_addr : SemaphoreStable -> Z)
               (store_semaphore_body : Z -> SemaphoreObject -> Assertion)
               (store_sem_dll :
                 {A} -> (Z -> A -> Assertion) -> Z -> list(SemDLNode A) -> Assertion)
               (store_sem_standalone_node :
                 {A} -> (Z -> A -> Assertion) -> Z -> A -> Assertion)
 */

void *x_malloc(x_size_t size)
/*@ Require size == 32 && emp
    Ensure (__return == 0 && emp) ||
           (__return != 0 && store_sem_allocated(__return))
 */;

void x_free(void *memory)
/*@ Require store_sem_zeroed_private(memory)
    Ensure emp
 */;

void *memset(void *dest, int value, x_size_t size)
/*@ Require value == 0 && size == 32 && store_sem_allocated(dest)
    Ensure __return == dest && store_sem_zeroed_private(dest)
 */;

x_base CriticalAreaLock(void)
/*@ ordinary
    With (stable : CrtosOSStable) (before : CrtosOSWorld)
    Require SemaphoreCriticalOutside(stable, before)
    Ensure exists handler current,
      __return == handler && semaphore_irq_handler_ok(handler) &&
      SemaphoreRely(stable, before, current) &&
      SemaphoreCriticalHeld(handler, nil, stable, current) *
      crtos_semaphore_os_inv(stable, current)
 */;

void CriticalAreaUnLock(x_base lock)
/*@ ordinary
    With (stable : CrtosOSStable) (before after : CrtosOSWorld)
    Require semaphore_irq_handler_ok(lock) &&
      SemaphoreGuarantee(stable, before, after) &&
      SemaphoreCriticalHeld(lock, nil, stable, before) *
      crtos_semaphore_os_inv(stable, after)
    Ensure SemaphoreCriticalOutside(stable, after)
 */;

int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (stable : SemaphoreStable) (before : SemaphoreState) sem
    Require manager != 0 && idnode != 0 && SemaphoreStableContext(stable) &&
      semaphore_layout_32_ok(sem) &&
      manager == semaphore_manager_addr(stable) &&
      idnode == field_addr(sem, struct Semaphore, id) &&
      store_semaphore_id_manager(stable, before) *
      store_sem_id_node_zeroed(sem)
    Ensure manager != 0 && idnode != 0 && SemaphoreStableContext(stable) &&
      semaphore_layout_32_ok(sem) &&
      ((__return == -1 && semaphore_first_free(stable, before) == None &&
       store_semaphore_id_manager(stable, before) *
       store_sem_id_node_zeroed(sem))
      ||
      (0 <= __return && semaphore_first_free(stable, before) == Some(__return) &&
       store_semaphore_id_manager(
         stable, semaphore_reserve_state(before, sem, __return))))
 */;

void InitDoubleLinkList(DoubleLinklistType *head)
/*@ With old_next old_prev
    Require head != 0 &&
      store(&(head->node_next), void *, old_next) *
      store(&(head->node_prev), void *, old_prev)
    Ensure store_sem_dll(semaphore_unit_empty, head, nil)
 */;

void DoubleLinkListInsertNodeAfter(
    DoubleLinklistType *head, DoubleLinklistType *node)
/*@ With {A} (store_payload : Z -> A -> Assertion)
         (payload : A) (nodes : list(SemDLNode A))
    Require node != 0 &&
      store_sem_dll(store_payload, head, nodes) *
      store_sem_standalone_node(store_payload, node, payload)
    Ensure store_sem_dll(store_payload, head,
      cons(Build_SemDLNode(payload, node), nodes))
 */;

int32 _SemaphoreCreate(uint16 val)
/*@ With (stable : CrtosOSStable) (before : CrtosOSWorld) X
    Require
      sizeof(struct Semaphore) == 32 &&
      0 <= val && val <= 65535 &&
      safeExec(SemaphoreLastSeen(crtos_semaphore_stable(stable),
        crtos_semaphore_state(before)),
        abs_ksemaphore_create(crtos_semaphore_stable(stable), val), X) &&
      SemaphoreCriticalOutside(stable, before)
    Ensure
      (exists current after,
        __return == -5 && SemaphoreRely(stable, before, current) &&
        after == current &&
        safeExec(SemaphoreLastSeen(crtos_semaphore_stable(stable),
          crtos_semaphore_state(after)), return(__return), X) &&
        SemaphoreCriticalOutside(stable, after))
      ||
      (exists current after sem id,
        __return == id && 0 <= id && id < 128 && sem != 0 &&
        SemaphoreRely(stable, before, current) &&
        semaphore_first_free(crtos_semaphore_stable(stable),
          crtos_semaphore_state(current)) == Some(id) &&
        after == Build_CrtosOSWorld(
          crtos_task_state(current), crtos_scheduler_state(current),
          semaphore_create_state(crtos_semaphore_state(current), sem, id, val)) &&
        safeExec(SemaphoreLastSeen(crtos_semaphore_stable(stable),
          crtos_semaphore_state(after)), return(__return), X) &&
        SemaphoreCriticalOutside(stable, after))
 */
{
    int32 id = 0;
    x_base lock = 0;
    struct Semaphore *sem = 0;

    sem = (struct Semaphore *)x_malloc(sizeof(struct Semaphore));
    if (sem == 0)
        return -5;

    memset(sem, 0, sizeof(struct Semaphore));
    lock = CriticalAreaLock()
      /*@ where (ordinary) stable = stable, before = before */;
    /*@ Given handler current */
    /*@ crtos_semaphore_os_inv(stable, current) *
        store_sem_zeroed_private(sem)
        which implies
          semaphore_layout_32_ok(sem) &&
          crtos_os_world_wf(stable, current) &&
          semaphore_find_addr(sem,
            semaphore_objects(crtos_semaphore_state(current))) == None &&
          crtos_semaphore_nonsem_frame(stable, current) *
          store_semaphore_id_manager(crtos_semaphore_stable(stable),
            crtos_semaphore_state(current)) *
          store_semaphore_registry(crtos_semaphore_stable(stable),
            crtos_semaphore_state(current)) *
          store_sem_id_node_zeroed(sem) *
          store_sem_after_id_insert_private(sem)
     */
    id = IdInsertObj(&k_sem_id_manager, &sem->id)
      /*@ where stable = crtos_semaphore_stable(stable),
                  before = crtos_semaphore_state(current), sem = sem */;
    if (id < 0) {
        /*@ semaphore_layout_32_ok(sem) &&
            store_sem_id_node_zeroed(sem) *
            store_sem_after_id_insert_private(sem)
            which implies store_sem_zeroed_private(sem)
         */
        x_free(sem);
        /*@ crtos_semaphore_nonsem_frame(stable, current) *
            store_semaphore_id_manager(crtos_semaphore_stable(stable),
              crtos_semaphore_state(current)) *
            store_semaphore_registry(crtos_semaphore_stable(stable),
              crtos_semaphore_state(current))
            which implies crtos_semaphore_os_inv(stable, current)
         */
        CriticalAreaUnLock(lock)
          /*@ where (ordinary) stable = stable, before = current, after = current */;
        return -5;
    }

    /*@ store_sem_after_id_insert_private(sem)
        which implies
          sem != 0 &&
          store(&(sem->value), unsigned short, 0) *
          store_sem_body_padding_zero(sem) *
          store(&(sem->pend_list.node_next),
            struct SysDoubleLinklistNode *, 0) *
          store(&(sem->pend_list.node_prev),
            struct SysDoubleLinklistNode *, 0) *
          store(&(sem->link.node_next),
            struct SysDoubleLinklistNode *, 0) *
          store(&(sem->link.node_prev),
            struct SysDoubleLinklistNode *, 0)
     */
    sem->value = val;
    InitDoubleLinkList(&sem->pend_list)
      /*@ where old_next = 0, old_prev = 0 */;
    /*@ SemaphoreStableContext(crtos_semaphore_stable(stable)) &&
        store_semaphore_registry(crtos_semaphore_stable(stable),
          crtos_semaphore_state(current))
        which implies
          store_sem_dll(store_semaphore_body, &k_sem_list,
            map(semaphore_registry_node,
              semaphore_objects(crtos_semaphore_state(current))))
     */
    /*@ sem != 0 && semaphore_layout_32_ok(sem) &&
        store_semaphore_id_manager(crtos_semaphore_stable(stable),
          semaphore_reserve_state(crtos_semaphore_state(current), sem, id)) *
        store(&(sem->value), unsigned short, val@pre) *
        store_sem_body_padding_zero(sem) *
        store_sem_dll(semaphore_unit_empty, &sem->pend_list, nil) *
        store(&(sem->link.node_next), struct SysDoubleLinklistNode *, 0) *
        store(&(sem->link.node_prev), struct SysDoubleLinklistNode *, 0)
        which implies
          store_semaphore_id_manager(crtos_semaphore_stable(stable),
            semaphore_reserve_state(crtos_semaphore_state(current), sem, id)) *
          store_sem_standalone_node(store_semaphore_body, &sem->link,
            Build_SemaphoreObject(sem, id, val@pre, nil))
     */
    DoubleLinkListInsertNodeAfter(&k_sem_list, &sem->link)
      /*@ where store_payload = store_semaphore_body,
                  payload = Build_SemaphoreObject(sem, id, val, nil),
                  nodes = map(semaphore_registry_node,
                    semaphore_objects(crtos_semaphore_state(current)));
                  A = SemaphoreObject */;
    /*@ sem != 0 && 0 <= id && id < 128 &&
        0 <= val@pre && val@pre <= 65535 &&
        crtos_os_world_wf(stable, current) &&
        semaphore_find_addr(sem,
          semaphore_objects(crtos_semaphore_state(current))) == None &&
        semaphore_first_free(crtos_semaphore_stable(stable),
          crtos_semaphore_state(current)) == Some(id) &&
        crtos_semaphore_nonsem_frame(stable, current) *
        store_semaphore_id_manager(crtos_semaphore_stable(stable),
          semaphore_reserve_state(crtos_semaphore_state(current), sem, id)) *
        store_sem_dll(store_semaphore_body, &k_sem_list,
          cons(Build_SemDLNode(Build_SemaphoreObject(sem, id, val@pre, nil),
                 &sem->link),
            map(semaphore_registry_node,
              semaphore_objects(crtos_semaphore_state(current)))))
        which implies
          crtos_os_world_wf(stable,
            Build_CrtosOSWorld(
              crtos_task_state(current), crtos_scheduler_state(current),
              semaphore_create_state(
                crtos_semaphore_state(current), sem, id, val@pre))) &&
          crtos_semaphore_os_inv(stable,
            Build_CrtosOSWorld(
              crtos_task_state(current), crtos_scheduler_state(current),
              semaphore_create_state(
                crtos_semaphore_state(current), sem, id, val@pre)))
     */
    CriticalAreaUnLock(lock)
      /*@ where (ordinary) stable = stable, before = current,
                    after = Build_CrtosOSWorld(
                      crtos_task_state(current), crtos_scheduler_state(current),
                      semaphore_create_state(
                        crtos_semaphore_state(current), sem, id, val)) */;
    return id;
}
