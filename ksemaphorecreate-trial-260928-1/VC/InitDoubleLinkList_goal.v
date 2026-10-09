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
Require Import CRTOS_Verify.sem.SemaphoreRep.
Require Import CRTOS_Verify.VC.SemaphoreProofLocal.
Local Open Scope sac.

(*----- Function InitDoubleLinkList -----*)

Definition InitDoubleLinkList_return_wit_1 := 
(
forall (linklist_head_pre: Z) (PreH1 : (linklist_head_pre <> 0)) ,
  ((&((linklist_head_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> linklist_head_pre)
  **  ((&((linklist_head_pre)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> linklist_head_pre)
|--
  (store_sem_dll semaphore_unit_empty linklist_head_pre (@nil (@SemDLNode unit)) )
) \/
(
forall (linklist_head_pre: Z) (PreH1 : (linklist_head_pre <> 0)) ,
  ((&((linklist_head_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> linklist_head_pre)
  **  ((&((linklist_head_pre)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> linklist_head_pre)
|--
  (store_sem_dll semaphore_unit_empty linklist_head_pre (@nil (@SemDLNode unit)) )
).

Definition InitDoubleLinkList_return_wit_1_split_goal_spatial := 
forall (linklist_head_pre: Z) (PreH1 : (linklist_head_pre <> 0)) ,
  ((&((linklist_head_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> linklist_head_pre)
  **  ((&((linklist_head_pre)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> linklist_head_pre)
|--
  (store_sem_dll semaphore_unit_empty linklist_head_pre (@nil (@SemDLNode unit)) )
.

Module Type VC_Correct.


Axiom proof_of_InitDoubleLinkList_return_wit_1 : InitDoubleLinkList_return_wit_1.

End VC_Correct.
