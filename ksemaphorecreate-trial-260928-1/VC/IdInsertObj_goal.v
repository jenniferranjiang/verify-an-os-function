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
Require Import CRTOS_Verify.sem.SemaphorePure.
Require Import CRTOS_Verify.sem.SemaphoreRep.
Require Import CRTOS_Verify.VC.SemaphoreProofLocal.
Local Open Scope sac.

(*----- Function IdInsertObj -----*)

Definition IdInsertObj_safety_wit_1 := 
forall (idnode_pre: Z) (manager_pre: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (manager_pre <> 0)) (PreH2 : (idnode_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (semaphore_layout_32_ok sem )) (PreH5 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH6 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((( &( "id" ) )) # Int  |->_)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (store_semaphore_id_manager stable before )
  **  (store_sem_id_node_zeroed sem )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition IdInsertObj_safety_wit_2 := 
forall (idnode_pre: Z) (manager_pre: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (manager_pre <> 0)) (PreH2 : (idnode_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (semaphore_layout_32_ok sem )) (PreH5 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH6 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (store_semaphore_id_manager stable before )
  **  (store_sem_id_node_zeroed sem )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition IdInsertObj_safety_wit_3 := 
forall (idnode_pre: Z) (manager_pre: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (manager_pre = 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (idnode_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (semaphore_layout_32_ok sem )) (PreH6 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH7 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (store_semaphore_id_manager stable before )
  **  (store_sem_id_node_zeroed sem )
|--
  “ False ”
.

Definition IdInsertObj_safety_wit_4 := 
forall (idnode_pre: Z) (manager_pre: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (manager_pre <> 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (idnode_pre <> 0)) (PreH4 : (SemaphoreStableContext stable )) (PreH5 : (semaphore_layout_32_ok sem )) (PreH6 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH7 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (store_semaphore_id_manager stable before )
  **  (store_sem_id_node_zeroed sem )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition IdInsertObj_safety_wit_5 := 
forall (idnode_pre: Z) (manager_pre: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (idnode_pre = 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (manager_pre <> 0)) (PreH4 : (idnode_pre <> 0)) (PreH5 : (SemaphoreStableContext stable )) (PreH6 : (semaphore_layout_32_ok sem )) (PreH7 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH8 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (store_semaphore_id_manager stable before )
  **  (store_sem_id_node_zeroed sem )
|--
  “ False ”
.

Definition IdInsertObj_safety_wit_6 := 
forall (idnode_pre: Z) (manager_pre: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (retval: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (SemaphoreStableContext stable )) (PreH3 : (0 <= retval)) (PreH4 : ((semaphore_first_free (stable) (before)) = (Some (retval)))) (PreH5 : (idnode_pre <> 0)) (PreH6 : (manager_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (idnode_pre <> 0)) (PreH9 : (SemaphoreStableContext stable )) (PreH10 : (semaphore_layout_32_ok sem )) (PreH11 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH12 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_manager_id_allocated stable before retval )
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (store_sem_id_node_zeroed sem )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition IdInsertObj_safety_wit_7 := 
forall (idnode_pre: Z) (manager_pre: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (retval: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (SemaphoreStableContext stable )) (PreH3 : (retval = (-1))) (PreH4 : ((semaphore_first_free (stable) (before)) = None)) (PreH5 : (idnode_pre <> 0)) (PreH6 : (manager_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (idnode_pre <> 0)) (PreH9 : (SemaphoreStableContext stable )) (PreH10 : (semaphore_layout_32_ok sem )) (PreH11 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH12 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_semaphore_id_manager stable before )
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (store_sem_id_node_zeroed sem )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition IdInsertObj_safety_wit_8 := 
forall (idnode_pre: Z) (manager_pre: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (retval: Z) (PreH1 : (retval < 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (0 <= retval)) (PreH5 : ((semaphore_first_free (stable) (before)) = (Some (retval)))) (PreH6 : (idnode_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (manager_pre <> 0)) (PreH9 : (idnode_pre <> 0)) (PreH10 : (SemaphoreStableContext stable )) (PreH11 : (semaphore_layout_32_ok sem )) (PreH12 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH13 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_manager_id_allocated stable before retval )
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (store_sem_id_node_zeroed sem )
|--
  “ False ”
.

Definition IdInsertObj_safety_wit_9 := 
forall (idnode_pre: Z) (manager_pre: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (retval: Z) (PreH1 : (retval >= 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (retval = (-1))) (PreH5 : ((semaphore_first_free (stable) (before)) = None)) (PreH6 : (idnode_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (manager_pre <> 0)) (PreH9 : (idnode_pre <> 0)) (PreH10 : (SemaphoreStableContext stable )) (PreH11 : (semaphore_layout_32_ok sem )) (PreH12 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH13 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_semaphore_id_manager stable before )
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (store_sem_id_node_zeroed sem )
|--
  “ False ”
.

Definition IdInsertObj_safety_wit_10 := 
forall (idnode_pre: Z) (manager_pre: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (retval: Z) (PreH1 : (retval < 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (retval = (-1))) (PreH5 : ((semaphore_first_free (stable) (before)) = None)) (PreH6 : (idnode_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (manager_pre <> 0)) (PreH9 : (idnode_pre <> 0)) (PreH10 : (SemaphoreStableContext stable )) (PreH11 : (semaphore_layout_32_ok sem )) (PreH12 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH13 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_semaphore_id_manager stable before )
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (store_sem_id_node_zeroed sem )
|--
  “ (1 <> (INT_MIN)) ”
.

Definition IdInsertObj_safety_wit_11 := 
forall (idnode_pre: Z) (manager_pre: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (retval: Z) (PreH1 : (retval < 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (retval = (-1))) (PreH5 : ((semaphore_first_free (stable) (before)) = None)) (PreH6 : (idnode_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (manager_pre <> 0)) (PreH9 : (idnode_pre <> 0)) (PreH10 : (SemaphoreStableContext stable )) (PreH11 : (semaphore_layout_32_ok sem )) (PreH12 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH13 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_semaphore_id_manager stable before )
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (store_sem_id_node_zeroed sem )
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition IdInsertObj_return_wit_1 := 
forall (idnode_pre: Z) (manager_pre: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (retval: Z) (PreH1 : (manager_pre <> 0)) (PreH2 : (idnode_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (semaphore_layout_32_ok sem )) (PreH5 : (retval >= 0)) (PreH6 : (manager_pre <> 0)) (PreH7 : (SemaphoreStableContext stable )) (PreH8 : (0 <= retval)) (PreH9 : ((semaphore_first_free (stable) (before)) = (Some (retval)))) (PreH10 : (idnode_pre <> 0)) (PreH11 : (manager_pre <> 0)) (PreH12 : (manager_pre <> 0)) (PreH13 : (idnode_pre <> 0)) (PreH14 : (SemaphoreStableContext stable )) (PreH15 : (semaphore_layout_32_ok sem )) (PreH16 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH17 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_semaphore_id_manager stable (semaphore_reserve_state (before) (sem) (retval)) )
|--
  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (0 <= retval) ” 
  &&  “ ((semaphore_first_free (stable) (before)) = (Some (retval))) ”
  &&  (store_semaphore_id_manager stable (semaphore_reserve_state (before) (sem) (retval)) )
.

Definition IdInsertObj_return_wit_2 := 
forall (idnode_pre: Z) (manager_pre: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (retval: Z) (PreH1 : (retval < 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (retval = (-1))) (PreH5 : ((semaphore_first_free (stable) (before)) = None)) (PreH6 : (idnode_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (manager_pre <> 0)) (PreH9 : (idnode_pre <> 0)) (PreH10 : (SemaphoreStableContext stable )) (PreH11 : (semaphore_layout_32_ok sem )) (PreH12 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH13 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_semaphore_id_manager stable before )
  **  (store_sem_id_node_zeroed sem )
|--
  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ ((-1) = (-1)) ” 
  &&  “ ((semaphore_first_free (stable) (before)) = None) ”
  &&  (store_semaphore_id_manager stable before )
  **  (store_sem_id_node_zeroed sem )
.

Definition IdInsertObj_partial_solve_wit_1_pure := 
forall (idnode_pre: Z) (manager_pre: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (idnode_pre <> 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (manager_pre <> 0)) (PreH4 : (idnode_pre <> 0)) (PreH5 : (SemaphoreStableContext stable )) (PreH6 : (semaphore_layout_32_ok sem )) (PreH7 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH8 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((( &( "id" ) )) # Int  |-> 0)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (store_semaphore_id_manager stable before )
  **  (store_sem_id_node_zeroed sem )
|--
  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ”
.

Definition IdInsertObj_partial_solve_wit_1_aux := 
forall (idnode_pre: Z) (manager_pre: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (PreH1 : (idnode_pre <> 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (manager_pre <> 0)) (PreH4 : (idnode_pre <> 0)) (PreH5 : (SemaphoreStableContext stable )) (PreH6 : (semaphore_layout_32_ok sem )) (PreH7 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH8 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_semaphore_id_manager stable before )
  **  (store_sem_id_node_zeroed sem )
|--
  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  (store_semaphore_id_manager stable before )
  **  (store_sem_id_node_zeroed sem )
.

Definition IdInsertObj_partial_solve_wit_1 := IdInsertObj_partial_solve_wit_1_pure -> IdInsertObj_partial_solve_wit_1_aux.

Definition IdInsertObj_partial_solve_wit_2_pure := 
forall (idnode_pre: Z) (manager_pre: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (retval: Z) (PreH1 : (retval >= 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (0 <= retval)) (PreH5 : ((semaphore_first_free (stable) (before)) = (Some (retval)))) (PreH6 : (idnode_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (manager_pre <> 0)) (PreH9 : (idnode_pre <> 0)) (PreH10 : (SemaphoreStableContext stable )) (PreH11 : (semaphore_layout_32_ok sem )) (PreH12 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH13 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_manager_id_allocated stable before retval )
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
  **  (store_sem_id_node_zeroed sem )
|--
  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ”
.

Definition IdInsertObj_partial_solve_wit_2_aux := 
forall (idnode_pre: Z) (manager_pre: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (retval: Z) (PreH1 : (retval >= 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (0 <= retval)) (PreH5 : ((semaphore_first_free (stable) (before)) = (Some (retval)))) (PreH6 : (idnode_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (manager_pre <> 0)) (PreH9 : (idnode_pre <> 0)) (PreH10 : (SemaphoreStableContext stable )) (PreH11 : (semaphore_layout_32_ok sem )) (PreH12 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH13 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_manager_id_allocated stable before retval )
  **  (store_sem_id_node_zeroed sem )
|--
  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (retval >= 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (0 <= retval) ” 
  &&  “ ((semaphore_first_free (stable) (before)) = (Some (retval))) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  (store_sem_id_node_zeroed sem )
  **  (store_sem_manager_id_allocated stable before retval )
.

Definition IdInsertObj_partial_solve_wit_2 := IdInsertObj_partial_solve_wit_2_pure -> IdInsertObj_partial_solve_wit_2_aux.

Definition IdInsertObj_partial_solve_wit_3_pure := 
(
forall (idnode_pre: Z) (manager_pre: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (retval: Z) (PreH1 : (retval >= 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (0 <= retval)) (PreH5 : ((semaphore_first_free (stable) (before)) = (Some (retval)))) (PreH6 : (idnode_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (manager_pre <> 0)) (PreH9 : (idnode_pre <> 0)) (PreH10 : (SemaphoreStableContext stable )) (PreH11 : (semaphore_layout_32_ok sem )) (PreH12 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH13 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> (unsigned_last_nbits (retval) (16)))
  **  (store_sem_id_node_zeroed_rest sem )
  **  (store_sem_manager_id_allocated stable before retval )
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
|--
  “ (SemaphoreStableContext stable ) ” 
  &&  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (0 <= retval) ” 
  &&  “ (retval < (semaphore_id_limit (stable))) ”
) \/
(
forall (idnode_pre: Z) (manager_pre: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (retval: Z) (PreH1 : (retval <= INT_MAX)) (PreH2 : (retval >= INT_MIN)) (PreH3 : (retval >= 0)) (PreH4 : (manager_pre <> 0)) (PreH5 : (SemaphoreStableContext stable )) (PreH6 : (0 <= retval)) (PreH7 : ((semaphore_first_free (stable) (before)) = (Some (retval)))) (PreH8 : (idnode_pre <> 0)) (PreH9 : (manager_pre <> 0)) (PreH10 : (manager_pre <> 0)) (PreH11 : (idnode_pre <> 0)) (PreH12 : (SemaphoreStableContext stable )) (PreH13 : (semaphore_layout_32_ok sem )) (PreH14 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH15 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> (unsigned_last_nbits (retval) (16)))
  **  (store_sem_id_node_zeroed_rest sem )
  **  (store_sem_manager_id_allocated stable before retval )
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
|--
  “ (retval < (semaphore_id_limit (stable))) ”
).

Definition IdInsertObj_partial_solve_wit_3_pure_split_goal_1 := 
forall (idnode_pre: Z) (manager_pre: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (retval: Z) (PreH1 : (retval <= INT_MAX)) (PreH2 : (retval >= INT_MIN)) (PreH3 : (retval >= 0)) (PreH4 : (manager_pre <> 0)) (PreH5 : (SemaphoreStableContext stable )) (PreH6 : (0 <= retval)) (PreH7 : ((semaphore_first_free (stable) (before)) = (Some (retval)))) (PreH8 : (idnode_pre <> 0)) (PreH9 : (manager_pre <> 0)) (PreH10 : (manager_pre <> 0)) (PreH11 : (idnode_pre <> 0)) (PreH12 : (SemaphoreStableContext stable )) (PreH13 : (semaphore_layout_32_ok sem )) (PreH14 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH15 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> (unsigned_last_nbits (retval) (16)))
  **  (store_sem_id_node_zeroed_rest sem )
  **  (store_sem_manager_id_allocated stable before retval )
  **  ((( &( "id" ) )) # Int  |-> retval)
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
|--
  “ (retval < (semaphore_id_limit (stable))) ”
.

Definition IdInsertObj_partial_solve_wit_3_aux := 
forall (idnode_pre: Z) (manager_pre: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (retval: Z) (PreH1 : (retval >= 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (0 <= retval)) (PreH5 : ((semaphore_first_free (stable) (before)) = (Some (retval)))) (PreH6 : (idnode_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (manager_pre <> 0)) (PreH9 : (idnode_pre <> 0)) (PreH10 : (SemaphoreStableContext stable )) (PreH11 : (semaphore_layout_32_ok sem )) (PreH12 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH13 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> (unsigned_last_nbits (retval) (16)))
  **  (store_sem_id_node_zeroed_rest sem )
  **  (store_sem_manager_id_allocated stable before retval )
|--
  “ (SemaphoreStableContext stable ) ” 
  &&  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (0 <= retval) ” 
  &&  “ (retval < (semaphore_id_limit (stable))) ” 
  &&  “ (retval >= 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (0 <= retval) ” 
  &&  “ ((semaphore_first_free (stable) (before)) = (Some (retval))) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> (unsigned_last_nbits (retval) (16)))
  **  (store_sem_id_node_zeroed_rest sem )
  **  (store_sem_manager_id_allocated stable before retval )
.

Definition IdInsertObj_partial_solve_wit_3 := IdInsertObj_partial_solve_wit_3_pure -> IdInsertObj_partial_solve_wit_3_aux.

Definition IdInsertObj_partial_solve_wit_4_pure := 
forall (idnode_pre: Z) (manager_pre: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (retval: Z) (PreH1 : (retval >= 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (0 <= retval)) (PreH5 : ((semaphore_first_free (stable) (before)) = (Some (retval)))) (PreH6 : (idnode_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (manager_pre <> 0)) (PreH9 : (idnode_pre <> 0)) (PreH10 : (SemaphoreStableContext stable )) (PreH11 : (semaphore_layout_32_ok sem )) (PreH12 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH13 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  ((( &( "id" ) )) # Int  |-> retval)
  **  (store_sem_id_node_insert_ready sem retval )
  **  (store_sem_manager_id_allocated stable before retval )
  **  ((( &( "manager" ) )) # Ptr  |-> manager_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode_pre)
|--
  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ”
.

Definition IdInsertObj_partial_solve_wit_4_aux := 
forall (idnode_pre: Z) (manager_pre: Z) (sem: Z) (before: SemaphoreState) (stable: SemaphoreStable) (retval: Z) (PreH1 : (retval >= 0)) (PreH2 : (manager_pre <> 0)) (PreH3 : (SemaphoreStableContext stable )) (PreH4 : (0 <= retval)) (PreH5 : ((semaphore_first_free (stable) (before)) = (Some (retval)))) (PreH6 : (idnode_pre <> 0)) (PreH7 : (manager_pre <> 0)) (PreH8 : (manager_pre <> 0)) (PreH9 : (idnode_pre <> 0)) (PreH10 : (SemaphoreStableContext stable )) (PreH11 : (semaphore_layout_32_ok sem )) (PreH12 : (manager_pre = (semaphore_manager_addr (stable)))) (PreH13 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_id_node_insert_ready sem retval )
  **  (store_sem_manager_id_allocated stable before retval )
|--
  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ” 
  &&  “ (retval >= 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (0 <= retval) ” 
  &&  “ ((semaphore_first_free (stable) (before)) = (Some (retval))) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (manager_pre <> 0) ” 
  &&  “ (idnode_pre <> 0) ” 
  &&  “ (SemaphoreStableContext stable ) ” 
  &&  “ (semaphore_layout_32_ok sem ) ” 
  &&  “ (manager_pre = (semaphore_manager_addr (stable))) ” 
  &&  “ (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  (store_sem_manager_id_allocated stable before retval )
  **  (store_sem_id_node_insert_ready sem retval )
.

Definition IdInsertObj_partial_solve_wit_4 := IdInsertObj_partial_solve_wit_4_pure -> IdInsertObj_partial_solve_wit_4_aux.

Definition IdInsertObj_which_implies_wit_1 := 
(
forall (idnode_pre: Z) (sem: Z) (PreH1 : (semaphore_layout_32_ok sem )) (PreH2 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_id_node_zeroed sem )
|--
  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> 0)
  **  (store_sem_id_node_zeroed_rest sem )
) \/
(
forall (idnode_pre: Z) (sem: Z) (PreH1 : (semaphore_layout_32_ok sem )) (PreH2 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_id_node_zeroed sem )
|--
  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> 0)
  **  (store_sem_id_node_zeroed_rest sem )
).

Definition IdInsertObj_which_implies_wit_1_split_goal_spatial := 
forall (idnode_pre: Z) (sem: Z) (PreH1 : (semaphore_layout_32_ok sem )) (PreH2 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) ,
  (store_sem_id_node_zeroed sem )
|--
  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> 0)
  **  (store_sem_id_node_zeroed_rest sem )
.

Definition IdInsertObj_which_implies_wit_2 := 
(
forall (idnode_pre: Z) (sem: Z) (stable: SemaphoreStable) (id: Z) (PreH1 : (SemaphoreStableContext stable )) (PreH2 : (semaphore_layout_32_ok sem )) (PreH3 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH4 : (0 <= id)) (PreH5 : (id < (semaphore_id_limit (stable)))) ,
  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> (unsigned_last_nbits (id) (16)))
  **  (store_sem_id_node_zeroed_rest sem )
|--
  (store_sem_id_node_insert_ready sem id )
) \/
(
forall (idnode_pre: Z) (sem: Z) (stable: SemaphoreStable) (id: Z) (PreH1 : (SemaphoreStableContext stable )) (PreH2 : (semaphore_layout_32_ok sem )) (PreH3 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH4 : (0 <= id)) (PreH5 : (id < (semaphore_id_limit (stable)))) ,
  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> (unsigned_last_nbits (id) (16)))
  **  (store_sem_id_node_zeroed_rest sem )
|--
  (store_sem_id_node_insert_ready sem id )
).

Definition IdInsertObj_which_implies_wit_2_split_goal_spatial := 
forall (idnode_pre: Z) (sem: Z) (stable: SemaphoreStable) (id: Z) (PreH1 : (SemaphoreStableContext stable )) (PreH2 : (semaphore_layout_32_ok sem )) (PreH3 : (idnode_pre = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH4 : (0 <= id)) (PreH5 : (id < (semaphore_id_limit (stable)))) ,
  ((&((idnode_pre)  # "IdNode" ->ₛ "id")) # UShort  |-> (unsigned_last_nbits (id) (16)))
  **  (store_sem_id_node_zeroed_rest sem )
|--
  (store_sem_id_node_insert_ready sem id )
.

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
Axiom proof_of_IdInsertObj_return_wit_1 : IdInsertObj_return_wit_1.
Axiom proof_of_IdInsertObj_return_wit_2 : IdInsertObj_return_wit_2.
Axiom proof_of_IdInsertObj_partial_solve_wit_1_pure : IdInsertObj_partial_solve_wit_1_pure.
Axiom proof_of_IdInsertObj_partial_solve_wit_1 : IdInsertObj_partial_solve_wit_1.
Axiom proof_of_IdInsertObj_partial_solve_wit_2_pure : IdInsertObj_partial_solve_wit_2_pure.
Axiom proof_of_IdInsertObj_partial_solve_wit_2 : IdInsertObj_partial_solve_wit_2.
Axiom proof_of_IdInsertObj_partial_solve_wit_3_pure : IdInsertObj_partial_solve_wit_3_pure.
Axiom proof_of_IdInsertObj_partial_solve_wit_3 : IdInsertObj_partial_solve_wit_3.
Axiom proof_of_IdInsertObj_partial_solve_wit_4_pure : IdInsertObj_partial_solve_wit_4_pure.
Axiom proof_of_IdInsertObj_partial_solve_wit_4 : IdInsertObj_partial_solve_wit_4.
Axiom proof_of_IdInsertObj_which_implies_wit_1 : IdInsertObj_which_implies_wit_1.
Axiom proof_of_IdInsertObj_which_implies_wit_2 : IdInsertObj_which_implies_wit_2.

End VC_Correct.
