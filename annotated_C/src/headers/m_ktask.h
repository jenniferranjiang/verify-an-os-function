#ifndef M_KTASK_H
#define M_KTASK_H

#include "m_id.h"

#define KTASK_LOWEST_PRIORITY       0
#define KTASK_INIT                  0x00
#define KTASK_READY                 0x01
#define KTASK_SUSPEND               0x02
#define KTASK_RUNNING               0x03
#define KTASK_CLOSE                 0x04
#define KTASK_STAT_MASK             0x07

#define KTASK_MAX_ADVANCE_PROCESS_TIME        0x1    ///< task max advance process times

#define TASK_DELAY_INACTIVE 0
#define TASK_DELAY_ACTIVE   1

typedef unsigned long size_t;

/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskPure */
/*@ Import Coq Require Import CRTOS_Verify.lib.StructFieldOffsetAxiom */
/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskStackSetup */
/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskStackSetupProofAux */
/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskParseInfo */
/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskDescriptor */
/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskSchedMember */
/*@ Import Coq Require Import CRTOS_Verify.lib.CrtosInv */
/*@ Import Coq Require Import CRTOS_Verify.libai.AssignReadyPending */

/*@ Extern Coq (TaskStatus :: *) */
/*@ Extern Coq
               (TSK_INIT : TaskStatus) (TSK_READY : TaskStatus)
               (TSK_RUNNING : TaskStatus) (TSK_SUSPEND : TaskStatus)
               (TSK_CLOSE : TaskStatus) (TSK_INVALID : TaskStatus)
               (decode_task_status : Z -> TaskStatus)
               (task_status_matches : TaskStatus -> Z -> Prop)
               (store_task_status : Z -> TaskStatus -> Assertion) */

/*@ Extern Coq (StableGlobalState :: *)
               (VarGlobalState :: *)
               (TaskStable :: *)
               (TaskState :: *)
               (AssignStable :: *)
               (DelayState :: *)
               (TaskDescriptorAbs :: *)
               (TaskSchedMemberAbs :: *)
               (TaskBaseInfoAbs :: *)
               (OsAssignReadyVectorAbs :: *)
               (VarAssignAbs :: *) */
/*@ Extern Coq
      (InsideCritical :
        StableGlobalState -> VarGlobalState -> Assertion)
      (OutsideCritical :
        StableGlobalState -> VarGlobalState -> Assertion)
      (Crtos_RTrans : VarGlobalState -> VarGlobalState -> Prop)
      (Crtos_GTrans : VarGlobalState -> VarGlobalState -> Prop)
      (os_inv :
        StableGlobalState -> VarGlobalState -> Assertion)
 */

/*
 * Stage-1 nested 接口对应当前非 SMP、RISC-V 配置下已关闭中断的调用者。
 * k210/interrupt.c 的 DisableLocalInterrupt 保存 mstatus 并清除 bit 3；
 * EnableLocalInterrupt 恢复保存值。因此 nested 返回值必须满足 MIE=0，
 * nested 解锁也必须检查该保存值，不能对任意 lock 承诺继续持锁。
 * 这些是新增的待审核 primitive Specs；汇编和锁计数器仍在既有临界区
 * primitive 的验证边界内，本次没有声称已经验证其 C/汇编实现。
 * ordinary/stable 使用原始 CriticalSTS 的进入/退出规则；nested 规格保持原文。
 */
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
 */
/*@ nested
    With (sg : StableGlobalState) (st : VarGlobalState)
    Require InsideCritical(sg, st)
    Ensure (__return & 8) == 0 && InsideCritical(sg, st)
 */
;

void CriticalAreaUnLock(x_base lock)
/*@ stable
    With (sg : StableGlobalState) (st1 st2 : VarGlobalState)
    Require
      Crtos_GTrans(st1, st2) &&
      InsideCritical(sg, st1) *
      os_inv(sg, st2)
    Ensure
      OutsideCritical(sg, st2)
 */
/*@ nested
    With (sg : StableGlobalState) (st : VarGlobalState)
    Require (lock & 8) == 0 && InsideCritical(sg, st)
    Ensure InsideCritical(sg, st)
 */
;

struct TaskDescriptor;

struct Delay
{
 struct TaskDescriptor *task;
 x_ticks_t ticks;
 uint8 status;
 DoubleLinklistType link;
};

typedef struct Delay *DelayType;

/*@ Import Coq Require Import CRTOS_Verify.libai.KTaskSetDelay */
/*@ Import Coq Import DLL */

/*@ Extern Coq (DL_Node :: * => *)
               (option :: * => *)
*/
/*@ Extern Coq Record TaskDelayAbs {
      tdTaskPtr: Z;
      tdTicks: Z;
      tdStatus: Z;
    }
*/
/* QCP 的 Record 声明只登记此切片需要的逻辑投影；不改变 Rocq record。 */
/*@ Extern Coq Record TaskSchedMemberAbs {
      tsmStat: TaskStatus;
      tsmAdvanceCnt: Z;
      tsmCurPrio: Z;
      tsmOriginTimeslice: Z;
      tsmRestTimeslice: Z;
      tsmBitmapColumn: Z;
    }
*/
/*@ Extern Coq Record TaskBaseInfoAbs {
      tbName: list(Z);
      tbFuncEntry: Z;
      tbFuncParam: Z;
      tbOriginPrio: Z;
      tbStackDepth: Z;
      tbStackStart: Z;
    }
*/
/*@ Extern Coq Record OsAssignReadyVectorAbs {
      orvBuckets: list(list(DL_Node Z));
      orvReadyGroup: Z;
      orvHighestPrio: Z;
    }
*/
/*@ Extern Coq Record VarAssignAbs {
      assignReadyVector: OsAssignReadyVectorAbs;
      assignRunningTask: Z;
      assignCurrentPriority: Z;
    }
*/
/*@ Extern Coq Record TaskStable {
      task_stable_ids: StableIdmanager;
      task_idmanager_ptr: Z;
      task_list_head: Z;
    }
*/
/*@ Extern Coq Record TaskState {
      task_desc_map: Z -> option TaskDescriptorAbs;
      task_idmanager_abs: VarIdmanager;
      task_ptr_list: list(Z);
      sched_owned_tasks: list(Z);
    }
*/
/*@ Extern Coq Record AssignStable {
      assign_ptr: Z;
    }
*/
/*@ Extern Coq Record DelayState {
      delay_inactive_map: Z -> option TaskDelayAbs;
      delay_active_nodes: list(DL_Node TaskDelayAbs);
    }
*/
/*@ Extern Coq Record StableGlobalState {
      os_task_stable: TaskStable;
      os_assign_stable: AssignStable;
      os_tick_ptr: Z;
      delay_head_ptr: Z;
    }
*/
/*@ Extern Coq Record VarGlobalState {
      os_tasks: TaskState;
      os_delays: DelayState;
      os_assign: VarAssignAbs;
      os_tick: Z;
    }
*/
/*@ Extern Coq Record TaskDescriptorAbs {
      tdBaseInfo: TaskBaseInfoAbs;
      tdSchedMember: TaskSchedMemberAbs;
      tdStackPoint: Z;
      tdDelay: Z;
      tdEventIdTrigger: Z;
      tdEventMode: Z;
      tdExstatus: Z;
      tdDone: Z;
    }
*/
/*@ Extern Coq
      (NOMEMORY : Z)
      (KOK : Z)
      (INVALID : Z)
      (KTICK_HALF_RANGE : Z)
      (tick_add : Z -> Z -> Z)
      (tick_beforeb : Z -> Z -> bool)
      (delay_list_window : Z -> list(DL_Node TaskDelayAbs) -> Prop)
      (Some : {A} -> A -> option A)
      (os_global_context : StableGlobalState -> Prop)
      (task_inv : StableGlobalState -> VarGlobalState -> Assertion)
      (task_fields : StableGlobalState -> VarGlobalState -> Assertion)
      (assign_ready_vector_addr : StableGlobalState -> Z)
      (assign_ready_published : VarGlobalState -> Prop)
      (assign_ready_pending : StableGlobalState -> VarGlobalState -> Assertion)
      (replace_global_ready_vector :
        OsAssignReadyVectorAbs -> VarGlobalState -> VarGlobalState)
      (replace_task_desc_map :
        (Z -> option TaskDescriptorAbs) -> VarGlobalState -> VarGlobalState)
      (delay_inv : StableGlobalState -> VarGlobalState -> Assertion)
      (tick_inv : StableGlobalState -> VarGlobalState -> Assertion)
      (store_delay_info : Z -> TaskDelayAbs -> Assertion)
      (store_task_delay_opt :
        Z -> Z -> list(DL_Node TaskDelayAbs) -> Assertion)
      (store_delay_unlinked_info :
        Z -> TaskDelayAbs -> Assertion)
      (store_delay_dll_focus :
        Z -> list(DL_Node TaskDelayAbs) -> DL_Node TaskDelayAbs ->
        list(DL_Node TaskDelayAbs) -> Assertion)
      (store_delay_dll_frame :
        Z -> list(DL_Node TaskDelayAbs) -> DL_Node TaskDelayAbs ->
        list(DL_Node TaskDelayAbs) -> Assertion)
      (store_delay_dll_head_frame :
        Z -> list(DL_Node TaskDelayAbs) -> Z -> Assertion)
      (store_delay_dll_next_frame :
        Z -> list(DL_Node TaskDelayAbs) -> DL_Node TaskDelayAbs ->
        list(DL_Node TaskDelayAbs) -> Z -> Assertion)
      (store_delay_scan :
        Z -> Z -> list(DL_Node TaskDelayAbs) ->
        list(DL_Node TaskDelayAbs) -> Assertion)
      (delay_prefix_scanned :
        Z -> list(DL_Node TaskDelayAbs) -> Prop)
      (delay_nodes_wf : list(DL_Node TaskDelayAbs) -> Prop)
      (mkTaskDelayAbs : Z -> Z -> Z -> TaskDelayAbs)
      (delay_remove_old :
        Z -> list(DL_Node TaskDelayAbs) ->
        list(DL_Node TaskDelayAbs))
      (delay_insert_by_ticks :
        DL_Node TaskDelayAbs -> list(DL_Node TaskDelayAbs) ->
        list(DL_Node TaskDelayAbs))
      (TASK_DELAY_INACTIVE_VALUE : Z)
      (TASK_DELAY_ACTIVE_VALUE : Z)
      (heartbeat_ticks_addr : Z)
*/

void CheckTaskDelay(void);


struct TaskBaseInfo {
    char name[32]; ///< task name
    void *func_entry; ///< task function entry
    void *func_param; ///< task parameter
    uint8 origin_prio; ///< task init priority
    uint32 stack_depth; ///< task stack size
    void *stack_start; ///< task stack start address
};

typedef struct TaskBaseInfo TaskBaseInfoType;

struct TaskDyncSchedMember {
    uint8 stat; ///< task stat
    uint8 advance_cnt; ///< total time slice advance process count
    uint8 cur_prio; ///< task current priority
    x_ubase origin_timeslice; ///< task init timeslice
    x_ubase rest_timeslice; ///< task remaining timeslice
    DoubleLinklistType sched_link; ///< task sched list
    uint32 bitmap_column;
    DelayType delay;
};

typedef struct TaskDyncSchedMember TaskDyncSchedMembeType;

struct KTaskDone;

struct TaskDescriptor
{
    void *stack_point; ///< stack point
    TaskDyncSchedMembeType task_dync_sched_member; ///< task dynamic sched member
    TaskBaseInfoType task_base_info; ///< task base information
    uint32 event_id_trigger; ///< event ops (event trigger )
    uint32 event_mode; ///<  event mode (AND/OR/AUTOCLEAN)
    x_err_t exstatus; ///< exception status
    DoubleLinklistType link; ///< manage list
    struct IdNode id; ///< task id
    struct KTaskDone *Done;
};

typedef struct TaskDescriptor *KTaskDescriptorType;

struct OsAssignReadyVector {
    DoubleLinklistType priority_ready_vector[32];
    uint32 priority_ready_group;
    x_ubase highest_prio;
};

struct KTaskDone
{
    int32 (*init)(KTaskDescriptorType task,
                        const char *name,
                        void (*entry)(void *parameter),
                        void *parameter,
                        uint32 stack_depth,
                        uint8 priority);
    x_err_t (*start)(KTaskDescriptorType task);
    x_err_t (*Delete)(KTaskDescriptorType task);
    x_err_t (*delay)(KTaskDescriptorType task, x_ticks_t ticks);
    x_err_t (*mdelay)(KTaskDescriptorType task,uint32 ms);
    x_err_t (*prioset)(KTaskDescriptorType task, uint8 prio);
    x_err_t (*suspend)(KTaskDescriptorType task);
    x_err_t (*wake)(KTaskDescriptorType task);
};

int32 KTaskCreate(const char *name,
                             void (*entry)(void *parameter),
                             void *parameter,
                             uint32 stack_depth,
                             uint8 priority);

void KTaskQuit(void);

void KUpdateExstatus(x_err_t no);

int *KObtainExstatus(void);

KTaskDescriptorType GetKTaskDescriptor(void);

KTaskDescriptorType KTaskSearch(char *name);

x_err_t StartupKTask(int32 id);

x_err_t KTaskDelete(int32 id);

x_err_t YieldOsAssign(void);

x_err_t DelayKTask(x_ticks_t tick);

x_err_t MdelayKTask(uint32 ms);

// KTaskPrioSet is bugged, dont use this
x_err_t KTaskPrioSet(int32 id, uint8 prio);

x_err_t KTaskCoreCombine(int32 id, uint8 coreid);

x_err_t KTaskCoreUnCombine(int32 id);

x_err_t SuspendKTask(int32 id);

x_err_t KTaskWakeup(int32 id);

void KTaskTimeout(void *parameter);

void InitIdleKTask(void);

void IdleKTaskExec(void);

KTaskDescriptorType GetIdleKTaskDescripter(void);

void KTaskOsAssign(void);

void KTaskOsAssignRemoveKTask(struct TaskDescriptor *task);

void RoundRobinRemainTaskTimesliceInit(struct TaskDescriptor *task);

void RoundRobinRemainReadyVectorInsert(struct TaskDescriptor *task, struct OsAssignReadyVector* ready_table);

void RoundRobinRemainTaskTimesliceUpdate(struct TaskDescriptor *task);

x_err_t LinklistSuspend(DoubleLinklistType *list,struct TaskDescriptor *task,uint8 flag);
x_err_t LinklistResume(DoubleLinklistType *list);

x_err_t LinklistResumeAll(DoubleLinklistType *list);

void HwSendIpi(int ipi_vector, unsigned int cpu_mask);

void KTaskIdDelete(int32 id);

struct TaskDescriptor *GetTaskWithIdnodeInfo(int32 id);



/*@ Extern Coq (TaskBaseInfoAbs :: *) */
/*@ Extern Coq (StackRegisterContextAbs :: *) */
/*@ Extern Coq (store_string_n : Z -> Z -> list Z -> Assertion)
               (store_task_base_info : Z -> TaskBaseInfoAbs -> Assertion)
               (store_ktask_stack :
                  Z -> Z -> list Z ->
                  StackRegisterContextAbs -> Assertion)
               (store_stack_register_context_slots :
                  Z -> StackRegisterContextAbs -> Assertion)
               (ktask_context_regs_setup :
                  Z -> Z -> Z -> Z -> Z -> StackRegisterContextAbs)
               (UCharArray::full : Z -> Z -> list Z -> Assertion)
               (UIntArray::full : Z -> Z -> list Z -> Assertion)
               (CHAR_SHARP : Z)
               (OxFADEFACE : Z)
               (SAVED_MSTATUS : Z)
               (REG_COUNT : Z)
               (REG_LENGTH : Z)
               (unsigned_last_nbits : Z -> Z -> Z)
               (ktask_stack_aligned_top : Z -> Z -> Z -> Z)
               (ktask_stack_context_addr : Z -> Z -> Z -> Z)
               (ktask_stack_setup_layout_ok : Z -> Z -> Z -> Prop)
               (ktask_stack_context_layout_ok : Prop)
               (aligned_reglen : Z -> Prop)
               (ktask_xubase_value : Z -> Prop)
               (kss_raw_top : TaskBaseInfoAbs -> Z)
               (kss_aligned_top : TaskBaseInfoAbs -> Z)
               (kss_context_addr : TaskBaseInfoAbs -> Z) */

struct StackRegisterContext
{
    x_ubase epc;
    x_ubase ra;
    x_ubase mstatus;
    x_ubase gp;
    x_ubase tp;
    x_ubase t0;
    x_ubase t1;
    x_ubase t2;
    x_ubase s0_fp;
    x_ubase s1;
    x_ubase a0;
    x_ubase a1;
    x_ubase a2;
    x_ubase a3;
    x_ubase a4;
    x_ubase a5;
    x_ubase a6;
    x_ubase a7;
    x_ubase s2;
    x_ubase s3;
    x_ubase s4;
    x_ubase s5;
    x_ubase s6;
    x_ubase s7;
    x_ubase s8;
    x_ubase s9;
    x_ubase s10;
    x_ubase s11;
    x_ubase t3;
    x_ubase t4;
    x_ubase t5;
    x_ubase t6;

};

uint8 KTaskStackSetup(struct TaskDescriptor *task)
/*@ With info
    Require task != 0 &&
            ktask_xubase_value(&KTaskQuit) &&
            ktask_stack_setup_layout_ok(
              info.tbStackStart, info.tbStackDepth, REG_LENGTH) &&
            has_permission(&(task->stack_point)) *
            store_task_base_info(task, info) *
            UCharArray::full(
              info.tbStackStart, info.tbStackDepth,
              repeat_Z(CHAR_SHARP, info.tbStackDepth))
    Ensure __return == 0 &&
            store(&(task->stack_point), kss_context_addr(info)) *
            store_task_base_info(task, info) *
            store_ktask_stack(
              info.tbStackStart, info.tbStackDepth,
              repeat_Z(
                CHAR_SHARP,
                kss_context_addr(info) - info.tbStackStart),
              ktask_context_regs_setup(
                info.tbFuncEntry, info.tbFuncParam, &KTaskQuit,
                SAVED_MSTATUS, OxFADEFACE))
 */
;

inline void NULL_PARAM_CHECK_1(void *p)
/*@
    Require emp
    Ensure p != 0
*/
;

inline void NULL_PARAM_CHECK_2(void (*entry)(void *parameter))
/*@
    Require emp
    Ensure entry != 0
*/
;

/*@ Extern Coq (TaskBaseInfoAbs :: *) */
/*@ Extern Coq (StackRegisterContextAbs :: *) */
/*@ Extern Coq (store_string : Z -> list Z -> Assertion)
               (crtos_valid_string : list Z -> Prop)
               (string_length : list Z -> Z)
               (ktask_xubase_value : Z -> Prop)
               (kss_context_addr : TaskBaseInfoAbs -> Z)
               (mkTaskBaseInfoAbs :
                  list Z -> Z -> Z -> Z -> Z -> Z -> TaskBaseInfoAbs)
               (KOK : Z)
               (NOMEMORY : Z)
               (INVALID : Z)
               (PRIORITY_MAX : Z)
               (NAME_MAX_SIZE : Z)
               (REG_LENGTH : Z)
               (ktask_stack_aligned_top : Z -> Z -> Z -> Z)
               (ktask_stack_context_addr : Z -> Z -> Z -> Z)
               (ktask_stack_setup_layout_ok : Z -> Z -> Z -> Prop)
               (aligned_reglen : Z -> Prop)
               (store_ktask_stack :
                  Z -> Z -> list Z ->
                  StackRegisterContextAbs -> Assertion)
               (ktask_context_regs_setup :
                  Z -> Z -> Z -> Z -> Z -> StackRegisterContextAbs)
               (CHAR_SHARP : Z)
               (OxFADEFACE : Z)
               (SAVED_MSTATUS : Z)
               (store_task_base_info :
                  Z -> TaskBaseInfoAbs -> Assertion)
               (has_permission_ktask_base_info : Z -> Assertion)
               (ktask_init_input_arguments_ok :
                  Z -> Z -> Z -> Z -> Z -> Prop)
               (assert_task_base_info_values :
                  TaskBaseInfoAbs -> list Z ->
                  Z -> Z -> Z -> Z -> Prop)
               (has_permission_ktask_base_info_start0 : Z -> Assertion)
               (ALIGN_SIZE : Z)
               (addr_aligned : Z -> Z -> Prop)
 */

/*
 * Verification-facing replacement for
 * CONTAINER_OF(..., TaskDescriptor, task_dync_sched_member.sched_link).
 * The helper has no memory effect.  Its alignment premise is the local fact
 * required by the centralized 32-bit TaskDescriptor layout axiom.
 */
struct TaskDescriptor *CONTAINER_OF_TASK_SCHED(
    DoubleLinklistType *sched_link_ptr)
/*@ With task_ptr
    Require addr_aligned(task_ptr, ALIGN_SIZE) &&
            sched_link_ptr == sched_link_of(task_ptr) &&
            emp
    Ensure __return == task_ptr &&
           addr_aligned(__return, ALIGN_SIZE) &&
           sched_link_ptr ==
             &(__return->task_dync_sched_member.sched_link)
 */
;


void *KERNEL_MALLOC(uint32 size)
/*@ Require 0 <= size && size <= UINT_MAX
    Ensure (__return == 0) ||
           (0 < __return &&
            __return <= UINT_MAX - size &&
            addr_aligned(__return, ALIGN_SIZE) &&
            CharArray::undef_full(__return, size))
 */
;

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

void *memset(void *s, int c, size_t n)
/*@ Require 0 <= n && n <= UINT_MAX &&
            0 <= c && c <= 127 &&
            CharArray::undef_full(s, n)
    Ensure __return == s && CharArray::full(s, n, repeat_Z(c, n))
*/
;

/*@ Printing Coq Name crtos_valid_string := Crtos_C_Rules.valid_string */
/*@ Printing Strategy Name crtos_valid_string := Crtos_C_Rules.valid_string */
char *strncpy(char *dest, const char *src, size_t n)
/*@ With src_str
    Require 0 <= n && n <= UINT_MAX &&
            CharArray::undef_full(dest, n) *
            store_string(src, src_str)
    Ensure  __return == dest &&
            crtos_valid_string(sublist(0, n, src_str)) &&
            CharArray::full(dest, n,
              app(sublist(0, n, src_str),
                  repeat_Z(0, n - string_length(sublist(0, n, src_str))))) *
            store_string(src, src_str)
*/
;

static x_err_t _KTaskBaseInfoParse(KTaskDescriptorType task,
                            const char *name,
                            void (*entry)(void *parameter),
                            void       *parameter,
                            uint32 stack_depth,
                            uint8  priority)
/*@ With src_name
    Require ktask_init_input_arguments_ok(
              entry, parameter, &KTaskQuit,
              stack_depth, priority) &&
            has_permission(&(task->stack_point)) *
            has_permission_ktask_base_info(task) *
            store_string(name, src_name)
    Ensure ktask_init_input_arguments_ok(
             entry, parameter, &KTaskQuit,
             stack_depth, priority) &&
           task != 0 && name != 0 && entry != 0 &&
           ((__return == -INVALID &&
              priority >= PRIORITY_MAX &&
              has_permission(&(task->stack_point)) *
              has_permission_ktask_base_info(task) *
              store_string(name, src_name)) ||
            (__return == -NOMEMORY &&
              priority < PRIORITY_MAX &&
              has_permission(&(task->stack_point)) *
              has_permission_ktask_base_info_start0(task) *
              store_string(name, src_name)) ||
            (__return == KOK &&
              exists info,
              info.tbStackStart != 0 &&
              priority < PRIORITY_MAX &&
              assert_task_base_info_values(
                info, sublist(0, NAME_MAX_SIZE - 1, src_name),
                entry, parameter, stack_depth, priority) &&
              store(&(task->stack_point), kss_context_addr(info)) *
              store_task_base_info(task, info) *
              store_string(name, src_name) *
              store_ktask_stack(
                info.tbStackStart, info.tbStackDepth,
                repeat_Z(
                  CHAR_SHARP,
                  kss_context_addr(info) - info.tbStackStart),
                ktask_context_regs_setup(
                  info.tbFuncEntry, info.tbFuncParam, &KTaskQuit,
                  SAVED_MSTATUS, OxFADEFACE))))
 */
;


/*@ Extern Coq
    (mkTaskSchedMemberAbs :
        TaskStatus -> Z -> Z -> Z -> Z -> Z -> TaskSchedMemberAbs)
      (has_permission_task_sched_member : Z -> TaskStatus -> Assertion)
*/

// Copied from /home/cheng/osroot/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/assign_roundrobinremain.c

void RoundRobinRemainTaskTimesliceInit(struct TaskDescriptor *task)
/*@ Require
      has_permission(
        &(task->task_dync_sched_member.origin_timeslice)) *
      has_permission(
        &(task->task_dync_sched_member.rest_timeslice))
    Ensure
      task != 0 &&
      store(
        &(task->task_dync_sched_member.origin_timeslice),
        unsigned int, 10) *
      store(
        &(task->task_dync_sched_member.rest_timeslice),
        unsigned int, 10)
 */
;

int32 _InitKTask(KTaskDescriptorType task,
              const char *name,
							void (*entry)(void *parameter),
							void       *parameter,
							uint32 stack_depth,
							uint8  priority);
x_err_t _StartupKTask(KTaskDescriptorType task);
x_err_t _DeleteKTask(KTaskDescriptorType task);
x_err_t _DelayKTask(KTaskDescriptorType task, x_ticks_t ticks);
x_err_t _MdelayKTask(KTaskDescriptorType task, uint32 ms);
x_err_t _KTaskPrioSet(KTaskDescriptorType task, uint8 prio);

x_err_t _SuspendKTask(KTaskDescriptorType task);
x_err_t _KTaskWakeup(KTaskDescriptorType task);

DoubleLinklistType xiaoshan_task_head ={&xiaoshan_task_head, &xiaoshan_task_head};    ///< global task manage list

// k_task_id_manager中的ID MAX NUM和桶的大小初始化后固定；
// 抽象状态应为分可变和不可变的部分

// DECLARE_ID_MANAGER(k_task_id_manager, ID_NUM_MAX);
// =================================================>
uint8 __id_map_k_task_id_manager[16];
DoubleLinklistType __htable_k_task_id_manager[16];
struct IdManager k_task_id_manager = {
    .id_max = ID_NUM_MAX,
    .hoffset = 16,
    .id_map = __id_map_k_task_id_manager,
    .htable = __htable_k_task_id_manager
};

// read-only, not protected by lock

static struct KTaskDone Done = {
    .init =  _InitKTask,
    .start = _StartupKTask,
    .Delete = _DeleteKTask,
    .delay = _DelayKTask,
    .mdelay = _MdelayKTask,
    .prioset = _KTaskPrioSet,
    .suspend = _SuspendKTask,
    .wake = _KTaskWakeup
};


DoubleLinklistType xiaoshan_delay_head = {&xiaoshan_delay_head, &xiaoshan_delay_head};

#endif
