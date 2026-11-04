Require Export CRTOS_Verify.lib.EventState CRTOS_Verify.lib.RemoveFound.
Require Import Coq.Lists.List.
From SimpleC.SL Require Import Mem.

(** KTaskWakeup 只从事件等待链摘除目标任务，保留管理顺序、ID、options
    和 events。Trigger 的位清除或 Process 的消费属于各自先前/后续操作。
    本关系不拥有任务字段，不宣称整个事件模块已获实现证明。 *)
Definition event_remove_waiter_step (task : addr)
    (before after : EventState) : Prop :=
  Forall2 (fun old new =>
    new.(event_addr) = old.(event_addr) /\
    new.(event_id) = old.(event_id) /\
    new.(event_options) = old.(event_options) /\
    new.(event_events) = old.(event_events) /\
    remove_found_prop task old.(event_pending_addrs) new.(event_pending_addrs))
    before after.
