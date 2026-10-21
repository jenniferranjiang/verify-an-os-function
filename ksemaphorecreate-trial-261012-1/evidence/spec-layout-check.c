#include "../annotated_C/include/crtos_semaphore_layout.h"
#define OFF(t, f) __builtin_offsetof(t, f)
_Static_assert(sizeof(void *) == 4 && sizeof(int) == 4 && sizeof(long) == 4, "ILP32");
_Static_assert(sizeof(x_size_t) == 4 && sizeof(x_base) == 4 && sizeof(uint16) == 2, "typedef widths");
_Static_assert(sizeof(DoubleLinklistType) == 8, "link size");
_Static_assert(OFF(DoubleLinklistType,node_next) == 0 && OFF(DoubleLinklistType,node_prev) == 4, "link offsets");
_Static_assert(sizeof(struct IdNode) == 12 && OFF(struct IdNode,id) == 0 && OFF(struct IdNode,link) == 4, "id node layout");
_Static_assert(sizeof(struct IdManager) == 12, "manager size");
_Static_assert(OFF(struct IdManager,id_max) == 0 && OFF(struct IdManager,hoffset) == 2 && OFF(struct IdManager,id_map) == 4 && OFF(struct IdManager,htable) == 8, "manager offsets");
_Static_assert(sizeof(struct Semaphore) == 32, "semaphore size");
_Static_assert(OFF(struct Semaphore,id) == 0 && OFF(struct Semaphore,value) == 12 && OFF(struct Semaphore,pend_list) == 16 && OFF(struct Semaphore,link) == 24, "semaphore offsets");
