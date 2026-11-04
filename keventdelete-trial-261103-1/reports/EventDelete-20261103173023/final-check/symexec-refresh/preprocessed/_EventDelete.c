# 0 "/home/xinra/crtos/keventdelete-trial-261103-1/annotated_C/src/_EventDelete.c"
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
# 1 "/home/xinra/crtos/keventdelete-trial-261103-1/annotated_C/src/_EventDelete.c"
# 1 "/home/xinra/crtos/keventdelete-trial-261103-1/annotated_C/src/../include/slice_types.h" 1

#define KEVENTDELETE_SLICE_TYPES_H 
/* ABI-only declarations from current xs_base/xs_klist/xs_id/xs_sem/xs_ktask,
 * xs_delay and xs_assign. ILP32, non-SMP, RR_REMAINSLICE, 32 priorities.
 * The two task event bitfields are expanded to uint32 under TrustBase.
 * No API contracts or executable macro replacements live in this header. */
typedef signed int int32;
typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;
typedef signed long x_base;
typedef unsigned long x_ubase;
typedef x_base x_err_t;
typedef unsigned int x_ticks_t;
typedef unsigned char BOOL;
#define NONE ((void *)0)
#define EOK 0
#define ERROR 1
#define RET_TRUE 1
#define KTASK_READY 1
#define KTASK_SUSPEND 2
#define KTASK_STAT_MASK 7
#define KTASK_MAX_ADVANCE_PROCESS_TIME 1
#define TASK_DELAY_INACTIVE 0
#define TASK_DELAY_ACTIVE 1
struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
};
typedef struct SysDoubleLinklistNode DoubleLinklistType;
struct IdNode { uint16 id; DoubleLinklistType link; };
struct IdManager { uint16 id_max; uint16 hoffset; uint8 *id_map; DoubleLinklistType *htable; };
struct Event { struct IdNode id; uint32 options; uint32 events; DoubleLinklistType pend_list; DoubleLinklistType link; };
struct TaskDescriptor;
struct Delay { struct TaskDescriptor *task; x_ticks_t ticks; uint8 status; DoubleLinklistType link; };
typedef struct Delay *DelayType;
struct TaskBaseInfo {
    char name[32]; void *func_entry; void *func_param; uint8 origin_prio;
    uint32 stack_depth; void *stack_start;
};
typedef struct TaskBaseInfo TaskBaseInfoType;
struct TaskDyncSchedMember {
    uint8 stat; uint8 advance_cnt; uint8 cur_prio;
    x_ubase origin_timeslice; x_ubase rest_timeslice;
    DoubleLinklistType sched_link; uint32 bitmap_column; DelayType delay;
};
typedef struct TaskDyncSchedMember TaskDyncSchedMembeType;
struct KTaskDone;
struct TaskDescriptor {
    void *stack_point;
    TaskDyncSchedMembeType task_dync_sched_member;
    TaskBaseInfoType task_base_info;
    uint32 event_id_trigger; uint32 event_mode;
    x_err_t exstatus; DoubleLinklistType link; struct IdNode id; struct KTaskDone *Done;
};
typedef struct TaskDescriptor *KTaskDescriptorType;
extern struct IdManager k_event_id_manager;
extern DoubleLinklistType k_event_list;
# 2 "/home/xinra/crtos/keventdelete-trial-261103-1/annotated_C/src/_EventDelete.c" 2
# 1 "/home/xinra/crtos/keventdelete-trial-261103-1/annotated_C/src/../include/logic.h" 1

#define KEVENTDELETE_LOGIC_H 
/* Semantic declarations only. All function contracts are canonical in src/
 * and copied before direct calls; there is no module-wide contract header. */
/*@ Import Coq Require Import CRTOS_Verify.lib.IdModuleSpec CRTOS_Verify.lib.DoubleLinkListSpec */
/*@ Import Coq Require Import CRTOS_Verify.lib.KEventDelete */
/*@ Import Coq Import IDNode DLL MonadErr */
/*@ Extern Coq addr := Z */
/*@ Extern Coq
  (DL_Node :: * => *) (option :: * => *) (unit :: *)
  (StableGlobalState :: *) (VarGlobalState :: *)
  (StableIdmanager :: *) (VarIdmanager :: *) (IdNodeAbs :: *)
  (TaskStatus :: *) (TaskState :: *)
  (TaskDescriptorAbs :: *) (TaskSchedMemberAbs :: *)
  (program :: * => * => *)
 */
/*@ Extern Coq Record StableIdmanager { idmax: Z; hoffset: Z; id_map: Z; htable: Z; } */
/*@ Extern Coq Record TaskSchedMemberAbs { tsmStat: TaskStatus; } */
/*@ Extern Coq Record TaskDescriptorAbs { tdSchedMember: TaskSchedMemberAbs; tdDelay: Z; } */
/*@ Extern Coq Record TaskState { task_desc_map: addr -> option TaskDescriptorAbs; } */
/*@ Extern Coq Record VarGlobalState { os_tasks: TaskState; } */
/*@ Extern Coq
  (Some : {A} -> A -> option A) (None : {A} -> option A)
  (tt : unit) (true : bool) (false : bool)
  (Build_IdNodeAbs : Z -> addr -> IdNodeAbs)
  (Build_DL_Node : {A} -> A -> addr -> DL_Node A)
  (nil : {A} -> list A) (cons : {A} -> A -> list A -> list A)
  (app : {A} -> list A -> list A -> list A)
  (store_idmanager : StableIdmanager -> VarIdmanager -> addr -> Assertion)
  (store_idmanager_found : StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion)
  (store_idnode_insert_ready : addr -> Assertion)
  (idmanager_query : VarIdmanager -> Z -> bool)
  (idmanager_remove : StableIdmanager -> VarIdmanager -> Z -> VarIdmanager)
  (idmanager_add : VarIdmanager -> Z -> VarIdmanager)
  (idmanager_link : StableIdmanager -> VarIdmanager -> Z -> addr -> VarIdmanager)
  (idmanager_contains : StableIdmanager -> VarIdmanager -> Z -> Z -> Prop)
  (store_dll : {A} -> (addr -> A -> Assertion) -> addr -> list(DL_Node A) -> Assertion)
  (store_node_self_linked : addr -> Assertion)
  (store_task_sched_member : addr -> TaskSchedMemberAbs -> Assertion)
  (store_priority_ready_bucket : addr -> list(DL_Node addr) -> Assertion)
  (sched_link_of : addr -> addr) (sched_link_node : addr -> DL_Node addr)
  (ALIGN_SIZE : Z) (addr_aligned : addr -> Z -> Prop)
  (TSK_SUSPEND : TaskStatus)
  (get_task_with_idnode_success : StableGlobalState -> VarGlobalState -> Z -> addr -> Prop)
  (ktask_wakeup_step : addr -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop)
  (ktask_wakeup_detached_null_condition : StableGlobalState -> VarGlobalState -> Z -> Prop)
  (ktask_wakeup_detached_null_step : addr -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop)
  (semaphore_pending_nodes : addr -> VarGlobalState -> list(DL_Node addr) -> Prop)
  (wakeup_semaphore_head : addr -> addr -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop)
  (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
  (safeExec : {Sigma} {A} -> (Sigma -> Prop) -> program Sigma A -> (A -> Sigma -> Prop) -> Prop)
  (return : {Sigma} {A} -> A -> program Sigma A)
  (OutsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
  (InsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
  (Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop)
  (Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop)
  (os_inv : StableGlobalState -> VarGlobalState -> Assertion)
  (EventRaw : addr -> Assertion)
  (event_delete_guard : Z -> addr -> bool -> VarGlobalState -> Prop)
  (event_delete_gap : Z -> addr -> bool -> VarGlobalState -> VarGlobalState -> Prop)
  (event_pending_head : addr -> addr)
  (abs_find_event : Z -> program (VarGlobalState -> Prop) addr)
  (abs_event_resume_all : Z -> addr -> program (VarGlobalState -> Prop) unit)
  (abs_event_delete_at : Z -> addr -> program (VarGlobalState -> Prop) unit)
  (abs_event_delete : Z -> program (VarGlobalState -> Prop) unit)
  (abs_ktask_assign : program (VarGlobalState -> Prop) unit)
 */
/*@ Printing Coq Name program := MonadErr.M */
/*@ Printing Strategy Name program := MonadErr.M */
/*@ Printing Coq Name safeExec := monadesafe_lib.safeExec */
/*@ Printing Coq Name return := MonadErr.ret */
# 3 "/home/xinra/crtos/keventdelete-trial-261103-1/annotated_C/src/_EventDelete.c" 2

/*@ Import Coq Require Import CRTOS_Verify.VC.EventDelete_lib */
/*@ Extern Coq (EventAbs :: *) (EventStable :: *) */
/*@ Extern Coq EventState := list EventAbs */
/*@ Extern Coq
  (os_events : VarGlobalState -> EventState)
  (os_event_stable : StableGlobalState -> EventStable)
  (event_manager_stable : EventStable -> StableIdmanager)
  (event_list_head : EventStable -> addr)
  (event_manager : EventState -> VarIdmanager)
  (event_addr : EventAbs -> addr) (event_id : EventAbs -> Z)
  (event_options : EventAbs -> Z) (event_events : EventAbs -> Z)
  (event_pending_addrs : EventAbs -> list addr)
  (event_wait_node : addr -> DL_Node addr)
  (event_link_node : EventAbs -> DL_Node EventAbs)
  (event_pending_at : Z -> addr -> list addr -> VarGlobalState -> Prop)
  (event_create_frame : StableGlobalState -> VarGlobalState -> Assertion)
  (store_event : (addr -> addr -> Assertion) -> addr -> EventAbs -> Assertion)
  (pure_suspend_sched_link : (addr -> option TaskDescriptorAbs) -> addr -> addr -> Assertion)
  (event_delete_pending_restore : StableGlobalState -> VarGlobalState -> addr -> list addr -> Assertion)
  (event_delete_id_restore : StableGlobalState -> VarGlobalState -> addr -> Z -> Assertion)
  (event_delete_finish : Z -> addr -> bool -> program (VarGlobalState -> Prop) unit)
  (event_delete_resume_cont : Z -> addr -> (unit -> (VarGlobalState -> Prop) -> Prop) -> unit -> (VarGlobalState -> Prop) -> Prop)
  (EventRetired : addr -> Z -> Z -> Assertion)
  (event_unpublish : addr -> EventState -> EventState)
  (replace_events : EventState -> VarGlobalState -> VarGlobalState)
  (In : {A} -> A -> list A -> Prop)
  (NoDup : {A} -> list A -> Prop)
  (map : {A} {B} -> (A -> B) -> list A -> list B)
 */

/* Imported contract boundary; source/revision: checks/source-slices/manifest.json. */
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

/* This named boundary is valid only under the user-approved D1/D2 execution
 * restrictions of this EventDelete experiment. It is NOT derived from ordinary
 * locking and does not assert that the kernel enforces those restrictions.
 * D1 concerns the same allocation throughout the lookup-to-unpublish interval;
 * equal pointer/ID snapshots alone do not establish freedom from ABA. */
x_base CriticalAreaLock(void)
/*@ event_delete_gap
    With (sg : StableGlobalState) (before : VarGlobalState)
         (id p : Z) (empty : bool)
    Require event_delete_guard(id, p, empty, before) &&
            OutsideCritical(sg, before)
    Ensure exists current,
      event_delete_gap(id, p, empty, before, current) &&
      InsideCritical(sg, current) * os_inv(sg, current)
 */;

/* Imported contract boundary; source/revision: checks/source-slices/manifest.json. */
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

/* Imported contract boundary; source/revision: checks/source-slices/manifest.json. */
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
 */;

/* Imported contract boundary; source/revision: checks/source-slices/manifest.json. */
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
           field_addr(idnode, struct IdNode, link) != 0 &&
           store_idmanager(sm,
             idmanager_remove(sm,
               idmanager_link(sm, idmanager_add(m, id), id, idnode), id),
             manager) *
           store(field_addr(idnode, struct IdNode, id), unsigned short, 65535) *
           store(field_addr(field_addr(idnode, struct IdNode, link), struct SysDoubleLinklistNode, node_prev), struct SysDoubleLinklistNode *, field_addr(idnode, struct IdNode, link)) *
           store(field_addr(field_addr(idnode, struct IdNode, link), struct SysDoubleLinklistNode, node_next), struct SysDoubleLinklistNode *, field_addr(idnode, struct IdNode, link))
*/;

void IdRemoveObj(struct IdManager *manager, uint16 id)
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
              field_addr(idnode, struct IdNode, link) != 0 &&
              store_idmanager(sm, idmanager_remove(sm, m, id), manager) *
              store(field_addr(idnode, struct IdNode, id), unsigned short, 65535) *
              store(field_addr(field_addr(idnode, struct IdNode, link), struct SysDoubleLinklistNode, node_prev), struct SysDoubleLinklistNode *, field_addr(idnode, struct IdNode, link)) *
              store(field_addr(field_addr(idnode, struct IdNode, link), struct SysDoubleLinklistNode, node_next), struct SysDoubleLinklistNode *, field_addr(idnode, struct IdNode, link)))
*/;

/* Imported contract boundary; source/revision: checks/source-slices/manifest.json. */
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
 */;

void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
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
 */;

void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
/*@ remove_self
    With (node : Z)
    Require
      linklist_node == node &&
      node != 0 &&
      store_node_self_linked(node)
    Ensure
      store_node_self_linked(node)
 */;

void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
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
*/;

void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
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
*/;

/* Trusted KERNEL_FREE/x_free boundary under TrustBase; owns the complete
 * detached Event allocation, including padding. Not a new implementation proof. */
void x_free(void *ptr)
/*@ Require EventRaw(ptr)
    Ensure emp
 */;

/* Imported contract boundary; source/revision: checks/source-slices/manifest.json. */
void KTASK_ASSIGN(void)
/*@ outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_ktask_assign, X) && OutsideCritical(sg, before)
    Ensure exists after, safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */;

x_err_t LinklistResumeAll(DoubleLinklistType *list)
/*@ event_waiters_oc
    With (sg : StableGlobalState) (before : VarGlobalState) (id p : Z) X
    Require list == event_pending_head(p) &&
      event_delete_guard(id, p, false, before) &&
      safeExec(LastSeen(before), abs_event_resume_all(id, p), X) &&
      OutsideCritical(sg, before)
    Ensure __return == 0 && exists after,
      event_delete_guard(id, p, true, after) &&
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */;

void _EventDelete(struct Event *event)
/*@ event_delete_at_oc
    With (sg : StableGlobalState) (before : VarGlobalState) (id : Z) X
    Require event_delete_guard(id, event, false, before) &&
      safeExec(LastSeen(before), abs_event_delete_at(id, event), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */
{
    int resched = 0;
    x_base lock = 0;
    x_base inspect_lock = 0;
    int pending_empty;

    if (event == ((void *)0)) {
        /*@ Inv Assert event == event@pre && event == 0 &&
          event_delete_guard(id, event, false, before) &&
          safeExec(LastSeen(before), abs_event_delete_at(id, event), X) &&
          has_permission(&resched) * has_permission(&lock) *
          has_permission(&inspect_lock) * has_permission(&pending_empty) *
          OutsideCritical(sg, before)
         */
        while (1) { }
    }

    inspect_lock = CriticalAreaLock()
      /*@ where (event_delete_gap) sg = sg, before = before, id = id, p = event, empty = false */;
    /*@ Given checked from current */
    /*@ event_delete_gap(id, event@pre, false, before, checked) && os_inv(sg, checked)
        which implies exists waiting,
          event_pending_at(id, event@pre, waiting, checked) &&
          event_delete_gap(id, event@pre, false, before, checked) &&
          event_delete_guard(id, event@pre, false, checked) &&
          event_pending_head(event@pre) == field_addr(event@pre, struct Event, pend_list) &&
          store_dll(pure_suspend_sched_link(checked.os_tasks.task_desc_map),
            field_addr(event@pre, struct Event, pend_list), map(event_wait_node, waiting)) *
          event_delete_pending_restore(sg, checked, event@pre, waiting)
     */
    /*@ Given waiting */
    pending_empty = IsDoubleLinkListEmpty(&event->pend_list)
      /*@ where (dll) storeA = pure_suspend_sched_link(checked.os_tasks.task_desc_map),
           nodes = map(event_wait_node, waiting); A = addr */;
    /*@ event_pending_at(id, event@pre, waiting, checked) &&
        store_dll(pure_suspend_sched_link(checked.os_tasks.task_desc_map),
          field_addr(event@pre, struct Event, pend_list), map(event_wait_node, waiting)) *
        event_delete_pending_restore(sg, checked, event@pre, waiting)
        which implies event_pending_at(id, event@pre, waiting, checked) &&
          Crtos_GTrans(checked, checked) && os_inv(sg, checked)
     */
    CriticalAreaUnLock(inspect_lock) /*@ where (stable) sg = sg, st1 = checked, st2 = checked */;
    if (!pending_empty) {
        /*@ event_pending_at(id, event@pre, waiting, checked) &&
            event_delete_gap(id, event@pre, false, before, checked) &&
            map(event_wait_node, waiting) != nil &&
            safeExec(LastSeen(before), abs_event_delete_at(id, event@pre), X) &&
            OutsideCritical(sg, checked)
            which implies event_delete_guard(id, event@pre, false, checked) &&
              safeExec(LastSeen(checked), abs_event_resume_all(id, event@pre),
                event_delete_resume_cont(id, event@pre, X)) && OutsideCritical(sg, checked)
         */
        resched = 1;
        LinklistResumeAll(&event->pend_list)
          /*@ where (event_waiters_oc) sg = sg, before = checked, id = id, p = event,
               X = event_delete_resume_cont(id, event@pre, X) */;
        /*@ Given drained from after */
        /*@ safeExec(LastSeen(drained), return(tt), event_delete_resume_cont(id, event@pre, X)) &&
            OutsideCritical(sg, drained)
            which implies safeExec(LastSeen(drained), event_delete_finish(id, event@pre, true), X) &&
              OutsideCritical(sg, drained)
         */
    } else {
        /*@ event_pending_at(id, event@pre, waiting, checked) &&
            event_delete_gap(id, event@pre, false, before, checked) &&
            map(event_wait_node, waiting) == nil &&
            safeExec(LastSeen(before), abs_event_delete_at(id, event@pre), X) &&
            OutsideCritical(sg, checked)
            which implies event_delete_guard(id, event@pre, true, checked) &&
              safeExec(LastSeen(checked), event_delete_finish(id, event@pre, false), X) &&
              OutsideCritical(sg, checked)
         */
    }

    /*@ Assert exists ready,
      event == event@pre &&
      ((resched == 0 && safeExec(LastSeen(ready), event_delete_finish(id, event, false), X)) ||
       (resched == 1 && safeExec(LastSeen(ready), event_delete_finish(id, event, true), X))) &&
      event_delete_guard(id, event, true, ready) &&
      has_permission(&lock) * has_permission(&inspect_lock) * has_permission(&pending_empty) *
      OutsideCritical(sg, ready)
     */
    /*@ Given ready */
    lock = CriticalAreaLock()
      /*@ where (event_delete_gap) sg = sg, before = ready, id = id, p = event, empty = true */;
    /*@ Given locked from current */
    /*@ event_delete_gap(id, event@pre, true, ready, locked) && os_inv(sg, locked)
        which implies exists (original : EventAbs) (prefix suffix : list EventAbs),
          os_events(locked) == app(prefix, cons(original, suffix)) &&
          event_addr(original) == event@pre && event_id(original) == id &&
          event_pending_addrs(original) == nil && event@pre != 0 && 0 <= id && id < 65536 &&
          NoDup(map(event_addr, os_events(locked))) &&
          NoDup(map(event_id, os_events(locked))) &&
          idmanager_remove(event_manager_stable(os_event_stable(sg)), event_manager(os_events(locked)), id) ==
            event_manager(event_unpublish(event@pre, os_events(locked))) &&
          idmanager_query(event_manager(os_events(locked)), id) == true &&
          store(field_addr(field_addr(event@pre, struct Event, id), struct IdNode, id), unsigned short, id) *
          event_delete_id_restore(sg, locked, event@pre, id)
     */
    /*@ Given original prefix suffix */
    /* Equivalent expression split: read this uint16 exactly once before restoring the manager. */
    uint16 delete_event_id = event->id.id;
    /*@ store(field_addr(field_addr(event@pre, struct Event, id), struct IdNode, id), unsigned short, id) *
        event_delete_id_restore(sg, locked, event@pre, id)
        which implies os_inv(sg, locked)
     */
    /*@ os_events(locked) == app(prefix, cons(original, suffix)) &&
        event_addr(original) == event@pre && os_inv(sg, locked)
        which implies os_events(locked) == app(prefix, cons(original, suffix)) &&
          event_addr(original) == event@pre &&
          store_idmanager(event_manager_stable(os_event_stable(sg)),
            event_manager(os_events(locked)), &k_event_id_manager) *
          event_create_frame(sg, locked) *
          store_dll(store_event(pure_suspend_sched_link(locked.os_tasks.task_desc_map)),
            event_list_head(os_event_stable(sg)),
            app(map(event_link_node, prefix),
              cons(Build_DL_Node(original, field_addr(event@pre, struct Event, link)), map(event_link_node, suffix))))
     */
    IdRemoveObj(&k_event_id_manager, delete_event_id)
      /*@ where (low_level_spec) sm = event_manager_stable(os_event_stable(sg)), m = event_manager(os_events(locked)) */;
    DoubleLinkListRmNode(&event->link)
      /*@ where (remove_member) storeA = store_event(pure_suspend_sched_link(locked.os_tasks.task_desc_map)),
           head = event_list_head(os_event_stable(sg)), a = original,
           prefix = map(event_link_node, prefix), suffix = map(event_link_node, suffix); A = EventAbs */;
    /*@ Assert exists after saved_lock,
      lock == saved_lock && event == event@pre && delete_event_id == id &&
      after == replace_events(event_unpublish(event, os_events(locked)), locked) &&
      ((resched == 0 && safeExec(LastSeen(after), return(tt), X)) ||
       (resched == 1 && safeExec(LastSeen(after), abs_ktask_assign, X))) &&
      Crtos_GTrans(locked, after) &&
      has_permission(&inspect_lock) * has_permission(&pending_empty) *
      InsideCritical(sg, locked) * os_inv(sg, after) *
      EventRetired(event, event_options(original), event_events(original))
     */
    /*@ Given after saved_lock */
    CriticalAreaUnLock(lock) /*@ where (stable) sg = sg, st1 = locked, st2 = after */;
    /*@ EventRetired(event@pre, event_options(original), event_events(original))
        which implies EventRaw(event@pre)
     */
    x_free(event);

    if (resched)
        KTASK_ASSIGN() /*@ where (outside_critical) sg = sg, before = after, X = X */;
}
