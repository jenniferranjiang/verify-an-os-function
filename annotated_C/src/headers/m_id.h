#ifndef XS_ID_H
#define XS_ID_H

#include "xs_klist.h"

struct IdNode
{
    uint16 id;
    DoubleLinklistType link;
};

struct IdManager
{
    uint16 id_max;
    uint16 hoffset;
    uint8 *id_map;
    DoubleLinklistType *htable;
};

#define DECLARE_ID_MANAGER(_name, _id_max) \
uint8 __id_map_##_name[((_id_max) + 7) / 8]; \
DoubleLinklistType __htable_##_name[(_id_max) < ID_HTABLE_SIZE ? (_id_max) : ID_HTABLE_SIZE]; \
struct IdManager _name = { \
    .id_max = _id_max, \
    .hoffset = (_id_max) < ID_HTABLE_SIZE ? (_id_max) : ID_HTABLE_SIZE, \
    .id_map = __id_map_##_name, \
    .htable = __htable_##_name \
};

/*@ Import Coq Require Import CRTOS_Verify.lib.idnode */
/*@ Import Coq Require Import CRTOS_Verify.lib.CrtosRules */
/*@ Import Coq Import IDNode */

/*@ Extern Coq (unit :: *) */
/*@ Extern Coq (tt : unit) */
/*@ Extern Coq (true: bool)
               (false: bool) */
/*@ Extern Coq Record IdNodeAbs {
  idnode_id: Z;
  idnode_addr: addr;
} */

/*@ Extern Coq
  (Build_IdNodeAbs: Z -> addr -> IdNodeAbs)
*/

/*@ Extern Coq Record StableIdmanager {
  idmax: Z;
  hoffset: Z;
  id_map: addr;
  htable: addr;
} */

/*@ Extern Coq Record VarIdmanager {
  idlist: list(Z);
  idbuckets: list(list(IdNodeAbs));
} */

/*@ Extern Coq
  (idmanager_add : VarIdmanager -> Z -> VarIdmanager)
  (idmanager_link : StableIdmanager -> VarIdmanager -> Z -> addr -> VarIdmanager)
  (idmanager_min_free_id : StableIdmanager -> VarIdmanager -> Z -> Prop)
  (idmanager_first_free_id : StableIdmanager -> VarIdmanager -> option Z)
  (idmanager_query : VarIdmanager -> Z -> bool)
  (idbuckets_ok :
    Z -> Z -> list(Z) -> list(list(IdNodeAbs)) -> Prop)
  (store_idnode_insert_ready : addr -> Assertion)
  (store_idmanager : StableIdmanager -> VarIdmanager -> addr -> Assertion)
  (store_idmanager_allocated_unlinked :
    StableIdmanager -> VarIdmanager -> addr -> Z -> Assertion)
  (store_idnode_unlinked: addr -> IdNodeAbs -> Assertion)
  (store_idnodes: addr -> list IdNodeAbs -> Assertion)
*/

/* Shared address-aware model declarations. The authoritative idnode-branch
 * function contracts are included below, with predicate compatibility audited. */
/*@ Extern Coq
  (store_idmanager_found :
    StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion)
  (idmanager_remove : StableIdmanager -> VarIdmanager -> Z -> VarIdmanager)
  (store_idmanager_remove_ready :
    StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion)
  (store_idmanager_removeobj_post :
    StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion)
  (store_idnode : addr -> IdNodeAbs -> Assertion)
  (UCharArray::full : Z -> Z -> list Z -> Assertion)
*/

#include "id_module_spec.h"

#endif
