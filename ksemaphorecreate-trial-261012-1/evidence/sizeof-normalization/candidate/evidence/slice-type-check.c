#include "spec-layout-check.c"
_Static_assert(__builtin_types_compatible_p(x_size_t, unsigned int), "slice x_size_t");
_Static_assert((x_size_t)-1 > 0, "slice size unsigned");
_Static_assert((x_size_t)sizeof(struct Semaphore)==(x_size_t)32, "slice argument equal");
