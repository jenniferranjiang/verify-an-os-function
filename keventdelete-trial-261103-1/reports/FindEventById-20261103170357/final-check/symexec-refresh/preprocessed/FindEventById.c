# 0 "/home/xinra/crtos/keventdelete-trial-261103-1/annotated_C/src/FindEventById.c"
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
# 1 "/home/xinra/crtos/keventdelete-trial-261103-1/annotated_C/src/FindEventById.c"
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
# 2 "/home/xinra/crtos/keventdelete-trial-261103-1/annotated_C/src/FindEventById.c" 2
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
# 3 "/home/xinra/crtos/keventdelete-trial-261103-1/annotated_C/src/FindEventById.c" 2
/*@ Import Coq Require Import CRTOS_Verify.VC.FindEventById_lib */
/*@ Extern Coq
  (EventStable :: *) (EventAbs :: *)
 */
/*@ Extern Coq EventState := list EventAbs */
/*@ Extern Coq
  (os_event_stable : StableGlobalState -> EventStable)
  (os_events : VarGlobalState -> EventState)
  (event_manager_stable : EventStable -> StableIdmanager)
  (event_manager : EventState -> VarIdmanager)
  (find_event_manager_frame : StableGlobalState -> VarGlobalState -> Assertion)
  (event_lookup_result : Z -> addr -> VarGlobalState -> Prop)
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
*/;

/* TrustBase CONTAINER_OF model; pure address relation, no lifetime ownership. */
struct Event *CONTAINER_OF_EVENT_ID(struct IdNode *id_ptr)
/*@ With (event_ptr : addr)
    Require id_ptr == field_addr(event_ptr, struct Event, id) && emp
    Ensure __return == event_ptr && id_ptr == &(__return->id) && emp
 */;

struct Event *FindEventById(int32 id)
/*@ event_lookup_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require 0 <= id && id < 65536 &&
      safeExec(LastSeen(before), abs_find_event(id), X) &&
      OutsideCritical(sg, before)
    Ensure
      (exists after,
        __return == 0 &&
        safeExec(LastSeen(after), return(0), X) && OutsideCritical(sg, after))
      ||
      (exists after,
        __return != 0 && event_delete_guard(id, __return, false, after) &&
        safeExec(LastSeen(after), return(__return), X) && OutsideCritical(sg, after))
 */
{
    x_base lock = 0;
    struct IdNode *idnode = ((void *)0);
    struct Event *event = ((void *)0);

    if (id < 0)
        return ((void *)0);
    lock = CriticalAreaLock() /*@ where (ordinary) sg = sg, st1 = before */;
    /*@ Given st_lock */
    /*@ os_inv(sg, st_lock)
        which implies
        &k_event_id_manager != 0 &&
        store_idmanager(event_manager_stable(os_event_stable(sg)),
          event_manager(os_events(st_lock)), &k_event_id_manager) *
        find_event_manager_frame(sg, st_lock)
    */
    idnode = IdGetObj(&k_event_id_manager, id)
      /*@ where sm = event_manager_stable(os_event_stable(sg)),
                m = event_manager(os_events(st_lock)) */;
    if (idnode == ((void *)0)) {
        /*@ idmanager_query(event_manager(os_events(st_lock)), id) == false &&
            store_idmanager(event_manager_stable(os_event_stable(sg)),
              event_manager(os_events(st_lock)), &k_event_id_manager) *
            find_event_manager_frame(sg, st_lock)
            which implies event_lookup_result(id, 0, st_lock) && os_inv(sg, st_lock)
        */
        /*@ safeExec(LastSeen(before), abs_find_event(id), X) &&
            Crtos_RTrans(before, st_lock) && 0 <= id && id < 65536 &&
            event_lookup_result(id, 0, st_lock) && os_inv(sg, st_lock)
            which implies
            safeExec(LastSeen(st_lock), return(0), X) &&
            0 <= id && id < 65536 && Crtos_GTrans(st_lock, st_lock) && os_inv(sg, st_lock)
        */
        CriticalAreaUnLock(lock) /*@ where (stable) sg = sg, st1 = st_lock, st2 = st_lock */;
        return ((void *)0);
    }

    /*@ idnode != 0 &&
        store_idmanager_found(event_manager_stable(os_event_stable(sg)),
          event_manager(os_events(st_lock)), &k_event_id_manager, idnode, id) *
        find_event_manager_frame(sg, st_lock)
        which implies exists found,
          found != 0 && idnode == field_addr(found, struct Event, id) &&
          event_delete_guard(id, found, false, st_lock) &&
          event_lookup_result(id, found, st_lock) && os_inv(sg, st_lock)
    */
    /*@ Given found */
    event = CONTAINER_OF_EVENT_ID(idnode) /*@ where event_ptr = found */;
    /*@ safeExec(LastSeen(before), abs_find_event(id), X) &&
        Crtos_RTrans(before, st_lock) && 0 <= id && id < 65536 &&
        event_lookup_result(id, event, st_lock) && os_inv(sg, st_lock)
        which implies
        safeExec(LastSeen(st_lock), return(event), X) &&
        0 <= id && id < 65536 && Crtos_GTrans(st_lock, st_lock) && os_inv(sg, st_lock)
    */
    CriticalAreaUnLock(lock) /*@ where (stable) sg = sg, st1 = st_lock, st2 = st_lock */;
    return event;
}
