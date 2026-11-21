# 0 "/home/xinra/crtos-verify/annotated_C/src/kernel/semaphore/_SemaphoreDelete.c"
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
# 1 "/home/xinra/crtos-verify/annotated_C/src/kernel/semaphore/_SemaphoreDelete.c"
/* Source: /home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/semaphore.c; SHA-256 dafd02bf7c6fa5a7324c6e0f824d9a1ddc1544c43f9e71aabeb902d832f30ab8.
 * Selected 32-bit non-SMP config: KERNEL_STATIC_OBJECTS and KERNEL_DEFER_IPC_SCHED undefined. */
/* One canonical body, with selectable calling context.
 * CRTOS_DATAQUEUE_SEMAPHORE_IC defaults to 1 for this dataqueue verification.
 * Define it as 0 to retain the original OC contracts, annotations and locks.
 * IC uses the reviewed dataqueue contract and removes only nested lock/unlock
 * operations under the source-processing rule; all other C paths are shared.
 * Selecting a contract is not an implementation-proof result.
 */

#define CRTOS_DATAQUEUE_SEMAPHORE_IC 1


# 1 "annotated_C/src/headers/dataqueue.h" 1

#define CRTOS_DATAQUEUE_H 
/* Source ABI: /home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_dataqueue.h; current ILP32 non-SMP configuration.
 * Source SHA-256: fb10a4ae331e8646d0cf26c3302c63d0b199e3bb6562d351a9130aa705454df8.
 * Shared scalar, ID and semaphore layouts are imported without copying.
 * Latest NULL_PARAM_CHECK is log/count-only and supplies no non-null fact. */
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
# 8 "annotated_C/src/headers/dataqueue.h" 2

typedef struct DataElem {
    const void *data;
    x_size_t length;
} DataElemType;
typedef struct DataQueue {
    uint16 front;
    uint16 rear;
    uint16 max_len;
    DataElemType *base;
    int sem_blank;
    int sem_data;
} DataQueueType;
/*@ Import Coq Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak */
/*@ Import Coq From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib */
/*@ Import Coq Import Monad MonadNotation */
/*@ Import Coq Local Open Scope monad */
/*@ Extern Coq
  (program :: * => * => *) (unit :: *)
*/
/*@ Extern Coq
  (tt : unit)
  (safeExec : {Sigma} {A} -> (Sigma -> Prop) -> program Sigma A -> (A -> Sigma -> Prop) -> Prop)
  (return : {Sigma} {A} -> A -> program Sigma A)
  (addr_aligned : Z -> Z -> Prop)
  (CharArray::undef_full : Z -> Z -> Assertion)
  (CharArray::full : Z -> Z -> list Z -> Assertion)
  (repeat_Z : {A} -> A -> Z -> list A)
*/
/*@ Printing Coq Name program := MonadErr.M */
/*@ Printing Strategy Name program := MonadErr.M */
/*@ Printing Coq Name safeExec := monadesafe_lib.safeExec */
/*@ Printing Coq Name return := MonadErr.ret */

#define CRTOS_DATAQUEUE_COQ_OPTION 
/*@ Extern Coq
  (option :: * => *)
*/
/*@ Extern Coq
  (Some : {A} -> A -> option A) (None : {A} -> option A)
*/

/*@ Extern Coq
  (StableGlobalState :: *) (VarGlobalState :: *)
  (DataQueueAbs :: *) (DataqueueState :: *) (DataqueueSemRefs :: *)
*/
/*@ Extern Coq
  (InsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
  (OutsideCritical : StableGlobalState -> VarGlobalState -> Assertion)
  (os_inv : StableGlobalState -> VarGlobalState -> Assertion)
  (Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop)
  (Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop)
  (LastSeen : VarGlobalState -> (VarGlobalState -> Prop) -> Prop)
  (DataqueueStorage : Z -> Assertion)
  (store_dataqueue : Z -> DataQueueAbs -> Assertion)
  (dataqueue_retired : DataQueueAbs -> DataQueueAbs)
  (dq_base : DataQueueAbs -> Z)
  (dq_max_len : DataQueueAbs -> Z) (dq_front : DataQueueAbs -> Z)
  (dq_rear : DataQueueAbs -> Z) (dq_sem_blank : DataQueueAbs -> Z)
  (dq_sem_data : DataQueueAbs -> Z)
  (os_dataqueues : VarGlobalState -> DataqueueState)
  (dataqueue_map : DataqueueState -> Z -> option DataQueueAbs)
  (In : {A} -> A -> list A -> Prop)
  (abs_init_dataqueue : StableGlobalState -> Z -> Z -> program (VarGlobalState -> Prop) Z)
  (abs_deinit_dataqueue : StableGlobalState -> Z -> DataQueueAbs -> DataqueueSemRefs -> program (VarGlobalState -> Prop) unit)
  (semaphore_create_ic_effect : StableGlobalState -> Z -> VarGlobalState -> Z -> VarGlobalState -> Prop)
  (semaphore_delete_quiescent : Z -> VarGlobalState -> Prop)
  (semaphore_delete_ic_effect : Z -> VarGlobalState -> VarGlobalState -> Prop)
*/
/*@ Printing Coq Name StableGlobalState := CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState */
/*@ Printing Coq Name VarGlobalState := CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState */
/*@ Printing Coq Name os_dataqueues := CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues */
/*@ Printing Coq Name InsideCritical := CRTOS_Verify.lib.common.CrtosRules.InsideCritical */
/*@ Printing Coq Name OutsideCritical := CRTOS_Verify.lib.common.CrtosRules.OutsideCritical */
/*@ Printing Coq Name Crtos_RTrans := CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans */
/*@ Printing Coq Name Crtos_GTrans := CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans */
/*@ Printing Coq Name LastSeen := CRTOS_Verify.lib.common.CrtosRules.LastSeen */
/*@ Printing Coq Name os_inv := CRTOS_Verify.lib.common.CrtosInv.os_inv */
/*@ Printing Coq Name DataqueueState := CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueState */
/*@ Printing Coq Name dataqueue_map := CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map */
/*@ Printing Coq Name DataQueueAbs := CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs */
/*@ Printing Coq Name dataqueue_retired := CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired */
/*@ Printing Coq Name dq_base := CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base */
/*@ Printing Coq Name dq_max_len := CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len */
/*@ Printing Coq Name dq_front := CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front */
/*@ Printing Coq Name dq_rear := CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear */
/*@ Printing Coq Name dq_sem_blank := CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank */
/*@ Printing Coq Name dq_sem_data := CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data */
/*@ Printing Coq Name DataqueueStorage := CRTOS_Verify.lib.common.DataqueueInv.DataqueueStorage */
/*@ Printing Coq Name store_dataqueue := CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue */
/*@ Printing Coq Name DataqueueSemRefs := CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs */
/*@ Printing Coq Name abs_deinit_dataqueue := CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue */
/*@ Printing Coq Name abs_init_dataqueue := CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue */
/*@ Printing Coq Name semaphore_create_ic_effect := CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect */
/*@ Printing Coq Name semaphore_delete_quiescent := CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent */
/*@ Printing Coq Name semaphore_delete_ic_effect := CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect */
/*@ Extern Coq
  (DataqueueElem :: *)
*/
/*@ Extern Coq
  (dq_data : DataqueueElem -> Z) (dq_length : DataqueueElem -> Z)
  (peak_data_slot : Z -> option Z -> Assertion)
  (peak_length_slot : Z -> option Z -> Assertion)
  (abs_dataqueue_peak : StableGlobalState -> Z -> program (VarGlobalState -> Prop) (option DataqueueElem))
*/
/*@ Printing Coq Name DataqueueElem := CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem */
/*@ Printing Coq Name dq_data := CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data */
/*@ Printing Coq Name dq_length := CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length */
/*@ Printing Coq Name peak_data_slot := CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot */
/*@ Printing Coq Name peak_length_slot := CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot */
/*@ Printing Coq Name abs_dataqueue_peak := CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak */
# 15 "/home/xinra/crtos-verify/annotated_C/src/kernel/semaphore/_SemaphoreDelete.c" 2
# 1 "annotated_C/src/headers/dataqueue_semaphore_logic.h" 1

#define CRTOS_DATAQUEUE_SEMAPHORE_LOGIC_H 

/* Native shared predicates: vocabulary only; contracts remain in each C file.
 * Source: /home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_sem.h; SHA-256 c2c6edfde22823863a655d6d2a3f59fb749085a8b426166c885c2d5354174fab.
 * Source: /home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_assign.h; SHA-256 939b9f9b498ef33a02863dd0063220017610364f423e36c93a9be7c66848a472.
 * Source: /home/xinra/crtoslatest/Ubiquitous/XiZi_IIoT_Macro/kernel/include/xs_static_objects.h; SHA-256 7299746e499097857ca3a2f0fbb67352fba9f4efbb94c7b52280b998d61d1576.
 * Selected annotated_C/src/include/xsconfig.h leaves KERNEL_DEFER_IPC_SCHED
 * and KERNEL_STATIC_OBJECTS undefined: ON_WAKE uses DO_KTASK_ASSIGN and
 * lifecycle-check macros are empty. Other configurations require new review. */
/*@ Import Coq Require Import CRTOS_Verify.lib.semaphore.KSemaphoreDelete */
/*@ Import Coq Require Import CRTOS_Verify.lib.id.idnode CRTOS_Verify.lib.id.IdModuleSpec CRTOS_Verify.lib.common.dll CRTOS_Verify.lib.list.NodeSelfLinked */
/*@ Import Coq Import IDNode DLL */
# 23 "annotated_C/src/headers/dataqueue_semaphore_logic.h"
/*@ Extern Coq addr := Z */
/*@ Extern Coq Record StableIdmanager { idmax: Z; hoffset: Z; id_map: Z; htable: Z; } */
/*@ Extern Coq
  (VarIdmanager :: *) (IdNodeAbs :: *) (DL_Node :: * => *)
*/
/*@ Extern Coq
  (store_idmanager : StableIdmanager -> VarIdmanager -> Z -> Assertion)
  (Build_IdNodeAbs : Z -> Z -> IdNodeAbs)
  (store_idmanager_allocated_unlinked : StableIdmanager -> VarIdmanager -> Z -> Z -> Assertion)
  (store_idmanager_remove_ready : StableIdmanager -> VarIdmanager -> Z -> Z -> Z -> Assertion)
  (store_idmanager_removeobj_post : StableIdmanager -> VarIdmanager -> Z -> Z -> Z -> Assertion)
  (store_idnode_unlinked : Z -> IdNodeAbs -> Assertion)
  (idmanager_first_free_id : StableIdmanager -> VarIdmanager -> option Z)
  (store_idmanager_found : StableIdmanager -> VarIdmanager -> Z -> Z -> Z -> Assertion)
  (store_idnode_insert_ready : Z -> Assertion)
  (idmanager_min_free_id : StableIdmanager -> VarIdmanager -> Z -> Prop)
  (idmanager_add : VarIdmanager -> Z -> VarIdmanager)
  (idmanager_link : StableIdmanager -> VarIdmanager -> Z -> Z -> VarIdmanager)
  (idmanager_query : VarIdmanager -> Z -> bool)
  (idmanager_contains : StableIdmanager -> VarIdmanager -> Z -> Z -> Prop)
  (idmanager_remove : StableIdmanager -> VarIdmanager -> Z -> VarIdmanager)
  (store_node_self_linked : Z -> Assertion)
  (occupy_dll_node : Z -> Assertion)
  (store_dll : {A} -> (Z -> A -> Assertion) -> Z -> list(DL_Node A) -> Assertion)
  (Build_DL_Node : {A} -> A -> Z -> DL_Node A)
  (dll_insert_anchor : {A} -> Z -> list(DL_Node A) -> Z -> Prop)
  (dll_insert_after_dispatch : {A} -> Z -> list(DL_Node A) -> Z -> DL_Node A -> list(DL_Node A))
  (map : {A} {B} -> (A -> B) -> list A -> list B)
  (app : {A} -> list A -> list A -> list A)
  (semaphore_pending_head : Z -> Z)
  (sched_link_node : Z -> DL_Node Z)
  (semaphore_pending_nodes_ic : Z -> VarGlobalState -> list(DL_Node Z) -> Prop)
  (semaphore_resume_all_ic_effect : Z -> list Z -> VarGlobalState -> VarGlobalState -> Prop)
  (abs_ktask_assign : program (VarGlobalState -> Prop) unit)
*/
/*@ Printing Coq Name semaphore_pending_nodes_ic := CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_pending_nodes_ic */
/*@ Printing Coq Name semaphore_resume_all_ic_effect := CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_resume_all_ic_effect */
/*@ Printing Coq Name abs_ktask_assign := CRTOS_Verify.lib.assign.KTaskOsAssign.abs_ktask_assign */
/*@ Printing Coq Name store_idmanager := CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager */
/*@ Printing Coq Name store_idmanager_allocated_unlinked := CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager_allocated_unlinked */
/*@ Printing Coq Name store_idmanager_remove_ready := CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager_remove_ready */
/*@ Printing Coq Name store_idmanager_removeobj_post := CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager_removeobj_post */
/*@ Printing Coq Name store_idnode_unlinked := CRTOS_Verify.lib.id.idnode.IDNode.store_idnode_unlinked */
/*@ Printing Coq Name store_idmanager_found := CRTOS_Verify.lib.id.idnode.IDNode.store_idmanager_found */
/*@ Printing Coq Name store_idnode_insert_ready := CRTOS_Verify.lib.id.idnode.IDNode.store_idnode_insert_ready */
/*@ Printing Coq Name occupy_dll_node := CRTOS_Verify.lib.common.dll.DLL.occupy_dll_node */
/*@ Printing Coq Name store_dll := CRTOS_Verify.lib.common.dll.DLL.store_dll */
/*@ Printing Coq Name store_node_self_linked := CRTOS_Verify.lib.list.NodeSelfLinked.store_node_self_linked */
/*@ Printing Coq Name idmanager_min_free_id := CRTOS_Verify.lib.id.idnode.IDNode.idmanager_min_free_id */
/*@ Printing Coq Name idmanager_first_free_id := CRTOS_Verify.lib.id.idnode.IDNode.idmanager_first_free_id */
/*@ Printing Coq Name idmanager_remove := CRTOS_Verify.lib.id.idnode.IDNode.idmanager_remove */
/*@ Printing Coq Name idmanager_add := CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_add */
/*@ Printing Coq Name idmanager_link := CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_link */
/*@ Printing Coq Name idmanager_query := CRTOS_Verify.lib.id.idnode_abs.IDNodePure.idmanager_query */
/*@ Printing Coq Name idmanager_contains := CRTOS_Verify.lib.id.IdModuleSpec.idmanager_contains */
/*@ Printing Coq Name StableIdmanager := CRTOS_Verify.lib.id.idnode_abs.StableIdmanager */
/*@ Printing Coq Name VarIdmanager := CRTOS_Verify.lib.id.idnode_abs.VarIdmanager */
/*@ Printing Coq Name IdNodeAbs := CRTOS_Verify.lib.id.idnode_abs.IdNodeAbs */
/*@ Printing Coq Name Build_IdNodeAbs := CRTOS_Verify.lib.id.idnode_abs.Build_IdNodeAbs */
/*@ Printing Coq Name DL_Node := CRTOS_Verify.lib.common.dll_abs.DL_Node */
/*@ Printing Coq Name Build_DL_Node := CRTOS_Verify.lib.common.dll_abs.Build_DL_Node */
/*@ Printing Coq Name dll_insert_anchor := CRTOS_Verify.lib.list.DoubleLinkListSpec.dll_insert_anchor */
/*@ Printing Coq Name dll_insert_after_dispatch := CRTOS_Verify.lib.list.DoubleLinkListSpec.dll_insert_after_dispatch */
# 16 "/home/xinra/crtos-verify/annotated_C/src/kernel/semaphore/_SemaphoreDelete.c" 2

/*@ Extern Coq (SemaphoreStable :: *) (SemaphoreAbs :: *) */
/*@ Extern Coq SemaphoreState := list SemaphoreAbs */
/*@ Extern Coq
 (os_semaphores : VarGlobalState -> SemaphoreState)
 (os_semaphore_stable : StableGlobalState -> SemaphoreStable)
 (semaphore_manager_stable : SemaphoreStable -> StableIdmanager)
 (semaphore_manager : SemaphoreState -> VarIdmanager)
 (dataqueue_inv : SemaphoreState -> DataqueueState -> Assertion)
*/
/* Existing semantic interfaces used only to expose call-site resources. */
/*@ Extern Coq
      (TaskState :: *)
      (TaskDescriptorAbs :: *)
      (ServiceSlotAbs :: *)
      (ZombieQueueAbs :: *)
      (MutexStable :: *)
      (MutexState :: *)
      (EventStable :: *)
      (EventState :: *)
      (IsrStable :: *)
      (IsrAbs :: *)
*/
/*@ Extern Coq
      (os_world_wf : StableGlobalState -> VarGlobalState -> Prop)
      (semaphore_context : SemaphoreStable -> Prop)
      (os_tasks : VarGlobalState -> TaskState)
      (task_desc_map : TaskState -> Z -> option TaskDescriptorAbs)
      (pure_suspend_sched_link : (Z -> option TaskDescriptorAbs) -> Z -> Z -> Assertion)
      (os_zombie_head : StableGlobalState -> Z)
      (zombie_queue : VarGlobalState -> ZombieQueueAbs)
      (os_recycler_slot : StableGlobalState -> Z)
      (os_recycle : VarGlobalState -> ServiceSlotAbs)
      (service_id : ServiceSlotAbs -> Z)
      (os_idle_array : StableGlobalState -> Z)
      (os_idle : VarGlobalState -> list ServiceSlotAbs)
      (CORE_COUNT : Z)
      (os_mutex_stable : StableGlobalState -> MutexStable)
      (os_mutexes : VarGlobalState -> MutexState)
      (os_event_stable : StableGlobalState -> EventStable)
      (os_events : VarGlobalState -> EventState)
      (os_isr_stable : StableGlobalState -> IsrStable)
      (os_isr : VarGlobalState -> IsrAbs)
      (store_prio_lookup_table : Assertion)
      (store_zombie_queue : (Z -> option TaskDescriptorAbs) -> Z -> ZombieQueueAbs -> Assertion)
      (mutex_inv : (Z -> Z -> Assertion) -> MutexStable -> MutexState -> Assertion)
      (event_inv : (Z -> Z -> Assertion) -> EventStable -> EventState -> Assertion)
      (isrmanager_inv : IsrStable -> IsrAbs -> Assertion)
      (semaphore_addr : SemaphoreAbs -> Z)
      (semaphore_link_node : SemaphoreAbs -> DL_Node SemaphoreAbs)
      (store_semaphore : (Z -> Z -> Assertion) -> Z -> SemaphoreAbs -> Assertion)
      (task_inv : StableGlobalState -> VarGlobalState -> Assertion)
      (tick_inv : StableGlobalState -> VarGlobalState -> Assertion)
      (delay_inv : StableGlobalState -> VarGlobalState -> Assertion)
      (assign_inv : StableGlobalState -> VarGlobalState -> Assertion)
      (exstatus_inv : StableGlobalState -> VarGlobalState -> Assertion)
*/

/*@ Extern Coq
 (true : bool) (false : bool)
 (wand : Assertion -> Assertion -> Assertion)
 (store_ushort : Z -> Z -> Assertion)
 (NoDup : {A} -> list A -> Prop)
 (semaphore_id : SemaphoreAbs -> Z)
 (semaphore_value : SemaphoreAbs -> Z)
 (semaphore_pending_addrs : SemaphoreAbs -> list Z)
*/

/* Current source: kernel/thread/semaphore.c; non-SMP ILP32.
 * New IC contract for dataqueue's existing locked call site. The global
 * OC contract and IC specialization remain separate design interfaces.
 */

/* reused-spec: annotated_C/src/kernel/id/IdGetObj.c; IdGetObj.
 * Source SHA-256: 6f5447b61e00e565c578815331e1b9c4d777a6b70e17f6a653a73dc6f9349cae.
 * Contract imported with the current predicate names; body/proof status is not
 * a reason to add a local implementation target. See .docs/Report/dataqueue/2026-11-16-InitDataqueue-DataqueuePeak/design.md. */
struct IdNode *IdGetObj(struct IdManager *manager, uint16 id)
/*@ dataqueue_ic_import
    With (sm: StableIdmanager) (m: VarIdmanager)
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

/* TrustBase CONTAINER_OF model: exact embedding, no dereference permission. */
struct Semaphore *CONTAINER_OF_SEMAPHORE_ID(struct IdNode *id_ptr)
/*@ dataqueue_ic_import
    With (sem_ptr : Z)
    Require id_ptr == field_addr(sem_ptr, struct Semaphore, id) && emp
    Ensure __return == sem_ptr && id_ptr == &(__return->id) && emp
*/;

/* reused-spec: annotated_C/src/kernel/list/IsDoubleLinkListEmpty.c; IsDoubleLinkListEmpty.
 * Source SHA-256: 4b22b601357f81ec24f89cdcfd28a186b27fc7d9db2c7930811c5cc9b14ef1ca.
 * Contract imported with the current predicate names; body/proof status is not
 * a reason to add a local implementation target. See .docs/Report/dataqueue/2026-11-16-InitDataqueue-DataqueuePeak/design.md. */
int IsDoubleLinkListEmpty(const DoubleLinklistType *linklist)
/*@ dataqueue_ic_dll
    With {A} (storeA : Z -> A -> Assertion)
             (nodes : list(DL_Node A))
    Require
      store_dll(storeA, linklist, nodes)
    Ensure
      ((__return == 1 && nodes == nil) ||
       (__return == 0 && nodes != nil)) &&
      store_dll(storeA, linklist, nodes)
 */;

/* reused-spec: annotated_C/src/kernel/semaphore/LinklistResumeAll.c / semaphore_waiters.
 * Source SHA-256: 29ca9f354357150f450eed11198bff152a258c1611f8a3e3d153330f70a13b05.
 * Native shared-state effect preserves the dataqueue component. Its adaptation
 * obligations remain explicit. The nonempty branch is retained but unreachable
 * under dataqueue_cleanup_ic's empty-pending guard. */
x_err_t LinklistResumeAll(DoubleLinklistType *list)
/*@ dataqueue_ic_semaphore_waiters
    With (sg : StableGlobalState) (before : VarGlobalState)
         (sem : Z) (waiting : list Z)
    Require list == semaphore_pending_head(sem) &&
      semaphore_pending_nodes_ic(sem, before, map(sched_link_node, waiting)) && os_inv(sg, before)
    Ensure __return == 0 && exists after,
      semaphore_resume_all_ic_effect(sem, waiting, before, after) &&
      semaphore_pending_nodes_ic(sem, after, nil) && os_inv(sg, after)
*/;

/* reused-spec: annotated_C/src/kernel/id/IdRemoveObj.c; IdRemoveObj / low_level_spec.
 * Source SHA-256: 5694b0d103788e448d12bb48a1090312f54e0760c2fc09bf6c576e5104a49bf7.
 * Contract imported with the current predicate names; body/proof status is not
 * a reason to add a local implementation target. See .docs/Report/dataqueue/2026-11-16-InitDataqueue-DataqueuePeak/design.md. */
void IdRemoveObj(struct IdManager *manager, uint16 id)
/*@ dataqueue_ic_low_level_spec
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
              store(field_addr(field_addr(idnode, struct IdNode, link), struct SysDoubleLinklistNode, node_prev), void *, field_addr(idnode, struct IdNode, link)) *
              store(field_addr(field_addr(idnode, struct IdNode, link), struct SysDoubleLinklistNode, node_next), void *, field_addr(idnode, struct IdNode, link)))
*/;

/* reused-spec: annotated_C/src/headers/m_double_linklist.h; DoubleLinkListRmNode / remove_member.
 * Source SHA-256: 8e67a7da9673c31ca64c330eac42066d37ef2c6257c7323792659a6580435a40.
 * Contract imported with the current predicate names; body/proof status is not
 * a reason to add a local implementation target. See .docs/Report/dataqueue/2026-11-16-InitDataqueue-DataqueuePeak/design.md. */
void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
/*@ dataqueue_ic_remove_member
    With {A} (storeA: addr -> A -> Assertion)
             (head: addr) (a: A)
             (prefix: list(DL_Node A))
             (suffix: list(DL_Node A))
    Require store_dll(storeA, head,
              app(prefix, cons(Build_DL_Node(a, linklist_node), suffix)))
    Ensure store_dll(storeA, head, app(prefix, suffix)) *
           storeA(linklist_node, a) *
           store_node_self_linked(linklist_node)
*/;

/* Source-processing model: empty critical section, current shared protocol. */
void KTASK_ASSIGN(void)
/*@ dataqueue_ic_outside_critical
    With (sg : StableGlobalState) (before : VarGlobalState) X
    Require safeExec(LastSeen(before), abs_ktask_assign, X) && OutsideCritical(sg, before)
    Ensure exists after,
      safeExec(LastSeen(after), return(tt), X) && OutsideCritical(sg, after)
*/;
/* KERNEL_FREE exact macro target; entire original allocation is returned. */
void x_free(void *p)
/*@ dataqueue_ic_import
    With n
    Require p != 0 && 0 < n && CharArray::undef_full(p, n)
    Ensure emp
*/;
# 431 "/home/xinra/crtos-verify/annotated_C/src/kernel/semaphore/_SemaphoreDelete.c"
void _SemaphoreDelete(int32 id)

/*@ dataqueue_cleanup_ic
    With (sg : StableGlobalState) (before : VarGlobalState)
    Require semaphore_delete_quiescent(id, before) && os_inv(sg, before)
    Ensure exists after,
      semaphore_delete_ic_effect(id, before, after) && os_inv(sg, after)
*/
# 448 "/home/xinra/crtos-verify/annotated_C/src/kernel/semaphore/_SemaphoreDelete.c"
{





    int resched = 0;
    x_base lock = 0;
    struct Semaphore *sem = ((void *)0);
    struct IdNode *idnode = ((void *)0);

    /* SemIdInvalid(id), inlined from the latest pure helper. */
    if (id < 0 || id > 65535)
        return;
# 484 "/home/xinra/crtos-verify/annotated_C/src/kernel/semaphore/_SemaphoreDelete.c"
/*@ os_inv(sg, before)
      which implies
      os_world_wf(sg, before) && semaphore_context(os_semaphore_stable(sg)) &&
      NoDup(map(semaphore_id, os_semaphores(before))) &&
      store_idmanager(semaphore_manager_stable(os_semaphore_stable(sg)), semaphore_manager(os_semaphores(before)), &k_sem_id_manager) *
      store_dll(store_semaphore(pure_suspend_sched_link(task_desc_map(os_tasks(before)))), &k_sem_list, map(semaphore_link_node, os_semaphores(before))) *
      task_inv(sg, before) * tick_inv(sg, before) * delay_inv(sg, before) *
      assign_inv(sg, before) * store_prio_lookup_table *
      store_zombie_queue(task_desc_map(os_tasks(before)), os_zombie_head(sg), zombie_queue(before)) *
      data_at(os_recycler_slot(sg), int, service_id(os_recycle(before))) *
      IntArray::full(os_idle_array(sg), CORE_COUNT, map(service_id, os_idle(before))) *
      mutex_inv(pure_suspend_sched_link(task_desc_map(os_tasks(before))), os_mutex_stable(sg), os_mutexes(before)) *
      event_inv(pure_suspend_sched_link(task_desc_map(os_tasks(before))), os_event_stable(sg), os_events(before)) *
      isrmanager_inv(os_isr_stable(sg), os_isr(before)) * exstatus_inv(sg, before) *
      dataqueue_inv(os_semaphores(before), os_dataqueues(before)) */

    idnode = IdGetObj(&k_sem_id_manager, id)

/*@ where (dataqueue_ic_import) */

;
    if (idnode == ((void *)0)) {
# 522 "/home/xinra/crtos-verify/annotated_C/src/kernel/semaphore/_SemaphoreDelete.c"
        return;
    }
# 543 "/home/xinra/crtos-verify/annotated_C/src/kernel/semaphore/_SemaphoreDelete.c"
/*@ Assert exists (original : SemaphoreAbs),
      id == id@pre && 0 <= id && id <= 65535 && lock == 0 && resched == 0 && sem == 0 &&
      In(original, os_semaphores(before)) && semaphore_id(original) == id &&
      semaphore_pending_addrs(original) == nil &&
      idnode == field_addr(semaphore_addr(original), struct Semaphore, id) &&
      semaphore_addr(original) != 0 && semaphore_delete_quiescent(id, before) && os_inv(sg, before) */


/*@ Given original */

    sem = CONTAINER_OF_SEMAPHORE_ID(idnode)


/*@ where (dataqueue_ic_import) */



;
# 573 "/home/xinra/crtos-verify/annotated_C/src/kernel/semaphore/_SemaphoreDelete.c"
/*@ In(original, os_semaphores(before)) && sem == semaphore_addr(original) &&
      semaphore_pending_addrs(original) == nil && os_inv(sg, before)
      which implies
      sem == semaphore_addr(original) &&
      store_dll(pure_suspend_sched_link(task_desc_map(os_tasks(before))), &sem->pend_list, nil) * wand(store_dll(pure_suspend_sched_link(task_desc_map(os_tasks(before))), &sem->pend_list, nil), os_inv(sg, before)) */

    if (!IsDoubleLinkListEmpty(&sem->pend_list)


/*@ where (dataqueue_ic_dll) {A = Z} */




) {
        resched = 1;
# 601 "/home/xinra/crtos-verify/annotated_C/src/kernel/semaphore/_SemaphoreDelete.c"
        LinklistResumeAll(&sem->pend_list)


/*@ where (dataqueue_ic_semaphore_waiters) */




;
    }
# 648 "/home/xinra/crtos-verify/annotated_C/src/kernel/semaphore/_SemaphoreDelete.c"
/*@ sem == semaphore_addr(original) && store_dll(pure_suspend_sched_link(task_desc_map(os_tasks(before))), &sem->pend_list, nil) * wand(store_dll(pure_suspend_sched_link(task_desc_map(os_tasks(before))), &sem->pend_list, nil), os_inv(sg, before))
      which implies sem == semaphore_addr(original) && os_inv(sg, before) */


/*@ In(original, os_semaphores(before)) && sem == semaphore_addr(original) && os_inv(sg, before)
      which implies sem == semaphore_addr(original) &&
      store(field_addr(field_addr(sem, struct Semaphore, id), struct IdNode, id), unsigned short, semaphore_id(original)) * wand(store_ushort(field_addr(field_addr(sem, struct Semaphore, id), struct IdNode, id), semaphore_id(original)), os_inv(sg, before)) */

    uint16 delete_sem_id = sem->id.id;

/*@ sem == semaphore_addr(original) && store(field_addr(field_addr(sem, struct Semaphore, id), struct IdNode, id), unsigned short, semaphore_id(original)) * wand(store_ushort(field_addr(field_addr(sem, struct Semaphore, id), struct IdNode, id), semaphore_id(original)), os_inv(sg, before))
      which implies sem == semaphore_addr(original) && os_inv(sg, before) */
# 697 "/home/xinra/crtos-verify/annotated_C/src/kernel/semaphore/_SemaphoreDelete.c"
    /* Keep the old manager's ID uniqueness as a pure fact across removal.
     * The previous os_inv entailment must derive it from idbuckets_ok/idlist_ok;
     * the post-removal manager alone cannot recover uniqueness of deleted IDs. */

/*@ Assert exists (prefix suffix : list SemaphoreAbs),
      id == id@pre && 0 <= id && id <= 65535 && lock == 0 && resched == 0 &&
      sem == semaphore_addr(original) && idnode == &sem->id && delete_sem_id == semaphore_id(original) &&
      semaphore_id(original) == id && semaphore_pending_addrs(original) == nil &&
      os_semaphores(before) == app(prefix, cons(original, suffix)) &&
      NoDup(map(semaphore_id, os_semaphores(before))) &&
      idmanager_query(semaphore_manager(os_semaphores(before)), semaphore_id(original)) == true &&
      semaphore_delete_quiescent(id, before) &&
      os_world_wf(sg, before) && semaphore_context(os_semaphore_stable(sg)) &&
      store_idmanager(semaphore_manager_stable(os_semaphore_stable(sg)), semaphore_manager(os_semaphores(before)), &k_sem_id_manager) *
      store_dll(store_semaphore(pure_suspend_sched_link(task_desc_map(os_tasks(before)))),
        &k_sem_list, app(map(semaphore_link_node, prefix),
          cons(Build_DL_Node(original, &sem->link), map(semaphore_link_node, suffix)))) *
      task_inv(sg, before) * tick_inv(sg, before) * delay_inv(sg, before) *
      assign_inv(sg, before) * store_prio_lookup_table *
      store_zombie_queue(task_desc_map(os_tasks(before)), os_zombie_head(sg), zombie_queue(before)) *
      data_at(os_recycler_slot(sg), int, service_id(os_recycle(before))) *
      IntArray::full(os_idle_array(sg), CORE_COUNT, map(service_id, os_idle(before))) *
      mutex_inv(pure_suspend_sched_link(task_desc_map(os_tasks(before))), os_mutex_stable(sg), os_mutexes(before)) *
      event_inv(pure_suspend_sched_link(task_desc_map(os_tasks(before))), os_event_stable(sg), os_events(before)) *
      isrmanager_inv(os_isr_stable(sg), os_isr(before)) * exstatus_inv(sg, before) *
      dataqueue_inv(os_semaphores(before), os_dataqueues(before)) */


/*@ Given prefix suffix */

    IdRemoveObj(&k_sem_id_manager, delete_sem_id)


/*@ where (dataqueue_ic_low_level_spec) */




;
# 749 "/home/xinra/crtos-verify/annotated_C/src/kernel/semaphore/_SemaphoreDelete.c"
    DoubleLinkListRmNode(&sem->link)


/*@ where (dataqueue_ic_remove_member) {A = SemaphoreAbs} */





;
# 790 "/home/xinra/crtos-verify/annotated_C/src/kernel/semaphore/_SemaphoreDelete.c"
/*@ Assert exists (after : VarGlobalState),
      id == id@pre && sem == semaphore_addr(original) && sem != 0 &&
      lock == 0 && resched == 0 && idnode == &sem->id && delete_sem_id == semaphore_id(original) &&
      semaphore_delete_ic_effect(id, before, after) &&
      os_inv(sg, after) * CharArray::undef_full(sem, 32) */


/*@ Given after */

    x_free(sem)

/*@ where (dataqueue_ic_import) */

;

    if (resched){
        /* DO_KTASK_ASSIGN_ON_WAKE() == DO_KTASK_ASSIGN in the selected
         * config (KERNEL_DEFER_IPC_SCHED undefined); use the existing model. */
        KTASK_ASSIGN()

/*@ where (dataqueue_ic_outside_critical) */



;
    }
}
