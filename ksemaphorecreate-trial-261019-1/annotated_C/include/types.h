#ifndef TRIAL_TYPES_H
#define TRIAL_TYPES_H
#include <stddef.h>
/* Source: kernel/include/xs_base.h, xs_klist.h, xs_id.h, xs_sem.h; ILP32. */
typedef unsigned char uint8;
typedef unsigned short uint16;
typedef signed int int32;
typedef long x_base;
typedef unsigned long x_size_t;
typedef struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
} DoubleLinklistType;
struct IdNode { uint16 id; DoubleLinklistType link; };
struct IdManager { uint16 id_max; uint16 hoffset; uint8 *id_map; DoubleLinklistType *htable; };
struct Semaphore { struct IdNode id; uint16 value; DoubleLinklistType pend_list; DoubleLinklistType link; };
#define NONE ((void *)0)
#define ENOMEMORY 5
extern struct IdManager k_sem_id_manager;
extern DoubleLinklistType k_sem_list;
extern uint16 KTaskOsAssignLockNest;
#endif
