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

int AllocId(struct IdManager *manager)
/*@ With (sidm: StableIdmanager) (idm: VarIdmanager)
    Require store_idmanager(sidm, idm, manager)
    Ensure (idmanager_first_free_id(sidm, idm) == Some(__return) &&
            __return < 65536 &&
            store_idmanager_allocated_unlinked(sidm, idm, manager, __return))
           ||
           (idmanager_first_free_id(sidm, idm) == None &&
            __return == -1 &&
            store_idmanager(sidm, idm, manager))
*/;

void InsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sidm: StableIdmanager) (idm: VarIdmanager) (id: Z)
    Require store_idmanager_allocated_unlinked(sidm, idm, manager, id) *
            store_idnode_unlinked(&(idnode->link), Build_IdNodeAbs(id, idnode))
    Ensure store_idmanager(sidm,
             idmanager_link(sidm, idmanager_add(idm, id), id, idnode), manager)
*/;

int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sidm: StableIdmanager) (idm: VarIdmanager)
    Require store_idmanager(sidm, idm, manager) *
            store_idnode_insert_ready(idnode)
    Ensure (__return == -1 &&
            idmanager_first_free_id(sidm, idm) == None &&
            store_idmanager(sidm, idm, manager) *
            store_idnode_insert_ready(idnode))
           ||
           (idmanager_min_free_id(sidm, idm, __return) &&
            store_idmanager(sidm,
              idmanager_link(sidm, idmanager_add(idm, __return), __return, idnode),
              manager))
*/
;

/*@ Extern Coq
  (store_idmanager_found :
    StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion)
*/

struct IdNode *GetObj(struct IdManager *manager, uint16 id)
/*@ With (sidm: StableIdmanager) (idm: VarIdmanager)
    Require 0 <= id && id < sidm.idmax && store_idmanager(sidm, idm, manager)
    Ensure (__return == 0 &&
            idmanager_query(idm, id) == false &&
            store_idmanager(sidm, idm, manager))
           ||
           (__return != 0 &&
            idmanager_query(idm, id) == true &&
            store_idmanager_found(sidm, idm, manager, __return, id))
*/
;

struct IdNode *IdGetObj(struct IdManager *manager, uint16 id)
/*@ With (sidm: StableIdmanager) (idm: VarIdmanager)
    Require 0 <= id && id < 65536 && store_idmanager(sidm, idm, manager)
    Ensure (manager == 0 &&
            __return == 0 &&
            store_idmanager(sidm, idm, manager))
           ||
           (manager != 0 &&
            __return == 0 &&
            idmanager_query(idm, id) == false &&
            store_idmanager(sidm, idm, manager))
           ||
           (manager != 0 &&
            __return != 0 &&
            idmanager_query(idm, id) == true &&
            store_idmanager_found(sidm, idm, manager, __return, id))
*/
;

/*@ Extern Coq
  (idmanager_remove : StableIdmanager -> VarIdmanager -> Z -> VarIdmanager)
  (store_idmanager_remove_ready :
    StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion)
  (store_idmanager_removeobj_post :
    StableIdmanager -> VarIdmanager -> addr -> addr -> Z -> Assertion)
  (UCharArray::full : Z -> Z -> list Z -> Assertion)
*/

void RemoveObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sidm: StableIdmanager) (idm: VarIdmanager) (id: Z)
    Require store_idmanager_remove_ready(sidm, idm, manager, idnode, id)
    Ensure store_idmanager_removeobj_post(sidm, idm, manager, idnode, id)
*/
;

void IdRemoveObj(struct IdManager *manager, uint16 id)
/*@ known_node
    With (sidm: StableIdmanager) (idm: VarIdmanager) (idnode: addr)
    Require manager != 0 &&
            0 <= id && id < 65536 &&
            idmanager_query(
              idmanager_link(sidm, idmanager_add(idm, id), id, idnode), id)
              == true &&
            store_idmanager(sidm,
              idmanager_link(sidm, idmanager_add(idm, id), id, idnode),
              manager)
    Ensure idnode != 0 &&
           &(idnode->link) != 0 &&
           store_idmanager(sidm,
             idmanager_remove(sidm,
               idmanager_link(sidm, idmanager_add(idm, id), id, idnode), id),
             manager) *
           (idnode->id == 65535) *
           store_node_self_linked(&(idnode->link))
*/
/*@ current_node
    With (sidm: StableIdmanager) (idm: VarIdmanager) (idnode: addr)
    Require manager != 0 &&
            0 <= id && id < 65536 &&
            store_idmanager_remove_ready(sidm, idm, manager, idnode, id)
    Ensure idnode != 0 &&
           &(idnode->link) != 0 &&
           store_idmanager_removeobj_post(sidm, idm, manager, idnode, id)
*/
;

/*@ Extern Coq
  (store_idnode : addr -> IdNodeAbs -> Assertion)
*/

#endif
