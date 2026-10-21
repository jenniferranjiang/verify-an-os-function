Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Strings.String.
From SimpleC.SL Require Import Mem CNotation.
Require Import Logic.LogicGenerator.demo932.Interface.

Require Import CRTOS_Verify.mutex.MutexPure.
Require Import CRTOS_Verify.mutex.MutexProtocol.
Require Import CRTOS_Verify.mutex.MutexRep.

Import ListNotations.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

(** Cortex-M3 的 PRIMASK 保存值只能为 0 或 1。 *)
Definition mutex_irq_handler_ok (handler : Z) : Prop :=
  handler = 0 \/ handler = 1.

Definition mutex_handler_stack_ok (handlers : list Z) : Prop :=
  Forall mutex_irq_handler_ok handlers /\ Zlength handlers <= 65535.

(**
  非 SMP [CriticalArea.c] 的 TU-local [KTaskOsAssignLockNest] 是 uint16；
  单函数切片将它外部化为同名全局。本谓词独占这两个字节并把值关联到
  ghost handler 栈深度，不拥有硬件 PRIMASK 寄存器。
*)
Definition store_mutex_critical_nest (handlers : list Z) : Assertion :=
  “ mutex_handler_stack_ok handlers ” &&
  &("KTaskOsAssignLockNest") # UShort |-> Zlength handlers.

(** 临界区外 view：空 STS 栈与具体 nesting counter 0。 *)
Definition MutexCriticalOutside
    (stable : MutexStable) (state : MutexState) : Assertion :=
  MutexOutsideCritical stable state ** store_mutex_critical_nest nil.

(**
  临界区内 view：handler 是本层须恢复的 PRIMASK，heap invariant 仍作为
  独立 conjunct 交给 caller，nested lock 不复制共享 heap ownership。
*)
Definition MutexCriticalHeld
    (handler : Z) (handlers : list Z)
    (stable : MutexStable) (state : MutexState) : Assertion :=
  MutexInsideCritical handler handlers stable state **
  store_mutex_critical_nest (handler :: handlers).

Definition mutex_critical_enterable (handlers : list Z) : Prop :=
  mutex_handler_stack_ok handlers /\ Zlength handlers < 65535.

Definition mutex_critical_exit_ok (handler : Z) (handlers : list Z) : Prop :=
  mutex_handler_stack_ok (handler :: handlers).
