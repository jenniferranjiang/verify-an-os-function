#include "m_double_linklist.h"

/*@ include strategies "node_self_linked.strategies" */

/*@ Import Coq Require Import CRTOS_Verify.libai.NodeSelfLinked */

/*@ Extern Coq
      (store_node_self_linked : Z -> Assertion)
 */

/**
 * This function will remove a node from the list.
 *
 * @param linklist_node the node needed to removed
 */
void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
/*@ remove_self */
{
    linklist_node->node_next->node_prev = linklist_node->node_prev;
    linklist_node->node_prev->node_next = linklist_node->node_next;

    linklist_node->node_next = linklist_node;
    linklist_node->node_prev = linklist_node;

    /*@ Assert
          linklist_node == node &&
          node != 0 &&
          store_node_self_linked(node)
     */
}
