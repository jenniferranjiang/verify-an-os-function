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
Require Import CRTOS_Verify.lib.CrtosGlobState.
Require Import CRTOS_Verify.sem.SemaphorePure.
Require Import CRTOS_Verify.sem.CrtosOSPure.
Require Import CRTOS_Verify.sem.SemaphoreProtocol.
Require Import CRTOS_Verify.sem.SemaphoreCritical.
From MonadLib.StateRelMonad Require Import StateRelBasic safeexec_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Local Open Scope sac.

(*----- Function KSemaphoreCreate -----*)

Definition KSemaphoreCreate_return_wit_1 := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (after_3: CrtosOSWorld) (current_3: CrtosOSWorld) (retval: Z) (PreH1 : (retval = (-5))) (PreH2 : (SemaphoreRely stable before current_3 )) (PreH3 : (after_3 = current_3)) (PreH4 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (after_3)))) (return (retval)) X )) (PreH5 : (sizeof( "Semaphore" ) = 32)) (PreH6 : (0 <= val_pre)) (PreH7 : (val_pre <= 65535)) (PreH8 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (SemaphoreCriticalOutside stable after_3 )
|--
  EX (after: CrtosOSWorld)  (current: CrtosOSWorld) ,
  “ (retval = (-5)) ” 
  &&  “ (SemaphoreRely stable before current ) ” 
  &&  “ (after = current) ” 
  &&  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (after)))) (return (retval)) X ) ”
  &&  (SemaphoreCriticalOutside stable after )
.

Definition KSemaphoreCreate_return_wit_2 := 
(
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (after_3: CrtosOSWorld) (current_3: CrtosOSWorld) (sem_2: Z) (id_2: Z) (retval: Z) (PreH1 : (retval = id_2)) (PreH2 : (0 <= id_2)) (PreH3 : (id_2 < 128)) (PreH4 : (sem_2 <> 0)) (PreH5 : (SemaphoreRely stable before current_3 )) (PreH6 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current_3)))) = (Some (id_2)))) (PreH7 : (after_3 = (Build_CrtosOSWorld ((crtos_task_state (current_3))) ((crtos_scheduler_state (current_3))) ((semaphore_create_state ((crtos_semaphore_state (current_3))) (sem_2) (id_2) (val_pre)))))) (PreH8 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (after_3)))) (return (retval)) X )) (PreH9 : (sizeof( "Semaphore" ) = 32)) (PreH10 : (0 <= val_pre)) (PreH11 : (val_pre <= 65535)) (PreH12 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (SemaphoreCriticalOutside stable after_3 )
|--
  EX (after_2: CrtosOSWorld)  (current_2: CrtosOSWorld)  (sem: Z)  (id: Z) ,
  “ (retval = id) ” 
  &&  “ (0 <= id) ” 
  &&  “ (id < 128) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (SemaphoreRely stable before current_2 ) ” 
  &&  “ ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current_2)))) = (Some (id))) ” 
  &&  “ (after_2 = (Build_CrtosOSWorld ((crtos_task_state (current_2))) ((crtos_scheduler_state (current_2))) ((semaphore_create_state ((crtos_semaphore_state (current_2))) (sem) (id) (val_pre))))) ” 
  &&  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (after_2)))) (return (retval)) X ) ”
  &&  (SemaphoreCriticalOutside stable after_2 )
) \/
(
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (after_3: CrtosOSWorld) (current_3: CrtosOSWorld) (sem_2: Z) (id_2: Z) (retval: Z) (PreH1 : (retval = id_2)) (PreH2 : (0 <= id_2)) (PreH3 : (id_2 < 128)) (PreH4 : (sem_2 <> 0)) (PreH5 : (SemaphoreRely stable before current_3 )) (PreH6 : ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current_3)))) = (Some (id_2)))) (PreH7 : (after_3 = (Build_CrtosOSWorld ((crtos_task_state (current_3))) ((crtos_scheduler_state (current_3))) ((semaphore_create_state ((crtos_semaphore_state (current_3))) (sem_2) (id_2) (val_pre)))))) (PreH8 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (after_3)))) (return (retval)) X )) (PreH9 : (sizeof( "Semaphore" ) = 32)) (PreH10 : (0 <= val_pre)) (PreH11 : (val_pre <= 65535)) (PreH12 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (SemaphoreCriticalOutside stable after_3 )
|--
  EX (current_2: CrtosOSWorld)  (sem: Z) ,
  “ (0 <= retval) ” 
  &&  “ (retval < 128) ” 
  &&  “ (sem <> 0) ” 
  &&  “ (SemaphoreRely stable before current_2 ) ” 
  &&  “ ((semaphore_first_free ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (current_2)))) = (Some (retval))) ” 
  &&  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state ((Build_CrtosOSWorld ((crtos_task_state (current_2))) ((crtos_scheduler_state (current_2))) ((semaphore_create_state ((crtos_semaphore_state (current_2))) (sem) (retval) (val_pre)))))))) (return (retval)) X ) ”
  &&  (SemaphoreCriticalOutside stable (Build_CrtosOSWorld ((crtos_task_state (current_2))) ((crtos_scheduler_state (current_2))) ((semaphore_create_state ((crtos_semaphore_state (current_2))) (sem) (retval) (val_pre)))) )
).

Definition KSemaphoreCreate_partial_solve_wit_1_pure := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (PreH1 : (sizeof( "Semaphore" ) = 32)) (PreH2 : (0 <= val_pre)) (PreH3 : (val_pre <= 65535)) (PreH4 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  ((( &( "val" ) )) # UShort  |-> val_pre)
  **  (SemaphoreCriticalOutside stable before )
|--
  “ (sizeof( "Semaphore" ) = 32) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X ) ”
.

Definition KSemaphoreCreate_partial_solve_wit_1_aux := 
forall (val_pre: Z) (X: (Z -> ((SemaphoreState -> Prop) -> Prop))) (before: CrtosOSWorld) (stable: CrtosOSStable) (PreH1 : (sizeof( "Semaphore" ) = 32)) (PreH2 : (0 <= val_pre)) (PreH3 : (val_pre <= 65535)) (PreH4 : (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X )) ,
  (SemaphoreCriticalOutside stable before )
|--
  “ (sizeof( "Semaphore" ) = 32) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X ) ” 
  &&  “ (sizeof( "Semaphore" ) = 32) ” 
  &&  “ (0 <= val_pre) ” 
  &&  “ (val_pre <= 65535) ” 
  &&  “ (safeExec (SemaphoreLastSeen ((crtos_semaphore_stable (stable))) ((crtos_semaphore_state (before)))) (abs_ksemaphore_create ((crtos_semaphore_stable (stable))) (val_pre)) X ) ”
  &&  (SemaphoreCriticalOutside stable before )
.

Definition KSemaphoreCreate_partial_solve_wit_1 := KSemaphoreCreate_partial_solve_wit_1_pure -> KSemaphoreCreate_partial_solve_wit_1_aux.

Module Type VC_Correct.


Axiom proof_of_KSemaphoreCreate_return_wit_1 : KSemaphoreCreate_return_wit_1.
Axiom proof_of_KSemaphoreCreate_return_wit_2 : KSemaphoreCreate_return_wit_2.
Axiom proof_of_KSemaphoreCreate_partial_solve_wit_1_pure : KSemaphoreCreate_partial_solve_wit_1_pure.
Axiom proof_of_KSemaphoreCreate_partial_solve_wit_1 : KSemaphoreCreate_partial_solve_wit_1.

End VC_Correct.
