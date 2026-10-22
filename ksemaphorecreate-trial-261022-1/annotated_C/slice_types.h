#ifndef KSEMAPHORECREATE_TRIAL_TYPES_H
#define KSEMAPHORECREATE_TRIAL_TYPES_H
/* ABI-only declarations, sourced from current xs_base/xs_klist/xs_id/xs_sem.
 * Cortex-M3 ILP32; original static nest remains the same object in this slice. */
typedef signed int int32;
typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;
typedef long x_base;
typedef unsigned long x_size_t;
typedef unsigned int size_t;
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
extern uint16 KTaskOsAssignLockNest;
extern struct IdManager k_sem_id_manager;
extern DoubleLinklistType k_sem_list;
#endif
