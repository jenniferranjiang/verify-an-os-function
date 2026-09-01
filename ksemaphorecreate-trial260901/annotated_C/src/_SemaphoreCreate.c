/*
 * Extraction: kernel/thread/semaphore.c:33-62.
 * The TU-static symbol is slice-externalized. SYS_KDEBUG_LOG is expanded with
 * KDBG_IPC == 0; its dead-branch KPrintf target is approved trusted.
 */

typedef signed int int32;
typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned long x_size_t;
typedef signed long x_base;

typedef struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
} DoubleLinklistType;

struct IdNode {
    uint16 id;
    DoubleLinklistType link;
};

struct IdManager {
    uint16 id_max;
    uint16 hoffset;
    uint8 *id_map;
    DoubleLinklistType *htable;
};

struct Semaphore {
    struct IdNode id;
    uint16 value;
    DoubleLinklistType pend_list;
    DoubleLinklistType link;
};

extern struct IdManager k_sem_id_manager;
extern DoubleLinklistType k_sem_list;

/*@ Extern Coq (SemaphoreStable :: *)
               (SemaphoreState :: *)
               (SemaphoreObject :: *)
               (SemaphoreWaiter :: *)
               (StableIdManager :: *)
               (IdManagerState :: *)
               (DllNode :: * => *)
               (Build_SemaphoreObject : Z -> Z -> Z -> list SemaphoreWaiter -> SemaphoreObject)
               (SemaphoreCreateEffect : SemaphoreStable -> Z -> SemaphoreState -> Z -> SemaphoreState -> Prop)
               (SemaphoreStableContext : SemaphoreStable -> Prop)
               (SemaphoreCritical : list Z -> SemaphoreStable -> SemaphoreState -> Assertion)
               (SemaphoreVisible : SemaphoreStable -> list Z -> SemaphoreState -> SemaphoreState -> Prop)
               (SemaphoreGuarantee : SemaphoreStable -> SemaphoreState -> SemaphoreState -> Prop)
               (semaphore_critical_enterable : list Z -> SemaphoreStable -> SemaphoreState -> Assertion)
               (semaphore_critical_interface : list Z -> SemaphoreStable -> SemaphoreState -> Assertion)
               (semaphore_handler_depth : list Z -> Z)
               (semaphore_id_stable : SemaphoreStable -> StableIdManager)
               (sem_manager_addr : SemaphoreStable -> Z)
               (sem_list_head_addr : SemaphoreStable -> Z)
               (sem_objects : SemaphoreState -> list SemaphoreObject)
               (semaphore_list_node : SemaphoreObject -> DllNode SemaphoreObject)
               (semaphore_list_nodes : list SemaphoreObject -> list (DllNode SemaphoreObject))
               (store_semaphore_list_payload : Z -> SemaphoreObject -> Assertion)
               (semaphore_inv : SemaphoreStable -> SemaphoreState -> Assertion)
               (store_sem_registry : SemaphoreStable -> SemaphoreState -> Assertion)
               (store_critical_nest : Z -> Assertion)
               (store_sem_allocated : Z -> Assertion)
               (store_sem_zeroed_private : Z -> Assertion)
               (store_sem_after_id_insert_private : Z -> Assertion)
               (semaphore_id_registered : SemaphoreStable -> SemaphoreState -> IdManagerState -> SemaphoreObject -> Assertion)
               (store_sem_publish_ready_private : Z -> SemaphoreObject -> Assertion)
               (id_manager_matches_semaphores : SemaphoreState -> IdManagerState -> Prop)
               (store_id_manager : StableIdManager -> IdManagerState -> Z -> Assertion)
               (store_id_node_insert_ready : Z -> Assertion)
               (id_manager_after_insert : StableIdManager -> IdManagerState -> Z -> Z -> IdManagerState)
               (id_manager_min_free_id : StableIdManager -> IdManagerState -> Z -> Prop)
               (id_manager_full : StableIdManager -> IdManagerState -> Prop)
               (store_dll : {A} -> (Z -> A -> Assertion) -> Z -> list (DllNode A) -> Assertion)
               (store_dll_node_uninitialized : Z -> Assertion)
               (store_dll_node_standalone : Z -> Assertion)
               (dll_insert_after : {A} -> Z -> Z -> DllNode A -> list (DllNode A) -> list (DllNode A) -> Prop)
               (dll_link_addr : {A} -> DllNode A -> Z)
               (dll_payload : {A} -> DllNode A -> A)) */
/*@ Import Coq Require Import CRTOS_Verify.lib.SemaphoreRep */

void *x_malloc(x_size_t size)
/*@ Require size == 32 && emp
    Ensure (__return == 0 && emp) ||
           (__return != 0 && store_sem_allocated(__return))
*/;

void *memset(void *dest, int value, x_size_t size)
/*@ With sem
    Require dest == sem && value == 0 && size == 32 &&
            store_sem_allocated(sem)
    Ensure __return == sem && store_sem_zeroed_private(sem)
*/;

void x_free(void *pointer)
/*@ With sem
    Require pointer == sem && store_sem_zeroed_private(sem)
    Ensure emp
*/;

void KPrintf(const char *fmt, ...)
/*@ Require emp
    Ensure emp
*/;

x_base CriticalAreaLock(void)
/*@ With (sg : SemaphoreStable) handlers before
    Require semaphore_critical_enterable(handlers, sg, before)
    Ensure exists current saved,
            __return == saved &&
            SemaphoreVisible(sg, handlers, before, current) &&
            semaphore_critical_interface(cons(saved, handlers), sg, current)
*/;

void CriticalAreaUnLock(x_base lock)
/*@ With (sg : SemaphoreStable) rest protocol_state memory_state
    Require SemaphoreGuarantee(sg, protocol_state, memory_state) &&
            SemaphoreCritical(cons(lock, rest), sg, protocol_state) *
            semaphore_inv(sg, memory_state) *
            store_critical_nest(semaphore_handler_depth(cons(lock, rest)))
    Ensure semaphore_critical_enterable(rest, sg, memory_state)
*/;

int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sm : StableIdManager) (before : IdManagerState)
    Require manager != 0 && idnode != 0 &&
            store_id_manager(sm, before, manager) *
            store_id_node_insert_ready(idnode)
    Ensure (__return == -1 && id_manager_full(sm, before) &&
            store_id_manager(sm, before, manager) *
            store_id_node_insert_ready(idnode)) ||
           (exists id,
             __return == id &&
             id_manager_min_free_id(sm, before, id) &&
             store_id_manager(sm,
               id_manager_after_insert(sm, before, id, idnode), manager))
*/;

void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ Require store_dll_node_uninitialized(linklist_head)
    Ensure store_dll_node_standalone(linklist_head)
*/;

void DoubleLinkListInsertNodeAfter(
    DoubleLinklistType *linklist,
    DoubleLinklistType *linklist_node)
/*@ With {A} (store_payload : Z -> A -> Assertion)
         head focus (new_node : DllNode A) before_nodes after_nodes
    Require focus == linklist &&
            dll_link_addr(new_node) == linklist_node &&
            dll_insert_after(head, focus, new_node,
                             before_nodes, after_nodes) &&
            store_dll(store_payload, head, before_nodes) *
            store_payload(linklist_node, dll_payload(new_node)) *
            store_dll_node_uninitialized(linklist_node)
    Ensure store_dll(store_payload, head, after_nodes)
*/;

int32 _SemaphoreCreate(uint16 val)
/*@ With (sg : SemaphoreStable) handlers before
    Require 0 <= val && val <= 65535 &&
            SemaphoreStableContext(sg) &&
            semaphore_critical_enterable(handlers, sg, before)
    Ensure exists observed after,
            SemaphoreVisible(sg, handlers, before, observed) &&
            SemaphoreStableContext(sg) &&
            SemaphoreCreateEffect(sg, val, observed, __return, after) &&
            semaphore_critical_enterable(handlers, sg, after)
*/
{
    int32 id = 0;
    x_base lock = 0;
    struct Semaphore *sem = (void *)0;

    sem = (struct Semaphore *)x_malloc(sizeof(struct Semaphore));
    if (sem == (void *)0)
        return -5;

    memset(sem, 0, sizeof(struct Semaphore)) /*@ where sem = sem */;
    lock = CriticalAreaLock()
      /*@ where sg = sg, handlers = handlers, before = before */;

    /*@ semaphore_critical_interface(cons(lock, handlers), sg, current)
        which implies
        SemaphoreCritical(cons(lock, handlers), sg, current) *
        semaphore_inv(sg, current) *
        store_critical_nest(
          semaphore_handler_depth(cons(lock, handlers))) */

    /*@ exists current idm,
          SemaphoreVisible(sg, handlers, before, current) &&
          id_manager_matches_semaphores(current, idm) &&
          SemaphoreCritical(cons(lock, handlers), sg, current) *
          store_id_manager(semaphore_id_stable(sg), idm,
                           sem_manager_addr(sg)) *
          store_sem_registry(sg, current) *
          store_id_node_insert_ready(&(sem->id)) *
          store_sem_after_id_insert_private(sem) *
          store_critical_nest(
            semaphore_handler_depth(cons(lock, handlers))) */
    id = IdInsertObj(&k_sem_id_manager, &sem->id)
      /*@ where sm = semaphore_id_stable(sg), before = idm */;
    if (id < 0) {
        /*@ exists current,
              SemaphoreGuarantee(sg, current, current) &&
              SemaphoreCritical(cons(lock, handlers), sg, current) *
              semaphore_inv(sg, current) *
              store_sem_zeroed_private(sem) *
              store_critical_nest(
                semaphore_handler_depth(cons(lock, handlers))) */
        x_free(sem) /*@ where sem = sem */;
        CriticalAreaUnLock(lock)
          /*@ where sg = sg, rest = handlers,
                       protocol_state = current,
                       memory_state = current */;
        return -5;
    }

    /*@ exists current idm,
          SemaphoreCritical(cons(lock, handlers), sg, current) *
          semaphore_id_registered(sg, current, idm,
            Build_SemaphoreObject(sem, id, 0, nil)) *
          store_sem_after_id_insert_private(sem) *
          store_critical_nest(
            semaphore_handler_depth(cons(lock, handlers))) */
    sem->value = val;
    InitDoubleLinkList(&sem->pend_list);

    /*@ exists current idm,
          SemaphoreCritical(cons(lock, handlers), sg, current) *
          semaphore_id_registered(sg, current, idm,
            Build_SemaphoreObject(sem, id, 0, nil)) *
          store_sem_publish_ready_private(sem,
            Build_SemaphoreObject(sem, id, val, nil)) *
          store_critical_nest(
            semaphore_handler_depth(cons(lock, handlers))) */
    DoubleLinkListInsertNodeAfter(&k_sem_list, &sem->link)
      /*@ where A = SemaphoreObject,
                   store_payload = store_semaphore_list_payload,
                   head = sem_list_head_addr(sg),
                   focus = sem_list_head_addr(sg),
                   new_node = semaphore_list_node(
                     Build_SemaphoreObject(sem, id, val, nil)),
                   before_nodes = semaphore_list_nodes(sem_objects(current)),
                   after_nodes = cons(
                     semaphore_list_node(
                       Build_SemaphoreObject(sem, id, val, nil)),
                     semaphore_list_nodes(sem_objects(current))) */;

    /*@ exists current after,
          SemaphoreCreateEffect(sg, val, current, id, after) &&
          SemaphoreGuarantee(sg, current, after) &&
          SemaphoreCritical(cons(lock, handlers), sg, current) *
          semaphore_inv(sg, after) *
          store_critical_nest(
            semaphore_handler_depth(cons(lock, handlers))) */
    CriticalAreaUnLock(lock)
      /*@ where sg = sg, rest = handlers,
                   protocol_state = current,
                   memory_state = after */;

    if (0) {
        KPrintf("[%s:%d] ", "_SemaphoreCreate", 59);
        KPrintf("created semaphore: id %d, value %d\n", id, (int)val);
    }

    return id;
}
