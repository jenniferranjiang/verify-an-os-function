#include "../../../annotated_C/include/crtos_semaphore_layout.h"
/* Native ILP32 check only. The saved ARM probe supplies Cortex-M3 evidence. */
_Static_assert(sizeof(struct Semaphore) == 32, "fixed complete object");
_Static_assert(sizeof(x_size_t) == 4, "normalized parameter width");
_Static_assert((x_size_t)-1 > 0, "normalized parameter unsigned");
_Static_assert(__builtin_constant_p(sizeof(struct Semaphore)), "non-VLA constant");
_Static_assert((x_size_t)sizeof(struct Semaphore) == (x_size_t)32,
               "same converted actual argument");
_Static_assert((unsigned long)sizeof(struct Semaphore) == (unsigned long)32,
               "same original x_size_t actual argument");
