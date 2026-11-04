# 0 "/home/xinra/crtos/kmutexdelete-trial-261103-1/annotated_C/src/LinklistResumeAll.c"
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
# 1 "/home/xinra/crtos/kmutexdelete-trial-261103-1/annotated_C/src/LinklistResumeAll.c"
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
# 2 "/home/xinra/crtos/kmutexdelete-trial-261103-1/annotated_C/src/LinklistResumeAll.c" 2
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
# 3 "/home/xinra/crtos/kmutexdelete-trial-261103-1/annotated_C/src/LinklistResumeAll.c" 2

/*@ Import Coq Require Import KMutexDeleteProof.VC.MutexResumeAll_lib */
/*@ Extern Coq
  (mutex_resume_remaining_effect : addr -> list addr -> VarGlobalState -> list addr -> VarGlobalState -> Prop)
  (mutex_resume_all_steps : addr -> list addr -> VarGlobalState -> VarGlobalState -> Prop)
  (set_task_desc_exstatus : TaskDescriptorAbs -> Z -> TaskDescriptorAbs)
  (mutex_resume_next_restore : StableGlobalState -> VarGlobalState -> addr -> addr -> Assertion)
  (mutex_resume_exstatus_restore : StableGlobalState -> VarGlobalState -> Z -> Z -> Assertion)
  (mutex_resume_id_restore : StableGlobalState -> VarGlobalState -> Z -> Z -> Assertion)
 */

/* Source: kernel/thread/linklist.c:110-132. This is a NEW mutex/outside
 * contract, not derived from the root semaphore_waiters contract. Both
 * real lock/unlock calls are retained. KTaskWakeup is the existing inside
 * reused-spec boundary; its nested locks are covered by that adaptation.
 */
/* A1: caller-scoped trusted environment contract, NOT a consequence of
 * ordinary CriticalAreaLock. Only this experiment's approved delete chain
 * may select it. The same allocation stays published between its lookup
 * and this acquisition; other fields and OS modules may change. */
x_base CriticalAreaLock(void)
/*@ mutex_live
    With (sg : StableGlobalState) (before : VarGlobalState) (p id : Z)
    Require mutex_delete_live(p, id, before) && OutsideCritical(sg, before)
    Ensure exists st_lock,
      Crtos_RTrans(before, st_lock) && mutex_delete_live(p, id, st_lock) &&
      InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
 */;

void CriticalAreaUnLock(x_base lock)
/*@ stable
    With (sg : StableGlobalState) (st1 st2 : VarGlobalState)
    Require Crtos_GTrans(st1, st2) &&
      InsideCritical(sg, st1) * os_inv(sg, st2)
    Ensure OutsideCritical(sg, st2)
 */;

struct TaskDescriptor *CONTAINER_OF_TASK_SCHED(DoubleLinklistType *sched_link_ptr)
/*@ With task_ptr
    Require addr_aligned(task_ptr, ALIGN_SIZE) &&
      sched_link_ptr == sched_link_of(task_ptr) && emp
    Ensure __return == task_ptr && addr_aligned(__return, ALIGN_SIZE) &&
      sched_link_ptr == &(__return->task_dync_sched_member.sched_link)
 */;

x_err_t KTaskWakeup(int32 id)
/*@ wakeup_by_id_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require id < 65536 && os_inv(sg, before)
    Ensure exists (task : Z) (desc : TaskDescriptorAbs) (after : VarGlobalState),
      task != 0 && get_task_with_idnode_success(sg, before, id, task) &&
      before.os_tasks.task_desc_map(task) == Some(desc) &&
      ((desc.tdSchedMember.tsmStat != TSK_SUSPEND && __return == -1 && after == before)
       ||
       (desc.tdSchedMember.tsmStat == TSK_SUSPEND && __return == 0 &&
        ktask_wakeup_step(task, desc, before, after))) && os_inv(sg, after)
 */
/*@ detached_sched_null_delay <= wakeup_by_id_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require id < 65536 && ktask_wakeup_detached_null_condition(sg, before, id) &&
      os_inv(sg, before)
    Ensure exists (task : Z) (desc : TaskDescriptorAbs) (after : VarGlobalState),
      task != 0 && get_task_with_idnode_success(sg, before, id, task) &&
      before.os_tasks.task_desc_map(task) == Some(desc) && desc.tdDelay == 0 &&
      ((desc.tdSchedMember.tsmStat != TSK_SUSPEND && __return == -1 && after == before)
       ||
       (desc.tdSchedMember.tsmStat == TSK_SUSPEND && __return == 0 &&
          ktask_wakeup_detached_null_step(task, desc, before, after))) &&
      os_inv(sg, after)
 */
/*@ semaphore_pending_head_ic <= wakeup_by_id_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
      (sem task : Z) (rest : list(DL_Node Z))
    Require id < 65536 && get_task_with_idnode_success(sg, before, id, task) &&
      semaphore_pending_nodes(sem, before, cons(sched_link_node(task), rest)) &&
      os_inv(sg, before)
    Ensure exists (desc : TaskDescriptorAbs) (after : VarGlobalState),
      __return == 0 && task != 0 &&
      before.os_tasks.task_desc_map(task) == Some(desc) &&
      desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
      wakeup_semaphore_head(sem, task, desc, before, after) &&
      semaphore_pending_nodes(sem, after, rest) && os_inv(sg, after)
 */;

x_err_t LinklistResumeAll(DoubleLinklistType *list)
/*@ mutex_waiters_oc
    With (sg : StableGlobalState) (before : VarGlobalState) (p id : Z) X
    Require list == mutex_pending_head(p) &&
      mutex_delete_live(p, id, before) &&
      safeExec(LastSeen(before), abs_mutex_resume_all(p, id), X) &&
      OutsideCritical(sg, before)
    Ensure __return == KOK && exists after,
      mutex_delete_drained(p, id, after) &&
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */
{
    x_ubase lock = 0;
    struct TaskDescriptor *task = ((void *)0);
    DoubleLinklistType *node = ((void *)0);
    if (list == ((void *)0)) {
        /*@ Inv Assert list == list@pre && list == 0 &&
          list == mutex_pending_head(p) && mutex_delete_live(p, id, before) &&
          safeExec(LastSeen(before), abs_mutex_resume_all(p, id), X) &&
          has_permission(&task) * has_permission(&node) * has_permission(&lock) *
          OutsideCritical(sg, before)
         */
        while (1) { }
    }

    lock = CriticalAreaLock()
      /*@ where (mutex_live) sg = sg, before = before, p = p, id = id */;
    /*@ Given st_lock */
    /*@ mutex_delete_live(p, id, st_lock) && os_inv(sg, st_lock)
        which implies exists (original : MutexAbs),
        In(original, os_mutexes(st_lock)) && original.mutex_addr == p &&
        original.mutex_id == id && mutex_delete_live(p, id, st_lock) &&
        mutex_pending_nodes(p, st_lock, map(sched_link_node, original.mutex_pending_addrs)) &&
        os_inv(sg, st_lock)
     */
    /*@ Given original */
    /*@ Inv Assert exists (current : VarGlobalState) (remaining : list addr)
                         (saved_lock : Z),
        list == list@pre && list != 0 && list == mutex_pending_head(p) &&
        lock == saved_lock &&
        In(original, os_mutexes(st_lock)) && original.mutex_addr == p &&
        original.mutex_id == id && Crtos_RTrans(before, st_lock) &&
        mutex_delete_live(p, id, st_lock) && mutex_delete_live(p, id, current) &&
        mutex_pending_nodes(p, current, map(sched_link_node, remaining)) &&
        mutex_resume_remaining_effect(p, original.mutex_pending_addrs, st_lock, remaining, current) &&
        safeExec(LastSeen(before), abs_mutex_resume_all(p, id), X) &&
        has_permission(&task) * has_permission(&node) *
        InsideCritical(sg, st_lock) * os_inv(sg, current)
     */
    while (1) {
        /*@ Given current remaining saved_lock */
        /*@ list@pre == mutex_pending_head(p) && list@pre != 0 &&
            mutex_pending_nodes(p, current, map(sched_link_node, remaining)) && os_inv(sg, current)
            which implies exists next,
            list@pre == mutex_pending_head(p) && list@pre != 0 &&
            mutex_pending_nodes(p, current, map(sched_link_node, remaining)) &&
            ((remaining == nil && next == list@pre) ||
             (exists first tail, remaining == cons(first, tail) &&
               next == sched_link_of(first) && next != list@pre)) &&
            store(field_addr(list@pre, struct SysDoubleLinklistNode, node_next), struct SysDoubleLinklistNode *, next) *
            mutex_resume_next_restore(sg, current, list@pre, next)
         */
        /*@ Given next */
        node = list->node_next;
        /*@ store(field_addr(list@pre, struct SysDoubleLinklistNode, node_next), struct SysDoubleLinklistNode *, next) *
            mutex_resume_next_restore(sg, current, list@pre, next)
            which implies os_inv(sg, current)
         */
        if (node != list) {
            /*@ Given target from first */
            /*@ Given rest from tail */
            /*@ remaining == cons(target, rest) && next == sched_link_of(target) &&
                mutex_pending_nodes(p, current, map(sched_link_node, remaining)) && os_inv(sg, current)
                which implies exists desc,
                remaining == cons(target, rest) && next == sched_link_of(target) &&
                addr_aligned(target, ALIGN_SIZE) &&
                current.os_tasks.task_desc_map(target) == Some(desc) &&
                desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
                mutex_pending_nodes(p, current, cons(sched_link_node(target), map(sched_link_node, rest))) &&
                os_inv(sg, current)
             */
            /*@ Given desc */
            task = CONTAINER_OF_TASK_SCHED(node) /*@ where task_ptr = target */;
            /*@ current.os_tasks.task_desc_map(target) == Some(desc) && os_inv(sg, current)
                which implies exists marked,
                current.os_tasks.task_desc_map(target) == Some(desc) &&
                marked == replace_task_desc_map(
                  update_task_desc_map(target, set_task_desc_exstatus(desc, -1), current.os_tasks.task_desc_map), current) &&
                store(field_addr(target, struct TaskDescriptor, exstatus), int, desc.tdExstatus) *
                mutex_resume_exstatus_restore(sg, marked, target, -1)
             */
            /*@ Given marked */
            task->exstatus = -1;
            /*@ store(field_addr(target, struct TaskDescriptor, exstatus), int, -1) *
                mutex_resume_exstatus_restore(sg, marked, target, -1)
                which implies os_inv(sg, marked)
             */
            /*@ remaining == cons(target, rest) &&
                mutex_pending_nodes(p, current, cons(sched_link_node(target), map(sched_link_node, rest))) &&
                marked == replace_task_desc_map(
                  update_task_desc_map(target, set_task_desc_exstatus(desc, -1), current.os_tasks.task_desc_map), current) &&
                os_inv(sg, marked)
                which implies exists task_id,
                remaining == cons(target, rest) &&
                mutex_pending_nodes(p, current, cons(sched_link_node(target), map(sched_link_node, rest))) &&
                marked == replace_task_desc_map(
                  update_task_desc_map(target, set_task_desc_exstatus(desc, -1), current.os_tasks.task_desc_map), current) &&
                0 <= task_id && task_id < 65536 &&
                get_task_with_idnode_success(sg, marked, task_id, target) &&
                mutex_pending_nodes(p, marked, cons(sched_link_node(target), map(sched_link_node, rest))) &&
                store(field_addr(field_addr(target, struct TaskDescriptor, id), struct IdNode, id), unsigned short, task_id) *
                mutex_resume_id_restore(sg, marked, target, task_id)
             */
            /*@ Given task_id */
            /* Equivalent normalization: read the original uint16 argument once;
             * only ghost annotations separate this read from its call. */
            int32 resume_task_id = task->id.id;
            /*@ store(field_addr(field_addr(target, struct TaskDescriptor, id), struct IdNode, id), unsigned short, task_id) *
                mutex_resume_id_restore(sg, marked, target, task_id)
                which implies os_inv(sg, marked)
             */
            KTaskWakeup(resume_task_id) /*@ where (wakeup_by_id_ic) sg = sg, before = marked */;
        } else {
            break;
        }
    }
    /*@ Given current remaining saved_lock */
    /*@ mutex_delete_live(p, id, current) &&
        mutex_pending_nodes(p, current, map(sched_link_node, remaining)) && remaining == nil &&
        In(original, os_mutexes(st_lock)) && original.mutex_addr == p && original.mutex_id == id &&
        Crtos_RTrans(before, st_lock) && mutex_delete_live(p, id, st_lock) &&
        mutex_resume_remaining_effect(p, original.mutex_pending_addrs, st_lock, remaining, current) &&
        safeExec(LastSeen(before), abs_mutex_resume_all(p, id), X) && os_inv(sg, current)
        which implies mutex_delete_drained(p, id, current) && Crtos_GTrans(st_lock, current) &&
        safeExec(LastSeen(current), return(tt), X) && os_inv(sg, current)
     */
    CriticalAreaUnLock(lock) /*@ where (stable) sg = sg, st1 = st_lock, st2 = current */;
    return 0;
}
