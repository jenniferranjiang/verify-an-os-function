# 0 "/home/xinra/crtos/kmutexcreate-trial-261101-1/annotated_C/src/_MutexCreate.c"
# 0 "<built-in>"
#define __STDC__ 1
# 0 "<built-in>"
#define __STDC_VERSION__ 201710L
# 0 "<built-in>"
#define __STDC_UTF_16__ 1
# 0 "<built-in>"
#define __STDC_UTF_32__ 1
# 0 "<built-in>"
#define __STDC_HOSTED__ 0
# 0 "<command-line>"
# 1 "/home/xinra/crtos/kmutexcreate-trial-261101-1/annotated_C/src/_MutexCreate.c"
# 1 "/home/xinra/crtos/kmutexcreate-trial-261101-1/annotated_C/src/../include/slice_types.h" 1

#define KMUTEX_SLICE_TYPES_H 
/* ILP32 non-SMP slice. Full layouts of every accessed struct are retained.
 * Origin: kernel/include/xs_{base,klist,id,mutex}.h and configured xsconfig.h. */
typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;
typedef int int32;
typedef long x_base;
typedef unsigned long x_size_t;
typedef unsigned long size_t;
struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
};
typedef struct SysDoubleLinklistNode DoubleLinklistType;
struct IdNode { uint16 id; DoubleLinklistType link; };
struct IdManager {
    uint16 id_max;
    uint16 hoffset;
    uint8 *id_map;
    DoubleLinklistType *htable;
};
struct TaskDescriptor;
struct Mutex {
    struct IdNode id;
    uint16 val;
    uint8 recursive_cnt;
    uint8 origin_prio;
    struct TaskDescriptor *holder;
    DoubleLinklistType pend_list;
    DoubleLinklistType link;
};
#define NONE ((void *)0)
#define ENOMEMORY 5
#define UINT_MAX 4294967295U
#define ALIGN_SIZE 4
#define ID_NUM_MAX 128
#define ID_HTABLE_SIZE 16
#define KERNEL_MUTEX 
extern struct IdManager k_mutex_id_manager;
extern DoubleLinklistType k_mutex_list;
# 2 "/home/xinra/crtos/kmutexcreate-trial-261101-1/annotated_C/src/_MutexCreate.c" 2
# 1 "/home/xinra/crtos/kmutexcreate-trial-261101-1/annotated_C/src/../include/logic.h" 1

#define KMUTEX_LOGIC_H 
/* Only logic declarations: canonical function contracts live in the src C files. */
/*@ Import Coq Require Import CRTOS_Verify.lib.KMutexCreate */
/*@ Import Coq Require Import CRTOS_Verify.lib.DoubleLinkListSpec */
/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskWakeup */
/*@ Import Coq Import DLL IDNode */
# 1 "/home/xinra/crtos/kmutexcreate-trial-261101-1/annotated_C/src/../include/monad.h" 1

#define CRTOS_MONAD_H 

/* Native QCP MonadErr declarations shared by all abstract-program Specs. */
/*@ Import Coq From MonadLib.MonadErr
      Require Import MonadErrBasic MonadErrHoare monadesafe_lib */
/*@ Import Coq Import Monad MonadNotation */
/*@ Import Coq Local Open Scope monad */
/*@ Extern Coq (program :: * => * => *) (unit :: *) */
/*@ Printing Coq Name program := MonadErr.M */
/*@ Printing Strategy Name program := MonadErr.M */
/*@ Extern Coq
      (safeExec : {Sigma} {A} ->
        (Sigma -> Prop) -> program Sigma A -> (A -> Sigma -> Prop) -> Prop)
      (return : {Sigma} {A} -> A -> program Sigma A)
      (tt : unit)
 */
/*@ Printing Coq Name safeExec := monadesafe_lib.safeExec */
/*@ Printing Coq Name return := MonadErr.ret */
# 9 "/home/xinra/crtos/kmutexcreate-trial-261101-1/annotated_C/src/../include/logic.h" 2
/*@ Extern Coq addr := Z */
/*@ Extern Coq (StableGlobalState :: *) (VarGlobalState :: *)
               (StableIdmanager :: *) (VarIdmanager :: *)
               (DL_Node :: * => *) */
/*@ Extern Coq
 (OutsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
 (InsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
 (os_inv : StableGlobalState -> VarGlobalState -> Assertion)
 (Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop)
 (Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop)
 (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
 (abs_mutex_create : StableGlobalState -> program (VarGlobalState -> Prop) Z)
 (addr_aligned : Z -> Z -> Prop)
 (MutexRaw : addr -> Assertion)
 (store_idmanager : StableIdmanager -> VarIdmanager -> addr -> Assertion)
 (store_idnode_insert_ready : addr -> Assertion)
 (idmanager_min_free_id : StableIdmanager -> VarIdmanager -> Z -> Prop)
 (idmanager_add : VarIdmanager -> Z -> VarIdmanager)
 (idmanager_link : StableIdmanager -> VarIdmanager -> Z -> addr -> VarIdmanager)
 (CharArray::undef_full : Z -> Z -> Assertion)
 (CharArray::full : Z -> Z -> list Z -> Assertion)
 (repeat_Z : {A} -> A -> Z -> list A)
 (store_node_self_linked : addr -> Assertion)
 (store_dll : {A} -> (addr -> A -> Assertion) -> addr -> list (DL_Node A) -> Assertion)
 (occupy_dll_node : addr -> Assertion)
 (nil : {A} -> list A)
 (cons : {A} -> A -> list A -> list A)
 (app : {A} -> list A -> list A -> list A)
 (Build_DL_Node : {A} -> A -> addr -> DL_Node A)
 (dll_insert_anchor : {A} -> addr -> list (DL_Node A) -> addr -> Prop)
 (dll_insert_after_dispatch : {A} -> addr -> list (DL_Node A) -> addr -> DL_Node A -> list (DL_Node A))
 (sched_link_of : addr -> addr)
 (store_ready_dll_tail_view : addr -> list (DL_Node Z) -> addr -> Assertion)
 (store_priority_ready_bucket : addr -> list (DL_Node Z) -> Assertion)
*/
# 3 "/home/xinra/crtos/kmutexcreate-trial-261101-1/annotated_C/src/_MutexCreate.c" 2

/*@ Import Coq Require Import CRTOS_Verify.VC.MutexCreate_lib */
/*@ Extern Coq (MutexAbs :: *) (MutexStable :: *)
               (TaskState :: *) (TaskDescriptorAbs :: *) (option :: * => *) */
/*@ Extern Coq MutexState := list MutexAbs */
/*@ Extern Coq
  (map : {A} {B} -> (A -> B) -> list A -> list B)
  (In : {A} -> A -> list A -> Prop)
  (os_mutex_stable : StableGlobalState -> MutexStable)
  (os_mutexes : VarGlobalState -> MutexState)
  (mutex_manager_stable : MutexStable -> StableIdmanager)
  (mutex_manager : MutexState -> VarIdmanager)
  (mutex_context : MutexStable -> Prop)
  (mutex_addr : MutexAbs -> addr)
  (mutex_created : Z -> Z -> MutexAbs)
  (mutex_publish : Z -> Z -> MutexState -> MutexState)
  (mutex_link_node : MutexAbs -> DL_Node MutexAbs)
  (replace_mutexes : MutexState -> VarGlobalState -> VarGlobalState)
  (os_tasks : VarGlobalState -> TaskState)
  (task_desc_map : TaskState -> addr -> option TaskDescriptorAbs)
  (pure_suspend_sched_link : (addr -> option TaskDescriptorAbs) -> addr -> addr -> Assertion)
  (store_mutex : (addr -> addr -> Assertion) -> addr -> MutexAbs -> Assertion)
  (mutex_create_frame : StableGlobalState -> VarGlobalState -> Assertion)
  (MutexZero : addr -> Assertion)
  (MutexPadding : addr -> Assertion)
  (NodeZero : addr -> Assertion)
*/

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
    struct Mutex *mutex = ((void *)0);

 mutex = x_malloc(sizeof(struct Mutex));
 if (mutex == ((void *)0)) {
  return -5;
 }

 memset(mutex, 0x0, sizeof(struct Mutex));
    /*@ 0 < mutex && mutex <= 4294967295 - sizeof(struct Mutex) && addr_aligned(mutex, 4) &&
        CharArray::full(mutex, sizeof(struct Mutex), repeat_Z(0, sizeof(struct Mutex)))
        which implies
        mutex != 0 && addr_aligned(mutex, 4) &&
        &mutex->pend_list != 0 && &mutex->link != 0 && MutexZero(mutex)
    */
    lock = CriticalAreaLock() /*@ where (ordinary) sg = sg, st1 = before */;
    /*@ Given st_lock */
    /*@ os_inv(sg, st_lock) * MutexZero(mutex)
        which implies
        mutex != 0 && addr_aligned(mutex, 4) &&
        mutex_context(os_mutex_stable(sg)) &&
        !(In(mutex, map(mutex_addr, os_mutexes(st_lock)))) &&
        mutex_create_frame(sg, st_lock) *
        store_idmanager(mutex_manager_stable(os_mutex_stable(sg)), mutex_manager(os_mutexes(st_lock)), &k_mutex_id_manager) *
        store_dll(store_mutex(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock)))), &k_mutex_list, map(mutex_link_node, os_mutexes(st_lock))) *
        store_idnode_insert_ready(&mutex->id) *
        data_at(&mutex->val, unsigned short, 0) *
        data_at(&mutex->recursive_cnt, unsigned char, 0) *
        data_at(&mutex->origin_prio, unsigned char, 0) *
        data_at(&mutex->holder, struct TaskDescriptor *, 0) *
        NodeZero(&mutex->pend_list) * NodeZero(&mutex->link) * MutexPadding(mutex)
    */

    id = IdInsertObj(&k_mutex_id_manager, &mutex->id)
      /*@ where sm = mutex_manager_stable(os_mutex_stable(sg)), m = mutex_manager(os_mutexes(st_lock)) */;
    /*@ idmanager_min_free_id(mutex_manager_stable(os_mutex_stable(sg)),
          mutex_manager(os_mutexes(st_lock)), id) => (0 <= id && id < 128) by local */
    if (id < 0) {
        /*@ mutex != 0 && addr_aligned(mutex, 4) &&
            &mutex->pend_list != 0 && &mutex->link != 0 &&
            safeExec(LastSeen(before), abs_mutex_create(sg), X) &&
            Crtos_RTrans(before, st_lock) &&
            mutex_create_frame(sg, st_lock) * store_idmanager(mutex_manager_stable(os_mutex_stable(sg)), mutex_manager(os_mutexes(st_lock)), &k_mutex_id_manager) * store_dll(store_mutex(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock)))), &k_mutex_list, map(mutex_link_node, os_mutexes(st_lock))) *
            store_idnode_insert_ready(&mutex->id) *
        data_at(&mutex->val, unsigned short, 0) *
        data_at(&mutex->recursive_cnt, unsigned char, 0) *
        data_at(&mutex->origin_prio, unsigned char, 0) *
        data_at(&mutex->holder, struct TaskDescriptor *, 0) *
        NodeZero(&mutex->pend_list) * NodeZero(&mutex->link) * MutexPadding(mutex)
            which implies
            safeExec(LastSeen(st_lock), return(-5), X) &&
            Crtos_GTrans(st_lock, st_lock) && os_inv(sg, st_lock) * MutexRaw(mutex)
        */
        CriticalAreaUnLock(lock)
          /*@ where (stable) sg = sg, st1 = st_lock, st2 = st_lock */;
        x_free(mutex);
        return -5;
    }

    /*@ NodeZero(&mutex->pend_list)
        which implies
        undef_data_at(&mutex->pend_list.node_prev) *
        undef_data_at(&mutex->pend_list.node_next)
    */
 InitDoubleLinkList(&mutex->pend_list);

    mutex->val = 1;
    mutex->holder = ((void *)0);
    mutex->origin_prio = 0xFF;
    mutex->recursive_cnt = 0;

    /*@ mutex != 0 && addr_aligned(mutex, 4) && &mutex->link != 0 &&
        idmanager_min_free_id(mutex_manager_stable(os_mutex_stable(sg)),
          mutex_manager(os_mutexes(st_lock)), id) &&
        data_at(&mutex->val, unsigned short, 1) *
        data_at(&mutex->recursive_cnt, unsigned char, 0) *
        data_at(&mutex->origin_prio, unsigned char, 255) *
        data_at(&mutex->holder, struct TaskDescriptor *, 0) *
        store_node_self_linked(&mutex->pend_list) * NodeZero(&mutex->link) * MutexPadding(mutex)
        which implies
        idmanager_min_free_id(mutex_manager_stable(os_mutex_stable(sg)),
          mutex_manager(os_mutexes(st_lock)), id) &&
        store_mutex(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock))), &mutex->link, mutex_created(mutex, id)) *
        occupy_dll_node(&mutex->link)
    */
 DoubleLinkListInsertNodeAfter(&k_mutex_list, &mutex->link)
      /*@ where (dispatch_case)
          storeA = store_mutex(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock)))), nodes = map(mutex_link_node, os_mutexes(st_lock)),
          a = mutex_created(mutex, id), head = &k_mutex_list; A = MutexAbs */;

    /*@ mutex != 0 && addr_aligned(mutex, 4) &&
        mutex_context(os_mutex_stable(sg)) &&
        idmanager_min_free_id(mutex_manager_stable(os_mutex_stable(sg)), mutex_manager(os_mutexes(st_lock)), id) &&
        !(In(mutex, map(mutex_addr, os_mutexes(st_lock)))) &&
        safeExec(LastSeen(before), abs_mutex_create(sg), X) && Crtos_RTrans(before, st_lock) &&
        mutex_create_frame(sg, st_lock) *
        store_idmanager(mutex_manager_stable(os_mutex_stable(sg)), idmanager_link(mutex_manager_stable(os_mutex_stable(sg)), idmanager_add(mutex_manager(os_mutexes(st_lock)), id), id, &mutex->id), &k_mutex_id_manager) *
        store_dll(store_mutex(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock)))), &k_mutex_list,
          dll_insert_after_dispatch(&k_mutex_list, map(mutex_link_node, os_mutexes(st_lock)), &k_mutex_list,
            Build_DL_Node(mutex_created(mutex, id), &mutex->link)))
        which implies
        0 <= id && id < 128 &&
        safeExec(LastSeen(replace_mutexes(mutex_publish(mutex, id, os_mutexes(st_lock)), st_lock)), return(id), X) &&
        Crtos_GTrans(st_lock, replace_mutexes(mutex_publish(mutex, id, os_mutexes(st_lock)), st_lock)) && os_inv(sg, replace_mutexes(mutex_publish(mutex, id, os_mutexes(st_lock)), st_lock))
    */
    CriticalAreaUnLock(lock)
      /*@ where (stable) sg = sg, st1 = st_lock, st2 = replace_mutexes(mutex_publish(mutex, id, os_mutexes(st_lock)), st_lock) */;

    return id;
}
