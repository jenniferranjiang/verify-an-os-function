#include "../include/crtos_semaphore_layout.h"
#include "../include/semaphore_logic.h"

/* Primitive memory-shape contract; all unmentioned cells are framed. */


void DoubleLinkListInsertNodeAfter(DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ With (successor : Z) (previous : Z)
    Require linklist != 0 && linklist_node != 0 && successor != 0 &&
      store(&(linklist->node_next), struct SysDoubleLinklistNode *, successor) *
      store(&(((struct SysDoubleLinklistNode *)successor)->node_prev), struct SysDoubleLinklistNode *, previous) *
      undef_data_at(&(linklist_node->node_next), struct SysDoubleLinklistNode *) *
      undef_data_at(&(linklist_node->node_prev), struct SysDoubleLinklistNode *)
    Ensure
      store(&(linklist->node_next), struct SysDoubleLinklistNode *, linklist_node) *
      store(&(((struct SysDoubleLinklistNode *)successor)->node_prev), struct SysDoubleLinklistNode *, linklist_node) *
      store(&(linklist_node->node_next), struct SysDoubleLinklistNode *, successor) *
      store(&(linklist_node->node_prev), struct SysDoubleLinklistNode *, linklist)
*/
{
    linklist->node_next->node_prev = linklist_node;
    linklist_node->node_next = linklist->node_next;

    linklist->node_next = linklist_node;
    linklist_node->node_prev = linklist;
}
