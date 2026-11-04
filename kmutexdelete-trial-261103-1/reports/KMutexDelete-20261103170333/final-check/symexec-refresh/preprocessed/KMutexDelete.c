# 0 "/home/xinra/crtos/kmutexdelete-trial-261103-1/annotated_C/src/KMutexDelete.c"
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
# 1 "/home/xinra/crtos/kmutexdelete-trial-261103-1/annotated_C/src/KMutexDelete.c"
# 1 "/home/xinra/crtos/kmutexdelete-trial-261103-1/annotated_C/src/../include/slice_types.h" 1

#define KMUTEXDELETE_SLICE_TYPES_H 
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
struct Semaphore { struct IdNode id; uint16 value; DoubleLinklistType pend_list; DoubleLinklistType link; };
struct TaskDescriptor;
struct Mutex {
    struct IdNode id; uint16 val; uint8 recursive_cnt; uint8 origin_prio;
    struct TaskDescriptor *holder; DoubleLinklistType pend_list; DoubleLinklistType link;
};
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
struct OsAssignReadyVector {
    DoubleLinklistType priority_ready_vector[32];
    uint32 priority_ready_group; x_ubase highest_prio;
};
struct PriorityReadyVectorDone;
struct Assign {
    struct OsAssignReadyVector os_assign_ready_vector;
    struct TaskDescriptor *os_running_task;
    struct PriorityReadyVectorDone *ready_vector_done;
    uint8 current_priority;
};
extern struct IdManager k_mutex_id_manager;
extern DoubleLinklistType k_mutex_list;
extern struct IdManager k_sem_id_manager;
extern struct IdManager k_task_id_manager;
extern DoubleLinklistType k_sem_list;
extern DoubleLinklistType xiaoshan_delay_head;
extern struct Assign Assign;
# 2 "/home/xinra/crtos/kmutexdelete-trial-261103-1/annotated_C/src/KMutexDelete.c" 2
# 1 "/home/xinra/crtos/kmutexdelete-trial-261103-1/annotated_C/src/../include/logic.h" 1

#define KMUTEXDELETE_LOGIC_H 
/*@ Import Coq Require Import CRTOS_Verify.lib.IdModuleSpec */
/* Formal types and semantic vocabulary only. Contracts are caller-local. */
/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskWakeup */
/*@ Import Coq Require Import CRTOS_Verify.lib.DoubleLinkListSpec CRTOS_Verify.lib.TaskStatusMemory CRTOS_Verify.lib.KTaskParseInfo */
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
  (ALIGN_SIZE : Z) (addr_aligned : addr -> Z -> Prop)
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
 */
/*@ Printing Coq Name program := MonadErr.M */
/*@ Printing Strategy Name program := MonadErr.M */
/*@ Printing Coq Name safeExec := monadesafe_lib.safeExec */
/*@ Printing Coq Name return := MonadErr.ret */
/*@ Import Coq Require Import CRTOS_Verify.lib.KMutexDelete */
/*@ Extern Coq (MutexAbs :: *) (MutexStable :: *) */
/*@ Extern Coq MutexState := list MutexAbs */
/*@ Extern Coq Record MutexAbs {
  mutex_addr: addr; mutex_id: Z; mutex_value: Z;
  mutex_recursive_count: Z; mutex_original_priority: Z; mutex_holder: addr;
  mutex_pending_addrs: list addr;
} */
/*@ Extern Coq
  (os_mutex_stable : StableGlobalState -> MutexStable)
  (os_mutexes : VarGlobalState -> MutexState)
  (mutex_manager_stable : MutexStable -> StableIdmanager)
  (mutex_manager : MutexState -> VarIdmanager)
  (MutexRaw : addr -> Assertion)
  (MutexRetired : MutexAbs -> Assertion)
  (mutex_pending_head : addr -> addr)
  (mutex_delete_live : addr -> Z -> VarGlobalState -> Prop)
  (mutex_delete_drained : addr -> Z -> VarGlobalState -> Prop)
  (mutex_pending_nodes : addr -> VarGlobalState -> list(DL_Node addr) -> Prop)
  (mutex_resume_all_effect : addr -> list addr -> VarGlobalState -> VarGlobalState -> Prop)
  (abs_mutex_resume_all : addr -> Z -> program (VarGlobalState -> Prop) unit)
  (abs_mutex_retire : addr -> Z -> program (VarGlobalState -> Prop) unit)
  (abs_mutex_delete_object : addr -> Z -> program (VarGlobalState -> Prop) unit)
  (abs_mutex_delete : Z -> program (VarGlobalState -> Prop) unit)
 */
# 3 "/home/xinra/crtos/kmutexdelete-trial-261103-1/annotated_C/src/KMutexDelete.c" 2
/*@ Import Coq Require Import KMutexDeleteProof.VC.KMutexDelete_lib */
/*@ Extern Coq
  (mutex_lookup_frame : StableGlobalState -> VarGlobalState -> Assertion)
  (unsigned_last_nbits : Z -> Z -> Z)
*/

/* Source: kernel/thread/mutex.c:235-257. Original lock boundaries kept.
 * Assumptions A1/A2 are approved for this call chain; see source-review.md.
 * KDEBUG_NOT_IN_INTERRUPT is removed under TrustBase; fixed done dispatch
 * resolves to _MutexDelete. Nonnegative int32 IDs still convert to uint16.
 */
x_base CriticalAreaLock(void)
/*@ ordinary
    With (sg : StableGlobalState) (st1 : VarGlobalState)
    Require OutsideCritical(sg, st1)
    Ensure exists st_lock,
      Crtos_RTrans(st1, st_lock) &&
      InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
 */;

void CriticalAreaUnLock(x_base lock)
/*@ stable
    With (sg : StableGlobalState) (st1 st2 : VarGlobalState)
    Require Crtos_GTrans(st1, st2) &&
      InsideCritical(sg, st1) * os_inv(sg, st2)
    Ensure OutsideCritical(sg, st2)
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
*/;

struct Mutex *CONTAINER_OF_MUTEX_ID(struct IdNode *id_ptr)
/*@ With (mutex_ptr : addr)
    Require id_ptr == field_addr(mutex_ptr, struct Mutex, id) && emp
    Ensure __return == mutex_ptr && id_ptr == &(__return->id) && emp
 */;

void _MutexDelete(struct Mutex *mutex)
/*@ assumed_environment
    With (sg : StableGlobalState) (before : VarGlobalState) (id : Z) X
    Require mutex_delete_live(mutex, id, before) &&
      safeExec(LastSeen(before), abs_mutex_delete_object(mutex, id), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */;

void KMutexDelete(int32 id)
/*@ assumed_environment
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_mutex_delete(id), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */
{
    /*@ -2147483648 <= id && id <= 2147483647 by local */
    x_base lock = 0;
    struct Mutex *mutex = ((void *)0);
    struct IdNode *idnode = ((void *)0);

    if (id < 0)
        return;

    lock = CriticalAreaLock() /*@ where (ordinary) sg = sg, st1 = before */;
    /*@ Given st_lock */
    /*@ os_inv(sg, st_lock)
        which implies
        store_idmanager(mutex_manager_stable(os_mutex_stable(sg)),
          mutex_manager(os_mutexes(st_lock)), &k_mutex_id_manager) *
        mutex_lookup_frame(sg, st_lock)
    */
    idnode = IdGetObj(&k_mutex_id_manager, id)
      /*@ where sm = mutex_manager_stable(os_mutex_stable(sg)),
          m = mutex_manager(os_mutexes(st_lock)) */;
    if (idnode == ((void *)0)) {
        /*@ store_idmanager(mutex_manager_stable(os_mutex_stable(sg)),
              mutex_manager(os_mutexes(st_lock)), &k_mutex_id_manager) *
            mutex_lookup_frame(sg, st_lock)
            which implies os_inv(sg, st_lock)
        */
        CriticalAreaUnLock(lock)
          /*@ where (stable) sg = sg, st1 = st_lock, st2 = st_lock */;
        return;
    }

    /*@ store_idmanager_found(mutex_manager_stable(os_mutex_stable(sg)),
          mutex_manager(os_mutexes(st_lock)), &k_mutex_id_manager,
          idnode, unsigned_last_nbits(id, 16)) * mutex_lookup_frame(sg, st_lock)
        which implies exists (original : MutexAbs),
          In(original, os_mutexes(st_lock)) &&
          original.mutex_id == unsigned_last_nbits(id, 16) &&
          idnode == field_addr(original.mutex_addr, struct Mutex, id) &&
          mutex_delete_live(original.mutex_addr, original.mutex_id, st_lock) &&
          os_inv(sg, st_lock)
    */
    /*@ Given original */
    mutex = CONTAINER_OF_MUTEX_ID(idnode)
      /*@ where mutex_ptr = original.mutex_addr */;
    CriticalAreaUnLock(lock)
      /*@ where (stable) sg = sg, st1 = st_lock, st2 = st_lock */;
    _MutexDelete(mutex)
      /*@ where (assumed_environment) sg = sg, before = st_lock,
          id = original.mutex_id, X = X */;
}
