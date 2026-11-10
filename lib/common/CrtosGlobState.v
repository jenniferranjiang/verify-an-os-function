(** Task-free global state used by the shared object and list libraries. *)
Require Import Coq.ZArith.ZArith Coq.Lists.List Coq.Strings.String.
From SimpleC.SL Require Import Mem CNotation.
Require Export CRTOS_Verify.lib.isr.IsrState.
Require Export CRTOS_Verify.lib.semaphore.SemaphoreState.
Require Export CRTOS_Verify.lib.mutex.MutexState.
Require Export CRTOS_Verify.lib.event.EventState.
Import CrtosCNotation ListNotations.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope list.

(** Only stable contexts owned by the retained non-task modules remain. *)
Record StableGlobalState : Type := {
  os_event_stable : EventStable;
  os_mutex_stable : MutexStable;
  os_semaphore_stable : SemaphoreStable;
  os_isr_stable : IsrStable
}.

(** Task, scheduler, delay, tick, zombie and exstatus state were removed. *)
Record VarGlobalState : Type := Build_VarGlobalState {
  os_events : EventState;
  os_mutexes : MutexState;
  os_semaphores : SemaphoreState;
  os_isr : IsrAbs
}.

Definition os_global_context (sg : StableGlobalState) : Prop :=
  event_context sg.(os_event_stable) /\
  mutex_context sg.(os_mutex_stable) /\
  semaphore_context sg.(os_semaphore_stable) /\
  IsrGlobalContext sg.(os_isr_stable).

Definition replace_semaphores
    (sems : SemaphoreState) (st : VarGlobalState) : VarGlobalState :=
  {| os_events := st.(os_events);
     os_mutexes := st.(os_mutexes);
     os_semaphores := sems;
     os_isr := st.(os_isr) |}.

Definition replace_mutexes
    (mutexes : MutexState) (st : VarGlobalState) : VarGlobalState :=
  {| os_events := st.(os_events);
     os_mutexes := mutexes;
     os_semaphores := st.(os_semaphores);
     os_isr := st.(os_isr) |}.

Definition replace_events
    (events : EventState) (st : VarGlobalState) : VarGlobalState :=
  {| os_events := events;
     os_mutexes := st.(os_mutexes);
     os_semaphores := st.(os_semaphores);
     os_isr := st.(os_isr) |}.
