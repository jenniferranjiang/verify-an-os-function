# 0 "/home/xinra/crtos/keventdelete-trial-261103-1/annotated_C/src/KEventDelete.c"
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
# 1 "/home/xinra/crtos/keventdelete-trial-261103-1/annotated_C/src/KEventDelete.c"
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
# 2 "/home/xinra/crtos/keventdelete-trial-261103-1/annotated_C/src/KEventDelete.c" 2
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
# 3 "/home/xinra/crtos/keventdelete-trial-261103-1/annotated_C/src/KEventDelete.c" 2

/*@ Import Coq Require Import CRTOS_Verify.VC.KEventDelete_lib */
/*@ Extern Coq
  (kevent_delete_lookup_cont : Z -> (unit -> (VarGlobalState -> Prop) -> Prop) -> addr -> (VarGlobalState -> Prop) -> Prop)
 */

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
 */;

void _EventDelete(struct Event *event)
/*@ event_delete_at_oc
    With (sg : StableGlobalState) (before : VarGlobalState) (id : Z) X
    Require event_delete_guard(id, event, false, before) &&
      safeExec(LastSeen(before), abs_event_delete_at(id, event), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */;

void KEventDelete(int32 id)
/*@ event_delete_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require 0 <= id && id < 65536 &&
      safeExec(LastSeen(before), abs_event_delete(id), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */
{
    /* KDEBUG_NOT_IN_INTERRUPT removed under TrustBase. */
    /*@ safeExec(LastSeen(before), abs_event_delete(id), X) && OutsideCritical(sg, before)
        which implies safeExec(LastSeen(before), abs_find_event(id),
          kevent_delete_lookup_cont(id, X)) && OutsideCritical(sg, before)
     */
    struct Event *event = FindEventById(id)
      /*@ where (event_lookup_oc) sg = sg, before = before, X = kevent_delete_lookup_cont(id, X) */;
    /*@ Given looked_up from after */
    if (event == ((void *)0))
        return;
    /* done.EventDelete resolves to _EventDelete in the immutable initializer. */
    /*@ event != 0 &&
        safeExec(LastSeen(looked_up), return(event), kevent_delete_lookup_cont(id, X)) &&
        OutsideCritical(sg, looked_up)
        which implies safeExec(LastSeen(looked_up), abs_event_delete_at(id, event), X) &&
          OutsideCritical(sg, looked_up)
     */
    _EventDelete(event) /*@ where (event_delete_at_oc) sg = sg, before = looked_up, id = id, X = X */;
}
