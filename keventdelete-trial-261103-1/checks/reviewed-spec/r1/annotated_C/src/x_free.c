#include "../include/slice_types.h"
#include "../include/logic.h"

/* Trusted KERNEL_FREE/x_free boundary under TrustBase; owns the complete
 * detached Event allocation, including padding. Not a new implementation proof. */
void x_free(void *ptr)
/*@ Require EventRaw(ptr)
    Ensure emp
 */;
