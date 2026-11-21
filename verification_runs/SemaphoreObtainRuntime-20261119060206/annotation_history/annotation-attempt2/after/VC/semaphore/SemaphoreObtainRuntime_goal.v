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
Local Open Scope sac.

(*----- Function _SemaphoreObtain -----*)

Definition _SemaphoreObtain_safety_wit_1 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "lock" ) )) # Int  |->_)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreObtain_safety_wit_2 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "wait_time" ) )) # Int  |->_)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreObtain_safety_wit_3 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreObtain_safety_wit_4 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "sem" ) )) # Ptr  |->_)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreObtain_safety_wit_5 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "idnode" ) )) # Ptr  |->_)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreObtain_safety_wit_6 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : ((INT_MIN) <= msec_pre)) (PreH2 : (msec_pre <= INT_MAX)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreObtain_safety_wit_7 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (id_pre >= 0)) (PreH2 : ((INT_MIN) <= msec_pre)) (PreH3 : (msec_pre <= INT_MAX)) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (65535 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 65535) ”
.

Definition _SemaphoreObtain_safety_wit_8 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (id_pre > 65535)) (PreH2 : (id_pre >= 0)) (PreH3 : ((INT_MIN) <= msec_pre)) (PreH4 : (msec_pre <= INT_MAX)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (1 <> (INT_MIN)) ”
.

Definition _SemaphoreObtain_safety_wit_9 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (id_pre < 0)) (PreH2 : ((INT_MIN) <= msec_pre)) (PreH3 : (msec_pre <= INT_MAX)) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (1 <> (INT_MIN)) ”
.

Definition _SemaphoreObtain_safety_wit_10 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (id_pre < 0)) (PreH2 : ((INT_MIN) <= msec_pre)) (PreH3 : (msec_pre <= INT_MAX)) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition _SemaphoreObtain_safety_wit_11 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (id_pre > 65535)) (PreH2 : (id_pre >= 0)) (PreH3 : ((INT_MIN) <= msec_pre)) (PreH4 : (msec_pre <= INT_MAX)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition _SemaphoreObtain_safety_wit_12 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (id_pre <= 65535)) (PreH2 : (id_pre >= 0)) (PreH3 : ((INT_MIN) <= msec_pre)) (PreH4 : (msec_pre <= INT_MAX)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreObtain_safety_wit_13 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre < 0)) (PreH2 : (id_pre <= 65535)) (PreH3 : (id_pre >= 0)) (PreH4 : ((INT_MIN) <= msec_pre)) (PreH5 : (msec_pre <= INT_MAX)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (1 <> (INT_MIN)) ”
.

Definition _SemaphoreObtain_safety_wit_14 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre < 0)) (PreH2 : (id_pre <= 65535)) (PreH3 : (id_pre >= 0)) (PreH4 : ((INT_MIN) <= msec_pre)) (PreH5 : (msec_pre <= INT_MAX)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition _SemaphoreObtain_safety_wit_15 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre <> (-1))) (PreH2 : (msec_pre < 0)) (PreH3 : (id_pre <= 65535)) (PreH4 : (id_pre >= 0)) (PreH5 : ((INT_MIN) <= msec_pre)) (PreH6 : (msec_pre <= INT_MAX)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (1 <> (INT_MIN)) ”
.

Definition _SemaphoreObtain_safety_wit_16 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre <> (-1))) (PreH2 : (msec_pre < 0)) (PreH3 : (id_pre <= 65535)) (PreH4 : (id_pre >= 0)) (PreH5 : ((INT_MIN) <= msec_pre)) (PreH6 : (msec_pre <= INT_MAX)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition _SemaphoreObtain_safety_wit_17 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre >= 0)) (PreH2 : (id_pre <= 65535)) (PreH3 : (id_pre >= 0)) (PreH4 : ((INT_MIN) <= msec_pre)) (PreH5 : (msec_pre <= INT_MAX)) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreObtain_safety_wit_18 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre = (-1))) (PreH2 : (msec_pre < 0)) (PreH3 : (id_pre <= 65535)) (PreH4 : (id_pre >= 0)) (PreH5 : ((INT_MIN) <= msec_pre)) (PreH6 : (msec_pre <= INT_MAX)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreObtain_safety_wit_19 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre = 0)) (PreH2 : (msec_pre = (-1))) (PreH3 : (msec_pre < 0)) (PreH4 : (id_pre <= 65535)) (PreH5 : (id_pre >= 0)) (PreH6 : ((INT_MIN) <= msec_pre)) (PreH7 : (msec_pre <= INT_MAX)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ False ”
.

Definition _SemaphoreObtain_safety_wit_20 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre = 0)) (PreH2 : (msec_pre >= 0)) (PreH3 : (id_pre <= 65535)) (PreH4 : (id_pre >= 0)) (PreH5 : ((INT_MIN) <= msec_pre)) (PreH6 : (msec_pre <= INT_MAX)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreObtain_safety_wit_21 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre <> 0)) (PreH2 : (msec_pre = (-1))) (PreH3 : (msec_pre < 0)) (PreH4 : (id_pre <= 65535)) (PreH5 : (id_pre >= 0)) (PreH6 : ((INT_MIN) <= msec_pre)) (PreH7 : (msec_pre <= INT_MAX)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (1 <> (INT_MIN)) ”
.

Definition _SemaphoreObtain_safety_wit_22 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre <> 0)) (PreH2 : (msec_pre >= 0)) (PreH3 : (id_pre <= 65535)) (PreH4 : (id_pre >= 0)) (PreH5 : ((INT_MIN) <= msec_pre)) (PreH6 : (msec_pre <= INT_MAX)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (1 <> (INT_MIN)) ”
.

Definition _SemaphoreObtain_safety_wit_23 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre <> 0)) (PreH2 : (msec_pre >= 0)) (PreH3 : (id_pre <= 65535)) (PreH4 : (id_pre >= 0)) (PreH5 : ((INT_MIN) <= msec_pre)) (PreH6 : (msec_pre <= INT_MAX)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition _SemaphoreObtain_safety_wit_24 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre <> 0)) (PreH2 : (msec_pre = (-1))) (PreH3 : (msec_pre < 0)) (PreH4 : (id_pre <= 65535)) (PreH5 : (id_pre >= 0)) (PreH6 : ((INT_MIN) <= msec_pre)) (PreH7 : (msec_pre <= INT_MAX)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition _SemaphoreObtain_safety_wit_25 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre = (-1))) (PreH2 : (msec_pre <> 0)) (PreH3 : (msec_pre >= 0)) (PreH4 : (id_pre <= 65535)) (PreH5 : (id_pre >= 0)) (PreH6 : ((INT_MIN) <= msec_pre)) (PreH7 : (msec_pre <= INT_MAX)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ False ”
.

Definition _SemaphoreObtain_safety_wit_26 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre <> (-1))) (PreH2 : (msec_pre <> 0)) (PreH3 : (msec_pre = (-1))) (PreH4 : (msec_pre < 0)) (PreH5 : (id_pre <= 65535)) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= msec_pre)) (PreH8 : (msec_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ False ”
.

Definition _SemaphoreObtain_safety_wit_27 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre = (-1))) (PreH2 : (msec_pre <> 0)) (PreH3 : (msec_pre = (-1))) (PreH4 : (msec_pre < 0)) (PreH5 : (id_pre <= 65535)) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= msec_pre)) (PreH8 : (msec_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (1 <> (INT_MIN)) ”
.

Definition _SemaphoreObtain_safety_wit_28 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre = (-1))) (PreH2 : (msec_pre <> 0)) (PreH3 : (msec_pre = (-1))) (PreH4 : (msec_pre < 0)) (PreH5 : (id_pre <= 65535)) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= msec_pre)) (PreH8 : (msec_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "idnode" ) )) # Ptr  |-> 0)
  **  ((( &( "sem" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "wait_time" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition _SemaphoreObtain_safety_wit_29 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (saved: Z) (retval: Z) (PreH1 : (( &( "k_sem_id_manager" ) ) = 0)) (PreH2 : (retval = 0)) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : ((-1) <= msec_pre)) (PreH6 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH7 : ((-1) <= wait_time)) (PreH8 : (wait_time < KTICK_HALF_RANGE)) (PreH9 : (task = 0)) (PreH10 : (sem = 0)) (PreH11 : (idnode = 0)) (PreH12 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval)
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreObtain_safety_wit_30 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (saved: Z) (retval: Z) (PreH1 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH2 : (retval = 0)) (PreH3 : ((idmanager_query ((semaphore_manager ((os_semaphores (held))))) (id_pre)) = false)) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= 65535)) (PreH6 : ((-1) <= msec_pre)) (PreH7 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH8 : ((-1) <= wait_time)) (PreH9 : (wait_time < KTICK_HALF_RANGE)) (PreH10 : (task = 0)) (PreH11 : (sem = 0)) (PreH12 : (idnode = 0)) (PreH13 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval)
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreObtain_safety_wit_31 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (saved: Z) (retval: Z) (PreH1 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH2 : (retval <> 0)) (PreH3 : ((idmanager_query ((semaphore_manager ((os_semaphores (held))))) (id_pre)) = true)) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= 65535)) (PreH6 : ((-1) <= msec_pre)) (PreH7 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH8 : ((-1) <= wait_time)) (PreH9 : (wait_time < KTICK_HALF_RANGE)) (PreH10 : (task = 0)) (PreH11 : (sem = 0)) (PreH12 : (idnode = 0)) (PreH13 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (store_idmanager_found (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) retval id_pre )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval)
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreObtain_safety_wit_32 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (saved: Z) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) = 0)) (PreH3 : (retval = 0)) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= 65535)) (PreH6 : ((-1) <= msec_pre)) (PreH7 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH8 : ((-1) <= wait_time)) (PreH9 : (wait_time < KTICK_HALF_RANGE)) (PreH10 : (task = 0)) (PreH11 : (sem = 0)) (PreH12 : (idnode = 0)) (PreH13 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval)
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ False ”
.

Definition _SemaphoreObtain_safety_wit_33 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (saved: Z) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval = 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((os_semaphores (held))))) (id_pre)) = false)) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : ((-1) <= msec_pre)) (PreH8 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH9 : ((-1) <= wait_time)) (PreH10 : (wait_time < KTICK_HALF_RANGE)) (PreH11 : (task = 0)) (PreH12 : (sem = 0)) (PreH13 : (idnode = 0)) (PreH14 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval)
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ False ”
.

Definition _SemaphoreObtain_safety_wit_34 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (saved: Z) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval <> 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((os_semaphores (held))))) (id_pre)) = true)) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : ((-1) <= msec_pre)) (PreH8 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH9 : ((-1) <= wait_time)) (PreH10 : (wait_time < KTICK_HALF_RANGE)) (PreH11 : (task = 0)) (PreH12 : (sem = 0)) (PreH13 : (idnode = 0)) (PreH14 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (store_idmanager_found (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) retval id_pre )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> retval)
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ False ”
.

Definition _SemaphoreObtain_safety_wit_35 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : (task = 0)) (PreH6 : (sem = 0)) (PreH7 : (idnode = 0)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-1))) X_semaphore_obtain_oc )) (PreH9 : (Crtos_GTrans held held )),
  (OutsideCritical sg_semaphore_obtain_oc held )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
|--
  “ (1 <> (INT_MIN)) ”
.

Definition _SemaphoreObtain_safety_wit_36 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : (task = 0)) (PreH6 : (sem = 0)) (PreH7 : (idnode = 0)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-1))) X_semaphore_obtain_oc )) (PreH9 : (Crtos_GTrans held held )),
  (OutsideCritical sg_semaphore_obtain_oc held )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition _SemaphoreObtain_safety_wit_37 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : (0 < (semaphore_value (original)))) (PreH2 : (retval = (semaphore_addr (original)))) (PreH3 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= 65535)) (PreH6 : ((-1) <= msec_pre)) (PreH7 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH8 : ((-1) <= wait_time)) (PreH9 : (wait_time < KTICK_HALF_RANGE)) (PreH10 : (0 <= id_pre)) (PreH11 : (id_pre <= 65535)) (PreH12 : (task = 0)) (PreH13 : (sem = 0)) (PreH14 : (In original (os_semaphores (held)) )) (PreH15 : ((semaphore_id (original)) = id_pre)) (PreH16 : ((semaphore_addr (original)) <> 0)) (PreH17 : (0 <= (semaphore_value (original)))) (PreH18 : ((semaphore_value (original)) <= 65535)) (PreH19 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH20 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "sem" ) )) # Ptr  |-> (semaphore_addr (original)))
  **  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (((semaphore_value (original)) - 1 ))) (os_inv (sg_semaphore_obtain_oc) ((replace_semaphores ((semaphore_set_value ((semaphore_addr (original))) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)))) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreObtain_safety_wit_38 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : ((semaphore_value (original)) = 0)) (PreH2 : (retval = (semaphore_addr (original)))) (PreH3 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= 65535)) (PreH6 : ((-1) <= msec_pre)) (PreH7 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH8 : ((-1) <= wait_time)) (PreH9 : (wait_time < KTICK_HALF_RANGE)) (PreH10 : (0 <= id_pre)) (PreH11 : (id_pre <= 65535)) (PreH12 : (task = 0)) (PreH13 : (sem = 0)) (PreH14 : (In original (os_semaphores (held)) )) (PreH15 : ((semaphore_id (original)) = id_pre)) (PreH16 : ((semaphore_addr (original)) <> 0)) (PreH17 : (0 <= (semaphore_value (original)))) (PreH18 : ((semaphore_value (original)) <= 65535)) (PreH19 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH20 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "sem" ) )) # Ptr  |-> (semaphore_addr (original)))
  **  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (0)) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreObtain_safety_wit_39 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : ((semaphore_value (original)) <= 0)) (PreH2 : (0 < (semaphore_value (original)))) (PreH3 : (retval = (semaphore_addr (original)))) (PreH4 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : ((-1) <= msec_pre)) (PreH8 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH9 : ((-1) <= wait_time)) (PreH10 : (wait_time < KTICK_HALF_RANGE)) (PreH11 : (0 <= id_pre)) (PreH12 : (id_pre <= 65535)) (PreH13 : (task = 0)) (PreH14 : (sem = 0)) (PreH15 : (In original (os_semaphores (held)) )) (PreH16 : ((semaphore_id (original)) = id_pre)) (PreH17 : ((semaphore_addr (original)) <> 0)) (PreH18 : (0 <= (semaphore_value (original)))) (PreH19 : ((semaphore_value (original)) <= 65535)) (PreH20 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH21 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "sem" ) )) # Ptr  |-> (semaphore_addr (original)))
  **  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (((semaphore_value (original)) - 1 ))) (os_inv (sg_semaphore_obtain_oc) ((replace_semaphores ((semaphore_set_value ((semaphore_addr (original))) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)))) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ False ”
.

Definition _SemaphoreObtain_safety_wit_40 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : ((semaphore_value (original)) > 0)) (PreH2 : ((semaphore_value (original)) = 0)) (PreH3 : (retval = (semaphore_addr (original)))) (PreH4 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : ((-1) <= msec_pre)) (PreH8 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH9 : ((-1) <= wait_time)) (PreH10 : (wait_time < KTICK_HALF_RANGE)) (PreH11 : (0 <= id_pre)) (PreH12 : (id_pre <= 65535)) (PreH13 : (task = 0)) (PreH14 : (sem = 0)) (PreH15 : (In original (os_semaphores (held)) )) (PreH16 : ((semaphore_id (original)) = id_pre)) (PreH17 : ((semaphore_addr (original)) <> 0)) (PreH18 : (0 <= (semaphore_value (original)))) (PreH19 : ((semaphore_value (original)) <= 65535)) (PreH20 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH21 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "sem" ) )) # Ptr  |-> (semaphore_addr (original)))
  **  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (0)) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ False ”
.

Definition _SemaphoreObtain_safety_wit_41 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : (task = 0)) (PreH6 : (sem = (semaphore_addr (original)))) (PreH7 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen ((replace_semaphores ((semaphore_set_value (sem) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)))) ( MonadErr.ret  (0)) X_semaphore_obtain_oc )) (PreH9 : (Crtos_GTrans held (replace_semaphores ((semaphore_set_value (sem) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)) )),
  (OutsideCritical sg_semaphore_obtain_oc (replace_semaphores ((semaphore_set_value ((semaphore_addr (original))) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreObtain_safety_wit_42 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : ((semaphore_addr (original)) = (semaphore_addr (original)))) (PreH2 : ((semaphore_value (original)) <= 0)) (PreH3 : ((semaphore_value (original)) = 0)) (PreH4 : (retval = (semaphore_addr (original)))) (PreH5 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH6 : (0 <= id_pre)) (PreH7 : (id_pre <= 65535)) (PreH8 : ((-1) <= msec_pre)) (PreH9 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH10 : ((-1) <= wait_time)) (PreH11 : (wait_time < KTICK_HALF_RANGE)) (PreH12 : (0 <= id_pre)) (PreH13 : (id_pre <= 65535)) (PreH14 : (task = 0)) (PreH15 : (sem = 0)) (PreH16 : (In original (os_semaphores (held)) )) (PreH17 : ((semaphore_id (original)) = id_pre)) (PreH18 : ((semaphore_addr (original)) <> 0)) (PreH19 : (0 <= (semaphore_value (original)))) (PreH20 : ((semaphore_value (original)) <= 65535)) (PreH21 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH22 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH23 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "sem" ) )) # Ptr  |-> (semaphore_addr (original)))
  **  (os_inv sg_semaphore_obtain_oc held )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreObtain_safety_wit_43 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = 0)) (PreH5 : (task = 0)) (PreH6 : (sem = (semaphore_addr (original)))) (PreH7 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-2))) X_semaphore_obtain_oc )) (PreH9 : (Crtos_GTrans held held )),
  (OutsideCritical sg_semaphore_obtain_oc held )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
|--
  “ (2 <> (INT_MIN)) ”
.

Definition _SemaphoreObtain_safety_wit_44 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = 0)) (PreH5 : (task = 0)) (PreH6 : (sem = (semaphore_addr (original)))) (PreH7 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-2))) X_semaphore_obtain_oc )) (PreH9 : (Crtos_GTrans held held )),
  (OutsideCritical sg_semaphore_obtain_oc held )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
|--
  “ (2 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 2) ”
.

Definition _SemaphoreObtain_safety_wit_45 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (desc: TaskDescriptorAbs) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : (wait_time <> 0)) (PreH6 : ((-1) <= wait_time)) (PreH7 : (wait_time < KTICK_HALF_RANGE)) (PreH8 : (task = (assignRunningTask ((os_assign (held)))))) (PreH9 : (task <> 0)) (PreH10 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH11 : (sem = (semaphore_addr (original)))) (PreH12 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH13 : (In original (os_semaphores (held)) )) (PreH14 : ((semaphore_id (original)) = id_pre)) (PreH15 : ((semaphore_value (original)) = 0)) (PreH16 : (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held )) (PreH17 : forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < wait_time) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) ))))))) (PreH18 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((&((task)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (desc.(tdExstatus) ))
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (wand (store_int (&((task)  # "TaskDescriptor" ->ₛ "exstatus")) (0)) (os_inv (sg_semaphore_obtain_oc) ((semaphore_clear_status (task) (desc) (held)))) )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreObtain_safety_wit_46 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : (wait_time <> 0)) (PreH6 : ((-1) <= wait_time)) (PreH7 : (wait_time < KTICK_HALF_RANGE)) (PreH8 : (task = (assignRunningTask ((os_assign (held)))))) (PreH9 : (task <> 0)) (PreH10 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH11 : (sem = (semaphore_addr (original)))) (PreH12 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH13 : (In original (os_semaphores (held)) )) (PreH14 : ((semaphore_id (original)) = id_pre)) (PreH15 : ((semaphore_value (original)) = 0)) (PreH16 : (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held )) (PreH17 : forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < wait_time) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) ))))))) (PreH18 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )) (PreH20 : (semaphore_pending_nodes sem (semaphore_clear_status (task) (desc) (held)) (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH21 : (linklist_suspend_admissible task 1 (semaphore_clear_status (task) (desc) (held)) )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc (semaphore_clear_status (task) (desc) (held)) )
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition _SemaphoreObtain_safety_wit_47 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : (wait_time <> 0)) (PreH6 : ((-1) <= wait_time)) (PreH7 : (wait_time < KTICK_HALF_RANGE)) (PreH8 : (task = (assignRunningTask ((os_assign (held)))))) (PreH9 : (task <> 0)) (PreH10 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH11 : (sem = (semaphore_addr (original)))) (PreH12 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH13 : (In original (os_semaphores (held)) )) (PreH14 : ((semaphore_id (original)) = id_pre)) (PreH15 : ((semaphore_value (original)) = 0)) (PreH16 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH17 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH18 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH19 : ((0 < wait_time) -> ((((sd.(tdDelay) ) = 0) \/ (((suspended.(os_delays) ).(delay_inactive_map) ((sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) )))) (PreH20 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc suspended )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreObtain_safety_wit_48 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (delay_frame: Assertion) (delay_after: Z) (st_after: VarGlobalState) (retval: Z) (PreH1 : (ktask_set_delay_step task sd wait_time delay_after suspended retval st_after )) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre <= 65535)) (PreH4 : ((-1) <= msec_pre)) (PreH5 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH6 : (0 < wait_time)) (PreH7 : (wait_time < KTICK_HALF_RANGE)) (PreH8 : (task = (assignRunningTask ((os_assign (held)))))) (PreH9 : (task <> 0)) (PreH10 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH11 : (sem = (semaphore_addr (original)))) (PreH12 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH13 : (In original (os_semaphores (held)) )) (PreH14 : ((semaphore_id (original)) = id_pre)) (PreH15 : ((semaphore_value (original)) = 0)) (PreH16 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH17 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH18 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH19 : (((suspended.(os_delays) ).(delay_inactive_map) ((sd.(tdDelay) ))) <> None)) (PreH20 : (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) )) (PreH21 : (os_global_context sg_semaphore_obtain_oc )) (PreH22 : forall (delayed: VarGlobalState), forall (dp: Z), forall (rc: Z), ((ktask_set_delay_step task sd wait_time dp suspended rc delayed ) -> (derivable1 (sepcon ((store_ptr (&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) (dp))) ((sepcon ((delay_inv (sg_semaphore_obtain_oc) (delayed))) ((sepcon ((tick_inv (sg_semaphore_obtain_oc) (delayed))) (delay_frame)))))) (os_inv (sg_semaphore_obtain_oc) (delayed)) ))) (PreH23 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH24 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) # Ptr  |-> delay_after)
  **  (delay_inv sg_semaphore_obtain_oc st_after )
  **  (tick_inv sg_semaphore_obtain_oc st_after )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (andp (coq_prop ((os_global_context (sg_semaphore_obtain_oc)))) delay_frame )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreObtain_safety_wit_49 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (delay_frame: Assertion) (delay_after: Z) (st_after: VarGlobalState) (retval: Z) (PreH1 : (ktask_set_delay_step task sd wait_time delay_after suspended retval st_after )) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre <= 65535)) (PreH4 : ((-1) <= msec_pre)) (PreH5 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH6 : (0 < wait_time)) (PreH7 : (wait_time < KTICK_HALF_RANGE)) (PreH8 : (task = (assignRunningTask ((os_assign (held)))))) (PreH9 : (task <> 0)) (PreH10 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH11 : (sem = (semaphore_addr (original)))) (PreH12 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH13 : (In original (os_semaphores (held)) )) (PreH14 : ((semaphore_id (original)) = id_pre)) (PreH15 : ((semaphore_value (original)) = 0)) (PreH16 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH17 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH18 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH19 : ((sd.(tdDelay) ) = 0)) (PreH20 : (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) )) (PreH21 : (os_global_context sg_semaphore_obtain_oc )) (PreH22 : forall (delayed: VarGlobalState), forall (dp: Z), forall (rc: Z), ((ktask_set_delay_step task sd wait_time dp suspended rc delayed ) -> (derivable1 (sepcon ((store_ptr (&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) (dp))) ((sepcon ((delay_inv (sg_semaphore_obtain_oc) (delayed))) ((sepcon ((tick_inv (sg_semaphore_obtain_oc) (delayed))) (delay_frame)))))) (os_inv (sg_semaphore_obtain_oc) (delayed)) ))) (PreH23 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH24 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) # Ptr  |-> delay_after)
  **  (delay_inv sg_semaphore_obtain_oc st_after )
  **  (tick_inv sg_semaphore_obtain_oc st_after )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (andp (coq_prop ((os_global_context (sg_semaphore_obtain_oc)))) delay_frame )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _SemaphoreObtain_safety_wit_50 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (rollback_id: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (after_wakeup: VarGlobalState) (PreH1 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH2 : (task = (assignRunningTask ((os_assign (held)))))) (PreH3 : (sem = (semaphore_addr (original)))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (after_wakeup)) ( MonadErr.ret  ((-5))) X_semaphore_obtain_oc )) (PreH6 : (Crtos_GTrans held after_wakeup )),
  (OutsideCritical sg_semaphore_obtain_oc after_wakeup )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "wakeup_id" ) )) # Int  |-> rollback_id)
|--
  “ (5 <> (INT_MIN)) ”
.

Definition _SemaphoreObtain_safety_wit_51 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (rollback_id: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (after_wakeup: VarGlobalState) (PreH1 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH2 : (task = (assignRunningTask ((os_assign (held)))))) (PreH3 : (sem = (semaphore_addr (original)))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (after_wakeup)) ( MonadErr.ret  ((-5))) X_semaphore_obtain_oc )) (PreH6 : (Crtos_GTrans held after_wakeup )),
  (OutsideCritical sg_semaphore_obtain_oc after_wakeup )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "wakeup_id" ) )) # Int  |-> rollback_id)
|--
  “ (5 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 5) ”
.

Definition _SemaphoreObtain_entail_wit_1_1 :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre = 0)) (PreH2 : (msec_pre >= 0)) (PreH3 : (id_pre <= 65535)) (PreH4 : (id_pre >= 0)) (PreH5 : ((INT_MIN) <= msec_pre)) (PreH6 : (msec_pre <= INT_MAX)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (0 = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ ((-1) <= 0) ”
  &&  “ (0 < KTICK_HALF_RANGE) ”
  &&  “ (0 = 0) ”
  &&  “ (0 = 0) ”
  &&  “ (0 = 0) ”
  &&  “ (0 = 0) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre = 0)) (PreH2 : (msec_pre >= 0)) (PreH3 : (id_pre <= 65535)) (PreH4 : (id_pre >= 0)) (PreH5 : ((INT_MIN) <= msec_pre)) (PreH6 : (msec_pre <= INT_MAX)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  TT && emp 
|--
  “ (0 < KTICK_HALF_RANGE) ”
  &&  “ (0 = (semaphore_wait_ticks (0))) ”
  &&  emp
).

Definition _SemaphoreObtain_entail_wit_1_1_split_goal_1 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre = 0)) (PreH2 : (msec_pre >= 0)) (PreH3 : (id_pre <= 65535)) (PreH4 : (id_pre >= 0)) (PreH5 : ((INT_MIN) <= msec_pre)) (PreH6 : (msec_pre <= INT_MAX)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (0 < KTICK_HALF_RANGE)
.

Definition _SemaphoreObtain_entail_wit_1_1_split_goal_2 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre = 0)) (PreH2 : (msec_pre >= 0)) (PreH3 : (id_pre <= 65535)) (PreH4 : (id_pre >= 0)) (PreH5 : ((INT_MIN) <= msec_pre)) (PreH6 : (msec_pre <= INT_MAX)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (0 = (semaphore_wait_ticks (0)))
.

Definition _SemaphoreObtain_entail_wit_1_2 :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre = (-1))) (PreH2 : (msec_pre <> 0)) (PreH3 : (msec_pre = (-1))) (PreH4 : (msec_pre < 0)) (PreH5 : (id_pre <= 65535)) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= msec_pre)) (PreH8 : (msec_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ ((-1) = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ ((-1) <= (-1)) ”
  &&  “ ((-1) < KTICK_HALF_RANGE) ”
  &&  “ (0 = 0) ”
  &&  “ (0 = 0) ”
  &&  “ (0 = 0) ”
  &&  “ (0 = 0) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre = (-1))) (PreH2 : (msec_pre <> 0)) (PreH3 : (msec_pre = (-1))) (PreH4 : (msec_pre < 0)) (PreH5 : (id_pre <= 65535)) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= msec_pre)) (PreH8 : (msec_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  TT && emp 
|--
  “ ((-1) < KTICK_HALF_RANGE) ”
  &&  “ ((-1) = (semaphore_wait_ticks ((-1)))) ”
  &&  emp
).

Definition _SemaphoreObtain_entail_wit_1_2_split_goal_1 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre = (-1))) (PreH2 : (msec_pre <> 0)) (PreH3 : (msec_pre = (-1))) (PreH4 : (msec_pre < 0)) (PreH5 : (id_pre <= 65535)) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= msec_pre)) (PreH8 : (msec_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((-1) < KTICK_HALF_RANGE)
.

Definition _SemaphoreObtain_entail_wit_1_2_split_goal_2 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre = (-1))) (PreH2 : (msec_pre <> 0)) (PreH3 : (msec_pre = (-1))) (PreH4 : (msec_pre < 0)) (PreH5 : (id_pre <= 65535)) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= msec_pre)) (PreH8 : (msec_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((-1) = (semaphore_wait_ticks ((-1))))
.

Definition _SemaphoreObtain_entail_wit_1_3 :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (retval: Z) (PreH1 : (retval = (tick_from_time_ms (msec_pre)))) (PreH2 : (msec_pre <> (-1))) (PreH3 : (msec_pre <> 0)) (PreH4 : (msec_pre >= 0)) (PreH5 : (id_pre <= 65535)) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= msec_pre)) (PreH8 : (msec_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ ((signed_last_nbits (retval) (32)) = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ ((-1) <= (signed_last_nbits (retval) (32))) ”
  &&  “ ((signed_last_nbits (retval) (32)) < KTICK_HALF_RANGE) ”
  &&  “ (0 = 0) ”
  &&  “ (0 = 0) ”
  &&  “ (0 = 0) ”
  &&  “ (0 = 0) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (retval: Z) (PreH1 : (retval = (tick_from_time_ms (msec_pre)))) (PreH2 : (msec_pre <> (-1))) (PreH3 : (msec_pre <> 0)) (PreH4 : (msec_pre >= 0)) (PreH5 : (id_pre <= 65535)) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= msec_pre)) (PreH8 : (msec_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  TT && emp 
|--
  “ ((signed_last_nbits (retval) (32)) < KTICK_HALF_RANGE) ”
  &&  “ ((-1) <= (signed_last_nbits (retval) (32))) ”
  &&  “ ((signed_last_nbits (retval) (32)) = (semaphore_wait_ticks (msec_pre))) ”
  &&  emp
).

Definition _SemaphoreObtain_entail_wit_1_3_split_goal_1 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (retval: Z) (PreH1 : (retval = (tick_from_time_ms (msec_pre)))) (PreH2 : (msec_pre <> (-1))) (PreH3 : (msec_pre <> 0)) (PreH4 : (msec_pre >= 0)) (PreH5 : (id_pre <= 65535)) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= msec_pre)) (PreH8 : (msec_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((signed_last_nbits (retval) (32)) < KTICK_HALF_RANGE)
.

Definition _SemaphoreObtain_entail_wit_1_3_split_goal_2 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (retval: Z) (PreH1 : (retval = (tick_from_time_ms (msec_pre)))) (PreH2 : (msec_pre <> (-1))) (PreH3 : (msec_pre <> 0)) (PreH4 : (msec_pre >= 0)) (PreH5 : (id_pre <= 65535)) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= msec_pre)) (PreH8 : (msec_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((-1) <= (signed_last_nbits (retval) (32)))
.

Definition _SemaphoreObtain_entail_wit_1_3_split_goal_3 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (retval: Z) (PreH1 : (retval = (tick_from_time_ms (msec_pre)))) (PreH2 : (msec_pre <> (-1))) (PreH3 : (msec_pre <> 0)) (PreH4 : (msec_pre >= 0)) (PreH5 : (id_pre <= 65535)) (PreH6 : (id_pre >= 0)) (PreH7 : ((INT_MIN) <= msec_pre)) (PreH8 : (msec_pre <= INT_MAX)) (PreH9 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((signed_last_nbits (retval) (32)) = (semaphore_wait_ticks (msec_pre)))
.

Definition _SemaphoreObtain_entail_wit_2 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (wait_time: Z) (lock: Z) (task: Z) (sem: Z) (idnode: Z) (st_lock: VarGlobalState) (PreH1 : (Crtos_RTrans before_semaphore_obtain_oc st_lock )) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre <= 65535)) (PreH4 : ((-1) <= msec_pre)) (PreH5 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH6 : ((-1) <= wait_time)) (PreH7 : (wait_time < KTICK_HALF_RANGE)) (PreH8 : (lock = 0)) (PreH9 : (task = 0)) (PreH10 : (sem = 0)) (PreH11 : (idnode = 0)) (PreH12 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (InsideCritical sg_semaphore_obtain_oc st_lock )
  **  (os_inv sg_semaphore_obtain_oc st_lock )
|--
  EX (held: VarGlobalState),
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ ((-1) <= wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (task = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (idnode = 0) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc held )
.

Definition _SemaphoreObtain_entail_wit_3_1 :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) = 0)) (PreH3 : (retval = 0)) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= 65535)) (PreH6 : ((-1) <= msec_pre)) (PreH7 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH8 : ((-1) <= wait_time)) (PreH9 : (wait_time < KTICK_HALF_RANGE)) (PreH10 : (task = 0)) (PreH11 : (sem = 0)) (PreH12 : (idnode = 0)) (PreH13 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (task = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (retval = 0) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-1))) X_semaphore_obtain_oc ) ”
  &&  “ (Crtos_GTrans held held ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc held )
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) = 0)) (PreH3 : (retval = 0)) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= 65535)) (PreH6 : ((-1) <= msec_pre)) (PreH7 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH8 : ((-1) <= wait_time)) (PreH9 : (wait_time < KTICK_HALF_RANGE)) (PreH10 : (task = 0)) (PreH11 : (sem = 0)) (PreH12 : (idnode = 0)) (PreH13 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ (Crtos_GTrans held held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-1))) X_semaphore_obtain_oc ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc held )
).

Definition _SemaphoreObtain_entail_wit_3_1_split_goal_1 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) = 0)) (PreH3 : (retval = 0)) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= 65535)) (PreH6 : ((-1) <= msec_pre)) (PreH7 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH8 : ((-1) <= wait_time)) (PreH9 : (wait_time < KTICK_HALF_RANGE)) (PreH10 : (task = 0)) (PreH11 : (sem = 0)) (PreH12 : (idnode = 0)) (PreH13 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ (Crtos_GTrans held held ) ”
.

Definition _SemaphoreObtain_entail_wit_3_1_split_goal_2 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) = 0)) (PreH3 : (retval = 0)) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= 65535)) (PreH6 : ((-1) <= msec_pre)) (PreH7 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH8 : ((-1) <= wait_time)) (PreH9 : (wait_time < KTICK_HALF_RANGE)) (PreH10 : (task = 0)) (PreH11 : (sem = 0)) (PreH12 : (idnode = 0)) (PreH13 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-1))) X_semaphore_obtain_oc ) ”
.

Definition _SemaphoreObtain_entail_wit_3_1_split_goal_spatial :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) = 0)) (PreH3 : (retval = 0)) (PreH4 : (0 <= id_pre)) (PreH5 : (id_pre <= 65535)) (PreH6 : ((-1) <= msec_pre)) (PreH7 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH8 : ((-1) <= wait_time)) (PreH9 : (wait_time < KTICK_HALF_RANGE)) (PreH10 : (task = 0)) (PreH11 : (sem = 0)) (PreH12 : (idnode = 0)) (PreH13 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc held )
.

Definition _SemaphoreObtain_entail_wit_3_2 :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval = 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((os_semaphores (held))))) (id_pre)) = false)) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : ((-1) <= msec_pre)) (PreH8 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH9 : ((-1) <= wait_time)) (PreH10 : (wait_time < KTICK_HALF_RANGE)) (PreH11 : (task = 0)) (PreH12 : (sem = 0)) (PreH13 : (idnode = 0)) (PreH14 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (task = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (retval = 0) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-1))) X_semaphore_obtain_oc ) ”
  &&  “ (Crtos_GTrans held held ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc held )
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval = 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((os_semaphores (held))))) (id_pre)) = false)) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : ((-1) <= msec_pre)) (PreH8 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH9 : ((-1) <= wait_time)) (PreH10 : (wait_time < KTICK_HALF_RANGE)) (PreH11 : (task = 0)) (PreH12 : (sem = 0)) (PreH13 : (idnode = 0)) (PreH14 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ (Crtos_GTrans held held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-1))) X_semaphore_obtain_oc ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc held )
).

Definition _SemaphoreObtain_entail_wit_3_2_split_goal_1 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval = 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((os_semaphores (held))))) (id_pre)) = false)) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : ((-1) <= msec_pre)) (PreH8 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH9 : ((-1) <= wait_time)) (PreH10 : (wait_time < KTICK_HALF_RANGE)) (PreH11 : (task = 0)) (PreH12 : (sem = 0)) (PreH13 : (idnode = 0)) (PreH14 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ (Crtos_GTrans held held ) ”
.

Definition _SemaphoreObtain_entail_wit_3_2_split_goal_2 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval = 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((os_semaphores (held))))) (id_pre)) = false)) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : ((-1) <= msec_pre)) (PreH8 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH9 : ((-1) <= wait_time)) (PreH10 : (wait_time < KTICK_HALF_RANGE)) (PreH11 : (task = 0)) (PreH12 : (sem = 0)) (PreH13 : (idnode = 0)) (PreH14 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-1))) X_semaphore_obtain_oc ) ”
.

Definition _SemaphoreObtain_entail_wit_3_2_split_goal_spatial :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval = 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((os_semaphores (held))))) (id_pre)) = false)) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : ((-1) <= msec_pre)) (PreH8 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH9 : ((-1) <= wait_time)) (PreH10 : (wait_time < KTICK_HALF_RANGE)) (PreH11 : (task = 0)) (PreH12 : (sem = 0)) (PreH13 : (idnode = 0)) (PreH14 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc held )
.

Definition _SemaphoreObtain_entail_wit_4 :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval <> 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((os_semaphores (held))))) (id_pre)) = true)) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : ((-1) <= msec_pre)) (PreH8 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH9 : ((-1) <= wait_time)) (PreH10 : (wait_time < KTICK_HALF_RANGE)) (PreH11 : (task = 0)) (PreH12 : (sem = 0)) (PreH13 : (idnode = 0)) (PreH14 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (store_idmanager_found (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) retval id_pre )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  EX (original: SemaphoreAbs),
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ ((-1) <= wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (task = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_addr (original)) <> 0) ”
  &&  “ (0 <= (semaphore_value (original))) ”
  &&  “ ((semaphore_value (original)) <= 65535) ”
  &&  “ (retval = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc held )
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (( &( "k_sem_id_manager" ) ) <> 0)) (PreH3 : (retval <> 0)) (PreH4 : ((idmanager_query ((semaphore_manager ((os_semaphores (held))))) (id_pre)) = true)) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : ((-1) <= msec_pre)) (PreH8 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH9 : ((-1) <= wait_time)) (PreH10 : (wait_time < KTICK_HALF_RANGE)) (PreH11 : (task = 0)) (PreH12 : (sem = 0)) (PreH13 : (idnode = 0)) (PreH14 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (store_idmanager_found (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) retval id_pre )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  EX (original: SemaphoreAbs),
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ ((-1) <= wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (task = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_addr (original)) <> 0) ”
  &&  “ (0 <= (semaphore_value (original))) ”
  &&  “ ((semaphore_value (original)) <= 65535) ”
  &&  “ (retval = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc held )
).

Definition _SemaphoreObtain_entail_wit_5 :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : ((semaphore_value (original)) > 0)) (PreH2 : (0 < (semaphore_value (original)))) (PreH3 : (retval = (semaphore_addr (original)))) (PreH4 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : ((-1) <= msec_pre)) (PreH8 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH9 : ((-1) <= wait_time)) (PreH10 : (wait_time < KTICK_HALF_RANGE)) (PreH11 : (0 <= id_pre)) (PreH12 : (id_pre <= 65535)) (PreH13 : (task = 0)) (PreH14 : (sem = 0)) (PreH15 : (In original (os_semaphores (held)) )) (PreH16 : ((semaphore_id (original)) = id_pre)) (PreH17 : ((semaphore_addr (original)) <> 0)) (PreH18 : (0 <= (semaphore_value (original)))) (PreH19 : ((semaphore_value (original)) <= 65535)) (PreH20 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH21 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> ((semaphore_value (original)) - 1 ))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (((semaphore_value (original)) - 1 ))) (os_inv (sg_semaphore_obtain_oc) ((replace_semaphores ((semaphore_set_value ((semaphore_addr (original))) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)))) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (task = 0) ”
  &&  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen ((replace_semaphores ((semaphore_set_value ((semaphore_addr (original))) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)))) ( MonadErr.ret  (0)) X_semaphore_obtain_oc ) ”
  &&  “ (Crtos_GTrans held (replace_semaphores ((semaphore_set_value ((semaphore_addr (original))) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)) ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc (replace_semaphores ((semaphore_set_value ((semaphore_addr (original))) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)) )
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : ((semaphore_value (original)) > 0)) (PreH2 : (0 < (semaphore_value (original)))) (PreH3 : (retval = (semaphore_addr (original)))) (PreH4 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : ((-1) <= msec_pre)) (PreH8 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH9 : ((-1) <= wait_time)) (PreH10 : (wait_time < KTICK_HALF_RANGE)) (PreH11 : (0 <= id_pre)) (PreH12 : (id_pre <= 65535)) (PreH13 : (task = 0)) (PreH14 : (sem = 0)) (PreH15 : (In original (os_semaphores (held)) )) (PreH16 : ((semaphore_id (original)) = id_pre)) (PreH17 : ((semaphore_addr (original)) <> 0)) (PreH18 : (0 <= (semaphore_value (original)))) (PreH19 : ((semaphore_value (original)) <= 65535)) (PreH20 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH21 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> ((semaphore_value (original)) - 1 ))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (((semaphore_value (original)) - 1 ))) (os_inv (sg_semaphore_obtain_oc) ((replace_semaphores ((semaphore_set_value ((semaphore_addr (original))) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)))) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ (Crtos_GTrans held (replace_semaphores ((semaphore_set_value (retval) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)) ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen ((replace_semaphores ((semaphore_set_value (retval) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)))) ( MonadErr.ret  (0)) X_semaphore_obtain_oc ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc (replace_semaphores ((semaphore_set_value ((semaphore_addr (original))) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)) )
).

Definition _SemaphoreObtain_entail_wit_5_split_goal_1 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : ((semaphore_value (original)) > 0)) (PreH2 : (0 < (semaphore_value (original)))) (PreH3 : (retval = (semaphore_addr (original)))) (PreH4 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : ((-1) <= msec_pre)) (PreH8 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH9 : ((-1) <= wait_time)) (PreH10 : (wait_time < KTICK_HALF_RANGE)) (PreH11 : (0 <= id_pre)) (PreH12 : (id_pre <= 65535)) (PreH13 : (task = 0)) (PreH14 : (sem = 0)) (PreH15 : (In original (os_semaphores (held)) )) (PreH16 : ((semaphore_id (original)) = id_pre)) (PreH17 : ((semaphore_addr (original)) <> 0)) (PreH18 : (0 <= (semaphore_value (original)))) (PreH19 : ((semaphore_value (original)) <= 65535)) (PreH20 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH21 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> ((semaphore_value (original)) - 1 ))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (((semaphore_value (original)) - 1 ))) (os_inv (sg_semaphore_obtain_oc) ((replace_semaphores ((semaphore_set_value ((semaphore_addr (original))) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)))) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ (Crtos_GTrans held (replace_semaphores ((semaphore_set_value (retval) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)) ) ”
.

Definition _SemaphoreObtain_entail_wit_5_split_goal_2 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : ((semaphore_value (original)) > 0)) (PreH2 : (0 < (semaphore_value (original)))) (PreH3 : (retval = (semaphore_addr (original)))) (PreH4 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : ((-1) <= msec_pre)) (PreH8 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH9 : ((-1) <= wait_time)) (PreH10 : (wait_time < KTICK_HALF_RANGE)) (PreH11 : (0 <= id_pre)) (PreH12 : (id_pre <= 65535)) (PreH13 : (task = 0)) (PreH14 : (sem = 0)) (PreH15 : (In original (os_semaphores (held)) )) (PreH16 : ((semaphore_id (original)) = id_pre)) (PreH17 : ((semaphore_addr (original)) <> 0)) (PreH18 : (0 <= (semaphore_value (original)))) (PreH19 : ((semaphore_value (original)) <= 65535)) (PreH20 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH21 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> ((semaphore_value (original)) - 1 ))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (((semaphore_value (original)) - 1 ))) (os_inv (sg_semaphore_obtain_oc) ((replace_semaphores ((semaphore_set_value ((semaphore_addr (original))) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)))) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen ((replace_semaphores ((semaphore_set_value (retval) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)))) ( MonadErr.ret  (0)) X_semaphore_obtain_oc ) ”
.

Definition _SemaphoreObtain_entail_wit_5_split_goal_spatial :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : ((semaphore_value (original)) > 0)) (PreH2 : (0 < (semaphore_value (original)))) (PreH3 : (retval = (semaphore_addr (original)))) (PreH4 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : ((-1) <= msec_pre)) (PreH8 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH9 : ((-1) <= wait_time)) (PreH10 : (wait_time < KTICK_HALF_RANGE)) (PreH11 : (0 <= id_pre)) (PreH12 : (id_pre <= 65535)) (PreH13 : (task = 0)) (PreH14 : (sem = 0)) (PreH15 : (In original (os_semaphores (held)) )) (PreH16 : ((semaphore_id (original)) = id_pre)) (PreH17 : ((semaphore_addr (original)) <> 0)) (PreH18 : (0 <= (semaphore_value (original)))) (PreH19 : ((semaphore_value (original)) <= 65535)) (PreH20 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH21 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> ((semaphore_value (original)) - 1 ))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (((semaphore_value (original)) - 1 ))) (os_inv (sg_semaphore_obtain_oc) ((replace_semaphores ((semaphore_set_value ((semaphore_addr (original))) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)))) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc (replace_semaphores ((semaphore_set_value ((semaphore_addr (original))) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)) )
.

Definition _SemaphoreObtain_entail_wit_6 :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : (wait_time = 0)) (PreH2 : ((semaphore_addr (original)) = (semaphore_addr (original)))) (PreH3 : ((semaphore_value (original)) <= 0)) (PreH4 : ((semaphore_value (original)) = 0)) (PreH5 : (retval = (semaphore_addr (original)))) (PreH6 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH7 : (0 <= id_pre)) (PreH8 : (id_pre <= 65535)) (PreH9 : ((-1) <= msec_pre)) (PreH10 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH11 : ((-1) <= wait_time)) (PreH12 : (wait_time < KTICK_HALF_RANGE)) (PreH13 : (0 <= id_pre)) (PreH14 : (id_pre <= 65535)) (PreH15 : (task = 0)) (PreH16 : (sem = 0)) (PreH17 : (In original (os_semaphores (held)) )) (PreH18 : ((semaphore_id (original)) = id_pre)) (PreH19 : ((semaphore_addr (original)) <> 0)) (PreH20 : (0 <= (semaphore_value (original)))) (PreH21 : ((semaphore_value (original)) <= 65535)) (PreH22 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH23 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH24 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (os_inv sg_semaphore_obtain_oc held )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = 0) ”
  &&  “ (task = 0) ”
  &&  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-2))) X_semaphore_obtain_oc ) ”
  &&  “ (Crtos_GTrans held held ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc held )
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : (wait_time = 0)) (PreH2 : ((semaphore_value (original)) <= 0)) (PreH3 : ((semaphore_value (original)) = 0)) (PreH4 : (retval = (semaphore_addr (original)))) (PreH5 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH6 : (0 <= id_pre)) (PreH7 : (id_pre <= 65535)) (PreH8 : ((-1) <= msec_pre)) (PreH9 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH10 : ((-1) <= wait_time)) (PreH11 : (wait_time < KTICK_HALF_RANGE)) (PreH12 : (0 <= id_pre)) (PreH13 : (id_pre <= 65535)) (PreH14 : (task = 0)) (PreH15 : (sem = 0)) (PreH16 : (In original (os_semaphores (held)) )) (PreH17 : ((semaphore_id (original)) = id_pre)) (PreH18 : ((semaphore_addr (original)) <> 0)) (PreH19 : (0 <= (semaphore_value (original)))) (PreH20 : ((semaphore_value (original)) <= 65535)) (PreH21 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH22 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH23 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  TT && emp 
|--
  “ (Crtos_GTrans held held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-2))) X_semaphore_obtain_oc ) ”
  &&  emp
).

Definition _SemaphoreObtain_entail_wit_6_split_goal_1 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : (wait_time = 0)) (PreH2 : ((semaphore_value (original)) <= 0)) (PreH3 : ((semaphore_value (original)) = 0)) (PreH4 : (retval = (semaphore_addr (original)))) (PreH5 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH6 : (0 <= id_pre)) (PreH7 : (id_pre <= 65535)) (PreH8 : ((-1) <= msec_pre)) (PreH9 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH10 : ((-1) <= wait_time)) (PreH11 : (wait_time < KTICK_HALF_RANGE)) (PreH12 : (0 <= id_pre)) (PreH13 : (id_pre <= 65535)) (PreH14 : (task = 0)) (PreH15 : (sem = 0)) (PreH16 : (In original (os_semaphores (held)) )) (PreH17 : ((semaphore_id (original)) = id_pre)) (PreH18 : ((semaphore_addr (original)) <> 0)) (PreH19 : (0 <= (semaphore_value (original)))) (PreH20 : ((semaphore_value (original)) <= 65535)) (PreH21 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH22 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH23 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (Crtos_GTrans held held )
.

Definition _SemaphoreObtain_entail_wit_6_split_goal_2 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : (wait_time = 0)) (PreH2 : ((semaphore_value (original)) <= 0)) (PreH3 : ((semaphore_value (original)) = 0)) (PreH4 : (retval = (semaphore_addr (original)))) (PreH5 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH6 : (0 <= id_pre)) (PreH7 : (id_pre <= 65535)) (PreH8 : ((-1) <= msec_pre)) (PreH9 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH10 : ((-1) <= wait_time)) (PreH11 : (wait_time < KTICK_HALF_RANGE)) (PreH12 : (0 <= id_pre)) (PreH13 : (id_pre <= 65535)) (PreH14 : (task = 0)) (PreH15 : (sem = 0)) (PreH16 : (In original (os_semaphores (held)) )) (PreH17 : ((semaphore_id (original)) = id_pre)) (PreH18 : ((semaphore_addr (original)) <> 0)) (PreH19 : (0 <= (semaphore_value (original)))) (PreH20 : ((semaphore_value (original)) <= 65535)) (PreH21 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH22 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH23 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-2))) X_semaphore_obtain_oc )
.

Definition _SemaphoreObtain_entail_wit_7 :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : (wait_time <> 0)) (PreH2 : ((semaphore_addr (original)) = (semaphore_addr (original)))) (PreH3 : ((semaphore_value (original)) <= 0)) (PreH4 : ((semaphore_value (original)) = 0)) (PreH5 : (retval = (semaphore_addr (original)))) (PreH6 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH7 : (0 <= id_pre)) (PreH8 : (id_pre <= 65535)) (PreH9 : ((-1) <= msec_pre)) (PreH10 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH11 : ((-1) <= wait_time)) (PreH12 : (wait_time < KTICK_HALF_RANGE)) (PreH13 : (0 <= id_pre)) (PreH14 : (id_pre <= 65535)) (PreH15 : (task = 0)) (PreH16 : (sem = 0)) (PreH17 : (In original (os_semaphores (held)) )) (PreH18 : ((semaphore_id (original)) = id_pre)) (PreH19 : ((semaphore_addr (original)) <> 0)) (PreH20 : (0 <= (semaphore_value (original)))) (PreH21 : ((semaphore_value (original)) <= 65535)) (PreH22 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH23 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH24 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (os_inv sg_semaphore_obtain_oc held )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (wait_time <> 0) ”
  &&  “ ((-1) <= wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (task = 0) ”
  &&  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_value (original)) = 0) ”
  &&  “ (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held ) ”
  &&  “ forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < wait_time) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) )))))) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc held )
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : (wait_time <> 0)) (PreH2 : ((semaphore_value (original)) <= 0)) (PreH3 : ((semaphore_value (original)) = 0)) (PreH4 : (retval = (semaphore_addr (original)))) (PreH5 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH6 : (0 <= id_pre)) (PreH7 : (id_pre <= 65535)) (PreH8 : ((-1) <= msec_pre)) (PreH9 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH10 : ((-1) <= wait_time)) (PreH11 : (wait_time < KTICK_HALF_RANGE)) (PreH12 : (0 <= id_pre)) (PreH13 : (id_pre <= 65535)) (PreH14 : (task = 0)) (PreH15 : (sem = 0)) (PreH16 : (In original (os_semaphores (held)) )) (PreH17 : ((semaphore_id (original)) = id_pre)) (PreH18 : ((semaphore_addr (original)) <> 0)) (PreH19 : (0 <= (semaphore_value (original)))) (PreH20 : ((semaphore_value (original)) <= 65535)) (PreH21 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH22 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH23 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  TT && emp 
|--
  “ forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < (semaphore_wait_ticks (msec_pre))) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) )))))) ”
  &&  “ (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held ) ”
  &&  emp
).

Definition _SemaphoreObtain_entail_wit_7_split_goal_1 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : (wait_time <> 0)) (PreH2 : ((semaphore_value (original)) <= 0)) (PreH3 : ((semaphore_value (original)) = 0)) (PreH4 : (retval = (semaphore_addr (original)))) (PreH5 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH6 : (0 <= id_pre)) (PreH7 : (id_pre <= 65535)) (PreH8 : ((-1) <= msec_pre)) (PreH9 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH10 : ((-1) <= wait_time)) (PreH11 : (wait_time < KTICK_HALF_RANGE)) (PreH12 : (0 <= id_pre)) (PreH13 : (id_pre <= 65535)) (PreH14 : (task = 0)) (PreH15 : (sem = 0)) (PreH16 : (In original (os_semaphores (held)) )) (PreH17 : ((semaphore_id (original)) = id_pre)) (PreH18 : ((semaphore_addr (original)) <> 0)) (PreH19 : (0 <= (semaphore_value (original)))) (PreH20 : ((semaphore_value (original)) <= 65535)) (PreH21 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH22 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH23 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < (semaphore_wait_ticks (msec_pre))) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) ))))))
.

Definition _SemaphoreObtain_entail_wit_7_split_goal_2 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : (wait_time <> 0)) (PreH2 : ((semaphore_value (original)) <= 0)) (PreH3 : ((semaphore_value (original)) = 0)) (PreH4 : (retval = (semaphore_addr (original)))) (PreH5 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH6 : (0 <= id_pre)) (PreH7 : (id_pre <= 65535)) (PreH8 : ((-1) <= msec_pre)) (PreH9 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH10 : ((-1) <= wait_time)) (PreH11 : (wait_time < KTICK_HALF_RANGE)) (PreH12 : (0 <= id_pre)) (PreH13 : (id_pre <= 65535)) (PreH14 : (task = 0)) (PreH15 : (sem = 0)) (PreH16 : (In original (os_semaphores (held)) )) (PreH17 : ((semaphore_id (original)) = id_pre)) (PreH18 : ((semaphore_addr (original)) <> 0)) (PreH19 : (0 <= (semaphore_value (original)))) (PreH20 : ((semaphore_value (original)) <= 65535)) (PreH21 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH22 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH23 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held )
.

Definition _SemaphoreObtain_entail_wit_8 :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (retval: Z) (PreH1 : ((assignRunningTask ((os_assign (held)))) = (assignRunningTask ((os_assign (held)))))) (PreH2 : (retval = (assignRunningTask ((os_assign (held)))))) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : ((-1) <= msec_pre)) (PreH6 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH7 : (wait_time <> 0)) (PreH8 : ((-1) <= wait_time)) (PreH9 : (wait_time < KTICK_HALF_RANGE)) (PreH10 : (task = 0)) (PreH11 : (sem = (semaphore_addr (original)))) (PreH12 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH13 : (In original (os_semaphores (held)) )) (PreH14 : ((semaphore_id (original)) = id_pre)) (PreH15 : ((semaphore_value (original)) = 0)) (PreH16 : (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held )) (PreH17 : forall (entry_desc_2: TaskDescriptorAbs), forall (entry_suspended_2: VarGlobalState), forall (entry_sd_2: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc_2))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc_2) (held)) entry_suspended_2 ) -> (((task_desc_map ((os_tasks (entry_suspended_2))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd_2))) -> ((0 < wait_time) -> ((((entry_sd_2.(tdDelay) ) = 0) \/ (((entry_suspended_2.(os_delays) ).(delay_inactive_map) ((entry_sd_2.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended_2)) ((entry_suspended_2.(os_delays) ).(delay_active_nodes) ) ))))))) (PreH18 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (os_inv sg_semaphore_obtain_oc held )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  EX (desc: TaskDescriptorAbs),
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (wait_time <> 0) ”
  &&  “ ((-1) <= wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ ((assignRunningTask ((os_assign (held)))) = (assignRunningTask ((os_assign (held))))) ”
  &&  “ ((assignRunningTask ((os_assign (held)))) <> 0) ”
  &&  “ ((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (desc))) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_value (original)) = 0) ”
  &&  “ (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held ) ”
  &&  “ forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < wait_time) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) )))))) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  ((&(((assignRunningTask ((os_assign (held)))))  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (desc.(tdExstatus) ))
  **  (wand (store_int (&(((assignRunningTask ((os_assign (held)))))  # "TaskDescriptor" ->ₛ "exstatus")) (0)) (os_inv (sg_semaphore_obtain_oc) ((semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (desc) (held)))) )
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (retval: Z) (PreH1 : (retval = (assignRunningTask ((os_assign (held)))))) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre <= 65535)) (PreH4 : ((-1) <= msec_pre)) (PreH5 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH6 : (wait_time <> 0)) (PreH7 : ((-1) <= wait_time)) (PreH8 : (wait_time < KTICK_HALF_RANGE)) (PreH9 : (task = 0)) (PreH10 : (sem = (semaphore_addr (original)))) (PreH11 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH12 : (In original (os_semaphores (held)) )) (PreH13 : ((semaphore_id (original)) = id_pre)) (PreH14 : ((semaphore_value (original)) = 0)) (PreH15 : (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held )) (PreH16 : forall (entry_desc_2: TaskDescriptorAbs), forall (entry_suspended_2: VarGlobalState), forall (entry_sd_2: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc_2))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc_2) (held)) entry_suspended_2 ) -> (((task_desc_map ((os_tasks (entry_suspended_2))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd_2))) -> ((0 < wait_time) -> ((((entry_sd_2.(tdDelay) ) = 0) \/ (((entry_suspended_2.(os_delays) ).(delay_inactive_map) ((entry_sd_2.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended_2)) ((entry_suspended_2.(os_delays) ).(delay_active_nodes) ) ))))))) (PreH17 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (os_inv sg_semaphore_obtain_oc held )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  EX (desc: TaskDescriptorAbs),
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (wait_time <> 0) ”
  &&  “ ((-1) <= wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ ((assignRunningTask ((os_assign (held)))) <> 0) ”
  &&  “ ((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (desc))) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_value (original)) = 0) ”
  &&  “ (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held ) ”
  &&  “ forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < wait_time) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) )))))) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  ((&(((assignRunningTask ((os_assign (held)))))  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (desc.(tdExstatus) ))
  **  (wand (store_int (&(((assignRunningTask ((os_assign (held)))))  # "TaskDescriptor" ->ₛ "exstatus")) (0)) (os_inv (sg_semaphore_obtain_oc) ((semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (desc) (held)))) )
).

Definition _SemaphoreObtain_entail_wit_9 :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (desc: TaskDescriptorAbs) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : (wait_time <> 0)) (PreH6 : ((-1) <= wait_time)) (PreH7 : (wait_time < KTICK_HALF_RANGE)) (PreH8 : (task = (assignRunningTask ((os_assign (held)))))) (PreH9 : (task <> 0)) (PreH10 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH11 : (sem = (semaphore_addr (original)))) (PreH12 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH13 : (In original (os_semaphores (held)) )) (PreH14 : ((semaphore_id (original)) = id_pre)) (PreH15 : ((semaphore_value (original)) = 0)) (PreH16 : (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held )) (PreH17 : forall (entry_desc_2: TaskDescriptorAbs), forall (entry_suspended_2: VarGlobalState), forall (entry_sd_2: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc_2))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc_2) (held)) entry_suspended_2 ) -> (((task_desc_map ((os_tasks (entry_suspended_2))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd_2))) -> ((0 < wait_time) -> ((((entry_sd_2.(tdDelay) ) = 0) \/ (((entry_suspended_2.(os_delays) ).(delay_inactive_map) ((entry_sd_2.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended_2)) ((entry_suspended_2.(os_delays) ).(delay_active_nodes) ) ))))))) (PreH18 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&((task)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> 0)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (wand (store_int (&((task)  # "TaskDescriptor" ->ₛ "exstatus")) (0)) (os_inv (sg_semaphore_obtain_oc) ((semaphore_clear_status (task) (desc) (held)))) )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (wait_time <> 0) ”
  &&  “ ((-1) <= wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (task <> 0) ”
  &&  “ ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc))) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_value (original)) = 0) ”
  &&  “ (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held ) ”
  &&  “ forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < wait_time) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) )))))) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  “ (semaphore_pending_nodes sem (semaphore_clear_status (task) (desc) (held)) (map (sched_link_node) ((semaphore_pending_addrs (original)))) ) ”
  &&  “ (linklist_suspend_admissible task 1 (semaphore_clear_status (task) (desc) (held)) ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc (semaphore_clear_status (task) (desc) (held)) )
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (desc: TaskDescriptorAbs) (PreH1 : (0 <= INT_MAX)) (PreH2 : (0 >= INT_MIN)) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : ((-1) <= msec_pre)) (PreH6 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH7 : (wait_time <> 0)) (PreH8 : ((-1) <= wait_time)) (PreH9 : (wait_time < KTICK_HALF_RANGE)) (PreH10 : (task = (assignRunningTask ((os_assign (held)))))) (PreH11 : (task <> 0)) (PreH12 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH13 : (sem = (semaphore_addr (original)))) (PreH14 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH15 : (In original (os_semaphores (held)) )) (PreH16 : ((semaphore_id (original)) = id_pre)) (PreH17 : ((semaphore_value (original)) = 0)) (PreH18 : (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held )) (PreH19 : forall (entry_desc_2: TaskDescriptorAbs), forall (entry_suspended_2: VarGlobalState), forall (entry_sd_2: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc_2))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc_2) (held)) entry_suspended_2 ) -> (((task_desc_map ((os_tasks (entry_suspended_2))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd_2))) -> ((0 < wait_time) -> ((((entry_sd_2.(tdDelay) ) = 0) \/ (((entry_suspended_2.(os_delays) ).(delay_inactive_map) ((entry_sd_2.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended_2)) ((entry_suspended_2.(os_delays) ).(delay_active_nodes) ) ))))))) (PreH20 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&((task)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> 0)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (wand (store_int (&((task)  # "TaskDescriptor" ->ₛ "exstatus")) (0)) (os_inv (sg_semaphore_obtain_oc) ((semaphore_clear_status (task) (desc) (held)))) )
|--
  “ (linklist_suspend_admissible task 1 (semaphore_clear_status (task) (desc) (held)) ) ”
  &&  “ (semaphore_pending_nodes sem (semaphore_clear_status (task) (desc) (held)) (map (sched_link_node) ((semaphore_pending_addrs (original)))) ) ”
  &&  “ forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < wait_time) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) )))))) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc (semaphore_clear_status (task) (desc) (held)) )
).

Definition _SemaphoreObtain_entail_wit_9_split_goal_1 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (desc: TaskDescriptorAbs) (PreH1 : (0 <= INT_MAX)) (PreH2 : (0 >= INT_MIN)) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : ((-1) <= msec_pre)) (PreH6 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH7 : (wait_time <> 0)) (PreH8 : ((-1) <= wait_time)) (PreH9 : (wait_time < KTICK_HALF_RANGE)) (PreH10 : (task = (assignRunningTask ((os_assign (held)))))) (PreH11 : (task <> 0)) (PreH12 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH13 : (sem = (semaphore_addr (original)))) (PreH14 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH15 : (In original (os_semaphores (held)) )) (PreH16 : ((semaphore_id (original)) = id_pre)) (PreH17 : ((semaphore_value (original)) = 0)) (PreH18 : (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held )) (PreH19 : forall (entry_desc_2: TaskDescriptorAbs), forall (entry_suspended_2: VarGlobalState), forall (entry_sd_2: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc_2))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc_2) (held)) entry_suspended_2 ) -> (((task_desc_map ((os_tasks (entry_suspended_2))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd_2))) -> ((0 < wait_time) -> ((((entry_sd_2.(tdDelay) ) = 0) \/ (((entry_suspended_2.(os_delays) ).(delay_inactive_map) ((entry_sd_2.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended_2)) ((entry_suspended_2.(os_delays) ).(delay_active_nodes) ) ))))))) (PreH20 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&((task)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> 0)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (wand (store_int (&((task)  # "TaskDescriptor" ->ₛ "exstatus")) (0)) (os_inv (sg_semaphore_obtain_oc) ((semaphore_clear_status (task) (desc) (held)))) )
|--
  “ (linklist_suspend_admissible task 1 (semaphore_clear_status (task) (desc) (held)) ) ”
.

Definition _SemaphoreObtain_entail_wit_9_split_goal_2 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (desc: TaskDescriptorAbs) (PreH1 : (0 <= INT_MAX)) (PreH2 : (0 >= INT_MIN)) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : ((-1) <= msec_pre)) (PreH6 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH7 : (wait_time <> 0)) (PreH8 : ((-1) <= wait_time)) (PreH9 : (wait_time < KTICK_HALF_RANGE)) (PreH10 : (task = (assignRunningTask ((os_assign (held)))))) (PreH11 : (task <> 0)) (PreH12 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH13 : (sem = (semaphore_addr (original)))) (PreH14 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH15 : (In original (os_semaphores (held)) )) (PreH16 : ((semaphore_id (original)) = id_pre)) (PreH17 : ((semaphore_value (original)) = 0)) (PreH18 : (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held )) (PreH19 : forall (entry_desc_2: TaskDescriptorAbs), forall (entry_suspended_2: VarGlobalState), forall (entry_sd_2: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc_2))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc_2) (held)) entry_suspended_2 ) -> (((task_desc_map ((os_tasks (entry_suspended_2))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd_2))) -> ((0 < wait_time) -> ((((entry_sd_2.(tdDelay) ) = 0) \/ (((entry_suspended_2.(os_delays) ).(delay_inactive_map) ((entry_sd_2.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended_2)) ((entry_suspended_2.(os_delays) ).(delay_active_nodes) ) ))))))) (PreH20 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&((task)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> 0)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (wand (store_int (&((task)  # "TaskDescriptor" ->ₛ "exstatus")) (0)) (os_inv (sg_semaphore_obtain_oc) ((semaphore_clear_status (task) (desc) (held)))) )
|--
  “ (semaphore_pending_nodes sem (semaphore_clear_status (task) (desc) (held)) (map (sched_link_node) ((semaphore_pending_addrs (original)))) ) ”
.

Definition _SemaphoreObtain_entail_wit_9_split_goal_3 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (desc: TaskDescriptorAbs) (PreH1 : (0 <= INT_MAX)) (PreH2 : (0 >= INT_MIN)) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : ((-1) <= msec_pre)) (PreH6 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH7 : (wait_time <> 0)) (PreH8 : ((-1) <= wait_time)) (PreH9 : (wait_time < KTICK_HALF_RANGE)) (PreH10 : (task = (assignRunningTask ((os_assign (held)))))) (PreH11 : (task <> 0)) (PreH12 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH13 : (sem = (semaphore_addr (original)))) (PreH14 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH15 : (In original (os_semaphores (held)) )) (PreH16 : ((semaphore_id (original)) = id_pre)) (PreH17 : ((semaphore_value (original)) = 0)) (PreH18 : (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held )) (PreH19 : forall (entry_desc_2: TaskDescriptorAbs), forall (entry_suspended_2: VarGlobalState), forall (entry_sd_2: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc_2))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc_2) (held)) entry_suspended_2 ) -> (((task_desc_map ((os_tasks (entry_suspended_2))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd_2))) -> ((0 < wait_time) -> ((((entry_sd_2.(tdDelay) ) = 0) \/ (((entry_suspended_2.(os_delays) ).(delay_inactive_map) ((entry_sd_2.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended_2)) ((entry_suspended_2.(os_delays) ).(delay_active_nodes) ) ))))))) (PreH20 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&((task)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> 0)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (wand (store_int (&((task)  # "TaskDescriptor" ->ₛ "exstatus")) (0)) (os_inv (sg_semaphore_obtain_oc) ((semaphore_clear_status (task) (desc) (held)))) )
|--
  “ forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < wait_time) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) )))))) ”
.

Definition _SemaphoreObtain_entail_wit_9_split_goal_spatial :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (desc: TaskDescriptorAbs) (PreH1 : (0 <= INT_MAX)) (PreH2 : (0 >= INT_MIN)) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : ((-1) <= msec_pre)) (PreH6 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH7 : (wait_time <> 0)) (PreH8 : ((-1) <= wait_time)) (PreH9 : (wait_time < KTICK_HALF_RANGE)) (PreH10 : (task = (assignRunningTask ((os_assign (held)))))) (PreH11 : (task <> 0)) (PreH12 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH13 : (sem = (semaphore_addr (original)))) (PreH14 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH15 : (In original (os_semaphores (held)) )) (PreH16 : ((semaphore_id (original)) = id_pre)) (PreH17 : ((semaphore_value (original)) = 0)) (PreH18 : (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held )) (PreH19 : forall (entry_desc_2: TaskDescriptorAbs), forall (entry_suspended_2: VarGlobalState), forall (entry_sd_2: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc_2))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc_2) (held)) entry_suspended_2 ) -> (((task_desc_map ((os_tasks (entry_suspended_2))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd_2))) -> ((0 < wait_time) -> ((((entry_sd_2.(tdDelay) ) = 0) \/ (((entry_suspended_2.(os_delays) ).(delay_inactive_map) ((entry_sd_2.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended_2)) ((entry_suspended_2.(os_delays) ).(delay_active_nodes) ) ))))))) (PreH20 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&((task)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> 0)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (wand (store_int (&((task)  # "TaskDescriptor" ->ₛ "exstatus")) (0)) (os_inv (sg_semaphore_obtain_oc) ((semaphore_clear_status (task) (desc) (held)))) )
|--
  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc (semaphore_clear_status (task) (desc) (held)) )
.

Definition _SemaphoreObtain_entail_wit_10 :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (after: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) after )) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : ((-1) <= msec_pre)) (PreH6 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH7 : (wait_time <> 0)) (PreH8 : ((-1) <= wait_time)) (PreH9 : (wait_time < KTICK_HALF_RANGE)) (PreH10 : (task = (assignRunningTask ((os_assign (held)))))) (PreH11 : (task <> 0)) (PreH12 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH13 : (sem = (semaphore_addr (original)))) (PreH14 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH15 : (In original (os_semaphores (held)) )) (PreH16 : ((semaphore_id (original)) = id_pre)) (PreH17 : ((semaphore_value (original)) = 0)) (PreH18 : (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held )) (PreH19 : forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < wait_time) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) ))))))) (PreH20 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )) (PreH22 : (semaphore_pending_nodes sem (semaphore_clear_status (task) (desc) (held)) (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH23 : (linklist_suspend_admissible task 1 (semaphore_clear_status (task) (desc) (held)) )),
  (os_inv sg_semaphore_obtain_oc after )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  EX (sd: TaskDescriptorAbs) (suspended: VarGlobalState),
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (wait_time <> 0) ”
  &&  “ ((-1) <= wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (task <> 0) ”
  &&  “ ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc))) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_value (original)) = 0) ”
  &&  “ (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended ) ”
  &&  “ ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd))) ”
  &&  “ (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ ((0 < wait_time) -> ((((sd.(tdDelay) ) = 0) \/ (((suspended.(os_delays) ).(delay_inactive_map) ((sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) ))) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc suspended )
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (after: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) after )) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : ((-1) <= msec_pre)) (PreH6 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH7 : (wait_time <> 0)) (PreH8 : ((-1) <= wait_time)) (PreH9 : (wait_time < KTICK_HALF_RANGE)) (PreH10 : (task = (assignRunningTask ((os_assign (held)))))) (PreH11 : (task <> 0)) (PreH12 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH13 : (sem = (semaphore_addr (original)))) (PreH14 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH15 : (In original (os_semaphores (held)) )) (PreH16 : ((semaphore_id (original)) = id_pre)) (PreH17 : ((semaphore_value (original)) = 0)) (PreH18 : (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held )) (PreH19 : forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < wait_time) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) ))))))) (PreH20 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )) (PreH22 : (semaphore_pending_nodes sem (semaphore_clear_status (task) (desc) (held)) (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH23 : (linklist_suspend_admissible task 1 (semaphore_clear_status (task) (desc) (held)) )),
  TT && emp 
|--
  EX (sd: TaskDescriptorAbs),
  “ ((task_desc_map ((os_tasks (after))) ((assignRunningTask ((os_assign (held)))))) = (Some (sd))) ”
  &&  “ (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ ((0 < (semaphore_wait_ticks (msec_pre))) -> ((((sd.(tdDelay) ) = 0) \/ (((after.(os_delays) ).(delay_inactive_map) ((sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (after)) ((after.(os_delays) ).(delay_active_nodes) ) ))) ”
  &&  emp
).

Definition _SemaphoreObtain_entail_wit_11 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (PreH1 : (wait_time > 0)) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre <= 65535)) (PreH4 : ((-1) <= msec_pre)) (PreH5 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH6 : (wait_time <> 0)) (PreH7 : ((-1) <= wait_time)) (PreH8 : (wait_time < KTICK_HALF_RANGE)) (PreH9 : (task = (assignRunningTask ((os_assign (held)))))) (PreH10 : (task <> 0)) (PreH11 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH12 : (sem = (semaphore_addr (original)))) (PreH13 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH14 : (In original (os_semaphores (held)) )) (PreH15 : ((semaphore_id (original)) = id_pre)) (PreH16 : ((semaphore_value (original)) = 0)) (PreH17 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH18 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH19 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH20 : ((0 < wait_time) -> ((((sd.(tdDelay) ) = 0) \/ (((suspended.(os_delays) ).(delay_inactive_map) ((sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) )))) (PreH21 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc suspended )
|--
  (EX (delay_frame: Assertion),
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (0 < wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (task <> 0) ”
  &&  “ ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc))) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_value (original)) = 0) ”
  &&  “ (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended ) ”
  &&  “ ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd))) ”
  &&  “ (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (((suspended.(os_delays) ).(delay_inactive_map) ((sd.(tdDelay) ))) <> None) ”
  &&  “ (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) ) ”
  &&  “ (os_global_context sg_semaphore_obtain_oc ) ”
  &&  “ forall (delayed: VarGlobalState), forall (dp: Z), forall (rc: Z), ((ktask_set_delay_step task sd wait_time dp suspended rc delayed ) -> (derivable1 (sepcon ((store_ptr (&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) (dp))) ((sepcon ((delay_inv (sg_semaphore_obtain_oc) (delayed))) ((sepcon ((tick_inv (sg_semaphore_obtain_oc) (delayed))) (delay_frame)))))) (os_inv (sg_semaphore_obtain_oc) (delayed)) )) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  ((&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) # Ptr  |-> (sd.(tdDelay) ))
  **  (delay_inv sg_semaphore_obtain_oc suspended )
  **  (tick_inv sg_semaphore_obtain_oc suspended )
  **  (andp (coq_prop ((os_global_context (sg_semaphore_obtain_oc)))) delay_frame ))
  ||
  (EX (delay_frame: Assertion),
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (0 < wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (task <> 0) ”
  &&  “ ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc))) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_value (original)) = 0) ”
  &&  “ (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended ) ”
  &&  “ ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd))) ”
  &&  “ (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ ((sd.(tdDelay) ) = 0) ”
  &&  “ (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) ) ”
  &&  “ (os_global_context sg_semaphore_obtain_oc ) ”
  &&  “ forall (delayed: VarGlobalState), forall (dp: Z), forall (rc: Z), ((ktask_set_delay_step task sd wait_time dp suspended rc delayed ) -> (derivable1 (sepcon ((store_ptr (&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) (dp))) ((sepcon ((delay_inv (sg_semaphore_obtain_oc) (delayed))) ((sepcon ((tick_inv (sg_semaphore_obtain_oc) (delayed))) (delay_frame)))))) (os_inv (sg_semaphore_obtain_oc) (delayed)) )) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  ((&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) # Ptr  |-> (sd.(tdDelay) ))
  **  (delay_inv sg_semaphore_obtain_oc suspended )
  **  (tick_inv sg_semaphore_obtain_oc suspended )
  **  (andp (coq_prop ((os_global_context (sg_semaphore_obtain_oc)))) delay_frame ))
.

Definition _SemaphoreObtain_entail_wit_12_1 :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (delay_frame: Assertion) (delay_after: Z) (st_after: VarGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (ktask_set_delay_step task sd wait_time delay_after suspended retval st_after )) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : ((-1) <= msec_pre)) (PreH6 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH7 : (0 < wait_time)) (PreH8 : (wait_time < KTICK_HALF_RANGE)) (PreH9 : (task = (assignRunningTask ((os_assign (held)))))) (PreH10 : (task <> 0)) (PreH11 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH12 : (sem = (semaphore_addr (original)))) (PreH13 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH14 : (In original (os_semaphores (held)) )) (PreH15 : ((semaphore_id (original)) = id_pre)) (PreH16 : ((semaphore_value (original)) = 0)) (PreH17 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH18 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH19 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH20 : (((suspended.(os_delays) ).(delay_inactive_map) ((sd.(tdDelay) ))) <> None)) (PreH21 : (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) )) (PreH22 : (os_global_context sg_semaphore_obtain_oc )) (PreH23 : forall (delayed: VarGlobalState), forall (dp: Z), forall (rc: Z), ((ktask_set_delay_step task sd wait_time dp suspended rc delayed ) -> (derivable1 (sepcon ((store_ptr (&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) (dp))) ((sepcon ((delay_inv (sg_semaphore_obtain_oc) (delayed))) ((sepcon ((tick_inv (sg_semaphore_obtain_oc) (delayed))) (delay_frame)))))) (os_inv (sg_semaphore_obtain_oc) (delayed)) ))) (PreH24 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH25 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) # Ptr  |-> delay_after)
  **  (delay_inv sg_semaphore_obtain_oc st_after )
  **  (tick_inv sg_semaphore_obtain_oc st_after )
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (andp (coq_prop ((os_global_context (sg_semaphore_obtain_oc)))) delay_frame )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (0 < wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (task <> 0) ”
  &&  “ ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc))) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_value (original)) = 0) ”
  &&  “ (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended ) ”
  &&  “ ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd))) ”
  &&  “ (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (ktask_set_delay_step task sd wait_time 0 suspended (-5) suspended ) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc suspended )
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (delay_frame: Assertion) (delay_after: Z) (st_after: VarGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (ktask_set_delay_step task sd wait_time delay_after suspended retval st_after )) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : ((-1) <= msec_pre)) (PreH6 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH7 : (0 < wait_time)) (PreH8 : (wait_time < KTICK_HALF_RANGE)) (PreH9 : (task = (assignRunningTask ((os_assign (held)))))) (PreH10 : (task <> 0)) (PreH11 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH12 : (sem = (semaphore_addr (original)))) (PreH13 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH14 : (In original (os_semaphores (held)) )) (PreH15 : ((semaphore_id (original)) = id_pre)) (PreH16 : ((semaphore_value (original)) = 0)) (PreH17 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH18 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH19 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH20 : (((suspended.(os_delays) ).(delay_inactive_map) ((sd.(tdDelay) ))) <> None)) (PreH21 : (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) )) (PreH22 : (os_global_context sg_semaphore_obtain_oc )) (PreH23 : forall (delayed: VarGlobalState), forall (dp: Z), forall (rc: Z), ((ktask_set_delay_step task sd wait_time dp suspended rc delayed ) -> (derivable1 (sepcon ((store_ptr (&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) (dp))) ((sepcon ((delay_inv (sg_semaphore_obtain_oc) (delayed))) ((sepcon ((tick_inv (sg_semaphore_obtain_oc) (delayed))) (delay_frame)))))) (os_inv (sg_semaphore_obtain_oc) (delayed)) ))) (PreH24 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH25 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) # Ptr  |-> delay_after)
  **  (delay_inv sg_semaphore_obtain_oc st_after )
  **  (tick_inv sg_semaphore_obtain_oc st_after )
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (andp (coq_prop ((os_global_context (sg_semaphore_obtain_oc)))) delay_frame )
|--
  “ (ktask_set_delay_step task sd wait_time 0 suspended (-5) suspended ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc suspended )
).

Definition _SemaphoreObtain_entail_wit_12_1_split_goal_1 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (delay_frame: Assertion) (delay_after: Z) (st_after: VarGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (ktask_set_delay_step task sd wait_time delay_after suspended retval st_after )) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : ((-1) <= msec_pre)) (PreH6 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH7 : (0 < wait_time)) (PreH8 : (wait_time < KTICK_HALF_RANGE)) (PreH9 : (task = (assignRunningTask ((os_assign (held)))))) (PreH10 : (task <> 0)) (PreH11 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH12 : (sem = (semaphore_addr (original)))) (PreH13 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH14 : (In original (os_semaphores (held)) )) (PreH15 : ((semaphore_id (original)) = id_pre)) (PreH16 : ((semaphore_value (original)) = 0)) (PreH17 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH18 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH19 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH20 : (((suspended.(os_delays) ).(delay_inactive_map) ((sd.(tdDelay) ))) <> None)) (PreH21 : (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) )) (PreH22 : (os_global_context sg_semaphore_obtain_oc )) (PreH23 : forall (delayed: VarGlobalState), forall (dp: Z), forall (rc: Z), ((ktask_set_delay_step task sd wait_time dp suspended rc delayed ) -> (derivable1 (sepcon ((store_ptr (&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) (dp))) ((sepcon ((delay_inv (sg_semaphore_obtain_oc) (delayed))) ((sepcon ((tick_inv (sg_semaphore_obtain_oc) (delayed))) (delay_frame)))))) (os_inv (sg_semaphore_obtain_oc) (delayed)) ))) (PreH24 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH25 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) # Ptr  |-> delay_after)
  **  (delay_inv sg_semaphore_obtain_oc st_after )
  **  (tick_inv sg_semaphore_obtain_oc st_after )
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (andp (coq_prop ((os_global_context (sg_semaphore_obtain_oc)))) delay_frame )
|--
  “ (ktask_set_delay_step task sd wait_time 0 suspended (-5) suspended ) ”
.

Definition _SemaphoreObtain_entail_wit_12_1_split_goal_spatial :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (delay_frame: Assertion) (delay_after: Z) (st_after: VarGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (ktask_set_delay_step task sd wait_time delay_after suspended retval st_after )) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : ((-1) <= msec_pre)) (PreH6 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH7 : (0 < wait_time)) (PreH8 : (wait_time < KTICK_HALF_RANGE)) (PreH9 : (task = (assignRunningTask ((os_assign (held)))))) (PreH10 : (task <> 0)) (PreH11 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH12 : (sem = (semaphore_addr (original)))) (PreH13 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH14 : (In original (os_semaphores (held)) )) (PreH15 : ((semaphore_id (original)) = id_pre)) (PreH16 : ((semaphore_value (original)) = 0)) (PreH17 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH18 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH19 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH20 : (((suspended.(os_delays) ).(delay_inactive_map) ((sd.(tdDelay) ))) <> None)) (PreH21 : (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) )) (PreH22 : (os_global_context sg_semaphore_obtain_oc )) (PreH23 : forall (delayed: VarGlobalState), forall (dp: Z), forall (rc: Z), ((ktask_set_delay_step task sd wait_time dp suspended rc delayed ) -> (derivable1 (sepcon ((store_ptr (&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) (dp))) ((sepcon ((delay_inv (sg_semaphore_obtain_oc) (delayed))) ((sepcon ((tick_inv (sg_semaphore_obtain_oc) (delayed))) (delay_frame)))))) (os_inv (sg_semaphore_obtain_oc) (delayed)) ))) (PreH24 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH25 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) # Ptr  |-> delay_after)
  **  (delay_inv sg_semaphore_obtain_oc st_after )
  **  (tick_inv sg_semaphore_obtain_oc st_after )
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (andp (coq_prop ((os_global_context (sg_semaphore_obtain_oc)))) delay_frame )
|--
  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc suspended )
.

Definition _SemaphoreObtain_entail_wit_12_2 :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (delay_frame: Assertion) (delay_after: Z) (st_after: VarGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (ktask_set_delay_step task sd wait_time delay_after suspended retval st_after )) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : ((-1) <= msec_pre)) (PreH6 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH7 : (0 < wait_time)) (PreH8 : (wait_time < KTICK_HALF_RANGE)) (PreH9 : (task = (assignRunningTask ((os_assign (held)))))) (PreH10 : (task <> 0)) (PreH11 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH12 : (sem = (semaphore_addr (original)))) (PreH13 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH14 : (In original (os_semaphores (held)) )) (PreH15 : ((semaphore_id (original)) = id_pre)) (PreH16 : ((semaphore_value (original)) = 0)) (PreH17 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH18 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH19 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH20 : ((sd.(tdDelay) ) = 0)) (PreH21 : (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) )) (PreH22 : (os_global_context sg_semaphore_obtain_oc )) (PreH23 : forall (delayed: VarGlobalState), forall (dp: Z), forall (rc: Z), ((ktask_set_delay_step task sd wait_time dp suspended rc delayed ) -> (derivable1 (sepcon ((store_ptr (&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) (dp))) ((sepcon ((delay_inv (sg_semaphore_obtain_oc) (delayed))) ((sepcon ((tick_inv (sg_semaphore_obtain_oc) (delayed))) (delay_frame)))))) (os_inv (sg_semaphore_obtain_oc) (delayed)) ))) (PreH24 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH25 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) # Ptr  |-> delay_after)
  **  (delay_inv sg_semaphore_obtain_oc st_after )
  **  (tick_inv sg_semaphore_obtain_oc st_after )
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (andp (coq_prop ((os_global_context (sg_semaphore_obtain_oc)))) delay_frame )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (0 < wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (task <> 0) ”
  &&  “ ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc))) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_value (original)) = 0) ”
  &&  “ (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended ) ”
  &&  “ ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd))) ”
  &&  “ (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (ktask_set_delay_step task sd wait_time 0 suspended (-5) suspended ) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc suspended )
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (delay_frame: Assertion) (delay_after: Z) (st_after: VarGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (ktask_set_delay_step task sd wait_time delay_after suspended retval st_after )) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : ((-1) <= msec_pre)) (PreH6 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH7 : (0 < wait_time)) (PreH8 : (wait_time < KTICK_HALF_RANGE)) (PreH9 : (task = (assignRunningTask ((os_assign (held)))))) (PreH10 : (task <> 0)) (PreH11 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH12 : (sem = (semaphore_addr (original)))) (PreH13 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH14 : (In original (os_semaphores (held)) )) (PreH15 : ((semaphore_id (original)) = id_pre)) (PreH16 : ((semaphore_value (original)) = 0)) (PreH17 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH18 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH19 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH20 : ((sd.(tdDelay) ) = 0)) (PreH21 : (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) )) (PreH22 : (os_global_context sg_semaphore_obtain_oc )) (PreH23 : forall (delayed: VarGlobalState), forall (dp: Z), forall (rc: Z), ((ktask_set_delay_step task sd wait_time dp suspended rc delayed ) -> (derivable1 (sepcon ((store_ptr (&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) (dp))) ((sepcon ((delay_inv (sg_semaphore_obtain_oc) (delayed))) ((sepcon ((tick_inv (sg_semaphore_obtain_oc) (delayed))) (delay_frame)))))) (os_inv (sg_semaphore_obtain_oc) (delayed)) ))) (PreH24 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH25 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) # Ptr  |-> delay_after)
  **  (delay_inv sg_semaphore_obtain_oc st_after )
  **  (tick_inv sg_semaphore_obtain_oc st_after )
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (andp (coq_prop ((os_global_context (sg_semaphore_obtain_oc)))) delay_frame )
|--
  “ (ktask_set_delay_step task sd wait_time 0 suspended (-5) suspended ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc suspended )
).

Definition _SemaphoreObtain_entail_wit_12_2_split_goal_1 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (delay_frame: Assertion) (delay_after: Z) (st_after: VarGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (ktask_set_delay_step task sd wait_time delay_after suspended retval st_after )) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : ((-1) <= msec_pre)) (PreH6 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH7 : (0 < wait_time)) (PreH8 : (wait_time < KTICK_HALF_RANGE)) (PreH9 : (task = (assignRunningTask ((os_assign (held)))))) (PreH10 : (task <> 0)) (PreH11 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH12 : (sem = (semaphore_addr (original)))) (PreH13 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH14 : (In original (os_semaphores (held)) )) (PreH15 : ((semaphore_id (original)) = id_pre)) (PreH16 : ((semaphore_value (original)) = 0)) (PreH17 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH18 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH19 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH20 : ((sd.(tdDelay) ) = 0)) (PreH21 : (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) )) (PreH22 : (os_global_context sg_semaphore_obtain_oc )) (PreH23 : forall (delayed: VarGlobalState), forall (dp: Z), forall (rc: Z), ((ktask_set_delay_step task sd wait_time dp suspended rc delayed ) -> (derivable1 (sepcon ((store_ptr (&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) (dp))) ((sepcon ((delay_inv (sg_semaphore_obtain_oc) (delayed))) ((sepcon ((tick_inv (sg_semaphore_obtain_oc) (delayed))) (delay_frame)))))) (os_inv (sg_semaphore_obtain_oc) (delayed)) ))) (PreH24 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH25 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) # Ptr  |-> delay_after)
  **  (delay_inv sg_semaphore_obtain_oc st_after )
  **  (tick_inv sg_semaphore_obtain_oc st_after )
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (andp (coq_prop ((os_global_context (sg_semaphore_obtain_oc)))) delay_frame )
|--
  “ (ktask_set_delay_step task sd wait_time 0 suspended (-5) suspended ) ”
.

Definition _SemaphoreObtain_entail_wit_12_2_split_goal_spatial :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (delay_frame: Assertion) (delay_after: Z) (st_after: VarGlobalState) (retval: Z) (PreH1 : (retval <> 0)) (PreH2 : (ktask_set_delay_step task sd wait_time delay_after suspended retval st_after )) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : ((-1) <= msec_pre)) (PreH6 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH7 : (0 < wait_time)) (PreH8 : (wait_time < KTICK_HALF_RANGE)) (PreH9 : (task = (assignRunningTask ((os_assign (held)))))) (PreH10 : (task <> 0)) (PreH11 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH12 : (sem = (semaphore_addr (original)))) (PreH13 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH14 : (In original (os_semaphores (held)) )) (PreH15 : ((semaphore_id (original)) = id_pre)) (PreH16 : ((semaphore_value (original)) = 0)) (PreH17 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH18 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH19 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH20 : ((sd.(tdDelay) ) = 0)) (PreH21 : (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) )) (PreH22 : (os_global_context sg_semaphore_obtain_oc )) (PreH23 : forall (delayed: VarGlobalState), forall (dp: Z), forall (rc: Z), ((ktask_set_delay_step task sd wait_time dp suspended rc delayed ) -> (derivable1 (sepcon ((store_ptr (&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) (dp))) ((sepcon ((delay_inv (sg_semaphore_obtain_oc) (delayed))) ((sepcon ((tick_inv (sg_semaphore_obtain_oc) (delayed))) (delay_frame)))))) (os_inv (sg_semaphore_obtain_oc) (delayed)) ))) (PreH24 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH25 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) # Ptr  |-> delay_after)
  **  (delay_inv sg_semaphore_obtain_oc st_after )
  **  (tick_inv sg_semaphore_obtain_oc st_after )
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (andp (coq_prop ((os_global_context (sg_semaphore_obtain_oc)))) delay_frame )
|--
  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc suspended )
.

Definition _SemaphoreObtain_entail_wit_13_1 :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (rollback_id: Z) (after: VarGlobalState) (desc_2: TaskDescriptorAbs) (task_2: Z) (retval: Z) (PreH1 : (task_2 <> 0)) (PreH2 : (get_task_with_idnode_success sg_semaphore_obtain_oc suspended rollback_id task_2 )) (PreH3 : (((suspended.(os_tasks) ).(task_desc_map) (task_2)) = (Some (desc_2)))) (PreH4 : (((desc_2.(tdSchedMember) ).(tsmStat) ) <> TSK_SUSPEND)) (PreH5 : (retval = (-1))) (PreH6 : (after = suspended)) (PreH7 : (0 <= rollback_id)) (PreH8 : (rollback_id < 65536)) (PreH9 : (get_task_with_idnode_success sg_semaphore_obtain_oc suspended rollback_id (assignRunningTask ((os_assign (held)))) )) (PreH10 : (0 <= id_pre)) (PreH11 : (id_pre <= 65535)) (PreH12 : ((-1) <= msec_pre)) (PreH13 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH14 : (0 < wait_time)) (PreH15 : (wait_time < KTICK_HALF_RANGE)) (PreH16 : (task = (assignRunningTask ((os_assign (held)))))) (PreH17 : (task <> 0)) (PreH18 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH19 : (sem = (semaphore_addr (original)))) (PreH20 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH21 : (In original (os_semaphores (held)) )) (PreH22 : ((semaphore_id (original)) = id_pre)) (PreH23 : ((semaphore_value (original)) = 0)) (PreH24 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH25 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH26 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH27 : (ktask_set_delay_step task sd wait_time 0 suspended (-5) suspended )) (PreH28 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH29 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (os_inv sg_semaphore_obtain_oc after )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  EX (after_wakeup: VarGlobalState),
  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ ((assignRunningTask ((os_assign (held)))) = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after_wakeup)) ( MonadErr.ret  ((-5))) X_semaphore_obtain_oc ) ”
  &&  “ (Crtos_GTrans held after_wakeup ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc after_wakeup )
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (rollback_id: Z) (after: VarGlobalState) (desc_2: TaskDescriptorAbs) (task_2: Z) (retval: Z) (PreH1 : (task_2 <> 0)) (PreH2 : (get_task_with_idnode_success sg_semaphore_obtain_oc suspended rollback_id task_2 )) (PreH3 : (((suspended.(os_tasks) ).(task_desc_map) (task_2)) = (Some (desc_2)))) (PreH4 : (((desc_2.(tdSchedMember) ).(tsmStat) ) <> TSK_SUSPEND)) (PreH5 : (retval = (-1))) (PreH6 : (after = suspended)) (PreH7 : (0 <= rollback_id)) (PreH8 : (rollback_id < 65536)) (PreH9 : (get_task_with_idnode_success sg_semaphore_obtain_oc suspended rollback_id (assignRunningTask ((os_assign (held)))) )) (PreH10 : (0 <= id_pre)) (PreH11 : (id_pre <= 65535)) (PreH12 : ((-1) <= msec_pre)) (PreH13 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH14 : (0 < wait_time)) (PreH15 : (wait_time < KTICK_HALF_RANGE)) (PreH16 : (task = (assignRunningTask ((os_assign (held)))))) (PreH17 : (task <> 0)) (PreH18 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH19 : (sem = (semaphore_addr (original)))) (PreH20 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH21 : (In original (os_semaphores (held)) )) (PreH22 : ((semaphore_id (original)) = id_pre)) (PreH23 : ((semaphore_value (original)) = 0)) (PreH24 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH25 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH26 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH27 : (ktask_set_delay_step task sd wait_time 0 suspended (-5) suspended )) (PreH28 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH29 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  TT && emp 
|--
  “ (Crtos_GTrans held suspended ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (suspended)) ( MonadErr.ret  ((-5))) X_semaphore_obtain_oc ) ”
  &&  emp
).

Definition _SemaphoreObtain_entail_wit_13_1_split_goal_1 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (rollback_id: Z) (after: VarGlobalState) (desc_2: TaskDescriptorAbs) (task_2: Z) (retval: Z) (PreH1 : (task_2 <> 0)) (PreH2 : (get_task_with_idnode_success sg_semaphore_obtain_oc suspended rollback_id task_2 )) (PreH3 : (((suspended.(os_tasks) ).(task_desc_map) (task_2)) = (Some (desc_2)))) (PreH4 : (((desc_2.(tdSchedMember) ).(tsmStat) ) <> TSK_SUSPEND)) (PreH5 : (retval = (-1))) (PreH6 : (after = suspended)) (PreH7 : (0 <= rollback_id)) (PreH8 : (rollback_id < 65536)) (PreH9 : (get_task_with_idnode_success sg_semaphore_obtain_oc suspended rollback_id (assignRunningTask ((os_assign (held)))) )) (PreH10 : (0 <= id_pre)) (PreH11 : (id_pre <= 65535)) (PreH12 : ((-1) <= msec_pre)) (PreH13 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH14 : (0 < wait_time)) (PreH15 : (wait_time < KTICK_HALF_RANGE)) (PreH16 : (task = (assignRunningTask ((os_assign (held)))))) (PreH17 : (task <> 0)) (PreH18 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH19 : (sem = (semaphore_addr (original)))) (PreH20 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH21 : (In original (os_semaphores (held)) )) (PreH22 : ((semaphore_id (original)) = id_pre)) (PreH23 : ((semaphore_value (original)) = 0)) (PreH24 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH25 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH26 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH27 : (ktask_set_delay_step task sd wait_time 0 suspended (-5) suspended )) (PreH28 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH29 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (Crtos_GTrans held suspended )
.

Definition _SemaphoreObtain_entail_wit_13_1_split_goal_2 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (rollback_id: Z) (after: VarGlobalState) (desc_2: TaskDescriptorAbs) (task_2: Z) (retval: Z) (PreH1 : (task_2 <> 0)) (PreH2 : (get_task_with_idnode_success sg_semaphore_obtain_oc suspended rollback_id task_2 )) (PreH3 : (((suspended.(os_tasks) ).(task_desc_map) (task_2)) = (Some (desc_2)))) (PreH4 : (((desc_2.(tdSchedMember) ).(tsmStat) ) <> TSK_SUSPEND)) (PreH5 : (retval = (-1))) (PreH6 : (after = suspended)) (PreH7 : (0 <= rollback_id)) (PreH8 : (rollback_id < 65536)) (PreH9 : (get_task_with_idnode_success sg_semaphore_obtain_oc suspended rollback_id (assignRunningTask ((os_assign (held)))) )) (PreH10 : (0 <= id_pre)) (PreH11 : (id_pre <= 65535)) (PreH12 : ((-1) <= msec_pre)) (PreH13 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH14 : (0 < wait_time)) (PreH15 : (wait_time < KTICK_HALF_RANGE)) (PreH16 : (task = (assignRunningTask ((os_assign (held)))))) (PreH17 : (task <> 0)) (PreH18 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH19 : (sem = (semaphore_addr (original)))) (PreH20 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH21 : (In original (os_semaphores (held)) )) (PreH22 : ((semaphore_id (original)) = id_pre)) (PreH23 : ((semaphore_value (original)) = 0)) (PreH24 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH25 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH26 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH27 : (ktask_set_delay_step task sd wait_time 0 suspended (-5) suspended )) (PreH28 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH29 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ( monadesafe_lib.safeExec  (LastSeen (suspended)) ( MonadErr.ret  ((-5))) X_semaphore_obtain_oc )
.

Definition _SemaphoreObtain_entail_wit_13_2 :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (rollback_id: Z) (after: VarGlobalState) (desc_2: TaskDescriptorAbs) (task_2: Z) (retval: Z) (PreH1 : (task_2 <> 0)) (PreH2 : (get_task_with_idnode_success sg_semaphore_obtain_oc suspended rollback_id task_2 )) (PreH3 : (((suspended.(os_tasks) ).(task_desc_map) (task_2)) = (Some (desc_2)))) (PreH4 : (((desc_2.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH5 : (retval = 0)) (PreH6 : (ktask_wakeup_step task_2 desc_2 suspended after )) (PreH7 : (0 <= rollback_id)) (PreH8 : (rollback_id < 65536)) (PreH9 : (get_task_with_idnode_success sg_semaphore_obtain_oc suspended rollback_id (assignRunningTask ((os_assign (held)))) )) (PreH10 : (0 <= id_pre)) (PreH11 : (id_pre <= 65535)) (PreH12 : ((-1) <= msec_pre)) (PreH13 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH14 : (0 < wait_time)) (PreH15 : (wait_time < KTICK_HALF_RANGE)) (PreH16 : (task = (assignRunningTask ((os_assign (held)))))) (PreH17 : (task <> 0)) (PreH18 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH19 : (sem = (semaphore_addr (original)))) (PreH20 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH21 : (In original (os_semaphores (held)) )) (PreH22 : ((semaphore_id (original)) = id_pre)) (PreH23 : ((semaphore_value (original)) = 0)) (PreH24 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH25 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH26 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH27 : (ktask_set_delay_step task sd wait_time 0 suspended (-5) suspended )) (PreH28 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH29 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (os_inv sg_semaphore_obtain_oc after )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  EX (after_wakeup: VarGlobalState),
  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ ((assignRunningTask ((os_assign (held)))) = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after_wakeup)) ( MonadErr.ret  ((-5))) X_semaphore_obtain_oc ) ”
  &&  “ (Crtos_GTrans held after_wakeup ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc after_wakeup )
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (rollback_id: Z) (after: VarGlobalState) (desc_2: TaskDescriptorAbs) (task_2: Z) (retval: Z) (PreH1 : (task_2 <> 0)) (PreH2 : (get_task_with_idnode_success sg_semaphore_obtain_oc suspended rollback_id task_2 )) (PreH3 : (((suspended.(os_tasks) ).(task_desc_map) (task_2)) = (Some (desc_2)))) (PreH4 : (((desc_2.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH5 : (retval = 0)) (PreH6 : (ktask_wakeup_step task_2 desc_2 suspended after )) (PreH7 : (0 <= rollback_id)) (PreH8 : (rollback_id < 65536)) (PreH9 : (get_task_with_idnode_success sg_semaphore_obtain_oc suspended rollback_id (assignRunningTask ((os_assign (held)))) )) (PreH10 : (0 <= id_pre)) (PreH11 : (id_pre <= 65535)) (PreH12 : ((-1) <= msec_pre)) (PreH13 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH14 : (0 < wait_time)) (PreH15 : (wait_time < KTICK_HALF_RANGE)) (PreH16 : (task = (assignRunningTask ((os_assign (held)))))) (PreH17 : (task <> 0)) (PreH18 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH19 : (sem = (semaphore_addr (original)))) (PreH20 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH21 : (In original (os_semaphores (held)) )) (PreH22 : ((semaphore_id (original)) = id_pre)) (PreH23 : ((semaphore_value (original)) = 0)) (PreH24 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH25 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH26 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH27 : (ktask_set_delay_step task sd wait_time 0 suspended (-5) suspended )) (PreH28 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH29 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  TT && emp 
|--
  “ (Crtos_GTrans held after ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  ((-5))) X_semaphore_obtain_oc ) ”
  &&  emp
).

Definition _SemaphoreObtain_entail_wit_13_2_split_goal_1 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (rollback_id: Z) (after: VarGlobalState) (desc_2: TaskDescriptorAbs) (task_2: Z) (retval: Z) (PreH1 : (task_2 <> 0)) (PreH2 : (get_task_with_idnode_success sg_semaphore_obtain_oc suspended rollback_id task_2 )) (PreH3 : (((suspended.(os_tasks) ).(task_desc_map) (task_2)) = (Some (desc_2)))) (PreH4 : (((desc_2.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH5 : (retval = 0)) (PreH6 : (ktask_wakeup_step task_2 desc_2 suspended after )) (PreH7 : (0 <= rollback_id)) (PreH8 : (rollback_id < 65536)) (PreH9 : (get_task_with_idnode_success sg_semaphore_obtain_oc suspended rollback_id (assignRunningTask ((os_assign (held)))) )) (PreH10 : (0 <= id_pre)) (PreH11 : (id_pre <= 65535)) (PreH12 : ((-1) <= msec_pre)) (PreH13 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH14 : (0 < wait_time)) (PreH15 : (wait_time < KTICK_HALF_RANGE)) (PreH16 : (task = (assignRunningTask ((os_assign (held)))))) (PreH17 : (task <> 0)) (PreH18 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH19 : (sem = (semaphore_addr (original)))) (PreH20 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH21 : (In original (os_semaphores (held)) )) (PreH22 : ((semaphore_id (original)) = id_pre)) (PreH23 : ((semaphore_value (original)) = 0)) (PreH24 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH25 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH26 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH27 : (ktask_set_delay_step task sd wait_time 0 suspended (-5) suspended )) (PreH28 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH29 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (Crtos_GTrans held after )
.

Definition _SemaphoreObtain_entail_wit_13_2_split_goal_2 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (rollback_id: Z) (after: VarGlobalState) (desc_2: TaskDescriptorAbs) (task_2: Z) (retval: Z) (PreH1 : (task_2 <> 0)) (PreH2 : (get_task_with_idnode_success sg_semaphore_obtain_oc suspended rollback_id task_2 )) (PreH3 : (((suspended.(os_tasks) ).(task_desc_map) (task_2)) = (Some (desc_2)))) (PreH4 : (((desc_2.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH5 : (retval = 0)) (PreH6 : (ktask_wakeup_step task_2 desc_2 suspended after )) (PreH7 : (0 <= rollback_id)) (PreH8 : (rollback_id < 65536)) (PreH9 : (get_task_with_idnode_success sg_semaphore_obtain_oc suspended rollback_id (assignRunningTask ((os_assign (held)))) )) (PreH10 : (0 <= id_pre)) (PreH11 : (id_pre <= 65535)) (PreH12 : ((-1) <= msec_pre)) (PreH13 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH14 : (0 < wait_time)) (PreH15 : (wait_time < KTICK_HALF_RANGE)) (PreH16 : (task = (assignRunningTask ((os_assign (held)))))) (PreH17 : (task <> 0)) (PreH18 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH19 : (sem = (semaphore_addr (original)))) (PreH20 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH21 : (In original (os_semaphores (held)) )) (PreH22 : ((semaphore_id (original)) = id_pre)) (PreH23 : ((semaphore_value (original)) = 0)) (PreH24 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH25 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH26 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH27 : (ktask_set_delay_step task sd wait_time 0 suspended (-5) suspended )) (PreH28 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH29 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  ((-5))) X_semaphore_obtain_oc )
.

Definition _SemaphoreObtain_entail_wit_14_1 :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (delay_frame: Assertion) (delay_after: Z) (st_after: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (ktask_set_delay_step task sd wait_time delay_after suspended retval st_after )) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : ((-1) <= msec_pre)) (PreH6 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH7 : (0 < wait_time)) (PreH8 : (wait_time < KTICK_HALF_RANGE)) (PreH9 : (task = (assignRunningTask ((os_assign (held)))))) (PreH10 : (task <> 0)) (PreH11 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH12 : (sem = (semaphore_addr (original)))) (PreH13 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH14 : (In original (os_semaphores (held)) )) (PreH15 : ((semaphore_id (original)) = id_pre)) (PreH16 : ((semaphore_value (original)) = 0)) (PreH17 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH18 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH19 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH20 : (((suspended.(os_delays) ).(delay_inactive_map) ((sd.(tdDelay) ))) <> None)) (PreH21 : (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) )) (PreH22 : (os_global_context sg_semaphore_obtain_oc )) (PreH23 : forall (delayed: VarGlobalState), forall (dp: Z), forall (rc: Z), ((ktask_set_delay_step task sd wait_time dp suspended rc delayed ) -> (derivable1 (sepcon ((store_ptr (&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) (dp))) ((sepcon ((delay_inv (sg_semaphore_obtain_oc) (delayed))) ((sepcon ((tick_inv (sg_semaphore_obtain_oc) (delayed))) (delay_frame)))))) (os_inv (sg_semaphore_obtain_oc) (delayed)) ))) (PreH24 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH25 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) # Ptr  |-> delay_after)
  **  (delay_inv sg_semaphore_obtain_oc st_after )
  **  (tick_inv sg_semaphore_obtain_oc st_after )
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (andp (coq_prop ((os_global_context (sg_semaphore_obtain_oc)))) delay_frame )
|--
  EX (prepared: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))),
  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (task <> 0) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (prepared)) abs_ktask_assign Y ) ”
  &&  “ forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc )) ”
  &&  “ (Crtos_GTrans held prepared ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc prepared )
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (delay_frame: Assertion) (delay_after: Z) (st_after: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (ktask_set_delay_step task sd wait_time delay_after suspended retval st_after )) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : ((-1) <= msec_pre)) (PreH6 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH7 : (0 < wait_time)) (PreH8 : (wait_time < KTICK_HALF_RANGE)) (PreH9 : (task = (assignRunningTask ((os_assign (held)))))) (PreH10 : (task <> 0)) (PreH11 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH12 : (sem = (semaphore_addr (original)))) (PreH13 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH14 : (In original (os_semaphores (held)) )) (PreH15 : ((semaphore_id (original)) = id_pre)) (PreH16 : ((semaphore_value (original)) = 0)) (PreH17 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH18 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH19 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH20 : (((suspended.(os_delays) ).(delay_inactive_map) ((sd.(tdDelay) ))) <> None)) (PreH21 : (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) )) (PreH22 : (os_global_context sg_semaphore_obtain_oc )) (PreH23 : forall (delayed: VarGlobalState), forall (dp: Z), forall (rc: Z), ((ktask_set_delay_step task sd wait_time dp suspended rc delayed ) -> (derivable1 (sepcon ((store_ptr (&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) (dp))) ((sepcon ((delay_inv (sg_semaphore_obtain_oc) (delayed))) ((sepcon ((tick_inv (sg_semaphore_obtain_oc) (delayed))) (delay_frame)))))) (os_inv (sg_semaphore_obtain_oc) (delayed)) ))) (PreH24 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH25 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) # Ptr  |-> delay_after)
  **  (delay_inv sg_semaphore_obtain_oc st_after )
  **  (tick_inv sg_semaphore_obtain_oc st_after )
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (andp (coq_prop ((os_global_context (sg_semaphore_obtain_oc)))) delay_frame )
|--
  EX (prepared: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))),
  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (task <> 0) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (prepared)) abs_ktask_assign Y ) ”
  &&  “ forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc )) ”
  &&  “ (Crtos_GTrans held prepared ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc prepared )
).

Definition _SemaphoreObtain_entail_wit_14_2 :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (delay_frame: Assertion) (delay_after: Z) (st_after: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (ktask_set_delay_step task sd wait_time delay_after suspended retval st_after )) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : ((-1) <= msec_pre)) (PreH6 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH7 : (0 < wait_time)) (PreH8 : (wait_time < KTICK_HALF_RANGE)) (PreH9 : (task = (assignRunningTask ((os_assign (held)))))) (PreH10 : (task <> 0)) (PreH11 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH12 : (sem = (semaphore_addr (original)))) (PreH13 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH14 : (In original (os_semaphores (held)) )) (PreH15 : ((semaphore_id (original)) = id_pre)) (PreH16 : ((semaphore_value (original)) = 0)) (PreH17 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH18 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH19 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH20 : ((sd.(tdDelay) ) = 0)) (PreH21 : (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) )) (PreH22 : (os_global_context sg_semaphore_obtain_oc )) (PreH23 : forall (delayed: VarGlobalState), forall (dp: Z), forall (rc: Z), ((ktask_set_delay_step task sd wait_time dp suspended rc delayed ) -> (derivable1 (sepcon ((store_ptr (&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) (dp))) ((sepcon ((delay_inv (sg_semaphore_obtain_oc) (delayed))) ((sepcon ((tick_inv (sg_semaphore_obtain_oc) (delayed))) (delay_frame)))))) (os_inv (sg_semaphore_obtain_oc) (delayed)) ))) (PreH24 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH25 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) # Ptr  |-> delay_after)
  **  (delay_inv sg_semaphore_obtain_oc st_after )
  **  (tick_inv sg_semaphore_obtain_oc st_after )
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (andp (coq_prop ((os_global_context (sg_semaphore_obtain_oc)))) delay_frame )
|--
  EX (prepared: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))),
  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (task <> 0) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (prepared)) abs_ktask_assign Y ) ”
  &&  “ forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc )) ”
  &&  “ (Crtos_GTrans held prepared ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc prepared )
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (delay_frame: Assertion) (delay_after: Z) (st_after: VarGlobalState) (retval: Z) (PreH1 : (retval = 0)) (PreH2 : (ktask_set_delay_step task sd wait_time delay_after suspended retval st_after )) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : ((-1) <= msec_pre)) (PreH6 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH7 : (0 < wait_time)) (PreH8 : (wait_time < KTICK_HALF_RANGE)) (PreH9 : (task = (assignRunningTask ((os_assign (held)))))) (PreH10 : (task <> 0)) (PreH11 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH12 : (sem = (semaphore_addr (original)))) (PreH13 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH14 : (In original (os_semaphores (held)) )) (PreH15 : ((semaphore_id (original)) = id_pre)) (PreH16 : ((semaphore_value (original)) = 0)) (PreH17 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH18 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH19 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH20 : ((sd.(tdDelay) ) = 0)) (PreH21 : (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) )) (PreH22 : (os_global_context sg_semaphore_obtain_oc )) (PreH23 : forall (delayed: VarGlobalState), forall (dp: Z), forall (rc: Z), ((ktask_set_delay_step task sd wait_time dp suspended rc delayed ) -> (derivable1 (sepcon ((store_ptr (&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) (dp))) ((sepcon ((delay_inv (sg_semaphore_obtain_oc) (delayed))) ((sepcon ((tick_inv (sg_semaphore_obtain_oc) (delayed))) (delay_frame)))))) (os_inv (sg_semaphore_obtain_oc) (delayed)) ))) (PreH24 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH25 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) # Ptr  |-> delay_after)
  **  (delay_inv sg_semaphore_obtain_oc st_after )
  **  (tick_inv sg_semaphore_obtain_oc st_after )
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (andp (coq_prop ((os_global_context (sg_semaphore_obtain_oc)))) delay_frame )
|--
  EX (prepared: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))),
  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (task <> 0) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (prepared)) abs_ktask_assign Y ) ”
  &&  “ forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc )) ”
  &&  “ (Crtos_GTrans held prepared ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc prepared )
).

Definition _SemaphoreObtain_entail_wit_14_3 :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (PreH1 : (wait_time <= 0)) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre <= 65535)) (PreH4 : ((-1) <= msec_pre)) (PreH5 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH6 : (wait_time <> 0)) (PreH7 : ((-1) <= wait_time)) (PreH8 : (wait_time < KTICK_HALF_RANGE)) (PreH9 : (task = (assignRunningTask ((os_assign (held)))))) (PreH10 : (task <> 0)) (PreH11 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH12 : (sem = (semaphore_addr (original)))) (PreH13 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH14 : (In original (os_semaphores (held)) )) (PreH15 : ((semaphore_id (original)) = id_pre)) (PreH16 : ((semaphore_value (original)) = 0)) (PreH17 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH18 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH19 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH20 : ((0 < wait_time) -> ((((sd.(tdDelay) ) = 0) \/ (((suspended.(os_delays) ).(delay_inactive_map) ((sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) )))) (PreH21 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc suspended )
|--
  EX (prepared: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))),
  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (task <> 0) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (prepared)) abs_ktask_assign Y ) ”
  &&  “ forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc )) ”
  &&  “ (Crtos_GTrans held prepared ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc prepared )
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (PreH1 : (wait_time <= 0)) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre <= 65535)) (PreH4 : ((-1) <= msec_pre)) (PreH5 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH6 : (wait_time <> 0)) (PreH7 : ((-1) <= wait_time)) (PreH8 : (wait_time < KTICK_HALF_RANGE)) (PreH9 : (task = (assignRunningTask ((os_assign (held)))))) (PreH10 : (task <> 0)) (PreH11 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH12 : (sem = (semaphore_addr (original)))) (PreH13 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH14 : (In original (os_semaphores (held)) )) (PreH15 : ((semaphore_id (original)) = id_pre)) (PreH16 : ((semaphore_value (original)) = 0)) (PreH17 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH18 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH19 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH20 : ((0 < wait_time) -> ((((sd.(tdDelay) ) = 0) \/ (((suspended.(os_delays) ).(delay_inactive_map) ((sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) )))) (PreH21 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  TT && emp 
|--
  EX (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))),
  “ ( monadesafe_lib.safeExec  (LastSeen (suspended)) abs_ktask_assign Y ) ”
  &&  “ forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) ((assignRunningTask ((os_assign (held)))))) X_semaphore_obtain_oc )) ”
  &&  “ (Crtos_GTrans held suspended ) ”
  &&  emp
).

Definition _SemaphoreObtain_entail_wit_15 :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (prepared: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (after: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) Y )) (PreH2 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH3 : (task = (assignRunningTask ((os_assign (held)))))) (PreH4 : (task <> 0)) (PreH5 : (sem = (semaphore_addr (original)))) (PreH6 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (prepared)) abs_ktask_assign Y )) (PreH8 : forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc ))) (PreH9 : (Crtos_GTrans held prepared )),
  (OutsideCritical sg_semaphore_obtain_oc after )
|--
  EX (scheduled: VarGlobalState),
  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (scheduled)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc ) ”
  &&  (OutsideCritical sg_semaphore_obtain_oc scheduled )
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (prepared: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (after: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) Y )) (PreH2 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH3 : (task = (assignRunningTask ((os_assign (held)))))) (PreH4 : (task <> 0)) (PreH5 : (sem = (semaphore_addr (original)))) (PreH6 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (prepared)) abs_ktask_assign Y )) (PreH8 : forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc ))) (PreH9 : (Crtos_GTrans held prepared )),
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc ) ”
  &&  emp
).

Definition _SemaphoreObtain_entail_wit_15_split_goal_1 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (prepared: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (after: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) Y )) (PreH2 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH3 : (task = (assignRunningTask ((os_assign (held)))))) (PreH4 : (task <> 0)) (PreH5 : (sem = (semaphore_addr (original)))) (PreH6 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (prepared)) abs_ktask_assign Y )) (PreH8 : forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc ))) (PreH9 : (Crtos_GTrans held prepared )),
  ( monadesafe_lib.safeExec  (LastSeen (after)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc )
.

Definition _SemaphoreObtain_entail_wit_16 :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (scheduled: VarGlobalState) (st_lock: VarGlobalState) (PreH1 : (Crtos_RTrans scheduled st_lock )) (PreH2 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH3 : (task = (assignRunningTask ((os_assign (held)))))) (PreH4 : (sem = (semaphore_addr (original)))) (PreH5 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (scheduled)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc )),
  (InsideCritical sg_semaphore_obtain_oc st_lock )
  **  (os_inv sg_semaphore_obtain_oc st_lock )
|--
  EX (status_desc: TaskDescriptorAbs) (observed: VarGlobalState),
  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (Crtos_RTrans scheduled observed ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (scheduled)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc ) ”
  &&  “ ((task_desc_map ((os_tasks (observed))) (task)) = (Some (status_desc))) ”
  &&  (InsideCritical sg_semaphore_obtain_oc observed )
  **  ((&((task)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (status_desc.(tdExstatus) ))
  **  (wand (store_int (&((task)  # "TaskDescriptor" ->ₛ "exstatus")) ((status_desc.(tdExstatus) ))) (os_inv (sg_semaphore_obtain_oc) (observed)) )
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (scheduled: VarGlobalState) (st_lock: VarGlobalState) (PreH1 : (Crtos_RTrans scheduled st_lock )) (PreH2 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH3 : (task = (assignRunningTask ((os_assign (held)))))) (PreH4 : (sem = (semaphore_addr (original)))) (PreH5 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (scheduled)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc )),
  (InsideCritical sg_semaphore_obtain_oc st_lock )
  **  (os_inv sg_semaphore_obtain_oc st_lock )
|--
  EX (status_desc: TaskDescriptorAbs) (observed: VarGlobalState),
  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (Crtos_RTrans scheduled observed ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (scheduled)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc ) ”
  &&  “ ((task_desc_map ((os_tasks (observed))) (task)) = (Some (status_desc))) ”
  &&  (InsideCritical sg_semaphore_obtain_oc observed )
  **  ((&((task)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (status_desc.(tdExstatus) ))
  **  (wand (store_int (&((task)  # "TaskDescriptor" ->ₛ "exstatus")) ((status_desc.(tdExstatus) ))) (os_inv (sg_semaphore_obtain_oc) (observed)) )
).

Definition _SemaphoreObtain_entail_wit_17 :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (scheduled: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (observed: VarGlobalState) (status_desc: TaskDescriptorAbs) (PreH1 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH2 : (task = (assignRunningTask ((os_assign (held)))))) (PreH3 : (sem = (semaphore_addr (original)))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : (Crtos_RTrans scheduled observed )) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (scheduled)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc )) (PreH7 : ((task_desc_map ((os_tasks (observed))) (task)) = (Some (status_desc)))),
  ((&((task)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (status_desc.(tdExstatus) ))
  **  (InsideCritical sg_semaphore_obtain_oc observed )
  **  (wand (store_int (&((task)  # "TaskDescriptor" ->ₛ "exstatus")) ((status_desc.(tdExstatus) ))) (os_inv (sg_semaphore_obtain_oc) (observed)) )
|--
  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ ((status_desc.(tdExstatus) ) = (status_desc.(tdExstatus) )) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (observed)) ( MonadErr.ret  ((status_desc.(tdExstatus) ))) X_semaphore_obtain_oc ) ”
  &&  “ (Crtos_GTrans observed observed ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc observed )
  **  (os_inv sg_semaphore_obtain_oc observed )
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (scheduled: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (observed: VarGlobalState) (status_desc: TaskDescriptorAbs) (PreH1 : ((status_desc.(tdExstatus) ) <= INT_MAX)) (PreH2 : ((status_desc.(tdExstatus) ) >= INT_MIN)) (PreH3 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH4 : (task = (assignRunningTask ((os_assign (held)))))) (PreH5 : (sem = (semaphore_addr (original)))) (PreH6 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH7 : (Crtos_RTrans scheduled observed )) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (scheduled)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc )) (PreH9 : ((task_desc_map ((os_tasks (observed))) (task)) = (Some (status_desc)))),
  ((&((task)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (status_desc.(tdExstatus) ))
  **  (InsideCritical sg_semaphore_obtain_oc observed )
  **  (wand (store_int (&((task)  # "TaskDescriptor" ->ₛ "exstatus")) ((status_desc.(tdExstatus) ))) (os_inv (sg_semaphore_obtain_oc) (observed)) )
|--
  “ (Crtos_GTrans observed observed ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (observed)) ( MonadErr.ret  ((status_desc.(tdExstatus) ))) X_semaphore_obtain_oc ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc observed )
  **  (os_inv sg_semaphore_obtain_oc observed )
).

Definition _SemaphoreObtain_entail_wit_17_split_goal_1 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (scheduled: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (observed: VarGlobalState) (status_desc: TaskDescriptorAbs) (PreH1 : ((status_desc.(tdExstatus) ) <= INT_MAX)) (PreH2 : ((status_desc.(tdExstatus) ) >= INT_MIN)) (PreH3 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH4 : (task = (assignRunningTask ((os_assign (held)))))) (PreH5 : (sem = (semaphore_addr (original)))) (PreH6 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH7 : (Crtos_RTrans scheduled observed )) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (scheduled)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc )) (PreH9 : ((task_desc_map ((os_tasks (observed))) (task)) = (Some (status_desc)))),
  ((&((task)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (status_desc.(tdExstatus) ))
  **  (InsideCritical sg_semaphore_obtain_oc observed )
  **  (wand (store_int (&((task)  # "TaskDescriptor" ->ₛ "exstatus")) ((status_desc.(tdExstatus) ))) (os_inv (sg_semaphore_obtain_oc) (observed)) )
|--
  “ (Crtos_GTrans observed observed ) ”
.

Definition _SemaphoreObtain_entail_wit_17_split_goal_2 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (scheduled: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (observed: VarGlobalState) (status_desc: TaskDescriptorAbs) (PreH1 : ((status_desc.(tdExstatus) ) <= INT_MAX)) (PreH2 : ((status_desc.(tdExstatus) ) >= INT_MIN)) (PreH3 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH4 : (task = (assignRunningTask ((os_assign (held)))))) (PreH5 : (sem = (semaphore_addr (original)))) (PreH6 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH7 : (Crtos_RTrans scheduled observed )) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (scheduled)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc )) (PreH9 : ((task_desc_map ((os_tasks (observed))) (task)) = (Some (status_desc)))),
  ((&((task)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (status_desc.(tdExstatus) ))
  **  (InsideCritical sg_semaphore_obtain_oc observed )
  **  (wand (store_int (&((task)  # "TaskDescriptor" ->ₛ "exstatus")) ((status_desc.(tdExstatus) ))) (os_inv (sg_semaphore_obtain_oc) (observed)) )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (observed)) ( MonadErr.ret  ((status_desc.(tdExstatus) ))) X_semaphore_obtain_oc ) ”
.

Definition _SemaphoreObtain_entail_wit_17_split_goal_spatial :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (scheduled: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (observed: VarGlobalState) (status_desc: TaskDescriptorAbs) (PreH1 : ((status_desc.(tdExstatus) ) <= INT_MAX)) (PreH2 : ((status_desc.(tdExstatus) ) >= INT_MIN)) (PreH3 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH4 : (task = (assignRunningTask ((os_assign (held)))))) (PreH5 : (sem = (semaphore_addr (original)))) (PreH6 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH7 : (Crtos_RTrans scheduled observed )) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (scheduled)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc )) (PreH9 : ((task_desc_map ((os_tasks (observed))) (task)) = (Some (status_desc)))),
  ((&((task)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (status_desc.(tdExstatus) ))
  **  (InsideCritical sg_semaphore_obtain_oc observed )
  **  (wand (store_int (&((task)  # "TaskDescriptor" ->ₛ "exstatus")) ((status_desc.(tdExstatus) ))) (os_inv (sg_semaphore_obtain_oc) (observed)) )
|--
  (InsideCritical sg_semaphore_obtain_oc observed )
  **  (os_inv sg_semaphore_obtain_oc observed )
.

Definition _SemaphoreObtain_return_wit_1 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (observed: VarGlobalState) (status_desc: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (result: Z) (PreH1 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH2 : (task = (assignRunningTask ((os_assign (held)))))) (PreH3 : (sem = (semaphore_addr (original)))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : (result = (status_desc.(tdExstatus) ))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (observed)) ( MonadErr.ret  (result)) X_semaphore_obtain_oc )) (PreH7 : (Crtos_GTrans observed observed )),
  (OutsideCritical sg_semaphore_obtain_oc observed )
|--
  EX (after: VarGlobalState),
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (result)) X_semaphore_obtain_oc ) ”
  &&  (OutsideCritical sg_semaphore_obtain_oc after )
.

Definition _SemaphoreObtain_return_wit_2 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (after_wakeup: VarGlobalState) (PreH1 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH2 : (task = (assignRunningTask ((os_assign (held)))))) (PreH3 : (sem = (semaphore_addr (original)))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (after_wakeup)) ( MonadErr.ret  ((-5))) X_semaphore_obtain_oc )) (PreH6 : (Crtos_GTrans held after_wakeup )),
  (OutsideCritical sg_semaphore_obtain_oc after_wakeup )
|--
  EX (after: VarGlobalState),
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  ((-5))) X_semaphore_obtain_oc ) ”
  &&  (OutsideCritical sg_semaphore_obtain_oc after )
.

Definition _SemaphoreObtain_return_wit_3 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = 0)) (PreH5 : (task = 0)) (PreH6 : (sem = (semaphore_addr (original)))) (PreH7 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-2))) X_semaphore_obtain_oc )) (PreH9 : (Crtos_GTrans held held )),
  (OutsideCritical sg_semaphore_obtain_oc held )
|--
  EX (after: VarGlobalState),
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  ((-2))) X_semaphore_obtain_oc ) ”
  &&  (OutsideCritical sg_semaphore_obtain_oc after )
.

Definition _SemaphoreObtain_return_wit_4 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : (task = 0)) (PreH6 : (sem = (semaphore_addr (original)))) (PreH7 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen ((replace_semaphores ((semaphore_set_value (sem) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)))) ( MonadErr.ret  (0)) X_semaphore_obtain_oc )) (PreH9 : (Crtos_GTrans held (replace_semaphores ((semaphore_set_value (sem) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)) )),
  (OutsideCritical sg_semaphore_obtain_oc (replace_semaphores ((semaphore_set_value ((semaphore_addr (original))) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)) )
|--
  EX (after: VarGlobalState),
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (0)) X_semaphore_obtain_oc ) ”
  &&  (OutsideCritical sg_semaphore_obtain_oc after )
.

Definition _SemaphoreObtain_return_wit_5 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : (task = 0)) (PreH6 : (sem = 0)) (PreH7 : (idnode = 0)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-1))) X_semaphore_obtain_oc )) (PreH9 : (Crtos_GTrans held held )),
  (OutsideCritical sg_semaphore_obtain_oc held )
|--
  EX (after: VarGlobalState),
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  ((-1))) X_semaphore_obtain_oc ) ”
  &&  (OutsideCritical sg_semaphore_obtain_oc after )
.

Definition _SemaphoreObtain_return_wit_6 :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre <> (-1))) (PreH2 : (msec_pre < 0)) (PreH3 : (id_pre <= 65535)) (PreH4 : (id_pre >= 0)) (PreH5 : ((INT_MIN) <= msec_pre)) (PreH6 : (msec_pre <= INT_MAX)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  EX (after: VarGlobalState),
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  ((-1))) X_semaphore_obtain_oc ) ”
  &&  (OutsideCritical sg_semaphore_obtain_oc after )
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre <> (-1))) (PreH2 : (msec_pre < 0)) (PreH3 : (id_pre <= 65535)) (PreH4 : (id_pre >= 0)) (PreH5 : ((INT_MIN) <= msec_pre)) (PreH6 : (msec_pre <= INT_MAX)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) ( MonadErr.ret  ((-1))) X_semaphore_obtain_oc ) ”
  &&  emp
).

Definition _SemaphoreObtain_return_wit_6_split_goal_1 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre <> (-1))) (PreH2 : (msec_pre < 0)) (PreH3 : (id_pre <= 65535)) (PreH4 : (id_pre >= 0)) (PreH5 : ((INT_MIN) <= msec_pre)) (PreH6 : (msec_pre <= INT_MAX)) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) ( MonadErr.ret  ((-1))) X_semaphore_obtain_oc )
.

Definition _SemaphoreObtain_return_wit_7 :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (id_pre < 0)) (PreH2 : ((INT_MIN) <= msec_pre)) (PreH3 : (msec_pre <= INT_MAX)) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  EX (after: VarGlobalState),
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  ((-1))) X_semaphore_obtain_oc ) ”
  &&  (OutsideCritical sg_semaphore_obtain_oc after )
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (id_pre < 0)) (PreH2 : ((INT_MIN) <= msec_pre)) (PreH3 : (msec_pre <= INT_MAX)) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) ( MonadErr.ret  ((-1))) X_semaphore_obtain_oc ) ”
  &&  emp
).

Definition _SemaphoreObtain_return_wit_7_split_goal_1 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (id_pre < 0)) (PreH2 : ((INT_MIN) <= msec_pre)) (PreH3 : (msec_pre <= INT_MAX)) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) ( MonadErr.ret  ((-1))) X_semaphore_obtain_oc )
.

Definition _SemaphoreObtain_return_wit_8 :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (id_pre > 65535)) (PreH2 : (id_pre >= 0)) (PreH3 : ((INT_MIN) <= msec_pre)) (PreH4 : (msec_pre <= INT_MAX)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  EX (after: VarGlobalState),
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  ((-1))) X_semaphore_obtain_oc ) ”
  &&  (OutsideCritical sg_semaphore_obtain_oc after )
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (id_pre > 65535)) (PreH2 : (id_pre >= 0)) (PreH3 : ((INT_MIN) <= msec_pre)) (PreH4 : (msec_pre <= INT_MAX)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) ( MonadErr.ret  ((-1))) X_semaphore_obtain_oc ) ”
  &&  emp
).

Definition _SemaphoreObtain_return_wit_8_split_goal_1 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (id_pre > 65535)) (PreH2 : (id_pre >= 0)) (PreH3 : ((INT_MIN) <= msec_pre)) (PreH4 : (msec_pre <= INT_MAX)) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) ( MonadErr.ret  ((-1))) X_semaphore_obtain_oc )
.

Definition _SemaphoreObtain_partial_solve_wit_1 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
.

Definition _SemaphoreObtain_partial_solve_wit_2 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : ((INT_MIN) <= msec_pre)) (PreH2 : (msec_pre <= INT_MAX)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (store_integer (Z.to_nat (4)) 4 ( &( "msec" ) ) msec_pre )
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ ((INT_MIN) <= msec_pre) ”
  &&  “ (msec_pre <= INT_MAX) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  (store_integer (Z.to_nat (4)) 4 ( &( "msec" ) ) msec_pre )
  **  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
.

Definition _SemaphoreObtain_partial_solve_wit_3 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (PreH1 : (msec_pre <> (-1))) (PreH2 : (msec_pre <> 0)) (PreH3 : (msec_pre >= 0)) (PreH4 : (id_pre <= 65535)) (PreH5 : (id_pre >= 0)) (PreH6 : ((INT_MIN) <= msec_pre)) (PreH7 : (msec_pre <= INT_MAX)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (msec_pre <> (-1)) ”
  &&  “ (msec_pre <> 0) ”
  &&  “ (msec_pre >= 0) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (id_pre >= 0) ”
  &&  “ ((INT_MIN) <= msec_pre) ”
  &&  “ (msec_pre <= INT_MAX) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
.

Definition _SemaphoreObtain_partial_solve_wit_4 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (wait_time: Z) (lock: Z) (task: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : ((-1) <= wait_time)) (PreH6 : (wait_time < KTICK_HALF_RANGE)) (PreH7 : (lock = 0)) (PreH8 : (task = 0)) (PreH9 : (sem = 0)) (PreH10 : (idnode = 0)) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ ((-1) <= wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (lock = 0) ”
  &&  “ (task = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (idnode = 0) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  (OutsideCritical sg_semaphore_obtain_oc before_semaphore_obtain_oc )
.

Definition _SemaphoreObtain_partial_solve_wit_5 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : ((-1) <= wait_time)) (PreH6 : (wait_time < KTICK_HALF_RANGE)) (PreH7 : (task = 0)) (PreH8 : (sem = 0)) (PreH9 : (idnode = 0)) (PreH10 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc held )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ ((-1) <= wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (task = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (idnode = 0) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  (os_inv sg_semaphore_obtain_oc held )
  **  (InsideCritical sg_semaphore_obtain_oc held )
.

Definition _SemaphoreObtain_partial_solve_wit_6_pure :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (saved: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : ((-1) <= wait_time)) (PreH6 : (wait_time < KTICK_HALF_RANGE)) (PreH7 : (task = 0)) (PreH8 : (sem = 0)) (PreH9 : (idnode = 0)) (PreH10 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre < 65536) ”
.

Definition _SemaphoreObtain_partial_solve_wit_6_aux :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (held: VarGlobalState) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : ((-1) <= wait_time)) (PreH6 : (wait_time < KTICK_HALF_RANGE)) (PreH7 : (task = 0)) (PreH8 : (sem = 0)) (PreH9 : (idnode = 0)) (PreH10 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre < 65536) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ ((-1) <= wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (task = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (idnode = 0) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
.

Definition _SemaphoreObtain_partial_solve_wit_6 := _SemaphoreObtain_partial_solve_wit_6_pure -> _SemaphoreObtain_partial_solve_wit_6_aux.

Definition _SemaphoreObtain_partial_solve_wit_7_pure :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : (task = 0)) (PreH6 : (sem = 0)) (PreH7 : (idnode = 0)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-1))) X_semaphore_obtain_oc )) (PreH9 : (Crtos_GTrans held held )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc held )
|--
  “ (Crtos_GTrans held held ) ”
.

Definition _SemaphoreObtain_partial_solve_wit_7_aux :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : (task = 0)) (PreH6 : (sem = 0)) (PreH7 : (idnode = 0)) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-1))) X_semaphore_obtain_oc )) (PreH9 : (Crtos_GTrans held held )),
  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc held )
|--
  “ (Crtos_GTrans held held ) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (task = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (idnode = 0) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-1))) X_semaphore_obtain_oc ) ”
  &&  “ (Crtos_GTrans held held ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc held )
.

Definition _SemaphoreObtain_partial_solve_wit_7 := _SemaphoreObtain_partial_solve_wit_7_pure -> _SemaphoreObtain_partial_solve_wit_7_aux.

Definition _SemaphoreObtain_partial_solve_wit_8_pure :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : ((-1) <= wait_time)) (PreH6 : (wait_time < KTICK_HALF_RANGE)) (PreH7 : (0 <= id_pre)) (PreH8 : (id_pre <= 65535)) (PreH9 : (task = 0)) (PreH10 : (sem = 0)) (PreH11 : (In original (os_semaphores (held)) )) (PreH12 : ((semaphore_id (original)) = id_pre)) (PreH13 : ((semaphore_addr (original)) <> 0)) (PreH14 : (0 <= (semaphore_value (original)))) (PreH15 : ((semaphore_value (original)) <= 65535)) (PreH16 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH17 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc held )
|--
  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
.

Definition _SemaphoreObtain_partial_solve_wit_8_aux :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : ((-1) <= wait_time)) (PreH6 : (wait_time < KTICK_HALF_RANGE)) (PreH7 : (0 <= id_pre)) (PreH8 : (id_pre <= 65535)) (PreH9 : (task = 0)) (PreH10 : (sem = 0)) (PreH11 : (In original (os_semaphores (held)) )) (PreH12 : ((semaphore_id (original)) = id_pre)) (PreH13 : ((semaphore_addr (original)) <> 0)) (PreH14 : (0 <= (semaphore_value (original)))) (PreH15 : ((semaphore_value (original)) <= 65535)) (PreH16 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH17 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc held )
|--
  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ ((-1) <= wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (task = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_addr (original)) <> 0) ”
  &&  “ (0 <= (semaphore_value (original))) ”
  &&  “ ((semaphore_value (original)) <= 65535) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc held )
.

Definition _SemaphoreObtain_partial_solve_wit_8 := _SemaphoreObtain_partial_solve_wit_8_pure -> _SemaphoreObtain_partial_solve_wit_8_aux.

Definition _SemaphoreObtain_partial_solve_wit_9_pure :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : (retval = (semaphore_addr (original)))) (PreH2 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : ((-1) <= msec_pre)) (PreH6 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH7 : ((-1) <= wait_time)) (PreH8 : (wait_time < KTICK_HALF_RANGE)) (PreH9 : (0 <= id_pre)) (PreH10 : (id_pre <= 65535)) (PreH11 : (task = 0)) (PreH12 : (sem = 0)) (PreH13 : (In original (os_semaphores (held)) )) (PreH14 : ((semaphore_id (original)) = id_pre)) (PreH15 : ((semaphore_addr (original)) <> 0)) (PreH16 : (0 <= (semaphore_value (original)))) (PreH17 : ((semaphore_value (original)) <= 65535)) (PreH18 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH19 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc held )
|--
  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
.

Definition _SemaphoreObtain_partial_solve_wit_9_aux :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : (retval = (semaphore_addr (original)))) (PreH2 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH3 : (0 <= id_pre)) (PreH4 : (id_pre <= 65535)) (PreH5 : ((-1) <= msec_pre)) (PreH6 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH7 : ((-1) <= wait_time)) (PreH8 : (wait_time < KTICK_HALF_RANGE)) (PreH9 : (0 <= id_pre)) (PreH10 : (id_pre <= 65535)) (PreH11 : (task = 0)) (PreH12 : (sem = 0)) (PreH13 : (In original (os_semaphores (held)) )) (PreH14 : ((semaphore_id (original)) = id_pre)) (PreH15 : ((semaphore_addr (original)) <> 0)) (PreH16 : (0 <= (semaphore_value (original)))) (PreH17 : ((semaphore_value (original)) <= 65535)) (PreH18 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH19 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "sem" ) )) # Ptr  |-> retval)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc held )
|--
  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
  &&  “ (retval = (semaphore_addr (original))) ”
  &&  “ (idnode = &((retval)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ ((-1) <= wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (task = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_addr (original)) <> 0) ”
  &&  “ (0 <= (semaphore_value (original))) ”
  &&  “ ((semaphore_value (original)) <= 65535) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  ((( &( "sem" ) )) # Ptr  |-> (semaphore_addr (original)))
  **  (os_inv sg_semaphore_obtain_oc held )
  **  (InsideCritical sg_semaphore_obtain_oc held )
.

Definition _SemaphoreObtain_partial_solve_wit_9 := _SemaphoreObtain_partial_solve_wit_9_pure -> _SemaphoreObtain_partial_solve_wit_9_aux.

Definition _SemaphoreObtain_partial_solve_wit_10 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : ((semaphore_addr (original)) = (semaphore_addr (original)))) (PreH2 : (0 < (semaphore_value (original)))) (PreH3 : (retval = (semaphore_addr (original)))) (PreH4 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : ((-1) <= msec_pre)) (PreH8 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH9 : ((-1) <= wait_time)) (PreH10 : (wait_time < KTICK_HALF_RANGE)) (PreH11 : (0 <= id_pre)) (PreH12 : (id_pre <= 65535)) (PreH13 : (task = 0)) (PreH14 : (sem = 0)) (PreH15 : (In original (os_semaphores (held)) )) (PreH16 : ((semaphore_id (original)) = id_pre)) (PreH17 : ((semaphore_addr (original)) <> 0)) (PreH18 : (0 <= (semaphore_value (original)))) (PreH19 : ((semaphore_value (original)) <= 65535)) (PreH20 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH21 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (((semaphore_value (original)) - 1 ))) (os_inv (sg_semaphore_obtain_oc) ((replace_semaphores ((semaphore_set_value ((semaphore_addr (original))) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)))) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ (0 < (semaphore_value (original))) ”
  &&  “ (retval = (semaphore_addr (original))) ”
  &&  “ (idnode = &((retval)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ ((-1) <= wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (task = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_addr (original)) <> 0) ”
  &&  “ (0 <= (semaphore_value (original))) ”
  &&  “ ((semaphore_value (original)) <= 65535) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (((semaphore_value (original)) - 1 ))) (os_inv (sg_semaphore_obtain_oc) ((replace_semaphores ((semaphore_set_value ((semaphore_addr (original))) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)))) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
.

Definition _SemaphoreObtain_partial_solve_wit_11 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : ((semaphore_addr (original)) = (semaphore_addr (original)))) (PreH2 : ((semaphore_value (original)) = 0)) (PreH3 : (retval = (semaphore_addr (original)))) (PreH4 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : ((-1) <= msec_pre)) (PreH8 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH9 : ((-1) <= wait_time)) (PreH10 : (wait_time < KTICK_HALF_RANGE)) (PreH11 : (0 <= id_pre)) (PreH12 : (id_pre <= 65535)) (PreH13 : (task = 0)) (PreH14 : (sem = 0)) (PreH15 : (In original (os_semaphores (held)) )) (PreH16 : ((semaphore_id (original)) = id_pre)) (PreH17 : ((semaphore_addr (original)) <> 0)) (PreH18 : (0 <= (semaphore_value (original)))) (PreH19 : ((semaphore_value (original)) <= 65535)) (PreH20 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH21 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (0)) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ ((semaphore_value (original)) = 0) ”
  &&  “ (retval = (semaphore_addr (original))) ”
  &&  “ (idnode = &((retval)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ ((-1) <= wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (task = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_addr (original)) <> 0) ”
  &&  “ (0 <= (semaphore_value (original))) ”
  &&  “ ((semaphore_value (original)) <= 65535) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (0)) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
.

Definition _SemaphoreObtain_partial_solve_wit_12_pure :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : (task = 0)) (PreH6 : (sem = (semaphore_addr (original)))) (PreH7 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen ((replace_semaphores ((semaphore_set_value (sem) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)))) ( MonadErr.ret  (0)) X_semaphore_obtain_oc )) (PreH9 : (Crtos_GTrans held (replace_semaphores ((semaphore_set_value (sem) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)) )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc (replace_semaphores ((semaphore_set_value (sem) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)) )
|--
  “ (Crtos_GTrans held (replace_semaphores ((semaphore_set_value ((semaphore_addr (original))) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)) ) ”
.

Definition _SemaphoreObtain_partial_solve_wit_12_aux :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : (task = 0)) (PreH6 : (sem = (semaphore_addr (original)))) (PreH7 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen ((replace_semaphores ((semaphore_set_value (sem) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)))) ( MonadErr.ret  (0)) X_semaphore_obtain_oc )) (PreH9 : (Crtos_GTrans held (replace_semaphores ((semaphore_set_value (sem) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)) )),
  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc (replace_semaphores ((semaphore_set_value (sem) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)) )
|--
  “ (Crtos_GTrans held (replace_semaphores ((semaphore_set_value ((semaphore_addr (original))) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)) ) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (task = 0) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen ((replace_semaphores ((semaphore_set_value (sem) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)))) ( MonadErr.ret  (0)) X_semaphore_obtain_oc ) ”
  &&  “ (Crtos_GTrans held (replace_semaphores ((semaphore_set_value (sem) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)) ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc (replace_semaphores ((semaphore_set_value ((semaphore_addr (original))) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)) )
.

Definition _SemaphoreObtain_partial_solve_wit_12 := _SemaphoreObtain_partial_solve_wit_12_pure -> _SemaphoreObtain_partial_solve_wit_12_aux.

Definition _SemaphoreObtain_partial_solve_wit_13_pure :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : ((semaphore_value (original)) <= 0)) (PreH2 : ((semaphore_value (original)) = 0)) (PreH3 : (retval = (semaphore_addr (original)))) (PreH4 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : ((-1) <= msec_pre)) (PreH8 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH9 : ((-1) <= wait_time)) (PreH10 : (wait_time < KTICK_HALF_RANGE)) (PreH11 : (0 <= id_pre)) (PreH12 : (id_pre <= 65535)) (PreH13 : (task = 0)) (PreH14 : (sem = 0)) (PreH15 : (In original (os_semaphores (held)) )) (PreH16 : ((semaphore_id (original)) = id_pre)) (PreH17 : ((semaphore_addr (original)) <> 0)) (PreH18 : (0 <= (semaphore_value (original)))) (PreH19 : ((semaphore_value (original)) <= 65535)) (PreH20 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH21 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "sem" ) )) # Ptr  |-> (semaphore_addr (original)))
  **  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (0)) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
  &&  “ (0 = 0) ”
.

Definition _SemaphoreObtain_partial_solve_wit_13_aux :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (original: SemaphoreAbs) (retval: Z) (PreH1 : ((semaphore_value (original)) <= 0)) (PreH2 : ((semaphore_value (original)) = 0)) (PreH3 : (retval = (semaphore_addr (original)))) (PreH4 : (idnode = &((retval)  # "Semaphore" ->ₛ "id"))) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : ((-1) <= msec_pre)) (PreH8 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH9 : ((-1) <= wait_time)) (PreH10 : (wait_time < KTICK_HALF_RANGE)) (PreH11 : (0 <= id_pre)) (PreH12 : (id_pre <= 65535)) (PreH13 : (task = 0)) (PreH14 : (sem = 0)) (PreH15 : (In original (os_semaphores (held)) )) (PreH16 : ((semaphore_id (original)) = id_pre)) (PreH17 : ((semaphore_addr (original)) <> 0)) (PreH18 : (0 <= (semaphore_value (original)))) (PreH19 : ((semaphore_value (original)) <= 65535)) (PreH20 : (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id"))) (PreH21 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH22 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (0)) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ ((semaphore_addr (original)) = (semaphore_addr (original))) ”
  &&  “ (0 = 0) ”
  &&  “ ((semaphore_value (original)) <= 0) ”
  &&  “ ((semaphore_value (original)) = 0) ”
  &&  “ (retval = (semaphore_addr (original))) ”
  &&  “ (idnode = &((retval)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ ((-1) <= wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ (task = 0) ”
  &&  “ (sem = 0) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_addr (original)) <> 0) ”
  &&  “ (0 <= (semaphore_value (original))) ”
  &&  “ ((semaphore_value (original)) <= 65535) ”
  &&  “ (idnode = &(((semaphore_addr (original)))  # "Semaphore" ->ₛ "id")) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  ((&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (wand (store_ushort (&(((semaphore_addr (original)))  # "Semaphore" ->ₛ "value")) (0)) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
.

Definition _SemaphoreObtain_partial_solve_wit_13 := _SemaphoreObtain_partial_solve_wit_13_pure -> _SemaphoreObtain_partial_solve_wit_13_aux.

Definition _SemaphoreObtain_partial_solve_wit_14_pure :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = 0)) (PreH5 : (task = 0)) (PreH6 : (sem = (semaphore_addr (original)))) (PreH7 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-2))) X_semaphore_obtain_oc )) (PreH9 : (Crtos_GTrans held held )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc held )
|--
  “ (Crtos_GTrans held held ) ”
.

Definition _SemaphoreObtain_partial_solve_wit_14_aux :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = 0)) (PreH5 : (task = 0)) (PreH6 : (sem = (semaphore_addr (original)))) (PreH7 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-2))) X_semaphore_obtain_oc )) (PreH9 : (Crtos_GTrans held held )),
  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc held )
|--
  “ (Crtos_GTrans held held ) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = 0) ”
  &&  “ (task = 0) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (held)) ( MonadErr.ret  ((-2))) X_semaphore_obtain_oc ) ”
  &&  “ (Crtos_GTrans held held ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc held )
.

Definition _SemaphoreObtain_partial_solve_wit_14 := _SemaphoreObtain_partial_solve_wit_14_pure -> _SemaphoreObtain_partial_solve_wit_14_aux.

Definition _SemaphoreObtain_partial_solve_wit_15 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : (wait_time <> 0)) (PreH6 : ((-1) <= wait_time)) (PreH7 : (wait_time < KTICK_HALF_RANGE)) (PreH8 : (task = 0)) (PreH9 : (sem = (semaphore_addr (original)))) (PreH10 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH11 : (In original (os_semaphores (held)) )) (PreH12 : ((semaphore_id (original)) = id_pre)) (PreH13 : ((semaphore_value (original)) = 0)) (PreH14 : (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held )) (PreH15 : forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < wait_time) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) ))))))) (PreH16 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc held )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (wait_time <> 0) ”
  &&  “ ((-1) <= wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (task = 0) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_value (original)) = 0) ”
  &&  “ (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held ) ”
  &&  “ forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < wait_time) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) )))))) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  (os_inv sg_semaphore_obtain_oc held )
  **  (InsideCritical sg_semaphore_obtain_oc held )
.

Definition _SemaphoreObtain_partial_solve_wit_16 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : (wait_time <> 0)) (PreH6 : ((-1) <= wait_time)) (PreH7 : (wait_time < KTICK_HALF_RANGE)) (PreH8 : (task = 0)) (PreH9 : (sem = (semaphore_addr (original)))) (PreH10 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH11 : (In original (os_semaphores (held)) )) (PreH12 : ((semaphore_id (original)) = id_pre)) (PreH13 : ((semaphore_value (original)) = 0)) (PreH14 : (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held )) (PreH15 : forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < wait_time) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) ))))))) (PreH16 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&(( &( "Assign" ) )->ₛ "os_running_task")) # Ptr  |-> (assignRunningTask ((os_assign (held)))))
  **  (wand (store_ptr (&(( &( "Assign" ) )->ₛ "os_running_task")) ((assignRunningTask ((os_assign (held)))))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (wait_time <> 0) ”
  &&  “ ((-1) <= wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (task = 0) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_value (original)) = 0) ”
  &&  “ (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held ) ”
  &&  “ forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < wait_time) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) )))))) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  ((&(( &( "Assign" ) )->ₛ "os_running_task")) # Ptr  |-> (assignRunningTask ((os_assign (held)))))
  **  (wand (store_ptr (&(( &( "Assign" ) )->ₛ "os_running_task")) ((assignRunningTask ((os_assign (held)))))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
.

Definition _SemaphoreObtain_partial_solve_wit_17_pure :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (retval: Z) (PreH1 : (retval = (assignRunningTask ((os_assign (held)))))) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre <= 65535)) (PreH4 : ((-1) <= msec_pre)) (PreH5 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH6 : (wait_time <> 0)) (PreH7 : ((-1) <= wait_time)) (PreH8 : (wait_time < KTICK_HALF_RANGE)) (PreH9 : (task = 0)) (PreH10 : (sem = (semaphore_addr (original)))) (PreH11 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH12 : (In original (os_semaphores (held)) )) (PreH13 : ((semaphore_id (original)) = id_pre)) (PreH14 : ((semaphore_value (original)) = 0)) (PreH15 : (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held )) (PreH16 : forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < wait_time) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) ))))))) (PreH17 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&(( &( "Assign" ) )->ₛ "os_running_task")) # Ptr  |-> (assignRunningTask ((os_assign (held)))))
  **  (wand (store_ptr (&(( &( "Assign" ) )->ₛ "os_running_task")) ((assignRunningTask ((os_assign (held)))))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> retval)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ ((assignRunningTask ((os_assign (held)))) = (assignRunningTask ((os_assign (held))))) ”
.

Definition _SemaphoreObtain_partial_solve_wit_17_aux :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (retval: Z) (PreH1 : (retval = (assignRunningTask ((os_assign (held)))))) (PreH2 : (0 <= id_pre)) (PreH3 : (id_pre <= 65535)) (PreH4 : ((-1) <= msec_pre)) (PreH5 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH6 : (wait_time <> 0)) (PreH7 : ((-1) <= wait_time)) (PreH8 : (wait_time < KTICK_HALF_RANGE)) (PreH9 : (task = 0)) (PreH10 : (sem = (semaphore_addr (original)))) (PreH11 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH12 : (In original (os_semaphores (held)) )) (PreH13 : ((semaphore_id (original)) = id_pre)) (PreH14 : ((semaphore_value (original)) = 0)) (PreH15 : (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held )) (PreH16 : forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < wait_time) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) ))))))) (PreH17 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&(( &( "Assign" ) )->ₛ "os_running_task")) # Ptr  |-> (assignRunningTask ((os_assign (held)))))
  **  (wand (store_ptr (&(( &( "Assign" ) )->ₛ "os_running_task")) ((assignRunningTask ((os_assign (held)))))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  ((( &( "task" ) )) # Ptr  |-> retval)
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ ((assignRunningTask ((os_assign (held)))) = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (retval = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (wait_time <> 0) ”
  &&  “ ((-1) <= wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (task = 0) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_value (original)) = 0) ”
  &&  “ (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held ) ”
  &&  “ forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < wait_time) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) )))))) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  ((( &( "task" ) )) # Ptr  |-> (assignRunningTask ((os_assign (held)))))
  **  ((&(( &( "Assign" ) )->ₛ "os_running_task")) # Ptr  |-> (assignRunningTask ((os_assign (held)))))
  **  (wand (store_ptr (&(( &( "Assign" ) )->ₛ "os_running_task")) ((assignRunningTask ((os_assign (held)))))) (os_inv (sg_semaphore_obtain_oc) (held)) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
.

Definition _SemaphoreObtain_partial_solve_wit_17 := _SemaphoreObtain_partial_solve_wit_17_pure -> _SemaphoreObtain_partial_solve_wit_17_aux.

Definition _SemaphoreObtain_partial_solve_wit_18 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (desc: TaskDescriptorAbs) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : (wait_time <> 0)) (PreH6 : ((-1) <= wait_time)) (PreH7 : (wait_time < KTICK_HALF_RANGE)) (PreH8 : (task = (assignRunningTask ((os_assign (held)))))) (PreH9 : (task <> 0)) (PreH10 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH11 : (sem = (semaphore_addr (original)))) (PreH12 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH13 : (In original (os_semaphores (held)) )) (PreH14 : ((semaphore_id (original)) = id_pre)) (PreH15 : ((semaphore_value (original)) = 0)) (PreH16 : (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held )) (PreH17 : forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < wait_time) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) ))))))) (PreH18 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (InsideCritical sg_semaphore_obtain_oc held )
  **  ((&((task)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (desc.(tdExstatus) ))
  **  (wand (store_int (&((task)  # "TaskDescriptor" ->ₛ "exstatus")) (0)) (os_inv (sg_semaphore_obtain_oc) ((semaphore_clear_status (task) (desc) (held)))) )
|--
  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (wait_time <> 0) ”
  &&  “ ((-1) <= wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (task <> 0) ”
  &&  “ ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc))) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_value (original)) = 0) ”
  &&  “ (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held ) ”
  &&  “ forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < wait_time) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) )))))) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  ((&((task)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (desc.(tdExstatus) ))
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (wand (store_int (&((task)  # "TaskDescriptor" ->ₛ "exstatus")) (0)) (os_inv (sg_semaphore_obtain_oc) ((semaphore_clear_status (task) (desc) (held)))) )
.

Definition _SemaphoreObtain_partial_solve_wit_19_pure :=
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : (wait_time <> 0)) (PreH6 : ((-1) <= wait_time)) (PreH7 : (wait_time < KTICK_HALF_RANGE)) (PreH8 : (task = (assignRunningTask ((os_assign (held)))))) (PreH9 : (task <> 0)) (PreH10 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH11 : (sem = (semaphore_addr (original)))) (PreH12 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH13 : (In original (os_semaphores (held)) )) (PreH14 : ((semaphore_id (original)) = id_pre)) (PreH15 : ((semaphore_value (original)) = 0)) (PreH16 : (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held )) (PreH17 : forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < wait_time) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) ))))))) (PreH18 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )) (PreH20 : (semaphore_pending_nodes sem (semaphore_clear_status (task) (desc) (held)) (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH21 : (linklist_suspend_admissible task 1 (semaphore_clear_status (task) (desc) (held)) )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc (semaphore_clear_status (task) (desc) (held)) )
|--
  “ (1 = 1) ”
  &&  “ (semaphore_pending_nodes sem (semaphore_clear_status (task) (desc) (held)) (map (sched_link_node) ((semaphore_pending_addrs (original)))) ) ”
  &&  “ (linklist_suspend_admissible task 1 (semaphore_clear_status (task) (desc) (held)) ) ”
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") = (semaphore_pending_head (sem))) ”
) \/
(
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (PreH1 : (wait_time <= INT_MAX)) (PreH2 : (saved <= INT_MAX)) (PreH3 : (msec_pre <= INT_MAX)) (PreH4 : (id_pre <= INT_MAX)) (PreH5 : (wait_time >= INT_MIN)) (PreH6 : (saved >= INT_MIN)) (PreH7 : (msec_pre >= INT_MIN)) (PreH8 : (id_pre >= INT_MIN)) (PreH9 : (0 <= id_pre)) (PreH10 : (id_pre <= 65535)) (PreH11 : ((-1) <= msec_pre)) (PreH12 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH13 : (wait_time <> 0)) (PreH14 : ((-1) <= wait_time)) (PreH15 : (wait_time < KTICK_HALF_RANGE)) (PreH16 : (task = (assignRunningTask ((os_assign (held)))))) (PreH17 : (task <> 0)) (PreH18 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH19 : (sem = (semaphore_addr (original)))) (PreH20 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH21 : (In original (os_semaphores (held)) )) (PreH22 : ((semaphore_id (original)) = id_pre)) (PreH23 : ((semaphore_value (original)) = 0)) (PreH24 : (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held )) (PreH25 : forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < wait_time) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) ))))))) (PreH26 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH27 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )) (PreH28 : (semaphore_pending_nodes sem (semaphore_clear_status (task) (desc) (held)) (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH29 : (linklist_suspend_admissible task 1 (semaphore_clear_status (task) (desc) (held)) )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc (semaphore_clear_status (task) (desc) (held)) )
|--
  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") = (semaphore_pending_head (sem))) ”
).

Definition _SemaphoreObtain_partial_solve_wit_19_pure_split_goal_1 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (PreH1 : (wait_time <= INT_MAX)) (PreH2 : (saved <= INT_MAX)) (PreH3 : (msec_pre <= INT_MAX)) (PreH4 : (id_pre <= INT_MAX)) (PreH5 : (wait_time >= INT_MIN)) (PreH6 : (saved >= INT_MIN)) (PreH7 : (msec_pre >= INT_MIN)) (PreH8 : (id_pre >= INT_MIN)) (PreH9 : (0 <= id_pre)) (PreH10 : (id_pre <= 65535)) (PreH11 : ((-1) <= msec_pre)) (PreH12 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH13 : (wait_time <> 0)) (PreH14 : ((-1) <= wait_time)) (PreH15 : (wait_time < KTICK_HALF_RANGE)) (PreH16 : (task = (assignRunningTask ((os_assign (held)))))) (PreH17 : (task <> 0)) (PreH18 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH19 : (sem = (semaphore_addr (original)))) (PreH20 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH21 : (In original (os_semaphores (held)) )) (PreH22 : ((semaphore_id (original)) = id_pre)) (PreH23 : ((semaphore_value (original)) = 0)) (PreH24 : (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held )) (PreH25 : forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < wait_time) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) ))))))) (PreH26 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH27 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )) (PreH28 : (semaphore_pending_nodes sem (semaphore_clear_status (task) (desc) (held)) (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH29 : (linklist_suspend_admissible task 1 (semaphore_clear_status (task) (desc) (held)) )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc (semaphore_clear_status (task) (desc) (held)) )
|--
  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") = (semaphore_pending_head (sem))) ”
.

Definition _SemaphoreObtain_partial_solve_wit_19_aux :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : (wait_time <> 0)) (PreH6 : ((-1) <= wait_time)) (PreH7 : (wait_time < KTICK_HALF_RANGE)) (PreH8 : (task = (assignRunningTask ((os_assign (held)))))) (PreH9 : (task <> 0)) (PreH10 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH11 : (sem = (semaphore_addr (original)))) (PreH12 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH13 : (In original (os_semaphores (held)) )) (PreH14 : ((semaphore_id (original)) = id_pre)) (PreH15 : ((semaphore_value (original)) = 0)) (PreH16 : (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held )) (PreH17 : forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < wait_time) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) ))))))) (PreH18 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )) (PreH20 : (semaphore_pending_nodes sem (semaphore_clear_status (task) (desc) (held)) (map (sched_link_node) ((semaphore_pending_addrs (original)))) )) (PreH21 : (linklist_suspend_admissible task 1 (semaphore_clear_status (task) (desc) (held)) )),
  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc (semaphore_clear_status (task) (desc) (held)) )
|--
  “ (1 = 1) ”
  &&  “ (semaphore_pending_nodes sem (semaphore_clear_status (task) (desc) (held)) (map (sched_link_node) ((semaphore_pending_addrs (original)))) ) ”
  &&  “ (linklist_suspend_admissible task 1 (semaphore_clear_status (task) (desc) (held)) ) ”
  &&  “ (&((sem)  # "Semaphore" ->ₛ "pend_list") = (semaphore_pending_head (sem))) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (wait_time <> 0) ”
  &&  “ ((-1) <= wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (task <> 0) ”
  &&  “ ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc))) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_value (original)) = 0) ”
  &&  “ (linklist_suspend_admissible (assignRunningTask ((os_assign (held)))) 1 held ) ”
  &&  “ forall (entry_desc: TaskDescriptorAbs), forall (entry_suspended: VarGlobalState), forall (entry_sd: TaskDescriptorAbs), (((task_desc_map ((os_tasks (held))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_desc))) -> ((linklist_suspend_prio (semaphore_addr (original)) (assignRunningTask ((os_assign (held)))) (semaphore_clear_status ((assignRunningTask ((os_assign (held))))) (entry_desc) (held)) entry_suspended ) -> (((task_desc_map ((os_tasks (entry_suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (entry_sd))) -> ((0 < wait_time) -> ((((entry_sd.(tdDelay) ) = 0) \/ (((entry_suspended.(os_delays) ).(delay_inactive_map) ((entry_sd.(tdDelay) ))) <> None)) /\ (delay_list_window (os_tick (entry_suspended)) ((entry_suspended.(os_delays) ).(delay_active_nodes) ) )))))) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  “ (semaphore_pending_nodes sem (semaphore_clear_status (task) (desc) (held)) (map (sched_link_node) ((semaphore_pending_addrs (original)))) ) ”
  &&  “ (linklist_suspend_admissible task 1 (semaphore_clear_status (task) (desc) (held)) ) ”
  &&  (os_inv sg_semaphore_obtain_oc (semaphore_clear_status (task) (desc) (held)) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
.

Definition _SemaphoreObtain_partial_solve_wit_19 := _SemaphoreObtain_partial_solve_wit_19_pure -> _SemaphoreObtain_partial_solve_wit_19_aux.

Definition _SemaphoreObtain_partial_solve_wit_20_pure :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (delay_frame: Assertion) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : (0 < wait_time)) (PreH6 : (wait_time < KTICK_HALF_RANGE)) (PreH7 : (task = (assignRunningTask ((os_assign (held)))))) (PreH8 : (task <> 0)) (PreH9 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH10 : (sem = (semaphore_addr (original)))) (PreH11 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH12 : (In original (os_semaphores (held)) )) (PreH13 : ((semaphore_id (original)) = id_pre)) (PreH14 : ((semaphore_value (original)) = 0)) (PreH15 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH16 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH17 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH18 : (((suspended.(os_delays) ).(delay_inactive_map) ((sd.(tdDelay) ))) <> None)) (PreH19 : (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) )) (PreH20 : (os_global_context sg_semaphore_obtain_oc )) (PreH21 : forall (delayed: VarGlobalState), forall (dp: Z), forall (rc: Z), ((ktask_set_delay_step task sd wait_time dp suspended rc delayed ) -> (derivable1 (sepcon ((store_ptr (&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) (dp))) ((sepcon ((delay_inv (sg_semaphore_obtain_oc) (delayed))) ((sepcon ((tick_inv (sg_semaphore_obtain_oc) (delayed))) (delay_frame)))))) (os_inv (sg_semaphore_obtain_oc) (delayed)) ))) (PreH22 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH23 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  ((&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) # Ptr  |-> (sd.(tdDelay) ))
  **  (delay_inv sg_semaphore_obtain_oc suspended )
  **  (tick_inv sg_semaphore_obtain_oc suspended )
  **  (andp (coq_prop ((os_global_context (sg_semaphore_obtain_oc)))) delay_frame )
|--
  “ (0 <= wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (((suspended.(os_tasks) ).(task_desc_map) (task)) = (Some (sd))) ”
  &&  “ (os_global_context sg_semaphore_obtain_oc ) ”
  &&  “ (((sd.(tdDelay) ) <> 0) -> (((suspended.(os_delays) ).(delay_inactive_map) ((sd.(tdDelay) ))) <> None)) ”
  &&  “ (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) ) ”
.

Definition _SemaphoreObtain_partial_solve_wit_20_aux :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (delay_frame: Assertion) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : (0 < wait_time)) (PreH6 : (wait_time < KTICK_HALF_RANGE)) (PreH7 : (task = (assignRunningTask ((os_assign (held)))))) (PreH8 : (task <> 0)) (PreH9 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH10 : (sem = (semaphore_addr (original)))) (PreH11 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH12 : (In original (os_semaphores (held)) )) (PreH13 : ((semaphore_id (original)) = id_pre)) (PreH14 : ((semaphore_value (original)) = 0)) (PreH15 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH16 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH17 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH18 : (((suspended.(os_delays) ).(delay_inactive_map) ((sd.(tdDelay) ))) <> None)) (PreH19 : (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) )) (PreH20 : (os_global_context sg_semaphore_obtain_oc )) (PreH21 : forall (delayed: VarGlobalState), forall (dp: Z), forall (rc: Z), ((ktask_set_delay_step task sd wait_time dp suspended rc delayed ) -> (derivable1 (sepcon ((store_ptr (&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) (dp))) ((sepcon ((delay_inv (sg_semaphore_obtain_oc) (delayed))) ((sepcon ((tick_inv (sg_semaphore_obtain_oc) (delayed))) (delay_frame)))))) (os_inv (sg_semaphore_obtain_oc) (delayed)) ))) (PreH22 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH23 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (InsideCritical sg_semaphore_obtain_oc held )
  **  ((&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) # Ptr  |-> (sd.(tdDelay) ))
  **  (delay_inv sg_semaphore_obtain_oc suspended )
  **  (tick_inv sg_semaphore_obtain_oc suspended )
  **  (andp (coq_prop ((os_global_context (sg_semaphore_obtain_oc)))) delay_frame )
|--
  “ (0 <= wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (((suspended.(os_tasks) ).(task_desc_map) (task)) = (Some (sd))) ”
  &&  “ (os_global_context sg_semaphore_obtain_oc ) ”
  &&  “ (((sd.(tdDelay) ) <> 0) -> (((suspended.(os_delays) ).(delay_inactive_map) ((sd.(tdDelay) ))) <> None)) ”
  &&  “ (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) ) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (0 < wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (task <> 0) ”
  &&  “ ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc))) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_value (original)) = 0) ”
  &&  “ (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended ) ”
  &&  “ ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd))) ”
  &&  “ (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (((suspended.(os_delays) ).(delay_inactive_map) ((sd.(tdDelay) ))) <> None) ”
  &&  “ (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) ) ”
  &&  “ (os_global_context sg_semaphore_obtain_oc ) ”
  &&  “ forall (delayed: VarGlobalState), forall (dp: Z), forall (rc: Z), ((ktask_set_delay_step task sd wait_time dp suspended rc delayed ) -> (derivable1 (sepcon ((store_ptr (&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) (dp))) ((sepcon ((delay_inv (sg_semaphore_obtain_oc) (delayed))) ((sepcon ((tick_inv (sg_semaphore_obtain_oc) (delayed))) (delay_frame)))))) (os_inv (sg_semaphore_obtain_oc) (delayed)) )) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  ((&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) # Ptr  |-> (sd.(tdDelay) ))
  **  (delay_inv sg_semaphore_obtain_oc suspended )
  **  (tick_inv sg_semaphore_obtain_oc suspended )
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (andp (coq_prop ((os_global_context (sg_semaphore_obtain_oc)))) delay_frame )
.

Definition _SemaphoreObtain_partial_solve_wit_20 := _SemaphoreObtain_partial_solve_wit_20_pure -> _SemaphoreObtain_partial_solve_wit_20_aux.

Definition _SemaphoreObtain_partial_solve_wit_21_pure :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (delay_frame: Assertion) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : (0 < wait_time)) (PreH6 : (wait_time < KTICK_HALF_RANGE)) (PreH7 : (task = (assignRunningTask ((os_assign (held)))))) (PreH8 : (task <> 0)) (PreH9 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH10 : (sem = (semaphore_addr (original)))) (PreH11 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH12 : (In original (os_semaphores (held)) )) (PreH13 : ((semaphore_id (original)) = id_pre)) (PreH14 : ((semaphore_value (original)) = 0)) (PreH15 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH16 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH17 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH18 : ((sd.(tdDelay) ) = 0)) (PreH19 : (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) )) (PreH20 : (os_global_context sg_semaphore_obtain_oc )) (PreH21 : forall (delayed: VarGlobalState), forall (dp: Z), forall (rc: Z), ((ktask_set_delay_step task sd wait_time dp suspended rc delayed ) -> (derivable1 (sepcon ((store_ptr (&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) (dp))) ((sepcon ((delay_inv (sg_semaphore_obtain_oc) (delayed))) ((sepcon ((tick_inv (sg_semaphore_obtain_oc) (delayed))) (delay_frame)))))) (os_inv (sg_semaphore_obtain_oc) (delayed)) ))) (PreH22 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH23 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  ((&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) # Ptr  |-> (sd.(tdDelay) ))
  **  (delay_inv sg_semaphore_obtain_oc suspended )
  **  (tick_inv sg_semaphore_obtain_oc suspended )
  **  (andp (coq_prop ((os_global_context (sg_semaphore_obtain_oc)))) delay_frame )
|--
  “ (0 <= wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (((suspended.(os_tasks) ).(task_desc_map) (task)) = (Some (sd))) ”
  &&  “ (os_global_context sg_semaphore_obtain_oc ) ”
  &&  “ (((sd.(tdDelay) ) <> 0) -> (((suspended.(os_delays) ).(delay_inactive_map) ((sd.(tdDelay) ))) <> None)) ”
  &&  “ (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) ) ”
.

Definition _SemaphoreObtain_partial_solve_wit_21_aux :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (delay_frame: Assertion) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : (0 < wait_time)) (PreH6 : (wait_time < KTICK_HALF_RANGE)) (PreH7 : (task = (assignRunningTask ((os_assign (held)))))) (PreH8 : (task <> 0)) (PreH9 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH10 : (sem = (semaphore_addr (original)))) (PreH11 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH12 : (In original (os_semaphores (held)) )) (PreH13 : ((semaphore_id (original)) = id_pre)) (PreH14 : ((semaphore_value (original)) = 0)) (PreH15 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH16 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH17 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH18 : ((sd.(tdDelay) ) = 0)) (PreH19 : (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) )) (PreH20 : (os_global_context sg_semaphore_obtain_oc )) (PreH21 : forall (delayed: VarGlobalState), forall (dp: Z), forall (rc: Z), ((ktask_set_delay_step task sd wait_time dp suspended rc delayed ) -> (derivable1 (sepcon ((store_ptr (&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) (dp))) ((sepcon ((delay_inv (sg_semaphore_obtain_oc) (delayed))) ((sepcon ((tick_inv (sg_semaphore_obtain_oc) (delayed))) (delay_frame)))))) (os_inv (sg_semaphore_obtain_oc) (delayed)) ))) (PreH22 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH23 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (InsideCritical sg_semaphore_obtain_oc held )
  **  ((&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) # Ptr  |-> (sd.(tdDelay) ))
  **  (delay_inv sg_semaphore_obtain_oc suspended )
  **  (tick_inv sg_semaphore_obtain_oc suspended )
  **  (andp (coq_prop ((os_global_context (sg_semaphore_obtain_oc)))) delay_frame )
|--
  “ (0 <= wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (((suspended.(os_tasks) ).(task_desc_map) (task)) = (Some (sd))) ”
  &&  “ (os_global_context sg_semaphore_obtain_oc ) ”
  &&  “ (((sd.(tdDelay) ) <> 0) -> (((suspended.(os_delays) ).(delay_inactive_map) ((sd.(tdDelay) ))) <> None)) ”
  &&  “ (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) ) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (0 < wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (task <> 0) ”
  &&  “ ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc))) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_value (original)) = 0) ”
  &&  “ (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended ) ”
  &&  “ ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd))) ”
  &&  “ (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ ((sd.(tdDelay) ) = 0) ”
  &&  “ (delay_list_window (os_tick (suspended)) ((suspended.(os_delays) ).(delay_active_nodes) ) ) ”
  &&  “ (os_global_context sg_semaphore_obtain_oc ) ”
  &&  “ forall (delayed: VarGlobalState), forall (dp: Z), forall (rc: Z), ((ktask_set_delay_step task sd wait_time dp suspended rc delayed ) -> (derivable1 (sepcon ((store_ptr (&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) (dp))) ((sepcon ((delay_inv (sg_semaphore_obtain_oc) (delayed))) ((sepcon ((tick_inv (sg_semaphore_obtain_oc) (delayed))) (delay_frame)))))) (os_inv (sg_semaphore_obtain_oc) (delayed)) )) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  ((&((task)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "delay")) # Ptr  |-> (sd.(tdDelay) ))
  **  (delay_inv sg_semaphore_obtain_oc suspended )
  **  (tick_inv sg_semaphore_obtain_oc suspended )
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (andp (coq_prop ((os_global_context (sg_semaphore_obtain_oc)))) delay_frame )
.

Definition _SemaphoreObtain_partial_solve_wit_21 := _SemaphoreObtain_partial_solve_wit_21_pure -> _SemaphoreObtain_partial_solve_wit_21_aux.

Definition _SemaphoreObtain_partial_solve_wit_22_pure :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : (0 < wait_time)) (PreH6 : (wait_time < KTICK_HALF_RANGE)) (PreH7 : (task = (assignRunningTask ((os_assign (held)))))) (PreH8 : (task <> 0)) (PreH9 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH10 : (sem = (semaphore_addr (original)))) (PreH11 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH12 : (In original (os_semaphores (held)) )) (PreH13 : ((semaphore_id (original)) = id_pre)) (PreH14 : ((semaphore_value (original)) = 0)) (PreH15 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH16 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH17 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH18 : (ktask_set_delay_step task sd wait_time 0 suspended (-5) suspended )) (PreH19 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc suspended )
|--
  “ ((assignRunningTask ((os_assign (held)))) = (assignRunningTask ((os_assign (held))))) ”
  &&  “ ((task_desc_map ((os_tasks (suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (sd))) ”
.

Definition _SemaphoreObtain_partial_solve_wit_22_aux :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (PreH1 : (0 <= id_pre)) (PreH2 : (id_pre <= 65535)) (PreH3 : ((-1) <= msec_pre)) (PreH4 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH5 : (0 < wait_time)) (PreH6 : (wait_time < KTICK_HALF_RANGE)) (PreH7 : (task = (assignRunningTask ((os_assign (held)))))) (PreH8 : (task <> 0)) (PreH9 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH10 : (sem = (semaphore_addr (original)))) (PreH11 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH12 : (In original (os_semaphores (held)) )) (PreH13 : ((semaphore_id (original)) = id_pre)) (PreH14 : ((semaphore_value (original)) = 0)) (PreH15 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH16 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH17 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH18 : (ktask_set_delay_step task sd wait_time 0 suspended (-5) suspended )) (PreH19 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "task" ) )) # Ptr  |-> task)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc suspended )
|--
  “ ((assignRunningTask ((os_assign (held)))) = (assignRunningTask ((os_assign (held))))) ”
  &&  “ ((task_desc_map ((os_tasks (suspended))) ((assignRunningTask ((os_assign (held)))))) = (Some (sd))) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (0 < wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (task <> 0) ”
  &&  “ ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc))) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_value (original)) = 0) ”
  &&  “ (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended ) ”
  &&  “ ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd))) ”
  &&  “ (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (ktask_set_delay_step task sd wait_time 0 suspended (-5) suspended ) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  ((( &( "task" ) )) # Ptr  |-> (assignRunningTask ((os_assign (held)))))
  **  (os_inv sg_semaphore_obtain_oc suspended )
  **  (InsideCritical sg_semaphore_obtain_oc held )
.

Definition _SemaphoreObtain_partial_solve_wit_22 := _SemaphoreObtain_partial_solve_wit_22_pure -> _SemaphoreObtain_partial_solve_wit_22_aux.

Definition _SemaphoreObtain_partial_solve_wit_23_pure :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (rollback_id: Z) (PreH1 : ((assignRunningTask ((os_assign (held)))) = (assignRunningTask ((os_assign (held)))))) (PreH2 : (0 <= rollback_id)) (PreH3 : (rollback_id < 65536)) (PreH4 : (get_task_with_idnode_success sg_semaphore_obtain_oc suspended rollback_id (assignRunningTask ((os_assign (held)))) )) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : ((-1) <= msec_pre)) (PreH8 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH9 : (0 < wait_time)) (PreH10 : (wait_time < KTICK_HALF_RANGE)) (PreH11 : (task = (assignRunningTask ((os_assign (held)))))) (PreH12 : (task <> 0)) (PreH13 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH14 : (sem = (semaphore_addr (original)))) (PreH15 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH16 : (In original (os_semaphores (held)) )) (PreH17 : ((semaphore_id (original)) = id_pre)) (PreH18 : ((semaphore_value (original)) = 0)) (PreH19 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH20 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH21 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH22 : (ktask_set_delay_step task sd wait_time 0 suspended (-5) suspended )) (PreH23 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH24 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "wakeup_id" ) )) # Int  |-> rollback_id)
  **  ((( &( "task" ) )) # Ptr  |-> (assignRunningTask ((os_assign (held)))))
  **  ((&(((assignRunningTask ((os_assign (held)))))  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> rollback_id)
  **  (wand (store_ushort (&(((assignRunningTask ((os_assign (held)))))  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (rollback_id)) (os_inv (sg_semaphore_obtain_oc) (suspended)) )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ ((assignRunningTask ((os_assign (held)))) = (assignRunningTask ((os_assign (held))))) ”
.

Definition _SemaphoreObtain_partial_solve_wit_23_aux :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (rollback_id: Z) (PreH1 : ((assignRunningTask ((os_assign (held)))) = (assignRunningTask ((os_assign (held)))))) (PreH2 : (0 <= rollback_id)) (PreH3 : (rollback_id < 65536)) (PreH4 : (get_task_with_idnode_success sg_semaphore_obtain_oc suspended rollback_id (assignRunningTask ((os_assign (held)))) )) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : ((-1) <= msec_pre)) (PreH8 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH9 : (0 < wait_time)) (PreH10 : (wait_time < KTICK_HALF_RANGE)) (PreH11 : (task = (assignRunningTask ((os_assign (held)))))) (PreH12 : (task <> 0)) (PreH13 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH14 : (sem = (semaphore_addr (original)))) (PreH15 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH16 : (In original (os_semaphores (held)) )) (PreH17 : ((semaphore_id (original)) = id_pre)) (PreH18 : ((semaphore_value (original)) = 0)) (PreH19 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH20 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH21 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH22 : (ktask_set_delay_step task sd wait_time 0 suspended (-5) suspended )) (PreH23 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH24 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((&(((assignRunningTask ((os_assign (held)))))  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> rollback_id)
  **  (wand (store_ushort (&(((assignRunningTask ((os_assign (held)))))  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (rollback_id)) (os_inv (sg_semaphore_obtain_oc) (suspended)) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ ((assignRunningTask ((os_assign (held)))) = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (0 <= rollback_id) ”
  &&  “ (rollback_id < 65536) ”
  &&  “ (get_task_with_idnode_success sg_semaphore_obtain_oc suspended rollback_id (assignRunningTask ((os_assign (held)))) ) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (0 < wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (task <> 0) ”
  &&  “ ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc))) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_value (original)) = 0) ”
  &&  “ (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended ) ”
  &&  “ ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd))) ”
  &&  “ (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (ktask_set_delay_step task sd wait_time 0 suspended (-5) suspended ) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  ((&(((assignRunningTask ((os_assign (held)))))  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> rollback_id)
  **  (wand (store_ushort (&(((assignRunningTask ((os_assign (held)))))  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (rollback_id)) (os_inv (sg_semaphore_obtain_oc) (suspended)) )
  **  (InsideCritical sg_semaphore_obtain_oc held )
.

Definition _SemaphoreObtain_partial_solve_wit_23 := _SemaphoreObtain_partial_solve_wit_23_pure -> _SemaphoreObtain_partial_solve_wit_23_aux.

Definition _SemaphoreObtain_partial_solve_wit_24_pure :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (rollback_id: Z) (PreH1 : ((assignRunningTask ((os_assign (held)))) = (assignRunningTask ((os_assign (held)))))) (PreH2 : (0 <= rollback_id)) (PreH3 : (rollback_id < 65536)) (PreH4 : (get_task_with_idnode_success sg_semaphore_obtain_oc suspended rollback_id (assignRunningTask ((os_assign (held)))) )) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : ((-1) <= msec_pre)) (PreH8 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH9 : (0 < wait_time)) (PreH10 : (wait_time < KTICK_HALF_RANGE)) (PreH11 : (task = (assignRunningTask ((os_assign (held)))))) (PreH12 : (task <> 0)) (PreH13 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH14 : (sem = (semaphore_addr (original)))) (PreH15 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH16 : (In original (os_semaphores (held)) )) (PreH17 : ((semaphore_id (original)) = id_pre)) (PreH18 : ((semaphore_value (original)) = 0)) (PreH19 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH20 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH21 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH22 : (ktask_set_delay_step task sd wait_time 0 suspended (-5) suspended )) (PreH23 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH24 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  ((( &( "task" ) )) # Ptr  |-> (assignRunningTask ((os_assign (held)))))
  **  ((( &( "wakeup_id" ) )) # Int  |-> rollback_id)
  **  (os_inv sg_semaphore_obtain_oc suspended )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ (rollback_id < 65536) ”
.

Definition _SemaphoreObtain_partial_solve_wit_24_aux :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (before_semaphore_obtain_oc: VarGlobalState) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (desc: TaskDescriptorAbs) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (rollback_id: Z) (PreH1 : ((assignRunningTask ((os_assign (held)))) = (assignRunningTask ((os_assign (held)))))) (PreH2 : (0 <= rollback_id)) (PreH3 : (rollback_id < 65536)) (PreH4 : (get_task_with_idnode_success sg_semaphore_obtain_oc suspended rollback_id (assignRunningTask ((os_assign (held)))) )) (PreH5 : (0 <= id_pre)) (PreH6 : (id_pre <= 65535)) (PreH7 : ((-1) <= msec_pre)) (PreH8 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH9 : (0 < wait_time)) (PreH10 : (wait_time < KTICK_HALF_RANGE)) (PreH11 : (task = (assignRunningTask ((os_assign (held)))))) (PreH12 : (task <> 0)) (PreH13 : ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc)))) (PreH14 : (sem = (semaphore_addr (original)))) (PreH15 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH16 : (In original (os_semaphores (held)) )) (PreH17 : ((semaphore_id (original)) = id_pre)) (PreH18 : ((semaphore_value (original)) = 0)) (PreH19 : (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended )) (PreH20 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))) (PreH21 : (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH22 : (ktask_set_delay_step task sd wait_time 0 suspended (-5) suspended )) (PreH23 : (Crtos_RTrans before_semaphore_obtain_oc held )) (PreH24 : ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc )),
  (os_inv sg_semaphore_obtain_oc suspended )
  **  (InsideCritical sg_semaphore_obtain_oc held )
|--
  “ (rollback_id < 65536) ”
  &&  “ (0 <= rollback_id) ”
  &&  “ (rollback_id < 65536) ”
  &&  “ (get_task_with_idnode_success sg_semaphore_obtain_oc suspended rollback_id (assignRunningTask ((os_assign (held)))) ) ”
  &&  “ (0 <= id_pre) ”
  &&  “ (id_pre <= 65535) ”
  &&  “ ((-1) <= msec_pre) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (0 < wait_time) ”
  &&  “ (wait_time < KTICK_HALF_RANGE) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (task <> 0) ”
  &&  “ ((task_desc_map ((os_tasks (held))) (task)) = (Some (desc))) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (In original (os_semaphores (held)) ) ”
  &&  “ ((semaphore_id (original)) = id_pre) ”
  &&  “ ((semaphore_value (original)) = 0) ”
  &&  “ (linklist_suspend_prio sem task (semaphore_clear_status (task) (desc) (held)) suspended ) ”
  &&  “ ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd))) ”
  &&  “ (((sd.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ”
  &&  “ (ktask_set_delay_step task sd wait_time 0 suspended (-5) suspended ) ”
  &&  “ (Crtos_RTrans before_semaphore_obtain_oc held ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_semaphore_obtain_oc)) (abs_semaphore_obtain (sg_semaphore_obtain_oc) (id_pre) (msec_pre)) X_semaphore_obtain_oc ) ”
  &&  (os_inv sg_semaphore_obtain_oc suspended )
  **  (InsideCritical sg_semaphore_obtain_oc held )
.

Definition _SemaphoreObtain_partial_solve_wit_24 := _SemaphoreObtain_partial_solve_wit_24_pure -> _SemaphoreObtain_partial_solve_wit_24_aux.

Definition _SemaphoreObtain_partial_solve_wit_25_pure :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (rollback_id: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (after_wakeup: VarGlobalState) (PreH1 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH2 : (task = (assignRunningTask ((os_assign (held)))))) (PreH3 : (sem = (semaphore_addr (original)))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (after_wakeup)) ( MonadErr.ret  ((-5))) X_semaphore_obtain_oc )) (PreH6 : (Crtos_GTrans held after_wakeup )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "wakeup_id" ) )) # Int  |-> rollback_id)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc after_wakeup )
|--
  “ (Crtos_GTrans held after_wakeup ) ”
.

Definition _SemaphoreObtain_partial_solve_wit_25_aux :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (after_wakeup: VarGlobalState) (PreH1 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH2 : (task = (assignRunningTask ((os_assign (held)))))) (PreH3 : (sem = (semaphore_addr (original)))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (after_wakeup)) ( MonadErr.ret  ((-5))) X_semaphore_obtain_oc )) (PreH6 : (Crtos_GTrans held after_wakeup )),
  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc after_wakeup )
|--
  “ (Crtos_GTrans held after_wakeup ) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after_wakeup)) ( MonadErr.ret  ((-5))) X_semaphore_obtain_oc ) ”
  &&  “ (Crtos_GTrans held after_wakeup ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc after_wakeup )
.

Definition _SemaphoreObtain_partial_solve_wit_25 := _SemaphoreObtain_partial_solve_wit_25_pure -> _SemaphoreObtain_partial_solve_wit_25_aux.

Definition _SemaphoreObtain_partial_solve_wit_26_pure :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (prepared: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (PreH1 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH2 : (task = (assignRunningTask ((os_assign (held)))))) (PreH3 : (task <> 0)) (PreH4 : (sem = (semaphore_addr (original)))) (PreH5 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (prepared)) abs_ktask_assign Y )) (PreH7 : forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc ))) (PreH8 : (Crtos_GTrans held prepared )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc prepared )
|--
  “ (Crtos_GTrans held prepared ) ”
.

Definition _SemaphoreObtain_partial_solve_wit_26_aux :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (prepared: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (PreH1 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH2 : (task = (assignRunningTask ((os_assign (held)))))) (PreH3 : (task <> 0)) (PreH4 : (sem = (semaphore_addr (original)))) (PreH5 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (prepared)) abs_ktask_assign Y )) (PreH7 : forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc ))) (PreH8 : (Crtos_GTrans held prepared )),
  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc prepared )
|--
  “ (Crtos_GTrans held prepared ) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (task <> 0) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (prepared)) abs_ktask_assign Y ) ”
  &&  “ forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc )) ”
  &&  “ (Crtos_GTrans held prepared ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc held )
  **  (os_inv sg_semaphore_obtain_oc prepared )
.

Definition _SemaphoreObtain_partial_solve_wit_26 := _SemaphoreObtain_partial_solve_wit_26_pure -> _SemaphoreObtain_partial_solve_wit_26_aux.

Definition _SemaphoreObtain_partial_solve_wit_27_pure :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (saved: Z) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (prepared: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (PreH1 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH2 : (task = (assignRunningTask ((os_assign (held)))))) (PreH3 : (task <> 0)) (PreH4 : (sem = (semaphore_addr (original)))) (PreH5 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (prepared)) abs_ktask_assign Y )) (PreH7 : forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc ))) (PreH8 : (Crtos_GTrans held prepared )),
  (OutsideCritical sg_semaphore_obtain_oc prepared )
  **  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (prepared)) abs_ktask_assign Y ) ”
.

Definition _SemaphoreObtain_partial_solve_wit_27_aux :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (prepared: VarGlobalState) (Y: (unit -> ((VarGlobalState -> Prop) -> Prop))) (PreH1 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH2 : (task = (assignRunningTask ((os_assign (held)))))) (PreH3 : (task <> 0)) (PreH4 : (sem = (semaphore_addr (original)))) (PreH5 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (prepared)) abs_ktask_assign Y )) (PreH7 : forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc ))) (PreH8 : (Crtos_GTrans held prepared )),
  (OutsideCritical sg_semaphore_obtain_oc prepared )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (prepared)) abs_ktask_assign Y ) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (task <> 0) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (prepared)) abs_ktask_assign Y ) ”
  &&  “ forall (st: VarGlobalState), (( monadesafe_lib.safeExec  (LastSeen (st)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  (LastSeen (st)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc )) ”
  &&  “ (Crtos_GTrans held prepared ) ”
  &&  (OutsideCritical sg_semaphore_obtain_oc prepared )
.

Definition _SemaphoreObtain_partial_solve_wit_27 := _SemaphoreObtain_partial_solve_wit_27_pure -> _SemaphoreObtain_partial_solve_wit_27_aux.

Definition _SemaphoreObtain_partial_solve_wit_28 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (scheduled: VarGlobalState) (PreH1 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH2 : (task = (assignRunningTask ((os_assign (held)))))) (PreH3 : (sem = (semaphore_addr (original)))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (scheduled)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc )),
  (OutsideCritical sg_semaphore_obtain_oc scheduled )
|--
  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (scheduled)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc ) ”
  &&  (OutsideCritical sg_semaphore_obtain_oc scheduled )
.

Definition _SemaphoreObtain_partial_solve_wit_29 :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (scheduled: VarGlobalState) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (observed: VarGlobalState) (status_desc: TaskDescriptorAbs) (PreH1 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH2 : (task = (assignRunningTask ((os_assign (held)))))) (PreH3 : (sem = (semaphore_addr (original)))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : (Crtos_RTrans scheduled observed )) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (scheduled)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc )) (PreH7 : ((task_desc_map ((os_tasks (observed))) (task)) = (Some (status_desc)))),
  (InsideCritical sg_semaphore_obtain_oc observed )
  **  ((&((task)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (status_desc.(tdExstatus) ))
  **  (wand (store_int (&((task)  # "TaskDescriptor" ->ₛ "exstatus")) ((status_desc.(tdExstatus) ))) (os_inv (sg_semaphore_obtain_oc) (observed)) )
|--
  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (Crtos_RTrans scheduled observed ) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (scheduled)) (semaphore_obtain_after_assign (sg_semaphore_obtain_oc) (task)) X_semaphore_obtain_oc ) ”
  &&  “ ((task_desc_map ((os_tasks (observed))) (task)) = (Some (status_desc))) ”
  &&  ((&((task)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (status_desc.(tdExstatus) ))
  **  (InsideCritical sg_semaphore_obtain_oc observed )
  **  (wand (store_int (&((task)  # "TaskDescriptor" ->ₛ "exstatus")) ((status_desc.(tdExstatus) ))) (os_inv (sg_semaphore_obtain_oc) (observed)) )
.

Definition _SemaphoreObtain_partial_solve_wit_30_pure :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (id_pre: Z) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (observed: VarGlobalState) (status_desc: TaskDescriptorAbs) (saved_status: Z) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (result: Z) (PreH1 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH2 : (task = (assignRunningTask ((os_assign (held)))))) (PreH3 : (sem = (semaphore_addr (original)))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : (result = (status_desc.(tdExstatus) ))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (observed)) ( MonadErr.ret  (result)) X_semaphore_obtain_oc )) (PreH7 : (Crtos_GTrans observed observed )),
  ((( &( "id" ) )) # Int  |-> id_pre)
  **  ((( &( "msec" ) )) # Int  |-> msec_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved_status)
  **  ((( &( "wait_time" ) )) # Int  |-> wait_time)
  **  ((( &( "task" ) )) # Ptr  |-> task)
  **  ((( &( "sem" ) )) # Ptr  |-> sem)
  **  ((( &( "idnode" ) )) # Ptr  |-> idnode)
  **  ((( &( "result" ) )) # Int  |-> result)
  **  (InsideCritical sg_semaphore_obtain_oc observed )
  **  (os_inv sg_semaphore_obtain_oc observed )
|--
  “ (Crtos_GTrans observed observed ) ”
.

Definition _SemaphoreObtain_partial_solve_wit_30_aux :=
forall (X_semaphore_obtain_oc: (Z -> ((VarGlobalState -> Prop) -> Prop))) (sg_semaphore_obtain_oc: StableGlobalState) (msec_pre: Z) (held: VarGlobalState) (original: SemaphoreAbs) (observed: VarGlobalState) (status_desc: TaskDescriptorAbs) (wait_time: Z) (task: Z) (sem: Z) (idnode: Z) (result: Z) (PreH1 : (wait_time = (semaphore_wait_ticks (msec_pre)))) (PreH2 : (task = (assignRunningTask ((os_assign (held)))))) (PreH3 : (sem = (semaphore_addr (original)))) (PreH4 : (idnode = &((sem)  # "Semaphore" ->ₛ "id"))) (PreH5 : (result = (status_desc.(tdExstatus) ))) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (observed)) ( MonadErr.ret  (result)) X_semaphore_obtain_oc )) (PreH7 : (Crtos_GTrans observed observed )),
  (InsideCritical sg_semaphore_obtain_oc observed )
  **  (os_inv sg_semaphore_obtain_oc observed )
|--
  “ (Crtos_GTrans observed observed ) ”
  &&  “ (wait_time = (semaphore_wait_ticks (msec_pre))) ”
  &&  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (sem = (semaphore_addr (original))) ”
  &&  “ (idnode = &((sem)  # "Semaphore" ->ₛ "id")) ”
  &&  “ (result = (status_desc.(tdExstatus) )) ”
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (observed)) ( MonadErr.ret  (result)) X_semaphore_obtain_oc ) ”
  &&  “ (Crtos_GTrans observed observed ) ”
  &&  (InsideCritical sg_semaphore_obtain_oc observed )
  **  (os_inv sg_semaphore_obtain_oc observed )
.

Definition _SemaphoreObtain_partial_solve_wit_30 := _SemaphoreObtain_partial_solve_wit_30_pure -> _SemaphoreObtain_partial_solve_wit_30_aux.

Definition _SemaphoreObtain_which_implies_wit_1 :=
(
forall (msec_pre: Z),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
|--
  “ ((INT_MIN) <= msec_pre) ”
  &&  “ (msec_pre <= INT_MAX) ”
  &&  (store_integer (Z.to_nat (4)) 4 ( &( "msec" ) ) msec_pre )
) \/
(
forall (msec_pre: Z) (PreH1 : (msec_pre <= INT_MAX)) (PreH2 : (msec_pre >= INT_MIN)),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
|--
  (store_integer (Z.to_nat (4)) 4 ( &( "msec" ) ) msec_pre )
).

Definition _SemaphoreObtain_which_implies_wit_1_split_goal_spatial :=
forall (msec_pre: Z) (PreH1 : (msec_pre <= INT_MAX)) (PreH2 : (msec_pre >= INT_MIN)),
  ((( &( "msec" ) )) # Int  |-> msec_pre)
|--
  (store_integer (Z.to_nat (4)) 4 ( &( "msec" ) ) msec_pre )
.

Definition _SemaphoreObtain_which_implies_wit_2 :=
(
forall (msec_pre: Z),
  (store_integer (Z.to_nat (4)) 4 ( &( "msec" ) ) msec_pre )
|--
  ((( &( "msec" ) )) # Int  |-> msec_pre)
) \/
(
forall (msec_pre: Z),
  (store_integer (Z.to_nat (4)) 4 ( &( "msec" ) ) msec_pre )
|--
  ((( &( "msec" ) )) # Int  |-> msec_pre)
).

Definition _SemaphoreObtain_which_implies_wit_2_split_goal_spatial :=
forall (msec_pre: Z),
  (store_integer (Z.to_nat (4)) 4 ( &( "msec" ) ) msec_pre )
|--
  ((( &( "msec" ) )) # Int  |-> msec_pre)
.

Definition _SemaphoreObtain_which_implies_wit_3 :=
(
forall (sg_semaphore_obtain_oc: StableGlobalState) (held: VarGlobalState),
  (os_inv sg_semaphore_obtain_oc held )
|--
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_obtain_oc) (held)) )
) \/
(
forall (sg_semaphore_obtain_oc: StableGlobalState) (held: VarGlobalState),
  (os_inv sg_semaphore_obtain_oc held )
|--
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_obtain_oc) (held)) )
).

Definition _SemaphoreObtain_which_implies_wit_3_split_goal_spatial :=
forall (sg_semaphore_obtain_oc: StableGlobalState) (held: VarGlobalState),
  (os_inv sg_semaphore_obtain_oc held )
|--
  (store_idmanager (semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc)))) (semaphore_manager ((os_semaphores (held)))) ( &( "k_sem_id_manager" ) ) )
  **  (wand (store_idmanager ((semaphore_manager_stable ((os_semaphore_stable (sg_semaphore_obtain_oc))))) ((semaphore_manager ((os_semaphores (held))))) (( &( "k_sem_id_manager" ) ))) (os_inv (sg_semaphore_obtain_oc) (held)) )
.

Definition _SemaphoreObtain_which_implies_wit_4 :=
forall (sg_semaphore_obtain_oc: StableGlobalState) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (PreH1 : (In original (os_semaphores (held)) )) (PreH2 : (sem = (semaphore_addr (original)))),
  (os_inv sg_semaphore_obtain_oc held )
|--
  (“ (sem = (semaphore_addr (original))) ”
  &&  “ ((semaphore_value (original)) = 0) ”
  &&  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> 0)
  **  (wand (store_ushort (&((sem)  # "Semaphore" ->ₛ "value")) (0)) (os_inv (sg_semaphore_obtain_oc) (held)) ))
  ||
  (“ (sem = (semaphore_addr (original))) ”
  &&  “ (0 < (semaphore_value (original))) ”
  &&  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
  **  (wand (store_ushort (&((sem)  # "Semaphore" ->ₛ "value")) (((semaphore_value (original)) - 1 ))) (os_inv (sg_semaphore_obtain_oc) ((replace_semaphores ((semaphore_set_value (sem) (((semaphore_value (original)) - 1 )) ((os_semaphores (held))))) (held)))) ))
.

Definition _SemaphoreObtain_which_implies_wit_5 :=
forall (original: SemaphoreAbs) (sem: Z),
  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
|--
  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> (semaphore_value (original)))
.

Definition _SemaphoreObtain_which_implies_wit_6 :=
(
forall (sg_semaphore_obtain_oc: StableGlobalState) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (sem_value: Z) (PreH1 : (sem = (semaphore_addr (original)))) (PreH2 : (sem_value = 0)),
  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> sem_value)
  **  (wand (store_ushort (&((sem)  # "Semaphore" ->ₛ "value")) (0)) (os_inv (sg_semaphore_obtain_oc) (held)) )
|--
  “ (sem = (semaphore_addr (original))) ”
  &&  (os_inv sg_semaphore_obtain_oc held )
) \/
(
forall (sg_semaphore_obtain_oc: StableGlobalState) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (sem_value: Z) (PreH1 : (sem = (semaphore_addr (original)))) (PreH2 : (sem_value = 0)),
  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> sem_value)
  **  (wand (store_ushort (&((sem)  # "Semaphore" ->ₛ "value")) (0)) (os_inv (sg_semaphore_obtain_oc) (held)) )
|--
  (os_inv sg_semaphore_obtain_oc held )
).

Definition _SemaphoreObtain_which_implies_wit_6_split_goal_spatial :=
forall (sg_semaphore_obtain_oc: StableGlobalState) (held: VarGlobalState) (original: SemaphoreAbs) (sem: Z) (sem_value: Z) (PreH1 : (sem = (semaphore_addr (original)))) (PreH2 : (sem_value = 0)),
  ((&((sem)  # "Semaphore" ->ₛ "value")) # UShort  |-> sem_value)
  **  (wand (store_ushort (&((sem)  # "Semaphore" ->ₛ "value")) (0)) (os_inv (sg_semaphore_obtain_oc) (held)) )
|--
  (os_inv sg_semaphore_obtain_oc held )
.

Definition _SemaphoreObtain_which_implies_wit_7 :=
(
forall (sg_semaphore_obtain_oc: StableGlobalState) (held: VarGlobalState),
  (os_inv sg_semaphore_obtain_oc held )
|--
  ((&(( &( "Assign" ) )->ₛ "os_running_task")) # Ptr  |-> (assignRunningTask ((os_assign (held)))))
  **  (wand (store_ptr (&(( &( "Assign" ) )->ₛ "os_running_task")) ((assignRunningTask ((os_assign (held)))))) (os_inv (sg_semaphore_obtain_oc) (held)) )
) \/
(
forall (sg_semaphore_obtain_oc: StableGlobalState) (held: VarGlobalState),
  (os_inv sg_semaphore_obtain_oc held )
|--
  ((&(( &( "Assign" ) )->ₛ "os_running_task")) # Ptr  |-> (assignRunningTask ((os_assign (held)))))
  **  (wand (store_ptr (&(( &( "Assign" ) )->ₛ "os_running_task")) ((assignRunningTask ((os_assign (held)))))) (os_inv (sg_semaphore_obtain_oc) (held)) )
).

Definition _SemaphoreObtain_which_implies_wit_7_split_goal_spatial :=
forall (sg_semaphore_obtain_oc: StableGlobalState) (held: VarGlobalState),
  (os_inv sg_semaphore_obtain_oc held )
|--
  ((&(( &( "Assign" ) )->ₛ "os_running_task")) # Ptr  |-> (assignRunningTask ((os_assign (held)))))
  **  (wand (store_ptr (&(( &( "Assign" ) )->ₛ "os_running_task")) ((assignRunningTask ((os_assign (held)))))) (os_inv (sg_semaphore_obtain_oc) (held)) )
.

Definition _SemaphoreObtain_which_implies_wit_8 :=
(
forall (sg_semaphore_obtain_oc: StableGlobalState) (held: VarGlobalState) (task: Z) (PreH1 : (task = (assignRunningTask ((os_assign (held)))))),
  ((&(( &( "Assign" ) )->ₛ "os_running_task")) # Ptr  |-> task)
  **  (wand (store_ptr (&(( &( "Assign" ) )->ₛ "os_running_task")) (task)) (os_inv (sg_semaphore_obtain_oc) (held)) )
|--
  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  (os_inv sg_semaphore_obtain_oc held )
) \/
(
forall (sg_semaphore_obtain_oc: StableGlobalState) (held: VarGlobalState) (task: Z) (PreH1 : (task = (assignRunningTask ((os_assign (held)))))),
  ((&(( &( "Assign" ) )->ₛ "os_running_task")) # Ptr  |-> task)
  **  (wand (store_ptr (&(( &( "Assign" ) )->ₛ "os_running_task")) (task)) (os_inv (sg_semaphore_obtain_oc) (held)) )
|--
  (os_inv sg_semaphore_obtain_oc held )
).

Definition _SemaphoreObtain_which_implies_wit_8_split_goal_spatial :=
forall (sg_semaphore_obtain_oc: StableGlobalState) (held: VarGlobalState) (task: Z) (PreH1 : (task = (assignRunningTask ((os_assign (held)))))),
  ((&(( &( "Assign" ) )->ₛ "os_running_task")) # Ptr  |-> task)
  **  (wand (store_ptr (&(( &( "Assign" ) )->ₛ "os_running_task")) (task)) (os_inv (sg_semaphore_obtain_oc) (held)) )
|--
  (os_inv sg_semaphore_obtain_oc held )
.

Definition _SemaphoreObtain_which_implies_wit_9 :=
forall (desc: TaskDescriptorAbs) (task: Z),
  ((&((task)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (desc.(tdExstatus) ))
|--
  ((&((task)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (desc.(tdExstatus) ))
.

Definition _SemaphoreObtain_which_implies_wit_10 :=
(
forall (sg_semaphore_obtain_oc: StableGlobalState) (held: VarGlobalState) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (task: Z) (PreH1 : (task = (assignRunningTask ((os_assign (held)))))) (PreH2 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))),
  (os_inv sg_semaphore_obtain_oc suspended )
|--
  EX (rollback_id: Z),
  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (0 <= rollback_id) ”
  &&  “ (rollback_id < 65536) ”
  &&  “ (get_task_with_idnode_success sg_semaphore_obtain_oc suspended rollback_id task ) ”
  &&  ((&((task)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> rollback_id)
  **  (wand (store_ushort (&((task)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (rollback_id)) (os_inv (sg_semaphore_obtain_oc) (suspended)) )
) \/
(
forall (sg_semaphore_obtain_oc: StableGlobalState) (held: VarGlobalState) (suspended: VarGlobalState) (sd: TaskDescriptorAbs) (task: Z) (PreH1 : (task = (assignRunningTask ((os_assign (held)))))) (PreH2 : ((task_desc_map ((os_tasks (suspended))) (task)) = (Some (sd)))),
  (os_inv sg_semaphore_obtain_oc suspended )
|--
  EX (rollback_id: Z),
  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  “ (0 <= rollback_id) ”
  &&  “ (rollback_id < 65536) ”
  &&  “ (get_task_with_idnode_success sg_semaphore_obtain_oc suspended rollback_id task ) ”
  &&  ((&((task)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> rollback_id)
  **  (wand (store_ushort (&((task)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (rollback_id)) (os_inv (sg_semaphore_obtain_oc) (suspended)) )
).

Definition _SemaphoreObtain_which_implies_wit_11 :=
(
forall (sg_semaphore_obtain_oc: StableGlobalState) (held: VarGlobalState) (suspended: VarGlobalState) (rollback_id: Z) (task: Z) (PreH1 : (task = (assignRunningTask ((os_assign (held)))))),
  ((&((task)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> rollback_id)
  **  (wand (store_ushort (&((task)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (rollback_id)) (os_inv (sg_semaphore_obtain_oc) (suspended)) )
|--
  “ (task = (assignRunningTask ((os_assign (held))))) ”
  &&  (os_inv sg_semaphore_obtain_oc suspended )
) \/
(
forall (sg_semaphore_obtain_oc: StableGlobalState) (held: VarGlobalState) (suspended: VarGlobalState) (rollback_id: Z) (task: Z) (PreH1 : (task = (assignRunningTask ((os_assign (held)))))),
  ((&((task)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> rollback_id)
  **  (wand (store_ushort (&((task)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (rollback_id)) (os_inv (sg_semaphore_obtain_oc) (suspended)) )
|--
  (os_inv sg_semaphore_obtain_oc suspended )
).

Definition _SemaphoreObtain_which_implies_wit_11_split_goal_spatial :=
forall (sg_semaphore_obtain_oc: StableGlobalState) (held: VarGlobalState) (suspended: VarGlobalState) (rollback_id: Z) (task: Z) (PreH1 : (task = (assignRunningTask ((os_assign (held)))))),
  ((&((task)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> rollback_id)
  **  (wand (store_ushort (&((task)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) (rollback_id)) (os_inv (sg_semaphore_obtain_oc) (suspended)) )
|--
  (os_inv sg_semaphore_obtain_oc suspended )
.

Definition _SemaphoreObtain_which_implies_wit_12 :=
forall (status_desc: TaskDescriptorAbs) (task: Z),
  ((&((task)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (status_desc.(tdExstatus) ))
|--
  ((&((task)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (status_desc.(tdExstatus) ))
.

Module Type VC_Correct.


Axiom proof_of__SemaphoreObtain_safety_wit_1 : _SemaphoreObtain_safety_wit_1.
Axiom proof_of__SemaphoreObtain_safety_wit_2 : _SemaphoreObtain_safety_wit_2.
Axiom proof_of__SemaphoreObtain_safety_wit_3 : _SemaphoreObtain_safety_wit_3.
Axiom proof_of__SemaphoreObtain_safety_wit_4 : _SemaphoreObtain_safety_wit_4.
Axiom proof_of__SemaphoreObtain_safety_wit_5 : _SemaphoreObtain_safety_wit_5.
Axiom proof_of__SemaphoreObtain_safety_wit_6 : _SemaphoreObtain_safety_wit_6.
Axiom proof_of__SemaphoreObtain_safety_wit_7 : _SemaphoreObtain_safety_wit_7.
Axiom proof_of__SemaphoreObtain_safety_wit_8 : _SemaphoreObtain_safety_wit_8.
Axiom proof_of__SemaphoreObtain_safety_wit_9 : _SemaphoreObtain_safety_wit_9.
Axiom proof_of__SemaphoreObtain_safety_wit_10 : _SemaphoreObtain_safety_wit_10.
Axiom proof_of__SemaphoreObtain_safety_wit_11 : _SemaphoreObtain_safety_wit_11.
Axiom proof_of__SemaphoreObtain_safety_wit_12 : _SemaphoreObtain_safety_wit_12.
Axiom proof_of__SemaphoreObtain_safety_wit_13 : _SemaphoreObtain_safety_wit_13.
Axiom proof_of__SemaphoreObtain_safety_wit_14 : _SemaphoreObtain_safety_wit_14.
Axiom proof_of__SemaphoreObtain_safety_wit_15 : _SemaphoreObtain_safety_wit_15.
Axiom proof_of__SemaphoreObtain_safety_wit_16 : _SemaphoreObtain_safety_wit_16.
Axiom proof_of__SemaphoreObtain_safety_wit_17 : _SemaphoreObtain_safety_wit_17.
Axiom proof_of__SemaphoreObtain_safety_wit_18 : _SemaphoreObtain_safety_wit_18.
Axiom proof_of__SemaphoreObtain_safety_wit_19 : _SemaphoreObtain_safety_wit_19.
Axiom proof_of__SemaphoreObtain_safety_wit_20 : _SemaphoreObtain_safety_wit_20.
Axiom proof_of__SemaphoreObtain_safety_wit_21 : _SemaphoreObtain_safety_wit_21.
Axiom proof_of__SemaphoreObtain_safety_wit_22 : _SemaphoreObtain_safety_wit_22.
Axiom proof_of__SemaphoreObtain_safety_wit_23 : _SemaphoreObtain_safety_wit_23.
Axiom proof_of__SemaphoreObtain_safety_wit_24 : _SemaphoreObtain_safety_wit_24.
Axiom proof_of__SemaphoreObtain_safety_wit_25 : _SemaphoreObtain_safety_wit_25.
Axiom proof_of__SemaphoreObtain_safety_wit_26 : _SemaphoreObtain_safety_wit_26.
Axiom proof_of__SemaphoreObtain_safety_wit_27 : _SemaphoreObtain_safety_wit_27.
Axiom proof_of__SemaphoreObtain_safety_wit_28 : _SemaphoreObtain_safety_wit_28.
Axiom proof_of__SemaphoreObtain_safety_wit_29 : _SemaphoreObtain_safety_wit_29.
Axiom proof_of__SemaphoreObtain_safety_wit_30 : _SemaphoreObtain_safety_wit_30.
Axiom proof_of__SemaphoreObtain_safety_wit_31 : _SemaphoreObtain_safety_wit_31.
Axiom proof_of__SemaphoreObtain_safety_wit_32 : _SemaphoreObtain_safety_wit_32.
Axiom proof_of__SemaphoreObtain_safety_wit_33 : _SemaphoreObtain_safety_wit_33.
Axiom proof_of__SemaphoreObtain_safety_wit_34 : _SemaphoreObtain_safety_wit_34.
Axiom proof_of__SemaphoreObtain_safety_wit_35 : _SemaphoreObtain_safety_wit_35.
Axiom proof_of__SemaphoreObtain_safety_wit_36 : _SemaphoreObtain_safety_wit_36.
Axiom proof_of__SemaphoreObtain_safety_wit_37 : _SemaphoreObtain_safety_wit_37.
Axiom proof_of__SemaphoreObtain_safety_wit_38 : _SemaphoreObtain_safety_wit_38.
Axiom proof_of__SemaphoreObtain_safety_wit_39 : _SemaphoreObtain_safety_wit_39.
Axiom proof_of__SemaphoreObtain_safety_wit_40 : _SemaphoreObtain_safety_wit_40.
Axiom proof_of__SemaphoreObtain_safety_wit_41 : _SemaphoreObtain_safety_wit_41.
Axiom proof_of__SemaphoreObtain_safety_wit_42 : _SemaphoreObtain_safety_wit_42.
Axiom proof_of__SemaphoreObtain_safety_wit_43 : _SemaphoreObtain_safety_wit_43.
Axiom proof_of__SemaphoreObtain_safety_wit_44 : _SemaphoreObtain_safety_wit_44.
Axiom proof_of__SemaphoreObtain_safety_wit_45 : _SemaphoreObtain_safety_wit_45.
Axiom proof_of__SemaphoreObtain_safety_wit_46 : _SemaphoreObtain_safety_wit_46.
Axiom proof_of__SemaphoreObtain_safety_wit_47 : _SemaphoreObtain_safety_wit_47.
Axiom proof_of__SemaphoreObtain_safety_wit_48 : _SemaphoreObtain_safety_wit_48.
Axiom proof_of__SemaphoreObtain_safety_wit_49 : _SemaphoreObtain_safety_wit_49.
Axiom proof_of__SemaphoreObtain_safety_wit_50 : _SemaphoreObtain_safety_wit_50.
Axiom proof_of__SemaphoreObtain_safety_wit_51 : _SemaphoreObtain_safety_wit_51.
Axiom proof_of__SemaphoreObtain_entail_wit_1_1 : _SemaphoreObtain_entail_wit_1_1.
Axiom proof_of__SemaphoreObtain_entail_wit_1_2 : _SemaphoreObtain_entail_wit_1_2.
Axiom proof_of__SemaphoreObtain_entail_wit_1_3 : _SemaphoreObtain_entail_wit_1_3.
Axiom proof_of__SemaphoreObtain_entail_wit_2 : _SemaphoreObtain_entail_wit_2.
Axiom proof_of__SemaphoreObtain_entail_wit_3_1 : _SemaphoreObtain_entail_wit_3_1.
Axiom proof_of__SemaphoreObtain_entail_wit_3_2 : _SemaphoreObtain_entail_wit_3_2.
Axiom proof_of__SemaphoreObtain_entail_wit_4 : _SemaphoreObtain_entail_wit_4.
Axiom proof_of__SemaphoreObtain_entail_wit_5 : _SemaphoreObtain_entail_wit_5.
Axiom proof_of__SemaphoreObtain_entail_wit_6 : _SemaphoreObtain_entail_wit_6.
Axiom proof_of__SemaphoreObtain_entail_wit_7 : _SemaphoreObtain_entail_wit_7.
Axiom proof_of__SemaphoreObtain_entail_wit_8 : _SemaphoreObtain_entail_wit_8.
Axiom proof_of__SemaphoreObtain_entail_wit_9 : _SemaphoreObtain_entail_wit_9.
Axiom proof_of__SemaphoreObtain_entail_wit_10 : _SemaphoreObtain_entail_wit_10.
Axiom proof_of__SemaphoreObtain_entail_wit_11 : _SemaphoreObtain_entail_wit_11.
Axiom proof_of__SemaphoreObtain_entail_wit_12_1 : _SemaphoreObtain_entail_wit_12_1.
Axiom proof_of__SemaphoreObtain_entail_wit_12_2 : _SemaphoreObtain_entail_wit_12_2.
Axiom proof_of__SemaphoreObtain_entail_wit_13_1 : _SemaphoreObtain_entail_wit_13_1.
Axiom proof_of__SemaphoreObtain_entail_wit_13_2 : _SemaphoreObtain_entail_wit_13_2.
Axiom proof_of__SemaphoreObtain_entail_wit_14_1 : _SemaphoreObtain_entail_wit_14_1.
Axiom proof_of__SemaphoreObtain_entail_wit_14_2 : _SemaphoreObtain_entail_wit_14_2.
Axiom proof_of__SemaphoreObtain_entail_wit_14_3 : _SemaphoreObtain_entail_wit_14_3.
Axiom proof_of__SemaphoreObtain_entail_wit_15 : _SemaphoreObtain_entail_wit_15.
Axiom proof_of__SemaphoreObtain_entail_wit_16 : _SemaphoreObtain_entail_wit_16.
Axiom proof_of__SemaphoreObtain_entail_wit_17 : _SemaphoreObtain_entail_wit_17.
Axiom proof_of__SemaphoreObtain_return_wit_1 : _SemaphoreObtain_return_wit_1.
Axiom proof_of__SemaphoreObtain_return_wit_2 : _SemaphoreObtain_return_wit_2.
Axiom proof_of__SemaphoreObtain_return_wit_3 : _SemaphoreObtain_return_wit_3.
Axiom proof_of__SemaphoreObtain_return_wit_4 : _SemaphoreObtain_return_wit_4.
Axiom proof_of__SemaphoreObtain_return_wit_5 : _SemaphoreObtain_return_wit_5.
Axiom proof_of__SemaphoreObtain_return_wit_6 : _SemaphoreObtain_return_wit_6.
Axiom proof_of__SemaphoreObtain_return_wit_7 : _SemaphoreObtain_return_wit_7.
Axiom proof_of__SemaphoreObtain_return_wit_8 : _SemaphoreObtain_return_wit_8.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_1 : _SemaphoreObtain_partial_solve_wit_1.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_2 : _SemaphoreObtain_partial_solve_wit_2.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_3 : _SemaphoreObtain_partial_solve_wit_3.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_4 : _SemaphoreObtain_partial_solve_wit_4.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_5 : _SemaphoreObtain_partial_solve_wit_5.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_6_pure : _SemaphoreObtain_partial_solve_wit_6_pure.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_6 : _SemaphoreObtain_partial_solve_wit_6.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_7_pure : _SemaphoreObtain_partial_solve_wit_7_pure.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_7 : _SemaphoreObtain_partial_solve_wit_7.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_8_pure : _SemaphoreObtain_partial_solve_wit_8_pure.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_8 : _SemaphoreObtain_partial_solve_wit_8.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_9_pure : _SemaphoreObtain_partial_solve_wit_9_pure.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_9 : _SemaphoreObtain_partial_solve_wit_9.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_10 : _SemaphoreObtain_partial_solve_wit_10.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_11 : _SemaphoreObtain_partial_solve_wit_11.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_12_pure : _SemaphoreObtain_partial_solve_wit_12_pure.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_12 : _SemaphoreObtain_partial_solve_wit_12.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_13_pure : _SemaphoreObtain_partial_solve_wit_13_pure.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_13 : _SemaphoreObtain_partial_solve_wit_13.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_14_pure : _SemaphoreObtain_partial_solve_wit_14_pure.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_14 : _SemaphoreObtain_partial_solve_wit_14.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_15 : _SemaphoreObtain_partial_solve_wit_15.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_16 : _SemaphoreObtain_partial_solve_wit_16.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_17_pure : _SemaphoreObtain_partial_solve_wit_17_pure.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_17 : _SemaphoreObtain_partial_solve_wit_17.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_18 : _SemaphoreObtain_partial_solve_wit_18.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_19_pure : _SemaphoreObtain_partial_solve_wit_19_pure.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_19 : _SemaphoreObtain_partial_solve_wit_19.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_20_pure : _SemaphoreObtain_partial_solve_wit_20_pure.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_20 : _SemaphoreObtain_partial_solve_wit_20.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_21_pure : _SemaphoreObtain_partial_solve_wit_21_pure.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_21 : _SemaphoreObtain_partial_solve_wit_21.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_22_pure : _SemaphoreObtain_partial_solve_wit_22_pure.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_22 : _SemaphoreObtain_partial_solve_wit_22.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_23_pure : _SemaphoreObtain_partial_solve_wit_23_pure.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_23 : _SemaphoreObtain_partial_solve_wit_23.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_24_pure : _SemaphoreObtain_partial_solve_wit_24_pure.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_24 : _SemaphoreObtain_partial_solve_wit_24.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_25_pure : _SemaphoreObtain_partial_solve_wit_25_pure.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_25 : _SemaphoreObtain_partial_solve_wit_25.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_26_pure : _SemaphoreObtain_partial_solve_wit_26_pure.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_26 : _SemaphoreObtain_partial_solve_wit_26.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_27_pure : _SemaphoreObtain_partial_solve_wit_27_pure.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_27 : _SemaphoreObtain_partial_solve_wit_27.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_28 : _SemaphoreObtain_partial_solve_wit_28.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_29 : _SemaphoreObtain_partial_solve_wit_29.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_30_pure : _SemaphoreObtain_partial_solve_wit_30_pure.
Axiom proof_of__SemaphoreObtain_partial_solve_wit_30 : _SemaphoreObtain_partial_solve_wit_30.
Axiom proof_of__SemaphoreObtain_which_implies_wit_1 : _SemaphoreObtain_which_implies_wit_1.
Axiom proof_of__SemaphoreObtain_which_implies_wit_2 : _SemaphoreObtain_which_implies_wit_2.
Axiom proof_of__SemaphoreObtain_which_implies_wit_3 : _SemaphoreObtain_which_implies_wit_3.
Axiom proof_of__SemaphoreObtain_which_implies_wit_4 : _SemaphoreObtain_which_implies_wit_4.
Axiom proof_of__SemaphoreObtain_which_implies_wit_5 : _SemaphoreObtain_which_implies_wit_5.
Axiom proof_of__SemaphoreObtain_which_implies_wit_6 : _SemaphoreObtain_which_implies_wit_6.
Axiom proof_of__SemaphoreObtain_which_implies_wit_7 : _SemaphoreObtain_which_implies_wit_7.
Axiom proof_of__SemaphoreObtain_which_implies_wit_8 : _SemaphoreObtain_which_implies_wit_8.
Axiom proof_of__SemaphoreObtain_which_implies_wit_9 : _SemaphoreObtain_which_implies_wit_9.
Axiom proof_of__SemaphoreObtain_which_implies_wit_10 : _SemaphoreObtain_which_implies_wit_10.
Axiom proof_of__SemaphoreObtain_which_implies_wit_11 : _SemaphoreObtain_which_implies_wit_11.
Axiom proof_of__SemaphoreObtain_which_implies_wit_12 : _SemaphoreObtain_which_implies_wit_12.

End VC_Correct.
