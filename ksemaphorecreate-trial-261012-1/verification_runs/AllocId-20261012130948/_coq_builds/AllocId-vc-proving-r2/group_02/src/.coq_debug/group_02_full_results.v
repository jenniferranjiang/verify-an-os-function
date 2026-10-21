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

Definition AllocId_return_wit_2 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (id: Z) (entry: Z) (index: Z) (qcp_local_end: Z) (PreH1 : (id >= (idmax (sm)))) (PreH2 : (manager_pre <> 0)) (PreH3 : (qcp_local_end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH4 : (0 <= index)) (PreH5 : (index < qcp_local_end)) (PreH6 : ((Znth (index) (bytes) (0)) <> 255)) (PreH7 : (allocid_index_scan_inv bytes index )) (PreH8 : (allocid_entry_scan_inv bytes index id entry )) (PreH9 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH10 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) (PreH11 : ((Z.land entry 1) = 0)) ,
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

Lemma probe2 : AllocId_return_wit_2.
Proof.
Abort.
Definition AllocId_return_wit_3 := 
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (bytes: (@list Z)) (entry: Z) (id: Z) (index: Z) (qcp_local_end: Z) (PreH1 : (index = qcp_local_end)) (PreH2 : (index >= qcp_local_end)) (PreH3 : (manager_pre <> 0)) (PreH4 : (qcp_local_end = (((idmax (sm)) + 7 ) ÷ 8 ))) (PreH5 : (0 <= index)) (PreH6 : (index <= qcp_local_end)) (PreH7 : (id = 0)) (PreH8 : (entry = 0)) (PreH9 : (allocid_index_scan_inv bytes index )) (PreH10 : (id_map_bytes_ok (idmax (sm)) (idlist (before)) bytes )) (PreH11 : (idbuckets_ok (idmax (sm)) (hoffset (sm)) (idlist (before)) (idbuckets (before)) )) ,
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

Lemma probe3 : AllocId_return_wit_3.
Proof.
Abort.
