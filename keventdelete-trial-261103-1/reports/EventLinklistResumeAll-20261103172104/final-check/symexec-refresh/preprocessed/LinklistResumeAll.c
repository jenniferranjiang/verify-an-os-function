# 0 "/home/xinra/crtos/keventdelete-trial-261103-1/annotated_C/src/LinklistResumeAll.c"
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
# 1 "/home/xinra/crtos/keventdelete-trial-261103-1/annotated_C/src/LinklistResumeAll.c"
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
# 2 "/home/xinra/crtos/keventdelete-trial-261103-1/annotated_C/src/LinklistResumeAll.c" 2
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
# 3 "/home/xinra/crtos/keventdelete-trial-261103-1/annotated_C/src/LinklistResumeAll.c" 2

/*@ Import Coq Require Import CRTOS_Verify.VC.EventLinklistResumeAll_lib */
/*@ Extern Coq
  (event_pending_at : Z -> addr -> list addr -> VarGlobalState -> Prop)
  (event_resume_all_effect : addr -> list addr -> VarGlobalState -> VarGlobalState -> Prop)
  (event_resume_remaining_effect : addr -> list addr -> VarGlobalState -> list addr -> VarGlobalState -> Prop)
  (event_resume_next_restore : StableGlobalState -> VarGlobalState -> addr -> addr -> Assertion)
  (event_resume_exstatus_restore : StableGlobalState -> VarGlobalState -> Z -> Z -> Assertion)
  (event_resume_id_restore : StableGlobalState -> VarGlobalState -> Z -> Z -> Assertion)
  (set_task_desc_exstatus : TaskDescriptorAbs -> Z -> TaskDescriptorAbs)
  (update_task_desc_map : addr -> TaskDescriptorAbs -> (addr -> option TaskDescriptorAbs) -> addr -> option TaskDescriptorAbs)
  (replace_task_desc_map : (addr -> option TaskDescriptorAbs) -> VarGlobalState -> VarGlobalState)
  (tdExstatus : TaskDescriptorAbs -> Z)
  (os_world_wf : StableGlobalState -> VarGlobalState -> Prop)
  (task_world_wf : VarGlobalState -> Prop)
 */

/* New Event outside-critical scenario. The old semaphore_waiters IC contract
 * and its differently adapted body remain untouched in root annotated_C/src.
 * This function retains its actual acquire/release; it is a new proof target. */
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
struct TaskDescriptor *CONTAINER_OF_TASK_SCHED(DoubleLinklistType *sched_link_ptr)
/*@ With task_ptr
    Require addr_aligned(task_ptr, ALIGN_SIZE) &&
            sched_link_ptr == sched_link_of(task_ptr) &&
            emp
    Ensure __return == task_ptr &&
           addr_aligned(__return, ALIGN_SIZE) &&
           sched_link_ptr ==
             &(__return->task_dync_sched_member.sched_link)
 */;

/* Imported contract boundary; source/revision: checks/source-slices/manifest.json. */
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
 */;

x_err_t KTaskWakeup(int32 id)
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
 */;

x_err_t KTaskWakeup(int32 id)
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
/*@ event_waiters_oc
    With (sg : StableGlobalState) (before : VarGlobalState) (id p : Z) X
    Require list == event_pending_head(p) &&
      event_delete_guard(id, p, false, before) &&
      safeExec(LastSeen(before), abs_event_resume_all(id, p), X) &&
      OutsideCritical(sg, before)
    Ensure __return == 0 && exists after,
      event_delete_guard(id, p, true, after) &&
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
 */
{
    x_ubase lock = 0;
    struct TaskDescriptor *task = ((void *)0);
    DoubleLinklistType *node = ((void *)0);

    if (list == ((void *)0)) {
        /*@ Inv Assert list == list@pre && list == 0 &&
          list == event_pending_head(p) && event_delete_guard(id, p, false, before) &&
          safeExec(LastSeen(before), abs_event_resume_all(id, p), X) &&
          has_permission(&task) * has_permission(&node) * has_permission(&lock) *
          OutsideCritical(sg, before)
         */
        while (1) { }
    }

    lock = CriticalAreaLock()
      /*@ where (event_delete_gap) sg = sg, before = before, id = id, p = p, empty = false */;
    /*@ Given locked from current */
    /*@ event_delete_gap(id, p, false, before, locked) && os_inv(sg, locked)
        which implies exists (waiting : list addr),
          event_delete_gap(id, p, false, before, locked) &&
          event_pending_at(id, p, waiting, locked) && os_inv(sg, locked)
     */
    /*@ Given waiting */
    /*@ Inv Assert exists (current : VarGlobalState) (remaining : list addr) (saved_lock : Z),
      list == list@pre && list != 0 && list == event_pending_head(p) && lock == saved_lock &&
      event_delete_gap(id, p, false, before, locked) &&
      event_pending_at(id, p, waiting, locked) &&
      event_pending_at(id, p, remaining, current) &&
      event_resume_remaining_effect(p, waiting, locked, remaining, current) &&
      safeExec(LastSeen(before), abs_event_resume_all(id, p), X) &&
      has_permission(&task) * has_permission(&node) *
      InsideCritical(sg, locked) * os_inv(sg, current)
     */
    while (1) {
        /*@ Given current remaining saved_lock */
        /*@ list@pre == event_pending_head(p) &&
            event_pending_at(id, p, remaining, current) && os_inv(sg, current)
            which implies exists next,
              list@pre == event_pending_head(p) &&
              event_pending_at(id, p, remaining, current) &&
              ((remaining == nil && next == list@pre) ||
               (exists first tail, remaining == cons(first, tail) &&
                 next == sched_link_of(first) && next != list@pre)) &&
              store(field_addr(list@pre, struct SysDoubleLinklistNode, node_next),
                struct SysDoubleLinklistNode *, next) *
              event_resume_next_restore(sg, current, list@pre, next)
         */
        /*@ Given next */
        node = list->node_next;
        /*@ store(field_addr(list@pre, struct SysDoubleLinklistNode, node_next),
              struct SysDoubleLinklistNode *, next) *
            event_resume_next_restore(sg, current, list@pre, next)
            which implies os_inv(sg, current)
         */
        if(node != list) {
            /*@ Given target from first */
            /*@ Given rest from tail */
            /*@ remaining == cons(target, rest) && next == sched_link_of(target) &&
                event_pending_at(id, p, remaining, current) && os_inv(sg, current)
                which implies exists desc,
                  remaining == cons(target, rest) && next == sched_link_of(target) &&
                  event_pending_at(id, p, remaining, current) &&
                  addr_aligned(target, ALIGN_SIZE) &&
                  current.os_tasks.task_desc_map(target) == Some(desc) &&
                  desc.tdSchedMember.tsmStat == TSK_SUSPEND &&
                  os_world_wf(sg, current) && task_world_wf(current) && os_inv(sg, current)
             */
            /*@ Given desc */
            task = CONTAINER_OF_TASK_SCHED(node) /*@ where task_ptr = target */;
            /*@ current.os_tasks.task_desc_map(target) == Some(desc) && os_inv(sg, current)
                which implies exists marked,
                  current.os_tasks.task_desc_map(target) == Some(desc) &&
                  marked == replace_task_desc_map(
                    update_task_desc_map(target, set_task_desc_exstatus(desc, -1),
                      current.os_tasks.task_desc_map), current) &&
                  store(field_addr(target, struct TaskDescriptor, exstatus), long, tdExstatus(desc)) *
                  event_resume_exstatus_restore(sg, marked, target, -1)
             */
            /*@ Given marked */
            task->exstatus = -1;
            /*@ store(field_addr(target, struct TaskDescriptor, exstatus), long, -1) *
                event_resume_exstatus_restore(sg, marked, target, -1)
                which implies os_inv(sg, marked)
             */
            /*@ remaining == cons(target, rest) &&
                event_pending_at(id, p, remaining, current) &&
                marked == replace_task_desc_map(
                  update_task_desc_map(target, set_task_desc_exstatus(desc, -1),
                    current.os_tasks.task_desc_map), current) && os_inv(sg, marked)
                which implies exists task_id,
                  remaining == cons(target, rest) &&
                  event_pending_at(id, p, remaining, current) &&
                  marked == replace_task_desc_map(
                    update_task_desc_map(target, set_task_desc_exstatus(desc, -1),
                      current.os_tasks.task_desc_map), current) &&
                  0 <= task_id && task_id < 65536 &&
                  get_task_with_idnode_success(sg, marked, task_id, target) &&
                  event_pending_at(id, p, remaining, marked) &&
                  os_world_wf(sg, marked) && task_world_wf(marked) &&
                  store(field_addr(field_addr(target, struct TaskDescriptor, id), struct IdNode, id),
                    unsigned short, task_id) * event_resume_id_restore(sg, marked, target, task_id)
             */
            /*@ Given task_id */
            int32 resume_task_id = task->id.id;
            /*@ store(field_addr(field_addr(target, struct TaskDescriptor, id), struct IdNode, id),
                  unsigned short, task_id) * event_resume_id_restore(sg, marked, target, task_id)
                which implies os_inv(sg, marked)
             */
            KTaskWakeup(resume_task_id) /*@ where (wakeup_by_id_ic) sg = sg, before = marked */;
        } else {
            break;
        }
    }
    /*@ Given current remaining saved_lock */
    /*@ event_pending_at(id, p, remaining, current) &&
        event_resume_remaining_effect(p, waiting, locked, remaining, current) &&
        remaining == nil && event_delete_gap(id, p, false, before, locked) &&
        event_pending_at(id, p, waiting, locked) &&
        safeExec(LastSeen(before), abs_event_resume_all(id, p), X) && os_inv(sg, current)
        which implies event_delete_guard(id, p, true, current) &&
          Crtos_GTrans(locked, current) &&
          safeExec(LastSeen(current), return(tt), X) && os_inv(sg, current)
     */
    CriticalAreaUnLock(lock) /*@ where (stable) sg = sg, st1 = locked, st2 = current */;

    return 0;
}
