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
Require Import CRTOS_Verify.sem.CrtosOSProtocol.
Import CrtosOS_C_Rules.
Require Import Coq.Lists.List.
Require Import CRTOS_Verify.sem.SemaphorePure.
Require Import CRTOS_Verify.sem.SemaphoreRep.
Require Import CRTOS_Verify.VC.SemaphoreProofLocal.
Local Open Scope sac.

(*----- Function InsertObj -----*)

Definition InsertObj_safety_wit_1 := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (manager_pre <> 0)) (PreH2 : (idnode_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (semaphore_layout_32_ok sem )) (PreH5 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH6 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (store_sem_manager_id_allocated stable before id )
  **  (store_sem_id_node_insert_ready sem id )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition InsertObj_safety_wit_2 := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (manager_pre = 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (idnode_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (semaphore_layout_32_ok sem )) (PreH6 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH7 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (store_sem_manager_id_allocated stable before id )
  **  (store_sem_id_node_insert_ready sem id )
|--
  “ False ”
.

Definition InsertObj_safety_wit_3 := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (manager_pre <> 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (idnode_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (semaphore_layout_32_ok sem )) (PreH6 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH7 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (store_sem_manager_id_allocated stable before id )
  **  (store_sem_id_node_insert_ready sem id )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition InsertObj_safety_wit_4 := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (idnode_pre = 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (manager_pre <> 0)) (PreH4 : (idnode_pre <> 0)) (PreH5 : (SemaphoreStableContext stable )) (PreH6 : (semaphore_layout_32_ok sem )) (PreH7 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH8 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (store_sem_manager_id_allocated stable before id )
  **  (store_sem_id_node_insert_ready sem id )
|--
  “ False ”
.

Definition InsertObj_safety_wit_5 := 
(
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (sem <> 0)) (PreH2 : (0 <= id)) (PreH3 : (id < (semaphore_id_limit (stable)))) (PreH4 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : (idnode_pre <> 0)) (PreH6 : (manager_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (idnode_pre <> 0)) (PreH9 : (SemaphoreStableContext stable )) (PreH10 : (semaphore_layout_32_ok sem )) (PreH11 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH12 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((( &( "head" ) )) # Ptr  |->_)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
  **  (store_semaphore_buckets stable before )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
|--
  “ ((id <> (INT_MIN)) \/ ((semaphore_bucket_count (stable)) <> (-1))) ” 
  &&  “ ((semaphore_bucket_count (stable)) <> 0) ”
) \/
(
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (sem <> 0)) (PreH2 : (0 <= id)) (PreH3 : (id < (semaphore_id_limit (stable)))) (PreH4 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : (idnode_pre <> 0)) (PreH6 : (manager_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (idnode_pre <> 0)) (PreH9 : (SemaphoreStableContext stable )) (PreH10 : (semaphore_layout_32_ok sem )) (PreH11 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH12 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((( &( "head" ) )) # Ptr  |->_)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
  **  (store_semaphore_buckets stable before )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
|--
  “ ((id <> (INT_MIN)) \/ ((semaphore_bucket_count (stable)) <> (-1))) ” 
  &&  “ ((semaphore_bucket_count (stable)) <> 0) ”
).

Definition InsertObj_safety_wit_5_split_goal_1 := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (sem <> 0)) (PreH2 : (0 <= id)) (PreH3 : (id < (semaphore_id_limit (stable)))) (PreH4 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : (idnode_pre <> 0)) (PreH6 : (manager_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (idnode_pre <> 0)) (PreH9 : (SemaphoreStableContext stable )) (PreH10 : (semaphore_layout_32_ok sem )) (PreH11 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH12 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((( &( "head" ) )) # Ptr  |->_)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
  **  (store_semaphore_buckets stable before )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
|--
  “ ((id <> (INT_MIN)) \/ ((semaphore_bucket_count (stable)) <> (-1))) ”
.

Definition InsertObj_safety_wit_5_split_goal_2 := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (sem <> 0)) (PreH2 : (0 <= id)) (PreH3 : (id < (semaphore_id_limit (stable)))) (PreH4 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : (idnode_pre <> 0)) (PreH6 : (manager_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (idnode_pre <> 0)) (PreH9 : (SemaphoreStableContext stable )) (PreH10 : (semaphore_layout_32_ok sem )) (PreH11 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH12 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((( &( "head" ) )) # Ptr  |->_)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
  **  (store_semaphore_buckets stable before )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
|--
  “ ((semaphore_bucket_count (stable)) <> 0) ”
.

Definition InsertObj_safety_wit_6 := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (previous: Z) (PreH1 : (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0)) (PreH2 : (previous <> 0)) (PreH3 : (sem <> 0)) (PreH4 : (0 <= id)) (PreH5 : (id < (semaphore_id_limit (stable)))) (PreH6 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH7 : (idnode_pre <> 0)) (PreH8 : (manager_pre <> 0)) (PreH9 : (manager_pre <> 0)) (PreH10 : (idnode_pre <> 0)) (PreH11 : (SemaphoreStableContext stable )) (PreH12 : (semaphore_layout_32_ok sem )) (PreH13 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH14 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((&((((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> previous)
  **  (store_sem_dll_without_prev store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) previous )
  **  (store_sem_buckets_some_rest stable before (id % ( 16 ) ) )
  **  ((( &( "head" ) )) # Ptr  |-> ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition InsertObj_safety_wit_7 := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0)) (PreH2 : (sem <> 0)) (PreH3 : (0 <= id)) (PreH4 : (id < (semaphore_id_limit (stable)))) (PreH5 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH6 : (idnode_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (manager_pre <> 0)) (PreH9 : (idnode_pre <> 0)) (PreH10 : (SemaphoreStableContext stable )) (PreH11 : (semaphore_layout_32_ok sem )) (PreH12 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH13 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((&((((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> 0)
  **  ((&((((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> 0)
  **  (store_sem_buckets_none_rest stable before (id % ( 16 ) ) )
  **  ((( &( "head" ) )) # Ptr  |-> ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition InsertObj_safety_wit_8 := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (previous: Z) (PreH1 : (previous = 0)) (PreH2 : (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0)) (PreH3 : (previous <> 0)) (PreH4 : (sem <> 0)) (PreH5 : (0 <= id)) (PreH6 : (id < (semaphore_id_limit (stable)))) (PreH7 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH8 : (idnode_pre <> 0)) (PreH9 : (manager_pre <> 0)) (PreH10 : (manager_pre <> 0)) (PreH11 : (idnode_pre <> 0)) (PreH12 : (SemaphoreStableContext stable )) (PreH13 : (semaphore_layout_32_ok sem )) (PreH14 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH15 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((&((((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> previous)
  **  (store_sem_dll_without_prev store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) previous )
  **  (store_sem_buckets_some_rest stable before (id % ( 16 ) ) )
  **  ((( &( "head" ) )) # Ptr  |-> ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
|--
  “ False ”
.

Definition InsertObj_return_wit_1 := 
(
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0)) (PreH2 : (sem <> 0)) (PreH3 : (0 <= id)) (PreH4 : (id < (semaphore_id_limit (stable)))) (PreH5 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH6 : (idnode_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (manager_pre <> 0)) (PreH9 : (idnode_pre <> 0)) (PreH10 : (SemaphoreStableContext stable )) (PreH11 : (semaphore_layout_32_ok sem )) (PreH12 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH13 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_dll store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (cons ((Build_SemDLNode ((Build_SemaphoreObject (sem) (id) (0) ((@nil Z)))) (&((idnode_pre)  # "IdNode" ->ₛ "link")))) ((map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))))) )
  **  (store_sem_buckets_none_rest stable before (id % ( 16 ) ) )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
|--
  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (semaphore_layout_32_ok sem ) ”
  &&  (store_semaphore_id_manager stable (semaphore_reserve_state (before) (sem) (id)) )
) \/
(
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0)) (PreH2 : (sem <> 0)) (PreH3 : (0 <= id)) (PreH4 : (id < (semaphore_id_limit (stable)))) (PreH5 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH6 : (idnode_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (manager_pre <> 0)) (PreH9 : (idnode_pre <> 0)) (PreH10 : (SemaphoreStableContext stable )) (PreH11 : (semaphore_layout_32_ok sem )) (PreH12 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH13 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_dll store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (cons ((Build_SemDLNode ((Build_SemaphoreObject (sem) (id) (0) ((@nil Z)))) (&((idnode_pre)  # "IdNode" ->ₛ "link")))) ((map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))))) )
  **  (store_sem_buckets_none_rest stable before (id % ( 16 ) ) )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
|--
  (store_semaphore_id_manager stable (semaphore_reserve_state (before) (sem) (id)) )
).

Definition InsertObj_return_wit_1_split_goal_spatial := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0)) (PreH2 : (sem <> 0)) (PreH3 : (0 <= id)) (PreH4 : (id < (semaphore_id_limit (stable)))) (PreH5 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH6 : (idnode_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (manager_pre <> 0)) (PreH9 : (idnode_pre <> 0)) (PreH10 : (SemaphoreStableContext stable )) (PreH11 : (semaphore_layout_32_ok sem )) (PreH12 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH13 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_dll store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (cons ((Build_SemDLNode ((Build_SemaphoreObject (sem) (id) (0) ((@nil Z)))) (&((idnode_pre)  # "IdNode" ->ₛ "link")))) ((map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))))) )
  **  (store_sem_buckets_none_rest stable before (id % ( 16 ) ) )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
|--
  (store_semaphore_id_manager stable (semaphore_reserve_state (before) (sem) (id)) )
.

Definition InsertObj_return_wit_2 := 
(
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (previous: Z) (PreH1 : (previous <> 0)) (PreH2 : (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0)) (PreH3 : (previous <> 0)) (PreH4 : (sem <> 0)) (PreH5 : (0 <= id)) (PreH6 : (id < (semaphore_id_limit (stable)))) (PreH7 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH8 : (idnode_pre <> 0)) (PreH9 : (manager_pre <> 0)) (PreH10 : (manager_pre <> 0)) (PreH11 : (idnode_pre <> 0)) (PreH12 : (SemaphoreStableContext stable )) (PreH13 : (semaphore_layout_32_ok sem )) (PreH14 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH15 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_dll store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (cons ((Build_SemDLNode ((Build_SemaphoreObject (sem) (id) (0) ((@nil Z)))) (&((idnode_pre)  # "IdNode" ->ₛ "link")))) ((map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))))) )
  **  (store_sem_buckets_some_rest stable before (id % ( 16 ) ) )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
|--
  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (semaphore_layout_32_ok sem ) ”
  &&  (store_semaphore_id_manager stable (semaphore_reserve_state (before) (sem) (id)) )
) \/
(
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (previous: Z) (PreH1 : (previous <> 0)) (PreH2 : (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0)) (PreH3 : (previous <> 0)) (PreH4 : (sem <> 0)) (PreH5 : (0 <= id)) (PreH6 : (id < (semaphore_id_limit (stable)))) (PreH7 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH8 : (idnode_pre <> 0)) (PreH9 : (manager_pre <> 0)) (PreH10 : (manager_pre <> 0)) (PreH11 : (idnode_pre <> 0)) (PreH12 : (SemaphoreStableContext stable )) (PreH13 : (semaphore_layout_32_ok sem )) (PreH14 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH15 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_dll store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (cons ((Build_SemDLNode ((Build_SemaphoreObject (sem) (id) (0) ((@nil Z)))) (&((idnode_pre)  # "IdNode" ->ₛ "link")))) ((map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))))) )
  **  (store_sem_buckets_some_rest stable before (id % ( 16 ) ) )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
|--
  (store_semaphore_id_manager stable (semaphore_reserve_state (before) (sem) (id)) )
).

Definition InsertObj_return_wit_2_split_goal_spatial := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (previous: Z) (PreH1 : (previous <> 0)) (PreH2 : (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0)) (PreH3 : (previous <> 0)) (PreH4 : (sem <> 0)) (PreH5 : (0 <= id)) (PreH6 : (id < (semaphore_id_limit (stable)))) (PreH7 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH8 : (idnode_pre <> 0)) (PreH9 : (manager_pre <> 0)) (PreH10 : (manager_pre <> 0)) (PreH11 : (idnode_pre <> 0)) (PreH12 : (SemaphoreStableContext stable )) (PreH13 : (semaphore_layout_32_ok sem )) (PreH14 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH15 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_dll store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (cons ((Build_SemDLNode ((Build_SemaphoreObject (sem) (id) (0) ((@nil Z)))) (&((idnode_pre)  # "IdNode" ->ₛ "link")))) ((map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))))) )
  **  (store_sem_buckets_some_rest stable before (id % ( 16 ) ) )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
|--
  (store_semaphore_id_manager stable (semaphore_reserve_state (before) (sem) (id)) )
.

Definition InsertObj_partial_solve_wit_1_pure := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (idnode_pre <> 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (manager_pre <> 0)) (PreH4 : (idnode_pre <> 0)) (PreH5 : (SemaphoreStableContext stable )) (PreH6 : (semaphore_layout_32_ok sem )) (PreH7 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH8 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (store_sem_manager_id_allocated stable before id )
  **  (store_sem_id_node_insert_ready sem id )
|--
  “ (manager_pre = (semaphore_manager_addr (stable))) ”
.

Definition InsertObj_partial_solve_wit_1_aux := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (idnode_pre <> 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (manager_pre <> 0)) (PreH4 : (idnode_pre <> 0)) (PreH5 : (SemaphoreStableContext stable )) (PreH6 : (semaphore_layout_32_ok sem )) (PreH7 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH8 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_manager_id_allocated stable before id )
  **  (store_sem_id_node_insert_ready sem id )
|--
  “ (manager_pre = (semaphore_manager_addr (stable))) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  (store_sem_manager_id_allocated stable before id )
  **  (store_sem_id_node_insert_ready sem id )
.

Definition InsertObj_partial_solve_wit_1 := InsertObj_partial_solve_wit_1_pure -> InsertObj_partial_solve_wit_1_aux.

Definition InsertObj_partial_solve_wit_2_pure := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (idnode_pre <> 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (manager_pre <> 0)) (PreH4 : (idnode_pre <> 0)) (PreH5 : (SemaphoreStableContext stable )) (PreH6 : (semaphore_layout_32_ok sem )) (PreH7 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH8 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
  **  (store_semaphore_buckets stable before )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (store_sem_id_node_insert_ready sem id )
|--
  “ (SemaphoreStableContext stable ) ” 
  &&  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ”
.

Definition InsertObj_partial_solve_wit_2_aux := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (idnode_pre <> 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (manager_pre <> 0)) (PreH4 : (idnode_pre <> 0)) (PreH5 : (SemaphoreStableContext stable )) (PreH6 : (semaphore_layout_32_ok sem )) (PreH7 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH8 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
  **  (store_semaphore_buckets stable before )
  **  (store_sem_id_node_insert_ready sem id )
|--
  “ (SemaphoreStableContext stable ) ” 
  &&  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  (store_sem_id_node_insert_ready sem id )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
  **  (store_semaphore_buckets stable before )
.

Definition InsertObj_partial_solve_wit_2 := InsertObj_partial_solve_wit_2_pure -> InsertObj_partial_solve_wit_2_aux.

Definition InsertObj_partial_solve_wit_3_pure := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (sem <> 0)) (PreH2 : (0 <= id)) (PreH3 : (id < (semaphore_id_limit (stable)))) (PreH4 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : (idnode_pre <> 0)) (PreH6 : (manager_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (idnode_pre <> 0)) (PreH9 : (SemaphoreStableContext stable )) (PreH10 : (semaphore_layout_32_ok sem )) (PreH11 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH12 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((( &( "head" ) )) # Ptr  |-> ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
  **  (store_semaphore_buckets stable before )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
|--
  “ (SemaphoreStableContext stable ) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id < (semaphore_id_limit (stable))) ”
.

Definition InsertObj_partial_solve_wit_3_aux := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (sem <> 0)) (PreH2 : (0 <= id)) (PreH3 : (id < (semaphore_id_limit (stable)))) (PreH4 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : (idnode_pre <> 0)) (PreH6 : (manager_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (idnode_pre <> 0)) (PreH9 : (SemaphoreStableContext stable )) (PreH10 : (semaphore_layout_32_ok sem )) (PreH11 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH12 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
  **  (store_semaphore_buckets stable before )
|--
  “ (SemaphoreStableContext stable ) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id < (semaphore_id_limit (stable))) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id < (semaphore_id_limit (stable))) ” 
  &&  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  (store_semaphore_buckets stable before )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
.

Definition InsertObj_partial_solve_wit_3 := InsertObj_partial_solve_wit_3_pure -> InsertObj_partial_solve_wit_3_aux.

Definition InsertObj_partial_solve_wit_4_pure := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0)) (PreH2 : (sem <> 0)) (PreH3 : (0 <= id)) (PreH4 : (id < (semaphore_id_limit (stable)))) (PreH5 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH6 : (idnode_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (manager_pre <> 0)) (PreH9 : (idnode_pre <> 0)) (PreH10 : (SemaphoreStableContext stable )) (PreH11 : (semaphore_layout_32_ok sem )) (PreH12 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH13 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((&((((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> 0)
  **  ((&((((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> 0)
  **  (store_sem_buckets_none_rest stable before (id % ( 16 ) ) )
  **  ((( &( "head" ) )) # Ptr  |-> ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
|--
  “ (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0) ”
.

Definition InsertObj_partial_solve_wit_4_aux := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0)) (PreH2 : (sem <> 0)) (PreH3 : (0 <= id)) (PreH4 : (id < (semaphore_id_limit (stable)))) (PreH5 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH6 : (idnode_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (manager_pre <> 0)) (PreH9 : (idnode_pre <> 0)) (PreH10 : (SemaphoreStableContext stable )) (PreH11 : (semaphore_layout_32_ok sem )) (PreH12 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH13 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((&((((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> 0)
  **  ((&((((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> 0)
  **  (store_sem_buckets_none_rest stable before (id % ( 16 ) ) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
|--
  “ (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0) ” 
  &&  “ (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id < (semaphore_id_limit (stable))) ” 
  &&  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  ((&((((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> 0)
  **  ((&((((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> 0)
  **  (store_sem_buckets_none_rest stable before (id % ( 16 ) ) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
.

Definition InsertObj_partial_solve_wit_4 := InsertObj_partial_solve_wit_4_pure -> InsertObj_partial_solve_wit_4_aux.

Definition InsertObj_partial_solve_wit_5_pure := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (previous: Z) (PreH1 : (previous <> 0)) (PreH2 : (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0)) (PreH3 : (previous <> 0)) (PreH4 : (sem <> 0)) (PreH5 : (0 <= id)) (PreH6 : (id < (semaphore_id_limit (stable)))) (PreH7 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH8 : (idnode_pre <> 0)) (PreH9 : (manager_pre <> 0)) (PreH10 : (manager_pre <> 0)) (PreH11 : (idnode_pre <> 0)) (PreH12 : (SemaphoreStableContext stable )) (PreH13 : (semaphore_layout_32_ok sem )) (PreH14 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH15 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((&((((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> previous)
  **  (store_sem_dll_without_prev store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) previous )
  **  (store_sem_buckets_some_rest stable before (id % ( 16 ) ) )
  **  ((( &( "head" ) )) # Ptr  |-> ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
|--
  “ (previous <> 0) ”
.

Definition InsertObj_partial_solve_wit_5_aux := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (previous: Z) (PreH1 : (previous <> 0)) (PreH2 : (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0)) (PreH3 : (previous <> 0)) (PreH4 : (sem <> 0)) (PreH5 : (0 <= id)) (PreH6 : (id < (semaphore_id_limit (stable)))) (PreH7 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH8 : (idnode_pre <> 0)) (PreH9 : (manager_pre <> 0)) (PreH10 : (manager_pre <> 0)) (PreH11 : (idnode_pre <> 0)) (PreH12 : (SemaphoreStableContext stable )) (PreH13 : (semaphore_layout_32_ok sem )) (PreH14 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH15 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((&((((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> previous)
  **  (store_sem_dll_without_prev store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) previous )
  **  (store_sem_buckets_some_rest stable before (id % ( 16 ) ) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
|--
  “ (previous <> 0) ” 
  &&  “ (previous <> 0) ” 
  &&  “ (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0) ” 
  &&  “ (previous <> 0) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id < (semaphore_id_limit (stable))) ” 
  &&  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  ((&((((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> previous)
  **  (store_sem_dll_without_prev store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) previous )
  **  (store_sem_buckets_some_rest stable before (id % ( 16 ) ) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
.

Definition InsertObj_partial_solve_wit_5 := InsertObj_partial_solve_wit_5_pure -> InsertObj_partial_solve_wit_5_aux.

Definition InsertObj_partial_solve_wit_6 := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0)) (PreH2 : (sem <> 0)) (PreH3 : (0 <= id)) (PreH4 : (id < (semaphore_id_limit (stable)))) (PreH5 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH6 : (idnode_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (manager_pre <> 0)) (PreH9 : (idnode_pre <> 0)) (PreH10 : (SemaphoreStableContext stable )) (PreH11 : (semaphore_layout_32_ok sem )) (PreH12 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH13 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_dll semaphore_unit_empty ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (@nil (@SemDLNode unit)) )
  **  (store_sem_buckets_none_rest stable before (id % ( 16 ) ) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
|--
  “ (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id < (semaphore_id_limit (stable))) ” 
  &&  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  (store_sem_dll semaphore_unit_empty ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (@nil (@SemDLNode unit)) )
  **  (store_sem_buckets_none_rest stable before (id % ( 16 ) ) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
.

Definition InsertObj_partial_solve_wit_7_pure := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (previous: Z) (PreH1 : (previous <> 0)) (PreH2 : (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0)) (PreH3 : (previous <> 0)) (PreH4 : (sem <> 0)) (PreH5 : (0 <= id)) (PreH6 : (id < (semaphore_id_limit (stable)))) (PreH7 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH8 : (idnode_pre <> 0)) (PreH9 : (manager_pre <> 0)) (PreH10 : (manager_pre <> 0)) (PreH11 : (idnode_pre <> 0)) (PreH12 : (SemaphoreStableContext stable )) (PreH13 : (semaphore_layout_32_ok sem )) (PreH14 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH15 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_dll store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) )
  **  (store_sem_buckets_some_rest stable before (id % ( 16 ) ) )
  **  ((( &( "head" ) )) # Ptr  |-> ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
|--
  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ”
.

Definition InsertObj_partial_solve_wit_7_aux := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (previous: Z) (PreH1 : (previous <> 0)) (PreH2 : (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0)) (PreH3 : (previous <> 0)) (PreH4 : (sem <> 0)) (PreH5 : (0 <= id)) (PreH6 : (id < (semaphore_id_limit (stable)))) (PreH7 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH8 : (idnode_pre <> 0)) (PreH9 : (manager_pre <> 0)) (PreH10 : (manager_pre <> 0)) (PreH11 : (idnode_pre <> 0)) (PreH12 : (SemaphoreStableContext stable )) (PreH13 : (semaphore_layout_32_ok sem )) (PreH14 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH15 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_dll store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) )
  **  (store_sem_buckets_some_rest stable before (id % ( 16 ) ) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
|--
  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (previous <> 0) ” 
  &&  “ (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0) ” 
  &&  “ (previous <> 0) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id < (semaphore_id_limit (stable))) ” 
  &&  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
  **  (store_sem_dll store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) )
  **  (store_sem_buckets_some_rest stable before (id % ( 16 ) ) )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
.

Definition InsertObj_partial_solve_wit_7 := InsertObj_partial_solve_wit_7_pure -> InsertObj_partial_solve_wit_7_aux.

Definition InsertObj_partial_solve_wit_8_pure := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0)) (PreH2 : (sem <> 0)) (PreH3 : (0 <= id)) (PreH4 : (id < (semaphore_id_limit (stable)))) (PreH5 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH6 : (idnode_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (manager_pre <> 0)) (PreH9 : (idnode_pre <> 0)) (PreH10 : (SemaphoreStableContext stable )) (PreH11 : (semaphore_layout_32_ok sem )) (PreH12 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH13 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_dll store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) )
  **  (store_sem_buckets_none_rest stable before (id % ( 16 ) ) )
  **  ((( &( "head" ) )) # Ptr  |-> ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
|--
  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ”
.

Definition InsertObj_partial_solve_wit_8_aux := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0)) (PreH2 : (sem <> 0)) (PreH3 : (0 <= id)) (PreH4 : (id < (semaphore_id_limit (stable)))) (PreH5 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH6 : (idnode_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (manager_pre <> 0)) (PreH9 : (idnode_pre <> 0)) (PreH10 : (SemaphoreStableContext stable )) (PreH11 : (semaphore_layout_32_ok sem )) (PreH12 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH13 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_dll store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) )
  **  (store_sem_buckets_none_rest stable before (id % ( 16 ) ) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
|--
  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id < (semaphore_id_limit (stable))) ” 
  &&  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
  **  (store_sem_dll store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) )
  **  (store_sem_buckets_none_rest stable before (id % ( 16 ) ) )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
.

Definition InsertObj_partial_solve_wit_8 := InsertObj_partial_solve_wit_8_pure -> InsertObj_partial_solve_wit_8_aux.

Definition InsertObj_partial_solve_wit_9_pure := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0)) (PreH2 : (sem <> 0)) (PreH3 : (0 <= id)) (PreH4 : (id < (semaphore_id_limit (stable)))) (PreH5 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH6 : (idnode_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (manager_pre <> 0)) (PreH9 : (idnode_pre <> 0)) (PreH10 : (SemaphoreStableContext stable )) (PreH11 : (semaphore_layout_32_ok sem )) (PreH12 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH13 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_standalone_node store_semaphore_id_payload &((idnode_pre)  # "IdNode" ->ₛ "link") (Build_SemaphoreObject (sem) (id) (0) ((@nil Z))) )
  **  (store_sem_dll store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) )
  **  (store_sem_buckets_none_rest stable before (id % ( 16 ) ) )
  **  ((( &( "head" ) )) # Ptr  |-> ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
|--
  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ”
.

Definition InsertObj_partial_solve_wit_9_aux := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0)) (PreH2 : (sem <> 0)) (PreH3 : (0 <= id)) (PreH4 : (id < (semaphore_id_limit (stable)))) (PreH5 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH6 : (idnode_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (manager_pre <> 0)) (PreH9 : (idnode_pre <> 0)) (PreH10 : (SemaphoreStableContext stable )) (PreH11 : (semaphore_layout_32_ok sem )) (PreH12 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH13 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_standalone_node store_semaphore_id_payload &((idnode_pre)  # "IdNode" ->ₛ "link") (Build_SemaphoreObject (sem) (id) (0) ((@nil Z))) )
  **  (store_sem_dll store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) )
  **  (store_sem_buckets_none_rest stable before (id % ( 16 ) ) )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
|--
  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ” 
  &&  “ (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id < (semaphore_id_limit (stable))) ” 
  &&  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  (store_sem_dll store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) )
  **  (store_sem_standalone_node store_semaphore_id_payload &((idnode_pre)  # "IdNode" ->ₛ "link") (Build_SemaphoreObject (sem) (id) (0) ((@nil Z))) )
  **  (store_sem_buckets_none_rest stable before (id % ( 16 ) ) )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
.

Definition InsertObj_partial_solve_wit_9 := InsertObj_partial_solve_wit_9_pure -> InsertObj_partial_solve_wit_9_aux.

Definition InsertObj_partial_solve_wit_10_pure := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (previous: Z) (PreH1 : (previous <> 0)) (PreH2 : (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0)) (PreH3 : (previous <> 0)) (PreH4 : (sem <> 0)) (PreH5 : (0 <= id)) (PreH6 : (id < (semaphore_id_limit (stable)))) (PreH7 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH8 : (idnode_pre <> 0)) (PreH9 : (manager_pre <> 0)) (PreH10 : (manager_pre <> 0)) (PreH11 : (idnode_pre <> 0)) (PreH12 : (SemaphoreStableContext stable )) (PreH13 : (semaphore_layout_32_ok sem )) (PreH14 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH15 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_standalone_node store_semaphore_id_payload &((idnode_pre)  # "IdNode" ->ₛ "link") (Build_SemaphoreObject (sem) (id) (0) ((@nil Z))) )
  **  (store_sem_dll store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) )
  **  (store_sem_buckets_some_rest stable before (id % ( 16 ) ) )
  **  ((( &( "head" ) )) # Ptr  |-> ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
|--
  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ”
.

Definition InsertObj_partial_solve_wit_10_aux := 
forall (idnode_pre: Z) (manager_pre: Z) (id: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (previous: Z) (PreH1 : (previous <> 0)) (PreH2 : (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0)) (PreH3 : (previous <> 0)) (PreH4 : (sem <> 0)) (PreH5 : (0 <= id)) (PreH6 : (id < (semaphore_id_limit (stable)))) (PreH7 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH8 : (idnode_pre <> 0)) (PreH9 : (manager_pre <> 0)) (PreH10 : (manager_pre <> 0)) (PreH11 : (idnode_pre <> 0)) (PreH12 : (SemaphoreStableContext stable )) (PreH13 : (semaphore_layout_32_ok sem )) (PreH14 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH15 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_standalone_node store_semaphore_id_payload &((idnode_pre)  # "IdNode" ->ₛ "link") (Build_SemaphoreObject (sem) (id) (0) ((@nil Z))) )
  **  (store_sem_dll store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) )
  **  (store_sem_buckets_some_rest stable before (id % ( 16 ) ) )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
|--
  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ” 
  &&  “ (previous <> 0) ” 
  &&  “ (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0) ” 
  &&  “ (previous <> 0) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id < (semaphore_id_limit (stable))) ” 
  &&  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  (store_sem_dll store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) )
  **  (store_sem_standalone_node store_semaphore_id_payload &((idnode_pre)  # "IdNode" ->ₛ "link") (Build_SemaphoreObject (sem) (id) (0) ((@nil Z))) )
  **  (store_sem_buckets_some_rest stable before (id % ( 16 ) ) )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
.

Definition InsertObj_partial_solve_wit_10 := InsertObj_partial_solve_wit_10_pure -> InsertObj_partial_solve_wit_10_aux.

Definition InsertObj_which_implies_wit_1 := 
(
forall (manager_pre: Z) (id: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  (store_sem_manager_id_allocated stable before id )
|--
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
  **  (store_semaphore_buckets stable before )
) \/
(
forall (manager_pre: Z) (id: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  (store_sem_manager_id_allocated stable before id )
|--
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
  **  (store_semaphore_buckets stable before )
).

Definition InsertObj_which_implies_wit_1_split_goal_spatial := 
forall (manager_pre: Z) (id: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (manager_pre = (semaphore_manager_addr (stable)))) ,
  (store_sem_manager_id_allocated stable before id )
|--
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (semaphore_id_limit (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (semaphore_bucket_count (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (semaphore_bitmap_addr (stable)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (semaphore_buckets_addr (stable)))
  **  (store_semaphore_bitmap_ids stable (cons (id) ((semaphore_ids ((semaphore_objects (before)))))) )
  **  (store_semaphore_buckets stable before )
.

Definition InsertObj_which_implies_wit_2 := 
(
forall (idnode_pre: Z) (id: Z) (sem: Z) (stable: SemaphoreStable) (PreH1 : (SemaphoreStableContext stable )) (PreH2 : (semaphore_layout_32_ok sem )) (PreH3 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_id_node_insert_ready sem id )
|--
  “ (sem <> 0) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id < (semaphore_id_limit (stable))) ” 
  &&  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ”
  &&  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
) \/
(
forall (idnode_pre: Z) (id: Z) (sem: Z) (stable: SemaphoreStable) (PreH1 : (SemaphoreStableContext stable )) (PreH2 : (semaphore_layout_32_ok sem )) (PreH3 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_id_node_insert_ready sem id )
|--
  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ” 
  &&  “ (id < (semaphore_id_limit (stable))) ” 
  &&  “ (0 <= id) ” 
  &&  “ (sem <> 0) ”
  &&  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
).

Definition InsertObj_which_implies_wit_2_split_goal_1 := 
forall (idnode_pre: Z) (id: Z) (sem: Z) (stable: SemaphoreStable) (PreH1 : (SemaphoreStableContext stable )) (PreH2 : (semaphore_layout_32_ok sem )) (PreH3 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_id_node_insert_ready sem id )
|--
  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ”
.

Definition InsertObj_which_implies_wit_2_split_goal_2 := 
forall (idnode_pre: Z) (id: Z) (sem: Z) (stable: SemaphoreStable) (PreH1 : (SemaphoreStableContext stable )) (PreH2 : (semaphore_layout_32_ok sem )) (PreH3 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_id_node_insert_ready sem id )
|--
  “ (id < (semaphore_id_limit (stable))) ”
.

Definition InsertObj_which_implies_wit_2_split_goal_3 := 
forall (idnode_pre: Z) (id: Z) (sem: Z) (stable: SemaphoreStable) (PreH1 : (SemaphoreStableContext stable )) (PreH2 : (semaphore_layout_32_ok sem )) (PreH3 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_id_node_insert_ready sem id )
|--
  “ (0 <= id) ”
.

Definition InsertObj_which_implies_wit_2_split_goal_4 := 
forall (idnode_pre: Z) (id: Z) (sem: Z) (stable: SemaphoreStable) (PreH1 : (SemaphoreStableContext stable )) (PreH2 : (semaphore_layout_32_ok sem )) (PreH3 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_id_node_insert_ready sem id )
|--
  “ (sem <> 0) ”
.

Definition InsertObj_which_implies_wit_2_split_goal_spatial := 
forall (idnode_pre: Z) (id: Z) (sem: Z) (stable: SemaphoreStable) (PreH1 : (SemaphoreStableContext stable )) (PreH2 : (semaphore_layout_32_ok sem )) (PreH3 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_id_node_insert_ready sem id )
|--
  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
.

Definition InsertObj_which_implies_wit_3 := 
forall (id: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (SemaphoreStableContext stable )) (PreH2 : (0 <= id)) (PreH3 : (id < (semaphore_id_limit (stable)))) ,
  (store_semaphore_buckets stable before )
|--
  (“ (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0) ”
  &&  ((&((((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> 0)
  **  ((&((((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> 0)
  **  (store_sem_buckets_none_rest stable before (id % ( 16 ) ) ))
  ||
  (EX (previous: Z) ,
  “ (((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) <> 0) ” 
  &&  “ (previous <> 0) ”
  &&  ((&((((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> previous)
  **  (store_sem_dll_without_prev store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) previous )
  **  (store_sem_buckets_some_rest stable before (id % ( 16 ) ) ))
.

Definition InsertObj_which_implies_wit_4 := 
(
forall (id: Z) (before: SemaphoreState) (stable: SemaphoreStable) ,
  (store_sem_dll semaphore_unit_empty ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (@nil (@SemDLNode unit)) )
  **  (store_sem_buckets_none_rest stable before (id % ( 16 ) ) )
|--
  (store_sem_dll store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) )
  **  (store_sem_buckets_none_rest stable before (id % ( 16 ) ) )
) \/
(
forall (id: Z) (before: SemaphoreState) (stable: SemaphoreStable) ,
  (store_sem_dll semaphore_unit_empty ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (@nil (@SemDLNode unit)) )
  **  (store_sem_buckets_none_rest stable before (id % ( 16 ) ) )
|--
  (store_sem_dll store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) )
  **  (store_sem_buckets_none_rest stable before (id % ( 16 ) ) )
).

Definition InsertObj_which_implies_wit_4_split_goal_spatial := 
forall (id: Z) (before: SemaphoreState) (stable: SemaphoreStable) ,
  (store_sem_dll semaphore_unit_empty ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (@nil (@SemDLNode unit)) )
  **  (store_sem_buckets_none_rest stable before (id % ( 16 ) ) )
|--
  (store_sem_dll store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) )
  **  (store_sem_buckets_none_rest stable before (id % ( 16 ) ) )
.

Definition InsertObj_which_implies_wit_5 := 
(
forall (id: Z) (before: SemaphoreState) (stable: SemaphoreStable) (previous: Z) (PreH1 : (previous <> 0)) ,
  ((&((((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> previous)
  **  (store_sem_dll_without_prev store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) previous )
  **  (store_sem_buckets_some_rest stable before (id % ( 16 ) ) )
|--
  (store_sem_dll store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) )
  **  (store_sem_buckets_some_rest stable before (id % ( 16 ) ) )
) \/
(
forall (id: Z) (before: SemaphoreState) (stable: SemaphoreStable) (previous: Z) (PreH1 : (previous <> 0)) ,
  ((&((((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> previous)
  **  (store_sem_dll_without_prev store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) previous )
  **  (store_sem_buckets_some_rest stable before (id % ( 16 ) ) )
|--
  (store_sem_dll store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) )
  **  (store_sem_buckets_some_rest stable before (id % ( 16 ) ) )
).

Definition InsertObj_which_implies_wit_5_split_goal_spatial := 
forall (id: Z) (before: SemaphoreState) (stable: SemaphoreStable) (previous: Z) (PreH1 : (previous <> 0)) ,
  ((&((((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))))  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> previous)
  **  (store_sem_dll_without_prev store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) previous )
  **  (store_sem_buckets_some_rest stable before (id % ( 16 ) ) )
|--
  (store_sem_dll store_semaphore_id_payload ((semaphore_buckets_addr (stable)) + ((id % ( (semaphore_bucket_count (stable)) ) ) * sizeof( "SysDoubleLinklistNode" ))) (map (semaphore_id_node) ((semaphore_objects_in_bucket (stable) ((id % ( 16 ) )) ((semaphore_objects (before)))))) )
  **  (store_sem_buckets_some_rest stable before (id % ( 16 ) ) )
.

Definition InsertObj_which_implies_wit_6 := 
(
forall (idnode_pre: Z) (id: Z) (sem: Z) (PreH1 : (semaphore_layout_32_ok sem )) (PreH2 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
|--
  (store_sem_standalone_node store_semaphore_id_payload &((idnode_pre)  # "IdNode" ->ₛ "link") (Build_SemaphoreObject (sem) (id) (0) ((@nil Z))) )
) \/
(
forall (idnode_pre: Z) (id: Z) (sem: Z) (PreH1 : (semaphore_layout_32_ok sem )) (PreH2 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
|--
  (store_sem_standalone_node store_semaphore_id_payload &((idnode_pre)  # "IdNode" ->ₛ "link") (Build_SemaphoreObject (sem) (id) (0) ((@nil Z))) )
).

Definition InsertObj_which_implies_wit_6_split_goal_spatial := 
forall (idnode_pre: Z) (id: Z) (sem: Z) (PreH1 : (semaphore_layout_32_ok sem )) (PreH2 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  (store_sem_id_node_insert_ready_rest sem id )
|--
  (store_sem_standalone_node store_semaphore_id_payload &((idnode_pre)  # "IdNode" ->ₛ "link") (Build_SemaphoreObject (sem) (id) (0) ((@nil Z))) )
.

Module Type VC_Correct.


Axiom proof_of_InsertObj_safety_wit_1 : InsertObj_safety_wit_1.
Axiom proof_of_InsertObj_safety_wit_2 : InsertObj_safety_wit_2.
Axiom proof_of_InsertObj_safety_wit_3 : InsertObj_safety_wit_3.
Axiom proof_of_InsertObj_safety_wit_4 : InsertObj_safety_wit_4.
Axiom proof_of_InsertObj_safety_wit_5 : InsertObj_safety_wit_5.
Axiom proof_of_InsertObj_safety_wit_6 : InsertObj_safety_wit_6.
Axiom proof_of_InsertObj_safety_wit_7 : InsertObj_safety_wit_7.
Axiom proof_of_InsertObj_safety_wit_8 : InsertObj_safety_wit_8.
Axiom proof_of_InsertObj_return_wit_1 : InsertObj_return_wit_1.
Axiom proof_of_InsertObj_return_wit_2 : InsertObj_return_wit_2.
Axiom proof_of_InsertObj_partial_solve_wit_1_pure : InsertObj_partial_solve_wit_1_pure.
Axiom proof_of_InsertObj_partial_solve_wit_1 : InsertObj_partial_solve_wit_1.
Axiom proof_of_InsertObj_partial_solve_wit_2_pure : InsertObj_partial_solve_wit_2_pure.
Axiom proof_of_InsertObj_partial_solve_wit_2 : InsertObj_partial_solve_wit_2.
Axiom proof_of_InsertObj_partial_solve_wit_3_pure : InsertObj_partial_solve_wit_3_pure.
Axiom proof_of_InsertObj_partial_solve_wit_3 : InsertObj_partial_solve_wit_3.
Axiom proof_of_InsertObj_partial_solve_wit_4_pure : InsertObj_partial_solve_wit_4_pure.
Axiom proof_of_InsertObj_partial_solve_wit_4 : InsertObj_partial_solve_wit_4.
Axiom proof_of_InsertObj_partial_solve_wit_5_pure : InsertObj_partial_solve_wit_5_pure.
Axiom proof_of_InsertObj_partial_solve_wit_5 : InsertObj_partial_solve_wit_5.
Axiom proof_of_InsertObj_partial_solve_wit_6 : InsertObj_partial_solve_wit_6.
Axiom proof_of_InsertObj_partial_solve_wit_7_pure : InsertObj_partial_solve_wit_7_pure.
Axiom proof_of_InsertObj_partial_solve_wit_7 : InsertObj_partial_solve_wit_7.
Axiom proof_of_InsertObj_partial_solve_wit_8_pure : InsertObj_partial_solve_wit_8_pure.
Axiom proof_of_InsertObj_partial_solve_wit_8 : InsertObj_partial_solve_wit_8.
Axiom proof_of_InsertObj_partial_solve_wit_9_pure : InsertObj_partial_solve_wit_9_pure.
Axiom proof_of_InsertObj_partial_solve_wit_9 : InsertObj_partial_solve_wit_9.
Axiom proof_of_InsertObj_partial_solve_wit_10_pure : InsertObj_partial_solve_wit_10_pure.
Axiom proof_of_InsertObj_partial_solve_wit_10 : InsertObj_partial_solve_wit_10.
Axiom proof_of_InsertObj_which_implies_wit_1 : InsertObj_which_implies_wit_1.
Axiom proof_of_InsertObj_which_implies_wit_2 : InsertObj_which_implies_wit_2.
Axiom proof_of_InsertObj_which_implies_wit_3 : InsertObj_which_implies_wit_3.
Axiom proof_of_InsertObj_which_implies_wit_4 : InsertObj_which_implies_wit_4.
Axiom proof_of_InsertObj_which_implies_wit_5 : InsertObj_which_implies_wit_5.
Axiom proof_of_InsertObj_which_implies_wit_6 : InsertObj_which_implies_wit_6.

End VC_Correct.
