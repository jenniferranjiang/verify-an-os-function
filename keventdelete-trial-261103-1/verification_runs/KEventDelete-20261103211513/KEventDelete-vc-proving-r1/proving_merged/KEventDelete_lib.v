From Coq Require Import ZArith List.
Import ListNotations.
Local Open Scope Z_scope.

Require Import CRTOS_Verify.lib.KEventDelete.
From MonadLib.MonadErr Require Import MonadErrHoare.
Import MonadErr.

(** Lookup returns a pointer, while the public API returns unit.  Its
    continuation preserves the remaining delete operation on a hit. *)
Definition kevent_delete_lookup_cont (id : Z)
    (X : unit -> (VarGlobalState -> Prop) -> Prop)
    : Z -> (VarGlobalState -> Prop) -> Prop :=
  fun p states => weakestpre
    (if Z.eqb p 0 then MonadErr.ret tt else abs_event_delete_at id p) X states.
