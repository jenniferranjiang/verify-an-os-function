Require Import Coq.ZArith.ZArith Coq.Strings.String.
From SimpleC.SL Require Import Mem CArch CNotation.
Module Import ObjectWaitCNotation := CNotationSig Arch32.
Local Open Scope Z_scope.
Local Open Scope string.

(** Physical address of the embedded wait-list link.  This helper owns no
    descriptor memory and does not reintroduce a task state or predicate. *)
Definition object_wait_link_of (owner : addr) : addr :=
  &(owner # "TaskDescriptor" ->ₛ
    "task_dync_sched_member" .ₛ "sched_link").
