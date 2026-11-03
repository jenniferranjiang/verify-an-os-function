#include <xs_mutex.h>
#include <xs_memory.h>
#include "abi_assertions.h"
ASSERT(ID_NUM_MAX == 128);
ASSERT(ID_HTABLE_SIZE == 16);
ASSERT(ENOMEMORY == 5);
#ifdef ARCH_SMP
#error SMP is outside this experiment
#endif
#ifdef ARCH_CPU_64BIT
#error 64 bit is outside this experiment
#endif
void *allocation_alias(unsigned long n) { return KERNEL_MALLOC(n); }
void free_alias(void *p) { KERNEL_FREE(p); }
