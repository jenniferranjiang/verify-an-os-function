#include "../include/crtos_semaphore_layout.h"
#include "../include/semaphore_logic.h"

/* Primitive memory-shape contract; all unmentioned cells are framed. */


void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ With (head : Z)
    Require linklist_head == head && head != 0 &&
      undef_data_at(&(linklist_head->node_next), struct SysDoubleLinklistNode *) *
      undef_data_at(&(linklist_head->node_prev), struct SysDoubleLinklistNode *)
    Ensure
      store(&(linklist_head->node_next), struct SysDoubleLinklistNode *, head) *
      store(&(linklist_head->node_prev), struct SysDoubleLinklistNode *, head)
*/
{
    linklist_head->node_next = linklist_head;
    linklist_head->node_prev = linklist_head;
}
