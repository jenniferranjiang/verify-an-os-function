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
From CRTOS_Verify.VC Require Import AllocId_goal.
From CRTOS_Verify.VC Require Import AllocId_proof_auto.
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


Lemma test : (
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (entry: Z) (id: Z) (qcp_local_end: Z) (index: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (index = 0)) (PreH3 : (qcp_local_end = 0)) (PreH4 : (id = 0)) (PreH5 : (entry = 0)) ,
  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
|--
  EX (bytes: (@list Z)) ,
  “ (manager_pre <> 0) ” 
  &&  “ (index = 0) ” 
  &&  “ (qcp_local_end = 0) ” 
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
forall (manager_pre: Z) (before: VarIdmanager) (sm: StableIdmanager) (entry: Z) (id: Z) (qcp_local_end: Z) (index: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (index = 0)) (PreH3 : (qcp_local_end = 0)) (PreH4 : (id = 0)) (PreH5 : (entry = 0)) ,
  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
|--
  EX (bytes: (@list Z)) ,
  “ (manager_pre <> 0) ” 
  &&  “ (index = 0) ” 
  &&  “ (qcp_local_end = 0) ” 
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
Proof.
