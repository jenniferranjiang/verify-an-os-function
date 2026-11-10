#ifndef KMUTEXDELETE_TRIAL_TYPES_H
#define KMUTEXDELETE_TRIAL_TYPES_H
/* ILP32, non-SMP, RR_REMAINSLICE. ABI declarations only.
 * Task event bitfields use the TrustBase uint32 adaptation. */
typedef signed int int32;
typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;
typedef signed long x_base;
typedef unsigned long x_ubase;
typedef x_base x_err_t;
#define NONE ((void *)0)
#define EOK 0
#define ERROR 1
struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
};
typedef struct SysDoubleLinklistNode DoubleLinklistType;
struct IdNode { uint16 id; DoubleLinklistType link; };
struct IdManager { uint16 id_max; uint16 hoffset; uint8 *id_map; DoubleLinklistType *htable; };
struct TaskDescriptor;
struct Mutex {
    struct IdNode id; uint16 val; uint8 recursive_cnt; uint8 origin_prio;
    struct TaskDescriptor *holder; DoubleLinklistType pend_list; DoubleLinklistType link;
};
struct Delay;
struct TaskBaseInfo {
    char name[32]; void *func_entry; void *func_param; uint8 origin_prio;
    uint32 stack_depth; void *stack_start;
};
struct TaskDyncSchedMember {
    uint8 stat; uint8 advance_cnt; uint8 cur_prio;
    x_ubase origin_timeslice; x_ubase rest_timeslice;
    DoubleLinklistType sched_link; uint32 bitmap_column; struct Delay *delay;
};
struct KTaskDone;
struct TaskDescriptor {
    void *stack_point; struct TaskDyncSchedMember task_dync_sched_member;
    struct TaskBaseInfo task_base_info;
    uint32 event_id_trigger; uint32 event_mode;
    x_err_t exstatus; DoubleLinklistType link; struct IdNode id; struct KTaskDone *Done;
};
extern struct IdManager k_mutex_id_manager;
extern DoubleLinklistType k_mutex_list;
#endif
