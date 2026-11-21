From SimpleC.Verification Require Import VCPrelude.
Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Local Open Scope sac.

(*----- Function DataqueuePeak -----*)

Definition DataqueuePeak_safety_wit_1 :=
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X )),
  ((( &( "lock" ) )) # Int  |->_)
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "StartAddr" ) )) # Ptr  |-> StartAddr_pre)
  **  ((( &( "size" ) )) # Ptr  |-> size_pre)
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg before )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition DataqueuePeak_safety_wit_2 :=
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (saved: Z) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (pElem: Z) (PreH1 : (pElem = (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) + (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) * sizeof( "DataElem" ))))) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (observed)) ( MonadErr.ret  ((Some (e)))) X )) (PreH3 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed observed )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg observed )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "StartAddr" ) )) # Ptr  |-> StartAddr_pre)
  **  ((( &( "size" ) )) # Ptr  |-> size_pre)
  **  ((( &( "pElem" ) )) # Ptr  |-> pElem)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))) )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition DataqueuePeak_safety_wit_3 :=
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (saved: Z) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (observed)) ( MonadErr.ret  (None)) X )) (PreH2 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed observed )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg observed )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "StartAddr" ) )) # Ptr  |-> StartAddr_pre)
  **  ((( &( "size" ) )) # Ptr  |-> size_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  “ (1 <> (INT_MIN)) ”
.

Definition DataqueuePeak_safety_wit_4 :=
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (saved: Z) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (observed)) ( MonadErr.ret  (None)) X )) (PreH2 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed observed )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg observed )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "StartAddr" ) )) # Ptr  |-> StartAddr_pre)
  **  ((( &( "size" ) )) # Ptr  |-> size_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition DataqueuePeak_entail_wit_1 :=
(
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X )),
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  EX (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ),
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (observed))) (p_queue_pre)) = (Some (q))) ”
  &&  “ (dataqueue_ready q ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre q )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (observed)) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
) \/
(
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X )),
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  EX (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ),
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (observed))) (p_queue_pre)) = (Some (q))) ”
  &&  “ (dataqueue_ready q ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre q )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (observed)) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
).

Definition DataqueuePeak_entail_wit_2 :=
(
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (PreH1 : ((dataqueue_peak (q)) = (Some (e)))) (PreH2 : (p_queue_front <> p_queue_rear)) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH6 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH7 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH8 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH9 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH10 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH12 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X )) (PreH13 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (observed))) (p_queue_pre)) = (Some (q)))) (PreH14 : (dataqueue_ready q )),
  ((&(((p_queue_base + (p_queue_front * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "length")) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
  **  ((&(((p_queue_base + (p_queue_front * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "data")) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((StartAddr_pre) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((size_pre) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
  **  (wand (dataqueue_slot (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ((Some (e)))) (dataqueue_buffer (q)) )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (observed)) )
|--
  “ ((p_queue_base + (p_queue_front * sizeof( "DataElem" ))) = (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) + (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) * sizeof( "DataElem" )))) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (observed)) ( MonadErr.ret  ((Some (e)))) X ) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed observed ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))) )
) \/
(
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (PreH1 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)) <= UINT_MAX)) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)) >= 0)) (PreH3 : (p_queue_sem_data <= INT_MAX)) (PreH4 : (p_queue_sem_blank <= INT_MAX)) (PreH5 : (p_queue_sem_data >= INT_MIN)) (PreH6 : (p_queue_sem_blank >= INT_MIN)) (PreH7 : ((dataqueue_peak (q)) = (Some (e)))) (PreH8 : (p_queue_front <> p_queue_rear)) (PreH9 : (p_queue_pre <> 0)) (PreH10 : (addr_aligned p_queue_pre 4 )) (PreH11 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH12 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH13 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH14 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH15 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH16 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH17 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH18 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X )) (PreH19 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (observed))) (p_queue_pre)) = (Some (q)))) (PreH20 : (dataqueue_ready q )),
  ((&(((p_queue_base + (p_queue_front * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "length")) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
  **  ((&(((p_queue_base + (p_queue_front * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "data")) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((StartAddr_pre) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((size_pre) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
  **  (wand (dataqueue_slot (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ((Some (e)))) (dataqueue_buffer (q)) )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (observed)) )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (observed)) ( MonadErr.ret  ((Some (e)))) X ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))) )
).

Definition DataqueuePeak_entail_wit_2_split_goal_1 :=
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (PreH1 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)) <= UINT_MAX)) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)) >= 0)) (PreH3 : (p_queue_sem_data <= INT_MAX)) (PreH4 : (p_queue_sem_blank <= INT_MAX)) (PreH5 : (p_queue_sem_data >= INT_MIN)) (PreH6 : (p_queue_sem_blank >= INT_MIN)) (PreH7 : ((dataqueue_peak (q)) = (Some (e)))) (PreH8 : (p_queue_front <> p_queue_rear)) (PreH9 : (p_queue_pre <> 0)) (PreH10 : (addr_aligned p_queue_pre 4 )) (PreH11 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH12 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH13 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH14 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH15 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH16 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH17 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH18 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X )) (PreH19 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (observed))) (p_queue_pre)) = (Some (q)))) (PreH20 : (dataqueue_ready q )),
  ((&(((p_queue_base + (p_queue_front * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "length")) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
  **  ((&(((p_queue_base + (p_queue_front * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "data")) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((StartAddr_pre) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((size_pre) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
  **  (wand (dataqueue_slot (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ((Some (e)))) (dataqueue_buffer (q)) )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (observed)) )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed observed ) ”
.

Definition DataqueuePeak_entail_wit_2_split_goal_2 :=
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (PreH1 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)) <= UINT_MAX)) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)) >= 0)) (PreH3 : (p_queue_sem_data <= INT_MAX)) (PreH4 : (p_queue_sem_blank <= INT_MAX)) (PreH5 : (p_queue_sem_data >= INT_MIN)) (PreH6 : (p_queue_sem_blank >= INT_MIN)) (PreH7 : ((dataqueue_peak (q)) = (Some (e)))) (PreH8 : (p_queue_front <> p_queue_rear)) (PreH9 : (p_queue_pre <> 0)) (PreH10 : (addr_aligned p_queue_pre 4 )) (PreH11 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH12 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH13 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH14 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH15 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH16 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH17 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH18 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X )) (PreH19 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (observed))) (p_queue_pre)) = (Some (q)))) (PreH20 : (dataqueue_ready q )),
  ((&(((p_queue_base + (p_queue_front * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "length")) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
  **  ((&(((p_queue_base + (p_queue_front * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "data")) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((StartAddr_pre) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((size_pre) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
  **  (wand (dataqueue_slot (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ((Some (e)))) (dataqueue_buffer (q)) )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (observed)) )
|--
  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (observed)) ( MonadErr.ret  ((Some (e)))) X ) ”
.

Definition DataqueuePeak_entail_wit_2_split_goal_spatial :=
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (PreH1 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)) <= UINT_MAX)) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)) >= 0)) (PreH3 : (p_queue_sem_data <= INT_MAX)) (PreH4 : (p_queue_sem_blank <= INT_MAX)) (PreH5 : (p_queue_sem_data >= INT_MIN)) (PreH6 : (p_queue_sem_blank >= INT_MIN)) (PreH7 : ((dataqueue_peak (q)) = (Some (e)))) (PreH8 : (p_queue_front <> p_queue_rear)) (PreH9 : (p_queue_pre <> 0)) (PreH10 : (addr_aligned p_queue_pre 4 )) (PreH11 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH12 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH13 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH14 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH15 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH16 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH17 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH18 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X )) (PreH19 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (observed))) (p_queue_pre)) = (Some (q)))) (PreH20 : (dataqueue_ready q )),
  ((&(((p_queue_base + (p_queue_front * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "length")) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
  **  ((&(((p_queue_base + (p_queue_front * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "data")) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((StartAddr_pre) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((size_pre) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
  **  (wand (dataqueue_slot (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ((Some (e)))) (dataqueue_buffer (q)) )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (observed)) )
|--
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))) )
.

Definition DataqueuePeak_entail_wit_3 :=
(
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_front = p_queue_rear)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH5 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH6 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH7 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH8 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH9 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH10 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH11 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X )) (PreH12 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (observed))) (p_queue_pre)) = (Some (q)))) (PreH13 : (dataqueue_ready q )),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  (dataqueue_buffer q )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (observed)) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (observed)) ( MonadErr.ret  (None)) X ) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed observed ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
) \/
(
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_sem_data <= INT_MAX)) (PreH2 : (p_queue_sem_blank <= INT_MAX)) (PreH3 : (p_queue_sem_data >= INT_MIN)) (PreH4 : (p_queue_sem_blank >= INT_MIN)) (PreH5 : (p_queue_front = p_queue_rear)) (PreH6 : (p_queue_pre <> 0)) (PreH7 : (addr_aligned p_queue_pre 4 )) (PreH8 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH9 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH10 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH11 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH12 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH13 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH14 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH15 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X )) (PreH16 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (observed))) (p_queue_pre)) = (Some (q)))) (PreH17 : (dataqueue_ready q )),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  (dataqueue_buffer q )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (observed)) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (observed)) ( MonadErr.ret  (None)) X ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
).

Definition DataqueuePeak_entail_wit_3_split_goal_1 :=
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_sem_data <= INT_MAX)) (PreH2 : (p_queue_sem_blank <= INT_MAX)) (PreH3 : (p_queue_sem_data >= INT_MIN)) (PreH4 : (p_queue_sem_blank >= INT_MIN)) (PreH5 : (p_queue_front = p_queue_rear)) (PreH6 : (p_queue_pre <> 0)) (PreH7 : (addr_aligned p_queue_pre 4 )) (PreH8 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH9 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH10 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH11 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH12 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH13 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH14 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH15 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X )) (PreH16 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (observed))) (p_queue_pre)) = (Some (q)))) (PreH17 : (dataqueue_ready q )),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  (dataqueue_buffer q )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (observed)) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed observed ) ”
.

Definition DataqueuePeak_entail_wit_3_split_goal_2 :=
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_sem_data <= INT_MAX)) (PreH2 : (p_queue_sem_blank <= INT_MAX)) (PreH3 : (p_queue_sem_data >= INT_MIN)) (PreH4 : (p_queue_sem_blank >= INT_MIN)) (PreH5 : (p_queue_front = p_queue_rear)) (PreH6 : (p_queue_pre <> 0)) (PreH7 : (addr_aligned p_queue_pre 4 )) (PreH8 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH9 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH10 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH11 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH12 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH13 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH14 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH15 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X )) (PreH16 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (observed))) (p_queue_pre)) = (Some (q)))) (PreH17 : (dataqueue_ready q )),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  (dataqueue_buffer q )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (observed)) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (observed)) ( MonadErr.ret  (None)) X ) ”
.

Definition DataqueuePeak_entail_wit_3_split_goal_spatial :=
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_sem_data <= INT_MAX)) (PreH2 : (p_queue_sem_blank <= INT_MAX)) (PreH3 : (p_queue_sem_data >= INT_MIN)) (PreH4 : (p_queue_sem_blank >= INT_MIN)) (PreH5 : (p_queue_front = p_queue_rear)) (PreH6 : (p_queue_pre <> 0)) (PreH7 : (addr_aligned p_queue_pre 4 )) (PreH8 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH9 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH10 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH11 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH12 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH13 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH14 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH15 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X )) (PreH16 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (observed))) (p_queue_pre)) = (Some (q)))) (PreH17 : (dataqueue_ready q )),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  (dataqueue_buffer q )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (observed)) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
.

Definition DataqueuePeak_return_wit_1 :=
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (observed)) ( MonadErr.ret  (None)) X )) (PreH2 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed observed )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  EX (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ ((-1) = (-1)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( MonadErr.ret  (None)) X ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
.

Definition DataqueuePeak_return_wit_2 :=
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (e_2:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (pElem: Z) (PreH1 : (pElem = (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) + (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) * sizeof( "DataElem" ))))) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (observed)) ( MonadErr.ret  ((Some (e_2)))) X )) (PreH3 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed observed )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e_2)))) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e_2)))) )
|--
  EX (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ),
  “ (0 = 0) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_2)) ( MonadErr.ret  ((Some (e)))) X ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_2 )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))) )
.

Definition DataqueuePeak_partial_solve_wit_1 :=
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg before )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg before )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
.

Definition DataqueuePeak_partial_solve_wit_2 :=
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (PreH1 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X )) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (observed))) (p_queue_pre)) = (Some (q)))) (PreH4 : (dataqueue_ready q )),
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre q )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (observed)) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (observed))) (p_queue_pre)) = (Some (q))) ”
  &&  “ (dataqueue_ready q ) ”
  &&  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue_pre q )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (observed)) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
.

Definition DataqueuePeak_partial_solve_wit_3_pure :=
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (saved: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_front <> p_queue_rear)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH5 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH6 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH7 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH8 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH9 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH10 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH11 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X )) (PreH12 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (observed))) (p_queue_pre)) = (Some (q)))) (PreH13 : (dataqueue_ready q )),
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
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (observed)) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  “ (dataqueue_ready q ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q))) ”
.

Definition DataqueuePeak_partial_solve_wit_3_aux :=
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_front <> p_queue_rear)) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH5 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH6 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH7 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH8 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH9 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH10 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH11 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X )) (PreH12 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (observed))) (p_queue_pre)) = (Some (q)))) (PreH13 : (dataqueue_ready q )),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  (dataqueue_buffer q )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (observed)) )
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
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (observed))) (p_queue_pre)) = (Some (q))) ”
  &&  “ (dataqueue_ready q ) ”
  &&  (dataqueue_buffer q )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (observed)) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
.

Definition DataqueuePeak_partial_solve_wit_3 := DataqueuePeak_partial_solve_wit_3_pure -> DataqueuePeak_partial_solve_wit_3_aux.

Definition DataqueuePeak_partial_solve_wit_4 :=
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (PreH1 : ((dataqueue_peak (q)) = (Some (e)))) (PreH2 : (p_queue_front <> p_queue_rear)) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH6 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH7 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH8 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH9 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH10 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH12 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X )) (PreH13 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (observed))) (p_queue_pre)) = (Some (q)))) (PreH14 : (dataqueue_ready q )),
  (dataqueue_slot ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) (Some (e)) )
  **  (wand (dataqueue_slot (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ((Some (e)))) (dataqueue_buffer (q)) )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (observed)) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  “ ((dataqueue_peak (q)) = (Some (e))) ”
  &&  “ (p_queue_front <> p_queue_rear) ”
  &&  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ”
  &&  “ (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q))) ”
  &&  “ (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q))) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (observed))) (p_queue_pre)) = (Some (q))) ”
  &&  “ (dataqueue_ready q ) ”
  &&  (dataqueue_slot ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) (Some (e)) )
  **  (wand (dataqueue_slot (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ((Some (e)))) (dataqueue_buffer (q)) )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (observed)) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
.

Definition DataqueuePeak_partial_solve_wit_5 :=
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (PreH1 : ((dataqueue_peak (q)) = (Some (e)))) (PreH2 : (p_queue_front <> p_queue_rear)) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH6 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH7 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH8 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH9 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH10 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH12 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X )) (PreH13 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (observed))) (p_queue_pre)) = (Some (q)))) (PreH14 : (dataqueue_ready q )),
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
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (observed)) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  “ ((dataqueue_peak (q)) = (Some (e))) ”
  &&  “ (p_queue_front <> p_queue_rear) ”
  &&  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ”
  &&  “ (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q))) ”
  &&  “ (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q))) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (observed))) (p_queue_pre)) = (Some (q))) ”
  &&  “ (dataqueue_ready q ) ”
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
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (observed)) )
.

Definition DataqueuePeak_partial_solve_wit_6 :=
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (PreH1 : ((dataqueue_peak (q)) = (Some (e)))) (PreH2 : (p_queue_front <> p_queue_rear)) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH6 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH7 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH8 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH9 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH10 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH12 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X )) (PreH13 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (observed))) (p_queue_pre)) = (Some (q)))) (PreH14 : (dataqueue_ready q )),
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
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (observed)) )
|--
  “ ((dataqueue_peak (q)) = (Some (e))) ”
  &&  “ (p_queue_front <> p_queue_rear) ”
  &&  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ”
  &&  “ (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q))) ”
  &&  “ (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q))) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (observed))) (p_queue_pre)) = (Some (q))) ”
  &&  “ (dataqueue_ready q ) ”
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
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (observed)) )
.

Definition DataqueuePeak_partial_solve_wit_7 :=
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (PreH1 : ((dataqueue_peak (q)) = (Some (e)))) (PreH2 : (p_queue_front <> p_queue_rear)) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)))) (PreH6 : (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))) (PreH7 : (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)))) (PreH8 : (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)))) (PreH9 : (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH10 : (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH12 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X )) (PreH13 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (observed))) (p_queue_pre)) = (Some (q)))) (PreH14 : (dataqueue_ready q )),
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
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (observed)) )
|--
  “ ((dataqueue_peak (q)) = (Some (e))) ”
  &&  “ (p_queue_front <> p_queue_rear) ”
  &&  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ (p_queue_front = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ”
  &&  “ (p_queue_rear = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q))) ”
  &&  “ (p_queue_max_len = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q))) ”
  &&  “ (p_queue_base = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) ”
  &&  “ (p_queue_sem_blank = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (p_queue_sem_data = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q))) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.abs_dataqueue_peak  (sg) (p_queue_pre)) X ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_map  (( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (observed))) (p_queue_pre)) = (Some (q))) ”
  &&  “ (dataqueue_ready q ) ”
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
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  (wand ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  (p_queue_pre) (q)) ( CRTOS_Verify.lib.common.CrtosInv.os_inv  (sg) (observed)) )
.

Definition DataqueuePeak_partial_solve_wit_8_pure :=
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (saved: Z) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (pElem: Z) (PreH1 : (pElem = (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) + (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) * sizeof( "DataElem" ))))) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (observed)) ( MonadErr.ret  ((Some (e)))) X )) (PreH3 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed observed )),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "StartAddr" ) )) # Ptr  |-> StartAddr_pre)
  **  ((( &( "size" ) )) # Ptr  |-> size_pre)
  **  ((( &( "pElem" ) )) # Ptr  |-> pElem)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))) )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed observed ) ”
.

Definition DataqueuePeak_partial_solve_wit_8_aux :=
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) (pElem: Z) (PreH1 : (pElem = (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) + (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) * sizeof( "DataElem" ))))) (PreH2 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (observed)) ( MonadErr.ret  ((Some (e)))) X )) (PreH3 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed observed )),
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))) )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed observed ) ”
  &&  “ (pElem = (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) + (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) * sizeof( "DataElem" )))) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (observed)) ( MonadErr.ret  ((Some (e)))) X ) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed observed ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))) )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre (Some (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))) )
.

Definition DataqueuePeak_partial_solve_wit_8 := DataqueuePeak_partial_solve_wit_8_pure -> DataqueuePeak_partial_solve_wit_8_aux.

Definition DataqueuePeak_partial_solve_wit_9_pure :=
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (saved: Z) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (observed)) ( MonadErr.ret  (None)) X )) (PreH2 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed observed )),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "StartAddr" ) )) # Ptr  |-> StartAddr_pre)
  **  ((( &( "size" ) )) # Ptr  |-> size_pre)
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed observed ) ”
.

Definition DataqueuePeak_partial_solve_wit_9_aux :=
forall (X: ((@option  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ) -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (old_length: (@option Z)) (old_data: (@option Z)) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (StartAddr_pre: Z) (size_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (observed)) ( MonadErr.ret  (None)) X )) (PreH2 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed observed )),
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed observed ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (observed)) ( MonadErr.ret  (None)) X ) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed observed ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_data_slot  StartAddr_pre old_data )
  **  ( CRTOS_Verify.lib.dataqueue.KDataqueuePeak.peak_length_slot  size_pre old_length )
.

Definition DataqueuePeak_partial_solve_wit_9 := DataqueuePeak_partial_solve_wit_9_pure -> DataqueuePeak_partial_solve_wit_9_aux.

Definition DataqueuePeak_which_implies_wit_1 :=
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

Definition DataqueuePeak_which_implies_wit_1_split_goal_1 :=
forall (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue: Z),
  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue q )
|--
  “ (addr_aligned p_queue 4 ) ”
.

Definition DataqueuePeak_which_implies_wit_1_split_goal_2 :=
forall (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (p_queue: Z),
  ( CRTOS_Verify.lib.common.DataqueueInv.store_dataqueue  p_queue q )
|--
  “ (p_queue <> 0) ”
.

Definition DataqueuePeak_which_implies_wit_1_split_goal_spatial :=
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

Definition DataqueuePeak_which_implies_wit_2 :=
(
forall (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (PreH1 : (dataqueue_ready q )) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))),
  (dataqueue_buffer q )
|--
  EX (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ),
  “ ((dataqueue_peak (q)) = (Some (e))) ”
  &&  (dataqueue_slot ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) (Some (e)) )
  **  (wand (dataqueue_slot (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ((Some (e)))) (dataqueue_buffer (q)) )
) \/
(
forall (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (PreH1 : (dataqueue_ready q )) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)))),
  (dataqueue_buffer q )
|--
  EX (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ),
  “ ((dataqueue_peak (q)) = (Some (e))) ”
  &&  (dataqueue_slot ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) (Some (e)) )
  **  (wand (dataqueue_slot (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q))) (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q))) ((Some (e)))) (dataqueue_buffer (q)) )
).

Definition DataqueuePeak_which_implies_wit_3 :=
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

Definition DataqueuePeak_which_implies_wit_3_split_goal_spatial :=
forall (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataQueueAbs ) (e:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueElem ),
  (dataqueue_slot ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) (Some (e)) )
|--
  ((&(((( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) + (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "data")) # Ptr  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_data  (e)))
  **  ((&(((( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) + (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) * sizeof( "DataElem" ))))  # "DataElem" ->ₛ "length")) # UInt  |-> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_length  (e)))
.

Definition DataqueuePeak_which_implies_wit_4 :=
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


Axiom proof_of_DataqueuePeak_safety_wit_1 : DataqueuePeak_safety_wit_1.
Axiom proof_of_DataqueuePeak_safety_wit_2 : DataqueuePeak_safety_wit_2.
Axiom proof_of_DataqueuePeak_safety_wit_3 : DataqueuePeak_safety_wit_3.
Axiom proof_of_DataqueuePeak_safety_wit_4 : DataqueuePeak_safety_wit_4.
Axiom proof_of_DataqueuePeak_entail_wit_1 : DataqueuePeak_entail_wit_1.
Axiom proof_of_DataqueuePeak_entail_wit_2 : DataqueuePeak_entail_wit_2.
Axiom proof_of_DataqueuePeak_entail_wit_3 : DataqueuePeak_entail_wit_3.
Axiom proof_of_DataqueuePeak_return_wit_1 : DataqueuePeak_return_wit_1.
Axiom proof_of_DataqueuePeak_return_wit_2 : DataqueuePeak_return_wit_2.
Axiom proof_of_DataqueuePeak_partial_solve_wit_1 : DataqueuePeak_partial_solve_wit_1.
Axiom proof_of_DataqueuePeak_partial_solve_wit_2 : DataqueuePeak_partial_solve_wit_2.
Axiom proof_of_DataqueuePeak_partial_solve_wit_3_pure : DataqueuePeak_partial_solve_wit_3_pure.
Axiom proof_of_DataqueuePeak_partial_solve_wit_3 : DataqueuePeak_partial_solve_wit_3.
Axiom proof_of_DataqueuePeak_partial_solve_wit_4 : DataqueuePeak_partial_solve_wit_4.
Axiom proof_of_DataqueuePeak_partial_solve_wit_5 : DataqueuePeak_partial_solve_wit_5.
Axiom proof_of_DataqueuePeak_partial_solve_wit_6 : DataqueuePeak_partial_solve_wit_6.
Axiom proof_of_DataqueuePeak_partial_solve_wit_7 : DataqueuePeak_partial_solve_wit_7.
Axiom proof_of_DataqueuePeak_partial_solve_wit_8_pure : DataqueuePeak_partial_solve_wit_8_pure.
Axiom proof_of_DataqueuePeak_partial_solve_wit_8 : DataqueuePeak_partial_solve_wit_8.
Axiom proof_of_DataqueuePeak_partial_solve_wit_9_pure : DataqueuePeak_partial_solve_wit_9_pure.
Axiom proof_of_DataqueuePeak_partial_solve_wit_9 : DataqueuePeak_partial_solve_wit_9.
Axiom proof_of_DataqueuePeak_which_implies_wit_1 : DataqueuePeak_which_implies_wit_1.
Axiom proof_of_DataqueuePeak_which_implies_wit_2 : DataqueuePeak_which_implies_wit_2.
Axiom proof_of_DataqueuePeak_which_implies_wit_3 : DataqueuePeak_which_implies_wit_3.
Axiom proof_of_DataqueuePeak_which_implies_wit_4 : DataqueuePeak_which_implies_wit_4.

End VC_Correct.
