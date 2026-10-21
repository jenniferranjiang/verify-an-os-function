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

(*----- Function IdInsertObj -----*)

Definition IdInsertObj_safety_wit_1 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (PreH1 : (manager_pre <> 0)) (PreH2 : (idnode_pre <> 0)) ,
  ((( &( "id" ) )) # Int  |->_)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition IdInsertObj_safety_wit_2 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (PreH1 : (manager_pre <> 0)) (PreH2 : (idnode_pre <> 0)) ,
  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition IdInsertObj_safety_wit_3 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (PreH1 : (manager_pre = 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (idnode_pre <> 0)) ,
  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
|--
  “ False ”
.

Definition IdInsertObj_safety_wit_4 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (idnode_pre <> 0)) (PreH3 : (id = 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition IdInsertObj_safety_wit_5 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (idnode_pre <> 0)) (PreH3 : (id = 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition IdInsertObj_safety_wit_6 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (PreH1 : (idnode_pre = 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (idnode_pre <> 0)) (PreH4 : (id = 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
|--
  “ False ”
.

Definition IdInsertObj_safety_wit_7 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (idnode_pre <> 0)) (PreH3 : (id = 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition IdInsertObj_safety_wit_8 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (retval: Z) (PreH1 : (retval = (-1))) (PreH2 : (idmanager_full sm before )) (PreH3 : (manager_pre <> 0)) (PreH4 : (idnode_pre <> 0)) (PreH5 : (id = 0)) ,
  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition IdInsertObj_safety_wit_9 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (retval: Z) (PreH1 : (idmanager_min_free_id sm before retval )) (PreH2 : (manager_pre <> 0)) (PreH3 : (idnode_pre <> 0)) (PreH4 : (id = 0)) ,
  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (retval)) )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition IdInsertObj_safety_wit_10 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (retval: Z) (PreH1 : (retval >= 0)) (PreH2 : (retval = (-1))) (PreH3 : (idmanager_full sm before )) (PreH4 : (manager_pre <> 0)) (PreH5 : (idnode_pre <> 0)) (PreH6 : (id = 0)) ,
  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
|--
  “ False ”
.

Definition IdInsertObj_safety_wit_11 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (retval: Z) (PreH1 : (retval < 0)) (PreH2 : (idmanager_min_free_id sm before retval )) (PreH3 : (manager_pre <> 0)) (PreH4 : (idnode_pre <> 0)) (PreH5 : (id = 0)) ,
  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (retval)) )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
|--
  “ (1 <> (INT_MIN)) ”
.

Definition IdInsertObj_safety_wit_12 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (retval: Z) (PreH1 : (retval < 0)) (PreH2 : (retval = (-1))) (PreH3 : (idmanager_full sm before )) (PreH4 : (manager_pre <> 0)) (PreH5 : (idnode_pre <> 0)) (PreH6 : (id = 0)) ,
  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
|--
  “ (1 <> (INT_MIN)) ”
.

Definition IdInsertObj_safety_wit_13 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (retval: Z) (PreH1 : (retval < 0)) (PreH2 : (retval = (-1))) (PreH3 : (idmanager_full sm before )) (PreH4 : (manager_pre <> 0)) (PreH5 : (idnode_pre <> 0)) (PreH6 : (id = 0)) ,
  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition IdInsertObj_safety_wit_14 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (retval: Z) (PreH1 : (retval < 0)) (PreH2 : (idmanager_min_free_id sm before retval )) (PreH3 : (manager_pre <> 0)) (PreH4 : (idnode_pre <> 0)) (PreH5 : (id = 0)) ,
  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (retval)) )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition IdInsertObj_entail_wit_1 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (PreH1 : (manager_pre <> 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (idnode_pre <> 0)) ,
  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
|--
  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (0 = 0) ”
  &&  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
.

Definition IdInsertObj_entail_wit_2 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (PreH1 : (idnode_pre <> 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (idnode_pre <> 0)) (PreH4 : (id = 0)) ,
  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
|--
  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (id = 0) ”
  &&  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
.

Definition IdInsertObj_entail_wit_3 := 
(
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (retval: Z) (PreH1 : (retval >= 0)) (PreH2 : (idmanager_min_free_id sm before retval )) (PreH3 : (manager_pre <> 0)) (PreH4 : (idnode_pre <> 0)) (PreH5 : (id = 0)) ,
  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (retval)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
|--
  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ” 
  &&  “ (idmanager_min_free_id sm before retval ) ” 
  &&  “ (0 <= retval) ” 
  &&  “ (retval <= 65535) ”
  &&  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (retval)) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> old_id)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> previous)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> next)
) \/
(
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (retval: Z) (PreH1 : (retval >= 0)) (PreH2 : (idmanager_min_free_id sm before retval )) (PreH3 : (manager_pre <> 0)) (PreH4 : (idnode_pre <> 0)) (PreH5 : (id = 0)) ,
  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (retval)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
|--
  “ (retval <= 65535) ” 
  &&  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ”
  &&  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (retval)) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> old_id)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> previous)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> next)
).

Definition IdInsertObj_entail_wit_3_split_goal_1 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (retval: Z) (PreH1 : (retval >= 0)) (PreH2 : (idmanager_min_free_id sm before retval )) (PreH3 : (manager_pre <> 0)) (PreH4 : (idnode_pre <> 0)) (PreH5 : (id = 0)) ,
  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (retval)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
|--
  “ (retval <= 65535) ”
.

Definition IdInsertObj_entail_wit_3_split_goal_2 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (retval: Z) (PreH1 : (retval >= 0)) (PreH2 : (idmanager_min_free_id sm before retval )) (PreH3 : (manager_pre <> 0)) (PreH4 : (idnode_pre <> 0)) (PreH5 : (id = 0)) ,
  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (retval)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
|--
  “ (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0) ”
.

Definition IdInsertObj_entail_wit_3_split_goal_spatial := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (retval: Z) (PreH1 : (retval >= 0)) (PreH2 : (idmanager_min_free_id sm before retval )) (PreH3 : (manager_pre <> 0)) (PreH4 : (idnode_pre <> 0)) (PreH5 : (id = 0)) ,
  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (retval)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
|--
  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (retval)) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> old_id)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> previous)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> next)
.

Definition IdInsertObj_entail_wit_4 := 
(
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (idnode_pre <> 0)) (PreH3 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH4 : (idmanager_min_free_id sm before id )) (PreH5 : (0 <= id)) (PreH6 : (id <= 65535)) ,
  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (id)) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> previous)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> next)
|--
  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (idmanager_min_free_id sm before id ) ”
  &&  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (id)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (id) (previous) (next)) )
) \/
(
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (idnode_pre <> 0)) (PreH3 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH4 : (idmanager_min_free_id sm before id )) (PreH5 : (0 <= id)) (PreH6 : (id <= 65535)) ,
  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (id)) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> previous)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> next)
|--
  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (id)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (id) (previous) (next)) )
).

Definition IdInsertObj_entail_wit_4_split_goal_spatial := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (idnode_pre <> 0)) (PreH3 : (&((idnode_pre)  # "IdNode" ->ₛ "link") <> 0)) (PreH4 : (idmanager_min_free_id sm before id )) (PreH5 : (0 <= id)) (PreH6 : (id <= 65535)) ,
  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (id)) )
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> id)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> previous)
  **  ((&((idnode_pre)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> next)
|--
  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (id)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (id) (previous) (next)) )
.

Definition IdInsertObj_return_wit_1 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (idnode_pre <> 0)) (PreH3 : (idmanager_min_free_id sm before id )) ,
  (OSHeap (store_idmanager (sm) ((idmanager_link (sm) ((idmanager_add (before) (id))) (id) (idnode_pre))) (manager_pre)) )
|--
  (“ (id = (-1)) ” 
  &&  “ (idmanager_full sm before ) ”
  &&  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) ))
  ||
  (“ (idmanager_min_free_id sm before id ) ”
  &&  (OSHeap (store_idmanager (sm) ((idmanager_link (sm) ((idmanager_add (before) (id))) (id) (idnode_pre))) (manager_pre)) ))
.

Definition IdInsertObj_return_wit_2 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (retval: Z) (PreH1 : (retval < 0)) (PreH2 : (retval = (-1))) (PreH3 : (idmanager_full sm before )) (PreH4 : (manager_pre <> 0)) (PreH5 : (idnode_pre <> 0)) (PreH6 : (id = 0)) ,
  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
|--
  (“ ((-1) = (-1)) ” 
  &&  “ (idmanager_full sm before ) ”
  &&  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) ))
  ||
  (“ (idmanager_min_free_id sm before (-1) ) ”
  &&  (OSHeap (store_idmanager (sm) ((idmanager_link (sm) ((idmanager_add (before) ((-1)))) ((-1)) (idnode_pre))) (manager_pre)) ))
.

Definition IdInsertObj_return_wit_3 := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (retval: Z) (PreH1 : (retval < 0)) (PreH2 : (idmanager_min_free_id sm before retval )) (PreH3 : (manager_pre <> 0)) (PreH4 : (idnode_pre <> 0)) (PreH5 : (id = 0)) ,
  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (retval)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
|--
  (“ ((-1) = (-1)) ” 
  &&  “ (idmanager_full sm before ) ”
  &&  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) ))
  ||
  (“ (idmanager_min_free_id sm before (-1) ) ”
  &&  (OSHeap (store_idmanager (sm) ((idmanager_link (sm) ((idmanager_add (before) ((-1)))) ((-1)) (idnode_pre))) (manager_pre)) ))
.

Definition IdInsertObj_partial_solve_wit_1_pure := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (idnode_pre <> 0)) (PreH3 : (id = 0)) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
|--
  “ (manager_pre <> 0) ”
.

Definition IdInsertObj_partial_solve_wit_1_aux := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (old_id: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (idnode_pre <> 0)) (PreH3 : (id = 0)) ,
  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
|--
  “ (manager_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (id = 0) ”
  &&  (OSHeap (store_idmanager (sm) (before) (manager_pre)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (old_id) (previous) (next)) )
.

Definition IdInsertObj_partial_solve_wit_1 := IdInsertObj_partial_solve_wit_1_pure -> IdInsertObj_partial_solve_wit_1_aux.

Definition IdInsertObj_partial_solve_wit_2_pure := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (idnode_pre <> 0)) (PreH3 : (idmanager_min_free_id sm before id )) ,
  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  ((( &( "id" ) )) # Int  |-> id)
  **  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (id)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (id) (previous) (next)) )
|--
  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ”
.

Definition IdInsertObj_partial_solve_wit_2_aux := 
forall (idnode_pre: Z) (manager_pre: Z) (next: Z) (previous: Z) (before: VarIdmanager) (sm: StableIdmanager) (id: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (idnode_pre <> 0)) (PreH3 : (idmanager_min_free_id sm before id )) ,
  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (id)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (id) (previous) (next)) )
|--
  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (idmanager_min_free_id sm before id ) ”
  &&  (OSHeap (store_idmanager_allocated_unlinked (sm) (before) (manager_pre) (id)) )
  **  (OSHeap (store_sem_id_detached (idnode_pre) (id) (previous) (next)) )
.

Definition IdInsertObj_partial_solve_wit_2 := IdInsertObj_partial_solve_wit_2_pure -> IdInsertObj_partial_solve_wit_2_aux.

Module Type VC_Correct.


Axiom proof_of_IdInsertObj_safety_wit_1 : IdInsertObj_safety_wit_1.
Axiom proof_of_IdInsertObj_safety_wit_2 : IdInsertObj_safety_wit_2.
Axiom proof_of_IdInsertObj_safety_wit_3 : IdInsertObj_safety_wit_3.
Axiom proof_of_IdInsertObj_safety_wit_4 : IdInsertObj_safety_wit_4.
Axiom proof_of_IdInsertObj_safety_wit_5 : IdInsertObj_safety_wit_5.
Axiom proof_of_IdInsertObj_safety_wit_6 : IdInsertObj_safety_wit_6.
Axiom proof_of_IdInsertObj_safety_wit_7 : IdInsertObj_safety_wit_7.
Axiom proof_of_IdInsertObj_safety_wit_8 : IdInsertObj_safety_wit_8.
Axiom proof_of_IdInsertObj_safety_wit_9 : IdInsertObj_safety_wit_9.
Axiom proof_of_IdInsertObj_safety_wit_10 : IdInsertObj_safety_wit_10.
Axiom proof_of_IdInsertObj_safety_wit_11 : IdInsertObj_safety_wit_11.
Axiom proof_of_IdInsertObj_safety_wit_12 : IdInsertObj_safety_wit_12.
Axiom proof_of_IdInsertObj_safety_wit_13 : IdInsertObj_safety_wit_13.
Axiom proof_of_IdInsertObj_safety_wit_14 : IdInsertObj_safety_wit_14.
Axiom proof_of_IdInsertObj_entail_wit_1 : IdInsertObj_entail_wit_1.
Axiom proof_of_IdInsertObj_entail_wit_2 : IdInsertObj_entail_wit_2.
Axiom proof_of_IdInsertObj_entail_wit_3 : IdInsertObj_entail_wit_3.
Axiom proof_of_IdInsertObj_entail_wit_4 : IdInsertObj_entail_wit_4.
Axiom proof_of_IdInsertObj_return_wit_1 : IdInsertObj_return_wit_1.
Axiom proof_of_IdInsertObj_return_wit_2 : IdInsertObj_return_wit_2.
Axiom proof_of_IdInsertObj_return_wit_3 : IdInsertObj_return_wit_3.
Axiom proof_of_IdInsertObj_partial_solve_wit_1_pure : IdInsertObj_partial_solve_wit_1_pure.
Axiom proof_of_IdInsertObj_partial_solve_wit_1 : IdInsertObj_partial_solve_wit_1.
Axiom proof_of_IdInsertObj_partial_solve_wit_2_pure : IdInsertObj_partial_solve_wit_2_pure.
Axiom proof_of_IdInsertObj_partial_solve_wit_2 : IdInsertObj_partial_solve_wit_2.

End VC_Correct.
