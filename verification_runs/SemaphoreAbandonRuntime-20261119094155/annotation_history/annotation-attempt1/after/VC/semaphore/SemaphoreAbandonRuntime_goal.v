From SimpleC.Verification Require Import VCPrelude.
Require Import CRTOS_Verify.lib.id.IdModuleSpec.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreDelete CRTOS_Verify.lib.delay.KTaskUnSetDelay.
Require Import CRTOS_Verify.lib.list.DoubleLinkListSpec CRTOS_Verify.lib.task.TaskStatusMemory CRTOS_Verify.lib.task.KTaskParseInfo.
Import IDNode DLL.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreAbandon.
Require Import CRTOS_Verify.lib.semaphore.KSemaphoreObtain.
Import SimpleC.CoreLang.CTypes.SimpleCtypeNotations.
Local Open Scope sac.

(*----- Function _SemaphoreAbandon -----*)

Definition _SemaphoreAbandon_safety_wit_1 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((( &( "lock" ) )) # Int  |->_)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_abandon_oc before_semaphore_abandon_oc )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreAbandon_safety_wit_2 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((( &( "resched" ) )) # Int  |->_)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_abandon_oc before_semaphore_abandon_oc )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreAbandon_safety_wit_3 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((( &( "sem" ) )) # Ptr  |->_)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_abandon_oc before_semaphore_abandon_oc )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreAbandon_safety_wit_4 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((( &( "idnode" ) )) # Ptr  |->_)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_abandon_oc before_semaphore_abandon_oc )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreAbandon_safety_wit_5 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_abandon_oc before_semaphore_abandon_oc )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreAbandon_safety_wit_6 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (PreH1 : (id_pre >= 0)) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_abandon_oc before_semaphore_abandon_oc )
|--
  “ (65535 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 65535) ”
.

Definition _SemaphoreAbandon_safety_wit_7 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (PreH1 : (id_pre > 65535)) (PreH2 : (id_pre >= 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_abandon_oc before_semaphore_abandon_oc )
|--
  “ (1 <> (INT_MIN)) ”
.

Definition _SemaphoreAbandon_safety_wit_8 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (PreH1 : (id_pre < 0)) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_abandon_oc before_semaphore_abandon_oc )
|--
  “ (1 <> (INT_MIN)) ”
.

Definition _SemaphoreAbandon_safety_wit_9 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (PreH1 : (id_pre < 0)) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_abandon_oc before_semaphore_abandon_oc )
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition _SemaphoreAbandon_safety_wit_10 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (PreH1 : (id_pre > 65535)) (PreH2 : (id_pre >= 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_abandon_oc before_semaphore_abandon_oc )
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition _SemaphoreAbandon_safety_wit_11 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (resched: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (saved: Z) (retval: Z) (PreH1 : (( &( "k_sem_id_manager" ) ) = 0)) (PreH2 : (retval = 0)) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : (resched = 0)) (PreH6 : (sem = 0)) (PreH7 : (idnode = 0)) (PreH8 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval)
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreAbandon_safety_wit_12 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (resched: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (saved: Z) (retval: Z) (PreH1 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH2 : (retval = 0)) (PreH3 : ((idmanager_query ((semaphore_manager ((os_semaphores (held))))) (id_pre)) = false)) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= 65535)) (PreH6 : (resched = 0)) (PreH7 : (sem = 0)) (PreH8 : (idnode = 0)) (PreH9 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval)
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreAbandon_safety_wit_13 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (resched: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (saved: Z) (retval: Z) (PreH1 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH2 : (retval <> 0)) (PreH3 : ((idmanager_query ((semaphore_manager ((os_semaphores (held))))) (id_pre)) = true)) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= 65535)) (PreH6 : (resched = 0)) (PreH7 : (sem = 0)) (PreH8 : (idnode = 0)) (PreH9 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_idmanager_found (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) retval id_pre )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval)
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreAbandon_safety_wit_14 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (resched: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (saved: Z) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) = 0)) (PreH3 : (retval = 0)) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= 65535)) (PreH6 : (resched = 0)) (PreH7 : (sem = 0)) (PreH8 : (idnode = 0)) (PreH9 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval)
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ False ”
.

Definition _SemaphoreAbandon_safety_wit_15 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (resched: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (saved: Z) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval = 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((os_semaphores (held))))) (id_pre)) = false)) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : (resched = 0)) (PreH8 : (sem = 0)) (PreH9 : (idnode = 0)) (PreH10 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval)
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ False ”
.

Definition _SemaphoreAbandon_safety_wit_16 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (resched: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (saved: Z) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval <> 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((os_semaphores (held))))) (id_pre)) = true)) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : (resched = 0)) (PreH8 : (sem = 0)) (PreH9 : (idnode = 0)) (PreH10 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_idmanager_found (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) retval id_pre )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval)
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ False ”
.

Definition _SemaphoreAbandon_safety_wit_17 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (resched: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (resched = 0)) (PreH4 : (sem = 0)) (PreH5 : (idnode = 0)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-1))) X_semaphore_abandon_oc )) (PreH7 : (Crtos_GTrans held held )),
  (OutsideCritical sg_semaphore_abandon_oc held )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
|--
  “ (1 <> (INT_MIN)) ”
.

Definition _SemaphoreAbandon_safety_wit_18 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (resched: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (resched = 0)) (PreH4 : (sem = 0)) (PreH5 : (idnode = 0)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-1))) X_semaphore_abandon_oc )) (PreH7 : (Crtos_GTrans held held )),
  (OutsideCritical sg_semaphore_abandon_oc held )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition _SemaphoreAbandon_safety_wit_19 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 <> 0)) (PreH2 : (retval_2 = 0)) (PreH3 : ((map (sched_link_node) ((semaphore_pending_addrs (original)))) <> (@nil (@DL_Node Z)))) (PreH4 : (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH5 : (retval = (semaphore_addr (original)))) (PreH6 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH7 : (0 <= id_pre)) (PreH8 : (id_pre <= 65535)) (PreH9 : (resched = 0)) (PreH10 : (sem = 0)) (PreH11 : (In original (os_semaphores (held)) )) (PreH12 : ((semaphore_id (original)) = id_pre)) (PreH13 : ((semaphore_addr (original)) <> 0)) (PreH14 : (0 <= (semaphore_value (original)))) (PreH15 : ((semaphore_value (original)) <= 65535)) (PreH16 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH17 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (held)))))) &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((semaphore_pending_addrs (original)))) )
  **  ((( &( "sem" ) )) # Ptr  |-> (semaphore_addr (original)))
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (held))))))) (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list")) ((map (sched_link_node) ((semaphore_pending_addrs (original)))))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ False ”
.

Definition _SemaphoreAbandon_safety_wit_20 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : (retval_2 = 1)) (PreH3 : ((map (sched_link_node) ((semaphore_pending_addrs (original)))) = (@nil (@DL_Node Z)))) (PreH4 : (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH5 : (retval = (semaphore_addr (original)))) (PreH6 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH7 : (0 <= id_pre)) (PreH8 : (id_pre <= 65535)) (PreH9 : (resched = 0)) (PreH10 : (sem = 0)) (PreH11 : (In original (os_semaphores (held)) )) (PreH12 : ((semaphore_id (original)) = id_pre)) (PreH13 : ((semaphore_addr (original)) <> 0)) (PreH14 : (0 <= (semaphore_value (original)))) (PreH15 : ((semaphore_value (original)) <= 65535)) (PreH16 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH17 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (held)))))) &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((semaphore_pending_addrs (original)))) )
  **  ((( &( "sem" ) )) # Ptr  |-> (semaphore_addr (original)))
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (held))))))) (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list")) ((map (sched_link_node) ((semaphore_pending_addrs (original)))))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ False ”
.

Definition _SemaphoreAbandon_safety_wit_21 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (resched: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (resched = 0)) (PreH4 : (sem = (semaphore_addr (original)))) (PreH5 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH6 : (In original (os_semaphores (held)) )) (PreH7 : ((semaphore_id (original)) = id_pre)) (PreH8 : ((semaphore_pending_addrs (original)) <> (@nil Z))) (PreH9 : (semaphore_pending_nodes sem held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH10 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition _SemaphoreAbandon_safety_wit_22 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH2 : (0 <= (semaphore_value (original)))) (PreH3 : ((semaphore_value (original)) < 65535)) (PreH4 : (retval_2 <> 0)) (PreH5 : (retval_2 = 1)) (PreH6 : ((map (sched_link_node) ((semaphore_pending_addrs (original)))) = (@nil (@DL_Node Z)))) (PreH7 : (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH8 : (retval = (semaphore_addr (original)))) (PreH9 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH10 : (0 <= id_pre)) (PreH11 : (id_pre <= 65535)) (PreH12 : (resched = 0)) (PreH13 : (sem = 0)) (PreH14 : (In original (os_semaphores (held)) )) (PreH15 : ((semaphore_id (original)) = id_pre)) (PreH16 : ((semaphore_addr (original)) <> 0)) (PreH17 : (0 <= (semaphore_value (original)))) (PreH18 : ((semaphore_value (original)) <= 65535)) (PreH19 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH20 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((( &( "sem" ) )) # Ptr  |-> (semaphore_addr (original)))
  **  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (((semaphore_value (original)) + 1 ))) (os_inv (sg_semaphore_abandon_oc) ((replace_semaphores ((semaphore_set_value ((semaphore_addr (original))) (((semaphore_value (original)) + 1 )) ((os_semaphores (held))))) (held)))) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ (65535 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 65535) ”
.

Definition _SemaphoreAbandon_safety_wit_23 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH2 : ((semaphore_value (original)) = 65535)) (PreH3 : (retval_2 <> 0)) (PreH4 : (retval_2 = 1)) (PreH5 : ((map (sched_link_node) ((semaphore_pending_addrs (original)))) = (@nil (@DL_Node Z)))) (PreH6 : (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH7 : (retval = (semaphore_addr (original)))) (PreH8 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH9 : (0 <= id_pre)) (PreH10 : (id_pre <= 65535)) (PreH11 : (resched = 0)) (PreH12 : (sem = 0)) (PreH13 : (In original (os_semaphores (held)) )) (PreH14 : ((semaphore_id (original)) = id_pre)) (PreH15 : ((semaphore_addr (original)) <> 0)) (PreH16 : (0 <= (semaphore_value (original)))) (PreH17 : ((semaphore_value (original)) <= 65535)) (PreH18 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH19 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((( &( "sem" ) )) # Ptr  |-> (semaphore_addr (original)))
  **  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (65535)) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ (65535 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 65535) ”
.

Definition _SemaphoreAbandon_safety_wit_24 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : ((semaphore_value (original)) = 65535)) (PreH2 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH3 : (0 <= (semaphore_value (original)))) (PreH4 : ((semaphore_value (original)) < 65535)) (PreH5 : (retval_2 <> 0)) (PreH6 : (retval_2 = 1)) (PreH7 : ((map (sched_link_node) ((semaphore_pending_addrs (original)))) = (@nil (@DL_Node Z)))) (PreH8 : (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH9 : (retval = (semaphore_addr (original)))) (PreH10 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH11 : (0 <= id_pre)) (PreH12 : (id_pre <= 65535)) (PreH13 : (resched = 0)) (PreH14 : (sem = 0)) (PreH15 : (In original (os_semaphores (held)) )) (PreH16 : ((semaphore_id (original)) = id_pre)) (PreH17 : ((semaphore_addr (original)) <> 0)) (PreH18 : (0 <= (semaphore_value (original)))) (PreH19 : ((semaphore_value (original)) <= 65535)) (PreH20 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH21 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((( &( "sem" ) )) # Ptr  |-> (semaphore_addr (original)))
  **  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (((semaphore_value (original)) + 1 ))) (os_inv (sg_semaphore_abandon_oc) ((replace_semaphores ((semaphore_set_value ((semaphore_addr (original))) (((semaphore_value (original)) + 1 )) ((os_semaphores (held))))) (held)))) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ False ”
.

Definition _SemaphoreAbandon_safety_wit_25 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : ((semaphore_value (original)) <> 65535)) (PreH2 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH3 : ((semaphore_value (original)) = 65535)) (PreH4 : (retval_2 <> 0)) (PreH5 : (retval_2 = 1)) (PreH6 : ((map (sched_link_node) ((semaphore_pending_addrs (original)))) = (@nil (@DL_Node Z)))) (PreH7 : (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH8 : (retval = (semaphore_addr (original)))) (PreH9 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH10 : (0 <= id_pre)) (PreH11 : (id_pre <= 65535)) (PreH12 : (resched = 0)) (PreH13 : (sem = 0)) (PreH14 : (In original (os_semaphores (held)) )) (PreH15 : ((semaphore_id (original)) = id_pre)) (PreH16 : ((semaphore_addr (original)) <> 0)) (PreH17 : (0 <= (semaphore_value (original)))) (PreH18 : ((semaphore_value (original)) <= 65535)) (PreH19 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH20 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((( &( "sem" ) )) # Ptr  |-> (semaphore_addr (original)))
  **  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (65535)) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ False ”
.

Definition _SemaphoreAbandon_safety_wit_26 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (resched: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (resched = 0)) (PreH4 : (sem = (semaphore_addr (original)))) (PreH5 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-3))) X_semaphore_abandon_oc )) (PreH7 : (Crtos_GTrans held held )),
  (OutsideCritical sg_semaphore_abandon_oc held )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
|--
  “ (3 <> (INT_MIN)) ”
.

Definition _SemaphoreAbandon_safety_wit_27 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (resched: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (resched = 0)) (PreH4 : (sem = (semaphore_addr (original)))) (PreH5 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-3))) X_semaphore_abandon_oc )) (PreH7 : (Crtos_GTrans held held )),
  (OutsideCritical sg_semaphore_abandon_oc held )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
|--
  “ (3 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 3) ”
.

Definition _SemaphoreAbandon_safety_wit_28 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (released: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (sem = (semaphore_addr (original)))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : (resched = 1)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (released)) abs_ktask_assign Y )) (PreH7 : forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ))) (PreH8 : (Crtos_GTrans held released )) (PreH9 : (resched = 0)),
  (OutsideCritical sg_semaphore_abandon_oc released )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "resched" ) )) # Int  |-> resched)
|--
  “ False ”
.

Definition _SemaphoreAbandon_safety_wit_29 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (released: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (sem = (semaphore_addr (original)))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : (resched = 0)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (released)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc )) (PreH7 : forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ))) (PreH8 : (Crtos_GTrans held released )) (PreH9 : (resched <> 0)),
  (OutsideCritical sg_semaphore_abandon_oc released )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "resched" ) )) # Int  |-> resched)
|--
  “ False ”
.

Definition _SemaphoreAbandon_safety_wit_30 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (released: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (after: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) Y )) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre <= 65535)) (PreH4 : (sem = (semaphore_addr (original)))) (PreH5 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH6 : (resched = 1)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (released)) abs_ktask_assign Y )) (PreH8 : forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ))) (PreH9 : (Crtos_GTrans held released )) (PreH10 : (resched <> 0)),
  (OutsideCritical sg_semaphore_abandon_oc after )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "resched" ) )) # Int  |-> resched)
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreAbandon_safety_wit_31 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (released: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (sem = (semaphore_addr (original)))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : (resched = 0)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (released)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc )) (PreH7 : forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ))) (PreH8 : (Crtos_GTrans held released )) (PreH9 : (resched = 0)),
  (OutsideCritical sg_semaphore_abandon_oc released )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "resched" ) )) # Int  |-> resched)
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreAbandon_entail_wit_1 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (st_lock: VarGlobalState) (PreH1 : (Crtos_RTrans before_semaphore_abandon_oc st_lock )) (PreH2 : (id_pre <= 65535)) (PreH3 : (id_pre >= 0)) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (InsideCritical sg_semaphore_abandon_oc st_lock )
  **  (os_inv sg_semaphore_abandon_oc st_lock )
|--
  EX (held: VarGlobalState),
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (0 = 0) ”
  &&  “ (0 = 0) ”
  &&  “ (0 = 0) ”
  &&  “ (Crtos_RTrans before_semaphore_abandon_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc ) ”
  &&  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
.

Definition _SemaphoreAbandon_entail_wit_2_1 :=
(
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (resched: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) = 0)) (PreH3 : (retval = 0)) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= 65535)) (PreH6 : (resched = 0)) (PreH7 : (sem = 0)) (PreH8 : (idnode = 0)) (PreH9 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (retval = 0) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-1))) X_semaphore_abandon_oc ) ”
  &&  “ (Crtos_GTrans held held ) ”
  &&  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
) \/
(
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (resched: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) = 0)) (PreH3 : (retval = 0)) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= 65535)) (PreH6 : (resched = 0)) (PreH7 : (sem = 0)) (PreH8 : (idnode = 0)) (PreH9 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ (Crtos_GTrans held held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-1))) X_semaphore_abandon_oc ) ”
  &&  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
).

Definition _SemaphoreAbandon_entail_wit_2_1_split_goal_1 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (resched: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) = 0)) (PreH3 : (retval = 0)) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= 65535)) (PreH6 : (resched = 0)) (PreH7 : (sem = 0)) (PreH8 : (idnode = 0)) (PreH9 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ (Crtos_GTrans held held ) ”
.

Definition _SemaphoreAbandon_entail_wit_2_1_split_goal_2 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (resched: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) = 0)) (PreH3 : (retval = 0)) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= 65535)) (PreH6 : (resched = 0)) (PreH7 : (sem = 0)) (PreH8 : (idnode = 0)) (PreH9 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-1))) X_semaphore_abandon_oc ) ”
.

Definition _SemaphoreAbandon_entail_wit_2_1_split_goal_spatial :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (resched: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) = 0)) (PreH3 : (retval = 0)) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= 65535)) (PreH6 : (resched = 0)) (PreH7 : (sem = 0)) (PreH8 : (idnode = 0)) (PreH9 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
.

Definition _SemaphoreAbandon_entail_wit_2_2 :=
(
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (resched: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval = 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((os_semaphores (held))))) (id_pre)) = false)) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : (resched = 0)) (PreH8 : (sem = 0)) (PreH9 : (idnode = 0)) (PreH10 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (retval = 0) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-1))) X_semaphore_abandon_oc ) ”
  &&  “ (Crtos_GTrans held held ) ”
  &&  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
) \/
(
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (resched: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval = 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((os_semaphores (held))))) (id_pre)) = false)) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : (resched = 0)) (PreH8 : (sem = 0)) (PreH9 : (idnode = 0)) (PreH10 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ (Crtos_GTrans held held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-1))) X_semaphore_abandon_oc ) ”
  &&  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
).

Definition _SemaphoreAbandon_entail_wit_2_2_split_goal_1 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (resched: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval = 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((os_semaphores (held))))) (id_pre)) = false)) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : (resched = 0)) (PreH8 : (sem = 0)) (PreH9 : (idnode = 0)) (PreH10 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ (Crtos_GTrans held held ) ”
.

Definition _SemaphoreAbandon_entail_wit_2_2_split_goal_2 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (resched: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval = 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((os_semaphores (held))))) (id_pre)) = false)) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : (resched = 0)) (PreH8 : (sem = 0)) (PreH9 : (idnode = 0)) (PreH10 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-1))) X_semaphore_abandon_oc ) ”
.

Definition _SemaphoreAbandon_entail_wit_2_2_split_goal_spatial :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (resched: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval = 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((os_semaphores (held))))) (id_pre)) = false)) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : (resched = 0)) (PreH8 : (sem = 0)) (PreH9 : (idnode = 0)) (PreH10 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
.

Definition _SemaphoreAbandon_entail_wit_3 :=
(
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (resched: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval <> 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((os_semaphores (held))))) (id_pre)) = true)) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : (resched = 0)) (PreH8 : (sem = 0)) (PreH9 : (idnode = 0)) (PreH10 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_idmanager_found (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) retval id_pre )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  EX (original: SemaphoreAbs),
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_addr (original)) <> 0) ”
  &&  “ (0 <= (semaphore_value (original))) ”
  &&  “ ((semaphore_value (original)) <= 65535) ”
  &&  “ (retval = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ (Crtos_RTrans before_semaphore_abandon_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc ) ”
  &&  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
) \/
(
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (resched: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval <> 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((os_semaphores (held))))) (id_pre)) = true)) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : (resched = 0)) (PreH8 : (sem = 0)) (PreH9 : (idnode = 0)) (PreH10 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_idmanager_found (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) retval id_pre )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  EX (original: SemaphoreAbs),
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_addr (original)) <> 0) ”
  &&  “ (0 <= (semaphore_value (original))) ”
  &&  “ ((semaphore_value (original)) <= 65535) ”
  &&  “ (retval = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ (Crtos_RTrans before_semaphore_abandon_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc ) ”
  &&  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
).

Definition _SemaphoreAbandon_entail_wit_4 :=
(
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : ((semaphore_addr (original)) = (semaphore_addr (original)))) (PreH2 : (retval_2 = 0)) (PreH3 : (retval_2 = 0)) (PreH4 : ((map (sched_link_node) ((semaphore_pending_addrs (original)))) <> (@nil (@DL_Node Z)))) (PreH5 : (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH6 : (retval = (semaphore_addr (original)))) (PreH7 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH8 : (0 <= id_pre)) (PreH9 : (id_pre <= 65535)) (PreH10 : (resched = 0)) (PreH11 : (sem = 0)) (PreH12 : (In original (os_semaphores (held)) )) (PreH13 : ((semaphore_id (original)) = id_pre)) (PreH14 : ((semaphore_addr (original)) <> 0)) (PreH15 : (0 <= (semaphore_value (original)))) (PreH16 : ((semaphore_value (original)) <= 65535)) (PreH17 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH18 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (os_inv sg_semaphore_abandon_oc held )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (resched = 0) ”
  &&  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_pending_addrs (original)) <> (@nil Z)) ”
  &&  “ (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) ) ”
  &&  “ (Crtos_RTrans before_semaphore_abandon_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc ) ”
  &&  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
) \/
(
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : (retval_2 = 0)) (PreH3 : ((map (sched_link_node) ((semaphore_pending_addrs (original)))) <> (@nil (@DL_Node Z)))) (PreH4 : (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH5 : (retval = (semaphore_addr (original)))) (PreH6 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH7 : (0 <= id_pre)) (PreH8 : (id_pre <= 65535)) (PreH9 : (resched = 0)) (PreH10 : (sem = 0)) (PreH11 : (In original (os_semaphores (held)) )) (PreH12 : ((semaphore_id (original)) = id_pre)) (PreH13 : ((semaphore_addr (original)) <> 0)) (PreH14 : (0 <= (semaphore_value (original)))) (PreH15 : ((semaphore_value (original)) <= 65535)) (PreH16 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH17 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  TT && emp 
|--
  “ ((semaphore_pending_addrs (original)) <> (@nil Z)) ”
  &&  emp
).

Definition _SemaphoreAbandon_entail_wit_4_split_goal_1 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : (retval_2 = 0)) (PreH3 : ((map (sched_link_node) ((semaphore_pending_addrs (original)))) <> (@nil (@DL_Node Z)))) (PreH4 : (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH5 : (retval = (semaphore_addr (original)))) (PreH6 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH7 : (0 <= id_pre)) (PreH8 : (id_pre <= 65535)) (PreH9 : (resched = 0)) (PreH10 : (sem = 0)) (PreH11 : (In original (os_semaphores (held)) )) (PreH12 : ((semaphore_id (original)) = id_pre)) (PreH13 : ((semaphore_addr (original)) <> 0)) (PreH14 : (0 <= (semaphore_value (original)))) (PreH15 : ((semaphore_value (original)) <= 65535)) (PreH16 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH17 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((semaphore_pending_addrs (original)) <> (@nil Z))
.

Definition _SemaphoreAbandon_entail_wit_5 :=
(
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : ((semaphore_value (original)) = 65535)) (PreH2 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH3 : ((semaphore_value (original)) = 65535)) (PreH4 : (retval_2 <> 0)) (PreH5 : (retval_2 = 1)) (PreH6 : ((map (sched_link_node) ((semaphore_pending_addrs (original)))) = (@nil (@DL_Node Z)))) (PreH7 : (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH8 : (retval = (semaphore_addr (original)))) (PreH9 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH10 : (0 <= id_pre)) (PreH11 : (id_pre <= 65535)) (PreH12 : (resched = 0)) (PreH13 : (sem = 0)) (PreH14 : (In original (os_semaphores (held)) )) (PreH15 : ((semaphore_id (original)) = id_pre)) (PreH16 : ((semaphore_addr (original)) <> 0)) (PreH17 : (0 <= (semaphore_value (original)))) (PreH18 : ((semaphore_value (original)) <= 65535)) (PreH19 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH20 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (65535)) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (resched = 0) ”
  &&  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-3))) X_semaphore_abandon_oc ) ”
  &&  “ (Crtos_GTrans held held ) ”
  &&  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
) \/
(
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : ((semaphore_value (original)) = 65535)) (PreH2 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH3 : ((semaphore_value (original)) = 65535)) (PreH4 : (retval_2 <> 0)) (PreH5 : (retval_2 = 1)) (PreH6 : ((map (sched_link_node) ((semaphore_pending_addrs (original)))) = (@nil (@DL_Node Z)))) (PreH7 : (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH8 : (retval = (semaphore_addr (original)))) (PreH9 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH10 : (0 <= id_pre)) (PreH11 : (id_pre <= 65535)) (PreH12 : (resched = 0)) (PreH13 : (sem = 0)) (PreH14 : (In original (os_semaphores (held)) )) (PreH15 : ((semaphore_id (original)) = id_pre)) (PreH16 : ((semaphore_addr (original)) <> 0)) (PreH17 : (0 <= (semaphore_value (original)))) (PreH18 : ((semaphore_value (original)) <= 65535)) (PreH19 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH20 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (65535)) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ (Crtos_GTrans held held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-3))) X_semaphore_abandon_oc ) ”
  &&  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
).

Definition _SemaphoreAbandon_entail_wit_5_split_goal_1 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : ((semaphore_value (original)) = 65535)) (PreH2 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH3 : ((semaphore_value (original)) = 65535)) (PreH4 : (retval_2 <> 0)) (PreH5 : (retval_2 = 1)) (PreH6 : ((map (sched_link_node) ((semaphore_pending_addrs (original)))) = (@nil (@DL_Node Z)))) (PreH7 : (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH8 : (retval = (semaphore_addr (original)))) (PreH9 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH10 : (0 <= id_pre)) (PreH11 : (id_pre <= 65535)) (PreH12 : (resched = 0)) (PreH13 : (sem = 0)) (PreH14 : (In original (os_semaphores (held)) )) (PreH15 : ((semaphore_id (original)) = id_pre)) (PreH16 : ((semaphore_addr (original)) <> 0)) (PreH17 : (0 <= (semaphore_value (original)))) (PreH18 : ((semaphore_value (original)) <= 65535)) (PreH19 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH20 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (65535)) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ (Crtos_GTrans held held ) ”
.

Definition _SemaphoreAbandon_entail_wit_5_split_goal_2 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : ((semaphore_value (original)) = 65535)) (PreH2 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH3 : ((semaphore_value (original)) = 65535)) (PreH4 : (retval_2 <> 0)) (PreH5 : (retval_2 = 1)) (PreH6 : ((map (sched_link_node) ((semaphore_pending_addrs (original)))) = (@nil (@DL_Node Z)))) (PreH7 : (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH8 : (retval = (semaphore_addr (original)))) (PreH9 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH10 : (0 <= id_pre)) (PreH11 : (id_pre <= 65535)) (PreH12 : (resched = 0)) (PreH13 : (sem = 0)) (PreH14 : (In original (os_semaphores (held)) )) (PreH15 : ((semaphore_id (original)) = id_pre)) (PreH16 : ((semaphore_addr (original)) <> 0)) (PreH17 : (0 <= (semaphore_value (original)))) (PreH18 : ((semaphore_value (original)) <= 65535)) (PreH19 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH20 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (65535)) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-3))) X_semaphore_abandon_oc ) ”
.

Definition _SemaphoreAbandon_entail_wit_5_split_goal_spatial :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : ((semaphore_value (original)) = 65535)) (PreH2 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH3 : ((semaphore_value (original)) = 65535)) (PreH4 : (retval_2 <> 0)) (PreH5 : (retval_2 = 1)) (PreH6 : ((map (sched_link_node) ((semaphore_pending_addrs (original)))) = (@nil (@DL_Node Z)))) (PreH7 : (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH8 : (retval = (semaphore_addr (original)))) (PreH9 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH10 : (0 <= id_pre)) (PreH11 : (id_pre <= 65535)) (PreH12 : (resched = 0)) (PreH13 : (sem = 0)) (PreH14 : (In original (os_semaphores (held)) )) (PreH15 : ((semaphore_id (original)) = id_pre)) (PreH16 : ((semaphore_addr (original)) <> 0)) (PreH17 : (0 <= (semaphore_value (original)))) (PreH18 : ((semaphore_value (original)) <= 65535)) (PreH19 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH20 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (65535)) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
.

Definition _SemaphoreAbandon_entail_wit_6_1 :=
(
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (resched: Z) (sem: Z) (idnode: Z) (after: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (semaphore_resume_head_effect sem held after )) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : (resched = 0)) (PreH6 : (sem = (semaphore_addr (original)))) (PreH7 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH8 : (In original (os_semaphores (held)) )) (PreH9 : ((semaphore_id (original)) = id_pre)) (PreH10 : ((semaphore_pending_addrs (original)) <> (@nil Z))) (PreH11 : (semaphore_pending_nodes sem held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH12 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (os_inv sg_semaphore_abandon_oc after )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  EX (released: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))),
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (1 = 1) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (released)) abs_ktask_assign Y ) ”
  &&  “ forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc )) ”
  &&  “ (Crtos_GTrans held released ) ”
  &&  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc released )
) \/
(
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (resched: Z) (sem: Z) (idnode: Z) (after: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (semaphore_resume_head_effect sem held after )) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : (resched = 0)) (PreH6 : (sem = (semaphore_addr (original)))) (PreH7 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH8 : (In original (os_semaphores (held)) )) (PreH9 : ((semaphore_id (original)) = id_pre)) (PreH10 : ((semaphore_pending_addrs (original)) <> (@nil Z))) (PreH11 : (semaphore_pending_nodes sem held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH12 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  TT && emp 
|--
  EX (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))),
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign Y ) ”
  &&  “ forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc )) ”
  &&  “ (Crtos_GTrans held after ) ”
  &&  emp
).

Definition _SemaphoreAbandon_entail_wit_6_2 :=
(
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : ((semaphore_value (original)) <> 65535)) (PreH2 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH3 : (0 <= (semaphore_value (original)))) (PreH4 : ((semaphore_value (original)) < 65535)) (PreH5 : (retval_2 <> 0)) (PreH6 : (retval_2 = 1)) (PreH7 : ((map (sched_link_node) ((semaphore_pending_addrs (original)))) = (@nil (@DL_Node Z)))) (PreH8 : (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH9 : (retval = (semaphore_addr (original)))) (PreH10 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH11 : (0 <= id_pre)) (PreH12 : (id_pre <= 65535)) (PreH13 : (resched = 0)) (PreH14 : (sem = 0)) (PreH15 : (In original (os_semaphores (held)) )) (PreH16 : ((semaphore_id (original)) = id_pre)) (PreH17 : ((semaphore_addr (original)) <> 0)) (PreH18 : (0 <= (semaphore_value (original)))) (PreH19 : ((semaphore_value (original)) <= 65535)) (PreH20 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH21 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> ((semaphore_value (original)) + 1 ))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (((semaphore_value (original)) + 1 ))) (os_inv (sg_semaphore_abandon_oc) ((replace_semaphores ((semaphore_set_value ((semaphore_addr (original))) (((semaphore_value (original)) + 1 )) ((os_semaphores (held))))) (held)))) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  EX (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (released: VarGlobalState),
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ (resched = 0) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (released)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ) ”
  &&  “ forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc )) ”
  &&  “ (Crtos_GTrans held released ) ”
  &&  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc released )
) \/
(
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : ((semaphore_value (original)) <> 65535)) (PreH2 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH3 : (0 <= (semaphore_value (original)))) (PreH4 : ((semaphore_value (original)) < 65535)) (PreH5 : (retval_2 <> 0)) (PreH6 : (retval_2 = 1)) (PreH7 : ((map (sched_link_node) ((semaphore_pending_addrs (original)))) = (@nil (@DL_Node Z)))) (PreH8 : (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH9 : (retval = (semaphore_addr (original)))) (PreH10 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH11 : (0 <= id_pre)) (PreH12 : (id_pre <= 65535)) (PreH13 : (resched = 0)) (PreH14 : (sem = 0)) (PreH15 : (In original (os_semaphores (held)) )) (PreH16 : ((semaphore_id (original)) = id_pre)) (PreH17 : ((semaphore_addr (original)) <> 0)) (PreH18 : (0 <= (semaphore_value (original)))) (PreH19 : ((semaphore_value (original)) <= 65535)) (PreH20 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH21 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> ((semaphore_value (original)) + 1 ))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (((semaphore_value (original)) + 1 ))) (os_inv (sg_semaphore_abandon_oc) ((replace_semaphores ((semaphore_set_value ((semaphore_addr (original))) (((semaphore_value (original)) + 1 )) ((os_semaphores (held))))) (held)))) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  EX (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (released: VarGlobalState),
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ (resched = 0) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (released)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ) ”
  &&  “ forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc )) ”
  &&  “ (Crtos_GTrans held released ) ”
  &&  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc released )
).

Definition _SemaphoreAbandon_entail_wit_7_1 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (released: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (sem = (semaphore_addr (original)))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : (resched = 0)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (released)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc )) (PreH7 : forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ))) (PreH8 : (Crtos_GTrans held released )) (PreH9 : (resched = 0)),
  (OutsideCritical sg_semaphore_abandon_oc released )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (resched = 0) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (released)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ) ”
  &&  “ forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc )) ”
  &&  “ (Crtos_GTrans held released ) ”
  &&  “ (resched = 0) ”
  &&  (OutsideCritical sg_semaphore_abandon_oc released )
.

Definition _SemaphoreAbandon_entail_wit_7_2 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (released: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (sem = (semaphore_addr (original)))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : (resched = 1)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (released)) abs_ktask_assign Y )) (PreH7 : forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ))) (PreH8 : (Crtos_GTrans held released )) (PreH9 : (resched = 0)),
  (OutsideCritical sg_semaphore_abandon_oc released )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (resched = 0) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (released)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ) ”
  &&  “ forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc )) ”
  &&  “ (Crtos_GTrans held released ) ”
  &&  “ (resched = 0) ”
  &&  (OutsideCritical sg_semaphore_abandon_oc released )
.

Definition _SemaphoreAbandon_entail_wit_8_1 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (released: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (sem = (semaphore_addr (original)))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : (resched = 0)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (released)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc )) (PreH7 : forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ))) (PreH8 : (Crtos_GTrans held released )) (PreH9 : (resched <> 0)),
  (OutsideCritical sg_semaphore_abandon_oc released )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (resched = 1) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (released)) abs_ktask_assign Y ) ”
  &&  “ forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc )) ”
  &&  “ (Crtos_GTrans held released ) ”
  &&  “ (resched <> 0) ”
  &&  (OutsideCritical sg_semaphore_abandon_oc released )
.

Definition _SemaphoreAbandon_entail_wit_8_2 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (released: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (sem = (semaphore_addr (original)))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : (resched = 1)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (released)) abs_ktask_assign Y )) (PreH7 : forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ))) (PreH8 : (Crtos_GTrans held released )) (PreH9 : (resched <> 0)),
  (OutsideCritical sg_semaphore_abandon_oc released )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (resched = 1) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (released)) abs_ktask_assign Y ) ”
  &&  “ forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc )) ”
  &&  “ (Crtos_GTrans held released ) ”
  &&  “ (resched <> 0) ”
  &&  (OutsideCritical sg_semaphore_abandon_oc released )
.

Definition _SemaphoreAbandon_return_wit_1 :=
(
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (released: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (after_2: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (after_2)) ( MonadErr.ret  (tt)) Y )) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre <= 65535)) (PreH4 : (sem = (semaphore_addr (original)))) (PreH5 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH6 : (resched = 1)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (released)) abs_ktask_assign Y )) (PreH8 : forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ))) (PreH9 : (Crtos_GTrans held released )) (PreH10 : (resched <> 0)),
  (OutsideCritical sg_semaphore_abandon_oc after_2 )
|--
  EX (after: VarGlobalState),
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ) ”
  &&  (OutsideCritical sg_semaphore_abandon_oc after )
) \/
(
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (id_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (released: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (after_2: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (after_2)) ( MonadErr.ret  (tt)) Y )) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre <= 65535)) (PreH4 : (sem = (semaphore_addr (original)))) (PreH5 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH6 : (resched = 1)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (released)) abs_ktask_assign Y )) (PreH8 : forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ))) (PreH9 : (Crtos_GTrans held released )) (PreH10 : (resched <> 0)),
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (after_2)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ) ”
  &&  emp
).

Definition _SemaphoreAbandon_return_wit_1_split_goal_1 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (id_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (released: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (after_2: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (after_2)) ( MonadErr.ret  (tt)) Y )) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre <= 65535)) (PreH4 : (sem = (semaphore_addr (original)))) (PreH5 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH6 : (resched = 1)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (released)) abs_ktask_assign Y )) (PreH8 : forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ))) (PreH9 : (Crtos_GTrans held released )) (PreH10 : (resched <> 0)),
  ( monadesafe_lib.safeExec  (LastSeen (after_2)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc )
.

Definition _SemaphoreAbandon_return_wit_2 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (released: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (sem = (semaphore_addr (original)))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : (resched = 0)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (released)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc )) (PreH7 : forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ))) (PreH8 : (Crtos_GTrans held released )) (PreH9 : (resched = 0)),
  (OutsideCritical sg_semaphore_abandon_oc released )
|--
  EX (after: VarGlobalState),
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ) ”
  &&  (OutsideCritical sg_semaphore_abandon_oc after )
.

Definition _SemaphoreAbandon_return_wit_3 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (resched: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (resched = 0)) (PreH4 : (sem = (semaphore_addr (original)))) (PreH5 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-3))) X_semaphore_abandon_oc )) (PreH7 : (Crtos_GTrans held held )),
  (OutsideCritical sg_semaphore_abandon_oc held )
|--
  EX (after: VarGlobalState),
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  ((-3))) X_semaphore_abandon_oc ) ”
  &&  (OutsideCritical sg_semaphore_abandon_oc after )
.

Definition _SemaphoreAbandon_return_wit_4 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (resched: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (resched = 0)) (PreH4 : (sem = 0)) (PreH5 : (idnode = 0)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-1))) X_semaphore_abandon_oc )) (PreH7 : (Crtos_GTrans held held )),
  (OutsideCritical sg_semaphore_abandon_oc held )
|--
  EX (after: VarGlobalState),
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  ((-1))) X_semaphore_abandon_oc ) ”
  &&  (OutsideCritical sg_semaphore_abandon_oc after )
.

Definition _SemaphoreAbandon_return_wit_5 :=
(
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (PreH1 : (id_pre < 0)) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (OutsideCritical sg_semaphore_abandon_oc before_semaphore_abandon_oc )
|--
  EX (after: VarGlobalState),
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  ((-1))) X_semaphore_abandon_oc ) ”
  &&  (OutsideCritical sg_semaphore_abandon_oc after )
) \/
(
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (PreH1 : (id_pre < 0)) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) ( MonadErr.ret  ((-1))) X_semaphore_abandon_oc ) ”
  &&  emp
).

Definition _SemaphoreAbandon_return_wit_5_split_goal_1 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (PreH1 : (id_pre < 0)) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) ( MonadErr.ret  ((-1))) X_semaphore_abandon_oc )
.

Definition _SemaphoreAbandon_return_wit_6 :=
(
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (PreH1 : (id_pre > 65535)) (PreH2 : (id_pre >= 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (OutsideCritical sg_semaphore_abandon_oc before_semaphore_abandon_oc )
|--
  EX (after: VarGlobalState),
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  ((-1))) X_semaphore_abandon_oc ) ”
  &&  (OutsideCritical sg_semaphore_abandon_oc after )
) \/
(
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (PreH1 : (id_pre > 65535)) (PreH2 : (id_pre >= 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) ( MonadErr.ret  ((-1))) X_semaphore_abandon_oc ) ”
  &&  emp
).

Definition _SemaphoreAbandon_return_wit_6_split_goal_1 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (PreH1 : (id_pre > 65535)) (PreH2 : (id_pre >= 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) ( MonadErr.ret  ((-1))) X_semaphore_abandon_oc )
.

Definition _SemaphoreAbandon_partial_solve_wit_1 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (PreH1 : (id_pre <= 65535)) (PreH2 : (id_pre >= 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (OutsideCritical sg_semaphore_abandon_oc before_semaphore_abandon_oc )
|--
  “ (id_pre <= 65535) ”
  &&  “ (id_pre >= 0) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc ) ”
  &&  (OutsideCritical sg_semaphore_abandon_oc before_semaphore_abandon_oc )
.

Definition _SemaphoreAbandon_partial_solve_wit_2 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (resched: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (resched = 0)) (PreH4 : (sem = 0)) (PreH5 : (idnode = 0)) (PreH6 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (idnode = 0) ”
  &&  “ (Crtos_RTrans before_semaphore_abandon_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc ) ”
  &&  (os_inv sg_semaphore_abandon_oc held )
  **  (InsideCritical sg_semaphore_abandon_oc held )
.

Definition _SemaphoreAbandon_partial_solve_wit_3_pure :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (resched: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (saved: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (resched = 0)) (PreH4 : (sem = 0)) (PreH5 : (idnode = 0)) (PreH6 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre < 65536) ”
.

Definition _SemaphoreAbandon_partial_solve_wit_3_aux :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (resched: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (resched = 0)) (PreH4 : (sem = 0)) (PreH5 : (idnode = 0)) (PreH6 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre < 65536) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (idnode = 0) ”
  &&  “ (Crtos_RTrans before_semaphore_abandon_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc ) ”
  &&  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
.

Definition _SemaphoreAbandon_partial_solve_wit_3 := _SemaphoreAbandon_partial_solve_wit_3_pure -> _SemaphoreAbandon_partial_solve_wit_3_aux.

Definition _SemaphoreAbandon_partial_solve_wit_4_pure :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (resched: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (resched = 0)) (PreH4 : (sem = 0)) (PreH5 : (idnode = 0)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-1))) X_semaphore_abandon_oc )) (PreH7 : (Crtos_GTrans held held )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
|--
  “ (Crtos_GTrans held held ) ”
.

Definition _SemaphoreAbandon_partial_solve_wit_4_aux :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (resched: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (resched = 0)) (PreH4 : (sem = 0)) (PreH5 : (idnode = 0)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-1))) X_semaphore_abandon_oc )) (PreH7 : (Crtos_GTrans held held )),
  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
|--
  “ (Crtos_GTrans held held ) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (idnode = 0) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-1))) X_semaphore_abandon_oc ) ”
  &&  “ (Crtos_GTrans held held ) ”
  &&  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
.

Definition _SemaphoreAbandon_partial_solve_wit_4 := _SemaphoreAbandon_partial_solve_wit_4_pure -> _SemaphoreAbandon_partial_solve_wit_4_aux.

Definition _SemaphoreAbandon_partial_solve_wit_5_pure :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (resched = 0)) (PreH4 : (sem = 0)) (PreH5 : (In original (os_semaphores (held)) )) (PreH6 : ((semaphore_id (original)) = id_pre)) (PreH7 : ((semaphore_addr (original)) <> 0)) (PreH8 : (0 <= (semaphore_value (original)))) (PreH9 : ((semaphore_value (original)) <= 65535)) (PreH10 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH11 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH12 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
|--
  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
.

Definition _SemaphoreAbandon_partial_solve_wit_5_aux :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (resched = 0)) (PreH4 : (sem = 0)) (PreH5 : (In original (os_semaphores (held)) )) (PreH6 : ((semaphore_id (original)) = id_pre)) (PreH7 : ((semaphore_addr (original)) <> 0)) (PreH8 : (0 <= (semaphore_value (original)))) (PreH9 : ((semaphore_value (original)) <= 65535)) (PreH10 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH11 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH12 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
|--
  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_addr (original)) <> 0) ”
  &&  “ (0 <= (semaphore_value (original))) ”
  &&  “ ((semaphore_value (original)) <= 65535) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ (Crtos_RTrans before_semaphore_abandon_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc ) ”
  &&  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
.

Definition _SemaphoreAbandon_partial_solve_wit_5 := _SemaphoreAbandon_partial_solve_wit_5_pure -> _SemaphoreAbandon_partial_solve_wit_5_aux.

Definition _SemaphoreAbandon_partial_solve_wit_6_pure :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : (retval = (semaphore_addr (original)))) (PreH2 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : (resched = 0)) (PreH6 : (sem = 0)) (PreH7 : (In original (os_semaphores (held)) )) (PreH8 : ((semaphore_id (original)) = id_pre)) (PreH9 : ((semaphore_addr (original)) <> 0)) (PreH10 : (0 <= (semaphore_value (original)))) (PreH11 : ((semaphore_value (original)) <= 65535)) (PreH12 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH13 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
|--
  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
.

Definition _SemaphoreAbandon_partial_solve_wit_6_aux :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : (retval = (semaphore_addr (original)))) (PreH2 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : (resched = 0)) (PreH6 : (sem = 0)) (PreH7 : (In original (os_semaphores (held)) )) (PreH8 : ((semaphore_id (original)) = id_pre)) (PreH9 : ((semaphore_addr (original)) <> 0)) (PreH10 : (0 <= (semaphore_value (original)))) (PreH11 : ((semaphore_value (original)) <= 65535)) (PreH12 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH13 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
|--
  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
  &&  “ (retval = (semaphore_addr (original))) ”
  &&  “ (idnode = &((retval)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_addr (original)) <> 0) ”
  &&  “ (0 <= (semaphore_value (original))) ”
  &&  “ ((semaphore_value (original)) <= 65535) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ (Crtos_RTrans before_semaphore_abandon_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc ) ”
  &&  ((( &( "sem" ) )) # Ptr  |-> (semaphore_addr (original)))
  **  (os_inv sg_semaphore_abandon_oc held )
  **  (InsideCritical sg_semaphore_abandon_oc held )
.

Definition _SemaphoreAbandon_partial_solve_wit_6 := _SemaphoreAbandon_partial_solve_wit_6_pure -> _SemaphoreAbandon_partial_solve_wit_6_aux.

Definition _SemaphoreAbandon_partial_solve_wit_7 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : ((semaphore_addr (original)) = (semaphore_addr (original)))) (PreH2 : (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH3 : (retval = (semaphore_addr (original)))) (PreH4 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : (resched = 0)) (PreH8 : (sem = 0)) (PreH9 : (In original (os_semaphores (held)) )) (PreH10 : ((semaphore_id (original)) = id_pre)) (PreH11 : ((semaphore_addr (original)) <> 0)) (PreH12 : (0 <= (semaphore_value (original)))) (PreH13 : ((semaphore_value (original)) <= 65535)) (PreH14 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH15 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH16 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (held)))))) &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((semaphore_pending_addrs (original)))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (held))))))) (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list")) ((map (sched_link_node) ((semaphore_pending_addrs (original)))))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) ) ”
  &&  “ (retval = (semaphore_addr (original))) ”
  &&  “ (idnode = &((retval)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_addr (original)) <> 0) ”
  &&  “ (0 <= (semaphore_value (original))) ”
  &&  “ ((semaphore_value (original)) <= 65535) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ (Crtos_RTrans before_semaphore_abandon_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc ) ”
  &&  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (held)))))) &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((semaphore_pending_addrs (original)))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (held))))))) (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list")) ((map (sched_link_node) ((semaphore_pending_addrs (original)))))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
.

Definition _SemaphoreAbandon_partial_solve_wit_8_pure :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : (retval_2 = 0)) (PreH3 : ((map (sched_link_node) ((semaphore_pending_addrs (original)))) <> (@nil (@DL_Node Z)))) (PreH4 : (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH5 : (retval = (semaphore_addr (original)))) (PreH6 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH7 : (0 <= id_pre)) (PreH8 : (id_pre <= 65535)) (PreH9 : (resched = 0)) (PreH10 : (sem = 0)) (PreH11 : (In original (os_semaphores (held)) )) (PreH12 : ((semaphore_id (original)) = id_pre)) (PreH13 : ((semaphore_addr (original)) <> 0)) (PreH14 : (0 <= (semaphore_value (original)))) (PreH15 : ((semaphore_value (original)) <= 65535)) (PreH16 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH17 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (held)))))) &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((semaphore_pending_addrs (original)))) )
  **  ((( &( "sem" ) )) # Ptr  |-> (semaphore_addr (original)))
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (held))))))) (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list")) ((map (sched_link_node) ((semaphore_pending_addrs (original)))))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
.

Definition _SemaphoreAbandon_partial_solve_wit_8_aux :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : (retval_2 = 0)) (PreH3 : ((map (sched_link_node) ((semaphore_pending_addrs (original)))) <> (@nil (@DL_Node Z)))) (PreH4 : (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH5 : (retval = (semaphore_addr (original)))) (PreH6 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH7 : (0 <= id_pre)) (PreH8 : (id_pre <= 65535)) (PreH9 : (resched = 0)) (PreH10 : (sem = 0)) (PreH11 : (In original (os_semaphores (held)) )) (PreH12 : ((semaphore_id (original)) = id_pre)) (PreH13 : ((semaphore_addr (original)) <> 0)) (PreH14 : (0 <= (semaphore_value (original)))) (PreH15 : ((semaphore_value (original)) <= 65535)) (PreH16 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH17 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (held)))))) &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((semaphore_pending_addrs (original)))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (held))))))) (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list")) ((map (sched_link_node) ((semaphore_pending_addrs (original)))))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
  &&  “ (retval_2 = 0) ”
  &&  “ (retval_2 = 0) ”
  &&  “ ((map (sched_link_node) ((semaphore_pending_addrs (original)))) <> (@nil (@DL_Node Z))) ”
  &&  “ (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) ) ”
  &&  “ (retval = (semaphore_addr (original))) ”
  &&  “ (idnode = &((retval)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_addr (original)) <> 0) ”
  &&  “ (0 <= (semaphore_value (original))) ”
  &&  “ ((semaphore_value (original)) <= 65535) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ (Crtos_RTrans before_semaphore_abandon_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc ) ”
  &&  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (held)))))) &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((semaphore_pending_addrs (original)))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (held))))))) (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list")) ((map (sched_link_node) ((semaphore_pending_addrs (original)))))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
.

Definition _SemaphoreAbandon_partial_solve_wit_8 := _SemaphoreAbandon_partial_solve_wit_8_pure -> _SemaphoreAbandon_partial_solve_wit_8_aux.

Definition _SemaphoreAbandon_partial_solve_wit_9_pure :=
(
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (resched: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (resched = 0)) (PreH4 : (sem = (semaphore_addr (original)))) (PreH5 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH6 : (In original (os_semaphores (held)) )) (PreH7 : ((semaphore_id (original)) = id_pre)) (PreH8 : ((semaphore_pending_addrs (original)) <> (@nil Z))) (PreH9 : (semaphore_pending_nodes sem held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH10 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> 1)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
|--
  “ ((semaphore_pending_addrs (original)) <> (@nil Z)) ”
  &&  “ (semaphore_pending_nodes sem held (map (sched_link_node) ((semaphore_pending_addrs (original)))) ) ”
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") = (semaphore_pending_head (sem))) ”
) \/
(
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (resched: Z) (sem: Z) (idnode: Z) (PreH1 : (1 <= INT_MAX)) (PreH2 : (saved <= INT_MAX)) (PreH3 : (id_pre <= INT_MAX)) (PreH4 : (1 >= INT_MIN)) (PreH5 : (saved >= INT_MIN)) (PreH6 : (id_pre >= INT_MIN)) (PreH7 : (0 <= id_pre)) (PreH8 : (id_pre <= 65535)) (PreH9 : (resched = 0)) (PreH10 : (sem = (semaphore_addr (original)))) (PreH11 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH12 : (In original (os_semaphores (held)) )) (PreH13 : ((semaphore_id (original)) = id_pre)) (PreH14 : ((semaphore_pending_addrs (original)) <> (@nil Z))) (PreH15 : (semaphore_pending_nodes sem held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH16 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> 1)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
|--
  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") = (semaphore_pending_head (sem))) ”
).

Definition _SemaphoreAbandon_partial_solve_wit_9_pure_split_goal_1 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (resched: Z) (sem: Z) (idnode: Z) (PreH1 : (1 <= INT_MAX)) (PreH2 : (saved <= INT_MAX)) (PreH3 : (id_pre <= INT_MAX)) (PreH4 : (1 >= INT_MIN)) (PreH5 : (saved >= INT_MIN)) (PreH6 : (id_pre >= INT_MIN)) (PreH7 : (0 <= id_pre)) (PreH8 : (id_pre <= 65535)) (PreH9 : (resched = 0)) (PreH10 : (sem = (semaphore_addr (original)))) (PreH11 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH12 : (In original (os_semaphores (held)) )) (PreH13 : ((semaphore_id (original)) = id_pre)) (PreH14 : ((semaphore_pending_addrs (original)) <> (@nil Z))) (PreH15 : (semaphore_pending_nodes sem held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH16 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> 1)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
|--
  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") = (semaphore_pending_head (sem))) ”
.

Definition _SemaphoreAbandon_partial_solve_wit_9_aux :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (resched: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (resched = 0)) (PreH4 : (sem = (semaphore_addr (original)))) (PreH5 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH6 : (In original (os_semaphores (held)) )) (PreH7 : ((semaphore_id (original)) = id_pre)) (PreH8 : ((semaphore_pending_addrs (original)) <> (@nil Z))) (PreH9 : (semaphore_pending_nodes sem held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH10 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
|--
  “ ((semaphore_pending_addrs (original)) <> (@nil Z)) ”
  &&  “ (semaphore_pending_nodes sem held (map (sched_link_node) ((semaphore_pending_addrs (original)))) ) ”
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") = (semaphore_pending_head (sem))) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_pending_addrs (original)) <> (@nil Z)) ”
  &&  “ (semaphore_pending_nodes sem held (map (sched_link_node) ((semaphore_pending_addrs (original)))) ) ”
  &&  “ (Crtos_RTrans before_semaphore_abandon_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc ) ”
  &&  (os_inv sg_semaphore_abandon_oc held )
  **  (InsideCritical sg_semaphore_abandon_oc held )
.

Definition _SemaphoreAbandon_partial_solve_wit_9 := _SemaphoreAbandon_partial_solve_wit_9_pure -> _SemaphoreAbandon_partial_solve_wit_9_aux.

Definition _SemaphoreAbandon_partial_solve_wit_10_pure :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 <> 0)) (PreH2 : (retval_2 = 1)) (PreH3 : ((map (sched_link_node) ((semaphore_pending_addrs (original)))) = (@nil (@DL_Node Z)))) (PreH4 : (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH5 : (retval = (semaphore_addr (original)))) (PreH6 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH7 : (0 <= id_pre)) (PreH8 : (id_pre <= 65535)) (PreH9 : (resched = 0)) (PreH10 : (sem = 0)) (PreH11 : (In original (os_semaphores (held)) )) (PreH12 : ((semaphore_id (original)) = id_pre)) (PreH13 : ((semaphore_addr (original)) <> 0)) (PreH14 : (0 <= (semaphore_value (original)))) (PreH15 : ((semaphore_value (original)) <= 65535)) (PreH16 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH17 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (held)))))) &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((semaphore_pending_addrs (original)))) )
  **  ((( &( "sem" ) )) # Ptr  |-> (semaphore_addr (original)))
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (held))))))) (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list")) ((map (sched_link_node) ((semaphore_pending_addrs (original)))))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
.

Definition _SemaphoreAbandon_partial_solve_wit_10_aux :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : (retval_2 <> 0)) (PreH2 : (retval_2 = 1)) (PreH3 : ((map (sched_link_node) ((semaphore_pending_addrs (original)))) = (@nil (@DL_Node Z)))) (PreH4 : (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH5 : (retval = (semaphore_addr (original)))) (PreH6 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH7 : (0 <= id_pre)) (PreH8 : (id_pre <= 65535)) (PreH9 : (resched = 0)) (PreH10 : (sem = 0)) (PreH11 : (In original (os_semaphores (held)) )) (PreH12 : ((semaphore_id (original)) = id_pre)) (PreH13 : ((semaphore_addr (original)) <> 0)) (PreH14 : (0 <= (semaphore_value (original)))) (PreH15 : ((semaphore_value (original)) <= 65535)) (PreH16 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH17 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (held)))))) &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((semaphore_pending_addrs (original)))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (held))))))) (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list")) ((map (sched_link_node) ((semaphore_pending_addrs (original)))))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
  &&  “ (retval_2 <> 0) ”
  &&  “ (retval_2 = 1) ”
  &&  “ ((map (sched_link_node) ((semaphore_pending_addrs (original)))) = (@nil (@DL_Node Z))) ”
  &&  “ (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) ) ”
  &&  “ (retval = (semaphore_addr (original))) ”
  &&  “ (idnode = &((retval)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_addr (original)) <> 0) ”
  &&  “ (0 <= (semaphore_value (original))) ”
  &&  “ ((semaphore_value (original)) <= 65535) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ (Crtos_RTrans before_semaphore_abandon_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc ) ”
  &&  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (held)))))) &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((semaphore_pending_addrs (original)))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (held))))))) (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "pend_list")) ((map (sched_link_node) ((semaphore_pending_addrs (original)))))) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
.

Definition _SemaphoreAbandon_partial_solve_wit_10 := _SemaphoreAbandon_partial_solve_wit_10_pure -> _SemaphoreAbandon_partial_solve_wit_10_aux.

Definition _SemaphoreAbandon_partial_solve_wit_11_pure :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : ((semaphore_addr (original)) = (semaphore_addr (original)))) (PreH2 : (retval_2 <> 0)) (PreH3 : (retval_2 = 1)) (PreH4 : ((map (sched_link_node) ((semaphore_pending_addrs (original)))) = (@nil (@DL_Node Z)))) (PreH5 : (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH6 : (retval = (semaphore_addr (original)))) (PreH7 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH8 : (0 <= id_pre)) (PreH9 : (id_pre <= 65535)) (PreH10 : (resched = 0)) (PreH11 : (sem = 0)) (PreH12 : (In original (os_semaphores (held)) )) (PreH13 : ((semaphore_id (original)) = id_pre)) (PreH14 : ((semaphore_addr (original)) <> 0)) (PreH15 : (0 <= (semaphore_value (original)))) (PreH16 : ((semaphore_value (original)) <= 65535)) (PreH17 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH18 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((( &( "sem" ) )) # Ptr  |-> (semaphore_addr (original)))
  **  (os_inv sg_semaphore_abandon_oc held )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
  &&  “ ((map (sched_link_node) ((semaphore_pending_addrs (original)))) = (@nil (@DL_Node Z))) ”
.

Definition _SemaphoreAbandon_partial_solve_wit_11_aux :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : ((semaphore_addr (original)) = (semaphore_addr (original)))) (PreH2 : (retval_2 <> 0)) (PreH3 : (retval_2 = 1)) (PreH4 : ((map (sched_link_node) ((semaphore_pending_addrs (original)))) = (@nil (@DL_Node Z)))) (PreH5 : (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH6 : (retval = (semaphore_addr (original)))) (PreH7 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH8 : (0 <= id_pre)) (PreH9 : (id_pre <= 65535)) (PreH10 : (resched = 0)) (PreH11 : (sem = 0)) (PreH12 : (In original (os_semaphores (held)) )) (PreH13 : ((semaphore_id (original)) = id_pre)) (PreH14 : ((semaphore_addr (original)) <> 0)) (PreH15 : (0 <= (semaphore_value (original)))) (PreH16 : ((semaphore_value (original)) <= 65535)) (PreH17 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH18 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  (os_inv sg_semaphore_abandon_oc held )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
  &&  “ ((map (sched_link_node) ((semaphore_pending_addrs (original)))) = (@nil (@DL_Node Z))) ”
  &&  “ (retval_2 <> 0) ”
  &&  “ (retval_2 = 1) ”
  &&  “ ((map (sched_link_node) ((semaphore_pending_addrs (original)))) = (@nil (@DL_Node Z))) ”
  &&  “ (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) ) ”
  &&  “ (retval = (semaphore_addr (original))) ”
  &&  “ (idnode = &((retval)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_addr (original)) <> 0) ”
  &&  “ (0 <= (semaphore_value (original))) ”
  &&  “ ((semaphore_value (original)) <= 65535) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ (Crtos_RTrans before_semaphore_abandon_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc ) ”
  &&  (os_inv sg_semaphore_abandon_oc held )
  **  (InsideCritical sg_semaphore_abandon_oc held )
.

Definition _SemaphoreAbandon_partial_solve_wit_11 := _SemaphoreAbandon_partial_solve_wit_11_pure -> _SemaphoreAbandon_partial_solve_wit_11_aux.

Definition _SemaphoreAbandon_partial_solve_wit_12 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : ((semaphore_addr (original)) = (semaphore_addr (original)))) (PreH2 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH3 : (0 <= (semaphore_value (original)))) (PreH4 : ((semaphore_value (original)) < 65535)) (PreH5 : (retval_2 <> 0)) (PreH6 : (retval_2 = 1)) (PreH7 : ((map (sched_link_node) ((semaphore_pending_addrs (original)))) = (@nil (@DL_Node Z)))) (PreH8 : (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH9 : (retval = (semaphore_addr (original)))) (PreH10 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH11 : (0 <= id_pre)) (PreH12 : (id_pre <= 65535)) (PreH13 : (resched = 0)) (PreH14 : (sem = 0)) (PreH15 : (In original (os_semaphores (held)) )) (PreH16 : ((semaphore_id (original)) = id_pre)) (PreH17 : ((semaphore_addr (original)) <> 0)) (PreH18 : (0 <= (semaphore_value (original)))) (PreH19 : ((semaphore_value (original)) <= 65535)) (PreH20 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH21 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (((semaphore_value (original)) + 1 ))) (os_inv (sg_semaphore_abandon_oc) ((replace_semaphores ((semaphore_set_value ((semaphore_addr (original))) (((semaphore_value (original)) + 1 )) ((os_semaphores (held))))) (held)))) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ ((semaphore_pending_addrs (original)) = (@nil Z)) ”
  &&  “ (0 <= (semaphore_value (original))) ”
  &&  “ ((semaphore_value (original)) < 65535) ”
  &&  “ (retval_2 <> 0) ”
  &&  “ (retval_2 = 1) ”
  &&  “ ((map (sched_link_node) ((semaphore_pending_addrs (original)))) = (@nil (@DL_Node Z))) ”
  &&  “ (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) ) ”
  &&  “ (retval = (semaphore_addr (original))) ”
  &&  “ (idnode = &((retval)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_addr (original)) <> 0) ”
  &&  “ (0 <= (semaphore_value (original))) ”
  &&  “ ((semaphore_value (original)) <= 65535) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ (Crtos_RTrans before_semaphore_abandon_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc ) ”
  &&  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (((semaphore_value (original)) + 1 ))) (os_inv (sg_semaphore_abandon_oc) ((replace_semaphores ((semaphore_set_value ((semaphore_addr (original))) (((semaphore_value (original)) + 1 )) ((os_semaphores (held))))) (held)))) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
.

Definition _SemaphoreAbandon_partial_solve_wit_13 :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_abandon_oc: VarGlobalState) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (resched: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (retval_2: Z) (PreH1 : ((semaphore_addr (original)) = (semaphore_addr (original)))) (PreH2 : ((semaphore_pending_addrs (original)) = (@nil Z))) (PreH3 : ((semaphore_value (original)) = 65535)) (PreH4 : (retval_2 <> 0)) (PreH5 : (retval_2 = 1)) (PreH6 : ((map (sched_link_node) ((semaphore_pending_addrs (original)))) = (@nil (@DL_Node Z)))) (PreH7 : (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH8 : (retval = (semaphore_addr (original)))) (PreH9 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH10 : (0 <= id_pre)) (PreH11 : (id_pre <= 65535)) (PreH12 : (resched = 0)) (PreH13 : (sem = 0)) (PreH14 : (In original (os_semaphores (held)) )) (PreH15 : ((semaphore_id (original)) = id_pre)) (PreH16 : ((semaphore_addr (original)) <> 0)) (PreH17 : (0 <= (semaphore_value (original)))) (PreH18 : ((semaphore_value (original)) <= 65535)) (PreH19 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH20 : (Crtos_RTrans before_semaphore_abandon_oc held )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc )),
  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> 65535)
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (65535)) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
|--
  “ ((semaphore_pending_addrs (original)) = (@nil Z)) ”
  &&  “ ((semaphore_value (original)) = 65535) ”
  &&  “ (retval_2 <> 0) ”
  &&  “ (retval_2 = 1) ”
  &&  “ ((map (sched_link_node) ((semaphore_pending_addrs (original)))) = (@nil (@DL_Node Z))) ”
  &&  “ (semaphore_pending_nodes (semaphore_addr (original)) held (map (sched_link_node) ((semaphore_pending_addrs (original)))) ) ”
  &&  “ (retval = (semaphore_addr (original))) ”
  &&  “ (idnode = &((retval)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_addr (original)) <> 0) ”
  &&  “ (0 <= (semaphore_value (original))) ”
  &&  “ ((semaphore_value (original)) <= 65535) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ (Crtos_RTrans before_semaphore_abandon_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_abandon_oc)) (abs_semaphore_abandon (sg_semaphore_abandon_oc) (id_pre)) X_semaphore_abandon_oc ) ”
  &&  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (65535)) (os_inv (sg_semaphore_abandon_oc) (held)) )
  **  (InsideCritical sg_semaphore_abandon_oc held )
.

Definition _SemaphoreAbandon_partial_solve_wit_14_pure :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (resched: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (resched = 0)) (PreH4 : (sem = (semaphore_addr (original)))) (PreH5 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-3))) X_semaphore_abandon_oc )) (PreH7 : (Crtos_GTrans held held )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
|--
  “ (Crtos_GTrans held held ) ”
.

Definition _SemaphoreAbandon_partial_solve_wit_14_aux :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (resched: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (resched = 0)) (PreH4 : (sem = (semaphore_addr (original)))) (PreH5 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-3))) X_semaphore_abandon_oc )) (PreH7 : (Crtos_GTrans held held )),
  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
|--
  “ (Crtos_GTrans held held ) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (resched = 0) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-3))) X_semaphore_abandon_oc ) ”
  &&  “ (Crtos_GTrans held held ) ”
  &&  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc held )
.

Definition _SemaphoreAbandon_partial_solve_wit_14 := _SemaphoreAbandon_partial_solve_wit_14_pure -> _SemaphoreAbandon_partial_solve_wit_14_aux.

Definition _SemaphoreAbandon_partial_solve_wit_15_pure :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (released: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (sem = (semaphore_addr (original)))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : (resched = 0)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (released)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc )) (PreH7 : forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ))) (PreH8 : (Crtos_GTrans held released )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc released )
|--
  “ (Crtos_GTrans held released ) ”
.

Definition _SemaphoreAbandon_partial_solve_wit_15_aux :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (released: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (sem = (semaphore_addr (original)))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : (resched = 0)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (released)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc )) (PreH7 : forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ))) (PreH8 : (Crtos_GTrans held released )),
  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc released )
|--
  “ (Crtos_GTrans held released ) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (resched = 0) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (released)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ) ”
  &&  “ forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc )) ”
  &&  “ (Crtos_GTrans held released ) ”
  &&  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc released )
.

Definition _SemaphoreAbandon_partial_solve_wit_15 := _SemaphoreAbandon_partial_solve_wit_15_pure -> _SemaphoreAbandon_partial_solve_wit_15_aux.

Definition _SemaphoreAbandon_partial_solve_wit_16_pure :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (released: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (sem = (semaphore_addr (original)))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : (resched = 1)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (released)) abs_ktask_assign Y )) (PreH7 : forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ))) (PreH8 : (Crtos_GTrans held released )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc released )
|--
  “ (Crtos_GTrans held released ) ”
.

Definition _SemaphoreAbandon_partial_solve_wit_16_aux :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (released: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (sem = (semaphore_addr (original)))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : (resched = 1)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (released)) abs_ktask_assign Y )) (PreH7 : forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ))) (PreH8 : (Crtos_GTrans held released )),
  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc released )
|--
  “ (Crtos_GTrans held released ) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (resched = 1) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (released)) abs_ktask_assign Y ) ”
  &&  “ forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc )) ”
  &&  “ (Crtos_GTrans held released ) ”
  &&  (InsideCritical sg_semaphore_abandon_oc held )
  **  (os_inv sg_semaphore_abandon_oc released )
.

Definition _SemaphoreAbandon_partial_solve_wit_16 := _SemaphoreAbandon_partial_solve_wit_16_pure -> _SemaphoreAbandon_partial_solve_wit_16_aux.

Definition _SemaphoreAbandon_partial_solve_wit_17_pure :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (released: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (sem = (semaphore_addr (original)))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : (resched = 1)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (released)) abs_ktask_assign Y )) (PreH7 : forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ))) (PreH8 : (Crtos_GTrans held released )) (PreH9 : (resched <> 0)),
  (OutsideCritical sg_semaphore_abandon_oc released )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "resched" ) )) # Int  |-> resched)
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (released)) abs_ktask_assign Y ) ”
.

Definition _SemaphoreAbandon_partial_solve_wit_17_aux :=
forall (X_semaphore_abandon_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_abandon_oc: StableGlobalState) (id_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (idnode: Z) (resched: Z) (released: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : (sem = (semaphore_addr (original)))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : (resched = 1)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (released)) abs_ktask_assign Y )) (PreH7 : forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc ))) (PreH8 : (Crtos_GTrans held released )) (PreH9 : (resched <> 0)),
  (OutsideCritical sg_semaphore_abandon_oc released )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (released)) abs_ktask_assign Y ) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (resched = 1) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (released)) abs_ktask_assign Y ) ”
  &&  “ forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (0)) X_semaphore_abandon_oc )) ”
  &&  “ (Crtos_GTrans held released ) ”
  &&  “ (resched <> 0) ”
  &&  (OutsideCritical sg_semaphore_abandon_oc released )
.

Definition _SemaphoreAbandon_partial_solve_wit_17 := _SemaphoreAbandon_partial_solve_wit_17_pure -> _SemaphoreAbandon_partial_solve_wit_17_aux.

Definition _SemaphoreAbandon_which_implies_wit_1 :=
(
forall (sg_semaphore_abandon_oc: StableGlobalState) (held: VarGlobalState),
  (os_inv sg_semaphore_abandon_oc held )
|--
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_abandon_oc) (held)) )
) \/
(
forall (sg_semaphore_abandon_oc: StableGlobalState) (held: VarGlobalState),
  (os_inv sg_semaphore_abandon_oc held )
|--
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_abandon_oc) (held)) )
).

Definition _SemaphoreAbandon_which_implies_wit_1_split_goal_spatial :=
forall (sg_semaphore_abandon_oc: StableGlobalState) (held: VarGlobalState),
  (os_inv sg_semaphore_abandon_oc held )
|--
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_abandon_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_abandon_oc) (held)) )
.

Definition _SemaphoreAbandon_which_implies_wit_2 :=
(
forall (sg_semaphore_abandon_oc: StableGlobalState) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (PreH1 : (In original (os_semaphores (held)) )) (PreH2 : (sem = (semaphore_addr (original)))),
  (os_inv sg_semaphore_abandon_oc held )
|--
  “ (sem = (semaphore_addr (original))) ”
  &&  “ (semaphore_pending_nodes sem held (map (sched_link_node) ((semaphore_pending_addrs (original)))) ) ”
  &&  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (held)))))) &((sem)  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((semaphore_pending_addrs (original)))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (held))))))) (&((sem)  # "Semaphore" ->ₛ "pend_list")) ((map (sched_link_node) ((semaphore_pending_addrs (original)))))) (os_inv (sg_semaphore_abandon_oc) (held)) )
) \/
(
forall (sg_semaphore_abandon_oc: StableGlobalState) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (PreH1 : (In original (os_semaphores (held)) )) (PreH2 : (sem = (semaphore_addr (original)))),
  (os_inv sg_semaphore_abandon_oc held )
|--
  “ (semaphore_pending_nodes sem held (map (sched_link_node) ((semaphore_pending_addrs (original)))) ) ”
  &&  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (held)))))) &((sem)  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((semaphore_pending_addrs (original)))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (held))))))) (&((sem)  # "Semaphore" ->ₛ "pend_list")) ((map (sched_link_node) ((semaphore_pending_addrs (original)))))) (os_inv (sg_semaphore_abandon_oc) (held)) )
).

Definition _SemaphoreAbandon_which_implies_wit_2_split_goal_1 :=
forall (sg_semaphore_abandon_oc: StableGlobalState) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (PreH1 : (In original (os_semaphores (held)) )) (PreH2 : (sem = (semaphore_addr (original)))),
  (os_inv sg_semaphore_abandon_oc held )
|--
  “ (semaphore_pending_nodes sem held (map (sched_link_node) ((semaphore_pending_addrs (original)))) ) ”
.

Definition _SemaphoreAbandon_which_implies_wit_2_split_goal_spatial :=
forall (sg_semaphore_abandon_oc: StableGlobalState) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (PreH1 : (In original (os_semaphores (held)) )) (PreH2 : (sem = (semaphore_addr (original)))),
  (os_inv sg_semaphore_abandon_oc held )
|--
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (held)))))) &((sem)  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((semaphore_pending_addrs (original)))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (held))))))) (&((sem)  # "Semaphore" ->ₛ "pend_list")) ((map (sched_link_node) ((semaphore_pending_addrs (original)))))) (os_inv (sg_semaphore_abandon_oc) (held)) )
.

Definition _SemaphoreAbandon_which_implies_wit_3 :=
(
forall (sg_semaphore_abandon_oc: StableGlobalState) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (PreH1 : (sem = (semaphore_addr (original)))),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (held)))))) &((sem)  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((semaphore_pending_addrs (original)))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (held))))))) (&((sem)  # "Semaphore" ->ₛ "pend_list")) ((map (sched_link_node) ((semaphore_pending_addrs (original)))))) (os_inv (sg_semaphore_abandon_oc) (held)) )
|--
  “ (sem = (semaphore_addr (original))) ”
  &&  (os_inv sg_semaphore_abandon_oc held )
) \/
(
forall (sg_semaphore_abandon_oc: StableGlobalState) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (PreH1 : (sem = (semaphore_addr (original)))),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (held)))))) &((sem)  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((semaphore_pending_addrs (original)))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (held))))))) (&((sem)  # "Semaphore" ->ₛ "pend_list")) ((map (sched_link_node) ((semaphore_pending_addrs (original)))))) (os_inv (sg_semaphore_abandon_oc) (held)) )
|--
  (os_inv sg_semaphore_abandon_oc held )
).

Definition _SemaphoreAbandon_which_implies_wit_3_split_goal_spatial :=
forall (sg_semaphore_abandon_oc: StableGlobalState) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (PreH1 : (sem = (semaphore_addr (original)))),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (held)))))) &((sem)  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((semaphore_pending_addrs (original)))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (held))))))) (&((sem)  # "Semaphore" ->ₛ "pend_list")) ((map (sched_link_node) ((semaphore_pending_addrs (original)))))) (os_inv (sg_semaphore_abandon_oc) (held)) )
|--
  (os_inv sg_semaphore_abandon_oc held )
.

Definition _SemaphoreAbandon_which_implies_wit_4 :=
(
forall (sg_semaphore_abandon_oc: StableGlobalState) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (PreH1 : (sem = (semaphore_addr (original)))),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (held)))))) &((sem)  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((semaphore_pending_addrs (original)))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (held))))))) (&((sem)  # "Semaphore" ->ₛ "pend_list")) ((map (sched_link_node) ((semaphore_pending_addrs (original)))))) (os_inv (sg_semaphore_abandon_oc) (held)) )
|--
  “ (sem = (semaphore_addr (original))) ”
  &&  (os_inv sg_semaphore_abandon_oc held )
) \/
(
forall (sg_semaphore_abandon_oc: StableGlobalState) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (PreH1 : (sem = (semaphore_addr (original)))),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (held)))))) &((sem)  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((semaphore_pending_addrs (original)))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (held))))))) (&((sem)  # "Semaphore" ->ₛ "pend_list")) ((map (sched_link_node) ((semaphore_pending_addrs (original)))))) (os_inv (sg_semaphore_abandon_oc) (held)) )
|--
  (os_inv sg_semaphore_abandon_oc held )
).

Definition _SemaphoreAbandon_which_implies_wit_4_split_goal_spatial :=
forall (sg_semaphore_abandon_oc: StableGlobalState) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (PreH1 : (sem = (semaphore_addr (original)))),
  (store_dll (pure_suspend_sched_link ((task_desc_map ((os_tasks (held)))))) &((sem)  # "Semaphore" ->ₛ "pend_list") (map (sched_link_node) ((semaphore_pending_addrs (original)))) )
  **  (wand (store_dll ((pure_suspend_sched_link ((task_desc_map ((os_tasks (held))))))) (&((sem)  # "Semaphore" ->ₛ "pend_list")) ((map (sched_link_node) ((semaphore_pending_addrs (original)))))) (os_inv (sg_semaphore_abandon_oc) (held)) )
|--
  (os_inv sg_semaphore_abandon_oc held )
.

Definition _SemaphoreAbandon_which_implies_wit_5 :=
forall (sg_semaphore_abandon_oc: StableGlobalState) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (PreH1 : (In original (os_semaphores (held)) )) (PreH2 : (sem = (semaphore_addr (original)))) (PreH3 : ((map (sched_link_node) ((semaphore_pending_addrs (original)))) = (@nil (@DL_Node Z)))),
  (os_inv sg_semaphore_abandon_oc held )
|--
  (“ (sem = (semaphore_addr (original))) ”
  &&  “ ((semaphore_pending_addrs (original)) = (@nil Z)) ”
  &&  “ ((semaphore_value (original)) = 65535) ”
  &&  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 65535)
  **  (wand (store_ushort (&((sem)  # "Semaphore" ->ₛ "value")) (65535)) (os_inv (sg_semaphore_abandon_oc) (held)) ))
  ||
  (“ (sem = (semaphore_addr (original))) ”
  &&  “ ((semaphore_pending_addrs (original)) = (@nil Z)) ”
  &&  “ (0 <= (semaphore_value (original))) ”
  &&  “ ((semaphore_value (original)) < 65535) ”
  &&  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
  **  (wand (store_ushort (&((sem)  # "Semaphore" ->ₛ "value")) (((semaphore_value (original)) + 1 ))) (os_inv (sg_semaphore_abandon_oc) ((replace_semaphores ((semaphore_set_value (sem) (((semaphore_value (original)) + 1 )) ((os_semaphores (held))))) (held)))) ))
.

Definition _SemaphoreAbandon_which_implies_wit_6 :=
forall (original: SemaphoreAbs) (sem: Z),
  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
|--
  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
.

Module Type VC_Correct.


Axiom proof_of__SemaphoreAbandon_safety_wit_1 : _SemaphoreAbandon_safety_wit_1.
Axiom proof_of__SemaphoreAbandon_safety_wit_2 : _SemaphoreAbandon_safety_wit_2.
Axiom proof_of__SemaphoreAbandon_safety_wit_3 : _SemaphoreAbandon_safety_wit_3.
Axiom proof_of__SemaphoreAbandon_safety_wit_4 : _SemaphoreAbandon_safety_wit_4.
Axiom proof_of__SemaphoreAbandon_safety_wit_5 : _SemaphoreAbandon_safety_wit_5.
Axiom proof_of__SemaphoreAbandon_safety_wit_6 : _SemaphoreAbandon_safety_wit_6.
Axiom proof_of__SemaphoreAbandon_safety_wit_7 : _SemaphoreAbandon_safety_wit_7.
Axiom proof_of__SemaphoreAbandon_safety_wit_8 : _SemaphoreAbandon_safety_wit_8.
Axiom proof_of__SemaphoreAbandon_safety_wit_9 : _SemaphoreAbandon_safety_wit_9.
Axiom proof_of__SemaphoreAbandon_safety_wit_10 : _SemaphoreAbandon_safety_wit_10.
Axiom proof_of__SemaphoreAbandon_safety_wit_11 : _SemaphoreAbandon_safety_wit_11.
Axiom proof_of__SemaphoreAbandon_safety_wit_12 : _SemaphoreAbandon_safety_wit_12.
Axiom proof_of__SemaphoreAbandon_safety_wit_13 : _SemaphoreAbandon_safety_wit_13.
Axiom proof_of__SemaphoreAbandon_safety_wit_14 : _SemaphoreAbandon_safety_wit_14.
Axiom proof_of__SemaphoreAbandon_safety_wit_15 : _SemaphoreAbandon_safety_wit_15.
Axiom proof_of__SemaphoreAbandon_safety_wit_16 : _SemaphoreAbandon_safety_wit_16.
Axiom proof_of__SemaphoreAbandon_safety_wit_17 : _SemaphoreAbandon_safety_wit_17.
Axiom proof_of__SemaphoreAbandon_safety_wit_18 : _SemaphoreAbandon_safety_wit_18.
Axiom proof_of__SemaphoreAbandon_safety_wit_19 : _SemaphoreAbandon_safety_wit_19.
Axiom proof_of__SemaphoreAbandon_safety_wit_20 : _SemaphoreAbandon_safety_wit_20.
Axiom proof_of__SemaphoreAbandon_safety_wit_21 : _SemaphoreAbandon_safety_wit_21.
Axiom proof_of__SemaphoreAbandon_safety_wit_22 : _SemaphoreAbandon_safety_wit_22.
Axiom proof_of__SemaphoreAbandon_safety_wit_23 : _SemaphoreAbandon_safety_wit_23.
Axiom proof_of__SemaphoreAbandon_safety_wit_24 : _SemaphoreAbandon_safety_wit_24.
Axiom proof_of__SemaphoreAbandon_safety_wit_25 : _SemaphoreAbandon_safety_wit_25.
Axiom proof_of__SemaphoreAbandon_safety_wit_26 : _SemaphoreAbandon_safety_wit_26.
Axiom proof_of__SemaphoreAbandon_safety_wit_27 : _SemaphoreAbandon_safety_wit_27.
Axiom proof_of__SemaphoreAbandon_safety_wit_28 : _SemaphoreAbandon_safety_wit_28.
Axiom proof_of__SemaphoreAbandon_safety_wit_29 : _SemaphoreAbandon_safety_wit_29.
Axiom proof_of__SemaphoreAbandon_safety_wit_30 : _SemaphoreAbandon_safety_wit_30.
Axiom proof_of__SemaphoreAbandon_safety_wit_31 : _SemaphoreAbandon_safety_wit_31.
Axiom proof_of__SemaphoreAbandon_entail_wit_1 : _SemaphoreAbandon_entail_wit_1.
Axiom proof_of__SemaphoreAbandon_entail_wit_2_1 : _SemaphoreAbandon_entail_wit_2_1.
Axiom proof_of__SemaphoreAbandon_entail_wit_2_2 : _SemaphoreAbandon_entail_wit_2_2.
Axiom proof_of__SemaphoreAbandon_entail_wit_3 : _SemaphoreAbandon_entail_wit_3.
Axiom proof_of__SemaphoreAbandon_entail_wit_4 : _SemaphoreAbandon_entail_wit_4.
Axiom proof_of__SemaphoreAbandon_entail_wit_5 : _SemaphoreAbandon_entail_wit_5.
Axiom proof_of__SemaphoreAbandon_entail_wit_6_1 : _SemaphoreAbandon_entail_wit_6_1.
Axiom proof_of__SemaphoreAbandon_entail_wit_6_2 : _SemaphoreAbandon_entail_wit_6_2.
Axiom proof_of__SemaphoreAbandon_entail_wit_7_1 : _SemaphoreAbandon_entail_wit_7_1.
Axiom proof_of__SemaphoreAbandon_entail_wit_7_2 : _SemaphoreAbandon_entail_wit_7_2.
Axiom proof_of__SemaphoreAbandon_entail_wit_8_1 : _SemaphoreAbandon_entail_wit_8_1.
Axiom proof_of__SemaphoreAbandon_entail_wit_8_2 : _SemaphoreAbandon_entail_wit_8_2.
Axiom proof_of__SemaphoreAbandon_return_wit_1 : _SemaphoreAbandon_return_wit_1.
Axiom proof_of__SemaphoreAbandon_return_wit_2 : _SemaphoreAbandon_return_wit_2.
Axiom proof_of__SemaphoreAbandon_return_wit_3 : _SemaphoreAbandon_return_wit_3.
Axiom proof_of__SemaphoreAbandon_return_wit_4 : _SemaphoreAbandon_return_wit_4.
Axiom proof_of__SemaphoreAbandon_return_wit_5 : _SemaphoreAbandon_return_wit_5.
Axiom proof_of__SemaphoreAbandon_return_wit_6 : _SemaphoreAbandon_return_wit_6.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_1 : _SemaphoreAbandon_partial_solve_wit_1.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_2 : _SemaphoreAbandon_partial_solve_wit_2.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_3_pure : _SemaphoreAbandon_partial_solve_wit_3_pure.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_3 : _SemaphoreAbandon_partial_solve_wit_3.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_4_pure : _SemaphoreAbandon_partial_solve_wit_4_pure.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_4 : _SemaphoreAbandon_partial_solve_wit_4.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_5_pure : _SemaphoreAbandon_partial_solve_wit_5_pure.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_5 : _SemaphoreAbandon_partial_solve_wit_5.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_6_pure : _SemaphoreAbandon_partial_solve_wit_6_pure.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_6 : _SemaphoreAbandon_partial_solve_wit_6.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_7 : _SemaphoreAbandon_partial_solve_wit_7.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_8_pure : _SemaphoreAbandon_partial_solve_wit_8_pure.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_8 : _SemaphoreAbandon_partial_solve_wit_8.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_9_pure : _SemaphoreAbandon_partial_solve_wit_9_pure.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_9 : _SemaphoreAbandon_partial_solve_wit_9.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_10_pure : _SemaphoreAbandon_partial_solve_wit_10_pure.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_10 : _SemaphoreAbandon_partial_solve_wit_10.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_11_pure : _SemaphoreAbandon_partial_solve_wit_11_pure.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_11 : _SemaphoreAbandon_partial_solve_wit_11.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_12 : _SemaphoreAbandon_partial_solve_wit_12.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_13 : _SemaphoreAbandon_partial_solve_wit_13.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_14_pure : _SemaphoreAbandon_partial_solve_wit_14_pure.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_14 : _SemaphoreAbandon_partial_solve_wit_14.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_15_pure : _SemaphoreAbandon_partial_solve_wit_15_pure.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_15 : _SemaphoreAbandon_partial_solve_wit_15.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_16_pure : _SemaphoreAbandon_partial_solve_wit_16_pure.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_16 : _SemaphoreAbandon_partial_solve_wit_16.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_17_pure : _SemaphoreAbandon_partial_solve_wit_17_pure.
Axiom proof_of__SemaphoreAbandon_partial_solve_wit_17 : _SemaphoreAbandon_partial_solve_wit_17.
Axiom proof_of__SemaphoreAbandon_which_implies_wit_1 : _SemaphoreAbandon_which_implies_wit_1.
Axiom proof_of__SemaphoreAbandon_which_implies_wit_2 : _SemaphoreAbandon_which_implies_wit_2.
Axiom proof_of__SemaphoreAbandon_which_implies_wit_3 : _SemaphoreAbandon_which_implies_wit_3.
Axiom proof_of__SemaphoreAbandon_which_implies_wit_4 : _SemaphoreAbandon_which_implies_wit_4.
Axiom proof_of__SemaphoreAbandon_which_implies_wit_5 : _SemaphoreAbandon_which_implies_wit_5.
Axiom proof_of__SemaphoreAbandon_which_implies_wit_6 : _SemaphoreAbandon_which_implies_wit_6.

End VC_Correct.
