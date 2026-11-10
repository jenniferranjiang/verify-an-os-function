Require Import Coq.ZArith.ZArith.
Require Import Coq.Strings.String.
Require Import Coq.Lists.List.
Import ListNotations.
From SimpleC.SL Require Import Mem IntLib CArch CNotation.
Module Import CrtosCNotation := CNotationSig Arch32.
Require Import Logic.LogicGenerator.demo932.Interface.

Local Open Scope Z_scope.
Local Open Scope string.

(** ABI facts retained by the task-free shared library.  They are pure layout
    propositions and grant no memory ownership. *)
Definition ALIGN_SIZE : Z := 4.

Definition addr_aligned (p alignment : Z) : Prop :=
  p mod alignment = 0.

Definition ID_NODE_MEM_SIZE : Z := 12.
Definition MUTEX_MEM_SIZE : Z := 36.
Definition IRQ_DESC_SIZE : Z := 8.
Definition ISR_DONE_SIZE : Z := 48.
Definition ISR_MANAGER_SIZE : Z := 536.

Definition mutex_field_offset_ok (p : addr) : Prop :=
  &(p # "Mutex" ->ₛ "id") = p /\
  &(p # "IdNode" ->ₛ "id") = p /\
  &(p # "IdNode" ->ₛ "link") = p + 4 /\
  &(p # "Mutex" ->ₛ "val") = p + 12 /\
  &(p # "Mutex" ->ₛ "recursive_cnt") = p + 14 /\
  &(p # "Mutex" ->ₛ "origin_prio") = p + 15 /\
  &(p # "Mutex" ->ₛ "holder") = p + 16 /\
  &(p # "Mutex" ->ₛ "pend_list") = p + 20 /\
  &(p # "Mutex" ->ₛ "link") = p + 28 /\
  (forall node, In node [p + 4; p + 20; p + 28] ->
    &(node # "SysDoubleLinklistNode" ->ₛ "node_next") = node /\
    &(node # "SysDoubleLinklistNode" ->ₛ "node_prev") = node + 4).

Definition irq_desc_field_offset_ok (p : addr) : Prop :=
  &(p # "IrqDesc" ->ₛ "handler") = p /\
  &(p # "IrqDesc" ->ₛ "param") = p + 4.

Definition isr_done_field_offset_ok (p : addr) : Prop :=
  &(p # "IsrDone" ->ₛ "isInIsr") = p /\
  &(p # "IsrDone" ->ₛ "registerIrq") = p + 4 /\
  &(p # "IsrDone" ->ₛ "freeIrq") = p + 8 /\
  &(p # "IsrDone" ->ₛ "enableIrq") = p + 12 /\
  &(p # "IsrDone" ->ₛ "disableIrq") = p + 16 /\
  &(p # "IsrDone" ->ₛ "handleIrq") = p + 20 /\
  &(p # "IsrDone" ->ₛ "getCounter") = p + 24 /\
  &(p # "IsrDone" ->ₛ "incCounter") = p + 28 /\
  &(p # "IsrDone" ->ₛ "decCounter") = p + 32 /\
  &(p # "IsrDone" ->ₛ "getSwitchTrigerFlag") = p + 36 /\
  &(p # "IsrDone" ->ₛ "setSwitchTrigerFlag") = p + 40 /\
  &(p # "IsrDone" ->ₛ "clearSwitchTrigerFlag") = p + 44.

Definition isr_manager_field_offset_ok (p : addr) : Prop :=
  &(p # "InterruptServiceRoutines" ->ₛ "isr_count") = p /\
  &(p # "InterruptServiceRoutines" ->ₛ "isr_switch_trigger_flag") = p + 2 /\
  &(p # "InterruptServiceRoutines" ->ₛ "irq_table") = p + 4 /\
  &(p # "InterruptServiceRoutines" ->ₛ "done") = p + 532.

Axiom id_node_size_axiom : sizeof("IdNode") = ID_NODE_MEM_SIZE.

Axiom mutex_size_axiom : sizeof("Mutex") = MUTEX_MEM_SIZE.
Axiom mutex_field_offset_axiom :
  forall p, addr_aligned p ALIGN_SIZE -> mutex_field_offset_ok p.

Axiom irq_desc_size_axiom : sizeof("IrqDesc") = IRQ_DESC_SIZE.
Axiom irq_desc_field_offset_axiom :
  forall p, irq_desc_field_offset_ok p.

Axiom isr_done_size_axiom : sizeof("IsrDone") = ISR_DONE_SIZE.
Axiom isr_done_field_offset_axiom :
  forall p, isr_done_field_offset_ok p.

Axiom isr_manager_size_axiom :
  sizeof("InterruptServiceRoutines") = ISR_MANAGER_SIZE.
Axiom isr_manager_field_offset_axiom :
  forall p, isr_manager_field_offset_ok p.
