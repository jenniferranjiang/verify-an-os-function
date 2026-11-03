#include "../include/slice_types.h"
#include "../include/logic.h"

/* TrustBase KERNEL_FREE boundary, instantiated for this complete allocation.
 * EventRaw owns every model byte; conversion to raw allocation bytes is a
 * separately recorded, unproved design obligation in EventInv. */
void x_free(void *ptr)
/*@ event_object
    Require EventRaw(ptr)
    Ensure emp
 */;
