#include "m_double_linklist.h"

/*@ include strategies "node_self_linked.strategies" */

/*@ Extern Coq
      (dll_nodes_nonzero : {A} -> list(DL_Node A) -> Prop)
      (dllseg_shift :
        {A} -> (Z -> A -> Assertion) -> Z -> Z ->
        list(DL_Node A) -> Assertion)
      (dllseg_shift_rev :
        {A} -> (Z -> A -> Assertion) -> Z -> Z ->
        list(DL_Node A) -> Assertion)
 */

/*
 * 直接验证 m_double_linklist.h 的既有多态成员删除接口；C 语句逐字对应原 double_link.c。
 * prefix/suffix 的 payload 保持抽象，仅暴露删除操作写入的四个指针槽。
 */
void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
/*@ remove_member */
{
    /*@ store_dll(storeA, head,
          app(prefix, cons(Build_DL_Node(a, linklist_node), suffix)))
        which implies
        exists previous next,
          head != 0 && linklist_node != 0 &&
          previous != 0 && next != 0 &&
          dll_nodes_nonzero(app(prefix, suffix)) &&
          dllseg_shift(storeA, head, previous, prefix) *
          store_ptr(field_addr(previous, struct SysDoubleLinklistNode, node_next), linklist_node) *
          (linklist_node->node_prev == previous) *
          (linklist_node->node_next == next) *
          store_ptr(field_addr(next, struct SysDoubleLinklistNode, node_prev), linklist_node) *
          dllseg_shift_rev(storeA, next, head, suffix) *
          storeA(linklist_node, a)
     */
    /*@ Given previous next */
    linklist_node->node_next->node_prev = linklist_node->node_prev;
    linklist_node->node_prev->node_next = linklist_node->node_next;

    linklist_node->node_next = linklist_node;
    linklist_node->node_prev = linklist_node;
    /*@ head != 0 &&
        dll_nodes_nonzero(app(prefix, suffix)) &&
        dllseg_shift(storeA, head, previous, prefix) *
        store_ptr(field_addr(previous, struct SysDoubleLinklistNode, node_next), next) *
        store_ptr(field_addr(next, struct SysDoubleLinklistNode, node_prev), previous) *
        dllseg_shift_rev(storeA, next, head, suffix)
        which implies
        store_dll(storeA, head, app(prefix, suffix))
     */
}
