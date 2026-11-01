#include "../include/slice_types.h"
#include "../include/logic.h"

/* TrustBase primitive boundary; no implementation claim. */
void x_free(void *ptr)
/*@ mutex_object
    Require MutexRaw(ptr)
    Ensure emp
 */;
