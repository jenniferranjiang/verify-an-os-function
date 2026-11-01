#include "../include/slice_types.h"
#include "../include/logic.h"

/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/double_link.c. Current 32-bit non-SMP configuration. */


void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ Require
      undef_data_at(&(linklist_head->node_prev)) *
      undef_data_at(&(linklist_head->node_next))
    Ensure
      linklist_head != 0 && store_node_self_linked(linklist_head)
 */
{
    linklist_head->node_next = linklist_head;
    linklist_head->node_prev = linklist_head;
}
