/* Exact field order and ILP32 ABI from authoritative xs_*.h. */
#ifndef FRESH_SEMAPHORE_TYPES_H
#define FRESH_SEMAPHORE_TYPES_H
typedef unsigned char uint8;
typedef unsigned short uint16;
typedef signed int int32;
typedef long x_base;
typedef unsigned long x_size_t;
#include <stddef.h>
typedef struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
} DoubleLinklistType;
struct IdNode { uint16 id; DoubleLinklistType link; };
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
#define RET_TRUE 1
#define ENOMEMORY 5
#endif
