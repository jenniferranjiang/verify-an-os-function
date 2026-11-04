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
Require Import CRTOS_Verify.VC.EventLinklistResumeAll_lib.
Local Open Scope sac.

(*----- Function LinklistResumeAll -----*)

Definition LinklistResumeAll_safety_wit_1 := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (PreH1 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH2 : (event_delete_guard id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  ((( &( "lock" ) )) # UInt  |->_)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  (OutsideCritical sg_event_waiters_oc before_event_waiters_oc )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition LinklistResumeAll_safety_wit_2 := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (PreH1 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH2 : (event_delete_guard id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "lock" ) )) # UInt  |-> 0)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  (OutsideCritical sg_event_waiters_oc before_event_waiters_oc )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition LinklistResumeAll_safety_wit_3 := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (PreH1 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH2 : (event_delete_guard id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  ((( &( "node" ) )) # Ptr  |->_)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # UInt  |-> 0)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  (OutsideCritical sg_event_waiters_oc before_event_waiters_oc )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition LinklistResumeAll_safety_wit_4 := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (PreH1 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH2 : (event_delete_guard id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  ((( &( "node" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # UInt  |-> 0)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  (OutsideCritical sg_event_waiters_oc before_event_waiters_oc )
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition LinklistResumeAll_safety_wit_5 := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (PreH1 : (list_pre = 0)) (PreH2 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH3 : (event_delete_guard id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |->_)
  **  ((( &( "lock" ) )) # UInt  |->_)
  **  (OutsideCritical sg_event_waiters_oc before_event_waiters_oc )
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition LinklistResumeAll_safety_wit_6 := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (remaining: (@list Z)) (current: VarGlobalState) (saved_lock: Z) (PreH1 : (list_pre <> 0)) (PreH2 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH3 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH4 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH5 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH6 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |->_)
  **  (InsideCritical sg_event_waiters_oc locked )
  **  (os_inv sg_event_waiters_oc current )
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition LinklistResumeAll_safety_wit_7 := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (next: Z) (PreH1 : (next <> list_pre)) (PreH2 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH3 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH4 : (remaining = (@nil Z))) (PreH5 : (next = list_pre)) (PreH6 : (list_pre <> 0)) (PreH7 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH8 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH9 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH10 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH11 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH12 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (os_inv sg_event_waiters_oc current )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  “ False ”
.

Definition LinklistResumeAll_safety_wit_8 := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (first: Z) (tail: (@list Z)) (next: Z) (PreH1 : (next = list_pre)) (PreH2 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH3 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH4 : (remaining = (cons (first) (tail)))) (PreH5 : (next = (sched_link_of (first)))) (PreH6 : (next <> list_pre)) (PreH7 : (list_pre <> 0)) (PreH8 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH9 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH10 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH11 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH12 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (os_inv sg_event_waiters_oc current )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  “ False ”
.

Definition LinklistResumeAll_safety_wit_9 := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH2 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH3 : (retval = target)) (PreH4 : (addr_aligned retval ALIGN_SIZE )) (PreH5 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH6 : (remaining = (cons (target) (rest)))) (PreH7 : (next = (sched_link_of (target)))) (PreH8 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH9 : (addr_aligned target ALIGN_SIZE )) (PreH10 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH11 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH12 : (os_world_wf sg_event_waiters_oc current )) (PreH13 : (task_world_wf current )) (PreH14 : (next <> list_pre)) (PreH15 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH16 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH17 : (remaining = (cons (target) (rest)))) (PreH18 : (next = (sched_link_of (target)))) (PreH19 : (next <> list_pre)) (PreH20 : (list_pre <> 0)) (PreH21 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH22 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH23 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH24 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH25 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH26 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (tdExstatus (desc)))
  **  (event_resume_exstatus_restore sg_event_waiters_oc marked target (-1) )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |-> retval)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  “ (1 <> (INT_MIN)) ”
.

Definition LinklistResumeAll_safety_wit_10 := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH2 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH3 : (retval = target)) (PreH4 : (addr_aligned retval ALIGN_SIZE )) (PreH5 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH6 : (remaining = (cons (target) (rest)))) (PreH7 : (next = (sched_link_of (target)))) (PreH8 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH9 : (addr_aligned target ALIGN_SIZE )) (PreH10 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH11 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH12 : (os_world_wf sg_event_waiters_oc current )) (PreH13 : (task_world_wf current )) (PreH14 : (next <> list_pre)) (PreH15 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH16 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH17 : (remaining = (cons (target) (rest)))) (PreH18 : (next = (sched_link_of (target)))) (PreH19 : (next <> list_pre)) (PreH20 : (list_pre <> 0)) (PreH21 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH22 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH23 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH24 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH25 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH26 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (tdExstatus (desc)))
  **  (event_resume_exstatus_restore sg_event_waiters_oc marked target (-1) )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |-> retval)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  “ (1 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 1) ”
.

Definition LinklistResumeAll_safety_wit_11 := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (next: Z) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (PreH1 : (event_delete_guard id_event_waiters_oc p_event_waiters_oc true current )) (PreH2 : (Crtos_GTrans locked current )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (current)) ( MonadErr.ret  (tt)) X_event_waiters_oc )) (PreH4 : (next = list_pre)) (PreH5 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH6 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH7 : (remaining = (@nil Z))) (PreH8 : (next = list_pre)) (PreH9 : (list_pre <> 0)) (PreH10 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH11 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH12 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH13 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH14 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (OutsideCritical sg_event_waiters_oc current )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |-> next)
|--
  “ (0 <= INT_MAX) ” 
  &&  “ ((INT_MIN) <= 0) ”
.

Definition LinklistResumeAll_entail_wit_1 := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (PreH1 : (list_pre = 0)) (PreH2 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH3 : (event_delete_guard id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  ((( &( "node" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # UInt  |-> 0)
  **  (OutsideCritical sg_event_waiters_oc before_event_waiters_oc )
|--
  “ (list_pre = 0) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_delete_guard id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc ) ”
  &&  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |->_)
  **  ((( &( "lock" ) )) # UInt  |->_)
  **  (OutsideCritical sg_event_waiters_oc before_event_waiters_oc )
.

Definition LinklistResumeAll_entail_wit_2 := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (PreH1 : (list_pre = 0)) (PreH2 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH3 : (event_delete_guard id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (OutsideCritical sg_event_waiters_oc before_event_waiters_oc )
|--
  “ (list_pre = 0) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_delete_guard id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc ) ”
  &&  (OutsideCritical sg_event_waiters_oc before_event_waiters_oc )
.

Definition LinklistResumeAll_entail_wit_3 := 
(
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (PreH1 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH2 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH3 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH4 : (list_pre <> 0)) (PreH5 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH6 : (event_delete_guard id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc )) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (os_inv sg_event_waiters_oc locked )
  **  (InsideCritical sg_event_waiters_oc locked )
  **  ((( &( "node" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
|--
  EX (remaining: (@list Z))  (current: VarGlobalState) ,
  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc ) ”
  &&  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |->_)
  **  (InsideCritical sg_event_waiters_oc locked )
  **  (os_inv sg_event_waiters_oc current )
) \/
(
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (PreH1 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH2 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH3 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH4 : (list_pre <> 0)) (PreH5 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH6 : (event_delete_guard id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc )) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  TT && emp 
|--
  EX (remaining: (@list Z)) ,
  “ (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining locked ) ” 
  &&  “ (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining locked ) ”
  &&  emp
).

Definition LinklistResumeAll_entail_wit_4_1 := 
(
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current_2: VarGlobalState) (remaining_2: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (task_id: Z) (after: VarGlobalState) (desc_2: TaskDescriptorAbs) (task: Z) (retval_2: Z) (PreH1 : (task <> 0)) (PreH2 : (get_task_with_idnode_success sg_event_waiters_oc marked task_id task )) (PreH3 : (((marked.(os_tasks) ).(task_desc_map) (task)) = (Some (desc_2)))) (PreH4 : (((desc_2.(tdSchedMember) ).(tsmStat) ) <> TSK_SUSPEND)) (PreH5 : (retval_2 = (-1))) (PreH6 : (after = marked)) (PreH7 : (remaining_2 = (cons (target) (rest)))) (PreH8 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining_2 current_2 )) (PreH9 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current_2.(os_tasks) ).(task_desc_map) )))) (current_2)))) (PreH10 : (0 <= task_id)) (PreH11 : (task_id < 65536)) (PreH12 : (get_task_with_idnode_success sg_event_waiters_oc marked task_id target )) (PreH13 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining_2 marked )) (PreH14 : (os_world_wf sg_event_waiters_oc marked )) (PreH15 : (task_world_wf marked )) (PreH16 : (((current_2.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH17 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current_2.(os_tasks) ).(task_desc_map) )))) (current_2)))) (PreH18 : (retval = target)) (PreH19 : (addr_aligned retval ALIGN_SIZE )) (PreH20 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH21 : (remaining_2 = (cons (target) (rest)))) (PreH22 : (next = (sched_link_of (target)))) (PreH23 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining_2 current_2 )) (PreH24 : (addr_aligned target ALIGN_SIZE )) (PreH25 : (((current_2.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH26 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH27 : (os_world_wf sg_event_waiters_oc current_2 )) (PreH28 : (task_world_wf current_2 )) (PreH29 : (next <> list_pre)) (PreH30 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH31 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining_2 current_2 )) (PreH32 : (remaining_2 = (cons (target) (rest)))) (PreH33 : (next = (sched_link_of (target)))) (PreH34 : (next <> list_pre)) (PreH35 : (list_pre <> 0)) (PreH36 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH37 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH38 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH39 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining_2 current_2 )) (PreH40 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining_2 current_2 )) (PreH41 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (os_inv sg_event_waiters_oc after )
  **  ((( &( "task" ) )) # Ptr  |-> retval)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  EX (remaining: (@list Z))  (current: VarGlobalState) ,
  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc ) ”
  &&  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |->_)
  **  (InsideCritical sg_event_waiters_oc locked )
  **  (os_inv sg_event_waiters_oc current )
) \/
(
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current_2: VarGlobalState) (remaining_2: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (task_id: Z) (after: VarGlobalState) (desc_2: TaskDescriptorAbs) (task: Z) (retval_2: Z) (PreH1 : (task <> 0)) (PreH2 : (get_task_with_idnode_success sg_event_waiters_oc marked task_id task )) (PreH3 : (((marked.(os_tasks) ).(task_desc_map) (task)) = (Some (desc_2)))) (PreH4 : (((desc_2.(tdSchedMember) ).(tsmStat) ) <> TSK_SUSPEND)) (PreH5 : (retval_2 = (-1))) (PreH6 : (after = marked)) (PreH7 : (remaining_2 = (cons (target) (rest)))) (PreH8 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining_2 current_2 )) (PreH9 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current_2.(os_tasks) ).(task_desc_map) )))) (current_2)))) (PreH10 : (0 <= task_id)) (PreH11 : (task_id < 65536)) (PreH12 : (get_task_with_idnode_success sg_event_waiters_oc marked task_id target )) (PreH13 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining_2 marked )) (PreH14 : (os_world_wf sg_event_waiters_oc marked )) (PreH15 : (task_world_wf marked )) (PreH16 : (((current_2.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH17 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current_2.(os_tasks) ).(task_desc_map) )))) (current_2)))) (PreH18 : (retval = target)) (PreH19 : (addr_aligned retval ALIGN_SIZE )) (PreH20 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH21 : (remaining_2 = (cons (target) (rest)))) (PreH22 : (next = (sched_link_of (target)))) (PreH23 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining_2 current_2 )) (PreH24 : (addr_aligned target ALIGN_SIZE )) (PreH25 : (((current_2.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH26 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH27 : (os_world_wf sg_event_waiters_oc current_2 )) (PreH28 : (task_world_wf current_2 )) (PreH29 : (next <> list_pre)) (PreH30 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH31 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining_2 current_2 )) (PreH32 : (remaining_2 = (cons (target) (rest)))) (PreH33 : (next = (sched_link_of (target)))) (PreH34 : (next <> list_pre)) (PreH35 : (list_pre <> 0)) (PreH36 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH37 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH38 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH39 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining_2 current_2 )) (PreH40 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining_2 current_2 )) (PreH41 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  TT && emp 
|--
  EX (remaining: (@list Z)) ,
  “ ((event_pending_head (p_event_waiters_oc)) = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current_2.(os_tasks) ).(task_desc_map) )))) (current_2)) ) ” 
  &&  “ (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current_2.(os_tasks) ).(task_desc_map) )))) (current_2)) ) ”
  &&  emp
).

Definition LinklistResumeAll_entail_wit_4_2 := 
(
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current_2: VarGlobalState) (remaining_2: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (task_id: Z) (after: VarGlobalState) (desc_2: TaskDescriptorAbs) (task: Z) (retval_2: Z) (PreH1 : (task <> 0)) (PreH2 : (get_task_with_idnode_success sg_event_waiters_oc marked task_id task )) (PreH3 : (((marked.(os_tasks) ).(task_desc_map) (task)) = (Some (desc_2)))) (PreH4 : (((desc_2.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH5 : (retval_2 = 0)) (PreH6 : (ktask_wakeup_step task desc_2 marked after )) (PreH7 : (remaining_2 = (cons (target) (rest)))) (PreH8 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining_2 current_2 )) (PreH9 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current_2.(os_tasks) ).(task_desc_map) )))) (current_2)))) (PreH10 : (0 <= task_id)) (PreH11 : (task_id < 65536)) (PreH12 : (get_task_with_idnode_success sg_event_waiters_oc marked task_id target )) (PreH13 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining_2 marked )) (PreH14 : (os_world_wf sg_event_waiters_oc marked )) (PreH15 : (task_world_wf marked )) (PreH16 : (((current_2.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH17 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current_2.(os_tasks) ).(task_desc_map) )))) (current_2)))) (PreH18 : (retval = target)) (PreH19 : (addr_aligned retval ALIGN_SIZE )) (PreH20 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH21 : (remaining_2 = (cons (target) (rest)))) (PreH22 : (next = (sched_link_of (target)))) (PreH23 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining_2 current_2 )) (PreH24 : (addr_aligned target ALIGN_SIZE )) (PreH25 : (((current_2.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH26 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH27 : (os_world_wf sg_event_waiters_oc current_2 )) (PreH28 : (task_world_wf current_2 )) (PreH29 : (next <> list_pre)) (PreH30 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH31 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining_2 current_2 )) (PreH32 : (remaining_2 = (cons (target) (rest)))) (PreH33 : (next = (sched_link_of (target)))) (PreH34 : (next <> list_pre)) (PreH35 : (list_pre <> 0)) (PreH36 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH37 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH38 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH39 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining_2 current_2 )) (PreH40 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining_2 current_2 )) (PreH41 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (os_inv sg_event_waiters_oc after )
  **  ((( &( "task" ) )) # Ptr  |-> retval)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  EX (remaining: (@list Z))  (current: VarGlobalState) ,
  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc ) ”
  &&  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |->_)
  **  (InsideCritical sg_event_waiters_oc locked )
  **  (os_inv sg_event_waiters_oc current )
) \/
(
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current_2: VarGlobalState) (remaining_2: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (task_id: Z) (after: VarGlobalState) (desc_2: TaskDescriptorAbs) (task: Z) (retval_2: Z) (PreH1 : (task <> 0)) (PreH2 : (get_task_with_idnode_success sg_event_waiters_oc marked task_id task )) (PreH3 : (((marked.(os_tasks) ).(task_desc_map) (task)) = (Some (desc_2)))) (PreH4 : (((desc_2.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH5 : (retval_2 = 0)) (PreH6 : (ktask_wakeup_step task desc_2 marked after )) (PreH7 : (remaining_2 = (cons (target) (rest)))) (PreH8 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining_2 current_2 )) (PreH9 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current_2.(os_tasks) ).(task_desc_map) )))) (current_2)))) (PreH10 : (0 <= task_id)) (PreH11 : (task_id < 65536)) (PreH12 : (get_task_with_idnode_success sg_event_waiters_oc marked task_id target )) (PreH13 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining_2 marked )) (PreH14 : (os_world_wf sg_event_waiters_oc marked )) (PreH15 : (task_world_wf marked )) (PreH16 : (((current_2.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH17 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current_2.(os_tasks) ).(task_desc_map) )))) (current_2)))) (PreH18 : (retval = target)) (PreH19 : (addr_aligned retval ALIGN_SIZE )) (PreH20 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH21 : (remaining_2 = (cons (target) (rest)))) (PreH22 : (next = (sched_link_of (target)))) (PreH23 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining_2 current_2 )) (PreH24 : (addr_aligned target ALIGN_SIZE )) (PreH25 : (((current_2.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH26 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH27 : (os_world_wf sg_event_waiters_oc current_2 )) (PreH28 : (task_world_wf current_2 )) (PreH29 : (next <> list_pre)) (PreH30 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH31 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining_2 current_2 )) (PreH32 : (remaining_2 = (cons (target) (rest)))) (PreH33 : (next = (sched_link_of (target)))) (PreH34 : (next <> list_pre)) (PreH35 : (list_pre <> 0)) (PreH36 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH37 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH38 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH39 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining_2 current_2 )) (PreH40 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining_2 current_2 )) (PreH41 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  TT && emp 
|--
  EX (remaining: (@list Z)) ,
  “ ((event_pending_head (p_event_waiters_oc)) = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining after ) ” 
  &&  “ (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining after ) ”
  &&  emp
).

Definition LinklistResumeAll_return_wit_1 := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (next: Z) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (event_delete_guard id_event_waiters_oc p_event_waiters_oc true current )) (PreH2 : (Crtos_GTrans locked current )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (current)) ( MonadErr.ret  (tt)) X_event_waiters_oc )) (PreH4 : (next = list_pre)) (PreH5 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH6 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH7 : (remaining = (@nil Z))) (PreH8 : (next = list_pre)) (PreH9 : (list_pre <> 0)) (PreH10 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH11 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH12 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH13 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH14 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (OutsideCritical sg_event_waiters_oc current )
|--
  EX (after: VarGlobalState) ,
  “ (0 = 0) ” 
  &&  “ (event_delete_guard id_event_waiters_oc p_event_waiters_oc true after ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (after)) ( MonadErr.ret  (tt)) X_event_waiters_oc ) ”
  &&  (OutsideCritical sg_event_waiters_oc after )
.

Definition LinklistResumeAll_partial_solve_wit_1_pure := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (PreH1 : (list_pre <> 0)) (PreH2 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH3 : (event_delete_guard id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  ((( &( "node" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # UInt  |-> 0)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  (OutsideCritical sg_event_waiters_oc before_event_waiters_oc )
|--
  “ (event_delete_guard id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc ) ”
.

Definition LinklistResumeAll_partial_solve_wit_1_aux := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (PreH1 : (list_pre <> 0)) (PreH2 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH3 : (event_delete_guard id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc )) (PreH4 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (OutsideCritical sg_event_waiters_oc before_event_waiters_oc )
|--
  “ (event_delete_guard id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc ) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_delete_guard id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc ) ”
  &&  (OutsideCritical sg_event_waiters_oc before_event_waiters_oc )
.

Definition LinklistResumeAll_partial_solve_wit_1 := LinklistResumeAll_partial_solve_wit_1_pure -> LinklistResumeAll_partial_solve_wit_1_aux.

Definition LinklistResumeAll_partial_solve_wit_2_pure := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (retval: Z) (locked: VarGlobalState) (PreH1 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH2 : (list_pre <> 0)) (PreH3 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH4 : (event_delete_guard id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc )) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (InsideCritical sg_event_waiters_oc locked )
  **  (os_inv sg_event_waiters_oc locked )
  **  ((( &( "node" ) )) # Ptr  |-> 0)
  **  ((( &( "task" ) )) # Ptr  |-> 0)
  **  ((( &( "lock" ) )) # UInt  |-> (unsigned_last_nbits (retval) (32)))
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
|--
  “ (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked ) ”
.

Definition LinklistResumeAll_partial_solve_wit_2_aux := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (PreH1 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH2 : (list_pre <> 0)) (PreH3 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH4 : (event_delete_guard id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc )) (PreH5 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (InsideCritical sg_event_waiters_oc locked )
  **  (os_inv sg_event_waiters_oc locked )
|--
  “ (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked ) ” 
  &&  “ (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked ) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_delete_guard id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc ) ”
  &&  (os_inv sg_event_waiters_oc locked )
  **  (InsideCritical sg_event_waiters_oc locked )
.

Definition LinklistResumeAll_partial_solve_wit_2 := LinklistResumeAll_partial_solve_wit_2_pure -> LinklistResumeAll_partial_solve_wit_2_aux.

Definition LinklistResumeAll_partial_solve_wit_3_pure := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (PreH1 : (list_pre <> 0)) (PreH2 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH3 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH4 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH5 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH6 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |->_)
  **  (InsideCritical sg_event_waiters_oc locked )
  **  (os_inv sg_event_waiters_oc current )
|--
  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ”
.

Definition LinklistResumeAll_partial_solve_wit_3_aux := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (list_pre <> 0)) (PreH2 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH3 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH4 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH5 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH6 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH7 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (InsideCritical sg_event_waiters_oc locked )
  **  (os_inv sg_event_waiters_oc current )
|--
  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc ) ”
  &&  (os_inv sg_event_waiters_oc current )
  **  (InsideCritical sg_event_waiters_oc locked )
.

Definition LinklistResumeAll_partial_solve_wit_3 := LinklistResumeAll_partial_solve_wit_3_pure -> LinklistResumeAll_partial_solve_wit_3_aux.

Definition LinklistResumeAll_partial_solve_wit_4 := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (first: Z) (tail: (@list Z)) (next: Z) (PreH1 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH2 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH3 : (remaining = (cons (first) (tail)))) (PreH4 : (next = (sched_link_of (first)))) (PreH5 : (next <> list_pre)) (PreH6 : (list_pre <> 0)) (PreH7 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH8 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH9 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH10 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH11 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH12 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (event_resume_next_restore sg_event_waiters_oc current list_pre next )
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (remaining = (cons (first) (tail))) ” 
  &&  “ (next = (sched_link_of (first))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc ) ”
  &&  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (event_resume_next_restore sg_event_waiters_oc current list_pre next )
  **  (InsideCritical sg_event_waiters_oc locked )
.

Definition LinklistResumeAll_partial_solve_wit_5 := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (PreH1 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH2 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH3 : (remaining = (@nil Z))) (PreH4 : (next = list_pre)) (PreH5 : (list_pre <> 0)) (PreH6 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH7 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH8 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH9 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH10 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH11 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (event_resume_next_restore sg_event_waiters_oc current list_pre next )
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (remaining = (@nil Z)) ” 
  &&  “ (next = list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc ) ”
  &&  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (event_resume_next_restore sg_event_waiters_oc current list_pre next )
  **  (InsideCritical sg_event_waiters_oc locked )
.

Definition LinklistResumeAll_partial_solve_wit_6_pure := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (next: Z) (target: Z) (rest: (@list Z)) (PreH1 : (next <> list_pre)) (PreH2 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH3 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH4 : (remaining = (cons (target) (rest)))) (PreH5 : (next = (sched_link_of (target)))) (PreH6 : (next <> list_pre)) (PreH7 : (list_pre <> 0)) (PreH8 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH9 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH10 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH11 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH12 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (os_inv sg_event_waiters_oc current )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ”
.

Definition LinklistResumeAll_partial_solve_wit_6_aux := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (PreH1 : (next <> list_pre)) (PreH2 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH3 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH4 : (remaining = (cons (target) (rest)))) (PreH5 : (next = (sched_link_of (target)))) (PreH6 : (next <> list_pre)) (PreH7 : (list_pre <> 0)) (PreH8 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH9 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH10 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH11 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH12 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH13 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (os_inv sg_event_waiters_oc current )
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc ) ”
  &&  (os_inv sg_event_waiters_oc current )
  **  (InsideCritical sg_event_waiters_oc locked )
.

Definition LinklistResumeAll_partial_solve_wit_6 := LinklistResumeAll_partial_solve_wit_6_pure -> LinklistResumeAll_partial_solve_wit_6_aux.

Definition LinklistResumeAll_partial_solve_wit_7_pure := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (next = (sched_link_of (target)))) (PreH3 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH4 : (addr_aligned target ALIGN_SIZE )) (PreH5 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH6 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH7 : (os_world_wf sg_event_waiters_oc current )) (PreH8 : (task_world_wf current )) (PreH9 : (next <> list_pre)) (PreH10 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH11 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH12 : (remaining = (cons (target) (rest)))) (PreH13 : (next = (sched_link_of (target)))) (PreH14 : (next <> list_pre)) (PreH15 : (list_pre <> 0)) (PreH16 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH17 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH18 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH19 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH20 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (os_inv sg_event_waiters_oc current )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (next = (sched_link_of (target))) ”
.

Definition LinklistResumeAll_partial_solve_wit_7_aux := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (next = (sched_link_of (target)))) (PreH3 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH4 : (addr_aligned target ALIGN_SIZE )) (PreH5 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH6 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH7 : (os_world_wf sg_event_waiters_oc current )) (PreH8 : (task_world_wf current )) (PreH9 : (next <> list_pre)) (PreH10 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH11 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH12 : (remaining = (cons (target) (rest)))) (PreH13 : (next = (sched_link_of (target)))) (PreH14 : (next <> list_pre)) (PreH15 : (list_pre <> 0)) (PreH16 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH17 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH18 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH19 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH20 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH21 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (os_inv sg_event_waiters_oc current )
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (os_world_wf sg_event_waiters_oc current ) ” 
  &&  “ (task_world_wf current ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc ) ”
  &&  (os_inv sg_event_waiters_oc current )
  **  (InsideCritical sg_event_waiters_oc locked )
.

Definition LinklistResumeAll_partial_solve_wit_7 := LinklistResumeAll_partial_solve_wit_7_pure -> LinklistResumeAll_partial_solve_wit_7_aux.

Definition LinklistResumeAll_partial_solve_wit_8_pure := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (PreH1 : (retval = target)) (PreH2 : (addr_aligned retval ALIGN_SIZE )) (PreH3 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH4 : (remaining = (cons (target) (rest)))) (PreH5 : (next = (sched_link_of (target)))) (PreH6 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH7 : (addr_aligned target ALIGN_SIZE )) (PreH8 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH9 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH10 : (os_world_wf sg_event_waiters_oc current )) (PreH11 : (task_world_wf current )) (PreH12 : (next <> list_pre)) (PreH13 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH14 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH15 : (remaining = (cons (target) (rest)))) (PreH16 : (next = (sched_link_of (target)))) (PreH17 : (next <> list_pre)) (PreH18 : (list_pre <> 0)) (PreH19 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH20 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH21 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH22 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH23 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH24 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (os_inv sg_event_waiters_oc current )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |-> retval)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ”
.

Definition LinklistResumeAll_partial_solve_wit_8_aux := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (PreH1 : (retval = target)) (PreH2 : (addr_aligned retval ALIGN_SIZE )) (PreH3 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH4 : (remaining = (cons (target) (rest)))) (PreH5 : (next = (sched_link_of (target)))) (PreH6 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH7 : (addr_aligned target ALIGN_SIZE )) (PreH8 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH9 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH10 : (os_world_wf sg_event_waiters_oc current )) (PreH11 : (task_world_wf current )) (PreH12 : (next <> list_pre)) (PreH13 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH14 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH15 : (remaining = (cons (target) (rest)))) (PreH16 : (next = (sched_link_of (target)))) (PreH17 : (next <> list_pre)) (PreH18 : (list_pre <> 0)) (PreH19 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH20 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH21 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH22 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH23 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH24 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (os_inv sg_event_waiters_oc current )
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (retval = target) ” 
  &&  “ (addr_aligned retval ALIGN_SIZE ) ” 
  &&  “ (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (os_world_wf sg_event_waiters_oc current ) ” 
  &&  “ (task_world_wf current ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc ) ”
  &&  (os_inv sg_event_waiters_oc current )
  **  (InsideCritical sg_event_waiters_oc locked )
.

Definition LinklistResumeAll_partial_solve_wit_8 := LinklistResumeAll_partial_solve_wit_8_pure -> LinklistResumeAll_partial_solve_wit_8_aux.

Definition LinklistResumeAll_partial_solve_wit_9 := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH2 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH3 : (retval = target)) (PreH4 : (addr_aligned retval ALIGN_SIZE )) (PreH5 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH6 : (remaining = (cons (target) (rest)))) (PreH7 : (next = (sched_link_of (target)))) (PreH8 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH9 : (addr_aligned target ALIGN_SIZE )) (PreH10 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH11 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH12 : (os_world_wf sg_event_waiters_oc current )) (PreH13 : (task_world_wf current )) (PreH14 : (next <> list_pre)) (PreH15 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH16 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH17 : (remaining = (cons (target) (rest)))) (PreH18 : (next = (sched_link_of (target)))) (PreH19 : (next <> list_pre)) (PreH20 : (list_pre <> 0)) (PreH21 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH22 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH23 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH24 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH25 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH26 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (tdExstatus (desc)))
  **  (event_resume_exstatus_restore sg_event_waiters_oc marked target (-1) )
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (retval = target) ” 
  &&  “ (addr_aligned retval ALIGN_SIZE ) ” 
  &&  “ (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (os_world_wf sg_event_waiters_oc current ) ” 
  &&  “ (task_world_wf current ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc ) ”
  &&  ((&((retval)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |->_)
  **  (event_resume_exstatus_restore sg_event_waiters_oc marked target (-1) )
  **  (InsideCritical sg_event_waiters_oc locked )
.

Definition LinklistResumeAll_partial_solve_wit_10 := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH2 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH3 : (retval = target)) (PreH4 : (addr_aligned retval ALIGN_SIZE )) (PreH5 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH6 : (remaining = (cons (target) (rest)))) (PreH7 : (next = (sched_link_of (target)))) (PreH8 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH9 : (addr_aligned target ALIGN_SIZE )) (PreH10 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH11 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH12 : (os_world_wf sg_event_waiters_oc current )) (PreH13 : (task_world_wf current )) (PreH14 : (next <> list_pre)) (PreH15 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH16 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH17 : (remaining = (cons (target) (rest)))) (PreH18 : (next = (sched_link_of (target)))) (PreH19 : (next <> list_pre)) (PreH20 : (list_pre <> 0)) (PreH21 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH22 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH23 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH24 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH25 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH26 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  ((&((retval)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (-1))
  **  (event_resume_exstatus_restore sg_event_waiters_oc marked target (-1) )
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (retval = target) ” 
  &&  “ (addr_aligned retval ALIGN_SIZE ) ” 
  &&  “ (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (os_world_wf sg_event_waiters_oc current ) ” 
  &&  “ (task_world_wf current ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc ) ”
  &&  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (-1))
  **  (event_resume_exstatus_restore sg_event_waiters_oc marked target (-1) )
  **  (InsideCritical sg_event_waiters_oc locked )
.

Definition LinklistResumeAll_partial_solve_wit_11_pure := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH2 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH3 : (retval = target)) (PreH4 : (addr_aligned retval ALIGN_SIZE )) (PreH5 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH6 : (remaining = (cons (target) (rest)))) (PreH7 : (next = (sched_link_of (target)))) (PreH8 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH9 : (addr_aligned target ALIGN_SIZE )) (PreH10 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH11 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH12 : (os_world_wf sg_event_waiters_oc current )) (PreH13 : (task_world_wf current )) (PreH14 : (next <> list_pre)) (PreH15 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH16 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH17 : (remaining = (cons (target) (rest)))) (PreH18 : (next = (sched_link_of (target)))) (PreH19 : (next <> list_pre)) (PreH20 : (list_pre <> 0)) (PreH21 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH22 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH23 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH24 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH25 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH26 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (os_inv sg_event_waiters_oc marked )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |-> retval)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ”
.

Definition LinklistResumeAll_partial_solve_wit_11_aux := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH2 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH3 : (retval = target)) (PreH4 : (addr_aligned retval ALIGN_SIZE )) (PreH5 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH6 : (remaining = (cons (target) (rest)))) (PreH7 : (next = (sched_link_of (target)))) (PreH8 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH9 : (addr_aligned target ALIGN_SIZE )) (PreH10 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH11 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH12 : (os_world_wf sg_event_waiters_oc current )) (PreH13 : (task_world_wf current )) (PreH14 : (next <> list_pre)) (PreH15 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH16 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH17 : (remaining = (cons (target) (rest)))) (PreH18 : (next = (sched_link_of (target)))) (PreH19 : (next <> list_pre)) (PreH20 : (list_pre <> 0)) (PreH21 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH22 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH23 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH24 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH25 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH26 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (os_inv sg_event_waiters_oc marked )
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (retval = target) ” 
  &&  “ (addr_aligned retval ALIGN_SIZE ) ” 
  &&  “ (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (os_world_wf sg_event_waiters_oc current ) ” 
  &&  “ (task_world_wf current ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc ) ”
  &&  (os_inv sg_event_waiters_oc marked )
  **  (InsideCritical sg_event_waiters_oc locked )
.

Definition LinklistResumeAll_partial_solve_wit_11 := LinklistResumeAll_partial_solve_wit_11_pure -> LinklistResumeAll_partial_solve_wit_11_aux.

Definition LinklistResumeAll_partial_solve_wit_12 := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (task_id: Z) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH3 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH4 : (0 <= task_id)) (PreH5 : (task_id < 65536)) (PreH6 : (get_task_with_idnode_success sg_event_waiters_oc marked task_id target )) (PreH7 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining marked )) (PreH8 : (os_world_wf sg_event_waiters_oc marked )) (PreH9 : (task_world_wf marked )) (PreH10 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH11 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH12 : (retval = target)) (PreH13 : (addr_aligned retval ALIGN_SIZE )) (PreH14 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH15 : (remaining = (cons (target) (rest)))) (PreH16 : (next = (sched_link_of (target)))) (PreH17 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH18 : (addr_aligned target ALIGN_SIZE )) (PreH19 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH20 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH21 : (os_world_wf sg_event_waiters_oc current )) (PreH22 : (task_world_wf current )) (PreH23 : (next <> list_pre)) (PreH24 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH25 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH26 : (remaining = (cons (target) (rest)))) (PreH27 : (next = (sched_link_of (target)))) (PreH28 : (next <> list_pre)) (PreH29 : (list_pre <> 0)) (PreH30 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH31 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH32 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH33 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH34 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH35 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (event_resume_id_restore sg_event_waiters_oc marked target task_id )
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (0 <= task_id) ” 
  &&  “ (task_id < 65536) ” 
  &&  “ (get_task_with_idnode_success sg_event_waiters_oc marked task_id target ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining marked ) ” 
  &&  “ (os_world_wf sg_event_waiters_oc marked ) ” 
  &&  “ (task_world_wf marked ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (retval = target) ” 
  &&  “ (addr_aligned retval ALIGN_SIZE ) ” 
  &&  “ (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (os_world_wf sg_event_waiters_oc current ) ” 
  &&  “ (task_world_wf current ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc ) ”
  &&  ((&((retval)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (event_resume_id_restore sg_event_waiters_oc marked target task_id )
  **  (InsideCritical sg_event_waiters_oc locked )
.

Definition LinklistResumeAll_partial_solve_wit_13 := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (task_id: Z) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH3 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH4 : (0 <= task_id)) (PreH5 : (task_id < 65536)) (PreH6 : (get_task_with_idnode_success sg_event_waiters_oc marked task_id target )) (PreH7 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining marked )) (PreH8 : (os_world_wf sg_event_waiters_oc marked )) (PreH9 : (task_world_wf marked )) (PreH10 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH11 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH12 : (retval = target)) (PreH13 : (addr_aligned retval ALIGN_SIZE )) (PreH14 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH15 : (remaining = (cons (target) (rest)))) (PreH16 : (next = (sched_link_of (target)))) (PreH17 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH18 : (addr_aligned target ALIGN_SIZE )) (PreH19 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH20 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH21 : (os_world_wf sg_event_waiters_oc current )) (PreH22 : (task_world_wf current )) (PreH23 : (next <> list_pre)) (PreH24 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH25 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH26 : (remaining = (cons (target) (rest)))) (PreH27 : (next = (sched_link_of (target)))) (PreH28 : (next <> list_pre)) (PreH29 : (list_pre <> 0)) (PreH30 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH31 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH32 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH33 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH34 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH35 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  ((&((retval)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (event_resume_id_restore sg_event_waiters_oc marked target task_id )
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (0 <= task_id) ” 
  &&  “ (task_id < 65536) ” 
  &&  “ (get_task_with_idnode_success sg_event_waiters_oc marked task_id target ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining marked ) ” 
  &&  “ (os_world_wf sg_event_waiters_oc marked ) ” 
  &&  “ (task_world_wf marked ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (retval = target) ” 
  &&  “ (addr_aligned retval ALIGN_SIZE ) ” 
  &&  “ (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (os_world_wf sg_event_waiters_oc current ) ” 
  &&  “ (task_world_wf current ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc ) ”
  &&  ((&((target)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (event_resume_id_restore sg_event_waiters_oc marked target task_id )
  **  (InsideCritical sg_event_waiters_oc locked )
.

Definition LinklistResumeAll_partial_solve_wit_14_pure := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (task_id: Z) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH3 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH4 : (0 <= task_id)) (PreH5 : (task_id < 65536)) (PreH6 : (get_task_with_idnode_success sg_event_waiters_oc marked task_id target )) (PreH7 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining marked )) (PreH8 : (os_world_wf sg_event_waiters_oc marked )) (PreH9 : (task_world_wf marked )) (PreH10 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH11 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH12 : (retval = target)) (PreH13 : (addr_aligned retval ALIGN_SIZE )) (PreH14 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH15 : (remaining = (cons (target) (rest)))) (PreH16 : (next = (sched_link_of (target)))) (PreH17 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH18 : (addr_aligned target ALIGN_SIZE )) (PreH19 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH20 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH21 : (os_world_wf sg_event_waiters_oc current )) (PreH22 : (task_world_wf current )) (PreH23 : (next <> list_pre)) (PreH24 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH25 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH26 : (remaining = (cons (target) (rest)))) (PreH27 : (next = (sched_link_of (target)))) (PreH28 : (next <> list_pre)) (PreH29 : (list_pre <> 0)) (PreH30 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH31 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH32 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH33 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH34 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH35 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (os_inv sg_event_waiters_oc marked )
  **  ((( &( "resume_task_id" ) )) # Int  |-> task_id)
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |-> retval)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  “ (task_id < 65536) ”
.

Definition LinklistResumeAll_partial_solve_wit_14_aux := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (retval: Z) (marked: VarGlobalState) (task_id: Z) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH3 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH4 : (0 <= task_id)) (PreH5 : (task_id < 65536)) (PreH6 : (get_task_with_idnode_success sg_event_waiters_oc marked task_id target )) (PreH7 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining marked )) (PreH8 : (os_world_wf sg_event_waiters_oc marked )) (PreH9 : (task_world_wf marked )) (PreH10 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH11 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) (PreH12 : (retval = target)) (PreH13 : (addr_aligned retval ALIGN_SIZE )) (PreH14 : (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link"))) (PreH15 : (remaining = (cons (target) (rest)))) (PreH16 : (next = (sched_link_of (target)))) (PreH17 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH18 : (addr_aligned target ALIGN_SIZE )) (PreH19 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) (PreH20 : (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND)) (PreH21 : (os_world_wf sg_event_waiters_oc current )) (PreH22 : (task_world_wf current )) (PreH23 : (next <> list_pre)) (PreH24 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH25 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH26 : (remaining = (cons (target) (rest)))) (PreH27 : (next = (sched_link_of (target)))) (PreH28 : (next <> list_pre)) (PreH29 : (list_pre <> 0)) (PreH30 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH31 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH32 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH33 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH34 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH35 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (os_inv sg_event_waiters_oc marked )
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  “ (task_id < 65536) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (0 <= task_id) ” 
  &&  “ (task_id < 65536) ” 
  &&  “ (get_task_with_idnode_success sg_event_waiters_oc marked task_id target ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining marked ) ” 
  &&  “ (os_world_wf sg_event_waiters_oc marked ) ” 
  &&  “ (task_world_wf marked ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (retval = target) ” 
  &&  “ (addr_aligned retval ALIGN_SIZE ) ” 
  &&  “ (next = &((retval)  # "TaskDescriptor" ->ₛ "task_dync_sched_member" .ₛ "sched_link")) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (os_world_wf sg_event_waiters_oc current ) ” 
  &&  “ (task_world_wf current ) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (next <> list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc ) ”
  &&  (os_inv sg_event_waiters_oc marked )
  **  (InsideCritical sg_event_waiters_oc locked )
.

Definition LinklistResumeAll_partial_solve_wit_14 := LinklistResumeAll_partial_solve_wit_14_pure -> LinklistResumeAll_partial_solve_wit_14_aux.

Definition LinklistResumeAll_partial_solve_wit_15_pure := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (next: Z) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (PreH1 : (next = list_pre)) (PreH2 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH3 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH4 : (remaining = (@nil Z))) (PreH5 : (next = list_pre)) (PreH6 : (list_pre <> 0)) (PreH7 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH8 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH9 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH10 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH11 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH12 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (os_inv sg_event_waiters_oc current )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current ) ” 
  &&  “ (remaining = (@nil Z)) ” 
  &&  “ (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc ) ”
.

Definition LinklistResumeAll_partial_solve_wit_15_aux := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (next: Z) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (next = list_pre)) (PreH2 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH3 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH4 : (remaining = (@nil Z))) (PreH5 : (next = list_pre)) (PreH6 : (list_pre <> 0)) (PreH7 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH8 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH9 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH10 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH11 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH12 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (os_inv sg_event_waiters_oc current )
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current ) ” 
  &&  “ (remaining = (@nil Z)) ” 
  &&  “ (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc ) ” 
  &&  “ (next = list_pre) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (remaining = (@nil Z)) ” 
  &&  “ (next = list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc ) ”
  &&  (os_inv sg_event_waiters_oc current )
  **  (InsideCritical sg_event_waiters_oc locked )
.

Definition LinklistResumeAll_partial_solve_wit_15 := LinklistResumeAll_partial_solve_wit_15_pure -> LinklistResumeAll_partial_solve_wit_15_aux.

Definition LinklistResumeAll_partial_solve_wit_16_pure := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (next: Z) (current: VarGlobalState) (remaining: (@list Z)) (saved_lock: Z) (PreH1 : (event_delete_guard id_event_waiters_oc p_event_waiters_oc true current )) (PreH2 : (Crtos_GTrans locked current )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (current)) ( MonadErr.ret  (tt)) X_event_waiters_oc )) (PreH4 : (next = list_pre)) (PreH5 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH6 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH7 : (remaining = (@nil Z))) (PreH8 : (next = list_pre)) (PreH9 : (list_pre <> 0)) (PreH10 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH11 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH12 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH13 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH14 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (os_inv sg_event_waiters_oc current )
  **  ((( &( "list" ) )) # Ptr  |-> list_pre)
  **  ((( &( "lock" ) )) # UInt  |-> saved_lock)
  **  ((( &( "task" ) )) # Ptr  |->_)
  **  ((( &( "node" ) )) # Ptr  |-> next)
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  “ (Crtos_GTrans locked current ) ”
.

Definition LinklistResumeAll_partial_solve_wit_16_aux := 
forall (list_pre: Z) (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (next: Z) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (event_delete_guard id_event_waiters_oc p_event_waiters_oc true current )) (PreH2 : (Crtos_GTrans locked current )) (PreH3 : ( monadesafe_lib.safeExec  (LastSeen (current)) ( MonadErr.ret  (tt)) X_event_waiters_oc )) (PreH4 : (next = list_pre)) (PreH5 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH6 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH7 : (remaining = (@nil Z))) (PreH8 : (next = list_pre)) (PreH9 : (list_pre <> 0)) (PreH10 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH11 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH12 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH13 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH14 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH15 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (os_inv sg_event_waiters_oc current )
  **  (InsideCritical sg_event_waiters_oc locked )
|--
  “ (Crtos_GTrans locked current ) ” 
  &&  “ (event_delete_guard id_event_waiters_oc p_event_waiters_oc true current ) ” 
  &&  “ (Crtos_GTrans locked current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (current)) ( MonadErr.ret  (tt)) X_event_waiters_oc ) ” 
  &&  “ (next = list_pre) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (remaining = (@nil Z)) ” 
  &&  “ (next = list_pre) ” 
  &&  “ (list_pre <> 0) ” 
  &&  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc ) ”
  &&  (InsideCritical sg_event_waiters_oc locked )
  **  (os_inv sg_event_waiters_oc current )
.

Definition LinklistResumeAll_partial_solve_wit_16 := LinklistResumeAll_partial_solve_wit_16_pure -> LinklistResumeAll_partial_solve_wit_16_aux.

Definition LinklistResumeAll_which_implies_wit_1 := 
(
forall (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (PreH1 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) ,
  (os_inv sg_event_waiters_oc locked )
|--
  EX (waiting: (@list Z)) ,
  “ (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked ) ”
  &&  (os_inv sg_event_waiters_oc locked )
) \/
(
forall (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (locked: VarGlobalState) (PreH1 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) ,
  TT && emp 
|--
  EX (waiting: (@list Z)) ,
  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked ) ”
  &&  emp
).

Definition LinklistResumeAll_which_implies_wit_2 := 
forall (list_pre: Z) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (sg_event_waiters_oc: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (list_pre = (event_pending_head (p_event_waiters_oc)))) (PreH2 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) ,
  (os_inv sg_event_waiters_oc current )
|--
  (EX (next: Z) ,
  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (remaining = (@nil Z)) ” 
  &&  “ (next = list_pre) ”
  &&  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (event_resume_next_restore sg_event_waiters_oc current list_pre next ))
  ||
  (EX (next: Z)  (first: Z)  (tail: (@list Z)) ,
  “ (list_pre = (event_pending_head (p_event_waiters_oc))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (remaining = (cons (first) (tail))) ” 
  &&  “ (next = (sched_link_of (first))) ” 
  &&  “ (next <> list_pre) ”
  &&  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (event_resume_next_restore sg_event_waiters_oc current list_pre next ))
.

Definition LinklistResumeAll_which_implies_wit_3 := 
(
forall (list_pre: Z) (sg_event_waiters_oc: StableGlobalState) (current: VarGlobalState) (next: Z) ,
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (event_resume_next_restore sg_event_waiters_oc current list_pre next )
|--
  (os_inv sg_event_waiters_oc current )
) \/
(
forall (list_pre: Z) (sg_event_waiters_oc: StableGlobalState) (current: VarGlobalState) (next: Z) ,
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (event_resume_next_restore sg_event_waiters_oc current list_pre next )
|--
  (os_inv sg_event_waiters_oc current )
).

Definition LinklistResumeAll_which_implies_wit_3_split_goal_spatial := 
forall (list_pre: Z) (sg_event_waiters_oc: StableGlobalState) (current: VarGlobalState) (next: Z) ,
  ((&((list_pre)  # "SysDoubleLinklistNode" ->ₛ "node_next")) # Ptr  |-> next)
  **  (event_resume_next_restore sg_event_waiters_oc current list_pre next )
|--
  (os_inv sg_event_waiters_oc current )
.

Definition LinklistResumeAll_which_implies_wit_4 := 
(
forall (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (sg_event_waiters_oc: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (next = (sched_link_of (target)))) (PreH3 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) ,
  (os_inv sg_event_waiters_oc current )
|--
  EX (desc: TaskDescriptorAbs) ,
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (next = (sched_link_of (target))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (os_world_wf sg_event_waiters_oc current ) ” 
  &&  “ (task_world_wf current ) ”
  &&  (os_inv sg_event_waiters_oc current )
) \/
(
forall (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (sg_event_waiters_oc: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (next: Z) (target: Z) (rest: (@list Z)) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (next = (sched_link_of (target)))) (PreH3 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) ,
  TT && emp 
|--
  EX (desc: TaskDescriptorAbs) ,
  “ (addr_aligned target ALIGN_SIZE ) ” 
  &&  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (os_world_wf sg_event_waiters_oc current ) ” 
  &&  “ (task_world_wf current ) ”
  &&  emp
).

Definition LinklistResumeAll_which_implies_wit_5 := 
(
forall (sg_event_waiters_oc: StableGlobalState) (current: VarGlobalState) (target: Z) (desc: TaskDescriptorAbs) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) ,
  (os_inv sg_event_waiters_oc current )
|--
  EX (marked: VarGlobalState) ,
  “ (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc))) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ”
  &&  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (tdExstatus (desc)))
  **  (event_resume_exstatus_restore sg_event_waiters_oc marked target (-1) )
) \/
(
forall (sg_event_waiters_oc: StableGlobalState) (current: VarGlobalState) (target: Z) (desc: TaskDescriptorAbs) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) ,
  (os_inv sg_event_waiters_oc current )
|--
  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (tdExstatus (desc)))
  **  (event_resume_exstatus_restore sg_event_waiters_oc (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)) target (-1) )
).

Definition LinklistResumeAll_which_implies_wit_5_split_goal_spatial := 
forall (sg_event_waiters_oc: StableGlobalState) (current: VarGlobalState) (target: Z) (desc: TaskDescriptorAbs) (PreH1 : (((current.(os_tasks) ).(task_desc_map) (target)) = (Some (desc)))) ,
  (os_inv sg_event_waiters_oc current )
|--
  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (tdExstatus (desc)))
  **  (event_resume_exstatus_restore sg_event_waiters_oc (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)) target (-1) )
.

Definition LinklistResumeAll_which_implies_wit_6 := 
(
forall (sg_event_waiters_oc: StableGlobalState) (target: Z) (marked: VarGlobalState) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (-1))
  **  (event_resume_exstatus_restore sg_event_waiters_oc marked target (-1) )
|--
  (os_inv sg_event_waiters_oc marked )
) \/
(
forall (sg_event_waiters_oc: StableGlobalState) (target: Z) (marked: VarGlobalState) (PreH1 : ((-1) <= INT_MAX)) (PreH2 : ((-1) >= INT_MIN)) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (-1))
  **  (event_resume_exstatus_restore sg_event_waiters_oc marked target (-1) )
|--
  (os_inv sg_event_waiters_oc marked )
).

Definition LinklistResumeAll_which_implies_wit_6_split_goal_spatial := 
forall (sg_event_waiters_oc: StableGlobalState) (target: Z) (marked: VarGlobalState) (PreH1 : ((-1) <= INT_MAX)) (PreH2 : ((-1) >= INT_MIN)) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "exstatus")) # Int  |-> (-1))
  **  (event_resume_exstatus_restore sg_event_waiters_oc marked target (-1) )
|--
  (os_inv sg_event_waiters_oc marked )
.

Definition LinklistResumeAll_which_implies_wit_7 := 
(
forall (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (sg_event_waiters_oc: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (marked: VarGlobalState) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH3 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) ,
  (os_inv sg_event_waiters_oc marked )
|--
  EX (task_id: Z) ,
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (0 <= task_id) ” 
  &&  “ (task_id < 65536) ” 
  &&  “ (get_task_with_idnode_success sg_event_waiters_oc marked task_id target ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining marked ) ” 
  &&  “ (os_world_wf sg_event_waiters_oc marked ) ” 
  &&  “ (task_world_wf marked ) ”
  &&  ((&((target)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (event_resume_id_restore sg_event_waiters_oc marked target task_id )
) \/
(
forall (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (sg_event_waiters_oc: StableGlobalState) (current: VarGlobalState) (remaining: (@list Z)) (target: Z) (rest: (@list Z)) (desc: TaskDescriptorAbs) (marked: VarGlobalState) (PreH1 : (remaining = (cons (target) (rest)))) (PreH2 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH3 : (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current)))) ,
  (os_inv sg_event_waiters_oc marked )
|--
  EX (task_id: Z) ,
  “ (remaining = (cons (target) (rest))) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current ) ” 
  &&  “ (marked = (replace_task_desc_map ((update_task_desc_map (target) ((set_task_desc_exstatus (desc) ((-1)))) (((current.(os_tasks) ).(task_desc_map) )))) (current))) ” 
  &&  “ (0 <= task_id) ” 
  &&  “ (task_id < 65536) ” 
  &&  “ (get_task_with_idnode_success sg_event_waiters_oc marked task_id target ) ” 
  &&  “ (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining marked ) ” 
  &&  “ (os_world_wf sg_event_waiters_oc marked ) ” 
  &&  “ (task_world_wf marked ) ”
  &&  ((&((target)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (event_resume_id_restore sg_event_waiters_oc marked target task_id )
).

Definition LinklistResumeAll_which_implies_wit_8 := 
(
forall (sg_event_waiters_oc: StableGlobalState) (target: Z) (marked: VarGlobalState) (task_id: Z) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (event_resume_id_restore sg_event_waiters_oc marked target task_id )
|--
  (os_inv sg_event_waiters_oc marked )
) \/
(
forall (sg_event_waiters_oc: StableGlobalState) (target: Z) (marked: VarGlobalState) (task_id: Z) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (event_resume_id_restore sg_event_waiters_oc marked target task_id )
|--
  (os_inv sg_event_waiters_oc marked )
).

Definition LinklistResumeAll_which_implies_wit_8_split_goal_spatial := 
forall (sg_event_waiters_oc: StableGlobalState) (target: Z) (marked: VarGlobalState) (task_id: Z) ,
  ((&((target)  # "TaskDescriptor" ->ₛ "id" .ₛ "id")) # UShort  |-> task_id)
  **  (event_resume_id_restore sg_event_waiters_oc marked target task_id )
|--
  (os_inv sg_event_waiters_oc marked )
.

Definition LinklistResumeAll_which_implies_wit_9 := 
(
forall (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (sg_event_waiters_oc: StableGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH2 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH3 : (remaining = (@nil Z))) (PreH4 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH5 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (os_inv sg_event_waiters_oc current )
|--
  “ (event_delete_guard id_event_waiters_oc p_event_waiters_oc true current ) ” 
  &&  “ (Crtos_GTrans locked current ) ” 
  &&  “ ( monadesafe_lib.safeExec  (LastSeen (current)) ( MonadErr.ret  (tt)) X_event_waiters_oc ) ”
  &&  (os_inv sg_event_waiters_oc current )
) \/
(
forall (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH2 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH3 : (remaining = (@nil Z))) (PreH4 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH5 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  TT && emp 
|--
  “ ( monadesafe_lib.safeExec  (LastSeen (current)) ( MonadErr.ret  (tt)) X_event_waiters_oc ) ” 
  &&  “ (Crtos_GTrans locked current ) ” 
  &&  “ (event_delete_guard id_event_waiters_oc p_event_waiters_oc true current ) ”
  &&  emp
).

Definition LinklistResumeAll_which_implies_wit_9_split_goal_1 := 
forall (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH2 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH3 : (remaining = (@nil Z))) (PreH4 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH5 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  ( monadesafe_lib.safeExec  (LastSeen (current)) ( MonadErr.ret  (tt)) X_event_waiters_oc )
.

Definition LinklistResumeAll_which_implies_wit_9_split_goal_2 := 
forall (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH2 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH3 : (remaining = (@nil Z))) (PreH4 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH5 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (Crtos_GTrans locked current )
.

Definition LinklistResumeAll_which_implies_wit_9_split_goal_3 := 
forall (X_event_waiters_oc: (unit -> ((VarGlobalState -> Prop) -> Prop))) (p_event_waiters_oc: Z) (id_event_waiters_oc: Z) (before_event_waiters_oc: VarGlobalState) (locked: VarGlobalState) (waiting: (@list Z)) (current: VarGlobalState) (remaining: (@list Z)) (PreH1 : (event_pending_at id_event_waiters_oc p_event_waiters_oc remaining current )) (PreH2 : (event_resume_remaining_effect p_event_waiters_oc waiting locked remaining current )) (PreH3 : (remaining = (@nil Z))) (PreH4 : (event_delete_gap id_event_waiters_oc p_event_waiters_oc false before_event_waiters_oc locked )) (PreH5 : (event_pending_at id_event_waiters_oc p_event_waiters_oc waiting locked )) (PreH6 : ( monadesafe_lib.safeExec  (LastSeen (before_event_waiters_oc)) (abs_event_resume_all (id_event_waiters_oc) (p_event_waiters_oc)) X_event_waiters_oc )) ,
  (event_delete_guard id_event_waiters_oc p_event_waiters_oc true current )
.

Definition KTaskWakeup_derive_semaphore_pending_head_ic_by_wakeup_by_id_ic := 
forall (id_pre: Z) (rest_semaphore_pending_head_ic: (@list (@DL_Node Z))) (task_semaphore_pending_head_ic: Z) (sem_semaphore_pending_head_ic: Z) (before_semaphore_pending_head_ic: VarGlobalState) (sg_semaphore_pending_head_ic: StableGlobalState) ,
  “ (id_pre < 65536) ” 
  &&  “ (get_task_with_idnode_success sg_semaphore_pending_head_ic before_semaphore_pending_head_ic id_pre task_semaphore_pending_head_ic ) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_pending_head_ic before_semaphore_pending_head_ic (cons ((sched_link_node (task_semaphore_pending_head_ic))) (rest_semaphore_pending_head_ic)) ) ”
  &&  (os_inv sg_semaphore_pending_head_ic before_semaphore_pending_head_ic )
|--
EX (sg_wakeup_by_id_ic: StableGlobalState) (before_wakeup_by_id_ic: VarGlobalState) ,
  (“ (id_pre < 65536) ”
  &&  (os_inv sg_wakeup_by_id_ic before_wakeup_by_id_ic ))
  **
  (((EX after_2 desc_2 task retval_2,
  “ (task <> 0) ” 
  &&  “ (get_task_with_idnode_success sg_wakeup_by_id_ic before_wakeup_by_id_ic id_pre task ) ” 
  &&  “ (((before_wakeup_by_id_ic.(os_tasks) ).(task_desc_map) (task)) = (Some (desc_2))) ” 
  &&  “ (((desc_2.(tdSchedMember) ).(tsmStat) ) <> TSK_SUSPEND) ” 
  &&  “ (retval_2 = (-1)) ” 
  &&  “ (after_2 = before_wakeup_by_id_ic) ”
  &&  (os_inv sg_wakeup_by_id_ic after_2 ))
  ||
  (EX after_2 desc_2 task retval_2,
  “ (task <> 0) ” 
  &&  “ (get_task_with_idnode_success sg_wakeup_by_id_ic before_wakeup_by_id_ic id_pre task ) ” 
  &&  “ (((before_wakeup_by_id_ic.(os_tasks) ).(task_desc_map) (task)) = (Some (desc_2))) ” 
  &&  “ (((desc_2.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (retval_2 = 0) ” 
  &&  “ (ktask_wakeup_step task desc_2 before_wakeup_by_id_ic after_2 ) ”
  &&  (os_inv sg_wakeup_by_id_ic after_2 )))
  -*
  (EX after desc retval,
  “ (retval = 0) ” 
  &&  “ (task_semaphore_pending_head_ic <> 0) ” 
  &&  “ (((before_semaphore_pending_head_ic.(os_tasks) ).(task_desc_map) (task_semaphore_pending_head_ic)) = (Some (desc))) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (wakeup_semaphore_head sem_semaphore_pending_head_ic task_semaphore_pending_head_ic desc before_semaphore_pending_head_ic after ) ” 
  &&  “ (semaphore_pending_nodes sem_semaphore_pending_head_ic after rest_semaphore_pending_head_ic ) ”
  &&  (os_inv sg_semaphore_pending_head_ic after )))
.

Definition KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic := 
forall (id_pre: Z) (before_detached_sched_null_delay: VarGlobalState) (sg_detached_sched_null_delay: StableGlobalState) ,
  “ (id_pre < 65536) ” 
  &&  “ (ktask_wakeup_detached_null_condition sg_detached_sched_null_delay before_detached_sched_null_delay id_pre ) ”
  &&  (os_inv sg_detached_sched_null_delay before_detached_sched_null_delay )
|--
EX (sg_wakeup_by_id_ic: StableGlobalState) (before_wakeup_by_id_ic: VarGlobalState) ,
  (“ (id_pre < 65536) ”
  &&  (os_inv sg_wakeup_by_id_ic before_wakeup_by_id_ic ))
  **
  (((EX after_2 desc_2 task_2 retval_2,
  “ (task_2 <> 0) ” 
  &&  “ (get_task_with_idnode_success sg_wakeup_by_id_ic before_wakeup_by_id_ic id_pre task_2 ) ” 
  &&  “ (((before_wakeup_by_id_ic.(os_tasks) ).(task_desc_map) (task_2)) = (Some (desc_2))) ” 
  &&  “ (((desc_2.(tdSchedMember) ).(tsmStat) ) <> TSK_SUSPEND) ” 
  &&  “ (retval_2 = (-1)) ” 
  &&  “ (after_2 = before_wakeup_by_id_ic) ”
  &&  (os_inv sg_wakeup_by_id_ic after_2 ))
  ||
  (EX after_2 desc_2 task_2 retval_2,
  “ (task_2 <> 0) ” 
  &&  “ (get_task_with_idnode_success sg_wakeup_by_id_ic before_wakeup_by_id_ic id_pre task_2 ) ” 
  &&  “ (((before_wakeup_by_id_ic.(os_tasks) ).(task_desc_map) (task_2)) = (Some (desc_2))) ” 
  &&  “ (((desc_2.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (retval_2 = 0) ” 
  &&  “ (ktask_wakeup_step task_2 desc_2 before_wakeup_by_id_ic after_2 ) ”
  &&  (os_inv sg_wakeup_by_id_ic after_2 )))
  -*
  ((EX after desc task retval,
  “ (task <> 0) ” 
  &&  “ (get_task_with_idnode_success sg_detached_sched_null_delay before_detached_sched_null_delay id_pre task ) ” 
  &&  “ (((before_detached_sched_null_delay.(os_tasks) ).(task_desc_map) (task)) = (Some (desc))) ” 
  &&  “ ((desc.(tdDelay) ) = 0) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) <> TSK_SUSPEND) ” 
  &&  “ (retval = (-1)) ” 
  &&  “ (after = before_detached_sched_null_delay) ”
  &&  (os_inv sg_detached_sched_null_delay after ))
  ||
  (EX after desc task retval,
  “ (task <> 0) ” 
  &&  “ (get_task_with_idnode_success sg_detached_sched_null_delay before_detached_sched_null_delay id_pre task ) ” 
  &&  “ (((before_detached_sched_null_delay.(os_tasks) ).(task_desc_map) (task)) = (Some (desc))) ” 
  &&  “ ((desc.(tdDelay) ) = 0) ” 
  &&  “ (((desc.(tdSchedMember) ).(tsmStat) ) = TSK_SUSPEND) ” 
  &&  “ (retval = 0) ” 
  &&  “ (ktask_wakeup_detached_null_step task desc before_detached_sched_null_delay after ) ”
  &&  (os_inv sg_detached_sched_null_delay after ))))
.

Module Type VC_Correct.


Axiom proof_of_LinklistResumeAll_safety_wit_1 : LinklistResumeAll_safety_wit_1.
Axiom proof_of_LinklistResumeAll_safety_wit_2 : LinklistResumeAll_safety_wit_2.
Axiom proof_of_LinklistResumeAll_safety_wit_3 : LinklistResumeAll_safety_wit_3.
Axiom proof_of_LinklistResumeAll_safety_wit_4 : LinklistResumeAll_safety_wit_4.
Axiom proof_of_LinklistResumeAll_safety_wit_5 : LinklistResumeAll_safety_wit_5.
Axiom proof_of_LinklistResumeAll_safety_wit_6 : LinklistResumeAll_safety_wit_6.
Axiom proof_of_LinklistResumeAll_safety_wit_7 : LinklistResumeAll_safety_wit_7.
Axiom proof_of_LinklistResumeAll_safety_wit_8 : LinklistResumeAll_safety_wit_8.
Axiom proof_of_LinklistResumeAll_safety_wit_9 : LinklistResumeAll_safety_wit_9.
Axiom proof_of_LinklistResumeAll_safety_wit_10 : LinklistResumeAll_safety_wit_10.
Axiom proof_of_LinklistResumeAll_safety_wit_11 : LinklistResumeAll_safety_wit_11.
Axiom proof_of_LinklistResumeAll_entail_wit_1 : LinklistResumeAll_entail_wit_1.
Axiom proof_of_LinklistResumeAll_entail_wit_2 : LinklistResumeAll_entail_wit_2.
Axiom proof_of_LinklistResumeAll_entail_wit_3 : LinklistResumeAll_entail_wit_3.
Axiom proof_of_LinklistResumeAll_entail_wit_4_1 : LinklistResumeAll_entail_wit_4_1.
Axiom proof_of_LinklistResumeAll_entail_wit_4_2 : LinklistResumeAll_entail_wit_4_2.
Axiom proof_of_LinklistResumeAll_return_wit_1 : LinklistResumeAll_return_wit_1.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_1_pure : LinklistResumeAll_partial_solve_wit_1_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_1 : LinklistResumeAll_partial_solve_wit_1.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_2_pure : LinklistResumeAll_partial_solve_wit_2_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_2 : LinklistResumeAll_partial_solve_wit_2.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_3_pure : LinklistResumeAll_partial_solve_wit_3_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_3 : LinklistResumeAll_partial_solve_wit_3.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_4 : LinklistResumeAll_partial_solve_wit_4.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_5 : LinklistResumeAll_partial_solve_wit_5.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_6_pure : LinklistResumeAll_partial_solve_wit_6_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_6 : LinklistResumeAll_partial_solve_wit_6.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_7_pure : LinklistResumeAll_partial_solve_wit_7_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_7 : LinklistResumeAll_partial_solve_wit_7.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_8_pure : LinklistResumeAll_partial_solve_wit_8_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_8 : LinklistResumeAll_partial_solve_wit_8.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_9 : LinklistResumeAll_partial_solve_wit_9.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_10 : LinklistResumeAll_partial_solve_wit_10.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_11_pure : LinklistResumeAll_partial_solve_wit_11_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_11 : LinklistResumeAll_partial_solve_wit_11.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_12 : LinklistResumeAll_partial_solve_wit_12.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_13 : LinklistResumeAll_partial_solve_wit_13.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_14_pure : LinklistResumeAll_partial_solve_wit_14_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_14 : LinklistResumeAll_partial_solve_wit_14.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_15_pure : LinklistResumeAll_partial_solve_wit_15_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_15 : LinklistResumeAll_partial_solve_wit_15.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_16_pure : LinklistResumeAll_partial_solve_wit_16_pure.
Axiom proof_of_LinklistResumeAll_partial_solve_wit_16 : LinklistResumeAll_partial_solve_wit_16.
Axiom proof_of_LinklistResumeAll_which_implies_wit_1 : LinklistResumeAll_which_implies_wit_1.
Axiom proof_of_LinklistResumeAll_which_implies_wit_2 : LinklistResumeAll_which_implies_wit_2.
Axiom proof_of_LinklistResumeAll_which_implies_wit_3 : LinklistResumeAll_which_implies_wit_3.
Axiom proof_of_LinklistResumeAll_which_implies_wit_4 : LinklistResumeAll_which_implies_wit_4.
Axiom proof_of_LinklistResumeAll_which_implies_wit_5 : LinklistResumeAll_which_implies_wit_5.
Axiom proof_of_LinklistResumeAll_which_implies_wit_6 : LinklistResumeAll_which_implies_wit_6.
Axiom proof_of_LinklistResumeAll_which_implies_wit_7 : LinklistResumeAll_which_implies_wit_7.
Axiom proof_of_LinklistResumeAll_which_implies_wit_8 : LinklistResumeAll_which_implies_wit_8.
Axiom proof_of_LinklistResumeAll_which_implies_wit_9 : LinklistResumeAll_which_implies_wit_9.
Axiom proof_of_KTaskWakeup_derive_semaphore_pending_head_ic_by_wakeup_by_id_ic : KTaskWakeup_derive_semaphore_pending_head_ic_by_wakeup_by_id_ic.
Axiom proof_of_KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic : KTaskWakeup_derive_detached_sched_null_delay_by_wakeup_by_id_ic.

End VC_Correct.
