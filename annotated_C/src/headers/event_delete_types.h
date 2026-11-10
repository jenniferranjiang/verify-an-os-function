#ifndef CRTOS_EVENT_DELETE_TYPES_H
#define CRTOS_EVENT_DELETE_TYPES_H
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
#endif
