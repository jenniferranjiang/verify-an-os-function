#include "../verification_stdlib.h"
#include "../verification_list.h"
#include "../los_sortlink_0.h"

static inline void LOS_ListAdd(LOS_DL_LIST *list, LOS_DL_LIST *node)
/*@ high_level_spec <= low_level_spec
    With {A} (storeA1: Z -> A -> Assertion) (l: list(DL_Node A)) (a: A)
    Require exists pu un,
            data_at(field_addr(node,struct LOS_DL_LIST,pstPrev),struct LOS_DL_LIST *,pu) *
            data_at(field_addr(node,struct LOS_DL_LIST,pstNext),struct LOS_DL_LIST *,un) *
            storeA1(node,a) *
            store_dll(storeA1,list,l)
    Ensure store_dll(storeA1,list,cons(Build_DL_Node(a, node), l))
*/
;
 static inline void LOS_ListAdd(LOS_DL_LIST *list, LOS_DL_LIST *node)
/*@ low_level_spec
    With {A} (storeA: Z -> A -> Assertion) (a: A) (list_pstNext:addr)
    Require exists pu un,
            data_at(field_addr(node,struct LOS_DL_LIST,pstPrev),struct LOS_DL_LIST *,pu) *
            data_at(field_addr(node,struct LOS_DL_LIST,pstNext),struct LOS_DL_LIST *,un) *
            storeA(node,a) *
            data_at(field_addr(list,struct LOS_DL_LIST,pstNext),struct LOS_DL_LIST *,list_pstNext) *
            data_at(field_addr(list_pstNext,struct LOS_DL_LIST,pstPrev),struct LOS_DL_LIST *,list)
    Ensure  data_at(field_addr(list_pstNext,struct LOS_DL_LIST,pstPrev),struct LOS_DL_LIST *,node) *
            data_at(field_addr(node,struct LOS_DL_LIST,pstNext),struct LOS_DL_LIST *,list_pstNext) *
            dllseg_shift(storeA,list,node,cons(Build_DL_Node(a, node), nil()))
*/
{
    node->pstNext = list->pstNext;
    node->pstPrev = list;
    list->pstNext->pstPrev = node;
    list->pstNext = node;
}

static inline void LOS_ListTailInsert(LOS_DL_LIST *list, LOS_DL_LIST *node)
/*@ With {A} (storeA: Z -> A -> Assertion) (l: list(DL_Node A))(a: A)
    Require exists pu un,
            data_at(field_addr(node,struct LOS_DL_LIST,pstPrev),struct LOS_DL_LIST *,pu) *
            data_at(field_addr(node,struct LOS_DL_LIST,pstNext),struct LOS_DL_LIST *,un) *
            storeA(node,a) *
            store_dll(storeA,list,l)
    Ensure store_dll(storeA,list,app(l,cons(Build_DL_Node(a, node), nil)))
*/
{
    /*@ store_dll(storeA,list,l)
        which implies
        exists list_pstPrev,
        data_at(field_addr(list_pstPrev,struct LOS_DL_LIST,pstNext),struct LOS_DL_LIST *,list) *
        data_at(field_addr(list,struct LOS_DL_LIST,pstPrev),struct LOS_DL_LIST *,list_pstPrev) *
        dllseg_shift(storeA,list,list_pstPrev,l)
    */
    LOS_ListAdd(list->pstPrev, node) /*@ where (low_level_spec) storeA = storeA , a = a , list_pstNext = list ; A = A */;
}


static inline void LOS_ListHeadInsert(LOS_DL_LIST *list, LOS_DL_LIST *node)
/*@ With {A} (a: A) (storeA: Z -> A -> Assertion) (l: list(DL_Node A))
    Require exists pu un,
            data_at(field_addr(node,struct LOS_DL_LIST,pstPrev),struct LOS_DL_LIST *,pu) *
            data_at(field_addr(node,struct LOS_DL_LIST,pstNext),struct LOS_DL_LIST *,un) *
            storeA(node, a) *
            store_dll(storeA,list,l)
    Ensure store_dll(storeA,list,cons(Build_DL_Node(a, node), l))
*/
{   
    LOS_ListAdd(list, node)/*@ where (high_level_spec) storeA1 = storeA , a = a , l = l ; A = A */; 
}
