#ifndef CRTOS_SEMAPHORE_LAYOUT_H
#define CRTOS_SEMAPHORE_LAYOUT_H
/* Current Cortex-M3 ILP32 declarations, derived from xs_base.h, xs_klist.h,
 * xs_id.h and xs_sem.h. No executable code or module contracts here. */
typedef unsigned char uint8;
typedef unsigned short uint16;
typedef signed int int32;
typedef long x_base;
/* unsigned long and unsigned int have the same 32-bit size, alignment and
 * Cortex-M3 calling convention; approved x_size_t parser normalization. */
typedef unsigned int x_size_t;
typedef struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
} DoubleLinklistType;
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
#define NONE 0
#define ENOMEMORY 5
#endif
