#ifndef CRTOS_MUTEX_CREATE_TYPES_H
#define CRTOS_MUTEX_CREATE_TYPES_H
/* ILP32 non-SMP slice. Full layouts of every accessed struct are retained.
 * Origin: kernel/include/xs_{base,klist,id,mutex}.h and configured xsconfig.h. */
typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;
typedef int int32;
typedef long x_base;
typedef unsigned long x_size_t;
typedef unsigned long size_t;
struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
};
typedef struct SysDoubleLinklistNode DoubleLinklistType;
struct IdNode { uint16 id; DoubleLinklistType link; };
struct IdManager {
    uint16 id_max;
    uint16 hoffset;
    uint8 *id_map;
    DoubleLinklistType *htable;
};
struct TaskDescriptor;
struct Mutex {
    struct IdNode id;
    uint16 val;
    uint8 recursive_cnt;
    uint8 origin_prio;
    struct TaskDescriptor *holder;
    DoubleLinklistType pend_list;
    DoubleLinklistType link;
};
#define NONE ((void *)0)
#define ENOMEMORY 5
#define UINT_MAX 4294967295U
#define ALIGN_SIZE 4
#define ID_NUM_MAX 128
#define ID_HTABLE_SIZE 16
#define KERNEL_MUTEX
extern struct IdManager k_mutex_id_manager;
extern DoubleLinklistType k_mutex_list;
#endif
