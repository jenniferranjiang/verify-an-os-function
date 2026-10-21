#include "../../../source-abi.c"
#include <stddef.h>
#include <xs_memory.h>
_Static_assert(__builtin_types_compatible_p(x_size_t, unsigned long), "authoritative x_size_t");
_Static_assert(sizeof(size_t)==4 && (size_t)-1>0, "size_t unsigned32");
_Static_assert(__builtin_types_compatible_p(__typeof__(sizeof(struct Semaphore)), size_t), "sizeof returns size_t");
_Static_assert((x_size_t)sizeof(struct Semaphore)==(x_size_t)32, "malloc converted argument equal");
_Static_assert((size_t)sizeof(struct Semaphore)==(size_t)(x_size_t)32, "memset converted argument equal");
_Static_assert(__builtin_types_compatible_p(__typeof__(&x_malloc), void *(*)(x_size_t)), "malloc prototype");
/* memset prototype is recorded from authoritative TU preprocessing; no local replacement declaration. */
