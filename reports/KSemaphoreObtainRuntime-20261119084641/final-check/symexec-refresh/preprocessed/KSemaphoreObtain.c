# 0 "/home/xinra/crtos-verify/annotated_C/src/kernel/semaphore/KSemaphoreObtain.c"
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
# 1 "/home/xinra/crtos-verify/annotated_C/src/kernel/semaphore/KSemaphoreObtain.c"
# 1 "annotated_C/src/headers/m_semaphore.h" 1

#define CRTOS_M_SEMAPHORE_H 

/*
 * Shared Semaphore ABI for the current 32-bit, non-SMP verification model.
 * Function contracts and scenario-specific Rocq vocabulary remain in the
 * annotated C files or logic adapters; this header is stable across APIs.
 */
typedef signed int int32;
typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;
typedef signed long x_base;
typedef unsigned long x_ubase;
typedef x_base x_err_t;
typedef unsigned int x_ticks_t;
typedef x_ubase x_size_t;
typedef unsigned int size_t;
typedef unsigned char BOOL;

#define NONE ((void *)0)
#define EOK 0
#define ERROR 1
#define ENOMEMORY 5
#define RET_TRUE 1
#define UINT_MAX 4294967295U
#define ALIGN_SIZE 4
#define ID_NUM_MAX 128
#define ID_HTABLE_SIZE 16
#define KTASK_READY 1
#define KTASK_SUSPEND 2
#define KTASK_STAT_MASK 7
#define KTASK_MAX_ADVANCE_PROCESS_TIME 1
#define TASK_DELAY_INACTIVE 0
#define TASK_DELAY_ACTIVE 1
#define KERNEL_SEMAPHORE 

struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
};
typedef struct SysDoubleLinklistNode DoubleLinklistType;

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

struct TaskDescriptor;
struct Delay {
    struct TaskDescriptor *task;
    x_ticks_t ticks;
    uint8 status;
    DoubleLinklistType link;
};
typedef struct Delay *DelayType;

struct TaskBaseInfo {
    char name[32];
    void *func_entry;
    void *func_param;
    uint8 origin_prio;
    uint32 stack_depth;
    void *stack_start;
};
typedef struct TaskBaseInfo TaskBaseInfoType;

struct TaskDyncSchedMember {
    uint8 stat;
    uint8 advance_cnt;
    uint8 cur_prio;
    x_ubase origin_timeslice;
    x_ubase rest_timeslice;
    DoubleLinklistType sched_link;
    uint32 bitmap_column;
    DelayType delay;
};
typedef struct TaskDyncSchedMember TaskDyncSchedMembeType;

struct KTaskDone;
struct TaskDescriptor {
    void *stack_point;
    TaskDyncSchedMembeType task_dync_sched_member;
    TaskBaseInfoType task_base_info;
    uint32 event_id_trigger;
    uint32 event_mode;
    x_err_t exstatus;
    DoubleLinklistType link;
    struct IdNode id;
    struct KTaskDone *Done;
};
typedef struct TaskDescriptor *KTaskDescriptorType;

struct OsAssignReadyVector {
    DoubleLinklistType priority_ready_vector[32];
    uint32 priority_ready_group;
    x_ubase highest_prio;
};

struct PriorityReadyVectorDone;
struct Assign {
    struct OsAssignReadyVector os_assign_ready_vector;
    struct TaskDescriptor *os_running_task;
    struct PriorityReadyVectorDone *ready_vector_done;
    uint8 current_priority;
};

extern uint16 KTaskOsAssignLockNest;
extern struct IdManager k_sem_id_manager;
extern struct IdManager k_task_id_manager;
extern DoubleLinklistType k_sem_list;
extern DoubleLinklistType xiaoshan_delay_head;
extern struct Assign Assign;
# 2 "/home/xinra/crtos-verify/annotated_C/src/kernel/semaphore/KSemaphoreObtain.c" 2
# 1 "annotated_C/src/headers/semaphore_runtime_logic.h" 1

#define CRTOS_SEMAPHORE_RUNTIME_LOGIC_H 
# 1 "annotated_C/src/headers/semaphore_delete_logic.h" 1

#define CRTOS_SEMAPHORE_DELETE_LOGIC_H 
/*@ Import Coq Require Import CRTOS_Verify.lib.id.IdModuleSpec */
/* Formal types and semantic vocabulary only. Contracts are caller-local. */
/* A C ALIGN_SIZE macro supplies numeric uses directly; do not redeclare its
 * expanded value as a formal identifier. Keep the logical name for inputs
 * that do not define the C macro. */



/*@ Import Coq Require Import CRTOS_Verify.lib.semaphore.KSemaphoreDelete CRTOS_Verify.lib.delay.KTaskUnSetDelay */
/*@ Import Coq Require Import CRTOS_Verify.lib.list.DoubleLinkListSpec CRTOS_Verify.lib.task.TaskStatusMemory CRTOS_Verify.lib.task.KTaskParseInfo */
/*@ Import Coq Import IDNode DLL */
/*@ Import Coq From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib */
/*@ Import Coq Import Monad MonadNotation */
/*@ Import Coq Local Open Scope monad */
/*@ Extern Coq addr := Z */
/*@ Extern Coq
  (DL_Node :: * => *) (option :: * => *) (unit :: *)
  (TaskStatus :: *) (StableGlobalState :: *) (VarGlobalState :: *)
  (TaskDescriptorAbs :: *) (TaskSchedMemberAbs :: *) (TaskDelayAbs :: *)
  (OsAssignReadyVectorAbs :: *) (vSchedView :: *) (vDelayView :: *)
  (StableIdmanager :: *) (VarIdmanager :: *) (IdNodeAbs :: *)
  (SemaphoreStable :: *) (SemaphoreAbs :: *)
  (program :: * => * => *)
 */
/*@ Extern Coq SemaphoreState := list SemaphoreAbs */
/*@ Extern Coq Record StableIdmanager { idmax: Z; hoffset: Z; id_map: Z; htable: Z; } */
/*@ Extern Coq Record TaskSchedMemberAbs {
  tsmStat: TaskStatus; tsmAdvanceCnt: Z; tsmCurPrio: Z;
  tsmOriginTimeslice: Z; tsmRestTimeslice: Z; tsmBitmapColumn: Z;
} */
/*@ Extern Coq Record TaskDescriptorAbs {
  tdSchedMember: TaskSchedMemberAbs; tdDelay: Z; tdExstatus: Z;
} */
/*@ Extern Coq Record TaskDelayAbs { tdTaskPtr: Z; tdTicks: Z; tdStatus: Z; } */
/*@ Extern Coq Record OsAssignReadyVectorAbs {
  orvBuckets: list(list(DL_Node Z)); orvReadyGroup: Z; orvHighestPrio: Z;
} */
/*@ Extern Coq (TaskStable :: *) (TaskState :: *) (VarAssignAbs :: *) (DelayState :: *) */
/*@ Extern Coq Record SemaphoreAbs {
  semaphore_addr: addr; semaphore_id: Z; semaphore_value: Z; semaphore_pending_addrs: list addr;
} */
/*@ Extern Coq Record TaskStable {
  task_stable_ids: StableIdmanager; task_idmanager_ptr: Z;
} */
/*@ Extern Coq Record TaskState {
  task_desc_map: Z -> option TaskDescriptorAbs; task_idmanager_abs: VarIdmanager;
} */
/*@ Extern Coq Record VarAssignAbs { assignReadyVector: OsAssignReadyVectorAbs; } */
/*@ Extern Coq Record StableGlobalState { os_task_stable: TaskStable; delay_head_ptr: Z; } */
/*@ Extern Coq Record DelayState {
  delay_inactive_map: Z -> option TaskDelayAbs;
  delay_active_nodes: list(DL_Node TaskDelayAbs);
} */
/*@ Extern Coq Record VarGlobalState {
  os_tasks: TaskState; os_assign: VarAssignAbs; os_delays: DelayState; os_semaphores: SemaphoreState;
} */
/*@ Extern Coq
  (Some : {A} -> A -> option A) (None : {A} -> option A)
  (tt : unit) (true : bool) (false : bool)
  (Build_IdNodeAbs : Z -> addr -> IdNodeAbs)
  (Build_DL_Node : {A} -> A -> addr -> DL_Node A)
  (store_idmanager : StableIdmanager -> VarIdmanager -> addr -> Assertion)
  (store_idmanager_found : StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion)
  (store_idmanager_remove_ready : StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion)
  (store_idmanager_removeobj_post : StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion)
  (store_idnode : addr -> IdNodeAbs -> Assertion)
  (idmanager_query : VarIdmanager -> Z -> bool)
  (idmanager_remove : StableIdmanager -> VarIdmanager -> Z -> VarIdmanager)
  (idmanager_add : VarIdmanager -> Z -> VarIdmanager)
  (idmanager_link : StableIdmanager -> VarIdmanager -> Z -> addr -> VarIdmanager)
  (store_dll : {A} -> (addr -> A -> Assertion) -> addr -> list(DL_Node A) -> Assertion)
  (map : {A} {B} -> (A -> B) -> list A -> list B)
  (pure_suspend_sched_link : (addr -> option TaskDescriptorAbs) -> addr -> addr -> Assertion)
  (semaphore_wait_node : addr -> DL_Node addr)
  (occupy_dll_node : addr -> Assertion)
  (store_node_self_linked : addr -> Assertion)
  (store_task_sched_member : addr -> TaskSchedMemberAbs -> Assertion)
  (store_priority_ready_bucket : addr -> list(DL_Node addr) -> Assertion)
  (store_ready_dll_tail_view : addr -> list(DL_Node addr) -> addr -> Assertion)
  (dll_insert_anchor : {A} -> addr -> list(DL_Node A) -> addr -> Prop)
  (dll_insert_after_dispatch : {A} -> addr -> list(DL_Node A) -> addr -> DL_Node A -> list(DL_Node A))
  (dll_insert_before_dispatch : {A} -> addr -> list(DL_Node A) -> addr -> DL_Node A -> list(DL_Node A))
  (addr_aligned : addr -> Z -> Prop)
  (KOK : Z) (KERROR : Z) (PRIORITY_MAX : Z)
  (TSK_SUSPEND : TaskStatus) (TSK_READY : TaskStatus)
  (decode_task_status : Z -> TaskStatus)
  (store_task_status : addr -> TaskStatus -> Assertion)
  (os_global_context : StableGlobalState -> Prop)
  (task_world_wf : VarGlobalState -> Prop)
  (task_fields : StableGlobalState -> VarGlobalState -> Assertion)
  (task_wakeup_inv : StableGlobalState -> VarGlobalState -> Assertion)
  (tasks_ready_with_exstatus : VarGlobalState -> list addr -> Z -> Prop)
  (delay_inv : StableGlobalState -> VarGlobalState -> Assertion)
  (assign_ready_pending : StableGlobalState -> VarGlobalState -> Assertion)
  (sched_link_of : addr -> addr)
  (ready_task_node : addr -> DL_Node addr)
  (task_addr_aligned : addr -> OsAssignReadyVectorAbs -> Prop)
  (assign_ready_vector_addr : StableGlobalState -> addr)
  (get_task_with_idnode_success : StableGlobalState -> VarGlobalState -> Z -> addr -> Prop)
  (set_task_desc_ready : TaskDescriptorAbs -> TaskDescriptorAbs)
  (update_task_desc_map : addr -> TaskDescriptorAbs -> (addr -> option TaskDescriptorAbs) -> addr -> option TaskDescriptorAbs)
  (replace_task_desc_map : (addr -> option TaskDescriptorAbs) -> VarGlobalState -> VarGlobalState)
  (replace_global_ready_vector : OsAssignReadyVectorAbs -> VarGlobalState -> VarGlobalState)
  (os_assign_ready_vector_replace_bucket : OsAssignReadyVectorAbs -> Z -> list(DL_Node addr) -> OsAssignReadyVectorAbs)
  (rrr_bucket_insert : (addr -> option TaskDescriptorAbs) -> TaskSchedMemberAbs -> DL_Node addr -> list(DL_Node addr) -> list(DL_Node addr) -> Prop)
  (assign_policy_insert_ready_vector : OsAssignReadyVectorAbs -> TaskSchedMemberAbs -> list(DL_Node addr) -> OsAssignReadyVectorAbs)
  (assign_insert_step_ic : (addr -> option TaskDescriptorAbs) -> addr -> TaskDescriptorAbs -> OsAssignReadyVectorAbs -> OsAssignReadyVectorAbs -> Prop)
  (ktask_unset_delay_step : addr -> VarGlobalState -> VarGlobalState -> Prop)
  (unset_linked_delay_step : addr -> TaskDelayAbs -> VarGlobalState -> VarGlobalState -> Prop)
  (In : {A} -> A -> list A -> Prop)
  (vDelayNull : vDelayView)
  (vDelayInactive : addr -> TaskDelayAbs -> vDelayView)
  (vDelayActive : addr -> TaskDelayAbs -> list(DL_Node TaskDelayAbs) -> list(DL_Node TaskDelayAbs) -> vDelayView)
  (store_ktask_unset_delay_pre : addr -> vDelayView -> Assertion)
  (store_ktask_unset_delay_post : addr -> vDelayView -> Assertion)
  (vSchedLinked : addr -> list(DL_Node addr) -> list(DL_Node addr) -> vSchedView)
  (vSchedDetached : vSchedView)
  (store_ktask_wakeup_sched_pre : (addr -> option TaskDescriptorAbs) -> addr -> vSchedView -> Assertion)
  (store_ktask_wakeup_source_post : (addr -> option TaskDescriptorAbs) -> vSchedView -> Assertion)
  (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
  (safeExec : {Sigma} {A} -> (Sigma -> Prop) -> program Sigma A -> (A -> Sigma -> Prop) -> Prop)
  (return : {Sigma} {A} -> A -> program Sigma A)
  (abs_semaphore_delete : StableGlobalState -> Z -> program (VarGlobalState -> Prop) unit)
  (abs_ktask_assign : program (VarGlobalState -> Prop) unit)
  (OutsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
  (InsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
  (Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop)
  (Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop)
  (os_inv : StableGlobalState -> VarGlobalState -> Assertion)
  (SemaphoreRaw : addr -> Assertion)
  (idmanager_contains : StableIdmanager -> VarIdmanager -> Z -> Z -> Prop)
  (sched_link_node : addr -> DL_Node addr)
  (ktask_wakeup_step : addr -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop)
  (ktask_wakeup_detached_null_condition : StableGlobalState -> VarGlobalState -> Z -> Prop)
  (ktask_wakeup_detached_null_step : addr -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop)
 (semaphore_pending_nodes : Z -> VarGlobalState -> list(DL_Node Z) -> Prop)
 (wakeup_semaphore_head : Z -> Z -> TaskDescriptorAbs -> VarGlobalState -> VarGlobalState -> Prop)
  (semaphore_pending_head : addr -> addr)
  (semaphore_resume_all_effect : addr -> list addr -> VarGlobalState -> VarGlobalState -> Prop)
 */
/*@ Printing Coq Name program := MonadErr.M */
/*@ Printing Strategy Name program := MonadErr.M */
/*@ Printing Coq Name safeExec := monadesafe_lib.safeExec */
/*@ Printing Coq Name return := MonadErr.ret */
# 4 "annotated_C/src/headers/semaphore_runtime_logic.h" 2
/*@ Import Coq Require Import CRTOS_Verify.lib.semaphore.KSemaphoreAbandon */
/*@ Extern Coq
(abs_semaphore_abandon : StableGlobalState -> Z -> program (VarGlobalState -> Prop) Z)
(semaphore_resume_head_effect : Z -> VarGlobalState -> VarGlobalState -> Prop)
*/
/*@ Import Coq Require Import CRTOS_Verify.lib.semaphore.KSemaphoreObtain */
/*@ Extern Coq
(abs_semaphore_obtain : StableGlobalState -> Z -> Z -> program (VarGlobalState -> Prop) Z)
(tick_from_time_ms : Z -> Z)
(linklist_suspend_prio : Z -> Z -> VarGlobalState -> VarGlobalState -> Prop)
(linklist_suspend_admissible : Z -> Z -> VarGlobalState -> Prop)
(ktask_suspend_step : Z -> VarGlobalState -> Z -> VarGlobalState -> Prop)
(linklist_suspend_step : Z -> Z -> Z -> VarGlobalState -> Z -> VarGlobalState -> Prop)
(delay_list_window : Z -> list(DL_Node TaskDelayAbs) -> Prop)
(KTICK_HALF_RANGE : Z)
(tick_inv : StableGlobalState -> VarGlobalState -> Assertion)
(ktask_set_delay_step : Z -> TaskDescriptorAbs -> Z -> Z -> VarGlobalState -> Z -> VarGlobalState -> Prop)
*/
# 3 "/home/xinra/crtos-verify/annotated_C/src/kernel/semaphore/KSemaphoreObtain.c" 2
/* done.SemaphoreObtain = _SemaphoreObtain; KDEBUG_NOT_IN_INTERRUPT removed per TrustBase. */
int32 _SemaphoreObtain(int32 id, int32 msec)
/*@ semaphore_obtain_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_semaphore_obtain(sg, id, msec), X) && OutsideCritical(sg, before)
    Ensure exists after, safeExec(LastSeen(after), return(__return), X) && OutsideCritical(sg, after)
 */;
int32 KSemaphoreObtain(int32 id, int32 msec)
/*@ semaphore_obtain_oc
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_semaphore_obtain(sg, id, msec), X) && OutsideCritical(sg, before)
    Ensure exists after, safeExec(LastSeen(after), return(__return), X) && OutsideCritical(sg, after)
 */
{ return _SemaphoreObtain(id, msec); }
