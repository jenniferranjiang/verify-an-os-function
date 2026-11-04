#include "../../annotated_C/include/slice_types.h"
_Static_assert(sizeof(void *) == 4, "ILP32 pointers");
_Static_assert(sizeof(x_base) == 4, "ILP32 long");
_Static_assert(sizeof(struct IdNode) == 12, "IdNode size");
_Static_assert(sizeof(struct Mutex) == 36, "Mutex size");
_Static_assert(__builtin_offsetof(struct Mutex, id) == 0, "id offset");
_Static_assert(__builtin_offsetof(struct Mutex, id.link) == 4, "id link offset");
_Static_assert(__builtin_offsetof(struct Mutex, val) == 12, "val offset");
_Static_assert(__builtin_offsetof(struct Mutex, recursive_cnt) == 14, "recursive offset");
_Static_assert(__builtin_offsetof(struct Mutex, origin_prio) == 15, "priority offset");
_Static_assert(__builtin_offsetof(struct Mutex, holder) == 16, "holder offset");
_Static_assert(__builtin_offsetof(struct Mutex, pend_list) == 20, "pending offset");
_Static_assert(__builtin_offsetof(struct Mutex, link) == 28, "management link offset");
