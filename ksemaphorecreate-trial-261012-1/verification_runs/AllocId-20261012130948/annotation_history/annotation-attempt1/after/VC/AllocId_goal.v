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

(*----- Function AllocId -----*)

Definition AllocId_safety_wit_1 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (PreH1 : (manager_pre <> 0)) ,
  ((( &( "index" ) )) # Int  |->_)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition AllocId_safety_wit_2 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (PreH1 : (manager_pre <> 0)) ,
  ((( &( "end" ) )) # Int  |->_)
  **  ((( &( "index" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition AllocId_safety_wit_3 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (PreH1 : (manager_pre <> 0)) ,
  ((( &( "id" ) )) # Int  |->_)
  **  ((( &( "end" ) )) # Int  |-> 0)
  **  ((( &( "index" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition AllocId_safety_wit_4 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (PreH1 : (manager_pre <> 0)) ,
  ((( &( "entry" ) )) # UChar  |->_)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "end" ) )) # Int  |-> 0)
  **  ((( &( "index" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition AllocId_safety_wit_5 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (PreH1 : (manager_pre <> 0)) ,
  ((( &( "entry" ) )) # UChar  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "end" ) )) # Int  |-> 0)
  **  ((( &( "index" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition AllocId_safety_wit_6 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (PreH1 : (manager_pre = 0)) (PreH2 : (manager_pre <> 0)) ,
  ((( &( "entry" ) )) # UChar  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "end" ) )) # Int  |-> 0)
  **  ((( &( "index" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
|--
  “ False ”
.

Definition AllocId_safety_wit_7 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (entry: Z) (id: Z) (end: Z) (index: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (index = 0)) (PreH3 : (end = 0)) (PreH4 : (id = 0)) (PreH5 : (entry = 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition AllocId_safety_wit_8 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (index: Z) (end: Z) (id: Z) (entry: Z) (bytes: (@list Z)) (PreH1 : (manager_pre <> 0)) (PreH2 : (index = 0)) (PreH3 : (end = 0)) (PreH4 : (id = 0)) (PreH5 : (entry = 0)) (PreH6 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH7 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ ((((idmax (sm)) + 7 ) <> (INT_MIN)) \/ (8 <> (-1))) ” 
  &&  “ (8 <> 0) ”
.

Definition AllocId_safety_wit_9 := 
(
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (index: Z) (end: Z) (id: Z) (entry: Z) (bytes: (@list Z)) (PreH1 : (manager_pre <> 0)) (PreH2 : (index = 0)) (PreH3 : (end = 0)) (PreH4 : (id = 0)) (PreH5 : (entry = 0)) (PreH6 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH7 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (((idmax (sm)) + 7 ) <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= ((idmax (sm)) + 7 )) ”
) \/
(
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (index: Z) (end: Z) (id: Z) (entry: Z) (bytes: (@list Z)) (PreH1 : (manager_pre <> 0)) (PreH2 : (index = 0)) (PreH3 : (end = 0)) (PreH4 : (id = 0)) (PreH5 : (entry = 0)) (PreH6 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH7 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (((idmax (sm)) + 7 ) <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= ((idmax (sm)) + 7 )) ”
).

Definition AllocId_safety_wit_9_split_goal_1 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (index: Z) (end: Z) (id: Z) (entry: Z) (bytes: (@list Z)) (PreH1 : (manager_pre <> 0)) (PreH2 : (index = 0)) (PreH3 : (end = 0)) (PreH4 : (id = 0)) (PreH5 : (entry = 0)) (PreH6 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH7 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (((idmax (sm)) + 7 ) <= INT_MAX) ”
.

Definition AllocId_safety_wit_9_split_goal_2 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (index: Z) (end: Z) (id: Z) (entry: Z) (bytes: (@list Z)) (PreH1 : (manager_pre <> 0)) (PreH2 : (index = 0)) (PreH3 : (end = 0)) (PreH4 : (id = 0)) (PreH5 : (entry = 0)) (PreH6 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH7 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ ((INT_MIN) <= ((idmax (sm)) + 7 )) ”
.

Definition AllocId_safety_wit_10 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (index: Z) (end: Z) (id: Z) (entry: Z) (bytes: (@list Z)) (PreH1 : (manager_pre <> 0)) (PreH2 : (index = 0)) (PreH3 : (end = 0)) (PreH4 : (id = 0)) (PreH5 : (entry = 0)) (PreH6 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH7 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (7 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 7) ”
.

Definition AllocId_safety_wit_11 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (index: Z) (end: Z) (id: Z) (entry: Z) (bytes: (@list Z)) (PreH1 : (manager_pre <> 0)) (PreH2 : (index = 0)) (PreH3 : (end = 0)) (PreH4 : (id = 0)) (PreH5 : (entry = 0)) (PreH6 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH7 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (8 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 8) ”
.

Definition AllocId_safety_wit_12 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (index: Z) (end: Z) (id: Z) (entry: Z) (bytes: (@list Z)) (PreH1 : (manager_pre <> 0)) (PreH2 : (index = 0)) (PreH3 : (end = 0)) (PreH4 : (id = 0)) (PreH5 : (entry = 0)) (PreH6 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH7 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "end" ) )) # Int  |-> (((idmax (sm)) + 7 ) ÷ 8 ))
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition AllocId_safety_wit_13 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (entry: Z) (id: Z) (index: Z) (end: Z) (PreH1 : (index < end)) (PreH2 : (manager_pre <> 0)) (PreH3 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index)) (PreH5 : (index <= end)) (PreH6 : (id = 0)) (PreH7 : (entry = 0)) (PreH8 : (allocid_index_scan_inv bytes index )) (PreH9 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH10 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (255 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 255) ”
.

Definition AllocId_safety_wit_14 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (entry: Z) (id: Z) (index: Z) (end: Z) (PreH1 : ((Znth index bytes 0) = 255)) (PreH2 : (index < end)) (PreH3 : (manager_pre <> 0)) (PreH4 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index)) (PreH6 : (index <= end)) (PreH7 : (id = 0)) (PreH8 : (entry = 0)) (PreH9 : (allocid_index_scan_inv bytes index )) (PreH10 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH11 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ ((index + 1 ) <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= (index + 1 )) ”
.

Definition AllocId_safety_wit_15 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (entry: Z) (id: Z) (index: Z) (end: Z) (PreH1 : (index <> end)) (PreH2 : (index >= end)) (PreH3 : (manager_pre <> 0)) (PreH4 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index)) (PreH6 : (index <= end)) (PreH7 : (id = 0)) (PreH8 : (entry = 0)) (PreH9 : (allocid_index_scan_inv bytes index )) (PreH10 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH11 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ False ”
.

Definition AllocId_safety_wit_16 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (entry: Z) (id: Z) (index: Z) (end: Z) (PreH1 : (index = end)) (PreH2 : ((Znth index bytes 0) <> 255)) (PreH3 : (index < end)) (PreH4 : (manager_pre <> 0)) (PreH5 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH6 : (0 <= index)) (PreH7 : (index <= end)) (PreH8 : (id = 0)) (PreH9 : (entry = 0)) (PreH10 : (allocid_index_scan_inv bytes index )) (PreH11 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH12 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ False ”
.

Definition AllocId_safety_wit_17 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (entry: Z) (id: Z) (index: Z) (end: Z) (PreH1 : (index = end)) (PreH2 : (index >= end)) (PreH3 : (manager_pre <> 0)) (PreH4 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index)) (PreH6 : (index <= end)) (PreH7 : (id = 0)) (PreH8 : (entry = 0)) (PreH9 : (allocid_index_scan_inv bytes index )) (PreH10 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH11 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (1 <> (INT_MIN)) ”
.

Definition AllocId_safety_wit_18 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (entry: Z) (id: Z) (index: Z) (end: Z) (PreH1 : (index = end)) (PreH2 : (index >= end)) (PreH3 : (manager_pre <> 0)) (PreH4 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index)) (PreH6 : (index <= end)) (PreH7 : (id = 0)) (PreH8 : (entry = 0)) (PreH9 : (allocid_index_scan_inv bytes index )) (PreH10 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH11 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition AllocId_safety_wit_19 := 
(
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (entry: Z) (id: Z) (index: Z) (end: Z) (PreH1 : (index <> end)) (PreH2 : ((Znth index bytes 0) <> 255)) (PreH3 : (index < end)) (PreH4 : (manager_pre <> 0)) (PreH5 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH6 : (0 <= index)) (PreH7 : (index <= end)) (PreH8 : (id = 0)) (PreH9 : (entry = 0)) (PreH10 : (allocid_index_scan_inv bytes index )) (PreH11 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH12 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ ((index * 8 ) <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= (index * 8 )) ”
) \/
(
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (entry: Z) (id: Z) (index: Z) (end: Z) (PreH1 : (index <> end)) (PreH2 : ((Znth index bytes 0) <> 255)) (PreH3 : (index < end)) (PreH4 : (manager_pre <> 0)) (PreH5 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH6 : (0 <= index)) (PreH7 : (index <= end)) (PreH8 : (id = 0)) (PreH9 : (entry = 0)) (PreH10 : (allocid_index_scan_inv bytes index )) (PreH11 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH12 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ ((index * 8 ) <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= (index * 8 )) ”
).

Definition AllocId_safety_wit_19_split_goal_1 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (entry: Z) (id: Z) (index: Z) (end: Z) (PreH1 : (index <> end)) (PreH2 : ((Znth index bytes 0) <> 255)) (PreH3 : (index < end)) (PreH4 : (manager_pre <> 0)) (PreH5 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH6 : (0 <= index)) (PreH7 : (index <= end)) (PreH8 : (id = 0)) (PreH9 : (entry = 0)) (PreH10 : (allocid_index_scan_inv bytes index )) (PreH11 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH12 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ ((index * 8 ) <= INT_MAX) ”
.

Definition AllocId_safety_wit_19_split_goal_2 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (entry: Z) (id: Z) (index: Z) (end: Z) (PreH1 : (index <> end)) (PreH2 : ((Znth index bytes 0) <> 255)) (PreH3 : (index < end)) (PreH4 : (manager_pre <> 0)) (PreH5 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH6 : (0 <= index)) (PreH7 : (index <= end)) (PreH8 : (id = 0)) (PreH9 : (entry = 0)) (PreH10 : (allocid_index_scan_inv bytes index )) (PreH11 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH12 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ ((INT_MIN) <= (index * 8 )) ”
.

Definition AllocId_safety_wit_20 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (entry: Z) (id: Z) (index: Z) (end: Z) (PreH1 : (index <> end)) (PreH2 : ((Znth index bytes 0) <> 255)) (PreH3 : (index < end)) (PreH4 : (manager_pre <> 0)) (PreH5 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH6 : (0 <= index)) (PreH7 : (index <= end)) (PreH8 : (id = 0)) (PreH9 : (entry = 0)) (PreH10 : (allocid_index_scan_inv bytes index )) (PreH11 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH12 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (8 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 8) ”
.

Definition AllocId_safety_wit_21 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (end: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH3 : (0 <= index)) (PreH4 : (index < end)) (PreH5 : ((Znth (index) (bytes) (0)) <> 255)) (PreH6 : (allocid_index_scan_inv bytes index )) (PreH7 : (allocid_entry_scan_inv bytes index id entry )) (PreH8 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH9 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition AllocId_safety_wit_22 := 
(
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (end: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH3 : (0 <= index)) (PreH4 : (index < end)) (PreH5 : ((Znth (index) (bytes) (0)) <> 255)) (PreH6 : (allocid_index_scan_inv bytes index )) (PreH7 : (allocid_entry_scan_inv bytes index id entry )) (PreH8 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH9 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH10 : ((Z.land entry 1) <> 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ ((id + 1 ) <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= (id + 1 )) ”
) \/
(
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (end: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH3 : (0 <= index)) (PreH4 : (index < end)) (PreH5 : ((Znth (index) (bytes) (0)) <> 255)) (PreH6 : (allocid_index_scan_inv bytes index )) (PreH7 : (allocid_entry_scan_inv bytes index id entry )) (PreH8 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH9 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH10 : ((Z.land entry 1) <> 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ ((id + 1 ) <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= (id + 1 )) ”
).

Definition AllocId_safety_wit_22_split_goal_1 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (end: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH3 : (0 <= index)) (PreH4 : (index < end)) (PreH5 : ((Znth (index) (bytes) (0)) <> 255)) (PreH6 : (allocid_index_scan_inv bytes index )) (PreH7 : (allocid_entry_scan_inv bytes index id entry )) (PreH8 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH9 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH10 : ((Z.land entry 1) <> 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ ((id + 1 ) <= INT_MAX) ”
.

Definition AllocId_safety_wit_22_split_goal_2 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (end: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH3 : (0 <= index)) (PreH4 : (index < end)) (PreH5 : ((Znth (index) (bytes) (0)) <> 255)) (PreH6 : (allocid_index_scan_inv bytes index )) (PreH7 : (allocid_entry_scan_inv bytes index id entry )) (PreH8 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH9 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH10 : ((Z.land entry 1) <> 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ ((INT_MIN) <= (id + 1 )) ”
.

Definition AllocId_safety_wit_23 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (end: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH3 : (0 <= index)) (PreH4 : (index < end)) (PreH5 : ((Znth (index) (bytes) (0)) <> 255)) (PreH6 : (allocid_index_scan_inv bytes index )) (PreH7 : (allocid_entry_scan_inv bytes index id entry )) (PreH8 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH9 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH10 : ((Z.land entry 1) <> 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> (id + 1 ))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (1 <= 7) ” 
  &&  “ (0 <= 1) ”
.

Definition AllocId_safety_wit_24 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (end: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH3 : (0 <= index)) (PreH4 : (index < end)) (PreH5 : ((Znth (index) (bytes) (0)) <> 255)) (PreH6 : (allocid_index_scan_inv bytes index )) (PreH7 : (allocid_entry_scan_inv bytes index id entry )) (PreH8 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH9 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH10 : ((Z.land entry 1) <> 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> (id + 1 ))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition AllocId_safety_wit_25 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (end: Z) (PreH1 : (id >= (idmax (sm)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index)) (PreH5 : (index < end)) (PreH6 : ((Znth (index) (bytes) (0)) <> 255)) (PreH7 : (allocid_index_scan_inv bytes index )) (PreH8 : (allocid_entry_scan_inv bytes index id entry )) (PreH9 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH10 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH11 : ((Z.land entry 1) = 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (1 <> (INT_MIN)) ”
.

Definition AllocId_safety_wit_26 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (end: Z) (PreH1 : (id >= (idmax (sm)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index)) (PreH5 : (index < end)) (PreH6 : ((Znth (index) (bytes) (0)) <> 255)) (PreH7 : (allocid_index_scan_inv bytes index )) (PreH8 : (allocid_entry_scan_inv bytes index id entry )) (PreH9 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH10 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH11 : ((Z.land entry 1) = 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition AllocId_safety_wit_27 := 
(
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (end: Z) (PreH1 : (id < (idmax (sm)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index)) (PreH5 : (index < end)) (PreH6 : ((Znth (index) (bytes) (0)) <> 255)) (PreH7 : (allocid_index_scan_inv bytes index )) (PreH8 : (allocid_entry_scan_inv bytes index id entry )) (PreH9 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH10 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH11 : ((Z.land entry 1) = 0)) ,
  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ ((signed_last_nbits ((1 * (2^(id % ( 8 ) )) )) (32)) <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= (signed_last_nbits ((1 * (2^(id % ( 8 ) )) )) (32))) ” 
  &&  “ ((id % ( 8 ) ) <= 31) ” 
  &&  “ (0 <= (id % ( 8 ) )) ”
) \/
(
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (end: Z) (PreH1 : (id < (idmax (sm)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index)) (PreH5 : (index < end)) (PreH6 : ((Znth (index) (bytes) (0)) <> 255)) (PreH7 : (allocid_index_scan_inv bytes index )) (PreH8 : (allocid_entry_scan_inv bytes index id entry )) (PreH9 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH10 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH11 : ((Z.land entry 1) = 0)) ,
  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ ((signed_last_nbits ((1 * (2^(id % ( 8 ) )) )) (32)) <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= (signed_last_nbits ((1 * (2^(id % ( 8 ) )) )) (32))) ” 
  &&  “ ((id % ( 8 ) ) <= 31) ” 
  &&  “ (0 <= (id % ( 8 ) )) ”
).

Definition AllocId_safety_wit_27_split_goal_1 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (end: Z) (PreH1 : (id < (idmax (sm)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index)) (PreH5 : (index < end)) (PreH6 : ((Znth (index) (bytes) (0)) <> 255)) (PreH7 : (allocid_index_scan_inv bytes index )) (PreH8 : (allocid_entry_scan_inv bytes index id entry )) (PreH9 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH10 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH11 : ((Z.land entry 1) = 0)) ,
  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ ((signed_last_nbits ((1 * (2^(id % ( 8 ) )) )) (32)) <= INT_MAX) ”
.

Definition AllocId_safety_wit_27_split_goal_2 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (end: Z) (PreH1 : (id < (idmax (sm)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index)) (PreH5 : (index < end)) (PreH6 : ((Znth (index) (bytes) (0)) <> 255)) (PreH7 : (allocid_index_scan_inv bytes index )) (PreH8 : (allocid_entry_scan_inv bytes index id entry )) (PreH9 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH10 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH11 : ((Z.land entry 1) = 0)) ,
  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ ((INT_MIN) <= (signed_last_nbits ((1 * (2^(id % ( 8 ) )) )) (32))) ”
.

Definition AllocId_safety_wit_27_split_goal_3 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (end: Z) (PreH1 : (id < (idmax (sm)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index)) (PreH5 : (index < end)) (PreH6 : ((Znth (index) (bytes) (0)) <> 255)) (PreH7 : (allocid_index_scan_inv bytes index )) (PreH8 : (allocid_entry_scan_inv bytes index id entry )) (PreH9 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH10 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH11 : ((Z.land entry 1) = 0)) ,
  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ ((id % ( 8 ) ) <= 31) ”
.

Definition AllocId_safety_wit_27_split_goal_4 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (end: Z) (PreH1 : (id < (idmax (sm)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index)) (PreH5 : (index < end)) (PreH6 : ((Znth (index) (bytes) (0)) <> 255)) (PreH7 : (allocid_index_scan_inv bytes index )) (PreH8 : (allocid_entry_scan_inv bytes index id entry )) (PreH9 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH10 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH11 : ((Z.land entry 1) = 0)) ,
  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (0 <= (id % ( 8 ) )) ”
.

Definition AllocId_safety_wit_28 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (end: Z) (PreH1 : (id < (idmax (sm)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index)) (PreH5 : (index < end)) (PreH6 : ((Znth (index) (bytes) (0)) <> 255)) (PreH7 : (allocid_index_scan_inv bytes index )) (PreH8 : (allocid_entry_scan_inv bytes index id entry )) (PreH9 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH10 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH11 : ((Z.land entry 1) = 0)) ,
  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ ((id <> (INT_MIN)) \/ (8 <> (-1))) ” 
  &&  “ (8 <> 0) ”
.

Definition AllocId_safety_wit_29 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (end: Z) (PreH1 : (id < (idmax (sm)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index)) (PreH5 : (index < end)) (PreH6 : ((Znth (index) (bytes) (0)) <> 255)) (PreH7 : (allocid_index_scan_inv bytes index )) (PreH8 : (allocid_entry_scan_inv bytes index id entry )) (PreH9 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH10 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH11 : ((Z.land entry 1) = 0)) ,
  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition AllocId_safety_wit_30 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (end: Z) (PreH1 : (id < (idmax (sm)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index)) (PreH5 : (index < end)) (PreH6 : ((Znth (index) (bytes) (0)) <> 255)) (PreH7 : (allocid_index_scan_inv bytes index )) (PreH8 : (allocid_entry_scan_inv bytes index id entry )) (PreH9 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH10 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH11 : ((Z.land entry 1) = 0)) ,
  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "end" ) )) # Int  |-> end)
  **  ((( &( "index" ) )) # Int  |-> index)
  **  ((( &( "entry" ) )) # UChar  |-> entry)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (8 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 8) ”
.

Definition AllocId_entail_wit_1 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (PreH1 : (manager_pre <> 0)) (PreH2 : (manager_pre <> 0)) ,
  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
|--
  “ (manager_pre <> 0) ” 
  &&  “ (0 = 0) ” 
  &&  “ (0 = 0) ” 
  &&  “ (0 = 0) ” 
  &&  “ (0 = 0) ”
  &&  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
.

Definition AllocId_entail_wit_2 := 
(
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (entry: Z) (id: Z) (end: Z) (index: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (index = 0)) (PreH3 : (end = 0)) (PreH4 : (id = 0)) (PreH5 : (entry = 0)) ,
  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
|--
  EX (bytes: (@list Z)) ,
  “ (manager_pre <> 0) ” 
  &&  “ (index = 0) ” 
  &&  “ (end = 0) ” 
  &&  “ (id = 0) ” 
  &&  “ (entry = 0) ” 
  &&  “ (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes ) ” 
  &&  “ (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) ) ”
  &&  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
) \/
(
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (entry: Z) (id: Z) (end: Z) (index: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (index = 0)) (PreH3 : (end = 0)) (PreH4 : (id = 0)) (PreH5 : (entry = 0)) ,
  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
|--
  EX (bytes: (@list Z)) ,
  “ (manager_pre <> 0) ” 
  &&  “ (index = 0) ” 
  &&  “ (end = 0) ” 
  &&  “ (id = 0) ” 
  &&  “ (entry = 0) ” 
  &&  “ (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes ) ” 
  &&  “ (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) ) ”
  &&  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
).

Definition AllocId_entail_wit_3 := 
(
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (index: Z) (end: Z) (id: Z) (entry: Z) (bytes: (@list Z)) (PreH1 : (manager_pre <> 0)) (PreH2 : (index = 0)) (PreH3 : (end = 0)) (PreH4 : (id = 0)) (PreH5 : (entry = 0)) (PreH6 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH7 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (manager_pre <> 0) ” 
  &&  “ ((((idmax (sm)) + 7 ) ÷ 8 ) = (((idmax (sm)) + 7 ) ÷ 8 )) ” 
  &&  “ (0 <= 0) ” 
  &&  “ (0 <= (((idmax (sm)) + 7 ) ÷ 8 )) ” 
  &&  “ (id = 0) ” 
  &&  “ (entry = 0) ” 
  &&  “ (allocid_index_scan_inv bytes 0 ) ” 
  &&  “ (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes ) ” 
  &&  “ (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) ) ”
  &&  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
) \/
(
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (index: Z) (end: Z) (id: Z) (entry: Z) (bytes: (@list Z)) (PreH1 : (manager_pre <> 0)) (PreH2 : (index = 0)) (PreH3 : (end = 0)) (PreH4 : (id = 0)) (PreH5 : (entry = 0)) (PreH6 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH7 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  TT && emp 
|--
  “ (allocid_index_scan_inv bytes 0 ) ” 
  &&  “ (0 <= (((idmax (sm)) + 7 ) ÷ 8 )) ”
  &&  emp
).

Definition AllocId_entail_wit_3_split_goal_1 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (index: Z) (end: Z) (id: Z) (entry: Z) (bytes: (@list Z)) (PreH1 : (manager_pre <> 0)) (PreH2 : (index = 0)) (PreH3 : (end = 0)) (PreH4 : (id = 0)) (PreH5 : (entry = 0)) (PreH6 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH7 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  (allocid_index_scan_inv bytes 0 )
.

Definition AllocId_entail_wit_3_split_goal_2 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (index: Z) (end: Z) (id: Z) (entry: Z) (bytes: (@list Z)) (PreH1 : (manager_pre <> 0)) (PreH2 : (index = 0)) (PreH3 : (end = 0)) (PreH4 : (id = 0)) (PreH5 : (entry = 0)) (PreH6 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH7 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  (0 <= (((idmax (sm)) + 7 ) ÷ 8 ))
.

Definition AllocId_entail_wit_4 := 
(
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (entry: Z) (id: Z) (index: Z) (end: Z) (PreH1 : ((Znth index bytes 0) = 255)) (PreH2 : (index < end)) (PreH3 : (manager_pre <> 0)) (PreH4 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index)) (PreH6 : (index <= end)) (PreH7 : (id = 0)) (PreH8 : (entry = 0)) (PreH9 : (allocid_index_scan_inv bytes index )) (PreH10 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH11 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (manager_pre <> 0) ” 
  &&  “ (end = (((idmax (sm)) + 7 ) ÷ 8 )) ” 
  &&  “ (0 <= (index + 1 )) ” 
  &&  “ ((index + 1 ) <= end) ” 
  &&  “ (id = 0) ” 
  &&  “ (entry = 0) ” 
  &&  “ (allocid_index_scan_inv bytes (index + 1 ) ) ” 
  &&  “ (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes ) ” 
  &&  “ (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) ) ”
  &&  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
) \/
(
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (entry: Z) (id: Z) (index: Z) (end: Z) (PreH1 : ((Znth index bytes 0) = 255)) (PreH2 : (index < end)) (PreH3 : (manager_pre <> 0)) (PreH4 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index)) (PreH6 : (index <= end)) (PreH7 : (id = 0)) (PreH8 : (entry = 0)) (PreH9 : (allocid_index_scan_inv bytes index )) (PreH10 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH11 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  TT && emp 
|--
  “ (allocid_index_scan_inv bytes (index + 1 ) ) ”
  &&  emp
).

Definition AllocId_entail_wit_4_split_goal_1 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (entry: Z) (id: Z) (index: Z) (end: Z) (PreH1 : ((Znth index bytes 0) = 255)) (PreH2 : (index < end)) (PreH3 : (manager_pre <> 0)) (PreH4 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index)) (PreH6 : (index <= end)) (PreH7 : (id = 0)) (PreH8 : (entry = 0)) (PreH9 : (allocid_index_scan_inv bytes index )) (PreH10 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH11 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  (allocid_index_scan_inv bytes (index + 1 ) )
.

Definition AllocId_entail_wit_5 := 
(
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (entry: Z) (id: Z) (index: Z) (end: Z) (PreH1 : (index <> end)) (PreH2 : ((Znth index bytes 0) <> 255)) (PreH3 : (index < end)) (PreH4 : (manager_pre <> 0)) (PreH5 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH6 : (0 <= index)) (PreH7 : (index <= end)) (PreH8 : (id = 0)) (PreH9 : (entry = 0)) (PreH10 : (allocid_index_scan_inv bytes index )) (PreH11 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH12 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (manager_pre <> 0) ” 
  &&  “ (end = (((idmax (sm)) + 7 ) ÷ 8 )) ” 
  &&  “ (0 <= index) ” 
  &&  “ (index < end) ” 
  &&  “ ((Znth (index) (bytes) (0)) <> 255) ” 
  &&  “ (allocid_index_scan_inv bytes index ) ” 
  &&  “ (allocid_entry_scan_inv bytes index (index * 8 ) (Znth index bytes 0) ) ” 
  &&  “ (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes ) ” 
  &&  “ (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) ) ”
  &&  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
) \/
(
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (entry: Z) (id: Z) (index: Z) (end: Z) (PreH1 : (index <> end)) (PreH2 : ((Znth index bytes 0) <> 255)) (PreH3 : (index < end)) (PreH4 : (manager_pre <> 0)) (PreH5 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH6 : (0 <= index)) (PreH7 : (index <= end)) (PreH8 : (id = 0)) (PreH9 : (entry = 0)) (PreH10 : (allocid_index_scan_inv bytes index )) (PreH11 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH12 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  TT && emp 
|--
  “ (allocid_entry_scan_inv bytes index (index * 8 ) (Znth index bytes 0) ) ”
  &&  emp
).

Definition AllocId_entail_wit_5_split_goal_1 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (entry: Z) (id: Z) (index: Z) (end: Z) (PreH1 : (index <> end)) (PreH2 : ((Znth index bytes 0) <> 255)) (PreH3 : (index < end)) (PreH4 : (manager_pre <> 0)) (PreH5 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH6 : (0 <= index)) (PreH7 : (index <= end)) (PreH8 : (id = 0)) (PreH9 : (entry = 0)) (PreH10 : (allocid_index_scan_inv bytes index )) (PreH11 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH12 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  (allocid_entry_scan_inv bytes index (index * 8 ) (Znth index bytes 0) )
.

Definition AllocId_entail_wit_6 := 
(
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (end: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH3 : (0 <= index)) (PreH4 : (index < end)) (PreH5 : ((Znth (index) (bytes) (0)) <> 255)) (PreH6 : (allocid_index_scan_inv bytes index )) (PreH7 : (allocid_entry_scan_inv bytes index id entry )) (PreH8 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH9 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH10 : ((Z.land entry 1) <> 0)) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (manager_pre <> 0) ” 
  &&  “ (end = (((idmax (sm)) + 7 ) ÷ 8 )) ” 
  &&  “ (0 <= index) ” 
  &&  “ (index < end) ” 
  &&  “ ((Znth (index) (bytes) (0)) <> 255) ” 
  &&  “ (allocid_index_scan_inv bytes index ) ” 
  &&  “ (allocid_entry_scan_inv bytes index (id + 1 ) (unsigned_last_nbits ((Z.shiftr entry 1)) (8)) ) ” 
  &&  “ (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes ) ” 
  &&  “ (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) ) ”
  &&  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
) \/
(
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (end: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH3 : (0 <= index)) (PreH4 : (index < end)) (PreH5 : ((Znth (index) (bytes) (0)) <> 255)) (PreH6 : (allocid_index_scan_inv bytes index )) (PreH7 : (allocid_entry_scan_inv bytes index id entry )) (PreH8 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH9 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH10 : ((Z.land entry 1) <> 0)) ,
  TT && emp 
|--
  “ (allocid_entry_scan_inv bytes index (id + 1 ) (unsigned_last_nbits ((Z.shiftr entry 1)) (8)) ) ”
  &&  emp
).

Definition AllocId_entail_wit_6_split_goal_1 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (end: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH3 : (0 <= index)) (PreH4 : (index < end)) (PreH5 : ((Znth (index) (bytes) (0)) <> 255)) (PreH6 : (allocid_index_scan_inv bytes index )) (PreH7 : (allocid_entry_scan_inv bytes index id entry )) (PreH8 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH9 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH10 : ((Z.land entry 1) <> 0)) ,
  (allocid_entry_scan_inv bytes index (id + 1 ) (unsigned_last_nbits ((Z.shiftr entry 1)) (8)) )
.

Definition AllocId_return_wit_1 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (end: Z) (PreH1 : (id < (idmax (sm)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index)) (PreH5 : (index < end)) (PreH6 : ((Znth (index) (bytes) (0)) <> 255)) (PreH7 : (allocid_index_scan_inv bytes index )) (PreH8 : (allocid_entry_scan_inv bytes index id entry )) (PreH9 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH10 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH11 : ((Z.land entry 1) = 0)) ,
  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) (replace_Znth (index) ((Z.lor (unsigned_last_nbits ((Znth index bytes 0)) (8)) (unsigned_last_nbits ((Z.shiftl 1 (id % ( 8 ) ))) (8)))) (bytes)) )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  (“ (id = (-1)) ” 
  &&  “ (idmanager_full sm before ) ”
  &&  (OSHeap (store_idmanager (sm) (before) (manager_pre)) ))
  ||
  (“ (idmanager_min_free_id sm before id ) ”
  &&  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (id)) ))
.

Definition AllocId_return_wit_2 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (end: Z) (PreH1 : (id >= (idmax (sm)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index)) (PreH5 : (index < end)) (PreH6 : ((Znth (index) (bytes) (0)) <> 255)) (PreH7 : (allocid_index_scan_inv bytes index )) (PreH8 : (allocid_entry_scan_inv bytes index id entry )) (PreH9 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH10 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH11 : ((Z.land entry 1) = 0)) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  (“ ((-1) = (-1)) ” 
  &&  “ (idmanager_full sm before ) ”
  &&  (OSHeap (store_idmanager (sm) (before) (manager_pre)) ))
  ||
  (“ (idmanager_min_free_id sm before (-1) ) ”
  &&  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) ((-1))) ))
.

Definition AllocId_return_wit_3 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (entry: Z) (id: Z) (index: Z) (end: Z) (PreH1 : (index = end)) (PreH2 : (index >= end)) (PreH3 : (manager_pre <> 0)) (PreH4 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index)) (PreH6 : (index <= end)) (PreH7 : (id = 0)) (PreH8 : (entry = 0)) (PreH9 : (allocid_index_scan_inv bytes index )) (PreH10 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH11 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  (“ ((-1) = (-1)) ” 
  &&  “ (idmanager_full sm before ) ”
  &&  (OSHeap (store_idmanager (sm) (before) (manager_pre)) ))
  ||
  (“ (idmanager_min_free_id sm before (-1) ) ”
  &&  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) ((-1))) ))
.

Definition AllocId_partial_solve_wit_1 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (entry: Z) (id: Z) (index: Z) (end: Z) (PreH1 : (index < end)) (PreH2 : (manager_pre <> 0)) (PreH3 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index)) (PreH5 : (index <= end)) (PreH6 : (id = 0)) (PreH7 : (entry = 0)) (PreH8 : (allocid_index_scan_inv bytes index )) (PreH9 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH10 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (index < end) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (end = (((idmax (sm)) + 7 ) ÷ 8 )) ” 
  &&  “ (0 <= index) ” 
  &&  “ (index <= end) ” 
  &&  “ (id = 0) ” 
  &&  “ (entry = 0) ” 
  &&  “ (allocid_index_scan_inv bytes index ) ” 
  &&  “ (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes ) ” 
  &&  “ (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) ) ”
  &&  ((((id_map (sm)) + (index * sizeof(UCHAR)))) # UChar  |-> (Znth index bytes 0))
  **  (UCharArray.missing_i (id_map (sm)) index 0 (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
.

Definition AllocId_partial_solve_wit_2 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (entry: Z) (id: Z) (index: Z) (end: Z) (PreH1 : (index <> end)) (PreH2 : ((Znth index bytes 0) <> 255)) (PreH3 : (index < end)) (PreH4 : (manager_pre <> 0)) (PreH5 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH6 : (0 <= index)) (PreH7 : (index <= end)) (PreH8 : (id = 0)) (PreH9 : (entry = 0)) (PreH10 : (allocid_index_scan_inv bytes index )) (PreH11 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH12 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (index <> end) ” 
  &&  “ ((Znth index bytes 0) <> 255) ” 
  &&  “ (index < end) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (end = (((idmax (sm)) + 7 ) ÷ 8 )) ” 
  &&  “ (0 <= index) ” 
  &&  “ (index <= end) ” 
  &&  “ (id = 0) ” 
  &&  “ (entry = 0) ” 
  &&  “ (allocid_index_scan_inv bytes index ) ” 
  &&  “ (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes ) ” 
  &&  “ (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) ) ”
  &&  ((((id_map (sm)) + (index * sizeof(UCHAR)))) # UChar  |-> (Znth index bytes 0))
  **  (UCharArray.missing_i (id_map (sm)) index 0 (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
.

Definition AllocId_partial_solve_wit_3 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (end: Z) (PreH1 : (id < (idmax (sm)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index)) (PreH5 : (index < end)) (PreH6 : ((Znth (index) (bytes) (0)) <> 255)) (PreH7 : (allocid_index_scan_inv bytes index )) (PreH8 : (allocid_entry_scan_inv bytes index id entry )) (PreH9 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH10 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH11 : ((Z.land entry 1) = 0)) ,
  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (id < (idmax (sm))) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (end = (((idmax (sm)) + 7 ) ÷ 8 )) ” 
  &&  “ (0 <= index) ” 
  &&  “ (index < end) ” 
  &&  “ ((Znth (index) (bytes) (0)) <> 255) ” 
  &&  “ (allocid_index_scan_inv bytes index ) ” 
  &&  “ (allocid_entry_scan_inv bytes index id entry ) ” 
  &&  “ (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes ) ” 
  &&  “ (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) ) ” 
  &&  “ ((Z.land entry 1) = 0) ”
  &&  ((((id_map (sm)) + (index * sizeof(UCHAR)))) # UChar  |-> (Znth index bytes 0))
  **  (UCharArray.missing_i (id_map (sm)) index 0 (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
.

Definition AllocId_partial_solve_wit_4 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (end: Z) (PreH1 : (id < (idmax (sm)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index)) (PreH5 : (index < end)) (PreH6 : ((Znth (index) (bytes) (0)) <> 255)) (PreH7 : (allocid_index_scan_inv bytes index )) (PreH8 : (allocid_entry_scan_inv bytes index id entry )) (PreH9 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH10 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH11 : ((Z.land entry 1) = 0)) ,
  (UCharArray.full (id_map (sm)) (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
|--
  “ (id < (idmax (sm))) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (end = (((idmax (sm)) + 7 ) ÷ 8 )) ” 
  &&  “ (0 <= index) ” 
  &&  “ (index < end) ” 
  &&  “ ((Znth (index) (bytes) (0)) <> 255) ” 
  &&  “ (allocid_index_scan_inv bytes index ) ” 
  &&  “ (allocid_entry_scan_inv bytes index id entry ) ” 
  &&  “ (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes ) ” 
  &&  “ (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) ) ” 
  &&  “ ((Z.land entry 1) = 0) ”
  &&  ((((id_map (sm)) + (index * sizeof(UCHAR)))) # UChar  |->_)
  **  (UCharArray.missing_i (id_map (sm)) index 0 (((idmax (sm)) + 7 ) ÷ 8 ) bytes )
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_max")) # UShort  |-> (idmax (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "hoffset")) # UShort  |-> (hoffset (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "id_map")) # Ptr  |-> (id_map (sm)))
  **  ((&((manager_pre)  # "IdManager" ->ₛ "htable")) # Ptr  |-> (htable (sm)))
  **  (OSHeap (store_idbuckets ((htable (sm))) ((hoffset (sm))) ((idbuckets (before)))) )
.

Module Type VC_Correct.


Axiom proof_of_AllocId_safety_wit_1 : AllocId_safety_wit_1.
Axiom proof_of_AllocId_safety_wit_2 : AllocId_safety_wit_2.
Axiom proof_of_AllocId_safety_wit_3 : AllocId_safety_wit_3.
Axiom proof_of_AllocId_safety_wit_4 : AllocId_safety_wit_4.
Axiom proof_of_AllocId_safety_wit_5 : AllocId_safety_wit_5.
Axiom proof_of_AllocId_safety_wit_6 : AllocId_safety_wit_6.
Axiom proof_of_AllocId_safety_wit_7 : AllocId_safety_wit_7.
Axiom proof_of_AllocId_safety_wit_8 : AllocId_safety_wit_8.
Axiom proof_of_AllocId_safety_wit_9 : AllocId_safety_wit_9.
Axiom proof_of_AllocId_safety_wit_10 : AllocId_safety_wit_10.
Axiom proof_of_AllocId_safety_wit_11 : AllocId_safety_wit_11.
Axiom proof_of_AllocId_safety_wit_12 : AllocId_safety_wit_12.
Axiom proof_of_AllocId_safety_wit_13 : AllocId_safety_wit_13.
Axiom proof_of_AllocId_safety_wit_14 : AllocId_safety_wit_14.
Axiom proof_of_AllocId_safety_wit_15 : AllocId_safety_wit_15.
Axiom proof_of_AllocId_safety_wit_16 : AllocId_safety_wit_16.
Axiom proof_of_AllocId_safety_wit_17 : AllocId_safety_wit_17.
Axiom proof_of_AllocId_safety_wit_18 : AllocId_safety_wit_18.
Axiom proof_of_AllocId_safety_wit_19 : AllocId_safety_wit_19.
Axiom proof_of_AllocId_safety_wit_20 : AllocId_safety_wit_20.
Axiom proof_of_AllocId_safety_wit_21 : AllocId_safety_wit_21.
Axiom proof_of_AllocId_safety_wit_22 : AllocId_safety_wit_22.
Axiom proof_of_AllocId_safety_wit_23 : AllocId_safety_wit_23.
Axiom proof_of_AllocId_safety_wit_24 : AllocId_safety_wit_24.
Axiom proof_of_AllocId_safety_wit_25 : AllocId_safety_wit_25.
Axiom proof_of_AllocId_safety_wit_26 : AllocId_safety_wit_26.
Axiom proof_of_AllocId_safety_wit_27 : AllocId_safety_wit_27.
Axiom proof_of_AllocId_safety_wit_28 : AllocId_safety_wit_28.
Axiom proof_of_AllocId_safety_wit_29 : AllocId_safety_wit_29.
Axiom proof_of_AllocId_safety_wit_30 : AllocId_safety_wit_30.
Axiom proof_of_AllocId_entail_wit_1 : AllocId_entail_wit_1.
Axiom proof_of_AllocId_entail_wit_2 : AllocId_entail_wit_2.
Axiom proof_of_AllocId_entail_wit_3 : AllocId_entail_wit_3.
Axiom proof_of_AllocId_entail_wit_4 : AllocId_entail_wit_4.
Axiom proof_of_AllocId_entail_wit_5 : AllocId_entail_wit_5.
Axiom proof_of_AllocId_entail_wit_6 : AllocId_entail_wit_6.
Axiom proof_of_AllocId_return_wit_1 : AllocId_return_wit_1.
Axiom proof_of_AllocId_return_wit_2 : AllocId_return_wit_2.
Axiom proof_of_AllocId_return_wit_3 : AllocId_return_wit_3.
Axiom proof_of_AllocId_partial_solve_wit_1 : AllocId_partial_solve_wit_1.
Axiom proof_of_AllocId_partial_solve_wit_2 : AllocId_partial_solve_wit_2.
Axiom proof_of_AllocId_partial_solve_wit_3 : AllocId_partial_solve_wit_3.
Axiom proof_of_AllocId_partial_solve_wit_4 : AllocId_partial_solve_wit_4.

End VC_Correct.
