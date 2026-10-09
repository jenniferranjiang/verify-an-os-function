Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Strings.String.
From SimpleC.SL Require Import Mem CNotation.
Require Import Logic.LogicGenerator.demo932.Interface.

Require Import CRTOS_Verify.sem.SemaphorePure.
Require Import CRTOS_Verify.sem.SemaphoreProtocol.
Require Import CRTOS_Verify.sem.SemaphoreRep.
Require Import CRTOS_Verify.sem.CrtosOSRep.

Import ListNotations.
Local Open Scope Z_scope.
Local Open Scope string.
Local Open Scope sac.

(** Cortex-M3 的 PRIMASK 保存值只能是 0 或 1。 *)
Definition semaphore_irq_handler_ok (handler : Z) : Prop :=
  handler = 0 \/ handler = 1.

Definition semaphore_handler_stack_ok (handlers : list Z) : Prop :=
  Forall semaphore_irq_handler_ok handlers /\ Zlength handlers <= 65535.

(**
  [KTaskOsAssignLockNest] 是 [CriticalArea.c] 非 SMP 分支的 uint16 嵌套计数；
  切片外置该 TU-local static symbol，本谓词拥有其两字节并关联 ghost stack。
*)
Definition store_semaphore_critical_nest (handlers : list Z) : Assertion :=
  “ semaphore_handler_stack_ok handlers ” &&
  &("KTaskOsAssignLockNest") # UShort |-> Zlength handlers.

(**
  临界区外 view 组合空 nested-STS view 与值为零的具体计数器；semaphore heap
  invariant 仅由 lock contract 打开，不在这里重复拥有。
*)
Definition SemaphoreCriticalOutside
    (stable : CrtosOSStable) (world : CrtosOSWorld) : Assertion :=
  SemaphoreOutsideCritical stable world **
  store_semaphore_critical_nest nil.

(**
  持有 view 把保存的 IRQ handler 记在栈首，并拥有匹配的具体计数器；
  [semaphore_inv] 仍是独立空间合取，使嵌套 lock 可 frame 已打开的共享 heap。
*)
Definition SemaphoreCriticalHeld
    (handler : Z) (handlers : list Z)
    (stable : CrtosOSStable) (world : CrtosOSWorld) : Assertion :=
  SemaphoreInsideCritical handler handlers stable world **
  store_semaphore_critical_nest (handler :: handlers).

(** 只有计数器尚未达到 uint16 上限时，Lock 才可递增嵌套层数。 *)
Definition semaphore_critical_enterable (handlers : list Z) : Prop :=
  semaphore_handler_stack_ok handlers /\ Zlength handlers < 65535.

(** Unlock 必须恢复从 ghost stack 栈首弹出的同一 handler。 *)
Definition semaphore_critical_exit_ok
    (handler : Z) (handlers : list Z) : Prop :=
  semaphore_handler_stack_ok (handler :: handlers).
