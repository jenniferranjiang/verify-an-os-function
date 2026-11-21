From SimpleC.Verification Require Import VCPrelude.
Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Require Import CRTOS_Verify.lib.dataqueue.KPopDataqueue CRTOS_Verify.lib.dataqueue.KPushDataqueue.
Local Open Scope sac.

(*----- Function PopDataqueue -----*)

Definition PopDataqueue_safety_wit_1 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) (abs_pop_dataqueue (sg) (p_queue_pre) (timeout_pre)) X )),
  ((( &( "lock" ) )) # Int  |->_)
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "StartAddr" ) )) # Ptr  |-> StartAddr_pre)
  **  ((( &( "size" ) )) # Ptr  |-> size_pre)
  **  ((( &( "timeout" ) )) # Int  |-> timeout_pre)
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg before )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition PopDataqueue_safety_wit_2 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (seen_id:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (saved_id: Z) (obtain_id: Z) (Y: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (PreH1 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (seen_id)) (abs_semaphore_obtain (sg) (obtain_id) (timeout_pre)) Y )) (PreH3 : forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (status)) X ))) (PreH4 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_id seen_id )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg seen_id )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "StartAddr" ) )) # Ptr  |-> StartAddr_pre)
  **  ((( &( "size" ) )) # Ptr  |-> size_pre)
  **  ((( &( "timeout" ) )) # Int  |-> timeout_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved_id)
  **  ((( &( "obtain_id" ) )) # Int  |-> obtain_id)
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
  **  ((( &( "abandon_id" ) )) # Int  |->_)
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition PopDataqueue_safety_wit_3 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (seen_id:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (saved_id: Z) (obtain_id: Z) (Y: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval: Z) (PreH1 : (0 <> retval)) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( MonadErr.ret  (retval)) Y )) (PreH3 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH4 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (seen_id)) (abs_semaphore_obtain (sg) (obtain_id) (timeout_pre)) Y )) (PreH5 : forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (status)) X ))) (PreH6 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_id seen_id )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "StartAddr" ) )) # Ptr  |-> StartAddr_pre)
  **  ((( &( "size" ) )) # Ptr  |-> size_pre)
  **  ((( &( "timeout" ) )) # Int  |-> timeout_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved_id)
  **  ((( &( "obtain_id" ) )) # Int  |-> obtain_id)
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
  **  ((( &( "abandon_id" ) )) # Int  |->_)
|--
  “ (1 <> (INT_MIN)) ”
.

Definition PopDataqueue_safety_wit_4 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (seen_id:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (saved_id: Z) (obtain_id: Z) (Y: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval: Z) (PreH1 : (0 <> retval)) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( MonadErr.ret  (retval)) Y )) (PreH3 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH4 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (seen_id)) (abs_semaphore_obtain (sg) (obtain_id) (timeout_pre)) Y )) (PreH5 : forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (status)) X ))) (PreH6 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_id seen_id )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "StartAddr" ) )) # Ptr  |-> StartAddr_pre)
  **  ((( &( "size" ) )) # Ptr  |-> size_pre)
  **  ((( &( "timeout" ) )) # Int  |-> timeout_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved_id)
  **  ((( &( "obtain_id" ) )) # Int  |-> obtain_id)
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
  **  ((( &( "abandon_id" ) )) # Int  |->_)
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition PopDataqueue_safety_wit_5 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (after_get:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (obtain_id: Z) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (saved_ring: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_front = p_queue_rear)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH5 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH6 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH7 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH8 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH9 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH10 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  after_get seen_ring )) (PreH12 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X )) (PreH13 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))) (p_queue_pre)) = (Some (q)))) (PreH14 : (dataqueue_ready q )) (PreH15 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH16 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) <= 65535)) (PreH17 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH18 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH19 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  (dataqueue_buffer q )
  **  ((( &( "StartAddr" ) )) # Ptr  |-> StartAddr_pre)
  **  ((( &( "size" ) )) # Ptr  |-> size_pre)
  **  ((( &( "timeout" ) )) # Int  |-> timeout_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved_ring)
  **  ((( &( "obtain_id" ) )) # Int  |-> obtain_id)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) ((dataqueue_pop (q)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) ((replace_dataqueues ((dataqueue_publish (p_queue_pre) ((dataqueue_pop (q))) (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))))) (seen_ring)))) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
  **  ((( &( "abandon_id" ) )) # Int  |->_)
|--
  “ False ”
.

Definition PopDataqueue_safety_wit_6 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (after_get:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (obtain_id: Z) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (saved_ring: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_front <> p_queue_rear)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH5 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH6 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH7 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH8 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH9 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH10 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  after_get seen_ring )) (PreH12 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X )) (PreH13 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))) (p_queue_pre)) = (Some (q)))) (PreH14 : (dataqueue_ready q )) (PreH15 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH16 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) <= 65535)) (PreH17 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH18 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH19 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  (dataqueue_buffer q )
  **  ((( &( "StartAddr" ) )) # Ptr  |-> StartAddr_pre)
  **  ((( &( "size" ) )) # Ptr  |-> size_pre)
  **  ((( &( "timeout" ) )) # Int  |-> timeout_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved_ring)
  **  ((( &( "obtain_id" ) )) # Int  |-> obtain_id)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (seen_ring)) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
  **  ((( &( "abandon_id" ) )) # Int  |->_)
|--
  “ False ”
.

Definition PopDataqueue_safety_wit_7 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (after_get:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (obtain_id: Z) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (saved_ring: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (PreH1 : (dataqueue_ready q )) (PreH2 : ((dataqueue_peak (q)) = (Some (e)))) (PreH3 : (p_queue_front <> p_queue_rear)) (PreH4 : (p_queue_pre <> 0)) (PreH5 : (addr_aligned p_queue_pre 4 )) (PreH6 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH7 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH8 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH9 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH10 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH11 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH12 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH13 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  after_get seen_ring )) (PreH14 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X )) (PreH15 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))) (p_queue_pre)) = (Some (q)))) (PreH16 : (dataqueue_ready q )) (PreH17 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH18 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) <= 65535)) (PreH19 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH20 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH21 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))),
  ((&(((p_queue_base + (p_queue_front * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "length")) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
  **  ((&(((p_queue_base + (p_queue_front * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "data")) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((( &( "pElem" ) )) # Ptr  |-> (p_queue_base + (p_queue_front * sizeof( "DataElem" ))))
  **  ((( &( "StartAddr" ) )) # Ptr  |-> StartAddr_pre)
  **  ((StartAddr_pre) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((( &( "size" ) )) # Ptr  |-> size_pre)
  **  ((size_pre) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
  **  (wand (dataqueue_slot (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ((Some (e)))) (dataqueue_buffer (q)) )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ((( &( "timeout" ) )) # Int  |-> timeout_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved_ring)
  **  ((( &( "obtain_id" ) )) # Int  |-> obtain_id)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) ((dataqueue_pop (q)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) ((replace_dataqueues ((dataqueue_publish (p_queue_pre) ((dataqueue_pop (q))) (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))))) (seen_ring)))) )
  **  ((( &( "abandon_id" ) )) # Int  |->_)
|--
  “ (((p_queue_front + 1 ) <> (INT_MIN)) \/ (p_queue_max_len <> (-1))) ”
  &&  “ (p_queue_max_len <> 0) ”
.

Definition PopDataqueue_safety_wit_8 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (after_get:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (obtain_id: Z) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (saved_ring: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (PreH1 : (dataqueue_ready q )) (PreH2 : ((dataqueue_peak (q)) = (Some (e)))) (PreH3 : (p_queue_front <> p_queue_rear)) (PreH4 : (p_queue_pre <> 0)) (PreH5 : (addr_aligned p_queue_pre 4 )) (PreH6 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH7 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH8 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH9 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH10 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH11 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH12 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH13 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  after_get seen_ring )) (PreH14 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X )) (PreH15 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))) (p_queue_pre)) = (Some (q)))) (PreH16 : (dataqueue_ready q )) (PreH17 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH18 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) <= 65535)) (PreH19 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH20 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH21 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))),
  ((&(((p_queue_base + (p_queue_front * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "length")) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
  **  ((&(((p_queue_base + (p_queue_front * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "data")) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((( &( "pElem" ) )) # Ptr  |-> (p_queue_base + (p_queue_front * sizeof( "DataElem" ))))
  **  ((( &( "StartAddr" ) )) # Ptr  |-> StartAddr_pre)
  **  ((StartAddr_pre) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((( &( "size" ) )) # Ptr  |-> size_pre)
  **  ((size_pre) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
  **  (wand (dataqueue_slot (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ((Some (e)))) (dataqueue_buffer (q)) )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ((( &( "timeout" ) )) # Int  |-> timeout_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved_ring)
  **  ((( &( "obtain_id" ) )) # Int  |-> obtain_id)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) ((dataqueue_pop (q)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) ((replace_dataqueues ((dataqueue_publish (p_queue_pre) ((dataqueue_pop (q))) (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))))) (seen_ring)))) )
  **  ((( &( "abandon_id" ) )) # Int  |->_)
|--
  “ ((p_queue_front + 1 ) <= INT_MAX) ”
  &&  “ ((INT_MIN) <= (p_queue_front + 1 )) ”
.

Definition PopDataqueue_safety_wit_9 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (after_get:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (obtain_id: Z) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (saved_ring: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (PreH1 : (dataqueue_ready q )) (PreH2 : ((dataqueue_peak (q)) = (Some (e)))) (PreH3 : (p_queue_front <> p_queue_rear)) (PreH4 : (p_queue_pre <> 0)) (PreH5 : (addr_aligned p_queue_pre 4 )) (PreH6 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH7 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH8 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH9 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH10 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH11 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH12 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH13 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  after_get seen_ring )) (PreH14 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X )) (PreH15 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))) (p_queue_pre)) = (Some (q)))) (PreH16 : (dataqueue_ready q )) (PreH17 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH18 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) <= 65535)) (PreH19 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH20 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH21 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))),
  ((&(((p_queue_base + (p_queue_front * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "length")) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
  **  ((&(((p_queue_base + (p_queue_front * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "data")) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((( &( "pElem" ) )) # Ptr  |-> (p_queue_base + (p_queue_front * sizeof( "DataElem" ))))
  **  ((( &( "StartAddr" ) )) # Ptr  |-> StartAddr_pre)
  **  ((StartAddr_pre) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((( &( "size" ) )) # Ptr  |-> size_pre)
  **  ((size_pre) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
  **  (wand (dataqueue_slot (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ((Some (e)))) (dataqueue_buffer (q)) )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ((( &( "timeout" ) )) # Int  |-> timeout_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved_ring)
  **  ((( &( "obtain_id" ) )) # Int  |-> obtain_id)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) ((dataqueue_pop (q)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) ((replace_dataqueues ((dataqueue_publish (p_queue_pre) ((dataqueue_pop (q))) (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))))) (seen_ring)))) )
  **  ((( &( "abandon_id" ) )) # Int  |->_)
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition PopDataqueue_safety_wit_10 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (saved_ring: Z) (item:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (obtain_id: Z) (abandon_id: Z) (after_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (result: DataqueuePopResult) (new_data: (@option Z)) (new_length: (@option Z)) (Y_finish: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval: Z) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( MonadErr.ret  (retval)) Y_finish )) (PreH2 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH3 : (abandon_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH4 : (result = (DqPopItem (item)))) (PreH5 : (new_data = (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (item)))))) (PreH6 : (new_length = (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (item)))))) (PreH7 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_ring)) (abs_semaphore_abandon (sg) (abandon_id)) Y_finish )) (PreH8 : forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y_finish ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (result)) X ))) (PreH9 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_ring after_ring )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "StartAddr" ) )) # Ptr  |-> StartAddr_pre)
  **  ((( &( "size" ) )) # Ptr  |-> size_pre)
  **  ((( &( "timeout" ) )) # Int  |-> timeout_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved_ring)
  **  ((( &( "obtain_id" ) )) # Int  |-> obtain_id)
  **  ((( &( "abandon_id" ) )) # Int  |-> abandon_id)
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre new_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre new_length )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition PopDataqueue_safety_wit_11 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (saved_ring: Z) (obtain_id: Z) (abandon_id: Z) (after_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (result: DataqueuePopResult) (new_data: (@option Z)) (new_length: (@option Z)) (Y_finish: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval: Z) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( MonadErr.ret  (retval)) Y_finish )) (PreH2 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH3 : (abandon_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH4 : (result = DqPopEmpty)) (PreH5 : (new_data = old_data)) (PreH6 : (new_length = old_length)) (PreH7 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_ring)) (abs_semaphore_abandon (sg) (abandon_id)) Y_finish )) (PreH8 : forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y_finish ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (result)) X ))) (PreH9 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_ring after_ring )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "StartAddr" ) )) # Ptr  |-> StartAddr_pre)
  **  ((( &( "size" ) )) # Ptr  |-> size_pre)
  **  ((( &( "timeout" ) )) # Int  |-> timeout_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved_ring)
  **  ((( &( "obtain_id" ) )) # Int  |-> obtain_id)
  **  ((( &( "abandon_id" ) )) # Int  |-> abandon_id)
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre new_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre new_length )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition PopDataqueue_entail_wit_1 :=
(
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) (abs_pop_dataqueue (sg) (p_queue_pre) (timeout_pre)) X )),
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  EX (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (seen_id:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before seen_id ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) (abs_pop_dataqueue (sg) (p_queue_pre) (timeout_pre)) X ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_id))) (p_queue_pre)) = (Some (q_id))) ”
  &&  “ (dataqueue_ready q_id ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_id )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre q_id )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q_id)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (seen_id)) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
) \/
(
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) (abs_pop_dataqueue (sg) (p_queue_pre) (timeout_pre)) X )),
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  EX (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (seen_id:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before seen_id ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) (abs_pop_dataqueue (sg) (p_queue_pre) (timeout_pre)) X ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_id))) (p_queue_pre)) = (Some (q_id))) ”
  &&  “ (dataqueue_ready q_id ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_id )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre q_id )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q_id)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (seen_id)) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
).

Definition PopDataqueue_entail_wit_2 :=
(
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (seen_id:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_pre <> 0)) (PreH2 : (addr_aligned p_queue_pre 4 )) (PreH3 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_id)))) (PreH4 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_id)))) (PreH5 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_id)))) (PreH6 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_id)))) (PreH7 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_id)))) (PreH8 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH9 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before seen_id )) (PreH10 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) (abs_pop_dataqueue (sg) (p_queue_pre) (timeout_pre)) X )) (PreH11 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_id))) (p_queue_pre)) = (Some (q_id)))) (PreH12 : (dataqueue_ready q_id )),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  (dataqueue_buffer q_id )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_id )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q_id)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (seen_id)) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  EX (Y: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))),
  “ (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id))) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (seen_id)) (abs_semaphore_obtain (sg) (p_queue_sem_data) (timeout_pre)) Y ) ”
  &&  “ forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (status)) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_id seen_id ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_id )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg seen_id )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
) \/
(
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (seen_id:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_sem_data <= INT_MAX)) (PreH2 : (p_queue_sem_blank <= INT_MAX)) (PreH3 : (p_queue_sem_data >= INT_MIN)) (PreH4 : (p_queue_sem_blank >= INT_MIN)) (PreH5 : (p_queue_pre <> 0)) (PreH6 : (addr_aligned p_queue_pre 4 )) (PreH7 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_id)))) (PreH8 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_id)))) (PreH9 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_id)))) (PreH10 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_id)))) (PreH11 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_id)))) (PreH12 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH13 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before seen_id )) (PreH14 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) (abs_pop_dataqueue (sg) (p_queue_pre) (timeout_pre)) X )) (PreH15 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_id))) (p_queue_pre)) = (Some (q_id)))) (PreH16 : (dataqueue_ready q_id )),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  (dataqueue_buffer q_id )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_id )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q_id)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (seen_id)) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  EX (Y: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))),
  “ (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id))) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (seen_id)) (abs_semaphore_obtain (sg) (p_queue_sem_data) (timeout_pre)) Y ) ”
  &&  “ forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (status)) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_id seen_id ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_id )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg seen_id )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
).

Definition PopDataqueue_entail_wit_3 :=
(
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (seen_id:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (obtain_id: Z) (Y: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval: Z) (PreH1 : (0 = retval)) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( MonadErr.ret  (retval)) Y )) (PreH3 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH4 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (seen_id)) (abs_semaphore_obtain (sg) (obtain_id) (timeout_pre)) Y )) (PreH5 : forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (status)) X ))) (PreH6 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_id seen_id )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  EX (after_get:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id))) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_get )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
) \/
(
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (timeout_pre: Z) (seen_id:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (obtain_id: Z) (Y: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval: Z) (PreH1 : (0 = retval)) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( MonadErr.ret  (retval)) Y )) (PreH3 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH4 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (seen_id)) (abs_semaphore_obtain (sg) (obtain_id) (timeout_pre)) Y )) (PreH5 : forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (status)) X ))) (PreH6 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_id seen_id )),
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X ) ”
  &&  emp
).

Definition PopDataqueue_entail_wit_3_split_goal_1 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (timeout_pre: Z) (seen_id:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (obtain_id: Z) (Y: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval: Z) (PreH1 : (0 = retval)) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( MonadErr.ret  (retval)) Y )) (PreH3 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH4 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (seen_id)) (abs_semaphore_obtain (sg) (obtain_id) (timeout_pre)) Y )) (PreH5 : forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (status)) X ))) (PreH6 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_id seen_id )),
  ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X )
.

Definition PopDataqueue_entail_wit_4 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (obtain_id: Z) (after_get:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  after_get observed )) (PreH2 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH3 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X )),
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  (EX (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id))) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  after_get seen_ring ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))) (p_queue_pre)) = (Some (q))) ”
  &&  “ (dataqueue_ready q ) ”
  &&  “ (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) <= 65535) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q))) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre q )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) ((dataqueue_pop (q)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) ((replace_dataqueues ((dataqueue_publish (p_queue_pre) ((dataqueue_pop (q))) (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))))) (seen_ring)))) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length ))
  ||
  (EX (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id))) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  after_get seen_ring ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))) (p_queue_pre)) = (Some (q))) ”
  &&  “ (dataqueue_ready q ) ”
  &&  “ (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) <= 65535) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q))) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre q )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (seen_ring)) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length ))
.

Definition PopDataqueue_entail_wit_5_1 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (after_get:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (obtain_id: Z) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (PreH1 : (dataqueue_ready q )) (PreH2 : ((dataqueue_peak (q)) = (Some (e)))) (PreH3 : (p_queue_front <> p_queue_rear)) (PreH4 : (p_queue_pre <> 0)) (PreH5 : (addr_aligned p_queue_pre 4 )) (PreH6 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH7 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH8 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH9 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH10 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH11 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH12 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH13 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  after_get seen_ring )) (PreH14 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X )) (PreH15 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))) (p_queue_pre)) = (Some (q)))) (PreH16 : (dataqueue_ready q )) (PreH17 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH18 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) <= 65535)) (PreH19 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH20 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH21 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))),
  ((&(((p_queue_base + (p_queue_front * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "length")) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
  **  ((&(((p_queue_base + (p_queue_front * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "data")) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((StartAddr_pre) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((size_pre) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
  **  (wand (dataqueue_slot (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ((Some (e)))) (dataqueue_buffer (q)) )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> (unsigned_last_nbits (((p_queue_front + 1 ) % ( p_queue_max_len ) )) (16)))
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) ((dataqueue_pop (q)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) ((replace_dataqueues ((dataqueue_publish (p_queue_pre) ((dataqueue_pop (q))) (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))))) (seen_ring)))) )
|--
  (EX (after_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (Y_finish: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (new_length: (@option Z)) (new_data: (@option Z)) (item:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (result: DataqueuePopResult),
  “ (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id))) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (result = (DqPopItem (item))) ”
  &&  “ (new_data = (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (item))))) ”
  &&  “ (new_length = (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (item))))) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_ring)) (abs_semaphore_abandon (sg) (p_queue_sem_blank)) Y_finish ) ”
  &&  “ forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y_finish ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (result)) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_ring after_ring ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after_ring )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre new_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre new_length ))
  ||
  (EX (after_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (Y_finish: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (new_length: (@option Z)) (new_data: (@option Z)) (result: DataqueuePopResult),
  “ (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id))) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (result = DqPopEmpty) ”
  &&  “ (new_data = old_data) ”
  &&  “ (new_length = old_length) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_ring)) (abs_semaphore_abandon (sg) (p_queue_sem_blank)) Y_finish ) ”
  &&  “ forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y_finish ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (result)) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_ring after_ring ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after_ring )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre new_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre new_length ))
.

Definition PopDataqueue_entail_wit_5_2 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (after_get:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (obtain_id: Z) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_front = p_queue_rear)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH5 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH6 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH7 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH8 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH9 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH10 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  after_get seen_ring )) (PreH12 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X )) (PreH13 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))) (p_queue_pre)) = (Some (q)))) (PreH14 : (dataqueue_ready q )) (PreH15 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH16 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) <= 65535)) (PreH17 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH18 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH19 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  (dataqueue_buffer q )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (seen_ring)) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  (EX (after_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (Y_finish: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (new_length: (@option Z)) (new_data: (@option Z)) (item:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (result: DataqueuePopResult),
  “ (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id))) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (result = (DqPopItem (item))) ”
  &&  “ (new_data = (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (item))))) ”
  &&  “ (new_length = (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (item))))) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_ring)) (abs_semaphore_abandon (sg) (p_queue_sem_blank)) Y_finish ) ”
  &&  “ forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y_finish ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (result)) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_ring after_ring ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after_ring )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre new_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre new_length ))
  ||
  (EX (after_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (Y_finish: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (new_length: (@option Z)) (new_data: (@option Z)) (result: DataqueuePopResult),
  “ (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id))) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (result = DqPopEmpty) ”
  &&  “ (new_data = old_data) ”
  &&  “ (new_length = old_length) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_ring)) (abs_semaphore_abandon (sg) (p_queue_sem_blank)) Y_finish ) ”
  &&  “ forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y_finish ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (result)) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_ring after_ring ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after_ring )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre new_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre new_length ))
.

Definition PopDataqueue_return_wit_1 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (StartAddr_pre: Z) (size_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (item:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (obtain_id: Z) (abandon_id: Z) (after_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (result: DataqueuePopResult) (new_data: (@option Z)) (new_length: (@option Z)) (Y_finish: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (after_4:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval: Z) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_4)) ( MonadErr.ret  (retval)) Y_finish )) (PreH2 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH3 : (abandon_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH4 : (result = (DqPopItem (item)))) (PreH5 : (new_data = (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (item)))))) (PreH6 : (new_length = (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (item)))))) (PreH7 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_ring)) (abs_semaphore_abandon (sg) (abandon_id)) Y_finish )) (PreH8 : forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y_finish ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (result)) X ))) (PreH9 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_ring after_ring )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_4 )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre new_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre new_length )
|--
  (EX (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ (0 = 0) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_2)) ( MonadErr.ret  (DqPopEmpty)) X ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_2 )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length ))
  ||
  (EX (after_3:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ),
  “ (0 = 0) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_3)) ( MonadErr.ret  ((DqPopItem (e)))) X ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_3 )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))) ))
.

Definition PopDataqueue_return_wit_2 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (StartAddr_pre: Z) (size_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (obtain_id: Z) (abandon_id: Z) (after_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (result: DataqueuePopResult) (new_data: (@option Z)) (new_length: (@option Z)) (Y_finish: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (after_4:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval: Z) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_4)) ( MonadErr.ret  (retval)) Y_finish )) (PreH2 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH3 : (abandon_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH4 : (result = DqPopEmpty)) (PreH5 : (new_data = old_data)) (PreH6 : (new_length = old_length)) (PreH7 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_ring)) (abs_semaphore_abandon (sg) (abandon_id)) Y_finish )) (PreH8 : forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y_finish ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (result)) X ))) (PreH9 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_ring after_ring )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_4 )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre new_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre new_length )
|--
  (EX (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ (0 = 0) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_2)) ( MonadErr.ret  (DqPopEmpty)) X ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_2 )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length ))
  ||
  (EX (after_3:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ),
  “ (0 = 0) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_3)) ( MonadErr.ret  ((DqPopItem (e)))) X ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_3 )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))) ))
.

Definition PopDataqueue_return_wit_3 :=
(
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (seen_id:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (obtain_id: Z) (Y: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (after_4:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval: Z) (PreH1 : (0 <> retval)) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_4)) ( MonadErr.ret  (retval)) Y )) (PreH3 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH4 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (seen_id)) (abs_semaphore_obtain (sg) (obtain_id) (timeout_pre)) Y )) (PreH5 : forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (status)) X ))) (PreH6 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_id seen_id )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_4 )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  EX (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ ((-1) = (-1)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( MonadErr.ret  (DqPopFailed)) X ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
) \/
(
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (timeout_pre: Z) (seen_id:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (obtain_id: Z) (Y: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (after_4:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval: Z) (PreH1 : (0 <> retval)) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_4)) ( MonadErr.ret  (retval)) Y )) (PreH3 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH4 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (seen_id)) (abs_semaphore_obtain (sg) (obtain_id) (timeout_pre)) Y )) (PreH5 : forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (status)) X ))) (PreH6 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_id seen_id )),
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_4)) ( MonadErr.ret  (DqPopFailed)) X ) ”
  &&  emp
).

Definition PopDataqueue_return_wit_3_split_goal_1 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (timeout_pre: Z) (seen_id:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (obtain_id: Z) (Y: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (after_4:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval: Z) (PreH1 : (0 <> retval)) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_4)) ( MonadErr.ret  (retval)) Y )) (PreH3 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH4 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (seen_id)) (abs_semaphore_obtain (sg) (obtain_id) (timeout_pre)) Y )) (PreH5 : forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (status)) X ))) (PreH6 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_id seen_id )),
  ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_4)) ( MonadErr.ret  (DqPopFailed)) X )
.

Definition PopDataqueue_partial_solve_wit_1 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) (abs_pop_dataqueue (sg) (p_queue_pre) (timeout_pre)) X )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg before )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) (abs_pop_dataqueue (sg) (p_queue_pre) (timeout_pre)) X ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg before )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
.

Definition PopDataqueue_partial_solve_wit_2 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (seen_id:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (PreH1 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before seen_id )) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) (abs_pop_dataqueue (sg) (p_queue_pre) (timeout_pre)) X )) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_id))) (p_queue_pre)) = (Some (q_id)))) (PreH4 : (dataqueue_ready q_id )),
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_id )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre q_id )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q_id)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (seen_id)) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before seen_id ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) (abs_pop_dataqueue (sg) (p_queue_pre) (timeout_pre)) X ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_id))) (p_queue_pre)) = (Some (q_id))) ”
  &&  “ (dataqueue_ready q_id ) ”
  &&  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre q_id )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_id )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q_id)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (seen_id)) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
.

Definition PopDataqueue_partial_solve_wit_3_pure :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (seen_id:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (saved_id: Z) (obtain_id: Z) (Y: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (PreH1 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (seen_id)) (abs_semaphore_obtain (sg) (obtain_id) (timeout_pre)) Y )) (PreH3 : forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (status)) X ))) (PreH4 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_id seen_id )),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "StartAddr" ) )) # Ptr  |-> StartAddr_pre)
  **  ((( &( "size" ) )) # Ptr  |-> size_pre)
  **  ((( &( "timeout" ) )) # Int  |-> timeout_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved_id)
  **  ((( &( "obtain_id" ) )) # Int  |-> obtain_id)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_id )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg seen_id )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
  **  ((( &( "abandon_id" ) )) # Int  |->_)
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_id seen_id ) ”
.

Definition PopDataqueue_partial_solve_wit_3_aux :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (seen_id:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (obtain_id: Z) (Y: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (PreH1 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (seen_id)) (abs_semaphore_obtain (sg) (obtain_id) (timeout_pre)) Y )) (PreH3 : forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (status)) X ))) (PreH4 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_id seen_id )),
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_id )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg seen_id )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_id seen_id ) ”
  &&  “ (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id))) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (seen_id)) (abs_semaphore_obtain (sg) (obtain_id) (timeout_pre)) Y ) ”
  &&  “ forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (status)) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_id seen_id ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_id )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg seen_id )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
.

Definition PopDataqueue_partial_solve_wit_3 := PopDataqueue_partial_solve_wit_3_pure -> PopDataqueue_partial_solve_wit_3_aux.

Definition PopDataqueue_partial_solve_wit_4_pure :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (seen_id:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (saved_id: Z) (obtain_id: Z) (Y: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (PreH1 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (seen_id)) (abs_semaphore_obtain (sg) (obtain_id) (timeout_pre)) Y )) (PreH3 : forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (status)) X ))) (PreH4 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_id seen_id )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg seen_id )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "StartAddr" ) )) # Ptr  |-> StartAddr_pre)
  **  ((( &( "size" ) )) # Ptr  |-> size_pre)
  **  ((( &( "timeout" ) )) # Int  |-> timeout_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved_id)
  **  ((( &( "obtain_id" ) )) # Int  |-> obtain_id)
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
  **  ((( &( "abandon_id" ) )) # Int  |->_)
|--
  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (seen_id)) (abs_semaphore_obtain (sg) (obtain_id) (timeout_pre)) Y ) ”
.

Definition PopDataqueue_partial_solve_wit_4_aux :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (seen_id:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (obtain_id: Z) (Y: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (PreH1 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (seen_id)) (abs_semaphore_obtain (sg) (obtain_id) (timeout_pre)) Y )) (PreH3 : forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (status)) X ))) (PreH4 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_id seen_id )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg seen_id )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (seen_id)) (abs_semaphore_obtain (sg) (obtain_id) (timeout_pre)) Y ) ”
  &&  “ (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id))) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (seen_id)) (abs_semaphore_obtain (sg) (obtain_id) (timeout_pre)) Y ) ”
  &&  “ forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (status)) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_id seen_id ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg seen_id )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
.

Definition PopDataqueue_partial_solve_wit_4 := PopDataqueue_partial_solve_wit_4_pure -> PopDataqueue_partial_solve_wit_4_aux.

Definition PopDataqueue_partial_solve_wit_5 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (obtain_id: Z) (after_get:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_get )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  “ (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id))) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_get )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
.

Definition PopDataqueue_partial_solve_wit_6 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (after_get:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (obtain_id: Z) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (PreH1 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH2 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  after_get seen_ring )) (PreH3 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X )) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))) (p_queue_pre)) = (Some (q)))) (PreH5 : (dataqueue_ready q )) (PreH6 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH7 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) <= 65535)) (PreH8 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH9 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH10 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))),
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre q )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (seen_ring)) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  “ (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id))) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  after_get seen_ring ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))) (p_queue_pre)) = (Some (q))) ”
  &&  “ (dataqueue_ready q ) ”
  &&  “ (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) <= 65535) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q))) ”
  &&  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre q )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (seen_ring)) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
.

Definition PopDataqueue_partial_solve_wit_7 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (after_get:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (obtain_id: Z) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (PreH1 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH2 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  after_get seen_ring )) (PreH3 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X )) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))) (p_queue_pre)) = (Some (q)))) (PreH5 : (dataqueue_ready q )) (PreH6 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH7 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) <= 65535)) (PreH8 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH9 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH10 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))),
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre q )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) ((dataqueue_pop (q)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) ((replace_dataqueues ((dataqueue_publish (p_queue_pre) ((dataqueue_pop (q))) (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))))) (seen_ring)))) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  “ (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id))) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  after_get seen_ring ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))) (p_queue_pre)) = (Some (q))) ”
  &&  “ (dataqueue_ready q ) ”
  &&  “ (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) <= 65535) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q))) ”
  &&  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre q )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) ((dataqueue_pop (q)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) ((replace_dataqueues ((dataqueue_publish (p_queue_pre) ((dataqueue_pop (q))) (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))))) (seen_ring)))) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
.

Definition PopDataqueue_partial_solve_wit_8_pure :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (after_get:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (obtain_id: Z) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (saved_ring: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_front <> p_queue_rear)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH5 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH6 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH7 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH8 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH9 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH10 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  after_get seen_ring )) (PreH12 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X )) (PreH13 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))) (p_queue_pre)) = (Some (q)))) (PreH14 : (dataqueue_ready q )) (PreH15 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH16 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) <= 65535)) (PreH17 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH18 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH19 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  (dataqueue_buffer q )
  **  ((( &( "StartAddr" ) )) # Ptr  |-> StartAddr_pre)
  **  ((( &( "size" ) )) # Ptr  |-> size_pre)
  **  ((( &( "timeout" ) )) # Int  |-> timeout_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved_ring)
  **  ((( &( "obtain_id" ) )) # Int  |-> obtain_id)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) ((dataqueue_pop (q)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) ((replace_dataqueues ((dataqueue_publish (p_queue_pre) ((dataqueue_pop (q))) (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))))) (seen_ring)))) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
  **  ((( &( "abandon_id" ) )) # Int  |->_)
|--
  “ (dataqueue_ready q ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q))) ”
.

Definition PopDataqueue_partial_solve_wit_8_aux :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (after_get:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (obtain_id: Z) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_front <> p_queue_rear)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH5 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH6 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH7 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH8 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH9 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH10 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  after_get seen_ring )) (PreH12 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X )) (PreH13 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))) (p_queue_pre)) = (Some (q)))) (PreH14 : (dataqueue_ready q )) (PreH15 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH16 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) <= 65535)) (PreH17 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH18 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH19 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  (dataqueue_buffer q )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) ((dataqueue_pop (q)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) ((replace_dataqueues ((dataqueue_publish (p_queue_pre) ((dataqueue_pop (q))) (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))))) (seen_ring)))) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  “ (dataqueue_ready q ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q))) ”
  &&  “ (p_queue_front <> p_queue_rear) ”
  &&  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ”
  &&  “ (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q))) ”
  &&  “ (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q))) ”
  &&  “ (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id))) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  after_get seen_ring ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))) (p_queue_pre)) = (Some (q))) ”
  &&  “ (dataqueue_ready q ) ”
  &&  “ (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) <= 65535) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q))) ”
  &&  (dataqueue_buffer q )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) ((dataqueue_pop (q)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) ((replace_dataqueues ((dataqueue_publish (p_queue_pre) ((dataqueue_pop (q))) (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))))) (seen_ring)))) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
.

Definition PopDataqueue_partial_solve_wit_8 := PopDataqueue_partial_solve_wit_8_pure -> PopDataqueue_partial_solve_wit_8_aux.

Definition PopDataqueue_partial_solve_wit_9 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (after_get:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (obtain_id: Z) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (PreH1 : (dataqueue_ready q )) (PreH2 : ((dataqueue_peak (q)) = (Some (e)))) (PreH3 : (p_queue_front <> p_queue_rear)) (PreH4 : (p_queue_pre <> 0)) (PreH5 : (addr_aligned p_queue_pre 4 )) (PreH6 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH7 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH8 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH9 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH10 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH11 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH12 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH13 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  after_get seen_ring )) (PreH14 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X )) (PreH15 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))) (p_queue_pre)) = (Some (q)))) (PreH16 : (dataqueue_ready q )) (PreH17 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH18 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) <= 65535)) (PreH19 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH20 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH21 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))),
  (dataqueue_slot ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) (Some (e)) )
  **  (wand (dataqueue_slot (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ((Some (e)))) (dataqueue_buffer (q)) )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) ((dataqueue_pop (q)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) ((replace_dataqueues ((dataqueue_publish (p_queue_pre) ((dataqueue_pop (q))) (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))))) (seen_ring)))) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  “ (dataqueue_ready q ) ”
  &&  “ ((dataqueue_peak (q)) = (Some (e))) ”
  &&  “ (p_queue_front <> p_queue_rear) ”
  &&  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ”
  &&  “ (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q))) ”
  &&  “ (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q))) ”
  &&  “ (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id))) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  after_get seen_ring ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))) (p_queue_pre)) = (Some (q))) ”
  &&  “ (dataqueue_ready q ) ”
  &&  “ (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) <= 65535) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q))) ”
  &&  (dataqueue_slot ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) (Some (e)) )
  **  (wand (dataqueue_slot (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ((Some (e)))) (dataqueue_buffer (q)) )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) ((dataqueue_pop (q)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) ((replace_dataqueues ((dataqueue_publish (p_queue_pre) ((dataqueue_pop (q))) (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))))) (seen_ring)))) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
.

Definition PopDataqueue_partial_solve_wit_10 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (after_get:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (obtain_id: Z) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (PreH1 : (dataqueue_ready q )) (PreH2 : ((dataqueue_peak (q)) = (Some (e)))) (PreH3 : (p_queue_front <> p_queue_rear)) (PreH4 : (p_queue_pre <> 0)) (PreH5 : (addr_aligned p_queue_pre 4 )) (PreH6 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH7 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH8 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH9 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH10 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH11 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH12 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH13 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  after_get seen_ring )) (PreH14 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X )) (PreH15 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))) (p_queue_pre)) = (Some (q)))) (PreH16 : (dataqueue_ready q )) (PreH17 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH18 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) <= 65535)) (PreH19 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH20 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH21 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))),
  ((&(((( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) + (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "data")) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((&(((( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) + (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "length")) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
  **  (wand (dataqueue_slot (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ((Some (e)))) (dataqueue_buffer (q)) )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) ((dataqueue_pop (q)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) ((replace_dataqueues ((dataqueue_publish (p_queue_pre) ((dataqueue_pop (q))) (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))))) (seen_ring)))) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  “ (dataqueue_ready q ) ”
  &&  “ ((dataqueue_peak (q)) = (Some (e))) ”
  &&  “ (p_queue_front <> p_queue_rear) ”
  &&  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ”
  &&  “ (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q))) ”
  &&  “ (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q))) ”
  &&  “ (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id))) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  after_get seen_ring ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))) (p_queue_pre)) = (Some (q))) ”
  &&  “ (dataqueue_ready q ) ”
  &&  “ (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) <= 65535) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q))) ”
  &&  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
  **  ((&(((( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) + (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "data")) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((&(((( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) + (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "length")) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
  **  (wand (dataqueue_slot (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ((Some (e)))) (dataqueue_buffer (q)) )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) ((dataqueue_pop (q)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) ((replace_dataqueues ((dataqueue_publish (p_queue_pre) ((dataqueue_pop (q))) (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))))) (seen_ring)))) )
.

Definition PopDataqueue_partial_solve_wit_11 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (after_get:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (obtain_id: Z) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (PreH1 : (dataqueue_ready q )) (PreH2 : ((dataqueue_peak (q)) = (Some (e)))) (PreH3 : (p_queue_front <> p_queue_rear)) (PreH4 : (p_queue_pre <> 0)) (PreH5 : (addr_aligned p_queue_pre 4 )) (PreH6 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH7 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH8 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH9 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH10 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH11 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH12 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH13 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  after_get seen_ring )) (PreH14 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X )) (PreH15 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))) (p_queue_pre)) = (Some (q)))) (PreH16 : (dataqueue_ready q )) (PreH17 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH18 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) <= 65535)) (PreH19 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH20 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH21 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))),
  ((StartAddr_pre) # Ptr  |->_)
  **  ((size_pre) # UInt  |->_)
  **  ((&(((( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) + (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "data")) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((&(((( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) + (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "length")) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
  **  (wand (dataqueue_slot (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ((Some (e)))) (dataqueue_buffer (q)) )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) ((dataqueue_pop (q)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) ((replace_dataqueues ((dataqueue_publish (p_queue_pre) ((dataqueue_pop (q))) (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))))) (seen_ring)))) )
|--
  “ (dataqueue_ready q ) ”
  &&  “ ((dataqueue_peak (q)) = (Some (e))) ”
  &&  “ (p_queue_front <> p_queue_rear) ”
  &&  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ”
  &&  “ (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q))) ”
  &&  “ (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q))) ”
  &&  “ (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id))) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  after_get seen_ring ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))) (p_queue_pre)) = (Some (q))) ”
  &&  “ (dataqueue_ready q ) ”
  &&  “ (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) <= 65535) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q))) ”
  &&  ((&(((p_queue_base + (p_queue_front * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "data")) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((StartAddr_pre) # Ptr  |->_)
  **  ((size_pre) # UInt  |->_)
  **  ((&(((( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) + (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "length")) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
  **  (wand (dataqueue_slot (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ((Some (e)))) (dataqueue_buffer (q)) )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) ((dataqueue_pop (q)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) ((replace_dataqueues ((dataqueue_publish (p_queue_pre) ((dataqueue_pop (q))) (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))))) (seen_ring)))) )
.

Definition PopDataqueue_partial_solve_wit_12 :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (after_get:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (obtain_id: Z) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (PreH1 : (dataqueue_ready q )) (PreH2 : ((dataqueue_peak (q)) = (Some (e)))) (PreH3 : (p_queue_front <> p_queue_rear)) (PreH4 : (p_queue_pre <> 0)) (PreH5 : (addr_aligned p_queue_pre 4 )) (PreH6 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH7 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH8 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH9 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH10 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH11 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH12 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH13 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  after_get seen_ring )) (PreH14 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X )) (PreH15 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))) (p_queue_pre)) = (Some (q)))) (PreH16 : (dataqueue_ready q )) (PreH17 : (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH18 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) <= 65535)) (PreH19 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH20 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH21 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))),
  ((&(((p_queue_base + (p_queue_front * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "data")) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((StartAddr_pre) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((size_pre) # UInt  |->_)
  **  ((&(((( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) + (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "length")) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
  **  (wand (dataqueue_slot (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ((Some (e)))) (dataqueue_buffer (q)) )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) ((dataqueue_pop (q)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) ((replace_dataqueues ((dataqueue_publish (p_queue_pre) ((dataqueue_pop (q))) (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))))) (seen_ring)))) )
|--
  “ (dataqueue_ready q ) ”
  &&  “ ((dataqueue_peak (q)) = (Some (e))) ”
  &&  “ (p_queue_front <> p_queue_rear) ”
  &&  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ”
  &&  “ (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q))) ”
  &&  “ (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q))) ”
  &&  “ (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id))) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  after_get seen_ring ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_get)) (dataqueue_pop_after_obtain (sg) (p_queue_pre) (0)) X ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))) (p_queue_pre)) = (Some (q))) ”
  &&  “ (dataqueue_ready q ) ”
  &&  “ (0 < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) <= 65535) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) < ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q))) ”
  &&  ((&(((p_queue_base + (p_queue_front * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "length")) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
  **  ((&(((p_queue_base + (p_queue_front * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "data")) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((StartAddr_pre) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((size_pre) # UInt  |->_)
  **  (wand (dataqueue_slot (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ((Some (e)))) (dataqueue_buffer (q)) )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) ((dataqueue_pop (q)))) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) ((replace_dataqueues ((dataqueue_publish (p_queue_pre) ((dataqueue_pop (q))) (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (seen_ring))))) (seen_ring)))) )
.

Definition PopDataqueue_partial_solve_wit_13_pure :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (saved_ring: Z) (item:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (obtain_id: Z) (abandon_id: Z) (after_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (result: DataqueuePopResult) (new_data: (@option Z)) (new_length: (@option Z)) (Y_finish: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (PreH1 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH2 : (abandon_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH3 : (result = (DqPopItem (item)))) (PreH4 : (new_data = (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (item)))))) (PreH5 : (new_length = (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (item)))))) (PreH6 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_ring)) (abs_semaphore_abandon (sg) (abandon_id)) Y_finish )) (PreH7 : forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y_finish ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (result)) X ))) (PreH8 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_ring after_ring )),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "StartAddr" ) )) # Ptr  |-> StartAddr_pre)
  **  ((( &( "size" ) )) # Ptr  |-> size_pre)
  **  ((( &( "timeout" ) )) # Int  |-> timeout_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved_ring)
  **  ((( &( "obtain_id" ) )) # Int  |-> obtain_id)
  **  ((( &( "abandon_id" ) )) # Int  |-> abandon_id)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after_ring )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre new_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre new_length )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_ring after_ring ) ”
.

Definition PopDataqueue_partial_solve_wit_13_aux :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (StartAddr_pre: Z) (size_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (item:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (obtain_id: Z) (abandon_id: Z) (after_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (result: DataqueuePopResult) (new_data: (@option Z)) (new_length: (@option Z)) (Y_finish: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (PreH1 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH2 : (abandon_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH3 : (result = (DqPopItem (item)))) (PreH4 : (new_data = (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (item)))))) (PreH5 : (new_length = (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (item)))))) (PreH6 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_ring)) (abs_semaphore_abandon (sg) (abandon_id)) Y_finish )) (PreH7 : forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y_finish ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (result)) X ))) (PreH8 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_ring after_ring )),
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after_ring )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre new_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre new_length )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_ring after_ring ) ”
  &&  “ (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id))) ”
  &&  “ (abandon_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (result = (DqPopItem (item))) ”
  &&  “ (new_data = (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (item))))) ”
  &&  “ (new_length = (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (item))))) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_ring)) (abs_semaphore_abandon (sg) (abandon_id)) Y_finish ) ”
  &&  “ forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y_finish ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (result)) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_ring after_ring ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after_ring )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre new_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre new_length )
.

Definition PopDataqueue_partial_solve_wit_13 := PopDataqueue_partial_solve_wit_13_pure -> PopDataqueue_partial_solve_wit_13_aux.

Definition PopDataqueue_partial_solve_wit_14_pure :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (saved_ring: Z) (obtain_id: Z) (abandon_id: Z) (after_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (result: DataqueuePopResult) (new_data: (@option Z)) (new_length: (@option Z)) (Y_finish: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (PreH1 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH2 : (abandon_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH3 : (result = DqPopEmpty)) (PreH4 : (new_data = old_data)) (PreH5 : (new_length = old_length)) (PreH6 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_ring)) (abs_semaphore_abandon (sg) (abandon_id)) Y_finish )) (PreH7 : forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y_finish ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (result)) X ))) (PreH8 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_ring after_ring )),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "StartAddr" ) )) # Ptr  |-> StartAddr_pre)
  **  ((( &( "size" ) )) # Ptr  |-> size_pre)
  **  ((( &( "timeout" ) )) # Int  |-> timeout_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved_ring)
  **  ((( &( "obtain_id" ) )) # Int  |-> obtain_id)
  **  ((( &( "abandon_id" ) )) # Int  |-> abandon_id)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after_ring )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre new_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre new_length )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_ring after_ring ) ”
.

Definition PopDataqueue_partial_solve_wit_14_aux :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (StartAddr_pre: Z) (size_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (obtain_id: Z) (abandon_id: Z) (after_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (result: DataqueuePopResult) (new_data: (@option Z)) (new_length: (@option Z)) (Y_finish: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (PreH1 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH2 : (abandon_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH3 : (result = DqPopEmpty)) (PreH4 : (new_data = old_data)) (PreH5 : (new_length = old_length)) (PreH6 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_ring)) (abs_semaphore_abandon (sg) (abandon_id)) Y_finish )) (PreH7 : forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y_finish ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (result)) X ))) (PreH8 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_ring after_ring )),
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after_ring )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre new_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre new_length )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_ring after_ring ) ”
  &&  “ (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id))) ”
  &&  “ (abandon_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (result = DqPopEmpty) ”
  &&  “ (new_data = old_data) ”
  &&  “ (new_length = old_length) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_ring)) (abs_semaphore_abandon (sg) (abandon_id)) Y_finish ) ”
  &&  “ forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y_finish ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (result)) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_ring after_ring ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg seen_ring )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after_ring )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre new_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre new_length )
.

Definition PopDataqueue_partial_solve_wit_14 := PopDataqueue_partial_solve_wit_14_pure -> PopDataqueue_partial_solve_wit_14_aux.

Definition PopDataqueue_partial_solve_wit_15_pure :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (saved_ring: Z) (item:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (obtain_id: Z) (abandon_id: Z) (after_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (result: DataqueuePopResult) (new_data: (@option Z)) (new_length: (@option Z)) (Y_finish: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (PreH1 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH2 : (abandon_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH3 : (result = (DqPopItem (item)))) (PreH4 : (new_data = (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (item)))))) (PreH5 : (new_length = (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (item)))))) (PreH6 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_ring)) (abs_semaphore_abandon (sg) (abandon_id)) Y_finish )) (PreH7 : forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y_finish ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (result)) X ))) (PreH8 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_ring after_ring )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_ring )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "StartAddr" ) )) # Ptr  |-> StartAddr_pre)
  **  ((( &( "size" ) )) # Ptr  |-> size_pre)
  **  ((( &( "timeout" ) )) # Int  |-> timeout_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved_ring)
  **  ((( &( "obtain_id" ) )) # Int  |-> obtain_id)
  **  ((( &( "abandon_id" ) )) # Int  |-> abandon_id)
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre new_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre new_length )
|--
  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_ring)) (abs_semaphore_abandon (sg) (abandon_id)) Y_finish ) ”
.

Definition PopDataqueue_partial_solve_wit_15_aux :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (StartAddr_pre: Z) (size_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (item:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (obtain_id: Z) (abandon_id: Z) (after_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (result: DataqueuePopResult) (new_data: (@option Z)) (new_length: (@option Z)) (Y_finish: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (PreH1 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH2 : (abandon_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH3 : (result = (DqPopItem (item)))) (PreH4 : (new_data = (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (item)))))) (PreH5 : (new_length = (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (item)))))) (PreH6 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_ring)) (abs_semaphore_abandon (sg) (abandon_id)) Y_finish )) (PreH7 : forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y_finish ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (result)) X ))) (PreH8 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_ring after_ring )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_ring )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre new_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre new_length )
|--
  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_ring)) (abs_semaphore_abandon (sg) (abandon_id)) Y_finish ) ”
  &&  “ (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id))) ”
  &&  “ (abandon_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (result = (DqPopItem (item))) ”
  &&  “ (new_data = (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (item))))) ”
  &&  “ (new_length = (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (item))))) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_ring)) (abs_semaphore_abandon (sg) (abandon_id)) Y_finish ) ”
  &&  “ forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y_finish ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (result)) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_ring after_ring ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_ring )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre new_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre new_length )
.

Definition PopDataqueue_partial_solve_wit_15 := PopDataqueue_partial_solve_wit_15_pure -> PopDataqueue_partial_solve_wit_15_aux.

Definition PopDataqueue_partial_solve_wit_16_pure :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (timeout_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (saved_ring: Z) (obtain_id: Z) (abandon_id: Z) (after_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (result: DataqueuePopResult) (new_data: (@option Z)) (new_length: (@option Z)) (Y_finish: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (PreH1 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH2 : (abandon_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH3 : (result = DqPopEmpty)) (PreH4 : (new_data = old_data)) (PreH5 : (new_length = old_length)) (PreH6 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_ring)) (abs_semaphore_abandon (sg) (abandon_id)) Y_finish )) (PreH7 : forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y_finish ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (result)) X ))) (PreH8 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_ring after_ring )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_ring )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "StartAddr" ) )) # Ptr  |-> StartAddr_pre)
  **  ((( &( "size" ) )) # Ptr  |-> size_pre)
  **  ((( &( "timeout" ) )) # Int  |-> timeout_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved_ring)
  **  ((( &( "obtain_id" ) )) # Int  |-> obtain_id)
  **  ((( &( "abandon_id" ) )) # Int  |-> abandon_id)
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre new_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre new_length )
|--
  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_ring)) (abs_semaphore_abandon (sg) (abandon_id)) Y_finish ) ”
.

Definition PopDataqueue_partial_solve_wit_16_aux :=
forall (X: (DataqueuePopResult -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (StartAddr_pre: Z) (size_pre: Z) (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (seen_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (obtain_id: Z) (abandon_id: Z) (after_ring:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (result: DataqueuePopResult) (new_data: (@option Z)) (new_length: (@option Z)) (Y_finish: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (PreH1 : (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))) (PreH2 : (abandon_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH3 : (result = DqPopEmpty)) (PreH4 : (new_data = old_data)) (PreH5 : (new_length = old_length)) (PreH6 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_ring)) (abs_semaphore_abandon (sg) (abandon_id)) Y_finish )) (PreH7 : forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y_finish ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (result)) X ))) (PreH8 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_ring after_ring )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_ring )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre new_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre new_length )
|--
  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_ring)) (abs_semaphore_abandon (sg) (abandon_id)) Y_finish ) ”
  &&  “ (obtain_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id))) ”
  &&  “ (abandon_id = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (result = DqPopEmpty) ”
  &&  “ (new_data = old_data) ”
  &&  “ (new_length = old_length) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_ring)) (abs_semaphore_abandon (sg) (abandon_id)) Y_finish ) ”
  &&  “ forall (st:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), forall (status: Z), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (status)) Y_finish ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (st)) ( MonadErr.ret  (result)) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  seen_ring after_ring ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_ring )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre new_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre new_length )
.

Definition PopDataqueue_partial_solve_wit_16 := PopDataqueue_partial_solve_wit_16_pure -> PopDataqueue_partial_solve_wit_16_aux.

Definition PopDataqueue_which_implies_wit_1 :=
(
forall (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue: Z),
  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue q_id )
|--
  EX (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z),
  “ (p_queue <> 0) ”
  &&  “ (addr_aligned p_queue 4 ) ”
  &&  “ (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_id))) ”
  &&  “ (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_id))) ”
  &&  “ (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_id))) ”
  &&  “ (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_id))) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_id))) ”
  &&  “ (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id))) ”
  &&  ((&((p_queue)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue + (6 * sizeof(CHAR))) 2 )
  **  (dataqueue_buffer q_id )
) \/
(
forall (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue: Z),
  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue q_id )
|--
  “ (addr_aligned p_queue 4 ) ”
  &&  “ (p_queue <> 0) ”
  &&  ((&((p_queue)  # "DataQueue" ->ₛ "front")) # UShort  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_id)))
  **  ((&((p_queue)  # "DataQueue" ->ₛ "rear")) # UShort  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_id)))
  **  ((&((p_queue)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_id)))
  **  ((&((p_queue)  # "DataQueue" ->ₛ "base")) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_id)))
  **  ((&((p_queue)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_id)))
  **  ((&((p_queue)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))
  **  (CharArray.undef_full (p_queue + (6 * sizeof(CHAR))) 2 )
  **  (dataqueue_buffer q_id )
).

Definition PopDataqueue_which_implies_wit_1_split_goal_1 :=
forall (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue: Z),
  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue q_id )
|--
  “ (addr_aligned p_queue 4 ) ”
.

Definition PopDataqueue_which_implies_wit_1_split_goal_2 :=
forall (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue: Z),
  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue q_id )
|--
  “ (p_queue <> 0) ”
.

Definition PopDataqueue_which_implies_wit_1_split_goal_spatial :=
forall (q_id:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue: Z),
  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue q_id )
|--
  ((&((p_queue)  # "DataQueue" ->ₛ "front")) # UShort  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_id)))
  **  ((&((p_queue)  # "DataQueue" ->ₛ "rear")) # UShort  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_id)))
  **  ((&((p_queue)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_id)))
  **  ((&((p_queue)  # "DataQueue" ->ₛ "base")) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_id)))
  **  ((&((p_queue)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_id)))
  **  ((&((p_queue)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_id)))
  **  (CharArray.undef_full (p_queue + (6 * sizeof(CHAR))) 2 )
  **  (dataqueue_buffer q_id )
.

Definition PopDataqueue_which_implies_wit_2 :=
(
forall (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue: Z),
  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue q )
|--
  EX (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z),
  “ (p_queue <> 0) ”
  &&  “ (addr_aligned p_queue 4 ) ”
  &&  “ (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ”
  &&  “ (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q))) ”
  &&  “ (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q))) ”
  &&  ((&((p_queue)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue + (6 * sizeof(CHAR))) 2 )
  **  (dataqueue_buffer q )
) \/
(
forall (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue: Z),
  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue q )
|--
  “ (addr_aligned p_queue 4 ) ”
  &&  “ (p_queue <> 0) ”
  &&  ((&((p_queue)  # "DataQueue" ->ₛ "front")) # UShort  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))
  **  ((&((p_queue)  # "DataQueue" ->ₛ "rear")) # UShort  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))
  **  ((&((p_queue)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))
  **  ((&((p_queue)  # "DataQueue" ->ₛ "base")) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))
  **  ((&((p_queue)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))
  **  ((&((p_queue)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))
  **  (CharArray.undef_full (p_queue + (6 * sizeof(CHAR))) 2 )
  **  (dataqueue_buffer q )
).

Definition PopDataqueue_which_implies_wit_2_split_goal_1 :=
forall (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue: Z),
  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue q )
|--
  “ (addr_aligned p_queue 4 ) ”
.

Definition PopDataqueue_which_implies_wit_2_split_goal_2 :=
forall (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue: Z),
  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue q )
|--
  “ (p_queue <> 0) ”
.

Definition PopDataqueue_which_implies_wit_2_split_goal_spatial :=
forall (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue: Z),
  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue q )
|--
  ((&((p_queue)  # "DataQueue" ->ₛ "front")) # UShort  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))
  **  ((&((p_queue)  # "DataQueue" ->ₛ "rear")) # UShort  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))
  **  ((&((p_queue)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))
  **  ((&((p_queue)  # "DataQueue" ->ₛ "base")) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))
  **  ((&((p_queue)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))
  **  ((&((p_queue)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))
  **  (CharArray.undef_full (p_queue + (6 * sizeof(CHAR))) 2 )
  **  (dataqueue_buffer q )
.

Definition PopDataqueue_which_implies_wit_3 :=
(
forall (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (PreH1 : (dataqueue_ready q )) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))),
  (dataqueue_buffer q )
|--
  EX (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ),
  “ (dataqueue_ready q ) ”
  &&  “ ((dataqueue_peak (q)) = (Some (e))) ”
  &&  (dataqueue_slot ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) (Some (e)) )
  **  (wand (dataqueue_slot (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ((Some (e)))) (dataqueue_buffer (q)) )
) \/
(
forall (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (PreH1 : (dataqueue_ready q )) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))),
  (dataqueue_buffer q )
|--
  EX (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ),
  “ (dataqueue_ready q ) ”
  &&  “ ((dataqueue_peak (q)) = (Some (e))) ”
  &&  (dataqueue_slot ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) (Some (e)) )
  **  (wand (dataqueue_slot (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ((Some (e)))) (dataqueue_buffer (q)) )
).

Definition PopDataqueue_which_implies_wit_4 :=
(
forall (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ),
  (dataqueue_slot ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) (Some (e)) )
|--
  ((&(((( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) + (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "data")) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((&(((( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) + (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "length")) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
) \/
(
forall (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ),
  (dataqueue_slot ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) (Some (e)) )
|--
  ((&(((( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) + (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "data")) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((&(((( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) + (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "length")) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
).

Definition PopDataqueue_which_implies_wit_4_split_goal_spatial :=
forall (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ),
  (dataqueue_slot ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) (Some (e)) )
|--
  ((&(((( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) + (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "data")) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((&(((( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) + (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "length")) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
.

Definition PopDataqueue_which_implies_wit_5 :=
(
forall (old_length: (@option Z)) (old_data: (@option Z)) (StartAddr: Z) (size: Z),
  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size old_length )
|--
  ((StartAddr) # Ptr  |->_)
  **  ((size) # UInt  |->_)
) \/
(
forall (old_length: (@option Z)) (old_data: (@option Z)) (StartAddr: Z) (size: Z),
  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size old_length )
|--
  EX (x_2: Z) (x: Z),
  ((size) # UInt  |-> x_2)
  **  ((StartAddr) # Ptr  |-> x)
).

Module Type VC_Correct.


Axiom proof_of_PopDataqueue_safety_wit_1 : PopDataqueue_safety_wit_1.
Axiom proof_of_PopDataqueue_safety_wit_2 : PopDataqueue_safety_wit_2.
Axiom proof_of_PopDataqueue_safety_wit_3 : PopDataqueue_safety_wit_3.
Axiom proof_of_PopDataqueue_safety_wit_4 : PopDataqueue_safety_wit_4.
Axiom proof_of_PopDataqueue_safety_wit_5 : PopDataqueue_safety_wit_5.
Axiom proof_of_PopDataqueue_safety_wit_6 : PopDataqueue_safety_wit_6.
Axiom proof_of_PopDataqueue_safety_wit_7 : PopDataqueue_safety_wit_7.
Axiom proof_of_PopDataqueue_safety_wit_8 : PopDataqueue_safety_wit_8.
Axiom proof_of_PopDataqueue_safety_wit_9 : PopDataqueue_safety_wit_9.
Axiom proof_of_PopDataqueue_safety_wit_10 : PopDataqueue_safety_wit_10.
Axiom proof_of_PopDataqueue_safety_wit_11 : PopDataqueue_safety_wit_11.
Axiom proof_of_PopDataqueue_entail_wit_1 : PopDataqueue_entail_wit_1.
Axiom proof_of_PopDataqueue_entail_wit_2 : PopDataqueue_entail_wit_2.
Axiom proof_of_PopDataqueue_entail_wit_3 : PopDataqueue_entail_wit_3.
Axiom proof_of_PopDataqueue_entail_wit_4 : PopDataqueue_entail_wit_4.
Axiom proof_of_PopDataqueue_entail_wit_5_1 : PopDataqueue_entail_wit_5_1.
Axiom proof_of_PopDataqueue_entail_wit_5_2 : PopDataqueue_entail_wit_5_2.
Axiom proof_of_PopDataqueue_return_wit_1 : PopDataqueue_return_wit_1.
Axiom proof_of_PopDataqueue_return_wit_2 : PopDataqueue_return_wit_2.
Axiom proof_of_PopDataqueue_return_wit_3 : PopDataqueue_return_wit_3.
Axiom proof_of_PopDataqueue_partial_solve_wit_1 : PopDataqueue_partial_solve_wit_1.
Axiom proof_of_PopDataqueue_partial_solve_wit_2 : PopDataqueue_partial_solve_wit_2.
Axiom proof_of_PopDataqueue_partial_solve_wit_3_pure : PopDataqueue_partial_solve_wit_3_pure.
Axiom proof_of_PopDataqueue_partial_solve_wit_3 : PopDataqueue_partial_solve_wit_3.
Axiom proof_of_PopDataqueue_partial_solve_wit_4_pure : PopDataqueue_partial_solve_wit_4_pure.
Axiom proof_of_PopDataqueue_partial_solve_wit_4 : PopDataqueue_partial_solve_wit_4.
Axiom proof_of_PopDataqueue_partial_solve_wit_5 : PopDataqueue_partial_solve_wit_5.
Axiom proof_of_PopDataqueue_partial_solve_wit_6 : PopDataqueue_partial_solve_wit_6.
Axiom proof_of_PopDataqueue_partial_solve_wit_7 : PopDataqueue_partial_solve_wit_7.
Axiom proof_of_PopDataqueue_partial_solve_wit_8_pure : PopDataqueue_partial_solve_wit_8_pure.
Axiom proof_of_PopDataqueue_partial_solve_wit_8 : PopDataqueue_partial_solve_wit_8.
Axiom proof_of_PopDataqueue_partial_solve_wit_9 : PopDataqueue_partial_solve_wit_9.
Axiom proof_of_PopDataqueue_partial_solve_wit_10 : PopDataqueue_partial_solve_wit_10.
Axiom proof_of_PopDataqueue_partial_solve_wit_11 : PopDataqueue_partial_solve_wit_11.
Axiom proof_of_PopDataqueue_partial_solve_wit_12 : PopDataqueue_partial_solve_wit_12.
Axiom proof_of_PopDataqueue_partial_solve_wit_13_pure : PopDataqueue_partial_solve_wit_13_pure.
Axiom proof_of_PopDataqueue_partial_solve_wit_13 : PopDataqueue_partial_solve_wit_13.
Axiom proof_of_PopDataqueue_partial_solve_wit_14_pure : PopDataqueue_partial_solve_wit_14_pure.
Axiom proof_of_PopDataqueue_partial_solve_wit_14 : PopDataqueue_partial_solve_wit_14.
Axiom proof_of_PopDataqueue_partial_solve_wit_15_pure : PopDataqueue_partial_solve_wit_15_pure.
Axiom proof_of_PopDataqueue_partial_solve_wit_15 : PopDataqueue_partial_solve_wit_15.
Axiom proof_of_PopDataqueue_partial_solve_wit_16_pure : PopDataqueue_partial_solve_wit_16_pure.
Axiom proof_of_PopDataqueue_partial_solve_wit_16 : PopDataqueue_partial_solve_wit_16.
Axiom proof_of_PopDataqueue_which_implies_wit_1 : PopDataqueue_which_implies_wit_1.
Axiom proof_of_PopDataqueue_which_implies_wit_2 : PopDataqueue_which_implies_wit_2.
Axiom proof_of_PopDataqueue_which_implies_wit_3 : PopDataqueue_which_implies_wit_3.
Axiom proof_of_PopDataqueue_which_implies_wit_4 : PopDataqueue_which_implies_wit_4.
Axiom proof_of_PopDataqueue_which_implies_wit_5 : PopDataqueue_which_implies_wit_5.

End VC_Correct.
