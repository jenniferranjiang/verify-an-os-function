#include "../include/slice_types.h"
#include "../include/logic.h"

/* TrustBase CONTAINER_OF model; pure address relation, no lifetime ownership. */
struct Event *CONTAINER_OF_EVENT_ID(struct IdNode *id_ptr)
/*@ With (event_ptr : addr)
    Require id_ptr == field_addr(event_ptr, struct Event, id) && emp
    Ensure __return == event_ptr && id_ptr == &(__return->id) && emp
 */;
