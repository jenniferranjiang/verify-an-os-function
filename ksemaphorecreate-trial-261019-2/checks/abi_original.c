#include <xs_sem.h>
#include "abi_assertions.h"
DECLARE_ID_MANAGER(abi_k_sem_id_manager, ID_NUM_MAX);
ABI_ASSERT(sizeof(__id_map_abi_k_sem_id_manager) == 16);
ABI_ASSERT(sizeof(__htable_abi_k_sem_id_manager) == 128);
ABI_ASSERT(ID_HTABLE_SIZE == 16);
ABI_ASSERT(ID_NUM_MAX == 128);
#ifdef ARCH_SMP
#error non-SMP configuration required
#endif
