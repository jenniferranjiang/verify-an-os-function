typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;
typedef unsigned long size_t;
typedef int int32;
typedef long x_base;

#define NONE 0
#define ENOMEMORY 5
#define KDBG_IPC 0
#define SYS_KDEBUG_LOG(domain, args)

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

/*@ Import Coq Require Import CRTOS_Verify.lib.SemaphoreInv */
/*@ Import Coq Import DLL */
/*@ Import Coq Require Import SetsClass.SetsClass. Import SetsNotation */
/*@ Import Coq From MonadLib.StateRelMonad Require Import StateRelBasic safeexec_lib */
/*@ Import Coq Import Monad MonadNotation */
/*@ Import Coq Local Open Scope sets */
/*@ Import Coq Local Open Scope monad */

/*@ Printing Coq Name program := StateRelMonad.M */
/*@ Printing Strategy Name program := StateRelMonad.M */
/*@ Printing Strategy No @ bind */

/*@ Extern Coq
      (SemaphoreStable :: *)
      (SemaphoreState :: *)
      (SemaphoreObject :: *)
      (SemaphoreWaiter :: *)
      (SemaphoreTaskBoundary :: *)
      (SemaphoreCreateResult :: *)
      (DL_Node :: * => *)
      (unit :: *)
      (program :: * => * => *)
 */
/*@ Extern Coq
      (tt : unit)
      (nil : {A} -> list A)
      (cons : {A} -> A -> list A -> list A)
      (Build_DL_Node : {A} -> A -> Z -> DL_Node A)
      (Build_SemaphoreObject : Z -> Z -> Z -> list SemaphoreWaiter -> SemaphoreObject)
      (SEM_CREATE_NO_MEMORY : SemaphoreCreateResult)
      (SEM_CREATE_OK : Z -> Z -> Z -> SemaphoreCreateResult)
 */
/*@ Extern Coq
      (SemaphoreStableContext : SemaphoreStable -> Prop)
      (sem_objects : SemaphoreState -> list SemaphoreObject)
      (aligned_8 : Z -> Prop)
      (semaphore_layout_ok : Z -> Prop)
      (SemaphoreLastSeen : SemaphoreState -> (SemaphoreState -> Prop) -> Prop)
      (SemaphoreRTrans : SemaphoreState -> SemaphoreState -> Prop)
      (SemaphoreGTrans : SemaphoreState -> SemaphoreState -> Prop)
      (SemaphoreAcquireTrans : list Z -> SemaphoreState -> SemaphoreState -> Prop)
      (semaphore_min_free_id : SemaphoreStable -> SemaphoreState -> Z -> Prop)
      (semaphore_no_free_id : SemaphoreStable -> SemaphoreState -> Prop)
      (semaphore_mark_bucket_initialized :
        SemaphoreStable -> Z -> list bool -> list bool)
      (semaphore_create_state : SemaphoreState -> Z -> Z -> Z -> SemaphoreState)
      (semaphore_create_effect : SemaphoreStable -> SemaphoreState -> SemaphoreState -> Z -> Z -> Prop)
      (abs_semaphore_create : SemaphoreStable -> Z -> program (SemaphoreState -> Prop) SemaphoreCreateResult)
      (safeExec : {Sigma} {A} -> (Sigma -> Prop) -> program Sigma A -> (A -> Sigma -> Prop) -> Prop)
      (return : {Sigma} {A} -> A -> program Sigma A)
 */
/*@ Extern Coq
      (SemaphoreInsideCritical : list Z -> SemaphoreState -> Assertion)
      (SemaphoreCritical : list Z -> SemaphoreState -> Assertion)
      (SemaphoreOutsideCritical : SemaphoreState -> Assertion)
      (semaphore_inv : SemaphoreStable -> SemaphoreState -> Assertion)
      (semaphore_callable_context :
        SemaphoreStable -> list Z -> SemaphoreState -> Assertion)
      (store_sem_id_manager : SemaphoreStable -> SemaphoreState -> list bool -> Assertion)
      (store_sem_global_list : SemaphoreStable -> SemaphoreState -> Assertion)
      (store_zeroed_semaphore : Z -> Assertion)
      (store_sem_idnode_insert_ready : Z -> Assertion)
      (store_sem_create_remainder : Z -> Assertion)
      (store_sem_zero_padding : Z -> Assertion)
      (store_semaphore_freeable : Z -> Assertion)
      (store_sem_body : Z -> SemaphoreObject -> Assertion)
      (sem_waiter_payload : Z -> unit -> Assertion)
      (sem_global_nodes : list SemaphoreObject -> list (DL_Node SemaphoreObject))
      (store_dll : {A} -> (Z -> A -> Assertion) -> Z -> list (DL_Node A) -> Assertion)
      (occupy_dll_node : Z -> Assertion)
 */

void *x_malloc(size_t size)
/*@ Require 0 < size && size <= 64
    Ensure (__return == 0) ||
      (0 < __return && aligned_8(__return) && semaphore_layout_ok(__return) &&
       CharArray::undef_full(__return, size))
 */
;

void *memset(void *s, int c, size_t n)
/*@ Require 0 <= n && n <= 4294967295 &&
      0 <= c && c <= 127 && CharArray::undef_full(s, n)
    Ensure __return == s && CharArray::full(s, n, repeat_Z(c, n))
 */
;

x_base CriticalAreaLock(void)
/*@ With (sg : SemaphoreStable) (st : SemaphoreState) (handlers : list Z)
    Require SemaphoreStableContext(sg) &&
      semaphore_callable_context(sg, handlers, st)
    Ensure exists st_lock,
      SemaphoreAcquireTrans(handlers, st, st_lock) &&
      SemaphoreInsideCritical(cons(__return, handlers), st_lock) *
      semaphore_inv(sg, st_lock)
 */
;

int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sg : SemaphoreStable) (st : SemaphoreState)
         (flags : list bool) (sem : Z)
    Require manager == &k_sem_id_manager && idnode == sem &&
      semaphore_layout_ok(sem) &&
      store_sem_id_manager(sg, st, flags) *
      store_sem_idnode_insert_ready(sem)
    Ensure
      (__return == -1 && semaphore_no_free_id(sg, st) &&
       store_sem_id_manager(sg, st, flags) *
       store_sem_idnode_insert_ready(sem)) ||
      (0 <= __return && __return < 128 &&
       semaphore_min_free_id(sg, st, __return) &&
       store_sem_id_manager(
         sg, semaphore_create_state(st, __return, sem, 0),
         semaphore_mark_bucket_initialized(sg, __return, flags)))
 */
;

void InitDoubleLinkList(DoubleLinklistType *head)
/*@ With {A} (storeA : Z -> A -> Assertion)
    Require occupy_dll_node(head)
    Ensure store_dll(storeA, head, nil)
 */
;

void DoubleLinkListInsertNodeAfter(
    DoubleLinklistType *list, DoubleLinklistType *node)
/*@ With {A} (storeA : Z -> A -> Assertion)
         (nodes : list (DL_Node A)) (a : A)
    Require occupy_dll_node(node) * storeA(node, a) *
      store_dll(storeA, list, nodes)
    Ensure store_dll(storeA, list, cons(Build_DL_Node(a, node), nodes))
 */
;

void CriticalAreaUnLock(x_base lock)
/*@ With (sg : SemaphoreStable) (before after : SemaphoreState)
         (handlers : list Z)
    Require SemaphoreGTrans(before, after) &&
      SemaphoreInsideCritical(cons(lock, handlers), before) *
      semaphore_inv(sg, after)
    Ensure semaphore_callable_context(sg, handlers, after)
 */
;

void x_free(void *pointer)
/*@ With n
    Require pointer != 0 && 0 <= n && CharArray::undef_full(pointer, n)
    Ensure emp
 */
;

static int32 _SemaphoreCreate(uint16 val)
/*@ With (sg : SemaphoreStable) (st_bef : SemaphoreState)
         (handlers : list Z) X
    Require 0 <= val && val < 65536 &&
      SemaphoreStableContext(sg) &&
      safeExec(SemaphoreLastSeen(st_bef), abs_semaphore_create(sg, val), X) &&
      semaphore_callable_context(sg, handlers, st_bef)
    Ensure 0 <= val && val < 65536 &&
      exists st_lock st_aft,
        SemaphoreAcquireTrans(handlers, st_bef, st_lock) &&
        semaphore_create_effect(sg, st_lock, st_aft, val, __return) &&
        (( __return == -ENOMEMORY &&
           safeExec(SemaphoreLastSeen(st_aft), return(SEM_CREATE_NO_MEMORY), X)) ||
         (0 <= __return && __return < 128 &&
          exists sem_addr,
            st_aft == semaphore_create_state(
              st_lock, __return, sem_addr, val) &&
            safeExec(SemaphoreLastSeen(st_aft),
              return(SEM_CREATE_OK(__return, sem_addr, val)), X))) &&
        semaphore_callable_context(sg, handlers, st_aft)
 */
{
    int32 id = 0;
    x_base lock = 0;
    struct Semaphore *sem = NONE;

    sem = (struct Semaphore *)x_malloc(sizeof(struct Semaphore));
    if (sem == NONE)
        /*@ safeExec(SemaphoreLastSeen(st_bef),
              return(SEM_CREATE_NO_MEMORY), X) &&
            semaphore_callable_context(sg, handlers, st_bef) &&
            semaphore_create_effect(sg, st_bef, st_bef, val, -ENOMEMORY)
         */
        return -ENOMEMORY;

    memset(sem, 0, sizeof(struct Semaphore));
    /*@ aligned_8(sem) && semaphore_layout_ok(sem) &&
        CharArray::full(sem, sizeof(struct Semaphore),
          repeat_Z(0, sizeof(struct Semaphore)))
        which implies
        store_zeroed_semaphore(sem)
     */
    /*@ store_zeroed_semaphore(sem)
        which implies
        store_sem_idnode_insert_ready(sem) *
        store_sem_create_remainder(sem)
     */

    lock = CriticalAreaLock()
      /*@ where sg = sg, st = st_bef, handlers = handlers */;
    /*@ Given st_lock */
    /*@ SemaphoreInsideCritical(cons(lock, handlers), st_lock) *
        semaphore_inv(sg, st_lock)
        which implies
        exists flags,
          SemaphoreInsideCritical(cons(lock, handlers), st_lock) *
          store_sem_id_manager(sg, st_lock, flags) *
          store_sem_global_list(sg, st_lock)
     */
    /*@ Given flags */
    /*@ semaphore_layout_ok(sem)
        which implies &(sem->id) == sem
     */
    id = IdInsertObj(&k_sem_id_manager, &sem->id)
      /*@ where sg = sg, st = st_lock, flags = flags, sem = sem */;
    if (id < 0) {
        /*@ store_sem_idnode_insert_ready(sem) *
            store_sem_create_remainder(sem)
            which implies
            CharArray::undef_full(sem, sizeof(struct Semaphore))
         */
        x_free(sem) /*@ where n = sizeof(struct Semaphore) */;
        /*@ SemaphoreInsideCritical(cons(lock, handlers), st_lock) *
            store_sem_id_manager(sg, st_lock, flags) *
            store_sem_global_list(sg, st_lock)
            which implies
            SemaphoreGTrans(st_lock, st_lock) &&
            SemaphoreInsideCritical(cons(lock, handlers), st_lock) *
            semaphore_inv(sg, st_lock)
         */
        CriticalAreaUnLock(lock)
          /*@ where sg = sg, before = st_lock, after = st_lock,
              handlers = handlers */;
        /*@ safeExec(SemaphoreLastSeen(st_lock),
              return(SEM_CREATE_NO_MEMORY), X) &&
            semaphore_create_effect(sg, st_lock, st_lock, val, -ENOMEMORY)
         */
        return -ENOMEMORY;
    }
    /*@ store_sem_create_remainder(sem)
        which implies
        exists old_value,
          store(&(sem->value), unsigned short, old_value) *
          occupy_dll_node(&(sem->pend_list)) *
          occupy_dll_node(&(sem->link)) *
          store_sem_zero_padding(sem)
     */
    sem->value = val;
    InitDoubleLinkList(&sem->pend_list)
      /*@ where storeA = sem_waiter_payload; A = unit */;

    /*@ store(&(sem->value), unsigned short, val) *
        store_dll(sem_waiter_payload, &(sem->pend_list), nil) *
        occupy_dll_node(&(sem->link)) *
        store_sem_zero_padding(sem) &&
        semaphore_min_free_id(sg, st_lock, id)
        which implies
        occupy_dll_node(&(sem->link)) *
        store_sem_body(&(sem->link),
          Build_SemaphoreObject(id, sem, val, nil))
     */
    /*@ store_sem_global_list(sg, st_lock)
        which implies
        store_dll(store_sem_body, &k_sem_list,
          sem_global_nodes(sem_objects(st_lock)))
     */
    DoubleLinkListInsertNodeAfter(&k_sem_list, &sem->link)
      /*@ where storeA = store_sem_body,
          nodes = sem_global_nodes(sem_objects(st_lock)),
          a = Build_SemaphoreObject(id, sem, val, nil);
          A = SemaphoreObject */;

    /*@ SemaphoreInsideCritical(cons(lock, handlers), st_lock) *
        store_sem_id_manager(
          sg, semaphore_create_state(st_lock, id, sem, 0),
          semaphore_mark_bucket_initialized(sg, id, flags)) *
        store_dll(store_sem_body, &k_sem_list,
          cons(Build_DL_Node(
            Build_SemaphoreObject(id, sem, val, nil), &(sem->link)),
            sem_global_nodes(sem_objects(st_lock))))
        which implies
        SemaphoreGTrans(st_lock,
          semaphore_create_state(st_lock, id, sem, val)) &&
        semaphore_create_effect(sg, st_lock,
          semaphore_create_state(st_lock, id, sem, val), val, id) &&
        SemaphoreInsideCritical(cons(lock, handlers), st_lock) *
        semaphore_inv(sg, semaphore_create_state(st_lock, id, sem, val))
     */
    CriticalAreaUnLock(lock)
      /*@ where sg = sg, before = st_lock, handlers = handlers,
          after = semaphore_create_state(st_lock, id, sem, val) */;

    SYS_KDEBUG_LOG(KDBG_IPC,
         ("created semaphore: id %d, value %d\n", id, (int)val));

    /*@ safeExec(
          SemaphoreLastSeen(semaphore_create_state(st_lock, id, sem, val)),
          return(SEM_CREATE_OK(id, sem, val)), X)
     */
    return id;
}
