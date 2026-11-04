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
Require Import CRTOS_Verify.lib.IdModuleSpec.
Require Import CRTOS_Verify.lib.KTaskWakeup.
Require Import CRTOS_Verify.lib.DoubleLinkListSpec CRTOS_Verify.lib.TaskStatusMemory CRTOS_Verify.lib.KTaskParseInfo.
Import IDNode DLL.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.KMutexDelete.
Require Import KMutexDeleteProof.VC.KMutexDelete_lib.
Local Open Scope sac.

(*----- Function KMutexDelete -----*)

Definition KMutexDelete_safety_wit_1 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (PreH1 : ((INT_MIN) <= id_pre)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  ((( &( "lock" ) )) # Int  |->_)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_assumed_environment before_assumed_environment )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition KMutexDelete_safety_wit_2 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (PreH1 : ((INT_MIN) <= id_pre)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  ((( &( "mutex" ) )) # Ptr  |->_)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_assumed_environment before_assumed_environment )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition KMutexDelete_safety_wit_3 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (PreH1 : ((INT_MIN) <= id_pre)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  ((( &( "idnode" ) )) # Ptr  |->_)
  **  ((( &( "mutex" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_assumed_environment before_assumed_environment )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition KMutexDelete_safety_wit_4 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (PreH1 : ((INT_MIN) <= id_pre)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "mutex" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_assumed_environment before_assumed_environment )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition KMutexDelete_safety_wit_5 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (( &( "k_mutex_id_manager" ) ) = 0)) (PreH2 : (retval_2 = 0)) (PreH3 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH4 : (id_pre >= 0)) (PreH5 : ((INT_MIN) <= id_pre)) (PreH6 : (id_pre <= INT_MAX)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "mutex" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition KMutexDelete_safety_wit_6 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (( &( "k_mutex_id_manager" ) ) <> 0)) (PreH2 : (retval_2 = 0)) (PreH3 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = false)) (PreH4 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH5 : (id_pre >= 0)) (PreH6 : ((INT_MIN) <= id_pre)) (PreH7 : (id_pre <= INT_MAX)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "mutex" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition KMutexDelete_safety_wit_7 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (( &( "k_mutex_id_manager" ) ) <> 0)) (PreH2 : (retval_2 <> 0)) (PreH3 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH4 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH5 : (id_pre >= 0)) (PreH6 : ((INT_MIN) <= id_pre)) (PreH7 : (id_pre <= INT_MAX)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (store_idmanager_found (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) retval_2 (unsigned_last_nbits (id_pre) (16)) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "mutex" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition KMutexDelete_safety_wit_8 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (retval_2 <> 0)) (PreH2 : (( &( "k_mutex_id_manager" ) ) = 0)) (PreH3 : (retval_2 = 0)) (PreH4 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH5 : (id_pre >= 0)) (PreH6 : ((INT_MIN) <= id_pre)) (PreH7 : (id_pre <= INT_MAX)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "mutex" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ False ”
.

Definition KMutexDelete_safety_wit_9 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (retval_2 <> 0)) (PreH2 : (( &( "k_mutex_id_manager" ) ) <> 0)) (PreH3 : (retval_2 = 0)) (PreH4 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = false)) (PreH5 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= id_pre)) (PreH8 : (id_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "mutex" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ False ”
.

Definition KMutexDelete_safety_wit_10 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : (( &( "k_mutex_id_manager" ) ) <> 0)) (PreH3 : (retval_2 <> 0)) (PreH4 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH5 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= id_pre)) (PreH8 : (id_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (store_idmanager_found (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) retval_2 (unsigned_last_nbits (id_pre) (16)) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "mutex" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ False ”
.

Definition KMutexDelete_entail_wit_1 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_assumed_environment before_assumed_environment )
|--
  “ ((INT_MIN) <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment ) ”
  &&  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_assumed_environment before_assumed_environment )
.

Definition KMutexDelete_return_wit_1 := 
(
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_mutex_id_manager" ) ) = 0)) (PreH3 : (retval = 0)) (PreH4 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH5 : (id_pre >= 0)) (PreH6 : ((INT_MIN) <= id_pre)) (PreH7 : (id_pre <= INT_MAX)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (OutsideCritical sg_assumed_environment st_lock )
|--
  EX (after: VarGlobalState) ,
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_assumed_environment ) ”
  &&  (OutsideCritical sg_assumed_environment after )
) \/
(
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (st_lock: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_mutex_id_manager" ) ) = 0)) (PreH3 : (retval = 0)) (PreH4 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH5 : (id_pre >= 0)) (PreH6 : ((INT_MIN) <= id_pre)) (PreH7 : (id_pre <= INT_MAX)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (tt)) X_assumed_environment ) ”
  &&  emp
).

Definition KMutexDelete_return_wit_1_split_goal_1 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (st_lock: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_mutex_id_manager" ) ) = 0)) (PreH3 : (retval = 0)) (PreH4 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH5 : (id_pre >= 0)) (PreH6 : ((INT_MIN) <= id_pre)) (PreH7 : (id_pre <= INT_MAX)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (tt)) X_assumed_environment )
.

Definition KMutexDelete_return_wit_2 := 
(
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_mutex_id_manager" ) ) <> 0)) (PreH3 : (retval = 0)) (PreH4 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = false)) (PreH5 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= id_pre)) (PreH8 : (id_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (OutsideCritical sg_assumed_environment st_lock )
|--
  EX (after: VarGlobalState) ,
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_assumed_environment ) ”
  &&  (OutsideCritical sg_assumed_environment after )
) \/
(
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (st_lock: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_mutex_id_manager" ) ) <> 0)) (PreH3 : (retval = 0)) (PreH4 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = false)) (PreH5 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= id_pre)) (PreH8 : (id_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (tt)) X_assumed_environment ) ”
  &&  emp
).

Definition KMutexDelete_return_wit_2_split_goal_1 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (st_lock: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_mutex_id_manager" ) ) <> 0)) (PreH3 : (retval = 0)) (PreH4 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = false)) (PreH5 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= id_pre)) (PreH8 : (id_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  ( monadesafe_lib.safeExec  (LastSeen (st_lock)) ( MonadErr.ret  (tt)) X_assumed_environment )
.

Definition KMutexDelete_return_wit_3 := 
(
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (PreH1 : (id_pre < 0)) (PreH2 : ((INT_MIN) <= id_pre)) (PreH3 : (id_pre <= INT_MAX)) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (OutsideCritical sg_assumed_environment before_assumed_environment )
|--
  EX (after: VarGlobalState) ,
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_assumed_environment ) ”
  &&  (OutsideCritical sg_assumed_environment after )
) \/
(
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (PreH1 : (id_pre < 0)) (PreH2 : ((INT_MIN) <= id_pre)) (PreH3 : (id_pre <= INT_MAX)) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) ( MonadErr.ret  (tt)) X_assumed_environment ) ”
  &&  emp
).

Definition KMutexDelete_return_wit_3_split_goal_1 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (PreH1 : (id_pre < 0)) (PreH2 : ((INT_MIN) <= id_pre)) (PreH3 : (id_pre <= INT_MAX)) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) ( MonadErr.ret  (tt)) X_assumed_environment )
.

Definition KMutexDelete_return_wit_4 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (original: MutexAbs) (retval_2: Z) (after_2: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (after_2)) ( MonadErr.ret  (tt)) X_assumed_environment )) (PreH2 : (retval_2 = (original.(mutex_addr) ))) (PreH3 : (retval = &((retval_2)  # "Mutex" ->ₛ "id"))) (PreH4 : (In original (os_mutexes (st_lock)) )) (PreH5 : ((original.(mutex_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH6 : (retval = &(((original.(mutex_addr) ))  # "Mutex" ->ₛ "id"))) (PreH7 : (mutex_delete_live (original.(mutex_addr) ) (original.(mutex_id) ) st_lock )) (PreH8 : (retval <> 0)) (PreH9 : (( &( "k_mutex_id_manager" ) ) <> 0)) (PreH10 : (retval <> 0)) (PreH11 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH12 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH13 : (id_pre >= 0)) (PreH14 : ((INT_MIN) <= id_pre)) (PreH15 : (id_pre <= INT_MAX)) (PreH16 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (OutsideCritical sg_assumed_environment after_2 )
|--
  EX (after: VarGlobalState) ,
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_assumed_environment ) ”
  &&  (OutsideCritical sg_assumed_environment after )
.

Definition KMutexDelete_partial_solve_wit_1 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (PreH1 : (id_pre >= 0)) (PreH2 : ((INT_MIN) <= id_pre)) (PreH3 : (id_pre <= INT_MAX)) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (OutsideCritical sg_assumed_environment before_assumed_environment )
|--
  “ (id_pre >= 0) ” 
  &&  “ ((INT_MIN) <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment ) ”
  &&  (OutsideCritical sg_assumed_environment before_assumed_environment )
.

Definition KMutexDelete_partial_solve_wit_2 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (PreH1 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH2 : (id_pre >= 0)) (PreH3 : ((INT_MIN) <= id_pre)) (PreH4 : (id_pre <= INT_MAX)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (InsideCritical sg_assumed_environment st_lock )
  **  (os_inv sg_assumed_environment st_lock )
|--
  “ (Crtos_RTrans before_assumed_environment st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ ((INT_MIN) <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment ) ”
  &&  (os_inv sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
.

Definition KMutexDelete_partial_solve_wit_3_pure := 
(
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (PreH1 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH2 : (id_pre >= 0)) (PreH3 : ((INT_MIN) <= id_pre)) (PreH4 : (id_pre <= INT_MAX)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "mutex" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ ((unsigned_last_nbits (id_pre) (16)) < 65536) ” 
  &&  “ (0 <= (unsigned_last_nbits (id_pre) (16))) ”
) \/
(
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (PreH1 : (id_pre <= INT_MAX)) (PreH2 : (retval <= INT_MAX)) (PreH3 : (id_pre >= INT_MIN)) (PreH4 : (retval >= INT_MIN)) (PreH5 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= id_pre)) (PreH8 : (id_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "mutex" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (0 <= (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ ((unsigned_last_nbits (id_pre) (16)) < 65536) ”
).

Definition KMutexDelete_partial_solve_wit_3_pure_split_goal_1 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (PreH1 : (id_pre <= INT_MAX)) (PreH2 : (retval <= INT_MAX)) (PreH3 : (id_pre >= INT_MIN)) (PreH4 : (retval >= INT_MIN)) (PreH5 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= id_pre)) (PreH8 : (id_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "mutex" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (0 <= (unsigned_last_nbits (id_pre) (16))) ”
.

Definition KMutexDelete_partial_solve_wit_3_pure_split_goal_2 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (PreH1 : (id_pre <= INT_MAX)) (PreH2 : (retval <= INT_MAX)) (PreH3 : (id_pre >= INT_MIN)) (PreH4 : (retval >= INT_MIN)) (PreH5 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= id_pre)) (PreH8 : (id_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "mutex" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ ((unsigned_last_nbits (id_pre) (16)) < 65536) ”
.

Definition KMutexDelete_partial_solve_wit_3_aux := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (PreH1 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH2 : (id_pre >= 0)) (PreH3 : ((INT_MIN) <= id_pre)) (PreH4 : (id_pre <= INT_MAX)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
|--
  “ ((unsigned_last_nbits (id_pre) (16)) < 65536) ” 
  &&  “ (0 <= (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (Crtos_RTrans before_assumed_environment st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ ((INT_MIN) <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment ) ”
  &&  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
.

Definition KMutexDelete_partial_solve_wit_3 := KMutexDelete_partial_solve_wit_3_pure -> KMutexDelete_partial_solve_wit_3_aux.

Definition KMutexDelete_partial_solve_wit_4 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_mutex_id_manager" ) ) <> 0)) (PreH3 : (retval = 0)) (PreH4 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = false)) (PreH5 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= id_pre)) (PreH8 : (id_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
|--
  “ (retval = 0) ” 
  &&  “ (( &( "k_mutex_id_manager" ) ) <> 0) ” 
  &&  “ (retval = 0) ” 
  &&  “ ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = false) ” 
  &&  “ (Crtos_RTrans before_assumed_environment st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ ((INT_MIN) <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment ) ”
  &&  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
.

Definition KMutexDelete_partial_solve_wit_5 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_mutex_id_manager" ) ) = 0)) (PreH3 : (retval = 0)) (PreH4 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH5 : (id_pre >= 0)) (PreH6 : ((INT_MIN) <= id_pre)) (PreH7 : (id_pre <= INT_MAX)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
|--
  “ (retval = 0) ” 
  &&  “ (( &( "k_mutex_id_manager" ) ) = 0) ” 
  &&  “ (retval = 0) ” 
  &&  “ (Crtos_RTrans before_assumed_environment st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ ((INT_MIN) <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment ) ”
  &&  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
.

Definition KMutexDelete_partial_solve_wit_6_pure := 
(
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : (( &( "k_mutex_id_manager" ) ) = 0)) (PreH3 : (retval_2 = 0)) (PreH4 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH5 : (id_pre >= 0)) (PreH6 : ((INT_MIN) <= id_pre)) (PreH7 : (id_pre <= INT_MAX)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (os_inv sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "mutex" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (Crtos_GTrans st_lock st_lock ) ”
) \/
(
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (id_pre <= INT_MAX)) (PreH2 : (retval <= INT_MAX)) (PreH3 : (id_pre >= INT_MIN)) (PreH4 : (retval >= INT_MIN)) (PreH5 : (retval_2 = 0)) (PreH6 : (( &( "k_mutex_id_manager" ) ) = 0)) (PreH7 : (retval_2 = 0)) (PreH8 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH9 : (id_pre >= 0)) (PreH10 : ((INT_MIN) <= id_pre)) (PreH11 : (id_pre <= INT_MAX)) (PreH12 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (os_inv sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "mutex" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (Crtos_GTrans st_lock st_lock ) ”
).

Definition KMutexDelete_partial_solve_wit_6_pure_split_goal_1 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (id_pre <= INT_MAX)) (PreH2 : (retval <= INT_MAX)) (PreH3 : (id_pre >= INT_MIN)) (PreH4 : (retval >= INT_MIN)) (PreH5 : (retval_2 = 0)) (PreH6 : (( &( "k_mutex_id_manager" ) ) = 0)) (PreH7 : (retval_2 = 0)) (PreH8 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH9 : (id_pre >= 0)) (PreH10 : ((INT_MIN) <= id_pre)) (PreH11 : (id_pre <= INT_MAX)) (PreH12 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (os_inv sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "mutex" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (Crtos_GTrans st_lock st_lock ) ”
.

Definition KMutexDelete_partial_solve_wit_6_aux := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : (( &( "k_mutex_id_manager" ) ) = 0)) (PreH3 : (retval_2 = 0)) (PreH4 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH5 : (id_pre >= 0)) (PreH6 : ((INT_MIN) <= id_pre)) (PreH7 : (id_pre <= INT_MAX)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (os_inv sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
|--
  “ (Crtos_GTrans st_lock st_lock ) ” 
  &&  “ (retval_2 = 0) ” 
  &&  “ (( &( "k_mutex_id_manager" ) ) = 0) ” 
  &&  “ (retval_2 = 0) ” 
  &&  “ (Crtos_RTrans before_assumed_environment st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ ((INT_MIN) <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment ) ”
  &&  (InsideCritical sg_assumed_environment st_lock )
  **  (os_inv sg_assumed_environment st_lock )
.

Definition KMutexDelete_partial_solve_wit_6 := KMutexDelete_partial_solve_wit_6_pure -> KMutexDelete_partial_solve_wit_6_aux.

Definition KMutexDelete_partial_solve_wit_7_pure := 
(
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : (( &( "k_mutex_id_manager" ) ) <> 0)) (PreH3 : (retval_2 = 0)) (PreH4 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = false)) (PreH5 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= id_pre)) (PreH8 : (id_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (os_inv sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "mutex" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (Crtos_GTrans st_lock st_lock ) ”
) \/
(
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (id_pre <= INT_MAX)) (PreH2 : (retval <= INT_MAX)) (PreH3 : (id_pre >= INT_MIN)) (PreH4 : (retval >= INT_MIN)) (PreH5 : (retval_2 = 0)) (PreH6 : (( &( "k_mutex_id_manager" ) ) <> 0)) (PreH7 : (retval_2 = 0)) (PreH8 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = false)) (PreH9 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH10 : (id_pre >= 0)) (PreH11 : ((INT_MIN) <= id_pre)) (PreH12 : (id_pre <= INT_MAX)) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (os_inv sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "mutex" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (Crtos_GTrans st_lock st_lock ) ”
).

Definition KMutexDelete_partial_solve_wit_7_pure_split_goal_1 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (id_pre <= INT_MAX)) (PreH2 : (retval <= INT_MAX)) (PreH3 : (id_pre >= INT_MIN)) (PreH4 : (retval >= INT_MIN)) (PreH5 : (retval_2 = 0)) (PreH6 : (( &( "k_mutex_id_manager" ) ) <> 0)) (PreH7 : (retval_2 = 0)) (PreH8 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = false)) (PreH9 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH10 : (id_pre >= 0)) (PreH11 : ((INT_MIN) <= id_pre)) (PreH12 : (id_pre <= INT_MAX)) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (os_inv sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  ((( &( "mutex" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
|--
  “ (Crtos_GTrans st_lock st_lock ) ”
.

Definition KMutexDelete_partial_solve_wit_7_aux := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : (( &( "k_mutex_id_manager" ) ) <> 0)) (PreH3 : (retval_2 = 0)) (PreH4 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = false)) (PreH5 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= id_pre)) (PreH8 : (id_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (os_inv sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
|--
  “ (Crtos_GTrans st_lock st_lock ) ” 
  &&  “ (retval_2 = 0) ” 
  &&  “ (( &( "k_mutex_id_manager" ) ) <> 0) ” 
  &&  “ (retval_2 = 0) ” 
  &&  “ ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = false) ” 
  &&  “ (Crtos_RTrans before_assumed_environment st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ ((INT_MIN) <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment ) ”
  &&  (InsideCritical sg_assumed_environment st_lock )
  **  (os_inv sg_assumed_environment st_lock )
.

Definition KMutexDelete_partial_solve_wit_7 := KMutexDelete_partial_solve_wit_7_pure -> KMutexDelete_partial_solve_wit_7_aux.

Definition KMutexDelete_partial_solve_wit_8 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (( &( "k_mutex_id_manager" ) ) <> 0)) (PreH3 : (retval <> 0)) (PreH4 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH5 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= id_pre)) (PreH8 : (id_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (store_idmanager_found (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) retval (unsigned_last_nbits (id_pre) (16)) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
|--
  “ (retval <> 0) ” 
  &&  “ (( &( "k_mutex_id_manager" ) ) <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = true) ” 
  &&  “ (Crtos_RTrans before_assumed_environment st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ ((INT_MIN) <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment ) ”
  &&  (store_idmanager_found (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) retval (unsigned_last_nbits (id_pre) (16)) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
.

Definition KMutexDelete_partial_solve_wit_9_pure := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval_2: Z) (st_lock: VarGlobalState) (retval: Z) (original: MutexAbs) (PreH1 : (In original (os_mutexes (st_lock)) )) (PreH2 : ((original.(mutex_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH3 : (retval = &(((original.(mutex_addr) ))  # "Mutex" ->ₛ "id"))) (PreH4 : (mutex_delete_live (original.(mutex_addr) ) (original.(mutex_id) ) st_lock )) (PreH5 : (retval <> 0)) (PreH6 : (( &( "k_mutex_id_manager" ) ) <> 0)) (PreH7 : (retval <> 0)) (PreH8 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH9 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH10 : (id_pre >= 0)) (PreH11 : ((INT_MIN) <= id_pre)) (PreH12 : (id_pre <= INT_MAX)) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval)
  **  (os_inv sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "mutex" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> retval_2)
|--
  “ (retval = &(((original.(mutex_addr) ))  # "Mutex" ->ₛ "id")) ”
.

Definition KMutexDelete_partial_solve_wit_9_aux := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (retval: Z) (original: MutexAbs) (PreH1 : (In original (os_mutexes (st_lock)) )) (PreH2 : ((original.(mutex_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH3 : (retval = &(((original.(mutex_addr) ))  # "Mutex" ->ₛ "id"))) (PreH4 : (mutex_delete_live (original.(mutex_addr) ) (original.(mutex_id) ) st_lock )) (PreH5 : (retval <> 0)) (PreH6 : (( &( "k_mutex_id_manager" ) ) <> 0)) (PreH7 : (retval <> 0)) (PreH8 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH9 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH10 : (id_pre >= 0)) (PreH11 : ((INT_MIN) <= id_pre)) (PreH12 : (id_pre <= INT_MAX)) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (os_inv sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
|--
  “ (retval = &(((original.(mutex_addr) ))  # "Mutex" ->ₛ "id")) ” 
  &&  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (retval = &(((original.(mutex_addr) ))  # "Mutex" ->ₛ "id")) ” 
  &&  “ (mutex_delete_live (original.(mutex_addr) ) (original.(mutex_id) ) st_lock ) ” 
  &&  “ (retval <> 0) ” 
  &&  “ (( &( "k_mutex_id_manager" ) ) <> 0) ” 
  &&  “ (retval <> 0) ” 
  &&  “ ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = true) ” 
  &&  “ (Crtos_RTrans before_assumed_environment st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ ((INT_MIN) <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment ) ”
  &&  (os_inv sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
.

Definition KMutexDelete_partial_solve_wit_9 := KMutexDelete_partial_solve_wit_9_pure -> KMutexDelete_partial_solve_wit_9_aux.

Definition KMutexDelete_partial_solve_wit_10_pure := 
(
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (original: MutexAbs) (retval_3: Z) (PreH1 : (retval_3 = (original.(mutex_addr) ))) (PreH2 : (retval_2 = &((retval_3)  # "Mutex" ->ₛ "id"))) (PreH3 : (In original (os_mutexes (st_lock)) )) (PreH4 : ((original.(mutex_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH5 : (retval_2 = &(((original.(mutex_addr) ))  # "Mutex" ->ₛ "id"))) (PreH6 : (mutex_delete_live (original.(mutex_addr) ) (original.(mutex_id) ) st_lock )) (PreH7 : (retval_2 <> 0)) (PreH8 : (( &( "k_mutex_id_manager" ) ) <> 0)) (PreH9 : (retval_2 <> 0)) (PreH10 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH11 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH12 : (id_pre >= 0)) (PreH13 : ((INT_MIN) <= id_pre)) (PreH14 : (id_pre <= INT_MAX)) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  (os_inv sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval_3)
  **  ((( &( "lock" ) )) # Int  |-> retval)
|--
  “ (Crtos_GTrans st_lock st_lock ) ”
) \/
(
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (original: MutexAbs) (retval_3: Z) (PreH1 : (retval <= INT_MAX)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : (retval >= INT_MIN)) (PreH4 : (id_pre >= INT_MIN)) (PreH5 : (retval_3 = (original.(mutex_addr) ))) (PreH6 : (retval_2 = &((retval_3)  # "Mutex" ->ₛ "id"))) (PreH7 : (In original (os_mutexes (st_lock)) )) (PreH8 : ((original.(mutex_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH9 : (retval_2 = &(((original.(mutex_addr) ))  # "Mutex" ->ₛ "id"))) (PreH10 : (mutex_delete_live (original.(mutex_addr) ) (original.(mutex_id) ) st_lock )) (PreH11 : (retval_2 <> 0)) (PreH12 : (( &( "k_mutex_id_manager" ) ) <> 0)) (PreH13 : (retval_2 <> 0)) (PreH14 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH15 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH16 : (id_pre >= 0)) (PreH17 : ((INT_MIN) <= id_pre)) (PreH18 : (id_pre <= INT_MAX)) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  (os_inv sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval_3)
  **  ((( &( "lock" ) )) # Int  |-> retval)
|--
  “ (Crtos_GTrans st_lock st_lock ) ”
).

Definition KMutexDelete_partial_solve_wit_10_pure_split_goal_1 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval: Z) (st_lock: VarGlobalState) (retval_2: Z) (original: MutexAbs) (retval_3: Z) (PreH1 : (retval <= INT_MAX)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : (retval >= INT_MIN)) (PreH4 : (id_pre >= INT_MIN)) (PreH5 : (retval_3 = (original.(mutex_addr) ))) (PreH6 : (retval_2 = &((retval_3)  # "Mutex" ->ₛ "id"))) (PreH7 : (In original (os_mutexes (st_lock)) )) (PreH8 : ((original.(mutex_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH9 : (retval_2 = &(((original.(mutex_addr) ))  # "Mutex" ->ₛ "id"))) (PreH10 : (mutex_delete_live (original.(mutex_addr) ) (original.(mutex_id) ) st_lock )) (PreH11 : (retval_2 <> 0)) (PreH12 : (( &( "k_mutex_id_manager" ) ) <> 0)) (PreH13 : (retval_2 <> 0)) (PreH14 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH15 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH16 : (id_pre >= 0)) (PreH17 : ((INT_MIN) <= id_pre)) (PreH18 : (id_pre <= INT_MAX)) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_2)
  **  (os_inv sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
  **  ((( &( "mutex" ) )) # Ptr  |-> retval_3)
  **  ((( &( "lock" ) )) # Int  |-> retval)
|--
  “ (Crtos_GTrans st_lock st_lock ) ”
.

Definition KMutexDelete_partial_solve_wit_10_aux := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (retval_2: Z) (original: MutexAbs) (retval_3: Z) (PreH1 : (retval_3 = (original.(mutex_addr) ))) (PreH2 : (retval_2 = &((retval_3)  # "Mutex" ->ₛ "id"))) (PreH3 : (In original (os_mutexes (st_lock)) )) (PreH4 : ((original.(mutex_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH5 : (retval_2 = &(((original.(mutex_addr) ))  # "Mutex" ->ₛ "id"))) (PreH6 : (mutex_delete_live (original.(mutex_addr) ) (original.(mutex_id) ) st_lock )) (PreH7 : (retval_2 <> 0)) (PreH8 : (( &( "k_mutex_id_manager" ) ) <> 0)) (PreH9 : (retval_2 <> 0)) (PreH10 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH11 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH12 : (id_pre >= 0)) (PreH13 : ((INT_MIN) <= id_pre)) (PreH14 : (id_pre <= INT_MAX)) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (os_inv sg_assumed_environment st_lock )
  **  (InsideCritical sg_assumed_environment st_lock )
|--
  “ (Crtos_GTrans st_lock st_lock ) ” 
  &&  “ (retval_3 = (original.(mutex_addr) )) ” 
  &&  “ (retval_2 = &((retval_3)  # "Mutex" ->ₛ "id")) ” 
  &&  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (retval_2 = &(((original.(mutex_addr) ))  # "Mutex" ->ₛ "id")) ” 
  &&  “ (mutex_delete_live (original.(mutex_addr) ) (original.(mutex_id) ) st_lock ) ” 
  &&  “ (retval_2 <> 0) ” 
  &&  “ (( &( "k_mutex_id_manager" ) ) <> 0) ” 
  &&  “ (retval_2 <> 0) ” 
  &&  “ ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = true) ” 
  &&  “ (Crtos_RTrans before_assumed_environment st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ ((INT_MIN) <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment ) ”
  &&  (InsideCritical sg_assumed_environment st_lock )
  **  (os_inv sg_assumed_environment st_lock )
.

Definition KMutexDelete_partial_solve_wit_10 := KMutexDelete_partial_solve_wit_10_pure -> KMutexDelete_partial_solve_wit_10_aux.

Definition KMutexDelete_partial_solve_wit_11_pure := 
(
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval_2: Z) (st_lock: VarGlobalState) (retval_3: Z) (original: MutexAbs) (retval: Z) (PreH1 : (retval = (original.(mutex_addr) ))) (PreH2 : (retval_3 = &((retval)  # "Mutex" ->ₛ "id"))) (PreH3 : (In original (os_mutexes (st_lock)) )) (PreH4 : ((original.(mutex_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH5 : (retval_3 = &(((original.(mutex_addr) ))  # "Mutex" ->ₛ "id"))) (PreH6 : (mutex_delete_live (original.(mutex_addr) ) (original.(mutex_id) ) st_lock )) (PreH7 : (retval_3 <> 0)) (PreH8 : (( &( "k_mutex_id_manager" ) ) <> 0)) (PreH9 : (retval_3 <> 0)) (PreH10 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH11 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH12 : (id_pre >= 0)) (PreH13 : ((INT_MIN) <= id_pre)) (PreH14 : (id_pre <= INT_MAX)) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (OutsideCritical sg_assumed_environment st_lock )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_3)
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> retval_2)
|--
  “ (mutex_delete_live retval (original.(mutex_id) ) st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) (abs_mutex_delete_object (retval) ((original.(mutex_id) ))) X_assumed_environment ) ”
) \/
(
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval_2: Z) (st_lock: VarGlobalState) (retval_3: Z) (original: MutexAbs) (retval: Z) (PreH1 : (retval_2 <= INT_MAX)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : (retval_2 >= INT_MIN)) (PreH4 : (id_pre >= INT_MIN)) (PreH5 : (retval = (original.(mutex_addr) ))) (PreH6 : (retval_3 = &((retval)  # "Mutex" ->ₛ "id"))) (PreH7 : (In original (os_mutexes (st_lock)) )) (PreH8 : ((original.(mutex_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH9 : (retval_3 = &(((original.(mutex_addr) ))  # "Mutex" ->ₛ "id"))) (PreH10 : (mutex_delete_live (original.(mutex_addr) ) (original.(mutex_id) ) st_lock )) (PreH11 : (retval_3 <> 0)) (PreH12 : (( &( "k_mutex_id_manager" ) ) <> 0)) (PreH13 : (retval_3 <> 0)) (PreH14 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH15 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH16 : (id_pre >= 0)) (PreH17 : ((INT_MIN) <= id_pre)) (PreH18 : (id_pre <= INT_MAX)) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (OutsideCritical sg_assumed_environment st_lock )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_3)
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> retval_2)
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) (abs_mutex_delete_object (retval) ((original.(mutex_id) ))) X_assumed_environment ) ”
).

Definition KMutexDelete_partial_solve_wit_11_pure_split_goal_1 := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (retval_2: Z) (st_lock: VarGlobalState) (retval_3: Z) (original: MutexAbs) (retval: Z) (PreH1 : (retval_2 <= INT_MAX)) (PreH2 : (id_pre <= INT_MAX)) (PreH3 : (retval_2 >= INT_MIN)) (PreH4 : (id_pre >= INT_MIN)) (PreH5 : (retval = (original.(mutex_addr) ))) (PreH6 : (retval_3 = &((retval)  # "Mutex" ->ₛ "id"))) (PreH7 : (In original (os_mutexes (st_lock)) )) (PreH8 : ((original.(mutex_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH9 : (retval_3 = &(((original.(mutex_addr) ))  # "Mutex" ->ₛ "id"))) (PreH10 : (mutex_delete_live (original.(mutex_addr) ) (original.(mutex_id) ) st_lock )) (PreH11 : (retval_3 <> 0)) (PreH12 : (( &( "k_mutex_id_manager" ) ) <> 0)) (PreH13 : (retval_3 <> 0)) (PreH14 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH15 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH16 : (id_pre >= 0)) (PreH17 : ((INT_MIN) <= id_pre)) (PreH18 : (id_pre <= INT_MAX)) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (OutsideCritical sg_assumed_environment st_lock )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval_3)
  **  ((( &( "mutex" ) )) # Ptr  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> retval_2)
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) (abs_mutex_delete_object (retval) ((original.(mutex_id) ))) X_assumed_environment ) ”
.

Definition KMutexDelete_partial_solve_wit_11_aux := 
forall (id_pre: Z) (X_assumed_environment: (unit -> ((VarGlobalState -> Prop) -> Prop))) (before_assumed_environment: VarGlobalState) (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (retval_3: Z) (original: MutexAbs) (retval: Z) (PreH1 : (retval = (original.(mutex_addr) ))) (PreH2 : (retval_3 = &((retval)  # "Mutex" ->ₛ "id"))) (PreH3 : (In original (os_mutexes (st_lock)) )) (PreH4 : ((original.(mutex_id) ) = (unsigned_last_nbits (id_pre) (16)))) (PreH5 : (retval_3 = &(((original.(mutex_addr) ))  # "Mutex" ->ₛ "id"))) (PreH6 : (mutex_delete_live (original.(mutex_addr) ) (original.(mutex_id) ) st_lock )) (PreH7 : (retval_3 <> 0)) (PreH8 : (( &( "k_mutex_id_manager" ) ) <> 0)) (PreH9 : (retval_3 <> 0)) (PreH10 : ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = true)) (PreH11 : (Crtos_RTrans before_assumed_environment st_lock )) (PreH12 : (id_pre >= 0)) (PreH13 : ((INT_MIN) <= id_pre)) (PreH14 : (id_pre <= INT_MAX)) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment )) ,
  (OutsideCritical sg_assumed_environment st_lock )
|--
  “ (mutex_delete_live retval (original.(mutex_id) ) st_lock ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (st_lock)) (abs_mutex_delete_object (retval) ((original.(mutex_id) ))) X_assumed_environment ) ” 
  &&  “ (retval = (original.(mutex_addr) )) ” 
  &&  “ (retval_3 = &((retval)  # "Mutex" ->ₛ "id")) ” 
  &&  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_id) ) = (unsigned_last_nbits (id_pre) (16))) ” 
  &&  “ (retval_3 = &(((original.(mutex_addr) ))  # "Mutex" ->ₛ "id")) ” 
  &&  “ (mutex_delete_live (original.(mutex_addr) ) (original.(mutex_id) ) st_lock ) ” 
  &&  “ (retval_3 <> 0) ” 
  &&  “ (( &( "k_mutex_id_manager" ) ) <> 0) ” 
  &&  “ (retval_3 <> 0) ” 
  &&  “ ((idmanager_query ((mutex_manager ((os_mutexes (st_lock))))) ((unsigned_last_nbits (id_pre) (16)))) = true) ” 
  &&  “ (Crtos_RTrans before_assumed_environment st_lock ) ” 
  &&  “ (id_pre >= 0) ” 
  &&  “ ((INT_MIN) <= id_pre) ” 
  &&  “ (id_pre <= INT_MAX) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_assumed_environment)) (abs_mutex_delete (id_pre)) X_assumed_environment ) ”
  &&  (OutsideCritical sg_assumed_environment st_lock )
.

Definition KMutexDelete_partial_solve_wit_11 := KMutexDelete_partial_solve_wit_11_pure -> KMutexDelete_partial_solve_wit_11_aux.

Definition KMutexDelete_which_implies_wit_1 := 
(
forall (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) ,
  (os_inv sg_assumed_environment st_lock )
|--
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
) \/
(
forall (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) ,
  (os_inv sg_assumed_environment st_lock )
|--
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
).

Definition KMutexDelete_which_implies_wit_1_split_goal_spatial := 
forall (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) ,
  (os_inv sg_assumed_environment st_lock )
|--
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
.

Definition KMutexDelete_which_implies_wit_2 := 
(
forall (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
|--
  (os_inv sg_assumed_environment st_lock )
) \/
(
forall (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
|--
  (os_inv sg_assumed_environment st_lock )
).

Definition KMutexDelete_which_implies_wit_2_split_goal_spatial := 
forall (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) ,
  (store_idmanager (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
|--
  (os_inv sg_assumed_environment st_lock )
.

Definition KMutexDelete_which_implies_wit_3 := 
(
forall (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (id: Z) (idnode: Z) ,
  (store_idmanager_found (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) idnode (unsigned_last_nbits (id) (16)) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
|--
  EX (original: MutexAbs) ,
  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_id) ) = (unsigned_last_nbits (id) (16))) ” 
  &&  “ (idnode = &(((original.(mutex_addr) ))  # "Mutex" ->ₛ "id")) ” 
  &&  “ (mutex_delete_live (original.(mutex_addr) ) (original.(mutex_id) ) st_lock ) ”
  &&  (os_inv sg_assumed_environment st_lock )
) \/
(
forall (sg_assumed_environment: StableGlobalState) (st_lock: VarGlobalState) (id: Z) (idnode: Z) ,
  (store_idmanager_found (mutex_manager_stable ((os_mutex_stable (sg_assumed_environment)))) (mutex_manager ((os_mutexes (st_lock)))) ( &( "k_mutex_id_manager" ) ) idnode (unsigned_last_nbits (id) (16)) )
  **  (mutex_lookup_frame sg_assumed_environment st_lock )
|--
  EX (original: MutexAbs) ,
  “ (In original (os_mutexes (st_lock)) ) ” 
  &&  “ ((original.(mutex_id) ) = (unsigned_last_nbits (id) (16))) ” 
  &&  “ (idnode = &(((original.(mutex_addr) ))  # "Mutex" ->ₛ "id")) ” 
  &&  “ (mutex_delete_live (original.(mutex_addr) ) (original.(mutex_id) ) st_lock ) ”
  &&  (os_inv sg_assumed_environment st_lock )
).

Module Type VC_Correct.


Axiom proof_of_KMutexDelete_safety_wit_1 : KMutexDelete_safety_wit_1.
Axiom proof_of_KMutexDelete_safety_wit_2 : KMutexDelete_safety_wit_2.
Axiom proof_of_KMutexDelete_safety_wit_3 : KMutexDelete_safety_wit_3.
Axiom proof_of_KMutexDelete_safety_wit_4 : KMutexDelete_safety_wit_4.
Axiom proof_of_KMutexDelete_safety_wit_5 : KMutexDelete_safety_wit_5.
Axiom proof_of_KMutexDelete_safety_wit_6 : KMutexDelete_safety_wit_6.
Axiom proof_of_KMutexDelete_safety_wit_7 : KMutexDelete_safety_wit_7.
Axiom proof_of_KMutexDelete_safety_wit_8 : KMutexDelete_safety_wit_8.
Axiom proof_of_KMutexDelete_safety_wit_9 : KMutexDelete_safety_wit_9.
Axiom proof_of_KMutexDelete_safety_wit_10 : KMutexDelete_safety_wit_10.
Axiom proof_of_KMutexDelete_entail_wit_1 : KMutexDelete_entail_wit_1.
Axiom proof_of_KMutexDelete_return_wit_1 : KMutexDelete_return_wit_1.
Axiom proof_of_KMutexDelete_return_wit_2 : KMutexDelete_return_wit_2.
Axiom proof_of_KMutexDelete_return_wit_3 : KMutexDelete_return_wit_3.
Axiom proof_of_KMutexDelete_return_wit_4 : KMutexDelete_return_wit_4.
Axiom proof_of_KMutexDelete_partial_solve_wit_1 : KMutexDelete_partial_solve_wit_1.
Axiom proof_of_KMutexDelete_partial_solve_wit_2 : KMutexDelete_partial_solve_wit_2.
Axiom proof_of_KMutexDelete_partial_solve_wit_3_pure : KMutexDelete_partial_solve_wit_3_pure.
Axiom proof_of_KMutexDelete_partial_solve_wit_3 : KMutexDelete_partial_solve_wit_3.
Axiom proof_of_KMutexDelete_partial_solve_wit_4 : KMutexDelete_partial_solve_wit_4.
Axiom proof_of_KMutexDelete_partial_solve_wit_5 : KMutexDelete_partial_solve_wit_5.
Axiom proof_of_KMutexDelete_partial_solve_wit_6_pure : KMutexDelete_partial_solve_wit_6_pure.
Axiom proof_of_KMutexDelete_partial_solve_wit_6 : KMutexDelete_partial_solve_wit_6.
Axiom proof_of_KMutexDelete_partial_solve_wit_7_pure : KMutexDelete_partial_solve_wit_7_pure.
Axiom proof_of_KMutexDelete_partial_solve_wit_7 : KMutexDelete_partial_solve_wit_7.
Axiom proof_of_KMutexDelete_partial_solve_wit_8 : KMutexDelete_partial_solve_wit_8.
Axiom proof_of_KMutexDelete_partial_solve_wit_9_pure : KMutexDelete_partial_solve_wit_9_pure.
Axiom proof_of_KMutexDelete_partial_solve_wit_9 : KMutexDelete_partial_solve_wit_9.
Axiom proof_of_KMutexDelete_partial_solve_wit_10_pure : KMutexDelete_partial_solve_wit_10_pure.
Axiom proof_of_KMutexDelete_partial_solve_wit_10 : KMutexDelete_partial_solve_wit_10.
Axiom proof_of_KMutexDelete_partial_solve_wit_11_pure : KMutexDelete_partial_solve_wit_11_pure.
Axiom proof_of_KMutexDelete_partial_solve_wit_11 : KMutexDelete_partial_solve_wit_11.
Axiom proof_of_KMutexDelete_which_implies_wit_1 : KMutexDelete_which_implies_wit_1.
Axiom proof_of_KMutexDelete_which_implies_wit_2 : KMutexDelete_which_implies_wit_2.
Axiom proof_of_KMutexDelete_which_implies_wit_3 : KMutexDelete_which_implies_wit_3.

End VC_Correct.
