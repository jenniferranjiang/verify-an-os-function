#include "../../annotated_C/include/slice_types.h"
#define OFF(T, f) __builtin_offsetof(T, f)
_Static_assert(sizeof(void *) == 4, "ILP32");
_Static_assert(sizeof(struct Event) == 36, "adapted Event size");
_Static_assert(OFF(struct Event,id) == 0, "id");
_Static_assert(OFF(struct Event,options) == 12, "options");
_Static_assert(OFF(struct Event,events) == 16, "events");
_Static_assert(OFF(struct Event,pend_list) == 20, "pend");
_Static_assert(OFF(struct Event,link) == 28, "link");
_Static_assert(sizeof(struct IdNode) == 12, "IdNode");
_Static_assert(OFF(struct IdNode,link) == 4, "id link");
_Static_assert(sizeof(struct IdManager) == 12, "manager");
