From SimpleC.Verification Require Import VCPrelude.
Require Import CRTOS_Verify.lib.dataqueue.KInitDataqueue CRTOS_Verify.lib.dataqueue.KDataqueuePeak.
From MonadLib.MonadErr Require Import MonadErrBasic MonadErrHoare monadesafe_lib.
Import Monad MonadNotation.
Local Open Scope monad.
Local Open Scope sac.

(*----- Function InitDataqueue -----*)

Definition InitDataqueue_safety_wit_1 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ((( &( "lock" ) )) # Int  |->_)
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
  **  ( CRTOS_Verify.lib.common.DataqueueInv.DataqueueStorage  p_queue_pre )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg before )
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition InitDataqueue_safety_wit_2 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (retval: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  (CharArray.undef_full p_queue_pre sizeof( "DataQueue" ) )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition InitDataqueue_safety_wit_3 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (retval: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_2: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_front = 0)) (PreH2 : (p_queue_rear = 0)) (PreH3 : (p_queue_max_len = 0)) (PreH4 : (p_queue_base = 0)) (PreH5 : (p_queue_sem_blank = 0)) (PreH6 : (p_queue_sem_data = 0)) (PreH7 : (retval_2 = p_queue_pre)) (PreH8 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH9 : (p_queue_pre <> 0)) (PreH10 : (addr_aligned p_queue_pre 4 )) (PreH11 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ (1 <> (INT_MIN)) ”
.

Definition InitDataqueue_safety_wit_4 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (retval: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_2: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_front = 0)) (PreH2 : (p_queue_rear = 0)) (PreH3 : (p_queue_max_len = 0)) (PreH4 : (p_queue_base = 0)) (PreH5 : (p_queue_sem_blank = 0)) (PreH6 : (p_queue_sem_data = 0)) (PreH7 : (retval_2 = p_queue_pre)) (PreH8 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH9 : (p_queue_pre <> 0)) (PreH10 : (addr_aligned p_queue_pre 4 )) (PreH11 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition InitDataqueue_safety_wit_5 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (retval: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_2: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_front = 0)) (PreH2 : (p_queue_rear = 0)) (PreH3 : (p_queue_max_len = 0)) (PreH4 : (p_queue_base = 0)) (PreH5 : (p_queue_sem_blank = 0)) (PreH6 : (p_queue_sem_data = 0)) (PreH7 : (retval_2 = p_queue_pre)) (PreH8 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH9 : (p_queue_pre <> 0)) (PreH10 : (addr_aligned p_queue_pre 4 )) (PreH11 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> (-1))
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ (1 <> (INT_MIN)) ”
.

Definition InitDataqueue_safety_wit_6 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (retval: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_2: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_front = 0)) (PreH2 : (p_queue_rear = 0)) (PreH3 : (p_queue_max_len = 0)) (PreH4 : (p_queue_base = 0)) (PreH5 : (p_queue_sem_blank = 0)) (PreH6 : (p_queue_sem_data = 0)) (PreH7 : (retval_2 = p_queue_pre)) (PreH8 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH9 : (p_queue_pre <> 0)) (PreH10 : (addr_aligned p_queue_pre 4 )) (PreH11 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> (-1))
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition InitDataqueue_safety_wit_7 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (retval: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_2: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_front = 0)) (PreH2 : (p_queue_rear = 0)) (PreH3 : (p_queue_max_len = 0)) (PreH4 : (p_queue_base = 0)) (PreH5 : (p_queue_sem_blank = 0)) (PreH6 : (p_queue_sem_data = 0)) (PreH7 : (retval_2 = p_queue_pre)) (PreH8 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH9 : (p_queue_pre <> 0)) (PreH10 : (addr_aligned p_queue_pre 4 )) (PreH11 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> (-1))
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition InitDataqueue_safety_wit_8 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (retval: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_2: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_front = 0)) (PreH2 : (p_queue_rear = 0)) (PreH3 : (p_queue_max_len = 0)) (PreH4 : (p_queue_base = 0)) (PreH5 : (p_queue_sem_blank = 0)) (PreH6 : (p_queue_sem_data = 0)) (PreH7 : (retval_2 = p_queue_pre)) (PreH8 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH9 : (p_queue_pre <> 0)) (PreH10 : (addr_aligned p_queue_pre 4 )) (PreH11 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> (-1))
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition InitDataqueue_safety_wit_9 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (retval: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_2: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (retval_3: Z) (PreH1 : (retval_3 = 0)) (PreH2 : ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) > 0)) (PreH3 : (retval_3 > 0)) (PreH4 : (retval_3 <= (UINT_MAX - (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) ))) (PreH5 : (addr_aligned retval_3 4 )) (PreH6 : (p_queue_front = 0)) (PreH7 : (p_queue_rear = 0)) (PreH8 : (p_queue_max_len = 0)) (PreH9 : (p_queue_base = 0)) (PreH10 : (p_queue_sem_blank = 0)) (PreH11 : (p_queue_sem_data = 0)) (PreH12 : (retval_2 = p_queue_pre)) (PreH13 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH14 : (p_queue_pre <> 0)) (PreH15 : (addr_aligned p_queue_pre 4 )) (PreH16 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  (CharArray.undef_full retval_3 (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> (-1))
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ False ”
.

Definition InitDataqueue_safety_wit_10 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (retval: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_2: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (retval_3: Z) (PreH1 : (retval_3 <> 0)) (PreH2 : ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) > 0)) (PreH3 : (retval_3 = 0)) (PreH4 : (p_queue_front = 0)) (PreH5 : (p_queue_rear = 0)) (PreH6 : (p_queue_max_len = 0)) (PreH7 : (p_queue_base = 0)) (PreH8 : (p_queue_sem_blank = 0)) (PreH9 : (p_queue_sem_data = 0)) (PreH10 : (retval_2 = p_queue_pre)) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH12 : (p_queue_pre <> 0)) (PreH13 : (addr_aligned p_queue_pre 4 )) (PreH14 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> (-1))
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ False ”
.

Definition InitDataqueue_safety_wit_11 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (retval: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_2: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (retval_3: Z) (PreH1 : (retval_3 <> 0)) (PreH2 : ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) = 0)) (PreH3 : (retval_3 = 0)) (PreH4 : (p_queue_front = 0)) (PreH5 : (p_queue_rear = 0)) (PreH6 : (p_queue_max_len = 0)) (PreH7 : (p_queue_base = 0)) (PreH8 : (p_queue_sem_blank = 0)) (PreH9 : (p_queue_sem_data = 0)) (PreH10 : (retval_2 = p_queue_pre)) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH12 : (p_queue_pre <> 0)) (PreH13 : (addr_aligned p_queue_pre 4 )) (PreH14 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> (-1))
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ False ”
.

Definition InitDataqueue_safety_wit_12 :=
(
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (retval: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_2: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (retval_3: Z) (PreH1 : (retval_3 <> 0)) (PreH2 : ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) > 0)) (PreH3 : (retval_3 > 0)) (PreH4 : (retval_3 <= (UINT_MAX - (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) ))) (PreH5 : (addr_aligned retval_3 4 )) (PreH6 : (p_queue_front = 0)) (PreH7 : (p_queue_rear = 0)) (PreH8 : (p_queue_max_len = 0)) (PreH9 : (p_queue_base = 0)) (PreH10 : (p_queue_sem_blank = 0)) (PreH11 : (p_queue_sem_data = 0)) (PreH12 : (retval_2 = p_queue_pre)) (PreH13 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH14 : (p_queue_pre <> 0)) (PreH15 : (addr_aligned p_queue_pre 4 )) (PreH16 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  (CharArray.undef_full retval_3 (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> (-1))
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ ((NodeNumber_pre - 1 ) <= INT_MAX) ”
  &&  “ ((INT_MIN) <= (NodeNumber_pre - 1 )) ”
) \/
(
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (retval: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_2: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (retval_3: Z) (PreH1 : (retval_3 <> 0)) (PreH2 : ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) > 0)) (PreH3 : (retval_3 > 0)) (PreH4 : (retval_3 <= (UINT_MAX - (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) ))) (PreH5 : (addr_aligned retval_3 4 )) (PreH6 : (p_queue_front = 0)) (PreH7 : (p_queue_rear = 0)) (PreH8 : (p_queue_max_len = 0)) (PreH9 : (p_queue_base = 0)) (PreH10 : (p_queue_sem_blank = 0)) (PreH11 : (p_queue_sem_data = 0)) (PreH12 : (retval_2 = p_queue_pre)) (PreH13 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH14 : (p_queue_pre <> 0)) (PreH15 : (addr_aligned p_queue_pre 4 )) (PreH16 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  (CharArray.undef_full retval_3 (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> (-1))
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ ((NodeNumber_pre - 1 ) <= INT_MAX) ”
  &&  “ ((INT_MIN) <= (NodeNumber_pre - 1 )) ”
).

Definition InitDataqueue_safety_wit_12_split_goal_1 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (retval: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_2: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (retval_3: Z) (PreH1 : (retval_3 <> 0)) (PreH2 : ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) > 0)) (PreH3 : (retval_3 > 0)) (PreH4 : (retval_3 <= (UINT_MAX - (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) ))) (PreH5 : (addr_aligned retval_3 4 )) (PreH6 : (p_queue_front = 0)) (PreH7 : (p_queue_rear = 0)) (PreH8 : (p_queue_max_len = 0)) (PreH9 : (p_queue_base = 0)) (PreH10 : (p_queue_sem_blank = 0)) (PreH11 : (p_queue_sem_data = 0)) (PreH12 : (retval_2 = p_queue_pre)) (PreH13 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH14 : (p_queue_pre <> 0)) (PreH15 : (addr_aligned p_queue_pre 4 )) (PreH16 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  (CharArray.undef_full retval_3 (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> (-1))
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ ((NodeNumber_pre - 1 ) <= INT_MAX) ”
.

Definition InitDataqueue_safety_wit_12_split_goal_2 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (retval: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_2: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (retval_3: Z) (PreH1 : (retval_3 <> 0)) (PreH2 : ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) > 0)) (PreH3 : (retval_3 > 0)) (PreH4 : (retval_3 <= (UINT_MAX - (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) ))) (PreH5 : (addr_aligned retval_3 4 )) (PreH6 : (p_queue_front = 0)) (PreH7 : (p_queue_rear = 0)) (PreH8 : (p_queue_max_len = 0)) (PreH9 : (p_queue_base = 0)) (PreH10 : (p_queue_sem_blank = 0)) (PreH11 : (p_queue_sem_data = 0)) (PreH12 : (retval_2 = p_queue_pre)) (PreH13 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH14 : (p_queue_pre <> 0)) (PreH15 : (addr_aligned p_queue_pre 4 )) (PreH16 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  (CharArray.undef_full retval_3 (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> (-1))
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ ((INT_MIN) <= (NodeNumber_pre - 1 )) ”
.

Definition InitDataqueue_safety_wit_13 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (retval: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_2: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (retval_3: Z) (PreH1 : (retval_3 <> 0)) (PreH2 : ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) > 0)) (PreH3 : (retval_3 > 0)) (PreH4 : (retval_3 <= (UINT_MAX - (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) ))) (PreH5 : (addr_aligned retval_3 4 )) (PreH6 : (p_queue_front = 0)) (PreH7 : (p_queue_rear = 0)) (PreH8 : (p_queue_max_len = 0)) (PreH9 : (p_queue_base = 0)) (PreH10 : (p_queue_sem_blank = 0)) (PreH11 : (p_queue_sem_data = 0)) (PreH12 : (retval_2 = p_queue_pre)) (PreH13 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH14 : (p_queue_pre <> 0)) (PreH15 : (addr_aligned p_queue_pre 4 )) (PreH16 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  (CharArray.undef_full retval_3 (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> (-1))
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition InitDataqueue_safety_wit_14 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (retval: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_2: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (retval_3: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_4: Z) (PreH1 : (0 <= retval_4)) (PreH2 : (retval_4 < 128)) (PreH3 : ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg (unsigned_last_nbits ((NodeNumber_pre - 1 )) (16)) observed retval_4 after )) (PreH4 : (retval_3 <> 0)) (PreH5 : ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) > 0)) (PreH6 : (retval_3 > 0)) (PreH7 : (retval_3 <= (UINT_MAX - (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) ))) (PreH8 : (addr_aligned retval_3 4 )) (PreH9 : (p_queue_front = 0)) (PreH10 : (p_queue_rear = 0)) (PreH11 : (p_queue_max_len = 0)) (PreH12 : (p_queue_base = 0)) (PreH13 : (p_queue_sem_blank = 0)) (PreH14 : (p_queue_sem_data = 0)) (PreH15 : (retval_2 = p_queue_pre)) (PreH16 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH17 : (p_queue_pre <> 0)) (PreH18 : (addr_aligned p_queue_pre 4 )) (PreH19 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  (CharArray.undef_full retval_3 (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> retval_4)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition InitDataqueue_safety_wit_15 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (retval: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_2: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (retval_3: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_4: Z) (PreH1 : (retval_4 = (-5))) (PreH2 : ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg (unsigned_last_nbits ((NodeNumber_pre - 1 )) (16)) observed retval_4 after )) (PreH3 : (retval_3 <> 0)) (PreH4 : ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) > 0)) (PreH5 : (retval_3 > 0)) (PreH6 : (retval_3 <= (UINT_MAX - (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) ))) (PreH7 : (addr_aligned retval_3 4 )) (PreH8 : (p_queue_front = 0)) (PreH9 : (p_queue_rear = 0)) (PreH10 : (p_queue_max_len = 0)) (PreH11 : (p_queue_base = 0)) (PreH12 : (p_queue_sem_blank = 0)) (PreH13 : (p_queue_sem_data = 0)) (PreH14 : (retval_2 = p_queue_pre)) (PreH15 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH16 : (p_queue_pre <> 0)) (PreH17 : (addr_aligned p_queue_pre 4 )) (PreH18 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  (CharArray.undef_full retval_3 (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> retval_4)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition InitDataqueue_safety_wit_16 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (retval: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_2: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (retval_3: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_4: Z) (PreH1 : (retval_4 < 0)) (PreH2 : (0 <= retval_4)) (PreH3 : (retval_4 < 128)) (PreH4 : ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg (unsigned_last_nbits ((NodeNumber_pre - 1 )) (16)) observed retval_4 after )) (PreH5 : (retval_3 <> 0)) (PreH6 : ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) > 0)) (PreH7 : (retval_3 > 0)) (PreH8 : (retval_3 <= (UINT_MAX - (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) ))) (PreH9 : (addr_aligned retval_3 4 )) (PreH10 : (p_queue_front = 0)) (PreH11 : (p_queue_rear = 0)) (PreH12 : (p_queue_max_len = 0)) (PreH13 : (p_queue_base = 0)) (PreH14 : (p_queue_sem_blank = 0)) (PreH15 : (p_queue_sem_data = 0)) (PreH16 : (retval_2 = p_queue_pre)) (PreH17 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH18 : (p_queue_pre <> 0)) (PreH19 : (addr_aligned p_queue_pre 4 )) (PreH20 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  (CharArray.undef_full retval_3 (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> retval_4)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ False ”
.

Definition InitDataqueue_safety_wit_17 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (retval: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_2: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (retval_3: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_4: Z) (PreH1 : (retval_4 >= 0)) (PreH2 : (retval_4 = (-5))) (PreH3 : ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg (unsigned_last_nbits ((NodeNumber_pre - 1 )) (16)) observed retval_4 after )) (PreH4 : (retval_3 <> 0)) (PreH5 : ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) > 0)) (PreH6 : (retval_3 > 0)) (PreH7 : (retval_3 <= (UINT_MAX - (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) ))) (PreH8 : (addr_aligned retval_3 4 )) (PreH9 : (p_queue_front = 0)) (PreH10 : (p_queue_rear = 0)) (PreH11 : (p_queue_max_len = 0)) (PreH12 : (p_queue_base = 0)) (PreH13 : (p_queue_sem_blank = 0)) (PreH14 : (p_queue_sem_data = 0)) (PreH15 : (retval_2 = p_queue_pre)) (PreH16 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH17 : (p_queue_pre <> 0)) (PreH18 : (addr_aligned p_queue_pre 4 )) (PreH19 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  (CharArray.undef_full retval_3 (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> retval_4)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ False ”
.

Definition InitDataqueue_safety_wit_18 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (retval: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_2: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (retval_3: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_4: Z) (PreH1 : (retval_4 >= 0)) (PreH2 : (0 <= retval_4)) (PreH3 : (retval_4 < 128)) (PreH4 : ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg (unsigned_last_nbits ((NodeNumber_pre - 1 )) (16)) observed retval_4 after )) (PreH5 : (retval_3 <> 0)) (PreH6 : ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) > 0)) (PreH7 : (retval_3 > 0)) (PreH8 : (retval_3 <= (UINT_MAX - (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) ))) (PreH9 : (addr_aligned retval_3 4 )) (PreH10 : (p_queue_front = 0)) (PreH11 : (p_queue_rear = 0)) (PreH12 : (p_queue_max_len = 0)) (PreH13 : (p_queue_base = 0)) (PreH14 : (p_queue_sem_blank = 0)) (PreH15 : (p_queue_sem_data = 0)) (PreH16 : (retval_2 = p_queue_pre)) (PreH17 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH18 : (p_queue_pre <> 0)) (PreH19 : (addr_aligned p_queue_pre 4 )) (PreH20 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  (CharArray.undef_full retval_3 (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> retval_4)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition InitDataqueue_safety_wit_19 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (retval: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_2: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (retval_3: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_4: Z) (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_5: Z) (PreH1 : (0 <= retval_5)) (PreH2 : (retval_5 < 128)) (PreH3 : ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg 0 after retval_5 after_2 )) (PreH4 : (retval_4 >= 0)) (PreH5 : (0 <= retval_4)) (PreH6 : (retval_4 < 128)) (PreH7 : ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg (unsigned_last_nbits ((NodeNumber_pre - 1 )) (16)) observed retval_4 after )) (PreH8 : (retval_3 <> 0)) (PreH9 : ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) > 0)) (PreH10 : (retval_3 > 0)) (PreH11 : (retval_3 <= (UINT_MAX - (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) ))) (PreH12 : (addr_aligned retval_3 4 )) (PreH13 : (p_queue_front = 0)) (PreH14 : (p_queue_rear = 0)) (PreH15 : (p_queue_max_len = 0)) (PreH16 : (p_queue_base = 0)) (PreH17 : (p_queue_sem_blank = 0)) (PreH18 : (p_queue_sem_data = 0)) (PreH19 : (retval_2 = p_queue_pre)) (PreH20 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH21 : (p_queue_pre <> 0)) (PreH22 : (addr_aligned p_queue_pre 4 )) (PreH23 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after_2 )
  **  (CharArray.undef_full retval_3 (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> retval_4)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> retval_5)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition InitDataqueue_safety_wit_20 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (retval: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_2: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (retval_3: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_4: Z) (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_5: Z) (PreH1 : (retval_5 = (-5))) (PreH2 : ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg 0 after retval_5 after_2 )) (PreH3 : (retval_4 >= 0)) (PreH4 : (0 <= retval_4)) (PreH5 : (retval_4 < 128)) (PreH6 : ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg (unsigned_last_nbits ((NodeNumber_pre - 1 )) (16)) observed retval_4 after )) (PreH7 : (retval_3 <> 0)) (PreH8 : ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) > 0)) (PreH9 : (retval_3 > 0)) (PreH10 : (retval_3 <= (UINT_MAX - (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) ))) (PreH11 : (addr_aligned retval_3 4 )) (PreH12 : (p_queue_front = 0)) (PreH13 : (p_queue_rear = 0)) (PreH14 : (p_queue_max_len = 0)) (PreH15 : (p_queue_base = 0)) (PreH16 : (p_queue_sem_blank = 0)) (PreH17 : (p_queue_sem_data = 0)) (PreH18 : (retval_2 = p_queue_pre)) (PreH19 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH20 : (p_queue_pre <> 0)) (PreH21 : (addr_aligned p_queue_pre 4 )) (PreH22 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after_2 )
  **  (CharArray.undef_full retval_3 (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> retval_4)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> retval_5)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition InitDataqueue_safety_wit_21 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (retval: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_2: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (retval_3: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_4: Z) (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_5: Z) (PreH1 : (retval_5 < 0)) (PreH2 : (0 <= retval_5)) (PreH3 : (retval_5 < 128)) (PreH4 : ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg 0 after retval_5 after_2 )) (PreH5 : (retval_4 >= 0)) (PreH6 : (0 <= retval_4)) (PreH7 : (retval_4 < 128)) (PreH8 : ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg (unsigned_last_nbits ((NodeNumber_pre - 1 )) (16)) observed retval_4 after )) (PreH9 : (retval_3 <> 0)) (PreH10 : ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) > 0)) (PreH11 : (retval_3 > 0)) (PreH12 : (retval_3 <= (UINT_MAX - (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) ))) (PreH13 : (addr_aligned retval_3 4 )) (PreH14 : (p_queue_front = 0)) (PreH15 : (p_queue_rear = 0)) (PreH16 : (p_queue_max_len = 0)) (PreH17 : (p_queue_base = 0)) (PreH18 : (p_queue_sem_blank = 0)) (PreH19 : (p_queue_sem_data = 0)) (PreH20 : (retval_2 = p_queue_pre)) (PreH21 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH22 : (p_queue_pre <> 0)) (PreH23 : (addr_aligned p_queue_pre 4 )) (PreH24 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after_2 )
  **  (CharArray.undef_full retval_3 (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> retval_4)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> retval_5)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ False ”
.

Definition InitDataqueue_safety_wit_22 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (retval: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_2: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (retval_3: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_4: Z) (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_5: Z) (PreH1 : (retval_5 >= 0)) (PreH2 : (retval_5 = (-5))) (PreH3 : ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg 0 after retval_5 after_2 )) (PreH4 : (retval_4 >= 0)) (PreH5 : (0 <= retval_4)) (PreH6 : (retval_4 < 128)) (PreH7 : ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg (unsigned_last_nbits ((NodeNumber_pre - 1 )) (16)) observed retval_4 after )) (PreH8 : (retval_3 <> 0)) (PreH9 : ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) > 0)) (PreH10 : (retval_3 > 0)) (PreH11 : (retval_3 <= (UINT_MAX - (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) ))) (PreH12 : (addr_aligned retval_3 4 )) (PreH13 : (p_queue_front = 0)) (PreH14 : (p_queue_rear = 0)) (PreH15 : (p_queue_max_len = 0)) (PreH16 : (p_queue_base = 0)) (PreH17 : (p_queue_sem_blank = 0)) (PreH18 : (p_queue_sem_data = 0)) (PreH19 : (retval_2 = p_queue_pre)) (PreH20 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH21 : (p_queue_pre <> 0)) (PreH22 : (addr_aligned p_queue_pre 4 )) (PreH23 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after_2 )
  **  (CharArray.undef_full retval_3 (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> retval_4)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> retval_5)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ False ”
.

Definition InitDataqueue_safety_wit_23 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (saved: Z) (PreH1 : (In q ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (after)) )) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0)) (PreH5 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0)) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) <> 0)) (PreH7 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH8 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH9 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH10 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( MonadErr.ret  (0)) X )) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed after )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after )
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ (0 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 0) ”
.

Definition InitDataqueue_safety_wit_24 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (saved: Z) (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_2)) ( MonadErr.ret  (tt)) Y )) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0)) (PreH5 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0)) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) = (-1))) (PreH7 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-1))) (PreH8 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y )) (PreH9 : forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X ))) (PreH10 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after )),
  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q)) )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_2 )
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ (1 <> (INT_MIN)) ”
.

Definition InitDataqueue_safety_wit_25 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (saved: Z) (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_2)) ( MonadErr.ret  (tt)) Y )) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0)) (PreH5 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0)) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) = (-5))) (PreH7 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-1))) (PreH8 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y )) (PreH9 : forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X ))) (PreH10 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after )),
  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q)) )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_2 )
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ (1 <> (INT_MIN)) ”
.

Definition InitDataqueue_safety_wit_26 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (saved: Z) (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_2)) ( MonadErr.ret  (tt)) Y )) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0)) (PreH5 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0)) (PreH6 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH7 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-5))) (PreH8 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y )) (PreH9 : forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X ))) (PreH10 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after )),
  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q)) )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_2 )
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ (1 <> (INT_MIN)) ”
.

Definition InitDataqueue_safety_wit_27 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (saved: Z) (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_2)) ( MonadErr.ret  (tt)) Y )) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0)) (PreH5 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0)) (PreH6 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH7 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-5))) (PreH8 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y )) (PreH9 : forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X ))) (PreH10 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after )),
  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q)) )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_2 )
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition InitDataqueue_safety_wit_28 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (saved: Z) (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_2)) ( MonadErr.ret  (tt)) Y )) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0)) (PreH5 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0)) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) = (-5))) (PreH7 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-1))) (PreH8 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y )) (PreH9 : forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X ))) (PreH10 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after )),
  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q)) )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_2 )
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition InitDataqueue_safety_wit_29 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (saved: Z) (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_2)) ( MonadErr.ret  (tt)) Y )) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0)) (PreH5 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0)) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) = (-1))) (PreH7 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-1))) (PreH8 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y )) (PreH9 : forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X ))) (PreH10 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after )),
  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q)) )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_2 )
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ (1 <= INT_MAX) ”
  &&  “ ((INT_MIN) <= 1) ”
.

Definition InitDataqueue_entail_wit_1 :=
(
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (retval_2: Z) (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_3: Z) (after_3:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_4: Z) (PreH1 : (retval_4 >= 0)) (PreH2 : (0 <= retval_4)) (PreH3 : (retval_4 < 128)) (PreH4 : ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg 0 after_2 retval_4 after_3 )) (PreH5 : (retval_3 >= 0)) (PreH6 : (0 <= retval_3)) (PreH7 : (retval_3 < 128)) (PreH8 : ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg (unsigned_last_nbits ((NodeNumber_pre - 1 )) (16)) observed retval_3 after_2 )) (PreH9 : (retval_2 <> 0)) (PreH10 : ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) > 0)) (PreH11 : (retval_2 > 0)) (PreH12 : (retval_2 <= (UINT_MAX - (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) ))) (PreH13 : (addr_aligned retval_2 4 )) (PreH14 : (p_queue_front = 0)) (PreH15 : (p_queue_rear = 0)) (PreH16 : (p_queue_max_len = 0)) (PreH17 : (p_queue_base = 0)) (PreH18 : (p_queue_sem_blank = 0)) (PreH19 : (p_queue_sem_data = 0)) (PreH20 : (retval = p_queue_pre)) (PreH21 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH22 : (p_queue_pre <> 0)) (PreH23 : (addr_aligned p_queue_pre 4 )) (PreH24 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after_3 )
  **  (CharArray.undef_full retval_2 (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> retval_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> retval_4)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
|--
  EX (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ (In q ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (after)) ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) <> 0) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q))) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( MonadErr.ret  (0)) X ) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
) \/
(
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (retval_2: Z) (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_3: Z) (after_3:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_4: Z) (PreH1 : (retval_4 <= INT_MAX)) (PreH2 : (retval_3 <= INT_MAX)) (PreH3 : (retval_4 >= INT_MIN)) (PreH4 : (retval_3 >= INT_MIN)) (PreH5 : (retval_4 >= 0)) (PreH6 : (0 <= retval_4)) (PreH7 : (retval_4 < 128)) (PreH8 : ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg 0 after_2 retval_4 after_3 )) (PreH9 : (retval_3 >= 0)) (PreH10 : (0 <= retval_3)) (PreH11 : (retval_3 < 128)) (PreH12 : ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg (unsigned_last_nbits ((NodeNumber_pre - 1 )) (16)) observed retval_3 after_2 )) (PreH13 : (retval_2 <> 0)) (PreH14 : ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) > 0)) (PreH15 : (retval_2 > 0)) (PreH16 : (retval_2 <= (UINT_MAX - (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) ))) (PreH17 : (addr_aligned retval_2 4 )) (PreH18 : (p_queue_front = 0)) (PreH19 : (p_queue_rear = 0)) (PreH20 : (p_queue_max_len = 0)) (PreH21 : (p_queue_base = 0)) (PreH22 : (p_queue_sem_blank = 0)) (PreH23 : (p_queue_sem_data = 0)) (PreH24 : (retval = p_queue_pre)) (PreH25 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH26 : (p_queue_pre <> 0)) (PreH27 : (addr_aligned p_queue_pre 4 )) (PreH28 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  (CharArray.undef_full retval_2 (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> retval_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> retval_4)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
|--
  EX (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ),
  “ (In q ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (after_3)) ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) <> 0) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q))) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_3)) ( MonadErr.ret  (0)) X ) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed after_3 ) ”
  &&  emp
).

Definition InitDataqueue_entail_wit_2_1 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) > 0)) (PreH3 : (retval_2 = 0)) (PreH4 : (p_queue_front = 0)) (PreH5 : (p_queue_rear = 0)) (PreH6 : (p_queue_max_len = 0)) (PreH7 : (p_queue_base = 0)) (PreH8 : (p_queue_sem_blank = 0)) (PreH9 : (p_queue_sem_data = 0)) (PreH10 : (retval = p_queue_pre)) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH12 : (p_queue_pre <> 0)) (PreH13 : (addr_aligned p_queue_pre 4 )) (PreH14 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> (-1))
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
|--
  (EX (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ),
  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-5)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y ) ”
  &&  “ forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg held )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q ))
  ||
  (EX (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ),
  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) = (-5)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-1)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y ) ”
  &&  “ forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg held )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q ))
  ||
  (EX (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ),
  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) = (-1)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-1)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y ) ”
  &&  “ forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg held )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q ))
.

Definition InitDataqueue_entail_wit_2_2 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) = 0)) (PreH3 : (retval_2 = 0)) (PreH4 : (p_queue_front = 0)) (PreH5 : (p_queue_rear = 0)) (PreH6 : (p_queue_max_len = 0)) (PreH7 : (p_queue_base = 0)) (PreH8 : (p_queue_sem_blank = 0)) (PreH9 : (p_queue_sem_data = 0)) (PreH10 : (retval = p_queue_pre)) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH12 : (p_queue_pre <> 0)) (PreH13 : (addr_aligned p_queue_pre 4 )) (PreH14 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> (-1))
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
|--
  (EX (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ),
  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-5)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y ) ”
  &&  “ forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg held )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q ))
  ||
  (EX (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ),
  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) = (-5)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-1)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y ) ”
  &&  “ forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg held )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q ))
  ||
  (EX (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ),
  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) = (-1)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-1)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y ) ”
  &&  “ forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg held )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q ))
.

Definition InitDataqueue_entail_wit_2_3 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (retval_2: Z) (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_3: Z) (PreH1 : (retval_3 < 0)) (PreH2 : (retval_3 = (-5))) (PreH3 : ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg (unsigned_last_nbits ((NodeNumber_pre - 1 )) (16)) observed retval_3 after_2 )) (PreH4 : (retval_2 <> 0)) (PreH5 : ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) > 0)) (PreH6 : (retval_2 > 0)) (PreH7 : (retval_2 <= (UINT_MAX - (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) ))) (PreH8 : (addr_aligned retval_2 4 )) (PreH9 : (p_queue_front = 0)) (PreH10 : (p_queue_rear = 0)) (PreH11 : (p_queue_max_len = 0)) (PreH12 : (p_queue_base = 0)) (PreH13 : (p_queue_sem_blank = 0)) (PreH14 : (p_queue_sem_data = 0)) (PreH15 : (retval = p_queue_pre)) (PreH16 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH17 : (p_queue_pre <> 0)) (PreH18 : (addr_aligned p_queue_pre 4 )) (PreH19 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after_2 )
  **  (CharArray.undef_full retval_2 (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> retval_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
|--
  (EX (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ),
  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-5)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y ) ”
  &&  “ forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg held )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q ))
  ||
  (EX (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ),
  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) = (-5)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-1)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y ) ”
  &&  “ forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg held )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q ))
  ||
  (EX (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ),
  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) = (-1)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-1)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y ) ”
  &&  “ forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg held )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q ))
.

Definition InitDataqueue_entail_wit_2_4 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (retval_2: Z) (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_3: Z) (after_3:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_4: Z) (PreH1 : (retval_4 < 0)) (PreH2 : (retval_4 = (-5))) (PreH3 : ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg 0 after_2 retval_4 after_3 )) (PreH4 : (retval_3 >= 0)) (PreH5 : (0 <= retval_3)) (PreH6 : (retval_3 < 128)) (PreH7 : ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg (unsigned_last_nbits ((NodeNumber_pre - 1 )) (16)) observed retval_3 after_2 )) (PreH8 : (retval_2 <> 0)) (PreH9 : ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) > 0)) (PreH10 : (retval_2 > 0)) (PreH11 : (retval_2 <= (UINT_MAX - (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) ))) (PreH12 : (addr_aligned retval_2 4 )) (PreH13 : (p_queue_front = 0)) (PreH14 : (p_queue_rear = 0)) (PreH15 : (p_queue_max_len = 0)) (PreH16 : (p_queue_base = 0)) (PreH17 : (p_queue_sem_blank = 0)) (PreH18 : (p_queue_sem_data = 0)) (PreH19 : (retval = p_queue_pre)) (PreH20 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH21 : (p_queue_pre <> 0)) (PreH22 : (addr_aligned p_queue_pre 4 )) (PreH23 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after_3 )
  **  (CharArray.undef_full retval_2 (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> retval_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> retval_4)
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
|--
  (EX (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ),
  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-5)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y ) ”
  &&  “ forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg held )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q ))
  ||
  (EX (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ),
  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) = (-5)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-1)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y ) ”
  &&  “ forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg held )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q ))
  ||
  (EX (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ),
  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) = (-1)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-1)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y ) ”
  &&  “ forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg held )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q ))
.

Definition InitDataqueue_return_wit_1 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after_3:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_3:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (after_4:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_4)) ( MonadErr.ret  (tt)) Y )) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q_3)) = p_queue_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_3)) = NodeNumber_pre)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_3)) = 0)) (PreH5 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_3)) = 0)) (PreH6 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_3)))) (PreH7 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_3)) = (-5))) (PreH8 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_3)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q_3) (refs)) Y )) (PreH9 : forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X ))) (PreH10 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after_3 )),
  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_3)) )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_4 )
|--
  (EX (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_2:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ),
  “ ((-1) = (-1)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q_2)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_2)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_2)) = (-1)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_2)) = (-5)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_2)) ( MonadErr.ret  ((-1))) X ) ”
  &&  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q_2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_2 ))
  ||
  (EX (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_2:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ),
  “ ((-1) = (-1)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q_2)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_2)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_2)) = (-5)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_2)) = (-1)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_2)) ( MonadErr.ret  ((-1))) X ) ”
  &&  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q_2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_2 ))
  ||
  (EX (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_2:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ),
  “ ((-1) = (-1)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q_2)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_2)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_2)) = (-1)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_2)) = (-1)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_2)) ( MonadErr.ret  ((-1))) X ) ”
  &&  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q_2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_2 ))
.

Definition InitDataqueue_return_wit_2 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after_3:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_3:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (after_4:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_4)) ( MonadErr.ret  (tt)) Y )) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q_3)) = p_queue_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_3)) = NodeNumber_pre)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_3)) = 0)) (PreH5 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_3)) = 0)) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_3)) = (-5))) (PreH7 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_3)) = (-1))) (PreH8 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_3)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q_3) (refs)) Y )) (PreH9 : forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X ))) (PreH10 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after_3 )),
  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_3)) )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_4 )
|--
  (EX (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_2:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ),
  “ ((-1) = (-1)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q_2)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_2)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_2)) = (-1)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_2)) = (-5)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_2)) ( MonadErr.ret  ((-1))) X ) ”
  &&  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q_2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_2 ))
  ||
  (EX (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_2:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ),
  “ ((-1) = (-1)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q_2)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_2)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_2)) = (-5)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_2)) = (-1)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_2)) ( MonadErr.ret  ((-1))) X ) ”
  &&  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q_2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_2 ))
  ||
  (EX (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_2:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ),
  “ ((-1) = (-1)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q_2)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_2)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_2)) = (-1)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_2)) = (-1)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_2)) ( MonadErr.ret  ((-1))) X ) ”
  &&  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q_2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_2 ))
.

Definition InitDataqueue_return_wit_3 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after_3:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_3:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (after_4:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_4)) ( MonadErr.ret  (tt)) Y )) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q_3)) = p_queue_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_3)) = NodeNumber_pre)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_3)) = 0)) (PreH5 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_3)) = 0)) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_3)) = (-1))) (PreH7 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_3)) = (-1))) (PreH8 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_3)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q_3) (refs)) Y )) (PreH9 : forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X ))) (PreH10 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after_3 )),
  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  ( CRTOS_Verify.lib.dataqueue.DataqueueState.dataqueue_retired  (q_3)) )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_4 )
|--
  (EX (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_2:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ),
  “ ((-1) = (-1)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q_2)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_2)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_2)) = (-1)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_2)) = (-5)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_2)) ( MonadErr.ret  ((-1))) X ) ”
  &&  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q_2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_2 ))
  ||
  (EX (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_2:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ),
  “ ((-1) = (-1)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q_2)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_2)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_2)) = (-5)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_2)) = (-1)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_2)) ( MonadErr.ret  ((-1))) X ) ”
  &&  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q_2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_2 ))
  ||
  (EX (after_2:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_2:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ),
  “ ((-1) = (-1)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q_2)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_2)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_2)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_2)) = (-1)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_2)) = (-1)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_2)) ( MonadErr.ret  ((-1))) X ) ”
  &&  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q_2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_2 ))
.

Definition InitDataqueue_return_wit_4 :=
(
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after_3:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_3:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (PreH1 : (In q_3 ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (after_3)) )) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q_3)) = p_queue_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_3)) = NodeNumber_pre)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_3)) = 0)) (PreH5 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_3)) = 0)) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_3)) <> 0)) (PreH7 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_3)))) (PreH8 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_3)))) (PreH9 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_3)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_3)))) (PreH10 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_3)) ( MonadErr.ret  (0)) X )) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed after_3 )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after_3 )
|--
  EX (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ),
  “ (0 = 0) ”
  &&  “ (In q ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (after)) ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) <> 0) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q))) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( MonadErr.ret  (0)) X ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after )
) \/
(
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (p_queue_pre: Z) (NodeNumber_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after_3:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q_3:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (PreH1 : (In q_3 ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (after_3)) )) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q_3)) = p_queue_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_3)) = NodeNumber_pre)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q_3)) = 0)) (PreH5 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q_3)) = 0)) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q_3)) <> 0)) (PreH7 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_3)))) (PreH8 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_3)))) (PreH9 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q_3)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q_3)))) (PreH10 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after_3)) ( MonadErr.ret  (0)) X )) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed after_3 )),
  TT && emp 
|--
  EX (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ),
  “ (In q ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (after_3)) ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q_3))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q_3))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) <> 0) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q))) ”
  &&  emp
).

Definition InitDataqueue_partial_solve_wit_1 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (PreH1 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ( CRTOS_Verify.lib.common.DataqueueInv.DataqueueStorage  p_queue_pre )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg before )
|--
  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X ) ”
  &&  ( CRTOS_Verify.lib.common.DataqueueInv.DataqueueStorage  p_queue_pre )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg before )
.

Definition InitDataqueue_partial_solve_wit_2 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (PreH1 : (p_queue_pre <> 0)) (PreH2 : (addr_aligned p_queue_pre 4 )) (PreH3 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  (CharArray.undef_full p_queue_pre sizeof( "DataQueue" ) )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg before )
|--
  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg before )
  **  (CharArray.undef_full p_queue_pre sizeof( "DataQueue" ) )
.

Definition InitDataqueue_partial_solve_wit_3_pure :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (retval: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  (CharArray.undef_full p_queue_pre sizeof( "DataQueue" ) )
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
|--
  “ (0 <= 0) ”
  &&  “ (0 <= 127) ”
.

Definition InitDataqueue_partial_solve_wit_3_aux :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (PreH1 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH2 : (p_queue_pre <> 0)) (PreH3 : (addr_aligned p_queue_pre 4 )) (PreH4 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  (CharArray.undef_full p_queue_pre sizeof( "DataQueue" ) )
|--
  “ (0 <= 0) ”
  &&  “ (0 <= 127) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed ) ”
  &&  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X ) ”
  &&  (CharArray.undef_full p_queue_pre sizeof( "DataQueue" ) )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
.

Definition InitDataqueue_partial_solve_wit_3 := InitDataqueue_partial_solve_wit_3_pure -> InitDataqueue_partial_solve_wit_3_aux.

Definition InitDataqueue_partial_solve_wit_4 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval: Z) (PreH1 : (retval = p_queue_pre)) (PreH2 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH3 : (p_queue_pre <> 0)) (PreH4 : (addr_aligned p_queue_pre 4 )) (PreH5 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  (CharArray.full p_queue_pre sizeof( "DataQueue" ) (repeat_Z (0) (sizeof( "DataQueue" ))) )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
|--
  “ (retval = p_queue_pre) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed ) ”
  &&  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X ) ”
  &&  (CharArray.full p_queue_pre sizeof( "DataQueue" ) (repeat_Z (0) (sizeof( "DataQueue" ))) )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
.

Definition InitDataqueue_partial_solve_wit_5 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (PreH1 : (p_queue_front = 0)) (PreH2 : (p_queue_rear = 0)) (PreH3 : (p_queue_max_len = 0)) (PreH4 : (p_queue_base = 0)) (PreH5 : (p_queue_sem_blank = 0)) (PreH6 : (p_queue_sem_data = 0)) (PreH7 : (retval = p_queue_pre)) (PreH8 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH9 : (p_queue_pre <> 0)) (PreH10 : (addr_aligned p_queue_pre 4 )) (PreH11 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> (-1))
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
|--
  “ (p_queue_front = 0) ”
  &&  “ (p_queue_rear = 0) ”
  &&  “ (p_queue_max_len = 0) ”
  &&  “ (p_queue_base = 0) ”
  &&  “ (p_queue_sem_blank = 0) ”
  &&  “ (p_queue_sem_data = 0) ”
  &&  “ (retval = p_queue_pre) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed ) ”
  &&  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X ) ”
  &&  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> (-1))
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
.

Definition InitDataqueue_partial_solve_wit_6 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (retval_2: Z) (PreH1 : (retval_2 <> 0)) (PreH2 : ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) > 0)) (PreH3 : (retval_2 > 0)) (PreH4 : (retval_2 <= (UINT_MAX - (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) ))) (PreH5 : (addr_aligned retval_2 4 )) (PreH6 : (p_queue_front = 0)) (PreH7 : (p_queue_rear = 0)) (PreH8 : (p_queue_max_len = 0)) (PreH9 : (p_queue_base = 0)) (PreH10 : (p_queue_sem_blank = 0)) (PreH11 : (p_queue_sem_data = 0)) (PreH12 : (retval = p_queue_pre)) (PreH13 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH14 : (p_queue_pre <> 0)) (PreH15 : (addr_aligned p_queue_pre 4 )) (PreH16 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  (CharArray.undef_full retval_2 (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> (-1))
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
|--
  “ (retval_2 <> 0) ”
  &&  “ ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) > 0) ”
  &&  “ (retval_2 > 0) ”
  &&  “ (retval_2 <= (UINT_MAX - (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) )) ”
  &&  “ (addr_aligned retval_2 4 ) ”
  &&  “ (p_queue_front = 0) ”
  &&  “ (p_queue_rear = 0) ”
  &&  “ (p_queue_max_len = 0) ”
  &&  “ (p_queue_base = 0) ”
  &&  “ (p_queue_sem_blank = 0) ”
  &&  “ (p_queue_sem_data = 0) ”
  &&  “ (retval = p_queue_pre) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed ) ”
  &&  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg observed )
  **  (CharArray.undef_full retval_2 (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> (-1))
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
.

Definition InitDataqueue_partial_solve_wit_7 :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (before:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval: Z) (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z) (retval_2: Z) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (retval_3: Z) (PreH1 : (retval_3 >= 0)) (PreH2 : (0 <= retval_3)) (PreH3 : (retval_3 < 128)) (PreH4 : ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg (unsigned_last_nbits ((NodeNumber_pre - 1 )) (16)) observed retval_3 after )) (PreH5 : (retval_2 <> 0)) (PreH6 : ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) > 0)) (PreH7 : (retval_2 > 0)) (PreH8 : (retval_2 <= (UINT_MAX - (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) ))) (PreH9 : (addr_aligned retval_2 4 )) (PreH10 : (p_queue_front = 0)) (PreH11 : (p_queue_rear = 0)) (PreH12 : (p_queue_max_len = 0)) (PreH13 : (p_queue_base = 0)) (PreH14 : (p_queue_sem_blank = 0)) (PreH15 : (p_queue_sem_data = 0)) (PreH16 : (retval = p_queue_pre)) (PreH17 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed )) (PreH18 : (p_queue_pre <> 0)) (PreH19 : (addr_aligned p_queue_pre 4 )) (PreH20 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X )),
  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  (CharArray.undef_full retval_2 (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> retval_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
|--
  “ (retval_3 >= 0) ”
  &&  “ (0 <= retval_3) ”
  &&  “ (retval_3 < 128) ”
  &&  “ ( CRTOS_Verify.lib.semaphore.KSemaphoreCreate.semaphore_create_ic_effect  sg (unsigned_last_nbits ((NodeNumber_pre - 1 )) (16)) observed retval_3 after ) ”
  &&  “ (retval_2 <> 0) ”
  &&  “ ((unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) > 0) ”
  &&  “ (retval_2 > 0) ”
  &&  “ (retval_2 <= (UINT_MAX - (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) )) ”
  &&  “ (addr_aligned retval_2 4 ) ”
  &&  “ (p_queue_front = 0) ”
  &&  “ (p_queue_rear = 0) ”
  &&  “ (p_queue_max_len = 0) ”
  &&  “ (p_queue_base = 0) ”
  &&  “ (p_queue_sem_blank = 0) ”
  &&  “ (p_queue_sem_data = 0) ”
  &&  “ (retval = p_queue_pre) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_RTrans  before observed ) ”
  &&  “ (p_queue_pre <> 0) ”
  &&  “ (addr_aligned p_queue_pre 4 ) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (before)) ( CRTOS_Verify.lib.dataqueue.KInitDataqueue.abs_init_dataqueue  (sg) (p_queue_pre) (NodeNumber_pre)) X ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  (CharArray.undef_full retval_2 (unsigned_last_nbits (((unsigned_last_nbits (NodeNumber_pre) (32)) * sizeof( "DataElem" ) )) (32)) )
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> NodeNumber_pre)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "base")) # Ptr  |-> retval_2)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> retval_3)
  **  ((&((p_queue_pre)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> (-1))
  **  (CharArray.undef_full (p_queue_pre + (6 * sizeof(CHAR))) 2 )
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
.

Definition InitDataqueue_partial_solve_wit_8_pure :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (saved: Z) (PreH1 : (In q ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (after)) )) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0)) (PreH5 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0)) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) <> 0)) (PreH7 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH8 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH9 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH10 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( MonadErr.ret  (0)) X )) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed after )),
  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed after ) ”
.

Definition InitDataqueue_partial_solve_wit_8_aux :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (observed:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (PreH1 : (In q ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (after)) )) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0)) (PreH5 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0)) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) <> 0)) (PreH7 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH8 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH9 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)))) (PreH10 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( MonadErr.ret  (0)) X )) (PreH11 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed after )),
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed after ) ”
  &&  “ (In q ( CRTOS_Verify.lib.common.CrtosGlobState.os_dataqueues  (after)) ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_base  (q)) <> 0) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) <> ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q))) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( MonadErr.ret  (0)) X ) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  observed after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg observed )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
.

Definition InitDataqueue_partial_solve_wit_8 := InitDataqueue_partial_solve_wit_8_pure -> InitDataqueue_partial_solve_wit_8_aux.

Definition InitDataqueue_partial_solve_wit_9_pure :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (saved: Z) (PreH1 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre)) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0)) (PreH5 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-5))) (PreH7 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y )) (PreH8 : forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X ))) (PreH9 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after )),
  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg held )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after ) ”
.

Definition InitDataqueue_partial_solve_wit_9_aux :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (PreH1 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre)) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0)) (PreH5 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-5))) (PreH7 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y )) (PreH8 : forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X ))) (PreH9 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after )),
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg held )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-5)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y ) ”
  &&  “ forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg held )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q )
.

Definition InitDataqueue_partial_solve_wit_9 := InitDataqueue_partial_solve_wit_9_pure -> InitDataqueue_partial_solve_wit_9_aux.

Definition InitDataqueue_partial_solve_wit_10_pure :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (saved: Z) (PreH1 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre)) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0)) (PreH5 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) = (-5))) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-1))) (PreH7 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y )) (PreH8 : forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X ))) (PreH9 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after )),
  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg held )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after ) ”
.

Definition InitDataqueue_partial_solve_wit_10_aux :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (PreH1 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre)) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0)) (PreH5 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) = (-5))) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-1))) (PreH7 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y )) (PreH8 : forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X ))) (PreH9 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after )),
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg held )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) = (-5)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-1)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y ) ”
  &&  “ forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg held )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q )
.

Definition InitDataqueue_partial_solve_wit_10 := InitDataqueue_partial_solve_wit_10_pure -> InitDataqueue_partial_solve_wit_10_aux.

Definition InitDataqueue_partial_solve_wit_11_pure :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (saved: Z) (PreH1 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre)) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0)) (PreH5 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) = (-1))) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-1))) (PreH7 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y )) (PreH8 : forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X ))) (PreH9 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after )),
  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
  **  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg held )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after ) ”
.

Definition InitDataqueue_partial_solve_wit_11_aux :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (PreH1 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre)) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0)) (PreH5 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) = (-1))) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-1))) (PreH7 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y )) (PreH8 : forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X ))) (PreH9 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after )),
  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg held )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q )
|--
  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) = (-1)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-1)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y ) ”
  &&  “ forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after ) ”
  &&  ( CRTOS_Verify.lib.common.CrtosRules.InsideCritical  sg held )
  **  ( CRTOS_Verify.lib.common.CrtosInv.os_inv  sg after )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q )
.

Definition InitDataqueue_partial_solve_wit_11 := InitDataqueue_partial_solve_wit_11_pure -> InitDataqueue_partial_solve_wit_11_aux.

Definition InitDataqueue_partial_solve_wit_12_pure :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (saved: Z) (PreH1 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre)) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0)) (PreH5 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-5))) (PreH7 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y )) (PreH8 : forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X ))) (PreH9 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after )
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q )
|--
  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y ) ”
.

Definition InitDataqueue_partial_solve_wit_12_aux :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (PreH1 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre)) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0)) (PreH5 : (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)))) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-5))) (PreH7 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y )) (PreH8 : forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X ))) (PreH9 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q )
|--
  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0) ”
  &&  “ (0 <= ( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q))) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-5)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y ) ”
  &&  “ forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after ) ”
  &&  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after )
.

Definition InitDataqueue_partial_solve_wit_12 := InitDataqueue_partial_solve_wit_12_pure -> InitDataqueue_partial_solve_wit_12_aux.

Definition InitDataqueue_partial_solve_wit_13_pure :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (saved: Z) (PreH1 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre)) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0)) (PreH5 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) = (-5))) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-1))) (PreH7 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y )) (PreH8 : forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X ))) (PreH9 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after )
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q )
|--
  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y ) ”
.

Definition InitDataqueue_partial_solve_wit_13_aux :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (PreH1 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre)) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0)) (PreH5 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) = (-5))) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-1))) (PreH7 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y )) (PreH8 : forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X ))) (PreH9 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q )
|--
  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) = (-5)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-1)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y ) ”
  &&  “ forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after ) ”
  &&  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after )
.

Definition InitDataqueue_partial_solve_wit_13 := InitDataqueue_partial_solve_wit_13_pure -> InitDataqueue_partial_solve_wit_13_aux.

Definition InitDataqueue_partial_solve_wit_14_pure :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (saved: Z) (PreH1 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre)) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0)) (PreH5 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) = (-1))) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-1))) (PreH7 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y )) (PreH8 : forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X ))) (PreH9 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after )
  **  ((( &( "lock" ) )) # Int  |-> saved)
  **  ((( &( "p_queue" ) )) # Ptr  |-> p_queue_pre)
  **  ((( &( "NodeNumber" ) )) # UShort  |-> NodeNumber_pre)
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q )
|--
  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y ) ”
.

Definition InitDataqueue_partial_solve_wit_14_aux :=
forall (X: (Z -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (sg:  CRTOS_Verify.lib.common.CrtosGlobState.StableGlobalState ) (p_queue_pre: Z) (NodeNumber_pre: Z) (held:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (after:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ) (q:  CRTOS_Verify.lib.dataqueue.DataqueueState.DataqueueObject ) (refs:  CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.DataqueueSemRefs ) (Y: (unit -> (( CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState  -> Prop) -> Prop))) (PreH1 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre)) (PreH2 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre)) (PreH3 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0)) (PreH4 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0)) (PreH5 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) = (-1))) (PreH6 : (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-1))) (PreH7 : ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y )) (PreH8 : forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X ))) (PreH9 : ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after )),
  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after )
  **  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q )
|--
  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y ) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_addr  (q)) = p_queue_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_max_len  (q)) = NodeNumber_pre) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_front  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_rear  (q)) = 0) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_blank  (q)) = (-1)) ”
  &&  “ (( CRTOS_Verify.lib.dataqueue.DataqueueState.dq_sem_data  (q)) = (-1)) ”
  &&  “ ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (after)) ( CRTOS_Verify.lib.dataqueue.KDeInitDataqueue.abs_deinit_dataqueue  (sg) (q) (refs)) Y ) ”
  &&  “ forall (final:  CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState ), (( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  (tt)) Y ) -> ( monadesafe_lib.safeExec  ( CRTOS_Verify.lib.common.CrtosRules.LastSeen  (final)) ( MonadErr.ret  ((-1))) X )) ”
  &&  “ ( CRTOS_Verify.lib.common.CrtosRules.Crtos_GTrans  held after ) ”
  &&  ( CRTOS_Verify.lib.common.DataqueueInv.dataqueue_owned  q )
  **  ( CRTOS_Verify.lib.common.CrtosRules.OutsideCritical  sg after )
.

Definition InitDataqueue_partial_solve_wit_14 := InitDataqueue_partial_solve_wit_14_pure -> InitDataqueue_partial_solve_wit_14_aux.

Definition InitDataqueue_which_implies_wit_1 :=
(
forall (p_queue: Z),
  ( CRTOS_Verify.lib.common.DataqueueInv.DataqueueStorage  p_queue )
|--
  “ (p_queue <> 0) ”
  &&  “ (addr_aligned p_queue 4 ) ”
  &&  (CharArray.undef_full p_queue sizeof( "DataQueue" ) )
) \/
(
forall (p_queue: Z),
  ( CRTOS_Verify.lib.common.DataqueueInv.DataqueueStorage  p_queue )
|--
  “ (addr_aligned p_queue 4 ) ”
  &&  “ (p_queue <> 0) ”
  &&  (CharArray.undef_full p_queue sizeof( "DataQueue" ) )
).

Definition InitDataqueue_which_implies_wit_1_split_goal_1 :=
forall (p_queue: Z),
  ( CRTOS_Verify.lib.common.DataqueueInv.DataqueueStorage  p_queue )
|--
  “ (addr_aligned p_queue 4 ) ”
.

Definition InitDataqueue_which_implies_wit_1_split_goal_2 :=
forall (p_queue: Z),
  ( CRTOS_Verify.lib.common.DataqueueInv.DataqueueStorage  p_queue )
|--
  “ (p_queue <> 0) ”
.

Definition InitDataqueue_which_implies_wit_1_split_goal_spatial :=
forall (p_queue: Z),
  ( CRTOS_Verify.lib.common.DataqueueInv.DataqueueStorage  p_queue )
|--
  (CharArray.undef_full p_queue sizeof( "DataQueue" ) )
.

Definition InitDataqueue_which_implies_wit_2 :=
(
forall (p_queue: Z),
  (CharArray.full p_queue sizeof( "DataQueue" ) (repeat_Z (0) (sizeof( "DataQueue" ))) )
|--
  EX (p_queue_sem_data: Z) (p_queue_sem_blank: Z) (p_queue_base: Z) (p_queue_max_len: Z) (p_queue_rear: Z) (p_queue_front: Z),
  “ (p_queue_front = 0) ”
  &&  “ (p_queue_rear = 0) ”
  &&  “ (p_queue_max_len = 0) ”
  &&  “ (p_queue_base = 0) ”
  &&  “ (p_queue_sem_blank = 0) ”
  &&  “ (p_queue_sem_data = 0) ”
  &&  ((&((p_queue)  # "DataQueue" ->ₛ "front")) # UShort  |-> p_queue_front)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "rear")) # UShort  |-> p_queue_rear)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> p_queue_max_len)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "base")) # Ptr  |-> p_queue_base)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> p_queue_sem_blank)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> p_queue_sem_data)
  **  (CharArray.undef_full (p_queue + (6 * sizeof(CHAR))) 2 )
) \/
(
forall (p_queue: Z),
  (CharArray.full p_queue sizeof( "DataQueue" ) (repeat_Z (0) (sizeof( "DataQueue" ))) )
|--
  ((&((p_queue)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> 0)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "base")) # Ptr  |-> 0)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> 0)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> 0)
  **  (CharArray.undef_full (p_queue + (6 * sizeof(CHAR))) 2 )
).

Definition InitDataqueue_which_implies_wit_2_split_goal_spatial :=
forall (p_queue: Z),
  (CharArray.full p_queue sizeof( "DataQueue" ) (repeat_Z (0) (sizeof( "DataQueue" ))) )
|--
  ((&((p_queue)  # "DataQueue" ->ₛ "front")) # UShort  |-> 0)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "rear")) # UShort  |-> 0)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "max_len")) # UShort  |-> 0)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "base")) # Ptr  |-> 0)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "sem_blank")) # Int  |-> 0)
  **  ((&((p_queue)  # "DataQueue" ->ₛ "sem_data")) # Int  |-> 0)
  **  (CharArray.undef_full (p_queue + (6 * sizeof(CHAR))) 2 )
.

Module Type VC_Correct.


Axiom proof_of_InitDataqueue_safety_wit_1 : InitDataqueue_safety_wit_1.
Axiom proof_of_InitDataqueue_safety_wit_2 : InitDataqueue_safety_wit_2.
Axiom proof_of_InitDataqueue_safety_wit_3 : InitDataqueue_safety_wit_3.
Axiom proof_of_InitDataqueue_safety_wit_4 : InitDataqueue_safety_wit_4.
Axiom proof_of_InitDataqueue_safety_wit_5 : InitDataqueue_safety_wit_5.
Axiom proof_of_InitDataqueue_safety_wit_6 : InitDataqueue_safety_wit_6.
Axiom proof_of_InitDataqueue_safety_wit_7 : InitDataqueue_safety_wit_7.
Axiom proof_of_InitDataqueue_safety_wit_8 : InitDataqueue_safety_wit_8.
Axiom proof_of_InitDataqueue_safety_wit_9 : InitDataqueue_safety_wit_9.
Axiom proof_of_InitDataqueue_safety_wit_10 : InitDataqueue_safety_wit_10.
Axiom proof_of_InitDataqueue_safety_wit_11 : InitDataqueue_safety_wit_11.
Axiom proof_of_InitDataqueue_safety_wit_12 : InitDataqueue_safety_wit_12.
Axiom proof_of_InitDataqueue_safety_wit_13 : InitDataqueue_safety_wit_13.
Axiom proof_of_InitDataqueue_safety_wit_14 : InitDataqueue_safety_wit_14.
Axiom proof_of_InitDataqueue_safety_wit_15 : InitDataqueue_safety_wit_15.
Axiom proof_of_InitDataqueue_safety_wit_16 : InitDataqueue_safety_wit_16.
Axiom proof_of_InitDataqueue_safety_wit_17 : InitDataqueue_safety_wit_17.
Axiom proof_of_InitDataqueue_safety_wit_18 : InitDataqueue_safety_wit_18.
Axiom proof_of_InitDataqueue_safety_wit_19 : InitDataqueue_safety_wit_19.
Axiom proof_of_InitDataqueue_safety_wit_20 : InitDataqueue_safety_wit_20.
Axiom proof_of_InitDataqueue_safety_wit_21 : InitDataqueue_safety_wit_21.
Axiom proof_of_InitDataqueue_safety_wit_22 : InitDataqueue_safety_wit_22.
Axiom proof_of_InitDataqueue_safety_wit_23 : InitDataqueue_safety_wit_23.
Axiom proof_of_InitDataqueue_safety_wit_24 : InitDataqueue_safety_wit_24.
Axiom proof_of_InitDataqueue_safety_wit_25 : InitDataqueue_safety_wit_25.
Axiom proof_of_InitDataqueue_safety_wit_26 : InitDataqueue_safety_wit_26.
Axiom proof_of_InitDataqueue_safety_wit_27 : InitDataqueue_safety_wit_27.
Axiom proof_of_InitDataqueue_safety_wit_28 : InitDataqueue_safety_wit_28.
Axiom proof_of_InitDataqueue_safety_wit_29 : InitDataqueue_safety_wit_29.
Axiom proof_of_InitDataqueue_entail_wit_1 : InitDataqueue_entail_wit_1.
Axiom proof_of_InitDataqueue_entail_wit_2_1 : InitDataqueue_entail_wit_2_1.
Axiom proof_of_InitDataqueue_entail_wit_2_2 : InitDataqueue_entail_wit_2_2.
Axiom proof_of_InitDataqueue_entail_wit_2_3 : InitDataqueue_entail_wit_2_3.
Axiom proof_of_InitDataqueue_entail_wit_2_4 : InitDataqueue_entail_wit_2_4.
Axiom proof_of_InitDataqueue_return_wit_1 : InitDataqueue_return_wit_1.
Axiom proof_of_InitDataqueue_return_wit_2 : InitDataqueue_return_wit_2.
Axiom proof_of_InitDataqueue_return_wit_3 : InitDataqueue_return_wit_3.
Axiom proof_of_InitDataqueue_return_wit_4 : InitDataqueue_return_wit_4.
Axiom proof_of_InitDataqueue_partial_solve_wit_1 : InitDataqueue_partial_solve_wit_1.
Axiom proof_of_InitDataqueue_partial_solve_wit_2 : InitDataqueue_partial_solve_wit_2.
Axiom proof_of_InitDataqueue_partial_solve_wit_3_pure : InitDataqueue_partial_solve_wit_3_pure.
Axiom proof_of_InitDataqueue_partial_solve_wit_3 : InitDataqueue_partial_solve_wit_3.
Axiom proof_of_InitDataqueue_partial_solve_wit_4 : InitDataqueue_partial_solve_wit_4.
Axiom proof_of_InitDataqueue_partial_solve_wit_5 : InitDataqueue_partial_solve_wit_5.
Axiom proof_of_InitDataqueue_partial_solve_wit_6 : InitDataqueue_partial_solve_wit_6.
Axiom proof_of_InitDataqueue_partial_solve_wit_7 : InitDataqueue_partial_solve_wit_7.
Axiom proof_of_InitDataqueue_partial_solve_wit_8_pure : InitDataqueue_partial_solve_wit_8_pure.
Axiom proof_of_InitDataqueue_partial_solve_wit_8 : InitDataqueue_partial_solve_wit_8.
Axiom proof_of_InitDataqueue_partial_solve_wit_9_pure : InitDataqueue_partial_solve_wit_9_pure.
Axiom proof_of_InitDataqueue_partial_solve_wit_9 : InitDataqueue_partial_solve_wit_9.
Axiom proof_of_InitDataqueue_partial_solve_wit_10_pure : InitDataqueue_partial_solve_wit_10_pure.
Axiom proof_of_InitDataqueue_partial_solve_wit_10 : InitDataqueue_partial_solve_wit_10.
Axiom proof_of_InitDataqueue_partial_solve_wit_11_pure : InitDataqueue_partial_solve_wit_11_pure.
Axiom proof_of_InitDataqueue_partial_solve_wit_11 : InitDataqueue_partial_solve_wit_11.
Axiom proof_of_InitDataqueue_partial_solve_wit_12_pure : InitDataqueue_partial_solve_wit_12_pure.
Axiom proof_of_InitDataqueue_partial_solve_wit_12 : InitDataqueue_partial_solve_wit_12.
Axiom proof_of_InitDataqueue_partial_solve_wit_13_pure : InitDataqueue_partial_solve_wit_13_pure.
Axiom proof_of_InitDataqueue_partial_solve_wit_13 : InitDataqueue_partial_solve_wit_13.
Axiom proof_of_InitDataqueue_partial_solve_wit_14_pure : InitDataqueue_partial_solve_wit_14_pure.
Axiom proof_of_InitDataqueue_partial_solve_wit_14 : InitDataqueue_partial_solve_wit_14.
Axiom proof_of_InitDataqueue_which_implies_wit_1 : InitDataqueue_which_implies_wit_1.
Axiom proof_of_InitDataqueue_which_implies_wit_2 : InitDataqueue_which_implies_wit_2.

End VC_Correct.
