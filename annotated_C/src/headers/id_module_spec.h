#ifndef CRTOS_ID_MODULE_SPEC_H
#define CRTOS_ID_MODULE_SPEC_H

/* 直接包含本头文件时，先取得 C 类型和 QCP 模型声明；include guard
 * 同时允许 m_id.h 在声明完成后转导入本文件。 */
#include "m_id.h"

/* Contracts imported from ../crtosverify-id, branch idnode,
 * commit 12378745b310bfcefb150a6c0e5a5fbfdd95787c.
 * Predicate compatibility is checked by the accompanying audit.
 * With/Require/Ensure are unchanged. The provider proves the high-level
 * refinement; consumers import that contract without requesting it again.
 */
/*@ Import Coq Require Import CRTOS_Verify.lib.IdModuleSpec */
/*@ Extern Coq
  (idmanager_contains : StableIdmanager -> VarIdmanager -> Z -> Z -> Prop)
*/
/*@ Printing Coq Name idmanager_contains := CRTOS_Verify.lib.IdModuleSpec.idmanager_contains */

/* Source: annotated_C/src/id/AllocId.c */
int AllocId(struct IdManager *manager)
/*@ With (sm: StableIdmanager) (m: VarIdmanager)
    Require store_idmanager(sm, m, manager)
    Ensure (idmanager_first_free_id(sm, m) == Some(__return) &&
            __return < 65536 &&
            store_idmanager_allocated_unlinked(sm, m, manager, __return))
           ||
           (idmanager_first_free_id(sm, m) == None &&
            __return == -1 &&
            store_idmanager(sm, m, manager))
*/;

/* Source: annotated_C/src/id/FreeId.c */
void FreeId(struct IdManager *manager, uint16 id)
/*@ With (sm: StableIdmanager) (m: VarIdmanager) (idnode: addr)
    Require store_idmanager_found(sm, m, manager, idnode, id)
    Ensure store_idmanager_remove_ready(sm, m, manager, idnode, id)
*/;

/* Source: annotated_C/src/id/InsertObj.c */
void InsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sm: StableIdmanager) (m: VarIdmanager) (id: Z)
    Require store_idmanager_allocated_unlinked(sm, m, manager, id) *
            store_idnode_unlinked(&(idnode->link), Build_IdNodeAbs(id, idnode))
    Ensure store_idmanager(sm,
             idmanager_link(sm, idmanager_add(m, id), id, idnode), manager)
*/;

/* Source: annotated_C/src/id/RemoveObj.c */
void RemoveObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sm: StableIdmanager) (m: VarIdmanager) (id: Z)
    Require store_idmanager_remove_ready(sm, m, manager, idnode, id)
    Ensure store_idmanager_removeobj_post(sm, m, manager, idnode, id)
*/;

/* Source: annotated_C/src/id/GetObj.c */
struct IdNode *GetObj(struct IdManager *manager, uint16 id)
/*@ With (sm: StableIdmanager) (m: VarIdmanager)
    Require 0 <= id && id < sm.idmax && store_idmanager(sm, m, manager)
    Ensure (__return == 0 &&
            idmanager_query(m, id) == false &&
            store_idmanager(sm, m, manager))
           ||
           (__return != 0 &&
            idmanager_query(m, id) == true &&
            store_idmanager_found(sm, m, manager, __return, id))
*/;

/* Source: annotated_C/src/id/IdGetObj.c */
struct IdNode *IdGetObj(struct IdManager *manager, uint16 id)
/*@ With (sm: StableIdmanager) (m: VarIdmanager)
    Require 0 <= id && id < 65536 && store_idmanager(sm, m, manager)
    Ensure (manager == 0 &&
            __return == 0 &&
            store_idmanager(sm, m, manager))
           ||
           (manager != 0 &&
            __return == 0 &&
            idmanager_query(m, id) == false &&
            store_idmanager(sm, m, manager))
           ||
           (manager != 0 &&
            __return != 0 &&
            idmanager_query(m, id) == true &&
            store_idmanager_found(sm, m, manager, __return, id))
*/;

/* Source: annotated_C/src/id/IdInsertObj.c */
int IdInsertObj(struct IdManager *manager, struct IdNode *idnode)
/*@ With (sm: StableIdmanager) (m: VarIdmanager)
    Require store_idmanager(sm, m, manager) *
            store_idnode_insert_ready(idnode)
    Ensure (__return == -1 &&
            store_idmanager(sm, m, manager) *
            store_idnode_insert_ready(idnode))
           ||
           (idmanager_min_free_id(sm, m, __return) &&
            store_idmanager(sm,
              idmanager_link(sm, idmanager_add(m, __return), __return, idnode),
              manager))
*/;

/* Source: annotated_C/src/id/IdRemoveObj.c */
void IdRemoveObj(struct IdManager *manager, uint16 id)
/*@ high_level_spec
    With (sm: StableIdmanager) (m: VarIdmanager) (idnode: addr)
    Require manager != 0 &&
            0 <= id && id < 65536 &&
            idmanager_query(
              idmanager_link(sm, idmanager_add(m, id), id, idnode), id)
              == true &&
            store_idmanager(sm,
              idmanager_link(sm, idmanager_add(m, id), id, idnode),
              manager)
    Ensure idnode != 0 &&
           &(idnode->link) != 0 &&
           store_idmanager(sm,
             idmanager_remove(sm,
               idmanager_link(sm, idmanager_add(m, id), id, idnode), id),
             manager) *
           (idnode->id == 65535) *
           (idnode->link.node_prev == &(idnode->link)) *
           (idnode->link.node_next == &(idnode->link))
*/;

/* Source: annotated_C/src/id/IdRemoveObj.c */
void IdRemoveObj(struct IdManager *manager, uint16 id)
/*@ low_level_spec
    With (sm: StableIdmanager) (m: VarIdmanager)
    Require manager != 0 &&
            0 <= id && id < 65536 &&
            store_idmanager(sm, m, manager)
    Ensure (idmanager_query(m, id) == false &&
            store_idmanager(sm, m, manager))
           ||
           (exists idnode,
              idmanager_query(m, id) == true &&
              idmanager_contains(sm, m, id, idnode) &&
              idnode != 0 &&
              &(idnode->link) != 0 &&
              store_idmanager(sm, idmanager_remove(sm, m, id), manager) *
              (idnode->id == 65535) *
              (idnode->link.node_prev == &(idnode->link)) *
              (idnode->link.node_next == &(idnode->link)))
*/;

#endif
