# 0 "/home/xinra/crtos-verify/annotated_C/src/kernel/common/CalculateTickFromTimeMs.c"
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
# 1 "/home/xinra/crtos-verify/annotated_C/src/kernel/common/CalculateTickFromTimeMs.c"
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
# 2 "/home/xinra/crtos-verify/annotated_C/src/kernel/common/CalculateTickFromTimeMs.c" 2
/* Existing project assertion instance required with no_crules enabled. */
/*@ Import Coq Require Import CRTOS_Verify.lib.common.CrtosRules */
/*@ Import Coq Require Import CRTOS_Verify.lib.common.TickConversion */
/*@ Extern Coq (tick_from_time_ms : Z -> Z) */
/*@ Extern Coq (nat :: *) */
/*@ Extern Coq (Z::to_nat : Z -> nat) */
/*@ Extern Coq (store_uinteger : nat -> Z -> Z -> Z -> Assertion) */
/* Source: current crtoslatest/thread/tick.c, 100Hz; uint64 cast occurs BEFORE multiply. */
x_ticks_t CalculateTickFromTimeMs(uint32 ms)
/*@
 Require emp
 Ensure __return == tick_from_time_ms(ms) && emp
*/
{
 uint32 tmp = 0;
 x_ticks_t ticks = 0;
 ticks = (uint32)(((unsigned long long)ms * 100) / 1000);
 /* Preserve the actual UInt input range after local cells are released at
  * return. Borrow and return the input cell so its range has a resource basis. */
 /*@ data_at(&ms, unsigned int, ms@pre)
     which implies 0 <= ms@pre && ms@pre <= 4294967295 &&
       store_uinteger(Z::to_nat(4), 4, &ms, ms@pre) */
 /*@ store_uinteger(Z::to_nat(4), 4, &ms, ms@pre)
     which implies data_at(&ms, unsigned int, ms@pre) */
 if (0 == ticks) ticks = 1;
 else {
  tmp = (uint32)(((unsigned long long)ms * 100) % 1000);
  if(tmp >= 5 && tmp <= 9) ticks = ticks + 1;
 }
 return ticks;
}
