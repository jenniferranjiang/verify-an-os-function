# 0 "/home/xinra/crtos/keventcreate-trial-261101-1/annotated_C/src/_EventCreate.c"
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
# 1 "/home/xinra/crtos/keventcreate-trial-261101-1/annotated_C/src/_EventCreate.c"
# 1 "/home/xinra/crtos/keventcreate-trial-261101-1/annotated_C/src/../include/slice_types.h" 1

#define KEVENT_SLICE_TYPES_H 
/* ILP32 non-SMP slice. Full layouts of every accessed struct are retained.
 * Origin: kernel/include/xs_{base,klist,id,event}.h and configured xsconfig.h. */
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
/* TrustBase bitfield adaptation: original options:3/events:29 occupy one
 * uint32; here each has a separate uint32 cell. Assignment must preserve
 * truncation. Model offsets id=0/options=12/events=16/pend=20/link=28,size=36;
 * authoritative ILP32 offsets pend=16/link=24,size=32. */
struct Event {
    struct IdNode id;
    uint32 options;
    uint32 events;
    DoubleLinklistType pend_list;
    DoubleLinklistType link;
};
#define NONE ((void *)0)
#define ENOMEMORY 5
#define UINT_MAX 4294967295U
#define ALIGN_SIZE 4
#define ID_NUM_MAX 128
#define ID_HTABLE_SIZE 16
#define KERNEL_EVENT 
extern struct IdManager k_event_id_manager;
extern DoubleLinklistType k_event_list;
# 2 "/home/xinra/crtos/keventcreate-trial-261101-1/annotated_C/src/_EventCreate.c" 2
# 1 "/home/xinra/crtos/keventcreate-trial-261101-1/annotated_C/src/../include/logic.h" 1

#define KEVENT_LOGIC_H 
/* Only logic declarations: canonical function contracts live in the src C files. */
/*@ Import Coq Require Import CRTOS_Verify.lib.KEventCreate */
/*@ Import Coq Require Import CRTOS_Verify.lib.DoubleLinkListSpec */
/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskWakeup */
/*@ Import Coq Import DLL IDNode */
# 1 "/home/xinra/crtos/keventcreate-trial-261101-1/annotated_C/src/../include/monad.h" 1

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
# 9 "/home/xinra/crtos/keventcreate-trial-261101-1/annotated_C/src/../include/logic.h" 2
/*@ Extern Coq addr := Z */
/*@ Extern Coq (StableGlobalState :: *) (VarGlobalState :: *)
               (StableIdmanager :: *) (VarIdmanager :: *)
               (DL_Node :: * => *) (EventStable :: *) (EventAbs :: *)
               (TaskState :: *) (TaskDescriptorAbs :: *) (option :: * => *) */
/*@ Extern Coq EventState := list EventAbs */
/*@ Extern Coq
 (os_event_stable : StableGlobalState -> EventStable)
 (os_events : VarGlobalState -> EventState)
 (event_manager_stable : EventStable -> StableIdmanager)
 (event_manager : EventState -> VarIdmanager)
 (event_created : Z -> Z -> Z -> EventAbs)
 (event_publish : Z -> Z -> Z -> EventState -> EventState)
 (event_link_node : EventAbs -> DL_Node EventAbs)
 (store_event : (addr -> addr -> Assertion) -> addr -> EventAbs -> Assertion)
 (replace_events : EventState -> VarGlobalState -> VarGlobalState)
 (os_tasks : VarGlobalState -> TaskState)
 (task_desc_map : TaskState -> addr -> option TaskDescriptorAbs)
 (pure_suspend_sched_link : (addr -> option TaskDescriptorAbs) -> addr -> addr -> Assertion)
 (map : {A} {B} -> (A -> B) -> list A -> list B)
 (OutsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
 (InsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
 (os_inv : StableGlobalState -> VarGlobalState -> Assertion)
 (Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop)
 (Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop)
 (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
 (abs_event_create : StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
 (addr_aligned : Z -> Z -> Prop)
 (EventRaw : addr -> Assertion)
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
# 3 "/home/xinra/crtos/keventcreate-trial-261101-1/annotated_C/src/_EventCreate.c" 2

/*@ Import Coq Require Import CRTOS_Verify.VC.EventCreate_lib */
/*@ Extern Coq
  (In : {A} -> A -> list A -> Prop)
  (event_addr : EventAbs -> addr)
  (event_context : EventStable -> Prop)
  (event_create_frame : StableGlobalState -> VarGlobalState -> Assertion)
  (EventZero : addr -> Assertion)
  (EventPadding : addr -> Assertion)
  (NodeZero : addr -> Assertion)
*/

/* TrustBase primitive boundary; no implementation claim. */
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

/* TrustBase primitive boundary; no implementation claim. */
void *memset(void *s, int c, size_t n)
/*@ Require 0 <= n && n <= UINT_MAX &&
            0 <= c && c <= 127 &&
            CharArray::undef_full(s, n)
    Ensure __return == s && CharArray::full(s, n, repeat_Z(c, n))
*/
;

/* TrustBase primitive boundary; no implementation claim. */
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

/* reused-spec: root annotated_C/src/headers/id_module_spec.h. */
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

/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/double_link.c. Current 32-bit non-SMP configuration. */


void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ Require
      undef_data_at(&(linklist_head->node_prev)) *
      undef_data_at(&(linklist_head->node_next))
    Ensure
      linklist_head != 0 && store_node_self_linked(linklist_head)
 */;

/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/double_link.c. Current 32-bit non-SMP configuration. */


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

/* TrustBase primitive boundary; no implementation claim. */
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

/* TrustBase KERNEL_FREE boundary, instantiated for this complete allocation.
 * EventRaw owns every model byte; conversion to raw allocation bytes is a
 * separately recorded, unproved design obligation in EventInv. */
void x_free(void *ptr)
/*@ event_object
    Require EventRaw(ptr)
    Ensure emp
 */;

/* Source event.c::_EventCreate; static-to-slice-external normalization. */
int32 _EventCreate(uint32 options)
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_event_create(sg, options), X) &&
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
    /*@ 0 <= options@pre && options@pre <= 4294967295 by local */
    int32 id = 0;
    x_base lock = 0;
    struct Event *event = ((void *)0);

    event = (struct Event *)x_malloc(sizeof(struct Event));
    if (event == ((void *)0))
        return -5;

    memset(event, 0, sizeof(struct Event));
    /*@ 0 < event && event <= 4294967295 - sizeof(struct Event) &&
        addr_aligned(event, 4) &&
        CharArray::full(event, sizeof(struct Event), repeat_Z(0, sizeof(struct Event))) *
        data_at(&options, unsigned int, options@pre)
        which implies
        event != 0 && addr_aligned(event, 4) &&
        &event->pend_list != 0 && &event->link != 0 && EventZero(event) *
        data_at(&options, unsigned int, options@pre)
    */
    lock = CriticalAreaLock()
      /*@ where (ordinary) sg = sg, st1 = before */;
    /*@ Given st_lock */
    /*@ os_inv(sg, st_lock) * EventZero(event) * data_at(&options, unsigned int, options@pre)
        which implies
        event != 0 && addr_aligned(event, 4) &&
        event_context(os_event_stable(sg)) &&
        !(In(event, map(event_addr, os_events(st_lock)))) &&
        event_create_frame(sg, st_lock) *
        store_idmanager(event_manager_stable(os_event_stable(sg)),
                        event_manager(os_events(st_lock)), &k_event_id_manager) *
        store_dll(store_event(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock)))),
                  &k_event_list, map(event_link_node, os_events(st_lock))) *
        store_idnode_insert_ready(&event->id) *
        data_at(&event->options, unsigned int, 0) *
        data_at(&event->events, unsigned int, 0) *
        NodeZero(&event->pend_list) * NodeZero(&event->link) * EventPadding(event) *
        data_at(&options, unsigned int, options@pre)
    */
    id = IdInsertObj(&k_event_id_manager, &event->id)
      /*@ where sm = event_manager_stable(os_event_stable(sg)),
                m = event_manager(os_events(st_lock)) */;
    /*@ idmanager_min_free_id(event_manager_stable(os_event_stable(sg)),
          event_manager(os_events(st_lock)), id) => (0 <= id && id < 128) by local */
    if (id < 0) {
        /*@ event != 0 && addr_aligned(event, 4) &&
            &event->pend_list != 0 && &event->link != 0 &&
            safeExec(LastSeen(before), abs_event_create(sg, options@pre), X) &&
            Crtos_RTrans(before, st_lock) &&
            event_create_frame(sg, st_lock) *
            store_idmanager(event_manager_stable(os_event_stable(sg)),
                            event_manager(os_events(st_lock)), &k_event_id_manager) *
            store_dll(store_event(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock)))),
                      &k_event_list, map(event_link_node, os_events(st_lock))) *
            store_idnode_insert_ready(&event->id) *
            data_at(&event->options, unsigned int, 0) *
            data_at(&event->events, unsigned int, 0) *
            NodeZero(&event->pend_list) * NodeZero(&event->link) * EventPadding(event) *
            data_at(&options, unsigned int, options@pre)
            which implies
            safeExec(LastSeen(st_lock), return(-5), X) &&
            Crtos_GTrans(st_lock, st_lock) && os_inv(sg, st_lock) * EventRaw(event) *
            data_at(&options, unsigned int, options@pre)
        */
        CriticalAreaUnLock(lock)
          /*@ where (stable) sg = sg, st1 = st_lock, st2 = st_lock */;
        x_free(event);
        return -5;
    }

    /* Preserve original unsigned 3-bit assignment after field expansion. */
    event->options = options & 7U;
    /*@ NodeZero(&event->pend_list)
        which implies
        undef_data_at(&event->pend_list.node_prev) *
        undef_data_at(&event->pend_list.node_next)
    */
    InitDoubleLinkList(&event->pend_list);
    /*@ event != 0 && addr_aligned(event, 4) && &event->link != 0 &&
        idmanager_min_free_id(event_manager_stable(os_event_stable(sg)),
                             event_manager(os_events(st_lock)), id) &&
        data_at(&event->options, unsigned int, options@pre & 7) *
        data_at(&event->events, unsigned int, 0) *
        store_node_self_linked(&event->pend_list) * NodeZero(&event->link) * EventPadding(event) *
        data_at(&options, unsigned int, options@pre)
        which implies
        event != 0 && addr_aligned(event, 4) && &event->link != 0 &&
        idmanager_min_free_id(event_manager_stable(os_event_stable(sg)),
                             event_manager(os_events(st_lock)), id) &&
        store_event(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock))),
                    &event->link, event_created(event, id, options@pre)) *
        occupy_dll_node(&event->link) * data_at(&options, unsigned int, options@pre)
    */

    DoubleLinkListInsertNodeAfter(&k_event_list, &event->link)
      /*@ where (dispatch_case)
          storeA = store_event(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock)))),
          nodes = map(event_link_node, os_events(st_lock)),
          a = event_created(event, id, options@pre), head = &k_event_list; A = EventAbs */;
    /*@ event != 0 && addr_aligned(event, 4) &&
        event_context(os_event_stable(sg)) &&
        idmanager_min_free_id(event_manager_stable(os_event_stable(sg)),
                             event_manager(os_events(st_lock)), id) &&
        !(In(event, map(event_addr, os_events(st_lock)))) &&
        safeExec(LastSeen(before), abs_event_create(sg, options@pre), X) &&
        Crtos_RTrans(before, st_lock) &&
        data_at(&options, unsigned int, options@pre) *
        event_create_frame(sg, st_lock) *
        store_idmanager(event_manager_stable(os_event_stable(sg)),
          idmanager_link(event_manager_stable(os_event_stable(sg)),
            idmanager_add(event_manager(os_events(st_lock)), id), id, &event->id),
          &k_event_id_manager) *
        store_dll(store_event(pure_suspend_sched_link(task_desc_map(os_tasks(st_lock)))),
          &k_event_list,
          dll_insert_after_dispatch(&k_event_list, map(event_link_node, os_events(st_lock)),
            &k_event_list, Build_DL_Node(event_created(event, id, options@pre), &event->link)))
        which implies
        0 <= id && id < 128 &&
        safeExec(LastSeen(replace_events(event_publish(event, id, options@pre, os_events(st_lock)), st_lock)),
                 return(id), X) &&
        Crtos_GTrans(st_lock, replace_events(event_publish(event, id, options@pre, os_events(st_lock)), st_lock)) &&
        os_inv(sg, replace_events(event_publish(event, id, options@pre, os_events(st_lock)), st_lock)) *
        data_at(&options, unsigned int, options@pre)
    */
    CriticalAreaUnLock(lock)
      /*@ where (stable) sg = sg, st1 = st_lock,
          st2 = replace_events(event_publish(event, id, options@pre, os_events(st_lock)), st_lock) */;

    return id;
}
