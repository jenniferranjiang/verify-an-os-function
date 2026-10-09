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

(*----- Function DoubleLinkListInsertNodeAfter -----*)

Definition DoubleLinkListInsertNodeAfter_return_wit_1 := 
(
forall (A: Type) (linklist_node_pre: Z) (linklist_pre: Z) (nodes: (@list (@SemDLNode A))) (payload: A) (store_payload: (Z -> (A -> Assertion))) (PreH1 : (linklist_pre <> 0)) (PreH2 : (linklist_node_pre <> 0)) ,
  ((&((linklist_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> linklist_node_pre)
  **  ((&(((sem_dll_front (linklist_pre) (nodes)))  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> linklist_node_pre)
  **  (store_sem_dll_insert_rest store_payload linklist_pre nodes )
  **  (store_payload linklist_node_pre payload )
  **  ((&((linklist_node_pre)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> linklist_pre)
  **  ((&((linklist_node_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> (sem_dll_front (linklist_pre) (nodes)))
|--
  (store_sem_dll store_payload linklist_pre (cons ((Build_SemDLNode (payload) (linklist_node_pre))) (nodes)) )
) \/
(
forall (A: Type) (linklist_node_pre: Z) (linklist_pre: Z) (nodes: (@list (@SemDLNode A))) (payload: A) (store_payload: (Z -> (A -> Assertion))) (PreH1 : (linklist_pre <> 0)) (PreH2 : (linklist_node_pre <> 0)) ,
  ((&((linklist_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> linklist_node_pre)
  **  ((&(((sem_dll_front (linklist_pre) (nodes)))  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> linklist_node_pre)
  **  (store_sem_dll_insert_rest store_payload linklist_pre nodes )
  **  (store_payload linklist_node_pre payload )
  **  ((&((linklist_node_pre)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> linklist_pre)
  **  ((&((linklist_node_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> (sem_dll_front (linklist_pre) (nodes)))
|--
  (store_sem_dll store_payload linklist_pre (cons ((Build_SemDLNode (payload) (linklist_node_pre))) (nodes)) )
).

Definition DoubleLinkListInsertNodeAfter_return_wit_1_split_goal_spatial := 
forall (A: Type) (linklist_node_pre: Z) (linklist_pre: Z) (nodes: (@list (@SemDLNode A))) (payload: A) (store_payload: (Z -> (A -> Assertion))) (PreH1 : (linklist_pre <> 0)) (PreH2 : (linklist_node_pre <> 0)) ,
  ((&((linklist_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> linklist_node_pre)
  **  ((&(((sem_dll_front (linklist_pre) (nodes)))  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> linklist_node_pre)
  **  (store_sem_dll_insert_rest store_payload linklist_pre nodes )
  **  (store_payload linklist_node_pre payload )
  **  ((&((linklist_node_pre)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> linklist_pre)
  **  ((&((linklist_node_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> (sem_dll_front (linklist_pre) (nodes)))
|--
  (store_sem_dll store_payload linklist_pre (cons ((Build_SemDLNode (payload) (linklist_node_pre))) (nodes)) )
.

Definition DoubleLinkListInsertNodeAfter_partial_solve_wit_1 := 
forall (A: Type) (linklist_node_pre: Z) (linklist_pre: Z) (nodes: (@list (@SemDLNode A))) (payload: A) (store_payload: (Z -> (A -> Assertion))) (PreH1 : (linklist_node_pre <> 0)) ,
  (store_sem_dll store_payload linklist_pre nodes )
  **  (store_sem_standalone_node store_payload linklist_node_pre payload )
|--
  “ (linklist_node_pre <> 0) ”
  &&  (store_sem_dll store_payload linklist_pre nodes )
  **  (store_sem_standalone_node store_payload linklist_node_pre payload )
.

Definition DoubleLinkListInsertNodeAfter_which_implies_wit_1 := 
(
forall (A: Type) (nodes: (@list (@SemDLNode A))) (payload: A) (store_payload: (Z -> (A -> Assertion))) (linklist: Z) (linklist_node: Z) ,
  (store_sem_dll store_payload linklist nodes )
  **  (store_sem_standalone_node store_payload linklist_node payload )
|--
  “ (linklist <> 0) ”
  &&  ((&((linklist)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> (sem_dll_front (linklist) (nodes)))
  **  ((&(((sem_dll_front (linklist) (nodes)))  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> linklist)
  **  (store_sem_dll_insert_rest store_payload linklist nodes )
  **  (store_payload linklist_node payload )
  **  ((&((linklist_node)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |->_)
  **  ((&((linklist_node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |->_)
) \/
(
forall (A: Type) (nodes: (@list (@SemDLNode A))) (payload: A) (store_payload: (Z -> (A -> Assertion))) (linklist: Z) (linklist_node: Z) ,
  (store_sem_dll store_payload linklist nodes )
  **  (store_sem_standalone_node store_payload linklist_node payload )
|--
  EX (x_2: Z)  (x: Z) ,
  “ (linklist <> 0) ”
  &&  ((&((linklist_node)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> x_2)
  **  ((&((linklist_node)  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> x)
  **  ((&((linklist)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> (sem_dll_front (linklist) (nodes)))
  **  ((&(((sem_dll_front (linklist) (nodes)))  # "SysDoubleLinklistNode" ->ₛ "node_prev")) # Ptr  |-> linklist)
  **  (store_sem_dll_insert_rest store_payload linklist nodes )
  **  (store_payload linklist_node payload )
).

Module Type VC_Correct.


Axiom proof_of_DoubleLinkListInsertNodeAfter_return_wit_1 : DoubleLinkListInsertNodeAfter_return_wit_1.
Axiom proof_of_DoubleLinkListInsertNodeAfter_partial_solve_wit_1 : DoubleLinkListInsertNodeAfter_partial_solve_wit_1.
Axiom proof_of_DoubleLinkListInsertNodeAfter_which_implies_wit_1 : DoubleLinkListInsertNodeAfter_which_implies_wit_1.

End VC_Correct.
