From SimpleC.Verification Require Import VCPrelude.
Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Local Open Scope sac.

(*----- Function DeInitDataqueue -----*)

Definition DeInitDataqueue_safety_wit_1 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )),
  ((( &( "lock" ) )) # Int  |->_)
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre q_init_cleanup )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg_init_cleanup before_init_cleanup )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition DeInitDataqueue_safety_wit_2 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (saved: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_pre <> 0)) (PreH2 : (addr_aligned p_queue_pre 4 )) (PreH3 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH4 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH5 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH6 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH7 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH8 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH9 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) <> 0)) (PreH10 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH12 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH13 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH15 : (p_queue_base = 0)),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  (CharArray.undef_full ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)) * 8 ) )
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
|--
  “ False ”
.

Definition DeInitDataqueue_safety_wit_3 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (saved: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_pre <> 0)) (PreH2 : (addr_aligned p_queue_pre 4 )) (PreH3 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH4 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH5 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH6 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH7 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH8 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH9 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) = 0)) (PreH10 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH11 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH12 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH13 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH14 : (p_queue_base <> 0)),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
|--
  “ False ”
.

Definition DeInitDataqueue_safety_wit_4 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (saved: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_pre <> 0)) (PreH2 : (addr_aligned p_queue_pre 4 )) (PreH3 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH4 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH5 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH6 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH7 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH8 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH9 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) <> 0)) (PreH10 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH12 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH13 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH15 : (p_queue_base <> 0)),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition DeInitDataqueue_safety_wit_5 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (saved: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_pre <> 0)) (PreH2 : (addr_aligned p_queue_pre 4 )) (PreH3 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH4 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH5 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH6 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH7 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH8 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH9 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) = 0)) (PreH10 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH11 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH12 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH13 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH14 : (p_queue_base = 0)),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition DeInitDataqueue_safety_wit_6 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (saved: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_pre <> 0)) (PreH2 : (addr_aligned p_queue_pre 4 )) (PreH3 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH4 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH5 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH6 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH7 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH8 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH9 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) <> 0)) (PreH10 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH12 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH13 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH15 : (p_queue_base <> 0)),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition DeInitDataqueue_safety_wit_7 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (saved: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  p_queue_sem_blank observed after )) (PreH2 : (p_queue_sem_blank >= 0)) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH6 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH7 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH8 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH9 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH10 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH11 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) = 0)) (PreH12 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH13 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH15 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH16 : (p_queue_base = 0)),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup after )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
|--
  “ (1 <> (INT_MIN)) ”
.

Definition DeInitDataqueue_safety_wit_8 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (saved: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  p_queue_sem_blank observed after )) (PreH2 : (p_queue_sem_blank >= 0)) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH6 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH7 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH8 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH9 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH10 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH11 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) = 0)) (PreH12 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH13 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH15 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH16 : (p_queue_base = 0)),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup after )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition DeInitDataqueue_safety_wit_9 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (saved: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  p_queue_sem_blank observed after )) (PreH2 : (p_queue_sem_blank >= 0)) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH6 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH7 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH8 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH9 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH10 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH11 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) <> 0)) (PreH12 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH13 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH14 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH15 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH16 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH17 : (p_queue_base <> 0)),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup after )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
|--
  “ (1 <> (INT_MIN)) ”
.

Definition DeInitDataqueue_safety_wit_10 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (saved: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  p_queue_sem_blank observed after )) (PreH2 : (p_queue_sem_blank >= 0)) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH6 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH7 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH8 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH9 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH10 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH11 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) <> 0)) (PreH12 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH13 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH14 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH15 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH16 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH17 : (p_queue_base <> 0)),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup after )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition DeInitDataqueue_safety_wit_11 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (saved: Z) (p_queue_front: Z) (p_queue_rear: Z) (p_queue_max_len: Z) (p_queue_base: Z) (p_queue_sem_blank: Z) (p_queue_sem_data: Z) (middle:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : (p_queue_pre <> 0)) (PreH2 : (addr_aligned p_queue_pre 4 )) (PreH3 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH4 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH5 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH6 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed middle )) (PreH7 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) middle )) (PreH8 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH9 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH10 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH11 : (p_queue_base = 0)) (PreH12 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))) (PreH13 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup middle )
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition DeInitDataqueue_safety_wit_12 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (saved: Z) (p_queue_front: Z) (p_queue_rear: Z) (p_queue_max_len: Z) (p_queue_base: Z) (p_queue_sem_blank: Z) (p_queue_sem_data: Z) (middle:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : (p_queue_pre <> 0)) (PreH2 : (addr_aligned p_queue_pre 4 )) (PreH3 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH4 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH5 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) < 0)) (PreH6 : (middle = observed)) (PreH7 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) middle )) (PreH8 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH9 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH10 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH11 : (p_queue_base = 0)) (PreH12 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))) (PreH13 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup middle )
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition DeInitDataqueue_safety_wit_13 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (saved: Z) (p_queue_front: Z) (p_queue_rear: Z) (p_queue_max_len: Z) (p_queue_base: Z) (p_queue_sem_blank: Z) (p_queue_sem_data: Z) (middle:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  p_queue_sem_data middle after )) (PreH2 : (p_queue_sem_data >= 0)) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH6 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH7 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH8 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed middle )) (PreH9 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) middle )) (PreH10 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH11 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH12 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH13 : (p_queue_base = 0)) (PreH14 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))) (PreH15 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup after )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
|--
  “ (1 <> (INT_MIN)) ”
.

Definition DeInitDataqueue_safety_wit_14 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (saved: Z) (p_queue_front: Z) (p_queue_rear: Z) (p_queue_max_len: Z) (p_queue_base: Z) (p_queue_sem_blank: Z) (p_queue_sem_data: Z) (middle:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  p_queue_sem_data middle after )) (PreH2 : (p_queue_sem_data >= 0)) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH6 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH7 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH8 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed middle )) (PreH9 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) middle )) (PreH10 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH11 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH12 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH13 : (p_queue_base = 0)) (PreH14 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))) (PreH15 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup after )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition DeInitDataqueue_safety_wit_15 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (saved: Z) (p_queue_front: Z) (p_queue_rear: Z) (p_queue_max_len: Z) (p_queue_base: Z) (p_queue_sem_blank: Z) (p_queue_sem_data: Z) (middle:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  p_queue_sem_data middle after )) (PreH2 : (p_queue_sem_data >= 0)) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH6 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH7 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) < 0)) (PreH8 : (middle = observed)) (PreH9 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) middle )) (PreH10 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH11 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH12 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH13 : (p_queue_base = 0)) (PreH14 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))) (PreH15 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup after )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
|--
  “ (1 <> (INT_MIN)) ”
.

Definition DeInitDataqueue_safety_wit_16 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (saved: Z) (p_queue_front: Z) (p_queue_rear: Z) (p_queue_max_len: Z) (p_queue_base: Z) (p_queue_sem_blank: Z) (p_queue_sem_data: Z) (middle:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  p_queue_sem_data middle after )) (PreH2 : (p_queue_sem_data >= 0)) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH6 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH7 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) < 0)) (PreH8 : (middle = observed)) (PreH9 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) middle )) (PreH10 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH11 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH12 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH13 : (p_queue_base = 0)) (PreH14 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))) (PreH15 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup after )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition DeInitDataqueue_entail_wit_1 :=
(
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )),
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre q_init_cleanup )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup ) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed ) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre q_init_cleanup )
) \/
(
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )),
  TT && emp 
|--
  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed ) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed ) ”
  &&  emp
).

Definition DeInitDataqueue_entail_wit_1_split_goal_1 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )),
  ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )
.

Definition DeInitDataqueue_entail_wit_1_split_goal_2 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )),
  ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )
.

Definition DeInitDataqueue_entail_wit_2_1 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_sem_data_2: Z) (p_queue_sem_blank_2: Z) (p_queue_base_2: Z) (p_queue_max_len_2: Z) (p_queue_rear_2: Z) (p_queue_front_2: Z) (PreH1 : (p_queue_pre <> 0)) (PreH2 : (addr_aligned p_queue_pre 4 )) (PreH3 : (p_queue_front_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH4 : (p_queue_rear_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH5 : (p_queue_max_len_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH6 : (p_queue_base_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH7 : (p_queue_sem_blank_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH8 : (p_queue_sem_data_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH9 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) <> 0)) (PreH10 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH12 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH13 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH15 : (p_queue_base_2 = 0)),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data_2)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  (CharArray.undef_full ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)) * 8 ) )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
|--
  EX (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z),
  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup))) ”
  &&  “ (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup))) ”
  &&  “ (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup))) ”
  &&  “ (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup))) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup))) ”
  &&  “ (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) = 0) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup ) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed ) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed ) ”
  &&  “ (p_queue_base = 0) ”
  &&  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
.

Definition DeInitDataqueue_entail_wit_2_2 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_pre <> 0)) (PreH2 : (addr_aligned p_queue_pre 4 )) (PreH3 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH4 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH5 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH6 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH7 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH8 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH9 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) = 0)) (PreH10 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH11 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH12 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH13 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH14 : (p_queue_base = 0)),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
|--
  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup))) ”
  &&  “ (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup))) ”
  &&  “ (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup))) ”
  &&  “ (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup))) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup))) ”
  &&  “ (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) = 0) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup ) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed ) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed ) ”
  &&  “ (p_queue_base = 0) ”
  &&  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
.

Definition DeInitDataqueue_entail_wit_3_1 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_pre <> 0)) (PreH2 : (addr_aligned p_queue_pre 4 )) (PreH3 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH4 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH5 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH6 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH7 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH8 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH9 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) <> 0)) (PreH10 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH12 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH13 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH15 : (p_queue_base <> 0)),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  (CharArray.undef_full ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)) * 8 ) )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
|--
  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup))) ”
  &&  “ (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup))) ”
  &&  “ (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup))) ”
  &&  “ (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup))) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup))) ”
  &&  “ (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) <> 0) ”
  &&  “ (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup))) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup ) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed ) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed ) ”
  &&  “ (p_queue_base <> 0) ”
  &&  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  (CharArray.undef_full ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)) * 8 ) )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
.

Definition DeInitDataqueue_entail_wit_3_2 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_sem_data_2: Z) (p_queue_sem_blank_2: Z) (p_queue_base_2: Z) (p_queue_max_len_2: Z) (p_queue_rear_2: Z) (p_queue_front_2: Z) (PreH1 : (p_queue_pre <> 0)) (PreH2 : (addr_aligned p_queue_pre 4 )) (PreH3 : (p_queue_front_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH4 : (p_queue_rear_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH5 : (p_queue_max_len_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH6 : (p_queue_base_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH7 : (p_queue_sem_blank_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH8 : (p_queue_sem_data_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH9 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) = 0)) (PreH10 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH11 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH12 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH13 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH14 : (p_queue_base_2 <> 0)),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data_2)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
|--
  EX (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z),
  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup))) ”
  &&  “ (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup))) ”
  &&  “ (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup))) ”
  &&  “ (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup))) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup))) ”
  &&  “ (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) <> 0) ”
  &&  “ (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup))) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup ) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed ) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed ) ”
  &&  “ (p_queue_base <> 0) ”
  &&  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  (CharArray.undef_full ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)) * 8 ) )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
.

Definition DeInitDataqueue_entail_wit_4_1 :=
(
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_sem_data_3: Z) (p_queue_sem_blank_3: Z) (p_queue_base_3: Z) (p_queue_max_len_3: Z) (p_queue_rear_3: Z) (p_queue_front_3: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  p_queue_sem_blank_3 observed after )) (PreH2 : (p_queue_sem_blank_3 >= 0)) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : (p_queue_front_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH6 : (p_queue_rear_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH7 : (p_queue_max_len_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH8 : (p_queue_base_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH9 : (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH10 : (p_queue_sem_data_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH11 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) = 0)) (PreH12 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH13 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH15 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH16 : (p_queue_base_3 = 0)),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup after )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> (-1))
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data_3)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
|--
  EX (p_queue_sem_data_2: Z) (p_queue_sem_blank_2: Z) (p_queue_base_2: Z) (p_queue_max_len_2: Z) (p_queue_rear_2: Z) (p_queue_front_2: Z) (middle:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup ) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup))) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed middle ) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) middle ) ”
  &&  “ (p_queue_front_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup))) ”
  &&  “ (p_queue_rear_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup))) ”
  &&  “ (p_queue_max_len_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup))) ”
  &&  “ (p_queue_base_2 = 0) ”
  &&  “ (p_queue_sem_blank_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup))))) ”
  &&  “ (p_queue_sem_data_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup))) ”
  &&  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data_2)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup middle )
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
) \/
(
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_sem_data_3: Z) (p_queue_sem_blank_3: Z) (p_queue_base_3: Z) (p_queue_max_len_3: Z) (p_queue_rear_3: Z) (p_queue_front_3: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  p_queue_sem_blank_3 observed after )) (PreH2 : (p_queue_sem_blank_3 >= 0)) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : (p_queue_front_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH6 : (p_queue_rear_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH7 : (p_queue_max_len_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH8 : (p_queue_base_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH9 : (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH10 : (p_queue_sem_data_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH11 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) = 0)) (PreH12 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH13 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH15 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH16 : (p_queue_base_3 = 0)),
  TT && emp 
|--
  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  p_queue_sem_data_3 after ) ”
  &&  “ ((-1) = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup))))) ”
  &&  “ ((-1) = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup))))) ”
  &&  emp
).

Definition DeInitDataqueue_entail_wit_4_1_split_goal_1 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_sem_data_3: Z) (p_queue_sem_blank_3: Z) (p_queue_base_3: Z) (p_queue_max_len_3: Z) (p_queue_rear_3: Z) (p_queue_front_3: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  p_queue_sem_blank_3 observed after )) (PreH2 : (p_queue_sem_blank_3 >= 0)) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : (p_queue_front_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH6 : (p_queue_rear_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH7 : (p_queue_max_len_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH8 : (p_queue_base_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH9 : (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH10 : (p_queue_sem_data_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH11 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) = 0)) (PreH12 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH13 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH15 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH16 : (p_queue_base_3 = 0)),
  ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  p_queue_sem_data_3 after )
.

Definition DeInitDataqueue_entail_wit_4_1_split_goal_2 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_sem_data_3: Z) (p_queue_sem_blank_3: Z) (p_queue_base_3: Z) (p_queue_max_len_3: Z) (p_queue_rear_3: Z) (p_queue_front_3: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  p_queue_sem_blank_3 observed after )) (PreH2 : (p_queue_sem_blank_3 >= 0)) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : (p_queue_front_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH6 : (p_queue_rear_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH7 : (p_queue_max_len_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH8 : (p_queue_base_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH9 : (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH10 : (p_queue_sem_data_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH11 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) = 0)) (PreH12 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH13 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH15 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH16 : (p_queue_base_3 = 0)),
  ((-1) = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))
.

Definition DeInitDataqueue_entail_wit_4_1_split_goal_3 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_sem_data_3: Z) (p_queue_sem_blank_3: Z) (p_queue_base_3: Z) (p_queue_max_len_3: Z) (p_queue_rear_3: Z) (p_queue_front_3: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  p_queue_sem_blank_3 observed after )) (PreH2 : (p_queue_sem_blank_3 >= 0)) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : (p_queue_front_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH6 : (p_queue_rear_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH7 : (p_queue_max_len_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH8 : (p_queue_base_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH9 : (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH10 : (p_queue_sem_data_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH11 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) = 0)) (PreH12 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH13 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH15 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH16 : (p_queue_base_3 = 0)),
  ((-1) = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))
.

Definition DeInitDataqueue_entail_wit_4_2 :=
(
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_sem_data_3: Z) (p_queue_sem_blank_3: Z) (p_queue_base_3: Z) (p_queue_max_len_3: Z) (p_queue_rear_3: Z) (p_queue_front_3: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  p_queue_sem_blank_3 observed after )) (PreH2 : (p_queue_sem_blank_3 >= 0)) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : (p_queue_front_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH6 : (p_queue_rear_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH7 : (p_queue_max_len_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH8 : (p_queue_base_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH9 : (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH10 : (p_queue_sem_data_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH11 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) <> 0)) (PreH12 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH13 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH14 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH15 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH16 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH17 : (p_queue_base_3 <> 0)),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup after )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> (-1))
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data_3)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
|--
  EX (p_queue_sem_data_2: Z) (p_queue_sem_blank_2: Z) (p_queue_base_2: Z) (p_queue_max_len_2: Z) (p_queue_rear_2: Z) (p_queue_front_2: Z) (middle:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup ) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup))) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed middle ) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) middle ) ”
  &&  “ (p_queue_front_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup))) ”
  &&  “ (p_queue_rear_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup))) ”
  &&  “ (p_queue_max_len_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup))) ”
  &&  “ (p_queue_base_2 = 0) ”
  &&  “ (p_queue_sem_blank_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup))))) ”
  &&  “ (p_queue_sem_data_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup))) ”
  &&  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data_2)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup middle )
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
) \/
(
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_sem_data_3: Z) (p_queue_sem_blank_3: Z) (p_queue_base_3: Z) (p_queue_max_len_3: Z) (p_queue_rear_3: Z) (p_queue_front_3: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  p_queue_sem_blank_3 observed after )) (PreH2 : (p_queue_sem_blank_3 >= 0)) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : (p_queue_front_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH6 : (p_queue_rear_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH7 : (p_queue_max_len_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH8 : (p_queue_base_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH9 : (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH10 : (p_queue_sem_data_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH11 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) <> 0)) (PreH12 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH13 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH14 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH15 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH16 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH17 : (p_queue_base_3 <> 0)),
  TT && emp 
|--
  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  p_queue_sem_data_3 after ) ”
  &&  “ ((-1) = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup))))) ”
  &&  “ ((-1) = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup))))) ”
  &&  emp
).

Definition DeInitDataqueue_entail_wit_4_2_split_goal_1 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_sem_data_3: Z) (p_queue_sem_blank_3: Z) (p_queue_base_3: Z) (p_queue_max_len_3: Z) (p_queue_rear_3: Z) (p_queue_front_3: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  p_queue_sem_blank_3 observed after )) (PreH2 : (p_queue_sem_blank_3 >= 0)) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : (p_queue_front_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH6 : (p_queue_rear_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH7 : (p_queue_max_len_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH8 : (p_queue_base_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH9 : (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH10 : (p_queue_sem_data_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH11 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) <> 0)) (PreH12 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH13 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH14 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH15 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH16 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH17 : (p_queue_base_3 <> 0)),
  ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  p_queue_sem_data_3 after )
.

Definition DeInitDataqueue_entail_wit_4_2_split_goal_2 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_sem_data_3: Z) (p_queue_sem_blank_3: Z) (p_queue_base_3: Z) (p_queue_max_len_3: Z) (p_queue_rear_3: Z) (p_queue_front_3: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  p_queue_sem_blank_3 observed after )) (PreH2 : (p_queue_sem_blank_3 >= 0)) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : (p_queue_front_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH6 : (p_queue_rear_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH7 : (p_queue_max_len_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH8 : (p_queue_base_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH9 : (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH10 : (p_queue_sem_data_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH11 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) <> 0)) (PreH12 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH13 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH14 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH15 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH16 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH17 : (p_queue_base_3 <> 0)),
  ((-1) = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))
.

Definition DeInitDataqueue_entail_wit_4_2_split_goal_3 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_sem_data_3: Z) (p_queue_sem_blank_3: Z) (p_queue_base_3: Z) (p_queue_max_len_3: Z) (p_queue_rear_3: Z) (p_queue_front_3: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  p_queue_sem_blank_3 observed after )) (PreH2 : (p_queue_sem_blank_3 >= 0)) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : (p_queue_front_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH6 : (p_queue_rear_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH7 : (p_queue_max_len_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH8 : (p_queue_base_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH9 : (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH10 : (p_queue_sem_data_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH11 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) <> 0)) (PreH12 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH13 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH14 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH15 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH16 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH17 : (p_queue_base_3 <> 0)),
  ((-1) = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))
.

Definition DeInitDataqueue_entail_wit_4_3 :=
(
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_sem_data_3: Z) (p_queue_sem_blank_3: Z) (p_queue_base_3: Z) (p_queue_max_len_3: Z) (p_queue_rear_3: Z) (p_queue_front_3: Z) (PreH1 : (p_queue_sem_blank_3 < 0)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : (p_queue_front_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH5 : (p_queue_rear_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH6 : (p_queue_max_len_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH7 : (p_queue_base_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH8 : (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH9 : (p_queue_sem_data_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH10 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) = 0)) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH12 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH13 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH15 : (p_queue_base_3 = 0)),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data_3)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
|--
  EX (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (middle:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) < 0) ”
  &&  “ (middle = observed) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) middle ) ”
  &&  “ (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup))) ”
  &&  “ (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup))) ”
  &&  “ (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup))) ”
  &&  “ (p_queue_base = 0) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup))))) ”
  &&  “ (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup))) ”
  &&  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup middle )
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
) \/
(
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_sem_data_3: Z) (p_queue_sem_blank_3: Z) (p_queue_base_3: Z) (p_queue_max_len_3: Z) (p_queue_rear_3: Z) (p_queue_front_3: Z) (PreH1 : (p_queue_sem_blank_3 < 0)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : (p_queue_front_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH5 : (p_queue_rear_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH6 : (p_queue_max_len_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH7 : (p_queue_base_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH8 : (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH9 : (p_queue_sem_data_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH10 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) = 0)) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH12 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH13 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH15 : (p_queue_base_3 = 0)),
  TT && emp 
|--
  “ (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup))))) ”
  &&  “ (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup))))) ”
  &&  emp
).

Definition DeInitDataqueue_entail_wit_4_3_split_goal_1 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_sem_data_3: Z) (p_queue_sem_blank_3: Z) (p_queue_base_3: Z) (p_queue_max_len_3: Z) (p_queue_rear_3: Z) (p_queue_front_3: Z) (PreH1 : (p_queue_sem_blank_3 < 0)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : (p_queue_front_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH5 : (p_queue_rear_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH6 : (p_queue_max_len_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH7 : (p_queue_base_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH8 : (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH9 : (p_queue_sem_data_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH10 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) = 0)) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH12 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH13 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH15 : (p_queue_base_3 = 0)),
  (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))
.

Definition DeInitDataqueue_entail_wit_4_3_split_goal_2 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_sem_data_3: Z) (p_queue_sem_blank_3: Z) (p_queue_base_3: Z) (p_queue_max_len_3: Z) (p_queue_rear_3: Z) (p_queue_front_3: Z) (PreH1 : (p_queue_sem_blank_3 < 0)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : (p_queue_front_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH5 : (p_queue_rear_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH6 : (p_queue_max_len_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH7 : (p_queue_base_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH8 : (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH9 : (p_queue_sem_data_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH10 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) = 0)) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH12 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH13 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH15 : (p_queue_base_3 = 0)),
  (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))
.

Definition DeInitDataqueue_entail_wit_4_4 :=
(
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_sem_data_3: Z) (p_queue_sem_blank_3: Z) (p_queue_base_3: Z) (p_queue_max_len_3: Z) (p_queue_rear_3: Z) (p_queue_front_3: Z) (PreH1 : (p_queue_sem_blank_3 < 0)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : (p_queue_front_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH5 : (p_queue_rear_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH6 : (p_queue_max_len_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH7 : (p_queue_base_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH8 : (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH9 : (p_queue_sem_data_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH10 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) <> 0)) (PreH11 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH12 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH13 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH15 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH16 : (p_queue_base_3 <> 0)),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data_3)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
|--
  EX (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (middle:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) < 0) ”
  &&  “ (middle = observed) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) middle ) ”
  &&  “ (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup))) ”
  &&  “ (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup))) ”
  &&  “ (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup))) ”
  &&  “ (p_queue_base = 0) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup))))) ”
  &&  “ (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup))) ”
  &&  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup middle )
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
) \/
(
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_sem_data_3: Z) (p_queue_sem_blank_3: Z) (p_queue_base_3: Z) (p_queue_max_len_3: Z) (p_queue_rear_3: Z) (p_queue_front_3: Z) (PreH1 : (p_queue_sem_blank_3 < 0)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : (p_queue_front_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH5 : (p_queue_rear_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH6 : (p_queue_max_len_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH7 : (p_queue_base_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH8 : (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH9 : (p_queue_sem_data_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH10 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) <> 0)) (PreH11 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH12 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH13 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH15 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH16 : (p_queue_base_3 <> 0)),
  TT && emp 
|--
  “ (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup))))) ”
  &&  “ (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup))))) ”
  &&  emp
).

Definition DeInitDataqueue_entail_wit_4_4_split_goal_1 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_sem_data_3: Z) (p_queue_sem_blank_3: Z) (p_queue_base_3: Z) (p_queue_max_len_3: Z) (p_queue_rear_3: Z) (p_queue_front_3: Z) (PreH1 : (p_queue_sem_blank_3 < 0)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : (p_queue_front_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH5 : (p_queue_rear_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH6 : (p_queue_max_len_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH7 : (p_queue_base_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH8 : (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH9 : (p_queue_sem_data_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH10 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) <> 0)) (PreH11 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH12 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH13 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH15 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH16 : (p_queue_base_3 <> 0)),
  (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))
.

Definition DeInitDataqueue_entail_wit_4_4_split_goal_2 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_sem_data_3: Z) (p_queue_sem_blank_3: Z) (p_queue_base_3: Z) (p_queue_max_len_3: Z) (p_queue_rear_3: Z) (p_queue_front_3: Z) (PreH1 : (p_queue_sem_blank_3 < 0)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : (p_queue_front_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH5 : (p_queue_rear_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH6 : (p_queue_max_len_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH7 : (p_queue_base_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH8 : (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH9 : (p_queue_sem_data_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH10 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) <> 0)) (PreH11 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH12 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH13 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH15 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH16 : (p_queue_base_3 <> 0)),
  (p_queue_sem_blank_3 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))
.

Definition DeInitDataqueue_entail_wit_5_1 :=
(
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_front: Z) (p_queue_rear: Z) (p_queue_max_len: Z) (p_queue_base: Z) (p_queue_sem_blank: Z) (p_queue_sem_data: Z) (middle:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  p_queue_sem_data middle after )) (PreH2 : (p_queue_sem_data >= 0)) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH6 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH7 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH8 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed middle )) (PreH9 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) middle )) (PreH10 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH11 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH12 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH13 : (p_queue_base = 0)) (PreH14 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))) (PreH15 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup after )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
|--
  EX (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) X_init_cleanup ) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed final ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup final )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre ( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)) )
) \/
(
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_front: Z) (p_queue_rear: Z) (p_queue_max_len: Z) (p_queue_base: Z) (p_queue_sem_blank: Z) (p_queue_sem_data: Z) (middle:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ((-1) <= INT_MAX)) (PreH2 : (p_queue_sem_blank <= INT_MAX)) (PreH3 : ((-1) >= INT_MIN)) (PreH4 : (p_queue_sem_blank >= INT_MIN)) (PreH5 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  p_queue_sem_data middle after )) (PreH6 : (p_queue_sem_data >= 0)) (PreH7 : (p_queue_pre <> 0)) (PreH8 : (addr_aligned p_queue_pre 4 )) (PreH9 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH10 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH11 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH12 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed middle )) (PreH13 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) middle )) (PreH14 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH15 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH16 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH17 : (p_queue_base = 0)) (PreH18 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))) (PreH19 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup after )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
|--
  EX (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) X_init_cleanup ) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed final ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup final )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre ( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)) )
).

Definition DeInitDataqueue_entail_wit_5_2 :=
(
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_front: Z) (p_queue_rear: Z) (p_queue_max_len: Z) (p_queue_base: Z) (p_queue_sem_blank: Z) (p_queue_sem_data: Z) (middle:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  p_queue_sem_data middle after )) (PreH2 : (p_queue_sem_data >= 0)) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH6 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH7 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) < 0)) (PreH8 : (middle = observed)) (PreH9 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) middle )) (PreH10 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH11 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH12 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH13 : (p_queue_base = 0)) (PreH14 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))) (PreH15 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup after )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
|--
  EX (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) X_init_cleanup ) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed final ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup final )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre ( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)) )
) \/
(
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_front: Z) (p_queue_rear: Z) (p_queue_max_len: Z) (p_queue_base: Z) (p_queue_sem_blank: Z) (p_queue_sem_data: Z) (middle:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ((-1) <= INT_MAX)) (PreH2 : (p_queue_sem_blank <= INT_MAX)) (PreH3 : ((-1) >= INT_MIN)) (PreH4 : (p_queue_sem_blank >= INT_MIN)) (PreH5 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  p_queue_sem_data middle after )) (PreH6 : (p_queue_sem_data >= 0)) (PreH7 : (p_queue_pre <> 0)) (PreH8 : (addr_aligned p_queue_pre 4 )) (PreH9 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH10 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH11 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) < 0)) (PreH12 : (middle = observed)) (PreH13 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) middle )) (PreH14 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH15 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH16 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH17 : (p_queue_base = 0)) (PreH18 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))) (PreH19 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup after )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
|--
  EX (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) X_init_cleanup ) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed final ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup final )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre ( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)) )
).

Definition DeInitDataqueue_entail_wit_5_3 :=
(
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_front: Z) (p_queue_rear: Z) (p_queue_max_len: Z) (p_queue_base: Z) (p_queue_sem_blank: Z) (p_queue_sem_data: Z) (middle:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : (p_queue_sem_data < 0)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH5 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH6 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH7 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed middle )) (PreH8 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) middle )) (PreH9 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH10 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH11 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH12 : (p_queue_base = 0)) (PreH13 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))) (PreH14 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup middle )
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
|--
  EX (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) X_init_cleanup ) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed final ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup final )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre ( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)) )
) \/
(
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_front: Z) (p_queue_rear: Z) (p_queue_max_len: Z) (p_queue_base: Z) (p_queue_sem_blank: Z) (p_queue_sem_data: Z) (middle:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : (p_queue_sem_data <= INT_MAX)) (PreH2 : (p_queue_sem_blank <= INT_MAX)) (PreH3 : (p_queue_sem_data >= INT_MIN)) (PreH4 : (p_queue_sem_blank >= INT_MIN)) (PreH5 : (p_queue_sem_data < 0)) (PreH6 : (p_queue_pre <> 0)) (PreH7 : (addr_aligned p_queue_pre 4 )) (PreH8 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH9 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH10 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH11 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed middle )) (PreH12 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) middle )) (PreH13 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH14 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH15 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH16 : (p_queue_base = 0)) (PreH17 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))) (PreH18 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup middle )
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
|--
  EX (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) X_init_cleanup ) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed final ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup final )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre ( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)) )
).

Definition DeInitDataqueue_entail_wit_5_4 :=
(
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_front: Z) (p_queue_rear: Z) (p_queue_max_len: Z) (p_queue_base: Z) (p_queue_sem_blank: Z) (p_queue_sem_data: Z) (middle:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : (p_queue_sem_data < 0)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH5 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) < 0)) (PreH7 : (middle = observed)) (PreH8 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) middle )) (PreH9 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH10 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH11 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH12 : (p_queue_base = 0)) (PreH13 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))) (PreH14 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup middle )
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
|--
  EX (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) X_init_cleanup ) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed final ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup final )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre ( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)) )
) \/
(
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_front: Z) (p_queue_rear: Z) (p_queue_max_len: Z) (p_queue_base: Z) (p_queue_sem_blank: Z) (p_queue_sem_data: Z) (middle:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : (p_queue_sem_data <= INT_MAX)) (PreH2 : (p_queue_sem_blank <= INT_MAX)) (PreH3 : (p_queue_sem_data >= INT_MIN)) (PreH4 : (p_queue_sem_blank >= INT_MIN)) (PreH5 : (p_queue_sem_data < 0)) (PreH6 : (p_queue_pre <> 0)) (PreH7 : (addr_aligned p_queue_pre 4 )) (PreH8 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH9 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH10 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) < 0)) (PreH11 : (middle = observed)) (PreH12 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) middle )) (PreH13 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH14 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH15 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH16 : (p_queue_base = 0)) (PreH17 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))) (PreH18 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup middle )
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
|--
  EX (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) X_init_cleanup ) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed final ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup final )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre ( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)) )
).

Definition DeInitDataqueue_return_wit_1 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) X_init_cleanup )) (PreH2 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed final )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg_init_cleanup final )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre ( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)) )
|--
  EX (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( MonadErr.ret  (tt)) X_init_cleanup ) ”
  &&  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre ( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)) )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg_init_cleanup after )
.

Definition DeInitDataqueue_partial_solve_wit_1 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )),
  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre q_init_cleanup )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg_init_cleanup before_init_cleanup )
|--
  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg_init_cleanup before_init_cleanup )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre q_init_cleanup )
.

Definition DeInitDataqueue_partial_solve_wit_2 :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH3 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH4 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )),
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre q_init_cleanup )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup ) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed ) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed ) ”
  &&  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre q_init_cleanup )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
.

Definition DeInitDataqueue_partial_solve_wit_3_pure :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (saved: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_pre <> 0)) (PreH2 : (addr_aligned p_queue_pre 4 )) (PreH3 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH4 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH5 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH6 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH7 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH8 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH9 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) <> 0)) (PreH10 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH12 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH13 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH15 : (p_queue_base <> 0)),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  (CharArray.undef_full ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)) * 8 ) )
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
|--
  “ (p_queue_base <> 0) ”
  &&  “ (0 < (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)) * 8 )) ”
.

Definition DeInitDataqueue_partial_solve_wit_3_aux :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_pre <> 0)) (PreH2 : (addr_aligned p_queue_pre 4 )) (PreH3 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH4 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH5 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH6 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH7 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH8 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH9 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) <> 0)) (PreH10 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH12 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH13 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH15 : (p_queue_base <> 0)),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  (CharArray.undef_full ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)) * 8 ) )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
|--
  “ (p_queue_base <> 0) ”
  &&  “ (0 < (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)) * 8 )) ”
  &&  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup))) ”
  &&  “ (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup))) ”
  &&  “ (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup))) ”
  &&  “ (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup))) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup))) ”
  &&  “ (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) <> 0) ”
  &&  “ (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup))) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup ) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed ) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed ) ”
  &&  “ (p_queue_base <> 0) ”
  &&  (CharArray.undef_full p_queue_base (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)) * 8 ) )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
.

Definition DeInitDataqueue_partial_solve_wit_3 := DeInitDataqueue_partial_solve_wit_3_pure -> DeInitDataqueue_partial_solve_wit_3_aux.

Definition DeInitDataqueue_partial_solve_wit_4_pure :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (saved: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_sem_blank >= 0)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH5 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH6 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH7 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH8 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH9 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH10 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) = 0)) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH12 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH13 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH15 : (p_queue_base = 0)),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
|--
  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  p_queue_sem_blank observed ) ”
.

Definition DeInitDataqueue_partial_solve_wit_4_aux :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_sem_blank >= 0)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH5 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH6 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH7 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH8 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH9 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH10 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) = 0)) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH12 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH13 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH15 : (p_queue_base = 0)),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
|--
  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  p_queue_sem_blank observed ) ”
  &&  “ (p_queue_sem_blank >= 0) ”
  &&  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup))) ”
  &&  “ (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup))) ”
  &&  “ (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup))) ”
  &&  “ (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup))) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup))) ”
  &&  “ (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) = 0) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup ) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed ) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed ) ”
  &&  “ (p_queue_base = 0) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
.

Definition DeInitDataqueue_partial_solve_wit_4 := DeInitDataqueue_partial_solve_wit_4_pure -> DeInitDataqueue_partial_solve_wit_4_aux.

Definition DeInitDataqueue_partial_solve_wit_5_pure :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (saved: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_sem_blank >= 0)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH5 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH6 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH7 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH8 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH9 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH10 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) <> 0)) (PreH11 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH12 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH13 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH15 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH16 : (p_queue_base <> 0)),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
|--
  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  p_queue_sem_blank observed ) ”
.

Definition DeInitDataqueue_partial_solve_wit_5_aux :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_sem_blank >= 0)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH5 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH6 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH7 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)))) (PreH8 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH9 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))) (PreH10 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) <> 0)) (PreH11 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH12 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH13 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH14 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed )) (PreH15 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed )) (PreH16 : (p_queue_base <> 0)),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
|--
  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  p_queue_sem_blank observed ) ”
  &&  “ (p_queue_sem_blank >= 0) ”
  &&  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup))) ”
  &&  “ (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup))) ”
  &&  “ (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup))) ”
  &&  “ (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup))) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup))) ”
  &&  “ (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) <> 0) ”
  &&  “ (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup))) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup ) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed ) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) observed ) ”
  &&  “ (p_queue_base <> 0) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup observed )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
.

Definition DeInitDataqueue_partial_solve_wit_5 := DeInitDataqueue_partial_solve_wit_5_pure -> DeInitDataqueue_partial_solve_wit_5_aux.

Definition DeInitDataqueue_partial_solve_wit_6_pure :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (saved: Z) (p_queue_front: Z) (p_queue_rear: Z) (p_queue_max_len: Z) (p_queue_base: Z) (p_queue_sem_blank: Z) (p_queue_sem_data: Z) (middle:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : (p_queue_sem_data >= 0)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH5 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH6 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH7 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed middle )) (PreH8 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) middle )) (PreH9 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH10 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH11 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH12 : (p_queue_base = 0)) (PreH13 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))) (PreH14 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup middle )
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
|--
  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  p_queue_sem_data middle ) ”
.

Definition DeInitDataqueue_partial_solve_wit_6_aux :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_front: Z) (p_queue_rear: Z) (p_queue_max_len: Z) (p_queue_base: Z) (p_queue_sem_blank: Z) (p_queue_sem_data: Z) (middle:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : (p_queue_sem_data >= 0)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH5 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH6 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)))) (PreH7 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed middle )) (PreH8 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) middle )) (PreH9 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH10 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH11 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH12 : (p_queue_base = 0)) (PreH13 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))) (PreH14 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup middle )
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
|--
  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  p_queue_sem_data middle ) ”
  &&  “ (p_queue_sem_data >= 0) ”
  &&  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup ) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup))) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_ic_effect  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) observed middle ) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) middle ) ”
  &&  “ (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup))) ”
  &&  “ (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup))) ”
  &&  “ (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup))) ”
  &&  “ (p_queue_base = 0) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup))))) ”
  &&  “ (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup))) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup middle )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
.

Definition DeInitDataqueue_partial_solve_wit_6 := DeInitDataqueue_partial_solve_wit_6_pure -> DeInitDataqueue_partial_solve_wit_6_aux.

Definition DeInitDataqueue_partial_solve_wit_7_pure :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (saved: Z) (p_queue_front: Z) (p_queue_rear: Z) (p_queue_max_len: Z) (p_queue_base: Z) (p_queue_sem_blank: Z) (p_queue_sem_data: Z) (middle:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : (p_queue_sem_data >= 0)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH5 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) < 0)) (PreH7 : (middle = observed)) (PreH8 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) middle )) (PreH9 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH10 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH11 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH12 : (p_queue_base = 0)) (PreH13 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))) (PreH14 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup middle )
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
|--
  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  p_queue_sem_data middle ) ”
.

Definition DeInitDataqueue_partial_solve_wit_7_aux :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (refs_init_cleanup:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (before_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (p_queue_front: Z) (p_queue_rear: Z) (p_queue_max_len: Z) (p_queue_base: Z) (p_queue_sem_blank: Z) (p_queue_sem_data: Z) (middle:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : (p_queue_sem_data >= 0)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed )) (PreH5 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup )) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) < 0)) (PreH7 : (middle = observed)) (PreH8 : ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) middle )) (PreH9 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup)))) (PreH10 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup)))) (PreH11 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)))) (PreH12 : (p_queue_base = 0)) (PreH13 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)))))) (PreH14 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)))),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup middle )
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
|--
  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  p_queue_sem_data middle ) ”
  &&  “ (p_queue_sem_data >= 0) ”
  &&  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before_init_cleanup observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before_init_cleanup)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg_init_cleanup) (p_queue_pre) (q_init_cleanup) (refs_init_cleanup)) X_init_cleanup ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup)) < 0) ”
  &&  “ (middle = observed) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreDelete.semaphore_delete_quiescent  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup)) middle ) ”
  &&  “ (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup))) ”
  &&  “ (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup))) ”
  &&  “ (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup))) ”
  &&  “ (p_queue_base = 0) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup))))) ”
  &&  “ (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup))) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup middle )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
.

Definition DeInitDataqueue_partial_solve_wit_7 := DeInitDataqueue_partial_solve_wit_7_pure -> DeInitDataqueue_partial_solve_wit_7_aux.

Definition DeInitDataqueue_partial_solve_wit_8_pure :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (saved: Z) (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) X_init_cleanup )) (PreH2 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed final )),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup final )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre ( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)) )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed final ) ”
.

Definition DeInitDataqueue_partial_solve_wit_8_aux :=
forall (X_init_cleanup: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (sg_init_cleanup:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) X_init_cleanup )) (PreH2 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed final )),
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup final )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre ( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)) )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed final ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) X_init_cleanup ) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed final ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg_init_cleanup observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg_init_cleanup final )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre ( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_init_cleanup)) )
.

Definition DeInitDataqueue_partial_solve_wit_8 := DeInitDataqueue_partial_solve_wit_8_pure -> DeInitDataqueue_partial_solve_wit_8_aux.

Definition DeInitDataqueue_which_implies_wit_1 :=
forall (q_init_cleanup:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue: Z),
  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue q_init_cleanup )
|--
  (EX (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z),
  “ (p_queue <> 0) ”
  &&  “ (addr_aligned p_queue 4 ) ”
  &&  “ (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup))) ”
  &&  “ (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup))) ”
  &&  “ (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup))) ”
  &&  “ (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup))) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup))) ”
  &&  “ (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) = 0) ”
  &&  ((&((p_queue)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue + (6 * sizeof(CHAR))) 2 ))
  ||
  (EX (p_queue_sem_data_2: Z) (p_queue_sem_blank_2: Z) (p_queue_base_2: Z) (p_queue_max_len_2: Z) (p_queue_rear_2: Z) (p_queue_front_2: Z),
  “ (p_queue <> 0) ”
  &&  “ (addr_aligned p_queue 4 ) ”
  &&  “ (p_queue_front_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_init_cleanup))) ”
  &&  “ (p_queue_rear_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_init_cleanup))) ”
  &&  “ (p_queue_max_len_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup))) ”
  &&  “ (p_queue_base_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup))) ”
  &&  “ (p_queue_sem_blank_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_init_cleanup))) ”
  &&  “ (p_queue_sem_data_2 = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_init_cleanup))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) <> 0) ”
  &&  “ (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup))) ”
  &&  ((&((p_queue)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front_2)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear_2)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len_2)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base_2)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank_2)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data_2)
  **  (CharArray.undef_full (p_queue + (6 * sizeof(CHAR))) 2 )
  **  (CharArray.undef_full ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_init_cleanup)) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_init_cleanup)) * 8 ) ))
.

Module Type VC_Correct.


Axiom proof_of_DeInitDataqueue_safety_wit_1 : DeInitDataqueue_safety_wit_1.
Axiom proof_of_DeInitDataqueue_safety_wit_2 : DeInitDataqueue_safety_wit_2.
Axiom proof_of_DeInitDataqueue_safety_wit_3 : DeInitDataqueue_safety_wit_3.
Axiom proof_of_DeInitDataqueue_safety_wit_4 : DeInitDataqueue_safety_wit_4.
Axiom proof_of_DeInitDataqueue_safety_wit_5 : DeInitDataqueue_safety_wit_5.
Axiom proof_of_DeInitDataqueue_safety_wit_6 : DeInitDataqueue_safety_wit_6.
Axiom proof_of_DeInitDataqueue_safety_wit_7 : DeInitDataqueue_safety_wit_7.
Axiom proof_of_DeInitDataqueue_safety_wit_8 : DeInitDataqueue_safety_wit_8.
Axiom proof_of_DeInitDataqueue_safety_wit_9 : DeInitDataqueue_safety_wit_9.
Axiom proof_of_DeInitDataqueue_safety_wit_10 : DeInitDataqueue_safety_wit_10.
Axiom proof_of_DeInitDataqueue_safety_wit_11 : DeInitDataqueue_safety_wit_11.
Axiom proof_of_DeInitDataqueue_safety_wit_12 : DeInitDataqueue_safety_wit_12.
Axiom proof_of_DeInitDataqueue_safety_wit_13 : DeInitDataqueue_safety_wit_13.
Axiom proof_of_DeInitDataqueue_safety_wit_14 : DeInitDataqueue_safety_wit_14.
Axiom proof_of_DeInitDataqueue_safety_wit_15 : DeInitDataqueue_safety_wit_15.
Axiom proof_of_DeInitDataqueue_safety_wit_16 : DeInitDataqueue_safety_wit_16.
Axiom proof_of_DeInitDataqueue_entail_wit_1 : DeInitDataqueue_entail_wit_1.
Axiom proof_of_DeInitDataqueue_entail_wit_2_1 : DeInitDataqueue_entail_wit_2_1.
Axiom proof_of_DeInitDataqueue_entail_wit_2_2 : DeInitDataqueue_entail_wit_2_2.
Axiom proof_of_DeInitDataqueue_entail_wit_3_1 : DeInitDataqueue_entail_wit_3_1.
Axiom proof_of_DeInitDataqueue_entail_wit_3_2 : DeInitDataqueue_entail_wit_3_2.
Axiom proof_of_DeInitDataqueue_entail_wit_4_1 : DeInitDataqueue_entail_wit_4_1.
Axiom proof_of_DeInitDataqueue_entail_wit_4_2 : DeInitDataqueue_entail_wit_4_2.
Axiom proof_of_DeInitDataqueue_entail_wit_4_3 : DeInitDataqueue_entail_wit_4_3.
Axiom proof_of_DeInitDataqueue_entail_wit_4_4 : DeInitDataqueue_entail_wit_4_4.
Axiom proof_of_DeInitDataqueue_entail_wit_5_1 : DeInitDataqueue_entail_wit_5_1.
Axiom proof_of_DeInitDataqueue_entail_wit_5_2 : DeInitDataqueue_entail_wit_5_2.
Axiom proof_of_DeInitDataqueue_entail_wit_5_3 : DeInitDataqueue_entail_wit_5_3.
Axiom proof_of_DeInitDataqueue_entail_wit_5_4 : DeInitDataqueue_entail_wit_5_4.
Axiom proof_of_DeInitDataqueue_return_wit_1 : DeInitDataqueue_return_wit_1.
Axiom proof_of_DeInitDataqueue_partial_solve_wit_1 : DeInitDataqueue_partial_solve_wit_1.
Axiom proof_of_DeInitDataqueue_partial_solve_wit_2 : DeInitDataqueue_partial_solve_wit_2.
Axiom proof_of_DeInitDataqueue_partial_solve_wit_3_pure : DeInitDataqueue_partial_solve_wit_3_pure.
Axiom proof_of_DeInitDataqueue_partial_solve_wit_3 : DeInitDataqueue_partial_solve_wit_3.
Axiom proof_of_DeInitDataqueue_partial_solve_wit_4_pure : DeInitDataqueue_partial_solve_wit_4_pure.
Axiom proof_of_DeInitDataqueue_partial_solve_wit_4 : DeInitDataqueue_partial_solve_wit_4.
Axiom proof_of_DeInitDataqueue_partial_solve_wit_5_pure : DeInitDataqueue_partial_solve_wit_5_pure.
Axiom proof_of_DeInitDataqueue_partial_solve_wit_5 : DeInitDataqueue_partial_solve_wit_5.
Axiom proof_of_DeInitDataqueue_partial_solve_wit_6_pure : DeInitDataqueue_partial_solve_wit_6_pure.
Axiom proof_of_DeInitDataqueue_partial_solve_wit_6 : DeInitDataqueue_partial_solve_wit_6.
Axiom proof_of_DeInitDataqueue_partial_solve_wit_7_pure : DeInitDataqueue_partial_solve_wit_7_pure.
Axiom proof_of_DeInitDataqueue_partial_solve_wit_7 : DeInitDataqueue_partial_solve_wit_7.
Axiom proof_of_DeInitDataqueue_partial_solve_wit_8_pure : DeInitDataqueue_partial_solve_wit_8_pure.
Axiom proof_of_DeInitDataqueue_partial_solve_wit_8 : DeInitDataqueue_partial_solve_wit_8.
Axiom proof_of_DeInitDataqueue_which_implies_wit_1 : DeInitDataqueue_which_implies_wit_1.

End VC_Correct.
