Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem SeparationLogic.
Require Import Logic.LogicGenerator.demo932.Interface.
Require Export CRTOS_Verify.lib.delay.DelayInv.
Import ListNotations DLL.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

(** 同步 VRTOS KTaskSchedDelayState；保留本工程共享模块路径。 *)
Inductive vDelayView : Type :=
  | vDelayNull
  | vDelayInactive
      (delay_ptr : addr)
      (delay_abs : TaskDelayAbs)
  | vDelayActive
      (delay_ptr : addr)
      (delay_abs_before : TaskDelayAbs)
      (prefix suffix : list (DL_Node TaskDelayAbs)).

Definition delay_mark_inactive
    (info : TaskDelayAbs) : TaskDelayAbs :=
  mkTaskDelayAbs
    info.(tdTaskPtr)
    info.(tdTicks)
    TASK_DELAY_INACTIVE_VALUE.

Definition store_ktask_unset_delay_pre
    (task : addr)
    (view : vDelayView) : Assertion :=
  let slot :=
    &(task # "TaskDescriptor" ->ₛ
      "task_dync_sched_member" .ₛ "delay") in
  match view with
  | vDelayNull =>
      slot # Ptr |-> 0
  | vDelayInactive delay_ptr delay_abs =>
      “ delay_ptr <> 0 /\
        addr_aligned delay_ptr ALIGN_SIZE /\
        delay_abs.(tdStatus) = TASK_DELAY_INACTIVE_VALUE ” &&
      slot # Ptr |-> delay_ptr **
      store_delay_info
        (&(delay_ptr # "Delay" ->ₛ "link")) delay_abs
  | vDelayActive delay_ptr delay_abs_before prefix suffix =>
      let link := &(delay_ptr # "Delay" ->ₛ "link") in
      let node := Build_DL_Node delay_abs_before link in
      “ delay_ptr <> 0 /\
        addr_aligned delay_ptr ALIGN_SIZE /\
        delay_abs_before.(tdTaskPtr) = task /\
        delay_nodes_wf (prefix ++ node :: suffix) ” &&
      slot # Ptr |-> delay_ptr **
      store_dll
        store_delay_info
        &("xiaoshan_delay_head")
        (prefix ++ node :: suffix)
  end.

Definition store_ktask_unset_delay_post
    (task : addr)
    (view : vDelayView) : Assertion :=
  let slot :=
    &(task # "TaskDescriptor" ->ₛ
      "task_dync_sched_member" .ₛ "delay") in
  match view with
  | vDelayNull =>
      slot # Ptr |-> 0
  | vDelayInactive delay_ptr delay_abs =>
      “ delay_abs.(tdStatus) = TASK_DELAY_INACTIVE_VALUE ” &&
      slot # Ptr |-> delay_ptr **
      store_delay_info
        (&(delay_ptr # "Delay" ->ₛ "link")) delay_abs
  | vDelayActive delay_ptr delay_abs_before prefix suffix =>
      let link := &(delay_ptr # "Delay" ->ₛ "link") in
      “ delay_nodes_wf (prefix ++ suffix) ” &&
      slot # Ptr |-> delay_ptr **
      store_dll
        store_delay_info
        &("xiaoshan_delay_head")
        (prefix ++ suffix) **
      store_delay_info link (delay_mark_inactive delay_abs_before) **
      store_node_self_linked link
  end.

Definition delay_view_ptr (view : vDelayView) : addr :=
  match view with
  | vDelayNull => 0
  | vDelayInactive delay_ptr _ => delay_ptr
  | vDelayActive delay_ptr _ _ _ => delay_ptr
  end.

Definition store_ktask_unset_delay_external_pre
    (task : addr)
    (view : vDelayView) : Assertion :=
  match view with
  | vDelayNull => emp
  | vDelayInactive delay_ptr delay_abs =>
      “ delay_ptr <> 0 /\
        addr_aligned delay_ptr ALIGN_SIZE /\
        delay_abs.(tdStatus) = TASK_DELAY_INACTIVE_VALUE ” &&
      store_delay_info
        (&(delay_ptr # "Delay" ->ₛ "link")) delay_abs
  | vDelayActive delay_ptr delay_abs_before prefix suffix =>
      let link := &(delay_ptr # "Delay" ->ₛ "link") in
      let node := Build_DL_Node delay_abs_before link in
      “ delay_ptr <> 0 /\
        addr_aligned delay_ptr ALIGN_SIZE /\
        delay_abs_before.(tdTaskPtr) = task /\
        delay_nodes_wf (prefix ++ node :: suffix) ” &&
      store_dll
        store_delay_info
        &("xiaoshan_delay_head")
        (prefix ++ node :: suffix)
  end.

Definition store_ktask_unset_delay_external_post
    (task : addr)
    (view : vDelayView) : Assertion :=
  match view with
  | vDelayNull => emp
  | vDelayInactive delay_ptr delay_abs =>
      “ delay_abs.(tdStatus) = TASK_DELAY_INACTIVE_VALUE ” &&
      store_delay_info
        (&(delay_ptr # "Delay" ->ₛ "link")) delay_abs
  | vDelayActive delay_ptr delay_abs_before prefix suffix =>
      let link := &(delay_ptr # "Delay" ->ₛ "link") in
      “ delay_nodes_wf (prefix ++ suffix) ” &&
      store_dll
        store_delay_info
        &("xiaoshan_delay_head")
        (prefix ++ suffix) **
      store_delay_info link (delay_mark_inactive delay_abs_before) **
      store_node_self_linked link
  end.
