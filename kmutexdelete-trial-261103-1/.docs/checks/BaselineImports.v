(** 仅检查本次源码分析引用的既有接口；不是 KMutexDelete 的设计或证明。 *)
Require Import CRTOS_Verify.lib.CrtosInv.
Require Import CRTOS_Verify.lib.MutexOps.
Require Import CRTOS_Verify.lib.KTaskWakeup.
Check MutexAbs.
Check MutexRaw.
Check mutex_inv.
Check mutex_remove_waiter_step.
Check ktask_wakeup_step.
Check os_inv.
Check OutsideCritical.
Check task_atomic_cmd.
