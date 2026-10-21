Require Import Coq.ZArith.ZArith.
Require Import Coq.Bool.Bool.
Require Import Coq.Strings.String.
Require Import Coq.Strings.Ascii.
Require Import Coq.Lists.List.
Require Import Coq.Classes.RelationClasses.
Require Import Coq.Classes.Morphisms.
Require Import Coq.micromega.Psatz.
Require Import Coq.Sorting.Permutation.
From AUXLib Require Import int_auto Axioms Feq Idents ListLib VMap.
Require Import SetsClass.SetsClass. Import SetsNotation.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Local Open Scope Z_scope.
Local Open Scope sets.
Local Open Scope string_scope.
Local Open Scope list.
Require Import CRTOS_Verify.lib.idnode.
Require Import CRTOS_Verify.sem.SemaphorePure.
Require Import CRTOS_Verify.sem.SemaphoreRep.
Require Import CRTOS_Verify.sem.CrtosOSPure.
Require Import CRTOS_Verify.sem.CrtosOSProtocol.
Require Import CRTOS_Verify.sem.CrtosOSInv.
Require Import CRTOS_Verify.sem.SemaphoreCritical.
Require Import CRTOS_Verify.sem.SemaphoreCriticalViews.
Import IDNode.
Import Crtos_C_Rules.
Local Open Scope sac.

(*----- Function InsertObj -----*)

Definition InsertObj_safety_wit_1 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (PreH1 : (manager_pre <> 0)) (PreH2 : (idnode_pre <> 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (id)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (id) (previous) (next)) )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition InsertObj_safety_wit_2 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (PreH1 : (manager_pre = 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (idnode_pre <> 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (id)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (id) (previous) (next)) )
|--
  “ False ”
.

Definition InsertObj_safety_wit_3 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (PreH1 : (manager_pre <> 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (idnode_pre <> 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (id)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (id) (previous) (next)) )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition InsertObj_safety_wit_4 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (PreH1 : (manager_pre <> 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (idnode_pre <> 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (id)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (id) (previous) (next)) )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition InsertObj_safety_wit_5 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (PreH1 : (idnode_pre = 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (manager_pre <> 0)) (PreH4 : (idnode_pre <> 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (id)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (id) (previous) (next)) )
|--
  “ False ”
.

Definition InsertObj_safety_wit_6 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (PreH1 : (idnode_pre <> 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (manager_pre <> 0)) (PreH4 : (idnode_pre <> 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (id)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (id) (previous) (next)) )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition InsertObj_safety_wit_7 := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (PreH1 : (manager_pre <> 0)) (PreH2 : (idnode_pre <> 0)) (PreH3 : (idmanager_min_free_id sm before id )) (PreH4 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH5 : (0 <= id)) (PreH6 : (id <= 65535)) (PreH7 : (0 < (hoffset (sm)))) (PreH8 : ((hoffset (sm)) <= 65535)) ,
  ((( &( "head" ) )) # Ptr  |->_)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ ((id <> (INT_MIN)) \/ ((hoffset (sm)) <> (-1))) ” 
  &&  “ ((hoffset (sm)) <> 0) ”
.

Definition InsertObj_safety_wit_8 := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (bucket: (@list IdNodeAbs)) (hp: Z) (hn: Z) (head: Z) (PreH1 : (head = ((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ) ) ))) (PreH2 : (head <> 0)) (PreH3 : (bucket = (Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs))))) (PreH4 : (manager_pre <> 0)) (PreH5 : (idnode_pre <> 0)) (PreH6 : (idmanager_min_free_id sm before id )) (PreH7 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH8 : (0 <= id)) (PreH9 : (id <= 65535)) (PreH10 : (0 < (hoffset (sm)))) (PreH11 : ((hoffset (sm)) <= 65535)) (PreH12 : (hp <> 0)) (PreH13 : (hn <> 0)) (PreH14 : (idnodes_nonzero bucket )) ,
  ((( &( "head" ) )) # Ptr  |-> head)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) (bucket) ((idbuckets (before)))) )
  **  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> hp)
  **  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> hn)
  **  (OSHeap (idnodes_dllseg (hn) (head) (head) (hp) (bucket)) )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition InsertObj_safety_wit_9 := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (bucket: (@list IdNodeAbs)) (head: Z) (PreH1 : (head = ((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ) ) ))) (PreH2 : (head <> 0)) (PreH3 : (bucket = (Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs))))) (PreH4 : (manager_pre <> 0)) (PreH5 : (idnode_pre <> 0)) (PreH6 : (idmanager_min_free_id sm before id )) (PreH7 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH8 : (0 <= id)) (PreH9 : (id <= 65535)) (PreH10 : (0 < (hoffset (sm)))) (PreH11 : ((hoffset (sm)) <= 65535)) (PreH12 : (bucket = (@nil IdNodeAbs))) ,
  ((( &( "head" ) )) # Ptr  |-> head)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) (bucket) ((idbuckets (before)))) )
  **  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> 0)
  **  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> 0)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition InsertObj_safety_wit_10 := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (bucket: (@list IdNodeAbs)) (hp: Z) (hn: Z) (head: Z) (PreH1 : (hp = 0)) (PreH2 : (head = ((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ) ) ))) (PreH3 : (head <> 0)) (PreH4 : (bucket = (Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs))))) (PreH5 : (manager_pre <> 0)) (PreH6 : (idnode_pre <> 0)) (PreH7 : (idmanager_min_free_id sm before id )) (PreH8 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH9 : (0 <= id)) (PreH10 : (id <= 65535)) (PreH11 : (0 < (hoffset (sm)))) (PreH12 : ((hoffset (sm)) <= 65535)) (PreH13 : (hp <> 0)) (PreH14 : (hn <> 0)) (PreH15 : (idnodes_nonzero bucket )) ,
  ((( &( "head" ) )) # Ptr  |-> head)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) (bucket) ((idbuckets (before)))) )
  **  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> hp)
  **  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> hn)
  **  (OSHeap (idnodes_dllseg (hn) (head) (head) (hp) (bucket)) )
|--
  “ False ”
.

Definition InsertObj_entail_wit_1 := 
(
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (PreH1 : (idnode_pre <> 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (manager_pre <> 0)) (PreH4 : (idnode_pre <> 0)) ,
  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (id)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (id) (previous) (next)) )
|--
  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (idmanager_min_free_id sm before id ) ” 
  &&  “ (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) ) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id <= 65535) ” 
  &&  “ (0 < (hoffset (sm))) ” 
  &&  “ ((hoffset (sm)) <= 65535) ”
  &&  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
) \/
(
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (PreH1 : (idnode_pre <> 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (manager_pre <> 0)) (PreH4 : (idnode_pre <> 0)) ,
  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (id)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (id) (previous) (next)) )
|--
  EX (x_2: Z)  (x: Z) ,
  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (idmanager_min_free_id sm before id ) ” 
  &&  “ (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) ) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id <= 65535) ” 
  &&  “ (0 < (hoffset (sm))) ” 
  &&  “ ((hoffset (sm)) <= 65535) ”
  &&  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> x_2)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> x)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
).

Definition InsertObj_entail_wit_2 := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (PreH1 : (manager_pre <> 0)) (PreH2 : (idnode_pre <> 0)) (PreH3 : (idmanager_min_free_id sm before id )) (PreH4 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH5 : (0 <= id)) (PreH6 : (id <= 65535)) (PreH7 : (0 < (hoffset (sm)))) (PreH8 : ((hoffset (sm)) <= 65535)) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  (EX (bucket: (@list IdNodeAbs)) ,
  “ (((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ))) = ((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ) ) )) ” 
  &&  “ (((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0) ” 
  &&  “ (bucket = (Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs)))) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (idmanager_min_free_id sm before id ) ” 
  &&  “ (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) ) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id <= 65535) ” 
  &&  “ (0 < (hoffset (sm))) ” 
  &&  “ ((hoffset (sm)) <= 65535) ” 
  &&  “ (bucket = (@nil IdNodeAbs)) ”
  &&  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) (bucket) ((idbuckets (before)))) )
  **  ((&((((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ))))  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> 0)
  **  ((&((((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ))))  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> 0))
  ||
  (EX (hn: Z)  (hp: Z)  (bucket: (@list IdNodeAbs)) ,
  “ (((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ))) = ((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ) ) )) ” 
  &&  “ (((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0) ” 
  &&  “ (bucket = (Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs)))) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (idmanager_min_free_id sm before id ) ” 
  &&  “ (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) ) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id <= 65535) ” 
  &&  “ (0 < (hoffset (sm))) ” 
  &&  “ ((hoffset (sm)) <= 65535) ” 
  &&  “ (hp <> 0) ” 
  &&  “ (hn <> 0) ” 
  &&  “ (idnodes_nonzero bucket ) ”
  &&  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) (bucket) ((idbuckets (before)))) )
  **  ((&((((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ))))  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> hp)
  **  ((&((((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ))))  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> hn)
  **  (OSHeap (idnodes_dllseg (hn) (((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" )))) (((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" )))) (hp) (bucket)) ))
.

Definition InsertObj_entail_wit_3_1 := 
(
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (bucket_2: (@list IdNodeAbs)) (head: Z) (PreH1 : (head = ((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ) ) ))) (PreH2 : (head <> 0)) (PreH3 : (bucket_2 = (Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs))))) (PreH4 : (manager_pre <> 0)) (PreH5 : (idnode_pre <> 0)) (PreH6 : (idmanager_min_free_id sm before id )) (PreH7 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH8 : (0 <= id)) (PreH9 : (id <= 65535)) (PreH10 : (0 < (hoffset (sm)))) (PreH11 : ((hoffset (sm)) <= 65535)) (PreH12 : (bucket_2 = (@nil IdNodeAbs))) ,
  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> head)
  **  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> head)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) (bucket_2) ((idbuckets (before)))) )
|--
  EX (bucket: (@list IdNodeAbs))  (successor: Z) ,
  “ (head = ((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ) ) )) ” 
  &&  “ (head <> 0) ” 
  &&  “ (successor <> 0) ” 
  &&  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ” 
  &&  “ (bucket = (Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs)))) ” 
  &&  “ (idnodes_nonzero bucket ) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (idmanager_min_free_id sm before id ) ” 
  &&  “ (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) ) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id <= 65535) ” 
  &&  “ (0 < (hoffset (sm))) ” 
  &&  “ ((hoffset (sm)) <= 65535) ”
  &&  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) (bucket) ((idbuckets (before)))) )
  **  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> successor)
  **  ((&((successor)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> head)
  **  (OSHeap (DLL.dllseg_shift_rev (store_idnode) (successor) (head) ((idnodes_to_dll (bucket)))) )
) \/
(
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (bucket_2: (@list IdNodeAbs)) (head: Z) (PreH1 : (head = ((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ) ) ))) (PreH2 : (head <> 0)) (PreH3 : (bucket_2 = (Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs))))) (PreH4 : (manager_pre <> 0)) (PreH5 : (idnode_pre <> 0)) (PreH6 : (idmanager_min_free_id sm before id )) (PreH7 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH8 : (0 <= id)) (PreH9 : (id <= 65535)) (PreH10 : (0 < (hoffset (sm)))) (PreH11 : ((hoffset (sm)) <= 65535)) (PreH12 : (bucket_2 = (@nil IdNodeAbs))) ,
  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) (bucket_2) ((idbuckets (before)))) )
|--
  “ (idnodes_nonzero bucket_2 ) ” 
  &&  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ”
  &&  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) ((Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs)))) ((idbuckets (before)))) )
  **  (OSHeap (DLL.dllseg_shift_rev (store_idnode) (head) (head) ((idnodes_to_dll ((Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs))))))) )
).

Definition InsertObj_entail_wit_3_1_split_goal_1 := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (bucket_2: (@list IdNodeAbs)) (head: Z) (PreH1 : (head = ((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ) ) ))) (PreH2 : (head <> 0)) (PreH3 : (bucket_2 = (Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs))))) (PreH4 : (manager_pre <> 0)) (PreH5 : (idnode_pre <> 0)) (PreH6 : (idmanager_min_free_id sm before id )) (PreH7 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH8 : (0 <= id)) (PreH9 : (id <= 65535)) (PreH10 : (0 < (hoffset (sm)))) (PreH11 : ((hoffset (sm)) <= 65535)) (PreH12 : (bucket_2 = (@nil IdNodeAbs))) ,
  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) (bucket_2) ((idbuckets (before)))) )
|--
  “ (idnodes_nonzero bucket_2 ) ”
.

Definition InsertObj_entail_wit_3_1_split_goal_2 := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (bucket_2: (@list IdNodeAbs)) (head: Z) (PreH1 : (head = ((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ) ) ))) (PreH2 : (head <> 0)) (PreH3 : (bucket_2 = (Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs))))) (PreH4 : (manager_pre <> 0)) (PreH5 : (idnode_pre <> 0)) (PreH6 : (idmanager_min_free_id sm before id )) (PreH7 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH8 : (0 <= id)) (PreH9 : (id <= 65535)) (PreH10 : (0 < (hoffset (sm)))) (PreH11 : ((hoffset (sm)) <= 65535)) (PreH12 : (bucket_2 = (@nil IdNodeAbs))) ,
  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) (bucket_2) ((idbuckets (before)))) )
|--
  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ”
.

Definition InsertObj_entail_wit_3_1_split_goal_spatial := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (bucket_2: (@list IdNodeAbs)) (head: Z) (PreH1 : (head = ((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ) ) ))) (PreH2 : (head <> 0)) (PreH3 : (bucket_2 = (Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs))))) (PreH4 : (manager_pre <> 0)) (PreH5 : (idnode_pre <> 0)) (PreH6 : (idmanager_min_free_id sm before id )) (PreH7 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH8 : (0 <= id)) (PreH9 : (id <= 65535)) (PreH10 : (0 < (hoffset (sm)))) (PreH11 : ((hoffset (sm)) <= 65535)) (PreH12 : (bucket_2 = (@nil IdNodeAbs))) ,
  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) (bucket_2) ((idbuckets (before)))) )
|--
  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) ((Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs)))) ((idbuckets (before)))) )
  **  (OSHeap (DLL.dllseg_shift_rev (store_idnode) (head) (head) ((idnodes_to_dll ((Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs))))))) )
.

Definition InsertObj_entail_wit_3_2 := 
(
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (bucket_2: (@list IdNodeAbs)) (hp: Z) (hn: Z) (head: Z) (PreH1 : (hp <> 0)) (PreH2 : (head = ((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ) ) ))) (PreH3 : (head <> 0)) (PreH4 : (bucket_2 = (Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs))))) (PreH5 : (manager_pre <> 0)) (PreH6 : (idnode_pre <> 0)) (PreH7 : (idmanager_min_free_id sm before id )) (PreH8 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH9 : (0 <= id)) (PreH10 : (id <= 65535)) (PreH11 : (0 < (hoffset (sm)))) (PreH12 : ((hoffset (sm)) <= 65535)) (PreH13 : (hp <> 0)) (PreH14 : (hn <> 0)) (PreH15 : (idnodes_nonzero bucket_2 )) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) (bucket_2) ((idbuckets (before)))) )
  **  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> hp)
  **  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> hn)
  **  (OSHeap (idnodes_dllseg (hn) (head) (head) (hp) (bucket_2)) )
|--
  EX (bucket: (@list IdNodeAbs))  (successor: Z) ,
  “ (head = ((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ) ) )) ” 
  &&  “ (head <> 0) ” 
  &&  “ (successor <> 0) ” 
  &&  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ” 
  &&  “ (bucket = (Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs)))) ” 
  &&  “ (idnodes_nonzero bucket ) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (idmanager_min_free_id sm before id ) ” 
  &&  “ (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) ) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id <= 65535) ” 
  &&  “ (0 < (hoffset (sm))) ” 
  &&  “ ((hoffset (sm)) <= 65535) ”
  &&  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) (bucket) ((idbuckets (before)))) )
  **  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> successor)
  **  ((&((successor)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> head)
  **  (OSHeap (DLL.dllseg_shift_rev (store_idnode) (successor) (head) ((idnodes_to_dll (bucket)))) )
) \/
(
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (bucket_2: (@list IdNodeAbs)) (hp: Z) (hn: Z) (head: Z) (PreH1 : (hp <> 0)) (PreH2 : (head = ((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ) ) ))) (PreH3 : (head <> 0)) (PreH4 : (bucket_2 = (Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs))))) (PreH5 : (manager_pre <> 0)) (PreH6 : (idnode_pre <> 0)) (PreH7 : (idmanager_min_free_id sm before id )) (PreH8 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH9 : (0 <= id)) (PreH10 : (id <= 65535)) (PreH11 : (0 < (hoffset (sm)))) (PreH12 : ((hoffset (sm)) <= 65535)) (PreH13 : (hp <> 0)) (PreH14 : (hn <> 0)) (PreH15 : (idnodes_nonzero bucket_2 )) ,
  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) (bucket_2) ((idbuckets (before)))) )
  **  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> hp)
  **  (OSHeap (idnodes_dllseg (hn) (head) (head) (hp) (bucket_2)) )
|--
  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ”
  &&  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) ((Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs)))) ((idbuckets (before)))) )
  **  ((&((hn)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> head)
  **  (OSHeap (DLL.dllseg_shift_rev (store_idnode) (hn) (head) ((idnodes_to_dll ((Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs))))))) )
).

Definition InsertObj_entail_wit_3_2_split_goal_1 := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (bucket_2: (@list IdNodeAbs)) (hp: Z) (hn: Z) (head: Z) (PreH1 : (hp <> 0)) (PreH2 : (head = ((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ) ) ))) (PreH3 : (head <> 0)) (PreH4 : (bucket_2 = (Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs))))) (PreH5 : (manager_pre <> 0)) (PreH6 : (idnode_pre <> 0)) (PreH7 : (idmanager_min_free_id sm before id )) (PreH8 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH9 : (0 <= id)) (PreH10 : (id <= 65535)) (PreH11 : (0 < (hoffset (sm)))) (PreH12 : ((hoffset (sm)) <= 65535)) (PreH13 : (hp <> 0)) (PreH14 : (hn <> 0)) (PreH15 : (idnodes_nonzero bucket_2 )) ,
  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) (bucket_2) ((idbuckets (before)))) )
  **  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> hp)
  **  (OSHeap (idnodes_dllseg (hn) (head) (head) (hp) (bucket_2)) )
|--
  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ”
.

Definition InsertObj_entail_wit_3_2_split_goal_spatial := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (bucket_2: (@list IdNodeAbs)) (hp: Z) (hn: Z) (head: Z) (PreH1 : (hp <> 0)) (PreH2 : (head = ((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ) ) ))) (PreH3 : (head <> 0)) (PreH4 : (bucket_2 = (Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs))))) (PreH5 : (manager_pre <> 0)) (PreH6 : (idnode_pre <> 0)) (PreH7 : (idmanager_min_free_id sm before id )) (PreH8 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH9 : (0 <= id)) (PreH10 : (id <= 65535)) (PreH11 : (0 < (hoffset (sm)))) (PreH12 : ((hoffset (sm)) <= 65535)) (PreH13 : (hp <> 0)) (PreH14 : (hn <> 0)) (PreH15 : (idnodes_nonzero bucket_2 )) ,
  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) (bucket_2) ((idbuckets (before)))) )
  **  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> hp)
  **  (OSHeap (idnodes_dllseg (hn) (head) (head) (hp) (bucket_2)) )
|--
  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) ((Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs)))) ((idbuckets (before)))) )
  **  ((&((hn)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> head)
  **  (OSHeap (DLL.dllseg_shift_rev (store_idnode) (hn) (head) ((idnodes_to_dll ((Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs))))))) )
.

Definition InsertObj_return_wit_1 := 
(
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (bucket: (@list IdNodeAbs)) (successor: Z) (head: Z) (PreH1 : (head = ((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ) ) ))) (PreH2 : (head <> 0)) (PreH3 : (successor <> 0)) (PreH4 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : (bucket = (Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs))))) (PreH6 : (idnodes_nonzero bucket )) (PreH7 : (manager_pre <> 0)) (PreH8 : (idnode_pre <> 0)) (PreH9 : (idmanager_min_free_id sm before id )) (PreH10 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH11 : (0 <= id)) (PreH12 : (id <= 65535)) (PreH13 : (0 < (hoffset (sm)))) (PreH14 : ((hoffset (sm)) <= 65535)) ,
  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> &((idnode_pre)  # "IdNode" ->ₛ "link"))
  **  ((&((successor)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> &((idnode_pre)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> successor)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> head)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) (bucket) ((idbuckets (before)))) )
  **  (OSHeap (DLL.dllseg_shift_rev (store_idnode) (successor) (head) ((idnodes_to_dll (bucket)))) )
|--
  (OSHeap (store_idmanager (sm) ((idmanager_link (sm) ((idmanager_add (before) (id))) (id) (idnode_pre))) (manager_pre)) )
) \/
(
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (bucket: (@list IdNodeAbs)) (successor: Z) (head: Z) (PreH1 : (head = ((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ) ) ))) (PreH2 : (head <> 0)) (PreH3 : (successor <> 0)) (PreH4 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : (bucket = (Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs))))) (PreH6 : (idnodes_nonzero bucket )) (PreH7 : (manager_pre <> 0)) (PreH8 : (idnode_pre <> 0)) (PreH9 : (idmanager_min_free_id sm before id )) (PreH10 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH11 : (0 <= id)) (PreH12 : (id <= 65535)) (PreH13 : (0 < (hoffset (sm)))) (PreH14 : ((hoffset (sm)) <= 65535)) ,
  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> &((idnode_pre)  # "IdNode" ->ₛ "link"))
  **  ((&((successor)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> &((idnode_pre)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> successor)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> head)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) (bucket) ((idbuckets (before)))) )
  **  (OSHeap (DLL.dllseg_shift_rev (store_idnode) (successor) (head) ((idnodes_to_dll (bucket)))) )
|--
  (OSHeap (store_idmanager (sm) ((idmanager_link (sm) ((idmanager_add (before) (id))) (id) (idnode_pre))) (manager_pre)) )
).

Definition InsertObj_return_wit_1_split_goal_spatial := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (bucket: (@list IdNodeAbs)) (successor: Z) (head: Z) (PreH1 : (head = ((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ) ) ))) (PreH2 : (head <> 0)) (PreH3 : (successor <> 0)) (PreH4 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : (bucket = (Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs))))) (PreH6 : (idnodes_nonzero bucket )) (PreH7 : (manager_pre <> 0)) (PreH8 : (idnode_pre <> 0)) (PreH9 : (idmanager_min_free_id sm before id )) (PreH10 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH11 : (0 <= id)) (PreH12 : (id <= 65535)) (PreH13 : (0 < (hoffset (sm)))) (PreH14 : ((hoffset (sm)) <= 65535)) ,
  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> &((idnode_pre)  # "IdNode" ->ₛ "link"))
  **  ((&((successor)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> &((idnode_pre)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> successor)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> head)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) (bucket) ((idbuckets (before)))) )
  **  (OSHeap (DLL.dllseg_shift_rev (store_idnode) (successor) (head) ((idnodes_to_dll (bucket)))) )
|--
  (OSHeap (store_idmanager (sm) ((idmanager_link (sm) ((idmanager_add (before) (id))) (id) (idnode_pre))) (manager_pre)) )
.

Definition InsertObj_partial_solve_wit_1_pure := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (bucket: (@list IdNodeAbs)) (head: Z) (PreH1 : (head = ((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ) ) ))) (PreH2 : (head <> 0)) (PreH3 : (bucket = (Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs))))) (PreH4 : (manager_pre <> 0)) (PreH5 : (idnode_pre <> 0)) (PreH6 : (idmanager_min_free_id sm before id )) (PreH7 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH8 : (0 <= id)) (PreH9 : (id <= 65535)) (PreH10 : (0 < (hoffset (sm)))) (PreH11 : ((hoffset (sm)) <= 65535)) (PreH12 : (bucket = (@nil IdNodeAbs))) ,
  ((( &( "head" ) )) # Ptr  |-> head)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) (bucket) ((idbuckets (before)))) )
  **  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> 0)
  **  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> 0)
|--
  “ (head = head) ” 
  &&  “ (head <> 0) ”
.

Definition InsertObj_partial_solve_wit_1_aux := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (bucket: (@list IdNodeAbs)) (head: Z) (PreH1 : (head = ((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ) ) ))) (PreH2 : (head <> 0)) (PreH3 : (bucket = (Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs))))) (PreH4 : (manager_pre <> 0)) (PreH5 : (idnode_pre <> 0)) (PreH6 : (idmanager_min_free_id sm before id )) (PreH7 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH8 : (0 <= id)) (PreH9 : (id <= 65535)) (PreH10 : (0 < (hoffset (sm)))) (PreH11 : ((hoffset (sm)) <= 65535)) (PreH12 : (bucket = (@nil IdNodeAbs))) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) (bucket) ((idbuckets (before)))) )
  **  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> 0)
  **  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> 0)
|--
  “ (head = head) ” 
  &&  “ (head <> 0) ” 
  &&  “ (head = ((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ) ) )) ” 
  &&  “ (head <> 0) ” 
  &&  “ (bucket = (Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs)))) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (idmanager_min_free_id sm before id ) ” 
  &&  “ (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) ) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id <= 65535) ” 
  &&  “ (0 < (hoffset (sm))) ” 
  &&  “ ((hoffset (sm)) <= 65535) ” 
  &&  “ (bucket = (@nil IdNodeAbs)) ”
  &&  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |->_)
  **  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |->_)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) (bucket) ((idbuckets (before)))) )
.

Definition InsertObj_partial_solve_wit_1 := InsertObj_partial_solve_wit_1_pure -> InsertObj_partial_solve_wit_1_aux.

Definition InsertObj_partial_solve_wit_2_pure := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (bucket: (@list IdNodeAbs)) (successor: Z) (head: Z) (PreH1 : (head = ((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ) ) ))) (PreH2 : (head <> 0)) (PreH3 : (successor <> 0)) (PreH4 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : (bucket = (Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs))))) (PreH6 : (idnodes_nonzero bucket )) (PreH7 : (manager_pre <> 0)) (PreH8 : (idnode_pre <> 0)) (PreH9 : (idmanager_min_free_id sm before id )) (PreH10 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH11 : (0 <= id)) (PreH12 : (id <= 65535)) (PreH13 : (0 < (hoffset (sm)))) (PreH14 : ((hoffset (sm)) <= 65535)) ,
  ((( &( "head" ) )) # Ptr  |-> head)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) (bucket) ((idbuckets (before)))) )
  **  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> successor)
  **  ((&((successor)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> head)
  **  (OSHeap (DLL.dllseg_shift_rev (store_idnode) (successor) (head) ((idnodes_to_dll (bucket)))) )
|--
  “ (head <> 0) ” 
  &&  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ” 
  &&  “ (successor <> 0) ”
.

Definition InsertObj_partial_solve_wit_2_aux := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (before: VarIdmanager) (sm: StableIdmanager) (bucket: (@list IdNodeAbs)) (successor: Z) (head: Z) (PreH1 : (head = ((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ) ) ))) (PreH2 : (head <> 0)) (PreH3 : (successor <> 0)) (PreH4 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : (bucket = (Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs))))) (PreH6 : (idnodes_nonzero bucket )) (PreH7 : (manager_pre <> 0)) (PreH8 : (idnode_pre <> 0)) (PreH9 : (idmanager_min_free_id sm before id )) (PreH10 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH11 : (0 <= id)) (PreH12 : (id <= 65535)) (PreH13 : (0 < (hoffset (sm)))) (PreH14 : ((hoffset (sm)) <= 65535)) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) (bucket) ((idbuckets (before)))) )
  **  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> successor)
  **  ((&((successor)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> head)
  **  (OSHeap (DLL.dllseg_shift_rev (store_idnode) (successor) (head) ((idnodes_to_dll (bucket)))) )
|--
  “ (head <> 0) ” 
  &&  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ” 
  &&  “ (successor <> 0) ” 
  &&  “ (head = ((htable (sm)) + ((id % ( (hoffset (sm)) ) ) * sizeof( "SysDoubleLinklistNode" ) ) )) ” 
  &&  “ (head <> 0) ” 
  &&  “ (successor <> 0) ” 
  &&  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ” 
  &&  “ (bucket = (Znth ((id % ( (hoffset (sm)) ) )) ((idbuckets (before))) ((@nil IdNodeAbs)))) ” 
  &&  “ (idnodes_nonzero bucket ) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (idmanager_min_free_id sm before id ) ” 
  &&  “ (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) ) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id <= 65535) ” 
  &&  “ (0 < (hoffset (sm))) ” 
  &&  “ ((hoffset (sm)) <= 65535) ”
  &&  ((&((head)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> successor)
  **  ((&((successor)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> head)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |->_)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |->_)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_id_map ((id_map (sm))) ((idmax (sm))) ((idlist_add (id) ((idlist (before)))))) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (OSHeap (store_idbuckets_except ((htable (sm))) ((id % ( (hoffset (sm)) ) )) (bucket) ((idbuckets (before)))) )
  **  (OSHeap (DLL.dllseg_shift_rev (store_idnode) (successor) (head) ((idnodes_to_dll (bucket)))) )
.

Definition InsertObj_partial_solve_wit_2 := InsertObj_partial_solve_wit_2_pure -> InsertObj_partial_solve_wit_2_aux.

Module Type VC_Correct.


Axiom proof_of_InsertObj_safety_wit_1 : InsertObj_safety_wit_1.
Axiom proof_of_InsertObj_safety_wit_2 : InsertObj_safety_wit_2.
Axiom proof_of_InsertObj_safety_wit_3 : InsertObj_safety_wit_3.
Axiom proof_of_InsertObj_safety_wit_4 : InsertObj_safety_wit_4.
Axiom proof_of_InsertObj_safety_wit_5 : InsertObj_safety_wit_5.
Axiom proof_of_InsertObj_safety_wit_6 : InsertObj_safety_wit_6.
Axiom proof_of_InsertObj_safety_wit_7 : InsertObj_safety_wit_7.
Axiom proof_of_InsertObj_safety_wit_8 : InsertObj_safety_wit_8.
Axiom proof_of_InsertObj_safety_wit_9 : InsertObj_safety_wit_9.
Axiom proof_of_InsertObj_safety_wit_10 : InsertObj_safety_wit_10.
Axiom proof_of_InsertObj_entail_wit_1 : InsertObj_entail_wit_1.
Axiom proof_of_InsertObj_entail_wit_2 : InsertObj_entail_wit_2.
Axiom proof_of_InsertObj_entail_wit_3_1 : InsertObj_entail_wit_3_1.
Axiom proof_of_InsertObj_entail_wit_3_2 : InsertObj_entail_wit_3_2.
Axiom proof_of_InsertObj_return_wit_1 : InsertObj_return_wit_1.
Axiom proof_of_InsertObj_partial_solve_wit_1_pure : InsertObj_partial_solve_wit_1_pure.
Axiom proof_of_InsertObj_partial_solve_wit_1 : InsertObj_partial_solve_wit_1.
Axiom proof_of_InsertObj_partial_solve_wit_2_pure : InsertObj_partial_solve_wit_2_pure.
Axiom proof_of_InsertObj_partial_solve_wit_2 : InsertObj_partial_solve_wit_2.

End VC_Correct.
