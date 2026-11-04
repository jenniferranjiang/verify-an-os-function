# 0 "/home/xinra/crtos/kmutexdelete-trial-261103-1/annotated_C/src/_MutexDelete.c"
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
# 1 "/home/xinra/crtos/kmutexdelete-trial-261103-1/annotated_C/src/_MutexDelete.c"
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
# 2 "/home/xinra/crtos/kmutexdelete-trial-261103-1/annotated_C/src/_MutexDelete.c" 2
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
# 3 "/home/xinra/crtos/kmutexdelete-trial-261103-1/annotated_C/src/_MutexDelete.c" 2

/*@ Import Coq Require Import KMutexDeleteProof.VC.MutexDelete_lib */
/*@ Extern Coq
  (mutex_delete_after_resume : Z -> Z -> (unit -> (VarGlobalState -> Prop) -> Prop) -> unit -> (VarGlobalState -> Prop) -> Prop)
  (mutex_delete_id_restore : StableGlobalState -> VarGlobalState -> Z -> Z -> Assertion)
  (mutex_delete_manager_frame : StableGlobalState -> VarGlobalState -> Assertion)
  (mutex_create_frame : StableGlobalState -> VarGlobalState -> Assertion)
  (mutex_context : MutexStable -> Prop)
  (mutex_link_node : MutexAbs -> DL_Node MutexAbs)
  (mutex_addr : MutexAbs -> addr)
  (mutex_id : MutexAbs -> Z)
  (mutex_delete_unpublish : addr -> MutexState -> MutexState)
  (replace_mutexes : MutexState -> VarGlobalState -> VarGlobalState)
  (store_mutex : (addr -> addr -> Assertion) -> addr -> MutexAbs -> Assertion)
  (NoDup : {A} -> list A -> Prop)
 */

/* Source: kernel/thread/mutex.c:62-75. static is normalized to slice
 * external linkage. No lock is moved: ResumeAll returns outside critical,
 * then the original removal critical section begins. A1/A2 constrain only
 * the environment in the two gaps. NULL checking retains nontermination.
 */
/* A1 + A2: caller-scoped trusted environment contract. After ResumeAll,
 * the same allocation remains published and no new waiter joins before
 * this acquisition. No equality of unrelated state or scalar fields is
 * assumed. This contract cannot be exported as an unconditional lock API. */
x_base CriticalAreaLock(void)
/*@ mutex_drained
    With (sg : StableGlobalState) (before : VarGlobalState) (p id : Z)
    Require mutex_delete_drained(p, id, before) && OutsideCritical(sg, before)
    Ensure exists st_lock,
      Crtos_RTrans(before, st_lock) && mutex_delete_drained(p, id, st_lock) &&
      InsideCritical(sg, st_lock) * os_inv(sg, st_lock)
 */;

void CriticalAreaUnLock(x_base lock)
/*@ stable
    With (sg : StableGlobalState) (st1 st2 : VarGlobalState)
    Require Crtos_GTrans(st1, st2) &&
      InsideCritical(sg, st1) * os_inv(sg, st2)
    Ensure OutsideCritical(sg, st2)
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
 */;

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
*/
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
 */
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
 */
/*@ remove_self
    With (node : Z)
    Require
      linklist_node == node &&
      node != 0 &&
      store_node_self_linked(node)
    Ensure
      store_node_self_linked(node)
 */
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

/* TrustBase allocator boundary, specialized to the original Mutex base.
 * MutexRaw includes every field, both external links and two padding bytes;
 * the typed-byte conversion is an explicit design obligation. */
void x_free(void *ptr)
/*@ Require MutexRaw(ptr)
    Ensure emp
 */;

void _MutexDelete(struct Mutex *mutex)
/*@ assumed_environment
    With (sg : StableGlobalState) (before : VarGlobalState) (id : Z) X
    Require mutex_delete_live(mutex, id, before) &&
      safeExec(LastSeen(before), abs_mutex_delete_object(mutex, id), X) &&
      OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */
{
    x_base lock = 0;
    if (mutex == ((void *)0)) {
        /*@ Inv Assert mutex == mutex@pre && mutex == 0 &&
          mutex_delete_live(mutex, id, before) &&
          has_permission(&lock) * OutsideCritical(sg, before)
         */
        while (1) { }
    }
    /*@ safeExec(LastSeen(before), abs_mutex_delete_object(mutex@pre, id), X)
        which implies
        safeExec(LastSeen(before), abs_mutex_resume_all(mutex@pre, id),
          mutex_delete_after_resume(mutex@pre, id, X))
     */
    LinklistResumeAll(&mutex->pend_list)
      /*@ where (mutex_waiters_oc) sg = sg, before = before, p = mutex, id = id,
          X = mutex_delete_after_resume(mutex, id, X) */;
    /*@ Given drained from after */
    /*@ safeExec(LastSeen(drained), return(tt), mutex_delete_after_resume(mutex@pre, id, X))
        which implies safeExec(LastSeen(drained), abs_mutex_retire(mutex@pre, id), X)
     */
    lock = CriticalAreaLock()
      /*@ where (mutex_drained) sg = sg, before = drained, p = mutex, id = id */;
    /*@ Given st_lock */
    /*@ mutex_delete_drained(mutex@pre, id, st_lock) && os_inv(sg, st_lock)
        which implies exists (current : MutexAbs) (prefix suffix : list MutexAbs),
          os_mutexes(st_lock) == app(prefix, cons(current, suffix)) &&
          current.mutex_addr == mutex@pre && current.mutex_id == id &&
          current.mutex_pending_addrs == nil &&
          NoDup(map(mutex_addr, os_mutexes(st_lock))) &&
          NoDup(map(mutex_id, os_mutexes(st_lock))) &&
          idmanager_query(mutex_manager(os_mutexes(st_lock)), id) == true &&
          store(field_addr(field_addr(mutex@pre, struct Mutex, id), struct IdNode, id),
            unsigned short, id) * mutex_delete_id_restore(sg, st_lock, mutex@pre, id)
     */
    /*@ Given current prefix suffix */
    /* Equivalent slice normalization: one original ID read, same critical section. */
    uint16 delete_mutex_id = mutex->id.id;
    /*@ store(field_addr(field_addr(mutex@pre, struct Mutex, id), struct IdNode, id),
          unsigned short, id) * mutex_delete_id_restore(sg, st_lock, mutex@pre, id)
        which implies os_inv(sg, st_lock)
     */
    /*@ os_inv(sg, st_lock)
        which implies
        store_idmanager(mutex_manager_stable(os_mutex_stable(sg)),
          mutex_manager(os_mutexes(st_lock)), &k_mutex_id_manager) *
        mutex_delete_manager_frame(sg, st_lock)
     */
    IdRemoveObj(&k_mutex_id_manager, delete_mutex_id)
      /*@ where (low_level_spec) sm = mutex_manager_stable(os_mutex_stable(sg)),
          m = mutex_manager(os_mutexes(st_lock)) */;
    /*@ os_mutexes(st_lock) == app(prefix, cons(current, suffix)) &&
        current.mutex_addr == mutex@pre &&
        mutex_delete_manager_frame(sg, st_lock)
        which implies
        os_mutexes(st_lock) == app(prefix, cons(current, suffix)) &&
        current.mutex_addr == mutex@pre && mutex_context(os_mutex_stable(sg)) &&
        mutex_create_frame(sg, st_lock) *
        store_dll(store_mutex(pure_suspend_sched_link(st_lock.os_tasks.task_desc_map)),
          &k_mutex_list, app(map(mutex_link_node, prefix),
            cons(Build_DL_Node(current, &mutex@pre->link), map(mutex_link_node, suffix))))
     */
    DoubleLinkListRmNode(&(mutex->link))
      /*@ where (remove_member)
          storeA = store_mutex(pure_suspend_sched_link(st_lock.os_tasks.task_desc_map)),
          head = &k_mutex_list, a = current,
          prefix = map(mutex_link_node, prefix), suffix = map(mutex_link_node, suffix);
          A = MutexAbs */;
    /*@ Assert exists (after : VarGlobalState) (saved_lock : Z),
      lock == saved_lock && mutex == mutex@pre && mutex == current.mutex_addr &&
      delete_mutex_id == id &&
      after == replace_mutexes(mutex_delete_unpublish(mutex, os_mutexes(st_lock)), st_lock) &&
      safeExec(LastSeen(after), return(tt), X) && Crtos_GTrans(st_lock, after) &&
      InsideCritical(sg, st_lock) * os_inv(sg, after) * MutexRetired(current)
     */
    /*@ Given after saved_lock */
    CriticalAreaUnLock(lock)
      /*@ where (stable) sg = sg, st1 = st_lock, st2 = after */;
    /*@ MutexRetired(current) which implies MutexRaw(current.mutex_addr) */
    x_free(mutex);
}
