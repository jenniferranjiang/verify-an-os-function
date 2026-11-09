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
Require Import CRTOS_Verify.lib.IdModuleSpec CRTOS_Verify.lib.DoubleLinkListSpec.
Require Import CRTOS_Verify.lib.KEventDelete.
Import IDNode DLL MonadErr.
Require Import CRTOS_Verify.VC.EventDelete_lib.
Local Open Scope sac.

(*----- Function _EventDelete -----*)

Definition _EventDelete_safety_wit_1 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (PreH1 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  ((( &( "resched" ) )) # Int  |->_)
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
  **  (OutsideCritical sg_event_delete_at_oc before_event_delete_at_oc )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _EventDelete_safety_wit_2 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (PreH1 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  ((( &( "lock" ) )) # Int  |->_)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
  **  (OutsideCritical sg_event_delete_at_oc before_event_delete_at_oc )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _EventDelete_safety_wit_3 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (PreH1 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  ((( &( "inspect_lock" ) )) # Int  |->_)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
  **  (OutsideCritical sg_event_delete_at_oc before_event_delete_at_oc )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _EventDelete_safety_wit_4 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (PreH1 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  ((( &( "pending_empty" ) )) # Int  |->_)
  **  ((( &( "inspect_lock" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
  **  (OutsideCritical sg_event_delete_at_oc before_event_delete_at_oc )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition _EventDelete_safety_wit_5 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (PreH1 : (event_pre = 0)) (PreH2 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  ((( &( "event" ) )) # Ptr  |-> event_pre)
  **  ((( &( "resched" ) )) # Int  |->_)
  **  ((( &( "lock" ) )) # Int  |->_)
  **  ((( &( "inspect_lock" ) )) # Int  |->_)
  **  ((( &( "pending_empty" ) )) # Int  |->_)
  **  (OutsideCritical sg_event_delete_at_oc before_event_delete_at_oc )
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition _EventDelete_safety_wit_6 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (retval: Z) (checked: VarGlobalState) (waiting: (@list Z)) (retval_2: Z) (PreH1 : (retval_2 <> 0)) (PreH2 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH3 : (Crtos_GTrans checked checked )) (PreH4 : (retval_2 = 0)) (PreH5 : ((map (event_wait_node) (waiting)) <> (@nil (@DL_Node Z)))) (PreH6 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH7 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH8 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH9 : ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list"))) (PreH10 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH11 : (event_pre <> 0)) (PreH12 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (OutsideCritical sg_event_delete_at_oc checked )
  **  ((( &( "pending_empty" ) )) # Int  |-> retval_2)
  **  ((( &( "inspect_lock" ) )) # Int  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
|--
  “ False ”
.

Definition _EventDelete_safety_wit_7 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (retval: Z) (checked: VarGlobalState) (waiting: (@list Z)) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH3 : (Crtos_GTrans checked checked )) (PreH4 : (retval_2 = 1)) (PreH5 : ((map (event_wait_node) (waiting)) = (@nil (@DL_Node Z)))) (PreH6 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH7 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH8 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH9 : ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list"))) (PreH10 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH11 : (event_pre <> 0)) (PreH12 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (OutsideCritical sg_event_delete_at_oc checked )
  **  ((( &( "pending_empty" ) )) # Int  |-> retval_2)
  **  ((( &( "inspect_lock" ) )) # Int  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
|--
  “ False ”
.

Definition _EventDelete_safety_wit_8 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (retval: Z) (checked: VarGlobalState) (waiting: (@list Z)) (retval_2: Z) (PreH1 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (checked)) (abs_event_resume_all (id_event_delete_at_oc) (event_pre)) (event_delete_resume_cont (id_event_delete_at_oc) (event_pre) (X_event_delete_at_oc)) )) (PreH3 : (retval_2 = 0)) (PreH4 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH5 : (Crtos_GTrans checked checked )) (PreH6 : (retval_2 = 0)) (PreH7 : ((map (event_wait_node) (waiting)) <> (@nil (@DL_Node Z)))) (PreH8 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH9 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH10 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH11 : ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list"))) (PreH12 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH13 : (event_pre <> 0)) (PreH14 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (OutsideCritical sg_event_delete_at_oc checked )
  **  ((( &( "pending_empty" ) )) # Int  |-> retval_2)
  **  ((( &( "inspect_lock" ) )) # Int  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition _EventDelete_safety_wit_9 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (locked: VarGlobalState) (resched: Z) (after: VarGlobalState) (saved_lock: Z) (PreH1 : (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) (PreH2 : (resched = 1)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_event_delete_at_oc )) (PreH4 : (Crtos_GTrans locked after )) (PreH5 : (resched = 0)) ,
  (OutsideCritical sg_event_delete_at_oc after )
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
  **  ((( &( "delete_event_id" ) )) # UShort  |-> id_event_delete_at_oc)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "inspect_lock" ) )) # Int  |->_)
  **  ((( &( "pending_empty" ) )) # Int  |->_)
|--
  “ False ”
.

Definition _EventDelete_safety_wit_10 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (locked: VarGlobalState) (resched: Z) (after: VarGlobalState) (saved_lock: Z) (PreH1 : (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) (PreH2 : (resched = 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_event_delete_at_oc )) (PreH4 : (Crtos_GTrans locked after )) (PreH5 : (resched <> 0)) ,
  (OutsideCritical sg_event_delete_at_oc after )
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
  **  ((( &( "delete_event_id" ) )) # UShort  |-> id_event_delete_at_oc)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "inspect_lock" ) )) # Int  |->_)
  **  ((( &( "pending_empty" ) )) # Int  |->_)
|--
  “ False ”
.

Definition _EventDelete_entail_wit_1 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (PreH1 : (event_pre = 0)) (PreH2 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  ((( &( "inspect_lock" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  (OutsideCritical sg_event_delete_at_oc before_event_delete_at_oc )
|--
  “ (event_pre = 0) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc ) ”
  &&  ((( &( "resched" ) )) # Int  |->_)
  **  ((( &( "lock" ) )) # Int  |->_)
  **  ((( &( "inspect_lock" ) )) # Int  |->_)
  **  (OutsideCritical sg_event_delete_at_oc before_event_delete_at_oc )
.

Definition _EventDelete_entail_wit_2 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (PreH1 : (event_pre = 0)) (PreH2 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (OutsideCritical sg_event_delete_at_oc before_event_delete_at_oc )
|--
  “ (event_pre = 0) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc ) ”
  &&  (OutsideCritical sg_event_delete_at_oc before_event_delete_at_oc )
.

Definition _EventDelete_entail_wit_3_1 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (retval: Z) (checked: VarGlobalState) (waiting: (@list Z)) (retval_2: Z) (retval_3: Z) (drained: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (drained)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc )) (PreH2 : (retval_3 = 0)) (PreH3 : (event_delete_guard id_event_delete_at_oc event_pre true drained )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (event_delete_resume_cont (id_event_delete_at_oc) (event_pre) (X_event_delete_at_oc)) )) (PreH5 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (checked)) (abs_event_resume_all (id_event_delete_at_oc) (event_pre)) (event_delete_resume_cont (id_event_delete_at_oc) (event_pre) (X_event_delete_at_oc)) )) (PreH7 : (retval_2 = 0)) (PreH8 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH9 : (Crtos_GTrans checked checked )) (PreH10 : (retval_2 = 0)) (PreH11 : ((map (event_wait_node) (waiting)) <> (@nil (@DL_Node Z)))) (PreH12 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH13 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH14 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH15 : ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list"))) (PreH16 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH17 : (event_pre <> 0)) (PreH18 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH19 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (OutsideCritical sg_event_delete_at_oc drained )
  **  ((( &( "pending_empty" ) )) # Int  |-> retval_2)
  **  ((( &( "inspect_lock" ) )) # Int  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
|--
  EX (ready: VarGlobalState) ,
  “ (1 = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre true ready ) ”
  &&  ((( &( "lock" ) )) # Int  |->_)
  **  ((( &( "inspect_lock" ) )) # Int  |->_)
  **  ((( &( "pending_empty" ) )) # Int  |->_)
  **  (OutsideCritical sg_event_delete_at_oc ready )
.

Definition _EventDelete_entail_wit_3_2 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (retval: Z) (checked: VarGlobalState) (waiting: (@list Z)) (retval_2: Z) (PreH1 : (event_delete_guard id_event_delete_at_oc event_pre true checked )) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (checked)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc )) (PreH3 : (retval_2 <> 0)) (PreH4 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH5 : (Crtos_GTrans checked checked )) (PreH6 : (retval_2 = 1)) (PreH7 : ((map (event_wait_node) (waiting)) = (@nil (@DL_Node Z)))) (PreH8 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH9 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH10 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH11 : ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list"))) (PreH12 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH13 : (event_pre <> 0)) (PreH14 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (OutsideCritical sg_event_delete_at_oc checked )
  **  ((( &( "pending_empty" ) )) # Int  |-> retval_2)
  **  ((( &( "inspect_lock" ) )) # Int  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
|--
  EX (ready: VarGlobalState) ,
  “ (0 = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre true ready ) ”
  &&  ((( &( "lock" ) )) # Int  |->_)
  **  ((( &( "inspect_lock" ) )) # Int  |->_)
  **  ((( &( "pending_empty" ) )) # Int  |->_)
  **  (OutsideCritical sg_event_delete_at_oc ready )
.

Definition _EventDelete_entail_wit_4_1 := 
(
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = false)) (PreH2 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH3 : ((event_addr (original)) = event_pre)) (PreH4 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH5 : ((event_addr (original)) = event_pre)) (PreH6 : ((event_id (original)) = id_event_delete_at_oc)) (PreH7 : ((event_pending_addrs (original)) = (@nil Z))) (PreH8 : (event_pre <> 0)) (PreH9 : (0 <= id_event_delete_at_oc)) (PreH10 : (id_event_delete_at_oc < 65536)) (PreH11 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH12 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH13 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH14 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH15 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH16 : (resched = 1)) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc )) (PreH18 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((map (event_link_node) (suffix)))) )
  **  (store_event (pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "link") original )
  **  (store_node_self_linked &((event_pre)  # "Event" ->ₛ "link") )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  EX (after: VarGlobalState) ,
  “ (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked))) ” 
  &&  “ (resched = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_event_delete_at_oc ) ” 
  &&  “ (Crtos_GTrans locked after ) ”
  &&  (InsideCritical sg_event_delete_at_oc locked )
  **  (os_inv sg_event_delete_at_oc after )
  **  (EventRetired event_pre (event_options (original)) (event_events (original)) )
) \/
(
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = false)) (PreH2 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH3 : ((event_addr (original)) = event_pre)) (PreH4 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH5 : ((event_addr (original)) = event_pre)) (PreH6 : ((event_id (original)) = id_event_delete_at_oc)) (PreH7 : ((event_pending_addrs (original)) = (@nil Z))) (PreH8 : (event_pre <> 0)) (PreH9 : (0 <= id_event_delete_at_oc)) (PreH10 : (id_event_delete_at_oc < 65536)) (PreH11 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH12 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH13 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH14 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH15 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH16 : (resched = 1)) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc )) (PreH18 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((map (event_link_node) (suffix)))) )
  **  (store_event (pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "link") original )
  **  (store_node_self_linked &((event_pre)  # "Event" ->ₛ "link") )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  “ (Crtos_GTrans locked (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)) ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen ((replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) abs_ktask_assign X_event_delete_at_oc ) ”
  &&  (InsideCritical sg_event_delete_at_oc locked )
  **  (os_inv sg_event_delete_at_oc (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)) )
  **  (EventRetired event_pre (event_options (original)) (event_events (original)) )
).

Definition _EventDelete_entail_wit_4_1_split_goal_1 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = false)) (PreH2 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH3 : ((event_addr (original)) = event_pre)) (PreH4 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH5 : ((event_addr (original)) = event_pre)) (PreH6 : ((event_id (original)) = id_event_delete_at_oc)) (PreH7 : ((event_pending_addrs (original)) = (@nil Z))) (PreH8 : (event_pre <> 0)) (PreH9 : (0 <= id_event_delete_at_oc)) (PreH10 : (id_event_delete_at_oc < 65536)) (PreH11 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH12 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH13 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH14 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH15 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH16 : (resched = 1)) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc )) (PreH18 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((map (event_link_node) (suffix)))) )
  **  (store_event (pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "link") original )
  **  (store_node_self_linked &((event_pre)  # "Event" ->ₛ "link") )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  “ (Crtos_GTrans locked (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)) ) ”
.

Definition _EventDelete_entail_wit_4_1_split_goal_2 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = false)) (PreH2 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH3 : ((event_addr (original)) = event_pre)) (PreH4 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH5 : ((event_addr (original)) = event_pre)) (PreH6 : ((event_id (original)) = id_event_delete_at_oc)) (PreH7 : ((event_pending_addrs (original)) = (@nil Z))) (PreH8 : (event_pre <> 0)) (PreH9 : (0 <= id_event_delete_at_oc)) (PreH10 : (id_event_delete_at_oc < 65536)) (PreH11 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH12 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH13 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH14 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH15 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH16 : (resched = 1)) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc )) (PreH18 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((map (event_link_node) (suffix)))) )
  **  (store_event (pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "link") original )
  **  (store_node_self_linked &((event_pre)  # "Event" ->ₛ "link") )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen ((replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) abs_ktask_assign X_event_delete_at_oc ) ”
.

Definition _EventDelete_entail_wit_4_1_split_goal_spatial := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = false)) (PreH2 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH3 : ((event_addr (original)) = event_pre)) (PreH4 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH5 : ((event_addr (original)) = event_pre)) (PreH6 : ((event_id (original)) = id_event_delete_at_oc)) (PreH7 : ((event_pending_addrs (original)) = (@nil Z))) (PreH8 : (event_pre <> 0)) (PreH9 : (0 <= id_event_delete_at_oc)) (PreH10 : (id_event_delete_at_oc < 65536)) (PreH11 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH12 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH13 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH14 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH15 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH16 : (resched = 1)) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc )) (PreH18 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((map (event_link_node) (suffix)))) )
  **  (store_event (pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "link") original )
  **  (store_node_self_linked &((event_pre)  # "Event" ->ₛ "link") )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  (InsideCritical sg_event_delete_at_oc locked )
  **  (os_inv sg_event_delete_at_oc (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)) )
  **  (EventRetired event_pre (event_options (original)) (event_events (original)) )
.

Definition _EventDelete_entail_wit_4_2 := 
(
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (idnode: Z) (PreH1 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH2 : (idmanager_contains (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) id_event_delete_at_oc idnode )) (PreH3 : (idnode <> 0)) (PreH4 : (&((idnode)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH6 : ((event_addr (original)) = event_pre)) (PreH7 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH8 : ((event_addr (original)) = event_pre)) (PreH9 : ((event_id (original)) = id_event_delete_at_oc)) (PreH10 : ((event_pending_addrs (original)) = (@nil Z))) (PreH11 : (event_pre <> 0)) (PreH12 : (0 <= id_event_delete_at_oc)) (PreH13 : (id_event_delete_at_oc < 65536)) (PreH14 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH15 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH16 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH17 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH18 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH19 : (resched = 1)) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc )) (PreH21 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((map (event_link_node) (suffix)))) )
  **  (store_event (pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "link") original )
  **  (store_node_self_linked &((event_pre)  # "Event" ->ₛ "link") )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) ( &( "k_event_id_manager" ) ) )
  **  ((&((idnode)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  EX (after: VarGlobalState) ,
  “ (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked))) ” 
  &&  “ (resched = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_event_delete_at_oc ) ” 
  &&  “ (Crtos_GTrans locked after ) ”
  &&  (InsideCritical sg_event_delete_at_oc locked )
  **  (os_inv sg_event_delete_at_oc after )
  **  (EventRetired event_pre (event_options (original)) (event_events (original)) )
) \/
(
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (idnode: Z) (PreH1 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH2 : (idmanager_contains (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) id_event_delete_at_oc idnode )) (PreH3 : (idnode <> 0)) (PreH4 : (&((idnode)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH6 : ((event_addr (original)) = event_pre)) (PreH7 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH8 : ((event_addr (original)) = event_pre)) (PreH9 : ((event_id (original)) = id_event_delete_at_oc)) (PreH10 : ((event_pending_addrs (original)) = (@nil Z))) (PreH11 : (event_pre <> 0)) (PreH12 : (0 <= id_event_delete_at_oc)) (PreH13 : (id_event_delete_at_oc < 65536)) (PreH14 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH15 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH16 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH17 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH18 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH19 : (resched = 1)) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc )) (PreH21 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((map (event_link_node) (suffix)))) )
  **  (store_event (pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "link") original )
  **  (store_node_self_linked &((event_pre)  # "Event" ->ₛ "link") )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) ( &( "k_event_id_manager" ) ) )
  **  ((&((idnode)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  “ (Crtos_GTrans locked (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)) ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen ((replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) abs_ktask_assign X_event_delete_at_oc ) ”
  &&  (InsideCritical sg_event_delete_at_oc locked )
  **  (os_inv sg_event_delete_at_oc (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)) )
  **  (EventRetired event_pre (event_options (original)) (event_events (original)) )
).

Definition _EventDelete_entail_wit_4_2_split_goal_1 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (idnode: Z) (PreH1 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH2 : (idmanager_contains (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) id_event_delete_at_oc idnode )) (PreH3 : (idnode <> 0)) (PreH4 : (&((idnode)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH6 : ((event_addr (original)) = event_pre)) (PreH7 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH8 : ((event_addr (original)) = event_pre)) (PreH9 : ((event_id (original)) = id_event_delete_at_oc)) (PreH10 : ((event_pending_addrs (original)) = (@nil Z))) (PreH11 : (event_pre <> 0)) (PreH12 : (0 <= id_event_delete_at_oc)) (PreH13 : (id_event_delete_at_oc < 65536)) (PreH14 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH15 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH16 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH17 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH18 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH19 : (resched = 1)) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc )) (PreH21 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((map (event_link_node) (suffix)))) )
  **  (store_event (pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "link") original )
  **  (store_node_self_linked &((event_pre)  # "Event" ->ₛ "link") )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) ( &( "k_event_id_manager" ) ) )
  **  ((&((idnode)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  “ (Crtos_GTrans locked (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)) ) ”
.

Definition _EventDelete_entail_wit_4_2_split_goal_2 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (idnode: Z) (PreH1 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH2 : (idmanager_contains (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) id_event_delete_at_oc idnode )) (PreH3 : (idnode <> 0)) (PreH4 : (&((idnode)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH6 : ((event_addr (original)) = event_pre)) (PreH7 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH8 : ((event_addr (original)) = event_pre)) (PreH9 : ((event_id (original)) = id_event_delete_at_oc)) (PreH10 : ((event_pending_addrs (original)) = (@nil Z))) (PreH11 : (event_pre <> 0)) (PreH12 : (0 <= id_event_delete_at_oc)) (PreH13 : (id_event_delete_at_oc < 65536)) (PreH14 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH15 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH16 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH17 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH18 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH19 : (resched = 1)) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc )) (PreH21 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((map (event_link_node) (suffix)))) )
  **  (store_event (pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "link") original )
  **  (store_node_self_linked &((event_pre)  # "Event" ->ₛ "link") )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) ( &( "k_event_id_manager" ) ) )
  **  ((&((idnode)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen ((replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) abs_ktask_assign X_event_delete_at_oc ) ”
.

Definition _EventDelete_entail_wit_4_2_split_goal_spatial := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (idnode: Z) (PreH1 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH2 : (idmanager_contains (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) id_event_delete_at_oc idnode )) (PreH3 : (idnode <> 0)) (PreH4 : (&((idnode)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH6 : ((event_addr (original)) = event_pre)) (PreH7 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH8 : ((event_addr (original)) = event_pre)) (PreH9 : ((event_id (original)) = id_event_delete_at_oc)) (PreH10 : ((event_pending_addrs (original)) = (@nil Z))) (PreH11 : (event_pre <> 0)) (PreH12 : (0 <= id_event_delete_at_oc)) (PreH13 : (id_event_delete_at_oc < 65536)) (PreH14 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH15 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH16 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH17 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH18 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH19 : (resched = 1)) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc )) (PreH21 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((map (event_link_node) (suffix)))) )
  **  (store_event (pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "link") original )
  **  (store_node_self_linked &((event_pre)  # "Event" ->ₛ "link") )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) ( &( "k_event_id_manager" ) ) )
  **  ((&((idnode)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  (InsideCritical sg_event_delete_at_oc locked )
  **  (os_inv sg_event_delete_at_oc (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)) )
  **  (EventRetired event_pre (event_options (original)) (event_events (original)) )
.

Definition _EventDelete_entail_wit_4_3 := 
(
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = false)) (PreH2 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH3 : ((event_addr (original)) = event_pre)) (PreH4 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH5 : ((event_addr (original)) = event_pre)) (PreH6 : ((event_id (original)) = id_event_delete_at_oc)) (PreH7 : ((event_pending_addrs (original)) = (@nil Z))) (PreH8 : (event_pre <> 0)) (PreH9 : (0 <= id_event_delete_at_oc)) (PreH10 : (id_event_delete_at_oc < 65536)) (PreH11 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH12 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH13 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH14 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH15 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH16 : (resched = 0)) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc )) (PreH18 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((map (event_link_node) (suffix)))) )
  **  (store_event (pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "link") original )
  **  (store_node_self_linked &((event_pre)  # "Event" ->ₛ "link") )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  EX (after: VarGlobalState) ,
  “ (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked))) ” 
  &&  “ (resched = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_event_delete_at_oc ) ” 
  &&  “ (Crtos_GTrans locked after ) ”
  &&  (InsideCritical sg_event_delete_at_oc locked )
  **  (os_inv sg_event_delete_at_oc after )
  **  (EventRetired event_pre (event_options (original)) (event_events (original)) )
) \/
(
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = false)) (PreH2 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH3 : ((event_addr (original)) = event_pre)) (PreH4 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH5 : ((event_addr (original)) = event_pre)) (PreH6 : ((event_id (original)) = id_event_delete_at_oc)) (PreH7 : ((event_pending_addrs (original)) = (@nil Z))) (PreH8 : (event_pre <> 0)) (PreH9 : (0 <= id_event_delete_at_oc)) (PreH10 : (id_event_delete_at_oc < 65536)) (PreH11 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH12 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH13 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH14 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH15 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH16 : (resched = 0)) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc )) (PreH18 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((map (event_link_node) (suffix)))) )
  **  (store_event (pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "link") original )
  **  (store_node_self_linked &((event_pre)  # "Event" ->ₛ "link") )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  “ (Crtos_GTrans locked (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)) ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen ((replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) ( MonadErr.ret  (tt)) X_event_delete_at_oc ) ”
  &&  (InsideCritical sg_event_delete_at_oc locked )
  **  (os_inv sg_event_delete_at_oc (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)) )
  **  (EventRetired event_pre (event_options (original)) (event_events (original)) )
).

Definition _EventDelete_entail_wit_4_3_split_goal_1 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = false)) (PreH2 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH3 : ((event_addr (original)) = event_pre)) (PreH4 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH5 : ((event_addr (original)) = event_pre)) (PreH6 : ((event_id (original)) = id_event_delete_at_oc)) (PreH7 : ((event_pending_addrs (original)) = (@nil Z))) (PreH8 : (event_pre <> 0)) (PreH9 : (0 <= id_event_delete_at_oc)) (PreH10 : (id_event_delete_at_oc < 65536)) (PreH11 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH12 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH13 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH14 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH15 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH16 : (resched = 0)) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc )) (PreH18 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((map (event_link_node) (suffix)))) )
  **  (store_event (pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "link") original )
  **  (store_node_self_linked &((event_pre)  # "Event" ->ₛ "link") )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  “ (Crtos_GTrans locked (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)) ) ”
.

Definition _EventDelete_entail_wit_4_3_split_goal_2 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = false)) (PreH2 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH3 : ((event_addr (original)) = event_pre)) (PreH4 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH5 : ((event_addr (original)) = event_pre)) (PreH6 : ((event_id (original)) = id_event_delete_at_oc)) (PreH7 : ((event_pending_addrs (original)) = (@nil Z))) (PreH8 : (event_pre <> 0)) (PreH9 : (0 <= id_event_delete_at_oc)) (PreH10 : (id_event_delete_at_oc < 65536)) (PreH11 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH12 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH13 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH14 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH15 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH16 : (resched = 0)) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc )) (PreH18 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((map (event_link_node) (suffix)))) )
  **  (store_event (pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "link") original )
  **  (store_node_self_linked &((event_pre)  # "Event" ->ₛ "link") )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen ((replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) ( MonadErr.ret  (tt)) X_event_delete_at_oc ) ”
.

Definition _EventDelete_entail_wit_4_3_split_goal_spatial := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = false)) (PreH2 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH3 : ((event_addr (original)) = event_pre)) (PreH4 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH5 : ((event_addr (original)) = event_pre)) (PreH6 : ((event_id (original)) = id_event_delete_at_oc)) (PreH7 : ((event_pending_addrs (original)) = (@nil Z))) (PreH8 : (event_pre <> 0)) (PreH9 : (0 <= id_event_delete_at_oc)) (PreH10 : (id_event_delete_at_oc < 65536)) (PreH11 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH12 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH13 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH14 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH15 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH16 : (resched = 0)) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc )) (PreH18 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((map (event_link_node) (suffix)))) )
  **  (store_event (pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "link") original )
  **  (store_node_self_linked &((event_pre)  # "Event" ->ₛ "link") )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  (InsideCritical sg_event_delete_at_oc locked )
  **  (os_inv sg_event_delete_at_oc (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)) )
  **  (EventRetired event_pre (event_options (original)) (event_events (original)) )
.

Definition _EventDelete_entail_wit_4_4 := 
(
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (idnode: Z) (PreH1 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH2 : (idmanager_contains (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) id_event_delete_at_oc idnode )) (PreH3 : (idnode <> 0)) (PreH4 : (&((idnode)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH6 : ((event_addr (original)) = event_pre)) (PreH7 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH8 : ((event_addr (original)) = event_pre)) (PreH9 : ((event_id (original)) = id_event_delete_at_oc)) (PreH10 : ((event_pending_addrs (original)) = (@nil Z))) (PreH11 : (event_pre <> 0)) (PreH12 : (0 <= id_event_delete_at_oc)) (PreH13 : (id_event_delete_at_oc < 65536)) (PreH14 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH15 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH16 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH17 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH18 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH19 : (resched = 0)) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc )) (PreH21 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((map (event_link_node) (suffix)))) )
  **  (store_event (pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "link") original )
  **  (store_node_self_linked &((event_pre)  # "Event" ->ₛ "link") )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) ( &( "k_event_id_manager" ) ) )
  **  ((&((idnode)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  EX (after: VarGlobalState) ,
  “ (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked))) ” 
  &&  “ (resched = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_event_delete_at_oc ) ” 
  &&  “ (Crtos_GTrans locked after ) ”
  &&  (InsideCritical sg_event_delete_at_oc locked )
  **  (os_inv sg_event_delete_at_oc after )
  **  (EventRetired event_pre (event_options (original)) (event_events (original)) )
) \/
(
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (idnode: Z) (PreH1 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH2 : (idmanager_contains (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) id_event_delete_at_oc idnode )) (PreH3 : (idnode <> 0)) (PreH4 : (&((idnode)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH6 : ((event_addr (original)) = event_pre)) (PreH7 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH8 : ((event_addr (original)) = event_pre)) (PreH9 : ((event_id (original)) = id_event_delete_at_oc)) (PreH10 : ((event_pending_addrs (original)) = (@nil Z))) (PreH11 : (event_pre <> 0)) (PreH12 : (0 <= id_event_delete_at_oc)) (PreH13 : (id_event_delete_at_oc < 65536)) (PreH14 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH15 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH16 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH17 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH18 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH19 : (resched = 0)) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc )) (PreH21 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((map (event_link_node) (suffix)))) )
  **  (store_event (pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "link") original )
  **  (store_node_self_linked &((event_pre)  # "Event" ->ₛ "link") )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) ( &( "k_event_id_manager" ) ) )
  **  ((&((idnode)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  “ (Crtos_GTrans locked (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)) ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen ((replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) ( MonadErr.ret  (tt)) X_event_delete_at_oc ) ”
  &&  (InsideCritical sg_event_delete_at_oc locked )
  **  (os_inv sg_event_delete_at_oc (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)) )
  **  (EventRetired event_pre (event_options (original)) (event_events (original)) )
).

Definition _EventDelete_entail_wit_4_4_split_goal_1 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (idnode: Z) (PreH1 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH2 : (idmanager_contains (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) id_event_delete_at_oc idnode )) (PreH3 : (idnode <> 0)) (PreH4 : (&((idnode)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH6 : ((event_addr (original)) = event_pre)) (PreH7 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH8 : ((event_addr (original)) = event_pre)) (PreH9 : ((event_id (original)) = id_event_delete_at_oc)) (PreH10 : ((event_pending_addrs (original)) = (@nil Z))) (PreH11 : (event_pre <> 0)) (PreH12 : (0 <= id_event_delete_at_oc)) (PreH13 : (id_event_delete_at_oc < 65536)) (PreH14 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH15 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH16 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH17 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH18 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH19 : (resched = 0)) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc )) (PreH21 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((map (event_link_node) (suffix)))) )
  **  (store_event (pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "link") original )
  **  (store_node_self_linked &((event_pre)  # "Event" ->ₛ "link") )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) ( &( "k_event_id_manager" ) ) )
  **  ((&((idnode)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  “ (Crtos_GTrans locked (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)) ) ”
.

Definition _EventDelete_entail_wit_4_4_split_goal_2 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (idnode: Z) (PreH1 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH2 : (idmanager_contains (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) id_event_delete_at_oc idnode )) (PreH3 : (idnode <> 0)) (PreH4 : (&((idnode)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH6 : ((event_addr (original)) = event_pre)) (PreH7 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH8 : ((event_addr (original)) = event_pre)) (PreH9 : ((event_id (original)) = id_event_delete_at_oc)) (PreH10 : ((event_pending_addrs (original)) = (@nil Z))) (PreH11 : (event_pre <> 0)) (PreH12 : (0 <= id_event_delete_at_oc)) (PreH13 : (id_event_delete_at_oc < 65536)) (PreH14 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH15 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH16 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH17 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH18 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH19 : (resched = 0)) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc )) (PreH21 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((map (event_link_node) (suffix)))) )
  **  (store_event (pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "link") original )
  **  (store_node_self_linked &((event_pre)  # "Event" ->ₛ "link") )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) ( &( "k_event_id_manager" ) ) )
  **  ((&((idnode)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen ((replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) ( MonadErr.ret  (tt)) X_event_delete_at_oc ) ”
.

Definition _EventDelete_entail_wit_4_4_split_goal_spatial := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (idnode: Z) (PreH1 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH2 : (idmanager_contains (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) id_event_delete_at_oc idnode )) (PreH3 : (idnode <> 0)) (PreH4 : (&((idnode)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH6 : ((event_addr (original)) = event_pre)) (PreH7 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH8 : ((event_addr (original)) = event_pre)) (PreH9 : ((event_id (original)) = id_event_delete_at_oc)) (PreH10 : ((event_pending_addrs (original)) = (@nil Z))) (PreH11 : (event_pre <> 0)) (PreH12 : (0 <= id_event_delete_at_oc)) (PreH13 : (id_event_delete_at_oc < 65536)) (PreH14 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH15 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH16 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH17 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH18 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH19 : (resched = 0)) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc )) (PreH21 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((map (event_link_node) (suffix)))) )
  **  (store_event (pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "link") original )
  **  (store_node_self_linked &((event_pre)  # "Event" ->ₛ "link") )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) ( &( "k_event_id_manager" ) ) )
  **  ((&((idnode)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  (InsideCritical sg_event_delete_at_oc locked )
  **  (os_inv sg_event_delete_at_oc (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)) )
  **  (EventRetired event_pre (event_options (original)) (event_events (original)) )
.

Definition _EventDelete_entail_wit_5_1 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_event_delete_at_oc: StableGlobalState) (locked: VarGlobalState) (resched: Z) (after: VarGlobalState) (PreH1 : (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) (PreH2 : (resched = 1)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_event_delete_at_oc )) (PreH4 : (Crtos_GTrans locked after )) (PreH5 : (resched = 0)) ,
  (OutsideCritical sg_event_delete_at_oc after )
|--
  “ (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked))) ” 
  &&  “ (resched = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_event_delete_at_oc ) ” 
  &&  “ (Crtos_GTrans locked after ) ” 
  &&  “ (resched = 0) ”
  &&  (OutsideCritical sg_event_delete_at_oc after )
.

Definition _EventDelete_entail_wit_5_2 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_event_delete_at_oc: StableGlobalState) (locked: VarGlobalState) (resched: Z) (after: VarGlobalState) (PreH1 : (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) (PreH2 : (resched = 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_event_delete_at_oc )) (PreH4 : (Crtos_GTrans locked after )) (PreH5 : (resched = 0)) ,
  (OutsideCritical sg_event_delete_at_oc after )
|--
  “ (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked))) ” 
  &&  “ (resched = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_event_delete_at_oc ) ” 
  &&  “ (Crtos_GTrans locked after ) ” 
  &&  “ (resched = 0) ”
  &&  (OutsideCritical sg_event_delete_at_oc after )
.

Definition _EventDelete_entail_wit_6_1 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_event_delete_at_oc: StableGlobalState) (locked: VarGlobalState) (resched: Z) (after: VarGlobalState) (PreH1 : (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) (PreH2 : (resched = 1)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_event_delete_at_oc )) (PreH4 : (Crtos_GTrans locked after )) (PreH5 : (resched <> 0)) ,
  (OutsideCritical sg_event_delete_at_oc after )
|--
  “ (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked))) ” 
  &&  “ (resched = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_event_delete_at_oc ) ” 
  &&  “ (Crtos_GTrans locked after ) ” 
  &&  “ (resched <> 0) ”
  &&  (OutsideCritical sg_event_delete_at_oc after )
.

Definition _EventDelete_entail_wit_6_2 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_event_delete_at_oc: StableGlobalState) (locked: VarGlobalState) (resched: Z) (after: VarGlobalState) (PreH1 : (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) (PreH2 : (resched = 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_event_delete_at_oc )) (PreH4 : (Crtos_GTrans locked after )) (PreH5 : (resched <> 0)) ,
  (OutsideCritical sg_event_delete_at_oc after )
|--
  “ (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked))) ” 
  &&  “ (resched = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_event_delete_at_oc ) ” 
  &&  “ (Crtos_GTrans locked after ) ” 
  &&  “ (resched <> 0) ”
  &&  (OutsideCritical sg_event_delete_at_oc after )
.

Definition _EventDelete_return_wit_1 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_event_delete_at_oc: StableGlobalState) (locked: VarGlobalState) (resched: Z) (after_2: VarGlobalState) (after_3: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (after_3)) ( MonadErr.ret  (tt)) X_event_delete_at_oc )) (PreH2 : (after_2 = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) (PreH3 : (resched = 1)) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (after_2)) abs_ktask_assign X_event_delete_at_oc )) (PreH5 : (Crtos_GTrans locked after_2 )) (PreH6 : (resched <> 0)) ,
  (OutsideCritical sg_event_delete_at_oc after_3 )
|--
  EX (after: VarGlobalState) ,
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_event_delete_at_oc ) ”
  &&  (OutsideCritical sg_event_delete_at_oc after )
.

Definition _EventDelete_return_wit_2 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_event_delete_at_oc: StableGlobalState) (locked: VarGlobalState) (resched: Z) (after_2: VarGlobalState) (PreH1 : (after_2 = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) (PreH2 : (resched = 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (after_2)) ( MonadErr.ret  (tt)) X_event_delete_at_oc )) (PreH4 : (Crtos_GTrans locked after_2 )) (PreH5 : (resched = 0)) ,
  (OutsideCritical sg_event_delete_at_oc after_2 )
|--
  EX (after: VarGlobalState) ,
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_event_delete_at_oc ) ”
  &&  (OutsideCritical sg_event_delete_at_oc after )
.

Definition _EventDelete_partial_solve_wit_1_pure := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (PreH1 : (event_pre <> 0)) (PreH2 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  ((( &( "pending_empty" ) )) # Int  |->_)
  **  ((( &( "inspect_lock" ) )) # Int  |-> 0)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
  **  (OutsideCritical sg_event_delete_at_oc before_event_delete_at_oc )
|--
  “ (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc ) ”
.

Definition _EventDelete_partial_solve_wit_1_aux := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (PreH1 : (event_pre <> 0)) (PreH2 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (OutsideCritical sg_event_delete_at_oc before_event_delete_at_oc )
|--
  “ (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc ) ” 
  &&  “ (event_pre <> 0) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc ) ”
  &&  (OutsideCritical sg_event_delete_at_oc before_event_delete_at_oc )
.

Definition _EventDelete_partial_solve_wit_1 := _EventDelete_partial_solve_wit_1_pure -> _EventDelete_partial_solve_wit_1_aux.

Definition _EventDelete_partial_solve_wit_2_pure := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (retval: Z) (checked: VarGlobalState) (PreH1 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH2 : (event_pre <> 0)) (PreH3 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (InsideCritical sg_event_delete_at_oc checked )
  **  (os_inv sg_event_delete_at_oc checked )
  **  ((( &( "pending_empty" ) )) # Int  |->_)
  **  ((( &( "inspect_lock" ) )) # Int  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
|--
  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ”
.

Definition _EventDelete_partial_solve_wit_2_aux := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (checked: VarGlobalState) (PreH1 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH2 : (event_pre <> 0)) (PreH3 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (InsideCritical sg_event_delete_at_oc checked )
  **  (os_inv sg_event_delete_at_oc checked )
|--
  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ (event_pre <> 0) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc ) ”
  &&  (os_inv sg_event_delete_at_oc checked )
  **  (InsideCritical sg_event_delete_at_oc checked )
.

Definition _EventDelete_partial_solve_wit_2 := _EventDelete_partial_solve_wit_2_pure -> _EventDelete_partial_solve_wit_2_aux.

Definition _EventDelete_partial_solve_wit_3 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (checked: VarGlobalState) (waiting: (@list Z)) (PreH1 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH2 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH3 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH4 : ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list"))) (PreH5 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH6 : (event_pre <> 0)) (PreH7 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH8 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (store_dll (pure_suspend_sched_link (((checked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "pend_list") (map (event_wait_node) (waiting)) )
  **  (event_delete_pending_restore sg_event_delete_at_oc checked event_pre waiting )
  **  (InsideCritical sg_event_delete_at_oc checked )
|--
  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false checked ) ” 
  &&  “ ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list")) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ (event_pre <> 0) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc ) ”
  &&  (store_dll (pure_suspend_sched_link (((checked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "pend_list") (map (event_wait_node) (waiting)) )
  **  (event_delete_pending_restore sg_event_delete_at_oc checked event_pre waiting )
  **  (InsideCritical sg_event_delete_at_oc checked )
.

Definition _EventDelete_partial_solve_wit_4_pure := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (retval: Z) (checked: VarGlobalState) (waiting: (@list Z)) (retval_2: Z) (PreH1 : (retval_2 = 1)) (PreH2 : ((map (event_wait_node) (waiting)) = (@nil (@DL_Node Z)))) (PreH3 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH4 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH5 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH6 : ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list"))) (PreH7 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH8 : (event_pre <> 0)) (PreH9 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (store_dll (pure_suspend_sched_link (((checked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "pend_list") (map (event_wait_node) (waiting)) )
  **  (event_delete_pending_restore sg_event_delete_at_oc checked event_pre waiting )
  **  (InsideCritical sg_event_delete_at_oc checked )
  **  ((( &( "pending_empty" ) )) # Int  |-> retval_2)
  **  ((( &( "inspect_lock" ) )) # Int  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
|--
  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ”
.

Definition _EventDelete_partial_solve_wit_4_aux := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (checked: VarGlobalState) (waiting: (@list Z)) (retval_2: Z) (PreH1 : (retval_2 = 1)) (PreH2 : ((map (event_wait_node) (waiting)) = (@nil (@DL_Node Z)))) (PreH3 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH4 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH5 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH6 : ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list"))) (PreH7 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH8 : (event_pre <> 0)) (PreH9 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (store_dll (pure_suspend_sched_link (((checked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "pend_list") (map (event_wait_node) (waiting)) )
  **  (event_delete_pending_restore sg_event_delete_at_oc checked event_pre waiting )
  **  (InsideCritical sg_event_delete_at_oc checked )
|--
  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ” 
  &&  “ (retval_2 = 1) ” 
  &&  “ ((map (event_wait_node) (waiting)) = (@nil (@DL_Node Z))) ” 
  &&  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false checked ) ” 
  &&  “ ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list")) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ (event_pre <> 0) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc ) ”
  &&  (store_dll (pure_suspend_sched_link (((checked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "pend_list") (map (event_wait_node) (waiting)) )
  **  (event_delete_pending_restore sg_event_delete_at_oc checked event_pre waiting )
  **  (InsideCritical sg_event_delete_at_oc checked )
.

Definition _EventDelete_partial_solve_wit_4 := _EventDelete_partial_solve_wit_4_pure -> _EventDelete_partial_solve_wit_4_aux.

Definition _EventDelete_partial_solve_wit_5_pure := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (retval: Z) (checked: VarGlobalState) (waiting: (@list Z)) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : ((map (event_wait_node) (waiting)) <> (@nil (@DL_Node Z)))) (PreH3 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH4 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH5 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH6 : ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list"))) (PreH7 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH8 : (event_pre <> 0)) (PreH9 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (store_dll (pure_suspend_sched_link (((checked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "pend_list") (map (event_wait_node) (waiting)) )
  **  (event_delete_pending_restore sg_event_delete_at_oc checked event_pre waiting )
  **  (InsideCritical sg_event_delete_at_oc checked )
  **  ((( &( "pending_empty" ) )) # Int  |-> retval_2)
  **  ((( &( "inspect_lock" ) )) # Int  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
|--
  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ”
.

Definition _EventDelete_partial_solve_wit_5_aux := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (checked: VarGlobalState) (waiting: (@list Z)) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : ((map (event_wait_node) (waiting)) <> (@nil (@DL_Node Z)))) (PreH3 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH4 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH5 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH6 : ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list"))) (PreH7 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH8 : (event_pre <> 0)) (PreH9 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH10 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (store_dll (pure_suspend_sched_link (((checked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "pend_list") (map (event_wait_node) (waiting)) )
  **  (event_delete_pending_restore sg_event_delete_at_oc checked event_pre waiting )
  **  (InsideCritical sg_event_delete_at_oc checked )
|--
  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ” 
  &&  “ (retval_2 = 0) ” 
  &&  “ ((map (event_wait_node) (waiting)) <> (@nil (@DL_Node Z))) ” 
  &&  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false checked ) ” 
  &&  “ ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list")) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ (event_pre <> 0) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc ) ”
  &&  (store_dll (pure_suspend_sched_link (((checked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "pend_list") (map (event_wait_node) (waiting)) )
  **  (event_delete_pending_restore sg_event_delete_at_oc checked event_pre waiting )
  **  (InsideCritical sg_event_delete_at_oc checked )
.

Definition _EventDelete_partial_solve_wit_5 := _EventDelete_partial_solve_wit_5_pure -> _EventDelete_partial_solve_wit_5_aux.

Definition _EventDelete_partial_solve_wit_6_pure := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (retval: Z) (checked: VarGlobalState) (waiting: (@list Z)) (retval_2: Z) (PreH1 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH2 : (Crtos_GTrans checked checked )) (PreH3 : (retval_2 = 0)) (PreH4 : ((map (event_wait_node) (waiting)) <> (@nil (@DL_Node Z)))) (PreH5 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH6 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH7 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH8 : ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list"))) (PreH9 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH10 : (event_pre <> 0)) (PreH11 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH12 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (os_inv sg_event_delete_at_oc checked )
  **  (InsideCritical sg_event_delete_at_oc checked )
  **  ((( &( "pending_empty" ) )) # Int  |-> retval_2)
  **  ((( &( "inspect_lock" ) )) # Int  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
|--
  “ (Crtos_GTrans checked checked ) ”
.

Definition _EventDelete_partial_solve_wit_6_aux := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (checked: VarGlobalState) (waiting: (@list Z)) (retval_2: Z) (PreH1 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH2 : (Crtos_GTrans checked checked )) (PreH3 : (retval_2 = 0)) (PreH4 : ((map (event_wait_node) (waiting)) <> (@nil (@DL_Node Z)))) (PreH5 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH6 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH7 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH8 : ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list"))) (PreH9 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH10 : (event_pre <> 0)) (PreH11 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH12 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (os_inv sg_event_delete_at_oc checked )
  **  (InsideCritical sg_event_delete_at_oc checked )
|--
  “ (Crtos_GTrans checked checked ) ” 
  &&  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ” 
  &&  “ (Crtos_GTrans checked checked ) ” 
  &&  “ (retval_2 = 0) ” 
  &&  “ ((map (event_wait_node) (waiting)) <> (@nil (@DL_Node Z))) ” 
  &&  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false checked ) ” 
  &&  “ ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list")) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ (event_pre <> 0) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc ) ”
  &&  (InsideCritical sg_event_delete_at_oc checked )
  **  (os_inv sg_event_delete_at_oc checked )
.

Definition _EventDelete_partial_solve_wit_6 := _EventDelete_partial_solve_wit_6_pure -> _EventDelete_partial_solve_wit_6_aux.

Definition _EventDelete_partial_solve_wit_7_pure := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (retval: Z) (checked: VarGlobalState) (waiting: (@list Z)) (retval_2: Z) (PreH1 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH2 : (Crtos_GTrans checked checked )) (PreH3 : (retval_2 = 1)) (PreH4 : ((map (event_wait_node) (waiting)) = (@nil (@DL_Node Z)))) (PreH5 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH6 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH7 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH8 : ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list"))) (PreH9 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH10 : (event_pre <> 0)) (PreH11 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH12 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (os_inv sg_event_delete_at_oc checked )
  **  (InsideCritical sg_event_delete_at_oc checked )
  **  ((( &( "pending_empty" ) )) # Int  |-> retval_2)
  **  ((( &( "inspect_lock" ) )) # Int  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
|--
  “ (Crtos_GTrans checked checked ) ”
.

Definition _EventDelete_partial_solve_wit_7_aux := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (checked: VarGlobalState) (waiting: (@list Z)) (retval_2: Z) (PreH1 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH2 : (Crtos_GTrans checked checked )) (PreH3 : (retval_2 = 1)) (PreH4 : ((map (event_wait_node) (waiting)) = (@nil (@DL_Node Z)))) (PreH5 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH6 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH7 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH8 : ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list"))) (PreH9 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH10 : (event_pre <> 0)) (PreH11 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH12 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (os_inv sg_event_delete_at_oc checked )
  **  (InsideCritical sg_event_delete_at_oc checked )
|--
  “ (Crtos_GTrans checked checked ) ” 
  &&  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ” 
  &&  “ (Crtos_GTrans checked checked ) ” 
  &&  “ (retval_2 = 1) ” 
  &&  “ ((map (event_wait_node) (waiting)) = (@nil (@DL_Node Z))) ” 
  &&  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false checked ) ” 
  &&  “ ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list")) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ (event_pre <> 0) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc ) ”
  &&  (InsideCritical sg_event_delete_at_oc checked )
  **  (os_inv sg_event_delete_at_oc checked )
.

Definition _EventDelete_partial_solve_wit_7 := _EventDelete_partial_solve_wit_7_pure -> _EventDelete_partial_solve_wit_7_aux.

Definition _EventDelete_partial_solve_wit_8_pure := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (retval: Z) (checked: VarGlobalState) (waiting: (@list Z)) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH3 : (Crtos_GTrans checked checked )) (PreH4 : (retval_2 = 0)) (PreH5 : ((map (event_wait_node) (waiting)) <> (@nil (@DL_Node Z)))) (PreH6 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH7 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH8 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH9 : ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list"))) (PreH10 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH11 : (event_pre <> 0)) (PreH12 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (OutsideCritical sg_event_delete_at_oc checked )
  **  ((( &( "pending_empty" ) )) # Int  |-> retval_2)
  **  ((( &( "inspect_lock" ) )) # Int  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
|--
  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ ((map (event_wait_node) (waiting)) <> (@nil (@DL_Node Z))) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc ) ”
.

Definition _EventDelete_partial_solve_wit_8_aux := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (checked: VarGlobalState) (waiting: (@list Z)) (retval_2: Z) (PreH1 : (retval_2 = 0)) (PreH2 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH3 : (Crtos_GTrans checked checked )) (PreH4 : (retval_2 = 0)) (PreH5 : ((map (event_wait_node) (waiting)) <> (@nil (@DL_Node Z)))) (PreH6 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH7 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH8 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH9 : ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list"))) (PreH10 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH11 : (event_pre <> 0)) (PreH12 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (OutsideCritical sg_event_delete_at_oc checked )
|--
  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ ((map (event_wait_node) (waiting)) <> (@nil (@DL_Node Z))) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc ) ” 
  &&  “ (retval_2 = 0) ” 
  &&  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ” 
  &&  “ (Crtos_GTrans checked checked ) ” 
  &&  “ (retval_2 = 0) ” 
  &&  “ ((map (event_wait_node) (waiting)) <> (@nil (@DL_Node Z))) ” 
  &&  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false checked ) ” 
  &&  “ ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list")) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ (event_pre <> 0) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc ) ”
  &&  (OutsideCritical sg_event_delete_at_oc checked )
.

Definition _EventDelete_partial_solve_wit_8 := _EventDelete_partial_solve_wit_8_pure -> _EventDelete_partial_solve_wit_8_aux.

Definition _EventDelete_partial_solve_wit_9_pure := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (retval: Z) (checked: VarGlobalState) (waiting: (@list Z)) (retval_2: Z) (PreH1 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (checked)) (abs_event_resume_all (id_event_delete_at_oc) (event_pre)) (event_delete_resume_cont (id_event_delete_at_oc) (event_pre) (X_event_delete_at_oc)) )) (PreH3 : (retval_2 = 0)) (PreH4 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH5 : (Crtos_GTrans checked checked )) (PreH6 : (retval_2 = 0)) (PreH7 : ((map (event_wait_node) (waiting)) <> (@nil (@DL_Node Z)))) (PreH8 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH9 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH10 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH11 : ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list"))) (PreH12 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH13 : (event_pre <> 0)) (PreH14 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (OutsideCritical sg_event_delete_at_oc checked )
  **  ((( &( "pending_empty" ) )) # Int  |-> retval_2)
  **  ((( &( "inspect_lock" ) )) # Int  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 1)
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
|--
  “ (&((event_pre)  # "Event" ->ₛ "pend_list") = (event_pending_head (event_pre))) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false checked ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (checked)) (abs_event_resume_all (id_event_delete_at_oc) (event_pre)) (event_delete_resume_cont (id_event_delete_at_oc) (event_pre) (X_event_delete_at_oc)) ) ”
.

Definition _EventDelete_partial_solve_wit_9_aux := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (checked: VarGlobalState) (waiting: (@list Z)) (retval_2: Z) (PreH1 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (checked)) (abs_event_resume_all (id_event_delete_at_oc) (event_pre)) (event_delete_resume_cont (id_event_delete_at_oc) (event_pre) (X_event_delete_at_oc)) )) (PreH3 : (retval_2 = 0)) (PreH4 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH5 : (Crtos_GTrans checked checked )) (PreH6 : (retval_2 = 0)) (PreH7 : ((map (event_wait_node) (waiting)) <> (@nil (@DL_Node Z)))) (PreH8 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH9 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH10 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH11 : ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list"))) (PreH12 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH13 : (event_pre <> 0)) (PreH14 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (OutsideCritical sg_event_delete_at_oc checked )
|--
  “ (&((event_pre)  # "Event" ->ₛ "pend_list") = (event_pending_head (event_pre))) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false checked ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (checked)) (abs_event_resume_all (id_event_delete_at_oc) (event_pre)) (event_delete_resume_cont (id_event_delete_at_oc) (event_pre) (X_event_delete_at_oc)) ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false checked ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (checked)) (abs_event_resume_all (id_event_delete_at_oc) (event_pre)) (event_delete_resume_cont (id_event_delete_at_oc) (event_pre) (X_event_delete_at_oc)) ) ” 
  &&  “ (retval_2 = 0) ” 
  &&  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ” 
  &&  “ (Crtos_GTrans checked checked ) ” 
  &&  “ (retval_2 = 0) ” 
  &&  “ ((map (event_wait_node) (waiting)) <> (@nil (@DL_Node Z))) ” 
  &&  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false checked ) ” 
  &&  “ ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list")) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ (event_pre <> 0) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc ) ”
  &&  (OutsideCritical sg_event_delete_at_oc checked )
.

Definition _EventDelete_partial_solve_wit_9 := _EventDelete_partial_solve_wit_9_pure -> _EventDelete_partial_solve_wit_9_aux.

Definition _EventDelete_partial_solve_wit_10_pure := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (retval: Z) (checked: VarGlobalState) (waiting: (@list Z)) (retval_2: Z) (retval_3: Z) (drained: VarGlobalState) (PreH1 : (retval_3 = 0)) (PreH2 : (event_delete_guard id_event_delete_at_oc event_pre true drained )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (event_delete_resume_cont (id_event_delete_at_oc) (event_pre) (X_event_delete_at_oc)) )) (PreH4 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (checked)) (abs_event_resume_all (id_event_delete_at_oc) (event_pre)) (event_delete_resume_cont (id_event_delete_at_oc) (event_pre) (X_event_delete_at_oc)) )) (PreH6 : (retval_2 = 0)) (PreH7 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH8 : (Crtos_GTrans checked checked )) (PreH9 : (retval_2 = 0)) (PreH10 : ((map (event_wait_node) (waiting)) <> (@nil (@DL_Node Z)))) (PreH11 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH12 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH13 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH14 : ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list"))) (PreH15 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH16 : (event_pre <> 0)) (PreH17 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (OutsideCritical sg_event_delete_at_oc drained )
  **  ((( &( "pending_empty" ) )) # Int  |-> retval_2)
  **  ((( &( "inspect_lock" ) )) # Int  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 1)
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (event_delete_resume_cont (id_event_delete_at_oc) (event_pre) (X_event_delete_at_oc)) ) ”
.

Definition _EventDelete_partial_solve_wit_10_aux := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (checked: VarGlobalState) (waiting: (@list Z)) (retval_2: Z) (retval_3: Z) (drained: VarGlobalState) (PreH1 : (retval_3 = 0)) (PreH2 : (event_delete_guard id_event_delete_at_oc event_pre true drained )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (event_delete_resume_cont (id_event_delete_at_oc) (event_pre) (X_event_delete_at_oc)) )) (PreH4 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (checked)) (abs_event_resume_all (id_event_delete_at_oc) (event_pre)) (event_delete_resume_cont (id_event_delete_at_oc) (event_pre) (X_event_delete_at_oc)) )) (PreH6 : (retval_2 = 0)) (PreH7 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH8 : (Crtos_GTrans checked checked )) (PreH9 : (retval_2 = 0)) (PreH10 : ((map (event_wait_node) (waiting)) <> (@nil (@DL_Node Z)))) (PreH11 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH12 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH13 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH14 : ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list"))) (PreH15 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH16 : (event_pre <> 0)) (PreH17 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH18 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (OutsideCritical sg_event_delete_at_oc drained )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (event_delete_resume_cont (id_event_delete_at_oc) (event_pre) (X_event_delete_at_oc)) ) ” 
  &&  “ (retval_3 = 0) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre true drained ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (event_delete_resume_cont (id_event_delete_at_oc) (event_pre) (X_event_delete_at_oc)) ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false checked ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (checked)) (abs_event_resume_all (id_event_delete_at_oc) (event_pre)) (event_delete_resume_cont (id_event_delete_at_oc) (event_pre) (X_event_delete_at_oc)) ) ” 
  &&  “ (retval_2 = 0) ” 
  &&  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ” 
  &&  “ (Crtos_GTrans checked checked ) ” 
  &&  “ (retval_2 = 0) ” 
  &&  “ ((map (event_wait_node) (waiting)) <> (@nil (@DL_Node Z))) ” 
  &&  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false checked ) ” 
  &&  “ ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list")) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ (event_pre <> 0) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc ) ”
  &&  (OutsideCritical sg_event_delete_at_oc drained )
.

Definition _EventDelete_partial_solve_wit_10 := _EventDelete_partial_solve_wit_10_pure -> _EventDelete_partial_solve_wit_10_aux.

Definition _EventDelete_partial_solve_wit_11_pure := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (retval: Z) (checked: VarGlobalState) (waiting: (@list Z)) (retval_2: Z) (PreH1 : (retval_2 <> 0)) (PreH2 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH3 : (Crtos_GTrans checked checked )) (PreH4 : (retval_2 = 1)) (PreH5 : ((map (event_wait_node) (waiting)) = (@nil (@DL_Node Z)))) (PreH6 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH7 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH8 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH9 : ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list"))) (PreH10 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH11 : (event_pre <> 0)) (PreH12 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (OutsideCritical sg_event_delete_at_oc checked )
  **  ((( &( "pending_empty" ) )) # Int  |-> retval_2)
  **  ((( &( "inspect_lock" ) )) # Int  |-> retval)
  **  ((( &( "lock" ) )) # Int  |-> 0)
  **  ((( &( "resched" ) )) # Int  |-> 0)
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
|--
  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ ((map (event_wait_node) (waiting)) = (@nil (@DL_Node Z))) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc ) ”
.

Definition _EventDelete_partial_solve_wit_11_aux := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (checked: VarGlobalState) (waiting: (@list Z)) (retval_2: Z) (PreH1 : (retval_2 <> 0)) (PreH2 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH3 : (Crtos_GTrans checked checked )) (PreH4 : (retval_2 = 1)) (PreH5 : ((map (event_wait_node) (waiting)) = (@nil (@DL_Node Z)))) (PreH6 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH7 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH8 : (event_delete_guard id_event_delete_at_oc event_pre false checked )) (PreH9 : ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list"))) (PreH10 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH11 : (event_pre <> 0)) (PreH12 : (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc )) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (OutsideCritical sg_event_delete_at_oc checked )
|--
  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ ((map (event_wait_node) (waiting)) = (@nil (@DL_Node Z))) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc ) ” 
  &&  “ (retval_2 <> 0) ” 
  &&  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ” 
  &&  “ (Crtos_GTrans checked checked ) ” 
  &&  “ (retval_2 = 1) ” 
  &&  “ ((map (event_wait_node) (waiting)) = (@nil (@DL_Node Z))) ” 
  &&  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false checked ) ” 
  &&  “ ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list")) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ (event_pre <> 0) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false before_event_delete_at_oc ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc ) ”
  &&  (OutsideCritical sg_event_delete_at_oc checked )
.

Definition _EventDelete_partial_solve_wit_11 := _EventDelete_partial_solve_wit_11_pure -> _EventDelete_partial_solve_wit_11_aux.

Definition _EventDelete_partial_solve_wit_12_pure := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (PreH1 : (resched = 1)) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc )) (PreH3 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  ((( &( "event" ) )) # Ptr  |-> event_pre)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "lock" ) )) # Int  |->_)
  **  ((( &( "inspect_lock" ) )) # Int  |->_)
  **  ((( &( "pending_empty" ) )) # Int  |->_)
  **  (OutsideCritical sg_event_delete_at_oc ready )
|--
  “ (event_delete_guard id_event_delete_at_oc event_pre true ready ) ”
.

Definition _EventDelete_partial_solve_wit_12_aux := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (PreH1 : (resched = 1)) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc )) (PreH3 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (OutsideCritical sg_event_delete_at_oc ready )
|--
  “ (event_delete_guard id_event_delete_at_oc event_pre true ready ) ” 
  &&  “ (resched = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre true ready ) ”
  &&  (OutsideCritical sg_event_delete_at_oc ready )
.

Definition _EventDelete_partial_solve_wit_12 := _EventDelete_partial_solve_wit_12_pure -> _EventDelete_partial_solve_wit_12_aux.

Definition _EventDelete_partial_solve_wit_13_pure := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (PreH1 : (resched = 0)) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc )) (PreH3 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  ((( &( "event" ) )) # Ptr  |-> event_pre)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "lock" ) )) # Int  |->_)
  **  ((( &( "inspect_lock" ) )) # Int  |->_)
  **  ((( &( "pending_empty" ) )) # Int  |->_)
  **  (OutsideCritical sg_event_delete_at_oc ready )
|--
  “ (event_delete_guard id_event_delete_at_oc event_pre true ready ) ”
.

Definition _EventDelete_partial_solve_wit_13_aux := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (PreH1 : (resched = 0)) (PreH2 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc )) (PreH3 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (OutsideCritical sg_event_delete_at_oc ready )
|--
  “ (event_delete_guard id_event_delete_at_oc event_pre true ready ) ” 
  &&  “ (resched = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre true ready ) ”
  &&  (OutsideCritical sg_event_delete_at_oc ready )
.

Definition _EventDelete_partial_solve_wit_13 := _EventDelete_partial_solve_wit_13_pure -> _EventDelete_partial_solve_wit_13_aux.

Definition _EventDelete_partial_solve_wit_14_pure := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (retval: Z) (locked: VarGlobalState) (PreH1 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH2 : (resched = 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc )) (PreH4 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (InsideCritical sg_event_delete_at_oc locked )
  **  (os_inv sg_event_delete_at_oc locked )
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "inspect_lock" ) )) # Int  |->_)
  **  ((( &( "pending_empty" ) )) # Int  |->_)
|--
  “ (event_delete_gap id_event_delete_at_oc event_pre true ready locked ) ”
.

Definition _EventDelete_partial_solve_wit_14_aux := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (PreH1 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH2 : (resched = 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc )) (PreH4 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (InsideCritical sg_event_delete_at_oc locked )
  **  (os_inv sg_event_delete_at_oc locked )
|--
  “ (event_delete_gap id_event_delete_at_oc event_pre true ready locked ) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre true ready locked ) ” 
  &&  “ (resched = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre true ready ) ”
  &&  (os_inv sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
.

Definition _EventDelete_partial_solve_wit_14 := _EventDelete_partial_solve_wit_14_pure -> _EventDelete_partial_solve_wit_14_aux.

Definition _EventDelete_partial_solve_wit_15_pure := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (retval: Z) (locked: VarGlobalState) (PreH1 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH2 : (resched = 1)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc )) (PreH4 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (InsideCritical sg_event_delete_at_oc locked )
  **  (os_inv sg_event_delete_at_oc locked )
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "inspect_lock" ) )) # Int  |->_)
  **  ((( &( "pending_empty" ) )) # Int  |->_)
|--
  “ (event_delete_gap id_event_delete_at_oc event_pre true ready locked ) ”
.

Definition _EventDelete_partial_solve_wit_15_aux := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (PreH1 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH2 : (resched = 1)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc )) (PreH4 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (InsideCritical sg_event_delete_at_oc locked )
  **  (os_inv sg_event_delete_at_oc locked )
|--
  “ (event_delete_gap id_event_delete_at_oc event_pre true ready locked ) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre true ready locked ) ” 
  &&  “ (resched = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre true ready ) ”
  &&  (os_inv sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
.

Definition _EventDelete_partial_solve_wit_15 := _EventDelete_partial_solve_wit_15_pure -> _EventDelete_partial_solve_wit_15_aux.

Definition _EventDelete_partial_solve_wit_16 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH2 : ((event_addr (original)) = event_pre)) (PreH3 : ((event_id (original)) = id_event_delete_at_oc)) (PreH4 : ((event_pending_addrs (original)) = (@nil Z))) (PreH5 : (event_pre <> 0)) (PreH6 : (0 <= id_event_delete_at_oc)) (PreH7 : (id_event_delete_at_oc < 65536)) (PreH8 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH9 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH10 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH11 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH12 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH13 : (resched = 0)) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc )) (PreH15 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  ((&((event_pre)  # "Event" ->ₛ "id" .ₛ "id")) # UShort  |-> id_event_delete_at_oc)
  **  (event_delete_id_restore sg_event_delete_at_oc locked event_pre id_event_delete_at_oc )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  “ ((os_events (locked)) = (app (prefix) ((cons (original) (suffix))))) ” 
  &&  “ ((event_addr (original)) = event_pre) ” 
  &&  “ ((event_id (original)) = id_event_delete_at_oc) ” 
  &&  “ ((event_pending_addrs (original)) = (@nil Z)) ” 
  &&  “ (event_pre <> 0) ” 
  &&  “ (0 <= id_event_delete_at_oc) ” 
  &&  “ (id_event_delete_at_oc < 65536) ” 
  &&  “ (NoDup (map (event_addr) ((os_events (locked)))) ) ” 
  &&  “ (NoDup (map (event_id) ((os_events (locked)))) ) ” 
  &&  “ ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked))))))) ” 
  &&  “ ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre true ready locked ) ” 
  &&  “ (resched = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre true ready ) ”
  &&  ((&((event_pre)  # "Event" ->ₛ "id" .ₛ "id")) # UShort  |-> id_event_delete_at_oc)
  **  (event_delete_id_restore sg_event_delete_at_oc locked event_pre id_event_delete_at_oc )
  **  (InsideCritical sg_event_delete_at_oc locked )
.

Definition _EventDelete_partial_solve_wit_17 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH2 : ((event_addr (original)) = event_pre)) (PreH3 : ((event_id (original)) = id_event_delete_at_oc)) (PreH4 : ((event_pending_addrs (original)) = (@nil Z))) (PreH5 : (event_pre <> 0)) (PreH6 : (0 <= id_event_delete_at_oc)) (PreH7 : (id_event_delete_at_oc < 65536)) (PreH8 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH9 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH10 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH11 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH12 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH13 : (resched = 1)) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc )) (PreH15 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  ((&((event_pre)  # "Event" ->ₛ "id" .ₛ "id")) # UShort  |-> id_event_delete_at_oc)
  **  (event_delete_id_restore sg_event_delete_at_oc locked event_pre id_event_delete_at_oc )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  “ ((os_events (locked)) = (app (prefix) ((cons (original) (suffix))))) ” 
  &&  “ ((event_addr (original)) = event_pre) ” 
  &&  “ ((event_id (original)) = id_event_delete_at_oc) ” 
  &&  “ ((event_pending_addrs (original)) = (@nil Z)) ” 
  &&  “ (event_pre <> 0) ” 
  &&  “ (0 <= id_event_delete_at_oc) ” 
  &&  “ (id_event_delete_at_oc < 65536) ” 
  &&  “ (NoDup (map (event_addr) ((os_events (locked)))) ) ” 
  &&  “ (NoDup (map (event_id) ((os_events (locked)))) ) ” 
  &&  “ ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked))))))) ” 
  &&  “ ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre true ready locked ) ” 
  &&  “ (resched = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre true ready ) ”
  &&  ((&((event_pre)  # "Event" ->ₛ "id" .ₛ "id")) # UShort  |-> id_event_delete_at_oc)
  **  (event_delete_id_restore sg_event_delete_at_oc locked event_pre id_event_delete_at_oc )
  **  (InsideCritical sg_event_delete_at_oc locked )
.

Definition _EventDelete_partial_solve_wit_18_pure := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (retval: Z) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH2 : ((event_addr (original)) = event_pre)) (PreH3 : ((event_id (original)) = id_event_delete_at_oc)) (PreH4 : ((event_pending_addrs (original)) = (@nil Z))) (PreH5 : (event_pre <> 0)) (PreH6 : (0 <= id_event_delete_at_oc)) (PreH7 : (id_event_delete_at_oc < 65536)) (PreH8 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH9 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH10 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH11 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH12 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH13 : (resched = 0)) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc )) (PreH15 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (os_inv sg_event_delete_at_oc locked )
  **  ((( &( "delete_event_id" ) )) # UShort  |-> id_event_delete_at_oc)
  **  (InsideCritical sg_event_delete_at_oc locked )
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "inspect_lock" ) )) # Int  |->_)
  **  ((( &( "pending_empty" ) )) # Int  |->_)
|--
  “ ((os_events (locked)) = (app (prefix) ((cons (original) (suffix))))) ” 
  &&  “ ((event_addr (original)) = event_pre) ”
.

Definition _EventDelete_partial_solve_wit_18_aux := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH2 : ((event_addr (original)) = event_pre)) (PreH3 : ((event_id (original)) = id_event_delete_at_oc)) (PreH4 : ((event_pending_addrs (original)) = (@nil Z))) (PreH5 : (event_pre <> 0)) (PreH6 : (0 <= id_event_delete_at_oc)) (PreH7 : (id_event_delete_at_oc < 65536)) (PreH8 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH9 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH10 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH11 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH12 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH13 : (resched = 0)) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc )) (PreH15 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (os_inv sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  “ ((os_events (locked)) = (app (prefix) ((cons (original) (suffix))))) ” 
  &&  “ ((event_addr (original)) = event_pre) ” 
  &&  “ ((os_events (locked)) = (app (prefix) ((cons (original) (suffix))))) ” 
  &&  “ ((event_addr (original)) = event_pre) ” 
  &&  “ ((event_id (original)) = id_event_delete_at_oc) ” 
  &&  “ ((event_pending_addrs (original)) = (@nil Z)) ” 
  &&  “ (event_pre <> 0) ” 
  &&  “ (0 <= id_event_delete_at_oc) ” 
  &&  “ (id_event_delete_at_oc < 65536) ” 
  &&  “ (NoDup (map (event_addr) ((os_events (locked)))) ) ” 
  &&  “ (NoDup (map (event_id) ((os_events (locked)))) ) ” 
  &&  “ ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked))))))) ” 
  &&  “ ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre true ready locked ) ” 
  &&  “ (resched = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre true ready ) ”
  &&  (os_inv sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
.

Definition _EventDelete_partial_solve_wit_18 := _EventDelete_partial_solve_wit_18_pure -> _EventDelete_partial_solve_wit_18_aux.

Definition _EventDelete_partial_solve_wit_19_pure := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (retval: Z) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH2 : ((event_addr (original)) = event_pre)) (PreH3 : ((event_id (original)) = id_event_delete_at_oc)) (PreH4 : ((event_pending_addrs (original)) = (@nil Z))) (PreH5 : (event_pre <> 0)) (PreH6 : (0 <= id_event_delete_at_oc)) (PreH7 : (id_event_delete_at_oc < 65536)) (PreH8 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH9 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH10 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH11 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH12 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH13 : (resched = 1)) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc )) (PreH15 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (os_inv sg_event_delete_at_oc locked )
  **  ((( &( "delete_event_id" ) )) # UShort  |-> id_event_delete_at_oc)
  **  (InsideCritical sg_event_delete_at_oc locked )
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "inspect_lock" ) )) # Int  |->_)
  **  ((( &( "pending_empty" ) )) # Int  |->_)
|--
  “ ((os_events (locked)) = (app (prefix) ((cons (original) (suffix))))) ” 
  &&  “ ((event_addr (original)) = event_pre) ”
.

Definition _EventDelete_partial_solve_wit_19_aux := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH2 : ((event_addr (original)) = event_pre)) (PreH3 : ((event_id (original)) = id_event_delete_at_oc)) (PreH4 : ((event_pending_addrs (original)) = (@nil Z))) (PreH5 : (event_pre <> 0)) (PreH6 : (0 <= id_event_delete_at_oc)) (PreH7 : (id_event_delete_at_oc < 65536)) (PreH8 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH9 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH10 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH11 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH12 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH13 : (resched = 1)) (PreH14 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc )) (PreH15 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (os_inv sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  “ ((os_events (locked)) = (app (prefix) ((cons (original) (suffix))))) ” 
  &&  “ ((event_addr (original)) = event_pre) ” 
  &&  “ ((os_events (locked)) = (app (prefix) ((cons (original) (suffix))))) ” 
  &&  “ ((event_addr (original)) = event_pre) ” 
  &&  “ ((event_id (original)) = id_event_delete_at_oc) ” 
  &&  “ ((event_pending_addrs (original)) = (@nil Z)) ” 
  &&  “ (event_pre <> 0) ” 
  &&  “ (0 <= id_event_delete_at_oc) ” 
  &&  “ (id_event_delete_at_oc < 65536) ” 
  &&  “ (NoDup (map (event_addr) ((os_events (locked)))) ) ” 
  &&  “ (NoDup (map (event_id) ((os_events (locked)))) ) ” 
  &&  “ ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked))))))) ” 
  &&  “ ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre true ready locked ) ” 
  &&  “ (resched = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre true ready ) ”
  &&  (os_inv sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
.

Definition _EventDelete_partial_solve_wit_19 := _EventDelete_partial_solve_wit_19_pure -> _EventDelete_partial_solve_wit_19_aux.

Definition _EventDelete_partial_solve_wit_20_pure := 
(
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (retval: Z) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH2 : ((event_addr (original)) = event_pre)) (PreH3 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH4 : ((event_addr (original)) = event_pre)) (PreH5 : ((event_id (original)) = id_event_delete_at_oc)) (PreH6 : ((event_pending_addrs (original)) = (@nil Z))) (PreH7 : (event_pre <> 0)) (PreH8 : (0 <= id_event_delete_at_oc)) (PreH9 : (id_event_delete_at_oc < 65536)) (PreH10 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH11 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH12 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH13 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH14 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH15 : (resched = 1)) (PreH16 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc )) (PreH17 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((cons ((Build_DL_Node (original) (&((event_pre)  # "Event" ->ₛ "link")))) ((map (event_link_node) (suffix)))))) )
  **  ((( &( "delete_event_id" ) )) # UShort  |-> id_event_delete_at_oc)
  **  (InsideCritical sg_event_delete_at_oc locked )
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "inspect_lock" ) )) # Int  |->_)
  **  ((( &( "pending_empty" ) )) # Int  |->_)
|--
  “ (0 <= id_event_delete_at_oc) ” 
  &&  “ (id_event_delete_at_oc < 65536) ” 
  &&  “ (( &( "k_event_id_manager" ) ) <> 0) ”
) \/
(
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (retval: Z) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : (retval <= INT_MAX)) (PreH2 : (resched <= INT_MAX)) (PreH3 : (retval >= INT_MIN)) (PreH4 : (resched >= INT_MIN)) (PreH5 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH6 : ((event_addr (original)) = event_pre)) (PreH7 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH8 : ((event_addr (original)) = event_pre)) (PreH9 : ((event_id (original)) = id_event_delete_at_oc)) (PreH10 : ((event_pending_addrs (original)) = (@nil Z))) (PreH11 : (event_pre <> 0)) (PreH12 : (0 <= id_event_delete_at_oc)) (PreH13 : (id_event_delete_at_oc < 65536)) (PreH14 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH15 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH16 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH17 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH18 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH19 : (resched = 1)) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc )) (PreH21 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((cons ((Build_DL_Node (original) (&((event_pre)  # "Event" ->ₛ "link")))) ((map (event_link_node) (suffix)))))) )
  **  ((( &( "delete_event_id" ) )) # UShort  |-> id_event_delete_at_oc)
  **  (InsideCritical sg_event_delete_at_oc locked )
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "inspect_lock" ) )) # Int  |->_)
  **  ((( &( "pending_empty" ) )) # Int  |->_)
|--
  “ (( &( "k_event_id_manager" ) ) <> 0) ”
).

Definition _EventDelete_partial_solve_wit_20_pure_split_goal_1 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (retval: Z) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : (retval <= INT_MAX)) (PreH2 : (resched <= INT_MAX)) (PreH3 : (retval >= INT_MIN)) (PreH4 : (resched >= INT_MIN)) (PreH5 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH6 : ((event_addr (original)) = event_pre)) (PreH7 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH8 : ((event_addr (original)) = event_pre)) (PreH9 : ((event_id (original)) = id_event_delete_at_oc)) (PreH10 : ((event_pending_addrs (original)) = (@nil Z))) (PreH11 : (event_pre <> 0)) (PreH12 : (0 <= id_event_delete_at_oc)) (PreH13 : (id_event_delete_at_oc < 65536)) (PreH14 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH15 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH16 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH17 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH18 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH19 : (resched = 1)) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc )) (PreH21 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((cons ((Build_DL_Node (original) (&((event_pre)  # "Event" ->ₛ "link")))) ((map (event_link_node) (suffix)))))) )
  **  ((( &( "delete_event_id" ) )) # UShort  |-> id_event_delete_at_oc)
  **  (InsideCritical sg_event_delete_at_oc locked )
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "inspect_lock" ) )) # Int  |->_)
  **  ((( &( "pending_empty" ) )) # Int  |->_)
|--
  “ (( &( "k_event_id_manager" ) ) <> 0) ”
.

Definition _EventDelete_partial_solve_wit_20_aux := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH2 : ((event_addr (original)) = event_pre)) (PreH3 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH4 : ((event_addr (original)) = event_pre)) (PreH5 : ((event_id (original)) = id_event_delete_at_oc)) (PreH6 : ((event_pending_addrs (original)) = (@nil Z))) (PreH7 : (event_pre <> 0)) (PreH8 : (0 <= id_event_delete_at_oc)) (PreH9 : (id_event_delete_at_oc < 65536)) (PreH10 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH11 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH12 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH13 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH14 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH15 : (resched = 1)) (PreH16 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc )) (PreH17 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((cons ((Build_DL_Node (original) (&((event_pre)  # "Event" ->ₛ "link")))) ((map (event_link_node) (suffix)))))) )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  “ (0 <= id_event_delete_at_oc) ” 
  &&  “ (id_event_delete_at_oc < 65536) ” 
  &&  “ (( &( "k_event_id_manager" ) ) <> 0) ” 
  &&  “ ((os_events (locked)) = (app (prefix) ((cons (original) (suffix))))) ” 
  &&  “ ((event_addr (original)) = event_pre) ” 
  &&  “ ((os_events (locked)) = (app (prefix) ((cons (original) (suffix))))) ” 
  &&  “ ((event_addr (original)) = event_pre) ” 
  &&  “ ((event_id (original)) = id_event_delete_at_oc) ” 
  &&  “ ((event_pending_addrs (original)) = (@nil Z)) ” 
  &&  “ (event_pre <> 0) ” 
  &&  “ (0 <= id_event_delete_at_oc) ” 
  &&  “ (id_event_delete_at_oc < 65536) ” 
  &&  “ (NoDup (map (event_addr) ((os_events (locked)))) ) ” 
  &&  “ (NoDup (map (event_id) ((os_events (locked)))) ) ” 
  &&  “ ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked))))))) ” 
  &&  “ ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre true ready locked ) ” 
  &&  “ (resched = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre true ready ) ”
  &&  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((cons ((Build_DL_Node (original) (&((event_pre)  # "Event" ->ₛ "link")))) ((map (event_link_node) (suffix)))))) )
  **  (InsideCritical sg_event_delete_at_oc locked )
.

Definition _EventDelete_partial_solve_wit_20 := _EventDelete_partial_solve_wit_20_pure -> _EventDelete_partial_solve_wit_20_aux.

Definition _EventDelete_partial_solve_wit_21_pure := 
(
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (retval: Z) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH2 : ((event_addr (original)) = event_pre)) (PreH3 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH4 : ((event_addr (original)) = event_pre)) (PreH5 : ((event_id (original)) = id_event_delete_at_oc)) (PreH6 : ((event_pending_addrs (original)) = (@nil Z))) (PreH7 : (event_pre <> 0)) (PreH8 : (0 <= id_event_delete_at_oc)) (PreH9 : (id_event_delete_at_oc < 65536)) (PreH10 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH11 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH12 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH13 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH14 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH15 : (resched = 0)) (PreH16 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc )) (PreH17 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((cons ((Build_DL_Node (original) (&((event_pre)  # "Event" ->ₛ "link")))) ((map (event_link_node) (suffix)))))) )
  **  ((( &( "delete_event_id" ) )) # UShort  |-> id_event_delete_at_oc)
  **  (InsideCritical sg_event_delete_at_oc locked )
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "inspect_lock" ) )) # Int  |->_)
  **  ((( &( "pending_empty" ) )) # Int  |->_)
|--
  “ (0 <= id_event_delete_at_oc) ” 
  &&  “ (id_event_delete_at_oc < 65536) ” 
  &&  “ (( &( "k_event_id_manager" ) ) <> 0) ”
) \/
(
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (retval: Z) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : (retval <= INT_MAX)) (PreH2 : (resched <= INT_MAX)) (PreH3 : (retval >= INT_MIN)) (PreH4 : (resched >= INT_MIN)) (PreH5 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH6 : ((event_addr (original)) = event_pre)) (PreH7 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH8 : ((event_addr (original)) = event_pre)) (PreH9 : ((event_id (original)) = id_event_delete_at_oc)) (PreH10 : ((event_pending_addrs (original)) = (@nil Z))) (PreH11 : (event_pre <> 0)) (PreH12 : (0 <= id_event_delete_at_oc)) (PreH13 : (id_event_delete_at_oc < 65536)) (PreH14 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH15 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH16 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH17 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH18 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH19 : (resched = 0)) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc )) (PreH21 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((cons ((Build_DL_Node (original) (&((event_pre)  # "Event" ->ₛ "link")))) ((map (event_link_node) (suffix)))))) )
  **  ((( &( "delete_event_id" ) )) # UShort  |-> id_event_delete_at_oc)
  **  (InsideCritical sg_event_delete_at_oc locked )
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "inspect_lock" ) )) # Int  |->_)
  **  ((( &( "pending_empty" ) )) # Int  |->_)
|--
  “ (( &( "k_event_id_manager" ) ) <> 0) ”
).

Definition _EventDelete_partial_solve_wit_21_pure_split_goal_1 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (retval: Z) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : (retval <= INT_MAX)) (PreH2 : (resched <= INT_MAX)) (PreH3 : (retval >= INT_MIN)) (PreH4 : (resched >= INT_MIN)) (PreH5 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH6 : ((event_addr (original)) = event_pre)) (PreH7 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH8 : ((event_addr (original)) = event_pre)) (PreH9 : ((event_id (original)) = id_event_delete_at_oc)) (PreH10 : ((event_pending_addrs (original)) = (@nil Z))) (PreH11 : (event_pre <> 0)) (PreH12 : (0 <= id_event_delete_at_oc)) (PreH13 : (id_event_delete_at_oc < 65536)) (PreH14 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH15 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH16 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH17 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH18 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH19 : (resched = 0)) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc )) (PreH21 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((cons ((Build_DL_Node (original) (&((event_pre)  # "Event" ->ₛ "link")))) ((map (event_link_node) (suffix)))))) )
  **  ((( &( "delete_event_id" ) )) # UShort  |-> id_event_delete_at_oc)
  **  (InsideCritical sg_event_delete_at_oc locked )
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "lock" ) )) # Int  |-> retval)
  **  ((( &( "inspect_lock" ) )) # Int  |->_)
  **  ((( &( "pending_empty" ) )) # Int  |->_)
|--
  “ (( &( "k_event_id_manager" ) ) <> 0) ”
.

Definition _EventDelete_partial_solve_wit_21_aux := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH2 : ((event_addr (original)) = event_pre)) (PreH3 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH4 : ((event_addr (original)) = event_pre)) (PreH5 : ((event_id (original)) = id_event_delete_at_oc)) (PreH6 : ((event_pending_addrs (original)) = (@nil Z))) (PreH7 : (event_pre <> 0)) (PreH8 : (0 <= id_event_delete_at_oc)) (PreH9 : (id_event_delete_at_oc < 65536)) (PreH10 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH11 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH12 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH13 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH14 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH15 : (resched = 0)) (PreH16 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc )) (PreH17 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((cons ((Build_DL_Node (original) (&((event_pre)  # "Event" ->ₛ "link")))) ((map (event_link_node) (suffix)))))) )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  “ (0 <= id_event_delete_at_oc) ” 
  &&  “ (id_event_delete_at_oc < 65536) ” 
  &&  “ (( &( "k_event_id_manager" ) ) <> 0) ” 
  &&  “ ((os_events (locked)) = (app (prefix) ((cons (original) (suffix))))) ” 
  &&  “ ((event_addr (original)) = event_pre) ” 
  &&  “ ((os_events (locked)) = (app (prefix) ((cons (original) (suffix))))) ” 
  &&  “ ((event_addr (original)) = event_pre) ” 
  &&  “ ((event_id (original)) = id_event_delete_at_oc) ” 
  &&  “ ((event_pending_addrs (original)) = (@nil Z)) ” 
  &&  “ (event_pre <> 0) ” 
  &&  “ (0 <= id_event_delete_at_oc) ” 
  &&  “ (id_event_delete_at_oc < 65536) ” 
  &&  “ (NoDup (map (event_addr) ((os_events (locked)))) ) ” 
  &&  “ (NoDup (map (event_id) ((os_events (locked)))) ) ” 
  &&  “ ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked))))))) ” 
  &&  “ ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre true ready locked ) ” 
  &&  “ (resched = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre true ready ) ”
  &&  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((cons ((Build_DL_Node (original) (&((event_pre)  # "Event" ->ₛ "link")))) ((map (event_link_node) (suffix)))))) )
  **  (InsideCritical sg_event_delete_at_oc locked )
.

Definition _EventDelete_partial_solve_wit_21 := _EventDelete_partial_solve_wit_21_pure -> _EventDelete_partial_solve_wit_21_aux.

Definition _EventDelete_partial_solve_wit_22 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = false)) (PreH2 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH3 : ((event_addr (original)) = event_pre)) (PreH4 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH5 : ((event_addr (original)) = event_pre)) (PreH6 : ((event_id (original)) = id_event_delete_at_oc)) (PreH7 : ((event_pending_addrs (original)) = (@nil Z))) (PreH8 : (event_pre <> 0)) (PreH9 : (0 <= id_event_delete_at_oc)) (PreH10 : (id_event_delete_at_oc < 65536)) (PreH11 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH12 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH13 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH14 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH15 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH16 : (resched = 1)) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc )) (PreH18 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((cons ((Build_DL_Node (original) (&((event_pre)  # "Event" ->ₛ "link")))) ((map (event_link_node) (suffix)))))) )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  “ ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = false) ” 
  &&  “ ((os_events (locked)) = (app (prefix) ((cons (original) (suffix))))) ” 
  &&  “ ((event_addr (original)) = event_pre) ” 
  &&  “ ((os_events (locked)) = (app (prefix) ((cons (original) (suffix))))) ” 
  &&  “ ((event_addr (original)) = event_pre) ” 
  &&  “ ((event_id (original)) = id_event_delete_at_oc) ” 
  &&  “ ((event_pending_addrs (original)) = (@nil Z)) ” 
  &&  “ (event_pre <> 0) ” 
  &&  “ (0 <= id_event_delete_at_oc) ” 
  &&  “ (id_event_delete_at_oc < 65536) ” 
  &&  “ (NoDup (map (event_addr) ((os_events (locked)))) ) ” 
  &&  “ (NoDup (map (event_id) ((os_events (locked)))) ) ” 
  &&  “ ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked))))))) ” 
  &&  “ ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre true ready locked ) ” 
  &&  “ (resched = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre true ready ) ”
  &&  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((cons ((Build_DL_Node (original) (&((event_pre)  # "Event" ->ₛ "link")))) ((map (event_link_node) (suffix)))))) )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
.

Definition _EventDelete_partial_solve_wit_23 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (idnode: Z) (PreH1 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH2 : (idmanager_contains (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) id_event_delete_at_oc idnode )) (PreH3 : (idnode <> 0)) (PreH4 : (&((idnode)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH6 : ((event_addr (original)) = event_pre)) (PreH7 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH8 : ((event_addr (original)) = event_pre)) (PreH9 : ((event_id (original)) = id_event_delete_at_oc)) (PreH10 : ((event_pending_addrs (original)) = (@nil Z))) (PreH11 : (event_pre <> 0)) (PreH12 : (0 <= id_event_delete_at_oc)) (PreH13 : (id_event_delete_at_oc < 65536)) (PreH14 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH15 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH16 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH17 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH18 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH19 : (resched = 1)) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc )) (PreH21 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) ( &( "k_event_id_manager" ) ) )
  **  ((&((idnode)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((cons ((Build_DL_Node (original) (&((event_pre)  # "Event" ->ₛ "link")))) ((map (event_link_node) (suffix)))))) )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  “ ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true) ” 
  &&  “ (idmanager_contains (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) id_event_delete_at_oc idnode ) ” 
  &&  “ (idnode <> 0) ” 
  &&  “ (&((idnode)  # "IdNode" ->ₛ "link") <> 0) ” 
  &&  “ ((os_events (locked)) = (app (prefix) ((cons (original) (suffix))))) ” 
  &&  “ ((event_addr (original)) = event_pre) ” 
  &&  “ ((os_events (locked)) = (app (prefix) ((cons (original) (suffix))))) ” 
  &&  “ ((event_addr (original)) = event_pre) ” 
  &&  “ ((event_id (original)) = id_event_delete_at_oc) ” 
  &&  “ ((event_pending_addrs (original)) = (@nil Z)) ” 
  &&  “ (event_pre <> 0) ” 
  &&  “ (0 <= id_event_delete_at_oc) ” 
  &&  “ (id_event_delete_at_oc < 65536) ” 
  &&  “ (NoDup (map (event_addr) ((os_events (locked)))) ) ” 
  &&  “ (NoDup (map (event_id) ((os_events (locked)))) ) ” 
  &&  “ ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked))))))) ” 
  &&  “ ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre true ready locked ) ” 
  &&  “ (resched = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre true ready ) ”
  &&  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((cons ((Build_DL_Node (original) (&((event_pre)  # "Event" ->ₛ "link")))) ((map (event_link_node) (suffix)))))) )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) ( &( "k_event_id_manager" ) ) )
  **  ((&((idnode)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
.

Definition _EventDelete_partial_solve_wit_24 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = false)) (PreH2 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH3 : ((event_addr (original)) = event_pre)) (PreH4 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH5 : ((event_addr (original)) = event_pre)) (PreH6 : ((event_id (original)) = id_event_delete_at_oc)) (PreH7 : ((event_pending_addrs (original)) = (@nil Z))) (PreH8 : (event_pre <> 0)) (PreH9 : (0 <= id_event_delete_at_oc)) (PreH10 : (id_event_delete_at_oc < 65536)) (PreH11 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH12 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH13 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH14 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH15 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH16 : (resched = 0)) (PreH17 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc )) (PreH18 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((cons ((Build_DL_Node (original) (&((event_pre)  # "Event" ->ₛ "link")))) ((map (event_link_node) (suffix)))))) )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  “ ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = false) ” 
  &&  “ ((os_events (locked)) = (app (prefix) ((cons (original) (suffix))))) ” 
  &&  “ ((event_addr (original)) = event_pre) ” 
  &&  “ ((os_events (locked)) = (app (prefix) ((cons (original) (suffix))))) ” 
  &&  “ ((event_addr (original)) = event_pre) ” 
  &&  “ ((event_id (original)) = id_event_delete_at_oc) ” 
  &&  “ ((event_pending_addrs (original)) = (@nil Z)) ” 
  &&  “ (event_pre <> 0) ” 
  &&  “ (0 <= id_event_delete_at_oc) ” 
  &&  “ (id_event_delete_at_oc < 65536) ” 
  &&  “ (NoDup (map (event_addr) ((os_events (locked)))) ) ” 
  &&  “ (NoDup (map (event_id) ((os_events (locked)))) ) ” 
  &&  “ ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked))))))) ” 
  &&  “ ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre true ready locked ) ” 
  &&  “ (resched = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre true ready ) ”
  &&  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((cons ((Build_DL_Node (original) (&((event_pre)  # "Event" ->ₛ "link")))) ((map (event_link_node) (suffix)))))) )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
.

Definition _EventDelete_partial_solve_wit_25 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (resched: Z) (ready: VarGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (idnode: Z) (PreH1 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH2 : (idmanager_contains (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) id_event_delete_at_oc idnode )) (PreH3 : (idnode <> 0)) (PreH4 : (&((idnode)  # "IdNode" ->ₛ "link") <> 0)) (PreH5 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH6 : ((event_addr (original)) = event_pre)) (PreH7 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH8 : ((event_addr (original)) = event_pre)) (PreH9 : ((event_id (original)) = id_event_delete_at_oc)) (PreH10 : ((event_pending_addrs (original)) = (@nil Z))) (PreH11 : (event_pre <> 0)) (PreH12 : (0 <= id_event_delete_at_oc)) (PreH13 : (id_event_delete_at_oc < 65536)) (PreH14 : (NoDup (map (event_addr) ((os_events (locked)))) )) (PreH15 : (NoDup (map (event_id) ((os_events (locked)))) )) (PreH16 : ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked)))))))) (PreH17 : ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true)) (PreH18 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) (PreH19 : (resched = 0)) (PreH20 : ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc )) (PreH21 : (event_delete_guard id_event_delete_at_oc event_pre true ready )) ,
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) ( &( "k_event_id_manager" ) ) )
  **  ((&((idnode)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((cons ((Build_DL_Node (original) (&((event_pre)  # "Event" ->ₛ "link")))) ((map (event_link_node) (suffix)))))) )
  **  (InsideCritical sg_event_delete_at_oc locked )
|--
  “ ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true) ” 
  &&  “ (idmanager_contains (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) id_event_delete_at_oc idnode ) ” 
  &&  “ (idnode <> 0) ” 
  &&  “ (&((idnode)  # "IdNode" ->ₛ "link") <> 0) ” 
  &&  “ ((os_events (locked)) = (app (prefix) ((cons (original) (suffix))))) ” 
  &&  “ ((event_addr (original)) = event_pre) ” 
  &&  “ ((os_events (locked)) = (app (prefix) ((cons (original) (suffix))))) ” 
  &&  “ ((event_addr (original)) = event_pre) ” 
  &&  “ ((event_id (original)) = id_event_delete_at_oc) ” 
  &&  “ ((event_pending_addrs (original)) = (@nil Z)) ” 
  &&  “ (event_pre <> 0) ” 
  &&  “ (0 <= id_event_delete_at_oc) ” 
  &&  “ (id_event_delete_at_oc < 65536) ” 
  &&  “ (NoDup (map (event_addr) ((os_events (locked)))) ) ” 
  &&  “ (NoDup (map (event_id) ((os_events (locked)))) ) ” 
  &&  “ ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked))))))) ” 
  &&  “ ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre true ready locked ) ” 
  &&  “ (resched = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (ready)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre true ready ) ”
  &&  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((cons ((Build_DL_Node (original) (&((event_pre)  # "Event" ->ₛ "link")))) ((map (event_link_node) (suffix)))))) )
  **  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) ( &( "k_event_id_manager" ) ) )
  **  ((&((idnode)  # "IdNode" ->ₛ "id")) # UShort  |-> 65535)
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_prev")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  ((&((idnode)  # "IdNode" ->ₛ "link" .ₛ "node_next")) # Ptr  |-> &((idnode)  # "IdNode" ->ₛ "link"))
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (InsideCritical sg_event_delete_at_oc locked )
.

Definition _EventDelete_partial_solve_wit_26_pure := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (locked: VarGlobalState) (original: EventAbs) (resched: Z) (after: VarGlobalState) (saved_lock: Z) (PreH1 : (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) (PreH2 : (resched = 1)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_event_delete_at_oc )) (PreH4 : (Crtos_GTrans locked after )) ,
  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
  **  ((( &( "delete_event_id" ) )) # UShort  |-> id_event_delete_at_oc)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "inspect_lock" ) )) # Int  |->_)
  **  ((( &( "pending_empty" ) )) # Int  |->_)
  **  (InsideCritical sg_event_delete_at_oc locked )
  **  (os_inv sg_event_delete_at_oc after )
  **  (EventRetired event_pre (event_options (original)) (event_events (original)) )
|--
  “ (Crtos_GTrans locked after ) ”
.

Definition _EventDelete_partial_solve_wit_26_aux := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_event_delete_at_oc: StableGlobalState) (locked: VarGlobalState) (original: EventAbs) (resched: Z) (after: VarGlobalState) (PreH1 : (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) (PreH2 : (resched = 1)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_event_delete_at_oc )) (PreH4 : (Crtos_GTrans locked after )) ,
  (InsideCritical sg_event_delete_at_oc locked )
  **  (os_inv sg_event_delete_at_oc after )
  **  (EventRetired event_pre (event_options (original)) (event_events (original)) )
|--
  “ (Crtos_GTrans locked after ) ” 
  &&  “ (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked))) ” 
  &&  “ (resched = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_event_delete_at_oc ) ” 
  &&  “ (Crtos_GTrans locked after ) ”
  &&  (InsideCritical sg_event_delete_at_oc locked )
  **  (os_inv sg_event_delete_at_oc after )
  **  (EventRetired event_pre (event_options (original)) (event_events (original)) )
.

Definition _EventDelete_partial_solve_wit_26 := _EventDelete_partial_solve_wit_26_pure -> _EventDelete_partial_solve_wit_26_aux.

Definition _EventDelete_partial_solve_wit_27_pure := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (locked: VarGlobalState) (original: EventAbs) (resched: Z) (after: VarGlobalState) (saved_lock: Z) (PreH1 : (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) (PreH2 : (resched = 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_event_delete_at_oc )) (PreH4 : (Crtos_GTrans locked after )) ,
  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
  **  ((( &( "delete_event_id" ) )) # UShort  |-> id_event_delete_at_oc)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "inspect_lock" ) )) # Int  |->_)
  **  ((( &( "pending_empty" ) )) # Int  |->_)
  **  (InsideCritical sg_event_delete_at_oc locked )
  **  (os_inv sg_event_delete_at_oc after )
  **  (EventRetired event_pre (event_options (original)) (event_events (original)) )
|--
  “ (Crtos_GTrans locked after ) ”
.

Definition _EventDelete_partial_solve_wit_27_aux := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_event_delete_at_oc: StableGlobalState) (locked: VarGlobalState) (original: EventAbs) (resched: Z) (after: VarGlobalState) (PreH1 : (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) (PreH2 : (resched = 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_event_delete_at_oc )) (PreH4 : (Crtos_GTrans locked after )) ,
  (InsideCritical sg_event_delete_at_oc locked )
  **  (os_inv sg_event_delete_at_oc after )
  **  (EventRetired event_pre (event_options (original)) (event_events (original)) )
|--
  “ (Crtos_GTrans locked after ) ” 
  &&  “ (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked))) ” 
  &&  “ (resched = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_event_delete_at_oc ) ” 
  &&  “ (Crtos_GTrans locked after ) ”
  &&  (InsideCritical sg_event_delete_at_oc locked )
  **  (os_inv sg_event_delete_at_oc after )
  **  (EventRetired event_pre (event_options (original)) (event_events (original)) )
.

Definition _EventDelete_partial_solve_wit_27 := _EventDelete_partial_solve_wit_27_pure -> _EventDelete_partial_solve_wit_27_aux.

Definition _EventDelete_partial_solve_wit_28 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_event_delete_at_oc: StableGlobalState) (locked: VarGlobalState) (original: EventAbs) (resched: Z) (after: VarGlobalState) (PreH1 : (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) (PreH2 : (resched = 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_event_delete_at_oc )) (PreH4 : (Crtos_GTrans locked after )) ,
  (OutsideCritical sg_event_delete_at_oc after )
  **  (EventRetired event_pre (event_options (original)) (event_events (original)) )
|--
  “ (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked))) ” 
  &&  “ (resched = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_event_delete_at_oc ) ” 
  &&  “ (Crtos_GTrans locked after ) ”
  &&  (EventRetired event_pre (event_options (original)) (event_events (original)) )
  **  (OutsideCritical sg_event_delete_at_oc after )
.

Definition _EventDelete_partial_solve_wit_29 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_event_delete_at_oc: StableGlobalState) (locked: VarGlobalState) (original: EventAbs) (resched: Z) (after: VarGlobalState) (PreH1 : (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) (PreH2 : (resched = 1)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_event_delete_at_oc )) (PreH4 : (Crtos_GTrans locked after )) ,
  (OutsideCritical sg_event_delete_at_oc after )
  **  (EventRetired event_pre (event_options (original)) (event_events (original)) )
|--
  “ (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked))) ” 
  &&  “ (resched = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_event_delete_at_oc ) ” 
  &&  “ (Crtos_GTrans locked after ) ”
  &&  (EventRetired event_pre (event_options (original)) (event_events (original)) )
  **  (OutsideCritical sg_event_delete_at_oc after )
.

Definition _EventDelete_partial_solve_wit_30 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_event_delete_at_oc: StableGlobalState) (locked: VarGlobalState) (resched: Z) (after: VarGlobalState) (PreH1 : (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) (PreH2 : (resched = 1)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_event_delete_at_oc )) (PreH4 : (Crtos_GTrans locked after )) ,
  (EventRaw event_pre )
  **  (OutsideCritical sg_event_delete_at_oc after )
|--
  “ (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked))) ” 
  &&  “ (resched = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_event_delete_at_oc ) ” 
  &&  “ (Crtos_GTrans locked after ) ”
  &&  (EventRaw event_pre )
  **  (OutsideCritical sg_event_delete_at_oc after )
.

Definition _EventDelete_partial_solve_wit_31 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_event_delete_at_oc: StableGlobalState) (locked: VarGlobalState) (resched: Z) (after: VarGlobalState) (PreH1 : (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) (PreH2 : (resched = 0)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_event_delete_at_oc )) (PreH4 : (Crtos_GTrans locked after )) ,
  (EventRaw event_pre )
  **  (OutsideCritical sg_event_delete_at_oc after )
|--
  “ (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked))) ” 
  &&  “ (resched = 0) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_event_delete_at_oc ) ” 
  &&  “ (Crtos_GTrans locked after ) ”
  &&  (EventRaw event_pre )
  **  (OutsideCritical sg_event_delete_at_oc after )
.

Definition _EventDelete_partial_solve_wit_32_pure := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (locked: VarGlobalState) (resched: Z) (after: VarGlobalState) (saved_lock: Z) (PreH1 : (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) (PreH2 : (resched = 1)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_event_delete_at_oc )) (PreH4 : (Crtos_GTrans locked after )) (PreH5 : (resched <> 0)) ,
  (OutsideCritical sg_event_delete_at_oc after )
  **  ((( &( "lock" ) )) # Int  |-> saved_lock)
  **  ((( &( "event" ) )) # Ptr  |-> event_pre)
  **  ((( &( "delete_event_id" ) )) # UShort  |-> id_event_delete_at_oc)
  **  ((( &( "resched" ) )) # Int  |-> resched)
  **  ((( &( "inspect_lock" ) )) # Int  |->_)
  **  ((( &( "pending_empty" ) )) # Int  |->_)
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_event_delete_at_oc ) ”
.

Definition _EventDelete_partial_solve_wit_32_aux := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (sg_event_delete_at_oc: StableGlobalState) (locked: VarGlobalState) (resched: Z) (after: VarGlobalState) (PreH1 : (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked)))) (PreH2 : (resched = 1)) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_event_delete_at_oc )) (PreH4 : (Crtos_GTrans locked after )) (PreH5 : (resched <> 0)) ,
  (OutsideCritical sg_event_delete_at_oc after )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_event_delete_at_oc ) ” 
  &&  “ (after = (replace_events ((event_unpublish (event_pre) ((os_events (locked))))) (locked))) ” 
  &&  “ (resched = 1) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) abs_ktask_assign X_event_delete_at_oc ) ” 
  &&  “ (Crtos_GTrans locked after ) ” 
  &&  “ (resched <> 0) ”
  &&  (OutsideCritical sg_event_delete_at_oc after )
.

Definition _EventDelete_partial_solve_wit_32 := _EventDelete_partial_solve_wit_32_pure -> _EventDelete_partial_solve_wit_32_aux.

Definition _EventDelete_which_implies_wit_1 := 
(
forall (event_pre: Z) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (checked: VarGlobalState) (PreH1 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) ,
  (os_inv sg_event_delete_at_oc checked )
|--
  EX (waiting: (@list Z)) ,
  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false checked ) ” 
  &&  “ ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list")) ”
  &&  (store_dll (pure_suspend_sched_link (((checked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "pend_list") (map (event_wait_node) (waiting)) )
  **  (event_delete_pending_restore sg_event_delete_at_oc checked event_pre waiting )
) \/
(
forall (event_pre: Z) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (checked: VarGlobalState) (PreH1 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) ,
  (os_inv sg_event_delete_at_oc checked )
|--
  EX (waiting: (@list Z)) ,
  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ” 
  &&  “ (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false checked ) ” 
  &&  “ ((event_pending_head (event_pre)) = &((event_pre)  # "Event" ->ₛ "pend_list")) ”
  &&  (store_dll (pure_suspend_sched_link (((checked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "pend_list") (map (event_wait_node) (waiting)) )
  **  (event_delete_pending_restore sg_event_delete_at_oc checked event_pre waiting )
).

Definition _EventDelete_which_implies_wit_2 := 
(
forall (event_pre: Z) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (checked: VarGlobalState) (waiting: (@list Z)) (PreH1 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) ,
  (store_dll (pure_suspend_sched_link (((checked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "pend_list") (map (event_wait_node) (waiting)) )
  **  (event_delete_pending_restore sg_event_delete_at_oc checked event_pre waiting )
|--
  “ (event_pending_at id_event_delete_at_oc event_pre waiting checked ) ” 
  &&  “ (Crtos_GTrans checked checked ) ”
  &&  (os_inv sg_event_delete_at_oc checked )
) \/
(
forall (event_pre: Z) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (checked: VarGlobalState) (waiting: (@list Z)) (PreH1 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) ,
  (store_dll (pure_suspend_sched_link (((checked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "pend_list") (map (event_wait_node) (waiting)) )
  **  (event_delete_pending_restore sg_event_delete_at_oc checked event_pre waiting )
|--
  “ (Crtos_GTrans checked checked ) ”
  &&  (os_inv sg_event_delete_at_oc checked )
).

Definition _EventDelete_which_implies_wit_2_split_goal_1 := 
forall (event_pre: Z) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (checked: VarGlobalState) (waiting: (@list Z)) (PreH1 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) ,
  (store_dll (pure_suspend_sched_link (((checked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "pend_list") (map (event_wait_node) (waiting)) )
  **  (event_delete_pending_restore sg_event_delete_at_oc checked event_pre waiting )
|--
  “ (Crtos_GTrans checked checked ) ”
.

Definition _EventDelete_which_implies_wit_2_split_goal_spatial := 
forall (event_pre: Z) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (checked: VarGlobalState) (waiting: (@list Z)) (PreH1 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) ,
  (store_dll (pure_suspend_sched_link (((checked.(os_tasks) ).(task_desc_map) ))) &((event_pre)  # "Event" ->ₛ "pend_list") (map (event_wait_node) (waiting)) )
  **  (event_delete_pending_restore sg_event_delete_at_oc checked event_pre waiting )
|--
  (os_inv sg_event_delete_at_oc checked )
.

Definition _EventDelete_which_implies_wit_3 := 
(
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (checked: VarGlobalState) (waiting: (@list Z)) (PreH1 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH2 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH3 : ((map (event_wait_node) (waiting)) <> (@nil (@DL_Node Z)))) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (OutsideCritical sg_event_delete_at_oc checked )
|--
  “ (event_delete_guard id_event_delete_at_oc event_pre false checked ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (checked)) (abs_event_resume_all (id_event_delete_at_oc) (event_pre)) (event_delete_resume_cont (id_event_delete_at_oc) (event_pre) (X_event_delete_at_oc)) ) ”
  &&  (OutsideCritical sg_event_delete_at_oc checked )
) \/
(
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (checked: VarGlobalState) (waiting: (@list Z)) (PreH1 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH2 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH3 : ((map (event_wait_node) (waiting)) <> (@nil (@DL_Node Z)))) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (checked)) (abs_event_resume_all (id_event_delete_at_oc) (event_pre)) (event_delete_resume_cont (id_event_delete_at_oc) (event_pre) (X_event_delete_at_oc)) ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre false checked ) ”
  &&  emp
).

Definition _EventDelete_which_implies_wit_3_split_goal_1 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (checked: VarGlobalState) (waiting: (@list Z)) (PreH1 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH2 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH3 : ((map (event_wait_node) (waiting)) <> (@nil (@DL_Node Z)))) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  ( monadesafe_lib.safeExec  (LastSeen (checked)) (abs_event_resume_all (id_event_delete_at_oc) (event_pre)) (event_delete_resume_cont (id_event_delete_at_oc) (event_pre) (X_event_delete_at_oc)) )
.

Definition _EventDelete_which_implies_wit_3_split_goal_2 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (checked: VarGlobalState) (waiting: (@list Z)) (PreH1 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH2 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH3 : ((map (event_wait_node) (waiting)) <> (@nil (@DL_Node Z)))) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (event_delete_guard id_event_delete_at_oc event_pre false checked )
.

Definition _EventDelete_which_implies_wit_4 := 
(
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (drained: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (event_delete_resume_cont (id_event_delete_at_oc) (event_pre) (X_event_delete_at_oc)) )) ,
  (OutsideCritical sg_event_delete_at_oc drained )
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc ) ”
  &&  (OutsideCritical sg_event_delete_at_oc drained )
) \/
(
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (drained: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (event_delete_resume_cont (id_event_delete_at_oc) (event_pre) (X_event_delete_at_oc)) )) ,
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (drained)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc ) ”
  &&  emp
).

Definition _EventDelete_which_implies_wit_4_split_goal_1 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (drained: VarGlobalState) (PreH1 : ( monadesafe_lib.safeExec  (LastSeen (drained)) ( MonadErr.ret  (tt)) (event_delete_resume_cont (id_event_delete_at_oc) (event_pre) (X_event_delete_at_oc)) )) ,
  ( monadesafe_lib.safeExec  (LastSeen (drained)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (true)) X_event_delete_at_oc )
.

Definition _EventDelete_which_implies_wit_5 := 
(
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (sg_event_delete_at_oc: StableGlobalState) (checked: VarGlobalState) (waiting: (@list Z)) (PreH1 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH2 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH3 : ((map (event_wait_node) (waiting)) = (@nil (@DL_Node Z)))) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (OutsideCritical sg_event_delete_at_oc checked )
|--
  “ (event_delete_guard id_event_delete_at_oc event_pre true checked ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (checked)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc ) ”
  &&  (OutsideCritical sg_event_delete_at_oc checked )
) \/
(
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (checked: VarGlobalState) (waiting: (@list Z)) (PreH1 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH2 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH3 : ((map (event_wait_node) (waiting)) = (@nil (@DL_Node Z)))) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (checked)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc ) ” 
  &&  “ (event_delete_guard id_event_delete_at_oc event_pre true checked ) ”
  &&  emp
).

Definition _EventDelete_which_implies_wit_5_split_goal_1 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (checked: VarGlobalState) (waiting: (@list Z)) (PreH1 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH2 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH3 : ((map (event_wait_node) (waiting)) = (@nil (@DL_Node Z)))) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  ( monadesafe_lib.safeExec  (LastSeen (checked)) (event_delete_finish (id_event_delete_at_oc) (event_pre) (false)) X_event_delete_at_oc )
.

Definition _EventDelete_which_implies_wit_5_split_goal_2 := 
forall (event_pre: Z) (X_event_delete_at_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (id_event_delete_at_oc: Z) (before_event_delete_at_oc: VarGlobalState) (checked: VarGlobalState) (waiting: (@list Z)) (PreH1 : (event_pending_at id_event_delete_at_oc event_pre waiting checked )) (PreH2 : (event_delete_gap id_event_delete_at_oc event_pre false before_event_delete_at_oc checked )) (PreH3 : ((map (event_wait_node) (waiting)) = (@nil (@DL_Node Z)))) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_event_delete_at_oc)) (abs_event_delete_at (id_event_delete_at_oc) (event_pre)) X_event_delete_at_oc )) ,
  (event_delete_guard id_event_delete_at_oc event_pre true checked )
.

Definition _EventDelete_which_implies_wit_6 := 
(
forall (event_pre: Z) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (ready: VarGlobalState) (locked: VarGlobalState) (PreH1 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) ,
  (os_inv sg_event_delete_at_oc locked )
|--
  EX (prefix: (@list EventAbs))  (original: EventAbs)  (suffix: (@list EventAbs)) ,
  “ ((os_events (locked)) = (app (prefix) ((cons (original) (suffix))))) ” 
  &&  “ ((event_addr (original)) = event_pre) ” 
  &&  “ ((event_id (original)) = id_event_delete_at_oc) ” 
  &&  “ ((event_pending_addrs (original)) = (@nil Z)) ” 
  &&  “ (event_pre <> 0) ” 
  &&  “ (0 <= id_event_delete_at_oc) ” 
  &&  “ (id_event_delete_at_oc < 65536) ” 
  &&  “ (NoDup (map (event_addr) ((os_events (locked)))) ) ” 
  &&  “ (NoDup (map (event_id) ((os_events (locked)))) ) ” 
  &&  “ ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked))))))) ” 
  &&  “ ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true) ”
  &&  ((&((event_pre)  # "Event" ->ₛ "id" .ₛ "id")) # UShort  |-> id_event_delete_at_oc)
  **  (event_delete_id_restore sg_event_delete_at_oc locked event_pre id_event_delete_at_oc )
) \/
(
forall (event_pre: Z) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (ready: VarGlobalState) (locked: VarGlobalState) (PreH1 : (event_delete_gap id_event_delete_at_oc event_pre true ready locked )) ,
  (os_inv sg_event_delete_at_oc locked )
|--
  EX (prefix: (@list EventAbs))  (original: EventAbs)  (suffix: (@list EventAbs)) ,
  “ ((os_events (locked)) = (app (prefix) ((cons (original) (suffix))))) ” 
  &&  “ ((event_addr (original)) = event_pre) ” 
  &&  “ ((event_id (original)) = id_event_delete_at_oc) ” 
  &&  “ ((event_pending_addrs (original)) = (@nil Z)) ” 
  &&  “ (event_pre <> 0) ” 
  &&  “ (0 <= id_event_delete_at_oc) ” 
  &&  “ (id_event_delete_at_oc < 65536) ” 
  &&  “ (NoDup (map (event_addr) ((os_events (locked)))) ) ” 
  &&  “ (NoDup (map (event_id) ((os_events (locked)))) ) ” 
  &&  “ ((idmanager_remove ((event_manager_stable ((os_event_stable (sg_event_delete_at_oc))))) ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = (event_manager ((event_unpublish (event_pre) ((os_events (locked))))))) ” 
  &&  “ ((idmanager_query ((event_manager ((os_events (locked))))) (id_event_delete_at_oc)) = true) ”
  &&  ((&((event_pre)  # "Event" ->ₛ "id" .ₛ "id")) # UShort  |-> id_event_delete_at_oc)
  **  (event_delete_id_restore sg_event_delete_at_oc locked event_pre id_event_delete_at_oc )
).

Definition _EventDelete_which_implies_wit_7 := 
(
forall (event_pre: Z) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (locked: VarGlobalState) ,
  ((&((event_pre)  # "Event" ->ₛ "id" .ₛ "id")) # UShort  |-> id_event_delete_at_oc)
  **  (event_delete_id_restore sg_event_delete_at_oc locked event_pre id_event_delete_at_oc )
|--
  (os_inv sg_event_delete_at_oc locked )
) \/
(
forall (event_pre: Z) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (locked: VarGlobalState) ,
  ((&((event_pre)  # "Event" ->ₛ "id" .ₛ "id")) # UShort  |-> id_event_delete_at_oc)
  **  (event_delete_id_restore sg_event_delete_at_oc locked event_pre id_event_delete_at_oc )
|--
  (os_inv sg_event_delete_at_oc locked )
).

Definition _EventDelete_which_implies_wit_7_split_goal_spatial := 
forall (event_pre: Z) (id_event_delete_at_oc: Z) (sg_event_delete_at_oc: StableGlobalState) (locked: VarGlobalState) ,
  ((&((event_pre)  # "Event" ->ₛ "id" .ₛ "id")) # UShort  |-> id_event_delete_at_oc)
  **  (event_delete_id_restore sg_event_delete_at_oc locked event_pre id_event_delete_at_oc )
|--
  (os_inv sg_event_delete_at_oc locked )
.

Definition _EventDelete_which_implies_wit_8 := 
(
forall (event_pre: Z) (sg_event_delete_at_oc: StableGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH2 : ((event_addr (original)) = event_pre)) ,
  (os_inv sg_event_delete_at_oc locked )
|--
  “ ((os_events (locked)) = (app (prefix) ((cons (original) (suffix))))) ” 
  &&  “ ((event_addr (original)) = event_pre) ”
  &&  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((cons ((Build_DL_Node (original) (&((event_pre)  # "Event" ->ₛ "link")))) ((map (event_link_node) (suffix)))))) )
) \/
(
forall (event_pre: Z) (sg_event_delete_at_oc: StableGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH2 : ((event_addr (original)) = event_pre)) ,
  (os_inv sg_event_delete_at_oc locked )
|--
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((cons ((Build_DL_Node (original) (&((event_pre)  # "Event" ->ₛ "link")))) ((map (event_link_node) (suffix)))))) )
).

Definition _EventDelete_which_implies_wit_8_split_goal_spatial := 
forall (event_pre: Z) (sg_event_delete_at_oc: StableGlobalState) (locked: VarGlobalState) (original: EventAbs) (prefix: (@list EventAbs)) (suffix: (@list EventAbs)) (PreH1 : ((os_events (locked)) = (app (prefix) ((cons (original) (suffix)))))) (PreH2 : ((event_addr (original)) = event_pre)) ,
  (os_inv sg_event_delete_at_oc locked )
|--
  (store_idmanager (event_manager_stable ((os_event_stable (sg_event_delete_at_oc)))) (event_manager ((os_events (locked)))) ( &( "k_event_id_manager" ) ) )
  **  (event_create_frame sg_event_delete_at_oc locked )
  **  (store_dll (store_event ((pure_suspend_sched_link (((locked.(os_tasks) ).(task_desc_map) ))))) (event_list_head ((os_event_stable (sg_event_delete_at_oc)))) (app ((map (event_link_node) (prefix))) ((cons ((Build_DL_Node (original) (&((event_pre)  # "Event" ->ₛ "link")))) ((map (event_link_node) (suffix)))))) )
.

Definition _EventDelete_which_implies_wit_9 := 
(
forall (event_pre: Z) (original: EventAbs) ,
  (EventRetired event_pre (event_options (original)) (event_events (original)) )
|--
  (EventRaw event_pre )
) \/
(
forall (event_pre: Z) (original: EventAbs) ,
  (EventRetired event_pre (event_options (original)) (event_events (original)) )
|--
  (EventRaw event_pre )
).

Definition _EventDelete_which_implies_wit_9_split_goal_spatial := 
forall (event_pre: Z) (original: EventAbs) ,
  (EventRetired event_pre (event_options (original)) (event_events (original)) )
|--
  (EventRaw event_pre )
.

Module Type VC_Correct.


Axiom proof_of__EventDelete_safety_wit_1 : _EventDelete_safety_wit_1.
Axiom proof_of__EventDelete_safety_wit_2 : _EventDelete_safety_wit_2.
Axiom proof_of__EventDelete_safety_wit_3 : _EventDelete_safety_wit_3.
Axiom proof_of__EventDelete_safety_wit_4 : _EventDelete_safety_wit_4.
Axiom proof_of__EventDelete_safety_wit_5 : _EventDelete_safety_wit_5.
Axiom proof_of__EventDelete_safety_wit_6 : _EventDelete_safety_wit_6.
Axiom proof_of__EventDelete_safety_wit_7 : _EventDelete_safety_wit_7.
Axiom proof_of__EventDelete_safety_wit_8 : _EventDelete_safety_wit_8.
Axiom proof_of__EventDelete_safety_wit_9 : _EventDelete_safety_wit_9.
Axiom proof_of__EventDelete_safety_wit_10 : _EventDelete_safety_wit_10.
Axiom proof_of__EventDelete_entail_wit_1 : _EventDelete_entail_wit_1.
Axiom proof_of__EventDelete_entail_wit_2 : _EventDelete_entail_wit_2.
Axiom proof_of__EventDelete_entail_wit_3_1 : _EventDelete_entail_wit_3_1.
Axiom proof_of__EventDelete_entail_wit_3_2 : _EventDelete_entail_wit_3_2.
Axiom proof_of__EventDelete_entail_wit_4_1 : _EventDelete_entail_wit_4_1.
Axiom proof_of__EventDelete_entail_wit_4_2 : _EventDelete_entail_wit_4_2.
Axiom proof_of__EventDelete_entail_wit_4_3 : _EventDelete_entail_wit_4_3.
Axiom proof_of__EventDelete_entail_wit_4_4 : _EventDelete_entail_wit_4_4.
Axiom proof_of__EventDelete_entail_wit_5_1 : _EventDelete_entail_wit_5_1.
Axiom proof_of__EventDelete_entail_wit_5_2 : _EventDelete_entail_wit_5_2.
Axiom proof_of__EventDelete_entail_wit_6_1 : _EventDelete_entail_wit_6_1.
Axiom proof_of__EventDelete_entail_wit_6_2 : _EventDelete_entail_wit_6_2.
Axiom proof_of__EventDelete_return_wit_1 : _EventDelete_return_wit_1.
Axiom proof_of__EventDelete_return_wit_2 : _EventDelete_return_wit_2.
Axiom proof_of__EventDelete_partial_solve_wit_1_pure : _EventDelete_partial_solve_wit_1_pure.
Axiom proof_of__EventDelete_partial_solve_wit_1 : _EventDelete_partial_solve_wit_1.
Axiom proof_of__EventDelete_partial_solve_wit_2_pure : _EventDelete_partial_solve_wit_2_pure.
Axiom proof_of__EventDelete_partial_solve_wit_2 : _EventDelete_partial_solve_wit_2.
Axiom proof_of__EventDelete_partial_solve_wit_3 : _EventDelete_partial_solve_wit_3.
Axiom proof_of__EventDelete_partial_solve_wit_4_pure : _EventDelete_partial_solve_wit_4_pure.
Axiom proof_of__EventDelete_partial_solve_wit_4 : _EventDelete_partial_solve_wit_4.
Axiom proof_of__EventDelete_partial_solve_wit_5_pure : _EventDelete_partial_solve_wit_5_pure.
Axiom proof_of__EventDelete_partial_solve_wit_5 : _EventDelete_partial_solve_wit_5.
Axiom proof_of__EventDelete_partial_solve_wit_6_pure : _EventDelete_partial_solve_wit_6_pure.
Axiom proof_of__EventDelete_partial_solve_wit_6 : _EventDelete_partial_solve_wit_6.
Axiom proof_of__EventDelete_partial_solve_wit_7_pure : _EventDelete_partial_solve_wit_7_pure.
Axiom proof_of__EventDelete_partial_solve_wit_7 : _EventDelete_partial_solve_wit_7.
Axiom proof_of__EventDelete_partial_solve_wit_8_pure : _EventDelete_partial_solve_wit_8_pure.
Axiom proof_of__EventDelete_partial_solve_wit_8 : _EventDelete_partial_solve_wit_8.
Axiom proof_of__EventDelete_partial_solve_wit_9_pure : _EventDelete_partial_solve_wit_9_pure.
Axiom proof_of__EventDelete_partial_solve_wit_9 : _EventDelete_partial_solve_wit_9.
Axiom proof_of__EventDelete_partial_solve_wit_10_pure : _EventDelete_partial_solve_wit_10_pure.
Axiom proof_of__EventDelete_partial_solve_wit_10 : _EventDelete_partial_solve_wit_10.
Axiom proof_of__EventDelete_partial_solve_wit_11_pure : _EventDelete_partial_solve_wit_11_pure.
Axiom proof_of__EventDelete_partial_solve_wit_11 : _EventDelete_partial_solve_wit_11.
Axiom proof_of__EventDelete_partial_solve_wit_12_pure : _EventDelete_partial_solve_wit_12_pure.
Axiom proof_of__EventDelete_partial_solve_wit_12 : _EventDelete_partial_solve_wit_12.
Axiom proof_of__EventDelete_partial_solve_wit_13_pure : _EventDelete_partial_solve_wit_13_pure.
Axiom proof_of__EventDelete_partial_solve_wit_13 : _EventDelete_partial_solve_wit_13.
Axiom proof_of__EventDelete_partial_solve_wit_14_pure : _EventDelete_partial_solve_wit_14_pure.
Axiom proof_of__EventDelete_partial_solve_wit_14 : _EventDelete_partial_solve_wit_14.
Axiom proof_of__EventDelete_partial_solve_wit_15_pure : _EventDelete_partial_solve_wit_15_pure.
Axiom proof_of__EventDelete_partial_solve_wit_15 : _EventDelete_partial_solve_wit_15.
Axiom proof_of__EventDelete_partial_solve_wit_16 : _EventDelete_partial_solve_wit_16.
Axiom proof_of__EventDelete_partial_solve_wit_17 : _EventDelete_partial_solve_wit_17.
Axiom proof_of__EventDelete_partial_solve_wit_18_pure : _EventDelete_partial_solve_wit_18_pure.
Axiom proof_of__EventDelete_partial_solve_wit_18 : _EventDelete_partial_solve_wit_18.
Axiom proof_of__EventDelete_partial_solve_wit_19_pure : _EventDelete_partial_solve_wit_19_pure.
Axiom proof_of__EventDelete_partial_solve_wit_19 : _EventDelete_partial_solve_wit_19.
Axiom proof_of__EventDelete_partial_solve_wit_20_pure : _EventDelete_partial_solve_wit_20_pure.
Axiom proof_of__EventDelete_partial_solve_wit_20 : _EventDelete_partial_solve_wit_20.
Axiom proof_of__EventDelete_partial_solve_wit_21_pure : _EventDelete_partial_solve_wit_21_pure.
Axiom proof_of__EventDelete_partial_solve_wit_21 : _EventDelete_partial_solve_wit_21.
Axiom proof_of__EventDelete_partial_solve_wit_22 : _EventDelete_partial_solve_wit_22.
Axiom proof_of__EventDelete_partial_solve_wit_23 : _EventDelete_partial_solve_wit_23.
Axiom proof_of__EventDelete_partial_solve_wit_24 : _EventDelete_partial_solve_wit_24.
Axiom proof_of__EventDelete_partial_solve_wit_25 : _EventDelete_partial_solve_wit_25.
Axiom proof_of__EventDelete_partial_solve_wit_26_pure : _EventDelete_partial_solve_wit_26_pure.
Axiom proof_of__EventDelete_partial_solve_wit_26 : _EventDelete_partial_solve_wit_26.
Axiom proof_of__EventDelete_partial_solve_wit_27_pure : _EventDelete_partial_solve_wit_27_pure.
Axiom proof_of__EventDelete_partial_solve_wit_27 : _EventDelete_partial_solve_wit_27.
Axiom proof_of__EventDelete_partial_solve_wit_28 : _EventDelete_partial_solve_wit_28.
Axiom proof_of__EventDelete_partial_solve_wit_29 : _EventDelete_partial_solve_wit_29.
Axiom proof_of__EventDelete_partial_solve_wit_30 : _EventDelete_partial_solve_wit_30.
Axiom proof_of__EventDelete_partial_solve_wit_31 : _EventDelete_partial_solve_wit_31.
Axiom proof_of__EventDelete_partial_solve_wit_32_pure : _EventDelete_partial_solve_wit_32_pure.
Axiom proof_of__EventDelete_partial_solve_wit_32 : _EventDelete_partial_solve_wit_32.
Axiom proof_of__EventDelete_which_implies_wit_1 : _EventDelete_which_implies_wit_1.
Axiom proof_of__EventDelete_which_implies_wit_2 : _EventDelete_which_implies_wit_2.
Axiom proof_of__EventDelete_which_implies_wit_3 : _EventDelete_which_implies_wit_3.
Axiom proof_of__EventDelete_which_implies_wit_4 : _EventDelete_which_implies_wit_4.
Axiom proof_of__EventDelete_which_implies_wit_5 : _EventDelete_which_implies_wit_5.
Axiom proof_of__EventDelete_which_implies_wit_6 : _EventDelete_which_implies_wit_6.
Axiom proof_of__EventDelete_which_implies_wit_7 : _EventDelete_which_implies_wit_7.
Axiom proof_of__EventDelete_which_implies_wit_8 : _EventDelete_which_implies_wit_8.
Axiom proof_of__EventDelete_which_implies_wit_9 : _EventDelete_which_implies_wit_9.

End VC_Correct.
