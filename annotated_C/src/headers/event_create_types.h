#ifndef CRTOS_EVENT_CREATE_TYPES_H
#define CRTOS_EVENT_CREATE_TYPES_H
/* ILP32 non-SMP slice. Full layouts of every accessed struct are retained.
 * Origin: kernel/include/xs_{base,klist,id,event}.h and configured xsconfig.h. */
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
/* TrustBase bitfield adaptation: original options:3/events:29 occupy one
 * uint32; here each has a separate uint32 cell. Assignment must preserve
 * truncation. Model offsets id=0/options=12/events=16/pend=20/link=28,size=36;
 * authoritative ILP32 offsets pend=16/link=24,size=32. */
struct Event {
    struct IdNode id;
    uint32 options;
    uint32 events;
    DoubleLinklistType pend_list;
    DoubleLinklistType link;
};
#define NONE ((void *)0)
#define ENOMEMORY 5
#define UINT_MAX 4294967295U
#define ALIGN_SIZE 4
#define ID_NUM_MAX 128
#define ID_HTABLE_SIZE 16
#define KERNEL_EVENT
extern struct IdManager k_event_id_manager;
extern DoubleLinklistType k_event_list;
#endif
