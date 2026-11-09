#include "xs_event.h"
#define OFF(T,F) __builtin_offsetof(T,F)
_Static_assert(sizeof(void*) == 4, "ILP32");
_Static_assert(sizeof(struct Event) == 32, "event size");
_Static_assert(sizeof(struct IdNode) == 12, "idnode size");
_Static_assert(OFF(struct Event,id) == 0, "id");
_Static_assert(OFF(struct Event,pend_list) == 16, "pending");
_Static_assert(OFF(struct Event,link) == 24, "link");
_Static_assert(OFF(struct IdNode,link) == 4, "id link");
_Static_assert(sizeof(struct IdManager) == 12, "manager size");
_Static_assert(OFF(struct IdManager,id_map) == 4, "map");
_Static_assert(OFF(struct IdManager,htable) == 8, "table");
struct AdaptedEvent {struct IdNode id; uint32 options; uint32 events; DoubleLinklistType pend_list; DoubleLinklistType link;};
_Static_assert(sizeof(struct AdaptedEvent) == 36, "adapted size");
_Static_assert(OFF(struct AdaptedEvent,options) == 12, "adapted options");
_Static_assert(OFF(struct AdaptedEvent,events) == 16, "adapted events");
_Static_assert(OFF(struct AdaptedEvent,pend_list) == 20, "adapted pending");
_Static_assert(OFF(struct AdaptedEvent,link) == 28, "adapted link");
