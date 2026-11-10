Require Export CRTOS_Verify.lib.event.EventState CRTOS_Verify.lib.common.RemoveFound.
Require Import Coq.Lists.List Coq.ZArith.ZArith.
From SimpleC.SL Require Import Mem.

(** 从事件等待链摘除目标 owner，保留管理顺序、ID、options 和 events。
    Trigger 的位清除或 Process 的消费属于各自先前/后续操作。 *)
Definition event_remove_waiter_step (owner : addr)
    (before after : EventState) : Prop :=
  Forall2 (fun old new =>
    new.(event_addr) = old.(event_addr) /\
    new.(event_id) = old.(event_id) /\
    new.(event_options) = old.(event_options) /\
    new.(event_events) = old.(event_events) /\
    remove_found_prop owner old.(event_pending_addrs) new.(event_pending_addrs))
    before after.

Local Open Scope Z_scope.

(** 只更新给定 Event 基址的 pending 序列，保留其 ID、位域值及其他对象。
    地址定位适用于当前存活期，不把被释放后复用的地址认作同一对象。 *)
Definition event_set_pending (p : addr) (pending : list addr)
    (events : EventState) : EventState :=
  map (fun e => if Z.eq_dec e.(event_addr) p then
    {| event_addr := e.(event_addr); event_id := e.(event_id);
       event_options := e.(event_options); event_events := e.(event_events);
       event_pending_addrs := pending |}
    else e) events.

(** 注销时从管理顺序删除对象，其余对象及顺序保持。该纯操作不释放内存；
    调用者须另行获得 EventRetired 的完整私有资源，才可传给 x_free。 *)
Definition event_unpublish (p : addr) (events : EventState) : EventState :=
  filter (fun e => negb (Z.eqb e.(event_addr) p)) events.
