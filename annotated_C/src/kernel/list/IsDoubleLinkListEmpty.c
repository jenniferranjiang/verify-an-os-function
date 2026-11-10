#include "m_double_linklist.h"

/* Source: /home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro/kernel/thread/double_link.c. Current 32-bit non-SMP configuration. */


int IsDoubleLinkListEmpty(const DoubleLinklistType *linklist)
/*@ dll
    With {A} (storeA : Z -> A -> Assertion)
             (nodes : list(DL_Node A))
    Require
      store_dll(storeA, linklist, nodes)
    Ensure
      ((__return == 1 && nodes == nil) ||
       (__return == 0 && nodes != nil)) &&
      store_dll(storeA, linklist, nodes)
 */
{
    return linklist->node_next == linklist;
}
