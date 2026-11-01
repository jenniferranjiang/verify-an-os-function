typedef unsigned short uint16;
typedef struct SysDoubleLinklistNode {
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
} DoubleLinklistType;
struct IdNode { uint16 id; DoubleLinklistType link; };
struct Semaphore {
    struct IdNode id;
    uint16 value;
    DoubleLinklistType pend_list;
    DoubleLinklistType link;
};

_Static_assert(sizeof(void *) == 4, "approved ABI requires 32-bit pointers");
_Static_assert(sizeof(struct Semaphore) == 32,
               "Semaphore ABI drifted from the reviewed layout");
