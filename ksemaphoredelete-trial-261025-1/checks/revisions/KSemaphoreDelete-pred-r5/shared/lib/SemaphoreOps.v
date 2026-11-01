Require Import Coq.ZArith.ZArith Coq.Lists.List.
From SimpleC.SL Require Import Mem.
Require Export CRTOS_Verify.lib.SemaphoreState.
Import ListNotations.
Local Open Scope Z_scope.

(** int32 入口的负值分支先在调用者处理；非负值传给 uint16 形参时按
    65536 取模。不能把所有大于 ID_MAX 的 int32 输入直接当作无效 ID。 *)
Definition semaphore_query_id (id : Z) : Z := id mod 65536.

(** 只更新这个已发布对象的等待序列；基址、ID、value 和其他对象均保持。
    地址用于追踪同一个仍存活的对象；不声称跨释放后的地址永久唯一。 *)
Definition semaphore_set_pending (p : addr) (pending : list addr)
    (sems : SemaphoreState) : SemaphoreState :=
  map (fun s => if Z.eq_dec s.(semaphore_addr) p then
    {| semaphore_addr := s.(semaphore_addr); semaphore_id := s.(semaphore_id);
       semaphore_value := s.(semaphore_value); semaphore_pending_addrs := pending |}
    else s) sems.

(** 已注销的对象从管理顺序中移除，其余对象次序不变。
    此纯更新不释放内存；原对象的私有字段资源必须由调用者带到 x_free。 *)
Definition semaphore_unpublish (p : addr) (sems : SemaphoreState) : SemaphoreState :=
  filter (fun s => negb (Z.eqb s.(semaphore_addr) p)) sems.
