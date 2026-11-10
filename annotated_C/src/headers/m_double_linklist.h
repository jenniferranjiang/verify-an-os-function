#ifndef M_DOUBLE_LINKLIST_H
#define M_DOUBLE_LINKLIST_H

#include "xs_base.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct SysDoubleLinklistNode
{
    struct SysDoubleLinklistNode *node_next;
    struct SysDoubleLinklistNode *node_prev;
} DoubleLinklistType;

/* OS-independent, polymorphic doubly linked-list verification interface. */
/*@ Import Coq Require Import CRTOS_Verify.lib.common.dll */
/*@ Import Coq Require Import CRTOS_Verify.lib.common.CrtosRules */
/*@ Import Coq Require Import CRTOS_Verify.lib.list.DoubleLinkListSpec */
/*@ Import Coq Require Import CRTOS_Verify.lib.list.NodeSelfLinked */
/*@ Import Coq Import DLL */

/*@ Extern Coq addr := Z */
/*@ Extern Coq (DL_Node :: * => *) */
/*@ Extern Coq
      (Build_DL_Node : {A} -> A -> Z -> DL_Node A)
      (store_dll :
        {A} -> (Z -> A -> Assertion) ->
        Z -> list(DL_Node A) -> Assertion)
      (nil : {A} -> list A)
      (cons : {A} -> A -> list A -> list A)
      (app : {A} -> list A -> list A -> list A)
      (occupy_dll_node : Z -> Assertion)
      (store_node_self_linked : Z -> Assertion)
      (dll_insert_anchor :
        {A} -> Z -> list(DL_Node A) -> Z -> Prop)
      (dll_insert_before_dispatch :
        {A} -> Z -> list(DL_Node A) -> Z -> DL_Node A ->
        list(DL_Node A))
      (dll_insert_after_dispatch :
        {A} -> Z -> list(DL_Node A) -> Z -> DL_Node A ->
        list(DL_Node A))
 */

void InitDoubleLinkList(DoubleLinklistType *linklist_head)
/*@ Require
      undef_data_at(&(linklist_head->node_prev)) *
      undef_data_at(&(linklist_head->node_next))
    Ensure
      linklist_head != 0 && store_node_self_linked(linklist_head)
 */
;

void DoubleLinkListInsertNodeBefore(
  DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ dispatch_case
    With {A} (storeA: Z -> A -> Assertion)
             (head: Z) (nodes: list(DL_Node A)) (inserted_data: A)
    Require dll_insert_anchor(head, nodes, linklist) &&
            linklist_node != 0 &&
            store_dll(storeA, head, nodes) *
            storeA(linklist_node, inserted_data) *
            occupy_dll_node(linklist_node)
    Ensure store_dll(
             storeA, head,
             dll_insert_before_dispatch(
               head, nodes, linklist,
               Build_DL_Node(inserted_data, linklist_node)))
*/
;

void DoubleLinkListInsertNodeAfter(
  DoubleLinklistType *linklist, DoubleLinklistType *linklist_node)
/*@ dispatch_case
    With {A} (storeA: addr -> A -> Assertion)
             (nodes: list(DL_Node A)) (a: A) (head: addr)
    Require dll_insert_anchor(head, nodes, linklist) &&
            linklist_node != 0 &&
            store_dll(storeA, head, nodes) *
            storeA(linklist_node, a) *
            occupy_dll_node(linklist_node)
    Ensure store_dll(
             storeA, head,
             dll_insert_after_dispatch(
               head, nodes, linklist,
               Build_DL_Node(a, linklist_node)))
*/
;

void DoubleLinkListRmNode(DoubleLinklistType *linklist_node)
/*@ remove_self
    With (node : Z)
    Require linklist_node == node && node != 0 &&
            store_node_self_linked(node)
    Ensure store_node_self_linked(node)
 */
/*@ remove_member
    With {A} (storeA: addr -> A -> Assertion)
             (head: addr) (a: A)
             (prefix: list(DL_Node A))
             (suffix: list(DL_Node A))
    Require store_dll(storeA, head,
              app(prefix, cons(Build_DL_Node(a, linklist_node), suffix)))
    Ensure store_dll(storeA, head, app(prefix, suffix)) *
           storeA(linklist_node, a) *
           store_node_self_linked(linklist_node)
*/
/*@ remove_from_head
    With {A} (storeA: addr -> A -> Assertion)
             (head: addr) (a: A)
             (suffix: list(DL_Node A))
    Require linklist_node != 0 &&
            store_dll(storeA, head,
              cons(Build_DL_Node(a, linklist_node), suffix))
    Ensure store_dll(storeA, head, suffix) *
           storeA(linklist_node, a) *
           store_node_self_linked(linklist_node)
*/
;

int IsDoubleLinkListEmpty(const DoubleLinklistType *linklist)
/*@ dll
    With {A} (storeA : Z -> A -> Assertion)
             (nodes : list(DL_Node A))
    Require store_dll(storeA, linklist, nodes)
    Ensure
      ((__return == 1 && nodes == nil) ||
       (__return == 0 && nodes != nil)) &&
      store_dll(storeA, linklist, nodes)
 */
;

struct SysDoubleLinklistNode *DoubleLinkListGetHead(
  const DoubleLinklistType *linklist);
struct SysDoubleLinklistNode *DoubleLinkListGetNext(
  const DoubleLinklistType *linklist,
  const struct SysDoubleLinklistNode *linklist_node);
unsigned int DoubleLinkListLenGet(const DoubleLinklistType *linklist);

#ifdef __cplusplus
}
#endif

#endif
