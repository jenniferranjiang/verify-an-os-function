#include <xs_event.h>
#include <xs_memory.h>
#define OFF(T, f) __builtin_offsetof(T, f)
_Static_assert(sizeof(void *) == 4, "ILP32");
_Static_assert(sizeof(struct IdNode) == 12, "IdNode size");
_Static_assert(OFF(struct IdNode, link) == 4, "IdNode link");
_Static_assert(sizeof(struct Event) == 32, "Event packed-bitfield size");
_Static_assert(OFF(struct Event, id) == 0, "Event id");
_Static_assert(OFF(struct Event, pend_list) == 16, "Event pend");
_Static_assert(OFF(struct Event, link) == 24, "Event link");
_Static_assert(sizeof(struct IdManager) == 12, "manager size");
_Static_assert(ID_NUM_MAX == 128 && ID_HTABLE_SIZE == 16, "ID config");
#ifdef ARCH_SMP
#error SMP outside experiment
#endif
#ifdef ARCH_CPU_64BIT
#error 64bit outside experiment
#endif
void *allocation_alias(unsigned long n) { return KERNEL_MALLOC(n); }
void free_alias(void *p) { KERNEL_FREE(p); }
