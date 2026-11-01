Require Export CRTOS_Verify.lib.MutexState CRTOS_Verify.lib.RemoveFound.
Require Import Coq.Lists.List.
From SimpleC.SL Require Import Mem.

(** 唤醒从Mutex等待链摘除目标任务，保留管理顺序、ID、holder及所有标量。
    holder转移属于_MutexAbandon的前一步写入，不属于KTaskWakeup。 *)
Definition mutex_remove_waiter_step (task : addr)
    (before after : MutexState) : Prop :=
  Forall2 (fun old new =>
    new.(mutex_addr) = old.(mutex_addr) /\
    new.(mutex_id) = old.(mutex_id) /\
    new.(mutex_value) = old.(mutex_value) /\
    new.(mutex_recursive_count) = old.(mutex_recursive_count) /\
    new.(mutex_original_priority) = old.(mutex_original_priority) /\
    new.(mutex_holder) = old.(mutex_holder) /\
    remove_found_prop task old.(mutex_pending_addrs) new.(mutex_pending_addrs))
    before after.

